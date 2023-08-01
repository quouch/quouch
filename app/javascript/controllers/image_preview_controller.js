import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'preview']

  previewImage(event) {
    const file = event.target.files[0]
    const maxSize = 10485760 // 10MB in bytes

    if (file && file.size > maxSize) {
      alert('File size must be less than 10MB so we can keep the site fast!')
      event.preventDefault()
      event.target.value = ''// Reset the input field to clear the invalid file
    } else {
      const url = URL.createObjectURL(this.inputTarget.files[0])
      this.previewTarget.src = url
    }
  }
}
