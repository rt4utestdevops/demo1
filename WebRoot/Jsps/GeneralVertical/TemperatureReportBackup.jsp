<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*,t4u.util.*,t4u.functions.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String regNo = "";
CommonFunctions cf = new CommonFunctions();
boolean isCustLogin = false;
 
 
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int customerId=0;
if(loginInfo != null) {

			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
 GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();
 int loginUserId=loginInfo.getUserId();
 int systemId = loginInfo.getSystemId();
 int custId= gvf.getUserAssociatedCustomerID(loginUserId,systemId);
 if(custId != 0) {
 	isCustLogin = true;
 }
 

%>
 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
	<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">	
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css"> 
 	<link rel="stylesheet" href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css" type="text/css" />
			
			
			
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
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
 	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.0/multiple-select.js"></script>
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
         
         #hourlyData, #hourlyTripData{
              height: 28px !important;
              padding: 4px 9px;
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
  .align{
         text-align:center
         }
         .panel {
         margin-bottom: 17px;
         background-color: #fff;
         border: 1px solid #333 !important;
         border-radius: 4px;
         -webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
         box-shadow: 0 1px 1px rgba(0,0,0,.05);
         }
         .percentageWell {
         float: right;
         background-color: #337ab7;
         color: #fff;
         padding: 9px;
         border-radius: 4px;
         /* border: 1px solid #333; */
         border-bottom: 1px solid #333;
         border-left: 1px solid #333;
         text-align: center;
         }
         .label{
         margin-left: 41px; 
         }
		 #description{
		   padding-right:13%;
		 }
		 #panelBox{
		    height:100px;
		 }
		 #routeList{
			 width:196.22px;
			 height: 34px;
		 }
		 #customerList{
			 width:196.22px;
			 height: 34px;
		 }
		 #add{
		 margin-top: 140px;
		 }
		 #add2{
		 margin-top: 140px;
		 }
		 #add3{
		 margin-top: 140px;
		 }
		 #add4{
		 margin-top: 140px;
		 }
		 .form-control{
		 	 width: 196.22px;
			 height: 34px;
		 }
		 .open>.dropdown-menu {
		     display: block;
		     width: 200px;
		     height: 120px !important;
		     overflow-x: auto !important;
		     overflow-y: visible !important;
		   		 }
		 .multiselect dropdown-toggle btn btn-default{
			 width:196.22px;
			 height: 34px;
		 }

		 .btn-group.open .dropdown-toggle {
		 	 width:196.22px;
			 height: 34px;
		 }
		 .multiselect-selected-text{
		 	 width:196.22px;
			 height: 34px;
		 }
		 .btn-group>.btn:first-child {
		    width: 196.22px;
		}
		.modal-title{
		text-align: center;
		}

		#page-loader{
		 position:fixed;
		 left: 20%;
		 top: 35%;
		 z-index: 1000;
		 width:100%;
		 height:100%;
		 background-position:center;
		 z-index:10000000;
		 opacity: 0.7;
		 filter: alpha(opacity=40);
		 }
		 .btn .caret {
    display: none;
}
.multiselect-container {
    overflow-y: auto;
    height: 103px !important;
}
.dropdown-menu {
min-width: 195px;
}

.garage-title {
    clear: both;
    display: inline-block;
    overflow: hidden;
    white-space: nowrap;
}
      </style>

<!--    <body onload="getTripNames();" >   -->
    
      <div class="custom">
         <div class="panel panel-primary">
               
			   <div class="panel-heading">
                  <h3 class="panel-title" >
                     Temperature Report
                  </h3>
               </div>
			   
			   <div class="panel-body">
			   <div class="col-lg-12 col-md-12">
			    <span><label >Trip wise  </label><span style="padding-left: 20px;"></span><input type="radio" value="radiotrip" name="yesno" id="yesClick" >
			   <label id="vehicleWiseId" style="padding-left: 50px;">Vehicle wise</label><span style="padding-left: 20px;"></span><input type="radio" value="radiovehicle" name="yesno" id="noClick" style="padding-left: 20px;"></span>
			   </div>
			   <div class="panel row" style="padding:1% ;margin: 0%;"> 
			   
			
			   
			   <div class="col-xs-12 col-md-12 col-lg-12 col-sm-12 row" id="tripWise" >
				   <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3  "  >
				     <select class="form-control" id="tripName" onchange="resetDataTable()">
				     	<option > </option>
				     </select> 
	               </div>
	                 <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3  " style="padding-left: 60px;">
	               <select class="form-control" id="hourlyTripData" onchange="resetDataTable()"> 
				   <option value="">Select Time Range</option> 
				   <option value="1">None</option> 
				   <option value="15">15 Minutes</option> 
				   <option value="30">30 Minutes</option> 
				   <option value="45">45 Minutes</option> 
				  <option value="60">1 Hour</option> 
				   <option value="120">2 Hours</option> 
				   <option value="180">3 Hours</option> 
				    </select> </div>
	               <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  class="btn btn-success" onclick="getTemperatureReport()">View Report</button></div>
				   <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  class="btn btn-success" onclick="getTempDetails()">View Graph</button></div>
				   
				   
				   <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  class="btn btn-primary" onclick="getReport(1)">Download Report</button></div>
				   <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 38px;"><button type="button"  class="btn btn-primary" onclick="getReport(2)">Download Graph</button></div>
			   </div>
			    <div class="col-sm-12 col-md-12 col-lg-12 col-sm-12 row" id="vehicleWise">
				   <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3 " id="vehicleWise"><select class="form-control" id="vehicleNumber" onchange="resetVehicleWiseDataTable()">
				     	<option value=""></option>
				     </select> </div>
				 <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3  " style="padding-left: 30px;">
	               <select class="form-control" id="hourlyVehicleData" onchange="resetDataTable()"> 
				   <option value="">Select Time Range</option> 
				   <option value="1">None</option> 
				   <option value="15">15 Minutes</option> 
				   <option value="30">30 Minutes</option> 
				   <option value="45">45 Minutes</option> 
				  <option value="60">1 Hour</option> 
				   <option value="120">2 Hours</option> 
				   <option value="180">3 Hours</option> 
				    </select> </div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1 garage-title" style = "margin-left: -75px; position: relative; top: 5px;"><label   id="startDateLabelId" >Start Date:</label></div>
				   <div class="col-sm-2 col-md-2 col-lg-2 col-sm-2 " style = "margin-left: -17px; position: relative; top: 5px;"><input type='text'  id="dateInput1" /></div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1 garage-title" style = "position: relative; top: 5px;"><label  id="endDateLabelId">End Date:</label></div>
				   <div class="col-sm-2 col-md-2 col-lg-2 col-sm-2 " style = "margin-left: -16px; position: relative; top: 5px;"><input type='text'  id="dateInput2" /></div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1 " ><button type="button"  class="btn btn-success" onclick="getVehicleWiseTemperatureReport()" >View Report</button></div>
<!--				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1" style="margin-top: 10px; margin-left: 8px;" ><button type="button"  class="btn btn-success" onclick="getTempDetails()">View Graph</button></div>-->
				   
				   
			   </div>
			    
			    </div>  <!--End of header Panel-->
			    
			    
			    <div class="panel row" style="padding:1% ;margin: 0%;" id ="tripVehicles"> 
			   <div class="col-lg-12 col-md-12" >
			   
			     <label>Vehicle No: </label> <label id="vehicleNo" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>Start Date: </label> <label id="startdate" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>End Date: </label> <label id="endDate" style="font-weight: 300;padding-right: 40px;"></label>
			  
			   </div>
			    <div class="col-lg-12 col-md-12 " >
					    <div class="col-lg-1 col-md-1"></div>
					    <div class="col-lg-10 col-md-10 " style="padding:1% ;margin: 0%;" id='placeholderForTemperatureRange'></div>
					    <div class="col-lg-1 col-md-1"></div>
						    </div>
			    </div>  <!--End of header Panel-->
			     <div class="center-view" style="display:none;" id="loading-div">
            	  <img src="../../Main/images/loading.gif" alt="">
           		</div>
			   
			    			   <div style="overflow: auto !important;">
			   <table id="vehicleWiseTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%;display:none;">
					<thead>
						<tr>
							<th>Sl No</th>
						    <th>T1</th>
							<th>T2</th>
							<th>T3</th>
							<th>Location</th>
							<th>Date & Time</th>
					 </tr>
					</thead>	
							
				</table>
				</div>	<!-- end of table -->
			    <div style="overflow: auto !important;">
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">

				</table>
				</div>	<!-- end of table -->
			   
			   </div>  <!-- end of panel body -->
	  </div> <!-- end of panel  -->
	  </div> <!-- end of main div : custom -->
	  
	 <div id="add" class="modal fade" style="width: 90%;margin-left: 63px;margin-top: 76px;">
         <div class="modal-content">
            <div class="modal-header" >
               <div class="secondLine" style="align-items:baseline;padding-right:880px;">
                  Category: 
                     <select class="form-control" multiple="multiple" id="tempCombo"  onchange=""  >
			     </select>
			     </div>
                  <button type="button" class="close" data-dismiss="modal">&times;</button>              
            </div>
            <div class="col-lg-12" >
               <div id = "tempForGraph"></div>
               </div>
            <div class="modal-body" style="height: 100%;">
               
               <div class="row">
                  <div class="col-lg-12">
                  	<input class="btn-success" id="save-pdf" type="button" value="Save as PDF" disabled />
                      <div id="chart_div"></div>
                  </div>
               </div>
            </div>
            <div class="modal-footer"  style="text-align: right; height:75px;" >
           <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px;">Close</button>
            </div>
         </div>
      </div>
      <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
     <script type="text/javascript">
     var status = "";
     var timerange = "";
	 
     function getReport(type) {
		
	     if(status == 'OPEN') {
	     	sweetAlert("The trip is open.Cannot generate the report");
	     	return;
	     }
	     if(document.getElementById("tripName").value == "0"){
		    sweetAlert("Please select Trip name");
		    return;
		}
		
     	window.open("<%=request.getContextPath()%>/TemperatureServlet?tripId="+tripId+"&type="+type);
     }
	  window.onload = function () { 
		getTripNames();
	}
	var columnArr = [];
     var currentDate = new Date();
     var yesterdayDate = new Date();
         yesterdayDate.setDate(yesterdayDate.getDate() - 1);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);
     var startDate;
	 var endDate;
	 var regNo;
	  var click = 0;
	  var reportName ;
	  var tempInfoText="";
	  var tempInfoHTML = "";
	  var hourlyRange = "";
	    var hourlyRange1 = "";
 $(document).ready(function () {
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
   
});
	 
	 $('input:radio[name=yesno]').change(function() {
        if (this.value == 'radiotrip') {
           $("#tripName").val(0).trigger('change');
           $('#startDateLabelId').hide();
           $('#dateInput1').hide();
           $('#endDateLabelId').hide();
           $('#dateInput2').hide();
           $('#vehicleWise').hide();
           $('#tripWise').show();
          // $('#tripVehicles').show(); 
           if(document.getElementById("vehicleNumber").value){
	          $("#vehicleNumber").select2("val", "");
	       }
	       $("#dateInput1").val(yesterdayDate);
	       $("#dateInput2").val(currentDate);
	       $("#placeholderForTemperatureRange").show();  
        }
        if (this.value == 'radiovehicle') {
           $("#vehicleNumber").val(0).trigger('change');
           $('#startDateLabelId').show();
           $('#dateInput1').show();
           $('#endDateLabelId').show();
           $('#dateInput2').show();
           $('#vehicleWise').show();
           $('#tripWise').hide();      
           $('#tripVehicles').hide(); 
           if(document.getElementById("tripName").value){
	          $("#tripName").select2("val", "");
	       }
	       $("#placeholderForTemperatureRange").hide();  
	        tempInfoText="";
	        tempInfoHTML = "";
        }
    });
    
    function resetDataTable()
    {
    	if($.fn.DataTable.isDataTable("#vehicleWiseTable"))
    	{
    		$("#vehicleWiseTable").DataTable().clear().destroy();  
    		$('#vehicleWiseTable').empty();  
    		//columnArr = [];
    	}
    	
    }
	
	function resetVehicleWiseDataTable()
    {
		if($.fn.DataTable.isDataTable("#example"))
    	{
    		$("#example").DataTable().clear().destroy();  
    		$('#example').empty();  
    		columnArr = [];
    	}
    	
    }
	
 function getTemperatureReport(){
 	var vehicleNo;
 	$("#vehicleWiseTable").css("display", "none");
	if(document.getElementById("yesClick").checked){
		vehicleNo = document.getElementById("vehicleNo").innerHTML;
		if(document.getElementById("tripName").value == "0"){
		    sweetAlert("Please select Trip name");
		    return;
		}
		if(document.getElementById("hourlyTripData").value == ""){
		    sweetAlert("Please select time range");
		    return;
		}
		var reportName1 = $('#tripName option:selected').text();
		reportName1 = reportName1.split('-');
		reportName  = reportName1[0];
		hourlyRange = document.getElementById("hourlyTripData").value;
		
	}
	else if(document.getElementById("noClick").checked){
		vehicleNo = document.getElementById("vehicleNumber").value;
	    if(document.getElementById("vehicleNumber").value == "0"){
		    sweetAlert("Please select Vehicle Number");
		    return;
		}else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else if(document.getElementById("hourlyData").value == ""){
		    sweetAlert("Please select time range");
		    return;
		}else{
			
				regNo = document.getElementById("vehicleNumber").value;
				startDate = document.getElementById("dateInput1").value;
				endDate = document.getElementById("dateInput2").value;
				hourlyRange = document.getElementById("hourlyData").value;
				var dd = startDate.split("/");
		        var ed = endDate.split("/");
		        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
		        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
					if (parsedStartDate > parsedEndDate) {
			        	sweetAlert("End date should be greater than Start date");
			       	    document.getElementById("dateInput2").value = currentDate;
			       	    return;
			   		}
			    reportName = regNo;
		}		
	}
	if ($.fn.DataTable.isDataTable('#example')) {
	    $('#example').DataTable().destroy();	   
	}
	$('#loading-div').show();
    
	getConfigurationDetails(regNo,'');
       
	setTimeout(function(){
    var table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTemperatureReport",
                "dataSrc": "tempReportRoot",
                  "data": {
					startdate: startDate,
					enddate: endDate,
					vehicleNo: regNo,
					hourlyRange: hourlyRange
               }
            },
            "bLengthChange": false,
            "dom": 'Bfrtip',
       		"buttons": [{extend:'pageLength'},
	       				{
	       				extend:'excel',
	       					text: 'Export to Excel',
		      	 			className: 'btn btn-primary',
		      	 			title: 'Temperature_Report'+'_'+reportName ,
		      	 			messageTop: tempInfoText,
		      	 			exportOptions: {
				            	columns: ':visible'
				            }
			            },{
                extend: 'pdfHtml5',
                customize: function (doc) { doc.defaultStyle.fontSize = 8;
        		doc.content[1].table.widths = [100,100,100,100,100,100,100,100];
                },
                orientation: 'landscape',
                pageSize: 'A4',
                alignment: 'center',
                text: 'Export to PDF',
                className: 'btn btn-primary',
                title: 'Temperature_Report'+'_'+reportName ,
                messageTop: tempInfoText,
	      	 	exportOptions: {
			    columns: ':visible'
			     }
            	}],
		        "columns": columnArr
        });
        if(<%=isCustLogin%>) {
        	table.column( 1 ).visible( false );
        	table.column( 2 ).visible( false );
        	table.column( 3 ).visible( false );
        }
        
        }, 2000);
        $('#loading-div').hide();
       }
       
function getVehicleWiseTemperatureReport(){
 	var vehicleNo;
	if(document.getElementById("yesClick").checked){
		vehicleNo = document.getElementById("vehicleNo").innerHTML;
		if(document.getElementById("tripName").value == "0"){
		    sweetAlert("Please select Trip name");
		    return;
		}
		if(document.getElementById("hourlyTripData").value == ""){
		    sweetAlert("Please select time range");
		    return;
		}
		var reportName1 = $('#tripName option:selected').text();
		reportName1 = reportName1.split('-');
		reportName  = reportName1[0];
		hourlyRange = document.getElementById("hourlyTripData").value;
		
	}
	else if(document.getElementById("noClick").checked){
		vehicleNo = document.getElementById("vehicleNumber").value;
	    if(document.getElementById("vehicleNumber").value == "0"){
		    sweetAlert("Please select Vehicle Number");
		    return;
		}else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else if(document.getElementById("hourlyVehicleData").value == ""){
			 sweetAlert("Please select time range");
		    return;
		}else{
			
				regNo = document.getElementById("vehicleNumber").value;
				startDate = document.getElementById("dateInput1").value;
				endDate = document.getElementById("dateInput2").value;
				hourlyRange1 = document.getElementById("hourlyVehicleData").value;
				var dd = startDate.split("/");
		        var ed = endDate.split("/");
		        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
		        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
					if (parsedStartDate > parsedEndDate) {
			        	sweetAlert("End date should be greater than Start date");
			       	    document.getElementById("dateInput2").value = currentDate;
			       	    return;
			   		}
			    reportName = regNo;
		}		
	}
	$("#vehicleWiseTable").css("display", "block");
	if ($.fn.DataTable.isDataTable('#vehicleWiseTable')) {
	    $('#vehicleWiseTable').DataTable().destroy();	   
	}
    
    var table = $('#vehicleWiseTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehicleWiseTemperatureReport",
                "dataSrc": "temperatureReportRoot",
                  "data": {
					startdate: startDate,
					enddate: endDate,
					vehicleNo: regNo,
					hourlyRange1:hourlyRange1
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
			            },{
			            extend:'pdf',
       					text: 'Export to Pdf',
	      	 			className: 'btn btn-primary',
	      	 			title: 'Temperature Report',
	      	 			exportOptions: {
			                columns: ':visible'
			            }
			            }],
       		columnDefs: [
		            { width: 50, targets: 0 },
		            { width: 50, targets: 1 },
		            { width: 50, targets: 2 },
					{ width: 50, targets: 3 },
		            { width: 300, targets: 4 },
					{ width: 150, targets: 5 }
		        ],
            "columns": [{
                "data": "slno"
            }, {
                "data": "t1"
            }, {
                "data": "t2"
            }, {
                "data": "t3"
            }, {
                "data": "location"
            },{
                "data": "datetime"
            }]
        });
        if(<%=isCustLogin%>) {
        	table.column( 1 ).visible( false );
        	table.column( 2 ).visible( false );
        	table.column( 3 ).visible( false );
        }
        
        //}, 2000);
       }
			var tripId;
	$('#tripName').change(function() {
	    $('#tripVehicles').hide(); 
		$("#placeholderForTemperatureRange").empty();
        tripId = $('#tripName option:selected').attr('value');
        if(tripId > 0){
        	getTripData(tripId);
        }
       document.getElementById("hourlyTripData").value = "";
       
    });
    $('#vehicleNumber').change(function() {
    	//document.getElementById("hourlyData").value = "";
    });
    
      
    function getTripNames(){
	    tripArray=[];
		$.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTrip',
	        data: {
              custId:'<%=custId%>'
            },
	          success: function(result) {
	           tripList = JSON.parse(result);
	           $('#tripName').append($("<option></option>").attr("value","0").text("Select Trip"));
		       for (var i = 0; i < tripList["tripNames"].length; i++) {
				   $('#tripName').append($("<option></option>").attr("value",tripList["tripNames"][i].tripId).text(tripList["tripNames"][i].tripName));
			   }
				$("#tripName").select2();
				$("#tripName").val(0).trigger('change');
			}
		});
		getVehicle();
		document.getElementById("yesClick").checked = true;
		$('#startDateLabelId').hide();
        $('#dateInput1').hide();
        $('#endDateLabelId').hide();
        $('#dateInput2').hide();
        $('#vehicleWise').hide();
    }
    function getVehicle(){
		var vehicleAarray=[];
		var vehicles = [];
		$.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehicles',
	          success: function(result) {
	                  vehicles = JSON.parse(result); 
	         	$('#vehicleNumber').append($("<option></option>").attr("value","0").text("Select Vehicle"));
	            for (var i = 0; i < vehicles["vehicleDetails"].length; i++) {
				vehicleAarray.push(vehicles["vehicleDetails"][i].vehicleNo);
				   $('#vehicleNumber').append($("<option></option>").attr("value",vehicles["vehicleDetails"][i].vehicleNo).text(vehicles["vehicleDetails"][i].vehicleNo));			
				}
	            $("#vehicleNumber").select2();	
	            $("#vehicleNumber").val(0).trigger('change');           	            
			}
		});
    }
    var minGreenTemp;
	var maxGreenTemp;
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
                status = results["tripData"][0].status;
                timerange = results["tripData"][0].timerange;
                document.getElementById("vehicleNo").innerHTML = regNo;
                document.getElementById("startdate").innerHTML = startDate;
                if(results["tripData"][0].status=='OPEN'){
                	 document.getElementById("endDate").innerHTML = '';
                } else{
                	 document.getElementById("endDate").innerHTML = endDate;
                }
               
                tempInfoText = results["tripData"][0].tblDataExport ;
                tempInfoHTML = results["tripData"][0].tblData;
				minGreenTemp = results["tripData"][0].minGreenRange;
				maxGreenTemp = results["tripData"][0].maxGreenRange;
                $("#placeholderForTemperatureRange").empty();  
		 		document.getElementById("placeholderForTemperatureRange").innerHTML = results["tripData"][0].tblData;
		 		 $('#tripVehicles').show(); 
		 		
            }
        });
    }
    
    var btnSave = document.getElementById('save-pdf');
     var chart1 ;//new google.visualization.LineChart(document.getElementById('chart_div'));
    
     btnSave.addEventListener("click", function h(e) {
                               var doc = new jsPDF('landscape');
								 doc.setFontSize(10);
    							 doc.setTextColor(40);
   							 	 doc.setFontStyle('normal');
   								 doc.text(tempInfoText ,10, 100);
                                 doc.addImage(chart1.getImageURI(), -10, 0);
                                 doc.save('chart.pdf');
                            });
   $('#tempCombo').change(function() { 
    var selectedcombo = "";
	var combolength=$('#tempCombo > option').length;
      tempData =$("#tempCombo option:selected");
	  tempData.each(function () {
            selectedcombo += $(this).val() + ",";
        });
        console.log('tempData== '+tempData.length);
        
        if(<%=isCustLogin%>) {
        	console.log('selectedcombo=='+selectedcombo);
        	getIndividualTemp(selectedcombo);
        } else {
        	if(tempData.length==combolength){
	        	getTempDetailsForAll();
	        }else{
	        	getIndividualTemp(selectedcombo);
	        }
        }
    });
    
    function getTempDetails(){
    
	    if(document.getElementById("yesClick").checked){
		    if(document.getElementById("tripName").value == "0"){
			    sweetAlert("Please select Trip name");
			    return;
			}
			if(document.getElementById("hourlyTripData").value == ""){
		    sweetAlert("Please select time range");
		    return;
		   }
		}
		else if(document.getElementById("noClick").checked){
		    if(document.getElementById("vehicleNumber").value == "0"){
		    sweetAlert("Please select Vehicle Number");
		    return;
		}else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else if(document.getElementById("hourlyData").value == ""){
		    sweetAlert("Please select time range");
		    return;
		}else{
			
				regNo = document.getElementById("vehicleNumber").value;
				startDate = document.getElementById("dateInput1").value;
				endDate = document.getElementById("dateInput2").value;
				hourlyRange = document.getElementById("hourlyData").value;
				var dd = startDate.split("/");
		        var ed = endDate.split("/");
		        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
		        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
					if (parsedStartDate > parsedEndDate) {
			        	sweetAlert("End date should be greater than Start date");
			       	    document.getElementById("dateInput2").value = currentDate;
			       	    return;
			   		}
		}
		}
	    getConfigurationDetails(regNo,'graph');
	     $(".modal-header #tripEventsTitle").text("Temperature Graph for "+regNo+" From  "+startDate+" To  "+endDate);
	     $('#add').modal('show');
	     
	     
	     if(<%=isCustLogin%>) {
	     
		     setTimeout(function(){
	                 	$('#tempCombo').trigger('change');
	         }, 4000);
         } else {
         	getTempDetailsForAll();
         }
     }
    
     function getIndividualTemp(temp){
     	 $("#chart_div").html('<div class="center-view"><img src="../../Main/images/loading.gif" alt=""></div>');
		google.charts.load('current', {'packages':['corechart']});
      	google.charts.setOnLoadCallback(drawChart1(temp));
	}
	function drawChart1(temp) {
	
			   $.ajax({
                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTempDetails',
                        data: {
                        	vehicleNo: regNo,
							startdate: startDate,
							category: temp,
							enddate: endDate,
							hourlyRange: hourlyRange
                        },
                        success: function(response) {
                            tempList = JSON.parse(response);
                            $("#tempForGraph").empty();  
		 					document.getElementById("tempForGraph").innerHTML = tempInfoHTML;
                           	var t=temp.substring(0, temp.length-1);
                            var tempArr=t.split(",");
                            if(tempList["tempRoot"].length>0){
                            var data = new google.visualization.DataTable();
                            data.addColumn('string', 'Time');
                            for(var k=0;k<tempArr.length;k++){
                            	data.addColumn('number', tempArr[k]);
                            }
							data.addColumn('number', 'Min Green Range');
							data.addColumn('number', 'Max Green Range');
                            for (var i = 0; i < tempList["tempRoot"].length; i++) {
                                var arr = [];
                                arr.push(tempList["tempRoot"][i].DATE);
							
                                if(tempArr.length==2) {
                                	arr.push(Number(tempList["tempRoot"][i].TEMP));
                                	arr.push(Number(tempList["tempRoot"][i].TEMP1));
                                } else if (tempArr.length==3) {
									arr.push(Number(tempList["tempRoot"][i].TEMP));
                                	arr.push(Number(tempList["tempRoot"][i].TEMP1));
									arr.push(Number(tempList["tempRoot"][i].TEMP2));
								} else {
                                	arr.push(Number(tempList["tempRoot"][i].TEMP));
                                }
								arr.push(minGreenTemp);
								arr.push(maxGreenTemp);
                                data.addRows([arr]);
                            }
                            
                            var options = {  
                                title: 'Temperature Graph - '+regNo+'. From  '+startDate+' To  '+endDate,
                                height: 350,
                                width: 1120,
                                vAxis: {
	                             format: 'decimal'
	                         	},
                                hAxis: {
                                    direction: 1,
                                    slantedText: true,
                                    slantedTextAngle: 315
                                },
								series: {
									
          						}
                            };
                           $("#chart_div").html('');
                           var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                           var chart_div = document.getElementById('chart_div');
                           chart1=chart;
						   google.visualization.events.addListener(chart, 'ready', function () {
						    	btnSave.disabled = false;
						   });
      					   chart.draw(data, options);
      					   
      					   }else{
      					   		$('.modal').modal('hide');
      					   		sweetAlert("No records Found");
      					   }
                        }
                    });
		}
   function getTempDetailsForAll(){
   		$("#chart_div").html('<div class="center-view"><img src="../../Main/images/loading.gif" alt=""></div>');
		if(hourlyRange == "") {hourlyRange = document.getElementById("hourlyTripData").value;}
		google.charts.load('current', {'packages': ['corechart'], 'callback': drawCharts});
		
		
		function drawCharts() {
			   $.ajax({
                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTemperatureReport',
                        data: {
                        	vehicleNo: regNo,
							startdate: startDate,
							enddate: endDate,
							hourlyRange: hourlyRange
                        },
                        success: function(response) {
                            tempList = JSON.parse(response);
                            $("#tempForGraph").empty();  
		 					document.getElementById("tempForGraph").innerHTML =tempInfoHTML;
		 					
                            if(tempList["tempReportRoot"].length>0){
	                            var data = new google.visualization.DataTable();
	                            data.addColumn('string', 'Time');
	                            for(var j = 0; j < headerArrayAj.length; j++){
	                               data.addColumn('number', headerArrayAj[j]+'(°C)');
			                    }
								data.addColumn('number', 'T@Container');
								data.addColumn('number', 'Min Green Range');
								data.addColumn('number', 'Max Green Range');
								
	                            for (var i = 0; i < tempList["tempReportRoot"].length; i++) {
	                                var arr = [];
	                                arr.push(tempList["tempReportRoot"][i].gmt);
	                                for(var j = 0; j < headerArrayAj.length; j++){
	                                   arr.push(Number(tempList["tempReportRoot"][i][headerArrayAj[j].replace(/\s/g, '')]));
	                                }
									arr.push(Number(tempList["tempReportRoot"][i].finalTemp));
									arr.push(Number(minGreenTemp));
									arr.push(Number(maxGreenTemp));
									
									
	                                data.addRows([arr]);
	                            }
	                            var options = {
	                                title: 'Temperature Graph of - '+regNo+'. From  '+startDate+' To  '+endDate,
	                                height: 330,
	                                width: 1120,
	                                vAxis: {
		                             format: 'decimal'
		                         	},
	                                hAxis: {
	                                    direction: 1,
	                                    slantedText: true,
	                                    slantedTextAngle: 315
	                                }
	                            };
	                            $("#chart_div").html('');
	                          	var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
								var chart_div = document.getElementById('chart_div');
                                 chart1=chart;
							  	google.visualization.events.addListener(chart, 'ready', function () {
							    	btnSave.disabled = false;
							  	});
								chart.draw(data, options);
                           }else{
                           		$('.modal').modal('hide');
                           		sweetAlert("No records Found");
                           }
                        }
                    });
       		}
		}
	var headerArrayAj=[];
	var dataArray=[];
	function getConfigurationDetails(regNo,graph){
	 columnArr = [];
	 headerArrayAj=[];
	 $('#tempCombo').empty();
		$.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTempConfigurations',
            data: {
              regNo:regNo
            },
             success: function(result) {
                 json = JSON.parse(result);
                 headerArrayAj = json["tempConfigDetails"][0];
                 dataArray = json["tempConfigDetails"][1];
                 
                 if(graph!=''){
                 if(!<%=isCustLogin%>) {
                 	for (var i = 0; i < headerArrayAj.length; i++) {
	                   $('#tempCombo').append($("<option></option>").attr("value",headerArrayAj[i]).text(headerArrayAj[i]));
	               }
                 }
                 $('#tempCombo').append($("<option></option>").attr("value",'T@Container').text('T@Container'));
				   
	            $('#tempCombo').multiselect({
	            nonSelectedText:'Select Category',
 				includeSelectAllOption: true,
 				 numberDisplayed: 1
 				});
				$("#tempCombo").multiselect('selectAll', false);
  				$("#tempCombo").multiselect('updateButtonText');
                 } else {
                    columnArr.push({ "title": "Sl No","data": "slno"});
				    //columnArr.push({ "title": "Vehicle No","data": "vehicleNo"});
				    for(var j = 0; j < headerArrayAj.length; j++){
				       columnArr.push({ "title": headerArrayAj[j],"data": dataArray[j]});
				    }
					columnArr.push({ "title": "T@Container","data": "finalTemp"});
				    columnArr.push({ "title": "Location","data": "location"});
				    columnArr.push({ "title": "Date & Time","data": "dateTime"});
					
                 }
            }
        });
	}
	
 </script>
   
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->