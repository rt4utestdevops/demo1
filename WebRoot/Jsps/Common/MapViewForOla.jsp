
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
 	String mapTypeFromOpen = "";
 	if(request.getParameter("processId")!=null)
 	{
 	processID=Integer.parseInt((String)request.getParameter("processId")); 	 	
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
 	int countryId =0;// loginInfo.getCountryCode();
 	int mapType=loginInfo.getMapType(); 
 	int offset = loginInfo.getOffsetMinutes();
 	int customerId = loginInfo.getCustomerId();
 	int isLtsp = loginInfo.getIsLtsp();
	String countryName = "";//cf.getCountryName(countryId);
 	Properties properties = ApplicationListener.prop;
 	//String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	String vehicleImagePath = properties.getProperty("vehicleImagePath");
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
tobeConverted.add("Sim_Card_Installed_In_Device_May_Not_Be_Working");
tobeConverted.add("Device_May_Be_Tampered");
tobeConverted.add("Vehicle_May_Be_Out_of_Network_Coverage_Area");
tobeConverted.add("Device_Wire_May_Be_Loosley_Connected");
tobeConverted.add("Device_Health");
tobeConverted.add("Refresh");
tobeConverted.add("Show_Hubs");
//tobeConverted.add("Show_Details");
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
String vehicleId=convertedWords.get(33);
String showServiceStation=convertedWords.get(34);
String distUnits = cf.getUnitOfMeasure(systemid);
String latitudeLongitude = cf.getCoordinates(systemid);
MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
String mapName = bean.getMapName();
String appKey = bean.getAPIKey();
String appCode = bean.getAppCode();
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
	<script type="text/javascript" src="https://lovcombo.extjs.eu/js/Ext.ux.util.js"></script>	
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
	
	<jsp:include page="../Common/InitializeLeaflet.jsp" />
	<pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script>
  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>
  	
  	<link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
	<script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	<link  href="https://unpkg.com/leaflet-geosearch@latest/assets/css/leaflet.css" rel="stylesheet" />
	<script src="https://unpkg.com/leaflet-geosearch@latest/dist/bundle.min.js"></script>
	<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	<script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	<link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
  crossorigin=""></script>
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
	  @media screen and (device-width:1280px) {
	.noteinfo {
		margin-top: -7px;
	}
}
	  @media (device-width: 1280px) and (device-height: 720px) {
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
	  @media (device-width: 1280px) and (device-height: 800px) {
	      .openLayerButton {
	          margin-top: -462px!important;
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
	  .vehicle_marker{
		float:left;
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
	.leaflet-control-geosearch bar {
   height: 24px;
   padding: 6px 12px;
   font-size: 14px;
   line-height: 1.42857143;
   color: #555;
   background-color: #fff;
   background-image: none;
   border: 1px solid #aaa;
   border-radius: 4px;
   -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
   box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
   -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
   -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
   transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
}
#c2{	display:none;
}
#c3{	display:none;
}
#c4{	display:none;
}
#c5{	display:none;
}
#c1{	display:none;
}
input[type="checkbox"] {
    display: block;
}
#selectAll{
	display:none;
}
	</style>
	</head>
<!--    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&region=IN"></script>-->
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
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">1)<%=simCardInstalledInDeviceMayNotBeWorking %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) <%=deviceMayBeTampered%></span></li>
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
					<div class="mp-options-wrapper"/>		
					 <table width="98%" style="margin-top:8px;">
						<tr height="10px"><td > <div class="mp-option-showhub" id="show"></div></td>
<!--						<td>-->
<!--								<div>-->
<!--							<img class="ruler" id ="startRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerStart.gif" title="Start Ruler"/>							-->
<!--								</div>-->
<!--							</td>-->
<!--							<td>-->
<!--								<div>-->
<!--							<img  class="ruler" id ="removeRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerEnd.gif" title="Remove Ruler"/>							-->
<!--								</div>-->
<!--							</td>-->
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
            				<% if(systemid == 12 || systemid == 261){%>
            				<td width="15%"><div style="padding-left:13px">
								<input type="checkbox" id="c4" name="cc" onclick='showServiceStation(this);' />
            					<label for="c4"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showServiceStation%></span>
            				</div></td>
            				<%}%>
            				<td width="15%"><div style="padding-left:13px">
								<input type="checkbox" id="c3" name="cb" onclick='showBorder(this);'/>
            					<label for="c3"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showBorder%></span>
            				</div></td>
            				<td width="15%">
                           <div style="padding-left:13px">
                              <input type="checkbox" id="c5" name="cz" onclick='setZoomToMap(this);'/>
                              <label for="c5"><span></span></label>
                              <span class="vehicle-show-details-block"><%=setZoomToMap%></span>
                           </div>
                        </td>
            				<td width="25%"><div class ="checkBoxRegion"  style="display:block;">
								<input type="checkbox" id="c2" name="cc" onclick='showDetails(this);'/>
            					<label for="c2"><span></span></label>
            					<span class="vehicle-show-details-block"><%=showDetails%></span>
            				</div></td>
            				<td align="center"><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImagesNew/MapImages/Legend_BR.png">            				
							<span class="vehicle_marker_label" style="padding-right: 10px;"><%=stopped %></span></div></td>
							<td><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImagesNew/MapImages/Legend_BG.png">							
							<span  class="vehicle_marker_label" style="padding-right: 10px;"><%=running %></span></div></td>
							<td><div><img class="vehicle_marker" src="/ApplicationImages/VehicleImagesNew/MapImages/Legend_BL.png">							
							<span class="vehicle_marker_label"style="padding-right: 10px;"><%=idle%></span></div></td>
													
						<td style="width:0px;"><div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"  onclick="mapFullScreen()"></div></td>
						</tr></table>
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
		var jspName="Map View";
		var circle;
		var button="Map";
		var selectAll="false";
		var previousSelectedRow=-1;
		var contentOne;
		var layerGroup;
		var exportDataType="int,string,date,string,string,int,float,string,string,string,string,string,string,date";
		var ctsb;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		var previousVehicleType='<%=vehicleTypeRequest%>';
		var firstLoadDetails=0;
		var mapviewFullScreen=0;	
		var refreshcount=0;	
		var bounds = new L.LatLngBounds();
		var selectAllCheckClicked=0;
		var markerCluster;
		var markerClusterArray=[];
		var mcOptions = {gridSize: 20, maxZoom: 100};	
		var countryName = '<%=countryName%>';	
		var processID = '<%=processID%>';
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
		var vehicleList;
		var distanceUnits = '<%=distUnits%>';
		var showlabel = "false";
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
			}
		}
		
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
					 map.invalidateSize();
					
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
		 map.invalidateSize();
					
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
					map.invalidateSize();
					
		}
		var mapZoom = 14;
	
	initialize("map", new L.LatLng(<%=latitudeLongitude%>),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
   /* var GeoSearchControl = window.GeoSearch.GeoSearchControl;
    var OpenStreetMapProvider = window.GeoSearch.OpenStreetMapProvider;
    var provider = new OpenStreetMapProvider({});
    var searchControl = new GeoSearchControl({
		provider: provider,
		style: 'bar',
		showMarker: true,
		marker: {
		   draggable: false
		},
		autoClose: true,
		keepResult: true,
    });
    map.addControl(searchControl);*/
    var plugin = L.control.measure({
        //  control position
        position: 'bottomleft',
        //  weather to use keyboard control for this plugin
        keyboard: true,
        //  shortcut to activate measure
        activeKeyCode: 'M'.charCodeAt(0),
        //  shortcut to cancel measure, defaults to 'Esc'
        cancelKeyCode: 27,
        //  line color
        lineColor: 'red',
        //  line weight
        lineWeight: 2,
        //  line dash
        lineDashArray: '6, 6',
        //  line opacity
        lineOpacity: 1,
        //  distance formatter
        // formatDistance: function (val) {
        //   return Math.round(1000 * val / 1609.344) / 1000 + 'mile';
        // }
      }).addTo(map)
//***********************************Plot Vehicle on Map *******************************************

function createPolylineTrace(){
	 	var lon = 0.0;
		var lat = 0.0; 
		var flightPath=[];
		polylines = [];
		var BoundsForPlotting = new L.LatLngBounds();
		/*var lineSymbol = {
        	path: L.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
        	scale: 2,
        	fillColor: '#006400',
        	fillOpacity: 1.0
    	};*/
		for(var i=0;i<datalist.length;i++){
			lat = datalist[i];
		    lon = datalist[i+1];
		    if(i == 0)
		    {
			    var positionFlag = new L.LatLng(lat,lon);
		       /* markerFlag = new google.maps.Marker({
			    position: positionFlag,
			    map: map,
			    icon:'/ApplicationImages/VehicleImages/redcirclemarker.png'
			    });*/
			    image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/redcirclemarker.png',
                iconSize: [19, 19], // size of the icon
                popupAnchor: [0, -15]
            });
			    firstLatLong = positionFlag;
		    }
		    var latLong = new L.LatLng(lat,lon);
		    flightPath.push(latLong);  
		    if(i == (datalist.length - 3))
		    {
		        	var BoundsForPlotting = new L.LatLngBounds();
					BoundsForPlotting.extend(firstLatLong);
					BoundsForPlotting.extend(latLong);
					map.fitBounds(BoundsForPlotting);
		    }
			i+=2;			
		}		
		if(datalist.length == 0)
		{
			map.fitBounds(bounds);
		}
        	polyline = L.polyline(flightPath, {
        color: '#006400',
        weight: 4,
        smoothFactor: 1
    }).addTo(map);
    polylines.push(polyline);
    //animatePolylines();
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
	     	map.removeLayer(poly);
	     	//poly.setMap(null);
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
	             if(datalist.length > 0){
	              createPolylineTrace();
	             }
			} 
		});
	}
	layerGroup = new L.LayerGroup().addTo(map);
	function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, status, imagePath,isMarkerCluster,counts) {
		if (status == 'stoppage') {
			imageurl = '<%=vehicleImagePath%>MapImages/' + imagePath + '_BR.png';
		} else if (status == 'idle') {
			imageurl = '<%=vehicleImagePath%>MapImages/' + imagePath + '_BL.png';
		} else {
			imageurl = '<%=vehicleImagePath%>MapImages/' + imagePath + '_BG.png';
		}
		 var image = L.icon({
        iconUrl: imageurl,
        iconSize: [35, 35], // size of the icon
        popupAnchor: [0, 32]
    });
    
		var pos = new L.LatLng(latitude, longtitude);
		var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto;color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
			'<table>' +
			'<tr><td><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
			'<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' +
			'<tr><td><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
			'<tr><td><span style="margin-right: 1em;"><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="googlemaplink(\'' + vehicleNo + '\',\'' + latitude + '\',\'' + longtitude + '\')">External Map link</button></span></td><td style="float:left;"><span style="margin-right: 1em;"><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="historyAnalysis(\'' + vehicleNo + '\')">History Analysis</button></span><span><button type="button" id="create-landmark-button" class="create-landmark-button" onclick="createLandmark(\'' + vehicleNo + '\',\'' + latitude + '\',\'' + longtitude + '\')"><%=createlandmark%></button><span></td></tr>' +
			'</table>' +
			'</div>';
		contentOne = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto; width:100%; height: 100%; float: left; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +
			'<table>' +
			'<tr><td></td><td>' + vehicleNo + '</td></tr>' +
			'</table>' +
			'</div>';
		var marker;
	if(isMarkerCluster == true) {
		marker = new L.Marker(new L.LatLng(latitude, longtitude), {myCustomId:vehicleNo,icon: image});
		marker.bindTooltip(vehicleNo,{permanent:true})
		marker.bindPopup(content, {closeOnClick: false, autoClose: false});
		//markerCluster.addLayer(marker);
	} else {
		marker = new L.Marker(new L.LatLng(latitude, longtitude), {myCustomId:vehicleNo,icon: image}).addTo(map);
			marker.bindTooltip(vehicleNo,{permanent:true})		
		marker.bindPopup(content, {closeOnClick: false, autoClose: false});
	}
	if (document.getElementById("c2").checked == false) {
            showlabel = "false";
            marker.closeTooltip();
    }
	marker.on('popupopen', function(e) {
	var popup = marker.getPopup();
    markerClickEvent(this.options.myCustomId);
   });
   marker.on('popupclose', function(e) {
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
   })
		
		

		if(animate == "true")
		{
			//marker.setAnimation(google.maps.Animation.DROP);
		}
		if (location != 'No GPS Device Connected') {
			bounds.extend(pos);
			//map.setView(pos,4);
		}else {
		if(document.getElementById("c5").checked)
		{
			map.setZoom(zoompercent);
			map.fitBounds(zoomlevel);
		}
		}
		
		//infowindows[vehicleNo] = infowindow;
		markers[vehicleNo] = marker;
		//infowindowsOne[vehicleNo] = infowindowOne;
		if(showlabel == "true"){
       showDetails(document.getElementById("c2"));
	}
	if(counts>50){
    markerCluster.addLayer(marker);
	map.addLayer(markerCluster);
	markerClusterArray.push(marker);
}else{
marker.addTo(layerGroup);
}
	}	    
	    
function markerClickEvent(vehicleNo){
	firstLoadDetails = 1;
    if (document.getElementById("c2").checked == true) {
        showlabel = "true";
    }
    showDetailsForLargeInfoWindow(false);
    loadMapViewDetails(vehicleNo);
    if (sliderArray.length == 0) {
        $mpContainer.removeClass('mp-container-fitscreen');
        $mpContainer.addClass('mp-container');
        slider();
        sliderArray.push(vehicleNo);
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
						//marker.setMap(null);
						map.removeLayer(marker);
					}
				}
			});
			removePrevLatLongMarker();
		}
		//listView = "false";
		if (cb.checked) {
			selectAll = "true";
			var countAll = 0;
			layerGroup.clearLayers();
			if (markerCluster) {
			map.removeLayer(markerCluster);
		      }
			//document.getElementById("c2").disabled = true;
			//markerClusterArray.length = 0;
				markerCluster = L.markerClusterGroup();
			for (var k = 0; k < store.getCount(); k++) {
				var counts=store.getCount();
				var recnew = store.getAt(k);
				if (!recnew.data['latitude'] == 0 && !recnew.data['longitude'] == 0) {
					countAll++;
					plotSingleVehicle(recnew.data['vehicleNo'], recnew.data['latitude'], recnew.data['longitude'], recnew.data['location'], recnew.data['gmt'], recnew.data['category'], recnew.data['imagePath'],true,counts);
				}
			}
			grid.getSelectionModel().selectAll();
			selectAllCheckClicked = 1;
			map.addLayer(markerCluster);
			//markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
			if (countAll > 0) {
            if (document.getElementById("c5").checked) {
                map.setZoom(zoompercent);
                map.fitBounds(zoomlevel);
            } else {
                map.fitBounds(bounds);
            }
        }
        if (countAll > 300) {
            document.getElementById("c2").disabled = true;
        }
		} else {
			selectAll = "deselect";
			selectAllCheckClicked = 0;
			if (markerCluster) {
			map.removeLayer(markerCluster);
		}
		layerGroup.clearLayers();
			//markerCluster.clearMarkers();
			mapViewAssetDetails.removeAll();
			markerClusterArray.length = 0;
			<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
			document.getElementById('<%=detailsID%>').innerHTML = '';
			<%}%>
			grid.getSelectionModel().clearSelections();
			document.getElementById("c2").disabled = false;
			<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
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
  				 map.removeLayer(marker);
    			/*marker.setMap(null);
    			if(markerCluster){
    			markerCluster.removeMarker(marker);
    			var index = markerClusterArray.indexOf(marker);
    			if(index>-1){
    			markerClusterArray.splice(index, 1);
    			}    			
    			}*/    			
    			marker=null;
    			}
    		}
	    }
	    function removePrevLatLongMarker()
	    {
    	   for(var i=0;i<latlongmarkers.length;i++){
           	var prelatlongmarker = latlongmarkers[i];
           	 map.removeLayer(prelatlongmarker);
           //	prelatlongmarker.setMap(null);
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
    				 map.removeLayer(marker);
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
{       refreshcount=1;
		if(selectAll=='true'){
		 if (markerCluster) {
			map.removeLayer(markerCluster);
		}
		layerGroup.clearLayers();
		markerCluster = L.markerClusterGroup();
		markerClusterArray.length=0;		
		}
		//mapZoom=map.getZoom();
		//var mapZoomRefresh=map.getZoom();
		//var center=map.getCenter();
        previousSelectedRow=-1;
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
		    <%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
	        document.getElementById('<%=detailsID%>').innerHTML='';
			<%}%>
	        
	   if (mapviewFullScreen == 1) {
        Ext.getCmp('vehiclePannel').hide();
        mapFullScreen();

    } else {
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
			//showDetails(true);
			if (document.getElementById("c2").checked == true) {
            showlabel = "true";
        } 	 
		}
		
		firstLoadDetails=0;
        sliderArray.length=0;
        slider();
					
	    store.load({
    	params:{vehicleType:previousVehicleType,vehicleNoList:vehicleList},
    	callback:function(){
			for(i=0; i<selVehicles.length; i++) {
    		removeVehicleMarker(selVehicles[i]);
			}
			removePrevLatLongMarker();
			selectedVehIndex = selectedIdx.length;
			grid.getSelectionModel().selectRows(selectedIdx);
			refreshcount=0;
			selectedVehIndex=0;
			if(selectAll=='true'){
    	 	//markerCluster = new MarkerClusterer(map, markerClusterArray,mcOptions); 
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
    			//circles[i].setMap(null);
    			//buffermarkers[i].setMap(null);
    			 map.removeLayer(circles[i]);
                 map.removeLayer(buffermarkers[i]);
	    	}
	    	for(var i=0;i<polygons.length;i++)
	    	{
    			map.removeLayer(polygons[i]);
               map.removeLayer(polygonmarkers[i]);
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
	    function setZoomToMap(cz) {
    if (cz.checked) {
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
   				var myBorderLatLng = new L.LatLng(rec.data['lat'],rec.data['long']);      
       				createBorderCircle = L.circle(myBorderLatLng, {
                color: '#A7A005',
                fillColor: '#ECF086',
                fillOpacity: 0.55,
                center: myBorderLatLng,
                radius: convertRadiusToMeters //In meters
            }).addTo(map);   
 				 sericeStationImage = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/border.png',
                iconSize: [19, 35], // size of the icon
                popupAnchor: [0, 32]
            }); 

 				serviceStationMarker = new L.Marker(myBorderLatLng, {
                icon: borderCircleImage
            }).addTo(map);
       	
       	 serviceStationMarker.bindPopup(rec.data['borderName']);
       	 borderCircleMarkers[circleBorderCount] = borderCircleMarker;
            borderCircles[circleBorderCount] = new google.maps.Circle(createBorderCircle);
            circleBorderCount++;
	    	
	    	}else{
	    	
	    	if(i!=borderStore.getCount()-1 && rec.data['borderHubid']==borderStore.getAt(i+1).data['borderHubid'])
	    	{
	    	var latLong=new L.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	borderCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new L.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	borderCoords.push(latLong);
	    	borderCoords.push(borderCoords[0]);
			}  			
 
	        borderPolyline = L.polyline(borderCoords, {
                color: '#ff0000',
                weight: 3,
                Opacity: 1.0,
                smoothFactor: 1
            }).addTo(map);
	        			
	    	 borderImage = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/border.png',
                iconSize: [48, 48], // size of the icon
                popupAnchor: [0, 32]
            });
            
             borderMarker = new L.Marker(latLong, {icon: borderImage}).addTo(map);
            borderMarker.bindPopup(rec.data['borderName']);



            /* borderMarker.setAnimation(google.maps.Animation.DROP); 
  			borderPolyline.setMap(map); */
            borderPolylines[hubid] = borderPolyline;
            borderMarkers[hubid] = borderMarker;
            hubid++;
            borderCoords = [];
	    	
	    	}
	    	
	    }
	}
	
	function removeBorder(){
			for(var i=0;i<borderPolylines.length;i++){
				//borderPolylines[i].setMap(null);
				//borderMarkers[i].setMap(null);
				 map.removeLayer(borderPolylines[i]);
                 map.removeLayer(borderMarkers[i]);
			}
			borderPolylines.length=0;
			
			for(var i=0;i<borderCircles.length;i++){
				map.removeLayer(borderCircleMarkers[i]);
                map.removeLayer(borderCircles[i]);
				}
	}

///***************************************** Show Details********************************************	    
	    
	    function showDetails(cb)
	    {	
	    		var vehicles = grid.getSelectionModel().getSelections(); 
	    		if (vehicles.length == 0) {
        document.getElementById("c2").checked = false;
         } else {
				Ext.iterate(vehicles, function(vehicle, index) {
				var vehicleNo = store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
				var markerI = markers[vehicleNo];
          if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
					if(cb.checked)
	    			{
	    			markerI.openTooltip();
	    				//infowindowsOne[infowindowId].open(map, markers[infowindowId]); 
    	    			//infowindowOne.setContent(contentOne);
    	    		}
    	    		else
    	    		{
    	    		     markerI.closeTooltip();
    	    			//infowindowsOne[infowindowId].setMap(null);
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
	    				//infowindows[infowindowId].open(map, markers[infowindowId]); 
    	    			//infowindows.setContent(content);
    	    		}
    	    		else
    	    		{
    	    			//infowindows[infowindowId].setMap(null);
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
	    var myLatLng = new L.LatLng(rec.data['latitude'],rec.data['longitude']);       	
	        createCircle = L.circle(myLatLng, {
            color: '#A7A005',
            fillColor: '#ECF086',
            fillOpacity: 0.55,
            center: myLatLng,
            radius: convertRadiusToMeters //In meters
        }).addTo(map);
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
	    	 bufferimage = L.icon({
            iconUrl: urlForZero,
            iconSize: [19, 35], // size of the icon
            popupAnchor: [0, 32]
        });

        bufferMarkerForServiceSt = new L.Marker(myLatLng, {icon: bufferimage}).addTo(map);
        bufferMarkerForServiceSt.bindPopup(rec.data['buffername']);

        //buffermarker.setAnimation(google.maps.Animation.DROP); 

        buffermarkers[i] = bufferMarkerForServiceSt;
        circles[i] = createCircle;
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
	    	var latLong=new L.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new L.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
			}
  			
  			polygon = L.polygon(polygonCoords).addTo(map);
        polygonimage = L.icon({
            iconUrl: '/ApplicationImages/VehicleImages/information.png',
            iconSize: [48, 48], // size of the icon
            popupAnchor: [0, 32]
        });	
        polygonmarker = new L.Marker(latLong, {icon: polygonimage}).addTo(map);
        polygonmarker.bindPopup(rec.data['polygonname']);

        polygons[hubid] = polygon;
        polygonmarkers[hubid] = polygonmarker;
        hubid++;
        polygonCoords = [];
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
				var serviceStationLatLng = new L.LatLng(rec.data['lat'], rec.data['long']);
				  createServiceStationCircle = L.circle(serviceStationLatLng, {
                color: '#A7A005',
                fillColor: '#ECF086',
                fillOpacity: 0.55,
                center: serviceStationLatLng,
                radius: convertRadiusToMeters //In meters
            }).addTo(map);

				 serviceStationCircleImage = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/information.png',
                iconSize: [19, 35], // size of the icon
                popupAnchor: [0, 32]
            });

				
				bufferMarkerForServiceSt = new L.Marker(serviceStationLatLng, {
                icon: serviceStationCircleImage
            }).addTo(map);
            bufferMarkerForServiceSt.bindPopup(rec.data['serviceStationName']);
            
            bufferMarkerForServiceSts[circleServiceStationCount] = bufferMarkerForServiceSt;
            circlesForServiceSt[circleServiceStationCount] = new google.maps.Circle(createServiceStationCircle);
            circleServiceStationCount++;

			} else {

				if (i != serviceStationStore.getCount() - 1 && rec.data['hubId'] == serviceStationStore.getAt(i + 1).data['hubId']) {
					var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
					serviceStationCoords.push(latLong);
					continue;
				} else {
					var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
					serviceStationCoords.push(latLong);
					serviceStationCoords.push(serviceStationCoords[0]);
				}

				 sericeStationPolyline = L.polyline(serviceStationCoords, {
                color: '#ff0000',
                weight: 3,
                smoothFactor: 1
            }).addTo(map);

              sericeStationImage = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/border.png',
                iconSize: [48, 48], // size of the icon
                popupAnchor: [0, 32]
            });

				serviceStationMarker = new L.Marker(latLong, {
               icon: sericeStationImage
            }).addTo(map);
           // serviceStationMarker.bindPopup(rec.data['borderName']);
				serviceStationMarker.bindPopup(rec.data['serviceStationName']);
				 serviceStation[hubid] = sericeStationPolyline;
            serviceStationMarkers[hubid] = serviceStationMarker;
            hubid++;
            serviceStationCoords = [];
			}
		}
	}
	
	function removeServiceStation(){
		for (var i = 0; i < serviceStation.length; i++) {
		     map.removeLayer(serviceStation[i]);
        map.removeLayer(serviceStationMarkers[i]);
		}
		serviceStation.length = 0;
		serviceStationMarkers.length = 0;
		
		for (var i = 0; i < circlesForServiceSt.length; i++) {
		   map.removeLayer(circlesForServiceSt[i]);
        map.removeLayer(bufferMarkerForServiceSts[i]);
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
        		 }       
        	  ]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getOlaMapViewVehicles',
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
        header: "<span style=font-weight:bold;><%=vehicleNo%> (<%=vehicleId%>)</span>",
        sortable: true,
         menuDisabled:true,
        dataIndex: 'assetNo',
        width:150
    	},{
        header: "<span style=font-weight:bold;>Image</span>",
        sortable: true,
        menuDisabled:true,
        dataIndex: 'imageIcon',
        width:50
    	},{
    	header: "<span style=font-weight:bold;><%=groupName%></span>",
        sortable: true,          
        dataIndex: 'groupname',
        width:200
    	}]
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
		 removePolylineTrace();
   		 if(markerFlag != null)
   		 {
   			map.removeLayer(markerFlag);
   		 }
   		 if (markerCluster) {
		map.removeLayer(markerCluster);
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
					   		interval = setInterval(function(){refreshVehicle()},60000);
				   		} else {
				   			plotVehicleImage(selModel,index,record);
				   			interval = setInterval(function(){refreshVehicle()},180000);
				   		}
			    } else {
			    	animate = "true";
			    	plotVehicleImage(selModel,index,record);
			    	interval = setInterval(function(){refreshVehicle()},180000);
		        }
	        } else {
	        		animate = "true";
			    	plotVehicleImage(selModel,index,record);
			    	interval = setInterval(function(){refreshVehicle()},180000);
	        }
	    } else {
	    	animate = "true";
	    	plotVehicleImage(selModel,index,record);
	    	interval = setInterval(function(){refreshVehicle()},180000);
	    }
	});  

	selModel.on('rowdeselect', function(selModel, index, record) {
		var selectedRows = selModel.getSelections();
		var rec = grid.store.getAt(index);
        //listView = "false";
        removePolylineTrace();
   		if(markerFlag != null)
   		{
   			 map.removeLayer(markerFlag);
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
				<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
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
			<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
			document.getElementById('<%=detailsID%>').innerHTML = '';
			<%}%>

		}

	});
  
    function plotVehicleImage(selModel,index,record)
    {
    	if (selectAll != 'true' || refreshcount == 1) {
			if (detailspage > 0) {
				if (previousSelectedRow != -1) {
					selModel.deselectRow(previousSelectedRow);
				}
				previousSelectedRow = index;
				getNonCommStatusData();
			}
			var selectedRows = selModel.getSelections();
			var rec = grid.store.getAt(index);
			var counts=store.getCount();
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
						plotSingleVehicle(rec.data['vehicleNo'], historyLatitude, historyLogitude, historyLocation, historyGmt, rec.data['category'], rec.data['imagePath']);
					} else {
						plotSingleVehicle(rec.data['vehicleNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'],false,counts);
					}
				} else {
					if(selectAll == 'true'){
					plotSingleVehicle(rec.data['vehicleNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'],true,counts);
				} else {
					plotSingleVehicle(rec.data['vehicleNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath'],false,counts);
				}
				}
				if (selectedRows.length == 1) {
					//plotPrevLatLong(rec.data['vehicleNo'], rec.data['prevlat'], rec.data['prevlong']);
				}
			}
			if (singleSelectCount > 0) {
				if(animate == "true"){
					if (document.getElementById("c5").checked) {
                    zoompercent = map.getZoom();
                    zoomlevel = map.getBounds();
                    map.setZoom(zoompercent);
                    map.fitBounds(zoomlevel);
                } else {
                    //map.fitBounds(bounds);
                }
            }
        }
			/*var listener = google.maps.event.addListener(map, "idle", function() {
				if (map.getZoom() > 16) map.setZoom(mapZoom);
				google.maps.event.removeListener(listener);
			});*/

			if (selectedRows.length > 1) {
				document.getElementById('ackw-button-id').style.visibility = 'hidden';
				removePrevLatLongMarker();
			} else if (selectedRows.length == 1) {
				if (detailspage != 1 && '<%=vehicleTypeRequest%>' == "noncomm") {
					document.getElementById('ackw-button-id').style.visibility = 'visible';
				}

			} else if (selectedRows.length == 0) {
				<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
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
						plotSingleVehicle(rec.data['vehicleNo'], historyLatitude, historyLogitude, historyLocation, historyGmt, rec.data['category'], rec.data['imagePath']);
					} else {
						plotSingleVehicle(rec.data['vehicleNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath']);
					}
				} else {
					plotSingleVehicle(rec.data['vehicleNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['gmt'], rec.data['category'], rec.data['imagePath']);
				}
				if (selectedRows.length == 1) {
					//plotPrevLatLong(rec.data['vehicleNo'], rec.data['prevlat'], rec.data['prevlong']);
				}
			}
			if (singleSelectCount > 0) {
				/*if (markerCluster) {
					markerCluster.clearMarkers();
					markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
				}*/
				if(animate == "true"){
					map.fitBounds(bounds);
				}
			}
			/*var listener = google.maps.event.addListener(map, "idle", function() {
				if (map.getZoom() > 16) map.setZoom(mapZoom);
				google.maps.event.removeListener(listener);
			});*/

			if (selectedRows.length > 1) {
				document.getElementById('ackw-button-id').style.visibility = 'hidden';
				removePrevLatLongMarker();
			} else if (selectedRows.length == 1) {
				if (detailspage != 1 && '<%=vehicleTypeRequest%>' == "noncomm") {
					document.getElementById('ackw-button-id').style.visibility = 'visible';
				}

			} else if (selectedRows.length == 0) {
				<%for(int i=0;i<liveVisionColumns.getListOfIds().size();i++) {  detailsID=liveVisionColumns.getListOfIds().get(i);%>
				document.getElementById('<%=detailsID%>').innerHTML = '';
				<%}%>
			}

		}
		$("#mp-container").unmask();
		$("#mapViewGridId").unmask();
    }
    
 	function startfilter() {
		/*if (markerCluster) {
			markerCluster.clearMarkers();
			markerClusterArray.length = 0;
		}*/
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
	var vehicleStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/MapView.do?param=getVehicleList',
	    id: 'vehicleListId',
	    root: 'vehicleListRoot',
	    autoLoad: false,
	    fields: ['id','name']
	});
   var vehicleListCombo = new Ext.ux.form.LovCombo({
		id:'vehicleListComboId',	 
 		width:300,
		maxHeight:200,
		store: vehicleStore,
		mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'id',
	    displayField: 'name',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
		listeners:{
			select: {
				fn: function(){
					vehicleList = Ext.getCmp('vehicleListComboId').getValue();
					store.load({
				    	params:{vehicleType:previousVehicleType,vehicleNoList:vehicleList},
				    	callback:function(){    		
				    	} 
				    });
				}
			}
		}
	});
   Ext.Ajax.timeout = 360000;   
   
 	var vehiclePannel =new Ext.Panel({
		id:'vehiclePannel',
		cls:'vehiclegridstyles',
        items: [vehicleListCombo,{
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
		   var myLatlng = new L.LatLng(prevlat,prevlong);	
		    var image = L.icon({
            iconUrl: '/ApplicationImages/VehicleImages/redcirclemarker.png',
            iconSize: [30, 30], // size of the icon
            popupAnchor: [0, -15]
        });   
		  /* latlongmarker = new google.maps.Marker({
			      position: myLatlng,
			      id : vehicleNo,
			      map: map,			      
			      icon:	image				     
  			}); */
  			latlongmarker = new L.Marker(myLatLng, {
            icon: bufferimage
        }).addTo(map);
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
										document.getElementById('Latitude').innerHTML=historyLatitude;
									} else {
										document.getElementById('Latitude').innerHTML=rec.data['latitude'];
									}
								}
								if(document.getElementById('Longitude')!= null )
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Longitude').innerHTML=historyLogitude;
									} else {
										document.getElementById('Longitude').innerHTML=rec.data['longitude'];
									}
								}
								if(document.getElementById('Location')!=null)
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Location').innerHTML=historyLocation;
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
										document.getElementById('Date_Time').innerHTML=historyGmt;
									} else {
										document.getElementById('Date_Time').innerHTML=rec.data['gmt'];
									}
								}
								 if (document.getElementById('Speed') !=null )
								{
									if(animate == "false" && infolist.length != 0)
									{
										document.getElementById('Speed').innerHTML=historySpeed;
									} else {
										document.getElementById('Speed').innerHTML=record.data['speed'];	
									}
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

function createLandmark(vehicleNo,lat,lon){
	  title="Create New Landmark";
	  var reg = vehicleNo.replace(/ /g,"%20");
	  var locationPage="<%=request.getContextPath()%>/Jsps/Common/CreateLandmark.jsp?vehicle="+reg+"&lat="+lat+"&lon="+lon;
      openLocationWindow(locationPage,title);	
    	
}	
function googlemaplink(vehicleNo, lat, lon) {
	if('<%=mapName%>' == 'HERE') {
		window.open("https://share.here.com/l/"+ lat + "," + lon+"?p=PIN");
	} else {
		window.open("http://www.google.com/maps/place/" + lat + "," + lon);
	}
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
vehicleStore.load({params:{vehicleType:previousVehicleType}});
/*
    store.load({
    	params:{vehicleType:previousVehicleType},
    	callback:function(){
    		var vehicles=parent.document.getElementById('reglist').value;  
    		if(vehicles != null){  		
	    		vehicles = vehicles.substring(0, vehicles.length - 1);    		
	    		var selectedVehicle=vehicles.split("|");    		
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
    */
});
	</script>
    </body>
</html> 
