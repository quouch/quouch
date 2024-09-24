import { Controller } from '@hotwired/stimulus'
import swal from 'sweetalert'

export default class extends Controller {
	static targets = ['checkbox', 'list']

	displayInfo() {
		if (this.checkboxTarget.checked) {
			this.listTarget.style.display = 'none'
			swal({
				title: 'Info',
				text: "If you select that you are currently travelling, your profile will show only the travelling badge and you won't appear as a host until you remove the checkmark for travelling again.",
				button: 'Ok, I understand!',
			})
		} else {
			this.listTarget.style.display = 'block'
		}
	}
}
