<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
  <link rel="icon" type="image/png" href="assets/img/favicon1.png">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>
    Rane T4U - Reports
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
    .report-table {
      position: relative;
      border: solid #f7f7f9;
      border-width: .2rem;
      overflow-x: auto;
    }
    .option-head {
      padding: 9px !important;
      margin-top: -8px !important;
      margin-left: -6px !important;
      margin-bottom: 16px;
      display: inline-block;
    }

    .btn-dropdown {
      background: #3A5A85;
      color: white;
      width: 100%;
      text-align: left;
    }

    .report-form {
      padding: 0 10px;
      margin-top: 15px;
    }

    .report-form>[class*='col-'] {
      margin: 5px 0px;
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
              <li class="nav-item">
                <a class="nav-link" href="scorecard.jsp">
                  <i class="material-icons">score</i>
                  <p>Scorecard</p>
                </a>
              </li>
              <li class="nav-item active">
                <a class="nav-link" href="reports.jsp" style="background:#3A5A85">
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
                      <h4 style="margin-top:8px">PAST PERFORMANCE </h4>
                    </div>

                 </div>
                   <ul class="nav nav-tabs navAlign" data-tabs="tabs">
                    <li class="nav-item">
                      <a class="nav-link active" href="#reports" data-toggle="tab">Reports</a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="card-body " style="overflow-y:auto;overflow-x:hidden;">
              <div class="tab-content text-center">
                <div class="tab-pane active" id="reports">
                  <div class="row" style="margin-top:-12px;">
                    <div class="col-xs-12 col-md-12 col-lg-6">
                      <div class="card">
                        <div class="card-body">
                          <div class="card-header card-header-info option-head" style="margin: 0 0 0 -5px !important; display: flex; width: 52%">Input</div>
                          <div class="row report-form">
                            <div class="col-xs-6 col-md-4 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportRouteFrom"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  All Routes From
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportRouteFrom">
                                  <a class="dropdown-item" href="#">Route1</a>
                                  <a class="dropdown-item" href="#">Route2</a>
                                  <a class="dropdown-item" href="#">Route3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-4 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportRouteTo"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  All Routes To
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportRouteTo">
                                  <a class="dropdown-item" href="#">Route1</a>
                                  <a class="dropdown-item" href="#">Route2</a>
                                  <a class="dropdown-item" href="#">Route3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-4 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportVehicle"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  All Vehicles
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportVehicle">
                                  <a class="dropdown-item" href="#">Vecicle 1</a>
                                  <a class="dropdown-item" href="#">Vecicle 2</a>
                                  <a class="dropdown-item" href="#">Vecicle 3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-4 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportDriver"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  All Drivers
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportDriver">
                                  <a class="dropdown-item" href="#">Driver1</a>
                                  <a class="dropdown-item" href="#">Driver2</a>
                                  <a class="dropdown-item" href="#">Driver3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-4 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportCustomer"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  All Customers
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportCustomer">
                                  <a class="dropdown-item" href="#">Customer1</a>
                                  <a class="dropdown-item" href="#">Customer2</a>
                                  <a class="dropdown-item" href="#">Customer3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-4 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportDate"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  All Dates
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportDate">
                                  <li class="dropdown-item" value="date1">Date 1</li>
                                  <li class="dropdown-item" value="date2">Date 1</li>
                                  <li class="dropdown-item" value="date3">Date 1</li>
                                </ul>
                              </div>
                            </div>
                          </div>
                          <div class="card-header card-header-info option-head" style="margin: 10px 0 0 -5px !important; display: flex; width: 52%">Output (Shipment Details)</div>
                          <div class="row report-form">
                            <div class="col-xs-6 col-md-6 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportRouteTT"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  Transit Time
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportRouteTT">
                                  <a class="dropdown-item" href="#">Route1</a>
                                  <a class="dropdown-item" href="#">Route2</a>
                                  <a class="dropdown-item" href="#">Route3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-6 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportLUT"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  Loading/Unloadng Time
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportLUT">
                                  <a class="dropdown-item" href="#">Route1</a>
                                  <a class="dropdown-item" href="#">Route2</a>
                                  <a class="dropdown-item" href="#">Route3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-6 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportTTA"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  Transit Time Alerts
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportTTA">
                                  <a class="dropdown-item" href="#">Vecicle 1</a>
                                  <a class="dropdown-item" href="#">Vecicle 2</a>
                                  <a class="dropdown-item" href="#">Vecicle 3</a>
                                </div>
                              </div>
                            </div>
                            <div class="col-xs-6 col-md-6 col-lg-6">
                              <div class="dropdown" style="width: 100%;">
                                <button class="btn dropdown-toggle btn-dropdown" style="padding: 6px 8px 6px 8px;" type="button" id="dropdownMenuButtonReportSA"
                                  data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  Safety Alerts
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButtonReportSA">
                                  <a class="dropdown-item" href="#">Driver1</a>
                                  <a class="dropdown-item" href="#">Driver2</a>
                                  <a class="dropdown-item" href="#">Driver3</a>
                                </div>
                              </div>
                            </div>
                          </div>
                          <div style="padding-top: 25px">
                            <button class="btn btn-primary">Create Report</button>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-md-12 col-lg-6">
                      <div class="card">
                        <div class="card-body" >
                          <div class="report-table">
                            <table class="table">
                              <thead>
                                <tr>
                                  <th>Shipment ID</th>
                                  <th>Date</th>
                                  <th>Route Desc</th>
                                  <th>Driver ID</th>
                                  <th>Vehicle ID</th>
                                  <th>Customer ID</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <td>1</td>
                                  <td>12/12/2014</td>
                                  <td>Blt to MUM</td>
                                  <td>CVM 101</td>
                                  <td>MH 04 233</td>
                                  <td>DHL101</td>
                                </tr>
                                <tr>
                                  <td>1</td>
                                  <td>12/12/2014</td>
                                  <td>Blt to MUM</td>
                                  <td>CVM 101</td>
                                  <td>MH 04 233</td>
                                  <td>DHL101</td>
                                </tr>
                                <tr>
                                  <td>1</td>
                                  <td>12/12/2014</td>
                                  <td>Blt to MUM</td>
                                  <td>CVM 101</td>
                                  <td>MH 04 233</td>
                                  <td>DHL101</td>
                                </tr>
                                <tr>
                                  <td>1</td>
                                  <td>12/12/2014</td>
                                  <td>Blt to MUM</td>
                                  <td>CVM 101</td>
                                  <td>MH 04 233</td>
                                  <td>DHL101</td>
                                </tr>
                              </tbody>
                            </table>
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
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"></script>
  <!-- Chartist JS -->
  <script src="assets/js/plugins/chartist.min.js"></script>
  <!--  Notifications Plugin    -->
  <script src="assets/js/plugins/bootstrap-notify.js"></script>
  <!-- Control Center for Material Dashboard: parallax effects, scripts for the example pages etc -->
  <script src="assets/js/material-dashboard.js" type="text/javascript"></script>
  <script src="assets/demo/demo.js"></script>
  <script>
    $(document).ready(function () {
      // Javascript method's body can be found in assets/js/demos.js
      demo.initGoogleMaps();
    });
  </script>
</body>

</html>
