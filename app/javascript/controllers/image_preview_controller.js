import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
	static targets = ['input', 'preview', 'placeholder']

	previewImage(event) {
		const file = event.target.files[0]
		const maxSize = 5000000 // 5MB in bytes

		if (file && file.size > maxSize) {
			alert('File size must be less than 5MB')
			event.preventDefault()
			event.target.value = '' // Reset the input field to clear the invalid file
		} else {
			const url = URL.createObjectURL(this.inputTarget.files[0])
			this.previewTarget.src = url
		}
	}
}
