<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
	int customerId=loginInfo.getCustomerId();
    String countryName = cf.getCountryName(countryId);
    Properties properties = ApplicationListener.prop;
    String vehicleImagePath = properties.getProperty("vehicleImagePath");
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
    String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
    MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
String mapName = bean.getMapName();
String appKey = bean.getAPIKey();
String appCode = bean.getAppCode();
String t4uspringappURL1 = properties.getProperty("t4uspringappURL").trim();
%>
<jsp:include page="../Common/header.jsp" />
<jsp:include page="../Common/InitializeLeaflet.jsp" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" type="text/css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css" type="text/css"/>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" type="text/css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" type="text/css"/>
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css" rel="stylesheet" />
<link href = "https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css"rel = "stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
<script src="../../Main/Js/markerclusterer.js"></script>
<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link href="https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/master/leaflet.css" rel="stylesheet" type="text/css" />
<script src="https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/master/leaflet.js"></script>
<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css" />
<script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>
<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--<script src="../../Main/leaflet/initializeleaflet.js"></script>-->

<style>
  body {
   overflow-x: hidden;
 }
.dataTables_wrapper .dataTables_filter input {
   border-radius: 8px !important;
}
thead th {
 white-space: nowrap;
}

thead {
 color: #d40511 !important;
 background-color: #ffcc00 !important;
 padding-top: 4px;
 padding-bottom: 4px;
   padding-left:16px;
}

	

table.dataTable.display tbody tr td {
 padding: 0px 12px;
 white-space: nowrap !important;
}

td {
  padding: 0px 12px;
  white-space: nowrap !important;

}

table.dataTable {
 border-color: #939393;
 border: none;
}


  .infoDiv td {
    padding: 4px;
    vertical-align: top;
    line-height: 12px;
    border: 1px solid #dfdfdf;
}

	
		



/* width */

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
 margin-top:2px;
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

/*.card {
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
 padding: 0px 0px 4px 0px;
 border: 0px !important;
 text-align: center;
}*/



.card{
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
padding: 0px 0px 4px 0px;
border: 0px !important;
text-align: center;
}


.center-view {
 background: none;
 position: fixed;
 z-index: 1000000000;
 top: 50%;
     left: 45%;
     right: 40%;
     bottom: 25%;
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


/*.blue-gradient-rgba {
 background: linear-gradient(to right, rgb(58, 96, 115), rgb(22, 34, 42))!important;
}*/


.blue-gradient-rgba {
 background: #ffcc00 !important;
 color: #D40511 !important;
}
.green-gradient-rgba {
 background: linear-gradient(to right, #3bb78f 0%, #28A745 74%)!important;
}

.orange-gradient-rgba {
 background: linear-gradient(to right, #FFCC00, rgb(241, 39, 17)) !important;
}

.red-gradient-rgba {
 background: #ffffff !important;
 color: #D40511 !important;
 border: 1px solid  #D40511 !important;
}

.red-gradient-rgba:hover,.red-gradient-rgbaSelected {
 background: #d40511 !important;
 color: #ffffff !important;
 border: 1px solid  #D40511 !important;
}

.redBackground-gradient-rgba {
 background: linear-gradient(to right, rgb(229, 45, 39), rgb(179, 18, 23)) !important;
}

.green {
 color: #28A745 !important;
 font-weight: 500;
}

.red {
 color: rgb(179, 18, 23) !important;
 font-weight: 700;
}

.orange {
 color: rgb(241, 39, 17) !important;
 font-weight: 600;
}

.blue {
 color: rgb(22, 34, 42) !important;
}

.html-white {
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
 min-width: 112px;
 height: 24px;
 background: linear-gradient(40deg, #777777, #000C40);
 padding-top: 4px !important;
 margin-top: 2px;
 font-size: 13px !important;
 cursor: pointer;
 display: flex;
  justify-content: space-between;
  border-radius:8px !important;
}

.list-group-item {
 padding: .15rem 1.25rem 0.3rem 1.25rem !important;
 font-size: 13px;
 white-space:nowrap;
}

#alertsCard ul li.list-group-item{
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
 padding: 6px 8px 6px 8px;
 align-items: center;
}



.col-lg-4 {
 padding: 0px 4px !important;
}

.topHeader {
 font-size: 11px;
 font-weight: 800;
 color: #1d1b1a;
 margin-left:-40px;
}

table tbody {
 font-size: 12px !important;
}

table.dataTable {
   border-collapse: collapse !important;
   font-size:13px !important;
}


  .cardHeight {
   height: 74px;
  }

  .cardHeightShort {
   height: 74px;
   margin-top:6px;
  }

#greenCard,
#redCard,
#orangeCard, #alertsCard {
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

li:hover{
  border:none;
}



.badgeHeader {
 background: linear-gradient(to right, #ffffff, #ece9e6)!important;
 font-weight: 700 !important;
 font-size: 14px !important;
 cursor: pointer;
 margin-left:-2px;
 display:flex;
 height:18px !important;
 align-items: flex-end;
 justify-content: center;
 width:60px !important;
 max-width:60px !important;
 min-width:60px !important;
}

.badgeHeaderRight {
  background: linear-gradient(to right, #ffffff, #ece9e6)!important;
 font-weight: 700 !important;
 font-size: 13px !important;
 cursor: pointer;
 display:flex;
 height:18px !important;
 align-items: flex-end;
 justify-content: center;
 width:50px !important;
 max-width:50px !important;
 min-width:50px !important;
}

.flexWidth{
  width:168px;
  justify-content: space-between;
}

.flexWidthCardDet{
  justify-content: center;
  flex-direction:column;
}
.btn-group {
 width: 140px !important;
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

.topRowData{
 margin-bottom: 24px;
   color: #d40511;
   text-align: center;
 background: #ffcc00;
 border-radius:2px;
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
 min-width:300px !important;
}

.multiselect-clear-filter {
 display: none !important;
}

.multiselect-filter .input-group {
 width: 96% !important
}

.multiselect-container .multiselect-search {
 border-radius: 8px !important;
 height:24px !important;
 font-size:12px !important;
}

.multiselect-container a .checkbox{
 color:#777777 !important;
 padding:0px 16px;
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

#ulRowData .col-lg-4, #ulRowData .col-lg-8 {
 padding:1px !important;
 border: 1px solid #dfdfdf !important;
}


#viewDatatable, #viewDashboard{
 cursor:pointer;
 width:100%;
 text-align:center;
 margin-top:48px;
  margin-bottom:48px;
 font-size:12px;
}

.dhlBack{
 color: #D40511;
 background: #FFCC00;
 padding: 8px 16px;
 border-radius: 8px;
}

.dhlBackTop{
 color: #D40511;
 background: #FFCC00;
 padding: 4px 16px 8px 16px;
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

   #ulRowData .col-lg-4, #ulRowData .col-lg-8{
     padding:0px 6px !important;
     word-break: break-word !important;
   }

.select2-container{
 font-weight:400;
}

.select2-selection{
   height:32px !important;
 }

 .modal-dialog{
   margin-top:64px !important;
 }

 .modal-content{
   border:none !important;
 }

 .ui-widget.ui-widget-content {
   border: none !important;
   z-index: 100000;
   font-size: 11px;
   width: 200px !important;
 height:200px !important;
 overflow-y: auto !important;
}

#tripNoAutoComplete:focus{
 outline:none !important;
}

.flex{
  display: flex;
}

.marginBetweenBadge{
/*  margin-left:8px;*/
}
.marginBetweenBadgeRight{
/*  margin-right:8px;*/
}
body {
  font-size: 12px !important;
  background: white !important;
}

.secondRowHeaderHeight{
  padding-top:4px;
  height:48px;
  display: flex;
  align-items: center;
}


.tablet{
  border-radius:8px !important;
}

.thirdCol{
  padding:0px;border-radius:8px;border:1px solid #777777;
}


    .buttons-excel{
      color: white;
     height: 32px !important;
       padding: 4px 16px !important;
       background: #0bab64 !important;
       border: 1px solid #0bab64 !important;
     border-radius:4px;
    }

    #tripSumaryTable_filter label{
      display: flex;
      align-items: center;
      text-transform: uppercase;
    }

    #tableDiv{
      width:100%;border-radius:8px;overflow:hidden;;
    }



    .tableFullScreen{
      position: fixed;
      top:40px;
      left:-8px;
      bottom:-8px;
      z-index:100;
      background: #ffffff;
      width:101% !important;
      z-index:9999;
    }

    .commNonComm{   font-size:10px; text-transform: uppercase;
    font-weight: 600;   text-align: center;}
    .commNonCommSH{   font-size:10px;
    font-weight: 600;   text-align: center;}

    hr{
      width: 100%;
padding: 0px;
margin: 0px;
border-top:1px solid #888888 !important
    }

    .hrli{
      min-height:16px !important;
      max-height:16px !important;

    }
/*.cardOtherDet{
  padding: 0px 8px 4px 8px;
  margin:8px;
  background: #ffffff
}*/

.cardOtherDet{
  padding: 4px 8px 4px 8px;
    margin: 3px;
    background: #ffffff;
    display: flex;
    flex-direction: row;
    align-items: flex-end;
    justify-content: space-between;
}
.cardOtherDetAgeing{
  font-weight:700;
  padding: 4px;
  color:#D40511 !important;
  border-radius:4px;
  font-size:14px;
  background: #ffcc00 !important;
}

.cardOtherDet span{
  text-transform: uppercase;
  padding-bottom: 2px;
}

#tripSumaryTable_wrapper{padding:0px !important;}

.leftCountNoHover{
  background:none !important;
  font-size:28px !important;
  height:50px !important;
  justify-content: flex-end;
   min-width: 80px !important;
   padding-left:0px;
   color: #a6a6a6!important;
   margin-left:-8px;

}

.leftCount{
  background:none !important;
  font-size:28px !important;
  height:50px !important;
  justify-content: flex-end;
   min-width: 80px !important;
   padding-left:0px;
   color: #000000!important;
   margin-left:-8px;
}

.leftCount:hover,.leftCountSelected {
  color: #d40511 !important;
}

.midText{
  font-weight: 700 !important;
    font-size: 13px !important;
    height:34px;
    margin-top:8px !important;
    display: flex;
    align-items: center;
    margin-left:-8px;
    color: #D40511 !important;
}

.midTextNoHeight{
  font-weight: 700 !important;
    font-size: 13px !important;
    margin-top:8px !important;
    display: flex;
    align-items: center;
    margin-left:-8px;
    color: #D40511 !important;
}
.distText{
  font-weight: 700 !important;
    font-size: 13px !important;
    height:34px;
    margin-left:24px;
}
.bg-dark {
    background-color: #337AB7 !important;

}
.insideSHSt {
  font-size: 12px  !important;
  margin-left: 8px;
  text-transform: capitalize !important;
  margin-top: 2px;
  font-weight: 600;
}

.topH{
width: 30px !important;
border-radius: 4px !important;
background: none !important;
color: #d40511 !important;
font-size: 28px !important;
height: 40px !important;
margin-top: 10px;
}

.topHCount{
height: 40px !important;
font-size: 14px;
margin-top: 24px;

}

.buttons-excel{
background: #d40511 !important;
    border: 1px solid #d40511 !important;
    border-radius: 8px !important;
}

.insideSH-gradient-rgba{
  background: #ffffff !important;
  border: 2px solid #ffcc00 !important;
  color: #D40511 !important;
}
.insideSH-gradient-rgba:hover, .insideSH-gradient-rgbaSelected{
  background: #ffcc00 !important;
  border: 1px solid #ffcc00 !important;
  color: #ffffff !important;
}

.topCardText{
  font-size:14px !important;
}
#tripDetailsDiv{
  text-transform: uppercase;
  text-align: center
}
.input-group {
	width: 97% !important;
}

.inner{
	    width: 56%;
    justify-content: space-between;
margin-right: 340px;}

.midSize{
min-width:70px !important; width: 92px;}

.overrideCardOtherDet{
	margin:3px;
	margin-right:-15px;
	padding: 4px 8px 4px 8px;
	align-items: flex-end;
	 flex-direction: row;
	 justify-content: space-between;

}
.overrideCardOtherDetNon{
	 height: 60px;
	margin:3px;
	margin-right:-15px;
	padding: 4px 8px 4px 8px;
	align-items: flex-end;
	 flex-direction: row;
	 justify-content: space-between;

}
.overrideCardOtherDetNon .midText{
align-items: left;
}
</style>

<div class="center-viewInitial" id="loading-divInitial"  style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;">
</div>
<div class="center-view" id="loading-div" style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;">
</div>
<div class="topRowData dhlBackTop" id="slaDashboardHeader" style="max-height:60px !important;margin-top:-18px;display:flex;justify-content:space-between;align-items:center;">
       <div style="font-weight:bold;font-size:16px;">UTILIZATION DASHBOARD</div>
        <div class="flex inner"><div class="leftMargin1" > <span class="topHeader">&nbsp;VEHICLE CATEGORY</span> <br/>
            <select  id="vehCatgy" multiple="multiple" class="input-s" name="state">
            </select>
        </div>
		<div class="leftMargin2" style = "margin-left: -100px;"> <span class="topHeader" style="margin-left:-68px;">&nbsp;VEHICLE TYPE</span> <br/>
            <select  id="vehType" multiple="multiple" class="input-s" name="state">
            </select>
        </div>
        <div class="leftMargin3" style = "margin-left: -100px;">
           <span class="topHeader" style="margin-left:-72px;">&nbsp;REGION WISE</span> <br/>
           <select  id="regionWise" multiple="multiple" class="input-s" name="state">
                <option value="'North'">North</option>
                <option value="'East'">East</option>
                <option value="'West'">West</option>
                <option value="'South'">South</option>
            </select>
        </div>
        <div class="leftMargin4"style = "margin-left: -100px;"> <span class="topHeader" style="margin-left:-80px;">&nbsp;SMART HUB</span> <br/>
            <select  id="hubWise" multiple="multiple" class="input-s" name="state">
            </select>
        </div>
		
		<div style="display:flex;padding-top:16px;margin-left:-100px;">
            <input onclick="viewClicked()" type="button" class="btn btn-success" style="padding-left:16px !important;padding-right:16px !important;" value="View" />
                <i class="fab fa-rev fa-2x btnStyle" title="RESET" onclick="resetClicked()" style="color:#e02d10;"></i>
                           
        </div>
		</div>
</div>
<div class="row" id="columnContainer" style="margin-left:0px;margin-top:-16px;padding-right:8px;">
   <div class="col-lg-9" id="leftColumn"style="padding:0px;height:572px;">
           <div class="row" style="width: 100%;margin-left: 0px;padding-right: 16px;">
             <div class="col-lg-4">
                <div class="card">
                   <div class="cardHeading blue-gradient-rgba">
                     <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Total Unassigned"
                       onclick="selected(this);loadTableMap(this,'getUnassignedVehiclesDetails','getUnassignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0')"
                       id="utotalCount"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
				<span data-toggle="tooltip" class="midText topCardText" title="Unassigned">UNASSIGNED</span><span style="margin-left:-89px" id="unassignedPercentage"></span></div>
                       <div class="flex flexWidthCardDet">
                       <div class="flex" style="flex-direction: row;margin-left: 4px;">
                         <span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight"
                           onclick="selected(this);loadTableMap(this,'getInsideSHDetails&type=Unassigned','getUnassignedVehiclesMapDetailsForISH&moveStatus=&days=0')"
                           id="uinsideshCount" title="Unassigned Inside Smart Hub"
                           style="width: 110px;background: linear-gradient(to right, #ffffff, #ece9e6)!important;">0
                           <span class="insideSHSt" style="background: linear-gradient(to right, #ffffff, #ece9e6)!important;">Inside SH</span></span></div>
                      <div class="flex" style="flex-direction: row;margin-left: 4px;">
                        <span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight"
                          onclick="selected(this);loadTableMap(this,'getNonCommUnassignedVehiclesDetails','getUnassignedVehiclesMapDetails&commStatus=NO&moveStatus=&days=0')"
                          id="unonCommunicatingCount" title="Unassigned Non-Communicating" style="width: 110px;background: linear-gradient(to right, #ffffff, #ece9e6)!important;">0
                          <span class="insideSHSt">Non-Comm</span></span></div>
                   </div>
                   </div>
                       <div class="card cardOtherDet">
					    <div class="flex flexWidthCardDet">
                     <span class="badge badge-primary badge-pill insideSH-gradient-rgba" id="uAvaliableCount"  onclick="selected(this);loadTableMap(this,'getUnassignedAvailableVehicleList','getUnassignedVehicleMapList&type=UnassignedAvailable')" title="Unassigned Available">0<span class="insideSHSt">Available</span></span>
                     <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="uDedicatedCount"  onclick="selected(this);loadTableMap(this,'getUnassignedDedicatedList','getUnassignedVehicleMapList&type=UnassignedDedicated')" title="Unassigned Dedicated">0<span class="insideSHSt">Dedicated</span></span>
					 </div>
                     <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba" id="distance50plus"  onclick="selected(this);loadTableMap(this,'getExtraTravelledKMSDetails&type=Unassigned&distance=50','getExtraTravelledKMSDetailsMaps&type=Unassigned&distance=50')" title="Unassigned Distance Travelled 50 to 100 Km"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">50 - 100 Km</span></span>
                          <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="distance100plus"  onclick="selected(this);loadTableMap(this,'getExtraTravelledKMSDetails&type=Unassigned&distance=100','getExtraTravelledKMSDetailsMaps&type=Unassigned&distance=100')" title="Unassigned Distance Travelled Greater Than 100 Km"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">> 100 Km</span></span></div>
                       </div>
                      <div class="card cardOtherDet">
                         <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=Moved&days=0','getListViewsForAllMaps&type=unassigned&mStatus=Moved&days=0')" title="Unassigned Moving" id="utotalMoving"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title="">Moving</span></div>
                         <div class="flex flexWidthCardDet"><span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Unassigned Inside Smart Hub" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=Moved&hourId=0','getUnassignedVehiclesMapDetailsForISH&moveStatus=Moved&days=0')" id="uinsideMoving"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                         <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="umovingNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getMovedNonCommUnassignedVehiclesDetails','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=Moved&days=0')" title="Unassigned Moving Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                      <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Unassigned Idling" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=Idling&days=0','getListViewsForAllMaps&type=unassigned&mStatus=Idling&days=0')" id="utotalIdle"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title="">Idle</span></div>
                         <div class="flex flexWidthCardDet">
                           <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Unassigned Idling Inside Smart Hub" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=Idling&hourId=0','getUnassignedVehiclesMapDetailsForISH&moveStatus=Idling&days=0')" id="uinsideIdle"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                          <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="uidleNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getIdlingNonCommUnassignedVehiclesDetails','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=Idling&days=0')" title="Unassigned Idling Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                      <div class="card cardOtherDet">
                         <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Unassigned Halted" id="utotalHalted" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=Halted&days=0','getListViewsForAllMaps&type=unassigned&mStatus=Halted&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title="">Halted</span></div>
                         <div class="flex flexWidthCardDet"><span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Unassigned Halted Inside Smart Hub" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=Halted&hourId=0','getUnassignedVehiclesMapDetailsForISH&moveStatus=Halted&days=0')" id="uinsideHalted"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                         <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="uhaltedNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getHaltedNonCommUnassignedVehiclesDetails','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=Halted&days=0')" title="Unassigned Halted Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                      <div class="cardOtherDetAgeing">DURATION</div>
                      <div class="card cardOtherDet">
                         <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Unassigned  Greater Than 10 days" id="utotal10Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=&days=10','getListViewsForAllMaps&type=unassigned&mStatus=&days=10')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title=""  class="red"><i class="fas fa-greater-than"></i>&nbsp;10 days</span></div>
                         <div class="flex flexWidthCardDet">
                           <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Unassigned Greater Than 10 days Inside Smart Hub" id="uinside10Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=&hourId=10','getUnassignedVehiclesMapDetailsForISH&moveStatus=&days=10')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                         <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="unonCommunicating10Hour"  onclick="selected(this);loadTableMap(this,'getNonCommUnassignedVehiclesDaywiseDetails&hourId=10','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=&days=10')" title="Unassigned Greater Than 10 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                      <div class="card cardOtherDet">
                         <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Unassigned 6 to 10 days" id="utotal7Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=&days=7','getListViewsForAllMaps&type=unassigned&mStatus=&days=7')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title="Unassigned  6 to 10 days" class="red">6 to 10 days</span></div>
                         <div class="flex flexWidthCardDet">
                           <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Unassigned 6 to 10 days Inside Smart Hub" id="uinside7Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=&hourId=7','getUnassignedVehiclesMapDetailsForISH&moveStatus=&days=7')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                         <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="unonCommunicating7Hour"  onclick="selected(this);loadTableMap(this,'getNonCommUnassignedVehiclesDaywiseDetails&hourId=7','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=&days=7')" title="Unassigned 6 to 10 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                      <div class="card cardOtherDet">
                         <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Unassigned 2 to 5 days" id="utotal5Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=&days=5','getListViewsForAllMaps&type=unassigned&mStatus=&days=5')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title="Unassigned 2 to 5 days" class="orange">2 to 5 days</span></div>
                         <div class="flex flexWidthCardDet"><span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Unassigned 2 to 5 days Inside Smart Hub" id="uinside5Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=&hourId=5','getUnassignedVehiclesMapDetailsForISH&moveStatus=&days=5')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                         <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="unonCommunicating5Hour"  onclick="selected(this);loadTableMap(this,'getNonCommUnassignedVehiclesDaywiseDetails&hourId=5','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=&days=5')" title="Unassigned  2 to 5 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                      <div class="card cardOtherDet">
                         <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Unassigned Less than 2 days" id="utotal2Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=unassigned&mStatus=&days=2','getListViewsForAllMaps&type=unassigned&mStatus=&days=2')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                         <span data-toggle="tooltip" class="midText" title="Unassigned Less Than 2 days" class="green"><i class="fas fa-less-than"></i>&nbsp;2 days</span></div>
                         <div class="flex flexWidthCardDet"><span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Unassigned&mStatus=&hourId=2','getUnassignedVehiclesMapDetailsForISH&moveStatus=&days=2')" title="Unassigned less than 2 days Inside Smart Hub" id="uinside2Hour"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                         <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="unonCommunicating2Hour" onclick="selected(this);loadTableMap(this,'getNonCommUnassignedVehiclesDaywiseDetails&hourId=2','getUnassignedVehiclesMapDetails&commStatus=no&moveStatus=&days=2')" title="Unassigned less than 2 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                      </div>
                </div>
             </div>
             <div class="col-lg-4">
               <div class="card ">
                 <div class="cardHeading blue-gradient-rgba">
                   <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned Total"
                     onclick="selected(this);loadTableMap(this,'getAssignedVehiclesDetails','getAssignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0')"
                       id="atotalCount"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                   <span data-toggle="tooltip" class="midText topCardText" title="Assigned">ASSIGNED</span></i><span style="margin-left:-67px" id="totalAssignedPercentage"></span></span></div>
                     <div class="flex flexWidthCardDet">
                     <div class="flex" style="flex-direction: row;margin-left: 4px;"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight" id="insideshCount" onclick="selected(this);loadTableMap(this,'getInsideSHDetails&type=Assigned','getAssignedVehiclesMapDetailsForISH&moveStatus=&days=0')" title="Assigned Inside Smart Hub" style="
                     width: 110px;
                     background: linear-gradient(to right, #ffffff, #ece9e6)!important;
                     ">0<span class="insideSHSt" style="
                     background: linear-gradient(to right, #ffffff, #ece9e6)!important;
                     ">Inside SH</span></span></div>
                    <div class="flex" style="flex-direction: row;margin-left: 4px;"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight" id="nonCommunicatingCount" onclick="selected(this);loadTableMap(this,'getNonCommAssignedVehiclesDetails','getAssignedVehiclesMapDetails&commStatus=No&moveStatus=&days=0')" title="Assigned Non-Communicating" style="
width: 110px;
background: linear-gradient(to right, #ffffff, #ece9e6)!important;
">0<span class="insideSHSt">Non-Comm</span></span></div>

                </div>
                 </div>
                   
                   <div class="card cardOtherDet overrideCardOtherDet">
                     <div class="flex flexWidthCardDet">
					 <div class="left"  style="min-width:70px !important; width: 92px;">
                       <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Assigned Loading Vehicles" id="loading" onclick="selected(this);loadTableMap(this,'getLoadingStatusDetails&type=loading','getLoadingStatusMapDetails&type=loading')" style="min-width:70px !import;width:92px;"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Loading</span></span>
                   <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge midSize" id="unloading"  onclick="selected(this);loadTableMap(this,'getLoadingStatusDetails&type=unloading','getLoadingStatusMapDetails&type=unloading')" title="Assigned Unloading Vehicles"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Unloading</span></span>
				   </div>
				   </div>
				   <div class="flex flexWidthCardDet">
				   <div class="center"  style="min-width:60px !important; width: 85px;">
                       <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Assigned Empty Vehicles midSize" id="empty" onclick="selected(this);loadTableMap(this,'getEmptyOrCustomerVehiclesDetails&type=empty','getAssignedVehiclesMapDetails&commStatus=Empty&moveStatus=&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Empty</span></span>
                   <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge midSize" id="customer"  onclick="selected(this);loadTableMap(this,'getEmptyOrCustomerVehiclesDetails&type=customer','getAssignedVehiclesMapDetails&commStatus=Customer&moveStatus=&days=0')" title="Assigned Customer Vehicles"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Customer</span></span>
				   </div>
				   
				   </div>
				   <div class="flex flexWidthCardDet">
				     <div class="right"  style=" min-width:46px !important; width:110px;;">
                       <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Assigned Dry Vehicles" id="dry" onclick="selected(this);loadTableMap(this,'getTripTypeWiseListView&type=Dry','getTripTypeWiseMapListView&type=Dry')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Dry</span></span>
                   <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge midSize" id="tcl"  onclick="selected(this);loadTableMap(this,'getTripTypeWiseListView&type=TCL','getTripTypeWiseMapListView&type=TCL')" title="Assigned TCL Vehicles"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">TCL</span></span>
				   </div>
                 </div>
				  </div>
                     <div class="card cardOtherDet">
                        <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned Moving" id="totalMoving" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=assigned&mStatus=Moved&days=0','getListViewsForAllMaps&type=assigned&mStatus=Moved&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText" title="">Moving</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Assigned Moving Inside Smart Hub" id="insideMoving" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Assigned&mStatus=Moved&hourId=0','getAssignedVehiclesMapDetailsForISH&moveStatus=Moved&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="movingNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getMovedNonCommAssignedVehiclesDetails','getAssignedVehiclesMapDetails&commStatus=no&moveStatus=Moved&days=0')" title="Assigned Moving Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                    
					     <div class="card cardOtherDet overrideCardOtherDetNon">
                     <div class="flex flexWidthCardDet">
					 <div class="left"  style="min-width:70px !important; width: 92px; margin-bottom: 26px !important;">
                       <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Assigned OdoIn Vehicles" id="odoIn" onclick="selected(this);loadTableMap(this,'odoroutelistdetails&type=odoIn','odoroutemapdetails&type=odoIn')" style="min-width:70px !import;width:92px;"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">OdoIn</span></span>
					   </div>
				   </div>
				   <div class="flex flexWidthCardDet"   style= "margin-left: -59%;">
				   <div class="center"  style="min-width:60px !important; width: 85px;    margin-bottom: 26px !important;">
                       <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Assigned OdoOut Vehicles midSize" id="odoOut" onclick="selected(this);loadTableMap(this,'odoroutelistdetails&type=odoOut','odoroutemapdetails&type=odoOut')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">OdoOut</span></span>
                  
				   </div>
				   
				   </div>
				   <div class="flex flexWidthCardDet" style= "margin-left: -62%; margin-right: -57%;">
				     <div class="right"  style=" min-width:46px !important; width:110px;margin-bottom: 26px !important;margin-left:16%;">
                       <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Assigned OdoAway Vehicles" id="odoAway" onclick="selected(this);loadTableMap(this,'odoroutelistdetails&type=odoAway','odoroutemapdetails&type=odoAway')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">OdoAway</span></span>
                   </div>
                 </div>
				  <div class="left"><span data-toggle="tooltip" class="midTextNoHeight" title="" text-align="left" style="margin-right:10%; margin-left: -240px;">ODO NON-COMPLIANCES</span></div>
				 </div>
                     <div class="card cardOtherDet">
                        <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned Halted" id="totalHalted" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=assigned&mStatus=Halted&days=0','getListViewsForAllMaps&type=assigned&mStatus=Halted&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText" title="">Halted</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Assigned Halted Inside Smart Hub" id="insideHalted" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Assigned&mStatus=Halted&hourId=0','getAssignedVehiclesMapDetailsForISH&moveStatus=Halted&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="haltedNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getHaltedNonCommAssignedVehiclesDetails','getAssignedVehiclesMapDetails&commStatus=no&moveStatus=Halted&days=0')" title="Assigned Halted Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="cardOtherDetAgeing">DURATION</div>


                     <div class="card cardOtherDet">
                           <div class="flex"> <span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned Greater than 10 days" id="total10Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=assigned&mStatus=&days=10','getListViewsForAllMaps&type=assigned&mStatus=&days=10')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title=""  class="red"><i class="fas fa-greater-than"></i>&nbsp;10 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Assigned Greater than 10 days Inside Smart Hub" id="inside10Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Assigned&mStatus=&hourId=10','getAssignedVehiclesMapDetailsForISH&moveStatus=&days=10')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="nonCommunicating10Hour" onclick="selected(this);loadTableMap(this,'getNonCommAssignedVehiclesDaywiseDetails&hourId=10','getAssignedVehiclesMapDetails&moveStatus=&commStatus=no&days=10')" title="Assigned Greater than 10 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned 6 to 10 days" id="total7Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=assigned&mStatus=&days=7','getListViewsForAllMaps&type=assigned&mStatus=&days=7')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title=""  class="red">6 to 10 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Assigned 6 to 10 days Inside Smart Hub" id="inside7Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Assigned&mStatus=&hourId=7','getAssignedVehiclesMapDetailsForISH&moveStatus=&days=7')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="nonCommunicating7Hour"  onclick="selected(this);loadTableMap(this,'getNonCommAssignedVehiclesDaywiseDetails&hourId=7','getAssignedVehiclesMapDetails&moveStatus=&commStatus=no&days=7')" title="Assigned 6 to 10 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                         <div class="flex"> <span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned 2 to 5 days" id="total5Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=assigned&mStatus=&days=5','getListViewsForAllMaps&type=assigned&mStatus=&days=5')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText" title="" class="orange">2 to 5 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Assigned 2 to 5 days Inside Smart Hub"  id="inside5Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Assigned&mStatus=&hourId=5','getAssignedVehiclesMapDetailsForISH&moveStatus=&days=5')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="nonCommunicating5Hour" onclick="selected(this);loadTableMap(this,'getNonCommAssignedVehiclesDaywiseDetails&hourId=5','getAssignedVehiclesMapDetails&moveStatus=&commStatus=no&days=5')" title="Assigned 2 to 5 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Assigned trip starts greather than 2 days" id="total2Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=assigned&mStatus=&days=2','getListViewsForAllMaps&type=assigned&mStatus=&days=2')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText" title="" class="green">STP&nbsp;<i class="fas fa-greater-than"></i>&nbsp;2 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Assigned trip starts greather than 2 days Inside Smart Hub" id="inside2Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Assigned&mStatus=&hourId=2','getAssignedVehiclesMapDetailsForISH&moveStatus=&days=2')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="nonCommunicating2Hour"  onclick="selected(this);loadTableMap(this,'getNonCommAssignedVehiclesDaywiseDetails&hourId=2','getAssignedVehiclesMapDetails&moveStatus=&commStatus=no&days=2')" title="Assigned trip starts greather than 2 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>

               </div>
            </div>
            <div class="col-lg-4" id="maintenanceCol">
               <div class="card">
                 <div class="cardHeading blue-gradient-rgba">
                   <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance Total"
                      onclick="selected(this);loadTableMap(this,'getMaintenanceVehiclesDetails','getMaintenanceVehiclesMapDetails&commStatus=All&moveStatus=&days=0')"
                      id="mtotalCount"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                   <span data-toggle="tooltip" class="midText topCardText" title="Maintenance" >MAINTENANCE</span><span style="margin-left:-102px" id="totalMaintenancePercentage"></span><label style = " position: relative; top: 34px; left: -34px;"> MTD: </label>&nbsp;<span style=" position: relative; top: 34px; left: -34px;" title="Maintenance MTD Percentage" id="mtdPercentage"></span> </div>
                <div class="flex flexWidthCardDet">

                     <div class="flex" style="flex-direction: row;margin-left: 4px;"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight" id="minsideshCount" onclick="selected(this);loadTableMap(this,'getInsideSHDetails&type=Maintenance','getMaintenanceVehiclesMapDetailsForISH&moveStatus=&days=0')" title="Maintenance Inside Smart Hub" style="
                   width: 110px;
                   background: linear-gradient(to right, #ffffff, #ece9e6)!important;
                   ">0<span class="insideSHSt" style="
                   background: linear-gradient(to right, #ffffff, #ece9e6)!important;
                   ">Inside SH</span></span></div>
                    <div class="flex" style="flex-direction: row;margin-left: 4px;"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight" id="mnonCommunicatingCount" onclick="selected(this);loadTableMap(this,'getNonCommMaintenanceVehiclesDetails','getMaintenanceVehiclesMapDetails&commStatus=No&moveStatus=&days=0')" title="Maintenance Non-Communicating" style="
width: 110px;
background: linear-gradient(to right, #ffffff, #ece9e6)!important;
">0<span class="insideSHSt">Non-Comm</span></span></div>


                </div>
                 </div>
                  <div class="card cardOtherDet">
                   <div class="flex flexWidthCardDet">
                     <span class="badge badge-primary badge-pill insideSH-gradient-rgba" id="minsideSC"  onclick="selected(this);loadTableMap(this,'getMaintenanceInsideOrEnrouteDetails&type=MaintenanceInsideSC','getMaintenanceVehiclesMapDetails&commStatus=insideSC&moveStatus=&days=0')" title="Maintenance Inside Service Centers">0<span class="insideSHSt">Inside SC</span></span>
                     <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mEnrouteSC"  onclick="selected(this);loadTableMap(this,'getMaintenanceInsideOrEnrouteDetails&type=MaintenanceEnrouteSC','getMaintenanceVehiclesMapDetails&commStatus=enrouteSC&moveStatus=&days=0')" title="Maintenance Enroute Service Centers">0<span class="insideSHSt">Enroute SC</span></span></div>
                     <div class="flex flexWidthCardDet">
                     <span class="badge badge-primary badge-pill insideSH-gradient-rgba" id="mdistance50plus"  onclick="selected(this);loadTableMap(this,'getExtraTravelledKMSDetails&type=Maintenance&distance=50','getExtraTravelledKMSDetailsMaps&type=Maintenance&distance=50')" title="Maintenance Distance travelled 50 to 100 Km">0<span class="insideSHSt">50 - 100 Km</span></span>
                     <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mdistance100plus"  onclick="selected(this);loadTableMap(this,'getExtraTravelledKMSDetails&type=Maintenance&distance=100','getExtraTravelledKMSDetailsMaps&type=Maintenance&distance=100')" title="Maintenance Distance Travelled Grater Than 100 Km">0<span class="insideSHSt">> 100 Km</span></span></div>
                  </div>
                     <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance Total Moving" id="mtotalMoving" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=maintenance&mStatus=Moved&days=0','getListViewsForAllMaps&type=maintenance&mStatus=Moved&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title="Maintenance Moving">Moving</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Maintenance Moving Inside Smart Hub" id="minsideMoving" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=Moved&hourId=0','getMaintenanceVehiclesMapDetailsForISH&moveStatus=Moved&days=0')">0<span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mmovingNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getMovedNonCommMaintenanceVehiclesDetails','getMaintenanceVehiclesMapDetails&commStatus=no&moveStatus=Moved&days=0')" title="Maintenance Moving Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                         <div class="flex"> <span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance Idling" id="mtotalIdle" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=maintenance&mStatus=Idling&days=0','getListViewsForAllMaps&type=maintenance&mStatus=Idling&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip"  class="midText" title="">Idle</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Maintenance Idling Inside Smart Hub" id="minsideIdle" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=Idling&hourId=0','getMaintenanceVehiclesMapDetailsForISH&moveStatus=Idling&days=0')">0<span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="midleNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getIdlingNonCommMaintenanceVehiclesDetails','getMaintenanceVehiclesMapDetails&commStatus=no&moveStatus=Idling&days=0')" title="Maintenance Idling Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance Total Halted" id="mtotalHalted" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=maintenance&mStatus=Halted&days=0','getListViewsForAllMaps&type=maintenance&mStatus=Halted&days=0')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title="Maintenance Halted">Halted</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Maintenance Halted Inside Smart Hub" id="minsideHalted" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=Halted&hourId=0','getMaintenanceVehiclesMapDetailsForISH&moveStatus=Halted&days=0')">0<span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mhaltedNonCommunicatingCount"  onclick="selected(this);loadTableMap(this,'getHaltedNonCommMaintenanceVehiclesDetails','getMaintenanceVehiclesMapDetails&commStatus=no&moveStatus=Halted&days=0')" title="Maintenance Halted Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="cardOtherDetAgeing">DURATION</div>
                     <div class="card cardOtherDet">
                            <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance Greater Than 10 days" id="mtotal10Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=Maintenance&mStatus=&days=10','getListViewsForAllMaps&type=maintenance&mStatus=&days=10')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title=""  class="red"><i class="fas fa-greater-than"></i>&nbsp;10 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Maintenance Greater Than 10 days Inside Smart Hub" id="minside10Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=&hourId=10','getMaintenanceVehiclesMapDetailsForISH&moveStatus=&days=10')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mnonCommunicating10Hour"  onclick="selected(this);loadTableMap(this,'getNonCommMaintenanceVehiclesDaywiseDetails&hourId=10','getMaintenanceVehiclesMapDetails&moveStatus=&commStatus=no&days=10')" title="Maintenance Greater than 10 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance 6 to 10 days" id="mtotal7Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=maintenance&mStatus=&days=7','getListViewsForAllMaps&type=maintenance&mStatus=&days=7')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title="" class="red">6 to 10 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Maintenance 6 to 10 days Inside Smart Hub" id="minside7Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=&hourId=7','getMaintenanceVehiclesMapDetailsForISH&moveStatus=&days=7')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mnonCommunicating7Hour"  onclick="selected(this);loadTableMap(this,'getNonCommMaintenanceVehiclesDaywiseDetails&hourId=7','getMaintenanceVehiclesMapDetails&moveStatus=&commStatus=no&days=7')" title="Maintenance 6 to 10 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                         <div class="flex"> <span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance 2 to 5 days" id="mtotal5Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=maintenance&mStatus=&days=5','getListViewsForAllMaps&type=maintenance&mStatus=&days=5')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title="" class="orange">2 to 5 days</span></div>
                        <div class="flex flexWidthCardDet">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight" title="Maintenance 2 to 5 days Inside Smart Hub" id="minside5Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=&hourId=5','getMaintenanceVehiclesMapDetailsForISH&moveStatus=&days=5')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                      <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge" id="mnonCommunicating5Hour"  onclick="selected(this);loadTableMap(this,'getNonCommMaintenanceVehiclesDaywiseDetails&hourId=5','getMaintenanceVehiclesMapDetails&moveStatus=&commStatus=no&days=5')" title="Maintenance 2 to 5 days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span></div>
                     </div>
                     <div class="card cardOtherDet">
                          <div class="flex"><span class="badge badge-primary badge-pill blue-gradient-rgba marginBetweenBadgeRight leftCount" title="Maintenance Less than 2 days" id="mtotal2Hour" onclick="selected(this);loadTableMap(this,'getListViewsForAll&type=maintenance&mStatus=&days=2','getListViewsForAllMaps&type=maintenance&mStatus=&days=2')"><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
                        <span data-toggle="tooltip" class="midText"  title="" class="green"><i class="fas fa-less-than"></i>&nbsp;2 days</span></div>
                        <div class="flex flexWidthCardDet">
						 <div class="left"  style="min-width:70px !important; width: 92px;">
                      <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="mtotallessthanl2Hour" id="lessThan12Hour" onclick="selected(this);loadTableMap(this,'getmaintancelessOrgreather12hrs&type=lessThan12hr','getListViewsForAllMaps&type=maintenance&mStatus=&days=11')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt"> <12 Hrs</span></span>
					  <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="mtotalgreaterthanl2Hour" id="greaterThan12Hour" onclick="selected(this);loadTableMap(this,'getmaintancelessOrgreather12hrs&type=greatherThan12hr','getListViewsForAllMaps&type=maintenance&mStatus=&days=12')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt"> >12 Hrs</span></span>
                   
					 </div>
					</div>
				  <div class="right">
                          <span class="badge badge-primary badge-pill insideSH-gradient-rgba marginBetweenBadgeRight midSize" title="Maintenance Less Than 2 days Inside Smart Hub" id="minside2Hour" onclick="selected(this);loadTableMap(this,'getInsideSHVehiclesDaywiseDetails&type=Maintenance&mStatus=&hourId=2','getMaintenanceVehiclesMapDetailsForISH&moveStatus=&days=2')"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Inside SH</span></span>
                        <span class="badge badge-primary badge-pill red-gradient-rgba marginBetweenBadge midSize" id="mnonCommunicating2Hour"  onclick="selected(this);loadTableMap(this,'getNonCommMaintenanceVehiclesDaywiseDetails&hourId=2','getMaintenanceVehiclesMapDetails&moveStatus=&commStatus=No&days=2')" title="Maintenance Less Than 2 Days Non-Communicating"><i class="fas fa-spinner fa-spin spinnerColor"></i><span class="insideSHSt">Non-Comm</span></span>
						</div>
				   </div>
				   </div>
				  
               </div>
             </div>
           </div>
		   

   <div class="col-lg-3 thirdCol" id="rightColumn" style="padding:0px;margin-left:-8px;height:622px;">

               <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);border-radius:8px;"></div>

   </div>
</div>
<div class="row" style="width: 100%;height:80px;">
  <div class="col-lg-12" >
      <div id="viewDatatable" style=""> <span class="dhlBack"><i class="fas fa-chevron-down blink"></i>&nbsp;&nbsp;<strong>VIEW DETAILS</strong> &nbsp;&nbsp; <i class="fas fa-chevron-down blink"></i></span></div>
    </div>
  </div>
<div class="row topRowData" style="margin-bottom:16px;margin-top:32px;" id="tripDetailsDiv">
         <div class="col-lg-12"><strong>Total Unassigned - Vehicle Details</strong></div>
         </div>
<div class="row" id="midColumn" style="width: 100%;padding:0px;margin-left:0px">
  <div class="col-lg-12" style="padding:0px;">
   <div id="tableDiv" class="tableDiv">

      <table id="tripSumaryTable" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;z-index:1">
         <thead style="background:#37474F;color:white;">
            <tr>
               <th>Sl No</th>
               <th>Duration (DD:HH:MM)</th>
               <th>Trip No</th>
			   <th>Customer Name</th>
			   <th>Vehicle No</th>
			   <th>Vehicle Make</th>
			   <th>Vehicle Source Hub</th>
			   <th>ODO Route</th>
			   <th>Vehicle Category</th>
			   <th>Vehicle Type</th>
               <th>Moving Status</th>
               <th>Communication Status</th>
			  
               <th>Distance</th>               
               <th>Tamper Count</th>
               <th>Current Location</th>
			   <th>Route Id</th>
               <th>Driver 1 Name</th>
               <th>Driver 1 Contact</th>
               <th>Driver 2 Name</th>
               <th>Driver 2 Contact</th>
            </tr>
         </thead>
      </table>
   </div>
 </div>
</div>

<div id="viewDashboard"> <div class="row"><div class="col-lg-9" style="margin-left:100px;margin-left: 100px;"><span class="dhlBack"><i class="fas fa-chevron-up blink"></i>&nbsp;&nbsp;<strong>VIEW DASHBOARD & MAP </strong>&nbsp;&nbsp; <i class="fas fa-chevron-up blink"></i></span></div><div class="col-lg-3"></div></div></div>

<script>
//history.pushState({ foo: 'fake' }, 'Fake Url', 'UtilizationDashboard#');
//let t4uspringappURL = 'https://track-staging.dhlsmartrucking.com/Telematics4uApp/tripDashBoardAction.do?param=';
//let t4uspringappURL = 'http://localhost:8080/Telematics4uApp/tripDashBoardAction.do?param=';
let t4uspringappURL = "<%=request.getContextPath()%>/tripDashBoardAction.do?param=";
let t4uspringappURL1 = '<%=t4uspringappURL1%>';
  var status = 0;
var noncommveh = false;
var unassignedVehtype = "";

var tableFullScreen = false;

var map;
var boxLeft = 3;
var boxRight = 3;
var mcOptions = {
  gridSize: 20,
  maxZoom: 100
};
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
//var countryName = 'India';
var $mpContainer = $('#map');
var custName = "ALL";
var routeId = "ALL";
var tripStatus = "";
var flag = false;
var toggle = "hide";
var vehCatLength=0;
var vehTypLength=0;
var regionLength=4;
var hubNameLength=0;
var totalAssignedCount = 0;
var totalUnAssignedCount = 0;
var totalMaintenanceCount = 0;
var totalCount = 0;
var totalMaintenanceAgeCount = 0;
var mapAPIArray = [];
var odoListArray=[];
var type=[];
var mapOdoType=[];
var currentDate = new Date();
var mm = currentDate.getMonth() + 1; 
var yyyy = currentDate.getFullYear(); 
var days ;                 

$("#viewDatatable").click(function() {
  $('html, body').animate({
        scrollTop: $("#tableDiv").offset().top - 48
    }, 1000);
});

$("#viewDashboard").click(function() {
  $('html, body').animate({
        scrollTop: $("#slaDashboardHeader").offset().top - 60
    }, 1000);
});



$("#tableFullScreen").on("click", function(){
  if(tableFullScreen)
  {
    $("#tableDiv").removeClass("tableFullScreen");
    $("#tableDiv").css("height",$(window).height()-372);
    if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
      $('#tripSumaryTable').DataTable().clear().destroy();
    }

    table = $('#tripSumaryTable').DataTable({
      paging: true,
      "bLengthChange": true,
      deferRender: true,
      scrollY: "480px",
      scrollX: true,
      scrollCollapse: true,
      dom: 'Bfrtip',
      pageLength: 50,
      "oLanguage": {
        "sEmptyTable": "No data available"
      },
      dom: 'Bfrtip',
      buttons: [ {
          extend: 'excel',
          text: 'EXPORT TO EXCEL',
          title: 'Utilization Details',
          className: 'btn btn-primary excelWidth',
          exportOptions: {
              columns: ':visible'
          }
      }]
    });
    table.rows.add(rows).draw();
    $('#loading-div').hide();
    $('#tableDiv').css('visibility', '');
  }
  else {
    $("#tableDiv").addClass("tableFullScreen");
    $("#tableDiv").css("height",$(window).height());
    if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
      $('#tripSumaryTable').DataTable().clear().destroy();
    }

    table = $('#tripSumaryTable').DataTable({
      paging: false,
      "bLengthChange": true,
      deferRender: true,
      scrollX: true,
      scrollCollapse: true,
      dom: 'Bfrtip',
      "oLanguage": {
        "sEmptyTable": "No data available"
      },
      dom: 'Bfrtip',
      buttons: [ {
          extend: 'excel',
          text: 'EXPORT TO EXCEL',
          title: 'Utilization Details',
          className: 'btn btn-primary excelWidth',
          exportOptions: {
              columns: ':visible'
          }
      }]
    });
    table.rows.add(rows).draw();
    $('#loading-div').hide();
    $('#tableDiv').css('visibility', '');
  }
  tableFullScreen = !tableFullScreen;
})


$(document).ready(function () {
/*  $("#rightColumn").css("height",$(window).height() - 146);
  $("#map").css("height",$(window).height() - 146);*/
  $("#rightColumn").css({"height":"622px"});
  $("#map").css({"height":"622px"});//$("#maintenanceCol").height()

  $('html, body').animate({
        scrollTop: $("#slaDashboardHeader").offset().top - 60
    }, 1000);
	
	 
	
	
	$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getProductLine',
	        data: {
	            custId: <%=customerId%>
	        },
	        success: function(response) {
	            vehCatList = JSON.parse(response);
	            var $vehCatgy = $('#vehCatgy');
				var output = '';
	            vehCatLength = vehCatList["productLineRoot"].length;
	            for (var i = 0; i < vehCatList["productLineRoot"].length; i++) {
	                $('#vehCatgy').append($("<option></option>").attr("value", "'" + vehCatList["productLineRoot"][i].productname + "'").text(vehCatList["productLineRoot"][i].productname));
	            }
	            $('#vehCatgy').multiselect({
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
	            $("#vehCatgy").multiselect('selectAll', false);
	            $("#vehCatgy").multiselect('updateButtonText');
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
		
		 getHubNames();
		 getVehicleType();
		 days = daysInMonth (mm, yyyy);
		 
		 
	table = $('#tripSumaryTable').DataTable({
    paging: true,
    "bLengthChange": true,
    deferRender: true,
    scrollY: "380px",
    scrollX: true,
    scrollCollapse: true,
    dom: 'Bfrtip',
    pageLength: 50,
    "oLanguage": {
      "sEmptyTable": "No data available"
    },
    dom: 'Bfrtip',
    buttons: [ {
        extend: 'excel',
        text: 'EXPORT TO EXCEL',
        title: 'Utilization Details',
        className: 'btn btn-primary excelWidth',
        exportOptions: {
            columns: ':visible'
        }
    }]
  });



  map.invalidateSize();
  loadTable("getUnassignedVehiclesDetails");
  loadMap('getUnassignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0');
  
 
});

setInterval(function(){
  $(".leftCountSelected").removeClass("leftCountSelected");
  $(".insideSH-gradient-rgbaSelected").removeClass("insideSH-gradient-rgbaSelected");
  $(".red-gradient-rgbaSelected").removeClass("red-gradient-rgbaSelected");

  loadInitialData();
  loadTable("getUnassignedVehiclesDetails");
  loadMap('getUnassignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0');
},600000 )


function daysInMonth (month, year) {
    return new Date(year, month, 0).getDate();
}

function getHubNames(select) {
	   
	    $.ajax({
	        type: 'GET',
	        url: t4uspringappURL1 + 'getSmartHubs',
	        datatype: 'json',
	        contentType: "application/json",
	        data: {
	            customerId: <%=customerId%>,
	            systemId: <%=systemId%>,
	            region: $('#regionWise').val().toString()
	        },
	        success: function(response) {
	            hubList = response.responseBody;
				$('#hubWise').html("").multiselect("destroy");
	            var output = '';
	            hubNameLength = hubList.length;
	            ////console.log("hublength",hubNameLength);
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
	            if(select){
					$("#hubWise").multiselect('selectAll', false);
					$("#hubWise").multiselect('updateButtonText');
				}
	        }
	    });
	}
	
	$('#regionWise').change(function() {
	    getHubNames(true);
	})
	
	function getVehicleType(select){
	  
		$.ajax({
	        url: t4uspringappURL + 'getVehicleTypeData',
	        data: {
	            custId: <%=customerId%>,
				vehicleCategry: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() 
			},
			
	        success: function(response) {
			 totalCount = 0;
	            vehTypeList = JSON.parse(response);
				$('#vehType').html("").multiselect("destroy");
	            var $vehTyp = $('#vehType');
	            var output = '';
	            vehTypLength = vehTypeList["vehicleTypeRoot"].length;
	            for (var i = 0; i < vehTypeList["vehicleTypeRoot"].length; i++) {
	                $('#vehType').append($("<option></option>").attr("value", "'" + vehTypeList["vehicleTypeRoot"][i].vehicleType + "'").text(vehTypeList["vehicleTypeRoot"][i].vehicleType));
	            }
				
				$('#vehType').multiselect({
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
	            $("#vehType").multiselect('selectAll', false);
	            $("#vehType").multiselect('updateButtonText');   
	        }
	    });
	}
	
	$('#vehCatgy').change(function() {
	    getVehicleType(true);
	})
	
	
	function viewClicked() {
	window.console.clear();
		 $('#loading-div').show();
		 totalCount = 0;
		loadTable("getUnassignedVehiclesDetails");
		loadInitialData();
		loadMap('getUnassignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0');  
		
		 
		
	}

	function resetClicked() {
        totalCount = 0;
	  
	    $("#vehCatgy").multiselect('deselectAll', false)
	        .multiselect('updateButtonText');
	    $("#hubWise").multiselect('deselectAll', false)
	        .multiselect('updateButtonText');
	    $("#regionWise").multiselect('deselectAll', false)
	        .multiselect('updateButtonText');
	    $("#vehType").multiselect('deselectAll', false)
	        .multiselect('updateButtonText');
	    
	    getHubNames();
		getVehicleType();
	    loadTable("getUnassignedVehiclesDetails");
		loadInitialData();
	    loadMap('getUnassignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0');
		
		
	   	
	}

loadInitialData();
function loadInitialData(){
        $('#unassignedPercentage').html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
		$('#totalAssignedPercentage').html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
		$('#totalMaintenancePercentage').html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
		$('#mtdPercentage').html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
								 
        $.ajax({
        type: "POST",
        url: t4uspringappURL + 'getUnassignedVehicleDaysJson',
		data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
        success: function (result) {
				var data = JSON.parse(result).List[0];
				  $("#unonCommunicating2Hour").html(data.nonCommunicating2Hour + '<span class="insideSHSt">Non-Comm</span>');
				  $("#unonCommunicating5Hour").html(data.nonCommunicating5Hour + '<span class="insideSHSt">Non-Comm</span>');
				  $("#unonCommunicating7Hour").html(data.nonCommunicating7Hour + '<span class="insideSHSt">Non-Comm</span>');
				  $("#unonCommunicating10Hour").html(data.nonCommunicating10Hour + '<span class="insideSHSt">Non-Comm</span>');
				  $("#utotal2Hour").html(parseInt(data.communicating2Hour)+parseInt(data.nonCommunicating2Hour));
				  $("#utotal5Hour").html(parseInt(data.communicating5Hour)+parseInt(data.nonCommunicating5Hour));
				  $("#utotal7Hour").html(parseInt(data.communicating7Hour)+parseInt(data.nonCommunicating7Hour));
				  $("#utotal10Hour").html(parseInt(data.communicating10Hour)+parseInt(data.nonCommunicating10Hour));
				  $("#uinside2Hour").html(data.insideSH2Hour + '<span class="insideSHSt">Inside SH</span>');
				  $("#uinside5Hour").html(data.insideSH5Hour + '<span class="insideSHSt">Inside SH</span>');
				  $("#uinside7Hour").html(data.insideSH7Hour + '<span class="insideSHSt">Inside SH</span>');
				  $("#uinside10Hour").html(data.insideSH10Hour + '<span class="insideSHSt">Inside SH</span>');
			}
        });

        setTimeout(function(){
              $.ajax({
              type: "POST",
              url: t4uspringappURL + 'getAssignedVehicleCountJson',
			  data:{
	              vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	              vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
                  hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
              },
              success: function (result) {
              var data = JSON.parse(result).CountIndex[0];
			  $("#haltedNonCommunicatingCount").html(data.haltedNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#nonCommunicatingCount").html(data.nonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#movingNonCommunicatingCount").html(data.movingNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#idleNonCommunicatingCount").html(data.idlingNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#atotalCount").html(data.totalCount);
		      $("#totalMoving").html(parseInt(data.movingCommunicatingCount)+parseInt(data.movingNonCommunicatingCount));
              $("#totalHalted").html(parseInt(data.haltedCommunicatingCount)+parseInt(data.haltedNonCommunicatingCount));
              $("#totalIdle").html(parseInt(data.idlingCommunicatingCount)+parseInt(data.idlingNonCommunicatingCount));
			  totalAssignedCount  = data.totalCount;
			  totalCount = totalCount + totalAssignedCount;
			  $.ajax({
					  type: "POST",
					   url: t4uspringappURL + 'getUnAssignedVehicleCountJson',
						data:{
						 vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
						 vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
						 hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
						 },
					  success: function (result) {
					  totalUnAssignedCount = JSON.parse(result).CountIndex[0].totalCount;
					  $.ajax({
							type: "POST",
							url: t4uspringappURL + 'getMaintenanceVehicleCountJson',
							data:{
								  vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
								  vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
								  hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
								},
							success: function (result) {
								 totalMaintenanceCount = JSON.parse(result).CountIndex[0].totalCount;
								 totalMaintenanceAgeCount = JSON.parse(result).CountIndex[0].totalMaintenanceAge;
								 totalCount = totalUnAssignedCount + totalAssignedCount + totalMaintenanceCount;
                                  							 
								if(	totalCount >0){		 
							      $('#unassignedPercentage').html(((totalUnAssignedCount/totalCount)*100).toFixed(2) +"%");
							      $('#totalAssignedPercentage').html(((totalAssignedCount/totalCount)*100).toFixed(2)+ "%");
								  $('#totalMaintenancePercentage').html(((totalMaintenanceCount/totalCount)*100).toFixed(2)+ "%");
								  $('#mtdPercentage').html((((totalMaintenanceAgeCount)/(totalCount*60*24*days))*100).toFixed(2) +"%");
								  }else{
								  $('#unassignedPercentage').html("NA");
							      $('#totalAssignedPercentage').html("NA");
								  $('#totalMaintenancePercentage').html("NA");
								  $('#mtdPercentage').html("NA");
								  
								  }
							  }
							});

					  }
					});

              }
            });
			
			
			$.ajax({
            type: "POST",
            url: t4uspringappURL + 'getTripTypeWiseCounts',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).Counts[0];
            $("#dry").html(data.dryCount + '<span class="insideSHSt">Dry</span>');
            $("#tcl").html(data.tclCount + '<span class="insideSHSt">TCL</span>');
           
            }
          });
		  
		  $.ajax({
            type: "GET",
            url: t4uspringappURL1 + 'odoroutecount',
			datatype: 'json',
            contentType: "application/json",
			 data:{
				 systemId: <%=systemId%>,
				 customerId: <%=customerId%>,
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL'
			
             },
			success: function (result) {
				//console.log("result:: now",result);
            var data = result.responseBody;
            $("#odoIn").html(data.odoIn + '<span class="insideSHSt">odoIn</span>');
            $("#odoOut").html(data.odoOut + '<span class="insideSHSt">odoOut</span>');
			$("#odoAway").html(data.odoAway + '<span class="insideSHSt">odoAway</span>');
           }
          });
		  
		  $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getAssignedEmptyTripVehicleCountJson',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).CountIndex[0];
            $("#empty").html(data.totalEmptyTripCount + '<span class="insideSHSt">Empty</span>');
           }
          });
		  
		   $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getAssignedCustomerTripVehicleCountJson',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).CountIndex[0];
            $("#customer").html(data.totalCustomerTripCount + '<span class="insideSHSt">Customer</span>');
           }
          });
		  
		  $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getLoadingStatusCounts',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).Counts[0];
            $("#loading").html(data.loadingCount + '<span class="insideSHSt">Loading</span>');
            $("#unloading").html(data.unloadingCount + '<span class="insideSHSt">Unloading</span>');
           
            }
          });

            $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getInsideSHCounts',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
            success: function (result) {
            var data = JSON.parse(result).ISHCounts[0];
            $("#insideIdle").html(data.aIdle + '<span class="insideSHSt">Inside SH</span>');
            $("#uinsideIdle").html(data.uaIdle + '<span class="insideSHSt">Inside SH</span>');
        	$("#minsideIdle").html(data.mIdle + '<span class="insideSHSt">Inside SH</span>');
            $("#insideHalted").html(data.aHalted + '<span class="insideSHSt">Inside SH</span>');
            $("#uinsideHalted").html(data.uaHalted + '<span class="insideSHSt">Inside SH</span>');
        	$("#minsideHalted").html(data.mHalted + '<span class="insideSHSt">Inside SH</span>');
            $("#insideMoving").html(data.aMoved + '<span class="insideSHSt">Inside SH</span>');
            $("#uinsideMoving").html(data.uaMoved + '<span class="insideSHSt">Inside SH</span>');
        	$("#minsideMoving").html(data.mMoved + '<span class="insideSHSt">Inside SH</span>');
            $("#insideshCount").html(data.assignedISH + '<span class="insideSHSt">Inside SH</span>');
            $("#uinsideshCount").html(data.unassignedISH + '<span class="insideSHSt">Inside SH</span>');
            $("#minsideshCount").html(data.maintenanceISH + '<span class="insideSHSt">Inside SH</span>');

            }
            });



            $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getUnAssignedVehicleCountJson',
			data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
            success: function (result) {
            var data = JSON.parse(result).CountIndex[0];
              $("#uhaltedNonCommunicatingCount").html(data.haltedNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#unonCommunicatingCount").html(data.nonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#umovingNonCommunicatingCount").html(data.movingNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#uidleNonCommunicatingCount").html(data.idlingNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
              $("#utotalCount").html(data.totalCount);
			  $("#utotalMoving").html(parseInt(data.movingCommunicatingCount)+parseInt(data.movingNonCommunicatingCount));
              $("#utotalHalted").html(parseInt(data.haltedCommunicatingCount)+parseInt(data.haltedNonCommunicatingCount));
              $("#utotalIdle").html(parseInt(data.idlingCommunicatingCount)+parseInt(data.idlingNonCommunicatingCount));
			  totalUnAssignedCount = data.totalCount;
			  totalCount = totalCount + totalUnAssignedCount;
			 
			  }
            });
			
			$.ajax({
        type: 'GET',
        url: t4uspringappURL1 + 'getUnassignedAvailableVehicleList',
        datatype: 'json',
        contentType: "application/json",
		data:{
	          vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	          vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
              hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
              },
        success: function(response) {
		  $("#uAvaliableCount").html(response.responseBody.length + '<span class="insideSHSt">Available</span>');
		    $.ajax({
            type: 'GET',
            url: t4uspringappURL1 + 'getUnassignedDedicatedList',
            datatype: 'json',
            contentType: "application/json",
			data:{
	              vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	              vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
                  hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
                 },
            success: function(response) {
		        $("#uDedicatedCount").html(response.responseBody.length + '<span class="insideSHSt">Dedicated</span>');
		    }
            });
	       }
        });

            $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getExtraTravelledKMSCount',
			data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
            success: function (result) {
            var data = JSON.parse(result).extraKMS[0];
              $("#distance50plus").html(data.unassigned50 + '<span class="insideSHSt">50 - 100 Km</span>');
              $("#distance100plus").html(data.unassigned100 + '<span class="insideSHSt">> 100 Km</span>');
              $("#utotalDistance").html(parseInt(data.unassigned50)+parseInt(data.unassigned100));
              $("#mdistance50plus").html(data.maintenance50 + '<span class="insideSHSt">50 - 100 Km</span>');
              $("#mdistance100plus").html(data.maintenance100 + '<span class="insideSHSt">> 100 Km</span>');
              $("#mtotalDistance").html(parseInt(data.maintenance50)+parseInt(data.maintenance100));
              }
            });

            $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getMaintenanceVehicleCountJson',
			data:{
	              vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	              vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
                  hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
                },
            success: function (result) {
            var data = JSON.parse(result).CountIndex[0];
                $("#mhaltedNonCommunicatingCount").html(data.haltedNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
                $("#mnonCommunicatingCount").html(data.nonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
                $("#mmovingNonCommunicatingCount").html(data.movingNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
                $("#midleNonCommunicatingCount").html(data.idlingNonCommunicatingCount + '<span class="insideSHSt">Non-Comm</span>');
                $("#mtotalCount").html(data.totalCount);
               $("#mtotalMoving").html(parseInt(data.movingCommunicatingCount)+parseInt(data.movingNonCommunicatingCount));
               $("#mtotalHalted").html(parseInt(data.haltedCommunicatingCount)+parseInt(data.haltedNonCommunicatingCount));
              $("#mtotalIdle").html(parseInt(data.idlingCommunicatingCount)+parseInt(data.idlingNonCommunicatingCount));
			  $("#minsh").html(data.insh);
			  totalMaintenanceCount = data.totalCount;
			  totalCount = totalCount + totalMaintenanceCount;
			 
              }
            });
			
			 $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getMaintenanceInsideSCCountJson',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).CountIndex[0];
            $("#minsideSC").html(data.insideSCCount + '<span class="insideSHSt">Inside SC</span>');
           }
          });
		  
		   $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getMaintenanceEnrouteSCCountJson',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).CountIndex[0];
            $("#mEnrouteSC").html(data.insideEnrouteCount + '<span class="insideSHSt">Enroute SC</span>');
           }
          });
		  
			
			
            $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getAssignedVehicleDaysJson',
			data:{
	              vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	              vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
                  hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
                },
            success: function (result) {
            var data = JSON.parse(result).List[0];
              $("#nonCommunicating5Hour").html(data.nonCommunicating5Hour + '<span class="insideSHSt">Non-Comm</span>');
              $("#nonCommunicating7Hour").html(data.nonCommunicating7Hour + '<span class="insideSHSt">Non-Comm</span>');
              $("#nonCommunicating10Hour").html(data.nonCommunicating10Hour + '<span class="insideSHSt">Non-Comm</span>');
              $("#total5Hour").html(parseInt(data.communicating5Hour)+parseInt(data.nonCommunicating5Hour));
              $("#total7Hour").html(parseInt(data.communicating7Hour)+parseInt(data.nonCommunicating7Hour));
              $("#total10Hour").html(parseInt(data.communicating10Hour)+parseInt(data.nonCommunicating10Hour));
              $("#inside5Hour").html(data.insideSH5Hour + '<span class="insideSHSt">Inside SH</span>');
              $("#inside7Hour").html(data.insideSH7Hour + '<span class="insideSHSt">Inside SH</span>');
              $("#inside10Hour").html(data.insideSH10Hour + '<span class="insideSHSt">Inside SH</span>');

              }
            });
			
			 $.ajax({
            type: "POST",
            url: t4uspringappURL + 'getAssignedVehicleSTPGreatherThan2DaysJson',
			 data:{
	         vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	         vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 	
             hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
			success: function (result) {
            var data = JSON.parse(result).List[0];
            $("#nonCommunicating2Hour").html(data.nonCommunicatingGrthn2Hour + '<span class="insideSHSt">Non-Comm</span>');
			$("#total2Hour").html(parseInt(data.communicatingGrthn2Hour)+parseInt(data.nonCommunicatingGrthn2Hour));
			$("#inside2Hour").html(data.insideSHGrth2Hour + '<span class="insideSHSt">Inside SH</span>');
           }
          });
		  
		  },3000);





        $.ajax({
        type: "POST",
        url: t4uspringappURL + 'getMaintenanceVehicleDaysJson',
		data:{
	              vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	              vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
                  hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
             },
        success: function (result) {
        var data = JSON.parse(result).List[0];
          $("#mnonCommunicating2Hour").html(data.nonCommunicating2Hour + '<span class="insideSHSt">Non-Comm</span>');
          $("#mnonCommunicating5Hour").html(data.nonCommunicating5Hour + '<span class="insideSHSt">Non-Comm</span>');
          $("#mnonCommunicating7Hour").html(data.nonCommunicating7Hour + '<span class="insideSHSt">Non-Comm</span>');
          $("#mnonCommunicating10Hour").html(data.nonCommunicating10Hour + '<span class="insideSHSt">Non-Comm</span>');
          $("#mtotal2Hour").html(parseInt(data.communicating2Hour)+parseInt(data.nonCommunicating2Hour));
		  
		  $("#lessThan12Hour").html(parseInt(data.agelessthan)+ '<span class="insideSHSt"> <12 Hrs</span>');
		  $("#greaterThan12Hour").html(parseInt(data.agegreathan)+ '<span class="insideSHSt"> >12 Hrs</span>');
          
		  $("#mtotal5Hour").html(parseInt(data.communicating5Hour)+parseInt(data.nonCommunicating5Hour));
          $("#mtotal7Hour").html(parseInt(data.communicating7Hour)+parseInt(data.nonCommunicating7Hour));
          $("#mtotal10Hour").html(parseInt(data.communicating10Hour)+parseInt(data.nonCommunicating10Hour));
          $("#minside2Hour").html(data.insideSH2Hour + '<span class="insideSHSt">Inside SH</span>');
            $("#minside5Hour").html(data.insideSH5Hour + '<span class="insideSHSt">Inside SH</span>');
              $("#minside7Hour").html(data.insideSH7Hour + '<span class="insideSHSt">Inside SH</span>');
                $("#minside10Hour").html(data.insideSH10Hour + '<span class="insideSHSt">Inside SH</span>');

          }
        });
}
   
function selected(element){
  $(".leftCountSelected").removeClass("leftCountSelected");
  $(".insideSH-gradient-rgbaSelected").removeClass("insideSH-gradient-rgbaSelected");
  $(".red-gradient-rgbaSelected").removeClass("red-gradient-rgbaSelected");
  $(element).hasClass("leftCount") ? $(element).addClass("leftCountSelected") : "" ;
  $(element).hasClass("insideSH-gradient-rgba") ? $(element).addClass("insideSH-gradient-rgbaSelected") : "" ;
  $(element).hasClass("red-gradient-rgba") ? $(element).addClass("red-gradient-rgbaSelected") : "" ;
}

function loadTableMap(element,tableAPI,mapAPI){
	window.console.clear();
  $('#loading-div').show();
  //console.log(tableAPI, mapAPI);
  loadInitialData();
  $("#tripDetailsDiv").html('<div class="col-lg-12"><strong>'+$(element).prop('title')+' - Vehicle Details</strong></div>')

  loadTable(tableAPI);
  loadMap(mapAPI);

}


// ************* Map Details
//initialize("map",new L.LatLng(<%=latitudeLongitude%>),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
 initialize("map",new L.LatLng(21.146633,79.088860),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');

var markerCluster;

function loadMap(api) {
   if(api.includes('getUnassignedVehicleMapList')){
		loadMapData(api);
	}
	else if (api.includes('odoroutemapdetails&type')){
		//alert("Map Api:: "+api);
		loadOdoMapData(api);
	}
	else{
		
	setTimeout(function(){
 
  //console.log("API Called", t4uspringappURL + api);
  $.ajax({
  type: "POST",
  url: t4uspringappURL + api,
  data:{
	vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
    hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
       },
  
    success: function (result) {
		
		var position = new L.LatLng(21.146633,79.088860);       
        map.setZoom(3.5);
	  
	  $('#loading-div').hide();
      var bounds = new L.LatLngBounds();

      results = JSON.parse(result);
      //console.log("Map", results);
      var count = 0;
      if (markerCluster) {
        map.removeLayer(markerCluster);
      }
      markerCluster = L.markerClusterGroup();
      var iconBase = "/ApplicationImages/VehicleImages/";
      var icons = {
        0: {
          name: 'On Time',
          icon: iconBase + 'ontime.svg'
        },
        1: {
          name: 'EnRoute Placement',
          icon: iconBase + 'enroute.svg'
        },
        2: {
          name: 'Delayed < 1hr',
          icon: iconBase + 'tempdelayed1.svg'
        },
        3: {
          name: 'Delayed > 1hr',
          icon: iconBase + 'tempdelayed2.svg'
        },
        4: {
          name: 'Loading Detention',
          icon: iconBase + 'EnroutePlacement.svg'
        },
        5: {
          name: 'Unloading Detention',
          icon: iconBase + 'detention.svg'
        },
        6: {
          name: 'Delayed - Late Departure',
          icon: iconBase + 'tempPink.svg'
        }
      };

    /* var legend = document.getElementById('legend');
      $("#legend").html("");
      for (var key in icons) {
        var type = icons[key];
        var name = type.name;
        var icon = type.icon;
        var div = document.createElement('div');
        div.innerHTML = '<img src="' + icon + '"> ' + name;
        legend.appendChild(div);
      }*/
      for (var i = 0; i < results["MapViewIndex"].length; i++) {
        if (!results["MapViewIndex"][i].lat == 0 && !results["MapViewIndex"][i].long == 0) {
          count++;
          let plot = true;
          /*if (noncommveh) {
            if (results["MapViewIndex"][i].CommStatus != "NON COMMUNICATING") {
              plot = false;
            }
          }
          if (unassignedVehtype == "moving") {
            if (results["MapViewIndex"][i].movingStatus != "Moved") {
              plot = false;
            }
          }
          if (unassignedVehtype == "halted") {
            if (results["MapViewIndex"][i].movingStatus != "Halted") {
              plot = false;
            }
          }*/
          if (plot) {
            plotSingleVehicle(results["MapViewIndex"][i].vehicleNO, results["MapViewIndex"][i].lat, results["MapViewIndex"][i].long,
              results["MapViewIndex"][i].location, results["MapViewIndex"][i].gmt,
              results["MapViewIndex"][i].tripStatus, results["MapViewIndex"][i].custName, results["MapViewIndex"][i].shipmentId,
              results["MapViewIndex"][i].delay, results["MapViewIndex"][i].humidity, results["MapViewIndex"][i].driverNames,
              results["MapViewIndex"][i].eta, results["MapViewIndex"][i].etha, results["MapViewIndex"][i].routeIdHidden,
              results["MapViewIndex"][i].ATD, results["MapViewIndex"][i].status, results["MapViewIndex"][i].tripId,
              results["MapViewIndex"][i].endDateHidden, results["MapViewIndex"][i].STD, results["MapViewIndex"][i].T1,
              results["MapViewIndex"][i].T2, results["MapViewIndex"][i].T3, results["MapViewIndex"][i].productLine, results["MapViewIndex"][i].Humidity, results["MapViewIndex"][i].tripNO,
              results["MapViewIndex"][i].routeName, results["MapViewIndex"][i].currentStoppageTime, results["MapViewIndex"][i].currentIdlingTime,
              results["MapViewIndex"][i].speed, results["MapViewIndex"][i].LRNO);
            var mylatLong = new L.LatLng(results["MapViewIndex"][i].lat, results["MapViewIndex"][i].long);
          }
        }
      }
      map.addLayer(markerCluster);
    }
  });
   },4000);
	}
}

function loadMapData(tableMapAPI){
	mapAPIArray = tableMapAPI.split(/[&=,]/);
	var mapType = mapAPIArray[2] ;
	
	setTimeout(function(){
	 $.ajax({
        type: "GET",
        url: t4uspringappURL1 + mapAPIArray[0],
		datatype: 'json',
        contentType: "application/json",
       data:{
	   vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	   vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
       hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
	   type: mapType,
	   },
	   success: function (response) {
		var position = new L.LatLng(21.146633,79.088860);       
        map.setZoom(3.5);
	    $('#loading-div').hide();
        var bounds = new L.LatLngBounds();

      result = response.responseBody;
      //console.log("Map", results);
      var count = 0;
      if (markerCluster) {
        map.removeLayer(markerCluster);
      }
      markerCluster = L.markerClusterGroup();
      var iconBase = "/ApplicationImages/VehicleImages/";
      var icons = {
        0: {
          name: 'On Time',
          icon: iconBase + 'ontime.svg'
        },
        1: {
          name: 'EnRoute Placement',
          icon: iconBase + 'enroute.svg'
        },
        2: {
          name: 'Delayed < 1hr',
          icon: iconBase + 'tempdelayed1.svg'
        },
        3: {
          name: 'Delayed > 1hr',
          icon: iconBase + 'tempdelayed2.svg'
        },
        4: {
          name: 'Loading Detention',
          icon: iconBase + 'EnroutePlacement.svg'
        },
        5: {
          name: 'Unloading Detention',
          icon: iconBase + 'detention.svg'
        },
        6: {
          name: 'Delayed - Late Departure',
          icon: iconBase + 'tempPink.svg'
        }
      };

   
          $.each(result, function (i, item) { 
		  
		  //console.log(item.latitude);
        if (!item.latitude == '' && !item.longitude == '') {
          count++;
          let plot = true;
          
          if (plot) {
            plotSingleVehicle(item.vehicleNumber, item.latitude, item.longitude,
              item.location, item.gmt,
              item.tripStatus, item.custName, item.shipmentId,
              item.delay, item.humidity, item.driverNames,
              item.eta, item.etha, item.routeIdHidden,
              item.ATD, item.status, item.tripId,
              item.endDateHidden, item.STD, item.T1,
              item.T2, item.T3, item.productLine, item.Humidity, item.tripNO,
              item.routeName, item.currentStoppageTime, item.currentIdlingTime,
              item.speed, item.LRNO);
            var mylatLong = new L.LatLng(item.latitude, item.longitude);
          }
        }
      });
      map.addLayer(markerCluster);
    }
  });
  },4000);
}



function loadOdoMapData(tableMapAPI){

	mapAPIArray = tableMapAPI.split(/[&]/);
	var mapArray= mapAPIArray[0] ;
	var mapArray1 = mapAPIArray[1] ;
	mapOdoType=mapArray1.split(/[=]/);
	var odoMapType=mapOdoType[1];
	
	//alert(mapArray);
	//alert(mapArray1);
	//alert("odoMapType"+odoMapType);
	
	setTimeout(function(){
	 $.ajax({
        type: "GET",
        url: t4uspringappURL1 + mapAPIArray[0],
		datatype: 'json',
        contentType: "application/json",
       data:{
			systemId: <%=systemId%>,
			customerId: <%=customerId%>,
			type: odoMapType,
	   },
	   success: function (response) {
		var position = new L.LatLng(21.146633,79.088860);       
        map.setZoom(3.5);
	    $('#loading-div').hide();
        var bounds = new L.LatLngBounds();

      result = response.responseBody;
      console.log("Map", results);
      var count = 0;
      if (markerCluster) {
        map.removeLayer(markerCluster);
      }
      markerCluster = L.markerClusterGroup();
      var iconBase = "/ApplicationImages/VehicleImages/";
      var icons = {
        0: {
          name: 'On Time',
          icon: iconBase + 'ontime.svg'
        },
        1: {
          name: 'EnRoute Placement',
          icon: iconBase + 'enroute.svg'
        },
        2: {
          name: 'Delayed < 1hr',
          icon: iconBase + 'tempdelayed1.svg'
        },
        3: {
          name: 'Delayed > 1hr',
          icon: iconBase + 'tempdelayed2.svg'
        },
        4: {
          name: 'Loading Detention',
          icon: iconBase + 'EnroutePlacement.svg'
        },
        5: {
          name: 'Unloading Detention',
          icon: iconBase + 'detention.svg'
        },
        6: {
          name: 'Delayed - Late Departure',
          icon: iconBase + 'tempPink.svg'
        }
      };

   
          $.each(result, function (i, item) { 
		  
		  //console.log(item.latitude);
        if (!item.latitude == '' && !item.longitude == '') {
          count++;
          let plot = true;
          
          if (plot) {
            plotSingleVehicle(item.vehicleNo, item.latitude, item.longitude,
              item.location, item.lastCommDateTime,
              item.tripStatus, item.customerName, item.tripNO,
              item.delay, item.humidity, item.driverName,
              item.etaToNextHub, item.etaToDestination, item.routeId,
              item.ATD, item.status, item.tripNO,
              item.endDateHidden, item.STD, item.T1,
              item.T2, item.T3, item.productLine, item.Humidity, item.tripNo,
              item.routeName, item.stoppageTime, item.idleTime,
              item.speed, item.LRNO);
            var mylatLong = new L.LatLng(item.latitude, item.longitude);
          }
        }
      });
      map.addLayer(markerCluster);
    }
  });
  },4000);
}

function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, tripStatus, custName, shipmentId, delay, weather,
  driverName, etaDest, etaNextPt, routeId, ATD, status, tripId, endDate, startDate, T1, T2, T3, productLine, Humidity, tripNo, routeName, currentStoppageTime, currentIdlingTime, speed, LRNO) {
  var tempContent = '';
  var humidityContent = '';
  var Humidity;
  if (productLine != 'Chiller' && productLine != 'Freezer' && productLine != 'TCL') {
    T1 = 'NA';
    T2 = 'NA';
    T3 = 'NA';
    Humidity = 'NA';
  }
  if (T1 != 'NA') {
    tempContent = '<tr><td><b>T @ reefer(Ã‚Â°C):</b></td><td>' + T1 + '</td></tr>'
  }
  if (T2 != 'NA') {
    tempContent = tempContent + '<tr><td><b>T @ middle(Ã‚Â°C):</b></td><td>' + T2 + '</td></tr>'
  }
  if (T3 != 'NA') {
    tempContent = tempContent + '<tr><td><b>T @ door(Ã‚Â°C):</b></td><td>' + T3 + '</td></tr>'
  }
  if (Humidity == '') {
    Humidity = 'NA';
  }

  if (T1 == 'NA' || T2 == 'NA' || T3 == 'NA') {
    humidityContent = '';
  } else {
    humidityContent = humidityContent + '<tr><td><b>Humidity:</b></td><td>' + Humidity + '</td></tr>';
  }

  var imageurl = '/ApplicationImages/VehicleImages/ontime.svg';
  if (tripStatus == 'ENROUTE PLACEMENT ON TIME' || tripStatus == 'ENROUTE PLACEMENT DELAYED') {
    imageurl = '/ApplicationImages/VehicleImages/enroute.svg';
  }
  if (tripStatus == 'ON TIME') {
    imageurl = '/ApplicationImages/VehicleImages/ontime.svg';
  }
  if (tripStatus == 'DELAYED' && delay < 60) {
    imageurl = '/ApplicationImages/VehicleImages/delayed1hr.svg';
  }
  if (tripStatus == 'DELAYED' && delay > 60) {
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
  if (tempContent != '' && tripStatus == 'DELAYED' && delay < 60) {
    imageurl = '/ApplicationImages/VehicleImages/tempdelayed1.svg';
  }
  if (tempContent != '' && tripStatus == 'DELAYED' && delay > 60) {
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
  var image = L.icon({
    iconUrl: String(imageurl),
    iconSize: [20, 40],
    popupAnchor: [0, -15]
  });
  var pos = new L.LatLng(latitude, longtitude);
  var coordinate = latitude + ',' + longtitude;

  vehicleNo = vehicleNo == null ? "NA" : vehicleNo;
  tripNo = tripNo == null ? "NA" : tripNo;
  LRNO = LRNO == null ? "NA" : LRNO;
  routeName = routeName == null ? "NA" : routeName;
  location = location == null ? "NA" : location;
  gmt = gmt == null ? "NA" : gmt;
  custName = custName == null ? "NA" : custName;
  delay = delay == null ? "NA" : convertMinutesToHHMM(delay);
  weather = weather == null ? "NA" : weather;
  driverName = driverName == null ? "NA" : driverName;
  etaNextPt = etaNextPt == null ? "NA" : etaNextPt;
  etaDest = etaDest == null ? "NA" : etaDest;
  currentStoppageTime = currentStoppageTime == null ? "NA" : currentStoppageTime;
  currentIdlingTime = currentIdlingTime == null ? "NA" : currentIdlingTime;
  speed = speed == null ? "NA" : speed;


  var content = '<div id="myInfoDiv" style="overflow:auto; color: #000; line-height:100%; font-size:11px; font-family: sans-serif;padding:4px;height: 380px !important;">' +
    '<table class="infoDiv">' +
    '<tr><td nowrap><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
    '<tr><td nowrap><b>Trip No:</b></td><td>' + tripNo + '</td></tr>' +
    '<tr><td nowrap><b>Route Name:</b></td><td>' + routeName + '</td></tr>' +
    '<tr><td nowrap><b>Location:</b></td><td>' + location.replace(/,/g, "<br/>") + '</td></tr>' +
    '<tr><td nowrap><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
    '<tr><td nowrap><b>Customer :</b></td><td>' + custName + '</td></tr>' +
    '<tr><td nowrap><b>Delay:</b></td><td>' + delay + '</td></tr>' +
    '<tr><td nowrap><b>weather:</b></td><td>' + weather + '</td></tr>' +
    '<tr><td nowrap><b>Driver Name:</b></td><td>' + driverName + '</td></tr>' +
    '<tr><td nowrap><b>Next Hub ETA:</b></td><td>' + etaNextPt + '</td></tr>' +
    '<tr><td nowrap><b>Dest ETA:</b></td><td>' + etaDest + '</td></tr>' +
    '<tr><td nowrap><b>LatLong:</b></td><td>' + coordinate.replace(",", "<br/>") + '</td></tr>' +
    '<tr><td nowrap><b>Curr Stoppage:&nbsp;&nbsp;</b></td><td>' + currentStoppageTime + ' (HH.mm)</td></tr>' +
    '<tr><td nowrap><b>Curr Idling:</b></td><td>' + currentIdlingTime + ' (HH.mm)</td></tr>' +
    '<tr><td nowrap><b>Speed(km/h):</b></td><td>' + speed + '</td></tr>' +
    tempContent +
    humidityContent +
    '</table>' +
    '</div>';
  contentOne = '<div id="myInfoDiv" style="overflow:auto; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;height: 380px;">' +
    '<table>' +
    '<tr><td></td><td>' + vehicleNo + '</td></tr>' +
    '</table>' +
    '</div>';


  var marker = new L.Marker(pos, {
    icon: image
  });
  marker.bindPopup(content);
  markerCluster.addLayer(marker);
  markerClusterArray.push(marker);

  var parameterStr = "tripNo=" + tripId + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + ATD + "&routeId=" + routeId;

  if (animate == "true") {
    //marker.setAnimation(google.maps.Animation.DROP);
  }
  if (location != 'No GPS Device Connected') {
    bounds.extend(pos);
  }

}


var table;


let rows = [];

function showCEDashboard(tripId) {
   window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/CEDashboard.jsp?tripId=" + tripId, '_blank');
}

function loadTable(api) {
	//alert(api);
	if(api == 'getUnassignedDedicatedList'|| api == 'getUnassignedAvailableVehicleList'){
		loadData(api);
	}
	else if(api.includes('odoroutelistdetails&type')){
		//alert("here api"+ api);
		loadOdoData(api);
	}
	else{
setTimeout(function(){
 window.console.clear();
 //console.log(Array(100).join("\n"));
  $.ajax({
  type: "POST",
  url: t4uspringappURL + api,
  data:{
	  vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	  vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
      hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
  },
  success: function (result) {
      result = JSON.parse(result).List;
      /*result = {"List":[{"movingStatus":"Halted","driver1Contact":"","driver2":"","driver1":"","routeId":"STN_CCU_302_001_STN_BAH_101_001_STN_RPR_001_001_SH_NAG_023_001_STN_BHI_302_001_3600-HR55AC0792-30112019123135","vehicleNumber":"HR55AC0792","driver2Contact":"","currentLocation":"1 kms from Jyothi Hospital, Kuruda,Balasore,Odisha,756056, Korkora, OD, India","tripNo":"8100028001","distance":220,"unassignedTime":"00:04:48","commStatus":"COMMUNICATING","tamperCount":0},{"movingStatus":"Halted","driver1Contact":"9451803236","driver2":"Om Kumar","driver1":"ASHOK KUMAR","routeId":"BDE_LKO_012_001_SH_NAG_023_001_BDE_MAA_077_001_3660-HR55AC0820-28112019190137","vehicleNumber":"HR55AC0820","driver2Contact":"9559662244","currentLocation":"Near to SVC_HYD_336_001,Hyderabad,Telangana,IN","tripNo":"8100027911","distance":1373,"unassignedTime":"01:10:48","commStatus":"COMMUNICATING","tamperCount":0}]}
      result = result.List;*/


      let rowCounter = 1;
      rows = [];
      $.each(result, function (i, item) {
        let row = [];
          row.push(rowCounter);
          row.push(item.unassignedTime != null? item.unassignedTime : "");
 		  row.push(item.tripNo != null ? '<span style="cursor:pointer;color:blue;" onClick="showCEDashboard(\'' + item.tripId + '\')">' + item.tripNo + '</span>' : "");
		   row.push(item.customerName != null? item.customerName : "");
          row.push(item.vehicleNumber != null? item.vehicleNumber : "");
		  
		  row.push(item.modelName != null? item.modelName : "");
		  row.push(item.srcHub != null? item.srcHub : "");

		  row.push(item.currentODORoute != null? item.currentODORoute : "");
		   row.push(item.vehicleCategory != null? item.vehicleCategory : "");
		  row.push(item.vehicleType != null? item.vehicleType : "");
		  
		  let movStatus = item.movingStatus != null? item.movingStatus : "";
 		  movStatus = movStatus === "Moved" ? "Moving": movStatus;
		  
		  row.push(movStatus);
          row.push(item.commStatus != null? item.commStatus : "");
          row.push(item.distance != null? item.distance : "");
          row.push(item.tamperCount != null? item.tamperCount : "");
          row.push(item.currentLocation != null? item.currentLocation : "");
          row.push(item.routeId != null? item.routeId : "");
          row.push(item.driver1 != null? item.driver1 : "");
          row.push(item.driver1Contact != null? item.driver1Contact : "");
          row.push(item.driver2 != null? item.driver2 : "");
          row.push(item.driver2Contact != null? item.driver2Contact : "");
		
		 
          
		 
        let push = true;
        if (noncommveh) {
          if (item.CommStatus != "NON COMMUNICATING") {
            push = false;
          }
        }
        if (unassignedVehtype == "moving") {
          if (item.movingStatus != "Moved") {
            push = false;
          }
        }
        if (unassignedVehtype == "halted") {
          if (item.movingStatus != "Halted") {
            push = false;
          }
        }
		
          rows.push(row);
          rowCounter++;
        
      });


            ////console.log("rows is", rows);



      
      $('#tableDiv').css('visibility', '');

      if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
        $('#tripSumaryTable').DataTable().clear();
      }

     table.rows.add(rows).draw();
	
	 
    /* table.column(9).visible(false);
     table.column(10).visible(false);
     table.column(11).visible(false);
     table.column(12).visible(false);
     table.column(13).visible(false);
     table.columns.adjust().draw();*/

    }
  });
  },2000);
	}
}
 
 function loadData(tableAPIData) {
    setTimeout(function(){
     $.ajax({
        type: "GET",
        url: t4uspringappURL1 + tableAPIData,
		datatype: 'json',
        contentType: "application/json",
       data:{
	   vehicleCat: $("#vehCatgy").val().length   === vehCatLength || $("#vehCatgy").val() == '' ? 'ALL' : $("#vehCatgy").val().toString() ,  
	   vehicleType: $("#vehType").val().length > 0 ? $("#vehType").val().toString() : 'ALL', 
       hubType: $("#hubWise").val().length > 0 ? $("#hubWise").val().toString() : 'ALL',
       },
	    success: function (response) {
      result = response.responseBody;
      let rowCounter = 1;
      rows = [];
      $.each(result, function (i, item) {
        let row = [];
          row.push(rowCounter);
          row.push(item.unassignedTime != null? item.unassignedTime : "");
 		  row.push(item.tripNo != null ? '<span style="cursor:pointer;color:blue;" onClick="showCEDashboard(\'' + item.tripId + '\')">' + item.tripNo + '</span>' : "");
		  row.push(item.customerName != null? item.customerName : "");
          row.push(item.vehicleNumber != null? item.vehicleNumber : "");
		  row.push(item.modelName != null? item.modelName : "");
		  row.push(item.srcHub != null? item.srcHub : "");
          row.push(item.currentODORoute != null? item.currentODORoute : "");
		  row.push(item.vehicleCategory != null? item.vehicleCategory : "");
		  row.push(item.vehicleType != null? item.vehicleType : "");
		  let movStatus = item.movingStatus != null? item.movingStatus : "";
 		  movStatus = movStatus === "Moved" ? "Moving": movStatus;
		  row.push(movStatus);
          row.push(item.commStatus != null? item.commStatus : "");
          row.push(item.distance != null? item.distance : "");
          row.push(item.tamperCount != null? item.tamperCount : "");
          row.push(item.currentLocation != null? item.currentLocation : "");
          row.push(item.routeId != null? item.routeId : "");
          row.push(item.driver1 != null? item.driver1 : "");
          row.push(item.driver1Contact != null? item.driver1Contact : "");
          row.push(item.driver2 != null? item.driver2 : "");
          row.push(item.driver2Contact != null? item.driver2Contact : "");
		
		let push = true;
        if (noncommveh) {
          if (item.CommStatus != "NON COMMUNICATING") {
            push = false;
          }
        }
        if (unassignedVehtype == "moving") {
          if (item.movingStatus != "Moved") {
            push = false;
          }
        }
        if (unassignedVehtype == "halted") {
          if (item.movingStatus != "Halted") {
            push = false;
          }
        }
		rows.push(row);
          rowCounter++;
        
      });

      $('#tableDiv').css('visibility', '');

      if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
        $('#tripSumaryTable').DataTable().clear();
      }

     table.rows.add(rows).draw();
	
	}
  });

  },2000);
 }
 
 function loadOdoData(tableAPIData) {
	odoListArray = tableAPIData.split(/[&]/);
	var listType = odoListArray[0] ;
	var listType1 = odoListArray[1] ;
	type=listType1.split(/[=]/);
	var odoType=type[1];
	
	//alert(listType);
	//alert(listType1);
	//alert(odoType);
    setTimeout(function(){
     $.ajax({
        type: "GET",
        url: t4uspringappURL1 + listType,
		datatype: 'json',
        contentType: "application/json",
       data:{
			systemId: <%=systemId%>,
			customerId: <%=customerId%>,
			type: odoType
       },
	    success: function (response) {
      result = response.responseBody;
      let rowCounter = 1;
      rows = [];
      $.each(result, function (i, item) {
        let row = [];
          row.push(rowCounter);
          row.push(item.ageingDuration != null? item.ageingDuration : "");
 		  row.push(item.tripNo != null ? '<span style="cursor:pointer;color:blue;" onClick="showCEDashboard(\'' + item.tripId + '\')">' + item.tripNo + '</span>' : "");
		  row.push(item.customerName != null? item.customerName : "");
          row.push(item.vehicleNo != null? item.vehicleNo : "");
		  row.push(item.vehicleMake != null? item.vehicleMake : "");
		  row.push(item.vehicleSrcHub != null? item.vehicleSrcHub : "");
          row.push(item.odoRoute != null? item.odoRoute : "");
		  row.push(item.vehicleCategory != null? item.vehicleCategory : "");
		  row.push(item.vehicleType != null? item.vehicleType : "");
		  row.push(item.movingStatus != null? item.movingStatus : "");
          row.push(item.communicationStatus != null? item.communicationStatus : "");
          row.push(item.distance != null? item.distance : "");
          row.push(item.tamperCount != null? item.tamperCount : "");
          row.push(item.location != null? item.location : "");
          row.push(item.routeId != null? item.routeId : "");
          row.push((item.driverName == "" || item.driverName == null) ? "" : item.driverName.split("/")[0]);
          row.push((item.driverContact == "" || item.driverContact == null) ? "" : item.driverContact.split("/")[0]);
          row.push((item.driverName == "" || item.driverName == null || item.driverName.split("/")[1] == null) ? "" : item.driverName.split("/")[1]);
          row.push((item.driverContact == "" || item.driverContact == null || item.driverContact.split("/")[1] == null) ? "" : item.driverContact.split("/")[1]);
	
		rows.push(row);
          rowCounter++;
        
      });

      $('#tableDiv').css('visibility', '');

      if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
        $('#tripSumaryTable').DataTable().clear();
      }

     table.rows.add(rows).draw();
	
	}
  });

  },2000);
 }
 
var tableNew;

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

function format(d) {

  var tbody = "";
  var a;

  if (d.legdetails.length > 0) {
    for (var i = 0; i < d.legdetails.length; i++) {
      var row = "";
      row += '<tr>'
      row += '<td>' + d.legdetails[i].LegName + '</td>';
      row += '<td>' + d.legdetails[i].Driver1 + '</td>';
      row += '<td>' + d.legdetails[i].Driver2 + '</td>';
      row += '<td>' + d.legdetails[i].STD + '</td>';
      row += '<td>' + d.legdetails[i].STA + '</td>';
      row += '<td>' + d.legdetails[i].ATD + '</td>';
      row += '<td>' + d.legdetails[i].ATA + '</td>';
      row += '<td>' + d.legdetails[i].TotalDistance + '</td>';
      row += '<td>' + d.legdetails[i].AvgSpeed + '</td>';
      row += '<td>' + d.legdetails[i].FuelConsumed + '</td>';
      row += '<td>' + d.legdetails[i].Mileage + '</td>';
      row += '<td>' + d.legdetails[i].OBDMileage + '</td>';
      row += '<td>' + d.legdetails[i].TravelDuration + '</td>';
      row += '<td>' + d.legdetails[i].ETA + '</td>';

      row += '</tr>';
      tbody += row;
    }
    a = '<div style="overflow-x:auto;width:29%">' +
      '<table class="table table-bordered" >' +
      '<thead>' +
      '<tr ">' +
      '<th>Leg Name</th>' +
      '<th>Driver 1</th>' +
      '<th>Driver 2</th>' +
      '<th>STD</th>' +
      '<th>STA</th>' +
      '<th>ATD</th>' +
      '<th>ATA</th>' +
      '<th>Total Distance (km)</th>' +
      '<th>Average Speed (kmph)</th>' +
      '<th>Fuel Consumed</th>' +
      '<th>Mileage</th>' +
      '<th>OBD Mileage</th>' +
      '<th>Travel Duration (HH:mm)</th>' +
      '<th>ETA</th>' +
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


  if (columnIndex == 2) {
    window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
  }
  event.preventDefault();
});

$('#legbtn').click(function () {
  $.ajax({
    url: '<%=request.getContextPath()%>/LegDetailsExportAction.do?param=createLegExcel',
    data: {
      groupId: groupId,
      unit: '<%=unit%>',
      custName: custName,
      routeId: routeId,
      status: tripStatus
    },
    success: function (responseText) {
      window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
    }
  });
});
</script>
<jsp:include page="../Common/footer.jsp" />

