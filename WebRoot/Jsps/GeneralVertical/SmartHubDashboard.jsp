<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
    String countryName = cf.getCountryName(countryId);
    Properties properties = ApplicationListener.prop;
    String vehicleImagePath = properties.getProperty("vehicleImagePath");
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
    int custId= loginInfo.getCustomerId();
    int loginUserId=loginInfo.getUserId();
%>
<jsp:include page="../Common/header.jsp" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet" />
<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet" />
<link href="../../Main/custom.css" rel="stylesheet" type="text/css">
<link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js" integrity="sha384-kW+oWsYx3YpxvjtZjFXqazFpA7UP/MbiY4jvs+RWZo2+N94PFZ36T6TFkc9O3qoB" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
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
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
<style>
    .form-control {
        display: block;
        width: 100%;
        padding: 6px 12px;
        font-size: 14px;
        line-height: 1.42857143;
        color: #555;
        background-color: #fff;
        background-image: none;
        border: 1px solid #aaa;
        -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
        box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
        -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
        -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
    }

    .enroutecard {
        border: 0.5px solid;
        height: 146px;
        width: 17% !important;
        margin-left: 8px;

    }

    .middleCard {
        width: 20.7% !important;
        border: 1px solid;
        height: 146px;
        margin-left: 6px;

    }

    .inner-row {
        border: 1px solid;
        height: 65px;
        margin-top: -2px;
    }

    .inner-text {
        margin-top: -7px;
        font-size: 10px !important;
    }

    #tripSumaryTable_wrapper {
        padding: 8px 0px 0px 0px;
    }

    #tripSumaryTable_filter {
        margin-top: -32px;
    }

    .dataTables_scroll {
        overflow: auto;
    }

    .modal {
        position: fixed;
        top: 10%;
        left: 30%;
        z-index: 1050;
        width: 800px;
        margin-left: -280px;
        margin-top: 80px;
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
    }

    .modal {
        position: fixed;
        top: 5%;
        left: 30%;
        z-index: 1050;
        width: 81%;
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
        overflow-y: hidden;
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

    .nav-tabs>li.active>a,
    .nav-tabs>li.active>a:hover,
    .nav-tabs>li.active>a:focus {
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

    td.details-control {
        background: url('../../Main/images/details_open.png') no-repeat center center;
        cursor: pointer;
    }

    tr.shown td.details-control {
        background: url('../../Main/images/details_close.png') no-repeat center center;
    }

    .sweet-alert button.cancel {
        background-color: #d9534f !important;
    }

    .sweet-alert button {
        background-color: #5cb85c !important;
    }


    .card {
        box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);
        padding: 4px;
        margin-bottom: 16px;
        border-radius: 0px !important;
        height: 35vh;
    }

    .cardSmall {
        box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);
        transition: all 0.3s cubic-bezier(.25, .8, .25, 1);


    }

    .caret {
        display: none;
    }

    /* @media only screen and (min-width: 768px) {
                   .card {height:160px;}
                 }*/
    .row {
        margin-right: 0px !important;
        margin: auto;
        width: 100%;
        margin-top: 0px;
    }

    .col-md-4 {
        padding: 0px;
    }

    .col-sm-2,
    .col-sm-1,
    .col-sm-4,
    .col-md-2,
    .col-md-1,
    .col-lg-2,
    .col-lg-1,
    .col-lg-12 {
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

    .outer-count p {
        font-size: 12px;
    }

    .outer-count h3 {
        font-size: 18px;
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

    .blueWater {
        /*  background: #7CC7DF;*/
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
        color: white !important;
        font-weight: bold !important;
    }

    .mustard {
        background: #EABC00;

    }

    .blueGrey {
        /*background: #607D8B*/
        /* background: #37474F; */
        background: #ECEFF1;
        color: black !important;
    }

    .blueGreyLight {
        /* background: #ECEFF1; */
        background: #90A4AE;
    }

    .blueGreyDark {
        /* background: #ECEFF1; */
        background: #37474F;
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
        text-align: center;
        color: white;
        padding: 4px 4px 4px 0px;
        font-weight: normal !important;
    }


    .centerText {
        text-align: center;
        position: relative;
        float: left;
        top: 50%;
        left: 50%;
        font-size: 16px;
        color: white !important;
        transform: translate(-50%, -50%);
    }

    .centerTextRed {
        text-align: center;
        position: relative;
        cursor: pointer;
        float: left;
        top: 50%;
        left: 50%;
        font-size: 20px;
        transform: translate(-50%, -50%);
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
        padding: 1px;
        margin: 0px;
    }

    .col-lg-8 {
        padding: 0px;
        margin: 0px;
    }

    .col-lg-6 {
        padding: 4px;
        margin: 0px;
    }

    .center-view {
        top: 40%;
        left: 50%;
        position: fixed;
        height: 200px;
        width: 200px;
        z-index: 10000;

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

    #legend {
        background: #fff;
        padding: 10px;
        margin: 10px;
        border: 1px solid #37474F;
    }

    #legend h3 {
        margin-top: 0;
        font-size: 16px !important;
    }

    #legend img {
        vertical-align: middle;
    }

    .paddingLeft16 {
        padding-left: 16px;
    }

    .select2 {
        width: 240px !important;
    }

    .green {
        background: #00897B;
        color: white;
        border: 1px solid #00897B
    }

    .blue {
        background: #18519E;
        color: white;
        height: 32px;
        width: 200px;
        border-radius: 4px;
        border: 1px solid #18519E
    }

    < !--.multiselect {
        -->< !-- -->< !-- margin-top: -37px !important;
        -->< !-- margin-left: 92px !important;
        -->< !--
    }

    -->.btn-group.open .dropdown-toggle {
        width: 196.22px;
        height: 34px;
    }

    .multiselect-selected-text {
        width: 196.22px;
        height: 34px;
    }

    .btn-group>.btn:first-child {
        width: 196.22px;
    }

    .modal-title {
        text-align: center;
    }

    .btn .caret {
        display: none;
    }

    .multiselect-container {
        overflow-y: auto;
        height: 211px !important;
    }

    .multiselect {
        width: 245px !important;
    }
    .dataTable td {
		/* essential */
		text-overflow: ellipsis;
		width: 90px;
		white-space: nowrap;
		overflow: hidden;
		
		/* for good looks */
		padding: 5px !important;
	}
	#columnContainer5 {
		padding: 5px !important;
	    height: 30px;
	    font-weight : 700;
	}
	
	tbody td {
		font-size: 13px;
		font-weight: 500;
	}
	
	.navbar {
	    position: relative;
	    min-height: 50px;
	    margin-bottom: -2px;
	    border: 1px solid transparent;
	} 
	thead th { white-space: nowrap; }
	
	html{  overflow-y: hidden;}
	    
	.multiselect-selected-text {
	   font-weight : 500;
	}
	.btn-group>.btn:first-child {
	    width: 349.22px !important;
	}
	
	#dateInput1{
	    width: 180px !important;
	    height: 25px;
	}
	#dateInput2{
	    width: 180px !important;
	    height: 25px;
	}
	a {
	    color: white;
	    text-decoration: none;
	}
	.multiselect-container>li>a>label {
	    margin: 0;
	    height: 100%;
	    cursor: pointer;
	    font-weight: 700;
	    padding: 3px 20px 3px 40px;
	}
</style>

<div class="center-view" style="display:none;" id="loading-div">
    <img src="../../Main/images/loading.gif" alt="">
</div>

<div class="row" style="margin-bottom:8px;margin-left:8px; margin-top: -21px;">
    <div class="col-lg-2" style="font-size: 18px;">
        <strong>Smart Hub Dashboard</strong>
    </div>
    <div class="col-lg-3" style="text-align:center">
        <select id="selectSmartHub" name="selectSmartHub" multiple="multiple" onchange="loadData();"></select>
    </div>
    <div class="col-lg-2" style="text-align:right;padding-right:24px; margin-left: 60px;">
          <input type='text'  id="dateInput1">
    </div>
    <div class="col-lg-2" style="text-align:right;padding-right:24px;">
          <input type='text'  id="dateInput2">
    </div>
    
    <div class="col-lg-2" style="text-align:right;padding-right:24px;">
          <button id='exportHistory'  class='blue' onClick="exportHistory()">GET WEEKLY REPORT</button>
    </div>
</div>

<div class="row">
    <div class="col-lg-6">
        <div class="row" id="columnContainer5" style="background: brown;color: white;padding: 8px;">
            <div class="col-lg-2" style="padding-left:32px;">
            </div>
            <div class="col-lg-7" style="text-align:center;">
                Inbound Smart Hub - Leg Level
            </div>
            <div class="col-lg-2" style="text-align:center;">
            	<a href="#" id="panel-fullscreen" role="button" title="Toggle fullscreen" onclick="openFullScreen(1)"><i class="glyphicon glyphicon-resize-full"></i></a>
            </div>
        </div>
        <div class="row" style="width:100%;">
            <div class="col-lg-12 card" style="padding:4px 0px;">
                <table id="table1" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip No</th>
                            <th>Vehicle No</th>
                            <th>ETA (HH:MM)</th>
                            <th>STA wrt ATD</th>
                            <th>Delay</th>
                            <th>Net Delay</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="row" id="columnContainer5" style="background: darkblue;color: white;padding: 8px;">
            <div class="col-lg-2" style="padding-left:32px;">
            </div>
            <div class="col-lg-7" style="text-align:center;">
                 Outbound Origin - Customer Hub - Trip Level
            </div>
            <div class="col-lg-2" style="text-align:center;">
            	<a href="#" id="panel-fullscreen" role="button" title="Toggle fullscreen" onclick="openFullScreen(2)"><i class="glyphicon glyphicon-resize-full"></i></a>
            </div>
        </div>
        <div class="row" style="width:100%;">
            <div class="col-lg-12 card" style="padding:4px 0px;">
                <table id="table2" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip ID</th>
                            <th>Trip No</th>
                            <th>ATP</th>
                            <th>Placement Delay</th>
                            <th>ATD</th>
                            <th>Next Touch Point</th>
                            <th>ETA to Destination</th>
                            <th>STA wrt ATD</th>
                            <th>ATA@Destination</th>
                        </tr>
                    </thead>
                </table>

            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-6">
        <div class="row" id="columnContainer5" style="background: darkblue;color: white;padding: 8px;">
            <div class="col-lg-2" style="padding-left:32px;">
            </div>
            <div class="col-lg-7" style="text-align:center;">
                Inbound Destination - Customer Hub - Trip Level
            </div>
            <div class="col-lg-2" style="text-align:center;">
            	<a href="#" id="panel-fullscreen" role="button" title="Toggle fullscreen" onclick="openFullScreen(3)"><i class="glyphicon glyphicon-resize-full"></i></a>
            </div>
        </div>
        <div class="row" style="width:100%;">
            <div class="col-lg-12 card" style="padding:4px 0px;">
                <table id="table3" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip ID</th>
                            <th>Trip No</th>
                            <th>ETA (HH:MM)</th>
                            <th>STA</th>
                            <th>Delay</th>
                            <th>Net Delay</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="row" id="columnContainer5" style="background: brown;color: white;padding: 8px;">
            <div class="col-lg-2" style="padding-left:32px;">
            </div>
            <div class="col-lg-7" style="text-align:center;">
                Outbound Intransit Smart Hub - Leg Level
            </div>
            <div class="col-lg-2" style="text-align:center;">
            	<a href="#" id="panel-fullscreen" role="button" title="Toggle fullscreen" onclick="openFullScreen(4)"><i class="glyphicon glyphicon-resize-full"></i></a>
            </div>
        </div>
        <div class="row" style="width:100%;">
            <div class="col-lg-12 card" style="padding:4px 0px;">
                <table id="table4" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip No</th>
                            <th>Vehicle No</th>
                            <th>ATA@SH</th>
                            <th>ATD@SH</th>
                            <th>Excess Detention</th>
                        </tr>
                    </thead>
                </table>

            </div>
        </div>
    </div>
</div>
<script>
	//history.pushState({ foo: 'fake' }, 'Fake Url', 'SmartHubDashboard#');
    var table1;
    var table2;
    var table3;
    var table4;
    var smartHubList;
    var currentDate = new Date();
    var yesterdayDate = new Date();
    yesterdayDate.setDate(yesterdayDate.getDate() - 6);
    yesterdayDate.setHours(00);
	yesterdayDate.setMinutes(00);
	yesterdayDate.setSeconds(00);
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);

	function openFullScreen(id){
		var custcombo = "";
		var custselected = $("#selectSmartHub option:selected");

        custselected.each(function() {
            custcombo += $(this).val() + ",";
        });

        var combo = custcombo.split(",").join(",");
		window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/SmartHubTripDetails.jsp?table="+id+"&shids="+combo, '_blank');
	}

	function exportHistory(){
		var custcombo = "";
		var custselected = $("#selectSmartHub option:selected");

        custselected.each(function() {
            custcombo += $(this).val() + ",";
        });

        var combo = custcombo.split(",").join(",");
        if(document.getElementById("selectSmartHub").value == ""){
        	console.log('first');
    	 	sweetAlert("Please select Smart Hub");
		    return;
    	 }else if (document.getElementById("dateInput1").value == ""){
    	 	console.log('second');
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			console.log('third');
			sweetAlert("Please select End Date");
		    return;
		}else{
			console.log('fourth');
			startDate = document.getElementById("dateInput1").value;
			endDate = document.getElementById("dateInput2").value;
			
	         val = checkMonthValidation(startDate,endDate);
	         if(!val) {
	        	sweetAlert("Please select one week range");
	        	return;
	    	 }
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
		window.open("<%=request.getContextPath()%>/SmartHubWeeklyReport?hubIds=" + combo+"&startDate="+startDate+"&endDate="+endDate);
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
 	$(document).ready(function () {
	   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
	   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
	   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
	   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
	});
    function loadData() {
        $('#loading-div').show();
        var custcombo = "";
        var custselected = $("#selectSmartHub option:selected");

        custselected.each(function() {
            custcombo += $(this).val() + ",";
        });

        var combo = custcombo.split(",").join(",");

        var custselected = $("#selectSmartHub option:selected");
        console.log(custselected);
        loadInboundSmartHubDetails(combo);
        loadOutboundOriginTrips(combo);
        loadInboundDestinationTrips(combo);
        loadOutboundSmartHubTrips(combo);
        $('#loading-div').hide();
    }
    $.ajax({
        url: '<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getSmartHubs',
        success: function(result) {
            smartHubList = JSON.parse(result);
            console.log(smartHubList);
            for (var i = 0; i < smartHubList["smartHubRoot"].length; i++) {
                $('#selectSmartHub').append($("<option></option>").attr("value", smartHubList["smartHubRoot"][i].hubId).text(smartHubList["smartHubRoot"][i].name));
            }
            $('#selectSmartHub').multiselect({
                nonSelectedText: 'Select Smart Hub',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1
            });
            $("#selectSmartHub").multiselect('selectAll', true);
            $("#selectSmartHub").multiselect('updateButtonText');
        }
    });

    function loadInboundSmartHubDetails(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getInBoundSHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "inBoundSHDetails",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils", result.length);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripNo,
                        "3": item.vehicleNo,
                        "4": item.ETA,
                        "5": item.STA_WRT_STD,
                        "6": item.delay,
                        "7": item.netDelay
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table1")) {
                    $('#table1').DataTable().clear().destroy();
                }
                table1 = $('#table1').DataTable({
                    "scrollY": "23vh",
                    "scrollX": true,
                    "bLengthChange":false,
                    searching: false,
                    paging: false,
                    autoWidth: true,  
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                console.log("rows :: " + rows);
                table1.rows.add(rows).draw();
                //table1.column( 7 ).visible( false );
            }
        })
    }

    function loadOutboundOriginTrips(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getOutBoundOriginCHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "OutBoundOriginCHTrips",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils2", result);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripId,
                        "3": item.tripNo,
                        "4": item.ATP,
                        "5": item.placementDelay,
                        "6": item.ATD,
                        "7": item.nextTouchPoint,
                        "8": item.ETA,
                        "9": item.STD_WRT_ATD,
                        "10": item.ATA
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table2")) {
                    $('#table2').DataTable().clear().destroy();
                }
                table2 = $('#table2').DataTable({
                    "scrollY": "23vh",
                    "scrollX": true,
                    searching: false,
                    paging: false,
                    "bLengthChange":false,
                    autoWidth: true,  
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                table2.rows.add(rows).draw();
            }
        })
    }

    function loadInboundDestinationTrips(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getInBoundDestinationCHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "InBoundDestinationCHTrips",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils3", result);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripId,
                        "3": item.tripNo,
                        "4": item.ETA,
                        "5": item.STA,
                        "6": item.delay,
                        "7": item.netDelay
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table3")) {
                    $('#table3').DataTable().clear().destroy();
                }
                table3 = $('#table3').DataTable({
                    "scrollY": "23vh",
                    "scrollX": true,
                    searching: false,
                    paging: false,
                    autoWidth: true,  
                    "bLengthChange":false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                table3.rows.add(rows).draw();
                //table3.column( 7 ).visible( false );
            }
        })
    }

    function loadOutboundSmartHubTrips(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getOutBoundSHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "OutBoundSHTrips",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils4", result.length);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripNo,
                        "3": item.vehicleNo,
                        "4": item.ATA,
                        "5": item.ATD,
                        "6": item.excessDetention
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table4")) {
                    $('#table4').DataTable().clear().destroy();
                }
                table4 = $('#table4').DataTable({
                    "scrollY": "23vh",
                    "scrollX": true,
                    searching: false,
                    paging: false,
                    autoWidth: true,  
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                table4.rows.add(rows).draw();
            }
        })
    }
    function showTripAndAlertDetails(tripNo, vehicleNo, startDate, endDate, status, routeId) {
    var startDate = startDate.replace(/-/g, " ");
    var endDate = endDate.replace(/-/g, " ");
    var actualDate = "";
    window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
}
</script>

<jsp:include page="../Common/footer.jsp" />