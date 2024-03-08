# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@2.15.0/dist/mapbox-gl.js"
pin "process" # @2.0.1
pin "@mapbox/mapbox-gl-geocoder", to: "https://ga.jspm.io/npm:@mapbox/mapbox-gl-geocoder@5.0.1/lib/index.js"
pin "#lib/client.js", to: "https://ga.jspm.io/npm:@mapbox/mapbox-sdk@0.13.7/lib/browser/browser-client.js"
pin "@mapbox/fusspot", to: "https://ga.jspm.io/npm:@mapbox/fusspot@0.4.0/lib/index.js"
pin "@mapbox/mapbox-sdk", to: "https://ga.jspm.io/npm:@mapbox/mapbox-sdk@0.13.7/index.js"
pin "@mapbox/mapbox-sdk/services/geocoding", to: "https://ga.jspm.io/npm:@mapbox/mapbox-sdk@0.13.7/services/geocoding.js"
pin "@mapbox/parse-mapbox-token", to: "https://ga.jspm.io/npm:@mapbox/parse-mapbox-token@0.2.0/index.js"
pin "stimulus-flatpickr", to: "https://ga.jspm.io/npm:stimulus-flatpickr@3.0.0-0/dist/index.m.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.9/dist/flatpickr.js"
pin "stimulus-autocomplete", to: "https://ga.jspm.io/npm:stimulus-autocomplete@3.0.0-rc.5/src/autocomplete.js"
pin "sweetalert" # @2.1.2
pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.1.3
pin "star-rating.js" # @4.3.0
