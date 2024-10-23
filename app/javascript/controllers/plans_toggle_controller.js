import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="plans-toggle"
export default class extends Controller {
	static targets = ['toggle', 'month', 'sixmonths', 'year']
	static values = {
		interval: String,
	}

	connect() {
		if (this.intervalValue) {
			this.switch({ target: { value: this.intervalValue } })
		}
	}

	switch(event) {
		const selectedPlan = event.target.value

		// Hide all targets initially
		this.monthTarget.classList.add('display-none')
		this.sixmonthsTarget.classList.add('display-none')
		this.yearTarget.classList.add('display-none')

		if (selectedPlan === 'month') {
			this.monthTarget.classList.remove('display-none')
		} else if (selectedPlan === 'sixmonths') {
			this.sixmonthsTarget.classList.remove('display-none')
		} else if (selectedPlan === 'year') {
			this.yearTarget.classList.remove('display-none')
		}
	}
}
