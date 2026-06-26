import { Controller } from "@hotwired/stimulus"

// Draws the course + aid stations from a JSON endpoint, plus (on the crew map only) the
// crew driving route between drivable trailheads. Leaflet loads via a <script> in the page <head>.
export default class extends Controller {
  static values = { url: String, drive: Boolean }
  static targets = ["canvas"]

  connect() { this.#withLeaflet(() => this.#init()) }
  disconnect() { this.map?.remove() }

  #init() {
    this.map = L.map(this.canvasTarget, { scrollWheelZoom: false }).setView([39.5, -98.5], 4)
    L.tileLayer("https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png", {
      maxZoom: 17, attribution: "&copy; OpenStreetMap &copy; CARTO"
    }).addTo(this.map)
    this.crewLayer = L.layerGroup().addTo(this.map)
    this.otherLayer = L.layerGroup().addTo(this.map)
    this.driveLayer = L.layerGroup().addTo(this.map)
    fetch(this.urlValue).then((r) => r.json()).then((d) => this.#draw(d))
  }

  #draw(d) {
    const bounds = []

    const pts = (d.course || []).map((p) => [p[0], p[1]])
    if (pts.length) {
      L.polyline(pts, { color: "#ffffff", weight: 7, opacity: 0.9 }).addTo(this.map)
      L.polyline(pts, { color: "#E4521F", weight: 3.5 }).addTo(this.map)
      bounds.push(...pts)
    }

    // Crew driving route (dashed) — only when this is the crew map.
    const drive = d.crew_route?.geometry || []
    if (this.driveValue && drive.length) {
      L.polyline(drive, { color: "#ffffff", weight: 6, opacity: 0.6 }).addTo(this.driveLayer)
      L.polyline(drive, { color: "#19170F", weight: 3, opacity: 0.9, dashArray: "10 9", lineCap: "round" }).addTo(this.driveLayer)
      bounds.push(...drive)
    }

    for (const s of d.stations || []) {
      if (s.lat == null || s.lng == null) continue
      const layer = s.crew ? this.crewLayer : this.otherLayer
      L.circleMarker([s.lat, s.lng], this.#style(s)).bindPopup(this.#popup(s)).addTo(layer)
      bounds.push([s.lat, s.lng])
    }

    this.map.invalidateSize()
    if (bounds.length) this.map.fitBounds(bounds, { padding: [30, 30] })
  }

  toggleOther(e) { this.#toggle(this.otherLayer, e.target.checked) }
  toggleDrive(e) { this.#toggle(this.driveLayer, e.target.checked) }

  #toggle(layer, on) {
    if (on) layer.addTo(this.map)
    else this.map.removeLayer(layer)
  }

  #style(s) {
    return s.crew
      ? { radius: 7, color: "#fff", weight: 2, fillColor: "#1F5132", fillOpacity: 1 }
      : { radius: 5, color: "#fff", weight: 1.5, fillColor: "#9a937f", fillOpacity: 0.85 }
  }

  #popup(s) {
    const dir = s.lat != null
      ? `<a href="https://www.google.com/maps/dir/?api=1&destination=${s.lat},${s.lng}" target="_blank" rel="noopener">Get directions</a>`
      : ""
    const tags = [s.crew ? "✅ Crew access" : "🚫 No crew", s.drop_bag ? "drop bag" : null, s.pacer ? "pacer" : null]
      .filter(Boolean).join(" · ")
    return `<strong>${s.name}</strong><br>Mile ${s.mile ?? "—"}${s.cutoff ? " · cutoff " + s.cutoff : ""}` +
      `<br>${tags}${s.parking ? "<br><em>" + s.parking + "</em>" : ""}${dir ? "<br>" + dir : ""}`
  }

  #withLeaflet(cb, tries = 0) {
    if (window.L) return cb()
    if (tries > 60) return
    setTimeout(() => this.#withLeaflet(cb, tries + 1), 50)
  }
}
