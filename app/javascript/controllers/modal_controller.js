import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element)
    this.modal.show()
    
    this.element.addEventListener('hidden.bs.modal', (event) => {
      this.element.remove()
    })
  }
  
  close() {
    this.modal.hide()
  }
}