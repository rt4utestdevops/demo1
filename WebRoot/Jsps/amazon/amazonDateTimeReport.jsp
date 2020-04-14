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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
    <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
         <script src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.0/multiple-select.js"></script>
    
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
    <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
      <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      <link href="../../Main/custom.css" rel="stylesheet" type="text/css">
      <link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css" type="text/css" />
      <link rel="stylesheet" href="https://rawgit.com/zhangtasdq/range-picker/master/dist/css/range-picker.min.css" />

      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.0/multiple-select.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>

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
      <script src="../../Main/Js/markerclusterer.js"></script>     
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
      <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	  <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	  
	  	<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/scripts/demos.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcore.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxdatetimeinput.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcalendar.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxtooltip.js"></script>
		<script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/globalization/globalize.js"></script>
	<style>
	</style>
	
 <div class="panel panel-primary">
      <div class="panel-heading"><h3>Summary Report</h3></div>
      <div class="panel-body">
      		<div class="form-group" id="vehiclevendorblock" style="display: none;">
      				<label class="col-sm-1" for="pwd">No Of Vehicles :</label>
      				<span id="vehicleCount"></span>
      				<label class="col-sm-1" for="pwd">No Of Vendor :</label>
      				<span id="vendorCount"></span>
      		</div>
      		<div class="form-group">
   			  <div class="col-xs-12 col-md-2 col-lg-2">
						<label> Date</label>	 
			  <select class="form-control" id="dateList" onchange="getReportData()">
					<option value="0">Select Date</option>
			    </select>	
				</div>
		</div>
    </div>
  <!--</form>
--></div><br/>
	<table id="amazonReportTable"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		 <th>Sl No</th>
		                                 <th>Vendor Name</th>
		                                 <th>No of Vehicles t4u AMZ</th>
		                                 <th>No Of Pings</th>
		                       		</tr>
		                    	</thead>
		               		</table>
      
	<script type="text/javascript">

	$(document).ready(function() {	
 	getVendorToVehicleDetails();
 });
	
function getReportData()
{

 var amazonReportTable;

   var startDate = document.getElementById("dateList").value;
   //alert(startDate);
   if(startDate == 0)
   {
     sweetAlert("Please Select Valid Date");
   }else
   {
	   if ($.fn.DataTable.isDataTable('#amazonReportTable')) {
	           $('#amazonReportTable').DataTable().destroy();
	   }
	   amazonReportTable = $('#amazonReportTable').DataTable({
			      	"ajax": {
			        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAmazonDateWiseReportDetails",
			            "dataSrc": "AmazonDateReportDetails",
			            "data":{
			            	startDate : startDate
			            }
			        },
			        //"bProcessing": true,
			        "sScrollX": "100%",
			        "sScrollY": "400px",
			        "bDestroy": true,
			        //"lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
			        "oLanguage": {
	       	 				"sEmptyTable": "No data available"
	    			},
	    			  "dom": 'Bfrtip',
		       		//"dom":  "<'row'<'col-sm-4 'B><'col-sm-3'><'col-sm-2 text-right'<'toolbar'>><'col-sm-2'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
	        		"buttons": [{extend:'pageLength'},
	        				{extend:'excel',
	        				title: 'SummaryReport'}
	        	 	],
		        	"lengthChange":true,
			         "columns": [{
	                	"data": "slNoIndex"
		            }, {
		                "data": "vendorNameIndex"
		            }, {
		                "data": "noOfVehiclesAmzT4uIndex"
		            }, {
		                "data": "noOfPingsIndex"
		            }]
		 		});
		 		//getVehicleVendorCount();
	 }
}
function getVehicleVendorCount(){

	var startDate = document.getElementById('dateInput1').value;
  	var endDate = document.getElementById('dateInput2').value;
	$.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehicleAndVendorCount',
        data: {
		            	startDate : startDate,
		            	endDate : endDate	
		 },
        success: function(result) {
            var report = JSON.parse(result);
            document.getElementById('vehiclevendorblock').style.display="block";
            //alert(report['VehicleVendorCountRoot'][0].VehicleCount);
            //alert(report['VehicleVendorCountRoot'][1].VendorCount);
            document.getElementById('vehicleCount').innerHTML=report['VehicleVendorCountRoot'][0].VehicleCount;
            document.getElementById('vendorCount').innerHTML=dashboard['VehicleVendorCountRoot'][1].VendorCount;    
         }
    });
}

function getVendorToVehicleDetails(){
	 var dateWise;
     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDateList',
         success: function(result) {
             dateWise = JSON.parse(result);
             for (var i = 0; i < dateWise["DateListRoot"].length; i++) {
                 var name = dateWise["DateListRoot"][i].date;
				 $('#dateList').append($("<option></option>").attr("value", name).text(name));
             }
	       }
     });
}
	
	</script>
