import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import GeocodingClient from '@mapbox/mapbox-sdk/services/geocoding'

// Connects to data-controller="map"
export default class extends Controller {
	static targets = ['map', 'form']
	static values = {
		apiKey: String,
		marker: Array,
		fuzzy: Boolean
	}

	connect() {
		mapboxgl.accessToken = this.apiKeyValue

		this.map = new mapboxgl.Map({
			container: this.mapTarget,
			style: 'mapbox://styles/mapbox/streets-v11',
			maxZoom: this.fuzzyValue ? 14 : 22
		})

		this.markers = []
		this.sources = new Map()

		if (this.fuzzyValue) {
			this.#addFuzzyMarkersToMap(this.markerValue).then(() => {
				this.#fitMapToMarkers()
			})
			this.map.on('load', () => {
				this.sources.forEach((source, featureId) => {
					this.map.addSource(featureId, source)

					this.map.addLayer({
						id: featureId,
						type: 'circle',
						source: featureId,
						minzoom: 13,
						paint: {
							'circle-radius': {
								base: 150,
								stops: [[14, 180]]
							},
							'circle-color': '#007cbf',
							'circle-opacity': 0.4
						}
					})
				})
			})
		} else {
			this.#addMarkersToMap(this.markerValue)
			this.#fitMapToMarkers()
		}
	}

	#clearMarkers() {
		this.markers.forEach((marker) => marker.remove())
		this.markers = []
	}

	#addMarkersToMap(markers) {
		markers.forEach((marker) => {
			const newMarker = this.createMarker([marker.lng, marker.lat], marker)
			this.markers.push(newMarker)
		})
	}

	async #addFuzzyMarkersToMap(markers) {
		const geocoding = new GeocodingClient({ accessToken: this.apiKeyValue })

		return Promise.all(
			markers.map((marker) => {
				return geocoding
					.forwardGeocode({
						query: marker.fuzzy,
						autocomplete: false,
						limit: 1
					})
					.send()
					.then((response) => {
						if (
							response &&
							response.body &&
							response.body.features &&
							response.body.features.length
						) {
							const feature = response.body.features[0]

							const newMarker = this.createMarker(feature.center, marker)

							this.addLayer(feature)

							this.markers.push(newMarker)
						}
					})
					.catch((error) => {
						console.error('Error geocoding address:', error)
					})
			})
		)
	}

	addLayer(feature) {
		const source = {
			type: 'geojson',
			data: {
				type: 'FeatureCollection',
				features: [feature]
			}
		}

		this.sources.set(feature.id, source)
	}

	createMarker(lngLat, marker) {
		const info_popup = marker.info_popup
		const popup = new mapboxgl.Popup()
		if (info_popup.text) {
			popup.setText(info_popup.text)
		}
		if (info_popup.html) {
			popup.setHTML(info_popup.html)
		}

		let markerHtmlContent = marker.marker_html

		// Create the custom marker element
		const customMarker = document.createElement('div')
		customMarker.innerHTML = markerHtmlContent

		return new mapboxgl.Marker(customMarker)
			.setLngLat(lngLat)
			.setPopup(popup)
			.addTo(this.map)
	}

	#fitMapToMarkers() {
		const bounds = new mapboxgl.LngLatBounds()
		this.markers.forEach((marker) => bounds.extend(marker.getLngLat()))
		if (!bounds.isEmpty()) {
			this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
		}
	}
}
