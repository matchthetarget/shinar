import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]
  static values = { text: String }

  copy() {
    const textToCopy = this.hasTextValue ? this.textValue : window.location.href
  }
}
