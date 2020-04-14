<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<jsp:include page="../Common/header.jsp" />

<div ng-app="myApp">

      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="description" content="">
      <meta name="author" content="">
      <title>Dashboard</title>
      <!-- Bootstrap Core CSS -->
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="/Telematics4uApp/Main/resources/css/DistributionLogisticsDashboardStyles.css" rel="stylesheet">
      <link href='https://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900italic,900' rel='stylesheet' type='text/css'>
      <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
      <![endif]-->
      
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
     
      <!-- Bootstrap Core JavaScript -->
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <style>
     	.loader1{
   			position: absolute;
   			top: 50%;
   			left: 50%;
   			margin-top: -50px;
   			margin-left: -50px;
   		}
   		.running-trips {
    		top: 35% !important;
    	}
    	.footer {
    		//bottom : -10px !important;
    	}
	   </style> 

   <div ng-controller="myCtrl">
      <!--.header-->
     
      <!-- /.header-->
      <!-- .page-wrapper-->
      <div class="">
         <div class="overall-status">
            <div class="container">
               <h1>Welcome to Dashboard of {{clientName}}</h1>
               <div class="status-details">
                  <div class="status-elems">
                     <a href=""><h3 class="ontime" id="onTimeId" ng-bind="onTimeId" ng-click="filters.tripStatus = 'ON TIME'">0</h3></a>
                     <h6>On Time <br/></h6>
                  </div>
                  <div class="status-elems">
                     <a href=""><h3 class="delayed" id="delayedId" ng-bind="delayedId" ng-click="filters.tripStatus = 'DELAYED'">0</h3></a>
                     <h6>Delayed <br/></h6>
                  </div>
                  <div class="status-elems">
                     <a href=""><h3 class="delayed-address" id="delayedAddressId" ng-bind="delayedAddressId" ng-click="filters.tripStatus = 'ADDRESSED'">0</h3></a>
                     <h6>Delay<br/>
                        Addressed
                     </h6>
                  </div>
                  <div class="status-elems">
                     <a href=""><h3 class="before-time" id="beforeTimeId" ng-bind="beforeTimeId" ng-click="filters.tripStatus = 'BEFORE TIME'">0</h3></a>
                     <h6>Before<br/>
                        Time
                     </h6>
                  </div>
                  <div class="status-elems">
                     <a href="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/AlertReport.jsp?dashBoard=new&dashBoard=new&AlertId=2&AlertName=Over Speed&data='123'---'555'---'2434'&fromdatefordetailspage=Sun Jan 01 2017 00:00:00 GMT 0530 (India Standard Time)&todatefordetailspage=Sun Jan 29 2017 00:00:00 GMT 0530 (India Standard Time)&typefordetailspage=IN TRANSIT&fromlocationfordetailspage=0&fromlocationIdfordetailspage=0&tolocationfordetailspage=0&tolocationIdfordetailspage=0"><h3 class="over-time" id="overSpeedId" ng-bind="overSpeedId" ng-click="filters.tripStatus = ''">0</h3></a>
                     <h6>Over<br/>
                        Speed
                     </h6>
                  </div>
                  <div class="status-elems">
                      <a href="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/AlertReport.jsp?dashBoard=new&AlertId=1&AlertName=Vehicle Stoppage&data='123'---'555'---'2434'&fromdatefordetailspage=Sun Jan 01 2017 00:00:00 GMT 0530 (India Standard Time)&todatefordetailspage=Sun Jan 29 2017 00:00:00 GMT 0530 (India Standard Time)&typefordetailspage=IN TRANSIT&fromlocationfordetailspage=0&fromlocationIdfordetailspage=0&tolocationfordetailspage=0&tolocationIdfordetailspage=0"><h3 class="vehicle-stoppage" id="vehicleStoppageId" ng-bind="vehicleStoppageId" ng-click="filters.tripStatus = ''">0</h3></a>
                     <h6>Vehicle<br/>
                        Stoppage
                     </h6>
                  </div>
                  <div class="clearfix"></div>
               </div>
            </div>
            <!-- /.container-fluid -->
         </div>
         <div class="running-trips">
            <div class="row">
               <div class="col-md-3 col-sm-4">
                  <h3 class="running-trips-title">In-Transit Trips <span></span></h3>
               </div>
               <div class="col-md-9 col-sm-8">
                  <div class="trip-filter">
                     <div class="title">
                        <h6>Search</h6>
                     </div>
                     <div class="filters">
                        <div class=" material-form">
                           <input type="text" required="required" ng-model="filters.vehicleNo">
                           <label for="input" class="control-label">Vehicle No.</label><i class="bar"></i>
                        </div>
                     </div>
					 
					 <div class="filters">
						<div class=" material-form">
                        <input type="text" required="required" ng-model="filters.tripNo">
                        <label for="input" class="control-label">Shipment ID.</label><i class="bar"></i>
                      </div>
                  
                </div>
                    
                 <!--   <div class="search-filter">
                        <a href="#">
                        <img src="/ApplicationImages/DashBoard/search_icon.svg" alt="search_icon">
                        </a>
                     </div> -->
                     <div class="clearfix"></div>
                  </div>
               </div>
            </div>
            <!-- .fixed-grid-style-->
            <div class="fixed-grid-style table-responsive">
               <table class="table table-fixed">
                  <thead>
                     <tr>
                        <th><span>Source</span><span style="padding-left: 95px;"> Destination</span></th>
                        <th >Shipment ID</th>
                        <th >Current Location</th>
                        <th >Status</th>
                     </tr>
                  </thead>
                  <tbody>
                  <div id = "jspPageId" class="loader loader1" ng-show="loading">
                  <img src = "/ApplicationImages/ApplicationButtonIcons/loader.gif" alt="loading">
                  <h6>Loading...</h6>
                  </div>
                     <tr ng-repeat="row in dashboardDetails | filter:filters">
                        <td >
                           <div class="journey-details">
                              <div class="from">
                                 <div class="circle"></div>
                                 <p>{{row.source}}</p>
                              </div>
                              <div class="to">
                                 <div class="circle"></div>
                                 <p>{{row.destination}}</p>
                              </div>
                              <div class="distance">
                                 <span>{{row.totalDistance}}</span>
                              </div>
                              <div class="vehicle-details">
                                 <img src="/ApplicationImages/DashBoard/truck-side-view.svg" class="truck-side-view">
                                 <span>
                                  <a href="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/DashboardDetails.jsp?dashBoard=new&data={{row.tripId}}---{{row.vehicleNo}}---{{row.tripNo}}">{{row.vehicleNo}}</a>
                                </span>
                              </div>
                              <div class="clearfix"></div>
                           </div>
                        </td>
                        <td >
                          <a href="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/DashboardDetails.jsp?dashBoard=new&data={{row.tripId}}---{{row.vehicleNo}}---{{row.tripNo}}"><h5>{{row.tripNo}}</h5></a>
                      </td>
                        <td >
                           <div class="current-loc">
                              <div class="location-icon">
                                 <img src="/ApplicationImages/DashBoard/location-pin.svg" alt="location-pin">
                              </div>
                              <div class="location">
							  {{row.location}}
                              </div>
                              <div class="clearfix"></div>
                           </div>
                        </td>
                        <td >
                           <div class="horizontal-step-nav">
                              <ul ng-class="{success:row.tripStatus=='ON TIME',error:row.tripStatus=='DELAYED',onTimeClass:row.tripStatus=='BEFORE TIME',delayedAddressClass:row.tripStatus=='ADDRESSED'}">
                                 <li ng-repeat="x in row.touchPoints" ng-class="{completed:x.currentPoint,active:x.currentPoint}"  data-html="true" data-placement="top" data-toggle="popover" data-trigger="click" data-content='<div class="popover-content-wrap"><div class="popover-item"><div class="popover-elems"> <p>Name: </p></div><div class="popover-elems"> <p>{{x.pointName}}</p></div></div><div class="popover-item"><div class="popover-elems"> <p>ETA: </p></div><div class="popover-elems"> <p>{{x.eta }}</p></div></div><div class="popover-item"><div class="popover-elems"> <p>Distance: </p></div><div class="popover-elems"><p>{{x.touchPointDistance}} KM</p></div></div><div class="popover-item"><div class="popover-elems"> <p>Contact No.: </p></div><div class="popover-elems"><p>{{row.driverNumber}}</p></div></div><div class="clearfix"></div></div>' >  {{alphabet[$index]}}</li>
                              </ul>
                              <p>{{row.distanceTravelled | number:2 }} KM Covered</p>
                           </div>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </div>
            <!-- /.fixed-grid-style-->
         </div>
      </div>
      <!-- /.page-wrapper
      <footer class="footer">
         <img src="/ApplicationImages/DashBoard/t4u_logo.png" alt="t4u_logo">
         <span>telematics4u © 2017</span>
      </footer>-->
      
     
      
      
      <!-- jQuery Version 3.1.1 -->
   
   	<script type="text/javascript">
   	var path = "<%=request.getContextPath()%>";
   	setTimeout(function(){
   		window.location.reload(1);
	}, 120000);
   	
   	</script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.6.1/angular.min.js"></script>
    <script src="/Telematics4uApp/Main/Js/distributionLogisticsDashboardMain.js"></script>
   </div>
</div>

 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
