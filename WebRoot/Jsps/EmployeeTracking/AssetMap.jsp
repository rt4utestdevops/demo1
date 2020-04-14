
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
if(request.getParameter("RouteName")==null)
{
 response.sendRedirect(request.getContextPath()+ "/Jsps/Common/404Error.html");
}
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(0);
loginInfo.setUserId(0);
loginInfo.setLanguage("en");
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setUserName("");
session.setAttribute("loginInfoDetails",loginInfo);
String routeName=request.getParameter("RouteName").toUpperCase();
Properties properties = ApplicationListener.prop;						
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
response.addHeader("Refresh","60");
%>
 <!DOCTYPE html>
<html>

<head>


    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
 <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
 <pack:script src="../../Main/Js/Common.js"></pack:script>

 <pack:style src="../../Main/resources/css/ext-all.css" />
 <pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
 <pack:style src="../../Main/resources/css/common.css" />
 <pack:style src="../../Main/resources/css/commonnew.css" />
 <pack:script src="../../Main/Js/examples1.js"></pack:script>
 <pack:style src="../../Main/resources/css/examples1.css" />

 <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
 <title>Map</title>
 <script src=<%=GoogleApiKey%>></script>
 <script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/richmarker/src/richmarker.js"></script>
 
 <style type="text/css">
     html {
         height: 100%
     }
     
     body {
         height: 100%;
         margin: 0px;
         padding: 0px
     }
     
     #content {
         height: 100%
     }
     
     .mp-options-wrapper {
         position: absolute;
         height: 31px;
         background: #FFF;
         bottom: 0px;
         text-align: center;
         width: 0%;
         padding-top: 9px;
     }
     
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
     .my-other-marker{
       color: darkblue;
	   width: 15px;
       padding-left: 10px;
	   height: 17px;
	   border: black;
	   font-size: 15px;
	   font-weight: bold;
}
     }
     
 </style>

</head>

<body>
    <div id="content">
    </div>
    <div class="mp-options-wrapper">
        <input id="pac-input" class="controls" type="text" placeholder="Search Places">
    </div>

    <script type="text/javascript">
     var customerID = 0;
     var customerName = '';
     var customerPanel;
     var map;
     var vehicleMarker;
     var directionDisplay;
     var searchBox;
     var directionsService = new google.maps.DirectionsService();
     var selectedInfoWindow;

     var defaultmapOptions = {
         zoom: 10,
         center: new google.maps.LatLng('12.972442', '77.583847'),
         mapTypeId: google.maps.MapTypeId.ROADMAP
         //position:google.maps.ControlPosition.CENTER
     };

     map = new google.maps.Map(document.getElementById('content'), defaultmapOptions);

     searchBox(map, 'pac-input');

     var markers = new Ext.data.JsonStore({
         url: '<%=request.getContextPath()%>/DashBoard.do?param=getAssetMapDetails',
         id: 'MapVehicles',
         root: 'MapVehicles',
         autoLoad: false,
         remoteSort: true,
         fields: ['msg', 'regno', 'longittude', 'lattitude', 'gmt', 'location', 'facLatitude1', 'facLongitude1', 'facility', 'type','TripStartDate','clientId']
     });
     var store = new Ext.data.JsonStore({
         url: '<%=request.getContextPath()%>/DashBoard.do?param=getRouteDetails',
         id: 'routeId',
         root: 'routeId',
         autoLoad: false,
         remoteSort: true,
         fields: ['latitude', 'longitude', 'location', 'arrTime', 'count', 'empName','sequence','LAST_VISITED']
     });
      var latlongStore = new Ext.data.JsonStore({
         url: '<%=request.getContextPath()%>/DashBoard.do?param=getLatlongs',
         id: 'latlongId',
         root: 'latlongId',
         autoLoad: false,
         remoteSort: true,
         fields: ['longitudee', 'latitudee']
     });
     markers.load({
         params: {
             routeName: '<%=routeName%>'
         },
         callback: function() {
             if (markers.data.length == 0) {
                 Ext.example.msg("Trip is not Available");
             } else {
                 var rec = markers.getAt(0);

                 if (rec.data['msg'] != "") {
                     Ext.example.msg(rec.data['msg']);
                 } else {
                     var latlongs = [];
                     var polylatlongs= [];
                     if (rec.data['facLatitude1'] == "0" || rec.data['facLongitude1'] == "0") {
                         for (var i = 0; i < markers.getCount(); i++) {
                             var rec = markers.getAt(i);
                             var regNo = rec.data['regno'];
                             var pos = new google.maps.LatLng(rec.data['lattitude'], rec.data['longittude']);
                             latlongs.push(pos);
                             var startDate=rec.data['TripStartDate'];
                             var clientId=rec.data['clientId'];
                             var lon=rec.data['longittude'];
                             var lat=rec.data['lattitude'];
                             store.load({
                                 params: {
                                     routeName: '<%=routeName%>',
                                     vehNo: regNo
                                 },
                                 callback: function() {
                                     var count ;
                                     var lastVisited;
                                     var rec1 = store.getAt(1);
                                     if(typeof rec1 == 'undefined' ){
                                     count=0;
                                     lastVisited='NA';
                                     }else{
                                     count = rec1.data['count'];
                                     lastVisited = rec1.data['LAST_VISITED'];
                                     }
                                     setMarker(map, markers, rec.data['longittude'], rec.data['lattitude'], rec.data['gmt'], rec.data['location'], rec.data['regno'], latlongs, rec.data['type'], count, lastVisited);
                                     store.load({
                                         params: {
                                             routeName: '<%=routeName%>',
                                             vehNo: regNo
                                         },
                                         callback: function() {
                                             for (var i = 0; i < store.getCount(); i++) {
                                                 var rec = store.getAt(i);
                                                 setTransitPoints(map, rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['arrTime'], rec.data['count'],rec.data['sequence']);
                                             }
                                         }
                                     });
                                     latlongStore.load({
                                         params: {
                                             routeName: '<%=routeName%>',
                                             vehNo: regNo,
                                             startDate:startDate,
                                             clientId:clientId,
                                             lon:lon,
                                             lat:lat
                                         },
                                         callback: function() {
                                             for (var i = 0; i < latlongStore.getCount(); i++) {
                                                 var rec = latlongStore.getAt(i);
                                                 var latlon= new google.maps.LatLng(rec.data['latitudee'], rec.data['longitudee']);
                                                 polylatlongs.push(latlon);
                                                 setPolyPoints(map, rec.data['latitudee'], rec.data['longitudee'],polylatlongs);
                                             }
                                         }
                                     });
                                 }
                             });
                         }
                         Ext.example.msg("Facility is not available");
                     } else {
                         for (var i = 0; i < markers.getCount(); i++) {
                             var rec = markers.getAt(0);
                             var regNo = rec.data['regno'];
                             var startDate=rec.data['TripStartDate'];
                             var clientId=rec.data['clientId'];
                             var lon=rec.data['longittude'];
                             var lat=rec.data['lattitude'];
                             var pos = new google.maps.LatLng(rec.data['lattitude'], rec.data['longittude']);
                             var pos1 = new google.maps.LatLng(rec.data['facLatitude1'], rec.data['facLongitude1']);
                             latlongs.push(pos);
                             latlongs.push(pos1);
                             store.load({
                                 params: {
                                     routeName: '<%=routeName%>',
                                     vehNo: regNo
                                 },
                                 callback: function() {
                                 var count ;
                                 var lastVisited;
                                     var rec1 = store.getAt(1);
                                     if(typeof rec1 == 'undefined' ){
                                     count=0;
                                     lastVisited='NA';
                                     }else{
                                     count = rec1.data['count'];
                                     lastVisited = rec1.data['LAST_VISITED'];
                                     }
                                     setMarker(map, markers, rec.data['longittude'], rec.data['lattitude'], rec.data['gmt'], rec.data['location'], rec.data['regno'], latlongs, rec.data['type'], count, lastVisited);
                                     setFacility(map, rec.data['facLatitude1'], rec.data['facLongitude1'], rec.data['facility'], latlongs);
                                     store.load({
                                         params: {
                                             routeName: '<%=routeName%>',
                                             vehNo: regNo
                                         },
                                         callback: function() {
                                             for (var i = 0; i < store.getCount(); i++) {
                                                 var rec = store.getAt(i);
                                                 setTransitPoints(map, rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['arrTime'], rec.data['count'],rec.data['sequence']);
                                             }
                                         }
                                     });
                                      latlongStore.load({
                                         params: {
                                             routeName: '<%=routeName%>',
                                             vehNo: regNo,
                                             startDate:startDate,
                                             clientId:clientId,
                                             lon:lon,
                                             lat:lat
                                         },
                                         callback: function() {
                                             for (var i = 0; i < latlongStore.getCount(); i++) {
                                                 var rec = latlongStore.getAt(i);
                                                 var latlon= new google.maps.LatLng(rec.data['latitudee'], rec.data['longitudee']);
                                                 polylatlongs.push(latlon);
                                                 setPolyPoints(map,polylatlongs);
                                             }
                                         }
                                     });
                                 }
                             });
                         }
                     }
                 }
             }
         }
     });

     function setMarker(map, markers, longitude, latitude, gmt, location, regno, latlongs, type, count, lastVisited) {
         var infowindow = new google.maps.InfoWindow(),
             marker, i, image;
         image = {
             url: '/ApplicationImages/VehicleImages/bus3_BG.gif', // This marker is 20 pixels wide by 32 pixels tall.
             size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
             origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
             anchor: new google.maps.Point(0, 32)
         };
         var pos = new google.maps.LatLng(latitude, longitude);
         marker = new google.maps.Marker({
             position: pos,
             map: map,
             icon: image
         });
         var bounds = new google.maps.LatLngBounds();
         bounds.extend(pos);
         map.fitBounds(bounds);
         var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#fff; line-height:100%; font-size:80%; font-family: sans-serif;">' +
             '<table>' +
             '<tr><td><b>Vehicle No:</b></td><td>' + regno + '</td></tr>' +
             '<tr><td><b>Landmark:</b></td><td style=" width: 118px; ">' + location + '</td></tr>' +
             '<tr><td><b>DateTime:</b></td><td>' + gmt + '</td></tr>' +
             '<tr><td><b>RouteId:</b></td><td>' + '<%=routeName%>' + '</td></tr>' +
             '<tr><td><b>RouteType:</b></td><td>' + type + '</td></tr>' +
             '<tr><td><b>Visited Count:</b></td><td>' + count + '</td></tr>' +
             '<tr><td><b>Last Visited Point:</b></td><td>' + lastVisited + '</td></tr>' +
             '</table>' +
             '</div>';
            
         infowindow.setOptions({
             content: content,
             position: pos,
         });
         if (selectedInfoWindow != null && selectedInfoWindow.getMap() != null) {
             selectedInfoWindow.close();
         }
         selectedInfoWindow = infowindow;
         infowindow.open(map, marker);
         google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
             return function() {
                 if (selectedInfoWindow != null && selectedInfoWindow.getMap() != null) {
                     selectedInfoWindow.close();

                 }
                 selectedInfoWindow = infowindow;
                 infowindow.setContent(content);
                 map.setCenter(map.getCenter());
                 infowindow.open(map, marker);
             };
         })(marker, content, infowindow));
         if (map.getZoom() > 18) map.setZoom(17);
     }

     function setTransitPoints(map, latitude, longitude, location, arrTime, count,sequence) {
     var arrvTime;
         if (arrTime != "") {
             arrvTime=arrTime;
             imageurl = '/ApplicationImages/VehicleImages/greenm.png';
         } else {
             arrvTime='NA';
             imageurl = '/ApplicationImages/VehicleImages/redm.png';
         }
         var infowindow = new google.maps.InfoWindow(),
             marker, i, image;
         image = {
             url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
             size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
             origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
             anchor: new google.maps.Point(0, 32)
         };
         var pos = new google.maps.LatLng(latitude, longitude);
         marker = new google.maps.Marker({
             position: pos,
             map: map,
             icon: image
         });
         var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#fff; line-height:100%; font-size:80%; font-family: sans-serif;">' +
             '<table>' +
             '<tr><td><b>Landmark:</b></td><td style=" width: 54px; ">' + location + '</td></tr>' +
             '<tr><td><b>Arrival Time:</b></td><td style=" width: 54px; ">' + arrvTime + '</td></tr>' +
             '</table>' +
             '</div>';
         createRichMarker(pos,sequence);
         google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
             return function() {
                 if (selectedInfoWindow != null && selectedInfoWindow.getMap() != null) {
                     selectedInfoWindow.close();
                 }
                 selectedInfoWindow = infowindow;
                 infowindow.setContent(content);
                 infowindow.open(map, marker);
             };
         })(marker, content, infowindow));
         
     }

     function setFacility(map, latitude, longitude, facility, latlongs) {
         var infowindow = new google.maps.InfoWindow(),
             marker, i, image;
         image = {
             url: '/ApplicationImages/DashBoard/building-icon.png', // This marker is 20 pixels wide by 32 pixels tall.
             size: new google.maps.Size(40, 80), // The origin for this image is 0,0.
             origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
             anchor: new google.maps.Point(0, 32)
         };
         var pos = new google.maps.LatLng(latitude, longitude);
         marker = new google.maps.Marker({
             position: pos,
             map: map,
             icon: image
         });
         var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#fff; line-height:100%; font-size:80%; font-family: sans-serif;">' +
             '<table>' +
             '<tr><td><b>Facility:</b></td><td style=" width: 65px; ">' + facility + '</td></tr>' +
             '</table>' +
             '</div>';
         google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
             return function() {
                 if (selectedInfoWindow != null && selectedInfoWindow.getMap() != null) {
                     selectedInfoWindow.close();
                 }
                 selectedInfoWindow = infowindow;
                 infowindow.setContent(content);
                 infowindow.open(map, marker);
             };
         })(marker, content, infowindow));
     }
  function setPolyPoints(map,polylatlongs){
  var line = new google.maps.Polyline({
    path: polylatlongs,
    strokeColor: '#6699FF',
     map: map
  });
  line.setMap(map);
 }
 function createRichMarker(position,sequence){
 var labelmarkers=[];
var content = '<div class="my-other-marker">'+sequence+'</div>';
var labelMarker = new RichMarker({
         map: map,
         position: position,
         draggable: false,
         flat: true,
         anchor:RichMarkerPosition.MIDDLE,
         content: content
       });
   labelmarkers.push(labelMarker);	
}
 </script>
</body>

</html>