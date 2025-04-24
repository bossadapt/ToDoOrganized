import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()

    if (!this.dropdown) {
      this.dropdown = new window.bootstrap.Dropdown(this.element)
    }

    this.dropdown.toggle()
  }
}