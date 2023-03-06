import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="close-modal"
export default class extends Controller {
  static targets = ["modal"]
  
  connect() {
    setTimeout(() => {
      this.modalTarget.style.opacity = '0'
    }, 3000)
  }

  closeModal() {
    this.modalTarget.style.display = "none"
  }

  afterLeave() {
    this.modalTarget.remove();
  }
}
