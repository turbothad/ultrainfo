import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "row", "status"]

  connect() {
    this.filter = "all"
    this.update()
  }

  select(event) {
    this.filter = event.currentTarget.dataset.stationFilterName
    this.update()
  }

  showCrew() {
    this.filter = "crew"
    this.update()
  }

  update() {
    let visibleCount = 0

    this.rowTargets.forEach((row) => {
      const matches = this.filter === "all" || row.dataset.filterTags.split(" ").includes(this.filter)
      row.hidden = !matches
      if (matches) visibleCount += 1
    })

    this.buttonTargets.forEach((button) => {
      button.setAttribute("aria-pressed", button.dataset.stationFilterName === this.filter)
    })

    const noun = visibleCount === 1 ? "station pass" : "station passes"
    this.statusTarget.textContent = `Showing ${visibleCount} ${noun}`
  }
}
