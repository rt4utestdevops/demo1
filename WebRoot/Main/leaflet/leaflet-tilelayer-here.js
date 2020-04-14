

// Tile layer for HERE maps tiles.
L.TileLayer.HERE = L.TileLayer.extend({

	options: {
		subdomains: '1234',
		minZoom: 2,
		maxZoom: 18,

		// The "map scheme", as documented in the HERE API.
		scheme: 'normal.day',

		// The "map resource", as documented in the HERE API.
		resource: 'maptile',

		
		// Version of the map tiles to be used, or a hash of an unique map
		mapId: 'newest',

		
		// Image format to be used (`png8`, `png`, or `jpg`)
		format: 'png8',

		
		// Required option. The `app_id` provided as part of the HERE credentials
		appId: '',

		
		// Required option. The `app_code` provided as part of the HERE credentials
		appCode: '',
		
		pois :'true',
	},


	initialize: function initialize(options) {
		options = L.setOptions(this, options);

		// Decide if this scheme uses the aerial servers or the basemap servers
		var schemeStart = options.scheme.split('.')[0];
		
		options.tileResolution = 256;

		if (L.Browser.retina) {
			options.tileResolution = 512;
		}
		var path = '/{resource}/2.1/{resource}/{mapId}/{scheme}/{z}/{x}/{y}/{tileResolution}/{format}?app_id={appId}&app_code={appCode}&pois={pois}&congestion=true&lg=eng';
		var attributionPath = '/maptile/2.1/copyright/{mapId}?app_id={appId}&app_code={appCode}';

		var tileServer = 'base.maps.api.here.com';
		if (schemeStart == 'satellite' ||
				schemeStart == 'terrain' ||
				schemeStart == 'hybrid') {
			tileServer = 'aerial.maps.api.here.com';
		}
		if (options.scheme.indexOf('.traffic.') !== -1) {
			tileServer = 'traffic.maps.api.here.com';
			
			path = '/maptile/2.1/traffictile/{mapId}/{scheme}/{z}/{x}/{y}/{tileResolution}/{format}?app_id={appId}&app_code={appCode}&pois={pois}&min_traffic_congestion=heavy';
			
		}
	
			if(options.scheme == "hybrid.day.mobile" || options.scheme == "carnav.day.grey" || options.scheme == "hybrid.day.mobile" || options.scheme == "normal.day.custom" ||
					options.scheme == "normal.day.grey.mobile" || options.scheme == "normal.day.mobile" || options.scheme == "normal.day.transit.mobile" ||
					options.scheme == "normal.night.grey.mobile" || options.scheme == "normal.day.mobile" || options.scheme == "pedestrian.day.mobile" ||
					options.scheme == "pedestrian.night.mobile" || options.scheme == "satellite.day" || options.scheme == "terrain.day.mobile")
			{
				
			}
			else
			{
				path = path + '&ppi=500';
				
			}

		var tileUrl = 'https://{s}.' + tileServer + path;

		this._attributionUrl = L.Util.template('https://1.' + tileServer , this.options);

		L.TileLayer.prototype.initialize.call(this, tileUrl, options);

		this._attributionText = '';

	},

	onAdd: function onAdd(map) {
		L.TileLayer.prototype.onAdd.call(this, map);

		if (!this._attributionBBoxes) {
			this._fetchAttributionBBoxes();
		}
	},

	onRemove: function onRemove(map) {
		L.TileLayer.prototype.onRemove.call(this, map);

		this._map.attributionControl.removeAttribution(this._attributionText);

		this._map.off('moveend zoomend resetview', this._findCopyrightBBox, this);
	},

	_fetchAttributionBBoxes: function _onMapMove() {
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange = L.bind(function(){
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				this._parseAttributionBBoxes(JSON.parse(xmlhttp.responseText));
			}
		}, this);
		xmlhttp.open("GET", this._attributionUrl, true);
		xmlhttp.send();
	},

	_parseAttributionBBoxes: function _parseAttributionBBoxes(json) {
		if (!this._map) { return; }
		var providers = json[this.options.scheme.split('.')[0]] || json.normal;
		for (var i=0; i<providers.length; i++) {
			if (providers[i].boxes) {
				for (var j=0; j<providers[i].boxes.length; j++) {
					var box = providers[i].boxes[j];
					providers[i].boxes[j] = L.latLngBounds( [ [box[0], box[1]], [box[2], box[3]] ]);
				}
			}
		}

		this._map.on('moveend zoomend resetview', this._findCopyrightBBox, this);

		this._attributionProviders = providers;

		this._findCopyrightBBox();
	},

	_findCopyrightBBox: function _findCopyrightBBox() {
		if (!this._map) { return; }
		var providers = this._attributionProviders;
		var visibleProviders = [];
		var zoom = this._map.getZoom();
		var visibleBounds = this._map.getBounds();

		for (var i=0; i<providers.length; i++) {
			if (providers[i].minLevel < zoom && providers[i].maxLevel > zoom)

			if (!providers[i].boxes) {
				// No boxes = attribution always visible
				visibleProviders.push(providers[i]);
				break;
			}

			for (var j=0; j<providers[i].boxes.length; j++) {
				var box = providers[i].boxes[j];
				if (visibleBounds.overlaps(box)) {
					visibleProviders.push(providers[i]);
					break;
				}
			}
		}

		var attributions = ['<a href="https://legal.here.com/terms/serviceterms/gb/">HERE maps</a>'];
		for (var i=0; i<visibleProviders.length; i++) {
			var provider = visibleProviders[i];
			attributions.push('<abbr title="' + provider.alt + '">' + provider.label + '</abbr>');
		}

		var attributionText = ' ' + attributions.join(', ') + '. ';

		if (attributionText !== this._attributionText) {
			this._map.attributionControl.removeAttribution(this._attributionText);
			this._map.attributionControl.addAttribution(this._attributionText = attributionText);
		}
	},

});


L.tileLayer.here = function(opts){
	return new L.TileLayer.HERE(opts);
}
