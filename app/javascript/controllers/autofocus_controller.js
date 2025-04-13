import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.focusAutofocusElement()
  }

  focusAutofocusElement() {
    setTimeout(() => {
      const autofocusElement = this.element.querySelector('[autofocus]')
      if (autofocusElement) {
        autofocusElement.focus()
        autofocusElement.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }
    }, 100) // Small delay to ensure DOM is ready
  }
}