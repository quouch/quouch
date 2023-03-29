import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'preview']

  previewImage() {
    const url = URL.createObjectURL(this.inputTarget.files[0])
    this.previewTarget.src = url
  }
}
