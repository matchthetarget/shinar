import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]
  static values = { text: String }

  copy() {
    const textToCopy = this.hasTextValue ? this.textValue : window.location.href
    
    navigator.clipboard.writeText(textToCopy)
      .then(() => {
        this.showToast("Copied to clipboard!")
      })
      .catch(err => {
        console.error("Failed to copy: ", err)
        this.showToast("Failed to copy to clipboard", "error")
      })
  }

  showToast(message, type = "success") {
    const event = new CustomEvent("show-toast", {
      detail: { message, type }
    })
    window.dispatchEvent(event)
  }
}