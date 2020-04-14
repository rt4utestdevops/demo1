<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
    String excelUploadMsg = "";
    String excelUploadMsgs = "";

    if(session.getAttribute("excelUploadMsg")!=null){
	    excelUploadMsg=session.getAttribute("excelUploadMsg").toString();
    }
     if(session.getAttribute("excelUploadMsgs")!=null){
	    excelUploadMsgs=session.getAttribute("excelUploadMsgs").toString();
    }
%>
<jsp:include page="../Common/header.jsp" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet" />
<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet" />
<link href="../../Main/custom.css" rel="stylesheet" type="text/css">
<link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
<script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@7.12.15/dist/sweetalert2.all.min.js"></script>
<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/sweetalert2@7.12.15/dist/sweetalert2.min.css'>
<style>

.swal2-container{
	z-index:100000000;
}
   .modal {
   position: fixed;
   top: 5%;
   left: 0%;
   z-index: 10500;
   width: 88%;
   bottom: unset;
   background-color: #ffffff;
   border: 1px solid #999;
   border: 1px solid rgba(0, 0, 0, 0.3);
   -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
   -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
   box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
   -webkit-background-clip: padding-box;
   -moz-background-clip: padding-box;
   background-clip: padding-box;
   outline: none;
   border-radius: 4px;
   overflow-y: auto;
   }
   .nav-tabs {
   border-bottom: 1px dotted black;
   height: 40px;
   padding-top: 4px;
   font-size: 16px;
   margin-left: 10px;
   }
   .nav-tabs>li.active>a,.nav-tabs>li.active>a:hover,.nav-tabs>li.active>a:focus {
   color: #555;
   cursor: default;
   background-color: #fff;
   border: 1px dotted black;
   border-bottom-color: transparent;
   height: 32px;
   padding-top: 4px;
   }
   .modal-content .modal-body {
   padding-top: 24px;
   padding-right: 24px;
   padding-bottom: 16px;
   padding-left: 24px;
   overflow-y: auto;
   max-height: 400px;
   }
   .modal-open .modal {
   overflow-x: hidden;
   overflow-y: hidden;
   }
   #smarthubImportModal {
   border-radius: 4px;
   }
   .sweet-alert button.cancel {
   background-color: #d9534f !important;
   }
   .sweet-alert button {
   background-color: #5cb85c !important;
   }
   .file {
   visibility: hidden;
   position: absolute;
   }
   .caret {
   display: none;
   }
   .row {
   margin-right: 0px !important;
   margin: auto;
   width: 100%;
   margin-top: 0px;
   }
   .col-md-4 {
   padding: 0px;
   }
   .col-sm-2,.col-sm-1,.col-sm-4,.col-md-2,.col-md-1,.col-lg-2,.col-lg-1,.col-lg-12
   {
   padding: 0px;
   }
   .inner-row-card {
   border-top: 1px solid black !important;
   }
 
   .inner-row-card .col-md-4 {
   margin-top: 16px;
   padding: 1px;
   }
   .blueGrey { /*background: #607D8B*/
   background: #337ab7;
   }
   .blueGreyLight {
   background: #ECEFF1;
   }
   .headerText {
   text-align: left;
   color: white;
   padding: 8px 4px 8px 0px;
   }
   .close {
   float: right;
   display: inline-block;
   padding: 0px 12px 0px 8px;
   }
   
  
   .close:hover {
   cursor: pointer;
   }
   .col-lg-4 {
   padding: 8px;
   margin: 0px;
   }
   .col-lg-8,.col-lg-6 {
   padding: 8px;
   margin: 0px;
   }
   .center-view {
   top: 40%;
   left: 50%;
   position: fixed;
   height: 200px;
   width: 200px;
   }
   .blueGreyDark {
   background: #337ab7;
   }
   .pointer {
   cursor: pointer;
   }
   .btnScreen {
   width: 140px;
   font-size: 18px;
   padding-top: 2px;
   height: 32px;
   border: 0px;
   }
   .createTrip {
   <!--	font-size: 16px !important;-->
   height: 200px !important;
   width: 60% !important;
   margin-left: 20% !important;
   margin-top:30px;
   }
   .list-group-item {
   padding-top: 0px;
   padding-bottom: 0px;
   }
   .col-lg-8,.col-lg-4 {
   padding: 4px;
   }
   #tblAssociateVehicles,#tblHubMaster,#tblAT,#tblDelay,#tblUnassignedVehicles
   {
   border: 1px solid #AAAAAA !important;
   }
   label.myLabel input[type="file"] {
   position: absolute;
   top: -1000px;
   }
   /***** Example custom styling *****/
   .myLabel {
   background: none;
   display: inline-block;
   position: absolute;
   right: 56px;
   cursor: pointer;
   font-size: 16px;
   }
   .downloadClass {
   position: absolute;
   right: 24px;
   color: white;
   cursor: pointer;
   font-size: 32px;
   }
   .multiselect-container {
   overflow-y: auto;
   height: 211px !important;
   width: 200px !important;
   font-size: 11px;
   }
   .multiselect {
   width: 200px !important;
   height: 34px;
   border: 1px solid !important;
   }
   .col-md-1 {
   padding-right: 8px;
   }
   .form-control-filter {
   float: right;
   border-radius: 2px;
   border: none;
   z-index: 100;
   border: 1px solid;
   height: 34px !important;
   padding: 0px 0px 0px 8px;
   }
   .form-control-filter:focus {
   border: none;
   border: 1px solid;
   box-shadow: none;
   -webkit-box-shadow: none;
   }
   .form-label-group {
   position: relative;
   width: 100%;
   margin-bottom: 1rem;
   }
   .form-label-group-axis-left {
   position: relative;
   float: left;
   width: 50%;
   margin-bottom: 1rem;
   }
   .form-label-group-axis-right {
   position: relative;
   float: right;
   padding-left: 5px;
   width: 50%;
   margin-bottom: 1rem;
   }
   .multiselect-container>li>a {
   margin-left: -15px;
   }
   .btn-file input[type=file] {
   top: 0;
   left: 0;
   min-width: 100%;
   min-height: 100%;
   text-align: right;
   opacity: 0;
   background: none;
   cursor: inherit;
   display: block;
   }
   .modalupload {
   font-size: 16px !important;
   height: 233px !important;
   width: 58% !important;
   margin-left: 20% !important;
   }
   .table {
   width: 100%;
   max-width: 100%;
   margin-bottom: 1rem;
   background-color: transparent;
   font-size: 12px;
   }
   a {
   color: white;
   }
   .greenBorder{
   border:3px solid green !important;
   }
   .unloading{
   font-size:14px;color:#2f8386;
   }
   #select2-userNames-container{
   	padding-left: 34px;
   }
   .modalHeader{
	  border-radius: 4px; width: 100%; padding-top: 8px; height: 40px; border-bottom: 1px solid black;
	}
	  .blink {
      animation: blink 2s steps(5, start) infinite;
      -webkit-animation: blink 1s steps(5, start) infinite;
    }
    @keyframes blink {
      to {
        visibility: hidden;
      }
    }
    @-webkit-keyframes blink {
      to {
        visibility: hidden;
      }
    }
    .dataTables_filter {
    	margin-top: -34px;
    }
    #tblAssociateVehicles tr td {
	    height: 10px;
	}
	.dataTables_wrapper {
		margin-top:6px;
	}
	tbody{
		font-weight:normal;
	}
	.w3-card-4 {
	box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
    margin:-0px -4px 0px -4px;
 	padding-bottom: 8px;
 	padding-left:8px;
	padding-right:8px;
	width: 99.9%;
    margin-left: 1px;
	}
	#createTitle{
		text-align: center;
	    margin-left: 69px;
	    color: white;
	}
	.invalid{
		border: red 1px solid;
	}
	.dt-buttons{
		display:flex;

	}
	div.dataTables_scrollBody thead {
    display: none;
} label.myLabelFile input[type="file"] {
   position: absolute;
   top: -1000px;
   }
   /***** Example custom styling *****/
   .myLabelFile {
	   background: none;
	   display: inline-block;
	   position: absolute;
	   left: 210px;
	   top:8px;
	   cursor: pointer;
	   font-size: 16px;
   }
   .divTime {
	    background: none;
	   display: inline-block;
	   position: absolute;
	   left: 360px;
	   top:16px;
	   cursor: pointer;
	   font-size: 16px;
   }
   .form-control{
   	  border: 1px solid #101010;
   }
   table{
	  table-layout: fixed; // ***********add this
	  word-wrap:break-word; // ***********and this
   }
   .select2-selection {
	  height: 34px;
	  border: 1px solid #101010;
	}
	.excel_button {
	margin-top: -38px;
    font-size: 14px;
    padding-top: 5px;
    width: 9%;

	}

#tblTAT_filter{
	margin-top:0px;
}

</style>

<div class="center-view" style="display: none;" id="loading-div">
   <img src="../../Main/images/loading.gif" alt="">
</div>
<!-- content -->
<div class="row" style="margin-top: -16px;    font-size: 16px;">
   <div class="col-lg-4 col-md-4 col-sm-12">
      <div class="row">
         <div class="col-lg-12">
            <div class="headerText blueGrey">
               <img src="/ApplicationImages/VehicleImages/delivery-van.png"
                  style="width: 30px; margin-left: 16px; height: 25px;" />
               <span style="margin-left: 12px; font-weight: bold;">Total Vehicles</span>
            </div>
            <ul class="list-group"
               style="border-bottom: 0px !important; margin-bottom: 0px; font-weight: bold;">
               <li class="list-group-item">
                  <div class="col-lg-8">
                     In-Transit
                  </div>
                  <div class="col-lg-4" id="inTransit"></div>
                  <div class="unloading col-lg-8">
                     Unloading
                  </div>
                  <div class="unloading col-lg-4 pointer" id="unloading" onclick="getUnloadingVehicles('TOTAL');" ></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     Planned
                  </div>
                  <div class="col-lg-4" id="planned"></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     Available
                  </div>
                  <div class="col-lg-4 pointer" id="available" onclick="getAvailableVehicles('TOTAL');"></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     GPS Non-Communicating
                  </div>
                  <div class="col-lg-4 pointer" id="nonComm" onclick="getNonCommVehicles('TOTAL');"></div>
               </li>
            </ul>
         </div>
      </div>
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
      <div class="row">
         <div class="col-lg-12">
            <div class="headerText blueGrey">
               <img src="/ApplicationImages/VehicleImages/delivery-van.png"
                  style="width: 30px; margin-left: 16px; height: 25px;" />
               <span style="margin-left: 12px; font-weight: bold;">TCL Vehicles</span>
            </div>
            <ul class="list-group"
               style="border-bottom: 0px !important; margin-bottom: 0px; font-weight: bold;">
               <li class="list-group-item">
                  <div class="col-lg-8">
                     In-Transit
                  </div>
                  <div class="col-lg-4" id="inTransitTCL"></div>
                  <div class="unloading col-lg-8">
                     Unloading
                  </div>
                  <div class="unloading col-lg-4 pointer" id="unloadingTCL" onclick="getUnloadingVehicles('TCL');" ></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     Planned
                  </div>
                  <div class="col-lg-4" id="plannedTCL"></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     Available
                  </div>
                  <div class="col-lg-4 pointer" id="availableTCL" onclick="getAvailableVehicles('TCL');"></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     GPS Non-Communicating
                  </div>
                  <div class="col-lg-4 pointer" id="nonCommTCL" onclick="getNonCommVehicles('TCL');"></div>
               </li>
            </ul>
         </div>
      </div>
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
      <div class="row">
         <div class="col-lg-12">
            <div class="headerText blueGrey">
               <img src="/ApplicationImages/VehicleImages/delivery-van.png"
                  style="width: 30px; margin-left: 16px; height: 25px;" />
               <span style="margin-left: 12px; font-weight: bold;">Dry
               Vehicles</span>
            </div>
            <ul class="list-group"
               style="border-bottom: 0px !important; margin-bottom: 0px; font-weight: bold;">
               <li class="list-group-item">
                  <div class="col-lg-8">
                     In-Transit
                  </div>
                  <div class="col-lg-4" id="inTransitDry"></div>
                  <div class="unloading col-lg-8">
                     Unloading
                  </div>
                  <div class="unloading col-lg-4 pointer" id="unloadingDry" onclick="getUnloadingVehicles('DRY');" ></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     Planned
                  </div>
                  <div class="col-lg-4" id="plannedDry"></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     Available
                  </div>
                  <div class="col-lg-4 pointer" id="availableDry" onclick="getAvailableVehicles('DRY');"></div>
               </li>
               <li class="list-group-item">
                  <div class="col-lg-8">
                     GPS Non-Communicating
                  </div>
                  <div class="col-lg-4 pointer" id="nonCommDry" onclick="getNonCommVehicles('DRY');"></div>
               </li>
            </ul>
         </div>
      </div>
   </div>
</div>
<div class="row">
   <div class="col-lg-12">
      <hr style="width: 100%; margin-top: 4px; margin-bottom: 8px;" />
   </div>
</div>
<div class="tabs-container blueGrey" style="color: white;">
   <ul class="nav nav-tabs">
      <li class="active">
         <a href="#criteriaTabPane" onClick="loadCriteriaDetails()" data-toggle="tab" active
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Define Criteria</a>
      </li>
      <li>
         <a href="#associateVehiclesTabPane" onClick="loadAssociatedData()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Associate Vehicles</a>
      </li>
      <li>
         <a href="#hubSupervisorTabPane" id='hubTab' onClick="loadHubData()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;display:none;">Hub</a>
      </li>
      <li>
         <a href="#aggressiveTatTabPane" id='aggressiveTab' onClick="loadTATData()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Aggressive TAT</a>
      </li>
      <li>
         <a href="#delayTabPane" id='delayTab' onClick="loadDelayData()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Delay Codes View</a>
      </li>
      <li>
         <a href="#vehicldCountTabPane" id='vehicleTabId' onClick="loadVehicleCounts()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Association Summary</a>
      </li>
      <li>
         <a href="#associatedDetailsTabPane" id='associatedTabId' onClick="loadAllAssociatedVehicles()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Associated Vehicles</a>
      </li>
      <li>
         <a href="#supervisorScheduleTabPane" id='supervisorScheduleTabId' onClick="loadAllSupervisorSchedule()" data-toggle="tab"
            style="margin: 0px; border-radius: 0px; font-size: 16px; font-weight: 600; height: 32px; padding-top: 4px;">Supervisor Schedule</a>
      </li>
      <label class="myLabel" id="addButtonTat" style="display:none;">
      <span><i class="glyphicon glyphicon-plus" title="Add TAT Details" onclick="openAggressiveTat()"
         style="color: white;font-size: 28px;"></i> </span>
      </label>
      <label class="myLabel" id="addButtonDelay" style="display:none;">
      <span><i class="glyphicon glyphicon-plus" title="Add Delay Details" onclick="openDelayWindow()"
         style="color: white;font-size: 28px;"></i> </span>
      </label>
   </ul>
</div>
<div class="tab-pane active" id="criteriaTabPane">
   <div class="w3-card-4">
      <div class="card-body" style="padding:0px !important">
         <div class="row" style="padding-top: 10px;">
            <div class="col-md-2">
               <select class="form-control form-control-custom" id="customers" multiple></select>
            </div>
            <div class="col-md-2">
               <select class="form-control form-control-custom" id="segmentType" multiple></select>
            </div>
            <div class="col-md-2">
               <select class="form-control form-control-custom" id="vehType" multiple></select>
            </div>
            <div class="col-md-2">
               <select class="form-control form-control-custom" id="categoryType" multiple>
                  <option>Dry</option>
                  <option>TCL</option>
               </select>
            </div>
            <div class="col-md-2">
               <input type="text" class="form-control comboClass" maxLength="100" id="criteriaNameId" placeholder="Enter Criteria Name" required>
            </div>
            <div class="col-md-1">
               <button id="criteriaBtnId"
                  class="btn btn-generate btn-md  btn-primary btnScreen"
                  style="margin-left: 8px;font-size: 14px;padding-top: 6px;" onclick="saveCriteriaDetails();">
               Freeze Criteria
               </button>
            </div>
            <div class="col-md-1">
               <button id="cancelBtn"
                  class="btn btn-generate btn-md  btn-primary btnScreen"
                  style="display:none;margin-left: 43px;font-size: 14px;padding-top: 6px;width: 66px;" onclick="cancel();">
               Cancel
               </button>
            </div>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <table id="tblCriteriaDetails" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>Criteria Name</th>
                  <th>Customer Name</th>
                  <th>Customer Type</th>
                  <th>Vehicle Type</th>
                  <th>Trip Category</th>
                  <th>Edit</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<div class="tab-pane" id="associateVehiclesTabPane">
   <div class="w3-card-4">
      <div class="card-body" style="padding:0px !important">
         <div class="row" style="padding-top: 10px;">
            <div class="col-md-2" style="padding: 0px;">
               <select class="form-control form-control-custom" id="userNames" multiple> </select>
            </div>
            <div class="col-md-2" style="padding: 0px;">
               <select class="form-control form-control-custom" id="criteriaNames">
                  <option value="0">Select Criteria</option>
               </select>
            </div>
            <div>
               <button id="btnAssociate" style="width: 97%;margin-left: 11px;padding-top: 3px;padding-left: 3px;font-size: 14px;"
                  class="btn btn-generate btn-md  btn-primary btnScreen" onClick="validateAssociate();">
               Associate
               </button>
            </div>
            <div>
               <button id="btnGetAssociatedVehicles" style="width: 97%;margin-left: 11px;padding-top: 3px;padding-left: 3px;font-size: 14px;"
                  class="btn btn-generate btn-md  btn-primary btnScreen"
                  onClick="getAssociatedVehicles(false)">
               Get Associated Vehicles
               </button>
            </div>
            <div class="">
               <button id="resetbtn" style="margin-left: 11px;;font-size: 14px;padding-top: 3px;width:82%"
                  class="btn btn-generate btn-md  btn-primary btnScreen"
                  onClick="reset()">
               Reset
               </button>
            </div>
            <div class="col-md-1">
               <i id="alertId" class="fa fa-bell" style="cursor:pointer;font-size:28px;color:red;margin-left:10px;" title="Click to view the unassigned vehicle list" onclick="getUnassignedVehicles();"></i>
            </div>
         </div>
      </div>
   </div>
   <div class="row" id="tblAssociateVehiclesRowId">
      <div class="col-lg-12">
         <table id="tblAssociateVehicles" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>Vehicle No</th>
                  <th>Vehicle Type</th>
                  <th>Customer Name</th>
                  <th>Trip Category</th>
                  <th>TAT</th>
                  <th>Criteria Name</th>
                  <th>Disassociate</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<div class="tab-pane" id="hubSupervisorTabPane">
   <div class="row">
      <div class="col-lg-12">
         <table id="tblHubMaster" class="table table-striped table-bordered" cellspacing="0" width="100%">
         </table>
      </div>
   </div>
</div>
<div class="tab-pane" id="aggressiveTatTabPane">
   <div class="row" id="addAggTatWin" style="padding-top: 10px;display:none;">
      <div class="col-md-2" style="padding: 0px 10px 10px 10px;">
         <select class="form-control" id="source">
            <option value="0">Select Source</option>
         </select>
      </div>
      <div class="col-md-2" style="padding: 0px 10px 10px 10px;">
         <select class="form-control" id="destination">
            <option value="0">Select Destination</option>
         </select>
      </div>
      <div class="col-md-2" style="    padding: 0px 10px 10px 10px;">
         <input class="form-control" id="TATId" placeholder="Enter TAT in HH:mm" style="height: 28px !important;">
      </div>
      <div class="col-md-4">
         <button id="saveTatId" style="margin-left: 11px;"
            class="btn btn-generate btn-md  btn-primary" onClick="saveAggressiveTatDetails()">
         Save
         </button>
      </div>
   </div>
   <div class="col-lg-12">
      <div class="col-lg-12">
         <div >
            <button id="template" style="width: 11%;margin-top:11px; margin-left:140px;padding-top: 7px;padding-left: 9px;font-size: 14px;margin-bottom: -32px;"
               class="btn btn-generate btn-md  btn-primary btnScreen" onClick="downloadTemplate();">
            Download Template
            </button>
         </div>
         <div style="margin-left:300px;">
 				<form id="aggressiveTatForm">
						 <div class="form-group">
						    <div class="input-group col-xs-3" style="margin-bottom:-44px;">
						    <input type="file" id="updateTemplate" name="file" accept=".xlsx" required />
						    </div>
						    
						  </div>
						  
		<button type="submit" class="btn btn-primary input-sm" style="margin-left: 280px;height: 32px;margin-top: -1px;" id="upload" ><i class="glyphicon glyphicon-upload"></i>Upload</button>
							
						 
						 </form>
<!--            <form id="aggressiveTatForm">-->
<!--               <label class="myLabelFile" style="margin-left:100px;">-->
<!--               <input type="file" id="updateTemplate" name="file" accept=".xlsx" required /> <span><a class="btn btn-generate btn-md  btn-primary btnScreen" style = "font-size: 14px;padding-top: 5px;width: 100%;-->
<!--                  margin-top: 2px;"><span style="color:white;">Upload Template</span></a></span>-->
<!--               </label>-->
<!--            </form>-->
         </div>
      </div>
      <div class="col-lg-12" >
         <table id="tblTAT" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>Source City</th>
                  <th>Destination City</th>
                  <th>TAT</th>
                  </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<div class="tab-pane" id="delayTabPane">
   <div class="row">
      <div class="col-lg-12">
         <table id="tblDelay" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>Delay Category</th>
                  <th>Delay Code</th>
                  <th>Delay Reason</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<div class="tab-pane" id="vehicldCountTabPane">
   <div class="row">
      <div class="col-lg-12">
         <table id="tblVehicleCount" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>CT Executive Name</th>
                  <th>Vehicles Associated</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<div class="tab-pane" id="associatedDetailsTabPane">
   <div class="row">
      <div class="col-lg-12">
         <table id="tblassociatedVehicles" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>CT Executive Name</th>
                  <th>Vehicle No</th>
                  <th>Vehicle Type</th>
                  <th>Customer Name</th>
                  <th>Trip Category</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<!-- code added by shweta -->
<div class="tab-pane" id="supervisorScheduleTabPane">
   <div class="row">
      <div class="col-lg-12">
         <form id="imageForm" action="<%=request.getContextPath()%>/UploadExcelToDB" enctype="multipart/form-data" method="POST"  >
            <label class="myLabelFile">
            <input type="file" id="importFileSelect" name="file" accept=".xlsx" required /> <span><a class="dt-button buttons-excel buttons-html5 btn btn-primary"><span style="color:white;">Upload Excel</span></a></span>
            </label>
         </form>
         <div class="divTime" id="divTime">Last Updated: </div>
         <table id="tblsupervisorSchedule" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>Supervisor Name</th>
                  <th>Hub Name</th>
                  <th>Hub Code</th>
                  <th>Shift Start Timing ( e.g. 09:00 )</th>
                  <th>Shift End Time (e.g. 15:30 )</th>
                  <th>Contact Number</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>
<div id="unassignedVehiclesModal" class="modal fade createTrip" style="height: 85% !important;">
   <div class="row blueGreyDark modalHeader">
      <div class="col-md-10">
         <h4 id="createTitle" class="modal-title">
            Unassigned Vehicles
         </h4>
      </div>
      <div class="col-md-2 fa fa-window-close" data-dismiss="modal" style="cursor: pointer; color: white; text-align: right; padding-right: 10px;">
      </div>
   </div>
   <div class="modal-body"
      style="margin-top: 8px; height: 80vh; padding: 0px;">
      <table id="tblUnassignedVehicles" class="table table-striped table-bordered" cellspacing="0" width="100%">
         <thead>
            <tr>
               <th>Vehicle No</th>
               <th>Trip No</th>
               <th>Vehicle Type</th>
               <th>Customer Name</th>
               <th>Trip Category</th>
            </tr>
         </thead>
      </table>
   </div>
</div>
<div id="availableVehiclesModal" class="modal fade createTrip">
   <div class="row blueGreyDark modalHeader">
      <div class="col-md-10">
         <h4 id="createTitle" class="modal-title">
            Available Vehicles
         </h4>
      </div>
      <div class="col-md-2 fa fa-window-close" data-dismiss="modal" style="cursor: pointer; color: white; text-align: right; padding-right: 10px;">
      </div>
   </div>
   <div class="modal-body"
      style="margin-top: 8px; height: 80vh; overflow-y: auto; padding: 0px;">
      <table id="tblavailableVehicles" class="table table-striped table-bordered" cellspacing="0" width="100%">
         <thead>
            <tr>
               <th>Vehicle No</th>
               <th>Location</th>
               <th>Last Communication</th>
            </tr>
         </thead>
      </table>
   </div>
</div>
<div id="nonCommunicatingModal" class="modal fade createTrip">
   <div class="row blueGreyDark modalHeader">
      <div class="col-md-10">
         <h4 id="createTitle" class="modal-title">
            Non-Communicating Vehicles
         </h4>
      </div>
      <div class="col-md-2 fa fa-window-close" data-dismiss="modal" style="cursor: pointer; color: white; text-align: right; padding-right: 10px;">
      </div>
   </div>
   <div class="modal-body"
      style="margin-top: 8px; height: 80vh; overflow-y: auto; padding: 0px;">
      <table id="nonCommunicatingVehicles" class="table table-striped table-bordered" cellspacing="0" width="100%">
         <thead>
            <tr>
               <th>Vehicle No</th>
               <th>Location</th>
               <th>Last Communication</th>
               <th>Vehicle Status</th>
            </tr>
         </thead>
      </table>
   </div>
</div>
<div id="unloadingModal" class="modal fade createTrip" style="width:60% !important;">
   <div class="row blueGreyDark modalHeader">
      <div class="col-md-10">
         <h4 id="createTitle" class="modal-title">
            Unloading Vehicles
         </h4>
      </div>
      <div class="col-md-2 fa fa-window-close" data-dismiss="modal" style="cursor: pointer; color: white; text-align: right; padding-right: 10px;"></div>
   </div>
   <div class="modal-body"
      style="margin-top: 8px; height: 80vh; overflow-y: auto; padding: 0px;">
      <table id="tblUnloadingVehicles" class="table table-striped table-bordered" cellspacing="0" width="100%">
         <thead>
            <tr>
               <th>Vehicle No</th>
               <th>Location</th>
               <th>Last Communication</th>
               <th>ATA</th>
               <th>Allowed Detention(HH:mm)</th>
            </tr>
         </thead>
      </table>
   </div>
</div>
<div id="delayDetailsId" class="modal-content modal fade createTrip" id="addModifyModal">
   <div class="row blueGreyDark modalHeader">
      <div class="col-md-10">
         <h4 id="createTitle" class="modal-title">
            Delay Code Details
         </h4>
      </div>
      <div class="col-md-2 fa fa-window-close" data-dismiss="modal" style="cursor: pointer; color: white; text-align: right; padding-right: 10px;">
      </div>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: auto;">
      <div class="col-md-12">
         <table id="delayDetailsId" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
            <tbody>
               <tr>
                  <td>Delay Category<sup></sup>
                  </td>
                  <td>
                     <input type="text" class="form-control comboClass" maxLength="60" id="delayCategoryId" required>
                  </td>
               </tr>
               <tr>
                  <td>Delay Code<sup>*</sup></td>
                  <td>
                     <input type="text" class="form-control comboClass" maxLength="60" id="delayCodeId" required>
                  </td>
               </tr>
               <tr>
                  <td>Delay Reason<sup>*</sup></td>
                  <td>
                     <input type="text" class="form-control comboClass" maxLength="60" id="delayReasonId" required>
                  </td>
               </tr>
            </tbody>
         </table>
      </div>
   </div>
   <div class="modal-footer" style="text-align: center;">
      <input id="save1" onclick="saveDelayData()" type="button" class="btn btn-success" value="Save" />
      <button type="reset" class="btn btn-danger" id="cancelbutton" data-dismiss="modal">Cancel</button>
   </div>
</div>


<script><!--
//history.pushState({ foo: 'fake' }, 'Fake Url', 'CTAdminDashboard#');
    var tabName = "";
var customerList;
var custTypeList;
var vehTypeList;
var vehicleCategoryList;
var tblDelay;
var tblTAT;
var tblRegion;
var criteriaIdMod;
var excelUploadMsg = "<%=excelUploadMsg%>";
var excelUploadMsgs = "<%=excelUploadMsgs%>";
var totalRecords=0;
var validRecord=0;
var importTempleMasterRoot={};

function onlyNumbersWithColon(e) {
    var charCode;
    if (e.keyCode > 0) {
        charCode = e.which || e.keyCode;
    } else if (typeof(e.charCode) != "undefined") {
        charCode = e.which || e.keyCode;
    }
    if (charCode == 58)
        return true
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

$(document).keydown(function(e) {
    var code = e.keyCode || e.which;
    if (code == 27) {
        $("#nonCommunicatingModal").modal("hide");
        $("#availableVehiclesModal").modal("hide");
        $("#unloadingModal").modal("hide");
        $("#unassignedVehiclesModal").modal("hide");
    }
});
setInterval(function() {
    loadDashboardCounts();
    getUnassignedVehicles();
}, 300000);

function reset() {
    $('#segmentType').multiselect('deselectAll', false);
    $('#segmentType').multiselect('updateButtonText');
    $('#customers').multiselect('deselectAll', false);
    $('#customers').multiselect('updateButtonText');
    $('#vehicles').multiselect('deselectAll', false);
    $('#vehicles').multiselect('updateButtonText');
    $('#vehType').multiselect('deselectAll', false);
    $('#vehType').multiselect('updateButtonText');
    $('#categoryType').multiselect('deselectAll', false);
    $('#categoryType').multiselect('updateButtonText');
    $('#userNames').multiselect('deselectAll', false);
    $('#userNames').multiselect('updateButtonText');

    if (document.getElementById("criteriaNames").value) {
        $("#criteriaNames").select2("val", "0");
    }
    if ($.fn.DataTable.isDataTable("#tblCriteriaDetails")) {
        $('#tblCriteriaDetails').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblAssociateVehicles")) {
        $('#tblAssociateVehicles').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblUnassignedVehicles")) {
        $('#tblUnassignedVehicles').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblavailableVehicles")) {
        $('#tblavailableVehicles').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#nonCommunicatingVehicles")) {
        $('#nonCommunicatingVehicles').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblUnloadingVehicles")) {
        $('#tblUnloadingVehicles').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblVehicleCount")) {
        $('#tblVehicleCount').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblTAT")) {
        $('#tblTAT').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblassociatedVehicles")) {
        $('#tblassociatedVehicles').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblsupervisorSchedule")) {
        $('#tblsupervisorSchedule').DataTable().clear().destroy();
    }
    if ($.fn.DataTable.isDataTable("#tblDelay")) {
        $('#tblDelay').DataTable().clear().destroy();
    }
}

function resetForAssociate() {
    $('#segmentType').multiselect('deselectAll', false);
    $('#segmentType').multiselect('updateButtonText');
    $('#customers').multiselect('deselectAll', false);
    $('#customers').multiselect('updateButtonText');
    $('#vehicles').multiselect('deselectAll', false);
    $('#vehicles').multiselect('updateButtonText');
    $('#vehType').multiselect('deselectAll', false);
    $('#vehType').multiselect('updateButtonText');
    $('#categoryType').multiselect('deselectAll', false);
    $('#categoryType').multiselect('updateButtonText');
    getAssociatedVehicles(true);
    loadVehicleNo();

}

function resetAfterCriteriaCreation() {
    $('#segmentType').multiselect('deselectAll', false);
    $('#segmentType').multiselect('updateButtonText');
    $('#customers').multiselect('deselectAll', false);
    $('#customers').multiselect('updateButtonText');
    $('#vehicles').multiselect('deselectAll', false);
    $('#vehicles').multiselect('updateButtonText');
    $('#vehType').multiselect('deselectAll', false);
    $('#vehType').multiselect('updateButtonText');
    $('#categoryType').multiselect('deselectAll', false);
    $('#categoryType').multiselect('updateButtonText');
    loadCriteriaTable();
}

function loadCriteriaDetails() {
    $("#delayTabPane").hide();
    $("#associateVehiclesTabPane").hide();
    $("#aggressiveTatTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").hide();
    $("#associatedDetailsTabPane").hide();
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").hide();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").show();
    loadCriteriaTable();

}

function loadCriteriaTable() {
    if ($.fn.DataTable.isDataTable("#tblCriteriaDetails")) {
        $('#tblCriteriaDetails').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#tblCriteriaDetails').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCriteriaDetails',
            "dataSrc": "criteriaRoot"
        },
        "scrollX": true,
        "scrollY": "350px",
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Criteria Details',
            exportOptions: {
                columns: ':visible'
            }
        }],
        "columns": [{
            "data": "criteriaName"
        }, {
            "data": "customerName"
        }, {
            "data": "customerType"
        }, {
            "data": "vehicleType"
        }, {
            "data": "vehicleCategory"
        }, {
            "data": "editBtn"
        }]
    });
}

function getAssociatedVehicles(flag) {
    if (!flag) {
        if (document.getElementById("userNames").value == "") {
            swal("Alert!!", "Please select user(s) to see the associated vehicles", "warning");
            return;
        }
        if (document.getElementById("criteriaNames").value == "") {
            swal("Alert!!", "Please select a criteria to see the associated vehicles", "warning");
            return;
        }
    }
    var userCombo = "";
    var userSelected = $("#userNames option:selected");
    userSelected.each(function() {
        userCombo += $(this).val() + ",";
    });
    var userList = userCombo.split(",").join(",");
    if ($.fn.DataTable.isDataTable("#tblAssociateVehicles")) {
        $('#tblAssociateVehicles').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#tblAssociateVehicles').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getAssciationDetails',
            "data": {
                userId: userList,
                criteriaId: $('#criteriaNames').val()
            },
            "dataSrc": "associationRoot"
        },
        "scrollX": true,
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Associated Vehicles',
            exportOptions: {
                columns: ':visible'
            }
        }],
        "columns": [{
            "data": "vehicleNo"
        }, {
            "data": "vehicleType"
        }, {
            "data": "customerName"
        }, {
            "data": "vehicleCategory"
        }, {
            "data": "TAT"
        }, {
            "data": "criteriaName"
        }, {
            "data": "disassociate"
        }]
    });
    tblAssVeh.column(6).visible(false);
}

function loadVehicleCounts() {

    $("#delayTabPane").hide();
    $("#associateVehiclesTabPane").hide();
    $("#aggressiveTatTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").show();
    $("#associatedDetailsTabPane").hide();
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").hide();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").hide();


    if ($.fn.DataTable.isDataTable("#tblVehicleCount")) {
        $('#tblVehicleCount').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#tblVehicleCount').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getUserWiseVehicleCount',
            "dataSrc": "vehicleCount"
        },
        "scrollX": true,
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'UserWise Vehicle Count',
            exportOptions: {
                columns: ':visible'
            }
        }],
        "columns": [{
            "data": "userName"
        }, {
            "data": "count"
        }]
    });
}

$("#destination").on("change", function(){
	if($("#destination").val() == $("#source").val())
	{
		swal("Alert!!","Source and destination cannot be same", "warning");
		$("#destination").val("0").trigger("change");
	}
	
});

function loadAllAssociatedVehicles() {

    $("#delayTabPane").hide();
    $("#associateVehiclesTabPane").hide();
    $("#aggressiveTatTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").hide();
    $("#associatedDetailsTabPane").show();
    $("#associatedDetailsTabPane").hide();
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").hide();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").hide();

    if ($.fn.DataTable.isDataTable("#tblassociatedVehicles")) {
        $('#tblassociatedVehicles').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#tblassociatedVehicles').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getAllAssociatedVehicles',
            "dataSrc": "associatedVehicles"
        },
        "scrollX": true,
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Associated Vehicles',
            exportOptions: {
                columns: ':visible'
            }
        }],
        "columns": [{
            "data": "userName"
        }, {
            "data": "vehicleNo"
        }, {
            "data": "vehType"
        }, {
            "data": "customerName"
        }, {
            "data": "vehCategory"
        }]
    });
}

//new req by shweta
//$('input[type=file]').change(function () { 
$('#importFileSelect').change(function () { //  made specific as now we have 2 input type as  file
         var fileName = this.files[0].name;
         var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
            if(!(ext=="xlsx"))
            {
                sweetAlert("Please choose .xlsx file");
          return;
            }
          document.getElementById("imageForm").submit();
   });

   $("form#imageForm").submit(function(){

    var formData = new FormData($(this)[0]);

    $.ajax({
        url: '<%=request.getContextPath()%>/UploadExcelToDB',
        type: 'POST',
        data: formData,
        async: false,
        success: function (response) {

        if(response.includes("error")){
        		swal("Error!!", response, "error");
        	} else if(response.includes("available")) {
        		swal("Alert!!", response, "warning");
        	} else {
        		swal("Success!!", response, "success");
        	}
        },
        cache: false,
        contentType: false,
        processData: false
    });

    return false;
});

function valiadteForNewCity(length,response) {
           
    swal({
        title: "Are you sure? ",
        text: "This action can’t be reverted.",
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "Yes,Insert New City !",
        cancelButtonText: "Cancel",
        closeOnConfirm: true,
        closeOnCancel: true
    }).then(function(isConfirm) {
        if (isConfirm.value) {
            validateRegion(response);
        }
    })
}
	$("form#aggressiveTatForm").submit(function(event){
	 //disable the default form submission
	  event.preventDefault();
	  var formData = new FormData($(this)[0]);
    $.ajax({
        url: '<%=request.getContextPath()%>/UploadTemplateExcelToDB',
        type: 'POST',
        data: formData,
        async: false,
        success: function(response) {
        	response = JSON.parse(response);
        	
        	if (response["noRecords"]){
        	swal("Error!!", "No Data Found to upload", "error");
        	}else{
        	
			if(response["newCityRoot"].length == 0  && response["errorList"].length > 0) {  // Duplicate Records
			     swal("Alert!!", response["errorList"].length +"records are duplicated" + response["errorList"],"warning");
			} else if(response["newCityRoot"].length == 0  && response["errorList"].length == 0) {  //Success
				swal("Success!!", "Records uploaded successfully" , "success");
			} else if (response["errorList"].length > 0) { // Duplcate pincode
				 swal("Alert!!", +response["errorList"].length + "records are duplicated" + response["errorList"] ,"warning");
			} else if (response["newCityRoot"].length > 0 &&  response["errorList"].length == 0) { //New City
				valiadteForNewCity(response["newCityRoot"].length,response["newCityRoot"]);
			} else if (response["errorList"].length > 0 && response["errorList"].includes("error")) {
                swal("Error!!", response, "error");
            } 
            }
           $("#updateTemplate").val("");  
        },
       
        cache: false,
        contentType: false,
        processData: false
    });
    return false;
    });
     
   

function loadAllSupervisorSchedule() {

    $("#delayTabPane").hide();
    $("#associateVehiclesTabPane").hide();
    $("#aggressiveTatTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").hide();
    $("#supervisorScheduleTabPane").show();
    $("#associatedDetailsTabPane").hide();

    //added by shweta
    $("#associatedDetailsTabPane").hide();
    $("#addButtonTat").hide();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").hide();

    if ($.fn.DataTable.isDataTable("#tblsupervisorSchedule")) {
        $('#tblsupervisorSchedule').DataTable().clear().destroy();
    }
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=loadAllSupervisorSchedule',
        enctype: 'multipart/form-data',
        success: function(response) {
            var d = new Date(JSON.parse(response).supervisorSchedule[0].excelUploadTime);
            $("#divTime").html('Last Updated:');
            $("#divTime").append(d.toLocaleString("en-GB"));
        }
    });
    tblSupervisorSchedule = $('#tblsupervisorSchedule').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=loadAllSupervisorSchedule',
            "dataSrc": "supervisorSchedule"
        },
        "scrollX": true,
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Download Excel Format',
            className: 'btn btn-primary',
            title: 'Supervisor Schedule',
            exportOptions: {
                modifier: {
                    selected: true
                }
            }
        }],
        "columns": [{
            "data": "supervisorName"
        }, {
            "data": "hubName"
        }, {
            "data": "hubCode"
        }, {
            "data": "shiftStartTiming"
        }, {
            "data": "shiftEndTiming"
        }, {
            "data": "contactNumber"
        }]
    });
}

function uploadExcel(fileName) {
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=uploadSupervisorScheduleTableFromExcel',
        data: {
            fileName: fileName
        },
        enctype: 'multipart/form-data',
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("available")) {
                swal("Alert!!", response, "warning");
            } else {
                swal("Success!!", response, "success");
            }
        }
    });
}

function openAggressiveTat() {
    $('#addAggTatWin').show();
    getSourceAndDestination();
}

function openDelayWindow() {
    $("#delayDetailsId").modal("show");
    $('#delayCategoryId').val('');
    $('#delayCodeId').val('');
    $('#delayReasonId').val('');
}

function loadAssociatedData() {
    $("#aggressiveTatTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").hide();
    $("#delayTabPane").hide();
    $("#associatedDetailsTabPane").hide();
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").hide();
    $("#associateVehiclesTabPane").show();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").hide();
    getUsers();
    getCriterias();
}

function makeEditable(current, colNum) {
    var currentTD = $(current).parents('tr').find('td');
    if ($(current).hasClass("fa-pencil-alt")) {
        $(current).removeClass("fa-pencil-alt");
        $(current).addClass("fa-save");
        let x = 0;
        $.each(currentTD, function() {
            if (x == colNum) {
                $(this).prop('contenteditable', true)
                $(this).addClass('greenBorder')
            }
            x++;
        });
    } else {
        $(current).addClass("fa-pencil-alt");
        $(current).removeClass("fa-save");
        let x = 0;
        $.each(currentTD, function() {
            if (x == colNum) {
                $(this).prop('contenteditable', false)
                $(this).removeClass('greenBorder')
                $(this).html(
                    $(currentTD[colNum]).html().split("<br>").join(""))

                var tr = $(currentTD).closest('tr');
                var count = 0;
                var source = '';
                var destination = ''
                var TAT = '';
                $(tr).find('td').each(function() {
                    if (count == 0) {
                        source = $(this).html().split("<")[0];
                    }
                    if (count == 1) {
                        destination = $(this).html().split("<")[0];
                    }
                    if (count == 2) {
                        TAT = $(this).html().split("<")[0];
                    }
                    count++;
                });
                updateAggressiveTatDetails(source, destination, TAT);
                
            }
            x++;
        });
    }
}

function getAvailableVehicles(type) {
    $("#availableVehiclesModal").modal("show");

    if ($.fn.DataTable.isDataTable("#tblavailableVehicles")) {
        $('#tblavailableVehicles').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#tblavailableVehicles').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getAvailableVehicles',
            "data": {
                type: type
            },
            "dataSrc": "availableVehiclesRoot"
        },
        "scrollX": true,
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Available Vehicles',
            exportOptions: {
                columns: ':visible'
            }
        }],
        columnDefs: [{
                width: 100,
                targets: 0
            },
            {
                width: 100,
                targets: 1
            },
            {
                width: 100,
                targets: 2
            },
        ],
        "columns": [{
            "data": "vehicleNo"
        }, {
            "data": "location"
        }, {
            "data": "lastCommunication"
        }]
    });

}

function getNonCommVehicles(type) {
    $("#nonCommunicatingModal").modal("show");

    if ($.fn.DataTable.isDataTable("#nonCommunicatingVehicles")) {
        $('#nonCommunicatingVehicles').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#nonCommunicatingVehicles').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getNonCommunicationVehicles',
            "data": {
                type: type
            },
            "dataSrc": "nonCommVehiclesRoot"
        },
        "scrollX": true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Non-Communicated Vehicles',
            exportOptions: {
                columns: ':visible'
            }
        }],
        columnDefs: [{
                width: 100,
                targets: 0
            },
            {
                width: 500,
                targets: 1
            },
            {
                width: 100,
                targets: 2
            }, {
                width: 100,
                targets: 3
            }
        ],
        "columns": [{
            "data": "vehicleNo"
        }, {
            "data": "location"
        }, {
            "data": "lastCommunication"
        }, {
            "data": "status"
        }]
    });

}

function getUnloadingVehicles(type) {
    $("#unloadingModal").modal("show");

    if ($.fn.DataTable.isDataTable("#tblUnloadingVehicles")) {
        $('#tblUnloadingVehicles').DataTable().clear().destroy();
    }
    var tblAssVeh = $('#tblUnloadingVehicles').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getUnloadingVehicles',
            "data": {
                type: type
            },
            "dataSrc": "unloadingVehiclesRoot"
        },
        "scrollX": true,
        "scrollY": '350px',
        paging: true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Unloading Vehicles',
            exportOptions: {
                columns: ':visible'
            }
        }],
        columnDefs: [{
                width: 50,
                targets: 0
            },
            {
                width: 500,
                targets: 1
            },
            {
                width: 100,
                targets: 2
            },
            {
                width: 100,
                targets: 3
            },
            {
                width: 30,
                targets: 4
            }
        ],
        "columns": [{
            "data": "vehicleNo"
        }, {
            "data": "location"
        }, {
            "data": "lastCommunication"
        }, {
            "data": "ETA"
        }, {
            "data": "detention"
        }]
    });

}

function disAssociateVehicle(vehicleNo, type) {
    swal({
        title: "Are you sure?",
        text: "This action can’t be reverted. You need to associate the vehicle manually.",
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "Yes, Disassociate it!",
        cancelButtonText: "Cancel",
        closeOnConfirm: true,
        closeOnCancel: true
    }).then(function(isConfirm) {
        if (isConfirm.value) {
            validate(vehicleNo, type);
        }
    })
}

function validate(vehicleNo, type) {
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=disassociateVehicles',
        data: {
            vehicleNo: vehicleNo,
            user: $('#userNames').val()
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("available")) {
                swal("Alert!!", response, "warning");
            } else {
                swal("Success!!", response, "success");
            }
            resetForAssociate();
        }
    });
}
var tblSupervisorSchedule;

$(document).ready(function() {
    if (excelUploadMsg == "Inserted" || excelUploadMsg == "Failed" || excelUploadMsg != "") {

        sweetAlert(excelUploadMsg);
        $('[href="#supervisorScheduleTabPane"]').tab('show');
        excelUploadMsg = ""; 
        <%session.setAttribute("excelUploadMsg","");%>
        loadAllSupervisorSchedule();
        setTimeout(function() {
            getUnassignedVehicles()
        }, 3000);
    } else {
        loadDashboardCounts();
        getUnassignedVehicles();
        loadCriteriaDetails();
        loadCustomerSegment();
        loadTripCustomer();
        loadVehicleType();

        $('#categoryType').multiselect({
            nonSelectedText: 'Select Category',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            cssClass: 'form-control-custom'
        });
        $("#categoryType").multiselect('selectAll', true);
        $("#categoryType").multiselect('updateButtonText');
    }
})

$(document).ready(function() {
    if (excelUploadMsgs == "Inserted" || excelUploadMsgs == "Failed" || excelUploadMsgs != "") {

        sweetAlert(excelUploadMsgs);
        $('[href="#aggressiveTatTabPane"]').tab('show');
        excelUploadMsgs = ""; 
        <%session.setAttribute("excelUploadMsgs","");%>
        loadTATData();
        setTimeout(function() {
            getUnassignedVehicles()
        }, 3000);
    } else {
        loadDashboardCounts();
        getUnassignedVehicles();
        loadCriteriaDetails();
        loadCustomerSegment();
        loadTripCustomer();
        loadVehicleType();

        $('#categoryType').multiselect({
            nonSelectedText: 'Select Category',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            cssClass: 'form-control-custom'
        });
        $("#categoryType").multiselect('selectAll', true);
        $("#categoryType").multiselect('updateButtonText');
    }
})

function getUnassignedVehicles() {
    $("#unassignedVehiclesModal").modal("show");

    if ($.fn.DataTable.isDataTable("#tblUnassignedVehicles")) {
        $('#tblUnassignedVehicles').DataTable().clear().destroy();
    }
    var tblUnassociatedVeh = $('#tblUnassignedVehicles').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getUnassignedVehicles',
            "data": {
                userId: $('#userNames').val()
            },
            "dataSrc": "unassignedVehicleRoot"
        },
        "scrollX": true,
        "scrollY": "350px",
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Unassigned Vehicles',
            exportOptions: {
                columns: ':visible'
            }
        }],
        "columns": [{
            "data": "vehicleNo"
        }, {
            "data": "tripNo"
        }, {
            "data": "vehicleType"
        }, {
            "data": "customerName"
        }, {
            "data": "vehicleCategory"
        }]
    });
}

function saveCriteriaDetails() {
    var buttonValue = $('#criteriaBtnId').text();
    var custypeCombo = "";
    var custTypeSelected = $("#segmentType option:selected");
    custTypeSelected.each(function() {
        custypeCombo += $(this).val() + ",";
    });
    custTypeList = custypeCombo.split(",").join(",");

    var vehtypeCombo = "";
    var vehTypeSelected = $("#vehType option:selected");
    vehTypeSelected.each(function() {
        vehtypeCombo += $(this).val() + ",";
    });
    vehTypeList = vehtypeCombo.split(",").join(",");

    var vehcategoryCombo = "";
    var vehCategorySelected = $("#categoryType option:selected");
    vehCategorySelected.each(function() {
        vehcategoryCombo += $(this).val() + ",";
    });
    vehicleCategoryList = vehcategoryCombo.split(",").join(",");

    var custCombo = "";
    var custSelected = $("#customers option:selected");
    custSelected.each(function() {
        custCombo += $(this).val() + ",";
    });
    customerList = custCombo.split(",").join(",");

    if ($('#criteriaNameId').val() == '') {
        swal("Alert!!", "Please enter criteria name", "warning");
        return;
    }
    if (custTypeList == '' && vehTypeList == '' && vehicleCategoryList == '' && customerList == '') {
        swal("Alert!!", "Please select atleast one field to create a criteria", "warning");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=saveCriteriaDetails',
        data: {
            tripCustNames: customerList,
            custType: custTypeList,
            vehType: vehTypeList,
            vehicleCategory: vehicleCategoryList,
            criteriaName: $('#criteriaNameId').val(),
            criteriaId: criteriaIdMod,
            buttonValue: buttonValue
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("saved")) {
                swal("Success!!", response, "success");
            } else if (response.includes("modified")) {
                swal("Success!!", response, "success");
            } else {
                swal("Alert!!", response, "warning");
            }
            cancel();
        }
    });
}

function validateAssociate() {

    if (document.getElementById("userNames").value == "") {
        swal("Alert!!", "Please select user(s) to see the associated vehicles", "warning");
        return;
    }
    if ($('#criteriaNames').val() == '0') {
        swal("Alert!!", "Please enter criteria name", "warning");
        return;
    }
    swal({
        title: "Are you sure?",
        text: "You want to associate the user and critria.",
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "Yes, Associate it!",
        cancelButtonText: "Cancel",
        closeOnConfirm: true,
        closeOnCancel: true
    }).then(function(isConfirm) {
        if (isConfirm.value) {
            associateCriteriaToUser();
        }
    })
}

function associateCriteriaToUser() {
    var userCombo = "";
    var userSelected = $("#userNames option:selected");
    userSelected.each(function() {
        userCombo += $(this).val() + ",";
    });
    userList = userCombo.split(",").join(",");
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=associateCriteriaToUser',
        data: {
            userList: userList,
            criteriaName: $('#criteriaNames').val()
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("associated")) {
                swal("Success!!", response, "success");
            } else {
                swal("Alert!!", response, "warning");
            }
            getAssociatedVehicles();
        }
    });
}

function saveDelayData() {
    if ($('#delayCategoryId').val() == '') {
        $("#delayCategoryId").addClass("invalid");
        return;
    } else {
        $("#delayCategoryId").removeClass("invalid");
    }
    if ($('#delayCodeId').val() == '') {
        $("#delayCodeId").addClass("invalid");
        return;
    } else {
        $("#delayCodeId").removeClass("invalid");
    }
    if ($('#delayReasonId').val() == '') {
        $("#delayReasonId").addClass("invalid");
        return;
    } else {
        $("#delayReasonId").removeClass("invalid");
    }

    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=saveDelayDetails',
        data: {
            issueType: $('#delayCategoryId').val(),
            delayCode: $('#delayCodeId').val(),
            subIssue: $('#delayReasonId').val()
        },
        success: function(response) {
            $("#delayDetailsId").modal("hide");
            tblDelay.ajax.reload();
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else {
                swal("Success!!", response, "success");
            }
        }
    });
}

function saveAggressiveTatDetails() {

    if ($("#TATId").val().split(":").length != 2) {
        swal("Alert!!", "Please enter TAT in HH:mm format", "warning");
        return;
    }
	if ((parseInt($("#TATId").val().split(":")[0]) < 1) && (parseInt($("#TATId").val().split(":")[1]) < 1)) {
        swal("Alert!!", "mm should be greater than zero", "warning");
        return;
    }
	
	if($("#destination").val() == "0" || $("#source").val() == "0"  )
	{
		swal("Alert!!","Source and destination cannot be empty", "warning");
		return;
		
	}
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=saveAggressiveTatDetails',
        data: {
            source: $('#source').val(),
            destination: $('#destination').val(),
            TAT: $('#TATId').val()
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("available")) {
                swal("Alert!!", response, "warning");
            } else {
                swal("Success!!", response, "success");
                loadTATData();
            }
        }
    });
}

function updateAggressiveTatDetails(source, dest, TAT) {
    if (TAT.split(":").length != 2) {
        swal("Alert!!", "Please enter TAT in HH:mm format", "warning");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=updateAggressiveTatDetails',
        data: {
            source: source,
            destination: dest,
            TAT: TAT
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("available")) {
                swal("Alert!!", response, "warning");
            } else {
                swal("Success!!", response, "success");
                loadTATData();
            }
        }
    });
}

function loadHubData() {

    $("#aggressiveTatTabPane").hide();
    $("#delayTabPane").hide();
    $("#associateVehiclesTabPane").hide();
    $("#hubSupervisorTabPane").show();
    $("#vehicldCountTabPane").hide();
    $("#associatedDetailsTabPane").hide();
    //added by shweta
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").hide();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").hide();

    if ($.fn.DataTable.isDataTable("#tblHubMaster")) {
        $('#tblHubMaster').DataTable().clear().destroy();
    }
    var tblHubMaster = $('#tblHubMaster').DataTable({
        "scrollY": "300px",
        "scrollX": true,
        paging: false,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: []
    });


}

function loadTATData() {
    $("#aggressiveTatTabPane").show();
    $("#delayTabPane").hide();
    $("#associateVehiclesTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").hide();
    $("#associatedDetailsTabPane").hide();
    //added by shweta
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").show();
    $("#addButtonDelay").hide();
    $("#criteriaTabPane").hide();

    if ($.fn.DataTable.isDataTable("#tblTAT")) {
        $('#tblTAT').DataTable().clear().destroy();
    }
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getTATDetails',
        success: function(result) {
            data = JSON.parse(result);
            let rows = [];
            $.each(data.tatRoot, function(i, item) {
                let row = {
                    "0": item.source,
                    "1": item.destination,
                    "2": item.TAT +'<i class="fas fa-pencil-alt fa-2x" onclick="makeEditable(this, 2)" style="color:#3F51B5;cursor:pointer; float:right;padding-right:8px;" aria-hidden="true" ></i>',
                }
                rows.push(row);
            })
            tblTAT = $('#tblTAT').DataTable({
                "scrollX": true,
                "bFilter": true,
                paging: true,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-generate btn-md  btn-primary btnScreen excel_button',
                    title: 'Aggressive TAT Details',
                    exportOptions: {
                        columns: ':visible'
                    }
                }]
            });
            tblTAT.rows.add(rows).draw();
        }
    })
}

function loadDelayData() {
    $("#aggressiveTatTabPane").hide();
    $("#delayTabPane").show();
    $("#associateVehiclesTabPane").hide();
    $("#hubSupervisorTabPane").hide();
    $("#vehicldCountTabPane").hide();
    $("#associatedDetailsTabPane").hide();
    //added by shweta
    $("#supervisorScheduleTabPane").hide();
    $("#addButtonTat").hide();
    $("#addButtonDelay").show();
    $("#criteriaTabPane").hide();

    if ($.fn.DataTable.isDataTable("#tblDelay")) {
        $('#tblDelay').DataTable().clear().destroy();
    }

    tblDelay = $('#tblDelay').DataTable({
        "ajax": {
            "url": '<%=request.getContextPath()%>/CTDashboardAction.do?param=getDelayDetails',
            "dataSrc": "delayDetailsRoot"
        },
        "scrollX": true,
        "order": [],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary',
            title: 'Delay Details',
            exportOptions: {
                columns: ':visible'
            }
        }],
        "columns": [{
            "data": "delayCategory"
        }, {
            "data": "delayCode"
        }, {
            "data": "delaytype"
        }]
    });
}

function loadDashboardCounts() {
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCTAdminDashboardCounts',
        "dataSrc": "dashboardCounts",
        success: function(result) {
            data = JSON.parse(result);
            $("#inTransit").html(data["dashboardCounts"][0].inTransit);
            $("#planned").html(data["dashboardCounts"][0].planned);
            $("#available").html(data["dashboardCounts"][0].available);
            $("#inMaintenance").html(data["dashboardCounts"][0].inMaintenance);
            $("#nonComm").html(data["dashboardCounts"][0].nonComm);
            $("#inTransitTCL").html(data["dashboardCounts"][0].inTransitTCL);
            $("#plannedTCL").html(data["dashboardCounts"][0].plannedTCL);
            $("#availableTCL").html(data["dashboardCounts"][0].availableTCL);
            $("#inMaintenanceTCL").html(data["dashboardCounts"][0].inMaintenanceTCL);
            $("#nonCommTCL").html(data["dashboardCounts"][0].nonCommTCL);
            $("#inTransitDry").html(data["dashboardCounts"][0].inTransitDry);
            $("#plannedDry").html(data["dashboardCounts"][0].plannedDry);
            $("#availableDry").html(data["dashboardCounts"][0].availableDry);
            $("#inMaintenanceDry").html(data["dashboardCounts"][0].inMaintenanceDry);
            $("#nonCommDry").html(data["dashboardCounts"][0].nonCommDry);
            $("#unloading").html(data["dashboardCounts"][0].unloading);
            $("#unloadingTCL").html(data["dashboardCounts"][0].unloadingTCL);
            $("#unloadingDry").html(data["dashboardCounts"][0].unloadingDry);

        }
    })
}

function getSourceAndDestination() {
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getSourceAndDestination',
        success: function(result) {
            data = JSON.parse(result);
            for (var i = 0; i < data["sourceAndDestRoot"].length; i++) {
                $('#source').append($("<option></option>").attr("value", data["sourceAndDestRoot"][i].cityName).text(data["sourceAndDestRoot"][i].cityName));

                $('#destination').append($("<option></option>").attr("value", data["sourceAndDestRoot"][i].cityName).text(data["sourceAndDestRoot"][i].cityName));

            }
            $('#source').select2();
            $('#destination').select2();
        }
    })
}

function loadCustomerSegment() {
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripCustomerType',
        success: function(response) {
            tripCustTypeList = JSON.parse(response);
            for (var i = 0; i < tripCustTypeList["tripCustTypeRoot"].length; i++) {
                $('#segmentType').append($("<option></option>").attr("value", tripCustTypeList["tripCustTypeRoot"][i].tripCustomerValue).text(tripCustTypeList["tripCustTypeRoot"][i].tripCustomerType));
            }
            $('#segmentType').multiselect({
                nonSelectedText: 'Select Customer Type',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1,
                cssClass: 'form-control-custom'
            });
            $("#segmentType").multiselect('selectAll', true);
            $("#segmentType").multiselect('updateButtonText');

        }
    });
}

function loadTripCustomer() {
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCustNames',
        success: function(response) {
            custList = JSON.parse(response);
            for (var i = 0; i < custList["customerRoot"].length; i++) {
                $('#customers').append($("<option></option>").attr("value", custList["customerRoot"][i].custId).text(custList["customerRoot"][i].custName));
            }
            $('#customers').multiselect({
                nonSelectedText: 'Select Customer',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1,
                cssClass: 'form-control-custom'
            });
            $("#customers").multiselect('selectAll', true);
            $("#customers").multiselect('updateButtonText');
        }
    });
}

function loadVehicleNo() {

    $('#vehicles').html('');
    $("#vehicles").multiselect('destroy');
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getVehicles',
        data: {
            tripCustNames: customerList,
            custType: custTypeList,
            vehType: vehTypeList,
            vehicleCategory: vehicleCategoryList,
            userId: $('#userNames').val()
        },
        success: function(response) {
            vehicleList = JSON.parse(response);
            for (var i = 0; i < vehicleList["vehicleNoRoot"].length; i++) {
                $('#vehicles').append($("<option></option>").attr("value", vehicleList["vehicleNoRoot"][i].vehicleNo).text(vehicleList["vehicleNoRoot"][i].vehicleNo));
            }
            $('#vehicles').multiselect({
                nonSelectedText: 'Select Vehicle',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1
            });
            $("#vehicles").multiselect('selectAll', true);
            $("#vehicles").multiselect('updateButtonText');
        }
    });
}

function loadVehicleType() {
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getVehicleType',
        success: function(response) {
            vehicleTypeList = JSON.parse(response);
            for (var i = 0; i < vehicleTypeList["vehicleTypeRoot"].length; i++) {
                $('#vehType').append($("<option></option>").attr("value", vehicleTypeList["vehicleTypeRoot"][i].vehicleType).text(vehicleTypeList["vehicleTypeRoot"][i].vehicleType));
            }
            $('#vehType').multiselect({
                nonSelectedText: 'Select Vehicle Type',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1
            });
            $("#vehType").multiselect('selectAll', true);
            $("#vehType").multiselect('updateButtonText');
        }
    });
}

function getUsers() {
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getUsers',
        success: function(response) {
            userList = JSON.parse(response);
            for (var i = 0; i < userList["userRoot"].length; i++) {
                $('#userNames').append($("<option></option>").attr("value", userList["userRoot"][i].userId).attr("criteriaId", userList["userRoot"][i].criteriaId).text(userList["userRoot"][i].userName));
            }
            $('#userNames').multiselect({
                nonSelectedText: 'Select Users',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1
            });
            $("#userNames").multiselect('selectAll', true);
            $("#userNames").multiselect('updateButtonText');
        }
    });
}

function getCriterias() {
    $("#criteriaNames").empty().select2();
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCriteria',
        success: function(response) {
            criteriaList = JSON.parse(response);
            $('#criteriaNames').append($("<option></option>").attr("value", "0").text("Select Criteria"));
            for (var i = 0; i < criteriaList["criteriaDetails"].length; i++) {
                $('#criteriaNames').append($("<option></option>").attr("value", criteriaList["criteriaDetails"][i].criteriaId).text(criteriaList["criteriaDetails"][i].criteriaName));
            }
            $('#criteriaNames').select2();
        }
    });
}

function saveAssociationDetails() {

    var vehicleCombo = "";
    var vehicleSelected = $("#vehicles option:selected");
    vehicleSelected.each(function() {
        vehicleCombo += $(this).val() + ",";
    });
    vehicleList = vehicleCombo.split(",").join(",");
    if (vehicleList == '') {
        swal("Alert!!", "Please select at least 1 vehicle to associate", "warning");
        return;
    }
    if ($('#userNames').val() == '0') {
        swal("Alert!!", "Please select a user to associate the vehicles", "warning");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=associateVehiclesToUsers',
        data: {
            vehicleList: vehicleList,
            userId: $('#userNames').val(),
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else {
                swal("Success!!", response, "success");
            }
            resetForAssociate();
        }
    });
}

function modifyCriteria(criteriaId) {
    criteriaIdMod = criteriaId;
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCriteriaForEdit',
        data: {
            criteriaId: criteriaId
        },
        success: function(response) {
            criteriaList = JSON.parse(response);
            criteriaList = criteriaList["criteriaForEdit"][0];

            $('#criteriaNameId').val(criteriaList.criteriaName);
            var tripCustArr = criteriaList.tripCustId.split(",");
            $("#customers").val(tripCustArr);
            $("#customers").multiselect("refresh");

            var custTypeArr = criteriaList.custType.split(",");
            $("#segmentType").val(custTypeArr);
            $("#segmentType").multiselect("refresh");

            var vehTypeArr = criteriaList.vehicleType.split(",");
            $("#vehType").val(vehTypeArr);
            $("#vehType").multiselect("refresh");

            var vehCategoryArr = criteriaList.vehicleCategory.split(",");
            $("#categoryType").val(vehCategoryArr);
            $("#categoryType").multiselect("refresh");
        }
    });

    $("#criteriaNameId").prop("disabled", true);
    //$("#criteriaBtnId").attr("disabled", true);
    $("#criteriaBtnId").html('Modify Criteria');
    //$("#criteriaBtnId").css("visibility", "hidden");
    //$("#criteriaBtnId").hide();
    $('#cancelBtn').show();
}

function cancel() {
    //$("#criteriaBtnId").css("visibility", "visible");
    $("#criteriaBtnId").html('Freeze Criteria')
    $('#cancelBtn').hide();
    $("#criteriaNameId").prop("disabled", false);
    $("#criteriaNameId").val('');
    resetAfterCriteriaCreation();
}

$('#userNames').change(function() {
    var userSelected = $("#userNames option:selected");
    if (userSelected.length > 1) {
        $("#criteriaNames").val(0).trigger('change');
    } else {
        var criteria = $('#userNames option:selected').attr("criteriaId");
        $("#criteriaNames").val(criteria).trigger('change');
    }
})

function downloadTemplate() {
    
    var abc = "";
    window.open("<%=request.getContextPath()%>/CTExecutiveTemplateSevlet?relativePath=" + abc);
}

function validateRegion(newCityList) {
	
    $.ajax({
        type: 'POST',
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=loadPincodeRegion',
        data: {
            newCityList: JSON.stringify(newCityList)
         },
           success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else if (response.includes("available")) {
                swal("Alert!!", response, "warning");
            } else {
                swal("Success!!", response, "success");
            }
            
        }
    });
}

--></script>
