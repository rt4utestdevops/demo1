var baselayers={};
var overlayMaps = {};
var languageLayer;

function initializeMapView(mapId,position,mapName,appKey,appCode) {
    var here1 = L.tileLayer("https://1.base.maps.cit.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id="+appKey+"&app_code="+appCode, {
        styleId: 997
    })
    var osm1 = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    });
    
    mapView = new L.Map(mapId, {
        fullscreenControl: {
            pseudoFullscreen: false
        },
        tms: true,
        center: position,
        zoom: 4,
        tileResolution: 256,
        maxZoom : 18
    });
	var baseMaps = {};
	if (mapName == 'HERE') {
        baseMaps["HERE"] = here1;
        baseMaps["OSM"] = osm1;
    } else {
         baseMaps["OSM"] = osm1;
    }
	var overlayMaps = {};
    L.control.layers(baseMaps).addTo(mapView);
    if (mapName == 'HERE') {
    	baseMaps["HERE"].addTo(mapView);
    } else {
    	baseMaps["OSM"].addTo(mapView);
    }
}
function initialize(mapId,position,mapName,appKey,appCode) {
    var osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    });
	var mmitraffic = new L.tileLayer('https://mt1.mapmyindia.com/advancedmaps/v1/37ktloc3q4kui5kjkblm8rs21jpcxw4c/traffic_tile/{z}/{x}/{y}.png',{attribution: " "});
	
    map = new L.Map(mapId, {
        fullscreenControl: {
            pseudoFullscreen: false
        },
        collapsibleGroups: true,
        collapsed: true,
        tms: true,
        center: position,
        tileResolution: 256,
        maxZoom : 18,
        minZoom: 4,
        zoom: 4
    });

    var schemes = [
   		'normal.day',
   		'hybrid.day.transit',
   		'satellite.day',
   	    'normal.traffic.day',
   		'hybrid.day',
   		'normal.day.grey',
   		'normal.day.transit',
   		'normal.night.transit',
   		'normal.day.custom',
   		'normal.night',
   		'normal.night.grey',
   		'pedestrian.day',
   		'pedestrian.day.mobile',
   		'pedestrian.night',
   		'pedestrian.night.mobile',
   		'carnav.day.grey',
   		'normal.day.mobile',
   		'normal.day.grey.mobile',
   		'normal.day.transit.mobile',
   		'normal.night.transit.mobile',
   		'normal.night.mobile',
   		'normal.night.grey.mobile',
   		'reduced.day',
   		'reduced.night',
   		'terrain.day',
   		'hybrid.grey.day',
   		'terrain.day.mobile',
   		'hybrid.day.mobile' 
   	];
    
	
	var pois='true';
	var nocp = 'true';
	if (mapName == 'HERE') {
		for (var i =0;i<schemes.length;i++) {
       		var scheme = schemes[i];
       		baselayers[scheme] = L.tileLayer.here({
       			appId: appKey,
       			appCode: appCode,
       			scheme: scheme,
       			poi: pois
       		});
    	}
		baselayers["OSM"] = osm;
		
		traffic    = createLayer("normal.day", "flowtile",appKey,appCode), 
		transport  = createLayer("normal.day", "truckonlytile",appKey,appCode);
		languageLayer = createLanguageLayer("normal.day", "truckonlytile",'<%=appKey%>', '<%=appCode%>','hin');
		
		map.addLayer(mmitraffic);
		map.addLayer(transport);
		map.addLayer(traffic);
		overlayMaps = {
			"Traffic": traffic,
			"Transport": transport,
			"Hindi" : languageLayer,
			"MMI Traffic" : mmitraffic
			
		};
    } else {
    	
    	var sat= L.esri.basemapLayer('Imagery');
    	var satlbl= L.esri.basemapLayer('ImageryLabels');
    	baselayers["OSM"] = osm;
    	baselayers["SAT"] = sat;
    	map.addLayer(satlbl);
    	overlayMaps = {
    			"LABELS": satlbl
    	};
    }
    layerControl = L.control.layers(baselayers, overlayMaps).addTo(map);
    if (mapName == 'HERE') {
    	baselayers["normal.day"].addTo(map);
    } else {
    	baselayers["OSM"].addTo(map);
    }
    
	map.on("baselayerchange", function(e){
		setTimeout(function(){
			map.removeLayer(languageLayer);
			if(e.name === 'hybrid.day.transit' || e.name === 'satellite.day' || e.name === 'OSM' ||
			e.name === 'normal.traffic.day' || e.name === 'hybrid.day' || e.name === 'normal.day.grey' ||
			e.name === 'normal.day.transit' || e.name === 'normal.night.transit' || e.name === 'normal.day.custom' || e.name === 'normal.night' ||
			e.name === 'normal.night.grey' || e.name === 'pedestrian.day' || e.name === 'pedestrian.day.mobile' ||
			e.name === 'pedestrian.night' || e.name === 'pedestrian.night.mobile' || e.name === 'carnav.day.grey' ||
			e.name === 'normal.day.mobile' || e.name === 'normal.day.grey.mobile' || e.name === 'normal.day.transit.mobile' ||
			e.name === 'normal.night.transit.mobile' || e.name === 'normal.night.mobile' || e.name === 'normal.night.grey.mobile' ||
			e.name === 'reduced.day' || e.name === 'reduced.night' || e.name === 'terrain.day' || e.name === 'hybrid.grey.day' ||
			e.name === 'terrain.day.mobile' || e.name === 'hybrid.day.mobile'){
				layerControl.removeLayer(languageLayer);
			} else {
				layerControl.addOverlay(languageLayer,'Hindi');
			}
		},1000);
   });
   /* map.on('overlayadd', function(eo) {
    if (eo.name === 'Hindi'){
        setTimeout(function(){map.removeLayer(cities2)}, 10);
    } else {
        setTimeout(function(){map.removeLayer(cities1)}, 10);
    }
    }); */
   
}
function createLayer(scheme, tiletype, appKey, appCode) {
    var type = 'base';
    if (scheme.indexOf("hybrid") != -1 || scheme.indexOf("terrain") != -1 || scheme.indexOf("satellite") != -1) {
        type = 'aerial';
    }
    if (tiletype.indexOf("flowtile") != -1) {
        type = 'traffic';
    }

    baseUrl = ['https://{s}.',
        type,
        '.maps.cit.api.here.com/maptile/2.1/',
        tiletype,
        '/newest/',
        scheme,
        '/{z}/{x}/{y}/256/png8?app_id=',
        appKey,
        '&app_code=',
        appCode,
        ((tiletype.indexOf('truckonlytile') != -1) ? "&style=fleet" : "")
    ].join("");
    layer = L.tileLayer(baseUrl, {
        subdomains: '1234',
        attribution:  '',
        maxZoom: 18
    });
    return layer;
}

function createLanguageLayer(scheme, tiletype, appKey, appCode,lang) {
    var type = 'base';
     baseUrl = ['https://{s}.' + 'base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=',
     appKey,
     '&app_code=',
     appCode,
	 '&lg=',lang,'&ppi=500&pois=true&congestion=true'].join(""); 
    layer = L.tileLayer(baseUrl, {
        subdomains: '1234',
        attribution:  '',
        maxZoom: 18
    });
    return layer;
}
