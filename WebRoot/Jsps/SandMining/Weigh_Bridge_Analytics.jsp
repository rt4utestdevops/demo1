<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
    int customerId = loginInfo.getCustomerId();
    int userId =loginInfo.getUserId();
    String username = loginInfo.getUserName();
    String countryName = cf.getCountryName(countryId);
    Properties properties = ApplicationListener.prop;
    String vehicleImagePath = properties.getProperty("vehicleImagePath");
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
%>
<jsp:include page="../Common/header.jsp" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

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

#driverEffTable_filter{
   margin-top: -34px;
}

table {
font-size: smaller;
}
    
.dataTables_scrollBody{
  overflow-y: auto !important;
  overflow-x: hidden !important;
}

@media (min-width: 576px){
.form-inline label {
    margin-top: 20px !important;    
    margin-left: 1000px !important;
}
}

div.dataTables_wrapper div.dataTables_paginate {   
    margin-left: 986px  !important;
}
.select2 {
width: 144px !important;
}

body {
 
  font-family: "Tahoma", Geneva,  sans-serif !important;
}

.form-control{
	display : none !important;
}
label {
	display : none !important;
}


</style>

  
<!--  <body>-->
<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
			Analytical Weigh-Bridge Report
		</h3>
	</div>
	<div class="panel-body" style="margin-bottom: 3%;">
		<div class="row" style="margin-bottom: 2%;">
<!--			<div class="col-sm-3 col-md-3">-->
<!--				<label for="staticEmail2" class="col-sm-4 col-md-4">-->
<!--					Customer-->
<!--				</label>-->
<!--				<select class="col-sm-6 col-md-6" id="custDropDownId"-->
<!--					data-live-search="true" onchange="getVehicleAndRouteName(this)"-->
<!--					style="height: 25px;border-radius:3px;width:55%;">-->
<!--					<option selected></option>-->
<!--				</select>-->
<!--			</div>-->

			<div class="col-sm-4 col-md-4" style="display: inherit;">
				<div for="staticEmail2" class="col-sm-4 col-md-4">
					Start Date
				</div>
				<div class='col-sm-8 col-md-8 input-group date'
					style="margin-left: -4% !important;">
					<input type='text' id="dateInput1" />
				</div>
			</div>

			<div class="col-sm-4 col-md-4" style="display: inherit;">
				<div for="staticEmail2" class="col-sm-4 col-md-4">
					End Date
				</div>
				<div class='col-sm-8 col-md-8 input-group date'
					style="margin-left: -4% !important;">
					<input type='text' id="dateInput2" />
				</div>
			</div>
			
			<div class="col-sm-3 col-md-3" style="display: inherit;">
			<label for="staticEmail2" class="col-sm-4 col-md-4">
					
				</label>
				<div class='col-sm-8 col-md-8 input-group date'
					style="margin-left: -4% !important;">
					<button type="button" class="btn btn-primary" onclick="getSwipedReportData()">Generate Report</button>
				</div>
			</div>
		</div>
		
				<div class="panel-body">
					<table id="driverEffTable"
						class="table table-striped table-bordered" cellspacing="0"
						width="98%">
						<thead>
							<tr>
								<th>
									Sl. No
								</th>
								<th>
									MMPS TRIPSHEET CODE 
								</th>
								<th>
									Lease Code
								</th>
								<th>
									Lease Name
								</th>
								<th>
									Buyer Name
								</th>
								<th>
									Source
								</th>
								<th>
									Destination
								</th>
								<th>
									Vehicle No
								</th>
								<th>
									Pass Issue Date
								</th>
								<th title="Weight from ILMS DATA">
									MDP Weight
								</th>
								<th title="Weight from T4U DATA">
									Actual Weight
								</th>
								<th>
									Difference Weight
								</th>
								<th>
									 Inserted Date
								</th>
							</tr>
						</thead>
					</table>
				</div>
	</div>
</div>


<script>
	var table;
	var status;
    var startDate="";
    var endDate = "";
    var uniqueId;
    var currentDate = new Date();
    var yesterdayDate = new Date();
         yesterdayDate.setDate(yesterdayDate.getDate() - 1);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);

	window.onload = function() {
		loadAllDetails();
	}
	$(document).ready(function () {
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

	});

	
	function loadAllDetails(){
	var custId;
	var custName;
	var custarray=[];
	var vehicleList;
	var routeList;
	/*
	$.ajax({
       
          success: function(result) {
                   customerDetails = JSON.parse(result);
         
            for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
            custarray.push(customerDetails["CustomerRoot"][i].CustName);
           }
			
		for (i = 0; i < custarray.length; i++) {
                var opt = document.createElement("option");
              //  document.getElementById("custDropDownId").options.add(opt);
                opt.text = custarray[i];
                opt.value = custarray[i];
            }
            
			if(customerDetails["CustomerRoot"].length == 1){
				var cName="";
				for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
					cName = customerDetails["CustomerRoot"][i].CustName;
				}
				function setSelectedIndex(s, v) {
					for ( var i = 0; i < s.options.length; i++ ) {
       			 		if ( s.options[i].text == v ) {
           		 			s.options[i].selected = true;
           		 			return;
        				}
   			 		}
				}
		setSelectedIndex(document.getElementById('custDropDownId'),cName);
			
		var custId;
	    var customerName = document.getElementById("custDropDownId").value;
	    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             custId = customerDetails["CustomerRoot"][i].CustId;
	        }
	    }
	}//if
		}
	});
	*/
	
		
		
		
}

    
    
   function getSwipedReportData(){
 
		if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("dateInput1").value;
			endDate = document.getElementById("dateInput2").value;
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
		var date1=startDate.split(" ");
		var sDate="";
	    if(date1.length == 2){
	    	sDate = date1[0]; //sDate+" "+startDate[1];
	    }
		var date2=endDate.split(" ");
		var eDate="";
	    if(date2.length == 2){
	    	eDate = date2[0]; //sDate+" "+startDate[1];
	    }
		val = checkMonthValidation(sDate,eDate);
         if(!val) {
        	sweetAlert("Please Select a Months Data");
        	return;
    	 }
			
         if ($.fn.DataTable.isDataTable('#driverEffTable')) {
            $('#driverEffTable').DataTable().destroy();
        }
        
      var table = $('#driverEffTable').DataTable({
    
         "ajax": {
             "url": '<%=request.getContextPath()%>/SandMiningAction.do?param=getAnalyticalWeighBridgeReport',
             "data": {
                 startDate: startDate,
					endDate: endDate
             },
             "dataSrc": "AnalyticalWeighBridgeReport"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Analytical Weigh-Bridge Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "ID"
         },{
             "data": "MMPS_TRIPSHEET_CODE"
         },{
             "data": "LEASE_CODE"
         },{
             "data": "LEASE_NAME"
         },{
             "data": "BUYER"
         },{
             "data": "SOURCE"
         },{
             "data": "DESTINATION"
         },{
             "data": "VEHICLE_NO"
         },{
             "data": "PASS_ISSUE_DATE"
         },{
             "data": "ACTUAL_WEIGHT"
         },{
             "data": "NET_WEIGHT"
         },{
             "data": "DIFFERENCE_WEIGHT"
         },{
             "data": "INSERTED_DATE"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

    }
    
   function checkMonthValidation(date1, date2) {
	     var dd = date1.split("/");
	     var ed = date2.split("/");
	     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
	     var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
	     var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
	     if (daysDiff <= 31) {
	         return true;
	     } else {
	         return false;
	     }
  }

</script>
<jsp:include page="../Common/footer.jsp" />
<!--  </body>-->
<!--</html>-->
