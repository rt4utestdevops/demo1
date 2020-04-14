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
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
      <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
      <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>
      
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />

       <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	  <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">


 <style>

.well {
    min-height: 90px ;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #f5f5f5 !important;
    border: 1px solid #333;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
	height: 92px !important;
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

 .row a {
    text-decoration: none !important;
    color: black !important;
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

.alertheader{
	margin-left:30px;
	font-size: 16px;
	font-weight: bold;
	width: 15px;
}

<!-- .actionBytotalHeader{ -->
	<!-- margin-left:40px; -->
	<!-- font-size: 20px; -->
	<!-- font-weight: bold; -->
	<!-- float:right !important;	 -->
	<!-- border: 1px solid black; -->
	<!-- border-radius: 4px; -->
	<!-- height:75 px !important; -->
	<!-- width: 75 px !important; -->
	<!-- background-color: red; -->
<!-- } -->

.actionBytotalHeader{
	display: inline-block;
    min-width: 10px;
    padding: 7px 7px;
    font-size: 17px;
    font-weight: 700;
    line-height: 1;
    color: coral;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    background-color: #464444;
    border-radius: 4px;
    float: right;
}

#page-loader{
  position:fixed;
  left: 50%;
  top: 35%;
  z-index: 1000;
  width:100%;
  height:100%;
  background-position:center;
  z-index:10000000;
  opacity: 0.7;
  filter: alpha(opacity=40); /* For IE8 and earlier */
}

		.sweet-alert button.cancel
		{
			background-color: #d9534f !important;
		}

		.sweet-alert button
		{
	 		background-color: #5cb85c !important;
		}
.row{width:100%;}

.dataTables_length{
   margin-right: 43%;
    margin-top: 1%;
}

.dataTables_filter{
	margin-left: 48%;
    margin-top: 1%;
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
		 .btn .caret {
    display: none;
}
.multiselect-container {
    overflow-y: auto;
    height: 211px !important;
}


</style>

<!-- <nav class="navbar navbar-inverse"> -->
  <!-- <div class="container-fluid"> -->
    <!-- <div class="navbar-header"> -->
      <!-- <img src="DHL Logo.png" text="dhllogo">  -->
    <!-- </div> -->
    <!-- <ul class="nav navbar-nav"> -->
      <!-- <li class="active"><a href="#">EXECUTIVE VIEW STATIC</a></li> -->
      <!-- <li><a href="#">EXECUTIVE VIEW LIVE</a></li> -->
      <!-- <li><a href="#">SERVICE LEVEL DASHBOARD</a></li> -->
      <!-- <li><a href="#">SMART TRUCK HEALTH</a></li> -->
      <!-- <li><a href="#">SMART TRUCKER BEHAVIOR</a></li> -->
	  <!-- <li><a href="#">UTILIZATION</a></li>  -->
	  <!-- <li><a href="#">REPORTS</a></li> -->
    <!-- </ul> -->
  <!-- </div> -->
<!-- </nav> -->

	<div class="custom" >
	 <div class="panel panel-primary">
      <div class="panel-heading">SMART TRUCK HEALTH</div>
      <div class="panel-body">

     <div class="panel row" style="padding:1% ;margin: 0%;">
			   <div class="col-md-12">
			   <div class="col-xs-12 col-md-3 ">
<!-- 			   <label> Make</label>	 -->		 
			  <select class="form-control"  multiple="multiple" id="OEMMakeList" onchange="getVehicleList();" >
<!--					<option value="0">Select OEM Make</option>-->
			    </select>
               </div>
			   <div class="col-xs-12 col-md-3 ">
<!--			   <label> Vehicle</label>	-->
			     <select class="form-control"  multiple="multiple" id="vehicleList" onchange="getTruckTypeList();">
<!--					<option value="0">Select VEHICLE ID</option>-->
				</select>
               </div>
			   <div class="col-xs-12 col-md-3 ">
<!--			   <label> Truck</label>	-->
			     <select class="form-control"  multiple="multiple" id="truckTypeList" >
<!--					<option value="0">SELECT TYPE</option>-->
				</select>
               </div>
			    <div class="col-xs-12 col-md-3 ">
								<input type="submit" class="btn btn-success" onclick="loadDashboardData('click')" style="border-radius:0px;" value="Submit"/>
				</div>
				<div class="col-xs-12 col-md-2 ">
               	</div>
				<div class="col-md-2">
			    </div>
			   </div>
			 </div>
<br>
	<div class="row">
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6" >
        <a href="#" onClick="showDiv('Power Train');">
          <div class="well" data-toggle="modal" data-target="">
		  		    <img src="../../Main/resources/images/dhl/Power Train.svg" alt="Power Train">
					<span class="alertheader" id="powerTrainHeader"> Power Train </span>
					<span class="actionBytotalHeader" id="powerTrainAlert"> 0/0 </span>
          </div>
		</a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv('Chasis');">
		  <div class="well" data-toggle="modal" data-target="">
		  		  <img src="../../Main/resources/images/dhl/Chasis.svg" alt="Chasis">
					<span class="alertheader" id="chasisHeader"> Chasis </span>
					<span class="actionBytotalHeader" id="chasisAlert"> 0/0 </span>
          </div>
		</a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv('Body');">
          <div class="well" data-toggle="modal" data-target="">
		   <img src="../../Main/resources/images/dhl/Body.svg" alt="Body">
					<span class="alertheader" id="bodyHeader"> Body </span>
					<span class="actionBytotalHeader" id="bodyAlert"> 0/0 </span>
		   </div>
          </div>
         </a>
      </div>


	 	<div class="row">
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6" >
        <a href="#" onClick="showDiv('Low Fuel Alert');">
          <div class="well" data-toggle="modal" data-target="">
		  <img src="../../Main/resources/images/dhl/fuel_alert.svg" alt="Low Fuel Alert">
					<span class="alertheader" id="lowFuelHeader"> Low Fuel Alert </span>
					<span class="actionBytotalHeader" id="lowFuelAlert"> 0/0 </span>
          </div>
       </a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv('Battery Voltage');">
		  <div class="well" data-toggle="modal" data-target="">
		    <div id="page-loader" style="margin-left:10px;display:none;">
					<img src="../../Main/images/loading.gif" alt="loader" />
				</div>
			<img src="../../Main/resources/images/dhl/Battery Voltage.svg" alt="Battery Voltage">
				<span class="alertheader" id="BatteryVoltageHeader"> Battery Voltage </span>
				<span class="actionBytotalHeader" id="batteryVolAlert"> 0/0 </span>
		  </div>
	  </a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv('Engine Coolant');">
          <div class="well">
           <img src="../../Main/resources/images/dhl/Engine coolant temprature.svg" alt="Engine Coolant temp">
				<span class="alertheader" id="engineCoolantHeader"> Engine Coolant Temperature </span>
				<span class="actionBytotalHeader" id="powerCoolantTemp"> 0/0 </span>
		  </div>
         </a>
        </div>
     </div>

	<div class="row">
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6" >
        <a href="#" onClick="showDiv('ABSEBS');">
          <div class="well" data-toggle="modal" data-target="">
			<img src="../../Main/resources/images/dhl/ABS_EBS_amber warning signals.svg" alt="ABS/EBS signal">
				<span class="alertheader" id="absEbsHeader">ABS/EBS Warning Signal </span>

				<span class="actionBytotalHeader" id="absebsSignal"> 0/0 </span>
			</div>
		</a>
        </div><!--
        showDiv('emmission');
        --><div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="">
		  <div class="well" data-toggle="modal" data-target="" style="cursor: not-allowed;">
			<img src="../../Main/resources/images/dhl/CO2 emission alert.svg" alt="Co2 emmision alert">
				<span class="alertheader" id="co2Header"> CO <sub>2</sub> Emision Alert </span>
				<span class="actionBytotalHeader" id="emmisAlert"> 0/0 </span>
		  </div>
	  </a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv('lowKmpl');">
          <div class="well" data-toggle="modal" data-target="">
			<img src="../../Main/resources/images/dhl/Low Kmpl alert.svg" alt="Low Kmpl alert">
				<span class="alertheader" id="lowKMPLHeader"> Low Kmpl Alert </span>
				<span class="actionBytotalHeader" id="lowKmplalert"> 0/0 </span>
		 </div>
         </a>
        </div>
     </div><!--
showDiv('tyreAMC');
	 --><div class="row">
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6" >
        <a href="#" onClick="">
          <div class="well" data-toggle="modal" data-target="" style="cursor: not-allowed;">
			<img src="../../Main/resources/images/dhl/Tyre AMC Alert.svg" alt="Tyre AMC alert">
				<span class="alertheader" id="TyreAMCHeader"> Tyre AMC Alert </span>
				<span class="actionBytotalHeader" id="tyreAMCalert"> 0/0 </span>
		 </div>
		</a>
        </div><!--
        showDiv('truckAMC');
        --><div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="">
		  <div class="well" data-toggle="modal" data-target="" style="cursor: not-allowed;">
         	<img src="../../Main/resources/images/dhl/Truck AMC alert.svg" alt="Truck AMC alert ">
				<span class="alertheader" id="TruckAMCHeader"> Truck AMC Alert  </span>
				<span class="actionBytotalHeader" id="truckAMCalert"> 0/0 </span>
          </div>
		</a>
        </div><!--
        showDiv('complaince');
        --><div class="col-lg-4 col-sm-12 col-xs-12 col-md-6" >
          <a href="#" onClick="">
          <div class="well" style="cursor: not-allowed;">
			<img src="../../Main/resources/images/dhl/compliance alert.svg" alt="compliance alert ">
				<span class="alertheader" id="complainceHeader"> Compliance Alert </span>
				<span class="actionBytotalHeader" id="complianceAlert"> 0/0 </span>
		  </div>
		  </a>
        </div>
     </div>
	 </div>
</div>
</div>

	 <div id="add" class="modal fade" style="margin-right: 2%;">
        <div class="modal-dialog" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:1200px;height:400px;">
            <div class="modal-content"  style="width:1000px;margin-left:-250px;">
                <div class="modal-header">
                    <h5 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Vehicle Details</h5>
										<button type="button" class="close" data-dismiss="modal">&times;</button>

								</div>
                <div class="modal-body" style="max-height: 100%;">
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12 col-sm-12" style="border: solid  1px lightgray;  margin-top:6px;">
                        	<table id="alertTable"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		 <th>Sl No</th>
		                                 <th>Vehicle No</th>
		                                 <th>Location</th>
		                                 <th>Date</th>
		                                 <th>Remarks</th>
		                                 <th>Action Taken</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		<div>
                    			<p id="totalPanel"></p>
                    		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

	 	 <div id="orderTableModel2" class="modal fade" style="margin-right: 2%;">
        <div class="modal-dialog" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:1200px;height:400px;">
            <div class="modal-content" style="width:1000px;margin-left:-250px;">
                <div class="modal-header">
                    <h5 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Vehicle Details</h5>
										<button type="button" class="close" data-dismiss="modal">&times;</button>

								</div>
                <div class="modal-body" style="max-height: 100%;">
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12 col-sm-12" style="border: solid  1px lightgray;  margin-top:6px;">
                        	<table id="orderTable2"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		<th>Sl No</th>
		                        		<th>Customer Name</th>
		                        		<th>Route Name</th>
		                        		<th>Vehicle No</th>
		                        	    <th>GPS Date</th>
		                        	    <th>Location</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		<div>
                    			<p id="totalPanel"></p>
                    		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-warning" onclick="reloadlocation()" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>


<script type="text/javascript"><!--
//history.pushState({ foo: 'fake' }, 'Fake Url', 'SmartTruckHealth#');
var alertTable;
var Make;
var vehicleId;
var truckTypeList;
getOEMMakeList();

function loadDashboardData(type){

  		var makecombo = "";
        var vehiclecombo = "";
        var truckcombo = "";
        var makeselected = $("#OEMMakeList option:selected");
        makeselected.each(function () {
            makecombo += $(this).val() + ",";
        });

        var selected = $("#vehicleList option:selected");
        selected.each(function () {
            vehiclecombo += $(this).val() + ",";
        });
        
		var truckselected = $("#truckTypeList option:selected");
        truckselected.each(function () {
            truckcombo += $(this).val() + ",";
        });   

    var combo1= makecombo.split(",").join(",");
	var combo2= vehiclecombo.split(",").join(",");
	var combo3= truckcombo.split(",").join(",");
	

Make=combo1;//document.getElementById("OEMMakeList").value;
vehicleId=combo2;//document.getElementById("vehicleList").value;
truckTypeList=combo3;//document.getElementById("truckTypeList").value;

if(type=='click')
{
if(Make==0)
{
	sweetAlert("Please select OEM Make");
}
else if(vehicleId==0)
{
	sweetAlert("Please Select Vehicle");
}
else if(truckTypeList==0)
{
	sweetAlert("Please Select Truck Type");
}
else {
 		var param = {
		//Make:Make,
		//vehicleId: vehicleId,
		//truckTypeList: truckTypeList
			makeList: combo1,
            vehicleList:combo2,
            truckTypeList:combo3
        };            
document.getElementById("page-loader").style.display="block";
$.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckHealthDBDetails',
        data: param,
        type: "POST",
        success: function(result) {
        document.getElementById("page-loader").style.display="none";
            var dashboard = JSON.parse(result);
            //alert(dashboard['smartTruckHealthAlertDetails'][0].topChasis);
            document.getElementById('powerTrainAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][0].topPowerTrain+'<span>/</span>'+ dashboard['smartTruckHealthAlertDetails'][1].totalPowerTrain;
            document.getElementById('chasisAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][0].topChasis+'<span>/</span>'+dashboard['smartTruckHealthAlertDetails'][1].totalChasis;
            document.getElementById('bodyAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][0].topBody+'<span>/</span>'+dashboard['smartTruckHealthAlertDetails'][1].totalBody;
            document.getElementById('batteryVolAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][2].topBatteryVoltageCount+'<span>/</span>'+dashboard['smartTruckHealthAlertDetails'][3].totalBatteryVoltageCount;
            document.getElementById('powerCoolantTemp').innerHTML=dashboard['smartTruckHealthAlertDetails'][4].toppowerCoolantCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][5].totalpowerCoolantCount;
            document.getElementById('lowFuelAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][6].toplowFuelCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][7].totallowFuelCount;
            document.getElementById('absebsSignal').innerHTML=dashboard['smartTruckHealthAlertDetails'][8].topABSEBSCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][9].totalABSEBSCount;
            document.getElementById('lowKmplalert').innerHTML=dashboard['smartTruckHealthAlertDetails'][10].toplowKmplCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][11].totallowKmplCount;
         }
    });
}
}
else
{
var param = {
		//Make:Make,
		//vehicleId: vehicleId,
		//truckTypeList: truckTypeList
			makeList: combo1,
            vehicleList:combo2,
            truckTypeList:combo3
        };
 document.getElementById("page-loader").style.display="block";
$.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckHealthDBDetails',
        data: param,
        type: "POST",
        success: function(result) {
         document.getElementById("page-loader").style.display="none";
            var dashboard = JSON.parse(result);
            //alert(dashboard['smartTruckHealthAlertDetails'][0].topChasis);
            document.getElementById('powerTrainAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][0].topPowerTrain+'<span>/</span>'+ dashboard['smartTruckHealthAlertDetails'][1].totalPowerTrain;
            document.getElementById('chasisAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][0].topChasis+'<span>/</span>'+dashboard['smartTruckHealthAlertDetails'][1].totalChasis;
            document.getElementById('bodyAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][0].topBody+'<span>/</span>'+dashboard['smartTruckHealthAlertDetails'][1].totalBody;
            document.getElementById('batteryVolAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][2].topBatteryVoltageCount+'<span>/</span>'+dashboard['smartTruckHealthAlertDetails'][3].totalBatteryVoltageCount;
            document.getElementById('powerCoolantTemp').innerHTML=dashboard['smartTruckHealthAlertDetails'][4].toppowerCoolantCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][5].totalpowerCoolantCount;
            document.getElementById('lowFuelAlert').innerHTML=dashboard['smartTruckHealthAlertDetails'][6].toplowFuelCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][7].totallowFuelCount;
            document.getElementById('absebsSignal').innerHTML=dashboard['smartTruckHealthAlertDetails'][8].topABSEBSCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][9].totalABSEBSCount;
            document.getElementById('lowKmplalert').innerHTML=dashboard['smartTruckHealthAlertDetails'][10].toplowKmplCount+'<span>/<span>'+dashboard['smartTruckHealthAlertDetails'][11].totallowKmplCount;
         }
    });
}
}

function getOEMMakeList(){

var OEMMakeList;
var OEMMakearray = [];
var OEMMakearray2 = [];
document.getElementById("page-loader").style.display="block";
		$.ajax({
		type: "POST",
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getOEMMakeList',
          success: function(result) {
          document.getElementById("page-loader").style.display="none";
                   OEMMakeList = JSON.parse(result);
            for (var i = 0; i < OEMMakeList["OEMMakeList"].length; i++) {
			OEMMakearray.push(OEMMakeList["OEMMakeList"][i].OEMMakeName)
			OEMMakearray2.push(OEMMakeList["OEMMakeList"][i].OEMMakeId)
			}

			for (i = 0; i < OEMMakearray.length; i++) {
   			 $('#OEMMakeList').append('<option value='+OEMMakearray2[i]+'>'+OEMMakearray[i]+'</option>')
	            }
	             $('#OEMMakeList').multiselect({
	            nonSelectedText:'Select Make',
 				includeSelectAllOption: true,
 				 numberDisplayed: 1
 				});
				$("#OEMMakeList").multiselect('selectAll', false);
  				$("#OEMMakeList").multiselect('updateButtonText');
  				getVehicleList();
			}
			 });
			 
 }

function getVehicleList(){

		var makecombo = "";
      
        var makeselected = $("#OEMMakeList option:selected");
        makeselected.each(function () {
            makecombo += $(this).val() + ",";
        });

		var vehicleList;
		var vehiclerarray = [];
		var OEMMake=makecombo;//document.getElementById("OEMMakeList").value;

 	var param = {
		OEMMake:OEMMake
    };

    if(OEMMake.length > 0){
		$.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehicleList',
        data:param,
          success: function(result) {
                   vehicleList = JSON.parse(result);
                   $('#vehicleList').empty();
                   $('#vehicleList').multiselect('destroy'); 
	            	for (var i = 0; i < vehicleList["vehicleListRoot"].length; i++) {
					var vehicleName=vehicleList["vehicleListRoot"][i].vehicleName;
				 	$('#vehicleList').append($("<option></option>").attr("value",vehicleName).text(vehicleName));
			}
			$('#vehicleList').multiselect({
	            nonSelectedText:'Select Vehicle Type',
 				includeSelectAllOption: true,
 				 numberDisplayed: 1
 				});
				$("#vehicleList").multiselect('selectAll', false);
  				$("#vehicleList").multiselect('updateButtonText');
  				getTruckTypeList();
		}		
	});
	}
 }

function getTruckTypeList()
{
        var vehiclecombo = "";
          
        var selected = $("#vehicleList option:selected");
        selected.each(function () {
            vehiclecombo += $(this).val() + ",";
        });
        
	var truckTypeList;
	var truckTypearray = [];
	var vehicleList=vehiclecombo;//document.getElementById("vehicleList").value;
	for(var i = document.getElementById("truckTypeList").length - 1; i >= 1; i--) {
		        document.getElementById("truckTypeList").remove(i);
		    }
			 var param = {
			TruckType:vehicleList
	        };
  
	        if(vehicleList.length > 0){
			$.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTruckTypeList',
	        data:param,
	        type: "POST",
	          success: function(result) {
	                   truckTypeList = JSON.parse(result);
                   	   $('#truckTypeList').empty();
                   	   $('#truckTypeList').multiselect('destroy'); 
	             	for (var i = 0; i < truckTypeList["truckTypeList"].length; i++) {
				 		var truckType=truckTypeList["truckTypeList"][i].VehicleType;
				 		$('#truckTypeList').append($("<option></option>").attr("value",truckType).text(truckType));
				    }
					$('#truckTypeList').multiselect({
	            		nonSelectedText:'Select Truck Type',
 						includeSelectAllOption: true,
 				 		numberDisplayed: 1
 					});
				$("#truckTypeList").multiselect('selectAll', false);
  				$("#truckTypeList").multiselect('updateButtonText');
				
			}
		});
		}
		//setTimeout(function(){loadDashboardData('click');},1000);
 }

function showDiv(alertType)
{
	//var oemMake=document.getElementById("OEMMakeList").value;
	//var vehicleId=document.getElementById("vehicleList").value;
	//var truckTypeList=document.getElementById("truckTypeList").value;
	
	  	var oemMake = "";
        var vehicleId = "";
        var truckTypeList = "";
        var makeselected = $("#OEMMakeList option:selected");
        makeselected.each(function () {
            oemMake += $(this).val() + ",";
        });

        var selected = $("#vehicleList option:selected");
        selected.each(function () {
            vehicleId += $(this).val() + ",";
        });
        
		var truckselected = $("#truckTypeList option:selected");
        truckselected.each(function () {
            truckTypeList += $(this).val() + ",";
        });   

    var combo1= oemMake.split(",").join(",");
	var combo2= vehicleId.split(",").join(",");
	var combo3= truckTypeList.split(",").join(",");
	//alert("oemMake : " + oemMake);
	//alert("vehicleId : " + vehicleId);
	//alert("truckTypeList : " + truckTypeList);
	
   if ($.fn.DataTable.isDataTable('#alertTable')) {
           $('#alertTable').DataTable().destroy();
       }

   		 if(alertType=='Power Train')
		 {
			$("#tripDetailsTitle").text("Power Train Details");
		 }
		 else if(alertType=='Chasis')
		 {
		  $("#tripDetailsTitle").text("Chasis Details");
		 }
		 else if(alertType=='Body')
		 {
			$("#tripDetailsTitle").text("Body Details");
		 }
		 else if(alertType=='Low Fuel Alert')
		 {
			   $("#tripDetailsTitle").text("Low Fuel Details");
		 }
		 else if(alertType=='Battery Voltage')
		 {
			$("#tripDetailsTitle").text("Battery Voltage Details");
		 }
		 else if(alertType=='Engine Coolant')
		 {
			$("#tripDetailsTitle").text("Engine Coolant Details");
		 }
		 else if(alertType=='ABSEBS')
		 {
			$("#tripDetailsTitle").text("ABS/EBS Details");
		 }
		 else if(alertType=='emmission')
		 {
			 $("#tripDetailsTitle").text("Co2 Emission Details");
		 }
		 else if(alertType=='lowKmpl')
		 {
			$("#tripDetailsTitle").text("Low Kmpl Details");
		 }
		  else if(alertType=='lowKmpl')
		 {
			$("#tripDetailsTitle").text("Low Kmpl Details");
		 }
		 else if(alertType=='tyreAMC')
		 {
			 $("#tripDetailsTitle").text("Tyre AMC Details");
		 }
		 else if(alertType=='truckAMC')
		 {
			 $("#tripDetailsTitle").text("Truck AMC Details");
		 }
		 else if(alertType=='complaince')
		 {
			 $("#tripDetailsTitle").text("Complaince Details");
		 }

   $('#add').modal('show');
   alertTable = $('#alertTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartTruckHealthAlertDetails",
		            "dataSrc": "TruckHealthAlertDetails",
		            "data":{
		            	uniqueId : alertType,
		            	oemMake : oemMake,
		            	vehicleId:vehicleId,
		            	vehicleType: truckTypeList,
		            },
		            type: "POST"
		        },
		        //"bProcessing": true,
		        "sScrollX": "100%",
		        "sScrollY": "200px",
		        "bDestroy": true,
		        "lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    			},
	        	"lengthChange":true,
		         "columns": [{
                	"data": "slNoIndex"
	            }, {
	                "data": "vehicleNoIndex"
	            }, {
	                "data": "locationIndex"
	            }, {
	                "data": "dateTimeIndex"
	            }, {
	                "data": "remarksIndex"
	            }, {
	                "data": "button"
	            }]
	 		});

}

     function Acknowledge(uniqueId) {

        swal({
                title: "",
                text: "Enter Remarks:",
                type: "input",
                showCancelButton: true,
                closeOnConfirm: false,
                animation: "slide-from-top",
                inputPlaceholder: "Enter Remarks"
            },
            function(inputValue) {
                if (inputValue === "") {
                    swal.showInputError("Enter Remarks!");
                    return false;
                } else if(inputValue === true) {
                	//alert("upadte ");

                }else if(typeof(inputValue)=="string"){
                    $.ajax({
                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateActionTaken',
                        data: {
                            uniqueId: uniqueId,
                            remarks: inputValue
                        },
                        success: function(result) {
                               sweetAlert(result);
                                alertTable.ajax.reload();
                        }
                    })
                }
            },
            function() {
                alert();
            })
    }

 	     function Acknowledge2(vehicleNo,errorCode) {

        swal({
                title: "",
                text: "Enter Remarks:",
                type: "input",
                showCancelButton: true,
                closeOnConfirm: false,
                animation: "slide-from-top",
                inputPlaceholder: "Enter Remarks"
            },
            function(inputValue) {
                if (inputValue === "") {
                    swal.showInputError("Enter Remarks!");
                    return false;
                } else if(inputValue === true) {
                	//alert("upadte ");

                }else if(typeof(inputValue)=="string"){
                    $.ajax({
                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateActionTakenEngineCoolant',
                        data: {
                            uniqueId: vehicleNo,
                            errorCode: errorCode,
                            remarks: inputValue
                        },
                        success: function(result) {
                               sweetAlert(result);
                                alertTable.ajax.reload();
                        }
                    })
                }
            },
            function() {
                alert();
            })
    }
	 	$('#add').on('hidden.bs.modal', function (e) {
    	//loadDashboardData('custom');
})
--></script>
<jsp:include page="../Common/footer.jsp" />
