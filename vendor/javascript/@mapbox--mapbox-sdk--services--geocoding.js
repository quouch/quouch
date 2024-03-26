import*as e from"xtend";import{_ as r,a as o,b as a}from"../_/df1a00fb.js";import{_ as t}from"../_/f392aba7.js";import"@mapbox/fusspot";import"../_/6d2134c8.js";import"@mapbox/parse-mapbox-token";import"eventemitter3";import"#lib/client.js";var i="default"in e?e.default:e;var n={};var s=i;var m=r;var p=o;var u=t;var d=a;var c={};var l=["country","region","postcode","district","place","locality","neighborhood","address","poi","poi.landmark"];
/**
 * Search for a place.
 *
 * See the [public documentation](https://docs.mapbox.com/api/search/#forward-geocoding).
 *
 * @param {Object} config
 * @param {string} config.query - A place name.
 * @param {'mapbox.places'|'mapbox.places-permanent'} [config.mode="mapbox.places"] - Either `mapbox.places` for ephemeral geocoding, or `mapbox.places-permanent` for storing results and batch geocoding.
 * @param {Array<string>} [config.countries] - Limits results to the specified countries.
 *   Each item in the array should be an [ISO 3166 alpha 2 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
 * @param {Coordinates|'ip'} [config.proximity] - Bias local results based on a provided coordinate location or a user's IP address.
 * @param {Array<'country'|'region'|'postcode'|'district'|'place'|'locality'|'neighborhood'|'address'|'poi'|'poi.landmark'>} [config.types] - Filter results by feature types.
 * @param {boolean} [config.autocomplete=true] - Return autocomplete results or not.
 * @param {BoundingBox} [config.bbox] - Limit results to a bounding box.
 * @param {number} [config.limit=5] - Limit the number of results returned.
 * @param {Array<string>} [config.language] - Specify the language to use for response text and, for forward geocoding, query result weighting.
 *  Options are [IETF language tags](https://en.wikipedia.org/wiki/IETF_language_tag) comprised of a mandatory
 *  [ISO 639-1 language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) and optionally one or more IETF subtags for country or script.
 * @param {boolean} [config.routing=false] - Specify whether to request additional metadata about the recommended navigation destination. Only applicable for address features.
 * @param {boolean} [config.fuzzyMatch=true] - Specify whether the Geocoding API should attempt approximate, as well as exact, matching.
 * @param {String} [config.worldview="us"] - Filter results to geographic features whose characteristics are defined differently by audiences belonging to various regional, cultural, or political groups.
 * @return {MapiRequest}
 *
 * @example
 * geocodingClient.forwardGeocode({
 *   query: 'Paris, France',
 *   limit: 2
 * })
 *   .send()
 *   .then(response => {
 *     const match = response.body;
 *   });
 *
 * @example
 * // geocoding with proximity
 * geocodingClient.forwardGeocode({
 *   query: 'Paris, France',
 *   proximity: [-95.4431142, 33.6875431]
 * })
 *   .send()
 *   .then(response => {
 *     const match = response.body;
 *   });
 *
 * // geocoding with countries
 * geocodingClient.forwardGeocode({
 *   query: 'Paris, France',
 *   countries: ['fr']
 * })
 *   .send()
 *   .then(response => {
 *     const match = response.body;
 *   });
 *
 * // geocoding with bounding box
 * geocodingClient.forwardGeocode({
 *   query: 'Paris, France',
 *   bbox: [2.14, 48.72, 2.55, 48.96]
 * })
 *   .send()
 *   .then(response => {
 *     const match = response.body;
 *   });
 */c.forwardGeocode=function(e){m.assertShape({query:m.required(m.string),mode:m.oneOf("mapbox.places","mapbox.places-permanent"),countries:m.arrayOf(m.string),proximity:m.oneOf(m.coordinates,"ip"),types:m.arrayOf(m.oneOf(l)),autocomplete:m.boolean,bbox:m.arrayOf(m.number),limit:m.number,language:m.arrayOf(m.string),routing:m.boolean,fuzzyMatch:m.boolean,worldview:m.string})(e);e.mode=e.mode||"mapbox.places";var r=u(s({country:e.countries},p(e,["proximity","types","autocomplete","bbox","limit","language","routing","fuzzyMatch","worldview"])));return this.client.createRequest({method:"GET",path:"/geocoding/v5/:mode/:query.json",params:p(e,["mode","query"]),query:r})};
/**
 * Search for places near coordinates.
 *
 * See the [public documentation](https://docs.mapbox.com/api/search/#reverse-geocoding).
 *
 * @param {Object} config
 * @param {Coordinates} config.query - Coordinates at which features will be searched.
 * @param {'mapbox.places'|'mapbox.places-permanent'} [config.mode="mapbox.places"] - Either `mapbox.places` for ephemeral geocoding, or `mapbox.places-permanent` for storing results and batch geocoding.
 * @param {Array<string>} [config.countries] - Limits results to the specified countries.
 *   Each item in the array should be an [ISO 3166 alpha 2 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
 * @param {Array<'country'|'region'|'postcode'|'district'|'place'|'locality'|'neighborhood'|'address'|'poi'|'poi.landmark'>} [config.types] - Filter results by feature types.
 * @param {BoundingBox} [config.bbox] - Limit results to a bounding box.
 * @param {number} [config.limit=1] - Limit the number of results returned. If using this option, you must provide a single item for `types`.
 * @param {Array<string>} [config.language] - Specify the language to use for response text and, for forward geocoding, query result weighting.
 *  Options are [IETF language tags](https://en.wikipedia.org/wiki/IETF_language_tag) comprised of a mandatory
 *  [ISO 639-1 language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) and optionally one or more IETF subtags for country or script.
 * @param {'distance'|'score'} [config.reverseMode='distance'] - Set the factors that are used to sort nearby results.
 * @param {boolean} [config.routing=false] - Specify whether to request additional metadata about the recommended navigation destination. Only applicable for address features.
 * @param {String} [config.worldview="us"] - Filter results to geographic features whose characteristics are defined differently by audiences belonging to various regional, cultural, or political groups.
 * @return {MapiRequest}
 *
 * @example
 * geocodingClient.reverseGeocode({
 *   query: [-95.4431142, 33.6875431]
 * })
 *   .send()
 *   .then(response => {
 *     // GeoJSON document with geocoding matches
 *     const match = response.body;
 *   });
 */c.reverseGeocode=function(e){m.assertShape({query:m.required(m.coordinates),mode:m.oneOf("mapbox.places","mapbox.places-permanent"),countries:m.arrayOf(m.string),types:m.arrayOf(m.oneOf(l)),bbox:m.arrayOf(m.number),limit:m.number,language:m.arrayOf(m.string),reverseMode:m.oneOf("distance","score"),routing:m.boolean,worldview:m.string})(e);e.mode=e.mode||"mapbox.places";var r=u(s({country:e.countries},p(e,["country","types","bbox","limit","language","reverseMode","routing","worldview"])));return this.client.createRequest({method:"GET",path:"/geocoding/v5/:mode/:query.json",params:p(e,["mode","query"]),query:r})};n=d(c);var b=n;export{b as default};

