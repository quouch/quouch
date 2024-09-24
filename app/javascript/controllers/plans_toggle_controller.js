import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="plans-toggle"
export default class extends Controller {
	static targets = ['toggle', 'month', 'year']
	switch() {
		if (this.monthTarget.classList.contains('display-none')) {
			this.monthTarget.classList.remove('display-none')
			this.yearTarget.classList.add('display-none')
		} else if (this.yearTarget.classList.contains('display-none')) {
			this.yearTarget.classList.remove('display-none')
			this.monthTarget.classList.add('display-none')
		}
	}
}
