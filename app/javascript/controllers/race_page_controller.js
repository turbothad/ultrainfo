import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  showCrewDrive() {
    document.dispatchEvent(new CustomEvent("terrain-map:show-drive"))
  }
}
