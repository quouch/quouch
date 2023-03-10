import { Application } from "@hotwired/stimulus"

import '../../assets/stylesheets/application.scss';

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }