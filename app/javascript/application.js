// Entry point for the build script
import "@hotwired/turbo-rails"
import "./controllers"

// Bootstrap JS with Popper
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap;

// Change to true to allow Turbo
import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = true;

// Allow UJS alongside Turbo
import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
import Rails from "@rails/ujs"
Rails.start();

// Handle autofocus after Turbo navigation
document.addEventListener('turbo:load', () => {
  const elements = document.querySelectorAll('[data-controller="autofocus"]')
  elements.forEach(element => {
    const autofocusElement = element.querySelector('[autofocus]')
    if (autofocusElement) {
      setTimeout(() => {
        autofocusElement.focus()
        autofocusElement.scrollIntoView({ behavior: 'auto', block: 'center' })
      }, 100)
    }
  })
});
