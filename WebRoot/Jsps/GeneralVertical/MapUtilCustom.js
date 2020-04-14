var modfiedHubIdToCircle = {};
var modfiedHubIdToPolygon = {};

function plotBuffersForSmartHub() {
    modfiedHubIdToCircle = {};
    for (var i = 0; i < bufferStoreSmartHub.getCount(); i++) {
        var rec = bufferStoreSmartHub.getAt(i);
        var urlForZero = '/ApplicationImages/VehicleImages/red.png';
        var convertRadiusToMeters = rec.data['radius'] * 1000;
        var myLatLng = new L.LatLng(rec.data['latitude'], rec.data['longitude']);

        bufferimage = L.icon({
            iconUrl: String(urlForZero),
            iconSize: [19, 35], // size of the icon
            popupAnchor: [0, -15]
        });

        buffermarker = new L.Marker(myLatLng, {
            icon: bufferimage
        }).addTo(mapView);

        buffermarker.bindPopup(rec.data['buffername']);

        buffermarkersmart[i] = buffermarker;
        circle = L.circle(myLatLng, {
            color: '#A7A005',
            fillColor: '#ECF086',
            fillOpacity: 0.55,
            center: myLatLng,
            radius: convertRadiusToMeters //In meters
        }).addTo(mapView);
        circlessmart[i] = circle;

        // TODO Need to add editing option for hubs
    }
}

function plotPolygonSmartHub() {
    var hubid = 0;
    var polygonCoords = [];
    modfiedHubIdToPolygon = {};
    for (var i = 0; i < polygonStoreSmartHub.getCount(); i++) {
        var rec = polygonStoreSmartHub.getAt(i);
        if (i != polygonStoreSmartHub.getCount() - 1 && rec.data['hubid'] == polygonStoreSmartHub.getAt(i + 1).data['hubid']) {
            var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
            polygonCoords.push(latLong);
            continue;
        } else {
            var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
            polygonCoords.push(latLong);
        }
        polygon = L.polygon(polygonCoords).addTo(mapView);

        polygonimage = L.icon({
            iconUrl: '/ApplicationImages/VehicleImages/red.png',
            iconSize: [48, 48], // size of the icon
            popupAnchor: [0, -15]
        });

        polygonmarker = new L.Marker(latLong, {
            icon: polygonimage
        }).addTo(mapView);
        polygonmarker.bindPopup(rec.data['polygonname']);
        // TODO Need to add editing option for polygon
        polygonsmart[hubid] = polygon;
        polygonmarkersmart[hubid] = polygonmarker;
        hubid++;
        polygonCoords = [];

    }
}