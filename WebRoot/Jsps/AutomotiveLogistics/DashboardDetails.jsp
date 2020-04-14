<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
String vehicleNo="";
String shipmentId="";
String routeId="";
String flag="";
int customerId = loginInfo.getCustomerId();	
int systemId=loginInfo.getSystemId();
if(request.getParameter("flag")!=null){
	routeId = request.getParameter("routeName");
	vehicleNo = request.getParameter("vehicleNo");		
	shipmentId = request.getParameter("shipmentId");
	flag=request.getParameter("flag");//"MRDASHBOARD";
}
if(request.getParameter("data") != null && !request.getParameter("data").equals("")){
String data = request.getParameter("data");
String parts[] = data.split("---");	
routeId = parts[0].trim();
vehicleNo = parts[1].trim();		
shipmentId = parts[2].trim();
}
String fromdatefordetailspage="";
String todatefordetailspage="";
String typefordetailspage="";
String fromlocationfordetailspage="";
String fromlocationIdfordetailspage="";
String tolocationfordetailspage="";
String tolocationIdfordetailspage="";
String dashboardFrom="";
if(request.getParameter("dashBoard")!=null){
dashboardFrom=request.getParameter("dashBoard");
}
  
if(request.getParameter("fromdatefordetailspage") != null && request.getParameter("todatefordetailspage")!= null && request.getParameter("typefordetailspage") != null && request.getParameter("fromlocationfordetailspage")!= null && request.getParameter("fromlocationIdfordetailspage")!= null && request.getParameter("tolocationfordetailspage")!= null && request.getParameter("tolocationIdfordetailspage")!= null){
	fromdatefordetailspage=request.getParameter("fromdatefordetailspage");
	todatefordetailspage=request.getParameter("todatefordetailspage");
	typefordetailspage=request.getParameter("typefordetailspage");
	fromlocationfordetailspage=request.getParameter("fromlocationfordetailspage");
	fromlocationIdfordetailspage=request.getParameter("fromlocationIdfordetailspage");
	tolocationfordetailspage=request.getParameter("tolocationfordetailspage");
	tolocationIdfordetailspage=request.getParameter("tolocationIdfordetailspage");
	
}
Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
CommonFunctions cf = new CommonFunctions();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Location");
tobeConverted.add("Hub_Id");
tobeConverted.add("Trip_Id");
tobeConverted.add("Planned_Time");
tobeConverted.add("Actual_Time");
tobeConverted.add("Sequence");
tobeConverted.add("Notification");
tobeConverted.add("Remarks");
tobeConverted.add("Action_Status");
tobeConverted.add("Issue");
tobeConverted.add("Trip_Status");
tobeConverted.add("Shipment_Status");
tobeConverted.add("Latitude");
tobeConverted.add("Longitude");
tobeConverted.add("GPS");
tobeConverted.add("Status");
tobeConverted.add("Action");
tobeConverted.add("Back");
tobeConverted.add("Stopped");
tobeConverted.add("Running");
tobeConverted.add("Idle");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SLNO = convertedWords.get(0);
String ID = convertedWords.get(1);
String Location = convertedWords.get(2);
String HubId = convertedWords.get(3);
String TripId= convertedWords.get(4);
String PlannedTime = convertedWords.get(5);
String ActualTime = convertedWords.get(6);
String Sequence = convertedWords.get(7);
String Notification = convertedWords.get(8);
String Remarks = convertedWords.get(9);
String ActionStatus = convertedWords.get(10);
String Issue = convertedWords.get(11);
String TripStatus = convertedWords.get(12);
String ShipmentStatus = convertedWords.get(13);
String Latitude = convertedWords.get(14);
String Longitude = convertedWords.get(15);
String GPS = convertedWords.get(16);
String Status = convertedWords.get(17);
String Actions = convertedWords.get(18);
String Back =  convertedWords.get(19);
String Stopped=convertedWords.get(20);
String Running=convertedWords.get(21);
String Idle=convertedWords.get(22);
String PointStatus="Point Status";
%>

<!DOCTYPE HTML>
<html>
  <head>
    <title>DashboardDetails</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <style>
    .mp-container {
	background: #f4f4f4;
	border: 5px solid #fff;
	width: 38%;
	height: 471px;
	position: relative;
	margin: initial;
	left: 60%;
	-moz-box-shadow: 1px 1px 3px #cac4ab;
	-webkit-box-shadow: 1px 1px 3px #cac4ab;
	box-shadow: 1px 1px 3px #cac4ab;
}

#grid-panel.main1 {
width: 60%;
height: 75px;   
float: right;
margin-left:5px;
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}

.mp-vehicle-details-wrapper{
width: 40.5%;
height: 550px;
float: right;
background-color: #ffffff;
overflow: auto;
overflow-x: hidden;
}
    </style>
    
	<link rel="stylesheet" href="../../Main/modules/automotiveLogistics/mapview/css/component.css" type="text/css" />
  	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
	<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
	<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
	<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
	<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
	<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
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
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/chooser.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/modules/sandMining/theme/css/component.css" />
	<pack:style src="../../Main/resources/css/dashboard.css" />
	<pack:style src="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />
	<pack:style src="../../Main/iconCls/icons.css" />
	<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
	<pack:script src="../../Main/Js/examples1.js"></pack:script>
	<pack:style src="../../Main/resources/css/examples1.css" />
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
	<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>
	<pack:script src="../../Main/Js/jQueryMask.js"></pack:script>
     <pack:style src="../../Main/modules/common/jquery.loadmask.css" />
  </head>
  
  <body>
   <script src=<%=GoogleApiKey%>></script>
   <div class="container">
	   		<div>
		   		 <div class="header" id="header">	
					<h1>
						<span>Dashboard Details</span>						
					</h1>
								
				 </div>
	   		</div>
	   		<div class="main1" id="grid-panel"></div>
	   		<div class="mp-container" id="mp-container">
				<div class="mp-map-wrapper" id="map"></div>
				<div class="mp-options-wrapper"/>
				<table style="width: 96%;">
					<tr>
						<td align="center" style="width: 20%;">
							<div>
								<img class="vehicle_marker" src="/ApplicationImages/VehicleImages/red2.png">            				
								<span class="vehicle_marker_label" style="padding-right: 10px;"><%=Stopped%></span>
							</div>
						</td>
							<td style="width: 20%;">
								<div>
									<img class="vehicle_marker" src="/ApplicationImages/VehicleImages/green2.png">							
									<span  class="vehicle_marker_label" style="padding-right: 10px;"><%=Running%></span>
								</div>
							</td>
							<td style="width: 40%;">
								<div>
									<img class="vehicle_marker" src="/ApplicationImages/VehicleImages/yellow2.png">							
									<span class="vehicle_marker_label"style="padding-right: 10px;"><%=Idle%></span>
								</div>
							</td>
							<td style="width: 25%;">
								<div>
									<input type="submit" id ="tracePath" onclick = "getHistoryData()" value = "Route Path" Style="background-color:#7b766f;border-radius: 13px;border: solid;color:white; width: 95px;height:27px;" hidden="true";>							
								</div> 
							</td>
						<td>
							<div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
							<div class="mp-option-fullscreen" id="option-fullscreen" onclick="mapFullScreen()"></div>
						</td>
					</tr>
				</table>
			</div>
   </div>
   <script>
    var jspName = "Dashboard_Details";
	var exportDataType = "int,string,int,int,string,string,int,string,string,string,string,string,string,string";
    var grid;
    var myWin;
	var map;
	var $mpContainer = $('#mp-container');
	var $mapEl = $('#map'); 
	var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
	var shipmentStatus="";
	var actionButton= 0;
	var actionsStatus;
	var issuess;
	var status;
	var imageurl;
	var datalist = [];
    var infolist = [];
    var createlndmrk=false;
    var dataAndInfoList;
  	var centerMap ; 
	var lastlat; 
	var infoWindows = [];    
	var lineInfo = [];       
	var buttonwidth = 622;                    
    var custId='<%=customerId%>';
    var sysId='<%=systemId%>';                    
  
	document.getElementById('option-normal').style.display = 'none';
	function initialize() {
        var mapOptions = {
            zoom: 3,
            center: new google.maps.LatLng(21.0000, 78.0000),
            mapTypeControl: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };        
        map = new google.maps.Map(document.getElementById('map'), mapOptions); 
        mapZoom = 10;
        var defaultBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),
        new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));
        map.fitBounds(defaultBounds);       
    }
     google.maps.event.addDomListener(window, 'load', initialize);
     function mapFullScreen() {
		    document.getElementById('option-fullscreen').style.display = 'none';
		    document.getElementById('option-normal').style.display = 'block';
		    $mpContainer.removeClass('mp-container-fitscreen');
		    $mpContainer.addClass('mp-container-fullscreen').css({
		        width: 'originalWidth',
		        height: 485
		    });
		    $mapEl.css({
		        width: $mapEl.data('originalWidth'),
		        height: $mapEl.data('originalHeight')
		    });
		    google.maps.event.trigger(map, 'resize');
		    if((centerMap != null) && (lastlat != null)){
		     var bounds = new google.maps.LatLngBounds();
		            bounds.extend(centerMap);
		            bounds.extend(lastlat);
		            map.fitBounds(bounds); 	
		        }
		   // map.setZoom(8);
		}

		function reszieFullScreen() {
		    document.getElementById('option-fullscreen').style.display = 'block';
		    document.getElementById('option-normal').style.display = 'none';
		    $mpContainer.removeClass('mp-container-fitscreen');
		    $mpContainer.removeClass('mp-container-fullscreen');
		    $mpContainer.addClass('mp-container');
		    $mapEl.css({
		        width: $mapEl.data('originalWidth'),
		        height: $mapEl.data('originalHeight')
		    });
		    google.maps.event.trigger(map, 'resize');
		    if((centerMap != null) && (lastlat != null)){
		     var bounds = new google.maps.LatLngBounds();
		            bounds.extend(centerMap);
		            bounds.extend(lastlat);
		            map.fitBounds(bounds); 	
		        }
		   // map.setZoom(6);
		}
		var stautsStore = new Ext.data.SimpleStore({
	      id: 'stautsStoreId',
	      fields: ['Name', 'Value'],
	      autoLoad: true,
	      data: [
	          ['Active','Active'],
	          ['Closed','Closed']
	      ]
	  	});	  	
	  	var issuescombostore = new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getIssuesList',
			id: 'issuesId',
			root: 'issuesRoot',
			autoLoad: true,
			remoteSort: true,
			fields: ['value']
		});
		var statusCombo = new Ext.form.ComboBox({ 	
	   		cls:'selectstylePerfect',
	   		allowBlank: false,
	   		mode: 'local',
	   		forceSelection: true,
	   		triggerAction: 'all',
	   		anyMatch: true,
	        onTypeAhead: true,
	        selectOnFocus: true,
	   		store:stautsStore,
	   		valueField:'Name',
	   		displayField:'Value',
	   		id:'actionstatusId',
	   		listeners:{
	   			select: {
		            fn: function () {
		            	//actionstatus = Ext.getCmp('actionstatusId').getValue();
		            }
		        }
	   		}	    		
	   });
	   
	   
	   function closeInfowindow()
	   {
			if(infoWindows.length > 0){
				infoWindows[0].set("marker",null);
				infoWindows[0].close();
				infoWindows.length = 0;
		    } 
       } 
       
	 function clearMap()
	 {
	        if(lineInfo.length > 0){
		 		    var marker = lineInfo[0];
	    			marker.setMap(null);
	    			marker=null;
    			}
	  }
	   
 function getHistoryData() 
 {
	$("#mp-container").mask();
	if(store.getCount()>0){
	var rec=store.getAt(0);
	var timeband = 0;
	var startdate = rec.data['startDate'];
	var Sdatetime=startdate.split(" ");
	var startDate = Sdatetime[0].trim();
	var startTime = Sdatetime[1].split(":");
	var starttimehr = startTime[0]; 
	var starttimemin = startTime[1]; 
	
	var enddate = rec.data['endDate'];
	var Edatetime=enddate.split(" ");
	var endDate = Edatetime[0].trim();
	var endTime = Edatetime[1].split(":");
	var endtimehr = endTime[0]; 
	var endtimemin = endTime[1];

	var pattrn = new RegExp("^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
	
	   	$.ajax({
		url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=submit',
		data:{
			vehicleNo:'<%=vehicleNo%>',
			startdate:startDate,
			timeband:timeband,
			startdatetimehr:starttimehr,
			startdatetimemin:starttimemin,
			enddate:endDate,
			endtimehr:endtimehr,
			endtimemin:endtimemin,
			},
		success: function(result) { 
			
			//clearMovingMarkers();
			//clearMarkers();
		 	
	 	 	datalist = [];
			infolist = [];
			distanceList = [];
			dataAndInfoList = JSON.parse(result);
			
		 	var totaldatalist = dataAndInfoList["vehiclesTrackingRoot"][0].datalist;
			for(var i=0;i<totaldatalist.length;i++){
			 	datalist.push(totaldatalist[i]);
			 }
             var totalinfolist = dataAndInfoList["vehiclesTrackingRoot"][1].infolist;
             for(var i=0;i<totalinfolist.length;i++){
			 	infolist.push(totalinfolist[i]);
			 }
             var totaldistanceList = dataAndInfoList["vehiclesTrackingRoot"][2].distanceList;
             for(var i=0;i<totaldistanceList.length;i++){
			 	distanceList.push(totaldistanceList[i]);
			 }
            if(datalist.length > 0){
                clearMap();
             	plotHistoryToMap();
             	plotHubs();
             	
            }else{
            	Ext.example.msg("No Record Found");
            }
		} 
	});
	
	function plotHubs(){
	for(var i=0; i<store.getCount(); i++){
		var record=store.getAt(i);
							var vehicleNo = '<%=vehicleNo%>';
							var latitude = record.data['hubLAT'];
							var longitude = record.data['hubLONG'];
							var location = record.data['nameIndex'];
							var gps = record.data['actualTimeIndex'];
							var status = record.data['tripstatus'];
							shipmentStatus = record.data['shipmentStatusIndex'];
							var category = record.data['categoryIndex'];
							var shipmentId = '<%=shipmentId%>';
							var routeId = '<%=routeId%>';
							var transittimeId =  store.getAt(store.getCount()-1).data['transitIndex'];
							var truckTypeId =  record.data['truckTypeIndex'];
							var modeId =  record.data['modeIndex'];
							plotHubsmarker(vehicleNo,latitude,longitude,location,gps,status,category,shipmentId,routeId,transittimeId,truckTypeId,modeId);
							//document.getElementById("tracePath").hidden=false;
							}
							
							function plotHubsmarker(vehicleNo,latitude,longitude,location,gps,status,category,shipmentId,routeId,transittimeId,truckTypeId,modeId){
		
			if(i==0){
		    	imageurl='/ApplicationImages/VehicleImages/red.png';
		    }
		    else if(i==(store.getCount()-1)){
		    	imageurl='/ApplicationImages/VehicleImages/green.png';
		    }else{
		    	imageurl='/ApplicationImages/VehicleImages/yellow.png';
		    } 
			image = {
	        	url:imageurl,
	        	scaledSize:  new google.maps.Size(24, 35),
	        	origin: new google.maps.Point(0, 0),
	        	anchor: new google.maps.Point(0, 32)
	   		};
			var pos= new google.maps.LatLng(latitude,longitude);
	   		var marker = new google.maps.Marker({
	        	position: pos,
	        	id:vehicleNo,
	        	map: map,
	        	icon:image
	   		}); 
	   		var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">'+
				'<table>'+
				'<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>'+vehicleNo+'</td></tr>'+				
				'<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>'+location+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>'+gps+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Shipment Id:</b></div></span></td><td>'+shipmentId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Route Id:</b></div></span></td><td>'+routeId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Transit Time:</b></div></span></td><td>'+transittimeId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Truck Type :</b></div></span></td><td>'+truckTypeId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Mode:</b></div></span></td><td>'+modeId+'</td></tr>'+
				'</table>'+
				'</div>';
			var infowindow = new google.maps.InfoWindow({
	      		content: content,
	      		marker:marker,
	      		maxWidth: 300,
	      		image:image
	  		 });
	  		//infowindow.setContent(content);
	      //  infowindow.open(map,marker); 
	       google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){   			
  				return function() {
    				closeInfowindow(); 
    				infowindow.setContent(content);
        			infowindow.open(map,marker);  
        			infoWindows[0] = infowindow;    
        			
    			};
			})(marker,content,infowindow));      		
			//marker.setAnimation(google.maps.Animation.DROP);  
			//lineInfo[0] =   marker;     		
	  	}
	}
	
	function plotHistoryToMap(){
	var lon = 0.0;
    var lat = 0.0;
	var latlng ;
	var mkrCtr=0;
	var k = 0;
	var lineSymbol = {
        	path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
        	scale: 2,
        	fillColor: '#006400',
        	fillOpacity: 1.0
    	};
	
	 vehicleNo = '<%=vehicleNo%>';
						
							var shipmentId = '<%=shipmentId%>';
     
     if(datalist != null){
     
                    lat = datalist[0];
		            lon = datalist[1];
		            centerMap = new google.maps.LatLng(lat,lon);
		           
			     //var mapProp = {
			 // center:centerMap,
			 // zoom:4,
			 // mapTypeId:google.maps.MapTypeId.ROADMAP
			  //};
			  
			//map=new google.maps.Map(document.getElementById("map"),mapProp);

 poly = new google.maps.Polyline({
          strokeColor: '#006400',
          strokeOpacity: 1.0,
          strokeWeight: 4,
           icons: [{
	            icon: lineSymbol,
	            offset: '100%',
	            repeat: '100px'
	        }],
        });
        poly.setMap(map);
        
         	for(var i=0;i<datalist.length;i++){
         	
         		if(datalist[i] != null && datalist[i+1] != null && datalist[i+2] != null)
          		{
	                lat = datalist[i];
		            lon = datalist[i+1];
		            if(i==0){ 	//start flag
						imageurl= '/ApplicationImages/VehicleImages/redcirclemarker.png';
						image = {
	        	url:imageurl,
	        	scaledSize:  new google.maps.Size(25, 25),
	        	origin: new google.maps.Point(0, 0),
	        	anchor: new google.maps.Point(0, 32)
	   		              };
            		}
            		else if(i==datalist.length-3){ 	//stop flag  
            		    lastlat = new google.maps.LatLng(lat,lon);
            			imageurl='/ApplicationImages/VehicleImagesNew/MapImages/Aggregate_BG.png';
            			image = {
	        	url:imageurl,
	        	scaledSize:  new google.maps.Size(25, 35),
	        	origin: new google.maps.Point(0, 0),
	        	anchor: new google.maps.Point(0, 32)
	   		}; 
            		}//----------------------------
            		
           			//---------------------------------
           			var date = convert(infolist[k]);
	             	var loc = infolist[k+3];
	             	var loctn="";
	             	if(loc != null && loc != "" && loc != undefined){
	             		loctn = loc.replace(/\'/g, "");
	             	}
	             	var speed = infolist[k+4];
	          		k = k + 6;

         //addLatLng(); 
         var path = poly.getPath();
 latlng = new google.maps.LatLng(lat, lon);
       
        path.push(latlng);
       if((i==datalist.length-3) || (i==0)){ 
  
 var marker = new google.maps.Marker({
            position: latlng,
            map: map,
            icon: image
         });
         
       var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">'+
				'<table>'+
				'<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>'+vehicleNo+'</td></tr>'+				
				'<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>'+loc+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>'+date+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>'+speed+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Shipment Id:</b></div></span></td><td>'+shipmentId+'</td></tr>'+
				'</table>'+
				'</div>';
			var infowindow = new google.maps.InfoWindow({
	      		content: content,
	      		marker:marker,
	      		maxWidth: 300,
	      		image:image
	  		 });
	  		google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){   			
  				return function() {
  				closeInfowindow(); 
    				infowindow.setContent(content);
        			infowindow.open(map,marker);  
        			infoWindows[0] = infowindow;      			        			
    			};
			})(marker,content,infowindow));
			}
        animatePolylines();
        animate = "true";

  //___________________________________________________________________
 
			
        //___________________________________________________________________
		            i+=2;
		            
                     }
		            }
		            }
		         var bounds = new google.maps.LatLngBounds();
		            bounds.extend(centerMap);
		            bounds.extend(lastlat);
		            map.fitBounds(bounds); 	
		                console.log(centerMap+'----'+lastlat)
		                $("#mp-container").unmask();
	}
	}
	
	   }
	   
	    function animatePolylines() {	
		var count = 0;
		window.setInterval(function () {
		count = (count + 1) % 200;
		var icons = polyline.get('icons');		
		icons[0].offset = (count / 2) + '%';
		polyline.set('icons', icons);
		}, 900);
	 } 
	   
	       function convert(time){
    	var date = "";
        if(time != null && time != "" && time != undefined){
	     	date = time.replace(/\'/g, "");
	     	return date;
	     }else{
	     	return date;
	     }
	 }
	   
	   var issueCombo = new Ext.form.ComboBox({ 	
	   		cls:'selectstylePerfect',
	   		allowBlank: false,
	   		mode: 'local',
	   		forceSelection: true,
	   		triggerAction: 'all',
	   		anyMatch: true,
	        onTypeAhead: true,
	        selectOnFocus: true,
	   		store:issuescombostore,
	   		valueField:'value',
	   		displayField:'value',
	   		id:'issuestatusId',
	   		listeners:{
	   			select: {
		            fn: function () {
		            	
		            }
		        }
	   		}	    		
	   });
		var reader = new Ext.data.JsonReader({
	      idProperty: 'TransitPointForTripId',
	      root: 'TransitPointForTripRoot',
	      totalProperty: 'total',
	      fields: [{
	          		name: 'SLNOIndex'
	      		},{
					name:'IdIndex'
				},{
					name:'nameIndex'
				},{
					name:'hubIdIndex'
				},{
					name:'tripIdIndex'
				},{
					name:'plannedTimeIndex'
				},{
					name:'revisedTimeIndex'
				},{
					name:'actualTimeIndex'
				},{
					name:'sequenceIndex'
				},{
					name:'minsdiffIndex'
				},{
					name:'remarksIndex'
				},{
					name:'actionStatusIndex'
				},{
					name:'issuesType'
				},{
					name:'tripstatus'
				},{
					name:'shipmentStatusIndex'
				},{
					name:'latitudeIndex'
				},{
					name:'longitudeIndex'
				},{
					name:'gpsDateTimeIndex'
				},{
					name:'locationIndex'
				},{
					name:'categoryIndex'
				},{
					name:'speedIndex'
				},{
					name:'pointStatusIndex'
				},{
					name:'transitIndex'
				},{
					name:'truckTypeIndex'
				},{
					name:'modeIndex'
				},{
					name:'startDate'
				},{
					name:'endDate'
				},{
					name:'hubLAT'
				},{
					name:'hubLONG'
				}]
	    });
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
					type:'numeric',
					dataIndex:'IdIndex'
				},{
					type:'string',
					dataIndex:'nameIndex'
				},{
					type:'numeric',
					dataIndex:'hubIdIndex'
				},{
					type:'numeric',
					dataIndex:'tripIdIndex'
				},{
					type:'string',
					dataIndex:'plannedTimeIndex'
				},{
					type:'string',
					dataIndex:'revisedTimeIndex'
				},{
					type:'string',
					dataIndex:'actualTimeIndex'
				},{
					type:'numeric',
					dataIndex:'sequenceIndex'
				},{
					type:'numeric',
					dataIndex:'minsdiffIndex'
				},{
					type:'string',
					dataIndex:'remarksIndex'
				},{
					type:'string',
					dataIndex:'actionStatusIndex'
				},{
					type:'string',
					dataIndex:'issuesType'
				},{
					type:'string',
					dataIndex:'tripstatus'
				},{
					type:'string',
					dataIndex:'shipmentStatusIndex'
				},{
					type:'string',
					dataIndex:'latitudeIndex'
				},{
					type:'string',
					dataIndex:'longitudeIndex'
				},{
					type:'string',
					dataIndex:'gpsDateTimeIndex'
				},{
					type:'string',
					dataIndex:'locationIndex'
				},{
					type:'string',
					dataIndex:'pointStatusIndex'
				}]
    });
    
    var colModel = new Ext.grid.ColumnModel({
	    columns :[
	     	new Ext.grid.RowNumberer({
	            header : "<span style=font-weight:bold;><%=SLNO%></span>",
	            width : 50,
	            hidden:false,
	            filter:{type: 'numeric'}
	        	}),{
				header: "<span style=font-weight:bold;><%=SLNO%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'SLNOIndex'
				},{
				header: "<span style=font-weight:bold;><%=ID%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'IdIndex'
				},{
				header: "<span style=font-weight:bold;><%=PointStatus%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'pointStatusIndex',
				renderer: function(value, metaData, record, rowIndex, colIndex, store) {
		                var fieldName = grid.getColumnModel().getDataIndex(colIndex);
						status = record.get(fieldName);
                        return status;
	                }
				},{
				header: "<span style=font-weight:bold;><%=Location%></span>",
				sortable: true,
				width:250,
				dataIndex:'nameIndex'
				},{
				header: "<span style=font-weight:bold;><%=HubId%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'hubIdIndex'
				},{
				header: "<span style=font-weight:bold;><%=TripId%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'tripIdIndex'
				},{
				header: "<span style=font-weight:bold;><%=PlannedTime%></span>",
				sortable: true,
				width:125,
				dataIndex:'plannedTimeIndex'
				},{
				header: "<span style=font-weight:bold;>Revised ETA</span>",
				sortable: true,
				width:125,
				dataIndex:'revisedTimeIndex'
				},{
				header: "<span style=font-weight:bold;><%=ActualTime%></span>",
				sortable: true,
				width:125,
				dataIndex:'actualTimeIndex'
				},{
				header: "<span style=font-weight:bold;><%=Sequence%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'sequenceIndex'
				},{
				header: "<span style=font-weight:bold;><%=Notification%></span>",
				sortable: true,
				hidden:false,
				width:120,
				dataIndex:'minsdiffIndex',
				renderer: function(value, metaData, record, rowIndex, colIndex, store) {
		                var fieldName = grid.getColumnModel().getDataIndex(colIndex);
						var hours = record.get(fieldName);
						if(status == 'DELAYED'){
						if(hours != 0 && hours>0){
							if(hours>=6){
								metaData.attr = 'style="background-color:red;"';
								return '6 Hours and More';
							}else if(4<= hours && hours <6){
								metaData.attr = 'style="background-color:orange;"';
								return '>4<6 Hours Delay';
							}else if(2<= hours && hours <4){
								metaData.attr = 'style="background-color:yellow;"';
								return '>2<4 Hour Delay';
							}else if(1<= hours && hours <2){
								metaData.attr = 'style="background-color:grey;"';
								return '>1<2 Hour Delay';
							}
						}
					  }
	                }
				},{
				header: "<span style=font-weight:bold;><%=Issue%></span>",
				sortable: true,
				hidden:false,
				dataIndex:'issuesType'
				},{
				header: "<span style=font-weight:bold;><%=Remarks%></span>",
				sortable: true,
				hidden:false,
				dataIndex:'remarksIndex'
				},{
				header: "<span style=font-weight:bold;><%=ActionStatus%></span>",
				sortable: true,
				hidden:false,
				dataIndex:'actionStatusIndex'
				},{
				header: "<span style=font-weight:bold;><%=TripStatus%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'tripstatus'
				},{
				header: "<span style=font-weight:bold;><%=ShipmentStatus%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'shipmentStatusIndex'
				},{
				header: "<span style=font-weight:bold;><%=Latitude%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'latitudeIndex'
				},{
				header: "<span style=font-weight:bold;><%=Longitude%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'longitudeIndex'
				},{
				header: "<span style=font-weight:bold;><%=GPS%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'gpsDateTimeIndex'
				},{
				header: "<span style=font-weight:bold;><%=Location%></span>",
				sortable: true,
				hidden:true,
				dataIndex:'locationIndex'
				}]
			});
	   
	var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,	
		autoScroll:true,
		frame:true,
		height:200,
		id:'transitpointId',
		layout:'table',
		layoutConfig: {columns:2},
		items: [{
				xtype:'fieldset', 
				title:'Action',
				cls:'fieldsetpanel',
				collapsible: false,
				colspan:3,
				id:'custpanelid',
				layout:'table',
				layoutConfig: {
					columns:3,
					tableAttrs: {
						style: {width: '70%'}
					  }
				},
				items:[{
	            	xtype:'label',
	            	text:'*',
	            	cls:'mandatoryfield',
	            	id:'mandatoryissue'
	            	},{
					xtype: 'label',
					cls:'labelstyle',
					id:'issuelab',
					text: '<%=Issue%> :'
					},issueCombo,{
	            	xtype:'label',
	            	text:'*',
	            	cls:'mandatoryfield',
	            	id:'mandatoryremarks'
	            	},{
					xtype: 'label',
					cls:'labelstyle',
					id:'remarklab',
					text: '<%=Remarks%> :'
					},{
					xtype:'textarea',
		    		allowBlank: false,
		    		cls:'textareainlinestyle',
		    		id:'RemarkId',
		    		autoCreate:{tag: "textarea",autocomplete: "off",maxlength:500},
					selectOnFocus: true,
					enableKeyEvents:true 
					},{
	            	xtype:'label',
	            	text:'*',
	            	cls:'mandatoryfield',
	            	id:'mandatorystatus'
	            	},{
					xtype: 'label',
					cls:'labelstyle',
					id:'statuslab',
					text: '<%=Status%> :'
					},statusCombo]
		    	}]
	   });
	var winButtonPanel=new Ext.Panel({
        	id: 'winbuttonid',
        	standardSubmit: true,			
			cls:'windowbuttonpanel',
			frame:true,
			height:20,
			width:480,
			layout:'table',
			layoutConfig: {
				columns:2
			},
			buttons:[{
       			xtype:'button',
      			text:'save',
        		id:'addButtId',
        		iconCls:'savebutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function(){
       						var selected = grid.getSelectionModel().getSelected();
			                var Id = selected.get('IdIndex');	
			                var tripid = selected.get('tripIdIndex');	
			                if (Ext.getCmp('issuestatusId').getValue() == "") {
		                        Ext.example.msg("Enter Issue Type");
		                        Ext.getCmp('issuestatusId').focus();
		                        return;
		                    }	                
			                if (Ext.getCmp('RemarkId').getValue() == "") {
		                        Ext.example.msg("Enter Remarks");
		                        Ext.getCmp('RemarkId').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('actionstatusId').getValue() == "") {
		                        Ext.example.msg("Enter Status");
		                        Ext.getCmp('actionstatusId').focus();
		                        return;
		                    }
		                    if(innerPanel.getForm().isValid()){
		                    	 
       							Ext.Ajax.request({
		                            url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=insertRemarks',
		                            method: 'POST',
		                            params: {
		                            	ID:Id,
		                            	remarks:Ext.getCmp('RemarkId').getValue(),
		                            	actionStatus:Ext.getCmp('actionstatusId').getValue(),
		                            	tripid:tripid,
		                            	issues:Ext.getCmp('issuestatusId').getValue()									                           	                       
		                            },
		                            success: function (response, options) {
		                                var message = response.responseText;
		                                Ext.example.msg(message);
		                                myWin.hide();
		                                store.reload();
		                               },
		                            failure: function () {
		                                Ext.example.msg("Error");		                                
		                                myWin.hide();
		                                store.reload();
		                            }
	                        	});	                       
       						}
       					}
       				}
       			}
      		},{
       			xtype:'button',
      			text:'cancel',
        		id:'cancelButtId',
        		iconCls:'cancelbutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function()
       					{
       						myWin.hide();
       						Ext.getCmp('issuestatusId').reset();
       						Ext.getCmp('RemarkId').reset();
       						Ext.getCmp('actionstatusId').reset();
       					}
       				}
       			}
      		}]
	});
/****************************************************************************Outer panel window for form field**************************************************************************/
	var outerPanelWindow=new Ext.Panel({
		cls:'outerpanelwindow',
		standardSubmit: true,
		frame:false,
		height:250,
		items: [innerPanel, winButtonPanel]
	});
/****************************************************************************Window For Add and Edit**************************************************************************/
	myWin = new Ext.Window({
		    title: 'Action',
		    closable: false,
		    resizable: false,
		    modal: true,
		    autoScroll: true,
		    frame:true,
		    height:300,
		    id: 'myWin',
		    items: [outerPanelWindow]
	});
	var selModel=new Ext.grid.RowSelectionModel({
      singleSelect:true
	});
	var store = new Ext.data.GroupingStore({
        proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getTransitPointForTrip',
        method: 'POST'
        }),
        autoLoad: false,
        reader: reader
    });
    
       if((custId==5015 && sysId==214) || (custId==5492 && sysId==291)){
    buttonwidth = 550;
    }
    
    grid = new Ext.grid.GridPanel({                         
     height 	: 475,
     width		: 765,    
     store      : store,                                                                    
     colModel   : colModel,                                       
     sm         : selModel,
     loadMask	: true,
     border		: false,
	 plugins	: [filters],
	 listeners	: {render : function(){grid.store.on('load', function(store, records, options){});},
	 			   cellclick:{fn:getRegionId}
	 			  },
	 bbar	    : new Ext.Toolbar({items: [{xtype: 'tbspacer', width: buttonwidth}]})    
	});
	function getRegionId(grid,rowIndex,columnIndex,e){
		actionsStatus = grid.getStore().getAt(rowIndex).data['actionStatusIndex'];
		issuess = grid.getStore().getAt(rowIndex).data['minsdiffIndex'];
	}
	
	if((custId==5015 && sysId==214) || (custId==5492 && sysId==291)){ //5015 is for MIDLLEMILE and 214 is for MLLECOM
	if(true)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'TripEnd',
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		}
		
	if(true){
		grid.getBottomToolbar().add([
		'-',                             
		{
		    text:'<%=Actions%>',
		    iconCls : 'addbutton',
		    handler : function(){
		    addRecord();
			}    
		  }]);
	}	
	if(true){
		grid.getBottomToolbar().add([
		'-',                             
		{
		    text:'<%=Back%>',
		    iconCls : 'editbutton',
		    id: 'modifyId',
		    handler : function(){
		    modifyData();
			}    
		  }]);
	}    
	function addRecord(){		
		titelForInnerPanel = 'Action';
		myWin.setPosition(450,100);
		if(actionsStatus === undefined && issuess === undefined){
			Ext.example.msg("No Row Selected");
		    return;	
		}
		if(actionsStatus == 'Active'){
			myWin.show();				
		}else if(actionsStatus == 'Closed' && issuess>1){
			Ext.example.msg("Delayed Addressed");
		    return;				
		}else if(actionsStatus == 'Closed'){
			Ext.example.msg("Action Updated");
		    return;				
		}
		var selected = grid.getSelectionModel().getSelected();		
		Ext.getCmp('RemarkId').setValue(selected.get('remarksIndex'));
		Ext.getCmp('actionstatusId').setValue(selected.get('actionStatusIndex'));		
	}
	function modifyData(){
		var checkDashBoardDetails = '1';
		if('<%=dashboardFrom%>'=='new'){
		window.location ="<%=request.getContextPath()%>/Jsps/DistributionLogistics/DashboardForOpenTrips.jsp";
		}else if('<%=flag%>'=='MRDASHBOARD'){
		window.location ="<%=request.getContextPath()%>/Jsps/DistributionLogistics/MLLDashboard.jsp";
		}else{
		window.location ="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/MonitoringDashboard.jsp?fromdateformonitoringpage="+'<%=fromdatefordetailspage%>'+"&todateformonitoringpage="+'<%=todatefordetailspage%>'+"&typeformonitoringpage="+'<%=typefordetailspage%>'+"&fromlocationformonitoringpage="+'<%=fromlocationfordetailspage%>'+"&fromlocationIdformonitoringpage="+'<%=fromlocationIdfordetailspage%>'+"&tolocationformonitoringpage="+'<%=tolocationfordetailspage%>'+"&tolocationIdformonitoringpage="+'<%=tolocationIdfordetailspage%>'+"&checkDashBoardDetails="+checkDashBoardDetails+"&shipmentStatus="+shipmentStatus;
		}
	}
	
	  function closetripsummary() {
	  	var rec=store.getAt(0);
	    if(rec.data['tripstatus']=='Closed'){
	    Ext.example.msg("Trip Already Closed");
	    return;
	    }
	  
      Ext.Msg.show({
          title: 'Confirmation For Ending The Trip..',
          msg: 'You are about to end the trip in middle are you sure?',
          buttons: Ext.Msg.YESNO,
          fn: function(btn) {  
              if (btn == 'no') {          
                  return;
              }
              if (btn == 'yes') {                        
                   {
                  var 	selected = grid.getStore().getAt(1);
                  var tripId= selected.get('tripIdIndex');               
                  var shipmentId = '<%=shipmentId%>';
                      Ext.Ajax.request({
		                            url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getCloseTrip',
		                            method: 'POST',
		                            params: {
		                            		shipmentId:shipmentId,
		                            		tripId:tripId,
		                            		vehicleNo :'<%=vehicleNo%>'
		                            },
		                            success: function (response, options) {
		                                var message = response.responseText;
		                                Ext.example.msg(message);
		                                myWin.hide();
		                                store.reload();
		                               },
		                            failure: function () {
		                                Ext.example.msg("Error");		                                
		                                myWin.hide();
		                                store.reload();
		                            }
	                        	});	
                  }
              }
          }
      });
  }
	
	Ext.onReady(function () {
  		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
		        title: '',		        
		        standardSubmit: true,
		        width: 770,
		        height:480,
		        renderTo: 'grid-panel',
		        cls: 'outerpanel',
		        layout: 'table',
		        layoutConfig: {
		            columns: 1
		        },
		        items: [grid]
		    });
        store.load({
        params:{vehicleNo:'<%=vehicleNo%>',shipmentId:'<%=shipmentId%>'},
        callback:function(){
		            if(store.getCount()>0){
							var record=store.getAt(0);
							var vehicleNo = '<%=vehicleNo%>';
							var latitude = record.data['latitudeIndex'];
							var longitude = record.data['longitudeIndex'];
							var location = record.data['locationIndex'];
							var gps = record.data['gpsDateTimeIndex'];
							var status = record.data['tripstatus'];
							shipmentStatus = record.data['shipmentStatusIndex'];
							var category = record.data['categoryIndex'];
							var speed = record.data['speedIndex'];
							var shipmentId = '<%=shipmentId%>';
							var routeId = '<%=routeId%>';
							var transittimeId =  store.getAt(store.getCount()-1).data['transitIndex'];
							var truckTypeId =  record.data['truckTypeIndex'];
							var modeId =  record.data['modeIndex'];
							plotmarker(vehicleNo,latitude,longitude,location,gps,status,category,speed,shipmentId,routeId,transittimeId,truckTypeId,modeId);
							document.getElementById("tracePath").hidden=false;
		            }
				}
        	});        
		});
	function plotmarker(vehicleNo,latitude,longitude,location,gps,status,category,speed,shipmentId,routeId,transittimeId,truckTypeId,modeId){
		if(status == 'Closed'){				
			Ext.example.msg("Current vehicle location not available for the shipment delivered");
		    return;
		}else{
			if(category =='stoppage'){
		    	imageurl='/ApplicationImages/VehicleImages/red.png';
		    }
		    else if(category =='idle'){
		    	imageurl='/ApplicationImages/VehicleImages/yellow.png';
		    }else{
		    	imageurl='/ApplicationImages/VehicleImages/green.png';
		    } 
			image = {
	        	url:imageurl,
	        	scaledSize:  new google.maps.Size(19, 35),
	        	origin: new google.maps.Point(0, 0),
	        	anchor: new google.maps.Point(0, 32)
	   		};
			var pos= new google.maps.LatLng(latitude,longitude);
	   		var marker = new google.maps.Marker({
	        	position: pos,
	        	id:vehicleNo,
	        	map: map,
	        	icon:image
	   		}); 
	   		var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">'+
				'<table>'+
				'<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>'+vehicleNo+'</td></tr>'+				
				'<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>'+location+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>'+gps+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>'+speed+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Shipment Id:</b></div></span></td><td>'+shipmentId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Route Id:</b></div></span></td><td>'+routeId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Transit Time:</b></div></span></td><td>'+transittimeId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Truck Type :</b></div></span></td><td>'+truckTypeId+'</td></tr>'+
				'<tr><td><div style="width: 70px;"><span><b>Mode:</b></div></span></td><td>'+modeId+'</td></tr>'+
				'</table>'+
				'</div>';
			var infowindow = new google.maps.InfoWindow({
	      		content: content,
	      		marker:marker,
	      		maxWidth: 300,
	      		image:image,
	      		id:vehicleNo
	  		 });
	  		infowindow.setContent(content);
	        infowindow.open(map,marker); 
	       google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){   			
  				return function() {
    				infowindow.setContent(content);
        			infowindow.open(map,marker);
        			
    			};
			})(marker,content,infowindow));      		
			marker.setAnimation(google.maps.Animation.DROP);  
			lineInfo[0] =   marker;     		
	      	var bounds = new google.maps.LatLngBounds(new google.maps.LatLng(latitude,longitude));
			map.fitBounds(bounds);
			var listener = google.maps.event.addListener(map, "idle", function() { 
	     			map.setZoom(10);
	     			if (map.getZoom() > 16) map.setZoom(mapZoom);
					google.maps.event.removeListener(listener); 
			});
	  	}
	}
   </script>
  </body>
</html>
