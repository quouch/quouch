import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="characteristics-filter"
export default class extends Controller {
  static targets = ['form', 'list', 'couches']

  listCouches(event) {
    event.preventDefault()

    const formData = new FormData(this.formTarget);
    const searchParams = new URLSearchParams(formData).toString();
    const url = `${this.formTarget.action}?${searchParams}`;

    fetch(url, {
      headers: { 'Accept': 'application/json' },
    })
      .then(response => response.json())
      .then((data) => {
        console.log(searchParams)
        this.couchesTarget.remove()
        this.listTarget.insertAdjacentHTML('beforeend', data.inserted_list)
      })
  }
}
