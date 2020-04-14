<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int customerId=0;
if(loginInfo != null){

			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>
 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
	<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">	
      
 <link rel="stylesheet" href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css" type="text/css" />
			
			
			
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
   
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert.min.js"></script>

	 <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/scripts/demos.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/globalization/globalize.js"></script>
    
     <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.5/jspdf.min.js"></script>
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }
         #tempCombo{
         	    margin-right: 930px;
         }
        .select2-container{
         	width:300px !important;
         }
          .center-view{
						width:100%;
						margin-left:48%;
				}

      </style>
 
      <div class="custom">
         <div class="panel panel-primary">
               
			   <div class="panel-heading">
                  <h3 class="panel-title" >
                     Alert Report
                  </h3>
               </div>
			   
			   <div class="panel-body">

			   <div class="panel row" style="padding:1% ;margin: 0%;"> 
			   
			
			   
			   <div class="col-xs-12 col-md-12 col-lg-12 col-sm-12 row" id="tripWise" >

				   <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3  "  >
				     <select class="form-control" id="reportTypeId">
				     	<option value="0" selected>Select Report</option>
				     	<option value="1">Temperature</option>
				     	<option value="2">Door</option>
				     </select> 
	               </div>

				   <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3  "  >
				     <select class="form-control" id="tripName">
				     	<option value="0">Select Trip Number</option>
				     </select> 
	               </div>
	               <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  class="btn btn-success" onclick="getReportData()">View Report</button></div>
<!--				   <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  class="btn btn-success" onclick="getTempDetails()">View Graph</button></div>-->
			   </div>
	    
			    </div>  <!--End of header Panel-->
			    
			    
			    <div class="panel row" style="padding:1% ;margin: 0%;" id ="tripVehicles"> 
			   <div class="col-lg-12 col-md-12" >
			   
			     <label>Vehicle No: </label> <label id="vehicleNo" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>Start Date: </label> <label id="startdate" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>End Date: </label> <label id="endDate" style="font-weight: 300;padding-right: 40px;"></label>
			  
			   </div>
			    
			    </div>  <!--End of header Panel-->
			    
			    <div id = "tempDiv" style="overflow: auto !important;">
			   <table id="temperatureTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
					<th>SL. No</th>
					<th>Vehicle No.</th>
					<th>Name</th>
					<th>Value</th>
					<th>Date Time</th>
					<th>Location</th>
<!--					<th>Description</th>-->
					<th>Remarks</th>
					<th>Acknowlodged By</th>
					<th>Acknowlodged Date Time</th>
					 </tr>
					</thead>	
							
				</table>
				</div>	<!-- end of temp table -->
				
				<div id = "doorDiv" style="display: none;">
			   <table id="doorTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
					<th>SL. No</th>
					<th>Vehicle No.</th>
					<th>Door No.</th>
					<th>Alert Type</th>
					<th>Time of Opening</th>
					<th>Time of Closing</th>
					<th>Duration (sec)</th>
					<th>Opening Location</th>
					<th>Closing Location</th>
					<th>Status</th>
					<th>Acknowledged By</th>
					<th>Acknowledged DateTime</th>
					 </tr>
					</thead>	
							
				</table>
				</div>	<!-- end of table -->
			   
			   </div>  <!-- end of panel body -->
	  </div> <!-- end of panel  -->
	  </div> <!-- end of main div : custom -->
	  
      <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
     <script type="text/javascript">
	  window.onload = function () { 
		getTripNames();
	}
	
     var currentDate = new Date();
     var yesterdayDate = new Date();
         yesterdayDate.setDate(yesterdayDate.getDate() - 2);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);
     var startDate;
	 var endDate;
	 var regNo;
	 
 $(document).ready(function () {
   
<!--   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});-->
<!--   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);-->
<!--   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});-->
<!--   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);-->
   
});
	 

    function getReportData(){
    
    var reportType = document.getElementById("reportTypeId").value;
    if(reportType == "0"){
			    sweetAlert("Please select Report");
			    return;
			}
    if(document.getElementById("tripName").value == "0"){
			    sweetAlert("Please select Trip Number");
			    return;
			}
        if(reportType == '1'){
    		getTemperatureReport();
    		document.getElementById("doorDiv").style.display = "none";
    		document.getElementById("tempDiv").style.display = "block";
    		
    		
    	}else if(reportType == '2'){
    		getDoorReport();
    		document.getElementById("tempDiv").style.display = "none";
    		document.getElementById("doorDiv").style.display = "block";
    	}
    }
    
    function resetDataTable()
    {
    	if($.fn.DataTable.isDataTable("#temperatureTable"))
    	{
    		$("#temperatureTable").DataTable().clear().destroy();    		
    	}
    	if($.fn.DataTable.isDataTable("#doorTable"))
    	{
    		$("#doorTable").DataTable().clear().destroy();    		
    	}
    }
	
 function getTemperatureReport(){
    
	if ($.fn.DataTable.isDataTable('#temperatureTable')) {
	    $('#temperatureTable').DataTable().destroy();	   
	}
    var table = $('#temperatureTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/TripBasedReportAction.do?param=getTemperatureAlertReport",
                "dataSrc": "tempReportRoot",
                  "data": {
					startdate: startDate,
					enddate: endDate,
					vehicleNo: regNo
               }
            },
            "bLengthChange": false,
             "dom": 'Bfrtip',
       		"buttons": [{extend:'pageLength'},
	       				{
	       				extend:'excel',
	       					text: 'Export to Excel',
		      	 			className: 'btn btn-primary',
		      	 			title: 'Temperature Report',
		      	 			exportOptions: {
				            	columns: ':visible'
				            }
			            },
<!--			            {-->
<!--			            extend:'pdf',-->
<!--       					text: 'Export to Pdf',-->
<!--	      	 			className: 'btn btn-primary',-->
<!--	      	 			title: 'Temperature Alert Report',-->
<!--	      	 			exportOptions: {-->
<!--			                columns: ':visible'-->
<!--			            }-->
<!--			            }-->
			            ],
       		columnDefs: [
		            { width: 30, targets: 0 },
		            { width: 50, targets: 3 },
		            { width: 50, targets: 1 },
		            { width: 50, targets: 2 },
		            { width: 400, targets: 5 },
		            { width: 200, targets: 6 }
		        ],
            "columns": [{
             "data": "slnoIndex"
         }, { 
             "data": "vehicleNoIndex"
         },{
             "data": "alertNameIndex"
         }, {
             "data": "tempIndex"
         }, {
             "data": "dateTimeIndex"
         }, {
             "data": "locationIndex"
         }, 
<!--         {-->
<!--             "data": "descriptionIndex"-->
<!--         }, -->
         {
             "data": "remarksIndex"
         }, {
             "data": "ackByIndex"
         }, {
             "data": "ackDateTimeIndex"
         }]
        });
       }
       
       
function getDoorReport(){
    
	if ($.fn.DataTable.isDataTable('#doorTable')) {
	    $('#doorTable').DataTable().destroy();	   
	}
    var table = $('#doorTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/TripBasedReportAction.do?param=getDoorAlertReport",
                "dataSrc": "doorReportRoot",
                  "data": {
					startdate: startDate,
					enddate: endDate,
					vehicleNo: regNo
               }
            },
            "bLengthChange": false,
             "dom": 'Bfrtip',
       		"buttons": [{extend:'pageLength'},
	       				{
	       				extend:'excel',
	       					text: 'Export to Excel',
		      	 			className: 'btn btn-primary',
		      	 			title: 'Door Alert Report',
		      	 			exportOptions: {
				            	columns: ':visible'
				            }
			            }
<!--			            ,{-->
<!--			            extend:'pdf',-->
<!--       					text: 'Export to Pdf',-->
<!--	      	 			className: 'btn btn-primary',-->
<!--	      	 			title: 'Door Alert Report',-->
<!--	      	 			exportOptions: {-->
<!--			                columns: ':visible'-->
<!--			            }-->
<!--			            }-->
			            ],
       		columnDefs: [
<!--		            { width: 30, targets: 0 },-->
<!--		            { width: 200, targets: 3 },-->
<!--		            { width: 50, targets: 1 },-->
<!--		            { width: 50, targets: 2 },-->
<!--		            { width: 100, targets: 4 },-->
<!--		            { width: 100, targets: 5 },-->
		            { width: 300, targets: 7 },
		            { width: 300, targets: 8 }
		        ],
            "columns": [{
		 "data": "slnoIndex"
		}, { 
		 "data": "vehicleNoIndex"
		},{
		 "data": "doorNoIndex"
		},{
		 "data": "alertTypeIndex"
		},{
		 "data": "startTimeIndex"
		}, {
		 "data": "endTimeIndex"
		}, {
		 "data": "durationIndex"
		},{
		 "data": "startLocIndex"
		},{
		 "data": "endLocIndex"
		},{
		 "data": "statusIndex"
		},{
		 "data": "ackByIndex"
		},{
		 "data": "ackDateTimeIndex"
		}
		]
        });
       }
			
	$('#tripName').change(function() {
        tripId = $('#tripName option:selected').attr('value');
        if(tripId){
        	getTripData(tripId);
        }
    });

    function getTripNames(){
	    tripArray=[];
		$.ajax({
	        url: '<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTrip',
	          success: function(result) {
	           tripList = JSON.parse(result);
		       for (var i = 0; i < tripList["tripNames"].length; i++) {
				   $('#tripName').append($("<option></option>").attr("value",tripList["tripNames"][i].tripId).text(tripList["tripNames"][i].tripName));
			   }
				$("#tripName").select2();
			}
		});
}

    function getTripData(tripId){
    	$.ajax({
            url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripData",
            data: {
              tripId:tripId
            },
            "dataSrc": "tripData",
            success: function(result) {
                results = JSON.parse(result);
                regNo=results["tripData"][0].assetNo;
                startDate=results["tripData"][0].startDate;
                endDate=results["tripData"][0].endDate;
                
                document.getElementById("vehicleNo").innerHTML = regNo;
                document.getElementById("startdate").innerHTML = startDate;
                document.getElementById("endDate").innerHTML = endDate;
            }
        });
    }

    
 </script>
   
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->