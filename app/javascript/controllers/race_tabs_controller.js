import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { active: String }
  static targets = ["tab", "panel"]

  connect() {
    this.onHashChange = () => {
      const hashTab = window.location.hash.replace("#", "")
      if (this.#validTab(hashTab)) this.show(hashTab, false)
    }
    window.addEventListener("hashchange", this.onHashChange)

    const hashTab = window.location.hash.replace("#", "")
    this.show(this.#validTab(hashTab) || this.activeValue || "overview", false)
  }

  disconnect() {
    window.removeEventListener("hashchange", this.onHashChange)
  }

  select(event) {
    event.preventDefault()
    this.show(event.currentTarget.dataset.tab)
  }

  show(tab, updateHash = true) {
    const active = this.#validTab(tab) || "overview"

    for (const button of this.tabTargets) {
      button.setAttribute("aria-selected", button.dataset.tab === active ? "true" : "false")
    }

    for (const panel of this.panelTargets) {
      panel.hidden = panel.dataset.tabPanel !== active
    }

    const activePanel = this.panelTargets.find((panel) => panel.dataset.tabPanel === active)
    activePanel?.dispatchEvent(new CustomEvent("race-tabs:shown", { bubbles: true, detail: { tab: active } }))

    if (updateHash) history.replaceState(null, "", `#${active}`)
  }

  #validTab(tab) {
    return ["overview", "runner", "crew", "follower", "map"].includes(tab) ? tab : null
  }
}
