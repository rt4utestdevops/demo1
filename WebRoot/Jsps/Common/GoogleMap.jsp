
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	Properties properties = ApplicationListener.prop;						
	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		
	ArrayList<String> tobeConverted=new ArrayList<String>();	

	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	

%>
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <title>Map</title>  
    <script src=<%=GoogleApiKey%>></script>   
    	<style type="text/css">
     		html { height: 100% }
     		body { height: 100%; margin: 0px; padding: 0px }
     		#content { height: 100% }
     		#myInfoDiv { width:100%; height:100% }
   		</style>
  </head> 
  	<body onload = "initialize();">
  	<jsp:include page="../Common/ImportJS.jsp" />
  	
  	<script type="text/javascript">
   	var map;
	var circle;

	var assetNumber = parent.assetNumber;
	var asetId = parent.assetId;
	var centerLatitude = parent.mapLatitude;
	var centerLongitude = parent.mapLongitude;	
	var singleCircleRadius = parent.mapRadius;
	var markers = parent.marineLiveGridStore;
	var speed = parent.speed;

	function initialize() {
	    var mapOptions = {
	        zoom: 10,
	        center: new google.maps.LatLng(centerLatitude, centerLongitude),
	        mapTypeId: google.maps.MapTypeId.ROADMAP
	    };

	    map = new google.maps.Map(document.getElementById('content'), mapOptions);
	    //Plotting Single Markers in Map 		
	    setSingleMarkers(map, centerLatitude, centerLongitude);
	    //Plotting Multiple Markers in Map
	    setMultipleMarkers(map, markers);
	    //Ploting circle
	    setSingleCircles(map, centerLatitude, centerLongitude);
	}
	
	function setSingleMarkers(map, centerLatitude, centerLongitude) {
	    if(centerLatitude > 0 && centerLongitude >0) {
	    	var infowindow = new google.maps.InfoWindow(), marker;
			var image = {
	        	url: '/ApplicationImages/VehicleImages/PinkBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	}; 
    		
    		var pos = new google.maps.LatLng(centerLatitude, centerLongitude); 
    		
        	marker = new google.maps.Marker({
            	position: pos,
            	map: map,
            	icon: image
        	});
        	
        	var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="width:100%; height: 100%; float: left; color: #FFF; background:#ed8719; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td><b>Vessel Name:</b></td><td>'+assetNumber+'</td></tr>'+
			'<tr><td><b>Vessel Id:</b></td><td>'+asetId+'</td></tr>'+
			'<tr><td><b>Latitude:</b></td><td>'+centerLatitude+'</td></tr>'+
			'<tr><td><b>Longitude:</b></td><td>'+centerLongitude+'</td></tr>'+
			'</table>'+
			'</div>';
        	google.maps.event.addListener(marker, 'click', function() {
                	infowindow.setContent(content);
                	infowindow.open(map, marker);
        	});
        }
	}

	function setMultipleMarkers(map, markers) {
	    
	    var infowindow = new google.maps.InfoWindow(), marker, i, image;
    	for (i = 0; i < markers.data.length; i++) { 
    		var column = markers.getAt(i);
    		image = {
	        	url: '/ApplicationImages/VehicleImages/GreenBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};
    		
    		var pos = new google.maps.LatLng(column.data['latitude'], column.data['longitude']); 
        	marker = new google.maps.Marker({
            	position: pos,
            	map: map,
            	icon: image
        	});
        	
			var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="width:100%; height: 100%; float: left; color: #FFF; background:#ed8719; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td><b>Vessel Name:</b></td><td>'+column.data['vesselName']+'</td></tr>'+
			'<tr><td><b>Vessel Id:</b></td><td>'+column.data['vesselId']+'</td></tr>'+
			'<tr><td><b>Latitude:</b></td><td>'+column.data['latitude']+'</td></tr>'+
			'<tr><td><b>Longitude:</b></td><td>'+column.data['longitude']+'</td></tr>'+
			'<tr><td><b>Speed:</b></td><td>'+column.data['speed']+'</td></tr>'+
			'<tr><td><b>Distance:</b></td><td>'+column.data['distance']+'</td></tr>'+
			'</table>'+
			'</div>';
			google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){ 
    			return function() {
        			infowindow.setContent(content);
        			infowindow.open(map,marker);
    			};
			})(marker,content,infowindow));  
    	}
	}

	function setSingleCircles(map, centerLatitude, centerLongitude) {
	
	    if (singleCircleRadius > 0) {
			var convertRadiusToMeters = singleCircleRadius * 1000;
	        var myLatLng = new google.maps.LatLng(centerLatitude, centerLongitude);

	        var createCircle = {
	            strokeColor: '#FF8000',
	            strokeOpacity: 0.8,
	            strokeWeight: 2,
	            fillColor: '#FF8000',
	            fillOpacity: 0.35,
	            map: map,
	            center: myLatLng,
	            radius: convertRadiusToMeters //In meters
	        };
	        circle = new google.maps.Circle(createCircle);
	        circle.setCenter(myLatLng);
	        map.fitBounds(circle.getBounds());
	    }
	}
	
	google.maps.event.addDomListener(window, 'load', initialize);
    </script>
  </body>
</html>