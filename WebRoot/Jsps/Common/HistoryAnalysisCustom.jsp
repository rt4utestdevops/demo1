<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,java.text.SimpleDateFormat,java.nio.charset.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

String vehiclesNo="";
String vehcleNo = "";
boolean hisTrackNew = false;
if(request.getParameter("hisTrackNew") != null && !request.getParameter("hisTrackNew").equals("")){
	vehiclesNo= request.getParameter("vehicleNo").replaceAll(" ","%20");
	vehcleNo = request.getParameter("vehicleNo");
	byte[] bytes = vehcleNo.getBytes(Charset.forName("ISO-8859-1"));
	vehcleNo = new String(bytes, Charset.forName("UTF-8"));
	hisTrackNew = Boolean.parseBoolean(request.getParameter("hisTrackNew"));
}	
boolean sandMiningReport = false;
String startd="";
String endd="";
String fromlocation="";
String tolocation="";
String vehicleNumber="";
String startmin="";
String starthr="";
String fromlat="";
String fromlong="";
String tolat="";
String tolong="";
if(request.getParameter("sandMiningReport") != null && !request.getParameter("sandMiningReport").equals("")){
	vehicleNumber = request.getParameter("vehicleNo");
	startd = request.getParameter("startdate");
	starthr= request.getParameter("startdateHrs");
	if(starthr.length()==1){
     starthr="0"+starthr;
       }
	startmin= request.getParameter("startdateMin");
    if(startmin.length()==1){
     startmin="0"+startmin;
       }
	endd = request.getParameter("enddate");
	fromlocation = request.getParameter("fromplace");
	tolocation = request.getParameter("destination");
	sandMiningReport = Boolean.parseBoolean(request.getParameter("sandMiningReport"));
	fromlat= request.getParameter("fromlat");
	fromlong= request.getParameter("fromlong");
	tolat= request.getParameter("tolat");
	tolong= request.getParameter("tolong");
}
boolean essentialReport=false;
boolean tripReport=false;
String vehicleNo="";
String startDate="";
String endDate="";
String startTimeHr= "";
String startTimeMin= "";
String endTimeHr= "";
String endTimeMin= "";
if(request.getParameter("tripReport") != null && !request.getParameter("tripReport").equals("")){
	vehicleNo = request.getParameter("vehicleNo");
	startDate = request.getParameter("startDate");
	endDate= request.getParameter("endDate");
	startTimeHr = request.getParameter("startTimeHr");
	startTimeMin= request.getParameter("startTimeMin");
	endTimeHr = request.getParameter("endTimeHr");
	endTimeMin= request.getParameter("endTimeMin");
	tripReport = Boolean.parseBoolean(request.getParameter("tripReport"));
}

if(request.getParameter("essentialReport") != null && !request.getParameter("essentialReport").equals("")){
	vehicleNo = request.getParameter("vehicleNo");
	startDate = request.getParameter("startDate");
	endDate= request.getParameter("endDate");
	startTimeHr = request.getParameter("startTimeHr");
	startTimeMin= request.getParameter("startTimeMin");
	endTimeHr = request.getParameter("endTimeHr");
	endTimeMin= request.getParameter("endTimeMin");
	essentialReport = Boolean.parseBoolean(request.getParameter("essentialReport"));
}
String language = loginInfo.getLanguage();
int systemid = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();
String sysName =  loginInfo.getSystemName().replaceAll(" ","%20");
int countryId = 0;//loginInfo.getCountryCode();
int offset = loginInfo.getOffsetMinutes();
String countryName = "";// cf.getCountryName(countryId);

HistoryAnalysisFunction hTrackingFunctions = new HistoryAnalysisFunction();
ArrayList unitOfMeasurementList= hTrackingFunctions.getUnitDetails(systemid);
String unitOfMeasurement=unitOfMeasurementList.get(0).toString();

String status = "";
if(request.getParameter("status") != null && !request.getParameter("status").equals("")){
	status = request.getParameter("status");
}
String recordstatus = "";
if(request.getParameter("recordstatus") != null && !request.getParameter("recordstatus").equals("")){
	recordstatus = request.getParameter("recordstatus");
}
String pageLoad = "";
if(request.getParameter("pageLoad") != null && !request.getParameter("pageLoad").equals("")){
	pageLoad = request.getParameter("pageLoad");
}
String mapTypeFromOpen = "";
if (request.getParameter("mapType") != null) {
     mapTypeFromOpen = request.getParameter("mapType");
 	}
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Asset_No");
tobeConverted.add("Start_Date");
tobeConverted.add("Start_Time_HHMM");
tobeConverted.add("End_Date");
tobeConverted.add("End_Time_HHMM");
tobeConverted.add("Date");
tobeConverted.add("Speed_Id");
tobeConverted.add("Location");
tobeConverted.add("Trace_Path");
tobeConverted.add("Show_Hubs");
tobeConverted.add("Show_Labels");
tobeConverted.add("Speed_Control");
tobeConverted.add("Submit");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String assetNo = convertedWords.get(0);
String StartDate = convertedWords.get(1);
String startTimeHHMM = convertedWords.get(2);
String EndDate = convertedWords.get(3);
String endTimeHHMM = convertedWords.get(4);
String date = convertedWords.get(5);
String speed = convertedWords.get(6);
String location = convertedWords.get(7);
String tracePath = convertedWords.get(8);
String showhubs = convertedWords.get(9);
String showlabels = convertedWords.get(10);
String speedControl = convertedWords.get(11);
String submit = convertedWords.get(12);
String distUnits = cf.getUnitOfMeasure(systemid);
String note = " Note: Displaying records of previous 6 hours.";
String latitudeLongitude = cf.getCoordinates(systemid);
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">    
    <title>HistoryTrackingNew</title>
        
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">	
	

	
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
	<pack:script src="../../Main/Js/examples1.js"></pack:script>
	<pack:script src="../../Main/Js/dateval.js"></pack:script>
	
	<pack:script src="../../Main/Js/jqueryjson.js"></pack:script>
	
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/chooser.css" />
	<pack:style src="../../Main/resources/css/common.css" />	
	<pack:style src="../../Main/resources/css/dashboard.css" />
	<pack:style src="../../Main/resources/css/examples1.css" />
	<pack:style src="../../Main/resources/css/style.css" />
	<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
	<style>	
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
 .panel-details {
	width: 103.5%;
	height: 227px;
	float: left;
}
.me-select {
	margin-top : 10px;
	overflow-x: hidden;
	overflow-y: hidden;
}
.maplabel{
	color:#1F1D1D;
	font-weight: bold;
}
.buttonCls{
	width : 50px;
	height :10px;
	margin-top : 20px;
}
.popuppanel{
	width : 221px !important;
	height : 137px !important;
}
     @media screen and (device-width:1920px) {
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
		 		.popuppanel{
					width : 221px !important;
					height : 137px !important;
				}
	}
		@media (device-width: 1280px) and (device-height: 720px) {
			  .openLayerButton {
		        margin-top: -396px;
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
			 .popuppanel{
				width : 221px !important;
				height : 137px !important;
			}
		}
		@media screen and (device-width: 1600px) {
			.openLayerButton {
		        margin-top: -555px;
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
			 .popuppanel{
				width : 221px !important;
				height : 137px !important;
			}
		}
		@media screen and (device-width:1440px) {
			.openLayerButton {
	        margin-top: -555px;
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
		 .popuppanel{
			width : 221px !important;
			height : 137px !important;
		}
		}
		@media (device-width: 1280px) and (device-height: 800px) {
			.openLayerButton {
	        margin-top: -465px;
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
		 .popuppanel{
			width : 221px !important;
			height : 137px !important;
		}
	}
	.note_for_display {
    float: left;
    width: 75%;
    font-size: 11px;
    font-family: 'Open Sas' sans-serif !important;
    font-weight: bold;
    padding-left: 20px;
}
.maplabel {
    color: #1F1D1D;
    font-weight: 100;
}

.x-combo-list, .x-combo-list-inner{
	height:200px !important;
	overflow-y: auto !important;
}
 .x-combo-list-item{ cursor:pointer;}
 .x-combo-list-item:hover{ background:#dfdfdf;}
 
	</style>
  </head>
  <script src='<%=GoogleApiKey%>'></script>
  
	<pack:script src="../../Main/Js/richmarker.js"></pack:script>
  <body>   
  	<div class="container" id="content">
		 <div class = "main">		 	
		 	<div class="mp-vehicle-details-wrapper" id="vehicle-details">
				<form class="me-select">
				<div class="panel-details" id="style-switcherid"></div>
				<p></p>
				<hr>
				<p></p>
					<ul id="me-select-list">
						<li class='me-select-label'>
							<span class="vehicle-details-block-header"><%=assetNo%></span>
							<span class="vehicle-details-block-sep">&nbsp;:</span>
							<span class="vehicle-details-block" id="vehicleDetailsId"><%=vehcleNo%></span>
			 			</li>
			 			<li class='me-select-label'>
							<span class="vehicle-details-block-header"><%=StartDate%> (HH:MM)</span>
							<span class="vehicle-details-block-sep">&nbsp;:</span>
							<span class="vehicle-details-block" id="vehicledetailsstartdate"></span>
							<span style="margin-left:1em;" id="vehicledetailsstarttime"></span>
			 			</li>
			 			<li class='me-select-label'>
							<span class="vehicle-details-block-header"><%=EndDate%> (HH:MM)</span>
							<span class="vehicle-details-block-sep">&nbsp;:</span>
							<span class="vehicle-details-block" id="vehicledetailsenddate"></span>
							<span style="margin-left:1em;" id="vehicledetailsendtime"></span>
			 			</li>
			 			<li class='me-select-label'>
							<span class="vehicle-details-block-header"><%=date%> </span>
							<span class="vehicle-details-block-sep">&nbsp;:</span>
							<span class="vehicle-details-block" id="dateId"></span>
			 			</li>
			 			<li class='me-select-label'>
							<span class="vehicle-details-block-header"><%=speed%> </span>
							<span class="vehicle-details-block-sep">&nbsp;:</span>
							<span class="vehicle-details-block" id="speedId"></span>
							<span class="vehicle-details-block" id="speedMeasure"></span>
			 			</li>
			 			<li class='me-select-label'>
							<span class="vehicle-details-block-header"><%=location%> </span>
							<span class="vehicle-details-block-sep">&nbsp;:</span>
							<p class="vehicle-details-block" id="locationId"></p>
			 			</li>
					</ul>					
				</form>	
				<div id="noteDiv" style="display:none">
				<span class="note_for_display"><%=note%> </span>
				</div>									
			</div>		 	
			
		    <div class="mp-container" id="mp-container">	
				<div class="mp-map-wrapper" id="map-container"></div>
				<div class="mp-options-wrapper">
				<select class="openLayerButton" id="maptype" onchange="customMap();">
  					<%if(mapTypeFromOpen.equals("SatMap")){%>
	       			<option value="SatMap">Satellite Google Map</option>
  					<option value="StreetMap">Street Google Map</option>
<!--  					<option value="CusMap">Openstreet Map</option>-->
  					<%} else if(mapTypeFromOpen.equals("StreetMap")) {%>
	        		<option value="StreetMap">Street Google Map</option>
	        		<option value="SatMap">Satellite Google Map</option>
<!--  					<option value="CusMap">Openstreet Map</option>-->
  					<%} else if(mapTypeFromOpen.equals("")) {%>
	        		<option value="StreetMap">Street Google Map</option>
	        		<option value="SatMap">Satellite Google Map</option>
<!--  					<option value="CusMap">Openstreet Map</option>-->
  					<%}%>
					</select>
					<table style="width:99%">
						<tr>
							<td><div><img class="ruler" id ="startRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerStart.gif" title="Start Ruler"/></div></td>
							<td><div><img  class="ruler" id ="removeRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerEnd.gif" title="Remove Ruler"/></div></td>
							<td><div><img class="play" id="play/pause" src="/ApplicationImages/ApplicationButtonIcons/play.png" alt="Play History Analysis" onclick='playHistoryTracking(this);' title="Play History Analysis"/></div></td>
							<td style="width:5%"><div><img class="pause" id ="stop" src="/ApplicationImages/ApplicationButtonIcons/stop.png" onclick='stopHistoryTracking();' title="Stop History Analysis" /></div></td>
							<td><div id="stopIconId"><img src="/ApplicationImages/ReportIcons/stop_rpt_25.gif" alt="Stop Report" title='Stop Report' height="22" width="25" onclick="reportWindow('Stop')"></img></div></td>
							<td><div id="speedIconId"><img src="/ApplicationImages/ReportIcons/speed-alert_22.gif" alt="Speed Report" title ='Speed Report' height="22" width="22" onclick="reportWindow('Speed')"></img></div></td>
							<td><div id="activityIconId"><img src="/ApplicationImages/ReportIcons/activity_report_25.gif" alt="Activity Report" title='Vehicle Activity Report' height="22" width="25" onclick="reportWindow('Activity')"></img></div></td>
							<td><div><input type="submit" id ="optionList" onclick = "getOptionList()" value = "Options" Style="background-color:#7b766f;border-radius: 13px;border: solid;color:white; width: 95px;height:27px;"></div></td> 
							<td style="width:25%">
								<div>
								<!-- 	<span class="show-label">
										<input type="checkbox" value="check" id="notchecked" onclick="labeloption(this);">
										<span class='labletxt'><%=showlabels%></span>
									</span>        -->
									<span class="show-label">
										<select name="lablesel" id="lablesel" class='select-style' style="visibility: hidden" onchange="setlabelgap()">
								    	  <option value="0">Select Label</option>
								    	  <option value="Position">Position Label</option>
								    	  <option value="1">Distance Label 1</option>
								    	  <option value="5">Distance Label 5</option>
								    	  <option value="10">Distance Label 10</option>
								    	  <option value="15">Distance Label 15</option>
								    	  <option value="20">Distance Label 20</option>
								    	  <option value="25">Distance Label 25</option>
									    </select>
									</span>
								</div>
							</td>
							<td><span class="show-label"><%=speedControl%> :</span></td>
							<td><div><span id="slider"></span></div></td>
							<td>
								<div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
								<div class="mp-option-fullscreen1" id="option-fullscreen"  onclick="mapFullScreen()"></div>
						    </td>
						</tr>
					</table>
				</div>					
			</div>
	</div>
	</div>
	<script type="text/javascript">	
	var map;
	var firstload=1;
	var titleMkr=[];
	var simpleMarkers = [];
	var markers = [];
	var speedMarkers = [];
	var mapZoom;
	var polyline;
	var polylines=[];
	var path;
	var timerval=null;
	var mkrColl=[];
	var displaytext=[];
	var unitOfMeasurement = '<%=unitOfMeasurement%>';
	var status = '<%=status%>';
	var recordstatus = '<%=recordstatus%>';
	var countryName = '<%=countryName%>';
	var running=false;
	var drawpoly;
	var drawpolys = [];
	var sliderValue;
	var Firstcheck=true;
    var HubFlg=false;
    var circles = [];
    var buffermarkers = [];
    var polygons = [];
    var polygonmarkers = [];
    var borderPolylines = [];
    var labelmarkers = [];
    var distArray = [];
    var distanceList=[];
    var datalist = [];
    var infolist = [];
    var createlndmrk=false;
    var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
    var infowindow;
    var outerPanel;
    var $mpContainer = $('#mp-container');	
	var $mapEl = $('#map');	
	var borderCircles=[];
	var borderCircleMarkers=[];
	var borderMarkers=[];
	var dataAndInfoList;
	var fromMapView = <%=hisTrackNew%>;
	var fromSandReport = <%=sandMiningReport%>;
	var fromTripReport = <%=tripReport%>;
	var fromEssentialReport = <%=essentialReport%>;
	var offset = <%=offset%>;
	var livePlottingInterval; 
	var pageLoad = '<%=pageLoad%>';	
	var myWinForOptions; 
	var jspName = "";
	var exportDataType = "";
	var markerFlag;
	var markerFlagGreen;
	var previousChecks = [];
	var optionsStore;
	var buttonValue = "";
	var deselectedOptions = "";
	var selectedOptions = "";
	var fromlat= '<%=fromlat%>';
 	var fromlong= '<%=fromlong%>';
	var tolat= '<%=tolat%>';
	var tolong= '<%=tolong%>';
	document.getElementById('option-normal').style.display = 'none';
	var distanceUnits = '<%=distUnits%>';
	var histfromclick = '<%=hisTrackNew%>';
	
	function initialize() {
	    var mapOptions = {
            zoom: 5,
            center: new google.maps.LatLng(<%=latitudeLongitude%>),
             <%if(mapTypeFromOpen.equals("SatMap")){%>  
	        mapTypeId: google.maps.MapTypeId.HYBRID,   
	        <%}else if(mapTypeFromOpen.equals("StreetMap")) {%>  
	        mapTypeId: google.maps.MapTypeId.STREET,
	        <%}%>
            mapTypeControl: false,
            gestureHandling: 'greedy'
            
        };        
        map = new google.maps.Map(document.getElementById('map-container'), mapOptions); 
        mapZoom = 10;
        document.getElementById("lablesel").value = 0;
     	document.getElementById("lablesel").disabled=true;     
	//	if(recordstatus == "fromListView" || pageLoad == "googleMap"){
<!--			var geocoder = new google.maps.Geocoder();-->
<!--		    geocoder.geocode({'address': countryName}, function(results, status) {-->
<!--		      if (status == google.maps.GeocoderStatus.OK) {-->
<!--			        map.setCenter(results[0].geometry.location);-->
<!--			        map.fitBounds(results[0].geometry.viewport);-->
<!--		      	}-->
<!--		    });-->
	  //  }
	    if(fromMapView){
	       	loadDate();
	    }
	    if(fromSandReport){
	    document.getElementById('vehicleId') != null ? document.getElementById('vehicleId').setAttribute("disabled","disabled"):"";
		//Ext.getCmp('vehicleId').disable();
		Ext.getCmp('startDateId').disable();
	 	Ext.getCmp('startTimeId').disable();
	 	Ext.getCmp('endDateId').disable();
	 	Ext.getCmp('endTimeId').disable();
	 	Ext.getCmp('addbuttonid').disable();
	    Dataload();
	    }
	    if(fromTripReport){
	    	document.getElementById('vehicleId') != null ? document.getElementById('vehicleId').setAttribute("disabled","disabled"):"";
	    	
			//Ext.getCmp('vehicleId').disable();
			Ext.getCmp('startDateId').disable();
		 	Ext.getCmp('startTimeId').disable();
		 	Ext.getCmp('endDateId').disable();
		 	Ext.getCmp('endTimeId').disable();
		 	Ext.getCmp('addbuttonid').disable();
		    loadHistData();
	    }
	    if(fromEssentialReport){
			document.getElementById('vehicleId') != null ? document.getElementById('vehicleId').setAttribute("disabled","disabled"):"";
	    	//Ext.getCmp('vehicleId').disable();
			Ext.getCmp('startDateId').disable();
		 	Ext.getCmp('startTimeId').disable();
		 	Ext.getCmp('endDateId').disable();
		 	Ext.getCmp('endTimeId').disable();
		 	Ext.getCmp('addbuttonid').disable();
		    loadHistData();
	    }
	    
    }
  	$( ".style-toggler" ).click(function(event) {
	  	$("#style-switcherid").toggle("slow",function(){
	  		  var e = document.getElementById('style-switcherid');
		      if(e.style.display == 'none'){
		         $('#style-toggler-id').attr('src','/ApplicationImages/ApplicationButtonIcons/contract.png');
		      }else{
		         $('#style-toggler-id').attr('src','/ApplicationImages/ApplicationButtonIcons/expands.png');
		      }
	  	});
	}); 
	function customMap(){
			if(document.getElementById("maptype").value == "CusMap")
			{
				var mapType = 'CusMap';
				var url="<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysisOpenLayer.jsp?mapType="+mapType;
				window.parent.$('#historyAnalysisContainer').attr('src',url);		
			}  else if(document.getElementById("maptype").value == "SatMap")
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
    plotRulerMarkerNew(map,'#startRulerId','#removeRulerId',distanceUnits); 
    google.maps.event.addDomListener(window, 'load', initialize);
/***************************minimize and maximize map****************************/   
	function mapFullScreen(){	
        document.getElementById('option-fullscreen').style.display = 'none';
        document.getElementById('option-normal').style.display = 'block';	
        $mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.addClass('mp-container-fullscreen').css({width:'originalWidth',height:'originalHeight'});
		$mapEl.css({width:$mapEl.data('originalWidth'),height:$mapEl.data( 'originalHeight')});			
		google.maps.event.trigger(map, 'resize');
	}
	function reszieFullScreen(){
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';		
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container-fitscreen');		
		$mapEl.css({width:$mapEl.data('originalWidth'),height:$mapEl.data( 'originalHeight')});			
		google.maps.event.trigger(map, 'resize');
	} 
	
	function loadDate(){
		loadMask.show();
		var dtcur = new Date();	
		var timeband = '0';
		document.getElementById('vehicleDetailsId').innerHTML='<%=vehcleNo%>';
		$.ajax({
			url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=getVehicleTrackingHistory',
			data:{
				vehicleNo:'<%=vehcleNo%>',
				timeband:timeband,
				recordForSixhrs:'recordForSixhrs',
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
	             var totaldistanceList = dataAndInfoList["vehiclesTrackingRoot"][2].distanceList;
	             for(var i=0;i<totaldistanceList.length;i++){
				 	distanceList.push(totaldistanceList[i]);
				 }
				 var startDateList = dataAndInfoList["vehiclesTrackingRoot"][3].startDate;
				 var endDateList = dataAndInfoList["vehiclesTrackingRoot"][4].endDate;
				 
				 var sdtTime;
				 var sdate;
				 var stime;
				 var sddate;
				 var sd; 
				 var sdtime; 				 
				 
				 var edtTime;
				 var edate;
				 var etime;
				 var eddate;
				 var ed;				 
				 var edtime;				 
				 
				 if(startDateList != undefined && endDateList != undefined){
					sdtTime = startDateList.split(" ");
					sdate = sdtTime [0].split("/");
					stime = sdtTime [1].split(":");
					sddate = sdate[0]+","+sdate[1]+","+sdate[2];
					sd = sdate[2]+"/"+sdate[1]+"/"+sdate[0]; 
					sdtime = stime[0]+":"+stime[1]; 
					
					edtTime = endDateList.split(" ");
					edate = edtTime [0].split("/");
					etime = edtTime [1].split(":");
					eddate = edate[0]+","+edate[1]+","+edate[2];
					ed = edate[2]+"/"+edate[1]+"/"+edate[0];
					edtime = etime[0]+":"+etime[1];
					
					document.getElementById("vehicledetailsstartdate").innerHTML=sd;
			   	 	document.getElementById("vehicledetailsstarttime").innerHTML=sdtime;
			   	 	document.getElementById("vehicledetailsenddate").innerHTML=ed;
			   	 	document.getElementById("vehicledetailsendtime").innerHTML=edtime;
			   	
			   	 	Ext.getCmp('startDateId').setValue(new Date(sddate));
				 	Ext.getCmp('startTimeId').setValue(sdtime);
				 	Ext.getCmp('endDateId').setValue(new Date(eddate));
				 	Ext.getCmp('endTimeId').setValue(edtime);
				 }
	             loadMask.hide();
	             if(datalist.length > 0){
	             	createPolylineTrace();
	             	plotHistoryToMap('StopOrIdle');
	             }else{
	             	Ext.example.msg("No Record Found");
	             	var geocoder = new google.maps.Geocoder();
				    geocoder.geocode({'address': countryName}, function(results, status) {
				      if (status == google.maps.GeocoderStatus.OK) {
					        map.setCenter(results[0].geometry.location);
					        map.fitBounds(results[0].geometry.viewport);
					        Ext.getCmp('startDateId').setValue();
							Ext.getCmp('startTimeId').setValue();
							Ext.getCmp('endDateId').setValue();
							Ext.getCmp('endTimeId').setValue();
			             	document.getElementById("vehicledetailsstartdate").innerHTML="";
						   	document.getElementById("vehicledetailsstarttime").innerHTML="";
						   	document.getElementById("vehicledetailsenddate").innerHTML="";
						   	document.getElementById("vehicledetailsendtime").innerHTML="";
				      	}
				    });
	             	
	             }
			} 
		});
	}
	
	function getOptionList()
	{
		myWinForOptions.show();
		for(var i=0;i<grid.getSelectionModel().getSelections().length;i++)
   		{
   			var selectedRecord = grid.getSelectionModel().getSelections()[i];
   			previousChecks.push(selectedRecord);
   		}
	   	optionsStore.load({
		params:{},
		callback:function(){
		if(previousChecks.length>0)
		{
		for(var i=0;i<previousChecks.length;i++)
		{
		    var rec = previousChecks[i];
		    if(rec.data['optionIdIndex'] != '1' && buttonValue == 'submit')
		    {
				var rec1=optionsStore.find('optionIdIndex', 1);
			    grid.getSelectionModel().selectRow(rec1,true);
		    }
		    if(rec.data['optionIdIndex'] != '5' && buttonValue == 'submit')
		    {
			    var rec2=optionsStore.find('optionIdIndex', 5);
			    grid.getSelectionModel().selectRow(rec2,true);
		    }
			var record=optionsStore.find('optionIdIndex', rec.data['optionIdIndex']);
			grid.getSelectionModel().selectRow(record,true);
		}
		} else {
			var rec1=optionsStore.find('optionIdIndex', 1);
			grid.getSelectionModel().selectRow(rec1,true);
			var rec2=optionsStore.find('optionIdIndex', 5);
			grid.getSelectionModel().selectRow(rec2,true);
		}
		previousChecks = [];
		buttonValue = "";
	    }
   	  }); 
	}
	//******************************sand Mining report*******************************//
	function Dataload(){

	var vehicleNo='<%=vehicleNumber%>';
	var timeband = 0;
	var startdate = '<%=startd%>';
	var starttimehr = '<%=starthr%>';
	var starttimemin = '<%=startmin%>';
	var enddate = '<%=endd%>';
	var endtimehr = '23';
	var endtimemin = '59';
	var fromloc='<%=fromlocation%>';
	var toloc='<%=tolocation%>';
   	
	$.ajax({
		url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=sandReport',
		data:{
			vehicleNo:vehicleNo,
			startdate:startdate,
			timeband:timeband,
			startdatetimehr:starttimehr,
			startdatetimemin:starttimemin,
			enddate:enddate,
			endtimehr:endtimehr,
			endtimemin:endtimemin,
			recordForSixhrs : 'recordForGivenDate'
			},
			success: function(result) {
			datalist = [];
			infolist = [];
			distanceList = [];
			titleMkr = [];
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
			 var startDateList = dataAndInfoList["vehiclesTrackingRoot"][3].startDate;
			 var endDateList = dataAndInfoList["vehiclesTrackingRoot"][4].endDate;
	             	document.getElementById('vehicleDetailsId').innerHTML=vehicleNo;
					document.getElementById("vehicledetailsstartdate").innerHTML=startdate;
			   	 	document.getElementById("vehicledetailsstarttime").innerHTML=starttimehr+':'+starttimemin;
			   	 	document.getElementById("vehicledetailsenddate").innerHTML=enddate;
			   	 	document.getElementById("vehicledetailsendtime").innerHTML=endtimehr+':'+endtimemin;
			   	
			   		$("#vehicleId").val(vehicleNo);
					//Ext.getCmp('vehicleId').setValue(vehicleNo);
			   	 	Ext.getCmp('startDateId').setValue((startdate));
				 	Ext.getCmp('startTimeId').setValue(starttimehr+':'+starttimemin);
				 	Ext.getCmp('endDateId').setValue((enddate));
				 	Ext.getCmp('endTimeId').setValue(endtimehr+':'+endtimemin); 
	             if(datalist.length > 0){
	             	createPolylineTrace();
	             	plotHistoryToMap('StopOrIdle');
	             }else{
	             	Ext.example.msg("No Record Found");
	             	var geocoder = new google.maps.Geocoder();
				    geocoder.geocode({'address': countryName}, function(results, status) {
				      if (status == google.maps.GeocoderStatus.OK) {
					        map.setCenter(results[0].geometry.location);
					        map.fitBounds(results[0].geometry.viewport);
					        Ext.getCmp('startDateId').setValue();
							Ext.getCmp('startTimeId').setValue();
							Ext.getCmp('endDateId').setValue();
							Ext.getCmp('endTimeId').setValue();
			             	document.getElementById("vehicledetailsstartdate").innerHTML="";
						   	document.getElementById("vehicledetailsstarttime").innerHTML="";
						   	document.getElementById("vehicledetailsenddate").innerHTML="";
						   	document.getElementById("vehicledetailsendtime").innerHTML="";
				      	}
				    });
	             	
	             }
	             if(fromlat !=0 && fromlong !=0) //start point
		            {
						imageurl='/ApplicationImages/VehicleImages/GreenBalloon.png';
						createFromlocationMarker(fromlat,fromlong,imageurl);
		            }
		            if(tolat !=0 && tolong !=0) //end point
		            {
						imageurl='/ApplicationImages/VehicleImages/PinkBalloon.png';
						createTolocationMarker(tolat,tolong,imageurl);
		            }
			} 
		});
	}
	
		//******************************Shiftwise Trip report*******************************//
	function loadHistData(){

	var vehicleNo='<%=vehicleNo%>';
	var timeband = 0;
	var startdate = '<%=startDate%>';
	var starttimehr = '<%=startTimeHr%>';
	var starttimemin = '<%=startTimeMin%>';
	var enddate = '<%=endDate%>';
	var endtimehr = '<%=endTimeHr%>';
	var endtimemin = '<%=endTimeMin%>';
	
   	
	$.ajax({
		url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=shiftWiseTripReport',
		data:{
			vehicleNo:vehicleNo,
			startdate:startdate,
			timeband:timeband,
			startdatetimehr:starttimehr,
			startdatetimemin:starttimemin,
			enddate:enddate,
			endtimehr:endtimehr,
			endtimemin:endtimemin,
			recordForSixhrs : 'recordForGivenDate'
			},
			success: function(result) { 
			datalist = [];
			infolist = [];
			distanceList = [];
			titleMkr = [];
			dataAndInfoList = JSON.parse(result);
			console.log("jsdhfkjsdfh",dataAndInfoList);
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
			 var startDateList = dataAndInfoList["vehiclesTrackingRoot"][3].startDate;
			 var endDateList = dataAndInfoList["vehiclesTrackingRoot"][4].endDate;
	         document.getElementById('vehicleDetailsId').innerHTML=vehicleNo;
			 document.getElementById("vehicledetailsstartdate").innerHTML=startdate;
	  	 	 document.getElementById("vehicledetailsstarttime").innerHTML=starttimehr+':'+starttimemin;
	  	 	 document.getElementById("vehicledetailsenddate").innerHTML=enddate;
	  	 	 document.getElementById("vehicledetailsendtime").innerHTML=endtimehr+':'+endtimemin;
			   	
	   		$("#vehicleId").val(vehicleNo);
	   		//Ext.getCmp('vehicleId').setValue(vehicleNo);
	   	 	 Ext.getCmp('startDateId').setValue((startdate));
		 	 Ext.getCmp('startTimeId').setValue(starttimehr+':'+starttimemin);
		 	 Ext.getCmp('endDateId').setValue((enddate));
		 	 Ext.getCmp('endTimeId').setValue(endtimehr+':'+endtimemin); 
	             if(datalist.length > 0){
	             	createPolylineTrace();
	             	plotHistoryToMap('StopOrIdle');
	             	map.setZoom(14);
	             }else{
	             	Ext.example.msg("No Record Found");
	             	var geocoder = new google.maps.Geocoder();
				    geocoder.geocode({'address': countryName}, function(results, status) {
				      if (status == google.maps.GeocoderStatus.OK) {
					        map.setCenter(results[0].geometry.location);
					        map.fitBounds(results[0].geometry.viewport);
					        Ext.getCmp('startDateId').setValue();
							Ext.getCmp('startTimeId').setValue();
							Ext.getCmp('endDateId').setValue();
							Ext.getCmp('endTimeId').setValue();
			             	document.getElementById("vehicledetailsstartdate").innerHTML="";
						   	document.getElementById("vehicledetailsstarttime").innerHTML="";
						   	document.getElementById("vehicledetailsenddate").innerHTML="";
						   	document.getElementById("vehicledetailsendtime").innerHTML="";
				      	}
				    });
	             	
	             }
	             if(fromlat !=0 && fromlong !=0) //start point
		            {
						imageurl='/ApplicationImages/VehicleImages/GreenBalloon.png';
						createFromlocationMarker(fromlat,fromlong,imageurl);
		            }
		            if(tolat !=0 && tolong !=0) //end point
		            {
						imageurl='/ApplicationImages/VehicleImages/PinkBalloon.png';
						createTolocationMarker(tolat,tolong,imageurl);
		            }
			} 
		});
	}
	
	//==================================//
	function createFromlocationMarker(lat,lon,imageurl){
      		var position = new google.maps.LatLng(lat,lon);
	        var marker = new google.maps.Marker({
		    position: position,
		    map: map,
		    icon:imageurl
		  });
		  simpleMarkers.push(marker);  
        content='From Place:'+'<%=fromlocation%>'; 	
		infowindow = new google.maps.InfoWindow({
      		content:content,
      		marker:marker,
      		minWidth:400,
      		maxWidth: 400
  		});	 
		  google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){   			
  				return function() {
    				infowindow.setContent(content);
        			infowindow.open(map,marker);        			        			
    			};
			})(marker,content,infowindow));
			
		var latlng = new google.maps.LatLng(lat, lon);
        map.setCenter(latlng); 
		} 
			//==================================//
	function createTolocationMarker(lat,lon,imageurl){
      		var position = new google.maps.LatLng(lat,lon);
	        var marker = new google.maps.Marker({
		    position: position,
		    map: map,
		    icon:imageurl
		  });
		  simpleMarkers.push(marker);  
		  content='To Place:'+'<%=tolocation%>'; 	
		infowindow = new google.maps.InfoWindow({
      		content:content,
      		marker:marker,
      		minWidth:400,
      		maxWidth: 400
  		});	 
		  google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){   			
  				return function() {
    				infowindow.setContent(content);
        			infowindow.open(map,marker);        			        			
    			};
			})(marker,content,infowindow));
			
		var latlng = new google.maps.LatLng(lat, lon);
        map.setCenter(latlng);	
		}
/***************************plotting markers with infowindow****************************/     
       function plotHistoryToMap(type){
	       	var lon = 0.0;
	        var lat = 0.0;
	        var mkrCtr=0;
	        var k = 0;
	        var stopOrIdleHours = "Stop";
	        if(unitOfMeasurement=="mile"){
	           unitOfMeasurement="miles";
	        } 
	        else if(unitOfMeasurement=="nmi"){
	           unitOfMeasurement="nmi";	                 
	         } 
	        else if(unitOfMeasurement=="kms"){
	           unitOfMeasurement="kms";
	        }  
	        if(datalist != null){
         	for(var i=0;i<datalist.length;i++){
         		if(datalist[i] != null && datalist[i+1] != null && datalist[i+2] != null)
          		{
		            lat = datalist[i];
		            lon = datalist[i+1];
		            if(i==0){ 	//start flag
						imageurl='/ApplicationImages/VehicleImages/startflag.png';
						createSimpleMarker(lat,lon,imageurl);
            		}
            		else if(i==datalist.length-3){ 	//stop flag            			
            			imageurl='/ApplicationImages/VehicleImages/endflag.png';
						createSimpleMarker(lat,lon,imageurl);
            		}
            		if(datalist[i+2] == "1"){ 	//stop
						imageurl='/ApplicationImages/VehicleImages/redbal.png';
						stopOrIdleHours = "Stop";
            		}
            		else if(datalist[i+2] == "2"){  //overspeed
           				imageurl='/ApplicationImages/VehicleImages/bluebal.png';
           			} 
           			else if(datalist[i+2] == "3")//idle
           			{
           				imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
           				stopOrIdleHours = "Idle";
           			}
           			else{
           				imageurl='/ApplicationImages/VehicleImages/GreenBalloon1.png';
           			}
           			var date = convert(infolist[k]);
            	 	var dateString = convertUTC(infolist[k]);
             		var dateUTC= new Date(dateString);
             		titleMkr.push(dateUTC);
             		titleMkr.push(mkrCtr);
	             	var loc = infolist[k+3];
	             	var loctn="";
	             	if(loc != null && loc != "" && loc != undefined){
	             		loctn = loc.replace(/\'/g, "");
	             	}
	             	var speed = infolist[k+4];
              		var stopHrs=getHrMinsFormat(infolist[k+5]);
	          		k = k + 6;
	          		if(datalist[i+2] == "1" ){
	          			var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+									  
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">'+stopOrIdleHours+' Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		else if(datalist[i+2] == "3" ){
	          		 	var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">'+stopOrIdleHours+' Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		else if(datalist[i+2] == "2"){
	          		 	var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">'+stopOrIdleHours+' Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		else{
	          			var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">'+stopOrIdleHours+' Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}

	          		if(type == 'Speed' && imageurl == '/ApplicationImages/VehicleImages/GreenBalloon1.png')
	          		{
	          			createMarker(lat,lon,content,imageurl,type);
	          		} else if(type == 'StopOrIdle' && imageurl != '/ApplicationImages/VehicleImages/GreenBalloon1.png'){
	          			createMarker(lat,lon,content,imageurl,type);
	          		} else if(type == 'Both'){
	          			createMarker(lat,lon,content,imageurl,'');
	          		}

         		}
         		var Bounds = new google.maps.LatLngBounds(new google.maps.LatLng(lat, lon),new google.maps.LatLng(lat,lon));
		        map.fitBounds(Bounds); 
		        map.setZoom(14);		       
		        i+=2;
		        mkrCtr++;
       		}
       		}
       		hideLabel();
        	document.getElementById("lablesel").value = 0
       		var listener = google.maps.event.addListener(map, "idle", function() { 
       		//	map.setZoom(mapZoom);
       			//if (map.getZoom() > 16) map.setZoom(mapZoom);
					google.maps.event.removeListener(listener); 
			});
			if(fromMapView){ 
	         	//livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},60000);   
	        }
       	}
      function createSimpleMarker(lat,lon,imageurl){
      		var position = new google.maps.LatLng(lat,lon);
	        var marker = new google.maps.Marker({
		    position: position,
		    map: map,
		    icon:imageurl
		  });
		  simpleMarkers.push(marker);  	
		} 
	 function createMarker(lat,lon,content,imageurl,type){
	 	var pos= new google.maps.LatLng(lat,lon);
	 	var marker = new google.maps.Marker({
            position: pos,
            map: map,
            icon: imageurl
        	});
        	if(type == 'Speed'){
        		speedMarkers.push(marker);
        		infowindow = new google.maps.InfoWindow({
		      		contents: content,
		      		marker:speedMarkers,
		      		minWidth:400,
		      		maxWidth: 400
	  		 	});
        	} else {
        		markers.push(marker);
        		infowindow = new google.maps.InfoWindow({
		      		contents: content,
		      		marker:marker,
		      		minWidth:400,
		      		maxWidth: 400
	  		 	});
        	}
	 	      		 		
  		google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){   			
  				return function() {
    				infowindow.setContent(content);
        			infowindow.open(map,marker);        			        			
    			};
			})(marker,content,infowindow));
			
		var latlng = new google.maps.LatLng(lat, lon);
        map.setCenter(latlng); 
        map.setZoom(14);
	} 
	
/*********************************create polylines***************************/
	  function tracepath(cb){ 
	 	if(cb.checked){	
	        createPolylineTrace(); 
      	}else{
      		removePolylineTrace(); 
	 	}
	 }    	
	 function createPolylineTrace(){
	 	var lon = 0.0;
		var lat = 0.0; 
		var flightPath=[];
		var lineSymbol = {
        	path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
        	scale: 2,
        	strokeColor: '#006400',
    	};
		for(var i=0;i<datalist.length;i++){
			lat = datalist[i];
		    lon = datalist[i+1];
		    if(i == 0)
		    {
			    var positionFlag = new google.maps.LatLng(lat,lon);
		        markerFlag = new google.maps.Marker({
			    position: positionFlag,
			    map: map,
			    icon:'/ApplicationImages/VehicleImages/startflag.png'
			    });
			    firstLatLong = positionFlag;
		    }
		    var latLong = new google.maps.LatLng(lat,lon);
		    flightPath.push(latLong);  	
		    if(i == (datalist.length - 3))
		    {
		    		var positionFlag = new google.maps.LatLng(lat,lon);
			        markerFlagGreen = new google.maps.Marker({
				    position: positionFlag,
				    map: map,
				    icon:'/ApplicationImages/VehicleImages/endflag.png'
				    });
		        	var BoundsForPlotting = new google.maps.LatLngBounds();
					BoundsForPlotting.extend(firstLatLong);
					BoundsForPlotting.extend(latLong);
					map.fitBounds(BoundsForPlotting);
					map.setZoom(14);
					
		    }
			i+=2;			
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
		if(firstload == 1){		
        	animatePolylines();
        }
        firstload = 0; 		
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
/********************************Play/Pause**********************************/	 
	 var playCount = 0;
	 var playDataList = datalist;
	 var playInfoDataList = infolist;
	 var playTitle = 1;
	 var infoCount = 0;
	 var i =0;
	 var startCtr;
	 var endCtr;
	 var pausedCtr=0;
	 var clickeventofimg = false; 	
	 function getStartEndCounterForPlay(){
	 	startCtr=0;
	    endCtr=(titleMkr.length/2)-1; 
	 }
	function playHistoryTracking(cb)
	 { 
	 // document.getElementById("unchecked").disabled=true;
	  clearInterval(livePlottingInterval);
 	   if(pausedCtr==0){ 
			getStartEndCounterForPlay();
	        playCount=startCtr*3;
        }else{        	
	         playCount=pausedCtr*3;
	         i=pausedCtr;
	         infoCount=pausedCtr*6;
	         playTitle = pausedCtr+1;
	         pausedCtr=0;
        }
	     if (startCtr==endCtr){
	          Ext.example.msg("No records to Play during this interval.");
	     }else{
	       if(cb.alt=="Play History Analysis"){
		         running=true; 
		         if(playCount==startCtr*3){
			         clearMap();
			         clearMarkers();	         		       		
			 		 playCount = startCtr*3;
			 		 playTitle = 1;
			 		 infoCount = startCtr*6;
			 		 i=startCtr;
		 		 }
		 		 playDataList = datalist;
		 		 playInfoDataList = infolist;
			 	 if (typeof(sliderValue)=="undefined" || sliderValue==0){
			 	 		timerval = window.setInterval("animate()",1000);
						cb.src ="/ApplicationImages/ApplicationButtonIcons/pause.png";
						cb.alt = "Pause History Analysis";
				}else if (sliderValue>=0){
					timerval = window.setInterval("animate()",(10000/sliderValue));
					cb.src ="/ApplicationImages/ApplicationButtonIcons/pause.png";
					cb.alt = "Pause History Analysis";
				}
				if(fromSandReport){ 	
	         	//livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},60000);  
				if(fromlat !=0 && fromlong !=0) //start point
		            {
						imageurl='/ApplicationImages/VehicleImages/GreenBalloon.png';
						createFromlocationMarker(fromlat,fromlong,imageurl);
		            }
		            if(tolat !=0 && tolong !=0) //end point
		            {
						imageurl='/ApplicationImages/VehicleImages/PinkBalloon.png';
						createTolocationMarker(tolat,tolong,imageurl);
		            }
			 	} 
			 	createPolylineTrace();
			}else {
			 	 clearInterval(timerval);
		         cb.src ="/ApplicationImages/ApplicationButtonIcons/play.png";
			     cb.alt = "Play History Analysis";
			     running=false;
			     pausedCtr=i;
			}													
		 }
		 var listener = google.maps.event.addListener(map, "idle", function() {    				 
	 		//if (map.getZoom() > 16) map.setZoom(mapZoom);
				google.maps.event.removeListener(listener); 
		 });		        
		}
		
	function animate(){
	 	if(playCount < (endCtr+1)*3) {
	 		if(unitOfMeasurement=="mile"){
	           unitOfMeasurement="miles";
	        } 
	        else if(unitOfMeasurement=="nmi"){
	           unitOfMeasurement="nmi";	                 
	         } 
	         else if(unitOfMeasurement=="kms"){
	           unitOfMeasurement="kms";
	        }
		 	var lon = playDataList[playCount+1];
		 	var lat = playDataList[playCount];
        	
		 	if(playCount==0) //start point
            {
				imageurl='/ApplicationImages/VehicleImages/startflag.png';
				createSimpleMarker(lat,lon,imageurl);
            }
            else if(playCount==playDataList.length-3) // last point
            { 	
				imageurl='/ApplicationImages/VehicleImages/endflag.png';
				createSimpleMarker(lat,lon,imageurl);					 
		    }
            if(playDataList[playCount+2] == "1") //stop
            {	
				imageurl='/ApplicationImages/VehicleImages/redbal.png';
            }  
            else if(playDataList[playCount+2] == "2")  //overspeed
            {
				imageurl='/ApplicationImages/VehicleImages/bluebal.png';
            }
            else if(playDataList[playCount+2] == "3")//idle
            {
            	imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
            }
			else  //other points
            {	
				imageurl='/ApplicationImages/VehicleImages/GreenBalloon1.png';
			}
			var date = convert(playInfoDataList[infoCount]);
			var loctn;
			var loc = playInfoDataList[infoCount+3];
           	if(loc != null && loc != "" && loc != undefined){
           		loctn = loc.replace(/\'/g, "");
           	}
			var speed = playInfoDataList[infoCount+4];             
			var stopHrs =getHrMinsFormat(playInfoDataList[infoCount+5]);
			infoCount = infoCount + 6; 
	        if(playDataList[playCount+2] == "1"){
	            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
							  '<table class="infotable">'+
							  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
							  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
							  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
							  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
							  '<tr><td></td><td>'+
							  '<span class="create-land-route">'+
							  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
							  '</td></tr>'+
							  '</div>';
	             }
	           else if(playDataList[playCount+2] == "3")
	             {
	               var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
								  '<table class="infotable">'+
								  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
								  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
								  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
								  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
								  '<tr><td></td><td>'+
								  '<span class="create-land-route">'+
								  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
								  '</td></tr>'+
								  '</div>';
	             }
	             else if(playDataList[playCount+2] == "2")
	             {
	             var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
							  '<table class="infotable">'+
							  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
							  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
							  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
							  '<tr><td></td><td>'+
							  '<span class="create-land-route">'+
							  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
							  '</td></tr>'+
							  '</div>';
	             }
	             else
	             {
	              var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
							  '<table class="infotable">'+
							  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
							  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
							  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
							  '<tr><td></td><td>'+
							  '<span class="create-land-route">'+
							  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
							  '</td></tr>'+
							  '</div>';
			    }        
	          	createMarker(lat,lon,content,imageurl,''); 
				  
				imageurl='/ApplicationImages/VehicleImages/greenbal.png';					
				if (mkrColl.length>0){					
					var greenMarkerlength=mkrColl.length-1;					
		   			var greenMarker = mkrColl[greenMarkerlength];
					greenMarker.setMap(null);
	    			greenMarker=null;		    				  								
	    		} 				
	    		if(i>0 && i<(playDataList.length/3)-1){
	    			var position = new google.maps.LatLng(lat,lon);
			    	var marker = new google.maps.Marker({
		            position: position,
		            map: map,
		            icon: imageurl
		        	});
		        	mkrColl.push(marker);      	 
		   		}
		   		document.getElementById("dateId").innerHTML=date;
	   			document.getElementById("speedId").innerHTML=speed;
	   			document.getElementById("speedMeasure").innerHTML=unitOfMeasurement;
	   			document.getElementById("locationId").innerHTML=loctn;				   		 
				i++;
		   	    playCount = playCount + 3;
				playTitle++;
			 }		 	 
		 if (playCount==(endCtr+1)*3){
		 	 //document.getElementById("unchecked").disabled=false;
		 	 running=false;
	         var e=document.getElementById("play/pause");
	         e.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
		     e.alt = "Play History Analysis";
	         playCount=0;
	         i=0;
	         infoCount=0;
	         running=false;
	         pausedCtr=0;
	         clearInterval(timerval);
	         startCtr=0;
	         endCtr=0;
	         title=1;
	         document.getElementById("dateId").innerHTML="";
	    	 document.getElementById("speedId").innerHTML="";
	    	 document.getElementById("speedMeasure").innerHTML="";
	    	 document.getElementById("locationId").innerHTML="";
	         titleMkr=[];
	         clearMarkers();
	         markers=[];
	         plotHistoryToMap('Both'); 
	         if(fromMapView){ 
	         	//livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},60000);   
	         }
	         if(fromSandReport){ 	
	        // livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},60000);  
			 }  
        }       					
 	}
/********************************Stop Tracking**********************************/	
 	function stopHistoryTracking(){
 		//document.getElementById('unchecked').disabled=false; 
	 	var cb=document.getElementById("play/pause");
        cb.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
     	cb.alt = "Play History Analysis";
        playCount=0;
        i=0;
        infoCount=0;
        running=false;
        pausedCtr=0;
        clearInterval(timerval);
        clearInterval(livePlottingInterval);
        running=false;
        startCtr=0;
        endCtr=0;
        title=1;
        document.getElementById("dateId").innerHTML="";
	    document.getElementById("speedId").innerHTML="";
	    document.getElementById("speedMeasure").innerHTML="";
	    document.getElementById("locationId").innerHTML="";
        titleMkr=[];
        clearMarkers();
        clearMovingMarkers();
        clearMap();
        plotHistoryToMap('Both');
        if(fromMapView){ 
         	//livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},60000);   
         }
          if(fromSandReport){ 
			//livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},60000);  
	           if(fromlat !=0 && fromlong !=0) //start point
		            {
						imageurl='/ApplicationImages/VehicleImages/GreenBalloon.png';
						createFromlocationMarker(fromlat,fromlong,imageurl);
		            }
		            if(tolat !=0 && tolong !=0) //end point
		            {
						imageurl='/ApplicationImages/VehicleImages/PinkBalloon.png';
						createTolocationMarker(tolat,tolong,imageurl);
		            }   
			}                
       }
/******************************remove markers and polylines******************************/ 
	  function clearSimpleMarkers() {
  		for (var i = 0; i < simpleMarkers.length; i++) {
    		var marker = simpleMarkers[i];
    			marker.setMap(null);
    			marker=null;
  		} 
  		simpleMarkers.length = 0; 		
	 }
	 function clearMarkers() {
  		for (var i = 0; i < markers.length; i++) {
    		var marker = markers[i];
    			marker.setMap(null);
    			marker=null;
  		} 
  		markers.length = 0; 		
	 }
	 function clearSpeedMarkers() {
  		for (var i = 0; i < speedMarkers.length; i++) {
    		var marker = speedMarkers[i];
    			marker.setMap(null);
    			marker=null;
  		} 
  		speedMarkers.length = 0; 		
	 }
	 function clearMovingMarkers() {
		for (var i = 0; i < mkrColl.length; i++) {
			mkrColl[i].setMap(null);
		} 
		 	mkrColl.length=0;	
	 }	 
	 function removePolylineTrace(){	 	
	     for(var i=0;i<polylines.length;i++){
	     	var poly = polylines[i];
	     	poly.setMap(null);
	     	poly=null;
	     } 
	     polylines.length = 0;  	 		
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
		borderCircles.length = 0;
	}
	function removerichmarkers(){
	 	for(var i=0; i<labelmarkers.length; i++){
		  var marker = labelmarkers[i];
		  marker.setMap(null);
		}
		  labelmarkers.length=0;
	 }
	 function clearMap(){
	 	clearSimpleMarkers();
	 	removePolylineTrace();
	 	//removeBorder();
	 	removerichmarkers();
	 }
/***********************************end of remove markers and polylines***********************************/ 
    function convert(time){
    	var date = "";
        if(time != null && time != "" && time != undefined){
	     	date = time.replace(/\'/g, "");
	     	return date;
	     }else{
	     	return date;
	     }
	 }
	 function convertUTC(time){
	 	 var date = "";
	 	 if(time != null && time != "" && time != undefined){
	     	date = time.replace(/\'/g, "");
	     	return date;
	     }else{
	     	return date;
	     }
	 }
 	 function getHrMinsFormat(strHrs){
	 	var stoptime = String (strHrs).split('.');
		var hrs=stoptime[0];
		var mins="0";
		if(stoptime.length>1){
			mins=stoptime[1];
		}
		if(hrs < 10){
			hrs="0"+hrs;
		}
		if(mins.length == 1){
			mins=mins+"0";
		}
		var Time = hrs + " Hr(s) " + mins + " Min(s) ";
		return Time;
	 }
/*****************************************Buffer, Polygon & Border Stores*****************************************/	
var historyTrackingstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=getVehicles',
    id: 'vehiclesId',
    root: 'vehiclesRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['vehicleNo']	
});

//console.log("history Tracking store", historyTrackingstore);
var hisTrackingJson = [];
$.ajax({
		url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=getVehicles',
	
			success: function(result) {
				
				let response = JSON.parse(result);
				hisTrackingJson = response.vehiclesRoot;
				//console.log("hisTrackingJson", hisTrackingJson);
			}
})




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
var borderStore=new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/MapView.do?param=getBorderForMapView',
	id:'borderMapView',
	root: 'borderMapView',
	autoLoad: false,
	remoteSort: true,
	fields: ['longitude','latitude','borderName','borderSequence','borderHubid','lat','long','borderRadius']
});	
/*****************************************Show Hubs*****************************************/
	function showHub(cb){
		if(cb.checked){
			loadMask.show();
			bufferStore.load({
			    callback:function(){
			    	plotBuffers();
			    	}
			});
			polygonStore.load({
			    callback:function(){
			    	plotPolygon();	
			    	}
			});	
			borderStore.load({
			    callback:function(){
			    	plotBorder();
			    	loadMask.hide();	
			    	}
			});
		}else{			
			for(var i=0;i<circles.length;i++){
			    	circles[i].setMap(null);
			    	buffermarkers[i].setMap(null);
			}
			circles.length=0;
			for(var i=0;i<polygons.length;i++){
		    	polygons[i].setMap(null);
		    	polygonmarkers[i].setMap(null);
			}
			polygons.length=0;
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
	} 
/*****************************************Ploting Buffers*****************************************/	
function plotBuffers(){
	for(var i=0;i<bufferStore.getCount();i++){
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
	    if(convertRadiusToMeters==0 && rec.data['imagename']!=''){
	        var image1='/jsps/images/CustomImages/';
	        var image2=rec.data['imagename'];
	        urlForZero= image1+image2 ;
	    }else if (convertRadiusToMeters==0 && rec.data['imagename']==''){
	        urlForZero='/jsps/OpenLayers-2.10/img/marker.png';
	    }
		bufferimage = {
			url: urlForZero,
			scaledSize: new google.maps.Size(19, 35),
			origin: new google.maps.Point(0, 0),
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
/*****************************************Ploting Polygon*****************************************/	
function plotPolygon(){
	var hubid=0;
	var polygonCoords=[];
	var polygonlines = [];
	for(var i=0;i<polygonStore.getCount();i++){
		var rec=polygonStore.getAt(i);
		if(i!=polygonStore.getCount()-1 && rec.data['hubid']==polygonStore.getAt(i+1).data['hubid']){			
			var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
			polygonCoords.push(latLong);
			continue;
		}else{
		
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
			url: '/ApplicationImages/VehicleImages/information.png',
			size: new google.maps.Size(48, 48),
			origin: new google.maps.Point(0, 0),
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
/*****************************************Ploting Border*****************************************/	
	function plotBorder(){
  		var hubid=0;
	   	var borderCoords=[];
	   	var circleBorderCount=0;
	    for(var i=0;i<borderStore.getCount();i++){	    	
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
	    	if(i!=borderStore.getCount()-1 && rec.data['borderHubid']==borderStore.getAt(i+1).data['borderHubid']){
		    	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
		    	borderCoords.push(latLong);
		    	continue;
			}else{
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
  			hubid++;
  			borderCoords=[];
	    	}
	    }
	}
/*****************************************Show Labels*****************************************/	
	function getDistance(){
	  distArray.push(0);
	  var totaldistance=0;
	  for(var i=1;i<markers.length;i++){
	  var point1= new google.maps.LatLng(markers[i].getPosition().lat(),markers[i].getPosition().lng());
	  var point2= new google.maps.LatLng(markers[i-1].getPosition().lat(),markers[i-1].getPosition().lng());
	  distance= calcDistance(point1,point2);
	  totaldistance+=distance;	  
	  distArray.push(totaldistance)
	  }
	  setLabel();
	}
	function showLabel() {	
	 for(var i=0; i<labelmarkers.length; i++){
	  var marker = labelmarkers[i];
	  marker.setVisible(true);
	  }
	}	
	function hideLabel() {
	 for(var i=0; i<labelmarkers.length; i++){
	  var marker = labelmarkers[i];
	  marker.setVisible(false);
	  }
	}	
	function setLabel() {
	  distArray = distanceList;	  
	  for(var i=0; i<markers.length; i++){
	    var position = new google.maps.LatLng(markers[i].getPosition().lat(),markers[i].getPosition().lng());
	   	var labl = distArray[i];
	    var label = parseFloat(labl).toFixed(2);
	    var content = '<div class="my-other-marker">'+
	    '<div class="poslabel">'+label+'</div>'+
	    '<div class="poslabel">'+unitOfMeasurement+'</div>'+
	    '</div>';
	    createRichMarker(position,content);       
	  	}
	}
	function labeloption(e){
		if(e.id=="checked"){
	     e.id="notchecked"
	     hideLabel();
	     document.getElementById("lablesel").value = 0;
	     document.getElementById("lablesel").disabled=true;
	   }else{
	     e.id="checked"
	     if(document.getElementById("lablesel").value != 0){
	         showLabel();
	     }
	     document.getElementById("lablesel").disabled=false;
	   }
	}
	function setlabelgap(){
	   if(document.getElementById("lablesel").value != 0)
	   {
	   	var lablegap=document.getElementById("lablesel").value;
		if(lablegap=="Position"){
		   hideLabel();	
		   for(var i=0,count=1;i<markers.length;i++){
		  	var position = new google.maps.LatLng(markers[i].getPosition().lat(),markers[i].getPosition().lng());
			var content = '<div class="my-other-marker">'+ count +'</div>';
			createRichMarker(position,content);	
			count++;			    
		  }
		}else{
		  getDistance();
		 for(var j=0;j<labelmarkers.length;j++){	
		  var marker = labelmarkers[j];
		  marker.setVisible(false);
		 }
		 if(!running){  
		   for(var j=0;j<markers.length;j++){ 
			 if(j!==0 && j!=markers.length-1 && j%lablegap == 0){ 
			   labelmarkers[j].setVisible(true);
			 }
		   }
		 }else{
	           for(var j=0;j<=i;j++){
	             if(j!==0 && j!=labelmarkers.length-1 && j%lablegap == 0){
	               labelmarkers[j].setVisible(true);
	             }
	           }
	         }
	       }
	    }
	   else
	   {
	    for(var j=0;j<labelmarkers.length;j++){
		  var marker = labelmarkers[j];
		  marker.setVisible(false);
		 }	
	   }	       
	}
	function createRichMarker(position,content){
		var labelMarker = new RichMarker({
	          map: map,
	          position: position,
	          draggable: false,
	          flat: true,
	          anchor:RichMarkerPosition.MIDDLE,
	          content: content
	        });
	    labelmarkers.push(labelMarker);	
	}
/*****************************************Create Landmark*****************************************/	
function openLndmrkCreation(lat,lon){
	var vehicleNo = document.getElementById('vehicleId').value.split("[")[0];	
	//var vehicleNo = Ext.getCmp('vehicleId').getValue().split("[")[0];	
	vehicleNo = vehicleNo.replace(/ /g, "%20");
	if(<%=systemid%> == 257 && <%=customerId%> == 4522 && <%=userId%> == 198){
	// for Secure value History Analysis
	}
	else{
	var locationPage="<%=request.getContextPath()%>/Jsps/Common/CreateLandmark.jsp?vehicle="+vehicleNo+"&lat="+lat+"&lon="+lon;
	openLocationWindow(locationPage);	 
	}		 
}
/*****************************************Panel Details*****************************************/	
 var countId = 0;	
  	var vehiclecombo = new Ext.form.ComboBox({
		cls:'selectstylePerfect',
		height:20,
		width:150,
		emptyText:'Select Asset No',
		blankText:'Select Asset No',
		mode: 'local',
		forceSelection: true,
		triggerAction: 'all',
		anyMatch: true,
		onTypeAhead: true,
		selectOnFocus: true,
		store:historyTrackingstore,
		displayField: 'vehicleNo',
		valueField: 'vehicleNo', 				
		id: 'vehicleId',
		listeners: {
			beforeRender: function() {
				clearMarkers();
				clearSpeedMarkers();
				$("#vehicleId").val('<%=vehcleNo%>');
			},
			change: function() {
				clearInterval(livePlottingInterval);
			},
			expand: function(){ 
			 $(".x-combo-list-inner").html("");
			 $.each(hisTrackingJson, function( key, value ) {
				 $(".x-combo-list-inner").append('<div class="x-combo-list-item" onclick="populate(\''+value.vehicleNo+'\')">'+value.vehicleNo+'</div>');
				 
			 })
                   
				
            }
		}
	});
	function populate(value){
		
		$("#vehicleId").val(value);
		clearInterval(livePlottingInterval);
		
	}
	
						
var endDT = new Date().add(Date.DAY, -1);
	var EndDate = new Ext.form.DateField({
	    	 cls: 'selectstylePerfect',
	    	 fieldLabel: 'End Date',
			 id:'endDateId',
			 width: 140,
			format:'d/m/Y ',
             value:endDT,
             maxValue:endDT,
             allowBlank:false,
             menuListeners: {
                select: function(m, d){
                			
            	         this.setValue(d);
                         if(Ext.getCmp('startdate').value!="" && Ext.getCmp('enddate').value!=""){
                             enddate=Ext.getCmp('enddate').value;
                         }
                 }
			 } 				
	   	 });	
  var datepanel = new Ext.Panel({
    standardSubmit: true,
    id: 'datepanelId',
    layout: 'table',
    border: false,
    cls:'dashboardcustomerpannelmap',
    bodyCfg : { cls:'dashboardcustomerpannelmap' , style: {'background-color': 'transparent !important' } },
    layoutConfig: {
        columns: 2
    },
    items: [{
    			xtype:'label',
				cls:'maplabel',
				id: 'vehiclelab',
				text: '<%=assetNo%>'+ ' :'
    		},vehiclecombo,{
  		        xtype: 'label',
  		        cls: 'maplabel',
  		        id: 'startdatelab',
  		        text: '<%=StartDate%>' + ' :'
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        emptyText:'Select Start Date',
				blankText:'Select Start Date',
  		        id: 'startDateId',
  		        format: getDateFormats(),
  		        listeners: {
				}
  		    },{
    			xtype:'label',
				cls:'maplabel',
				id: 'startTimelab',
				text: '<%=startTimeHHMM%>' + ':'
    		},{
    			xtype:'textfield',
				cls:'selectstylePerfect',
				emptyText:'00:00',
				blankText:'00:00',
				id: 'startTimeId',
				listeners: {
				}				
    		},{
  		        xtype: 'label',
  		        cls: 'maplabel',
  		        id: 'enddatelab',
  		        text: '<%=EndDate%>' + ' :'
  		    },
  		    <%if(systemid == 257 && customerId == 4522 && userId == 198){%>
  		     EndDate
  		     <%}else{%>
  		     	{
  		     	xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        emptyText:'Select End Date',
				blankText:'Select End Date',  		        
  		        id: 'endDateId',
  		        format: getDateFormats(), 
  		        listeners: {
				}
  		    }
  		    <%}%>
  		    ,{
    			xtype:'label',
				cls:'maplabel',
				id: 'endTimelab',
				text: '<%=endTimeHHMM%>' + ' :'
    		},{
    			xtype:'textfield',
				cls:'selectstylePerfect',
				emptyText:'00:00',
				blankText:'00:00',
				id: 'endTimeId',
				listeners: {
				}			
    		},{
  		        xtype: 'label',
  		        cls: 'maplabel',  		       
  		        id: ''  		        
  		    },{
  		        xtype: 'label',
  		        cls: 'maplabel',  		       
  		        id: ''  		        
  		    },{
  		        xtype: 'label',
  		        cls: 'maplabel',  		       
  		        id: ''  		        
  		    },{
  		        xtype: 'button',
  		        text: '<%=submit%>',
           		cls : 'buttonCls',
  		        id: 'addbuttonid',
  		        width:80,
  		        handler: function(){
  		        		clearInterval(livePlottingInterval);
  		        		//livePlottingInterval = 0;
           		   		submitValues();
           		   		buttonValue = "submit";
  		    		}  	
  		    }	    
    ]
});
function submitValues(){
	fromMapView = false;
	fromSandReport = false;
	fromTripReport = false;
	fromEssentialReport = false;
	document.getElementById("vehicledetailsstartdate").innerHTML="";
   	document.getElementById("vehicledetailsstarttime").innerHTML="";
   	document.getElementById("vehicledetailsenddate").innerHTML="";
   	document.getElementById("vehicledetailsendtime").innerHTML="";	
   	
	var vehicleNo=document.getElementById('vehicleId').value.split("[")[0];
	//var vehicleNo=Ext.getCmp('vehicleId').getValue().split("[")[0];
	var timeband = 0;
	var startdate = document.getElementById("startDateId").value;
	var starttime = document.getElementById("startTimeId").value.trim();
	var startsTime = starttime.split(":");
	var starttimehr = startsTime[0];
	var starttimemin = startsTime[1];
	var enddate = document.getElementById("endDateId").value;
	var endtime = document.getElementById("endTimeId").value.trim();
	var endsTime = endtime.split(":");
	var endtimehr = endsTime[0];
	var endtimemin = endsTime[1];
	var pattrn = new RegExp("^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
	
	if (vehicleNo == "" || vehicleNo === undefined){
		Ext.example.msg("Please Select Vehicle Number");		
		return false;		
	}		
	if(startdate==""){
		Ext.example.msg("Please Select Start Date");
		return false;
	}
	 var strthhmm = starttimehr+":"+starttimemin;
	 if(!pattrn.test(strthhmm )){
       Ext.example.msg("Please select valid time");
		return false;
    }	 
	if(enddate==""){
		Ext.example.msg("Please Select End Date");
		return false;
	}
	var endhhmm = endtimehr+":"+endtimemin;
	if(!pattrn.test(endhhmm)){
       	Ext.example.msg("Please select valid time");
		return false;
    }
	if (TimeCompare(startdate,enddate,starttimehr,endtimehr,starttimemin,endtimemin)==false){
		Ext.example.msg("Start Time should be less than End Time");
		return false;
	}
	if (DateCompare3(startdate,enddate)==false){
		Ext.example.msg("Start date should be less than End Date");
		return false;
	}
	if(checkDays(startdate,enddate)>7){
		Ext.example.msg("History Tracking is displayed only when the difference between Start Date and End Date is in between 7 days");
		return false;
	}
	loadMask.show();
	document.getElementById('vehicleDetailsId').innerHTML=vehicleNo;
	document.getElementById("vehicledetailsstartdate").innerHTML=startdate;
   	document.getElementById("vehicledetailsstarttime").innerHTML=starttimehr+":"+starttimemin;
   	document.getElementById("vehicledetailsenddate").innerHTML=enddate;
   	document.getElementById("vehicledetailsendtime").innerHTML=endtimehr+":"+endtimemin;	
	
	$.ajax({
		url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=submit',
		data:{
			vehicleNo:vehicleNo,
			startdate:startdate,
			timeband:timeband,
			startdatetimehr:starttimehr,
			startdatetimemin:starttimemin,
			enddate:enddate,
			endtimehr:endtimehr,
			endtimemin:endtimemin,
			},
		success: function(result) {
			clearMap();
			clearMovingMarkers();
			clearMarkers();
			clearSpeedMarkers();
			if(markerFlag != null)
	   		{
	   			markerFlag.setMap(null);
	   		}
	   		if(markerFlagGreen != null)
	   		{
	   			markerFlagGreen.setMap(null);
	   		}
		 	loadMask.hide();
	 	 	datalist = [];
			infolist = [];
			distanceList = [];
			titleMkr = [];
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
            	if(grid.getSelectionModel().getSelections().length>0)
            	{
	          		for(var i=0;i<grid.getSelectionModel().getSelections().length;i++)
                	{
                		var selectedRecord = grid.getSelectionModel().getSelections()[i];
                		if(selectedRecord.data['optionIdIndex']=='1'){
		             		createPolylineTrace();
		             	} else if(selectedRecord.data['optionIdIndex']=='5')
		             	{
		             		plotHistoryToMap('StopOrIdle');
		             	}  else if(selectedRecord.data['optionIdIndex']=='2')
		             	{
		             		plotHistoryToMap('Speed');
		             	}  
	           		}
	           		if(buttonValue == 'submit')
	           		{
	           			createPolylineTrace();
           				plotHistoryToMap('StopOrIdle');
	           		}
           		} else {
           			createPolylineTrace();
           			plotHistoryToMap('StopOrIdle');
           		}
             	loadMask.hide();
            }else{
            	Ext.example.msg("No Record Found");
            }
		} 
	});
}
/****************************************Live plotting********************************************************/

	function livePlottingOfVehicleRoute(){
		var vehicleNo;
		var timeband = 0;
		
		var startdate = document.getElementById("startDateId").value;
		var starttime = document.getElementById("startTimeId").value.trim();
		var startsTime = starttime.split(":");
		var starttimehr = startsTime[0];
		var starttimemin = startsTime[1];
		
		var enddate = document.getElementById("endDateId").value;
		var endtime = document.getElementById("endTimeId").value.trim();
		var endsTime = endtime.split(":");
		var endtimehr = endsTime[0];
		var endtimemin = endsTime[1];
		
	/*	if (Ext.getCmp('vehicleId').getValue().split("[")[0] != "" || Ext.getCmp('vehicleId').getValue().split("[")[0] != undefined){
			vehicleNo = Ext.getCmp('vehicleId').getValue().split("[")[0];	
		} */
		
		if (document.getElementById('vehicleId').value.split("[")[0] != "" || document.getElementById('vehicleId').value.split("[")[0] != undefined){
			vehicleNo = document.getElementById('vehicleId').value.split("[")[0];	
		}else{
			vehicleNo = '<%=vehcleNo%>';
		}
		$.ajax({
			url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=getVehicleTrackingHistory',
			data:{
				vehicleNo:vehicleNo,
				timeband:0,
				startdate:startdate,				
				startdatetimehr:endtimehr,
				startdatetimemin:endtimemin,				
				recordForTwoMin:'recordForTwoMin'
				},
			success: function(result) {
			   	 document.getElementById("vehicledetailsenddate").innerHTML="";
			   	 document.getElementById("vehicledetailsendtime").innerHTML="";
			   	
				 Ext.getCmp('endDateId').setValue("");
				 Ext.getCmp('endTimeId').setValue("");
				 
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
	             //var startDateList = dataAndInfoList["vehiclesTrackingRoot"][3].startDate;
	             var endDateList = dataAndInfoList["vehiclesTrackingRoot"][4].endDate;
	             var sdtTime;
				 var sdate;
				 var stime;
				 var sddate;
				 var sd; 
				 var sdtime; 				 
				 
				 var edtTime;
				 var edate;
				 var etime;
				 var eddate;
				 var ed;				 
				 var edtime;				 
				 
				 if(endDateList != undefined){
					/* sdtTime = startDateList.split(" ");
					sdate = sdtTime [0].split("/");
					stime = sdtTime [1].split(":");
					sddate = sdate[0]+","+sdate[1]+","+sdate[2];
					sd = sdate[2]+"/"+sdate[1]+"/"+sdate[0]; 
					sdtime = stime[0]+":"+stime[1]; 
					*/
					edtTime = endDateList.split(" ");
					edate = edtTime [0].split("/");
					etime = edtTime [1].split(":");
					ed = edate[2]+"/"+edate[1]+"/"+edate[0];
					eddate = edate[0]+","+edate[1]+","+edate[2];
					edtime = etime[0]+":"+etime[1];
					
					document.getElementById("vehicledetailsenddate").innerHTML=ed;
			   	 	document.getElementById("vehicledetailsendtime").innerHTML=edtime;
			   	 	Ext.getCmp('endDateId').setValue(new Date(eddate));
				 	Ext.getCmp('endTimeId').setValue(edtime);
				 }
	             if(totaldatalist.length > 0){
				 	livePlottingOnMap(totaldatalist,totalinfolist);
				 }
			} 
		});
	}
	function livePlottingOnMap(totaldatalist,totalinfolist){
	       	var lon = 0.0;
	        var lat = 0.0;
	        var mkrCtr=0;
	        var k = 0;
	        if(unitOfMeasurement=="mile"){
	           unitOfMeasurement="miles";
	        } 
	        else if(unitOfMeasurement=="nmi"){
	           unitOfMeasurement="nmi";	                 
	         } 
	        else if(unitOfMeasurement=="kms"){
	           unitOfMeasurement="kms";
	        }  
	        if(datalist != null){
         	for(var i=0;i<totaldatalist.length;i++){
         		if(totaldatalist[i] != null && totaldatalist[i+1] != null)
          		{
		            lat = totaldatalist[i];
		            lon = totaldatalist[i+1];
		            if(totaldatalist[i+2] == "1"){ 	//stop
						imageurl='/ApplicationImages/VehicleImages/redbal.png';
            		}
            		else if(totaldatalist[i+2] == "2"){  //overspeed
           				imageurl='/ApplicationImages/VehicleImages/bluebal.png';
           			} 
           			else if(totaldatalist[i+2] == "3")//idle
           			{
           				imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
           			}
           			else{
           				imageurl='/ApplicationImages/VehicleImages/greenbal.png';
           			}
           			var date = convert(totalinfolist[k]);
            	 	var dateString = convertUTC(totalinfolist[k]);
             		var dateUTC= new Date(dateString); 
             		titleMkr.push(dateUTC);
             		titleMkr.push(mkrCtr);            		
	             	var loc = totalinfolist[k+3];
	             	var loctn="";
	             	if(loc != null && loc != "" && loc != undefined){
	             		loctn = loc.replace(/\'/g, "");
	             	}
	             	var speed = totalinfolist[k+4];
              		var stopHrs=getHrMinsFormat(totalinfolist[k+5]);
	          		k = k + 6;
	          		if(totaldatalist[i+2] == "1" ){
	          			var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+									  
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		else if(totaldatalist[i+2] == "3" ){
	          		 	var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		else if(totaldatalist[i+2] == "2"){
	          		 	var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		else{
	          			var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
									  '<table class="infotable">'+
									  '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
									  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
									  '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
									  '<tr><td></td><td>'+
									  '<span class="create-land-route">'+
									  '<input type="button" value="Create Landmark" class="off" style="font-family: sans-serif;font-size: 12px;" onclick="openLndmrkCreation(\'' + lat + '\',\'' + lon + '\')" /></span>'+
									  '</td></tr>'+
									  '</div>';
	          		}
	          		createMarker(lat,lon,content,imageurl);
         		}
         		var Bounds = new google.maps.LatLngBounds(new google.maps.LatLng(lat, lon),new google.maps.LatLng(lat,lon));
		        map.fitBounds(Bounds); 		       
		        i+=2;
		        mkrCtr++;
       		}
       		}
       		hideLabel();
        	document.getElementById("lablesel").value = 0
       		var listener = google.maps.event.addListener(map, "idle", function() { 
       			map.setZoom(14);
       		//	if (map.getZoom() > 16) map.setZoom(mapZoom);
					google.maps.event.removeListener(listener); 
			});
       	}
       	
 var reader = new Ext.data.JsonReader({
    idProperty: 'optionsDetailsid',
    root: 'optionsDetailsRoot',
    totalProperty: 'total',
    fields: [{
        	name: 'slnoIndex',
         	type: 'int'
   		 },{
        	name: 'optionIdIndex',
         	type: 'int'
   		 }, {
        	name: 'optionNameIndex',
         	type: 'string'
   		 },  
    
     ]
});

   optionsStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/HistoryAnalysisAction.do?param=getOptionNames',
        method: 'POST'
    }),
    storeId: 'optionsStoreId',
    reader: reader
});

var filters1 = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [
    	{
	        type: 'numeric',
	        dataIndex: 'slnoIndex'
    	},{
	        type: 'numeric',
	        dataIndex: 'optionIdIndex'
    	},{
	        type: 'string',
	        dataIndex: 'optionNameIndex'
    	}, 
    ]
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SL NO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SL NO</span>",
            filter: {
                type: 'numeric'
            }
        },selModel,
        {
            dataIndex: 'optionIdIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>Option Id</span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'optionNameIndex',
            hidden: false,
            header: "<span style=font-weight:bold;>Option Name</span>",
            filter: {
                type: 'string'
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
							
       	var selModel = new Ext.grid.CheckboxSelectionModel({
	     	singleSelect : false,
	     	checkOnly : true
 		});
 		
       	var grid = new Ext.grid.GridPanel({
	    	title:'Option List',
	        border: false,
	        bodyCssClass: 'popuppanel',
	        autoScroll:true,
	        store: optionsStore,
	        id:'grid',
	        colModel: createColModel(5),
	        selModel: selModel,
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	            groupTextTpl: getGroupConfig(),
	            emptyText: "",deferEmptyText: false
	        }),
	        plugins: [filters1],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	    
	    selModel.on('rowdeselect', function(selModel, index, record) {
			var rec = grid.store.getAt(index);
			deselectedOptions = rec.data['optionIdIndex'];
			selectedOptions = "";
		});
		
		selModel.on('rowselect', function(selModel, index, record) {
			var rec = grid.store.getAt(index);
			selectedOptions = rec.data['optionIdIndex'];
			deselectedOptions = "";
		});
	    
       	var gridPanel = new Ext.Panel({
	       standardSubmit: true,
	       collapsible: false,
	       autoScroll: true,
	       height: 180,
	       width: 250,
	       frame: true,
	       id: 'gridInfo',
	       layout: 'table',
	       layoutConfig: {
	           columns: 1
	       },
	       items: [grid]
	   });
   		
  var ButtonPanelForOptions = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 250,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    }, buttons: [{
        xtype: 'button',
        text: 'Plot',
        id: 'plotButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                		loadMask.show();
                		if(deselectedOptions=='1')
                		{
                			if(markerFlag != null)
					   		{
					   			markerFlag.setMap(null);
					   		}
					   		if(markerFlagGreen != null)
					   		{
					   			markerFlagGreen.setMap(null);
					   		}
					   		removePolylineTrace();
					   		deselectedOptions = "";
                		}else if(deselectedOptions=='2')
                		{
                			clearSpeedMarkers();
                			deselectedOptions = "";
                		}else if(deselectedOptions=='3')
                		{
                			for(var i=0;i<circles.length;i++){
						    	circles[i].setMap(null);
						    	buffermarkers[i].setMap(null);
							}
							circles.length=0;
							for(var i=0;i<polygons.length;i++){
						    	polygons[i].setMap(null);
						    	polygonmarkers[i].setMap(null);
							}
							polygons.length=0;
							deselectedOptions = "";
                		}else if(deselectedOptions=='4')
                		{
                			for(var i=0;i<borderPolylines.length;i++){
								borderPolylines[i].setMap(null);
								borderMarkers[i].setMap(null);
							}
							borderPolylines.length=0;
							for(var i=0;i<borderCircles.length;i++){
								borderCircleMarkers[i].setMap(null);
								borderCircles[i].setMap(null);
							}
							borderCircles.length=0;
							deselectedOptions = "";
                		}
                		else if(deselectedOptions=='5')
                		{
                			clearMarkers();
							if(markerFlag != null)
					   		{
					   			markerFlag.setMap(null);
					   		}
					   		if(markerFlagGreen != null)
					   		{
					   			markerFlagGreen.setMap(null);
					   		}
					   		deselectedOptions = "";
                		}
                		if(selectedOptions=='3')
                		{
                			bufferStore.load({
							    callback:function(){
							    	plotBuffers();
							    	}
							});
							polygonStore.load({
							    callback:function(){
							    	plotPolygon();	
							    	}
							});	
							selectedOptions = "";
                		}  else if(selectedOptions=='1' || selectedOptions=='2' || selectedOptions=='5')
                		{
                			submitValues();
                			selectedOptions = "";
                		} else if(selectedOptions=='4')
                		{
                			 borderStore.load({
							    callback:function(){
							    	plotBorder();
							    	}
							    	
							}); 
							selectedOptions = "";
                		}
                	myWinForOptions.hide();
                	loadMask.hide();
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    myWinForOptions.hide();
                }
            }
        }
    }]
});

       	var optionsOuterPanelWindow = new Ext.Panel({
	       width: 270,
	       height: 250,
	       standardSubmit: true,
	       frame: true,
	       items: [gridPanel,ButtonPanelForOptions]
	   });
       	
       	myWinForOptions = new Ext.Window({
	       title: "Option List",
	       closable: false,
	       resizable: false,
	       modal: true,
	       autoScroll: false,
	       height: 290,
	       width: 290,
	       id: 'myWinForOptionsId',
	       items: [optionsOuterPanelWindow]
	   });
	   
	   function reportWindow(type)
	   {
	    var vehicleNo=document.getElementById('vehicleId').value.split("[")[0].replace(/ /g, '%20');
		//var vehicleNo=Ext.getCmp('vehicleId').getValue().split("[")[0].replace(/ /g, '%20');
		var timeband = 0;
		var startdate = document.getElementById("startDateId").value;
		var starttime = document.getElementById("startTimeId").value.trim();
		var startsTime = starttime.split(":");
		var starttimehr = startsTime[0];
		var starttimemin = startsTime[1];
		var enddate = document.getElementById("endDateId").value;
		var endtime = document.getElementById("endTimeId").value.trim();
		var endsTime = endtime.split(":");
		var endtimehr = endsTime[0];
		var endtimemin = endsTime[1];
		var pattrn = new RegExp("^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
		
		if (vehicleNo == "" || vehicleNo === undefined){
			Ext.example.msg("Please Select Vehicle Number");		
			return false;		
		}		
		if(startdate==""){
			Ext.example.msg("Please Select Start Date");
			return false;
		}
		 var strthhmm = starttimehr+":"+starttimemin;
		 if(!pattrn.test(strthhmm )){
	       Ext.example.msg("Please select valid time");
			return false;
	    }	 
		if(enddate==""){
			Ext.example.msg("Please Select End Date");
			return false;
		}
		var endhhmm = endtimehr+":"+endtimemin;
		if(!pattrn.test(endhhmm)){
	       	Ext.example.msg("Please select valid time");
			return false;
	    }
		if (TimeCompare(startdate,enddate,starttimehr,endtimehr,starttimemin,endtimemin)==false){
			Ext.example.msg("Start Time should be less than End Time");
			return false;
		}
		if (DateCompare3(startdate,enddate)==false){
			Ext.example.msg("Start date should be less than End Date");
			return false;
		}
		if(checkDays(startdate,enddate)>31){
			Ext.example.msg("Please take the report for maximum 31 days");
			return false;
		}
	   	var myParam =  vehicleNo + "|" + startdate + "|" + starttimehr +"|"+starttimemin + "|" + enddate +"|" + endtimehr +"|"+endtimemin + "|" +'<%=sysName %>';
		var myParam1 =  vehicleNo + "|" + startdate + "%20" + starttimehr +":"+starttimemin +":00"+ "|" + enddate +"%20" + endtimehr +":"+endtimemin +":00"+ "|" +'<%=sysName %>'+ "|" +timeband;
	   	if(type == 'Stop')
	   	{
	   		var locationPageStop="/jsps/report_jsps/StopReportNew.jsp?myParam="+myParam;
	   		openLocationWindow(locationPageStop);
	   	} else if(type == 'Speed')
	   	{
	   		var locationPageSpeed= "/jsps/report_jsps/SpeedReportNew.jsp?myParam="+myParam;
	   		openLocationWindow(locationPageSpeed);
	   	} else if (type == 'Activity')
	   	{
	   		var locationPageActivity="/jsps/Activity_jsp/ActivityReport.jsp?myParam1="+myParam1;
	   		openLocationWindow(locationPageActivity);
	   	}
	   }
/****************************************End of live plotting*************************************************/
Ext.onReady(function(){
if(<%=systemid%> == 257 && <%=customerId%> == 4522 && <%=userId%> == 198){
//For Secure Value history analysis
	document.getElementById("stopIconId").style.display="none";
	document.getElementById("speedIconId").style.display="none";
	document.getElementById("activityIconId").style.display="none";
}
	var sliderNew = new Ext.Slider({
		renderTo: 'slider',
		id: 'sliderId',
		width: 190,
		minValue: 10,
		increment: 10,
		maxValue: 100,
		plugins: new Ext.ux.SliderTip(),
		listeners: {
			dragend: {
						fn:function(){
							 sliderValue= sliderNew.getValue();
							 if(running==true){
								 if(sliderValue==0){
									clearInterval(timerval);
									timerval = window.setInterval("animate()",1000);
								 }
								 else
								 {
									clearInterval(timerval);
									timerval = window.setInterval("animate()",(10000/sliderValue));
								 }
							  }
						}
			}
		}
	});	
	outerPanel = new Ext.Panel({
		border:false,
		width:400,
		id:'mainPanelid',
		cls:'dashboardcustomerpannelmap',	
		bodyCfg:{style: {cls:'dashboardcustomerpannelmap','background-color': 'transparent !important'}},
		items:[datepanel]
	});	
	outerPanel.render('style-switcherid'); 
	if(histfromclick == true || histfromclick == 'true'){
	document.getElementById("noteDiv").style.display = "block"
	}else{
	document.getElementById("noteDiv").style.display = "none"
	}
});
	</script>
  </body>
</html>
