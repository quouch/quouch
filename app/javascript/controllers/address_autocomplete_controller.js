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
  }

  #setInputValue(event) {
    this.addressTarget.value = event.result.place_name
    const city = document.getElementById('city')
    // const address = document.getElementById('street')
    const zip = document.getElementById('zip')
    const country = document.getElementById('user_country')
    // const street = event.result.text ? event.result.text : ''
    // const number = event.result.address ? event.result.address : ''
    // address.value = `${street} ${number}`
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

  // autofill() {
  //   const fullAddress = event.value
  //   this.cityInput = fullAddress

  // }

  //     // from here all you have to do is to sync each value to right target input
  //     // Target input address = fullAddressHash[:address_name]
  //     // Target input zip_code = fullAddressHash[:zip_code]
  //     // Target input city = fullAddressHash[:city]
  //   });

  //   function extractFullAddress(value) {
  //     // do your regex stuff with the value to get an array of something like this ["12 rue blabla", "75000", "Paris"] and store in result
  //     return { address_name: result[0], zip_code: result[1], city: result[2] };
  //   };
}
