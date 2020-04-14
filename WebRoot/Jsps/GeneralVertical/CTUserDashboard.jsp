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
	int userId = loginInfo.getUserId();
	String username = loginInfo.getUserName();
	String roleName = cf.getRoleIdFromUsersWithoutConnection(systemId,
			userId);
%>
<jsp:include page="../Common/header.jsp" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
<!--<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">-->
<link
	href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css"
	rel="stylesheet" />
<link href="../../Main/custom.css" rel="stylesheet" type="text/css">
<link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
<link rel='stylesheet'
	href='https://cdn.jsdelivr.net/npm/sweetalert2@7.12.15/dist/sweetalert2.min.css'>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.7.2/css/all.css"
	integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr"
	crossorigin="anonymous">
<script
	src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
<script
	src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
<script
	src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css"
	rel="stylesheet" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
<script
	src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
<link rel="stylesheet"
	href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css"
	type="text/css" />
<script type="text/javascript"
	src="https://www.jqwidgets.com/jquery-widgets-demo/scripts/demos.js"></script>
<script type="text/javascript"
	src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcore.js"></script>
<script type="text/javascript"
	src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxdatetimeinput.js"></script>
<script type="text/javascript"
	src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcalendar.js"></script>
<script type="text/javascript"
	src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript"
	src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/globalization/globalize.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@7.12.15/dist/sweetalert2.all.min.js"></script>
<style>
.modal-backdrop {
	z-index: 0;
}

.modal {
	position: fixed;
	top: 6%;
	left: 0%;
	z-index: 1;
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

#alertEventsTable_filter {
	padding-left: 99px;
	padding-top: 10px;
}

#alertEventsTable_length {
	padding-top: 12px;
}
.panel-primary {
	border: none !important;
	margin-top: 0px;
}

.nav-tabs {
	border-bottom: 1px dotted black;
	height: 32px;
}

.nav-tabs>li.active>a,.nav-tabs>li.active>a:hover,.nav-tabs>li.active>a:focus
	{
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

.sweet-alert button.cancel {
	background-color: #d9534f !important;
}

.sweet-alert button {
	background-color: #5cb85c !important;
}

.cardUser {
	box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.2), 0 2px 10px 0
		rgba(0, 0, 0, 0.19);
	padding: 10px;
	margin-bottom: 8px;
	border-radius: 2px !important;
}

.caret {
	display: none;
}

.row {
	margin-right: 0px !important;
	margin: auto;
	width: 102%;
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

.outer-count {
	text-align: center;
}

.main-count {
	margin-top: 20px;
	margin-bottom: 10px;
}

.padTop {
	padding-top: 10px;
}

.col-md-12 {
	padding: 0px;
}

#tripWise .col-sm-12 {
	padding: 0px;
}

.col-sm-12 {
	padding: 0px;
}

#viewBtn {
	height: 28px;
	padding-top: 3px;
}

.purple {
	background: #8D33AA;
}

.green {
	background: #00897B;
}

.orange {
	background: #E9681B;
}

.blueWater { /*  background: #7CC7DF;*/
	background: #B0BEC5;
}

.blue {
	background: #00A1DE;
}

.brick {
	background: #C83131;
}

.red {
	background: #D32F2F;
}

.mustard {
	background: #EABC00;
}

.blueGrey {
	background: #337ab7;
}

.blueGreyLight {
	background: #ECEFF1;
}

.purpleFont {
	color: #8D33AA;
}

.greenFont {
	color: #00897B;
}

.orangeFont {
	color: #E9681B;
}

.whiteFont {
	color: #ffffff;
}

.blueFont {
	color: #00A1DE;
}

.brickFont {
	color: #C83131;
}

.mustardFont {
	color: #EABC00;
}

.headerText {
	text-align: left;
	color: white;
	padding: 4px 4px 4px 0px;
}

.close {
	float: right;
	display: inline-block;
	padding: 0px 12px 0px 8px;
}

.close:hover {
	cursor: pointer;
}

.left {
	padding: 8px 16px 8px 16px;
	width: 100%;
}

.right {
	float: right;
}

.right:hover {
	text-decoration: underline;
	cursor: pointer;
}

.imageOpen {
	float: right;
	padding: 8px 12px 8px 8px;
}

#midColumn {
	-webkit-transition: all 0.5s ease;
	-moz-transition: all 0.5s ease;
	-o-transition: all 0.5s ease;
	transition: all 0.5s ease;
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

.highlightText {
	text-align: center;
	padding: 2px 0px 2px 0px;
	min-height: 24px;
	cursor: pointer;
}

.highlightRow {
	width: 30%;
	float: right;
}

.highlightRowLeft {
	width: 45%;
	float: left;
}

.infoDiv td {
	padding: 4px 0px 4px 0px;
	vertical-align: top;
	line-height: 12px;
}

.paddingLeft16 {
	padding-left: 16px;
}

.select2 {
	width: 240px !important;
}

.blueGreyDark {
	background: #337ab7;
}

.pointer {
	cursor: pointer;
}

.redStatus { /* background: #EF5350; */
	color: #FF1744;
}

.orangeStatus { /* background:#FFB74D; */
	color: #FF6F00;
	background: #ECEFF1;
}

.greenStatus { /* background: #4CAF50; */
	color: #1B5E20;
}

.redBorder {
	border: 1px solid red !important;
}

.dispNone {
	display: none;
}

.red {
	color: red;
	background: white;
}

.highlight {
	color: white !important;
	background: #00A0D6 !important;
}

.list-group-item {
	padding-top: 0px;
	padding-bottom: 0px;
}

.col-lg-8,.col-lg-4 {
	padding: 4px;
}

#tblAssociateVehicles {
	border: 1px solid #AAAAAA !important;
}

#tblUnassignedVehicles {
	border: 1px solid #AAAAAA !important;
}

.list-group-item {
	padding-top: 4px;
}

.list-group-item .col-lg-10 {
	padding-left: 0px;
}

#rightN .col-lg-3 {
	padding: 8px 0px 0px 0px;
	margin-right: 16px;
}

#rightN .col-lg-2 {
	padding: 8px 0px 0px 0px;
	margin-right: 16px;
	width: 20%;
}

#rightN .col-lg-6 {
	padding: 8px 0px;
}

#bottomRow {
	width: 100%;
	margin-left: 0px;
	text-align: center;
}

#bottomRow .col-lg-3 {
	padding-bottom: 4px;
	padding-top: 4px;
}

.dataTables_filter {
	margin-top: -32px;
}

.redText {
	color: red;
	font-weight: bold;
	font-size: 18px;
}

.greenText {
	color: green;
	font-weight: bold;
	font-size: 18px;
}

.orangeText {
	color: orange;
	font-weight: bold;
	font-size: 18px;
}

.darkRedText {
	color: #c30119 !important;
	font-weight: bold;
	font-size: 18px;
}

.select2-container {
	width: 100% !important
}

.btnStyle {
	padding: 0.4rem;
	border-radius: 4px;
	background: #4285F4;
	width: 120px;
	color: White;
}

.hrStyle {
	padding: 5px 5px 20px 20px;
	border-radius: 1px;
	opacity: 1;
	background: #337ab7;
	text-transform: uppercase;
	color: white;
	height: 30px;
	font-size: 18px;
}

.resetBtn {
	color: white;
	font-size: 18px;
	float: right;
	margin-right: 16px;
	margin-top: 2px;
}

#totalVehicles {
	float: right;
	padding-right: 40px;
	margin-top: 5px;
}

html {
	overflow-x: hidden;
}

.table {
	width: 100%;
	max-width: 100%;
	margin-bottom: 1rem;
	background-color: transparent;
	font-size: 12px;
}

#ctuserTable_wrapper {
	margin-top: 10px;
	margin-left: -12px;
}

.createTrip {<!--
	font-size: 16px !important; -->
	height: 200px !important;
	width: 60% !important;
	margin-left: 20% !important;
	margin-top: 30px;
}

#createTitle {
	text-align: center;
	margin-left: 69px;
	color: white;
	height: 33px;
	padding-top: 6px;
}

.invalid {
	border: red 1px solid;
}

hr {
	border-top: 1px solid #6d6d6d !important;
	margin-top: 8px !important;
	margin-bottom: 8px !important;
}

.btn-primary {
	height: 24px;
	padding: 1px 16px;
	margin-top: -2px;
}

.blueGreyDark {
	padding: 1px;
}

.modal-footer { /* padding: 15px; */
	text-align: right;
	border-top: 1px solid #e5e5e5;
	height: 50px;
}

#datatableRemarks {
	padding-right: 17px;
	width: 90% !important;
	margin-left: 45px !important;
}

.multiselect-container {
	overflow-y: scroll !important;
	height: 300px;
	overflow-x: hidden;
}

.center-view {
	top: 40%;
	left: 50%;
	position: fixed;
	height: 200px;
	width: 200px;
	z-index: 1000000000;
}

#delayReasonDetailsTable_wrapper {
	margin-top: 11px;
}

#viewBtnId {
	margin-left: 6px;
	width: 60px;
	height: 25px;
	padding-top: 3px;
}

#viewId {
	height: 27px;
	padding: 1px 16px;
	margin-top: 0px;
}

.blink {
	animation: blink 2s steps(5, start) infinite;
	-webkit-animation: blink 1s steps(5, start) infinite;
}

@
keyframes blink {to { visibility:hidden;
	
}

}
@
-webkit-keyframes blink {to { visibility:hidden;
	
}
}
</style>
<!-- content -->
<div style="margin-top: -20px;">
	<div class="hrStyle text-center">
		CT User Dashboard
		<i class="fa fa-undo resetBtn pointer" title="Click to refresh"
			onclick="refreshData()"></i>
	</div>
	<div class="row" style="margin-top: 5px;">
		<div class="col-lg-2" style="padding: 0px 0px 8px 0px;">
			<select id="userNames" style="width: 100% !important;"
				name="userNames">
				<option value="0">
					ALL
				</option>
			</select>
		</div>
		<div class="col-lg-2"
			style="padding: 0px 0px 8px 0px; margin-left: 8px;">
			<button class="btn btn-primary" id="viewId" onclick="viewData();">
				View
			</button>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-2 col-md-2 col-sm-12 cardUser">
			<div class="row">
				<div class="col-lg-12" style="line-height: 28Px;">
					<div class="headerText blueGrey" style="width: 98%">
						<img src="/ApplicationImages/VehicleImages/delivery-van.png"
							style="width: 30px; margin-left: 16px;" />
						<span style="margin-left: 12px;">Vehicles</span>
						<span class="pointer" id="totalVehicles" onclick=loadDataTable('')>0</span>
					</div>
					<ul class="list-group"
						style="border-bottom: 0px !important; margin-bottom: 0px; height: 94px; width: 98%;">
						<li class="list-group-item">
							<div class="row">
								<div class="col-lg-10"><p data-toggle="tooltip" title="Vehicle has departed from the source and is enroute to destination
ATD is not null and ATA is null ">
									In Transit</p>
								</div>
								<div class="col-lg-2 pointer" id="inTransitCount"
									onclick="loadDataTable('inTransit')">
									0
								</div>
							</div>
						</li>
						<li class="list-group-item" style="background: #ECEFF1;">
							<div class="row">
								<div class="col-lg-10"><p data-toggle="tooltip"title="Vehicle is yet to reach the source location. ATP is null">
									Planned</p>
								</div>
								<div class="col-lg-2 pointer" id="plannedCount"
									onclick="loadDataTable('planned')">
									0
								</div>
							</div>
						</li>
						<li class="list-group-item"
							style="height: 40px; border-bottom: 0px !important;">
							<div class="row">
								<div class="col-lg-10">
									GPS Non-Comm
								</div>
								<div class="col-lg-2 pointer" id="nonCommCount"
									onclick="loadDataTable('nonCommunicating')">
									0
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="col-lg-10 col-md-4 col-sm-12">
			<div id="rightN" style="margin-left: 16px; text-align: center;">
				<div class="row">
					<div class="col-lg-2 cardUser" style="padding: 48px 0px;">
						<div id="onTime" class="greenText pointer"
							onclick="loadDataTable('ontime')">
							0
						</div>
						<div><p data-toggle="tooltip"title="Vehicle has departed from the source location and is within schedule to reach the destination. Trip Status = On time & ATD is not null and ATA is null. ETA < STA w.r.t ATD">
							On Time</p>
						</div>
						<!--            <hr style="margin:0px;border-top:1px solid #6d6d6d;margin-top: 15px !important;">-->
						<!--            <div id="departureDelay" class="greenText pointer" onclick="loadDataTable('departuredelay')">0</div>-->
						<!--            <div>Delayed - Late Departure</div>-->
					</div>
					<div class="col-lg-2 cardUser">
						<div id="delay" class="darkRedText pointer"
							onclick="loadDataTable('delayed')">
							0
						</div>
						<div style="padding-bottom: 8px;"><p data-toggle="tooltip"title="Vehicle has departed from the source location and is not on schedule to reach the destination. Trip Status = Delay & ATD is not null and ATA is null. ETA > STA w.r.t ATD">
							Delay</p>
						</div>
						<hr style="margin: 0px; border-top: 1px solid #6d6d6d">
						<div class="row">
							<div class="col-lg-6" style="border-right: 1px solid #6d6d6d;">
								<div id="lessThanOneHr" class="orangeText pointer"
									onclick="loadDataTable('delayedLess')">
									0
								</div>
								<div>
									&lt; 1 hr
								</div>
							</div>
							<div class="col-lg-6">
								<div id="greaterThanOneHour" class="redText pointer"
									onclick="loadDataTable('delayedGreater')">
									0
								</div>
								<div>
									&gt; 1 hr
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-2 cardUser">
						<div id="atUnloading" class="darkRedText pointer"
							onclick="loadDataTable('unloading')">
							0
						</div>
						<div style="padding-bottom: 8px;"><p data-toggle="tooltip"title="Vehicle is at the destination. ATA is not null and Trip Close time is null.">
							At Unloading</p>
						</div>
						<hr style="margin: 0px; border-top: 1px solid #6d6d6d;">
						<div class="row">
							<div class="col-lg-6" style="border-right: 1px solid #6d6d6d;">
								<div id="lessThan24Hr" class="orangeText pointer"
									onclick="loadDataTable('unloadingLess')">
									0
								</div>
								<div>
									&lt; 24 hr
								</div>
							</div>
							<div class="col-lg-6">
								<div id="greaterThan24Hour" class="redText pointer"
									onclick="loadDataTable('unloadingGeater')">
									0
								</div>
								<div>
									&gt; 24 hr
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-2 cardUser">
						<div id="loading" class="darkRedText pointer"
							onclick="loadDataTable('loading')">
							0
						</div>
						<div style="padding-bottom: 8px;"><p data-toggle="tooltip"title="Vehicle is at the source location. ATP is not null and ATD is null.">
							At Loading</p>
						</div>
						<hr style="margin: 0px; border-top: 1px solid #6d6d6d">
						<div class="row">
							<div class="col-lg-6" style="border-right: 1px solid #6d6d6d;">
								<div id="loadingLessThan24Hrs" class="orangeText pointer"
									onclick="loadDataTable('loadingLess')">
									0
								</div>
								<div>
									&lt; 24 hrs
								</div>
							</div>
							<div class="col-lg-6">
								<div id="loadingGreaterThan24Hrs" class="redText pointer"
									onclick="loadDataTable('loadingGreater')">
									0
								</div>
								<div>
									&gt; 24 hrs
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-2 cardUser" style="padding: 41px 0px;">
						<div class="row">
							<div class="col-lg-6" style="border-right: 1px solid #6d6d6d;">
								<div id="accident" class="redText pointer"
									onclick="loadDataTable('accident')">
									0
								</div>
								<div>
									Accident
								</div>
							</div>
							<div class="col-lg-6">
								<div id="breakdown" class="redText pointer"
									onclick="loadDataTable('breakdown')">
									0
								</div>
								<div>
									Breakdown
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row cardUser"
		style="background: #f7f7f7; margin-bottom: 16px;" id="bottomRow">
		<div class="col-lg-3" style="border-right: 1px solid #6d6d6d;">
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title="Vehicle which had to enter a customer touching point and stay for sometime and the leave, either doesnt enter the touching point and goes  5.00 KMs kms away or leaves within 00:15 (HH:MM) min of entry.">
						Customer Hub Missed
					</p>
				</div>
				<div id="touchPointMiss"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Customer Hub Missed Alerts', '206')">
					0
				</div>
			</div>
			<hr>
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title=" Vehicle on trip which stops communicating for 00:15 (HH:MM) mins.
Note : Alert generated after the vehicles departure-( from source point and before arrival at destination.">
						Non Communicating Vehicle
					</p>
				</div>
				<div id="nonCommunicatingVehicle"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Non Communicating Vehicle', '85')">
					0
				</div>
			</div>

		</div>
		<div class="col-lg-3" style="border-right: 1px solid #6d6d6d;">
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title="On Trip vehicle is inside enroute DHL SH for more than 'Allowed SH detention time' Mins.
Note : Alert generated after the vehicles departure-( from source point and before arrival at destination.">
						Enroute SH Detention
					</p>
				</div>
				<div id="enrouteShDetention"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Enroute SH Detention', '204')">
					0
				</div>
			</div>
			<hr>
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title="Vehicle which is on trip, stops enroute at a non-geofenced location for more than 00:15 (HH:MM) minutes.
Note : Alert generated after the vehicles departure-( from source point and before arrival at destination.">
						Unplanned Stoppage
					</p>
				</div>
				<div id="unplannedStoppage"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Unplanned Stoppage', '202')">
					0
				</div>
			</div>
		</div>
		<div class="col-lg-3" style="border-right: 1px solid #6d6d6d;">
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title="Vehicle which is on trip deviates for 10.00 KMs kms from the planned route.
Note : Alert generated after the vehicles departure-( from source point and before arrival at destination.">
						Route Deviation
					</p>
				</div>
				<div id="routeDeviation"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Route Deviation', '5')">
					0
				</div>
			</div>
			<hr>
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title="When there is a temprature deviation from the ''set Green band for on TRIP' TCL vehicle from ATD + 30 Mins to ATA.
Note : Alert generated after the vehicles departure-( from source point and before arrival at destination.">
						Temperature Deviation
					</p>
				</div>
				<div id="tempDeviation"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Temperature Deviation', '216')">
					0
				</div>
			</div>
		</div>
		<div class="col-lg-2"
			style="border-right: 1px solid #6d6d6d; padding: 4px 16px;">
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title=" Vehicle which had to enter a SmartHub and stay for sometime and then leave, either doesnt enter the touching point and goes 5.00 KMs kms away or leaves within 00:10 (HH:MM) min of entry.
Note : Alert generated after the vehicles departure-( from source point and before arrival at destination.">
						Smart Hub Missed
					</p>
				</div>
				<div id="smartHubMiss"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Smart Hub Missed Alerts', '205')">
					0
				</div>
			</div>
			<hr>
			<div style="display: flex;">
				<div style="width: 70%; text-align: left; margin-left: 8px;">
					<p data-toggle="tooltip"
						title="Vehicle which is on trip, stops enroute at a non-geofenced location for more than 00:15 (HH:MM) minutes.
Note : Alert generated after the vehicles departure-(from source point and before arrival at destination).">
						Idle
					</p>
				</div>
				<div id="idleAlert"
					style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Idle', '39')">
					0
				</div>
			</div>
		</div>
		<div class="col-lg-1">
			<div
				style="display: flex; flex-direction: column; align-items: center; margin-left: 10px; border: 1px solid black; padding-bottom: 8px; padding-right: 4px; background: white;">
				<div style="margin-top: 12px;">
					<i class="far fa-pause-circle"
						style="font-size: 16px; color: red; padding-right: 4px;"></i>Paused
				</div>
				<div style="font-weight: bold; width: 30%; cursor: pointer;"
					onclick="OpenDataTable('Remarks','Snoozed', '0')">
					<span id="paused">0</span>
				</div>
			</div>

		</div>
	</div>
	<div class="center-view" style="display: none;" id="loading-div">
		<img src="../../Main/images/loading.gif" alt="">
	</div>
	<div class="row">
		<div class="col-lg-12">
			<table id="ctuserTable" class="table table-striped table-bordered"
				cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>
							#
						</th>
						<th>
							Customer Name
						</th>
						<th>
							Trip No.
						</th>
						<th>
							Vehicle No.
						</th>
						<th>
							GPS Status
						</th>
						<th>
							Route Key
						</th>
						<th>
							Touch Points
						</th>
						<th>
							Average Speed(km/h)
						</th>
						<th>
							Status
						</th>
						<th>
							ATD
						</th>
						<th>
							Destination ETA
						</th>
						<th>
							Drivers
						</th>
						<th>
							Driver Contacts
						</th>
						<th>
							Delay Reason
						</th>
						<th>
							Planned Temperature(°C)
						</th>
						<th>
							Actual Temperature(°C)
						</th>
						<th>
							Delay Updated Timestamp
						</th>
						<th>
							Delay Type
						</th>
						<th>
							Transit Delay(hh:mm:ss)
						</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
</div>
<div id="addRemarksId" class="modal-content modal fade createTrip">
	<div class="row blueGreyDark modalHeader">
		<div class="col-md-10">
			<h4 id="createTitle" class="modal-title">
				Delay Code Details
			</h4>
		</div>
		<div class="col-md-2 fa fa-window-close" data-dismiss="modal"
			style="cursor: pointer; color: white; text-align: right; padding-right: 10px; margin-top: 9px;">
		</div>
	</div>
	<div class="modal-body" style="height: 100%; overflow-y: auto;">
		<div class="col-md-12">
			<table id="delayDetailsId" class="table table-striped table-bordered"
				cellspacing="0" style="width: -1px;">
				<tbody>
					<tr>
						<td>
							Delay Type
							<sup>
								*
							</sup>
						</td>
						<td>
							<select class="form-control form-control-custom" id="delayTypeId">
							</select>
						</td>
					</tr>
					<tr>
						<td>
							Delay Start Time
							<sup>
								*
							</sup>
						</td>
						<td>
							<input type='text' id="dateInput1" />
						</td>
					</tr>
					<tr>
						<td>
							Delay End Time
							<sup>
								*
							</sup>
						</td>
						<td>
							<input type='text' id="dateInput2" />
						</td>
					</tr>
					<tr>
						<td>
							Delay
							<sup></sup>
						</td>
						<td>
							<input type='text' id="delayId" disabled />
						</td>
					</tr>
					<tr>
						<td>
							Remarks
							<sup></sup>
						</td>
						<td>
							<input class="form-control" type='text' id="remarksId" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="modal-footer" style="text-align: center;">
		<input id="save1" onclick="saveRemarksData()" type="button"
			class="btn btn-success" value="Save" />
		<button type="reset" class="btn btn-danger" id="cancelbutton"
			data-dismiss="modal">
			Cancel
		</button>
	</div>
</div>
<div id="TouchPointsModal" class="modal fade createTrip"
	style="height: 85% !important;">
	<div class="row blueGreyDark modalHeader">
		<div class="col-md-10">
			<h4 id="createTitle" class="modal-title">
				Touch Points
			</h4>
		</div>
		<div class="col-md-2 fa fa-window-close" data-dismiss="modal"
			style="cursor: pointer; color: white; text-align: right; padding-right: 10px; margin-top: 9px;">
		</div>
	</div>
	<div class="modal-body"
		style="margin-top: 8px; height: 80vh; overflow-y: auto; padding-top: 10px;">
		<table id="touchPointTable" class="table table-striped table-bordered"
			cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>
						Sl No
					</th>
					<th>
						Touch Point Name
					</th>
					<th>
						Allowed Detention (HH:mm)
					</th>
				</tr>
			</thead>
		</table>
	</div>
</div>
<div id="viewDelayModal" class="modal fade createTrip"
	style="width: 85% !important; margin-left: 8% !important;">
	<div class="row blueGreyDark modalHeader">
		<div class="col-md-10">
			<h4 id="createTitle" class="modal-title">
				View Delay Reason
			</h4>
		</div>
		<div class="col-md-2 fa fa-window-close" data-dismiss="modal"
			style="cursor: pointer; color: white; text-align: right; padding-right: 10px; margin-top: 9px;">
		</div>
	</div>
	<div class="modal-body"
		style="margin-top: 8px; height: 80vh; overflow-y: auto; padding: 0px;">
		<table id="delayReasonDetailsTable"
			class="table table-striped table-bordered" cellspacing="0"
			width="100%">
			<thead>
				<tr>
					<th>
						#
					</th>
					<th>
						Customer Name
					</th>
					<th>
						Trip No
					</th>
					<th>
						Vehicle No
					</th>
					<th>
						Delay Type
					</th>
					<th>
						Delay Category
					</th>
					<th>
						Location
					</th>
					<th>
						Delay Start Date
					</th>
					<th>
						Delay End Date
					</th>
					<th>
						Delay Time (HH:mm:ss)
					</th>
					<th>
						Remarks
					</th>
					<th>
						Added By
					</th>
					<th>
						Added Date
					</th>
				</tr>
			</thead>
		</table>
	</div>
</div>
<div id="datatableRemarks" class="modal fade createTrip">
	<div class="row blueGreyDark modalHeader">
		<div class="col-md-10">
			<h4 id="datatableRemarksHeader" class="modal-title"
				style="color: white; text-align: center; margin-left: 18%;">
				Add Remarks
			</h4>
		</div>
		<div class="col-md-2 fa fa-window-close" data-dismiss="modal"
			style="cursor: pointer; color: white; text-align: right; padding-right: 10px; margin-top: 9px;">
		</div>
	</div>
	<div class="modal-body" style="height: 100%; overflow-y: auto;">
		<div class="col-md-12">
			<table id="myTableRemarks" class="table table-striped table-bordered"
				cellspacing="0" style="width: -1px;">
			</table>
		</div>
	</div>
	<div class="modal-footer">
		<input id="save1" onclick="saveAlertsData()" type="button"
			class="btn btn-success" value="Save" />
		<button type="reset" class="btn btn-danger" id="cancelbutton"
			data-dismiss="modal">
			Close
		</button>
	</div>
</div>


<script>
	//history.pushState({ foo: 'fake' }, 'Fake Url', 'CTUserDashboard#');
    var currentDate = new Date();
var yesterdayDate = new Date();
yesterdayDate.setDate(yesterdayDate.getDate() - 1);
yesterdayDate.setHours(00);
yesterdayDate.setMinutes(00);
yesterdayDate.setSeconds(00);
currentDate.setHours(23);
currentDate.setMinutes(59);
currentDate.setSeconds(59);

var userId = '9999';
var dataSet = '';

function saveAlertsData() {
    let saveData = [];
    var detail = "";
    var tempDetail = "";
    for (var i = 0; i < noOfRows; i++) {
         if ($("#select" + i).val() != "" && $("#select" + i).val() != undefined  ) {
            let dt = {
                slNo: $("#select" + i).attr("slNO"),
                remarks: $("#input" + i).val(),
                snooze: $("#select" + i).val()
            }
             if($("#input" + i).val()==""){
             swal("Warning!!", "Enter the Remarks", "warning");
             return;
              }
            saveData.push(dt);
            }
    
       else  if ($("#input" + i).val() != "" && $("#input" + i).val() != undefined ) {
            let dt = {
                slNo: $("#input" + i).attr("slNO"),
                remarks: $("#input" + i).val(),
                snooze: 0
            }
            if($("#input" + i).val()==""){
             swal("Warning!!", "Enter the Remarks", "warning");
             return;
              }
            saveData.push(dt);
        }
     }
    
       
    if (saveData.length == 0) {
        swal("Warning!!", "No record found for acknowledgement", "warning");
        return;
    }
   
    var length = saveData.length;
    if(saveData.length>0){
    $.ajax({
       url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=updateRemarks',
        data: {
            detail: JSON.stringify(saveData),
            alertId: currentType
        },
        
        success: function(response) {
            response = JSON.parse(response); 
               
               if(response["errorList"].length > 0 && response["errorList"].includes("error")) {
                       swal("Error!!", response, "error");  
			} else if(response["updatedRemarksArr"].length > 0 && response["snoozedArr"].length > 0  && response["alreadySnoozedArr"].length == 0) {  //Success
			    loadCounts();
			    loadSnoozeCount();
				swal("", +response["updatedRemarksArr"].length +" Alert(s) have been acknowledged and " +response["snoozedArr"].length +" " + "Alert(s) have been paused!!" , "success");
				populateRemarksDataTable('Remarks');
			}  else if(response["updatedRemarksArr"].length > 0 && response["snoozedArr"].length == 0  && response["alreadySnoozedArr"].length == 0) {  //Success
			    loadCounts();
			    loadSnoozeCount();
				swal("", +response["updatedRemarksArr"].length +" Alert(s) have been acknowledged!!" , "success");
				populateRemarksDataTable('Remarks');
			} else if(response["updatedRemarksArr"].length == 0 && response["snoozedArr"].length > 0  && response["alreadySnoozedArr"].length == 0) {  //Success
			    loadCounts();
			    loadSnoozeCount();
				swal("", +response["snoozedArr"].length +" Alert(s) have been paused!!" , "success");
				populateRemarksDataTable('Remarks');
			} else if (response["updatedRemarksArr"].length > 0 && response["snoozedArr"].length > 0 && response["alreadySnoozedArr"].length > 0) { 
			    loadCounts();
			    loadSnoozeCount();
				swal("Alert!!", " " + "Vehicle No has Already Snoozed for 2 times You cant snooze it more " +  " " + response["alreadySnoozedArr"]+  " " +response["updatedRemarksArr"].length +" Alert(s) have been acknowledged and " +response["snoozedArr"].length +" " + "Alert(s) have been paused!!" ,"warning");
				populateRemarksDataTable('Remarks');
			} else if (response["updatedRemarksArr"].length > 0  && response["alreadySnoozedArr"].length > 0) { 
			    loadCounts();
			    loadSnoozeCount();
			    swal("Alert!!", " " + "Vehicle No has Already Snoozed for 2 times You cant snooze it more " +  " " + response["alreadySnoozedArr"]+  " " +response["updatedRemarksArr"].length +" Alert(s) have been acknowledged "  ,"warning");
				populateRemarksDataTable('Remarks');
			} else if (response["snoozedArr"].length > 0  && response["alreadySnoozedArr"].length > 0) { 
			    loadCounts();
			    loadSnoozeCount();
				swal("Alert!!", " " + "Vehicle No has Already Snoozed for 2 times You cant snooze it more " +  " " + response["alreadySnoozedArr"]+  " " +response["snoozedArr"].length +" Alert(s) have been paused!! "  ,"warning");
				populateRemarksDataTable('Remarks');
			} else if(response["alreadySnoozedArr"].length > 0){
			    swal("Alert!!", " " + "Vehicle No has Already Snoozed for 2 times You cant snooze it more " + " " + response["alreadySnoozedArr"]+ "","warning");
			    populateRemarksDataTable('Remarks');  
			}else if(response["oldRemarksArr"].length > 0 && response["updatedRemarksArr"].length == 0 && response["snoozedArr"].length == 0 && response["alreadySnoozedArr"].length == 0){
			    swal("Alert!!", " " + "Please modify atleast one Alert" + " " ,"warning");
			    populateRemarksDataTable('Remarks');  
			}
         }
    });
    }
    }
    
   
var noOfRows = 0;
var currentType = "";


function OpenDataTable(id, headerText, type) {
   headerTextGlobal = headerText;
    currentType = type;
   $("#datatable" + id).modal("show");
   $('#datatable' + id + 'Header').html(headerText);
    populateRemarksDataTable(id);
}

function populateRemarksDataTable(id){
	if ($.fn.DataTable.isDataTable('#myTable' + id)) {
        $('#myTable' + id).DataTable().clear().destroy();
    }
    $('#myTable' + id).html("");
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getAlertDetails',
        datatype: "application/json",
        data: {
            alertId: currentType,
            userId: userId
        },
        success: function(result) {
         result = JSON.parse(result);
         dataSet = result.alertDetails;
            var my_columns = [];
            var headers = Object.keys(dataSet[0]).reduce((a, c) => (a[c] = dataSet[0][c], a), {});
            $.each(headers, function(key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = value;
                my_columns.push(my_item);
            });
          dataSet.splice(0, 1);
           if(currentType!=0){
            $.each(dataSet, function(key, value) {
           		dataSet[key][my_columns.length.toString()] = "<input style='width:200px;' id='input" + noOfRows + "' slNo='" + dataSet[key][2] + "' value='' placeholder='Enter Remarks'/>";
          		 dataSet[key][(my_columns.length -1).toString()] = "<select style='width:200px;height: 23px;' id='select" + noOfRows + "' slNo='" + dataSet[key][2] + "'><option value=''>hh:mm</option><option value='15'>00:15</option><option value='30'>00:30</option><option value='60'>01:00</option></select>";
                noOfRows++;
            });
            }else{
              $.each(dataSet, function(key, value) {
           		dataSet[key][my_columns.length.toString()] = "<input style='width:200px;' id='input" + noOfRows + "' slNo='" + dataSet[key][2] + "' value= '"+dataSet[key][13]+"' placeholder='Enter Remarks'/>";
          		 dataSet[key][(my_columns.length -1).toString()] = "<select style='width:200px;height: 23px;' id='select" + noOfRows + "' slNo='" + dataSet[key][2] + "'><option value=''>hh:mm</option><option value='15'>00:15</option><option value='30'>00:30</option><option value='60'>01:00</option></select>";
                noOfRows++;
            }); 
            }
           
             setTimeout(function() {
                let dtTemp = $('#myTable' + id).DataTable({
                    "columnDefs": [{
                        "className": "dt-left",
                        "targets": "_all"
                    }],
                    "scrollX": true,
                    "scrollY": 250,
                    data: dataSet,
                    paging: false,
                    "bSort": false,
                    "columns": my_columns,
                    "dom": 'Bfrtip',
                    buttons: [{
                        extend: 'excel',
                        text: 'Export to Excel',
                        className: "btn btn-primary",
                        title: headerTextGlobal + " Report"
                    }],
                });
                dtTemp.columns([0,1]).visible(false);
            }, 200)


        }
    })
}

function closetable(id) {
    $('#datatable' + id).css({
        'height': '0px'
    });
    if (id == "3") {
        $("html, body").animate({
            scrollTop: 0
        }, 1000);
    }
}

$(document).ready(function() {
$('[data-toggle="tooltip"]').tooltip(); 
  
    $("#loader").addClass("active");
    if ('<%=roleName%>' == 'CT Admin' || '<%=roleName%>' == 'Super Admin' || '<%=roleName%>' == 'T4u Users') {

        $('#userNames').show();
        $('#viewId').show();
        loadUsers();
        userId = $('#userNames').val();
    } else {
        $('#userNames').hide();
        $('#viewId').hide();
    }
    loadDataTable('');
    loadCounts();
    loadSnoozeCount();

    $("#dateInput1").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '100%',
        height: '25px',
        max: new Date()
    });
    $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
    $("#dateInput2").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '100%',
        height: '25px',
        max: currentDate
    });
    $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

    $('#dateInput1').on('change', function(event) {
        calculatedelay();
    });
    $('#dateInput2').on('change', function(event) {
        calculatedelay();
    });
});
var tripId = 0;
var customerRefId = "";
var vehicleNo = "";

function addRemarks(tripIdBackend, customerRefIdBackend, vehicleNoBackend) {
    $("#addRemarksId").modal("show");
    tripId = tripIdBackend;
    customerRefId = customerRefIdBackend;
    vehicleNo = vehicleNoBackend;
    loadDelayType();
    calculatedelay();
}
function loadUsers() {
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getUsers',
        success: function(response) {
            userList = JSON.parse(response);
            for (var i = 0; i < userList["userRoot"].length; i++) {
                $('#userNames').append($("<option></option>").attr("value", userList["userRoot"][i].userId).text(userList["userRoot"][i].userName));
            }
            $('#userNames').select2();
        }
    });
}

function loadDataTable(type) {
    $('#loading-div').show();
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCTUserDashboardListDetails',
        data: {
            user: userId,
            type: type
        },
        method: 'POST',
        success: function(result) {
            let rows = [];
            data = JSON.parse(result);
            $.each(data.getCTUserDashboardListDetailsRoot, function(i, item) {
                let row = {
                    "0": item.slNo,
                    "1": item.customername,
                    "2": item.tripno,
                    "3": item.vehicleno,
                    "4": item.gpsstatus,
                    "5": item.routekey,
                    "6": item.allTouchPoints,
                    "7": item.currentspeed,
                    "8": item.status,
                    "9": item.ATD,
                    "10": item.destinationeta,
                    "11": item.drivers,
                    "12": item.drivercontacts,
                    "13": item.delayReason,
                    "14": item.plannedTemperature == null ? "" : item.plannedTemperature,
                    "15": item.actualTemperature == null ? "" : item.actualTemperature,
                    "16": item.lastDelayUpdatedTime == null ? "" : item.lastDelayUpdatedTime,
                    "17": item.delayType == null ? "" : item.delayType,
                    "18": item.transitDelay == null ? "" : item.transitDelay
                };
                rows.push(row);
            })
            if ($.fn.DataTable.isDataTable("#ctuserTable")) {
                $('#ctuserTable').DataTable().clear().destroy();
            }

            ctuserTable = $('#ctuserTable').DataTable({
                "scrollY": "400px",
                "scrollX": true,
                footer: false,
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: "btn btn-primary",
                    title: 'CT User List View Details',
                    exportOptions: {
                        columns: [1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18]
                    }
                }],
                columnDefs: [{
                        width: 500,
                        targets: 9
                    }

                ],
            });
            ctuserTable.rows.add(rows).draw();
            $('#loading-div').hide();
        }
    });

}

function loadCounts() {
    //To Load CT User Trip related Count details
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCTUserDashboardVehicleCounts',
        method: 'POST',
        "dataSrc": "dashboardTripVehicleRoot",
        data: {
            user: userId
        },
        success: function(response) {
            var countJSON = JSON.parse(response).dashboardTripVehicleRoot;
            $("#inTransitCount").html(countJSON.intransit)
            $("#nonCommCount").html(countJSON.nonCommunicating)
            $("#totalVehicles").html(countJSON.totalVehicle)
            $("#plannedCount").html(countJSON.planned)
        }
    });

    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCTUserDashboardTripCounts',
        method: 'POST',
        "dataSrc": "dashboardTripCountRoot",
        data: {
            user: userId
        },

        success: function(response) {
            var countJSON = JSON.parse(response).dashboardTripCountRoot;
            $("#breakdown").html(countJSON.breakdown)
            $("#accident").html(countJSON.accident)
            $("#loading").html(countJSON.loading)
            $("#loadingLessThan24Hrs").html(countJSON.loadingLessThan)
            $("#loadingGreaterThan24Hrs").html(countJSON.loadingGreater)
            $("#atUnloading").html(countJSON.unloading)
            $("#delay").html(countJSON.delayed)
            $("#lessThan24Hr").html(countJSON.unloadingLessThan)
            $("#lessThanOneHr").html(countJSON.delayedLessThan)
            $("#greaterThan24Hour").html(countJSON.unloadingGreater)
            $("#onTime").html(countJSON.ontime)
            $("#greaterThanOneHour").html(countJSON.delayedGreaterThan)
           // $("#departureDelay").html(countJSON.delayedDeparture)
        }
    });

    //To Load CT User Alert related Count details
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCTUserDashboardAlertCounts',
        method: 'POST',
        "dataSrc": "dashboardAlertCountRoot",
        data: {
            user: userId
        },
        success: function(response) {
            var countJSON = JSON.parse(response).dashboardAlertCountRoot;
            $("#enrouteShDetention").html(countJSON.enrouteSHDetention)
            $("#enrouteHubDetention").html(countJSON.enrouteCHDetention)
            $("#touchPointMiss").html(countJSON.touchPointMissing)
            $("#routeDeviation").html(countJSON.routeDeviation)
            $("#nonCommunicatingVehicle").html(countJSON.nonCommunicatingVehicle)
            $("#unplannedStoppage").html(countJSON.unplannedStoppage)
            $("#smartHubMiss").html(countJSON.smartHubMiss)
            $("#tempDeviation").html(countJSON.tempDeviation)
            $("#idleAlert").html(countJSON.idleAlert)
        }
    });
}

function loadSnoozeCount(){
	$.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getCTUserDashboardSnoozeCounts',
        method: 'POST',
        "dataSrc": "dashboardSnoozeCountRoot",
        data: {
            user: userId
        },
        success: function(response) {
            var countJSON = JSON.parse(response).dashboardSnoozeCountRoot;
            $("#paused").html(countJSON.pausedAlert)
            console.log(countJSON.snoozeTime);
            if(countJSON.snoozeTime > 0){
            	$('#paused').addClass("blink");
            } else {
           		$('#paused').removeClass("blink");
            }
        }
    });
}

function showTripAndAlertDetails(tripNo, vehicleNo, startDate, endDate, status, routeId) {
    var startDate = startDate.replace(/-/g, " ");
    var endDate = endDate.replace(/-/g, " ");
    var actualDate = "";
    window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
}

function viewTouchPoints(tripNo) {
    $("#TouchPointsModal").modal("show");
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getAllTouchPointNames',
        method: 'GET',
        data: {
            tripNo: tripNo
        },
        contentType: 'application/json',
        success: function(result) {
            let rows = [];
            var data = JSON.parse(result);
            $.each(data.getAllTouchPointDetailsRoot, function(i, item) {
                let row = {
                    "0": i + 1,
                    "1": item.touchpointname,
                    "2": item.detention,
                };
                rows.push(row);
            });

            setTimeout(function() {
                if ($.fn.DataTable.isDataTable("#touchPointTable")) {
                    $('#touchPointTable').DataTable().clear().destroy();
                }
                touchPointTable = $('#touchPointTable').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    },
                    dom: 'Bfrtip',
                    buttons: [{
                        extend: 'excel',
                        text: 'Export to Excel',
                        className: "btn btn-primary",
                        title: 'Touch Point Excel'
                    }]
                });
                touchPointTable.rows.add(rows).draw();
            }, 200);
        }
    })
}

function loadDelayType() {
    $("#delayTypeId").empty().select2();
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getDelayType',
        success: function(response) {
            issueList = JSON.parse(response);
            $('#delayTypeId').append($("<option></option>").attr("value", "Select Delay Type").text("Select Delay Type"));
            for (var i = 0; i < issueList["subIssueTypeRoot"].length; i++) {
                $('#delayTypeId').append($("<option></option>").attr("value", issueList["subIssueTypeRoot"][i].subIssueType).text(issueList["subIssueTypeRoot"][i].subIssueType));
            }
        }
    });
}

function calculatedelay() {
    var starttime = document.getElementById("dateInput1").value;

    var endtime = document.getElementById("dateInput2").value;
    starttime = getDateObject(starttime);
    endtime = getDateObject(endtime);
    var delay = gettimediff(starttime, endtime);
    $('#delayId').val(delay);

}

function getDateObject(datestr) {
    var parts = datestr.split(' ');
    var dateparts = parts[0].split('/');
    var day = dateparts[0];
    var month = parseInt(dateparts[1]) - 1;
    var year = dateparts[2];
    var timeparts = parts[1].split(':')
    var hh = timeparts[0];
    var mm = timeparts[1];
    var ss = timeparts[2];
    var date = new Date(year, month, day, hh, mm, ss, 00);
    return date;
}

function gettimediff(t1, t2) {
    var diff = t2 - t1;
    var hours = Math.floor(diff / 3.6e6);
    var minutes = Math.floor((diff % 3.6e6) / 6e4);
    var seconds = Math.floor((diff % 6e4) / 1000);
    if (hours < 10 && hours >= 0) {
        hours = "0" + hours;
    }
    if (minutes < 10 && minutes >= 0) {
        minutes = "0" + minutes;
    }
    if (seconds < 10 && seconds >= 0) {
        seconds = "0" + seconds;
    }
    var duration = hours + ":" + minutes + ":" + seconds;
    return duration;
}

function saveRemarksData() {
    if ($('#delayTypeId').val() == 'Select Delay Type' || $('#delayTypeId').val() == '0') {
        swal("Error!", "Please enter Delay Type", "error");
        return;
    }
    startdate = new Date(document.getElementById("dateInput1").value);
    enddate = new Date(document.getElementById("dateInput2").value);
    if (startdate > enddate) {
        swal("Error!", "Delay End Time should be greater than Delay Start Time", "error");
        return;
    }
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=saveRemarksDetails',
        data: {
            delayType: $('#delayTypeId').val(),
            delay: $('#delayId').val(),
            remarks: $('#remarksId').val(),
            tripId: tripId,
            customerRefId: customerRefId,
            startDate: $('#dateInput1').val(),
            endDate: $('#dateInput2').val(),
            vehicleNo: vehicleNo
        },
        success: function(response) {
            if (response.includes("error")) {
                swal("Error!!", response, "error");
            } else {
                $("#addRemarksId").modal("hide");
                swal(" Delay Sucessfully Added!!", response, "success");
            }
            document.getElementById("remarksId").value = "";
            $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);

            $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
            $("#delayTypeId").empty().select2();
            document.getElementById("delayId").value = "00:00:00";
        }
    });
}

function viewRemarks(tripId) {
    $("#viewDelayModal").modal("show");
    $.ajax({
        url: '<%=request.getContextPath()%>/CTDashboardAction.do?param=getDelayReasons',
        data: {
            tripId: tripId
        },
        method: 'POST',
        success: function(result) {
            let rows = [];
            data = JSON.parse(result);
            $.each(data.delayReasonDetailsRoot, function(i, item) {
                let row = {
                    "0": item.slNo,
                    "1": item.customername,
                    "2": item.tripno,
                    "3": item.vehicleno,
                    "4": item.delayType,
                    "5": item.delayCategory,
                    "6": item.location,
                    "7": item.delayStart,
                    "8": item.delayEnd,
                    "9": item.delayTime,
                    "10": item.remarks,
                    "11": item.addedBy,
                    "12": item.addedDate
                };
                rows.push(row);
            })
            if ($.fn.DataTable.isDataTable("#delayReasonDetailsTable")) {
                $('#delayReasonDetailsTable').DataTable().clear().destroy();
            }
            delayReasonDetailsTable = $('#delayReasonDetailsTable').DataTable({
                "scrollY": "335px",
                "scrollX": true,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                footer: false,
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: "btn btn-primary",
                    title: 'Delay Reason Details'
                }],
                columnDefs: [{
                    width: 500,
                    targets: 9
                }],
            });
            delayReasonDetailsTable.rows.add(rows).draw();
        }
    });
}

function viewData() {
    userId = $('#userNames').val();
    loadDataTable('');
    loadCounts();
    loadSnoozeCount();

}

function refreshData() {
    if ('<%=roleName%>' == 'CT Admin' || '<%=roleName%>' == 'Super Admin' || '<%=roleName%>' == 'T4u Users') {

    } else {
        userId = '9999';
    }
    loadDataTable('');
    loadCounts();
    loadSnoozeCount();
    
}
setInterval(function() {
    loadDataTable('');
    loadCounts();
}, 300000); 

setInterval(function() {
    loadSnoozeCount();
}, 30000); 

</script>