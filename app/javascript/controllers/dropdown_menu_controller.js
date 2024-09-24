import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="dropdown-menu"
export default class extends Controller {
	static targets = ['toggle', 'menu']

	displayAndHideMenu() {
		this.menuTarget.classList.toggle('display-none')
	}
}
