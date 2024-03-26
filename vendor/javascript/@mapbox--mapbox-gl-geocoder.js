import*as t from"suggestions";import*as e from"lodash.debounce";import*as i from"xtend";import*as o from"events";import*as n from"@mapbox/mapbox-sdk";import*as s from"@mapbox/mapbox-sdk/services/geocoding";import*as r from"nanoid";import*as a from"subtag";var l={};l={fr:{name:"France",bbox:[[-4.59235,41.380007],[9.560016,51.148506]]},us:{name:"United States",bbox:[[-171.791111,18.91619],[-66.96466,71.357764]]},ru:{name:"Russia",bbox:[[19.66064,41.151416],[190.10042,81.2504]]},ca:{name:"Canada",bbox:[[-140.99778,41.675105],[-52.648099,83.23324]]}};var h=l;var c=r;try{"default"in r&&(c=r.default)}catch(t){}var u={};var d=c.nanoid;
/**
 * Construct a new mapbox event client to send interaction events to the mapbox event service
 * @param {Object} options options with which to create the service
 * @param {String} options.accessToken the mapbox access token to make requests
 * @param {Number} [options.flushInterval=1000] the number of ms after which to flush the event queue
 * @param {Number} [options.maxQueueSize=100] the number of events to queue before flushing
 * @private
 */function MapboxEventManager$1(t){this.origin=t.origin||"https://api.mapbox.com";this.endpoint="events/v2";this.access_token=t.accessToken;this.version="0.2.0";this.sessionID=this.generateSessionID();this.userAgent=this.getUserAgent();this.options=t;this.send=this.send.bind(this);this.countries=t.countries?t.countries.split(","):null;this.types=t.types?t.types.split(","):null;this.bbox=t.bbox?t.bbox:null;this.language=t.language?t.language.split(","):null;this.limit=t.limit?+t.limit:null;this.locale=navigator.language||null;this.enableEventLogging=this.shouldEnableLogging(t);this.eventQueue=new Array;this.flushInterval=t.flushInterval||1e3;this.maxQueueSize=t.maxQueueSize||100;this.timer=this.flushInterval?setTimeout(this.flush.bind(this),this.flushInterval):null;this.lastSentInput="";this.lastSentIndex=0}MapboxEventManager$1.prototype={
/**
     * Send a search.select event to the mapbox events service
     * This event marks the array index of the item selected by the user out of the array of possible options
     * @private
     * @param {Object} selected the geojson feature selected by the user
     * @param {Object} geocoder a mapbox-gl-geocoder instance
     * @returns {Promise}
     */
select:function(t,e){var i=this.getSelectedIndex(t,e);var o=this.getEventPayload("search.select",e);o.resultIndex=i;o.resultPlaceName=t.place_name;o.resultId=t.id;if((i!==this.lastSentIndex||o.queryString!==this.lastSentInput)&&i!=-1){this.lastSentIndex=i;this.lastSentInput=o.queryString;if(o.queryString)return this.push(o)}},
/**
     * Send a search-start event to the mapbox events service
     * This turnstile event marks when a user starts a new search
     * @private
     * @param {Object} geocoder a mapbox-gl-geocoder instance
     * @returns {Promise}
     */
start:function(t){var e=this.getEventPayload("search.start",t);if(e.queryString)return this.push(e)},
/**
   * Send a search-keyevent event to the mapbox events service
   * This event records each keypress in sequence
   * @private
   * @param {Object} keyEvent the keydown event to log
   * @param {Object} geocoder a mapbox-gl-geocoder instance
   * 
   */
keyevent:function(t,e){if(t.key&&!t.metaKey&&[9,27,37,39,13,38,40].indexOf(t.keyCode)===-1){var i=this.getEventPayload("search.keystroke",e);i.lastAction=t.key;if(i.queryString)return this.push(i)}},
/**
   * Send an event to the events service
   *
   * The event is skipped if the instance is not enabled to send logging events
   *
   * @private
   * @param {Object} payload the http POST body of the event
   * @param {Function} [callback] a callback function to invoke when the send has completed
   * @returns {Promise}
   */
send:function(t,e){if(!this.enableEventLogging)return e?e():void 0;var i=this.getRequestOptions(t);this.request(i,function(t){return t?this.handleError(t,e):e?e():void 0}.bind(this))},
/**
   * Get http request options
   * @private
   * @param {*} payload
   */
getRequestOptions:function(t){Array.isArray(t)||(t=[t]);var e={method:"POST",host:this.origin,path:this.endpoint+"?access_token="+this.access_token,headers:{"Content-Type":"application/json"},body:JSON.stringify(t)};return e},
/**
   * Get the event payload to send to the events service
   * Most payload properties are shared across all events
   * @private
   * @param {String} event the name of the event to send to the events service. Valid options are 'search.start', 'search.select', 'search.feedback'.
   * @param {Object} geocoder a mapbox-gl-geocoder instance
   * @returns {Object} an event payload
   */
getEventPayload:function(t,e){var i;i=e.options.proximity?typeof e.options.proximity==="object"?[e.options.proximity.longitude,e.options.proximity.latitude]:e.options.proximity==="ip"?[999,999]:e.options.proximity:null;var o=e._map?e._map.getZoom():void 0;var n={event:t,created:+new Date,sessionIdentifier:this.sessionID,country:this.countries,userAgent:this.userAgent,language:this.language,bbox:this.bbox,types:this.types,endpoint:"mapbox.places",autocomplete:e.options.autocomplete,fuzzyMatch:e.options.fuzzyMatch,proximity:i,limit:e.options.limit,routing:e.options.routing,worldview:e.options.worldview,mapZoom:o,keyboardLocale:this.locale};t==="search.select"?n.queryString=e.inputString:t!="search.select"&&e._inputEl?n.queryString=e._inputEl.value:n.queryString=e.inputString;return n},
/**
   * Wraps the request function for easier testing
   * Make an http request and invoke a callback
   * @private
   * @param {Object} opts options describing the http request to be made
   * @param {Function} callback the callback to invoke when the http request is completed
   */
request:function(t,e){var i=new XMLHttpRequest;i.onreadystatechange=function(){if(this.readyState==4)return this.status==204?e(null):e(this.statusText)};i.open(t.method,t.host+"/"+t.path,true);for(var o in t.headers){var n=t.headers[o];i.setRequestHeader(o,n)}i.send(t.body)},
/**
   * Handle an error that occurred while making a request
   * @param {Object} err an error instance to log
   * @private
   */
handleError:function(t,e){if(e)return e(t)},generateSessionID:function(){return d()},getUserAgent:function(){return"mapbox-gl-geocoder."+this.version+"."+navigator.userAgent},
/**
     * Get the 0-based numeric index of the item that the user selected out of the list of options
     * @private
     * @param {Object} selected the geojson feature selected by the user
     * @param {Object} geocoder a Mapbox-GL-Geocoder instance
     * @returns {Number} the index of the selected result
     */
getSelectedIndex:function(t,e){if(e._typeahead){var i=e._typeahead.data;var o=t.id;var n=i.map((function(t){return t.id}));var s=n.indexOf(o);return s}},shouldEnableLogging:function(t){return t.enableEventLogging!==false&&((!t.origin||t.origin==="https://api.mapbox.com")&&(!t.localGeocoder&&!t.filter))},flush:function(){if(this.eventQueue.length>0){this.send(this.eventQueue);this.eventQueue=new Array}this.timer&&clearTimeout(this.timer);this.flushInterval&&(this.timer=setTimeout(this.flush.bind(this),this.flushInterval))},
/**
   * Push event into the pending queue
   * @param {Object} evt the event to send to the events service
   * @param {Boolean} forceFlush indicates that the event queue should be flushed after adding this event regardless of size of the queue
   * @private
   */
push:function(t,e){this.eventQueue.push(t);(this.eventQueue.length>=this.maxQueueSize||e)&&this.flush()},remove:function(){this.flush()}};u=MapboxEventManager$1;var p=u;var g={};var f={de:"Suche",it:"Ricerca",en:"Search",nl:"Zoeken",fr:"Chercher",ca:"Cerca",he:"לחפש",ja:"サーチ",lv:"Meklēt",pt:"Procurar",sr:"Претрага",zh:"搜索",cs:"Vyhledávání",hu:"Keresés",ka:"ძიება",nb:"Søke",sk:"Vyhľadávanie",th:"ค้นหา",fi:"Hae",is:"Leita",ko:"수색",pl:"Szukaj",sl:"Iskanje",fa:"جستجو",ru:"Поиск"};g={placeholder:f};var m=g;var _={};function Geolocation$1(){}Geolocation$1.prototype={isSupport:function(){return Boolean(window.navigator.geolocation)},getCurrentPosition:function(){const t={enableHighAccuracy:true};return new Promise((function(e,i){window.navigator.geolocation.getCurrentPosition(e,i,t)}))}};_=Geolocation$1;var v=_;var y={};
/**
 * This function transforms the feature from reverse geocoding to plain text with specified accuracy
 * @param {object} feature 
 * @param {string} accuracy 
 * @returns 
 */function transformFeatureToGeolocationText(t,e){const i=getAddressInfo(t);const o=["address","street","place","country"];var n;if(typeof e==="function")return e(i);const s=o.indexOf(e);n=s===-1?o:o.slice(s);return n.reduce((function(t,e){if(!i[e])return t;t!==""&&(t+=", ");return t+i[e]}),"")}
/**
 * This function transforms the feature from reverse geocoding to AddressInfo object
 * @param {object} feature 
 * @returns {object}
 */function getAddressInfo(t){const e=t.address||"";const i=t.text||"";const o=t.place_name||"";const n=o.split(",")[0];const s={address:n,houseNumber:e,street:i,placeName:o};t.context.forEach((function(t){const e=t.id.split(".")[0];s[e]=t.text}));return s}const b=/^[ ]*(-?\d{1,3}(\.\d{0,256})?)[, ]+(-?\d{1,3}(\.\d{0,256})?)[ ]*$/;y={transformFeatureToGeolocationText:transformFeatureToGeolocationText,getAddressInfo:getAddressInfo,REVERSE_GEOCODE_COORD_RGX:b};var E=y;var x=t;try{"default"in t&&(x=t.default)}catch(t){}var w=e;try{"default"in e&&(w=e.default)}catch(t){}var L=i;try{"default"in i&&(L=i.default)}catch(t){}var k=o;try{"default"in o&&(k=o.default)}catch(t){}var C=n;try{"default"in n&&(C=n.default)}catch(t){}var S=s;try{"default"in s&&(S=s.default)}catch(t){}var M=a;try{"default"in a&&(M=a.default)}catch(t){}var T={};var G=x;var A=w;var B=L;var I=k.EventEmitter;var R=h;var O=C;var P=S;var z=p;var q=m;var D=M;var F=v;var N=E;const V={FORWARD:0,LOCAL:1,REVERSE:2};function getFooterNode(){var t=document.createElement("div");t.className="mapboxgl-ctrl-geocoder--powered-by";t.innerHTML='<a href="https://www.mapbox.com/search-service" target="_blank">Powered by Mapbox</a>';return t}
/**
 * A geocoder component using the [Mapbox Geocoding API](https://docs.mapbox.com/api/search/#geocoding)
 * @class MapboxGeocoder
 * @param {Object} options
 * @param {String} options.accessToken Required.
 * @param {String} [options.origin=https://api.mapbox.com] Use to set a custom API origin.
 * @param {Object} [options.mapboxgl] A [mapbox-gl](https://github.com/mapbox/mapbox-gl-js) instance to use when creating [Markers](https://docs.mapbox.com/mapbox-gl-js/api/#marker). Required if `options.marker` is `true`.
 * @param {Number} [options.zoom=16] On geocoded result what zoom level should the map animate to when a `bbox` isn't found in the response. If a `bbox` is found the map will fit to the `bbox`.
 * @param {Boolean|Object} [options.flyTo=true] If `false`, animating the map to a selected result is disabled. If `true`, animating the map will use the default animation parameters. If an object, it will be passed as `options` to the map [`flyTo`](https://docs.mapbox.com/mapbox-gl-js/api/#map#flyto) or [`fitBounds`](https://docs.mapbox.com/mapbox-gl-js/api/#map#fitbounds) method providing control over the animation of the transition.
 * @param {String} [options.placeholder=Search] Override the default placeholder attribute value.
 * @param {Object|'ip'} [options.proximity] a geographical point given as an object with `latitude` and `longitude` properties, or the string 'ip' to use a user's IP address location. Search results closer to this point will be given higher priority.
 * @param {Boolean} [options.trackProximity=true] If `true`, the geocoder proximity will dynamically update based on the current map view or user's IP location, depending on zoom level.
 * @param {Boolean} [options.collapsed=false] If `true`, the geocoder control will collapse until hovered or in focus.
 * @param {Boolean} [options.clearAndBlurOnEsc=false] If `true`, the geocoder control will clear it's contents and blur when user presses the escape key.
 * @param {Boolean} [options.clearOnBlur=false] If `true`, the geocoder control will clear its value when the input blurs.
 * @param {Array} [options.bbox] a bounding box argument: this is
 * a bounding box given as an array in the format `[minX, minY, maxX, maxY]`.
 * Search results will be limited to the bounding box.
 * @param {string} [options.countries] a comma separated list of country codes to
 * limit results to specified country or countries.
 * @param {string} [options.types] a comma seperated list of types that filter
 * results to match those specified. See https://docs.mapbox.com/api/search/#data-types
 * for available types.
 * If reverseGeocode is enabled and no type is specified, the type defaults to POIs. Otherwise, if you configure more than one type, the first type will be used.
 * @param {Number} [options.minLength=2] Minimum number of characters to enter before results are shown.
 * @param {Number} [options.limit=5] Maximum number of results to show.
 * @param {string} [options.language] Specify the language to use for response text and query result weighting. Options are IETF language tags comprised of a mandatory ISO 639-1 language code and optionally one or more IETF subtags for country or script. More than one value can also be specified, separated by commas. Defaults to the browser's language settings.
 * @param {Function} [options.filter] A function which accepts a Feature in the [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) format to filter out results from the Geocoding API response before they are included in the suggestions list. Return `true` to keep the item, `false` otherwise.
 * @param {Function} [options.localGeocoder] A function accepting the query string which performs local geocoding to supplement results from the Mapbox Geocoding API. Expected to return an Array of GeoJSON Features in the [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) format.
 * @param {Function} [options.externalGeocoder] A function accepting the query string and current features list which performs geocoding to supplement results from the Mapbox Geocoding API. Expected to return a Promise which resolves to an Array of GeoJSON Features in the [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) format.
 * @param {distance|score} [options.reverseMode=distance] - Set the factors that are used to sort nearby results.
 * @param {boolean} [options.reverseGeocode=false] If `true`, enable reverse geocoding mode. In reverse geocoding, search input is expected to be coordinates in the form `lat, lon`, with suggestions being the reverse geocodes.
 * @param {boolean} [options.flipCoordinates=false] If `true`, search input coordinates for reverse geocoding is expected to be in the form `lon, lat` instead of the default `lat, lon`.
 * @param {Boolean} [options.enableEventLogging=true] Allow Mapbox to collect anonymous usage statistics from the plugin.
 * @param {Boolean|Object} [options.marker=true]  If `true`, a [Marker](https://docs.mapbox.com/mapbox-gl-js/api/#marker) will be added to the map at the location of the user-selected result using a default set of Marker options.  If the value is an object, the marker will be constructed using these options. If `false`, no marker will be added to the map. Requires that `options.mapboxgl` also be set.
 * @param {Function} [options.render] A function that specifies how the results should be rendered in the dropdown menu. This function should accepts a single [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) object as input and return a string. Any HTML in the returned string will be rendered.
 * @param {Function} [options.getItemValue] A function that specifies how the selected result should be rendered in the search bar. This function should accept a single [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) object as input and return a string. HTML tags in the output string will not be rendered. Defaults to `(item) => item.place_name`.
 * @param {String} [options.mode=mapbox.places] A string specifying the geocoding [endpoint](https://docs.mapbox.com/api/search/#endpoints) to query. Options are `mapbox.places` and `mapbox.places-permanent`. The `mapbox.places-permanent` mode requires an enterprise license for permanent geocodes.
 * @param {Boolean} [options.localGeocoderOnly=false] If `true`, indicates that the `localGeocoder` results should be the only ones returned to the user. If `false`, indicates that the `localGeocoder` results should be combined with those from the Mapbox API with the `localGeocoder` results ranked higher.
 * @param {Boolean} [options.autocomplete=true] Specify whether to return autocomplete results or not. When autocomplete is enabled, results will be included that start with the requested string, rather than just responses that match it exactly.
 * @param {Boolean} [options.fuzzyMatch=true] Specify whether the Geocoding API should attempt approximate, as well as exact, matching when performing searches, or whether it should opt out of this behavior and only attempt exact matching.
 * @param {Boolean} [options.routing=false] Specify whether to request additional metadata about the recommended navigation destination corresponding to the feature or not. Only applicable for address features.
 * @param {String} [options.worldview="us"] Filter results to geographic features whose characteristics are defined differently by audiences belonging to various regional, cultural, or political groups.
 * @param {Boolean} [options.enableGeolocation=false] If `true` enable user geolocation feature.
 * @param {('address'|'street'|'place'|'country')} [options.addressAccuracy="street"] The accuracy for the geolocation feature with which we define the address line to fill. The browser API returns the user's position with accuracy, and sometimes we can get the neighbor's address. To prevent receiving an incorrect address, you can reduce the accuracy of the definition.
 * @example
 * var geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken });
 * map.addControl(geocoder);
 * @return {MapboxGeocoder} `this`
 *
 */function MapboxGeocoder(t){this._eventEmitter=new I;this.options=B({},this.options,t);this.inputString="";this.fresh=true;this.lastSelected=null;this.geolocation=new F}MapboxGeocoder.prototype={options:{zoom:16,flyTo:true,trackProximity:true,minLength:2,reverseGeocode:false,flipCoordinates:false,limit:5,origin:"https://api.mapbox.com",enableEventLogging:true,marker:true,mapboxgl:null,collapsed:false,clearAndBlurOnEsc:false,clearOnBlur:false,enableGeolocation:false,addressAccuracy:"street",getItemValue:function(t){return t.place_name},render:function(t){var e=t.place_name.split(",");return'<div class="mapboxgl-ctrl-geocoder--suggestion"><div class="mapboxgl-ctrl-geocoder--suggestion-title">'+e[0]+'</div><div class="mapboxgl-ctrl-geocoder--suggestion-address">'+e.splice(1,e.length).join(",")+"</div></div>"}},
/**
   * Add the geocoder to a container. The container can be either a `mapboxgl.Map`, an `HTMLElement` or a CSS selector string.
   *
   * If the container is a [`mapboxgl.Map`](https://docs.mapbox.com/mapbox-gl-js/api/map/), this function will behave identically to [`Map.addControl(geocoder)`](https://docs.mapbox.com/mapbox-gl-js/api/map/#map#addcontrol).
   * If the container is an instance of [`HTMLElement`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement), then the geocoder will be appended as a child of that [`HTMLElement`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement).
   * If the container is a [CSS selector string](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors), the geocoder will be appended to the element returned from the query.
   *
   * This function will throw an error if the container is none of the above.
   * It will also throw an error if the referenced HTML element cannot be found in the `document.body`.
   *
   * For example, if the HTML body contains the element `<div id='geocoder-container'></div>`, the following script will append the geocoder to `#geocoder-container`:
   *
   * ```javascript
   * var geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken });
   * geocoder.addTo('#geocoder-container');
   * ```
   * @param {String|HTMLElement|mapboxgl.Map} container A reference to the container to which to add the geocoder
   */
addTo:function(t){function addToExistingContainer(t,e){if(!document.body.contains(e))throw new Error("Element provided to #addTo() exists, but is not in the DOM");const i=t.onAdd();e.appendChild(i)}if(t._controlContainer)t.addControl(this);else if(t instanceof HTMLElement)addToExistingContainer(this,t);else{if(typeof t!="string")throw new Error("Error: addTo must be a mapbox-gl-js map, an html element, or a CSS selector query for a single html element");{const e=document.querySelectorAll(t);if(e.length===0)throw new Error("Element ",t,"not found.");if(e.length>1)throw new Error("Geocoder can only be added to a single html element");addToExistingContainer(this,e[0])}}},onAdd:function(t){t&&typeof t!="string"&&(this._map=t);this.setLanguage();this.options.localGeocoderOnly||(this.geocoderService=P(O({accessToken:this.options.accessToken,origin:this.options.origin})));if(this.options.localGeocoderOnly&&!this.options.localGeocoder)throw new Error("A localGeocoder function must be specified to use localGeocoderOnly mode");this.eventManager=new z(this.options);this._onChange=this._onChange.bind(this);this._onKeyDown=this._onKeyDown.bind(this);this._onPaste=this._onPaste.bind(this);this._onBlur=this._onBlur.bind(this);this._showButton=this._showButton.bind(this);this._hideButton=this._hideButton.bind(this);this._onQueryResult=this._onQueryResult.bind(this);this.clear=this.clear.bind(this);this._updateProximity=this._updateProximity.bind(this);this._collapse=this._collapse.bind(this);this._unCollapse=this._unCollapse.bind(this);this._clear=this._clear.bind(this);this._clearOnBlur=this._clearOnBlur.bind(this);this._geolocateUser=this._geolocateUser.bind(this);var e=this.container=document.createElement("div");e.className="mapboxgl-ctrl-geocoder mapboxgl-ctrl";var i=this.createIcon("search",'<path d="M7.4 2.5c-2.7 0-4.9 2.2-4.9 4.9s2.2 4.9 4.9 4.9c1 0 1.8-.2 2.5-.8l3.7 3.7c.2.2.4.3.8.3.7 0 1.1-.4 1.1-1.1 0-.3-.1-.5-.3-.8L11.4 10c.4-.8.8-1.6.8-2.5.1-2.8-2.1-5-4.8-5zm0 1.6c1.8 0 3.2 1.4 3.2 3.2s-1.4 3.2-3.2 3.2-3.3-1.3-3.3-3.1 1.4-3.3 3.3-3.3z"/>');this._inputEl=document.createElement("input");this._inputEl.type="text";this._inputEl.className="mapboxgl-ctrl-geocoder--input";this.setPlaceholder();if(this.options.collapsed){this._collapse();this.container.addEventListener("mouseenter",this._unCollapse);this.container.addEventListener("mouseleave",this._collapse);this._inputEl.addEventListener("focus",this._unCollapse)}(this.options.collapsed||this.options.clearOnBlur)&&this._inputEl.addEventListener("blur",this._onBlur);this._inputEl.addEventListener("keydown",A(this._onKeyDown,200));this._inputEl.addEventListener("paste",this._onPaste);this._inputEl.addEventListener("change",this._onChange);this.container.addEventListener("mouseenter",this._showButton);this.container.addEventListener("mouseleave",this._hideButton);this._inputEl.addEventListener("keyup",function(t){this.eventManager.keyevent(t,this)}.bind(this));var o=document.createElement("div");o.classList.add("mapboxgl-ctrl-geocoder--pin-right");this._clearEl=document.createElement("button");this._clearEl.setAttribute("aria-label","Clear");this._clearEl.addEventListener("click",this.clear);this._clearEl.className="mapboxgl-ctrl-geocoder--button";var n=this.createIcon("close",'<path d="M3.8 2.5c-.6 0-1.3.7-1.3 1.3 0 .3.2.7.5.8L7.2 9 3 13.2c-.3.3-.5.7-.5 1 0 .6.7 1.3 1.3 1.3.3 0 .7-.2 1-.5L9 10.8l4.2 4.2c.2.3.7.3 1 .3.6 0 1.3-.7 1.3-1.3 0-.3-.2-.7-.3-1l-4.4-4L15 4.6c.3-.2.5-.5.5-.8 0-.7-.7-1.3-1.3-1.3-.3 0-.7.2-1 .3L9 7.1 4.8 2.8c-.3-.1-.7-.3-1-.3z"/>');this._clearEl.appendChild(n);this._loadingEl=this.createIcon("loading",'<path fill="#333" d="M4.4 4.4l.8.8c2.1-2.1 5.5-2.1 7.6 0l.8-.8c-2.5-2.5-6.7-2.5-9.2 0z"/><path opacity=".1" d="M12.8 12.9c-2.1 2.1-5.5 2.1-7.6 0-2.1-2.1-2.1-5.5 0-7.7l-.8-.8c-2.5 2.5-2.5 6.7 0 9.2s6.6 2.5 9.2 0 2.5-6.6 0-9.2l-.8.8c2.2 2.1 2.2 5.6 0 7.7z"/>');o.appendChild(this._clearEl);o.appendChild(this._loadingEl);e.appendChild(i);e.appendChild(this._inputEl);e.appendChild(o);if(this.options.enableGeolocation&&this.geolocation.isSupport()){this._geolocateEl=document.createElement("button");this._geolocateEl.setAttribute("aria-label","Geolocate");this._geolocateEl.addEventListener("click",this._geolocateUser);this._geolocateEl.className="mapboxgl-ctrl-geocoder--button";var s=this.createIcon("geolocate",'<path d="M12.999 3.677L2.042 8.269c-.962.403-.747 1.823.29 1.912l5.032.431.431 5.033c.089 1.037 1.509 1.252 1.912.29l4.592-10.957c.345-.822-.477-1.644-1.299-1.299z" fill="#4264fb"/>');this._geolocateEl.appendChild(s);o.appendChild(this._geolocateEl);this._showGeolocateButton()}var r=this._typeahead=new G(this._inputEl,[],{filter:false,minLength:this.options.minLength,limit:this.options.limit});this.setRenderFunction(this.options.render);r.getItemValue=this.options.getItemValue;var a=r.list.draw;var l=this._footerNode=getFooterNode();r.list.draw=function(){a.call(this);l.addEventListener("mousedown",function(){this.selectingListItem=true}.bind(this));l.addEventListener("mouseup",function(){this.selectingListItem=false}.bind(this));this.element.appendChild(l)};this.mapMarker=null;this._handleMarker=this._handleMarker.bind(this);if(this._map){if(this.options.trackProximity){this._updateProximity();this._map.on("moveend",this._updateProximity)}this._mapboxgl=this.options.mapboxgl;if(!this._mapboxgl&&this.options.marker){console.error("No mapboxgl detected in options. Map markers are disabled. Please set options.mapboxgl.");this.options.marker=false}}return e},_geolocateUser:function(){this._hideGeolocateButton();this._showLoadingIcon();this.geolocation.getCurrentPosition().then(function(t){this._hideLoadingIcon();const e={geometry:{type:"Point",coordinates:[t.coords.longitude,t.coords.latitude]}};this._handleMarker(e);this._fly(e);this._typeahead.clear();this._typeahead.selected=true;this.lastSelected=JSON.stringify(e);this._showClearButton();this.fresh=false;const i={limit:1,language:[this.options.language],query:e.geometry.coordinates,types:["address"]};if(this.options.localGeocoderOnly){const t=e.geometry.coordinates[0]+","+e.geometry.coordinates[1];this._setInputValue(t);this._eventEmitter.emit("result",{result:e})}else this.geocoderService.reverseGeocode(i).send().then(function(t){const i=t.body.features[0];if(i){const t=N.transformFeatureToGeolocationText(i,this.options.addressAccuracy);this._setInputValue(t);i.user_coordinates=e.geometry.coordinates;this._eventEmitter.emit("result",{result:i})}else this._eventEmitter.emit("result",{result:{user_coordinates:e.geometry.coordinates}})}.bind(this))}.bind(this)).catch(function(t){t.code===1?this._renderUserDeniedGeolocationError():this._renderLocationError();this._hideLoadingIcon();this._showGeolocateButton();this._hideAttribution()}.bind(this))},createIcon:function(t,e){var i=document.createElementNS("http://www.w3.org/2000/svg","svg");i.setAttribute("class","mapboxgl-ctrl-geocoder--icon mapboxgl-ctrl-geocoder--icon-"+t);i.setAttribute("viewBox","0 0 18 18");i.setAttribute("xml:space","preserve");i.setAttribute("width",18);i.setAttribute("height",18);i.innerHTML=e;return i},onRemove:function(){this.container.parentNode.removeChild(this.container);this.options.trackProximity&&this._map&&this._map.off("moveend",this._updateProximity);this._removeMarker();this._map=null;return this},_setInputValue:function(t){this._inputEl.value=t;setTimeout(function(){this._inputEl.focus();this._inputEl.scrollLeft=0;this._inputEl.setSelectionRange(0,0)}.bind(this),1)},_onPaste:function(t){var e=(t.clipboardData||window.clipboardData).getData("text");e.length>=this.options.minLength&&this._geocode(e)},_onKeyDown:function(t){var e=27,i=9;if(t.keyCode===e&&this.options.clearAndBlurOnEsc){this._clear(t);return this._inputEl.blur()}var o=t.target&&t.target.shadowRoot?t.target.shadowRoot.activeElement:t.target;var n=o?o.value:"";if(!n){this.fresh=true;t.keyCode!==i&&this.clear(t);this._showGeolocateButton();return this._hideClearButton()}this._hideGeolocateButton();t.metaKey||[i,e,37,39,13,38,40].indexOf(t.keyCode)!==-1||o.value.length>=this.options.minLength&&this._geocode(o.value)},_showButton:function(){this._typeahead.selected&&this._showClearButton()},_hideButton:function(){this._typeahead.selected&&this._hideClearButton()},_showClearButton:function(){this._clearEl.style.display="block"},_hideClearButton:function(){this._clearEl.style.display="none"},_showGeolocateButton:function(){this._geolocateEl&&this.geolocation.isSupport()&&(this._geolocateEl.style.display="block")},_hideGeolocateButton:function(){this._geolocateEl&&(this._geolocateEl.style.display="none")},_showLoadingIcon:function(){this._loadingEl.style.display="block"},_hideLoadingIcon:function(){this._loadingEl.style.display="none"},_showAttribution:function(){this._footerNode.style.display="block"},_hideAttribution:function(){this._footerNode.style.display="none"},_onBlur:function(t){this.options.clearOnBlur&&this._clearOnBlur(t);this.options.collapsed&&this._collapse()},_onChange:function(){var t=this._typeahead.selected;if(t&&JSON.stringify(t)!==this.lastSelected){this._hideClearButton();this.options.flyTo&&this._fly(t);this.options.marker&&this._mapboxgl&&this._handleMarker(t);this._inputEl.focus();this._inputEl.scrollLeft=0;this._inputEl.setSelectionRange(0,0);this.lastSelected=JSON.stringify(t);this._eventEmitter.emit("result",{result:t});this.eventManager.select(t,this)}},_fly:function(t){var e;if(t.properties&&R[t.properties.short_code]){e=B({},this.options.flyTo);this._map&&this._map.fitBounds(R[t.properties.short_code].bbox,e)}else if(t.bbox){var i=t.bbox;e=B({},this.options.flyTo);this._map&&this._map.fitBounds([[i[0],i[1]],[i[2],i[3]]],e)}else{var o={zoom:this.options.zoom};e=B({},o,this.options.flyTo);t.center?e.center=t.center:t.geometry&&t.geometry.type&&t.geometry.type==="Point"&&t.geometry.coordinates&&(e.center=t.geometry.coordinates);this._map&&this._map.flyTo(e)}},_requestType:function(t,e){var i;i=t.localGeocoderOnly?V.LOCAL:t.reverseGeocode&&N.REVERSE_GEOCODE_COORD_RGX.test(e)?V.REVERSE:V.FORWARD;return i},_setupConfig:function(t,e){const i=["bbox","limit","proximity","countries","types","language","reverseMode","mode","autocomplete","fuzzyMatch","routing","worldview"];const o=/[\s,]+/;var n=this;var s=i.reduce((function(t,e){if(n.options[e]===void 0||n.options[e]===null)return t;["countries","types","language"].indexOf(e)>-1?t[e]=n.options[e].split(o):t[e]=n.options[e];const i=typeof n.options[e].longitude==="number"&&typeof n.options[e].latitude==="number";if(e==="proximity"&&i){const i=n.options[e].longitude;const o=n.options[e].latitude;t[e]=[i,o]}return t}),{});switch(t){case V.REVERSE:var r=e.split(o).map((function(t){return parseFloat(t,10)}));n.options.flipCoordinates||r.reverse();s.types?[s.types[0]]:["poi"];s=B(s,{query:r,limit:1});["proximity","autocomplete","fuzzyMatch","bbox"].forEach((function(t){t in s&&delete s[t]}));break;case V.FORWARD:{const t=e.trim();const i=/^(-?\d{1,3}(\.\d{0,256})?)[, ]+(-?\d{1,3}(\.\d{0,256})?)?$/;i.test(t)&&(e=e.replace(/,/g," "));s=B(s,{query:e})}break}return s},_geocode:function(t){this.inputString=t;this._showLoadingIcon();this._eventEmitter.emit("loading",{query:t});const e=this._requestType(this.options,t);const i=this._setupConfig(e,t);var o;switch(e){case V.LOCAL:o=Promise.resolve();break;case V.FORWARD:o=this.geocoderService.forwardGeocode(i).send();break;case V.REVERSE:o=this.geocoderService.reverseGeocode(i).send();break}var n=this.options.localGeocoder&&this.options.localGeocoder(t)||[];var s=[];var r=null;o.catch(function(t){r=t}.bind(this)).then(function(e){this._hideLoadingIcon();var o={};if(e){if(e.statusCode=="200"){o=e.body;o.request=e.request;o.headers=e.headers}}else o={type:"FeatureCollection",features:[]};o.config=i;if(this.fresh){this.eventManager.start(this);this.fresh=false}o.features=o.features?n.concat(o.features):n;if(this.options.externalGeocoder){s=this.options.externalGeocoder(t,o.features)||Promise.resolve([]);return s.then((function(t){o.features=o.features?t.concat(o.features):t;return o}),(function(){return o}))}return o}.bind(this)).then(function(t){if(r)throw r;this.options.filter&&t.features.length&&(t.features=t.features.filter(this.options.filter));if(t.features.length){this._showClearButton();this._hideGeolocateButton();this._showAttribution();this._eventEmitter.emit("results",t);this._typeahead.update(t.features)}else{this._hideClearButton();this._hideAttribution();this._typeahead.selected=null;this._renderNoResults();this._eventEmitter.emit("results",t)}}.bind(this)).catch(function(t){this._hideLoadingIcon();this._hideAttribution();if(n.length&&this.options.localGeocoder||s.length&&this.options.externalGeocoder){this._showClearButton();this._hideGeolocateButton();this._typeahead.update(n)}else{this._hideClearButton();this._typeahead.selected=null;this._renderError()}this._eventEmitter.emit("results",{features:n});this._eventEmitter.emit("error",{error:t})}.bind(this));return o},
/**
   * Shared logic for clearing input
   * @param {Event} [ev] the event that triggered the clear, if available
   * @private
   *
   */
_clear:function(t){t&&t.preventDefault();this._inputEl.value="";this._typeahead.selected=null;this._typeahead.clear();this._onChange();this._hideClearButton();this._showGeolocateButton();this._removeMarker();this.lastSelected=null;this._eventEmitter.emit("clear");this.fresh=true},
/**
   * Clear and then focus the input.
   * @param {Event} [ev] the event that triggered the clear, if available
   *
   */
clear:function(t){this._clear(t);this._inputEl.focus()},
/**
   * Clear the input, without refocusing it. Used to implement clearOnBlur
   * constructor option.
   * @param {Event} [ev] the blur event
   * @private
   */
_clearOnBlur:function(t){var e=this;t.relatedTarget&&e._clear(t)},_onQueryResult:function(t){var e=t.body;if(e.features.length){var i=e.features[0];this._typeahead.selected=i;this._inputEl.value=i.place_name;this._onChange()}},_updateProximity:function(){if(this._map&&this.options.trackProximity)if(this._map.getZoom()>9){var t=this._map.getCenter().wrap();this.setProximity({longitude:t.lng,latitude:t.lat},false)}else this.setProximity(null,false)},_collapse:function(){this._inputEl.value||this._inputEl===document.activeElement||this.container.classList.add("mapboxgl-ctrl-geocoder--collapsed")},_unCollapse:function(){this.container.classList.remove("mapboxgl-ctrl-geocoder--collapsed")},
/**
   * Set & query the input
   * @param {string} searchInput location name or other search input
   * @returns {MapboxGeocoder} this
   */
query:function(t){this._geocode(t).then(this._onQueryResult);return this},_renderError:function(){var t="<div class='mapbox-gl-geocoder--error'>There was an error reaching the server</div>";this._renderMessage(t)},_renderLocationError:function(){var t="<div class='mapbox-gl-geocoder--error'>A location error has occurred</div>";this._renderMessage(t)},_renderNoResults:function(){var t="<div class='mapbox-gl-geocoder--error mapbox-gl-geocoder--no-results'>No results found</div>";this._renderMessage(t)},_renderUserDeniedGeolocationError:function(){var t="<div class='mapbox-gl-geocoder--error'>Geolocation permission denied</div>";this._renderMessage(t)},_renderMessage:function(t){this._typeahead.update([]);this._typeahead.selected=null;this._typeahead.clear();this._typeahead.renderError(t)},
/**
   * Get the text to use as the search bar placeholder
   *
   * If placeholder is provided in options, then use options.placeholder
   * Otherwise, if language is provided in options, then use the localized string of the first language if available
   * Otherwise use the default
   *
   * @returns {String} the value to use as the search bar placeholder
   * @private
   */
_getPlaceholderText:function(){if(this.options.placeholder)return this.options.placeholder;if(this.options.language){var t=this.options.language.split(",")[0];var e=D.language(t);var i=q.placeholder[e];if(i)return i}return"Search"},
/**
   * Set input
   * @param {string} searchInput location name or other search input
   * @param {boolean} [showSuggestions=false] display suggestion on setInput call
   * @returns {MapboxGeocoder} this
   */
setInput:function(t,e){e===void 0&&(e=false);this._inputEl.value=t;this._typeahead.selected=null;this._typeahead.clear();t.length>=this.options.minLength&&(e?this._geocode(t):this._onChange());return this},
/**
   * Set proximity
   * @param {Object|'ip'} proximity The new `options.proximity` value. This is a geographical point given as an object with `latitude` and `longitude` properties or the string 'ip'.
   * @param {Boolean} disableTrackProximity If true, sets `trackProximity` to false. True by default to prevent `trackProximity` from unintentionally overriding an explicitly set proximity value.
   * @returns {MapboxGeocoder} this
   */
setProximity:function(t,e=true){this.options.proximity=t;e&&(this.options.trackProximity=false);return this},
/**
   * Get proximity
   * @returns {Object} The geocoder proximity
   */
getProximity:function(){return this.options.proximity},
/**
   * Set the render function used in the results dropdown
   * @param {Function} fn The function to use as a render function. This function accepts a single [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) object as input and returns a string.
   * @returns {MapboxGeocoder} this
   */
setRenderFunction:function(t){t&&typeof t=="function"&&(this._typeahead.render=t);return this},
/**
   * Get the function used to render the results dropdown
   *
   * @returns {Function} the render function
   */
getRenderFunction:function(){return this._typeahead.render},
/**
   * Get the language to use in UI elements and when making search requests
   *
   * Look first at the explicitly set options otherwise use the browser's language settings
   * @param {String} language Specify the language to use for response text and query result weighting. Options are IETF language tags comprised of a mandatory ISO 639-1 language code and optionally one or more IETF subtags for country or script. More than one value can also be specified, separated by commas.
   * @returns {MapboxGeocoder} this
   */
setLanguage:function(t){var e=navigator.language||navigator.userLanguage||navigator.browserLanguage;this.options.language=t||this.options.language||e;return this},
/**
   * Get the language to use in UI elements and when making search requests
   * @returns {String} The language(s) used by the plugin, if any
   */
getLanguage:function(){return this.options.language},
/**
   * Get the zoom level the map will move to when there is no bounding box on the selected result
   * @returns {Number} the map zoom
   */
getZoom:function(){return this.options.zoom},
/**
   * Set the zoom level
   * @param {Number} zoom The zoom level that the map should animate to when a `bbox` isn't found in the response. If a `bbox` is found the map will fit to the `bbox`.
   * @returns {MapboxGeocoder} this
   */
setZoom:function(t){this.options.zoom=t;return this},
/**
   * Get the parameters used to fly to the selected response, if any
   * @returns {Boolean|Object} The `flyTo` option
   */
getFlyTo:function(){return this.options.flyTo},
/**
   * Set the flyTo options
   * @param {Boolean|Object} flyTo If false, animating the map to a selected result is disabled. If true, animating the map will use the default animation parameters. If an object, it will be passed as `options` to the map [`flyTo`](https://docs.mapbox.com/mapbox-gl-js/api/#map#flyto) or [`fitBounds`](https://docs.mapbox.com/mapbox-gl-js/api/#map#fitbounds) method providing control over the animation of the transition.
   */
setFlyTo:function(t){this.options.flyTo=t;return this},
/**
   * Get the value of the placeholder string
   * @returns {String} The input element's placeholder value
   */
getPlaceholder:function(){return this.options.placeholder},
/**
   * Set the value of the input element's placeholder
   * @param {String} placeholder the text to use as the input element's placeholder
   * @returns {MapboxGeocoder} this
   */
setPlaceholder:function(t){this.options.placeholder=t||this._getPlaceholderText();this._inputEl.placeholder=this.options.placeholder;this._inputEl.setAttribute("aria-label",this.options.placeholder);return this},
/**
   * Get the bounding box used by the plugin
   * @returns {Array<Number>} the bounding box, if any
   */
getBbox:function(){return this.options.bbox},
/**
   * Set the bounding box to limit search results to
   * @param {Array<Number>} bbox a bounding box given as an array in the format [minX, minY, maxX, maxY].
   * @returns {MapboxGeocoder} this
   */
setBbox:function(t){this.options.bbox=t;return this},
/**
   * Get a list of the countries to limit search results to
   * @returns {String} a comma separated list of countries to limit to, if any
   */
getCountries:function(){return this.options.countries},
/**
   * Set the countries to limit search results to
   * @param {String} countries a comma separated list of countries to limit to
   * @returns {MapboxGeocoder} this
   */
setCountries:function(t){this.options.countries=t;return this},
/**
   * Get a list of the types to limit search results to
   * @returns {String} a comma separated list of types to limit to
   */
getTypes:function(){return this.options.types},
/**
   * Set the types to limit search results to
   * @param {String} countries a comma separated list of types to limit to
   * @returns {MapboxGeocoder} this
   */
setTypes:function(t){this.options.types=t;return this},
/**
   * Get the minimum number of characters typed to trigger results used in the plugin
   * @returns {Number} The minimum length in characters before a search is triggered
   */
getMinLength:function(){return this.options.minLength},
/**
   * Set the minimum number of characters typed to trigger results used by the plugin
   * @param {Number} minLength the minimum length in characters
   * @returns {MapboxGeocoder} this
   */
setMinLength:function(t){this.options.minLength=t;this._typeahead&&(this._typeahead.options.minLength=t);return this},
/**
   * Get the limit value for the number of results to display used by the plugin
   * @returns {Number} The limit value for the number of results to display used by the plugin
   */
getLimit:function(){return this.options.limit},
/**
   * Set the limit value for the number of results to display used by the plugin
   * @param {Number} limit the number of search results to return
   * @returns {MapboxGeocoder}
   */
setLimit:function(t){this.options.limit=t;this._typeahead&&(this._typeahead.options.limit=t);return this},
/**
   * Get the filter function used by the plugin
   * @returns {Function} the filter function
   */
getFilter:function(){return this.options.filter},
/**
   * Set the filter function used by the plugin.
   * @param {Function} filter A function which accepts a Feature in the [Carmen GeoJSON](https://github.com/mapbox/carmen/blob/master/carmen-geojson.md) format to filter out results from the Geocoding API response before they are included in the suggestions list. Return `true` to keep the item, `false` otherwise.
   * @returns {MapboxGeocoder} this
   */
setFilter:function(t){this.options.filter=t;return this},
/**
   * Set the geocoding endpoint used by the plugin.
   * @param {Function} origin A function which accepts an HTTPS URL to specify the endpoint to query results from.
   * @returns {MapboxGeocoder} this
   */
setOrigin:function(t){this.options.origin=t;this.geocoderService=P(O({accessToken:this.options.accessToken,origin:this.options.origin}));return this},
/**
   * Get the geocoding endpoint the plugin is currently set to
   * @returns {Function} the endpoint URL
   */
getOrigin:function(){return this.options.origin},
/**
   * Set the accessToken option used for the geocoding request endpoint.
   * @param {String} accessToken value
   * @returns {MapboxGeocoder} this
   */
setAccessToken:function(t){this.options.accessToken=t;this.geocoderService=P(O({accessToken:this.options.accessToken,origin:this.options.origin}));return this},
/**
   * Set the autocomplete option used for geocoding requests
   * @param {Boolean} value The boolean value to set autocomplete to
   * @returns
   */
setAutocomplete:function(t){this.options.autocomplete=t;return this},
/**
   * Get the current autocomplete parameter value used for requests
   * @returns {Boolean} The autocomplete parameter value
   */
getAutocomplete:function(){return this.options.autocomplete},
/**
   * Set the fuzzyMatch option used for approximate matching in geocoding requests
   * @param {Boolean} value The boolean value to set fuzzyMatch to
   * @returns
   */
setFuzzyMatch:function(t){this.options.fuzzyMatch=t;return this},
/**
   * Get the current fuzzyMatch parameter value used for requests
   * @returns {Boolean} The fuzzyMatch parameter value
   */
getFuzzyMatch:function(){return this.options.fuzzyMatch},
/**
   * Set the routing parameter used to ask for routable point metadata in geocoding requests
   * @param {Boolean} value The boolean value to set routing to
   * @returns
   */
setRouting:function(t){this.options.routing=t;return this},
/**
   * Get the current routing parameter value used for requests
   * @returns {Boolean} The routing parameter value
   */
getRouting:function(){return this.options.routing},
/**
   * Set the worldview parameter
   * @param {String} code The country code representing the worldview (e.g. "us" | "cn" | "jp", "in")
   * @returns
   */
setWorldview:function(t){this.options.worldview=t;return this},
/**
   * Get the current worldview parameter value used for requests
   * @returns {String} The worldview parameter value
   */
getWorldview:function(){return this.options.worldview},
/**
   * Handle the placement of a result marking the selected result
   * @private
   * @param {Object} selected the selected geojson feature
   * @returns {MapboxGeocoder} this
   */
_handleMarker:function(t){if(this._map){this._removeMarker();var e={color:"#4668F2"};var i=B({},e,this.options.marker);this.mapMarker=new this._mapboxgl.Marker(i);t.center?this.mapMarker.setLngLat(t.center).addTo(this._map):t.geometry&&t.geometry.type&&t.geometry.type==="Point"&&t.geometry.coordinates&&this.mapMarker.setLngLat(t.geometry.coordinates).addTo(this._map);return this}},_removeMarker:function(){if(this.mapMarker){this.mapMarker.remove();this.mapMarker=null}},
/**
   * Subscribe to events that happen within the plugin.
   * @param {String} type name of event. Available events and the data passed into their respective event objects are:
   *
   * - __clear__ `Emitted when the input is cleared`
   * - __loading__ `{ query } Emitted when the geocoder is looking up a query`
   * - __results__ `{ results } Fired when the geocoder returns a response`
   * - __result__ `{ result } Fired when input is set`
   * - __error__ `{ error } Error as string`
   * @param {Function} fn function that's called when the event is emitted.
   * @returns {MapboxGeocoder} this;
   */
on:function(t,e){this._eventEmitter.on(t,e);return this},
/**
   * Remove an event
   * @returns {MapboxGeocoder} this
   * @param {String} type Event name.
   * @param {Function} fn Function that should unsubscribe to the event emitted.
   */
off:function(t,e){this._eventEmitter.removeListener(t,e);this.eventManager.remove();return this}};T=MapboxGeocoder;var Q=T;export{Q as default};

