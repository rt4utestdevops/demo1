<!doctype html>
<html lang="en">
   <head>
      <meta charset="utf-8" />
      <link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
      <link rel="icon" type="image/png" href="assets/img/favicon1.png">
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
      <title>
         Rane T4U - Future
      </title>
      <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport' />
      <!--     Fonts and icons     -->
      <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
      <!-- CSS Files -->
      <link href="assets/css/material-dashboard.css?v=2.1.0" rel="stylesheet" />
      <!-- CSS Just for demo purpose, don't include it in your project -->
      <link href="assets/demo/demo.css" rel="stylesheet" />
      <style>
      .table > tbody > tr > td, .table > tfoot > tr > td {
            padding: 2px;
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
                  <li class="nav-item" onclick="$('#childpast').toggle()">
                     <a class="nav-link" href="#0">
                        <i class="material-icons">history</i>
                        <p>Past Performance</p>
                     </a>
                     <ul id="childpast" class="nav" style="margin-left:40px;margin-top:8px;display:none">
                        <li class="nav-item">
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
                  <li class="nav-item active ">
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
                                 <h4 style="margin-top:8px">FUTURE OPTIMIZATION</h4>
                               </div>

                            </div>
                              <ul class="nav nav-tabs navAlign" data-tabs="tabs">
                                 <li class="nav-item">
                                    <a class="nav-link active" href="#analytics" data-toggle="tab">Analytics</a>
                                 </li>
                                 <li class="nav-item">
                                    <a class="nav-link" href="#planning" data-toggle="tab">Planning</a>
                                 </li>
                              </ul>
                           </div>
                        </div>
                     </div>
                     <div class="card-body " style="overflow-y:auto;overflow-x:hidden;">
                        <div class="tab-content text-center">
                           <div class="tab-pane active" id="analytics">
                              ANALYTICS
                           </div>
                           <div class="tab-pane" id="planning">
                              PLANNING
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
         $(document).ready(function() {
           // Javascript method's body can be found in assets/js/demos.js
           demo.initGoogleMaps();
         });
      </script>
   </body>
</html>
