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
    Rane T4U - Scorecard
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
  <link rel="stylesheet" href="assets/css/bootstarp-datepicker.min.css">

  <style>
    .table>tbody>tr>td,
    .table>tfoot>tr>td {
      padding: 2px;
    }

    .flex {
      display: flex;
      padding: 16px 16px;
    }

    .flex-col {
      display: flex;
      flex-direction: column;
    }

    .flex-only {
      display: flex;
    }

    .flex-center {
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .row-center {
      display: flex;
      align-items: center;
    }

    .h-center {
      justify-content: center;
      display: flex;
    }

    .option-head {
      padding: 9px !important;
      margin-top: -8px !important;
      margin-left: -6px !important;
      margin-bottom: 16px;
      display: inline-block;
    }

    .left {
      width: 50%
    }

    .middle {
      width: 30%
    }

    .right {
      width: 20%;
      text-align: center;
    }

    .rotateUp {
      -webkit-transform: rotate(270deg);
      -moz-transform: rotate(270deg);
      -o-transform: rotate(270deg);
      -ms-transform: rotate(270deg);
      transform: rotate(270deg);
      color: green;

    }

    .rotateDown {
      -webkit-transform: rotate(90deg);
      -moz-transform: rotate(90deg);
      -o-transform: rotate(90deg);
      -ms-transform: rotate(90deg);
      transform: rotate(90deg);
      color: red;

    }

    .rotateLeft{
      -webkit-transform: rotate(180deg);
      -moz-transform: rotate(180deg);
      -o-transform: rotate(180deg);
      -ms-transform: rotate(180deg);
      transform: rotate(180deg);
      color: yellow;
      margin-right:-2px;
    }

    .rotateRight{
      margin-left:-2px;
      color: yellow;
    }

    .red {
      background-color: red;
      color: white;
    }

    .green {
      background-color: green;
      color: white;
    }

    .yellow {
      background-color: yellow;
      color: black;
    }

    .orange {
      background-color: yellow;
      color: black;
    }

    .oval {
      width: 80px;
      height: 40px;
      -moz-border-radius: 100px / 50px;
      -webkit-border-radius: 100px / 50px;
      border-radius: 100px / 50px;
      text-align: center;
      padding: 8px;
    }

    .route-score {
      height: 100%;
      border-radius: 2;
      margin-right: 5px;
    }

    .option {
      cursor: pointer;
      align-items: center;
    }

    .option:active,
    .option-active,
    .option:hover {
      background-color: #E6E6E6;
    }

    .score-low {
      width: 50%;
      background-color: red;
    }

    .score-mid {
      width: 70%;
      background-color: yellow;
    }

    .score-high {
      width: 90%;
      background-color: green;
    }

    .col1 {
      width: 20%
    }

    .col2 {
      width: 40%
    }

    .col3 {
      width: 20%
    }

    .col4 {
      width: 20%;
      padding-left:24px;
    }

    .btn-dropdown {
      background: #3A5A85;
      color: white;
      width: 100%;
      text-align: left;
    }

    .arg {
      color: #4472C5;
    }

    .arg-head {
      font-size: 1.3rem;
      font-weight: bolder
    }

    .arg-param {
      font-size: 0.8rem;
      font-weight: 600;
    }

    .driver-table {
      position: relative;
      border: solid #f7f7f9;
      border-width: .2rem;
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

    .column{
      height:430px;
      overflow-y: auto;
    }

    .overflowMedia{
      overflow-y:hidden !important;
    }

@media (max-width: 992px) {
    .overflowMedia{
      overflow-y:auto !important;
    }
  }

  .underline{
        border-bottom: 3px solid #ffeb3b;
  }

  </style>
</head>

<body class="">
  <div class="wrapper ">
    <div class="sidebar" data-image="bg.png" data-color="purple" data-background-color="white">
      <div class="logo">
        <a href="#" class="simple-text" style="background:#093166;margin-top:-6px;padding:8px;">
          <img src="http://www.ranet4u.com/images/logo.png" style="width:140px;" alt="logo" />
        </a>
      </div>
      <div class="sidebar-wrapper">
        <ul class="nav">
          <li class="nav-item ">
            <a class="nav-link" href="DashboardMcKinsey.jsp">
              <i class="material-icons">dashboard</i>
              <p>Current Status</p>
            </a>
          </li>
          <li class="nav-item  active" onclick="$('#childpast').toggle()">
            <a class="nav-link" href="#0">
              <i class="material-icons">history</i>
              <p>Past Performance</p>
            </a>
            <ul id="childpast" class="nav" style="margin-left:40px;margin-top:8px;">
              <li class="nav-item active">
                <a class="nav-link" href="scorecard.jsp" style="background:#3A5A85">
                  <i class="material-icons">score</i>
                  <p>Scorecard</p>
                </a>
              </li>
              <li class="nav-item">
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
    <div id="mainPanel" class="main-panel overflowMedia">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-transparent navbar-absolute fixed-top ">
        <div class="container-fluid">

          <div class="card card-nav-tabs card-plain">
            <div class="card-header card-header-info">
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
                      <h4 style="margin-top:8px">PAST PERFORMANCE > Scorecard</h4>
                    </div>

                 </div>
                   <ul class="nav nav-tabs navAlign" data-tabs="tabs">
                    <li class="nav-item">
                      <a id="overallHeader" class="nav-link active" href="#overall" data-toggle="tab">Overall</a>
                    </li>
                    <li class="nav-item">
                      <a id="routeHeader" class="nav-link" href="#route" data-toggle="tab">Route</a>
                    </li>
                    <li class="nav-item">
                      <a id="driverHeader" class="nav-link" href="#driver" data-toggle="tab">Driver</a>
                    </li>
                    <li class="nav-item">
                      <a id="vehicleHeader" class="nav-link" href="#vehicle" data-toggle="tab">Vehicle</a>
                    </li>
                    <li class="nav-item">
                      <a id="locationHeader" class="nav-link" href="#location" data-toggle="tab">Location</a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="card-body " >
              <div class="tab-content text-center">
                <div class="tab-pane active" id="overall">
                  <div class="row" style="height:90vh;text-align:left;">
                    <div class="col-xs-12 col-md-12 col-lg-6">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body">
                          <div class="card-header card-header-info option-head" style="margin-top:-10px;">
                            <select id="selectVehicleIdShipment" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:180px;">
                              <option value="0">Select Customer</option>
                              <option value="1">Customer 1</option>
                              <option value="2">Customer 2</option>
                              <option value="3">Customer 3</option>
                            </select>
                          </div>
                          <div class="flex text-primary" style="margin-top:8px;background: #093166;color: white !important;border-radius: 4px;">
                            <div class="left"></div>
                            <div class="middle">MTD (Out of 10)</div>
                            <div class="right">M-o-M (%)</div>
                          </div>
                          <div class="flex option option-active" data-value="option1">
                            <div class="left">Transit-Time Adherence</div>
                            <div class="middle">
                              <div class="oval green">8.5</div>
                            </div>
                            <div class="right h-center">
                              <span>2.0</span>
                              <i class="material-icons rotateUp">forward</i>
                            </div>
                          </div>
                          <div class="flex option" data-value="option2">
                            <div class="left">Vehicle Utilization Score</div>
                            <div class="middle">
                              <div class="oval yellow">7.0</div>
                            </div>
                            <div class="right h-center">
                              <span>1.0</span>
                              <i class="material-icons rotateUp">forward</i>

                            </div>
                          </div>
                          <div class="flex option" data-value="option3">
                            <div class="left">Loading Time Adherence</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <span>-2.0</span>
                              <i class="material-icons rotateDown">forward</i>
                            </div>
                          </div>
                          <div class="flex option" data-value="option4">
                            <div class="left">Unloading Time Adherence</div>
                            <div class="middle">
                              <div class="oval green">7.7</div>
                            </div>
                            <div class="right h-center">
                                <span>-0.5</span>
                              <i class="material-icons rotateDown">forward</i>
                            </div>
                          </div>
                          <div class="flex option" data-value="option5">
                            <div class="left">Safety Norms Adherence</div>
                            <div class="middle">
                              <div class="oval yellow">5</div>
                            </div>
                            <div class="right h-center">
                              <span>0.5</span>
                              <i class="material-icons rotateUp">forward</i>
                            </div>
                          </div>
                          <div class="flex option" data-value="option6">
                            <div class="left">Maintenance Norms Adherence</div>
                            <div class="middle">
                              <div class="oval red">3</div>
                            </div>
                            <div class="right h-center">
                              <span>0.0</span>
                              <i class="material-icons rotateUp">forward</i>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-6">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body" id="overall-option-details-1">
                          <div class="card-header card-header-info option-head"  style="background:#3A5A85">
                            Route Transit Time Score
                          </div>
                          <h3 style="margin-top:0px;"></h3>
                          <div class="flex text-primary" style="background: #3A5A85;color: white !important;border-radius: 4px;">
                            <div class="col1">Route Id</div>
                            <div class="col2">Route Description</div>
                            <div class="col3">Route Score</div>
                            <div class="col4">M-o-M (%)</div>
                          </div>
                          <div class="column" id="routeScore">
                          </div>
                        </div>
                        <div class="card-body" id="overall-option-details-2" style="display: none">
                          <div class="card-header card-header-info option-head"  style="background:#3A5A85">
                            Vehicle Utilization Score
                          </div>
                          <h3 style="margin-top:0px;"></h3>
                          <div class="flex text-primary" style="background: #3A5A85;color: white !important;border-radius: 4px;">
                            <div class="col1">Veh-Id</div>
                            <div class="col2">Vehicle Description</div>
                            <div class="col3">Utilization Score</div>
                            <div class="col4">M-o-M (%)</div>
                          </div>
                          <div class="column" id="utilisationScore">

                          </div>
                        </div>
                        <div class="card-body" id="overall-option-details-3" style="display: none">
                          <div class="card-header card-header-info option-head" style="background:#3A5A85">
                            Location Loading Time Adherence Score
                          </div>
                          <h3 style="margin-top:0px;"></h3>
                          <div class="flex text-primary" style="background: #3A5A85;color: white !important;border-radius: 4px;">
                            <div class="col1">Loc-Id</div>
                            <div class="col2">Loc Description</div>
                            <div class="col3">Hub Score</div>
                            <div class="col4">M-o-M (%)</div>
                          </div>
                          <div class="column" id="loadingScore">

                          </div>
                        </div>
                        <div class="card-body" id="overall-option-details-4" style="display: none">
                          <div class="card-header card-header-info option-head" style="background:#3A5A85">
                            Location Unloading Time Adherence Score
                          </div>
                          <h3 style="margin-top:0px;"></h3>
                          <div class="flex text-primary" style="background: #3A5A85;color: white !important;border-radius: 4px;">
                            <div class="col1">Loc-Id</div>
                            <div class="col2">Loc Description</div>
                            <div class="col3">Hub Score</div>
                            <div class="col4">M-o-M (%)</div>
                          </div>
                          <div class="column" id="unloadingScore">

                          </div>
                        </div>
                        <div class="card-body" id="overall-option-details-5" style="display: none">
                          <div class="card-header card-header-info option-head"  style="background:#3A5A85">
                            Safety Norms Score
                          </div>
                          <h3 style="margin-top:0px;"></h3>
                          <div class="flex text-primary" style="background: #3A5A85;color: white !important;border-radius: 4px;">
                            <div class="col1">Driver-Id</div>
                            <div class="col2">Driver Description</div>
                            <div class="col3">Driver Score</div>
                            <div class="col4">M-o-M (%)</div>
                          </div>
                          <div class="column" id="safetyScore">

                          </div>
                        </div>
                        <div class="card-body" id="overall-option-details-6" style="display: none">
                          <div class="card-header card-header-info option-head"  style="background:#3A5A85">
                            Vehicle Maintenance Score
                          </div>
                          <h3 style="margin-top:0px;"></h3>
                          <div class="flex text-primary" style="background: #3A5A85;color: white !important;border-radius: 4px;">
                            <div class="col1">Veh-Id</div>
                            <div class="col2">Vehicle Description</div>
                            <div class="col3">Vehicle Score</div>
                            <div class="col4">M-o-M (%)</div>
                          </div>
                          <div class="column" id="maintenanceScore">

                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="tab-pane" id="route">
                  <div class="card" style="margin-top:0px; height:80vh;">
                    <div class="card-body" style="height: 100%;">
                      <div class="col-xs-12 col-md-12 col-lg-12 flex-col" style="height: 100%;">
                        <div class="row">

                          <%-- <div style="font-weight:bold;color:white;margin:24px;">OR</div>
                          <select id="fromDropdown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                            <option value="0">FROM</option>
                            <option value="AMBALA">Ambala</option>
                            <option value="BANGALORE">Bangalore</option>
                            <option value="CHENNAI">Chennai</option>
                            <option value="COCHIN">Cochin</option>
                            <option value="DELHI">Delhi</option>
                            <option value="HYDERABAD">Hyderabad</option>
                            <option value="MUMBAI">Mumbai</option>
                          </select> <div style="font-weight:bold;color:white;">TO</div>
                          <select id="toDropdown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                            <option value="0">To</option>
                            <option value="AMBALA">Ambala</option>
                            <option value="BANGALORE">Bangalore</option>
                            <option value="CHENNAI">Chennai</option>
                            <option value="COCHIN">Cochin</option>
                            <option value="DELHI">Delhi</option>
                            <option value="MUMBAI">Mumbai</option>
                          </select> --%>
                          <%-- <div class="form-group">
                            <div class='input-group date' id='sc-route-filter-date'>
                              <input type='text' class="form-control" />
                              <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                              </span>
                            </div>
                          </div> --%>
                          <div class="col-xs-12 col-md-12 col-lg-12">

                            <div class="row" style="text-align: left;flex: 1">
                              <div class="col-xs-12 col-md-12 col-lg-6">
                                <div class="card-header card-header-info option-head" style="width: 100%; margin-top: -8px !important;">
                                  <div class="col-xs-12 col-md-12 col-lg-12">
                                    <div class="row" style="margin-bottom:16px;">
                                      <div class="col-xs-12 col-md-12 col-lg-4 row-center">
                                        <div class="form-group" style="padding: 0;margin: 0">
                                          <div style="font-weight:bold;color:white;padding-bottom:4px;">SELECT ROUTE</div>
                                          <select id="routeIdDropDown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                                            <option value="0">ROUTE ID</option>
                                          </select>
                                        </div>
                                       </div>
                                      <div class="col-xs-12 col-md-12 col-lg-4">
                                        <div class="form-group" style="padding: 0;margin: 0">
                                          <div style="font-weight:bold;color:white;padding-bottom:4px;">FILTERS</div>
                                          <select id="routeCustomer" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                                            <option value="0">SELECT CUSTOMER</option>
                                            <option value="1">Customer 1</option>
                                            <option value="2">Customer 2</option>
                                            <option value="3">Customer 3</option>
                                          </select>
                                        </div>
                                      </div>
                                      <div class="col-xs-12 col-md-12 col-lg-4" style="margin-top:28px;">
                                        <select id="truckTypeDropDown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                                            <option value="0">TRUCK TYPE</option>
                                        </select>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div class="card-header card-header-info option-head" style="margin-top: 16px !important;margin-left: -22px !important;">Route Details</div>
                                <%-- <div class="arg arg-param">Average time to complete this route</div> --%>
                                <div id="columnchart_stacked" ></div>
                              </div>
                              <div class="col-xs-12 col-md-12 col-lg-6 flex-col" style="height: 100%;">
                                <div class="flex text-primary" style="padding-top:0px">
                                  <div class="left"></div>
                                  <div class="middle">MTD (Out of 10)</div>
                                  <div class="right">Vs. (M-o-M%)</div>
                                </div>
                                <div class="flex" style="margin-bottom:16px; border-radius:4px;margin-top:-16px;">
                                  <div class="left arg arg-head">Route Score</div>
                                  <div class="middle">
                                    <div class="oval yellow" id="routeTabScore">7</div>
                                  </div>
                                  <div class="right h-center">
                                    <i id="routeTabArrow" class="material-icons rotateUp">forward</i>
                                    <span id="routeTabChangeValue" style="margin-top:10px;">0.5</span>
                                  </div>
                                </div>
                                <div class="card-header card-header-info option-head" style="margin-top:16px;width:300px;">Time to reach each hub</div>

                                <%-- <div class="arg arg-head" style="margin-left:16px;">Time to reach each hub</div> --%>
                                <div>
                                  <div id="routeRight_chart" style="margin-top:0px;"></div>
                                  <div id="loading1" style="display:none;position:absolute;width:100%;height:70vh;top:0;left:0;z-index:10000;">
                                    <div style="position:absolute;top:40%;left:40%;z-index:3">
                                    <img src="../../../Main/images/loading.gif" alt=""></div>
                                  </div>
                                  <div id="map2" style="display:none;height:70vh;padding:0px !important"></div>

                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="tab-pane" id="driver">
                  <div class="row" style="height:90vh;text-align:left;">
                    <div class="col-xs-12 col-md-12 col-lg-6">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body">
                          <div class="card-header card-header-info option-head" style="width: 75%; margin-top: -8px !important">
                            <div class="col-xs-12 col-md-12 col-lg-12">
                              <div class="row">
                                <div class="col-xs-12 col-md-12 col-lg-5 row-center">
                                  <div class="card-header card-header-info option-head" style="margin-top: 0px !important;">
                                    <select id="driverIdDropDown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                                      <option value="0">Driver ID</option>
                                    </select>
                                 </div>
                                </div>
                                <div class="col-xs-12 col-md-12 col-lg-1 flex-center" style="color: white">or</div>
                                <div class="col-xs-12 col-md-12 col-lg-6">
                                  <div class="form-group" style="padding: 0;margin: 0">
                                    <input type="email" class="form-control" id="search-driver-name" placeholder="Search" aria-describedby="driverSearch">
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                          <br/>
                          <div class="card-header card-header-info option-head" style="margin-top:16px !important;">Driver Details</div>
                          <div class="flex">

                            <div class="row driver-table" style="width: 100%; margin: 0">

                              <div class="col-xs-8 col-md-8 col-lg-12">
                                <table class="table" style="height: 100%;">
                                  <tbody>
                                    <tr>
                                      <td>Driver Name</td>
                                      <td id="driverName">Ram Dulara</td>
                                    </tr>
                                    <tr>
                                      <td>License Num</td>
                                      <td>MH234565653</td>
                                    </tr>
                                    <tr>
                                      <td>Phone Num</td>
                                      <td>+91 9900000000</td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                              <%-- <div class="col-xs-4 col-md-4 col-lg-4">
                                <img src="./assets/img/driver-icon.png" style="width: auto; height: 180px;padding-left:24px;" alt="driver-icon">
                              </div> --%>
                            </div>
                          </div>
                          <div class="card-header card-header-info option-head" style="margin-top:8px !important">Driver Score</div>
                          <div class="flex text-primary">
                            <div class="left"></div>
                            <div class="middle">MTD (Out of 10)</div>
                            <div class="right">Vs. (M-o-M%)</div>
                          </div>
                          <div class="flex">
                            <div class="left">Overall Score</div>
                            <div class="middle">
                              <div class="oval yellow"id="driverTabScore">6.0</div>
                            </div>
                            <div class="right h-center" style="align-items: center">
                              <i id="driverTabArrow" class="material-icons rotateUp">forward</i>
                              <span id="driverTabChangeValue">1</span>
                            </div>
                          </div>
                          <div class="flex option option-active" data-value="option1">
                            <div class="left">Safety Norms Score</div>
                            <div class="middle">
                              <div class="oval yellow">4.6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1</span>
                            </div>
                          </div>
                          <div class="flex option" data-value="option2" style="margin-bottom:20px;">
                            <div class="left">Transit Time Score</div>
                            <div class="middle">
                              <div class="oval green">7.25</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1</span>
                            </div>
                          </div>

                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-6">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body" id="driver-option-details-1">
                          <div class="card-header card-header-info option-head">Safety Norms Score</div>
                          <div class="flex text-primary">
                            <div class="left"></div>
                            <div class="middle">MTD (Out of 10)</div>
                            <div class="right">Vs. (M-o-M%)</div>
                          </div>
                          <div style="height:500px;overflow-y:scroll;">
                            <div class="flex row-center">
                              <div class="left">Harsh Acceleration</div>
                              <div class="middle">
                                <div class="oval yellow">7</div>
                              </div>
                              <div class="right h-center">
                                <i class="material-icons rotateUp">forward</i>
                                <span>2%</span>
                              </div>
                            </div>
                            <div class="flex row-center">
                              <div class="left">Harsh Braking</div>
                              <div class="middle">
                                <div class="oval yellow">5</div>
                              </div>
                              <div class="right h-center">
                                <i class="material-icons rotateUp">forward</i>
                                <span>1%</span>
                              </div>
                            </div>
                            <div class="flex row-center">
                              <div class="left">Harsh Cornering</div>
                              <div class="middle">
                                <div class="oval yellow">6</div>
                              </div>
                              <div class="right h-center">
                                <i class="material-icons rotateUp">forward</i>
                                <span>1%</span>
                              </div>
                            </div>
                            <div class="flex row-center">
                              <div class="left">Over Speeding</div>
                              <div class="middle">
                                <div class="oval yellow">5</div>
                              </div>
                              <div class="right h-center">
                                <i class="material-icons rotateDown">forward</i>
                                <span>1%</span>
                              </div>
                            </div>
                            <div class="flex row-center">
                              <div class="left">Tail Gating</div>
                              <div class="middle">
                                <div class="oval yellow">5</div>
                              </div>
                              <div class="right h-center" style="flex-direction:column">
                                <span>0%</span>
                                <div><i class="material-icons rotateLeft">forward</i><i class="material-icons rotateRight">forward</i></div>
                              </div>
                            </div>
                            <div class="flex row-center">
                              <div class="left">Crash Detection</div>
                              <div class="middle">
                                <div class="oval green">10</div>
                              </div>
                              <div class="right h-center" style="flex-direction:column">
                                <span>0%</span>
                                <div><i class="material-icons rotateLeft">forward</i><i class="material-icons rotateRight">forward</i></div>
                              </div>
                            </div>
                            <%-- <div class="flex row-center">
                              <div class="left">Irregular Driving Pattern</div>
                              <div class="middle">
                                <div class="oval green">8</div>
                              </div>
                              <div class="right h-center">
                                <i class="material-icons rotateUp">forward</i>
                                <span class="underline">0%</span>
                              </div>
                            </div>
                            <div class="flex row-center">
                              <div class="left">Device Tampering</div>
                              <div class="middle">
                                <div class="oval green">9</div>
                              </div>
                              <div class="right h-center">
                                <i class="material-icons rotateUp">forward</i>
                                <span class="underline">0%</span>
                              </div>
                            </div> --%>
                          </div>
                        </div>
                        <div class="card-body" id="driver-option-details-2" style="display: none;height:625px;">
                          <div class="card-header card-header-info option-head">Transit Time Score</div>
                          <div class="flex text-primary">
                            <div class="left"></div>
                            <div class="middle">MTD (Out of 10)</div>
                            <div class="right">Vs. (M-o-M%)</div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Mileage</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Delay Deliveries</div>
                            <div class="middle">
                              <div class="oval green">8</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>2%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Unplanned Stoppage</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateDown">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Idling</div>
                            <div class="middle">
                              <div class="oval yellow">7</div>
                            </div>
                            <div class="right h-center" style="flex-direction:column">
                              <span>0%</span>
                              <div><i class="material-icons rotateLeft">forward</i><i class="material-icons rotateRight">forward</i></div>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Delayed Deliveries</div>
                            <div class="middle">
                              <div class="oval yellow">8</div>
                            </div>
                            <div class="right h-center" style="flex-direction:column">
                              <span>0%</span>
                              <div><i class="material-icons rotateLeft">forward</i><i class="material-icons rotateRight">forward</i></div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="tab-pane" id="vehicle">
                  <div class="row" style="height:90vh;text-align:left;">
                    <div class="col-xs-12 col-md-12 col-lg-5">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body">
                          <div class="card-header card-header-info option-head" style="width: 75%; margin-top: -8px !important">
                            <div class="col-xs-12 col-md-12 col-lg-12">
                              <div class="row">
                                <div class="col-xs-12 col-md-12 col-lg-5 row-center">
                                  <div class="card-header card-header-info option-head" style="margin-top: 0px !important;">
                                    <select id="vehicleIdDropDown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                                      <option value="0">Vehicle ID</option>
                                    </select>
                                 </div>
                                </div>
                                <div class="col-xs-12 col-md-12 col-lg-1 flex-center" style="color: white">or</div>
                                <div class="col-xs-12 col-md-12 col-lg-6">
                                  <div class="form-group" style="padding: 0;margin: 0">
                                    <input type="email" class="form-control" id="search-vehicle-id" placeholder="Vehicle Num" aria-describedby="driverSearch">
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                          <br/>
                          <div class="card-header card-header-info option-head" style="margin-top:16px !important;">Vehicle Details</div>
                          <div class="flex">
                            <div class="row driver-table" style="width: 100%; margin: 0">
                              <div class="col-xs-12 col-md-12 col-lg-12">
                                <table class="table" style="height: 100%;">
                                  <tbody>
                                    <tr>
                                      <td>Vehicle Num</td>
                                      <td id="vehNo"></td>
                                    </tr>
                                    <tr>
                                      <td>Vehicle Type Num</td>
                                      <td id="vehType"></td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                            </div>
                          </div>
                          <div class="card-header card-header-info option-head" style="margin-top:8px !important;">Vehicle Score</div>
                          <div class="flex text-primary">
                            <div class="left"></div>
                            <div class="middle">MTD (Out of 10)</div>
                            <div class="right">Vs. (M-o-M%)</div>
                          </div>
                          <div class="flex option option-active" data-value="option1">
                            <div class="left">Utilization</div>
                            <div class="middle">
                              <div id="vehicleTabScore" class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i id="vehicleTabArrow" class="material-icons rotateUp">forward</i>
                              <span id="vehicleTabChangeValue">1%</span>
                            </div>
                          </div>
                          <div class="flex option" data-value="option2" style="margin-bottom:60px;">
                            <div class="left">Vehicle Health Score</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-7">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body" id="vehicle-option-details-1">
                          <div class="card-header card-header-info option-head">Un-utilized hours (last 30 days)</div>
                          <div class="flex flex-center">
                            <div id="unutilized_chart"></div>
                          </div>
                        </div>
                        <div class="card-body" id="vehicle-option-details-2" style="display: none;height:560px;">
                          <div class="card-header card-header-info option-head">Vehicle Health Score (per 100 kms)</div>
                          <div class="flex text-primary">
                            <div class="left"></div>
                            <div class="middle">MTD (Out of 10)</div>
                            <div class="right">Vs. (M-o-M%)</div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Mileage</div>
                            <div class="middle">
                              <div class="oval yellow">7</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Battery Health</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Fuel System Health</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Turbo System Health</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Coolant System Health</div>
                            <div class="middle">
                              <div class="oval yellow">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateUp">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                          <div class="flex row-center">
                            <div class="left">Engine Error Codes</div>
                            <div class="middle">
                              <div class="oval green">6</div>
                            </div>
                            <div class="right h-center">
                              <i class="material-icons rotateDown">forward</i>
                              <span>1%</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="tab-pane" id="location">
                  <div class="row" style="height:90vh;text-align:left;">
                    <div class="col-xs-12 col-md-12 col-lg-5">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body" style="height:600px;">
                          <div class="card-header card-header-info option-head" style="width: 75%; margin-top: -8px !important">
                            <div class="col-xs-12 col-md-12 col-lg-12">
                              <div class="row">
                                <div class="col-xs-12 col-md-12 col-lg-5 row-center">
                                  <div class="card-header card-header-info option-head" style="margin-top: 0px !important;">
                                    <select id="locationIdDropdown" style="padding: 6px 8px 6px 8px;background: #3A5A85;color: white;border-radius:4px;border:0px;width:200px;">
                                      <option value="0">Location ID</option>
                                    </select>
                                 </div>
                                </div>
                                <div class="col-xs-12 col-md-12 col-lg-1 flex-center" style="color: white">or</div>
                                <div class="col-xs-12 col-md-12 col-lg-6">
                                  <div class="form-group" style="padding: 0;margin: 0">
                                    <input type="email" class="form-control" id="search-location-desc" placeholder="Location Desc" aria-describedby="driverSearch">
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div><br/>
                            <div class="card-header card-header-info option-head" style="margin-top:16px !important;">Location Score</div>
                            <div class="flex text-primary">
                              <div class="left"></div>
                              <div class="middle">MTD (Out of 10)</div>
                              <div class="right">Vs. (M-o-M%)</div>
                            </div>
                          <div class="flex option" onclick="javascript:locChartType = '1';initiateDrawChartloc();" data-value="option1" style="margin-top: 20px;">
                            <div class="left">Loading time Score</div>
                            <div class="middle">
                              <div id="locTabScore" class="oval yellow">6.0</div>
                            </div>
                            <div class="right h-center">
                              <i id="locTabArrow" class="material-icons rotateDown">forward</i>
                              <span id="locTabChangeValue">1%</span>
                            </div>
                          </div>
                          <div class="flex option"  onclick="javascript:locChartType = '2';initiateDrawChartloc();" data-value="option2" style="margin-top: 20px;">
                            <div class="left">UnLoading time Score</div>
                            <div class="middle">
                              <div id="locTabScore1" class="oval green">8.0</div>
                            </div>
                            <div class="right h-center">
                              <i id="locTabArrow1" class="material-icons rotateUp">forward</i>
                              <span id="locTabChangeValue1">2%</span>
                            </div>
                          </div>
                          <div class="flex option"  onclick="javascript:locChartType = '3';initiateDrawChartloc();" data-value="option3" style="margin-top: 20px;">
                            <div class="left">Gate-IN detention time</div>
                            <div class="middle">
                              <div id="locTabScore2" class="oval yellow">7.0</div>
                            </div>
                            <div class="right h-center" style="flex-direction:column">
                              <span id="locTabChangeValue2" >0%</span>
                              <div><i class="material-icons rotateLeft">forward</i><i class="material-icons rotateRight">forward</i></div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-7">
                      <div class="card" style="margin-top:0px;">
                        <div class="card-body" id="vehicle-option-details-1">
                          <div class="card-header card-header-info option-head">Average loading and unloading time</div>
                          <input type="reset" style="border-radius:8px;margin-left:24px;" onclick="javascript:locChartType = 'all';initiateDrawChartloc();" value="Reset">
                          <div style="height:600px;overflow-y:scroll;"><div class="flex flex-center" style="flex-direction:column;">
                              <div id="columnchart_stackedLoc" style="margin-left:0px"></div>
                              <div id="columnchart_stackedLoc1" style="margin-left:0px"></div>
                              <div id="columnchart_stackedLoc2" style="margin-left:16px"></div>
                              <div style="width:100%;text-align:left;margin-left:0px;">
                                <table border="1" style="width:80%;margin-top:16px;">
                                  <tr>
                                    <td>Days</td>
                                    <td>1</td>
                                    <td>2</td>
                                    <td>3</td>
                                    <td>4</td>
                                    <td>5</td>
                                    <td>6</td>
                                    <td>7</td>
                                    <td>8</td>
                                    <td>9</td>
                                    <td>10</td>
                                    <td>11</td>
                                    <td>12</td>
                                    <td>13</td>
                                    <td>14</td>
                                    <td>15</td>
                                    <td>16</td>
                                    <td>17</td>
                                    <td>18</td>
                                    <td>19</td>
                                    <td>20</td>
                                    <td>21</td>
                                    <td>22</td>
                                    <td>23</td>
                                    <td>24</td>
                                    <td>25</td>
                                    <td>26</td>
                                    <td>27</td>
                                    <td>28</td>
                                    <td>29</td>
                                    <td>30</td>
                                  </tr>
                                  <tr>
                                    <td>No. Trucks</td>
                                    <td>30</td>
                                    <td>33</td>
                                    <td>34</td>
                                    <td>30</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>35</td>
                                    <td>30</td>
                                    <td>30</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>30</td>
                                    <td>33</td>
                                    <td>30</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>25</td>
                                    <td>35</td>
                                    <td>30</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>60</td>
                                    <td>25</td>
                                    <td>28</td>
                                    <td>30</td>
                                    <td>30</td>
                                    <td>30</td>
                                  </tr>
                                <table>
                              </div>
                          </div></div>
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
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"></script>
  <!-- Chartist JS -->
  <script src="assets/js/plugins/chartist.min.js"></script>
  <!--  Notifications Plugin    -->
  <script src="assets/js/plugins/bootstrap-notify.js"></script>
  <!-- Control Center for Material Dashboard: parallax effects, scripts for the example pages etc -->
  <script src="assets/js/material-dashboard.js" type="text/javascript"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
  <script type="text/javascript" src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1.1','packages':['corechart']}]}"></script>
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

  $("#routeHeader").on("click", function(){
    setTimeout(function(){ drawChart(); drawChartRouteRight(); },150);
  })
  $("#locationHeader").on("click", function(){
    setTimeout(function(){ initiateDrawChartloc(); },150);
  })


  google.load("visualization", '1.1', { packages: ['corechart'] });
  google.setOnLoadCallback(drawChart);


function drawChart() {
    var today = new Date();
    today = new Date(today.setDate(today.getDate() - 29));


    var data = google.visualization.arrayToDataTable([
      ['Days', 'Hub1', 'Hub2', 'Hub3'],
      [today.getDate().toString(),	8,	8,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	10,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	11,	5],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	8,	8],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	11,	5],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	11],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	12,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	10,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	9,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	10,	5],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	9,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	10,	8],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	12,	5],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	11,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	11,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	10,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	7,	9,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	10,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8,	9,	7],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	9,	9],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	10,	8],
      [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	6,	12,	7]
    ]);

    var options = {
        width: 850,
        height: 425,
        vAxis: {title: "Hours to complete trip"},
        hAxis: {title: "Days", showTextEvery: 1},
        bar: { groupWidth: '75%' },
        isStacked: true,
        legend: { position: 'top', alignment: 'start' },
        colors: ['#039BE5', '#0277BD', '#01579B']
    };

    var view = new google.visualization.DataView(data);
    var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_stacked'));
    google.visualization.events.addListener(chart, 'select', function () {
        highlightBar(chart, options, view);
    });
    chart.draw(data, options);
}

google.load("visualization", '1.1', { packages: ['corechart'] });
google.setOnLoadCallback(drawChartLoc);



function initiateDrawChartloc(){
  google.load("visualization", '1.1', { packages: ['corechart'] });
  google.setOnLoadCallback(drawChartLoc);
  drawChartLoc()
}
function drawChartLoc() {
  if(locChartType == "all" || locChartType == "1"){
      var today = new Date();
      today = new Date(today.setDate(today.getDate() - 29));
      var data = google.visualization.arrayToDataTable([
        ['Days', 'Hours'],
        [today.getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.75],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.25],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3.75],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),4],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.75],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.75],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.75],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3]

      ]);

      var options = {
        title:"Avg. Loading Time",
          width: 800,
          height: 200,
          vAxis: {title: "Avg. loading & waiting time in hrs"},
          hAxis: {title: "Days", showTextEvery: 1},
          bar: { groupWidth: '75%' },
          isStacked: true,
          legend: { position: 'none' },
          colors: [ '#0277BD']
      };

      if(locChartType != "all"){
        document.getElementById('columnchart_stackedLoc1').innerHTML = "";
        document.getElementById('columnchart_stackedLoc2').innerHTML = "";
        options = {
          title:"Avg. Loading Time",
            width: 800,
            height: 430,
            vAxis: {title: "Avg. loading & waiting time in hrs"},
            hAxis: {title: "Days", showTextEvery: 1},
            bar: { groupWidth: '75%' },
            isStacked: true,
            legend: { position: 'none' },
            colors: [ '#0277BD']
        };
      }

      var view = new google.visualization.DataView(data);
      var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_stackedLoc'));
      google.visualization.events.addListener(chart, 'select', function () {
          highlightBar(chart, options, view);
      });
      chart.draw(data, options);


  }

  if(locChartType == "all" || locChartType == "2"){

      var today = new Date();
      today = new Date(today.setDate(today.getDate() - 29));
      var data = google.visualization.arrayToDataTable([
        ['Days', 'Hours'],
        [today.getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),3],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2.5],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2],
        [new Date(today.setDate(today.getDate() +1)).getDate().toString(),2]


      ]);

      var options = {
        title:"Avg. Unloading Time",
          width: 800,
          height: 200,
          vAxis: {title: "Avg. loading & waiting time in hrs"},
          hAxis: {title: "Days", showTextEvery: 1},
          bar: { groupWidth: '75%' },
          isStacked: true,
          legend: { position: 'none' },
          colors: [ '#0277BD']
      };

      if(locChartType != "all"){
      document.getElementById('columnchart_stackedLoc').innerHTML = "";
      document.getElementById('columnchart_stackedLoc2').innerHTML = "";
      options = {
        title:"Avg. Unloading Time",
          width: 800,
          height: 430,
          vAxis: {title: "Avg. loading & waiting time in hrs"},
          hAxis: {title: "Days", showTextEvery: 1},
          bar: { groupWidth: '75%' },
          isStacked: true,
          legend: { position: 'none' },
          colors: [ '#0277BD']
      };
      }

      var view = new google.visualization.DataView(data);
      var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_stackedLoc1'));
      google.visualization.events.addListener(chart, 'select', function () {
          highlightBar(chart, options, view);
      });
      chart.draw(data, options);


  }

  if(locChartType == "all" || locChartType == "3"){

      var today = new Date();
      today = new Date(today.setDate(today.getDate() - 29));
      var data = google.visualization.arrayToDataTable([
        ['Days', 'Hours'],
        [today.getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.75],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.75],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.75],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.75],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.25],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),1],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.5],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.75],
          [new Date(today.setDate(today.getDate() +1)).getDate().toString(),0.75],


      ]);



      var options = {
          title: "Avg. Waiting Time (gate-in time)",
          width: 800,
          height: 200,
          vAxis: {title: "Avg. loading & waiting timein hrs"},
          hAxis: {title: "Days", showTextEvery: 1},
          bar: { groupWidth: '75%' },
          isStacked: true,
          legend: { position: 'none'},
          colors: [ '#0277BD']
      };

      if(locChartType != "all"){
      document.getElementById('columnchart_stackedLoc1').innerHTML = "";
      document.getElementById('columnchart_stackedLoc').innerHTML = "";
      options = {
          title: "Avg. Waiting Time (gate-in time)",
          width: 800,
          height: 470,
          vAxis: {title: "Avg. loading & waiting time in hrs"},
          hAxis: {title: "Days", showTextEvery: 1},
          bar: { groupWidth: '75%' },
          isStacked: true,
          legend: { position: 'none'},
          colors: [ '#0277BD']
      };
      }

      var view = new google.visualization.DataView(data);
      var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_stackedLoc2'));
      google.visualization.events.addListener(chart, 'select', function () {
          highlightBar(chart, options, view);
      });
      chart.draw(data, options);



    }
}

google.load("visualization", '1.1', { packages: ['corechart'] });
google.setOnLoadCallback(drawChartUnutilized);
function drawChartUnutilized() {
  var today = new Date();
  today = new Date(today.setDate(today.getDate() - 29));
  var data = google.visualization.arrayToDataTable([
    ['Days', 'Hours'],
    [today.getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	8],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	16],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	3],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	5],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	4],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	14],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	5],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	15],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	24],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	3],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0],
    [new Date(today.setDate(today.getDate() +1)).getDate().toString(),	0]
  ]);

  var options = {
      width: 850,
      height: 475,
      vAxis: {title: "Time spent on road in Hrs"},
      hAxis: {title: "Days", showTextEvery: 1},
      bar: { groupWidth: '75%' },
      isStacked: true,
      legend: { position: 'none'},
      colors: [ '#0277BD']
  };

  var view = new google.visualization.DataView(data);
  var chart = new google.visualization.ColumnChart(document.getElementById('unutilized_chart'));
  google.visualization.events.addListener(chart, 'select', function () {
      highlightBar(chart, options, view);
  });
  chart.draw(data, options);
}

google.load("visualization", '1.1', { packages: ['corechart'] });
google.setOnLoadCallback(drawChartRouteRight);
function drawChartRouteRight() {

  var data = google.visualization.arrayToDataTable([
    ['Days', 'Min Time','Max Time','Avg. Time'],
    ['Route',	21,30,26],
    ['Hub1',	6,8,7],
    ['Hub2',	8,11,9],
    ['Hub3',	7,11,8],

  ]);

  var options = {
      width: 650,
      height: 425,
      vAxis: {title: "Hours"},
      hAxis: {title: "Performance of hub in past 30 days"},
      bar: { groupWidth: '75%' },
      legend: { position: 'top', alignment: 'start' },
      colors: ['#039BE5', '#0277BD', '#01579B']
  };

  var view = new google.visualization.DataView(data);
  var chart = new google.visualization.ColumnChart(document.getElementById('routeRight_chart'));
  google.visualization.events.addListener(chart, 'select', function () {
      highlightBar(chart, options, view);
  });
  chart.draw(data, options);
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
     var locChartType = "all";

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

  function initialize() {
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

      map2 = new google.maps.Map(document.getElementById('map2'), mapOptions);

    //map.fitBounds(bounds);
      var trafficLayer = new google.maps.TrafficLayer();
      trafficLayer.setMap(map2);

      var geocoder = new google.maps.Geocoder();

      geocoder.geocode( {'address' : '<%=countryName%>'}, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            map2.setCenter(results[0].geometry.location);
          }
      });
  }

  function routeIdOnChange()
  {
    globalTripId = $('#routeIdDropDown option:selected').attr("tripId");
    globalTripStartTime = $('#routeIdDropDown option:selected').attr("tripStartTime");
    globalRouteId = $('#routeIdDropDown option:selected').attr("routeId");
    selectedVehicleNo = $('#routeIdDropDown option:selected').attr("vehicleNo");

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
              map2MarkerImage = 'assets/icons/delivery-van-green.png';
              if(result.status == "red")
              {
                map2MarkerImage = 'assets/icons/delivery-van-red.png';
              }
              initialize();
              $("#loading1").show()
              plotOnMap(globalRouteId,"shipment")
            }
          });

  }


    $(document).ready(function () {
      // Javascript method's body can be found in assets/js/demos.js

      //initialize();
       $("#selectVehicleIdShipment").select2();
        $("#routeCustomer").select2();
        $("#fromDropdown").select2();
        $("#toDropdown").select2();
        $("#routeIdDropDown").select2();
        $("#truckTypeDropDown").select2();
        $("#driverIdDropDown").select2();
        $("#vehicleIdDropDown").select2();
        $("#locationIdDropdown").select2();

        $('#routeIdDropDown').on('select2:select', function (e) {
          //routeIdOnChange();

        });


        // $.ajax({
        //      type: "POST",
        //      url: "<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehicleNoAndShipmentIdOnTrip",
        //       data: {
        //       },
        //      success: function(result) {
        //       result = JSON.parse(result).vehicleListRoot;
        //        $("#routeIdDropDown").empty().select2();
        //        $('#routeIdDropDown').append($("<option></option>").attr("value", 0).text("Select Shipment ID"));
        //        for (var i = 0; i < result.length; i++) {
        //           $('#routeIdDropDown').append($("<option></option>").attr("shipmentId", result[i].shipmentId).text(result[i].shipmentId).attr("vehicleNo", result[i].vehicleNo).attr("routeId", result[i].routeId).attr("tripId", result[i].tripId).attr("tripStartTime", result[i].tripStartTime));
        //        }
        //        $("#routeIdDropDown").select2();
        //     }
        //    });

       $.ajax({
            type: "GET",
            url: 'time.json',
            success: function(result) {

              var routeScoreHtml = "";
              $.each(result, function(i, item) {
                routeScoreHtml += '<div class="flex">';
                routeScoreHtml += '<div class="col1">';
                var changeStatus = "rotateDown";
                if(item.changeStatus == "green"){ changeStatus = "rotateUp"}
                routeScoreHtml += "<a style='color:purple;cursor:pointer' onclick='routeIdClick(\""+item.routeName+"\",\""+item.routeScoreStatus+"\",\""+item.routeScore+"\",\""+changeStatus+"\",\""+item.change+"\",\""+item.routeKey+"\")' title='"+item.routeName+"'>" + item.routeName.substring(0,6) + " ...</a>";
                $("#routeIdDropDown").append("<option value ='"+item.routeName+"'>"+item.routeName+"</option>")
                routeScoreHtml += '</div>';
                routeScoreHtml += '<div class="col2">'+item.routeKey+'</div>';
                routeScoreHtml += '<div class="col3 flex-only">';
                var scoreClass = "score-high";
                if(item.routeScoreStatus == "orange")
                {
                  scoreClass = "score-mid"
                }
                else if(item.routeScoreStatus == "red")
                {
                  scoreClass = "score-low";
                }
                routeScoreHtml += '<span class="route-score '+scoreClass+'"></span>';
                routeScoreHtml += '<span>'+item.routeScore+'</span>';
                routeScoreHtml += '</div>';
                routeScoreHtml += '<div class="col4 flex-only">';
                routeScoreHtml += '<i class="material-icons '+changeStatus+'">forward</i>';
                routeScoreHtml += '<span>'+item.change+'</span>';
                routeScoreHtml += '</div>';
                routeScoreHtml += '</div>';
              })

              $("#routeScore").html(routeScoreHtml)
            }
       })

       $.ajax({
            type: "GET",
            url: 'utilization.json',
            success: function(result) {

              var utilizationScoreHtml = "";
              $.each(result, function(i, item) {
                utilizationScoreHtml += '<div class="flex">';
                utilizationScoreHtml += '<div class="col1">';
                var changeStatus = "rotateDown";
                if(item.changeStatus == "green"){ changeStatus = "rotateUp"}
                utilizationScoreHtml += "<a  style='color:purple;cursor:pointer' onclick='vehicleIdUtilizationClick(\""+item.vehicleNo+"\",\""+item.vehicleDesc+"\",\""+item.utilizationScore+"\",\""+item.utilizationScoreStatus+"\",\""+item.change+"\",\""+changeStatus+"\")' title='"+item.vehicleNo+"'>" + item.vehicleNo + "</a>";
                utilizationScoreHtml += '</div>';
                utilizationScoreHtml += '<div class="col2">'+item.vehicleDesc+'</div>';
                $("#truckTypeDropDown").append("<option value ='"+item.vehicleDesc+"'>"+item.vehicleDesc+"</option>")
                $("#vehicleIdDropDown").append("<option value ='"+item.vehicleNo+"'>"+item.vehicleNo+"</option>")
                utilizationScoreHtml += '<div class="col3 flex-only">';
                var scoreClass = "score-high";
                if(item.utilizationScoreStatus == "orange")
                {
                  scoreClass = "score-mid"
                }
                else if(item.utilizationScoreStatus == "red")
                {
                  scoreClass = "score-low";
                }
                utilizationScoreHtml += '<span class="route-score '+scoreClass+'"></span>';
                utilizationScoreHtml += '<span>'+item.utilizationScore+'</span>';
                utilizationScoreHtml += '</div>';
                utilizationScoreHtml += '<div class="col4 flex-only">';
                utilizationScoreHtml += '<i class="material-icons '+changeStatus+'">forward</i>';
                utilizationScoreHtml += '<span>'+item.change+'</span>';
                utilizationScoreHtml += '</div>';
                utilizationScoreHtml += '</div>';
              })

              $("#utilisationScore").html(utilizationScoreHtml)
            }
       })

       $.ajax({
            type: "GET",
            url: 'loading.json',
            success: function(result) {

              var loadinghtml = "";
              $.each(result, function(i, item) {
                loadinghtml += '<div class="flex">';
                loadinghtml += '<div class="col1">';
                var changeStatus = "rotateDown";
                if(item.changeStatus == "green"){ changeStatus = "rotateUp"}
                loadinghtml += "<a style='color:purple;cursor:pointer' onclick='locationIdClick(\""+item.locationName+"\",\""+item.locScoreStatus+"\",\""+item.locScore+"\",\""+changeStatus+"\",\""+item.change+"\")' title='"+item.locationName+"'>" + item.locationName + "</a>";
                $("#locationIdDropdown").append("<option value ='"+item.locationName+"'>"+item.locationName+"</option>")
                loadinghtml += '</div>';
                loadinghtml += '<div class="col2">'+item.locationDesc+'</div>';
                loadinghtml += '<div class="col3 flex-only">';
                var scoreClass = "score-high";
                if(item.locScoreStatus == "orange")
                {
                  scoreClass = "score-mid"
                }
                else if(item.locScoreStatus == "red")
                {
                  scoreClass = "score-low";
                }
                loadinghtml += '<span class="route-score '+scoreClass+'"></span>';
                loadinghtml += '<span>'+item.locScore+'</span>';
                loadinghtml += '</div>';
                loadinghtml += '<div class="col4 flex-only">';
                loadinghtml += '<i class="material-icons '+changeStatus+'">forward</i>';
                loadinghtml += '<span>'+item.change+'</span>';
                loadinghtml += '</div>';
                loadinghtml += '</div>';
              })

              $("#loadingScore").html(loadinghtml)
            }
       })

       $.ajax({
            type: "GET",
            url: 'unloading.json',
            success: function(result) {

              var unloadinghtml = "";
              $.each(result, function(i, item) {
                unloadinghtml += '<div class="flex">';
                unloadinghtml += '<div class="col1">';
                var changeStatus = "rotateDown";
                if(item.changeStatus == "green"){ changeStatus = "rotateUp"}
                unloadinghtml += "<a style='color:purple;cursor:pointer' onclick='locationIdUnloadingClick(\""+item.locationName+"\",\""+item.locScoreStatus+"\",\""+item.locScore+"\",\""+changeStatus+"\",\""+item.change+"\")' title='"+item.locationName+"'>" + item.locationName + "</a>";
                unloadinghtml += '</div>';
                unloadinghtml += '<div class="col2">'+item.locationDesc+'</div>';
                unloadinghtml += '<div class="col3 flex-only">';
                var scoreClass = "score-high";
                if(item.locScoreStatus == "orange")
                {
                  scoreClass = "score-mid"
                }
                else if(item.locScoreStatus == "red")
                {
                  scoreClass = "score-low";
                }
                unloadinghtml += '<span class="route-score '+scoreClass+'"></span>';
                unloadinghtml += '<span>'+item.locScore+'</span>';
                unloadinghtml += '</div>';
                unloadinghtml += '<div class="col4 flex-only">';
                unloadinghtml += '<i class="material-icons '+changeStatus+'">forward</i>';
                unloadinghtml += '<span>'+item.change+'</span>';
                unloadinghtml += '</div>';
                unloadinghtml += '</div>';
              })

              $("#unloadingScore").html(unloadinghtml)
            }
       })

       $.ajax({
            type: "GET",
            url: 'safety.json',
            success: function(result) {

              var safetyhtml = "";
              $.each(result, function(i, item) {
                safetyhtml += '<div class="flex">';
                safetyhtml += '<div class="col1">';
                var changeStatus = "rotateDown";
                if(item.changeStatus == "green"){ changeStatus = "rotateUp"}
                safetyhtml += "<a style='color:purple;cursor:pointer' onclick='driverIdClick(\""+item.driverId+"\",\""+item.driverName+"\",\""+item.driverScore+"\",\""+item.driverScoreStatus+"\",\""+changeStatus+"\",\""+item.change+"\")' title='"+item.driverId+"'>" + item.driverId + "</a>";
                $("#driverIdDropDown").append("<option value ='"+item.driverId+"'>"+item.driverId+"</option>")
                safetyhtml += '</div>';
                safetyhtml += '<div class="col2">'+item.driverName+'</div>';
                safetyhtml += '<div class="col3 flex-only">';
                var scoreClass = "score-high";
                if(item.driverScoreStatus == "orange")
                {
                  scoreClass = "score-mid"
                }
                else if(item.driverScoreStatus == "red")
                {
                  scoreClass = "score-low";
                }
                safetyhtml += '<span class="route-score '+scoreClass+'"></span>';
                safetyhtml += '<span>'+item.driverScore+'</span>';
                safetyhtml += '</div>';
                safetyhtml += '<div class="col4 flex-only">';
                safetyhtml += '<i class="material-icons '+changeStatus+'">forward</i>';
                safetyhtml += '<span>'+item.change+'</span>';
                safetyhtml += '</div>';
                safetyhtml += '</div>';
              })

              $("#safetyScore").html(safetyhtml)
            }
       })

       $.ajax({
            type: "GET",
            url: 'maintenance.json',
            success: function(result) {

              var maintenanceHtml = "";
              $.each(result, function(i, item) {
                maintenanceHtml += '<div class="flex">';
                maintenanceHtml += '<div class="col1">';
                var changeStatus = "rotateDown";
                if(item.changeStatus == "green"){ changeStatus = "rotateUp"}
                maintenanceHtml += "<a style='color:purple;cursor:pointer' onclick='vehicleIdMaintenanceClick(\""+item.vehicleNo+"\",\""+item.vehicleDesc+"\",\""+item.vehicleScore+"\",\""+item.vehicleScoreStatus+"\",\""+item.change+"\",\""+changeStatus+"\")' title='"+item.vehicleNo+"'>" + item.vehicleNo + "</a>";
                maintenanceHtml += '</div>';
                maintenanceHtml += '<div class="col2">'+item.vehicleDesc+'</div>';
                maintenanceHtml += '<div class="col3 flex-only">';
                var scoreClass = "score-high";
                if(item.vehicleScoreStatus == "orange")
                {
                  scoreClass = "score-mid"
                }
                else if(item.vehicleScoreStatus == "red")
                {
                  scoreClass = "score-low";
                }
                maintenanceHtml += '<span class="route-score '+scoreClass+'"></span>';
                maintenanceHtml += '<span>'+item.vehicleScore+'</span>';
                maintenanceHtml += '</div>';
                maintenanceHtml += '<div class="col4 flex-only">';
                maintenanceHtml += '<i class="material-icons '+changeStatus+'">forward</i>';
                maintenanceHtml += '<span>'+item.change+'</span>';
                maintenanceHtml += '</div>';
                maintenanceHtml += '</div>';
              })

              $("#maintenanceScore").html(maintenanceHtml)
            }
       })


    });

    function routeIdClick(routeId, routeScoreStatus, routeScore, changeStatus, changeScore,routeKey)
    {

      var fromTo = routeKey.split("_");
       $("#fromDropdown").val(fromTo[0]).trigger('change');
       $("#toDropdown").val(fromTo[1]).trigger('change');
       $("#routeIdDropDown").val(routeId).trigger('change');
      // $("#routeIdDropDown").val($("#routeIdDropDown option:eq(1)").val()).trigger('change');
    //  routeIdOnChange();

      $("#routeTabScore").html(routeScore);
      $("#routeTabScore").removeClass("red");
      $("#routeTabScore").removeClass("green");
      $("#routeTabScore").removeClass("orange");
      $("#routeTabScore").addClass(routeScoreStatus);
      $("#routeTabChangeValue").html(changeScore);
      $("#routeTabArrow").removeClass("rotateUp");
      $("#routeTabArrow").removeClass("rotateDown");
      $("#routeTabArrow").addClass(changeStatus);
      $("#overall").removeClass("active")
      $("#route").addClass("active")
      $("#driver").removeClass("active")
      $("#vehicle").removeClass("active")
      $("#location").removeClass("active")
      $("#overallHeader").removeClass("active show")
      $("#routeHeader").addClass("active show")
      $("#driverHeader").removeClass("active show")
      $("#vehicleHeader").removeClass("active show")
      $("#locationHeader").removeClass("active show")
      setTimeout(function(){drawChart(); drawChartRouteRight(); },150);

    }

    function locationIdUnloadingClick(locationId, locScoreStatus, locScore, changeStatus, changeScore)
    {

      $("#locationIdDropdown").val(locationId).trigger('change');

      $("#locTabScore1").html(locScore);
      $("#locTabScore1").removeClass("red");
      $("#locTabScore1").removeClass("green");
      $("#locTabScore1").removeClass("orange");
      $("#locTabScore1").addClass(locScoreStatus);
      $("#locTabChangeValue1").html(changeScore);
      $("#locTabArrow1").removeClass("rotateUp");
      $("#locTabArrow1").removeClass("rotateDown");
      $("#locTabArrow1").addClass(changeStatus);

      $("#overallHeader").removeClass("active show")
      $("#routeHeader").removeClass("active show")
      $("#driverHeader").removeClass("active show")
      $("#vehicleHeader").removeClass("active show")
      $("#locationHeader").addClass("active show")
      $("#overall").removeClass("active")
      $("#route").removeClass("active")
      $("#driver").removeClass("active")
      $("#vehicle").removeClass("active")
      $("#location").addClass("active")
      setTimeout(function(){initiateDrawChartloc() },150);

    }

    function locationIdClick(locationId, locScoreStatus, locScore, changeStatus, changeScore)
    {

      $("#locationIdDropdown").val(locationId).trigger('change');

      $("#locTabScore").html(locScore);
      $("#locTabScore").removeClass("red");
      $("#locTabScore").removeClass("green");
      $("#locTabScore").removeClass("orange");
      $("#locTabScore").addClass(locScoreStatus);
      $("#locTabChangeValue").html(changeScore);
      $("#locTabArrow").removeClass("rotateUp");
      $("#locTabArrow").removeClass("rotateDown");
      $("#locTabArrow").addClass(changeStatus);

      $("#overallHeader").removeClass("active show")
      $("#routeHeader").removeClass("active show")
      $("#driverHeader").removeClass("active show")
      $("#vehicleHeader").removeClass("active show")
      $("#locationHeader").addClass("active show")
      $("#overall").removeClass("active")
      $("#route").removeClass("active")
      $("#driver").removeClass("active")
      $("#vehicle").removeClass("active")
      $("#location").addClass("active")
      setTimeout(function(){initiateDrawChartloc() },150);

    }

    function driverIdClick(driverId, driverName, driverScore, driverScoreStatus, changeStatus, changeScore)
    {

      $("#driverTabScore").html(driverScore);
      $("#driverTabScore").removeClass("red");
      $("#driverTabScore").removeClass("green");
      $("#driverTabScore").removeClass("orange");
      $("#driverTabScore").removeClass("yellow");
      $("#driverTabScore").addClass(driverScoreStatus);
      $("#driverTabChangeValue").html(changeScore);
      $("#driverTabArrow").removeClass("rotateUp");
      $("#driverTabArrow").removeClass("rotateDown");
      $("#driverTabArrow").addClass(changeStatus);

      $("#driverIdDropDown").val(driverId).trigger('change');
      $("#driverName").html(driverName)
      $("#overallHeader").removeClass("active show")
      $("#routeHeader").removeClass("active show")
      $("#driverHeader").addClass("active show")
      $("#vehicleHeader").removeClass("active show")
      $("#locationHeader").removeClass("active show")
      $("#overall").removeClass("active")
      $("#route").removeClass("active")
      $("#driver").addClass("active")
      $("#vehicle").removeClass("active")
      $("#location").removeClass("active")

    }

    function vehicleIdUtilizationClick(vehicleNo, vehDesc, vehicleScore, vehicleScoreStatus, changeScore, changeStatus)
    {
      $("#vehicleIdDropDown").val(vehicleNo).trigger('change');
      $("#vehNo").html(vehicleNo)
      $("#vehType").html(vehDesc)
      $("#overallHeader").removeClass("active show")
      $("#routeHeader").removeClass("active show")
      $("#driverHeader").removeClass("active show")
      $("#vehicleHeader").addClass("active show")
      $("#locationHeader").removeClass("active show")
      $("#overall").removeClass("active")
      $("#route").removeClass("active")
      $("#driver").removeClass("active")
      $("#vehicle").addClass("active")
      $("#location").removeClass("active")


      $("#vehicleTabScore").html(vehicleScore);
      $("#vehicleTabScore").removeClass("red");
      $("#vehicleTabScore").removeClass("green");
      $("#vehicleTabScore").removeClass("yellow");
      $("#vehicleTabScore").removeClass("orange");
      $("#vehicleTabScore").addClass(vehicleScoreStatus);
      $("#vehicleTabChangeValue").html(changeScore);
      $("#vehicleTabArrow").removeClass("rotateUp");
      $("#vehicleTabArrow").removeClass("rotateDown");
      $("#vehicleTabArrow").addClass(changeStatus);


    }

    function vehicleIdMaintenanceClick(vehicleNo, vehDesc , vehicleScore, vehicleScoreStatus, changeScore, changeStatus)
    {
      $("#vehicleIdDropDown").val(vehicleNo).trigger('change');
      $("#vehNo").html(vehicleNo)
      $("#vehType").html(vehDesc)
      $("#overallHeader").removeClass("active show")
      $("#routeHeader").removeClass("active show")
      $("#driverHeader").removeClass("active show")
      $("#vehicleHeader").addClass("active show")
      $("#locationHeader").removeClass("active show")
      $("#overall").removeClass("active")
      $("#route").removeClass("active")
      $("#driver").removeClass("active")
      $("#vehicle").addClass("active")
      $("#location").removeClass("active")

      $("#vehicleTabScore").html(vehicleScore);
      $("#vehicleTabScore").removeClass("red");
      $("#vehicleTabScore").removeClass("green");
      $("#vehicleTabScore").removeClass("yellow");
      $("#vehicleTabScore").removeClass("orange");
      $("#vehicleTabScore").addClass(vehicleScoreStatus);
      $("#vehicleTabChangeValue").html(changeScore);
      $("#vehicleTabArrow").removeClass("rotateUp");
      $("#vehicleTabArrow").removeClass("rotateDown");
      $("#vehicleTabArrow").addClass(changeStatus);

    }

  </script>
  <script type="text/javascript" src="./assets/js/bootstrap-datepicker.min.js"></script>
  <script src="./assets/js/custom/scorecard.js" type="text/javascript"></script>
</body>

</html>
