import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Initialize dropdown on first connection
    this.initDropdown()
    
    // Re-initialize after Turbo navigations
    document.addEventListener("turbo:load", this.initDropdown.bind(this))
    document.addEventListener("turbo:frame-load", this.initDropdown.bind(this))
    document.addEventListener("turbo:render", this.initDropdown.bind(this))
  }
  
  disconnect() {
    // Remove event listeners to prevent memory leaks
    document.removeEventListener("turbo:load", this.initDropdown.bind(this))
    document.removeEventListener("turbo:frame-load", this.initDropdown.bind(this))
    document.removeEventListener("turbo:render", this.initDropdown.bind(this))
    
    // Clean up dropdown instance
    if (this.dropdown) {
      this.dropdown.dispose()
    }
  }
  
  initDropdown() {
    // Dispose existing dropdown if it exists
    if (this.dropdown) {
      this.dropdown.dispose()
    }
    
    // Create a new Bootstrap dropdown
    this.dropdown = new bootstrap.Dropdown(this.element.querySelector('[data-bs-toggle="dropdown"]'))
  }
}