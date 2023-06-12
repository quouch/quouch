import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="validate-form"
export default class extends Controller {
  static targets = ['start', 'end', 'button', 'flexible']

  enableButton() {
    if (this.#allValid() || this.flexibleTarget.checked) {
      this.buttonTarget.disabled = false;
    } else {
      this.buttonTarget.disabled = true;
    }
  }

  #allValid() {
    return this.#isValid(this.startTarget) && this.#isValid(this.endTarget);
  }

  #isValid(input) {
    return input.value !== "";
  }
}
