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
      .then(response => console.log(response.json()))
      .then(data => console.log(data))
  }
}
