import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="conditional-user-fields"
export default class extends Controller {
	static targets = ['trigger', 'field']

	connect() {
		if (this.triggerTarget.checked) {
			this.fieldTarget.classList.remove('display-none')
		}
	}

	toggleField() {
		this.fieldTarget.classList.toggle('display-none')
	}
}
