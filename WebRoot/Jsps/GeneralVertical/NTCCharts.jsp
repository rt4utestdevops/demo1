<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Properties properties = ApplicationListener.prop;
  /* String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();*/
%>

<jsp:include page="../Common/header.jsp" />
<style>
  .panel-body{
    padding:0px !important;
    position: relative;
    height: 250px
  }
  .panelInner{
    margin-bottom:0px !important;
    position: absolute;
    bottom: 0px;
    left:0px;
    right:0px;
    border: 0px !important;
  }
  .panel-footer{
    padding:0px !important;
  }
  .m-t {

    margin-top: 6px !important;}
    p {

    margin:0px 0px 6px 0px !important;
}
.padTop6{
	padding-top:6px;
}
.padTop16{
	padding-top:16px;
}
#chart1, #chart2, #chart3, #chart4, #chart5, #chart6 {height:190px;}
#chart7, #chart8 {min-height:300px;}
.navbar-brand img {
max-height: 43px !important;
margin-top: -12px !important;
vertical-align: middle !important;
}
  </style>
<link rel="stylesheet" href="../Analytics/css/bootstrap.css" type="text/css" />
<link rel="stylesheet" href="../Analytics/css/animate.css" type="text/css" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css" />
<link rel="stylesheet" href="../Analytics/css/font.css" type="text/css" />

<link rel="stylesheet" href="../Analytics/css/app.css" type="text/css" />
<link rel="stylesheet" href="../Analytics/js/datepicker/datepicker.css" type="text/css" />
 <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" type="text/css"/>
 <link rel="stylesheet" href="../Analytics/css/analytics.css" type="text/css"/>
<div class="center-view" style="display:none;" id="loading-div">
    <img src="../../Main/images/loading.gif" alt="">
  </div>
<section class="vbox" style="margin-top:-24px;">

    <section class="hbox stretch">

      <section id="content">
        <section class="vbox" >
          <section class="padder" id="contentChild">
            <div class="m-b-md" style="margin-top:-8px !important;">
              <div class="row">
                <div class="col-sm-6">
                  <div style="display:flex">
                    <div>
                    <h3 class="m-b-none m-t-smHead" id="h3Header" style="display:none;">Charts</h3>
                    <small id="lastsixmonths"></small>
                  </div>
                </div>
                </div>
                <div class="col-sm-6" style="display:none;">
                  <div class="text-right text-left-xs">
                    <div class="sparkline m-l m-r-lg pull-right" data-type="bar" data-height="35" data-bar-width="6" data-bar-spacing="2" data-bar-color="#fb6b5b">5,8,9,12,8,10,8,9,7,8,6</div>
                    <div class="m-t-sm">

                    </div>
                  </div>
                </div>
              </div>
            </div>



            <div class="row">
			<div class="col-lg-4">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">ONLINE</header>
                  <div class="panel-body"  style="height:300px;">
                    <div id="chart2"  style="height:250px;" ></div>
                    <section class="panel panel-default panelInner">
                      <footer class="panel-footer bg-white">
                        <div class="row text-center no-gutter">
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Online</p>
                            <p class="h3 font-bold m-t" style="color:#5d62b5"  id="online"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Moving</p>
                            <p class="h3 font-bold m-t" style="color:#29c3be" id="moving"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Idle</p>
                            <p class="h3 font-bold m-t" style="color:#ffc533"   id="idle"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3">
                            <p class="text-muted font-bold padTop6">Stopped</p>
                            <p class="h3 font-bold m-t" style="color:#f2726f"  id="parked"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>

                        </div>
                      </footer>
                    </section>
                  </div>
                </section>
              </div>
              <div class="col-lg-4">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">OFFLINE</header>
                  <div class="panel-body" style="height:300px;">
                    <div id="chart3" style="margin:4px;height:250px;" ></div>
                    <section class="panel panel-default panelInner">
                      <footer class="panel-footer bg-white">
                        <div class="row text-center no-gutter">
                          <div class="col-xs-4 b-r b-light">
                            <p class="text-muted font-bold padTop6">Offline</p>
                            <p class="h3 font-bold m-t" style="color:#f2726f" id="offline"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Poor GSM</p>
                            <p class="h3 font-bold m-t"  style="color:#5d62b5"    id="poorgsm"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <!--<div class="col-xs-4 b-r b-light">
                            <p class="text-muted font-bold padTop6">Poor Sa</p>
                            <p class="h3 font-bold m-t" style="color:#f2726f"   id="poorsa"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>-->
                          <div class="col-xs-4">
                            <p class="text-muted font-bold padTop6">Disconnected</p>
                            <p class="h3 font-bold m-t" style="color:#29c3be"    id="disconnected"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                        </div>
                      </footer>
                    </section>
                  </div>
                </section>
              </div>
              <div class="col-lg-4">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">LOCATION</header>
                  <div class="panel-body"  style="height:300px;">
                    <div id="chart4"  style="height:250px;"></div>
                    <section class="panel panel-default panelInner">
                      <footer class="panel-footer bg-white">
                        <div class="row text-center no-gutter">
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6">Location</p>
                            <p class="h3 font-bold m-t" style="color:#5d62b5" id="location"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6">Loading</p>
                            <p class="h3 font-bold m-t" style="color:#29c3be"   id="loading"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6">Unloading</p>
                            <p class="h3 font-bold m-t" style="color:#f2726f"   id="unloading"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Enroute</p>
                            <p class="h3 font-bold m-t" style="color:#ffc533"   id="enroute"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
        				  <div class="col-xs-3">
                            <p class="text-muted font-bold padTop6">Service Center</p>
                            <p class="h3 font-bold m-t"  id="serviceCenter"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                        </div>
                      </footer>
                    </section>
                  </div>
                </section>
              </div>
              <div class="col-lg-12"   style="display:none;">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">Chart 5</header>
                  <div class="panel-body">
                    <div id="chart5" ></div>
                    <section class="panel panel-default panelInner">
                      <footer class="panel-footer bg-white">
                        <div class="row text-center no-gutter">
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6">Alerts</p>
                            <p class="h3 font-bold m-t" id="alerts"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6" title="Over Speed">Over Sp...</p>
                            <p class="h3 font-bold m-t"  id="overspeed"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6" title="Delayed Start">Delayed...</p>
                            <p class="h3 font-bold m-t"  id="delayedstart"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Delayed Stop</p>
                            <p class="h3 font-bold m-t"  id="delayedStop"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
        				  <div class="col-xs-3">
                            <p class="text-muted font-bold padTop6">Delayed Trip</p>
                            <p class="h3 font-bold m-t"  id="delayedTrip"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                        </div>
                      </footer>
                    </section>
                  </div>
                </section>
              </div>
              <div class="col-lg-4"   style="display:none;">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">Chart 6</header>
                  <div class="panel-body">
                    <div id="chart6" ></div>
                    <section class="panel panel-default panelInner">
                      <footer class="panel-footer bg-white">
                        <div class="row text-center no-gutter">
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Halting</p>
                            <p class="h3 font-bold m-t" id="halting"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Loading Halt</p>
                            <p class="h3 font-bold m-t"  id="loadingHalt"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3 b-r b-light">
                            <p class="text-muted font-bold padTop6">Unloading Halt</p>
                            <p class="h3 font-bold m-t"  id="unloadingHalt"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-3">
                            <p class="text-muted font-bold padTop6">Enroute Halt</p>
                            <p class="h3 font-bold m-t"  id="enrouteHalt"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                        </div>
                      </footer>
                    </section>
                  </div>
                </section>
              </div>
            </div>


            <div class="row">
              <div class="col-lg-6">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">CLIENT DETAILS</header>
                  <div class="panel-body" style="height:300px;">
                    <div class="padTop16" id="chart7" style="height:250px;"></div>
                  </div>
                </section>
              </div>
              <div class="col-lg-6">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">MATERIAL DETAILS</header>
                  <div class="panel-body"  style="height:300px;">
                    <div id="chart8"  style="height:250px;"></div>
                  </div>
                </section>
              </div>
            </div>
			
            <div class="row">
              <div class="col-lg-12">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">HIGH PRIORITY</small></header>
                  <div class="panel-body" style="height:350px;">
                    <div id="chart1" style="height:280px;"></div>
                    <section class="panel panel-default panelInner">
                      <footer class="panel-footer bg-white">
                        <div class="row text-center no-gutter">
                          <div class="col-xs-4 b-r b-light">
							<p class="text-muted font-bold padTop6">High Priority</p>
                            <p class="h3 font-bold m-t"  style="color:red"  id="highPriority"><i class="fa fa-spinner fa-spin"></i></p>                            
                          </div>
                          <div class="col-xs-2 b-r b-light">
							<p class="text-muted font-bold padTop6" id="c1"></p>
                            <p class="h3 font-bold m-t" style="color:#5d62b5"   id="typeOne"><i class="fa fa-spinner fa-spin"></i></p>                            
                          </div>
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6" id="c2"></p>
                            <p class="h3 font-bold m-t" style="color:#29c3be"   id="typeTwo"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
                          <div class="col-xs-2 b-r b-light">
                            <p class="text-muted font-bold padTop6" id="c3"></p>
                            <p class="h3 font-bold m-t" style="color:#f2726f"   id="typeThree"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>
						 <div class="col-xs-2">
                            <p class="text-muted font-bold padTop6" id="c4"></p>
                            <p class="h3 font-bold m-t" style="color:#FDBF2F"   id="others"><i class="fa fa-spinner fa-spin"></i></p>
                          </div>

                        </div>
                      </footer>
                    </section>
                  </div>
                </section>
              </div>              
            </div>

          </section>
        </section>
        <a href="#" class="hide nav-off-screen-block" data-toggle="class:nav-off-screen" data-target="#nav"></a>
      </section>
      <aside class="bg-light lter b-l aside-md hide" id="notes">
        <div class="wrapper">Notification</div>
      </aside>
    </section>
  </section>
</section>

<!-- App -->
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<script src="../Analytics/js/app.plugin.js"></script>
<script src="../Analytics/js/charts/sparkline/jquery.sparkline.min.js"></script>
<script src="../Analytics/js/charts/easypiechart/jquery.easy-pie-chart.js"></script>
<script src="../Analytics/js/charts/flot/jquery.flot.min.js"></script>
<script src="../Analytics/js/charts/flot/jquery.flot.tooltip.min.js"></script>
<script src="../Analytics/js/charts/flot/jquery.flot.resize.js"></script>
<script src="../Analytics/js/charts/flot/jquery.flot.orderBars.js"></script>
<script src="../Analytics/js/charts/flot/jquery.flot.pie.min.js"></script>
<script src="../Analytics/js/charts/flot/jquery.flot.grow.js"></script>
<script src="../Analytics/js/datepicker/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="../Analytics/js/charts/flot/fusioncharts/fusioncharts.js"></script>
<script type="text/javascript" src="https://rawgit.com/fusioncharts/fusioncharts-jquery-plugin/develop/dist/fusioncharts.jqueryplugin.min.js"></script>
<script type="text/javascript" src="https://cdn.fusioncharts.com/fusioncharts/latest/themes/fusioncharts.theme.fusion.js"></script>
<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.js"></script>

<script src="https://unpkg.com/leaflet@1.0.2/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.2/dist/leaflet.css" />
<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />

<script><!--

loadData();

window.setInterval(function(){
 loadData();
}, 60000);

function loadData(){
	getChart1Data();
	getChart2Data();
	getChart3Data();
	getChart4Data();
	getChart7Data();
	getChart8Data();
}

function getChart1Data()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getPieChartData&chartName=chart1',
             success: function(result) {
             var rs=JSON.parse(result);
             $("#highPriority").html(rs.chartData[0].highPriority);
             $("#c1").html(rs.chartData[1][0] && rs.chartData[1][0].customerName.split(" ")[0] || "No Data");
			 $("#c1").attr("title", rs.chartData[1][0] && rs.chartData[1][0].customerName || "No Data");
             $("#typeOne").html(rs.chartData[1][0] && rs.chartData[1][0].noOfTrips || 0);
             $("#c2").html(rs.chartData[1][1] && rs.chartData[1][1].customerName.split(" ")[0] || "No Data");
			 $("#c2").attr("title", rs.chartData[1][1] && rs.chartData[1][1].customerName || "No Data");
             $("#typeTwo").html(rs.chartData[1][1] && rs.chartData[1][1].noOfTrips || 0);
             $("#c3").html(rs.chartData[1][2] && rs.chartData[1][2].customerName.split(" ")[0] || "No Data");
			 $("#c3").attr("title", rs.chartData[1][2] && rs.chartData[1][2].customerName || "No Data");
             $("#typeThree").html(rs.chartData[1][2] && rs.chartData[1][2].noOfTrips || 0);
			 var others=0;
			  others=rs.chartData[1][0] &&(parseInt(rs.chartData[0].highPriority)-(parseInt(rs.chartData[1][0].noOfTrips)))||0;
			  others=rs.chartData[1][0] && rs.chartData[1][1] && (parseInt(rs.chartData[0].highPriority)-(parseInt(rs.chartData[1][0].noOfTrips)+parseInt(rs.chartData[1][1].noOfTrips)))||0;
			  others=rs.chartData[1][0] && rs.chartData[1][1] && rs.chartData[1][1] && (parseInt(rs.chartData[0].highPriority)-(parseInt(rs.chartData[1][0].noOfTrips)+parseInt(rs.chartData[1][1].noOfTrips)+parseInt(rs.chartData[1][2].noOfTrips)))||0;
			 if(parseInt(others)==0 && parseInt(rs.chartData[0].highPriority)>0)
			 {
				 others=parseInt(rs.chartData[0].highPriority)
			 }
             $("#others").html(others || 0);
			 $("#c4").html('Others');
			 $("#c4").attr("title",'Others');
			 const dataSource = {
							  chart: {
							    caption: "",						    
							    plottooltext: "$label, <b>$value</b> , $percentValue",
							    showlegend: "0",
							    showpercentvalues: "1",
							    legendposition: "bottom",
							    usedataplotcolorforlabels: "1",
							    theme: "fusion",
							    "pieRadius": "100"
							  },
							  data: [
							    {
							      label: rs.chartData[1][0] && rs.chartData[1][0].customerName,
							      value: rs.chartData[1][0] && rs.chartData[1][0].noOfTrips
							    },
							    {
							      label: rs.chartData[1][1] && rs.chartData[1][1].customerName,
							      value: rs.chartData[1][1] && rs.chartData[1][1].noOfTrips
							    },
							    {
							      label: rs.chartData[1][1] && rs.chartData[1][2].customerName,
							      value: rs.chartData[1][1] && rs.chartData[1][2].noOfTrips
							    },
							    {
							      label: 'Others',
							      value: others
							    },
							  ]
							};
							
							FusionCharts.ready(function() {
							  var myChart = new FusionCharts({
							    type: "pie2d",
							    renderAt: "chart1",
							    width: "100%",
							    height: "100%",
							    dataFormat: "json",
							    dataSource
							  }).render();
							});
             }
           });
}


function getChart2Data()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getPieChartData&chartName=chart2',
             success: function(result) {
             var rs=JSON.parse(result);
             $("#online").html(rs.chartData[0].online);
             $("#moving").html(rs.chartData[0].running);
             $("#idle").html((parseInt(rs.chartData[0].online)-(parseInt(rs.chartData[0].running)+parseInt(rs.chartData[0].parked))));
             $("#parked").html(rs.chartData[0].parked);
             const dataSource = {
							  chart: {
							    caption: "",
							    plottooltext: "$label, <b>$value</b> , $percentValue",
							    showlegend: "0",
							    showpercentvalues: "1",
							    legendposition: "bottom",
							    usedataplotcolorforlabels: "1",
							    theme: "fusion",
							    "pieRadius": "80"
							  },
							  data: [
							    {
							      label: "Moving",
							      value: rs.chartData[0].running
							    },
							    {
							      label: "Idle",
							      value: (parseInt(rs.chartData[0].online)-(parseInt(rs.chartData[0].running)+parseInt(rs.chartData[0].parked)))
							    },
							    {
							      label: "Stopped",
							      value: rs.chartData[0].parked
							    },
							    
							  ]
							};
							
							FusionCharts.ready(function() {
							  var myChart = new FusionCharts({
							    type: "pie2d",
							    renderAt: "chart2",
							    width: "100%",
							    height: "100%",
							    dataFormat: "json",
							    dataSource
							  }).render();
							});
             }
           });
	}

function getChart3Data()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getPieChartData&chartName=chart3',
             success: function(result) {
             var rs=JSON.parse(result);
             $("#offline").html(rs.chartData[0].noComm);
             $("#poorgsm").html((parseInt(rs.chartData[0].noComm)-parseInt(rs.chartData[0].disConnected)));
            // $("#poorsa").html(rs.chartData[0].poorSat);
             $("#disconnected").html(rs.chartData[0].disConnected);
             const dataSource = {
							  chart: {
							    caption: "",
							    plottooltext: "$label, <b>$value</b> , $percentValue",
							    showlegend: "0",
							    showpercentvalues: "1",
							    legendposition: "bottom",
							    usedataplotcolorforlabels: "1",
							    theme: "fusion",
							    "pieRadius": "80"
							  },
							  data: [

							    {
							      label: "Poor GSM",
							      value: (parseInt(rs.chartData[0].noComm)-parseInt(rs.chartData[0].disConnected))
							    },
							    {
							      label: "Disconnected",
							      value: rs.chartData[0].disConnected
							    },
							    
							  ]
							};
							
					FusionCharts.ready(function() {
					  var myChart = new FusionCharts({
					    type: "pie2d",
					    renderAt: "chart3",
					    width: "100%",
					    height: "100%",
					    dataFormat: "json",
					    dataSource
					  }).render();
					});
             }
           });
}

function getChart4Data()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getPieChartData&chartName=chart4',
             success: function(result) {
             var rs=JSON.parse(result);
             $("#location").html(rs.chartData[0].totalTrip);
             $("#loading").html(rs.chartData[0].loading);
             $("#unloading").html(rs.chartData[0].unLoading);
             $("#enroute").html((parseInt(rs.chartData[0].totalTrip)-(parseInt(rs.chartData[0].loading)+parseInt(rs.chartData[0].unLoading)+parseInt(rs.chartData[0].serviceCenter))));
             $("#serviceCenter").html(rs.chartData[0].serviceCenter);
             const dataSource = {
							  chart: {
							    caption: "",
							    plottooltext: "$label, <b>$value</b> , $percentValue",
							    showlegend: "0",
							    showpercentvalues: "1",
							    legendposition: "bottom",
							    usedataplotcolorforlabels: "1",
							    theme: "fusion",
							    "pieRadius": "80"
							  },
							  data: [
							    {
							      label: "Loading",
							      value: rs.chartData[0].loading
							    },
							    {
							      label: "Unloading",
							      value: rs.chartData[0].unLoading
							    },
							    {
							      label: "Enroute",
							      value: (parseInt(rs.chartData[0].totalTrip)-(parseInt(rs.chartData[0].loading)+parseInt(rs.chartData[0].unLoading)+parseInt(rs.chartData[0].serviceCenter)))
							    },
							    {
							      label: "Service Center",
							      value: rs.chartData[0].serviceCenter
							    },
							    
							  ]
							};
							
							FusionCharts.ready(function() {
							  var myChart = new FusionCharts({
							    type: "pie2d",
							    renderAt: "chart4",
							    width: "100%",
							    height: "100%",
							    dataFormat: "json",
							    dataSource
							  }).render();
							});
             }
           });
	}

function getChart7Data()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getPieChartData&chartName=chart7',
             success: function(result) {
             var rs=JSON.parse(result);
			 var data1=[];
			 for(var i=0;i<rs.chartData[0].length;i++)
			 {
				 var obj1={
					 label:rs.chartData[0][i].customerName,
					 value:rs.chartData[0][i].noOfTrips
				 }
				 data1.push(obj1);
			 }
             const dataSource = {
							  chart: {
							    caption: "",
								showLabels: 0,
							    plottooltext: "$label, <b>$value</b> , $percentValue",
							    showlegend: "0",
							    showpercentvalues: "1",
							    legendposition: "bottom",
							    usedataplotcolorforlabels: "1",
							    theme: "fusion",
							    "pieRadius": "100"
							  },
							  data:data1
							};
							
							FusionCharts.ready(function() {
							  var myChart = new FusionCharts({
							    type: "pie2d",
							    renderAt: "chart7",
							    width: "100%",
							    height: "100%",
							    dataFormat: "json",
							    dataSource
							  }).render();
							});
             }
           });
}

function getChart8Data()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getPieChartData&chartName=chart8',
             success: function(result) {
             var rs=JSON.parse(result);
             const dataSource = {
							  chart: {
							    caption: "",
							    plottooltext: "$label, <b>$value</b> , $percentValue",
							    showlegend: "1",
							    showpercentvalues: "1",
							    legendposition: "bottom",
							    usedataplotcolorforlabels: "1",
							    theme: "fusion",
							    "pieRadius": "100"
							  },
							  data: [
							    {
							      label: 'Blade',
							      value: rs.chartData[0].blade
							    },
							    {
							      label: 'Hub',
							      value: rs.chartData[0].hub
							    },
							    {
							      label: 'Nacelle',
							      value: rs.chartData[0].nacelle
							    },
							    {
							      label: 'Tower',
							      value: rs.chartData[0].tower
							    },
								{
							      label: 'Others',
							      value: rs.chartData[0].others
							    },
							  ]
							};
							
							FusionCharts.ready(function() {
							  var myChart = new FusionCharts({
							    type: "pie2d",
							    renderAt: "chart8",
							    width: "100%",
							    height: "100%",
							    dataFormat: "json",
							    dataSource
							  }).render();
							});
             }
           });
}
/*const dataSource = {
  chart: {
    caption: "",
    showValues: 0,
    showLabels:0,
    plottooltext: "<b>$value</b> of web servers run on $label servers",
    showlegend: "1",
    showpercentvalues: "1",
    legendposition: "bottom",
    usedataplotcolorforlabels: "1",
    theme: "fusion",
    "pieRadius": "60"
  },
  data: [
    {
      label: "Apache",
      value: "32647479"
    },
    {
      label: "Microsoft",
      value: "22100932"
    },
    {
      label: "Zeus",
      value: "14376"
    },
    {
      label: "Other",
      value: "18674221"
    }
  ]
};*/
/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart1",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});
*/

/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart2",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});*/
/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart3",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
}); */

/*FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart4",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});
*/
/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart5",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});
*/
/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart6",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});
*/
/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart7",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});
*/
/*
FusionCharts.ready(function() {
  var myChart = new FusionCharts({
    type: "pie2d",
    renderAt: "chart8",
    width: "100%",
    height: "100%",
    dataFormat: "json",
    dataSource
  }).render();
});*/



--></script>


<jsp:include page="../Common/footer.jsp" />
