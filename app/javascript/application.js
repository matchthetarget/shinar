// Entry point for the build script
import "@hotwired/turbo-rails"
import "./controllers"

// Bootstrap JS with Popper
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap;

// Enable Turbo
import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = true;

// Initialize TurboPower
import TurboPower from "turbo_power";
TurboPower.initialize(Turbo.StreamActions);

// Add jQuery for legacy compatibility if needed
import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
