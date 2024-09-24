import { Controller } from '@hotwired/stimulus'
import swal from 'sweetalert'

// Connects to data-controller="confirm-alert"
export default class extends Controller {
	static targets = ['cancel', 'action']

	displayDeclineAlert(event) {
		const title = event.target.dataset.confirmTitle
		const text = event.target.dataset.confirmText
		const buttons = JSON.parse(event.target.dataset.confirmButtons || '[]')

		swal({
			title: title,
			text: text,
			content: {
				element: 'input',
				attributes: {
					placeholder: 'Leave a kind message for your guest..',
					type: 'text',
				},
			},
			buttons: buttons,
		}).then((value) => {
			const messageInput = value.trim()

			const hiddenInput = document.createElement('input')
			hiddenInput.type = 'hidden'
			hiddenInput.name = 'message'
			hiddenInput.value = messageInput

			const form = this.actionTarget.closest('form')
			form.appendChild(hiddenInput)

			// Submit the form
			this.actionTarget.click()
		})
	}

	displayCancelAlert(event) {
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

	displayAcceptAlert(event) {
		swal({
			title: 'Request accepted!',
			text: 'Nice, request confirmed. Feel free to chat about details with them in case you still have questions or just want to say hi. Have fun with your guest!',
			button: 'Ok!',
		}).then(() => {
			window.location.reload()
		})
	}
}
