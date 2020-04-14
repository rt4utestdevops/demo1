
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
 	
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	String systemID = Integer.toString(systemid);
 	int customeridlogged = loginInfo.getCustomerId();
 	String CustName = loginInfo.getCustomerName();
 	String customernamelogged = "null";
 	String vehicleTypeRequest = "all";
 	if (request.getParameter("vehicleType") != null) {
 		vehicleTypeRequest = request.getParameter("vehicleType");
 	}
 	if (customeridlogged > 0) {
 		customernamelogged=cf.getCustomerName(String.valueOf(customeridlogged),systemid);
 	}
 	int userId = loginInfo.getUserId();
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("SLNO");
tobeConverted.add("Status");
tobeConverted.add("Add");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Date_Time");
tobeConverted.add("Location");
tobeConverted.add("Ignition");
tobeConverted.add("Speed");
tobeConverted.add("STOPPAGE_TIME_ALERT");
tobeConverted.add("Driver_Name");
tobeConverted.add("Door_Status");
tobeConverted.add("Vehicle_Group");
tobeConverted.add("Remarks");
tobeConverted.add("Vehicle_Model");
tobeConverted.add("GMT");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Enter_Remarks");
tobeConverted.add("Mapview");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String Status=convertedWords.get(1);
String Add=convertedWords.get(2);
String Save=convertedWords.get(3);
String Cancel=convertedWords.get(4);
String VehicleNO=convertedWords.get(5);
String DateTime=convertedWords.get(6);
String Location=convertedWords.get(7);
String Ignition=convertedWords.get(8);
String Speed=convertedWords.get(9);
String StoppageTime=convertedWords.get(10);
String DriverName=convertedWords.get(11);
String DoorStatus=convertedWords.get(12);
String VehicleGroup=convertedWords.get(13);
String Remarks=convertedWords.get(14);
String VehicleModel=convertedWords.get(15);
String GMT=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String NoRecordsFound=convertedWords.get(18);
String NoRowsSelected=convertedWords.get(19);
String SelectSingleRow=convertedWords.get(20);
String EnterRemarks=convertedWords.get(21);
String LiveVision=convertedWords.get(22).toUpperCase();
 %>
<!DOCTYPE html>
<html>
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
     
    <title>Map</title> 
  <head>
    <link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/component.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/component.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/layout.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/theme/css/EXTJSExtn.css" /> 
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
    <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
    
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

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
	<style>
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

      
	</style>
	</head>
    <script src=<%=GoogleApiKey%>></script>
     <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places&region=IN"></script>
     <body>
	 <jsp:include page="../Common/ExportJS.jsp"/>
	
		<div class="container">
			<header>
				<select class="combobox" id="vehicletype" onchange="loadvehicles();GRID();">
  					<option value="all">All</option>
  					<option value="comm">Communicating</option>
  					<option value="noncomm">Non Communicating</option>
  					<option value="noGPS">No GPS Connected</option>
				</select>					
				<h1><span><%=LiveVision%></span></h1>					
			</header>					
			<div class = "main">
			
			<img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index:4;left: 50%;top: 50%;">			
			<div class="mapview-mask" id="mapview-mask-id"></div>	
			<div class="mp-vehicle-wrapper" id="vehicle-list"></div>
			
			<div class="mp-vehicle-details-wrapper" id="vehicle-details">
			<form class="me-select">
				<ul id="me-select-list">
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle No </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="asset-no-id"></p></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Location </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="location-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle Group </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="group-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Date Time </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="gmt-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Driver Name </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="driver-name-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle Type </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="vehicleType-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Model</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="model-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Owner Name</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="ownerName-id"></span></li>	
					<li class="me-select-label"><span class="vehicle-details-block-header">Status</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="status-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Ignition</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="ignition-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Cash In</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="cashin-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Cash Out</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="cashout-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Cash Balance</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="cashbalance-id"></span></li>
					</ul>
			 </form>						
			</div>
				<div class="mp-container" id="mp-container">
				<button type="button" class="button" id="listviewid"  onclick="changecolor();gridLoad();">LIST VIEW</button>
			        <button type="button" class="button" id="mapviewid"  onclick="changecolor1();reszieFullScreen1();"  >MAP VIEW</button>
			        <input type="text" name="search" id="search-input" placeholder="Search Vehicle" autocomplete="off" class="search" onclick="this.value = '';" onkeyup="searchClient()" onkeydown="searchClient()"/>
		      
			        <div id="grid">
			          
					<div class="mp-map-wrapper" id="map">
						        
						         </div>
						         
					<div class="mp-options-wrapper"/>
					
					<input id="pac-input" class="controls" type="text" placeholder="Search Places" >
					<table width="98%">
						<tr height="10px"><td > <div class="mp-option-showhub" id="show">
							<td><div>
								<input type="checkbox" id="c1" name="cc" onclick='showHub(this);'/>
            					<label for="c1"><span></span></label>
            					<span class="vehicle-show-details-block">Show Hubs</span>
            				</div></td>
            				<td ><div class ="checkBoxRegion">
								<input type="checkbox" id="c2" name="cc" onclick='showDetails(this);'/>
            					<label for="c2"><span></span></label>
            					<span class="vehicle-show-details-block">Show Details</span>
            				</div></td>
            				
            			</div></td>
            			
							<td align="center"><img id="info" src="/ApplicationImages/VehicleImages/red2.png" >
							<span style="padding-right: 10px; font-size: 14px;">Stopped</span></td>
							<td><img class="info" src="/ApplicationImages/VehicleImages/green2.png">
							<span style="padding-right: 10px; font-size: 14px;">Running</span></td>
							<td><img class="info" src="/ApplicationImages/VehicleImages/yellow2.png">
							<span style="padding-right: 10px; font-size: 14px;">Idle</span></td>
						
						<td style="width:0px;"><div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"  onclick="mapFullScreen()"></div></td>
						</tr></table>
					</div>
					
					</div>
				</div>
			</div>
			</div>		
		<script>
		
		var grid;
		var markers = {};
		var outerPanel;
		var infowindows= {};
		var circles = [];
		var polygons =[];
		var buffermarkers = [];
		var polygonmarkers =[];
		var marker;
		//var vehicleDetailsStore;
		var map;
		var infowindow;
		var jspName="LiveVision";
		var circle;
		var button="Map";
		var selectAll="false";
		
		var exportDataType="int,string,date,string,string,number,number,string,string,string,string,string,string,date";
		var ctsb;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		document.getElementById('option-normal').style.display = 'none';
		var previousVehicleType='<%=vehicleTypeRequest%>';
		document.getElementById("vehicletype").value='<%=vehicleTypeRequest%>';
		
		
		
		
		
		function mapFullScreen()
		{	
		if(grid.getSelectionModel().getCount()>1)
		{
		 $mpContainer.removeClass('list-container-fitscreen');
		}
        document.getElementById('option-fullscreen').style.display = 'none';
        document.getElementById('option-normal').style.display = 'block';	
        $mpContainer.removeClass('mp-container-fitscreen');
       
		$mpContainer.addClass('mp-container-fullscreen').css({
						width	: 'originalWidth',
						height	: 'originalHeight'
					});

		
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
					google.maps.event.trigger(map, 'resize');
					
		}
		
		function reszieFullScreen()
		{
		if(grid.getSelectionModel().getCount()>1)
		{
		
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container-fitscreen');
		}
		else
		{
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.removeClass('mp-container-fullscreen');
		document.getElementById('vehicle-details').style.display = 'block';	
		$mpContainer.addClass('mp-container');
		
		}
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		google.maps.event.trigger(map, 'resize');
					
		}
		
		function reszieFullScreen1()
		{
		button="List";
	
       
		document.getElementById('search-input').style.visibility = 'hidden';
		document.getElementById('map').style.display = 'block';
        document.getElementById('vehicle-details').style.display = 'block';
        document.getElementById('vehicle-list').style.display = 'block';
        $mpContainer.removeClass('list-container-fitscreen');
         var defaultBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),
        new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));
        map.fitBounds(defaultBounds);
       
       
		if(grid.getSelectionModel().getCount()>1)
		{
		Ext.getCmp('outerpanel').hide();
		//document.getElementById('show').style.display = 'block';
		 
        document.getElementById('option-fullscreen').style.display = 'block';
	    //document.getElementById('map').style.display = 'block';
		document.getElementById('option-normal').style.display = 'none';	
        $mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container-fitscreen');
		
		
		
		}
		else
		{
		Ext.getCmp('outerpanel').hide();
		 
		//document.getElementById('show').style.display = 'block';
        document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';
        document.getElementById('map').style.display = 'block';
        document.getElementById('vehicle-details').style.display = 'block';		
		$mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.removeClass('list-container-fitscreen');
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container');
		 
		}
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		google.maps.event.trigger(map, 'resize');
					
		}
//*****************************Multiple Vehicle Screen ******************************************************		
		function multipleVehicleScreen()
		{
		//document.getElementById('option-fullscreen').style.display = 'none';
        document.getElementById('option-normal').style.display = 'none';	
        
		$mpContainer.addClass('mp-container-fitscreen').css({
						width	: 'originalWidth',
						height	: 'originalHeight'
					});

		
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});				
					google.maps.event.trigger(map, 'resize');
		}
		
		
		 var mapOptions = {
	        zoom: 2,
	        center: new google.maps.LatLng('0.0', '0.0'),
	        mapTypeId: google.maps.MapTypeId.ROADMAP
	    };

	    map = new google.maps.Map(document.getElementById('map'), mapOptions);
	    var mapZoom = 10;
	  //   var defaultBounds = new google.maps.LatLngBounds(
      //  new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),
      //  new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));
      //  map.fitBounds(defaultBounds);
      // map.setCenter(defaultBounds.getCenter(), map.getBoundsZoomLevel(defaultBounds));
  // Create the search box and link it to the UI element.
  var input = (document.getElementById('pac-input'));
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);

  var searchBox = new google.maps.places.SearchBox(input);

  // [START region_getplaces]
  // Listen for the event fired when the user selects an item from the
  // pick list. Retrieve the matching places for that item.
  google.maps.event.addListener(searchBox, 'places_changed', function() { 
    var places = searchBox.getPlaces();

    if (places.length == 0) {
      return;
    }
    for (var i = 0, marker; marker = markers[i]; i++) {
      marker.setMap(null);
    }

    // For each place, get the icon, place name, and location.
    markers1 = [];
    var bounds = new google.maps.LatLngBounds();
    for (var i = 0, place; place = places[i]; i++) {
      var image = {
        url: place.icon,
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(25, 25)
       
      };

      // Create a marker for each place.
       
       var marker1 = new google.maps.Marker({
       map: map,
       icon: image,
       title: place.name,
       position: place.geometry.location
        
      });
      markers1.push(marker1);
      bounds.extend(place.geometry.location);
    }

    map.fitBounds(bounds);
    if (map.getZoom() > 16) map.setZoom(15);
    
  });
  // [END region_getplaces]

  // Bias the SearchBox results towards places that are within the bounds of the
  // current map's viewport.
  google.maps.event.addListener(map, 'bounds_changed', function() {
    var bounds = map.getBounds();
    searchBox.setBounds(bounds);
  });
//***********************************Plot Vehicle on Map *******************************************
	    
	    function plotSingleVehicle(vehicleNo,latitude,longtitude,location,gmt,status)
	    {
	    if(status=='stoppage')
	    {
	    imageurl='/ApplicationImages/VehicleImages/red.png';
	    }
	    else if(status=='idle')
	    {
	    imageurl='/ApplicationImages/VehicleImages/yellow.png';
	    }
	    else
	    {
	    imageurl='/ApplicationImages/VehicleImages/green.png';
	    }
	    image = {
	        	url:imageurl , // This marker is 20 pixels wide by 32 pixels tall.
	        	scaledSize:  new google.maps.Size(19, 35), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};
    	var pos= new google.maps.LatLng(latitude,longtitude);
        marker = new google.maps.Marker({
            	position: pos,
            	id:vehicleNo,
            	map: map,
            	icon: image
        	});
            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td><b>Vehicle No:</b></td><td>'+vehicleNo+'</td></tr>'+
			'<tr><td><b>Location:</b></td><td>'+location+'</td></tr>'+
			'<tr><td><b>Date Time:</b></td><td>'+gmt+'</td></tr>'+
			'</table>'+
			'</div>';
		    infowindow = new google.maps.InfoWindow({
      		content: content,
      		maxWidth: 300,
      		marker:marker,
      		image:image,
      		id:vehicleNo
  		});	
			google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){ 
    			return function() {
        			infowindow.setContent(content);
        			infowindow.open(map,marker);
    			};
			})(marker,content,infowindow)); 
			marker.setAnimation(google.maps.Animation.DROP); 	
        var bounds = new google.maps.LatLngBounds();
        var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
    				bounds.extend(new google.maps.LatLng(store.getAt(grid.getStore().indexOf(vehicle)).data['latitude'],store.getAt(grid.getStore().indexOf(vehicle)).data['longitude']));	
    			}	
				}); 
	    map.fitBounds(bounds);
	    var listener = google.maps.event.addListener(map, "idle", function() { 
  		 
  		 if (map.getZoom() > 16) map.setZoom(mapZoom);
  			google.maps.event.removeListener(listener); 
		});
	    infowindows[vehicleNo]=infowindow;
	    markers[vehicleNo] = marker;
	        
	    }


//********************************* Select All ********************************************************

function selecAllVehicles(cb)
  {		
  if(document.getElementById("vehicletype").value!='noGPS') 
  	   {
	    var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
    				marker.setMap(null);
    			}	
				}); 
		}
   if(cb.checked)
   {
        
   
       grid.getSelectionModel().selectAll();	
    }  
                   
   
   else
   {  
          	 
      grid.getSelectionModel().clearSelections();
             
   }
  }	    
	    
    
//********************************* Remove Vehicle Marker**********************************************	    
	  
	    function removeVehicleMarker(vehicleNo)
	    {
	    	if(document.getElementById("vehicletype").value!='noGPS')
	    	{
  				var marker = markers[vehicleNo];
    			marker.setMap(null);
    		}
	    }
	   
//*************************Serch Client*******************************// 
	    function searchClient()
	    {
	    var val = document.getElementById("search-input").value;
		var cm = grid1.getColumnModel();
		
 		//var filter = grid1.filters1.filters.get(cm.getDataIndex(1));
 		var filter = grid1.filters.getFilter('vehiclenoindex');
 		
 		//store.load().filter('vehiclenoindex', val);
 		filter.setValue(val);
 		if(val!="") {
 			filter.setActive(true);
 		} else {
 			filter.setActive(false);
 		}
	}
	
//********************************* Load Vehicles********************************************************	    
	    function loadvehicles()
	    {
	        //GRID();
	        document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';		
			document.getElementById('ignition-id').innerHTML='';
			document.getElementById('vehicleType-id').innerHTML='';
			document.getElementById('model-id').innerHTML='';
			document.getElementById('ownerName-id').innerHTML='';
			document.getElementById('status-id').innerHTML='';
			document.getElementById('cashin-id').innerHTML='';
			document.getElementById('cashout-id').innerHTML='';
			document.getElementById('cashbalance-id').innerHTML='';
	    reszieFullScreen();
	    if(previousVehicleType!='noGPS')
	    {
	    var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
    				marker.setMap(null);
    			}	
				}); 
		}
		
		previousVehicleType=document.getElementById("vehicletype").value;			
	    store.load({
    	params:{vehicleType:document.getElementById("vehicletype").value},
    	callback:function(){
    	var el = document.getElementById('loadImage');
		el.parentNode.removeChild(el);
		var el1 = document.getElementById('mapview-mask-id');
		el1.parentNode.removeChild(el1);
    	
    	}
    	});
    	
	    }	    
//********************************** Refresh Vehicles every 5 min*****************************************************

function GRID()

{
vehicleDetailsStore.load({
params:{custName:'<%=customernamelogged%>',jspName:jspName,vehicleType:document.getElementById("vehicletype").value } });
}

function refreshVehicle()
{       mapZoom=map.getZoom();
        
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
	        document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';		
			document.getElementById('ignition-id').innerHTML='';
			document.getElementById('vehicleType-id').innerHTML='';
			document.getElementById('model-id').innerHTML='';
			document.getElementById('ownerName-id').innerHTML='';
			document.getElementById('status-id').innerHTML='';
			document.getElementById('cashin-id').innerHTML='';
			document.getElementById('cashout-id').innerHTML='';
			document.getElementById('cashbalance-id').innerHTML='';
	    reszieFullScreen();
	    if(previousVehicleType!='noGPS')
	    {
	    		var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
    				selectedIdx.push(grid.getStore().indexOf(vehicle));
    				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
					{
						selVehicles.push(store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']);
    				}
    				
				}); 
		}
		previousVehicleType=document.getElementById("vehicletype").value;			
	    store.load({
    	params:{vehicleType:document.getElementById("vehicletype").value},
    	callback:function(){
			for(i=0; i<selVehicles.length; i++) {
    		removeVehicleMarker(selVehicles[i]);
			}
			grid.getSelectionModel().selectRows(selectedIdx);
    	}
    	});
    	  
}	    
//********************************** AssetDetails,Buffer & Polygon Store *********************************************	    
	    var bufferStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getBufferMapView',
				id:'BufferMapView',
				root: 'BufferMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','buffername','radius']
		}); 
		
		var polygonStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getPolygonMapView',
				id:'PolygonMapView',
				root: 'PolygonMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','polygonname','sequence','hubid']
		});
		
		
		var mapViewAssetDetails = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getCashVanMapViewVehicleDetails',
				id:'MapViewVehicleDetails',
				root: 'MapViewVehicleDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['vehicleType','model','ownerName','status','cashin','cashout','cashbalance']
		});
						
//*************************************** Display Hub *********************************************	

	    function showHub(cb)
	    {
	    	if(cb.checked)
	    	{
	    	loadMask.show();	
	    		bufferStore.load({
	    			callback:function(){
	    							plotBuffers();
	    							loadMask.hide();	
	    							}
	    					});
	    		polygonStore.load({
	    			callback:function(){
	    							plotPolygon();
	    							loadMask.hide();	
	    							}
	    					});			
	    	}
	    else
	    	{
	    	for(var i=0;i<circles.length;i++)
	    	{
    			circles[i].setMap(null);
    			buffermarkers[i].setMap(null);
	    	}
	    	for(var i=0;i<polygons.length;i++)
	    	{
    			polygons[i].setMap(null);
    			polygonmarkers[i].setMap(null);
	    	}
	    	}
	    }

///***************************************** Show Details********************************************	    
	    
	    function showDetails(cb)
	    {	
	    		var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
					infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
					if(cb.checked)
	    			{
    	    			infowindows[infowindowId].open(map, markers[infowindowId]); 
    	    		}
    	    		else
    	    		{
    	    			infowindows[infowindowId].setMap(null);
    	    		}
				}); 
	    }

//******************************************* Buffer *******************************************************	    
	    function plotBuffers()
	    {
	    for(var i=0;i<bufferStore.getCount();i++)
	    {
	    var rec=bufferStore.getAt(i);
	    var convertRadiusToMeters = rec.data['radius'] * 1000;
	    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
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
	  bufferimage = {
	        	url: '/ApplicationImages/VehicleImages/information.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	scaledSize: new google.maps.Size(19, 35), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};      

	  buffermarker = new google.maps.Marker({
            	position: myLatLng,
            	id:rec.data['vehicleNo'],
            	map: map,
            	icon:bufferimage
        	});
        buffercontent=rec.data['buffername']; 	
		bufferinfowindow = new google.maps.InfoWindow({
      		content:buffercontent,
      		id:rec.data['vehicleNo'],
      		marker:buffermarker
  		});	
  		
  		google.maps.event.addListener(buffermarker,'click', (function(buffermarker,buffercontent,bufferinfowindow){ 
    			return function() {
        			bufferinfowindow.setContent(buffercontent);
        			bufferinfowindow.open(map,buffermarker);
    			};
			})(buffermarker,buffercontent,bufferinfowindow)); 
			buffermarker.setAnimation(google.maps.Animation.DROP); 


    		buffermarkers[i]=buffermarker;
			circles[i] = new google.maps.Circle(createCircle);
	    }
	    }


//**************************************Polygon*****************************************************************	    
	    function plotPolygon()
	    {
	    var hubid=0;
	    var polygonCoords=[];
	    for(var i=0;i<polygonStore.getCount();i++)
	    {
	    	var rec=polygonStore.getAt(i);
	    	if(i!=polygonStore.getCount()-1 && rec.data['hubid']==polygonStore.getAt(i+1).data['hubid'])
	    	{
	    	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
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
        	var polygoncontent=rec.data['polygonname'];
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
	    }
	    }
	    
//***************************** Vehicle Grid***********************************************************	    
	 var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'MapViewVehicles',
        totalProperty: 'total',
        fields: [{
            		name: 'vehicleNo'
        		 },
        		 {
            		name: 'latitude'
        		 },
        		 {
            		name: 'longitude'
        		 },
        		 {
            		name: 'location'
        		 },
        		 {
            		name: 'gmt'
        		 },
        		 {
            		name: 'drivername'
        		 },
        		 {
            		name: 'groupname'
        		 },
        		 {
        		    name:'category'
        		 },
        		 {
        		    name:'ignition'
        		 }      
        	  ]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getMapViewVehicles',
            method: 'POST'
        }),
        remoteSort: false,
        
        storeId: 'darStore',
        reader: reader
    });
    

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'vehicleNo',
            type: 'string'
        }]
    });
    
    
       var selModel = new Ext.grid.CheckboxSelectionModel({             
     	singleSelect : false,
     	checkOnly : true
     	
 		});

    //************************************Column Model Config******************************************
     var colModel = new Ext.grid.ColumnModel({
    	columns: [selModel,
    	 {
        header: 'Vehicle No',
        sortable: true,
        dataIndex: 'vehicleNo',
        width:160
    	}]
		});


         
   
    grid = new Ext.grid.EditorGridPanel({                         
     height 	: 470,
     viewConfig: {
            forceFit: true
        },
     store      : store,                                                                     
     colModel   : colModel,                                       
     selModel   : selModel,
     hideHeaders: true,
     loadMask	: true,
	 plugins: [filters]    
	});


  selModel.on('rowselect', function(selModel, index, record){
  
  var selectedRows = selModel.getSelections();
  var rec = grid.store.getAt(index);
  
  if(!rec.data['latitude']==0 && !rec.data['longitude']==0)
  {
 		plotSingleVehicle(rec.data['vehicleNo'],rec.data['latitude'],rec.data['longitude'],rec.data['location'],rec.data['gmt'],rec.data['category']);
 		
          
  }
  
  	if( selectedRows.length>1){
  	        
            multipleVehicleScreen();
            
           	}
           	else if( selectedRows.length==1){
           	       
           			document.getElementById('asset-no-id').innerHTML=rec.data['vehicleNo'];
					document.getElementById('location-id').innerHTML=rec.data['location'];
					document.getElementById('group-id').innerHTML=rec.data['groupname'];
					document.getElementById('gmt-id').innerHTML=rec.data['gmt'];
					document.getElementById('driver-name-id').innerHTML=rec.data['drivername'];
					document.getElementById('ignition-id').innerHTML=rec.data['ignition'];	
					
							
					mapViewAssetDetails.load({
						params:{vehicleNo:rec.data['vehicleNo']},
						callback:function()
							{
							   if(mapViewAssetDetails.getCount()>0){
								var record=mapViewAssetDetails.getAt(0);
								document.getElementById('vehicleType-id').innerHTML=record.data['vehicleType'];
								document.getElementById('model-id').innerHTML=record.data['model'];
								document.getElementById('ownerName-id').innerHTML=record.data['ownerName'];
								document.getElementById('status-id').innerHTML=record.data['status'];
								document.getElementById('cashin-id').innerHTML=record.data['cashin'];
								document.getElementById('cashout-id').innerHTML=record.data['cashout'];
								document.getElementById('cashbalance-id').innerHTML=record.data['cashbalance'];
							    }	
							}
				});	
           	}	
           	
  		});
  
  
  selModel.on('rowdeselect',function(selModel, index, record){
  var selectedRows = selModel.getSelections();
  var rec = grid.store.getAt(index);
  
  if(!rec.data['latitude']==0 && !rec.data['longitude']==0)
  
  {
  removeVehicleMarker(rec.data['vehicleNo']);
  }      
           if( selectedRows.length==1){
            reszieFullScreen();
            if(button=="List")
            {
            reszieFullScreen1();
            }
            //document.getElementById('vehicle-details').style.display = 'block';	
            var record = grid.getSelectionModel().getSelections(); 
			Ext.iterate(record, function(record, index) {
			document.getElementById('asset-no-id').innerHTML=record.data['vehicleNo'];
			document.getElementById('location-id').innerHTML=record.data['location'];
			document.getElementById('group-id').innerHTML=record.data['groupname'];
			document.getElementById('gmt-id').innerHTML=record.data['gmt'];
			document.getElementById('driver-name-id').innerHTML=record.data['drivername'];	
			document.getElementById('ignition-id').innerHTML=record.data['ignition'];	
			 
		
			mapViewAssetDetails.load({
						params:{vehicleNo:rec.data['vehicleNo']},
						callback:function()
							{
							   if(mapViewAssetDetails.getCount()>0){
								var record=mapViewAssetDetails.getAt(0);
								document.getElementById('vehicleType-id').innerHTML=record.data['vehicleType'];
								document.getElementById('model-id').innerHTML=record.data['model'];
								document.getElementById('ownerName-id').innerHTML=record.data['ownerName'];
								document.getElementById('status-id').innerHTML=record.data['status'];
								document.getElementById('cashin-id').innerHTML=record.data['cashin'];
								document.getElementById('cashout-id').innerHTML=record.data['cashout'];
								document.getElementById('cashbalance-id').innerHTML=record.data['cashbalance'];
							    }	
							}
				});	
			});
			//selectAll="false";			
           	}
           	else if( selectedRows.length==0){
           	document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';		
			document.getElementById('ignition-id').innerHTML='';
			document.getElementById('vehicleType-id').innerHTML='';
			document.getElementById('model-id').innerHTML='';
			document.getElementById('ownerName-id').innerHTML='';
			document.getElementById('status-id').innerHTML='';
			document.getElementById('cashin-id').innerHTML='';
			document.getElementById('cashout-id').innerHTML='';
			document.getElementById('cashbalance-id').innerHTML='';
			
           	}
           	
  });
  
  
   
   function startfilter() {
		var val = Ext.getCmp('searchVehicle').getValue();
		var cm = this.grid.getColumnModel();
 		var filter = this.grid.filters.filters.get(cm.getDataIndex(1));
 		filter.setValue(val);
 		if(val!="") {
 			filter.setActive(true);
 		} else {
 			filter.setActive(false);
 		}
	} 
//******************************************* Vehicle Panel****************************************	
   Ext.Ajax.timeout = 360000;
   var vehiclePannel =new Ext.Panel({
   					id:'vehiclePannel',
                    height : 520,
                    items: [{
                    		xtype:'textfield',
                    		id:'searchVehicle',
                    		width:'100%',
                    		height:30,
                    		emptyText:'Search Vehicle',
                    		cls:'searchtextbox',
                    		fireKey: function (e) {
                        			if (e.type == 'keydown' || e.type == 'keypress') {
                            setTimeout('startfilter()', 500);
                        			}
                    				}
							}, {
							xtype: 'panel',
							name :'image',
							html : '<div  style="background-color:#E4E4E4;height:27px;width:203px;"><input  type="checkbox" id="selectAll" name="cc" onclick="selecAllVehicles(this)"/><label for="selectAll"><span margin: "6px 4px 0 0"></span></label><span class="vehicle-show-details-block">Select All</span></div>'          
							}, grid]
                });
        loadvehicles();        
		setInterval(function(){refreshVehicle()},300000);  
        vehiclePannel.render('vehicle-list');	
        
//***************************************************Reader,Store,Filter and ColumnModel**********************  
//var selected = selModel.getSelectionModel().getSelections(); 


function gridLoad()
{
         button="Map";
         document.getElementById('search-input').style.visibility = 'visible';
        //  alert( 'You selected List View' );
         document.getElementById('listviewid').style.color='#02B0E6';
         document.getElementById('mapviewid').style.color='#fff';
         document.getElementById('listviewid').style.borderColor='#02B0E6';
         document.getElementById('mapviewid').style.borderColor='#fff';
          Ext.getCmp('outerpanel').show();
          //$mpContainer.removeClass('mp-vehicle-wrapper');
          
          document.getElementById('vehicle-list').style.display = 'none';
          document.getElementById('option-fullscreen').style.display = 'none';
         // document.getElementById('show').style.display = 'none';
          //document.getElementById('option-normal').style.display = 'none';
          //document.getElementById('option-fullscreen').style.display = 'none';
          document.getElementById('map').style.display = 'none';
          document.getElementById('vehicle-details').style.display = 'none';
          $mpContainer.addClass('list-container-fitscreen');
          outerPanel.render('grid');
          
         // Ext.getCmp('pac-input').hide();
            
         // $mpContainer.removeClass('mp-option-showhub');
         setInterval('refreshRecord()',180000);
          
}

var innerPanelForHubDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 110,
    width: 400,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
   
        items: [{
                xtype: 'label',
                text: 'Remarks:',
                cls: 'labelstyle',
                id: 'defaultDaysTxtId'
            },{
                xtype: 'textarea',
				//id: 'rem1',
				readOnly: false,
	   			width: 300,
	   			maxLength: 500,
	   			value: '',
	   			cls: 'bskExtStyle',
                //cls: 'selectstylePerfect',
                id: 'hubId'
            } 
        ]
    
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    }, buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    
                    if (innerPanelForHubDetails.getForm().isValid()) {
                        
                        var selectdName;
                        var selected = grid1.getSelectionModel().getSelected();
                        selectdName= selected.get('vehiclenoindex');
                        //selected.get('vehiclenoindex');
                       
                        taskMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MapView.do?param=AddRemarks',
                            method: 'POST',
                            params: {
                                selectdName:selectdName ,
                                jspName: jspName,
                                hubID:Ext.getCmp('hubId').getValue()
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                setMsgBoxStatus(message);
                                myWin.hide();
                                taskMasterOuterPanelWindow.getEl().unmask();
                                vehicleDetailsStore.reload();
                            },
                            failure: function () {
                                ctsb.setStatus({
                                    text: getMessageForStatus("Error"),
                                    iconCls: '',
                                    clear: true
                                });
                                
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    Ext.getCmp('hubId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});
 

var taskMasterOuterPanelWindow = new Ext.Panel({
    width: 390,
    height:175,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForHubDetails, innerWinButtonPanel]
  });

myWin = new Ext.Window({
    title: 'My win',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 195,
    width: 390,
    id: 'myWin',
    items: [taskMasterOuterPanelWindow]
});
 
 function addRecord() {
    if (grid1.getSelectionModel().getCount() == 0) {
        setMsgBoxStatus('<%=NoRowsSelected%>');
       
        return;
    }
    if (grid1.getSelectionModel().getCount() > 1) {
        setMsgBoxStatus('<%=SelectSingleRow%>');
         
        return;
    }
    var selected = grid1.getSelectionModel().getSelected();
    Ext.getCmp('hubId').setValue(selected.get('remarksindex'));
    buttonValue = 'add';
    titelForInnerPanel = 'Add Remarks';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    
    myWin.show();
}

 function refreshRecord() {
    vehicleDetailsStore.reload();
}

function changecolor()
{
document.getElementById('listviewid').style.color='#02B0E6';
document.getElementById('mapviewid').style.color='#fff';
document.getElementById('listviewid').style.borderColor='#02B0E6';
document.getElementById('mapviewid').style.borderColor='#fff';
}
function changecolor1()
{
document.getElementById('listviewid').style.color='#fff';
document.getElementById('mapviewid').style.color='#02B0E6';
document.getElementById('listviewid').style.borderColor='#fff';
document.getElementById('mapviewid').style.borderColor='#02B0E6';
}

function clearCheckbox()
{
if(selectAll=="true")
{
document.getElementById("selectAll").checked = false;
}
}

function clearCheckbox1()
{
if(selectAll=="true")
{
document.getElementById("selectAll").checked = true;
}
}

var reader1 = new Ext.data.JsonReader({
    idProperty: 'cashVanDetailsid',
    root: 'cashVanListDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
         type: 'int'
    }, {
        name: 'vehiclenoindex',
         type: 'string'
    }, {
        name: 'datetimeindex',
        type: 'date',
        dateFormat: getDateTimeFormat() 
    }, {
        name: 'locationindex',
         type: 'string'
    }, {
        name: 'ignitionindex',
         type: 'string'
    }, {
        name: 'speedindex',
         type: 'int'
    },  {
        name: 'stoppagetimeindex',
         type: 'float'
    },   {
        name: 'statusindex',
         type: 'string'
    },  {
        name: 'drivernameindex',
         type: 'string'
    },  {
        name: 'doorstatusindex',
         type: 'string'
    },  {
        name: 'vehiclegroupindex',
         type: 'string'
    },  {
        name: 'remarksindex',
         type: 'string'
    },  {
        name: 'vehiclemodelindex',
         type: 'string'
    },  {
        name: 'gmtindex',
        type: 'date',
        dateFormat: getDateTimeFormat() 
    },  {
        name: 'id'
    }]
});

  var vehicleDetailsStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MapView.do?param=getCashVanListViewVehicleDetails',
        method: 'POST'
    }),
    storeId: 'taskMasterid',
    reader: reader1
});

var filters1 = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'vehiclenoindex'
    }, {
        type: 'date',
        dataIndex: 'datetimeindex'
    }, {
        type: 'string',
        dataIndex: 'locationindex'
    }, {
        type: 'string',
        dataIndex: 'ignitionindex'
    }, {
        type: 'int',
        dataIndex: 'speedindex'
    }, {
        type: 'float',
        dataIndex: 'stoppagetimeindex'
    }, {
        type: 'string',
        dataIndex: 'statusindex'
    }, {
        type: 'string',
        dataIndex: 'drivernameindex'
    }, {
        type: 'string',
        dataIndex: 'doorstatusindex'
    }, {
        type: 'string',
        dataIndex: 'vehiclegroupindex'
    }, {
        type: 'string',
        dataIndex: 'remarksindex'
    }, {
        type: 'string',
        dataIndex: 'vehiclemodelindex'
    }, {
        type: 'date',
        dataIndex: 'gmtindex'
    }]
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleNO%></span>",
            dataIndex: 'vehiclenoindex',
             width: 100,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'datetimeindex',
            header: "<span style=font-weight:bold;><%=DateTime%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
             width: 150,
            filter: {
                type: 'date'
            }
        },  {
            header: "<span style=font-weight:bold;><%=Location%></span>",
            dataIndex: 'locationindex',
             width: 400,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'ignitionindex',
            header: "<span style=font-weight:bold;><%=Ignition%></span>",
             width: 70,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'speedindex',
            header: "<span style=font-weight:bold;><%=Speed%></span>",
             width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'stoppagetimeindex',
            header: "<span style=font-weight:bold;><%=StoppageTime%></span>",
            renderer: Ext.util.Format.numberRenderer('0.00'),
             width: 150,
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'statusindex',
            header: "<span style=font-weight:bold;><%=Status%></span>",
              width: 100,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'drivernameindex',
            header: "<span style=font-weight:bold;><%=DriverName%></span>",
            width: 200,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DoorStatus%></span>",
             width: 100,
            dataIndex: 'doorstatusindex',
             
            filter: {
                type: 'string'
            }
        },  {
            dataIndex: 'vehiclegroupindex',
            header: "<span style=font-weight:bold;><%=VehicleGroup%></span>",
             width: 200,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'remarksindex',
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
             width: 200,
            filter: {
                type: 'string'
            }
        },  {
            dataIndex: 'vehiclemodelindex',
            header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
            width: 200,
            filter: {
                type: 'string'
            }
        },  {
            dataIndex: 'gmtindex',
            header: "<span style=font-weight:bold;><%=GMT%></span>",
             width: 150,
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};      

 //**************************************GRID***************************************************************
// var grid= getHubOpearationGrid('HubOperationalDetails', 'NoRecordsFound', hubOperationStore, screen.width - 25, 455, 10, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, '', jspName, exportDataType, false, '', false, 'add', false, 'modify',false,'del',false,'details');
    var   grid1= getCashVanGrid('', 'NoRecordsFound', vehicleDetailsStore, screen.width - 30, 478, 15, true,'Refresh',filters1, 'ClearFilterData', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'Acknowledge', false, 'Modify');
     
        outerPanel = new Ext.Panel({
        id:'outerpanel',
        height:487,
        autoScroll:true,
        width:screen.width-15,
        layoutConfig: {
            columns: 1
        },
        items: [grid1],
        bbar: ctsb
       
    });

 Ext.onReady(function () {
    gridLoad();
    vehicleType="";
    if(previousVehicleType!=null && previousVehicleType!="")
    {
    vehicleType=previousVehicleType;
    }
    vehicleDetailsStore.load({
params:{custName:'<%=customernamelogged%>',jspName:jspName,vehicleType:vehicleType } });
});
 
        
	</script>
    </body>
      </html> 
