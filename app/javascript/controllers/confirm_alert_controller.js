import { Controller } from "@hotwired/stimulus"
import swal from 'sweetalert';

// Connects to data-controller="confirm-alert"
export default class extends Controller {
  static targets = ['cancel', 'action']
  
  displayConfirmAlert() {
    swal({
      title: "Confirm",
      text: "Are you sure you want to cancel this booking?",
      buttons: ['No, go back', 'Yes, cancel']
    }).then((value) => {
      if (value == true) {
        this.actionTarget.click();
      }
    })
  }
}

