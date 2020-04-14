<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
    <%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
 	
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	String systemID = Integer.toString(systemid);
 	int customeridlogged = loginInfo.getCustomerId();
 	String customernamelogged = "null";
 	String vehicleTypeRequest = "all";
 	if (request.getParameter("vehicleType") != null) {
 		vehicleTypeRequest = request.getParameter("vehicleType");
 	}
 	if (customeridlogged > 0) {
 		customernamelogged = loginInfo.getCustomerName();
 	}
 	int userId = loginInfo.getUserId();
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	
 	String Location="Location";
 	String Latitude="Latitude";
 	String Longitude="Longitude";
 	String WorkLocationDetails="Work Location Details";
 %>
 <!DOCTYPE html>
<html>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">

<title>Map</title>

<head>
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/mapView/css/component.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/mapView/css/layout.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
    <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
    <pack:script src="../../Main/Js/Common.js"></pack:script>

    <!-- for grid -->
    <pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
    <pack:script src="../../Main/Js/Jquery-min.js"></pack:script>
    <pack:style src="../../Main/resources/css/ext-all.css" />
    <pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
    <pack:style src="../../Main/resources/css/common.css" />
    <pack:style src="../../Main/resources/css/commonnew.css" />
    <pack:script src="../../Main/Js/examples1.js"></pack:script>
    <pack:style src="../../Main/resources/css/examples1.css" />

    <!-- for grid -->
    <pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
    <pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
</head>
<style>
    #pac-input {
        background-color: #fff;
        padding: 0 11px 0 13px;
        width: 400px;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        text-overflow: ellipsis;
    }
    .controls {
        margin-top: 6px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 32px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
    }
    body {
        background-color: #FFFFFF;
    }
    html {
        overflow-x: hidden;
        overflow-y: hidden;
    }
    .x-panel-header {
        height: 40px !important;
    }
    .x-panel-body {
        margin-top: 10px;
    }
    .x-panel-footer {
        padding: 0px;
    }
    #locationLabelId2 {
        margin-left: 8px;
    }
    #latitudeLabelId2 {
        margin-left: 10px;
    }
</style>
<script src=<%=GoogleApiKey%>></script> 

<body>
    <div class="container">
        <div class="main">
            <div class="mp-vehicle-wrapper" id="location-details"></div>
            <div class="mp-container" id="mp-container">
                <div class="mp-map-wrapper" id="map"></div>
                <div class="mp-options-wrapper">
                    <input id="pac-input" class="controls" type="text" placeholder="Search Places">
                </div>
            </div>
        </div>
    </div>
    <script>
        var markers = {};
        var outerPanel;
        var tsb;
        var marker;
        var mapOptions = {
            zoom: 5,
            center: new google.maps.LatLng('14.9694557','75.2940712'), //21.0256378,75.9542144
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var LatLng = new google.maps.LatLng('0.0', '0.0');
        var map = new google.maps.Map(document.getElementById('map'), mapOptions)
        var input = (document.getElementById('pac-input'));
        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);
        var searchBox = new google.maps.places.SearchBox(input);
        google.maps.event.addListener(searchBox, 'places_changed', function() {
            var places = searchBox.getPlaces();
            if (places.length == 0) {
                return;
            }
            for (var i = 0, marker; marker = markers[i]; i++) {
                marker.setMap(null);
            }
            markers1 = [];
            var bounds = new google.maps.LatLngBounds();
            for (var i = 0, place; place = places[i]; i++) {
                var image = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25)
                };
                bounds.extend(place.geometry.location);
            }
            map.fitBounds(bounds);
            if (map.getZoom() > 16) map.setZoom(15);

        });
        google.maps.event.addListener(map, 'bounds_changed', function() {
            var bounds = map.getBounds();
            searchBox.setBounds(bounds);
        });
        google.maps.event.addListener(map, 'click', function(event) {
            if (marker != null) {
                marker.setMap(null);
            }
            var latitude = event.latLng.lat().toFixed(5);
            var longitude = event.latLng.lng().toFixed(5);
            Ext.getCmp('latitudeId').setValue(latitude);
            Ext.getCmp('longitudeId').setValue(longitude);
            var LatLng = new google.maps.LatLng(latitude, longitude);
            var geocoder;
            geocoder = new google.maps.Geocoder();
            var latlng = new google.maps.LatLng(latitude, longitude);
            geocoder.geocode({'latLng': latlng }, function(results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[0]) {
                        var add = results[0].formatted_address;
                        var value = add.split(",");
                        Ext.getCmp('locationId').setValue(value);
                    } else {
                        alert("address not found");
                    }
                } 
            });
            marker = new google.maps.Marker({
                position: LatLng,
                map: map
            });
        });

        var ButtonPanel = new Ext.Panel({
            id: 'buttonPanelId',
            standardSubmit: true,
            collapsible: false,
            autoHeight: true,
            height: 100,
            width: 275,
            frame: false,
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            buttons: [{
                xtype: 'button',
                text: 'Save & Continue',
                id: 'backButtId',
                iconCls: 'backbutton',
                width: 70,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('locationId').getValue() == "" ) {
                                Ext.example.msg("Select Location On Map");
                                return;
                            }
                            if (Ext.getCmp('latitudeId').getValue() == "") {
                                Ext.example.msg("Select Location On Map");
                                return;
                            }
                            parent.Ext.getCmp('enrolmentId').enable();
                            parent.Ext.getCmp('enrolmentId').show();
                            Ext.Ajax.request({
                                url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=addLocationDetails',
                                method: 'POST',
                                params: {
                                    location: Ext.getCmp('locationId').getValue(),
                                    latitude: Ext.getCmp('latitudeId').getValue(),
                                    longitude: Ext.getCmp('longitudeId').getValue()
                                },
                                success: function(response, options) {
                                    var message = response.responseText;
                                    Ext.example.msg(message);
                                    Ext.getCmp('locationId').reset();
                                    Ext.getCmp('latitudeId').reset();
                                    Ext.getCmp('longitudeId').reset();
                                },
                                failure: function() {
                                    Ext.example.msg("Error");
                                }
                            });
                        }
                    }
                }
            }]
        });
        var locationDetails = new Ext.Panel({
            id: 'consumerDetailsId',
            id: 'locationDetailsPannel',
            height: 529,
            title: '<%=WorkLocationDetails%>',
            layoutConfig: {
                columns: 4
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'locationEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Location%>' + ' :',
                cls: 'labelstyle',
                id: 'locationLabelId'
            }, {
                xtype: 'label',
                text: '',
                id: 'locationLabelId2'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                allowBlank: false,
                blankText: 'Select Location On Map',
                emptyText: 'Select Location On Map',
                id: 'locationId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'latitudeEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Latitude%>' + ' :',
                cls: 'labelstyle',
                id: 'latitudeLabelId'
            }, {
                xtype: 'label',
                text: '',
                id: 'latitudeLabelId2'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                readOnly: true,
                allowBlank: false,
                emptyText: '',
                id: 'latitudeId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'longitudeEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Longitude%>' + ' :',
                cls: 'labelstyle',
                id: 'longitudeLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                readOnly: true,
                allowBlank: false,
                emptyText: '',
                id: 'longitudeId'
            }, ButtonPanel]
        });
        locationDetails.render('location-details');
    </script>
</body>

</html>          