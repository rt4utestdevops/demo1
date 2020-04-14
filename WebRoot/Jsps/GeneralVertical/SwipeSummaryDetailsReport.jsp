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

#driverEffTable_filter{
   margin-top: -34px;
}

#orderDetailTable_filter{
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

</style>

  
<!--  <body>-->
<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
			AlNaba Vehicle Trip Tracking(AVTT)
		</h3>
	</div>
	<div class="panel-body" style="margin-bottom: 3%;">
		<div class="row" style="margin-bottom: 2%;">
			<div class="col-sm-3 col-md-3">
				<label for="staticEmail2" class="col-sm-4 col-md-4">
					Customer 
				</label>
				<select class="col-sm-6 col-md-6" id="custDropDownId"
					data-live-search="true" onchange="getCustomerName(this)"
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
					<a href="#tripDetailDiv" data-toggle="tab" active>Trip Detail</a>
				</li>
				<li>
					<a href="#tripSummaryDiv" data-toggle="tab">Trip Summary</a>
				</li>
				</ul>
		</div>

		<div class="tab-content" id="tabs">
			<div id="tripDetailDiv" class="tab-pane">

				<div class="panel-body">
					<div class="row" style="margin-bottom: 2%;">
					  <div class="col-sm-9 col-md-9" style="margin-left: 0%;">
						<span><!-- 123445677 -->
						<input type="radio" value="radiovehicle" name="yesno" id="yesClickTripDetail" onclick="resetValue()" ></span>
						<label for="staticEmail2" > Vehicle No  </label> 
							<select  id="vehicleDetail" disabled="disabled" data-live-search="true" style="height: 25px; width:14%" >
				     		<option selected></option>
							</select>
							<span style="padding-left: 20px;"></span>
							<input type="radio" value="radiogroup" name="yesno" id="noClickTripDetail"  onclick="resetValue()">
			  				 <label for="staticEmail2" > Group</label>
			  				 <select id="groupDetailNew" disabled="disabled"  data-live-search="true" style="height: 25px; width:14%" >
			  				 <option selected></option>
			  				 </select><span style="padding-left: 20px;"></span>
						</div>
						
						
						<div class="col-sm-3 col-md-3">
							<div class="col-sm-4 col-md-4">
								<button id="viewVehicleTripDetailId" class="col-lg-12 btn btn-primary"
									onclick="getVehicleTripDetailsData()">
									View
								</button>
							</div>
						</div>
					</div>

					<table id="VehicleTripDetailsTable"
						class="table table-striped table-bordered" cellspacing="0"
						width="98%">
						<thead>
							<tr>
								<th>
									Sl. No
								</th>
								<th>
									Group
								</th>
								
								<th>
									Vehicle Number
								</th>
								<th>
									Vehicle Type
								</th>
								<th>
									Driver Name
								</th>
								<th>
									Starting Date(dd/mm/yyyy)
								</th>
								<th>
									Starting Time(hh:mm)
								</th>
								<th>
									Ending Date(dd/mm/yyyy)
								</th>
								<th>
									Ending Time(hh:mm)
								</th>
								<th>
									Starting Odometer
								</th>
								<th>
									Ending Odometer
								</th>
								<th>
									Total Hours(HH:mm) on trip
								</th>
								<th>
									Trip total Kilometres(Km)
								</th>
								<th>
									Total Number of employees
								</th>
							</tr>
						</thead>
					</table>

				</div>
			</div>
			<div id="tripSummaryDiv" class="tab-pane">
				<div class="panel-body">
					<div class="row" style="margin-bottom: 2%;">

						<div class="col-sm-9 col-md-9" style="margin-left: 0%;">
							<span>
						<input type="radio" value="radiovehicle1" name="yesnoSummary" id="yesClickTripSummary" onclick="resetValue1()"  ></span>
						<label for="staticEmail2" > Vehicle No  </label> 
							<select  id="vehicleSummary" disabled="disabled" data-live-search="true" style="height: 25px; width:14%">
				     		<option selected></option>
							</select>
							<span style="padding-left: 20px;"></span>
							<input type="radio" value="radiogroup1" name="yesnoSummary" id="noClickTripSummary"  onclick="resetValue1()" >
			  				 <label for="staticEmail2" > Group</label>
			  				 <select id="groupSummary" disabled="disabled" data-live-search="true" style="height: 25px; width:14%">
			  				 <option selected></option>
			  				 </select><span style="padding-left: 20px;"></span>
						</div>

						<div class="col-sm-3 col-md-3">
							<div class="col-sm-4 col-md-4">
								<button id="viewVehicleTripSummaryId" class="col-lg-12 btn btn-primary"
									onclick="getVehicleTripSummaryData()">
									View
								</button>
							</div>
						</div>
					</div>
					<table id="VehicleTripSummaryTable"
						class="table table-striped table-bordered" cellspacing="0"
						width="98%">
						<thead>
							<tr>
								<th>
									Sl. No
								</th>
								<th>
									Group
								</th>
								<th>
									Vehicle number
								</th>
								<th>
									Number of Trips
								</th>
								<th>
									Number of drivers
								</th>
								<th>
									Total Distance(Km)
								</th>
								<th>
									Number of passengers
								</th>
								<th>
									Average Passengers per trip
								</th>
								<th>
									Average distance(Km) per trip
								</th>
								<th>
									Average distance per driver
								</th>
								<th>
									Average Time per trip
								</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
        </div>
	</div>
</div>


<script><!--
	var table;

    var startDate="";
    var endDate = "";
    
    var currentDate = new Date();
    var yesterdayDate = new Date();
         yesterdayDate.setDate(yesterdayDate.getDate() - 1);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);

	function activaTab(tab) {
		$('.nav-tabs a[href="#' + tab + '"]').tab('show');
	};
	activaTab('tripDetailDiv');

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
		$('#tripSummaryDiv').hide();
		$('#tripDetailDiv').hide();
		$('#tripSummaryDiv').removeClass("show");
		$('#tripDetailDiv').removeClass("show");
	};
	
	
    
    function resetValue()
     {
       if(document.getElementById("yesClickTripDetail").checked){
          document.getElementById("groupDetailNew").value = " ";
          $("#groupDetailNew").val(" ").trigger("change");
       }else{
          document.getElementById("vehicleDetail").value = " ";
          $("#vehicleDetail").val(" ").trigger("change");
          
          }
          }
          
     function resetValue1()
     {
       if(document.getElementById("yesClickTripSummary").checked){
          document.getElementById("groupSummary").value = " ";
           $("#groupSummary").val(" ").trigger("change");
       }else{
          document.getElementById("vehicleSummary").value = " ";
           $("#vehicleSummary").val(" ").trigger("change");
          }
          }
          
   
       
	
		 $('input:radio[name=yesno]').change(function() {
		//if ($.fn.DataTable.isDataTable('#example')) {
		  //  $('#example').DataTable().destroy();
		//}
	//$('#groupDetailNew').hide();
	     var radioValue = $("input:radio[name=yesno]:checked").val();
        if (radioValue == 'radiovehicle') {
          
           $('#groupDetailNew').prop( "disabled", true);
           $('#vehicleDetail').prop( "disabled", false );
      //  $('#groupDetailNew').removeAttr('disabled'); 
           if(document.getElementById("vehicleDetail").value){
	          $("#vehicleDetail").select2("val", "");
	       }  
	       $("#dateInput1").val(yesterdayDate);
	       $("#dateInput2").val(currentDate);
        }else{
       
         
           $('#groupDetailNew').prop( "disabled", false );
           $('#vehicleDetail').prop( "disabled", true );      
           
           if(document.getElementById("groupDetailNew").value){
	          $("#groupDetailNew").select2("val", "");
	       }
        }
       
    });
    
	
	
	 $('input:radio[name=yesnoSummary]').change(function() {
		//if ($.fn.DataTable.isDataTable('#example')) {
		   // $('#example').DataTable().destroy();
		//}
		var radioValue1 = $("input:radio[name=yesnoSummary]:checked").val();
	 if ( radioValue1 == 'radiovehicle1') {
           $('#groupSummary').prop( "disabled", true);
           $('#vehicleSummary').prop( "disabled", false);
        
           if(document.getElementById("vehicleSummary").value){
	          $("#vehicleSummary").select2("val", "");
	       }
	       $("#dateInput1").val(yesterdayDate);
	       $("#dateInput2").val(currentDate);
        }
      else  {
         
           $('#groupSummary').prop( "disabled", false);
           $('#vehicleSummary').prop( "disabled", true);      
           
           if(document.getElementById("groupSummary").value){
	          $("#groupSummary").select2("val", "");
	       }
        }
         });
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
	
		
	
		var vehiclesArr = [];
		$.ajax({
	        url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=getVehicleNo',
	          success: function(result) {
	                  vehiclesArr = JSON.parse(result);
	         
	            for (var i = 0; i < vehiclesArr.vehicles.length; i++) {
	            console.log(" vehicles :: :: " + JSON.stringify(vehiclesArr.vehicles));
				   $('#vehicleDetail').append($("<option></option>").attr("value",vehiclesArr.vehicles[i].value).text(vehiclesArr.vehicles[i].value));			
				}
	            $("#vehicleDetail").select2();	           	            
			}
		});
		
		
		var vehiclesArr = [];
		$.ajax({
	        url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=getVehicleNo',
	          success: function(result) {
	                  vehiclesArr = JSON.parse(result);
	         
	            for (var i = 0; i < vehiclesArr.vehicles.length; i++) {
	            console.log(" vehicles :: :: " + JSON.stringify(vehiclesArr.vehicles));
				   $('#vehicleSummary').append($("<option></option>").attr("value",vehiclesArr.vehicles[i].value).text(vehiclesArr.vehicles[i].value));			
				}
	            $("#vehicleSummary").select2();	           	            
			}
		});
		
		
		
	
		var groupAarray=[];
		var groups = [];
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripDetailSummaryAction.do?param=getGroupData',
	          success: function(result) {
	                  groups = JSON.parse(result);
	                   console.log("group :: ::" +result);
	                  console.log("groupName :: ::" +groups);
	            for (var i = 0; i < groups["groupNames"].length; i++) {
				//groupAarray(groups["groupNames"][i].groupName);
				   $('#groupDetailNew').append($("<option></option>").attr("value",groups["groupNames"][i].groupName).text(groups["groupNames"][i].groupName));			
				}
	            $("#groupDetailNew").select2();	           	            
			}
		});
		
		var groupAarray=[];
		var groups = [];
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripDetailSummaryAction.do?param=getGroupData',
	          success: function(result) {
	                  groups = JSON.parse(result);
	                   console.log("group :: ::" +result);
	                  console.log("groupName :: ::" +groups);
	            for (var i = 0; i < groups["groupNames"].length; i++) {
				//groupAarray(groups["groupNames"][i].groupName);
				   $('#groupSummary').append($("<option></option>").attr("value",groups["groupNames"][i].groupName).text(groups["groupNames"][i].groupName));			
				}
	            $("#groupSummary").select2();	           	            
			}
		});
		
		}

    function getVehicleTripDetailsData(){
     var vehicleNo;
     var vehicleGroup;
       if(document.getElementById("yesClickTripDetail").checked){
		vehicleNo = document.getElementById("vehicleDetail").value;
		if(document.getElementById("vehicleDetail").value == ""){
		  sweetAlert("Please select Vehicle No");
	 return;
	}
  }else if(document.getElementById("noClickTripDetail").checked){
		vehicleGroup = document.getElementById("groupDetailNew").value;
	   if(document.getElementById("groupDetailNew").value == ""){
		   sweetAlert("Please select the group");
		    return;
		   }
		  }
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
	   	
	   var vehicleGroup =document.getElementById("groupDetailNew").value;
	   var vehicleNo =document.getElementById("vehicleDetail").value;
	 
        
         if ($.fn.DataTable.isDataTable('#VehicleTripDetailsTable')) {
            $('#VehicleTripDetailsTable').DataTable().destroy();
        }
      var table = $('#VehicleTripDetailsTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/TripDetailSummaryAction.do?param=getTripDetailData',
             "data": {
                 	startDate: startDate,
					endDate: endDate,
					vehicleNo:vehicleNo,
					vehicleGroup:vehicleGroup
					 },
             "dataSrc": "tripDetailsRoot"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Trip Details Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "groupIndex"
          },{
             "data": "vehicleNoIndex"
         },{ 
             "data": "vehicleTypeIndex"
         },{
             "data": "driverNameIndex"
         },{
             "data": "startingDateIndex"
         },{
             "data": "startingTimeIndex"
         },{
             "data": "endingDateIndex"
         },{
             "data": "endingTimeIndex"
         },{
             "data": "startingOdometerIndex"//customerName
         }, {
             "data": "endingOdometerTime"
         }, {
             "data": "totalHoursOnTrip"
         },{
             "data": "tripTotalKilometers"
         },{
             "data": "totalNoOfEmployees"
             
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

    }
    
  
    
     function getVehicleTripSummaryData(){
     var vehicleNo1;
     var vehicleGroup1;
     if(document.getElementById("yesClickTripSummary").checked){
		vehicleNo1 = document.getElementById("vehicleSummary").value;
		if(document.getElementById("vehicleSummary").value == ""){
		    sweetAlert("Please select Vehicle No");
		   return;
		}
	}else if(document.getElementById("noClickTripSummary").checked){
		vehicleGroup1 = document.getElementById("groupSummary").value;
	   if(document.getElementById("groupSummary").value == ""){
		  sweetAlert("Please select the group");
		  return;
		  }
		   }
     
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
			
	   var vehicleGroup1 =document.getElementById("groupSummary").value;
	   var vehicleNo1 =document.getElementById("vehicleSummary").value;
	  
 	if ($.fn.DataTable.isDataTable('#VehicleTripSummaryTable')) {
            $('#VehicleTripSummaryTable').DataTable().destroy();
        }
      var table = $('#VehicleTripSummaryTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/TripDetailSummaryAction.do?param=getTripSummaryData',
             "data": {
                 	startDate: startDate,
					endDate: endDate,
				    vehicleNo1: vehicleNo1,
				    vehicleGroup1:vehicleGroup1
				    },
             "dataSrc": "tripSummaryRoot"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Trip Summary Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "slnoIndex"
         }, {
             "data": "groupIndex"
         },{
             "data": "vehicleNoIndex"
         },{ 
             "data": "noOfTripsIndex"
         },{
             "data": "noOfDriversIndex"
         },{
             "data": "totalDistanceIndex"
         },{
             "data": "noOfPassengersIndex"
         },{
             "data": "averagePassengersPerTrip"
         }, {
             "data": "averageDistancePerTrip"
         }, {
             "data": "averageDistancePerDriver"
         }, {
             "data": "averageTimePerTrip"
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

--></script>
<jsp:include page="../Common/footer.jsp" />
<!--  </body>-->
<!--</html>-->
