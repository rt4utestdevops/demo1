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
#pendingDeliveriesTable_filter{
   margin-top: -34px;
}

#pendingDeliveriesTable_filter label{
   width:0px;
}

#driverEffTable_filter{
   margin-top: -34px;
}

#orderDetailTable_filter{
   margin-top: -34px;
}
#orderDetailTable_filter label{
   width:0px;
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

</style>

  
<!--  <body>-->
<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
			Jotun Smart Delivery System (JSDS)
		</h3>
	</div>
	<div class="panel-body" style="margin-bottom: 3%;">
		<div class="row" style="margin-bottom: 2%;">
			<div class="col-sm-3 col-md-3">
				<label for="staticEmail2" class="col-sm-4 col-md-4">
					Customer
				</label>
				<select class="col-sm-6 col-md-6" id="custDropDownId"
					data-live-search="true" onchange="getVehicleAndRouteName(this)"
					style="height: 25px;">
					<option selected></option>
				</select>
			</div>

			<div class="col-sm-3 col-md-3" style="display: inherit;">
				<label for="staticEmail2" class="col-sm-5 col-md-5">
					Start Date
				</label>
				<div class='col-sm-7 col-md-7 input-group date'
					style="margin-left: -4% !important;">
					<input type='text' id="dateInput1" />
				</div>
			</div>

			<div class="col-sm-3 col-md-3" style="display: inherit;">
				<label for="staticEmail2" class="col-sm-5 col-md-5">
					End Date
				</label>
				<div class='col-sm-7 col-md-7 input-group date'
					style="margin-left: -4% !important;">
					<input type='text' id="dateInput2" />
				</div>
			</div>
		</div>
		
		<div class="tabs-container">
			<ul class="nav nav-tabs" style="display: table-cell;">
				<li>
					<a href="#orderDetailDiv" data-toggle="tab" active>Order Detail</a>
				</li>
				<li>
					<a href="#pendingDiv" data-toggle="tab">Pending Deliveries</a>
				</li>
				<li>
					<a href="#driverEffDiv" data-toggle="tab">Driver Efficiency</a>
				</li>
			</ul>
		</div>

		<div class="tab-content" id="tabs">
			<div id="pendingDiv" class="tab-pane">

				<div class="panel-body">
					<div class="row" style="margin-bottom: 2%;">
						<div class="col-sm-5 col-md-5" style="margin-left: 0%;">
							<label for="staticEmail2" class="col-sm-4 col-md-4">
								Order No.
							</label>
							<span id="span1">
							<select class="col-sm-8 col-md-8" id="orderNoDropDownPending"
								data-live-search="true" style="height: 25px;">
								<option selected></option>
							</select>
							</span>
						</div>
						<div class="col-sm-7 col-md-7" style="margin-left: 0%;">
							<label for="staticEmail2" class="col-sm-4 col-md-4">
								Trip Customer
							</label>
							<select class="col-sm-5 col-md-5" id="tripCustomerNamePending"
								data-live-search="true" style="height: 25px;">
								<option selected></option>
							</select>
								<div class="col-sm-3 col-md-3" style="float: right">
								<button id="viewPendingId" class="col-lg-12 btn btn-primary"
									onclick="getPendingDeliveriesData()">
									View
								</button>
							</div>
						</div>
						<div class="col-sm-4 col-md-4" style="margin-left: 0%;" hidden>
							<label for="staticEmail2" class="col-sm-6 col-md-6">
								Order Status
							</label>
							<select class="col-sm-6 col-md-6" id="statusDropDownPending"
								data-live-search="true" style="height: 25px;" >
								<option value="0" selected>
									-- All --
								</option>
								<option value="1">
									DT Pending
								</option>
								<option value="2">
									Delivered
								</option>
								<option value="3">
									Not Delivered
								</option>
							</select>
						</div>
<!--						<div class="col-sm-3 col-md-3">-->
<!--							-->
<!--						</div>-->
					</div>

					<table id="pendingDeliveriesTable"
						class="table table-striped table-bordered" cellspacing="0"
						width="98%">
						<thead>
							<tr>
								<th>
									Sl. No
								</th>
								<th>
									Order No
								</th>
								<th>
									DT No
								</th>
								<th>
									DN No
								</th>
								<th>
									Driver Name
								</th>
								<th>
									Driver Contact
								</th>
								<th>
									Loading Partner
								</th>
								<th>
									Customer Name
								</th>
								<th>
									Dispatch DateTime
								</th>
								<th>
									Delivered Time
								</th>
								<th>
									Remarks
								</th>

							</tr>
						</thead>
					</table>

				</div>
			</div>
			<div id="driverEffDiv" class="tab-pane">
				<div class="panel-body">
					<div class="row" style="margin-bottom: 2%;">

						<div class="col-sm-4 col-md-4" style="margin-left: 0%;">
							<label for="staticEmail2" class="col-sm-6 col-md-6">
								Driver
							</label>
							<select class="col-sm-6 col-md-6" id="driverDropDown"
								data-live-search="true" style="height: 25px;">
								<option selected></option>
							</select>
						</div>

						<div class="col-sm-3 col-md-3">
							<div class="col-sm-4 col-md-4">
								<button id="viewDriverId" class="col-lg-12 btn btn-primary"
									onclick="getDriverEfficiencyData()">
									View
								</button>
							</div>
						</div>
					</div>
					<table id="driverEffTable"
						class="table table-striped table-bordered" cellspacing="0"
						width="98%">
						<thead>
							<tr>
								<th>
									Sl. No
								</th>
								<th>
									Driver Name
								</th>
								<th>
									No Of Trips
								</th>
								<th>
									Total Time (HH:mm)
								</th>
								<th>
									Average Time (HH:mm)
								</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>

			<div id="orderDetailDiv" class="tab-pane">

				<div class="panel-body">
					<div class="row" style="margin-bottom: 2%;">

						<div class="col-sm-4 col-md-4" style="margin-left: 0%;">
							<label for="staticEmail2" class="col-sm-5 col-md-5">
								Order No.
							</label>
							<span id="span2">
							<select class="col-sm-6 col-md-6" id="orderNoDropDown"
								data-live-search="true" style="height: 25px;">
								<option selected></option>
							</select>
							</span>
						</div>
						<div class="col-sm-4 col-md-4" style="margin-left: 0%;">
							<label for="staticEmail2" class="col-sm-6 col-md-6">
								Trip Customer
							</label>
							<select class="col-sm-6 col-md-6" id="tripCustomerNameOrder"
								data-live-search="true" style="height: 25px;">
								<option selected></option>
							</select>
						</div>
						<div class="col-sm-4 col-md-4" style="margin-left: 0%;">
							<label for="staticEmail2" class="col-sm-4 col-md-4">
								Order Status
							</label>
							<select class="col-sm-4 col-md-4" id="statusDropDownOrder"
								data-live-search="true" style="height: 25px;">
								<option value="0" selected>
									-- All --
								</option>
								<option value="1">
									DT Pending
								</option>
								<option value="2">
									Delivered
								</option>
								<option value="3">
									Not Delivered
								</option>
							</select>
							<div class="col-sm-4 col-md-4" style="float:right">
								<button id="viewOrderDetailId" class="col-lg-12 btn btn-primary"
									onclick="getOrderDetailData()">
									View
								</button>
							</div>
						</div>
<!--						<div class="col-sm-3 col-md-3">-->
<!--							<div class="col-sm-4 col-md-4">-->
<!--								<button id="viewOrderDetailId" class="col-lg-12 btn btn-primary"-->
<!--									onclick="getOrderDetailData()">-->
<!--									View-->
<!--								</button>-->
<!--							</div>-->
<!--						</div>-->
					</div>

					<table id="orderDetailTable"
						class="table table-striped table-bordered" cellspacing="0"
						width="98%">
						<thead>
							<tr>
								<th>
									Sl. No
								</th>
								<th>
									Order No
								</th>
								<th>
									DT No
								</th>
								<th>
									DN No
								</th>
								<th>
									Driver Name
								</th>
								<th>
									Driver Contact
								</th>
								<th>
									Loading Partner
								</th>
								<th>
									Customer Name
								</th>
								<th>
									Dispatch DateTime
								</th>
								<th>
									Delivered Time
								</th>
								<th>
									Acknowledged Time
								</th>
								<th>
									Remarks
								</th>
								<th>
									Collected By
								</th>
								<th>
									Mobile Number
								</th>
								<th>
									Vehicle Number
								</th>
							</tr>
						</thead>
					</table>

				</div>
			</div>
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
         yesterdayDate.setDate(yesterdayDate.getDate() - 2);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);
	var isDateChanged=true;

	function activaTab(tab) {
		$('.nav-tabs a[href="#' + tab + '"]').tab('show');
	};
	activaTab('orderDetailDiv');

	window.onload = function() {
		loadAllDetails();
	}
	$(document).ready(function () {
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

	});

	function changeTab1(tab1) {
		$('.nav-tabs a[href="#' + tab1 + '"]').tab('show');
		$('#pendingDiv').hide();
		$('#orderDetailDiv').hide();
		$('#pendingDiv').removeClass("show");
		$('#orderDetailDiv').removeClass("show");
	};

	function changeTab(tab1) {
		$('.nav-tabs a[href="#' + tab1 + '"]').tab('show');
		$('#pendingDiv').hide();
		$('#driverEffDiv').hide();
		$('#pendingDiv').removeClass("show");
		$('#driverEffDiv').removeClass("show");
	};
	
		function changeTab2(tab1) {
		$('.nav-tabs a[href="#' + tab1 + '"]').tab('show');
		$('#driverEffDiv').hide();
		$('#orderDetailDiv').hide();
		$('#driverEffDiv').removeClass("show");
		$('#orderDetailDiv').removeClass("show");
	};
	
	
	function loadAllDetails(){
	var custId;
	var custName;
	var custarray=[];
	var vehicleList;
	var routeList;
//	$("#vehicleNoDropDownId").empty().select2();
//	$("#routeDropDownId").empty().select2();
	
	
	$.ajax({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
          success: function(result) {
                   customerDetails = JSON.parse(result);
         
            for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
            custarray.push(customerDetails["CustomerRoot"][i].CustName);
           }
			
		for (i = 0; i < custarray.length; i++) {
                var opt = document.createElement("option");
                document.getElementById("custDropDownId").options.add(opt);
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
	
		$("#tripCustomerNamePending").empty().select2();
		$("#tripCustomerNameOrder").empty().select2();
   		$.ajax({
	        url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getTripCustomers',
	        success: function(result) {
	            addcustList = JSON.parse(result);
	            $('#tripCustomerNamePending').append($("<option></option>").attr("value", 0).text("--All--"));
	             $('#tripCustomerNameOrder').append($("<option></option>").attr("value", 0).text("--All--"));
	            for (var i = 0; i < addcustList["customerRoot"].length; i++) {
                    $('#tripCustomerNamePending').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
                     $('#tripCustomerNameOrder').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
	            }
	            $('#tripCustomerNamePending').select2();
	            $('#tripCustomerNameOrder').select2();
			}
		});
		$(document).on("click","#span1", function() {  
		   getOrderNumber();
		});
		$(document).on("click","#span2", function() {  
		   getOrderNumber();
		});
		$("#dateInput1").change(function(){
		  isDateChanged=true;
		});
		$("#dateInput2").change(function(){
		  isDateChanged=true;
		});
		getOrderNumber();
		function getOrderNumber()
		{
			if(isDateChanged)
			{
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
				$("#orderNoDropDownPending").empty().select2();
				$("#orderNoDropDown").empty().select2();
		   		$.ajax({
			        url: '<%=request.getContextPath()%>/DTSReportsAction.do?param=getOrderNo&startDate='+startDate+'&endDate='+endDate,
			        success: function(result) {
			            addOrderList = JSON.parse(result);
			            $('#orderNoDropDownPending').append($("<option></option>").attr("value", 0).text("--All--"));
			             $('#orderNoDropDown').append($("<option></option>").attr("value", 0).text("--All--"));
			            var options1=$('#orderNoDropDownPending').html();
			            var options2=$('#orderNoDropDown').html();
			            for (var i = 0; i < addOrderList["orderRoot"].length; i++) {
			            options1 +="<option value='"+(addOrderList["orderRoot"][i].orderNo)+"'>"+(addOrderList["orderRoot"][i].orderNo)+"</option>";
			            options2 +="<option value='"+(addOrderList["orderRoot"][i].orderNo)+"'>"+(addOrderList["orderRoot"][i].orderNo)+"</option>";
		                    //$('#orderNoDropDownPending').append($("<option></option>").attr("value", addOrderList["orderRoot"][i].orderNo).text(addOrderList["orderRoot"][i].orderNo));
		                    // $('#orderNoDropDown').append($("<option></option>").attr("value", addOrderList["orderRoot"][i].orderNo).text(addOrderList["orderRoot"][i].orderNo));
			            }
			            $('#orderNoDropDownPending').html(options1);	            
			            $('#orderNoDropDown').html(options2);
			            $('#orderNoDropDownPending').select2();
			            $('#orderNoDropDown').select2();
			           isDateChanged=false;
					}
				});
			}	
		};
		$("#driverDropDown").empty().select2();
   		$.ajax({
	        url: '<%=request.getContextPath()%>/DTSReportsAction.do?param=getDriverNames',
	        success: function(result) {
	            addOrderList = JSON.parse(result);
	             $('#driverDropDown').append($("<option></option>").attr("value", 0).text("--All--"));
	            for (var i = 0; i < addOrderList["driverRoot"].length; i++) {
                     $('#driverDropDown').append($("<option></option>").attr("value", addOrderList["driverRoot"][i].driverId).text(addOrderList["driverRoot"][i].driverName));
	            }
	            $('#driverDropDown').select2();
			}
		});
}

    function getPendingDeliveriesData(){
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
			
	   var orderNoPending=document.getElementById("orderNoDropDownPending").value;
	   var tripCustPending=document.getElementById("tripCustomerNamePending").value;
	  // var statusPending=document.getElementById("statusDropDownPending").value;
        
         if ($.fn.DataTable.isDataTable('#pendingDeliveriesTable')) {
            $('#pendingDeliveriesTable').DataTable().destroy();
        }
      var table = $('#pendingDeliveriesTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/DTSReportsAction.do?param=getPendingDeliveriesReport',
             "data": {
                 	startDate: startDate,
					endDate: endDate,
					orderNo: orderNoPending,
					tripCust: tripCustPending,
					//status: statusPending
             },
             "dataSrc": "pendingDeliveriesRoot"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Pending Deliveries Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "orderNoIndex"
         },{
             "data": "dtNoIndex"
         },{ 
             "data": "dnNoIndex"
         },{
             "data": "driverNameIndex"
         },{
             "data": "driverContactIndex"
         },{
             "data": "loadingPartnerIndex"
         },{
             "data": "customerNameIndex"//customerName
         }, {
             "data": "dispatchTime"
         }, {
             "data": "deliveredTime"
         },{
             "data": "remarks"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

    }
    
   function getDriverEfficiencyData(){
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
			
	   var vehicleNo=document.getElementById("driverDropDown").value;
        
         if ($.fn.DataTable.isDataTable('#driverEffTable')) {
            $('#driverEffTable').DataTable().destroy();
        }
      var table = $('#driverEffTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/DTSReportsAction.do?param=getDriverEfficiencyReport',
             "data": {
                 startDate: startDate,
					endDate: endDate,
					vehicleNo: vehicleNo
             },
             "dataSrc": "driverEffRoot"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Driver Efficiency Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "driverNameIndex"
         },{
             "data": "noOfTripsIndex"
         },{
             "data": "totalTimeIndex"
         }, {
             "data": "avgTimeIndex"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

    }
    
     function getOrderDetailData(){
     
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
			
	   var orderNo=document.getElementById("orderNoDropDown").value;
	   var tripCust=document.getElementById("tripCustomerNameOrder").value;
	   var status=document.getElementById("statusDropDownOrder").value;
        
 	if ($.fn.DataTable.isDataTable('#orderDetailTable')) {
            $('#orderDetailTable').DataTable().destroy();
        }
      var table = $('#orderDetailTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/DTSReportsAction.do?param=getOrderDetailReport',
             "data": {
                 	startDate: startDate,
					endDate: endDate,
					orderNo: orderNo,
					tripCust: tripCust,
					status: status
             },
             "dataSrc": "orderDetailRoot"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Order Delivery Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "slnoIndex"
         }, {
             "data": "orderNoIndex"
         },{
             "data": "dtNoIndex"
         },{ 
             "data": "dnNoIndex"
         },{
             "data": "driverNameIndex"
         },{
             "data": "driverContactIndex"
         },{
             "data": "loadingPartnerIndex"
         },{
             "data": "customerNameIndex"//customer name
         }, {
             "data": "dispatchTime"
         }, {
             "data": "deliveredTime"
         }, {
             "data": "ackDateTime"
         }, {
             "data": "remarks"
         }, {
             "data": "collectedBy"
         }, {
             "data": "mobileNumber"
         }, {
             "data": "vehicleNumber"
         }
         ]
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
