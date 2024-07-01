import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['code', 'link'];

  static values = {
    feedbackText: String
  }

  copy(event) {
    navigator.clipboard.writeText(this.inputTarget.value);
    event.currentTarget.disabled = true;
    event.currentTarget.innerText = this.feedbackTextValue;
  }
}