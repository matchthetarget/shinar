import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const toast = new bootstrap.Toast(this.element, {
      autohide: true,
      delay: 5000
    })
    toast.show()
  }
}
