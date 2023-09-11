import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-submit"
export default class extends Controller {
  static targets = [ 'input', 'form' ]

  submitMessage(event) {
    if (event.key === 'Enter' && event.shiftKey) {
      event.preventDefault();
      this.inputTarget.value += '\n';
    } else if (event.key === 'Enter') {
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
      .then(() => {
        this.inputTarget.value = '';
      })
      .catch(error => {
        // Handle any errors that occurred during the request
        console.error(error);
      });
  }
}
