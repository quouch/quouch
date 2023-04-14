import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="conditional-user-fields"
export default class extends Controller {
  static targets = ['trigger', 'field']

   toggleField() {
    if (this.triggerTarget.checked) {
      this.fieldTarget.style.display = 'flex'
    } else {
      this.fieldTarget.style.display = 'none'
    }
  }
}
