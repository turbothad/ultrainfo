import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = ["terrain-map", "station-filter"]

  showCrewDrive(event) {
    this.#transition(event, () => this.terrainMapOutlet.showDrive())
  }

  showCrewPasses(event) {
    this.#transition(event, () => this.stationFilterOutlet.showCrew())
  }

  openStationPass(event) {
    event.preventDefault()
    const hash = event.currentTarget.hash
    const stationPassRow = hash && this.element.querySelector(hash)
    const stationPass = stationPassRow?.matches("details") ? stationPassRow : stationPassRow?.querySelector("details")
    if (!stationPassRow || !stationPass) return

    this.stationFilterOutlet.showAll()
    stationPass.open = true
    this.#navigate(hash, stationPassRow)
    stationPass.querySelector("summary")?.focus({ preventScroll: true })
  }

  #transition(event, update) {
    event.preventDefault()
    const hash = event.currentTarget.hash
    const destination = hash && this.element.querySelector(hash)
    if (!destination) return

    update()
    this.#navigate(hash, destination)
  }

  #navigate(hash, destination) {
    history.replaceState(null, "", hash)
    destination.scrollIntoView({ behavior: this.#motionBehavior(), block: "start" })
  }

  #motionBehavior() {
    return window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth"
  }
}
