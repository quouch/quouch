import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="close-modal"
export default class extends Controller {
  static targets = ["modal"]
  
  closeModal() {
    this.modalTarget.style.display = "none"
  }
}
