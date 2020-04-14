<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");

String language=loginInfo.getLanguage();
//getting client id
int customeridlogged=loginInfo.getCustomerId();
int countryId = loginInfo.getCountryCode();
String countryName = cf.getCountryName(countryId);
%>

       <jsp:include page="../Common/header.jsp" />

            <title>Create Route Hub</title>
            <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&v=3.93&amp;sensor=false&amp;libraries=places,drawing&region=IN"></script>
        
        <style>
            .x-panel-tl {
                border-bottom: 1px solid !important;
            }

            .x-panel-header-text {
                font-family: 'Cambria';
                text-align: center;
            }

            .labelstyleNew {
                spacing: 10px;
                height: 20px;
                width: 150 px !important;
                min-width: 150px !important;
                font-size: 12px;
                font-family: sans-serif;
                margin: 10px 15px 15px 15px !important;
            }

            .x-form-check-wrap {
                line-height: 18px;
                height: auto;
                font-size: initial;
            }

            #radioPanelId {
                margin-top: 0px;
            }
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
        </style>

        
            <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
                <jsp:include page="../Common/ImportJSSandMining.jsp" />
                <%}else {%>
                    <jsp:include page="../Common/ImportJS.jsp" />
                    <%} %>
                        <script>
                            var map;
                            var drawingManager;
                            var markers = null;
                            var pointer = null;
                            var circles = null;
                            var polygons = null;
                            var circlesPlot = [];
                            var latitude = [];
                            var longitude = [];
                            var buffermarkers = [];
                            var polygonsPlot = [];
                            var polygonmarkers = [];
                            var borderPolylines = [];
                            var countryName = '<%=countryName%>';
                            var Lat;
                            var Lng;
                            var circle;
					   	    var polygonNew;

                            function loadMap() {

                                var mapOptions = {
                                    center: new google.maps.LatLng(23.524681, 77.810561),
                                    zoom: 5,
                                    mapTypeId: google.maps.MapTypeId.ROADMAP
                                };

                                map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
                                var geocoder = new google.maps.Geocoder();
                                geocoder.geocode({
                                    'address': countryName
                                }, function(results, status) {
                                    if (status == google.maps.GeocoderStatus.OK) {
                                        map.setCenter(results[0].geometry.location);
                                        map.fitBounds(results[0].geometry.viewport);
                                    }
                                });

                                var type = Ext.getCmp('loccomboId').value;
                                var mode;
                                var dmodes;
                                if (type == 1) {
                                    mode = google.maps.drawing.OverlayType.CIRCLE;
                                    dmodes = 'circle';
                                } else if (type == 2) {
                                    mode = google.maps.drawing.OverlayType.POLYGON;
                                    dmodes = 'polygon';
                                }

                                drawingManager = new google.maps.drawing.DrawingManager({
                                    drawingMode: mode,
                                    drawingControl: true,
                                    drawingControlOptions: {
                                        position: google.maps.ControlPosition.TOP_CENTER,
                                        drawingModes: [dmodes]
                                    },
                                    circleOptions: {
                                        fillColor: '',
                                        fillOpacity: 0.1,
                                        strokeWeight: 2,
                                        clickable: false,
                                        editable: true,
                                        zIndex: 1
                                    }
                                });
                                drawingManager.setMap(map);
                                google.maps.event.addListener(drawingManager, 'markercomplete', function(marker) {
                                    if (Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value == undefined) {
                                        marker.setMap(null);
                                        Ext.example.msg("Select Location Type");
                                        Ext.getCmp('loccomboId').focus();
                                        return;
                                    }
                                    Ext.getCmp('saveLabelId').enable();
                                    markers = marker;
                                    if (pointer != null) {
                                        pointer.setMap(null);
                                    }
                                    marker.setOptions({
                                        draggable: true
                                    });
                                    google.maps.event.addListener(marker, 'dragend', function() {

                                        var objLatLng = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
                                        Lat = objLatLng[0];
                                        Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
                                        Lng = objLatLng[1];
                                        Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma

                                    });

                                    google.maps.event.addListener(map, 'click', function(event) {
                                        if (Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value == undefined) {
                                            marker.setMap(null);
                                            Ext.example.msg("Select Location Type");
                                            Ext.getCmp('loccomboId').focus();
                                            return;
                                        } else {
                                            marker.setPosition(event.latLng);
                                            Lat = event.latLng.lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
                                            Lng = event.latLng.lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
                                        }
                                    });

                                    drawingManager.setOptions({
                                        drawingControl: false
                                    });
                                    drawingManager.setDrawingMode(null);
                                    var objLatLng = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
                                    Lat = objLatLng[0];
                                    Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
                                    Lng = objLatLng[1];
                                    Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1").trim(); // Set 5 Digits after comma
                                });

                                google.maps.event.addListener(drawingManager, 'circlecomplete', function(circle) {
                                    Ext.getCmp('saveLabelId').enable();
                                    circles = circle;
                                    drawingManager.setOptions({
                                        drawingControl: false
                                    });
                                    drawingManager.setDrawingMode(null);

                                    google.maps.event.addListener(circle, 'radius_changed', function() {
                                        radius = circle.getRadius() / 1000;
                                        Lat = circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                        Lng = circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                    });

                                    google.maps.event.addListener(circle, 'center_changed', function() {
                                        radius = circle.getRadius() / 1000;
                                        Lat = circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                        Lng = circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                        var pos = new google.maps.LatLng(Lat, Lng);
                                        if (markers == null) {
                                            if (pointer != null) {
                                                pointer.setPosition(pos);
                                            }
                                        } else {
                                            markers.setPosition(pos);
                                        }
                                    });

                                });
                                google.maps.event.addListener(drawingManager, 'polygoncomplete', function(polygon) {

                                    polygons = polygon;
                                    Ext.getCmp('saveLabelId').enable();
                                    var polygonBounds = polygon.getPath();
                                    latitude = [];
                                    longitude = [];
                                    for (var i = 0; i < polygonBounds.length; i++) {
                                        latitude.push(polygonBounds.getAt(i).lat());
                                        longitude.push(polygonBounds.getAt(i).lng());
                                        //google.maps.event.addListener(polygon,'click', showInfoWindow);

                                    }
                                    polygon.setOptions({
                                        editable: true
                                    });

                                    drawingManager.setOptions({
                                        drawingControl: false
                                    });
                                    drawingManager.setDrawingMode(null);

                                    function showInfoWindow(event) {
                                        var contentString = '<b>Latitude: </b>' + event.latLng.lat() + '<br>' +
                                            '<b>Longitude: </b>' + event.latLng.lng();
                                        infoWindow.setContent(contentString);
                                        infoWindow.open(map);
                                        infoWindow.setPosition(event.latLng);
                                    }

                                    google.maps.event.addListener(polygon.getPath(), 'set_at', function() {
                                        latitude = [];
                                        longitude = [];

                                        var len = polygon.getPath().getLength();
                                        for (var i = 0; i < len; i++) {
                                            latitude.push(polygon.getPath().getAt(i).lat());
                                            longitude.push(polygon.getPath().getAt(i).lng());
                                        }
                                    });
                                    google.maps.event.addListener(polygon.getPath(), 'insert_at', function() {
                                        latitude = [];
                                        longitude = [];
                                        var len = polygon.getPath().getLength();
                                        for (var i = 0; i < len; i++) {
                                            latitude.push(polygon.getPath().getAt(i).lat());
                                            longitude.push(polygon.getPath().getAt(i).lng());
                                        }
                                    });

                                });
                            }
                            setTimeout(function() {
                                loadMap();
                            }, 500);

                            /*******************resize window event function**********************/
                            Ext.EventManager.onWindowResize(function() {
                                var width = '100%';
                                var height = '100%';
                                outerPanel.setSize(width, height);
                                outerPanel.doLayout();
                            });
                            /*******************End of resize window event function**********************/

                            var outerPanel;
                            var informationPanel;
                            var mapPannel;

                            var clientcombostore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                                id: 'CustomerStoreId',
                                root: 'CustomerRoot',
                                autoLoad: true,
                                remoteSort: true,
                                fields: ['CustId', 'CustName'],
                                listeners: {
                                    load: function(custstore, records, success, options) {
                                        if (<%= customeridlogged %> > 0) {
                                            Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                                            custId = Ext.getCmp('custcomboId').getValue();

                                        }
                                    }
                                }
                            });

                            var custCombo = new Ext.form.ComboBox({
                                store: clientcombostore,
                                id: 'custcomboId',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: 'Select Customer',
                                selectOnFocus: true,
                                allowBlank: false,
                                anyMatch: true,
                                typeAhead: false,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'CustId',
                                width: 170,
                                displayField: 'CustName',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {

                                        }
                                    }
                                }
                            });
                            
                            var polyStore=new Ext.data.JsonStore({
								url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getPolygonData',
								id:'polyId',
								root: 'polyRoot',
								autoLoad: false,
								remoteSort: true,
								fields: ['longitude','latitude','sequence','hubid','radius']
						    });
                            
                            var locationstore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getLocation',
                                id: 'locStoreId',
                                root: 'locationRoot',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['locId', 'locName','speedLimitId','status','locType'],
                                listeners: {
                                    
                                }
                            });

                            var locationCombo = new Ext.form.ComboBox({
                                store: locationstore,
                                id: 'locationComboId',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: 'Select Location',
                                selectOnFocus: true,
                                allowBlank: false,
                                anyMatch: true,
                                typeAhead: false,
                                hidden:true,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'locId',
                                width: 170,
                                displayField: 'locName',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {
                                        var row = locationstore.findExact('locId',Ext.getCmp('locationComboId').getValue());
					                    var rec = locationstore.getAt(row);
					                    speed = rec.data['speedLimitId'];
					                    Ext.getCmp('speedTextId').setValue(speed);
					                    Ext.getCmp('statusId').setValue(rec.data['status']);
					                    Ext.getCmp('loccomboId').setValue(rec.data['locType']);
					                    var loc=Ext.getCmp('locationComboId').getValue();
					                    var latitudePolygon=[];
					                    var longitudePolygon=[];
					                    var polygonCoords=[];
					                    polyStore.load({
					   	                    params: {
					   	               			 hubId: Ext.getCmp('locationComboId').getValue()
					   	           				},
					   	                        callback: function() {
					   	                            var latLong;
					   	                            for (var i = 0; i < polyStore.getCount(); i++) {
					   	                                var rec = polyStore.getAt(i);
					   	                                if (i != polyStore.getCount()  && loc == polyStore.getAt(i).data['hubid']) {
					   	                                    latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
					   	                                    polygonCoords.push(latLong);
					   	                                    latitudePolygon.push(rec.data['latitude']);
					   	                                    longitudePolygon.push(rec.data['longitude']);
					   	                                    continue;
					   	                                }
					   	                            }
					   	                            if(polyStore.getCount()==1){
							   	                        var convertintomtrs = rec.data['radius'] * 1000;
							   	                        if(circle!=null){
          													circle.setMap(null);
       													}
       													if(polygonNew!=null){
          													polygonNew.setMap(null);
       													}
													    myLatLng = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
												        createCircle = {
												            strokeColor: '#FF8000',
												            strokeOpacity: 0.8,
												            strokeWeight: 2,
												            fillColor: '#FF8000',
												            fillOpacity: 0.35,
												            map: map,
												            center: myLatLng,
												            radius: convertintomtrs //In meter
												        };
												        circle = new google.maps.Circle(createCircle);
												        circle.setCenter(myLatLng);
												        map.fitBounds(circle.getBounds());
					   	                            }else{
					   	                            	if(circle!=null){
          													circle.setMap(null);
       													}
       													if(polygonNew!=null){
          													polygonNew.setMap(null);
       													}
					   	                             polygonNew = new google.maps.Polygon({
					   	                                paths: polygonCoords,
					   	                                map: map,
					   	                                strokeColor: '#A7A005',
					   	                                strokeOpacity: 0.8,
					   	                                strokeWeight: 3,
					   	                                fillColor: '#ECF086',
					   	                                fillOpacity: 0.55,
					   	                                editable: true
					   	                            }); //polygon
					   	                            bounds = new google.maps.LatLngBounds();
					   	                            for (i = 0; i < polygonCoords.length; i++) {
					   	                                bounds.extend(polygonCoords[i]);
					   	                            }
					   	                            map.fitBounds(bounds);
					   	                            
					   	                            }
					   	                        }
					   	                    });
					   	                     
                                        }
                                    }
                                }
                            });

                            var locTypeComboStore = new Ext.data.SimpleStore({
                                id: 'locationTypeStoreId',
                                autoLoad: true,
                                fields: ['LocTypeId', 'LocTyeName'],
                                data: [
                                    ['1', 'Buffer'],
                                    ['2', 'Polygon']
                                ]
                            });

                            var locTypeCombo = new Ext.form.ComboBox({
                                store: locTypeComboStore,
                                id: 'loccomboId',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: 'Select Location Type',
                                selectOnFocus: true,
                                allowBlank: false,
                                anyMatch: true,
                                typeAhead: false,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'LocTypeId',
                                width: 170,
                                displayField: 'LocTyeName',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {
                                            loadMap();
                                            Ext.getCmp('CheckboxId').reset();
                                        }
                                    }
                                }
                            });

                            var statusComboStore = new Ext.data.SimpleStore({
                                id: 'statusStoreId',
                                autoLoad: true,
                                fields: ['status'],
                                data: [['Active'], ['Inactive']]
                            });

                            var statusCombo = new Ext.form.ComboBox({
                                store: statusComboStore,
                                id: 'statusId',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: 'Select Status',
                                selectOnFocus: true,
                                allowBlank: false,
                                anyMatch: true,
                                typeAhead: false,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'status',
                                width: 170,
                                value: 'Active',
                                displayField: 'status',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {}
                                    }
                                }
                            });
                            var bufferStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getBufferMapView',
                                id: 'BufferMapView',
                                root: 'BufferMapView',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['longitude', 'latitude', 'buffername', 'radius', 'imagename']
                            });

                            var polygonStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getPolygonMapView',
                                id: 'PolygonMapView',
                                root: 'PolygonMapView',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['longitude', 'latitude', 'polygonname', 'sequence', 'hubid']
                            });

                            function plotBuffers() {
                                for (var i = 0; i < bufferStore.getCount(); i++) {
                                    var rec = bufferStore.getAt(i);
                                    var urlForZero = '/ApplicationImages/VehicleImages/information.png';
                                    var convertRadiusToMeters = rec.data['radius'] * 1000;
                                    var myLatLng = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                                    createCircle = {
                                        strokeColor: '#A7A005',
                                        strokeOpacity: 0.8,
                                        strokeWeight: 3,
                                        fillColor: '#ECF086',
                                        fillOpacity: 0.55,
                                        map: map,
                                        center: myLatLng,
                                        radius: convertRadiusToMeters //In meters
                                    };
                                    if (convertRadiusToMeters == 0 && rec.data['imagename'] != '') {
                                        var image1 = '/jsps/images/CustomImages/';
                                        var image2 = rec.data['imagename'];
                                        urlForZero = image1 + image2;
                                    } else if (convertRadiusToMeters == 0 && rec.data['imagename'] == '') {
                                        urlForZero = '/jsps/OpenLayers-2.10/img/marker.png';
                                    }
                                    bufferimage = {
                                        url: urlForZero,
                                        scaledSize: new google.maps.Size(19, 35),
                                        origin: new google.maps.Point(0, 0),
                                        anchor: new google.maps.Point(0, 32)
                                    };
                                    buffermarker = new google.maps.Marker({
                                        position: myLatLng,
                                        id: rec.data['vehicleNo'],
                                        map: map,
                                        icon: bufferimage
                                    });
                                    buffercontent = rec.data['buffername'];
                                    bufferinfowindow = new google.maps.InfoWindow({
                                        content: buffercontent,
                                        id: rec.data['vehicleNo'],
                                        marker: buffermarker
                                    });
                                    google.maps.event.addListener(buffermarker, 'click', (function(buffermarker, buffercontent, bufferinfowindow) {
                                        return function() {
                                            bufferinfowindow.setContent(buffercontent);
                                            bufferinfowindow.open(map, buffermarker);
                                        };
                                    })(buffermarker, buffercontent, bufferinfowindow));
                                    buffermarker.setAnimation(google.maps.Animation.DROP);
                                    buffermarkers[i] = buffermarker;
                                    circlesPlot[i] = new google.maps.Circle(createCircle);
                                }
                            }

                            function plotPolygon() {
                                var hubid = 0;
                                var polygonCoords = [];
                                var polygonlines = [];
                                for (var i = 0; i < polygonStore.getCount(); i++) {
                                    var rec = polygonStore.getAt(i);
                                    if (i != polygonStore.getCount() - 1 && rec.data['hubid'] == polygonStore.getAt(i + 1).data['hubid']) {
                                        var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                                        polygonCoords.push(latLong);
                                        continue;
                                    } else {

                                        var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                                        polygonCoords.push(latLong);
                                    }
                                    polygon = new google.maps.Polygon({
                                        paths: polygonCoords,
                                        strokeColor: '#A7A005',
                                        strokeOpacity: 0.8,
                                        strokeWeight: 3,
                                        fillColor: '#ECF086',
                                        fillOpacity: 0.55
                                    });
                                    polygonimage = {
                                        url: '/ApplicationImages/VehicleImages/information.png',
                                        size: new google.maps.Size(48, 48),
                                        origin: new google.maps.Point(0, 0),
                                        anchor: new google.maps.Point(0, 32)
                                    };
                                    polygonmarker = new google.maps.Marker({
                                        position: latLong,
                                        map: map,
                                        icon: polygonimage
                                    });
                                    var polygoncontent = rec.data['polygonname'];
                                    polygoninfowindow = new google.maps.InfoWindow({
                                        content: polygoncontent,
                                        marker: polygonmarker
                                    });

                                    google.maps.event.addListener(polygonmarker, 'click', (function(polygonmarker, polygoncontent, polygoninfowindow) {
                                        return function() {
                                            polygoninfowindow.setContent(polygoncontent);
                                            polygoninfowindow.open(map, polygonmarker);
                                        };
                                    })(polygonmarker, polygoncontent, polygoninfowindow));
                                    polygonmarker.setAnimation(google.maps.Animation.DROP);
                                    polygon.setMap(map);
                                    polygonsPlot[hubid] = polygon;
                                    polygonmarkers[hubid] = polygonmarker;
                                    hubid++;
                                    polygonCoords = [];
                                }
                            }

                            var innerPanel = new Ext.form.FormPanel({
                                standardSubmit: true,
                                collapsible: false,
                                autoScroll: true,
                                height: 410,
                                width: 378,
                                frame: false,
                                id: 'innerPanelId',
                                layout: 'table',
                                style: 'margin-top:20px',
                                layoutConfig: {
                                    columns: 4,
                                    tableAttrs: {
                                        style: {
                                            height: '60%'
                                        }
                                    }
                                },
                                items: [{
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'custMandatoryId'
                                    }, {
                                        xtype: 'label',
                                        text: 'Customer Name',
                                        cls: 'labelstyle',
                                        id: 'custLabelId'
                                    },
                                    custCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'cust4LabelId'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'locationNameMandatoryId'
                                    }, {
                                        xtype: 'label',
                                        text: 'Location Name',
                                        cls: 'labelstyle',
                                        id: 'locationNameLabelId'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: 'Enter Location Name',
                                        emptyText: 'Enter Location Name',
                                        allowBlank: false,
                                        id: 'locationNameTextId'
                                       // regex: validate('alphanumericname')
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'loc4LabelId'
                                    }, 
                                    {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'locationcomMandatoryId',
                                         hidden:true
                                    }, {
                                        xtype: 'label',
                                        text: 'Location Name',
                                        cls: 'labelstyle',
                                        id: 'locationComLabelId',
                                        hidden:true
                                    },locationCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'locCoLabelId',
                                        hidden:true
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'loctypeMandatoryId'
                                    }, {
                                        xtype: 'label',
                                        text: 'Location Type',
                                        cls: 'labelstyle',
                                        id: 'loctypeLabelId'
                                    },
                                    locTypeCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'locTypeLabelId'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'speedMandatoryId'
                                    }, {
                                        xtype: 'label',
                                        text: 'Speed Limit',
                                        cls: 'labelstyle',
                                        id: 'speedLabelId'
                                    }, {
                                        xtype: 'numberfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        allowBlank: false,
                                        disabled: false,
                                        id: 'speedTextId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'speedLimitLabelId'
                                    },

                                    {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'statusManId'
                                    }, {
                                        xtype: 'label',
                                        text: 'Status',
                                        cls: 'labelstyle',
                                        id: 'statusLabelId'
                                    },
                                    statusCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'statLabelId'
                                    },
                                    {
                                        xtype: 'label',
                                        id: 'CheckBoxLabelId',
                                        cls: 'labelstyle',
                                        text: ''
                                    },
                                    {
                                        xtype: 'checkbox',
                                        id: 'CheckboxId',
                                        boxLabel: 'Show Hubs',
                                        width: 100,
                                        listeners: {
                                            check: function() {
                                                if (Ext.getCmp('CheckboxId').getValue()) {
                                                    bufferStore.load({
                                                        callback: function() {
                                                            plotBuffers();
                                                        }
                                                    });
                                                    polygonStore.load({
                                                        callback: function() {
                                                            plotPolygon();
                                                        }
                                                    });
                                                } else {
                                                    for (var i = 0; i < circlesPlot.length; i++) {
                                                        circlesPlot[i].setMap(null);
                                                        buffermarkers[i].setMap(null);
                                                    }
                                                    circlesPlot.length = 0;
                                                    for (var i = 0; i < polygonsPlot.length; i++) {
                                                        polygonsPlot[i].setMap(null);
                                                        polygonmarkers[i].setMap(null);
                                                    }
                                                    polygonsPlot.length = 0;
                                                }
                                            }
                                        }

                                    },
                                    {
                                        xtype: 'button',
                                        text: 'Save',
                                        cls: 'labelstyle',
                                        disabled: true,
                                        id: 'saveLabelId',
                                        listeners: {
                                            click: {
                                                fn: function() {
													var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
                                                    var radius = 0;
                                                    if (Ext.getCmp('custcomboId').getValue() == "") {
                                                        Ext.example.msg("Select Customer Name");
                                                        Ext.getCmp('custcomboId').focus();
                                                        return;
                                                    }
                                                    if(checked==1){
                                                    if (Ext.getCmp('locationNameTextId').getValue() == "") {
                                                        Ext.example.msg("Enter Location Name");
                                                        Ext.getCmp('locationNameTextId').focus();
                                                        return;
                                                    }
                                                    if (Ext.getCmp('loccomboId').getValue() == "") {
                                                        Ext.example.msg("Select Location Type");
                                                        Ext.getCmp('locationNameTextId').focus();
                                                        return;
                                                    }
                                                    }
                                                    if (Ext.getCmp('speedTextId').getValue() == "") {
                                                        Ext.example.msg("Enter Speed Limit");
                                                        Ext.getCmp('speedTextId').focus();
                                                        return;
                                                    }
                                                    if (Ext.getCmp('statusId').getValue() == "") {
                                                        Ext.example.msg("Select Status");
                                                        Ext.getCmp('statusId').focus();
                                                        return;
                                                    }
                                                    if (Ext.getCmp('loccomboId').getValue() == "1") {
                                                        radius = circles.getRadius() / 1000;
                                                        lat = circles.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                                        lng = circles.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                                    } else {
                                                        radius = "-1";
                                                        lat = latitude + "";
                                                        lng = longitude + "";
                                                    }
                                                    //if (innerPanel.getForm().isValid()) {
                                                        Ext.Ajax.request({
                                                            url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=saveRouteHub',
                                                            method: 'POST',
                                                            params: {
                                                                CustID: Ext.getCmp('custcomboId').getValue(),
                                                                locationName: Ext.getCmp('locationNameTextId').getValue(),
                                                                speedLimit: Ext.getCmp('speedTextId').getValue(),
                                                                latitude: lat,
                                                                longitude: lng,
                                                                radius: radius,
                                                                status: Ext.getCmp('statusId').getValue(),checked:checked,
                                                                routeId: Ext.getCmp('locationComboId').getValue()
                                                            },
                                                            success: function(response, options) {
                                                                var message = response.responseText;
                                                                Ext.example.msg(message);
                                                                Ext.getCmp('custcomboId').reset();
                                                                Ext.getCmp('locationNameTextId').reset();
                                                                Ext.getCmp('loccomboId').reset();
                                                                Ext.getCmp('speedTextId').reset();
                                                                Ext.getCmp('CheckboxId').reset();
                                                                Ext.getCmp('statusId').reset();
                                                                Ext.getCmp('locationComboId').reset();
                                                                loadMap();
                                                                locationstore.load();
                                                            },
                                                            failure: function() {
                                                                Ext.example.msg("Error");
                                                                Ext.getCmp('custcomboId').reset();
                                                                Ext.getCmp('locationNameTextId').reset();
                                                                Ext.getCmp('loccomboId').reset();
                                                                Ext.getCmp('speedTextId').reset();
                                                                Ext.getCmp('CheckboxId').reset();
                                                                Ext.getCmp('statusId').reset();
                                                                Ext.getCmp('locationComboId').reset();
                                                                loadMap();
                                                                locationstore.load();
                                                            }
                                                        });
                                                        if (markers != null) {
                                                            markers.setMap(null);
                                                        }
                                                        if (pointer != null) {
                                                            pointer.setMap(null);
                                                        }
                                                        if (circles != null) {
                                                            circles.setMap(null);
                                                        }
                                                        if (polygons != null) {
                                                            polygons.setMap(null);
                                                        }
                                                    //} else {
                                                        //Ext.example.msg("Location Name Cannot Conatin Special Character");
                                                    //}
                                                }
                                            }
                                        }
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'labelstyle',
                                        id: 'save4LabelId'
                                    }
                                ]
                            });

                            var innerPanelForRadioBtn = new Ext.form.FormPanel({
                                standardSubmit: true,
                                collapsible: false,
                                autoScroll: true,
                                height: 20,
                                width: 378,
                                frame: false,
                                id: 'radioPanelId',
                                layout: 'table',
                                layoutConfig: {
                                    columns: 2,
                                    tableAttrs: {
                                        style: {
                                            height: '90%'
                                        }
                                    }
                                },
                                items: [{
                                        xtype: 'radio',
                                        boxLabel: 'Add&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
                                        name: 'radio_selection',
                                        inputValue: 1,
                                        checked: true,
                                        listeners:{
                                        	check : function(cb, value) {
                                        	if(value) {
                                        	    Ext.getCmp('loccomboId').reset();
                                                Ext.getCmp('speedTextId').reset();
                                                
                                                Ext.getCmp('locationComboId').hide();
                                                Ext.getCmp('locationcomMandatoryId').hide();
                                                Ext.getCmp('locationComLabelId').hide();
                                                Ext.getCmp('locCoLabelId').hide();
                                                
                                                Ext.getCmp('locationNameTextId').show();
                                                Ext.getCmp('locationNameMandatoryId').show();
                                                Ext.getCmp('locationNameLabelId').show();
                                                Ext.getCmp('loc4LabelId').show();
                                                document.getElementById("map-canvas").disabled = false;
                                                Ext.getCmp('loccomboId').setReadOnly(false);
                                                
                                                }
                                        	}
                                        }
                                    },
                                    {
                                        xtype: 'radio',
                                        boxLabel: 'Modify&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
                                        name: 'radio_selection',
                                        inputValue: 2,
                                        checked: false,
                                        listeners:{
                                        	check : function(cb, value) {
                                        	if(value) {
                                        		
                                                Ext.getCmp('locationNameTextId').reset();
                                                Ext.getCmp('loccomboId').reset();
                                                Ext.getCmp('speedTextId').reset();
                                                Ext.getCmp('CheckboxId').reset();
                                                Ext.getCmp('statusId').reset();
                                                
                                                Ext.getCmp('locationComboId').show();
                                                Ext.getCmp('locationcomMandatoryId').show();
                                                Ext.getCmp('locationComLabelId').show();
                                                Ext.getCmp('locCoLabelId').show();
                                                
                                                Ext.getCmp('locationNameTextId').hide();
                                                Ext.getCmp('locationNameMandatoryId').hide();
                                                Ext.getCmp('locationNameLabelId').hide();
                                                Ext.getCmp('loc4LabelId').hide();
                                                locationstore.load();
                                                document.getElementById("map-canvas").disabled = true;
                                                Ext.getCmp('loccomboId').setReadOnly(true);
                                                Ext.getCmp('saveLabelId').enable();
                                                
        									}
                                        	}
                                        }
                                    }
                                ],
                            });
                            var mapPannel = new Ext.Panel({
                                standardSubmit: true,
                                id: 'mapPannelId',
                                collapsible: false,
                                frame: true,
                                style: 'margin-left: 5px',
                                title: 'Location on Map',
                                width: screen.width - 465,
                                height: 445,
                                html: '<div id="map-canvas" style="width:100%;height:398px;border:2;">'
                            });

                            var informationPanel = new Ext.Panel({
                                id: 'informationPanelId',
                                standardSubmit: true,
                                collapsible: false,
                                frame: true,
                                title: 'Hub Details',
                                height: 445,
                                width: 410,
                                layout: 'table',
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [innerPanelForRadioBtn, innerPanel]
                            });


                            Ext.onReady(function() {
                                Ext.QuickTips.init();
                                Ext.form.Field.prototype.msgTarget = 'side';
                                outerPanel = new Ext.Panel({
                                    renderTo: 'content',
                                    standardSubmit: true,
                                    frame: true,
                                    title: 'Route Hub Creation',
                                    width: screen.width - 38,
                                    height: 500,
                                    layout: 'table',
                                    cls: 'outerpanel',
                                    layoutConfig: {
                                        columns: 2
                                    },
                                    items: [informationPanel, mapPannel]
                                });
                            });
                        </script>
         <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->