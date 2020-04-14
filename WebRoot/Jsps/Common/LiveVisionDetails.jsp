<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
        <%
	    CommonFunctions cf = new CommonFunctions();

		String path = request.getContextPath();
		String basePath = request.getScheme() + "://"+ request.getServerName() + ":"+ request.getServerPort() + path + "/";
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setLanguage("en");
		loginInfo.setSystemId(0);
		loginInfo.setZone("A");//B
		loginInfo.setOffsetMinutes(330);
		loginInfo.setCategory("India");
		loginInfo.setCategoryType("South India");
		Properties properties = ApplicationListener.prop;
		String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		
		ArrayList<String> tobeConverted = new ArrayList<String>();
        tobeConverted.add("Vehicle_No");
        tobeConverted.add("Enter_Vehicle_No");
        tobeConverted.add("Vehicle_No_Not_Exists");
        tobeConverted.add("Unit_No_Not_Associated");
        
        ArrayList<String> convertedWords = new ArrayList<String>();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
		
		String VehicleNo=convertedWords.get(0);
		String EnterVehicleNo=convertedWords.get(1);
		String VehicleNotFound=convertedWords.get(2);
		String UnitNotAssociated=convertedWords.get(3);
		
%>
            <!DOCTYPE html>
            <html>
            <meta name="viewport" content="initial-scale=1.0, user-scalable=no">

            <title>Map</title>
            
            <style type="text/css">
                #image-info {
                    text-align: left;
                    width: 501px;
                    float: left;
                }
                
                #image-info img {
                    width: 16px;
                    height: 16px;
                    margin-right: 5px;
                    margin-left: 5px;
                }
                
                .mp-container-fitscreen {
                    position: fixed;
                    border: 5px solid #ffffff;
                    top: 40px !important;
                    left: 16%;
                    width: 84%;
                    height: 520px;
                }
                
                .mp-map-wrapper1 {
                    width: 99.5%;
                    height: 484px;
                    position: absolute;
                }
                
                .x-table-layout1 td {
                    vertical-align: top;
                }
                
                .vehicle-details-block-sep {
                    font-size: 12px;
                    font-family: 'Open Sas' sans-serif !important;
                    float: left;
                    padding-right: 14px;
                }
                
                .mp-container1 {
                    background: #f4f4f4;
                    border: 5px solid #fff;
                    width: 76.5%;
                    height: 525px;
                    position: relative;
                    margin: initial;
                    right: 0%;
                    -moz-box-shadow: 1px 1px 3px #cac4ab;
                    -webkit-box-shadow: 1px 1px 3px #cac4ab;
                    box-shadow: 1px 1px 3px #cac4ab;
                }
                
                .vehicle-details-block-header {
                    float: left;
                    width: 35%;
                    font-size: 12px;
                    font-family: 'Open Sas' sans-serif !important;
                    font-weight: bold;
                    color: black;
                }
                
                .vehicle-details-block {
                    word-wrap: break-word;
                    overflow: hidden;
                    font-size: 12px;
                    font-family: 'Open Sas' sans-serif !important;
                    color: black;
                }
            </style>

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
            <script src=<%=GoogleApiKey%>
                >
            </script>

            <body oncontextmenu="return false">
                <div class="container">
                    <header>
                        <div id="vehicletype">
                        </div>
                        <h1>
				<span>MAPVIEW</span>
			</h1>

                    </header>
                    <div class="combodiv" id="customerIddiv1">
                    </div>
                    <div class="main">
                        <div class="mp-vehicle-details-wrapper" id="vehicle-details">
                            <form class="me-select">
                                <ul id="me-select-list">
                                    <li class="me-select-label"><span class="vehicle-details-block-header">Registration No </span><span class="vehicle-details-block-sep">:</span>
                                        <p class="vehicle-details-block" id="registrationNo-Id"></p>
                                    </li>
                                    <li class="me-select-label"><span class="vehicle-details-block-header">Location </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="location-Id"></p></li>
                                    <li class="me-select-label"><span class="vehicle-details-block-header">Date Time </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="dateTime-Id"></p></li>
                                    <li class="me-select-label"><span class="vehicle-details-block-header">Speed </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="speed-Id"></p></li>
                                    <li class="me-select-label"><span class="vehicle-details-block-header">Ignition</span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="ignition-Id"></p></li>
                                </ul>
                            </form>
                        </div>
                        <div class="mp-container1" id="mp-container">
                            <div class="mp-map-wrapper1" id="map"></div>
                            <div class="mp-options-wrapper" />  
                         <div id="image-info">
							<img id="info" src="/ApplicationImages/VehicleImages/red.png">
							<span style="padding-right: 20px; font-size: 14px;">Vehicle Not Moving</span>
							<img class="info" src="/ApplicationImages/VehicleImages/green.png">
							<span style="padding-right: 20px; font-size: 14px;">Moving Vehicle</span>
							<span style="left: 50px; position: absolute;"></span>
						</div>
                            <div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
                            <div class="mp-option-fullscreenl" id="option-fullscreen" onclick="mapFullScreen()"></div>
                        </div>
                    </div>
                </div>
                </div>
<script>
 var markers = {};
 var infowindows = {};
 var marker;
 var map;
 var infowindow;
 var $mpContainer = $('#mp-container');
 var $mapEl = $('#map');
 var loadMask = new Ext.LoadMask(Ext.getBody(), {
     msg: "Loading"
 });
 document.getElementById('option-normal').style.display = 'none';


 function mapFullScreen() {
     document.getElementById('option-fullscreen').style.display = 'none';
     document.getElementById('option-normal').style.display = 'block';
     $mpContainer.removeClass('mp-container-fitscreen');
     $mpContainer.addClass('mp-container-fullscreen').css({
         width: 'originalWidth',
         height: 'originalHeight'
     });


     $mapEl.css({
         width: $mapEl.data('originalWidth'),
         height: $mapEl.data('originalHeight')
     });
     google.maps.event.trigger(map, 'resize');

 }

 function reszieFullScreen() {

     document.getElementById('option-fullscreen').style.display = 'block';
     document.getElementById('option-normal').style.display = 'none';
     $mpContainer.removeClass('mp-container-fitscreen');
     $mpContainer.removeClass('mp-container-fullscreen');
     $mpContainer.addClass('mp-container1');

     $mapEl.css({
         width: $mapEl.data('originalWidth'),
         height: $mapEl.data('originalHeight')
     });
     google.maps.event.trigger(map, 'resize');

 }
 var mapOptions = {
     zoom: 4,
     center: new google.maps.LatLng('22.89', '78.88'),
     mapTypeId: google.maps.MapTypeId.ROADMAP
 };
 map = new google.maps.Map(document.getElementById('map'), mapOptions);

 //***********************************Plot Vehicle on Map *******************************************
 function plotSingleVehicle(regNo, latitude, longtitude, location, gpsDateTime, speed,category) {
     if ((category == 'stoppage') || (category == 'idle')) {
        imageurl = '/ApplicationImages/VehicleImages/red.png';
    } else {
        imageurl = '/ApplicationImages/VehicleImages/green.png';
    }
     image = {
         url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
         size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
         origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
         anchor: new google.maps.Point(0, 32)
     };
     var pos = new google.maps.LatLng(latitude, longtitude);
     marker = new google.maps.Marker({
         position: pos,
         id: regNo,
         map: map, 
         icon: image
     });
     var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">' +
         '<table>' +
         '<tr><td style=" width: 74px; " ><b>Vehicle No:</b></td><td>' + regNo + '</td></tr>' +
         '<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' +
         '<tr><td><b>Date Time:</b></td><td>' + gpsDateTime + '</td></tr>' +
         '</table>' +
         '</div>';
     infowindow = new google.maps.InfoWindow({
         content: content,
         maxWidth: 300,
         marker: marker,
         image: image,
         id: regNo
     });

     google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
         return function() {
             infowindow.setContent(content);
             infowindow.open(map, marker);
         };
     })(marker, content, infowindow));
     marker.setAnimation(google.maps.Animation.DROP);
    var bounds = new google.maps.LatLngBounds();
	bounds.extend(pos);
	map.fitBounds(bounds);
	if (map.getZoom() > 16) map.setZoom(14);
 }

 var detailsStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CommonAction.do?param=getLiveVisionDetails',
     id: 'storeId',
     root: 'detailsStoreRoot',
     autoLoad: false,
     fields: ['regNo', 'unitNo', 'longitude', 'latitude', 'location', 'gpsDateTime', 'speed', 'ignition','category']
 });

 var viewButton = new Ext.Button({
     text: 'View',
     id: 'submitId',
     cls: 'buttonStyle',
     width: 70,
     handler: function() {
         map = new google.maps.Map(document.getElementById('map'), mapOptions);

         if (Ext.getCmp('vehicleNoId').getValue() == "") {
             Ext.example.msg('<%=EnterVehicleNo%>');
             return;
         }
         document.getElementById('registrationNo-Id').innerHTML = '';
         document.getElementById('location-Id').innerHTML = '';
         document.getElementById('dateTime-Id').innerHTML = '';
         document.getElementById('speed-Id').innerHTML = '';
         document.getElementById('ignition-Id').innerHTML = '';
         detailsStore.load({
             params: {
                 vehicleNo: Ext.getCmp('vehicleNoId').getValue()
             },
             callback: function() {
                 var rec = detailsStore.getAt(0);
                 if(typeof rec == 'undefined' ){
                     Ext.example.msg('<%=VehicleNotFound%>');
                     return;
                 }
                 registrationNo = rec.data['regNo'];
                 unitNo = rec.data['unitNo'];
                 if (registrationNo = !"" && unitNo == "") {
                     Ext.example.msg('<%=UnitNotAssociated%>');
                     return;
                 }
                 if (!rec.data['latitude'] == 0 && !rec.data['longitude'] == 0) {
                     plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gpsDateTime'], rec.data['speed'], rec.data['category'])
                 }  
                 document.getElementById('registrationNo-Id').innerHTML = rec.data['regNo'];
                 document.getElementById('location-Id').innerHTML = rec.data['location'];
                 document.getElementById('dateTime-Id').innerHTML = rec.data['gpsDateTime'];
                 document.getElementById('speed-Id').innerHTML = rec.data['speed'];
                 document.getElementById('ignition-Id').innerHTML = rec.data['ignition'];
             }
         });
     }
 });

 Ext.Ajax.timeout = 360000;
 var outerPanel = new Ext.Panel({
     standardSubmit: true,
     frame: true,
     height: 50,
     layout: 'table',
     layoutConfig: {
         columns: 5
     },
     items: [{
             xtype: 'label',
             text: '<%=VehicleNo%>' + ' :',
             cls: 'labelstyle',
             id: 'vehicleNoemptyId'
         }, {
             xtype: 'textfield',
             id: 'vehicleNoId',
             cls: 'selectstylePerfect',
             emptyText: '<%=EnterVehicleNo%>'
         }, {
             width: 50
         },
         viewButton
     ]
 });
 outerPanel.render('customerIddiv1');
    </script>
  </body>
</html>