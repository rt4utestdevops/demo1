<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8" %>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
        CommonFunctions cf=new CommonFunctions();
	    AdminFunctions adminFunction = new AdminFunctions();
	    LoginInfoBean loginInfo=(LoginInfoBean) session.getAttribute( "loginInfoDetails");
	    int countryId=loginInfo.getCountryCode();
	    int systemId=loginInfo.getSystemId();
	    int customerId=loginInfo.getCustomerId();
	    String countryName=cf.getCountryName(countryId);
	    String language=loginInfo.getLanguage();
	    Properties properties=ApplicationListener.prop;
        String vehicleImagePath=properties.getProperty( "vehicleImagePath");
        String HelpDocPath=properties.getProperty("HelpDocPath");
        String unit=cf.getUnitOfMeasure(systemId);
        String latitudeLongitude=cf.getCoordinates(systemId);
        String userAuthority=cf.getUserAuthority(loginInfo.getSystemId(),loginInfo.getUserId());
        boolean isAdmin=(("Admin".equals(userAuthority)) || ("Super Admin".equals(userAuthority))) ?true : false;
		String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		String GoogleAPIKEY = GoogleApiKey + "&libraries=places,drawing";
		String pageName =  "/Jsps/GeneralVertical/CreateTrip.jsp";
		boolean hasTripCreatePermission = adminFunction.checkUserProcessPermission(systemId,loginInfo.getUserId(),pageName);
		MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
		String mapName = bean.getMapName();
		String appKey = bean.getAPIKey();
		String appCode = bean.getAppCode();
		String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();

    	int userId=loginInfo.getUserId();
		String userAuthorityCTExec = cf.getUserAuthority(systemId,userId);
		String userName=loginInfo.getUserName();
%>
<jsp:include page="../Common/header.jsp" />
<jsp:include page="../Common/InitializeLeaflet.jsp" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" type="text/css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css" type="text/css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" type="text/css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css" rel="stylesheet" />
<link href = "https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css"
   rel = "stylesheet">
<script
   src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
   integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
   crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/select/1.3.0/js/dataTables.select.min.js"></script>
<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.js"></script>
<script src="https://unpkg.com/leaflet@1.0.2/dist/leaflet.js"></script>
<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--<script src="../../Main/leaflet/initializeleaflet.js"></script>-->
<script src="../../Main/leaflet/leaflet-heat.js"></script>
<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js" integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
   crossorigin=""></script>
<script type="text/javascript" src="https://cdn.datatables.net/fixedcolumns/3.2.1/js/dataTables.fixedColumns.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>

<script src="../../Main/leaflet/leaflet-list-markers.src.js"></script>
<script src="../../Main/leaflet/leaflet-list-markers.min.js"></script>
<link rel="stylesheet" href="../../Main/leaflet/leaflet-list-markers.min.css">
<link rel="stylesheet" href="../../Main/leaflet/leaflet-list-markers.src.css">


<style>body {
	overflow-x: hidden;
}

th:nth-child(5),
th:nth-child(8),
td:nth-child(5),
td:nth-child(8) {
	max-width: 200px !important;
	word-wrap: break-word;
}

#tripDatatable_wrapper input {
	border-radius: 4px;
}

.dataTables_wrapper .dataTables_filter input {
	border-radius: 8px !important;
}

#tripDatatable_filter {
	margin-top: -32px;
}

#onTripVehicleDetails_filter {
	margin-top: -32px;
}

thead th {
	white-space: nowrap;
}

thead {
	color: #ece9e6 !important;
	background-color: #355869 !important;
	padding-top: 4px;
	padding-bottom: 4px;
	padding-left: 16px;
}

table.dataTable.display tbody tr td {
	padding: 0px 12px;
	white-space: nowrap !important;
}

table.dataTable {
	border-color: #939393;
	border: none;
}

 ::-webkit-scrollbar {
	width: 10px;
	height: 10px;
}


/* Track */

 ::-webkit-scrollbar-track {
	background: #f1f1f1;
	border-radius: 4px;
}


/* Handle */

 ::-webkit-scrollbar-thumb {
	background: #888;
	border-radius: 4px;
}


/* Handle on hover */

 ::-webkit-scrollbar-thumb:hover {
	background: #555;
	border-radius: 4px;
}

.spinnerColor {
	color: #dfdfdf;
}

.btnStyle {
	cursor: pointer;
	margin-left: 16px;
	margin-top: 2px;
}

.btnFilter {
	height: 32px;
	border-radius: 8px;
	padding: 0px 8px !important;
	background: #2E7D32 !important;
	border-color: #2E7D32 !important;
}

.btn-success {
	height: 28px!important;
	padding: 0px 2px !important;
	margin-left: 8px;
}

#tripDatatable_filter .btn-success {
	height: 32px!important;
	padding: 0px 8px !important;
}

#columnSetting .btn-success {
	height: 40px!important;
	padding: 0px 8px !important;
	margin-left: 16px;
}

#envelopeModal .btn-success {
	height: 40px!important;
	padding: 0px 8px !important;
	margin-left: 16px;
}

primary:not(:disabled):not(.disabled):active {
	border-color: #2E7D32 !important;
}

.btnView {
	height: 40px;
	border-radius: 8px;
	background: #2E7D32 !important;
	border-color: #2E7D32;
}

.card {
	font-weight: 600;
	border: 0;
	box-shadow: 0 2px 5px 0 rgba(0, 0, 0, .16), 0 2px 10px 0 rgba(0, 0, 0, .12);
	position: relative;
	display: flex;
	flex-direction: column;
	min-width: 0;
	word-wrap: break-word;
	background-color: #fff;
	background-clip: border-box;
	border-radius: .25rem;
	padding: 0px;
	border: 0px !important;
	text-align: center;
}

.center-view {
	background: none;
	position: fixed;
	z-index: 1000000000;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
}

.center-viewInitial {
	background: linear-gradient(to right, #ffffff, #ece9e6)!important;
	opacity: 1;
	position: fixed;
	z-index: 1000000000;
	top: 48px;
	left: 0;
	right: 0;
	bottom: 0;
}

.buttons-excel {
	height: 28px !important;
	padding: 0px 2px !important;
	background: #0bab64 !important;
	border: 1px solid #0bab64 !important;
	border-radius: 4px;
}

.blue-gradient-rgba {
	background: linear-gradient(to right, rgb(58, 96, 115), rgb(22, 34, 42))!important;
}

.green-gradient-rgba {
	background: linear-gradient(to right, #3bb78f 0%, #28A745 74%)!important;
}

.orange-gradient-rgba {
	background: linear-gradient(to right, #FFCC00, rgb(241, 39, 17)) !important;
}

.red-gradient-rgba {
	background: linear-gradient(to right, rgb(229, 45, 39), rgb(179, 18, 23)) !important;
}

.green {
	color: #0bab64 !important;
}

.red {
	color: rgb(179, 18, 23) !important;
}

.orange {
	color: rgb(241, 39, 17) !important;
}

.blue {
	color: rgb(22, 34, 42) !important;
}

.text-white {
	color: #fff!important;
}

.h-100 {
	height: 100%!important;
}

.d-flex {
	display: -ms-flexbox!important;
	display: flex!important;
	flex-direction: column;
}

.badge {
	min-width: 80px;
	height: 24px;
	background: linear-gradient(40deg, #777777, #000C40);
	padding-top: 4px !important;
	margin-top: 2px;
	font-size: 14px !important;
	cursor: pointer;
}

.list-group-item {
	padding: .1rem 1.25rem 0.5rem 1.25rem !important;
	font-size: 12px;
	white-space: nowrap;
}

.cardHeading {
	width: 100%;
	text-align: left;
	color: white;
	padding-bottom: 8px;
	border-top-left-radius: 8px;
	border-top-right-radius: 8px;
	font-size: 12px;
	font-weight: 700;
	display: flex;
	justify-content: space-between;
	padding: 2px 20px 0px 20px;
}

.col-lg-4 {
	padding: 4px !important;
}

.topHeader {
	font-size: 12px;
	font-weight: 600;
	color: #ece9e6;
}

table tbody {
	font-size: 12px !important;
}

table.dataTable {
	border-collapse: collapse !important;
	font-size: 13px !important;
}

.cardHeight {
	height: 74px;
}

.cardHeightShort {
	height: 74px;
	margin-top: 6px;
}

#greenCard,
#redCard,
#orangeCard,
#alertsCard {
	border: 0px;
	height: 232px;
}

#greenCard ul li,
#redCard ul li,
#orangeCard ul li {
	border: 0px;
}

.leftMargin {
	margin-left: 16px;
}

.flexRow {
	flex-direction: row;
}

.badgeHeader {
	margin-bottom: 4px;
	background: linear-gradient(to right, #ffffff, #ece9e6)!important;
	font-weight: 700 !important;
	font-size: 14px !important;
	cursor: pointer;
}

.btn-group {
	width: 140px !important;
	height: 28px !important;
}

.btn-group>.btn:first-child {
	padding: 0px !important;
	background: #ffffff;
	border: 1px solid #777777;
}

.fa-2x {
	font-size: 1.5em !important;
}

.topRow {
	margin-top: -24px;
	background: #355869;
	border-radius: 2px;
	padding: 4px 0px 8px 0px;
	margin-left: 0px !important;
	margin-right: 0px !important;
}

.topRowData {
	margin-bottom: 24px;
	color: #ece9e6;
	text-align: center;
	background: #355869;
	border-radius: 2px;
	padding: 4px 0px 8px 0px;
	margin-left: 0px !important;
	margin-right: 0px !important;
}

.threePixelPadding {
	padding-top: 3px;
}

input[type=radio] {
	margin: 8px 4px 0px 8px !important;
}

.details-control {
	background: url('../../Main/images/details_open.png') no-repeat center center;
	cursor: pointer;
	width: 40px;
	height: 40px;
}

tr.shown td div.details-control {
	background: url('../../Main/images/details_close.png') no-repeat center center;
}

table.dataTable thead .sorting_asc {
	background-image: none !important;
}

.dispNone {
	display: none;
}

.multiselect-container {
	font-size: 12px !important;
	z-index: 100000000 !important;
	min-width: 300px !important;
}

.multiselect-clear-filter {
	display: none !important;
}

.multiselect-filter .input-group {
	width: 96% !important
}

.multiselect-container .multiselect-search {
	border-radius: 8px !important;
	height: 24px !important;
	font-size: 12px !important;
}

.multiselect-container a .checkbox {
	color: #777777 !important;
	padding: 0px 16px;
}

#sortable li {
	display: flex;
}

input[type=checkbox] {
	margin-top: 5px;
	margin-right: 8px;
}

#sortable {
	padding-left: 16px;
	padding-top: 16px;
	-moz-column-count: 3;
	-moz-column-gap: 16px;
	-webkit-column-count: 3;
	-webkit-column-gap: 16px;
	column-count: 3;
	column-gap: 16px;
}

#ulRowData,#ulRowDataSummary ,#ulRowDataSumm {
	padding-left: 24px;
	padding-right: 16px;
	list-style: none;
	-moz-column-count: 1;
	-moz-column-gap: 16px;
	-webkit-column-count: 1;
	-webkit-column-gap: 16px;
	column-count: 1;
	column-gap: 16px;
	color: #777777;
	font-size: 12px !important;
}

#columnSetting .modal-content {
	width: 200% !important;
	border-radius: 8px !important;
	top: 48px !important;
	left: -50%;
}

#envelopeModal .modal-content ,#lockEnvelopeModal .modal-content {
	width: 200% !important;
	border-radius: 8px !important;
	top: 12px !important;
	left: -50%;
	overflow: hidden;
}

#onTripVehiclStoppageMapModal .modal-content {
	width: 200% !important;
	border-radius: 8px !important;
	top: 12px !important;
	left: -50%;
}

#rowDataDisplay .modal-content {
	width: 140% !important;
	border-radius: 8px !important;
	top: 48px !important;
	left: -30%;
}

#chartModal .modal-content {
	width: 140% !important;
	border-radius: 8px !important;
	top: 48px !important;
	left: -30%;
}

.modal-header {
	color: #ece9e6;
	font-size: 16px;
	height: 56px;
	display: flex;
	justify-content: space-between;
	width: 100%;
}

.btn-group>.btn:first-child {
	font-size: 12px !important;
}

#ulRowData .col-lg-4,
#ulRowData .col-lg-8 {
	padding: 1px !important;
	border: 1px solid #dfdfdf !important;
}

.dt-buttons {
	display: flex;
}

#viewDatatable,
#viewDashboard {
	cursor: pointer;
	width: 100%;
	text-align: center;
	margin-top: 16px;
	font-size: 12px;
}

.dhlBack {
	color: #D40511;
	background: #FFCC00;
	padding: 8px 16px;
	border-radius: 8px;
}

.dhlBackTop {
	color: #D40511;
	background: #FFCC00;
	padding: 8px 16px;
	font-weight: bold;
	border-radius: 2px;
}

.blink {
	animation: blink 3s steps(5, start) infinite;
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

#ulRowData .col-lg-4,
#ulRowData .col-lg-8 {
	padding: 0px 6px !important;
	word-break: break-word !important;
}

.select2-container {
	font-weight: 400;
}

.select2-selection {
	height: 32px !important;
}

.modal-dialog {
	margin-top: 64px !important;
}

.modal-content {
	border: none !important;
}

.ui-widget.ui-widget-content {
	border: none !important;
	z-index: 100000;
	font-size: 11px;
	width: 200px !important;
	max-height: 200px !important;
	overflow-y: auto !important;
}

#tripNoAutoComplete:focus {
	outline: none !important;
}

#legDetailsModal .modalTripNo span {
	color: white !important;
}
.list-markers-ul {
	display:none !important;
}
.custom-div-icon {
   position: absolute;
   width: 22px;
   font-size: 22px;
   left: 0;
   right: 0;
   margin: 10px auto;
   text-align: center;
}
.leaflet-control-attribution{
	display:none !important;
}

.command{
	background: white;
    border-radius: 4px;
padding: 4px 16px 8px 16px;    display: flex;
    justify-content: space-around;
    flex-direction: row;
    width: 220px;}

	.leafLeft{
    display: flex;
    align-items: center;
	}
	.leafRight{
		margin-top:4px;
		margin-left:-4px;
		margin-right:16px;
	}
			
th:first-child{
	width:83px !important;
}
.fa.fa-lock{
	margin-left: 4px !important;
	padding-left: 8px !important;
}
.fas.fa-exclamation-circle{
	margin-left: 210px;
	padding-top:10px;
	background-color: white;
    color: red;
}
#cancelButton{
	margin-left:70px;
}
.fas.fa-check-circle{
	margin-left: 210px;
	padding-top:10px;
	background-color: white;
    color: #6cc318;
}
.far.fa-times-circle{
	margin-left: 210px;
	padding-top:10px;
	background-color: white;
    color: red;
}
#unlockPopUp,#locationCheckId,#vehicleSuccessId,#vehicleFailureId, #selectTripId{
	margin-top: 10%;
}
.btnUnlock{
	background-color:DodgerBlue;
}
#lockSummary modal-dialog modal-lg{
	  width: 360px;
      height:600px !important;
}
#unlockBtnId{
color:#ece9e6;margin-right: 79%;
}
#ulRowDataSummary .col-lg-6 {
	padding: 0px 6px !important;
	word-break: break-word !important;
	font-size:14px;
	margin-left: -15px;
}
#lockSummary .dt-buttons ,#lockEnvelopeModal .dt-buttons {
	display: flex;
	margin-bottom: -30px;
}
.fa.fa-lock.blink {
	animation: blink 3s steps(5, start) infinite;
	-webkit-animation: blink 1s steps(5, start) infinite;
}

.btnContinue{
	background-color:DodgerBlue;
}

.btnSkip{
    background-color: #118c23;
}

 

</style>
<div class="center-view" id="loading-div" style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;top: 40vh;">
</div>
<div class="center-viewInitial" id="loading-divInitial"  style="display:block;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;top: 40vh;">
</div>
<div class="center-view" id="loading-div" style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;top: 40%;">
</div>
<section class="vbox" style="">
   <section class="hbox stretch" style="margin:8px;">
      <section id="content">
         <section class="vbox" >
            <section class="scrollable padder" id="contentChild">
               <div class="m-b-md" style="display:none;">
                  <div class="row">
                     <div class="col-sm-6">
                        <div style="display:flex">
                           <div>
                              <h3 class="m-b-none m-t-smHead" id="h3Header">NTC Datatable</h3>
                              <small id="lastsixmonths">Priority</small>
                           </div>
                        </div>
                     </div>
                     <div class="col-sm-6">
                        <div class="text-right text-left-xs">
                           <div class="sparkline m-l m-r-lg pull-right" data-type="bar" data-height="35" data-bar-width="6" data-bar-spacing="2" data-bar-color="#fb6b5b">5,8,9,12,8,10,8,9,7,8,6</div>
                           <div class="m-t-sm">
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
               <div class="topRowData dhlBackTop" id="slaDashboardHeader" style="margin-top:-16px;display:flex;justify-content:space-between;align-items:center;">
                  <div style="font-weight:bold;font-size:16px;">SLA DASHBOARD</div>
				  <div class="badge badge-primary badge-pill blue" style="padding: 16px !important;
                     display: flex;
                     justify-content: space-between;
                     align-items: center;color:white !important;width:135px;"onclick="getCountsBasedOnTripTypeStatus('emptyTripVehicles')">Empty Trip &nbsp;&nbsp;<span id="emptyTripVehicles" onclick="getCountsBasedOnTripTypeStatus('emptyTripVehicles')" style = "font-size:14px;"></span></div>
			      <div class="badge badge-primary badge-pill blue" style="padding: 16px !important;
                     display: flex;
                     justify-content: space-between;
                     align-items: center;color:white !important;width:135px;margin-left:-125px !important;"onclick="getCountsBasedOnTripTypeStatus('maintenanceTripVehicles')">Maintenance &nbsp;&nbsp;<span id="maintenanceTripVehicles" onclick="getCountsBasedOnTripTypeStatus('maintenanceTripVehicles')" style = "font-size:14px;"></span></div>
					 <div class="badge badge-primary badge-pill blue" style="padding: 16px !important;
                     display: flex;
                     justify-content: space-between;
                     align-items: center;color:white !important;width:135px;margin-left:-125px !important;"onclick="getCountsBasedOnTripTypeStatus('customerTripVehicles')">Customer &nbsp;&nbsp;<span id="customerTripVehicles" onclick="getCountsBasedOnTripTypeStatus('customerTripVehicles')" style = "font-size:14px;"></span></div>
                  <div class="badge badge-primary badge-pill blue" style="padding: 16px !important;
                     display: flex;
                     justify-content: space-between;
                     align-items: center;color:white !important;width:135px;margin-left:-125px !important;"onclick="getCountsBasedOnTripTypeStatus('totalOnTripVehicles')">Total Trip &nbsp;&nbsp;<span id="totalOnTripVehicles" onclick="getCountsBasedOnTripTypeStatus('totalOnTripVehicles')" style = "font-size:14px;"></span></div>
                  <div><input id="tripNoAutoComplete" placeholder="Search Any Trip Here..." title="Search any trip in the last two months and click enter to reach CE Dashboard." style="width:200px !important;height:32px !important;border-radius:8px;padding-left:4px;"/><i style="display:none;" onclick="autoCompleteShowCEDashboard()" style="cursor:pointer;padding-left:16px;" class="fas fa-2x fa-search"></i></div>
               </div>
               <div class="row topRow" style="margin-top:-12px;">
                  <div class="col-lg-12" style="margin-top:-5px;" >
                     <div style="display:flex;width:100%">
                        <div> <span class="topHeader"> &nbsp;ROUTE NAME </span><br/>
                           <select  id="routeName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                        <div class="leftMargin"> <span class="topHeader"> &nbsp;CUSTOMER NAME</span> <br/>
                           <select  id="customerName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                        <div class="leftMargin"> <span class="topHeader">&nbsp;CUSTOMER TYPE</span> <br/>
                           <select  id="customerType" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                        <div class="leftMargin"> <span class="topHeader">&nbsp;TRIP TYPE</span> <br/>
                           <select  id="tripType" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                        <div class="leftMargin">
                           <span class="topHeader">&nbsp;REGION WISE</span> <br/>
                           <select  id="regionWise" multiple="multiple" class="input-s" name="state">
                              <option value="'North'">North</option>
                              <option value="'East'">East</option>
                              <option value="'West'">West</option>
                              <option value="'South'">South</option>
                           </select>
                        </div>
                        <div class="leftMargin"> <span class="topHeader">&nbsp;HUB WISE</span> <br/>
                           <select  id="hubWise" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                        <div class="leftMargin" id="hubDirectionDiv">
                           <span class="topHeader">&nbsp;DIRECTION</span> <br/>
                           <select  id="hubDirection" multiple="multiple" class="input-s" name="state">
                              <option>Incoming</option>
                              <option>Outgoing</option>
                           </select>
                        </div>
                        <div style="display:flex;padding-top:24px;">
                           <input onclick="viewClicked()" type="button" class="btn btn-success" style="padding-left:16px;padding-right:16px;" value="View" />
                           <!--<i class="far fa-eye fa-2x btnStyle" title="VIEW" onclick="viewClicked()" style="color:#4ED352;"></i>-->
                           <i class="fab fa-rev fa-2x btnStyle" title="RESET" onclick="resetClicked()" style="color:#FFCC00;"></i>
                           <i class="fas fa-envelope-square fa-2x btnStyle" onclick="openEnvelopeModal()" title="MODAL" style="color:#FFCC00;"></i>
                           <i class="far fa-question-circle fa-2x btnStyle" title="HELP" onclick="helpingServlet()" style="color:#FFCC00;"></i>
                           <div onclick="openSmartLockEnvelope()"><i class="fa fa-lock fa-2x btnStyle blink " title="SmartLock" style="color:#FFCC00;"></i></div>
						   <!--   <i class="far fa-question-circle fa-2x btnStyle" title="CHART" onclick="createGraph()" style="color:#fc0;"></i>-->
                        </div>
                     </div>
                  </div>
               </div>
               <div class="row">
                  <div class="col-lg-9" style="padding-right:6px;">
                     <div class="row" style="margin-top:8px;">
                        <div class="col-lg-3" style="padding-right:0px;display: flex;flex-direction: column;justify-content: space-between;">
                           <div class="card ">
                              <div class="cardHeading blue-gradient-rgba">
                                 <div class="threePixelPadding">
                                    <p data-toggle="tooltip" title="Vehicles which are coming to source for placement.Trip status=enroute placement ontime and enroute placement delayed ">ENROUTE PLACEMENT</p>
                                 </div>
                                 <span class="badge badge-primary badge-pill badgeHeader blue" id="enroute" onclick="getCountsBasedOnStatus('enrouteTotal')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                              </div>
                              <ul class="list-group">
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="Vehicles which are coming to source for placement on or before scheduled time.">On-Time</span>
                                    <span class="badge badge-primary badge-pill green-gradient-rgba" id="enrouteOntime" onclick="getCountsBasedOnStatus('enrouteOnTime')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="Vehicles are esitimated to arrive at source late from the scheduled time.">Delayed</span>
                                    <span class="badge badge-primary badge-pill red-gradient-rgba" id="enrouteDelayed" onclick="getCountsBasedOnStatus('enrouteDelayed')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                              </ul>
                           </div>
                           <div class="card" style="margin-top:12px;">
                              <div class="cardHeading blue-gradient-rgba">
                                 <div class="threePixelPadding">DETENTION</div>
                                 <span class="badge badge-primary badge-pill badgeHeader blue" id="detentionTotal" onclick="getCountsBasedOnStatus('detentionTotal')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                              </div>
                              <ul class="list-group">
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="Vehicles are at unloading point and not yet departed by exceeding the detention time.">Unloading</span>
                                    <span class="badge badge-primary badge-pill" id="unloadingDetention" onclick="getCountsBasedOnStatus('unloadingDetention')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="Vehicles are at loading point and not yet departed by exceeding the detention time.">Loading</span>
                                    <span class="badge badge-primary badge-pill" id="loadingDetention" onclick="getCountsBasedOnStatus('loadingDetention')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                              </ul>
                           </div>
                        </div>
                        <div class="col-lg-6">
                           <div class="card " id="greenCard">
                              <div class="cardHeading green-gradient-rgba">
                                 <div class="threePixelPadding">ON-TIME</div>
                                 <span class="badge badge-primary badge-pill green-gradient-rgba badgeHeader green"  onclick="getCountsBasedOnStatus('totalOnTime')" id="ontimeTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                              </div>
                              <div class="row" style="margin:6px 4px;">
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=ontime and ATP is not null and ATD is null">Loading</span>
                                             <span class="badge badge-primary badge-pill green-gradient-rgba" id="ontimeLoading" onclick="getCountsBasedOnStatus('onTimeLoading')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=ontime and ATD is not null and ATA is null">In-Transit</span>
                                             <span class="badge badge-primary badge-pill green-gradient-rgba"  id="ontimeIntransit" onclick="getCountsBasedOnStatus('onTimeIntransit')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                    </div>
                                    </li>
                                    </ul>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=ontime and ATA is not null and Trip closed time is null">Unloading</span>
                                             <span class="badge badge-primary badge-pill green-gradient-rgba" id="ontimeUnloading" onclick="getCountsBasedOnStatus('onTimeUnLoading')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                              <div class="row" style="margin:4px 4px 0px 4px;">
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">Unplanned Stoppage</span>
                                             <span class="badge badge-primary badge-pill  green-gradient-rgba" id="unscheduledStoppageOntime" onclick="getCountsBasedOnStatus('ontimeStoppage')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">SmartHub Detention</span>
                                             <span class="badge badge-primary badge-pill green-gradient-rgba" id="smartHubDetentionOntime" onclick="getCountsBasedOnStatus('ontimeDetention')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">Route Deviation</span>
                                             <span class="badge badge-primary badge-pill green-gradient-rgba" id="routeDeviationOntime" onclick="getCountsBasedOnStatus('ontimeDeviation')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-lg-3" style="padding-left:0px">
                           <div class="card" id="alertsCard">
                              <div class="cardHeading blue-gradient-rgba">
                                 <div class="threePixelPadding">ALERTS</div>
                                 <span class="badge badge-primary badge-pill badgeHeader blue" style="visibility:hidden" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                              </div>
                              <ul class="list-group">
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="">SH Missed</span>
                                    <span class="badge badge-primary badge-pill" id="smartHubMissed"  onclick="getCountsBasedOnStatus('shMissed')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="">CH Missed</span>
                                    <span class="badge badge-primary badge-pill" id="customerHubMissed"  onclick="getCountsBasedOnStatus('chMissed')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="">Non Comm</span>
                                    <span class="badge badge-primary badge-pill" id="nonCommunicating"  onclick="getCountsBasedOnStatus('nonComm')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="">Idle</span>
                                    <span class="badge badge-primary badge-pill" id="idle"  onclick="getCountsBasedOnStatus('idle')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
                                 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="" style="white-space:nowrap !important;">Temp. Deviation</span>
                                    <span class="badge badge-primary badge-pill" id="temperatureDeviation"  onclick="getCountsBasedOnStatus('tempDeviation')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                 </li>
								 <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
                                    <span data-toggle="tooltip" title="">Container Unlocked</span>
                                    <span class="badge badge-primary badge-pill" id="containerUnlocked"  onclick="getCountsBasedOnStatus('containerUnlocked')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                </li>
                              </ul>
                           </div>
                        </div>
                     </div>
                     <div class="row"  style="margin-top:8px;">
                        <div class="col-lg-6"  style="padding-right:4px;">
                           <div class="card " id="orangeCard">
                              <div class="cardHeading orange-gradient-rgba">
                                 <div class="threePixelPadding">
                                    <p data-toggle="tooltip" title="Trips running delay time <1 hour">DELAYED < 1 HOUR</p>
                                 </div>
                                 <span class="badge badge-primary badge-pill green-gradient-rgba badgeHeader orange" id="delayedLessTotal"  onclick="getCountsBasedOnStatus('totalDelayedLess')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                              </div>
                              <div class="row" style="margin:6px 4px;">
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=delayed and ATP is not null and ATD is null">Loading</span>
                                             <span class="badge badge-primary badge-pill  orange-gradient-rgba" id="delayedLessLoading" onclick="getCountsBasedOnStatus('delayedLessLoading')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=delayed and ATD is not null and ATA is null">In-Transit</span>
                                             <span class="badge badge-primary badge-pill orange-gradient-rgba" id="delayedLessIntransit" onclick="getCountsBasedOnStatus('delayedLessIntransit')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=delayed and ATA is not null and Trip closed time is null">Unloading</span>
                                             <span class="badge badge-primary badge-pill orange-gradient-rgba" id="delayedLessUnloading" onclick="getCountsBasedOnStatus('delayedLessUnLoading')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                              <div class="row"  style="margin:4px;">
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">Unplanned Stoppage</span>
                                             <span class="badge badge-primary badge-pill orange-gradient-rgba" id="unscheduledStoppage" onclick="getCountsBasedOnStatus('delayedLessStoppage')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">SmartHub Detention</span>
                                             <span class="badge badge-primary badge-pill orange-gradient-rgba" id="smartHubDetentionDelayedLess" onclick="getCountsBasedOnStatus('delayedLessDetention')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">Route Deviation</span>
                                             <span class="badge badge-primary badge-pill orange-gradient-rgba" id="routeDeviationDelayedLess" onclick="getCountsBasedOnStatus('delayedLessDeviation')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-lg-6" style="padding-left:4px;">
                           <div class="card "  id="redCard">
                              <div class="cardHeading red-gradient-rgba">
                                 <div class="threePixelPadding">
                                    <p data-toggle="tooltip" title="Trips running delay time > 1 hour">DELAYED > 1 HOUR</p>
                                 </div>
                                 <span class="badge badge-primary badge-pill green-gradient-rgba badgeHeader red" id="delayedGreaterTotal"  onclick="getCountsBasedOnStatus('totalDelayedGreater')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                              </div>
                              <div class="row" style="margin:6px 4px;">
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=delayed and ATP is not null and ATD is null">Loading</span>
                                             <span class="badge badge-primary badge-pill red-gradient-rgba" id="delayedGreaterLoading" onclick="getCountsBasedOnStatus('delayedGreaterLoading')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=delayed and ATD is not null and ATA is null">In-Transit</span>
                                             <span class="badge badge-primary badge-pill red-gradient-rgba" id="delayedGreaterIntransit" onclick="getCountsBasedOnStatus('delayedGreaterIntransit')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeightShort">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="Trip status=delayed and ATA is not null and Trip closed time is null">Unloading</span>
                                             <span class="badge badge-primary badge-pill red-gradient-rgba" id="delayedGreaterUnloading" onclick="getCountsBasedOnStatus('delayedGreaterUnloading')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                              <div class="row"  style="margin:4px;">
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">Unplanned Stoppage</span>
                                             <span class="badge badge-primary badge-pill red-gradient-rgba" id="unscheduledStoppageDelayedGreater" onclick="getCountsBasedOnStatus('delayedGreaterStoppage')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">SmartHub Detention</span>
                                             <span class="badge badge-primary badge-pill red-gradient-rgba" id="smartHubDetentionDelayedGreater" onclick="getCountsBasedOnStatus('delayedGreaterDetention')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                                 <div class="col-lg-4">
                                    <div class="card cardHeight">
                                       <ul class="list-group "  style="margin-top:8px;">
                                          <li class="list-group-item d-flex justify-content-between align-items-center">
                                             <span data-toggle="tooltip" title="">Route Deviation</span>
                                             <span class="badge badge-primary badge-pill red-gradient-rgba" id="routeDeviationDelayedGreater" onclick="getCountsBasedOnStatus('delayedGreaterDeviation')" ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                                          </li>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div id="viewDatatable" style="margin-left:100px;margin-top:32px;margin-bottom:40px;"> <span class="dhlBack"><i class="fas fa-chevron-down blink"></i>&nbsp;&nbsp;<strong>VIEW TRIP DETAILS</strong> &nbsp;&nbsp; <i class="fas fa-chevron-down blink"></i></span></div>
                  </div>
                  <div class="col-lg-3" style="padding-left:0px;" >
                     <div style="border:1px solid #939393;border-radius:8px;margin-bottom:8px;margin-top:8px;width:100%;height:478px;padding:4px;">
                        <div id="map" style="width:100%;height:100%">
                        </div>
                     </div>
                  </div>
               </div>
               <div class="row topRowData" id="tripDetailsDiv">
                  <div class="col-lg-12">TRIP DETAILS</div>
               </div>
               <div class="row" style="margin-bottom:24px;margin-top:0px;">
                  <div class="col-lg-12">
                     <div id="legDetailsModal"  class="modal fade" role="dialog" style="width:100% !important;">
                        <div class="modal-dialog" style="width:70% !important;max-width:70% !important;">
                           <div class="modal-content" >
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">LEG DETAILS (TRIP NO: <span id="modalTripNo" class="modalTripNo" style="color:blue"></span>)</h6>
                              </div>
                              <div class="modal-body" id="legDetailsModalBody">
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div id="envelopeModal"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">ACTION REQUIRED FOR GEOFENCE CORRECTION</h6>
                              </div>
                              <div class="modal-body">
                                 <table id="onTripVehicleDetails" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                                    <thead>
                                       <tr>
                                          <th>Sl. No.</th>
                                          <th style="display:none;">Id</th>
                                          <th>Trip No</th>
                                          <th>Vehicle Number</th>
                                          <th style="display:none;">Trip Cutsomer Id</th>
                                          <th>Customer Name</th>
                                          <th>Total Stop Time(HH:mm:ss)</th>
                                          <th>Stoppage Begin</th>
                                          <th>Map View</th>
                                          <th>Trip ID</th>
                                          <th>Route ID</th>
                                          <th>Latitude</th>
                                          <th>Longitude</th>
                                          <th>Current Location</th>
                                          <th>Status</th>
                                          <th style="display:none;">Trip Id</th>
                                       </tr>
                                    </thead>
                                 </table>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
			<div id="lockEnvelopeModal"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">ACTION REQUIRED FOR SMART LOCK</h6>
                              </div>
                              <div class="modal-body" style="width:100% !important">
                                 <table id="onTripLockedVehicleDetails" class="table table-striped table-bordered" cellspacing="0" style="width:100%">
                                    <thead >
                                       <tr>
                                          <th>Sl. No.</th>
                                          <th>Vehicle No</th>
										  <th>Trip No</th>
                                          <th>Driver Name</th>
                                          <th>Driver Number</th>
                                          <th>Lock Status</th>
                                          <th>Vehicle Tracking Time</th>
                                          </tr>
                                    </thead>
                                 </table>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
					 
                     <div id="onTripVehiclStoppageMapModal"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">ACTION REQUIRED FOR GEOFENCE CORRECTION</h6>
                              </div>
                              <div class="modal-body">
                                 <div id="dvMap" style="width: 896px; height: 417px; margin-top: 8px; margin-left:30px;border: 1px solid gray;"></div>
                                 <div class="inline row" style="margin-left: 2px;margin-top: 7px;  display: -webkit-box;">
                                    <label class="container checkbox-inline col-md-6" style="padding-left: 41px; font-weight: 400;">
                                       <div class="checkbox">
                                    <label><input type="checkbox" id="smartHub" value="">Show Customer/Smart Hubs</label>
                                    </div>
                                    </label>
                                 </div>
                                 <div>
                                    <h5 id="dialogBoxId" style="color:red;"></h5>
                                 </div>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div id="columnSetting"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">COLUMN SETTINGS</h6>
                              </div>
                              <div class="modal-body">
                                 <b>Check the items you want to display:</b>
                                 <br/>
                                 <ul id="sortable">
                                    <li class="second"><input type="checkbox" name="select-all" id="select-all" />Select All</li>
                                 </ul>
                              </div>
                              <div class="modal-footer">
                                 <input onclick="createOrUpdateListViewColumnSetting()" type="button" class="btn btn-success" id="columnSettingSave" value="Save" />
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div id="rowDataDisplay"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">TRIP DATA</h6>
                              </div>
                              <div class="modal-body" style="height:60vh;overflow-y:auto;">
                                 <ul id="ulRowData">
                                 </ul>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
					 <div id="lockSummary"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog modal-lg">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">LOCK/UNLOCK SUMMARY</h6>
                              </div>
                              <div class="modal-body" style="height:-1vh;overflow:hidden;">
                                 <ul id="ulRowDataSummary">
                                 </ul>
								<table id="activityReportTable" class="table table-striped table-bordered" cellspacing="0" style="width:100%;font-size:13px;">
                                    <thead>
                                       <tr>
										  <th>Sl. No.</th>
                                          <th>Vehicle No</th>
                                          <th>Alert Datetime</th>                                          
                                          <th>Unlock Time</th>
                                          <th>Locked Time</th>
                                          <th>Unlocked Duration(min)</th>
                                          <th>First Gate Opened Time</th>
                                          <th>Last Gate Closed Time</th>
										  <th>Latitude</th>
                                          <th>Longitude</th>
										  <th>Location </th>
                                         </tr>
                                    </thead>
                                 </table>
								</div>
								<div class="modal-footer" style="margin-top:0px;">
								<button id="unlockBtnId" type="button" class="btn btn-default btnUnlock" onclick="displayAlertMessage()" data-dismiss="modal">UNLOCK</button>
                                <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
							  </div>
							   </div>
                           </div>
                        </div>
                     </div>
					  <div id="lockSummaryNoUnlock"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">LOCK/UNLOCK SUMMARY</h6>
                              </div>
                              <div class="modal-body" style="height:45vh;overflow-y:auto;">
                                 <ul id="ulRowDataSumm">
                                 </ul>
                              </div>
                              <div class="modal-footer">
								<!--<button id="unlockBtnId" type="button" class="btn btn-default btnUnlock" style="color:#ece9e6;margin-right: 65%;" onclick="displayRowDataSummary()" data-dismiss="modal">UNLOCK</button>-->
                                <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
					  <div id="unlockPopUp"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title" align="center">  ALERT!! </h6>
                              </div>
							  <div id="exclamationcircle">
							  <i class="fas fa-exclamation-circle fa-3x"></i>
							  <p style="margin-left: 65px;padding-top: 10px;"> ARE YOU SURE TO UNLOCK THE CONTAINER?? </p>
							  </div>
                              <div class="modal-footer">
							  <button type="button" class="btn btn-default btnUnlock" style="color:#ece9e6;margin-right:36%;" onclick="displayRowDataSummary()" data-dismiss="modal">Yes, Unlock it!!</button>
                              
                                 <button id="cancelButton"type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">No, Cancel</button>
                              </div>
                           </div>
                        </div>
                     </div>
					   <div id="locationCheckId"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title" align="center"> WARNING!! </h6>
                              </div>
							  <div id="exclamationcircle">
							  <i class="fas fa-exclamation-circle fa-3x"></i>
							  <p style="margin-left: 25px;padding-top: 10px;">The current location of the vehicle is not valid for Unlocking the container. Still want to continue UNLOCKING?</p>
							  </div>
                              <div class="modal-footer">
							  <button type="button" class="btn btn-default btnUnlock" style="color:#ece9e6;margin-right: 30%;" onclick="unlockSuccess()"  data-dismiss="modal">Yes, Continue Unlocking...!!!</button>
                              
                                 <button id="closeButton"type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal"> No, Cancel</button>
                              </div>
                           </div>
                        </div>
                     </div>
					 <div id="vehicleSuccessId"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title" align="center">VEHICLE LOCK STATUS </h6>
                              </div>
                              <i class="fas fa-check-circle fa-3x"></i>
							  <div>
							  <p style="margin-left: 65px;padding-top: 10px;"> THE VEHICLE IS UNLOCKED SUCCESSFULLY!! </p>
							  </div>
                              <div class="modal-footer">
						        <button type="button" class="btn btn-default btnUnlock" style="color:#ece9e6;" data-dismiss="modal">OK</button>
                              </div>
                           </div>
                        </div>
                     </div>
					 <div id="vehicleFailureId"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title" align="center">VEHICLE LOCK STATUS </h6>
                              </div>
                              <i class="far fa-times-circle fa-3x"></i>
							  <div>
							  <p style="margin-left: 25px;padding-top: 10px;"> The Vehicle isn't UNLOCKED!! Please try again OR contact your supervisor..</p>
							  </div>
                              <div class="modal-footer">
						        <button type="button" class="btn btn-default btnUnlock" style="color:#ece9e6;" data-dismiss="modal">OK</button>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div id="chartModal"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title">SPEED CHART</h6>
                              </div>
                              <div class="modal-body" style="height:60vh;overflow-y:auto;">
                                 <div id="speed_chart" style="width: 900px; height: 500px"></div>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;" data-dismiss="modal">Close</button>
                              </div>
                           </div>
                        </div>
                     </div>
					  <div id="selectTripId"  class="modal fade" role="dialog" style="width:100% !important">
                        <div class="modal-dialog">
                           <div class="modal-content">
                              <div class="modal-header blue-gradient-rgba">
                                 <h6 class="modal-title" style = "margin-left: 184px; font-size: larger;"> Attention!! </h6>
								 <button type="button" class="close" onclick="changeRadioClick()" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true" data-toggle="tooltip" title = "Close">&times;</span>
                                 </button>
							 </div>
                              <div>
							   <p style="margin-left: 17px;padding-top: 15px;"> 
							   </p>
							   </div>
							  <div>
							  <input type="text" class="form-control comboClass" maxLength="60" id="tripOrVehicleId" placeholder="Enter Trip No / Vehicle No" required style= "width: 210px !important;margin-left: 134px; position: relative ; top: -14px;">
							  </div>
                              <div class="modal-footer ">
							    <button type="button" class="btn btn-default btnContinue" onclick="getSpecifiedTripDetails()" style="color:#ece9e6; position:relative;left: -167px;" data-dismiss="modal">Submit</button>
							    <button type="button" class="btn btn-default btnSkip" onclick="getTripDetails()" style="color:#ece9e6; position:relative;left: -167px;" data-dismiss="modal">Skip</button>
						       </div>
                           </div>
                        </div>
                     </div>
                     <table id="tripDatatable" class="display" border="1">
                        <thead>
                           <tr>
                              <th></th>
                              <th>Trip Id</th>
                              <th>Route Id</th>
                              <th>End Date</th>
                              <th nowrap="nowrap">Sl. No.</th>
                              <th nowrap="nowrap">Created Time</th>
                              <th nowrap="nowrap">Trip No.</th>
                              <th nowrap="nowrap">Vehicle No.</th>
                              <th nowrap="nowrap">Customer Name</th>
                              <th nowrap="nowrap">Route ID</th>
                              <th nowrap="nowrap">Route Key</th>
                              <th nowrap="nowrap">Current Location</th>
                              <th nowrap="nowrap">Trip Type</th>
                              <th nowrap="nowrap">Trip Category</th>
                              <th nowrap="nowrap">Trip ID</th>
                              <th nowrap="nowrap">Customer Reference ID</th>
                              <th nowrap="nowrap">Customer Type</th>
                              <th nowrap="nowrap">Make of Vehicle</th>
                              <th nowrap="nowrap">Type of Vehicle</th>
                              <th nowrap="nowrap">Driver 1 Name</th>
                              <th nowrap="nowrap">Driver 1 Contact</th>
                              <th nowrap="nowrap">Driver 2 Name</th>
                              <th nowrap="nowrap">Driver 2 Contact</th>
                              <th nowrap="nowrap">Origin City</th>
                              <th nowrap="nowrap">Destination City</th>
                              <th nowrap="nowrap">STP</th>
                              <th nowrap="nowrap">ATP</th>
                              <th nowrap="nowrap">Placement Delay</th>
                              <th nowrap="nowrap">Loading Detention(HH:mm:ss)</th>
                              <th nowrap="nowrap">STD</th>
                              <th nowrap="nowrap">ATD</th>
                              <th nowrap="nowrap">Departure Delay wrt STD</th>
                              <th nowrap="nowrap">Next Touch Point</th>
                              <th nowrap="nowrap">Distance to Next Touch Point(km)</th>
                              <th nowrap="nowrap">ETA to Next Touch Point</th>
                              <th nowrap="nowrap">STA wrt STD</th>
                              <th nowrap="nowrap">STA wrt ATD</th>
                              <th nowrap="nowrap">ETA</th>
                              <th nowrap="nowrap">ATA</th>
                              <th nowrap="nowrap">Planned TT - incl. SH Stoppages</th>
                              <th nowrap="nowrap">Actual TT - incl. SH Stoppages</th>
                              <th nowrap="nowrap">Transit Delay(HH:mm:ss)</th>
                              <th nowrap="nowrap">Trip Status</th>
                              <th nowrap="nowrap">Distance(km)</th>
                              <th nowrap="nowrap">Avg. Speed(kmph)</th>
                              <th nowrap="nowrap">Close/Cancellation Time</th>
                              <th nowrap="nowrap">Reason for Cancellation</th>
                              <th nowrap="nowrap">Unloading Detention(HH:mm:ss)</th>
                              <th nowrap="nowrap">Last Comm</th>
                              <th nowrap="nowrap">Vehicle Stoppage</th>
							  <th nowrap="nowrap">Lock Status</th>
							  <th nowrap="nowrap">Tracking Time</th>
                           </tr>
                        </thead>
                     </table>
                     <div id="viewDashboard">
                        <div class="row">
                           <div class="col-lg-9" style="margin-left:100px;margin-left: 100px;"><span class="dhlBack"><i class="fas fa-chevron-up blink"></i>&nbsp;&nbsp;<strong>VIEW DASHBOARD & MAP </strong>&nbsp;&nbsp; <i class="fas fa-chevron-up blink"></i></span></div>
                           <div class="col-lg-3"></div>
                        </div>
                     </div>
                  </div>
               </div>


            </section>
         </section>
      </section>
   </section>
</section>
</section>

<script>
//history.pushState({ foo: 'fake' }, 'Fake Url', 'SLADashboardNew#');
var userType = '<%=userAuthorityCTExec%>';
var userAuthority= '<%=userAuthority%>';
var  userName='<%=userName%>';
var  userId='<%=userId%>';
var t4uspringappURL = '<%=t4uspringappURL%>';
var getlockunlockStatusResult;
window.onload = callNotification();

function callNotification() {
if (userType === "CT Executive") {
      openEnvelopeModal();
   }
 }

setInterval(function () {
   if (userType === "CT Executive") {
      openEnvelopeModal();
   }
}, 300000);

let count = 0;
let prev = "";
let map;
let markerCluster;
let markerClusterArray = [];
var onTripVehAlertMapInfo = {};
var mapView;
var routeNameLength = 0;
var custNameLength = 0;
var custTypeLenght = 0;
var tripTypeLength = 0;
var hubDirectionLength = 0;
var regionLength = 4;
var hubNameLength = 0;
var weatherAllCityMarkerArr=[];
var weatherCapitalCityMarkerArr=[];
var cityArr = ['Delhi', 'Mumbai', 'Chennai', 'Bangalore', 'Hyderabad', 'Nagpur', 'Kolkata', 'Guwahati'];
var markersLayer;
var mainRowTripType = '';
var selectedValue = '';
var rangeId =0;

$("#viewDatatable").click(function () {
   $('html, body').animate({
      scrollTop: $("#tripDetailsDiv").offset().top - 48
   }, 1000);
});

$("#viewDashboard").click(function () {
   $('html, body').animate({
      scrollTop: $("#contentChild").offset().top - 60
   }, 1000);
});


$(document).keyup(function (e) {
   if (e.key === "Escape") {
      $("#rowDataDisplay").modal("hide");
	  $('#lockSummary').modal('hide');
		$('#lockSummaryNoUnlock').modal('hide');
		$('#unlockPopUp').modal('hide');
		$('#locationCheckId').modal('hide');
		$('#vehicleSuccessId').modal('hide');
		$('#vehicleFailureId').modal('hide');
		$('#lockEnvelopeModal').modal('hide');
		}
});

function helpingServlet() {
   window.open("<%=request.getContextPath()%>/HelpDocumentServlet?FileName=SLAFieldLogics.pdf");
}


let autoCompleteResultList;
let autoCompleteOptions = [];
let getAutoCompleteResultList;
let getAutoCompleteOptions = [];

function autoCompleteShowCEDashboard() {
   let selValue = "";
   $.each(getAutoCompleteResultList, function (i, item) {
      if (item.tripNo === $('#tripNoAutoComplete').val()) {
         selValue = item.tripId;
      }
   });
   $("#tripNoAutoComplete").val("");
   showCEDashboard(selValue);
}

function autoCompleteShowCEDashboardOnSelect(value) {
   let selValue = "";
   $.each(getAutoCompleteResultList, function (i, item) {
      if (item.tripNo === value) {
         selValue = item.tripId;
      }
   });
   setTimeout(function(){ $("#tripNoAutoComplete").val("");},1000)
   showCEDashboard(selValue);
}

$(document).ready(function () {

   $.ajax({
      url: t4uspringappURL + 'getLastTwoMonthsTripNo',
      datatype: 'json',
      contentType: "application/json",
      data: {
         systemId: <%=systemId%>,
         custId: <%=customerId%>
      },
      success: function (result) {
         getAutoCompleteResultList = result.responseBody;

         $.each(result.responseBody, function (i, item) {
            getAutoCompleteOptions.push(item.tripNo);
         });
         $("#tripNoAutoComplete").autocomplete({
            source: function (request, response) {
               var results = $.ui.autocomplete.filter(getAutoCompleteOptions, request.term);
               response(results.slice(0, 100));
            },
            select: function( event, ui ) {
              autoCompleteShowCEDashboardOnSelect(ui.item.label);
            },
            minLength: 0,
            delay: 0,
         });
      }
   });

   $('#tripNoAutoComplete').keypress(function (event) {
      var keycode = (event.keyCode ? event.keyCode : event.which);
      if (keycode == '13') {
         autoCompleteShowCEDashboard();
      }
   });

   $.ajax({
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
      success: function (response) {
         routeList = JSON.parse(response);
         var $routeName = $('#routeName');
         var output = '';
         routeNameLength = routeList.length;
         $.each(routeList, function () {
            $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeName);
         });
         $('#routeName').multiselect({
            nonSelectedText: 'ALL',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            allSelectedText: 'ALL',
            buttonWidth: 160,
            maxHeight: 200,
            selectAllText: 'ALL',
            selectAllValue: 'ALL'
         });
         $("#routeName").multiselect('selectAll', false);
         $("#routeName").multiselect('updateButtonText');

      }
   });

   $.ajax({

      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustNamesForSLA',
      success: function (response) {
         custList = JSON.parse(response);
         var $custName = $('#customerName');
         var output = '';
         custNameLength = custList["customerRoot"].length;
         for (var i = 0; i < custList["customerRoot"].length; i++) {
            $('#customerName').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
         }
         $('#customerName').multiselect({
            nonSelectedText: 'ALL',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            allSelectedText: 'ALL',
            buttonWidth: 160,
            maxHeight: 200,
            includeSelectAllOption: true,
            selectAllText: 'ALL',
            selectAllValue: 'ALL',
         });
         $("#customerName").multiselect('selectAll', false);
         $("#customerName").multiselect('updateButtonText');
      }
   });

   $.ajax({
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripCustomerType',
      success: function (response) {
         custTypeList = JSON.parse(response);
         custTypeLenght = custTypeList["tripCustTypeRoot"].length;
         for (var i = 0; i < custTypeList["tripCustTypeRoot"].length; i++) {
            $('#customerType').append($("<option></option>").attr("value", "'" + custTypeList["tripCustTypeRoot"][i].tripCustomerValue + "'").text(custTypeList["tripCustTypeRoot"][i].tripCustomerType));
         }
         $('#customerType').multiselect({
            nonSelectedText: 'ALL',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            allSelectedText: 'ALL',
            buttonWidth: 160,
            maxHeight: 200,
            includeSelectAllOption: true,
            selectAllText: 'ALL',
            selectAllValue: 'ALL',
         });
         $("#customerType").multiselect('selectAll', false);
         $("#customerType").multiselect('updateButtonText');
      }
   });


   $.ajax({
      url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getProductLine',
      data: {
         custId: <%=customerId%>
      },
      success: function (response) {
         tripTypeList = JSON.parse(response);
         var $tripType = $('#tripType');
         var output = '';
         tripTypeLength = tripTypeList["productLineRoot"].length;
         for (var i = 0; i < tripTypeList["productLineRoot"].length; i++) {
            $('#tripType').append($("<option></option>").attr("value", "'" + tripTypeList["productLineRoot"][i].productname + "'").text(tripTypeList["productLineRoot"][i].productname));
         }
         $('#tripType').multiselect({
            nonSelectedText: 'ALL',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            allSelectedText: 'ALL',
            buttonWidth: 160,
            maxHeight: 200,
            includeSelectAllOption: true,
            selectAllText: 'ALL',
            selectAllValue: 'ALL',
         });
         $("#tripType").multiselect('selectAll', false);
         $("#tripType").multiselect('updateButtonText');
      }
   });
   $('#regionWise').multiselect({
      nonSelectedText: 'ALL',
      includeSelectAllOption: true,
      enableFiltering: true,
      enableCaseInsensitiveFiltering: true,
      numberDisplayed: 1,
      allSelectedText: 'ALL',
      buttonWidth: 160,
      maxHeight: 200,
      includeSelectAllOption: true,
      selectAllText: 'ALL',
      selectAllValue: 'ALL',
   });
   $("#regionWise").multiselect('selectAll', false);
   $("#regionWise").multiselect('updateButtonText');

   $('#hubDirection').multiselect({
      nonSelectedText: 'ALL',
      includeSelectAllOption: true,
      enableFiltering: true,
      enableCaseInsensitiveFiltering: true,
      numberDisplayed: 1,
      allSelectedText: 'ALL',
      buttonWidth: 160,
      maxHeight: 200,
      includeSelectAllOption: true,
      selectAllText: 'ALL',
      selectAllValue: 'ALL',
   });
   $("#hubDirection").multiselect('selectAll', false);
   $("#hubDirection").multiselect('updateButtonText');
   /* var heat = L.heatLayer([
		[23.703161, 90.414101, 1],
	], {radius: 35,
		max: 1.0,
		blur: 15,
		gradient: {
			0.0: 'green',
			0.5: 'yellow',
			1.0: 'red'
		},
		minOpacity: 0.7}); */
   getHubNames();
   getListViewDetails("totalOnTripVehicles", 0, "", true);
   getAllCounts();
   getAllMainCounts();
   initialize("map", new L.LatLng(20.5937, 78.9629), '<%=mapName%>', '<%=appKey%>', '<%=appCode%>');

/*    markersLayer = new L.LayerGroup();	//layer contain searched elements
   map.addLayer(markersLayer);
   var list = new L.Control.ListMarkers({layer: markersLayer, itemIcon: null});
   map.addControl(list);  */

   plotVehiclesOnMap("totalOnTripVehicles");
   getWeatherInfoForCities(true);//todo

   var command = L.control({position: 'bottomleft'});

   command.onAdd = function (map) {
		var div = L.DomUtil.create('div', 'command');
		div.innerHTML = '<div class="leafLeft"><input type="checkbox" id="capitalCity" value="" checked> <span class="leafRight">Capital Cities</span></div><div class="leafLeft"><input type="checkbox" id="allCity" value=""> <span class="leafRight"> All Cities</span></div>'
		return div;
   };
   command.addTo(map);
    //document.getElementById("allCity").disabled= true;

     map.on('zoomend', function() {
	   /* if(map.getZoom() > 5) {
		   contained = [];
		   markersLayer.eachLayer(function(lmarker) {
				if( lmarker instanceof L.Marker && map.getBounds().contains(lmarker.getLatLng()))
					contained.push(lmarker);
				    map.addLayer(lmarker);
		   });
		   //console.log('contained ::',contained);
	   } */
	   if(map.getZoom() > 7) {
		   $("#allCity").prop("checked", true).change();
	   } else {
		  $("#allCity").prop("checked", false).change();
	   }
   });

});

setInterval(function () {
   if ($("#onTrip").prop("checked")) {
      getListViewDetails(prev, 0, "", false);
      plotVehiclesOnMap(prev);
      getAllCounts();
	  getAllMainCounts();
	  getWeatherInfoForCities(true);
      radioClick(0);
   }

}, 300000)

/*  setInterval(function () {
   getWeatherInfoForCities(true);
}, 216000‬)  */

function getHubNames(select) {
   $("#hubWise").html("");
   $("#hubWise").multiselect('destroy');
   $.ajax({
      type: 'GET',
      url: t4uspringappURL + 'getSmartHubs',
      datatype: 'json',
      contentType: "application/json",
      data: {
         customerId: <%=customerId%>,
         systemId: <%=systemId%>,
         region: $('#regionWise').val().toString()
      },
      success: function (response) {
         hubList = response.responseBody;
         var output = '';
         hubNameLength = hubList.length;
         for (var i = 0; i < hubList.length; i++) {
            $('#hubWise').append($("<option></option>").attr("value", hubList[i].hubId).text(hubList[i].hubName));
         }
         $('#hubWise').multiselect({
            nonSelectedText: 'ALL',
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
            allSelectedText: 'ALL',
            buttonWidth: 160,
            maxHeight: 200,
            selectAllText: 'ALL',
            selectAllValue: 'ALL',
         }).multiselect('selectAll', false).multiselect('updateButtonText');
         if (select) {
            $("#hubWise").multiselect('selectAll', false);
            $("#hubWise").multiselect('updateButtonText');
         }
      }
   });
}
let rage = 0;

function radioClick(range) {
	if (rage != range) {   
      rage = range;
	 if(range != 0){
		  rangeId = range;
      if (range === 999) {
         $("#startDateInput").show();
         $("#endDateInput").show();
         $("#viewDateRange").show();
		
      } else {
         $("#startDateInput").hide();
         $("#endDateInput").hide();
         $("#viewDateRange").hide();
		 $("#tripOrVehicleId").val('');
		 $("#selectTripId").modal("show");
		 }
	  }else{
		  $("#startDateInput").hide();
         $("#endDateInput").hide();
         $("#viewDateRange").hide();
		 getListViewDetails("totalOnTripVehicles",0,"");
         $("#loading-div").show();		 
	  }
   }
}

function getSpecifiedTripDetails(){
	  
	var inputValue = $('#tripOrVehicleId').val();
	 if (inputValue == '') {
		 sweetAlert("Please Enter TripNo / VehicleNo");
       return;
    }
	if(inputValue.length < 4){
		sweetAlert("Please enter atleast 4 character in search box and try again");
		return;
	}
	 selectedValue = $('#tripOrVehicleId').val();
	 //console.log("continueselectedvalue",selectedValue);
	 //console.log("Rangeno",rangeId);
	 getListViewDetails("totalOnTripVehicles", rangeId,selectedValue);
     $("#loading-div").show();
	  
	 }

function dateRangeViewClick() {
	$("#tripOrVehicleId").val('');
	$("#selectTripId").modal("show");
	//console.log("triporvehicleno",selectedValue);
}

function getTripDetails(){
	selectedValue = '';
	//console.log("insideskip", rangeId);
	getListViewDetails("totalOnTripVehicles", rangeId,selectedValue);
	$("#loading-div").show();
	
	}


function changeRadioClick(){
	 radioCheckDisable();
	 $("#onTrip").prop("checked", true);
	 range = 0;
	 radioClick(range);
	 }
	 
function  radioCheckDisable(){
	if(rangeId == 7){
	 $("#Weekly").prop("checked", false);
	  }else if(rangeId == 30){
	  $("#Monthy").prop("checked", false);
      } else{
	 $("#dateRange").prop("checked", false); 
	 }
	}
	 
var selectedType = '';

function getCountsBasedOnStatus(type) {
   selectedType = '';
   selectedType = type;
   $('html, body').animate({
      scrollTop: $("#tripDetailsDiv").offset().top - 48
   }, 1000);
   rage = 0;
   $("#onTrip").prop("checked", true);
   tableMain.search('').columns().search('').draw();
   getListViewDetails(type);
   getAllCounts();
   plotVehiclesOnMap(type);

}

function getCountsBasedOnTripTypeStatus(type) {
   mainRowTripType = type ;
   //console.log('maintrip', mainRowTripType);
   $('html, body').animate({
      scrollTop: $("#tripDetailsDiv").offset().top - 48
   }, 1000);
   rage = 0;
   $("#onTrip").prop("checked", true);
   tableMain.search('').columns().search('').draw();
   getListViewDetails(type);
   getAllCounts();
   plotVehiclesOnMap(type);
  }


function viewClicked() {
   $("#loading-div").show();
   getAllCounts();
   getAllMainCounts();
   getListViewDetails("totalOnTripVehicles");
   plotVehiclesOnMap("totalOnTripVehicles");
}

function resetClicked() {
    mainRowTripType = '' ;
   $("#routeName").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   $("#customerName").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   $("#customerType").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   $("#tripType").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   $("#hubWise").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   $("#regionWise").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   $("#hubDirection").multiselect('deselectAll', false)
      .multiselect('updateButtonText');
   getAllCounts();
   getAllMainCounts();
   getListViewDetails("totalOnTripVehicles");
   plotVehiclesOnMap("totalOnTripVehicles");
   getHubNames();
   getWeatherInfoForCities(true);
   //openSmartLockEnvelope();
}

function showLoading() {
   let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';
   $("#enroute").html(fallback);
   $("#enrouteOntime").html(fallback);
   $("#enrouteDelayed").html(fallback);
   $("#ontimeIntransit").html(fallback);
   $("#ontimeLoading").html(fallback);
   $("#ontimeUnloading").html(fallback);
   $("#delayedLessIntransit").html(fallback);
   $("#delayedLessLoading").html(fallback);
   $("#delayedLessUnloading").html(fallback);
   $("#delayedGreaterLoading").html(fallback);
   $("#delayedGreaterUnloading").html(fallback);
   $("#delayedGreaterIntransit").html(fallback);
   $("#loadingDetention").html(fallback);
   $("#unloadingDetention").html(fallback);
   $("#delayedLateDeparture").html(fallback);
   $("#detentionTotal").html(fallback);
   $("#ontimeTotal").html(fallback);
   $("#delayedLessTotal").html(fallback);
   $("#delayedGreaterTotal").html(fallback);
   $("#smartHubMissed").html(fallback);
   $("#customerHubMissed").html(fallback);
   $("#nonCommunicating").html(fallback);
   $("#idle").html(fallback);
   $("#temperatureDeviation").html(fallback);
   $("#containerUnlocked").html(fallback);
   $("#routeDeviationOntime").html(fallback);
   $("#routeDeviationDelayedLess").html(fallback);
   $("#routeDeviationDelayedGreater").html(fallback);
   $("#smartHubDetentionOntime").html(fallback);
   $("#smartHubDetentionDelayedLess").html(fallback);
   $("#smartHubDetentionDelayedGreater").html(fallback);
   $("#unscheduledStoppageOntime").html(fallback);
   $("#unscheduledStoppage").html(fallback);
   $("#unscheduledStoppageDelayedGreater").html(fallback);

}

function showMainLoading() {
   let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';
   $("#totalOnTripVehicles").html(fallback);
   $("#emptyTripVehicles").html(fallback);
   $("#maintenanceTripVehicles").html(fallback);
   $("#customerTripVehicles").html(fallback);
}

function getAllCounts() {
   showLoading();
   window.console.clear();
   let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';
   $.ajax({
      type: "GET",
      url: t4uspringappURL + 'getAllTripCounts',
      datatype: 'json',
      contentType: "application/json",
      data: {
		 customerId: <%=customerId%>,
         systemId: <%=systemId%>,
		 mainTripType: mainRowTripType,
         routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
      },
      success: function (result) {
         tripCount = result.responseBody;
         $("#enroute").html(tripCount.enroute == null ? fallback : tripCount.enroute);
         $("#enrouteOntime").html(tripCount.enrouteOntime == null ? fallback : tripCount.enrouteOntime);
         $("#enrouteDelayed").html(tripCount.enrouteDelayed == null ? fallback : tripCount.enrouteDelayed);
         $("#ontimeIntransit").html(tripCount.ontimeIntransit == null ? fallback : tripCount.ontimeIntransit);
         $("#ontimeLoading").html(tripCount.ontimeLoading == null ? fallback : tripCount.ontimeLoading);
         $("#ontimeUnloading").html(tripCount.ontimeUnloading == null ? fallback : tripCount.ontimeUnloading);
         $("#delayedLessIntransit").html(tripCount.delayedLessIntransit == null ? fallback : tripCount.delayedLessIntransit);
         $("#delayedLessLoading").html(tripCount.delayedLessLoading == null ? fallback : tripCount.delayedLessLoading);
         $("#delayedLessUnloading").html(tripCount.delayedLessUnloading == null ? fallback : tripCount.delayedLessUnloading);
         $("#delayedGreaterLoading").html(tripCount.delayedGreaterLoading == null ? fallback : tripCount.delayedGreaterLoading);
         $("#delayedGreaterUnloading").html(tripCount.delayedGreaterUnloading == null ? fallback : tripCount.delayedGreaterUnloading);
         $("#delayedGreaterIntransit").html(tripCount.delayedGreaterIntransit == null ? fallback : tripCount.delayedGreaterIntransit);
         $("#loadingDetention").html(tripCount.loadingDetention == null ? fallback : tripCount.loadingDetention);
         $("#unloadingDetention").html(tripCount.unloadingDetention == null ? fallback : tripCount.unloadingDetention);
         $("#delayedLateDeparture").html(tripCount.delayedLateDeparture == null ? fallback : tripCount.delayedLateDeparture);
         $("#detentionTotal").html(tripCount.unloadingDetention == null ? fallback : tripCount.unloadingDetention + tripCount.loadingDetention);
         $("#ontimeTotal").html(tripCount.unloadingDetention == null ? fallback : tripCount.ontimeLoading + tripCount.ontimeUnloading + tripCount.ontimeIntransit);
         $("#delayedLessTotal").html(tripCount.unloadingDetention == null ? fallback : tripCount.delayedLessLoading + tripCount.delayedLessUnloading + tripCount.delayedLessIntransit);
         $("#delayedGreaterTotal").html(tripCount.unloadingDetention == null ? fallback : tripCount.delayedGreaterLoading + tripCount.delayedGreaterUnloading + tripCount.delayedGreaterIntransit);

      }
   });

   $.ajax({
      type: "GET",
      url: t4uspringappURL + 'getAllEventCounts',
      datatype: 'json',
      contentType: "application/json",
      data: {
         customerId: <%=customerId%>,
         systemId: <%=systemId%>,
		 mainTripType: mainRowTripType,
         routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
      },
      success: function (result) {
         eventCount = result.responseBody;
         $("#routeDeviationOntime").html(eventCount.routeDeviationOntime == null ? fallback : eventCount.routeDeviationOntime);
         $("#routeDeviationDelayedLess").html(eventCount.routeDeviationDelayedLess == null ? fallback : eventCount.routeDeviationDelayedLess);
         $("#routeDeviationDelayedGreater").html(eventCount.routeDeviationDelayedGreater == null ? fallback : eventCount.routeDeviationDelayedGreater);
         $("#smartHubDetentionOntime").html(eventCount.smartHubDetentionOntime == null ? fallback : eventCount.smartHubDetentionOntime);
         $("#smartHubDetentionDelayedLess").html(eventCount.smartHubDetentionDelayedLess == null ? fallback : eventCount.smartHubDetentionDelayedLess);
         $("#smartHubDetentionDelayedGreater").html(eventCount.smartHubDetentionDelayedGreater == null ? fallback : eventCount.smartHubDetentionDelayedGreater);
         $("#unscheduledStoppageOntime").html(eventCount.unscheduledStoppageOntime == null ? fallback : eventCount.unscheduledStoppageOntime);
         $("#unscheduledStoppage").html(eventCount.unscheduledStoppage == null ? fallback : eventCount.unscheduledStoppage);
         $("#unscheduledStoppageDelayedGreater").html(eventCount.unscheduledStoppageDelayedGreater == null ? fallback : eventCount.unscheduledStoppageDelayedGreater);

      }
   });

   $.ajax({
      type: "GET",
      url: t4uspringappURL + 'getAlertCounts',
      datatype: 'json',
      contentType: "application/json",
      data: {
         customerId: <%=customerId%>,
         systemId: <%=systemId%>,
		 mainTripType: mainRowTripType,
         routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
      },
      success: function (result) {
         alertCount = result.responseBody;
         $("#smartHubMissed").html(alertCount.smartHubMissed == null ? fallback : alertCount.smartHubMissed);
         $("#customerHubMissed").html(alertCount.customerHubMissed == null ? fallback : alertCount.customerHubMissed);
         $("#nonCommunicating").html(alertCount.nonCommunicating == null ? fallback : alertCount.nonCommunicating);
         $("#idle").html(alertCount.idle == null ? fallback : alertCount.idle);
         $("#temperatureDeviation").html(alertCount.temperatureDeviation == null ? fallback : alertCount.temperatureDeviation);
         $("#containerUnlocked").html(alertCount.containerUnlocked == null ? fallback : alertCount.containerUnlocked);
      }
   });
}

function getAllMainCounts() {
	showMainLoading();
   let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';
   $.ajax({
      type: "GET",
      url: t4uspringappURL + 'getMainTripCounts',
      datatype: 'json',
      contentType: "application/json",
      data: {
		 customerId: <%=customerId%>,
         systemId: <%=systemId%>,
		 routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
      },
	  success: function (result) {
         mainTripCount = result.responseBody;
		 $("#emptyTripVehicles").html(mainTripCount.emptyTrip == null ? fallback : mainTripCount.emptyTrip);
		 $("#maintenanceTripVehicles").html(mainTripCount.maintenanceTrip == null ? fallback : mainTripCount.maintenanceTrip);
		 $("#customerTripVehicles").html(mainTripCount.customerTrip == null ? fallback : mainTripCount.customerTrip);
         $("#totalOnTripVehicles").html(mainTripCount.emptyTrip + mainTripCount.maintenanceTrip + mainTripCount.customerTrip);
        }
	});
}


function plotVehiclesOnMap(type) {
   $.ajax({
      url: t4uspringappURL + 'getMapViewDetails',
      datatype: 'json',
      contentType: "application/json",
      data: {
         customerId: <%=customerId%>,
         systemId: <%=systemId%>,
		 mainTripType: mainRowTripType,
         routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString(),
         type: type
      },
      success: function (result) {
         result = result.responseBody;
         if (markerCluster) {
            map.removeLayer(markerCluster);
         }
         markerCluster = L.markerClusterGroup();

         for (var i = 0; i < result.length; i++) {
            if (!result[i].latitude == 0 && !result[i].longitude == 0) {
               plotSingleVehicle(result[i]);
            }
         }
         map.addLayer(markerCluster);
      }
   });


}

function plotSingleVehicle(mapViewResponse) {
   var tempContent = '';
   var humidityContent = '';
   var Humidity;
   var temperatureSensorsDataArray;
   var temperatureSensorNameValue = '';
   var delay = mapViewResponse.delay.split(':')[0];
   if (mapViewResponse.productLine == 'Chiller' || mapViewResponse.productLine == 'Freezer' || mapViewResponse.productLine == 'TCL') {
      temperatureSensorsDataArray = mapViewResponse.temperatureData.split(',');
      for (var i = 0; i < temperatureSensorsDataArray.length; i++) {
         temperatureSensorNameValue = temperatureSensorsDataArray[i].split('=');
         tempContent = tempContent + '<tr><td><b>' + temperatureSensorNameValue[0] + '(°C):</b></td><td>' + temperatureSensorNameValue[1] + '</td></tr>'
      }
   }

   var imageurl;
   if (mapViewResponse.tripStatus == 'ENROUTE PLACEMENT ON TIME' || mapViewResponse.tripStatus == 'ENROUTE PLACEMENT DELAYED') {
      imageurl = '/ApplicationImages/VehicleImages/enroute.svg';
   }
   if (mapViewResponse.tripStatus == 'ON TIME') {
      imageurl = '/ApplicationImages/VehicleImages/ontime.svg';
   }
   if (mapViewResponse.tripStatus == 'DELAYED' && delay < 1) {
      imageurl = '/ApplicationImages/VehicleImages/delayed1hr.svg';
   }
   if (mapViewResponse.tripStatus == 'DELAYED' && delay > 1) {
      imageurl = '/ApplicationImages/VehicleImages/delayed1hr2.svg';
   }
   if (mapViewResponse.tripStatus == 'LOADING DETENTION') {
      imageurl = '/ApplicationImages/VehicleImages/EnroutePlacement.svg';
   }
   if (mapViewResponse.tripStatus == 'UNLOADING DETENTION') {
      imageurl = '/ApplicationImages/VehicleImages/detention.svg';
   }
   if (mapViewResponse.tripStatus == 'DELAYED LATE DEPARTURE') {
      imageurl = '/ApplicationImages/VehicleImages/Pink.svg';
   }
   if (tempContent != '' && (mapViewResponse.tripStatus == 'ENROUTE PLACEMENT ON TIME' || mapViewResponse.tripStatus == 'ENROUTE PLACEMENT DELAYED')) {
      imageurl = '/ApplicationImages/VehicleImages/tempenroute.svg';
   }
   if (tempContent != '' && mapViewResponse.tripStatus == 'ON TIME') {
      imageurl = '/ApplicationImages/VehicleImages/tempontime.svg';
   }
   if (tempContent != '' && mapViewResponse.tripStatus == 'DELAYED' && delay < 1) {
      imageurl = '/ApplicationImages/VehicleImages/tempdelayed1.svg';
   }
   if (tempContent != '' && mapViewResponse.tripStatus == 'DELAYED' && delay > 1) {
      imageurl = '/ApplicationImages/VehicleImages/tempdelayed2.svg';
   }
   if (tempContent != '' && mapViewResponse.tripStatus == 'LOADING DETENTION') {
      imageurl = '/ApplicationImages/VehicleImages/temploading.svg';
   }
   if (tempContent != '' && mapViewResponse.tripStatus == 'UNLOADING DETENTION') {
      imageurl = '/ApplicationImages/VehicleImages/tempunloading.svg';
   }
   if (tempContent != '' && mapViewResponse.tripStatus == 'DELAYED LATE DEPARTURE') {
      imageurl = '/ApplicationImages/VehicleImages/tempPink.svg';
   }
   image = L.icon({
      iconUrl: String(imageurl),
      iconSize: [20, 40], // size of the icon
      popupAnchor: [0, -15]
   });
   var coordinate = mapViewResponse.latitude + ',' + mapViewResponse.longitude;
   var delayFormat = mapViewResponse.delay;
   var content = '<div id="" seamless="seamless" scrolling="no" style="height: 180px;overflow:auto; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
      '<table>' +
      '<tr><td><b>Vehicle No:</b></td><td>' + mapViewResponse.vehicleNo + '</td></tr>' +
      '<tr><td><a href="#" data-toggle="tooltip" title="' + mapViewResponse.tripId + '"><b>Trip Id:</b></a></td><td><a href="#" data-toggle="tooltip" title="' + mapViewResponse.tripId + '">' + mapViewResponse.tripId + '</a></td></tr>' +
      '<tr><td><b>Trip No:</b></td><td>' + mapViewResponse.tripNo + '</td></tr>' +
      '<tr><td><a href="#" data-toggle="tooltip" title="' + mapViewResponse.routeName + '"><b>Route Name:</b></a></td><td><a href="#" data-toggle="tooltip" title="' + mapViewResponse.routeName + '">' + mapViewResponse.routeName + '</a></td></tr>' +
      '<tr><td><b>Route Key:</b></td><td>' + mapViewResponse.routeKey + '</td></tr>' +
      '<tr><td><b>Location:</b></td><td>' + mapViewResponse.location + '</td></tr>' +
      '<tr><td><b>Last Comm:</b></td><td>' + mapViewResponse.lastCommDateTime + '</td></tr>' +
      '<tr><td><b>Customer :</b></td><td>' + mapViewResponse.customerName + '</td></tr>' +
      '<tr><td><b>Delay:</b></td><td>' + mapViewResponse.delay + '</td></tr>' +
      '<tr><td><b>Driver Name:</b></td><td>' + mapViewResponse.driverName + '</td></tr>' +
      '<tr><td><b>Driver Contact:</b></td><td>' + mapViewResponse.driverContact + '</td></tr>' +
      '<tr><td><b>ETA to Next Hub:</b></td><td>' + mapViewResponse.etaToNextHub + '</td></tr>' +
      '<tr><td><b>ETA to Destination:</b></td><td>' + mapViewResponse.etaToDestination + '</td></tr>' +
      '<tr><td><b>LatLong:</b></td><td>' + coordinate + '</td></tr>' +
      '<tr><td><b>Current Stoppage Time(HH.mm) :</b></td><td>' + mapViewResponse.stoppageTime + '</td></tr>' +
      '<tr><td><b>Current Idling Time(HH.mm):</b></td><td>' + mapViewResponse.idleTime + '</td></tr>' +
      '<tr><td><b>Speed(km/h):</b></td><td>' + mapViewResponse.speed + '</td></tr>' +
      tempContent +
      humidityContent +
      '</table>' +
      '</div>';

   marker = new L.Marker(new L.LatLng(mapViewResponse.latitude, mapViewResponse.longitude), {
      icon: image
   });
   marker.bindPopup(content);

   markerCluster.addLayer(marker);
   markerClusterArray.push(marker);

   showWeatherDataForMarker(mapViewResponse.latitude, mapViewResponse.longitude, marker);
}


let tableMain;

function formatDate(date) {
   var d = new Date(date),
      month = '' + (d.getDate()),
      day = '' + (d.getMonth() + 1),
      year = d.getFullYear();

   if (month.length < 2)
      month = '0' + month;
   if (day.length < 2)
      day = '0' + day;

   return [year, month, day].join('-');
}

var buttonCommon = {
   exportOptions: {
      format: {
         body: function (data, row, column, node) {
            if (column === 6 || column === 8 || column === 11) {
               let ret = data.replace('<span title="', '');
               return ret.split('">')[0];
            } else {
               if (column === 0) {
                  return null
               } else {
                  if (column === 3 || column === 4 || column === 6 || column === 8) {
                     return (data != null && data != "" && data != undefined) ? data.split('">')[1].split("</span>")[0] : data;
                  } else {

                     return data;
                  }
               }
            }
         }
      }
   }
};
setTimeout(function () {
   $("#loading-divInitial").hide();
}, 1000);

let listViewResult;
function getListViewDetails(type, range, selectedValue ,initialLoad) {
	window.console.clear();
	//console.log("insidelistview",selectedValue);
	 $('#loading-div').show();
   prev = type;
   $.ajax({
      type: "GET",
      url: t4uspringappURL + 'getListViewDetails',
      datatype: 'json',
      contentType: "application/json",
      data: {
         range: range == null ? 0 : range, //999 - Date Range, 7 -  One Week, 30 - Month
         systemId: <%=systemId%>,
         customerId: <%=customerId%>,
         type: type,
		 mainTripType: mainRowTripType,
		 selectedValue:selectedValue == null ? '' : selectedValue,
         startDate: $("#startDateInput").val() != null ? $("#startDateInput").val().split("/").reverse().join("-") : '',
         endDate: $("#endDateInput").val() != null ? $("#endDateInput").val().split("/").reverse().join("-") : '',
         routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
      },
      success: function (result) {
         result = result.responseBody;
		 console.log("resultsssss",result);
		  listViewResult = result;
         let slNo = 0;
		 let trips = [];
         result.forEach(function (item) {
            let trip = [];
           	let lockUnlockImg;
			let unlockColor;
			lockUnlockImg = item.lockStatus ==="Locked" ? "lock":"unlock";
            slNo++;
			//if(item.lockStatus=="locked"){
            //trip.push("<div style='display:flex'><div class='details-control' id='div" + slNo + "' onclick='expandClick(" + slNo + ")'></div>&nbsp;<span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData(" + slNo + ")'><i class='fas fa-2x fa-info-circle'></i></span><span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData1(" + slNo + ")'><img src="../../Main/images/lock.png"></img></span><div style='padding-left:8px;' id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
            //}else{
			//trip.push("<div style='display:flex'><div class='details-control' id='div" + slNo + "' onclick='expandClick(" + slNo + ")'></div>&nbsp;<span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData(" + slNo + ")'><i class='fas fa-2x fa-info-circle'></i></span><span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData1(" + slNo + ")'><img src="../../Main/images/unlock.png"></img></span><div style='padding-left:8px;' id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
         	//}
			var lockUnlockImage= "<img class='lockUnlockImgId' id='lock"+slNo+"' onclick='displayRowDataLockUnlockSummary(\""+item.vehicleNo+"\","+slNo+",\""+item.tripCreationTime+"\")' style='cursor:pointer;height:20px;margin-top:12px;' src='../../Main/images/"+lockUnlockImg+".png'></img>";
			var lockUnlockImageNoUnlock="<img class='lockUnlockImgId' onclick='displayRowDataUnlockSummary(\""+item.vehicleNo+"\","+slNo+",\""+item.tripCreationTime+"\")' style='cursor:pointer;height:20px;margin-top:12px;' src='../../Main/images/"+lockUnlockImg+".png'></img>";
			var noLockImage="<img class='lockUnlockImgId'  style='height:22px;margin-top:12px;' src='../../Main/images/DeleteLock.png'></img>";
			var noPowerImage="<img class='lockUnlockImgId'  style='height:22px;margin-top:12px;' src='../../Main/images/noPower.png'></img>";;
		
			if (item.lockStatus ===""||item.lockStatus ===null ){
				trip.push("<div style='display:flex'><div class='details-control' id='div" + slNo + "' onclick='expandClick(" + slNo + ")'></div> "+noLockImage+ "&nbsp;&nbsp;<span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData(" + slNo + ")'><i class='fas fa-2x fa-info-circle'></i></span><div style='padding-left:8px;' id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
			}else if(item.lockStatus ==="Power Disconnected"){
				trip.push("<div style='display:flex'><div class='details-control' id='div" + slNo + "' onclick='expandClick(" + slNo + ")'></div> "+noPowerImage+ "&nbsp;&nbsp;<span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData(" + slNo + ")'><i class='fas fa-2x fa-info-circle'></i></span><div style='padding-left:8px;' id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
			}
			else if(((userAuthority === "CT Executive") || ( userAuthority === "CT Admin") || ( userAuthority === "T4u Users")) && (item.lockStatus ==="Locked" )){
			//else if(userAuthority != "CT Executive" || userAuthority != "CT Admin"|| item.lockStatus ==="Unlocked" ){
				trip.push("<div style='display:flex'><div class='details-control' id='div" + slNo + "' onclick='expandClick(" + slNo + ")'></div> "+lockUnlockImage+ "&nbsp;&nbsp;<span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData(" + slNo + ")'><i class='fas fa-2x fa-info-circle'></i></span><div style='padding-left:8px;' id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
			}
			else{
				trip.push("<div style='display:flex'><div class='details-control' id='div" + slNo + "' onclick='expandClick(" + slNo + ")'></div> "+lockUnlockImageNoUnlock+ "&nbsp;&nbsp;<span style='cursor:;padding-top:12px;' id='send" + slNo + "' onclick='displayRowData(" + slNo + ")'><i class='fas fa-2x fa-info-circle'></i></span><div style='padding-left:8px;' id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
			}
   			trip.push(item.tripId);
            trip.push(item.routeId);
            trip.push(item.endDateForMap);
            trip.push(slNo);
            trip.push(item.tripCreationTime);
            trip.push('<span style="cursor:pointer;color:blue;" onClick="showCEDashboard(\'' + item.tripId + '\',\'' + item.vehicleNo + '\',\'' + item.std + '\',\'' + item.endDateForMap + '\',\'' + item.completeStatus + '\',\'' + item.routeId + '\')">' + item.tripNo + '</span>');
            trip.push('<span style="cursor:pointer;color:blue;" onClick="showTripAndAlertDetails(\'' + item.tripId + '\',\'' + item.vehicleNo + '\',\'' + item.std + '\',\'' + item.endDateForMap + '\',\'' + item.completeStatus + '\',\'' + item.routeId + '\')">' + item.vehicleNo + '</span>');
            trip.push(item.customerName);
            trip.push('<span title="' + item.routeName + '">' + item.routeName.substr(0, 25).toUpperCase() + "...</span>");
            trip.push(item.routeKey);
            trip.push('<span title="' + item.location + '">' + item.location.substr(0, 25).toUpperCase() + "...</span>");
            trip.push(item.tripType);
            trip.push(item.tripCategory);
            trip.push('<span title="' + item.shipmentId + '">' + item.shipmentId.substr(0, 25).toUpperCase() + "...</span>");
            trip.push(item.tripCustomerRefId);
            trip.push(item.tripCustomerType);
            trip.push(item.make);
            trip.push(item.vehicleType);
            trip.push((item.driverName == "" || item.driverName == null) ? "" : item.driverName.split("/")[0]);
            trip.push((item.driverNumber == "" || item.driverNumber == null) ? "" : item.driverNumber.split("/")[0]);
            trip.push((item.driverName == "" || item.driverName == null || item.driverName.split("/")[1] == null) ? "" : item.driverName.split("/")[1]);
            trip.push((item.driverNumber == "" || item.driverNumber == null || item.driverNumber.split("/")[1] == null) ? "" : item.driverNumber.split("/")[1]);
            trip.push(item.originCity);
            trip.push(item.destinationCity);
            trip.push(item.stp);
            trip.push(item.atp);
            trip.push(item.placementDelay);
            trip.push(item.loadingDetention);
            trip.push(item.std);
            trip.push(item.atd);
            trip.push(item.delayedDepartureATDwrtSTD);
            trip.push(item.nextTouchPoint);
            trip.push(item.distanceToNextTouchPoint);
            trip.push(item.etaToNextTouchPoint);
            trip.push(item.staWrtStd);
            trip.push(item.staWrtAtd);
            trip.push(item.eta);
            trip.push(item.ata);
            trip.push(item.plannedTransitTime);
            trip.push(item.actualTransitTime);
            if (item.atd == null || item.atd == 0 || item.atd == '') {
               trip.push('00:00:00')
            } else {
               trip.push(item.transitDelay);
            }
            trip.push(item.completeStatus);
            trip.push(item.totalDistance);
            trip.push(item.avgSpeed);
            trip.push(item.endDate); //Trip closure cancellation Datetime
            trip.push(item.cancelledRemarks);
            trip.push(item.unloadingDetention);
            trip.push(item.lastCommunicationStamp);
            trip.push(item.stoppageDuration);
			trip.push((item.lockStatus)==""? "Lock Not Installed": item.lockStatus);
			trip.push(item.trackingTime);
            //trip.push("<div style='display:flex'><div id='weather" + slNo + "' data-lat='" + item.latitude + "' data-lng='" + item.longitude + "'></div>");
			//weatherCall(slNo, item.latitude, item.longitude);
            trips.push({
               ...trip
            });
            count++;
         })

         if (initialLoad) {
            if ($.fn.DataTable.isDataTable("#tripDatatable")) {
               $('#tripDatatable').DataTable().clear().destroy();
            }
            tableMain = $('#tripDatatable').DataTable({
               data: trips,
               paging: true,
               "bLengthChange": true,
               processing: true,
               deferRender: true,
               scrollY: "380px",
               scrollX: true,
               scrollCollapse: true,
               dom: 'Bfrtip',
               pageLength: 50,
               fixedColumns: {
                  leftColumns: 8

               },
               "columnDefs": [{
                     "targets": [1, 2, 3],
                     "visible": false
                  },
                  {
                     "className": "dt-center",
                     "targets": [4]
                  },
                  {
                     "name": "TripCreationTime",
                     "targets": 5
                  },
                  {
                     "name": "Trip_No",
                     "targets": 6
                  },
                  {
                     "name": "vehicleNo",
                     "targets": 7
                  },
                  {
                     "name": "Customer_Name",
                     "targets": 8
                  },
                  {
                     "name": "Route_ID",
                     "targets": 9
                  },
                  {
                     "name": "Route_Key",
                     "targets": 10
                  },
                  {
                     "name": "Location",
                     "targets": 11
                  },
                  {
                     "name": "Trip_Type",
                     "targets": 12
                  },
                  {
                     "name": "Trip_Category",
                     "targets": 13
                  },
                  {
                     "name": "Trip ID",
                     "targets": 14
                  },
                  {
                     "name": "Customer_Reference_ID",
                     "targets": 15
                  },
                  {
                     "name": "Customer_Type",
                     "targets": 16
                  },
                  {
                     "name": "Make_of_Vehicle",
                     "targets": 17
                  },
                  {
                     "name": "Type_of_Vehicle",
                     "targets": 18
                  },
                  {
                     "name": "Driver1_Name",
                     "targets": 19
                  },
                  {
                     "name": "Driver1_Contact",
                     "targets": 20
                  },
                  {
                     "name": "Driver2_Name",
                     "targets": 21
                  },
                  {
                     "name": "Driver2_Contact",
                     "targets": 22
                  },
                  {
                     "name": "Origin_City",
                     "targets": 23
                  },
                  {
                     "name": "Destination_City",
                     "targets": 24
                  },
                  {
                     "name": "STP",
                     "targets": 25
                  },
                  {
                     "name": "ATP",
                     "targets": 26
                  },
                  {
                     "name": "Placement_Delay",
                     "targets": 27
                  },
                  {
                     "name": "Origin_Hub(Loading)_Detention",
                     "targets": 28
                  },
                  {
                     "name": "STD",
                     "targets": 29
                  },
                  {
                     "name": "ATD",
                     "targets": 30
                  },
                  {
                     "name": "Departure Delay wrt STD",
                     "targets": 31
                  },
                  {
                     "name": "Next_Touching_Point",
                     "targets": 32
                  },
                  {
                     "name": "Distance_To_NextHub",
                     "targets": 33
                  },
                  {
                     "name": "ETA_to_next_Touching_Point",
                     "targets": 34
                  },
                  {
                     "name": "STA (WRT STD)",
                     "targets": 35
                  },
                  {
                     "name": "STA (WRT ATD)",
                     "targets": 36
                  },
                  {
                     "name": "ETA",
                     "targets": 37
                  },
                  {
                     "name": "ATA",
                     "targets": 38
                  },
                  {
                     "name": "Planned_Transit_Time",
                     "targets": 39
                  },
                  {
                     "name": "Actual_Transit_Time ",
                     "targets": 40
                  },
                  {
                     "name": "Transit_Delay",
                     "targets": 41
                  },
                  {
                     "name": "Trip_Status",
                     "targets": 42
                  },
                  {
                     "name": "Total_Distance",
                     "targets": 43
                  },
                  {
                     "name": "Average_Speed",
                     "targets": 44
                  },
                  {
                     "name": "Trip_Closure_Date_Time",
                     "targets": 45
                  },
                  {
                     "name": "Reason_For_Cancellation",
                     "targets": 46
                  },
                  {
                     "name": "Destination_hub(Unloading)_Detention",
                     "targets": 47
                  }
               ],
               buttons: [
                  $.extend(true, {}, buttonCommon, {
                     extend: 'excelHtml5',
                     text: 'Quick Export',
                     title: 'Trip Details',
                     className: 'btn btn-primary excelWidth',
                     exportOptions: {
                        columns: ':visible'
                     }
                  })

               ]
            });
            $("#loading-div").hide();
            setColumnsVisibilyBasedOnUserSetting();
           /*  for (var w = 1; w <= slNo; w++) {
			    $('#weather' + w).html("<img style='height: 41px;' src='" + tripsweatherResponse.iconLink + "'>");
			} */

            setTimeout(function () {

               $("#tripDatatable_wrapper .dt-buttons").append('<div style="display:flex;"><input id="legBtn" type="button" class="btn btn-success" value="Leg Wise Export" onclick="exportLegWise()" /><input onclick="showUserTableSetting()" type="button" class="btn btn-success" value="User Settings" /><input type="radio" id="onTrip" name="radOptions" onclick="radioClick(0)"  checked><div class="threePixelPadding">On Trip</div><input type="radio"  name="radOptions" onclick="radioClick(7)" id="Weekly"><div class="threePixelPadding">Weekly</div><input type="radio"  name="radOptions" onclick="radioClick(30)"  id="Monthy"><div class="threePixelPadding">Monthly</div><input type="radio"  name="radOptions" id="dateRange" onclick="radioClick(999)" ><div class="threePixelPadding">Date Range</div><input type="text" style="margin-left:16px;" id="startDateInput"><input type="text"  style="margin-left:16px;" id="endDateInput"><input onclick="dateRangeViewClick()" type="button" class="btn btn-success" id="viewDateRange" value="View" /></div>')
               $("#startDateInput").jqxDateTimeInput({
                  theme: "arctic",
                  formatString: "dd/MM/yyyy",
                  showTimeButton: false,
                  width: '140px',
                  height: '32px'
               });
               $('#startDateInput ').jqxDateTimeInput('setDate', '');
               $("#endDateInput").jqxDateTimeInput({
                  theme: "arctic",
                  formatString: "dd/MM/yyyy",
                  showTimeButton: false,
                  width: '140px',
                  height: '32px'
               });
               $('#endDateInput ').jqxDateTimeInput('setDate', '');
               $("#startDateInput").hide();
               $('#endDateInput ').hide();
               $("#viewDateRange").hide();
               $("#loading-divInitial").hide();
               $('html, body').animate({
                  scrollTop: $("#contentChild").offset().top - 60
               }, 1000);

            }, 1000);
         } else {
            $('#tripDatatable').DataTable().clear();
            tableMain.rows.add(trips);
            tableMain.draw();
            setColumnsVisibilyBasedOnUserSetting();
            $("#loading-div").hide();
         }
      }
   });
}


function geocodeLatLng(slno,lat, lon) {
	fetch('https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?prox=' + lat + "," + lon + ',250&mode=retrieveAddresses&maxresults=1&gen=9&app_id=' + '<%=appKey%>' + '&app_code=' + '<%=appCode%>').then(function (response) {
		resp = response.json();
		return resp;
	}).then(function (json) {
		//console.log('geocode:: ',json);
		if ('error' in json) {
			//alert("address not found");
		}
		district = "";
		var cntry = json.Response.View[0].Result[0].Location.Address.AdditionalData[0].value.replace(/[0-9]/g, '');
		var stat = json.Response.View[0].Result[0].Location.Address.AdditionalData[1].value.replace(/[0-9]/g, '');
		district = json.Response.View[0].Result[0].Location.Address.AdditionalData[2].value.replace(/[0-9]/g, '');
		var cty = "";
		if ('City' in json.Response.View[0].Result[0].Location.Address) {
			cty = json.Response.View[0].Result[0].Location.Address.City.replace(/[0-9]/g, '')
		} else if ('village' in json.address) {
			cty = json.address.village.replace(/[0-9]/g, '')
		} else if ('hamlet' in json.address) {
			cty = json.address.hamlet.replace(/[0-9]/g, '')
		} else if ('town' in json.address) {
			cty = json.address.town.replace(/[0-9]/g, '')
		} else {
			cty = "";
		}
		var locationSmartLock = cty+','+district+','+stat+','+cntry
		//$("#loc"+slno).html(locationSmartLock);
		$("#rowsUnlock"+slno).html("<span title='"+locationSmartLock+"'>"+locationSmartLock.substr(0, 10)+"...</span>");
		
		
		
		//$("#addressDiv").html("<div class='toolTipDiv' style='font-size: 13px;display: flex;width: 330px;margin-left: -16px;'>"+address+"</div>");
		
	//$("#ulRowDataSummary").appendTo('<li class="second"><div class="row"><div class="col-lg-4"><strong>Current Location: </strong></div><div class="col-lg-8">' + locationSmartLock + '</div></div></li>');
	return locationSmartLock;
	})
}

let weatherDet = [];
function weatherCall(w,lat,lng) {
   $.ajax({
      url: 'https://weather.api.here.com/weather/1.0/report.json',
      type: 'GET',
      dataType: 'jsonp',
      jsonp: 'jsonpcallback',
      data: {
         product: 'observation',
         latitude: lat,
         longitude: lng,
         app_id: '<%=appKey%>',
         app_code: '<%=appCode%>',
         oneobservation: 'true'
      },
      success: function (data) {
         weatherResponse = data.observations.location[0].observation[0];

		 for(var x=0; x <trips.length; x++)
		 {
			 if(trips[x].slNo == x)
			 {
				 trips[x].weatherLink = weatherResponse.iconLink;
			 }
		 }
      }
   });
}

/*$('#tripDatatable').on('page.dt', function () {
	for (var w = 1; w <= 500; w++) {
				   $('#weather' + w).html("<img style='height: 41px;' src='" + weatherDet[w].iconLink + "'>");
				}} );*/

function exportLegWise() {
   $.ajax({
      type: "POST",
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getLegWiseSLAReport',
      data: {
         range: rage,
         startDate: $("#startDateInput").val() != null ? $("#startDateInput").val().split("/").reverse().join("-") : '',
         endDate: $("#endDateInput").val() != null ? $("#endDateInput").val().split("/").reverse().join("-") : '',
         customerId: <%=customerId%>,
         selectedType: selectedType,
         routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
      },
      success: function (responseText) {
         if (responseText != "Failed to Download Report") {
            window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
         } else {
            sweetAlert("Failure in downloading");
         }
      }
   });

}
// Add event listener for opening and closing details
function expandClick(slNo) {
   var tr = $("#div" + slNo).closest('tr');
   var row = tableMain.row(tr);
   tr.addClass('details');
   getLegData(row.data());
}

let legDetails;

function getLegData(d) {
   var a;
   $.ajax({
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getLegDetailsForTrip',
      "data": {
         tripId: d[1],
         tripStatus: d[41],
         delay: d[30]
      },
      success: function (result) {
         result = JSON.parse(result);
         legDetails = result["legDetails"];
         $("#legDetailsModal").modal("show");
         $("#modalTripNo").html(d[6]);
         $("#legDetailsModalBody").html(format());
      }
   });
}

/* Formatting function for row details - modify as you need */
function format() {
   var tbody = "";

   var legName, Driver1, Driver2, STD, STA, ATD, ATA, ETA, driver1Contact, driver2Contact, Source, Destination, DepartureDelaywrtSTD, PlannedTransitTime, STAwrtATD, ActualTransitTime, TransitDelay, LegDistance, Tripstatus;

   if (legDetails.length > 0) {
      for (var i = 0; i < legDetails.length; i++) {

         if (legDetails[i].LegName === '' || legDetails[i].LegName === 'NA') {
            legName = '<td bgcolor=white>' + legDetails[i].LegName + '</td>';
         } else {
            legName = '<td>' + legDetails[i].LegName + '</td>';
         }
         if (legDetails[i].Driver1 === '' || legDetails[i].Driver1 === 'NA') {
            Driver1 = '<td bgcolor=white>' + legDetails[i].Driver1 + '</td>';
         } else {
            Driver1 = '<td>' + legDetails[i].Driver1 + '</td>';
         }
         if (legDetails[i].Driver2 === '' || legDetails[i].Driver2 === 'NA') {
            Driver2 = '<td bgcolor=white>' + legDetails[i].Driver2 + '</td>';
         } else {
            Driver2 = '<td>' + legDetails[i].Driver2 + '</td>';
         }
         if (legDetails[i].STD === '' || legDetails[i].STD === 'NA') {
            STD = '<td bgcolor=white>' + legDetails[i].STD + '</td>';
         } else {
            STD = '<td>' + legDetails[i].STD + '</td>';
         }
         if (legDetails[i].STA === '' || legDetails[i].STA === 'NA') {
            STA = '<td bgcolor=white>' + legDetails[i].STA + '</td>';
         } else {
            STA = '<td>' + legDetails[i].STA + '</td>';
         }
         if (legDetails[i].ATD === '' || legDetails[i].ATD === 'NA') {
            ATD = '<td bgcolor=white>' + legDetails[i].ATD + '</td>';
         } else {
            ATD = '<td>' + legDetails[i].ATD + '</td>';
         }
         if (legDetails[i].ATA === '' || legDetails[i].ATA === 'NA') {
            ATA = '<td bgcolor=white>' + legDetails[i].ATA + '</td>';
         } else {
            ATA = '<td>' + legDetails[i].ATA + '</td>';
         }
         if (legDetails[i].ETA === '' || legDetails[i].ETA === 'NA') {
            ETA = '<td bgcolor=white>' + legDetails[i].ETA + '</td>';
         } else {
            ETA = '<td>' + legDetails[i].ETA + '</td>';
         }

         if (legDetails[i].driver1Contact === '' || legDetails[i].driver1Contact === 'NA') {
            driver1Contact = '<td bgcolor=white>' + legDetails[i].driver1Contact + '</td>';
         } else {
            driver1Contact = '<td>' + legDetails[i].driver1Contact + '</td>';
         }

         if (legDetails[i].driver2Contact === '' || legDetails[i].driver2Contact === 'NA') {
            driver2Contact = '<td bgcolor=white>' + legDetails[i].driver2Contact + '</td>';
         } else {
            driver2Contact = '<td>' + legDetails[i].driver2Contact + '</td>';
         }

         if (legDetails[i].Source === '' || legDetails[i].Source === 'NA') {
            Source = '<td bgcolor=white>' + legDetails[i].Source + '</td>';
         } else {
            Source = '<td>' + legDetails[i].Source + '</td>';
         }

         if (legDetails[i].Destination === '' || legDetails[i].Destination === 'NA') {
            Destination = '<td bgcolor=white>' + legDetails[i].Destination + '</td>';
         } else {
            Destination = '<td>' + legDetails[i].Destination + '</td>';
         }

         if (legDetails[i].PlannedTransitTime === '' || legDetails[i].PlannedTransitTime === 'NA') {
            PlannedTransitTime = '<td bgcolor=white>' + legDetails[i].PlannedTransitTime + '</td>';
         } else {
            PlannedTransitTime = '<td>' + legDetails[i].PlannedTransitTime + '</td>';
         }

         if (legDetails[i].STAwrtATD === '' || legDetails[i].STAwrtATD === 'NA' || legDetails[i].STAwrtATD === 'undefined') {
            STAwrtATD = '<td bgcolor=white>' + legDetails[i].STAwrtATD + '</td>';
         } else {
            STAwrtATD = '<td>' + legDetails[i].STAwrtATD + '</td>';
         }

         if (legDetails[i].ActualTransitTime === '' || legDetails[i].ActualTransitTime === 'NA') {
            ActualTransitTime = '<td bgcolor=white>' + legDetails[i].ActualTransitTime + '</td>';
         } else {
            ActualTransitTime = '<td>' + legDetails[i].ActualTransitTime + '</td>';
         }

         if (legDetails[i].TransitDelay === '' || legDetails[i].TransitDelay === 'NA') {
            TransitDelay = '<td bgcolor=white>' + legDetails[i].TransitDelay + '</td>';
         } else {
            TransitDelay = '<td>' + legDetails[i].TransitDelay + '</td>';
         }

         if (legDetails[i].LegDistance === '' || legDetails[i].LegDistance === 'NA') {
            LegDistance = '<td bgcolor=white>' + legDetails[i].LegDistance + '</td>';
         } else {
            LegDistance = '<td>' + legDetails[i].LegDistance + '</td>';
         }

         if (legDetails[i].DepartureDelaywrtSTD === '' || legDetails[i].DepartureDelaywrtSTD === 'NA') {
            DepartureDelaywrtSTD = '<td bgcolor=white>' + legDetails[i].DepartureDelaywrtSTD + '</td>';
         } else {
            DepartureDelaywrtSTD = '<td>' + legDetails[i].DepartureDelaywrtSTD + '</td>';
         }

         if (legDetails[i].Tripstatus === '' || legDetails[i].Tripstatus === 'NA') {
            Tripstatus = '<td bgcolor=white>' + legDetails[i].Tripstatus + '</td>';
         } else {
            Tripstatus = '<td>' + legDetails[i].Tripstatus + '</td>';
         }

         var row = "";
         row += '<tr>'
         row += legName;
         row += Driver1;
         row += driver1Contact;
         row += Driver2;
         row += driver2Contact;
         row += Source;
         row += Destination;
         row += STD;
         row += ATD;
         row += DepartureDelaywrtSTD;
         row += PlannedTransitTime;
         row += STAwrtATD;
         row += ETA;
         row += ATA;
         row += ActualTransitTime;
         row += TransitDelay;
         row += LegDistance;


         row += '</tr>';
         tbody += row;
      }
      a = '<div style="overflow-x:auto;width:100%">' +
         '<table class="table table-bordered" >' +
         ' <thead>' +
         '<tr">' +
         '<th>Leg ID</th>' +
         '<th>Driver 1 Name</th>' +
         '<th>Driver 1 Contact</th>' +
         '<th>Driver 2 Name</th>' +
         '<th>Driver 2 Contact</th>' +
         '<th>Origin</th>' +
         '<th>Destination</th>' +
         '<th>STD</th>' +
         '<th>ATD</th>' +
         '<th>Departure Delay wrt STD</th>' +
         '<th>Planned Transit Time (incl. planned stoppages)</th>' +
         '<th>STA wrt ATD</th>' +
         '<th>ETA</th>' +
         '<th>ATA</th>' +
         '<th>Actual Transit Time (incl. planned and unplanned stoppages)</th>' +
         '<th>Transit Delay</th>' +
         '<th>Leg Distance (Kms)</th>' +
         '</tr>' +
         '</thead>' +
         '<tbody id="tbodyId">' + tbody + '</tbody>' +
         '</table>' +
         '</div>';
   } else {
      var row = "";
      row += '<tr>'
      row += '<td colspan="14"><b>No Records Found for this trip</b></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '<td></td>';
      row += '</tr>';
      tbody += row;

      a = '<div style="overflow-x:auto;width:100%">' +
         '<table  cellpadding="5" cellspacing="0" border="0">' +
         ' <thead>' +
         '</thead>' +
         '<tbody id="tbodyId">' + tbody + '</tbody>' +
         '</table>' +
         '</div>';
   }
   return a;
}

$('#regionWise').change(function () {
   getHubNames(true);
})

function setColumnsVisibilyBasedOnUserSetting() {
   hiddenColumns = [];
   var pageName = "SLA_DASHBOARD";
   $.ajax({
      url: "<%=request.getContextPath()%>/CommonAction.do?param=getListViewColumnSetting",
      data: {
         pageName: pageName
      },
      "dataSrc": "columnSettingsRoot",
      success: function (result) {
         var checkstatus = "unchecked";
         results = JSON.parse(result);

         for (var i = 0; i < results['columnSettingsRoot'].length; i++) {
            if (results['columnSettingsRoot'][i].visibility == 'false') {
               tableMain.column(results['columnSettingsRoot'][i].columnName + ':name').visible(false);
            }
         }
      }
   });
}

function showUserTableSetting() {
   $('#columnSetting').modal('show');
   $('#sortable').empty();
   var pageName = "SLA_DASHBOARD";
   $.ajax({
      url: "<%=request.getContextPath()%>/CommonAction.do?param=getListViewColumnSetting",
      data: {
         pageName: pageName
      },
      "dataSrc": "columnSettingsRoot",
      success: function (result) {
         var checkstatus = "unchecked";
         results = JSON.parse(result);
         if ((Number(results['columnSettingsRoot'].length) == Number(0))) {
            setDefaultUserColumnSetting();
            columnSettingAddOrModify = "ADD";
         } else {
            columnSettingAddOrModify = "UPDATE";
            for (var i = 0; i < results['columnSettingsRoot'].length; i++) {
               if (results['columnSettingsRoot'][i].visibility == 'true') {
                  checkstatus = "checked";
               } else {
                  checkstatus = "unchecked";
               }
               $("#sortable").append("<li class='second'><div class='checkbox'><input name='columnSetting' type='checkbox' " + checkstatus + " value='" + results['columnSettingsRoot'][i].id + "'/></div>" + results['columnSettingsRoot'][i].columnName + "</li>");
            }
         }
      }
   });
}

function createOrUpdateListViewColumnSetting() {
   if (columnSettingAddOrModify == "ADD") {
      createListViewColumnSetting()
   } else if ((columnSettingAddOrModify == "UPDATE")) {
      updateListViewColumnSetting();
   }
}

function createListViewColumnSetting() {
   var jsonObj = [];
   var pageName = "SLA_DASHBOARD";
   $("input[name=columnSetting]").each(function () {
      item = {}
      item["columnName"] = $(this).val();
      item["visibility"] = this.checked;
      jsonObj.push(item);
   });
   document.getElementById("columnSettingSave").disabled = true;
   var columnSettings = JSON.stringify(jsonObj);
   $.ajax({
      url: "<%=request.getContextPath()%>/CommonAction.do?param=createListViewColumnSetting",
      data: {
         columnSettings: columnSettings,
         pageName: pageName
      },
      success: function (result) {
         document.getElementById("columnSettingSave").disabled = false;
         setTimeout(function () {
            sweetAlert("Saved Successfully");
            $('#columnSetting').modal('hide');
         }, 1000);
         getListViewDetails("");
      }
   });
}

function updateListViewColumnSetting() {
   var jsonObj = [];
   $("input[name=columnSetting]").each(function () {
      item = {}
      item["id"] = $(this).val();
      item["visibility"] = this.checked;
      jsonObj.push(item);
   });
   document.getElementById("columnSettingSave").disabled = true;
   var columnSettings = JSON.stringify(jsonObj);
   $.ajax({
      url: "<%=request.getContextPath()%>/CommonAction.do?param=updateListViewColumnSetting",
      data: {
         columnSettings: columnSettings
      },
      success: function (result) {
         document.getElementById("columnSettingSave").disabled = false;
         setTimeout(function () {
            sweetAlert("Saved Successfully");
            $('#columnSetting').modal('hide');
         }, 1000);
         getListViewDetails("");
      }
   });
}


function setDefaultUserColumnSetting() {
   var columnsDefns = table.settings().init().columns;
   table.columns().every(function (index) {
      if (columnsDefns[index].name != undefined) {
         columns.push(columnsDefns[index].name);
      }
   })
   for (var i = 0; i < columns.length; i++) {
      checkstatus = "checked";
      $("#sortable").append("<li class='second'><div class='checkbox'><input name='columnSetting' type='checkbox' " + checkstatus + " value='" + columns[i] + "' /></div>" + columns[i] + "</li>");
   }
}

$('#legbtn').click(function () {
   var startDateRange = document.getElementById("startDateInput").value;
   startDateRange = startDateRange.split("/").reverse().join("-");

   var endDateRange = document.getElementById("endDateInput").value;
   endDateRange = endDateRange.split("/").reverse().join("-");
   var data = table.rows().data();
   if (data.length) {

      document.getElementById("page-loader").style.display = "block";
      $.ajax({
         url: '<%=request.getContextPath()%>/LegDetailsExportAction.do?param=createLegExcel',
         data: {
            groupId: 0,
            unit: '<%=unit%>',
            status: "",
            startDateRange: startDateRange,
            endDateRange: endDateRange,
            routeId: $("#routeName").val().length === routeNameLength ? 'ALL' : $("#routeName").val().toString(),
            tripCustId: $("#customerName").val().length === custNameLength ? 'ALL' : $("#customerName").val().toString(),
            custType: $("#customerType").val().length === custTypeLenght ? 'ALL' : $("#customerType").val().toString(),
            tripType: $("#tripType").val().length === tripTypeLength ? 'ALL' : $("#tripType").val().toString(),
            hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
            hubDirection: $("#hubDirection").val().length === hubDirectionLength ? 'ALL' : $("#hubDirection").val().toString()
         },
         success: function (responseText) {
            window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
            document.getElementById("page-loader").style.display = "none";
			window.console.clear();
			//console.log(Array(100).join("\n"));
         }
      });
   } else {
      sweetAlert("No Data Found to Export");
   }
});

function displayRowData(slNo) {

   let tr = $("#send" + slNo).closest('tr');
   let d = tableMain.row(tr).data();
   $("#rowDataDisplay").modal("show");
   $("#ulRowData").html("");
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Created Time: </strong></div><div class="col-lg-8">' + d[5] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Trip No.: </strong></div><div class="col-lg-8">' + d[6] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Vehicle No.: </strong></div><div class="col-lg-8">' + d[7] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Customer Name: </strong></div><div class="col-lg-8">' + d[8] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Route ID: </strong></div><div class="col-lg-8">' + d[9] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Route Key: </strong></div><div class="col-lg-8">' + d[10] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Current Location: </strong></div><div class="col-lg-8">' + d[11] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Trip Type: </strong></div><div class="col-lg-8">' + d[12] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Trip Category: </strong></div><div class="col-lg-8">' + d[13] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Trip ID: </strong></div><div class="col-lg-8">' + d[14] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Customer Reference ID: </strong></div><div class="col-lg-8">' + d[15] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Customer Type: </strong></div><div class="col-lg-8">' + d[16] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Make of Vehicle: </strong></div><div class="col-lg-8">' + d[17] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Type of Vehicle: </strong></div><div class="col-lg-8">' + d[18] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Driver 1 Name: </strong></div><div class="col-lg-8">' + d[19] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Driver 1 Contact: </strong></div><div class="col-lg-8">' + d[20] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Driver 2 Name: </strong></div><div class="col-lg-8">' + d[21] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Driver 2 Contact: </strong></div><div class="col-lg-8">' + d[22] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Origin City: </strong></div><div class="col-lg-8">' + d[23] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Destination City: </strong></div><div class="col-lg-8">' + d[24] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>STP: </strong></div><div class="col-lg-8">' + d[25] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>ATP: </strong></div><div class="col-lg-8">' + d[26] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Placement Delay: </strong></div><div class="col-lg-8">' + d[27] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Loading Detention(HH:mm:ss): </strong></div><div class="col-lg-8">' + d[28] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>STD: </strong></div><div class="col-lg-8">' + d[29] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>ATD: </strong></div><div class="col-lg-8">' + d[30] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Departure Delay wrt STD: </strong></div><div class="col-lg-8">' + d[31] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Next Touch Point: </strong></div><div class="col-lg-8">' + d[32] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Distance to Next Touch Point(km): </strong></div><div class="col-lg-8">' + d[33] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>ETA to Next Touch Point: </strong></div><div class="col-lg-8">' + d[34] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>STA wrt STD: </strong></div><div class="col-lg-8">' + d[35] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>STA wrt ATD: </strong></div><div class="col-lg-8">' + d[36] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>ETA: </strong></div><div class="col-lg-8">' + d[37] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>ATA: </strong></div><div class="col-lg-8">' + d[38] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Planned TT - incl. SH Stoppages: </strong></div><div class="col-lg-8">' + d[39] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Actual TT - incl. SH Stoppages: </strong></div><div class="col-lg-8">' + d[40] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Transit Delay(HH:mm:ss): </strong></div><div class="col-lg-8">' + d[41] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Trip Status: </strong></div><div class="col-lg-8">' + d[42] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Distance(km): </strong></div><div class="col-lg-8">' + d[43] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Avg. Speed(kmph): </strong></div><div class="col-lg-8">' + d[44] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Close/Cancellation Time: </strong></div><div class="col-lg-8">' + d[45] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Reason for Cancellation: </strong></div><div class="col-lg-8">' + d[46] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Unloading Detention(HH:mm:ss): </strong></div><div class="col-lg-8">' + d[47] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Last Comm: </strong></div><div class="col-lg-8">' + d[48] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Vehicle Stoppage: </strong></div><div class="col-lg-8">' + d[49] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Lock Status: </strong></div><div class="col-lg-8">' + d[50] + '</div></div></li>');
   $("#ulRowData").append('<li class="second"><div class="row"><div class="col-lg-4"><strong>Tracking Time: </strong></div><div class="col-lg-8">' + d[51] + '</div></div></li>');
}
var vehicleNoChosenForLock = "";
let slNoChosenForLock = "";
let fromdate="";
let todate="";
let tripIdForLock="";
let tripCreationTimeForLock="";
let driverNames="";
let driverContacts="";
let dataItemNeededForUnlockSuccess;
let dataItemNeededForUnlockHistory;
let historyDataForSmartLockList;
let rowsUnlock = [];
function displayRowDataLockUnlockSummary(vehicleNo,slNo,tripCreationTime) {
	//console.log(tripCreationTime);
	 if ($.fn.DataTable.isDataTable("#activityReportTable")) {
        $('#activityReportTable').DataTable().clear().destroy();

    }
	
	listViewResult.forEach(function (item) {
		if(item.vehicleNo === vehicleNo){
			dataItemNeededForUnlockSuccess = item;
		}
	});
   vehicleNoChosenForLock = vehicleNo;
   slNoChosenForLock = slNo;
   fromdate=tripCreationTime;
 
   let tr = $("#send" + slNo).closest('tr');
   let d = tableMain.row(tr).data();
   $("#unlockBtnId").show();
   $("#lockSummary").modal("show");
   $("#ulRowDataSummary").html("");
   $("#ulRowDataSummary").append('<li class="second"><div class="row"><div class="col-lg-6"><strong>Trip No &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; :&nbsp; &nbsp;  ' + d[6] + '</strong></div><div class="col-lg-6"><strong>Trip Creation Time&nbsp; &nbsp;&nbsp; &nbsp;: &nbsp; &nbsp; ' + d[5] + '</strong></div></div></li>');
   $("#ulRowDataSummary").append('<li class="second"><div class="row"><div class="col-lg-6"><strong>Lock Status &nbsp;&nbsp;&nbsp;: &nbsp; &nbsp;' + d[50] + '</strong></div><div class="col-lg-6"><strong>Tracking Time&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; : &nbsp; &nbsp;' + d[51] + '</strong></div></div></li>');
   $("#loading-div").show();
   $.ajax({
	 type: "GET",
       url: t4uspringappURL + 'lockunlockhistory?VNo='+vehicleNoChosenForLock+'&fromdate='+fromdate,
       datatype: 'json',
       contentType: "application/json",
       success: function (result) {
		 //console.log("Returned", result);
		 result = result.responseBody;
		result = result.includes("No records found")? [] : JSON.parse(result);
		 historyDataForSmartLockList=result;
		let rowsUnlock = [];
        //console.log("result of lockunlockhistory::"+result);

		let slno = 1;
		
        $.each(result.returnmessage, function(i, item) {
                let row = {
					"0": slno,
                    "1": item.VehicleNumber==="" ? vehicleNoChosenForLock:item.VehicleNumber, 
                    "2": item.AlartDatetime,
                    "3": item.UnlockTime,
                    "4": item.LockedTime,
                    "5": item.UnlockedDuration,
					"6" : item.FirstGateOpenedTime,	
					"7": item.FirstGateOpenedTime,
					"8": item.lat,
					"9": item.lng,
					"10": "<span id='rowsUnlock"+slno+"' lat='"+item.lat+"' lng='"+item.lng+"'></span>"
			}
			
			
                rowsUnlock.push(row);
				
				slno++;			
            })

	setTimeout(function() {	
	
 
    let tableN = $('#activityReportTable').DataTable({
        "scrollY": "280px",
        "scrollX": true,
        paging: false,
       
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'excel',
                text: 'Export to Excel',
                title: 'Lock/Unlock Summary Report  ',
                className: 'btn btn-primary',
                exportOptions: {
                    columns: ':visible'
                }
            }
        ]
    });
	
	if(rowsUnlock.length > 0){
    tableN.rows.add(rowsUnlock).draw();
	for(var t = 1; t <= rowsUnlock.length; t++)
	{
		//You can test
		geocodeLatLng(t,$("#rowsUnlock"+t).attr("lat"),$("#rowsUnlock"+t).attr("lng"));	
	}
	}
	$("#loading-div").hide();
	},3000);
	}
	});
}
function displayAlertMessage(){
	$("#unlockPopUp").modal("show");
}
function displayRowDataUnlockSummary(vehicleNo,slNo,tripCreationTime) {
		displayRowDataLockUnlockSummary(vehicleNo,slNo,tripCreationTime);
		//$("#unlockBtnId").hide();
		document.getElementById("unlockBtnId").disabled = true;
}
function displayRowDataSummary() {
	//$("#unlockPopUp").modal("show");
	$.ajax({
	type: "GET",
      url: t4uspringappURL + 'vehicleinsidehub?vehicleNo='+vehicleNoChosenForLock,
      datatype: 'json',
      contentType: "application/json",
      success: function (result) {
		  //console.log("Retunred", result);
           result = result.responseBody;
			if(result)
			{
				let tr = $("#send" + slNoChosenForLock).closest('tr');
                let d = tableMain.row(tr).data();
				unlockSuccess();
			}
			else{
				displayUnlockPopUp(slNoChosenForLock);
			}
	  }
	});
 }
function displayUnlockPopUp(slNo) {
   let tr = $("#send" + slNo).closest('tr');
   let d = tableMain.row(tr).data();
   $("#locationCheckId").modal("show");
   
}
function unlockSuccess(id) {
   	if(historyDataForSmartLockList.length > 0){
			historyDataForSmartLockList.returnmessage.forEach(function(item) {
					if(item.VehicleNumber === vehicleNoChosenForLock){
						dataItemNeededForUnlockHistory = item;
					}
            })			
		}
		else{
			dataItemNeededForUnlockHistory="";
		}
	
  $.ajax({
	type: "GET",
      url: t4uspringappURL + 'unlockcontainer?VehicleNo='+vehicleNoChosenForLock,
       datatype: 'json',
       contentType: "application/json",
       success: function (result) {
		  unlockresult=JSON.parse(result.responseBody);
		  //console.log("result for unlock response",unlockresult);
			if(result.success === "1"){
			   let tr = $("#send" + slNo).closest('tr');
			   let d = tableMain.row(tr).data();
			   $("#vehicleSuccessId").modal("show");
			   //$("#unlockBtnId").hide();
			   //trip.push(item.lockStatus==="Unlocked");
			   $("#lock"+ slNoChosenForLock).attr("src","../../Main/images/unlock.png");
			
			} else{
				unlockFailure(slNoChosenForLock); 
			}

   $.ajax({
			type: "POST",
			url: t4uspringappURL + 'storeintoaudittable',
			contentType: "application/json",
			
			data:JSON.stringify({
					vehicleNo: dataItemNeededForUnlockSuccess.vehicleNo,
					tripNo: dataItemNeededForUnlockSuccess.tripNo,
					customerName : dataItemNeededForUnlockSuccess.customerName,
					unlockStatus: unlockresult.returnmessage[0].status,
					requestedCTUser:userName,
					driverName : dataItemNeededForUnlockSuccess.driverName,
					driverContact : dataItemNeededForUnlockSuccess.driverNumber,
					unlockRequestDateTime : dataItemNeededForUnlockHistory === "" || dataItemNeededForUnlockHistory.UnlockTime===""?"":dataItemNeededForUnlockHistory.UnlockTime,
					location : dataItemNeededForUnlockSuccess.location
					
			}),
				success: function (result) {
					  //sweetAlert("Succesfull");
				}	  
			});
				//console.log("result::Fr audit",result);
				
	  }
 });
}
function unlockFailure(slNo) {
   let tr = $("#send" + slNo).closest('tr');
   let d = tableMain.row(tr).data();
   $("#vehicleFailureId").modal("show");
   
}

function showTripAndAlertDetails(tripNo, vehicleNo, startDate, endDate, status, routeId) {
   var startDate = startDate.replace(/-/g, " ");
   var endDate = endDate.replace(/-/g, " ");
   var actualDate = "";
   window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
}

function showCEDashboard(tripId, status) {
   if (tripId == null || tripId == "") {
      sweetAlert("Invalid Trip Id");
      return;
   }
   window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/CEDashboard.jsp?tripId=" + tripId, '_blank');
}

function openEnvelopeModal() {
   loadOnTripVehicleActionDetailsTable();
}

function loadOnTripVehicleActionDetailsTable() {
   if ($.fn.DataTable.isDataTable('#onTripVehicleDetails')) {
      $('#onTripVehicleDetails').DataTable().clear().destroy();
   }
   $.ajax({
      type: "POST",
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getOnTripVehiclesStoppageActionDetails',
      "data": {},
      success: function (result) {
         result = JSON.parse(result).tripVehiclesStoppageAction;
         if ($.fn.DataTable.isDataTable('#onTripVehicleDetails')) {
            $('#onTripVehicleDetails').DataTable().clear().destroy();
         }
         var rows = new Array();

         $('#envelopeModal').modal('show');
         if (result != "") {
            $.each(result, function (i, item) {

               var row = {
                  "0": item.slNo,
                  "1": item.id,
                  "2": item.lrNumber,
                  "3": item.assetNumber,
                  "4": item.tripCustomerId,
                  "5": item.tripCustomerName,
                  "6": item.duration,
                  "7": item.stoppageBegin,
                  "8": item.viewMapIndex,
                  "9": item.shipmentId,
                  "10": item.routeName,
                  "11": item.latitude,
                  "12": item.longitude,
                  "13": item.location,
                  "14": item.status,
                  "15": item.tripId
               }
               rows.push(row);
            });
         } else {
            var row = {
               "0": "No Data available"
            }
         }
         onTripVehTable = $('#onTripVehicleDetails').DataTable({
            "scrollY": "280px",
            "scrollX": true,
            paging: true,
            "serverSide": false,
            "oLanguage": {
               "sEmptyTable": "No data available"
            },
            "dom": 'Bfrtip',
            "processing": true,
            "buttons": [{
               extend: 'excel',
               text: 'Export to Excel',
               className: 'btn btn-primary excelWidth'
            }],
         });
         onTripVehTable.rows.add(rows).draw();
         onTripVehTable.columns([1, 4, 15]).visible(false);
      }
   });
}
let dataItemNeededForSmartLockPopUp;
function openSmartLockEnvelope() {

   $("#loading-div").show();
   $.ajax({
      type: "GET",
      url: t4uspringappURL + 'smartlockpopup',
	  contentType: "application/json",
      "data": {
		 customerId: <%=customerId%>,
         systemId: <%=systemId%>,
		 routeId: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'ALL' : $("#routeName").val().toString(),
         tripCustId: $("#customerName").val().length === custNameLength || $("#customerName").val() == '' ? 'ALL' : $("#customerName").val().toString(),
         custType: $("#customerType").val().length === custTypeLenght || $("#customerType").val() == '' ? 'ALL' : $("#customerType").val().toString(),
         tripType: $("#tripType").val().length === tripTypeLength || $("#tripType").val() == '' ? 'ALL' : $("#tripType").val().toString(),
         hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
         hubDirection: $("#hubDirection").val().length === hubDirectionLength || $("#hubDirection").val() == '' ? 'ALL' : $("#hubDirection").val().toString()
		  
	  },
      success: function (result) {
		 result = result.responseBody;
		 //console.log("result of lockpopup:: ",result);
         
		 let slNum = 1;
         let rows = [];
		 $('#lockEnvelopeModal').modal('show');
         if (result != "") {
            $.each(result, function (i, item) {
			var row = {
				  "0": slNum,
                  "1": item.vehicleNo,
                  "2": '<span style="cursor:pointer;color:blue;" onClick="showCEDashboard(\'' + item.tripId + '\',\'' + item.vehicleNo + '\',\'' + item.std + '\',\'' + item.endDateForMap + '\',\'' + item.completeStatus + '\',\'' + item.routeId + '\')">' + item.tripNo + '</span>',
                  "3": item.driverName,
                  "4": item.driverNumber,
                  "5": item.lockStatus,
                  "6": item.lockedVehicleTrackingTime
                 }
			   slNum++;
               rows.push(row);
            });
         } else {
            var row = {
               "0": "No Data available"
            }
         }
	setTimeout(function() {	
	if ($.fn.DataTable.isDataTable('#onTripLockedVehicleDetails')) {
            $('#onTripLockedVehicleDetails').DataTable().clear().destroy();
         }
         onTripVehTable = $('#onTripLockedVehicleDetails').DataTable({
            "scrollY": "280px",
            "scrollX": true,
            paging: false,
            "oLanguage": {
               "sEmptyTable": "No data available"
            },
            "dom": 'Bfrtip',
            "buttons": [{
               extend: 'excel',
               text: 'Export to Excel',
			   title : 'Locked Vehicles Report',
               className: 'btn btn-primary excelWidth'
            }],
         });
         onTripVehTable.rows.add(rows).draw();
		 $("#loading-div").hide();
		 },3000);
         //onTripVehTable.columns([1, 4, 15]).visible(false);
      }
   });
} 

$('#onTripVehicleDetails').unbind().on('click', 'td', function (event) {
   var table = $('#onTripVehicleDetails').DataTable();
   var columnIndex = table.cell(this).index().column;
   var aPos = $('#onTripVehicleDetails').dataTable().fnGetPosition(this);
   var data = $('#onTripVehicleDetails').dataTable().fnGetData(aPos[0]);
   onTripVehStopLatitude = data[11];
   onTripVehStopLongitude = data[12];
   onTripVehStopTripCustId = data[4];
   onTripVehStopDetailsTableId = data[1];
   onTripVehStoppageTripID = data[15];
   onTripVehAlertMapInfo.tripCustomerName = data[5];
   onTripVehAlertMapInfo.shipmentId = data[9];
   onTripVehAlertMapInfo.assetNumber = data[3];
   onTripVehAlertMapInfo.routeName = data[10];
   onTripVehAlertMapInfo.status = data[14];
   onTripVehAlertMapInfo.latitude = data[11];
   onTripVehAlertMapInfo.longitude = data[12];
   onTripVehAlertMapInfo.location = data[13];
   onTripVehAlertMapInfo.duration = data[6];
   onTripVehAlertMapInfo.lrNumber = data[2];
   onTripVehAlertMapInfo.stoppageBegin = data[7];
   if (columnIndex == 8) {
      showOnTripVehiclStoppageMap();
   }
});

function showOnTripVehiclStoppageMap() {
   $('#onTripVehiclStoppageMapModal').modal('show');

   $('#smartHub').prop("checked", false).trigger("change");
   var pos = new L.LatLng(onTripVehStopLatitude, onTripVehStopLongitude);
   if (mapView != null) {
      mapView.remove();
   }
   initializeMapView("dvMap", pos, '<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
   setTimeout(function () {
      mapView.invalidateSize();
   }, 250);
   imageurl = '/ApplicationImages/VehicleImagesNew/MapImages/default_BR.png';
   image = L.icon({
      iconUrl: String(imageurl),
      iconSize: [35, 35],
      popupAnchor: [0, -15]
   });
   var vehiclemarker = new L.Marker(pos, {
      icon: image
   }).addTo(mapView);

   var contentForDot = '<div id="myInfoDivForVehicle" seamless="seamless" scrolling="no" style="overflow:auto;color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
      '<table>' +
      '<tr><td><b>Customer name:</b></td><td>' + onTripVehAlertMapInfo.tripCustomerName + '</td></tr>' +
      '<tr><td><b>Trip ID:</b></td><td>' + onTripVehAlertMapInfo.shipmentId + '</td></tr>' +
      '<tr><td><b>Vehicle Number:</b></td><td>' + onTripVehAlertMapInfo.assetNumber + '</td></tr>' +
      '<tr><td><b>Trip No:</b></td><td>' + onTripVehAlertMapInfo.lrNumber + '</td></tr>' +
      '<tr><td><b>Route name:</b></td><td>' + onTripVehAlertMapInfo.routeName + '</td></tr>' +
      '<tr><td><b>Latitude:</b></td><td>' + onTripVehAlertMapInfo.latitude + '</td></tr>' +
      '<tr><td><b>Longitude:</b></td><td>' + onTripVehAlertMapInfo.longitude + '</td></tr>' +
      '<tr><td><b>Location:</b></td><td>' + onTripVehAlertMapInfo.location + '</td></tr>' +
      '<tr><td><b>Duration(HH:mm:ss)</b></td><td>' + onTripVehAlertMapInfo.duration + '</td></tr>' +
      '</table>' +
      '</div>';
   vehiclemarker.bindPopup(contentForDot);
}



function plotBuffersForSmartHub(bufferStoreSmartHubTripDelay) {
   for (var i = 0; i < bufferStoreSmartHubTripDelay.getCount(); i++) {
      var rec = bufferStoreSmartHubTripDelay.getAt(i);
      var urlForZero;
      if (rec.data['hubType'] == '32')
         urlForZero = '/ApplicationImages/VehicleImages/red.png';
      else
         urlForZero = '/ApplicationImages/VehicleImages/green.png';
      var convertRadiusToMeters = rec.data['radius'] * 1000;
      var lat = parseFloat(rec.data['latitude']);
      var lng = parseFloat(rec.data['longitude']);
      var myLatLng1 = new L.LatLng(lat, lng);

      bufferimage1 = L.icon({
         iconUrl: urlForZero,
         iconSize: [19, 35],
         popupAnchor: [0, -15]
      });
      buffermarker1 = new L.Marker(myLatLng1, {
         icon: bufferimage1
      }).addTo(mapView);
      buffermarker1.bindPopup(rec.data['buffername']);
      buffermarkersmart1[i] = buffermarker1;
      circlessmart1[i] = L.circle(myLatLng1, {
         color: '#A7A005',
         fillColor: '#ECF086',
         fillOpacity: 0.55,
         center: myLatLng1,
         radius: convertRadiusToMeters
      }).addTo(mapView);
   }
}


function plotPolygonSmartHub() {
   var hubid = 0;
   var polygonCoords = [];
   for (var i = 0; i < polygonStoreSmartHubTripDelay.getCount(); i++) {
      var rec = polygonStoreSmartHubTripDelay.getAt(i);
      if (i != polygonStoreSmartHubTripDelay.getCount() - 1 && rec.data['hubid'] == polygonStoreSmartHubTripDelay.getAt(i + 1).data['hubid']) {
         var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
         polygonCoords.push(latLong);
         continue;
      } else {
         var latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
         polygonCoords.push(latLong);
      }
      polygon = L.polygon(polygonCoords).addTo(mapView);

      var urlForZero;
      if (rec.data['hubType'] == '32')
         urlForZero = '/ApplicationImages/VehicleImages/red.png';
      else
         urlForZero = '/ApplicationImages/VehicleImages/green.png';
      polygonimage = L.icon({
         iconUrl: urlForZero,
         iconSize: [48, 48], // size of the icon
         popupAnchor: [0, -15]
      });
      polygonmarker = new L.Marker(latLong, {
         bounceOnAdd: true
      }, {
         icon: polygonimage
      }).addTo(mapView);

      polygonmarker.bindPopup(rec.data['polygonname']);
      polygonsmart1[hubid] = polygon;
      polygonmarkersmart1[hubid] = polygonmarker;
      hubid++;
      polygonCoords = [];
   }
}

function createGraph() {
   $("#chartModal").modal("show");
   google.charts.load('current', {
      'packages': ['corechart']
   });
   google.charts.setOnLoadCallback(drawChart);

}

function drawChart() {
   $.ajax({
      url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getActivityReportData',
      data: {
         startdate: '05/11/2019 12:00:00',
         enddate: '06/11/2019 12:00:00',
         regno: 'HR55AD8501'
      },
      success: function (response) {
         tempList = JSON.parse(response);
         var data = new google.visualization.DataTable();
         data.addColumn('string', 'Time');
         data.addColumn('number', 'Avg Speed');
         data.addColumn('number', 'Speed');
         for (var i = 0; i < tempList["ActivityReportDetailsRoot"].length; i++) {
            var arr = [];
            arr.push(tempList["ActivityReportDetailsRoot"][i].dateTimeDataIndex);
            arr.push(Number(53));
            arr.push(Number(tempList["ActivityReportDetailsRoot"][i].speedDataIndex));
            data.addRows([arr]);
         }
         var options = {
            title: 'Company Performance',
            curveType: 'function',
            legend: {
               position: 'bottom'
            }
         };
         var chart = new google.visualization.LineChart(document.getElementById('speed_chart'));
         chart.draw(data, options);
      }
   });
}

function getWeatherInfoForCities(isCapital) {

    $.ajax({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCityNamesForMap',
	  data: {
		isCapital:  isCapital
	  },
      success: function (response) {
         cityList = JSON.parse(response);
         $.each(cityList.cityRoot, function () {
            plotMarkerForCityWeatherData(this.latitude, this.longitude, this);
            if(this.severeDesc !='') {
            	plotMarkerForSevereAlert(this.latitude, this.longitude, this.cityName, this.severeDesc);
            }
         });
      }
   });
}

function plotMarkerForSevereAlert(latitude, longitude, cityName, desc) {
   var weatherImage = L.icon({
      iconUrl: String('/ApplicationImages/VehicleImages/severealert.png'),
      iconSize: [40, 40], // size of the icon
      popupAnchor: [0, -15]
   });
   severeWeatherMarker = new L.Marker(new L.LatLng(latitude, longitude), {
      icon: weatherImage
   }).addTo(map);

   var severeAlertLabel = '<div id="" seamless="seamless" scrolling="no" style="height: 50px;overflow:auto; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
      '<table>' +
      '<tr><td><b>CityName:</b></td><td>' + cityName + '</td></tr>' +
      '<tr><td><b>Description:</b></td><td>' + desc.toUpperCase() + '</td></tr>' +
      '</table>' +
      '</div>';
	severeWeatherMarker.bindTooltip(severeAlertLabel, {
	  permanent: false
   })
}

function plotMarkerForCityWeatherData(latitude, longitude, cityList) {
   var weatherImage = L.icon({
      iconUrl: String(cityList.iconLink),
      iconSize: [25, 25],
      popupAnchor: [0, -15]
   });
   weatherMarker = new L.Marker(new L.LatLng(latitude, longitude), {
      icon: weatherImage
   }).addTo(map);

   var cityLabel = '<div id="" seamless="seamless" scrolling="no" style="height: 50px;overflow:auto; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
      '<table>' +
      '<tr><td><b>City Name:</b></td><td>' + cityList.cityName + '</td></tr>' +
      '<tr><td><b>Temperature(°C):</b></td><td>' + cityList.temperature + '</td></tr>' +
      '<tr><td><b>Description:</b></td><td>' + cityList.iconName.toUpperCase() + '</td></tr>' +
	  '<tr><td><b>Datetime :</b></td><td>' +getFormattedDate(cityList.utcTime)+ '</td></tr>' +
      '</table>' +
      '</div>';

   weatherMarker.bindTooltip(cityLabel, {
	  permanent: false
   })
   if(cityList.capital == 'CAPITAL') {
	  weatherCapitalCityMarkerArr.push(weatherMarker);
   } else {
	  weatherMarker.valueOf()._icon.style.height = '30px';
      weatherMarker.valueOf()._icon.style.width = '30px';
	  weatherAllCityMarkerArr.push(weatherMarker);
   }

   weatherMarker.valueOf()._icon.style.backgroundColor = 'rgb(12, 12, 12, 0.8)';
   weatherMarker.valueOf()._icon.style.borderRadius = '50%';
}
function getFormattedDate(dateTime){
	var formattedDate = "";
	var dateParts = dateTime.split('T');
	var timeParts = dateParts[1].split('+');
	var dateTime = new Date(dateParts[0]+' '+timeParts[0]);

	var dd = dateTime.getDate() < 10 ? "0"+dateTime.getDate() : dateTime.getDate();
	var month = (dateTime.getMonth() + 1) < 10 ? "0"+(dateTime.getMonth() + 1) : (dateTime.getMonth() + 1);
	var yyyy = dateTime.getFullYear() < 10 ? "0"+dateTime.getFullYear() : dateTime.getFullYear();
	var hh = dateTime.getHours() < 10 ? "0"+dateTime.getHours() : dateTime.getHours();
	var mm = dateTime.getMinutes() < 10 ? "0"+dateTime.getMinutes() : dateTime.getMinutes();
	var ss = dateTime.getSeconds() < 10 ? "0"+dateTime.getSeconds() : dateTime.getSeconds();
	formattedDate= dd+"/"+month+"/"+yyyy+" "+hh+":"+mm+":"+ss;
	return formattedDate;
}
function showWeatherDataForMarker(lat, lon, marker) {
   $.ajax({
      url: 'https://weather.api.here.com/weather/1.0/report.json',
      type: 'GET',
      dataType: 'jsonp',
      jsonp: 'jsonpcallback',
      data: {
         product: 'observation',
         latitude: lat,
         longitude: lon,
         app_id: '<%=appKey%>',
         app_code: '<%=appCode%>',
         oneobservation: 'true'
      },
      success: function (data) {
		 if(data.observations != undefined){
         var weatherResponse = data.observations.location[0].observation[0];
         var visibility = "";
         if (weatherResponse.visibility > '2') {
            visibility = "Good";
         } else if (weatherResponse.visibility > '0.20' && weatherResponse.visibility < '2') {
            visibility = "Bad";
         } else if (weatherResponse.visibility < '0.20') {
            visibility = "Poor";
         }
		 
         var label = '<div seamless="seamless" scrolling="no" style="height: 70px;overflow:auto; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
            '<table>' +
            '<tr><td><b>Visibility:</b></td><td>' + visibility + '</td></tr>' +
            '<tr><td><b>Temperature(°C):</b></td><td>' + weatherResponse.temperature + '</td></tr>' +
            '<tr><td><b>Description :</b></td><td>' + weatherResponse.iconName.toUpperCase() + '</td></tr>' +
			'<tr><td><b>Datetime :</b></td><td>' + getFormattedDate(weatherResponse.utcTime) + '</td></tr>' +
            '<tr><td><b>Icon :</b></td><td>' + '<img style="height:25px;background-color:rgb(58, 96, 115, 0.8);border-radius:50%;" src=' + weatherResponse.iconLink + '></td></tr>' +
            '</table>' +
            '</div>';

         marker.bindTooltip(label, {
            permanent: false
         })
	  }
      }
   });
}
$(document).on("change",'#allCity',function() {
	if(this.checked) {
		getWeatherInfoForCities(false);
	} else {
		for (var i = 0; i < weatherAllCityMarkerArr.length; i++) {
		  map.removeLayer(weatherAllCityMarkerArr[i]);
	   }
	}
});

$(document).on("change",'#capitalCity',function() {
	if(this.checked) {
		getWeatherInfoForCities(true);
	} else {
		for (var i = 0; i < weatherCapitalCityMarkerArr.length; i++) {
		  map.removeLayer(weatherCapitalCityMarkerArr[i]);
	   }
	}
});

</script>


<jsp:include page="../Common/footer.jsp" />
