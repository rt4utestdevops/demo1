<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<jsp:include page="../Common/header.jsp" />
    <title>Middle Mile Dash Board</title>
		<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	<link rel="styles/jqx" href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.bootstrap.min.css"></link>
 	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 	<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.dataTables.min.css"></link>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>   
	<script src="https://malsup.github.io/jquery.form.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
   <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
   <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
	    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>

<style>

.huge {
    font-size: 32px;
    text-align: center;
    color: darkgrey;
    margin-top: 10px;    
}
.label{
   	 		font-size: 18px;
   	 		color: black;
   	 		margin-left: 0px 
   	 	}
   	 	
.label1{
   	 		font-size: 13px;
   	 		color: black;
   	 		margin-left: 0px 
   	 	}
   	 	
 numbersBig{
   	 		font-size: 30px;
   	 	}  	 
.dataTables_scroll{
	overflow-x: auto;
    overflow-y: hidden;
}

body{
 overflow-x: hidden;

}

p.thick {
    font-weight: bold;
}
#example_filter{
   margin-top: -34px;
}

table {
font-size: smaller;
}
label {
	display : inline !important;
}

#example_filter {
    margin-top: 1px;
    margin-left: 803px;
}

div.dataTables_wrapper div.dataTables_filter {
    text-align: right;
    margin-left: 330px;
}

.modal-content
 {
    width: 115%;
}

div.dataTables_wrapper div.dataTables_paginate {
        margin-left: 274px;
}

ul.pagination {
    
    margin-left: 881px;
}

#example_paginate{
	 margin-left: 1159px;
}
</style>

  
  
<div class="panel panel-default">
	<div class="row">
	<div class="panel-heading" style="padding: 5px 15px;></div>
	<div class="panel-body">
	<div class="col-lg-12 row" style="margin-top: 0px;margin-bottom: 0px;height: 30px;">
		
				<div class="col-lg-7 ">
					<label for="staticEmail2" style="width:120px"class="col-lg-5 ">Hub Name :</label>
						<select class="col-lg-5" id="hubDropDownId"  data-live-search="true" style="height:25px;width: 275px;" onchange="getHubIdData()">
<!--						<option style="display: none"></option>-->
<!--						<option value="0" selected>ALL</option>-->
						</select>
				</div>
			    <div class="col-lg-2 " style="visibility: hidden">
					 <label for="staticEmail2" class="col-lg-4 ">Start Date:</label>
					<div class='col-lg-5 input-group date'>
						<input type='text'  id="dateInput1" />
					</div>
			    </div>
					<div class="col-lg-2" style="visibility: hidden">
							 <label for="staticEmail2" class="col-lg-4 ">End Date :</label>
							<div class='col-lg-6 input-group date'>
								<input type='text'  id="dateInput2" />
							</div>
					</div> 					
					<button id="submitBtnId" style="visibility: hidden" class="col-lg-1 btn btn-primary" onclick="getHubIdData()">Submit</button>
					
		</div>
		</div>
		</div>
</div>
		
		<div class="col-lg-12 col-md-12 col-sm-12" >				<!-- style="margin-left: 20px;"-->
	                   
	                   <div class="row" >
	                   <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">		<!--a&gt; row inner -->
	                   	<div class="col-lg-4 col-md-4 col-sm-4 card" style="border: 2px solid;margin-left: 2%;width: 394px;height: 290px;border-radius: 10px;color: grey">
	                     <div class="row" style="padding-top: 2%;margin-left: 0px;">
             			  <div class="panel panel-default" style="border: 2px solid; margin-bottom: auto;background: white;margin-right: 4%;">
                			  <div class="panel-body " style="margin-top: 0px;width: 336px;">
                			  
		                	     <div class="row" style="margin-left: 0px;margin-top: -3%;">
					                        <p style="text-align: center;margin-bottom: -3%;color:#B22222;padding-left: 72px;">
					                        <span><b>Vehicle Placement Chart</b></span>
					                        </p>
					                     </div>
					                  </div>
					               </div>
					            </div>
	                     
	                    <div class="pie-chart" id="pieChartId"></div>
	                   </div>
	                   
	                   <div class="col-lg-4 col-md-4 col-sm-4 card" style="border: 2px solid;margin-left: 1%;width: 476px;height: 290px;border-radius: 10px;color: grey;">
	                     <div class="row" style="padding-top: 2%;margin-left: 6px;margin-top: 0px;">
             			  <div class="panel panel-default" style="border: 2px solid; margin-bottom: auto;background: white;margin-right: 3%;">
                			  <div class="panel-body" style="margin-top: 0px;width: 380px;">
		                	     <div class="row" style="margin-left: 10px;margin-top: -3%;">
					                    <p style="text-align: center;margin-bottom: -3%;color:#B22222;padding-left: 145px;">
					                        <span><b>ALERTS</b></span>
					                        </p>
					                     </div>
					                  </div>
					               </div>
					            </div>
					            
								<div class="row" style="margin-left: 10px;margin-top: 0px;">
					            	<div class="col-lg-5 col-md-5 col-sm-5 card" style="border: 1px solid;height: 85px;width: 185px;margin-top: 10px;border-radius: 10px;">
	                                 <div class="huge" id="hc1Id" >
	                                <div class="label1">
	                                <p style="text-align: center;">
					                        <span><b>Unplanned Stoppage</b></span>
					                        </p></div>
	                                 <div class="col-lg-12 col-md-12 col-sm-12 card" style="border: 1px solid;height: 40px;width: 155px;border-radius: 10px;">
	                                 <div class="numbersBig">
	                                 <a href="javascript:loadAlertTableDetails(1,'Unplanned Stoppage')" >
					                       	 <h2 id="unplannedStoppageAlertId" style="text-align: center;color:red;margin-top: 2px;" >0</h2>
					                       	 </a>
									</div>
	                                 </div>
	                                 </div>
	                                 </div>
	                                 
	                             <div class="col-lg-5 col-md-5 col-sm-5 card" style="border: 1px solid;height: 85px;width: 185px;margin-top: 10px;margin-left: 30px;border-radius: 10px;">
	                             <div class="huge" id="hc2Id" >
	                                <div class="label1">
	                                <p style="text-align: center;">
					                        <span><b>Route Deviation</b></span>
					                        </p></div>
	                                 <div class="col-lg-12 col-md-12 col-sm-12 card" style="border: 1px solid;height: 40px;width: 155px;border-radius: 10px;">
	                                <div class="numbersBig">
	                                <a href="javascript:loadAlertTableDetails(5,'Route Deviation')" >
					                       	<h2 id="routeDeviationAlertId" style="text-align: center;color:red;margin-top: 2px;">0</h2>
					                       	</a>
									</div>
	                                 </div>
	                                 </div>
	                                </div>
					             </div>
					             
					    <div class="row" style="padding-top: 17px;margin-left: 7px;margin-top: -5px;">
             			  <div class="panel panel-default" style="border: 2px solid; margin-bottom: auto;background: white;margin-right: 15px;">
                			  <div class="panel-body" style="margin-top: -12px;width: 380px;">
		                	     <div class="row" style="margin-left: 0px;">
					                    <p style="text-align: center;margin-bottom: -10px;color:#B22222;padding-left: 106px;">
					                        <span><b>TODAY'S TRIP STATUS</b></span>
					                        </p>
					                     </div>
					                  </div>
					               </div>
					            </div>
	                       
	                        <div class="row" style="margin-left: -16px;margin-top: 0px;">
					            	<div class="row" style="border: 1px solid;height: 85px;width: 120px;margin-top: 10px;margin-left: 15px;border-radius: 10px;">
	                                 <div class="huge" id="hc2Id" >
	                                <div class="label1">
	                                <p style="text-align: center;padding-left: 25px;">
					                        <span><b>Completed</b></span>
					                        </p></div>
	                                 <div class="row" style="border: 1px solid;height: 45%;width: 66px;border-radius: 10px;margin-left: 27px;">
	                                 <div class="numbersBig">
					                       <a href="javascript:loadTableData('CLOSED')" >
					                       <h2 id="completedTripsAlertId"  style="text-align: center;color:green;margin-top: 2px;padding-left: 23px;" >0</h2>
					                       </a>
									</div>
	                                 </div>
	                                 </div>
	                                 </div>
	                                 <div class="row" style="border: 1px solid;height: 85px;width: 120px;margin-left: 35px; margin-top: 10px;border-radius: 10px;">
	                                 <div class="huge" id="hc2Id" >
	                                <div class="label1">
	                                <p style="text-align: center;padding-left: 25px;">
					                        <span><b>TAT Delayed</b></span>
					                        </p></div>
	                                 <div class="row" style="border: 1px solid;height: 45%;width: 66px;border-radius: 10px;margin-left: 27px;">
	                                 <div class="numbersBig">
					                       <a href="javascript:loadTableData('TAT')" >
					                       <h2 id="tatId"  style="text-align: center;color:red;margin-top: 2px;padding-left: 23px;"  >0</h2>
					                       </a>
									</div>
	                                 </div>
	                                 </div>
	                                 </div>
	                             <div class="row" style="border: 1px solid;height: 85px;width: 120px;margin-top: 10px;margin-left: 35px;border-radius: 10px;">
	                                    <div class="huge" id="hc2Id" >
	                                <div class="label1">
	                                <p style="text-align: center;padding-left: 25px;">
					                        <span><b>In-transit</b></span>
					                        </p></div>
	                                 <div class="row" style="border: 1px solid;height: 45%;width: 66px;border-radius: 10px;margin-left: 27px;">
	                                 <div class="numbersBig">
					                       	<a href="javascript:loadTableData('OPEN')" >
					                       	<h2 id="enrouteTripsAlertId" style="text-align: center;color:red;margin-top: 2px;padding-left: 23px;" >0</h2>
					                       	</a>
									</div>
	                                 </div>
	                                 </div>
	                                </div>
					             </div>
	                   </div>
	                   
	                   <div class="col-lg-4 col-md-4 col-sm-4 card" style="border: 2px solid;margin-left: 1%;width: 413px;height: 290px;border-radius: 10px;color: grey;">
	                     <div class="row" style="padding-top: 2%;margin-left: 0px;">
             			  <div class="panel panel-default" style="border: 2px solid; margin-bottom: auto;background: white;margin-right: 4%;">
                			  <div class="panel-body" style="margin-top: 0px;width: 380px;">
		                	     <div class="row" style="margin-left: 10px;margin-top: -3%;">
					                        <p style="text-align: center;margin-bottom: -3%;color:#B22222; padding-left: 115px;">
					                        <span><b>On-Time Placement</b></span>
					                        </p>
					                     </div>
					                  </div>
					               </div>
					            </div>
	                     
					<div id="onTimePieChartId"></div>
	                   </div>
	                   </div><!-- row inner --> 
	                   </div>
<!--	                   <div id="gridHeaderId" class="gridHeaderclass" style="width:100%;height: 25px;border:0;margin-top: 1%;margin-left: 1%;margin-bottom: -2%;color:#B22222;" align="left"><b>-->
<!--	                   </b>-->
<!--	                   </div>-->

		                	     <div class="row" style="border:2px solid;margin-bottom: -2%;margin-top: 1%;margin-left: 35%;width: 30%;border-radius: 10px; color: grey;">
					                        <p class="thick" style="text-align: center;;color:#B22222;margin-top: 1%;margin-left: 174px;">
					                        <span id="gridHeaderId"><b></b></span>
					                        </p>
					                     </div>
	                   
	       <div class="col-lg-12 col-md-12 col-sm-8 " style="margin-top: 0%">
               <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-bottom: -3%;margin-top: 1%;">
           		<thead>
                 	<tr>
                 	<th>Sl. No</th>
					<th style="display:none;">Trip Id</th>
					<th>Shipment Id</th>
					<th>VR No</th>
					<th>Vehicle No</th>
					<th>Start Point</th>
					<th>End Point</th>
					<th>Next Touch Point</th>
					<th>ETA to Touch Point</th>
					<th>Current Location</th>
					<th>Trip Start</th>
					<th>ETA to Destination</th>
					<th>Total Distance (Kms)</th>
					<th>Remaining Distance (Kms)</th>
					<th>Delayed/ On-time</th>
					<th style="display:none;">Route Id</th>
					<th style="display:none;">Trip status</th>
					<th style="display:none;">Start Date Time</th>
					<th>Status Bar</th>						
				
					<th>Map</th>
					<th style="display:none;">End Date</th>
					<th style="display:none;">Lat Lng</th>
					<th>Remarks</th>
					<th>UnloadingTime</th>					
					<th style="display:none;">AlertName</th>
					<th style="display:none;">DestArrival</th>
					
					</tr>
				</thead>
			</table>
		</div>
	    </div>
	   </div>
	   
<div class="modal fade" id="mapModal" role="dialog">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
		<div class="col-lg-12">
		
		<div class="col-lg-6"></div> <h4 class="modal-title">Map</h4></div>
		<div class="col-lg-6">   <button type="button" class="close" data-dismiss="modal">&times;</button></div>
        
          
        </div>
        <div class="modal-body">
          <div id="map" style="width:initial;height: 500px; "></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="remarksModal" role="dialog">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
		<div class="col-lg-12">
		<div class="col-lg-6"><h4 id="remarksTitle" class="modal-title" style="text-align:left; margin-left:5px;">Remarks</h4></div>
		<div class="col-lg-6"><button type="button" class="close" data-dismiss="modal">&times;</button></div>
		</div>
          
        </div>
        <div class="modal-body" style="margin-top:5px">
		<div class="form-group">
      		<label for="previousRemarks">Previous Remarks:</label>
      			<div  class="well well-sm" id="previousRemarks"> </div>
    	
      		<label id="remarksLbl" for="remarksId">Remarks:</label>
      			<textarea class="form-control" style="resize:none" id="remarksId" rows="5"></textarea>
    		</div>		
        </div>
        <div class="modal-footer">
          <div class="modal-footer"  style="text-align: center;">
                 <input id="save" onclick="saveTripRemarks()" type="button" class="btn btn-success" value="Save" />
                 <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button> 
          </div>
        </div>
  
      </div>
    </div>
  </div>
  
 <div class="modal fade" id="TimerModal" role="dialog">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
		<div class="col-lg-12"> 
		<div class="col-lg-6"><h4 id="timerModalTitle" class="modal-title" style="text-align:left; margin-left:5px;"></h4> </div>
		<div class="col-lg-6"> <button type="button" class="close" data-dismiss="modal">&times;</button></div>
		</div>
          
        </div>
         <div class="modal-body" style="margin-top:5px">
          <div class="col-lg-3 col-sm-3 col-md-3 col-xs-3 ">
					 <label for="staticEmail2" class="col-lg-4 col-sm-4 col-md-4 col-xs-4"> Date:</label>
					<div class="col-lg-8 col-sm-8 col-md-8 col-xs-8 date">
						<input type='text'  id="dateInput3"  />
				</div>
			     </div>
    		</div>		
        <div class="modal-footer">
          <div class="modal-footer"  style="text-align: center;">
                 <input id="save" onclick="saveUnloadingDetails()" type="button" class="btn btn-success" value="Save" />
                 <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button> 
          </div>
        </div>
  
      </div>
    </div>
  </div>
 
<!--  <div class="timer-div-one"; id="countdown" style="height: 20px; width: 20px;">-->
<!--  </div>-->
  
<div class="modal fade" id="alertDetailsModal" role="dialog">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
		<div class="col-lg-12">
		<div class="col-lg-6">
		<h4 id="alertTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
		</div>
		<div class="col-lg-6">
		 <button type="button" class="close" data-dismiss="modal">&times;</button>
		</div>
		</div>
         
			
        </div>
        <div class="modal-body" style="margin-top:-30px">
		 <div class="col-lg-12" style="margin-top:15px">
             <table id="alertDetailsTable" class="table table-striped table-bordered" cellspacing="0" width="100%" >
               	<thead>
                  		<tr>
                      		<th>Sl No</th>
                      		<th style="display:none;">ID</th>
                      		<th>Vehicle No</th>
                      		<th>Location</th>
                      		<th>Date</th>
                      		<th>Remarks</th>
                     		</tr>
                  	</thead>
             		</table>
             		</div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
  
  <div class="modal fade" id="vehiclePlacementDetailsModal" role="dialog">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header" >
		<div class="col-lg-12">
		<div class="col-lg-6">
		<h4 id="chartDetailsTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
		</div>
		<div class="col-lg-6">
		 <button type="button" class="close" data-dismiss="modal">&times;</button>
		</div>
		</div>
		
         
			
        </div>
        <div class="modal-body" style="margin-top:-30px">
		 <div class="col-lg-12" style="margin-top:15px">
             <table id="vehiclePlacementChartDetailsTable" class="table table-striped table-bordered" cellspacing="0" width="100%" >
               	<thead>
                  		<tr>
                      		<th>Sl No</th>
                      		<th>Hub Name</th>
                      		<th>Vehicle Type</th>
                      		<th>Vehicle Make</th>
                      		<th>Vehicle Number</th>
                      		<th>Current Reporting Time</th>
                      		<th>Actual Reporting Time</th>
                      		<th>Vehicle Assigned Time</th>
                     		</tr>
                  	</thead>
             		</table>
             		</div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"></script>
<script lang="javascript" type="text/javascript">
 
 
var table;
var destarr;
var dest;
var hubDetails;
var hubId=0;
var hubName;
var unplanned=0;
var routeDeviation=0;
var completed=0;
var enroute=0;
var alertList;
var hubArray=[];
var fromMiddleMileDashboard="fromMiddleMileDashboard";
var tripType;
var newTable;
var selectedTripId;
var selectedVehicleNo;
var selectedLocationIndex;
var buttonValue;
var alertName;
var alert;
var gpstime;
var gps;
var todayDate=new Date();

	var currentDate = new Date();
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);
	window.onload = function () { 
		getHubs();
	}
$(document).ready(function () {
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
   $("#dateInput3").jqxDateTimeInput({ theme: "arctic", formatString: 'yyyy-MM-dd HH:mm', showTimeButton: true, showCalendarButton: true,width: '197px', height: '25px'});
   $('#dateInput3').jqxDateTimeInput('setDate',todayDate);
 //   $('#dateInput3').jqxDateTimeInput({ min:(todayDate.getHours,todayDate.getMinutes) });

  
  
<!--   $("#dateInput1").change(function (event) {-->
<!--    var startDate = document.getElementById("dateInput1").value;-->
<!--    var endDate = document.getElementById("dateInput2").value;-->
<!---->
<!--    if ((Date.parse(startDate) >= Date.parse(endDate))) {-->
<!--        sweetAlert("End date should be greater than Start date");-->
<!--        document.getElementById("dateInput2").value = "";-->
<!--   }-->
<!--});-->
<!--   $("#dateInput2").change(function (event) {-->
<!--    var startDate = document.getElementById("dateInput1").value;-->
<!--    var endDate = document.getElementById("dateInput2").value;-->
<!---->
<!--    if ((Date.parse(startDate) >= Date.parse(endDate))) {-->
<!--        sweetAlert("End date should be greater than Start date");-->
<!--        document.getElementById("dateInput2").value = "";-->
<!--   }-->
<!--});-->
});


function getHubs(){
<!--	$("#hubDropDownId").empty().select2();-->
	$.ajax({
        url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getHubDetails',
          success: function(result) {
                   hubDetails = JSON.parse(result);
         
            for (var i = 0; i < hubDetails["HubDetailsRoot"].length; i++) {
<!--            hubArray.push(hubDetails["HubDetailsRoot"][i].hubName);-->
<!--			hubId = hubDetails["HubDetailsRoot"][i].hubId;-->
			$('#hubDropDownId').append($("<option></option>").attr("value", hubDetails["HubDetailsRoot"][i].hubId).text(hubDetails["HubDetailsRoot"][i].hubName));
			}
			$('#hubDropDownId').select2();
			
<!--		for (i = 0; i < hubArray.length; i++) {-->
<!--                var opt = document.createElement("option");-->
<!--                document.getElementById("hubDropDownId").options.add(opt);-->
<!--                opt.text = hubArray[i];-->
<!--                opt.value = hubArray[i];-->
<!--					-->
<!--            }-->
		}
	});
	
	//loadData();
	loadAlertDetails();
	loadVehiclePlacementChart();
	loadOnTimePlacementChart();
	loadTableData('OPEN');
	
	
 } 

function loadAlertDetails(){
<!--hubName=document.getElementById("hubDropDownId").value;-->
<!--if(hubName!=0){-->
<!--	for (var i = 0; i < hubArray.length; i++) {-->
<!--        if (hubName ==  hubDetails["HubDetailsRoot"][i].hubName) {-->
<!--            hubId = hubDetails["HubDetailsRoot"][i].hubId;-->
<!--        }-->
<!--     }-->
<!--}else{-->
<!--    hubId=0;-->
<!--}-->

var hubId = $('#hubDropDownId option:selected').attr("value");
if(hubId=='' || hubId == undefined){
		hubId=0;
	}
 $.ajax({
        url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getAlertDetails',
         "data": {
                 
                 hubId:hubId
             },
        success: function(result) {
            	alertList = JSON.parse(result);
               $("#unplannedStoppageAlertId").text(alertList["AlertDetailsRoot"][0].unplanedStoppage);
               $("#routeDeviationAlertId").text(alertList["AlertDetailsRoot"][0].routeDeviation);
               $("#completedTripsAlertId").text(alertList["AlertDetailsRoot"][0].completedTrips);  
               $("#enrouteTripsAlertId").text(alertList["AlertDetailsRoot"][0].enrouteTrips);
		       $("#tatId").text(alertList["AlertDetailsRoot"][0].tatTrips);
         }
	});

} 

function loadTableData(tripType){
	if(tripType=='OPEN'){
 		document.getElementById("gridHeaderId").innerHTML = "In-transit Trips";
	}else if(tripType=='TAT')
	{
	document.getElementById("gridHeaderId").innerHTML = "TAT Delayed";
	}
	else{
 		document.getElementById("gridHeaderId").innerHTML = "Completed Trips";
	}
var tripNo;
var vehicleNo;
var sDate;
var eDate;
var actualDate;
var status;
var routeId;

hubName=document.getElementById("hubDropDownId").value;
<!--if(hubName!=0){-->
<!--	for (var i = 0; i < hubArray.length; i++) {-->
<!--        if (hubName ==  hubDetails["HubDetailsRoot"][i].hubName) {-->
<!--            hubId = hubDetails["HubDetailsRoot"][i].hubId;-->
<!--        }-->
<!--     }-->
<!--}else{-->
<!--    hubId=0;-->
<!--}-->

var hubId = $('#hubDropDownId option:selected').attr("value");
if(hubId=='' || hubId == undefined){
		hubId=0;
	}
     

	var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
    if ($.fn.DataTable.isDataTable('#example')) {
        $('#example').DataTable().clear().destroy();
           }  
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getGridDetails',
        "data": {
        	startdate: startDate,
            enddate: endDate,
            tripType:tripType,
            hubId:hubId
        },
        success: function(result) {
         result = JSON.parse(result).gridDetailsRoot;
         if ($.fn.DataTable.isDataTable('#example')) {
             $('#example').DataTable().clear().destroy();
                }
         var rows = new Array();
         $.each(result, function(i, item) {
           var row = { "0":item.slnoIndex,
                     "1" : item.tripIdIndex,
                     "2" : item.tripNumberIndex,
                     "3" : item.vrNumberIndex,
                     "4" : item.vehicleNoIndex,
                     "5" : item.startPointIndex,
                     "6" : item.endPointIndex,
                     "7" : item.nextTouchPointIndex,
                     "8" : item.etaTouchPointIndex,
                     "9" : item.currentLocationIndex,
                     "10" : item.tripStartIndex,
                     "11" : item.etaIndex,
                     "12" : item.totalDistanceIndex,
                     "13" : item.remainingDistanceIndex,
                     "14" : item.onTimeDelayedStatusIndex,
                     "15" : item.routeIdIndex,
                     "16" : item.tripStatusIndex,
                     "17" : item.stdIndex,
                     "18" : item.statusIndex,
                     "19" : item.viewMapIndex,
                     "20" : item.endDateIndex,
                     "21" : item.latLngIndex,
                     "22" : item.tripRemarksIndex,
                     "23" : item.unloadingIndex,
                     "24" : item.alertnameIndex,
                     "25" : item.actualarrdestindex
           }
           
           rows.push(row);
         });
           table = $('#example').DataTable({
               "scrollY": "280px",
               "scrollX": true,
               paging : true,
               "serverSide": false,
               "oLanguage": {
                   "sEmptyTable": "No data available"
               },
	    "dom": 'Bfrtip',
	    "processing": true,
              "buttons": [{
              		extend: 'pageLength'
          		}, {
               extend: 'excel',
               text: 'Export to Excel',
  	            className: 'btn btn-primary',
  	             exportOptions: {
	                 columns: ':visible'
	            }
          	  }],
          	  
             });
             table.rows.add(rows).draw();
             table.columns( [1,15,16,17,20,21,24,25] ).visible( false );
	     
    }
    });     
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
     

     $(document).on("dblclick", "#example tr", function () {
     
            var data = table.row(this).data();
            //var columnIndex = table.cell(this).index().column;
            var lat;
	    var lng;
            var latLng=data[21];//latLngIndex	    
            var latLngArr=[]
            latLngArr=latLng.split(',');
            lat=latLngArr[0];
            lng=latLngArr[1];
            viewOnMap(lat,lng);
        });
        
 $('#example').unbind().on('click', 'td', function(event) {
			var columnIndex = table.cell(this).index().column;
			var aPos = $('#example').dataTable().fnGetPosition(this);
	        var data = $('#example').dataTable().fnGetData(aPos[0]);
            tripNo = (data[1]);//tripIdIndex
            vehicleNo = (data[4]);//vehicleNoIndex
            sDate = (data[17]);//stdIndex
            eDate = (data[20]);//endDateIndex
            actualDate = (data[17]);//stdIndex
            status = (data[16]);//tripStatusIndex
            routeId = (data[15]);//routeIdIndex
            alertName=(data[24]);//alertnameIndex
            destarr=(data[25]);//actualarrdestindex
	    	selectedTripId=tripNo;
 	    	selectedVehicleNo=vehicleNo;
	    	selectedLocationIndex = (data[9]);
	        if(columnIndex == 19){ //column index 19 is used for MAP column//
   			    window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + sDate + "&endDate=" + eDate + "&pageId=6&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId , '_blank');
   			   // window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + sDate + "&endDate=" + eDate + "&pageId=6&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId , '_blank';
           		event.preventDefault();
			}
			if(columnIndex == 22){//column index 22 is used for Remarks 
				
				loadRemarksModal(status);
			}
			if(columnIndex == 23){//column index 22 is used for Unloading 
				if(alertName!='completed')
				{

				$('#TimerModal').modal('show');
					if(alertName == 'Unload_Start'){
						$(".modal-header #timerModalTitle").text("Enter unloading start date");
					}else if(alertName == 'Unload_End'){
						$(".modal-header #timerModalTitle").text("Enter unloading end date");
					}
				}
			}
});        
	}//load data



function loadVehiclePlacementChart() {

<!--	hubName=document.getElementById("hubDropDownId").value;-->
<!--	if(hubName!=0){-->
<!--		for (var i = 0; i < hubArray.length; i++) {-->
<!--         if (hubName ==  hubDetails["HubDetailsRoot"][i].hubName) {-->
<!--             hubId = hubDetails["HubDetailsRoot"][i].hubId;-->
<!--         }-->
<!--      }-->
<!--     }else{-->
<!--     	hubId=0;-->
<!--     }-->

	
	
	var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
    
    
  google.charts.load('current', {
      'packages': ['line', 'corechart', 'bar']
  });

  google.charts.setOnLoadCallback(drawChart);

function drawChart() {
	var hubId = $('#hubDropDownId option:selected').attr("value");
	if(hubId=='' || hubId == undefined){
		hubId=0;
	}
                        $.ajax({
                            url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getVehiclePlacementChartDashBoard',
                            data: {
                            	hubId:hubId,
                            	startDate:startDate,
                            	endDate:endDate
                            },
                            success: function(response) {
                                    var jsonList = JSON.parse(response);
                                    var placed = jsonList["vehiclePlacementDetailsRoot"][0].placed;
                                    var yetToBePlaced = jsonList["vehiclePlacementDetailsRoot"][0].yetToBePlaced;

                                   
                                    var data = google.visualization.arrayToDataTable([
                                        ['Task', 'Vehicle Placement'],
                                        ['Placed', Number(placed)],
                                        ['Yet to be Placed', Number(yetToBePlaced)],
                                    ]);
                                    var options = {
                                        height: 232,
                                        width: 370,
                                        legend:'bottom',
                                      // pieSliceText: 'value-and-percentage',
                                        pieSliceText: 'value',
                                        colors: ['#58D68D', '#E74C3C']// '#ec8f6e', '#f3b49f', '#f6c7b6']
                                    };
                                    
                                     var chart = new google.visualization.PieChart(document.getElementById('pieChartId'));
                                    
                         google.visualization.events.addListener(chart, 'select', selectHandler);
                        function selectHandler() {
						var selection = chart.getSelection();
						for (var i = 0; i < selection.length; i++) {
							 var selectedItem = chart.getSelection()[0];
								    if (selectedItem) {
								      var value = data.getValue(selectedItem.row,0);
								      viewVehiclePlacementChartDetails(value);
								    }
							}
							
						}

							        //google.visualization.events.addListener(chart, 'select', selectHandler); 
							       
							        chart.draw(data, options);
                                }
                        });
                        
                        
                        
                    }
                    //pie select
                }
                
        


               
 function loadOnTimePlacementChart() {
 
 	var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
 
             google.charts.load('current', {
                 'packages': ['line', 'corechart', 'bar']
             });

                    google.charts.setOnLoadCallback(drawChart);

     function drawChart() {
<!--         var data = new google.visualization.DataTable();-->
<!--   			data.addColumn('number', 'X');-->
<!--     		data.addColumn('number', 'Vehicles');-->
<!--		      data.addRows([-->
<!--		        [0, 0],   [1, 10],  [2, 23],  [3, 17],  [4, 18],  [5, 9],-->
<!--		        [6, 11],  [7, 27],  [8, 33],  [9, 40],  [10, 32], [11, 35],-->
<!--		        [12, 30], [13, 40], [14, 42], [15, 47], [16, 44], [17, 48],-->
<!--		        [18, 52], [19, 54], [20, 42], [21, 55], [22, 56], [23, 57],-->
<!--		        [24, 60], [25, 50], [26, 52], [27, 51], [28, 49], [29, 53],-->
<!--		        [30, 55], [31, 60], [32, 61], [33, 59], [34, 62], [35, 65],-->
<!--		        [36, 62], [37, 58], [38, 55], [39, 61], [40, 64], [41, 65],-->
<!--		        [42, 63], [43, 66], [44, 67], [45, 69], [46, 69], [47, 70],-->
<!--		        [48, 72], [49, 68], [50, 66], [51, 65], [52, 67], [53, 70],-->
<!--		        [54, 71], [55, 72], [56, 73], [57, 75], [58, 70], [59, 68],-->
<!--		        [60, 64], [61, 60], [62, 65], [63, 67], [64, 68], [65, 69],-->
<!--		        [66, 70], [67, 72], [68, 75], [69, 80]-->
<!--		      ]);            -->
                    
                    var hubId = $('#hubDropDownId option:selected').attr("value");
                    if(hubId=='' || hubId == undefined){
							hubId=0;
						}
                    
                        $.ajax({
                            url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getOnTimePlacementDashBoard',
                            data: {
                            	startDate:startDate,
                            	endDate:endDate,
                            	hubId:hubId

                            },
                            success: function(response) {
                                    var jsonList = JSON.parse(response);
                                    var onTime = jsonList["onTimePlacementDetailsRoot"][0].onTime;
                                    var delayed = jsonList["onTimePlacementDetailsRoot"][0].delayed;
                                    var yetToReach = jsonList["onTimePlacementDetailsRoot"][0].yetToReach;
                                   
                                    var data = google.visualization.arrayToDataTable([
                                        ['Task', 'Vehicle Placement'],
                                        ['On-time', Number(onTime)],
                                        ['Delayed', Number(delayed)],
                                        ['Not Reached', Number(yetToReach)],
                                    ]);
                                    var options = {
                                        height: 232,
                                        width: 370,
                                        legend:'bottom',
                                      // pieSliceText: 'value-and-percentage',
                                        pieSliceText: 'value',
                                        colors: ['#58D68D', '#E74C3C','#e28814']// '#ec8f6e', '#f3b49f', '#f6c7b6']
                                    };
                                     var chart = new google.visualization.PieChart(document.getElementById('onTimePieChartId'));
                                     google.visualization.events.addListener(chart, 'select', selectHandler1);
                        function selectHandler1() {
						var selection = chart.getSelection();
						for (var i = 0; i < selection.length; i++) {
							 var selectedItem = chart.getSelection()[0];
								    if (selectedItem) {
								      var value = data.getValue(selectedItem.row,0);
								      viewOnTimePlacementChartDetails(value);
								    }
							}
							
						}
                                    chart.draw(data, options);
                                }
                        });
                    }
                }     
                
  function getHubIdData(){
  	hubId=0;
	loadAlertDetails();
	loadVehiclePlacementChart();
	loadOnTimePlacementChart();
	loadTableData('OPEN');
         	
 }  
 
 function viewOnMap(lat,lng){//,flag){
 var map;
 var markers;
 var pos;
	function initialize(){
      	var mapOptions = {
	        zoom:7,
	        mapTypeId: google.maps.MapTypeId.ROADMAP,
	        //mapTypeControl: false,
	        gestureHandling: 'greedy' 
	    };
	   	map = new google.maps.Map(document.getElementById('map'), mapOptions);
		
		pos = new google.maps.LatLng(lat, lng);
           markers = new google.maps.Marker({
                position: pos,
                map: map,
                icon: '/ApplicationImages/VehicleImages/GreenBalloon.png'
            });

	}
	initialize();
 //loadMap();
 $('#mapModal').modal('show');
 $('#mapModal').on('shown.bs.modal', function () {
    google.maps.event.trigger(map, "resize");
    map.setCenter(pos);
    map.setZoom(15);
    
});

 } 

 
 function loadAlertTableDetails(alertId, alertName){
 	$(".modal-header #alertTitle").text(alertName);
 	$('#alertDetailsModal').modal('show');
 	loadAlertDataTable(alertId, alertName);
 
 }


function saveUnloadingDetails(){
    
var Date=document.getElementById("dateInput3").value;
alert(selectedTripId);
	 	$.ajax({
        	url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=saveunloadingvehicle',
        	 "data": {
		  		tripId : selectedTripId,
		  		alert : alertName,
		  		vehicleNo :selectedVehicleNo,
		  		dest:destarr,
				currentLocation: selectedLocationIndex,	
				Date:Date
		  	},
        	success: function(result) {           	
             sweetAlert(result); 
              table.ajax.reload();
              setTimeout(function() {
            	  $('#TimerModal').modal('hide');
              }, 1000);
         	}
	});

 }		 
 function loadRemarksModal(status){
		document.getElementById("previousRemarks").innerHTML="";
	 	$.ajax({
        	url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getTripRemarks',
    
        	 "data": {
	
		  		tripId : selectedTripId
		  	},
        	success: function(result) {
            		results = JSON.parse(result);
			document.getElementById("previousRemarks").innerHTML=results["tripRemarks"];
			document.getElementById("remarksId").value="";	 
	 		$('#remarksModal').modal('show');
	 		if(status == "CLOSED"){
				$('#remarksLbl').hide();
				$('#remarksId').hide()
			}
			else{
				$('#remarksLbl').show()
				$('#remarksId').show();
			}
         	}
		});
	
	 }
 
 function saveTripRemarks(){
	var hubId = $('#hubDropDownId option:selected').attr("value");
	if(hubId=='' || hubId == undefined){
		hubId=0;
	}
	var remarks= (document.getElementById("remarksId").value).trim();
	 if (remarks == "") {
         sweetAlert("Please enter remarks");
         return;
     }
	var param = {
		tripId : selectedTripId,
		vehicleNo :selectedVehicleNo,
		currentLocation: selectedLocationIndex,
		hubId : hubId,
		remarks:remarks	
	}
 	$.ajax({
        	url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=saveTripRemarks',
        	 "data": param,
        	success: function(result) {           	
                	sweetAlert(result);
					$('#remarksModal').modal('hide');
					document.getElementById("remarksId").value="";
         	}
	});

 }
 

 function loadAlertDataTable(alertId, alertName){

 if ($.fn.DataTable.isDataTable('#alertDetailsTable')) {
     $('#alertDetailsTable').DataTable().destroy();
        }
       var hubId = $('#hubDropDownId option:selected').attr("value");
	if(hubId=='' || hubId == undefined){
		hubId=0;
	}
        
  newTable = $('#alertDetailsTable').DataTable({
 "ajax": {
             "url": '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getAlertTableDetails',
             "data": {
                 alertId:alertId,
                 hubId:hubId
             },
             "dataSrc": "alertTableRoot"
         },
         "bLengthChange": false,
<!--         "dom": 'Bfrtip',-->
<!--           // "scrollY":  '50vh',-->
<!--            "buttons": [-->
<!--            {-->
<!--                extend: 'pageLength'-->
<!--            }],-->

         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "idIndex",
             "visible": false,
         },{
             "data": "vehicleNoIndex"
         },{
         	"data": "locationIndex"
         },{
         	"data": "dateTimeIndex"
         },{
         	"data": "remarksIndex"
         }
         ]
     });
     
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
 }
 
 function viewVehiclePlacementChartDetails(selectionType){
  if ($.fn.DataTable.isDataTable('#vehiclePlacementChartDetailsTable')) {
     $('#vehiclePlacementChartDetailsTable').DataTable().destroy();
        }
       var hubId = $('#hubDropDownId option:selected').attr("value");
	if(hubId=='' || hubId == undefined){
		hubId=0;
	}
         
        var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
  newTable = $('#vehiclePlacementChartDetailsTable').DataTable({
 "ajax": {
             "url": '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getVehiclePlacementTableDetails',
             "data": {
                 selectionType:selectionType,
                 hubId:hubId,
                 date:startDate,
             },
             "dataSrc": "vehiclePlacementTableRoot"
         },
         "bLengthChange": false,
<!--         "dom": 'Bfrtip',-->
<!--           // "scrollY":  '50vh',-->
<!--            "buttons": [-->
<!--            {-->
<!--                extend: 'pageLength'-->
<!--            }],-->

         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "hubNameIndex"
         },{
         	"data": "vehicleTypeIndex"
         },{
         	"data": "vehicleMakeIndex"
         },{
         	"data": "vehicleNumberIndex"
         },{
         	"data": "currentReportingTimeIndex"
         },{
         	"data": "actualReportingIndex"
         },{
         	"data": "vehicleAssignedTimeIndex"
         }
         ]
     });
     $(".modal-header #chartDetailsTitle").text(selectionType);
     $('#vehiclePlacementDetailsModal').modal('show');
     
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
     
 
 
 }
 
  function viewOnTimePlacementChartDetails(selectionType){
  if ($.fn.DataTable.isDataTable('#vehiclePlacementChartDetailsTable')) {
     $('#vehiclePlacementChartDetailsTable').DataTable().destroy();
        }
        var hubId = $('#hubDropDownId option:selected').attr("value");
	if(hubId=='' || hubId == undefined){
		hubId=0;
	}
        var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
  newTable = $('#vehiclePlacementChartDetailsTable').DataTable({
 "ajax": {
             "url": '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getOnTimePlacementTableDetails',
             "data": {
                 selectionType:selectionType,
                 hubId:hubId,
                 date:startDate,
                // selectionType:selectionType,
             },
             "dataSrc": "onTimePlacementTableRoot"
         },
         "bLengthChange": false,
<!--         "dom": 'Bfrtip',-->
<!--           // "scrollY":  '50vh',-->
<!--            "buttons": [-->
<!--            {-->
<!--                extend: 'pageLength'-->
<!--            }],-->

         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "hubNameIndex"
         },{
         	"data": "vehicleTypeIndex"
         },{
         	"data": "vehicleMakeIndex"
         },{
         	"data": "vehicleNumberIndex"
         },{
         	"data": "currentReportingTimeIndex"
         },{
         	"data": "actualReportingIndex"
         },{
         	"data": "vehicleAssignedTimeIndex"
         }
         ]
     });
     $(".modal-header #chartDetailsTitle").text(selectionType);
     $('#vehiclePlacementDetailsModal').modal('show');
     
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
     
  }
 </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->