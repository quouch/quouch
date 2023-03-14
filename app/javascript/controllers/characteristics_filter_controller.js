import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="characteristics-filter"
export default class extends Controller {
  static targets = ['form']

  submitForm() {
    this.formTarget.submit()
  }
}
