import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { text: String }

  connect() {
    // If no text value provided, use the current URL
    if (!this.hasTextValue) {
      this.textValue = window.location.href
    }
    
    // Store original button text if button target is used
    if (this.hasButtonTarget) {
      this.originalText = this.buttonTarget.innerHTML
    }
  }

  copy() {
    const textToCopy = this.textValue
    
    navigator.clipboard.writeText(textToCopy)
      .then(() => {
        this.showCopiedFeedback()
      })
      .catch(err => {
        console.error('Could not copy text to clipboard', err)
      })
  }
  
  showCopiedFeedback() {
    // Change button text if we have a button target
    if (this.hasButtonTarget) {
      const originalText = this.originalText
      this.buttonTarget.innerHTML = "Copied!"
      
      // Reset after 5 seconds
      setTimeout(() => {
        this.buttonTarget.innerHTML = originalText
      }, 5000)
    }
  }
}
