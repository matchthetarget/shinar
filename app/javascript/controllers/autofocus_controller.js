import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { enabled: { type: Boolean, default: true } }

  connect() {
    if (this.enabledValue) {
      this.focusAutofocusElement()
    }
  }

  focusAutofocusElement() {
    setTimeout(() => {
      // Skip autofocus if dropdown is open (to prevent dropdown issues)
      const dropdownOpen = document.querySelector('.dropdown-menu.show')
      if (dropdownOpen) return
      
      const autofocusElement = this.element.querySelector('[autofocus]')
      if (autofocusElement) {
        autofocusElement.focus()
        autofocusElement.scrollIntoView({ behavior: 'auto', block: 'center' })
      }
    }, 300) // Increased delay to ensure DOM is stable and dropdowns can initialize first
  }
}