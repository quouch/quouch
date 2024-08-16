import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display-filters"
export default class extends Controller {
  static targets = ['filters']

  connect() {
    if (window.screen.width >= 768) {
      this.filtersTarget.classList.remove('display-none')
    }
  }

  toggleFilters(event) {
    this.filtersTarget.classList.toggle('display-none')
    event.currentTarget.classList.toggle('search__hide-filters--active')
  }
}
