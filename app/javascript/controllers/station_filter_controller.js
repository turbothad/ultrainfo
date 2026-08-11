import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { initial: String }
  static targets = ["button", "row", "status"]

  connect() {
    this.showAll = () => this.#apply("all")
    document.addEventListener("station-filter:show-all", this.showAll)
    this.#apply(this.initialValue || "all")
  }

  disconnect() {
    document.removeEventListener("station-filter:show-all", this.showAll)
  }

  filter(event) {
    this.#apply(event.params.filter)
  }

  showCrew() {
    this.#apply("crew")
  }

  #apply(filter) {
    let visibleCount = 0
    for (const row of this.rowTargets) {
      row.hidden = filter !== "all" && row.dataset[filter] !== "true"
      if (!row.hidden) visibleCount += 1
    }

    for (const button of this.buttonTargets) {
      button.setAttribute("aria-pressed", String(button.dataset.stationFilterFilterParam === filter))
    }

    if (this.hasStatusTarget) {
      const noun = visibleCount === 1 ? "station pass" : "station passes"
      this.statusTarget.textContent = `Showing ${visibleCount} ${noun}`
    }
  }
}
