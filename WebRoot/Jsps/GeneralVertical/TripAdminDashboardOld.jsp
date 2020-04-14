<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int countryId = loginInfo.getCountryCode();
	int systemId = loginInfo.getSystemId();
	String countryName = cf.getCountryName(countryId);
	Properties properties = ApplicationListener.prop;
	String vehicleImagePath = properties.getProperty("vehicleImagePath");
	String unit = cf.getUnitOfMeasure(systemId);

%>
<jsp:include page="../Common/header.jsp" />

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Trip Dash Board</title>

	<!--  CSS -->
    <!-- Bootstrap Core CSS -->
    <link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- MetisMenu CSS -->
    <link href="../../Main/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<!--	<link href="../../Main/vendor/datatables/css/dataTables.bootstrap.min.css" rel="stylesheet">-->
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">

	<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />



	<!-- JS -->
	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
	<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>
    <!-- Metis Menu Plugin JavaScript -->
    <script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>
    <!-- Custom Theme JavaScript -->
    <script src="../../Main/dist/js/sb-admin-2.js"></script>
    <script src="../../Main/Js/markerclusterer.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>

	 <link rel="stylesheet" href="../../Main/fixedHeader/table-fixed-header.css">
    <script src="../../Main/fixedHeader/table-fixed-header.js"></script>
		<script src="https://unpkg.com/leaflet@1.0.2/dist/leaflet.js"></script>
		<link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
		<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
		<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
		<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
		<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
		<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

	<style>
		<!-- .row { -->
		    <!-- margin-right: -3px !important; -->
		    <!-- margin-left: -10px !important; -->
		<!-- } -->
		.row {
		    margin-right: 0px !important;
		    margin-left: 8px !important;
		}
		.panel-heading{
			padding-bottom: inherit !important;
    		padding-top: inherit !important;

		}
		.panel {
   	 		margin-bottom: 8px;
   	 	}
   	 	.label{
   	 		font-size: 15px;
   	 		color: white;
   	 		padding-left: 10px;
    		margin-left: -52px !important;
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
    		height: 22px !important;
    	}
    	div.dataTables_wrapper div.dataTables_length select{
    		height: 31px !important;
    	}
    	button, input, select, textarea{
    		font-size:13px !important;
    	}
		#tripSumaryTable tr td {
			height: 20px !important;
		}
		.btn-warning {
    		color: #fff;
   	 		background-color: #31708f;
    		border-color: #31708f;
    	}
    	#disclimer{
	    	padding-left: 3%;
		    font-size: 70%;
		    font-weight: 400;
		    color: #098282;
    	}
		.icons{
		margin-left:8px;
		}
		#page-loader{
		 position:fixed;
		 left: 0%;
		 top: 35%;
		 z-index: 1000;
		 width:100%;
		 height:100%;
		 background-position:center;
		 z-index:10000000;
		 opacity: 0.7;
		 filter: alpha(opacity=40);
		 }


		.col-lg-2 {
			width: 14.966667% !important;
		}

		modal-content {

		}
		.modal-header .close {
			margin-top: -26px !important;
			margin-right: -550px !important;
		}

		.fullscreen{
			border:2px solid black;
			position:fixed !important;
			left:0px;
			right:0px;
			top:0px;
			bottom:0px;
			height:100vh !important;
			z-index:0;
		}

		.searchStyle{
			z-index:100;top:24px;left:8px;position:fixed;
		}
		.searchStyleWand{
			z-index:100;top:24px;left:272px;position:fixed;
		}
		.showLabelStyle{
			z-index:100;bottom:32px;left:32px;position:fixed;background:#555555; color:white; padding:16px 40px;
		}

		.showFS{
			z-index:100;top:12px;right:30px;position:fixed;background:#c2b5b5; color:white; padding:8px 8px;
		}

		.showNotFS{
			margin-left:1200px;height:32px;padding-top:8px;border-radius:0px;position:absolute; top:8px;cursor:pointer;z-index:100000;
		}
		.blueGreyLight {background: #ECEFF1;}

   #myInfoDiv table tr td {
		 padding:4px;
   }

   .bringTop{
	   z-index:100 !important;
   }

   #select2-vehicleSearch-container{
    z-index:100 !important;
   }
.select2 {
	z-index:100 !important;
	top : 1px;
	left : 2px;
}


.leaflet-popup-content {
    margin: 0px;
    line-height: 1.4;
    height: 0px;
}

.leaflet-popup-content-wrapper, .leaflet-popup-tip {

    box-shadow:none !important;
		background: none;
}
.leaflet-control-fullscreen-button{display:none !important;}

	</style>

	<div id="wrapper" style=" width: 99%;">
    	<div id="page-wrapper" style="background-color: white;">
            <div class="panel panel-default">
                <div class="panel-heading" style="background-color: #fff; margin-bottom: 5px; font-weight: 700;  font-size: large;"> Alerts: Past 24hrs
               </div>

                <div class="row" hight= 72px;>
                	<div class="col-lg-2 col-md-6">
	                <a href="javascript:loadEvents('soc','SOC')">
	                    <div class="panel panel-orange">
	                        <div class="panel-heading">
	                            <div class="row">
 								  <div class="col-xs-3">
                                    	<img src="../../Main/resources/images/obd/STATE_OF_CHARGE_WHITE.png" style="height: 38px;">
	                                </div>
	                                <div class="col-xs-9 text-right">
	                                    <div class="huge" id="stateOfChargeId">0</div>
	                                    <div class ="label">SOC ( <30% )</div>
	                                </div>
	                            </div>
	                        </div>

	                    </div>
	                    </a>
	                </div>
	                <div class="col-lg-2 col-md-6">
	                <a href="javascript:loadEvents(2,'Overspeed')">
	                    <div class="panel panel-orange">
	                        <div class="panel-heading">
	                            <div class="row">
	                                <div class="col-xs-3">
	                                    	<img src="/ApplicationImages/VehicleImages/overspeed.png" style="width: 40px;">
	                                </div>

	                                <div class="col-xs-9	 text-right">
	                                    <div class="huge" id="boostId">0</div>
	                                    <div class ="label">Booster Mode</div>
	                                </div>
	                            </div>
	                        </div>

	                    </div>
	                    </a>
	                </div>
	                <div class="col-lg-2 col-md-6">
	                <a href="javascript:loadEvents(58,'Harsh Braking')">
	                    <div class="panel panel-orange">
	                        <div class="panel-heading">
	                            <div class="row">
	                                <div class="col-xs-3">
											<img src="/ApplicationImages/VehicleImages/harshbreak.png" style="margin-top: 5px;">
	                                </div>
	                                <div class="col-xs-9 text-right">
	                                    <div class="huge" id="hbId">0</div>
	                                    <div class ="label">Harsh Brake</div>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                    </a>
	                </div>
	                <div class="col-lg-2 col-md-6">
	                <a href="javascript:loadEvents('acStatus','acStatus')">
	                    <div class="panel panel-orange">
	                        <div class="panel-heading">
	                            <div class="row">
	                                <div class="col-xs-3">
	                                    <img src="/ApplicationImages/VehicleImages/AC.png" style="width: 40px;">
	                                </div>
	                                <div class="col-xs-9 text-right">
	                                    <div class="huge" id=acId>0</div>
	                                    <div class ="label">AC Status</div>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                    </a>
	                </div>

	                <div class="col-lg-2 col-md-6">
	            	<a href="javascript:loadEvents(7,'Device Tampering')">

	                    <div class="panel panel-orange">

	                        <div class="panel-heading">
	                            <div class="row">
	                                <div class="col-xs-3">
	                                    <i class="fa fa-power-off fa-2x" style="margin-top: 6px;"></i>
	                                </div>
	                                <div class="col-xs-9 text-right">
	                                    <div class="huge" id="mainPowerId">0</div>
	                                    <div class ="label">Device Tampering</div>
	                                </div>
	                                  </div>

	                                 </div>
	                                   </div>
	                                   </div> </a>

	                                   <div class="totalVehiclePanel" >
                    		                <h4 style="text-align: center;"><strong id="totalVehicle"> Total E-Vehicles :</strong></h4>
                    	               </div>
	                                     <div class="totalVehiclePanel">
                    		            <h4 style="text-align: center;"><strong id="commVehicle"> Communicating :</strong></h4>
                    	               </div>
                                      <div class="totalVehiclePanel">
                    		           <h4 style="text-align: center;"><strong id="noncommVehicle"> Non Communicating :</strong></h4>
                    	             </div>

	                     </div>
	                     <div  class="row" class="col-xs-3">
	                                  <div class="inline row" style="display:flex;margin-top:-9px;">
	                                 <div id="showLabelDiv" style="z-index:10000 !important;"><input type="checkbox" id="showLabels" style="z-index:10000 !important;margin-left: 12px;" onclick="showInfoWindowOne()"></input><span style="padding-left:11px;">Show Labels</span></div>


	                                 <select  onchange="searchVehicleOnMap()" style="width:250px; height:24px; position:absolute; top: 0;" id="vehicleSearch" class="newStyleSearch"
										required="required"></select>

						      </div>
						      </div>


	                </div>


            <div class="panel panel-default">
			<div class="col-md-12">
            	<div id="parentId" >


                <div class="col-md-10">
                        <div id="map" style="width:initial;height: 420px; margin-top: 0px;margin-left: -20px;margin-right: -250px ;"></div>
						<div id="page-loader" style="margin-top:10px;display:none;">
							<img src="../../Main/images/loading.gif" alt="loader" />
						</div>

					    </div>
                      <div class="showNotFS" id="compressDiv"  ><a onclick="fullscreen()" data-toggle="tab" heders=" " ><i class="fas fa-compress fa-2x"></i></a></div>
                   </div>
               </div>
			   </div>
            </div>

        </div>
        <!-- /#page-wrapper -->
    </div>
    <!-- /#wrapper -->

    <div id="add" class="modal fade" style="margin-right: 14%;">
        <div class="modal-dialog" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:1200px;height:100px;">
            <div class="modal-content" style="width : 96%">
                <div class="modal-header" >
					<div class="row">
						<div class="col-md-2">
							<div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline; margin-left:-250px">
								<h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>

							</div>
						</div>
						<div class="col-md-9">
						</div>
						<div class="col-md-1">
							<button type="button" class="close" style="align:right;" data-dismiss="modal" onclick="closeButton()">&times;</button>
						</div>
					</div>
					<div>

					</div>


				</div>
                <div class="modal-body" style="max-height: 50%;">
                    <div class="row">
                    	<div class="col-lg-12">
                    		<div class="col-lg-12" style="border: solid  1px lightgray;">
                        	<table id="criticalEventsTable"  class="table table-striped table-bordered" cellspacing="0">
			                	<thead>

			                         		<tr>
		                        		<th>#</th>
		                        		<th>E-Vehicle No</th>
		                        		<th>Location</th>
		                        		<th>Date</th>
		                        		<th>Communication Status</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-warning" data-dismiss="modal" onclick="closeButton()">Close</button>

                </div>
            </div>
        </div>
    </div>


    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg"></script>
	<script>

		var countryName = '<%=countryName%>';
      	var map;
      	var mcOptions = {gridSize: 20, maxZoom: 100};

		  var markerCluster, markerCluster1;
      	var markerClusterArray = [];
      	var markerClusterArray1 = [];
		var markerClusterVehicleArray = [];
      	var animate = "false";
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
      	var infoWindowOnes = [];
      	var groupId;
		var table;
		var endDatehid;
		var markers = {};
		var vehicleDetails = [];
		var infoWindowPrev ;
		var toggle = "hide";
		var currentOpenMarker;
		var currentOpenMarkerVehicle;
		var markerCluster;
		var searchVehicleNumber;
		var layerGroup;
<!--		var alertId;-->
<!--		var groupIdNew = 0;-->
		var loadVehicleCombo = false;

$(document).ready(function() {
	//$('#showLabelDiv').show();
});

function searchVehicleOnMap(){
	var vehicleNo = document.getElementById("vehicleSearch").value;
	markerCluster.clearLayers();
		if(vehicleNo == 'ALL'){
			count = 0;
			for (var i = 0; i < vehicleDetails.length; i++) {
				if (!vehicleDetails[i].latitude == 0 && !vehicleDetails[i].longitude == 0) {
					count++;
					plotSingleVehicleOutside(vehicleDetails[i].vehicleNo,vehicleDetails[i].latitude,vehicleDetails[i].longitude,
								vehicleDetails[i].location,vehicleDetails[i].gmt,vehicleDetails[i].category,
								vehicleDetails[i].imagePath,vehicleDetails[i].ignitionValue,vehicleDetails[i].speedValue);

				}
			}
		}else{
			count = 0;
			for (var i = 0; i < vehicleDetails.length; i++) {
				if (vehicleDetails[i].vehicleNo== vehicleNo && !vehicleDetails[i].latitude == 0 && !vehicleDetails[i].longitude == 0) {
					count++;
					plotSingleVehicleOutside(vehicleDetails[i].vehicleNo,vehicleDetails[i].latitude,vehicleDetails[i].longitude,
								vehicleDetails[i].location,vehicleDetails[i].gmt,vehicleDetails[i].category,
								vehicleDetails[i].imagePath,vehicleDetails[i].ignitionValue,vehicleDetails[i].speedValue);

				}
			}
		}
}

function plotSingleVehicleOutside(vehicleNo, latitude, longtitude, location, gmt, status, imagePath,ignition , speed) {
    layerGroup.clearLayers();
	imageurl = '<%=vehicleImagePath%>MapImages/car_BG4.png';
	image = L.icon({
			iconUrl: String("https://cdn4.iconfinder.com/data/icons/eldorado-transport/40/truck_1-512.png"),
			iconSize: [20, 40], // size of the icon
			popupAnchor: [0, -15]
	});
	var coordinate = latitude + ',' + longtitude;

	 var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; float: left; color: #000; line-height:100%; font-size:10px; font-family: sans-serif;padding:4px;">' +
	'<table>' +
	'<tr><td nowrap>E-Vehicle No:</td><td>' + vehicleNo + '</td></tr>' +
	'<tr><td nowrap>Location:</td><td></td<td>' + location + '</td></tr>' +
	'<tr><td nowrap>Last Comm:</td><td></td<td>' + gmt + '</td></tr>' +
	'<tr><td nowrap>Ignition: </td><td></td<td>' + ignition + '</td></tr>' +
	'<tr><td nowrap>Speed: </td><td></td<td>' + speed + '</td></tr>' +
	'obdInfo' +
	'</table>' +
	'</div>';
	contentOne = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +

	'<span style="height:2px">' + vehicleNo + '</span>' +

	'</div>';




	marker = new L.Marker(new L.LatLng(latitude, longtitude), {
			icon: image
	})
	.on('click', function(e) {
		$.ajax({
		url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleDiagnosticDeatails',
		data: {
			vehicleNo: e.target.vehicleNo
		},
		success: function(result) {

		pendingList = JSON.parse(result);

		var obdInfo = '';
		if(pendingList["vehicleDiagnosisDetailsRoot"].length > 0){
			for(var i = 0; i < pendingList["vehicleDiagnosisDetailsRoot"].length; i++){
				var temp;

				obdInfo += ' <tr><td nowrap>'+toCamelCase(pendingList["vehicleDiagnosisDetailsRoot"][i].paramName)+':</td>'+'<td>'+pendingList["vehicleDiagnosisDetailsRoot"][i].value+'</td></tr> ';
			}
			console.log("OBD INfois", obdInfo);
			var con = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; float: left; color: #000; line-height:100%; font-size:10px; font-family: sans-serif;padding:4px;">' +
		'<table>' +
		'<tr><td nowrap>E-Vehicle No:</td><td>' +  e.target.vehicleNo + '</td></tr>' +
		'<tr><td nowrap>Location:</td><td></td<td>' +  e.target.location + '</td></tr>' +
		'<tr><td nowrap>Last Comm:</td><td></td<td>' +  e.target.gmt + '</td></tr>' +
		'<tr><td nowrap>Ignition: </td><td></td<td>' +  e.target.ignition + '</td></tr>' +
		'<tr><td nowrap>Speed: </td><td></td<td>' +  e.target.speed + '</td></tr>' +
		obdInfo +
		'</table>' +
		'</div>';
		L.popup()
		.setLatLng(e.target.getLatLng())
		.setContent(con)
		.openOn(map);

			}
		}
		});
	})
	.bindTooltip(vehicleNo,
	{
		permanent: document.getElementById("showLabels").checked ? true: false,
		direction: 'right'
	})

	marker.vehicleNo = vehicleNo;
	marker.location = location;
	marker.gmt = gmt;
	marker.ignition = ignition;
	marker.speed = speed;
	marker.bindPopup(content);


	markerCluster.addLayer(marker);
	map.addLayer(markerCluster);
	markerClusterArray.push(marker);
	map.setView(new L.LatLng(latitude, longtitude),7);

}

		loadData();
      	function loadData(){
      		loadCount();
      		function loadCount(){
      		$.ajax({
			url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCriticalAlert",
		    "dataSrc": "vehicleCount",
		    success: function(result){
		    	results = JSON.parse(result);

	    		$("#mainPowerId").text(results["criticalEvents"][0].mainPower);
	    			      	$("#stateOfChargeId").text(results["criticalEvents"][0].stateOfChargeLessCount);
		      	$("#hbId").text(results["criticalEvents"][0].harshBrake);
		      	$("#hcId").text(results["criticalEvents"][0].harshCurve);
		      	$("#acId").text(results["criticalEvents"][0].acOnCount);
		      	$("#engineErrorId").text(results["criticalEvents"][0].engineError);
		      	$("#boostId").text(results["criticalEvents"][0].boostCount);
		    }

			});



			$.ajax({
		    	url: "<%=request.getContextPath()%>/LTSPAction.do?param=getCommNonCommunicatingVehicles",
		    	"dataSrc": "vehicleCount",
		    	success: function(result){
		    		results = JSON.parse(result);
		    		console.log("results ::: ******" + result);
		   			$('#totalVehicle').text("Total Vehicles : "+results["DashBoardElementCountRoot"][0].totalAssetCount);
					$('#commVehicle').text("Communicating: "+results["DashBoardElementCountRoot"][0].commCount);
					$('#noncommVehicle').text("Non Communicating : "+results["DashBoardElementCountRoot"][0].nonCommCount);
	        	}
	        });
      		}

      	// ************* Map Details
		function initialize(){
    //   	var mapOptions = {
	  //       zoom:8,
	  //       center: new google.maps.LatLng('0.0', '0.0'),
	  //       mapTypeId: google.maps.MapTypeId.ROADMAP,
	  //       mapTypeControl: false,
	  //       gestureHandling: 'greedy',fullscreenControl:false
	  //   };
	  //  	map = new google.maps.Map(document.getElementById('map'), mapOptions);
		//
	  //  	var geocoder = new google.maps.Geocoder();
		// geocoder.geocode({'address': countryName}, function(results, status) {
		//
		// });

		var osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
				maxZoom: 14,
				attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
		});

		map = new L.Map("map", {
				fullscreenControl: {
						pseudoFullscreen: false,
						fullscreen:false
				},
				center: new L.LatLng('21.146633', '79.088860'),
				zoom: 5
		});

		L.control.layers({
				"OSM": osm
		}, null, {
				collapsed: false
		}).addTo(map);
		osm.addTo(map);
		}

		initialize();

		 function loadMap() {

        	infoWindows = [];
        	infoWindowOnes = [];
        	markerClusterArray = [];
        	markerClusterArray1 = [];
			getMapViewVehicles();

			}
		loadMap();

		function getMapViewVehicles (){
		var results = "";
		$.ajax({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getMapViewVehicles',
			    "dataSrc": "MapViewVehicles",
			    success: function(result){


			    //	var bounds = new google.maps.LatLngBounds();

			    	results = JSON.parse(result);
			    	vehicleDetails = results["MapViewVehicles"];

					var count = 0;
      		if( $('#vehicleSearch').has('option').length == 0 ) {
						$('#vehicleSearch').append($("<option></option>").attr("value","ALL").text('ALL'));
              			loadVehicleCombo = true;
              		}else{
						loadVehicleCombo =false;
					}
                   layerGroup.clearLayers();
					if (markerCluster) {
							map.removeLayer(markerCluster);
					}
					markerCluster = L.markerClusterGroup();
					if (markerCluster1) {
							map.removeLayer(markerCluster1);
					}
					markerCluster1 = L.markerClusterGroup();

					for (var i = 0; i < results["MapViewVehicles"].length; i++) {
						var counts=results["MapViewVehicles"].length;
						if (!results["MapViewVehicles"][i].latitude == 0 && !results["MapViewVehicles"][i].longitude == 0) {
							count++;

							plotSingleVehicle(results["MapViewVehicles"][i].vehicleNo,results["MapViewVehicles"][i].latitude,results["MapViewVehicles"][i].longitude,
										results["MapViewVehicles"][i].location,results["MapViewVehicles"][i].gmt,results["MapViewVehicles"][i].category,
										results["MapViewVehicles"][i].imagePath,results["MapViewVehicles"][i].ignitionValue,results["MapViewVehicles"][i].speedValue,counts);

							if( loadVehicleCombo == true) {

								$('#vehicleSearch').append($("<option></option>").attr("value", results["MapViewVehicles"][i].vehicleNo).text(results["MapViewVehicles"][i].vehicleNo));
								$('#vehicleSearch').select2();
							}
						}
					}


				}
			});
		}
		layerGroup = new L.LayerGroup().addTo(map);
		function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, status, imagePath,ignition , speed,counts) {

			imageurl = '<%=vehicleImagePath%>MapImages/car_BG4.png';
			image = L.icon({
	        iconUrl: String("https://cdn4.iconfinder.com/data/icons/eldorado-transport/40/truck_1-512.png"),
	        iconSize: [20, 40], // size of the icon
	        popupAnchor: [0, -15]
	    });
	    var coordinate = latitude + ',' + longtitude;

			 var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; float: left; color: #000; line-height:100%; font-size:10px; font-family: sans-serif;padding:4px;">' +
			'<table>' +
			'<tr><td nowrap>E-Vehicle No:</td><td>' + vehicleNo + '</td></tr>' +
			'<tr><td nowrap>Location:</td><td></td<td>' + location + '</td></tr>' +
			'<tr><td nowrap>Last Comm:</td><td></td<td>' + gmt + '</td></tr>' +
			'<tr><td nowrap>Ignition: </td><td></td<td>' + ignition + '</td></tr>' +
			'<tr><td nowrap>Speed: </td><td></td<td>' + speed + '</td></tr>' +
			'obdInfo' +
			'</table>' +
			'</div>';
			contentOne = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +

			'<span style="height:2px">' + vehicleNo + '</span>' +

			'</div>';




			marker = new L.Marker(new L.LatLng(latitude, longtitude), {
					icon: image
			})
			.on('click', function(e) {
				$.ajax({
				url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleDiagnosticDeatails',
				data: {
					vehicleNo: e.target.vehicleNo
				},
				success: function(result) {

				pendingList = JSON.parse(result);

				var obdInfo = '';
				if(pendingList["vehicleDiagnosisDetailsRoot"].length > 0){
					for(var i = 0; i < pendingList["vehicleDiagnosisDetailsRoot"].length; i++){
						var temp;

						obdInfo += ' <tr><td nowrap>'+toCamelCase(pendingList["vehicleDiagnosisDetailsRoot"][i].paramName)+':</td>'+'<td>'+pendingList["vehicleDiagnosisDetailsRoot"][i].value+'</td></tr> ';
					}
					console.log("OBD INfois", obdInfo);
					var con = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; float: left; color: #000; line-height:100%; font-size:10px; font-family: sans-serif;padding:4px;">' +
	 			'<table>' +
	 			'<tr><td nowrap>E-Vehicle No:</td><td>' +  e.target.vehicleNo + '</td></tr>' +
	 			'<tr><td nowrap>Location:</td><td></td<td>' +  e.target.location + '</td></tr>' +
	 			'<tr><td nowrap>Last Comm:</td><td></td<td>' +  e.target.gmt + '</td></tr>' +
	 			'<tr><td nowrap>Ignition: </td><td></td<td>' +  e.target.ignition + '</td></tr>' +
	 			'<tr><td nowrap>Speed: </td><td></td<td>' +  e.target.speed + '</td></tr>' +
	 			obdInfo +
	 			'</table>' +
	 			'</div>';
				L.popup()
				.setLatLng(e.target.getLatLng())
				.setContent(con)
				.openOn(map);

					}
				}
				});
			})
			.bindTooltip(vehicleNo,
    	{
        permanent: document.getElementById("showLabels").checked ? true: false,
        direction: 'right'
    	})

			marker.vehicleNo = vehicleNo;
			marker.location = location;
			marker.gmt = gmt;
			marker.ignition = ignition;
			marker.speed = speed;
			marker.bindPopup(content);

         if(counts>50){
			markerCluster.addLayer(marker);
			map.addLayer(markerCluster);
			markerClusterArray.push(marker);
		 }else{
			 marker.addTo(layerGroup);
			 map.setView(new L.LatLng(latitude, longtitude),11);
		 }

		}

      	// ************ Table for Trip Summary
      	$('#groupName').change(function() {
	         groupId = $('#groupName option:selected').attr('id');
	         loadTable();
	    });
		loadTable();
		function loadTable(){
			groupId = $('#groupName option:selected').attr('id');
			table = $('#tripSumaryTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetails",
		            "dataSrc": "tripSummaryDetails",
					"data": {
						groupId: groupId,
						unit:'<%=unit%>'
					}
		        },
		        "bDestroy": true,
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    				},

	        	"lengthChange":true,

	        	"dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				exportOptions: {
				                columns: [0,2,3,4,5,6,7,8,9,10,11]
				            }},'colvis'
        	 				],
        	 	columnDefs: [
		            { width: 200, targets: 5 },
		            { width: 200, targets: 6 },
		            { width: 100, targets: 9 }
		        ],
		        fixedColumns: true,
		        "columns": [{
		        		"data": "slNo"
		        	}, {
		                "data": "tripNo"
		            }, {
		                "data": "tripName"
		            }, {
		                "data": "vehicleNo"
		            }, {
		                "data": "routeName"
		            }, {
		                "data": "startLocation"
		            }, {
		                "data": "currentLocation"
		            }, {
		                "data": "plannedDate"
		            }, {
		                "data": "actualDate"
		            }, {
		                "data": "distanceTravelled"
		            }, {
		                "data": "events"
		            },{
		            	"data": "status"
		            },{
		            	"data": "endDateHidden"
		            }]
 			});
 			table.column( 1 ).visible( false );
			table.column( 12 ).visible( false );
		}

 		$('#tripSumaryTable tbody').on('click', 'tr', function() {
        	var data = table.row( this ).data();
            tripNo = (data['tripNo']);
            vehicleNo = (data['vehicleNo']);
            startDate = (data['plannedDate']);
            endDate = (data['endDateHidden']);
            status = (data['status']);
            actualDate = (data['actualDate']);
<!--            var today = new Date();-->
<!--			var dd = today.getDate();-->
<!--			var mm = today.getMonth()+1; //January is 0!-->
<!--			var hh = today.getHours();-->
<!--			var MM = today.getMinutes();-->
<!--			var ss = today.getSeconds();-->
<!---->
<!--			var yyyy = today.getFullYear();-->
<!--			if(dd<10){-->
<!--    			dd='0'+dd;-->
<!--			} -->
<!--			if(mm<10){-->
<!--    			mm='0'+mm;-->
<!--			} -->
<!--			var endDate = dd+'/'+mm+'/'+yyyy+' '+hh+':'+MM+':'+ss;-->
	window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=6&status=" + status + "&actual=" + actualDate  , '_blank');
            event.preventDefault();
        });
        setInterval( function () {
      			loadCount();
      			//loadMap();


   				//$('#tripSumaryTable').DataTable().ajax.reload();
		}, 30000);	// 30 sec interval
	   }
		var tableNew;
		var groupIdNew;
		function loadEvents(alertId,alertName){
			$('#showLabelDiv').hide();
			$(".modal-header #tripEventsTitle").text(alertName);
			$('#add').modal('show');

			loadTableNew(alertId,groupIdNew);

      	}

      	function loadTableNew(alertId,groupIdNew){
		    	 tableNew = $('#criticalEventsTable').DataTable({
			      	"ajax": {
			        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCriticalEventsDetails",
			            "dataSrc": "criticalEventsDetails",
						"data": {
							alertId: alertId,
							groupId: 0
						}
			        },
			        "bDestroy": true,
			        "processing": true,
			        "scrollY": '50vh',
			        "title": "adadadadsa",
			        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    				},
			        "columns": [{
			        		"data": "slNoIndex"
			        	}, {
			                "data": "vehicleNoIndex"
			            }, {
			                "data": "locationIndex"
			            }, {
			                "data": "dateTimeIndex"
			            }, {
			                "data": "CommStatusIndex"
			            }],
			    });

			    $('#criticalEventsTable').closest('.dataTables_scrollBody').css('max-height', '400px');
			    if(alertId == 'soc') {
        	tableNew.column( 4 ).visible( true );
        	}else{
        	tableNew.column( 4 ).visible( false );

        }


			}

			function getVehicleDiagnostic(vehicleNo){
			 document.getElementById("page-loader").style.display="block";


			$("#tripId").fadeOut("slow");
			$("#alertId").fadeIn("slow");
			$("#tripId").hide();
			$("#alertId").show();
				  //Alert Details
   	  		$.ajax({
        	url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleDiagnosticDeatails',
        	data: {
        		vehicleNo: vehicleNo
        	},
        	success: function(result) {
			 document.getElementById("page-loader").style.display="none";

            	pendingList = JSON.parse(result);
            	if(pendingList["vehicleDiagnosisDetailsRoot"].length > 0){

					  jQuery('#obdDataBodyId tr').html('');
            		for(var i = 0; i < pendingList["vehicleDiagnosisDetailsRoot"].length; i++){

						var temp;

						 if(pendingList["vehicleDiagnosisDetailsRoot"][i].color=='icon-green')
						 temp =  '<img src="../../Main/resources/images/obd/'+pendingList["vehicleDiagnosisDetailsRoot"][i].id+'.png" class="icons"  alt="user">'  ;
						else if(pendingList["vehicleDiagnosisDetailsRoot"][i].color=='icon-red')
						temp =	' <img src="../../Main/resources/images/obd/'+pendingList["vehicleDiagnosisDetailsRoot"][i].id+'_red.png" class="icons"  alt="user">'




						var tbody = document.getElementById('obdDataBodyId');
						var row = document.createElement("tr");
						row.style.fontFamily = 'Helvetica Neue", Helvetica, Roboto, Arial, sans-serif';
						row.innerHTML += ' <td>'+temp+'</td><td>:</td><td>'+pendingList["vehicleDiagnosisDetailsRoot"][i].paramName+'</td> <td>:</td> '+
						'<td>'+pendingList["vehicleDiagnosisDetailsRoot"][i].value+'</td> ';
						tbody.appendChild(row);


           			}
            	}else{

					sweetAlert("Please Specify the Model for this Vehicle");
            	}
        	}
    		});
			 document.getElementById("page-loader").style.display="block";

			}
			function clearDiv(){
			$("#tripId").fadeIn("slow");
			$("#alertId").fadeOut("slow");
			$("#tripId").show();
			$("#alertId").hide();

			}

			function showInfoWindowOne(){
				if(document.getElementById("showLabels").checked){
					map.eachLayer(function(l) {
            if (l.getTooltip()) {
                var tooltip = l.getTooltip();
                l.unbindTooltip().bindTooltip(tooltip, {
                    permanent: true
                })
            }
          });
					var vehicleNoSearch = document.getElementById("vehicleSearch").value;
					if(vehicleNoSearch == 'ALL'){
						for(var i=0; i< vehicleDetails.length;i++){
							infowindowId = vehicleDetails[i].vehicleNo;
							infoWindowOnes[infowindowId].open(map, markers[infowindowId]);
							infowindowOne.setContent(contentOne);
						}
					}else{

						for(var i=0; i< vehicleDetails.length;i++){
							if(vehicleDetails[i].vehicleNo == vehicleNoSearch){
								infowindowId = vehicleDetails[i].vehicleNo;
								infoWindowOnes[infowindowId].open(map, markers[infowindowId]);
								infowindowOne.setContent(contentOne);
								break;
							}
						}
					}
				}else{
					map.eachLayer(function(l) {
            if (l.getTooltip()) {
                var tooltip = l.getTooltip();
                l.unbindTooltip().bindTooltip(tooltip, {
                    permanent: false
                })
            }
        	})
				}
			}

			function clearSearchVehicleOnMap(){
				document.getElementById("vehicleSearch").value = '';
				$("vehicleSearch").val("");
				searchVehicleOnMap();
			}



	function fullscreen()
    {
			$(".leaflet-control-fullscreen-button").hide();
		if($("#map").hasClass("fullscreen"))
		{
			$("#map").removeClass("fullscreen");
			$("#vehicleSearch").removeClass("searchStyle");
			$("#vehicleSearchBtn").removeClass("searchStyleWand");
			$("#showLabelDiv").removeClass("showLabelStyle");
			$("#compressDiv").addClass("showNotFS");
			$("#compressDiv").removeClass("showFS");



		}
		else{
			$("#compressDiv").removeClass("showNotFS");
			$("#compressDiv").addClass("showFS");
			$("#map").addClass("fullscreen");
			$("#vehicleSearch").addClass("searchStyle");
			$("#vehicleSearchBtn").addClass("searchStyleWand");
			$("#showLabelDiv").addClass("showLabelStyle");
		}



      if(toggle == "hide")
      {
        toggle = "show";
        $( "#leftColumn" ).hide();
        $( "#rightColumn" ).hide();
        $( "#leftColumn" ).removeClass("col-lg-2");
        $( "#rightColumn" ).removeClass("col-lg-2");
        $( "#midColumn" ).removeClass("col-lg-8").addClass("col-lg-12");
    }
      else {
        toggle = "hide";
        $( "#midColumn" ).removeClass("col-lg-12").addClass("col-lg-8");
        $( "#leftColumn" ).addClass("col-lg-2");
        setTimeout(function(){$( "#leftColumn" ).fadeIn();$( "#rightColumn" ).addClass("col-lg-2");$( "#rightColumn" ).fadeIn();},600);
      }

    }

	function toCamelCase(str){
	  return str.split(' ').map(function(word,index){
	   // If it is not the first word only upper case the first char and lowercase the rest.
		return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
	  }).join(' ');
	}
	function closeButton (){
		$('#showLabelDiv').show();
	}
	</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
