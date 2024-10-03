import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import GeocodingClient from '@mapbox/mapbox-sdk/services/geocoding'

// Connects to data-controller="map"
export default class extends Controller {
	static targets = ['map', 'form']
	static values = {
		apiKey: String,
		marker: Array,
		fuzzy: Boolean,
	}

	connect() {
		mapboxgl.accessToken = this.apiKeyValue

		this.map = new mapboxgl.Map({
			container: this.mapTarget,
			style: 'mapbox://styles/mapbox/streets-v11',
			maxZoom: this.fuzzyValue ? 14 : 22,
		})

		this.markers = []
		this.sources = []

		if (this.fuzzyValue) {
			this.addFuzzyMarkersToMap(this.markerValue).then(() => {
				const lngLats = this.sources.map((source) => source.center)
				this.fitMap(lngLats)
			})
			this.map.on('load', () => {
				this.map.addSource('couches', {
					type: 'geojson',
					data: {
						type: 'FeatureCollection',
						features: this.sources,
					},
				})
				this.map.addLayer({
					id: 'couches',
					type: 'circle',
					source: 'couches',
					paint: {
						'circle-color': '#fff',
						'circle-radius': 3,
						'circle-stroke-width': 6,
						'circle-stroke-color': '#fb5705',
					},
				})

				this.initializePopup()
			})
		} else {
			this.addMarkersToMap(this.markerValue)
			const lngLats = this.markers.map((marker) => marker.getLngLat())
			this.fitMap(lngLats)
		}
	}

	addMarkersToMap(markers) {
		markers.forEach((marker) => {
			const newMarker = this.createMarker(
				[marker.lng, marker.lat],
				marker,
				false,
			)
			this.markers.push(newMarker)
		})
	}

	async addFuzzyMarkersToMap(markers) {
		const geocoding = new GeocodingClient({ accessToken: this.apiKeyValue })

		return Promise.all(
			markers.map((marker) => {
				return geocoding
					.forwardGeocode({
						query: marker.fuzzy,
						autocomplete: false,
						limit: 1,
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

							this.addMarkerSource(feature, marker)
						}
					})
					.catch((error) => {
						console.error('Error geocoding address:', error)
					})
			}),
		)
	}

	addMarkerSource(feature, marker) {
		const source = {
			...feature,
			properties: {
				id: marker.id,
				...marker.info_popup.data,
			},
		}

		this.sources.push(source)
	}

	createMarker(lngLat, marker, fuzzy = false) {
		const info_popup = marker.info_popup
		const popup = new mapboxgl.Popup()
		if (info_popup.text) {
			popup.setText(info_popup.text)
		} else if (info_popup.user) {
		}

		// Create the custom marker element
		const customMarker = document.createElement('div')
		let innerClassName = 'quouch-map-pin color-secondary marker-pin'
		if (fuzzy) {
			customMarker.className = 'fuzzy-marker'
			innerClassName = 'fa fa-circle-dot color-primary marker-dot'
		}
		customMarker.innerHTML = `<i class='${innerClassName}' data-couch-id='${marker.id}' arial-label='Marker icon'></i>`

		return new mapboxgl.Marker(customMarker)
			.setLngLat(lngLat)
			.setPopup(popup)
			.addTo(this.map)
	}

	fitMap(lngLats) {
		const bounds = new mapboxgl.LngLatBounds()
		lngLats.forEach((lngLat) => bounds.extend(lngLat))

		if (!bounds.isEmpty()) {
			this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
		}
	}

	getUserPopup(userData) {
		return `
			<div class='mapboxgl-popup__user'>
				<a href='/couches/${userData.id}' class='mapboxgl-popup__link' data-turbo-frame='_top'>
					<img src='${userData.photo}' alt='${userData.first_name}' class='user__profile__image'/>
				</a>
				<div class='mapboxgl-popup__info'>
					<p class='mapboxgl-popup__name'>${userData.first_name}</p>
					<p class='mapboxgl-popup__pronouns'>${userData.pronouns || ''}</p>
				</div>
			</div>
			<div class='mapboxgl-popup__reviews'>
				<i class='quouch-star color-secondary-light' aria-label='Star icon'></i>
				<p class='mapboxgl-popup__rating'>${userData.rating}</p>
			</div>`
	}

	initializePopup() {
		// Create a popup, but don't add it to the map yet.
		const popup = new mapboxgl.Popup({
			closeButton: true,
			closeOnClick: false,
		})

		this.map.on('click', 'couches', (e) => {
			// Change the cursor style as a UI indicator.
			this.map.getCanvas().style.cursor = 'pointer'

			// Copy coordinates array.
			const coordinates = e.features[0].geometry.coordinates.slice()
			const properties = e.features[0].properties

			// Ensure that if the map is zoomed out such that multiple
			// copies of the feature are visible, the popup appears
			// over the copy being pointed to.
			if (
				['mercator', 'equirectangular'].includes(this.map.getProjection().name)
			) {
				while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
					coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360
				}
			}

			// Populate the popup and set its coordinates
			// based on the feature found.
			popup
				.setLngLat(coordinates)
				.setHTML(this.getUserPopup(properties))
				.addTo(this.map)
		})

		// Change the cursor to a pointer when the mouse is over the places layer.
		this.map.on('mouseenter', 'couches', () => {
			this.map.getCanvas().style.cursor = 'pointer'
		})

		this.map.on('mouseleave', 'couches', () => {
			this.map.getCanvas().style.cursor = ''
		})
	}
}
