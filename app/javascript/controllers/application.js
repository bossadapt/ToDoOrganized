import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.bootstrap = bootstrap
window.Stimulus   = application

export { application }
