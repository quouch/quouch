import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="display-filters"
export default class extends Controller {
	static targets = ['filters', 'input']

	connect() {
		// Check if the show_filters parameter is set to true
		if (this.inputTarget.value === 'true') {
			this.filtersTarget.classList.remove('display-none')
			return
		}

		// Use window.innerWidth in favor of window.screen.width. Why?
		// window.innerWidth is the width of the window's viewport,
		// whereas window.screen.width returns the actual screen size
		// window.screen.width would generally work but we assume that people don't use full-screen on desktop always,
		// so window.innerWidth is a more accurate representation of what the user is seeing.
		// For more information, https://developer.mozilla.org/en-US/docs/Web/API/Window/innerWidth
		if (window.innerWidth >= 768) {
			this.filtersTarget.classList.remove('display-none')
		}
	}

	toggleFilters(event) {
		this.filtersTarget.classList.toggle('display-none')
		event.currentTarget.classList.toggle('search__hide-filters--active')

		// Set the value for `show_filters` in the form
		this.inputTarget.value = this.filtersTarget.classList.contains('display-none') ? 'false' : 'true'
	}
}
