import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
    
    // Observe new message additions to auto-scroll
    this.observer = new MutationObserver((mutations) => {
      this.autoScrollOnNewMessages(mutations)
    })
    
    this.observer.observe(this.element, {
      childList: true,
      subtree: true
    })
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  scrollToBottom() {
    if (this.element) {
      this.element.scrollTop = this.element.scrollHeight
    }
  }
  
  // Smart scroll that only scrolls if user is already at the bottom
  autoScrollOnNewMessages(mutations) {
    if (!this.element) return
    
    // Check if the user is scrolled near the bottom (within 200px of bottom)
    const isNearBottom = this.element.scrollHeight - this.element.scrollTop - this.element.clientHeight < 200
    
    // If near bottom, scroll to bottom 
    if (isNearBottom) {
      // Small delay to ensure content is rendered
      setTimeout(() => {
        this.scrollToBottom()
      }, 100)
    }
  }
}
