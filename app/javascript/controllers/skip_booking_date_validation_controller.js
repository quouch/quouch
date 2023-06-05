import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="skip-booking-date-validation"
export default class extends Controller {
  static targets = ['checkbox', 'date']

  hideFields() {
    console.log('hi')
    if (this.checkboxTarget.checked) {
      this.dateTarget.style.display = 'none';
    } else {
      this.dateTarget.style.display = 'flex';
    }
  }
}
