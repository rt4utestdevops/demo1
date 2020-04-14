<%@ page language="java" 
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" 
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf = new CommonFunctions();
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
int customerId=0;
if(loginInfo != null){}
else{response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");}
 
 String table  = request.getParameter("table");
 String shids  = request.getParameter("shids");


%>

 	  <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
      <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
      <!--      <script src="https://code.jquery.com/jquery-1.12.4.js"></script>-->
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
      <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
      <script src="../../Main/DatatableEditor/jquery.tabledit.js"></script>
 
      <div class="custom">
         <div class="panel panel-primary" id="headerId">
            <div class="panel-heading">
               <h3 class="panel-title">
                 
               </h3>
            </div>
            <div class="panel-body">
               <div class="row" style="width:100%; display: none;" id="firstTableId">
            <div class="col-lg-12 card" style="padding:4px 0px;     margin-left: 13px;">
                <table id="table1" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip No</th>
                            <th>Vehicle No</th>
                            <th>ETA (HH:MM)</th>
                            <th>STA wrt ATD</th>
                            <th>Delay</th>
                            <th>Net Delay</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
		
		        <div class="row" style="width:100%; display: none;" id="secondTableId">
            <div class="col-lg-12 card" style="padding:4px 0px;     margin-left: 13px;">
                <table id="table2" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip ID</th>
                            <th>Trip No</th>
                            <th>ATP</th>
                            <th>Placement Delay</th>
                            <th>ATD</th>
                            <th>Next Touch Point</th>
                            <th>ETA to Destination</th>
                            <th>STA wrt ATD</th>
                            <th>ATA@Destination</th>
                        </tr>
                    </thead>
                </table>

            </div>
        </div>
		
		
		        <div class="row" style="width:100%; display: none;" id="thirdTableId">
            <div class="col-lg-12 card" style="padding:4px 0px;     margin-left: 13px;">
                <table id="table3" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip ID</th>
                            <th>Trip No</th>
                            <th>ETA (HH:MM)</th>
                            <th>STA</th>
                            <th>Delay</th>
                            <th>Net Delay</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
		<div class="row" style="width:100%; display: none;" id="fourthTableId">
            <div class="col-lg-12 card" style="padding:4px 0px;     margin-left: 13px;">
                <table id="table4" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Trip Status</th>
                            <th>Trip No</th>
                            <th>Vehicle No</th>
                            <th>ATA@SH</th>
                            <th>ATD@SH</th>
                            <th>Excess Detention</th>
                        </tr>
                    </thead>
                </table>

            </div>
        </div>
               <!-- end of table -->
            </div>
            <!-- end of panel body -->
         </div>
         <!-- end of panel  -->
      </div>
      
 <script type="text/javascript">

var table1;var table2;var table3;var table4;
var combo = '<%=shids%>';
console.log(combo);
	if('<%=table%>' == '1'){
		$("#headerId .panel-heading h3").text("Inbound Smart Hub - Leg Level");
		loadInboundSmartHubDetails(combo);
		$('#firstTableId').show();
	} 
	if('<%=table%>' == '2'){
		$("#headerId .panel-heading h3").text("Outbound Origin - Customer Hub - Trip Level");
		loadOutboundOriginTrips(combo);
		$('#secondTableId').show();
	} 
	
	if('<%=table%>' == '3'){
		$("#headerId .panel-heading h3").text("Inbound Destination - Customer Hub - Trip Level");
		loadInboundDestinationTrips(combo);
		$('#thirdTableId').show();
	} 
	if('<%=table%>' == '4'){
		$("#headerId .panel-heading h3").text("Outbound Intransit Smart Hub - Leg Level");
		loadOutboundSmartHubTrips(combo);
		$('#fourthTableId').show();
	} 

		
	function loadInboundSmartHubDetails(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getInBoundSHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "inBoundSHDetails",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils", result.length);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripNo,
                        "3": item.vehicleNo,
                        "4": item.ETA,
                        "5": item.STA_WRT_STD,
                        "6": item.delay,
                        "7": item.netDelay
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table1")) {
                    $('#table1').DataTable().clear().destroy();
                }
                table1 = $('#table1').DataTable({
                 	"dom": 'Bfrtip',
                    "scrollY": true,
                    "scrollX": true,
                    "bLengthChange":false,
                    searching: true,
                    paging: true,
                    autoWidth: true, 
                    "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Inbound SH Details',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	], 
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                console.log("rows :: " + rows);
                table1.rows.add(rows).draw();
                //table1.column( 7 ).visible( false );
            }
        })
    }

    function loadOutboundOriginTrips(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getOutBoundOriginCHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "OutBoundOriginCHTrips",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils2", result);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripId,
                        "3": item.tripNo,
                        "4": item.ATP,
                        "5": item.placementDelay,
                        "6": item.ATD,
                        "7": item.nextTouchPoint,
                        "8": item.ETA,
                        "9": item.STD_WRT_ATD,
                        "10": item.ATA
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table2")) {
                    $('#table2').DataTable().clear().destroy();
                }
                table2 = $('#table2').DataTable({
                	 "dom": 'Bfrtip',
                    "scrollY": true,
                    "scrollX": true,
                    searching: true,
                    paging: true,
                    "bLengthChange":false,
                    autoWidth: true, 
                    "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Outbound origin Hub Details',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],  
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                table2.rows.add(rows).draw();
            }
        })
    }

    function loadInboundDestinationTrips(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getInBoundDestinationCHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "InBoundDestinationCHTrips",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils3", result);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripId,
                        "3": item.tripNo,
                        "4": item.ETA,
                        "5": item.STA,
                        "6": item.delay,
                        "7": item.netDelay
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table3")) {
                    $('#table3').DataTable().clear().destroy();
                }
                table3 = $('#table3').DataTable({
                 	"dom": 'Bfrtip',
                    "scrollY": true,
                    "scrollX": true,
                    searching: true,
                    paging: true,
                    autoWidth: true,  
                    "bLengthChange":false,
                    "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Inbound Destination Hub Details',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	], 
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                table3.rows.add(rows).draw();
                //table3.column( 7 ).visible( false );
            }
        })
    }

    function loadOutboundSmartHubTrips(combo) {
        $.ajax({
            type: "GET",
            url: "<%=request.getContextPath()%>/SmartHubDashboardAction.do?param=getOutBoundSHTrips",
            data: {
                hubIds: combo
            },
            "dataSrc": "OutBoundSHTrips",
            success: function(results) {
                var result = JSON.parse(results);
                console.log("Deatils4", result.length);
                let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                    let row = {
                        "0": rowCounter,
                        "1": item.status,
                        "2": item.tripNo,
                        "3": item.vehicleNo,
                        "4": item.ATA,
                        "5": item.ATD,
                        "6": item.excessDetention
                    }
                    rows.push(row);
                    rowCounter++;
                })
                if ($.fn.DataTable.isDataTable("#table4")) {
                    $('#table4').DataTable().clear().destroy();
                }
                table4 = $('#table4').DataTable({
                	 "dom": 'Bfrtip',
                    "scrollY": true,
                    "scrollX": true,
                    searching: false,
                    paging: false,
                    autoWidth: true,
                    "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Outbound SH Details',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],   
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                });
                table4.rows.add(rows).draw();
            }
        })
    }
    
    function showTripAndAlertDetails(tripNo, vehicleNo, startDate, endDate, status, routeId) {
    var startDate = startDate.replace(/-/g, " ");
    var endDate = endDate.replace(/-/g, " ");
    var actualDate = "";
    window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
}
</script>