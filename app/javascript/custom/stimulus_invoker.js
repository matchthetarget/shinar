import * as Turbo from "@hotwired/turbo"
import { application } from "../controllers/application" // Adjusted path to Stimulus application instance

Turbo.StreamActions.invoke_stimulus = function() {
  const method = this.getAttribute("method")
  const targetSelector = this.getAttribute("target") // Get target from attribute
  
  // Parse arguments - handle both array and object formats
  let args = []
  try {
    const argsRaw = this.getAttribute("arguments")
    if (argsRaw) {
      const parsed = JSON.parse(argsRaw)
      args = Array.isArray(parsed) ? parsed : [parsed]
    }
  } catch (e) {
    console.error("Error parsing arguments for invoke_stimulus:", e)
    args = []
  }

  // Find all elements matching the selector
  const elements = document.querySelectorAll(targetSelector);
  if (elements.length === 0) {
    console.warn(`Turbo Stream 'invoke_stimulus': No elements found for selector "${targetSelector}"`);
    return;
  }

  elements.forEach(element => {
    const controllerAttribute = element.getAttribute("data-controller");
    if (!controllerAttribute) {
      console.warn(`Turbo Stream 'invoke_stimulus': Target element has no data-controller attribute.`, element);
      return; // Skip elements without controllers
    }

    // Extract controller identifiers (supports multiple space-separated controllers)
    const controllerIdentifiers = controllerAttribute.split(" ");

    // Try to find a matching controller with the method
    let methodInvoked = false;
    
    controllerIdentifiers.forEach(identifier => {
      try {
        const controller = application.getControllerForElementAndIdentifier(element, identifier);

        if (controller && typeof controller[method] === 'function') {
          console.log(`Invoking ${identifier}#${method} on`, element, 'with args:', args);
          controller[method](...args); // Use spread operator for arguments
          methodInvoked = true;
        } else if (controller) {
          console.warn(`Turbo Stream 'invoke_stimulus': Method "${method}" not found on controller "${identifier}".`);
        }
      } catch (error) {
        console.error(`Error invoking Stimulus controller method: ${error.message}`);
      }
    });
    
    if (!methodInvoked) {
      console.warn(`No controller with method "${method}" found for element:`, element);
    }
  });
};