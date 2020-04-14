<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");

	if (loginInfo != null) {
	} else {
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");

	}
%>
<jsp:include page="../Common/header.jsp" />

		<title>Boat Trips Report</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">

		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
		<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
		<!--	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">-->
		<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet" />
		<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet" />
		<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
		<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
		<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.min.css" rel="stylesheet" />

		<link rel="stylesheet" href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css" type="text/css" />
        <link rel="stylesheet" href="https://rawgit.com/zhangtasdq/range-picker/master/dist/css/range-picker.min.css" />


		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
		<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
		<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
		<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
		<script src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
		<!--    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>-->

		<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>

		<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
		<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
		<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
		<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
		<script type="text/javascript" src="https://rawgit.com/zhangtasdq/range-picker/master/dist/js/range_picker.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.min.js"></script>
		

		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/scripts/demos.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcore.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxdatetimeinput.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcalendar.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxtooltip.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/globalization/globalize.js"></script>
		
<style>
#ex1Slider .slider-selection {
	background: #BABABA;
}
</style>



	
		<div class="custom">
         <div class="panel panel-primary">
               
			   <div class="panel-heading">
                  <h3 class="panel-title" >
                     BOAT EXCAVATION TRIP  REPORT 
                  </h3>
               </div>
			   
			   <div class="panel-body">
			   
			   <div class="panel row" style="padding:1% ;margin: 0%;border: solid 1px #ccc;"> 
			   
			   <div class="col-xs-12 col-md-12 col-lg-12">
			   
			   <div class="col-xs-12 col-md-3 col-lg-3  ">
			     <select class="form-control" id="customerList" onchange="getTpOwners()">
					<option value=0 style="display:none"> CUSTOMER NAME</option>
				</select> 
               </div>
               
               <div class="col-xs-12 col-md-3 col-lg-3  ">
			     <select class="form-control" id="tpOwnerList" onchange="getBoatsName(); " >
					<option value=0  style="display:none"> TP OWNER</option>
				</select> 
               </div>
               
               <div class="col-xs-12 col-md-3 col-lg-3  ">
			     <select class="form-control" id="boatList" onchange="getHubList()">
					<option value=0  style="display:none" > BOAT NUMBERS</option>
				</select> 
               </div>
               
               <div class="col-xs-12 col-md-2 col-lg-2  ">
					<button type="button"  class="btn btn-success" onclick="getExcavationTripReport()" style=" margin-top: 0%;margin-left: 13%;">Submit</button>
			   </div>	
			   
				
				
<!--				<div class="col-xs-12 col-md-3 col-lg-3 form-group">-->
<!--								<div class='input-group date' id='dateInput'>-->
<!--									<input type='text' placeholder="Date Range" class="form-control" />-->
<!--									<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span> </span>-->
<!--								</div>-->
<!--				</div>-->
				
				
			  
			  
			   </div>  <!--  heading 1  -->
			   
			    <div class="col-xs-12 col-md-12 col-lg-12" style="margin-top:1%">
				  <div class="col-xs-12 col-md-4 col-lg-4" > Filter by duration interval (min) : <br/>
				  <b>0</b> &nbsp; &nbsp;
					  <input id="distanceR" type="text" class="span2" value="" data-slider-min="0" data-slider-max="300" data-slider-step="2" data-slider-value="[0,0]"/> 
				  &nbsp; &nbsp;<b>300</b>
				 </div>
				 
				  <div class="col-xs-12 col-md-4 col-lg-4" > Filter by Associated Hub (kms) : <br/>
				  <b>0</b> &nbsp; &nbsp;
					  <input id="associatedR" type="text" class="span2" value="" data-slider-min="0" data-slider-max="50" data-slider-step="1" data-slider-value="[0,0]"/> 
					&nbsp;  &nbsp; <b>50</b>
				 </div>
				 
				  <div class="col-xs-12 col-md-4 col-lg-4" > Filter by Unassociated Hub (kms) : <br/>
				     <b>0</b>&nbsp; &nbsp;
					  <input id="disassocaitedR" type="text" class="span2" value="" data-slider-min="0" data-slider-max="50" data-slider-step="1" data-slider-value="[0,0]"/> 
					 &nbsp; &nbsp; <b>50</b>
				 </div>	
				 
				 		 
 
			   </div> <!--  heading 2 end -->
			   
			    <div class="col-xs-12 col-md-12 col-lg-12" style="padding-top:1%">
			   
			   <div class="col-xs-12 col-md-3 col-lg-3  ">
			     <select class="form-control" id="ahubList" ">
					<option value=0 style="display:none"> ASSOCIATED HUB</option>
				</select> 
               </div>
               
               <div class="col-xs-12 col-md-3 col-lg-3  ">
			     <select class="form-control" id="uhubList"  " >
					<option value=0  style="display:none"> UNASSOCIATED HUB</option>
				</select> 
               </div>
               <div class="col-lg-2">
							<div class='input-group date' id='dateInput1'>
								<input type='text' placeholder="start date" class="form-control"  style="margin-top:0.2%;"/>
								<span class="input-group-addon"><span
									class="glyphicon glyphicon-calendar"></span> </span>
				</div>
				</div>
				<div class="col-lg-2">
							<div class="form-group">
								<div class='input-group date' id='dateInput2'>
									<input type='text' placeholder="end date" class="form-control"  style="margin-top:0.2%;"/>
									<span class="input-group-addon"><span
										class="glyphicon glyphicon-calendar"></span> </span>
								</div>
							</div> 
				</div>
               
                 </div> <!--  heading 3 end -->
			    
			    </div>  <!--End of header Panel-->
			    
			    <div style="overflow: auto !important;    padding-top: 1%;">
			   <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
							<th>Sl No.</th>
							<th>Boat Number</th>
						    <th>Trip Number</th>
							<th>Trip Start Date and Time</th>
							<th>Trip End Date and Time</th>
							<th>Total Trip Time (hours)</th>
							<th>Total Excavation Time (min)</th>
							<th>Total Excavation Count</th>
							<th>Remark</th>
							<th>Voltage (v)</th>
							<th>Status</th>
							<th>Details</th>
					 </tr>
					</thead>	
							
				</table>
				</div>	<!-- end of table -->
			   
			   </div>  <!-- end of panel body -->
	  </div> <!-- end of panel  -->
	  </div> <!-- end of main div : custom -->
	  
	  <div id='jqxWidget'>
        </div>
        
         <div id="excavationModal" class="modal fade" style="margin-right: 2%;">
        <div class="modal-dialog" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:1200px;height:530px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Excavation Details</h4>
                </div>
                <div class="modal-body" style="max-height: 100%;">
                  <p>
                        <label> Trip No:  <span class="badge badge-default" id="tripId"></span> </label>
                        <label>   Boat Name:  <span class="badge badge-default" id="boatId"></span> </label>
                    </p>
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12 col-sm-12" style="border: solid  1px lightgray;  margin-top:6px;">
                        	<table id="Edeatils"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		<th>Sl No.</th>
		                        		<th>Excavated Location</th>
		                        	    <th>Excavated Date and Time</th>
		                        	    <th>Excavation Duration (min)</th>
		                        	    <th>Associated Hub Distance (kms)</th>
		                        		<th>Associated  Hub</th>
		                        	    <th>Unassociated Hub Distance (kms)</th>
		                        		<th>Unassociated  Hub</th>
		                        	    <th>Voltage (v)</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-warning" data-dismiss="modal">Close</button> 
                    
                </div>
            </div>
        </div>
    </div>
        
        <script type="text/javascript">
		window.onload = function () { 
			getCustomerList();
		}
     //   function loadDated(){
        $(document).ready(function() {
        $("#distanceR").slider({});
         $("#associatedR").slider({});
          $("#disassocaitedR").slider({});
<!--     $("#dateInput").jqxDateTimeInput({-->
<!--         formatString: "dd/MM/yyyy",-->
<!--         showTimeButton: false,-->
<!--         width: '197px',-->
<!--         height: '25px',-->
<!--         max: new Date(),-->
<!--         selectionMode: 'range'-->
<!--     });-->

     var todayTimeStamp = +new Date; // Unix timestamp in milliseconds
     var oneDayTimeStamp = 1000 * 60 * 60 * 24; // Milliseconds in a day
     var diff = todayTimeStamp - (oneDayTimeStamp * 29);
     var yesterdayDate = new Date(diff);
     var today = new Date(todayTimeStamp);

     var date1 = new Date();
     date1.setFullYear(today.getFullYear(), (today.getMonth()), today.getDate());
     var date2 = new Date();
     date2.setFullYear(yesterdayDate.getFullYear(), (yesterdayDate.getMonth()), yesterdayDate.getDate());
    // $("#dateInput").jqxDateTimeInput('setRange', date1, date2);
     
     
    $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px',max: new Date()});
  	$('#dateInput1 ').jqxDateTimeInput('setDate', new Date(date2));
  	$("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px',max: new Date()});
  	$('#dateInput2 ').jqxDateTimeInput('setDate', new Date(date1));
     

 });
 
 //}
 
  

 function getCustomerList() {
 //loadDated()
     var CustomerList;


     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getCustomerList',
         success: function(result) {
             CustomerList = JSON.parse(result);
             //   $('#customerList').append('<option value="1">ALL</option>')
             for (var i = 0; i < CustomerList["customerRoot"].length; i++) {
                 var customerId = CustomerList["customerRoot"][i].CustId;
                 var customerName = CustomerList["customerRoot"][i].CustName;
                 $('#customerList').append($("<option></option>").attr("value", customerId).text(customerName));
             }

         }
     });



 }



 function getTpOwners() {
     var tpOwnerList;
     var custId = document.getElementById("customerList").value;

     for (var i = document.getElementById("tpOwnerList").length - 1; i >= 1; i--) {
         document.getElementById("tpOwnerList").remove(i);
     }

     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getTPownerNameList',
         data: {
             CustId: custId
         },
         success: function(result) {
             tpOwnerList = JSON.parse(result);
             $('#tpOwnerList').append('<option value="1">ALL</option>')
             for (var i = 0; i < tpOwnerList["TPowners"].length; i++) {
                 var tpId = tpOwnerList["TPowners"][i].tpId;
                 var tpOwner = tpOwnerList["TPowners"][i].tpOwner;
                 $('#tpOwnerList').append($("<option></option>").attr("value", tpId).text(tpOwner));
             }
             $("#tpOwnerList").select2({
             	});

         }
     });


 }

 function getBoatsName() {
     var boatNamesList;
     var boatArray = [];
     

     var custId = document.getElementById("customerList").value;
     var tpId = document.getElementById("tpOwnerList").value;

     for (var i = document.getElementById("boatList").length - 1; i >= 1; i--) {
         document.getElementById("boatList").remove(i);
     }
     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getboatNames',
         data: {
             CustId: custId,
             tpId: tpId
         },
         success: function(result) {
             boatNamesList = JSON.parse(result);
             $('#boatList').append('<option value="1">ALL</option>')
             for (var i = 0; i < boatNamesList["boatName"].length; i++) {
                 boatArray.push(boatNamesList["boatName"][i].boatName);
                 var name = boatNamesList["boatName"][i].boatName;
                 var hubId = boatNamesList["boatName"][i].hubId;
                 $('#boatList').append($("<option></option>").attr("value", hubId).text(name));
             }

             $("#boatList").select2({
             	});


         }
     });


 }



 function getHubList() {
     var AssHubList;
     var DisAssHubList;
     var custId = document.getElementById("customerList").value;
     var hubId = document.getElementById("boatList").value;

     for (var i = document.getElementById("ahubList").length - 1; i >= 1; i--) {
         document.getElementById("ahubList").remove(i);
     }
     for (var i = document.getElementById("uhubList").length - 1; i >= 1; i--) {
         document.getElementById("uhubList").remove(i);
     }
     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getAssHubList',
         data: {
             CustId: custId,
             hubId: hubId
         },
         success: function(result) {
             AssHubList = JSON.parse(result);
             //$('#ahubList').append('<option value="1">ALL</option>')
             for (var i = 0; i < AssHubList["assHubName"].length; i++) {
                 var hubid = AssHubList["assHubName"][i].hubId;
                 var hubName = AssHubList["assHubName"][i].hubName;
                 $('#ahubList').append($("<option></option>").attr("value", hubId).text(hubName));
             }
             $("#ahubList").select2({
             	});

         }
     });

     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getDiSAssHubList',
         data: {
             CustId: custId,
             hubId: hubId
         },
         success: function(result) {
             DisAssHubList = JSON.parse(result);
             // $('#uhubList').append('<option value="1">ALL</option>')
             for (var i = 0; i < DisAssHubList["disAssHubName"].length; i++) {
                 var hubid = DisAssHubList["disAssHubName"][i].hubId;
                 var hubName = DisAssHubList["disAssHubName"][i].hubName;
                 $('#uhubList').append($("<option></option>").attr("value", hubId).text(hubName));
             }
             $("#uhubList").select2({
             	});

         }
     });

 }

 var table;

 function getExcavationTripReport() {
     var custId = document.getElementById("customerList").value;
     var tpId = document.getElementById("tpOwnerList").value;
     var assetNumber = document.getElementById("boatList").options[document.getElementById("boatList").selectedIndex].text;
     var assetId = document.getElementById("boatList").value;
    // var dateRange = document.getElementById('dateInput').value;
   //  var dateDiff = checkMonthValidation(dateRange);
   	 var startDate = document.getElementById('dateInput1').value;
  	 var endDate = document.getElementById('dateInput2').value;
  	 var dateRange=startDate+'-'+endDate;
  	 var dateDiff=monthValidation(startDate,endDate);
  	 var dayDiff=dateValidation(startDate,endDate);
     var dur = document.getElementById("distanceR").value.split(',');
     var assc = document.getElementById("associatedR").value.split(',');
     var disAssc =document.getElementById("disassocaitedR").value.split(',');
     var associatedHubId = document.getElementById("ahubList").value;
     var disAsscHubId = document.getElementById('uhubList').value;
     var aHubName = document.getElementById("ahubList").options[document.getElementById("ahubList").selectedIndex].text;
     var uHubName = document.getElementById("uhubList").options[document.getElementById("uhubList").selectedIndex].text;
     //alert(dur +"   "+assc+"   "+disAssc);
     if (custId == 0) {
         sweetAlert("Please Select Customer Name");
         return;
     }
     if (tpId == 0) {
         sweetAlert("Please Select TP Owner Name");
         return;
     }
     if (assetId == 0) {
         sweetAlert("Please Select Boat Number");
         return;
     }
     if(!dayDiff){
     	 sweetAlert("Start Date should be greater than End Date");
         return;
     }
     if (!dateDiff) {
        sweetAlert("Date Range should be maximum 30 days");
         return;
     }


     if ($.fn.DataTable.isDataTable('#example')) {
         $('#example').DataTable().destroy();
     }
     var param = {
         CustId: custId,
         tpId: tpId,
         assetNumber: assetNumber,
         assetId: assetId,
         dateRange: dateRange,
         startDur: dur[0],
         endDur: dur[1],
         startAsscDis: assc[0],
         endAsscDis: assc[1],
         startDisAsscDis: disAssc[0],
         endDisAsscDis: disAssc[1],
         associatedHubId: associatedHubId,
         disAsscHubId: disAsscHubId,
         aHubName: aHubName,
         uHubName: uHubName
     };
     table = $('#example').DataTable({
         "ajax": {
             "url": "<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getSandExcavationDetails",
             "dataSrc": "sandReport",
             "data": param,
         },
         "bLengthChange": false,

         "columns": [{
             "data": "slno"
         }, {
             "data": "assetNumber"
         }, {
             "data": "tripNumber"
         }, {
             "data": "startTime"
         }, {
             "data": "endTime"
         }, {
             "data": "totalTrip"
         }, {
             "data": "totalEtime"
         }, {
             "data": "totalEcount"
         }, {
             "data": "remarks"
         }, {
             "data": "voltage"
         }, {
             "data": "status"
         }, {
             "data": null,
             "defaultContent": "<button class='btn btn-primary'>Excavation Details</button>"
         }]
     });

     $('#example').on('click', 'td', function(event) {
         var columnIndex = table.cell(this).index().column;
         var aPos = $('#example').dataTable().fnGetPosition(this);
         var data = $('#example').dataTable().fnGetData(aPos[0]);
         var tripNumber = (data['tripNumber']);
         var assetNumber = (data['assetNumber']);
         if (columnIndex == 11) {
             // alert( assetNumber +"'s salary is: "+ assetNumber );
             $('#excavationModal').modal('show');
             getExcavationDetais(custId, tripNumber, assetNumber);
         }

     });
 }
 
  function dateValidation(date1,date2) {
     var dd = date1.split("/");
     var ed = date2.split("/");
     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
     if (endDate >= startDate ) 
	{
	  return true;
	}else{
	   return false;
	}
 }
 
  function monthValidation(date1,date2) {
     var dd = date1.split("/");
     var ed = date2.split("/");
     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
     var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
     var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
     if (daysDiff <= 29) {
         return true;
     } else {
         return false;
     }
 }

 function checkMonthValidation(dateRange) {
     var res = dateRange.split(" - ");
     var date1 = res[0].trim();
     var date2 = res[1].trim();
     var dd = date1.split("/");
     var ed = date2.split("/");
     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
     var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
     var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
     if (daysDiff <= 29) {
         return true;
     } else {
         return false;
     }
 }


 function getExcavationDetais(custId, tripNO, assetNumber) {
     if ($.fn.DataTable.isDataTable('#Edeatils')) {
         $('#Edeatils').DataTable().destroy();
     }

     document.getElementById("tripId").innerHTML = tripNO;
     document.getElementById("boatId").innerHTML = assetNumber;

     var param = {
         CustId: custId,
         tripNO: tripNO,
         assetNumber: assetNumber,

     }
     var table2 = $('#Edeatils').DataTable({
         "ajax": {
             "url": "<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getExcavationDetails",
             "dataSrc": "excavationDetails",
             "data": param,
         },
         "bLengthChange": false,
         scrollY: "300px",
         scrollX: true,
         scrollCollapse: true,
         paging: false,
         columnDefs: [{
             width: 200,
             targets: 0
         }],
         fixedColumns: true,

         "columns": [{
             "data": "slno"
         }, {
             "data": "eloc"
         }, {
             "data": "etime"
         }, {
             "data": "edur"
         }, {
             "data": "adist"
         }, {
             "data": "ahubName"
         }, {
             "data": "udis"
         }, {
             "data": "uhubName"
         }, {
             "data": "voltage"
         }]
     });



 }
	 </script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
