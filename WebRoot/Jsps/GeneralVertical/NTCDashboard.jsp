<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<jsp:include page="../Common/header.jsp" />
<style>
.leaflet-right{
  display:none;
}
thead{
  background: #607D8B;
  color: #ffffff;
  font-size: 14px;
}
table{
  font-size:14px;
}
.boxStyle{margin-left:16px;padding:8px 100px;text-align:center;margin-bottom: 16px;}
.card-title{font-weight: 500;font-size:15px;}
.card-body{
	cursor:pointer;
	padding: 1rem 0rem 2rem 0rem !important;
}
#loaded1lbl,#loaded2lbl,#loaded3lbl,#loaded4lbl,#loaded5lbl { font-weight:bold;}
#empty1lbl,#empty2lbl,#empty3lbl,#empty4lbl,#empty5lbl { font-weight:bold;}
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
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" type="text/css"/>
<div class="center-view" style="display:none;" id="loading-div">
  <img src="../../Main/images/loading.gif" alt="">
</div>

<section class="vbox" style="margin-top:-24px;">

  <section class="hbox stretch">

    <section id="content">
      <section class="vbox" >
        <section class="scrollable padder" id="contentChild">
          <div class="m-b-md" style="margin-top:-8px !important;">
            <div class="row">
              <div class="col-sm-6">
                <div style="display:flex">
                  <div>
                  <h3 class="m-b-none m-t-smHead" id="h3Header" style="display:none;">NTC Dashboard</h3>
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
          <div style="display:flex; flex: 0 0 100%;justify-content:space-between">
            <div class="card text-white bg-success mb-3 boxStyle" style="margin-left:0px !important;background:#1212A0 !important;">
            <div class="card-body"  onclick="loadMap('ALLVEHICLEINFO')">
              <h5 class="card-title font-bold">Total</h5>
              <p class="h4 card-text font-bold" id="total"><i class="fa fa-spinner fa-spin"></i></p>
            </div>
          </div>

          <div class="card text-white bg-danger mb-3 boxStyle" style="background:#09B356 !important;">
            <div class="card-body" onclick="loadMap('ONLINEVEHICLEINFO')">
              <h5 class="card-title font-bold">Online</h5>
              <p class="h4 card-text font-bold" id="online"><i class="fa fa-spinner fa-spin"></i></p>
            </div>
          </div>
          <div class="card text-white bg-warning mb-3 boxStyle" style="background:#FFEA00 !important;">
            <div class="card-body" onclick="loadMap('OFFLINEVEHICLEINFO')">
              <h5 class="card-title font-bold">Offline</h5>
              <p class="h4 card-text font-bold" id="offline"><i class="fa fa-spinner fa-spin"></i></p>
            </div>
          </div>
          <div class="card text-white bg-info mb-3 boxStyle" style="background:#FF43A1 !important;">
            <div class="card-body" onclick="loadMap('LOADEDVEHICLEINFO')">
              <h5 class="card-title font-bold">Loaded</h5>
              <p class="h4 card-text font-bold" id="loaded"><i class="fa fa-spinner fa-spin"></i></p>
            </div>
          </div>
          <div class="card text-white bg-dark mb-3 boxStyle" style="background:#878787 !important;">
            <div class="card-body" onclick="loadMap('EMPTYVEHICLEINFO')">
              <h5 class="card-title font-bold" >Empty</h5>
              <p class="h4 card-text font-bold" id="empty"><i class="fa fa-spinner fa-spin"></i></p>
            </div>
          </div>
        </div>
        <!--- Remove This -->
          <!--<section class="panel panel-default">
            <footer class="panel-footer bg-white">
              <div class="row text-center no-gutter">
                <div class="col-xs-2 b-r b-light" onclick="loadMap('total')" style="cursor:pointer;">
                  <p class="h3 font-bold m-t" id="total"><i class="fa fa-spinner fa-spin"></i></p>
                  <p class="text-muted">Total</p>
                </div>
                <div class="col-xs-2 b-r b-light" onclick="loadMap('online')" style="cursor:pointer;">
                  <p class="h3 font-bold m-t"  id="online"><i class="fa fa-spinner fa-spin"></i></p>
                  <p class="text-muted">Online</p>
                </div>
                <div class="col-xs-2 b-r b-light" onclick="loadMap('offline')" style="cursor:pointer;">
                  <p class="h3 font-bold m-t"  id="offline"><i class="fa fa-spinner fa-spin"></i></p>
                  <p class="text-muted">Offline</p>
                </div>
                <div class="col-xs-3 b-r b-light" onclick="loadMap('loaded')" style="cursor:pointer;">
                  <p class="h3 font-bold m-t"  id="loaded"><i class="fa fa-spinner fa-spin"></i></p>
                  <p class="text-muted">Loaded</p>
                </div>
                <div class="col-xs-3" onclick="loadMap('empty')" style="cursor:pointer;">
                  <p class="h3 font-bold m-t"  id="empty"><i class="fa fa-spinner fa-spin"></i></p>
                  <p class="text-muted">Empty</p>
                </div>
              </div>
            </footer>

          </section>-->

          <!--Remove This -->
          <div class="row">
            <div class="col-lg-6">
              <section class="panel panel-default">
                <header class="panel-heading font-bold">High Priority Vehicles</header>
                <div class="panel-body" style="height:300px;padding:0px;">
                  <div id="map1"  style="height:300px"></div>
                </div>
              </section>
            </div>
            <div class="col-lg-6">
              <section class="panel panel-default">
                <header class="panel-heading font-bold">Total Vehicles</header>
                <div class="panel-body" style="height:300px;padding:0px;">
                  <div id="map2"  style="height:300px"></div>
                </div>
              </section>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-6">
              <section class="panel panel-default">
                <header class="panel-heading font-bold">Loaded Vehicles <small>(Overspeed Limit 40)</small></header>
                <div class="panel-body" style="min-height:230px;">
				<div id="chart-container-loaded" style="width:100%;text-align:center;display:flex;margin-left:24px;">
                    <div id="loaded1lbl" style="margin-left:50px"></div>
                    <div id="loaded2lbl" style="margin-left:92px"></div>
                    <div id="loaded3lbl" style="margin-left:110px"></div>
                  </div>
                  <div id="chart-container-loaded" style="width:100%;text-align:center;display:flex;margin-left:24px;">
                    <div id="loaded1"></div>
                    <div id="loaded2"></div>
                    <div id="loaded3"></div>
                  </div>
				  <div id="chart-container-loaded" style="width:100%;text-align:center;display:flex;margin-left:100px;">                    
                    <div id="loaded4lbl" style="margin-left:50px"></div>
                    <div id="loaded5lbl" style="margin-left:100px"></div>
                  </div>
				  <div id="chart-container-loaded" style="width:100%;text-align:center;display:flex;margin-left:100px;">                    
                    <div id="loaded4"></div>
                    <div id="loaded5"></div>
                  </div>
                  <table id="tblLoadedOverspeed" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>Vehicle No.</th>
                            <th>Driver Name</th>
                            <th>Priority</th>
                            <th>Speed</th>
                        </tr>
                    </thead>
                </table>
                </div>
              </section>
            </div>
            <div class="col-lg-6">
              <section class="panel panel-default">
                <header class="panel-heading font-bold">Empty Vehicles <small>(Overspeed Limit 60)</small></header>
                <div class="panel-body" style="min-height:230px;">
				<div id="chart-container-empty"  style="width:100%;text-align:center;display:flex;margin-left:24px;">
                    <div id="empty1lbl" style="margin-left:50px"></div>
                    <div id="empty2lbl" style="margin-left:110px"></div>
                    <div id="empty3lbl" style="margin-left:110px"></div>
                  </div>
                  <div id="chart-container-empty"  style="width:100%;text-align:center;display:flex;margin-left:24px;">
                    <div id="empty1"></div>
                    <div id="empty2"></div>
                    <div id="empty3"></div>
                  </div>
				  <div id="chart-container-empty"  style="width:100%;text-align:center;display:flex;margin-left:100px;">                   
                    <div id="empty4lbl" style="margin-left:50px"></div>
                    <div id="empty5lbl" style="margin-left:110px"></div>
                  </div>
				  <div id="chart-container-empty"  style="width:100%;text-align:center;display:flex;margin-left:100px;">                   
                    <div id="empty4"></div>
                    <div id="empty5"></div>
                  </div>
                  <table id="tblEmptyOverspeed" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>Vehicle No.</th>
                            <th>Driver Name</th>
                            <th>Priority</th>
                            <th>Speed</th>
                        </tr>
                    </thead>

                </table>
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
<script
src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

<script><!--

let map1, map2;
let markerTotal = [];
let markerPriority = [];
let totalCount = {
"total" : 20,
"communicating" : 10,
"noncommunicating" : 5,
"loaded": 10,
"empty": 5
};

$(document).ready(function() {
     $.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getDashboardCountsForNTC',
             success: function(result) {
                totalCount = JSON.parse(result)["vehicleCounts"][0];
				$("#total").html(totalCount.total);
				$("#online").html(totalCount.communicating);
				$("#offline").html(totalCount.noncommunicating);
				$("#loaded").html(totalCount.loaded);
				$("#empty").html(totalCount.empty);
		    }
   })
 } );
 //Done. refresh every minute right? For testing
  initialize();
 loadData();
window.setInterval(function(){
 loadData();
}, 60000);
 function loadData(){
	loadMap("HIGHPRIORITY");
	loadMap("ALLVEHICLEINFO");
	getLoadedVehicleDataBySpeedMoreThen30();
 }




function loadMap(status){
    if(status == "HIGHPRIORITY"){
     let totalVehicles = [];
            $.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getMapViewDataForNTCByStatus&status=HIGHPRIORITY',
             success: function(result) {
             var rs=JSON.parse(result);
             let vehicleDetails=rs.vehicleDetailsRoot;
             for(var i=0;i<vehicleDetails.length;i++)
             {
             	var obj=
             	{
             	"lat": vehicleDetails[i].latitude,
			     "lng": vehicleDetails[i].longitude,
			     "vehicleNo": vehicleDetails[i].registrationNo,
			     "driverName": vehicleDetails[i].driverName,
				 "location": vehicleDetails[i].location,
			     "isPriority": true,
			     "loaded": true,
			     "speed": vehicleDetails[i].speed
             	}
             	totalVehicles.push(obj);
             }
       //         totalCount = JSON.parse(result)["vehicleCounts"][0];
		//		$("#total").html(totalCount.total);
	//			$("#online").html(totalCount.communicating);
		//		$("#offline").html(totalCount.noncommunicating);
		//		$("#loaded").html(totalCount.loaded);
		//		$("#empty").html(totalCount.empty);
		    
   
 /*     let totalVehicles = [
      {
      "lat": '21.146633',
      "lng": '79.088860',
      "vehicleNo": "skdfsdjfll",
      "driverName": "iweuq oqeoqw",
      "isPriority": true,
      "loaded": true,
      "speed": 25
      },
      {
      "lat": '21.146633',
      "lng": '79.088860',
      "vehicleNo": "skdfsdjfljkl",
      "driverName": "iweuq oqeoqw",
      "isPriority": false,
      "loaded": false,
      "speed": 80
      },
      {
      "lat": '21.146633',
      "lng": '79.088860',
      "vehicleNo": "sioeuoieoiq",
      "driverName": "iweuq oqeoqw",
      "isPriority": false,
      "loaded": true,
      "speed": 70
      }
      ]
*/

	  for(var i = 0; i < markerPriority.length; i++){
			map2.removeLayer(markerPriority[i]);
		}
      markerPriority = [];
      totalVehicles.forEach(function(item){
		  if(!(item.lat==undefined && item.lng==undefined))
		  {
                       let image = L.icon({
                           iconUrl: "../../Main/images/truckTop_Red.png",
                           iconSize: [10, 20], // size of the icon
                           popupAnchor: [0, -15]
                       });
                       var marker = new L.Marker(new L.LatLng(item.lat, item.lng), {
                           icon: image
                       }).addTo(map1);
                       markerPriority.push(marker);
                       let content="<div style='display:flex;flex-direction:column'><div>Vehicle No. :"+item.vehicleNo+"</div><div>Driver Name :"+item.driverName+"</div><div>Location :"+item.location+"</div><div>Speed :"+item.speed+"</div></div>"

                       marker.bindPopup(content);
		  }
      })

     
      }
     })
   }
   else {
     let topbarClickVehicles = [];
            $.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getMapViewDataForNTCByStatus&status='+status,
             success: function(result) {
            // console.log(result);
             var rs=JSON.parse(result)
             let vehicleDetails=rs.vehicleDetailsRoot;
             for(var i=0;i<vehicleDetails.length;i++)
             {
             	var obj=
             	{
             	"lat": vehicleDetails[i].latitude,
			     "lng": vehicleDetails[i].longitude,
			     "vehicleNo": vehicleDetails[i].registrationNo,
			     "driverName": vehicleDetails[i].driverName,
				  "location": vehicleDetails[i].location,
			     "isPriority": true,
			     "loaded": true,
			     "speed": vehicleDetails[i].speed
             	}
             	if(obj.lat!=undefined && obj.lng!=undefined)
             	topbarClickVehicles.push(obj);
             }
       //         totalCount = JSON.parse(result)["vehicleCounts"][0];
		//		$("#total").html(totalCount.total);
	//			$("#online").html(totalCount.communicating);
		//		$("#offline").html(totalCount.noncommunicating);
		//		$("#loaded").html(totalCount.loaded);
		//		$("#empty").html(totalCount.empty);
		    
  
   
  /*   let topbarClickVehicles = [
     {
     "lat": '21.146633',
     "lng": '79.088860',
     "vehicleNo": "skdfsdjfll",
     "driverName": "iweuq oqeoqw",
     "isPriority": true,
     "loaded": true,
     "speed": 25
     },
     {
     "lat": '21.146633',
     "lng": '85.088860',
     "vehicleNo": "skdfsdjfljkl",
     "driverName": "iweuq oqeoqw",
     "isPriority": false,
     "loaded": false,
     "speed": 80
     },
     {
     "lat": '21.146633',
     "lng": '79.088860',
     "vehicleNo": "sioeuoieoiq",
     "driverName": "iweuq oqeoqw",
     "isPriority": false,
     "loaded": true,
     "speed": 70
     }
     ]
     */
	 	for(var i = 0; i < markerTotal.length; i++){
			map2.removeLayer(markerTotal[i]);
		}
		if(markerTotal.length > 0){
		markerTotal = [];}
     topbarClickVehicles.forEach(function(item){
                      let image = L.icon({
                          iconUrl: "../../Main/images/truckTop_Blue.png",
                          iconSize: [10, 20], // size of the icon
                          popupAnchor: [0, -15]
                      });
                      var marker = new L.Marker(new L.LatLng(item.lat, item.lng), {
                          icon: image
                      }).addTo(map2);
                      markerTotal.push(marker);
                      let content="<div style='display:flex;flex-direction:column'><div>Vehicle No. :"+item.vehicleNo+"</div><div>Driver Name :"+item.driverName+"</div><div>Location :"+item.location+"</div><div>Speed :"+item.speed+"</div></div>"
                      marker.bindPopup(content);
     })
			}
			 })
   }
}

function getLoadedVehicleDataBySpeedMoreThen30()
{
	$.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getMapViewDataForNTCByStatus&status=getDataForTable',
             success: function(result) {
             var rs=JSON.parse(result)
             let vehicleDetails=rs.vehicleDetailsRoot;
			  let totalVehicles = [];
             for(var i=0;i<vehicleDetails.length;i++)
             {
             	var obj=
             	{
			     "vehicleNo": vehicleDetails[i].registrationNo,
			     "driverName": vehicleDetails[i].driverName,
			     "isPriority": vehicleDetails[i].highPriority==true?'Y':'N',
			     "loaded": vehicleDetails[i].loaded,
			     "speed": vehicleDetails[i].speed
             	}
             	totalVehicles.push(obj);
             }


      let priorityVehicles = [];
      let loadedOverSpeed = [];
      let emptyOverSpeed = [];

      totalVehicles.forEach(function(item){
          item.isPriority ? priorityVehicles.push(item) :"";
          let itemForSpeed = [];
            itemForSpeed.push(item.vehicleNo);
            itemForSpeed.push(item.driverName);
            itemForSpeed.push(item.isPriority);
            itemForSpeed.push(item.speed);

          item.loaded  && item.speed > 40 ? loadedOverSpeed.push({...itemForSpeed}) : "";
          (!item.loaded) && item.speed > 60 ? emptyOverSpeed.push({...itemForSpeed}) : "";
      })
	
//.sort((a, b) => parseFloat(a.speed) - parseFloat(b.speed));
//		loadedOverSpeed.sort((a, b) => (a.speed < b.speed) ? 1 : -1)
      if($.fn.DataTable.isDataTable("#tblLoadedOverspeed")) {$('#tblLoadedOverspeed').DataTable().clear().destroy();}
      $('#tblLoadedOverspeed').DataTable( {
        "paging":   false,
         data: loadedOverSpeed
      });

//emptyOverSpeed.sort((a, b) => (a.speed < b.speed) ? 1 : -1)
      if($.fn.DataTable.isDataTable("#tblEmptyOverspeed")) {$('#tblEmptyOverspeed').DataTable().clear().destroy();}
      $('#tblEmptyOverspeed').DataTable( {
        "paging":   false,
         data: emptyOverSpeed
      });

      let chartcount = 1;

      loadedOverSpeed.forEach(function(item){

        
          let vehicleNumber = item[0];
          let chartData = [
            {
              value: item[3],
              bgcolor: "#F20F2F",
              basewidth: "8"
            }
          ];

          let dataSource = {
            chart: {
              captionpadding: "0",
              origw: "120",
              origh: "100",
              gaugeouterradius: "35",
              gaugestartangle: "270",
              gaugeendangle: "-25",
              showvalue: "1",
              valuefontsize: "12",
              majortmnumber: "13",
              majortmthickness: "2",
              majortmheight: "13",
              minortmheight: "7",
              minortmthickness: "1",
              minortmnumber: "1",
              showgaugeborder: "0",
              theme: "fusion"
            },
            colorrange: {
              color: [
                {
                  minvalue: "0",
                  maxvalue: "40",
                  code: "#28a745"
                },
                {
                  minvalue: "40",
                  maxvalue: "140",
                  code: "#FA3E3E"
                }
              ]
            },
            dials: {
              dial: chartData
            },
            annotations: {
              groups: [
                {
                  items: [
                    {
                      type: "text",
                      id: "text",
                      text: "kmph",
                      x: "$gaugeCenterX",
                      y: "$gaugeCenterY + 20",
                      fontsize: "10",
                      color: "#555555"
                    }
                  ]
                }
              ]
            }
          };
          FusionCharts.ready(function() {if(chartcount <= 5){
			  $("#loaded" + chartcount + "lbl").html(vehicleNumber)
            var myChart = new FusionCharts({
              type: "angulargauge",
              renderAt: "loaded"+chartcount,
              width: "180",
              height: "180",
              dataFormat: "json",
              dataSource
            }).render();
		  chartcount++;}
          });

          
        
      })

      chartcountEmpty = 1;

      emptyOverSpeed.forEach(function(item){

        
		let vehicleNumberEmpty = item[0];
        let chartData = [
            {
              value: item[3],
              bgcolor: "#F20F2F",
              basewidth: "8"
            }
          ];

          const dataSource = {
            chart: {
              captionpadding: "0",
              origw: "120",
              origh: "100",
              gaugeouterradius: "35",
              gaugestartangle: "270",
              gaugeendangle: "-25",
              showvalue: "1",
              valuefontsize: "12",
              majortmnumber: "13",
              majortmthickness: "2",
              majortmheight: "13",
              minortmheight: "7",
              minortmthickness: "1",
              minortmnumber: "1",
              showgaugeborder: "0",
              theme: "fusion"
            },
            colorrange: {
              color: [
                {
                  minvalue: "0",
                  maxvalue: "60",
                  code: "#28a745"
                },
                {
                  minvalue: "60",
                  maxvalue: "140",
                  code: "#FA3E3E"
                }
              ]
            },
            dials: {
              dial: chartData
            },
            annotations: {
              groups: [
                {
                  items: [
                    {
                      type: "text",
                      id: "text",
                      text: "kmph",
                      x: "$gaugeCenterX",
                      y: "$gaugeCenterY + 20",
                      fontsize: "10",
                      color: "#555555"
                    }
                  ]
                }
              ]
            }
          };

          FusionCharts.ready(function() {if(chartcountEmpty <= 5){
			    $("#empty" + chartcountEmpty + "lbl").html(vehicleNumberEmpty)
            var myChart = new FusionCharts({
              type: "angulargauge",
              renderAt: "empty" +chartcountEmpty,
              width: "180",
              height: "180",
              dataFormat: "json",
              dataSource
            }).render();
		  chartcountEmpty++;}
          });

          
        
      })
      }
     })

}

function initialize() {

     var osm1 = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
         maxZoom: 19,
         attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
     });

     var osm2 = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
         maxZoom: 19,
         attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
     });

     map1 = new L.Map("map1", {
         fullscreenControl: {
             pseudoFullscreen: false
         },
         center: new L.LatLng('21.146633', '79.088860'),
         zoom: 4
     });

     L.control.layers({
         "OSM": osm1
     }, null, {
         collapsed: false
     }).addTo(map1);
     osm1.addTo(map1);

     map2 = new L.Map("map2", {
         fullscreenControl: {
             pseudoFullscreen: false
         },
         center: new L.LatLng('21.146633', '79.088860'),
         zoom: 4
     });

     L.control.layers({
         "OSM": osm2
     }, null, {
         collapsed: false
     }).addTo(map2);
     osm2.addTo(map2);
 }


--></script>



<jsp:include page="../Common/footer.jsp" />
