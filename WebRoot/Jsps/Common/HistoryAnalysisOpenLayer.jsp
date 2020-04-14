<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,java.text.SimpleDateFormat,t4u.functions.MapViewFunctions" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Properties properties = ApplicationListener.prop;

CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

String vehiclesNo="";
String vehcleNo = "";
boolean hisTrackNew = false;
if(request.getParameter("hisTrackNew") != null && !request.getParameter("hisTrackNew").equals("")){
	vehiclesNo= request.getParameter("vehicleNo").replaceAll(" ","%20");
	vehcleNo = request.getParameter("vehicleNo");
	hisTrackNew = Boolean.parseBoolean(request.getParameter("hisTrackNew"));
}	
String language = loginInfo.getLanguage();
int systemid = loginInfo.getSystemId();
String sysName =  loginInfo.getSystemName().replaceAll(" ","%20");
int countryId = loginInfo.getCountryCode();
int offset = loginInfo.getOffsetMinutes();
String countryName = cf.getCountryName(countryId);

HistoryAnalysisFunction hTrackingFunctions = new HistoryAnalysisFunction();
ArrayList unitOfMeasurementList= hTrackingFunctions.getDistanceUnitDetail(systemid,vehiclesNo);
String unitOfMeasurement=unitOfMeasurementList.get(0).toString();

String status = "";
if(request.getParameter("status") != null && !request.getParameter("status").equals("")){
	status = request.getParameter("status");
}
String recordstatus = "";
if(request.getParameter("recordstatus") != null && !request.getParameter("recordstatus").equals("")){
	recordstatus = request.getParameter("recordstatus");
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
    String distUnits = cf.getUnitOfMeasure(systemid);
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
	<pack:script src="../../Main/OpenLayer3/build/ol.js"></pack:script>
	<pack:script src="../../Main/Js/jqueryjson.js"></pack:script>
	<pack:script src="../../Main/ol3-popup-master/src/ol3-popup.js" />
	
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/chooser.css" />
	<pack:style src="../../Main/resources/css/common.css" />	
	<pack:style src="../../Main/resources/css/dashboard.css" />
	<pack:style src="../../Main/resources/css/examples1.css" />
	<pack:style src="../../Main/resources/css/style.css" />
	<pack:style src="../../Main/OpenLayer3/css/ol.css" />
	<pack:style src="../../Main/ol3-popup-master/src/ol3-popup.css" />
	
	<style>	
	.tooltip {
  position: relative;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 4px;
  color: white;
  padding: 4px 8px;
  opacity: 0.7;
  white-space: nowrap;
}
.tooltip1 {
  position: relative;
  background: rgba(0, 0, 0, 0);
  border-radius: 0px;
  color: black;
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
		}
	</style>
  </head>
  <body onload="initialize()">   
  	<div class="container" id="content">
		 <div class = "main">		 			 	
		 	<div class="mp-vehicle-details-wrapper" id="vehicle-details">
				<form class="me-select">
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
			</div>		 	
		    <div class="mp-container" id="mp-container">					
				<div class="mp-map-wrapper" id="map-container"></div>
				<div class="mp-options-wrapper">
				<select class="openLayerButton" id="maptype" onchange="googleMap();">
  					<%if(mapTypeFromOpen.equals("CusMap")){%>  
	        		<option value="CusMap">Openstreet Map</option>
  					<option value="SatMap">Satellite Google Map</option>
  					<option value="StreetMap">Street Google Map</option>
	        		<%}%>  
	        		</select>
				<table style="width:99%">
						<tr>
							<td><div><img class="ruler" id ="startRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerStart.gif" title="Start Ruler" onclick="startRuler()"/></div></td>
							<td><div><img  class="ruler" id ="removeRulerId" src="/ApplicationImages/ApplicationButtonIcons/rulerEnd.gif" title="Remove Ruler" onclick="removeRuler()"/></div></td>
							<td><div><img class="play" id="play/pause" src="/ApplicationImages/ApplicationButtonIcons/play.png" alt="Play History Analysis" onclick='playHistoryTracking(this);' title="Play History Analysis"/></div></td>
							<td style="width:5%"><div><img class="pause" id ="stop" src="/ApplicationImages/ApplicationButtonIcons/stop.png" onclick='stopHistoryTracking();' title="Stop History Analysis" /></div></td>
							<td><div><input type="checkbox" value="unchecked" id="unchecked" onclick='showHub(this);'><span class="show-label"><%=showhubs%></span></div></td>
							<td style="width:25%">
								<div>
									<span class="show-label">
										<input type="checkbox" value="check" id="notchecked" onclick="labeloption(this);">
										<span class='labletxt'><%=showlabels%></span>
									</span>
									<span class="show-label">
										<select name="lablesel" id="lablesel" class='select-style' onchange="setlabelgap()">
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
			<div class="style-toggler">
				<img src="/ApplicationImages/ApplicationButtonIcons/expands.png" alt="" id="style-toggler-id">
			</div>
			<div class="style-switcher" id="style-switcherid"></div>				
	</div>
	</div>
	<script type="text/javascript">	
	
	var map;
	var firstload=1;
	var titleMkr=[];
	var simpleMarkers = [];
	var markers = [];
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
	var offset = <%=offset%>;
	var livePlottingInterval; 
	var vectorLayer;
	var vectorLayerGreen;
	var vectorLayerPlay;
	var vectorLayerPlayArray=[];	 
	var vectorSource;
	var vectorSourceGreen;
	var vectorSourcePlay;
	var layerLines = new ol.layer.Vector({});
	var popup = new ol.Overlay.Popup();
	var popupForBuffer = new ol.Overlay.Popup();
	var popupForPolygon = new ol.Overlay.Popup();
	var popupForBorder = new ol.Overlay.Popup();
	document.getElementById('option-normal').style.display = 'none';
	var lastount = 'false';
	var borderLayer;
	var borderLayerArray=[];
	var contentArray = {};
	var bufferLayer;
	var polygonLayer;
	var bufferLayerArray=[];
	var polygonLayerArray=[];
	var mapForBuffer;
	var measureToolTipArray = [];
	var mapForBorder;
	var tipCount = 0;
	var sourceRuler = new ol.source.Vector();
	var vectorRuler;
	var contentForVehicle  = '';
	var geometry;
	var wgs84Sphere = new ol.Sphere(6378137);
	var mapLayer =  new ol.layer.Tile();
	var mapFullScreen1 = 0;
	var lablegapForLayer="";
	var distanceUnits = '<%=distUnits%>';
	function initialize() {
	var viewForOpenLayer = new ol.View({
	       center: ol.proj.transform([<%=longCenter%>,<%=latCenter%>], 'EPSG:4326', 'EPSG:3857'),
	        zoom: 5
	    });
       map = new ol.Map({
		    target: 'map-container',
		     <%if(mapTypeFromOpen.equals("CusMap")){%>  
	        layers: [
		        new ol.layer.Tile({
		            source: new ol.source.OSM()
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
        mapZoom = 10;
        document.getElementById("lablesel").value = 0;
     	document.getElementById("lablesel").disabled=true;     
	    if(fromMapView){
	       	loadDate();
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
	
	function googleMap(){
		var pageLoad = "googleMap";
		var url= "";
		var mapType = '';
		if(document.getElementById("maptype").value == "SatMap")
		{
	     mapType = 'SatMap';
		 url="<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?pageLoad="+pageLoad+"&mapType="+mapType;
		 window.parent.$('#historyAnalysisContainer').attr('src',url);	
		} else if(document.getElementById("maptype").value == "StreetMap")
		{
		 mapType = 'StreetMap';
		 url="<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?pageLoad="+pageLoad+"&mapType="+mapType;
		 window.parent.$('#historyAnalysisContainer').attr('src',url);	
		} else if(document.getElementById("maptype").value == "CusMap")
			{
					var viewForOpenLayer = new ol.View({
				       center: ol.proj.transform([<%=longCenter%>,<%=latCenter%>], 'EPSG:4326', 'EPSG:3857'),
				        zoom: 5
				    });
				  map.removeLayer(mapLayer);
			      mapLayer = new ol.layer.Tile({
					           source: new ol.source.OSM()
					        });
				  map.addLayer(mapLayer);
				  loadAfterChangingLayer();
			} 
	}
    plotRulerMarkerNew(map,'#startRulerId','#removeRulerId',distanceUnits); 
   // google.maps.event.addDomListener(window, 'load', initialize);
/***************************minimize and maximize map****************************/   
	function mapFullScreen(){	
        document.getElementById('option-fullscreen').style.display = 'none';
        document.getElementById('option-normal').style.display = 'block';	
        $mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.addClass('mp-container-fullscreen').css({width:'originalWidth',height:'originalHeight'});
		$mapEl.css({width:$mapEl.data('originalWidth'),height:$mapEl.data( 'originalHeight')});		
		map.updateSize();	
		mapFullScreen1 = 1;
	}
	function reszieFullScreen(){
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';		
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container-fitscreen');		
		$mapEl.css({width:$mapEl.data('originalWidth'),height:$mapEl.data( 'originalHeight')});		
		map.updateSize();	
		mapFullScreen1 = 0;
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
	             	plotHistoryToMap();
	             }else{
	             	Ext.example.msg("No Record Found");
	             }
			} 
		});
	}
	
	function loadAfterChangingLayer(){
		loadMask.show();
		var dtcur = new Date();	
		var timeband = '0';
		 if(fromMapView){
		document.getElementById('vehicleDetailsId').innerHTML='<%=vehcleNo%>';
		} else {
		document.getElementById('vehicleDetailsId').innerHTML=Ext.getCmp('vehicleId').getValue();
		}
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
	             	plotHistoryToMap();
	             }else{
	             	Ext.example.msg("No Record Found");
	             }
	             if(document.getElementById("unchecked").checked)
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
					borderStore.load({
					    callback:function(){
					    	plotBorder();
					    	loadMask.hide();	
					    	}
					});
				 }
				  
				 if(document.getElementById("checked").checked)
				 {
				 	if(lablegapForLayer != ""){
				 		 document.getElementById("lablesel").value = lablegapForLayer;
				 		 setlabelgap();
				     }
				     
				 } else {
				 	document.getElementById("lablesel").value = 0;
				 }
				 if(mapFullScreen1 == 1)
				 {
				 	mapFullScreen();
				 }
			} 
		});
	}
/***************************plotting markers with infowindow****************************/     
       function plotHistoryToMap(){
            map.removeLayer(vectorLayer);
	       	var lon = 0.0;
	        var lat = 0.0;
	        var mkrCtr=0;
	        var k = 0;
	        var contentCount = 0;
	        contentArray = [];
	        markers = [];
	        if(unitOfMeasurement=="mile"){
	           unitOfMeasurement="miles";
	        } 
	        else if(unitOfMeasurement=="nmi"){
	           unitOfMeasurement="nmi";	                 
	         } 
	        else if(unitOfMeasurement=="kms"){
	           unitOfMeasurement="kms";
	        }  
	        vectorSource = new ol.source.Vector({});
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
            		if(datalist[i+2] == "1" || datalist[i+2] == "3" ){ 	//stop
						imageurl='/ApplicationImages/VehicleImages/redbal.png';
            		}
            		else if(datalist[i+2] == "2"){  //overspeed
           				imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
           			}
           			else{
           				imageurl='/ApplicationImages/VehicleImages/greenbal.png';
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
									  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
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
									  '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
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
	          		contentArray[contentCount]=content;
	          		createMarker(lat,lon,content,imageurl,contentCount);
	          		contentCount++;
         		}
         		if(contentCount>2)
         		{
         			map.getView().fit(vectorSource.getExtent(), map.getSize());
         			map.updateSize();
         		} else {
         			map.getView().setResolution(map.getView().getResolution() * 0.05);
         			map.getView().setResolution(map.getView().getResolution() / 0.05);
         		}
		        i+=2;
		        mkrCtr++;
       		}
       		}
       		hideLabel();
       		mapForVehicle = map.on("singleclick", mapForVehicle = function(evt) {
					map.forEachFeatureAtPixel(evt.pixel, function (iconFeature, vectorLayer) {
					 geometry = iconFeature.getGeometry();
						  contentForVehicle  = contentArray[iconFeature.getId()];
				     });
				     if(contentForVehicle !== undefined)
				     {
				     popup.setPosition(geometry.getCoordinates());
				     popup.setOffset([0, -40]);
				   	 popup.show(geometry.getCoordinates(), contentForVehicle);
				   	 mapForVehicle.remove();
				   	}
				     
					 });
       		vectorLayer = new ol.layer.Vector({
				  source: vectorSource
				});
       		map.addLayer(vectorLayer);
       		map.addOverlay(popup);
       		document.getElementById("lablesel").value = 0;
			if(fromMapView){ 
	         	livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},120000);   
	        }
       	}
      function createSimpleMarker(lat,lon,imageurl){
             var iconFeature = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(lon),parseFloat(lat)],'EPSG:4326','EPSG:3857'))
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
			    //iconFeature.setId(vehicleNo);
			    vectorSource.addFeature(iconFeature);
		} 
	 function createMarker(lat,lon,content,imageurl,contentCount){
	 
var iconFeature = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(lon),parseFloat(lat)],'EPSG:4326','EPSG:3857'))
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
				markers.push(iconFeature);
			    iconFeature.setStyle(iconStyle);
			    iconFeature.setId(contentCount);
			    vectorSource.addFeature(iconFeature);
			     map.getView().setCenter(ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857'));
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
		var latLong;
		var traceSource =  new ol.source.Vector();
		var lineFeature;
		var tracePath=[];
		var previousLatLong;
		var style= new ol.style.Style({
            fill: new ol.style.Fill({
              color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
              color: 'black',
              width: 2
            }),
            image: new ol.style.Icon({
		        src: '/ApplicationImages/VehicleImages/Right_Arrow.png',
		        anchor: [0.75, 0.5],
		        rotateWithView: false,
		        rotation: -10
		      })
          })
		for(var i=0;i<datalist.length;i++){
			lat = datalist[i];
		    lon = datalist[i+1];
		    latLong = ol.proj.transform([parseFloat(lon),parseFloat(lat)],'EPSG:4326','EPSG:3857');
		    flightPath.push(latLong);  
		    i+=2;	
		}	
		for(var j=0;j<flightPath.length;j++)
		{
			tracePath=[];
			if(j==0)
			{
				tracePath.push(flightPath[j]);
				tracePath.push(flightPath[j+1]);
				previousLatLong = flightPath[j+1];
				j+=1;
			} else {
				tracePath.push(previousLatLong);
				tracePath.push(flightPath[j]);
				previousLatLong = flightPath[j];
			}
			lineFeature = new ol.Feature({
		            geometry: new ol.geom.LineString(tracePath, 'XY'),
		            name: 'Line'
		        });
		    lineFeature.setStyle(style);
		    traceSource.addFeature(lineFeature);
		}
		
		layerLines = new ol.layer.Vector({
		    source: traceSource
		});
		map.addLayer(layerLines);
<!--		for(var j=0;j<flightPath.length;j++)-->
<!--		{-->
<!--		  var start[] = flightPath[j];-->
<!--		  var end[] = flightPath[j+1];-->
<!--		   var dx = end[0] - start[0];-->
<!--	    var dy = end[1] - start[1];-->
<!--	    var rotation = Math.atan2(dy, dx);-->
<!--	    // arrows-->
<!--			j+=2;	-->
<!--		}-->
<!--		vectorRuler = new ol.layer.Vector({-->
<!--  		source: traceSource,-->
<!--   		style: new ol.style.Style({-->
<!--            fill: new ol.style.Fill({-->
<!--              color: 'rgba(255, 255, 255, 0.2)'-->
<!--            }),-->
<!--            stroke: new ol.style.Stroke({-->
<!--              color: 'rgba(0, 0, 0, 0.5)',-->
<!--              lineDash: [10, 10],-->
<!--              width: 2-->
<!--            }),-->
<!--            image: new ol.style.Icon({-->
<!--		        src: 'data/arrow.png',-->
<!--		        anchor: [0.75, 0.5],-->
<!--		        rotateWithView: false,-->
<!--		      })-->
<!--          })-->
<!--});-->
<!--		map.addInteraction(new ol.interaction.Draw({-->
<!--		  source: source,-->
<!--		  type: /** @type {ol.geom.GeometryType} */ ('LineString')-->
<!--		}));-->
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
	 var openCount = 0;	
	 function getStartEndCounterForPlay(){
	 	startCtr=0;
	    endCtr=(titleMkr.length/2)-1; 
	 }
	function playHistoryTracking(cb)
	 {
	 if(lastount == 'true')
	 {
		 for(var k=0;k<vectorLayerPlayArray.length;k++)
		{
			map.removeLayer(vectorLayerPlayArray[k]);
		} 
		openCount = 0;
		vectorLayerPlayArray = [];
		lastount = 'false';
	}
	  document.getElementById("unchecked").disabled=true;
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
				
			}else {
			 	 clearInterval(timerval);
		         cb.src ="/ApplicationImages/ApplicationButtonIcons/play.png";
			     cb.alt = "Play History Analysis";
			     running=false;
			     pausedCtr=i;
			}													
		 }
		}
		
	function animate(){
	var iconFeature = new ol.Feature();
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
            if(playDataList[playCount+2] == "1" || playDataList[playCount+2] == "3") //stop
            {	
				imageurl='/ApplicationImages/VehicleImages/redbal.png';
            }  
            else if(playDataList[playCount+2] == "2")  //overspeed
            {
				imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
            }
			else  //other points
            {	
				imageurl='/ApplicationImages/VehicleImages/greenbal.png';
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
			   
			     vectorSource = new ol.source.Vector();
	          	createMarker(lat,lon,content,imageurl); 
				  vectorLayerPlay = new ol.layer.Vector({
				  source: vectorSource
				});
				vectorLayerPlayArray[openCount]=vectorLayerPlay;
				 openCount++;
				map.addLayer(vectorLayerPlay);
				imageurl='/ApplicationImages/VehicleImages/blankGreen.png';		
				if (mkrColl.length>0){					
					var greenMarkerlength=mkrColl.length-1;					
		   			var greenMarker = mkrColl[greenMarkerlength];
		   			vectorSourceGreen.clear();
					map.removeLayer(vectorLayerGreen);
	    			greenMarker=null;		    				  								
	    		} 				
	    		if(i>0 && i<(playDataList.length/3)-1){
 					iconFeature = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(lon),parseFloat(lat)],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyle = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 60],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: imageurl
				  }))
			});
			    iconFeature.setStyle(iconStyle);
			    mkrColl.push(iconFeature); 
			    vectorSourceGreen = new ol.source.Vector();
			    vectorSourceGreen.addFeature(iconFeature);
				  vectorLayerGreen = new ol.layer.Vector({
				  source: vectorSourceGreen
				});
				map.addLayer(vectorLayerGreen);
			    //iconFeature.setId(vehicleNo);
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
		 	 document.getElementById("unchecked").disabled=false;
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
	          plotHistoryToMap(); 
	          lastount = 'true';
	         if(fromMapView){ 
	         	livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},120000);   
	         }  
        }       					
 	}
/********************************Stop Tracking**********************************/	
 	function stopHistoryTracking(){
 		document.getElementById('unchecked').disabled=false; 
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
        plotHistoryToMap();
        if(fromMapView){ 
         	livePlottingInterval = setInterval(function(){livePlottingOfVehicleRoute();},120000);   
         }                
       }
/******************************remove markers and polylines******************************/ 
	  function clearSimpleMarkers() {
  		for(var k=0;k<vectorLayerPlayArray.length;k++)
		{
			map.removeLayer(vectorLayerPlayArray[k]);
		} 
	 }
	 function clearMarkers() {
  			map.removeLayer(vectorLayer);
	 }
	 function clearMovingMarkers() {
		for (var i = 0; i < mkrColl.length; i++) {
			vectorSourceGreen.clear();
			map.removeLayer(vectorLayerGreen);
		} 
		 	mkrColl.length=0;	
	 }	 
	 function removePolylineTrace(){	 	
	     map.removeLayer(layerLines);  	 		
	 }
	 function removeBorder(){
	}
	function removerichmarkers(){
<!--	 	for(var i=0; i<labelmarkers.length; i++){-->
<!--		  var marker = labelmarkers[i];-->
<!--		  marker.setMap(null);-->
<!--		}-->
<!--		  labelmarkers.length=0;-->
	 }
	 function clearMap(){
	 	clearSimpleMarkers();
	 	removePolylineTrace();
	 	removeBorder();
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
			for(var i=0;i<bufferStore.getCount();i++)
	         {	
	    		map.removeLayer(bufferLayerArray[i]);
	    	 }
    		for(var i=0;i<polygonStore.getCount();i++)
	         {	
	    		map.removeLayer(polygonLayerArray[i]);
	    	 }
    	  for(var i=0;i<borderStore.getCount();i++)
	         {	
	    		map.removeLayer(borderLayerArray[i]);
	    	 }
	    	 map.removeOverlay(popupForBorder);
	    	 map.removeOverlay(popupForPolygon);
	    	 map.removeOverlay(popupForBuffer);
		}			
	} 
/*****************************************Ploting Buffers*****************************************/	
function plotBuffers(){
	var vectorSourceBuffer = new ol.source.Vector({});
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
		        vectorSourceBuffer = new ol.source.Vector({
		            projection: 'EPSG:4326'
		        });
		        vectorSourceBuffer.addFeature(circleFeature);
		        
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
	  		var iconFeatureBuffer = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(rec.data['longitude']),parseFloat(rec.data['latitude'])],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStyleBuffer = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: urlForZero
				  }))
				  });
				   iconFeatureBuffer.setStyle(iconStyleBuffer);
				   iconFeatureBuffer.setId(rec.data['hubId']);
				    vectorSourceBuffer.addFeature(iconFeatureBuffer);
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

				bufferLayer = new ol.layer.Vector({
						  source: vectorSourceBuffer
						});
				bufferLayerArray[i]=bufferLayer;
			    map.addLayer(bufferLayer);		
			    map.addOverlay(popupForBuffer);
	    }
	    
	}
/*****************************************Ploting Polygon*****************************************/	
function plotPolygon(){
var hubid=0;
	    var polygonCoords=[];
	    var j=0;
   	    var firstLat,firstLong;
   	    var vectorSourcePolygon = new ol.source.Vector();
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
				vectorSourcePolygon = new ol.source.Vector({
				 projection: 'EPSG:4326'
				 });
			    vectorSourcePolygon.addFeature(feature);
	  			var iconFeaturePolygon = new ol.Feature({
				    geometry: new ol.geom.Point(ol.proj.transform([parseFloat(firstLong),parseFloat(firstLat)],'EPSG:4326','EPSG:3857'))
				    });
				    var iconStylepolygon = new ol.style.Style({
				    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
				    anchor: [0.5, 46],
				    anchorXUnits: 'fraction',
				    anchorYUnits: 'pixels',
				    opacity: 0.75,
				    src: '/ApplicationImages/VehicleImages/information.png'
				  }))});
				   iconFeaturePolygon.setStyle(iconStylepolygon);
				   iconFeaturePolygon.setId(rec.data['hubid']);
				   vectorSourcePolygon.addFeature(iconFeaturePolygon);
					   mapForPolygon = map.on("singleclick", mapForPolygon = function(evt){
					   var polygonStoreIndex = -1;
					   map.forEachFeatureAtPixel(evt.pixel, function (iconFeaturePolygon, polygonLayer) {
				       polygonStoreIndex = polygonStore.find('hubid', iconFeaturePolygon.getId());
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
		    	polygonCoords = [];
			}
			polygonLayer = new ol.layer.Vector({
				  source: vectorSourcePolygon
				});
				polygonLayerArray[i] = polygonLayer;
	   		 map.addLayer(polygonLayer);
	   		 map.addOverlay(popupForPolygon);
	    }
	    
}
/*****************************************Ploting Border*****************************************/	
	function plotBorder(){
			var hubid=0;
	   	    var borderCoords=[];
	   	    var circleBorderCount=0;
	   	    var j=0;
	   	    var firstLat,firstLong;
	   	    var vectorSourceBorder = new ol.source.Vector();
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
		        // Source and vector layer
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
				   
		        vectorSourceBorder = new ol.source.Vector({
		            projection: 'EPSG:4326'
		        });
		        vectorSourceBorder.addFeature(circleFeature);
		        vectorSourceBorder.addFeature(iconFeatureBorder);
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
				// Create vector source and the feature to it.
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
				vectorSourceBorder = new ol.source.Vector({
				 projection: 'EPSG:4326'
				 });
			    vectorSourceBorder.addFeature(feature);
			    vectorSourceBorder.addFeature(iconFeatureBorder);
		    	borderCoords = [];
			}  			
	    	}
	    	borderLayer = new ol.layer.Vector({
				  source: vectorSourceBorder
				});
			borderLayerArray[i]=borderLayer;
			map.addLayer(borderLayer);
			map.addOverlay(popupForBorder);
	    }
	}
/*****************************************Show Labels*****************************************/	
	function getDistance(){
	  distArray.push(0);
	  var totaldistance=0;
	  for(var i=1;i<markers.length;i++){
	  var point1= markers[i].getGeometry().getCoordinates();
	  var point2= markers[i-1].getGeometry().getCoordinates();
	  length += wgs84Sphere.haversineDistance(point1,point2);
        if (length > 100) {
          distance = (Math.round(length / 1000 * 100) / 100);
        } else {
          distance = (Math.round(length * 100) / 100);
        }
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
	  map.removeOverlay(marker);
	  }
	}	
	function setLabel() {
	  distArray = distanceList;
	  for(var i=0; i<markers.length; i++){
	    var position = markers[i].getGeometry().getCoordinates();
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
	     e.id="checked";
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
	   	lablegapForLayer = document.getElementById("lablesel").value;
		if(lablegap=="Position"){
		   hideLabel();
		   for(var i=0,count=1;i<markers.length;i++){
		  	var position = markers[i].getGeometry().getCoordinates();
			var content = '<div class="my-other-marker">'+ count +'</div>';
			createRichMarker(position,content);	
			count++;			    
		  }
		}else{
		  getDistance();
		 for(var j=0;j<labelmarkers.length;j++){	
		  var marker = labelmarkers[j];
		  map.removeOverlay(marker);
		 }
		 if(!running){  
		   for(var j=0;j<markers.length;j++){ 
			 if(j!==0 && j!=markers.length-1 && j%lablegap == 0){ 
			   //labelmarkers[j].setVisible(true);
			    map.addOverlay(labelmarkers[j]);
			 }
		   }
		 }else{
	           for(var j=0;j<=i;j++){
	             if(j!==0 && j!=labelmarkers.length-1 && j%lablegap == 0){
	               map.addOverlay(labelmarkers[j]);
	             }
	           }
	         }
	       }
	    }
	   else
	   {
	    for(var j=0;j<labelmarkers.length;j++){
		  var marker = labelmarkers[j];
		  map.removeOverlay(marker);
		 }	
	   }	       
	}
	function createRichMarker(position,content){
	 measureTooltipElement = document.createElement('div');
                 measureTooltipElement.className = 'tooltip1';
                  measureTooltip = new ol.Overlay({
		          element: measureTooltipElement,
		          offset: [0, 0],
		          positioning: 'bottom-center'
		        });
		         map.addOverlay(measureTooltip);
		        measureTooltipElement.innerHTML = content;
                measureTooltip.setPosition(position);
	    labelmarkers.push(measureTooltip);	
	}
/*****************************************Create Landmark*****************************************/	
function openLndmrkCreation(lat,lon){
	var vehicleNo = '<%=vehiclesNo%>';
	vehicleNo = vehicleNo.replace(/ /g, "%20");
	var locationPage="/jsps/CustomLocationCreation.jsp?vehicle="+vehicleNo+"&lat="+lat+"&lon="+lon+"&hs=yes";
	openLocationWindow(locationPage);	 		 
}
/*****************************************Panel Details*****************************************/	
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
				Ext.getCmp('vehicleId').setValue('<%=vehcleNo%>');
			},
			change: function() {
				clearInterval(livePlottingInterval);
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
				text: '<%=assetNo%>' + ' :'
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
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        emptyText:'Select End Date',
				blankText:'Select End Date',  		        
  		        id: 'endDateId',
  		        format: getDateFormats(), 
  		        listeners: {
				}
  		    },{
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
  		        xtype: 'button',
  		        text: '<%=submit%>',
  		        id: 'addbuttonid',
  		        width:80,
  		        handler: function(){
  		        		clearInterval(livePlottingInterval);
  		        		//livePlottingInterval = 0;
           		   		submitValues();
           		    }   
  		    }  		    
    ]
});
function submitValues(){
	fromMapView = false;
	document.getElementById("vehicledetailsstartdate").innerHTML="";
   	document.getElementById("vehicledetailsstarttime").innerHTML="";
   	document.getElementById("vehicledetailsenddate").innerHTML="";
   	document.getElementById("vehicledetailsendtime").innerHTML="";	
   	
	var vehicleNo=Ext.getCmp('vehicleId').getValue();
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
	if(checkDays(startdate,enddate)>20){
		Ext.example.msg("History Tracking is displayed only when the difference between Start Date and End Date is in between 20 days");
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
			clearMarkers();
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
             	plotHistoryToMap();
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
		
		if (Ext.getCmp('vehicleId').getValue() != "" || Ext.getCmp('vehicleId').getValue() != undefined){
			vehicleNo = Ext.getCmp('vehicleId').getValue();	
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
		            if(totaldatalist[i+2] == "1" || totaldatalist[i+2] == "3" ){ 	//stop
						imageurl='/ApplicationImages/VehicleImages/redbal.png';
            		}
            		else if(totaldatalist[i+2] == "2"){  //overspeed
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
		        i+=2;
		        mkrCtr++;
       		}
       		}
       		hideLabel();
        	document.getElementById("lablesel").value = 0
       	}
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
      
/****************************************End of live plotting*************************************************/
Ext.onReady(function(){
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
});
	</script>
  </body>
</html>
