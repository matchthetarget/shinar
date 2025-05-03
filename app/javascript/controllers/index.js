// Import and register all your controllers
import { application } from "./application"

// Import all controller modules
import AutosizeController from "./autosize_controller";
import ClipboardController from "./clipboard_controller";
import ToastController from "./toast_controller";

// Register controllers
application.register("autosize", AutosizeController);
application.register("clipboard", ClipboardController);
application.register("toast", ToastController);
