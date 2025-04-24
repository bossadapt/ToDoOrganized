import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "button"]

  connect() {
    this.update()
  }

  toggle() {
    this.expanded = !this.expanded
    this.update()
  }

  update() {
    const showCount = 5
    this.itemTargets.forEach((el, index) => {
      el.style.display = (this.expanded || index < showCount) ? "" : "none"
    })
    this.buttonTarget.innerText = this.expanded ? "Show less" : "Show more"
  }
}