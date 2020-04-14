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
      <div class="panel-heading"><h3>Amazon Report</h3></div>
      <div class="panel-body">
      		
      		<div class="form-group">
      <label class="control-label col-sm-1" for="pwd">Start Date:</label>
     <div class="col-xs-12 col-md-2 col-lg-2">
							<div class='input-group date' id='dateInput1'>
								<input type='text' placeholder="start date" class="form-control"  style="margin-top:0.2%;"/>
								<span class="input-group-addon"><span
									class="glyphicon glyphicon-calendar"></span> </span>
							</div>
				</div>
       <label class="control-label col-sm-1" for="pwd">End Date:</label>
      <div class="col-xs-12 col-md-2 col-lg-2">
							<div class="form-group">
								<div class='input-group date' id='dateInput2'>
									<input type='text' placeholder="end date" class="form-control"  style="margin-top:0.2%;"/>
									<span class="input-group-addon"><span
										class="glyphicon glyphicon-calendar"></span> </span>
								</div>
							</div> 
				</div>
        <div class="col-sm-2">
        <button type="submit" onclick="getReportData()" class="btn btn-default">Submit</button>
      </div>
    </div>
  <!--</form>
--></div><br/>
	<table id="amazonReportTable"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		 <th>Sl No</th>
		                                 <th>Vendor Name</th>
		                                 <th>No of Vehicles t4u Amz</th>
		                                 <th>No Of PIngs</th>
		                       		</tr>
		                    	</thead>
		               		</table>
      </div>
  

	<script type="text/javascript">
	
	$(document).ready(function() {	
    var now=new Date();
    $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '197px', height: '25px',max: new Date()});
  	$('#dateInput1 ').jqxDateTimeInput('setDate', new Date(now));
  	$("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '197px', height: '25px',max: new Date()});
 	$('#dateInput2 ').jqxDateTimeInput('setDate', new Date(now));
 });
	
function getReportData()
{

var amazonReportTable;

 var startDate = document.getElementById('dateInput1').value;
  	 var endDate = document.getElementById('dateInput2').value;
   if ($.fn.DataTable.isDataTable('#amazonReportTable')) {
           $('#amazonReportTable').DataTable().destroy();
       }
   amazonReportTable = $('#amazonReportTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAmazonReportDetails",
		            "dataSrc": "AmazonReportDetails",
		            "data":{
		            	startDate : startDate,
		            	endDate : endDate	
		            }
		        },
		        "bProcessing": true,
		        "sScrollX": "100%",
		        "sScrollY": "400px",
		        "bDestroy": true,
		        //"lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    			},
    			"buttons": [
        				'excel'
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
}
	
	</script>
