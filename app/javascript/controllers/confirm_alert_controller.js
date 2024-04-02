import { Controller } from '@hotwired/stimulus';
import swal from 'sweetalert';

// Connects to data-controller="confirm-alert"
export default class extends Controller {
  static targets = ['cancel', 'action'];

  displayConfirmAlert(event) {
    const title = event.target.dataset.confirmTitle
    const text = event.target.dataset.confirmText
    const buttons = JSON.parse(event.target.dataset.confirmButtons || '[]')

    swal({
      title: title,
      text: text,
      content: {
        element: 'input',
        attributes: {
          placeholder: 'Leave a message for your guest..',
          type: 'text'
        }
      },
      buttons: buttons
    }).then((value) => {
      console.log(value)
      if (value === true) {
        const messageContent = document.querySelector('.swal-content__input')
        this.actionTarget.click(messageContent)
      }
    })
  }

  displayAcceptAlert(event) {
    swal({
      title: 'Request accepted!',
      text: 'Nice, request confirmed. Feel free to chat about details with them in case you still have questions or just want to say hi. Have fun with your guest!',
      button: 'Ok!'
    }).then(() => {
      window.location.reload()
    })
  }
}
