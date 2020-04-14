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

	<!--  CSS -->
    <!-- Bootstrap Core CSS -->
<!--    <link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">-->
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">	
    <!-- MetisMenu CSS -->
    <link href="../../Main/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <!-- Custom CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">
		
	    <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
    <!-- Custom Fonts -->
<!-- 	<link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" rel="stylesheet">   -->
    <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<!--	<link href="../../Main/vendor/datatables/css/dataTables.bootstrap.min.css" rel="stylesheet">-->
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
<!--	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">-->
<!--  <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">  -->
	<link href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.bootstrap.min.css" rel="stylesheet">
<!--	<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />-->
	<link href="../../Main/vendor/customselect2.css" rel="stylesheet"/>
<!--      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />-->
		
		
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
	<!--    <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>-->
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
}
        
	</style>
</head>
<body >
	<div id="wrapper" style=" width: 99%;">
    	<div id="page-wrapper" style="background-color: white;">
            <div class="panel panel-default"  style="border: solid  1px lightgray;height:411px;">
                <div class="panel-heading" style="background-color: #fff; margin-bottom: 5px; font-weight: 700;">
                </div>
                <div class="col-lg-12">
                	<div id="map" style="width:initial;height: 350px; margin-top: 10px;margin-left: 0px "></div>
                </div>
                <div class="inline row">
                    <div class="col-lg-1 col-md-1" >
	                   <label class="container checkbox-inline">Show Hubs<input type="checkbox" onclick='showHub(this);' value=""><span class="checkmark"></span></label>
	                </div>
	                 <div class="col-lg-1 col-md-1" >
                       <label style="margin-left: 24px;" class="container checkbox-inline">Show Route<input id="showRoute" type="checkbox" value=""><span class="checkmark"></span></label>
                    </div>
	                <div class="col-lg-1 col-md-1" >
						<label class="container checkbox-inline">Checkpoint<input id="checkPoint" type="checkbox" value=""><span class="checkmark"></span></label>
					</div>
					<div class="col-lg-1 col-md-1" >
						<label class="container checkbox-inline">Panic<input id="panic" type="checkbox" value=""><span class="checkmark"></span></label>
					</div>
					<div class="col-lg-1 col-md-1" >
						<label class="container checkbox-inline">Device Tampering<input id="tampering" type="checkbox" value=""><span class="checkmark"></span></label>
					</div>
					<div class="col-lg-1 col-md-1" >
		                <label class="container checkbox-inline">Harsh Braking<input id="HB" type="checkbox" value=""><span class="checkmark"></span></label>
	                </div>
	                <div class="col-lg-1 col-md-1" >
		                <label class="container checkbox-inline">Overspeed<input id="overSpeed" type="checkbox" value=""><span class="checkmark"></span></label>
	                </div>
	                <div class="col-lg-1 col-md-1" >
		                <label class="container checkbox-inline">Restrictive Driving<input id="restritive" type="checkbox" value=""><span class="checkmark"></span></label>
	                </div>
	                <div class="col-lg-1 col-md-1" >
	                   <label class="container checkbox-inline">Engine Malfunction<input id="engine" type="checkbox" value=""><span class="checkmark"></span></label>
	                </div>
	                <div class="col-lg-1 col-md-1" >
		                <label class="container checkbox-inline">Others<input id="others" type="checkbox" value=""><span class="checkmark"></span></label>
	                </div>
	                <div class="col-lg-1 col-md-1">
                        <label class="container checkbox-inline">Track Points<input id="playMarker" type="checkbox" value=""><span class="checkmark"></span></label>
                    </div>
                </div>
                <div class="inline row" style="margin-bottom:6px;">
                	 <div class="col-lg-3 col-md-4" id="SearchDiv" style="display: none;">
                	 	<label>Search Hub: &nbsp;&nbsp;</label><select class="form-control" id="searchHubFilter">
                     </select>	
	                </div>
	                <div class="col-lg-9 col-md-8">
	                 <table style="width:31%;margin-top: 12px;">
                 	  <tr>
                       <td><span style="margin-left: 10px;" class="show-label">Play History :</span></td>
                       <td><div><img class="play" id="play/pause" src="/ApplicationImages/ApplicationButtonIcons/play.png" alt="Play History Analysis" onclick='playHistoryTracking(this);' title="Play History Analysis"/></div></td>
                       <td style="width:5%"><div><img class="pause" id ="stop" src="/ApplicationImages/ApplicationButtonIcons/stop.png" onclick='stopHistoryTracking();' title="Stop History Analysis" /></div></td>
                       <td><span style="margin-left: 10px;" class="show-label">Speed controller :</span></td>
                       <td><input type="range" min="1" max="100" value="0" class="slider" id="myRange"></td>
                   </tr>
                 </table>
	            </div>
               </div>
               
		<%if(associated>0){%> 
			<div id='placeholderForTemperatureRange'></div>
			</br>
			<div id='placeholderForTemperature'></div>
			
			<div>
				<div class="col-lg-3 col-md-3" id="humidityDivId" style="display:none;">
	                	<div  style="">
							<div class="onTripCount"
								style="text-align: center; margin-bottom: 40px;">
								<p >
									Humidity
								</p>
								
								<h4 style="font-size: 22px;" id = "humidityId" onclick="getTempDetails('Humidity');">0</h4>
								
								<h5 style="font-size: 15px;" id = "gmt5Id"></h5>
							</div>
						</div>
	                </div>
	                <div id = "reeferstatusId" class="col-lg-3 col-md-3" style="height: 161px;">
	                	<div  style="">
							<div class="onTripCount"
								style="text-align: center; margin-bottom: 40px;">
								<p >
									Reefer Status
								</p>
								<h2 style="font-size: 22px;" id = "Rid">0</h2>
								<h5 style="font-size: 15px;" id = "gmt4Id"></h5>
							</div>
						</div>
	                </div>
			</div>
            <%}%>  
                <div class="col-lg-12" style="margin-top: 13px;">
                <div class="panel-heading" style="background-color: #fff; margin-bottom: 5px; font-weight: 700;">
                	<button type="button" class="btn btn-default btn-md" id="backButtonId1" onclick="pdfnewButton();" style="margin-bottom: 4px; margin-top: 4px; background-color: deepskyblue;margin-left: -28px;">Trip Summary PDF</button>
                </div>
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
        <!-- /#page-wrapper -->
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
    <!-- /#wrapper -->
    
  <!--  <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&region=IN&key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"></script> --> 
    <script src='<%=GoogleApiKey%>'></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 
	<script>
	
		var countryName = '<%=countryName%>';
      	var map;
      	var mcOptions = {gridSize: 20, maxZoom: 100};
      	var markerClusterArray = [];
      	var animate = "true";
      	var bounds = new google.maps.LatLngBounds();
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
      	var pageId='<%=pageId%>';
		var plyArray = [];
		var polygon;
		var circle;
		var buffermarker;
		var buffermarkers=[];
		var circles=[];
		var polygonmarkers=[];
		var polygons=[];
		var markerArr = [];		
		var routeId='<%=routeId%>';
		var flag=true;
		var pdfzoom=9;
		var endDate="";
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
        var refreshFlag=true;
        var circleInfoWindow;
        var markerInfoWindow;
        var polyInfoWindow;
        var circlemarker;
        var playMarkerArr = [];
        
        
		$('#checkPoint').prop('checked', true).trigger("change");
		$('#showRoute').change(function() {
            if (this.checked) {
                if(<%=check%>==true){
                    getRoutePath1(routeId);
                }else{
                     getRoutePath(routeId);
                }
            } else {
                if (directionsDisplay != null) {
	              directionsDisplay.setMap(null);
	            }
            }
        });
		$('#checkPoint').change(function() {
            if (this.checked) {
                plotEventMarkers('0');
            } else {
                for (var i = 0; i < checkMarkerArr.length; i++) {
                    checkMarkerArr [i].setMap(null);
                }
            }
        });
        $('#panic').change(function() {
            if (this.checked) {
                plotEventMarkers('3');
            } else {
                for (var i = 0; i < panicMarkerArr.length; i++) {
                    panicMarkerArr [i].setMap(null);
                }
            }
        });
        $('#tampering').change(function() {
            if (this.checked) {
                plotEventMarkers('7');
            } else {
                for (var i = 0; i < tamperMarkerArr.length; i++) {
                    tamperMarkerArr [i].setMap(null);
                }
            }
        });
        $('#HB').change(function() {
            if (this.checked) {
                plotEventMarkers('58');
            } else {
                for (var i = 0; i < HBMarkerArr.length; i++) {
                    HBMarkerArr [i].setMap(null);
                }
            }
        });
        $('#restritive').change(function() {
            if (this.checked) {
                plotEventMarkers('45');
            } else {
                for (var i = 0; i < restrictiveMarkerArr.length; i++) {
                    restrictiveMarkerArr [i].setMap(null);
                }
            }
        });
        $('#overSpeed').change(function() {
            if (this.checked) {
                plotEventMarkers('2');
            } else {
                for (var i = 0; i < overSpeedMarkerArr.length; i++) {
                    overSpeedMarkerArr [i].setMap(null);
                }
            }
        });
         $('#engine').change(function() {
            if (this.checked) {
                plotEventMarkers('174');
            } else {
                for (var i = 0; i < ErrorMarkerArr.length; i++) {
                    ErrorMarkerArr [i].setMap(null);
                }
            }
        });
        $('#others').change(function() {
            if (this.checked) {
                plotEventMarkers('-1');
            } else {
                for (var i = 0; i < othersMarkerArr.length; i++) {
                    othersMarkerArr [i].setMap(null);
                }
            }
        });
        $('#playMarker').change(function() {
            if (this.checked) {
                plotMarkers();
            } else {
                for (var i = 0; i < playMarkerArr.length; i++) {
                    playMarkerArr [i].setMap(null);
                }
            }
        });
		function getTempDetails(temp){
		google.charts.load('current', {'packages':['corechart']});
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
                        success: function(response) {
                            tempList = JSON.parse(response);
                            if(tempList["tempRoot"].length>0){
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
      					   
      					   $(".modal-header #tripEventsTitle").text("Temperature Graph for "+'<%=vehicleNo%>'+" From "+'<%=startDate%>'+" To "+endDate);
       					   $('#add').modal('show');
      					   }else{
      					   		sweetAlert("No records Found");
      					   }
                        }
                    });
            
		}
		loadData();
      	function loadData(){
	
		function initialize(){
	      	var mapOptions = {
	      		center: new google.maps.LatLng('21.146633', '79.088860'),
		        zoom:4,
		        //zoomControl: true,
		        mapTypeId: google.maps.MapTypeId.STREET,
		        mapTypeControl: false,
		        gestureHandling: 'greedy' 
		    };
		   	map = new google.maps.Map(document.getElementById('map'), mapOptions);
			var trafficLayer = new google.maps.TrafficLayer();
        	trafficLayer.setMap(map);
			
		   	//var mapZoom = 14;
		   	var geocoder = new google.maps.Geocoder();
			geocoder.geocode({'address': countryName}, function(results, status) {
				if (status == google.maps.GeocoderStatus.OK) {
					map.setCenter(results[0].geometry.location);
				    map.fitBounds(results[0].geometry.viewport);
			    }
			});
		}
		initialize();
		
		function loadMaps(){
		    for(var i = 0 ; i < checkMarkerArr.length; i++){
               checkMarkerArr[i].setMap(null);
            } 
			//var endDate = "";
			if('<%=sts%>' == 'OPEN'){
				var today = new Date();
				var dd = today.getDate();
				var mm = today.getMonth()+1; //January is 0!
				var hh = today.getHours();
				var MM = today.getMinutes();
				var ss = today.getSeconds();
	
				var yyyy = today.getFullYear();
				if(dd<10){
	    			dd='0'+dd;
				} 
				if(mm<10){
	    			mm='0'+mm;
				}
				if(hh < 10){
					hh = "0"+hh
				}
				if(MM < 10){
					MM = "0"+MM; 
				}
				if(ss < 10){
					ss = "0"+ss;
				} 
				endDate = dd+'/'+mm+'/'+yyyy+' '+hh+':'+MM+':'+ss;	
			}else{
				endDate = '<%=endDate%>';
			}
		    
		$.ajax({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getHistoryAnalysisForTripDashBoard',
				data:{
					vehicleNo: '<%=vehicleNo%>',
					startdate: '<%=startDate%>',
					timeband:  0,
					enddate: endDate
				},
				success: function(result) { 
			 	 	datalist = [];
					infolist = [];
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
			  tripId :'<%=tripNo%>'
            },
            "dataSrc": "tempCounts",
            success: function(result) {
                results = JSON.parse(result);
				var tempArray = results["tempCounts"][0].temperatureData;
				var tempRange = results["tempCounts"][0].temperatureRange;
				var txt1="";
   		 		for(var i=0; i <tempArray.length;i++){
				var sensorname = tempArray[i].name;
     				txt1 =txt1+ "<div id='reeferId'  class='col-lg-2 col-md-2'>"+
	                	"<div  style=''>"+
						"<div class='onTripCount'style='text-align: center; margin-bottom: 40px;' >"+
						"<p >"+tempArray[i].name+"</p>"+
						"<h4 style=font-size: 22px;>"+tempArray[i].value+"</h4>"+
						"<h5 style='font-size: 15px;'>"+tempArray[i].time+"</h5>"+
						"</div>"+
						"</div>"+
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
	            "data":{
	            	tripNo: '<%=tripNo%>'
	            }
	        },
	        "bDestroy": true,
	        "processing": true,
        	dom: 'Bfrtip',
        	 buttons: [ {	extend:'excel',
	      	 				text: 'Export to Excel',
	      	 				className: 'btn btn-primary',
	      	 				
			 },{				extend:'pdf',
	      	 				text: 'Export to PDF',
	      	 				className: 'btn btn-primary',
	      	 				
			 } ],
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
	            },{
	            	"data": "statusIndex"
	            },{
	            	"data": "alertIndex"
	            }]
	    	});
	    	
			//$('#tripDeatailsTable').closest('.dataTables_scrollBody').css('max-height', '100px');
			//$('#tripDeatailsTable').DataTable().draw();
			setInterval( function () {
				//if( refreshFlag==true){  
				//  loadMaps(); 
				//}
   				//$('#tripDeatailsTable').DataTable().ajax.reload();
			}, 300000);	// 30 sec interval
			
	   }
			function clearMap(){
			if(lineInfo.length > 0){
				for(var k =0; k < lineInfo.length; k++){
					lineInfo[k].setMap(null);
				}
			}
			if(plyArray.length > 0){
				for (var i = 0; i < plyArray.length; i++) {
					plyArray[i].setMap(null);
				}
			}
		}
	  		function plotHistoryToMap(){
				var lon = 0.0;
			    var lat = 0.0;
				var latlng ;
				var mkrCtr=0;
				var k = 0;
				titleMkr = [];
				var bounds = new google.maps.LatLngBounds();
				var lineSymbol = {
			        	path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
			        	scale: 2,
			        	fillColor: '#006400',
			        	fillOpacity: 1.0
			    };
	 			vehicleNo = '<%=vehicleNo%>'
     			if(datalist != null){
                    lat = datalist[0];
		            lon = datalist[1];
					centerMap = new google.maps.LatLng(lat,lon);
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
         			for(var i=0;i<datalist.length;i++) {
         				if(datalist[i] != null && datalist[i+1] != null && datalist[i+2] != null) {
         					mylatLong = new google.maps.LatLng(lat,lon);
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
            				}else if(i>=datalist.length-12){ 	//stop flag  
		            			imageurl='/ApplicationImages/VehicleImagesNew/MapImages/Truck_BG.png';
		            			image = {
						        	url:imageurl,
						        	scaledSize:  new google.maps.Size(25, 35),
						        	origin: new google.maps.Point(0, 0),
						        	anchor: new google.maps.Point(0, 32)
						   		}; 
            				}
		           			var date = convert(infolist[k]);
		           			titleMkr.push("");
        					titleMkr.push("");   
			             	var loc = infolist[k+3];
			             	var loctn="";
			             	if(loc != null && loc != "" && loc != undefined) {
			             		loctn = loc.replace(/\'/g, "");
			             	}
			             	var speed = infolist[k+4];
			          		k = k + 24;
					        var path = poly.getPath();
					 		latlng = new google.maps.LatLng(lat, lon);
					       	
					        path.push(latlng);
					        plyArray.push(poly);
					        
					       	if((i>=datalist.length-12) || (i==0)){ 
					 			var marker = new google.maps.Marker({
						            position: latlng,
						            map: map,
						            icon: image
					         	});
         						lineInfo.push(marker);
					       		content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">'+
									'<table>'+
									'<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>'+vehicleNo+'</td></tr>'+				
									'<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>'+loc+'</td></tr>'+
									'<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>'+date+'</td></tr>'+
									'<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>'+speed+'</td></tr>'+
									'</table>'+
									'</div>';
								infowindow = new google.maps.InfoWindow({
						      		content: content,
						      		marker:marker,
						      		maxWidth: 300,
						      		image:image
						  		});
								google.maps.event.addListener(marker, 'click', function() {
									infowindow.setContent(content);
									infowindow.open(map, marker);
               					});
							}
					        //animatePolylines();
					        animate = "true";
		            		i+=11;
		            		if(flag==true){
			            		bounds.extend(mylatLong);
			            		map.fitBounds(bounds);
			            		pdfzoom=map.getZoom();
		            		}
                     	} 
		            	} // for loop end
		            	flag=false;
		            }
			}  
		 function plotMarkers(){
		   var lon = 0.0;
           var lat = 0.0;
           var latlng ;
           var mkrCtr=0;
           var k = 0;
           var bounds = new google.maps.LatLngBounds();
           vehicleNo = '<%=vehicleNo%>'
           if(datalist != null){
               lat = datalist[0];
               lon = datalist[1];
               centerMap = new google.maps.LatLng(lat,lon);
               for(var i=0;i<datalist.length;i++){
                   if(datalist[i] != null && datalist[i+1] != null && datalist[i+2] != null){
                       mylatLong = new google.maps.LatLng(lat,lon);
                       lat = datalist[i];
                       lon = datalist[i+1];
                       var date = convert(infolist[k]);
                       var loc = infolist[k+3];
                       var loctn="";
                       if(loc != null && loc != "" && loc != undefined){
                           loctn = loc.replace(/\'/g, "");
                       }
                       var speed = infolist[k+4];
                       k = k + 6;
                       var path = poly.getPath();
                       latlng = new google.maps.LatLng(lat, lon);
                       var marker = new google.maps.Marker({
                           position: latlng,
                           map: map,
                           icon: image
                       });
                        if(datalist[i+2] == "1") //stop
			            {  
			                imageurl='/ApplicationImages/VehicleImages/redbal.png';
			            }  
			            else if(datalist[i+2] == "2")  //overspeed
			            {
			                imageurl='/ApplicationImages/VehicleImages/bluebal.png';
			            }
			            else if(datalist[i+2] == "3")//idle
			            {
			                imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
			            }
			            else  //other points
			            {   
			                imageurl='/ApplicationImages/VehicleImages/GreenBalloon1.png';
			            }
                       playMarkerArr.push(marker);
                       content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">'+
                           '<table>'+
                           '<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>'+vehicleNo+'</td></tr>'+              
                           '<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>'+loc+'</td></tr>'+
                           '<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>'+date+'</td></tr>'+
                           '<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>'+speed+'</td></tr>'+
                           '</table>'+
                           '</div>';
                       image = {
							url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
							size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
							origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
							anchor: new google.maps.Point(0, 32)
						};
                       infowindow = new google.maps.InfoWindow({
                           content: content,
                           marker:marker,
                           maxWidth: 300,
                           image: image
                       });
                       google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){             
			                return function() {
			                    infowindow.setContent(content);
			                    infowindow.open(map,marker);                                        
			                };
			            })(marker,content,infowindow));
                       i+=2;
                       if(flag==true){
                           bounds.extend(mylatLong);
                           map.fitBounds(bounds);
                           pdfzoom=map.getZoom();
                       }
                   }
                   } // for loop end
                   flag=false;
               }
		}
			function pdfnewButton(){
				window.open("<%=request.getContextPath()%>/TripSummaryPDF?vehicleNo="+'<%=vehicleNo%>'+"&startDate="+'<%=startDate%>'+"&endDate="+endDate+"&tripId="+'<%=tripNo%>'+"&pdfzoom="+pdfzoom+"&routeId="+'<%=routeId%>');
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
			function animatePolylines() {	
				var count = 0;
				window.setInterval(function () {
					count = (count + 1) % 200;
					var icons = poly.get('icons');		
					icons[0].offset = (count / 2) + '%';
					poly.set('icons', icons);
				}, 9000);
			}
			function closeInfowindow(){
				if(infoWindows.length > 0){
					infoWindows[0].set("marker",null);
					infoWindows[0].close();
					infoWindows.length = 0;
				} 
			}
			
		function backButton(){
		if(pageId==2){
			window.location.href= "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripSummaryReport.jsp";
		}else if(pageId==99){
			window.location.href= "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAdminDashboardAmazon.jsp";
		}else if(pageId==3){
			window.location.href= "<%=request.getContextPath()%>/Jsps/GeneralVertical/DashBoardDHL.jsp";
		}else if(pageId==4){
			window.location.href= "<%=request.getContextPath()%>/Jsps/GeneralVertical/SLADashBoard.jsp";
		}else if(pageId==5){
			window.location.href= "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripSummaryReportDHL.jsp";
		}else if(pageId==6){
      		window.location.href= "<%=request.getContextPath()%>/Jsps/DistributionLogistics/MiddleMileDashboard.jsp";
      	}else{
      		window.location.href= "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAdminDashboard.jsp";
      	}
      	}
      	function plotMarker(myLatLng,name,sequence,type,alertId,date,alertName,vehicleExitTime) {
			var image;
			var location;
			var marker1;
			var infowindowpoints;
			var contentForDot;
			if(type == 'events'){
				location = "Location";
			     if(alertId == 2){ // overspeed
			     	image = {
						url: '/ApplicationImages/VehicleImages/pinkdashBoard.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					alertName = "Overspeed";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    overSpeedMarkerArr.push(marker1);
			     }else if(alertId == 7){ // GPS tampering
			     	image = {
						url: '/ApplicationImages/VehicleImages/blueBalloonNew.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					alertName = "Device Tampering";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    tamperMarkerArr.push(marker1);
			     }else if(alertId == 58){ // HB
			     	image = {
						url: '/ApplicationImages/VehicleImages/orangeBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					alertName = "Harsh Brake";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    HBMarkerArr.push(marker1);
			     }else if(alertId == 3){ // Panic
			     	image = {
						url: '/ApplicationImages/VehicleImages/redBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					alertName = "Panic";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    panicMarkerArr.push(marker1);
			    }else if(alertId == 45){ // Restrictive Hours
			     	image = {
						url: '/ApplicationImages/VehicleImages/lightGreenBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					alertName = "Restrictive Driving";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    restrictiveMarkerArr.push(marker1);
			     }else if(alertId == 174){ // Error codes
			     	image = {
						url: '/ApplicationImages/VehicleImages/purpleBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					alertName = "Engine Malfunction";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    ErrorMarkerArr.push(marker1);
			     }else {
			     	image = {
						url: '/ApplicationImages/VehicleImages/yellowBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    othersMarkerArr.push(marker1);
			     }
				contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
				'<table>' +
				'<tr><td><b> Alert name : </b></td><td>' + alertName + '</td></tr>' +
				'<tr><td><b>Location : </b></td><td>' + name + '</td></tr>' +
				'<tr><td><b>Date time : </b></td><td>' + date + '</td></tr>' +
				'</table>' +
				'</div>';
				
				infowindowpoints = new google.maps.InfoWindow({
					content: contentForDot,
					marker: marker1,
					maxWidth: 300
					//image: image,
					//id: vehicleNo
				});
				google.maps.event.addListener(marker1, 'click', function() {
				infowindowpoints.setContent(contentForDot);
				infowindowpoints.open(map, marker1);
				});
	        markerArr.push(marker1);
			}else{
			    var str="";
				if(sequence == 0){
					image = {
						url: '/ApplicationImages/VehicleImages/startflag.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					location = 'Source';
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    mainArr.push(marker1);
                    str = '<tr><td><b>Date Time : </b></td><td>' + date + '</td></tr>' ;
				}else if(sequence == 100){
					image = {
						url: '/ApplicationImages/VehicleImages/endflag.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					location = "Destination";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    mainArr.push(marker1);
                    str = '<tr><td><b>Date Time : </b></td><td>' + date + '</td></tr>' ;
				}else{
					image = {
						url: '/ApplicationImages/VehicleImages/PinkBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
						size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
						origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
						anchor: new google.maps.Point(0, 32)
					};
					location = "Check Point";
					marker1 = new google.maps.Marker({
                        map: map,
                        position: myLatLng,
                        icon: image
                    });
                    checkMarkerArr.push(marker1);
					str = '<tr><td><b>Vehicle Entry Time : </b></td><td>' + date + '</td></tr>' +
					'<tr><td><b>Vehicle Exit Time : </b></td><td>' + vehicleExitTime + '</td></tr>' ;
				}
					contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
					'<table>' +
					'<tr><td><b>'+location +' : </b></td><td>' + name + '</td></tr>' +
					str +
					'</table>' +
					'</div>';
					
					infowindowpoints = new google.maps.InfoWindow({
						content: contentForDot,
						marker: marker1,
						maxWidth: 300
						//image: image,
						//id: vehicleNo
					});
				 	google.maps.event.addListener(marker1, 'click', function() {
						infowindowpoints.setContent(contentForDot);
						infowindowpoints.open(map, marker1);
					});
	         markerArr.push(marker1);
		    }
		   
	    }
	    
	    var bufferStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getBufferMapView',
				id:'BufferMapView',
				root: 'BufferMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','buffername','radius','imagename']
		});
		
		var polygonStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getPolygonMapView',
				id:'PolygonMapView',
				root: 'PolygonMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','polygonname','sequence','hubid']
		}); 
		
	    function showHub(cb){
	    	if(cb.checked){
	    	document.getElementById('SearchDiv').style.display='inline';	
	    		bufferStore.load({
	    		
	    		params: {
                            tripId:'<%=tripNo%>'
                        },
	    			callback:function(){
	    				plotBuffers();
	    			}
	    		});
	    	}else{
	    	document.getElementById('SearchDiv').style.display='none';	
	    	document.getElementById('SearchDiv').value='';	
	    	
	    	map.setZoom(4);
	    	
	    	if(circleInfoWindow != undefined)
	    	{
	    		circleInfoWindow.close();
	    	}
	    	if(markerInfoWindow != undefined)
	    	{
	    		markerInfoWindow.close();
	    	}
	    	if(polyInfoWindow != undefined)
	    	{
	    		polyInfoWindow.close();
	    	}
	    	if(buffermarker!= undefined)
		    {
		    		buffermarker.setMap(null);
		    }
		    if(circle!= undefined)
		   	{
		    		circle.setMap(null);
		   	}
		   	if(polygon!= undefined)
		    {
		    		polygon.setMap(null);
		    }
	    	
	    		for(var i=0;i<circles.length;i++){
	    			circles[i].setMap(null);
	    			buffermarkers[i].setMap(null);
	    		}
	    		for(var i=0;i<polygons.length;i++){
	    			polygons[i].setMap(null);
	    			polygonmarkers[i].setMap(null);
	    		}
	    		hubListArray = [];
	    		$("#searchHubFilter").empty().select2();
	    	}
	    }
	    
	    function plotBuffers(){
	    	for(var i=0;i<bufferStore.getCount();i++){
		    var rec=bufferStore.getAt(i);
		    
		    var urlForZero='/ApplicationImages/VehicleImages/information.png';
		    var convertRadiusToMeters = rec.data['radius'] * 1000;
		    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']); 
		    hubListArray.push(rec.data['buffername']);     	
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
			        urlForZero= image1+image2;
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
		    polygonStore.load({
		    
	    		params: {
                            tripId:'<%=tripNo%>'
                        },
	    			callback:function(){
	    				plotPolygon();	
	    			}
	    		});
			//autocomplete();
	    }
	    
	    function plotPolygon(){
	    //alert('polygon '+polygonStore.getCount())
	    var hubid=0;
	    var polygonCoords=[];
	    for(var i=0;i<polygonStore.getCount();i++)
	    {
	    	var rec=polygonStore.getAt(i);
	    	if(i!=polygonStore.getCount()-1 && rec.data['polygonname']!=polygonStore.getAt(i+1).data['polygonname'])
	    	{
	    		hubListArray.push(rec.data['polygonname']);     	
	    	}
	    	
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
	    autocomplete();
	   }
	   
	   function autocomplete()
	   {
	    var $searchHubFilter = $('#searchHubFilter');
                var output = '';
                //alert("hubListArray "+hubListArray.length);
                //$('#searchHubFilter').append($("<option></option>").attr("value", 'Please Select Hub').text('Please Select Hub'));
                $.each(hubListArray, function(index,value) {
                    //$('<option value='+value+'>' + value + '</option>').appendTo($searchHubFilter);
 			$('#searchHubFilter').append($("<option></option>").attr("value", value).text(value));
 		 });
 		
          $('#searchHubFilter').select2();
	   }
	  
	   $('#searchHubFilter').change(function() {
        		searchHub = $('#searchHubFilter option:selected').val();
        		//alert(searchHub);
        		
	        	if(circleInfoWindow != undefined)
		    	{
		    		circleInfoWindow.close();
		    	}
		    	if(markerInfoWindow != undefined)
		    	{
		    		markerInfoWindow.close();
		    	}
		    	if(polyInfoWindow != undefined)
		    	{
		    		polyInfoWindow.close();
		    	}
		    	if(buffermarker!= undefined)
		    	{
		    		buffermarker.setMap(null);
		    	}
	    		if(circle!= undefined)
		    	{
		    		circle.setMap(null);
		    	}
		    	if(polygon!= undefined)
		    	{
		    		polygon.setMap(null);
		    	}
        		
                    for(var i=0;i<bufferStore.getCount();i++)
                    {
                    	var rec=bufferStore.getAt(i);
                    	if(searchHub==rec.data['buffername'])
                    	{
                    		if(parseFloat(rec.data['radius']) > 0)
                    		{
            					var convertRadiusToMeters = rec.data['radius'] * 1000;
							    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']); 
							    //hubListArray.push(rec.data['buffername']);     	
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
							        
							        //circles[i] = new google.maps.Circle(createCircle);
							        circle = new google.maps.Circle(createCircle);
							        
							        
							        var bounds = new google.maps.LatLngBounds(myLatLng);
			                           map.fitBounds(bounds);
			                           if (rec.data['radius'] < 1.0) {
			                               map.setZoom(15);
			                           } else {
			                               map.setZoom(9);
			                           }
									
												    
	
						    	
										        
							        circleInfoWindow = new google.maps.InfoWindow({
								      		content:rec.data['buffername'],
								      		id:rec.data['vehicleNo'],
								      		//marker:createCircle,
								  		});	
								  		//circleInfoWindow.open(map, createCircle);
								  		circleInfoWindow.setPosition(myLatLng); 
								  		circleInfoWindow.open(map);
								  		
                    		}
                    		else
                    		{
				                    			 var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']); 
				                    		
							            		buffermarker = new google.maps.Marker({
								            	position: myLatLng,
								            	id:rec.data['vehicleNo'],
								            	map: map,
								            	icon:'/ApplicationImages/VehicleImages/information.png'
								        });
								        var markercontent=rec.data['buffername']; 	
										markerInfoWindow = new google.maps.InfoWindow({
								      		content:markercontent,
								      		id:rec.data['vehicleNo'],
								      		marker:buffermarker
								  		});	
								  		
										buffermarkers[i]=buffermarker;
										   
									    var bounds = new google.maps.LatLngBounds(myLatLng);
			                            map.fitBounds(bounds);
			                           
							        
								  		markerInfoWindow.setPosition(myLatLng); 
								  		markerInfoWindow.open(map);
                    		}
                    		//alert('success'+rec.data['latitude']+','+rec.data['longitude']+','+rec.data['radius']+','+rec.data['buffername']);
                    	   
                    	   
						   //
                    	}
                    }
                    
                    var polygonCoords=[];
                    var contentvalue;
                    for(var i=0;i<polygonStore.getCount();i++)
                    {
                    	var rec=polygonStore.getAt(i);
                    	if(searchHub==rec.data['polygonname'])
                    	{
                    		contentvalue=rec.data['polygonname'];
                    		//alert(rec.data['polygonname']+', '+rec.data['sequence']+',  '+rec.data['latitude']+',  '+rec.data['longitude']);
							var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
						    polygonCoords.push(latLong);
						}
					}
			if(polygonCoords.length > 0)
			{
				polygon = new google.maps.Polygon({
    			paths: polygonCoords,
    			map: map,
    			strokeColor: '#A7A005',
    			strokeOpacity: 0.8,
    			strokeWeight: 3,
    			fillColor: '#ECF086',
	            fillOpacity: 0.55
  				});
  				
  				var bounds = new google.maps.LatLngBounds();
                                   for (i = 0; i < polygonCoords.length; i++) {
                                       bounds.extend(polygonCoords[i]);
                                   }
           		map.fitBounds(bounds);
           		
           		polyInfoWindow = new google.maps.InfoWindow({
								      		content:contentvalue,//rec.data['polygonname'],
								      		id:rec.data['vehicleNo'],
								      		//marker:createCircle,
								  		});	
								  		//bufferinfowindow.open(map, createCircle);
								  		polyInfoWindow.setPosition(polygonCoords[0]); 
								  		polyInfoWindow.open(map);
  			}
        });	
	    
	    function getRoutePath1(routeId){
            $.ajax({
                url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getLatLongs',
                data:{
                    routeId:routeId
                },
                success: function(result){
                    results = JSON.parse(result);
                    var polylatlongs = [];
                    var latlonS;
                    var latlonD;
                    for (var i = 0; i < results["latLongRoot"].length; i++) {
                    if((results["latLongRoot"][i].type=='SOURCE')){
                        latlonS= new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                    }
                    if(results["latLongRoot"][i].type=='DESTINATION'){
                        latlonD= new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                    }
                    if(results["latLongRoot"][i].type=='CHECK POINT'){
                     polylatlongs.push({
                       location: new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon),
                       stopover: true
                     });
                    }
                    }
                    drawRoute(latlonS,latlonD,polylatlongs);
                }
            });
        }
	    
	    function getRoutePath(routeId){
			$.ajax({
				url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLatLongsForRoute',
				data:{
					legIds :routeId
				},
			    success: function(result){
			    	results = JSON.parse(result);
			    	var polylatlongs = [];
			    	var latlonS;
			    	var latlonD;
					for (var i = 0; i < results["routelatlongRoot1"].length; i++) {
						if((results["routelatlongRoot1"][i].type=='SOURCE')){
							latlonS= new google.maps.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon);
						}
						if(results["routelatlongRoot1"][i].type=='DESTINATION'){
							latlonD= new google.maps.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon);
						}
						if(results["routelatlongRoot1"][i].type=='CHECKPOINT'){
						    polylatlongs.push({
				               location: new google.maps.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon),
				               stopover: true
				            });
						}
						if(results["routelatlongRoot1"][i].type=='DRAGPOINT'){
						 polylatlongs.push({
					               location: new google.maps.LatLng(results["routelatlongRoot1"][i].lat, results["routelatlongRoot1"][i].lon),
					               stopover: false
					          });
						}
					}
                    drawRoute(latlonS,latlonD,polylatlongs);
				}
			});
		}
		function drawRoute(latlonS,latlonD,polylatlongs){
		if (directionsDisplay != null) {
             directionsDisplay.setMap(null);
         }
         var directionsService = new google.maps.DirectionsService;
         directionsDisplay = new google.maps.DirectionsRenderer({
             map: map,
             suppressMarkers: true,
              polylineOptions: {
                strokeColor: "#1F6CF0"
            }
         });
       directionsService.route({
           origin: latlonS,
           destination: latlonD,
           travelMode: google.maps.TravelMode.DRIVING,
           waypoints: polylatlongs

       }, function(response, status) {
           if (status === google.maps.DirectionsStatus.OK) {
               directionsDisplay.setDirections(response);
           } else {
               console.log("Invalid Request");
           }
       });
 }
 function setPolyPoints(polylatlongs){
	var lineSymbol = {
          path: 'M 0,-1 0,1',
          strokeOpacity: 1,
          scale: 4
        };
	  var line = new google.maps.Polyline({
	    path: polylatlongs,
	    strokeOpacity: 0,
          icons: [{
            icon: lineSymbol,
            offset: '0',
            repeat: '20px'
          }],
	     map: map
	  });
	  line.setMap(map);
   }
        function plotEventMarkers(alertID){
          $.ajax({
                url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSummaryDetails',
                data:{
                    tripNo: '<%=tripNo%>',
                    alertId : alertID
                },
                success: function(result) { 
                    checkPointList = JSON.parse(result);
                    var bounds = new google.maps.LatLngBounds();
                    for(var i = 0 ; i < mainArr.length; i++){
                        mainArr[i].setMap(null);
                    }
                    centerMap = new google.maps.LatLng(checkPointList["tripSummarysRoot"][0].lat, checkPointList["tripSummarysRoot"][0].lon);
                    for(var i=0;i<checkPointList["tripSummarysRoot"].length;i++){
                    if(checkPointList["tripSummarysRoot"][i].lat != '0' && checkPointList["tripSummarysRoot"][i].lon != '0'
                        && checkPointList["tripSummarysRoot"][i].lat != '0.0' && checkPointList["tripSummarysRoot"][i].lon != '0.0'){
                        var latlng = new google.maps.LatLng(checkPointList["tripSummarysRoot"][i].lat, checkPointList["tripSummarysRoot"][i].lon);
                        var name = checkPointList["tripSummarysRoot"][i].sourceIndex;
                        var sequence = checkPointList["tripSummarysRoot"][i].seq;
                        var type = checkPointList["tripSummarysRoot"][i].type;
                        var alertId = checkPointList["tripSummarysRoot"][i].alertId;
                        var date = checkPointList["tripSummarysRoot"][i].actualDateIndex;
                        var alertName = checkPointList["tripSummarysRoot"][i].alertIndex;
                        var vehicleExitTime = checkPointList["tripSummarysRoot"][i].vehicleExitTime;
                        
                        plotMarker(latlng,name,sequence,type,alertId,date,alertName,vehicleExitTime);
                    }
                    }
                } 
            });
        }
        
        /********************************Play/Pause**********************************/   
     function createPolylineTrace(){
     if(plyArray.length > 0){
				for (var i = 0; i < plyArray.length; i++) {
					plyArray[i].setMap(null);
				}
			}
        var lon = 0.0;
        var lat = 0.0; 
        var flightPath=[];
        var lineSymbol = {
            path: google.maps.SymbolPath.FORWARD_OPEN_ARROW,
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
                //icon:'/ApplicationImages/VehicleImages/startflag.png'
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
                    //icon:'/ApplicationImages/VehicleImages/endflag.png'
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
     } 
     
     var playCount = 0;
     var playDataList = datalist;
     var playInfoDataList = infolist;
     var playTitle = 1;
     var infoCount = 0;
     var i = 0;
     var startCtr;
     var endCtr;
     var pausedCtr=0;
     var clickeventofimg = false;   
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
    var labelmarkers = [];
    var livePlottingInterval; 
    function getStartEndCounterForPlay(){
        startCtr=0;
       // endCtr=(titleMkr.length/2)-1; 
       endCtr=(datalist.length/2)-1
    }
    function playHistoryTracking(cb)
    {
     for (var j = 0; j < playMarkerArr.length; j++) {
         playMarkerArr [j].setMap(null);
     }
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
                     clearMap1();
                     clearMarkers();                                
                     playCount = startCtr*3;
                     playTitle = 1;
                     infoCount = startCtr*6;
                     i=startCtr;
                 }
                 console.log(playDataList);
                 playDataList = datalist;
                 playInfoDataList = infolist;
                 if (typeof(sliderValue)=="undefined" || sliderValue==0){
                        timerval = window.setInterval("animate1()",1000);
                        cb.src ="/ApplicationImages/ApplicationButtonIcons/pause.png";
                        cb.alt = "Pause History Analysis";
                }else if (sliderValue>=0){
                    timerval = window.setInterval("animate1()",(10000/sliderValue));
                    cb.src ="/ApplicationImages/ApplicationButtonIcons/pause.png";
                    cb.alt = "Pause History Analysis";
                }
                createPolylineTrace();
            }
            else 
            {
                 clearInterval(timerval);
                 cb.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
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
    function animate1(){
        refreshFlag=false;
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
                //console.log("animate i=="+i);
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
             //titleMkr=[];
             //clearMarkers();
             //markers=[];
        }                           
    }
/********************************Stop Tracking**********************************/   
    function stopHistoryTracking(){
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
        refreshFlag=true;
        //titleMkr=[];
        clearMarkers();
        clearMovingMarkers();
        clearMap();
        //plotHistoryToMap('Both');
       }
/******************************remove markers and polylines******************************/ 
      
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
     function clearMap1(){
        //clearSimpleMarkers();
        removePolylineTrace();
        //removeBorder();
        removerichmarkers();
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
/***********************************end of remove markers and polylines***********************************/ 
var slider = document.getElementById("myRange");
slider.oninput = function() {
 sliderValue= this.value;
 if(running==true){
    if(sliderValue==0){
       clearInterval(timerval);
       timerval = window.setInterval("animate1()",1000);
    }else{
       clearInterval(timerval);
       timerval = window.setInterval("animate1()",(10000/sliderValue));
    }
  }
}
	</script>
</body>
</html>
