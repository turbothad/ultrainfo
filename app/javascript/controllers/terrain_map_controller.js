import { Controller } from "@hotwired/stimulus"
import * as THREE from "three"
import { OrbitControls } from "three/addons/controls/OrbitControls.js"

const TERRAIN_SIZE = 60
const MARKER_RADIUS = 0.34

export default class extends Controller {
  static values = { url: String, drive: Boolean }
  static targets = ["canvas", "status", "detail"]

  connect() {
    this.layers = {}
    this.stationMeshes = []
    this.raycaster = new THREE.Raycaster()
    this.pointer = new THREE.Vector2()
    this.#initialize()
  }

  async #initialize() {
    if (this.initialized) return
    this.initialized = true
    try {
      const data = await fetch(this.urlValue).then((response) => response.json())
      const terrainPath = data.terrain_artifacts?.path
      if (!terrainPath) throw new Error("Terrain artifact path is missing")

      const terrain = await fetch(terrainPath).then((response) => response.json())
      this.dataPayload = data
      this.terrainPayload = terrain
      this.#buildScene()
      this.#buildTerrain(terrain)
      this.#buildCourse(data.course || [])
      this.#buildDrive(data.crew_route?.geometry || [])
      this.#buildStations(data.stations || [])
      this.#setStatus(`${terrain.grid.size}x${terrain.grid.size} DEM / ${terrain.grid.min_ft}-${terrain.grid.max_ft} ft / ${terrain.source.label}`)
      this.#animate()
    } catch (error) {
      this.#setStatus(`Terrain unavailable: ${error.message}`)
    }
  }

  disconnect() {
    cancelAnimationFrame(this.frame)
    this.resizeObserver?.disconnect()
    this.renderer?.domElement.removeEventListener("pointerdown", this.onPointerDown)
    this.controls?.dispose()
    this.renderer?.dispose()
    this.canvasTarget.replaceChildren()
  }

  toggleCourse(event) {
    if (this.layers.course) this.layers.course.visible = event.target.checked
  }

  toggleDrive(event) {
    if (this.layers.drive) this.layers.drive.visible = event.target.checked
  }

  toggleStations(event) {
    if (this.layers.stations) this.layers.stations.visible = event.target.checked
  }

  #buildScene() {
    const width = this.canvasTarget.clientWidth || 900
    const height = this.canvasTarget.clientHeight || 540

    this.scene = new THREE.Scene()
    this.scene.background = new THREE.Color("#123826")
    this.scene.fog = new THREE.Fog("#123826", 58, 96)

    this.camera = new THREE.PerspectiveCamera(43, width / height, 0.1, 160)
    this.camera.position.set(-29, 24, 32)

    this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false })
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    this.renderer.setSize(width, height)
    this.renderer.outputColorSpace = THREE.SRGBColorSpace
    this.canvasTarget.replaceChildren(this.renderer.domElement)

    this.controls = new OrbitControls(this.camera, this.renderer.domElement)
    this.controls.target.set(0, 1.5, 0)
    this.controls.enableDamping = true
    this.controls.dampingFactor = 0.08
    this.controls.minDistance = 12
    this.controls.maxDistance = 88
    this.controls.maxPolarAngle = Math.PI * 0.48
    this.controls.update()

    const ambient = new THREE.HemisphereLight("#dcead6", "#173223", 2.1)
    this.scene.add(ambient)

    const sun = new THREE.DirectionalLight("#fff2dc", 3.2)
    sun.position.set(-18, 30, 26)
    this.scene.add(sun)

    this.onPointerDown = (event) => this.#selectStation(event)
    this.renderer.domElement.addEventListener("pointerdown", this.onPointerDown)

    this.resizeObserver = new ResizeObserver(() => this.#resize())
    this.resizeObserver.observe(this.canvasTarget)
  }

  #buildTerrain(terrain) {
    const { size, elevations_ft: elevations, min_ft: minFt, max_ft: maxFt } = terrain.grid
    const span = Math.max(maxFt - minFt, 1)
    const positions = []
    const colors = []
    const indices = []

    for (let row = 0; row < size; row++) {
      for (let col = 0; col < size; col++) {
        const ft = elevations[row * size + col]
        const x = (col / (size - 1) - 0.5) * TERRAIN_SIZE
        const z = (row / (size - 1) - 0.5) * TERRAIN_SIZE
        const y = this.#sceneHeight(ft)
        positions.push(x, y, z)

        const t = (ft - minFt) / span
        const color = this.#terrainColor(t)
        colors.push(color.r, color.g, color.b)
      }
    }

    for (let row = 0; row < size - 1; row++) {
      for (let col = 0; col < size - 1; col++) {
        const a = row * size + col
        const b = a + 1
        const c = a + size
        const d = c + 1
        indices.push(a, c, b, b, c, d)
      }
    }

    const geometry = new THREE.BufferGeometry()
    geometry.setAttribute("position", new THREE.Float32BufferAttribute(positions, 3))
    geometry.setAttribute("color", new THREE.Float32BufferAttribute(colors, 3))
    geometry.setIndex(indices)
    geometry.computeVertexNormals()

    const material = new THREE.MeshStandardMaterial({
      vertexColors: true,
      roughness: 0.94,
      metalness: 0,
      flatShading: false
    })

    const mesh = new THREE.Mesh(geometry, material)
    this.scene.add(mesh)
    this.layers.terrain = mesh

    const contour = new THREE.LineSegments(
      new THREE.WireframeGeometry(geometry),
      new THREE.LineBasicMaterial({ color: "#dfe8d6", transparent: true, opacity: 0.055 })
    )
    this.scene.add(contour)
  }

  #buildCourse(points) {
    const projected = points.map((point) => this.#pointFromLatLng(point[0], point[1], 0.32))
    const geometry = new THREE.BufferGeometry().setFromPoints(projected)
    const line = new THREE.Line(geometry, new THREE.LineBasicMaterial({ color: "#f2d77b", linewidth: 2 }))
    this.scene.add(line)
    this.layers.course = line
  }

  #buildDrive(points) {
    const projected = points.map((point) => this.#pointFromLatLng(point[0], point[1], 0.48))
    const geometry = new THREE.BufferGeometry().setFromPoints(projected)
    const line = new THREE.Line(geometry, new THREE.LineBasicMaterial({ color: "#6cc0d5", linewidth: 2 }))
    line.visible = this.driveValue
    this.scene.add(line)
    this.layers.drive = line
  }

  #buildStations(stations) {
    const group = new THREE.Group()
    const seen = new Map()

    for (const station of stations) {
      if (station.lat == null || station.lng == null) continue

      const point = this.#pointFromLatLng(station.lat, station.lng, 0.9)
      const key = `${station.lat},${station.lng}`
      const count = seen.get(key) || 0
      seen.set(key, count + 1)
      if (count > 0) {
        point.x += Math.cos(count * 1.7) * 0.52
        point.z += Math.sin(count * 1.7) * 0.52
      }

      const marker = new THREE.Mesh(
        new THREE.SphereGeometry(MARKER_RADIUS, 18, 12),
        new THREE.MeshStandardMaterial({ color: station.crew ? "#f2d77b" : "#dfe8d6", emissive: station.crew ? "#3d2d05" : "#122015", roughness: 0.35 })
      )
      marker.position.copy(point)
      marker.userData.station = station
      group.add(marker)
      this.stationMeshes.push(marker)

      const stemGeometry = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(point.x, point.y - 0.85, point.z),
        new THREE.Vector3(point.x, point.y, point.z)
      ])
      group.add(new THREE.Line(stemGeometry, new THREE.LineBasicMaterial({ color: "#f8f5e6", transparent: true, opacity: 0.58 })))
    }

    this.scene.add(group)
    this.layers.stations = group
  }

  #pointFromLatLng(lat, lng, lift = 0) {
    const { min_lat: minLat, max_lat: maxLat, min_lng: minLng, max_lng: maxLng } = this.terrainPayload.grid.bounds
    const x = ((Number(lng) - minLng) / (maxLng - minLng) - 0.5) * TERRAIN_SIZE
    const z = ((maxLat - Number(lat)) / (maxLat - minLat) - 0.5) * TERRAIN_SIZE
    return new THREE.Vector3(x, this.#sampleHeight(lat, lng) + lift, z)
  }

  #sampleHeight(lat, lng) {
    const grid = this.terrainPayload.grid
    const { size, elevations_ft: elevations } = grid
    const { min_lat: minLat, max_lat: maxLat, min_lng: minLng, max_lng: maxLng } = grid.bounds
    const col = this.#clamp(((Number(lng) - minLng) / (maxLng - minLng)) * (size - 1), 0, size - 1.001)
    const row = this.#clamp(((maxLat - Number(lat)) / (maxLat - minLat)) * (size - 1), 0, size - 1.001)
    const x0 = Math.floor(col)
    const y0 = Math.floor(row)
    const fx = col - x0
    const fy = row - y0
    const a = elevations[y0 * size + x0]
    const b = elevations[y0 * size + x0 + 1]
    const c = elevations[(y0 + 1) * size + x0]
    const d = elevations[(y0 + 1) * size + x0 + 1]
    return this.#sceneHeight(a + (b - a) * fx + (c - a) * fy + (a - b - c + d) * fx * fy)
  }

  #sceneHeight(ft) {
    const grid = this.terrainPayload.grid
    const span = Math.max(grid.max_ft - grid.min_ft, 1)
    return ((ft - grid.min_ft) / span - 0.35) * 11
  }

  #terrainColor(t) {
    const low = new THREE.Color("#172d22")
    const mid = new THREE.Color("#6f805a")
    const high = new THREE.Color("#d9d5c4")
    if (t < 0.58) return low.clone().lerp(mid, t / 0.58)
    return mid.clone().lerp(high, (t - 0.58) / 0.42)
  }

  #selectStation(event) {
    if (!this.stationMeshes.length) return

    const rect = this.renderer.domElement.getBoundingClientRect()
    this.pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1
    this.pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1
    this.raycaster.setFromCamera(this.pointer, this.camera)

    const hit = this.raycaster.intersectObjects(this.stationMeshes, false)[0]
    if (hit) this.#showStation(hit.object.userData.station)
  }

  #showStation(station) {
    const directions = station.lat != null && station.lng != null
      ? `<a class="font-semibold text-[#f2d77b] hover:text-paper" target="_blank" rel="noopener" href="https://www.google.com/maps/dir/?api=1&destination=${station.lat},${station.lng}">Directions</a>`
      : ""
    const source = station.source_metadata?.verification_status || "pending"

    this.detailTarget.innerHTML = `
      <div class="font-semibold text-paper">${this.#escape(station.name)}</div>
      <div class="mt-1 font-mono text-[11px] uppercase tracking-[0.12em] text-paper/50">Mile ${this.#escape(station.mile)} / ${this.#escape(station.direction || "Pass")}</div>
      <dl class="mt-4 grid grid-cols-2 gap-3 text-sm">
        ${this.#detail("Cutoff", this.#cutoffLabel(station))}
        ${this.#detail("Crew", station.crew ? "Allowed" : "No")}
        ${this.#detail("Pacer", station.pacer ? "Allowed" : "No")}
        ${this.#detail("Drop bag", station.drop_bag ? "Yes" : "No")}
        ${this.#detail("Medical", station.medical ? "Yes" : "No")}
        ${this.#detail("Elevation", station.elevation_ft ? `${station.elevation_ft} ft` : "Not listed")}
      </dl>
      ${station.aid ? `<p class="mt-4 text-paper/78">${this.#escape(station.aid)}</p>` : ""}
      ${station.parking ? `<p class="mt-3 text-paper/62">${this.#escape(station.parking)}</p>` : ""}
      ${station.road_notes ? `<p class="mt-3 text-paper/62">${this.#escape(station.road_notes)}</p>` : ""}
      <div class="mt-4 flex items-center justify-between gap-3 border-t border-paper/10 pt-3 font-mono text-[10px] uppercase tracking-[0.12em] text-paper/50">
        <span>Source ${this.#escape(source)}</span>
        ${directions}
      </div>
    `
  }

  #detail(label, value) {
    return `<div><dt class="font-mono text-[10px] uppercase tracking-[0.12em] text-paper/45">${this.#escape(label)}</dt><dd class="mt-1 font-semibold text-paper">${this.#escape(value)}</dd></div>`
  }

  #cutoffLabel(station) {
    const normalized = [station.cutoff_clock, station.cutoff_elapsed_label].filter(Boolean).join(" / ")
    return normalized || station.cutoff || "None listed"
  }

  #setStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message
  }

  #animate() {
    this.frame = requestAnimationFrame(() => this.#animate())
    this.controls?.update()
    this.renderer?.render(this.scene, this.camera)
  }

  #resize() {
    if (!this.renderer || !this.camera) return
    const width = this.canvasTarget.clientWidth
    const height = this.canvasTarget.clientHeight
    this.camera.aspect = width / height
    this.camera.updateProjectionMatrix()
    this.renderer.setSize(width, height)
  }

  #clamp(value, min, max) {
    return Math.min(Math.max(value, min), max)
  }

  #escape(value) {
    const div = document.createElement("div")
    div.textContent = value == null ? "" : String(value)
    return div.innerHTML
  }
}
