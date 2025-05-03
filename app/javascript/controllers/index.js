// Import and register all your controllers
import { application } from "./application"

// Import all controller modules
import AutofocusController from "./autofocus_controller";
import AutogrowController from "./autogrow_controller";
import ClipboardController from "./clipboard_controller";
import ToastController from "./toast_controller";

// Register controllers
application.register("autofocus", AutofocusController);
application.register("autogrow", AutogrowController);
application.register("clipboard", ClipboardController);
application.register("toast", ToastController);
