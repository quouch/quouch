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
    window.history.pushState('', '', url)
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
