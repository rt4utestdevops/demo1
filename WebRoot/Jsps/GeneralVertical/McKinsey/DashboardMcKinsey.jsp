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
        boolean isAdmin=( "Admin".equals(userAuthority)) ?true : false;
		String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		String GoogleAPIKEY = GoogleApiKey + "&libraries=places,drawing";
		String pageName =  "/Jsps/GeneralVertical/CreateTrip.jsp";
		boolean hasTripCreatePermission = adminFunction.checkUserProcessPermission(systemId,loginInfo.getUserId(),pageName);

    HistoryAnalysisFunction hTrackingFunctions = new HistoryAnalysisFunction();
  	ArrayList unitOfMeasurementList= hTrackingFunctions.getUnitDetails(systemId);
  	String unitOfMeasurement=unitOfMeasurementList.get(0).toString();

	 %>
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
  <link rel="icon" type="image/png" href="assets/img/favicon1.png">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>
    Rane T4U
  </title>
  <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport'
  />
  <!--     Fonts and icons     -->
  <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons"
  />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
  <!-- CSS Files -->
  <link href="assets/css/material-dashboard.css?v=2.1.0" rel="stylesheet" />
  <!-- CSS Just for demo purpose, don't include it in your project -->
  <link href="assets/demo/demo.css" rel="stylesheet" />
  <style>
    .table>tbody>tr>td,
    .table>tfoot>tr>td {
      padding: 2px;
    }

    .table {table-layout:fixed !important;text-align:left !important; }

    table th {
      font-size: 16px !important};
    }

    .tbody-scroll {
      overflow: scroll;
    }

    .btn-dropdown {
      background: #3A5A85;
      color: white;
      width: 100%;
      text-align: left;
    }

    .veh-table {
      text-align: left;
      margin-top: 10px;
    }

    .vehicle-param-list {
      display: flex;
      flex-direction: row;
      width: 100%;
      flex-wrap: wrap;
      padding: 0px 10px;
    }

    .vehicle-param-item {
      border: 2px solid #f7f7f7;
      flex-grow: 0;
      flex-shrink: 0;
      flex-basis: calc(100%/3);
      padding: 3px;
    }

    .vehicle-param-item>.param-name {
      font-size: 0.8rem;
    }

    .vehicle-param-item>.param-val {
      font-size: 0.8rem;
      color: #C51B28;
    }

    .vehicle-param-item>.material-icons {
      font-size: 1.04rem;
    }
    .flex{
      display: flex;
    }
    .smallFont {
      font-size:11px
    }

    .leftElement{
      cursor:pointer;width:35%;border-right:1px solid #D5D5D5;padding:4px 8px 4px 8px;
    }
    .leftElementSmall{
      cursor:pointer;width:40%;padding-left:8px;
    }
    .leftElementLoading{
      cursor:pointer;width:60%;border-right:1px solid #D5D5D5;padding:4px 8px 4px 8px;
    }
    .rightElement{
      cursor:pointer;width:40%;padding:4px 8px 4px 16px;
    }

    .card-header-new-height{
      height: 48px;
      padding: 10px !important;
      -webkit-box-shadow: none !important;
	     -moz-box-shadow: none !important;
	      box-shadow: none !important;
    }

    .rightDivStyle{
      padding-left: 16px;
      padding-bottom:8px;
      padding-top:8px;
      border-bottom:1px solid #D5D5D5;
      display:flex;
    }

    div.dataTables_wrapper {
        margin: 0 auto;
        padding:0px;
    }

table1 {
font-size: smaller;
}
table2 {
font-size: smaller;
}

.dataTables_scrollBody{
  overflow-y: auto !important;
  overflow-x: hidden !important;
}

.heightCardHeader{
  height:32px;
}

.cardTitleMargin{
  margin-top:-5px !important;
}

.highlight {
  background: #86A3D8 !important;
  color:white !important;
}

.select2 {
  width: 99% !important;
    margin-top: 16px !important;
    margin-bottom: -8px !important;
    text-align: left !important;


}

.table-responsive{
  overflow:hidden;
}

/* width */
::-webkit-scrollbar {
    width: 8px;

}

/* Track */
::-webkit-scrollbar-track {
    background: #f1f1f1;
       border-radius:8px
}

/* Handle */
::-webkit-scrollbar-thumb {
    background: #888;
       border-radius:8px
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background: #555;
}

  </style>
  <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
</head>

<body class="">
  <div id="loading" style="position:absolute;width:100%;height:100vh;top:0;left:0;display:none;background:#dfdfdf;opacity:0.6;z-index:10000;">
  	<div style="position:absolute;top:40%;left:50%;z-index:3">
  	<img src="../../../Main/images/loading.gif" alt=""></div>
  </div>
  <div class="wrapper ">
    <div class="sidebar" data-image="bg.png" data-color="purple" data-background-color="white">
      <div class="logo">
        <a href="#" class="simple-text" style="background:#093166;margin-top:-6px;padding:8px;">
          <img src="http://www.ranet4u.com/images/logo.png" style="width:140px;" alt="logo" />
        </a>
      </div>
      <div class="sidebar-wrapper">
        <ul class="nav">
          <li class="nav-item active  ">
            <a class="nav-link" href="DashboardMcKinsey.jsp">
              <i class="material-icons">dashboard</i>
              <p>Current Status</p>
            </a>
          </li>
          <li class="nav-item" onclick="$('#childpast').toggle()">
            <a class="nav-link" href="#">
              <i class="material-icons">history</i>
              <p>Past Performance</p>
            </a>
            <ul id="childpast" class="nav" style="margin-left:40px;margin-top:8px;display:none;">
              <li class="nav-item ">
                <a class="nav-link" href="scorecard.jsp">
                  <i class="material-icons">score</i>
                  <p>Scorecard</p>
                </a>
              </li>
              <li class="nav-item  ">
                <a class="nav-link" href="reports.jsp">
                  <i class="material-icons">table_chart</i>
                  <p>Reports</p>
                </a>
              </li>
            </ul>
          </li>
          <li class="nav-item  ">
            <a class="nav-link" href="future.jsp">
              <i class="material-icons">multiline_chart</i>
              <p>Future Optimization</p>
            </a>
          </li>
          <!-- your sidebar here -->
        </ul>
      </div>
    </div>
    <div class="main-panel" style="overflow-y:auto !important;">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-transparent navbar-absolute fixed-top ">
        <div class="container-fluid">
          <div class="card card-nav-tabs card-plain">
            <div class="card-header card-header-info card-header-nav">
              <!-- colors: "header-primary", "header-info", "header-success", "header-warning", "header-danger" -->
              <div class="nav-tabs-navigation">
                <div class="nav-tabs-wrapper">
                  <div style="display:flex;flex-wrap:wrap;">
                    <div>
                      <button class="navbar-toggler" type="button" data-toggle="collapse" aria-controls="navigation-index"
                        aria-expanded="false" aria-label="Toggle navigation">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="navbar-toggler-icon icon-bar">
                          <div class="logo">
                            <a href="" class="simple-text logo-normal">
                              <img src="logo.png" alt="logo" />
                            </a>
                          </div>
                        </span>
                        <span class="navbar-toggler-icon icon-bar"></span>
                        <span class="navbar-toggler-icon icon-bar"></span>
                      </button>
                    </div>
                    <div>
                      <h4 style="margin-top:8px">CURRENT STATUS</h4>
                    </div>

                 </div>
                 <ul class="nav nav-tabs navAlign"  data-tabs="tabs">

                   <li class="nav-item">
                     <a id="snapshotHeader" class="nav-link active" href="#snapshot" data-toggle="tab">Snapshot</a>
                   </li>
                   <li class="nav-item">
                     <a id="actionHeader" class="nav-link" href="#action" data-toggle="tab">Action</a>
                   </li>
                   <li class="nav-item">
                     <a id="shipmentHeader" class="nav-link" href="#shipment" data-toggle="tab">Shipment</a>
                   </li>
                 </ul>

                </div>
              </div>
            </div>
            <div class="card-body ">
              <div class="tab-content text-center">
                <div class="tab-pane active" id="snapshot">
                  <div class="row" style="margin-top:-12px;">
                    <div class="col-xs-12 col-md-12 col-lg-3">
                      <div class="card">
                        <div class="card-body">
                          <div id="inTransit" style="cursor:pointer;" class="card-header card-header-new-height  card-header-info">
                            <div class="flex">
                              <div style="width:50%;text-align:left;"><img src="assets/icons/delivery-van.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;In Transit
                              </div>
                              <div style="width:50%"><div id="inTransitCount" style="border-radius:16px;background:#ffffff !important;float:right;width:80px;color:#093166;font-weight:bold;"></div>
                              </div>
                            </div>
                          </div>
                          <div class="flex" style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div  style="cursor:pointer;width:48%;border-right:1px solid #D5D5D5;padding:4px 8px 4px 8px;">On-Time</div>
                            <div id="onTime" style="cursor:pointer;color:green;font-weight:bold;width:52%;text-align:center;padding-top:4px;"></div>
                          </div>
                          <div class="flex" style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div style="cursor:pointer;width:48%;border-right:1px solid #D5D5D5;padding:4px 8px 4px 8px;">Delayed Hub Exit</div>
                            <div id="delayedHubDeparture" style="cursor:pointer;color:#34d334;font-weight:bold;width:52%;text-align:center;padding-top:4px;"></div>
                          </div>
                          <div class="flex" id="delayedLessThanOneHour"  style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div class="leftElement" style="padding-top:8px;">Delayed <1hr</div>
                            <div style="cursor:pointer;width:65%">
                               <div class="flex">
                                 <div id="delayLess" style="width:20%;border-right:1px solid #D5D5D5;text-align:center;padding-top:8px;color:orange;font-weight:bold;"></div>
                                 <div style="width:80%;">
                                   <div class="flex" style="border-bottom:1px solid #D5D5D5;">
                                     <div class="smallFont leftElementSmall" style="width:90%;">Unplanned Stoppage</div>
                                     <div id="stoppageDelayLess" style="width:20%;border-left:1px solid #D5D5D5;text-align:center;color:orange;font-weight:bold;"></div>
                                   </div>
                                   <div class="flex">
                                     <div class="smallFont leftElementSmall" style="width:90%;">Route Deviation</div>
                                     <div id="deviationDelayless" style="width:20%;border-left:1px solid #D5D5D5;text-align:center;color:orange;font-weight:bold;"></div>
                                   </div>
                                 </div>
                               </div>
                            </div>
                          </div>
                          <div id="delayedGreaterThanOneHour"  class="flex" style="text-align:left;">
                            <div class="leftElement">Delayed >1hr</div>
                            <div style="cursor:pointer;width:65%">
                              <div class="flex">
                                <div id="delayGreater" style="width:20%;border-right:1px solid #D5D5D5;text-align:center;padding-top:8px;color:red;font-weight:bold;"></div>
                                <div style="width:80%;">
                                  <div class="flex" style="border-bottom:1px solid #D5D5D5;">
                                    <div class="smallFont leftElementSmall" style="width:90%;">Unplanned Stoppage</div>
                                      <div id="stoppagedelayGreater" style="width:20%;border-left:1px solid #D5D5D5;text-align:center;color:red;font-weight:bold;"></div>
                                  </div>
                                  <div class="flex">
                                    <div class="smallFont leftElementSmall" style="width:90%;">Route Deviation</div>
                                    <div id="deviationDelayGreater" style="width:20%;border-left:1px solid #D5D5D5;text-align:center;color:red;font-weight:bold;"></div>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>

                          <div id="loadingUnloadingDiv" style="cursor:pointer;margin-top:4px !important;"  class="card-header card-header-new-height  card-header-info">
                            <div class="flex">
                              <div style="width:70%;text-align:left;"><img src="assets/icons/loading-unloading-area.png" style="margin-top:-4px;width:20px;"/>&nbsp;&nbsp;&nbsp;Loading/Unloading
                              </div>
                              <div id="loadingUnloadingCount" style="width:30%"><div id="loadingUnloading" style="border-radius:16px;background:#ffffff !important;float:right;width:80px;color:#093166;font-weight:bold;"></div>
                              </div>
                            </div>
                          </div>
                          <div class="flex" style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div class="leftElementLoading">On-Time</div>
                            <div id="onTimeLoading" class="rightElement" style="cursor:pointer;color:green;text-align:center;font-weight:bold;"></div>
                          </div>
                          <div class="flex" id="delayedLessThanOneHourLoading"  style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div class="leftElementLoading" style="padding-top:8px;">Delayed <1hr</div>
                            <div id="loadUnloadLess" class="rightElement" style="cursor:pointer;text-align:center;color:orange;font-weight:bold;">
                            </div>
                          </div>
                          <div id="delayedGreaterThanOneHourLoading"  class="flex" style="text-align:left;">
                            <div class="leftElementLoading">Delayed >1hr</div>
                            <div id="loadUnloadGreater" class="rightElement" style="cursor:pointer;text-align:center;color:red;font-weight:bold;">
                            </div>
                          </div>

                          <div style="margin-top:8px !important;" class="card-header card-header-new-height  card-header-info">
                            <div class="flex">
                              <div style="width:60%;text-align:left;"><img src="assets/icons/help-button.png" style="margin-top:-4px;width:16px;"/>&nbsp;&nbsp;&nbsp;Un-utilized Vehicles
                              </div>
                              <div  style="width:40%"><div id="unUtilizedVeh" style="border-radius:16px;background:#ffffff !important;float:right;width:80px;color:#093166;font-weight:bold;">6</div>
                              </div>
                            </div>
                          </div>

                          <div class="flex" id="delayedLessThanOneHourLoading"  style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div class="leftElementLoading" style="padding-top:8px;">In-Transit to loading pts</div>
                            <div class="rightElement" id="enroute" style="cursor:pointer;text-align:center;color:green;font-weight:bold;"></div>
                          </div>
                          <div class="flex" style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div class="leftElementLoading">Waiting for Instructions</div>
                            <div id="waitingInstructions" class="rightElement" style="cursor:pointer;text-align:center;color:red;font-weight:bold;">3</div>
                          </div>
                          <div class="flex" style="border-bottom:1px solid #D5D5D5;text-align:left;">
                            <div class="leftElementLoading">Truck Under Maintenance</div>
                            <div id="underMaintenance" class="rightElement" style="cursor:pointer;text-align:center;color:orange;font-weight:bold;">0</div>
                          </div>


                          <div  style="margin-top:8px !important;"  class="card-header card-header-new-height  card-header-info">
                             <div class="flex">
                                <div style="width:70%;text-align:left;"><img src="assets/icons/signal.png" style="margin-top:-4px;width:16px;"/>&nbsp;&nbsp;&nbsp;Vehicle Not reporting
                                </div>
                                <div style="width:30%"><div id="nonReporting" style="border-radius:16px;background:#ffffff !important;float:right;width:80px;color:#093166;font-weight:bold"></div>
                                </div>
                              </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-6" style="padding:0px;margin:0px;">
                      <div class="tab-pane active" id="map" style="margin:16px 0px 16px 0px !important;height:80vh;padding:0px !important"></div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-3">
                      <select id="selectVehicleIdSnapshot">
                        <option value="0">Select Vehicle Id</option>
                       <option value="volvo">Vehicle 1</option>
                       <option value="saab">Vehicle 2</option>
                       <option value="mercedes">Vehicle 3</option>
                       <option value="audi">Vehicle 4</option>
                      </select>
                      <div class="card">
                        <div class="card-body" style="text-align:left;">
                          <div class="card-header card-header-new-height  card-header-info">
                            &nbsp;<img src="assets/icons/car.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Vehicle Safety / Diagnostic Alerts
                          </div>
                          <div class="rightDivStyle" style="margin-top:8px;">
                             <div style="width:80%"><img src="assets/icons/gas-station.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Low Fuel</div>
                             <div id="fuel" style="color:red;cursor:pointer;font-weight:bold;">0</div>
                          </div>
                          <div class="rightDivStyle">
                            <div style="width:80%"><img src="assets/icons/battery.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Low Battery</div>
                            <div id="battery" style="color:red;cursor:pointer;font-weight:bold;">0</div>
                          </div>
                          <div class="rightDivStyle">
                            <div style="width:80%"><img src="assets/icons/rainy-day-weather-symbol.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Weather Alert</div>
                            <div id="weather" style="color:red;cursor:pointer;font-weight:bold;">0</div>
                          </div>
                          <div class="rightDivStyle">
                            <div style="width:80%"><img src="assets/icons/speedometer.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Speed Alert</div>
                            <div id="speedAlertCount" style="color:red;cursor:pointer;font-weight:bold;">0</div>
                          </div>
                          <div class="rightDivStyle">
                            <div style="width:80%"><img src="assets/icons/thermometer.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Temperature Alert</div>
                            <div id="temperature" style="color:red;cursor:pointer;font-weight:bold;">0</div>
                          </div>
                          <div class="rightDivStyle" style="border-bottom:none;">
                            <div style="width:80%"><img src="assets/icons/crash.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Crash Detection</div>
                            <div id="crash" style="color:red;cursor:pointer;font-weight:bold;">0</div>
                          </div>
                          <span id="vehicleDetails" style="display:none;">
                          <div class="card-header card-header-new-height card-header-info" style="margin-top:4px !important;">
                            <img src="assets/icons/writing.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Selected Vehicle Details
                            <img id="cancelSelect" src="assets/icons/cancel.png" style="cursor:pointer;margin-top:6px;width:12px;float:right;margin-right:4px;"/>
                          </div>
                          <div style="padding-left:16px;padding-top:8px;">
                            <div style="display:flex"><div style="width:50%;font-weight:bold;">Alert Type: </div><div style="width:50%" id="alertTypeDetails"></div></div>
                            <div style="display:flex"><div style="width:50%;font-weight:bold;">Alert Description: </div><div style="width:50%" id="alertDescDetails"></div></div>
                              <div style="display:flex"><div style="width:50%;font-weight:bold;">Registration No.: </div><div style="width:50%" id="vehicleNoDetails"></div></div>
                              <div style="display:flex"><div style="width:50%;font-weight:bold;">Driver Details: </div><div  style="width:50%"id="driverNameDetails"></div></div>
                              <div style="display:flex"><div style="width:50%;font-weight:bold;">Route Description: </div><div style="width:50%" id="routeDescDetails"></div></div>
                          </div>
                          <div style="display:flex;text-align:center;margin-top:8px;">
                          <div style="width:50%"><button style="width:90%;padding:4px" type="button" class="btn btn-success">Call Driver</button></div>
                          <div style="width:50%"><button id="btnAction" style="width:90%;padding:4px;" type="button" class="btn btn-success">Action</button></div>
                         </div>
                           <div style="text-align:center;"><button id="btnDeepDive" style="padding:4px;margin-top:16px;width:50%;background:#3700B3 !important" type="button" class="btn btn-success">Deep-Dive</button></div>
                        </span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="tab-pane" id="action">
                  <div class="row" style="margin-top:32px;">
                    <div class="col-xs-12 col-md-12 col-lg-8">
                      <div class="card-header card-header-new-height card-header-info" style="padding:4px;height:32px;">
                        <h5 class="card-title cardTitleMargin">In-Transit Delay Alerts</h5>
                      </div>
                      <div class="card-body" style="margin-top:-16px;">
                        <div class="table-responsive">
                          <table id="table1" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                            <thead>
                               <tr>
                                  <th>Shipment Id</th>
                                  <th>Route Detail</th>
                                  <th>Alert Type</th>
                                  <th>Alert Description</th>
                                  <th>Remarks</th>
                                </tr>
                            </thead>
                          </table>
                        </div>
                      </div>

                      <div class="card-header card-header-new-height card-header-info" style="padding:4px;height:32px;margin-top: -16px !important;">
                        <h5 class="card-title cardTitleMargin">Truck Detention Alerts</h5>
                      </div>
                      <div class="card-body" style="margin-top:-16px;">
                        <div class="table-responsive">
                          <table id="table2" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                            <thead>
                               <tr>
                                  <th>Shipment Id</th>
                                  <th>Route Detail</th>
                                  <th>Alert Type</th>
                                  <th>Alert Description</th>
                                  <th>Remarks</th>
                                </tr>
                            </thead>
                          </table>
                        </div>
                      </div>

                      <div class="card-header card-header-new-height card-header-info" style="padding:4px;height:32px;margin-top: -16px !important;">
                        <h5 class="card-title cardTitleMargin">Vehicle Safety / Diagnostic Alerts</h5>
                      </div>
                      <div class="card-body" style="margin-top:-16px;">
                        <div class="table-responsive">
                          <table id="table3" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                            <thead>
                               <tr>
                                  <th>Shipment Id</th>
                                  <th>Route Detail</th>
                                  <th>Alert Type</th>
                                  <th>Alert Description</th>
                                  <th>Remarks</th>
                                </tr>
                            </thead>
                          </table>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-4">
                      <div class="tab-pane active" id="map1" style="margin:-32px 0px 0px 0px !important;height:40vh;padding:0px !important"></div>
                      <div class="card" style="display:none;" id="alertActionCard">
                        <div class="card-body" style="position:relative;text-align:left;">
                          <div class="card-header card-header-new-height card-header-info">
                            ALERT ACTION
                            <img id="cancelAlertAction" src="assets/icons/cancel.png" style="cursor:pointer;margin-top:6px;width:12px;float:right;margin-right:4px;"/>
                          </div><div style="margin-left:24px;">
                          <div style="display:flex;margin-top:8px;"><div style="width:40%;font-weight:bold;">Alert Desc: </div><div style="width:60%" id="alertDescCard"></div></div>
                          <div style="display:flex"><div style="width:40%;font-weight:bold;">Vehicle No.: </div><div style="width:60%" id="vehicleNoCard"></div></div>
                          <div style="display:flex"><div style="width:40%;font-weight:bold;">Shipment Id: </div><div style="width:60%;cursor:pointer;color:blue;" id="shipmentIdCard"></div></div>
                          <div style="display:flex"><div style="width:40%;font-weight:bold;">Route Desc: </div><div  style="width:60%"id="routeDescCard"></div></div>
                          <div style="display:flex"><div style="width:40%;font-weight:bold;">Driver Details: </div><div style="width:60%" id="driverNameCard"></div></div>
                          <div style="display:flex;margin-bottom:8px;" id="remarksWrapper"><div style="width:40%;font-weight:bold;">Remarks: </div><div style="width:60%" id="remarksCard"></div></div>
                          <div style="display:flex;margin-bottom:8px;display:none;" id="remarksSaved"><div style="width:100%;font-weight:bold;color:green;">Remarks Saved Successfully</div></div>

                          <button type="button" style="padding:4px;position:absolute;top:48px;right:16px;" id="btnCallDriver" class="btn btn-success">Call Driver</button>
                          <textarea id = "alertActionRemarks" row="2" style="width:80%"> </textarea>
                          <button type="button" style="padding:8px;margin-top:-28px;" id="btnAlertAction" class="btn btn-success" onclick="saveRemarks()" >Action</button>
                          <br/></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="tab-pane" id="shipment">
                  <div class="row" style="margin-top:-16px;">
                    <div class="col-xs-12 col-md-12 col-lg-4">
                      <select id="selectVehicleIdShipment" >
                        <option value="0">Select Vehicle Id</option>
                      </select>
                      <div class="card" style="margin-top:16px;display:none;" id="leftWrapper">
                        <div class="card-body">
                          <div class="card-header card-header-new-height card-header-info heightCardHeader" style="margin: -8px 0 0 0 !important;text-align:left;">
                           <h5 class="card-title cardTitleMargin"><img src="assets/icons/delivery-van.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Vehicle Details</h5>
                          </div>
                          <div style="padding: 10px">
                            <table class="table veh-table" style="padding: 10px">
                              <tbody>
                                <tr>
                                  <td>Registration No.</td>
                                  <td id="regNoShipment"></td>
                                </tr>
                                <tr>
                                  <td>Vehicle Type</td>
                                  <td id="vehTypeShipment"></td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                          <div class="vehicle-param-list" style="cursor:pointer;">
                            <div class="vehicle-param-item" onclick="showHealthGrid('1')">
                              <img src="../../../Main/resources/images/dhl/Power Train.svg" style="height:32px;margin-top:8px;" alt="powerTrain">
                              <div class="param-name">Vehicle Error Codes</div>
                              <div class="param-val" id="powerTrain"></div>
                            </div>
                            <%-- <div class="vehicle-param-item" onclick="showHealthGrid('2')">
                              <img src="../../../Main/resources/images/dhl/Chasis.svg" style="width:48px;margin-top:8px;" alt="Chasis">
                              <div class="param-name">Chasis</div>
                              <div class="param-val" id="chasis"></div>
                            </div>
                            <div class="vehicle-param-item" onclick="showHealthGrid('3')">
                              <img src="../../../Main/resources/images/dhl/Body.svg" style="width:48px;margin-top:8px;margin-bottom:6px" alt="Body">
                              <div class="param-name">Body</div>
                              <div class="param-val" id="body"></div>
                            </div> --%>
                            <div class="vehicle-param-item">
                            <img src="../../../Main/resources/images/dhl/fuel_alert.svg" style="height:32px;margin-top:8px;" alt="Low Fuel">
                              <div class="param-name">Fuel Level(%)</div>
                              <div class="param-val" id="lowFuelAlert"></div>
                            </div>
                            <div class="vehicle-param-item" >
				<span id="bat"></span>
                              <div class="param-name">Battery(V)</div>
                              <div class="param-val" id="batteryVoltage"></div>
                            </div>
                            <div class="vehicle-param-item">
                              <img src="../../../Main/resources/images/dhl/Engine coolant temprature.svg" style="height:32px;margin-top:8px;" alt="Engine Coolant Temperature">
                              <div class="param-name">Engine Coolant Temp(°C)</div>
                              <div class="param-val" id="engineCoolantTemp"></div>
                            </div>
                            <%-- <div class="vehicle-param-item" onclick="showHealthGrid('7')">
                              <img src="../../../Main/resources/images/dhl/ABS_EBS_amber warning signals.svg" style="height:32px;margin-top:8px;" alt="ABS/EBS Warning Signal">
                              <div class="param-name">ABS/EBS Warning Signal</div>
                              <div class="param-val" id="absebs"></div>
                            </div> --%>
                            <%-- <div class="vehicle-param-item"> <!-- onclick="showHealthGrid('coEmission')" -->
                              <img src="../../../Main/resources/images/dhl/CO2 emission alert.svg" style="height:32px;margin-top:8px;" alt="CO2 Emission">
                              <div class="param-name">CO2 Emission</div>
                              <div class="param-val" id="coEmission"></div>
                            </div> --%>
                            <div class="vehicle-param-item">
                              <img src="../../../Main/resources/images/dhl/Low Kmpl alert.svg" style="height:32px;margin-top:8px;" alt="Low KMPL">
                              <div class="param-name">Mileage(Km/ltr)</div>
                              <div class="param-val" id="lowkmpl"></div>
                            </div>
                            <%-- <div class="vehicle-param-item"> <!--  onclick="showHealthGrid('tyreAmc')"-->
                              <img src="../../../Main/resources/images/dhl/Tyre AMC Alert.svg" style="height:32px;margin-top:8px;" alt="Tyre AMC">
                              <div class="param-name">Tyre AMC</div>
                              <div class="param-val" id="tyreAmc"></div>
                            </div> --%>
                            <div class="vehicle-param-item"> <!--  onclick="showHealthGrid('truckAmc')" -->
                              <img src="assets/icons/odometer.png" style="width:48px;margin-top:3px;" alt="Odometer">
                              <div class="param-name">Odometer(Km)</div>
                              <div class="param-val" id="odometer"></div>
                            </div>
                            <div class="vehicle-param-item"> <!--  onclick="showHealthGrid('truckAmc')" -->
                              <img src="assets/icons/rpm.png" style="width:48px;margin-top:3px;" alt="Engine RPM">
                              <div class="param-name">Engine RPM</div>
                              <div class="param-val" id="enginerpm"></div>
                            </div>
                            <div class="vehicle-param-item"> <!--  onclick="showHealthGrid('truckAmc')" -->
                              <img src="assets/icons/gps.png" style="width:48px;margin-top:3px;" alt="GPS Tampering">
                              <div class="param-name">GPS Tampering</div>
                              <div class="param-val" id="gpstampering"></div>
                            </div>
                            <div class="vehicle-param-item" > <!--onclick="showHealthGrid('compliance')"  -->
                              <img src="../../../Main/resources/images/dhl/compliance alert.svg" style="height:32px;margin-top:8px;" alt="Compliance">
                              <div class="param-name">Compliance</div>
                              <div class="param-val" id="compliance"></div>
                            </div>
                            <span id="healthGridWrapper" style="display:none">
                            <div class="card-header card-header-new-height card-header-info heightCardHeader" style="margin: 0 !important;text-align:left;width:96%;margin-top:16px !important;">
                              <h5 class="card-title cardTitleMargin"><img src="assets/icons/exclamation-mark.png" style="margin-top:-4px;width:18px;"/>&nbsp;&nbsp;&nbsp;Health Grid Alerts</h5>
                              <img id="cancelHealthGrid" onclick='$("#healthGridWrapper").hide()' src="assets/icons/cancel.png" style="cursor:pointer;margin-top:-20px;width:12px;float:right;margin-right:4px;"/>
                            </div>
                            <div style="padding: 10px;width:96%;">
                              <div class="row" style="margin: -12px;">
                                <div class="table-responsive"> <!--On Click showAction()-->
                                  <table id="healthGridTable" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                                    <thead>
                                       <tr>
                                         <th>Sl No.</th>
                                         <th>Error Desc</th>
                                         <th>Time Stamp</th>
                                        </tr>
                                    </thead>
                                  </table>
                                </div>

                              </div>
                            </div>
                          </span>




                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-4">
                      <select id="selectShipmentIdShipment">
                        <option value="0">Select Shipment Id</option>
                       <option value="volvo">Shipment 1</option>
                       <option value="saab">Shipment 2</option>
                       <option value="mercedes">Shipment 3</option>
                       <option value="audi">Shipment 4</option>
                      </select>
                      <div class="card" style="margin-top:16px;display:none" id="midWrapper">
                        <div class="card-body">
                          <div class="card-header card-header-new-height card-header-info heightCardHeader" style="margin: -8px 0 0 0 !important;text-align:left;">
                            <h5 class="card-title cardTitleMargin"><img src="assets/icons/driver.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Driver Details</h5>
                          </div>
                          <div style="padding: 10px">
                            <div class="row" style="margin: 0">
                              <div style="width: 75%">
                                <table class="table veh-table" style="padding: 10px">
                                  <tbody>
                                    <tr>
                                      <td>Driver ID</td>
                                      <td>
                                        Test1234
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>Name</td>
                                      <td id="driverNameShipment">Test Driver</td>
                                    </tr>
                                    <tr>
                                      <td>Phone</td>
                                      <td id="driverPhoneShipment">1234567890</td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                              <div style="width: 25%">
                                <img src="./assets/img/driver-icon.png" style="width: 100%;padding-left:8px;" alt="driver-icon">
                              </div>
                            </div>
                          </div>
                          <div class="card-header card-header-new-height card-header-info heightCardHeader" style="margin: 0 !important;text-align:left;">
                            <h5 class="card-title cardTitleMargin"><img src="assets/icons/trolley.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Consignment Details</h5>
                          </div>
                          <div style="padding: 10px">
                            <div class="row" style="margin: 0">
                              <div style="width: 100%">
                                <table class="table veh-table" style="padding: 10px">
                                  <tbody>
                                    <tr>
                                      <td>Shipment ID</td>
                                      <td id="shipmentIdShipment">
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>Customer ID</td>
                                      <td id="customerIdShipment"></td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                            </div>
                          </div>
                          <div class="card-header card-header-new-height card-header-info heightCardHeader" style="margin: 0 !important;text-align:left;">
                            <h5 class="card-title cardTitleMargin"><img src="assets/icons/exclamation-mark.png" style="margin-top:-4px;width:18px;"/>&nbsp;&nbsp;&nbsp;Alerts on Trip</h5>
                          </div>
                          <div style="padding: 10px">
                            <div class="row" style="margin: -12px;">
                              <div class="table-responsive"> <!--On Click showAction()-->
                                <table id="shipmentAlertTable" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                                  <thead>
                                     <tr>
                                       <th>Sl No</th>
                                       <th>Alert Desc</th>
                                       <th>Time Stamp</th>
                                       <th>Remarks</th>
                                      </tr>
                                  </thead>
                                </table>
                              </div>

                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-4">
                      <div class="card" style="margin-top:54px;display:none" id="rightWrapper" >
                        <div class="card-body">
                          <div class="card-header card-header-new-height card-header-info heightCardHeader" style="margin: -8px 0 0 0 !important;text-align:left;">
                             <h5 class="card-title cardTitleMargin" ><img src="assets/icons/route.png" style="margin-top:-4px;width:22px;"/>&nbsp;&nbsp;&nbsp;Route Details</h5>
                           </div>
                          <div style="padding: 10px; width: 100%">
                            <table class="table veh-table" style="padding: 10px">
                              <tbody>
                                <tr>
                                  <td>Route Name</td>
                                  <td id="routeIdShipment">
                                  </td>
                                </tr>
                                <tr>
                                  <td>From</td>
                                  <td id="fromShipment"></td>
                                </tr>
                                <tr>
                                  <td>To</td>
                                  <td id="toShipment"></td>
                                </tr>
                                <tr>
                                  <td>Distance (in km)</td>
                                  <td id="distanceShipment"></td>
                                </tr>
                                <tr>
                                  <td>Expected Time (in Hrs)</td>
                                  <td id="expectedShipment"></td>
                                </tr>
                                <tr>
                                  <td>Current Status</td>
                                  <td id="currentStatusShipment"></td>
                                </tr>
                              </tbody>
                            </table>
                            <div style="text-align:left;display:none;">
                              <span>
                                <span style="font-weight:bold;" class="show-label">Play History: </span>
                                <img style="padding-left:4px;padding-bottom:8px" class="play" id="play/pause" src="/ApplicationImages/ApplicationButtonIcons/play.png" alt="Play History Analysis" onclick="playHistoryTracking(this);" title="Play History Analysis"/>
                                <img class="pause" id ="stop" style="padding-left:2px;padding-bottom:8px" src="/ApplicationImages/ApplicationButtonIcons/stop.png" onclick="stopHistoryTracking();" title="Stop History Analysis" />
                                <span style="margin-left: 16px;font-weight:bold;" class="show-label">Speed:</span>
                                <input style="margin-left: 4px;height:12px;width:144px;margin-right:8px;" type="range" min="1" max="100" value="0" class="slider" id="myRange">
                              </span>
                            </div>
                            <div style="width: 100%; height: 300px;position:relative" id="shipment-route-map">
                              <div id="loading1" style="position:absolute;width:100%;height:46vh;top:0;left:0;background:#dfdfdf;opacity:0.6;z-index:10000;">
                              	<div style="position:absolute;top:40%;left:40%;z-index:3">
                              	<img src="../../../Main/images/loading.gif" alt=""></div>
                              </div>
                                <div class="tab-pane active" id="map2" style="height:46vh;padding:0px !important"></div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </nav>
      <!-- End Navbar -->
      <footer class="footer">
        <div class="container-fluid">
          <nav class="float-left">
            <ul>
              <li>
              </li>
            </ul>
          </nav>
          <div class="copyright float-right">
            &copy;
            <script>
              document.write(new Date().getFullYear())
            </script> telematics4u
          </div>
          <!-- your footer here -->
        </div>
      </footer>
    </div>
  </div>
  <!--   Core JS Files   -->

  <script src="assets/js/core/jquery.min.js" type="text/javascript"></script>
  <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
  <script src="assets/js/core/bootstrap-material-design.min.js" type="text/javascript"></script>
  <script src="assets/js/plugins/perfect-scrollbar.jquery.min.js"></script>
  <!--  Google Maps Plugin    -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg&region=IN"></script>
  <script src='<%=GoogleAPIKEY%>'></script>
  <!-- Chartist JS -->
  <script src="assets/js/plugins/chartist.min.js"></script>
  <!--  Notifications Plugin    -->
  <script src="assets/js/plugins/bootstrap-notify.js"></script>
  <!-- Control Center for Material Dashboard: parallax effects, scripts for the example pages etc -->
  <script src="assets/js/material-dashboard.js" type="text/javascript"></script>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
  <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js" type="text/javascript"></script>

  <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>

  <script>
  var markerClusterArray = [];
  var map;
  var map1;
  var map2;
  var map1marker = null;
  var map2marker = null;
  var remarksTripId;

  var globalTripId;
  var globalTripStartTime;
  var globalRouteId;
  var markerCluster = null;
  var jsonRequestCount = 0;
  var selectedVehicleNo = "";

  var legIds = "";
  var polylatlongs=[];
  var completeRoutePath;
  var dragPointArray = [];
  var myLatLngS;
  var myLatLngD;
  var directionDisplayArr=[];
    var directionDisplayArrShipment=[];
  var checkPointInfoWindowsArray = [];

  var directionsServiceAction = new google.maps.DirectionsService;
  var directionsDisplayAction = new google.maps.DirectionsRenderer({
  		map: map1,
      polylineOptions: {
          strokeColor: "#015636",
          strokeOpacity: 1.0,
          strokeWeight: 4
      }
  });

  var directionsServiceShipment = new google.maps.DirectionsService;
  var directionsDisplayShipment = new google.maps.DirectionsRenderer({
  		map: map2,
      polylineOptions: {
          strokeColor: "#015636",
          strokeOpacity: 1.0,
          strokeWeight: 4
      }
  });

  var totalLegCount = 0;
  var currentLeg = 0;
  var completeLegDetails = [];
  var fullRoute;
  var existingLegList;
  var existingRouteDetails;

  var datalist = [];
  var infolist = [];
  var lineInfo = [];
  var plyArray = [];
  var flag=true;

  var oldMarkerImage = "";
  var oldMarker = null;
  var countHistory = 0;

  function loadHistory(){
    if(countHistory == 1)
    {
      $("#loading1").hide();
      var today = new Date();
      var dd = today.getDate();
      var mm = today.getMonth()+1; //January is 0!
      var hh = today.getHours();
      var MM = today.getMinutes();
      var ss = today.getSeconds();

      var yyyy = today.getFullYear();
      if(dd<10){
          dd='0'+dd;
      }
      if(mm<10){
          mm='0'+mm;
      }
      if(hh < 10){
        hh = "0"+hh
      }
      if(MM < 10){
        MM = "0"+MM;
      }
      if(ss < 10){
        ss = "0"+ss;
      }
      var endDate = dd+'/'+mm+'/'+yyyy+' '+hh+':'+MM+':'+ss;


      var startTimeFormat = globalTripStartTime.split(" ");
      var startDateFormat = startTimeFormat[0].split("-");
      startTimeFormat=startTimeFormat[1].split(".");

      var startDateTimeString = startDateFormat[2] + "/" + startDateFormat[1] + "/" + startDateFormat[0] +  " " + startTimeFormat[0];

  $.ajax({
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getHistoryAnalysisForTripDashBoard',
      data:{
        vehicleNo: selectedVehicleNo,
        startdate: startDateTimeString,
        timeband:  0,
        enddate: endDate
      },
      success: function(result) {

        console.log("History Result", result)
        datalist = [];
        infolist = [];
        var dataAndInfoList = JSON.parse(result);

        var totaldatalist = dataAndInfoList["vehiclesTrackingRoot"][0].datalist;
        for(var i=0;i<totaldatalist.length;i++){
          datalist.push(totaldatalist[i]);
         }
               var totalinfolist = dataAndInfoList["vehiclesTrackingRoot"][1].infolist;
               for(var i=0;i<totalinfolist.length;i++){
          infolist.push(totalinfolist[i]);
         }
              if(datalist.length > 0){
                plotHistoryToMap();
                plotEventMarkers('-1');

              }
                $("#loading1").hide();
      }
    });
  }
  }

  function plotHistoryToMap(){
  var lon = 0.0;
    var lat = 0.0;
  var latlng ;
  var mkrCtr=0;
  var k = 0;
  titleMkr = [];
  var bounds = new google.maps.LatLngBounds();
  var lineSymbol = {
          path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
          scale: 2,
          fillColor: '#ffffff',
          fillOpacity: 1.0
    };
  var vehicleNo = selectedVehicleNo;
    if(datalist != null){
              lat = datalist[0];
          lon = datalist[1];
        centerMap = new google.maps.LatLng(lat,lon);
        poly = new google.maps.Polyline({
          strokeColor: '#F2716F',
            strokeOpacity: 1.0,
            strokeWeight: 4

        });
        poly.setMap(map2);
        for(var i=0;i<datalist.length;i++){
          if(datalist[i] != null && datalist[i+1] != null && datalist[i+2] != null){
            mylatLong = new google.maps.LatLng(lat,lon);
                lat = datalist[i];
              lon = datalist[i+1];
              if(i==0){ 	//start flag
          imageurl= '/ApplicationImages/VehicleImages/redcirclemarker.png';
          image = {
                url:imageurl,
                scaledSize:  new google.maps.Size(25, 25),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(0, 32)
            };
              }else if(i==datalist.length-3){ 	//stop flag
                imageurl=map2MarkerImage;
                image = {
                url:imageurl,
                scaledSize:  new google.maps.Size(25, 35),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(0, 32)
            };
              }
              var date = convert(infolist[k]);
              titleMkr.push("");
            titleMkr.push("");
              var loc = infolist[k+3];
              var loctn="";
              if(loc != null && loc != "" && loc != undefined){
                loctn = loc.replace(/\'/g, "");
              }
              var speed = infolist[k+4];
              k = k + 6;
            var path = poly.getPath();
            latlng = new google.maps.LatLng(lat, lon);

            path.push(latlng);
            plyArray.push(poly);

            if((i==datalist.length-3) || (i==0)){
           map2marker = new google.maps.Marker({
                  position: latlng,
                  map: map2,
                  icon: image
              });
              lineInfo.push(map2marker);
              content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;font-weight:initial;">'+
            '<table>'+
            '<tr><td><div style="width: 70px;"><span><b>Vehicle No:</b></div></span></td><td>'+vehicleNo+'</td></tr>'+
            '<tr><td><div style="width: 70px;"><span><b>Location:</b></div></span></td><td>'+loc+'</td></tr>'+
            '<tr><td><div style="width: 70px;"><span><b>Date Time:</b></div></span></td><td>'+date+'</td></tr>'+
            '<tr><td><div style="width: 70px;"><span><b>Speed:</b></td></div></span><td>'+speed+'</td></tr>'+
            '</table>'+
            '</div>';
          infowindow = new google.maps.InfoWindow({
                content: content,
                marker:map2marker,
                maxWidth: 300,
                image:image
            });
          google.maps.event.addListener(map2marker, 'click', function() {
            infowindow.setContent(content);
            infowindow.open(map, map2marker);
                  });
        }
            animatePolylines();
            animate = "true";
              i+=2;
              if(flag==true){
                bounds.extend(mylatLong);
                map.fitBounds(bounds);
                pdfzoom=map.getZoom();
              }
                }
            } // for loop end
            flag=false;
          }
}

function animatePolylines() {
  var count = 0;
  // window.setInterval(function () {
  //   count = (count + 1) % 200;
  //   var icons = poly.get('icons');
  //   icons[0].offset = (count / 2) + '%';
  //   poly.set('icons', icons);
  // }, 9000);
}

function convert(time){
  var date = "";
  if(time != null && time != "" && time != undefined){
    date = time.replace(/\'/g, "");
    return date;
  }else{
    return date;
  }
}

var playCount = 0;
var playDataList = datalist;
var playInfoDataList = infolist;
var playTitle = 1;
var infoCount = 0;
var i = 0;
var startCtr;
var endCtr;
var pausedCtr=0;
var clickeventofimg = false;
var firstload=1;
var titleMkr=[];
var simpleMarkers = [];
var markers = [];
var speedMarkers = [];
var mapZoom;
var polyline;
var polylines=[];
var path;
var timerval=null;
var mkrColl=[];
var displaytext=[];
var labelmarkers = [];
var livePlottingInterval;
var playMarkerArr  = [];
var unitOfMeasurement = '<%=unitOfMeasurement%>';
var map2MarkerImage = "";
var othersMarkerArr = [];
var mainArr = [];
//var markerArr = [];

function plotEventMarkers(alertID){
  $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSummaryDetails',
        data:{
            tripNo: globalTripId,
            alertId : alertID
        },
        success: function(result) {
            checkPointList = JSON.parse(result);
            var bounds = new google.maps.LatLngBounds();
            for(var i = 0 ; i < mainArr.length; i++){
                mainArr[i].setMap(null);
            }
            centerMap = new google.maps.LatLng(checkPointList["tripSummarysRoot"][0].lat, checkPointList["tripSummarysRoot"][0].lon);
            for(var i=0;i<checkPointList["tripSummarysRoot"].length;i++){
            if(checkPointList["tripSummarysRoot"][i].lat != '0' && checkPointList["tripSummarysRoot"][i].lon != '0'
                && checkPointList["tripSummarysRoot"][i].lat != '0.0' && checkPointList["tripSummarysRoot"][i].lon != '0.0'){
                var latlng = new google.maps.LatLng(checkPointList["tripSummarysRoot"][i].lat, checkPointList["tripSummarysRoot"][i].lon);
                var name = checkPointList["tripSummarysRoot"][i].sourceIndex;
                var sequence = checkPointList["tripSummarysRoot"][i].seq;
                var type = checkPointList["tripSummarysRoot"][i].type;
                var alertId = checkPointList["tripSummarysRoot"][i].alertId;
                var date = checkPointList["tripSummarysRoot"][i].actualDateIndex;
                var alertName = checkPointList["tripSummarysRoot"][i].alertIndex;
                var vehicleExitTime = checkPointList["tripSummarysRoot"][i].vehicleExitTime;

                plotMarker(latlng,name,sequence,type,alertId,date,alertName,vehicleExitTime);
            }
            }
        }
    });
}

function plotMarker(myLatLng,name,sequence,type,alertId,date,alertName,vehicleExitTime) {
var image;
var location;
var marker1;
var infowindowpoints;
var contentForDot;
if(type == 'events'){
location = "Location";
   if(alertId == 2){ // overspeed
    image = {
    url: '/ApplicationImages/VehicleImages/pinkdashBoard.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  alertName = "Overspeed";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            overSpeedMarkerArr.push(marker1);
   }else if(alertId == 7){ // GPS tampering
    image = {
    url: '/ApplicationImages/VehicleImages/blueBalloonNew.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  alertName = "Device Tampering";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            tamperMarkerArr.push(marker1);
   }else if(alertId == 58){ // HB
    image = {
    url: '/ApplicationImages/VehicleImages/orangeBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  alertName = "Harsh Brake";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            HBMarkerArr.push(marker1);
   }else if(alertId == 3){ // Panic
    image = {
    url: '/ApplicationImages/VehicleImages/redBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  alertName = "Panic";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            panicMarkerArr.push(marker1);
  }else if(alertId == 45){ // Restrictive Hours
    image = {
    url: '/ApplicationImages/VehicleImages/lightGreenBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  alertName = "Restrictive Driving";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            restrictiveMarkerArr.push(marker1);
   }else if(alertId == 174){ // Error codes
    image = {
    url: '/ApplicationImages/VehicleImages/purpleBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  alertName = "Engine Malfunction";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            ErrorMarkerArr.push(marker1);
   }else {
    image = {
    url: '/ApplicationImages/VehicleImages/yellowBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            othersMarkerArr.push(marker1);
   }
contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
'<table>' +
'<tr><td><b> Alert name : </b></td><td>' + alertName + '</td></tr>' +
'<tr><td><b>Location : </b></td><td>' + name + '</td></tr>' +
'<tr><td><b>Date time : </b></td><td>' + date + '</td></tr>' +
'</table>' +
'</div>';

infowindowpoints = new google.maps.InfoWindow({
  content: contentForDot,
  marker: marker1,
  maxWidth: 300
  //image: image,
  //id: vehicleNo
});
google.maps.event.addListener(marker1, 'click', function() {
infowindowpoints.setContent(contentForDot);
infowindowpoints.open(map, marker1);
});
  markerArr.push(marker1);
}else{
  var str="";
if(sequence == 0){
  image = {
    url: '/ApplicationImages/VehicleImages/startflag.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  location = 'Source';
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            mainArr.push(marker1);
            str = '<tr><td><b>Date Time : </b></td><td>' + date + '</td></tr>' ;
}else if(sequence == 100){
  image = {
    url: '/ApplicationImages/VehicleImages/endflag.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  location = "Destination";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            mainArr.push(marker1);
            str = '<tr><td><b>Date Time : </b></td><td>' + date + '</td></tr>' ;
}else{
  image = {
    url: '/ApplicationImages/VehicleImages/PinkBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
    size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  location = "Check Point";
  marker1 = new google.maps.Marker({
                map: map2,
                position: myLatLng,
                icon: image
            });
            checkMarkerArr.push(marker1);
  str = '<tr><td><b>Vehicle Entry Time : </b></td><td>' + date + '</td></tr>' +
  '<tr><td><b>Vehicle Exit Time : </b></td><td>' + vehicleExitTime + '</td></tr>' ;
}
  contentForDot = '<div id="myInfoDivForRedMarker" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
  '<table>' +
  '<tr><td><b>'+location +' : </b></td><td>' + name + '</td></tr>' +
  str +
  '</table>' +
  '</div>';

  infowindowpoints = new google.maps.InfoWindow({
    content: contentForDot,
    marker: marker1,
    maxWidth: 300
    //image: image,
    //id: vehicleNo
  });
  google.maps.event.addListener(marker1, 'click', function() {
    infowindowpoints.setContent(contentForDot);
    infowindowpoints.open(map, marker1);
  });
   markerArr.push(marker1);
}

}



function clearMap(){
if(lineInfo.length > 0){
  for(var k =0; k < lineInfo.length; k++){
    lineInfo[k].setMap(null);
  }
}
if(plyArray.length > 0){
  for (var i = 0; i < plyArray.length; i++) {
    plyArray[i].setMap(null);
  }
}
}

function createPolylineTrace(){
   var lon = 0.0;
   var lat = 0.0;
   var flightPath=[];
   var lineSymbol = {
       path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
       scale: 2,
       strokeColor: '#ffffff',
   };
   for(var i=0;i<datalist.length;i++){
       lat = datalist[i];
       lon = datalist[i+1];
       if(i == 0)
       {
           var positionFlag = new google.maps.LatLng(lat,lon);
           markerFlag = new google.maps.Marker({
           position: positionFlag,
           map: map2,
           //icon:'/ApplicationImages/VehicleImages/startflag.png'
           });
           firstLatLong = positionFlag;
       }
       var latLong = new google.maps.LatLng(lat,lon);
       flightPath.push(latLong);
       if(i == (datalist.length - 3))
       {
               var positionFlag = new google.maps.LatLng(lat,lon);
               markerFlagGreen = new google.maps.Marker({
               position: positionFlag,
               map: map2,
               //icon:'/ApplicationImages/VehicleImages/endflag.png'
               });
               var BoundsForPlotting = new google.maps.LatLngBounds();
               BoundsForPlotting.extend(firstLatLong);
               BoundsForPlotting.extend(latLong);
               map2.fitBounds(BoundsForPlotting);
               map2.setZoom(14);

       }
       i+=2;
   }
   polyline = new google.maps.Polyline({
       path: flightPath,
       strokeColor: '#006400',
       strokeOpacity: 1.0,
       strokeWeight: 4,
       icons: [{
           icon: lineSymbol,
           offset: '100%',
           repeat: '100px'
       }],
       map: map2
       });
       polyline.setMap(map2);
       polylines.push(polyline);
}

function getStartEndCounterForPlay(){
   startCtr=0;
   endCtr=(titleMkr.length/2)-1;
}
function playHistoryTracking(cb)
{

 clearInterval(livePlottingInterval);
  if(pausedCtr==0){
       getStartEndCounterForPlay();
       playCount=startCtr*3;
   }else{
        playCount=pausedCtr*3;
        i=pausedCtr;
        infoCount=pausedCtr*6;
        playTitle = pausedCtr+1;
        pausedCtr=0;
   }
    if (startCtr==endCtr){
         Ext.example.msg("No records to Play during this interval.");
    }else{
      if(cb.alt=="Play History Analysis"){
            running=true;
            if(playCount==startCtr*3){
                clearMap1();
                clearMarkers();
                playCount = startCtr*3;
                playTitle = 1;
                infoCount = startCtr*6;
                i=startCtr;
            }
            playDataList = datalist;
            playInfoDataList = infolist;
            if (typeof(sliderValue)=="undefined" || sliderValue==0){
                   timerval = window.setInterval("animate1()",1000);
                   cb.src ="/ApplicationImages/ApplicationButtonIcons/pause.png";
                   cb.alt = "Pause History Analysis";
           }else if (sliderValue>=0){
               timerval = window.setInterval("animate1()",(10000/sliderValue));
               cb.src ="/ApplicationImages/ApplicationButtonIcons/pause.png";
               cb.alt = "Pause History Analysis";
           }
           createPolylineTrace();
       }
       else
       {
            clearInterval(timerval);
            cb.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
            cb.alt = "Play History Analysis";
            running=false;
            pausedCtr=i;
       }
    }

    var listener = google.maps.event.addListener(map2, "idle", function() {
       //if (map.getZoom() > 16) map.setZoom(mapZoom);
           google.maps.event.removeListener(listener);
    });
   }

function createMarker(lat,lon,content,imageurl,type){
   var pos= new google.maps.LatLng(lat,lon);
   var marker = new google.maps.Marker({
       position: pos,
       map: map2,
       icon: imageurl
       });
       if(type == 'Speed'){
           speedMarkers.push(marker);
           infowindow = new google.maps.InfoWindow({
               contents: content,
               marker:speedMarkers,
               minWidth:400,
               maxWidth: 400
           });
       } else {
           markers.push(marker);
           infowindow = new google.maps.InfoWindow({
               contents: content,
               marker:marker,
               minWidth:400,
               maxWidth: 400
           });
       }

   google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){
           return function() {
               infowindow.setContent(content);
               infowindow.open(map,marker);
           };
       })(marker,content,infowindow));

   var latlng = new google.maps.LatLng(lat, lon);
   map2.setCenter(latlng);
   map2.setZoom(14);
}
function animate1(){
   refreshFlag=false;
   if(playCount < (endCtr+1)*3) {
       if(unitOfMeasurement=="mile"){
          unitOfMeasurement="miles";
       }
       else if(unitOfMeasurement=="nmi"){
          unitOfMeasurement="nmi";
       }
        else if(unitOfMeasurement=="kms"){
          unitOfMeasurement="kms";
       }
       var lon = playDataList[playCount+1];
       var lat = playDataList[playCount];

       if(playDataList[playCount+2] == "1") //stop
       {
           imageurl='/ApplicationImages/VehicleImages/redbal.png';
       }
       else if(playDataList[playCount+2] == "2")  //overspeed
       {
           imageurl='/ApplicationImages/VehicleImages/bluebal.png';
       }
       else if(playDataList[playCount+2] == "3")//idle
       {
           imageurl='/ApplicationImages/VehicleImages/yellowbal.png';
       }
       else  //other points
       {
           imageurl='/ApplicationImages/VehicleImages/GreenBalloon1.png';
       }
       var date = convert(playInfoDataList[infoCount]);
       var loctn;
       var loc = playInfoDataList[infoCount+3];
       if(loc != null && loc != "" && loc != undefined){
           loctn = loc.replace(/\'/g, "");
       }
       var speed = playInfoDataList[infoCount+4];
       var stopHrs =getHrMinsFormat(playInfoDataList[infoCount+5]);
       infoCount = infoCount + 6;
       if(playDataList[playCount+2] == "1"){
           var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
                         '<table class="infotable">'+
                         '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
                         '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
                         '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
                         '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
                         '<tr><td></td><td>'+
                         '<span class="create-land-route">'+
                         '</td></tr>'+
                         '</div>';
            }
          else if(playDataList[playCount+2] == "3")
            {
              var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
                             '<table class="infotable">'+
                             '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
                             '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
                             '<tr><td style="font-weight: bold;">Idle Hours:</td><td>'+stopHrs+'</td></tr>'+
                             '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
                             '<tr><td></td><td>'+
                             '<span class="create-land-route">'+
                             '</td></tr>'+
                             '</div>';
            }
            else if(playDataList[playCount+2] == "2")
            {
            var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
                         '<table class="infotable">'+
                         '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
                         '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
                         '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
                         '<tr><td></td><td>'+
                         '<span class="create-land-route">'+
                         '</td></tr>'+
                         '</div>';
            }
            else
            {
             var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#FFFFFF; line-height:100%; font-size:11px; font-family: sans-serif;">'+
                         '<table class="infotable">'+
                         '<tr><td style="font-weight: bold;">Date:</td><td>'+date+'</td></tr>'+
                         '<tr><td style="font-weight: bold;">Speed:</td><td><span>'+speed+'</span><span style="margin-left:1em;">'+unitOfMeasurement+'</span></td></tr>'+
                         '<tr><td style="font-weight: bold;">Location:</td><td>'+loctn+'</td></tr>'+
                         '<tr><td></td><td>'+
                         '<span class="create-land-route">'+
                         '</td></tr>'+
                         '</div>';
           }
           createMarker(lat,lon,content,imageurl,'');
           imageurl='assets/icons/bluebal.png';
           if (mkrColl.length>0){
               var greenMarkerlength=mkrColl.length-1;
               var greenMarker = mkrColl[greenMarkerlength];
               greenMarker.setMap(null);
               greenMarker=null;
           }
           if(i>0 && i<(playDataList.length/3)-1){
               var position = new google.maps.LatLng(lat,lon);
               var marker = new google.maps.Marker({
               position: position,
               map: map2,
               icon: imageurl
               });
               mkrColl.push(marker);
           }
           //console.log("animate i=="+i);
           i++;
           playCount = playCount + 3;
           playTitle++;
        }
    if (playCount==(endCtr+1)*3){
        //document.getElementById("unchecked").disabled=false;
        running=false;
        var e=document.getElementById("play/pause");
        e.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
        e.alt = "Play History Analysis";
        playCount=0;
        i=0;
        infoCount=0;
        running=false;
        pausedCtr=0;
        clearInterval(timerval);
        startCtr=0;
        endCtr=0;
        title=1;
        //titleMkr=[];
        //clearMarkers();
        //markers=[];
   }
}
/********************************Stop Tracking**********************************/
function stopHistoryTracking(){
   var cb=document.getElementById("play/pause");
   cb.src = "/ApplicationImages/ApplicationButtonIcons/play.png";
   cb.alt = "Play History Analysis";
   playCount=0;
   i=0;
   infoCount=0;
   running=false;
   pausedCtr=0;
   clearInterval(timerval);
   clearInterval(livePlottingInterval);
   running=false;
   startCtr=0;
   endCtr=0;
   title=1;
   refreshFlag=true;
   //titleMkr=[];
   clearMarkers();
   clearMovingMarkers();
   clearMap();
   //plotHistoryToMap('Both');
  }
/******************************remove markers and polylines******************************/

function clearMarkers() {
   for (var i = 0; i < markers.length; i++) {
       var marker = markers[i];
           marker.setMap(null);
           marker=null;
   }
   markers.length = 0;
}
function clearSpeedMarkers() {
   for (var i = 0; i < speedMarkers.length; i++) {
       var marker = speedMarkers[i];
           marker.setMap(null);
           marker=null;
   }
   speedMarkers.length = 0;
}
function clearMovingMarkers() {
   for (var i = 0; i < mkrColl.length; i++) {
       mkrColl[i].setMap(null);
   }
       mkrColl.length=0;
}
function removePolylineTrace(){
    for(var i=0;i<polylines.length;i++){
       var poly = polylines[i];
       poly.setMap(null);
       poly=null;
    }
    polylines.length = 0;
}
function removeBorder(){
   for(var i=0;i<borderPolylines.length;i++){
       borderPolylines[i].setMap(null);
       borderMarkers[i].setMap(null);
   }
   borderPolylines.length=0;
   for(var i=0;i<borderCircles.length;i++){
       borderCircleMarkers[i].setMap(null);
       borderCircles[i].setMap(null);
   }
   borderCircles.length = 0;
}
function removerichmarkers(){
   for(var i=0; i<labelmarkers.length; i++){
     var marker = labelmarkers[i];
     marker.setMap(null);
   }
     labelmarkers.length=0;
}
function clearMap1(){
   //clearSimpleMarkers();
   removePolylineTrace();
   //removeBorder();
   removerichmarkers();
}
function getHrMinsFormat(strHrs){
   var stoptime = String (strHrs).split('.');
   var hrs=stoptime[0];
   var mins="0";
   if(stoptime.length>1){
       mins=stoptime[1];
   }
   if(hrs < 10){
       hrs="0"+hrs;
   }
   if(mins.length == 1){
       mins=mins+"0";
   }
   var Time = hrs + " Hr(s) " + mins + " Min(s) ";
   return Time;
}
/***********************************end of remove markers and polylines***********************************/

  function plotOnMap(routeId, type)
  {

  		 polylatlongs=[];
  		 dragPointArray = [];
  		 directionDisplayArr=[];
  		 checkPointInfoWindowsArray = [];
  		$("#loading").show();
  		$.ajax({
  				url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLegList',
  				data:{
  					routeId: routeId
  				},
  				 success: function(response) {
  						 existingLegList = JSON.parse(response).legListRoot;
  						 getRouteLatlongs(routeId,type)
  				 }
  		 });


  }

  function getRouteLatlongs(routeId,type){

  	legIds = '';
  	google.maps.event.trigger(map, 'resize');
  	 for (var j = 0; j < existingLegList.length; j++) {
  					 legIds+=existingLegList[j].legId+',';
  	 }
  	 polylatlongs = [];
  	 $.ajax({
  		 url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLatLongsForCompleteRoute',
  		 data:{
  			 legIds: legIds,
  			 routeId : routeId
  		 },
  			 success: function(result){
  				 results = JSON.parse(result);
  				 completeRoutePath = results;

  			 for (var i = 0; i < results["routelatlongRoot"].length; i++) {
  				 if((results["routelatlongRoot"][i].type=='SOURCE')){
  					 myLatLngS= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
  				 }
  				 if(results["routelatlongRoot"][i].type=='DESTINATION'){
  					 myLatLngD= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
  				 }
  				 if(results["routelatlongRoot"][i].type=='CHECKPOINT'){
  						polylatlongs.push({
  											location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
  											stopover: true
  								 });
  				 }
  				 if(results["routelatlongRoot"][i].type=='DRAGPOINT'){
  					polylatlongs.push({
  											location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
  											stopover: false
  								 });
  				 }
  			 }
         if(type == "action"){
           plotRouteAction()
         }
         else {
           plotRouteShipment();
           countHistory = 1;
           loadHistory();
          }

  			 plotCheckPoints(completeRoutePath);
         (type == "shipment")? $("#loading1").show(): $("#loading1").hide();
  			 $("#loading").hide();
  		 }
  	 });
   }

   var func = loadHistory();
   var run = window.setInterval("func",10000)

   function plotRouteAction() {
   //clearMarkers();
  			 for (var i = 0; i < directionDisplayArr.length; i++) {
  			 directionDisplayArr[i].setMap(null);
  		 }
  		 if(directionsDisplayAction != null) {
  				directionsDisplayAction.setMap(null);
  				directionsDisplayAction = null;
  		}


  		 directionsDisplayAction = new google.maps.DirectionsRenderer({
  			 map: map1,
         polylineOptions: {
             strokeColor: "#015636",
             strokeOpacity: 1.0,
             strokeWeight: 4
         }
  		 });
  		 //polylatlongs = []

  		 directionsServiceAction.route({
  				 origin: myLatLngS,
  				 destination: myLatLngD,
  				 waypoints: polylatlongs,
  				 travelMode: google.maps.TravelMode.DRIVING

  		 }, function(response, status) {
  				 if (status === google.maps.DirectionsStatus.OK) {
  						 directionsDisplayAction.setDirections(response);
  						 directionDisplayArr.push(directionsDisplayAction);
  				 } else {
  						 console.log("Invalid Request "+status);
  				 }
  		 });


   }

   function plotRouteShipment() {
   //clearMarkers();


  			 for (var i = 0; i < directionDisplayArrShipment.length; i++) {
  			 directionDisplayArrShipment[i].setMap(null);
  		 }
  		 if(directionsDisplayShipment != null) {
  				directionsDisplayShipment.setMap(null);
  				directionsDisplayShipment = null;
  		}


  		 directionsDisplayShipment = new google.maps.DirectionsRenderer({
  			 map: map2,
         polylineOptions: {
             strokeColor: "#015636",
             strokeOpacity: 1.0,
             strokeWeight: 4
         }
  		 });
  		 //polylatlongs = []

  		 directionsServiceShipment.route({
  				 origin: myLatLngS,
  				 destination: myLatLngD,
  				 waypoints: polylatlongs,
  				 travelMode: google.maps.TravelMode.DRIVING

  		 }, function(response, status) {
  				 if (status === google.maps.DirectionsStatus.OK) {
  						 directionsDisplayShipment.setDirections(response);
  						 directionDisplayArrShipment.push(directionsDisplayShipment);
  				 } else {
  						 console.log("Invalid Request "+status);
  				 }
  		 });


   }
   var detentionCheckPointsArray = [];
   var checkPointMarkersArray = [];
   function plotCheckPoints(completeRoutePath){
  	 detentionCheckPointsArray = [];
  	 checkPointMarkersArray = [];
   }





  function initialize(type) {
      var mapOptions = {
          zoom: 4.6,
          center: new google.maps.LatLng(<%=latitudeLongitude%>), //23.524681, 77.810561),,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          mapTypeControl: false,
          gestureHandling: 'greedy',
          styles: [
                  {
                      "featureType": "all",
                      "elementType": "labels.text.fill",
                      "stylers": [
                          {
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
                      "stylers": [
                          {
                              "color": "#7CC7DF"
                          }
                      ]
                  }
              ]

      };
      if(type == "all" || type == "map")
      {
        map = new google.maps.Map(document.getElementById('map'), mapOptions);
      }
      if(type == "all" || type == "map1")
      {
        map1 = new google.maps.Map(document.getElementById('map1'), mapOptions);
      }
      if(type == "all" || type == "map2")
      {
        map2 = new google.maps.Map(document.getElementById('map2'), mapOptions);
      }
    //map.fitBounds(bounds);
      var trafficLayer = new google.maps.TrafficLayer();
      if(type == "all" || type == "map")
      {
        trafficLayer.setMap(map);
      }
      if(type == "all" || type == "map1")
      {
        trafficLayer.setMap(map1);
      }
      if(type == "all" || type == "map2")
      {
        trafficLayer.setMap(map2);
      }
      var geocoder = new google.maps.Geocoder();

      geocoder.geocode( {'address' : '<%=countryName%>'}, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            if(type == "all" || type == "map")
            {
              map.setCenter(results[0].geometry.location);
            }
            if(type == "all" || type == "map1")
            {
              map1.setCenter(results[0].geometry.location);
            }
            if(type == "all" || type == "map2")
            {
              map2.setCenter(results[0].geometry.location);
            }
          }
      });
  }

   $("#cancelSelect").on("click", function() {
       $("#vehicleDetails").hide();
   })

   $("#cancelAlertAction").on("click", function() {
     $("#alertActionCard").hide();
   })
  // Sets the map on all markers in the array.

  initialize("all");
  window.onload = function () {
        loadData();
	//loadInTransitTable();
    }

    setInterval(function() {
    if( $("#shipmentHeader").hasClass("active show"))
    {
                               getShipment();
                             }
                           }, 60000);
    $(document).ready(function () {
      var icon;
      var iconOrange;
      var iconGreen;
      var markerRed;
      var markerOrange;
      var markerGreen;
      var table1;
      var table2;
      var table3;
      var shipmentAlertTable;
      var truckJSON;

          $("#rightWrapper").css("height", 635);
      $.ajax({
           type: "POST",
           url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehicleNoAndShipmentIdOnTrip",
            data: {
            },
           success: function(result) {
            result = JSON.parse(result).vehicleListRoot;
             $("#selectVehicleIdShipment").empty().select2();
             $('#selectVehicleIdShipment').append($("<option></option>").attr("value", 0).text("Select Vehicle ID"));
             $("#selectShipmentIdShipment").empty().select2();
             $('#selectShipmentIdShipment').append($("<option></option>").attr("value", 0).text("Select Shipment ID"));
             for (var i = 0; i < result.length; i++) {
                $('#selectVehicleIdShipment').append($("<option></option>").attr("value", result[i].vehicleNo).text(result[i].vehicleNo).attr("shipmentId", result[i].shipmentId).attr("routeId", result[i].routeId).attr("tripId", result[i].tripId).attr("tripStartTime", result[i].tripStartTime));
                $('#selectShipmentIdShipment').append($("<option></option>").attr("shipmentId", result[i].shipmentId).text(result[i].shipmentId).attr("vehicleNo", result[i].vehicleNo).attr("routeId", result[i].routeId).attr("tripId", result[i].tripId).attr("tripStartTime", result[i].tripStartTime));

             }
             $("#selectVehicleIdShipment").select2();
             $("#selectShipmentIdShipment").select2();
          }
         });




      $("#inTransitCount").on("click", function(){ loadMap("2,3,4", "truck");});
      $("#onTime").on("click", function(){ loadMap("2", "truck");});
      $("#delayLess").on("click", function(){ loadMap("3", "truck");});
      $("#stoppageDelayLess").on("click", function(){ loadMap("7", "truck");});
      $("#deviationDelayless").on("click", function(){ loadMap("8", "truck");});
      $("#delayGreater").on("click", function(){ loadMap("4", "truck");});
      $("#stoppagedelayGreater").on("click", function(){ loadMap("9", "truck");});
      $("#deviationDelayGreater").on("click", function(){ loadMap("10", "truck");});
      $("#loadingUnloading").on("click", function(){ loadMap("11,12,13", "loadUnload");});
      $("#onTimeLoading").on("click", function(){ loadMap("11", "loadUnload");});
      $("#loadUnloadLess").on("click", function(){ loadMap("12", "loadUnload");});
      $("#loadUnloadGreater").on("click", function(){ loadMap("13", "loadUnload");});
 		$("#delayedHubDeparture").on("click", function(){ loadMap("30", "truck");});
      $("#waitingInstructions").on("click", function(){ loadMap("33","unutilizedRed");});
      $("#nonReporting").on("click", function(){ loadMap("44","unutilizedRed");});
     // $("#underMaintenance").on("click", function(){ loadMapTestJSon(3,"unutilizedOrange");});

      $("#fuel").on("click", function(){ loadMap("LOW_FUEL","fuel");});
      $("#battery").on("click", function(){ loadMap("LOW_BAT","battery");});
      $("#weather").on("click", function(){ loadMapTestJSon(9,"weather");});
      $("#speedAlertCount").on("click", function(){ loadMap("OVER_SPEED","speed");});
      $("#temperature").on("click", function(){ loadMap("COOLANT_TEMP","temperature");});

	   $("#enroute").on("click", function(){ loadMap("0,1", "unutilizedGreen");});

      //$("#unUtilizedVeh").on("click", function(){ loadMap("all", "unUtilized");});

      $("#btnDeepDive").on("click", function(){
        $("#shipment").addClass("active");
        $("#action").removeClass("active")
        $("#snapshot").removeClass("active")
        $("#shipmentHeader").addClass("active show")
        $("#actionHeader").removeClass("active show")
        $("#snapshotHeader").removeClass("active show")
        if(selectedVehicleNo != "")
        {
          $('#selectVehicleIdShipment').val(selectedVehicleNo).trigger('change');
          getShipment();
        }

      })
      $("#btnAction").on("click", function(){
        $("#shipment").removeClass("active")
        $("#action").addClass("active")
        $("#alertActionCard").hide();
        initialize("map1");
        loadActionData();
        $("#snapshot").removeClass("active")
        $("#shipmentHeader").removeClass("active show")
        $("#actionHeader").addClass("active show")
        $("#snapshotHeader").removeClass("active show")


      })


      loadMap("all", "truck");



    });

    $("#actionHeader").on("click", function(){
      loadActionData();
    })

    $("#snapshotHeader").on("click", function(){
      map.setZoom(4.6);
    })


    function loadActionData()
    {
      //table 1
      $.ajax({
           type: "GET",
           url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getInTransitDetails",
           success: function(result) {
	         result = JSON.parse(result).inTransitRoot;
            let rows = [];
            let rowEmpty = [];
            let rowHighlight = [];
            $.each(result, function(i, item) {
                let row = {
                     "0":"<a title='"+item.shipmentId+"'>" + item.shipmentId.substring(0,16) + " ...</a>",
                     "1":"<a title='"+item.routeDesc+"'>" + item.routeDesc.substring(0,16) + " ...</a>",
                     "2":item.alertType,
                     "3":item.alertDesc,
                     "4":(item.remarks.length < 10 || item.remarks == "")? item.remarks : "<a title='"+item.remarks+"'>" + item.remarks.substring(0,10) + " ...</a>",
                     "5":item.latitude,
                     "6":item.longitude,
                     "7":item.driverName,
                     "8":item.driverContact,
                     "9":item.vehicleNo,
                     "10":item.tripId,
                     "11":item.shipmentId,
                     "12": item.routeDesc,
                     "13":item.remarks,
                     "14":item.routeId
                }

                item.remarks === "" ? rows.unshift(row): rows.push(row);

              })

              var tempRows = [];
              for(var x=0;x < rows.length ; x++)
              {

                if(rows[x][9]  == selectedVehicleNo){
                  tempRows.unshift(rows[x]);
                }
                else{
                  tempRows.push(rows[x]);
                }
              }
              rows = tempRows;

              for(var x=0;x < rows.length ; x++)
              {
                if(rows[x][9]  == selectedVehicleNo){
                  rowHighlight.push(x);
                }
              }
              if ($.fn.DataTable.isDataTable("#table1")) {
                $('#table1').DataTable().clear().destroy();
              }

              table1 = $('#table1').DataTable({
                "scrollY": "150px",
                "scrollX": false,
                paging : false,
                searching:false,
                "order": [],
                info:false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip'
              });
              table1.rows.add(rows).draw();
              table1.rows( rowHighlight )
                  .nodes()
                  .to$()
                  .addClass( 'highlight' );


           }
      })

      //table 2
      $.ajax({
           type: "GET",
           url:"<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getTruckDetentionDetails",
           success: function(result) {
	   result = JSON.parse(result).truckDetentionRoot;
            let rows = [];
            let rowEmpty = [];
            let rowHighlight = [];
            $.each(result, function(i, item) {
                let row = {
                     "0":"<a title='"+item.shipmentId+"'>" + item.shipmentId.substring(0,16) + " ...</a>",
                     "1":"<a title='"+item.routeDesc+"'>" + item.routeDesc.substring(0,16) + " ...</a>",
                     "2":item.alertType,
                     "3":item.alertDesc,
                     "4":(item.remarks.length < 10 || item.remarks == "")? item.remarks : "<a title='"+item.remarks+"'>" + item.remarks.substring(0,10) + " ...</a>",
                     "5":item.latitude,
                     "6":item.longitude,
                     "7":item.driverName,
                     "8":item.driverContact,
                     "9":item.vehicleNo,
                     "10":item.tripId,
                     "11":item.shipmentId,
                     "12": item.routeDesc,
                     "13":item.remarks,
                     "14":item.routeId
                }
                  item.remarks === "" ? rows.unshift(row): rows.push(row);
              })

              var tempRows = [];
              for(var x=0;x < rows.length ; x++)
              {

                if(rows[x][9]  == selectedVehicleNo){
                  tempRows.unshift(rows[x]);
                }
                else{
                  tempRows.push(rows[x]);
                }
              }
              rows = tempRows;
              for(var x=0;x < rows.length ; x++)
              {
                if(rows[x][9]  == selectedVehicleNo){
                  rowHighlight.push(x);
                }
              }

              if ($.fn.DataTable.isDataTable("#table2")) {
                $('#table2').DataTable().clear().destroy();
              }

              table2 = $('#table2').DataTable({
                "scrollY": "150px",
                "scrollX": false,
                paging : false,
                  "order": [],
                searching:false,
                info:false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip'
              });
              table2.rows.add(rows).draw();
              table2.rows( rowHighlight )
                  .nodes()
                  .to$()
                  .addClass( 'highlight' );


           }
      })



      //table 3
      $.ajax({
           type: "GET",
           url:"<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehicleSafteyAlertActionDetails",
           success: function(result) {
           result = JSON.parse(result).vehicleSafteyRoot;
            let rows = [];
            let rowEmpty = [];
            let rowHighlight = [];
            $.each(result, function(i, item) {
                let row = {
                     "0":"<a title='"+item.shipmentId+"'>" + item.shipmentId.substring(0,16) + " ...</a>",
                     "1":"<a title='"+item.routeDesc+"'>" + item.routeDesc.substring(0,16) + " ...</a>",
                     "2":item.alertType,
                     "3":item.alertDesc,
                     "4":(item.remarks.length < 10 || item.remarks == "")? item.remarks : "<a title='"+item.remarks+"'>" + item.remarks.substring(0,10) + " ...</a>",
                     "5":item.latitude,
                     "6":item.longitude,
                     "7":item.driverName,
                     "8":item.driverContact,
                     "9":item.vehicleNo,
                     "10":item.tripId,
                     "11":item.shipmentId,
                     "12": item.routeDesc,
                     "13":item.remarks,
                     "14":item.routeId
                }
                item.remarks === "" ? rows.unshift(row): rows.push(row);

              })
              var tempRows = [];
              for(var x=0;x < rows.length ; x++)
              {

                if(rows[x][9]  == selectedVehicleNo){
                  tempRows.unshift(rows[x]);
                }
                else{
                  tempRows.push(rows[x]);
                }
              }
              rows = tempRows;
              for(var x=0;x < rows.length ; x++)
              {
                if(rows[x][9]  == selectedVehicleNo){
                  rowHighlight.push(x);
                }
              }

              if ($.fn.DataTable.isDataTable("#table3")) {
                $('#table3').DataTable().clear().destroy();
              }

              table3 = $('#table3').DataTable({
                "scrollY": "150px",
                "scrollX": false,
                paging : false,
                  "order": [],
                searching:false,
                info:false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                dom: 'Bfrtip'
              });
              table3.rows.add(rows).draw();
              table3.rows( rowHighlight )
                  .nodes()
                  .to$()
                  .addClass( 'highlight' );


           }
      })





      $('#table1').on('click', 'tr', function () {
       var data = table1.row( this ).data();
       if(map1marker != null)
       {
         map1marker.setMap(null);
       }
       var imageurl = {
           url: 'assets/icons/delivery-van-red.png',
           scaledSize : new google.maps.Size(32, 32),
       };
       if(data[3] == "delayed < 1hr")
       {
         imageurl = {
             url: 'assets/icons/delivery-van-orange.png',
             scaledSize : new google.maps.Size(32, 32),
         };

       }
	   remarksTripId = data[10];
       var pos = new google.maps.LatLng(data[5], data[6]);

       map1marker = new google.maps.Marker({
           position: pos,
           map: map1,
           icon: imageurl
       });
       map1.setCenter(pos);
       var routeId = data[14];
       routeId = data[14];
       plotOnMap(routeId, "action");
       showAlertActionCard(data[3],data[9], data[11], data[12], data[7], data[8],data[13]);
     });


     $('#table2').on('click', 'tr', function () {
      var data = table2.row( this ).data();
      var imageurl = {
          url: 'assets/icons/loading-unloading-area-red.png',
          scaledSize : new google.maps.Size(32, 32),
      };
      if(data[3] == "delayed < 1hr")
      {
        imageurl = {
            url: 'assets/icons/loading-unloading-area-orange.png',
            scaledSize : new google.maps.Size(32, 32),
        };

      }
      if(map1marker != null)
      {
        map1marker.setMap(null);
      }
      remarksTripId = data[10];
      var pos = new google.maps.LatLng(data[5], data[6]);

      map1marker = new google.maps.Marker({
          position: pos,
          map: map1,
          icon: imageurl
      });
      map1.setCenter(pos);
      var routeId = data[14];
      plotOnMap(routeId,'action');
      showAlertActionCard(data[3],data[9], data[11], data[12], data[7], data[8],data[13]);
     });

     $('#table3').on('click', 'tr', function () {
      var data = table3.row( this ).data();
      var imageurl = {
          url: 'assets/icons/delivery-van-red.png',
          scaledSize : new google.maps.Size(32, 32),
      };
      if(data[3] == "delayed < 1hr")
      {
        imageurl = {
            url: 'assets/icons/delivery-van-orange.png',
            scaledSize : new google.maps.Size(32, 32),
        };

      }
      if(map1marker != null)
      {
        map1marker.setMap(null);
      }
      var pos = new google.maps.LatLng(data[5], data[6]);
	  remarksTripId = data[10];
      map1marker = new google.maps.Marker({
          position: pos,
          map: map1,
          icon: imageurl
      });
      map1.setCenter(pos);
      var routeId = data[14];
      plotOnMap(routeId,'action');
      showAlertActionCard(data[3],data[9], data[11], data[12], data[7], data[8],data[13]);
    });
    }

    function showAlertActionCard(alertDesc,vehicleNo, shipmentId, routeDesc, driverName, driverContact,remarks){
      selectedVehicleNo = vehicleNo;

      $("#remarksSaved").hide();
        $("#alertDescCard").html(alertDesc);
        $("#vehicleNoCard").html(vehicleNo);
        $("#shipmentIdCard").html(shipmentId);
        $("#routeDescCard").html(routeDesc);
        $("#driverNameCard").html("Test Driver (1234567890)");
        if(remarks != "")
        {
          $("#remarksCard").html(remarks);
          $("#remarksWrapper").show();
          $("#btnAlertAction").hide();
          $("#alertActionRemarks").hide();
        }
        else {
          $("#remarksCard").html("");
          $("#remarksWrapper").hide();
          $("#btnAlertAction").show();
          $("#alertActionRemarks").show();
        }
        $("#alertActionCard").show();

      	if(remarks.trim()==''){
      		document.getElementById("btnAlertAction").disabled=false;
      	}else{
      		document.getElementById("btnAlertAction").disabled=true;
      	}
      	document.getElementById("alertActionRemarks").value='';
    }

    $('#selectVehicleIdSnapshot').on('select2:select', function (e) {

        var truck = null;
        for (var i = 0; i < markerClusterArray.length; i++ ) {
           markerClusterArray[i].setMap(null);
        }
        markerClusterArray.length = 0;
        for (var i = 0; i < truckJSON.length; i++) {
            if(truckJSON[i].vehicleNo == e.params.data.id ){
              truck = truckJSON[i];
            }
         }
         plotSingleVehicle("truck",
             truck.alertDesc,
             truck.alertType,
             truck.driverContact,
             truck.driverName,
             truck.latitude,
             truck.longitude,
             truck.remarks,
             truck.routeDesc,
             truck.shipmentId,
             truck.status,
             truck.tripId,
             truck.vehicleNo,
             truck.hasVehicleSafteyAlert
           );
         var mylatLong = new google.maps.LatLng(truck.latitude, truck.longitude);
         showVehicleDetails(truck.vehicleNo, truck.alertType ,truck.alertDesc, truck.driverName, truck.driverContact, truck.routeDesc);

         // Add a marker clusterer to manage the markers.
         if(markerCluster != null)
         {
           markerCluster.clearMarkers();
         }
         markerCluster = new MarkerClusterer(map, markerClusterArray,
              {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
    });

    $("#shipmentHeader").on("click", function(){
      if(selectedVehicleNo != "")
      {
        $('#selectVehicleIdShipment').val(selectedVehicleNo).trigger('change');
        getShipment();
      }
    })

    $("#shipmentIdCard").on("click", function(){
      if(selectedVehicleNo != "")
      {
        $("#shipment").addClass("active");
        $("#action").removeClass("active")
        $("#snapshot").removeClass("active")
        $("#shipmentHeader").addClass("active show")
        $("#actionHeader").removeClass("active show")
        $("#snapshotHeader").removeClass("active show")
        $('#selectVehicleIdShipment').val(selectedVehicleNo).trigger('change');
        getShipment();
      }
    })


    $('#selectVehicleIdShipment').on('select2:select', function (e) {
      getShipment()
    });

    function getShipment()
    {
      $("#leftWrapper").show()
      $("#midWrapper").show()
      $("#rightWrapper").show()
      globalTripId = $('#selectVehicleIdShipment option:selected').attr("tripId");
      globalTripStartTime = $('#selectVehicleIdShipment option:selected').attr("tripStartTime");
     globalRouteId = $('#selectVehicleIdShipment option:selected').attr("routeId");
     selectedVehicleNo = $('#selectVehicleIdShipment').val();
     $('#selectShipmentIdShipment').val("0").trigger('change');

      $.ajax({
           type: "POST",
          // url:"shipmentAlert.json",
          url : "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getAlertGrid",
          data: {
                   tripId : globalTripId,
              },
           success: function(result) {
            result = JSON.parse(result).alertGridRoot;
            let rows = [];
            $.each(result, function(i, item) {
                let row = {
                     "0":item.slno,
                     "1":item.routeDesc,
                     "2":item.timestamp,
                     "3":item.remarks
                }
                rows.push(row);
              })

              if ($.fn.DataTable.isDataTable("#shipmentAlertTable")) {
                $('#shipmentAlertTable').DataTable().clear().destroy();
              }

              shipmentAlertTable = $('#shipmentAlertTable').DataTable({
                    "scrollY": "200px",
                    "scrollX": false,
                    paging : false,
                    searching:false,
                    info:false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    },
                    dom: 'Bfrtip'
              });
              shipmentAlertTable.rows.add(rows).draw();

           }
      })

      $.ajax({
           type: "POST",
          // url: "OBD.json",
          url : "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehicleHealthCounts",
          data: {
                  tripStartTime : globalTripStartTime,
                   tripId : globalTripId,
              },
           success: function(result) {
           result = JSON.parse(result).getVehicleHealthCountsRoot;
             result = result[0];
             $("#powerTrain").html(result.errorCodeCount);
             // $("#body").html(result.body);
             // $("#chasis").html(result.chasis);
             $("#lowFuelAlert").html(result.fuelLevel);
             $("#batteryVoltage").html(result.batteryVoltage);

             if(parseInt(result.batteryVoltage) < 20)
             {
               $("#bat").html('<img src="assets/icons/batRed.png" style="height:32px;margin-top:8px;" alt="Battery Voltage">');
             }

             if((parseInt(result.batteryVoltage) >= 20) && (parseInt(result.batteryVoltage) <=24))
             {
               $("#bat").html('<img src="assets/icons/batRed.png" style="height:32px;margin-top:8px;" alt="Battery Voltage">');
             }

             if(parseInt(result.batteryVoltage) > 24)
             {
               $("#bat").html('<img src="assets/icons/batGreen.png" style="height:32px;margin-top:8px;" alt="Battery Voltage">');
             }



             $("#engineCoolantTemp").html(result.coolantTemp);
             // $("#absebs").html(result.ABSEBSCount);
             // $("#coEmission").html(result.co2EmissionCount);
             $("#lowkmpl").html(result.mileage);
             // $("#tyreAmc").html(result.truckAmcAlertCount);
             $("#odometer").html(result.odometer);
             $("#enginerpm").html(result.engineRPM);
             $("#gpstampering").html(result.gpsTampering);
             $("#compliance").html(result.complianceAlertCount);
           }
         });

         $.ajax({
              type: "POST",
             // url: "vehIdResponse.json",
             url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getShipmentDetails",
              data: {
                   tripId: globalTripId,
              },
                success: function(result) {

                result = JSON.parse(result).shipmentRoot;
                result = result[0]; //shipmentRoot
                $("#regNoShipment").html(result.vehicleNo);
                $("#vehTypeShipment").html(result.vehicleType);
                // $("#driverIdShipment").html(result.driverId);
                // $("#driverNameShipment").html(result.driverName);
                // $("#driverPhoneShipment").html(result.driverContact);
                $("#customerIdShipment").html(result.custRefId);
                $("#shipmentIdShipment").html(result.shipmentId);
                $("#routeIdShipment").html(result.routeName);
                $("#fromShipment").html(result.source);
                $("#toShipment").html(result.destination);
                $("#distanceShipment").html(result.distance);
                $("#expectedShipment").html(result.duration);
                $("#currentStatusShipment").html(result.currentStatus);
                map2MarkerImage = 'assets/icons/delivery-van-green.png';
                if(result.status == "red")
                {
                  map2MarkerImage = 'assets/icons/delivery-van-red.png';
                }else if(result.status == "orange")
                {
                  map2MarkerImage = 'assets/icons/delivery-van-orange.png';
                }
                else if(result.status == "lightgreen")
                {
                  map2MarkerImage = 'assets/icons/delivery-van-lightgreen.png';
                }
                initialize("map2");
                plotOnMap(globalRouteId,"shipment")
              }
            });


    }

    $('#selectShipmentIdShipment').on('select2:select', function (e) {
      $("#leftWrapper").show()
      $("#midWrapper").show()
      $("#rightWrapper").show()
      globalTripId = $('#selectShipmentIdShipment option:selected').attr("tripId");
      globalTripStartTime = $('#selectShipmentIdShipment option:selected').attr("tripStartTime");
      globalRouteId = $('#selectShipmentIdShipment option:selected').attr("routeId");
      selectedVehicleNo = $('#selectShipmentIdShipment option:selected').attr("vehicleNo");
      $('#selectVehicleIdShipment').val("0").trigger('change');;
      $.ajax({
           type: "POST",
          // url:"shipmentAlert.json",
          url : "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getAlertGrid",
          data: {
                   tripId : globalTripId,
              },
           success: function(result) {
           result = JSON.parse(result).alertGridRoot;
            let rows = [];
            $.each(result, function(i, item) {
                let row = {
                     "0":item.slno,
                     "1":item.routeDesc,
                     "2":item.timestamp,
                     "3":item.remarks
                }
                rows.push(row);

              })

              if ($.fn.DataTable.isDataTable("#shipmentAlertTable")) {
                $('#shipmentAlertTable').DataTable().clear().destroy();
              }

              shipmentAlertTable = $('#shipmentAlertTable').DataTable({
                    "scrollY": "200px",
                    "scrollX": false,
                    paging : false,
                    searching:false,
                    info:false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    },
                    dom: 'Bfrtip'
              });
              shipmentAlertTable.rows.add(rows).draw();
              shipmentAlertTable.columns.adjust()

           }
      })

      $.ajax({
          type: "POST",
          // url: "OBD.json",
          url : "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehicleHealthCounts",
          data: {
                  tripStartTime : globalTripStartTime,
                   tripId : globalTripId,
              },
           success: function(result) {
            result = JSON.parse(result).getVehicleHealthCountsRoot;
             result = result[0];
             $("#powerTrain").html(result.errorCodeCount);
             // $("#body").html(result.body);
             // $("#chasis").html(result.chasis);
             $("#lowFuelAlert").html(result.fuelLevel);
             $("#batteryVoltage").html(result.batteryVoltage);
             $("#engineCoolantTemp").html(result.coolantTemp);
             // $("#absebs").html(result.ABSEBSCount);
             // $("#coEmission").html(result.co2EmissionCount);
             $("#lowkmpl").html(result.mileage);
             // $("#tyreAmc").html(result.truckAmcAlertCount);
             $("#odometer").html(result.odometer);
             $("#enginerpm").html(result.engineRPM);
             $("#gpstampering").html(result.gpsTampering);
             $("#compliance").html(result.complianceAlertCount);
           }
         });
         $.ajax({
              type: "POST",
             // url: "vehIdResponse.json",
             url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getShipmentDetails",
              data: {
                   tripId: globalTripId,
              },
                success: function(result) {
                 result = JSON.parse(result).shipmentRoot;
                  result = result[0];
                $("#regNoShipment").html(result.vehicleNo);
                $("#vehTypeShipment").html(result.vehicleType);
                // $("#driverIdShipment").html(result.driverId);
                // $("#driverNameShipment").html(result.driverName);
                // $("#driverPhoneShipment").html(result.driverContact);
                $("#customerIdShipment").html(result.custRefId);
                $("#shipmentIdShipment").html(result.shipmentId);
                $("#routeIdShipment").html(result.routeId);
                $("#fromShipment").html(result.source);
                $("#toShipment").html(result.destination);
                $("#distanceShipment").html(result.distance);
                $("#expectedShipment").html(result.duration);
                $("#currentStatusShipment").html(result.currentStatus);
                map2MarkerImage = 'assets/icons/delivery-van-green.png';
                if(result.status == "red")
                {
                  map2MarkerImage = 'assets/icons/delivery-van-red.png';
                }
                initialize("map2");
                plotOnMap(globalRouteId,"shipment")
              }
            });


    });

    function showHealthGrid(uniqueID)
    {
      var tripId = globalTripId;
      var tripStartTime = globalTripStartTime;
      $("#healthGridWrapper").show();
      $.ajax({
            type: "POST",
             // url: "vehIdResponse.json",
             url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehicleHealthGridDetails",
              data: {
                  tripId: globalTripId,
                  tripStartTime : globalTripStartTime,
                  alertKey: uniqueID
              },
           success: function(result) {
           result = JSON.parse(result).vehicleHealthGridDetailsRoot;
             let rows = [];
             $.each(result, function(i, item) {
                 let row = {
                      "0":item.slno,
                      "1":item.timestamp,
                      "2":item.errorDesc
                 }
                 rows.push(row);

               })

               if ($.fn.DataTable.isDataTable("#healthGridTable")) {
                 $('#healthGridTable').DataTable().clear().destroy();
               }

               healthGridTable = $('#healthGridTable').DataTable({
                     "scrollY": "200px",
                     "scrollX": false,
                     paging : false,
                     searching:false,
                     info:false,
                     "oLanguage": {
                         "sEmptyTable": "No data available"
                     },
                     dom: 'Bfrtip'
               });
               healthGridTable.rows.add(rows).draw();

            }
           }
         );

    }

    function loadMapTestJSon(noOfVehicles, type)
    {
      $("#actionHeader").show();
      $("#btnAction").removeAttr('disabled');
      $("#vehicleDetails").hide();
      $.ajax({
           type: "GET",
           url: "test.json",
           success: function(result) {
             var bounds = new google.maps.LatLngBounds();
             var count = 0;
             for (var i = 0; i < markerClusterArray.length; i++ ) {
                markerClusterArray[i].setMap(null);
             }
             markerClusterArray.length = 0;

             if(jsonRequestCount == 0)
             {
               $("#selectVehicleIdSnapshot").empty().select2();
               $('#selectVehicleIdSnapshot').append($("<option></option>").attr("value", 0).text("Select Vehicle ID"));
             }

             for (var i = 0; i < noOfVehicles; i++) {
               if(jsonRequestCount == 0)
               {
               $('#selectVehicleIdSnapshot').append($("<option></option>").attr("value", result[i].vehicleNo).text(result[i].vehicleNo));}
                       plotSingleVehicle(type,
                         result[i].alertDesc,
                         result[i].alertType,
                         result[i].driverContact,
                         result[i].driverName,
                         result[i].latitude,
                         result[i].longitude,
                         result[i].remarks,
                         result[i].routeDesc,
                         result[i].shipmentId,
                         result[i].status,
                         result[i].tripId,
                         result[i].vehicleNo,
                         false
                       );
                     var mylatLong = new google.maps.LatLng(result[i].latitude, result[i].longitude);
              }
              if(jsonRequestCount == 0)
              {
                jsonRequestCount =1;
              $('#selectVehicleIdSnapshot').select2();}


              // Add a marker clusterer to manage the markers.
              if(markerCluster != null)
              {
                markerCluster.clearMarkers();
              }
              markerCluster = new MarkerClusterer(map, markerClusterArray,
                   {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
           }
         })
    }


    function loadMap(statusId, type)
    {
      $("#vehicleDetails").hide();
      if(statusId == "2"|| statusId == "0,1" || statusId == "11" || statusId == "33" || statusId == "44")
      {
        $("#actionHeader").hide();
        $("#btnAction").attr("disabled", "disabled");

      }
      else {
        $("#actionHeader").show();
        $("#btnAction").removeAttr('disabled');
      }
      $.ajax({
           type: "GET",
           url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getMapData",
            data: {
              "statusId": statusId
            },
           success: function(result) {
             var bounds = new google.maps.LatLngBounds();
             var count = 0;
             for (var i = 0; i < markerClusterArray.length; i++ ) {
                markerClusterArray[i].setMap(null);
             }
             markerClusterArray.length = 0;
	           results = JSON.parse(result);
             if(jsonRequestCount == 0)
             {
               truckJSON = results["mapDataRoot"];
               $("#selectVehicleIdSnapshot").empty().select2();
               $('#selectVehicleIdSnapshot').append($("<option></option>").attr("value", 0).text("Select Vehicle ID"));
             }
             for (var i = 0; i < results["mapDataRoot"].length; i++) {
                      if(jsonRequestCount == 0)
                      {
                        $('#selectVehicleIdSnapshot').append($("<option></option>").attr("value", results["mapDataRoot"][i].vehicleNo).text(results["mapDataRoot"][i].vehicleNo));
                      }

                       plotSingleVehicle(type,
                         results["mapDataRoot"][i].alertDesc,
                         results["mapDataRoot"][i].alertType,
                         results["mapDataRoot"][i].driverContact,
                         results["mapDataRoot"][i].driverName,
                         results["mapDataRoot"][i].latitude,
                         results["mapDataRoot"][i].longitude,
                         results["mapDataRoot"][i].remarks,
                         results["mapDataRoot"][i].routeDesc,
                         results["mapDataRoot"][i].shipmentId,
                         results["mapDataRoot"][i].status,
                         results["mapDataRoot"][i].tripId,
                         results["mapDataRoot"][i].vehicleNo,
                         results["mapDataRoot"][i].hasVehicleSafteyAlert
                       );
                     var mylatLong = new google.maps.LatLng(results["mapDataRoot"][i].latitude, results["mapDataRoot"][i].longitude);
              }

              if(jsonRequestCount == 0)
              {
                jsonRequestCount = 1;
                 $('#selectVehicleIdSnapshot').select2();
               }

              // Add a marker clusterer to manage the markers.
              if(markerCluster != null)
              {
                markerCluster.clearMarkers();
              }
              markerCluster = new MarkerClusterer(map, markerClusterArray,
                   {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
           }
         })
    }


    function plotSingleVehicle(type, alertDesc, alertType, driverContact,driverName,latitude,longitude,remarks,routeDesc,shipmentId,status,tripId,vehicleNo,hasVehicleSafteyAlert)
    {
      var imageurl;
	 var imageAlerturl ='';
	if(hasVehicleSafteyAlert == 'true'){
		imageAlerturl='-alert'
	}
      if(type == "truck"){

        if (status == "red") {
            imageurl = {
                      url: 'assets/icons/delivery-van-red'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
        if (status == "orange") {
            imageurl = {
                      url: 'assets/icons/delivery-van-orange'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
        if (status == "green") {
            imageurl = {
                      url: 'assets/icons/delivery-van-green'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
        if (status == "lightgreen") {
            imageurl = {
                      url: 'assets/icons/delivery-van-lightgreen'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
      }

      if(type == "loadUnload"){
        if (status == "red") {
            imageurl = {
                      url: 'assets/icons/loading-unloading-area-red'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
        if (status == "orange") {
            imageurl = {
                      url: 'assets/icons/loading-unloading-area-orange'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
        if (status == "green") {
            imageurl = {
                      url: 'assets/icons/loading-unloading-area-green'+imageAlerturl+'.png',
                      scaledSize : new google.maps.Size(32, 32),
                  };
        }
      }

      if(type == "unutilizedRed"){
        imageurl = {
                  url: 'assets/icons/help-button-red.png',
                  scaledSize : new google.maps.Size(24, 24),
              };
      }
      if(type == "unutilizedOrange"){
        imageurl = {
                  url: 'assets/icons/help-button-orange.png',
                  scaledSize : new google.maps.Size(24, 24),
              };
      }
      if(type == "fuel"){
        imageurl = {
                  url: 'assets/icons/gas-station-red.png',
                  scaledSize : new google.maps.Size(24, 24),
              };
      }
      if(type == "battery"){
        imageurl = {
                  url: 'assets/icons/battery-red.png',
                  scaledSize : new google.maps.Size(32, 32),
              };
      }
      if(type == "weather"){
        imageurl = {
                  url: 'assets/icons/cloud-red.png',
                  scaledSize : new google.maps.Size(32, 32),
              };
      }
      if(type == "speed"){
        imageurl = {
                  url: 'assets/icons/speedometer-red.png',
                  scaledSize : new google.maps.Size(32, 32),
              };
      }
      if(type == "temperature"){
        imageurl = {
                  url: 'assets/icons/thermometer-tool-red.png',
                  scaledSize : new google.maps.Size(40, 40),
              };
      }


      var pos = new google.maps.LatLng(latitude, longitude);
      var marker = new google.maps.Marker({
          position: pos,
          map: map,
          icon: imageurl,
          title: vehicleNo,
          alertType: alertType,
          alertDesc: alertDesc,
          vehicleNo: vehicleNo,
          driverName: driverName,
          driverContact: driverContact,
          routeDescription: routeDesc,
          type: type,
          status: status
      });

      google.maps.event.addListener(marker, "click", function (e) {

            if(oldMarker != null)
            {
              oldMarker.setIcon(oldMarkerImage);
            }

            oldMarkerImage = marker.get("icon");
            oldMarker = marker;

            var imageurl;

            if(type == "truck"){
              if (status == "red") {
                  imageurl = {
                            url: 'assets/icons/delivery-van-red-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
              if (status == "orange") {
                  imageurl = {
                            url: 'assets/icons/delivery-van-orange-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
              if (status == "green") {
                  imageurl = {
                            url: 'assets/icons/delivery-van-green-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
              if (status == "lightgreen") {
                  imageurl = {
                            url: 'assets/icons/delivery-van-lightgreen-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
            }

            if(type == "loadUnload"){
              if (status == "red") {
                  imageurl = {
                            url: 'assets/icons/loading-unloading-area-red-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
              if (status == "orange") {
                  imageurl = {
                            url: 'assets/icons/loading-unloading-area-orange-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
              if (status == "green") {
                  imageurl = {
                            url: 'assets/icons/loading-unloading-area-green-selected.png',
                            scaledSize : new google.maps.Size(32, 32),
                        };
              }
            }

            if(type == "unutilizedRed"){
              imageurl = {
                        url: 'assets/icons/help-button-red-selected.png',
                        scaledSize : new google.maps.Size(24, 24),
                    };
            }
            if(type == "unutilizedOrange"){
              imageurl = {
                        url: 'assets/icons/help-button-orange-selected.png',
                        scaledSize : new google.maps.Size(24, 24),
                    };
            }
            if(type == "fuel"){
              imageurl = {
                        url: 'assets/icons/gas-station-red-selected.png',
                        scaledSize : new google.maps.Size(24, 24),
                    };
            }
            if(type == "battery"){
              imageurl = {
                        url: 'assets/icons/battery-red-selected.png',
                        scaledSize : new google.maps.Size(32, 32),
                    };
            }
            if(type == "weather"){
              imageurl = {
                        url: 'assets/icons/cloud-red-selected.png',
                        scaledSize : new google.maps.Size(32, 32),
                    };
            }
            if(type == "speed"){
              imageurl = {
                        url: 'assets/icons/speedometer-red-selected.png',
                        scaledSize : new google.maps.Size(32, 32),
                    };
            }
            if(type == "temperature"){
              imageurl = {
                        url: 'assets/icons/thermometer-tool-red-selected.png',
                        scaledSize : new google.maps.Size(40, 40),
                    };
            }

            marker.setIcon(imageurl);


            showVehicleDetails(marker.get("vehicleNo"), marker.get("alertType"),marker.get("alertDesc"), marker.get("driverName"), marker.get("driverContact"), marker.get("routeDescription"));

      });

      markerClusterArray.push(marker);




    }


    function showVehicleDetails(vehicleNo, alertType, alertDesc,  driverName, driverContact, routeDescription)
    {
      selectedVehicleNo = vehicleNo;
      $("#alertTypeDetails").html(alertType);
      $("#alertDescDetails").html(alertDesc);
      $("#vehicleNoDetails").html(vehicleNo);
      $("#driverNameDetails").html("Test Driver (1234567890)");
      $("#routeDescDetails").html(routeDescription);
      $("#vehicleDetails").show();
    }

    function showShipment(){
      $("#shipment").addClass("active");
      $("#action").removeClass("active")
      $("#snapshot").removeClass("active")
      $("#shipmentHeader").addClass("active show")
      $("#actionHeader").removeClass("active show")
      $("#snapshotHeader").removeClass("active show")
    }

    function showAction(){
      $("#shipment").removeClass("active");
      $("#action").addClass("active")
      loadActionData();
      $("#snapshot").removeClass("active")
      $("#shipmentHeader").removeClass("active show")
      $("#actionHeader").addClass("active show")
      $("#snapshotHeader").removeClass("active show")
    }

     function loadData() {
                       $.ajax({
                           url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getDashBoardCounts",
                            data: {
                                custId: 1,
                                routeId: 2
                            },
                            "dataSrc": "vehicleCounts",
                            success: function(result) {
                              console.log("Result RAW", result);
                                results = JSON.parse(result);
                                console.log("Result parsed", results);


                                $("#inTransitCount").text(results["vehicleCounts"][0].inTransit);
                                $("#onTime").text(results["vehicleCounts"][0].ontimeCount);
                                $("#delayedHubDeparture").text(results["vehicleCounts"][0].delayedLateDeparture);
                                $("#delayLess").text(results["vehicleCounts"][0].delayLess);
                                $("#stoppageDelayLess").text(results["vehicleCounts"][0].stoppageDelayLess);
                                $("#deviationDelayless").text(results["vehicleCounts"][0].deviationDelayless);
                                $("#delayGreater").text(results["vehicleCounts"][0].delayGreater);
                                $("#stoppagedelayGreater").text(results["vehicleCounts"][0].stoppagedelayGreater);
                                 $("#deviationDelayGreater").text(results["vehicleCounts"][0].deviationDelayGreater);
                                $("#loadingUnloading").text(results["vehicleCounts"][0].loadingUnloading);
      								$("#onTimeLoading").text(results["vehicleCounts"][0].loadUnloadOnTime);
      								$("#loadUnloadLess").text(results["vehicleCounts"][0].loadUnloadLess);
      								$("#loadUnloadGreater").text(results["vehicleCounts"][0].loadUnloadGreater);
      								$("#speedAlertCount").text(results["vehicleCounts"][0].speedAlertCount);
      								$("#unUtilizedVeh").text(results["vehicleCounts"][0].unUtilizedVehTotal);
      								$("#enroute").text(results["vehicleCounts"][0].enroute);
      								$("#waitingInstructions").text(results["vehicleCounts"][0].unUtilizedVeh);
       								$("#nonReporting").text(results["vehicleCounts"][0].nonReporting);
       								$("#fuel").text(results["vehicleCounts"][0].lowFuelCount);
       								$("#battery").text(results["vehicleCounts"][0].lowBatteryCount);
       								$("#speedAlertCount").text(results["vehicleCounts"][0].overSpeedCount);
                					$("#temperature").text(results["vehicleCounts"][0].coolantTempCount);
                			}
                 });
	}

	function saveRemarks(){
		var remarks = document.getElementById('alertActionRemarks').value;
		if( remarks == 'undefined' || remarks.value == 'undefined' ){
			alert("Please enter remarks");
			return;
		}else if(remarks.trim() ==''){
			alert("Please enter remarks");
			return;
		}
		$.ajax({
                           url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=saveDashboardRemarks",
                            data: {
                                remarks: remarks,
                                tripId: remarksTripId
                            },
                            //"dataSrc": "vehicleCounts",
                            success: function(result) {

								document.getElementById('alertActionRemarks').value="";
                $("#alertActionRemarks").hide();
                $("#btnAlertAction").hide();
                $("#remarksSaved").show();
                $("#remarksWrapper").show();
                $("#remarksCard").html(remarks);

								//to-do //reload the data tables for remarks entered.
                loadActionData();

                			}
                 });

	}

  </script>
</body>

</html>
