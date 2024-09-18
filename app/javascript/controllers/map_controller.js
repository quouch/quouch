import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
	static targets = ['map', 'form']
	static values = {
		apiKey: String,
		marker: Array,
	}

	connect() {
		mapboxgl.accessToken = this.apiKeyValue

		this.map = new mapboxgl.Map({
			container: this.mapTarget,
			style: 'mapbox://styles/mapbox/streets-v10',
		})

		console.log(this.markerValue)

		this.markers = []
		this.#addMarkersToMap(this.markerValue)
		this.#fitMapToMarkers()
	}

	#clearMarkers() {
		this.markers.forEach((marker) => marker.remove())
		this.markers = []
	}

	#addMarkersToMap(markers) {
		markers.forEach((marker) => {
			const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

			let markerHtmlContent = marker.marker_html

			if (typeof markerHtmlContent === 'string') {
				try {
					markerHtmlContent = JSON.parse(markerHtmlContent).inserted_markers
				} catch (error) {
					console.error('Error parsing marker_html:', error)
				}
			}

			// Create the custom marker element
			const customMarker = document.createElement('div')
			customMarker.innerHTML = markerHtmlContent

			const newMarker = new mapboxgl.Marker(customMarker)
				.setLngLat([marker.lng, marker.lat])
				.setPopup(popup)
				.addTo(this.map)

			this.markers.push(newMarker)
		})
	}

	#fitMapToMarkers() {
		const bounds = new mapboxgl.LngLatBounds()
		this.markers.forEach((marker) => bounds.extend(marker.getLngLat()))
		if (!bounds.isEmpty()) {
			this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
		}
	}

	updateMarkers(event) {}
}
