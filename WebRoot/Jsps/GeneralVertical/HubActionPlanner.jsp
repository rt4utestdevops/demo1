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
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
    integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
  <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" type="text/css" />
  <link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css" type="text/css" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css"
    type="text/css" />
  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css" rel="stylesheet" />
  <link href="https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css" rel="stylesheet">
  <script
    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
  <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
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
  <link href="https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/master/leaflet.css" rel="stylesheet"
    type="text/css" />
  <script src="https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/master/leaflet.js"></script>
  <script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
  <script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css" />
  <script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>
  <script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
  <!-- <script src="../../Main/leaflet/initializeleaflet.js"></script> -->
  <style>
    body {
      overflow-x: hidden;
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

    table thead th {
      white-space: nowrap;
      color: #d40511 !important;
      background-color: #ffcc00 !important;
    }

    table thead {
      color: #d40511 !important;
      background-color: #ffcc00 !important;
      padding-top: 4px;
      padding-bottom: 4px;
      padding-left: 16px;
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
      border-color: #ffcc00;
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
      z-index: 0;
      position: relative;
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
      background: linear-gradient(to right, #ffffff, #ece9e6) !important;
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
      background: linear-gradient(to right, #3bb78f 0%, #28A745 74%) !important;
    }

    .orange-gradient-rgba {
      background: linear-gradient(to right, #FFCC00, rgb(241, 39, 17)) !important;
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
      border-radius: 4px;
      font-size: 12px;
      font-weight: 700;
      display: flex;
      justify-content: space-between;
      padding: 0px 12px 0px 10px;
      align-items: center;
    }

    .midCardHeading {
      height: 32px;
      align-items: center;
      justify-content: center;
      width: 100%;
      text-transform: uppercase;
      margin-left: -4px;
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

    .flexCol {
      display: flex;
      flex-direction: column;
    }

    .marg8 {
      margin-left: -8px;
    }

    li:hover {
      border: none;
    }

    li {
      min-height: 32px;
      max-height: 32px;
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

    .topRowData {
      margin-bottom: 24px;
      color: #d40511;
      text-align: center;
      background: #ffcc00;
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
      margin-top: 48px;
      margin-bottom: 48px;
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

    body {
      font-size: 12px !important;
      background: white !important;
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
      border-radius: 8px !important;
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
      width: 100%;
      padding: 0px;
      margin: 0px;
      border-top: 1px solid #888888 !important
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
      padding: 0px 8px 0px 2px;
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
      height: 36px;
      display: flex;
      align-items: center;
      text-align: left;
      white-space: nowrap;
      text-transform: uppercase;
      padding-top: 8px;
    }

    .rightTextHead {
      font-weight: 600 !important;
      font-size: 14px !important;
      height: 40px;
      display: flex;
      align-items: center;
      text-align: left;
      white-space: nowrap;
      text-transform: uppercase;
    }

    .leftText {
      background: none !important;
      font-size: 25px !important;
      height: 36px !important;
      width: 56px !important;
      margin-top: 4px;
      cursor: pointer;
    }

    .leftTextHead {
      background: none !important;
      font-size: 24px !important;
      /*  height:50px !important;*/
      width: 34px !important;
      cursor: pointer;
      text-align: right;
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
      padding-left: 4px;
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

    #circle1 {
      margin: auto !important;
      width: 630px;
      height: 630px;
      position: absolute !important;
      top: 16px;
    }

    .outer-2 {
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
      left: 10px;
      opacity: 0.6;
    }

    .outer-1 {
      width: 530px;
      height: 530px;
      position: absolute;
      border-radius: 50%;
      top: 50px;
      background: none;
      pointer-events: none;
      z-index: 0;
      left: 60px;
      transition: width 2s, height 4s;
    }

    .outer-1UpperLayer {
      width: 530px;
      height: 530px;
      position: absolute;
      border-radius: 50%;
      top: 50px;
      background: none;
      pointer-events: none;
      z-index: 10;
      left: 60px;
      transition: width 2s, height 4s;
    }

    .outerReg {
      width: 100%;
      height: 100%;
      position: absolute;
      border: 3px solid #ffcc00;
      border-radius: 50%;
      top: 0px;
      background: none;
      pointer-events: none;
      z-index: 0;
    }

    .outerLarge {
      width: 110%;
      height: 110%;
      position: absolute;
      border: 3px solid #ffcc00;
      border-radius: 50%;
      top: -24px;
      background: none;
      pointer-events: none;
      z-index: 0;
      left: -24px;
    }

    .outerSmall {
      width: 24%;
      height: 24%;
      position: absolute;
      border: 2px solid #ffcc00;
      border-radius: 50%;
      background: none;
      pointer-events: none;
      z-index: 0;
      left: 38%;
      top: 38%;
    }

    .inner-1 {
      top: 10%;
      left: 10%;
      width: 80%;
      height: 80%;
      position: absolute;
      pointer-events: none;
      z-index: 0;
    }

    .inner-1Large {
      top: -20px;
      left: -20px;
      width: 108%;
      height: 108%;
      position: absolute;
      border-radius: 50%;
      pointer-events: none;
      z-index: 0;
    }

    .inner-1Small {
      top: 40%;
      left: 40%;
      width: 20%;
      height: 20%;
      position: absolute;
      border-radius: 50%;
      pointer-events: none;
      z-index: 0;
    }

    .inner-2 {
      top: 30%;
      left: 30%;
      width: 40%;
      height: 40%;
      position: absolute;
      pointer-events: none;
      z-index: -1;
    }

    .inner-2Small {
      top: 42%;
      left: 42%;
      width: 16%;
      height: 16%;
      position: absolute;
      border-radius: 50%;
      pointer-events: none;
      z-index: -1;
    }

    .inner-2Large {
      top: 14px;
      left: 14px;
      width: 96%;
      height: 96%;
      position: absolute;
      pointer-events: none;
      z-index: -1;
      font-size: 12px;
    }

    .inner-3 {
      top: 45%;
      left: 45%;
      width: 10%;
      height: 10%;
      position: absolute;
      pointer-events: none;
      z-index: -1;
    }

    .width100 {
      width: 100%;
    }

    svg {
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

    .solid {
      stroke-dasharray: none;
    }

    .dashed {
      stroke-dasharray: 8, 8.5;
    }

    .dotted {
      stroke-dasharray: 0.1, 3.5;
      stroke-linecap: round;
    }

    .tooltipQ {}

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
      word-break: break-word;
    }

    .toolTipDivLast {
      margin: 2px 8px;
      text-align: left;
      display: flex;
      width: 100%;
      justify-content: left;
    }

    .topCardText {
      margin-left: 12px;
    }

    .toolOuter {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter1Hourincoming,
    .toolOuter1Houroutgoing {
      position: absolute;
      left: 35%;
      top: 35%;
      width: 30%;
      height: 30%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter2Hourincoming,
    .toolOuter2Houroutgoing {
      position: absolute;
      left: 27%;
      top: 28%;
      width: 45%;
      height: 45%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter3Hourincoming,
    .toolOuter3Houroutgoing {
      position: absolute;
      left: 16%;
      top: 16%;
      width: 68%;
      height: 68%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter4Hourincoming,
    .toolOuter4Houroutgoing {
      position: absolute;
      left: 4%;
      top: 4%;
      width: 92%;
      height: 92%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter4to6Hourincoming,
    .toolOuter4to6Houroutgoing {
      position: absolute;
      left: -40px;
      top: -40px;
      width: 116%;
      height: 116%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter6to8Hourincoming,
    .toolOuter6to8Houroutgoing {
      position: absolute;
      left: -60px;
      top: -60px;
      width: 125%;
      height: 125%;
      pointer-events: none;
      z-index: 1;
    }

    .toolOuter8Plusincoming,
    .toolOuter8Plusoutgoing {
      position: absolute;
      left: -100px;
      top: -100px;
      width: 148%;
      height: 148%;
      pointer-events: none;
      z-index: 1;
    }

    .truckImage {
      left: 50%;
      position: absolute;
      pointer-events: all;
      z-index: 1;
      height: 41px;
      width: 14px;
    }

    .inHub {
      position: absolute;
      top: 46%;
      left: 45.5%;
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
      padding: 16px 0px 16px 8px;
      justify-content: space-between;
      align-items: center;
    }

    .select2-results ul li {
      white-space: nowrap;
    }

    .center-viewLoading1 {
      top: 30%;
      left: 40%;
      position: fixed;
      height: 200px;
      z-index: -1;
    }

    .mapPopUpComponent {
      width: 250px;
      height: 250px;
      background: white;
      opacity: 1
    }

    .leaflet-popup-content {
      width: 500px !important;
      padding-bottom: 24px;
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
      font-size: 1.3rem !important;
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

    .buttons-excel {
      border: #d40511 !important;
    }

    .gpsGroup {
      width: 84px;
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
    }

    .fa-tachometer-alt {
      padding: 0px 0px 0px 32px;
    }

    .padBot {
      padding-bottom: 16px;
    }

    .botText {
      font-weight: 800;
      font-size: 10px;
    }

    .leaflet-container a.leaflet-popup-close-button {
      top: 4px !important;
      right: 16px !important;
      font-size: 32px !important;
      color: #000000;
    }

    .leaflet-left {
      right: 16px !important;
      left: auto !Important;
      top: 120px !important;
    }

    .toolTipStyle {
      height: 200px !important;
      overflow-y: auto;
      overflow-x: hidden;
      margin-right: -16px;
    }

    .cardStyle {
      position: absolute;
      z-index: 100;
      right: 4px;
      top: 240px;
      padding: 0px 10px 8px 0px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      background: #333333;
      color: white;
    }

    .expandArrow {
      align-items: center;
      display: flex;
      margin-right: 8px;
      font-size: 1.5em !important;
      cursor: pointer;
    }
  </style>
  <div class="center-viewInitial" id="loading-divInitial" style="display:none;">
    <img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;">
  </div>
  <div id="loading" class="center-viewLoading1" style="/* display: none; */">
    <img id="loading-image" src="load.png" style="width:250px;" alt="Loading...">
    <div style="width:100%;text-align:center;padding-top:16px;"> PLEASE SELECT A HUB...
    </div>
  </div>
  <div class="center-view" id="loading-div" style="display:none;">
    <img src="../../Main/images/loading.gif" alt="" style="position:absolute;">
  </div>
  <div class="topRowData dhlBackTop" id="slaDashboardHeader"
    style="display:flex;justify-content:space-between;align-items:center;margin-top:-16px;">
    <div style="font-weight:bold;font-size:16px;">HUB ACTION PLANNER</div>
    <div style="width: 62%;display:flex;justify-content:space-between;">
      <div style="display:flex;flex-direction:column;"><strong
          style="font-size:11px;text-align:left;color:#d40511;font-weight:700;">SELECT A HUB:</strong>
        <select id="hubWise" style="width:300px;text-align:left;">
        </select></div>
      <i class="fas  fa-2x fa-sync" id="refIcon" title="Refresh Hub Data"
        style="cursor:pointer;padding-top:10px;display:none;" onclick="refresh()"></i>
    </div>
  </div>
  <div id="tripDetDiv" style="display:none;">
    <div class="row" id="columnContainer" style="margin-top:-16px;">
      <div class="col-lg-2">
        <div class="card" id="divIncoming">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop" id="incomingTotal"
                onclick="toggleCard('divIncoming',this);showHideIncomingOutgoing('incoming',0);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightTextHead topCardText" title="" class="red">INCOMING</div>
            </div>
            <div class="expandArrow" style="display:none"
              onclick="toggleCard('divIncoming',this);showHideIncomingOutgoing('incoming',0);"><i
                class="fas fa-chevron-down"></i></div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex flexRow">
              <div class="leftText" id="incomingLessThan2Hours"
                onclick="selected(this);showHideIncomingOutgoing('incoming',2);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2
                hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incoming2To4Hours"
                onclick="selected(this);showHideIncomingOutgoing('incoming',4);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">2 to 4 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incoming4To8Hours"
                onclick="selected(this);showHideIncomingOutgoing('incoming',6);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">4 to 8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incoming8Plus" onclick="selected(this);showHideIncomingOutgoing('incoming',8);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i
                  class="fas fa-greater-than"></i>&nbsp;8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingAtUnLoading"
                onclick="selected(this);showHideIncomingOutgoing('incoming','atunloading');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">At UnLoading</div>
            </div>
          </div>
        </div>
        <div class="card" id="divOutgoing">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop" id="outgoingTotal"
                onclick="toggleCard('divOutgoing',this);showHideIncomingOutgoing('outgoing',0);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightTextHead topCardText" title="" class="red">OUTGOING</div>
            </div>
            <div class="expandArrow" onclick="toggleCard('divOutgoing',this);showHideIncomingOutgoing('outgoing',0);"><i
                class="fas fa-chevron-down"></i></div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingLessThan2Hours"
                onclick="selected(this);showHideIncomingOutgoing('outgoing',2);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2
                hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoing2To4Hours"
                onclick="selected(this);showHideIncomingOutgoing('outgoing',4);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">2 to 4 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoing4To8Hours"
                onclick="selected(this);showHideIncomingOutgoing('outgoing',6);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">4 to 8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoing8Plus" onclick="selected(this);showHideIncomingOutgoing('outgoing',8);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i
                  class="fas fa-greater-than"></i>&nbsp;8 HOURS</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingAtLoading"
                onclick="selected(this);showHideIncomingOutgoing('outgoing','atloading');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">At Loading</div>
            </div>
          </div>
        </div>
        <div class="card" id="divUnloadingDetention" style="height:42px;">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop" id="incomingUnLoadingDetention"
                onclick="toggleCard('divUnloadingDetention',this);showHideIncomingOutgoing('incoming','unloading');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightTextHead topCardText" title="" class="red">UNLOADING DET.</div>
            </div>
            <div class="expandArrow"
              onclick="toggleCard('divUnloadingDetention',this);showHideIncomingOutgoing('incoming','unloading');"><i
                class="fas fa-chevron-down"></i></div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex flexRow">
              <div class="leftText" id="uldLessThan2Hours" onclick="selected(this);showHideIncomingOutgoing('uld',2);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2
                hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="uld2To4Hours" onclick="selected(this);showHideIncomingOutgoing('uld',4);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">2 to 4 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="uld4To8Hours" onclick="selected(this);showHideIncomingOutgoing('uld',6);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">4 to 8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="uld8Plus" onclick="selected(this);showHideIncomingOutgoing('uld',8);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i
                  class="fas fa-greater-than"></i>&nbsp;8 hours</div>
            </div>
          </div>
        </div>
        <div class="card" id='divLoadingDetention' style="height:42px;">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop" id="outgoingLoadingDetention"
                onclick="toggleCard('divLoadingDetention',this);showHideIncomingOutgoing('outgoing','loading');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightTextHead topCardText" title="" class="red">LOADING DET.</div>
            </div>
            <div class="expandArrow"
              onclick="toggleCard('divLoadingDetention',this);showHideIncomingOutgoing('outgoing','loading');"><i
                class="fas fa-chevron-down"></i></div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ldLessThan2Hours" onclick="selected(this);showHideIncomingOutgoing('ld',2);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2
                hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ld2To4Hours" onclick="selected(this);showHideIncomingOutgoing('ld',4);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">2 to 4 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ld4To8Hours" onclick="selected(this);showHideIncomingOutgoing('ld',6);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">4 to 8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ld8Plus" onclick="selected(this);showHideIncomingOutgoing('ld',8);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i
                  class="fas fa-greater-than"></i>&nbsp;8 HOURS</div>
            </div>
          </div>
        </div>
        <div class="card" id="divDelayedIndents" style="height:42px;">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop" id="outgoingDelayedIndents"
                onclick="toggleCard('divDelayedIndents',this);showHideIncomingOutgoing('','DELAYEDINDENTS');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightTextHead topCardText" title="" class="red">UPCOMING INDENTS</div>
            </div>
            <div class="expandArrow"
              onclick="toggleCard('divDelayedIndents',this);showHideIncomingOutgoing('','DELAYEDINDENTS');"><i
                class="fas fa-chevron-down"></i>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex flexRow">
              <div class="leftText" id="diLessThan2Hours" onclick="selected(this);showHideIncomingOutgoing('di',2);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2
                hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="di2To4Hours" onclick="selected(this);showHideIncomingOutgoing('di',4);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">2 to 4 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="di4To8Hours" onclick="selected(this);showHideIncomingOutgoing('di',6);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">4 to 8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="di8Plus" onclick="selected(this);showHideIncomingOutgoing('di',8);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i
                  class="fas fa-greater-than"></i>&nbsp;8 hours</div>
            </div>
          </div>
        </div>
        <!-- <div class="card" id="divUpcomingIndents">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop" id="outgoingUpcomingIndents"
                onclick="selected(this);showHideIncomingOutgoing('','UPCOMINGINDENTS');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightTextHead topCardText" title="" class="red">UPCOMING INDENTS</div>
              <div class="expandArrow"><i class="fas fa-chevron-down"></i></div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex flexRow">
              <div class="leftText" id="uiLessThan2Hours" onclick="selected(this);showHideIncomingOutgoing('ui',2);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i class="fas fa-less-than"></i>&nbsp;2
                hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ui2To4Hours" onclick="selected(this);showHideIncomingOutgoing('ui',4);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">2 to 4 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ui4To8Hours" onclick="selected(this);showHideIncomingOutgoing('ui',6);"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">4 to 8 hours</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="ui8Plus" onclick="selected(this);showHideIncomingOutgoing('ui',8);">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red"><i
                  class="fas fa-greater-than"></i>&nbsp;8 hours</div>
            </div>
          </div>
        </div> -->
      </div>
      <div class="col-lg-8" id="leftColumn" style="padding:0px;display:flex;justify-content:center;">
        <div style="position:absolute;z-index:100;right:4px;top:60px;display:none;cursor:pointer;" id="circleIcon"
          onclick="toggleMapCircle()"><img src="cicon.png" style="width:48px;" /></div>
        <div style="position:absolute;z-index:100;right:12px;top:60px;color:#d40511;cursor:pointer;" id="mapIcon"
          onclick="toggleMapCircle()"><i class="fas fa-3x fa-map-marked-alt"></i></div>
        <!-- <div class="card cardStyle">
      <div style="text-align:left;"><input checked type="radio" name="radio1" id="radioAll" />ALL</div>
    <div><input type="radio" name="radio1" id="radio0To2" />0-2 HRS</div>
    <div><input type="radio" name="radio1" id="radio2To4" />2-4 HRS</div>
    <div><input type="radio" name="radio1" id="radio4To8" />4-8 HRS</div>
    <div><input type="radio" name="radio1" id="radio8Plus" />> 8 HRS</div>
  </div> -->
        <div class="abs mapBackground" style="z-index:-1;border-radius:4px;" id="map">Map</div>
        <div id="circle1">
          <div class="outer-2" id="outer2">
            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
              <title>Hours</title>
              <defs>
                <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z"
                  id="starbuckscircleTop1" transform="rotate(-10  -84 80)" />
              </defs>
              <text font-size="4.5" fill="#d40511" font-weight="bold">
                <textPath xlink:href="#starbuckscircleTop1">> 8 HOURS</textPath>
              </text>
            </svg>
          </div>
          <div class="outer-1">
            <div class="outerReg" id="outer1">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
                <title>Hours</title>
                <defs>
                  <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z"
                    id="starbuckscircleTop" transform="rotate(-12  -55 80)" />
                </defs>
                <text font-size="4.5" fill="#d40511" font-weight="bold">
                  <textPath xlink:href="#starbuckscircleTop">4 TO 8 HOURS</textPath>
                </text>
              </svg>
            </div>
          </div>
          <div class="outer-1">
            <div class="inner-1" id="inner1">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
                <title>Hours</title>
                <defs>
                  <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z"
                    id="starbuckscircle" transform="rotate(-16 12 80)" />
                </defs>
                <circle fill="none" stroke="#ffcc00" cx="100" cy="100" r="93.8" stroke-width="1" id="rim" />
                <text font-size="6" fill="#d40511" font-weight="bold">
                  <textPath xlink:href="#starbuckscircle">2 TO 4 HOURS</textPath>
                </text>
              </svg>
            </div>
            <div class="inner-2" id="inner2">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
                <title>Hours</title>
                <defs>
                  <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z"
                    id="starbuckscircle24" transform="rotate(-35 68 90)" />
                </defs>
                <circle fill="none" stroke="#ffcc00" cx="100" cy="100" r="93.8" stroke-width="1" id="rim1" />
                <text font-size="12" fill="#d40511" font-weight="bold">
                  <textPath xlink:href="#starbuckscircle24">0 TO 2 HOURS</textPath>
                </text>
              </svg>
            </div>
            <div class="inner-3" id="inner3">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 200">
                <title>Hours</title>
                <defs>
                  <path d="M100,37c34.8,0,63,28.2,63,63s-28.2,63-63,63s-63-28.2-63-63S65.2,37,100,37z"
                    id="starbuckscircle" transform="rotate(-28 100 100)" />
                </defs>
                <circle cx="100" cy="100" r="100" fill="#d40511" id="background" />
                <circle fill="none" stroke="#ccff00" cx="100" cy="100" r="93.8" stroke-width="3" id="rim2" />
              </svg>
            </div>
          </div>
          <div class="outer-1UpperLayer">
            <div class="inner-1">
              <div class="inHub">
                <div class="inHubFlex" id="inHubVehicles" title="Inside Hub" onclick="loadInHub()"><i
                    class="fas fa-spinner fa-spin spinnerColor" style="margin-top:6px;"></i>
                </div>
              </div>
              <div id="vehicles">
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-2">
        <div class="card">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop"></div>
              <div data-toggle="tooltip" style="margin-left:-16px;" class="rightTextHead topCardText" title=""
                class="red">ALERTS</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="shDetention"
                onclick="selected(this);showHideIncomingOutgoing('','SHDETENTION');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">SH Detention</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingSHMissed"
                onclick="selected(this);showHideIncomingOutgoing('alerts','TPMISSED');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">TouchPoint Missed</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingRouteDeviation"
                onclick="selected(this);showHideIncomingOutgoing('alerts','ROUTEDEVIATION');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Route Deviation</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingUnplannedStoppage"
                onclick="selected(this);showHideIncomingOutgoing('alerts','STOPPAGE');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Stoppage/Idling</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingTempDeviation"
                onclick="selected(this);showHideIncomingOutgoing('alerts','TEMPDEVIATION');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Temp. Deviation</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingLowAvgSpeed"
                onclick="selected(this);showHideIncomingOutgoing('alerts','LOWAVGSPEED');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Low Avg. speed </div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="incomingPanic"
                onclick="selected(this);showHideIncomingOutgoing('alerts','PANIC');">0</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Panic</div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="cardHeading blue-gradient-rgba">
            <div class="flex">
              <div class="leftTextHead leftTop"></div>
              <div data-toggle="tooltip" style="margin-left:-16px;" class="rightTextHead topCardText" title=""
                class="red">HUB ACTION PLAN</div>
            </div>
          </div>
          <!-- <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingUpcomingIndents"
                onclick="selected(this);showHideIncomingOutgoing('','UPCOMINGINDENTS');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Upcoming Indents</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingDelayedIndents"
                onclick="selected(this);showHideIncomingOutgoing('','DELAYEDINDENTS');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Delayed Indents</div>
            </div>
          </div> -->
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="odo" onclick="selected(this);showHideIncomingOutgoing('','ODO');scrollToDataTable();"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">ODO Non-Compliance</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingFixGPS" onclick="selected(this);showHideIncomingOutgoing('','GPS');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Fix GPS</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingFixTemp" onclick="selected(this);showHideIncomingOutgoing('','TEMP');">
                <i class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Fix Temp sensor</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftText" id="outgoingTopUpFuel"
                onclick="selected(this);showHideIncomingOutgoing('','FUEL');"><i
                  class="fas fa-spinner fa-spin spinnerColor"></i></div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Top-up fuel</div>
            </div>
          </div>
          <div class="card cardOtherDet">
            <div class="flex">
              <div class="leftTextNA" id="outgoingTyrePressure" onclick="selected(this);">NA</div>
              <div data-toggle="tooltip" class="rightText" title="" class="red">Tyre Pressure</div>
            </div>
          </div>
        </div>
        <div class="card cardOtherDet">
          <div class="flex">
            <div class="leftTextNA" id="outgoingCheckEngine" onclick="selected(this);">NA</div>
            <div data-toggle="tooltip" class="rightText" title="" class="red">Check Engine</div>
          </div>
        </div>
        <!-- <div class="card cardOtherDet">
      <div class="flex"><div class="leftText" id="outgoingDelayed" onclick="selected(this);showHideIncomingOutgoing('','DELAYED');"><i class="fas fa-spinner fa-spin spinnerColor"></i></div>
      <div data-toggle="tooltip" class="rightText" title=""  class="red">Delayed</div></div>
   </div> -->
      </div>
    </div>
    <div class="row" style="width: 100%;height:80px;">
      <div class="col-lg-12">
        <div id="viewDatatable" style=""> <span class="dhlBack"><i
              class="fas fa-chevron-down blink"></i>&nbsp;&nbsp;<strong>VIEW DETAILS</strong> &nbsp;&nbsp; <i
              class="fas fa-chevron-down blink"></i></span></div>
      </div>
    </div>
    <div class="row topRowData" style="margin-bottom:16px;margin-top:32px;" id="tripDetailsDiv">
      <div class="col-lg-12"><strong>VEHICLE DETAILS</strong><span id="headerText"></span></div>
    </div>
    <div class="row" id="midColumn" style="width: 100%;padding:0px;margin-left:0px">
      <div class="col-lg-12" style="padding:0px;">
        <div id="tableDiv" class="tableDiv">
          <table id="tripDatatable" class="table table-striped table-bordered" cellspacing="0"
            style="width:-1px;z-index:1">
            <thead>
              <tr>
                <th nowrap="nowrap">Sl. No.</th>
                <th>Trip Id</th>
                <th>Route Id</th>
                <th>End Date</th>
                <th nowrap="nowrap">Created Time</th>
                <th nowrap="nowrap">Trip No.</th>
                <th nowrap="nowrap">Vehicle No.</th>
                <th nowrap="nowrap">Suggested Time For Dispatch</th>
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
                <th nowrap="nowrap">Odometer Reading</th>
                <th nowrap="nowrap">Estimated Fuel</th>
                <th nowrap="nowrap">ASM Name</th>
                <th nowrap="nowrap">ASM Email</th>
                <th nowrap="nowrap">ASM Contact</th>
                <th nowrap="nowrap">Driver Source Hub</th>
                <th nowrap="nowrap">Avg. Loading Detention</th>
                <th nowrap="nowrap">Avg. Loading Detention Percentage</th>
                <th nowrap="nowrap">Preferred Laoding Time</th>
                <th nowrap="nowrap">Total Loss</th>
                <th nowrap="nowrap">Detention Control Executive Name</th>
                <th nowrap="nowrap">Extra Service</th>
                <th nowrap="nowrap">Distance To Next Hub</th>
                <th nowrap="nowrap">Customer Name</th>
                <th nowrap="nowrap">Customer Email</th>
                <th nowrap="nowrap">Customer Contact Number</th>
                <th nowrap="nowrap">ODO Route</th>
              </tr>
            </thead>
          </table>
        </div>
      </div>
    </div>
    <div id="viewDashboard">
      <div class="row">
        <div class="col-lg-12"><span class="dhlBack"><i class="fas fa-chevron-up blink"></i>&nbsp;&nbsp;<strong>VIEW
              DASHBOARD & MAP </strong>&nbsp;&nbsp; <i class="fas fa-chevron-up blink"></i></span></div>
        <div class="col-lg-3"></div>
      </div>
    </div>
  </div>
  <script>
    /*extend leadlet - you should include the polli*/
    L.RotatedMarker = L.Marker.extend({
      options: {
        angle: 0
      },
      _setPos: function (pos) {
        L.Marker.prototype._setPos.call(this, pos);
        if (L.DomUtil.TRANSFORM) {
          // use the CSS transform rule if available
          this._icon.style[L.DomUtil.TRANSFORM] += ' rotate(' + this.options.angle + 'deg)';
        } else if (L.Browser.ie) {
          // fallback for IE6, IE7, IE8
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
    /*end leaflet extension*/
    let t4uspringappURL = "<%=t4uspringappURL%>";
    let systemId = <%=systemId%>;
    let customerId = <%=customerId%>;
    let iconPath = "/Telematics4uApp/Jsps/GeneralVertical/";
    // let t4uspringappURL = "https://track-staging.dhlsmartrucking.com/t4uspringapp/";
    // let systemId = 268;
    // let customerId = 5560;
    // let iconPath = "";
    let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';
    let tableMain;
    let status = 0;
    var map = null;
    let markerClusterArray = [];
    let markerCluster;
    let markerClusterArrayHub = [];
    let markerClusterHub;
    let hubMarker;
    let animate = "true";
    let infowindow;
    let infowindowOne;
    let mapNew;
    let tripNo;
    let vehicleNo;
    let startDate;
    let endDatehid;
    let countryName = '<%=countryName%>';
    let custName = "ALL";
    let routeId = "ALL";
    let tripStatus = "";
    let flag = false;
    let toggle = "hide";
    let toggleVal = "";
    let resultAllIncoming = [];
    let resultAllOutgoing = [];
    let resultTotalIncoming = [];
    let resultTotalOutgoing = [];
    let result0To2Hoursincoming = [];
    let result2To4Hoursincoming = [];
    let result4To8Hoursincoming = [];
    let result8Plusincoming = [];
    let resultUnloadingDetention = [];
    let resultLoadingDetention = [];
    let resultAtLoading = [];
    let resultAtUnLoading = [];
    let resultUpcomingIndents = [];
    let resultDelayedIndents = [];
    let resultShDetention = [];
    let result0To2Hoursoutgoing = [];
    let result2To4Hoursoutgoing = [];
    let result4To8Hoursoutgoing = [];
    let result8Plusoutgoing = [];
    let resultGPSincoming = [];
    let resultGPSoutgoing = [];
    let resultTempincoming = [];
    let resultTempoutgoing = [];
    let resultFuelincoming = [];
    let resultFueloutgoing = [];
    let resultDelayedincoming = [];
    let resultDelayedoutgoing = [];
    let resultAlertincoming = [];
    let resultAlertoutgoing = [];
    let resultInsideHub = [];
    let result0To2HoursLD = [];
    let result2To4HoursLD = [];
    let result4To8HoursLD = [];
    let result8PlusLD = [];
    let result0To2HoursULD = [];
    let result2To4HoursULD = [];
    let result4To8HoursULD = [];
    let result8PlusULD = [];
    let result0To2HoursUI = [];
    let result2To4HoursUI = [];
    let result4To8HoursUI = [];
    let result8PlusUI = [];
    let result0To2HoursDI = [];
    let result2To4HoursDI = [];
    let result4To8HoursDI = []
    let resultODO  = [];
    let result8PlusDI = [];
    let initialLoad = true;
    let rows = [];
    let openToolTipId = "";
    function toggleMapCircle() {
      map.closePopup();
      if (toggleVal === "map") {
        $("#circleIcon").hide();
        $("#mapIcon").show();
        $("#map").show(1000);
        $("#map").css({ "z-index": -1 });
        $("#circle1").animate({ height: "630px", width: "630px" }, 1000);
        $(".outer-2").show();
        $(".outer-1").show();
        $("#map").animate({ opacity: 0.3 }, 1000);
        $("#vehicles").show(1000);
        toggleVal = "";
      }
      else {
        $("#map").show(1000);
        $("#map").css({ "z-index": 0 });
        $(".outer-2").hide(1000);
        $(".outer-1").hide(1000);
        $("#circle1").animate({ height: "0px", width: "0px" }, 1000);
        $("#map").animate({ opacity: 1 }, 1000);
        $("#circleIcon").show();
        $("#vehicles").hide(1000);
        $("#mapIcon").hide();
        toggleVal = "map"
      }
    }
    $("#viewDatatable").click(function () {
      scrollToDataTable();
    });

    function scrollToDataTable(){
      $('html, body').animate({
        scrollTop: $("#tableDiv").offset().top - 48
      }, 1000);
    }
    $("#viewDashboard").click(function () {
      $('html, body').animate({
        scrollTop: $("#slaDashboardHeader").offset().top - 60
      }, 1000);
    });
    $(document).ready(function () {
      $("#divLoadingDetention").animate({ "height": "42px" });
      $("#divLoadingDetention .card").hide(300);
      $("#divUnloadingDetention").animate({ "height": "42px" });
      $("#divUnloadingDetention .card").hide(300);
      $("#divDelayedIndents").animate({ "height": "42px" });
      $("#divDelayedIndents .card").hide(300);
      $('#hubWise').select2();
      $('#hubWise').html("");
      $('#hubWise').append($("<option></option>").attr("value", 0).text("Please Select A Hub"));
      $.ajax({
        type: 'GET',
        url: t4uspringappURL + 'smarthub?systemId=' + systemId + '&customerId=' + customerId,
        datatype: 'json',
        contentType: "application/json",
        success: function (response) {
          let hubList = response.responseBody;
          for (let i = 0; i < hubList.length; i++) {
            $('#hubWise').append($("<option></option>").attr("value", hubList[i].hubId).text(hubList[i].hubName).attr("lat", hubList[i].latitude).attr("lng", hubList[i].longitude));
          }
          $('#hubWise').select2();
          $('#hubWise').val("0").trigger("change");
        }
      });
    });
    function loadInHub() {
      $.ajax({
        type: 'GET',
        url: t4uspringappURL + 'insidehub?systemId=' + systemId + '&customerId=' + customerId + '&hubId=' + $("#hubWise").val() + '&hubName=' + $('#hubWise').select2('data')[0]['text'].split(",")[0],
        datatype: 'json',
        contentType: "application/json",
        success: function (response) {
          resultInsideHub = response.responseBody;
          $("#inHubVehicles").html(resultInsideHub.length);
          loadCircleMapTable("incoming", "inside");
          loadTable("inside", "incoming");
        }
      });
    }
    function loadAll() {
      $("#map").css({ "height": "680px" });
      $('html, body').animate({
        scrollTop: $("#slaDashboardHeader").offset().top - 60
      }, 1000);
      $("#outer1").addClass("outerReg").removeClass("outerLarge outerSmall");
      $("#inner1").addClass("inner-1").removeClass("inner-1Large inner-1Small");
      $("#inner2").addClass("inner-2").removeClass("inner-2Large inner-2Small");
      $("#vehicles").html("");
      loadMap("outgoing");
      loadMap("incoming");
      showUpcomingDelayedIndentsSHDetentionCount()
      showHideIncomingOutgoingCount('alerts', 'TPMISSED');
      showHideIncomingOutgoingCount('alerts', 'ROUTEDEVIATION');
      showHideIncomingOutgoingCount('alerts', 'STOPPAGE');
      showHideIncomingOutgoingCount('alerts', 'TEMPDEVIATION');
      showHideIncomingOutgoingCount('alerts', 'LOWAVGSPEED');
      showHideIncomingOutgoingCount('alerts', 'PANIC');
      odoCounts();
    }
    function odoCounts() {
      $.ajax({
        type: "GET",
        url: t4uspringappURL + 'odoRouteCountDetailsForHubAction',
        datatype: 'json',
        contentType: "application/json",
        data: {
          customerId: customerId,
          systemId: systemId,
          hubId: $("#hubWise").val().toString(),
          hubName: $('#hubWise').select2('data')[0].text
        },
        success: function (result) {
          resultODO = result.responseBody;
          console.log("result ODO", resultODO);
          $("#odo").html(parseInt(resultODO.length));
        }
      });
    }
    function toggleCard(id, e) {
      if (id == "divOutgoing") {
        $("#divLoadingDetention").animate({ "height": "42px" });
        $("#divLoadingDetention .card").hide(300);
        $("#divUnloadingDetention").animate({ "height": "42px" });
        $("#divUnloadingDetention .card").hide(300);
        $("#divDelayedIndents").animate({ "height": "42px" });
        $("#divDelayedIndents .card").hide(300);
      }
      if (id == "divLoadingDetention") {
        $("#divOutgoing").animate({ "height": "42px" });
        $("#divOutgoing .card").hide(300);
        $("#divUnloadingDetention").animate({ "height": "42px" });
        $("#divUnloadingDetention .card").hide(300);
        $("#divDelayedIndents").animate({ "height": "42px" });
        $("#divDelayedIndents .card").hide(300);
      }
      if (id == "divUnloadingDetention") {
        $("#divLoadingDetention").animate({ "height": "42px" });
        $("#divLoadingDetention .card").hide(300);
        $("#divOutgoing").animate({ "height": "42px" });
        $("#divOutgoing .card").hide(300);
        $("#divDelayedIndents").animate({ "height": "42px" });
        $("#divDelayedIndents .card").hide(300);

      }
      if (id == "divDelayedIndents") {
        $("#divLoadingDetention").animate({ "height": "42px" });
        $("#divLoadingDetention .card").hide(300);
        $("#divUnloadingDetention").animate({ "height": "42px" });
        $("#divUnloadingDetention .card").hide(300);
        $("#divOutgoing").animate({ "height": "42px" });
        $("#divOutgoing .card").hide(300);
      }
      $("#" + id + " .card").show(200);
      $("#" + id).css({ "height": "fit-content" });
    }
    function showUpcomingDelayedIndentsSHDetentionCount() {
      result0To2HoursDI = [];
      result2To4HoursDI = [];
      result4To8HoursDI = [];
      result8PlusDI = [];
      $.ajax({
        type: "GET",
        url: t4uspringappURL + 'upcomingindent',
        datatype: 'json',
        contentType: "application/json",
        data: {
          customerId: customerId,
          systemId: systemId,
          hubId: $("#hubWise").val().toString(),
          hubName: $('#hubWise').select2('data')[0].text
        },
        success: function (result) {
          // $("#outgoingUpcomingIndents").html(result.responseBody.length);
          resultUpcomingIndents = result.responseBody;
          // resultUpcomingIndents.forEach(function (res) {
          //   let dispatchTime = Math.abs(parseInt(res.suggestedTimeForDispatch));
          //   if (parseInt(dispatchTime) > 0 && parseInt(dispatchTime) <= 120) { result0To2HoursDI.push(res); }
          //   if (parseInt(dispatchTime) > 120 && parseInt(dispatchTime) <= 240) { result2To4HoursDI.push(res); }
          //   if (parseInt(dispatchTime) > 240 && parseInt(dispatchTime) <= 480) { result4To8HoursDI.push(res); }
          //   if (parseInt(dispatchTime) > 480) { result8PlusDI.push(res); }
          // })
          $.ajax({
            type: "GET",
            url: t4uspringappURL + 'delayedindent',
            datatype: 'json',
            contentType: "application/json",
            data: {
              customerId: customerId,
              systemId: systemId,
              hubId: $("#hubWise").val().toString(),
              hubName: $('#hubWise').select2('data')[0].text
            },
            success: function (result) {
              resultDelayedIndents = result.responseBody;
              resultDelayedIndents.concat(resultUpcomingIndents);
              $("#outgoingDelayedIndents").html(resultDelayedIndents.length);
              resultDelayedIndents.forEach(function (res) {
                let dispatchTime = Math.abs(parseInt(res.suggestedTimeForDispatch));
                if (parseInt(dispatchTime) > 0 && parseInt(dispatchTime) <= 120) { result0To2HoursDI.push(res); }
                if (parseInt(dispatchTime) > 120 && parseInt(dispatchTime) <= 240) { result2To4HoursDI.push(res); }
                if (parseInt(dispatchTime) > 240 && parseInt(dispatchTime) <= 480) { result4To8HoursDI.push(res); }
                if (parseInt(dispatchTime) > 480) { result8PlusDI.push(res); }
              })
              $("#diLessThan2Hours").html(result0To2HoursDI.length);
              $("#di2To4Hours").html(result2To4HoursDI.length);
              $("#di4To8Hours").html(result4To8HoursDI.length);
              $("#di8Plus").html(result8PlusDI.length);
            }
          });
        }
      });
      $.ajax({
        type: "GET",
        url: t4uspringappURL + 'shdetention',
        datatype: 'json',
        contentType: "application/json",
        data: {
          customerId: customerId,
          systemId: systemId,
          hubId: $("#hubWise").val().toString(),
          hubName: $('#hubWise').select2('data')[0].text
        },
        success: function (result) {
          $("#shDetention").html(result.responseBody.length);
          resultShDetention = result.responseBody;
        }
      });
    }
    $('#hubWise').on("change", function () {
      if ($('#hubWise').val() != "0") {
        $("#refIcon").show();
        resetFields();
        $("#loading").hide();
        $("#tripDetDiv").show();
        toggleVal === "map" ? toggleMapCircle() : "";
        map.invalidateSize();
        map.flyTo(new L.LatLng($('option:selected', "#hubWise").attr("lat"), $('option:selected', "#hubWise").attr("lng")), 8);
        $(".leaflet-marker-icon").remove(); $(".leaflet-popup").remove();
        markerCluster = L.markerClusterGroup();
        let image = L.icon({
          iconUrl: String(iconPath + "smarthubmarker.png"),
          iconSize: [60, 60],
          popupAnchor: [0, -15]
        });
        hubMarker = new L.marker(new L.LatLng($('option:selected', "#hubWise").attr("lat"), $('option:selected', "#hubWise").attr("lng")), {
          icon: image
        }).addTo(map);
        loadAll();
      }
      else {
        $("#refIcon").hide();
        resetFields();
        $("#loading").show();
        $("#tripDetDiv").hide();
      }
    })
    setInterval(function () {
      refresh();
    }, 900000)
    function refresh() {
      resetFields();
      toggleVal === "map" ? toggleMapCircle() : "";
      loadAll();
    }
    function selected(element) {
      $(".leftTextSelected").removeClass("leftTextSelected");
      $(element).hasClass("leftText") ? $(element).addClass("leftTextSelected") : "";
    }
    // ************* Map Details
    //initialize("map",new L.LatLng(<%=latitudeLongitude%>),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
    initialize("map", new L.LatLng(20.5937, 78.9629), '<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
    function resetFields() {
      $(".leftTextSelected").removeClass("leftTextSelected");
      $("#incomingTotal").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#incomingLessThan2Hours").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#incoming2To4Hours").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#incoming4To8Hours").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingTotal").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingLessThan2Hours").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoing2To4Hours").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoing4To8Hours").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingFixGPS").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingUpcomingIndents").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingDelayedIndents").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingFixTemp").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingTopUpFuel").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#outgoingDelayed").html('<i class="fas fa-spinner fa-spin spinnerColor"></i>');
      $("#inHubVehicles").html('<i class="fas fa-spinner fa-spin spinnerColor" style="margin-top:6px;"></i>');
      $("#shDetention").html(0);
      $("#incomingSHMissed").html(0);
      $("#incomingRouteDeviation").html(0);
      $("#incomingUnplannedStoppage").html(0);
      $("#incomingTempDeviation").html(0);
      $("#incomingLowAvgSpeed").html(0);
      $("#incomingPanic").html(0);
      $('#tripDatatable').DataTable().clear().draw();
      if (markerCluster) {
        map.removeLayer(markerCluster);
        markerClusterArray = [];
      }
    }
    function loadMap(hubDirection) {
      $.ajax({
        url: t4uspringappURL + 'getMapViewDetailsForHubActionDashboard',
        datatype: 'json',
        contentType: "application/json",
        data: {
          customerId: customerId,
          systemId: systemId,
          hubId: $('#hubWise').val(),
          hubDirection: hubDirection
        },
        success: function (result) {
          results = result.responseBody;
          if (hubDirection === "incoming") {
            result0To2Hoursincoming = [];
            result2To4Hoursincoming = [];
            result4To8Hoursincoming = [];
            result8Plusincoming = [];
            resultGPSincoming = [];
            resultTempincoming = [];
            resultFuelincoming = [];
            resultDelayedincoming = [];
            resultAllIncoming = [];
            resultTotalIncoming = [];
            resultUnloadingDetention = [];
            resultAtUnLoading = [];
          }
          else {
            result0To2Hoursoutgoing = [];
            result2To4Hoursoutgoing = [];
            result4To8Hoursoutgoing = [];
            result8Plusoutgoing = [];
            resultGPSoutgoing = [];
            resultTempoutgoing = [];
            resultFueloutgoing = [];
            resultDelayedoutgoing = [];
            resultAllOutgoing = [];
            resultTotalOutgoing = [];
            resultLoadingDetention = [];
            resultAtLoading = [];
          }
          for (let i = 0; i < results.length; i++) {
            let incomingTime = results[i].incomingTimeToNextPointDuration;
            let outgoingTime = results[i].outgoingTimeToNextPointDuration;
            if (hubDirection === "incoming") {
              resultTotalIncoming.push(results[i]);
              if (!results[i].gpsLocation.toLowerCase().includes($("#hubWise").select2('data')[0].text.toLowerCase().split(",")[0])) {
                if (parseInt(incomingTime) < 0 && results[i].ata !== "") { result0To2Hoursincoming.push(results[i]); resultAllIncoming.push(results[i]); }
                if (parseInt(incomingTime) > 0 && parseInt(incomingTime) <= 120) { result0To2Hoursincoming.push(results[i]); }
                if (parseInt(incomingTime) > 120 && parseInt(incomingTime) <= 240) { result2To4Hoursincoming.push(results[i]); }
                if (parseInt(incomingTime) > 240 && parseInt(incomingTime) <= 480) { result4To8Hoursincoming.push(results[i]); }
                if (parseInt(incomingTime) > 480) { result8Plusincoming.push(results[i]); }
                if (results[i].unloadingDetention !== "00:00:00" && results[i].ata !== "") {
                  resultUnloadingDetention.push(results[i]);
                  let uldTime = getLoadingUnloadingTime(results[i].unloadingDetention);
                  if (parseInt(uldTime) > 0 && parseInt(uldTime) <= 120) { result0To2HoursULD.push(results[i]); }
                  if (parseInt(uldTime) > 120 && parseInt(uldTime) <= 240) { result2To4HoursULD.push(results[i]); }
                  if (parseInt(uldTime) > 240 && parseInt(uldTime) <= 480) { result4To8HoursULD.push(results[i]); }
                  if (parseInt(uldTime) > 480) { result8PlusULD.push(results[i]); }
                }
                if ((results[i].loadingDetention !== "00:00:00" && !results[i].loadingDetention.includes("-")) && (results[i].stp !== "" || results[i].atp !== "") && results[i].atd === "") {
                  resultLoadingDetention.push(results[i]);
                  let ldTime = getLoadingUnloadingTime(results[i].loadingDetention);
                  if (parseInt(ldTime) > 0 && parseInt(ldTime) <= 120) { result0To2HoursLD.push(results[i]); }
                  if (parseInt(ldTime) > 120 && parseInt(ldTime) <= 240) { result2To4HoursLD.push(results[i]); }
                  if (parseInt(ldTime) > 240 && parseInt(ldTime) <= 480) { result4To8HoursLD.push(results[i]); }
                  if (parseInt(ldTime) > 480) { result8PlusLD.push(results[i]); }
                }
                if (results[i].ata !== "" && results[i].unloadingDetention === "00:00:00") { resultAtUnLoading.push(results[i]); }
                if (results[i].atp != "" && results[i].atd === "" && (results[i].loadingDetention === "00:00:00" || results[i].loadingDetention.includes("-"))) { resultAtLoading.push(results[i]); }
                if (results[i].gpsFix && results[i].gpsFix.toLowerCase() == "yes" && parseInt(incomingTime) <= 480) { resultGPSincoming.push(results[i]); }
                //if(results[i].obdFix && results[i].obdFix.toLowerCase() == "yes"  && parseInt(incomingTime) <=480){resultGPSincoming.push(results[i]);}
                if (results[i].tempFix && results[i].tempFix.toLowerCase() == "yes" && parseInt(incomingTime) <= 480) { resultTempincoming.push(results[i]); }
                if (results[i].fuelFix && results[i].fuelFix.toLowerCase() == "yes" && parseInt(incomingTime) <= 480) { resultFuelincoming.push(results[i]); }
                if (results[i].tripStatus.toLowerCase() == "delayed" && parseInt(incomingTime) >= 0 && parseInt(incomingTime) <= 480) { resultDelayedincoming.push(results[i]); }
                if (parseInt(incomingTime) > 0) { resultAllIncoming.push(results[i]); }
              }
            }
            else {
              resultTotalOutgoing.push(results[i]);
              if (!results[i].gpsLocation.toLowerCase().includes($("#hubWise").select2('data')[0].text.toLowerCase().split(",")[0])) {
                if (parseInt(outgoingTime) > 0 && parseInt(outgoingTime) <= 120) { result0To2Hoursoutgoing.push(results[i]); }
                if (parseInt(outgoingTime) > 120 && parseInt(outgoingTime) <= 240) { result2To4Hoursoutgoing.push(results[i]); }
                if (parseInt(outgoingTime) > 240 && parseInt(outgoingTime) <= 480) { result4To8Hoursoutgoing.push(results[i]); }
                if (parseInt(outgoingTime) > 480) { result8Plusoutgoing.push(results[i]); }
                if ((results[i].loadingDetention !== "00:00:00" && !results[i].loadingDetention.includes("-")) && (results[i].stp !== "" || results[i].atp !== "") && results[i].atd === "") {
                  resultLoadingDetention.push(results[i]);
                  let ldTime = getLoadingUnloadingTime(results[i].loadingDetention);
                  if (parseInt(ldTime) > 0 && parseInt(ldTime) <= 120) { result0To2HoursLD.push(results[i]); }
                  if (parseInt(ldTime) > 120 && parseInt(ldTime) <= 240) { result2To4HoursLD.push(results[i]); }
                  if (parseInt(ldTime) > 240 && parseInt(ldTime) <= 480) { result4To8HoursLD.push(results[i]); }
                  if (parseInt(ldTime) > 480) { result8PlusLD.push(results[i]); }
                }
                if (results[i].unloadingDetention !== "00:00:00" && results[i].ata !== "") {
                  resultUnloadingDetention.push(results[i]);
                  let uldTime = getLoadingUnloadingTime(results[i].unloadingDetention);
                  if (parseInt(uldTime) > 0 && parseInt(uldTime) <= 120) { result0To2HoursULD.push(results[i]); }
                  if (parseInt(uldTime) > 120 && parseInt(uldTime) <= 240) { result2To4HoursULD.push(results[i]); }
                  if (parseInt(uldTime) > 240 && parseInt(uldTime) <= 480) { result4To8HoursULD.push(results[i]); }
                  if (parseInt(uldTime) > 480) { result8PlusULD.push(results[i]); }
                }
                if (results[i].ata !== "" && results[i].unloadingDetention === "00:00:00") {
                  resultAtUnLoading.push(results[i]);
                }
                if (results[i].atp != "" && results[i].atd === "" && (results[i].loadingDetention === "00:00:00" || results[i].loadingDetention.includes("-"))) {
                  resultAtLoading.push(results[i]);
                }
                if (results[i].gpsFix && results[i].gpsFix.toLowerCase() == "yes" && parseInt(outgoingTime) <= 480) { resultGPSoutgoing.push(results[i]); }
                //if(results[i].obdFix && results[i].obdFix.toLowerCase() == "yes" && parseInt(outgoingTime) <=480){resultGPSoutgoing.push(results[i]);}
                if (results[i].tempFix && results[i].tempFix.toLowerCase() == "yes" && parseInt(outgoingTime) <= 480) { resultTempoutgoing.push(results[i]); }
                if (results[i].fuelFix && results[i].fuelFix.toLowerCase() == "yes" && parseInt(outgoingTime) <= 480) { resultFueloutgoing.push(results[i]); }
                if (results[i].tripStatus.toLowerCase() == "delayed" && parseInt(outgoingTime) > 0 && parseInt(outgoingTime) <= 480) { resultDelayedoutgoing.push(results[i]); }
                if (parseInt(outgoingTime) > 0) { resultAllOutgoing.push(results[i]); }
              }
            }
          }
          if (hubDirection === "incoming") {
            $("#incomingTotal").html(resultAllIncoming.length);
            $("#incomingLessThan2Hours").html(result0To2Hoursincoming.length);
            $("#incoming2To4Hours").html(result2To4Hoursincoming.length);
            $("#incoming4To8Hours").html(result4To8Hoursincoming.length);
            $("#incoming8Plus").html(result8Plusincoming.length);
            resultGPSincoming = Object.values(resultGPSincoming.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}));
            //resultGPSincoming = Object.values(resultGPSincoming.reduce((acc,cur)=>Object.assign(acc,{[cur.vehicleNo]:cur}),{}));
            resultTempincoming = Object.values(resultTempincoming.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}));
            $.ajax({
              type: 'GET',
              url: t4uspringappURL + 'insidehub?systemId=' + systemId + '&customerId=' + customerId + '&hubId=' + $("#hubWise").val() + '&hubName=' + $('#hubWise').select2('data')[0]['text'].split(",")[0],
              datatype: 'json',
              contentType: "application/json",
              success: function (response) {
                resultInsideHub = response.responseBody;
                resultInsideHub = Object.values(resultInsideHub.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}));
                resultInsideHub.forEach(function (res) {
                  if (res.gpsFix && res.gpsFix.toLowerCase() == "yes" && (res.tripId === null || res.tripId === 0)) { resultGPSoutgoing.push(res); }
                  //if(res.obdFix && res.obdFix.toLowerCase() == "yes" && (res.tripId === null || res.tripId === 0)){resultGPSoutgoing.push(res);}
                  if (res.tempFix && res.tempFix.toLowerCase() == "yes" && (res.tripId === null || res.tripId === 0)) { resultTempoutgoing.push(res); }
                  if (res.fuelFix && res.fuelFix.toLowerCase() == "yes" && (res.tripId === null || res.tripId === 0)) { resultFueloutgoing.push(res); }
                  if (res.unloadingDetention !== "00:00:00" && res.ata !== "") {
                    resultUnloadingDetention.push(res);
                    let uldTime = getLoadingUnloadingTime(res.unloadingDetention);
                    if (parseInt(uldTime) > 0 && parseInt(uldTime) <= 120) { result0To2HoursULD.push(res); }
                    if (parseInt(uldTime) > 120 && parseInt(uldTime) <= 240) { result2To4HoursULD.push(res); }
                    if (parseInt(uldTime) > 240 && parseInt(uldTime) <= 480) { result4To8HoursULD.push(res); }
                    if (parseInt(uldTime) > 480) { result8PlusULD.push(res); }
                  }
                  if ((res.loadingDetention !== "00:00:00" && !res.loadingDetention.includes("-")) && (res.stp !== "" || res.atp !== "") && res.atd === "") {
                    resultLoadingDetention.push(res);
                    let ldTime = getLoadingUnloadingTime(res.loadingDetention);
                    if (parseInt(ldTime) > 0 && parseInt(ldTime) <= 120) { result0To2HoursLD.push(res); }
                    if (parseInt(ldTime) > 120 && parseInt(ldTime) <= 240) { result2To4HoursLD.push(res); }
                    if (parseInt(ldTime) > 240 && parseInt(ldTime) <= 480) { result4To8HoursLD.push(res); }
                    if (parseInt(ldTime) > 480) { result8PlusLD.push(res); }
                  }
                  if (res.ata !== "" && res.unloadingDetention === "00:00:00") {
                    resultAtUnLoading.push(res);
                  }
                  if (res.atp != "" && res.atd === "" && (res.loadingDetention === "00:00:00" || res.loadingDetention.includes("-"))) { resultAtLoading.push(res); }
                })
                $("#incomingUnLoadingDetention").html(resultUnloadingDetention.length);
                $("#incomingAtUnLoading").html(resultAtUnLoading.length);
                $("#outgoingLoadingDetention").html(resultLoadingDetention.length);
                $("#outgoingAtLoading").html(resultAtLoading.length);
                $("#outgoingFixGPS").html(resultGPSincoming.concat(resultGPSoutgoing).length);
                $("#outgoingFixTemp").html(resultTempincoming.concat(resultTempoutgoing).length);
                $("#outgoingTopUpFuel").html(resultFuelincoming.concat(resultFueloutgoing).length);
                $("#inHubVehicles").html(resultInsideHub.length);
                $("#uldLessThan2Hours").html(result0To2HoursULD.length);
                $("#uld2To4Hours").html(result2To4HoursULD.length);
                $("#uld4To8Hours").html(result4To8HoursULD.length);
                $("#uld8Plus").html(result8PlusULD.length);
                $("#ldLessThan2Hours").html(result0To2HoursLD.length);
                $("#ld2To4Hours").html(result2To4HoursLD.length);
                $("#ld4To8Hours").html(result4To8HoursLD.length);
                $("#ld8Plus").html(result8PlusLD.length);
                loadCircleMapTable("incoming", "initial");
                loadTable("initial", "incoming");
              }
            });
          }
          else {
            $("#outgoingTotal").html(resultAllOutgoing.length);
            $("#outgoingLessThan2Hours").html(result0To2Hoursoutgoing.length);
            $("#outgoing2To4Hours").html(result2To4Hoursoutgoing.length);
            $("#outgoing4To8Hours").html(result4To8Hoursoutgoing.length);
            $("#outgoing8Plus").html(result8Plusoutgoing.length);
            resultGPSoutgoing = Object.values(resultGPSoutgoing.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}))
            resultTempoutgoing = Object.values(resultTempoutgoing.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}));
            resultDelayedoutgoing = Object.values(resultDelayedoutgoing.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}));
          }
          $("#outgoingDelayed").html(resultDelayedincoming.concat(resultDelayedoutgoing).length);
        }
      });
    }
    function getLoadingUnloadingTime(time) {
      let a = time.split(':');
      let minutes = (+a[0]) * 60 + (+a[1]);
      return minutes;
    }
    let resultTPMissedIncoming = [];
    let resultTPMissedOutgoing = [];
    let resultRouteDevIncoming = [];
    let resultRouteDevOutgoing = []
    let resultTempDevIncoming = [];
    let resultTempDevOutgoing = []
    let resultLowAvgSpeedIncoming = [];
    let resultLowAvgSpeedOutgoing = []
    let resultPanicIncoming = [];
    let resultPanicOutgoing = []
    let resultStoppageIncoming = [];
    let resultStoppageOutgoing = [];
    function showHideIncomingOutgoingCount(hubDirection, type) {
      $.ajax({
        type: 'GET',
        url: t4uspringappURL + 'alertdetails?systemId=' + systemId + '&customerId=' + customerId + '&hubId=' + $("#hubWise").val() + '&hubDirection=incoming&alertName=' + type,
        datatype: 'json',
        contentType: "application/json",
        success: function (response) {
          let temp = response.responseBody;
          let alertResIncoming = [];
          for (let i = 0; i < temp.length; i++) {
            let incomingTime = temp[i].incomingTimeToNextPointDuration;
            if (parseInt(incomingTime) > 0 && parseInt(incomingTime) <= 480) { alertResIncoming.push(temp[i]) }
          }
          if (type === "TPMISSED") {
            resultTPMissedIncoming = alertResIncoming;
            $("#incomingSHMissed").html(parseInt($("#incomingSHMissed").html()) + alertResIncoming.length);
          }
          if (type === "ROUTEDEVIATION") {
            resultRouteDevIncoming = alertResIncoming;
            $("#incomingRouteDeviation").html(parseInt($("#incomingRouteDeviation").html()) + alertResIncoming.length);
          }
          if (type === "STOPPAGE") {
            resultStoppageIncoming = alertResIncoming;
            $.ajax({
              type: 'GET',
              url: t4uspringappURL + 'alertdetails?systemId=' + systemId + '&customerId=' + customerId + '&hubId=' + $("#hubWise").val() + '&hubDirection=incoming&alertName=IDLE',
              datatype: 'json',
              contentType: "application/json",
              success: function (response) {
                resultStoppageIncoming = resultStoppageIncoming.concat(response.responseBody);
                resultStoppageIncoming = Object.values(resultStoppageIncoming.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}))
                $("#incomingUnplannedStoppage").html(parseInt($("#incomingUnplannedStoppage").html()) + resultStoppageIncoming.length);
              }
            });
          }
          if (type === "TEMPDEVIATION") {
            resultTempDevIncoming = alertResIncoming;
            $("#incomingTempDeviation").html(parseInt($("#incomingTempDeviation").html()) + alertResIncoming.length);
          }
          if (type === "LOWAVGSPEED") {
            resultLowAvgSpeedIncoming = alertResIncoming;
            $("#incomingLowAvgSpeed").html(parseInt($("#incomingLowAvgSpeed").html()) + alertResIncoming.length);
          }
          if (type === "PANIC") {
            resultPanicIncoming = alertResIncoming;
            $("#incomingPanic").html(parseInt($("#incomingPanic").html()) + alertResIncoming.length);
          }
        }
      });
      $.ajax({
        type: 'GET',
        url: t4uspringappURL + 'alertdetails?systemId=' + systemId + '&customerId=' + customerId + '&hubId=' + $("#hubWise").val() + '&hubDirection=outgoing&alertName=' + type,
        datatype: 'json',
        contentType: "application/json",
        success: function (response) {
          let temp = response.responseBody;
          let alertResOutgoing = [];
          for (let i = 0; i < temp.length; i++) {
            let outgoingTime = temp[i].outgoingTimeToNextPointDuration;
            if (parseInt(outgoingTime) > 0 && parseInt(outgoingTime) <= 480) { alertResOutgoing.push(temp[i]) }
          }
          if (type === "TPMISSED") {
            resultTPMissedOutgoing = alertResOutgoing;
            $("#incomingSHMissed").html(parseInt($("#incomingSHMissed").html()) + alertResOutgoing.length);
          }
          if (type === "ROUTEDEVIATION") {
            resultRouteDevOutgoing = alertResOutgoing;
            $("#incomingRouteDeviation").html(parseInt($("#incomingRouteDeviation").html()) + alertResOutgoing.length);
          }
          if (type === "STOPPAGE") {
            resultStoppageOutgoing = alertResOutgoing;
            $.ajax({
              type: 'GET',
              url: t4uspringappURL + 'alertdetails?systemId=' + systemId + '&customerId=' + customerId + '&hubId=' + $("#hubWise").val() + '&hubDirection=outgoing&alertName=IDLE',
              datatype: 'json',
              contentType: "application/json",
              success: function (response) {
                resultStoppageOutgoing = resultStoppageOutgoing.concat(response.responseBody);
                resultStoppageOutgoing = Object.values(resultStoppageOutgoing.reduce((acc, cur) => Object.assign(acc, { [cur.vehicleNo]: cur }), {}))
                $("#incomingUnplannedStoppage").html(parseInt($("#incomingUnplannedStoppage").html()) + resultStoppageOutgoing.length);
              }
            });
          }
          if (type === "TEMPDEVIATION") {
            resultTempDevOutgoing = alertResOutgoing;
            $("#incomingTempDeviation").html(parseInt($("#incomingTempDeviation").html()) + alertResOutgoing.length);
          }
          if (type === "LOWAVGSPEED") {
            resultLowAvgSpeedOutgoing = alertResOutgoing;
            $("#incomingLowAvgSpeed").html(parseInt($("#incomingLowAvgSpeed").html()) + alertResOutgoing.length);
          }
          if (type === "PANIC") {
            resultPanicOutgoing = alertResOutgoing;
            $("#incomingPanic").html(parseInt($("#incomingPanic").html()) + alertResOutgoing.length);
          }
        }
      });
    }
    function showHideIncomingOutgoing(hubDirection, type) {
      $("#loading-div").show();
      toggleVal === "map" ? toggleMapCircle() : "";
      map.setZoom(8);
      map.removeLayer(markerCluster);
      markerCluster = L.markerClusterGroup();
      $("#outer1").addClass("outerReg").removeClass("outerLarge outerSmall");
      $("#inner1").addClass("inner-1").removeClass("inner-1Large inner-1Small");
      $("#inner2").addClass("inner-2").removeClass("inner-2Large inner-2Small");
      if (type === 0) {
        loadCircleMapTable(hubDirection, "all");
        loadTable("all", hubDirection);
      }
      if (type === 2) {
        loadCircleMapTable(hubDirection, 2);
        loadTable(2, hubDirection);
        $("#outer1").addClass("outerLarge").removeClass("outerReg outerSmall")
        $("#inner1").addClass("inner-1Large").removeClass("inner-1 inner-1Small")
        $("#inner2").addClass("inner-2Large").removeClass("inner-2 inner-2Small")
      }
      if (type === 4) {
        loadCircleMapTable(hubDirection, 4);
        loadTable(4, hubDirection)
        $("#outer1").addClass("outerLarge").removeClass("outerReg outerSmall")
        $("#inner1").addClass("inner-1Large").removeClass("inner-1 inner-1Small")
        $("#inner2").addClass("inner-2Small").removeClass("inner-2 inner-2Large")
      }
      if (type === 6) {
        loadCircleMapTable(hubDirection, 8);
        loadTable(8, hubDirection)
        $("#outer1").addClass("outerLarge").removeClass("outerReg outerSmall")
        $("#inner1").addClass("inner-1Small").removeClass("inner-1 inner-1Large")
        $("#inner2").addClass("inner-2Small").removeClass("inner-2 inner-2Large")
      }
      if (type === 8) {
        loadCircleMapTable(hubDirection, 10);
        loadTable(10, hubDirection)
        $("#outer1").addClass("outerSmall").removeClass("outerReg outerLarge")
        $("#inner1").addClass("inner-1Small").removeClass("inner-1 inner-1Large")
        $("#inner2").addClass("inner-2Small").removeClass("inner-2 inner-2Large")
      }
      if (type === "loading" || type === "unloading" || type === "SHDETENTION") {
        loadCircleMapTable(hubDirection, type);
        loadTable(type, hubDirection)
      }
      if (type === "atloading" || type === "ODO" || type === "atunloading" || type === "UPCOMINGINDENTS" || type === "DELAYEDINDENTS" || type === "GPS" || type === "TEMP" || type === "FUEL" || type === "DELAYED") {
        loadCircleMapTable(hubDirection, type);
        loadTable(type, hubDirection)
      }
      if (hubDirection === "alerts") {
        resultAlertincoming = [];
        resultAlertoutgoing = [];
        $("#vehicles").html("");
        if (markerCluster) {
          map.removeLayer(markerCluster);
        }
        if (type === "TPMISSED") {
          resultAlertincoming = resultTPMissedIncoming;
          resultAlertoutgoing = resultTPMissedOutgoing;
          $("#headerText").html("- Alerts Touchpoint Missed");
        }
        if (type === "ROUTEDEVIATION") {
          resultAlertincoming = resultRouteDevIncoming;
          resultAlertoutgoing = resultRouteDevOutgoing;
          $("#headerText").html("- Alerts Route Deviation");
        }
        if (type === "STOPPAGE") {
          resultAlertincoming = resultStoppageIncoming;
          resultAlertoutgoing = resultStoppageOutgoing;
          $("#headerText").html("- Alerts Stoppage/Idle");
        }
        if (type === "TEMPDEVIATION") {
          resultAlertincoming = resultTempDevIncoming;
          resultAlertoutgoing = resultTempDevOutgoing;
          $("#headerText").html("- Alerts Temperature Deviation");
        }
        if (type === "LOWAVGSPEED") {
          resultAlertincoming = resultLowAvgSpeedIncoming;
          resultAlertoutgoing = resultLowAvgSpeedOutgoing;
          $("#headerText").html("- Alerts Low Average Speed");
        }
        if (type === "PANIC") {
          resultAlertincoming = resultPanicIncoming;
          resultAlertoutgoing = resultPanicOutgoing;
          $("#headerText").html("- Alerts Panic");
        }
        plotHubActionPlan("incoming", "alerts");
        plotHubActionPlan("outgoing", "alerts");
        loadTable("alerts", hubDirection);
      }
    }
    function loadCircleMapTable(hubDirection, type) {
      let results = [];
      $("#vehicles").html("");
      if (type == "all" && hubDirection == "incoming") {
        results = resultAllIncoming;
      }
      if (type == "all" && hubDirection == "outgoing") {
        results = resultAllOutgoing;
      }
      if (type == 2 && hubDirection == "incoming") {
        results = result0To2Hoursincoming;
      }
      if (type == 4 && hubDirection == "incoming") {
        results = result2To4Hoursincoming;
      }
      if (type == 8 && hubDirection == "incoming") {
        results = result4To8Hoursincoming;
      }
      if (type == 10 && hubDirection == "incoming") {
        results = result8Plusincoming;
      }
      if (type == 2 && hubDirection == "ui") {
        results = result0To2HoursUI;
      }
      if (type == 4 && hubDirection == "ui") {
        results = result2To4HoursUI;
      }
      if (type == 8 && hubDirection == "ui") {
        results = result4To8HoursUI;
      }
      if (type == 10 && hubDirection == "ui") {
        results = result8PlusUI;
      }
      if (type == 2 && hubDirection == "di") {
        results = result0To2HoursDI;
      }
      if (type == 4 && hubDirection == "di") {
        results = result2To4HoursDI;
      }
      if (type == 8 && hubDirection == "di") {
        results = result4To8HoursDI;
      }
      if (type == 10 && hubDirection == "di") {
        results = result8PlusDI;
      }
      if (type == 2 && hubDirection == "ld") {
        results = result0To2HoursLD;
      }
      if (type == 4 && hubDirection == "ld") {
        results = result2To4HoursLD;
      }
      if (type == 8 && hubDirection == "ld") {
        results = result4To8HoursLD;
      }
      if (type == 10 && hubDirection == "ld") {
        results = result8PlusLD;
      }
      if (type == 2 && hubDirection == "uld") {
        results = result0To2HoursULD;
      }
      if (type == 4 && hubDirection == "uld") {
        results = result2To4HoursULD;
      }
      if (type == 8 && hubDirection == "uld") {
        results = result4To8HoursULD;
      }
      if (type == 10 && hubDirection == "uld") {
        results = result8PlusULD;
      }
      if (type == 2 && hubDirection == "outgoing") {
        results = result0To2Hoursoutgoing;
      }
      if (type == 4 && hubDirection == "outgoing") {
        results = result2To4Hoursoutgoing;
      }
      if (type == 8 && hubDirection == "outgoing") {
        results = result4To8Hoursoutgoing;
      }
      if (type == 10 && hubDirection == "outgoing") {
        results = result8Plusoutgoing;
      }
      if (type === "inside") {
        results = resultInsideHub.concat(result0To2Hoursincoming);
      }
      if (type === "initial") {
        results = resultInsideHub.concat(resultAllIncoming);
      }
      if (type == "loading") {
        results = resultLoadingDetention;
      }
      if (type == "unloading") {
        results = resultUnloadingDetention;
      }
      if (type == "SHDETENTION") {
        results = resultShDetention;
      }
      if (type == "atloading") {
        results = resultAtLoading;
      }
      if (type == "atunloading") {
        results = resultAtUnLoading;
      }
      if (type == "UPCOMINGINDENTS") {
        results = resultUpcomingIndents;
      }
      if (type == "DELAYEDINDENTS") {
        results = resultDelayedIndents;
      }
      if(type == "ODO"){
        results = resultODO;
      }
      if (type === "DELAYED") {
        if (markerCluster) {
          map.removeLayer(markerCluster);
        }
        plotHubActionPlan("incoming", "DELAYED");
        plotHubActionPlan("outgoing", "DELAYED");
        return;
      }
      if (type === "GPS") {
        if (markerCluster) {
          map.removeLayer(markerCluster);
        }
        plotHubActionPlan("incoming", "GPS");
        plotHubActionPlan("outgoing", "GPS");
        return;
      }
      if (type === "TEMP") {
        if (markerCluster) {
          map.removeLayer(markerCluster);
        }
        plotHubActionPlan("incoming", "TEMP");
        plotHubActionPlan("outgoing", "TEMP");
        return;
      }
      if (type === "FUEL") {
        if (markerCluster) {
          map.removeLayer(markerCluster);
        }
        plotHubActionPlan("incoming", "FUEL");
        plotHubActionPlan("outgoing", "FUEL");
        return;
      }
      if (type == "alert") {
        results = resultAlert;
      }
      let vehDiv = "";
      let zindex = results.length;
      let count = 0;
      if (markerCluster) {
        map.removeLayer(markerCluster);
      }
      markerCluster = L.markerClusterGroup();
      let bracketType = "";
      if (hubDirection === "di" || hubDirection === "ld" || hubDirection === "uld") {
        bracketType = hubDirection;
      }
      for (let i = 0; i < results.length; i++) {
        let direction = results[i].directionInDegree;
        let incomingTime = results[i].incomingTimeToNextPointDuration;
        let outgoingTime = results[i].outgoingTimeToNextPointDuration;
        if (type === "UPCOMINGINDENTS" || type === "DELAYEDINDENTS" || bracketType === "di") {
          outgoingTime = Math.abs(parseInt(results[i].suggestedTimeForDispatch));
          hubDirection = "outgoing";
        }
        if (bracketType === "ld") {
          outgoingTime = getLoadingUnloadingTime(results[i].loadingDetention);
          hubDirection = "outgoing";
        }
        if (bracketType === "uld") {
          incomingTime = getLoadingUnloadingTime(results[i].unloadingDetention);
          hubDirection = "incoming";
        }
        let rotate = hubDirection === "incoming" ? "transform: rotate(180deg)" : "";
        let toolOuter = "toolOuter";
        let visible = true;
        let truck = "truckSN";
        if (type == 2 || type == 4 || type == 8 || type == 10) {
          if (hubDirection === "incoming") {
            if (bracketType === "uld") {
              toolOuter = toolOuterExpandedIncoming(incomingTime, results[i].ata);
            }
            else {
              if (!results[i].gpsLocation.toLowerCase().includes($("#hubWise").select2('data')[0].text.toLowerCase().split(",")[0])) {
                toolOuter = toolOuterExpandedIncoming(incomingTime, results[i].ata);
              }
            }
          }
          else {
            if (bracketType === "ld") {
              toolOuter = toolOuterExpandedOutgoing(outgoingTime);
            }
            else {
              if (!results[i].gpsLocation.toLowerCase().includes($("#hubWise").select2('data')[0].text.toLowerCase().split(",")[0])) {
                toolOuter = toolOuterExpandedOutgoing(outgoingTime);
              }
            }
          }
        }
        else {
          if (type === "UPCOMINGINDENTS" || type === "DELAYEDINDENTS") {
            toolOuter = toolOuterOutgoing(outgoingTime);
          }
          else {
            if (hubDirection === "incoming") {
              if (!results[i].gpsLocation.toLowerCase().includes($("#hubWise").select2('data')[0].text.toLowerCase().split(",")[0])) {
                toolOuter = toolOuterIncoming(incomingTime, results[i].ata);
              }
            }
            else {
              if (!results[i].gpsLocation.toLowerCase().includes($("#hubWise").select2('data')[0].text.toLowerCase().split(",")[0])) {
                toolOuter = toolOuterOutgoing(outgoingTime);
              }
            }
          }
        }
        if (type === "UPCOMINGINDENTS" || type === "DELAYEDINDENTS" || bracketType === "di") {
          if (parseInt(results[i].suggestedTimeForDispatch) < 0) {
            if (results[i].productLine.toLowerCase() === "dry") {
              truck = "truckSDelayed";
            }
            else {
              truck = "truckSNTCLDelayed";
            }
          }
          else {
            if (results[i].productLine.toLowerCase() === "tcl") {
              truck = "truckSNTCL";
            }
          }
        }
        else {
          if (results[i].tripStatus !== null && results[i].tripStatus !== undefined) {
            if (results[i].productLine.toLowerCase() === "dry" && (results[i].tripStatus != undefined && results[i].tripStatus.toLowerCase() === "delayed")) {
              truck = "truckSDelayed";
            }
            if (results[i].productLine.toLowerCase() !== "dry" && (results[i].tripStatus != undefined && results[i].tripStatus.toLowerCase() === "delayed")) {
              truck = "truckSNTCLDelayed";
            }
            if (results[i].productLine.toLowerCase() !== "dry" && (results[i].tripStatus != undefined && results[i].tripStatus.toLowerCase() !== "delayed")) {
              truck = "truckSNTCL";
            }
          }
        }
        let gpsColor = results[i].gpsFix && results[i].gpsFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let obdColor = results[i].obdFix && results[i].obdFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let fuelColor = results[i].fuelFix && results[i].fuelFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let arr = "arrowTop";
        if (parseInt(direction) >= 90 && parseInt(direction) <= 270) { arr = "arrowBottom" }
        let mapPopUpComponent = "<div class='" + arr + "'></div>";
        mapPopUpComponent += '<div class="popUpTop">';
        let currDate = new Date();
        let lastCommDate = results[i].lastCommDateTime.split(" ")[0].split("/");
        let lastCommTime = results[i].lastCommDateTime.split(" ")[1]
        let gpsVal = ((new Date() - new Date(lastCommDate[1] + "/" + lastCommDate[0] + "/" + lastCommDate[2] + " " + lastCommTime)) / 1000) / 60
        mapPopUpComponent += '<div class="flex gpsGroup"><div class="flexCol" style="color:' + gpsColor + ';"><i class="fas fa-2x fa-map-marker-alt"  title="GPS"></i><span class="botText">' + parseInt(gpsVal) + '&nbsp;min</span></div>';
        mapPopUpComponent += '<i class="fas fa-2x fa-table" title="OBD" style="color:' + obdColor + ';"></i></div>';
        let tempColorRefer = results[i].tempAtReeferFix && results[i].tempAtReeferFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let tempColorMiddle = results[i].tempAtMiddleFix && results[i].tempAtMiddleFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let tempColorDoor = results[i].tempAtDoorFix && results[i].tempAtDoorFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let tempReferVal = results[i].temperatureData && results[i].temperatureData.split(",")[0].split("=")[1];
        let tempMiddleVal = results[i].temperatureData && results[i].temperatureData.split(",")[1].split("=")[1];
        let tempDoorVal = results[i].temperatureData && results[i].temperatureData.split(",")[2].split("=")[1];
        let deg = "&deg;C";
        if (results[i].productLine !== "TCL") {
          tempColorRefer = tempColorMiddle = tempColorDoor = "#dfdfdf";
          tempReferVal = tempMiddleVal = tempDoorVal = "NA";
          deg = "";
        }
        mapPopUpComponent += '<div class="flex tempGroup"><div class="flexCol"style="color:' + tempColorRefer + ';"><div class="flex tempR"><i class="fas fa-2x fa-temperature-low"  title="T@Refer"></i><div class="flexRow marg8">@R</div></div><span class="botText">' + tempReferVal + deg + '</span></div>';
        mapPopUpComponent += '<div class="flexCol" style="color:' + tempColorMiddle + ';"><div class="flex tempR"><i class="fas fa-2x fa-temperature-low"  title="T@Middle"></i><div class="flexRow marg8">@M</div></div><span class="botText">' + tempMiddleVal + deg + '</span></div>';
        mapPopUpComponent += '<div class="flexCol" style="color:' + tempColorDoor + ';"><div class="flex tempR"><i class="fas fa-2x fa-temperature-low"  title="T@Door"></i><div class="flexRow marg8">@D</div></div><span class="botText">' + tempDoorVal + deg + '</span></div></div>';
        mapPopUpComponent += '<i class="fas fa-2x fa-gas-pump padBot" title="Fuel"  style="color:' + fuelColor + ';"></i>';
        mapPopUpComponent += '<i class="fas fa-2x fa-dot-circle padBot" title="Tyre Pressure"  style="color:#dfdfdf;"></i>';
        mapPopUpComponent += '<img src="' + iconPath + 'engine.png"  style="margin-top:-16px;opacity:0.5;"  title="Check Engine"/>';
        mapPopUpComponent += '<div class="flexCol"  style="color:#d40511;"><i class="fas fa-2x fa-stop-circle"  title="Vehicle Stoppage"></i><span class="botText">' + results[i].stoppageTime + '</span></div>';
        mapPopUpComponent += '</div>';
        mapPopUpComponent += '<div class="toolTipStyle"><div class="toolTipDiv"><div class="toolTipLeft">Vehicle No: </div><div class="toolTipRight">' + results[i].vehicleNo + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Trip No: </div><div class="toolTipRight">' + results[i].tripNo + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Trip Id: </div><div class="toolTipRight">' + results[i].shipmentId + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Route Key: </div><div class="toolTipRight">' + results[i].routeKey + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Customer Name: </div><div class="toolTipRight">' + results[i].customerName + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Current Location: </div><div class="toolTipRight">' + results[i].location + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Dist. to Next Hub: </div><div class="toolTipRight">' + results[i].distanceToNextTouchPoint + 'km<i title="Current Speed" class="fas fa-tachometer-alt"></i>&nbsp;' + results[i].speed + 'kmph' + '<img src="' + iconPath + 'odo.png" style="width:40px;margin:0px 0px 3px 32px" title="Current Odometer Reading"/>&nbsp;' + results[i].currentOdometerReading + 'km</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ETA to Hub: </div><div class="toolTipRight">' + results[i].etaToNextHub + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ETA to Destination: </div><div class="toolTipRight">' + results[i].etaToDestination + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Trip Status: </div><div class="toolTipRight">' + results[i].tripStatus + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Dist. To QRT:</div><div class="toolTipRight"> NA</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Driver Name: </div><div class="toolTipRight">' + results[i].driverName + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Driver Contact: </div><div class="toolTipRight">' + results[i].driverNumber + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ASM: </div><div class="toolTipRight">' + results[i].areaSalesManagerName + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ASM Contact: </div><div class="toolTipRight">' + results[i].areaSalesManagerContact + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ASM Email: </div><div class="toolTipRight">' + results[i].areaSalesManagerEmail + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDivLast"><div class="toolTipLeft">Driver Source Hub: </div><div class="toolTipRight">' + results[i].driverSrcHub + '</div></div>';
        mapPopUpComponent += '</div></div>';
        if (visible) {
          vehDiv += '<div class="tooltipQ" style="z-index:' + zindex + '"><div class="' + toolOuter + hubDirection + '" id="divImg' + i + '" ondblclick="openVehicleOnMap(' + i + ',' + results[i].latitude + ',' + results[i].longitude + ',' + markerClusterArray.length + ')" onclick="openToolTip(' + i + ',' + direction + ')" style="transform: rotate(' + direction + 'deg);z-index:' + zindex + '">';
          vehDiv += '<img class="truckImage" id="truck' + i + '" src="' + truck + '.png" style="' + rotate + ';z-index:' + zindex + '"></div>';
          vehDiv += '<div  id="toolTip' + i + '" class="tooltiptext" style="pointer-events:all;position:fixed;z-index:10000;padding-bottom:16px;padding-right:16px;"><div class="closeTop" onclick="closePopUp(' + i + ')"><i class="fas fa-times closeSize"></i></div>' + mapPopUpComponent + '</div>';
          zindex--;
        }
        let timeToCheck = 0;
        if (hubDirection === "incoming") {
          timeToCheck = results[i].incomingTimeToNextPointDuration;
        }
        else {
          timeToCheck = results[i].outgoingTimeToNextPointDuration;
          if (type === "UPCOMINGINDENTS" || type === "DELAYEDINDENTS") {
            timeToCheck = Math.abs(parseInt(results[i].suggestedTimeForDispatch));
          }
        }
        if (!results[i].latitude == 0 && !results[i].longitude == 0) {
          count++;
          let image = L.icon({
            iconUrl: String(iconPath + truck + ".png"),
            popupAnchor: [0, -15]
          });
          let marker = new L.rotatedMarker(new L.LatLng(results[i].latitude, results[i].longitude), {
            icon: image,
            angle: results[i].directionInDegree
          });
          marker.bindPopup('<div style="overflow:auto;min-width:500px !important;height: 310px !important;border:1px solid #d40511;padding:0px 16px 16px 0px;margin-top:32px;border-radius:8px;">' + mapPopUpComponent);
          markerCluster.addLayer(marker);
          markerClusterArray.push(marker);
        }
      }
      map.addLayer(markerCluster);
      $("#vehicles").append(vehDiv);
      if (type === "inside" || type === "initial") {
        $(".toolOuterincoming").hide();
      }
      if (type === "inside") {
        $(".toolOuterincoming").hide();
        $(".toolOuter3Hourincoming").hide();
        $(".toolOuter4Hourincoming").hide();
        $(".toolOuter4to6Hourincoming").hide();
        $(".toolOuter6to8Hourincoming").hide();
        $(".toolOuter8Plusincoming").hide();
      }
      if (type === "inside" || type === "loading" || type === "unloading" || type === "SHDETENTION" || type === "ODO") {
        $(".toolOuter").hide();
        $(".toolOuterincoming").hide();
        $(".toolOuteroutgoing").hide();
        $(".toolOuter1Hourincoming").hide();
        $(".toolOuter2Hourincoming").hide();
        $(".toolOuter3Hourincoming").hide();
        $(".toolOuter4Hourincoming").hide();
        $(".toolOuter4to6Hourincoming").hide();
        $(".toolOuter6to8Hourincoming").hide();
        $(".toolOuter8Plusincoming").hide();
        $(".toolOuter1Houroutgoing").hide();
        $(".toolOuter2Houroutgoing").hide();
        $(".toolOuter3Houroutgoing").hide();
        $(".toolOuter4Houroutgoing").hide();
        $(".toolOuter4to6Houroutgoing").hide();
        $(".toolOuter6to8Houroutgoing").hide();
        $(".toolOuter8Plusoutgoing").hide();
      }
    }
    function toolOuterIncoming(incomingTime, ata) {
      let toolOuter = "toolOuter";
      if (parseInt(incomingTime) < 0 && ata !== "") { toolOuter = "toolOuter1Hour"; }
      if (parseInt(incomingTime) > 0 && parseInt(incomingTime) <= 60) { toolOuter = "toolOuter1Hour"; }
      if (parseInt(incomingTime) > 60 && parseInt(incomingTime) <= 120) { toolOuter = "toolOuter2Hour"; }
      if (parseInt(incomingTime) > 120 && parseInt(incomingTime) <= 180) { toolOuter = "toolOuter3Hour"; }
      if (parseInt(incomingTime) > 180 && parseInt(incomingTime) <= 240) { toolOuter = "toolOuter4Hour"; }
      if (parseInt(incomingTime) > 240 && parseInt(incomingTime) <= 360) { toolOuter = "toolOuter4to6Hour"; }
      if (parseInt(incomingTime) > 360 && parseInt(incomingTime) <= 480) { toolOuter = "toolOuter6to8Hour"; }
      if (parseInt(incomingTime) > 480) { toolOuter = "toolOuter8Plus"; }
      return toolOuter;
    }
    function toolOuterOutgoing(outgoingTime) {
      let toolOuter = "toolOuter";
      if (parseInt(outgoingTime) > 0 && parseInt(outgoingTime) <= 60) { toolOuter = "toolOuter1Hour"; }
      if (parseInt(outgoingTime) > 60 && parseInt(outgoingTime) <= 120) { toolOuter = "toolOuter2Hour"; }
      if (parseInt(outgoingTime) > 120 && parseInt(outgoingTime) <= 180) { toolOuter = "toolOuter3Hour"; }
      if (parseInt(outgoingTime) > 180 && parseInt(outgoingTime) <= 240) { toolOuter = "toolOuter4Hour"; }
      if (parseInt(outgoingTime) > 240 && parseInt(outgoingTime) <= 360) { toolOuter = "toolOuter4to6Hour"; }
      if (parseInt(outgoingTime) > 360 && parseInt(outgoingTime) <= 480) { toolOuter = "toolOuter6to8Hour"; }
      if (parseInt(outgoingTime) > 480) { toolOuter = "toolOuter8Plus"; }
      return toolOuter;
    }
    function toolOuterExpandedOutgoing(outgoingTime) {
      let toolOuter = "toolOuter";
      if (parseInt(outgoingTime) > 0 && parseInt(outgoingTime) <= 60) {
        toolOuter = "toolOuter2Hour";
        if (parseInt(outgoingTime) <= 30) { toolOuter = "toolOuter1Hour"; }
      }
      if (parseInt(outgoingTime) > 60 && parseInt(outgoingTime) <= 120) {
        toolOuter = "toolOuter4Hour";
        if (parseInt(outgoingTime) <= 90) { toolOuter = "toolOuter3Hour"; }
      }
      if (parseInt(outgoingTime) > 120 && parseInt(outgoingTime) <= 180) {
        toolOuter = "toolOuter2Hour";
        if (parseInt(outgoingTime) <= 150) { toolOuter = "toolOuter3Hour"; }
      }
      if (parseInt(outgoingTime) > 180 && parseInt(outgoingTime) <= 240) {
        toolOuter = "toolOuter4to6Hour";
        if (parseInt(outgoingTime) <= 210) { toolOuter = "toolOuter4Hour"; }
      }
      if (parseInt(outgoingTime) > 240 && parseInt(outgoingTime) <= 360) {
        toolOuter = "toolOuter6to8Hour";
        if (parseInt(outgoingTime) <= 270) { toolOuter = "toolOuter3Hour"; }
        if (parseInt(outgoingTime) > 270 && parseInt(outgoingTime) <= 300) { toolOuter = "toolOuter4Hour"; }
        if (parseInt(outgoingTime) > 300 && parseInt(outgoingTime) <= 330) { toolOuter = "toolOuter4to6Hour"; }
      }
      if (parseInt(outgoingTime) > 360 && parseInt(outgoingTime) <= 480) {
        toolOuter = "toolOuter6to8Hour";
        if (parseInt(outgoingTime) <= 390) { toolOuter = "toolOuter3Hour"; }
        if (parseInt(outgoingTime) > 390 && parseInt(outgoingTime) <= 420) { toolOuter = "toolOuter4Hour"; }
        if (parseInt(outgoingTime) > 420 && parseInt(outgoingTime) <= 450) { toolOuter = "toolOuter4to6Hour"; }
      }
      if (parseInt(outgoingTime) > 480) {
        toolOuter = "toolOuter8Plus";
        if (parseInt(outgoingTime) > 480 && parseInt(outgoingTime) <= 960) { toolOuter = "toolOuter2Hour"; }
        if (parseInt(outgoingTime) > 960 && parseInt(outgoingTime) <= 1440) { toolOuter = "toolOuter3Hour"; }
        if (parseInt(outgoingTime) > 1440 && parseInt(outgoingTime) <= 1920) { toolOuter = "toolOuter4Hour"; }
        if (parseInt(outgoingTime) > 1920 && parseInt(outgoingTime) <= 2400) { toolOuter = "toolOuter4to6Hour"; }
        if (parseInt(outgoingTime) > 2400 && parseInt(outgoingTime) <= 2880) { toolOuter = "toolOuter6to8Hour"; }
      }
      return toolOuter;
    }
    function toolOuterExpandedIncoming(incomingTime, ata) {
      let toolOuter = "toolOuter";
      if (parseInt(incomingTime) < 0 && ata !== "") { toolOuter = "toolOuter1Hour"; }
      if (parseInt(incomingTime) > 0 && parseInt(incomingTime) <= 60) {
        toolOuter = "toolOuter2Hour";
        if (parseInt(incomingTime) <= 30) { toolOuter = "toolOuter1Hour"; }
      }
      if (parseInt(incomingTime) > 60 && parseInt(incomingTime) <= 120) {
        toolOuter = "toolOuter4Hour";
        if (parseInt(incomingTime) <= 90) { toolOuter = "toolOuter3Hour"; }
      }
      if (parseInt(incomingTime) > 120 && parseInt(incomingTime) <= 180) {
        toolOuter = "toolOuter2Hour";
        if (parseInt(incomingTime) <= 150) { toolOuter = "toolOuter3Hour"; }
      }
      if (parseInt(incomingTime) > 180 && parseInt(incomingTime) <= 240) {
        toolOuter = "toolOuter4to6Hour";
        if (parseInt(incomingTime) <= 210) { toolOuter = "toolOuter4Hour"; }
      }
      if (parseInt(incomingTime) > 240 && parseInt(incomingTime) <= 360) {
        toolOuter = "toolOuter6to8Hour";
        if (parseInt(incomingTime) <= 270) { toolOuter = "toolOuter3Hour"; }
        if (parseInt(incomingTime) > 270 && parseInt(incomingTime) <= 300) { toolOuter = "toolOuter4Hour"; }
        if (parseInt(incomingTime) > 300 && parseInt(incomingTime) <= 330) { toolOuter = "toolOuter4to6Hour"; }
      }
      if (parseInt(incomingTime) > 360 && parseInt(incomingTime) <= 480) {
        toolOuter = "toolOuter6to8Hour";
        if (parseInt(incomingTime) <= 390) { toolOuter = "toolOuter3Hour"; }
        if (parseInt(incomingTime) > 390 && parseInt(incomingTime) <= 420) { toolOuter = "toolOuter4Hour"; }
        if (parseInt(incomingTime) > 420 && parseInt(incomingTime) <= 450) { toolOuter = "toolOuter4to6Hour"; }
      }
      if (parseInt(incomingTime) > 480) {
        toolOuter = "toolOuter8Plus";
        if (parseInt(incomingTime) > 480 && parseInt(incomingTime) <= 960) { toolOuter = "toolOuter2Hour"; }
        if (parseInt(incomingTime) > 960 && parseInt(incomingTime) <= 1440) { toolOuter = "toolOuter3Hour"; }
        if (parseInt(incomingTime) > 1440 && parseInt(incomingTime) <= 1920) { toolOuter = "toolOuter4Hour"; }
        if (parseInt(incomingTime) > 1920 && parseInt(incomingTime) <= 2400) { toolOuter = "toolOuter4to6Hour"; }
        if (parseInt(incomingTime) > 2400 && parseInt(incomingTime) <= 2880) { toolOuter = "toolOuter6to8Hour"; }
      }
      return toolOuter;
    }
    function openToolTip(id, direction) {
      openToolTipId != "" ? $("#" + openToolTipId).hide() : "";
      openToolTipId = "toolTip" + id;
      let topVal = $("#truck" + id)[0].getBoundingClientRect().y;
      let leftVal = $("#truck" + id)[0].getBoundingClientRect().x - 168;
      if (parseInt(direction) >= 90 && parseInt(direction) <= 270) {
        $("#toolTip" + id).css({ top: topVal - 330, left: leftVal });
      }
      else {
        $("#toolTip" + id).css({ top: topVal + 40, left: leftVal });
      }
      $("#toolTip" + id).show();
    }
    function openVehicleOnMap(id, lat, lng, marker) {
      toggleMapCircle();
      map.flyTo(new L.LatLng(lat, lng), 18);
      setTimeout(function () { markerClusterArray[marker].openPopup() }, 6500);
    }
    $(document).on("scroll", function () {
      if (openToolTipId != "") {
        $("#" + openToolTipId).hide();
        openToolTipId = ""
      }
    })
    function closePopUp(id) {
      $("#toolTip" + id).hide();
    }
    $(document).on('keydown', function (e) {
      if (e.keyCode === 27) { // ESC
        $(".tooltiptext").hide();
        map.closePopup();
      }
    });
    function plotHubActionPlan(hubDirection, type) {
      let results = [];
      if (type === "DELAYED" && hubDirection === "incoming") {
        results = resultDelayedincoming;
      }
      if (type === "GPS" && hubDirection === "incoming") {
        results = resultGPSincoming;
      }
      if (type === "TEMP" && hubDirection === "incoming") {
        results = resultTempincoming;
      }
      if (type === "FUEL" && hubDirection === "incoming") {
        results = resultFuelincoming;
      }
      if (type === "DELAYED" && hubDirection === "outgoing") {
        results = resultDelayedoutgoing;
      }
      if (type === "GPS" && hubDirection === "outgoing") {
        results = resultGPSoutgoing;
      }
      if (type === "TEMP" && hubDirection === "outgoing") {
        results = resultTempoutgoing;
      }
      if (type === "FUEL" && hubDirection === "outgoing") {
        results = resultFueloutgoing;
      }
      if (type === "alerts" && hubDirection === "incoming") {
        results = resultAlertincoming;
      }
      if (type === "alerts" && hubDirection === "outgoing") {
        results = resultAlertoutgoing;
      }
      let vehDiv = "";
      let zindex = results.length;
      let count = 0;
      for (let i = 0; i < results.length; i++) {
        let direction = results[i].directionInDegree;
        let incomingTime = results[i].incomingTimeToNextPointDuration;
        let outgoingTime = results[i].outgoingTimeToNextPointDuration;
        let rotate = hubDirection === "incoming" ? "transform: rotate(180deg)" : "";
        let toolOuter = "toolOuter";
        let visible = true;
        let truck = "truckSN";
        if (hubDirection === "incoming") {
          toolOuter = toolOuterIncoming(incomingTime, results[i].ata);
        }
        else {
          toolOuter = toolOuterOutgoing(outgoingTime);
        }
        if (results[i].tripStatus !== null && results[i].tripStatus !== undefined) {
          if (results[i].productLine.toLowerCase() === "dry" && results[i].tripStatus.toLowerCase() === "delayed") {
            truck = "truckSDelayed";
          }
          if (results[i].productLine.toLowerCase() !== "dry" && results[i].tripStatus.toLowerCase() === "delayed") {
            truck = "truckSNTCLDelayed";
          }
          if (results[i].productLine.toLowerCase() !== "dry" && results[i].tripStatus.toLowerCase() !== "delayed") {
            truck = "truckSNTCL";
          }
        }
        let gpsColor = results[i].gpsFix && results[i].gpsFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let obdColor = results[i].obdFix && results[i].obdFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let fuelColor = results[i].fuelFix && results[i].fuelFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let arr = "arrowTop";
        if (parseInt(direction) >= 70 && parseInt(direction) <= 300) { arr = "arrowBottom" }
        let mapPopUpComponent = "<div class='" + arr + "'></div>";
        mapPopUpComponent += '<div class="popUpTop">';
        let currDate = new Date();
        let lastCommDate = results[i].lastCommDateTime.split(" ")[0].split("/");
        let lastCommTime = results[i].lastCommDateTime.split(" ")[1]
        let gpsVal = ((new Date() - new Date(lastCommDate[1] + "/" + lastCommDate[0] + "/" + lastCommDate[2] + " " + lastCommTime)) / 1000) / 60
        mapPopUpComponent += '<div class="flex gpsGroup"><div class="flexCol" style="color:' + gpsColor + ';"><i class="fas fa-2x fa-map-marker-alt"  title="GPS"></i><span class="botText">' + parseInt(gpsVal) + '&nbsp;min</span></div>';
        mapPopUpComponent += '<i class="fas fa-2x fa-table" title="OBD" style="color:' + obdColor + ';"></i></div>';
        let tempColorRefer = results[i].tempAtReeferFix && results[i].tempAtReeferFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let tempColorMiddle = results[i].tempAtMiddleFix && results[i].tempAtMiddleFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let tempColorDoor = results[i].tempAtDoorFix && results[i].tempAtDoorFix.toLowerCase() == "yes" ? "#d40511" : "green";
        let tempReferVal = results[i].temperatureData && results[i].temperatureData.split(",")[0].split("=")[1];
        let tempMiddleVal = results[i].temperatureData && results[i].temperatureData.split(",")[1].split("=")[1];
        let tempDoorVal = results[i].temperatureData && results[i].temperatureData.split(",")[2].split("=")[1];
        let deg = "&deg;C";
        if (results[i].productLine !== "TCL") {
          tempColorRefer = tempColorMiddle = tempColorDoor = "#dfdfdf";
          tempReferVal = tempMiddleVal = tempDoorVal = "NA";
          deg = "";
        }
        mapPopUpComponent += '<div class="flex tempGroup"><div class="flexCol"style="color:' + tempColorRefer + ';"><div class="flex tempR"><i class="fas fa-2x fa-temperature-low"  title="T@Refer"></i><div class="flexRow marg8">@R</div></div><span class="botText">' + tempReferVal + deg + '</span></div>';
        mapPopUpComponent += '<div class="flexCol" style="color:' + tempColorMiddle + ';"><div class="flex tempR"><i class="fas fa-2x fa-temperature-low"  title="T@Middle"></i><div class="flexRow marg8">@M</div></div><span class="botText">' + tempMiddleVal + deg + '</span></div>';
        mapPopUpComponent += '<div class="flexCol" style="color:' + tempColorDoor + ';"><div class="flex tempR"><i class="fas fa-2x fa-temperature-low"  title="T@Door"></i><div class="flexRow marg8">@D</div></div><span class="botText">' + tempDoorVal + deg + '</span></div></div>';
        mapPopUpComponent += '<i class="fas fa-2x fa-gas-pump padBot" title="Fuel"  style="color:' + fuelColor + ';"></i>';
        mapPopUpComponent += '<i class="fas fa-2x fa-dot-circle padBot" title="Tyre Pressure"  style="color:#dfdfdf;"></i>';
        mapPopUpComponent += '<img src="' + iconPath + 'engine.png" style="margin-top:-16px;opacity:0.5;" title="Check Engine"/>';
        mapPopUpComponent += '<div class="flexCol" style="color:#d40511;"><i class="fas fa-2x fa-stop-circle"  title="Vehicle Stoppage"></i><span class="botText">' + results[i].stoppageTime + '</span></div>';
        mapPopUpComponent += '</div>';
        mapPopUpComponent += '<div class="toolTipStyle"><div class="toolTipDiv"><div class="toolTipLeft">Vehicle No: </div><div class="toolTipRight">' + results[i].vehicleNo + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Trip No: </div><div class="toolTipRight">' + results[i].tripNo + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Trip Id: </div><div class="toolTipRight">' + results[i].shipmentId + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Route Key: </div><div class="toolTipRight">' + results[i].routeKey + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Current Location: </div><div class="toolTipRight">' + results[i].location + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Distance to Next Hub: </div><div class="toolTipRight">' + results[i].distanceToNextTouchPoint + '<i title="Current Odometer Reading" class="fas fa-tachometer-alt"></i>&nbsp;' + results[i].speed + 'kmph' + '<img src="' + iconPath + 'odo.png" style="width:40px;margin:0px 0px 3px 32px"  title="Current Odometer Reading"/>&nbsp;' + results[i].currentOdometerReading + 'km</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ETA to Hub: </div><div class="toolTipRight">' + results[i].etaToNextHub + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ETA to Destination: </div><div class="toolTipRight">' + results[i].etaToDestination + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Trip Status: </div><div class="toolTipRight">' + results[i].tripStatus + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Dist. To QRT:</div><div class="toolTipRight"> NA</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Driver Name: </div><div class="toolTipRight">' + results[i].driverName + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">Driver Contact: </div><div class="toolTipRight">' + results[i].driverNumber + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ASM: </div><div class="toolTipRight">' + results[i].areaSalesManagerName + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ASM Contact: </div><div class="toolTipRight">' + results[i].areaSalesManagerContact + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDiv"><div class="toolTipLeft">ASM Email: </div><div class="toolTipRight">' + results[i].areaSalesManagerEmail + '</div></div>';
        mapPopUpComponent += '<div class="toolTipDivLast"><div class="toolTipLeft">Driver Source Hub: </div><div class="toolTipRight">' + results[i].driverSrcHub + '</div></div>';
        mapPopUpComponent += '</div></div>';
        if (visible) {
          vehDiv += '<div class="tooltipQ" style="z-index:' + zindex + '"><div class="' + toolOuter + hubDirection + '" id="divImg' + i + '" ondblclick="openVehicleOnMap(' + i + ',' + results[i].latitude + ',' + results[i].longitude + ',' + markerClusterArray.length + ')" onclick="openToolTip(' + i + ',' + direction + ')"  style="transform: rotate(' + direction + 'deg);z-index:' + zindex + '">';
          vehDiv += '<img class="truckImage" id="truck' + i + '" src="' + truck + '.png" style="' + rotate + ';z-index:' + zindex + '"></div>';
          vehDiv += '<div  id="toolTip' + i + '" class="tooltiptext" style="overflow:auto;pointer-events:all;position:fixed;z-index:10000;padding-bottom:16px;padding-right:16px;"><div class="closeTop" onclick="closePopUp(' + i + ')"><i class="fas fa-times closeSize"></i></div>' + mapPopUpComponent + '</div>';
          zindex--;
        }
        let timeToCheck = 0;
        if (hubDirection === "incoming") {
          timeToCheck = results[i].incomingTimeToNextPointDuration;
        }
        else {
          timeToCheck = results[i].outgoingTimeToNextPointDuration;
        }
        if (!results[i].latitude == 0 && !results[i].longitude == 0) {
          count++;
          let image = L.icon({
            iconUrl: String(iconPath + truck + ".png"),
            popupAnchor: [0, -15]
          });
          let marker = new L.rotatedMarker(new L.LatLng(results[i].latitude, results[i].longitude), {
            icon: image,
            angle: results[i].directionInDegree
          });
          marker.bindPopup('<div style="overflow:auto;min-width:500px !important;height: 310px !important;border:1px solid #d40511;padding:0px 16px 16px 0px;margin:16px;border-radius:8px;">' + mapPopUpComponent);
          markerCluster.addLayer(marker);
          markerClusterArray.push(marker);
        }
      }
      map.addLayer(markerCluster);
      $("#vehicles").append(vehDiv);
    }
    function showCEDashboard(tripId) {
      window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/CEDashboard.jsp?tripId=" + tripId, '_blank');
    }
    function loadTable(type, hubDirection) {
      let result = [];
      if (type === "initial") {
        result = resultInsideHub.concat(resultAllIncoming);
        $("#headerText").html("");
      }
      if (type === "inside") {
        result = resultInsideHub.concat(result0To2Hoursincoming);
        $("#headerText").html("- Inside Hub");
      }
      if (type == "all" && hubDirection == "incoming") {
        result = resultInsideHub.concat(resultAllIncoming);
        $("#headerText").html("- All Incoming");
      }
      if (type == "all" && hubDirection == "outgoing") {
        result = resultAllOutgoing;
        $("#headerText").html("- All Outgoing");
      }
      if (type == 2 && hubDirection == "incoming") {
        result = result0To2Hoursincoming;
        $("#headerText").html("- Incoming 0 To 2 Hours");
      }
      if (type == 4 && hubDirection == "incoming") {
        result = result2To4Hoursincoming;
        $("#headerText").html("- Incoming 2 To 4 Hours");
      }
      if (type == 8 && hubDirection == "incoming") {
        result = result4To8Hoursincoming;
        $("#headerText").html("- Incoming 4 To 8 Hours");
      }
      if (type == 10 && hubDirection == "incoming") {
        result = result8Plusincoming;
        $("#headerText").html("- Incoming greater than 8 Hours");
      }
      if (type == 2 && hubDirection == "ui") {
        result = result0To2HoursUI;
        $("#headerText").html("- Upcoming Indents 0 To 2 Hours");
      }
      if (type == 4 && hubDirection == "ui") {
        result = result2To4HoursUI;
        $("#headerText").html("- Upcoming Indents 2 To 4 Hours");
      }
      if (type == 8 && hubDirection == "ui") {
        result = result4To8HoursUI;
        $("#headerText").html("- Upcoming Indents 4 To 8 Hours");
      }
      if (type == 10 && hubDirection == "ui") {
        result = result8PlusinUI;
        $("#headerText").html("- Upcoming Indents greater than 8 Hours");
      }
      if (type == 2 && hubDirection == "di") {
        result = result0To2HoursDI;
        $("#headerText").html("- Delayed Indents 0 To 2 Hours");
      }
      if (type == 4 && hubDirection == "di") {
        result = result2To4HoursDI;
        $("#headerText").html("- Delayed Indents 2 To 4 Hours");
      }
      if (type == 8 && hubDirection == "di") {
        result = result4To8HoursDI;
        $("#headerText").html("- Delayed Indents 4 To 8 Hours");
      }
      if (type == 10 && hubDirection == "di") {
        result = result8PlusDI;
        $("#headerText").html("- Delayed Indents greater than 8 Hours");
      }
      if (type == 2 && hubDirection == "ld") {
        result = result0To2HoursLD;
        $("#headerText").html("- Loading Detention 0 To 2 Hours");
      }
      if (type == 4 && hubDirection == "ld") {
        result = result2To4HoursLD;
        $("#headerText").html("- Loading Detention 2 To 4 Hours");
      }
      if (type == 8 && hubDirection == "ld") {
        result = result4To8HoursLD;
        $("#headerText").html("- Loading Detention 4 To 8 Hours");
      }
      if (type == 10 && hubDirection == "ld") {
        result = result8PlusLD;
        $("#headerText").html("- Loading Detention greater than 8 Hours");
      }
      if (type == 2 && hubDirection == "uld") {
        result = result0To2HoursULD;
        $("#headerText").html("- Unloading Detention 0 To 2 Hours");
      }
      if (type == 4 && hubDirection == "uld") {
        result = result2To4HoursULD;
        $("#headerText").html("- Unloading Detention 2 To 4 Hours");
      }
      if (type == 8 && hubDirection == "uld") {
        result = result4To8HoursULD;
        $("#headerText").html("- Unloading Detention 4 To 8 Hours");
      }
      if (type == 10 && hubDirection == "uld") {
        result = result8PlusULD;
        $("#headerText").html("- Unloading Detention greater than 8 Hours");
      }
      if (type == 2 && hubDirection == "outgoing") {
        result = result0To2Hoursoutgoing;
        $("#headerText").html("- Outgoing 0 To 2 Hours");
      }
      if (type == 4 && hubDirection == "outgoing") {
        result = result2To4Hoursoutgoing;
        $("#headerText").html("- Outgoing 2 To 4 Hours");
      }
      if (type == 8 && hubDirection == "outgoing") {
        result = result4To8Hoursoutgoing;
        $("#headerText").html("- Outgoing 4 To 8 Hours");
      }
      if (type == 10 && hubDirection == "outgoing") {
        result = result8Plusoutgoing;
        $("#headerText").html("- Outgoing greater than 8 Hours");
      }
      if (type == "loading") {
        result = resultLoadingDetention;
        $("#headerText").html("- Loading Detention");
      }
      if (type == "unloading") {
        result = resultUnloadingDetention;
        $("#headerText").html("- UnLoading Detention");
      }
      if (type == "atloading") {
        result = resultAtLoading;
        $("#headerText").html("- At Loading Detention");
      }
      if (type == "atunloading") {
        result = resultAtUnLoading;
        $("#headerText").html("- At unLoading Detention");
      }
      if (type == "SHDETENTION") {
        result = resultShDetention;
        $("#headerText").html("- SmartHub Detention");
      }
      if (type == "UPCOMINGINDENTS") {
        result = resultUpcomingIndents;
        $("#headerText").html("- Upcoming Indents");
      }
      if (type == "DELAYEDINDENTS") {
        result = resultDelayedIndents;
        $("#headerText").html("- Delayed Indents");
      }
      if (type == "ODO") {
        result = resultODO;
        $("#headerText").html("- ODO Non Compliances");
      }
      if (type === "DELAYED") {
        result = resultDelayedincoming.concat(resultDelayedoutgoing);
        $("#headerText").html("- Delayed");
      }
      if (type === "GPS") {
        result = resultGPSincoming.concat(resultGPSoutgoing)
        $("#headerText").html("- Fix GPS");
      }
      if (type === "TEMP") {
        result = resultTempincoming.concat(resultTempoutgoing)
        $("#headerText").html("- Fix Temperature");
      }
      if (type === "FUEL") {
        result = resultFuelincoming.concat(resultFueloutgoing)
        $("#headerText").html("- Top-up Fuel");
      }
      if (type == "alerts") {
        result = resultAlertincoming.concat(resultAlertoutgoing);
      }
      let trips = [];
      let slNo = 0;
      result.forEach(function (item) {
        let trip = [];
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.tripId);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.routeId);
        trip.push(item.endDateForMap === undefined ? "" : item.endDateForMap);
        trip.push(item.tripCreationTime === undefined ? "" : item.tripCreationTime);
        trip.push('<span class="pointer hyperlink" onClick="showCEDashboard(\'' + item.tripId + '\',\'' + item.vehicleNo + '\',\'' + item.std + '\',\'' + item.endDateForMap + '\',\'' + item.completeStatus + '\',\'' + item.routeId + '\')">' + item.tripNo + '</span>');
        (item.tripId === undefined || item.tripId === 0) ? trip.push('<span title="">' + item.vehicleNo + '</span>') :
          trip.push('<span class="pointer hyperlink" onClick="showTripAndAlertDetails(\'' + item.tripId + '\',\'' + item.vehicleNo + '\',\'' + item.std + '\',\'' + item.endDateForMap + '\',\'' + item.completeStatus + '\',\'' + item.routeId + '\')">' + item.vehicleNo + '</span>');
        let indentDate = new Date(new Date().setHours(new Date().getHours() + (parseInt(item.suggestedTimeForDispatch) / 60)));
        let dateToShow = indentDate.getDate().toString().padStart(2, "0") + "/" + (indentDate.getMonth() + 1).toString().padStart(2, "0") + "/" + indentDate.getFullYear() + " " + indentDate.getHours().toString().padStart(2, "0") + ":" + indentDate.getMinutes().toString().padStart(2, "0") + ":" + indentDate.getSeconds().toString().padStart(2, "0");
        trip.push((item.atp === "" && item.suggestedTimeForDispatch !== null) ? dateToShow : "");
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : '<span title="' + item.routeName + '">' + item.routeName.substr(0, 25).toUpperCase() + "...</span>");
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.routeKey);
        trip.push((item.tripId === undefined || item.tripId === 0) ? (item.gpsLocation != null ? '<span title="' + item.gpsLocation + '">' + item.gpsLocation.substr(0, 25).toUpperCase() + '...</span>' : "") : '<span title="' + item.location + '">' + item.location.substr(0, 25).toUpperCase() + '...</span>');
        trip.push(item.productLine === undefined ? "" : item.productLine);
        trip.push(item.tripCategory === undefined ? "" : item.tripCategory);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : '<span title="' + item.shipmentId + '">' + item.shipmentId.substr(0, 25).toUpperCase() + "...</span>");
        trip.push(item.tripCustomerRefId === undefined ? "" : item.tripCustomerRefId);
        trip.push(item.tripCustomerType === undefined ? "" : item.tripCustomerType);
        trip.push(item.make === undefined ? "" : item.make);
        trip.push(item.vehicleType === undefined ? "" : item.vehicleType);
        trip.push((item.driverName == "" || item.driverName == null) ? "" : item.driverName.split("/")[0]);
        trip.push((item.driverNumber == "" || item.driverNumber == null) ? "" : item.driverNumber.split("/")[0]);
        trip.push((item.driverName == "" || item.driverName == null || item.driverName.split("/")[1] == null) ? "" : item.driverName.split("/")[1]);
        trip.push((item.driverNumber == "" || item.driverNumber == null || item.driverNumber.split("/")[1] == null) ? "" : item.driverNumber.split("/")[1]);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.originCity);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.destinationCity);
        trip.push(item.stp === undefined ? "" : item.stp);
        trip.push(item.atp === undefined ? "" : item.atp);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.placementDelay)
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.loadingDetention.includes("-") ? "00:00:00" : item.loadingDetention);
        trip.push(item.std === undefined ? "" : item.std);
        trip.push(item.atd === undefined ? "" : item.atd);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.delayedDepartureATDwrtSTD);
        trip.push(item.nextTouchPoint === undefined ? "" : item.nextTouchPoint);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.distanceToNextTouchPoint);
        trip.push(item.etaToNextTouchPoint === undefined ? "" : item.etaToNextTouchPoint);
        trip.push(item.staWrtStd === undefined ? "" : item.staWrtStd);
        trip.push(item.staWrtAtd === undefined ? "" : item.staWrtAtd);
        trip.push(item.eta === undefined ? "" : item.eta);
        trip.push(item.ata === undefined ? "" : item.ata);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.plannedTransitTime);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.actualTransitTime);
        if (item.atd == null || item.atd == 0 || item.atd == '') {
          trip.push((item.tripId === undefined || item.tripId === 0) ? "" : '00:00:00')
        } else {
          trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.transitDelay);
        }
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.completeStatus);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.totalDistance);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.avgSpeed);
        trip.push(item.endDate === undefined ? "" : item.endDate); //Trip closure cancellation Datetime
        trip.push(item.cancelledRemarks === undefined ? "" : item.cancelledRemarks);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.unloadingDetention);
        trip.push(item.lastCommunicationStamp === undefined ? "" : item.lastCommunicationStamp);
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.stoppageDuration);
        trip.push(item.currentOdometerReading);
        trip.push(item.fuelQuantity ? item.fuelQuantity : "");
        trip.push(item.areaSalesManagerName);
        trip.push(item.areaSalesManagerEmail);
        trip.push(item.areaSalesManagerContact);
        trip.push(item.driverSrcHub);
        trip.push("");
        trip.push("");
        trip.push("");
        let totalLoss = 0;
        let ld = item.loadingDetention.split(":")[0];
        let unld = item.unloadingDetention.split(":")[0];
        if (item.productLine.toLowerCase() === "dry") {
          totalLoss = (parseInt(ld) * 2000) + (parseInt(unld) * 2000);
        }
        else {
          totalLoss = (parseInt(ld) * 4000) + (parseInt(unld) * 4000);
        }
        trip.push(totalLoss < 0 ? "0" : totalLoss);
        trip.push("");
        trip.push("");
        trip.push((item.tripId === undefined || item.tripId === 0) ? "" : item.distanceToNextTouchPoint);
        trip.push(item.srcCustomerName);
        trip.push(item.srcCustomerEmail);
        trip.push(item.srcCustomerContactNumber);
        trip.push(item.odoRoute? item.odoRoute: "");
        if (item.tripId === undefined || item.tripId === 0) {
          trips.unshift({
            ...trip
          });
        } else {
          trips.push({
            ...trip
          });
        }
      })
      trips.reverse();
      let tempTrips = [];
      for (var i = 0; i < trips.length; i++) {
        let t = Object.values(trips[i]);
        t.unshift(++slNo);
        tempTrips.push(t);
      }
      trips = tempTrips;
      if (initialLoad) {
        intialLoad = !initialLoad;
        if ($.fn.DataTable.isDataTable("#tripDatatable")) {
          $('#tripDatatable').DataTable().clear().destroy();
        }
        tableMain = $('#tripDatatable').DataTable({
          data: trips,
          paging: true,
          "bLengthChange": true,
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
          { "className": "dt-center", "targets": [4] },
          { "name": "TripCreationTime", "targets": 5 },
          { "name": "Trip_No", "targets": 6 },
          { "name": "vehicleNo", "targets": 7 },
          { "name": "Customer_Name", "targets": 8 },
          { "name": "Route_ID", "targets": 9 },
          { "name": "Route_Key", "targets": 10 },
          { "name": "Location", "targets": 11 },
          { "name": "Trip_Type", "targets": 12 },
          { "name": "Trip_Category", "targets": 13 },
          { "name": "Trip ID", "targets": 14 },
          { "name": "Customer_Reference_ID", "targets": 15 },
          { "name": "Customer_Type", "targets": 16 },
          { "name": "Make_of_Vehicle", "targets": 17 },
          { "name": "Type_of_Vehicle", "targets": 18 },
          { "name": "Driver1_Name", "targets": 19 },
          { "name": "Driver1_Contact", "targets": 20 },
          { "name": "Driver2_Name", "targets": 21 },
          { "name": "Driver2_Contact", "targets": 22 },
          { "name": "Origin_City", "targets": 23 },
          { "name": "Destination_City", "targets": 24 },
          { "name": "STP", "targets": 25 },
          { "name": "ATP", "targets": 26 },
          { "name": "Placement_Delay", "targets": 27 },
          { "name": "Origin_Hub(Loading)_Detention", "targets": 28 },
          { "name": "STD", "targets": 29 },
          { "name": "ATD", "targets": 30 },
          { "name": "Departure Delay wrt STD", "targets": 31 },
          { "name": "Next_Touching_Point", "targets": 32 },
          { "name": "Distance_To_NextHub", "targets": 33 },
          { "name": "ETA_to_next_Touching_Point", "targets": 34 },
          { "name": "STA (WRT STD)", "targets": 35 },
          { "name": "STA (WRT ATD)", "targets": 36 },
          { "name": "ETA", "targets": 37 },
          { "name": "ATA", "targets": 38 },
          { "name": "Planned_Transit_Time", "targets": 39 },
          { "name": "Actual_Transit_Time ", "targets": 40 },
          { "name": "Transit_Delay", "targets": 41 },
          { "name": "Trip_Status", "targets": 42 },
          { "name": "Total_Distance", "targets": 43 },
          { "name": "Average_Speed", "targets": 44 },
          { "name": "Trip_Closure_Date_Time", "targets": 45 },
          { "name": "Reason_For_Cancellation", "targets": 46 },
          { "name": "Destination_hub(Unloading)_Detention", "targets": 47 }
          ],
          buttons: [
            $.extend(true, {}, buttonCommon, {
              extend: 'excelHtml5',
              text: 'EXPORT TO EXCEL',
              title: 'Trip Details',
              className: 'btn btn-primary excelWidth',
              exportOptions: {
                columns: ':visible'
              }
            })
          ]
        });
      } else {
        $('#tripDatatable').DataTable().clear();
        tableMain.rows.add(trips);
        tableMain.draw();
      }
      $("#loading-div").hide();
    }
    var buttonCommon = {
      exportOptions: {
        format: {
          body: function (data, row, column, node) {
            if (column === 5 || column === 7 || column === 10) {
              let ret = data.replace('<span title="', '');
              return ret.split('">')[0];
            } else {
              if (column === 2 || column === 3) {
                return (data != null && data != "" && data != undefined) ? data.split('">')[1].split("</span>")[0] : data;
              } else {
                return data;
              }
            }
          }
        }
      }
    };
    $('#tripDatatable tbody').on('click', 'td', function () {
      let data = table.row(this).data();
      let columnIndex = table.cell(this).index().column;
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
    function showTripAndAlertDetails(tripNo, vehicleNo, startDate, endDate, status, routeId) {
      var startDate = startDate.replace(/-/g, " ");
      var endDate = endDate.replace(/-/g, " ");
      var actualDate = "";
      window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
    }
  </script>
<jsp:include page="../Common/footer.jsp" />
