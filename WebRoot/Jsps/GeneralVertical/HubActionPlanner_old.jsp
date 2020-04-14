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
    String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
    MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
String mapName = bean.getMapName();
String appKey = bean.getAPIKey();
String appCode = bean.getAppCode();
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
<link href = "https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css"
     rel = "stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
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
   -webkit-transition: 2s; /* Safari prior 6.1 */
transition: 2s;
 }


.dataTables_wrapper .dataTables_filter input {
   border-radius: 8px !important;
}



thead th {
 white-space: nowrap;
}

thead {
 color: #ece9e6 !important;
 background-color: #355869 !important;
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

.page-item.active .page-link {
    z-index: 3;
    color: #fff;
    background-color: #355869;
    border-color:#355869;
  }

  .infoDiv td {
    padding: 4px;
    vertical-align: top;
    line-height: 12px;
    border: 1px solid #dfdfdf;
}


/* thead th:last-child {
      border-top-right-radius: 8px;
      -webkit-border-top-right-radius: 8px;
      -moz-border-radius-topright: 8px;
  }
  thead th:first-child {
      border-top-left-radius: 8px;
      -webkit-border-top-left-radius: 8px;
      -moz-border-radius-topleft: 8px;
  }

  div.dataTables_scrollHead table {
    border-top-left-radius: 4px;
  }

  div.dataTables_scrollHead th:first-child {
    border-top-left-radius: 4px;
  }*/


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
     left: 35%;
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
 padding: 0px 12px 0px 16px;
 align-items: center;
}



.col-lg-4 {
 padding: 0px 4px !important;
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
li{
  min-height:32px;
  max-height:32px;
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

.topRowData{
 margin-bottom: 24px;
   color: #ece9e6;
   text-align: center;
 background: #355869;
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
 padding: 6px 16px;
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

.leftCount{
  background:none !important;
  font-size:28px !important;
  height:50px !important;
  width:90px !important;
}

.rightText{
  font-weight: 700 !important;
    font-size: 13px !important;
    height:50px;
    display: flex;
    align-items: center;
    text-transform: uppercase;
}

.leftText{
  background:none !important;
  font-size:28px !important;
  height:50px !important;
  width:80px !important;
  margin-top:4px;
}

.leftTop{
      padding-left: 20px;
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
.mapBackground{
  width:100%;
  height:630px;
  position:absolute;
  top:0px;
  opacity:0.3;
  background-size: cover;
}
.outer-1 {
            //  background:radial-gradient(circle,#ffcc00 25%,#ffffff) !important;
              width:630px; /* You can define it by % also */
              height:630px; /* You can define it by % also*/
              position:absolute;
              border:3px solid #ffcc00;
              border-radius: 50%;
              top:0px;
              background: #ffffff;

}
.inner-1 {
              top: 10%; left:10%; /* of the container */
              width:80%; /* of the outer-1 */
              height:80%; /* of the outer-1 */
              position: absolute;
            //  border:1px solid black;
            //  border-radius: 50%;
}
.inner-2 {

              top: 30%; left:30%; /* of the container */
              width:40%; /* of the inner-1 */
              height:40%; /* of the inner-1 */
              position: absolute;
            //  border:1px solid black;
              //  border-radius: 50%;
}
.inner-3 {
            // background: #d40511;
              top: 45%; left:45%; /* of the container */
              width:10%; /* of the inner-1 */
              height:10%; /* of the inner-1 */
              position: absolute;
            //  border:1px solid black;
              //  border-radius: 50%;
}

.width100{
width:100%;
}

svg{
height: 100%;
width: 100%;
}
.circle {
fill: transparent;
stroke: #d40511;
stroke-width: 1;
}
.circleInner {
fill: transparent;
stroke: #d40511;
stroke-width: 20;
}
.solid{
stroke-dasharray: none;
}
.dashed {
stroke-dasharray: 8, 8.5;
}
.dotted {
stroke-dasharray: 0.1, 3.5;
stroke-linecap: round;
}



</style>


<div class="center-viewInitial" id="loading-divInitial"  style="display:none;">
   <img src="../../Main/images16oading.gif" alt="" style="position:absolute;left:48%;">
</div>
<div class="center-view" id="loading-div" style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;">
</div>
<div class="topRowData dhlBackTop" id="slaDashboardHeader" style="margin-top:-18px;display:flex;justify-content:space-between;align-items:center;">
  <div style="font-weight:bold;font-size:16px;">HUB ACTION PLANNER</div>
</div>
<div class="row" id="columnContainer" style="margin-top:-16px;">
  <div class="col-lg-2">
     <div class="card">
        <div class="cardHeading blue-gradient-rgba">
          <div class="flex"><div class="leftText leftTop"  id="incomingTotal" ><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
          <div data-toggle="tooltip" class="rightText topCardText" title=""  class="red">INCOMING</div></div>
        </div>
        <div class="card cardOtherDet">
           <div class="flex flexRow"><div class="leftText" id="incomingLessThan2Hours"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
           <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2 hours</div></div>
        </div>
        <div class="card cardOtherDet">
           <div class="flex"><div class="leftText" id="incoming2To4Hours"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
           <div data-toggle="tooltip" class="rightText" title=""  class="red">2 to 4 hours</div></div>
        </div>
        <div class="card cardOtherDet">
           <div class="flex"><div class="leftText" id="incoming4To8Hours"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
           <div data-toggle="tooltip" class="rightText" title=""  class="red">4 to 8 hours</div></div>
        </div>
        <div class="card cardOtherDet">
           <div class="flex"><div class="leftText" id="incomingGreaterThan8Hours" ><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
           <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-greater-than"></i>&nbsp;8 hours</div></div>
        </div>
           <div class="cardOtherDetAgeing">ALERTS</div>
           <div class="card cardOtherDet">
              <div class="flex"><div class="leftText" id="incomingSHMissed"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title=""  class="red">SH Missed</div></div>
           </div>
           <div class="card cardOtherDet">
              <div class="flex"><div class="leftText" id="incomingRouteDeviation"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title=""  class="red">Route Deviation</div></div>
          </div>
           <div class="card cardOtherDet">
              <div class="flex"><div class="leftText" id="incomingUnplannedStoppage" ><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Stoppage</div></div>
            </div>
           <div class="card cardOtherDet">
              <div class="flex"><div class="leftText" id="incomingTempDeviation" ><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Temp. Deviation</div></div>
           </div>
     </div>
  </div>

<div class="col-lg-8" id="leftColumn"style="padding:0px;display:flex;justify-content:center;">
  <div class="abs mapBackground" onclick="toggleMapCircle()" id="map">Map</div>

  <div class="abs outer-1" id="circle" onclick="toggleMapCircle()">

    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
    <title>Hours</title>
    <defs>
    <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z" id="starbuckscircleTop" transform="rotate(-15  -18 70)" />
    </defs>
    <text  font-size = "4.5" fill="#d40511" font-weight="bold">
    <textPath xlink:href="#starbuckscircleTop">4 TO 8 HOURS</textPath>
    </text>
    </svg>
            <div class="inner-1">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
              <title>Hours</title>
              <defs>
              <path d="M15,100a85,85 0 1,0 170,0a85,85 0 1,0 -170,0" id="coffeecircle" />
              <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z" id="starbuckscircle" transform="rotate(-16 20 80)" />
              </defs>
              <circle fill="none" stroke="#ffcc00" cx="100" cy="100" r="93.8" stroke-width="3" id="rim" />
              <text  font-size = "6" fill="#d40511" font-weight="bold">
              <textPath xlink:href="#starbuckscircle">2 TO 4 HOURS</textPath>
              </text>

              </svg>

              <img src="truckS.png" style="position:absolute;left:50%;top:80%;"/>
              <img src="truckS.png" style="position:absolute;left:80%;top:50%;transform:rotate(270deg)"/>
              <img src="truckS.png" style="position:absolute;left:90%;top:60%;transform:rotate(280deg)"/>
              <img src="truckS.png" style="position:absolute;left:10%;top:10%;transform:rotate(120deg)"/>


            </div>

            <div class="inner-2">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
              <title>Hours</title>
              <defs>
              <path d="M15,100a85,85 0 1,0 170,0a85,85 0 1,0 -170,0" id="coffeecircle1" />
              <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z" id="starbuckscircle24" transform="rotate(-26 60 86)" />
              </defs>
              <circle fill="none" stroke="#ffcc00" cx="100" cy="100" r="93.8" stroke-width="3" id="rim1" />
              <text   font-size = "12" fill="#d40511" font-weight="bold">
              <textPath xlink:href="#starbuckscircle24">0 TO 2 HOURS</textPath>
              </text>
              </svg>
            </div>
            <div class="inner-3">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
              <title>Hours</title>
              <defs>
              <path d="M15,100a85,85 0 1,0 170,0a85,85 0 1,0 -170,0" id="coffeecircle2" />
              <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z" id="starbuckscircle" transform="rotate(-28 100 100)" />
              </defs>
              <circle cx="100" cy="100" r="100" fill="#d40511" id="background" />
              <circle fill="none" stroke="#ccff00" cx="100" cy="100" r="93.8" stroke-width="3" id="rim2" />
              </svg>
            </div>
</div>
</div>

<div class="col-lg-2">
 <div class="card">
    <div class="cardHeading blue-gradient-rgba">
      <div class="flex"><div class="leftText leftTop"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
      <div data-toggle="tooltip" class="rightText topCardText" title=""  class="red">OUTGOING</div></div>
    </div>
    <div class="card cardOtherDet">
       <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
       <div data-toggle="tooltip" class="rightText" title=""  class="red"><i class="fas fa-greater-than"></i>&nbsp;8 HOURS</div></div>
  </div>
    <div class="card cardOtherDet">
       <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
       <div data-toggle="tooltip" class="rightText" title=""  class="red">4 to 8 hours</div></div>
    </div>
    <div class="card cardOtherDet">
       <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
       <div data-toggle="tooltip" class="rightText" title=""  class="red">2 to 4 hours</div></div>
    </div>
    <div class="card cardOtherDet">
       <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
       <div data-toggle="tooltip" class="rightText" title=""  class="red"><i class="fas fa-less-than"></i>&nbsp;2 hours</div></div>
    </div>
       <div class="cardOtherDetAgeing">TASKS</div>
       <div class="card cardOtherDet">
          <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
          <div data-toggle="tooltip" class="rightText" title=""  class="red">Type 1</div></div>
       </div>
       <div class="card cardOtherDet">
          <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
          <div data-toggle="tooltip" class="rightText" title=""  class="red">Type 2</div></div>
       </div>
       <div class="card cardOtherDet">
          <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
          <div data-toggle="tooltip" class="rightText" title=""  class="red">Type 3</div></div>
         </div>
       <div class="card cardOtherDet">
          <div class="flex"><div class="leftText"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
          <div data-toggle="tooltip" class="rightText" title=""  class="red">Type 4</div></div>
       </div>
 </div>
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
               <th>Ageing(DD:HH:MM)</th>
               <th>Trip No</th>
               <th>Moving Status</th>
               <th>Communication Status</th>
               <th>Distance</th>
               <th>Vehicle No</th>
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
//let t4uspringappURL = 'https://track-staging.dhlsmartrucking.com/Telematics4uApp/tripDashBoardAction.do?param=';
//let t4uspringappURL = 'http://localhost:8080/Telematics4uApp/tripDashBoardAction.do?param=';
let t4uspringappURL = "<%=request.getContextPath()%>/tripDashBoardAction.do?param=";
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

let toggleVal="";

function toggleMapCircle(){
  if(toggleVal === "map"){
    $("#map").show(1000);
    $("#circle").animate({height:"630px", width:"630px", left: "15%"},1000);
    $("#map").animate({opacity:0.3},1000);
    toggleVal=""

  }
  else {
    $("#map").show(1000);
    $("#circle").animate({height:"30px", width:"30px", left:"0px"},1000);
    $("#map").animate({opacity:1},1000);
    toggleVal="map"
  }

}

$("#incomingSHMissed").html(0);
$("#incoming4To8Hours").html(0);
$("#incoming2To4Hours").html(0);
$("#incomingTempDeviation").html(0);
$("#incomingRouteDeviation").html(0);
$("#incomingLessThan2Hours").html(0);
$("#incomingUnplannedStoppage").html(0);
$("#incomingGreaterThan8Hours").html(0);
$("#incomingTotal").html(0);

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
  loadTable("getUnassignedVehiclesDetails");
  loadMap('getUnassignedVehiclesMapDetails&commStatus=ALL&moveStatus=&days=0');
},300000 )




function selected(element){
  $(".leftCountSelected").removeClass("leftCountSelected");
  $(".insideSH-gradient-rgbaSelected").removeClass("insideSH-gradient-rgbaSelected");
  $(".red-gradient-rgbaSelected").removeClass("red-gradient-rgbaSelected");
  $(element).hasClass("leftCount") ? $(element).addClass("leftCountSelected") : "" ;
  $(element).hasClass("insideSH-gradient-rgba") ? $(element).addClass("insideSH-gradient-rgbaSelected") : "" ;
  $(element).hasClass("red-gradient-rgba") ? $(element).addClass("red-gradient-rgbaSelected") : "" ;
}

function loadTableMap(element,tableAPI,mapAPI){
  console.log(tableAPI, mapAPI)
  $("#tripDetailsDiv").html('<div class="col-lg-12"><strong>'+$(element).prop('title')+' - Vehicle Details</strong></div>')

  loadTable(tableAPI);
  loadMap(mapAPI);

}


// ************* Map Details
//initialize("map",new L.LatLng(<%=latitudeLongitude%>),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
initialize("map",new L.LatLng(21.146633,79.088860),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');

var markerCluster;

function loadMap(api) {
  //$('#loading-div').show();
  console.log("API Called", t4uspringappURL + api);
  $.ajax({
  type: "POST",
  url: t4uspringappURL + api,
    success: function (result) {

      var bounds = new L.LatLngBounds();

      results = JSON.parse(result);
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
          if (noncommveh) {
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
          }
          if (plot) {
            plotSingleVehicle(results["MapViewIndex"][i].vehicleNo, results["MapViewIndex"][i].lat, results["MapViewIndex"][i].long,
              results["MapViewIndex"][i].location, results["MapViewIndex"][i].gmt,
              results["MapViewIndex"][i].tripStatus, results["MapViewIndex"][i].custName, results["MapViewIndex"][i].shipmentId,
              results["MapViewIndex"][i].delay, results["MapViewIndex"][i].weather, results["MapViewIndex"][i].driverName,
              results["MapViewIndex"][i].etaDest, results["MapViewIndex"][i].etaNextPt, results["MapViewIndex"][i].routeIdHidden,
              results["MapViewIndex"][i].ATD, results["MapViewIndex"][i].status, results["MapViewIndex"][i].tripId,
              results["MapViewIndex"][i].endDateHidden, results["MapViewIndex"][i].STD, results["MapViewIndex"][i].T1,
              results["MapViewIndex"][i].T2, results["MapViewIndex"][i].T3, results["MapViewIndex"][i].productLine, results["MapViewIndex"][i].Humidity, results["MapViewIndex"][i].tripNo,
              results["MapViewIndex"][i].routeName, results["MapViewIndex"][i].currentStoppageTime, results["MapViewIndex"][i].currentIdlingTime,
              results["MapViewIndex"][i].speed, results["MapViewIndex"][i].LRNO);
            var mylatLong = new L.LatLng(results["MapViewIndex"][i].lat, results["MapViewIndex"][i].long);
          }
        }
      }
      map.addLayer(markerCluster);
    }
  });
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
    tempContent = '<tr><td><b>T @ reefer(°C):</b></td><td>' + T1 + '</td></tr>'
  }
  if (T2 != 'NA') {
    tempContent = tempContent + '<tr><td><b>T @ middle(°C):</b></td><td>' + T2 + '</td></tr>'
  }
  if (T3 != 'NA') {
    tempContent = tempContent + '<tr><td><b>T @ door(°C):</b></td><td>' + T3 + '</td></tr>'
  }
  if (Humidity == '') {
    Humidity = 'NA';
  }

  if (T1 == 'NA' || T2 == 'NA' || T3 == 'NA') {
    humidityContent = '';
  } else {
    humidityContent = humidityContent + '<tr><td><b>Humidity:</b></td><td>' + Humidity + '</td></tr>';
  }

  var imageurl;
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
  delay = delay == null ? "NA" : delay;
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
    '<tr><td nowrap><b>LR No:</b></td><td>' + LRNO + '</td></tr>' +
    '<tr><td nowrap><b>Route Name:</b></td><td>' + routeName + '</td></tr>' +
    '<tr><td nowrap><b>Location:</b></td><td>' + location.replace(/,/g, "<br/>") + '</td></tr>' +
    '<tr><td nowrap><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
    '<tr><td nowrap><b>Customer :</b></td><td>' + custName + '</td></tr>' +
    '<tr><td nowrap><b>Delay:</b></td><td>' + convertMinutesToHHMM(delay) + '</td></tr>' +
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
  //$('#loading-div').show();
  console.log("Table API Called", t4uspringappURL + api);
  $.ajax({
  type: "POST",
  url: t4uspringappURL + api,
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
		  let movStatus = item.movingStatus != null? item.movingStatus : "";
 		  movStatus = movStatus === "Moved" ? "Moving": movStatus;
          row.push(movStatus);
          row.push(item.commStatus != null? item.commStatus : "");
          row.push(item.distance != null? item.distance : "");
          row.push(item.vehicleNumber != null? item.vehicleNumber : "");
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
        if (push) {
          rows.push(row);
          rowCounter++;
        }
      });


            console.log("rows is", rows);



      $('#loading-div').hide();
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
      ' <thead>' +
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
