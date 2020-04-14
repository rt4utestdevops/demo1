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
String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();
%>

<jsp:include page="../Common/header.jsp" />
<jsp:include page="../Common/InitializeLeaflet.jsp" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" type="text/css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css" type="text/css"/>
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


 .nav-link img{
   margin-top:0px !important;
 }


.dataTables_wrapper .dataTables_filter input {
   border-radius: 8px !important;
}



table thead th {
 white-space: nowrap;
/* color: #d40511 !important;*/
 color: black !important;
 background-color: #ffcc00 !important;
}

table thead {
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

.page-item.active .page-link {
    z-index: 3;
    color: #d40511;
    background-color: #ffffff;
    border-color:#ffcc00;
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
padding: 0px 0px 0px 0px;
border: 0px !important;
text-align: center;
}

.center-view {
 background: none;
 position: fixed;
 z-index: 1000000000;
 top: 40%;
 left: 47%;
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
.flexCol{
  display:flex;
 flex-direction: column;
 justify-content: center;
}

.marg8{
  margin-left:-8px;
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
   color:black;
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
 margin-left: -15px !important;
margin-right: -15px !important;
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
background: #d40511 !important;
    border: 1px solid #d40511 !important;
    border-radius: 8px !important;
}

    #tripDatatable_filter label{
      display: flex;
      align-items: center;
      text-transform: uppercase;
    }

    #tableDiv{
      width:100%;border-radius:8px;overflow:hidden;;
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
    padding: 2px 8px 4px 2px;
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
  font-size:15px;
  background: #ffcc00 !important;
  margin:4px 0px;
}

.cardOtherDet span{
  text-transform: uppercase;
  padding-bottom: 2px;
}

#tripDatatable_wrapper{padding:0px !important;}

.leftCount{
  background:none !important;
  font-size:28px !important;
  height:50px !important;
  width:90px !important;
}

.rightText{
  font-weight: 700 !important;
    font-size: 11px !important;
    height:48px;
    display: flex;
    align-items: center;
    text-align: left;
    white-space: nowrap;
    text-transform: uppercase;
}

.rightTextHead{
  font-weight: 700 !important;
    font-size: 15px !important;
    height:48px;
    display: flex;
    align-items: center;
    text-align: left;
    white-space: nowrap;
    text-transform: uppercase;
}

.leftText{
  background:none !important;
  font-size:25px !important;
/*  height:50px !important;*/
  width:56px !important;
  margin-top:4px;

}

.leftTextHead{
  background:none !important;
  font-size:27px !important;
/*  height:50px !important;*/
  width:64px !important;
  margin-top:4px;

}

.leftTextNA{
  background:none !important;
  font-size:20px !important;
/*  height:50px !important;*/
  width:64px !important;
  margin-top:4px;

}

.leftText:hover,.leftTextSelected{
  color:#d40511;
}

.leftText:active{
  color:#d40511;
}

.leftTop{
      padding-left: 10px;
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
              pointer-events: none;
z-index: 0;

}
.inner-1 {
              top: 10%; left:10%; /* of the container */
              width:80%; /* of the outer-1 */
              height:80%; /* of the outer-1 */
              position: absolute;
            //  border:1px solid black;
            //  border-radius: 50%;
            pointer-events: none;
z-index: 0;
}
.inner-2 {

              top: 30%; left:30%; /* of the container */
              width:40%; /* of the inner-1 */
              height:40%; /* of the inner-1 */
              position: absolute;
            //  border:1px solid black;
              //  border-radius: 50%;
              pointer-events: none;
z-index: -1;
}
.inner-3 {
            // background: #d40511;
              top: 45%; left:45%; /* of the container */
              width:10%; /* of the inner-1 */
              height:10%; /* of the inner-1 */
              position: absolute;
            //  border:1px solid black;
              //  border-radius: 50%;
              pointer-events: none;
z-index: -1;
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

.tooltipQ {

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

.toolTipDiv{
  border-bottom: 1px solid #dfdfdf;
  margin:2px 8px;
  text-align: left;
  display:flex;
  width:100%;
  justify-content: left;
}
.toolTipLeft
{
  width:130px;
  padding-left:8px;
  font-weight:500
}
.toolTipRight
{
  width:370px;
}

.toolTipDivLast{
  margin:2px 8px;
  text-align: left;
  display:flex;
  width:100%;
  justify-content: left;
}

.topCardText{
  font-weight:400;
  font-size:20px;
  width:100%;//text-align:center;
}

.topText{
  font-weight:400;
  font-size:12px;
}

.toolOuter{
  position:absolute;left: 0;top: 0;width: 100%;height: 100%;pointer-events: none;
  z-index:1;
}

.toolOuter1Hourincoming, .toolOuter1Houroutgoing{
  position: absolute;
  left: 35%;
  top: 35%;
  width: 30%;
  height: 30%;
  pointer-events: none;
  z-index:1;
}
.toolOuter2Hourincoming , .toolOuter2Houroutgoing{
position: absolute;
left: 27%;
top: 28%;
width: 45%;
height: 45%;
pointer-events: none;
z-index:1;
}
.toolOuter3Hourincoming, .toolOuter3Houroutgoing {
position: absolute;
left: 16%;
top: 16%;
width: 68%;
height: 68%;
pointer-events: none;
z-index:1;
}
.toolOuter4Hourincoming, .toolOuter4Houroutgoing {
position: absolute;
left: 4%;
top: 4%;
width: 92%;
height: 92%;
pointer-events: none;
z-index:1;
}
.toolOuter4to6Hourincoming, .toolOuter4to6Houroutgoing {
position: absolute;
  left: -40px;
  top: -40px;
  width: 116%;
  height: 116%;
  pointer-events: none;
  z-index:1;
}
.toolOuter6to8Hourincoming, .toolOuter6to8Houroutgoing {
position: absolute;
  left: -60px;
  top: -60px;
  width: 125%;
  height: 125%;
  pointer-events: none;
  z-index:1;
}


.truckImage{
  left: 50%;
  position: absolute;
  pointer-events: all;
  z-index:1;
}

.inHub{
  position: absolute;
  top:46.5%;
  left:46%;
  width:40px;
  height:40px;
  color:white;
  font-size: 20px;
z-index: 100;

 pointer-events: all;
}

.inHubFlex{
  display:flex;
  justify-content: center;
  align-items: center;
}
.popUpTop{
  display: flex;
  padding:16px 20px;
  justify-content: space-between;
  align-items: center;
}

.select2-results ul li{
  white-space: nowrap;
}

.center-viewLoading1{
  top:30%;
  left:40%;
  position:fixed;
  height:200px;
  z-index: -1;
}

.mapPopUpComponent{
  width:250px;
  height:250px;
  background:white;
  opacity:1
}

.leaflet-popup-content{
  width:500px !important;
  padding-bottom:24px;
}

.table-striped tbody tr:nth-of-type(odd) {
  background-color: #efefef!important;
}
.arrowTop{
  height:16px;
  width:16px;
  left:48%;
  top:-3%;
  border-left:1px solid #ffcc00;
  border-top:1px solid #ffcc00;
  background: #ffffff;
  transform:rotate(45deg);
  position:absolute;
}

.arrowBottom{
  height:16px;
  width:16px;
  left:48%;
  bottom:-3%;
  border-right:1px solid #ffcc00;
  border-bottom:1px solid #ffcc00;
  background: #ffffff;
  transform:rotate(45deg);
  position:absolute;
}

.closeTop{
  top:4px;
  right:4px;
  position:absolute;
  cursor:pointer;
  z-index:1000000;
}

.closeSize{
  font-size:1rem !important;
}

.pointer{
  cursor: pointer
}

.hyperlink{
  color:blue;
}

#headerText{
  text-transform: uppercase;
  font-weight:700;
}
.buttons-excel{
  border: #d40511 !important;
}
.gpsGroup{
  width:72px;justify-content:space-between;border: 1px solid #dfdfdf;
  border-radius: 8px;
  padding: 8px;
  white-space: nowrap;
}
.tempGroup{
  width:164px;justify-content:space-between;border: 1px solid #dfdfdf;
  border-radius: 8px;
  padding: 8px;
  white-space: nowrap;
}
.tempR{
  align-items: baseline;
  justify-content: center;
}
.fa-tachometer-alt{
  padding:0px 0px 0px 32px;
}
.padBot
{
  padding-bottom: 16px;
}
.botText{
  font-weight:800;
  font-size:10px;
}
.cardSm{
  width:30%;
  height:60px;
  background:#ffffff;
  margin-right:16px;
}
.cardLarge{
  width:50%;
  height:60px;
  background:#ffffff;
  margin-right:16px;
}
.cardHuge{
  width:100%;
  height:60px;
  background:#ffffff;
  margin-right:16px;
}
.flexJustify{
  justify-content: space-between;
}
.setTwoBeg{
  margin-left:40px;
}
.setTwoEnd{
  margin-right:40px;
}
.height40{
   height:40px;
}
.bRight{
  border-right:1px solid #f0f0f0;
}
.bwid20{
  width:20%;
}
.bwid25{
  width:25%;
}
.bwid15{
  width:15%;
}
body, .bg{
  background: #FFFDF3 !important;
}
.regSpace{
  display: flex;flex-direction:row;justify-content:space-around;margin-bottom:10px;
}
.regSpaceTop{
  display: flex;flex-direction:row;justify-content:space-around;margin-bottom:10px;margin:0px;padding:0px;
}
.h60{
  height:60px;
}

.bottom{
  text-align: center;
}

.alignLeft{
  align-items: baseline;
  padding-left:24px;
}
.topFont{
  font-size:20px;
}
.bottomFont{
  font-size:16px;
}
.strong{
  font-weight:800;
}
.container-fluid{
  padding-right: 0px;
padding-left: 0px;
}
span{

}

.redFont{
  color:#d40511 !important;
}
.topRowHeader{
  font-size:16px;
}
</style>


<div class="center-viewInitial" id="loading-divInitial"  style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;">
</div>
<div class="center-view" id="loading-div" style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;">
</div>
<div class="topRowData dhlBackTop" id="slaDashboardHeader" style="display:flex;justify-content:space-between;align-items:center;margin-top:-24px;flex-direction:column;align-items:baseline;color:black;">
  <div style="font-weight:bold;font-size:16px;">BUSINESS DASHBOARD</div>
  <div style="font-weight:bold;font-size:12px;">Updated on <span id="updateDate"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span> at <span id="updateTime"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
</div>
<div class="topCardText">Today's Performance</div>
<div class="row">
  <div class="col-lg-4 flex" style="justify-content:space-between;padding-right:40px;">
      <div class="topRowHeader">Placements&nbsp;&nbsp;<i class="fas fa-clock"></i></div>
      <div class="bottomFont"><strong>Total: <span id="tpTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></strong></div>
  </div>
  <div class="col-lg-4 flex" style="padding-left: 48px !important;justify-content:space-between;padding-right:24px;">
    <div class="topRowHeader">Revenue Generated&nbsp;&nbsp;<span><i class="fas fa-euro-sign"></i></span></div>
    <div class="bottomFont"><strong>Total: <span id="trTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></strong></div>
  </div>
  <div class="col-lg-4 flex"  style="padding-left: 48px !important;justify-content:space-between;padding-right:24px;">
    <div class="topRowHeader">Trucks Available&nbsp;&nbsp;<img src="RegTruck.png" style="height:16px;margin-bottom:6px;"></div>
    <div class="bottomFont"><strong>Total: <span id="tTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></strong></div>

  </div>
</div>
<div class="row">
  <div class="col-lg-4 flex">
      <div class="card cardSm">
      <div class="flexCol h60 alignLeft">
        <div class="top">Dry</div>
        <div class="bottom"><span id="tpDry" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardSm">
      <div class="flexCol h60 alignLeft">
        <div class="top">TCL</div>
        <div class="bottom"><span id="tpTcl" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardSm">
      <div class="flexCol  h60 alignLeft">
        <div class="top">Blue Dart</div>
        <div class="bottom"><span id="tpBlueDart" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
  </div>
  <div class="col-lg-4 flex" style="padding-left: 48px !important;padding-right:0px;">
    <div class="card cardSm">
      <div class="flexCol  h60 alignLeft">
        <div class="top">Dry</div>
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="trDry" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardSm">
      <div class="flexCol h60 alignLeft">
        <div class="top">TCL</div>
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="trTcl" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardSm">
      <div class="flexCol h60 alignLeft">
        <div class="top">Blue Dart</div>
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="trBlueDart" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
  </div>
  <div class="col-lg-4 flex"  style="padding-left: 48px !important;padding-right:0px;">
    <div class="card cardLarge">
      <div class="flexCol h60 alignLeft">
        <div class="top">Not Assigned</div>
        <div class="bottom"><span id="tNotAssigned" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardLarge">
      <div class="flexCol h60 alignLeft">
        <div class="top">Dedicated</div>
        <div class="bottom"><span id="tDedicated" class="topFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>

  </div>
</div>
<div class="row" style="margin-top:16px;">
  <div class="col-lg-8 flex flexWidthCardDet">
    <div class="cardHuge height40 regSpaceTop" style="background:none;">
      <div class="bwid25 topCardText">
        Revenue - <span id="revenueMonth"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom">Yesterday</div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom">Target</div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom">Sales-MTD</div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom">Achieved</div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom">Projected</div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25 alignLeft">
        <div class="bottom">Dry</div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="ryDry"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rtDry"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsDry"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span id="raDry"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom" id="rpDryDiv"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpDry" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25  alignLeft">
        <div class="bottom">TCL</div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="ryTcl"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rtTcl"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsTcl"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span id="raTcl"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom" id="rpTclDiv"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpTcl" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25 alignLeft">
        <div class="bottom">Blue Dart</div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="ryBlueDart"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rtBlueDart"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsBlueDart"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span id="raBlueDart"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom" id="rpBlueDartDiv"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpBlueDart" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25 alignLeft">
        <div class="bottom">Total</div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="ryTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rtTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid15 bg">
        <div class="bottom"><span id="raTotal"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid15">
        <div class="bottom" id="rpTotalDiv"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpTotal" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="cardHuge height40 regSpaceTop" style="background:none;">
      <div class="bwid25" style="flex-direction:row;white-space: nowrap;">
        <i class="fas fa-info-circle"></i>&nbsp;&nbsp;All revenue values in thousands
      </div>
      <div class="flexCol bwid15">
      </div>
      <div class="flexCol bwid15">
      </div>
      <div class="flexCol bwid15">
      </div>
      <div class="flexCol bwid15">
      </div>
      <div class="flexCol bwid15">
      </div>
    </div>
  </div>
  <div class="col-lg-4 flex flexWidthCardDet" style="padding-right:20px !important;padding-left: 48px !important;">
    <div class="cardHuge height40 regSpaceTop" style="background:none;">
      <div class="flexCol bwid25 topCardText">
        <div class="bottom">Regions</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom">Sales-MTD</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom">Achieved</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom">Projected</div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25">
        <div class="bottom">East</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsEast"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span id="raEast"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpEast" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol  bwid25">
        <div class="bottom">West</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsWest"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span id="raWest"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpWest" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25">
        <div class="bottom">South</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsSouth"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span id="raSouth"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpSouth" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardHuge height40 regSpace">
      <div class="flexCol bwid25">
        <div class="bottom">North</div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rsNorth"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span id="raNorth"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span>&nbsp;<i class="fa fa-percent" aria-hidden="true"></i></div>
      </div>
      <div class="flexCol bwid25">
        <div class="bottom"><span ><i class="fas fa-euro-sign"></i>&nbsp;</span><span id="rpNorth" class="strong"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="cardHuge height40 regSpaceTop" style="background:none;">
      <div style="flex-direction:row;width:100%;justify-conten:flex-start">
        <i class="fas fa-info-circle"></i>&nbsp;&nbsp;Blue Dart is excluded from region revenue
      </div>
    </div>


  </div>
</div>
<div class="row">
  <div class="col-lg-4 flex">
    <div class="topCardText">Rotation</div>
  </div>
  <div class="col-lg-8 flex" style="padding: 0px 4px 0px 0px;">
    <div class="topCardText">Trucks in Maintenance</div>
  </div>
</div>
<div class="row">
  <div class="col-lg-4 flex">
    <div class="card cardHuge flex" style="flex-direction:row;justify-content:space-around;">
      <div class="flexCol bRight bwid20">
        <div class="top">Total</div>
        <div class="bottom"><strong><span id="rTotal" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></strong></div>
      </div>
      <div class="flexCol bRight bwid20 bg">
        <div class="top">East</div>
        <div class="bottom"><span id="rEast" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid20">
        <div class="top">West</div>
        <div class="bottom"><span id="rWest" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bRight bwid20 bg">
        <div class="top">South</div>
        <div class="bottom"><span id="rSouth" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid20">
        <div class="top">North</div>
        <div class="bottom"><span id="rNorth" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
  </div>
  <div class="col-lg-8 flex" style="padding: 0px 4px 0px 0px;">
    <div class="card cardLarge"  style="flex-direction:row;justify-content:space-around;">
      <div class="flexCol bwid25">
        <div class="top">DRY</div>
        <div class="bottom"><strong><span id="tmDry" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></strong></div>
      </div>
      <div class="flexCol bwid25">
        <div class="top">24 ft. SXL</div>
        <div class="bottom"><span id="tm24SXL" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="top">32 ft. MXL</div>
        <div class="bottom"><span id="tm32MXL" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="top">32 ft. SXL</div>
        <div class="bottom"><span id="tm32SXL" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
    <div class="card cardLarge"  style="flex-direction:row;justify-content:space-around;">
      <div class="flexCol bwid25">
        <div class="top">TCL</div>
        <div class="bottom"><strong><span id="tmTcl" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></strong></div>
      </div>
      <div class="flexCol bwid25">
        <div class="top">20 ft. SXL</div>
        <div class="bottom"><span id="tm20SXL" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="top">24 ft. MXL</div>
        <div class="bottom"><span id="tm24MXL" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
      <div class="flexCol bwid25">
        <div class="top">32 ft. MXL</div>
        <div class="bottom"><span id="tm32SXLTCL" class="bottomFont"  ><i class="fas fa-spinner fa-spin spinnerColor"></i></span></div>
      </div>
    </div>
  </div>
</div>
<div class="row topRowData" style="margin-bottom:16px;margin-top:32px;display:none;" id="tripDetailsDiv">
         <div class="col-lg-12"><strong>VEHICLE DETAILS</strong><span id="headerText"></span></div>
         </div>
         <div class="row" id="midColumn" style="width: 100%;padding:0px;margin-left:0px;display:none;">
           <div class="col-lg-12" style="padding:0px;">
            <div id="tableDiv" class="tableDiv">

               <table id="tripSumaryTable" class="table table-striped table-bordered" cellspacing="0" style="width:100%;z-index:1">
                  <thead style="background:#37474F;color:white;">
                     <tr>
                        <th>Sl No</th>
                        <th>Trip No</th>
                        <th>Vehicle No</th>
                        <th>Vehicle Category</th>
                        <th>Vehicle Type</th>
                        <th>Moving Status</th>
                        <th>Communication Status</th>
                        <th>Current Location</th>
                        <th>Customer Name</th>
                     </tr>
                  </thead>
               </table>
            </div>
          </div>
         </div>

<script>
//history.pushState({ foo: 'fake' }, 'Fake Url', 'BusinessDashboard#');
var table;
function loadTable(element){



  //Use this ID as parameter for your ajax call... Then it will be very easy
  alert($(element).attr("id"));

  let result = {"List":[{"movingStatus":"Halted","driver1Contact":"","driver2":"","driver1":"","routeId":"STN_CCU_302_001_STN_BAH_101_001_STN_RPR_001_001_SH_NAG_023_001_STN_BHI_302_001_3600-HR55AC0792-30112019123135","vehicleNumber":"HR55AC0792","driver2Contact":"","currentLocation":"1 kms from Jyothi Hospital, Kuruda,Balasore,Odisha,756056, Korkora, OD, India","tripNo":"8100028001","distance":220,"unassignedTime":"00:04:48","commStatus":"COMMUNICATING","tamperCount":0},{"movingStatus":"Halted","driver1Contact":"9451803236","driver2":"Om Kumar","driver1":"ASHOK KUMAR","routeId":"BDE_LKO_012_001_SH_NAG_023_001_BDE_MAA_077_001_3660-HR55AC0820-28112019190137","vehicleNumber":"HR55AC0820","driver2Contact":"9559662244","currentLocation":"Near to SVC_HYD_336_001,Hyderabad,Telangana,IN","tripNo":"8100027911","distance":1373,"unassignedTime":"01:10:48","commStatus":"COMMUNICATING","tamperCount":0}]}
  result = result.List;

  rows = [];
  $.each(result, function (i, item) {
    let row = [];
      row.push(i+1);
      row.push(item.tripNo != null ? '<span style="cursor:pointer;color:blue;" onClick="showCEDashboard(\'' + item.tripId + '\')">' + item.tripNo + '</span>' : "");
      row.push(item.vehicleNumber != null? item.vehicleNumber : "");
      row.push(item.currentODORoute != null? item.currentODORoute : "");
      row.push(item.vehicleCategory != null? item.vehicleCategory : "");
      row.push(item.vehicleType != null? item.vehicleType : "");
      let movStatus = item.movingStatus != null? item.movingStatus : "";
       movStatus = movStatus === "Moved" ? "Moving": movStatus;
       row.push(movStatus);
      row.push(item.commStatus != null? item.commStatus : "");
      row.push(item.currentLocation != null? item.currentLocation : "");
      row.push(item.customerName != null? item.customerName : "");
      rows.push(row);
    });
    if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
      $('#tripSumaryTable').DataTable().clear();
    }

   table.rows.add(rows).draw();
}


 //let t4uspringappURL =  "https://track-staging.dhlsmartrucking.com/t4uspringapp/";
  //let t4uspringappURL =  "http://localhost:8089/t4uspringapp/";
let t4uspringappURL = "<%=t4uspringappURL%>";
 


$(document).ready(function(){

  Date.prototype.toShortFormat = function() {
    var month_names =["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    var day = this.getDate();
    var month_index = this.getMonth();
    var year = this.getFullYear();
    return "" + day + "-" + month_names[month_index] + "-" + year;
}
	var today = new Date();
	$("#updateDate").html(today.toShortFormat());
	$("#updateTime").html(today.toLocaleString('en-US', { hour: 'numeric', minute: 'numeric',  hour12: true }));


	const monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
	const d = new Date();
	$("#revenueMonth").html(monthNames[d.getMonth()]);

  $.ajax({
      type: 'GET',
      url: t4uspringappURL + 'getMaintenanceData',
      datatype: 'json',
      contentType: "application/json",
      success: function(response) {
        $("#tmDry").html("0");
        $("#tm24SXL").html("0");
        $("#tm32MXL").html("0");
        $("#tm32SXL").html("0");
        $("#tmTcl").html("0");
        $("#tm20SXL").html("0");
        $("#tm24MXL").html("0");
        $("#tm32SXLTCL").html("0");
		let countDry = 0;
		let countTcl = 0;
        response.responseBody.forEach(function(item){
          if(item.tripType === "Dry")
          {
            countDry++;

              $("#tmDry").html(parseInt($("#tmDry").html())+1);
              item.vehicleType === "24ft SXL DC"? $("#tm24SXL").html(parseInt($("#tm24SXL").html())+1):"";
              item.vehicleType === "32ft MXL DC"?$("#tm32MXL").html(parseInt($("#tm32MXL").html())+1):"";
              item.vehicleType === "32ft SXL DC"?$("#tm32SXL").html(parseInt($("#tm32SXL").html())+1):"";
          }
          else
          {
            countTcl++;
            $("#tmTcl").html(parseInt($("#tmTcl").html())+1);
            item.vehicleType === "20ft SXL TCL"?$("#tm20SXL").html(parseInt($("#tm20SXL").html())+1):"";
            item.vehicleType === "24ft MXL TCL"?$("#tm24MXL").html(parseInt($("#tm24MXL").html())+1):"";
            item.vehicleType === "32ft MXL TCL"?$("#tm32SXLTCL").html(parseInt($("#tm32SXLTCL").html())+1):"";
          }
        });
      }
  });

$.ajax({
      type: 'GET',
      url: t4uspringappURL + 'getAssignedData',
      datatype: 'json',
      contentType: "application/json",
      success: function(response) {
		$("#tpDry").html(response.responseBody.dry);
		$("#tpTcl").html(response.responseBody.tcl);
		$("#tpBlueDart").html(response.responseBody.blueDart);
		$("#tpTotal").html(response.responseBody.dry + response.responseBody.tcl + response.responseBody.blueDart);
		$("#trDry").html((response.responseBody.rDry).toFixed(2));
		$("#trTcl").html((response.responseBody.rTcl).toFixed(2));
		$("#trBlueDart").html((response.responseBody.rBlueDart).toFixed(2));
		$("#trTotal").html((response.responseBody.rDry + response.responseBody.rTcl + response.responseBody.rBlueDart).toFixed(2));
	  }
  });

$.ajax({
      type: 'GET',
      url: t4uspringappURL + 'getUnassignedNAData',
      datatype: 'json',
      contentType: "application/json",
      success: function(response) {
		$("#tNotAssigned").html(response.responseBody.length);
		$.ajax({
      type: 'GET',
      url: t4uspringappURL + 'getUnassignedDedicatedData',
      datatype: 'json',
      contentType: "application/json",
      success: function(response) {
		$("#tDedicated").html(response.responseBody.length);
		$("#tTotal").html(parseInt($("#tNotAssigned").html()) + parseInt($("#tDedicated").html()) );
	  }
  });
	  }
  });


$.ajax({
      type: 'GET',
      url: t4uspringappURL + 'getRevenueData',
      datatype: 'json',
      contentType: "application/json",
      success: function(response) {
    		$("#ryDry").html(response.responseBody.dryYesterday);
    		$("#rtDry").html(response.responseBody.dryTarget);
    		$("#rsDry").html(response.responseBody.drySales);
    		$("#raDry").html(response.responseBody.dryAchieved);
    		$("#rpDry").html(response.responseBody.dryProjected);
    		$("#ryTcl").html(response.responseBody.tclYesterday);
    		$("#rtTcl").html(response.responseBody.tclTarget);
    		$("#rsTcl").html(response.responseBody.tclSales);
    		$("#raTcl").html(response.responseBody.tclAchieved);
    		$("#rpTcl").html(response.responseBody.tclProjected);
    		$("#ryBlueDart").html(response.responseBody.bdeYesterday);
    		$("#rtBlueDart").html(response.responseBody.bdeTarget);
    		$("#rsBlueDart").html(response.responseBody.bdeSales);
    		$("#raBlueDart").html(response.responseBody.bdeAchieved);
    		$("#rpBlueDart").html(response.responseBody.bdeProjected);
    		$("#ryTotal").html(response.responseBody.totalYesterday);
    		$("#rtTotal").html(response.responseBody.totalTarget);
    		$("#rsTotal").html(response.responseBody.totalSales);
    		$("#raTotal").html(response.responseBody.totalAchieved);
    		$("#rpTotal").html(response.responseBody.totalProjected);
    		$("#rsEast").html(response.responseBody.eastSales);
    		$("#raEast").html(response.responseBody.eastAchieved);
    		$("#rpEast").html(response.responseBody.eastProjected);
    		$("#rsWest").html(response.responseBody.westSales);
    		$("#raWest").html(response.responseBody.westAchieved);
    		$("#rpWest").html(response.responseBody.westProjected);
    		$("#rsSouth").html(response.responseBody.southSales);
    		$("#raSouth").html(response.responseBody.southAchieved);
    		$("#rpSouth").html(response.responseBody.southProjected);
    		$("#rsNorth").html(response.responseBody.northSales);
    		$("#raNorth").html(response.responseBody.northAchieved);
    		$("#rpNorth").html(response.responseBody.northProjected);
        $("#rpDryDiv").removeClass("redFont");
        $("#rpTclDiv").removeClass("redFont");
        $("#rpBlueDartDiv").removeClass("redFont");
        $("#rpTotalDiv").removeClass("redFont");
        parseFloat(response.responseBody.dryProjected) < parseFloat(response.responseBody.dryTarget)  ? $("#rpDryDiv").addClass("redFont"):"";
        parseFloat(response.responseBody.tclProjected) < parseFloat(response.responseBody.tclTarget)  ?$("#rpTclDiv").addClass("redFont"):"";
        parseFloat(response.responseBody.bdeProjected) < parseFloat(response.responseBody.bdeTarget)  ?$("#rpBlueDartDiv").addClass("redFont"):"";
        parseFloat(response.responseBody.totalProjected) < parseFloat(response.responseBody.totalTarget)  ?$("#rpTotalDiv").addClass("redFont"):"";
	  }
  });




  $("#rTotal").html("-");
  $("#rEast").html("-");
  $("#rWest").html("-");
  $("#rNorth").html("-");
  $("#rSouth").html("-");






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
})
</script>
<jsp:include page="../Common/footer.jsp" />
