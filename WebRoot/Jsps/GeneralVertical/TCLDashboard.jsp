<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
    int loginUserId=loginInfo.getUserId();
    int clientId = loginInfo.getCustomerId();
    String countryName = cf.getCountryName(countryId);
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
  	int custId= gvf.getUserAssociatedCustomerID(loginUserId,systemId);
  	Properties properties = ApplicationListener.prop;
  	String ipAddress = properties.getProperty("tclIpAaddress");
%>

<jsp:include page="../Common/header.jsp" />
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
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
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
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/solid.css" integrity="sha384-TbilV5Lbhlwdyc4RuIV/JhD8NR+BfMrvz4BL5QFa2we1hQu6wvREr3v6XSRfCTRp" crossorigin="anonymous">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/fontawesome.css" integrity="sha384-ozJwkrqb90Oa3ZNb+yKFW2lToAWYdTiF1vt8JiH5ptTGHTGcN7qdoR1F95e0kYyG" crossorigin="anonymous">
<script defer src="https://use.fontawesome.com/releases/v5.1.0/js/solid.js" integrity="sha384-Z7p3uC4xXkxbK7/4keZjny0hTCWPXWfXl/mJ36+pW7ffAGnXzO7P+iCZ0mZv5Zt0" crossorigin="anonymous"></script>
<script defer src="https://use.fontawesome.com/releases/v5.1.0/js/fontawesome.js" integrity="sha384-juNb2Ils/YfoXkciRFz//Bi34FN+KKL2AN4R/COdBOMD9/sV/UsxI6++NqifNitM" crossorigin="anonymous"></script>
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
   -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
   box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
   -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
   -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
   transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
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
   margin-top:-32px;
   }
   .dataTables_scroll {
   overflow:auto;
   }
   .select2-container {
   width: 261px !important;
   }
   #add {
   border-radius:4px;
   }
   .modal {
   position: fixed;
   top: 10%;
   left: 8%;
   z-index: 1050;
   width: 85%;
   bottom:unset;
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
   overflow-y:hidden !important;
   }
   #alertEventsTable_filter{
   margin-top:-32px;
   }
   .btn-group {
   margin-top:8px;
   }
   #alertEventsTable_length{
   padding-top: 12px;
   }
   .panel-primary {
   border:none !important;
   margin-top: 0px;
   }
   .nav-tabs {
   border-bottom: 1px dotted black;
   height:32px;
   }
   .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {
   color: #555;
   cursor: default;
   background-color: #fff;
   border: 1px dotted black;
   border-bottom-color: transparent;
   height:32px;
   padding-top:4px;
   }
   .modal-content .modal-body {
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
   .sweet-alert button.cancel
   {
   background-color: #d9534f !important;
   }
   .sweet-alert button
   {
   background-color: #5cb85c !important;
   }
   .card {
   box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
   padding: 10px;
   margin-bottom:16px;
   border-radius:0px !important;
   height:160px;
   }
   .cardSmall {
   box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
   transition: all 0.3s cubic-bezier(.25,.8,.25,1);
   }
   .caret {display: none;}
   /* @media only screen and (min-width: 768px) {
   .card {height:160px;}
   }*/
   .row {margin-right:0px !important;margin:auto;width:100%;margin-top:0px;}
   .col-md-4{padding:0px;}
   .col-sm-2, .col-sm-1, .col-sm-4, .col-md-2, .col-md-1, .col-lg-2, .col-lg-1,.col-lg-12{padding: 0px;}
   .inner-row-card{border-top:1px solid black !important;}
   .inner-row-card .col-md-4 {margin-top:16px;padding:1px;}
   .outer-count{
   text-align: center;
   }
   .outer-count p {
   font-size: 12px;
   }
   .outer-count h3 {
   font-size: 18px;
   }
   .main-count{ margin-top: 20px;
   margin-bottom: 10px;}
   .padTop{
   padding-top:10px;
   }
   .col-md-12 {
   padding: 0px;
   }
   #tripWise .col-sm-12 {padding: 0px;}
   .col-sm-12 {padding: 0px;}
   #viewBtn {height: 28px;
   padding-top: 3px;}
   .purple {
   background: #8D33AA ;
   }
   .green {
   background: #00897B ;
   color:white;
   border: 1px solid #00897B
   }
   .orange {
   background: #E9681B;
   }
   .blueWater {
   /*  background: #7CC7DF;*/
   background: #B0BEC5;}
   .blueFont {
   color: #00A1DE;
   font-weight: bold;
   }
   .brick {
   background: #C83131;
   }
   .redFont {
   color: #D32F2F;
   font-weight: bold;
   }
   .mustard {
   background: #EABC00;
   }
   .blueGrey {
   /*background: #607D8B*/
   background: #37474F;}
   .blueGreyLight {background: #ECEFF1;}
   .purpleFont {
   color: #8D33AA ;
   }
   .green {
   background: #00897B ;
   }
   .greenFont {
   color: #00897B ;
   font-weight: bold;
   }
   .blackFont {
   color: #000000 ;
   font-weight: bold;
   }
   .orangeFont {
   color: #E9681B;
   }
   .whiteFont { color:#ffffff;}
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
   text-align:center; color: white;
   padding:4px 4px 4px 0px;
   }
   .centerText {
   text-align:center;
   position: relative;
   cursor:pointer;
   float: left;
   top: 50%;
   left: 50%;
   font-size:16px;
   transform: translate(-50%, -50%);
   }
   .close {
   float:right;
   display:inline-block;
   padding:0px 12px 0px 8px;
   }
   .close:hover { cursor:pointer;}
   .left { padding: 8px 16px 8px 16px; width:100%;}
   .right { float:right;}
   .right:hover { text-decoration: underline; cursor:pointer;}
   .imageOpen {float: right;padding: 8px 12px 8px 8px;}
   #midColumn{
   -webkit-transition: all 0.5s ease;
   -moz-transition: all 0.5s ease;
   -o-transition: all 0.5s ease;
   transition: all 0.5s ease;
   }
   .col-lg-4{padding: 8px;margin:0px;}
   .col-lg-8,.col-lg-6{padding: 0px;margin:0px;}
   .center-view{
   top:40%;
   left:50%;
   position:fixed;
   height:200px;
   width:200px;
   z-index:1000000000;
   }
   .highlightText{
   text-align: center;
   padding: 2px 0px 2px 0px;
   min-height:24px;
   cursor:pointer;
   }
   .highlightRow{
   width: 30%;
   float:right;
   }
   .highlightRowLeft{
   width: 45%;
   float:left;
   }
   .infoDiv td {
   padding:4px 0px 4px 0px;
   vertical-align: top;
   line-height:12px;
   }
   #legend {
   background: #fff;
   padding: 10px;
   margin: 10px;
   border: 1px solid #37474F;
   }
   #legend h3 {
   margin-top: 0;
   font-size:12px !important;
   }
   #legend img {
   vertical-align: middle;
   }
   .green {
   background: #00897B ;
   }
   .orange {
   background: #E9681B;
   }
   .blueWater {
   /*  background: #7CC7DF;*/
   background: #B0BEC5;}
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
   /*background: #607D8B*/
   background: #37474F;}
   .blueGreyLight {background: #ECEFF1;}
   .purpleFont {
   color: #8D33AA ;
   }
   .greenFont {
   color: #00897B ;
   }
   .orangeFont {
   color: #E9681B;
   }
   .whiteFont { color:#ffffff;}
   .blueFont {
   color: #00A1DE;
   }
   .brickFont {
   color: #C83131;
   }
   .mustardFont {
   color: #EABC00;
   }
   #map{
   width: 100%;
   height: 327px !important;
   position: relative;
   overflow: hidden;
   border: 1px solid rgba(0, 0, 0, 0.25);
   box-shadow: rgba(0, 0, 0, 0.25) 0px 1px 1px;
   }
   #openDoor{
   margin-top: 20px !important;
   }
   #closingLimitCrossed{
   margin-top: 20px !important;
   }
   #unauthorizedOpening{
   margin-top: 20px !important;
   }
   #midColumn {
   width: 98%;
   margin-left: 10px;
   }
</style>
<!-- content -->
<div class="row" style="
   padding-top: 11px;
   width: 98%;
   margin-left: 10px;
   ">
   <div class="col-sm-3" id="box1" style="padding-left:0px;">
      <div class="col-lg-12 card">
         <div class="row" style="height:55%;border-bottom:1px solid #ECEFF1;">
            <div class="col-lg-12">
               <div class="centerText greenFont" style="padding-top:98px;" title="vehicleOntrip" id="vehicleOnTrip" onclick="loadMap('ontrip',10);loadTable(10)"></div>
               <div class="headerText blueGrey"><span style="margin-left:-40px;"><i class="fas fa-truck-moving" style="color:#A7FFEB;margin-right:24px;"></i>Vehicle on Trip</span></div>
            </div>
         </div>
         <div class="row" style="height:45%;">
            <div class="col-lg-6">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText"  id="onTime" title="On Time" onclick="loadMap('ontrip',11);loadTable(11)">
                        <div style="font-size:12px;">In Transit</div>
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-lg-6 ">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText" style="left:53%" id="delayed" title="Delayed" onclick="loadMap('ontrip',12);loadTable(12)">
                        <div style="font-size:12px;">Completed</div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <div class="col-sm-3" id="box2">
      <div class="col-lg-12 card">
         <div class="row" style="height:55%;border-bottom:1px solid #ECEFF1;">
            <div class="col-lg-12">
               <div class="centerText redFont" style="padding-top:70px;" title="Door Alert" id="doorAlert" onclick="loadMap('doorAlert',38);"></div>
               <div class="headerText blueGrey"><span style="margin-left:-40px;"><i class="fas fa-door-open" style="margin-right:24px;color:#D32F2F;"></i>Door Alert</span></div>
            </div>
         </div>
         <div class="row" style="height:45%;">
            <div class="col-lg-4 ">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText"  id="openDoor" title="Multiple Door Opening" onclick="loadMap('doorAlert',15);" >
                        <div style="font-size:12px;">Multiple Door Opening</div>
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-lg-4">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText"  id="closingLimitCrossed" title="Door Closing Limit Crossed" onclick="loadMap('doorAlert',16);">
                        <div style="font-size:12px;">Door Closing Limit Crossed</div>
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-lg-4 ">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText" style="left:53%" id="unauthorizedOpening" title="Unauthorized Opening" onclick="loadMap('doorAlert',17);">
                        <div style="font-size:12px;">Unauthorized Opening</div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <div class="col-sm-3" id="box3">
      <div class="col-lg-12 card">
         <div class="row" style="height:55%;border-bottom:1px solid #ECEFF1;">
            <div class="col-lg-12">
               <div class="centerText blackFont" style="padding-top:98px;" title="Temperature Alert" id="temperatureAlert" onclick="loadMap('tempAlert',99);"></div>
               <div class="headerText blueGrey" ><span style="margin-left:-40px;"><i class="fas fa-thermometer" style="margin-right:24px;"></i>Temperature Alert</span></div>
            </div>
         </div>
         <div class="row" style="height:45%;">
            <div class="col-lg-6">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText" id="aboveThresholdLimit" title="Above Threshold Limit" onclick="loadMap('tempAlert',189);">
                        <div style="font-size:12px;">Above Threshold Limit</div>
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-lg-6 ">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText" style="left:53%" id="nearingThresholdLimit" title="Nearing Threshold Limit" onclick="loadMap('tempAlert',188);">
                        <div style="font-size:12px;">Nearing Threshold Limit</div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <div class="col-sm-3" id="box4" style="padding-right:0px;">
      <div class="col-lg-12 card">
         <div class="row" style="height:55%;border-bottom:1px solid #ECEFF1;">
            <div class="col-lg-12">
               <div class="centerText blueFont" style="padding-top:98px;" title="Non-Communicating Sensor" id="nonCommunicatingSensor" onclick="openModal('N1')"></div>
               <div class="headerText blueGrey" ><span style="margin-left:-16px;"><i class="fas fa-broadcast-tower" style="color:#80D8FF;margin-right:24px;"></i>Non-Communicating Sensor</span></div>
            </div>
         </div>
         <div class="row" style="height:45%;">
            <div class="col-lg-6">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText" id="temperatureSensor" title="Temperature Sensor" onclick="openModal('N2')">
                        <div style="font-size:12px;">Temperature Sensor</div>
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-lg-6 ">
               <div class="row" style="height:100%;">
                  <div class="col-lg-12">
                     <div class="centerText" style="left:53%" id="doorSensor" title="Door Sensor" onclick="openModal('N3')">
                        <div style="font-size:12px;">Door Sensor</div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>
<div class="row" id="columnContainer">
   <div class="col-lg-12" id="midColumn">
      <div class="tabs-container blueGrey" style="color:white;">
         <ul class="nav nav-tabs">
            <li><a href="#mapViewId" data-toggle="tab" active style="margin:0px;border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;"><i class="fas fa-globe"></i></a></li>
            <li><a href="#listViewId" data-toggle="tab" style="border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;margin:0px"><i class="far fa-list-alt"></i></a></li>
            <li class="dropdown">
               <a class="dropdown-toggle" data-toggle="dropdown" href="#" style="height:32px;padding-top:4px;">Legend
               <span class="caret"></span></a>
               <ul class ="dropdown-menu" style="margin-top:4px;background: gray;">
                  <li style="line-height: 48px;font-size:12px;"><img src="/ApplicationImages/VehicleImages/ontime.svg"> Vehicle On Trip</li>
                  <li style="line-height: 48px;font-size:12px;"><img src="/ApplicationImages/VehicleImages/enroute.svg"> Temperature Alert</li>
                  <li style="line-height: 48px;font-size:12px;"><img src="/ApplicationImages/VehicleImages/delayed1hr2.svg"> Door Alert</li>
                  
               </ul>
            </li>
         </ul>
      </div>
      <div class="tab-content" id="tabs">
         <div class="tab-pane" id="mapViewId">
            <div class="col-md-12" style="margin-bottom:0px;">
               <div class="center-view" style="display:none;" id="loading-map">
                  <img src="../../Main/images/loading.gif" alt="">
               </div>
               <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
            </div>
         </div>
         <div class="tab-pane" style="border:none;" id="listViewId" >
            <div class="center-view" style="display:none;" id="loading-div">
               <img src="../../Main/images/loading.gif" alt="">
            </div>
            <div id="tableDiv">
               <table id="tripSumaryTable"  class="table table-striped table-bordered" cellspacing="0">
                  <thead style="background:#37474F;color:white;">
                     <tr>
                        <th>Sl No.</th>
                        <th>Trip Id</th>
                        <th>Vehicle No</th>
                        <th>Trip No</th>
                        <th>Make</th>
                        <th>RouteId</th>
                        <th>Cust Ref Id</th>
                        <th>Customer Name</th>
                        <th>Trip Status</th>
                        <th>Planned Datetime</th>
                        <th>Actual Trip Start Time</th>
                        <th>Actual Trip End Time</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Current Location</th>
                        <th>Driver Contact</th>
                        <th>Driver Name</th>
                        <th>Distance</th>
                        <th>Door Alert</th>
                        <th>Temp Alert</th>
                     </tr>
                  </thead>
               </table>
            </div>
         </div>
         <div class="tab-pane" id="settingsViewId">
            <div class="col-lg-12" style="margin-bottom:32px;">
               <input type="checkbox" id="box1check" onChange="checkBox('box1')" name="box1check" value="box1check" checked> Box 1<br>
               <input type="checkbox" id="box2check" onChange="checkBox('box2')" name="box2check" value="box2check" checked> Box 2<br>
               <input type="checkbox" id="box3check" onChange="checkBox('box3')" name="box3check" value="box3check" checked> Box 3<br>
               <input type="checkbox" id="box4check" onChange="checkBox('box4')" name="box4check" value="box4check" checked> Box 4<br>
               <input type="checkbox" id="box5check" onChange="checkBox('box5')" name="box5check" value="box5check" checked> Box 5<br>
               <input type="checkbox" id="box6check" onChange="checkBox('box6')" name="box6check" value="box6check" checked> Box 6<br>
            </div>
         </div>
      </div>
   </div>
</div>
<div id="add" class="modal fade">
   <div class="row blueGreyLight" style="width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
      <div  class="col-md-6">
         <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
      </div>
      <div class="col-md-6" style="text-align:right;padding-right:24px;">
         <button type="button" class="close" style="align:right;cursor:pointer;" data-dismiss="modal">&times;</button>
      </div>
   </div>
   <div class="modal-body" style="margin-top:8px;height: 100%; overflow-y: hidden;padding:0px;">
      <div class="row">
         <div class="col-lg-12" >
            <table id="alertEventsTable"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
               <thead>
                  <tr>
                     <th>Sl No</th>
                     <th>Location</th>
                     <th>DateTime</th>
                     <th>Vehicle No</th>
                     <th>Type</th>
                     <th>Value(°C)</th>
                     <th>Remarks</th>
                     <th>Acknowledge</th>
                  </tr>
               </thead>
            </table>
         </div>
      </div>
   </div>
   <br/>
   <!--<div class="modal-footer"  style="text-align: right; height:52px;" >
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>-->
</div>
<div id="adding" class="modal fade">
   <div class="row blueGreyDark" style="width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
      <div  class="col-md-6">
         <h4 id="nonCommTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
      </div>
      <div class="col-md-6" style="text-align:right;padding-right:24px;">
         <button type="button" class="close" style="align:right;cursor:pointer;" data-dismiss="modal">&times;</button>
      </div>
   </div>
   <div class="modal-body" style="margin-top:8px;height: 100%; overflow-y: hidden;padding:0px;">
      <div class="row">
         <div class="col-lg-12" >
            <table id="nonCommTable"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
               <thead>
                  <tr>
                     <th>Sl No</th>
                     <th>VehicleNo</th>
                     <th>Last Communication</th>
                     <th>Type</th>
                  </tr>
               </thead>
            </table>
         </div>
      </div>
   </div>
   <br/>
   <!--<div class="modal-footer"  style="text-align: right; height:52px;" >
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>-->
</div>
<script src = "https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyAsd4dDgCqDIWhltN0yybawmbO-0CfO8yI&region=IN" ></script> 
<script src = "//code.jquery.com/ui/1.12.1/jquery-ui.js" > </script> 

<script >
var map;
var mcOptions = {
    gridSize: 20,
    maxZoom: 100
};
var markerClusterArray = [];
var animate = "true";
var bounds = new google.maps.LatLngBounds();
var infowindow;
var infowindowOne;
var mapNew;
var tripNo;
var vehicleNo;
var startDate;
var infoWindows = [];
var groupId;
var table;
var countryName = '<%=countryName%>';
var $mpContainer = $('#map');
var flag = false;
var custId = <%=custId%>;
var status = "";

$('#tableDiv').css('visibility', 'hidden');
 setInterval(function() {
loadTable(10);
}, 60000);

loadTable(10);


function openModal(alertType) {

    $("#nonCommTitle").text("");
    $('#adding').modal('show');
    $.ajax({
        type: "GET",
        url: '<%=ipAddress%>/getNonCommDetails',
        datatype: 'json',
        contentType: "application/json",
        data: {
            alertType: alertType,
            systemId: <%=systemId%>,
            customerId: <%=clientId%>
        },
        success: function(result) {
            result = result.responseBody;
            let rows = [];
            let rowCounter = 1;
            $.each(result, function(i, item) {
                let row = {
                    "0": rowCounter,
                    "1": item.vehicleNo,
                    "2": item.gpsDateTime,
                    "3": item.alertName

                }
                rows.push(row);
                rowCounter++;
            })

            if ($.fn.DataTable.isDataTable("#nonCommTable")) {
                $('#nonCommTable').DataTable().clear().destroy();
            }

            tableN = $('#nonCommTable').DataTable({
                "scrollY": "300px",
                "scrollX": false,
                paging: false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Export to Excel',
                    class: "btn btn-primary",
                    title: 'Non Communicating Sensor Details',
                    customData: function(exceldata) {
                        exportExtension = 'Excel';
                        return exceldata;
                    }
                }]
            });
            tableN.rows.add(rows).draw();
            $('#loading-div').hide();


        }
    });
}
$(document).ready(function() {
    $("#map").css("height", $(window).height() - 350);
    $("#box1").css("height", 175);
    $("#box2").css("height", 175);
    $("#box3").css("height", 175);

	 setInterval(function() {
		getCount();
	}, 60000);
	getCount();
});
function getCount(){
	$.ajax({
        type: "GET",
        url: '<%=ipAddress%>/getDashboardCounts',
        datatype: 'json',
        contentType: "application/json",
        data: {
            systemId: <%=systemId%>,
            customerId: <%=clientId%>
        },
        success: function(result) {
            var counts = result.responseBody;
            console.log(counts);
			$("#vehicleOnTrip").empty();
            $("#onTime").empty();
            $("#delayed").empty();
            $("#doorAlert").empty();
            $("#openDoor").empty();
            $("#closingLimitCrossed").empty();
            $("#unauthorizedOpening").empty();
            $("#temperatureAlert").empty();
            $("#aboveThresholdLimit").empty();
            $("#nearingThresholdLimit").empty();
            $("#nonCommunicatingSensor").empty();
            $("#temperatureSensor").empty();
            $("#doorSensor").empty();
			
            $("#vehicleOnTrip").prepend(counts.ontripCount);
			$("#onTime").prepend("<div style='font-size:12px;'>In Transit</div> <span class='greenFont'>" + counts.ontime + "</span>");
            $("#delayed").prepend("<div style='font-size:12px;'>Completed</div> <span class='greenFont'>" + counts.delayed + "</span>");
            $("#doorAlert").prepend(counts.totalDoorAlertCount);
            $("#openDoor").prepend("<div style='font-size:12px;'>Multiple Door Opening</div> <span class='redFont'>" + counts.openDoorCount + "</span>");
            $("#closingLimitCrossed").prepend("<div style='font-size:12px;'>Door Closing Limit Crossed</div><span class='redFont'>" + counts.closingLimitCount + "</span>");
            $("#unauthorizedOpening").prepend("<div style='font-size:12px;'>Unauthorized Opening</div><span class='redFont'>" + counts.unauthorizedCount + "</span>");
            $("#temperatureAlert").prepend(counts.totalTempAlertCount);
            $("#aboveThresholdLimit").prepend("<div style='font-size:12px;'>Above Threshold Limit</div><span class='blackFont'>" + counts.aboveTLimitCount + "</span>");
            $("#nearingThresholdLimit").prepend("<div style='font-size:12px;'>Nearing Threshold Limit</div><span class='blackFont'>" + counts.nearTLimitCount + "</span>");
            $("#nonCommunicatingSensor").prepend(counts.nonCommSensorCount);
            $("#temperatureSensor").prepend("<div style='font-size:12px;'>Nearing Threshold Limit</div><span class='blueFont'>" + counts.nonCommTempSensorCount + "</span>");
            $("#doorSensor").prepend("<div style='font-size:12px;'>Door Sensor</div><span class='blueFont'>" + counts.nonCommDoorSensorCount + "</span>");
        }
    });
}
function activaTab(tab) {
    $('.nav-tabs a[href="#' + tab + '"]').tab('show');
};
activaTab('mapViewId');

// ************* Map Details
function initialize() {
    var mapOptions = {
        zoom: 4.6,
        center: new google.maps.LatLng(<%=latitudeLongitude%>), //23.524681, 77.810561),,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControl: false,
        gestureHandling: 'greedy',
        styles: [{
                "featureType": "all",
                "elementType": "labels.text.fill",
                "stylers": [{
                        "color": "#7c93a3"
                    },
                    {
                        "lightness": "-10"
                    }
                ]
            },
            {
                "featureType": "water",
                "elementType": "geometry.fill",
                "stylers": [{
                    "color": "#7CC7DF"
                }]
            }
        ]

    };
    map = new google.maps.Map(document.getElementById('map'), mapOptions);
    var trafficLayer = new google.maps.TrafficLayer();
    trafficLayer.setMap(map);

    var geocoder = new google.maps.Geocoder();

    geocoder.geocode({
        'address': countryName
    }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.setCenter(results[0].geometry.location);
        }
    });
}

// Sets the map on all markers in the array.
initialize();
var markerCluster;

function loadMap(type, alertId) {
    $('#loading-map').show();
    $.ajax({
        url: '<%=ipAddress%>/getTripAlertDetails',
        datatype: 'json',
        contentType: "application/json",
        data: {
            systemId: <%=systemId%>,
            customerId: <%=clientId%>,
            alertType: alertId
        },
        success: function(result) {
            console.log("result", result)

            var bounds = new google.maps.LatLngBounds();

            results = result.responseBody;
            var count = 0;



            for (var i = 0; i < markerClusterArray.length; i++) {
                markerClusterArray[i].setMap(null);
            }
            markerClusterArray.length = 0;

            for (var i = 0; i < results.length; i++) {
                plotSingleVehicle(type, results[i].alertType,
                    results[i].alertValue,
                    results[i].drivaerName,
                    results[i].driverNumber,
                    results[i].latitude,
                    results[i].longitude,
                    results[i].location,
                    results[i].routeName,
                    results[i].vehicleNo,
                    results[i].vehicleType,
                    results[i].groupName,
                    results[i].middleTemp,
                    results[i].endTemp, alertId
                );
                var mylatLong = new google.maps.LatLng(results[i].latitude, results[i].longitude);
            }
            $('#loading-map').hide();
            //  console.log("Maker Arrya",markerClusterArray);
            //markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
        }
    });
}
 setInterval(function() {
loadMap("ontrip", 10);
}, 60000);
loadMap("ontrip", 10);

function plotSingleVehicle(type, alertType, alertValue, driverName, driverNumber, latitude, longitude, location, routeName, vehicleNo, vehicleType, groupName, middleTemp, endTemp, alertId) {

    var imageurl;
    var sensorValue = '';
    var doorNo = '';

    if (type == "ontrip") {
        imageurl = '/ApplicationImages/VehicleImages/ontime.svg';
    }
    if (type == "tempAlert") {
        imageurl = '/ApplicationImages/VehicleImages/enroute.svg';
        sensorValue = alertValue;
    }
    if (type == "doorAlert") {
        imageurl = '/ApplicationImages/VehicleImages/delayed1hr2.svg';
        doorNo = alertValue;
    }
    if (type == "nonComm") {
        imageurl = '/ApplicationImages/VehicleImages/EnroutePlacement.svg';
    }

    image = {
        url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
        scaledSize: new google.maps.Size(20, 40), // The origin for this image is 0,0.
        origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
        anchor: new google.maps.Point(0, 32)
    };
    var pos = new google.maps.LatLng(latitude, longitude);
    var marker = new google.maps.Marker({
        position: pos,
        map: map,
        icon: image,
        vehicleNo: vehicleNo,
        alertType: alertType
    });

    markerClusterArray.push(marker);
    var coordinate = latitude + ',' + longitude;

    var content = '<div id="myInfoDiv" class="" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; height: 100%; float: left; color: #000; line-height:100%; font-size:11px; font-family: sans-serif;padding:4px;">' +
        '<table class="infoDiv">' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Group Name:&nbsp; </b></td><td>' + groupName + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Vehicle Type:&nbsp; </b></td><td>' + vehicleType + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Vehicle No:&nbsp; </b></td><td>' + vehicleNo + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Driver Name:&nbsp; </b></td><td>' + driverName + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Driver Number:&nbsp; </b></td><td>' + driverNumber + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Vehicle Location:&nbsp; </b></td><td>' + location + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>Route Name:&nbsp; </b></td><td>' + routeName + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b style="color:red;">Alert type: &nbsp;</b></td><td style="color:red;">' + alertType + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b style="color:red;">Door No: &nbsp;</b></td><td style="color:red;">' + doorNo + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>T @ Middle(C):&nbsp; </b></td><td>' + middleTemp + '</td></tr>' +
        '<tr style="border-bottom:1px solid black;"><td nowrap style="text-align:left;"><b>T @ end-door(C): &nbsp;</b></td><td>' + endTemp + '</td></tr>' +
        '<tr><td nowrap style="text-align:left;"><b>Sensor:&nbsp; </b></td><td>' + sensorValue + '</td></tr>' +
        '<tr><td nowrap style="text-align:center;" colspan="2"><button class="green" onClick="javascript:acknowledgeModal(\'' + alertId + '\',\'' + alertType + '\',\'' + vehicleNo + '\')">Acknowledge</button></td></tr>' +
        '</table>' +
        '</div>';

    infowindow = new google.maps.InfoWindow({
        content: content,
        marker: marker,
        maxWidth: 300,
        id: vehicleNo
    });

    google.maps.event.addListener(marker, 'click', (function(marker, contents, infowindow) {
        return function() {
            firstLoadDetails = 1;
            infowindow.setContent(content);
            infowindow.open(map, marker);
        };
    })(marker, content, infowindow));

    google.maps.event.addListener(marker, "dblclick", function(e) {

        acknowledgeModal(marker.alertType, marker.vehicleNo);
    });

    google.maps.event.addListener(infowindow, 'click', function() {

    });

    if (animate == "true") {
        marker.setAnimation(google.maps.Animation.DROP);
    }


}

// ************ Table for Trip Summary

var alertTable;

function acknowledgeModal(alertId, alertType, vehicleNo) {
    if (alertType == 'NA') {
        sweetAlert('No records found');
        return;
    }
    $("#tripEventsTitle").text(alertType);
    $('#add').modal('show');
    $.ajax({
        type: "GET",
        url: '<%=ipAddress%>/getAlertDetails',
        datatype: 'json',
        contentType: "application/json",
        data: {
            alertType: alertId,
            systemId: <%=systemId%>,
            customerId: <%=clientId%>,
            vehicleNo: vehicleNo
        },
        success: function(result) {
            result = result.responseBody;
            let rows = [];
            let rowCounter = 1;
            $.each(result, function(i, item) {
                var ack = "";
                var remarks = "";
                if (item.groupName == null) {
                    ack = "<button id='btn" + item.uniqueId + "'  class='green' onClick='Acknowledge(" + item.tripId + ")'>Acknowledge</button>";
                    remarks = "<div id='div" + item.uniqueId + "'><input style='width:300px;' id='txt" + item.tripId + "' type='text'/></div>";
                } else {
                    remarks = item.groupName
                }
                let row = {
                    "0": rowCounter,
                    "1": item.location,
                    "2": item.gmt,
                    "3": item.vehicleNo,
                    "4": item.alertValue,
                    "5": item.vehicleType,
                    "6": remarks,
                    "7": ack

                }
                rows.push(row);
                rowCounter++;
            })

            if ($.fn.DataTable.isDataTable("#alertEventsTable")) {
                $('#alertEventsTable').DataTable().clear().destroy();
            }

            alertTable = $('#alertEventsTable').DataTable({
                "scrollY": "300px",
                "scrollX": false,
                paging: false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Export to Excel',
                    class: "btn btn-primary",
                    title: 'SLA dashboard Trip Details',
                    customData: function(exceldata) {
                        exportExtension = 'Excel';
                        return exceldata;
                    }
                }]
            });
            alertTable.rows.add(rows).draw();
            $('#loading-div').hide();
        }
    });
}
var table;

function loadTable(alertId) {
    $('#loading-div').show();

    $.ajax({
        type: "GET",
        url: '<%=ipAddress%>/getListViewDetails',
        datatype: 'json',
        contentType: "application/json",
        data: {
            alertId: alertId,
            systemId: <%=systemId%>,
            customerId: <%=clientId%>
        },
        success: function(result) {
            result = result.responseBody;
            console.log("Table", result);
            let rows = [];
            let rowCounter = 0;
            console.log(result.length);
            if (result != 'No records found') {
                $.each(result, function(i, item) {
                    rowCounter++;
                    let row = {
                        "0": rowCounter,
                        "1": item.tripId,
                        "2": item.vehicleNo,
                        "3": item.lrNo,
                        "4": item.make,
                        "5": item.routeId,
                        "6": item.custRefId,
                        "7": item.customerName,
                        "8": item.tripStatus,
                        "9": item.plannedDateTime,
                        "10": item.actualTripStartTime,
                        "11": item.actualTripEndTime,
                        "12": item.origin,
                        "13": item.destination,
                        "14": item.currentLocation,
                        "15": item.driverContact,
                        "16": item.driverName,
                        "17": item.distance,
                        "18": item.doorAlert,
                        "19": item.tempAlert
                    }
                    rows.push(row);
                })
            }


            if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
                $('#tripSumaryTable').DataTable().clear().destroy();
            }

            table = $('#tripSumaryTable').DataTable({
                "scrollY": "300px",
                "scrollX": true,
                paging: false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Export to Excel',
                    class: "btn btn-primary",
                    title: 'SLA dashboard Trip Details',
                    customData: function(exceldata) {
                        exportExtension = 'Excel';
                        return exceldata;
                    }
                }]
            });
            table.rows.add(rows).draw();
            $('#loading-div').hide();
            $('#tableDiv').css('visibility', '');
        }

    });
}




function Acknowledge(uniqueId) {
    if ($("#txt" + uniqueId).val() == "") {
        alert("Please enter remarks for this alert.");
        return;
    }
    $("#loading").show();
    var remarks = $("#txt" + uniqueId).val();
    $.ajax({
        url: '<%=ipAddress%>/updateAcknowledgement',
        type: 'POST',
        data: JSON.stringify({
            uniqueId: uniqueId,
            remarks: $("#txt" + uniqueId).val(),
            acknowledgeBy: <%=loginUserId%>
        }),
        datatype: 'json',
        contentType: "application/json",
        success: function(result) {
            console.log(result.responseBody);
            sweetAlert(result.responseBody);
            //alertTable.ajax.reload();
            $("#loading").hide();
            $("#div" + uniqueId).html(remarks);
            $("#btn" + uniqueId).hide();
        }
    });
}

</script>

<jsp:include page = "../Common/footer.jsp" />
