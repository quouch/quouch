import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
	static values = {
		apiKey: String,
		marker: Array,
	}

	connect() {
		mapboxgl.accessToken = this.apiKeyValue

		this.map = new mapboxgl.Map({
			container: this.element,
			style: 'mapbox://styles/mapbox/streets-v10',
		})
		this.#addMarkersToMap()
		this.#fitMapToMarkers()
	}

	#addMarkersToMap() {
		this.markerValue.forEach((marker) => {
			const customMarker = document.createElement('div')
			customMarker.innerHTML = marker.marker_html

			new mapboxgl.Marker(customMarker)
				.setLngLat([marker.lng, marker.lat])
				.addTo(this.map)
		})
	}

	#fitMapToMarkers() {
		const bounds = new mapboxgl.LngLatBounds()
		this.markerValue.forEach((marker) =>
			bounds.extend([marker.lng, marker.lat]),
		)
		this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
	}
}
