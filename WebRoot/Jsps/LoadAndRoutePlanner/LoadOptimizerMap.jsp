<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int systemId = loginInfo.getSystemId();
	Properties properties = ApplicationListener.prop;
	
	String vehicleNo = request.getParameter("vehicleNo");
	String uniqueId = request.getParameter("uniqueId");
	String tripId = request.getParameter("tripId");
	
	String sourceName = properties.getProperty("sourceName");
	String data[] = properties.getProperty("sourceLatLng").split(",");
	String sourceLat = data[0];
	String sourceLon = data[1];
%>
<!DOCTYPE html>
<html>
	<head>
  		<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    	<meta charset="utf-8">
    	<title></title>
    
    	<style>
    		#right-panel {
	        	margin-left:-20px;
      		}

<!--		    #right-panel select, #right-panel input {-->
<!--		    	font-size: 15px;-->
<!--		    }-->
		
<!--		    #right-panel select {-->
<!--		       width: 100%;-->
<!--		    }-->
		
<!--		      #right-panel i {-->
<!--		        font-size: 12px;-->
<!--		      }-->
<!--		      #map {-->
<!--		        height: 100%;-->
<!--		        float: left;-->
<!--		        width: 70%;-->
<!--		        height: 100%;-->
<!--		      }-->
<!--		      #right-panel {-->
<!--		        margin: 20px;-->
<!--		        border-width: 2px;-->
<!--		        width: 20%;-->
<!--		        height: 400px;-->
<!--		        float: left;-->
<!--		        text-align: left;-->
<!--		        padding-top: 0;-->
<!--		      }-->
<!--		      #directions-panel {-->
<!--		        margin-top: 10px;-->
<!--		        background-color: #FFEE77;-->
<!--		        padding: 10px;-->
<!--		        overflow: scroll;-->
<!--		        height: 400px;-->
<!--		      }-->
				.row {
    				margin-right: 0px !important;
    				margin-left: -15px !important;
				}
				.navbar-inverse .navbar-nav>li>a{
					color: white !important;
				}	
			
		</style>
    	
    	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    	
    	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
		<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>
 	
 	</head>
  	
  	<body onload="loadData()">
  	<nav class="navbar navbar-inverse">
  		<div class="container-fluid">
    	<div class="col-lg-8 navbar-header">
<!--      		<a class="navbar-brand" href="#" style="color: red;">Load Optimizer</a>-->
      		 <div class="row" style="color:#fff;padding-top:10px;">
      			<div class="col-lg-4 col-sm-4">
       				<h4>Round Trip</h4> 
   			   </div>
    		  <div class="col-lg-4 col-sm-4">
     			  <h4><span>Vehicle NO: <span><%=vehicleNo%></span></span></h4>
     		 </div>
     		 <div class="col-lg-4 col-sm-4">
     			  <span>Total Distance (km): <span id="kmid"></span></span><br/>
     			  <span>Total Duration (hh:mm): <span id="tid"></span></span>
     		 </div>
   		 </div>
    	</div>
    	<ul class="nav navbar-nav  navbar-right" >
      		<li><a href="<%=request.getContextPath()%>/Jsps/LoadAndRoutePlanner/LoadOptimizerTrip.jsp?uniqueId=<%=uniqueId%>" >Back</a></li>
    	</ul>
  		</div>
	</nav>
  	
  		<div class="col-md-12">
  			<div class="panel panel-default" style="margin-top: -20px;margin-left: -12px; margin-right: -14px;">
<!--  				<div class = "row">-->
<!--  					<div>-->
<!--  						<h4 style="float:left;margin-left:19px;font-size: 14px;">Vehicle No :- <b><%=vehicleNo%> </b></h4>-->
<!--  					</div>-->
<!--  					<div>-->
<!--					    <a href="LoadOptimizerTrip.jsp?uniqueId=<%=uniqueId%>" class="btn btn-info btn-md" style="float: right; border-radius: 10px;margin-right:17px;margin-top:4px;"> -->
<!--					    <span class="glyphicon glyphicon-circle-arrow-left"></span> Back-->
<!--					    </a>-->
<!--				    </div>-->
<!--  				</div>-->
  				<div class="row">
  					<div class="col-lg-9">
			    		<div id="map" style="height: 650px;"></div>
			    	</div>
			    	<div class="col-lg-3">	
				    	<div id="right-panel">
						    <div id="directions-panel"></div>
					    </div>
					</div>   
			    </div>
		    </div>
    	</div>
    
    <script>
		var groupId;
		var waypts=[];
		
		function loadData(){
		//groupId = document.getElementById("vehicleCobmo").value;
			$.ajax({
			url: "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=getRouteDetails", 
		    "dataSrc": "routeDetailsRoot",
		    "data":{
		   		uniqueId: '<%=uniqueId%>',
		   		tripId: '<%=tripId%>' 
		    },
		    success: function(result){
		    	results = JSON.parse(result);
		    	for (var i = 0; i < results["routeDetailsRoot"].length; i++) {
				waypts.push({ 
             		location: new google.maps.LatLng(results["routeDetailsRoot"][i].lat, results["routeDetailsRoot"][i].lon), 
              		stopover: true 
             	}); 
				}
				initMap(waypts,results);
		    }
			});
			
		}

		function initMap(waypts,results) {
        	var directionsService = new google.maps.DirectionsService;
        	var directionsDisplay = new google.maps.DirectionsRenderer;
        	
        	var map = new google.maps.Map(document.getElementById('map'), {
          		zoom: 6,
          		center: {lat: <%=sourceLat%>, lng: <%=sourceLon%>}
        	});
        	directionsDisplay.setMap(map);
          	
          	calculateAndDisplayRoute(directionsService, directionsDisplay,waypts,results);
		}

      	function calculateAndDisplayRoute(directionsService, directionsDisplay,waypts,results) {
      //	var k = results["routeDetailsRoot"].length-1;
            var totalKm=0;
			var totalTime=0;
        	directionsService.route({
          	origin: { lat: <%=sourceLat%>, lng: <%=sourceLon%>},
        //  	destination: new google.maps.LatLng(results["routeDetailsRoot"][k].lat, results["routeDetailsRoot"][k].lon),
            destination: { lat: <%=sourceLat%>, lng: <%=sourceLon%>},
          	waypoints: waypts,
          	optimizeWaypoints: true,
          	travelMode: 'DRIVING'
        	}, function(response, status) {
          		if (status === 'OK') {
            		directionsDisplay.setDirections(response);
            		var route = response.routes[0];
            		var summaryPanel = document.getElementById('directions-panel');
            		summaryPanel.innerHTML = '';
            		var alphaArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W"];
            		// For each route, display summary information.
            		summaryPanel.innerHTML += '<b> A. WareHouse</b><br>';
		            summaryPanel.innerHTML += '<%=sourceName%>' + '<br> <br>';
			          var name;
			         	         
		            for (var i = 0; i < route.legs.length; i++) {
		              var flag = i+1 ;
		              var destEta =false;
		              if(i==route.legs.length-1){
		              name='WareHouse'
		              destEta =false;
		              }else{
		              destEta =true;
		               name=results["routeDetailsRoot"][i].customer;
		              }
		              summaryPanel.innerHTML += '<b>'+alphaArray[flag]+'. '+ name
		                  '</b> <br> ';
		              summaryPanel.innerHTML += '<br>'+ route.legs[i].start_address + ' <strong>to</strong> ';
		              summaryPanel.innerHTML += route.legs[i].end_address + '<br>';
		              summaryPanel.innerHTML += route.legs[i].distance.text + '<br>';
		              summaryPanel.innerHTML += route.legs[i].duration.text + '<br>';
		              if(destEta){
		              	summaryPanel.innerHTML +=  'Destination ETA: '+results["routeDetailsRoot"][i].destETA +'<br>';
		              	summaryPanel.innerHTML +=  'Max ETA: '+results["routeDetailsRoot"][i].maxETA  + '<br> <br>';
		              }
		              
					 
		               totalKm+=route.legs[i].distance.value;
					  totalTime+=route.legs[i].duration.value;
					  
		            }
		              var hours = Math.floor( totalTime / 3600);          
    					var minutes = totalTime % 60;
    					console.log(hours+" : "+minutes);
	       		      $("#kmid").text(totalKm/1000);
        			  $("#tid").text(hours+":"+minutes);  
	          	} else {
            		window.alert('Directions request failed due to ' + status);
          		}
        	});
        
        	
		}
    </script>
    
    <script async defer
    	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCggveSOxAJpx4dq0SKd5zSSS-vXMQEmgE&region=IN">
	</script>
</body>
</html>