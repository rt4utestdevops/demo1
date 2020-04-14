<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.GeneralVertical.*"
	pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
			
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
	int offset = loginInfo.getOffsetMinutes();
	String offsetHHMM = cf.convertMinutesToHHMMFormat(offset);   
	String distUnits = cf.getUnitOfMeasure(systemId);
	 
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
	

      
      

<!--  	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">-->
  	
 
 <style>

  .modal-body {
    position: relative;
    overflow-y: hidden;
    max-height: 500px;
    padding: 15px;
}
.input-group[class*=col-] {
    float: left !important;
    padding-right: 0px;
    margin-left: -54px !important;
}
.comboClass{
   width: 200px;
   height: 25px;
   
}
.comboClass2{
   width: 200px;
   height: 25px;
   
}
.comboClassVeh{
   width: 200px;
   height: 25px;
   
}
.comboClassDriver{
   width: 150px;
   height: 25px;
   
}
label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: 500;
}
#emptyColumn{
	width: 20px;
}
#emptyColumn2{
 	width: 30px;
}
.dataTables_scroll
{
    overflow:auto;
}

.btn{
	font-size:13px;
}

#dateInput1{
    width: 150px !important;
    height: 25px;
}
#dateInput2{
    width: 150px !important;
    height: 25px;
}
#validTable_filter{
   margin-top: -34px;
}
#inValidTable_filter{
   margin-top: -34px;
}
#subTable_filter{
   margin-top: -34px;
}
#subTablePull_filter{
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
    margin-top: 35px !important;    
    margin-left: 850px !important;
}
}

div.dataTables_wrapper div.dataTables_paginate {   
    margin-left: 986px  !important;
}

 </style>
<!-- </head> -->
 
<!-- <body onload=getCustomer()>  -->
	
<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
                    Mobileye Data Platform
		</h3>
	</div>
	<div class="panel-body">
	<div class="row">
				<div class="col-sm-3 col-md-3">
					<label for="staticEmail2" class="col-sm-4 col-md-4" >Customer</label>
						<select class="col-sm-6 col-md-6" id="custDropDownId"  data-live-search="true" onchange="getVehicleAndRouteName(this)" style="height:25px;">
							<option selected></option>
						</select>
				</div>
				
				<div class="col-sm-3 col-md-3" style="margin-left: 0%;">
					<label for="staticEmail2" class="col-sm-4 col-md-4">Vehicle No.</label>
						<select class="col-sm-6 col-md-6" id="vehicleNoDropDownId"  data-live-search="true" style="height:25px;">
							<option selected></option>
						</select>
				</div>
				
			    <div class="col-sm-3 col-md-3" style="display: inherit;">
					 <label for="staticEmail2" class="col-sm-5 col-md-5" >Start Date</label>
					 	<div class='col-sm-7 col-md-7 input-group date' style="margin-left: -4% !important;">
							<input type='text'  id="dateInput1"/>
						</div>
				</div>
					 
				<div class="col-sm-3 col-md-3" style="display: inherit;">
				    <label for="staticEmail2" class="col-sm-5 col-md-5" >End Date</label>
						<div class='col-sm-7 col-md-7 input-group date' style="margin-left: -4% !important;">
							<input type='text'  id="dateInput2"/>
						</div>
				</div>
			</div>
	
		
		<div class="row" style="margin-top: 1%;margin-bottom:1%">
				<div class="col-sm-3 col-md-3" style="margin-left: 0%;">
					<label for="staticEmail2" class="col-sm-4 col-md-4">Type</label>
							<select class="col-sm-6 col-md-6" id="statusTypeDropDownId"  data-live-search="true" style="height:25px;">
								<option selected value = "Valid">Valid</option>
								<option value = "Invalid">Invalid</option>
							</select>
				</div>
				<div class="col-sm-3 col-md-3" style="margin-left: 0%;">
					<label for="staticEmail2" class="col-sm-4 col-md-4">API Type</label>
							<select class="col-sm-6 col-md-6" id="apiTypeDropDownId"  data-live-search="true" style="height:25px;">
								<option selected value = "get">Get</option>
								<option value = "post">Post</option>
							</select>
				</div>				
				<div class="col-sm-3 col-md-3">
					<div class="col-sm-4 col-md-4"> 
						<button id="viewId" class="col-lg-12 btn btn-primary" onclick="getGridData()">View</button>
					</div>
				</div>
		</div>
		<br><br/>
		<div class="row" style="margin-top: 0%;margin-bottom:2%">
		<div class="row" style="border:2px solid;margin-bottom: 0%;margin-top: 1%;margin-left: 35%;width: 30%;border-radius: 10px; color: grey;padding-left:138px;">
           <p class="thick" style="text-align: center;color:#000000;margin-top: 2%;">
           <span id="gridHeaderId"><b>Mobileye Data</b></span>
           </p>
		</div>
		</div>
		<div id="validTableDiv">
			<table id="validTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>SL. No</th>
					<th>Vehicle No</th>
					<th>Unit No</th>
					<th>GMT</th>
					<th>GMT + <%=offsetHHMM%></th>
					<th>Latitude</th>
					<th>Longitude</th>
					<th>Satellite Time (s)</th>
					<th>Speed (<%=distUnits %>)</th>
					<th>Alarm Type</th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div id="inValidTableDiv" style="display: none">	
			<table id="inValidTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>SL. No</th>
					<th>Vehicle No</th>
					<th>Unit No</th>
					<th>Inserted GMT</th>
					<th>Inserted GMT + <%=offsetHHMM%></th>
					<th>Packet</th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="row" style="border:2px solid;margin-bottom: -2%;margin-top: 1%;margin-left: 35%;width: 30%;border-radius: 10px; color: grey;padding-left:138px;">
           <p class="thick" style="text-align: center;color:#000000;margin-top: 2%;">
           <span id="gridHeaderId"><b>API Transactions</b></span>
           </p>
		</div>
		<div id="subTableDiv" style="margin-top: 2%;">
			<table id="subTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>SL. No</th>
					<th>Vehicle No</th>
					<th>Unit No</th>
					<th>Request/Response Date Time</th>
					<th>From Date Time</th>
					<th>To Date Time</th>
					<th>Status</th>
					<th>No Of Records</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="subTablePullDiv" style="margin-top: 2%;display: none;">
			<table id="subPullTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>SL. No</th>
					<th>Vehicle No</th>
					<th>Unit No</th>
					<th>Request/Response Date Time</th>
					<th>From Date Time</th>
					<th>To Date Time</th>
					<th>Status</th>
					<th>No Of Records</th>
					</tr>
				</thead>
			</table>
		</div>
		</div>
	</div>
			
	   

	  

    <script async>
	
	 window.onload = function () { 
		getCustomerAndVehicleNo();
		//doucment.getElementById("inValidTableDiv").style.display = "none";
	}
	
    var table;
    var customerDetails;
    var status;
    var startDate="";
    var endDate = "";
    var uniqueId;
    var currentDate = new Date();
    var restrictDate = new Date(currentDate).getDate()-7;
    var restrictMonth = new Date(currentDate).getMonth();
    var restrictYear =new Date(currentDate).getFullYear();
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);

	var tripId =0;
    
   $(document).ready(function () {
	   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: false, width: '197px', height: '25px'});
	   $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
	   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: false, width: '197px', height: '25px'});
	   $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());

	});
//##########function to get customer details#############//

function getCustomerAndVehicleNo(){
	var custId;
	var custName;
	var custarray=[];
	var vehicleList;
	
	$("#vehicleNoDropDownId").empty().select2();
	
	
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
	
		$.ajax({
        url: '<%=request.getContextPath()%>/MobileyeActivityAction.do?param=getVehicleNo',
          success: function(result) {
                   vehicleList = JSON.parse(result);
                   	            for (var i = 0; i < vehicleList["VehicleNoRoot"].length; i++) {
                    $('#vehicleNoDropDownId').append($("<option></option>").attr("value", vehicleList["VehicleNoRoot"][i].VehicleNo).text(vehicleList["VehicleNoRoot"][i].VehicleNo));
	            }
	            $('#vehicleNoDropDownId').select2();

		}
	});
}

    //#############function to get grid data###################
    
    function getGridData(){
    	var status = document.getElementById("statusTypeDropDownId").value;
    	var apiStatus = document.getElementById("apiTypeDropDownId").value;
    	var startDate=document.getElementById("dateInput1").value;
	    startDate=startDate.split(" ");
	    var sd="";
	    if(startDate.length == 2){
	    	//sDate=startDate[0].split("/").reverse().join("-");
	    	sd = startDate[0]; //sDate+" "+startDate[1];
	    }
	    var endDate=document.getElementById("dateInput2").value;
	    endDate=endDate.split(" ");
	    var ed="";
	    if(endDate.length == 2){
	    	//eDate=endDate[0].split("/").reverse().join("-");
	   		ed = endDate[0];//eDate+" "+endDate[1];
	    }
    	 val = checkMonthValidation(sd,ed);
         if(!val) {      	
        	sweetAlert("Please Select Seven Days Only");
        	return;
    	 }
    	 var sdDate = document.getElementById("dateInput1").value;
    	 var edDate = document.getElementById("dateInput2").value;
    	 
    	 var dd = sdDate.split("/");
	        var ed = edDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("dateInput2").value = currentDate;
		       	    return;
		   		}
			
    	 
    	 
<!--    	 alert("SD : "+ sdDate+" , ED : "+edDate);-->
<!--    	  if(sdDate>edDate) {-->
<!--        	sweetAlert("Start Date should be less than End Date");-->
<!--        	return;-->
<!--    	 }-->
    	 
    	  sdDate = new Date(sdDate);
    	  edDate = new Date(edDate);
    	  
    	
    	     	 
    	if(status == 'Valid'){
    		getValidGridData();
    		//getSubGridData();
    		document.getElementById("inValidTableDiv").style.display = "none";
    		document.getElementById("validTableDiv").style.display = "block";
    		
    		
    	}else if(status == 'Invalid'){
    		getInvalidGridData();
    		//getSubGridData();
    		document.getElementById("validTableDiv").style.display = "none";
    		document.getElementById("inValidTableDiv").style.display = "block";
    	}
    	if(apiStatus == 'get'){
    		//getValidGridData();
    		getSubGridData();
    		document.getElementById("subTablePullDiv").style.display = "none";
    		document.getElementById("subTableDiv").style.display = "block";
    		
    		
    	}else if(apiStatus == 'post'){
    		//getInvalidGridData();
    		getSubPullGridData();
    		document.getElementById("subTableDiv").style.display = "none";
    		document.getElementById("subTablePullDiv").style.display = "block";
    	}
    }
    
     function checkMonthValidation(date1, date2) {
	     var dd = date1.split("/");
	     var ed = date2.split("/");
	     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
	     var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
	     var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
	     if (daysDiff <= 7) {
	         return true;
	     } else {
	         return false;
	     }
  }
    
  function getValidGridData(){
  
    if ($.fn.DataTable.isDataTable('#validTable')) {
            $('#validTable').DataTable().destroy();
        }
    
    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split(" ");
    var newStartDate="";
    if(startDate.length == 2){
    	sDate=startDate[0].split("/").reverse().join("-");
    	newStartDate = sDate+" "+startDate[1];
    }
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split(" ");
    var newEndDate="";
    if(endDate.length == 2){
    	eDate=endDate[0].split("/").reverse().join("-");
   		newEndDate = eDate+" "+endDate[1];
    }    //var statusType = document.getElementById("statusTypeDropDownId").value;
    var vehicleNo=document.getElementById("vehicleNoDropDownId").value;
     table = $('#validTable').DataTable({
         //"processing": true,
         //"serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/MobileyeActivityAction.do?param=getMobileyeValidData',
             "data": {
                 //CustId: customerId,
                 startDate: newStartDate,
                 endDate: newEndDate,
                 //statusType: statusType,
                 vehicleNo:vehicleNo
                 
             },
             "dataSrc": "validMobileye"
         },
         "bLengthChange": false,
         "iDisplayLength": 5,
         "dom": '<"toolbar">Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Mobileye Data  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 				}
        	 				],
         "columns": [{
             "data": "slNoindex"
         }, {
             "data": "registrationNo"
         },{
             "data": "unitNo"
         },  {
             "data": "gmt"
         }, {
             "data": "gpsTime"
         }, {
             "data": "latitude"
         },{
             "data": "longitude"
         }, {
         	"data": "sateliteTime"
         }, {
             "data": "speed"
         }, {
             "data": "alarmType"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

   }
   
   

  function getInvalidGridData(){
  	 if ($.fn.DataTable.isDataTable('#inValidTable')) {
            $('#inValidTable').DataTable().destroy();
        }
    

    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split(" ");
    var newStartDate="";
    if(startDate.length == 2){
    	sDate=startDate[0].split("/").reverse().join("-");
    	newStartDate = sDate+" "+startDate[1];
    }
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split(" ");
    var newEndDate="";
    if(endDate.length == 2){
    	eDate=endDate[0].split("/").reverse().join("-");
   		newEndDate = eDate+" "+endDate[1];
    } 
    //var statusType = document.getElementById("statusTypeDropDownId").value;
    var vehicleNo=document.getElementById("vehicleNoDropDownId").value;
     table = $('#inValidTable').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/MobileyeActivityAction.do?param=getMobileyeInValidData',
             "data": {
                 //CustId: customerId,
                 startDate: newStartDate,
                 endDate: newEndDate,
                 //statusType: statusType,
                 vehicleNo:vehicleNo
                 
             },
             "dataSrc": "inValidMobileye",
         },
         "bLengthChange": false,
         "dom": '<"toolbar">Bfrtip',
         "iDisplayLength": 5,
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Mobileye Data  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 				}
        	 				],
         "columns": [{
             "data": "slNoindex"
         }, {
             "data": "registrationNo"
         }, {
             "data": "unitNo"
         }, {
             "data": "insertedGmt"
         }, {
             "data": "insertedGpsTime"
         },{
             "data": "packet"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
  }
  
  function getSubGridData(){
  
    if ($.fn.DataTable.isDataTable('#subTable')) {
            $('#subTable').DataTable().destroy();
        }
    
    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split(" ");
    var newStartDate="";
    if(startDate.length == 2){
    	sDate=startDate[0].split("/").reverse().join("-");
    	newStartDate = sDate+" "+startDate[1];
    }
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split(" ");
    var newEndDate="";
    if(endDate.length == 2){
    	eDate=endDate[0].split("/").reverse().join("-");
   		newEndDate = eDate+" "+endDate[1];
    } 
    //var statusType = document.getElementById("statusTypeDropDownId").value;
    var vehicleNo=document.getElementById("vehicleNoDropDownId").value;
     table = $('#subTable').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/MobileyeActivityAction.do?param=getMobileyeTransactionDataPull',
             "data": {
                 //CustId: customerId,
                 startDate: newStartDate,
                 endDate: newEndDate,
                 //statusType: statusType,
                 vehicleNo:vehicleNo
                 
             },
             "dataSrc": "validMobileye"
         },
         "bLengthChange": false,
         "iDisplayLength": 5,
         "dom": '<"toolbar">Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'API Transactions Get  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 				}
        	 				],
         "columns": [{
             "data": "slNoindex"
         }, {
             "data": "registrationNo"
         }, {
             "data": "unitNo"
         }, {
             "data": "requesttime"
         }, {
             "data": "fromtime"
         }, {
         	"data": "totime"
         }, {
         	"data": "status"
         },  {
             "data": "num_of_records"
         }],
          "columnDefs": [
      { "width": "40px", "targets": 0 },
      { "width": "100px", "targets": 1 },
      { "width": "100px", "targets": 2 },
      { "width": "150px", "targets": 3 },
      { "width": "150px", "targets": 4 },
      { "width": "150px", "targets": 5 },
      { "width": "150px", "targets": 6 },
      { "width": "100px", "targets": 7 }
    ]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

   }
   
     function getSubPullGridData(){
  
    if ($.fn.DataTable.isDataTable('#subPullTable')) {
            $('#subPullTable').DataTable().destroy();
        }
    
    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split(" ");
    var newStartDate="";
    if(startDate.length == 2){
    	sDate=startDate[0].split("/").reverse().join("-");
    	newStartDate = sDate+" "+startDate[1];
    }
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split(" ");
    var newEndDate="";
    if(endDate.length == 2){
    	eDate=endDate[0].split("/").reverse().join("-");
   		newEndDate = eDate+" "+endDate[1];
    } 
    //var statusType = document.getElementById("statusTypeDropDownId").value;
    var vehicleNo=document.getElementById("vehicleNoDropDownId").value;
     table = $('#subPullTable').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/MobileyeActivityAction.do?param=getMobileyeTransactionDataPush',
             "data": {
                 //CustId: customerId,
                 startDate: newStartDate,
                 endDate: newEndDate,
                 //statusType: statusType,
                 vehicleNo:vehicleNo
                 
             },
             "dataSrc": "validMobileye"
         },
         "bLengthChange": false,
         "iDisplayLength": 5,
         "dom": '<"toolbar">Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'API Transactions Post  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 				}
        	 				],
         "columns": [{
             "data": "slNoindex"
         }, {
             "data": "registrationNo"
         }, {
             "data": "unitNo"
         }, {
             "data": "requesttime"
         }, {
             "data": "fromtime"
         }, {
         	"data": "totime"
         }, {
         	"data": "status"
         },  {
             "data": "num_of_records"
         }],
          "columnDefs": [
      { "width": "40px", "targets": 0 },
      { "width": "100px", "targets": 1 },
      { "width": "100px", "targets": 2 },
      { "width": "150px", "targets": 3 },
      { "width": "150px", "targets": 4 },
      { "width": "150px", "targets": 5 },
      { "width": "150px", "targets": 6 },
      { "width": "100px", "targets": 7 }
    ]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

   }
		
	
    </script>
   <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 