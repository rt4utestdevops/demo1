<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

if(loginInfo != null){
			}
else
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");

 }
%>
<jsp:include page="../Common/header.jsp" />

    <link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <link href="../../Main/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
	<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>

	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
	<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>

    <script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>

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
	<script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>

	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>

<style>
    .custom {
        padding-left: 15px;
        padding-right: 15px;
        margin-left: auto;
        margin-right: auto;
        padding-top: 10px;
    }
    .panel {
        margin-bottom: 20px;
        background-color: #fff;
        <!-- border: 1px solid #333 !important;
        --> border-radius: 4px;
        -webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
        box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
    }
    .badge {
        display: inline-block;
        min-width: 10px;
        padding: 3px 4px;
        margin-top: -7px;
        margin-left: -15px;
        font-size: 20px !important;
        line-height: 1;
        color: #d40b0b;
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        background-color: #fff !important;
        border-radius: 20px !important;
        border: solid 1px rgba(0, 0, 0, .25);
    }
    #alertPanel {
        background-color: rgba(0, 0, 0, .25);
        border: solid 1px rgba(0, 0, 0, .25);
        cursor:pointer;
    }
    #alertRow {
        background-color: #eee;
        margin-left: 0%;
        margin-left: 0%;
    }
    .panel-body {
        padding: 10px !important;
    }
    .col-md-2 {
        width: 19.999% !important;
    }
		#example_wrapper {
 	 margin-top: 50px !important;
        border: solid 1px rgba(0, 0, 0, .25);
        padding: 1%;
        box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
    }
    .modal {
         position: fixed;
         top: 5%;
         left: 20%;
         z-index: 1050;
         width: 80%;
         margin-left: -280px;
         background-color: #ffffff;
         border: 1px solid #999;
         border: 1px solid rgba(0, 0, 0, 0.3);
         -webkit-border-radius: 6px;
         -moz-border-radius: 6px;
         border-radius: 6px;
         -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         -webkit-background-clip: padding-box;
         -moz-background-clip: padding-box;
         background-clip: padding-box;
         outline: none;
         }
        .dataTables_length{
          display:none;
        }
        #add{
         	margin-right: 2%;
    		margin-left: -124px;
    		height: 95%;
    		width: 80%;
    		display: block;
    		padding-right: 0px !important;
        }

      #page-loader{
	  position:fixed;
	  left: 50%;
	  top: 35%;
	  z-index: 1000;
	  width:100%;
	  height:100%;
	  background-position:center;
	  z-index:10000000;
	  opacity: 0.7;
	  filter: alpha(opacity=40); /* For IE8 and earlier */
	}
	.tabs-container{
		margin-top:360px;
	}

	.tabs-container .nav{
		float: left;
		margin-left: 10px;
		margin-right: 20px;
		margin-top: -50px;
	}
</style>

	<div class="custom">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title" >
                     SMART TRUCKER BEHAVIOUR
                  </h3>
			</div>
			<div id="panelBodyID" class="panel-body">
				<div class=" row">
					<div class="col-md-4 col-sm-10" style="margin-left: 12%; border: solid 1px rgba(0,0,0,.25);margin-top:0.7%;    box-shadow: 0 1px 1px rgba(0,0,0,.25);">
						<h4 style=" text-align: center;    font-weight: 600;"  ><span id="headerCount1">0 </span>/<span id="totalTrip1">0</span></h4>
						<h3 style="text-align: center;    margin-top: 0px;font-weight: 600;    color: #3ac519"> Eligible for incentives today</h3>
					</div>
					<div class="col-md-4 col-sm-10" style="margin-left: 5%;">
						<h4 style="  border: solid 1px rgba(0,0,0,.25); padding: 5px;     box-shadow: 0 1px 1px rgba(0,0,0,.25);">
							<span style="font-weight: 500;color: #3ac519">On-Time Performance <i style="font-size:13px">(Last 24 hours)</i>
							</br>
							<span style="color:red;font-size:10px;">**On-Time Trips/Total Trips created in the last 24 hours</span></span>
							<span style="float: right;    font-weight: 600;"  ><span id="headerCount2">0 </span>/<span id="totalTrip2">0</span></span>
						</h4>
						<h4 style="border: solid 1px rgba(0,0,0,.25); padding: 5px;    box-shadow: 0 1px 1px rgba(0,0,0,.25); ">
							<span style="font-weight: 500;color: #3ac519">  Mileage </span>
							<span style="float: right;    font-weight: 600;"  ><span id="headerCount3">0 </span>/<span id="totalTrip3">0</span></span>
						</h4>
					</div>
				</div>
				 <div id="page-loader" style="display:none;">
				<img src="../../Main/images/loading.gif" alt="loader" />
				</div>

				<!-- end of top row -->
				</br>
				</br >
				<div style="color:red">
				<i class="fa fa-exclamation-circle" aria-hidden="true"></i>**The alerts below are derived for the last 1 hour. The counts represent Acknowledged/Total Alerts generated in the last 1 hour.
				</div>
				<div id="alertRow" class="row" style="margin-right:14px;margin-top:1%;padding-top:1.5%;">
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(2,'Over Speeding','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Over Speeding </h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
								<h3 class="badge">
									<span id="remarkedalertCountId1" >0</span>/<span id="alertCountId1" >0</span>
								</h3>
							</span>
							</div>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(58,'Harsh Breaking','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Harsh Braking </h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
								<h3 class="badge">
									<span id="remarkedalertCountId2" >0</span>/<span id="alertCountId2" >0</span>
								</h3>
							</span>
							</div>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(105,'Harsh  Acceleration','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Harsh Acceleration </h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId3" >0</span>/<span id="alertCountId3" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(106,'Harsh  Cornering','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Harsh  Cornering </h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId4" >0</span>/<span id="alertCountId4" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(93,'Free Wheeling','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Free Wheeling </h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId5" >0</span>/<span id="alertCountId5" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end of first row -->

				<div id="alertRow" class="row" style="margin-right:14px;padding-top:1.5%;">
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(194,'Low/High RPM','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Low/High RPM</h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId6" >0</span>/<span id="alertCountId6" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(5,'Route  Deviation','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Route Deviation</h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId7" >0</span>/<span id="alertCountId7" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(1,'Unauthorized stoppages','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Unauthorized Stoppages</h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId8" >0</span>/<span id="alertCountId8" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadNonRemarksEvents('On-time Performance')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> On-Time Performance</h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="alertCountId9" >0</span>/<span id="totalAlertCount">0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="panel" style="width: 200px">
							<div class="panel-body" id="alertPanel" onclick="loadEvents(195,'Low Mileage','')">
								<span class="col-sm-12 col-md-9 col-lg-9">
									<h4> Low <br>Mileage</h4>
								</span>
								<span class="col-sm-12 col-md-3 col-lg-3">
									<h3 class="badge">
										<span id="remarkedalertCountId10" >0</span>/<span id="alertCountId10" >0</span>
									</h3>
								</span>
							</div>
						</div>
					</div>
				</div>

				<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
						    <th>SL NO.</th>
							<th>DRIVER NAME</th>
							<th>CONTACT</th>
							<th>TOTAL ALERTS</th>
							<th>OVER SPEEDING</th>
							<th>HARSH BRAKING</th>
							<th>HARSH ACCELERATION</th>
							<th>HARSH CORNERING</th>
							<th>FREEWHEELING</th>
							<th>INCORRECT GEAR USAGE</th>
							<th>ROUTE DEVIATION</th>
							<th>STOPPAGES</th>
							<th>ON-TIME PERFORAMANCE</th>
							<th>LOW MILEAGE</th>
							<th>VEHICLE NUMBER</th>
							<th>DRIVER ID</th>
						</tr>
					</thead>
				</table>
			</div>  <!-- end of panel body-->
		</div>  <!-- end of primary panel -->
		</div> <!-- end of custom -->
		 <div id="add" class="modal fade" style="height:540px;margin-top:75px;">
         <div class="modal-content">
            <div class="modal-header" >

               <div class="secondLine" style="display:flex; width:100%; justify-content:space-between; align-items:baseline;">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
									<button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>

							 </div>
            </div>
            <div class="modal-body">
               <div class="row">
                  <div class="col-lg-12">
                     <div class="col-lg-12" style="border: solid  1px lightgray;height: 365px;">
                        <table id="alertEventsTable"  class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                           <thead>
                              <tr>
                                 <th>SL NO.</th>
                                 <th>VEHICLE NO</th>
                                 <th>LOCATION</th>
                                 <th>DATE</th>
                                 <th>REMARKS</th>
                                 <th>ACTION TAKEN</th>
                              </tr>
                           </thead>
                        </table>
                     </div>
                  </div>
               </div>
            </div>
            <div class="modal-footer"  style="text-align: right;" >
               <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px;">Close</button>
            </div>
         </div>
      </div>




<script type="text/javascript">
//history.pushState({ foo: 'fake' }, 'Fake Url', 'SmartTrukerBehaviour#');
var groupId=0;
var table;

$(document).ready(function() {
loadAlert();loadAlertRemarked();
});


 		if ($.fn.DataTable.isDataTable('#example')) {
           $('#example').DataTable().destroy();
       	}

function loadAlert(){
 document.getElementById("page-loader").style.display="block";
var smartTruckerBehaviorList;
		$.ajax({
		type: "POST",
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckAlertCount',
          success: function(result) {
           document.getElementById("page-loader").style.display="none";
                   smartTruckerBehaviorList = JSON.parse(result);
				    for (var i = 0; i < smartTruckerBehaviorList["alertCountRoot"].length; i++) {
				var header1=smartTruckerBehaviorList["alertCountRoot"][i].incentiveCount;
				var header2=smartTruckerBehaviorList["alertCountRoot"][i].onTimeCount1;
				var header3=smartTruckerBehaviorList["alertCountRoot"][i].mileageCount;
				var totalTrip=smartTruckerBehaviorList["alertCountRoot"][i].totalTrip1;
				var totalTripAlert=smartTruckerBehaviorList["alertCountRoot"][i].totalTrip2;
				var alertCount1=smartTruckerBehaviorList["alertCountRoot"][i].overSpeedCount;
				var alertCount2=smartTruckerBehaviorList["alertCountRoot"][i].hbCount;
				var alertCount3=smartTruckerBehaviorList["alertCountRoot"][i].haCount;
				var alertCount4=smartTruckerBehaviorList["alertCountRoot"][i].hcCount;
				var alertCount5=smartTruckerBehaviorList["alertCountRoot"][i].freeWheelCount;
				var alertCount6=smartTruckerBehaviorList["alertCountRoot"][i].incorrectCount;
				var alertCount7=smartTruckerBehaviorList["alertCountRoot"][i].routeDeviatonCount;
				var alertCount8=smartTruckerBehaviorList["alertCountRoot"][i].stoppageCount;
				var alertCount9=smartTruckerBehaviorList["alertCountRoot"][i].onTimeCount2;
				var alertCount10=smartTruckerBehaviorList["alertCountRoot"][i].lowMileage;

				 document.getElementById('totalTrip1').innerHTML=totalTrip;
				 document.getElementById('totalTrip2').innerHTML=totalTrip;
			//	 document.getElementById('totalTrip3').innerHTML=totalTrip;
				 document.getElementById('headerCount1').innerHTML = header1;
				 document.getElementById('headerCount2').innerHTML = header2;
				 document.getElementById('headerCount3').innerHTML = header3;

				 document.getElementById('alertCountId1').innerHTML = alertCount1;
				 document.getElementById('alertCountId2').innerHTML = alertCount2;
				 document.getElementById('alertCountId3').innerHTML = alertCount3;
				 document.getElementById('alertCountId4').innerHTML = alertCount4;
				 document.getElementById('alertCountId5').innerHTML = alertCount5;
				 document.getElementById('alertCountId6').innerHTML = alertCount6;
				 document.getElementById('alertCountId7').innerHTML = alertCount7;
				 document.getElementById('alertCountId8').innerHTML = alertCount8;
				 document.getElementById('alertCountId9').innerHTML = alertCount9;
				 document.getElementById('alertCountId10').innerHTML = alertCount10;
				 document.getElementById('totalAlertCount').innerHTML = totalTripAlert;


			}

			}

			 });

	 $('#add').modal('show');
	 $('#add').modal('hide');

	 loadTable();
	 // document.getElementById("page-loader").style.display="none";
}

function loadAlertRemarked(){

 document.getElementById("page-loader").style.display="block";
var smartTruckerBehaviorList;
		$.ajax({
		type: "POST",
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckAlertCountRemarked',
          success: function(result) {
           document.getElementById("page-loader").style.display="none";
                   smartTruckerBehaviorList = JSON.parse(result);
				    for (var i = 0; i < smartTruckerBehaviorList["alertCountRemarkedRoot"].length; i++) {
				var header1=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].incentiveCount;
				var header2=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].onTimeCount1;
				var header3=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].mileageCount;
				var totalTrip=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].totalTrip1;
				//var totalTripAlert=smartTruckerBehaviorList["alertCountRoot"][i].totalTrip2;
				var alertCount1=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].overSpeedCount;
				var alertCount2=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].hbCount;
				var alertCount3=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].haCount;
				var alertCount4=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].hcCount;
				var alertCount5=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].freeWheelCount;
				var alertCount6=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].incorrectCount;
				var alertCount7=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].routeDeviatonCount;
				var alertCount8=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].stoppageCount;
				//var alertCount9=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].onTimeCount2;
				var alertCount10=smartTruckerBehaviorList["alertCountRemarkedRoot"][i].lowMileage;

				 // document.getElementById('totalTrip1').innerHTML=totalTrip;
				// document.getElementById('totalTrip2').innerHTML=totalTrip;
				// document.getElementById('totalTrip3').innerHTML=totalTrip;
				 //document.getElementById('headerCount1').innerHTML = header1;
				// document.getElementById('headerCount2').innerHTML = header2;
				// document.getElementById('headerCount3').innerHTML = header3;

				 document.getElementById('remarkedalertCountId1').innerHTML = alertCount1;
				 document.getElementById('remarkedalertCountId2').innerHTML = alertCount2;
				 document.getElementById('remarkedalertCountId3').innerHTML = alertCount3;
				 document.getElementById('remarkedalertCountId4').innerHTML = alertCount4;
				 document.getElementById('remarkedalertCountId5').innerHTML = alertCount5;
				 document.getElementById('remarkedalertCountId6').innerHTML = alertCount6;
				 document.getElementById('remarkedalertCountId7').innerHTML = alertCount7;
				 document.getElementById('remarkedalertCountId8').innerHTML = alertCount8;
				 //document.getElementById('remarkedalertCountId9').innerHTML = alertCount9;
				 document.getElementById('remarkedalertCountId10').innerHTML = alertCount10;
			}
		}
	});
}

function loadTable(){

 		 groupId = $('#groupName option:selected').attr('id');
 		 grouplabel = $('#groupName option:selected').attr('value');
 		 if(groupId === undefined){
 		    groupId=0;
 		 }
 		 if(grouplabel === undefined){
 		    grouplabel='Last 48 Hours';
 		 }

         table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=smartTruckerDetails",
                "dataSrc": "smartTruckerDetails",
                "data": {
					groupId: groupId,
               }
            },
            "bDestroy": true,
            "bLengthChange": false,
            "responsive": true,
            "lengthChange":true,
	        // "dom": 'Bfr<"toolbar">tip',
	       	"dom":  "<'row'<'col-sm-4 'B><'col-sm-3'><'col-sm-2 text-right'<'toolbar'>><'col-sm-2'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
        	"buttons": [{extend:'pageLength'},
        				{extend:'excel',
        				messageTop: 'The Excel sheet Contains '+grouplabel+' Data. ',
        	 				exportOptions: {
				                columns: [0,1,2,3,4,5,6,7,10,11]
				            }}
        	 ],
            "columns": [{
                "data": "slno"
            }, {
                "data": "driverName"
            }, {
                "data": "contact"
            }, {
                "data": "totalAlert"
            }, {
                "data": "overSpeedCount"
            }, {
                "data": "hbCount"
            }, {
                "data": "haCount"
            }, {
                "data": "hcCount"
            }, {
                "data": "freeWheelCount"
            }, {
                "data": "incorrectCount"
            }, {
                "data": "routeDeviatonCount"
            }, {
                "data": "stoppageCount"
            }, {
                "data": "onTimeCount2"
            }, {
                "data": "lowMileage"
            }, {
                "data": "vehicleNumber"
            }, {
                "data": "driverId"
            }]

        });


        $("div.toolbar").html('<select name="size" id="groupName" onchange="loadTable()" class="form-control"><option value="Last 48 Hours" id="0">Last 48 Hours</option><option  value="Last 7 days" id="1">Last 7 days</option><option value="Last 1 month" id="2">Last 1 month</option></select>');

 		 $('#groupName').val(grouplabel).attr("selected", "selected");
				 table.column(8).visible( false );
				 table.column(9).visible( false );
 				 table.column(12).visible( false );
			     table.column(13).visible( false );
			     table.column(14).visible( false );
			     table.column(15).visible( false );
 // document.getElementById("page-loader").style.display="none";
  var driverId;
  $('#example').on('click','td',function (event) {
    	event.preventDefault();
    	event.stopPropagation();
    	var columnIndex = table.cell( this ).index().column;
    	   var aPos = $('#example').dataTable().fnGetPosition(this);
    		var data = $('#example').dataTable().fnGetData(aPos[0]);
       		var overSpeedCount = (data['overSpeedCount']);
       		var hbCount = (data['hbCount']);
       		var haCount = (data['haCount']);
       		var hcCount = (data['hcCount']);
       		var routeDeviatonCount = (data['routeDeviatonCount']);
       		var stoppageCount = (data['stoppageCount']);
       		 driverId =(data['driverId']);

    	 if(columnIndex == 4){
    		tableLoadEvents(2,'Over Speeding',driverId);
       	 }
		 else if(columnIndex == 5){
    		tableLoadEvents(58,'Harsh Breaking',driverId);
       	 }
       	 else if(columnIndex == 6){
    		tableLoadEvents(105,'Harsh  Acceleration',driverId);
       	 }
       	 else if(columnIndex == 7){
    		tableLoadEvents(106,'Harsh  Cornering',driverId);
       	 }
       	 else if(columnIndex == 10){
    		tableLoadEvents(5,'Route  Deviation',driverId);
    	}
       	 else if(columnIndex == 11){
    		tableLoadEvents(1,'Unauthorized stoppages',driverId);
       	 }
   });

}
var remarksTable;
var remarksTable1;
function loadEvents(alertId, alertName,vehicleNo) {

if(vehicleNo==''){
vehicleNo="All";
}
   $(".modal-header #tripEventsTitle").text(alertName);
        $('#add').modal('show');
         remarksTable = $('#alertEventsTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckAlertDetails",
                "dataSrc": "alertDetails",
                "data": {
                    alertId: alertId,
                    vehicleNo:vehicleNo
                }
            },
            "bDestroy": true,
            "processing": true,
            "lengthMenu": [[4, 10, 50, -1], [4, 10, 50, "All"]] ,
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
                "data": "remarksIndex"
            }, {
                "data": "button"
            }]
        });
        $('#alertEventsTable').closest('.dataTables_scrollBody').css('max-height', '400px');
    }

    function loadNonRemarksEvents(alertName) {
        $(".modal-header #tripEventsTitle").text(alertName);
        $('#add').modal('show');
         remarksTable1 = $('#alertEventsTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckAlertDetailsNonRemark",
                "dataSrc": "alertDetailsNonRemark",
            },
            "bDestroy": true,
            "processing": true,
            "lengthMenu": [[4, 10, 50, -1], [4, 10, 50, "All"]] ,
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
                "data": "remarksIndex"
            }, {
                "data": "button"
            }]

        });
            //  remarksTable1.column(5).visible( false );
			//   remarksTable1.column(6).visible( false );
        $('#alertEventsTable').closest('.dataTables_scrollBody').css('max-height', '400px');
    }

     function Acknowledge(uniqueId) {
        swal({
                title: "",
                text: "Enter Remarks:",
                type: "input",
                showCancelButton: true,
                closeOnConfirm: false,
                animation: "slide-from-top",
                inputPlaceholder: "Enter Remarks"
            },
            function(inputValue) {
                if (inputValue === "") {
                    swal.showInputError("Enter Remarks!");
                    return false;
                } else if(inputValue === true) {
             	 //  alert("upadte ");
                }else if(typeof(inputValue)=="string"){
                    $.ajax({
                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateRemarks',
                        data: {
                            uniqueId: uniqueId,
                            remarks: inputValue
                        },
                        success: function(result) {
                               sweetAlert(result);
                                remarksTable.ajax.reload();
                               // autoRefreshPaanelsAndTable();
                        }
                    })
                }
            },
            function() {
             //   alert();
            })
    }
  function tableLoadEvents(alertId, alertName,driverId) {

   $(".modal-header #tripEventsTitle").text(alertName);
        $('#add').modal('show');
         remarksTable = $('#alertEventsTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckDriverAlertDetails",
                "dataSrc": "alertDetails",
                "data": {
                    alertId: alertId,
                    driverId: driverId,
                    groupId: groupId
                }
            },
            "bDestroy": true,
            "processing": false,
            "lengthMenu": [[4, 10, 50, -1], [4, 10, 50, "All"]] ,
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
                "data": "remarksIndex"
            }, {
                "data": "button"
            }]
        });
        $('#alertEventsTable').closest('.dataTables_scrollBody').css('max-height', '400px');
    }

    $('#add').on('hidden.bs.modal', function (e) {
    	loadAlertRemarked();
})

/*function autoRefreshPaanelsAndTable()
{
	alert("refresh the page ");
	 $("#div1").load();
	//loadAlert();
	//loadAlertRemarked()
}*/

 </script>
 <jsp:include page="../Common/footer.jsp" />
