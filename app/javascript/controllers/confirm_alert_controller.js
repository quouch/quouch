import { Controller } from "@hotwired/stimulus";
import swal from 'sweetalert';

// Connects to data-controller="confirm-alert"
export default class extends Controller {
  static targets = ['cancel', 'action'];
  
  displayConfirmAlert(event) {
    console.log(event.target.confirmButtons)
    const title = event.target.dataset.confirmTitle
    const text = event.target.dataset.confirmText
    const buttons = JSON.parse(event.target.dataset.confirmButtons || '[]')

    swal({
      title: title,
      text: text,
      buttons: buttons
    }).then((value) => {
      if (value === true) {
        this.actionTarget.click()
      }
    })
  }
}
