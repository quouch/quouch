import { Controller } from "@hotwired/stimulus"
import swal from 'sweetalert'

export default class extends Controller {
  static targets = ['checkbox']

  displayInfo() {
    if (this.checkboxTarget.checked) {
      swal({
        title: 'Info',
        text: "If you select that you are currently travelling, your profile will show only the travelling badge and you won't appear as a host.",
        button: 'Ok, I understand!'
      })
    }
  }
}
