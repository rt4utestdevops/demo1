<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Properties properties = ApplicationListener.prop;
  /* String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();*/
%>

<jsp:include page="../Common/header.jsp" />
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
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css" type="text/css"/>
<div class="center-view" style="display:none;" id="loading-div">
    <img src="../../Main/images/loading.gif" alt="">
  </div>
<section class="vbox" style="margin-top:-24px;">

    <section class="hbox stretch">

      <section id="content">
        <section class="vbox" >
          <section class="scrollable padder" id="contentChild">
            <div class="m-b-md" style="display:none;">
              <div class="row">
                <div class="col-sm-6">
                  <div style="display:flex">
                    <div>
                    <h3 class="m-b-none m-t-smHead" id="h3Header"></h3>
                    <small id="lastsixmonths">Priority</small>
                  </div>
                </div>
                </div>
                <div class="col-sm-6">
                  <div class="text-right text-left-xs">
                    <div class="sparkline m-l m-r-lg pull-right" data-type="bar" data-height="35" data-bar-width="6" data-bar-spacing="2" data-bar-color="#fb6b5b">5,8,9,12,8,10,8,9,7,8,6</div>
                    <div class="m-t-sm">

                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row" style="margin-bottom:24px;margin-top:16px;">
              <div class="col-lg-12">
                <table id="ntcDatatable" class="display" style="width:100%">
                  <thead>
                      <tr>
                          <th>Priority</th>
                          <th>id</th>
                          <th>Vehicle No.</th>
                          <th>Driver Name</th>
                          <th>Customer Name</th>
                          <th>Material</th>
                      </tr>
                  </thead>

              </table>
            </div>
          </div>

          </section>

        </section>
      </section>
    
    </section>
  </section>
</section>

<!-- App -->
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
  <script
    src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <script
      src="https://cdn.datatables.net/select/1.3.0/js/dataTables.select.min.js"></script>
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


<script>
let count = 0;
let table;
$(document).ready(function() {
     $.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getOpenTrips',
             "dataSrc": "openTripsDetailRoot",
             success: function(result) {
                tableJSON =  JSON.parse(result);;
                tableJSON = tableJSON["openTripsDetailRoot"]
			    let vehicles = [];
			    tableJSON.forEach(function(item){
				    let vehicle = [];
		            let checked = (item.isPriority == 'Y') ? "checked" : "";
		            vehicle.push("<input type='checkbox' "+checked+" data-id='"+item.id+"' id='"+count+"checkbox'/>");
		            vehicle.push(item.id);
		            vehicle.push(item.vehicleNo);
		            vehicle.push(item.driverName);
		            vehicle.push(item.customerName);
		            vehicle.push(item.material);
		            vehicles.push({...vehicle});
		            count++;
   				 })
		    if($.fn.DataTable.isDataTable("#ntcDatatable")) {$('#ntcDatatable').DataTable().clear().destroy();}
			    table = $('#ntcDatatable').DataTable( {
			      "paging":   false,
			      data: vehicles
			    } );
			    setTimeout(function(){$("#ntcDatatable_filter").append('<button type="button" onclick="savePriority()" class="btn btn-primary" style="margin-left:24px;height:28px;padding-top:2px;width:80px">Save</button>')},200)
			    
		    }
   })
 } );


// Handle form submission event. Fixed
function savePriority(){
     let priorityList = [];
     //let nonpriorityList = [];
	 $('#ntcDatatable').DataTable().search('').draw(false);
     for (let i = 0; i < count; i++){
       $("#"+i+"checkbox").is(':checked') ? priorityList.push($("#"+i+"checkbox").data("id")) :"";
     }
	    $.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=saveHighPrioritySetting',
	        data: {
	        	priorityList : JSON.stringify(priorityList)
	        	//nonpriorityList : nonpriorityList
	        },
	        success: function(result) {
	        	sweetAlert("Priority Changed Successfully");
	          //  vehicleList = JSON.parse(result);
				//$('#driverDropDownId').append($("<option></option>").attr("value", 0).text("--Pick Driver--"));
	           // for (var i = 0; i < vehicleList["vehiclesRoot"].length; i++) {
	           //        $('#driverDropDownId').append($("<option></option>").attr("value", vehicleList["vehiclesRoot"][i].vehicleNo).attr("tripId", vehicleList["vehiclesRoot"][i].tripId).text(vehicleList["vehiclesRoot"][i].driverName));
	           // }
	           // $('#driverDropDownId').select2();
	        }
	    });
    // console.log("Priority List", priorityList)
 };


</script>
<jsp:include page="../Common/footer.jsp" />
