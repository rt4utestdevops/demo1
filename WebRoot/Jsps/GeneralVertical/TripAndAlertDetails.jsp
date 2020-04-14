<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	CommonFunctions cf = new CommonFunctions();
	GeneralVerticalFunctions gf=new GeneralVerticalFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int countryId = loginInfo.getCountryCode();
	int systemId = loginInfo.getSystemId();
	String countryName = cf.getCountryName(countryId);

	String routeId="0";
	if(request.getParameter("routeId")!=null){
		routeId=request.getParameter("routeId");
	}
	String tripNo = request.getParameter("tripNo");
	String vehicleNo = request.getParameter("vehicleNo");
	String plannedDate = request.getParameter("startDate");

	String startDate = "";
	String actualDate = "";
	if(request.getParameter("actual") != null && !request.getParameter("actual").equals("")) {
		actualDate = request.getParameter("actual");
	}
	if(actualDate.equals("")) {
		startDate = plannedDate;
	} else {
		startDate = actualDate;
	}
	String endDate = request.getParameter("endDate");
	String pageId = request.getParameter("pageId");
	String status = request.getParameter("status");
	String sts = "";
	if(status != null && !status.equals("")){
		String statusArr[] =  status.split("-");
		sts = statusArr[0];
	}
	int associated=gf.getAssociationDetails(vehicleNo,tripNo);
	HistoryAnalysisFunction hTrackingFunctions = new HistoryAnalysisFunction();
	ArrayList unitOfMeasurementList= hTrackingFunctions.getUnitDetails(systemId);
	String unitOfMeasurement=unitOfMeasurementList.get(0).toString();

	boolean check  = gf.checkIfRoutePresent(Integer.parseInt(routeId));
	Properties properties = ApplicationListener.prop;
	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
	String mapName = bean.getMapName();
	String appKey = bean.getAPIKey();
	String appCode = bean.getAppCode();
	Integer isLtsp = loginInfo.getIsLtsp();
	
	int userId=0;  
	userId=loginInfo.getUserId();
	String userAuthority = cf.getUserAuthority(systemId,userId);   
		 
%>
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="description" content="">
      <meta name="author" content="">
      <title>Trip And Alert Details</title>
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="../../Main/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
      <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">
      <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
	  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
      <jsp:include page="../Common/InitializeLeaflet.jsp" />
      <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
      <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.bootstrap.min.css" rel="stylesheet">
      <link href="../../Main/vendor/customselect2.css" rel="stylesheet"/>
      <!-- JS -->
      <script src="../../Main/vendor/jquery/jquery.min.js"></script>
      <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
      <script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>
      <!-- Metis Menu Plugin JavaScript -->
      <script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>
      <!-- Custom Theme JavaScript -->
      <script src="../../Main/dist/js/sb-admin-2.js"></script>
      <script src="../../Main/Js/markerclusterer.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
      
      <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
      <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
      <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
      <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/PlayHistory.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>
      
	  <link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
      <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	  <script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	  <script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css" />
      <script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>
	  <script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	  <script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	  <script src="../../Main/leaflet/leaflet.polylineDecorator.js"></script>
	  
	   <link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
   <script src="../../Main/leaflet/leaflet.measure.js"></script>
<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
 integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
 crossorigin=""></script>
 
 
      <style>
      
         .row {
         margin-right: -3px !important;
         margin-left: -10px !important;
         }
         .panel-heading{
         padding-bottom: inherit !important;
         padding-top: inherit !important;
         }
         .panel {
         margin-bottom: 0px;
         }
         div.dataTables_wrapper div.dataTables_filter{
         margin-top: 2px !important;
         }
         .modal-header {
         padding: 3px;
         }
         #tripDeatailsTable_length{
         display: none !important;
         }
         #tripDeatailsTable_paginate{
         float :left;
         margin-left:0px;
         }
         #tripEventsTable_length{
         display: none !important;
         }
         div.dataTables_wrapper div.dataTables_filter input{
         height: 22px !important;
         }
         .container-fluid {
         padding-right: 0px;
         padding-left: 15px;
         margin-right: -16px;
         margin-left: -27px;
         margin-top: 15px;
         }
         p{
         font-size: 18px;
         }
         .container .checkmark:after {
         left: 9px;
         width: 5px;
         height: 10px;
         border: solid white;
         border-width: 0 3px 3px 0;
         -webkit-transform: rotate(45deg);
         -ms-transform: rotate(45deg);
         transform: rotate(45deg);
         }
         ul {position: absolute !important;}
         .container {
         padding-left: 35px;
         cursor: pointer;
         font-size: 15px;
         -webkit-user-select: none;
         -moz-user-select: none;
         -ms-user-select: none;
         user-select: none;
         }
         .container input {
         position: absolute;
         opacity: 0;
         cursor: pointer;
         }
         .checkmark {
         position: absolute;
         top: 0;
         left: 0;
         height: 25px;
         width: 25px;
         background-color: #eee;
         border: 1px solid black;
         border-radius: 4px;
         margin-top: 5px;
         }
         .container:hover input ~ .checkmark {
         background-color: #ccc;
         }
         .container input:checked ~ .checkmark {
         background-color: #2196F3;
         }
         .checkmark:after {
         content: "";
         position: absolute;
         display: none;
         }
         .container input:checked ~ .checkmark:after {
         display: block;
         }
         .checkbox-inline{
         width: 10%;
         }
         .label {
         display: inline;
         padding: .2em .6em .3em;
         font-size: 99%;
         font-weight: 700;
         line-height: 3;
         color: #fff;
         text-align: center;
         white-space: nowrap;
         vertical-align: baseline;
         border-radius: .25em;
         }
         <!-- newly added for Map Search Option -->
         .searchControls {
         display: inline-block;
         padding: 5px 11px;
         }
         .searchControls label {
         font-family: Roboto;
         font-size: 13px;
         font-weight: 300;
         }
         .select2-container{
         width: 261px !important;
         }
         .leaflet-routing-container{
         display:none;
         }
         }
         .btn-default {margin-right:8px;float:right;}
         .blueGrey {background: #37474F !important;}
         .blueGreyLight {background: #ECEFF1;}
         .headerText{width:100%;height:24px;padding-top:4px;text-align:center;color:white;}
         .panel-heading{
         padding-bottom: inherit !important;
         padding-top: inherit !important;
         }
         .panel {
         margin-bottom: 0px;
         }
         div.dataTables_wrapper div.dataTables_filter{
         margin-top: 2px !important;
         }
         .modal-header {
         padding: 3px;
         }
         #tripDeatailsTable_length{
         display: none !important;
         }
         #tripEventsTable_length{
         display: none !important;
         }
         div.dataTables_wrapper div.dataTables_filter input{
         height: 32px !important;
         }
         #tripDeatailsTable_filter
         {
         margin-right:4px;margin-top:-32px !important;
         }
         .container-fluid {
         padding-right: 0px;
         padding-left: 15px;
         margin-right: -16px;
         }
         p{
         font-size: 18px;
         }
         .container .checkmark:after {
         left: 9px;
         width: 5px;
         height: 10px;
         border: solid white;
         border-width: 0 3px 3px 0;
         -webkit-transform: rotate(45deg);
         -ms-transform: rotate(45deg);
         transform: rotate(45deg);
         }
         ul {position: absolute !important;}
         .container {
         padding-left: 32px;
         cursor: pointer;
         font-size: 12px;
         -webkit-user-select: none;
         -moz-user-select: none;
         -ms-user-select: none;
         user-select: none;
         }
         .container input {
         position: absolute;
         opacity: 0;
         cursor: pointer;
         }
         .checkmark {
         position: absolute;
         top: 0;
         left: 0;
         height: 16px;
         width: 23px;
         background-color: #eee;
         border: 1px solid black;
         border-radius: 4px;
         margin-top: 0px;
         }
         .container:hover input ~ .checkmark {
         background-color: #ccc;
         }
         .container input:checked ~ .checkmark {
         background-color: #7CC7DF;
         }
         .checkmark:after {
         content: "";
         position: absolute;
         display: none;
         }
         .container input:checked ~ .checkmark:after {
         display: block;
         }
         .checkbox-inline{
         width: 100%;
         margin-bottom:2px;
         margin-left:24px;
         }
         .label {
         display: inline;
         padding: .2em .6em .3em;
         font-size: 99%;
         font-weight: 700;
         line-height: 3;
         color: #fff;
         text-align: center;
         white-space: nowrap;
         vertical-align: baseline;
         border-radius: .25em;
         }
         <!-- newly added for Map Search Option -->
         .searchControls {
         display: inline-block;
         padding: 5px 11px;
         }
         .searchControls label {
         font-family: Roboto;
         font-size: 13px;
         font-weight: 300;
         }
         .select2-container{
         /*width: 261px !important;*/
         margin-left: 24px;
         }
         }
         .btn-group {margin-right:16px;}
         .select2{
         margin-bottom:8px !important;
         }
         .dataTables_scrollBody
         {
         border:1px solid #37474F;
         }
         body{
         overflow-x: hidden;
         background:white;
         }
         .select2-container {
         width: 180px !important;
         }
         #backButtonId1{
         margin-right: 16px;
         border-radius: 4px;
         background-color: #337ab7;
         border-color: #2e6da4;
         color: white;
         }
         .btn-primary{
         margin-right: 16px;
         border-radius: 4px;
         }
         #tripDeatailsTable thead {
         background: #37474F !important;
         color: white !important;
         }
         .select2-dropdown{
         margin-left:-24px !important;
         }
         .select2-container--default .select2-results > .select2-results__options {
		 	width: 180px;
		    font-size: 11px;
		}
		
		.card {
			box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.2), 0 2px 10px 0 rgba(0, 0, 0, 0.19);
			padding: 10px;
			margin-bottom: 0px;
			border-radius: 2px !important;
			width: 100%;
			margin-left: 8px;
			margin-top: 8px;			
			background-color: #dfdfdf;
			padding: 8px 0px 24px 0px;		
		}
		#placeholderForTemperatureRange table tr:first-child td {
			font-size: 15px;			
			padding-bottom: 8px;
			padding-left:24px;
		}
		#placeholderForTemperatureRange table{
			width:100%
		}
		.cardTemp {
			box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.2), 0 2px 10px 0 rgba(0, 0, 0, 0.19);
			padding: 10px;
			margin-bottom: 8px;
			margin-right:19px;
			border-radius: 2px !important;
			margin-left: 8px;
			margin-top: 0px;			
			background-color: #fffff;
			padding: 8px 0px 24px 0px;	
height:100px !important;			
		}
      </style>
   </head>
   <body>
      <div id="wrapper" style=" width: 99%;">
         <div id="page-wrapper" style="background-color: white;">
            <div class="row" style="padding:0px;margin-left:6px !important;margin-top:8px;margin-bottom:4px;border:1px solid #37474F">
               <div class="col-sm-10" style="padding:0px;border-right:1px solid #80A5B7;" id = "mapDiv">
                  <div id="map" style="width:initial;height: 350px;margin-left: 0px "></div>
               </div>
               <div class="col-sm-2" style="padding:0px;line-height: 20px;" id = "options">
                  <div class="headerText blueGrey">OPTIONS</div>
                  <label class="container checkbox-inline" style="margin-top:8px;">Show Hubs<input type="checkbox" onclick='showHub(this);' value=""><span class="checkmark"></span></label>
                  <div id="SearchDiv" style="display: none;">
                     <label class="container checkbox-inline" style="font-weight:bold;margin-left:-8px;margin-top:4px;">Search Hub: &nbsp;&nbsp;</label>
                     <select style="width:100px !important;margin-left:24px;" class="form-control" id="searchHubFilter">
                     </select>
                  </div>
                  <br/><label class="container checkbox-inline">Show Route<input id="showRoute" type="checkbox" value=""><span class="checkmark"></span>&nbsp;&nbsp;<span id="routeLoad"><i class="fas fa-spinner fa-spin" style="color:#939393;"></i></span></label>
                  <br/><label class="container checkbox-inline">Checkpoint<input id="checkPoint" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Panic<input id="panic" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Device Tampering<input id="tampering" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Harsh Braking<input id="HB" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Overspeed<input id="overSpeed" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Restrictive Driving<input id="restritive" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Engine Malfunction<input id="engine" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Others<input id="others" type="checkbox" value=""><span class="checkmark"></span></label>
                  <br/><label class="container checkbox-inline">Track Points<input id="playMarker" type="checkbox" value=""><span class="checkmark"></span></label>
               </div>
            </div>
			
            <%if(associated>0){%>
            <div id='placeholderForTemperatureRange' class="card"></div>
            </br>
            <div id='placeholderForTemperature'></div>
            <div>
               
               <div id = "reeferstatusId" class="col-lg-2 col-md-2 cardTemp" style="height: 161px;">
                  <div  style="">
                     <div class="onTripCount"
                        style="text-align: center; margin-bottom: 40px;">
                        <p >
                           Reefer Status
                        </p>
                        <h2 style="font-size: 18px;margin:0px !important" id = "Rid">0</h2>
                        <h5 style="font-size: 15px;" id = "gmt4Id"></h5>
                     </div>
                  </div>
               </div>
            </div>
            <%}%>
            <div class="col-lg-12">
               <table id="tripDeatailsTable"  class="table table-striped table-bordered" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                        <th>Sl No</th>
                        <th>Vehicle No</th>
                        <th>Location</th>
                        <th>Planned Time</th>
                        <th>Occured Time</th>
                        <th>Status</th>
                        <th>Alert Name</th>
                     </tr>
                  </thead>
               </table>
            </div>
         </div>
      </div>
      <div id="add" class="modal fade" style="width: 90%;margin-left: 63px;margin-top: 76px;">
         <div class="modal-content">
            <div class="modal-header" >
               <div>
                  <button type="button" class="close" style="align:right;"data-dismiss="modal">&times;</button>
               </div>
               <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
               </div>
            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-lg-12">
                     <div id="chart_div"></div>
                  </div>
               </div>
            </div>
            <div class="modal-footer"  style="text-align: right; height:75px;" >
               <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px;">Close</button>
            </div>
         </div>
      </div>
	<script>
	history.pushState({ foo: 'fake' }, 'Fake Url', 'TripAndAlertDetails.jsp');
	var countryName = '<%=countryName%>';
var map;
var mcOptions = {
    gridSize: 20,
    maxZoom: 100
};
var markerClusterArray = [];
var animate = "true";
var bounds = new L.LatLngBounds();
var infowindow;
var infowindowOne;
var mainPowerCount = 0;
var panicCount = 0;
var hbCount = 0;
var haCount = 0;
var restrictiveCount = 0;
var engineErrorCount = 0;
var mapNew;
var tripNo;
var vehicleNo;
var startDate;
var lineInfo = [];
var infoWindows = [];
var content;
var pageId = '<%=pageId%>';
var plyArray = [];
var polygon;
var circle;
var buffermarker;
var buffermarkers = [];
var circles = [];
var polygonmarkers = [];
var polygons = [];
var markerArr = [];
var routeId = '<%=routeId%>';
var flag = true;
var pdfzoom = 9;
var endDate = "";
var directionsDisplay;
var overSpeedMarkerArr = [];
var tamperMarkerArr = [];
var panicMarkerArr = [];
var HBMarkerArr = [];
var restrictiveMarkerArr = [];
var ErrorMarkerArr = [];
var othersMarkerArr = [];
var checkMarkerArr = [];
var mainArr = [];
var LegList = "";
var datalist = [];
var infolist = [];
var hubListArray = [];
var sliderValue;
var unitOfMeasurement = '<%=unitOfMeasurement%>';
var refreshFlag = true;
var circleInfoWindow;
var markerInfoWindow;
var polyInfoWindow;
var circlemarker;
var playMarkerArr = [];
var routingControl;
var poly;
var columnDefs = [{'width': "40%", 'targets': [2]}];


$('#checkPoint').prop('checked', true).trigger("change");
$('#showRoute').change(function () {
    if (this.checked) {
        if (<%=check%> == true) {
            getRoutePath1(routeId);
        } else {
            getRoutePath(routeId);
        }
    } else {
    for (var i = 0; i < routePolylines.length; i++) {
            map.removeLayer(routePolylines[i]);
        }
    }
});
$('#checkPoint').change(function () {
    if (this.checked) {
        plotEventMarkers('0');
    } else {
        for (var i = 0; i < checkMarkerArr.length; i++) {
            map.removeLayer(checkMarkerArr[i]);
        }
    }
});
$('#panic').change(function () {
    if (this.checked) {
        plotEventMarkers('3');
    } else {
        for (var i = 0; i < panicMarkerArr.length; i++) {
            map.removeLayer(panicMarkerArr[i]);
        }
    }
});
$('#tampering').change(function () {
    if (this.checked) {
        plotEventMarkers('7');
    } else {
        for (var i = 0; i < tamperMarkerArr.length; i++) {
            map.removeLayer(tamperMarkerArr[i]);
        }
    }
});
$('#HB').change(function () {
    if (this.checked) {
        plotEventMarkers('58');
    } else {
        for (var i = 0; i < HBMarkerArr.length; i++) {
            map.removeLayer(HBMarkerArr[i]);
        }
    }
});
$('#restritive').change(function () {
    if (this.checked) {
        plotEventMarkers('45');
    } else {
        for (var i = 0; i < restrictiveMarkerArr.length; i++) {
            map.removeLayer(restrictiveMarkerArr[i]);
        }
    }
});
$('#overSpeed').change(function () {
    if (this.checked) {
        plotEventMarkers('2');
    } else {
        for (var i = 0; i < overSpeedMarkerArr.length; i++) {
            map.removeLayer(overSpeedMarkerArr[i]);
        }
    }
});
$('#engine').change(function () {
    if (this.checked) {
        plotEventMarkers('174');
    } else {
        for (var i = 0; i < ErrorMarkerArr.length; i++) {
            map.removeLayer(ErrorMarkerArr[i]);
        }
    }
});
$('#others').change(function () {
    if (this.checked) {
        plotEventMarkers('-1');
    } else {
        for (var i = 0; i < othersMarkerArr.length; i++) {
            map.removeLayer(othersMarkerArr[i]);
        }
    }
});
$('#playMarker').change(function () {
    if (this.checked) {
        plotMarkers();
    } else {
        for (var i = 0; i < playMarkerArr.length; i++) {
            map.removeLayer(playMarkerArr[i]);
        }
    }
});

function getTempDetails(temp) {
    google.charts.load('current', {
        'packages': ['corechart']
    });
    google.charts.setOnLoadCallback(drawChart(temp));
}

function drawChart(temp) {
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTempDetails',
        data: {
            vehicleNo: '<%=vehicleNo%>',
            startdate: '<%=startDate%>',
            category: temp,
            enddate: endDate
        },
        success: function (response) {
            tempList = JSON.parse(response);
            if (tempList["tempRoot"].length > 0) {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Time');
                data.addColumn('number', temp);
                for (var i = 0; i < tempList["tempRoot"].length; i++) {
                    var arr = [];
                    arr.push(tempList["tempRoot"][i].DATE);
                    arr.push(Number(tempList["tempRoot"][i].TEMP));
                    data.addRows([arr]);
                }
                var options = {
                    title: 'Temperature Graph',
                    height: 350,
                    width: 1150,
                    vAxis: {
                        format: 'decimal'
                    },
                    hAxis: {
                        direction: 1,
                        slantedText: true,
                        slantedTextAngle: 315
                    }
                };
                var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                chart.draw(data, options);

                $(".modal-header #tripEventsTitle").text("Temperature Graph for " + '<%=vehicleNo%>' + " From " + '<%=startDate%>' + " To " + endDate);
                $('#add').modal('show');
            } else {
                sweetAlert("No records Found");
            }
        }
    });

}
loadData();

function loadData() {
	if ('<%=userAuthority%>' === "Customer Login"){
		columnDefs = [];
		$('#options').hide();
		$('#mapDiv').removeClass('col-sm-10');
		$('#mapDiv').addClass('col-sm-12');
		 
		columnDefs = [{ 'visible': false, 'targets': [6]},
			{'width': "50%", 'targets': [2]}] ;
		
	}else{
		
		columnDefs = [{'width': "40%", 'targets': [2]}];
		 
	}
	
    initialize("map",new L.LatLng('21.146633', '79.088860'),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
	$('#routeLoad').hide();	
    function loadMaps() {
        for (var i = 0; i < checkMarkerArr.length; i++) {
            map.removeLayer(checkMarkerArr[i]);
        }
        if ('<%=sts%>' == 'OPEN') {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var hh = today.getHours();
            var MM = today.getMinutes();
            var ss = today.getSeconds();

            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd;
            }
            if (mm < 10) {
                mm = '0' + mm;
            }
            if (hh < 10) {
                hh = "0" + hh
            }
            if (MM < 10) {
                MM = "0" + MM;
            }
            if (ss < 10) {
                ss = "0" + ss;
            }
            endDate = dd + '/' + mm + '/' + yyyy + ' ' + hh + ':' + MM + ':' + ss;
        } else {
            endDate = '<%=endDate%>';
        }

        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getHistoryAnalysisForTripDashBoard',
            data: {
                vehicleNo: '<%=vehicleNo%>',
                startdate: '<%=startDate%>',
                timeband: 0,
                enddate: endDate
            },
            success: function (result) {
                datalist = [];
                infolist = [];
                dataAndInfoList = JSON.parse(result);

                var totaldatalist = dataAndInfoList["vehiclesTrackingRoot"][0].datalist;
                for (var i = 0; i < totaldatalist.length; i++) {
                    datalist.push(totaldatalist[i]);
                }
                var totalinfolist = dataAndInfoList["vehiclesTrackingRoot"][1].infolist;
                for (var i = 0; i < totalinfolist.length; i++) {
                    infolist.push(totalinfolist[i]);
                }
                if (datalist.length > 0) {
                    clearMap();
                    plotHistoryToMap();
                }
            }
        });
        $.ajax({
            url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTempCount",
            data: {
                vehicleNo: '<%=vehicleNo%>',
                startdate: '<%=startDate%>',
                enddate: endDate,
                tripId: '<%=tripNo%>'
            },
            "dataSrc": "tempCounts",
            success: function (result) {
                results = JSON.parse(result);
                var tempArray = results["tempCounts"][0].temperatureData;
                var tempRange = results["tempCounts"][0].temperatureRange;
                var txt1 = "";
                for (var i = 0; i < tempArray.length; i++) {
                    var sensorname = tempArray[i].name;
                    txt1 = txt1 + "<div id='reeferId'  class='col-lg-3 col-md-3 cardTemp'>" +
                        "<div  style=''>" +
                        "<div class='onTripCount'style='text-align: center; margin-bottom: 40px;' >" +
                        "<p >" + tempArray[i].name + "</p>" +
                        "<h4 style=font-size: 22px;>" + tempArray[i].value + "</h4>" +
                        "<h5 style='font-size: 15px;'>" + tempArray[i].time + "</h5>" +
                        "</div>" +
                        "</div>" +
                        "</div>"
                }
                $("#placeholderForTemperature").empty();
                document.getElementById("placeholderForTemperature").innerHTML = txt1;
                $("#placeholderForTemperatureRange").empty();
                document.getElementById("placeholderForTemperatureRange").innerHTML = tempRange;
                $("#Rid").text(results["tempCounts"][0].REFFER);
                results["tempCounts"][0].REFFER == "ON" ? $("#Rid").css('color', 'green') : $("#Rid").css('color', 'red');
                $("#humidityId").text(results["tempCounts"][0].humidity);
                $("#gmt4Id").text(results["tempCounts"][0].time4);
                $("#gmt5Id").text(results["tempCounts"][0].time5);

            }
        });
        plotEventMarkers('0');
    }
    loadMaps();
    var summaryTable = $('#tripDeatailsTable').DataTable({
        "ajax": {
            "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSummaryDetails",
            "dataSrc": "tripSummarysRoot",
            "data": {
                tripNo: '<%=tripNo%>'
            }
        },
        "bDestroy": true,
        "processing": true,
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
			exportOptions: {
                        columns: ':visible'
                    }
			

        }, {
            extend: 'pdf',
            text: 'Export to PDF',
            className: 'btn btn-primary',
			exportOptions: {
                        columns: ':visible'
                    }

        }],
		
		'columnDefs' : columnDefs ,
		
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        "columns": [{
            "data": "slNoIndex"
        }, {
            "data": "vehicleNoIndex"
        }, {
            "data": "sourceIndex"
        }, {
            "data": "plannedDateIndex"
        }, {
            "data": "actualDateIndex"
        }, {
            "data": "statusIndex"
        }, {
            "data": "alertIndex"
        }]
    });

    $(".dt-buttons").append('<button type="button" class="btn btn-default btn-md" id="backButtonId1" onclick="pdfnewButton();" class="blueGrey">Trip Summary PDF</button>');
    $(".dt-buttons").append('<span style="margin-left:4px;"><span style="float:left;font-weight:bold;padding-top:8px;" class="show-label">Play History: </span><img style="float:left;padding-left:8px;padding-top:8px;" class="play" id="play/pause" src="/ApplicationImages/ApplicationButtonIcons/play.png" alt="Play History Analysis" onclick="playHistoryTracking(this);" title="Play History Analysis"/><img class="pause" id ="stop" style="padding-top:8px;padding-left:8px;float:left;" src="/ApplicationImages/ApplicationButtonIcons/stop.png" onclick="stopHistoryTracking();" title="Stop History Analysis" /><span style="margin-left: 16px;padding-top:8px;float:left;" class="show-label">Speed controller :</span><input style="padding-top:8px;margin-left: 16px;width:134px;float:left;margin-right:8px;" type="range" min="1" max="100" value="0" class="slider" id="myRange"></span>');

}

function clearMap() {
    if (lineInfo.length > 0) {
        for (var k = 0; k < lineInfo.length; k++) {
            map.removeLayer(lineInfo[k]);
        }
    }
    if (plyArray.length > 0) {
        for (var i = 0; i < plyArray.length; i++) {
            map.removeLayer(plyArray[i]);
        }
    }
}

function plotHistoryToMap() {
    var lon = 0.0;
    var lat = 0.0;
    var latlng;
    var mkrCtr = 0;
    var k = 0;
    titleMkr = [];
    var bounds = new L.LatLngBounds();
    vehicleNo = '<%=vehicleNo%>'
    if (datalist != null) {
        lat = datalist[0];
        lon = datalist[1];

        for (var i = 0; i < datalist.length; i++) {
            if (datalist[i] != null && datalist[i + 1] != null && datalist[i + 2] != null) {

                mylatLong = new L.LatLng(lat, lon);
                lat = datalist[i];
                lon = datalist[i + 1];
                if (i == 0) { //start flag
                    imageurl = '/ApplicationImages/VehicleImages/redcirclemarker.png';
                    image = L.icon({
                        iconUrl: String(imageurl),
                        iconSize: [25, 25], // size of the icon
                        popupAnchor: [0, -15]
                    });
                } else if (i >= datalist.length - 12) { //stop flag
                    imageurl = '/ApplicationImages/VehicleImagesNew/MapImages/Truck_BG.png';
                    image = L.icon({
                        iconUrl: String(imageurl),
                        iconSize: [25, 25], // size of the icon
                        popupAnchor: [0, -15]
                    });
                }
                var date = convert(infolist[k]);
                titleMkr.push("");
                titleMkr.push("");
                var loc = infolist[k + 3];
                var loctn = "";
                if (loc != null && loc != "" && loc != undefined) {
                    loctn = loc.replace(/\'/g, "");
                }
                var speed = infolist[k + 4];
                k = k + 24;
                plyArray.push(new L.LatLng(lat, lon));

                if ((i >= datalist.length - 12) || (i == 0)) {

                    content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">' +
                        '<table>' +
                        '<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>' + vehicleNo + '</td></tr>' +
                        '<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>' + loc + '</td></tr>' +
                        '<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>' + date + '</td></tr>' +
                        '<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>' + speed + '</td></tr>' +
                        '</table>' +
                        '</div>';

                    var marker = new L.Marker(new L.LatLng(lat, lon), {
                        icon: image
                    }).addTo(map);
                    lineInfo.push(marker);
                    marker.bindPopup(content);
                }
                //animatePolylines();
                animate = "true";
                i += 11;
                if (flag == true) {
                    bounds.extend(mylatLong);
                    map.fitBounds(bounds);
                    pdfzoom = map.getZoom();
                }
            }
        } // for loop end
        var polyline = L.polyline(plyArray, {
            color: '#006400',
            weight: 5,
            smoothFactor: 1
        }).addTo(map);
        var decorator = L.polylineDecorator(polyline, {
		    patterns: [
		        {offset: 0, repeat: 50, symbol: L.Symbol.arrowHead({pixelSize: 8, polygon: false, pathOptions: {stroke: true,color:'#006400'}})}
		    ]
		}).addTo(map);
        flag = false;
    }
}

function plotMarkers() {
    var lon = 0.0;
    var lat = 0.0;
    var latlng;
    var mkrCtr = 0;
    var k = 0;
    var bounds = new L.LatLngBounds();
    vehicleNo = '<%=vehicleNo%>'
    if (datalist != null) {
        lat = datalist[0];
        lon = datalist[1];

        for (var i = 0; i < datalist.length; i++) {
            if (datalist[i] != null && datalist[i + 1] != null && datalist[i + 2] != null) {
                mylatLong = new L.LatLng(lat, lon);
                lat = datalist[i];
                lon = datalist[i + 1];
                var date = convert(infolist[k]);
                var loc = infolist[k + 3];
                var loctn = "";
                if (loc != null && loc != "" && loc != undefined) {
                    loctn = loc.replace(/\'/g, "");
                }
                var speed = infolist[k + 4];
                k = k + 6;

                if (datalist[i + 2] == "1") //stop
                {
                    imageurl = '/ApplicationImages/VehicleImages/redbal.png';
                } else if (datalist[i + 2] == "2") //overspeed
                {
                    imageurl = '/ApplicationImages/VehicleImages/bluebal.png';
                } else if (datalist[i + 2] == "3") //idle
                {
                    imageurl = '/ApplicationImages/VehicleImages/yellowbal.png';
                } else //other points
                {
                    imageurl = '/ApplicationImages/VehicleImages/GreenBalloon1.png';
                }

                content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">' +
                    '<table>' +
                    '<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>' + vehicleNo + '</td></tr>' +
                    '<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>' + loc + '</td></tr>' +
                    '<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>' + date + '</td></tr>' +
                    '<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>' + speed + '</td></tr>' +
                    '</table>' +
                    '</div>';
                image = L.icon({
                    iconUrl: imageurl,
                    iconSize: [20, 20], // size of the icon
                    popupAnchor: [0, -15]
                });
                var marker = new L.Marker(new L.LatLng(lat, lon), {
                    icon: image
                }).addTo(map);
                marker.bindPopup(content);
                playMarkerArr.push(marker);
                i += 2;
                if (flag == true) {
                    bounds.extend(mylatLong);
                    map.fitBounds(bounds);
                    pdfzoom = map.getZoom();
                }
            }
        } // for loop end
        flag = false;

    }
}

function pdfnewButton() {
    window.open("<%=request.getContextPath()%>/TripSummaryPDFCustom?vehicleNo=" + '<%=vehicleNo%>' + "&startDate=" + '<%=startDate%>' + "&endDate=" + endDate + "&tripId=" + '<%=tripNo%>' + "&pdfzoom=" + pdfzoom + "&routeId=" + '<%=routeId%>');
}

function convert(time) {
    var date = "";
    if (time != null && time != "" && time != undefined) {
        date = time.replace(/\'/g, "");
        return date;
    } else {
        return date;
    }
}

function animatePolylines() {
    var count = 0;
    window.setInterval(function () {
        count = (count + 1) % 200;
        var icons = poly.get('icons');
        icons[0].offset = (count / 2) + '%';
        poly.set('icons', icons);
    }, 9000);
}

function closeInfowindow() {
    if (infoWindows.length > 0) {
        infoWindows[0].set("marker", null);
        infoWindows[0].close();
        infoWindows.length = 0;
    }
}

function backButton() {
    if (pageId == 2) {
        window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripSummaryReport.jsp";
    } else if (pageId == 99) {
        window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAdminDashboardAmazon.jsp";
    } else if (pageId == 3) {
        window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/DashBoardDHL.jsp";
    } else if (pageId == 4) {
        window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/SLADashBoard.jsp";
    } else if (pageId == 5) {
        window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripSummaryReportDHL.jsp";
    } else if (pageId == 6) {
        window.location.href = "<%=request.getContextPath()%>/Jsps/DistributionLogistics/MiddleMileDashboard.jsp";
    } else {
        window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAdminDashboard.jsp";
    }
}

function plotMarker(lat, lon, name, sequence, type, alertId, date, alertName, vehicleExitTime) {
    var image;
    var location;
    var marker1;
    var infowindowpoints;
    var contentForDot;
    if (type == 'events') {
        location = "Location";
        if (alertId == 2) { // overspeed

            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/pinkdashBoard.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            alertName = "Overspeed";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            overSpeedMarkerArr.push(marker1);
        } else if (alertId == 7) { // GPS tampering
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/blueBalloonNew.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            alertName = "Device Tampering";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            tamperMarkerArr.push(marker1);
        } else if (alertId == 58) { // HB
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/orangeBalloon.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            alertName = "Harsh Brake";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            HBMarkerArr.push(marker1);
        } else if (alertId == 3) { // Panic
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/redBalloon.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            alertName = "Panic";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            panicMarkerArr.push(marker1);
        } else if (alertId == 45) { // Restrictive Hours
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/lightGreenBalloon.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            alertName = "Restrictive Driving";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            restrictiveMarkerArr.push(marker1);
        } else if (alertId == 174) { // Error codes
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/purpleBalloon.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            alertName = "Engine Malfunction";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            ErrorMarkerArr.push(marker1);
        } else {
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/yellowBalloon.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            othersMarkerArr.push(marker1);
        }
        contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:auto;background:#ffffff; line-height:100%; font-size:10px; font-family: sans-serif;">' +
            '<table>' +
            '<tr><td><b> Alert name : </b></td><td>' + alertName + '</td></tr>' +
            '<tr><td><b>Location : </b></td><td>' + name + '</td></tr>' +
            '<tr><td><b>Date time : </b></td><td>' + date + '</td></tr>' +
            '</table>' +
            '</div>';
        marker1.bindPopup(contentForDot);
        markerArr.push(marker1);
    } else {
        var str = "";
        if (sequence == 0) {
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/startflag.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            location = 'Source';
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            mainArr.push(marker1);
            str = '<tr><td><b>Date Time : </b></td><td>' + date + '</td></tr>';
        } else if (sequence == 100) {
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/endflag.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            location = "Destination";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            mainArr.push(marker1);
            str = '<tr><td><b>Date Time : </b></td><td>' + date + '</td></tr>';
        } else {
            image = L.icon({
                iconUrl: '/ApplicationImages/VehicleImages/PinkBalloon.png',
                iconSize: [30, 30], // size of the icon
                popupAnchor: [0, -15]
            });
            location = "Check Point";
            marker1 = new L.Marker(new L.LatLng(lat, lon), {
                icon: image
            }).addTo(map);
            checkMarkerArr.push(marker1);
            str = '<tr><td><b>Vehicle Entry Time : </b></td><td>' + date + '</td></tr>' +
                '<tr><td><b>Vehicle Exit Time : </b></td><td>' + vehicleExitTime + '</td></tr>';
        }
        contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:auto; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
            '<table>' +
            '<tr><td><b>' + location + ' : </b></td><td>' + name + '</td></tr>' +
            str +
            '</table>' +
            '</div>';
        marker1.bindPopup(contentForDot);
        markerArr.push(marker1);
    }
}

var bufferStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getBufferMapView',
    id: 'BufferMapView',
    root: 'BufferMapView',
    autoLoad: false,
    remoteSort: true,
    fields: ['longitude', 'latitude', 'buffername', 'radius', 'imagename']
});

var polygonStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getPolygonMapView',
    id: 'PolygonMapView',
    root: 'PolygonMapView',
    autoLoad: false,
    remoteSort: true,
    fields: ['longitude', 'latitude', 'polygonname', 'sequence', 'hubid']
});

function showHub(cb) {
    if (cb.checked) {
        document.getElementById('SearchDiv').style.display = 'inline';
        bufferStore.load({

            params: {
                tripId: '<%=tripNo%>'
            },
            callback: function () {
                plotBuffers();
            }
        });
    } else {
        document.getElementById('SearchDiv').style.display = 'none';
        document.getElementById('SearchDiv').value = '';

        map.setZoom(4);

        if (circleInfoWindow != undefined) {
            circleInfoWindow.close();
        }
        if (markerInfoWindow != undefined) {
            markerInfoWindow.close();
        }
        if (polyInfoWindow != undefined) {
            polyInfoWindow.close();
        }
        if (buffermarker != undefined) {
            map.removeLayer(buffermarker);
        }
        if (circle != undefined) {
            map.removeLayer(circle);
        }

        if (polygon != undefined) {
            map.removeLayer(polygon);
        }

        for (var i = 0; i < circles.length; i++) {
            map.removeLayer(circles[i]);
            map.removeLayer(buffermarkers[i]);
        }
        for (var i = 0; i < polygons.length; i++) {
            map.removeLayer(polygons[i]);
            map.removeLayer(polygonmarkers[i]);
        }
        hubListArray = [];
        $("#searchHubFilter").empty().select2();
    }
}

function plotBuffers() {
    for (var i = 0; i < bufferStore.getCount(); i++) {
        var rec = bufferStore.getAt(i);

        var urlForZero = '/ApplicationImages/VehicleImages/information.png';
        var convertRadiusToMeters = rec.data['radius'] * 1000;
        var myLatLng = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
        hubListArray.push(rec.data['buffername']);

        if (convertRadiusToMeters == 0 && rec.data['imagename'] != '') {
            var image1 = '/jsps/images/CustomImages/';
            var image2 = rec.data['imagename'];
            urlForZero = image1 + image2;
        } else if (convertRadiusToMeters == 0 && rec.data['imagename'] == '') {
            urlForZero = '/jsps/OpenLayers-2.10/img/marker.png';
        }
        bufferimage = L.icon({
            iconUrl: String(urlForZero),
            iconSize: [19, 35], // size of the icon
            popupAnchor: [0, -15]
        });

        buffermarker = new L.Marker(myLatLng, {
            icon: bufferimage
        }).addTo(map);
        buffermarker.bindPopup(rec.data['buffername']);


        buffermarkers[i] = buffermarker;
        circles[i] = L.circle(myLatLng, {
            color: '#A7A005',
            fillColor: '#ECF086',
            fillOpacity: 0.55,
            center: myLatLng,
            radius: convertRadiusToMeters //In meters
        }).addTo(map);
    }

    polygonStore.load({
        params: {
            tripId: '<%=tripNo%>'
        },
        callback: function () {
            plotPolygon();
        }
    });
}

function plotPolygon() {
    var hubid = 0;
    var polygonCoords = [];
    for (var i = 0; i < polygonStore.getCount(); i++) {
        var rec = polygonStore.getAt(i);
        if (i != polygonStore.getCount() - 1 && rec.data['polygonname'] != polygonStore.getAt(i + 1).data['polygonname']) {
            hubListArray.push(rec.data['polygonname']);
        }

        if (i != polygonStore.getCount() - 1 && rec.data['hubid'] == polygonStore.getAt(i + 1).data['hubid']) {
            var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
            polygonCoords.push(latLong);
            continue;
        } else {
            var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
            polygonCoords.push(latLong);
        }
        var polygon = L.polygon(polygonCoords).addTo(map);

        polygonimage = L.icon({
            iconUrl: '/ApplicationImages/VehicleImages/information.png',
            iconSize: [48, 48], // size of the icon
            popupAnchor: [0, -15]
        });

        polygonmarker = new L.Marker(new L.LatLng(rec.data['latitude'], rec.data['longitude']), {
            bounceOnAdd: true
        }, {
            icon: polygonimage
        }).addTo(map);
        polygonmarker.bindPopup(rec.data['polygonname']);

        polygons[hubid] = polygon;
        polygonmarkers[hubid] = polygonmarker;
        hubid++;
        polygonCoords = [];
    }
    autocomplete();
}

function autocomplete() {
    var $searchHubFilter = $('#searchHubFilter');
    var output = '';
    $.each(hubListArray, function (index, value) {
        $('#searchHubFilter').append($("<option></option>").attr("value", value).text(value));
    });
    $('#searchHubFilter').select2();
}

$('#searchHubFilter').change(function () {
    searchHub = $('#searchHubFilter option:selected').val();

    if (circleInfoWindow != undefined) {
        circleInfoWindow.close();
    }
    if (markerInfoWindow != undefined) {
        markerInfoWindow.close();
    }
    if (polyInfoWindow != undefined) {
        polyInfoWindow.close();
    }
    if (buffermarker != undefined) {
        map.removeLayer(buffermarker);
    }
    if (circle != undefined) {
        map.removeLayer(circle);
    }
    if (polygon != undefined) {
        map.removeLayer(polygon);
    }

    for (var i = 0; i < bufferStore.getCount(); i++) {
        var rec = bufferStore.getAt(i);
        if (searchHub == rec.data['buffername']) {
            if (parseFloat(rec.data['radius']) > 0) {
                var convertRadiusToMeters = rec.data['radius'] * 1000;
                var myLatLng = new L.LatLng(rec.data['latitude'], rec.data['longitude']);

                bufferimage = L.icon({
                    iconUrl: '/ApplicationImages/VehicleImages/information.png',
                    iconSize: [19, 35], // size of the icon
                    popupAnchor: [0, -15]
                });

                buffermarker = new L.Marker(myLatLng, {
                    icon: bufferimage
                }).addTo(map);
                buffermarker.bindPopup(rec.data['buffername']);
                var bounds = new L.LatLngBounds();
                bounds.extend(myLatLng);
                map.fitBounds(bounds);
                if (rec.data['radius'] < 1.0) {
                    map.setZoom(15);
                } else {
                    map.setZoom(9);
                }

                circle = L.circle(myLatLng, {
                    color: '#A7A005',
                    fillColor: '#ECF086',
                    fillOpacity: 0.55,
                    center: myLatLng,
                    radius: convertRadiusToMeters //In meters
                }).addTo(map);

            } else {
                var myLatLng = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
                bufferimage = L.icon({
                    iconUrl: String('/ApplicationImages/VehicleImages/information.png'),
                    iconSize: [19, 35], // size of the icon
                    popupAnchor: [0, -15]
                });
                var bounds = new L.LatLngBounds(myLatLng);
                map.fitBounds(bounds);
                buffermarker = new L.Marker(new L.LatLng(rec.data['latitude'], rec.data['longitude']), {
                    bounceOnAdd: true
                }, {
                    icon: bufferimage
                }).addTo(map);
                buffermarker.bindPopup(rec.data['buffername']);
                buffermarkers[i] = buffermarker;
            }
        }
    }

    var polygonCoords = [];
    var contentvalue;
    for (var i = 0; i < polygonStore.getCount(); i++) {
        var rec = polygonStore.getAt(i);
        if (searchHub == rec.data['polygonname']) {
            contentvalue = rec.data['polygonname'];
            var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
            polygonCoords.push(latLong);
        }
    }
    if (polygonCoords.length > 0) {
        var polygon = L.polygon(polygonCoords).addTo(map);
        polygonimage = L.icon({
            iconUrl: '/ApplicationImages/VehicleImages/information.png',
            iconSize: [48, 48], // size of the icon
            popupAnchor: [0, -15]
        });

        polygonmarker = new L.Marker(new L.LatLng(rec.data['latitude'], rec.data['longitude']), {
            bounceOnAdd: true
        }, {
            icon: polygonimage
        });
        polygonmarker.bindPopup(rec.data['polygonname']);

    }
});

function getRoutePath1(routeId) {
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getLatLongs',
        data: {
            routeId: routeId
        },
        success: function (result) {
            results = JSON.parse(result);
            var polylatlongs = [];
            var latlonS;
            var latlonD;
            for (var i = 0; i < results["latLongRoot"].length; i++) {
                if ((results["latLongRoot"][i].type == 'SOURCE')) {
                    latlonS = new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                }
                if (results["latLongRoot"][i].type == 'DESTINATION') {
                    latlonD = new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                }
                if (results["latLongRoot"][i].type == 'CHECK POINT') {
                    polylatlongs.push({
                        location: new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon),
                        stopover: true
                    });
                }
            }
            drawRoute(latlonS, latlonD, polylatlongs);
        }
    });
}

function getRoutePath(routeId) {
    $.ajax({
        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLatLongsForRoute',
        data: {
            legIds: routeId
        },
        success: function (result) {
            results = JSON.parse(result);
            var polylatlongs = [];
            var latlonS;
            var latlonD;
            for (var i = 0; i < results["routelatlongRoot1"].length; i++) {
                if ((results["routelatlongRoot1"][i].type == 'SOURCE')) {
                    latlonS = new L.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon);
                }
                if (results["routelatlongRoot1"][i].type == 'DESTINATION') {
                    latlonD = new L.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon);
                }
                if (results["routelatlongRoot1"][i].type == 'CHECKPOINT') {
                    polylatlongs.push(new L.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon));
                }
                if (results["routelatlongRoot1"][i].type == 'DRAGPOINT') {
                    polylatlongs.push(new L.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon));
                }
            }
            drawRoute(latlonS, latlonD, polylatlongs);
        }
    });
}

function drawRoute(latlonS, latlonD, polylatlongs) {
		$('#routeLoad').show();	
		var route = new Array();
		var waypoints = 'waypoint0='+latlonS.lat +','+latlonS.lng;
		route.push({lat:latlonS.lat ,lng:latlonS.lng});
		var counter = 0;
		for (var i = 0; i < polylatlongs.length; i++) {
			counter = i+1;
			route.push({lat:polylatlongs[i].lat ,lng:polylatlongs[i].lng});
			waypoints = waypoints + '&waypoint'+(counter)+'='+polylatlongs[i].lat +','+polylatlongs[i].lng; 
		}
		route.push({lat:latlonD.lat ,lng:latlonD.lng});
		waypoints = waypoints + '&waypoint'+(counter+1)+'='+latlonD.lat +','+latlonD.lng;
  
   if ('<%=mapName%>' === 'HERE'){
     
		var url = 'https://route.api.here.com/routing/7.2/calculateroute.json?'+waypoints+'&mode='+'<%=bean.getRoutingType()%>'+';'+'<%=bean.getVehicleType()%>'+';traffic:disabled&routeattributes=shape&excludeCountries=BGD,PAK,NPL,BTN,CHN&app_id='+ '<%=appKey%>' + '&app_code=' + '<%=appCode%>';
		fetch(url).then(function(response){
			resp = response.json();
			return resp;
		}).then(function(json) {
			var shape = json.response.route[0].shape.map(x => x.split(","));
			poly = L.polyline(shape).addTo(map);
			routePolylines.push(poly);
			$('#routeLoad').hide();	
		})
    
    }else{
		
		var strRoute = JSON.stringify(route);
		 var url = 'http://localhost:1080/T4uMaps/GraphHopperMapRouteFinder';
		fetch(url,{method: 'POST',headers: {'Content-Type': 'application/json'},body: strRoute}).then(function(response){
			resp = response.json();
			return resp;
		}).then(function(json) {
			if ('MapData' in json){
				var shape = json.MapData.osmPoliLine.map(x => x.split(","));
				var poly = L.polyline(shape).addTo(map);
			} else{
				alert("No Routes Found.....");
			}
			
		})
		
    // routingControl = L.Routing.control({
    	// //router: new L.Routing.Here('F2jsoaclab3V97730NER', '5yey32J-HFMpzb8ujp-b3A'),
        // waypoints: route,
        // lineOptions: {
            // styles: [{
                // color: '#1F6CF0',
                // opacity: 1,
                // weight: 5
            // }]
        // },
        // createMarker: function () {
            // return null;
        // }

    // }).addTo(map);
	$('#routeLoad').hide();	
	}
	
}

function plotEventMarkers(alertID) {
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSummaryDetails',
        data: {
            tripNo: '<%=tripNo%>',
            alertId: alertID
        },
        success: function (result) {
            checkPointList = JSON.parse(result);
            for (var i = 0; i < checkPointList["tripSummarysRoot"].length; i++) {
                if (checkPointList["tripSummarysRoot"][i].lat != '0' && checkPointList["tripSummarysRoot"][i].lon != '0' &&
                    checkPointList["tripSummarysRoot"][i].lat != '0.0' && checkPointList["tripSummarysRoot"][i].lon != '0.0') {
                    var latlng = new L.LatLng(checkPointList["tripSummarysRoot"][i].lat, checkPointList["tripSummarysRoot"][i].lon);
                    var name = checkPointList["tripSummarysRoot"][i].sourceIndex;
                    var sequence = checkPointList["tripSummarysRoot"][i].seq;
                    var type = checkPointList["tripSummarysRoot"][i].type;
                    var alertId = checkPointList["tripSummarysRoot"][i].alertId;
                    var date = checkPointList["tripSummarysRoot"][i].actualDateIndex;
                    var alertName = checkPointList["tripSummarysRoot"][i].alertIndex;
                    var vehicleExitTime = checkPointList["tripSummarysRoot"][i].vehicleExitTime;

                    plotMarker(checkPointList["tripSummarysRoot"][i].lat, checkPointList["tripSummarysRoot"][i].lon, name, sequence, type, alertId, date, alertName, vehicleExitTime);
                }
            }
        }
    });
}

/********************************Play/Pause**********************************/
function createPolylineTrace() {
    if (plyArray.length > 0) {
        for (var i = 0; i < plyArray.length; i++) {
            map.removeLayer(plyArray[i]);
        }
    }
    var lon = 0.0;
    var lat = 0.0;
    var flightPath = [];

    for (var i = 0; i < datalist.length; i++) {
        lat = datalist[i];
        lon = datalist[i + 1];
        if (i == 0) {
            var positionFlag = new L.LatLng(lat, lon);
            serviceStationMarker = new L.Marker(positionFlag).addTo(map);
            firstLatLong = positionFlag;
        }
        var latLong = new L.LatLng(lat, lon);
        flightPath.push(latLong);
        if (i == (datalist.length - 3)) {
            var positionFlag = new L.LatLng(lat, lon);
            markerFlagGreen = new L.Marker(positionFlag).addTo(map);
            var BoundsForPlotting = new L.LatLngBounds();
            BoundsForPlotting.extend(firstLatLong);
            BoundsForPlotting.extend(latLong);
            map.fitBounds(BoundsForPlotting);
            map.setZoom(14);

        }
        i += 2;
    }
    polyline = L.polyline(flightPath, {
        color: '#006400',
        weight: 4,
        smoothFactor: 1
    }).addTo(map);
    var decorator = L.polylineDecorator(polyline, {
		    patterns: [
		        {offset: 0, repeat: 50, symbol: L.Symbol.arrowHead({pixelSize: 8, polygon: false, pathOptions: {stroke: true,color:'#006400'}})}
		    ]
		}).addTo(map);

    polylines.push(polyline);
}

var playCount = 0;
var playDataList = datalist;
var playInfoDataList = infolist;
var playTitle = 1;
var infoCount = 0;
var i = 0;
var startCtr;
var endCtr;
var pausedCtr = 0;
var clickeventofimg = false;
var firstload = 1;
var titleMkr = [];
var simpleMarkers = [];
var markers = [];
var speedMarkers = [];
var mapZoom;
var polyline;
var polylines = [];
var routePolylines = [];
var path;
var timerval = null;
var mkrColl = [];
var displaytext = [];
var labelmarkers = [];
var livePlottingInterval;

function getStartEndCounterForPlay() {
    startCtr = 0;
    // endCtr=(titleMkr.length/2)-1;
    endCtr = (datalist.length / 2) - 1
}

function playHistoryTracking(cb) {
    for (var j = 0; j < playMarkerArr.length; j++) {
        map.removeLayer(playMarkerArr[i]);
    }
    clearInterval(livePlottingInterval);
    if (pausedCtr == 0) {
        getStartEndCounterForPlay();
        playCount = startCtr * 3;
    } else {
        playCount = pausedCtr * 3;
        i = pausedCtr;
        infoCount = pausedCtr * 6;
        playTitle = pausedCtr + 1;
        pausedCtr = 0;
    }
    if (startCtr == endCtr) {
        Ext.example.msg("No records to Play during this interval.");
    } else {
        if (cb.alt == "Play History Analysis") {
            running = true;
            if (playCount == startCtr * 3) {
                clearMap1();
                clearMarkers();
                playCount = startCtr * 3;
                playTitle = 1;
                infoCount = startCtr * 6;
                i = startCtr;
            }
            console.log(playDataList);
            playDataList = datalist;
            playInfoDataList = infolist;
            if (typeof (sliderValue) == "undefined" || sliderValue == 0) {
                timerval = window.setInterval("animate1()", 1000);
                cb.src = "/ApplicationImages/ApplicationButtonIcons/pause.png";
                cb.alt = "Pause History Analysis";
            } else if (sliderValue >= 0) {
                timerval = window.setInterval("animate1()", (10000 / sliderValue));
                cb.src = "/ApplicationImages/ApplicationButtonIcons/pause.png";
                cb.alt = "Pause History Analysis";
            }
            createPolylineTrace();
        } else {
            clearInterval(timerval);
            cb.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
            cb.alt = "Play History Analysis";
            running = false;
            pausedCtr = i;
        }
    }
}

function createMarker(lat, lon, content, imageurl, type) {
    var pos = new L.LatLng(lat, lon);
    image = L.icon({
        iconUrl: imageurl,
        iconSize: [19, 19], // size of the icon
        popupAnchor: [0, -15]
    });
    var marker = new L.Marker(pos, {
        icon: image
    }).addTo(map);
    if (type == 'Speed') {
        speedMarkers.push(marker);
        marker.bindPopup(content);
    } else {
        markers.push(marker);
        marker.bindPopup(content);
    }

    var latlng = new L.LatLng(lat, lon);
    map.setView(latlng);
    map.setZoom(14);
}

function animate1() {
    refreshFlag = false;
    if (playCount < (endCtr + 1) * 3) {
        if (unitOfMeasurement == "mile") {
            unitOfMeasurement = "miles";
        } else if (unitOfMeasurement == "nmi") {
            unitOfMeasurement = "nmi";
        } else if (unitOfMeasurement == "kms") {
            unitOfMeasurement = "kms";
        }
        var lon = playDataList[playCount + 1];
        var lat = playDataList[playCount];

        if (playDataList[playCount + 2] == "1") //stop
        {
            imageurl = '/ApplicationImages/VehicleImages/redbal.png';
        } else if (playDataList[playCount + 2] == "2") //overspeed
        {
            imageurl = '/ApplicationImages/VehicleImages/bluebal.png';
        } else if (playDataList[playCount + 2] == "3") //idle
        {
            imageurl = '/ApplicationImages/VehicleImages/yellowbal.png';
        } else //other points
        {
            imageurl = '/ApplicationImages/VehicleImages/GreenBalloon1.png';
        }
        var date = convert(playInfoDataList[infoCount]);
        var loctn;
        var loc = playInfoDataList[infoCount + 3];
        if (loc != null && loc != "" && loc != undefined) {
            loctn = loc.replace(/\'/g, "");
        }
        var speed = playInfoDataList[infoCount + 4];
        var stopHrs = getHrMinsFormat(playInfoDataList[infoCount + 5]);
        infoCount = infoCount + 6;
        if (playDataList[playCount + 2] == "1") {
            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto;color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">' +
                '<table class="infotable">' +
                '<tr><td style="font-weight: bold;">Date:</td><td>' + date + '</td></tr>' +
                '<tr><td style="font-weight: bold;">Speed:</td><td><span>' + speed + '</span><span style="margin-left:1em;">' + unitOfMeasurement + '</span></td></tr>' +
                '<tr><td style="font-weight: bold;">Idle Hours:</td><td>' + stopHrs + '</td></tr>' +
                '<tr><td style="font-weight: bold;">Location:</td><td>' + loctn + '</td></tr>' +
                '<tr><td></td><td>' +
                '<span class="create-land-route">' +
                '</td></tr>' +
                '</div>';
        } else if (playDataList[playCount + 2] == "3") {
            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto;color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">' +
                '<table class="infotable">' +
                '<tr><td style="font-weight: bold;">Date:</td><td>' + date + '</td></tr>' +
                '<tr><td style="font-weight: bold;">Speed:</td><td><span>' + speed + '</span><span style="margin-left:1em;">' + unitOfMeasurement + '</span></td></tr>' +
                '<tr><td style="font-weight: bold;">Idle Hours:</td><td>' + stopHrs + '</td></tr>' +
                '<tr><td style="font-weight: bold;">Location:</td><td>' + loctn + '</td></tr>' +
                '<tr><td></td><td>' +
                '<span class="create-land-route">' +
                '</td></tr>' +
                '</div>';
        } else if (playDataList[playCount + 2] == "2") {
            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">' +
                '<table class="infotable">' +
                '<tr><td style="font-weight: bold;">Date:</td><td>' + date + '</td></tr>' +
                '<tr><td style="font-weight: bold;">Speed:</td><td><span>' + speed + '</span><span style="margin-left:1em;">' + unitOfMeasurement + '</span></td></tr>' +
                '<tr><td style="font-weight: bold;">Location:</td><td>' + loctn + '</td></tr>' +
                '<tr><td></td><td>' +
                '<span class="create-land-route">' +
                '</td></tr>' +
                '</div>';
        } else {
            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:auto; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">' +
                '<table class="infotable">' +
                '<tr><td style="font-weight: bold;">Date:</td><td>' + date + '</td></tr>' +
                '<tr><td style="font-weight: bold;">Speed:</td><td><span>' + speed + '</span><span style="margin-left:1em;">' + unitOfMeasurement + '</span></td></tr>' +
                '<tr><td style="font-weight: bold;">Location:</td><td>' + loctn + '</td></tr>' +
                '<tr><td></td><td>' +
                '<span class="create-land-route">' +
                '</td></tr>' +
                '</div>';
        }
        createMarker(lat, lon, content, imageurl, '');
        imageurl = '/ApplicationImages/VehicleImages/greenbal.png';
        if (mkrColl.length > 0) {
            var greenMarkerlength = mkrColl.length - 1;
            var greenMarker = mkrColl[greenMarkerlength];
            map.removeLayer(greenMarker);
            greenMarker = null;
        }
        if (i > 0 && i < (playDataList.length / 3) - 1) {
            var position = new L.LatLng(lat, lon);
            image = L.icon({
                iconUrl: imageurl,
                iconSize: [19, 19], // size of the icon
                popupAnchor: [0, -15]
            });

            marker = new L.Marker(position, {
                icon: image
            }).addTo(map);
            marker.bindPopup(content);
            mkrColl.push(marker);
        }
        i++;
        playCount = playCount + 3;
        playTitle++;
    }
    if (playCount == (endCtr + 1) * 3) {
        running = false;
        var e = document.getElementById("play/pause");
        e.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
        e.alt = "Play History Analysis";
        playCount = 0;
        i = 0;
        infoCount = 0;
        running = false;
        pausedCtr = 0;
        clearInterval(timerval);
        startCtr = 0;
        endCtr = 0;
        title = 1;
    }
}
/********************************Stop Tracking**********************************/
function stopHistoryTracking() {
    var cb = document.getElementById("play/pause");
    cb.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
    cb.alt = "Play History Analysis";
    playCount = 0;
    i = 0;
    infoCount = 0;
    running = false;
    pausedCtr = 0;
    clearInterval(timerval);
    clearInterval(livePlottingInterval);
    running = false;
    startCtr = 0;
    endCtr = 0;
    title = 1;
    refreshFlag = true;
    clearMarkers();
    clearMovingMarkers();
    clearMap();
}
/******************************remove markers and polylines******************************/

function clearMarkers() {
    for (var i = 0; i < markers.length; i++) {
        var marker = markers[i];
        map.removeLayer(marker);
        marker = null;
    }
    markers.length = 0;
}

function clearSpeedMarkers() {
    for (var i = 0; i < speedMarkers.length; i++) {
        var marker = speedMarkers[i];
        map.removeLayer(marker);
        marker = null;
    }
    speedMarkers.length = 0;
}

function clearMovingMarkers() {
    for (var i = 0; i < mkrColl.length; i++) {
        map.removeLayer(mkrColl[i]);
    }
    mkrColl.length = 0;
}

function removePolylineTrace() {
    for (var i = 0; i < polylines.length; i++) {
        var poly = polylines[i];
        map.removeLayer(poly);
        poly = null;
    }
    polylines.length = 0;
}

function removeBorder() {
    for (var i = 0; i < borderPolylines.length; i++) {
        map.removeLayer(borderPolylines[i]);
        map.removeLayer(borderMarkers[i]);
    }
    borderPolylines.length = 0;
    for (var i = 0; i < borderCircles.length; i++) {
        map.removeLayer(borderCircleMarkers[i]);
        map.removeLayer(borderCircles[i]);
    }
    borderCircles.length = 0;
}

function removerichmarkers() {
    for (var i = 0; i < labelmarkers.length; i++) {
        var marker = labelmarkers[i];
        map.removeLayer(marker);
    }
    labelmarkers.length = 0;
}

function clearMap1() {
    removePolylineTrace();
    removerichmarkers();
}

function getHrMinsFormat(strHrs) {
    var stoptime = String(strHrs).split('.');
    var hrs = stoptime[0];
    var mins = "0";
    if (stoptime.length > 1) {
        mins = stoptime[1];
    }
    if (hrs < 10) {
        hrs = "0" + hrs;
    }
    if (mins.length == 1) {
        mins = mins + "0";
    }
    var Time = hrs + " Hr(s) " + mins + " Min(s) ";
    return Time;
}
/***********************************end of remove markers and polylines***********************************/
var slider = document.getElementById("myRange");
slider.oninput = function () {
    sliderValue = this.value;
    if (running == true) {
        if (sliderValue == 0) {
            clearInterval(timerval);
            timerval = window.setInterval("animate1()", 1000);
        } else {
            clearInterval(timerval);
            timerval = window.setInterval("animate1()", (10000 / sliderValue));
        }
    }
}
</script>
</body>
</html>
