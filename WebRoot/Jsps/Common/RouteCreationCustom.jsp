<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
		loginInfo.setCustomerName(str[8].trim());
	}
	
	if(str.length>12){
		loginInfo.setStyleSheetOverride(str[12].trim());	
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
int custId= 0;
String buttonValue="";
int routeId=0;
String routeName="";
String source="";
String destination="";
String actualduration="";
String expDuration="";
float actualDistance=0;
float expDistance=0;
String routeDesp="";
String custName="";
int radius=0;
float SourceRadius=0;
float destRadius=0;
String createTrip="";
String createRouteFromTrip="";
String vehicleNo = "";
if(request.getParameter("custId") != null && !request.getParameter("custId").equals("")){
	custId = Integer.parseInt(request.getParameter("custId")); 
}
if(request.getParameter("buttonValue") != null && !request.getParameter("buttonValue").equals("")){
	buttonValue = request.getParameter("buttonValue");
}
if(request.getParameter("routeId") != null && !request.getParameter("routeId").equals("")){
	routeId = Integer.parseInt(request.getParameter("routeId")); 
}		
if(request.getParameter("routeName") != null && !request.getParameter("routeName").equals("")){
	routeName = request.getParameter("routeName"); 
}
if(request.getParameter("source") != null && !request.getParameter("source").equals("")){
	source = request.getParameter("source"); 
}
if(request.getParameter("destination") != null && !request.getParameter("destination").equals("")){
	destination = request.getParameter("destination"); 
}
if(request.getParameter("actualDistance") != null && !request.getParameter("actualDistance").equals("")){
	actualDistance = Float.parseFloat(request.getParameter("actualDistance")); 
}
if(request.getParameter("expDistance") != null && !request.getParameter("expDistance").equals("")){
	expDistance = Float.parseFloat(request.getParameter("expDistance")); 
}
if(request.getParameter("actualduration") != null && !request.getParameter("actualduration").equals("")){
	actualduration = request.getParameter("actualduration"); 
}
if(request.getParameter("expDuration") != null && !request.getParameter("expDuration").equals("")){
	expDuration = request.getParameter("expDuration"); 
}
if(request.getParameter("routeDesp") != null && !request.getParameter("routeDesp").equals("")){
	routeDesp =  request.getParameter("routeDesp");
}
if(request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
	custName =  request.getParameter("custName");
}
if(request.getParameter("radius") != null && !request.getParameter("radius").equals("")){
	radius =  Integer.parseInt(request.getParameter("radius"));
}
if(request.getParameter("viewFromCreateTrip") != null && !request.getParameter("viewFromCreateTrip").equals("")){
	createTrip = request.getParameter("viewFromCreateTrip");
}
if(request.getParameter("createRouteFromTrip") != null && !request.getParameter("createRouteFromTrip").equals("")){
	createRouteFromTrip = request.getParameter("createRouteFromTrip");
}
if(request.getParameter("vehicleNo") != null && !request.getParameter("vehicleNo").equals("")){
	vehicleNo = request.getParameter("vehicleNo"); 
}
String pageFlag = request.getParameter("pageFlag");
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
String customerName1 = loginInfo.getCustomerName();
Properties properties = ApplicationListener.prop;
//String GoogleApiKey ="AIzaSyDpDMA-NB9HEmfZYqOHXaQV63RGdhBJrpw"; //AIzaSyDubqhG46TgAY3teTWzSSkEJ-N0DMdQ1vY"; // properties.getProperty("GoogleMapApiKeyen").trim();
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	String GoogleAPIKEY = GoogleApiKey + "&libraries=places,drawing";
int countryId = 0;//loginInfo.getCountryCode();
String countryName = "";// cf.getCountryName(countryId);
String latitudeLongitude = cf.getCoordinates(systemid);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
    <title>RouteCreation</title>
    
    <pack:script src="../../Main/Js/jquery.min.js"></pack:script>
				<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>
                <pack:script src="../../Main/Js/jQueryMask.js"></pack:script>
                <pack:style src="../../Main/modules/common/jquery.loadmask.css" />
                <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
      			<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
      			
      			<script src='<%=GoogleAPIKEY%>'></script>
    

    <style>
        .selectstylePerfect1 {
            height: 20px;
            width: 230px !important;
            listwidth: 120px !important;
            max-listwidth: 230px !important;
            min-listwidth: 120px !important;
            margin: 0px 0px 5px 5px !important;
        }
        .btn-primary {
            color: #fff;
            background-color: #337ab7;
            border-color: #2e6da4;
        }
        .btn {
            display: inline-block;
            padding: 6px 12px;
            margin-bottom: 0;
            font-size: 14px;
            font-weight: 400;
            line-height: 1.42857143;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            -ms-touch-action: manipulation;
            touch-action: manipulation;
            cursor: pointer;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
            background-image: none;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        #room_fileds {
            height: 500px;
            max-height: 357px;
            overflow: auto;
            background-color: #fff;
            border: solid 2px #A5BED1;
        }
        #pac-dest {
            height: 28px;
            margin-right: -362px;
        }
        #pac-origin {
            height: 28px;
            margin-right: 318px;
        }
        #target,#checkPtradius, #type,#checkPointName,#detentionTime{
	          display: inline-block;
	          padding: 6px 12px;
	          font-size: 14px;
	          line-height: 1.428571429;
	          color: #555;
	          vertical-align: middle;
	          background-color: #fff;
	          background-image: none;
	          border: 1px solid black;
	          border-radius: 4px;
	          -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	          box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	          -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	      }
           button,
           html input[type="button"],
           input[type="reset"],
           input[type="submit"] {
               display: inline-block;
               padding: 6px 12px;
               margin-bottom: 0;
               font-size: 14px;
               font-weight: normal;
               line-height: 1.428571429;
               text-align: center;
               white-space: nowrap;
               vertical-align: middle;
               cursor: pointer;
               background-image: none;
               border: 1px solid transparent;
               border-radius: 4px;
               -webkit-user-select: none;
               -moz-user-select: none;
               -ms-user-select: none;
               -o-user-select: none;
               user-select: none;
               background-color: #4bc2e8;
           }
           .select2-container--default .select2-selection--single{
           	font-size: 13px !important;
           }
    </style>
</head>
  
<body onload="ShowRoute()">
    <%if (loginInfo.getStyleSheetOverride().equals( "Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else {%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%} %>

	<script>
		var outerPanel;
		var map;
		var drawingManager;
		var markers = null;
		var pointer = null;
		var objLatLngSource = null;
		var line;
		var sourcelatlng;
		var objLatLngDest = null;
		var directionsDisplay;
		var sourceMarker = null;
		var destMarker = null;
		var viewMarkerLat = null;
		var viewMarkerLng = null;
		var bounds;
		var markers;
		var CPLat;
		var CPLng;
		var jsonArray;
		var wayPts = [];
		var checkPointArray = [];
		var checkPointD = "";
		var custId = '<%=custId%>';
		var buttonValue = '<%=buttonValue%>';
		var routeId = '<%=routeId%>';
		var custName = '<%=custName%>';
		var countryName = '<%=countryName%>';
		var systemid = '<%=systemid%>';
		var total_pickup_distance = 0;
		var plotFlag = false;
		var checkPointFlag = false;
		var totalDurationMin = 0;
		var distUnits = "";
		var loc = "";
		var locArray=[];
		var myMarker;
		var createTrip='<%=createTrip%>';
		var createRouteFromTrip='<%=createRouteFromTrip%>';
		var circleArray = [];
		var Markerinfowindow;
		var sHubId=0;
		var dHubId=0;
		var MarkerinfowindowArr=[];
		var	polygonCoords=[];
		var deliveryWindow;

    function loadMap() {

        var mapOptions = {
            center: new google.maps.LatLng(<%=latitudeLongitude%>),//23.524681, 77.810561),
            zoom: 5,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            gestureHandling: 'greedy'
        };

        map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
        
        var placeSearch = document.getElementById('target');
	        var autocomplete = new google.maps.places.Autocomplete(placeSearch);
		   autocomplete.bindTo('bounds', map);
		        myMarker = new google.maps.Marker({
		          map: map
		        });
		  autocomplete.addListener('place_changed', function() {

	          var sourcePlace = autocomplete.getPlace();
	          if (sourcePlace.geometry.viewport) {
	            map.fitBounds(sourcePlace.geometry.viewport);
	            map.setZoom(16); 
	          } else {
	            map.setCenter(sourcePlace.geometry.location);
	            map.setZoom(17);  // Why 17? Because it looks good.
	          }
	          myMarker.setVisible(true);
	          myMarker.setPosition(sourcePlace.geometry.location);
	          locArray.push(myMarker);
	        });


        var sourceInput = document.getElementById('sourceNameId');
        var autocompleteSource = new google.maps.places.Autocomplete(sourceInput);
        autocompleteSource.bindTo('bounds', map);
        sourceMarker = new google.maps.Marker({
            map: map,
            draggable: true,
            anchorPoint: new google.maps.Point(0, -29)
        });
        sourcelatlng = sourceMarker.getPosition();
        autocompleteSource.addListener('place_changed', function() {
        	var sourceInput1 = Ext.getCmp('sourceNameId').getValue();
	        sourceInputarr1=sourceInput1.split(',');
	        if(sourceInputarr1.length ==2){
	        	Ext.getCmp('addButtonId1').enable();
	        }else{
	        	Ext.getCmp('addButtonId1').disable();
	        }
            sourceMarker.setVisible(false);
            locArray.push(sourceMarker);
            var sourcePlace = autocompleteSource.getPlace();
            sourcelatlng = sourceMarker.getPosition();
            if (!sourcePlace.geometry) {
                window.alert("No details available for input: '" + sourcePlace.name + "'");
                return;
            }
            if (sourcePlace.geometry.viewport) {
                map.fitBounds(sourcePlace.geometry.viewport);
            } else {
                map.setCenter(sourcePlace.geometry.location);
                map.setZoom(17); // Why 17? Because it looks good.
            }
            sourceMarker.setPosition(sourcePlace.geometry.location);
            sourceMarker.setVisible(true);
            objLatLngSource = sourceMarker.getPosition();
            var addressSource = '';
            if (sourcePlace.address_components) {
                addressSource = [
                    (sourcePlace.address_components[0] && sourcePlace.address_components[0].short_name || ''), (sourcePlace.address_components[1] && sourcePlace.address_components[1].short_name || ''), (sourcePlace.address_components[2] && sourcePlace.address_components[2].short_name || '')
                ].join(' ');
            }
        });

        google.maps.event.addListener(sourceMarker, 'dragend', function() {

            var geocoderSource = new google.maps.Geocoder;
            var cityNameSource = "";
            var areaNameSource = "";
            var stateNameSource = "";
            objLatLngSource = sourceMarker.getPosition(); //.toString();
            var addressboxSource = "";
            geocoderSource.geocode({
                'location': objLatLngSource
            }, function(results, status) {
                addressboxSource = results[0].formatted_address;
                document.getElementById('sourceNameId').value = addressboxSource;
            });
        });

        var destInput = document.getElementById('destinationNameId');
        var autocompleteDest = new google.maps.places.Autocomplete(destInput);
        autocompleteDest.bindTo('bounds', map);
        destMarker = new google.maps.Marker({
            map: map,
            draggable: true,
            anchorPoint: new google.maps.Point(0, -29)
        });
        autocompleteDest.addListener('place_changed', function() {
        	var destInput1 = Ext.getCmp('destinationNameId').getValue();
	        destInputarr1=destInput1.split(',');
	        if(destInputarr1.length ==2){
        		Ext.getCmp('addButtonId2').enable();
	        }else{
        		Ext.getCmp('addButtonId2').disable();
	        }
	                        
            destMarker.setVisible(false);
            var destplace = autocompleteDest.getPlace();
            if (!destplace.geometry) {
                window.alert("No details available for input: '" + place.name + "'");
                return;
            }
            if (destplace.geometry.viewport) {
                map.fitBounds(destplace.geometry.viewport);
            } else {
                map.setCenter(destplace.geometry.location);
                map.setZoom(17);
            }
            destMarker.setPosition(destplace.geometry.location);
            destMarker.setVisible(true);
            locArray.push(destMarker);
            objLatLngDest = destMarker.getPosition();
            document.getElementById("messageBoxId").innerHTML = "Click on \"Plot Route\" after source and destination are selected";
            var addressdest = '';
            if (destplace.address_components) {
                addressdest = [
                    (destplace.address_components[0] && destplace.address_components[0].short_name || ''), (destplace.address_components[1] && destplace.address_components[1].short_name || ''), (destplace.address_components[2] && destplace.address_components[2].short_name || '')
                ].join(' ');
            }
        });

        google.maps.event.addListener(destMarker, 'dragend', function() {
            var geocoderDest = new google.maps.Geocoder;
            var cityNameDest = "";
            var areaNameDest = "";
            var stateNameDest = "";
            objLatLngDest = destMarker.getPosition(); //.toString();
            var addressboxdest = "";
            geocoderDest.geocode({
                'location': objLatLngDest
            }, function(results, status) {
                addressboxdest = results[0].formatted_address;
                document.getElementById('destinationNameId').value = addressboxdest;
            });

        });
    }
 
 var routedetailsstore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getLatLongs',
     id: 'RouteDetailstoreId',
     root: 'latLongRoot',
     autoLoad: false,
     remoteSort: true,
     fields: ['sequence', 'lat', 'long', 'type', 'alias']
 });
 
  var routeDataStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getRouteDetails',
     id: 'RouteDatastoreId',
     root: 'RouteDataRoot',
     autoLoad: false,
     remoteSort: true,
     fields: ['routeNameDataIndex', 'routeFromDataIndex', 'routeToDataIndex', 'actualTimeDataIndex', 'despDataIndex', 'tempDistanceDataIndex', 'actualDistanceDataIndex', 'tempTimeDataIndex', 'radiusDataIndex']
 });
 
 function plotRoute(latlongorigin, latlongDestination) {
	if (directionsDisplay != null) {
         directionsDisplay.setMap(null);
     }
     for(var i = 0; i < locArray.length; i++){
    	locArray[i].setMap(null);
     }
 	if(Ext.getCmp('radioCustom').getValue() == true){
         if (Ext.getCmp('sourceNameId').getValue() == "") {
             document.getElementById("messageBoxId").innerHTML = "Enter source address";
             Ext.getCmp('sourceNameId').focus();
             return;
         }
         if (Ext.getCmp('destinationNameId').getValue() == "") {
             document.getElementById("messageBoxId").innerHTML = "Enter destination address";
             Ext.getCmp('destinationNameId').focus();
             return;
         }
     }else{
     	         if (Ext.getCmp('sourcecomboId').getValue() == "") {
             document.getElementById("messageBoxId").innerHTML = "Enter source address";
             Ext.getCmp('sourcecomboId').focus();
             return;
         }
         if (Ext.getCmp('destinationcomboId').getValue() == "") {
             document.getElementById("messageBoxId").innerHTML = "Enter destination address";
             Ext.getCmp('destinationcomboId').focus();
             return;
         }
     }
         if (plotFlag == false) {
             document.getElementById("messageBoxId").innerHTML = "Click on \"Add Check Point\" button to add check points to your route";
         }
         var directionsService = new google.maps.DirectionsService;
         directionsDisplay = new google.maps.DirectionsRenderer({
             map: map,
             draggable: true
         });
       google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {
           plotDrag(directionsDisplay.directions, map, directionsDisplay); // ,total_pickup_distance, total_duration);
       });
       sourceMarker.setVisible(false);
       destMarker.setVisible(false);
       plotFlag = true;
       total_pickup_distance = 0;
       totalDurationMin = 0;
       distUnits = 0;
       checkPointD = "";
       directionsService.route({
           origin: latlongorigin,
           destination: latlongDestination,
           travelMode: google.maps.TravelMode.DRIVING,
           waypoints: wayPts

       }, function(response, status) {
           if (status === google.maps.DirectionsStatus.OK) {
               directionsDisplay.setDirections(response);
           } else {
               console.log("Invalid Request");
           }
       });
       }

     function addCheckPoint() {
	 if(Ext.getCmp('radioCustom').getValue() == true){
	 $('#deliveryId').hide();
	 	if (Ext.getCmp('sourceNameId').getValue() == "") {
         document.getElementById("messageBoxId").innerHTML = "Enter source address";
         Ext.getCmp('sourceNameId').focus();
         return;
     }
     if (Ext.getCmp('destinationNameId').getValue() == "") {
         document.getElementById("messageBoxId").innerHTML = "Enter destination address";
         Ext.getCmp('destinationNameId').focus();
         return;
     }

     if (directionsDisplay == null) {
         document.getElementById("messageBoxId").innerHTML = "Plot route before adding check point";
     }
     if (checkPointFlag == false) {
         document.getElementById("messageBoxId").innerHTML = "Click on the map to add a check point";
     }
      Ext.getCmp('addButtonId').disable();
     var mode;
     var dmodes;
     mode = google.maps.drawing.OverlayType.MARKER;
     dmodes = 'marker';
     drawingManager = new google.maps.drawing.DrawingManager({
         drawingMode: mode,
         drawingControl: true,
         drawingControlOptions: {
             position: google.maps.ControlPosition.TOP_CENTER,
             drawingModes: [dmodes]
         },
         markerOptions: {

         }
     });
     drawingManager.setMap(map);

     google.maps.event.addListener(drawingManager, 'markercomplete', function(marker) {
         markers = marker;
         marker.setOptions({
             draggable: true
         });

         drawingManager.setOptions({
             drawingControl: false
         });
         drawingManager.setDrawingMode(null);
         var objLatLngCP = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
         CPLat = objLatLngCP[0];
         CPLat = CPLat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
         CPLng = objLatLngCP[1];
         CPLng = CPLng.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma

         getInfoWindowOnMarker(marker, CPLat, CPLng);
         google.maps.event.addListener(marker, 'dragend', function() {
             var objLatLngCP = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
             CPLat = objLatLngCP[0];
             CPLat = CPLat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
             CPLng = objLatLngCP[1];
             CPLng = CPLng.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
         });

         google.maps.event.addListener(map, 'click', function(event) {
             marker.setPosition(event.latLng);
             CPLat = event.latLng.lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
             CPLng = event.latLng.lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
          });
         google.maps.event.addListener(marker, 'click', function() {
             var objLatLngCP = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
             CPLat = objLatLngCP[0];
             CPLat = CPLat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
             CPLng = objLatLngCP[1];
             CPLng = CPLng.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
             getInfoWindowOnMarker(marker, CPLat, CPLng);

         });
         var objLatLngCP = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
         CPLat = objLatLngCP[0];
         CPLat = CPLat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
         CPLng = objLatLngCP[1];
         CPLng = CPLng.toString().replace(/(\.\d{1,5})\d*$/, "$1").trim(); // Set 5 Digits after comma
     });
	 }else{
	 	$('#deliveryId').show();
		$.ajax({ 
	  	url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getSourceAndDestination',
           data:{
                   CustId:<%=custId%>
           },
            success: function(response) {
                hubList = JSON.parse(response);
                for (var i = 0; i < hubList["sourceRoot"].length; i++) {
                    $('#deliveryId').append($("<option></option>").attr("value", hubList["sourceRoot"][i].Hub_Id).attr("latitude",hubList["sourceRoot"][i].latitude)
                    .attr("longitude",hubList["sourceRoot"][i].longitude).attr("radius",hubList["sourceRoot"][i].radius).text(hubList["sourceRoot"][i].Hub_Name).attr("detention",hubList["sourceRoot"][i].detention));
                }
                $('#deliveryId').select2();
            }
           });
           	 	if (Ext.getCmp('sourcecomboId').getValue() == "") {
         document.getElementById("messageBoxId").innerHTML = "Enter source address";
         Ext.getCmp('sourcecomboId').focus();
         return;
     }
     if (Ext.getCmp('destinationcomboId').getValue() == "") {
         document.getElementById("messageBoxId").innerHTML = "Enter destination address";
         Ext.getCmp('destinationcomboId').focus();
         return;
     }
	 	  if (directionsDisplay == null) {
         		document.getElementById("messageBoxId").innerHTML = "Plot route before adding check point";
     		}else{
      		Ext.getCmp('addButtonId').disable();
      		document.getElementById("messageBoxId").innerHTML = "Please select delivery points, then save route";
      		}
	 }
 }
 var contentString;
	function createInfoWindow(latitudeInfo,longitudeInfo,location,hubId){
		 $.ajax({
            url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getType',
            success: function(response) {
	            typeList = JSON.parse(response);
	           	for (var i = 0; i < typeList.length; i++) {
					var type=typeList[i].type;
					$('#type').append($("<option></option>").attr("id",type).text(type));
	            }
            }
        });
        loc=location.split(',');
        loc1=loc[0];
       	 contentString  = ' <div > ' +
                             ' <span style="font-weight: 600;">Check Point : </span> ' +
                             ' <input type="text" id="checkPointName" maxlength="50" value="'+loc1+'" style="width: 260px;margin-bottom: 6px;margin-left: 116px;" /><br> ' +
                             ' <span style="font-weight: 600;">Type : </span> ' +
                             ' <select name="type" id="type" placeholder="Select Type" style="width: 260px;margin-bottom: 6px;margin-left: 158px;">' +
                             ' <option value="">Select Type....</option> ' +
             				 ' </select> <br>' +
             				 ' <span style="font-weight: 600;">Radius (Meters) : </span> ' +
                             ' <input type="number"  id="checkPtradius" min="1" max="999999" maxlength="6"  value="" style="width: 260px;margin-bottom: 6px;margin-left: 93px;" /><br> ' +
                             ' <span style="font-weight: 600;">Detention Time (HH:mm): </span> ' +
                             ' <input type="text" min="0" id="detentionTime" value="" style="width: 260px;margin-bottom: 6px;margin-left: 44px;" /><br> ' +
                             ' <input type="button" value="Save" id="saveInfo" onclick="saveInfoWindowDetails(' + latitudeInfo + ',' + longitudeInfo + ','+hubId+')" style="margin-left: 114px;"/> ' +
                             ' <input type="button" value="Cancel" id="cancelInfo" onclick="cancel()" /> ' +
                             ' </div> ';
	}
       function getInfoWindowOnMarker(marker, CPLat, CPLng) {
      	   createInfoWindow(CPLat, CPLng,'',0);
           infoWindow = new google.maps.InfoWindow({
               content: contentString
           });
 		   infoWindow.setPosition(marker.getPosition());
           infoWindow.open(map, marker);
           checkPointFlag = true;
       }

       function getInfoWindowOnCheckPoint(myLocLatLng,id) {
           var image = {
					            url: '/ApplicationImages/VehicleImages/blue1.png', // This marker is 20 pixels wide by 32 pixels tall.
					            size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
					            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
					            anchor: new google.maps.Point(0, 32)
					        };
					        var markerContent='';
					        marker = new google.maps.Marker({
					            map: map,
					            position: myLocLatLng,
					            icon: image
					        });
					        marker.set("id", id);
					         MarkerinfowindowArr.push(marker);
							google.maps.event.addListener(marker, "click", function (event) {
								createInfoWindow(obj1["checkPoint"][this.id].latitude,obj1["checkPoint"][this.id].longitude,
								obj1["checkPoint"][this.id].Hub_Name,obj1["checkPoint"][this.id].Hub_Id);
	                         Markerinfowindow=new google.maps.InfoWindow({
					           content: contentString
					         });
					       
					         if (Markerinfowindow) {
	          					Markerinfowindow.close(); 
	          			     }
	                         Markerinfowindow.open(map, this);
	                         document.getElementById("messageBoxId").innerHTML = "";
							}); 
       }       
       function showHub(){
			$.ajax({
             url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getCheckPoints',
             data: {
                CustId: custId
             },
             success: function(response) {
                 obj1 = JSON.parse(response);
                 size = obj1["checkPoint"].length;
                 for (i = 0; i <= obj1["checkPoint"].length - 1; i++) {
                 	var myLocLatLng = new google.maps.LatLng(obj1["checkPoint"][i].latitude,obj1["checkPoint"][i].longitude);
                 	//drawPolygon(obj1["checkPoint"][i].Hub_Id);
                 	getInfoWindowOnCheckPoint(myLocLatLng,i);
                 	var convertintomtrs = obj1["checkPoint"][i].radius * 1000;
                    if(obj1["checkPoint"][i].radius == '-1' || obj1["checkPoint"][i].radius== -1){
                    	drawPolygon(obj1["checkPoint"][i].Hub_Id);
                    }else{
                    	DrawCircle(myLocLatLng, convertintomtrs);
                    }
                 }
             }
         });
	   }


       function clearCheckPoints() {
           checkPointArray = [];
           wayPts = [];
           total_pickup_distance = 0;
           total_duration = 0;
           Ext.getCmp('addButtonId').enable();
           if (directionsDisplay != null) {
               directionsDisplay.setMap(null);
           }
           Ext.getCmp('sourceNameId').reset();
           Ext.getCmp('sourceAliasId').reset();
           Ext.getCmp('destinationNameId').reset();
           Ext.getCmp('destinationAliasId').reset();
           Ext.getCmp('routeNameId').reset();
           Ext.getCmp('routeDescriptionId').reset();
           Ext.getCmp('actualKmId').reset();
           Ext.getCmp('expectedKmId').reset();
           Ext.getCmp('actualTimeId').reset();
           Ext.getCmp('expectedTimeId').reset();
           Ext.getCmp('radiusId').reset();
           Ext.getCmp('sourcecomboId').reset();
           Ext.getCmp('destinationcomboId').reset();
           document.getElementById('messageBoxId').innerHTML = "";
           if(markers!=null){
           	   markers.setMap(null);
           }
           for(var i = 0; i < locArray.length; i++){
        	 locArray[i].setMap(null);
           }
	       for(var i=0;i<MarkerinfowindowArr.length;i++){
			MarkerinfowindowArr[i].setMap(null);
		   }
		   for (var i = 0; i < circleArray.length; i++) {
              circleArray[i].setMap(null);
           }
           for (var i = 0; i < polygonCoords.length; i++) {
              polygonCoords[i].setMap(null);
           }
           
       }

       function saveInfoWindowDetails(CPLat, CPLng,ChubId) {
           if (document.getElementById("checkPointName").value == "") {
               document.getElementById("messageBoxId").innerHTML = "Enter check point name";
               return;
           }
           if (document.getElementById("type").value == "") {
               document.getElementById("messageBoxId").innerHTML = "Enter type";
               return;
           }
           
           if (document.getElementById("checkPtradius").value == "") {
               document.getElementById("messageBoxId").innerHTML = "Enter radius in Numbers";
               return;
           }
           if (document.getElementById("detentionTime").value == "") {
               document.getElementById("messageBoxId").innerHTML = "Enter Detention Time";
               return;
           }
           var datePattern = /^([01]\d|2[0-3]):?([0-5]\d)$/;
           if(!datePattern.test(document.getElementById("detentionTime").value)){
           	   document.getElementById("messageBoxId").innerHTML = "Enter detention time as HH:mm format";
               return;
           }
           
            var radiusPattern = /^\d{1,6}$/;
           if(!radiusPattern.test(document.getElementById("checkPtradius").value)){
           	   document.getElementById("messageBoxId").innerHTML = "Enter 6 Number Radius";
               return;
           }
           
           var CheckPointName = document.getElementById("checkPointName").value;
           var CheckRadius = document.getElementById("checkPtradius").value;
           var CheckType = document.getElementById("type").value;
           var detentionTime = document.getElementById("detentionTime").value;
           var i = 1;
           checkPointArray.push('{' + CheckPointName + ',' + new google.maps.LatLng(CPLat, CPLng) + ',' + CheckRadius + ',' +  CheckType + ',' +  detentionTime + ',' +ChubId +'}');
           wayPts.push({
               location: new google.maps.LatLng(CPLat, CPLng),
               stopover: true
           });
           plotRoute(objLatLngSource, objLatLngDest);
           $('#checkPointName').val("");
           $('#checkPtradius').val("");
           $('#type').val("");
           $('#detentionTime').val("");
           
           if(Ext.getCmp('radioCustom').getValue() == true){
           	infoWindow.close();
           	markers.setMap(null);
           }else{
           Markerinfowindow.close();
           }
           
           Ext.getCmp('addButtonId').enable();
           
           document.getElementById('target').innerHTML = '';
         }

       function cancel() {
           $('#checkPointName').val("");
           $('#detentionTime').val("");
           if(Ext.getCmp('radioCustom').getValue() == true){
           	infoWindow.close();
           	markers.setMap(null);
           }else{
           Markerinfowindow.close();
           }
           Ext.getCmp('addButtonId').enable();
           markers.setMap(null);
       }

       function plotDrag(result, map, directionsDisplay) {
           total_pickup_distance = 0;
           totalDurationMin = 0;
           distUnits = 0;
           checkPointD = "";

           var myRoute = result.routes[0].legs[0];
           jsonArray = [];
           var formattedTmeInMin = 0;
           for (var i = 0; i < result.routes[0].legs.length; i++) {
               var tempDuration = result.routes[0].legs[i].duration.text;
               var tempDist = result.routes[0].legs[i].distance.text;
               //   alert("TEMP DIST : "+tempDist+" AND TEMP TIME : "+tempDuration);
               checkPointD += tempDuration + ",";
               var containsKm = tempDist.indexOf("mi");
               if (containsKm == -1) {
                   distUnits = " KM";
               } else { //if(tempDist.indexOf("mi")){
                   distUnits = " MI";
               }
               tempDist = tempDist.replace("km", "").replace("mi", "").replace(",", "");
               total_pickup_distance += parseFloat(tempDist); 
               var containsDay = tempDuration.indexOf("day");
               var containsHrs = tempDuration.indexOf("hour");

               if (containsDay != -1 && containsHrs != -1) {
                   var durStrDay = [];
                   durStrDay = tempDuration.split("day");
                   var day = durStrDay[0];
                   var hrs = durStrDay[1];
                   day = day.replace("day", "").replace("s", "").replace(" ", "");
                   hrs = hrs.replace("hour", "").replace("s", "").replace(" ", "");
                   var formattedHours = 0;
                   var dayInMin = 0;
                   dayInMin = (parseInt(day)) * 1440; // (24 X 60 = 1440)
                   formattedHours = (parseInt(hrs)) * 60;
                   formattedTmeInMin = dayInMin + formattedHours;
                   totalDurationMin += parseInt(formattedTmeInMin);
               } else if (containsDay == -1 && containsHrs != -1) {
                   var durStr = [];
                   durStr = tempDuration.split("hour");
                   var hours = durStr[0];
                   var mins = durStr[1];
                   hours = hours.replace("hour", "").replace("s", "").replace(" ", "");
                   mins = mins.replace("min", "").replace("s", "").replace(" ", "");
                   var formattedHours = 0;

                   formattedHours = (parseInt(hours)) * 60;
                   formattedTmeInMin = formattedHours + (parseInt(mins));
                   totalDurationMin += parseInt(formattedTmeInMin);

               } else {
                   var mins = 0;
                   mins = tempDuration;
                   mins = mins.replace("min", "").replace("s", "").replace(" ", "");
                   totalDurationMin += parseInt(mins);
               }
           }
           if (totalDurationMin != 0) {
               var hours = 0;
               var mod = 0;
               hours = parseInt(totalDurationMin / 60);
               mod = parseInt(totalDurationMin % 60);

               var tempMod = "";
               tempMod = tempMod + mod;
               if (tempMod.length == 1) {
                   mod = '0' + mod;
               }
               totalDurationMin = hours + "." + mod;
           }
           //alert("DIST : "+total_pickup_distance+"  TIME :"+totalDurationMin);  
           Ext.getCmp('actualKmId').setValue(total_pickup_distance.toFixed(2) + distUnits);
           Ext.getCmp('actualTimeId').setValue(totalDurationMin);

           currentRoute = result.routes[0].overview_path;
           for (var i = 0; i < currentRoute.length; i++) {
               jsonArray.push('{' + (i + 1) + ',' + currentRoute[i].lat() + ',' + currentRoute[i].lng() + '}');
           }

       }

		function saveRoute() {
		if(Ext.getCmp('radioCustom').getValue() == true){
			if (Ext.getCmp('sourceNameId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter Source";
				Ext.getCmp('sourceNameId').focus();
				return;
			}
			if (Ext.getCmp('destinationNameId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter Destination";
				Ext.getCmp('destinationNameId').focus();
				return;
			}
			
		  if((objLatLngSource.lat()==objLatLngDest.lat()) && (objLatLngSource.lng()==objLatLngDest.lng())){
			  if(checkPointArray.length <= 0){
					document.getElementById("messageBoxId").innerHTML = "Soure and destination can not be same. Please add check point";
					return;
				}
		  }
			
		}else{
			sHubId=Ext.getCmp('sourcecomboId').getValue();
			dHubId=Ext.getCmp('destinationcomboId').getValue();
			if (Ext.getCmp('sourcecomboId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter Source";
				Ext.getCmp('sourcecomboId').focus();
				return;
			}
			if (Ext.getCmp('destinationcomboId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter Destination";
				Ext.getCmp('destinationcomboId').focus();
				return;
			}
			if(Number(sHubId) == Number(dHubId)){
				if(checkPointArray.length <= 0){
					document.getElementById("messageBoxId").innerHTML = "Soure and destination can not be same. Please add check point";
					return;
				}
			}
		}

			if (Ext.getCmp('routeNameId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter Route Name";
				Ext.getCmp('routeNameId').focus();
				return;
			}else{
				var idO = RouteNameStore.findExact('Route_Name', Ext.getCmp('routeNameId').getValue());
				var recordO = SourcecomboStore.getAt(idO);
				if(idO >=1){
					document.getElementById("messageBoxId").innerHTML = "Route name already exists";
					Ext.getCmp('routeNameId').focus();
					return;
				}
			
			}
			if (Ext.getCmp('actualKmId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "";
				Ext.getCmp('actualKmId').focus();
				return;
			}
			if (Ext.getCmp('expectedKmId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter expected distance";
				Ext.getCmp('expectedKmId').focus();
				return;
			}
			if (Ext.getCmp('actualTimeId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "";
				Ext.getCmp('actualTimeId').focus();
				return;
			}
			if (Ext.getCmp('expectedTimeId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter expected duration";
				Ext.getCmp('expectedTimeId').focus();
				return;
			}
			if (Ext.getCmp('radiusId').getValue() == "") {
				document.getElementById("messageBoxId").innerHTML = "Enter route radius for route deviation";
				Ext.getCmp('radiusId').focus();
				return;
			}
			var routeValues = JSON.stringify(jsonArray);
			var checkPointValues = JSON.stringify(checkPointArray);
			document.getElementById("messageBoxId").innerHTML = "";
			//if(innerPanel.getForm().isValid()) {

			Ext.Ajax.request({
				url: '<%=request.getContextPath()%>/routeCreationAction.do?param=saveRoute',
				method: 'POST',
				params: {

					sourceAlias: Ext.getCmp('sourceAliasId').getValue(),
					sourceName: objLatLngSource,
					destAlias: Ext.getCmp('destinationAliasId').getValue(),
					destName: objLatLngDest,
					routeName: Ext.getCmp('routeNameId').getValue(),
					routeDesc: Ext.getCmp('routeDescriptionId').getValue(),
					actualKm: Ext.getCmp('actualKmId').getValue(),
					expectedKm: Ext.getCmp('expectedKmId').getValue(),
					expectedTime: Ext.getCmp('expectedTimeId').getValue(),
					actualTime: Ext.getCmp('actualTimeId').getValue(),
					routeRadius: Ext.getCmp('radiusId').getValue(),
					routeValues: routeValues,
					checkpoints: checkPointValues,
					checkpointDur: checkPointD,
					custId: custId,
					sHubId: sHubId,
					dHubId: dHubId
				},
				success: function(response, options) {

					var message = response.responseText;
					//Ext.example.msg(message);
					document.getElementById("messageBoxId").innerHTML = message;
					jsonArray = [];
					checkPointArray = [];
					
					wayPts = [];
					total_pickup_distance = 0;
					total_duration = 0;
					if (directionsDisplay != null) {
						directionsDisplay.setMap(null);
					}
					Ext.getCmp('sourceNameId').reset();
					Ext.getCmp('sourceAliasId').reset();
					Ext.getCmp('destinationNameId').reset();
					Ext.getCmp('destinationAliasId').reset();
					Ext.getCmp('routeNameId').reset();
					Ext.getCmp('routeDescriptionId').reset();
					Ext.getCmp('actualKmId').reset();
					Ext.getCmp('expectedKmId').reset();
					Ext.getCmp('actualTimeId').reset();
					Ext.getCmp('expectedTimeId').reset();
					Ext.getCmp('radiusId').reset();
					Ext.getCmp('sourcecomboId').reset();
          			Ext.getCmp('destinationcomboId').reset();
          			if(markers!=null){
          				markers.setMap(null);
          			}
					document.getElementById('target').innerHTML = '';
					for(var i=0;i<MarkerinfowindowArr.length;i++){
						MarkerinfowindowArr[i].setMap(null);
					}
					for (var i = 0; i < circleArray.length; i++) {
			            circleArray[i].setMap(null);
			        }
			        for (var i = 0; i < polygonCoords.length; i++) {
			            polygonCoords[i].setMap(null);
			        }
			        
				},
				failure: function() {
					document.getElementById("messageBoxId").innerHTML = "Route Creation Unsuccessful";
					//Ext.example.msg("Route Creation Unsuccessful");
					document.getElementById("messageBoxId").innerHTML = "";
					jsonArray = [];
					checkPointArray = [];
					wayPts = [];
					if (directionsDisplay != null) {
						directionsDisplay.setMap(null);
					}
					Ext.getCmp('sourceNameId').reset();
					Ext.getCmp('sourceAliasId').reset();
					Ext.getCmp('destinationNameId').reset();
					Ext.getCmp('destinationAliasId').reset();
					Ext.getCmp('routeNameId').reset();
					Ext.getCmp('routeDescriptionId').reset();
					Ext.getCmp('actualKmId').reset();
					Ext.getCmp('expectedKmId').reset();
					Ext.getCmp('actualTimeId').reset();
					Ext.getCmp('expectedTimeId').reset();
					Ext.getCmp('radiusId').reset();
					Ext.getCmp('sourcecomboId').reset();
         		    Ext.getCmp('destinationcomboId').reset();
					if(markers!=null){
          				markers.setMap(null);
          			}
					document.getElementById('target').innerHTML = '';
					for(var i=0;i<MarkerinfowindowArr.length;i++){
						MarkerinfowindowArr[i].setMap(null);
					}
					for (var i = 0; i < circleArray.length; i++) {
			            circleArray[i].setMap(null);
			        }
			         for (var i = 0; i < polygonCoords.length; i++) {
			              polygonCoords[i].setMap(null);
			           }
				}
			});
		}

		function setPolyPoints(map, polylatlongs) {
			line = new google.maps.Polyline({
				path: polylatlongs,
				strokeColor: '#6699FF',
				map: map
			});
			line.setMap(map);
		}

		function setMarkers(map, viewMarkerLat, viewMarkerLng, type) {
			var markerLatLng = new google.maps.LatLng(viewMarkerLat, viewMarkerLng);
			if (type == 'SOURCE' || type == 'DESTINATION') {
				var fitBoundLatLng = markerLatLng;
				var markerIcon = '/ApplicationImages/VehicleImages/RedBalloon1.png';
			} else if (type == 'CHECK POINT') {
				var markerIcon = '/ApplicationImages/VehicleImages/GreenBalloon1.png';
			}
			viewmarker = new google.maps.Marker({
				map: map,
				position: markerLatLng,
				icon: markerIcon,
				anchorPoint: new google.maps.Point(0, -29)
			});
			bounds = new google.maps.LatLngBounds(markerLatLng);
			map.fitBounds(bounds);
			map.setZoom(12);

		}
   
		function ShowRoute() {
		if (buttonValue == 'Modify') {
			if(createTrip == 'CreateTrip'){
			var routeName="";
		    var source="";
		    var destination="";
		    var routeDesp="";
		    var actualDuration="";
		    var expDuration="";
		    var actualDistance="";
		    var expDistance;
		    var radius;
			
			routeDataStore.load({
				params: {
					RouteId: routeId
				},
				callback: function() {
					var size = routeDataStore.getCount();
					for (i = 0; i < routeDataStore.getCount(); i++) {
						var rec = routeDataStore.getAt(i);
						routeName=rec.data['routeNameDataIndex'];
						source=rec.data['routeFromDataIndex'];
						destination=rec.data['routeToDataIndex'];
						actualDuration=rec.data['actualTimeDataIndex'];
						expDuration=rec.data['tempTimeDataIndex'];
						actualDistance=rec.data['actualDistanceDataIndex'];
						expDistance=rec.data['tempDistanceDataIndex'];
						routeDesp=rec.data['despDataIndex'];
						radius=rec.data['radiusDataIndex'];
					}
					setTimeout(function(){ 
						Ext.getCmp('sourceAliasId').setValue(source);
						Ext.getCmp('destinationAliasId').setValue(destination);
						Ext.getCmp('routeNameId').setValue(routeName);
						Ext.getCmp('expectedKmId').setValue(expDistance);
						Ext.getCmp('actualKmId').setValue(actualDistance);
						Ext.getCmp('expectedTimeId').setValue(expDuration);
						Ext.getCmp('actualTimeId').setValue(actualDuration);
						Ext.getCmp('routeDescriptionId').setValue(routeDesp);
						Ext.getCmp('radiusId').setValue(parseInt(radius));	
					 }, 1500);
				}
			});
			
			//alert("RT NAME : "+routeName+" , "+source+" , "+destination+" , "+actualDuration+" , "+expDuration+" , "+actualDistance+" , "+expDistance+" , "+radius);
			Ext.getCmp('saveButtonId').hide();
			Ext.getCmp('plotRouteButton').hide();
			Ext.getCmp('addButtonId').hide();
			Ext.getCmp('clearButtonId').hide();
			Ext.getCmp('sourceNameId').disable();
			Ext.getCmp('destinationNameId').disable();
			Ext.getCmp('sourceAliasId').disable();
			Ext.getCmp('destinationAliasId').disable();
			Ext.getCmp('routeNameId').disable();
			Ext.getCmp('expectedKmId').disable();
			Ext.getCmp('actualKmId').disable();
			Ext.getCmp('expectedTimeId').disable();
			Ext.getCmp('actualTimeId').disable();
			Ext.getCmp('routeDescriptionId').disable();
			Ext.getCmp('radiusId').disable();

			routedetailsstore.load({
				params: {
					CustId: custId,
					RouteId: routeId
				},
				callback: function() {
					var size = routedetailsstore.getCount();
					var waypts = [];
					var radius;
					var polylatlongs = [];
					var markerLatLng = [];
					for (i = 0; i < routedetailsstore.getCount(); i++) {
						var rec = routedetailsstore.getAt(i);
						var alias;
						if (rec.data['type'] == "") {
							var latlon = new google.maps.LatLng(rec.data['lat'], rec.data['long']);
							polylatlongs.push(latlon);
							setPolyPoints(map, polylatlongs);
						} else {
							if (rec.data['type'] == 'SOURCE') {
								alias = rec.data['alias'];
								Ext.getCmp('sourceAliasId').setValue(alias);
							} else if (rec.data['type'] == 'DESTINATION') {
								alias = rec.data['alias'];
								Ext.getCmp('destinationAliasId').setValue(alias);
							}
							var type = rec.data['type'];
							setMarkers(map, rec.data['lat'], rec.data['long'], type);
						}
					}
				}
			});
			
			}else{
			
				Ext.getCmp('saveButtonId').hide();
				Ext.getCmp('plotRouteButton').hide();
				Ext.getCmp('addButtonId').hide();
				Ext.getCmp('clearButtonId').hide();
				Ext.getCmp('sourceAliasId').setValue('<%=source%>');
				Ext.getCmp('destinationAliasId').setValue('<%=destination%>');
				Ext.getCmp('routeNameId').setValue('<%=routeName%>');
				Ext.getCmp('expectedKmId').setValue('<%=expDistance%>');
				Ext.getCmp('actualKmId').setValue('<%=actualDistance%>');
				Ext.getCmp('expectedTimeId').setValue('<%=expDuration%>');
				Ext.getCmp('actualTimeId').setValue('<%=actualduration%>');
				Ext.getCmp('routeDescriptionId').setValue('<%=routeDesp%>');
				Ext.getCmp('radiusId').setValue('<%=radius%>');
				Ext.getCmp('sourceNameId').disable();
				Ext.getCmp('destinationNameId').disable();
				Ext.getCmp('sourceAliasId').disable();
				Ext.getCmp('destinationAliasId').disable();
				Ext.getCmp('routeNameId').disable();
				Ext.getCmp('expectedKmId').disable();
				Ext.getCmp('actualKmId').disable();
				Ext.getCmp('expectedTimeId').disable();
				Ext.getCmp('actualTimeId').disable();
				Ext.getCmp('routeDescriptionId').disable();
				Ext.getCmp('radiusId').disable();
	
				routedetailsstore.load({
					params: {
						CustId: custId,
						RouteId: routeId
					},
					callback: function() {
						var size = routedetailsstore.getCount();
						var waypts = [];
						var radius;
						var polylatlongs = [];
						var markerLatLng = [];
						for (i = 0; i < routedetailsstore.getCount(); i++) {
							var rec = routedetailsstore.getAt(i);
							var alias;
							if (rec.data['type'] == "") {
								var latlon = new google.maps.LatLng(rec.data['lat'], rec.data['long']);
								polylatlongs.push(latlon);
								setPolyPoints(map, polylatlongs);
							} else {
								if (rec.data['type'] == 'SOURCE') {
									alias = rec.data['alias'];
									Ext.getCmp('sourceAliasId').setValue(alias);
								} else if (rec.data['type'] == 'DESTINATION') {
									alias = rec.data['alias'];
									Ext.getCmp('destinationAliasId').setValue(alias);
								}
								var type = rec.data['type'];
								setMarkers(map, rec.data['lat'], rec.data['long'], type);
							}
						}
					}
				});
			}//else
		}
	}
	var SourcecomboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getSourceAndDestination',
        id: 'hubStoreId',
        root: 'sourceRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['Hub_Id', 'Hub_Name', 'latitude', 'longitude', 'radius', 'detention']
    });
    
    var destcomboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getSourceAndDestination1',
        id: 'hubStoreId1',
        root: 'sourceRoot1',
        autoLoad: false,
        remoteSort: true,
        fields: ['Hub_Id', 'Hub_Name', 'latitude', 'longitude', 'radius', 'detention']
    });
	
	var checkPointStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getCheckPoints',
        id: 'hubStoreId11',
        root: 'checkPointRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['Hub_Id', 'Hub_Name', 'latitude', 'longitude', 'radius', 'detention']
    });
    var polygonStoreForModify=new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getPolygon',
		id:'PolygonModifyId',
		root: 'PolygonModify',
		autoLoad: false,
		remoteSort: true,
		fields: ['longitude','latitude','sequence','hubid']
	});

	var RouteNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/routeCreationAction.do?param=getRouteNames',
        id: 'routeNameStoreId',
        root: 'routeNamesRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['Route_Id','Route_Name']
    });
    
	var sourceCombo = new Ext.form.ComboBox({
        store: SourcecomboStore,
     //   hidden:true,
        id: 'sourcecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Source',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        //width: 200,
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect1',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('destinationcomboId').reset();
                  	var source = Ext.getCmp('sourcecomboId').getValue();
                  	for (var i = 0; i < circleArray.length; i++) {
                       circleArray[i].setMap(null);
                    }
                    for (var i = 0; i < polygonCoords.length; i++) {
			          polygonCoords[i].setMap(null);
			        }
			        if (directionsDisplay != null) {
				         directionsDisplay.setMap(null);
				     }
                    var idO = SourcecomboStore.find('Hub_Id', source);
                    var recordO = SourcecomboStore.getAt(idO);
                    var convertintomtrs = recordO.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(recordO.data['latitude'], recordO.data['longitude']);
                    if(recordO.data['radius']== '-1' || recordO.data['radius']== -1){
                    	drawPolygon(source);
                    }else{
                    	DrawCircle(myLatLng, convertintomtrs);
                    }
                    objLatLngSource=myLatLng;
                    document.getElementById("messageBoxId").innerHTML = "Click on \"Plot Route\" after source and destination are selected";
                    Ext.getCmp('sourceAliasId').setValue(recordO.data['Hub_Name'].split(',')[0]);
                    Ext.getCmp('destinationAliasId').setValue('');
                    autoPopulateDefaultRouteName();
                }
            }
        }
    });

    function autoPopulateDefaultRouteName(){
    	var idO = SourcecomboStore.find('Hub_Id', Ext.getCmp('sourcecomboId').getValue());
    	var recordO = SourcecomboStore.getAt(idO);
    	var sourceHub = recordO.data['Hub_Name'].split(',')[0];   	
	var destHub = ""; 
    	var idD = destcomboStore.findExact('Hub_Id', Ext.getCmp('destinationcomboId').getValue());
    	var recordD = destcomboStore.getAt(idD);
    	if(recordD != undefined){
		destHub=recordD.data['Hub_Name'].split(',')[0];
	}
    	var defaultRouteName="";
		if(checkPointArray.length > 0){
			console.log(checkPointArray);
	    	var checkPointValues = JSON.stringify(checkPointArray);
	    	var checkPointNames ="";
	    	for (var i = 0; i < checkPointArray.length; i++) {
	    	    var checkPointName = (checkPointArray[i].split(',')[0]).slice(1,checkPointArray[i].length);
	    	    checkPointNames = checkPointNames.concat("-",checkPointName);
	    	}
	    	defaultRouteName = defaultRouteName.concat(sourceHub,checkPointNames,"-", destHub);
	    	
		}else{
			defaultRouteName = defaultRouteName.concat(sourceHub,"-",destHub);
		}
    	Ext.getCmp('routeNameId').setValue(defaultRouteName);
    }
    
    var destinationCombo = new Ext.form.ComboBox({
        store: destcomboStore,
 //       hidden:true,
        id: 'destinationcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Destination',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect1',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                    
                    var destination = Ext.getCmp('destinationcomboId').getValue();
                    var idD = destcomboStore.findExact('Hub_Id', destination);
                    var recordD = destcomboStore.getAt(idD);
                    myLatLngDest = recordD.data['latitude'] + ',' + recordD.data['longitude'];
                    var convertintomtrs = recordD.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(recordD.data['latitude'], recordD.data['longitude']);
                    if(recordD.data['radius']== '-1' || recordD.data['radius']== -1){
                    	drawPolygon(destination);
                    }else{
                    	DrawCircle(myLatLng, convertintomtrs);
                    }
                    objLatLngDest=myLatLng;
                    Ext.getCmp('destinationAliasId').setValue(recordD.data['Hub_Name'].split(',')[0]);
                    autoPopulateDefaultRouteName();
                }
            }
        }
    });
	function DrawCircle(myLatLng, convertintomtrs,lat,lon) {
	 
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
        circleArray.push(circle);
        createInfoWindow(lat, lon,'',0);
    }
    function drawPolygon(hubId){
   var polygonCoords1=[];
    polygonStoreForModify.load({
       params: {
  			 hubId: hubId
		},
           callback: function() {
               var latLong;
               for (var i = 0; i < polygonStoreForModify.getCount(); i++) {
                   var rec = polygonStoreForModify.getAt(i);
                   if (i != polygonStoreForModify.getCount()  && hubId == polygonStoreForModify.getAt(i).data['hubid']) {
                       latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                       polygonCoords1.push(latLong);
                       //latitudePolygon.push(rec.data['latitude']);
                       //longitudePolygon.push(rec.data['longitude']);
                       continue;
                   }
               }

               polygonNew = new google.maps.Polygon({
                   paths: polygonCoords1,
                   map: map,
                   strokeColor: '#A7A005',
                   strokeOpacity: 0.8,
                   strokeWeight: 3,
                   fillColor: '#ECF086',
                   fillOpacity: 0.55
               }); //polygon
               polygonCoords.push(polygonNew);
               bounds = new google.maps.LatLngBounds();
               for (i = 0; i < polygonCoords1.length; i++) {
                   bounds.extend(polygonCoords1[i]);
               }
               map.fitBounds(bounds);
           }
       });
    }
	var radioPanel = new Ext.Panel({
            title: '',
            layout: 'table',
            height:20,
            layoutConfig: {
                columns: 6
            },
            width: 340,
            items: [{width:20},{
                xtype: 'label',
                text: 'Create Route: ',
                width: 120,
                cls: 'myStyle'
            }, {width:50},{
                xtype: 'radio',
                id: 'radioCustom',
                boxLabel: 'Custom',
                name: 'radioHubReg',
                listeners: {
                    check: function () {
                        if (this.checked) {
                           Ext.getCmp('sourcecomboId').hide();
                           Ext.getCmp('sourcehEmptyId1').hide();
                           Ext.getCmp('sourceLabelhId').hide();
                           Ext.getCmp('sourceAliasId').enable();
                           Ext.getCmp('s').hide();
                           
                           Ext.getCmp('destinationcomboId').hide();
                           Ext.getCmp('sourcehEmptyId11').hide();
                           Ext.getCmp('sourceLabelhId1').hide();
                           Ext.getCmp('destinationAliasId').enable();
                           Ext.getCmp('s1').hide();
                             
                           Ext.getCmp('sourceEmptyId1').show();
                           Ext.getCmp('sourceLabelId').show();
                           Ext.getCmp('addButtonId1').show();
                           Ext.getCmp('sourceNameId').show();
                           
                           Ext.getCmp('destLabelId').show();
                           Ext.getCmp('destinationNameId').show();
                           Ext.getCmp('addButtonId2').show();
                           Ext.getCmp('destEmptyId1').show();
                           $('#deliveryId').hide();
                           clearCheckPoints();
                           
                           
                        }
                    }
                }
            },{width:50},{
                xtype: 'radio',
                id: 'radioHub',
		checked: true,
                boxLabel: 'Hub',
                name: 'radioHubReg',
                listeners: {
                    check: function () {
                        if (this.checked) {
                           Ext.getCmp('sourcecomboId').show();
                           Ext.getCmp('sourcehEmptyId1').show();
                           Ext.getCmp('sourceLabelhId').show();
                           Ext.getCmp('sourceAliasId').disable();
                           Ext.getCmp('s').show();
                           
                           Ext.getCmp('destinationcomboId').show();
                           Ext.getCmp('sourcehEmptyId11').show();
                           Ext.getCmp('sourceLabelhId1').show();
                           Ext.getCmp('destinationAliasId').disable();
                           Ext.getCmp('s1').show();
                           
                           Ext.getCmp('sourceEmptyId1').hide();
                           Ext.getCmp('sourceLabelId').hide();
                           Ext.getCmp('addButtonId1').hide();
                           Ext.getCmp('sourceNameId').hide();
                           
                           Ext.getCmp('destLabelId').hide();
                           Ext.getCmp('destinationNameId').hide();
                           Ext.getCmp('addButtonId2').hide();
                           Ext.getCmp('destEmptyId1').hide();
                           $('#deliveryId').hide();
                           clearCheckPoints();
                           document.getElementById("messageBoxId").innerHTML = "select source and destination hub";
                        }
                    }
                }
            }]
        });			
	  
	var searchPanel = new Ext.Panel({
     title: '',
     layout: 'table',
     layoutConfig: {
         columns: 1
     },
     width: 1000,
     html: '<div id="search-panel" style="height: 31px;">'+
      	   '<input id="target" type="text" placeholder="Search Places" style="width: 450px; margin-bottom: 10px;height: 25px;">'+ 
      	   '<button type="button" onclick="plotMarkerBasedLatlong();" style="width: 73px;height: 30px;margin-left: 16px;margin-bottom: 10px;margin-right: 20px;">Search</button>'+
      	   '<select class="form-control select2"  id="deliveryId" onchange="drawCheckpoints();" style=" display:none; width: 220px;height: 33px !important;margin-left: 20px;margin-bottom: 7px;">'+
      	   '<option>Select below delivery point :- </option></select>'+
    	   '</div>'
 	});
 	
 	function drawCheckpoints() {
          var convertintomtrs = $('#deliveryId option:selected').attr("radius") * 1000;
          myLatLngD = new google.maps.LatLng($('#deliveryId option:selected').attr("latitude"), $('#deliveryId option:selected').attr("longitude"));
          if($('#deliveryId option:selected').attr("radius")== '-1' || $('#deliveryId option:selected').attr("radius")== -1){
              drawPolygon(document.getElementById('deliveryId').value);
          }else{
              DrawCircle(myLatLngD, convertintomtrs,$('#deliveryId option:selected').attr("latitude"),$('#deliveryId option:selected').attr("longitude"));
          }
          loc=$('#deliveryId option:selected').text().split(',');
          loc1=loc[0];
          var CheckPointName = loc1;
          var CheckRadius = $('#deliveryId option:selected').attr("radius");
          var CheckType = 'Delivery Point';
          var detentionTime = $('#deliveryId option:selected').attr("detention");
          var i = 1;
          checkPointArray.push('{' + CheckPointName + ',' + myLatLngD + ',' + CheckRadius + ',' +  CheckType + ',' +  detentionTime + ',' +document.getElementById('deliveryId').value +'}');
          wayPts.push({
               location: new google.maps.LatLng($('#deliveryId option:selected').attr("latitude"), $('#deliveryId option:selected').attr("longitude")),
               stopover: true
           });
           var idO = SourcecomboStore.find('Hub_Id',  Ext.getCmp('sourcecomboId').getValue());
           var recordO = SourcecomboStore.getAt(idO);
           myLatLng = new google.maps.LatLng(recordO.data['latitude'], recordO.data['longitude']);
           
           var idO1 = destcomboStore.find('Hub_Id',  Ext.getCmp('destinationcomboId').getValue());
           var recordd = destcomboStore.getAt(idO1);
           myLatLng1 = new google.maps.LatLng(recordd.data['latitude'], recordd.data['longitude']);
           plotRoute(myLatLng, myLatLng1);
		   
           autoPopulateDefaultRouteName();
    };
	var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,
		collapsible: false,
		autoScroll: true,
		height: 365,
		width: 480,
		id: 'innerPanelId',
		layout: 'table',
		layoutConfig: {
			columns: 4
		},
		items: [{
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'sourcehEmptyId1',
//				hidden:true
			}, {
				xtype: 'label',
				text: 'Source' + ' :',
				cls: 'labelstyle',
				id: 'sourceLabelhId',
//				hidden:true
			}, sourceCombo,{
	           xtype: 'label',
				text: '',
				cls: 'mandatoryfield',
				id: 's',
//				hidden:true
            },{
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'sourcehEmptyId11',
//				hidden:true
			}, {
				xtype: 'label',
				text: 'Destination' + ' :',
				cls: 'labelstyle',
				id: 'sourceLabelhId1',
//				hidden:true
			}, destinationCombo,{
	           xtype: 'label',
				text: '',
				cls: 'mandatoryfield',
				id: 's1',
				hidden:true
            },{
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'sourceEmptyId1',
				hidden:true
			}, {
				xtype: 'label',
				text: 'Source' + ' :',
				cls: 'labelstyle',
				id: 'sourceLabelId',
				hidden:true
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				emptyText: 'Enter location',
				id: 'sourceNameId',
				tooltip: 'Enter the Source Address',
				resizable: true,
				hidden:true
			}, {
	            xtype: 'button',
	            text: 'Set',
	            //iconCls: 'addbutton',
	            id: 'addButtonId1',
	            cls: 'buttonstyle',
	            width: 40,
	            height:10,
		    hidden:true,
	            listeners: {
	                click: {
	                    fn: function() {
	                        var sourceInput = Ext.getCmp('sourceNameId').getValue();
	                        sourceInputarr=sourceInput.split(',');
	                        myLatLng = new google.maps.LatLng(sourceInputarr[0],sourceInputarr[1]);
	                        objLatLngSource=myLatLng;
	                    	sourceMarker.setPosition(myLatLng);
            				sourceMarker.setVisible(true);
            				
	                    }
	                }
	            }
            }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'destEmptyId1',
				hidden:true
			}, {
				xtype: 'label',
				text: 'Destination' + ' :',
				cls: 'labelstyle',
				id: 'destLabelId',
				hidden:true
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				emptyText: 'Enter location',
				id: 'destinationNameId',
				hidden:true
			},{
	            xtype: 'button',
	            text: 'Set',
	            //iconCls: 'addbutton',
	            id: 'addButtonId2',
	            cls: 'buttonstyle',
	            width: 40,
		    hidden:true,
	            listeners: {
	                click: {
	                    fn: function() {
	                        var destInput = Ext.getCmp('destinationNameId').getValue();
	                        destInputarr=destInput.split(',');
	                        myLatLng = new google.maps.LatLng(destInputarr[0],destInputarr[1]);
	                        objLatLngDest=myLatLng;
	                    	destMarker.setPosition(myLatLng);
            				destMarker.setVisible(true);
	                    }
	                }
	            }
            },
           {
			xtype: 'label',
				text: '',
				cls: 'mandatoryfield',
				id: 'sourceAliasEmptyId1'
			}, 
			{
				xtype: 'label',
				text: 'Source Alias' + ' :',
				cls: 'labelstyle',
				id: 'sourceLabelId2'
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				id: 'sourceAliasId',
				regex:validate('locationname'),
				disabled:true
			}, 
			{
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	         id: 'emptyId2'
	     	},
	         {
				xtype: 'label',
				text: '',
				cls: 'mandatoryfield',
				id: 'destAliasEmptyId1'
			}, 
			{
				xtype: 'label',
				text: 'Destination Alias' + ' :',
				cls: 'labelstyle',
				id: 'destinationLabelId'
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				id: 'destinationAliasId',
				regex:validate('locationname'),
				disabled:true
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId3'
	        }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'routeNameMandatoryId1'
			}, {
				xtype: 'label',
				text: 'Route Name' + ' :',
				cls: 'labelstyle',
				id: 'routeNameLabelId'
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				emptyText: 'Enter Route Name',
				id: 'routeNameId',
				regex:validate('locationname')
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId4'
	        }, {
				xtype: 'label',
				text: '',
				cls: 'mandatoryfield',
				id: 'routeDescEmptyId1'
			}, {
				xtype: 'label',
				text: 'Route Description' + ' :',
				cls: 'labelstyle',
				id: 'routeDescriptionLabelId'
			}, {
				xtype: 'textarea',
				cls: 'selectstylePerfect1',
				id: 'routeDescriptionId',
				emptyText: 'Enter Route Description'
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId5'
	        }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'actualKmEmptyId1'
			}, {
				xtype: 'label',
				text: 'Actual Distance' + ' :',
				cls: 'labelstyle',
				id: 'actualKmLabelId1'
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				readOnly: true,
				id: 'actualKmId'
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId6'
	        }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'expectedkmEmptyId1'
			}, {
				xtype: 'label',
				text: 'Expected Distance'+ ' :',
				cls: 'labelstyle',
				id: 'expectedkmLabelId'
			}, {
				xtype: 'numberfield',
				cls: 'selectstylePerfect1',
				emptyText: 'Enter Expected Distance',
				id: 'expectedKmId'
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId7'
	        }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'actualTimeEmptyId1'
			}, {
				xtype: 'label',
				text: 'Actual Time (HH.MM)' + ' :',
				cls: 'labelstyle',
				id: 'actualTimelableId'
			}, {
				xtype: 'textfield',
				cls: 'selectstylePerfect1',
				allowBlank: false,
				readOnly: true,
				decimalPrecision: 2,
				id: 'actualTimeId'
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId8'
	        }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'expectedTimeEmptyId1'
			}, {
				xtype: 'label',
				text: 'Expected Time (HH.MM)' + ' :',
				cls: 'labelstyle',
				id: 'expectedTimeLabelId'
			}, {
				xtype: 'numberfield',
				cls: 'selectstylePerfect1',
				emptyText: 'Enter Expected Time in HH.MM format',
				autoCreate: { //restricts user to 6 chars max, 
					tag: "input",
					maxlength: 6,
					type: "text",
					size: "6",
					autocomplete: "off"
				},
				id: 'expectedTimeId'
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId9'
	        }, {
				xtype: 'label',
				text: '*',
				cls: 'mandatoryfield',
				id: 'radiusEmptyId1'
			}, {
				xtype: 'label',
				text: 'Route Radius (Meters)' + ' :',
				cls: 'labelstyle',
				id: 'radiusLabelId'
			}, {
				xtype: 'numberfield',
				cls: 'selectstylePerfect1',
				emptyText: 'Enter Route Radius',
				value:1000,
				autoCreate: { //restricts user to 6 chars max, 
					tag: "input",
					maxlength: 4,
					type: "text",
					size: "6",
					autocomplete: "off"
				},
				decimalPrecision: 0,
				id: 'radiusId'
			}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'emptyId10'
	        }]
	});
	var buttonPanel = new Ext.form.FormPanel({
		standardSubmit: true,
		collapsible: false,
		autoScroll: true,
		height: 70,
		width: 480,
		id: 'buttonPanelId',
		layout: 'table',
		layoutConfig: {
			columns: 3
		},
		items: [{
				xtype: 'button',
				text: 'Plot Route',
				iconCls: 'drawbutton',
				cls: '',
				width: 40,
				id: 'plotRouteButton',
				tooltip: 'Plot Route after Source and Destination is entered',
				listeners: {
					click: {
						fn: function() {
							plotRoute(objLatLngSource, objLatLngDest);
						}
					}
				}
			}, {
				xtype: 'button',
				text: 'Add Delivery Point',
				iconCls: 'addbutton',
				id: 'addButtonId',
				cls: '',
				width: 40,
				tooltip: 'Add Delivery Point',
				listeners: {
					click: {
						fn: function() {
							addCheckPoint();
						}
					}
				}
			},{
				xtype: 'button',
				text: 'Clear All',
				iconCls: 'clearButton',
				id: 'clearButtonId',
				cls: '',
				width: 40,
				tooltip: 'Clear All',
				listeners: {
					click: {
						fn: function() {
							Ext.Msg.show({
								//title: '...',
								msg: 'Are you sure you want to clear the route?',
								buttons: Ext.Msg.YESNO,
								fn: function(btn) {
									if (btn == 'no') {
										return;
									}
									if (btn == 'yes') {
										clearCheckPoints();
									}
								}
							});


						}
					}
				}
			}, {
				xtype: 'button',
				text: 'Save Route',
				iconCls: 'savebutton',
				id: 'saveButtonId',
				cls: '',
				width: 40,
				tooltip: 'Save Route',
				listeners: {
					click: {
						fn: function() {
							saveRoute();
						}
					}
				}
			},{
				xtype: 'button',
				text: 'Go Back',
				iconCls: 'backbutton',
				id: 'backButtonId',
				cls: 'buttonstyle',
				width: 70,
				tooltip: 'Go back to Route Details',
				listeners: {
					click: {
						fn: function() {
						if(createTrip=='CreateTrip'){
							var pageId = "route";
							window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/CreateTrip.jsp?pageId="+pageId+"&vehicleNo=<%=vehicleNo%>&pageFlag=<%=pageFlag%>";
						}else if(createRouteFromTrip=='createRouteFromTrip'){
							var pageId = "route";
							window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/CreateTrip.jsp?pageId="+pageId+"&vehicleNo=<%=vehicleNo%>&pageFlag=<%=pageFlag%>";
						}
						else{
							var backData = '/Telematics4uApp/Jsps/Common/RouteOperation.jsp?';
							parent.Ext.getCmp('routeCreationId').update("<iframe style='width:101%;height:533px;border:0;' src='" + backData + "'></iframe>");
							parent.Ext.getCmp('routeOperationId').enable();
							parent.Ext.getCmp('routeOperationId').show();
							parent.Ext.getCmp('routeCreationId').disable();
							}
							// parent.Ext.getCmp('routeCreationId').show();
						}
					}
				}
			}
		]
	});
var bottomPanel = new Ext.Panel({
     standardSubmit: true,
     id: 'bottomPanelId',
     collapsible: false,
     height: 20,
     html: '<div id="messageBoxId" style="width:100%;height:20px;border:0;color:red;" align="center"></div>'
 });
   var leftPanel = new Ext.Panel({
     id: 'leftContentId',
     standardSubmit: true,
     collapsible: false,
     height: 460,
     width: 500,
     layout: 'table',
     layoutConfig: {
         columns: 1
     },
     items: [innerPanel,buttonPanel,bottomPanel]
 });

 var rightPanel = new Ext.Panel({
     standardSubmit: true,
     id: 'mapdivid',
     collapsible: false,
     width: screen.width - 250,
     height: 461,
     html: '<div id="map-canvas" style="width:75%;height:450px;border:0;margin-top: 6px;">'
 });

 
 var contentPanel = new Ext.Panel({
     id: 'ContentPanelId',
     standardSubmit: true,
     collapsible: false,
     height: 460,
     width: screen.width - 30,
     layout: 'table',
     layoutConfig: {
         columns: 2
     },
     items: []
 });
 var panelTop = new Ext.Panel({
     id: 'mainPanelId1',
     standardSubmit: true,
     collapsible: false,
     height: 500,
     width: screen.width - 30,
     layout: 'table',
     layoutConfig: {
         columns: 2
     },
     items: [radioPanel,searchPanel,leftPanel,rightPanel]
 });
 var mainPanel = new Ext.Panel({
     id: 'mainPanelId',
     standardSubmit: true,
     collapsible: false,
     height: 500,
     width: screen.width - 30,
     layout: 'table',
     layoutConfig: {
         columns: 1
     },
     items: [panelTop]
 });

	function plotMarkerBasedLatlong(){
		var input = document.getElementById('target').value;
        inputarr=input.split(',');
        myLatLng = new google.maps.LatLng(inputarr[0],inputarr[1]);
        var myMar = new google.maps.Marker({
          map: map
        });
     	myMar.setPosition(myLatLng);
		myMar.setVisible(true);
		locArray.push(myMar);
	}
 Ext.onReady(function() {
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         // title:'Route Creation',
         width: screen.width - 30,
         height: 500,
         layout: 'table',
         cls: 'outerpanel',
         layoutConfig: {
             columns: 2
         },
         items: [mainPanel]

     });
     loadMap();
     SourcecomboStore.load({
         params: {
             CustId: custId
         }
     });
     destcomboStore.load({
         params: {
             CustId: custId
         }
     });
     if (buttonValue != 'Modify') {
         document.getElementById("messageBoxId").innerHTML = "Please enter source and destination";
     }
     RouteNameStore.load({
         params: {
             CustId: custId
         }
     });
     

 }); 
 </script> 
 </body> 
 </html>