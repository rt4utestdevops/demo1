<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	
%>

<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    
       
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">

    <script src="../../Main/Js/jquery.js"></script>
	<script src="../../Main/Js/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	   
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 85%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #floating-panel {
        position: absolute;
        top: 10px;
        left: 25%;
        z-index: 5;
        background-color: #fff;
        padding: 5px;
        border: 1px solid #999;
        text-align: center;
        font-family: 'Roboto','sans-serif';
        line-height: 30px;
        padding-left: 10px;
      }
      #floating-panel {
        background-color: #fff;
        border: 1px solid #999;
        left: 25%;
        padding: 5px;
        position: absolute;
        top: 10px;
        z-index: 5;
      }
    </style>
  </head>

  <body onload="getPoints()">
    <div id="floating-panel">
    </div>
   <div id="map">
    	<div id="page-loader" style="margin-left:500px;margin-top:200px;">
				<img src="../../Main/images/loading.gif" alt="loader" />
		</div>
 
         </div>
           
    <div class="alert alert-info alert-dismissable" id="noteId" style="display:block;padding-top:17px;">
            <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
            <strong>Note: </strong> Harsh Brake Heat Map shows only 3 days data </span> .
        </div>
    <script>

      // This example requires the Visualization library. Include the libraries=visualization
      // parameter when you first load the API. For example:
      // <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=visualization">

        var map, heatmap;
        var pointsArry=[];
        

      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 04,

          center: {lat:23.30, lng: 80.00}
		
        }); 

        heatmap = new google.maps.visualization.HeatmapLayer({
          data: pointsArry,
          map: map
        });
		
		  heatmap.setMap(map);
		  changeGradient();
		  changeOpacity();
		  heatmap.set('radius', 20);
		  
      }
      
      function changeGradient() {
        var gradient = [
          'rgba(0, 255, 255, 0)',
          'rgba(0, 255, 255, 1)',
          'rgba(0, 191, 255, 1)',
          'rgba(0, 127, 255, 1)',
          'rgba(0, 63, 255, 1)',
          'rgba(0, 0, 255, 1)',
          'rgba(0, 0, 223, 1)',
          'rgba(0, 0, 191, 1)',
          'rgba(0, 0, 159, 1)',
          'rgba(0, 0, 127, 1)',
          'rgba(63, 0, 91, 1)',
          'rgba(127, 0, 63, 1)',
          'rgba(191, 0, 31, 1)',
          'rgba(255, 0, 0, 1)'
        ]
        heatmap.set('gradient', heatmap.get('gradient') ? null : gradient);
      }
      function changeOpacity() {
        heatmap.set('opacity', heatmap.get('opacity') ? 0.2 : null);
      }


      function getPoints() {
	  var latlngPoints;
	  var lat;
	  var lng;
	  document.getElementById("page-loader").style.display="block";
	   $.ajax({
        url: '<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getHBpoints',
          success: function(result) {
                   latlngPoints = JSON.parse(result);
         for (var i = 0; i < latlngPoints["getHBpointsData"].length; i++) {
			 lat = latlngPoints["getHBpointsData"][i].lat;
			 lng = latlngPoints["getHBpointsData"][i].lng;
			 pointsArry.push(new google.maps.LatLng(lat,lng));
       		}
       		
		  initMap();
		  document.getElementById("page-loader").style.display="none";
			}
			 });
       // return pointsArry;
      }
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBRq833ih3sg96f9LQ4Gpgk8qPSVaSuLH4&region=IN&libraries=visualization">
    </script>
  </body>
</html>