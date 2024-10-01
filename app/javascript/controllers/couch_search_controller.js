import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
	static targets = ['form']

	setUrlWithParams() {
		const formData = new FormData(this.formTarget)
		// remove "city" from the form data, as we don't want to show it in the URL
		formData.delete('city')

		let urlSearchParams = new URLSearchParams(formData)

		const searchParams = urlSearchParams.toString()
		const url = `${this.formTarget.action}?${searchParams}`

		window.history.pushState('', '', url)
	}

	search() {
		this.setUrlWithParams()
		this.formTarget.requestSubmit()
	}

	filter() {
		this.search()
	}

	reset() {
		const url = this.formTarget.action
		this.formTarget.reset()
		// `this.formTarget.reset()` only affects the items that were changed after the page was loaded
		// So we need to manually reset the text inputs and checkboxes after navigation
		// This is only a problem on navigation, as pagy changes the URL and restores the form values,
		// but these are treated as the new initial values in JS
		for (let element of this.formTarget.elements) {
			if (element.type == 'text') {
				element.value = ''
			}
			if (element.type == 'checkbox') {
				element.checked = false
			}
		}
		this.search()
	}
}
