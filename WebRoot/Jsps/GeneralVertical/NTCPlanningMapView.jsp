<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.functions.DashBoardFunctions" pageEncoding="utf-8"%>
<%@page import="t4u.util.JwtTokenUtil"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    String token = request.getParameter("token");
    System.out.println(token);
    String vehicleNos = request.getParameter("vehicleNos");
    System.out.println(vehicleNos);
    JwtTokenUtil util = new JwtTokenUtil();
    Boolean isExpired = util.isTokenExpired(token);
    System.out.println(isExpired);
%>
<style>
.leaflet-right{
  display:none;
}
</style>
<link rel="stylesheet" href="../Analytics/css/bootstrap.css" type="text/css" />
<link rel="stylesheet" href="../Analytics/css/animate.css" type="text/css" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css" />
<link rel="stylesheet" href="../Analytics/css/font.css" type="text/css" />

<link rel="stylesheet" href="../Analytics/css/app.css" type="text/css" />
<link rel="stylesheet" href="../Analytics/js/datepicker/datepicker.css" type="text/css" />
<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" type="text/css"/>
<link rel="stylesheet" href="../Analytics/css/analytics.css" type="text/css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" type="text/css"/>
<script src="https://unpkg.com/leaflet@1.0.2/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
<script
src="https://code.jquery.com/jquery-3.4.1.min.js"
integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
crossorigin="anonymous"></script>
<script
src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

<html>
<!--   <div class="panel-body" style="height:800px;padding:0px;">
                  <div id="map1"  style="height:800px"></div>
                </div> -->
                
<div class="container">
  <div class="panel panel-default" id="mapViewId">
    <div class="panel-heading"><strong>Map View</strong></div>
    <div class="panel-body">
	  <div id="map1"  style="height:800px"></div>
	  
     </div>
  </div>
  <div id="mapExpired" ><strong>Session is expired</strong></div>
</div>

</html>
<script>
//initialize();
//loadMap();

$(document).ready(function() { 
	if(<%=isExpired%> != null) {
		initialize();
		loadMap();
	} else {
		$("#mapExpired").show();
		$("#mapViewId").hide();
	}
});

let markerPriority = [];
function initialize() {

     var osm1 = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
         maxZoom: 19,
         attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
     });

     map1 = new L.Map("map1", {
         fullscreenControl: {
             pseudoFullscreen: false
         },
         center: new L.LatLng('21.146633', '79.088860'),
         zoom: 4
     });

     L.control.layers({
         "OSM": osm1
     }, null, {
         collapsed: false
     }).addTo(map1);
     osm1.addTo(map1);

 }
 
 
 function loadMap(){
	  let totalVehicles = [];
		 $.ajax({
		 type: "GET",
		 url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getCurrentLocationsForVehicles&vehicleNos=<%=vehicleNos%>',
		 success: function(result) {
		 var rs=JSON.parse(result)
		 let vehicleDetails=rs.vehicleDetailsRoot;
		 for(var i=0;i<vehicleDetails.length;i++)
		 {
			var obj=
			{
			 "lat": vehicleDetails[i].latitude,
			 "lng": vehicleDetails[i].longitude,
			 "vehicleNo": vehicleDetails[i].vehicleNo,
			 "location" : vehicleDetails[i].location,
			 "speed":vehicleDetails[i].speed
			}
			totalVehicles.push(obj);
		 }
 	    for(var i = 0; i < markerPriority.length; i++){
			map2.removeLayer(markerPriority[i]);
		}
      	markerPriority = [];
      	totalVehicles.forEach(function(item){
		  if(!(item.lat==undefined && item.lng==undefined))
		  {
			   let image = L.icon({
				   iconUrl: "../../Main/images/truckTop_Blue.png",
				   iconSize: [10, 20], // size of the icon
				   popupAnchor: [0, -15]
			   });
			   var marker = new L.Marker(new L.LatLng(item.lat, item.lng), {
				   icon: image
			   }).addTo(map1);
			   markerPriority.push(marker);
			   let content="<div style='display:flex;flex-direction:column'><div><b>Vehicle No.: </b>"+item.vehicleNo+
			   							//"</div><div>Latitude :"+item.lat+"</div><div>Longitude :"+item.lng+
			   							"</div><div><b>Location: </b>"+item.location+"</div><div><b>Speed: </b>"+item.speed+"</div></div>"

			   marker.bindPopup(content);
		  }
        })
       }
    })
  }
 
</script>