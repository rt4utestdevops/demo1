<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int systemId = loginInfo.getSystemId();
	Properties properties = ApplicationListener.prop;
	String vehicleImagePath = properties.getProperty("vehicleImagePath");
	String uniqueId =  request.getParameter("uniqueId");
	//String unit = cf.getUnitOfMeasure(systemId);
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Trip Creation</title>

	<!--  CSS -->
    <!-- Bootstrap Core CSS -->
    <link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<!--	<link href="../../Main/vendor/datatables/css/dataTables.bootstrap.min.css" rel="stylesheet">-->
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
		
	<!-- JS -->
	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
	<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>
    <!-- Metis Menu Plugin JavaScript -->
    <script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>
    <!-- Custom Theme JavaScript -->
    <script src="../../Main/dist/js/sb-admin-2.js"></script>
    <script src="../../Main/Js/markerclusterer.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
	
	<style>
		.row {
		    margin-right: -3px !important;
		    margin-left: -10px !important;
		}
		.panel-heading{
			padding-bottom: inherit !important;
    		padding-top: inherit !important;
		}
		.panel {
   	 		margin-bottom: 8px;
   	 	}
   	 	.label{
   	 		font-size: 18px;
   	 		color: white;
   	 		padding-left: 0px;
    		margin-left: -52px !important;
   	 	}
   	 	div.dataTables_wrapper div.dataTables_filter{
   	 		margin-top: 2px !important;
   	 	}
    	div.dataTables_wrapper div.dataTables_filter input{
    		height: 22px !important;
    	}
    	div.dataTables_wrapper div.dataTables_length select{
    		height: 31px !important;
    	}
    	button, input, select, textarea{
    		font-size:13px !important;
    	}
		.btn-warning {
    		color: #fff;
   	 		background-color: #31708f;
    		border-color: #31708f;
    	}
    	.modal-header{
    		margin-top: -10px !important;
    		margin-bottom: -7px !important;
    	}
    	#totalPanel{
    		margin-right: 330px;
    		float: right;
    		margin-top: -43px;
    		font-weight: 600;
    	}	
	</style>
</head>

<body >
<nav class="navbar navbar-inverse" style="margin-bottom: -18px;">
  <div class="container-fluid">
    <div class="navbar-header">
      <span class="navbar-brand" ><a href="<%=request.getContextPath()%>/Jsps/LoadAndRoutePlanner/ImportLoadPlan.jsp" style="color: red;">Load Optimizer</a></span>
    </div>
    <ul class="nav navbar-nav" >
<!--      <li><a href="<%=request.getContextPath()%>/Jsps/LoadAndRoutePlanner/ImportLoadPlan.jsp">Load Import</a></li>-->
<!--      <li class="active"><a href="#">Create Trip</a></li>-->
    </ul>
  </div>
</nav>

	<div id="wrapper" style=" width: 99%;">
    	<div id="page-wrapper" style="background-color: white;">
        	<div class="row">
              	<div class="panel panel-default" style="margin-right: -7px;">
              		<div class="panel-body" style="margin-top: -12px;">
                        	<div class="col-lg-12">
                            	<div>
                                	<table id="tripTable"  class="table table-striped table-bordered" cellspacing="0">
			                			<thead>
			                    			<tr>
			                        		<th>S No</th>
			                        		<th>Vehicle No</th>
			                        		<th>No of Orders</th>
			                        		<th>Vehicle Capacity (tons)</th>
			                        		<th>Lease Recommendation</th>
			                        		<th>Load Capacity (tons)</th>
			                        		<th>View Map</th>
			                        		<th>Trip</th>
			                        		<th>UniqueId</th>
			                        		<th>TripId</th>
			                        		<th>Status</th>
			                        		<th>Weight (Kg)</th>
			                        		</tr>
			                    		</thead>
			               			</table>
                                 </div>
                             </div>
                       </div>
          		</div>
            </div>
       </div>
	</div>
	<div id="add" class="modal fade" style="margin-right: 2%;">
        <div class="modal-dialog" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:1200px;height:400px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Order Details</h4>
                </div>
                <div class="modal-body" style="max-height: 50%;">
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12" style="border: solid  1px lightgray;  margin-top:6px;">
                        	<table id="orderTable"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		<th>S No</th>
		                        		<th>Customer</th>
		                        		<th>Order Date</th>
		                        		<th>Load Weight (kg)</th>
		                        		<th>Order Value</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		<div>
                    			<p id="totalPanel">Total Weight: 0 Kg</p>
                    		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-warning" data-dismiss="modal">Close</button> 
                    
                </div>
            </div>
        </div>
    </div>
	<script>
	
		var vehicleNo;
      	var table;
		var vehicleNo;
		var uniqueId;
		var tripId;
		
		loadData();
      	function loadData(){
				table = $('#tripTable').DataTable({
			      	"ajax": {
			        	"url": "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=getTripDetails",
			            "dataSrc": "tripDetailsRoot",
			            "data":{
			            	uniqueId : '<%=uniqueId%>'
			            }
			        },
			        "bDestroy": true,
			        "oLanguage": {
	       	 				"sEmptyTable": "No data available"
	    				},
		        	"lengthChange":true,
			        "columns": [{
			        		"data": "slNo"
			        	}, {
			                "data": "vehicleNo"
			            }, {
			                "data": "orders"
			            }, {
			                "data": "capacity"
			            }, {
			            	"data": "leaseRecommended"
			            }, {
			                "data": "filledCapacity"
			            }, {
			            	"data": "viewMap"
			            }, {
			            	"data": "createTrip"
			            }, {
			            	"data": "uniqueId"
			            }, {
			            	"data": "tripId"
			            }, {
			            	"data": "status"
			            }, {
			            	"data": "weight"
			            }]
	 			});
	 			
				table.column(8).visible( false );
				table.column(9).visible( false );
				table.column(10).visible( false );
				table.column(11).visible( false );
				
				
	 		$('#tripTable tbody').on('click', 'td', function() {
	        	var data = table.row( this ).data();
	        	var columnIndex = table.cell( this ).index().column;
	            vehicleNo = data['vehicleNo'];
	            uniqueId = data['uniqueId'];
	            tripId = data['tripId']
	            var status = data['status'];
	            var weight = data['weight'];
	            var tons = data['filledCapacity']; 
	            if(columnIndex == 6){
	            	window.location.href = "<%=request.getContextPath()%>/Jsps/LoadAndRoutePlanner/LoadOptimizerMap.jsp?vehicleNo="+vehicleNo+"&uniqueId="+uniqueId+"&tripId="+tripId+"";
	            }
	            if(columnIndex == 7 && status !== 'OPEN'){
	            	createTrip(vehicleNo,uniqueId,tripId);
	            }
	            if(columnIndex == 2){
	            	var text = "Total Weight : "+weight+" kg. ("+tons+" tons)"; 
	            	loadOrderPopup(uniqueId,tripId,text);
	            	$('#add').modal('show');
	            }
		        event.preventDefault();
	        });
	   	}
		function createTrip(vehicleNo,uniqueId,tripNo){
	   		$.ajax({
				url: "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=createTrip", 
			    "dataSrc": "routeDetailsRoot",
			    "data":{
			    	vehicleNo : vehicleNo,
			   		uniqueId: uniqueId,
			   		tripId: tripId
			    },
			    success: function(result){
			    	if(result.trim() === "Success"){
			    		sweetAlert("Trip created successfully");
			    		$('#tripTable').DataTable().ajax.reload();
			    	}else{
			    		sweetAlert("Error while creating trip");
			    	}
			    }
			});
		}
		function loadOrderPopup(uniqueId,tripId,text){
			$("#totalPanel").text(text);
			var orderTable = $('#orderTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=getOrderDetails",
		            "dataSrc": "orderDetailsRoot",
		            "data":{
		            	uniqueId : uniqueId,
		            	tripId: tripId
		            }
		        },
		        "bDestroy": true,
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    			},
	        	"lengthChange":true,
		        "columns": [{
		        		"data": "slNo"
		        	}, {
		                "data": "customer"
		            }, {
		                "data": "orderDate"
		            }, {
		                "data": "orderWeight"
		            },{
		            	"data": "orderValue"
		            }]
	 		});
		} 
	</script>
</body>
</html>
