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
  
  // Add global toast event listener
  window.addEventListener("show-toast", function(event) {
    const { message, type } = event.detail;
    
    // Create toast container if it doesn't exist
    let container = document.querySelector(".toast-container");
    if (!container) {
      container = document.createElement("div");
      container.className = "toast-container position-fixed top-0 end-0 p-3";
      document.body.appendChild(container);
    }
    
    // Create toast element
    const toast = document.createElement("div");
    toast.className = `toast border border-${type === 'error' ? 'danger' : type}`;
    toast.setAttribute("role", "alert");
    toast.setAttribute("aria-live", "assertive");
    toast.setAttribute("aria-atomic", "true");
    toast.setAttribute("data-controller", "toast");
    
    // Create toast body
    const toastBody = document.createElement("div");
    toastBody.className = "toast-body d-flex justify-content-between text-dark";
    toastBody.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    `;
    
    // Assemble and show toast
    toast.appendChild(toastBody);
    container.appendChild(toast);
    
    // Initialize Bootstrap toast
    const bsToast = new bootstrap.Toast(toast, {
      autohide: true,
      delay: 5000
    });
    bsToast.show();
  });
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
