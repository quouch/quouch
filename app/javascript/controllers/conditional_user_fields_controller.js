import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="conditional-user-fields"
export default class extends Controller {
  static targets = ["trigger", "field"]

  connect() {
    this.toggleField()
  }

   toggleField() {
    if (this.triggerTarget.checked) {
      this.fieldTarget.style.display = "block"
    } else {
      this.fieldTarget.style.display = "none"
    }
  }
}
