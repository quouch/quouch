import { Controller } from '@hotwired/stimulus'
import swal from 'sweetalert';


// Connects to data-controller="brevo"
export default class extends Controller {
  static targets = ['input']
  static values = { apiKey: String }

  send(event) {
    event.preventDefault();

    fetch('https://api.brevo.com/v3/contacts', {
      method: 'POST',
      headers: {'Content-Type': 'application/json', 'api-key': this.apiKeyValue },
      body: JSON.stringify({ 'email': this.inputTarget.value, 'listIds': [2] })
    })
      .then((response) => {
        if (response.status === 200) {
          swal({
            title: 'Signed up!',
            text: 'You have successfully subscribed to our newsletter and will now stay up to date. We would love to welcome you into our community!',
            button: 'Lots of love!'
          }).then(() => {
            window.location.reload()
          })
        }
      })
  }
}
