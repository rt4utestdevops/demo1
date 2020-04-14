
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"
 			+ request.getServerName() + ":" + request.getServerPort()
 			+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	LiveVisionColumns liveVisionColumns = new LiveVisionColumns();
 	cf.checkLoginInfo((LoginInfoBean) session
 			.getAttribute("loginInfoDetails"), session, request,
 			response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session
 			.getAttribute("loginInfoDetails");
 	String detailsID = "";
 	int processID = 0;
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	String systemID = Integer.toString(systemid);
 	int customeridlogged = loginInfo.getCustomerId();
 	String CustName = loginInfo.getCustomerName();
 	String customernamelogged = "null";
 	String vehicleTypeRequest = "all";
 	String mapTypeFromOpen = "";
 	if (request.getParameter("processId") != null) {
 		processID = Integer.parseInt((String) request
 				.getParameter("processId"));
 	}
 	if (request.getParameter("vehicleType") != null) {
 		vehicleTypeRequest = request.getParameter("vehicleType");
 	}
 	if (request.getParameter("mapType") != null) {
 		mapTypeFromOpen = request.getParameter("mapType");
 	}
 	if (customeridlogged > 0) {
 		customernamelogged = loginInfo.getCustomerName();
 	}
 	int userId = loginInfo.getUserId();
 	int countryId = 0;// loginInfo.getCountryCode();
 	int mapType = loginInfo.getMapType();
 	String countryName = "";// cf.getCountryName(countryId);
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen")
 			.trim();
 	String vehicleImagePath = properties
 			.getProperty("vehicleImagePath");
 	int zoompercent = 0;
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
 	tobeConverted
 			.add("Sim_Card_Installed_In_Device_May_Not_Be_Working");
 	tobeConverted.add("Device_May_Be_Tampered");
 	tobeConverted.add("Vehicle_May_Be_Out_of_Network_Coverage_Area");
 	tobeConverted.add("Device_Wire_May_Be_Loosley_Connected");
 	tobeConverted.add("Device_Health");
 	tobeConverted.add("Refresh");
 	tobeConverted.add("Show_Hubs");
 	tobeConverted.add("Show_Labels");
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
 	tobeConverted.add("Vehicle_Alias");
 	tobeConverted.add("Show_Service_Station");
 	String setZoomToMap = "Fix Map Postion";
 	ArrayList<String> convertedWords = new ArrayList<String>();
 	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,
 			language);

 	String SLNO = convertedWords.get(0);
 	String vehicleNo = convertedWords.get(1);
 	String lastCommunicatedLocation = convertedWords.get(2);
 	String lastCommunicatedDateTime = convertedWords.get(3);
 	String nonCommunicatingHours = convertedWords.get(4);
 	String noOfSatellites = convertedWords.get(5);
 	String invalidPacket = convertedWords.get(6);
 	String mainPower = convertedWords.get(7);
 	String mainPowerOffLocation = convertedWords.get(8);
 	String mainPowerOffDateTime = convertedWords.get(9);
 	String batteryVoltage = convertedWords.get(10);
 	String batteryHealth = convertedWords.get(11);
 	String deviceNonCommunicatingCheckList = convertedWords.get(12);
 	String simCardInstalledInDeviceMayNotBeWorking = convertedWords
 			.get(13);
 	String deviceMayBeTampered = convertedWords.get(14);
 	String vehicleMayBeOutofNetworkCoverageArea = convertedWords
 			.get(15);
 	String deviceWireMayBeLoosleyConnected = convertedWords.get(16);
 	String deviceHealth = convertedWords.get(17);
 	String refresh = convertedWords.get(18);
 	String showHubs = convertedWords.get(19);
 	String showDetails = convertedWords.get(20);
 	String stopped = convertedWords.get(21);
 	String running = convertedWords.get(22);
 	String idle = convertedWords.get(23);
 	String selectAll = convertedWords.get(24);
 	String dashBoardMap = convertedWords.get(25);
 	String createlandmark = convertedWords.get(26);
 	String showBorder = convertedWords.get(27);
 	String groupName = convertedWords.get(28);
 	String location = convertedWords.get(29);
 	String dateTime = convertedWords.get(30);
 	String packetType = convertedWords.get(31);
 	String speed = convertedWords.get(32);
 	String vehicleId = convertedWords.get(33);
 	String showServiceStation = convertedWords.get(34);
 	String distUnits = cf.getUnitOfMeasure(systemid);
 	String latitudeLongitude = cf.getCoordinates(systemid);
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
	<script src="../../Main/Js/markerclusterer.js"></script>	
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/common.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />
	<pack:script src="../../Main/Js/jQueryMask.js"></pack:script>
     <pack:style src="../../Main/modules/common/jquery.loadmask.css" />

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
	<style>
body {
	background-color: #FFFFFF;
}

.x-grid3-cell-inner {
	font-size: 11px;
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
	background-color: white;
	fontsize: 12;
}

@media screen and (device-width: 1920px) {
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
		background-color: white;
		fontsize: 12;
	}
}

@media ( device-width : 1280px) and (device-height: 720px) {
	.openLayerButton {
		margin-top: -386px !important;
		border: 1px solid transparent;
		border-radius: 2px 2px 2px 2px;
		box-sizing: border-box;
		-moz-box-sizing: border-box;
		height: 29px;
		outline: none;
		float: left;
		margin-left: 103px;
		background-color: white;
		fontsize: 12;
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
		background-color: white;
		fontsize: 12;
	}
}

@media screen and (device-width: 1440px) {
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
		background-color: white;
		fontsize: 12;
	}
}

@media screen and (device-width:1280px) {
	.noteinfo {
		margin-top: -7px;
	}
}

@media ( device-width : 1280px) and (device-height: 800px) {
	.openLayerButton {
		margin-top: -462px !important;
		border: 1px solid transparent;
		border-radius: 2px 2px 2px 2px;
		box-sizing: border-box;
		-moz-box-sizing: border-box;
		height: 29px;
		outline: none;
		float: left;
		margin-left: 103px;
		background-color: white;
		fontsize: 12;
	}
}

.vehicle_marker {
	float: left;
	margin-left: 5px;
	margin-top: 0px;
	font-size: 11px;
	font-family: 'Open Sas' sans-serif !important;
	width: 30px;
	height: 10px;
}

.create-landmark-button {
	height: 20px;
	background-color: transparent;
	border: 0;
	border-radius: 10px;
	background-repeat: no-repeat;
	background: #3498db;
	font-size: 10px;
	font-family: 'Open Sas' sans-serif !important;
	color: #fff;
	margin-left: -1px;
	width: 92px;
}
</style>
	</head>
	<script src='<%=GoogleApiKey%>'></script>
    
    <body>
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
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">1)<%=simCardInstalledInDeviceMayNotBeWorking%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) <%=deviceMayBeTampered%></span></li>
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">3)<%=vehicleMayBeOutofNetworkCoverageArea%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4) <%=deviceWireMayBeLoosleyConnected%></span></li>
					  </ul>	
					</form>	
			</div>
			<button type="button" id="ackw-button2-id" class="ack-button2" onclick="commstatusScreen()"><%=dashBoardMap%></button>	
			</div>
			<div class="mp-vehicle-wrapper" id="vehicle-list"></div>
			<div class="mp-vehicle-details-wrapper" id="vehicle-details">
			<form class="me-select">
				<ul id="me-select-list">
				<%=liveVisionColumns.getVehicleDetails(processID, language)
					.toString()%>
				</ul>
				<div class='map-view-botton-pannel-div'>		
					<button type="button" id="ackw-button-id" class="ack-button" onclick="commstatusScreen()"><%=deviceHealth%></button>		
				</div>
			 </form>						
			</div>
			<div class="mp-vehicle-details-wrapper" id="vehicle-obd-details">
			<form class="me-select">
				<ul id="me-select-list">
				<li class='me-select-label'><span class='vehicle-details-block-header'>test</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id='test'></p></li>
				</ul>
				<div class='map-view-botton-pannel-div'>		
					<button type="button" id="ackw-button-id" class="ack-button" onclick="commstatusScreen()"><%=deviceHealth%></button>		
				</div>
			 </form>						
			</div>
				<div class="mp-container" id="mp-container">
					<div id="grid">
			        <div class="mp-map-wrapper" id="map"> </div>
					<div class="mp-options-wrapper"/>
					<select class="openLayerButton" id="maptype" onchange="customMap();">
					<%
						if (mapTypeFromOpen.equals("")) {
							if (mapType == 1) {
					%>  
	        		<option value="SatMap">Satellite Google Map</option>
  					<option value="StreetMap">Street Google Map</option>
  					<!-- <option value="CusMap">Openstreet Map</option> -->
  					<option value="BhuvanCusMap">Bhuvan Map</option> 
  					<%
   						} else if (mapType != 1) {
   					%>  
	        		<option value="StreetMap">Street Google Map</option>
	        		<option value="SatMap">Satellite Google Map</option>
  					<!-- <option value="CusMap">Openstreet Map</option> -->
  					<option value="BhuvanCusMap">Bhuvan Map</option> 
  					<%
   						}
   						} else {
   							if (mapTypeFromOpen.equals("SatMap")) {
   					%>
	       			<option value="SatMap">Satellite Google Map</option>
  					<option value="StreetMap">Street Google Map</option>
  					<!-- <option value="CusMap">Openstreet Map</option> -->
  					<option value="BhuvanCusMap">Bhuvan Map</option> 
  					<%
   						} else if (mapTypeFromOpen.equals("StreetMap")) {
   					%>
	        		<option value="StreetMap">Street Google Map</option>
	        		<option value="SatMap">Satellite Google Map</option>
  					<!-- <option value="CusMap">Openstreet Map</option> -->
  					<option value="BhuvanCusMap">Bhuvan Map</option> 
  					<%
   						}
   						}
   					%>
					</select>		
					<input id="pac-input" class="controls" type="text" placeholder="Search Places" >
					<table width="98%">
						<tr height="10px"><td > <div class="mp-option-showhub" id="show"></div></td>
						<td>
								<div>
							<img class="ruler" id ="startRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerStart.gif" title="Start Ruler"/>							
								</div>
							</td>
							<td>
								<div>
							<img  class="ruler" id ="removeRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerEnd.gif" title="Remove Ruler"/>							
								</div>
							</td>
							<td>
								<div>
							<img class="refreshImage" src="/ApplicationImages/ApplicationButtonIcons/Refresh.png" onclick="refreshVehicle()" title="Refresh"/>							
								</div>
							</td>
							<td width="15%"><div style="padding-left:13px">
								<input type="checkbox" id="c1" name="cc" onclick='showHub(this);'/>
            					<label for="c1"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showHubs%></span>
            				</div></td>
            				<%
            					if (systemid == 12 || systemid == 261) {
            				%>
            				<td width="15%"><div style="padding-left:13px">
								<input type="checkbox" id="c4" name="cc" onclick='showServiceStation(this);' />
            					<label for="c4"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showServiceStation%></span>
            				</div></td>
            				<%
            					}
            				%>
            				<td width="15%"><div style="padding-left:13px">
								<input type="checkbox" id="c3" name="cb" onclick='showBorder(this);'/>
            					<label for="c3"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showBorder%></span>
            				</div></td>
            				<td width="15%"><div style="padding-left:13px">
								<input type="checkbox" id="c5" name="cz" onclick='setZoomToMap(this);'/>
            					<label for="c5"><span></span></label>
            					<span class="vehicle-show-details-block"><%=setZoomToMap%></span>
            				</div></td>
            				<td width="25%"><div class ="checkBoxRegion"  style="display:block;">
								<input type="checkbox" id="c2" name="cc" onclick='showDetails(this);'/>
            					<label for="c2"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showDetails%></span>
            				</div></td>
            				<td align="center"><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImagesNew/MapImages/Legend_BR.png">            				
							<span class="vehicle_marker_label" style="padding-right: 10px;"><%=stopped%></span></div></td>
							<td><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImagesNew/MapImages/Legend_BG.png">							
							<span  class="vehicle_marker_label" style="padding-right: 10px;"><%=running%></span></div></td>
							<td><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImagesNew/MapImages/Legend_BL.png">							
							<span class="vehicle_marker_label"style="padding-right: 10px;"><%=idle%></span></div></td>
													
						<td style="width:0px;"><div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"  onclick="mapFullScreen()"></div></td>
						</tr>
						</table>
						<div class="noteinfo"><b>NOTE</b>:Show Labels will be Enabled only for Maximum of 300 Vehicles .</div>
						<div class="noteinfo">              Zoom to the required area before checking on Fix Map Position .</div>
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
		var infowindowsTwo= {};
		var circles = [];
		var circlesForServiceSt = [];
		var borderCircles=[];
		var borderCircleMarkers=[];
		var polygons =[];
		var serviceStation = [];
		var serviceStationMarkers = [];	
		var bufferMarkerForServiceSts = [];	
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
		var infowindowTwo;
		var jspName="Map View";
		var circle;
		var button="Map";
		var selectAll="false";
		var previousSelectedRow=-1;
		var contentOne;
		var contentTwo;
		var exportDataType="int,string,date,string,string,int,float,string,string,string,string,string,string,date";
		var ctsb;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		var previousVehicleType='<%=vehicleTypeRequest%>';
		var firstLoadDetails=0;
		var mapviewFullScreen=0;	
		var refreshcount=0;	
		var bounds = new google.maps.LatLngBounds();
		var selectAllCheckClicked=0;
		var markerCluster;
		var markerClusterArray=[];
		var mcOptions = {gridSize: 20, maxZoom: 100};	
		var countryName = '<%=countryName%>';	
		var processID = '<%=processID%>';
		var distanceUnits = '<%=distUnits%>';
		document.getElementById('option-normal').style.display = 'none';		
		document.getElementById('mapview-commstatus-dashboard-id').style.visibility = 'hidden';	
		document.getElementById('ackw-button-id').style.visibility = 'hidden';	
		document.getElementById('ackw-button2-id').style.visibility = 'hidden';
		var distanceList=[];
	    var datalist = [];
	    var infolist = [];
	    var polyline;
	    var polylines=[];
	    var markerFlag;
	    var animate = "true";
		var firstLatLong;		
		var selectedVehIndex = "0";
		var selectedListVeh = 0;
		var historyLatitude ;
		var	historyLogitude;
		var	historyLocation;
		var	historyGmt;
		var	historySpeed;
		var interval;
		var showlabel= "false";
		function customMap(){
			if(document.getElementById("maptype").value == "CusMap")
			{
				var mapType = 'CusMap';
				var url="<%=request.getContextPath()%>/Jsps/Common/MapViewOpenLayer.jsp?vehicleType="+previousVehicleType+"&processId="+processID+"&mapType="+mapType;
				window.parent.$('#listviewcontainer').attr('src',url);		
			} else if(document.getElementById("maptype").value == "SatMap")
			{
				map.setOptions({
  					mapTypeId: google.maps.MapTypeId.HYBRID
				});	
			} else if(document.getElementById("maptype").value == "StreetMap")
			{
				map.setOptions({
  					mapTypeId: google.maps.MapTypeId.ROADMAP
				});	
			}else if(document.getElementById("maptype").value == "BhuvanCusMap")
			{
				var mapType = 'BhuvanCusMap';
				var url="<%=request.getContextPath()%>/Jsps/Common/BhuvanMapView.jsp?vehicleType="+previousVehicleType+"&processId="+processID+"&mapType="+mapType;
				window.parent.$('#listviewcontainer').attr('src',url);		
			} 
		}
		
		function commstatusScreen()
		{
		if(detailspage==0)
		{
		previousSelectedRow = grid.store.indexOf(grid.getSelectionModel().getSelected());
		
    	$('#mp-container').slideUp('slow', function() {});
  		$('#vehicle-details').slideUp('slow', function() {});
  		$('#vehicle-obd-details').slideUp('slow', function() {});
  		document.getElementById('mapview-asset-commstatus-id').style.display='block';
  		document.getElementById('ackw-button2-id').style.visibility = 'visible';
  		document.getElementById('mapview-commstatus-dashboard-id').style.visibility = 'visible';
  		document.getElementById('ackw-button-id').style.visibility = 'hidden';
  		gridCommStatus.render('mapview-commstatus-id');	 
  		document.getElementById('SELECTALL').style.display = 'none';
  		document.getElementById('vehicle-details').style.visibility = 'hidden';
  		document.getElementById('vehicle-obd-details').style.visibility = 'hidden';
  		detailspage=1;  		
		getNonCommStatusData();
  		}
  		else
  		{
  		$('#mp-container').slideDown('slow', function() {});
  		$('#vehicle-details').slideDown('slow', function() {});
  		$('#vehicle-obd-details').slideDown('slow', function() {});
  		document.getElementById('SELECTALL').style.display = 'block';
  		document.getElementById('mapview-asset-commstatus-id').style.display='none';
  		document.getElementById('ackw-button2-id').style.visibility = 'hidden';
  		document.getElementById('mapview-commstatus-dashboard-id').style.visibility = 'hidden';	
  		document.getElementById('ackw-button-id').style.visibility = 'visible';
  		document.getElementById('vehicle-details').style.visibility = 'visible';
  		document.getElementById('vehicle-obd-details').style.visibility = 'visible';
  		detailspage=0;
  		}
		}
		function mapFullScreen()
		{	
		if(grid.getSelectionModel().getCount()>1)
		{
		 $mpContainer.removeClass('list-container-fitscreen');
		}
		showDetailsForLargeInfoWindow(false);	
		mapviewFullScreen=1;
		firstLoadDetails=0;
		sliderArray.length=0;
		slider();
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
		mapviewFullScreen=0;
		Ext.getCmp('vehiclePannel').show();
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
	        zoom:5,
	        center: new google.maps.LatLng(<%=latitudeLongitude%>),//'0.0', '0.0'),	
	         <%if (mapTypeFromOpen.equals("")) {
				if (mapType == 1) {%>  
	        mapTypeId: google.maps.MapTypeId.HYBRID,   
	        <%} else if (mapType != 1) {%>  
	        mapTypeId: google.maps.MapTypeId.STREET,
	        <%}
			} else {
				if (mapTypeFromOpen.equals("SatMap")) {%>
	        mapTypeId: google.maps.MapTypeId.HYBRID, 
	        <%} else if (mapTypeFromOpen.equals("StreetMap")) {%>
	        mapTypeId: google.maps.MapTypeId.STREET,
	       <%}
			}%>
	        mapTypeControl: false,
	        gestureHandling: 'greedy' 
	    };

	  //map = new google.maps.Map(document.getElementById('map'), mapOptions);
	    map = new google.maps.Map(document.getElementById('map'), mapOptions);
		var trafficLayer = new google.maps.TrafficLayer();
       	trafficLayer.setMap(map);
	   var mapZoom = 14;
	  
<!--	   var geocoder = new google.maps.Geocoder();-->
<!--		    geocoder.geocode({'address': countryName}, function(results, status) {-->
<!--		      if (status == google.maps.GeocoderStatus.OK) {-->
<!--			        map.setCenter(results[0].geometry.location);-->
<!--			        map.fitBounds(results[0].geometry.viewport);-->
<!--		      	}-->
<!--		    });-->
		    
	   searchBox(map,'pac-input');
//***********************************Plot Vehicle on Map *******************************************

function createPolylineTrace(vehicleNoDot){
	 	var lon = 0.0;
		var lat = 0.0; 
		var flightPath=[];
		polylines = [];
		var BoundsForPlotting = new google.maps.LatLngBounds();
		var lineSymbol = {
        	path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
        	scale: 2,
        	fillColor: '#006400',
        	fillOpacity: 1.0
    	};
		for(var i=0;i<infolist.length;i++){
			lat = infolist[i+1];
		    lon = infolist[i+2];
		    if(i == 0)
		    {
			    var positionFlag = new google.maps.LatLng(lat,lon);
		        markerFlag = new google.maps.Marker({
			    position: positionFlag,
			    map: map,
			    icon:'/ApplicationImages/VehicleImages/redcirclemarker.png'
			    });
			    firstLatLong = positionFlag;
			    var contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
					'<table>' +
					'<tr><td><b>Vehicle No:</b></td><td>' + vehicleNoDot + '</td></tr>' +
					'<tr><td><b>Location:</b></td><td>' + infolist[i] + '</td></tr>' +
					'<tr><td><b>Date Time:</b></td><td>' + infolist[i+3] + '</td></tr>' +
					//'<tr><td></td><td style="float:right;"><span style="margin-right: 1em;"><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="historyAnalysis(\'' + vehicleNo + '\')">History Analysis</button></span><span><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="createLandmark(\'' + vehicleNo + '\',\'' + latitude + '\',\'' + longtitude + '\')"><%=createlandmark%></button><span></td></tr>' +
					'</table>' +
					'</div>';
				var infowindowDot = new google.maps.InfoWindow({
					content: contentForDot,
					marker: markerFlag,
					maxWidth: 300
					//image: image,
					//id: vehicleNo
				});
				google.maps.event.addListener(markerFlag, 'click', function() {
                    infowindowDot.setContent(contentForDot);
					infowindowDot.open(map, markerFlag);
                });
				
		    }
		    var latLong = new google.maps.LatLng(lat,lon);
		    flightPath.push(latLong);  
		    if(i == (infolist.length - 6))
		    {
		        	var BoundsForPlotting = new google.maps.LatLngBounds();
					BoundsForPlotting.extend(firstLatLong);
					BoundsForPlotting.extend(latLong);
					map.fitBounds(BoundsForPlotting);
		    }
			i+=5;			
		}		
		if(infolist.length == 0)
		{
			map.fitBounds(bounds);
		}
		polyline = new google.maps.Polyline({ 
		    path: flightPath,
		    strokeColor: '#006400',
		    strokeOpacity: 1.0,
		    strokeWeight: 4,
		    icons: [{
	            icon: lineSymbol,
	            offset: '100%',
	            repeat: '100px'
	        }],
	        map: map
  			});  
  			polyline.setMap(map);
  			polylines.push(polyline);
        	animatePolylines();
        	animate = "false";
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
	 
	 function removePolylineTrace(){	 	
	     for(var i=0;i<polylines.length;i++){
	     	var poly = polylines[i];
	     	poly.setMap(null);
	     	poly=null;
	     } 
	     polylines.length = 0; 
	 }
		
	 function loadData(vehicleNo){
		var dtcur = new Date();	
		var timeband = '0';
		datalist = [];
		infolist = [];
		$("#mapViewGridId").mask();
		 $("#mp-container").mask();
		 $.ajax({
			url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=getVehicleTrackingHistory',
			data:{
				vehicleNo:vehicleNo,
				timeband:timeband,
				recordForSixhrs:'recordForHalfAnhr',
				},
			success: function(result) {
				 dataAndInfoList = JSON.parse(result);
				 var totaldatalist = dataAndInfoList["vehiclesTrackingRoot"][0].datalist;
				 for(var i=0;i<totaldatalist.length;i++){
				 	datalist.push(totaldatalist[i]);
				 }
				 var totalinfolist = dataAndInfoList["vehiclesTrackingRoot"][1].infolist;
	             for(var i=0;i<totalinfolist.length;i++){
				 	infolist.push(totalinfolist[i]);
				 }
	             if(infolist.length > 0){
	              createPolylineTrace(vehicleNo);
	             }
			} 
		});
	}

	function plotSingleVehicle(vehicleNo,drivername, latitude, longtitude, location, gmt, status, imagePath, LRNO, tripNo, routeName,vehicleImageServerPath) {

		 
		image = {
			url: vehicleImageServerPath, // This marker is 20 pixels wide by 32 pixels tall.
			scaledSize: new google.maps.Size(35, 35), // The origin for this image is 0,0.
			origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
			anchor: new google.maps.Point(0, 32)
		};
		var pos = new google.maps.LatLng(latitude, longtitude);
		marker = new google.maps.Marker({
			position: pos,
			id: vehicleNo,
			map: map,
			icon: image
		});
		var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
			'<table>' +
			'<tr><td><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
			'<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' +
			'<tr><td><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
			'<tr><td><b>Driver Name:</b></td><td>' + drivername + '</td></tr>' +
			'<tr><td><b>Trip No:</b></td><td>' + LRNO + '</td></tr>' +
			'<tr><td><b>Trip Id:</b></td><td>' + tripNo + '</td></tr>' +
			'<tr><td><b>Route Name:</b></td><td>' + routeName + '</td></tr>' +
			'<tr><td><span style="margin-right: 1em;"><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="googlemaplink(\'' + vehicleNo + '\',\'' + latitude + '\',\'' + longtitude + '\')">Google Map link</button></span></td><td style="float:left;"><span style="margin-right: 1em;"><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="historyAnalysis(\'' + vehicleNo + '\')">Analysis on Map</button></span><span><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="createLandmark(\'' + vehicleNo + '\',\'' + latitude + '\',\'' + longtitude + '\')">Create Hub/POI</button><span></td></tr>' +
			'</table>' +
			'</div>';
		contentOne = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +
			'<table>' +
			'<tr><td></td><td>' + vehicleNo + '</td></tr>' +
			'</table>' +
			'</div>';
		
		contentTwo = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +
			'<table>' +
			'<tr><td></td><td>' + drivername + '</td></tr>' +
			'</table>' +
			'</div>';	
			
		infowindow = new google.maps.InfoWindow({
			content: content,
			marker: marker,
			maxWidth: 300,
			disableAutoPan: true,
			image: image,
			id: vehicleNo
		});
		infowindowOne = new google.maps.InfoWindow({
			contents: contentOne,
			marker: marker,
			maxWidth: 200,
			disableAutoPan: true,
			image: image,
			id: vehicleNo
		});
<!--		infowindowTwo = new google.maps.InfoWindow({-->
<!--			contents: contentTwo,-->
<!--			marker: marker,-->
<!--			maxWidth: 200,-->
<!--			image: image-->
<!--			-->
<!--		});-->
		google.maps.event.addListener(marker, 'click', (function(marker, contents, infowindow) {
			return function() {
				firstLoadDetails = 1;
				if(document.getElementById("c2").checked == true){
				showlabel = "true";
				}
				//showDetails(false);
				showDetailsForLargeInfoWindow(false);
				infowindow.setContent(content);
				infowindow.open(map, marker);
				loadMapViewDetails(marker.id);
				if (sliderArray.length == 0) {
					$mpContainer.removeClass('mp-container-fitscreen');
					$mpContainer.addClass('mp-container');
					slider();
					sliderArray.push(marker.id);
				}
				//var bounds = new google.maps.LatLngBounds(marker.position);
				//map.fitBounds(bounds);
				// if (map.getZoom() > 16) map.setZoom(12);        			       			
			};
		})(marker, content, infowindow));
		google.maps.event.addListener(infowindow, 'closeclick', function() {
			document.getElementById("c2").checked = false;
			if (sliderArray.length <= 1) {
				if (mapviewFullScreen == 1) {
					document.getElementById('option-fullscreen').style.display = 'none';
					document.getElementById('option-normal').style.display = 'block';
					$mpContainer.removeClass('mp-container-fitscreen');
				} else {
					$mpContainer.addClass('mp-container-fitscreen');
				}
				unLoadMapViewDetails();
				firstLoadDetails = 0;
				slider();
				sliderArray.length = 0;
			}

			if (sliderArray.length > 1) {
				sliderArray.shift();
				unLoadMapViewDetails();
			}
		});
		
		if(grid.getColumnModel().findColumnIndex('drivername') === 1){
							
    	    			    infowindowOne.setContent(contentTwo);
		}else{
								
    	    			     infowindowOne.setContent(contentOne);
		}
	    				
		

		if(animate == "true")
		{
			marker.setAnimation(google.maps.Animation.DROP);
		}
		if (location != 'No GPS Device Connected') {
			bounds.extend(pos);
		}else
		{
		if(document.getElementById("c5").checked)
			{
			map.setZoom(zoompercent);
			map.fitBounds(zoomlevel);
			}
		}
		markerClusterArray.push(marker);
		infowindows[vehicleNo] = infowindow;
		markers[vehicleNo] = marker;
		infowindowsOne[vehicleNo] = infowindowOne;
		infowindowsTwo[drivername] = infowindowTwo;
		if(showlabel == "true"){
        showDetails(document.getElementById("c2"));
		}
		
	}	    
	    


//********************************* Select All ********************************************************

	function selecAllVehicles(cb) {
		if (previousVehicleType != 'noGPS') {
			var vehicles = grid.getSelectionModel().getSelections();
			Ext.iterate(vehicles, function(vehicle, index) {
				if (store.getAt(grid.getStore().indexOf(vehicle)).data['location'] != 'No GPS Device Connected') {
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
					if(typeof marker !== "undefined"){
						marker.setMap(null);
					}
				}
			});
			removePrevLatLongMarker();
		}
		//listView = "false";
		if (cb.checked) {
			selectAll = "true";
			var countAll = 0;
			//document.getElementById("c2").disabled = false;
			markerClusterArray.length = 0;
			for (var k = 0; k < store.getCount(); k++) {
				var recnew = store.getAt(k);
				if (!recnew.data['latitude'] == 0 && !recnew.data['longitude'] == 0) {
					countAll++;
					
					plotSingleVehicle(recnew.data['vehicleNo'],recnew.data['drivername'], recnew.data['latitude'], recnew.data['longitude'], recnew.data['location'], recnew.data['gmt'], recnew.data['category'], recnew.data['imagePath'],  recnew.data['LRNO'], recnew.data['tripNo'], recnew.data['routeName'],recnew.data['vehicleImageServerPath']);
				}
			}
			grid.getSelectionModel().selectAll();
			selectAllCheckClicked = 1;
			markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
			if (countAll > 0) {
			if(document.getElementById("c5").checked)
			{
			map.setZoom(zoompercent);
			map.fitBounds(zoomlevel);
			}else
			{
			map.fitBounds(bounds);
			}
			}
			if(countAll>300)
			{
		
			document.getElementById("c2").disabled = true;
			}
   			
		} else {
			selectAll = "deselect";
			selectAllCheckClicked = 0;
			markerCluster.clearMarkers();
			mapViewAssetDetails.removeAll();
			markerClusterArray.length = 0;
			<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
			document.getElementById('<%=detailsID%>').innerHTML = '';
			<%}%>
			grid.getSelectionModel().clearSelections();
			document.getElementById("c2").disabled = false;
			<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
			document.getElementById('<%=detailsID%>').innerHTML = '';
			<%}%>
			mapViewAssetDetails.removeAll();

		}
	}   
	    
	function getNonCommStatusData() {
		setTimeout(function() {
			var selected = grid.getSelectionModel().getSelected();
			var name = selected.get('vehicleNo');
			mapViewNonCommStatus.load({
				params: {
					vehicleNo: name,
					customerID: <%=customeridlogged%>
				},
				callback: function() {
					if (mapViewNonCommStatus.getCount() > 0) {
						var record = mapViewNonCommStatus.getAt(0);
						document.getElementById('assetno-id').innerHTML = record.data['vehicleNo'];
						document.getElementById('lastlocation-id').innerHTML = record.data['lastCommLocation'];
						document.getElementById('lastgmt-id').innerHTML = record.data['lastCommDateTime'];
						document.getElementById('noncommhours-id').innerHTML = record.data['nonCommHours'];
						document.getElementById('mainpower-id').innerHTML = record.data['mainPower'];
						document.getElementById('invalidpacket-id').innerHTML = record.data['invalidPacket'];
						document.getElementById('batteryhealth-id').innerHTML = record.data['batteryHealth'];
						document.getElementById('batteryvoltage-id').innerHTML = record.data['batteryVoltage'];
						document.getElementById('mainpowerlocation-id').innerHTML = record.data['mainPowerOffLocation'];
						document.getElementById('mainpowergmt-id').innerHTML = record.data['mainPowerOffTime'];
						document.getElementById('staellite-id').innerHTML = record.data['noOfSatellites'];
						storeCommStatus.load({
							params: {
								vehicleNo: name,
								customerID: <%=customeridlogged%>,
								lastcommtime: record.data['lastCommGMTDateTime']
							}

						});
					}
				}
			}), 1000
		});
	}    
    
//********************************* Remove Vehicle Marker**********************************************	    
	   function removeVehicleMarker(vehicleNo)
	    {
    	   if(previousVehicleType!='noGPS') {
	    	   if(markers[vehicleNo]!=null){
  				var marker = markers[vehicleNo];
    			marker.setMap(null);
    			if(markerCluster){
    			markerCluster.removeMarker(marker);
    			var index = markerClusterArray.indexOf(marker);
    			if(index>-1){
    			markerClusterArray.splice(index, 1);
    			}    			
    			}    			
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
	        <%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
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

	function GRID(){
		vehicleDetailsStore.load({
			params:{jspName:jspName,vehicleType:document.getElementById("vehicletype").value } 
		});
	}

//********************************** Refresh Vehicles every 5 min*****************************************************

function refreshVehicle()
{       
	
		refreshcount=1;
		if(selectAll=='true'){
		markerCluster.clearMarkers();
		markerClusterArray.length=0;		
		}
		//mapZoom=map.getZoom();
		//var mapZoomRefresh=map.getZoom();
		//var center=map.getCenter();
        previousSelectedRow=-1;
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
		    <%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
	        document.getElementById('<%=detailsID%>').innerHTML='';
			<%}%>
	        
	     if(mapviewFullScreen==1)
	    {
	   	Ext.getCmp('vehiclePannel').hide();
	    mapFullScreen();
	  
	    }else
	    {	   
	    reszieFullScreen();
	    }
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
				if(document.getElementById("c2").checked == true){
				showlabel = "true";
				}
			//showDetails(false); 	 
		}
		
		firstLoadDetails=0;
        sliderArray.length=0;
        slider();
					
	    store.load({
    	params:{vehicleType:previousVehicleType},
    	callback:function(){
    	
			for(i=0; i<selVehicles.length; i++) {
    		removeVehicleMarker(selVehicles[i]);
			}
			removePrevLatLongMarker();
			selectedVehIndex = selectedIdx.length;
			grid.getSelectionModel().selectRows(selectedIdx);
			///map.setZoom(mapZoomRefresh);
			//map.setCenter(center);
			refreshcount=0;
			selectedVehIndex=0;
			if(selectAll=='true'){
			
    	 	markerCluster = new MarkerClusterer(map, markerClusterArray,mcOptions); 
    		}
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
				fields: ['longitude','latitude','buffername','radius','imagename']
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
				url: '<%=request.getContextPath()%>/MapView.do?param=getCashVanMapViewVehicleDetails&processID='+<%=processID%>,
				id:'MapViewVehicleDetails',
				root: 'MapViewVehicleDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['vehicleType','model','ownerName','status','cashin','cashout','cashbalance','vehicleNo','gmt','location','ignition','drivername','groupname','ownerNumber','drivermobile','speed','temperature','direction', 'LRNO', 'tripNo', 'routeName', 'customerName', 'etaDest', 'etaNextPt', 'delay', 'currentStoppageTime', 'currentIdlingTime', 'ATD','obd']
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
				fields: ['vehicleNo','lastCommLocation','lastCommDateTime','nonCommHours','mainPower','mainPowerOffLocation','mainPowerOffTime','invalidPacket','batteryHealth','batteryVoltage','noOfSatellites','lastCommGMTDateTime']
		});		
		
		var borderStore=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/MapView.do?param=getBorderForMapView',
			id:'borderMapView',
			root: 'borderMapView',
			autoLoad: false,
			remoteSort: true,
			fields: ['longitude','latitude','borderName','borderSequence','borderHubid','lat','long','borderRadius']
		});
		var serviceStationStore = new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/MapView.do?param=getServiceStation',
			id:'serviceStationStoreId',
			root: 'serviceStationRoot',
			autoLoad: false,
			remoteSort: true,
			fields: ['serviceStationName','longitude','latitude','sequenceNo','hubId','lat','long','radius']
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
		function showServiceStation(cb){
	    	if(cb.checked){
	    		var selectedRecord = grid.getSelectionModel().getSelected();
				var vehicleMake = store.getAt(grid.getStore().indexOf(selectedRecord)).data['vehicleMake'];
				var groupId = store.getAt(grid.getStore().indexOf(selectedRecord)).data['groupId'];
				if(grid.getSelectionModel().getCount() == 1){
		    		loadMask.show();
		    		serviceStationStore.load({
		    			params : {assetMake:vehicleMake,groupId:groupId},
		    			callback:function(){
		    				plotServiceStation();
		    				loadMask.hide();
		    			}
		    		});
	    		}else{
	    			Ext.example.msg("You can select only one vehicle");
					return false;
	    		}
	    	}else{
	    		removeServiceStation();
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
	    		removeBorder();
	    	}
	    }
	    
	    function setZoomToMap(cz)
	    {
	    if(cz.checked)
	    	{
	    	zoompercent = map.getZoom();
	    	zoomlevel = map.getBounds();			
	    	}
	    }
	    
	    
	    function plotBorder(){
  			var hubid=0;
	   	    var borderCoords=[];
	   	    var circleBorderCount=0;
	    for(var i=0;i<borderStore.getCount();i++)
	    {	    	
	    	var rec=borderStore.getAt(i);
	    	
	    	if(rec.data['borderSequence']==0){
	    	
	    		var convertRadiusToMeters = rec.data['borderRadius'] * 1000;
   				var myBorderLatLng = new google.maps.LatLng(rec.data['lat'],rec.data['long']);       
       				createBorderCircle = {
           				strokeColor: '#A7A005',
   						strokeOpacity: 0.8,
   						strokeWeight: 3,
   						fillColor: '#ECF086',
           				fillOpacity: 0.55,
           				map: map,
           				center: myBorderLatLng,
           				radius: convertRadiusToMeters //In meters
       				};	    
          
 				borderCircleImage = {
       				url: '/ApplicationImages/VehicleImages/border.png', // This marker is 20 pixels wide by 32 pixels tall.
       				scaledSize: new google.maps.Size(19, 35), // The origin for this image is 0,0.
       				origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
       				anchor: new google.maps.Point(0, 32)
   				};      

 				borderCircleMarker = new google.maps.Marker({
           			position: myBorderLatLng,            	
           			map: map,
           			icon:borderCircleImage
       			});
       	
       			var borderCircleContent=rec.data['borderName']; 
				borderCircleInfowindow = new google.maps.InfoWindow({
      			content:borderCircleContent,      	
     			marker:borderCircleMarker
 				});	
 	
  				google.maps.event.addListener(borderCircleMarker,'click', (function(borderCircleMarker,borderCircleContent,borderCircleInfowindow){ 
   					return function() {
        			borderCircleInfowindow.setContent(borderCircleContent);
        			borderCircleInfowindow.open(map,borderCircleMarker);
   					};
					})(borderCircleMarker,borderCircleContent,borderCircleInfowindow)); 
					borderCircleMarker.setAnimation(google.maps.Animation.DROP); 

    				borderCircleMarkers[circleBorderCount]=borderCircleMarker;
					borderCircles[circleBorderCount] = new google.maps.Circle(createBorderCircle); 
					circleBorderCount++;
	    	
	    	}else{
	    	
	    	if(i!=borderStore.getCount()-1 && rec.data['borderHubid']==borderStore.getAt(i+1).data['borderHubid'])
	    	{
	    	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	borderCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	borderCoords.push(latLong);
	    	borderCoords.push(borderCoords[0]);
			}  			
  				
  				borderPolyline = new google.maps.Polyline({ 
		    		path: borderCoords,
		    		strokeColor: '#ff0000',
		    		strokeOpacity: 1.0,
		    		strokeWeight: 3,
	        		map: map
	        		});	
	        		
	        borderImage = {
	        	url: '/ApplicationImages/VehicleImages/border.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	}; 	
  				
  			  borderMarker = new google.maps.Marker({
            	position:latLong,
            	map: map,
            	icon:borderImage
        	});
        	var borderContent=rec.data['borderName'];
			borderInfowindow = new google.maps.InfoWindow({
      			content:borderContent,
      			marker:borderMarker
  		});	
  		
     	google.maps.event.addListener(borderMarker,'click', (function(borderMarker,borderContent,borderInfowindow){ 
    			return function() {
        			borderInfowindow.setContent(borderContent);
        			borderInfowindow.open(map,borderMarker);
    			};
			})(borderMarker,borderContent,borderInfowindow)); 
			borderMarker.setAnimation(google.maps.Animation.DROP); 
  			borderPolyline.setMap(map);
  			borderPolylines[hubid]=borderPolyline;
  			borderMarkers[hubid]=borderMarker;
  			//polygonmarkers[hubid]=polygonmarker;
  			hubid++;
  			borderCoords=[];
	    	
	    	}
	    	
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

///***************************************** Show Details********************************************	    
	    
	    function showDetails(cb)
	    {	
	    		 var driverId = grid.getColumnModel().findColumnIndex('drivername');
	    		var vehicles = grid.getSelectionModel().getSelections(); 
	    		if(vehicles.length ==0)
	    		document.getElementById("c2").checked = false;
	    		else
	    		{
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
					if(cb.checked)
	    			{
	    			
					
					if(grid.getColumnModel().findColumnIndex('drivername') === 1){
						//	infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
							infowindowsOne[infowindowId].open(map, markers[infowindowId]); 
    	    			    infowindowOne.setContent(contentTwo);
						}else{
						//	infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
							infowindowsOne[infowindowId].open(map, markers[infowindowId]); 
    	    			     infowindowOne.setContent(contentOne);
						}
	    				
    	    		}
    	    		else
    	    		{
    	    			infowindowsOne[infowindowId].setMap(null);
    	    		}
    	    		}
				}); 
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
		    	    		if(grid.getColumnModel().findColumnIndex('drivername') === 1){
								infowindowsOne[infowindowId].open(map, markers[infowindowId]); 
		   	    			    infowindowOne.setContent(contentTwo);
							} else {
								infowindowsOne[infowindowId].open(map, markers[infowindowId]); 
		   	    			    infowindowOne.setContent(contentOne);
							}
	    	    		}
	    	    		else {
	    	    			infowindows[infowindowId].setMap(null);
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
/******************************************* Plot Service Station *********************************************/	
	function plotServiceStation() {
		var hubid = 0;
		var serviceStationCoords = [];
		var circleServiceStationCount = 0;
		for (var i = 0; i < serviceStationStore.getCount(); i++) {
			var rec = serviceStationStore.getAt(i);

			if (rec.data['sequenceNo'] == 0) {

				var convertRadiusToMeters = rec.data['radius'] * 1000;
				var serviceStationLatLng = new google.maps.LatLng(rec.data['lat'], rec.data['long']);
				createServiceStationCircle = {
					strokeColor: '#A7A005',
					strokeOpacity: 0.8,
					strokeWeight: 3,
					fillColor: '#ECF086',
					fillOpacity: 0.55,
					map: map,
					center: serviceStationLatLng,
					radius: convertRadiusToMeters
				};

				serviceStationCircleImage = {
					url: '/ApplicationImages/VehicleImages/information.png',
					scaledSize: new google.maps.Size(19, 35),
					origin: new google.maps.Point(0, 0), 
					anchor: new google.maps.Point(0, 32)
				};

				bufferMarkerForServiceSt = new google.maps.Marker({
					position: serviceStationLatLng,
					map: map,
					icon: serviceStationCircleImage
				});

				var bufferContentForServiceSt = rec.data['serviceStationName'];
				bufferInfoWindowForServiceSt = new google.maps.InfoWindow({
					content: bufferContentForServiceSt,
					marker: bufferMarkerForServiceSt
				});

				google.maps.event.addListener(bufferMarkerForServiceSt, 'click', (function(bufferMarkerForServiceSt, bufferContentForServiceSt, bufferInfoWindowForServiceSt) {
					return function() {
						bufferInfoWindowForServiceSt.setContent(bufferContentForServiceSt);
						bufferInfoWindowForServiceSt.open(map, bufferMarkerForServiceSt);
					};
				})(bufferMarkerForServiceSt, bufferContentForServiceSt, bufferInfoWindowForServiceSt));
				bufferMarkerForServiceSt.setAnimation(google.maps.Animation.DROP);

				bufferMarkerForServiceSts[circleServiceStationCount] = bufferMarkerForServiceSt;
				circlesForServiceSt[circleServiceStationCount] = new google.maps.Circle(createServiceStationCircle);
				circleServiceStationCount++;

			} else {

				if (i != serviceStationStore.getCount() - 1 && rec.data['hubId'] == serviceStationStore.getAt(i + 1).data['hubId']) {
					var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
					serviceStationCoords.push(latLong);
					continue;
				} else {
					var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
					serviceStationCoords.push(latLong);
					serviceStationCoords.push(serviceStationCoords[0]);
				}

				sericeStationPolyline = new google.maps.Polyline({
					path: serviceStationCoords,
					strokeColor: '#ff0000',
					strokeOpacity: 1.0,
					strokeWeight: 3,
					map: map
				});

				sericeStationImage = {
					url: '/ApplicationImages/VehicleImages/border.png', 
					size: new google.maps.Size(48, 48), 
					origin: new google.maps.Point(0, 0),
					anchor: new google.maps.Point(0, 32)
				};

				serviceStationMarker = new google.maps.Marker({
					position: latLong,
					map: map,
					icon: sericeStationImage
				});
				var serviceStationContent = rec.data['serviceStationName'];
				serviceStationInfoWindow = new google.maps.InfoWindow({
					content: serviceStationContent,
					marker: serviceStationMarker
				});

				google.maps.event.addListener(serviceStationMarker, 'click', (function(serviceStationMarker, serviceStationContent, serviceStationInfoWindow) {
					return function() {
						serviceStationInfoWindow.setContent(serviceStationContent);
						serviceStationInfoWindow.open(map, serviceStationMarker);
					};
				})(serviceStationMarker, serviceStationContent, serviceStationInfoWindow));
				serviceStationMarker.setAnimation(google.maps.Animation.DROP);
				sericeStationPolyline.setMap(map);
				serviceStation[hubid] = sericeStationPolyline;
				serviceStationMarkers[hubid] = serviceStationMarker;				
				hubid++;
				serviceStationCoords = [];
			}
		}
	}
	
	function removeServiceStation(){
		for (var i = 0; i < serviceStation.length; i++) {
		    serviceStation[i].setMap(null);
		    serviceStationMarkers[i].setMap(null);
		}
		serviceStation.length = 0;
		serviceStationMarkers.length = 0;
		
		for (var i = 0; i < circlesForServiceSt.length; i++) {
		    circlesForServiceSt[i].setMap(null);
		    bufferMarkerForServiceSts[i].setMap(null);
		}
		circlesForServiceSt.length = 0;
		bufferMarkerForServiceSts.length = 0;
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
            		name: 'groupId'
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
        		 } ,
        		 {
        		    name:'imagePath'
        		 } ,
        		 {
        		    name:'imageIcon'
        		 },
        		 {
        		    name:'vehicleMake'
        		 }  ,
        		 {
        		    name:'LRNO'
        		 } ,
        		 {
        		    name:'tripNo'
        		 },
        		 {
        		    name:'routeName'
        		 } ,
        		 {
        		    name:'vehicleImageServerPath'
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
        },{ 
        	dataIndex: 'drivername',
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
    	 //{
    //    header: "<span style=font-weight:bold;><%=vehicleNo%> (<%=vehicleId%>)</span>",
     //   sortable: true,
     //    menuDisabled:true,
     //   dataIndex: 'assetNo',
     //   width:150
   // 	},
    //	{
    //    header: "<span style=font-weight:bold;>Image</span>",
     //   sortable: true,
    //    menuDisabled:true,
    //    dataIndex: 'imageIcon',
     //   width:50
    //	},{
    //	header: "<span style=font-weight:bold;><%=groupName%></span>",
     //   sortable: true,          
      //  dataIndex: 'groupname',
    //    width:200
    //	},{
    //	header: "<span style=font-weight:bold;>Driver Name</span>",
      //  sortable: true,          
      //  dataIndex: 'drivername',
       // width:200
    //	},
    	 <%=liveVisionColumns.getGridHeaderBufferFromUserSetting(
					processID, language, systemid, customeridlogged, userId)
					.toString()%>
    	]
		});

	grid = new Ext.grid.EditorGridPanel({
		bodyCssClass: 'editorgridstyles',
		id:'mapViewGridId',
		view: new Ext.grid.GroupingView({
			groupTextTpl: getGroupConfig(),
			emptyText: 'No Records Found',
			deferEmptyText: false

		}),
		store: store,
		colModel: colModel,
		selModel: selModel,
		autoScroll: true,
		loadMask: true,
		plugins: [filters]
	});

	selModel.on('rowselect', function(selModel, index, record) {
		 clearInterval(interval);
		 var rec = grid.store.getAt(index);
		 var selectedRowsPlot = grid.getSelectionModel().getSelections();
		 var rowCount=grid.getSelectionModel().getSelections();
<!--		 if(rowCount.length == store.getCount()){-->
<!--    			document.getElementById("selectAll").checked = true;-->
<!--    			//selecAllVehicles(document.getElementById("selectAll"));-->
<!--    	}-->
		 removePolylineTrace();
   		 if(markerFlag != null)
   		 {
   			markerFlag.setMap(null);
   		 }
   		 if(selectedListVeh <= 1)
   		 {
   		 	if(selectAll != 'true')
   		 	{
		    	if(selectedRowsPlot.length == 1)
				{
				        if(selectedVehIndex <= 1)
				        {
					   		loadData(rec.data['vehicleNo']);
					   		animate = "false";
					   		setTimeout(function(){plotVehicleImage(selModel,index,record)},4000);
					   		if(<%=systemid%> == 27 && ( <%=customeridlogged%> == 2123 || <%=customeridlogged%> == 5020 || <%=customeridlogged%> == 5196 || <%=customeridlogged%> == 5206)){
					   			interval = setInterval(function(){refreshVehicle()},20000);
					   		}else{
					   			interval = setInterval(function(){refreshVehicle()},60000);
					   		}
				   		} else {
				   			plotVehicleImage(selModel,index,record);
				   			if(<%=systemid%> == 27 && ( <%=customeridlogged%> == 2123 || <%=customeridlogged%> == 5020 || <%=customeridlogged%> == 5196 || <%=customeridlogged%> == 5206)){
				   				interval = setInterval(function(){refreshVehicle()},20000);
				   			}else{
				   				interval = setInterval(function(){refreshVehicle()},180000);
				   			}
				   			
				   		}
			    } else {
			    	animate = "true";
			    	plotVehicleImage(selModel,index,record);
			    	if(<%=systemid%> == 27 && ( <%=customeridlogged%> == 2123 || <%=customeridlogged%> == 5020 || <%=customeridlogged%> == 5196 || <%=customeridlogged%> == 5206)){
		   				interval = setInterval(function(){refreshVehicle()},20000);
		   			}else{
		   				interval = setInterval(function(){refreshVehicle()},180000);
		   			}
		        }
	        } else {
	        		animate = "true";
			    	plotVehicleImage(selModel,index,record);
			    	if(<%=systemid%> == 27 && ( <%=customeridlogged%> == 2123 || <%=customeridlogged%> == 5020 || <%=customeridlogged%> == 5196 || <%=customeridlogged%> == 5206)){
		   				interval = setInterval(function(){refreshVehicle()},20000);
		   			}else{
		   				interval = setInterval(function(){refreshVehicle()},180000);
		   			}
	        }
	    } else {
	    	animate = "true";
	    	plotVehicleImage(selModel,index,record);
	    	if(<%=systemid%> == 27 && ( <%=customeridlogged%> == 2123 || <%=customeridlogged%> == 5020 || <%=customeridlogged%> == 5196 || <%=customeridlogged%> == 5206)){
   				interval = setInterval(function(){refreshVehicle()},20000);
   			}else{
   				interval = setInterval(function(){refreshVehicle()},180000);
   			}
	    }
	});  

	selModel.on('rowdeselect', function(selModel, index, record) {
		var selectedRows = selModel.getSelections();
		var rec = grid.store.getAt(index);
		var rowCount=grid.getSelectionModel().getSelections();
		//listView = "false";
<!--        if(rowCount.length < store.getCount()){-->
<!--    			document.getElementById("selectAll").checked = false;-->
<!--    			//markerCluster.clearMarkers();-->
<!--    				//selecAllVehicles(document.getElementById("selectAll"));-->
<!--    	}-->
        removePolylineTrace();
   		if(markerFlag != null)
   		{
   			markerFlag.setMap(null);
   		}
		if (!rec.data['latitude'] == 0 && !rec.data['longitude'] == 0) {
			removeVehicleMarker(rec.data['vehicleNo']);
			removePrevLatLongMarker();
		}
		if (selectedRows.length == 1) {
			var record = grid.getSelectionModel().getSelections();
			Ext.iterate(record, function(record, index) {
				//plotPrevLatLong(record.data['vehicleNo'], record.data['prevlat'], record.data['prevlong']);
			});
			if (detailspage != 1 && '<%=vehicleTypeRequest%>' == "noncomm") {
				document.getElementById('ackw-button-id').style.visibility = 'visible';
			}
			reszieFullScreen();
			if (button == "List") {
				reszieFullScreen1();
			}
			if (selectAll == "deselect") {
				<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
				document.getElementById('<%=detailsID%>').innerHTML = '';
				<%}%>
			}

		} else if (selectedRows.length == 0) {
			document.getElementById("c2").checked = false;
			document.getElementById('Location').innerHTML = '';
			document.getElementById('ackw-button-id').style.visibility = 'hidden';
			//removeServiceStation();
			if (firstLoadDetails == 1) {
				$mpContainer.addClass('mp-container-fitscreen');
			}
			firstLoadDetails = 0;
			sliderArray.length = 0;
			slider();
			<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
			document.getElementById('<%=detailsID%>').innerHTML = '';
			<%}%>

		}

	});
  
    function plotVehicleImage(selModel,index,record)
    {
    	if (selectAll != 'true' || refreshcount == 1) {
    	//alert("selectAll != 'true'");
			if (detailspage > 0) {
				if (previousSelectedRow != -1) {
					selModel.deselectRow(previousSelectedRow);
				}
				previousSelectedRow = index;
				getNonCommStatusData();
			}
			var selectedRows = selModel.getSelections();
			var rec = grid.store.getAt(index);
			
			var singleSelectCount = 0;
			if (!rec.data['latitude'] == 0 && !rec.data['longitude'] == 0) {
				singleSelectCount++;
				if(animate == "false")
				{
					if(infolist.length != 0)
					{
						historyLatitude = infolist[infolist.length-5];
						historyLogitude = infolist[infolist.length-4];
						historyLocation = infolist[infolist.length-3];
						historyGmt = infolist[infolist.length-6];
						historySpeed = infolist[infolist.length-2];
						plotSingleVehicle(rec.data['vehicleNo'],rec.data['drivername'], historyLatitude, historyLogitude, historyLocation, historyGmt, rec.data['category'], rec.data['imagePath'], rec.data['LRNO'],rec.data['tripNo'],rec.data['routeName'],rec.data['vehicleImageServerPath']);
					} else {
						plotSingleVehicle(rec.data['vehicleNo'],rec.data['drivername'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'], rec.data['LRNO'],rec.data['tripNo'],rec.data['routeName'],rec.data['vehicleImageServerPath']);
					}
				} else {
					plotSingleVehicle(rec.data['vehicleNo'],rec.data['drivername'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'], rec.data['LRNO'],rec.data['tripNo'],rec.data['routeName'],rec.data['vehicleImageServerPath']);
				}
				if (selectedRows.length == 1) {
					//plotPrevLatLong(rec.data['vehicleNo'], rec.data['prevlat'], rec.data['prevlong']);
				}
			}
			if (singleSelectCount > 0) {
			if(document.getElementById("c5").checked)
	    	{
	    	 //zoompercent = map.getZoom();
	    	 //zoomlevel = map.getBounds();
	    	 map.setZoom(zoompercent);
	    	 map.fitBounds(zoomlevel);
	    	}else
	    	{
	    	 map.fitBounds(bounds);
	    	}
				
			}
			var listener = google.maps.event.addListener(map, "idle", function() {
			if(document.getElementById("c5").checked)
	    	{
				map.setZoom(zoompercent);
			}else
			{
			if (map.getZoom() > 16) map.setZoom(mapZoom);
			}
				google.maps.event.removeListener(listener);
			});

			if (selectedRows.length > 1) {
				document.getElementById('ackw-button-id').style.visibility = 'hidden';
				removePrevLatLongMarker();
			} else if (selectedRows.length == 1) {
				if (detailspage != 1 && '<%=vehicleTypeRequest%>' == "noncomm") {
					document.getElementById('ackw-button-id').style.visibility = 'visible';
				}

			} else if (selectedRows.length == 0) {
				<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
				document.getElementById('<%=detailsID%>').innerHTML = '';
				<%}%>
			}
		} else if (selectAllCheckClicked == 1) {
			if (detailspage > 0) {
				if (previousSelectedRow != -1) {
					selModel.deselectRow(previousSelectedRow);
				}
				previousSelectedRow = index;
				getNonCommStatusData();
			}
			var selectedRows = selModel.getSelections();
			var rec = grid.store.getAt(index);
			var singleSelectCount = 0;
			if (!rec.data['latitude'] == 0 && !rec.data['longitude'] == 0) {
				singleSelectCount++;			
				if(animate == "false")
				{
					if(infolist.length != 0)
					{
						historyLatitude = infolist[infolist.length-5];
						historyLogitude = infolist[infolist.length-4];
						historyLocation = infolist[infolist.length-3];
						historyGmt = infolist[infolist.length-6];
						historySpeed = infolist[infolist.length-2];
						plotSingleVehicle(rec.data['vehicleNo'],rec.data['drivername'], historyLatitude, historyLogitude, historyLocation, historyGmt, rec.data['category'], rec.data['imagePath'], rec.data['LRNO'],rec.data['tripNo'],rec.data['routeName'],rec.data['vehicleImageServerPath']);
					} else {
						plotSingleVehicle(rec.data['vehicleNo'],rec.data['drivername'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'], rec.data['LRNO'],rec.data['tripNo'],rec.data['routeName'],rec.data['vehicleImageServerPath']);
					}
				} else {
					plotSingleVehicle(rec.data['vehicleNo'],rec.data['drivername'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'], rec.data['LRNO'],rec.data['tripNo'],rec.data['routeName'],rec.data['vehicleImageServerPath']);
				}
				if (selectedRows.length == 1) {
					//plotPrevLatLong(rec.data['vehicleNo'], rec.data['prevlat'], rec.data['prevlong']);
				}
			}
			if (singleSelectCount > 0) {
				if (markerCluster) {
					markerCluster.clearMarkers();
					markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
				}
				if(animate == "true"){
				if(document.getElementById("c5").checked)
	    		{
	    		 zoompercent = map.getZoom();
	    	 	zoomlevel = map.getBounds();
	    	 	map.setZoom(zoompercent);
	    	 	map.fitBounds(zoomlevel);
	    		}else
	    		{
	    	 	map.fitBounds(bounds);
	    		}
				}
			}
			var listener = google.maps.event.addListener(map, "idle", function() {
				if(document.getElementById("c5").checked)
	    	{
				 map.setZoom(zoompercent);
			}else
			{
			if (map.getZoom() > 16) map.setZoom(mapZoom);
			}
				google.maps.event.removeListener(listener);
			});

			if (selectedRows.length > 1) {
				document.getElementById('ackw-button-id').style.visibility = 'hidden';
				removePrevLatLongMarker();
			} else if (selectedRows.length == 1) {
				if (detailspage != 1 && '<%=vehicleTypeRequest%>' == "noncomm") {
					document.getElementById('ackw-button-id').style.visibility = 'visible';
				}

			} else if (selectedRows.length == 0) {
				<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
				document.getElementById('<%=detailsID%>').innerHTML = '';
				<%}%>
			}

		}
		$("#mp-container").unmask();
		$("#mapViewGridId").unmask();
    }
    
 	function startfilter() {
		if (markerCluster) {
			markerCluster.clearMarkers();
			markerClusterArray.length = 0;
		}
		var selectedRows = selModel.getSelections();
		if (Ext.getCmp('searchVehicle').getValue() != '') {
			document.getElementById("selectAll").checked = false;
			selectAll = "false";
			removePrevLatLongMarker();
			grid.getSelectionModel().clearSelections();
			document.getElementById("c2").disabled = false;
			selectAllCheckClicked = 0;
		}
		var val = Ext.getCmp('searchVehicle').getValue();
		var cm = this.grid.getColumnModel();
		var filter = this.grid.filters.filters.get(cm.getDataIndex(1));
		filter.setValue(val);
		if (val != "") {
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
                    		emptyText:'Search Vehicle/Vehicle Id',
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
   
 function plotPrevLatLong(vehicleNo,prevlat,prevlong){
		var latlongmarker; 		    
	    if(prevlat != 0.0 && prevlong != 0.0)
		{
		   var myLatlng = new google.maps.LatLng(prevlat,prevlong);	
		   var image = {
			url: '/ApplicationImages/VehicleImages/redcirclemarker.png', // This marker is 20 pixels wide by 32 pixels tall.
			scaledSize: new google.maps.Size(30, 30)
		   };	   
		   latlongmarker = new google.maps.Marker({
			      position: myLatlng,
			      id : vehicleNo,
			      map: map,			      
			      icon:	image				     
  			}); 
  		 	latlongmarkers.push(latlongmarker);	 			
		}
			
 } 
plotRulerMarkerNew(map,'#startRulerId','#removeRulerId',distanceUnits);      

function slider()
{  var effect = 'slide';
  
    var options = { direction: 'right' };
  
    var duration = 500;
    if($('#vehicle-details').is(":visible")){ 
 	 $('#vehicle-details').toggle(effect, options, duration);	
 	 }
 	 if(firstLoadDetails==1){
 	  $('#vehicle-details').toggle(effect, options, duration);	
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
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Latitude').innerHTML=rec.data['latitude'];
									} else {
										document.getElementById('Latitude').innerHTML=rec.data['latitude'];
									}
								}
								if(document.getElementById('Longitude')!= null )
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Longitude').innerHTML=rec.data['longitude'];
									} else {
										document.getElementById('Longitude').innerHTML=rec.data['longitude'];
									}
								}
								if(document.getElementById('Location')!=null)
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Location').innerHTML=rec.data['location'];
									} else {
								 		document.getElementById('Location').innerHTML=rec.data['location'];
								 	}
								}								
								if(document.getElementById('Vehicle_Group')!=null )
								{
								document.getElementById('Vehicle_Group').innerHTML=record.data['groupname'];
								}
								 if (document.getElementById('Date_Time')!=null )
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Date_Time').innerHTML=rec.data['gmt'];
									} else {
										document.getElementById('Date_Time').innerHTML=rec.data['gmt'];
									}
								}
								 if (document.getElementById('Speed') !=null )
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Speed').innerHTML=record.data['speed'];
									} else {
										document.getElementById('Speed').innerHTML=record.data['speed'];	
									}
								}
								if (document.getElementById('Driver_Name')!=null)								
								{															
									if(record.data['drivername']==''||record.data['drivername']=="")
									{
										document.getElementById('Driver_Name').innerHTML='NA';
									}
									else
									{
										document.getElementById('Driver_Name').innerHTML=record.data['drivername'];
									}
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
								if (document.getElementById('Direction')!=null)
								{
								document.getElementById('Direction').innerHTML=record.data['direction'];
								}
								
								if (document.getElementById('LR_NO')!=null)								
								{
									if(record.data['LRNO']==''||record.data['LRNO']=="")
									{
										document.getElementById('LR_NO').innerHTML='NA';
									}
									else
									{
										document.getElementById('LR_NO').innerHTML=record.data['LRNO'];
									}
								}
								if (document.getElementById('Trip_No')!=null)								
								{
									if(record.data['tripNo']==''||record.data['tripNo']=="")
									{
										document.getElementById('Trip_No').innerHTML='NA';
									}
									else
									{
										document.getElementById('Trip_No').innerHTML=record.data['tripNo'];
									}
								}
								if (document.getElementById('Route_Name')!=null)								
								{								
									if(record.data['routeName']==''||record.data['routeName']=="")
									{
										document.getElementById('Route_Name').innerHTML='NA';
									}
									else
									{
										document.getElementById('Route_Name').innerHTML=record.data['routeName'];
									}
								}
								if (document.getElementById('Customer')!=null)								
								{
									if(record.data['customerName']==''||record.data['customerName']=="")
									{
										document.getElementById('Customer').innerHTML='NA';
									}
									else
									{
										document.getElementById('Customer').innerHTML=record.data['customerName'];
									}
								}
								if (document.getElementById('ETA_To_Next_Hub')!=null)								
								{
									if(record.data['etaNextPt']==''||record.data['etaNextPt']=="")
									{
										document.getElementById('ETA_To_Next_Hub').innerHTML='';
									}
									else
									{
										document.getElementById('ETA_To_Next_Hub').innerHTML=record.data['etaNextPt'];
									}
								}
								if (document.getElementById('ETA_To_Destination')!=null)								
								{
									if(record.data['etaDest']==''||record.data['etaDest']=="")
									{
										document.getElementById('ETA_To_Destination').innerHTML='';
									}
									else
									{
										document.getElementById('ETA_To_Destination').innerHTML=record.data['etaDest'];
									}
								}
								if (document.getElementById('Delay')!=null)								
								{
									if(record.data['delay']==''||record.data['delay']=="")
									{
										document.getElementById('Delay').innerHTML='NA';
									}
									else
									{ 									
										document.getElementById('Delay').innerHTML=convertMinutesToHHMM(record.data['delay']);
									}
								}
								if (document.getElementById('Stoppage_Time')!=null)								
								{
									if(record.data['currentStoppageTime']==''||record.data['currentStoppageTime']=="")
									{
										document.getElementById('Stoppage_Time').innerHTML='NA';
									}
									else
									{
										document.getElementById('Stoppage_Time').innerHTML=record.data['currentStoppageTime'];
									}
								}
								if (document.getElementById('Idle_Time')!=null)								
								{
									if(record.data['currentIdlingTime']==''||record.data['currentIdlingTime']=="")
									{
										document.getElementById('Idle_Time').innerHTML='NA';
									}
									else
									{
										document.getElementById('Idle_Time').innerHTML=record.data['currentIdlingTime'];
									}
								}
								if (document.getElementById('Actual_Trip_Start_Time')!=null)								
								{
									if(record.data['ATD']==''||record.data['ATD']=="")
									{
										document.getElementById('Actual_Trip_Start_Time').innerHTML='';
									}
									else
									{
										document.getElementById('Actual_Trip_Start_Time').innerHTML=record.data['ATD'];
									}
								}
								//obd TODO Sneha 
								if(record.data['obd'] != null && record.data['obd'].length>0){
										for(var i=0; i< record.data['obd'].length; i++){
											let id = record.data['obd'][i]['id'];
											let value = record.data['obd'][i]['value'];
											document.getElementById(id).innerHTML=value;
										}
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
		<%for (int i = 0; i < liveVisionColumns.getListOfIds().size(); i++) {
				detailsID = liveVisionColumns.getListOfIds().get(i);%>
	                        	document.getElementById('<%=detailsID%>').innerHTML = '';
			                <%}%>

}

function createLandmark(vehicleNo,lat,lon){
	  title="Create Hub/POI";
	  var reg = vehicleNo.replace(/ /g,"%20");
	  var locationPage="<%=request.getContextPath()%>/Jsps/Common/CreateLandmark.jsp?ipVal=true&vehicle="+reg+"&lat="+lat+"&lon="+lon;
      openLocationWindow(locationPage,title);	
    	
}	

function googlemaplink(vehicleNo,lat,lon){
    	window.open("http://www.google.com/maps/place/"+lat+","+lon);
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

//****************************OnReady*********************************//
Ext.onReady(function () {
    store.load({
    	params:{vehicleType:previousVehicleType},
    	callback:function(){
    		var vehicles=parent.document.getElementById('reglist').value;  
    		if(vehicles != null){  		
	    		vehicles = vehicles.substring(0, vehicles.length - 1);    		
	    		var selectedVehicle=vehicles.split("|");   
    			if(selectedVehicle.length == store.getCount()){
    				document.getElementById("selectAll").checked = true;
    				selecAllVehicles(document.getElementById("selectAll"));
    			}	
	    		for(var i =0; i<selectedVehicle.length;i++){
		    		selectedListVeh = selectedVehicle.length;
		    		ind=grid.store.findExact('vehicleNo', selectedVehicle[i]);
		    		if(ind > -1){
			       		selModel.selectRow(ind,true);
		       		} 
	    		}
	    	}
    	} 
    });    
});
	</script>
    </body>
</html> 
