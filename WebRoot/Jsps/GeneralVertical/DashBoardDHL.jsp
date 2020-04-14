<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8" %>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <% CommonFunctions cf=new CommonFunctions(); 
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
	 %>
	 
	 <jsp:include page="../Common/header.jsp" />
	 <jsp:include page="../Common/InitializeLeaflet.jsp" />
	<link rel="shortcut icon" href="">
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
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
	<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" type="text/css" rel="stylesheet">
	<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
	<script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/plug-ins/1.10.19/sorting/time.js"></script>
	<script src="https://malsup.github.io/jquery.form.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
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
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<script src="MapUtilCustom.js"></script>

	<link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
    <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	<script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	<link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
  crossorigin=""></script>
	
	
<style>
   .form-control {
   display: block;
   width: 100%;
   height: 24px;
   padding: 6px 12px;
   font-size: 14px;
   line-height: 1.42857143;
   color: #555;
   background-color: #fff;
   background-image: none;
   border: 1px solid #aaa;
   border-radius: 4px;
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
   border-radius: 4px;
   }
   .middleCard {
   width: 20.7% !important;
   border: 1px solid;
   height: 146px;
   margin-left: 6px;
   border-radius: 4px;
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
   border: solid 1px rgba(0, 0, 0, .25);
   padding: 1%;
   box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
   width: 100.1%;
   padding-left: 0px;
   margin-bottom: 32px;
   }
   .dataTables_scroll {
   overflow: auto;
   }
   .select2-container {
   width: 160px !important;
   }
   .modal {
   position: fixed;
   top: 5%;
   left: 30%;
   z-index: 1050;
   width: 800px;
   margin-left: -280px;
   background-color: #ffffff;
   border: 1px solid #999;
   border: 1px solid rgba(0, 0, 0, 0.3);
   -webkit-border-radius: 6px;
   -moz-border-radius: 6px;
   border-radius: 6px;
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
   -webkit-border-radius: 6px;
   -moz-border-radius: 6px;
   border-radius: 6px;
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
   .nav-tabs > li.active > a,
   .nav-tabs > li.active > a:hover,
   .nav-tabs > li.active > a:focus {
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
   max-height: 450px;
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
   /*box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);*/
   box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);
   /*transition: all 0.3s cubic-bezier(.25,.8,.25,1);*/
   padding: 10px;
   margin: 4px 8px 16px 0px;
   }
   .cardSmall {
   box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);
   transition: all 0.3s cubic-bezier(.25, .8, .25, 1);
   }
   .caret {
   display: none;
   }
   @media only screen and (min-width: 768px) {
   .card {
   height: 180px;
   }
   }
   .tabs-container {
   width: 100%;
   margin: auto;
   }
   .tab-content {
   width: 98.5%;
   margin: auto;
   }
   .row {
   margin-right: 0px !important;
   margin: auto;
   width: 100%;
   }
   .col-md-4 {
   padding: 0px;
   }
   .col-sm-2,
   .col-md-2,
   .col-md-1,
   .col-lg-2,
   .col-lg-1 {
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
   font-weight:bold;
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
   #viewBtn {
   height: 28px;
   padding-top: 3px;
   margin-top: 2px;
   }
   #viewButtonId {
   height: 28px;
   padding-top: 3px;
   margin-top: 2px;
   }
   .comboClassVeh{
   width: 200px;
   height: 25px;
   }
   .dataTables_scroll {
   overflow: unset !important;
   }
   .dataTables_scrollHeadInner {
   /* box-sizing: content-box; */
   width: 0px !important;
   padding-right: 0px !important;
   }
   /*	#userView {
   margin-left: 1072px;
   margin-top: -75px;
   }   */
   #atpDateInput {
   height : 18px !important;
   padding-top : 2px;
   padding-bottom : 3px;					
   }
   #atdDateInput {
   height : 18px !important;
   padding-top : 2px;
   padding-bottom : 3px;					
   }	
   .excelWidth {
   margin-right : 5px !important;
   border-radius : 6px !important;
   }		
   .multiselect-container {
   font-size:11px !important;
   overflow-x: scroll !important;
   }	
   .multiselect-container>li>a {
   margin-left: -15px;
   }
   a {
   text-decoration: none; 
   color: black; 
   }
   .table {
   width: 100%;
   max-width: 100%;
   margin-bottom: 1rem;
   background-color: transparent;
   font-size: 12px;
   }

</style>
<div class="row" id="tripWise" style="margin-bottom:8px;">
   <div class="col-sm-12" style="display:flex;flex-direction:row">
      <label style="margin-top: 7px;">Route Name:&nbsp;&nbsp;</label>
      <select class="form-control" id="route_names" multiple>
      </select>&nbsp;&nbsp;
      <label style="margin-top: 7px;">Customer:&nbsp;&nbsp;</label>
      <select class="form-control" id="cust_names" multiple>
      </select>&nbsp;&nbsp;
      <label style="margin-top: 7px;">Customer Type:&nbsp;&nbsp;</label>
      <select class="form-control" id="cust_type" multiple>
      </select>&nbsp;&nbsp;
      <label style="margin-top: 7px;">Trip Type:&nbsp;&nbsp;</label>
      <select class="form-control" id="trip_type" multiple>
      </select>&nbsp;&nbsp;
      <button id="viewButtonId" type="button" class="btn btn-primary" onclick="viewData()">View</button>&nbsp;&nbsp;
      <button id="viewBtn" type="button" class="btn btn-primary" onclick="ResetData()">Reset</button>&nbsp;&nbsp;
      <% if(hasTripCreatePermission) {%>
      <button id="stoppageAlert" type="button" class="btn btn-danger btn-sm" style="margin-left: 5px;" onclick="loadOnTripVehicleActionDetails(true)" >
      <span class="glyphicon glyphicon-envelope" title="On-Trip Vehicle Stoppage"></span>  
      </button>
      <button id="atpDelayAlert" type="button" class="btn btn-warning btn-sm" style="margin-left: 5px;display:none" onclick="showAlertOnTripATPDelay()" >
      <span class="glyphicon glyphicon-envelope" title="Trips Delayed in Reaching Source"></span>  
      </button>
      <button id="updateATA" type="button" class="btn btn-danger btn-sm" style="margin-left: 5px;background-color:#d6d606; display:none;" onclick="getTripsWhoseATAIsToBeUpdated(true)" >
      <span class="glyphicon glyphicon-envelope" title="Closed Trips Without ATA"></span>  
      </button>
      <% } %>
      <button type="button" title="Help Option" class="btn btn-primary btn-sm" style="float: right;margin-left: 5px;" onclick="helpingServlet();">
      <span class="glyphicon glyphicon-question-sign"></span>
      </button>
   </div>
</div>
<div class="row" style="margin-left:auto;width:100%;">
   <div class="col-lg-2 card">
      <div class="count outer-count" onclick="getCountsBasedOnStatus('enrouteId')">
         <a href="#">
            <h3 id="enrouteId" style="font-weight: 600;color:#7f8fa4">0</h3>
         </a>
         <p>Enroute Placement</p>
      </div>
      <div class="row" style="border-top: 1px solid;">
         <div class="col-lg-6 col-md-6 col-sm-12">
            <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('enrouteId-Ontime')">
               <a href="#">
                  <h3 id="enrouteId-Ontime" style="font-weight: 600;margin-top: -9px;color:#7f8fa4">0</h3>
               </a>
               <p>On-Time</p>
            </div>
         </div>
         <div class="col-lg-6 col-md-6 col-sm-12">
            <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('enrouteId-delay')">
               <a href="#">
                  <h3 id="enrouteId-delay" style="font-weight: 600;margin-top: -9px;color:#7f8fa4">0</h3>
               </a>
               <p>Delayed</p>
            </div>
         </div>
      </div>
   </div>
   <div class="col-lg-2 card">
      <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('onTimeId')">
         <a href="#">
            <h3 style="color: #67cc67 !important;font-weight: 600;margin-top: -19px;" id="onTimeId">0</h3>
         </a>
         <p style="font-weight: bold;">On Time</p>
      </div>
      <div class="row inner-row-card">
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('onTimeId-stoppage')">
               <a href="#">
                  <h3 id="onTimeId-stoppage" style="color: #67cc67 !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">Unplanned Stoppage</p>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('onTimeId-hubhetention')">
               <a href="#">
                  <h3 id="onTimeId-hubhetention" style="color: #67cc67 !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">SmartHub Detention</p>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('onTimeId-deviation')">
               <a href="#">
                  <h3 id="onTimeId-deviation" style="color: #67cc67 !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">Unplanned Deviation</p>
            </div>
         </div>
      </div>
   </div>
   <div class="col-lg-2 card">
      <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('delayedless1')">
         <a href="#">
            <h3 style="color: orange !important; margin-top: -19px;" id="delayedless1">0</h3>
         </a>
         <p style="font-weight: bold;">Delayed
            < 1hour
         </p>
      </div>
      <div class="row inner-row-card">
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedless1-stoppage')">
               <a href="#">
                  <h3 id="delayedless1-stoppage" style="color: orange !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">Unplanned Stoppage</p>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedless1-detention')">
               <a href="#">
                  <h3 id="delayedless1-detention" style="color: orange !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">SmartHub Detention</p>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedless1-deviation')">
               <a href="#">
                  <h3 id="delayedless1-deviation" style="color: orange !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">Unplanned Deviation</p>
            </div>
         </div>
      </div>
   </div>
   <div class="col-lg-2 card">
      <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('delayedgreater1')">
         <a href="#">
            <h3 style="color: #c30119 !important;font-weight: 600; margin-top: -19px;margin-top: -19px;" id="delayedgreater1">0</h3>
         </a>
         <p style="font-weight: bold;">Delayed > 1hour</p>
      </div>
      <div class="row inner-row-card">
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedgreater1-stoppage')">
               <a href="#">
                  <h3 id="delayedgreater1-stoppage" style="color: #c30119 !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">Unplanned Stoppage</p>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedgreater1-detention')">
               <a href="#">
                  <h3 id="delayedgreater1-detention" style="color: #c30119 !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">SmartHub Detention</p>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedgreater1-deviation')">
               <a href="#">
                  <h3 id="delayedgreater1-deviation" style="color: #c30119 !important;font-weight: 600;">0</h3>
               </a>
               <p class="inner-text">Unplanned Deviation</p>
            </div>
         </div>
      </div>
   </div>
   <div class="col-lg-1 card">
      <div class="count outer-count" style="margin-top:-8px" onclick="getCountsBasedOnStatus('unloading-detention')">
         <a href="#">
            <h3 class="highlight" id="unloading-detention" style="height:58px; color:#653f84;font-weight: 600;">0</h3>
         </a>
         <p style="margin-top: -40px;">Unloading Detention</p>
      </div>
      <div class="row inner-row-card">
         <div class="col-md-12" style="padding:0px;margin-top:-8px">
            <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('loading-detention')">
               <a href="#">
                  <h3 class="highlight" id="loading-detention" style="color:#337ab7;font-weight: 600;margin-top: -9px;">0</h3>
               </a>
               <p style="margin-top: -8px;">Loading Detention</p>
            </div>
         </div>
      </div>
      <div class="row  inner-row-card">
         <div class="col-md-12" style="padding:4px 0px 0px 0px;">
            <div class="count outer-count" onclick="getCountsBasedOnStatus('delay-late-departure')">
               <a href="#">
                  <h3 class="highlight" id="delay-late-departure" style="color:#ed0bc7;font-weight: 600;margin-top: -10px;">0</h3>
               </a>
               <p style="margin-top: -8px;">Delayed -Late Departure</p>
            </div>
         </div>
      </div>
   </div>
   <div class="col-lg-2 card">
      <div class="row">
         <div class="col-md-4">
            <div class="count outer-count" onclick="loadEvents('38','Door Alert')">
               <a href="#">
                  <h3 class="alert-count" id="doorAlertId">0/0</h3>
               </a>
               <p>Door&nbsp;&nbsp;Alert</p>
            </div>
            <div class="row alert-row">
               <div class="col-md-12">
                  <div class="count outer-count" onclick="loadEvents('999','Temperature Alert')">
                     <a href="#">
                        <h3 class="alert-count" id="tempAlertId">0/0</h3>
                     </a>
                     <p>Temp Alert</p>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count" onclick="loadEvents('3','Panic Alert')">
               <a href="#">
                  <h3 class="alert-count" id="panicAlertId">0/0</h3>
               </a>
               <p>Panic Alert</p>
            </div>
            <div class="row alert-row">
               <div class="col-md-12">
                  <div class="count outer-count" onclick="loadEvents('190','Reefer Off Alert')">
                     <a href="#">
                        <h3 class="alert-count" id="reeferOffAlertId">0/0</h3>
                     </a>
                     <p>ReeferOff Alert</p>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-md-4">
            <div class="count outer-count" onclick="loadEvents('186','Humidity Alert')">
               <a href="#">
                  <h3 class="alert-count" id="humidityAlertId">0/0</h3>
               </a>
               <p>Humidity Alert</p>
            </div>
            <div class="row alert-row">
               <div class="col-md-12">
                  <div class="count outer-count" onclick="loadEvents('85','Non Communication Alert')">
                     <a href="#">
                        <h3 class="alert-count" id="nonReportingAlertId">0/0</h3>
                     </a>
                     <p>NotComm Alert</p>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>
<div class="tabs-container">
   <ul class="nav nav-tabs">
      <li><a href="#mapViewId" data-toggle="tab" active style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">Map View</a>
      </li>
      <li><a href="#listViewId" data-toggle="tab" style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">List View</a>
      </li>
      <li class="dropdown">
         <a class="dropdown-toggle" style="height:32px;padding-top:4px;" data-toggle="dropdown" href="#">Legend
         <span class="caret"></span></a>
         <ul class="dropdown-menu" style="margin-top:4px;">
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/ontime.svg"> On Time</li>
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/enroute.svg"> EnRoute Placement</li>
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/delayed1hr.svg"> Delayed
               < 1 hr 
            </li>
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/delayed1hr2.svg"> Delayed > 1 hr </li>
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/EnroutePlacement.svg"> Loading Detention</li>
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/detention.svg"> UnLoading Detention</li>
            <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/Pink.svg"> Delayed - Late Departure</li>
         </ul>
      </li>
   </ul>
</div>
<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
   <div id="page-loader" style="margin-top:10px;display:none;">
      <img src="../../Main/images/loading.gif" alt="loader" />
   </div>
</div>
<div class="tab-content" id="tabs">
   <div class="tab-pane" id="mapViewId">
      <div class="col-md-12" style="padding:0px 16px 10px 10px !important;margin-top: -3px;margin-bottom:32px;">
         <div id="map" style="width: 102%;margin-top:5px;margin-left: -10px;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
      </div>
   </div>
   <div class="tab-pane" id="listViewId">
      <i class="fa fa-fw"></i> Trip Information
      <span id="disclimer"> (click on the below hyperlink  to view the trip details)</span>
      <input type="button" id="expBtn" class="btn btn-primary" title="Make sure pop-up is not blocked for this Browser" value="Export to Excel">
      <input type="button" id="legbtn" class="btn btn-primary" title="Make sure pop-up is not blocked for this Browser" value="Leg Wise Export">
      <input type="button" id="userSetting" class="btn btn-primary" value="User Setting" onClick="showUserTableSetting()">
      <div id="tripCss" style="margin-left : 941px; margin-top : -26px">
         <input type="radio" name="abc" value="0" class="radio1" id="0" onchange="checkRadioButton(this.id)" style="margin-left:-155px" checked> On-Trip
         <input type="radio" name="abc" value="2" class="radio1" id="2" onchange="checkRadioButton(this.id)" style="margin-left:40px"> 1 Week
         <input type="radio" name="abc" value="4" class="radio1" id="4"  onchange="checkRadioButton(this.id)" style="margin-left:40px"> 1 Month
         <input type="radio" name="abc" value="5" class="radio1" id="5"  onchange="checkRadioButton(this.id)" style="margin-left:40px"> Date Range
      </div>
      <div class="row" style="margin-top: 14px;margin-bottom: 4px;">
         <div class="col-md-6">							
         </div>
         <div class="col-md-6" style="margin-left : 744px;">
            <div class="col-md-12">
               <div class="col-md-5" id="range1">
                  <div class="col-md-12" style="margin-left: 21%;">
                     <!--margin-left: 66px;-->
                     <div class="col-md-5">
                        <!-- style="margin-right: -16%">  -->
                        <label for="staticEmail2" class="" >Start Date</label>
                     </div>
                     <div class="col-md-7" style="margin-left: -26px">
                        <input type='text'  id="startDateInput"><!-- onchange="showDateRange()">  -->
                     </div>
                  </div>
               </div>
               <div class="col-md-5" id="range2">
                  <div class="col-md-12" style="margin-left: 6px;">
                     <div class="col-md-5">
                        <!-- style="margin-right: -16%">  -->
                        <label for="staticEmail1" class="" >End Date</label>
                     </div>
                     <div class="col-md-7" style="margin-left: -34px">
                        <input type='text'  id="endDateInput"><!-- onchange="showDateRange()">   -->
                     </div>
                  </div>
               </div>
               <div class="col-md-2">
                  <div class="col-md-12">
                     <div class="col-md-7" >
                        <input type="button" id="userView" class="btn btn-primary" value="View" onClick="showViewButton()" style="height:26px;padding-top:2px;margin-left:-48px;">  
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <table id="tripSumaryTable" class="table table-striped table-bordered" cellspacing="0">
         <thead>
            <tr>
               <th rowspan="2">S. No.</th>
               <th rowspan="2">TripID</th>
               <th rowspan="2">Trip Creation Time</th>
               <th rowspan="2">Trip Creation Month</th>
               <th rowspan="2">Trip ID</th>
               <th rowspan="2">Trip No.</th>
               <th rowspan="2">Trip Type</th>
               <th rowspan="2">Trip Category</th>
               <th rowspan="2">Vehicle Number</th>
               <th rowspan="2">Customer Reference ID</th>
               <th rowspan="2">Route Key</th>
               <th rowspan="2">Route ID</th>
               <th rowspan="2">Customer Name</th>
               <th rowspan="2">Customer Type</th>
               <th rowspan="2">Make of Vehicle</th>
               <th rowspan="2">Type of Vehicle</th>
               <th rowspan="2">Length of Truck</th>
               <th rowspan="2">Driver 1 Name</th>
               <th rowspan="2">Driver 1 Contact</th>
               <th rowspan="2">Driver 2 Name</th>
               <th rowspan="2">Driver 2 Contact</th>
               <th rowspan="2">Location</th>
               <th rowspan="2">Origin City</th>
               <th rowspan="2">Destination City</th>
               <th rowspan="2">Origin</th>
               <th rowspan="2">Destination</th>
               <th rowspan="2">STP</th>
               <th rowspan="2">ATP</th>
               <th rowspan="2">Placement Delay</th>
               <th rowspan="2">Origin Hub(Loading) Detention (HH:mm:ss)</th>
               <th rowspan="2">STD</th>
               <th rowspan="2">ATD</th>
               <th rowspan="2">Departure Delay wrt STD</th>
               <th rowspan="2">Nearest Hub</th>
               <th rowspan="2">ETA to Next Hub</th>
               <th rowspan="2">Next Touching Point</th>
               <th rowspan="2">Distance to Next Touching Point (<%=unit%>)</th>
               <th rowspan="2">ETA to Next Touching Point</th>
               <th rowspan="2">STA wrt STD</th>
               <th rowspan="2">STA wrt ATD</th>
               <th rowspan="2">ETA</th>
               <th rowspan="2">ATA</th>
               <th rowspan="2">Planned Transit Time (incl. planned stoppages)</th>
               <th rowspan="2">Actual Transit Time incl. planned and unplanned stoppages</th>
               <th rowspan="2">Transit Delay (HH:mm:ss)</th>
               <th rowspan="2">Trip Status</th>
               <th rowspan="2">Reason for Delay</th>
               <th rowspan="2">Trip Distance (<%=unit%>)</th>
               <th rowspan="2">Average Speed (<%=unit%>/h)</th>
               <th rowspan="2">Trip Closure/Cancellation date Time</th>
               <th rowspan="2">Reason for cancellation</th>
               <th rowspan="2"> Destination hub(Unloading) Detention(HH:mm:ss)</th>
               <th rowspan="2"> Last Communication Stamp</th>
               <th rowspan="2">Unplanned Stoppage Time(HH:mm:ss)</th>
               <th rowspan="2">Total Truck Running Time(HH:mm:ss)</th>
               <th rowspan="2">Total Stoppage Time(HH:mm:ss)</th>
               <th rowspan="2">Customer Detention Time(HH:mm:ss)</th>
               <th rowspan="2">Flag</th>
               <th rowspan="2">Weather</th>
               <th rowspan="2" >End Date</th>
               <th rowspan="2">routeId</th>
               <th rowspan="2">Panic Alert</th>
               <th rowspan="2">Door Alert</th>
               <th rowspan="2">Non-Communicating Alert</th>
               <th rowspan="2">Fuel Consumed(L)</th>
               <th rowspan="2">LLS Mileage (<%=unit%>/L)</th>
               <th rowspan="2">OBD Mileage (<%=unit%>/L)</th>
               <th rowspan="2">INSERTED_BY</th>
               <th colspan="3" style="text-align: center;">Red Band Temp Duration %(% of actual transit time)</th>
               <th rowspan="2">Distance Flag</th>
            </tr>
            <tr>
               <th>Temp @ Reefer</th>
               <th>Temp @ Middle</th>
               <th>Temp @ Door</th>
            </tr>
         </thead>
      </table>
   </div>
</div>
<div class="">
<div id="add" class="modal-content modal fade" style="margin-top:1%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;">Panic Alert</h4>
      </div>
      <div style="margin-left: 70%;">
         <button type="button" class="close" style="align:right;" data-dismiss="modal">×</button>
      </div>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: auto;">
      <div class="row">
         <div class="col-lg-12">
            <div class="col-lg-12" style="border: solid  1px lightgray;">
               <table id="alertEventsTable" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
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
            </div>
         </div>
      </div>
   </div>
   <div class="modal-footer" style="text-align: right; height:52px;">
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
   </div>
</div>
<div class="">
   <div id="columnSetting" class="modal-content modal fade" style="margin-top:1%;margin-left:-5%;width:50%">
      <div class="modal-header">
         <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
            <h4 id="columnSettingTitle" class="modal-title" style="text-align:left; margin-left:10px;">Column Settings</h4>
         </div>
         <div style="margin-left: 70%;">
            <button type="button" class="close" style="align:right;" data-dismiss="modal">×</button>
         </div>
      </div>
      <div class="modal-body" style="height: 100%; overflow-y: auto;">
         <b>Check the items you want to display .</b>
         <br/>
         <input type="checkbox" name="select-all" id="select-all" />Select All
         <ul id="sortable">
         </ul>
      </div>
      <div class="modal-footer" style="text-align: center; height:52px;">
         <input onclick="createOrUpdateListViewColumnSetting()" type="button" class="btn btn-success" id="columnSettingSave" value="Save" />
         <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
   </div>
</div>
<div class="">
<div id="addModify" class="modal-content modal fade" id="addModifyModal" style="margin-top:1%; top: 10%;left: 41%;width: 61%;">
   <div class="modal-header">
      <h4 id="addModifyTitle" class="modal-title"></h4>
      <button type="reset" id="closebutton" class="close" style="align:right;" data-dismiss="modal">×</button>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: auto;">
      <div class="col-md-12">
         <table id="alertEventsTable" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
            <tbody>
               <tr>
                  <td>Customer View<sup><font color="red">&nbsp;*</font></sup>
                  </td>
                  <td>
                     <input id="r4" name="cusType" type="radio" value="Yes">
                     <label for="r4">Yes</label>&nbsp;&nbsp;&nbsp;&nbsp;
                     <input id="r5" name="cusType" type="radio" value="No" required="required">
                     <label for="r5">No</label>
                  </td>
               </tr>
               <tr>
                  <td>Location of delay<sup><font color="red">&nbsp;*</font></sup>
                  </td>
                  <td>
                     <input type="text" class="form-control comboClass" maxLength="60" id="locationdelayId">
                  </td>
               </tr>
               <tr>
                  <td>Delay StartDate</td>
                  <td><input type='text' id="dateInput1" ></td>
               </tr>
               <tr>
                  <td>Delay EndDate</td>
                  <td><input type='text' id="dateInput2"></td>
               </tr>
               <tr>
                  <td>Duration of Delay(HH:mm:ss)</td>
                  <td><input type="text" class="form-control comboClass" id="delayId"></td>
               </tr>
               <tr>
                  <td>Issue Type<sup><font color="red">&nbsp;*</font></sup></td>
                  <td id="issueId"><select class="comboClassVeh" id="issueComboId"  onchange="loadSubIssuesModal()" required="required" ></select></td>
               </tr>
               <tr>
                  <td>Sub-Issue Type<sup><font color="red">&nbsp;*</font></sup></td>
                  <td id="subissueId"><select class="comboClassVeh" id="subissueComboId"  maxLength="60" required="required" ></select></td>
               </tr>
               <tr>
                  <td id="optional">Remarks</td>
                  <td>
                     <input type="text" class="form-control comboClass" maxLength="60" id="remarksId">
                  </td>
               </tr>
            </tbody>
         </table>
      </div>
   </div>
   <div class="modal-footer" style="text-align: center;">
      <input id="save1" onclick="saveData()" type="button" class="btn btn-success" value="Save" />
      <button type="reset" class="btn btn-danger" id="cancelbutton" data-dismiss="modal">Cancel</button>
   </div>
</div>
<div id="onTripVehicleStoppageAlert" class="modal-content modal fade" style="margin-top:1%;margin-left:-5%;width:50%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="columnSettingTitle" class="modal-title" style="text-align:left; margin-left:10px;">On-Trip Vehicle Stoppage Detected : Before Reaching Source</h4>
      </div>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: auto;">
      <table id="vehicleStoppageAlert" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
         <tbody>
            <tr>
               <td>Customer Name</td>
               <td>
                  <div id="customerName"></div>
               </td>
            </tr>
            <tr>
               <td>Trip Id</td>
               <td>
                  <div id="tripId"></div>
               </td>
            </tr>
            <tr>
               <td>Vehicle Number</td>
               <td>
                  <div id="assetNumber"></div>
               </td>
            </tr>
            <tr>
               <td>Trip No</td>
               <td>
                  <div id="lrNumber"></div>
               </td>
            </tr>
            <tr>
               <td>Route Name</td>
               <td>
                  <div id="routeName"></div>
               </td>
            </tr>
            <tr>
               <td>Current Latitude</td>
               <td>
                  <div id="latitude"></div>
               </td>
            </tr>
            <tr>
               <td>Current Longitude</td>
               <td>
                  <div id="longitude"></div>
               </td>
            </tr>
            <tr>
               <td>Location</td>
               <td>
                  <div id="location"></div>
               </td>
            </tr>
            <tr>
               <td>Total Stop Time(HH:mm:ss)</td>
               <td>
                  <div id="duration"></div>
               </td>
            </tr>
            <tr>
               <td>Stop Begin</td>
               <td>
                  <div id="stoppageBegin"></div>
               </td>
            </tr>
         </tbody>
      </table>
   </div>
   <div class="modal-footer" style="text-align: center; height:52px;">
      <input onclick="saveOnTripVehicleStoppageAction()" type="button" id="remindLaterBtn" class="btn btn-primary" value="REMIND ME LATER" />
      <input onclick="showOnTripVehiclStoppageMap()" type="button" class="btn btn-primary" value="SHOW ON MAP" />
   </div>
</div>
<div class="">
   <div id="onTripVehicleStoppageDetails" class="modal-content modal fade" style="margin-top:1%">
      <div class="modal-header">
         <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
            <h4 id="onTripVehicle" class="modal-title" style="text-align:left; margin-left:10px;">Action Required for  Geo-fence correction</h4>
         </div>
      </div>
      <div class="modal-body" style="height: 100%; overflow-y: hidden; max-height: 509px !important;">
         <div class="row">
            <div class="col-lg-12">
               <div class="col-lg-12" style="border: solid  1px lightgray;">
                  <table id="onTripVehicleDetails" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                     <thead>
                        <tr>
                           <th>Sl No</th>
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
            </div>
         </div>
      </div>
      <div class="modal-footer" style="text-align: right; height:52px;">
         <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
   </div>
</div>
<div id="onTripVehiclStoppageMapModal" class="modal-content modal fade" style="margin-top:1%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="onTripVehicle" class="modal-title" style="text-align:left; margin-left:10px;">Action Required for - Geo fence correction</h4>
      </div>
   </div>
   <div class="col-md-12">
      <div id="dvMap" style="width: 1000px; height: 417px; margin-top: 8px; margin-left:30px;border: 1px solid gray;"></div>
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
   <div class="modal-footer" style="text-align: right; height:52px;">
      <button class="btn btn-primary" id="ackBtnId" onclick="acknowledgeOnTripVehStoppage()">ACKNOWLEDGE</button>
      <button class="btn btn-primary" id="updateLandMarkBtnId" style="display:none;" onclick="updateLandMark()">SAVE & MARK AS DONE</button>
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
   </div>
</div>
<div id="gridModal" class="modal-content modal fade" style="margin-top:1%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:0px;">View Remarks</h4>
      </div>
      <div style="margin-left: 87%;">
         <button type="button" class="close" style="align:right;" data-dismiss="modal">×</button>
      </div>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: auto;">
      <div class="row">
         <div class="col-lg-12">
            <div class="col-lg-12" style="border: solid  1px lightgray;">
               <table id="editableGrid" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                  <thead>
                     <tr>
                        <th>SLNO</th>
                        <th>USER</th>
                        <th>CUSTOMER VIEW</th>
                        <th>DATE & TIME</th>
                        <th>LOCATION OF DELAY</th>
                        <th>DELAY STARTTIME</th>
                        <th>DELAY ENDTIME</th>
                        <th>DURATION OF DELAY(HH:mm:ss)</th>
                        <th>ISSUE TYPE</th>
                        <th>SUB-ISSUE TYPE</th>
                        <th>REMARKS</th>
                        <th>ACTION</th>
                     </tr>
                  </thead>
               </table>
            </div>
         </div>
      </div>
   </div>
   <div class="modal-footer" style="text-align: right; height:52px;">
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
   </div>
</div>
<div id="tripDelayAlert" class="modal-content modal fade" style="margin-top:1%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="tripDelay" class="modal-title" style="text-align:left; margin-left:10px;">ATP not captured – Please correct!</h4>
      </div>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: auto;">
      <div class="row">
         <div class="col-lg-12" style="border: solid  1px lightgray;">
            <table id="tripDelayAlertTbl" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
               <thead>
                  <tr>
                     <th>Sl No</th>
                     <th style="display:none;">TripId</th>
                     <th>Trip No.</th>
                     <th>Vehicle Number</th>
                     <th>Route ID</th>
                     <th>STP</th>
                     <th>Current location</th>
                     <th>Map View</th>
                     <th>Acknowledge</th>
                     <th style="display:none;">Shipment Id</th>
                     <th style="display:none;">Latitude</th>
                     <th style="display:none;">Langitude</th>
                     <th style="display:none;">Duration</th>
                     <th style="display:none;">Customer Name</th>
                     <th style="display:none;">Customer Id</th>
                  </tr>
               </thead>
            </table>
         </div>
      </div>
   </div>
   <div class="modal-footer" style="text-align: right; height:52px;">
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
   </div>
</div>
<div id="myId1" class="modal-content modal fade" style="margin-top:1%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="onTripVehicle" class="modal-title" style="text-align:left; margin-left:10px;">Map View </h4>
      </div>
      <div style="margin-left: 70%;">
         <button type="button" class="close" style="align:right;" data-dismiss="modal">×</button>
      </div>
   </div>
   <div class="col-md-12">
      <div id="dvMap1" style="width: 1000px; height: 417px; margin-top: 8px; margin-left:30px;border: 1px solid gray;"></div>
      <div class="row" style="margin-left: 2px;margin-top: 7px;  display: -webkit-box;">
         <div class="col-md-4" style="padding-left: 41px; font-weight: 400;">
            <div class="">
               <label><input type="checkbox" id="showSmartHub" value="">Show Customer/Smart Hubs</label> 
            </div>
         </div>
         <div class="col-md-8" style="">
            &nbsp;&nbsp; <img src='/ApplicationImages/VehicleImages/red.png'/> &nbsp;&nbsp; Customer Hub 
            &nbsp;&nbsp; <img src='/ApplicationImages/VehicleImages/green.png'/> &nbsp;&nbsp; Smart Hub 
         </div>
      </div>
      <div>
         <h5 id="dialogBoxId" style="color:red;"></h5>
      </div>
   </div>
   <div class="modal-footer" style="text-align: right; height:52px;">
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
   </div>
</div>
<div class="modal-content modal fade" id="acknowledgeModal" style="width: 34%;margin-left: 3%;top:150px">
   <!-- Modal content-->
   <div class="modal-content">
      <div class="modal-body" align="center !important">
         <label for="remarks" style="text-align: center;">
         Remarks *
         </label>
         <textarea class="form-control rounded-0" id="remarksAckTripDelayId"
            rows="3"></textarea>
         <br />
         <table class="table table-sm table-bordered table-striped" id="ataTable">
            <tbody>
               <tr>
                  <td>
                     ATP
                  </td>
                  <td>
                     <input type="text" id="atpDateInput" class="form-control">
                  </td>
               </tr>
               <tr>
                  <td>
                     ATD
                  </td>
                  <td>
                     <input type="text" id="atdDateInput" class='form-control'>
                  </td>
               </tr>
            </tbody>
         </table>
         <button
            style="margin-left: 150px; background-color: #158e1a; border-color: #158e1a;"
            type="button" onclick="acknowledgeTripDelay()" 
            class="btn btn-success">
         Acknowledge
         </button>
         <button
            style="margin-left: 16px; background-color: #da2618; border-color: #da2618;"
            type="button" class="btn btn-warning" data-dismiss="modal" >
         Close
         </button>
      </div>
   </div>
</div>
<div id="updateATAforClosedTrips" class="modal-content modal fade" style="margin-top:1%">
   <div class="modal-header">
      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
         <h4 id="updateATAforClosedTripHeading" class="modal-title" style="text-align:left; margin-left:10px;">Closed Trips Without ATA</h4>
      </div>
   </div>
   <div class="modal-body" style="height: 100%; overflow-y: hidden; max-height: 509px !important;">
      <div class="row">
         <div class="col-lg-12">
            <div class="col-lg-12" style="border: solid  1px lightgray;">
               <table id="tripsWithoutATAAfterReachingDest" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                  <thead>
                     <tr>
                        <th>Sl No</th>
                        <th style="display:none;">trip-Id</th>
                        <th>Trip No</th>
                        <th>Vehicle Number</th>
                        <th>Trip Start Time</th>
                        <th>Trip End Time</th>
                        <th>Trip Status</th>
                        <th>Action</th>
                     </tr>
                  </thead>
               </table>
            </div>
         </div>
      </div>
   </div>
   <div class="modal-footer" style="text-align: right; height:52px;">
      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
   </div>
</div>
<div id="updateATAModal"  class="modal-content modal fade" style="margin-top: 14%;display: none;width: 600px;margin-left: 12px;" data-backdrop="static" data-keyboard="false">
   <div class="modal-content">
      <div class="modal-header" style="padding: 1px;">
         <h4 id="updateATAModalName" class="modal-title">Update ATA</h4>
         <button type="button"  class="close" 	data-dismiss="modal"> 	&times; </button>
      </div>
      <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
         <div id="page-loader1" style="margin-top: 10px; display: none;">
            <img src="../../Main/images/loading.gif" alt="loader" />
         </div>
      </div>
      <div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
         <div class="col-md-12">
            <table class="table table-sm table-bordered table-striped">
               <tbody>
                  <tr style="display : none;">
                     <td>TRIP Id</td>
                     <td><input type="text" id="tripIdATA"  disabled ></td>
                  </tr>
                  <tr>
                     <td>ATD</td>
                     <td><input type="text" id="tripStartTime"  disabled ></td>
                  </tr>
                  <tr>
                     <td>Trip Closed Time</td>
                     <td><input type="text" id="tripEndTime"   disabled ></td>
                  </tr>
                  <tr>
                     <td>ATA</td>
                     <td><input type="text" id="updtateATADate" class='form-control comboClass'  ></td>
                  </tr>
               </tbody>
            </table>
         </div>
      </div>
      <div class="modal-footer" style="text-align: center;">
         <input onclick="updateATA()" type="button" class="btn btn-primary" style="background-color: #158e1a; border-color: #158e1a;" value="Update"	 />
         <button type="reset"  class="btn btn-warning" style="background-color: #da2618 !important; border-color: #da2618 !important;"  data-dismiss="modal"> 	Close </button>
      </div>
   </div>
</div>

<script>
//history.pushState({ foo: 'fake' }, 'Fake Url', 'DashBoardDHL#');
	window.onload = callNotification();

function callNotification() {
    if (<%=hasTripCreatePermission%>) {
        placemnetDelayGetAll = false;
        setTimeout(function () {
            loadOnTripVehicleActionDetails(false); //false - Don not show popu up if not data available. 
        }, 3000);
    }
}

var map;
var mcOptions = {
    gridSize: 20,
    maxZoom: 50
};
var radioSelected;
var markerClusterArray = [];
var markerClusterArray1 = [];
var animate = "true";
var bounds = new L.LatLngBounds();
var infowindow;
var infowindowOne;
var mainPowerCount = 0;
var panicCount = 0;
var hbCount = 0;
var haCount = 0;
var restrictiveCount = 0;
var engineErrorCount = 0;
var mapNew;
var tripNo;
var vehicleNo;
var startDate;
var lineInfo = [];
var infoWindows = [];
var groupId;
var table;
var endDatehid;
var countryName = '<%=countryName%>';
var $mpContainer = $('#map');
var custId = "ALL";
var customerId = "";
var routeId = "ALL";
var custType = "ALL";
var tripType = "ALL";
var tripStatus = "";
var flag = false;
var columns = [];
var hiddenColumns = [];
var visibleColumns = [];
var columnSettingAddOrModify = "";
var userName;
var insertedby = "";
var dateEntered;
var reason;
var remarks;
var checked;
var AddOrModify;
var uniqueid = 0;
var polygons = [];
var buffermarkersmart = [];
var circlessmart = [];
var polygonsmart = [];
var polygonmarkersmart = [];
var onTripVehStoppageTripID;
var onTripVehStopLatitude;
var onTripVehStopLongitude;
var onTripVehStopTripCustId;
var onTripVehStopDetailsTableId;
var subissue = "";
var flag = 0;
var placemnetDelayGetAll = "";
var hasTripCreatePermission = <%=hasTripCreatePermission%>;

//Trip Delay Changes
var buffermarkersmart1 = [];
var polygonmarkersmart1 = [];
var circlessmart1 = [];
var polygonsmart1 = [];
var buffermarkers1 = [];
var circles1 = [];
var polygonmarkers1 = [];
var tripCustIdToShowHubs;
var tripId = '';
var vehicleNo = '';
var mapView;

function ResetData() {
    custId = "ALL";
    routeId = "ALL";
    tripStatus = "";
    custType = "ALL";
    tripType = "ALL";
    loadData(custId, routeId, custType, tripType, 0);
    loadMap(custId, routeId, tripStatus, custType, tripType);
    loadTable(custId, routeId, tripStatus, custType, tripType, 0);
    getRouteNames(routeId);
    getCustNames(custId);
    getTripCustomerType(custType);
    getProductLine(tripType);

}

$(document).ready(function () {
    $('input[type=checkbox]').on('change', function () {
        if (!this.checked) {
            console.log('unchecked checkbox');
        }
    });
    $("#map").css("height", $(window).height() - 392);
    map.invalidateSize();
    $('#dateInput1').jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '197px',
        height: '25px'
    });
    $('#dateInput2').jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '197px',
        height: '25px'
    });
    $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
    $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());

    $("#startDateInput").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy",
        showTimeButton: false,
        width: '120px',
        height: '25px'
    });
    $('#startDateInput ').jqxDateTimeInput('setDate', '');
    $("#atpDateInput").jqxDateTimeInput({
        theme: "arctic",
        formatString: "MM/dd/yyyy HH:mm",
        showTimeButton: true,
        width: '197px',
        height: '25px'
    });
    $('#atpDateInput').jqxDateTimeInput('setDate', '');
    $("#atdDateInput").jqxDateTimeInput({
        theme: "arctic",
        formatString: "MM/dd/yyyy HH:mm",
        showTimeButton: true,
        width: '197px',
        height: '25px'
    });
    $('#atdDateInput').jqxDateTimeInput('setDate', '');

    $("#endDateInput").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy",
        showTimeButton: false,
        width: '120px',
        height: '25px'
    });
    $('#endDateInput ').jqxDateTimeInput('setDate', '');

    $("#range1").hide();
    $("#range2").hide();
    $("#userView").hide();
    $('#dateInput1').on('change', function (event) {
        calculatedelay();
    });
    $('#dateInput2').on('change', function (event) {
        calculatedelay();
    });
    $("#updtateATADate").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '197px',
        height: '25px'
    });
    $('#updtateATADate').jqxDateTimeInput('setDate', new Date());
});

function activaTab(tab) {
    $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        $($.fn.dataTable.tables(true)).DataTable()
            .columns.adjust();
    });
};
activaTab('mapViewId');
loadData(custId, routeId, custType, tripType, 0);

function loadData(custId, routeId, custType, tripType, count) {
    $.ajax({
        url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDashBoardCounts",
        data: {
            custId: custId,
            routeId: routeId,
            custType: custType,
            tripType: tripType,
            count: count
        },
        "dataSrc": "vehicleCounts",
        success: function (result) {
            results = JSON.parse(result);

            $("#enrouteId").text(results["vehicleCounts"][0].enroutePlacement);
            $("#enrouteId-Ontime").text(results["vehicleCounts"][0].enrouteOntime);
            $("#enrouteId-delay").text(results["vehicleCounts"][0].enrouteDelay);
            $("#onTimeId").text(results["vehicleCounts"][0].ontimeCount);
            $("#delayedless1").text(results["vehicleCounts"][0].delayLess);
            $("#delayedgreater1").text(results["vehicleCounts"][0].delayGreater);

            $("#unloading-detention").text(results["vehicleCounts"][0].unloadingDetention);
            $("#loading-detention").text(results["vehicleCounts"][0].loadingDetention);
            $("#delay-late-departure").text(results["vehicleCounts"][0].delayLateDeparture);

            $("#delayedless1-stoppage").text(results["vehicleCounts"][0].stoppageDelayLess);
            $("#delayedless1-detention").text(results["vehicleCounts"][0].detentionDelayLess);
            $("#delayedless1-deviation").text(results["vehicleCounts"][0].deviationDelayless);
            $("#delayedgreater1-stoppage").text(results["vehicleCounts"][0].stoppagedelayGreater);
            $("#delayedgreater1-deviation").text(results["vehicleCounts"][0].deviationDelayGreater);
            $("#delayedgreater1-detention").text(results["vehicleCounts"][0].detentionDelayedGreater);

            $("#onTimeId-stoppage").text(results["vehicleCounts"][0].ontimeStoopage);
            $("#onTimeId-hubhetention").text(results["vehicleCounts"][0].ontimeDetention);
            $("#onTimeId-deviation").text(results["vehicleCounts"][0].ontimeDeviation);
        }
    });

    $.ajax({
        url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAlertCounts",
        data: {
            custId: custId,
            routeId: routeId,
            custType: custType,
            tripType: tripType,
            count: count
        },
        "dataSrc": "alertCounts",
        success: function (result) {
            results = JSON.parse(result);
            $("#doorAlertId").text(results["alertCounts"][0].doorCount);
            $("#panicAlertId").text(results["alertCounts"][0].panicCount);
            $("#nonReportingAlertId").text(results["alertCounts"][0].nonReportingCount);
            $("#tempAlertId").text(results["alertCounts"][0].tempCount);
            $("#humidityAlertId").text(results["alertCounts"][0].humidityCount);
            $("#reeferOffAlertId").text(results["alertCounts"][0].reeferCount);
        }
    });
}
// ************* Map Details
var mapView;
initialize("map", new L.LatLng(<%=latitudeLongitude%>), '<%=mapName%>','<%=appKey%>','<%=appCode%>');
var markerCluster;

function loadMap(custId, routeId, tripStatus, custType, tripType) {
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehiclesForMap',
        data: {
            custId: custId,
            routeId: routeId,
            status: tripStatus,
            custType: custType,
            tripType: tripType
        },
        "dataSrc": "MapViewVehicles",
        success: function (result) {
            results = JSON.parse(result);
            var count = 0;
            if (markerCluster) {
                map.removeLayer(markerCluster);
            }
            markerCluster = L.markerClusterGroup();

            for (var i = 0; i < results["MapViewVehicles"].length; i++) {
                if (!results["MapViewVehicles"][i].lat == 0 && !results["MapViewVehicles"][i].lon == 0) {
                    count++;
                    plotSingleVehicle(results["MapViewVehicles"][i].vehicleNo, results["MapViewVehicles"][i].lat, results["MapViewVehicles"][i].lon,
                        results["MapViewVehicles"][i].location, results["MapViewVehicles"][i].gmt,
                        results["MapViewVehicles"][i].tripStatus, results["MapViewVehicles"][i].custName, results["MapViewVehicles"][i].shipmentId,
                        results["MapViewVehicles"][i].delay, results["MapViewVehicles"][i].weather, results["MapViewVehicles"][i].driverName,
                        results["MapViewVehicles"][i].etaDest, results["MapViewVehicles"][i].etaNextPt, results["MapViewVehicles"][i].routeIdHidden,
                        results["MapViewVehicles"][i].ATD, results["MapViewVehicles"][i].status, results["MapViewVehicles"][i].tripId,
                        results["MapViewVehicles"][i].endDateHidden, results["MapViewVehicles"][i].STD,
                        results["MapViewVehicles"][i].temperatureSensorsData, results["MapViewVehicles"][i].productLine, results["MapViewVehicles"][i].Humidity, results["MapViewVehicles"][i].tripNo,
                        results["MapViewVehicles"][i].routeName, results["MapViewVehicles"][i].currentStoppageTime, results["MapViewVehicles"][i].currentIdlingTime,
                        results["MapViewVehicles"][i].speed, results["MapViewVehicles"][i].LRNO, results["MapViewVehicles"][i].driverMobile, results["MapViewVehicles"][i].routeKey);
                }
            }
            map.addLayer(markerCluster);
        }
    });
}
loadMap(custId, routeId, tripStatus, custType, tripType);

function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, tripStatus, custName, shipmentId, delay1, weather, driverName, etaDest, etaNextPt, routeId, ATD,
    status, tripId, endDate, startDate, temperatureSensorsData, productLine, Humidity, tripNo, routeName, currentStoppageTime, currentIdlingTime, speed, LRNO, driverMobile, routeKey) {
    var tempContent = '';
    var humidityContent = '';
    var Humidity;
    var temperatureSensorsDataArray;
    var temperatureSensorNameValue = '';
    var delay = delay1.split(':')[0];
    if (productLine == 'Chiller' || productLine == 'Freezer' || productLine == 'TCL') {
        temperatureSensorsDataArray = temperatureSensorsData.split(',');
        for (var i = 0; i < temperatureSensorsDataArray.length; i++) {
            temperatureSensorNameValue = temperatureSensorsDataArray[i].split('=');
            tempContent = tempContent + '<tr><td><b>' + temperatureSensorNameValue[0] + '(°C):</b></td><td>' + temperatureSensorNameValue[1] + '</td></tr>'
        }
    }

    var imageurl;
    if (tripStatus == 'ENROUTE PLACEMENT ON TIME' || tripStatus == 'ENROUTE PLACEMENT DELAYED') {
        imageurl = '/ApplicationImages/VehicleImages/enroute.svg';
    }
    if (tripStatus == 'ON TIME') {
        imageurl = '/ApplicationImages/VehicleImages/ontime.svg';
    }
    if (tripStatus == 'DELAYED' && delay < 1) {
        imageurl = '/ApplicationImages/VehicleImages/delayed1hr.svg';
    }
    if (tripStatus == 'DELAYED' && delay > 1) {
        imageurl = '/ApplicationImages/VehicleImages/delayed1hr2.svg';
    }
    if (tripStatus == 'LOADING DETENTION') {
        imageurl = '/ApplicationImages/VehicleImages/EnroutePlacement.svg';
    }
    if (tripStatus == 'UNLOADING DETENTION') {
        imageurl = '/ApplicationImages/VehicleImages/detention.svg';
    }
    if (tripStatus == 'DELAYED LATE DEPARTURE') {
        imageurl = '/ApplicationImages/VehicleImages/Pink.svg';
    }
    if (tempContent != '' && (tripStatus == 'ENROUTE PLACEMENT ON TIME' || tripStatus == 'ENROUTE PLACEMENT DELAYED')) {
        imageurl = '/ApplicationImages/VehicleImages/tempenroute.svg';
    }
    if (tempContent != '' && tripStatus == 'ON TIME') {
        imageurl = '/ApplicationImages/VehicleImages/tempontime.svg';
    }
    if (tempContent != '' && tripStatus == 'DELAYED' && delay < 1) {
        imageurl = '/ApplicationImages/VehicleImages/tempdelayed1.svg';
    }
    if (tempContent != '' && tripStatus == 'DELAYED' && delay > 1) {
        imageurl = '/ApplicationImages/VehicleImages/tempdelayed2.svg';
    }
    if (tempContent != '' && tripStatus == 'LOADING DETENTION') {
        imageurl = '/ApplicationImages/VehicleImages/temploading.svg';
    }
    if (tempContent != '' && tripStatus == 'UNLOADING DETENTION') {
        imageurl = '/ApplicationImages/VehicleImages/tempunloading.svg';
    }
    if (tempContent != '' && tripStatus == 'DELAYED LATE DEPARTURE') {
        imageurl = '/ApplicationImages/VehicleImages/tempPink.svg';
    }
    image = L.icon({
        iconUrl: String(imageurl),
        iconSize: [20, 40], // size of the icon
        popupAnchor: [0, -15]
    });
    var coordinate = latitude + ',' + longtitude;
    var delayFormat = delay1;
    var content = '<div id="" seamless="seamless" scrolling="no" style="height: 180px;overflow:auto; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
        '<table>' +
        '<tr><td><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
        '<tr><td><a href="#" data-toggle="tooltip" title="' + tripNo + '"><b>Trip Id:</b></a></td><td><a href="#" data-toggle="tooltip" title="' + tripNo + '">' + tripNo + '</a></td></tr>' +
        '<tr><td><b>Trip No:</b></td><td>' + LRNO + '</td></tr>' +
        '<tr><td><a href="#" data-toggle="tooltip" title="' + routeName + '"><b>Route Name:</b></a></td><td><a href="#" data-toggle="tooltip" title="' + routeName + '">' + routeName + '</a></td></tr>' +
        '<tr><td><b>Route Key:</b></td><td>' + routeKey + '</td></tr>' +
        '<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' +
        '<tr><td><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
        '<tr><td><b>Customer :</b></td><td>' + custName + '</td></tr>' +
        '<tr><td><b>Delay:</b></td><td>' + delayFormat + '</td></tr>' +
        '<tr><td><b>weather:</b></td><td>' + weather + '</td></tr>' +
        '<tr><td><b>Driver Name:</b></td><td>' + driverName + '</td></tr>' +
        '<tr><td><b>Driver Contact:</b></td><td>' + driverMobile + '</td></tr>' +
        '<tr><td><b>ETA to Next Hub:</b></td><td>' + etaNextPt + '</td></tr>' +
        '<tr><td><b>ETA to Destination:</b></td><td>' + etaDest + '</td></tr>' +
        '<tr><td><b>LatLong:</b></td><td>' + coordinate + '</td></tr>' +
        '<tr><td><b>Current Stoppage Time(HH.mm) :</b></td><td>' + currentStoppageTime + '</td></tr>' +
        '<tr><td><b>Current Idling Time(HH.mm):</b></td><td>' + currentIdlingTime + '</td></tr>' +
        '<tr><td><b>Speed(km/h):</b></td><td>' + speed + '</td></tr>' +
        tempContent +
        humidityContent +
        '</table>' +
        '</div>';

    marker = new L.Marker(new L.LatLng(latitude, longtitude), {
        icon: image
    });
    marker.bindPopup(content);

    markerCluster.addLayer(marker);
    markerClusterArray.push(marker);

}
// ************ Table for Trip Summary
$('#groupName').change(function () {
    routeId = $('#route_names option:selected').val();
    custId = $('#cust_names option:selected').val();
    loadTable(custId, routeId, tripStatus, custType, tripType, 1);
});
var table;
var ccount;
loadTable(custId, routeId, tripStatus, custType, tripType, 0);
var startDateRange, endDateRange;
jQuery.extend(jQuery.fn.dataTableExt.oSort, {
    "time-uni-pre": function (a) {
        var uniTime;

        if (a.toLowerCase().indexOf("am") > -1 || (a.toLowerCase().indexOf("pm") > -1 && Number(a.split(":")[0]) === 12)) {
            uniTime = a.toLowerCase().split("pm")[0].split("am")[0];
            while (uniTime.indexOf(":") > -1) {
                uniTime = uniTime.replace(":", "");
            }
        } else if (a.toLowerCase().indexOf("pm") > -1 || (a.toLowerCase().indexOf("am") > -1 && Number(a.split(":")[0]) === 12)) {
            uniTime = Number(a.split(":")[0]) + 12;
            var leftTime = a.toLowerCase().split("pm")[0].split("am")[0].split(":");
            for (var i = 1; i < leftTime.length; i++) {
                uniTime = uniTime + leftTime[i].trim().toString();
            }
        } else {
            uniTime = a.replace(":", "");
            while (uniTime.indexOf(":") > -1) {
                uniTime = uniTime.replace(":", "");
            }
        }
        return Number(uniTime);
    },

    "time-uni-asc": function (a, b) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },

    "time-uni-desc": function (a, b) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
});

function loadTable(custId, routeId, tripStatus, custType, tripType, count) {
    grouplabel = $('#groupName option:selected').attr('value');
    ccount = count;
    var startDateRange = document.getElementById("startDateInput").value;
    startDateRange = startDateRange.split("/").reverse().join("-");

    var endDateRange = document.getElementById("endDateInput").value;
    endDateRange = endDateRange.split("/").reverse().join("-");

    var userAuthority = "<%=userAuthority%>";
    if (typeof groupId === 'undefined') {
        groupId = 0;
        grouplabel = "On Trip";
    }
    table = $('#tripSumaryTable').DataTable({
        "ajax": {
            "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetailsDHL",
            "dataSrc": "tripSummaryDetails",
            "data": {
                groupId: groupId,
                unit: '<%=unit%>',
                userAuthority: userAuthority,
                custId: custId,
                routeId: routeId,
                status: tripStatus,
                startDateRange: startDateRange,
                endDateRange: endDateRange,
                custType: custType,
                tripType: tripType,
                count: count
            }
        },
        "bDestroy": true,
        "scrollY": "300px",
        "scrollX": true,
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        "dom": "<'row'<'col-sm-4 'B><'col-sm-5'<'toolbar'>><'col-sm-3'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
        buttons: ['excel', 'pdf'],
        "buttons": [{
            extend: 'pageLength'
        }],
        columnDefs: [{
            width: 100,
            targets: 2
        }, {
            width: 100,
            targets: 3
        }, {
            width: 50,
            targets: 4
        }, {
            width: 200,
            targets: 12
        }, {
            width: 150,
            targets: 13
        }, {
            width: 200,
            targets: 14
        }, {
            width: 300,
            targets: 11
        }],
        "columns": [{
                "data": "slNo", //0
                "orderable": true,
                "defaultContent": '',
                "className": 'details-control',

            }, {
                "data": "tripNo", //1
                "name": "Trip ID",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData == '') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "tripCreationTime", //1
                "name": "TripCreationTime", //1
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData == '') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "tripCreationMonth", //1
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData == '') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ShipmentId", //2,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }

            }, {
                "data": "lrNo", //3
                "name": "Trip_No",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "tripType", //4
                "name": "Trip_Type",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "tripCategory", //5
                "name": "Trip_Category",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "name": "vehicleNo",
                "data": "vehicleNo", //7

            }, {
                "data": "custRefId", //11
                "name": "Customer_Reference_ID",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "routeKey", //17
                "name": "Route_Key",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "routeName", //6
                "name": "Route_ID",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "customerName", //8
                "name": "Customer_Name",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "customerType", //9 used for Customer type
                "name": "Customer_Type",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "make", //9
                "name": "Make_of_Vehicle",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "typeOfVehicle", //9
                "name": "Type_of_Vehicle",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "vehicleLength", //10
                //"name": "Length_of_Truck",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            },

            {
                "data": "driver1Name", //12,
                "name": "Driver1_Name",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "driver1Contact", //13
                "name": "Driver1_Contact",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            },
            {
                "data": "driver2Name", //14,
                "name": "Driver2_Name",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "driver2Contact", //15
                "name": "Driver2_Contact",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "Location", //16
                "name": "Location",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "OriginCity", //18
                "name": "Origin_City",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "DestCity", //19
                "name": "Destination_City",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "origin", //20
                //"name": "Origin",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "Destination", //21
                //"name": "Destination",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "STP", //22
                "name": "STP",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ATP", //23
                "name": "ATP",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "placementDelay", //24
                "name": "Placement_Delay",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "loadingDetentionTime", //25
                "name": "Origin_Hub(Loading)_Detention",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "STD", //26
                "name": "STD",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ATD", //27
                "name": "ATD",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
                    if (rowData.distanceFlag != 'Y' && cellData != '') {
                        $(td).css('background-color', 'orange')
                    } else if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "departureDelayWrtSTD", //28
                "name": "Departure Delay wrt STD",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "nearestHub", //31
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ETHA", //32
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "nearestHub", //34
                "name": "Next_Touching_Point",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "distanceToNextHub", //33
                "name": "Distance_To_NextHub",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ETHA", //35
                "name": "ETA_to_next_Touching_Point",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "STA (WRT STD)", //29
                "name": "STA (WRT STD)",
                //"visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "STA (WRT ATD)", //30
                "name": "STA (WRT ATD)",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ETA", //36
                "name": "ETA",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "ATA", //37
                "name": "ATA",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            },
            {
                "data": "plannedTT",
                "name": "Planned_Transit_Time",
                "type": 'time-uni',
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            },
            {
                "data": "actualTT",
                "name": "Actual_Transit_Time ",
                "type": 'time-uni',
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            },
            {
                "data": "delay", //38
                "name": "Transit_Delay",
                "type": 'time-uni',
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "status", //37
                "name": "Trip_Status",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "remarks", //38
                "name": "Reason_For_Delay",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "totalDist", //43
                "name": "Total_Distance",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "avgSpeed", //44
                "name": "Average_Speed",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "closeDate", //49
                "name": "Trip_Closure_Date_Time",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "reasonForCancel", //39
                "name": "Reason_For_Cancellation",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "unloadingDetentionTime", //40
                "name": "Destination_hub(Unloading)_Detention",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "lastCommunicationStamp", //40
                "name": "Last Communication Stamp",
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "unplannedStoppage", //41
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "totalTruckRunningTime", //42
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "stoppageTime", //45
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "customerDetentionTime", //46
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "flag", //47
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "weather", //48
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "endDateHidden", //49
                "visible": false
            }, {
                "data": "routeIdHidden", //50
                "visible": false
            }, {
                "data": "panicAlert", //51
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "doorAlert", //52
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "nonReporting", //53
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "fuelConsumed", //54
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "mileage", //55
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "mileageOBD", //56
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "insertedby", //57 
                "visible": false
            }, {
                "data": "tempT1",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "tempT2",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "tempT3",
                "visible": false,
                createdCell: function (td, cellData, rowData, row, col) {
                    if (cellData === '' || cellData === 'NA') {
                        $(td).css('background-color', 'white');
                    }
                }
            }, {
                "data": "distanceFlag", //57 
                "visible": false
            }
        ],
        "order": [
            [0, 'asc']
        ]
    });

    setColumnsVisibilyBasedOnUserSetting();
    table.columns.adjust().draw();

}
setInterval(function () {
    loadMap(custId, routeId, tripStatus, custType, tripType);
    table.ajax.reload();
    if (custId == 'ALL' && routeId == 'ALL' && custType == 'ALL' && custType == 'ALL') {
        loadData(custId, routeId, custType, tripType, 0);
    } else {
        loadData(custId, routeId, custType, tripType, 1);
    }

}, 300000);
setInterval(function () {

    if (hasTripCreatePermission) {
        loadOnTripVehicleActionDetails(false);
    }
}, 900000);
setInterval(function () {
    if (hasTripCreatePermission && ($('#tripDelayAlert').is(':visible') == false)) {
        placemnetDelayGetAll = false;
    }
}, 720000);

function showAlertOnTripATPDelay() {

}

function loadTripATPDelayAlertTable() {

    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getPlacementDelayedTrip',
        "data": {
            placemnetDelayGetAll: placemnetDelayGetAll
        },
        success: function (result) {
            result = JSON.parse(result).placementDelayedTrip;
            if ((placemnetDelayGetAll == true)) {
                $('#tripDelayAlert').modal('show');
                loadOntripDelayTable(result);
            } else {
                if (result != "") {
                    loadOntripDelayTable(result);
                    $('#tripDelayAlert').modal('show');
                } else {
                    $('#tripDelayAlert').modal('hide');
                }
            }
        }
    });
}

function loadOntripDelayTable(result) {
    if ($.fn.DataTable.isDataTable('#tripDelayAlertTbl')) {
        $('#tripDelayAlertTbl').DataTable().clear().destroy();
    }
    var rows = new Array();
    if (result != "") {
        $.each(result, function (i, item) {
            var row = {
                "0": item.slNo,
                "1": item.tripId,
                "2": item.lrNumber,
                "3": item.vehicleNo,
                "4": item.routeName,
                "5": item.STP,
                "6": item.currentLocation,
                "7": item.viewMapIndex,
                "8": item.button,
                "9": item.shipmentId,
                "10": item.latitude,
                "11": item.longitude,
                "12": item.duration,
                "13": item.tripCustomerName,
                "14": item.tripCustId
            }
            rows.push(row);
        });
    } else {
        var row = {
            "0": "No Data available"
        }
    }
    tripATPdelayTable = $('#tripDelayAlertTbl').DataTable({
        paging: true,
        "serverSide": false,

        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        "dom": 'Bfrtip',
        "processing": true,
        "buttons": [{
            extend: 'pageLength'
        }, {
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary excelWidth'
        }, {
            extend: 'pdf',
            text: 'Export to PDF',
            className: 'btn btn-primary excelWidth'
        }],
    });
    tripATPdelayTable.rows.add(rows).draw();
    tripATPdelayTable.columns([1, 9, 10, 11, 12, 13, 14]).visible(false);
}

$('#tripDelayAlertTbl').unbind().on('click', 'td', function (event) {
    var table = $('#tripDelayAlertTbl').DataTable();
    var columnIndex = table.cell(this).index().column;
    var aPos = $('#tripDelayAlertTbl').dataTable().fnGetPosition(this);
    var data = $('#tripDelayAlertTbl').dataTable().fnGetData(aPos[0]);
    tripCustIdToShowHubs = data[14];
    if (columnIndex == 7) { //view button click
        showTripDelayInSourceReachMap(data);
    }
    if (columnIndex == 8) { //view button click

        if (data[8].includes("</button>")) {
            $('#acknowledgeModal').modal('show');
            tripId = data[1];
            vehicleNo = data[3];
            $('#atpDateInput').jqxDateTimeInput('setDate', '');
            $('#atdDateInput').jqxDateTimeInput('setDate', '');
            document.getElementById("remarksAckTripDelayId").value = '';
        }
    }
});


function showTripDelayInSourceReachMap(data) {
	$('#myId1').modal('show');
	$('#showSmartHub').prop("checked", false).trigger("change");
	var pos = new L.LatLng(data[10], data[11]);
	if (mapView!=null){
		mapView.remove();
	}
    initializeMapView("dvMap1", pos, '<%=mapName%>','<%=appKey%>','<%=appCode%>');
    setTimeout(function(){mapView.invalidateSize();},250);
	imageurl = '/ApplicationImages/VehicleImagesNew/MapImages/default_BR.png';
	image = L.icon({
        iconUrl: imageurl,
        iconSize: [30, 30], // size of the icon
        popupAnchor: [0, -15]
    });
	vehiclemarker = new L.Marker(pos, {
        icon: image
    }).addTo(mapView);
	
	var contentForDot = '<div id="myInfoDivForVehicle" seamless="seamless" scrolling="no" style="height:180px !important;overflow:auto; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
		'<table>' +
		'<tr><td><b>Customer name:</b></td><td>' + data[13] + '</td></tr>' +
		'<tr><td><b>Trip ID:</b></td><td>' + data[9] + '</td></tr>' +
		'<tr><td><b>Asset Number:</b></td><td>' + data[3] + '</td></tr>' +
		'<tr><td><b>Trip No:</b></td><td>' + data[2] + '</td></tr>' +
		'<tr><td><b>Route name:</b></td><td>' + data[4] + '</td></tr>' +
		'<tr><td><b>Latitude:</b></td><td>' + data[10] + '</td></tr>' +
		'<tr><td><b>Longitude:</b></td><td>' + data[11] + '</td></tr>' +
		'<tr><td><b>Location:</b></td><td>' + data[6] + '</td></tr>' +
		'</table>' +
		'</div>';
	vehiclemarker.bindPopup(contentForDot);
}

var onTripVehAlertMapInfo = {};
var stoppageBegin = "";

function showAlertOnTripVehicleStoppage() {
    if ($('#onTripVehicleStoppageDetails').is(':visible') == false && $('#onTripVehicleStoppageAlert').is(':visible') == false) {
        document.getElementById("remindLaterBtn").disabled = false;
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getOnTripVehiclesStoppage',
            success: function (response) {
                vehicleList = JSON.parse(response);
                if (vehicleList["tripVehiclesStoppage"].length > 0) {
                    $('#onTripVehicleStoppageAlert').modal('show');
                    onTripVehStopTripCustId = vehicleList["tripVehiclesStoppage"][0].tripCustomerId;
                    document.getElementById("customerName").innerHTML = vehicleList["tripVehiclesStoppage"][0].tripCustomerName;
                    onTripVehAlertMapInfo.tripCustomerName = vehicleList["tripVehiclesStoppage"][0].tripCustomerName;
                    onTripVehStoppageTripID = vehicleList["tripVehiclesStoppage"][0].tripId;
                    document.getElementById("tripId").innerHTML = vehicleList["tripVehiclesStoppage"][0].shipmentId;
                    onTripVehAlertMapInfo.shipmentId = vehicleList["tripVehiclesStoppage"][0].shipmentId;
                    document.getElementById("assetNumber").innerHTML = vehicleList["tripVehiclesStoppage"][0].assetNumber;
                    onTripVehAlertMapInfo.assetNumber = vehicleList["tripVehiclesStoppage"][0].assetNumber;
                    document.getElementById("routeName").innerHTML = vehicleList["tripVehiclesStoppage"][0].routeName;
                    onTripVehAlertMapInfo.routeName = vehicleList["tripVehiclesStoppage"][0].routeName;
                    onTripVehStopLatitude = vehicleList["tripVehiclesStoppage"][0].latitude;
                    onTripVehAlertMapInfo.latitude = vehicleList["tripVehiclesStoppage"][0].latitude;
                    document.getElementById("latitude").innerHTML = vehicleList["tripVehiclesStoppage"][0].latitude;
                    onTripVehStopLongitude = vehicleList["tripVehiclesStoppage"][0].longitude;
                    document.getElementById("longitude").innerHTML = vehicleList["tripVehiclesStoppage"][0].longitude;
                    onTripVehAlertMapInfo.longitude = vehicleList["tripVehiclesStoppage"][0].longitude;
                    document.getElementById("location").innerHTML = vehicleList["tripVehiclesStoppage"][0].location;
                    onTripVehAlertMapInfo.location = vehicleList["tripVehiclesStoppage"][0].location;
                    document.getElementById("duration").innerHTML = vehicleList["tripVehiclesStoppage"][0].duration;
                    onTripVehAlertMapInfo.duration = vehicleList["tripVehiclesStoppage"][0].duration;
                    document.getElementById("stoppageBegin").innerHTML = vehicleList["tripVehiclesStoppage"][0].stoppageBegin;
                    stoppageBegin = vehicleList["tripVehiclesStoppage"][0].stoppageBegin;
                    document.getElementById("lrNumber").innerHTML = vehicleList["tripVehiclesStoppage"][0].lrNumber;
                    onTripVehAlertMapInfo.lrNumber = vehicleList["tripVehiclesStoppage"][0].lrNumber;
                    onTripVehAlertMapInfo.status = "NEW";
                }
            }
        });
    }
}

function saveOnTripVehicleStoppageAction() {
    document.getElementById("remindLaterBtn").disabled = true;
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=insertOnTripVehicleStoppageAction',
        data: {
            tripId: onTripVehStoppageTripID,
            stoppageBegin: stoppageBegin
        },
        success: function (response) {

            $('#onTripVehicleStoppageAlert').modal('hide');
        }
    });
}
$('#tripSumaryTable tbody').on('click', 'td.details-control', function () {
    var tr = $(this).closest('tr');
    var row = table.row(tr);
    if (row.child.isShown()) {
        tr.removeClass('details');
        row.child.hide();
        tr.removeClass('shown');
    } else {
        tr.addClass('details');
        getLegData(row.data());
        setTimeout(function () {
            var a = format();

            row.child(a).show();
            tr.addClass('shown');
        }, 3000);
    }
});

var tableNew;

function loadEvents(alertId, alertName, tripId) {
    $(".modal-header #tripEventsTitle").text(alertName);
    $('#add').modal('show');
    tableNew = $('#alertEventsTable').DataTable({
        "ajax": {
            "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAlertDetails",
            "dataSrc": "alertDetails",
            "data": {
                alertId: alertId,
                tripId: tripId,
                custId: custId,
                routeId: routeId,
                custType: custType,
                tripType: tripType
            }
        },
        "bDestroy": true,
        "processing": true,
        dom: 'Bfrtip',
        "buttons": [{
            extend: 'pageLength'
        }, {
            extend: 'excel',
            text: 'Export to Excel',
            className: 'btn btn-primary excelWidth'
        }, {
            extend: 'pdf',
            text: 'Export to PDF',
            className: 'btn btn-primary excelWidth'
        }],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
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
    $('#alertEventsTable').closest('.dataTables_scrollBody').css('max-height', '400px');
}
var routeId;
getRouteNames();

function getRouteNames(route) {
    for (var i = document.getElementById("route_names").length - 1; i >= 1; i--) {
        document.getElementById("route_names").remove(i);
    }
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
        success: function (response) {
            routeList = JSON.parse(response);
            var $routeName = $('#route_names');
            var output = '';
            $.each(routeList, function () {
                $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeName);
            });
            $('#route_names').multiselect({
                nonSelectedText: 'ALL',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1,
                allSelectedText: 'All',
                buttonWidth: 160,
                maxHeight: 200,
                includeSelectAllOption: true,
                selectAllText: 'ALL',
                selectAllValue: 'ALL'
            });
            $("#route_names").multiselect('deselectAll', false);
            $("#route_names").multiselect('updateButtonText');

        }
    });
}
var custName;
getCustNames();

function getCustNames(cust) {
    for (var i = document.getElementById("cust_names").length - 1; i >= 1; i--) {
        document.getElementById("cust_names").remove(i);
    }
    $.ajax({

        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustNamesForSLA',
        success: function (response) {
            custList = JSON.parse(response);
            var $custName = $('#cust_names');
            var output = '';
            for (var i = 0; i < custList["customerRoot"].length; i++) {
                $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
            }
            $('#cust_names').multiselect({
                nonSelectedText: 'ALL',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1,
                allSelectedText: 'All',
                buttonWidth: 160,
                maxHeight: 200,
                includeSelectAllOption: true,
                selectAllText: 'ALL',
                selectAllValue: 'ALL',
            });
            $("#cust_names").multiselect('deselectAll', false);
            $("#cust_names").multiselect('updateButtonText');
        }
    });
}

getTripCustomerType();

function getTripCustomerType() {
    for (var i = document.getElementById("cust_type").length - 1; i >= 1; i--) {
        document.getElementById("cust_type").remove(i);
    }
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripCustomerType',
        success: function (response) {
            custTypeList = JSON.parse(response);
            for (var i = 0; i < custTypeList["tripCustTypeRoot"].length; i++) {
                $('#cust_type').append($("<option></option>").attr("value", custTypeList["tripCustTypeRoot"][i].tripCustomerValue).text(custTypeList["tripCustTypeRoot"][i].tripCustomerType));
            }
            $('#cust_type').multiselect({
                nonSelectedText: 'ALL',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1,
                allSelectedText: 'All',
                buttonWidth: 160,
                maxHeight: 200,
                includeSelectAllOption: true,
                selectAllText: 'ALL',
                selectAllValue: 'ALL',
            });
            $("#cust_type").multiselect('deselectAll', false);
            $("#cust_type").multiselect('updateButtonText');
        }
    });
}

getProductLine();

function getProductLine() {
    $.ajax({
        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getProductLine',
        data: {
            custId: <%=customerId%>
        },
        success: function (response) {
            tripTypeList = JSON.parse(response);
            var $tripType = $('#trip_type');
            var output = '';
            for (var i = 0; i < tripTypeList["productLineRoot"].length; i++) {
                $('#trip_type').append($("<option></option>").attr("value", tripTypeList["productLineRoot"][i].productname).text(tripTypeList["productLineRoot"][i].productname));
            }
            $('#trip_type').multiselect({
                nonSelectedText: 'ALL',
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                numberDisplayed: 1,
                allSelectedText: 'All',
                buttonWidth: 160,
                maxHeight: 200,
                includeSelectAllOption: true,
                selectAllText: 'ALL',
                selectAllValue: 'ALL',
            });
            $("#trip_type").multiselect('deselectAll', false);
            $("#trip_type").multiselect('updateButtonText');
        }
    });
}


function getCountsBasedOnStatus(tripStatus1) {
    flag = true;
    tripStatus = tripStatus1;
    loadMap(custId, routeId, tripStatus, custType, tripType);
    loadTable(custId, routeId, tripStatus, custType, tripType, 1);
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
        function (inputValue) {
            if (inputValue === "") {
                swal.showInputError("Enter Remarks!");
                return false;
            } else if (inputValue === true) {

            } else if (typeof (inputValue) == "string") {
                $.ajax({
                    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateRemarks',
                    data: {
                        uniqueId: uniqueId,
                        remarks: inputValue
                    },
                    success: function (result) {
                        sweetAlert(result);
                        tableNew.ajax.reload();
                    }
                })
            }
        },
        function () {})
}

function acknowledgeOnTripVehStoppage() {
    swal({
            title: "",
            text: "Enter Remarks:",
            type: "input",
            showCancelButton: true,
            closeOnConfirm: false,
            animation: "slide-from-top",
            inputPlaceholder: "Enter Remarks"
        },
        function (inputValue) {
            if (inputValue === "") {
                swal.showInputError("Enter Remarks!");
                return false;
            } else if (inputValue === true) {

            } else if (typeof (inputValue) == "string") {
                $.ajax({
                    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateOnTripVehicleStoppageAction',
                    data: {
                        tripId: onTripVehStoppageTripID,
                        uniqueId: onTripVehStopDetailsTableId,
                        stoppageBegin: onTripVehAlertMapInfo.stoppageBegin,
                        status: 'ACKNOWLEDGED',
                        remarks: inputValue,
                        duration: onTripVehAlertMapInfo.duration,
                        latitude: onTripVehAlertMapInfo.latitude,
                        longitude: onTripVehAlertMapInfo.longitude,
                        location: onTripVehAlertMapInfo.location
                    },
                    success: function (result) {
                        sweetAlert(result);
                        $('#onTripVehiclStoppageMapModal').modal('hide');
                        loadOnTripVehicleActionDetailsTable();
                    }
                })
            }
        },
        function () {})
}

function acknowledgeTripDelay() {
    var inputValue = document.getElementById("remarksAckTripDelayId").value;
    if (inputValue === "") {
        sweetAlert("Enter Remarks!");
        return;
    }
    var atp = document.getElementById("atpDateInput").value;
    var atd = document.getElementById("atdDateInput").value;

    if (atp != '' && atd == '') {
        sweetAlert("Please enter ATD");
        return;
    }
    if (atd != '' && atp == '') {
        sweetAlert("Please enter ATP");
        return;
    }
    if (atp != '' && atd != '') {
        var valAtpDate = atp.split("/");
        var valAtdDate = atd.split("/");
        var parsedAtpDate = new Date(valAtpDate[0] + "/" + valAtpDate[1] + "/" + valAtpDate[2]);
        var parsedAtdDate = new Date(valAtdDate[0] + "/" + valAtdDate[1] + "/" + valAtdDate[2]);
        if (parsedAtpDate > parsedAtdDate) {
            sweetAlert("ATP cannot be greather than ATD");
            return;
        }
        atp = valAtpDate[1] + "/" + valAtpDate[0] + "/" + valAtpDate[2];
        atd = valAtdDate[1] + "/" + valAtdDate[0] + "/" + valAtdDate[2];
    }
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=acknowledgeTripDelay',
        data: {
            uniqueId: tripId,
            vehicleNo: vehicleNo,
            remarks: inputValue,
            atp: atp,
            atd: atd
        },
        success: function (result) {
            sweetAlert(result);

            setTimeout(function () {
                $('#acknowledgeModal').modal('hide');
            }, 1000);
        }
    })

}


function loadAjax() {
    loadTable(custId, routeId, tripStatus, custType, tripType, 0);
}
var legDetails;

function getLegData(d) {
    var a;
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getLegDetailsForTrip',
        "data": {
            tripId: d.tripNo,
            tripStatus: d.Tripstatus,
            delay: d.departureDelayWrtSTD
        },
        success: function (result) {
            result = JSON.parse(result);
            legDetails = result["legDetails"];
        }
    });
}

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
        a = '<div style="overflow-x:auto;width:29%">' +
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
        row += '<td colspan="14"><b>No Records Found for Trip Id: ' + d.ShipmentId + '</b></td>';
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

        a = '<div style="overflow-x:auto;width:31%">' +
            '<table  cellpadding="5" cellspacing="0" border="0">' +
            ' <thead>' +
            '</thead>' +
            '<tbody id="tbodyId">' + tbody + '</tbody>' +
            '</table>' +
            '</div>';
    }
    return a;
}

function showTripAndAlertDetails() {

}
function showCEDashboard(tripId,status){
	//if(status.includes("OPEN")){
		window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/CEDashboard.jsp?tripId=" + tripId, '_blank');
	//}
}
var inserted = "";
$('#tripSumaryTable tbody').on('click', 'td', function () {
    var data = table.row(this).data();
    var columnIndex = table.cell(this).index().column;
    tripNo = (data['tripNo']);
    vehicleNo = (data['vehicleNo']);
    startDate = (data['STD']);
    endDate = (data['endDateHidden']);
    actualDate = (data['ATD']);
    status = (data['status']);
    routeId = (data['routeIdHidden']);
    userName = (data['customerName']);
    insertedby = (data['insertedby']);
    tripId = tripNo;
    if (columnIndex == 4) {
        window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
    }
    if (columnIndex == 51) {
        inserted = insertedby;
    }
    event.preventDefault();
});

function eraseData() {
    if (document.getElementById('r4').checked) {
        document.getElementById('r4').checked = false;
    } else if (document.getElementById('r5').checked) {
        document.getElementById('r5').checked = false;
    }
    document.getElementById('optional').innerHTML = "Remarks";
    document.getElementById('r5').checked = true;
    document.getElementById("remarksId").value = "";
    document.getElementById("locationdelayId").value = "";
    $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
    $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
    $("#issueComboId").empty().select2();
    $("#subissueComboId").empty().select2();
    document.getElementById("delayId").value = "00:00:00";
}
$("#closebutton").on("click", function () {
    eraseData();
});
$("#cancelbutton").on("click", function () {
    eraseData();
});

function addRemarks(customer_Id) {
    customerId = customer_Id;
    AddOrModify = "add";
    document.getElementById('r5').checked = true;
    document.getElementById('optional').innerHTML = "Remarks";
    $('#addModify').modal('show');
    $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
    $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
    calculatedelay();
    loadissues();
    $(".modal-header #addModifyTitle").text("Add Remarks");
    $('#save1').attr('value', 'Save');
}

function viewRemarks(tripId) {
    $('#gridModal').modal('show');
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=editRemarkDetails',
        "data": {
            tripId: tripId
        },
        success: function (result) {
            result = JSON.parse(result).indentMasterRoot1;
            if ($.fn.DataTable.isDataTable('#editableGrid')) {
                $('#editableGrid').DataTable().clear().destroy();
            }
            var rows = new Array();
            $.each(result, function (i, item) {
                var row = {
                    "0": item.slno,
                    "1": item.user,
                    "2": item.customertype,
                    "3": item.datetime,
                    "4": item.locationdelay,
                    "5": item.startdate,
                    "6": item.enddate,
                    "7": item.durationdelay,
                    "8": item.issuetype,
                    "9": item.subissuetype,
                    "10": item.remarks,
                    "11": item.action
                }
                rows.push(row);
            });
            var prntTable = $('#editableGrid').DataTable({
                "bLengthChange": false,
                "scrollY": '50vh',
                "scrollX": true,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                "buttons": [{}],
            });
            prntTable.rows.add(rows).draw();
        }
    });
    $('#editableGrid').closest('.dataTables_scrollBody').css('max-height', '200px');
}

function saveData() {

    var flag = AddOrModify;
    if (document.getElementById('r4').checked) {
        checked = document.getElementById('r4').value;
    } else if (document.getElementById('r5').checked) {
        checked = document.getElementById('r5').value;
    }
    locationdelay = document.getElementById("locationdelayId").value;
    startdate = document.getElementById("dateInput1").value;
    enddate = document.getElementById("dateInput2").value;
    delaytime = document.getElementById("delayId").value;
    issue = $('#issueComboId option:selected').attr("value");
    subissue = $('#subissueComboId option:selected').attr("value");
    remarks = document.getElementById("remarksId").value;
    if (issue == 'Others' && remarks == "") {
        sweetAlert("Please Enter Remarks");
        return;
    }
    if (!document.getElementById('r4').checked && !document.getElementById('r5').checked) {
        sweetAlert("Please select Customer Type");
        return;
    }
    if (locationdelay == "") {
        sweetAlert("Please Enter Location of Delay");
        return;
    }
    var matches = locationdelay.match(/\d+/g);
    var s = /[^a-zA-Z0-9]/;
    if (matches != null || s.test(locationdelay)) {
        sweetAlert("Please Enter valid Location of Delay");
        return;
    }
    if (startdate > enddate) {
        sweetAlert("Delayed Enddate should be greater than Startdate");
        eraseData();
        return;
    }
    var regex = /^\d?\d:\d{2}:\d{2}$/;
    var regex1 = /([0-9][0-9][0-9]):[0-9][0-9]:[0-9][0-9]/g;
    if (!regex.test(delaytime) && !regex1.test(delaytime)) {
        sweetAlert("Please Enter Duration of Delay in HH:mm:ss format");
        return;
    }
    if (issue == "--select issue--") {
        sweetAlert("Please select Issue Type");
        return;
    }
    if (subissue == "--select sub-issue--") {
        sweetAlert("Please select Sub-issue Type");
        return;
    }

    var param = {
        Custname: inserted,
        checked: checked,
        remarks: remarks,
        locationdelay: locationdelay,
        startdate: startdate,
        enddate: enddate,
        delaytime: delaytime,
        issue: issue,
        subissue: subissue,
        tripId: tripId,
        flag: flag,
        uniqueid: uniqueid,
        customerId: customerId
    };

    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=saveRemarkDetails',
        data: param,
        success: function (result) {
            if (result == "success") {
                if (AddOrModify == "add")
                    sweetAlert("Saved Successfully");
                else if (AddOrModify == "update")
                    sweetAlert("Modified Successfully");
                $('#addModify').modal('hide');
                eraseData();
            } else {
                sweetAlert(result);
            }

        }
    });
}

function openModal(custType, remarks, locationdelay, startdate, enddate, durationdelay, issue, subissue, id) {
    uniqueid = id;
    subissue = subissue;
    flag = 0;
    AddOrModify = "update";
    $('#gridModal').modal('hide');
    loadissues(issue.split('$').join(' '), subissue.split('$').join(' '));
    if (issue.split('$').join(' ') == 'Others') {
        document.getElementById('optional').innerHTML = "Remarks<sup><font color='red'>&nbsp;*</font></sup>";
    }
    $('#addModify').modal('show');
    $(".modal-header #addModifyTitle").text("Modify Remarks");
    $('#save1').attr('value', 'Update');
    if (custType == 'Yes') {
        document.getElementById("r4").checked = true;
        $('input[type=radio][name=cusType]').change(function () {
            if (this.value == 'Yes') {
                document.getElementById("r4").checked = true;
            } else if (this.value == 'No') {
                document.getElementById("r5").checked = true;
            }
        });
    } else {
        document.getElementById("r5").checked = true;
        $('input[type=radio][name=cusType]').change(function () {
            if (this.value == 'Yes') {
                document.getElementById("r4").checked = true;
            } else if (this.value == 'No') {
                document.getElementById("r5").checked = true;
            }
        });
    }
    document.getElementById("remarksId").value = remarks.split('$').join(' ');
    document.getElementById("locationdelayId").value = locationdelay.split('$').join(' ');
    $('#dateInput1 ').jqxDateTimeInput('setDate', startdate.split('$').join(' '));
    $('#dateInput2 ').jqxDateTimeInput('setDate', enddate.split('$').join(' '));
    document.getElementById("delayId").value = durationdelay.split('$').join(' ');
}

function loadissues(issue, subissue) {
    $("#issueComboId").empty().select2();
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getIssuesData',
        success: function (result) {
            var issueStore = JSON.parse(result);
            for (var i = 0; i < issueStore["issueRoot"].length; i++) {
                $('#issueComboId').append($("<option></option>").attr("value", issueStore["issueRoot"][i].issuevalue)
                    .text(issueStore["issueRoot"][i].issuevalue));
            }
            $('#issueComboId').select2();
            if (issue != "") {
                $("#issueComboId").val(issue).trigger('change');
                loadSubIssues(subissue);
            }
        }
    });
}

function loadSubIssuesModal() {
    var issuetype = document.getElementById('issueComboId').value;
    if (issuetype == 'Others') {
        document.getElementById('optional').innerHTML = "Remarks<sup><font color='red'>&nbsp;*</font></sup>";
    }
    if (issuetype != 'Others') {
        document.getElementById('optional').innerHTML = "Remarks";
    }
    $("#subissueComboId").empty().select2();

    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSubIssuesData',
        data: {
            issuetype: document.getElementById('issueComboId').value
        },
        success: function (result) {
            subissueList = JSON.parse(result);
            for (var i = 0; i < subissueList["subissues"].length; i++) {
                $('#subissueComboId').append($("<option></option>").attr("value", subissueList["subissues"][i].subissuevalue).text(subissueList["subissues"][i].subissuevalue));
            }
            $('#subissueComboId').select2();
        }
    });
}

function loadSubIssues(subissue) {
    var issuetype = document.getElementById('issueComboId').value;
    if (issuetype == 'Others') {
        document.getElementById('optional').innerHTML = "Remarks<sup><font color='red'>&nbsp;*</font></sup>";
    }
    if (issuetype != 'Others') {
        document.getElementById('optional').innerHTML = "Remarks";
    }
    $("#subissueComboId").empty().select2();

    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSubIssuesData',
        data: {
            issuetype: document.getElementById('issueComboId').value
        },
        success: function (result) {
            subissueList = JSON.parse(result);
            if (flag == 1) {
                for (var i = 0; i < subissueList["subissues"].length; i++) {
                    $('#subissueComboId').append($("<option></option>").attr("value", subissueList["subissues"][i].subissuevalue).text(subissueList["subissues"][i].subissuevalue));
                }
            }
            $('#subissueComboId').select2();
            $("#subissueComboId").val(subissue).trigger('change');
            flag++;
        }
    });
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

function calculatedelay() {
    var starttime = document.getElementById("dateInput1").value;
    var endtime = document.getElementById("dateInput2").value;
    starttime = getDateObject(starttime);
    endtime = getDateObject(endtime);
    var delay = gettimediff(starttime, endtime);

    $('#delayId').val(delay);
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
                groupId: groupId,
                unit: '<%=unit%>',
                custId: custId,
                routeId: routeId,
                status: tripStatus,
                startDateRange: startDateRange,
                endDateRange: endDateRange,
                custType: custType,
                tripType: tripType
            },
            success: function (responseText) {
                window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
                document.getElementById("page-loader").style.display = "none";
            }
        });
    } else {
        sweetAlert("No Data Found to Export");
    }
});

$('#expBtn').click(function () {
    var startDateRange = document.getElementById("startDateInput").value;
    startDateRange = startDateRange.split("/").reverse().join("-");

    var endDateRange = document.getElementById("endDateInput").value;
    endDateRange = endDateRange.split("/").reverse().join("-");

    var data = table.rows().data();
    if (data.length) {
        document.getElementById("page-loader").style.display = "block";
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=GenerateExportExcel',
            data: {
                groupId: groupId,
                unit: '<%=unit%>',
                custId: custId,
                routeId: routeId,
                status: tripStatus,
                startDateRange: startDateRange,
                endDateRange: endDateRange,
                custType: custType,
                tripType: tripType,
                count: ccount
            },
            success: function (responseText) {
                if (responseText != "Failed to Download Report") {
                    window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
                    document.getElementById("page-loader").style.display = "none";
                } else {
                    sweetAlert(responseText);
                    document.getElementById("page-loader").style.display = "none";
                }
            }
        });
    } else {
        sweetAlert("No Data Found to Export");
    }
});

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

            var custcombo = "";
            var custselected = $("#cust_names option:selected");
            custselected.each(function () {
                custcombo += $(this).val() + ",";
            });
            var routecombo = "";
            var routeselected = $("#route_names option:selected");
            routeselected.each(function () {
                routecombo += $(this).val() + ",";
            });
            var custTypecombo = "";
            var custTypeSelected = $("#cust_type option:selected");
            custTypeSelected.each(function () {
                custTypecombo += "'" + $(this).val() + "'" + ",";
            });
            var tripTypecombo = "";
            var tripTypeSelected = $("#trip_type option:selected");
            tripTypeSelected.each(function () {
                tripTypecombo += "'" + $(this).val() + "'" + ",";
            });
            var custArr = custcombo.split(",");
            var routeArr = routecombo.split(",");
            var custTypeArr = custTypecombo.split(",");
            var tripTypeArr = tripTypecombo.split(",");
            if (custList["customerRoot"].length == custArr.length - 1 || custcombo == "") {
                custId = "ALL";
            } else {
                custId = custcombo;
            }
            if (routeList.length == routeArr.length - 1 || routecombo == "") {
                routeId = "ALL";
            } else {
                routeId = routecombo;
            }
            if (custTypeList.length == custTypeArr.length - 1 || custTypecombo == "") {
                custType = "ALL";
            } else {
                custType = custTypecombo;
            }
            if (tripTypeList["productLineRoot"].length == tripTypeArr.length - 1 || tripTypecombo == "") {
                tripType = "ALL";
            } else {
                tripType = tripTypecombo;
            }
            loadTable(custId, routeId, tripStatus, custType, tripType, 0);
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

            var custcombo = "";
            var custselected = $("#cust_names option:selected");
            custselected.each(function () {
                custcombo += $(this).val() + ",";
            });
            var routecombo = "";
            var routeselected = $("#route_names option:selected");
            routeselected.each(function () {
                routecombo += $(this).val() + ",";
            });
            var custTypecombo = "";
            var custTypeSelected = $("#cust_type option:selected");
            custTypeSelected.each(function () {
                custTypecombo += "'" + $(this).val() + "'" + ",";
            });
            var tripTypecombo = "";
            var tripTypeSelected = $("#trip_type option:selected");
            tripTypeSelected.each(function () {
                tripTypecombo += "'" + $(this).val() + "'" + ",";
            });
            var custArr = custcombo.split(",");
            var routeArr = routecombo.split(",");
            var custTypeArr = custTypecombo.split(",");
            var tripTypeArr = tripTypecombo.split(",");
            if (custList["customerRoot"].length == custArr.length - 1 || custcombo == "") {
                custId = "ALL";
            } else {
                custId = custcombo;
            }
            if (routeList.length == routeArr.length - 1 || routecombo == "") {
                routeId = "ALL";
            } else {
                routeId = routecombo;
            }
            if (custTypeList.length == custTypeArr.length - 1 || custTypecombo == "") {
                custType = "ALL";
            } else {
                custType = custTypecombo;
            }
            if (tripTypeList["productLineRoot"].length == tripTypeArr.length - 1 || tripTypecombo == "") {
                tripType = "ALL";
            } else {
                tripType = tripTypecombo;
            }
            loadTable(custId, routeId, tripStatus, custType, tripType, 0);

        }
    });
}

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
                    table.column(results['columnSettingsRoot'][i].columnName + ':name').visible(false);
                }
            }
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

$('#select-all').click(function (event) {
    if (this.checked) {
        // Iterate each checkbox
        $(':checkbox').each(function () {
            this.checked = true;
        });
    } else {
        $(':checkbox').each(function () {
            this.checked = false;
        });
    }
});

function showOnTripVehiclStoppageMap() {
    $('#onTripVehiclStoppageMapModal').modal('show');
    //enable save button
    document.getElementById("updateLandMarkBtnId").disabled = false;
    //check if status closed , disable save n Mark done 
    if (onTripVehAlertMapInfo.status == "CLOSED") {
        document.getElementById("updateLandMarkBtnId").disabled = true;
    } else {
        document.getElementById("updateLandMarkBtnId").disabled = false;
    }
    $('#smartHub').prop("checked", false).trigger("change");
    var pos = new L.LatLng(onTripVehStopLatitude, onTripVehStopLongitude);
    if (mapView!=null){
		mapView.remove();
	}
    initializeMapView("dvMap",pos, '<%=mapName%>','<%=appKey%>','<%=appCode%>');
     setTimeout(function(){mapView.invalidateSize();},250);
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

function loadOnTripVehicleActionDetails(showOnNoData) {
    loadOnTripVehicleActionDetailsTable(showOnNoData);
}

function loadOnTripVehicleActionDetailsTable(showOnNoData) {
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
            if (showOnNoData == false) {
                return;
            }
            $('#onTripVehicleStoppageDetails').modal('show');
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
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary excelWidth'
                }, {
                    extend: 'pdf',
                    text: 'Export to PDF',
                    className: 'btn btn-primary excelWidth'
                }],
            });
            onTripVehTable.rows.add(rows).draw();
            onTripVehTable.columns([1, 4, 15]).visible(false);
        }
    });


}
$('#onTripVehicleDetails').unbind().on('click', 'td', function (event) {
    var table = $('#onTripVehicleDetails').DataTable();
    var columnIndex = table.cell(this).index().column;
    var aPos = $('#onTripVehicleDetails').dataTable().fnGetPosition(this);
    var data = $('#onTripVehicleDetails').dataTable().fnGetData(aPos[0]);
    onTripVehStopLatitude = data[11]; //latitude
    onTripVehStopLongitude = data[12]; //longitude
    onTripVehStopTripCustId = data[4]; //tripCustomerId
    onTripVehStopDetailsTableId = data[1]; //id
    onTripVehStoppageTripID = data[15]; //Trip Id
    onTripVehAlertMapInfo.tripCustomerName = data[5];
    onTripVehAlertMapInfo.shipmentId = data[9];
    onTripVehAlertMapInfo.assetNumber = data[3];
    onTripVehAlertMapInfo.routeName = data[10];
    onTripVehAlertMapInfo.status = data[14]; //Status
    onTripVehAlertMapInfo.latitude = data[11];
    onTripVehAlertMapInfo.longitude = data[12];
    onTripVehAlertMapInfo.location = data[13];
    onTripVehAlertMapInfo.duration = data[6];
    onTripVehAlertMapInfo.lrNumber = data[2];
    onTripVehAlertMapInfo.stoppageBegin = data[7];
    if (columnIndex == 8) { //view button click
        showOnTripVehiclStoppageMap();
    }
});

$('#smartHub').change(function () {
    if (this.checked) {
        bufferStoreSmartHub.load({
            params: {
                tripCustId: onTripVehStopTripCustId,
                vehicleLat: onTripVehStopLatitude,
                vehicleLng: onTripVehStopLongitude
            },
            callback: function () {
                plotBuffersForSmartHub();
            }
        });
        polygonStoreSmartHub.load({
            params: {
                tripCustId: onTripVehStopTripCustId,
                vehicleLat: onTripVehStopLatitude,
                vehicleLng: onTripVehStopLongitude
            },
            callback: function () {
                plotPolygonSmartHub();
            }
        });
    } else {
        for (var i = 0; i < circlessmart.length; i++) {
        	mapView.removeLayer(circlessmart[i]);
        	mapView.removeLayer(buffermarkersmart[i]);
        }
        for (var i = 0; i < polygonsmart.length; i++) {
        	mapView.removeLayer(polygonsmart[i]);
        	mapView.removeLayer(polygonmarkersmart[i]);
        }
    }
});

var bufferStoreSmartHub = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartHubBufferWithinGivenLatLngRadius',
    id: 'BufferMapView',
    root: 'BufferMapView',
    autoLoad: false,
    remoteSort: true,
    fields: ['hubId', 'longitude', 'latitude', 'buffername', 'radius', 'imagename']
});
var polygonStoreSmartHub = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSmartHubPolygonWithinGivenLatLngRadius',
    id: 'PolygonMapView',
    root: 'PolygonMapView',
    autoLoad: false,
    remoteSort: true,
    fields: ['longitude', 'latitude', 'polygonname', 'sequence', 'hubid']
});


var bufferStoreSmartHubTripDelay = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripDelaySmartHubBuffer',
    id: 'TripDelayBufferMapView',
    root: 'TripDelayBufferMapView',
    autoLoad: false,
    remoteSort: true,
    fields: ['longitude', 'latitude', 'buffername', 'radius', 'imagename', 'hubType']
});
var polygonStoreSmartHubTripDelay = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripDelaySmartHubPolygon',
    id: 'TripDelayPolygonMapView',
    root: 'TripDelayPolygonMapView',
    autoLoad: false,
    remoteSort: true,
    fields: ['longitude', 'latitude', 'polygonname', 'sequence', 'hubid', 'hubType']
});


$('#showSmartHub').change(function () {
    if (this.checked) {
        bufferStoreSmartHubTripDelay.load({
            params: {
                tripCustId: tripCustIdToShowHubs
            },
            callback: function () {
                plotBuffersForSmartHubTd();
            }
        });
        polygonStoreSmartHubTripDelay.load({
            params: {
                tripCustId: tripCustIdToShowHubs
            },
            callback: function () {
                plotPolygonSmartHubTd();
            }
        });
    } else {
        for (var i = 0; i < circlessmart1.length; i++) {
        	mapView.removeLayer(circlessmart1[i]);
        	mapView.removeLayer(buffermarkersmart1[i]);
        }
        for (var i = 0; i < polygonsmart1.length; i++) {
        	mapView.removeLayer(polygonsmart1[i]);
        	mapView.removeLayer(polygonmarkersmart1[i]);
        }
    }
});

function plotBuffersForSmartHubTd() {
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
	        iconSize: [19, 35], // size of the icon
	        popupAnchor: [0, -15]
	    });
        buffermarker1 = new L.Marker(myLatLng1, {icon: bufferimage1}).addTo(mapView);
        buffermarker1.bindPopup(rec.data['buffername']);
        buffermarkersmart1[i] = buffermarker1;
        circlessmart1[i] = L.circle(myLatLng1, {
            color: '#A7A005',
            fillColor: '#ECF086',
            fillOpacity: 0.55,
            center: myLatLng1,
            radius: convertRadiusToMeters //In meters
        }).addTo(mapView);
    }
}


function plotPolygonSmartHubTd() {
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
function updateLandMark() {
    //disable save button
    document.getElementById("updateLandMarkBtnId").disabled = true;
    var modfiedHubsArray = new Array();
    var modfiedHub = {};
    for (var key in modfiedHubIdToCircle) { //Get hubs which are modified, check if vehicle inside any hub, if so, modify only that hub
        modfiedHub = {};
        modfiedHub.id = modfiedHubIdToCircle[key].id;
        modfiedHub.lat = modfiedHubIdToCircle[key].getCenter().lat();
        modfiedHub.lng = modfiedHubIdToCircle[key].getCenter().lng();
        modfiedHub.radius = modfiedHubIdToCircle[key].getRadius() / 1000;
        modfiedHubsArray.push(modfiedHub);
    }
    var modifiedPolygonsArray = new Array();
    var modifiedPoly = {};
    for (var keyp in modfiedHubIdToPolygon) {
        modifiedPoly = {};
        modifiedPoly.id = modfiedHubIdToPolygon[keyp].id;
        latitudePolygon = [];
        longitudePolygon = [];
        var len = modfiedHubIdToPolygon[keyp].getPath().getLength();
        for (var i = 0; i < len; i++) {
            latitudePolygon.push(modfiedHubIdToPolygon[keyp].getPath().getAt(i).lat());
            longitudePolygon.push(modfiedHubIdToPolygon[keyp].getPath().getAt(i).lng());
        }
        modifiedPoly.lat = latitudePolygon;
        modifiedPoly.lng = longitudePolygon;
        modifiedPolygonsArray.push(modifiedPoly);
    }
    $.ajax({
        url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=checkIfVehicleInsideWhichHub",
        data: {
            modfiedHubs: JSON.stringify(modfiedHubsArray),
            modfiedPolyHubs: JSON.stringify(modifiedPolygonsArray),
            vehicleLat: onTripVehStopLatitude,
            vehicleLng: onTripVehStopLongitude
        },
        "dataSrc": "hubDetails",
        success: function (result) {
            //Get old values which are not allowed to modify in this page from DB
            try {
                hubDetailsRoot = JSON.parse(result);
            } catch (err) {
                sweetAlert(result);
                return;
            }
            var newLat;
            var newLng;
            var newradius;
            var updatedDate = hubDetailsRoot["hubDetails"][0].updatedDate;
            if (hubDetailsRoot["hubDetails"][0].radius == '-1.0') {
                for (var key in modfiedHubIdToPolygon) {
                    if (key == hubDetailsRoot["hubDetails"][0].hubId) {
                        latitudePolygon = [];
                        longitudePolygon = [];
                        var len = modfiedHubIdToPolygon[keyp].getPath().getLength();
                        for (var i = 0; i < len; i++) {
                            latitudePolygon.push(modfiedHubIdToPolygon[keyp].getPath().getAt(i).lat());
                            longitudePolygon.push(modfiedHubIdToPolygon[keyp].getPath().getAt(i).lng());
                        }
                        newLat = latitudePolygon + "";
                        newLng = longitudePolygon + "";
                        newradius = "-1";
                    }
                }
                locationType = 'Polygonal Hub';
            } else {
                for (var key in modfiedHubIdToCircle) {
                    if (key == hubDetailsRoot["hubDetails"][0].hubId) {
                        newLat = modfiedHubIdToCircle[key].getCenter().lat();
                        newLng = modfiedHubIdToCircle[key].getCenter().lng();
                        newradius = modfiedHubIdToCircle[key].getRadius() / 1000;
                    }
                }
                locationType = 'Circular Hub';
            }
            $.ajax({
                url: "<%=request.getContextPath()%>/createLandmarkAction.do?param=saveLocation",
                data: {
                    CustID: <%=customerId%>,
                    locationName: hubDetailsRoot["hubDetails"][0].name,
                    locationType: locationType,
                    geofenceType: hubDetailsRoot["hubDetails"][0].typeOfOperation,
                    radius: newradius,
                    latitude: newLat,
                    longitude: newLng,
                    gmt: hubDetailsRoot["hubDetails"][0].offset,
                    standardDuration: hubDetailsRoot["hubDetails"][0].standardDuration,
                    city: hubDetailsRoot["hubDetails"][0].city,
                    state: hubDetailsRoot["hubDetails"][0].state,
                    isModify: true,
                    hubId: hubDetailsRoot["hubDetails"][0].hubId,
                    id: hubDetailsRoot["hubDetails"][0].hubId,
                    pageName: 'SLA_DASHBOARD',
                    tripCustomerId: hubDetailsRoot["hubDetails"][0].tripCustomerId,
                    region: hubDetailsRoot["hubDetails"][0].region,
                    area: hubDetailsRoot["hubDetails"][0].area,
                    contactPerson: hubDetailsRoot["hubDetails"][0].contactPerson,
                    address: hubDetailsRoot["hubDetails"][0].address,
                    desc: hubDetailsRoot["hubDetails"][0].description,
                    updatedDate: updatedDate
                },
                "dataSrc": "columnSettingsRoot",
                success: function (result) {
                    updateOnTripVehicleStoppage('CLOSED');
                }
            });
        }
    });
}

//added by Narendra to download Help document

function updateOnTripVehicleStoppage(status) {
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateOnTripVehicleStoppageAction',
        data: {
            tripId: onTripVehStoppageTripID,
            uniqueId: onTripVehStopDetailsTableId,
            stoppageBegin: onTripVehAlertMapInfo.stoppageBegin,
            status: status,
            duration: onTripVehAlertMapInfo.duration,
            latitude: onTripVehAlertMapInfo.latitude,
            longitude: onTripVehAlertMapInfo.longitude,
            location: onTripVehAlertMapInfo.location
        },
        "dataSrc": "result",
        success: function (result) {
            sweetAlert(result);
            $('#onTripVehiclStoppageMapModal').modal('hide');
            loadOnTripVehicleActionDetailsTable();
        }
    });
}

function helpingServlet() {
    window.open("<%=request.getContextPath()%>/HelpDocumentServlet?FileName=SLAFieldLogics.pdf");
}


function checkRadioButton(id) {
    $("#range1").hide();
    $("#range2").hide();
    $("#userView").hide();
    radioSelected = "";
    if (id == '0') {
        radioSelected = "0";
        $('#startDateInput ').jqxDateTimeInput('setDate', '');
        $('#endDateInput ').jqxDateTimeInput('setDate', '');
    }
    if (id == '2') {
        radioSelected = "2";
        $('#startDateInput ').jqxDateTimeInput('setDate', '');
        $('#endDateInput ').jqxDateTimeInput('setDate', '');
    }
    if (id == '4') {
        radioSelected = "4";
        $('#startDateInput ').jqxDateTimeInput('setDate', '');
        $('#endDateInput ').jqxDateTimeInput('setDate', '');
    }
    if (id == '5') {
        $('#startDateInput ').jqxDateTimeInput('setDate', '');
        $('#endDateInput ').jqxDateTimeInput('setDate', '');
        radioSelected = "5";
        $("#range1").show();
        $("#range2").show();
        $("#userView").show();
    }
    //if(id != '5') {							

    //}
    groupId = radioSelected;
    //routeId = $('#route_names option:selected').val();                             
    //custId = $('#cust_names option:selected').val();
    var custcombo = "";
    var custselected = $("#cust_names option:selected");
    custselected.each(function () {
        custcombo += $(this).val() + ",";
    });
    var routecombo = "";
    var routeselected = $("#route_names option:selected");
    routeselected.each(function () {
        routecombo += $(this).val() + ",";
    });
    var custTypecombo = "";
    var custTypeSelected = $("#cust_type option:selected");
    custTypeSelected.each(function () {
        custTypecombo += "'" + $(this).val() + "'" + ",";
    });
    var tripTypecombo = "";
    var tripTypeSelected = $("#trip_type option:selected");
    tripTypeSelected.each(function () {
        tripTypecombo += "'" + $(this).val() + "'" + ",";
    });
    var custArr = custcombo.split(",");
    var routeArr = routecombo.split(",");
    var custTypeArr = custTypecombo.split(",");
    var tripTypeArr = tripTypecombo.split(",");
    if (custList["customerRoot"].length == custArr.length - 1 || custcombo == "") {
        custId = "ALL";
    } else {
        custId = custcombo;
    }
    if (routeList.length == routeArr.length - 1 || routecombo == "") {
        routeId = "ALL";
    } else {
        routeId = routecombo;
    }
    if (custTypeList.length == custTypeArr.length - 1 || custTypecombo == "") {
        custType = "ALL";
    } else {
        custType = custTypecombo;
    }
    if (tripTypeList["productLineRoot"].length == tripTypeArr.length - 1 || tripTypecombo == "") {
        tripType = "ALL";
    } else {
        tripType = tripTypecombo;
    }
    loadTable(custId, routeId, tripStatus, custType, tripType, 1);
}

function checkDays(startDate, endDate) {
    var startDate = startDate.split("/");
    var from_Date = new Date(startDate[1] + "/" + startDate[0] + "/" + startDate[2]); //mm/dd/yyyy
    var endDate = endDate.split("/");
    var to_Date = new Date(endDate[1] + "/" + endDate[0] + "/" + endDate[2]); //mm/dd/yyyy
    var one_day = 1000 * 60 * 60 * 24;
    var days = parseInt((to_Date.getTime() - from_Date.getTime()) / one_day);
    return days;
}

function showViewButton() {
    startDateRange = "";
    endDateRange = "";
    startDateRange = document.getElementById("startDateInput").value;
    endDateRange = document.getElementById("endDateInput").value;
    if (startDateRange == '') {
        sweetAlert("Please select Start Date");
        return;
    }
    if (endDateRange == '') {
        sweetAlert("Please select End Date");
        return;
    }
    var sd = startDateRange.split("/");
    var ed = endDateRange.split("/");
    var parsedStartDate = new Date(sd[1] + "/" + sd[0] + "/" + sd[2]);
    var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
    if (parsedStartDate > parsedEndDate) {
        sweetAlert("End date should be greater than Start date");
        return;
    }

    var days = checkDays(startDateRange, endDateRange);
    if (days > 30) {
        sweetAlert("Please select Date within 1 month");
        return;
    }
    var custcombo = "";
    var custselected = $("#cust_names option:selected");
    custselected.each(function () {
        custcombo += $(this).val() + ",";
    });
    var routecombo = "";
    var routeselected = $("#route_names option:selected");
    routeselected.each(function () {
        routecombo += $(this).val() + ",";
    });
    var custTypecombo = "";
    var custTypeSelected = $("#cust_type option:selected");
    custTypeSelected.each(function () {
        custTypecombo += "'" + $(this).val() + "'" + ",";
    });
    var tripTypecombo = "";
    var tripTypeSelected = $("#trip_type option:selected");
    tripTypeSelected.each(function () {
        tripTypecombo += "'" + $(this).val() + "'" + ",";
    });
    var custArr = custcombo.split(",");
    var routeArr = routecombo.split(",");
    var custTypeArr = custTypecombo.split(",");
    var tripTypeArr = tripTypecombo.split(",");
    if (custList["customerRoot"].length == custArr.length - 1 || custcombo == "") {
        custId = "ALL";
    } else {
        custId = custcombo;
    }
    if (routeList.length == routeArr.length - 1 || routecombo == "") {
        routeId = "ALL";
    } else {
        routeId = routecombo;
    }
    if (custTypeList.length == custTypeArr.length - 1 || custTypecombo == "") {
        custType = "ALL";
    } else {
        custType = custTypecombo;
    }
    if (tripTypeList["productLineRoot"].length == tripTypeArr.length - 1 || tripTypecombo == "") {
        tripType = "ALL";
    } else {
        tripType = tripTypecombo;
    }
    loadTable(custId, routeId, tripStatus, custType, tripType, 1);
}


function viewData() {
    var custcombo = "";
    var custselected = $("#cust_names option:selected");
    custselected.each(function () {
        custcombo += $(this).val() + ",";
    });
    var routecombo = "";
    var routeselected = $("#route_names option:selected");
    routeselected.each(function () {
        routecombo += $(this).val() + ",";
    });
    var custTypecombo = "";
    var custTypeSelected = $("#cust_type option:selected");
    custTypeSelected.each(function () {
        custTypecombo += "'" + $(this).val() + "'" + ",";
    });
    var tripTypecombo = "";
    var tripTypeSelected = $("#trip_type option:selected");
    tripTypeSelected.each(function () {
        tripTypecombo += "'" + $(this).val() + "'" + ",";
    });
    var custArr = custcombo.split(",");
    var routeArr = routecombo.split(",");
    var custTypeArr = custTypecombo.split(",");
    var tripTypeArr = tripTypecombo.split(",");
    if (custList["customerRoot"].length == custArr.length - 1 || custcombo == "") {
        custId = "ALL";
    } else {
        custId = custcombo;
    }
    if (routeList.length == routeArr.length - 1 || routecombo == "") {
        routeId = "ALL";
    } else {
        routeId = routecombo;
    }
    if (custTypeList.length == custTypeArr.length - 1 || custTypecombo == "") {
        custType = "ALL";
    } else {
        custType = custTypecombo;
    }
    if (tripTypeList.length == tripTypeArr.length - 1 || tripTypecombo == "") {
        tripType = "ALL";
    } else {
        tripType = tripTypecombo;
    }
    loadData(custId, routeId, custType, tripType, 1);
    loadMap(custId, routeId, tripStatus, custType, tripType);
    loadTable(custId, routeId, tripStatus, custType, tripType, 1);
}


function getTripsWhoseATAIsToBeUpdated(showOnNoData) {
    if ($.fn.DataTable.isDataTable('#tripsWithoutATAAfterReachingDest')) {
        $('#tripsWithoutATAAfterReachingDest').DataTable().clear().destroy();
    }
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripsWhoseATAIsToBeUpdated',
        "data": {},
        success: function (result) {
            result = JSON.parse(result).tripsWhoseATAIsToBeUpdated;
            if ($.fn.DataTable.isDataTable('#tripsWithoutATAAfterReachingDest')) {
                $('#tripsWithoutATAAfterReachingDest').DataTable().clear().destroy();
            }
            var rows = new Array();
            if (result == "" && showOnNoData == false) {
                return;
            }
            $('#updateATAforClosedTrips').modal('show');
            if (result != "") {
                $.each(result, function (i, item) {
                    var row = {
                        "0": item.slNo,
                        "1": item.tripId,
                        "2": item.orderId,
                        "3": item.vehicleNumber,
                        "4": item.actualTripStartTime.replace("$", " "),
                        "5": item.actualTripEndTime.replace("$", " "),
                        "6": item.tripStatus,
                        "7": item.button,
                    }
                    rows.push(row);
                });
            } else {
                var row = {
                    "0": "No Data available"
                }
            }
            ATAVehTable = $('#tripsWithoutATAAfterReachingDest').DataTable({
                "scrollY": "280px",
                paging: true,
                "serverSide": false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                "dom": 'Bfrtip',
                "processing": true,
                "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary excelWidth',
                    title: 'Closed Trips Without ATA',
                    exportOptions: {
                        columns: ':visible'
                    }
                }, {
                    extend: 'pdf',
                    text: 'Export to PDF',
                    className: 'btn btn-primary excelWidth',
                    title: 'Closed Trips Without ATA',
                    exportOptions: {
                        columns: ':visible'
                    }
                }],
            });
            ATAVehTable.rows.add(rows).draw();
            ATAVehTable.columns([1]).visible(false);
        }
    });
}


function loadTripDetails(obj) {
    if (<%=isAdmin%>) {
        $('#updateATAModalName').html(" Update ATA for Trip   " + obj.orderId);
        $('#tripIdATA').val(obj.tripId);
        $('#updtateATADate').jqxDateTimeInput('setDate', new Date());
        $('#tripIdATA').val(obj.tripId);
        $('#tripStartTime').val(obj.actualTripStartTime.replace("$", " "));
        $('#tripEndTime').val(obj.actualTripEndTime.replace("$", " "));
        $('#updateATAModal').modal('show');
    } else {
        sweetAlert("Only admin users  have authority");
        return;
    }
}

function updateATA() {

    var startD = getDateObject($('#tripStartTime').val());
    var endD = getDateObject($('#tripEndTime').val());
    var ataD = getDateObject($('#updtateATADate').val());

    var inRange = false;
    if (ataD > startD && ataD < endD) {
        inRange = true;
    }
    if (inRange) {
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateATAForClosedTrip',
            data: {
                tripId: $('#tripIdATA').val(),
                ata: $('#updtateATADate').val()
            },
            success: function (result) {
                sweetAlert(result);

                setTimeout(function () {
                    getTripsWhoseATAIsToBeUpdated(true);

                    $('#updateATAModal').modal('hide');
                }, 1000);
            }
        })
    } else {
        sweetAlert(" ATA should be within ATD and Trip Closed Time");

    }
}
</script>

<jsp:include page="../Common/footer.jsp" />