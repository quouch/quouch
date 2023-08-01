import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-modal"
export default class extends Controller {
  connect() {
    swal({
      title: 'This is the new web app!',
      text: 'If you are an existing user, you should have received a link to reset your password. Reach out to us if you have problems. We hope that you like the new look! 😎 Safe travels! 🏝️',
      button: 'Got it'
    })
  }
}
