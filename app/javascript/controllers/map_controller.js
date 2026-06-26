import { Controller } from "@hotwired/stimulus"

// Draws the course + aid stations on a Leaflet map from a JSON endpoint.
// Crew-accessible stations are emphasized; the rest can be toggled off —
// "show me the map with crew info". Leaflet itself loads via a <script> in the page <head>.
export default class extends Controller {
  static values = { url: String }
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
    fetch(this.urlValue).then((r) => r.json()).then((d) => this.#draw(d))
  }

  #draw(d) {
    const pts = (d.course || []).map((p) => [p[0], p[1]])
    if (pts.length) {
      L.polyline(pts, { color: "#ffffff", weight: 7, opacity: 0.9 }).addTo(this.map)
      L.polyline(pts, { color: "#E4521F", weight: 3.5 }).addTo(this.map)
    }
    for (const s of d.stations || []) {
      if (s.lat == null || s.lng == null) continue
      const layer = s.crew ? this.crewLayer : this.otherLayer
      L.circleMarker([s.lat, s.lng], this.#style(s)).bindPopup(this.#popup(s)).addTo(layer)
    }
    // container is laid out by now → fix the size, then fit the view to the data
    this.map.invalidateSize()
    const markers = [...this.crewLayer.getLayers(), ...this.otherLayer.getLayers()]
    if (markers.length) this.map.fitBounds(L.featureGroup(markers).getBounds().pad(0.15))
    else if (pts.length) this.map.fitBounds(pts)
  }

  // Checkbox in the view toggles the non-crew stations.
  toggleOther(e) {
    if (e.target.checked) this.otherLayer.addTo(this.map)
    else this.map.removeLayer(this.otherLayer)
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
