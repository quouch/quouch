import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="validate-form"
export default class extends Controller {
  static targets = ['start', 'end', 'message', 'button']

  enableButton() {
    if (this.#allValid()) {
      this.buttonTarget.disabled = false;
    } else {

      this.buttonTarget.disabled = true;
    }
  }

  #allValid() {
    return this.#isValid(this.startTarget) && this.#isValid(this.endTarget) && this.#isValid(this.messageTarget);
  }

  #isValid(input) {
    return input.value !== "";
  }
}
