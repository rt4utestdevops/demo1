<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
    <%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
 	SandMiningFunctions sf=new SandMiningFunctions();
		Properties properties = ApplicationListener.prop;
		String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		String sessionmap = (String) session.getAttribute("chooseMapName");
		String vehicleNo = "";
		String id="";
		String datetime = "";
		String location = "";
		String latitude="";
		String longitude="";
		String systemId="";
		String parking_hub_lat ="";
		String parking_hub_lng ="";
		String parkingHubId = "";
		String loading_hub_lat ="";
		String loading_hub_lng ="";
		String loadingHubId = "";
		String stoppageDuration = "";
		String distanceFromHub1 = "";
		String distanceFromHub2 = "";
		String parkingHubName = "";
		String loadingHubName = "";
		
		if (request.getParameter("SandBoatRegNo") != null) {
 		vehicleNo = request.getParameter("SandBoatRegNo");
 		id = request.getParameter("ID");
 		ArrayList<Object> arrayList=sf.getInfo(vehicleNo,id);
 		if(arrayList!=null)
 		{
 		longitude=(String)arrayList.get(0);
 		latitude=(String)arrayList.get(1);
 		location=(String)arrayList.get(2);
 		datetime=(String)arrayList.get(3);
 		systemId=(String)arrayList.get(4);
		parkingHubName=(String)arrayList.get(5);
 		parking_hub_lat=(String)arrayList.get(6);
 		parking_hub_lng=(String)arrayList.get(7);
 		parkingHubId=(String)arrayList.get(8);
		loadingHubName=(String)arrayList.get(9);
 		loading_hub_lat=(String)arrayList.get(10);
 		loading_hub_lng=(String)arrayList.get(11);
 		loadingHubId=(String)arrayList.get(12);
 		stoppageDuration=(String)arrayList.get(13);
 		distanceFromHub1=(String)arrayList.get(14);
 		distanceFromHub2=(String)arrayList.get(15);
 		}
 	}
	  
		System.out.println("vehicleNo:"+vehicleNo+"-datetime:"+datetime+"-location:"+location+"-live Latitude:"+latitude+"-live longitude:"+longitude+"-parking_hub_lat:"+parking_hub_lat+"-parking_hub_lng:"+parking_hub_lng+
		"-parkingHubId:"+parkingHubId+"-loading_hub_lat:"+loading_hub_lat+"-loading_hub_lng:"+loading_hub_lng+"-loadingHubId:"+loadingHubId+"-stoppageDuration:"+stoppageDuration+"-distanceFromHub1:"+distanceFromHub1+
		"-distanceFromHub2:"+distanceFromHub2+"-:parkingHubName"+parkingHubName+"-loadingHubName:"+loadingHubName);
%>

 <!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<pack:style src="/css/RightClick.css" ></pack:style>
	<pack:script src="/js/cancelbackspace.js"></pack:script>
	<pack:style src="/resources/css/ext-all.css" ></pack:style>
	<pack:style src="/css/style.css"></pack:style>
	<pack:style src="/css/googlestyle.css"></pack:style>
	<pack:style src="/css/dhtmlwindow.css"></pack:style>
    <pack:style src="/css/dhtmlwindow-search.css"></pack:style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <pack:script src="/js/common.js"></pack:script> 
	<pack:script src="/js/string.js"></pack:script> 
	<pack:script src="/js/dhtmlwindow.js"></pack:script>
	<pack:script>
	
 	<src>/adapter/ext/ext-base.js</src>
 	<src>/ext-all.js</src>
		  <src>/ext-all-live.js</src>
		   <src>/livegrid-all-debug.js</src>
 	</pack:script>
</head>
<style>
    #pac-input {
        background-color: #fff;
        padding: 0 11px 0 13px;
        width: 300px;
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
        margin-left: 26px;
    }
    #distanceid3 {
        margin-left: 23px;
    }
    #latitudeLabelId8 {
        margin-left: 14px;
    }
    #locationLabelId7 {
        margin-left: 37px;
    }
         
    .mp-vehicle-wrapper {
	width: 19%;
	height: 520px;
	float: left;
	background-color: #ffffff;
}
.mp-container {
	background: #f4f4f4;
	border: 5px solid #fff;
	width: 100%;
	height: 520px;
	float: right;
	margin: auto;
	right: 4%;
	-moz-box-shadow: 1px 1px 3px #cac4ab;
	-webkit-box-shadow: 1px 1px 3px #cac4ab;
	box-shadow: 1px 1px 3px #cac4ab;
}
.mp-map-wrapper {
	width: 100%;
	height: 514px;
	position: absolute;
}
.mp-options-wrapper {
	position: absolute;
	height: 0px;
	background: #FFF;
	bottom: 0px;
	text-align: center;
	width: 100%;
	padding-top: 0px;
}
.selectstylePerfect {
	height: 20px;
	width: 140px !important;
	listwidth: 120px !important;
	max-listwidth: 120px !important;
	min-listwidth: 120px !important;
	margin: 0px 0px 5px 5px !important;
}
</style>

<body onload="initialize();">
    <div class="container">
        <div class="main">
            <div class="mp-vehicle-wrapper" id="location-details"></div>
            <div class="" id="">
                <div class="mp-map-wrapper" id="map"></div>
                <div class="">
                    <input id="pac-input" class="controls" type="text" placeholder="Search Places">
                    <table width="98%">
						<tr height="10px"><td > <div class="mp-option-showhub" id="show"></div></td>
            				
						</tr></table>
                </div>
            </div>
        </div>
    </div>    
        <script src="<%=GoogleApiKey%>"></script>
   		<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
   		<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js"></script>
   		<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>
    <script>
    
        var markers = {};
        var outerPanel;
        var tsb;
        var marker;
        var arr=[];
        var isOnload="false";
        var LatLng1;
        var mapOptions = {
            zoom: 2,
            center: new google.maps.LatLng('0.0', '0.0'),
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var LatLng = new google.maps.LatLng('0.0', '0.0');
        var map = new google.maps.Map(document.getElementById('map'), mapOptions)
        var input = (document.getElementById('pac-input'));
        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);
        var searchBox = new google.maps.places.SearchBox(input);
        var poly;	
	var rulerMarkers = [];
	var latlongClicked = [];
	var rulerlistener;
	var path;	
	var rulerContent;
	var rulerInfowindow;
	var rulerInfowindowArray=[];
	var firstLoad=1;
	var distance=0;
	var totalDistance=[];
	var previousMarker=0;
	var latitude1;
	var longitude1;
	var source;
	var distanceSet;
	var myLatLngS;
	var myLatLngD;
	var directionsDisplay;
	var latitude;
	var longitude;
	var lat;
	var lon;
	var date;
	var location;
	var parking_hub_lat;
	var parking_hub_lng;
	var parkingHubId;
	var polygons =[];
	var polygonmarkers =[];
	var lodingPolygons =[];
	var loadingPolygonmarkers =[];
	var infowindow;
	var firstLoadDetails=0;
	var sliderArray=[];
	var mapviewFullScreen=0;
	var infowindows=[];
	var infowindowsOne= {};
	var markerClusterArray=[];
	var pdfzoom=9;
	function CenterControl(controlDiv, map) {

        // Set CSS for the control border.
        var controlUI = document.createElement('div');
        controlUI.style.backgroundColor = '#fff';
        controlUI.style.border = '2px solid #fff';
        controlUI.style.borderRadius = '3px';
        controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
        controlUI.style.cursor ='pointer';
        controlUI.style.marginBottom = '22px';
        controlUI.style.textAlign = 'center';
        controlUI.title = 'Click to recenter the map';
        controlDiv.appendChild(controlUI);
 		map.controls[google.maps.ControlPosition.LEFT_TOP].push(controlUI);
 		
        // Set CSS for the control interior.
        var controlText = document.createElement('div');
        controlText.style.color = 'rgb(25,25,25)';
        controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
        controlText.style.fontSize = '16px';
        controlText.style.lineHeight = '38px';
        controlText.style.paddingLeft = '5px';
        controlText.style.paddingRight = '5px';
        controlText.innerHTML = 'Download';
        controlUI.appendChild(controlText);
        controlUI.addEventListener('click', function() {
	    pdfnewButton();
        });

      }
	var pdfnewButton = function() {
    var screenshot = {};
    html2canvas(document.getElementById('map'), {
        useCORS: true,
        optimized: false,
        allowTaint: false,
        onrendered: function (canvas) {
            var tempcanvas=document.createElement('canvas');
            tempcanvas.width=1350;
            tempcanvas.height=900;
            var context=tempcanvas.getContext('2d');
            context.drawImage(canvas,0,0,1350,900,0,0,1350,900);
            var link=document.createElement("a");
            link.href=tempcanvas.toDataURL('image/jpg');   //function blocks CORS
            link.download = 'Capture-'+<%="'"+vehicleNo+"'"%>+'.jpg';
            link.click();
        }
    });
}
     function initialize() {
        
     	latitude = <%=latitude%>; 
     	longitude = <%=longitude%>;
          isOnload="true";
          LatLng1 = new google.maps.LatLng(latitude, longitude);
          
          plotSingleVehicle();
          plotParkingPolygon();
     	  plotLoadingPolygon();
     	  
        var centerControlDiv = document.createElement('div');
        var centerControl = new CenterControl(centerControlDiv, map);

        centerControlDiv.index = 1;
        map.controls[google.maps.ControlPosition.TOP_CENTER].push(centerControlDiv);    
       }	

	//**************************************Polygon*****************************************************************	    
	    function plotParkingPolygon()
	    {
	    console.log("poly");
	    var hubid=<%=parkingHubId%>;
	    var polygonCoords=[];
	    var polyList;
			 $.ajax({
                    url: 'https://www.t4uwebapp.com/TelematicsRESTService/services/ServiceProcess/getPolygonMapView/'+hubid,
                    type: "GET",
                    dataType: "json",
                    contentType: 'application/json',
                    success: function(response) {
                        
                     response = JSON.stringify(response);
                     polyList = JSON.parse(response);
                    
	             for (var i = 0; i < polyList["polygonDetails"].length; i++) {
	                 var sequence = polyList["polygonDetails"][i].sequence;
	                 var hubid = polyList["polygonDetails"][i].hubid;
	                 var latitude = polyList["polygonDetails"][i].latitude;
	                 var longitude = polyList["polygonDetails"][i].longitude;
	                // alert(sequence+"  ===  "+hubid+"  ===  "+latitude+"  ===  "+longitude); 
	          
	             if(i!=polyList["polygonDetails"].length-1)
		    	{
			    	var latLong=new google.maps.LatLng(latitude,longitude);
			    	polygonCoords.push(latLong);
			    	continue;
				}
				else
				{  
					var latLong=new google.maps.LatLng(latitude,longitude);
			    	polygonCoords.push(latLong);
				}
  			polygon = new google.maps.Polygon({
    			paths: polygonCoords,
    			strokeColor: 'red',
    			strokeOpacity: 0.8,
    			strokeWeight: 3,
    			fillColor: '#000000',
	            fillOpacity: 0.55
  				});
  			
  			polygonimage = {
	        	url: '/ApplicationImages/VehicleImages/information.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	}; 	
  				
  			  polygonmarker = new google.maps.Marker({
            	position:latLong,
            	map: map,
            	icon:polygonimage
        	});
        	var polygoncontent='<%=parkingHubName%>';
			polygoninfowindow = new google.maps.InfoWindow({
      			content:polygoncontent,
      			marker:polygonmarker
  		});	
  		
     	google.maps.event.addListener(polygonmarker,'click', (function(polygonmarker,polygoncontent,polygoninfowindow){ 
    			return function() {
        			polygoninfowindow.setContent(polygoncontent);
        			polygoninfowindow.open(map,polygonmarker);
    			};
			})(polygonmarker,polygoncontent,polygoninfowindow)); 
			polygonmarker.setAnimation(google.maps.Animation.DROP); 
  			polygon.setMap(map);
  			polygons[hubid]=polygon;
  			polygonmarkers[hubid]=polygonmarker;
  			hubid++;
  			polygonCoords=[];
	  
	   		  } //end of for loop
            }
          });  
	 }
	 
	 
	function plotLoadingPolygon()
	    {
	    console.log("poly");
	    var hubid=<%=loadingHubId%>;
	    var polygonCoords=[];
	   
			var polyList;
			 $.ajax({
                    url: 'https://www.t4uwebapp.com/TelematicsRESTService/services/ServiceProcess/getPolygonMapView/'+hubid,
                    type: "GET",
                    dataType: "json",
                    contentType: 'application/json',
                    success: function(response) {
                        
                     response = JSON.stringify(response);
                     polyList = JSON.parse(response);
                    
	             for (var i = 0; i < polyList["polygonDetails"].length; i++) {
	                 var sequence = polyList["polygonDetails"][i].sequence;
	                 var hubid = polyList["polygonDetails"][i].hubid;
	                 var latitude = polyList["polygonDetails"][i].latitude;
	                 var longitude = polyList["polygonDetails"][i].longitude;
	                // alert(sequence+"  ===  "+hubid+"  ===  "+latitude+"  ===  "+longitude); 
	          
	             if(i!=polyList["polygonDetails"].length-1)
		    	{
			    	var latLong=new google.maps.LatLng(latitude,longitude);
			    	polygonCoords.push(latLong);
			    	continue;
				}
				else
				{  
					var latLong=new google.maps.LatLng(latitude,longitude);
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
		        	url: '/ApplicationImages/VehicleImages/information.png', // This marker is 20 pixels wide by 32 pixels tall.
		        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
		        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
		        	anchor: new google.maps.Point(0, 32)
		    	}; 	
	  				
	  			  polygonmarker = new google.maps.Marker({
	            	position:latLong,
	            	map: map,
	            	icon:polygonimage
	        	});
	        	var polygoncontent='<%=loadingHubName%>';
				polygoninfowindow = new google.maps.InfoWindow({
	      			content:polygoncontent,
	      			marker:polygonmarker
	  		});	
  		
     	google.maps.event.addListener(polygonmarker,'click', (function(polygonmarker,polygoncontent,polygoninfowindow){ 
    			return function() {
        			polygoninfowindow.setContent(polygoncontent);
        			polygoninfowindow.open(map,polygonmarker);
    			};
			})(polygonmarker,polygoncontent,polygoninfowindow)); 
			polygonmarker.setAnimation(google.maps.Animation.DROP); 
  			polygon.setMap(map);
  			lodingPolygons[hubid]=polygon;
  			loadingPolygonmarkers[hubid]=polygonmarker;
  			hubid++;
  			polygonCoords=[];
			   } //end of for loop
            }
          });  
	    }
	
	function plotSingleVehicle() {
	var vehicleNo = '<%=vehicleNo%>';
	var location = '<%=location%>';
	var dateTime = '<%=datetime%>';
	var stoppageDuration = '<%=stoppageDuration%>';
	var distanceFromHub1 = '<%=distanceFromHub1%>';
	var distanceFromHub2 = '<%=distanceFromHub2%>';
	var parkingHubName = '<%=parkingHubName%>';
	var loadingHubName = '<%=loadingHubName%>';
	
	console.log("inside vehicle");
			imageurl = '/ApplicationImages/VehicleImagesNew/sea-ship_BR.png';
		
		image = {
			url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
			scaledSize: new google.maps.Size(35, 35), // The origin for this image is 0,0.
			origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
			anchor: new google.maps.Point(0, 32)
		};
		var pos = new google.maps.LatLng(<%=latitude%>, <%=longitude%>);
		marker = new google.maps.Marker({
			position: pos,
			map: map,
			icon: image
		});

		var content =  '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:13px; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td style=" width: 75px; "><b>Asset No:</b></td><td>'+vehicleNo+'</td></tr>'+
			'<tr><td><b>Date Time:</b></td><td>'+dateTime+'</td></tr>'+
			'<tr><td><b>Location:</b></td><td>'+location+'</td></tr>'+
			'<tr><td><b>Stoppage Duration:</b></td><td>'+stoppageDuration+'</td></tr>'+
			'<tr><td><b>Distance from '+parkingHubName+' :</b></td><td>'+distanceFromHub1+' km</td></tr>'+
			'<tr><td><b>Distance from '+loadingHubName+' :</b></td><td>'+distanceFromHub2+' km</td></tr>'+
			'</table>'+
			'</div>'; 
			
		infowindow = new google.maps.InfoWindow({
			content: content,
			marker: marker,
			maxWidth: 400,
			disableAutoPan: true,
			image: image,
		});

		google.maps.event.addListener(marker, 'click', (function(marker, contents, infowindow) {
			return function() {
				firstLoadDetails = 1;
				infowindow.setContent(content);
				infowindow.open(map, marker);
			       			       			
			};
		})(marker, content, infowindow));
		map.setCenter(pos); 
		 map.setZoom(10);
		markerClusterArray.push(marker);
		infowindows[vehicleNo] = infowindow;
		markers[vehicleNo] = marker;
		
	}

</script>
</body>

</html> 
