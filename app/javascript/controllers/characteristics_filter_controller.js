import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="characteristics-filter"
export default class extends Controller {
  static targets = ['form', 'list', 'couches']

  listCouches(event) {
    event.preventDefault()

    const formData = new FormData(this.formTarget)
    const searchParams = new URLSearchParams(formData).toString()
    const url = `${this.formTarget.action}?${searchParams}`

    this.#fetchCouches(url)
  }

  resetForm() {
    const url = this.formTarget.action
    this.formTarget.reset()
    this.#fetchCouches(url)
  }

  #fetchCouches(url) {
    fetch(url, {
      headers: { 'Accept': 'application/json' },
    })
      .then(response => response.json())
      .then((data) => {
          this.couchesTarget.remove()
          this.listTarget.insertAdjacentHTML('afterbegin', data.inserted_list)
        })
  }
}
