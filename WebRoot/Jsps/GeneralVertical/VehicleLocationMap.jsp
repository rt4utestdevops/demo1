<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.functions.DashBoardFunctions" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
   String tripId = request.getParameter("tripId");
   String tripCustomerId = request.getParameter("tripCustomerId");
   DashBoardFunctions dashFunc = new DashBoardFunctions();
   ArrayList<String> vehicleInfo = dashFunc.getVehicleCurrentLocation(Integer.parseInt(tripId),Integer.parseInt(tripCustomerId));
   
   
   %>
<html>
   <head>
      <title>Map</title>
      <meta name="viewport" content="initial-scale=1.0">
      <meta charset="utf-8">
      <link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
      <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
      <script src="../../Main/leaflet/initializeleaflet.js"></script>
      <script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
         integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
         crossorigin=""></script>
      <style>
         /* Always set the map height explicitly to define the size of the div
         * element that contains the map. */
         #map {
         height: 100%;
         }
         /* Optional: Makes the sample page fill the window. */
         html, body {
         height: 100%;
         margin: 0;
         padding: 0;
         }
         .leaflet-popup-content {
         max-width: 500px;
         height: 200px;
         overflow-y: scroll;
         }
      </style>
   </head>
   <body>
      <div id="map"></div>
      <script>
         var map;
		 
         function initMap() {
			if('<%=vehicleInfo.get(0)%>' == ''){
				document.getElementById('map').innerHTML = "Page Expired";
				return;
			}
			initialize("map",new L.LatLng('<%=vehicleInfo.get(0) %>', '<%=vehicleInfo.get(1) %>'),'OSM', '', '');
			map.setView(new L.LatLng('<%=vehicleInfo.get(0) %>', '<%=vehicleInfo.get(1) %>'), 4);
			map.setZoom(8);
          
			plotSingleVehicle();
         }
		 initMap();
         function plotSingleVehicle() {
			var latitude = '<%=vehicleInfo.get(0) %>';
			var longtitude = '<%=vehicleInfo.get(1) %>';
			var vehicleNo ='<%=vehicleInfo.get(2) %>';
			var imageurl = '/ApplicationImages/VehicleImages/delivery-van-black.png';
          
         
			image = L.icon({
               iconUrl: imageurl,
               iconSize: [19, 35], // size of the icon
               popupAnchor: [0, -15]
			});
			var pos = new L.LatLng(latitude, longtitude);
			var coordinate=latitude+','+longtitude;
			var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="width:270px; height: 170px; float: left; color: #000; line-height:100%; font-size:8px !important; font-family: "Tahoma", Geneva,  sans-serif !important;">' +
               '<table class="infoDiv">' +
               '<tr><td nowrap><b>Vehicle No:&nbsp;&nbsp;</b></td><td>' + '<%=vehicleInfo.get(2) %>' + '</td></tr>' +
               '<tr><td nowrap><b>Driver Name:&nbsp;&nbsp;</b></td><td>' + '<%=vehicleInfo.get(3) %>' + '</td></tr>' +
               '<tr><td nowrap><b>Driver Contact:&nbsp;&nbsp;</b></td><td>' + '<%=vehicleInfo.get(4) %>' + ' </td></tr>' +
               '<tr><td nowrap><b>Location:&nbsp;&nbsp;</b></td><td>' + '<%=vehicleInfo.get(5) %>' + ' </td></tr>' +
               '</table>' +
               '</div>';
           var marker = new L.Marker(pos,{
				icon: image }).bindPopup(content).addTo(map);
				map.setView(pos);
				map.setZoom(12);
          
				marker.on("click", function (e) {
			firstLoadDetails = 1;
			info = false;
			var imageurl = '/ApplicationImages/VehicleImages/delivery-van-black.png';
    
			var markerImage = L.icon({
				iconUrl: imageurl,
				iconSize: [19, 35], // size of the icon
				popupAnchor: [0, -15]
			});
         
			e.target.setIcon(markerImage);
			marker._popup.setContent(content);
         			
			});
       
         }
      </script>
   </body>
</html>