import { Controller } from "@hotwired/stimulus"
import autosize from "autosize"

export default class extends Controller {
  static targets = ["textarea"]
  static values = { submitOnEnter: { type: Boolean, default: true } }

  connect() {
    if (this.hasTextareaTarget) {
      autosize(this.textareaTarget)
      this.textareaTarget.addEventListener("keydown", this.handleKeyDown.bind(this))
      
      // Force an update after connection to ensure proper sizing
      setTimeout(() => {
        autosize.update(this.textareaTarget)
      }, 100)
    }
  }

  disconnect() {
    if (this.hasTextareaTarget) {
      autosize.destroy(this.textareaTarget)
      this.textareaTarget.removeEventListener("keydown", this.handleKeyDown.bind(this))
    }
  }

  // Update autosize calculation when text changes
  update() {
    if (this.hasTextareaTarget) {
      autosize.update(this.textareaTarget)
    }
  }

  // Handle Enter and Shift+Enter keys
  handleKeyDown(event) {
    if (!this.submitOnEnterValue) return
    
    // If Enter is pressed without Shift, submit the form
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.requestSubmit()
    } else if (event.key === "Enter" && event.shiftKey) {
      // Shift+Enter pressed, allow default behavior (new line)
      // Force update autosize after new line is added
      setTimeout(() => {
        autosize.update(this.textareaTarget)
      }, 0)
    }
  }
}