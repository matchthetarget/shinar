import { Controller } from "@hotwired/stimulus"

// Controls textarea submission with Shift+Enter key
export default class extends Controller {
  connect() {
    this.element.addEventListener("keydown", this.handleKeyDown.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("keydown", this.handleKeyDown.bind(this))
  }

  handleKeyDown(event) {
    // Submit form on Shift+Enter
    if (event.key === "Enter" && event.shiftKey) {
      event.preventDefault()
      this.element.closest("form").requestSubmit()
    }
  }
}