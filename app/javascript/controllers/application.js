import { Application } from "@hotwired/stimulus"
//import { createConsumer } from "@rails/actioncable"
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
const application = Application.start()
// making it so turbo works with base path
//Turbo.session.drive = true
//Turbo.setAttribute("data-turbo-cable-url", "wss://bossadapt.org/todoorganized/cable");
//createConsumer("wss://bossadapt.org/todoorganized/cable");
// Configure Stimulus development experience
application.debug = false
window.bootstrap = bootstrap
window.Stimulus   = application

export { application }
