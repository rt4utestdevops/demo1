
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";	
 	 	
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
String selectAll="Select All";
  %>
<!DOCTYPE html>
<html>
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
     
    <title>Map</title> 
  <head>
     <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/mapView/css/MiningComponent.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/mapView/css/layout.css" /> 
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
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/common.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
		<pack:script src="../../Main/Js/examples1.js"></pack:script>
		<pack:style src="../../Main/resources/css/examples1.css" />
	<style>      
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
	</style>
	</head>
    <script src=<%=GoogleApiKey%>></script>
<!--     <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places"></script>-->
     <body background-color="white">
	 <div class="container">
	 <header>
								
				<h1><span>Public View</span></h1>					
			</header>
		 <div class = "main">
		 	<div class="mapview-asset-commstatus" id="mapview-asset-commstatus-id">
			<div id="mapview-commstatus-dashboard-id" class="map-view-noncommststus-dashboard">
			  
			</div>
			<div id="mapview-commstatus-id" class="map-view-noncommststus-grid"></div>
			
			</div>
			<div class="mp-vehicle-wrapper" id="vehicle-list"></div>
			<div class="mp-vehicle-details-wrapper" id="vehicle-details">
			<form class="me-select">
				<ul id="me-select-list" class='me-select-ul'>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Vehicle Number</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="vehiclenumber"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Location</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="location"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Date and Time</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="datetime"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Driver Name</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="drivername"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Ignition</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="ignition"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Speed</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="speed"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Vehicle ID</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="vehicleid"></p></li>
				<li class='me-select-label'><span class='vehicle-details-block-header'>Owner Name</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="ownername"></p></li>
<!--				<li class='me-select-label'><span class='vehicle-details-block-header'>Trip No</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="tripno"></p></li>-->
<!--				<li class='me-select-label'><span class='vehicle-details-block-header'>Trip Validity</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="tripvalidity"></p></li>-->
<!--				<li class='me-select-label'><span class='vehicle-details-block-header'>Status</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="status"></p></li>-->
<!--				<li class='me-select-label'><span class='vehicle-details-block-header'>Subscription Validity </span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="subscriptionvalidity"></p></li>-->
<!--				<li class='me-select-label'><span class='vehicle-details-block-header'>Reminder Date</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id="reminderdate"></p></li>-->
<!--				-->
					</ul>
					
			 </form>						
			</div>
				<div class="mp-container" id="mp-container">
				
			        <div id="grid">
			          
					<div class="mp-map-wrapper" id="map"> </div>
					<div class="mp-options-wrapper"/>
					
					
					<table width="98%">
						<tr height="10px"><td > <div class="mp-option-showhub" id="show"></div></td>
							<td>
								<div>
							<img class="refreshImage" id="clear" src="/ApplicationImages/ApplicationButtonIcons/removeMarker.png" onclick="removeMapMarker()"/>
							<span class="refresh" >&nbsp;&nbsp;Clear</span>
								</div>
							</td>
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
		var infowindowsOne= {};
		var circles = [];
		var polygons =[];
		var buffermarkers = [];
		var polygonmarkers =[];
		var marker;
		var detailspage=0;
	    var map;
		var infowindow;
		var infowindowOne;
		var jspName="Map View";
		var circle;
		var button="Map";
		var previousSelectedRow=-1;
		var contentOne;
		var selectAll="select";
		var clear="Add";
		var systemId="15";
		var clientId="950";
		
		var ctsb;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		document.getElementById('option-normal').style.display = 'none';
		
		
		
		
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
		
       
		document.getElementById('search-input').style.visibility = 'hidden';
		document.getElementById('map').style.display = 'block';
        document.getElementById('vehicle-details').style.display = 'block';
        document.getElementById('vehicle-list').style.display = 'block';
        $mpContainer.removeClass('list-container-fitscreen');
        var defaultBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),
        new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));
        map.fitBounds(defaultBounds);
       
       
					
		}
//*****************************Multiple Vehicle Screen ******************************************************		
		function multipleVehicleScreen()
		{
        document.getElementById('option-normal').style.display = 'none';	
        document.getElementById('vehicle-details').style.display = 'none';
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
		contentOne = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td></td><td>'+vehicleNo+'</td></tr>'+
			'</table>'+
			'</div>';
		infowindow = new google.maps.InfoWindow({
      		content: content,
      		marker:marker,
      		maxWidth: 300,
      		image:image,
      		id:vehicleNo
  		 });	
  		 infowindowOne = new google.maps.InfoWindow({
      		contents: contentOne,
      		marker:marker,
      		maxWidth: 300,      		
      		image:image,
      		id:vehicleNo
  		 });
		google.maps.event.addListener(marker,'click', (function(marker,contents,infowindow){ 
    			return function() {
    				showDetails(false);    				
    				infowindow.setContent(content);
        			infowindow.open(map,marker);
        			document.getElementById("c2").checked=true;         			
    			};
			})(marker,content,infowindow));
		google.maps.event.addListener(infowindow,'closeclick',function(){
			document.getElementById("c2").checked=false;						
		});
		infowindowOne.setContent(contentOne);
        infowindowOne.open(map,marker);        
        document.getElementById("c2").checked=true;	
         
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
	    infowindowsOne[vehicleNo]=infowindowOne;   
	    }

//********************************* Remove Vehicle Marker**********************************************	    
	  
	    function removeVehicleMarker(vehicleNo)
	    {
	    	  
	    	   if(markers[vehicleNo]!=null){
  				var marker = markers[vehicleNo];
    			marker.setMap(null);
    			marker=null;
    			}
    		}	   	     
//********************************* Load Vehicles********************************************************	    
	    function loadvehicles()
	    {
				document.getElementById('vehiclenumber').innerHTML='';
				document.getElementById('location').innerHTML='';
				document.getElementById('datetime').innerHTML='';
				document.getElementById('drivername').innerHTML='';
				document.getElementById('ignition').innerHTML='';	
				document.getElementById('speed').innerHTML='';
				document.getElementById('vehicleid').innerHTML='';
				document.getElementById('ownername').innerHTML='';
				//document.getElementById('status').innerHTML='';
				//document.getElementById('tripno').innerHTML='';
				//document.getElementById('tripvalidity').innerHTML='';
				//document.getElementById('subscriptionvalidity').innerHTML='';
			   // document.getElementById('reminderdate').innerHTML='';
	            reszieFullScreen();
	    
	            var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
    				marker.setMap(null);
    			}	
				}); 
		         
    	
	    }	    
//********************************** Refresh Vehicles every 5 min*****************************************************

function refreshVehicle()
{       mapZoom=map.getZoom();
        previousSelectedRow=-1;
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
		  
		 	    document.getElementById('vehiclenumber').innerHTML='';
				document.getElementById('location').innerHTML='';
				document.getElementById('datetime').innerHTML='';
				document.getElementById('drivername').innerHTML='';
				document.getElementById('ignition').innerHTML='';	
				document.getElementById('speed').innerHTML='';
				document.getElementById('vehicleid').innerHTML='';
				document.getElementById('ownername').innerHTML='';
				//document.getElementById('status').innerHTML='';
				//document.getElementById('tripno').innerHTML='';
				//document.getElementById('tripvalidity').innerHTML='';
				//document.getElementById('subscriptionvalidity').innerHTML='';
			   // document.getElementById('reminderdate').innerHTML='';
	        
	  		    reszieFullScreen();
	   
	    		var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
    				selectedIdx.push(grid.getStore().indexOf(vehicle));
    				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
					{
						selVehicles.push(store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']);
    				}
    				
				});
			showDetails(true); 	 
		
					
	    store.load({
    	params:{SystemId:systemId,ClientId:clientId},
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
				url: '<%=request.getContextPath()%>/MapView.do?param=getBufferMapViewForDMG',
				id:'BufferMapView',
				root: 'BufferMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','buffername','radius','imagename']
		}); 
		
		var polygonStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getPolygonMapViewForDMG',
				id:'PolygonMapView',
				root: 'PolygonMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','polygonname','sequence','hubid']
		});
		
		
		var mapViewAssetDetails = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getDMGMapViewVehicleDetails',
				id:'MapViewVehicleDetails',
				root: 'MapViewVehicleDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['vehicleNo','location','datetime','driverName','ignition','speed','vehicleId','ownerName','status','subscriptionValidity','remainderDate']
		});
		
		var tripDetails = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getTripDetails',
				id:'tripDetails',
				root: 'tripDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['tripNo','startDate']
		});
		
		
					
//*************************************** Display Hub *********************************************	

	    function showHub(cb)
	    {
	    	if(cb.checked)
	    	{
	    	loadMask.show();	
	    		bufferStore.load({
	    		params:{SystemId:systemId,ClientId:clientId},
	    			callback:function(){
	    							plotBuffers();
	    							loadMask.hide();	
	    							}
	    					});
	    		polygonStore.load({
	    		params:{SystemId:systemId,ClientId:clientId},
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
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
					if(cb.checked)
	    			{
	    				infowindowsOne[infowindowId].open(map, markers[infowindowId]); 
    	    			infowindowOne.setContent(contentOne);
    	    		}
    	    		else
    	    		{
    	    			infowindowsOne[infowindowId].setMap(null);
    	    		}
    	    		}
				}); 
	    }

//******************************************* Buffer *******************************************************	    
	    function plotBuffers()
	    {
	    for(var i=0;i<bufferStore.getCount();i++)
	    {
	    var rec=bufferStore.getAt(i);
	    var urlForZero='/ApplicationImages/VehicleImages/information.png';
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
	        if(convertRadiusToMeters==0 && rec.data['imagename']!='')
	        {
	        var image1='/jsps/images/CustomImages/';
	        var image2=rec.data['imagename'];
	        urlForZero= image1+image2 ;
	        }
	       else if (convertRadiusToMeters==0 && rec.data['imagename']=='')
	       {
	       urlForZero='/jsps/OpenLayers-2.10/img/marker.png';
	       }
	  bufferimage = {
	        	url: urlForZero, // This marker is 20 pixels wide by 32 pixels tall.
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
        		 } ,
        		 {
        		 	name:'status'
        		 }
        		     
        	  ]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getMapViewVehiclesForDMG',
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
     height 	: 580,
     width		: 210,
     viewConfig: {
            forceFit: true,
          getRowClass: function(record, index) {
        var status = record.get('status').trim();
       
        if(status=='Inactive')
        {
        	
        	return 'red-row';
        }

        
    }
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
 		   
  }	if( selectedRows.length>1){
  	                 multipleVehicleScreen();
            
           	}
  	else if( selectedRows.length==1){
  	 var record = grid.getSelectionModel().getSelections(); 
			Ext.iterate(record, function(record, index) {
			//alert('inside-->'+selectAll+'---'+clear);
			if(selectAll!="deselect" && clear!="remove"){
			    //alert('selectRows');
           	       mapViewAssetDetails.load({
						params:{vehicleNo:rec.data['vehicleNo'],SystemId:systemId,ClientId:clientId},
						callback:function()
							{
							   if(mapViewAssetDetails.getCount()>0){
							   	var record=mapViewAssetDetails.getAt(0);
								document.getElementById('vehiclenumber').innerHTML=record.data['vehicleNo'];
							 	document.getElementById('location').innerHTML=rec.data['location'];
								document.getElementById('datetime').innerHTML=rec.data['gmt'];
								document.getElementById('drivername').innerHTML=record.data['driverName'];
								document.getElementById('ignition').innerHTML=record.data['ignition'];	
								document.getElementById('speed').innerHTML=record.data['speed'];
								document.getElementById('vehicleid').innerHTML=record.data['vehicleId'];
								document.getElementById('ownername').innerHTML=record.data['ownerName'];
								//document.getElementById('status').innerHTML=record.data['status'];
								//document.getElementById('subscriptionvalidity').innerHTML=record.data['subscriptionValidity'];
								//document.getElementById('reminderdate').innerHTML=record.data['remainderDate'];
								
<!--								tripDetails.load({-->
<!--						        params:{vehicleNo:record.data['vehicleNo']},-->
<!--						        callback:function()-->
<!--							    {-->
<!--							       if(tripDetails.getCount()>0){-->
<!--								   var record1=tripDetails.getAt(0);-->
<!--								   //document.getElementById('tripno').innerHTML=record1.data['tripNo'];-->
<!--								   //document.getElementById('tripvalidity').innerHTML=record1.data['startDate'];-->
<!--								-->
<!--								    }-->
<!--								}-->
<!--							});-->
			         	}
				      }
    	          });
    	          }	
    	        });
   	         }
           	else if( selectedRows.length==0){
           		document.getElementById('vehiclenumber').innerHTML='';
				document.getElementById('location').innerHTML='';
				document.getElementById('datetime').innerHTML='';
				document.getElementById('drivername').innerHTML='';
				document.getElementById('ignition').innerHTML='';	
				document.getElementById('speed').innerHTML='';
				document.getElementById('vehicleid').innerHTML='';
				document.getElementById('ownername').innerHTML='';
				//document.getElementById('status').innerHTML='';
				//document.getElementById('tripno').innerHTML='';
				//document.getElementById('tripvalidity').innerHTML='';
				//document.getElementById('subscriptionvalidity').innerHTML='';
			   // document.getElementById('reminderdate').innerHTML='';
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
            var record = grid.getSelectionModel().getSelections(); 
            Ext.iterate(record, function(record, index) {
            //alert(selectAll+'-->'+clear);
           			if(selectAll!="deselect" && clear!="remove"){
           			mapViewAssetDetails.load({
						params:{vehicleNo:rec.data['vehicleNo'],SystemId:systemId,ClientId:clientId},
						callback:function()
							{
							   if(mapViewAssetDetails.getCount()>0){
							   	var record1=mapViewAssetDetails.getAt(0);
								document.getElementById('vehiclenumber').innerHTML=record.data['vehicleNo'];
							 	document.getElementById('location').innerHTML=record.data['location'];
								document.getElementById('datetime').innerHTML=record.data['gmt'];
								document.getElementById('drivername').innerHTML=record1.data['driverName'];
								document.getElementById('ignition').innerHTML=record1.data['ignition'];	
								document.getElementById('speed').innerHTML=record1.data['speed'];
								document.getElementById('vehicleid').innerHTML=record1.data['vehicleId'];
								document.getElementById('ownername').innerHTML=record1.data['ownerName'];
								//document.getElementById('status').innerHTML=record.data['status'];
								//document.getElementById('subscriptionvalidity').innerHTML=record.data['subscriptionValidity'];
								//document.getElementById('reminderdate').innerHTML=record.data['remainderDate'];
								
<!--								tripDetails.load({-->
<!--						        params:{vehicleNo:record.data['vehicleNo']},-->
<!--						        callback:function()-->
<!--							    {-->
<!--							       if(tripDetails.getCount()>0){-->
<!--								   var record1=tripDetails.getAt(0);-->
<!--								   //document.getElementById('tripno').innerHTML=record1.data['tripNo'];-->
<!--								   //document.getElementById('tripvalidity').innerHTML=record1.data['startDate'];-->
<!--								-->
<!--								    }-->
<!--								}-->
<!--							});-->
			         	}
				    }
    	        });	
				}
				 if(clear=="remove"){
           		    document.getElementById('vehiclenumber').innerHTML='';
					document.getElementById('location').innerHTML='';
					document.getElementById('datetime').innerHTML='';
					document.getElementById('drivername').innerHTML='';
					document.getElementById('ignition').innerHTML='';	
					document.getElementById('speed').innerHTML='';
					document.getElementById('vehicleid').innerHTML='';
					document.getElementById('ownername').innerHTML='';
           		}
           		else if(selectAll=="deselect"){
         			 document.getElementById('vehiclenumber').innerHTML='';
					document.getElementById('location').innerHTML='';
					document.getElementById('datetime').innerHTML='';
					document.getElementById('drivername').innerHTML='';
					document.getElementById('ignition').innerHTML='';	
					document.getElementById('speed').innerHTML='';
					document.getElementById('vehicleid').innerHTML='';
					document.getElementById('ownername').innerHTML='';
           			}
           			selectAll="select";  
           			clear="Add"; 	    
			});
						
           	}
           	else if( selectedRows.length==0){
           		document.getElementById("c2").checked=false;
               	document.getElementById('vehiclenumber').innerHTML='';
				document.getElementById('location').innerHTML='';
				document.getElementById('datetime').innerHTML='';
				document.getElementById('drivername').innerHTML='';
				document.getElementById('ignition').innerHTML='';	
				document.getElementById('speed').innerHTML='';
				document.getElementById('vehicleid').innerHTML='';
				document.getElementById('ownername').innerHTML='';
				//document.getElementById('status').innerHTML='';
				//document.getElementById('tripno').innerHTML='';
				//document.getElementById('tripvalidity').innerHTML='';
				//document.getElementById('subscriptionvalidity').innerHTML='';
			    //document.getElementById('reminderdate').innerHTML='';
           		}     
           
  });
  
  function removeMapMarker()
  { 
   var selectedRows = selModel.getSelections();   
   document.getElementById("selectAll").checked=false;
   if(selectedRows.length>0){
    clear="remove";
    //alert(clear);
   			for(var i=0;i<selectedRows.length;i++)
       		 {
      		  var index=i;
      		  var seletionModel = grid.getSelectionModel();
      		  var selectedRecords = selModel.getSelections();
      		  var myValue = selectedRecords[index].get('vehicleNo');
       		  removeVehicleMarker(myValue);   
		 //document.getElementById('status').innerHTML='';
		 //document.getElementById('tripno').innerHTML='';
		 //document.getElementById('tripvalidity').innerHTML='';
		 //document.getElementById('subscriptionvalidity').innerHTML='';
		 //document.getElementById('reminderdate').innerHTML='';	
		 document.getElementById('vehiclenumber').innerHTML='';
		 document.getElementById('location').innerHTML='';
		 document.getElementById('datetime').innerHTML='';
		 document.getElementById('drivername').innerHTML='';
		 document.getElementById('ignition').innerHTML='';	
		 document.getElementById('speed').innerHTML='';
		 document.getElementById('vehicleid').innerHTML='';
		 document.getElementById('ownername').innerHTML='';
       	 grid.getSelectionModel().clearSelections(); 
       	 }
       	 mapViewAssetDetails.removeAll();
       	 
   }
   clear="Add";
   grid.getSelectionModel().clearSelections();   
    var len = selModel.getSelections();        	   
        if(len.length == 0)
        {
        mapViewAssetDetails.removeAll();	
         document.getElementById('vehiclenumber').innerHTML='';
		 document.getElementById('location').innerHTML='';
		 document.getElementById('datetime').innerHTML='';
		 document.getElementById('drivername').innerHTML='';
		 document.getElementById('ignition').innerHTML='';	
		 document.getElementById('speed').innerHTML='';
		 document.getElementById('vehicleid').innerHTML='';
		 document.getElementById('ownername').innerHTML='';
		 //document.getElementById('status').innerHTML='';
		 //document.getElementById('tripno').innerHTML='';
		 //document.getElementById('tripvalidity').innerHTML='';
		 //document.getElementById('subscriptionvalidity').innerHTML='';
		 //document.getElementById('reminderdate').innerHTML='';	
        }
  }
  
       function startfilter() {
        
        var selectedRows = selModel.getSelections();
        if(Ext.getCmp('searchVehicle').getValue()!=''  && Ext.getCmp('searchVehicle').getValue().trim().length>2)
        {
        	
        for(var i=0;i<selectedRows.length;i++)
        {
        var index=i;
        var seletionModel = grid.getSelectionModel();
        var selectedRecords = selModel.getSelections();
        var myValue = selectedRecords[index].get('vehicleNo');
        removeVehicleMarker(myValue);         
        } 
        mapViewAssetDetails.removeAll();        
         document.getElementById('vehiclenumber').innerHTML='';
		 document.getElementById('location').innerHTML='';
		 document.getElementById('datetime').innerHTML='';
		 document.getElementById('drivername').innerHTML='';
		 document.getElementById('ignition').innerHTML='';	
		 document.getElementById('speed').innerHTML='';
		 document.getElementById('vehicleid').innerHTML='';
		 document.getElementById('ownername').innerHTML='';
		 //document.getElementById('status').innerHTML='';
		 //document.getElementById('tripno').innerHTML='';
		 //document.getElementById('tripvalidity').innerHTML='';
		 //document.getElementById('subscriptionvalidity').innerHTML='';
		// document.getElementById('reminderdate').innerHTML='';	 
		 grid.getSelectionModel().clearSelections();         
        }
        var len = selModel.getSelections();        
        if(len.length == 0)
        {
         document.getElementById('vehiclenumber').innerHTML='';
		 document.getElementById('location').innerHTML='';
		 document.getElementById('datetime').innerHTML='';
		 document.getElementById('drivername').innerHTML='';
		 document.getElementById('ignition').innerHTML='';	
		 document.getElementById('speed').innerHTML='';
		 document.getElementById('vehicleid').innerHTML='';
		 document.getElementById('ownername').innerHTML='';
		 //document.getElementById('status').innerHTML='';
		 //document.getElementById('tripno').innerHTML='';
		 //document.getElementById('tripvalidity').innerHTML='';
		// document.getElementById('subscriptionvalidity').innerHTML='';
		 //document.getElementById('reminderdate').innerHTML='';	
        }
		var val = Ext.getCmp('searchVehicle').getValue();
		var cm = this.grid.getColumnModel();
 		var filter = this.grid.filters.filters.get(cm.getDataIndex(1));
 		filter.setValue(val);
 		if(val!="" && val.trim().length>2) {
 			filter.setActive(true);
 		} else {
 			filter.setActive(false);
 		}
 		
	} 
//******************************************* Vehicle Panel****************************************
	
   Ext.Ajax.timeout = 360000;

   var vehiclePannel =new Ext.Panel({
   					id:'vehiclePannel',
                    height : 600,
                    items: [{
                    		xtype:'textfield',
                    		id:'searchVehicle',
                    		width:'98%',
                    		height:30,
                    		emptyText:'Enter 3 Digits To Filter Vehicle',
                    		cls:'searchtextbox',
                    		fireKey: function (e) {                    				
                        			if (e.type == 'keydown' || e.type == 'keypress') {
                            setTimeout('startfilter()', 500);
                        			}
                    				}
							}, {
							xtype: 'panel',
							name :'image',
							html : '<div id="SELECTALL" style="background-color:#E4E4E4;height:20px;width:203px;font-size:11px;"><input  type="checkbox" id="selectAll" name="cc" onclick="selecAllVehicles(this)"/><label for="selectAll"><span margin: "6px 4px 0 0"></span></label><span class="vehicle-show-details-block"><%=selectAll%></span></div>'          
							}, grid]
                });
        loadvehicles();        
		setInterval(function(){refreshVehicle()},180000);  
        vehiclePannel.render('vehicle-list');	
  
 //********************************* Select All ********************************************************

function selecAllVehicles(cb)
  {		
	    var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
    				marker.setMap(null);
    			}	
				}); 
   if(cb.checked)
   { 
   		var count = store.snapshot ? store.snapshot.length : store.getCount();
     if(count<=100){
       selectAll="select";
       grid.getSelectionModel().selectAll();
     }else{
        removeMapMarker();
     	Ext.example.msg("Cannot Select more than 100 vehicles");
     }
    }  
   else
   {  
       selectAll="deselect";
       mapViewAssetDetails.removeAll();
       grid.getSelectionModel().clearSelections();
         document.getElementById('vehiclenumber').innerHTML='';
		 document.getElementById('location').innerHTML='';
		 document.getElementById('datetime').innerHTML='';
		 document.getElementById('drivername').innerHTML='';
		 document.getElementById('ignition').innerHTML='';	
		 document.getElementById('speed').innerHTML='';
		 document.getElementById('vehicleid').innerHTML='';
		 document.getElementById('ownername').innerHTML='';
		mapViewAssetDetails.removeAll();
           
   }
  }	    
         
//****************************OnReady*********************************//

Ext.onReady(function () {

	 store.load({params:{SystemId:systemId,ClientId:clientId}});

});
 
        
	</script>
    </body>
</html> 
