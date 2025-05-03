// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Change to true to allow Turbo
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
