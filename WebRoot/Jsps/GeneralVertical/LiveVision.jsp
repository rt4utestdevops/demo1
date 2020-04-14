<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
        CommonFunctions cf=new CommonFunctions();
	    AdminFunctions adminFunction = new AdminFunctions();
	    LoginInfoBean loginInfo=(LoginInfoBean) session.getAttribute( "loginInfoDetails");
	    int countryId=loginInfo.getCountryCode();
	    int systemId=loginInfo.getSystemId();
	    int customerId=loginInfo.getCustomerId();
	    int nonCommHrs = loginInfo.getNonCommHrs();
	    int offset = loginInfo.getOffsetMinutes();
	    int isLtsp = loginInfo.getIsLtsp();
	    String countryName=cf.getCountryName(countryId);
	    String language=loginInfo.getLanguage();
	    Properties properties=ApplicationListener.prop;
        String unit=cf.getUnitOfMeasure(systemId);
		
		MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
		String mapName = bean.getMapName();
		String appKey = bean.getAPIKey();
		String appCode = bean.getAppCode();
		String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();
    
    	int userId=loginInfo.getUserId();
		String userAuthorityCTExec = cf.getUserAuthority(systemId,userId);


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
   <head>
      <jsp:include page="../Common/header.jsp" />
      <jsp:include page="../Common/InitializeLeaflet.jsp" />
      <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
         integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
      <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
      <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" type="text/css" />
      <link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css" type="text/css" />
      <link rel="stylesheet"
         href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css"
         type="text/css" />
      <link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
      <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
      <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
      <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css" rel="stylesheet" />
      <link href="https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css" rel="stylesheet">
      <!-- <script src="../../Main/leaflet/initializeleaflet.js"></script> -->
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
      <link rel="stylesheet" href="../../Main/leaflet/leaflet-list-markers.min.css">
      <link rel="stylesheet" href="../../Main/leaflet/leaflet-list-markers.src.css">
      <link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css" />
	  
	  
		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
		<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
		<script src="https://cdn.datatables.net/select/1.3.0/js/dataTables.select.min.js"></script>
		<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
		<script type="text/javascript"
		   src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.js"></script>
		<script src="https://unpkg.com/leaflet@1.0.2/dist/leaflet.js"></script>
		<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
		<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
		<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
		<script src="../../Main/leaflet/leaflet-heat.js"></script>
		<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
		<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
		<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
		<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
		<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
		<script src="../../Main/leaflet/leaflet-list-markers.src.js"></script>
		<script src="../../Main/leaflet/leaflet-list-markers.min.js"></script>
		<script src="../../Main/leaflet/leaflet.polylineDecorator.js"></script>
		<script
		   src="https://cdnjs.cloudflare.com/ajax/libs/leaflet-routing-machine/3.2.12/leaflet-routing-machine.min.js"></script>
		<script src="../../Main/leaflet/leaflet.measure.js"></script>
		<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"></script>
      <style>
         body {
         overflow-x: hidden;
         -webkit-transition: 2s;
         /* Safari prior 6.1 */
         transition: 2s;
         font-size: 12px !important;
         }
         #liveVisionContainer {
         -webkit-transition: 2s;
         /* Safari prior 6.1 */
         transition: 2s;
         }
         .nav-link img {
         margin-top: 0px !important;
         }
         .dataTables_wrapper .dataTables_filter input {
         border-radius: 8px !important;
         }
         .vehCompact table.dataTable thead .sorting_asc {
         border-top: 1px solid #333333 !important;
         border-left: 1px solid #333333 !important;
         border-right: 1px solid #333333 !important
         }
         #dtVehicleCompact_filter,
         #dtVehicleCompact_filter label {
         width: 100% !important;
         margin-left: 0px;
         height: 28px;
         padding-right: 4px;
         }
         #dtVehicleCompact_filter label input {
         width: 100% !important;
         border-radius: 4px !important;
         border: 2px solid #333333;
         height: 28px;
         margin-bottom: 0px;
         margin-left: 5px;
         margin-top: 2px;
         padding: 8px 12px;
         }
         table thead th {
         white-space: nowrap;
         /* color: #d40511 !important;*/
         color: #ffffff !important;
         background-color: #333333 !important;
         }
         table thead {
         color: #ffffff !important;
         background-color: #333333 !important;
         padding-top: 4px;
         padding-bottom: 4px;
         padding-left: 16px;
         }
         table.dataTable.display tbody tr td {
         padding: 8px 12px;
         white-space: nowrap !important;
         }
         table.dataTable {
         border-color: #939393;
         border: none;
         }
         .page-item.active .page-link {
         z-index: 3;
         color: #d40511;
         background-color: #ffffff;
         border-color: #333333;
         }
         .paginate_button {
         background: #ffffff !important;
         border: none !important;
         }
         .infoDiv td {
         padding: 4px;
         vertical-align: top;
         line-height: 12px;
         border: 1px solid #dfdfdf;
         }
         /* width */
         ::-webkit-scrollbar {
         width: 8px;
         height: 8px;
         }
         /* Track */
         ::-webkit-scrollbar-track {
         background: #f1f1f1;
         border-radius: 4px;
         }
         .vehCompact ::-webkit-scrollbar-track {
         background: #333333;
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
         height: 28px !important;
         padding: 0px 2px !important;
         margin-left: 8px;
         }
         #columnSetting .btn-success {
         height: 40px !important;
         padding: 0px 8px !important;
         margin-left: 16px;
         }
         #envelopeModal .btn-success {
         height: 40px !important;
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
         background-color: #dfdfdf;
         background-clip: border-box;
         border-radius: 8px;
         padding: 0px 0px 0px 0px;
         border: 0px !important;
         text-align: center;
         }
         .center-view {
         background: none;
         position: absolute;
         z-index: 10000;
         top: 50%;
         left: 45%;
         right: 40%;
         bottom: 25%;
         }
         .center-viewInitial {
         background: linear-gradient(to right, #ffffff, #ece9e6) !important;
         opacity: 1;
         position: absolute;
         z-index: 1000000000;
         top: 48px;
         left: 0;
         right: 0;
         bottom: 0;
         }
         .red-gradient-rgba {
         background: #ffffff !important;
         color: #D40511 !important;
         border: 1px solid #D40511 !important;
         }
         .redBackground-gradient-rgba {
         background: linear-gradient(to right, rgb(229, 45, 39), rgb(179, 18, 23)) !important;
         }
         .green {
         color: #28A745 !important;
         }
         .red {
         color: #d40511;
         }
         .yellow {
         color: #ffcc00;
         }
         .orange {
         color: rgb(241, 39, 17) !important;
         font-weight: 600;
         }
         .blue {
         color: rgb(22, 34, 42) !important;
         }
         .html-white {
         color: #fff !important;
         }
         .h-100 {
         height: 100% !important;
         }
         .d-flex {
         display: -ms-flexbox !important;
         display: flex !important;
         flex-direction: column;
         }
         .badge {
         min-width: 112px;
         height: 24px;
         background: linear-gradient(40deg, #777777, #000C40);
         padding-top: 4px !important;
         margin-top: 2px;
         font-size: 13px !important;
         cursor: pointer;
         display: flex;
         justify-content: space-between;
         border-radius: 8px !important;
         }
         .list-group-item {
         padding: .15rem 1.25rem 0.3rem 1.25rem !important;
         font-size: 13px;
         white-space: nowrap;
         }
         #alertsCard ul li.list-group-item {
         padding: .3rem 1.25rem 0.5rem 1.25rem !important;
         }
         .cardHeading {
         width: 100%;
         text-align: left;
         color: white;
         border-top-left-radius: 8px;
         border-top-right-radius: 8px;
         font-size: 12px;
         font-weight: 700;
         display: flex;
         justify-content: space-between;
         padding: 0px 12px 0px 16px;
         align-items: center;
         }
         .topHeader {
         font-size: 10px;
         font-weight: 600;
         display: flex;
         color: #A9C8E5;
         text-transform: uppercase;
         }
         .topHeaderMargins {
         margin-bottom: -4px;
         margin-top: 6px;
         font-weight: 700 !important;
         color: #ffffff;
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
         display: flex;
         flex-direction: column;
         }
         .flexRow {
         flex-direction: row;
         }
         .flexCol {
         display: flex;
         flex-direction: column;
         justify-content: center;
         }
         .marg8 {
         margin-left: -8px;
         }
         li:hover {
         border: none;
         }
         li {
         min-height: 12px;
         max-height: 32px;
         white-space: nowrap;
         }
         .badgeHeader {
         background: linear-gradient(to right, #ffffff, #ece9e6) !important;
         font-weight: 700 !important;
         font-size: 14px !important;
         cursor: pointer;
         margin-left: -2px;
         display: flex;
         height: 18px !important;
         align-items: flex-end;
         justify-content: center;
         width: 60px !important;
         max-width: 60px !important;
         min-width: 60px !important;
         }
         .badgeHeaderRight {
         background: linear-gradient(to right, #ffffff, #ece9e6) !important;
         font-weight: 700 !important;
         font-size: 13px !important;
         cursor: pointer;
         display: flex;
         height: 18px !important;
         align-items: flex-end;
         justify-content: center;
         width: 50px !important;
         max-width: 50px !important;
         min-width: 50px !important;
         }
         .flexWidth {
         width: 168px;
         justify-content: space-between;
         }
         .flexWidthCardDet {
         justify-content: center;
         flex-direction: column;
         }
         .btn-group {
         width: 112px !important;
         height: 28px !important;
         }
         .btn-group>.btn:first-child {
         padding: 5px !important;
         background: #ffffff;
         border: 1px solid #777777;
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
         margin-bottom: 8px;
         color: #333333;
         text-align: center;
         font-weight: 600;
         background: #ffcc00;
         border-radius: 2px;
         padding: 4px 0px 8px 0px;
         margin-left: 0px !important;
         margin-right: 0px !important;
         z-index: 10;
         display: flex;
         justify-content: space-between;
         width: 100%;
         }
         .topRowDataList {
         margin-bottom: 8px;
         color: #ffffff;
         font-weight: 600;
         font-size: 16px;
         background: #333333;
         border-radius: 2px;
         padding: 4px 0px 8px 24px;
         margin-left: 0px !important;
         margin-right: 0px !important;
         }
         .threePixelPadding {
         padding-top: 3px;
         }
         input[type=radio] {
         margin: 0px 4px 0px 8px !important;
         }
         .leaflet-control-layers-base {
         height: 50vh;
         overflow-y: auto;
         }
         input[type='checkbox'] {
         cursor: pointer;
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
         .multiselect-container {
         font-size: 12px !important;
         z-index: 100000000 !important;
         min-width: 300px !important;
         padding-bottom: 8px;
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
         #ulRowData {
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
         #envelopeModal .modal-content {
         width: 200% !important;
         border-radius: 8px !important;
         top: 12px !important;
         left: -50%;
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
         #viewDatatable,
         #viewDashboard {
         cursor: pointer;
         width: 100%;
         text-align: center;
         margin-bottom: 48px;
         font-size: 12px;
         }
         #viewDashboard {
         position: relative;
         margin-top: -70px;
         z-index: 100;
         }
         .dhlBack {
         color: #D40511;
         background: #FFCC00;
         padding: 8px 16px;
         border-radius: 8px;
         }
         .dhlBackTop {
         color: #ffcc00;
         background: #333333;
         padding: 8px 20px;
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
         height: 200px !important;
         overflow-y: auto !important;
         }
         #tripNoAutoComplete:focus {
         outline: none !important;
         }
         .flex {
         display: flex;
         }
         .marginBetweenBadge {
         /*  margin-left:8px;*/
         }
         .marginBetweenBadgeRight {
         /*  margin-right:8px;*/
         }
         .secondRowHeaderHeight {
         padding-top: 4px;
         height: 48px;
         display: flex;
         align-items: center;
         }
         .tablet {
         border-radius: 8px !important;
         }
         .thirdCol {
         padding: 0px;
         border-radius: 8px;
         border: 1px solid #777777;
         }
         .buttons-excel {
         background: #d40511 !important;
         border: 1px solid #d40511 !important;
         border-radius: 4px !important;
         height: 28px;
         padding: 0px 16px;
         margin-left: -8px;
         margin-bottom: -40px;
         }
         #tripDatatable_filter label {
         display: flex;
         align-items: center;
         text-transform: uppercase;
         }
         #tableDiv {
         width: 100%;
         border-radius: 8px;
         overflow: hidden;
         ;
         }
         .commNonComm {
         font-size: 10px;
         text-transform: uppercase;
         font-weight: 600;
         text-align: center;
         }
         .commNonCommSH {
         font-size: 10px;
         font-weight: 600;
         text-align: center;
         }
         hr {
         width: 80%;
         padding: 0px;
         margin: 0px;
         border-top: 1px solid #ffcc00 !important;
         }
         .hrli {
         min-height: 16px !important;
         max-height: 16px !important;
         }
         /*.cardOtherDet{
         padding: 0px 8px 4px 8px;
         margin:8px;
         background: #ffffff
         }*/
         .cardOtherDet {
         padding: 2px 8px 4px 2px;
         margin: 3px;
         background: #ffffff;
         display: flex;
         flex-direction: row;
         align-items: flex-end;
         justify-content: space-between;
         }
         .cardOtherDetAgeing {
         font-weight: 700;
         padding: 4px;
         color: #D40511 !important;
         border-radius: 4px;
         font-size: 15px;
         background: #ffcc00 !important;
         margin: 4px 0px;
         }
         .cardOtherDet span {
         text-transform: uppercase;
         padding-bottom: 2px;
         }
         #tripDatatable_wrapper {
         padding: 0px !important;
         }
         .leftCount {
         background: none !important;
         font-size: 28px !important;
         height: 50px !important;
         width: 90px !important;
         }
         .rightText {
         font-weight: 700 !important;
         font-size: 11px !important;
         height: 48px;
         display: flex;
         align-items: center;
         text-align: left;
         white-space: nowrap;
         text-transform: uppercase;
         }
         .rightTextHead {
         font-weight: 700 !important;
         font-size: 15px !important;
         height: 48px;
         display: flex;
         align-items: center;
         text-align: left;
         white-space: nowrap;
         text-transform: uppercase;
         }
         .leftText {
         background: none !important;
         font-size: 25px !important;
         /*  height:50px !important;*/
         width: 56px !important;
         margin-top: 4px;
         cursor: pointer;
         }
         .leftTextHead {
         background: none !important;
         font-size: 210px !important;
         /*  height:50px !important;*/
         width: 64px !important;
         margin-top: 4px;
         cursor: pointer;
         }
         .leftTextNA {
         background: none !important;
         font-size: 20px !important;
         /*  height:50px !important;*/
         width: 64px !important;
         margin-top: 4px;
         cursor: pointer;
         }
         .leftText:hover,
         .leftTextSelected {
         color: #d40511;
         }
         .leftText:active {
         color: #d40511;
         }
         .leftTop {
         padding-left: 10px;
         }
         .distText {
         font-weight: 700 !important;
         font-size: 13px !important;
         height: 34px;
         margin-left: 24px;
         }
         .bg-dark {
         background-color: #337AB7 !important;
         }
         .insideSHSt {
         font-size: 12px !important;
         margin-left: 8px;
         text-transform: capitalize !important;
         margin-top: 2px;
         font-weight: 600;
         }
         .topH {
         width: 30px !important;
         border-radius: 4px !important;
         background: none !important;
         color: #d40511 !important;
         font-size: 28px !important;
         height: 40px !important;
         margin-top: 10px;
         }
         .topHCount {
         height: 40px !important;
         font-size: 14px;
         margin-top: 24px;
         }
         .mapBackground {
         width: 100%;
         height: 630px;
         position: absolute;
         top: 0px;
         opacity: 0.3;
         background-size: cover;
         }
         .outer-1 {
         //  background:radial-gradient(circle,#ffcc00 25%,#ffffff) !important;
         width: 630px;
         /* You can define it by % also */
         height: 630px;
         /* You can define it by % also*/
         position: absolute;
         border: 3px solid #ffcc00;
         border-radius: 50%;
         top: 0px;
         background: #ffffff;
         pointer-events: none;
         z-index: 0;
         }
         .width100 {
         width: 100%;
         }
         .tooltipQ .tooltiptext {
         display: none;
         width: 470px;
         background-color: white;
         color: #000;
         text-align: center;
         border-radius: 6px;
         padding: 5px 0;
         border: 1px solid #ffcc00;
         pointer-events: all;
         /* Position the tooltip */
         position: absolute;
         z-index: 1000;
         top: 105%;
         left: 50%;
         margin-left: -60px;
         word-break: break-word;
         }
         /* .tooltipQ:hover .tooltiptext {
         visibility: visible;
         } */
         .toolTipDiv {
         border-bottom: 1px solid #dfdfdf;
         margin: 2px 8px;
         text-align: left;
         display: flex;
         width: 100%;
         justify-content: left;
         }
         .toolTipLeft {
         width: 130px;
         padding-left: 8px;
         font-weight: 500
         }
         .toolTipRight {
         width: 370px;
         }
         .toolTipDivLast {
         margin: 2px 8px;
         text-align: left;
         display: flex;
         width: 100%;
         justify-content: left;
         }
         .topCardText {
         font-weight: 400;
         font-size: 20px;
         width: 100%;
         z-index: 10;
         }
         .topText {
         font-weight: 400;
         font-size: 12px;
         }
         .truckImage {
         left: 50%;
         position: absolute;
         pointer-events: all;
         z-index: 1;
         }
         .inHub {
         position: absolute;
         top: 46.5%;
         left: 46%;
         width: 40px;
         height: 40px;
         color: white;
         font-size: 20px;
         z-index: 100;
         cursor: pointer;
         pointer-events: all;
         }
         .inHubFlex {
         display: flex;
         justify-content: center;
         align-items: center;
         }
         .popUpTop {
         display: flex;
         padding: 16px 20px;
         justify-content: space-between;
         align-items: center;
         }
         .select2-results ul li {
         white-space: nowrap;
         }
         .center-viewLoading1 {
         top: 30%;
         left: 40%;
         position: absolute;
         height: 200px;
         z-index: -1;
         }
         .mapPopUpComponent {
         width: 250px;
         height: 250px;
         background: white;
         opacity: 1
         }
         .table-striped tbody tr:nth-of-type(odd) {
         background-color: #efefef !important;
         }
         .arrowTop {
         height: 16px;
         width: 16px;
         left: 48%;
         top: -3%;
         border-left: 1px solid #ffcc00;
         border-top: 1px solid #ffcc00;
         background: #ffffff;
         transform: rotate(45deg);
         position: absolute;
         }
         .arrowBottom {
         height: 16px;
         width: 16px;
         left: 48%;
         bottom: -3%;
         border-right: 1px solid #ffcc00;
         border-bottom: 1px solid #ffcc00;
         background: #ffffff;
         transform: rotate(45deg);
         position: absolute;
         }
         .closeTop {
         top: 4px;
         right: 4px;
         position: absolute;
         cursor: pointer;
         z-index: 1000000;
         }
         .closeSize {
         font-size: 1rem !important;
         }
         .pointer {
         cursor: pointer
         }
         .hyperlink {
         color: blue;
         }
         #headerText {
         text-transform: uppercase;
         font-weight: 700;
         }
         .gpsGroup {
         width: 72px;
         justify-content: space-between;
         border: 1px solid #dfdfdf;
         border-radius: 8px;
         padding: 8px;
         white-space: nowrap;
         }
         .tempGroup {
         width: 164px;
         justify-content: space-between;
         border: 1px solid #dfdfdf;
         border-radius: 8px;
         padding: 8px;
         white-space: nowrap;
         }
         .tempR {
         align-items: baseline;
         justify-content: center;
         padding-bottom: 4px;
         }
         .fa-tachometer-alt {
         padding: 0px;
         }
         .padBot {
         padding-bottom: 16px;
         }
         .botText {
         font-weight: 800;
         font-size: 10px;
         }
         .cardSm {
         width: 30%;
         height: 60px;
         background: #ffffff;
         margin-right: 16px;
         }
         .cardLarge {
         width: 50%;
         height: 60px;
         background: #ffffff;
         margin-right: 16px;
         }
         .cardHuge {
         width: 100%;
         height: 60px;
         background: #ffffff;
         margin-right: 16px;
         }
         .flexJustify {
         justify-content: space-between;
         }
         .setTwoBeg {
         margin-left: 40px;
         }
         .setTwoEnd {
         margin-right: 40px;
         }
         .height40 {
         height: 40px;
         }
         .bRight {
         border-right: 1px solid #f0f0f0;
         }
         .bwid20 {
         width: 20%;
         }
         .bwid25 {
         width: 25%;
         }
         .bwid15 {
         width: 15%;
         }
         body,
         .bg {
         background: #FFFDF3 !important;
         }
         .regSpace {
         display: flex;
         flex-direction: row;
         justify-content: space-around;
         margin-bottom: 10px;
         }
         .regSpaceTop {
         display: flex;
         flex-direction: row;
         justify-content: space-around;
         margin-bottom: 10px;
         margin: 0px;
         padding: 0px;
         }
         .h60 {
         height: 60px;
         }
         .bottom {
         text-align: center;
         }
         .alignLeft {
         align-items: baseline;
         padding-left: 24px;
         }
         .topFont {
         font-size: 20px;
         }
         .bottomFont {
         font-size: 16px;
         }
         .strong {
         font-weight: 800;
         }
         .container-fluid {
         padding-right: 0px;
         padding-left: 0px;
         }
         span {
         cursor: pointer;
         }
         .btnColor,
         .btnColor:hover {
         background: #d40511;
         border: #d40511;
         padding: 0px 24px 3px 24px !important;
         }
         .btnColorHistory,
         .btnColorHistory:hover {
         background: #d40511;
         border: #d40511;
         padding: 0px 8px 3px 8px !important;
         }
         .DTFC_LeftBodyLiner {
         overflow-x: hidden;
         }
         .topCard {
         margin-bottom: 8px;
         background: #333333;
         text-transform: uppercase;
         flex-direction: column;
         justify-content: space-between;
         align-items: center;
         padding: 8px 4px;
         position: absolute;
         left: 16px;
         top: 115px;
         z-index: 10;
         color: #A9C8E5;
         align-items: center;
         width: 108px;
         transition: top 1s;
         }
         .showHubsBox {
         white-space: nowrap;
         left: 16px;
         background: #333333;
         padding: 8px 4px 8px 8px;
         width: fit-content;
         position: absolute;
         top: 440px;
         right: 16px;
         z-index: 9;
         color: #ffffff;
         line-height: 28px;
         transition: top 1s;
         }
         .topInnerCard {
         display: flex;
         flex-direction: column;
         text-align: left;
         /* border-right:1px solid #939393; */
         width: 88px;
         padding-left: 4px;
         }
         .topInnerCardLast {
         display: flex;
         flex-direction: column;
         text-align: left;
         width: 88px;
         padding-left: 4px;
         }
         .topNum {
         font-size: 18px;
         cursor: pointer;
         }
         .topBarInfo {
         width: 100%;
         height: 56px;
         display: flex;
         align-items: center;
         justify-content: space-between;
         padding: 16px;
         }
         .topBarbg {
         background: #333333;
         }
         #divVehInformation {
         position: fixed;
         background: #333333;
         width: 25%;
         top: 0px;
         right: 0px;
         bottom: 0px;
         z-index: 100000;
         border-left: 1px solid #939393;
         color: #ffffff;
         }
         .odo {
         border: 1px solid #ffcc00;
         margin-right: 4px;
         padding: 0px 4px;
         font-weight: 500;
         font-size: 16px;
         }
         .placeholder {
         border-bottom: 1px solid #939393;
         display: flex;
         justify-content: space-between;
         padding: 4px 20px;
         white-space: nowrap;
         }
         .placeholderHeader {
         border-bottom: 1px solid #939393;
         display: flex;
         font-size: 14px;
         justify-content: space-around;
         padding: 5px 20px;
         background: #A9C8E5;
         text-transform: uppercase;
         font-weight: 600;
         color: #333333;
         }
         .dataTables_scrollBody {
         border-bottom: 0px !important;
         }
         .fa-2x {
         font-size: 1.2rem;
         }
         .fa-2x:hover {
         transition: font-size 0.35s ease;
         font-size: 1.8em !important;
         }
         .infoLeftIcons {
         display: flex;
         flex-direction: column;
         justify-content: space-between;
         align-items: center;
         padding: 24px 0px;
         width: 18%;
         height: 530px;
         }
         tr.highlight,
         tr.highlight .sorting_1 {
         background-color: #333333 !important;
         color: #ffffff;
         }
         tr.highlight td {
         border: 1px solid #333333 !important;
         }
         #dtVehicleCompact tbody tr {
         height: 20px;
         }
         #vehicleDatatable tbody td {
         padding: 4px 18px;
         }
         table.dataTable thead th {
         border: 1px solid #333333 !important;
         }
         #dtVehicleCompact tbody td {
         padding: 4px 18px;
         background: #333333;
         color: #ffffff;
         border: 1px solid #333333;
         }
         .leftCol {
         display: flex;
         flex-direction: column;
         align-items: center;
         font-weight: bold
         }
         .dateText {
         font-size: 10px;
         font-weight: 500;
         }
         .fa-3x {
         font-size: 1.5rem !important
         }
         .fa-3x:hover {
         transition: font-size 0.35s ease;
         font-size: 2em !important;
         }
         input[type=range] {
         -webkit-appearance: none;
         width: 100%;
         background: #333333;
         }
         input[type=range]:focus {
         outline: none;
         }
         input[type=range]::-webkit-slider-runnable-track {
         width: 100%;
         height: 10px;
         cursor: pointer;
         animate: 0.2s;
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         background: #ffffff;
         border-radius: 25px;
         border: 0px solid #000101;
         }
         input[type=range]::-webkit-slider-thumb {
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         border: 0px solid #000000;
         height: 20px;
         width: 20px;
         border-radius: 10px;
         background: #ffcc00;
         cursor: pointer;
         -webkit-appearance: none;
         margin-top: -4.6px;
         }
         input[type=range]:focus::-webkit-slider-runnable-track {
         background: #ffffff;
         }
         input[type=range]::-moz-range-track {
         width: 100%;
         height: 10px;
         cursor: pointer;
         animate: 0.2s;
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         background: #ffffff;
         border-radius: 25px;
         border: 0px solid #000101;
         }
         input[type=range]::-moz-range-thumb {
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         border: 0px solid #000000;
         height: 20px;
         width: 20px;
         border-radius: 10px;
         background: #ffcc00;
         cursor: pointer;
         }
         input[type=range]::-ms-track {
         width: 100%;
         height: 10px;
         cursor: pointer;
         animate: 0.2s;
         background: transparent;
         border-color: transparent;
         border-width: 20px 0;
         color: transparent;
         }
         input[type=range]::-ms-fill-lower {
         background: #ffffff;
         border: 0px solid #000101;
         border-radius: 50px;
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         }
         input[type=range]::-ms-fill-upper {
         background: #ffffff;
         border: 0px solid #000101;
         border-radius: 50px;
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         }
         input[type=range]::-ms-thumb {
         box-shadow: 0px 0px 0px #000000, 0px 0px 0px #0d0d0d;
         border: 0px solid #000000;
         height: 20px;
         width: 20px;
         border-radius: 10px;
         background: #ffcc00;
         cursor: pointer;
         }
         input[type=range]:focus::-ms-fill-lower {
         background: #ffffff;
         }
         input[type=range]:focus::-ms-fill-upper {
         background: #ffffff;
         }
         /*.leaflet-interactive {
         pointer-events: visiblePainted;
         stroke-dasharray: 1920;
         stroke-dashoffset: 1920;
         animation: dash 20s linear 1s forwards;
         }
         @keyframes dash {
         to {
         stroke-dashoffset: 0;
         }
         }*/
         .leaflet-overlay-pane {
         z-index: 10000;
         }
         .leaflet-shadow-pane {
         z-index: 9999;
         }
         .dispFlex {
         display: flex;
         -webkit-transition: 1s;
         /* Safari prior 6.1 */
         transition: 1s;
         }
         .dispNone {
         display: none !important;
         -webkit-transition: 1s;
         /* Safari prior 6.1 */
         transition: 1s;
         }
         .mapStyle {
         position: absolute;
         z-index: 0;
         top: 56px;
         bottom: 0px;
         right: 0px;
         left: 0px;
         }
         #tripDetailsDiv {
         margin-bottom: -8px;
         padding: 0px 16px;
         width: 110%;
         margin-left: -16px;
         margin-right: -16px;
         }
         .dt-buttons {
         margin-left: 8px;
         margin-bottom: -28px;
         }
         #vehicleDatatable_filter {
         margin-right: 8px;
         }
         .leaflet-left {
         right: 3px;
         position: absolute;
         left: auto;
         top: 230px;
         }
         .leaflet-right {
         margin-top: 54px;
         right: -6px;
         }
         .leaflet-touch .leaflet-control-layers-toggle {
         width: 28px !important;
         height: 28px !important;
         }
         .leaflet-touch .leaflet-bar a {
         border-left: 1px solid #C6C9CA;
         }
         .resetMap {
         background: #ffffff;
         padding: 6px;
         border: 2px solid #C6C9CA !important;
         position: absolute;
         top: 256px;
         right: 2px;
         z-index: 1;
         background: #333333;
         color: white;
         cursor: pointer;
         }
         .listView {
         background: #ffffff;
         padding: 6px;
         border: 2px solid #C6C9CA !important;
         position: absolute;
         top: 220px;
         right: 2px;
         z-index: 1;
         background: #333333;
         color: white;
         cursor: pointer;
         }
         .listViewFilter {
         background: #ffffff;
         padding: 6px;
         border: 2px solid #C6C9CA !important;
         position: absolute;
         top: 154px;
         right: 2px;
         z-index: 1;
         background: #333333;
         color: white;
         cursor: pointer;
         }
         .vehIcon {
         background: #ffffff;
         padding: 6px;
         border: 2px solid #C6C9CA !important;
         position: absolute;
         top: 190px;
         right: 2px;
         z-index: 1;
         background: #333333;
         color: white;
         cursor: pointer;
         }
         .leaflet-touch .leaflet-bar a {
         background: #333333;
         color: white;
         }
         .leaflet-control-fullscreen a {
         background: #DDDDDD url(https://leaflet.github.io/Leaflet.fullscreen/dist/fullscreen.png) no-repeat 2% 2% !important;
         background-size: 26px 52px !important;
         background-position: 2px 2px !important;
         }
         #liveVisionHeader {
         position: fixed;
         top: 64px;
         left: 0px;
         right: 0px;
         z-index: 200;
         margin-top: -16px;
         display: flex;
         justify-content: space-between;
         align-items: center;
         transition: right 2s;
         }
         .vehCompact {
         width: 164px;
         position: absolute;
         right: 40px;
         top: 115px;
         background: #333333;
         border-radius: 8px;
         padding: 4px 4px 8px 4px;
         height: fit-content;
         overflow-x: hidden;
         }
         .dataTables_scrollHeadInner {
         width: 182.2px !important;
         }
         .listViewClass {
         width: 100%;
         background: #FFFDF3
         }
         #filters {
         z-index: 9;
         position: absolute;
         top: 108px;
         left: 16px;
         padding: 1px 12px 6px 12px !important;
         background: #333333;
         display: flex;
         color: white;
         border-radius: 4px;
         opacity: 0;
         transition: opacity 2s;
         }
         /* path.leaflet-interactive.animate {
         stroke-dasharray: 1920;
         stroke-dashoffset: 1920;
         animation: dash 20s linear 5s forwards;
         } */
         .topNum:hover,
         .topNumSelected {
         color: #ffcc00;
         }
         @keyframes dash {
         to {
         stroke-dashoffset: 0;
         }
         }
         #vehicleDatatable_wrapper {
         z-index: 10;
         background: #FFFDF3;
         height: 700px;
         padding-left: 16px;
         padding-right: 24px;
         width: 100%;
         }
         .leaflet-popup-content-wrapper {
         background: #333333;
         color: white;
         }
         .leaflet-popup-content {
         min-width: 350px;
         }
         .pop {
         color: #A9C8E5;
         width: 75%;
         }
         .flexPop {
         display: flex;
         align-items: baseline;
         }
         .popLeft {
         width: 25%;
         font-size: 10px;
         color: #ffffff;
         text-transform: uppercase;
         }
         .leaflet-popup-pane {
         z-index: 700000 !Important;
         }
         .flexAlign {
         align-items: center;
         }
         .leaflet-touch .leaflet-control-layers {
         background: #333333;
         color: white;
         }
         .popupBox {
         overflow: auto;
         padding: 8px;
         border: 1px solid #A9C8E5;
         margin-top: 8px;
         border-radius: 8px;
         background: #333333;
         width: 100%;
         }
         .popupBoxNoBorder {
         overflow: auto;
         padding: 8px;
         border: none;
         margin-top: 8px;
         border-radius: 8px;
         background: #333333;
         width: 100%;
         }
         .popupBoxSticky {
         left: 140px;
         overflow: auto;
         padding: 8px;
         margin-top: 8px;
         border-radius: 8px;
         background: #333333;
         position: absolute;
         top: 148px;
         z-index: 10;
         width: 400px;
         }
         .popupBoxInner {
         border: 2px solid #A9C8E5;
         width: 100%;
         border-radius: 8px;
         padding: 8px;
         }
         .leaflet-marker-pane {
         z-index: 60000 !important;
         }
         .fullWidth {
         position: absolute;
         left: 0px;
         right: 0px;
         top: 0px;
         }
         .percentWidth {
         position: absolute;
         left: 0px;
         right: 25%;
         top: 0px;
         }
         #tripDiv,
         #tripStart,
         #tripEnd,
         #truckType {
         display: flex;
         justify-content: space-around;
         font-size: 16px;
         align-items: center;
         color: #ffcc00;
         text-transform: uppercase;
         font-weight: 500;
         }
         #tripDiv {
         border-top: #939393 1px solid;
         border-bottom: #939393 1px solid;
         padding: 8px 16px;
         justify-content: space-between;
         }
         #atdEta {
         border-bottom: #939393 1px solid;
         padding: 0px 16px;
         justify-content: space-between;
         display: flex;
         }
         .atdClass {
         display: flex;
         justify-content: space-around;
         font-size: 16px;
         align-items: center;
         text-transform: uppercase;
         font-weight: 500;
         width: 50%;
         text-align: left;
         justify-content: flex-start;
         border-right: 1px solid;
         color: #A9C8E5 !important;
         font-size: 12px !important;
         }
         .etaClass {
         display: flex;
         justify-content: space-around;
         font-size: 16px;
         align-items: center;
         text-transform: uppercase;
         font-weight: 500;
         width: 50%;
         text-align: right;
         justify-content: flex-end;
         color: #A9C8E5 !important;
         font-size: 12px !important;
         }
         #truckType img {
         width: 100px;
         }
         .leaflet-marker-icon {
         margin: 0px !important;
         }
         .leaflet-tooltip-pane {
         z-index: 750000 !important;
         margin-top: -8px !important;
         }
         .leaflet-tooltip-top {
         background: #333333;
         border: 1px solid #A9C8E5;
         color: #A9C8E5;
         }
         .my-div-span {
         position: absolute;
         left: 1.5em;
         right: 1em;
         top: 1.4em;
         bottom: 2.5em;
         font-size: 9px;
         font-weight: bold;
         width: 1px;
         color: black;
         }
         .smartHubMarker {
         margin-top: -35px !important;
         margin-left: -25px !important;
         }
         .showMap {
         color: #ffcc00;
         position: absolute;
         z-index: 11;
         right: 152px;
         cursor: pointer;
         }
         .modal-title {
         color: #333333;
         }
         #searchDiv {
         background: #333333 !important;
         border: 1px solid #A9C8E5;
         padding: 4px;
         border-radius: 8px;
         display: flex;
         justify-content: center;
         }
         #searchDiv button {
         height: 28px;
         padding: 0px 16px;
         background: #d40511;
         border: #d40511;
         }
         #searchDiv select {
         height: 28px !important;
         margin-right: 8px;
         width: 70%;
         padding-left: 8px;
         }
         .vehCompact .dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody {
         overflow-x: hidden !important;
         }
         .imgTbl {
         width: 12px;
         }
         /* .leaflet-zoom-animated {
         margin-top: -10px !important;
         margin-left: -10px !important;
         } */
         .removeBorder {
         border: none;
         background: none;
         }
         .flagOffset {
         margin-top: -58px !important;
         }
         .animMarker {
         margin-top: -39px !important;
         margin-left: -12px !important;
         }
         .leaflet-marker-pane>* {
         -webkit-transition: transform .3s linear;
         -moz-transition: transform .3s linear;
         -o-transition: transform .3s linear;
         -ms-transition: transform .3s linear;
         transition: transform .3s linear;
         }
         .redHub {
         margin-top: -20px !important;
         margin-left: -20px !important;
         }
         .leaflet-popup-content {
         border: 1px solid #A9C8E5;
         padding: 8px;
         border-radius: 4px;
         }
      </style>
   </head>
   <body>
      <div class="center-viewInitial" id="loading-divInitial">
         <i class="fas fa-spinner fa-spin spinnerColor" style="font-size:80px;color:#333333;left: 50%;
            position: absolute;
            top: 45%;"></i>
      </div>
      <div class="center-view" id="loading-div">
         <i class="fas fa-spinner fa-spin spinnerColor" style="font-size:80px;color:#333333;"></i>
      </div>
      <div id="liveVisionContainer" class="fullWidth">
         <div id="liveVisionHeader">
            <div class="topRowData dhlBackTop">
               <div style="font-weight:bold;font-size:16px;">LIVE VISION</div>
               <div style="display:flex;">
                  <div class="leftMargin"> <span class="topHeader"> &nbsp;CUSTOMER NAME</span>
                     <select id="customerName" multiple="multiple" class="input-s" name="state">
                     </select>
                  </div>
                  <div class="leftMargin">
                     <span class="topHeader"> &nbsp;REGION WISE</span>
                     <select id="regionWise" multiple="multiple" class="input-s" name="state">
                        <option value="'North'">North</option>
                        <option value="'East'">East</option>
                        <option value="'West'">West</option>
                        <option value="'South'">South</option>
                     </select>
                  </div>
                  <div class="leftMargin" style="width:116px !important"> <span class="topHeader"> &nbsp;HUB WISE</span>
                     <select id="hubWise" multiple="multiple" class="input-s" name="state">
                     </select>
                  </div>
                  <div class="leftMargin">
                     <span class="topHeader"> &nbsp;DIRECTION</span>
                     <select id="directionWise" multiple="multiple" class="input-s" name="state">
                        <option>Incoming</option>
                        <option>Outgoing</option>
                     </select>
                  </div>
                  <div class="leftMargin"> <span class="topHeader"> &nbsp;</span>
                     <input onclick="viewClicked()" type="button" class="btn btn-success btnColor" value="View" />
                  </div>
                  <div class="leftMargin"> <span class="topHeader"> &nbsp;</span>
                     <i class="fas fa-sync-alt fa-2x" style="margin-top:4px;cursor: pointer;" onclick="refresh(true)"></i>
                  </div>
               </div>
               <div>
                  <input id="tripNoAutoComplete" placeholder="Search Any Trip Here..."
                     title="Search any trip in the last two months and click enter to reach CE Dashboard."
                     style="width:138px !important;height:28px !important;border-radius:8px;padding-left:8px;margin-top:12px;" /><i
                     onclick="autoCompleteShowCEDashboard()" title="Go to CE Dashboard" style="cursor:pointer;padding-left:4px;"
                     class="fas fa-2x fa-directions"></i>
               </div>
            </div>
         </div>
         <div class="popupBoxSticky" id="popupBoxOuter" style="display:none">
            <div class="popupBoxInner" id="popupBox">
            </div>
         </div>
         <div class="flex card topCard">
            <div class="topInnerCard">
               <div class="topHeader topHeaderMargins">Total</div>
               <div class="topNum" id="topTotal" onclick="loadListView('');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
            <div class="topInnerCard">
               <div class="topHeader topHeaderMargins">Comm</div>
               <div class="topNum topNumSelected" id="topComm" onclick="loadListView('comm');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
            <div class="topInnerCard">
               <div class="topHeader topHeaderMargins">Non Comm</div>
               <div class="topNum" id="topNonComm" onclick="loadListView('noncomm');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
            <div class="topInnerCard">
               <div class="topHeader topHeaderMargins">No GPS</div>
               <div class="topNum" id="topNoGPS" onclick="loadListView('nogps');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
            <div class="topInnerCard">
               <div class="topHeader topHeaderMargins">Running</div>
               <div class="topNum" id="topRunning" onclick="loadListView('running');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
            <div class="topInnerCard">
               <div class="topHeader topHeaderMargins">Stoppage</div>
               <div class="topNum" id="topStoppage" onclick="loadListView('stoppage');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
            <div class="topInnerCardLast">
               <div class="topHeader topHeaderMargins">Idle</div>
               <div class="topNum" id="topIdle" onclick="loadListView('idle');selected(this);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
            </div>
         </div>
         <div class="card flexCol showHubsBox">
            <div id="showHubsBox"></div>
            <div class="flex flexAlign" style="display:none;"><input type="checkbox" id="showBorders"
               style="margin-right:4px;" />Borders</div>
            <!-- <div class="flex flexAlign"><input type="checkbox" id="fixMap" style="margin-right:4px;" />Fix Map</div> -->
            <div class="flex flexAlign"><input type="checkbox" id="showLabels" style="margin-right:4px;" />Labels</div>
         </div>
         <div id="filters" class="dispNone" style="padding:0px 8px 8px 0px;justify-content:space-between;">
            <div class="flexCol">
               <div class="dateText">START DATE</div>
               <div class="flex">
                  <div id="startDate"></div>
                  <div id="startTime"></div>
               </div>
            </div>
            <div class="flexCol" style="margin-left:8px;">
               <div class="dateText">END DATE</div>
               <div class="flex">
                  <div id="endDate"></div>
                  <div id="endTime"></div>
               </div>
            </div>
            <div class="flexCol" style="justify-content:flex-end;"><input style="margin-right:8px"
               onclick="historyAnalysis('','')" type="button" class="btn btn-success btnColorHistory" value="Plot" /></div>
            <div class="flexCol" style="justify-content:flex-end;">
               <div class="flex"><i id="play" onclick="play(this)" class="far fa-play-circle fa-3x"
                  style="padding-right:8px;cursor: pointer;"></i><i id="pause" onclick="pause(this)"
                  style="padding-right:8px;cursor: pointer;" class="far fa-pause-circle fa-3x"></i>
                  <i id="stop" onclick="stop(this)" style="padding-right:8px;cursor: pointer;"
                     class="far fa-stop-circle fa-3x"></i>
                  <input id="speedRange" type="range" style="width:112px;" value="2" min="1" max="4" />
               </div>
            </div>
         </div>
         <div class="card flexCol resetMap">
            <div class="flex"><i class="fas fa-redo fa-2x" title="Reset Map" id="resetMap"></i></div>
         </div>
         <div class="card flexCol listView">
            <div class="flex"><i class="far fa-list-alt fa-2x" title="Scroll to List View" id="showListView"
               onclick="showListView()"></i></div>
         </div>
         <div class="card flexCol listViewFilter">
            <div class="flex"><i class="fas fa-filter fa-2x" title="Open Vehicle filter" id="showVehicleFilter"
               onclick="showListViewFilter()"></i></div>
         </div>
         <div class="card flexCol vehIcon">
            <div class="flex"><img src="images/dry.png" style="width:20px" onclick="showVehDetails()" /></div>
         </div>
         <div id="map" class="mapStyle">
         </div>
         <div class="vehCompact">
            <table id="dtVehicleCompact" width="100%" border="1">
               <thead>
                  <tr>
                     <th nowrap="nowrap"><input type="checkbox" id="checkboxMain" checked="true" />VEHICLES&nbsp;<span
                        class="yellow" id="vehicleCount"></span></th>
                  </tr>
               </thead>
            </table>
         </div>
         <!-- <div class="listViewClass" id="listViewClass"> -->
         <div class="row" id="tripDetailsDiv">
            <div class="col-lg-12 topRowDataList" style="z-index:10;display: flex;justify-content: space-between;">LIST VIEW<i
               onclick="goTop()" class="fas fa-map-marked-alt fa-3x showMap" title="Show Map"></i></div>
         </div>
         <table id="vehicleDatatable" style="z-index:100" class="display" border="1">
            <thead>
               <tr id="headth">
                  <th>Sl No.</th>
               </tr>
            </thead>
         </table>
         <div id="viewDashboard">
            <div class="row" style="width:100%;justify-content: center;">
               <div class="col-lg-12"><span class="dhlBack"><i class="fas fa-chevron-up blink"></i>&nbsp;&nbsp;<strong>VIEW MAP
                  </strong>&nbsp;&nbsp; <i class="fas fa-chevron-up blink"></i></span>
               </div>
            </div>
         </div>
         <!-- </div> -->
      </div>
      <div id="divVehInformation" style="display:none;">
         <div class="topBarInfo topBarbg">
            <div style="font-size:20px;color:white;display:flex;flex-direction:column;"><span id="vehicleNo"></span><span
               style="font-size:12px;text-transform: uppercase;color: aquamarine;" id="showRouteKey"></span></div>
            <i class="fas fa-times fa-2x" onclick="closeLeftInfoWindow()" style="color:#ffffff !important;cursor:pointer;"></i>
         </div>
         <div id="tripDiv">
            <div id="tripStart"></div>
            <div id="truckType"></div>
            <div id="tripEnd"></div>
         </div>
         <div id="atdEta">
            <div id="atd" title="Actual Time of Departure" class="atdClass"></div>
            <div id="eta" title="Estimated Time of Arrival" class="etaClass"></div>
         </div>
         <div class="topBarInfo" style="border-bottom:1px solid #939393;">
            <div style="display:flex;" id="vehOdometer">
            </div>
            <div><i title="Current Odometer Reading" class="fas fa-2x fa-tachometer-alt"></i>&nbsp;<span
               style="font-size:16px;"><span id="vehSpeed"></span>&nbsp;kmph</span></div>
            <div><i class="fas fa-2x fa-stop-circle" id="stoppageColor" title="Vehicle Stoppage"></i>&nbsp;<span
               id="stoppageLast"></span></div>
         </div>
         <div id="vehicleInfoDetails" style="display:flex;">
            <div style="width:82%;">
               <!-- <div class="placeholderHeader"><div>Vehicle Details</div></div> -->
               <div id="vehDivDetail" style="overflow:auto;">
                  <div id="individualTripDetail">
                     <div class="placeholderHeader">Trip Details</div>
                  </div>
                  <div id="individualVehDetail">
                     <div class="placeholderHeader">Vehicle Details</div>
                  </div>
               </div>
            </div>
            <div class="infoLeftIcons">
               <div class="leftCol"><i class="fas fa-2x fa-map-marker-alt" id="gpsColor" title="GPS"></i><span
                  id="gpsLast"></span></div>
               <div class="leftCol"><i class="fas fa-2x fa-table" id="obdColor" title="OBD"></i><span id="obdLast"></span>
               </div>
               <hr>
               <div class="leftCol">
                  <div class="flexCol">
                     <div class="flex tempR">
                        <i class="fas fa-2x fa-temperature-low" title="T@Refer"></i>
                        <div class="flexRow marg8">@R</div>
                     </div>
                     <span class="botText"></span>
                  </div>
                  <span id="reeferLast"></span>
               </div>
               <div class="leftCol">
                  <div class="flexCol">
                     <div class="flex tempR">
                        <i class="fas fa-2x fa-temperature-low" title="T@Refer"></i>
                        <div class="flexRow marg8">@M</div>
                     </div>
                     <span class="botText"></span>
                  </div>
                  <span id="middleLast"></span>
               </div>
               <div class="leftCol">
                  <div class="flexCol">
                     <div class="flex tempR">
                        <i class="fas fa-2x fa-temperature-low" title="T@Refer"></i>
                        <div class="flexRow marg8">@D</div>
                     </div>
                     <span class="botText"></span>
                  </div>
                  <span id="doorLast"></span>
               </div>
               <hr>
               <div class="leftCol"><i class="fas fa-2x fa-gas-pump padBot" title="Fuel"></i><span id="fuelLast"></span></div>
               <div class="leftCol"><i class="fas fa-2x fa-dot-circle padBot" title="Tyre Pressure" style="color:#dfdfdf;"></i>
               </div>
               <div class="leftCol"><img src="engine.png" style="width:22px;" /></div>
            </div>
         </div>
      </div>
      <div id="columnSetting" class="modal fade" role="dialog" style="width:100% !important">
         <div class="modal-dialog">
            <div class="modal-content">
               <div class="modal-header blue-gradient-rgba">
                  <h6 class="modal-title">COLUMN USER SETTINGS</h6>
               </div>
               <div class="modal-body">
                  <b>Check the items you want to display in the List View:</b>
                  <br />
                  <ul id="sortable">
                     <li class="second"><input type="checkbox" name="select-all" id="select-all" />Select All</li>
                  </ul>
               </div>
               <div class="modal-footer">
                  <input type="button" class="btn btn-success" id="columnSettingSave" value="Save" />
                  <button type="button" class="btn btn-default red-gradient-rgba" style="color:#ece9e6;"
                     data-dismiss="modal">Close</button>
               </div>
            </div>
         </div>
      </div>

    <script>
    	let iconPath = "images/";

let t4uspringappURL = '<%=t4uspringappURL%>'
let systemId = <%=systemId%>;
let mapName = '<%=mapName%>';
let customerId = <%=customerId%>;
let userId = <%=userId%>;
let nonCommHour = <%=nonCommHrs%>;
let offset = <%=offset%>;
let processId = 56;
let ltsp = '<%=isLtsp%>';
let zone = '<%=loginInfo.getZone()%>';

let initialLatLng = new L.LatLng(20.5937, 78.9629);
let initialZoom = 5;
let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';


// let t4uspringappURL = "https://track-staging.dhlsmartrucking.com/t4uspringapp/";
// let systemId = 268;
// let mapName = "HERE"
// let customerId = 5560;
// let userId = 220;
// let nonCommHour = 6;
// let offset = 330;
// let operationId = "33";
// let processId = 56;
// let ltsp = "0";
// let zone = "A";

let bounds = L.LatLngBounds();


let remarksEditingFlag = false;
let checkedCheckBoxes;

let isPlaying = false;
let isPlayPauseStop = false;


let custNameLength = 0;
let hubNameLength = 13;
let directionLength = 0;
let vehiclePlotted = "";

let lineLatLngs = [];
let plotLatLngs = [];
let clickedMarker;
let animatedMarker;
var line;

let currentZoom = 5;

let tableMain;
let tableVehCompact;
let trips = [];
let vehicles = [];
let vehiclesCompact = [];


let markerClusterArray = [];
let markerCluster;
let map = "";
let initialLoad = true;
let slNo = 1;

let headers;
let type2Headers;
let listView = [];

let markers = [];

var searchMarker;
var poiMarkerArr = [];
let poiMarkers = [];
let currentClick = "comm";

let autoCompleteResultList;
let autoCompleteOptions = [];
let getAutoCompleteResultList;
let getAutoCompleteOptions = [];



$("#viewDashboard").click(function () {
	goTop();
});

function goTop() {
	$('html, body').animate({
		scrollTop: $('html').offset().top
	}, 1000);
}


// file: script.js
// Initialize Firebase


// var config = {
//   apiKey: "AIzaSyDIxwzhEfvurvHjaebWqyV-Rz-USOs7TUw",
//   authDomain: "live-vision-25372.firebaseapp.com",
//   databaseURL: "https://live-vision-25372.firebaseio.com",
//   projectId: "live-vision-25372",
//   storageBucket: "live-vision-25372.appspot.com",
//   messagingSenderId: "903246958174"
// };

$(document).ready(function () {
	// setTimeout(function () {
	//   firebase.initializeApp(config);
	//   var dbRef = firebase.database();
	//   vehicleRef = dbRef.ref(systemId + '/' + customerId + '/');
	//   vehicleRef.on("child_changed", function (snap) {
	// markers.forEach(function (marker) {

	//   if (marker.options.vehicleNo === snap.key) {
	//     var newLatLng = new L.LatLng(snap.val().latitude, snap.val().longitude);
	//     marker.setLatLng(newLatLng);
	//     if (currentZoom < 7) {
	//       let oldIcon = marker.options.icon;
	//       let ico = L.icon({
	//         iconUrl: marker.options.icon.options.iconUrl,
	//         iconSize: [24, 24]
	//       });
	//       marker.setIcon(ico);
	//       setTimeout(function () {
	//         marker.setIcon(oldIcon);
	//       }, 20);
	//     }
	//   }
	// })
	//   });
	// }, 6000)
	setInterval(function () {
		refreshMap('running');
	}, 7000);

	setInterval(function () {
		refreshMap('idle');
	}, 11000);

	setInterval(function () {
		refreshMap('stoppage');
	}, 17000);
})

function refreshMap(type) {
	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getLiveVisionData',
		datatype: 'json',
		contentType: "application/json",
		data: {
			systemId: systemId,
			customerId: customerId,
			userId: userId
		},
		success: function (response) {
			let liveVisionData = response.responseBody;
			markers.forEach(function (marker) {
				let newData = liveVisionData.filter(function (lv) {
					return (lv.vehicleNo === marker.options.vehicleNo)
				});
				if (newData[0].category === type) {
					marker.options.angle = newData[0].direction;
					var newLatLng = new L.LatLng(newData[0].latitude, newData[0].longitude);
					marker.setLatLng(newLatLng);
					if (currentZoom < 7) {
						let oldIcon = marker.options.icon;
						let ico = L.icon({
							iconUrl: marker.options.icon.options.iconUrl,
							iconSize: [11, 24]
						});
						marker.setIcon(ico);
						setTimeout(function () {
							marker.setIcon(oldIcon);
						}, 20);
					}
				}

			})
		}
	})
}

L.RotatedMarker = L.Marker.extend({
	options: {
		angle: 0
	},
	_setPos: function (pos) {
		L.Marker.prototype._setPos.call(this, pos);
		if (L.DomUtil.TRANSFORM) {
			this._icon.style[L.DomUtil.TRANSFORM] += ' rotate(' + this.options.angle + 'deg)';
		} else if (L.Browser.ie) {
			let rad = this.options.angle * (Math.PI / 180),
				costheta = Math.cos(rad),
				sintheta = Math.sin(rad);
			this._icon.style.filter += ' progid:DXImageTransform.Microsoft.Matrix(sizingMethod=\'auto expand\', M11=' +
				costheta + ', M12=' + (-sintheta) + ', M21=' + sintheta + ', M22=' + costheta + ')';
		}
	}
});
L.rotatedMarker = function (pos, options) {
	return new L.RotatedMarker(pos, options);
};


function plotPolygon() {}

let buffermarkers = [];
let polygonmarkers = [];
let polygons = [];
let circles = [];

$("#showLabels").on("change", function () {

	map.setZoom(initialZoom);
	map.panTo(initialLatLng);
	if (this.checked) {
		markers.forEach((marker, i) => {
			marker.openTooltip();
		});
	} else {
		map.eachLayer(function (l) {
			if (l.getTooltip) {
				var toolTip = l.getTooltip();
				if (toolTip) {
					map.closeTooltip(toolTip);
				}
			}
		});
	}
})
$(document).on("change", '#showHubsBox input', function () {
	$("#loading-div").show();
	if (this.checked) {
		if ($(this).attr("hubTypeId") === "0") {
			$.ajax({
				type: 'GET',
				url: t4uspringappURL + 'getPOIDetails',
				datatype: 'json',
				contentType: "application/json",
				data: {
					systemId: systemId,
					clientId: customerId,
					userId: userId,
					tripId: 0,
					ltsp: ltsp,
					zone: zone,
					tripId: 0
				},
				success: function (response) {
					response.responseBody.forEach(function (poi) {
						bufferimage = L.icon({
							iconUrl: String(iconPath + "smartHubRedBorder.png"),
							iconSize: [50, 50],
							className: "smartHubMarker",
							popupAnchor: [0, -15]
						});
						let poiMarker = new L.Marker(new L.LatLng(poi.latitude, poi.longitude), {
							icon: bufferimage
						}).addTo(map);
						poiMarker.bindPopup("<div class='popupBoxNoBorder'>" + poi.name + "</div>");
						poiMarkers.push(poiMarker);
						$("#loading-div").hide();
					})
				}
			});
		} else {
			let hubType = $(this).attr("hubTypeId");
			$.ajax({
				type: 'GET',
				url: t4uspringappURL + 'getHubDetails',
				datatype: 'json',
				contentType: "application/json",
				data: {
					systemId: systemId,
					clientId: customerId,
					userId: userId,
					operationId: $(this).attr("hubTypeId"),
					ltsp: ltsp,
					zone: zone,
					tripId: 0
				},
				success: function (response) {
					let buffer = response.responseBody;
					var hubid = 0;
					var polygonCoords = [];
					for (let i = 0; i < buffer.length; i++) {
						let item = buffer[i];
						var convertRadiusToMeters = item['radius'] * 1000;
						var myLatLng = new L.LatLng(item['latitude'], item['longitude']);

						bufferimage = L.icon({
							iconUrl: hubType === "32" ? String(iconPath + "custhub.png") : String(iconPath + "smartHubRedBorder.png"),
							iconSize: [50, 50],
							className: "smartHubMarker",
							popupAnchor: [0, -15]
						});

						buffermarker = new L.Marker(myLatLng, {
							icon: bufferimage
						}).addTo(map);
						buffermarker.bindPopup("<div class='popupBoxNoBorder'>" + item['name'] + "</div>");


						buffermarkers.push(buffermarker);
						circles[i] = L.circle(myLatLng, {
							color: '#A7A005',
							fillColor: '#ECF086',
							fillOpacity: 0.55,
							center: myLatLng,
							radius: convertRadiusToMeters //In meters
						}).addTo(map);
						$("#loading-div").hide();

						//Plot polygonCoords


						// if (i != buffer.length - 1 && item['hubid'] == buffer[i+1]['hubid']) {
						//     var latLong = new L.LatLng(item['latitude'], item['longitude']);
						//     polygonCoords.push(latLong);
						//     continue;
						// } else {
						//     var latLong = new L.LatLng(item['latitude'], item['longitude']);
						//     polygonCoords.push(latLong);
						// }
						// var polygon = L.polygon(polygonCoords).addTo(map);
						//
						// polygonimage = L.icon({
						//     iconUrl:String(iconPath+ "smarthubmarker.png"),
						//     iconSize: [30, 30], // size of the icon
						//     popupAnchor: [0, -15]
						// });
						//
						// polygonmarker = new L.Marker(new L.LatLng(item['latitude'], item['longitude']), {
						//     bounceOnAdd: true
						// }, {
						//     icon: polygonimage
						// }).addTo(map);
						// polygonmarker.bindPopup(item['polygonname']);
						//
						// polygons[hubid] = polygon;
						// polygonmarkers[hubid] = polygonmarker;
						// hubid++;
						// polygonCoords = [];


					}

				}
			});
		}
	} else {
		$("#loading-div").hide();
		if ($(this).attr("hubTypeId") === "0") {
			poiMarkers.forEach(function (poi) {
				map.removeLayer(poi);
			})
		} else {
			for (let b = 0; b < buffermarkers.length; b++) {
				map.removeLayer(buffermarkers[b]);
			}
			for (let b = 0; b < circles.length; b++) {
				map.removeLayer(circles[b]);
			}
		}

	}
});


function loadListView(param) {
	if (!initialLoad) {
		$('#dtVehicleCompact').DataTable().search("").draw();
	}

	vehList = [];
	currentClick = param;
	tripWisePlotting = false;
	resetPolyline();

	$("#loading-div").show();
	markers.forEach(function (marker) {
		map.removeLayer(marker);
	})
	markers = [];


	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getLiveVisionListViewDetails',
		datatype: 'json',
		contentType: "application/json",
		data: {
			systemId: systemId,
			customerId: customerId,
			userId: userId,
			offset: offset,
			tripCustomerId: initialLoad ? "ALL" : (custNameLength === $("#customerName").val().length || $("#customerName").val().toString() == "") ? "ALL" : $("#customerName").val().toString(),
			hubName: initialLoad ? "ALL" : (hubNameLength === $("#hubWise").val().length || $("#hubWise").val().toString() == "") ? "ALL" : $("#hubWise").val().toString(),
			direction: initialLoad ? "ALL" : (directionLength === $("#directionWise").val().length || $("#directionWise").val().toString() == "") ? "ALL" : $("#directionWise").val().toString(),
			type: param,
			zone: zone,
			vehicleNo: "",
			nonCommHour: nonCommHour

		},
		success: function (response) {
			listView = response.responseBody;

			displayListView(true);

			initialLoad = false;
			$("#loading-div").hide();

			map.on('zoomend', function () {
				currentZoom = map.getZoom();

				markers.forEach(function (marker) {
					if (currentZoom <= 5) {
						let ico = L.icon({
							iconUrl: marker.options.icon.options.iconUrl,
							iconSize: [15, 33]
						});
						marker.setIcon(ico);
					}
					if (currentZoom > 5 && currentZoom <= 10) {
						let ico = L.icon({
							iconUrl: marker.options.icon.options.iconUrl,
							iconSize: [15, 33]
						});
						marker.setIcon(ico);
					}
					if (currentZoom > 10 && currentZoom <= 15) {
						let ico = L.icon({
							iconUrl: marker.options.icon.options.iconUrl,
							iconSize: [22, 50]
						});
						marker.setIcon(ico);
					}
					if (currentZoom > 15) {
						let ico = L.icon({
							iconUrl: marker.options.icon.options.iconUrl,
							iconSize: [27, 60]
						});
						marker.setIcon(ico);
					}

					if (currentZoom > 7) {
						if (markersForPolyline.length > 0) {
							markersForPolyline.forEach(function (mark) {
								if (mark.options.stopTime !== undefined) {
									let popupcontent = "";
									if (mark && mark.options) {
										if (mark.options.speed != null) {
											popupcontent = "<div class='flexPop'><span class='popLeft'>DATE TIME: </span><span class='pop'>" + mark.options.date + "</span></div>";
											popupcontent += "<div class='flexPop'><span class='popLeft'>LOCATION: </span><span class='pop'>" + mark.options.location + "</span></div>";
											popupcontent += "<div class='flexPop'><span class='popLeft'>SPEED:</span> <span class='pop'>" + mark.options.speed + " kmph</span></div>";
										} else {
											popupcontent = "<div class='flexPop'><span class='popLeft'>LOCATION: </span><span class='pop'>" + mark.options.location + "</span></div>";
											popupcontent += "<div class='flexPop'><span class='popLeft'>START DATE: </span><span class='pop'>" + mark.options.startTime + "</span></div>";
											popupcontent += "<div class='flexPop'><span class='popLeft'>END DATE: </span><span class='pop'>" + mark.options.endTime + "</span></div>";
											popupcontent += "<div class='flexPop'><span class='popLeft'>" + mark.options.category + ":</span> <span class='pop'>" + mark.options.stopTime + " min</span></div>";
										}
									}
									mark.addTo(map).bindPopup(popupcontent);
								}
							})
						}
					} else {
						markersForPolyline.forEach(function (mark) {
							map.removeLayer(mark)
						})
					}

				})
			});
			map.setZoom(initialZoom);
			map.panTo(initialLatLng);
		}
	});
}

function plotSingleVehicle(item) {
	
	let truck = item.vehicleGroup === "TCL" ? "truckCold" : "truckDry";
	let image = L.icon({
		iconUrl: String(iconPath + truck + ".png"),
		iconSize: [15, 33]
	});
	let marker = new L.rotatedMarker(new L.LatLng(item.latitude, item.longitude), {
		icon: image,
		angle: item.direction,
		vehicleNo: item.vehicleNo,
		uniqueTripId: item.uniqueTripId
	}).bindTooltip(item.vehicleNo, {
		permanent: false,
		direction: 'top'
	});
	marker.on('click', function (e) {
		$("#loading-div").show();
		$("#startDate").jqxDateTimeInput({
			disabled: false
		});
		$("#startTime").jqxDateTimeInput({
			disabled: false
		});
		$("#endDate").jqxDateTimeInput({
			disabled: false
		});
		$("#endTime").jqxDateTimeInput({
			disabled: false
		});
		plotOnMarkerClick(e);
	})

	marker.addTo(map);
	markers.push(marker);

}

function plotOnMarkerClick(e) {
	let tempVehList = vehList;

	resetPolyline();
	vehList = tempVehList;

	checkedCheckBoxes = $('#dtVehicleCompact tbody input:checkbox:checked');
	clickedMarker = e;
	$(".topNumSelected").removeClass("topNumSelected");

	displayVehDetails(e.target.options.vehicleNo, "");
	showVehDiv();

	listViewRefreshClickedMarker(e.target.options.vehicleNo);
	markers.forEach(function (marker) {
		if (marker.options.vehicleNo === e.target.options.vehicleNo) {
			marker.addTo(map);
		} else {
			map.removeLayer(marker);
		}
	})


}


let value = "";

$(document).ready(function () {
	$('#dtVehicleCompact').DataTable().on('search.dt', function () {
		$("#dtVehicleCompact tbody input[type='checkbox']").prop("checked", false);
		$("#checkboxMain").prop("checked", false);
		$("#vehicleCount").html("(0)");
	});

	$.ajax({
		url: t4uspringappURL + 'getLastTwoMonthsTripNo',
		datatype: 'json',
		contentType: "application/json",
		data: {
			systemId: systemId,
			custId: customerId
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
				select: function (event, ui) {
					autoCompleteShowCEDashboardOnSelect(ui.item.label);
					value = ui.item.label;
				},
				minLength: 0,
				delay: 0,
			});
		}
	});
});


function autoCompleteShowCEDashboard() {
	let selValue = "";
	let vehNo = "";
	$.each(getAutoCompleteResultList, function (i, item) {
		if (item.tripNo === value) {
			selValue = item.tripId;
			vehNo = item.tripNo.split("-")[1];
		}
	});
	showCEDashboard(selValue, vehNo);
}

let tripWisePlotting = false;

function autoCompleteShowCEDashboardOnSelect(value) {
	let selValue = "";
	let vehNo = "";
	$.each(getAutoCompleteResultList, function (i, item) {
		if (item.tripNo === value) {
			selValue = item.tripId;

			vehNo = item.tripNo.split("-")[1];
		}
	});
	resetPolyline();
	tripWisePlotting = true;
	historyAnalysis(selValue, vehNo);
}

function showCEDashboard(tripId, vehNo) {
	if (tripId == null || tripId == "") {
		sweetAlert("Invalid Trip Id");
		return;
	}
	window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/CEDashboard.jsp?tripId=" + tripId, '_blank');
}

function showOBDDashboard(vehicleNo) {
	let paramId = "liveVision";
	if (systemId == 261) {
		paramId === "liveVisionNew"
	}
	window.open("<%=request.getContextPath()%>/Jsps/OBD/VehicleDiagnosticDashBoard.jsp?RegNo=" + vehicleNo + "&ParamId=" + paramId, '_blank');
}

function showListView() {
	$('html, body').animate({
		scrollTop: $("#tripDetailsDiv").offset().top - 60
	}, 1000);

}

function showListViewFilter() {
	$(".vehCompact").toggle(1000);
}


function refresh(showLoading) {

	if (remarksEditingFlag) {
		return;
	}
	//if (isPlayPauseStop) { return; }
	if (plotClicked) {
		return;
	}
	if (showLoading) {
		$("#loading-div").show();
		closeLeftInfoWindow();
		resetPolyline();
		$("#customerName").multiselect('selectAll', false)
			.multiselect('updateButtonText');
		$("#hubWise").multiselect('selectAll', false)
			.multiselect('updateButtonText');
		$("#directionWise").multiselect('selectAll', false)
			.multiselect('updateButtonText');
		$("#regionWise").multiselect('selectAll', false)
			.multiselect('updateButtonText');

		getHubNames();
		markers.forEach(function (marker) {
			map.removeLayer(marker);
		})
		markers = [];
		loadCountsFallback();
		currentClick = "all";
		if (isPlayPauseStop) {
			isPlaying = false;
			stop();
		}

		map.removeLayer(animatedMarker)
		$("#filters").addClass("dispNone")
		$("#filters").removeClass("dispFlex")
		$('#dtVehicleCompact').DataTable().clear();
		clickedMarker = "";
		$('#dtVehicleCompact').DataTable().search("").draw();
		vehList = [];

		$.ajax({
			type: 'GET',
			url: t4uspringappURL + 'getLiveVisionListViewDetails',
			datatype: 'json',
			contentType: "application/json",
			data: {
				systemId: systemId,
				customerId: customerId,
				userId: userId,
				offset: offset,
				tripCustomerId: initialLoad ? "ALL" : (custNameLength === $("#customerName").val().length || $("#customerName").val().toString() == "") ? "ALL" : $("#customerName").val().toString(),
				hubName: initialLoad ? "ALL" : (hubNameLength === $("#hubWise").val().length || $("#hubWise").val().toString() == "") ? "ALL" : $("#hubWise").val().toString(),
				direction: initialLoad ? "ALL" : (directionLength === $("#directionWise").val().length || $("#directionWise").val().toString() == "") ? "ALL" : $("#directionWise").val().toString(),
				type: currentClick,
				zone: zone,
				vehicleNo: "",
				nonCommHour: nonCommHour
			},
			success: function (response) {
				loadCounts();
				listView = response.responseBody;
				selected("#topTotal");
				displayListView(true);
				$("#loading-div").hide();
			}
		})
	} else {
		$.ajax({
			type: 'GET',
			url: t4uspringappURL + 'getLiveVisionListViewDetails',
			datatype: 'json',
			contentType: "application/json",
			data: {
				systemId: systemId,
				customerId: customerId,
				userId: userId,
				offset: offset,
				tripCustomerId: initialLoad ? "ALL" : (custNameLength === $("#customerName").val().length || $("#customerName").val().toString() == "") ? "ALL" : $("#customerName").val().toString(),
				hubName: initialLoad ? "ALL" : (hubNameLength === $("#hubWise").val().length || $("#hubWise").val().toString() == "") ? "ALL" : $("#hubWise").val().toString(),
				direction: initialLoad ? "ALL" : (directionLength === $("#directionWise").val().length || $("#directionWise").val().toString() == "") ? "ALL" : $("#directionWise").val().toString(),
				type: currentClick,
				zone: zone,
				vehicleNo: "",
				nonCommHour: nonCommHour
			},
			success: function (response) {
				loadCounts();
				listView = response.responseBody;
				if (clickedMarker) {
					displayVehDetails(clickedMarker.target.options.vehicleNo, "");
					listViewRefreshClickedMarker(clickedMarker.target.options.vehicleNo);
				} else {
					if (!tripWisePlotting) {
						markers.forEach(function (marker) {
							map.removeLayer(marker);
						})
						markers = [];
						if (vehList.length > 0) {
							plotVehList();
						} else {
							displayListView(true);
						}
					} else {
						displayListView(false);
					}
				}

				if ($("#showLabels").is(":checked")) {
					markers.forEach((marker) => {
						marker.openTooltip();
					});
				}
				$("#loading-div").hide();
			}
		})
	}
}

function displayListView(plot) {
	let vehiclesCompact = [];
	let vehicles = [];
	slNo = 1;
	listView.forEach(function (item) {
		let vehicle = [];
		let vehicleCompact = [];
		vehicle.push(slNo++);
		headers.forEach(function (head) {
			if (item[head.columnIndex] != null) {
				if (head.columnIndex.toLowerCase() === "remarks") {
					let showEdit = "none";
					let showSave = "block";
					let showRemarks = '<input type="text" id="remarks' + vehicles.length + '"/>';
					if (item[head.columnIndex] !== "") {
						showEdit = "block";
						showSave = "none";
						showRemarks = '<input type="text" id="remarks' + vehicles.length + '" disabled value="' + item[head.columnIndex] + '"  class="removeBorder"/>';
					}
					vehicle.push('<div class="flex" style="align-items:center;">' + showRemarks + '<i style="margin-left:8px;cursor:pointer;display:' + showSave + '"  id="save' + vehicles.length + '" onclick="addRemarks(\'' + item.vehicleNo + '\',\'' + vehicles.length + '\')" class="far fa-2x fa-save"></i><i style="margin-left:8px;cursor:pointer;display:' + showEdit + '"  id="edit' + vehicles.length + '" onclick="editRemarks(\'' + item.vehicleNo + '\',\'' + vehicles.length + '\')" class="far fa-2x fa-edit"></i></div>');
				} else {
					if (head.columnIndex.toLowerCase().includes("obd") && item[head.columnIndex] !== "") {
						vehicle.push("<div style='cursor:pointer;text-decoration: underline;' onclick='showOBDDashboard(\"" + item.vehicleNo + "\")'>OBD</div>");
					} else {
						if (head.columnIndex.toLowerCase() === "location") {
							vehicle.push('<span title="' + item.location + '">' + item.location.substr(0, 25).toUpperCase() + "...</span>");
						} else {
							if (head.labelEnglish.toLowerCase().includes("stoppage time")) {
								vehicle.push(item.category === "stoppage" ? item[head.columnIndex] : "");
							} else {
								if (head.labelEnglish.toLowerCase().includes("idle time")) {
									vehicle.push(item.category === "idle" ? item[head.columnIndex] : "");
								} else {
									vehicle.push(item[head.columnIndex]);

								}
							}
						}
					}
				}
			} else {
				if (head.labelEnglish.toLowerCase().includes("image")) {
					let vGroup = item.vehicleGroup === "TCL" ? "TCL" : "";
					let truck = "truckSN" + vGroup + item.category;
					vehicle.push("<img  class='imgTbl' src='" + iconPath + truck + ".png'/>");
				} else {
					vehicle.push("");
				}
			}
		});

		vehicles.push({
			...vehicle
		});
		vehicleCompact.push("<input type='checkbox' checked=true id='checkbox" + item.vehicleNo + "' /><span class='veh'>" + item.vehicleNo + "</span>");
		vehiclesCompact.push({ ...vehicleCompact
		});
		if (plot) {
			plotSingleVehicle(item);
		}
	})

	$('#vehicleDatatable').DataTable().clear();
	tableMain.rows.add(vehicles);
	tableMain.draw();

	$('#dtVehicleCompact').DataTable().clear();
	tableVehCompact.rows.add(vehiclesCompact);
	tableVehCompact.draw();
	showHideFilters();
}

function listViewRefreshClickedMarker(vNo) {
	let vehiclesCompact = [];
	let vehicles = [];
	slNo = 1;
	$("#checkboxMain").prop("checked", false);
	listView.forEach(function (item) {
		let vehicle = [];
		let vehicleCompact = [];
		if (item.vehicleNo === vNo) {

			vehicle.push(slNo);
			headers.forEach(function (head) {
				if (item[head.columnIndex] != null) {
					if (head.columnIndex.toLowerCase() === "remarks") {
						let showEdit = "none";
						let showSave = "block";
						let showRemarks = '<input type="text" id="remarks' + vehicles.length + '"/>';
						if (item[head.columnIndex] !== "") {
							showEdit = "block";
							showSave = "none";
							showRemarks = '<input type="text" id="remarks' + vehicles.length + '" disabled value="' + item[head.columnIndex] + '"  class="removeBorder"/>';

						}
						vehicle.push('<div class="flex" style="align-items:center;">' + showRemarks + '<i style="margin-left:8px;cursor:pointer;display:' + showSave + '"  id="save' + vehicles.length + '" onclick="addRemarks(\'' + item.vehicleNo + '\',\'' + vehicles.length + '\')" class="far fa-2x fa-save"></i><i style="margin-left:8px;cursor:pointer;display:' + showEdit + '"  id="edit' + vehicles.length + '" onclick="editRemarks(\'' + item.vehicleNo + '\',\'' + vehicles.length + '\')" class="far fa-2x fa-edit"></i></div>');
					} else {
						if (head.columnIndex.toLowerCase().includes("obd") && item[head.columnIndex] !== "") {
							vehicle.push("<div style='cursor:pointer;text-decoration: underline;' onclick='showOBDDashboard(\"" + item.vehicleNo + "\")'>OBD</div>");
						} else {
							if (head.columnIndex.toLowerCase() === "location") {
								vehicle.push('<span title="' + item.location + '">' + item.location.substr(0, 25).toUpperCase() + "...</span>");
							} else {
								if (head.labelEnglish.toLowerCase().includes("stoppage time")) {
									vehicle.push(item.category === "stoppage" ? item[head.columnIndex] : "");
								} else {
									if (head.labelEnglish.toLowerCase().includes("idle time")) {
										vehicle.push(item.category === "idle" ? item[head.columnIndex] : "");
									} else {
										vehicle.push(item[head.columnIndex]);
									}
								}
							}
						}
					}
				} else {
					if (head.labelEnglish.toLowerCase().includes("image")) {
						let vGroup = item.vehicleGroup === "TCL" ? "TCL" : "";
						let truck = "truckSN" + vGroup + item.category;
						vehicle.push("<img class='imgTbl' src='" + iconPath + truck + ".png'/>");
					} else {
						vehicle.push("");
					}
				}

			});

			vehicles.push({
				...vehicle
			});
			vehicleCompact.push("<input type='checkbox' checked=true id='checkbox" + item.vehicleNo + "' /><span class='veh'>" + item.vehicleNo + "</span>");
			vehiclesCompact.unshift({ ...vehicleCompact
			});
		} else {
			vehicleCompact.push("<input type='checkbox'  id='checkbox" + item.vehicleNo + "' /><span class='veh'>" + item.vehicleNo + "</span>");
			vehiclesCompact.push({ ...vehicleCompact
			});

		}
	})

	$('#vehicleDatatable').DataTable().clear();
	tableMain.rows.add(vehicles);
	tableMain.draw();


	$('#dtVehicleCompact').DataTable().clear();
	tableVehCompact.rows.add(vehiclesCompact);
	tableVehCompact.draw();
	showHideFilters();
}

setTimeout(function () {
	$("#vehicleDatatable_wrapper .dt-buttons").append('<div style="display:flex;margin-left:120px;height:28px;margin-top:-1px;"><input onclick="showUserTableSetting()" type="button" class="btn btn-success" value="User Settings" /></div>')
}, 1000)

let userSettings;

function setColumnsVisibilyBasedOnUserSetting() {
	$.ajax({
		type: 'GET',
		datatype: 'json',
		contentType: "application/json",
		url: t4uspringappURL + "getLiveVisionColumnHeader",
		data: {
			systemId: systemId,
			clientId: customerId,
			userId: userId,
			processId: processId
		},
		success: function (result) {
			var checkstatus = "unchecked";
			userSettings = result.responseBody;
			for (var i = 0; i < userSettings.length; i++) {
				if (userSettings[i].visibility == 'false') {
					tableMain.column(userSettings[i].columnIndex + ":name").visible(false);
				} else {
					tableMain.column(userSettings[i].columnIndex + ":name").visible(true);
				}
			}

		}
	});

}

function showUserTableSetting() {
	$('#columnSetting').modal('show');
	$('#sortable').empty();
	$.ajax({
		type: 'GET',
		datatype: 'json',
		contentType: "application/json",
		url: t4uspringappURL + "getLiveVisionColumnHeader",
		data: {
			systemId: systemId,
			clientId: customerId,
			userId: userId,
			processId: processId
		},
		success: function (result) {
			var checkstatus = "unchecked";
			userSettings = result.responseBody;
			for (var i = 0; i < userSettings.length; i++) {
				if (userSettings[i].visibility == 'true') {
					checkstatus = "checked";
				} else {
					checkstatus = "unchecked";
				}
				$("#sortable").append("<li class='second'><div class='checkbox'><input id='userSetting" + i + "' name='columnSetting' type='checkbox' " + checkstatus + " columnName='" + userSettings[i].columnName + "'/></div>" + userSettings[i].labelEnglish + "</li>");
			}

		}
	});
}

$("#columnSettingSave").on("click", function () {

	let saveData = [];
	for (var i = 0; i < userSettings.length; i++) {
		let s = {
			systemId: systemId,
			clientId: customerId,
			userId: userId,
			columnName: $("#userSetting" + i).attr("columnName"),
			columnOrder: i,
			visibility: $("#userSetting" + i).is(":checked")
		}
		saveData.push(s);
	}

	$("#loading-div").show();
	$('#columnSetting').modal('hide');
	$.ajax({
		type: 'POST',
		url: t4uspringappURL + "updateLiveVisionColumnHeader",
		contentType: "application/json",
		data: JSON.stringify(saveData),
		success: function (result) {
			$("#loading-div").hide();
			setColumnsVisibilyBasedOnUserSetting();
		}
	})

})


function selected(element) {
	$(".topNumSelected").removeClass("topNumSelected");
	$(element).hasClass("topNum") ? $(element).addClass("topNumSelected") : "";
}

function viewClicked() {
	if ($("#customerName").val().toString() == "") {
		sweetAlert("Please select atleast one customer");
		return;
	}

	$(".topNumSelected").removeClass("topNumSelected");
	loadListView("");
	loadCounts();
	map.setZoom(initialZoom);
	map.panTo(initialLatLng);
}

setInterval(function () {
	refresh(false)
}, 120000);

$("#resetMap").on("click", function () {
	reset();
})

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		reset();
	}
});

function reset() {
	$("#showLabels").prop("checked", false).change();
	isPlaying = false;
	stop();
	if (vehList.length > 0) {
		resetToVehicleList();
	} else {
		resetPolyline();
	}
}

function resetFlags() {
	plotClicked = false;
	isPlaying = false;
	isPlayPauseStop = false;
	$("#popupBoxOuter").hide();
	window.clearInterval(playInterval);
	pl = 0;
}

function resetToVehicleList() {
	resetFlags();
	closeLeftInfoWindow();
	if (animatedMarker) {
		map.removeLayer(animatedMarker);
	}
	if (flagEnd) {
		map.removeLayer(flagEnd);
	}
	if (flagStart) {
		map.removeLayer(flagStart);
	}
	for (let k = 0; k < routePolylines.length; k++) {
		map.removeLayer(routePolylines[k])
	}
	if (polyLines.length > 0) {
		polyLines.forEach(function (poly) {
			map.removeLayer(poly);
		})
		polyLines = [];
	}
	markersForPolyline.forEach(function (m) {
		map.removeLayer(m);
	})
	markersForPolyline = [];
	markers.forEach(function (marker) {
		map.removeLayer(marker);
	})

	clickedMarker = "";

	$("#popupBoxOuter").hide();
	vehList.forEach(function (i) {
		$("#checkbox" + i).prop("checked", true);
	})
	showHideFilters()
	plotVehList();
	map.panTo(initialLatLng);
	map.setZoom(initialZoom);

}


function addRemarks(vehicleNo, num) {
	$.ajax({
		type: 'POST',
		url: '<%=request.getContextPath()%>/MapView.do?param=AddRemarks',
		data: {
			selectdName: vehicleNo,
			hubID: $("#remarks" + num).val()
		},
		success: function (response) {
			if (response.toLowerCase().includes("success")) {
				$("#remarks" + num).attr("disabled", true);
				$("#save" + num).hide();
				$("#edit" + num).show();
				$("#remarks" + num).addClass("removeBorder");
			}
		}
	});
}

function editRemarks(vehNo, num) {
	$("#remarks" + num).attr("disabled", false);
	$("#save" + num).show();
	$("#edit" + num).hide();
	$("#remarks" + num).removeClass("removeBorder");
}

function tConvert(time) {
	// Check correct time format and split into components
	time = time.toString().match(/^([01]\d|2[0-3])(:)([0-5]\d)(:[0-5]\d)?$/) || [time];

	if (time.length > 1) { // If time format correct
		time = time.slice(1); // Remove full string match value
		time[5] = +time[0] < 12 ? ' AM' : ' PM'; // Set AM/PM
		time[0] = +time[0] % 12 || 12; // Adjust hours
	}
	return time.join(''); // return adjusted time or original string
}


function resetPolyline() {
	resetFlags();
	$('#dtVehicleCompact').DataTable().search("").draw();
	for (var i = 0; i < poiMarkerArr.length; i++) {
		map.removeLayer(poiMarkerArr[i]);
	}
	if (animatedMarker) {
		map.removeLayer(animatedMarker);
	}
	if (flagEnd) {
		map.removeLayer(flagEnd);
	}
	if (flagStart) {
		map.removeLayer(flagStart);
	}
	clickedMarker = "";
	vehiclePlotted = "";
	$("#tripNoAutoComplete").val("");
	$("#filters").addClass("dispNone")
	$("#filters").removeClass("dispFlex")

	// lastZoom ? map.setZoom(lastZoom) : "";
	// lastBounds ? map.fitBounds(lastBounds) : "";

	map.setZoom(initialZoom);
	map.panTo(initialLatLng);
	for (let k = 0; k < routePolylines.length; k++) {
		map.removeLayer(routePolylines[k])
	}
	if (polyLines.length > 0) {
		polyLines.forEach(function (poly) {
			map.removeLayer(poly);
		})
		polyLines = [];
	}

	markersForPolyline.forEach(function (m) {
		map.removeLayer(m);
	})
	markersForPolyline = [];
	closeLeftInfoWindow();
	vehiclesCompact = [];
	vehicles = [];
	displayListView(false);
	$("#popupBoxOuter").hide();
	markers.forEach(function (marker) {
		marker.addTo(map);
	})
}


$("#checkboxMain").on("change", function () {
	if (!$('#checkboxMain').is(':checked')) {
		$("#dtVehicleCompact tbody input[type='checkbox']").prop("checked", false)
	} else {
		$("#dtVehicleCompact tbody input[type='checkbox']").prop("checked", true)
	};
	checkboxChecked();
	resetFlags();
	let numberOfChecked = $('#dtVehicleCompact tbody input:checkbox:checked').length;
	let totalCheckboxes = $('#dtVehicleCompact tbody input:checkbox').length;
	let numberNotChecked = totalCheckboxes - numberOfChecked;
	$("#vehicleCount").html(numberOfChecked > 0 ? "(" + numberOfChecked + ")" : "");
	if (numberOfChecked === 1) {
		$("#filters").removeClass("dispNone")
		$("#filters").addClass("dispFlex")
	} else {
		$("#filters").removeClass("dispFlex")
		$("#filters").addClass("dispNone")
	}

})

$(document).on("focus", "input[type='text']", function () {
	remarksEditingFlag = true;
})

$(document).on("blur", "input[type='text']", function () {
	remarksEditingFlag = false;
})

let vehListPlot = [];
let vehList = [];

$(document).on("change", "#dtVehicleCompact tbody input[type='checkbox']", function () {
	checkboxChecked()
})

function checkboxChecked() {
	resetFlags();
	let numberOfChecked = $('#dtVehicleCompact tbody input:checkbox:checked').length;
	let totalCheckboxes = $('#dtVehicleCompact tbody input:checkbox').length;
	let numberNotChecked = totalCheckboxes - numberOfChecked;
	if (numberOfChecked > 0) {
		if (clickedMarker) {
			closeLeftInfoWindow();
			clickedMarker = ""
		}
	}
	if (animatedMarker) {
		map.removeLayer(animatedMarker);
	}
	if (flagEnd) {
		map.removeLayer(flagEnd);
	}
	if (flagStart) {
		map.removeLayer(flagStart);
	}
	map.setZoom(initialZoom);
	map.panTo(initialLatLng);
	for (let k = 0; k < routePolylines.length; k++) {
		map.removeLayer(routePolylines[k])
	}
	if (polyLines.length > 0) {
		polyLines.forEach(function (poly) {
			map.removeLayer(poly);
		})
		polyLines = [];
	}

	markersForPolyline.forEach(function (m) {
		map.removeLayer(m);
	})
	markersForPolyline = [];
	markers.forEach(function (marker) {
		map.removeLayer(marker);
	})

	vehList = [];
	vehListPlot = [];

	tableVehCompact.rows().every(function (rowIdx, tableLoop, rowLoop) {
		if ($(this.node()).find("input").prop("checked")) {
			vehList.push($(this.node()).find(".veh").html());
			vehListPlot.push($(this.node()).find(".veh").html());
		}
	});

	plotVehList();
}

function plotVehList() {
	let vehicles = [];
	let num = 1;
	vehList.forEach(function (v) {
		listView.forEach(function (item) {
			if (item.vehicleNo === v) {
				plotSingleVehicle(item);
				let vehicle = [];
				vehicle.push(num++);
				headers.forEach(function (head) {
					if (item[head.columnIndex] != null) {
						if (head.columnIndex.toLowerCase() === "remarks") {
							let showEdit = "none";
							let showSave = "block";
							let showRemarks = '<input type="text" id="remarks' + vehicles.length + '"/>';
							if (item[head.columnIndex] !== "") {
								showEdit = "block";
								showSave = "none";
								showRemarks = '<input type="text" id="remarks' + vehicles.length + '" disabled value="' + item[head.columnIndex] + '"  class="removeBorder"/>';
							}
							vehicle.push('<div class="flex" style="align-items:center;">' + showRemarks + '<i style="margin-left:8px;cursor:pointer;display:' + showSave + '"  id="save' + vehicles.length + '" onclick="addRemarks(\'' + item.vehicleNo + '\',\'' + vehicles.length + '\')" class="far fa-2x fa-save"></i><i style="margin-left:8px;cursor:pointer;display:' + showEdit + '"  id="edit' + vehicles.length + '" onclick="editRemarks(\'' + item.vehicleNo + '\',\'' + vehicles.length + '\')" class="far fa-2x fa-edit"></i></div>');
						} else {
							if (head.columnIndex.toLowerCase().includes("obd") && item[head.columnIndex] !== "") {
								vehicle.push("<div style='cursor:pointer;text-decoration: underline;' onclick='showOBDDashboard(\"" + item.vehicleNo + "\")'>OBD</div>");
							} else {
								if (head.columnIndex.toLowerCase() === "location") {
									vehicle.push('<span title="' + item.location + '">' + item.location.substr(0, 25).toUpperCase() + "...</span>");
								} else {
									if (head.labelEnglish.toLowerCase().includes("stoppage time")) {
										vehicle.push(item.category === "stoppage" ? item[head.columnIndex] : "");
									} else {
										if (head.labelEnglish.toLowerCase().includes("idle time")) {
											vehicle.push(item.category === "idle" ? item[head.columnIndex] : "");
										} else {
											vehicle.push(item[head.columnIndex]);
										}
									}
								}
							}
						}
					} else {
						if (head.labelEnglish.toLowerCase().includes("image")) {

							let vGroup = item.vehicleGroup === "TCL" ? "TCL" : "";
							let truck = "truckSN" + vGroup + item.category;
							vehicle.push("<img class='imgTbl' src='" + iconPath + truck + ".png'/>");
						} else {
							vehicle.push("");
						}
					}

				});
				vehicles.push({
					...vehicle
				});
			}
		})
	})

	$('#vehicleDatatable').DataTable().clear();
	tableMain.rows.add(vehicles);
	tableMain.draw();
	showHideFilters();
}

let polyLines = [];
let lastZoom;
let lastBounds;
let markersForPolyline = [];
let routePolylines = [];

function drawRoute(latlonS, latlonD, polylatlongs) {
	var route = new Array();
	var waypoints = 'waypoint0=' + latlonS.lat + ',' + latlonS.lng;
	route.push({
		lat: latlonS.lat,
		lng: latlonS.lng
	});
	var counter = 0;
	for (var i = 0; i < polylatlongs.length; i++) {
		counter = i + 1;
		route.push({
			lat: polylatlongs[i].lat,
			lng: polylatlongs[i].lng
		});
		waypoints = waypoints + '&waypoint' + (counter) + '=' + polylatlongs[i].lat + ',' + polylatlongs[i].lng;
	}
	route.push({
		lat: latlonD.lat,
		lng: latlonD.lng
	});
	waypoints = waypoints + '&waypoint' + (counter + 1) + '=' + latlonD.lat + ',' + latlonD.lng;

	if (mapName === 'HERE') {

		var url = 'https://route.api.here.com/routing/7.2/calculateroute.json?' + waypoints + '&mode=' + '<%=bean.getRoutingType()%>' + ';' + '<%=bean.getVehicleType()%>' + ';traffic:disabled&routeattributes=shape&excludeCountries=BGD,PAK,NPL,BTN,CHN&app_id=' + '<%=appKey%>' + '&app_code=' + '<%=appCode%>';
		fetch(url).then(function (response) {
			resp = response.json();
			return resp;
		}).then(function (json) {
			var shape = json.response.route[0].shape.map(x => x.split(","));
			poly = L.polyline(shape).addTo(map);
			poly.setStyle({
				color: 'blue'
			});
			routePolylines.push(poly);
			if (clickedMarker && clickedMarker.target.options.uniqueTripId !== 0) {
				polyLines.forEach(function (poly) {
					poly.addTo(map);
				});
				$("#loading-div").hide();
			}
			map.fitBounds(poly.getBounds());
			map.fitBounds(poly.getLatLngs());
			$('#routeLoad').hide();
		})

	} else {

		var strRoute = JSON.stringify(route);
		var url = 'http://localhost:1080/T4uMaps/GraphHopperMapRouteFinder';
		fetch(url, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: strRoute
		}).then(function (response) {
			resp = response.json();
			return resp;
		}).then(function (json) {
			if ('MapData' in json) {
				var shape = json.MapData.osmPoliLine.map(x => x.split(","));
				var poly = L.polyline(shape).addTo(map);
			} else {
				alert("No Routes Found.....");
			}

		})

	}

}

let historyData;
let plotClicked = false;

function historyAnalysis(tripId, vehNo) {
	singleVehicle = 0;


	if (tripId === '') {
		plotClicked = true;
		markersForPolyline.forEach(function (mark) {
			map.removeLayer(mark)
		})
		displayVehDetails(vehiclePlotted, "plot");
		tripWisePlotting = false;
		closeLeftInfoWindow();
	} else {
		resetFlags();
		lineLatLngs = [];
		plotLatLngs = [];
		vehiclePlotted = vehNo;
		resetPolyline();
		$("#loading-div").show();
		markers.forEach(function (marker) {
			if (marker.options.vehicleNo !== vehNo) {
				map.removeLayer(marker);
			} else {
				marker.addTo(map);

			}
		})
		$("#filters").removeClass("dispNone")
		$("#filters").addClass("dispFlex")

		if (tripId === '') {
			$("#startDate").jqxDateTimeInput({
				disabled: false
			});
			$("#startTime").jqxDateTimeInput({
				disabled: false
			});
			$("#endDate").jqxDateTimeInput({
				disabled: false
			});
			$("#endTime").jqxDateTimeInput({
				disabled: false
			});
		} else {
			$("#startDate").jqxDateTimeInput({
				disabled: true
			});
			$("#startTime").jqxDateTimeInput({
				disabled: true
			});
			$("#endDate").jqxDateTimeInput({
				disabled: true
			});
			$("#endTime").jqxDateTimeInput({
				disabled: true
			});
		}
		$.ajax({
			type: 'GET',
			url: t4uspringappURL + 'getTripWiseHistoryDataDetails',
			datatype: 'json',
			contentType: "application/json",
			data: {
				systemId: systemId,
				customerId: customerId,
				userId: userId,
				offset: offset,
				tripId: tripId,
				zone: zone
			},
			success: function (response) {
				historyData = response.responseBody;
				plotHistoryData("");
			}
		});
	}
}

let firstLatLng;
let aniMarkerCount = 0;
let firstAnimLatLng;
let speed = 1000;
let pl = 0;
let playInterval;


function play(e) {
	isPlaying = true;
	isPlayPauseStop = true;
	$(e).css({
		color: "green"
	});
	$("#pause").css({
		color: "white"
	});
	$("#stop").css({
		color: "white"
	});
	map.setZoom(15);
	pl === 0 ? map.panTo(firstLatLng) : "";


	playInterval = window.setInterval(setIntervalFn, speed / $("#speedRange").val());

}


function setIntervalFn() {

	let popupcontent = "";
	if (plotLatLngs[pl].length < 6) {
		popupcontent = "<div class='flexPop'><span class='popLeft'>DATE TIME: </span><span class='pop'>" + plotLatLngs[pl][2] + "</span></div>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>LOCATION: </span><span class='pop'>" + plotLatLngs[pl][3] + "</span></div>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>SPEED:</span> <span class='pop'>" + plotLatLngs[pl][4] + " kmph</span></div>";
	} else {
		popupcontent = "<div class='flexPop'><span class='popLeft'>LOCATION: </span><span class='pop'>" + plotLatLngs[pl][4] + "</span></div>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>START DATE: </span><span class='pop'>" + plotLatLngs[pl][2] + "</span></div>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>END DATE: </span><span class='pop'>" + plotLatLngs[pl][3] + "</span></div>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>" + plotLatLngs[pl][5] + ":</span> <span class='pop'>" + plotLatLngs[pl][6] + " min</span></div>";
	}

	popupcontent += "<div class='flexPop'><span class='popLeft'>LAT LNG:</span> <span class='pop'>" + plotLatLngs[pl][0] + ", " + plotLatLngs[pl][1] + " </span></div>";

	$("#popupBox").html(popupcontent);
	pl === 0 ? $("#popupBoxOuter").show() : "";

	animatedMarker.setLatLng(new L.LatLng(plotLatLngs[pl][0], plotLatLngs[pl][1]));
	map.panTo(new L.LatLng(plotLatLngs[pl][0], plotLatLngs[pl][1]));
	pl++;
	if (pl + 1 == plotLatLngs.length) {
		stop();
	}
}

$("#speedRange").on("change", function () {
	if (isPlaying) {
		window.clearInterval(playInterval);
		playInterval = window.setInterval(setIntervalFn, speed / $("#speedRange").val());
	}
})

function pause(e) {
	$(e).css({
		color: "#ffcc00"
	});
	$("#play").css({
		color: "white"
	});
	$("#stop").css({
		color: "white"
	});
	window.clearInterval(playInterval);
	isPlaying = false;
}

function stop(e) {
	isPlaying = false;
	$(e).css({
		color: "#d40511"
	});
	$("#play").css({
		color: "white"
	});
	$("#pause").css({
		color: "white"
	});
	map.removeLayer(animatedMarker)
	window.clearInterval(playInterval);
	aniMarkerCount = 0;
	pl = 0;
	$("#popupBoxOuter").hide();
	let ic = L.icon({
		iconUrl: String(iconPath + "anim.png"),
		iconSize: [25, 39],
		className: "animMarker"
	});
	animatedMarker = new L.Marker(firstLatLng, {
		icon: ic
	})
	animatedMarker.addTo(map);
	map.panTo(firstLatLng);
}


function displayVehDetails(vehNo, type) {
	if (type === "plot") {
		if ($("#startDate").val() === "") {
			sweetAlert("Please pick a Start Date");
			return;
		}
		if ($("#startTime").val() === "") {
			sweetAlert("Please pick a Start Time");
			return;
		}
		if ($("#endDate").val() === "") {
			sweetAlert("Please pick an End Date");
			return;
		}
		if ($("#endTime").val() === "") {
			sweetAlert("Please pick an End Time");
			return;
		}
		if (new Date($("#startDate").val().split("/").reverse().join("-") + " " + $("#startTime").val()) > new Date($("#endDate").val().split("/").reverse().join("-") + " " + $("#endTime").val())) {
			sweetAlert("Start Date should be before End Date");
			return;
		}
	}

	lineLatLngs = [];
	plotLatLngs = [];
	if (type === "plot") {
		if (polyLines.length > 0) {
			polyLines.forEach(function (poly) {
				map.removeLayer(poly);
			})
			polyLines = [];
		}
		vehListPlot.forEach(function (v) {
			listView.forEach(function (item) {
				if (item.vehicleNo === v) {
					vehNo = item.vehicleNo;
				}
			})
		})
	}
	vehiclePlotted = vehNo;
	$("#filters").removeClass("dispNone")
	$("#filters").addClass("dispFlex")
	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getRouteByVehicleNo',
		datatype: 'json',
		contentType: "application/json",
		data: {
			vehicleNo: vehNo
		},
		success: function (response) {
			results = response.responseBody;

			if (results !== null) {
				var polylatlongs = [];
				var latlonS;
				var latlonD;
				for (var i = 0; i < results.length; i++) {
					if ((results[i].type == 'SOURCE')) {
						latlonS = new L.LatLng(results[i].lat, results[i].lon);
					}
					if (results[i].type == 'DESTINATION') {
						latlonD = new L.LatLng(results[i].lat, results[i].lon);
					}
					if (results[i].type == 'CHECKPOINT') {
						polylatlongs.push(new L.LatLng(results[i].lat, results[i].lon));
					}
					if (results[i].type == 'DRAGPOINT') {
						polylatlongs.push(new L.LatLng(results[i].lat, results[i].lon));
					}
				}
				drawRoute(latlonS, latlonD, polylatlongs);
				if (flagEnd) {
					map.removeLayer(flagEnd);
				}
				if (flagStart) {
					map.removeLayer(flagStart);
				}
				flagEnd = new L.Marker(latlonD).addTo(map);
				let ico = L.icon({
					iconUrl: String(iconPath + "flagEnd.png"),
					iconSize: [50, 50],
					className: "flagOffset",
					popupAnchor: [0, 0]
				});
				flagEnd.setIcon(ico);
				flagStart = new L.Marker(latlonS).addTo(map);
				let icoStart = L.icon({
					iconUrl: String(iconPath + "flag.png"),
					iconSize: [50, 50],
					className: "flagOffset",
					popupAnchor: [0, 0]
				});
				flagStart.setIcon(icoStart);

			}

		}
	})


	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getHistoryDataDetails',
		datatype: 'json',
		contentType: "application/json",
		data: {
			systemId: systemId,
			customerId: customerId,
			userId: userId,
			offset: offset,
			vehicleNo: vehNo,
			startDate: type === "plot" ? $("#startDate").val().split("/").reverse().join("-") + " " + $("#startTime").val().split(" ")[0] : "",
			endDate: type === "plot" ? $("#endDate").val().split("/").reverse().join("-") + " " + $("#endTime").val().split(" ")[0] : "",
			zone: zone
		},
		success: function (response) {
			historyData = response.responseBody;
			plotHistoryData(type);
		}

	});


	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getLiveVisionHeaders',
		datatype: 'json',
		contentType: "application/json",
		data: {
			processId: processId,
			type: 2
		},
		success: function (response) {
			type2Headers = response.responseBody;
			$("#individualVehDetail").html('<div class="placeholderHeader">Vehicle Details</div>');
			$("#individualTripDetail").html('<div class="placeholderHeader">Trip Details</div>');
			listView.forEach(function (item) {
				if (item.vehicleNo === vehNo) {
					let lastCommDate = item.lastCommunication.split(" ")[0].split("/");
					let lastCommTime = item.lastCommunication.split(" ")[1]
					let gpsVal = ((new Date() - new Date(lastCommDate[1] + "/" + lastCommDate[0] + "/" + lastCommDate[2] + " " + lastCommTime)) / 1000) / 60
					$("#gpsLast").html(parseInt(gpsVal) + " min");
					if (parseInt(gpsVal) > 360) {
						$("#gpsColor").addClass("red");
						$("#gpsLast").addClass("red");
						$("#gpsColor").removeClass("green");
						$("#gpsLast").removeClass("green");
					} else {
						$("#gpsColor").addClass("green");
						$("#gpsLast").addClass("green");
						$("#gpsColor").removeClass("red");
						$("#gpsLast").removeClass("red");
					}


					lastCommDate = item.obdDateTime.split(" ")[0].split("/");
					lastCommTime = item.obdDateTime.split(" ")[1]
					let obdVal = ((new Date() - new Date(lastCommDate[1] + "/" + lastCommDate[0] + "/" + lastCommDate[2] + " " + lastCommTime)) / 1000) / 60
					$("#obdLast").html(parseInt(obdVal) + " min");
					if (parseInt(obdVal) > 360) {
						$("#obdColor").addClass("red");
						$("#obdLast").addClass("red");
						$("#obdColor").removeClass("green");
						$("#obdLast").removeClass("green");
					} else {
						$("#obdColor").addClass("green");
						$("#obdLast").addClass("green");
						$("#obdColor").removeClass("red");
						$("#obdLast").removeClass("red");
					}

					if (item.temperatureForTcl == "") {
						$("#reeferLast").html("NA");
						$("#middleLast").html("NA");
						$("#doorLast").html("NA");
					} else {
						$("#reeferLast").html(item.temperatureForTcl.split(",")[0].split("=")[1] + " °C");
						$("#middleLast").html(item.temperatureForTcl.split(",")[1].split("=")[1] + " °C");
						$("#doorLast").html(item.temperatureForTcl.split(",")[2].split("=")[1] + " °C");
					}

					$("#fuelLast").html(item.fuelLiter);

					if (item.category === "stoppage") {
						$("#stoppageColor").addClass("red");
						$("#stoppageLast").html(item.duration);
					}
					if (item.category === "idle") {
						$("#stoppageColor").addClass("yellow");
						$("#stoppageLast").html(item.duration);
					}
					if (item.category === "running") {
						$("#stoppageColor").removeClass("red");
						$("#stoppageColor").removeClass("yellow");
						$("#stoppageLast").html("");
					}

					$("#vehSpeed").html(item.speed);
					$("#vehicleNo").html(item.vehicleGroup === "TCL" ? "<img style='width:50px' src='" + iconPath + "cold.png'>" + " " + item.vehicleNo : "<img  style='width:50px' src='" + iconPath + "dry.png'>" + " " + item.vehicleNo);
					item.uniqueTripId !== 0 ? $("#tripDiv").show() : $("#tripDiv").hide();
					item.uniqueTripId !== 0 ? $("#atdEta").show() : $("#atdEta").hide();

					$("#tripStart").html(item.uniqueTripId !== 0 ? item.routeKey.split("_")[0] : "");
					$("#tripEnd").html(item.uniqueTripId !== 0 ? item.routeKey.split("_")[1] : "");
					$("#truckType").html(item.vehicleGroup === "TCL" ? "<img src='" + iconPath + "cold.png'>" : "<img src='" + iconPath + "dry.png'>");

					let odo = item.odometer.split("");
					$("#vehOdometer").html("");
					odo.forEach(function (o) {
						$("#vehOdometer").append('<div class="odo">' + o + '</div>');
					})


					response.responseBody.forEach(function (head) {
						let displayVal = item[head.columnIndex];
						let headLabel = head.labelEnglish;
						if (head.labelEnglish.toLowerCase().includes("communication")) {
							headLabel = headLabel.replace("Communication", "COMM");
						}
						if (head.labelEnglish.toLowerCase().includes("destination")) {
							headLabel = headLabel.replace("Destination", "DEST");
						}
						if (head.labelEnglish.toLowerCase() === "atd") {
							$("#atd").html(displayVal);
						}
						if (head.labelEnglish.toLowerCase().includes("eta to dest")) {
							$("#eta").html(displayVal);
						}

						if (head.labelEnglish.toLowerCase().includes("driver name") || head.labelEnglish.toLowerCase().includes("location") || head.labelEnglish.toLowerCase().includes("trip id") || head.labelEnglish.toLowerCase().includes("route name")) {
							displayVal = '<span title="' + displayVal + '">' + displayVal.substr(0, 20).toUpperCase() + "...</span>";
						}
						if (head.labelEnglish.toLowerCase().includes("idle") && item.category !== "idle") {
							displayVal = "00:00";
						}
						if (head.labelEnglish.toLowerCase().includes("stoppage") && item.category !== "stoppage") {
							displayVal = "00:00";
						}
						if (head.labelEnglish.toLowerCase().includes("idle") || head.labelEnglish.toLowerCase().includes("stoppage")) {
							displayVal += " (HH.MM)";
						}
						if (head.labelEnglish.toLowerCase() === "speed") {
							displayVal += " (kmph)";
						}
						if (head.category === "vehicle") {
							$("#individualVehDetail").append("<div class='placeholder'><div class='topHeader' style='width:40%;padding-right:4px;color: #ffffff'>" + headLabel + " </div><div style='color: #A9C8E5;width:60%;'>" + displayVal + "</div></div>")
						} else {
							$("#individualTripDetail").append("<div class='placeholder'><div class='topHeader' style='width:40%;padding-right:4px;color: #ffffff'>" + headLabel + " </div><div style='color: #A9C8E5;width:60%;'>" + displayVal + "</div></div>")

						}
					})

					item.uniqueTripId === 0 ? $("#individualTripDetail").hide() : $("#individualTripDetail").show();

				}
			})
		}
	})
}

let flagEnd;
let flagStart;

function plotHistoryData(type) {
	var prevCategory = "";
	let latLng = [];
	if (animatedMarker) {
		map.removeLayer(animatedMarker);
	}

	if (type === "") {
		$("#startDate").val(historyData.startDate.split(" ")[0].split("-").reverse().join("/"))
		$("#startTime").val(tConvert(historyData.startDate.split(" ")[1]))
		$("#endDate").val(historyData.endDate.split(" ")[0].split("-").reverse().join("/"))
		$("#endTime").val(tConvert(historyData.endDate.split(" ")[1]))
	}

	let startStoppage = true;
	let startDateStoppage;
	let endDateStoppage;
	let plotStopMarker = false;
	let stoppageLocation = "";
	let lastLatLng;
	let polyColor;
	let runningColor = "#1B5E20";
	let idleColor = "#FF6A00";
	let stopColor = "#d40511"
	historyData.historyDataDetails.forEach(function (i, index) {
		index === 0 ? firstLatLng = new L.LatLng(i.latitude, i.longitude) : "";
		lastLatLng = new L.LatLng(i.latitude, i.longitude);

		if (i.category === "RUNNING") {
			let markerPoly = new L.Marker(new L.LatLng(i.latitude, i.longitude), {
				date: i.datetime,
				location: i.location,
				speed: i.speed
			})
			let ico = L.icon({
				iconUrl: String(iconPath + "smartHubRed.png"),
				iconSize: [0, 0],
				popupAnchor: [0, 0]
			});
			markerPoly.setIcon(ico);
			markersForPolyline.push(markerPoly);
		}


		if (prevCategory !== "" && i.category !== prevCategory) {
			let lastPrev = latLng[latLng.length - 1];
			polyColor = runningColor;
			if (prevCategory === "IDLE") {
				polyColor = idleColor;
				endDateStoppage = i.datetime;
				startStoppage = true;
				plotStopMarker = true;
			}
			if (prevCategory === "STOP") {
				polyColor = stopColor;
				endDateStoppage = i.datetime;
				startStoppage = true;
				plotStopMarker = true;
			}

			if (plotStopMarker) {
				let startlastCommDate = startDateStoppage && startDateStoppage.split(" ")[0].split("/");
				let startlastCommTime = startDateStoppage && startDateStoppage.split(" ")[1];
				let endlastCommDate = endDateStoppage && endDateStoppage.split(" ")[0].split("/");
				let endlastCommTime = endDateStoppage && endDateStoppage.split(" ")[1];
				let stopTime = "";
				if (startlastCommDate && startlastCommTime && endlastCommDate && endlastCommTime) {
					stopTime = ((new Date(endlastCommDate[1] + "/" + endlastCommDate[0] + "/" + endlastCommDate[2] + " " + endlastCommTime) - new Date(startlastCommDate[1] + "/" + startlastCommDate[0] + "/" + startlastCommDate[2] + " " + startlastCommTime)) / 1000) / 60
					stopTime = stopTime.toFixed(2);
				}
				let markerPoly = new L.Marker(new L.LatLng(i.latitude, i.longitude), {
					startTime: startDateStoppage,
					endTime: endDateStoppage,
					location: stoppageLocation,
					stopTime: stopTime,
					category: prevCategory
				})
				let idleStopImage = prevCategory.toLowerCase() === "idle" ? "/ApplicationImages/VehicleImages/yellowbal.png" : "/ApplicationImages/VehicleImages/redbal.png";
				let ico = L.icon({
					iconUrl: String(idleStopImage),
					iconSize: [20, 20],
					className: "redHub",
					popupAnchor: [0, -30]
				});
				markerPoly.setIcon(ico);
				markersForPolyline.push(markerPoly);
				plotStopMarker = false;


				if (plotLatLngs.length > 0) {
					if (plotLatLngs[plotLatLngs.length - 1][0] !== i.latitude || plotLatLngs[plotLatLngs.length - 1][1] !== i.longitude) {
						plotLatLngs.push([i.latitude, i.longitude, startDateStoppage, endDateStoppage, stoppageLocation, prevCategory, stopTime]);
					}
				} else {
					plotLatLngs.push([i.latitude, i.longitude, startDateStoppage, endDateStoppage, stoppageLocation, prevCategory, stopTime]);
				}

			}

			if (i.category === "IDLE" || i.category === "STOP") {
				if (startStoppage) {
					startDateStoppage = i.datetime;
					stoppageLocation = i.location;
					startStoppage = false;
				}
			}


			let polyline = L.polyline(latLng, {
				className: 'animate',
				color: polyColor,
				weight: polyColor === stopColor ? 10 : polyColor === idleColor ? 6 : 5,
				smoothFactor: 1
			});
			polyLines.push(polyline);
			latLng = [];

			latLng.push(lastPrev);
			lineLatLngs.push([lastPrev.lat, lastPrev.lng]);

		}
		prevCategory = i.category;

		if (plotLatLngs.length > 0) {
			if (plotLatLngs[plotLatLngs.length - 1][0] !== i.latitude || plotLatLngs[plotLatLngs.length - 1][1] !== i.longitude) {
				plotLatLngs.push([i.latitude, i.longitude, i.datetime, i.location, i.speed]);
			}
		} else {
			plotLatLngs.push([i.latitude, i.longitude, i.datetime, i.location, i.speed]);
		}
		latLng.push(new L.LatLng(i.latitude, i.longitude));
		lineLatLngs.push([i.latitude, i.longitude]);


	})


	let polyline = L.polyline(latLng, {
		className: 'animate',
		color: polyColor,
		weight: polyColor === stopColor ? 10 : polyColor === idleColor ? 6 : 5,
		smoothFactor: 1
	});
	polyLines.push(polyline);
	if (typeof clickedMarker === 'undefined' || clickedMarker === "") {
		polyLines.forEach(function (poly) {
			poly.addTo(map);
		});
		$("#loading-div").hide();
	} else {
		if (clickedMarker.target.options.uniqueTripId === 0) {
			polyLines.forEach(function (poly) {
				poly.addTo(map);
			});
			$("#loading-div").hide();
		}
	}

	lastZoom = map.getZoom();
	lastBounds = map.getBounds();
	line = L.polyline(lineLatLngs);
	let ic = L.icon({
		iconUrl: String(iconPath + "anim.png"),
		iconSize: [25, 39],
		className: "animMarker"

	});
	if (markersForPolyline.length > 0) {

		animatedMarker = new L.Marker(firstLatLng, {
			icon: ic
		})
		animatedMarker.addTo(map);
		if ($('#tripNoAutoComplete').val() != '') {
			vehiclePlotted = $('#tripNoAutoComplete').val().split("-")[1];
		}

		let popupcontent = "<div class='popupBox'>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>VEHICLE NO: </span><span class='pop'>" + vehiclePlotted + "</span></div>";
		if ($('#tripNoAutoComplete').val() != '') {
			popupcontent += "<div class='flexPop'><span class='popLeft'>TRIP NO: </span><span class='pop'>" + $('#tripNoAutoComplete').val().split("-")[0] + "</span></div>";
		}
		popupcontent += "<div class='flexPop'><span class='popLeft'>LOCATION: </span><span class='pop'>" + markersForPolyline[0].options.location + "</span></div>";
		popupcontent += "<div class='flexPop'><span class='popLeft'>DATE TIME: </span><span class='pop'>" + markersForPolyline[0].options.date + "</span></div>";
		popupcontent += "</div>";

		animatedMarker.bindPopup(popupcontent)

		//map.addLayer(animatedMarker);
		map.fitBounds(line.getBounds());
		map.fitBounds(line.getLatLngs());
	}

	// map.panTo(line.getLatLngs())

}


$(document).ready(function () {
	let vehDHeight = $(window).height() - 230;
	$("#vehDivDetail").css({
		"height": vehDHeight + "px"
	});
	$("#tripDetailsDiv").css({
		"margin-top": ($(window).height() + 24) + "px"
	});

	var dThreeMonths = new Date();
	dThreeMonths.setMonth(dThreeMonths.getMonth() - 3);

	$("#startDate").jqxDateTimeInput({
		min: dThreeMonths,
		width: '105px',
		height: '20px'
	});
	$("#startTime").jqxDateTimeInput({
		formatString: "T",
		showTimeButton: true,
		showCalendarButton: false,
		width: '115px',
		height: '20px'
	});
	$("#endDate").jqxDateTimeInput({
		min: dThreeMonths,
		width: '105px',
		height: '20px'
	});
	$("#endTime").jqxDateTimeInput({
		formatString: "T",
		showTimeButton: true,
		showCalendarButton: false,
		width: '115px',
		height: '20px'
	});
	initialize("map", initialLatLng, '<%=mapName%>', '<%=appKey%>', '<%=appCode%>');

	setTimeout(() => {
		if (systemId == 268) {
			map.on('click', function (e) {

				var latlngArr = map.mouseEventToLatLng(e.originalEvent);
				searchMarker = new L.Marker(new L.LatLng(latlngArr.lat, latlngArr.lng)).addTo(map);
				searchMarker.bindPopup('<div id="searchDiv" seamless="seamless" scrolling="no" style="overflow:auto;color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +
					'<table>' +
					'<tr><select id="input-field" class="popup-input" style="border-radius: 4px;border: 1px solid;height: 22px;margin-right: 2px;"><option value="petrol">Fuel Pumps</option><option value="police">Police Station</option><option value="restaurants">Restaurants</option><option value="hospital">Hospitals</option></select><button type="button" class="btn btn-primary" onclick="getNearbyPois(' + latlngArr.lat + ',' + latlngArr.lng + ')"' + '>Search</button></tr>' +
					'</table>' +
					'</div>').openPopup();
				searchMarker.on('popupclose', function (e) {
					map.removeLayer(searchMarker);
				})
			});
		}
		// var plugin = L.control.measure({
		//   //  control position
		//   position: 'topleft',
		//   //  weather to use keyboard control for this plugin
		//   keyboard: false,
		//   //  shortcut to activate measure
		//   activeKeyCode: 'M'.charCodeAt(0),
		//   //  shortcut to cancel measure, defaults to 'Esc'
		//   cancelKeyCode: 27,
		//   //  line color
		//   lineColor: 'red',
		//   //  line weight
		//   lineWeight: 2,
		//   //  line dash
		//   lineDashArray: '6, 6',
		//   //  line opacity
		//   lineOpacity: 1,
		//   //  distance formatter
		//   // formatDistance: function (val) {
		//   //   return Math.round(1000 * val / 1609.344) / 1000 + 'mile';
		//   // }
		// }).addTo(map)
	}, 1000);


	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getHubTypes',
		datatype: 'json',
		contentType: "application/json",
		data: {
			systemId: systemId,
			clientId: customerId,
			userId: userId,
			zone: zone,
			ltsp: ltsp
		},
		success: function (response) {
			response.responseBody.forEach(function (hub) {
				$("#showHubsBox").prepend('<div class="flex flexAlign"><input type="checkbox" hubTypeId="' + hub.hubTypeId + '" style="margin-right:4px;"/>' + hub.hubType + '</div>')
			})
		}
	})

	loadCounts();

	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getLiveVisionHeaders',
		datatype: 'json',
		contentType: "application/json",
		data: {
			processId: processId,
			type: 1
		},
		success: function (response) {
			headers = response.responseBody;

			let th = "";
			let colDefLV = [];

			headers.forEach(function (head, index) {
				th += "<th>" + head.labelEnglish + "</th>";
				colDefLV.push({
					"name": head.columnIndex,
					"targets": index + 1
				})
			})

			$("#headth").append(th);

			if ($.fn.DataTable.isDataTable("#vehicleDatatable")) {
				$('#vehicleDatatable').DataTable().clear().destroy();
			}

			tableMain = $('#vehicleDatatable').DataTable({
				data: trips,
				paging: true,
				"bLengthChange": true,
				processing: true,
				deferRender: true,
				scrollY: "500px",
				scrollX: true,
				scrollCollapse: true,
				dom: 'Bfrtip',
				pageLength: 50,
				absoluteColumns: {
					leftColumns: 4
				},
				"columnDefs": colDefLV,
				buttons: [
					$.extend(true, {}, buttonCommon, {
						extend: 'excelHtml5',
						text: 'Quick Export',
						title: 'List View Details',
						className: 'btn btn-primary excelWidth',
						exportOptions: {
							columns: ':visible'
						}
					})

				]
			});
			if ($.fn.DataTable.isDataTable("#dtVehicleCompact")) {
				$('#dtVehicleCompact').DataTable().clear().destroy();
			}
			setColumnsVisibilyBasedOnUserSetting();
			tableVehCompact = $('#dtVehicleCompact').DataTable({
				"scrollY": $(window).height() - 270,
				"scrollX": true,
				"paging": false,
				"info": false,
				"order": [],
				"ordering": false,
				"language": {
					search: "",
					searchPlaceholder: "FIND VEHICLE ..."
				},
				"columnDefs": []
			});


			$('#dtVehicleCompact tbody')
				.on('click', "tr", function () {
					showHideFilters();
					if (!$(this).find("input").prop("checked")) {
						$(this).find("input").prop("checked", false)
					} else {
						$(this).find("input").prop("checked", true)
					}
				});

			$("#loading-divInitial").hide();
			$("#loading-div").show();

			loadListView("comm");
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
				nonSelectedText: 'NONE',
				includeSelectAllOption: true,
				enableFiltering: true,
				enableCaseInsensitiveFiltering: true,
				numberDisplayed: 1,
				allSelectedText: 'ALL',
				buttonWidth: 112,
				maxHeight: 200,
				includeSelectAllOption: true,
				selectAllText: 'ALL',
				selectAllValue: 'ALL',
				onDropdownHide: function () {
					$('button.multiselect-clear-filter').click();
				}
			});
			$("#customerName").multiselect('selectAll', false);
			$("#customerName").multiselect('updateButtonText');
		}
	});

	$('#regionWise').multiselect({
		nonSelectedText: 'NONE',
		includeSelectAllOption: true,
		enableFiltering: true,
		enableCaseInsensitiveFiltering: true,
		numberDisplayed: 1,
		allSelectedText: 'ALL',
		buttonWidth: 112,
		maxHeight: 200,
		includeSelectAllOption: true,
		selectAllText: 'ALL',
		selectAllValue: 'ALL',
		onDropdownHide: function () {
			$('button.multiselect-clear-filter').click();
		}
	});
	$("#regionWise").multiselect('selectAll', false);
	$("#regionWise").multiselect('updateButtonText');

	directionLength = 2;
	$('#directionWise').multiselect({
		nonSelectedText: 'NONE',
		includeSelectAllOption: true,
		enableFiltering: true,
		enableCaseInsensitiveFiltering: true,
		numberDisplayed: 1,
		allSelectedText: 'ALL',
		buttonWidth: 112,
		maxHeight: 200,
		includeSelectAllOption: true,
		selectAllText: 'ALL',
		selectAllValue: 'ALL',
		onDropdownHide: function () {
			$('button.multiselect-clear-filter').click();
		}
	});
	$("#directionWise").multiselect('selectAll', false);
	$("#directionWise").multiselect('updateButtonText');


	getHubNames();


});

function getHubNames(select) {
	$("#hubWise").html("");
	$("#hubWise").multiselect('destroy');
	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getSmartHubs',
		datatype: 'json',
		contentType: "application/json",
		data: {
			customerId: customerId,
			systemId: systemId,
			region: $('#regionWise').val().toString()
		},
		success: function (response) {
			hubList = response.responseBody;
			var output = '';
			//hubNameLength = hubList.length;
			for (var i = 0; i < hubList.length; i++) {
				$('#hubWise').append($("<option></option>").attr("value", hubList[i].hubId).text(hubList[i].hubName));
			}
			$('#hubWise').multiselect({
				nonSelectedText: 'NONE',
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
var buttonCommon = {
	exportOptions: {
		format: {
			body: function (data, row, column, node) {
				if (data.toString().includes("<span")) {
					let ret = data.toString().replace('<span title="', '');
					return ret.split('">')[0];
				} else {
					if (data.toString().includes("input")) {
						return $("#" + data.toString().split(" ")[4].split('"')[1]).val();
					} else if (data.toString().includes("<img")) {
						return "";
					} else {
						if (data.toString().includes("OBD")) {
							return "OBD";
						} else {
							return data;
						}
					}
				}
			}
		}
	}
};

function loadCountsFallback() {
	$("#topTotal").html(fallback);
	$("#topComm").html(fallback);
	$("#topNonComm").html(fallback);
	$("#topNoGPS").html(fallback);
	$("#topRunning").html(fallback);
	$("#topStoppage").html(fallback);
	$("#topIdle").html(fallback);
}

function loadCounts() {
	loadCountsFallback();
	resetFlags();
	$.ajax({
		type: 'GET',
		url: t4uspringappURL + 'getLiveVisionStatusCount',
		datatype: 'json',
		contentType: "application/json",
		data: {
			systemId: systemId,
			customerId: customerId,
			userId: userId,
			offset: offset,
			tripCustomerId: initialLoad ? "ALL" : (custNameLength === $("#customerName").val().length || $("#customerName").val().toString() == "") ? "ALL" : $("#customerName").val().toString(),
			hubName: initialLoad ? "ALL" : (hubNameLength === $("#hubWise").val().length || $("#hubWise").val().toString() == "") ? "ALL" : $("#hubWise").val().toString(),
			direction: initialLoad ? "ALL" : (directionLength === $("#directionWise").val().length || $("#directionWise").val().toString() == "") ? "ALL" : $("#directionWise").val().toString(),
			zone: zone,
			nonCommHour: nonCommHour
		},
		success: function (response) {
			let totalVehicles = 0;
			$("#topRunning").html("0");
			$("#topStoppage").html("0");
			$("#topIdle").html("0");
			response.responseBody.forEach(function (item) {
				if (item.status === "COMM") {
					$("#topComm").html(item.count);
					totalVehicles += parseInt(item.count);
				}
				if (item.status === "NON_COMM") {
					$("#topNonComm").html(item.count);
					totalVehicles += parseInt(item.count);
				}
				if (item.status === "NOGPS") {
					$("#topNoGPS").html(item.count);
					totalVehicles += parseInt(item.count);
				}
				item.status === "RUNNING" ? $("#topRunning").html(item.count) : "";
				item.status === "STOPPAGE" ? $("#topStoppage").html(item.count) : "";
				item.status === "IDLE" ? $("#topIdle").html(item.count) : "";
			})
			$("#topTotal").html(totalVehicles);
		}
	});
}

function closeLeftInfoWindow() {
	$("#divVehInformation").hide('slide', {
		direction: 'right'
	}, 2000);
	$("#liveVisionContainer").removeClass("percentWidth");
	$("#liveVisionContainer").addClass("fullWidth");
	$(".vehCompact").css({
		"top": "115px"
	});
	$("#liveVisionHeader").css({
		"right": "0px"
	});
}

function showVehDiv() {
	$("#divVehInformation").show('slide', {
		direction: 'right'
	}, 1000);
	$(".vehCompact").hide(1000);
	$("#liveVisionContainer").removeClass("fullWidth");
	$("#liveVisionContainer").addClass("percentWidth");
	$(".vehCompact").css({
		"top": "154px"
	})
	$("#liveVisionHeader").css({
		"right": "25%"
	});
}


function showVehDetails() {
	if (clickedMarker) {

		if ($("#divVehInformation").is(":visible")) {
			closeLeftInfoWindow()
		} else {
			showVehDiv();
		}
	} else {
		sweetAlert("Please select a vehicle");
	}
}


function showHideFilters() {

	let numberOfChecked = $('#dtVehicleCompact tbody input:checkbox:checked').length;
	let totalCheckboxes = $('#dtVehicleCompact tbody input:checkbox').length;
	let numberNotChecked = totalCheckboxes - numberOfChecked;

	numberOfChecked === totalCheckboxes ? $("#checkboxMain").prop("checked", true) : $("#checkboxMain").prop("checked", false)
	$("#vehicleCount").html(numberOfChecked > 0 ? "(" + numberOfChecked + ")" : "");
	if (numberOfChecked === 1) {
		$("#filters").removeClass("dispNone")
		$("#filters").addClass("dispFlex")
		$("#filters").css({
			"opacity": "1"
		});
		$(".topCard").css({
			"top": "154px"
		});
		$(".showHubsBox").css({
			"top": "480px"
		});
	} else {
		$("#filters").removeClass("dispFlex")
		$("#filters").addClass("dispNone")
		$("#filters").css({
			"opacity": "0"
		});
		$(".topCard").css({
			"top": "115px"
		});
		$(".showHubsBox").css({
			"top": "440px"
		});
		$("#play").css({
			color: "white"
		});
		$("#pause").css({
			color: "white"
		});
		$("#stop").css({
			color: "white"
		});
	}
}

$('.dropdown-toggle').click(function (e) {
	e.preventDefault();
	e.stopPropagation();

	return false;
});

function getNearbyPois(lat, lng) {
	for (var i = 0; i < poiMarkerArr.length; i++) {
		map.removeLayer(poiMarkerArr[i]);
	}
	var settings = {
		"url": "https://outpost.mapmyindia.com/api/security/oauth/token",
		"method": "POST",
		"timeout": 0,
		"headers": {
			"Content-Type": "application/x-www-form-urlencoded"
		},
		"crossDomain": true,
		"data": {
			"grant_type": "client_credentials",
			"client_id": "5bcCIt4sKDY_yBcqzS8_J1NLrCCEEfF9uljSytzDAxzzVzz7k7dPYudyJYLqnpFiyrKWpzHAKWI=",
			"client_secret": "9K_q_9Q2GHPHZWeq7TSZZlVrIqrW3eCrLwQHuDYOjvJuFkHHB9fuUElAUALvYH7dNCqs2lDgHE7TBYSwG16NNQ=="
		}
	};

	$.ajax(settings).done(function (response) {
		var keyword = document.getElementById("input-field").value.toString();
		var latlng = lat + "," + lng;
		var settings = {
			"url": "https://atlas.mapmyindia.com/api/places/nearby/json?keywords=" + keyword + "&refLocation=" + latlng + "&sort=dist:asc&radius=10000&access_token=" + response.access_token,
			"method": "GET",
			"timeout": 0,
			"dataType": 'jsonp'
		};

		$.ajax(settings).done(function (response) {
			suggestedLocations = response.suggestedLocations;
			var boundForPoi = new L.LatLngBounds();
			if (suggestedLocations.length > 0) {
				for (var p = 0; p < suggestedLocations.length; p++) {
					var icon = L.divIcon({
						className: 'my-div-icon',
						html: "<img class='map_marker'  src=" + "'https://maps.mapmyindia.com/images/2.png'>" + '<span class="my-div-span" style="left:1.6em; top:1.4em;">' + (p + 1) + '</span>',
						iconSize: [10, 10],
						popupAnchor: [12, -10]
					});
					poiMarkerContent = '<div id="poiMarkerContent" seamless="seamless" scrolling="no" style="overflow:auto;color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
						'<table>' +
						'<tr><td><b>Place Name :</b></td><td>' + suggestedLocations[p].placeName + '</td></tr>' +
						'<tr><td><b>Distance(kms) : </b></td><td>' + (suggestedLocations[p].distance) / 1000 + '</td></tr>' +
						'<tr><td><b>Mobile No : </b></td><td>' + suggestedLocations[p].mobileNo + '</td></tr>' +
						'<tr><td><b>Address : </b></td><td>' + suggestedLocations[p].placeAddress + '</td></tr>' +
						'<tr><td><b>email: </b></td><td>' + suggestedLocations[p].email + '</td></tr>' +
						'</table>' +
						'</div>';
					var poiMarker = new L.Marker(new L.LatLng(suggestedLocations[p].latitude, suggestedLocations[p].longitude), {
						icon: icon
					}).addTo(map);
					poiMarker.bindPopup(poiMarkerContent);
					boundForPoi.extend(new L.LatLng(suggestedLocations[p].latitude, suggestedLocations[p].longitude));
					poiMarkerArr.push(poiMarker);
				}
				boundForPoi.extend(new L.LatLng(lat, lng));
				map.fitBounds(boundForPoi);
				searchMarker.closePopup();
				map.removeLayer(searchMarker);
			}
		})
	});
}

$('#regionWise').change(function () {
	getHubNames(true);
})
    </script>
  </body>
</html>
