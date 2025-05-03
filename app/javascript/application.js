// Entry point for the build script
import "@hotwired/turbo-rails"
import "./controllers"

// Change to true to allow Turbo
import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = true;

// Allow UJS alongside Turbo
import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
import Rails from "@rails/ujs"
Rails.start();

// Disable Bootstrap smooth scrolling
document.addEventListener('DOMContentLoaded', () => {
  window.addEventListener('scroll', () => {}, { passive: true });
  document.documentElement.style.scrollBehavior = 'auto';
});

// Handle autofocus after Turbo navigation
document.addEventListener('turbo:load', () => {
  const elements = document.querySelectorAll('[data-controller="autofocus"]')
  elements.forEach(element => {
    const autofocusElement = element.querySelector('[autofocus]')
    if (autofocusElement) {
      setTimeout(() => {
        autofocusElement.focus()
        autofocusElement.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }, 100)
    }
  })
});
