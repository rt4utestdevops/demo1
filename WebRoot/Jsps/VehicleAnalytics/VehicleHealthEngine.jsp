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
<!--<html lang="en">  -->
   
      <title>Vehicle Health Engine</title>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
<!--		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">-->
		<link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
		<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
<!--		<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.1.3/css/fixedHeader.bootstrap.min.css">-->
<!--		<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.0/css/responsive.bootstrap.min.css">-->
<!--		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">-->
        <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
		<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">	
<!--		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.min.css" />	-->
		
		<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
		<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
		<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
		 
<style>

.well { 
    min-height: 20px !important;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #f5f5f5 !important;
    
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
	height: 40px !important;
}

.value{
	text-align: center;
	color: black;
	text-transform: none;
	font-weight: bold;
}

.valuelive{
	text-align: center;
	color: black;
	text-transform: none;
	font-weight: bold;
}


.headername
{
	text-align: center;
	font-weight: bold;
	font-size: 11px;
	font-variant: small-caps;
}

a {
    text-decoration: none !important;
}

body{
	background-color: #f5f5f5;
}

.custom{
	 padding-left: 15px;
	 padding-right: 15px;
	 margin-left: auto;
	 margin-right: auto;
	 padding-top: 10px;
	 }

 .panel {
         margin-bottom: 20px;
         background-color: #fff;
         border: 1px solid #333 !important;
         border-radius: 4px;
         -webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
         box-shadow: 0 1px 1px rgba(0,0,0,.05);
         }
.panel1 {
         margin-bottom: 20px;
         background-color: #fff;
         border: 1px solid #333 !important;
         border-radius: 4px;
         -webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
         box-shadow: 0 1px 1px rgba(0,0,0,.05);
		 height: 435px !important;
         }
.inputdateInput1 {
top: 3px; !important;

}
.dateInput1{
height: 32px !important;
}
.dateInput2{
height: 32px !important;
}
.panel-body {
    padding: 10px !important;
}
		 
}

</style>

<div color="#00FF00" style="scroll: none">

	<div class="custom" >
	 <div class="panel panel-primary">
      <div class="panel-heading">Vehicle Health Engine</div>
      <div class="panel-body">

					<div class="panel row" style="padding: 1%; margin: 0%;">

						<div class="col-xs-12 col-lg-3">
							<select class="form-control " id="eventId"
								onchange="getVehicle();loadDashboardData();">
								<option value="1">
									Engine Over Heating Report
								</option>
								<option value="2">
									Engine Error Code
								</option>
								<option value="3">
									Vehicle Electric Health
								</option>
								<option value="4">
									Mileage Report
								</option>
								<option value="5">
									Accident Analysis
								</option>
							</select>
						</div>

						<div class="col-xs-12 col-lg-2 ">
							<select class="form-control" id="vehicleDropDownId" >
								<option value="0" style="display:none">
									Select Vehicle No
								</option>
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
						<div class="col-xs-12 col-lg-2" style="margin-top: -0.2%;margin-left: 1%;">
							<input type="Submit" class="btn btn-primary" id="submit"
								value="Submit" onclick="getCoolentTempData();">
						</div>
					</div>

					<br>

		<div class="row">
        <div id="coolentDivId" class="col-lg-12 col-sm-12 col-xs-12 col-md-6" >
			  <div class="panel panel-primary">
				<div  class="panel-heading">Engine Over Heating Report</div>
				<div class="panel-body">
					<!-- <table class="table table-hover"> -->
					<table id="example1" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
	    <th style="display:none;">#</th>
		<th style="display:none;">Vehicle No</th>
        <th>Start Date Of Event</th>
		<th>End Date Of Event</th>
		<th>Max Coolant Value (Degree C)</th>
		<th>Duration (Min)</th>
		
      </tr>
    </thead>

  </table>
				
			</div>
		</div>
							
	</div>
        <div id="errorCodeDivId" class="col-lg-12 col-sm-12 col-xs-12 col-md-6">
			  <div class="panel panel-primary">
				<div class="panel-heading">Engine Error Code</div>
				<div class="panel-body">
						<table id="example2" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
	    <th style="display:none;">#</th>
		<th style="display:none;">Vehicle No</th>
        <th>Error Code</th>
        <th>Description</th>
        <th>Start Date Of Event</th>
		<th>End Date Of Event</th>
		<th>Impact</th>
      </tr>
    </thead>
  </table>			

				</div>
			  </div>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
     </div>
	</div>
    

	 	<div class="row">
        <div id="electricDivId"  class="col-lg-6 col-sm-12 col-xs-12 col-md-6" >
			  <div class="panel1 panel-primary">
				<div class="panel-heading">Vehicle Electric Health</div>
				<div class="panel-body">
					<table id="example3" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
	    <th style="display:none;">#</th>
		<th style="display:none;">Vehicle No</th>
        <th>High Voltage</th>
        <th>Date</th>
       	
      </tr>
    </thead>
    
  </table>
  				<div class="col-lg-12">
						<div class="well" style="height:65px !important">
							<p>
								<b>Impact:</b>Possible alternator regulator issue
								
							</p>
						</div>
					</div>
				</div>
				</div>
			  </div>
      
        <div id="electricDivId2"  class="col-lg-6 col-sm-12 col-xs-12 col-md-6" >
			  <div class="panel1 panel-primary">
				<div class="panel-heading">Vehicle Electric Health</div>
				<div class="panel-body">
					<table id="example5" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
	    <th style="display:none;">#</th>
		<th style="display:none;">Vehicle No</th>
        <th>Low Voltage</th>
        <th>Date</th>
        <th>Distance (Kms)</th>
      </tr>
    </thead>
    
  </table>
  				
				</div>
			  </div>
        </div>
     </div>
        <div id="mileageDivId" class="col-lg-12 col-sm-12 col-xs-12 col-md-6">
			  <div class="panel panel-primary">
				<div class="panel-heading">Mileage Report</div>
				<div class="panel-body">
					<table id="example4" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
        <th style="display:none;">#</th>
        <th style="display:none;">Vehicle No</th>
        <th>Date</th>
		<th>Fuel Consumed (ltr)</th>
		<th>Distance (Kmh)</th>
		<th>Mileage (Km/l)</th>
      </tr>
    </thead>
    
  </table>
  		<div class="col-lg-12">
					<div class="well">
						<p>
							<b>Note:</b>This report shows mileage for the previous 6 months.
							
						</p>
					</div>
				</div>
				</div>
			  </div>
        </div>
        <div id="accidentDivId" class="col-lg-12 col-sm-12 col-xs-12 col-md-6">
			  <div class="panel panel-primary">
				<div class="panel-heading">Accident Analysis</div>
				<div class="panel-body">
						<table id="example6" class="table table-striped table-bordered" cellspacing="0" width="100%">
						    <thead>
						      <tr>
							    <th style="display:none;">#</th>
								<th style="display:none;">Vehicle No</th>
						        <th>Date</th>
						        <th>Location</th>
						        <th>Description</th>
						      </tr>
						    </thead>
						 </table>			

				</div>
			  </div>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
     </div>
     
	</div>
	
</div>
</div>

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
		<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
		 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
		<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
<!--		<script src="https://cdn.datatables.net/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script> -->
<!--		<script src="https://cdn.datatables.net/responsive/2.2.0/js/dataTables.responsive.min.js"></script>-->
<!--		<script src="https://cdn.datatables.net/responsive/2.2.0/js/responsive.bootstrap.min.js"></script>-->
<!--        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>-->
	    <script src="../../Main/sweetAlert/sweetalert-dev.js"></script> 
<!--	    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>-->
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
		
	    
	  	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
		<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
		
<script type="text/javascript"> 
window.onload = function () { 
		getVehicle();
	}

var vehicleDetails;
var currentDate = new Date();
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);


   $(document).ready(function () {
   	document.getElementById("coolentDivId").style.display='block';
	document.getElementById("errorCodeDivId").style.display='none';
	document.getElementById("electricDivId").style.display='none';
	document.getElementById("electricDivId2").style.display='none';
	document.getElementById("mileageDivId").style.display='none';
	document.getElementById("accidentDivId").style.display='none';
	document.getElementById("dateInput1").style.display='block';
	document.getElementById("dateInput2").style.display='block';
   

 	$("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px',min: new Date(2017, 09, 01),max: new Date(2017, 10, 30)});
  	$('#dateInput1 ').jqxDateTimeInput('setDate', new Date(2017, 09, 01));
  	$("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px',min: new Date(2017, 09, 01),max: new Date(2017, 10, 30)});
  	$('#dateInput2 ').jqxDateTimeInput('setDate', new Date(2017, 10, 30));
});

function loadDashboardData(){

var id = document.getElementById("eventId").value;

if(id==1){
document.getElementById("coolentDivId").style.display='block';
document.getElementById("errorCodeDivId").style.display='none';
document.getElementById("electricDivId").style.display='none';
document.getElementById("electricDivId2").style.display='none';
document.getElementById("mileageDivId").style.display='none';
document.getElementById("accidentDivId").style.display='none';
document.getElementById("dateInput1").style.display='block';
document.getElementById("dateInput2").style.display='block';
}
if(id==2){
document.getElementById("coolentDivId").style.display='none';
document.getElementById("errorCodeDivId").style.display='block';
document.getElementById("electricDivId").style.display='none';
document.getElementById("electricDivId2").style.display='none';
document.getElementById("mileageDivId").style.display='none';
document.getElementById("accidentDivId").style.display='none';
document.getElementById("dateInput1").style.display='block';
document.getElementById("dateInput2").style.display='block';
}if(id==3){
document.getElementById("coolentDivId").style.display='none';
document.getElementById("errorCodeDivId").style.display='none';
document.getElementById("electricDivId").style.display='block';
document.getElementById("electricDivId2").style.display='block';
document.getElementById("mileageDivId").style.display='none';
document.getElementById("accidentDivId").style.display='none';
document.getElementById("dateInput1").style.display='block';
document.getElementById("dateInput2").style.display='block';
}if(id==4){
document.getElementById("coolentDivId").style.display='none';
document.getElementById("errorCodeDivId").style.display='none';
document.getElementById("electricDivId").style.display='none';
document.getElementById("electricDivId2").style.display='none';
document.getElementById("mileageDivId").style.display='block';
document.getElementById("accidentDivId").style.display='none';
document.getElementById("dateInput1").style.display='none';
document.getElementById("dateInput2").style.display='none';
}if(id==5){
document.getElementById("coolentDivId").style.display='none';
document.getElementById("errorCodeDivId").style.display='none';
document.getElementById("electricDivId").style.display='none';
document.getElementById("electricDivId2").style.display='none';
document.getElementById("mileageDivId").style.display='none';
document.getElementById("accidentDivId").style.display='block';
document.getElementById("dateInput1").style.display='block';
document.getElementById("dateInput2").style.display='block';
}

}

//##########function to get Vehicle details#############//
   
   function getVehicle(){
	 for (var i = document.getElementById("vehicleDropDownId").length - 1; i >= 1; i--) {
       document.getElementById("vehicleDropDownId").remove(i);
     }
	 
	var VehName;
	var veharray=[];
	var id = document.getElementById("eventId").value;
	var param = {
        reportId: id
    };
	$.ajax({
        url: '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getVehicle',
          data: param,
          success: function(result) {
                   vehicleDetails = JSON.parse(result);
         
            for (var i = 0; i < vehicleDetails["VehicleRoot"].length; i++) {
			veharray.push(vehicleDetails["VehicleRoot"][i].vehicleNo);
            //VehName = vehicleDetails["VehicleRoot"][i].vehicleNo;
           
			}
			$("#vehicleDropDownId").select2({
				  data: veharray
				});
<!--		for (i = 0; i < veharray.length; i++) {-->
<!--                var opt = document.createElement("option");-->
<!--                document.getElementById("vehicleDropDownId").options.add(opt);-->
<!--                opt.text = veharray[i];-->
<!--                opt.value = veharray[i];-->
<!--            }-->
		}
	});
   }

//#############function to get coolent temp grid data###################
	function daydiff(first, second) {
	   return (second-first)/(1000*60*60*24)
	}
	function parseDate(str) {
	   var mdy = str.split('/')
	   return new Date(mdy[2], mdy[1]-1, mdy[0]);
	}

  function getCoolentTempData(){
    
    if ($.fn.DataTable.isDataTable('#example1')) {
            $('#example1').DataTable().destroy();
        }
    
      var vehicleNo = document.getElementById("vehicleDropDownId").value;
   	 var id = document.getElementById("eventId").value;
   	var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
    var fromDate = document.getElementById('dateInput1').value;
    var toDate = document.getElementById('dateInput2').value;
    var noOfDays=daydiff(parseDate(fromDate), parseDate(toDate));
    if(vehicleNo == '' || vehicleNo == 0){
    	sweetAlert("Please select Vehicle No");
    	 return;
    }
   
   else if(noOfDays<0){
        sweetAlert("End Date must be greater than Start Date");
        return;
      }
          
   else{
       switch(parseInt(id))
       {
       case 1 : 
       getCoolent(startDate,endDate);
       break;
       case 2 :
       getEngineErrorCodeData(startDate,endDate);
       break;
       case 3 : 
        getelectricalHealthData(startDate,endDate);
    	getBatteryHealthDetails(startDate,endDate);
       break;
       case 4: 
       getMileageData(startDate,endDate);
       break;
       case 5: 
       getAccidentDetails(startDate,endDate);
       break;
       default:
       console.log("error");
       break;
       }
    }  
  }
    
//#############function to get engine error code grid data###################


function getCoolent(startDate,endDate){
  var vehicleNo = document.getElementById("vehicleDropDownId").value;
table = $('#example1').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getCoolentTempDetails',
             "data": {
                 vehicleNo: vehicleNo,
                 startDate: startDate,
                 endDate: endDate
             },
             "dataSrc": "coolentTempDetailsRoot"
         },
         "lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
         "bLengthChange": false,
         "columns": [{
             "data": "slnoIndex",
             "visible": false,
         }, {
             "data": "VehicleNoIndex",
             "visible": false,
         },  {
             "data": "startDateDataIndex"
         },{
             "data": "endDateDataIndex"
         }, {
             "data": "collentValueDataIndex"
         }, {
             "data": "durationDataIndex"
         }]
     });

}
  function getEngineErrorCodeData(startDate,endDate){
    
    if ($.fn.DataTable.isDataTable('#example2')) {
            $('#example2').DataTable().destroy();
        }
    
      var vehicleNo = document.getElementById("vehicleDropDownId").value;
   
    if(vehicleNo == ''){
    	sweetAlert("Please select Vehicle No");
    }
   else{
     table = $('#example2').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getEngineErrorCodeDetails',
             "data": {
                 vehicleNo: vehicleNo,
                 startDate: startDate,
                 endDate: endDate
             },
             "dataSrc": "engineErrorCodeDetailsRoot"
         },
         "lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
         "bLengthChange": false,
         "columns": [{
             "data": "slnoerrorIndex",
             "visible": false,
         }, {
             "data": "vehicleNoErrorIndex",
             "visible": false,
         }, {
             "data": "errorCodeDataIndex"
         }, {
             "data": "errorDescDataIndex"
         },{
             "data": "startDateErrorDataIndex"
         }, {
             "data": "endDateErrorDataIndex"
         }, {
             "data": "imactDataIndex"
         }]
     });
    }
  }


//#############function to get mileage grid data###################
  function getMileageData(startDate,endDate){
    
    if ($.fn.DataTable.isDataTable('#example4')) {
            $('#example4').DataTable().destroy();
        }
    
      var vehicleNo = document.getElementById("vehicleDropDownId").value;
   
    if(vehicleNo == ''){
    	sweetAlert("Please select Vehicle No");
    }
   else{
     table = $('#example4').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getMileageDetails',
             "data": {
                 vehicleNo: vehicleNo,
                 startDate: startDate,
                 endDate: endDate
             },
             "dataSrc": "mileageDetailsRoot"
         },
         "lengthMenu": [[6, 10, 50, -1], [6, 10, 50, "All"]] ,
         "bLengthChange": false,
         "columns": [{
             "data": "slnoMileageIndex",
             "visible": false,
         }, {
             "data": "vehicleNoMileageIndex",
             "visible": false,
         }, {
             "data": "dateMileageDataIndex"
         }, {
             "data": "fuelDataIndex"
         },{
             "data": "distanceMileageDataIndex"
         }, {
             "data": "mileageDataIndex"
         }]
     });
    }
  }
//#############function to get electrical Health grid data###################
  function getelectricalHealthData(startDate,endDate){
    
    if ($.fn.DataTable.isDataTable('#example3')) {
            $('#example3').DataTable().destroy();
        }
    
      var vehicleNo = document.getElementById("vehicleDropDownId").value;
   
    if(vehicleNo == ''){
    	sweetAlert("Please select Vehicle No");
    }
   else{
     table = $('#example3').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getElectricalHealthDetails',
             "data": {
                 vehicleNo: vehicleNo,
                 startDate: startDate,
                 endDate: endDate
             },
             "dataSrc": "electricalHealthDetailsRoot"
         },
         "lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
         "bLengthChange": false,
         "columns": [{
             "data": "slnoElectricalIndex",
             "visible": false,
         }, {
             "data": "vehicleNoElectricalIndex",
             "visible": false,
         },{
             "data": "batteryDataIndex"
         }, {
             "data": "dateBatteryDataIndex"
         }]
     });
    }
  }
 function getBatteryHealthDetails(startDate,endDate){
    
    if ($.fn.DataTable.isDataTable('#example5')) {
            $('#example5').DataTable().destroy();
        }
    
      var vehicleNo = document.getElementById("vehicleDropDownId").value;
   
    if(vehicleNo == ''){
    	sweetAlert("Please select Vehicle No");
    }
   else{
     table = $('#example5').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getBatteryHealthDetails',
             "data": {
                 vehicleNo: vehicleNo,
                 startDate: startDate,
                 endDate: endDate
             },
             "dataSrc": "batteryHealthDetailsRoot"
         },
         "lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
         "bLengthChange": false,
         "columns": [{
             "data": "slnoElectricalIndex2",
             "visible": false,
         }, {
             "data": "vehicleNoElectricalIndex2",
             "visible": false,
         },{
             "data": "batteryDataIndex2"
         }, {
             "data": "dateBatteryDataIndex2"
         }, {
             "data": "distanceDataIndex2"
         }]
     });
    }
  }
function getAccidentDetails(startDate,endDate){
    
    if ($.fn.DataTable.isDataTable('#example6')) {
            $('#example6').DataTable().destroy();
        }
    
      var vehicleNo = document.getElementById("vehicleDropDownId").value;
   
    if(vehicleNo == ''){
    	sweetAlert("Please select Vehicle No");
    }
   else{
     table = $('#example6').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/VehicleHealthEngineAction.do?param=getAccidentDetails',
             "data": {
                 vehicleNo: vehicleNo,
                 startDate: startDate,
                 endDate: endDate
             },
             "dataSrc": "accidentDetailsRoot"
         },
         "lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
         "bLengthChange": false,
         "columns": [{
             "data": "slnoAccidentIndex",
             "visible": false,
         }, {
             "data": "vehicleNoAccidentIndex",
             "visible": false,
         },{
             "data": "accidentDateDataIndex"
         }, {
             "data": "accidentLocationDataIndex"
         }, {
             "data": "accidentDescDataIndex"
         }]
     });
    }
  }

 </script>
 </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
