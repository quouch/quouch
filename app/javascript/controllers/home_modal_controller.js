import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-modal"
export default class extends Controller {
  connect() {
    swal({
      title: 'Launch happening!',
      text: 'We just recently switched from the old app to the new one.',
      button: 'Ok, got it!'
    })
  }
}
