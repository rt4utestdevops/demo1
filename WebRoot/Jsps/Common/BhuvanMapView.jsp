
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.functions.MapViewFunctions" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	LiveVisionColumns liveVisionColumns=new LiveVisionColumns();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
 	String detailsID="";
 	int processID=0;
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	String systemID = Integer.toString(systemid);
 	int customeridlogged = loginInfo.getCustomerId();
 	String CustName = loginInfo.getCustomerName();
 	String customernamelogged = "null";
 	String vehicleTypeRequest = "all";
 	if(request.getParameter("processId")!=null)
 	{
 	processID=Integer.parseInt((String)request.getParameter("processId")); 	 	
 	}
 	if (request.getParameter("vehicleType") != null) {
     vehicleTypeRequest = request.getParameter("vehicleType");
 	}
 	if (customeridlogged > 0) {
 		customernamelogged = loginInfo.getCustomerName();
 	}
 	int userId = loginInfo.getUserId();
 	Properties properties = ApplicationListener.prop;
 	String latLongArray[] = null;
 	double latCenter = 0;
 	double longCenter = 0;
 	MapViewFunctions mf = new MapViewFunctions();
    String latLongForCenter = mf.getLatLongForCenter(systemid);
    if(!latLongForCenter.equals(""))
    {
    	latLongArray = latLongForCenter.split(",");
    	latCenter = Double.parseDouble(latLongArray[0]);
    	longCenter = Double.parseDouble(latLongArray[1]);
    }
    String mapTypeFromOpen = "";
    if (request.getParameter("mapType") != null) {
     mapTypeFromOpen = request.getParameter("mapType");
 	}
 	//String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("SLNO");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Last_Communicated_Location");
tobeConverted.add("Last_Communicated_Date_Time");
tobeConverted.add("NonCommunicating_Hours");
tobeConverted.add("No_of_Satellites");
tobeConverted.add("Invalid_Packet");
tobeConverted.add("Main_Power");
tobeConverted.add("Main_Power_Off_Location");
tobeConverted.add("Main_Power_Off_DateTime");
tobeConverted.add("Battery_Voltage");
tobeConverted.add("Battery_Health");
tobeConverted.add("Device_Non_Communicating_CheckList");
tobeConverted.add("Sim_Card_Installed_In_Device_May_Not_Be_Working");
tobeConverted.add("Device_May_Be_Tampered");
tobeConverted.add("Vehicle_May_Be_Out_of_Network_Coverage_Area");
tobeConverted.add("Device_Wire_May_Be_Loosley_Connected");
tobeConverted.add("Device_Health");
tobeConverted.add("Refresh");
tobeConverted.add("Show_Hubs");
tobeConverted.add("Show_Details");
tobeConverted.add("Stopped");
tobeConverted.add("Running");
tobeConverted.add("Idle");
tobeConverted.add("Select_All");
tobeConverted.add("DashBoardMap");
tobeConverted.add("Create_Landmark");
tobeConverted.add("Show_Border");
tobeConverted.add("Group_Name");
tobeConverted.add("Location");
tobeConverted.add("Date_Time");
tobeConverted.add("Packet_Type");
tobeConverted.add("Speed");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SLNO=convertedWords.get(0);
String vehicleNo=convertedWords.get(1);
String lastCommunicatedLocation=convertedWords.get(2);
String lastCommunicatedDateTime=convertedWords.get(3);
String nonCommunicatingHours=convertedWords.get(4);
String noOfSatellites=convertedWords.get(5);
String invalidPacket=convertedWords.get(6);
String mainPower=convertedWords.get(7);
String mainPowerOffLocation=convertedWords.get(8);
String mainPowerOffDateTime=convertedWords.get(9);
String batteryVoltage=convertedWords.get(10);
String batteryHealth=convertedWords.get(11);
String deviceNonCommunicatingCheckList=convertedWords.get(12);
String simCardInstalledInDeviceMayNotBeWorking=convertedWords.get(13);
String deviceMayBeTampered=convertedWords.get(14);
String vehicleMayBeOutofNetworkCoverageArea=convertedWords.get(15);
String deviceWireMayBeLoosleyConnected=convertedWords.get(16);
String deviceHealth=convertedWords.get(17);
String refresh=convertedWords.get(18);
String showHubs=convertedWords.get(19);
String showDetails=convertedWords.get(20);
String stopped=convertedWords.get(21);
String running=convertedWords.get(22);
String idle=convertedWords.get(23);
String selectAll=convertedWords.get(24);
String dashBoardMap=convertedWords.get(25);
String createlandmark = convertedWords.get(26);
String showBorder = convertedWords.get(27);
String groupName=convertedWords.get(28);
String location=convertedWords.get(29);
String dateTime=convertedWords.get(30);
String packetType=convertedWords.get(31);
String speed=convertedWords.get(32);
 %>
<!DOCTYPE html>
<html>
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
     
    <title>Map</title> 
  <head>
     <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/mapView/css/Component2.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/mapView/css/layout.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/theme/css/EXTJSExtn.css" /> 
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
    <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
     <pack:script src="../../Main/Js/examples1.js"></pack:script>
     <pack:style src="../../Main/resources/css/examples1.css" />
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
	<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>	
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/common.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ol3/3.7.0/ol.css" type="text/css">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/ol3/3.7.0/ol.js"></script>
	<style>	
	  body {
		background-color: #FFFFFF;
	   }  
	   
	   .x-grid3-cell-inner{
      font-size:11px;
      }     
      
      .x-grid3-hd-checker {
	visibility: hidden;
  }
    .openLayerButton {
        margin-top: -407px;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
 .mp-map-wrapper1 {
		width: 99.5%;
		height: 420px;
		position: absolute;
	}
	.infoWindowOpen
	{
		overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;
	}
	.mp-vehicle-details-wrapper1 {
		
		width: 23.5%;
		height: 600px;
		float: right;
		border: 5px solid #fff;
		background-color: #ffffff;
		overflow: auto;
		overflow-x: hidden;
		position: absolute;
		left: 77.5%;
		-moz-box-shadow: 1px 1px 3px #cac4ab;
		-webkit-box-shadow: 1px 1px 3px #cac4ab;
		box-shadow: 1px 1px 3px #cac4ab;
		z-index: 1;
		display:none;
	}
	.tooltip {
  position: relative;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 4px;
  color: white;
  padding: 4px 8px;
  opacity: 0.7;
  white-space: nowrap;
}
.tooltip-measure {
  opacity: 1;
  font-weight: bold;
}
.tooltip-static {
  background-color: #ffcc33;
  color: black;
  border: 1px solid white;
}
.tooltip-measure:before,
.tooltip-static:before {
  border-top: 6px solid rgba(0, 0, 0, 0.5);
  border-right: 6px solid transparent;
  border-left: 6px solid transparent;
  content: "";
  position: absolute;
  bottom: -6px;
  margin-left: -7px;
  left: 50%;
}
.tooltip-static:before {
  border-top-color: #ffcc33;
}
.openLayerButton {
        margin-top: -407px;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
@media screen and (device-width:1920px) {
			.openLayerButton {
        margin-top: -553px !important;;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
		}
		@media (device-width: 1280px) and (device-height: 720px) {
			.openLayerButton {
         margin-top: -553px !important;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
 
		}
		@media screen and (device-width: 1600px) {
			.openLayerButton {
        margin-top: -553px !important;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
		}
		@media screen and (device-width:1440px) {
			.openLayerButton {
         margin-top: -553px !important;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
		}
		@media (device-width: 1280px) and (device-height: 800px) {
			.openLayerButton {
         margin-top: -453px!important;
        border: 1px solid transparent;
        border-radius: 2px 2px 2px 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 29px;
        outline: none;
        float: left;
        margin-left: 103px;
        background-color : white;
        fontsize:12;
 }
		}
		
	</style>
	</head>
	<link rel="stylesheet" href="../../Main/OpenLayer3/css/ol.css" type="text/css">
    <script src="../../Main/OpenLayer3/build/ol.js"></script>
    <script src="../../Main/ol3-popup-master/src/ol3-popup.js"></script>
    <link rel="stylesheet" href="../../Main/ol3-popup-master/src/ol3-popup.css" type="text/css">
    <body background-color="white">
	 <div class="container">
		 <div class = "main">
		 	<div class="mapview-asset-commstatus" id="mapview-asset-commstatus-id">
			<div id="mapview-commstatus-dashboard-id" class="map-view-noncommststus-dashboard">
			     <div id="mapview-commstatus-leftdashboard-id" class="map-view-noncommststus-leftdashboard"> 
			        <form class="me-commselect">
					<ul id="me-select-list" class="map-view-comm-details">
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=vehicleNo%></span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="assetno-id"></p></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=lastCommunicatedLocation%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="lastlocation-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=lastCommunicatedDateTime%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="lastgmt-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=nonCommunicatingHours%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="noncommhours-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=noOfSatellites%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="staellite-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=invalidPacket%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="invalidpacket-id"></span></li>
					</ul>	
					</form>	
			     </div>
				 <div id="mapview-commstatus-rightdashboard-id" class="map-view-noncommststus-rightdashboard"> 
				 	<form class="me-commselect">
					<ul id="me-select-list" class="map-view-comm-details">
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=mainPower%></span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="mainpower-id"></p></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=mainPowerOffLocation%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="mainpowerlocation-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=mainPowerOffDateTime%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="mainpowergmt-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=batteryHealth%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="batteryhealth-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header"><%=batteryVoltage%></span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="batteryvoltage-id"></span></li>
					</ul>	
					</form>	
				 </div>
			</div>
			<div id="mapview-commstatus-id" class="map-view-noncommststus-grid"></div>
			<div id="mapview-commstatus-desc" class="map-view-noncommststus-desc">
			        <form class="me-commselect">
					  <ul id="me-select-list" class="map-view-comm-details">
					  		<li class="me-select-commlabel"><span class="vehicle-details-block-header"> <%=deviceNonCommunicatingCheckList%></span></li>
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">1)<%=simCardInstalledInDeviceMayNotBeWorking %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) <%=deviceMayBeTampered%></span></li>
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">3)<%=vehicleMayBeOutofNetworkCoverageArea%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4) <%=deviceWireMayBeLoosleyConnected%></span></li>
					  </ul>	
					</form>	
			</div>
			<button type="button" id="ackw-button2-id" class="ack-button2" onclick="commstatusScreen()"><%=dashBoardMap%></button>	
			</div>
			<div class="mp-vehicle-wrapper" id="vehicle-list"></div>
			<div class="mp-vehicle-details-wrapper1" id="vehicle-details">
			<form class="me-select">
				<ul id="me-select-list">
				<%=liveVisionColumns.getVehicleDetails(processID,language).toString()%>
				</ul>
				<div class='map-view-botton-pannel-div'>		
					<button type="button" id="ackw-button-id" class="ack-button" onclick="commstatusScreen()"><%=deviceHealth%></button>		
				</div>
			 </form>						
			</div>
				<div class="mp-container" id="mp-container">
					<div id="grid">
			        <div class="mp-map-wrapper" id="map"> </div>
			         <div class="infoWindowOpen" id="popup"> </div>
					<div class="mp-options-wrapper"/>	
  					<select class="openLayerButton" id="maptype" onchange="googleMap();">
  					
  					<%if(mapTypeFromOpen.equals("BhuvanCusMap")){%>  
	        		<option value="BhuvanCusMap">Bhuvan Map</option>
  					<option value="SatMap">Satellite Google Map</option>
  					<option value="StreetMap">Street Google Map</option>
  					<>
	        		<%}%>  
					</select>	
					<table width="98%">
						<tr height="10px"><td > <div class="mp-option-showhub" id="show"></div></td>
						<td>
								<div>
							<img class="ruler" id ="startRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerStart.gif" title="Start Ruler" onclick="startRuler()"/>							
								</div>
							</td>
							<td>
								<div>
							<img  class="ruler" id ="removeRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerEnd.gif" title="Remove Ruler" onclick="removeRuler()"/>							
								</div>
							</td>
							<td>
								<div>
							<img class="refreshImage" src="/ApplicationImages/ApplicationButtonIcons/Refresh.png" onclick="refreshVehicle()" title="Refresh"/>							
								</div>
							</td>
							<td width="18%"><div style="padding-left:13px">
								<input type="checkbox" id="c1" name="cc" onclick='showHub(this);'/>
            					<label for="c1"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showHubs%></span>
            				</div></td>
            				<td width="18%"><div style="padding-left:13px">
								<input type="checkbox" id="c3" name="cb" onclick='showBorder(this);'/>
            					<label for="c3"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showBorder%></span>
            				</div></td>
            				<td align="center"><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImages/red2.png">            				
							<span class="vehicle_marker_label" style="padding-right: 10px;"><%=stopped %></span></div></td>
							<td><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImages/green2.png">							
							<span  class="vehicle_marker_label" style="padding-right: 10px;"><%=running %></span></div></td>
							<td><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImages/yellow2.png">							
							<span class="vehicle_marker_label"style="padding-right: 10px;"><%=idle%></span></div></td>
													
						<td style="width:0px;"><div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"  onclick="mapFullScreen()"></div></td>
						</tr></table>
					</div>
					
					</div>
				</div>
			</div>
			</div>		
		<script>
		var sliderArray=[];
		var grid;
		var markers = {};
		var outerPanel;
		var infowindows= {};
		var infowindowsOne= {};
		var circles = [];
		var borderCircles=[];
		var borderCircleMarkers=[];
		var polygons =[];		
		var buffermarkers = [];
		var polygonmarkers =[];
		var latlongmarkers = [];
		var borderPolylines = [];
		var borderMarkers=[];
		var marker;
		var detailspage=0;
		var map;
		var infowindow;
		var infowindowOne;
		var jspName="Map View";
		var circle;
		var button="Map";
		var selectAll="false";
		var previousSelectedRow=-1;
		var contentOne;
		var exportDataType="int,string,date,string,string,int,float,string,string,string,string,string,string,date";
		var ctsb;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		var previousVehicleType='<%=vehicleTypeRequest%>';
		var firstLoadDetails=0;
		var mapviewFullScreen=0;	
		var refreshcount=0;	
		var selectAllCheckClicked=0;
		var customMapButton = 'false';
		var vectorLayer;
		var popup = new ol.Overlay.Popup();
		var borderLayer;
		var borderLayerArray=[];
		var popupForBuffer = new ol.Overlay.Popup();
		var popupForPolygon = new ol.Overlay.Popup();
		var bufferLayer;
		var polygonLayer;
		var bufferLayerArray=[];
		var polygonLayerArray=[];
		var selectedSingleVehicle = 'false';
		var selectedHub = 'false';
		var selectedPolygon = 'false';
		var popupOpened = 'false';
		var mapForVehicle;
		var mapForBuffer;
		var mapForPolygon;
		var processID = '<%=processID%>';
		var measureToolTipArray = [];
		var tipCount = 0;
		var sourceRuler = new ol.source.Vector();
		var vectorRuler;
		var clearSelect = 0;
		var mapForBorder;
		var mapLayer = new ol.layer.Tile();
		var mapTypeFromOpen = '<%=mapTypeFromOpen%>';
		var popupForBorder = new ol.Overlay.Popup();
		document.getElementById('option-normal').style.display = 'none';		
		document.getElementById('mapview-commstatus-dashboard-id').style.visibility = 'hidden';	
		document.getElementById('ackw-button-id').style.visibility = 'hidden';	
		document.getElementById('ackw-button2-id').style.visibility = 'hidden';
		
		function commstatusScreen()
		{
		if(detailspage==0)
		{
		previousSelectedRow = grid.store.indexOf(grid.getSelectionModel().getSelected());
		
    	$('#mp-container').slideUp('slow', function() {});
  		$('#vehicle-details').slideUp('slow', function() {});
  		document.getElementById('mapview-asset-commstatus-id').style.display='block';
  		document.getElementById('ackw-button2-id').style.visibility = 'visible';
  		document.getElementById('mapview-commstatus-dashboard-id').style.visibility = 'visible';
  		document.getElementById('ackw-button-id').style.visibility = 'hidden';
  		gridCommStatus.render('mapview-commstatus-id');	 
  		document.getElementById('SELECTALL').style.display = 'none';
  		document.getElementById('vehicle-details').style.visibility = 'hidden';
  		detailspage=1;  		
		getNonCommStatusData();
  		}
  		else
  		{
  		$('#mp-container').slideDown('slow', function() {});
  		$('#vehicle-details').slideDown('slow', function() {});
  		document.getElementById('SELECTALL').style.display = 'block';
  		document.getElementById('mapview-asset-commstatus-id').style.display='none';
  		document.getElementById('ackw-button2-id').style.visibility = 'hidden';
  		document.getElementById('mapview-commstatus-dashboard-id').style.visibility = 'hidden';	
  		document.getElementById('ackw-button-id').style.visibility = 'visible';
  		document.getElementById('vehicle-details').style.visibility = 'visible';
  		detailspage=0;
  		}
		}
		
		function googleMap(){
		
			if(document.getElementById("maptype").value == "BhuvanCusMap")
			{
					var viewForOpenLayer = new ol.View({
				       center: ol.proj.transform([<%=longCenter%>,<%=latCenter%>], 'EPSG:4326', 'EPSG:3857'),
				        zoom: 8
				    });
				  map.removeLayer(mapLayer);
			      mapLayer = new ol.layer.Tile({
         source: new ol.source.TileWMS({
                url:'https://bhuvannuis.nrsc.gov.in/bhuvan/gwc/service/wms/?',
                params: {
                    'LAYERS':'india3',
                    'PROJECTION':'EPSG:4326',
                    'VERSION':'1.0.0'
                }
            }),
            visible:true,
            zIndex:0

        }),
		new ol.layer.Tile({
            source: new ol.source.TileWMS({
                url:'https://bhuvannuis.nrsc.gov.in/bhuvan/gwc/service/wms/?',
                params: {
                    'LAYERS':'mmi:mmi_india',
                    'PROJECTION':'EPSG:4326',
                    'VERSION':'1.0.0'
                }
            }),
            visible:true,
            zIndex:2
        }),
            new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url:'https://bhuvan5.nrsc.gov.in/bhuvan/wms?',
                    params: {
                        'LAYERS':'vector:city_hq',
                        'PROJECTION':'EPSG:4326',
                        'VERSION':'1.0.0'
                    }
                }),
                zIndex:3
            });
				  map.addLayer(mapLayer);
				  loadingAfterLayerChange();
			} else if(document.getElementById("maptype").value == "SatMap")
			{
				var mapType = 'SatMap';
				var url="<%=request.getContextPath()%>/Jsps/Common/MapView.jsp?vehicleType="+previousVehicleType+"&processId="+processID+"&mapType="+mapType;
				window.parent.$('#listviewcontainer').attr('src',url);
			} else if(document.getElementById("maptype").value == "StreetMap")
			{
				var mapType = 'StreetMap';
				var url="<%=request.getContextPath()%>/Jsps/Common/MapView.jsp?vehicleType="+previousVehicleType+"&processId="+processID+"&mapType="+mapType;
				window.parent.$('#listviewcontainer').attr('src',url);
			}	
		}
		function mapFullScreen()
		{	
		if(grid.getSelectionModel().getCount()>1)
		{
		 $mpContainer.removeClass('list-container-fitscreen');
		}
		slider('close');
		popup.hide();
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
			map.updateSize();
			mapviewFullScreen=1;	
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
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container-fitscreen');		
		
		}
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		map.updateSize();	
		mapviewFullScreen=0;
		}
		
<!--		function reszieFullScreen1()-->
<!--		{-->
<!--		button="List";-->
<!--		document.getElementById('search-input').style.visibility = 'hidden';-->
<!--		document.getElementById('map').style.display = 'block';-->
<!--        document.getElementById('vehicle-details').style.display = 'block';-->
<!--        document.getElementById('vehicle-list').style.display = 'block';-->
<!--        $mpContainer.removeClass('list-container-fitscreen');-->
<!--        var defaultBounds = new google.maps.LatLngBounds(-->
<!--        new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),-->
<!--        new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));-->
<!--        map.fitBounds(defaultBounds);-->
<!--       }-->
//*****************************Multiple Vehicle Screen ******************************************************		
<!--		function multipleVehicleScreen()-->
<!--		{-->
<!--		-->
<!--        document.getElementById('option-normal').style.display = 'none';	-->
<!--        document.getElementById('vehicle-details').style.display = 'none';-->
<!--		$mpContainer.addClass('mp-container-fitscreen').css({-->
<!--						width	: 'originalWidth',-->
<!--						height	: 'originalHeight'-->
<!--					});-->
<!--		$mapEl.css({-->
<!--						width	: $mapEl.data( 'originalWidth'),-->
<!--						height	: $mapEl.data( 'originalHeight')-->
<!--					});				-->
<!--					google.maps.event.trigger(map, 'resize');-->
<!--					-->
<!--		}-->
<!--		var mapOptions = {-->
<!--	        zoom: 2,-->
<!--	        center: new google.maps.LatLng('0.0', '0.0'),-->
<!--	        mapTypeId: google.maps.MapTypeId.ROADMAP-->
<!--	    };-->

<!--	   map = new google.maps.Map(document.getElementById('map'), mapOptions);-->
<!--	   var mapZoom = 10;-->
<!--	   searchBox(map,'pac-input');-->
	   
	   var viewForOpenLayer = new ol.View({
	       center: ol.proj.transform([<%=longCenter%>,<%=latCenter%>], 'EPSG:4326', 'EPSG:3857'),
	        zoom: 5
	    });
      
	//**************** newly added for bhuvan maps********
       map = new ol.Map({
		    target: 'map',
		     <%if(mapTypeFromOpen.equals("BhuvanCusMap")){%>  
	        layers: [
		        new ol.layer.Tile({
         source: new ol.source.TileWMS({
                url:'https://bhuvannuis.nrsc.gov.in/bhuvan/gwc/service/wms/?',
                params: {
                    'LAYERS':'india3',
                    'PROJECTION':'EPSG:4326',
                    'VERSION':'1.0.0'
                }
            }),
            visible:true,
            zIndex:0

        }),
		new ol.layer.Tile({
            source: new ol.source.TileWMS({
                url:'https://bhuvannuis.nrsc.gov.in/bhuvan/gwc/service/wms/?',
                params: {
                    'LAYERS':'mmi:mmi_india',
                    'PROJECTION':'EPSG:4326',
                    'VERSION':'1.0.0'
                }
            }),
            visible:true,
            zIndex:2
        }),
            new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url:'https://bhuvan5.nrsc.gov.in/bhuvan/wms?',
                    params: {
                        'LAYERS':'vector:city_hq',
                        'PROJECTION':'EPSG:4326',
                        'VERSION':'1.0.0'
                    }
                }),
                zIndex:3
            })
		    ],   
	        <%}else if(mapTypeFromOpen.equals("MapquestCusMap")) {%>  
	       layers: [
		        new ol.layer.Tile({
		           source: new ol.source.MapQuest({layer: 'osm'})
		        })
		    ],
	        <%}%>
		    view: viewForOpenLayer
		});
		
		

//********************************* Select All ********************************************************

function selecAllVehicles(cb)
  {		
	   	if(cb.checked)
	   {
	    selectAll="true";
	   	grid.getSelectionModel().selectAll();
	   	popup = new ol.Overlay.Popup();
	   	plotMarkerForOpenLayer();
	   } else {
	    selectAll="deselect";
	   	grid.getSelectionModel().clearSelections();
	   	map.removeOverlay(popup);
        map.removeLayer(vectorLayer);
        slider('close');
        if(mapviewFullScreen==1){				
			 document.getElementById('option-fullscreen').style.display = 'none';
	      	 document.getElementById('option-normal').style.display = 'block';	
	     	 $mpContainer.removeClass('mp-container-fitscreen');
		}else{			
			 $mpContainer.addClass('mp-container-fitscreen');
		}
		map.updateSize();
		popupOpened = 'false';
	   }
   
  }	    
	    
    
      function getNonCommStatusData(){
    	setTimeout(function(){
    	var selected = grid.getSelectionModel().getSelected();
    	var name=selected.get('vehicleNo');
  		mapViewNonCommStatus.load({
  		params:{vehicleNo:name,customerID:<%=customeridlogged%>},
  		callback:function(){
    	if(mapViewNonCommStatus.getCount()>0){
								var record=mapViewNonCommStatus.getAt(0);
								document.getElementById('assetno-id').innerHTML=record.data['vehicleNo'];
								document.getElementById('lastlocation-id').innerHTML=record.data['lastCommLocation'];
								document.getElementById('lastgmt-id').innerHTML=record.data['lastCommDateTime'];
								document.getElementById('noncommhours-id').innerHTML=record.data['nonCommHours'];
								document.getElementById('mainpower-id').innerHTML=record.data['mainPower'];
								document.getElementById('invalidpacket-id').innerHTML=record.data['invalidPacket'];
								document.getElementById('batteryhealth-id').innerHTML=record.data['batteryHealth'];
								document.getElementById('batteryvoltage-id').innerHTML=record.data['batteryVoltage'];
								document.getElementById('mainpowerlocation-id').innerHTML=record.data['mainPowerOffLocation'];
								document.getElementById('mainpowergmt-id').innerHTML=record.data['mainPowerOffTime'];
								document.getElementById('staellite-id').innerHTML=record.data['noOfSatellites'];
								storeCommStatus.load({
  								params:{vehicleNo:name,
  										customerID:<%=customeridlogged%>,
  										lastcommtime:document.getElementById('lastgmt-id').innerHTML}
  		
							    });	 	   	
    	}
    	}
  		}) ,1000});	
  		}
    
    
    
    
//********************************* Remove Vehicle Marker**********************************************	    
	   function removeVehicleMarker(vehicleNo)
	    {
    	   if(previousVehicleType!='noGPS') {
	    	   if(markers[vehicleNo]!=null){
  				var marker = markers[vehicleNo];
    			marker.setMap(null);
    			marker=null;
    			}
    		}
	    }
	    function removePrevLatLongMarker()
	    {
    	   for(var i=0;i<latlongmarkers.length;i++){
           	var prelatlongmarker = latlongmarkers[i];
           	prelatlongmarker.setMap(null);
           	prelatlongmarker = null;
           } 
	    }
	    
	     
	     
//********************************* Load Vehicles********************************************************	    
	    function loadvehicles()
	    {
	        <%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
	        document.getElementById('<%=detailsID%>').innerHTML='';
			<%}%>
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
    	
	    }	    

function GRID()
{
vehicleDetailsStore.load({
params:{jspName:jspName,vehicleType:document.getElementById("vehicletype").value } });
}

//********************************** Refresh Vehicles every 5 min*****************************************************

function refreshVehicle()
{       

		var mapZoomRefresh=map.getView().getResolution();
		var center=map.getView().getCenter();
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
		    <%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
	        document.getElementById('<%=detailsID%>').innerHTML='';
			<%}%>
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
		firstLoadDetails=0;
        slider('close');
		map.removeOverlay(popup);			
	    store.load({
    	params:{vehicleType:previousVehicleType},
    	callback:function(){
			grid.getSelectionModel().selectRows(selectedIdx);
			map.removeLayer(vectorLayer);
			plotMarkerForOpenLayer();
			map.getView().setResolution(mapZoomRefresh);
			map.getView().setCenter(center);
			popup.hide();	
	 	}    	
    	});
    	  
}

function loadingAfterLayerChange()
{       
		var mapZoomRefresh=map.getView().getResolution();
		var center=map.getView().getCenter();
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
	    <%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
        document.getElementById('<%=detailsID%>').innerHTML='';
		<%}%>
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
		firstLoadDetails=0;
        slider('close');
        grid.getSelectionModel().selectRows(selectedIdx);
		map.removeLayer(vectorLayer);
		plotMarkerForOpenLayer();
		map.getView().setResolution(mapZoomRefresh);
		map.getView().setCenter(center);
		popup.hide();	
        if(document.getElementById("c1").checked)
		{
		  loadMask.show();	
   		  bufferStore.load({
   			callback:function(){
				plotBuffers();
			}
   		  });
   		  polygonStore.load({
   			callback:function(){
				plotPolygon();
				loadMask.hide();	
			  }
   		  });	
		 } 
		 if(document.getElementById("c3").checked)
		 {
		 	loadMask.show();	
    		borderStore.load({
    			callback:function(){
    			plotBorder();
    			loadMask.hide();	
	    		}
			});
		  } 
		  removeRuler();
		  if(mapviewFullScreen == 1)
		  {
		  	mapFullScreen();
		  }
}	    
//********************************** AssetDetails,Buffer & Polygon Store *********************************************	    
	    var bufferStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getBufferMapView',
				id:'BufferMapView',
				root: 'BufferMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','buffername','radius','imagename','hubId']
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
				fields: ['vehicleType','model','ownerName','status','cashin','cashout','cashbalance','vehicleNo','gmt','location','ignition','drivername','groupname','ownerNumber','drivermobile','speed','temperature']
		});
		
		var mapViewSandDetails = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getMapViewVehicleDetails',
				id:'MapViewVehicleDetails',
				root: 'MapViewVehicleDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['lastPortArrival','ownerName','ownerNo','uniqueSandId']
		});
		
		
		var mapViewNonCommStatus = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getIronMiningMapViewCommStatus',
				id:'MapViewCommStatus',
				root: 'MapViewCommStatus',
				autoLoad: false,
				remoteSort: true,
				fields: ['vehicleNo','lastCommLocation','lastCommDateTime','nonCommHours','mainPower','mainPowerOffLocation','mainPowerOffTime','invalidPacket','batteryHealth','batteryVoltage','noOfSatellites']
		});		
		
		var borderStore=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/MapView.do?param=getBorderForMapView',
			id:'borderMapView',
			root: 'borderMapView',
			autoLoad: false,
			remoteSort: true,
			fields: ['longitude','latitude','borderName','borderSequence','borderHubid','lat','long','borderRadius']
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
	    		for(var i=0;i<bufferStore.getCount();i++)
		         {	
		    		map.removeLayer(bufferLayerArray[i]);
		    	 }
	    		for(var i=0;i<polygonStore.getCount();i++)
		         {	
		    		map.removeLayer(polygonLayerArray[i]);
		    	 }
		    	 map.removeOverlay(popupForBuffer);
		    	 map.removeOverlay(popupForPolygon);
	    	}
	    }
	    
	     function showBorder(cb)
	    {
	    	if(cb.checked)
	    	{
	    	loadMask.show();	
	    		borderStore.load({
		    			callback:function(){
		    			plotBorder();
		    			loadMask.hide();	
		    			}
				});
	    					
	    	}
	    else
	    	{
		    	 for(var i=0;i<borderStore.getCount();i++)
		         {	
		    		map.removeLayer(borderLayerArray[i]);
		    	 }
		    	  map.removeOverlay(popupForBorder);
	    	 }
	    }
	    
	    function plotBorder(){
  			var hubid=0;
	   	    var borderCoords=[];
	   	    var circleBorderCount=0;
	   	    var j=0;
	   	    var firstLat,firstLong;
	   	    var vectorSource = new ol.source.Vector();
	   	    popupForBorder = new ol.Overlay.Popup();
	    for(var i=0;i<borderStore.getCount();i++)
	    {	    	
	    	var rec=borderStore.getAt(i);
	    	
	    	if(rec.data['borderSequence']==0){
	    	
	    		var convertRadiusToMeters = rec.data['borderRadius'] * 1000;

				var circle = new ol.geom.Circle(ol.proj.transform([parseFloat(rec.data['long']),parseFloat(rec.data['lat'])],'EPSG:4326','EPSG:3857'),convertRadiusToMeters);
				var circleFeature = new ol.Feature(circle);
			    var circleStyle = new ol.style.Style({
			        fill: new ol.style.Fill({
				      color: [255, 255, 0, 0.3]
				    }),
				    stroke: new ol.style.Stroke({
				      color: '#A7A005',
				      width: 2
				    })
				});
				circleFeature.setStyle(circleStyle);
				var iconFeatureBorder = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(rec.data['long']),parseFloat(rec.data['lat'])],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyleBorder = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: '/ApplicationImages/VehicleImages/border.png'
				  }))
				  });
				   iconFeatureBorder.setStyle(iconStyleBorder);
		        // Source and vector layer
		        vectorSource = new ol.source.Vector({
		            projection: 'EPSG:4326'
		        });
		        vectorSource.addFeature(circleFeature);
		        vectorSource.addFeature(iconFeatureBorder);
	    	}else{
	    	
	    	if(i!=borderStore.getCount()-1 && rec.data['borderHubid']==borderStore.getAt(i+1).data['borderHubid'])
	    	{
		    	if(j==0)
		    	{
		    	  firstLat = rec.data['latitude'];
		    	  firstLong = rec.data['longitude'];
		    	}
		    	borderCoords.push(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])],'EPSG:4326','EPSG:3857'));
		    	j++;
		    	continue;
			}
			else
			{
				j = 0;
				borderCoords.push(ol.proj.transform([parseFloat(firstLong),parseFloat(firstLat)],'EPSG:4326','EPSG:3857'));
			    var polygon = new ol.geom.Polygon([borderCoords]);
	  			
	  			var feature = new ol.Feature(polygon);
	  			var polygonStyle = new ol.style.Style({
				    stroke: new ol.style.Stroke({
				      color: 'red',
				      width: 2
				    })
				});
				feature.setStyle(polygonStyle);
				var iconFeatureBorder = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(firstLong),parseFloat(firstLat)],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyleBorder = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: '/ApplicationImages/VehicleImages/border.png'
				  }))
				  });
				   iconFeatureBorder.setStyle(iconStyleBorder);
				   iconFeatureBorder.setId(rec.data['borderHubid']);
				   mapForBorder = map.on("singleclick", mapForBorder = function(evt){
					   var borderStoreIndex = -1;
					   map.forEachFeatureAtPixel(evt.pixel, function (iconFeatureBorder, borderLayer) {
				       borderStoreIndex = borderStore.find('borderHubid', iconFeatureBorder.getId());
				       if(borderStoreIndex >= 0)
	                   {
		                  var record = borderStore.getAt(borderStoreIndex);
						  var content = record.data['borderName'];
						  var coOrdinate = ol.proj.transform([parseFloat(record.data['longitude']),parseFloat(record.data['latitude'])],'EPSG:4326','EPSG:3857');
						  popupForBorder.setPosition(coOrdinate);
						  popupForBorder.setOffset([0, -40]);
						  popupForBorder.show(coOrdinate, content);
					   }
				    });  
				    if(borderStoreIndex >= 0)
				    {
		            	mapForBorder.remove();
		            }
	              });
				// Create vector source and the feature to it.
				vectorSource = new ol.source.Vector({
				 projection: 'EPSG:4326'
				 });
			    vectorSource.addFeature(feature);
			    vectorSource.addFeature(iconFeatureBorder);
		    	borderCoords = [];
			}  			
	    	}
	    	borderLayer = new ol.layer.Vector({
				  source: vectorSource
				});
			borderLayerArray[i]=borderLayer;
			map.addLayer(borderLayer);
			map.addOverlay(popupForBorder);
	    }
	    	
	}
	
	
	function removeBorder(){
			for(var i=0;i<borderPolylines.length;i++){
				borderPolylines[i].setMap(null);
				borderMarkers[i].setMap(null);
			}
			borderPolylines.length=0;
			
			for(var i=0;i<borderCircles.length;i++){
				borderCircleMarkers[i].setMap(null);
				borderCircles[i].setMap(null);
				}
	}

	    
	     function showDetailsForLargeInfoWindow(cb)
	    {	
	    		var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
					if(cb.checked)
	    			{
	    				infowindows[infowindowId].open(map, markers[infowindowId]); 
    	    			infowindows.setContent(content);
    	    		}
    	    		else
    	    		{
    	    			infowindows[infowindowId].setMap(null);
    	    		}
    	    		}
				}); 
	    }

//******************************************* Buffer *******************************************************	    
	    function plotBuffers()
	    {
	    var vectorSource = new ol.source.Vector({});
	    popupForBuffer = new ol.Overlay.Popup();
	    for(var i=0;i<bufferStore.getCount();i++)
	    {
		    var rec=bufferStore.getAt(i);
		    var urlForZero='/ApplicationImages/VehicleImages/information.png';
		    var convertRadiusToMeters = rec.data['radius'] * 1000;
	        var circle = new ol.geom.Circle(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])],'EPSG:4326','EPSG:3857'),convertRadiusToMeters);
				var circleFeature = new ol.Feature(circle);
			    var circleStyle = new ol.style.Style({
			        fill: new ol.style.Fill({
				      color: [255, 255, 0, 0.3]
				    }),
				    stroke: new ol.style.Stroke({
				      color: '#A7A005',
				      width: 2
				    })
				});
				circleFeature.setStyle(circleStyle);
		        // Source and vector layer
		        vectorSource = new ol.source.Vector({
		            projection: 'EPSG:4326'
		        });
		        vectorSource.addFeature(circleFeature);
		        
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
	  		var iconFeature = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyle = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: urlForZero
				  }))
				  });
				   iconFeature.setStyle(iconStyle);
				   iconFeature.setId(rec.data['hubId']);
				   vectorSource.addFeature(iconFeature);
				   mapForBuffer = map.on("singleclick", mapForBuffer = function(evt){
				   var bufferStoreIndex = -1;
				   map.forEachFeatureAtPixel(evt.pixel,  function (iconFeature, bufferLayer) {
				   bufferStoreIndex = bufferStore.find('hubId', iconFeature.getId());
			       if(bufferStoreIndex >= 0)
                   {
	                   var record = bufferStore.getAt(bufferStoreIndex);
					   var content = record.data['buffername'];
					   var coOrdinate = ol.proj.transform([parseFloat(record.data['longitude']),parseFloat(record.data['latitude'])],'EPSG:4326','EPSG:3857');
					   popupForBuffer.setPosition(coOrdinate);
					   popupForBuffer.setOffset([0, -40]);
					   popupForBuffer.show(coOrdinate, content);
					   selectedHub = 'true';
				   }
	             });
	              if(bufferStoreIndex >= 0)
	              {
	              	mapForBuffer.remove();
	              }
                });

				var popupCloseEvent =popupForBuffer.closer.addEventListener('click', function(evt) {
					 selectedHub = 'false';
				});
				bufferLayer = new ol.layer.Vector({
						  source: vectorSource
						});
				bufferLayerArray[i]=bufferLayer;
			    map.addLayer(bufferLayer);		
			    map.addOverlay(popupForBuffer);
	    }
	    
				
	    }


//**************************************Polygon*****************************************************************	    
	    function plotPolygon()
	    {
	    var hubid=0;
	    var polygonCoords=[];
	    var j=0;
   	    var firstLat,firstLong;
   	    var vectorSource = new ol.source.Vector();
   	    popupForPolygon = new ol.Overlay.Popup();
	    for(var i=0;i<polygonStore.getCount();i++)
	    {
	    	var rec=polygonStore.getAt(i);
	    	if(i!=polygonStore.getCount()-1 && rec.data['hubid']==polygonStore.getAt(i+1).data['hubid'])
	    	{
	    	if(j==0)
		    	{
		    	  firstLat = rec.data['latitude'];
		    	  firstLong = rec.data['longitude'];
		    	}
		    	polygonCoords.push(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])],'EPSG:4326','EPSG:3857'));
		    	j++;
		    	continue;
			}
			else
			{
				j = 0;
				polygonCoords.push(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])],'EPSG:4326','EPSG:3857'));
				polygonCoords.push(ol.proj.transform([parseFloat(firstLong),parseFloat(firstLat)],'EPSG:4326','EPSG:3857'));
			    var polygon = new ol.geom.Polygon([polygonCoords]);
			    var feature = new ol.Feature(polygon);
	  			var polygonStyle = new ol.style.Style({
				    fill: new ol.style.Fill({
				      color: [255, 255, 0, 0.3]
				    }),
				    stroke: new ol.style.Stroke({
				      color: '#A7A005',
				      width: 2
				    })
				});
				feature.setStyle(polygonStyle);
				// Create vector source and the feature to it.
				vectorSource = new ol.source.Vector({
				 projection: 'EPSG:4326'
				 });
			    vectorSource.addFeature(feature);
	  			var iconFeature = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(firstLong),parseFloat(firstLat)],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyle = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: '/ApplicationImages/VehicleImages/information.png'
				  }))});
				   iconFeature.setStyle(iconStyle);
				   iconFeature.setId(rec.data['hubid']);
				   vectorSource.addFeature(iconFeature);
					   mapForPolygon = map.on("singleclick", mapForPolygon = function(evt){
					   var polygonStoreIndex = -1;
					   map.forEachFeatureAtPixel(evt.pixel, function (iconFeature, polygonLayer) {
				       polygonStoreIndex = polygonStore.find('hubid', iconFeature.getId());
				       if(polygonStoreIndex >= 0)
	                   {
		                  var record = polygonStore.getAt(polygonStoreIndex);
						  var content = record.data['polygonname'];
						  var coOrdinate = ol.proj.transform([parseFloat(record.data['longitude']),parseFloat(record.data['latitude'])],'EPSG:4326','EPSG:3857');
						  popupForPolygon.setPosition(coOrdinate);
						  popupForPolygon.setOffset([0, -40]);
						  popupForPolygon.show(coOrdinate, content);
						  selectedPolygon = 'true';
					   }
				    });  
				    if(polygonStoreIndex >= 0)
				    {
		            	mapForPolygon.remove();
		            }
	              });
			    var popupCloseEvent = popupForPolygon.closer.addEventListener('click', function(evt) {
			    selectedPolygon = 'false';
				});
		    	polygonCoords = [];
			}
			polygonLayer = new ol.layer.Vector({
				  source: vectorSource
				});
				polygonLayerArray[i] = polygonLayer;
	   		 map.addLayer(polygonLayer);
	   		 map.addOverlay(popupForPolygon);
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
            		name: 'assetNo'
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
        		 },
        		 {
        		    name:'prevlat'
        		 },
        		 {
        		    name:'prevlong'
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
            dataIndex: 'assetNo',
            type: 'string'
        },{ 
        	dataIndex: 'groupname',
            type: 'string'
        }]
    });
    
    
       var selModel = new Ext.grid.CheckboxSelectionModel({
     	singleSelect : false,
     	checkOnly : true,
     	header    : false
 		});

    //************************************Column Model Config******************************************
     var colModel = new Ext.grid.ColumnModel({
    	columns: [selModel,
    	 {
        header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
        sortable: true,
         menuDisabled:true,
        dataIndex: 'assetNo',
        width:120
    	},{
    	header: "<span style=font-weight:bold;><%=groupName%></span>",
        sortable: true,          
        dataIndex: 'groupname',
        width:200
    	}]
		});


         
   
    grid = new Ext.grid.EditorGridPanel({                         
     bodyCssClass : 'editorgridstyles',  
      view: new Ext.grid.GroupingView({	        	
	            groupTextTpl: getGroupConfig(),
	            emptyText: 'No Records Found',deferEmptyText: false
	            
	        }),	
     store      : store,                                                                     
     colModel   : colModel,                                       
     selModel   : selModel,
     autoScroll: true,        
     loadMask	: true,
	 plugins: [filters]    
	});


  selModel.on('rowselect', function(selModel, index, record){  
  var selectedRows = selModel.getSelections();
  clearSelect = 0;
  if( selectedRows.length>1){  			  			
  	        document.getElementById('ackw-button-id').style.visibility = 'hidden'; 
           	}
           	else if( selectedRows.length==1){
           		if(detailspage!=1 && '<%=vehicleTypeRequest%>'=="noncomm")
	            {
	            document.getElementById('ackw-button-id').style.visibility = 'visible';
	            }					
				
           	} else if( selectedRows.length==0){
           		<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
	        document.getElementById('<%=detailsID%>').innerHTML = '';
			<%}%>
           		}
           	  if(selectAll != 'true')
           	  {
           	     plotMarkerForOpenLayer();
           	     selectAll = 'false';
           	  }
  		});
  
  
  selModel.on('rowdeselect',function(selModel, index, record){ 
           if(selectAll!="deselect" && clearSelect == 0)
           {
            $mpContainer.addClass('mp-container-fitscreen');
            firstLoadDetails = 0;
            slider('close');
            map.updateSize();
            popup.hide();
            plotMarkerForOpenLayer();
            popupOpened = 'false';
           } 
  });
  
     function startfilter() {
        var selectedRows = selModel.getSelections();               
        if(Ext.getCmp('searchVehicle').getValue()!='')
        {
       // for(var i=0;i<selectedRows.length;i++)
      //  {
      //  var index=i;
      //  var seletionModel = grid.getSelectionModel();
		//get array of the currently selected records
       // var selectedRecords = selModel.getSelections();
		//get the value of given field definition from the first selected row
       // var myValue = selectedRecords[index].get('vehicleNo');       
		//loop thru selectedRecords for more records if MULTI selection was allowed		
       // removeVehicleMarker(myValue);    
       // }
       document.getElementById("selectAll").checked = false;
       selectAll="false";
       map.removeLayer(vectorLayer);
       clearSelect = 1;  
       grid.getSelectionModel().clearSelections();  
         selectAllCheckClicked=0;     
               
        }        
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
   					cls:'vehiclegridstyles',
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
							html : '<div id="SELECTALL" style="background-color:#E4E4E4;height:20px;width:203px;font-size:11px;"><input  type="checkbox" id="selectAll" name="cc" onclick="selecAllVehicles(this)"/><label for="selectAll"><span margin: "6px 4px 0 0"></span></label><span class="vehicle-show-details-block"><%=selectAll%></span></div>'          
							}, grid]
                });
        loadvehicles();        
		setInterval(function(){refreshVehicle()},180000);  
        vehiclePannel.render('vehicle-list');	  
   
     var readerNonCommStatus = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'MapViewHistoryData',
        totalProperty: 'total',
        fields: [{
            		name: 'location',
            		
        		 },
        		 {
            		name: 'datetime'            		
        		 },
        		 {
            		name: 'packettype'
        		 },
        		 {
        		    name: 'batteryvoltage'
        		 },
        		 {
        		    name: 'speed'
        		 },
        		 {
        		    name:'nosatelites',
        		 }       
        	  ]
    });
    
     var storeCommStatus = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getIronMiningHistoryData',
            method: 'POST'
        }),
        remoteSort: false,

        storeId: 'darStore',
        reader: readerNonCommStatus
    }); 
         var colModelCommStatus = new Ext.grid.ColumnModel({
    	columns: [
    	 {
        header: "<span style=font-weight:bold;><%=location%></span>",
        sortable: true,
        resizable:true,
        dataIndex: 'location',
        width:300
    	},{
        header: "<span style=font-weight:bold;><%=dateTime%></span>",
        sortable: true,
        resizable:true,
        dataIndex: 'datetime',
        width:150
    	},{
        header: "<span style=font-weight:bold;><%=packetType%></span>",
        sortable: true,
        resizable:true,
        dataIndex: 'packettype',
        width:170
    	},{
        header: "<span style=font-weight:bold;><%=batteryVoltage%></span>",
        sortable: true,
        resizable:true,
        dataIndex: 'batteryvoltage',
        width:100
    	},{
        header: "<span style=font-weight:bold;><%=speed%></span>",
        sortable: true,
        resizable:true,
        dataIndex: 'speed',
        width:80
    	},{
        header: "<span style=font-weight:bold;><%=noOfSatellites%></span>",
        sortable: true,
        resizable:true,
        dataIndex: 'nosatelites',
        width:80
    	}]
		});
   
  var gridCommStatus = new Ext.grid.EditorGridPanel({                         
     height 	: 140,
     id			:'gridCommStatusid',
     viewConfig: {
            forceFit: true
        },
     autoWidth	: false,
     resizable	: true,
     store      : storeCommStatus,                                                                     
     colModel   : colModelCommStatus,                                       
     loadMask	: true
	 //plugins: [filtersCommStatus]  
	});	  
   
    var noncommStatusPannel =new Ext.Panel({
   					id:'noncommStatusPannel',
                    height : 160,
                    border:true,
                    items: [gridCommStatus]
                });
var draw;
       var formatLength = function(line) {
        var length;
        var coordinates = line.getCoordinates();
          length = 0;
          var sourceProj = map.getView().getProjection();
          for (var i = 0, ii = coordinates.length - 1; i < ii; ++i) {
            var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
            var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
            length += wgs84Sphere.haversineDistance(c1, c2);
          }
        var output;
        if (length > 100) {
          output = (Math.round(length / 1000 * 100) / 100) +
              ' ' + 'km';
        } else {
          output = (Math.round(length * 100) / 100) +
              ' ' + 'm';
        }
        return output;
      };
      var sketch;
      var measureTooltipElement;
      var measureTooltip;
      var wgs84Sphere = new ol.Sphere(6378137);
      
      var pointerMoveHandler = function(evt) {
		  if (evt.dragging) {
		    map.removeOverlay(measureTooltip);
		  } else {
         	createMeasureTooltip(); 
         }
      };
      
function startRuler()
{
if(vectorRuler != null)
{
	removeRuler();
}
sourceRuler = new ol.source.Vector();
vectorRuler = new ol.layer.Vector({
  source: sourceRuler,
   style: new ol.style.Style({
            fill: new ol.style.Fill({
              color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
              color: 'rgba(0, 0, 0, 0.5)',
              lineDash: [10, 10],
              width: 2
            }),
            image: new ol.style.Circle({
              radius: 5,
              stroke: new ol.style.Stroke({
                color: 'rgba(0, 0, 0, 0.7)'
              }),
              fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
              })
            })
          })
});
	map.addLayer(vectorRuler);
    map.on('pointermove', pointerMoveHandler);
    addInteraction();
}   

function removeRuler()
{
   map.removeLayer(vectorRuler);
   map.removeInteraction(draw);
  for(var i=0;i<measureToolTipArray.length;i++)
  {
  	map.removeOverlay(measureToolTipArray[i]);
  }
 
}  

function slider(condition)
{  var effect = 'slide';
  
    var options = { direction: 'right' };
  
    var duration = 500;
    if(condition == 'close'){ 
 	 $('#vehicle-details').hide(effect, options, duration);	
 	 }else{
 	 $('#vehicle-details').show(effect, options, duration);	
 	 }
}

function loadMapViewDetails (vehicleNo)
{	

				var idCount= grid.store.findExact( 'vehicleNo', vehicleNo);
				var rec = grid.store.getAt(idCount);
           		mapViewAssetDetails.load({
						params:{vehicleNo:vehicleNo},
						callback:function()
							{
							   if(mapViewAssetDetails.getCount()>0){
							   
								var record=mapViewAssetDetails.getAt(0);
								if(document.getElementById('Vehicle_No')!= null )
								{
								document.getElementById('Vehicle_No').innerHTML=record.data['vehicleNo'];
								}
								if(document.getElementById('Latitude')!= null )
								{
								document.getElementById('Latitude').innerHTML=rec.data['latitude'];
								}
								if(document.getElementById('Longitude')!= null )
								{
								document.getElementById('Longitude').innerHTML=rec.data['longitude'];
								}
								if(document.getElementById('Location')!=null)
								{
								 	document.getElementById('Location').innerHTML=rec.data['location'];
								}								
								if(document.getElementById('Vehicle_Group')!=null )
								{
								document.getElementById('Vehicle_Group').innerHTML=record.data['groupname'];
								}
								 if (document.getElementById('Date_Time')!=null )
								{
									document.getElementById('Date_Time').innerHTML=rec.data['gmt'];
								}
								 if (document.getElementById('Speed') !=null )
								{
								document.getElementById('Speed').innerHTML=record.data['speed'];	
								}
								 if (document.getElementById('Driver_Name')!=null)								
								{
								document.getElementById('Driver_Name').innerHTML=record.data['drivername'];
								}
								 if (document.getElementById('Ignition')!=null)
								{
								document.getElementById('Ignition').innerHTML=record.data['ignition'];
								}
								 if (document.getElementById('Vehicle_Model')!=null)
								{
								document.getElementById('Vehicle_Model').innerHTML=record.data['model'];
								}
								 if (document.getElementById('Owner_Name')!=null)
								{
								document.getElementById('Owner_Name').innerHTML=record.data['ownerName'];
								}
								 if (document.getElementById('Vehicle_Type') !=null)
								{
								document.getElementById('Vehicle_Type').innerHTML=record.data['vehicleType'];
								}
								 if (document.getElementById('Status')!=null)
								{
								document.getElementById('Status').innerHTML=record.data['status'];
								}
								 if (document.getElementById('Cash_in')!=null)
								{
								document.getElementById('Cash_in').innerHTML=record.data['cashin'];
								}
								 if (document.getElementById('Cash_out')!=null)
								{
								document.getElementById('Cash_out').innerHTML=record.data['cashout'];
								}
								 if (document.getElementById('Cash_balance')!=null)
								{
								document.getElementById('Cash_balance').innerHTML=record.data['cashbalance'];
								}
								 if (document.getElementById('Driver_Number')!=null)
								{
								document.getElementById('Driver_Number').innerHTML=record.data['drivermobile'];
								}
								
								if (document.getElementById('Temperature')!=null)
								{
								document.getElementById('Temperature').innerHTML=record.data['temperature'];
								}
										
							    }	
							}
				});	
				if(<%=processID%>==29)
				{
				mapViewSandDetails.load({
						params:{vehicleNo:rec.data['vehicleNo']},
						callback:function()
							{
							   if(mapViewSandDetails.getCount()>0){
								var record=mapViewSandDetails.getAt(0);
								document.getElementById('Last_Port_Visit').innerHTML=record.data['lastPortArrival'];
								document.getElementById('Owner_Name').innerHTML=record.data['ownerName'];
								document.getElementById('Owner_Number').innerHTML=record.data['ownerNo'];
								document.getElementById('Sand_Reg_No').innerHTML=record.data['uniqueSandId'];
							    }	
							}
				});
				}
           		
           	

}

function unLoadMapViewDetails()
{
		<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
	                        	document.getElementById('<%=detailsID%>').innerHTML = '';
			                <%}%>

}

function createLandmark(vehicleNo){
title="Location Page";
var reg = vehicleNo.replace(/ /g,"%20");
var locationPage="/jsps/CustomLocationCreation.jsp?vehicle="+reg;
       parent.openLocationWindow(locationPage,title);	
    	
}	
function historyAnalysis(vehicleNo){
	var hisTrackNew = true;
	var url="<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?vehicleNo="+vehicleNo+"&hisTrackNew="+hisTrackNew;
	parent.document.getElementById('listviewid').style.color='#fff';
	parent.document.getElementById('listviewid').style.borderColor='#fff';
	parent.document.getElementById('mapviewid').style.color='#fff';
	parent.document.getElementById('mapviewid').style.borderColor='#fff';
	parent.document.getElementById('history_analysis').style.color='#02B0E6';
	parent.document.getElementById('history_analysis').style.borderColor='#02B0E6';
	window.parent.$('#listviewcontainer').attr('src',url);
}

function plotMarkerForOpenLayer()
{
// returns an array of selected records
				var vectorSource = new ol.source.Vector({});
				var selectedBanners = grid.getSelectionModel().getSelections(); 
				var selectCount = 0;
				Ext.iterate(selectedBanners, function(banner, index) {
				    // push the row indexes into your array
				    
				    var rec = grid.store.getAt(grid.getStore().indexOf(banner));
				    if(rec.data['longitude'] != '' && rec.data['latitude'] != '')
				    {
				    selectCount++;
				    var status = rec.data['category'];
				    var longitude = rec.data['longitude'];
				    var latitude = rec.data['latitude'];
				    var vehicleNo = rec.data['vehicleNo'];
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
				    var iconFeature = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(longitude),parseFloat(latitude)],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyle = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: imageurl
				  }))
			});
			    iconFeature.setStyle(iconStyle);
			    iconFeature.setId(vehicleNo);
			    vectorSource.addFeature(iconFeature);
                mapForVehicle = map.on("singleclick", mapForVehicle = function(evt) {
                var vehicleDetailsIndex = -1;
					map.forEachFeatureAtPixel(evt.pixel, function (iconFeature, vectorLayer) {
					   vehicleDetailsIndex = store.find('vehicleNo', iconFeature.getId());
		                if(vehicleDetailsIndex >= 0)
		                {
		                  var record = store.getAt(vehicleDetailsIndex);
						  var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">'+
										'<table>'+
										'<tr><td><b>Vehicle No:</b></td><td>'+iconFeature.getId()+'</td></tr>'+
										'<tr><td><b>Location:</b></td><td>'+record.data['location']+'</td></tr>'+
										'<tr><td><b>Date Time:</b></td><td>'+record.data['gmt']+'</td></tr>'+
										'<tr><td></td><td style="float:right;width:207px"><span style="margin-right: 1em;"><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="historyAnalysis(\'' + iconFeature.getId() + '\')">History Analysis</button></span><span><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="createLandmark(\'' + iconFeature.getId() + '\')"><%=createlandmark%></button><span></td></tr>'+
										'</table>'+
										'</div>';
						  var coOrdinate = ol.proj.transform([parseFloat(record.data['longitude']),parseFloat(record.data['latitude'])],'EPSG:4326','EPSG:3857');
						   loadMapViewDetails (iconFeature.getId());
		        			$mpContainer.removeClass('mp-container-fitscreen');
		        			$mpContainer.addClass('mp-container');
		        			slider('open');
		        			map.updateSize();
		        			document.getElementById('vehicle-details').style.display = 'block';
		        			document.getElementById('ackw-button-id').style.display = 'block';
		        			 popup.setPosition(coOrdinate);
						  popup.setOffset([0, -40]);
						   popup.show(coOrdinate, content);
						   popupOpened = 'true';
				     }
					 });
					  if(vehicleDetailsIndex >= 0)
					  {
						mapForVehicle.remove();
					  }
				});

				var popupCloseEvent = popup.closer.addEventListener('click', function(evt) {
					if(mapviewFullScreen==1){				
						 document.getElementById('option-fullscreen').style.display = 'none';
		        		document.getElementById('option-normal').style.display = 'block';	
		       			 $mpContainer.removeClass('mp-container-fitscreen');
					}else{			
					$mpContainer.addClass('mp-container-fitscreen');
					}
					map.updateSize();
					unLoadMapViewDetails();	
					slider('close');
					popupOpened = 'false';
				});
				 map.removeLayer(vectorLayer);
				 map.removeOverlay(popup);
				vectorLayer = new ol.layer.Vector({
				  source: vectorSource
				});
				map.addLayer(vectorLayer);
				map.addOverlay(popup);
				if((selectAll == 'false' || selectAll == 'deselect') && selectCount == 1)
				{
					if(selectedSingleVehicle == 'true')
				    {
				    	map.getView().setResolution(map.getView().getResolution() / 0.05);
				    }
				    selectedSingleVehicle = 'true';
				    map.getView().setCenter(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])], 'EPSG:4326', 'EPSG:3857'))
				    map.getView().setResolution(map.getView().getResolution() * 0.05);
				} else {
					selectedSingleVehicle = 'false';
				  	map.getView().fit(vectorSource.getExtent(), map.getSize());
				}
}
});
if(selectCount==0)
{
	map.removeLayer(vectorLayer);
	map.removeOverlay(popup);
}
}

  function addInteraction() {
        draw = new ol.interaction.Draw({
          source: sourceRuler,
          type: /** @type {ol.geom.GeometryType} */ 'LineString',
          style: new ol.style.Style({
            fill: new ol.style.Fill({
              color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
              color: 'rgba(0, 0, 0, 0.5)',
              lineDash: [10, 10],
              width: 2
            }),
            image: new ol.style.Circle({
              radius: 5,
              stroke: new ol.style.Stroke({
                color: 'rgba(0, 0, 0, 0.7)'
              }),
              fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
              })
            })
          })
        });
        map.addInteraction(draw);
        var listener;
        draw.on('drawstart',
            function(evt) {
              sketch = evt.feature;
              var tooltipCoord = evt.coordinate;
              listener = sketch.getGeometry().on('change', function(evt) {
                var geom = evt.target;
                var output = formatLength(/** @type {ol.geom.LineString} */ (geom));
                tooltipCoord = geom.getLastCoordinate();
                 measureTooltipElement = document.createElement('div');
                 measureTooltipElement.className = 'tooltip tooltip-measure';
                  measureTooltip = new ol.Overlay({
		          element: measureTooltipElement,
		          offset: [0, -15],
		          positioning: 'bottom-center'
		        });
		         map.addOverlay(measureTooltip);
                measureTooltipElement.innerHTML = output;
                measureTooltip.setPosition(tooltipCoord);
                tipCount++;
                measureToolTipArray[tipCount] = measureTooltip;
              });
            }, this);
            draw.on('drawend',
      function(evt) {
        // unset sketch
        sketch = null;
        // unset tooltip so that a new one can be created
        measureTooltipElement = null;
      }, this);
      }
      function createMeasureTooltip() {
        if (measureTooltipElement) {
          measureTooltipElement.parentNode.removeChild(measureTooltipElement);
        }
        measureTooltipElement = document.createElement('div');
        measureTooltipElement.className = 'tooltip tooltip-measure';
        measureTooltip = new ol.Overlay({
          element: measureTooltipElement,
          offset: [0, -15],
          positioning: 'bottom-center'
        });
        map.addOverlay(measureTooltip);
      }
//****************************OnReady*********************************//
Ext.onReady(function () {
 
    store.load({
    	params:{vehicleType:previousVehicleType},
    	callback:function(){
    		var vehicles=parent.document.getElementById('reglist').value;    		
    		vehicles = vehicles.substring(0, vehicles.length - 1);    		
    		var selectedVehicle=vehicles.split("|");    		
    		for(var i =0; i<selectedVehicle.length;i++){
    		ind=grid.store.findExact( 'vehicleNo', selectedVehicle[i]);
    		if(ind>-1){
	       	selModel.selectRow(ind,true);
	       		}    		
    		}
    		
    		
    	} 
    	});
});
 
 	
        
	</script>
    </body>
      </html> 
