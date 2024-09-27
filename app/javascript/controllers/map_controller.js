import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import GeocodingClient from '@mapbox/mapbox-sdk/services/geocoding'

// Connects to data-controller="map"
export default class extends Controller {
	static targets = ['map', 'form']
	static values = {
		apiKey: String,
		marker: Array
	}

	mapboxClient = null

	connect() {
		mapboxgl.accessToken = this.apiKeyValue

		this.map = new mapboxgl.Map({
			container: this.mapTarget,
			style: 'mapbox://styles/mapbox/streets-v11',
			maxZoom: 12
		})

		this.markers = []
		this.#addMarkersToMap(this.markerValue).then(() => {
			this.#fitMapToMarkers()
		})
	}

	#clearMarkers() {
		this.markers.forEach((marker) => marker.remove())
		this.markers = []
	}

	async #addMarkersToMap(markers) {
		const geocoding = new GeocodingClient({ accessToken: this.apiKeyValue })

		return Promise.all(
			markers.map((marker) => {
				return geocoding.forwardGeocode({
					query: marker.fuzzy,
					autocomplete: false,
					limit: 1
				}).send().then((response) => {
					if (response && response.body && response.body.features && response.body.features.length) {
						const feature = response.body.features[0]

						const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

						let markerHtmlContent = marker.marker_html

						// Create the custom marker element
						const customMarker = document.createElement('div')
						customMarker.innerHTML = markerHtmlContent

						const newMarker = new mapboxgl.Marker(customMarker)
							.setLngLat(feature.center)
							.setPopup(popup)
							.addTo(this.map)

						this.markers.push(newMarker)
					}
				}).catch((error) => {
					console.error('Error geocoding address:', error)
				})
			})
		)
	}

	#fitMapToMarkers() {
		const bounds = new mapboxgl.LngLatBounds()
		this.markers.forEach((marker) => bounds.extend(marker.getLngLat()))
		if (!bounds.isEmpty()) {
			this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
		}
	}

	updateMarkers(event) {
	}
}
