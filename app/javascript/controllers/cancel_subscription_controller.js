import { Controller } from '@hotwired/stimulus'
import swal from 'sweetalert'

export default class extends Controller {
	static targets = ['cancel', 'action']

	displayInfo(event) {
		const title = event.target.dataset.confirmTitle
		const text = event.target.dataset.confirmText
		const buttons = JSON.parse(event.target.dataset.confirmButtons || '[]')

		swal({
			title: title,
			text: text,
			buttons: buttons,
		}).then((value) => {
			if (value === true) {
				this.actionTarget.click()
			}
		})
	}
}
