import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { apiKey: String }

  static targets = ['address']

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: 'country, region, place, postcode, address'
    })
    this.geocoder.addTo(this.element)
    this.geocoder.on('result', event => this.#setInputValue(event))
    this.geocoder.on('clear', () => this.#clearInputValue())

    if (this.addressTarget.value) {
      const addressValue = this.addressTarget.value
      let address = document.querySelector('.mapboxgl-ctrl-geocoder--input')
      address.value = addressValue
    }
  }

  #setInputValue(event) {
    this.addressTarget.value = event.result.place_name
    const city = document.getElementById('city')
    const zip = document.getElementById('zip')
    const country = document.getElementById('user_country')
    let cityDone = false
    for (let i = 0; i < event.result.context.length; i++) {
      if (event.result.context[i].id.includes("postcode")) {
        zip.value = event.result.context[i].text;
      } else if (event.result.context[i].id.includes("place")) {
        city.value = event.result.context[i].text;
        cityDone = true
      } else if (event.result.context[i].id.includes("country")) {
        country.value = event.result.context[i].short_code.toUpperCase();
      }
    }
    if (!cityDone) {
      city.value = event.result.place_name.split(",")[0]
    }
  }

  #clearInputValue() {
    this.addressTarget.value = ''
  }

  disconnect() {
    this.geocoder.onRemove()
  }
}
