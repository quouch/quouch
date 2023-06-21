import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-submit"
export default class extends Controller {
  static targets = [ 'input', 'form' ]

  submitMessage(event) {
    console.log('hola')
    if (event.key === 'Enter') {
      event.preventDefault();
      this.submitForm();
    }
  }

  submitForm() {
    const form = this.formTarget;

    fetch(form.action, {
      method: form.method,
      body: new FormData(form),
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
      .catch(error => {
        // Handle any errors that occurred during the request
        console.error(error);
      });
  }
}
