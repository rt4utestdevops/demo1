<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int countryId = loginInfo.getCountryCode();
	int systemId = loginInfo.getSystemId();
	String countryName = cf.getCountryName(countryId);
	Properties properties = ApplicationListener.prop;
	String vehicleImagePath = properties.getProperty("vehicleImagePath");
	String unit = cf.getUnitOfMeasure(systemId);
%>
<jsp:include page="../Common/header.jsp" />
  <title>Amazon</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
   <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css"> 
   <link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" rel="stylesheet" />
   <link href="https://cdn.datatables.net/buttons/1.5.1/css/buttons.dataTables.min.css" rel="stylesheet" />
   <link href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.bootstrap.min.css" rel="stylesheet" /> 
   <link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" rel="stylesheet" />
   <link href="https://cdn.datatables.net/buttons/1.5.1/css/buttons.dataTables.min.css" rel="stylesheet" />
   <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
   


	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
<!--	<script src="https://cdn.datatables.net/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script>-->
	<script src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script> 
	<script src="https://cdn.datatables.net/responsive/2.2.1/js/responsive.bootstrap.min.js"></script> 

	
	
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
	


 <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
	
<!--	<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>   -->
    
     <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
    
  <style>
#page-loader{
  position:fixed;
  left: 20%;
  top: 35%;
  z-index: 1000;
  width:100%;
  height:100%;
  background-position:center;
  z-index:10000000;
  opacity: 0.7;
  filter: alpha(opacity=40); /* For IE8 and earlier */
}

div.dataTables_wrapper {
        width: 100%;
       
    }
    div.dataTables_wrapper div.dataTables_paginate ul.pagination {
    margin: 20px 0;
    white-space: nowrap;
}

#countTable_filter {
	//margin-left : 175px !important;
	margin-left : 6px !important;
}
#tripSumaryTable_filter {
	margin-left : 780px !important;	
}
#countTable_paginate {
	//margin-left : 184px !important;
	margin-left : 6px !important;
}
#tripSumaryTable_paginate {
	margin-left : 865px !important;
}
#countTable {
	width : 102% !important;
}
@media only screen and (min-width: 640px) {
	#countTable { 
		width: 147% !important;
	}
	#countTable_filter {
		margin-left : 175px !important;	
	}
	#countTable_paginate {
		margin-left : 184px !important;	
	}
	
}


		.select2-container--default .select2-selection--single {   
			width : 112% !important;
		}
	
		.select2-container--default .select2-selection--single {
			//width: 196% !important;
		}
	
		@media only screen and (min-width: 768px) {
		.select2-container--default .select2-selection--single {
			/*width: 100% !important;*/
		}
		.select2-hidden-accessible, .select2-container{
			width:160px !important;
		}
		}
		.select2-container--default .select2-selection--single .select2-selection__arrow {
			right: -138px !important;
		}
		@media only screen and (min-width: 768px) { 
		.select2-container--default .select2-selection--single .select2-selection__arrow {
			//right: -8px !important;
		}		
		}
		.select2-dropdown--below {
			width : 200px !important;
		}
		.select2-container--default .select2-selection--single {
			width: 188% !important;
		}
		.select2-dropdown--below {
			width: 300px !important;
		}
		.pagination {
			margin-left : -325px !important;
		}
  </style>

<!--<body onload="loadData();">   -->
 
<!--&quot;r<!-- <div class="container"> -->
  
  <div class="custom">
         <div class="panel panel-primary">
		 <nav class="navbar navbar-default navbar-fixed-top" >
				<div class="panel-heading">
                  <h3 class="panel-title" style="font-size: 24px;color: #5eb9f9;font-weight:300;">Trip Dashboard </h3>
               </div>
			   </nav>
		 <div class="panel-body" style="margin-top: 3%;">
		    <div class="panel row" style="padding:1% ;margin: 0%;border: solid 1px #ccc;"> 
			     <div class="col-sm-12 col-md-12 col-lg-12">
				 <div class="col-sm-12 col-md-2 col-lg-2"></div>
				  <div class="col-sm-12 col-md-6 col-lg-6" style="border: 3px solid #f5f5f5;padding-top: 1%;" >
				  <table id="countTable" class="table table-striped table-bordered" cellspacing="0"  style="margin-top:1%">
					<thead>
						<tr><th colspan=2><h3 style="text-align:center">Trip Information</h3></th></tr>
						  <tr>
							<th>Sort Center Name</th>
							<th>Vehicle Count</th>
						  </tr>
						</thead>
					</table>	
					 </div>
					   <div class="col-xs-12 col-md-3 col-lg-3"></div>
			   </div>  <!--End of header Panel1- count table 1-->
			
		   
			<div class="col-xs-12 col-md-12 col-lg-12" style="margin-top: 1%;border: 1px solid #f5f5f5; padding-top: 1%;">

<div class="col-xs-12 col-md-4 col-lg-4 form-group ">
    <label for="sort" class="col-sm-3 control-label"style="white-space:nowrap;"> Location : </label>
    <div class="col-sm-9">
        <select class="form-control" name="sort" id="hubId">
            <option value="All">All</option>
        </select>
     </div>
</div>

<div class="col-xs-12 col-md-4 col-lg-4 form-group">
    <label for="sort" class="col-sm-3 control-label" style="white-space:nowrap;"> Sort Center : </label>
    <div class="col-sm-9">
        <select class="form-control" name="sort" id="depotId">
            <option value="All">All</option>
        </select>
     </div>
</div>



<div class="col-xs-12 col-md-3 col-lg-3 form-group">
    <label for="sort" class="col-sm-2 control-label" style="white-space:nowrap;"> Trip : </label>
    <div class="col-sm-10">
        <select class="form-control" name="sort" id="groupName">
            <option id="0">On Trip</option>
												<option id="1">Last 2 days</option>
												<option id="2">Last 1 week</option>
												<option id="3">Last 15 days</option>
												<option id="4">Last 1 month</option>
												<option id="5">Last 2 days Closed Trip</option>
        </select>
     </div>
</div>
 
</div> <!--  heading 2 end -->
  <div id="page-loader" style="margin-left:10px;margin-top:200px;display:none;">
				<img src="../../Main/images/loading.gif" alt="loader" />
		</div>
<div class="col-xs-12 col-md-12 col-lg-12"style="overflow: auto !important;    padding-top: 1%;">
			   <table id="tripSumaryTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
											<th>#</th>
			                        		<th>Trip No</th>
			                        		<th>Transporter Name</th>
			                        		<th>Vehicle No</th>
			                        		<th>Latest Communication Time</th>
			                        		<th>Current Location</th>
			                        		<th>Sort Center</th>
			                        		<th>Status</th>
			                        		<th>Action</th>
											<th>Start Date</th>
											<th>End Date</th>
			                        		<th>Hub1 Name</th>
			                        		<th>Entry Time</th>
			                        		<th>Exit Time</th>
											<th>Stop Duration (min)</th>
											<th>Hub2 Name</th>
			                        		<th>Entry Time</th>
			                        		<th>Exit Time</th>
											<th>Stop Duration (min)</th>
											<th>Hub3 Name</th>
			                        		<th>Entry Time</th>
			                        		<th>Exit Time</th>
											<th>Stop Duration (min)</th>
<!--											<th>Hub4 Name</th>-->
<!--			                        		<th>Entry Time</th>-->
<!--			                        		<th>Exit Time</th>-->
<!--											<th>Stop Duration</th>-->
			                        		<th>Next Nearest Hub</th>
											<th>No.of km Travelled</th>
					 </tr>
					
					</thead>	
							
				</table>
</div>	<!-- end of table -->
 </div>  <!--panel  row-->
		 </div>  <!-- end of panel body -->
		 </div> <!-- end of panel  -->
</div> <!-- end of main div : custom -->

<script>
window.onload = function () { 
		loadData();
	}

$('#groupName').change(function() {
	         groupId = $('#groupName option:selected').attr('id');
	         loadTable();
	    });
	    
	    $('#depotId').change(function() {
	         loadTable();
	    });
	    $('#hubId').change(function() {
	         loadTable();
	    });
	    
	    function loadData(){
	    loadTable();
	    getTripCounts();
	    getSortCenter();
	    getHubName();
	    
<!--	      setInterval( function () {-->
<!--	    getTripCounts();-->
<!--	    getSortCenter();-->
<!--	    getHubName();-->
<!--   		$('#tripSumaryTable').DataTable().ajax.reload();-->
<!--		}, 30000);	// 30 sec interval-->
	    }
	    function getTripCounts(){
 
    		     if ($.fn.DataTable.isDataTable('#example')) {
				$('#countTable').DataTable().destroy();
       }
		var	table1 = $('#countTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSortCenterVehicleCount",
		            "dataSrc": "vehicleCount",
					
		        },
		        "destroy": true,
 				//"lengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]] ,
		        "columns": [{
		        		"data": "sortCenterName"
		        	}, {
		                "data": "vehicleCount"
		            }]
 			});
		}
<!--function getTripCounts1(){-->
<!--     var TRIPCOUNT;-->
<!--	 var totalcount=0;-->
<!--	  jQuery('#tableBodyId tr').html('');-->
<!--     $.ajax({-->
<!--         type: "POST",-->
<!--         url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSortCenterVehicleCount',-->
<!--         success: function(result) {-->
<!--             TRIPCOUNT = JSON.parse(result);-->
<!--             for (var i = 0; i < TRIPCOUNT["vehicleCount"].length; i++) {-->
<!--                 var count = TRIPCOUNT["vehicleCount"][i].vehicleCount;-->
<!--                 var name = TRIPCOUNT["vehicleCount"][i].sortCenterName;-->
<!--				  totalcount +=  count;-->
<!--				var objTo = document.getElementById('tableBodyId');-->
<!--				var row = document.createElement("tr");-->
<!--				   row.innerHTML += '<td>'+name+'</td><td>'+count+'</td>';-->
<!--					objTo.appendChild(row);-->
<!--             }-->
<!--             -->
<!--                var objTo1 = document.getElementById('tableBodyId');-->
<!--				var row1 = document.createElement("tr");-->
<!--				row1.innerHTML = '<td colspan=2>Assigned Vehicles : '+totalcount+'</td>';-->
<!--			    objTo1.appendChild(row1);-->
<!--			    -->
<!--			    var objTo2 = document.getElementById('tableBodyId');-->
<!--				var row2 = document.createElement("tr");-->
<!--				row2.innerHTML = '<td colspan=2>Total Vehicles : '+totalcount+'</td>';-->
<!--			    objTo2.appendChild(row2);-->
<!--             -->
<!--            -->
<!---->
<!--         }-->
<!--     });-->
<!---->
<!---->
<!---->
<!-- }-->
<!-- -->
 function getSortCenter(){
     var SORTCNTER;
     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getSortCenterList',
         success: function(result) {
             SORTCNTER = JSON.parse(result);
             for (var i = 0; i < SORTCNTER["SortCenterRoot"].length; i++) {
                 var name = SORTCNTER["SortCenterRoot"][i].Name;
				 $('#depotId').append($("<option></option>").attr("value", name).text(name));
              
             }
              $("#depotId").select2({
             	});

         }
     });
 }
 
 function getHubName(){
     var HubIndex;
     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getHubList',
         success: function(result) {
             HubIndex = JSON.parse(result);
             for (var i = 0; i < HubIndex["hubRoot"].length; i++) {
                 var name = HubIndex["hubRoot"][i].Name;
				 $('#hubId').append($("<option></option>").attr("value", name).text(name));
             }
              $("#hubId").select2({
             	});

         }
     });
 }
	    
function loadTable(){
 document.getElementById("page-loader").style.display="block";
			groupId = $('#groupName option:selected').attr('id');
			var tripName = document.getElementById("groupName").value;
			var depot = document.getElementById("depotId").value;
    		var hub = document.getElementById("hubId").value;
    		     if ($.fn.DataTable.isDataTable('#example')) {
         $('#tripSumaryTable').DataTable().destroy();
     }
			table = $('#tripSumaryTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetailsAmazon",
		            "dataSrc": "tripSummaryDetails",
					"data": {
						groupId: groupId,
						unit:'<%=unit%>' ,
						depot:depot,
						hub:hub      
					}
		        },
		        "destroy": true,
		        "responsive": true,
		        "dom": 'Bfrtip',
			          		"buttons": [{extend:'pageLength'},{extend:'excel', text: "Export to Excel",title:"Amazon Trip Details ["+tripName+"] ",
			          		exportOptions: {
				                columns: [0,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
				            }
			          		}],

		        "columns": [{
		        		"data": "slNo"
		        	}, {
		                "data": "tripNo"
		            }, {
		                "data": "vendorName"
		            }, {
		                "data": "vehicleNo"
		            }, {
		                "data": "latestComm"  
		            }, {
		                "data": "currentLoc"  
		            },{
		                "data": "startLocation"
		            }, {
		            	"data": "status"
		            }, {
		            	"data": "button"
		            },{
		                "data": "StartDate"
		            }, {
		                "data": "endDate"
		            }, {
		                "data": "hubName1"
		            }, {
		                "data": "entryTime1"
		            }, {
		                "data": "exitTime1"
		            }, {
		                "data": "stopDur1"
		            },{
		                "data": "hubName2"
		            }, {
		                "data": "entryTime2"
		            }, {
		                "data": "exitTime2"
		            }, {
		                "data": "stopDur2"
		            },{
		                "data": "hubName3"
		            }, {
		                "data": "entryTime3"
		            }, {
		                "data": "exitTime3"
		            }, {
		                "data": "stopDur3"
		            },
<!--		            {-->
<!--		                "data": "hubName4"-->
<!--		            }, {-->
<!--		                "data": "entryTime4"-->
<!--		            }, {-->
<!--		                "data": "exitTime4"-->
<!--		            }, {-->
<!--		                "data": "stopDur4"-->
<!--		            },-->
		             {
		                "data": "estimatedNextPoint"
		            }, {
		                "data": "distanceTravelled"
		            }]
 			});
 			//table.column( 1 ).visible( false );
			//table.column( 5 ).visible( false );
			 document.getElementById("page-loader").style.display="none";
			$('#tripSumaryTable tbody').on('dblclick', 'td', function() {
        	var data = table.row( this ).data();
			
            tripNo = (data['tripNo']);
            vehicleNo = (data['vehicleNo']);
            startDate = (data['StartDate']);
            endDate = (data['endDate']);
            actualDate = (data['StartDate']);
            status = (data['status']);
            action = (data['button']);
            var columnIndex = table.cell( this ).index().column;    		
	    	if(columnIndex != 8){
	    		window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo="+tripNo+"&vehicleNo="+vehicleNo+"&startDate="+startDate+"&endDate="+endDate+"&pageId=99&status="+status+"&actual="+actualDate+"" , '_blank');
	       	}
            //if(action.indexOf('<button')!=0){
            	//window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo="+tripNo+"&vehicleNo="+vehicleNo+"&startDate="+startDate+"&endDate="+endDate+"&pageId=99&status="+status+"&actual="+actualDate+"";
            //}
            event.preventDefault();
        });
      
			
		}
		
		function closeTrip(uniqueId){
			swal({
	            title: "Are you sure you want to close the trip!",
	            type: "warning",
	            confirmButtonClass: "btn-danger",
	            confirmButtonText: "Yes!",
	            showCancelButton: true,
	        },
	        function() {
	            $.ajax({
			      //  url: '<%=request.getContextPath()%>/TripCreatAction.do?param=closeTripAmazon',
			        data: {
						uniqueId: uniqueId
					},
			        success: function(result) {
			        	if (result == "Trip Closed") {
			                sweetAlert("Trip Closed Successfully");
			                setTimeout(function(){
			                    loadData();
			                     }, 1000);
			            } else {
			                sweetAlert(result);
			            }
			        }
				})
	        },function() {
	            //alert();
	        })
		}
</script>



 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
