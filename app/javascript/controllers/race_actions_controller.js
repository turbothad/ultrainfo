import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  showDrive(event) {
    this.#activate(event, "race:show-drive")
  }

  showCrewPasses(event) {
    this.#activate(event, "race:show-crew-passes")
  }

  #activate(event, name) {
    event.preventDefault()
    window.dispatchEvent(new CustomEvent(name))

    const section = document.getElementById(event.currentTarget.hash.slice(1))
    section?.scrollIntoView({ behavior: "smooth", block: "start" })
    history.replaceState(null, "", event.currentTarget.hash)
  }
}
