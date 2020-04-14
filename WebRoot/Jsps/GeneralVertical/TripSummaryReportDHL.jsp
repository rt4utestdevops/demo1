<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
	GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
    String unit = cf.getUnitOfMeasure(systemId);
    String userAuthority=cf.getUserAuthority(systemId,userId);
    boolean isCustLogin = false;
    int custId= gvf.getUserAssociatedCustomerID(userId,systemId);
	if(custId != 0) {isCustLogin = true;}
   
 %>
 
 <jsp:include page="../Common/header.jsp" />
	
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">
	

	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
 	<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>   
	<script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
	
	
   
	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	<link href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.bootstrap.min.css" rel="stylesheet">
	
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
  
<!--  	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">-->
  	
 
 <style>
  .modal-body {
    position: relative;
    overflow-y: hidden;
    max-height: 500px;
    padding: 15px;
}
.input-group[class*=col-] {
    float: left !important;
    padding-right: 0px;
    margin-left: -54px !important;
}
.comboClass{
   width: 200px;
   height: 25px;
   
}
div.dataTables_wrapper div.dataTables_filter {
    text-align: right;
    margin-top: -33px;
}

#emptyColumn{
 width: 20px;
}
.dataTables_scroll
		{
		    overflow:auto;
		}
/* CSS for Plus and Minus Symbol */		
	td.details-control {
    background: url('../../Main/images/details_open.png') no-repeat center center;
    cursor: pointer;
}
tr.shown td.details-control {
    background: url('../../Main/images/details_close.png') no-repeat center center;
}
.center-view {
 background: none;
 position: fixed;
 z-index: 1000000000;
 top: 40%;
 left: 47%;
     right: 40%;
     bottom: 25%;
}

		
 </style>


<!-- <body onload=getCustomer()> -->
<div class="center-view" id="loading-div" style="display:none;">
   <img src="../../Main/images/loading.gif" alt="" style="position:absolute;">
</div>
<div class="panel panel-primary">
	<div class="panel-heading">
	<h3 class="panel-title">Trip Summary Report</h3></div>
	<div class="panel-body">
	
	<div class="row"> 
		
				<div class="col-lg-2 col-sm-2 col-md-2 col-xs-2 ">
					<label for="staticEmail2" class="col-lg-6 col-sm-6 col-md-6 col-xs-6 ">Customer:</label>
					
						<select class="col-lg-6 col-sm-6 col-md-6 col-xs-6" id="custDropDownId"  data-live-search="true" onchange="getTripCustomer()" style="height:25px; text-overflow: ellipsis; padding : 0px; ">
						<option style="display: none"></option>
						  
						</select>

				</div>
				
				<div class="col-lg-3">
					<label for="staticEmail2" class="col-lg-6 col-sm-6 col-md-6 col-xs-6 ">Trip Customer:</label>
					
						<select class="col-lg-6 col-sm-6 col-md-6 col-xs-6" id="tripCustDropDownId"  data-live-search="true" style="height:25px; text-overflow: ellipsis; padding : 0px;">
					<!-- 	<option value="All">All</option>  -->
						  
						</select>

				</div>
				
			    <div class="col-lg-3 col-sm-3 col-md-3 col-xs-3 ">
					 <label for="staticEmail2" class="col-lg-4 col-sm-4 col-md-4 col-xs-4" style="padding-left: 11px;">Start Date:</label>
					<div class="col-lg-8 col-sm-8 col-md-8 col-xs-8 date">
						<input type='text'  id="dateInput1"  />
				</div>
			     </div>
					<div class="col-lg-3 col-sm-3 col-md-3 col-xs-3 ">
							 <label for="staticEmail2" class="col-lg-4 col-sm-4 col-md-4 col-xs-4">End Date:</label>
							<div class="col-lg-8 col-sm-8 col-md-8 col-xs-8 date">
								<input type='text'  id="dateInput2"  />
							</div>
					 </div>  
					<button id="viewId" class="col-lg-1 col-sm-1 col-md-1 col-xs-1 btn btn-primary" onclick="getData()" style="margin-left: -3px;margin-top: 1px;padding: 5px 0px !important;top: -5px;">View</button>
		</div>
		
		<br><br/>
			<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					               <th>Serial Number</th>
                                   <th>Trip No</th>
                                   <th>Trip ID</th>
                                   <th>Route ID</th>
                                   <th>Vehicle Number</th>
                                   <th>Make of Vehicle</th>
                                   <th>LR No.</th>
                                   <th>Customer Reference ID</th>
                                   <th>Customer Name</th>
                                   <th>Driver Name</th>
                                   <th>Driver Contact</th>
                                   <th>Current Location</th>
                                   <th>Origin</th>
                                   <th>Destination</th>
                                   <th>Origin City</th>
                                   <th>Origin State</th>
                                   <th>Destination City</th>
                                   <th>Destination State</th>
                                   <th>Trip Status</th>
                                   <th>STP</th>
                                   <th>ATP</th>
                                   <th>STD</th>
                                   <th>ATD</th>
                                   <th>Delayed Departure (HH:mm)</th>
                                   <th>Total Trip Time (HH:mm)</th>
                                   <th>Fuel Consumed(L)</th>
                                   <th>Mileage - Fuel sensor(km/L)</th>
                                   <th>OBD Mileage(km/L)</th>                                   
                                   <th>Trip Travel Time (HH:mm)</th>
                                   <th>Green-Band RPM %</th>
                                   <th>Green Band Speed %</th>
                                   <th>STA</th>
                                   <th>ATA</th>
                                   <th>Before Time</th>
                                   <th>Total Delay(HH:mm)</th>
                                   <th>Average Speed(<%=unit%>/Hr)</th>
                                   <th>Total Stoppage Time(HH:mm)</th>
                                   <th>Total Distance(<%=unit%>)</th>
                                   <th>Placement Delay Time(HH:mm)</th>
                                   <th>Customer Detention Time(HH:mm)</th>
                                   <th>Loading Detention Time(HH:mm)</th>
                                   <th>Unloading Detention Time(HH:mm)</th>
                                   <th>Flag</th>
                                   <th>End Date</th>
                                   <th>routeId</th>
                                   <th>Door Alert</th>
                                   <th>Panic Alert</th>
                                   <th>Non-Communicating Alert</th>
                                   <th>Remarks</th>
                                   <th>Reason</th>
                                   <th>Cancelled Remarks</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
    <script>
   // var table;
    window.onload = function () { 
		getCustomer();
	}
	
    var customerDetails;
    var addcustomerDetails;
    var clsName='details';
    var status;
    var routeList;
    var routeListarray = [];
    var uniqueId;
    var currentStartDate = new Date();
    var restrictDate = new Date(currentStartDate).getDate()-7;
    var restrictMonth = new Date(currentStartDate).getMonth();
    var restrictYear =new Date(currentStartDate).getFullYear();
	currentStartDate.setHours(00);
	currentStartDate.setMinutes(00);
	currentStartDate.setSeconds(00);
	 
	currentEndDate = new Date();
	currentEndDate.setHours(23);
	currentEndDate.setMinutes(59);
	currentEndDate.setSeconds(59);
	
    var tripCustomerDetails;
   $(document).ready(function () {
   
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '110%', height: '25px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', currentStartDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '110%', height: '25px'});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentEndDate);
  

});
//##########function to get customer details#############//

function getCustomer(){
	var custId;
	var custName;
	var custarray=[];
	$.ajax({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
          success: function(result) {
                   customerDetails = JSON.parse(result);
         
            for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
			custarray.push(customerDetails["CustomerRoot"][i].CustName);
			}
		for (i = 0; i < custarray.length; i++) {
                var opt = document.createElement("option");
                document.getElementById("custDropDownId").options.add(opt);
                opt.text = custarray[i];
                opt.value = custarray[i];
            }
            
            if(customerDetails["CustomerRoot"].length == 1){
				var cName="";
				for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
					cName = customerDetails["CustomerRoot"][i].CustName;
				}
				function setSelectedIndex(s, v) {
					for ( var i = 0; i < s.options.length; i++ ) {
       			 		if ( s.options[i].text == v ) {
           		 			s.options[i].selected = true;
           		 			return;
        				}
   			 		}
				}
			setSelectedIndex(document.getElementById('custDropDownId'),cName);
			getTripCustomer(); 
			}
		}
	});
	
    }
    ///////////////get trip customer////////////////////
    function getTripCustomer(){
	var custId;
	var custName;
	var selectedCustId;
	   var custName = document.getElementById("custDropDownId").value;
    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
        if (custName == customerDetails["CustomerRoot"][i].CustName) {
             selectedCustId = customerDetails["CustomerRoot"][i].CustId;

        }
    }
	var custarray=[];
	$.ajax({
        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getUserAssociatedCustomer',
        data: {
                   userId: <%= userId %>,
                   userAuth: '<%= isCustLogin %>',
                   custId: <%= customerId %>
                },
          success: function(result) {
                   tripCustomerDetails = JSON.parse(result);
                   //var userAuth = '<%= userAuthority %>' ;
                   //if( userAuth != 'User'){
                   clsName ='details-control';
                   var optn = document.createElement("option");
                   document.getElementById("tripCustDropDownId").options.add(optn);
                	optn.text = 'All';
                	optn.value = 'All';
                  // }
         
            for (var i = 0; i < tripCustomerDetails["customerRoot"].length; i++) {
			custarray.push(tripCustomerDetails["customerRoot"][i].CustName);
			}
		for (i = 0; i < custarray.length; i++) {
                var opt = document.createElement("option");
                document.getElementById("tripCustDropDownId").options.add(opt);
                opt.text = custarray[i];
                opt.value = custarray[i];
            }
		}
	});
    }

//#############function to get grid data###################
  function getData(){
    $("#loading-div").show();
	setTimeout(function(){
		 $("#loading-div").hide();
	}, 10000);
    if ($.fn.DataTable.isDataTable('#example')) {
            $('#example').DataTable().destroy();
        }
      var customerId;
      var customerName = document.getElementById("custDropDownId").value;
    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
             customerId = customerDetails["CustomerRoot"][i].CustId;

        }
    }
    var tripCustomerName = document.getElementById("tripCustDropDownId").value;
    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
    var newStartDate = document.getElementById("dateInput1").value;
	var newEndDate = document.getElementById("dateInput2").value;
	var dd = newStartDate.split("/");
    var ed = newEndDate.split("/");
    var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
    if(customerName == ''){
    	sweetAlert("Please select customer");
    }
    if(tripCustomerName == ''){
    	sweetAlert("Please select trip customer");
    }
	if (parsedStartDate > parsedEndDate) {
		   	sweetAlert("End date should be greater than Start date");
		  //document.getElementById("dateInput2").value = currentDate;
    	    return;
	}
		
   else{
     var  table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetailsForReport",
                "dataSrc": "tripSummaryDetailsgrid",
                "data": {
                   CustId: customerId,
	               startdate: startDate,
	               enddate: endDate,
	               tripCustomerName : tripCustomerName
                }
            },
            "bDestroy": true,
            "deferRender": true,
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            dom: 'Bfrtip',
        	buttons: [ 'excel', 'pdf'],
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "buttons": [{extend:'pageLength'},
	      	 				{extend:'excel',
	      	 				text: 'Export to Excel',
	      	 				className: 'btn btn-primary',
	      	 				title: 'Trip Summary Report ('+"Start Time: " + $("#dateInput1").val() + "      End Time: " + $("#dateInput2").val() + ")",
	      	 				exportOptions: {
			               // columns: [0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,26,27,28,29,30,31,32,33,34,35,36,39,40,41]
			                columns: ':visible'
			            }}
	      	 ],
            columnDefs: [
		            { width: 100, targets: 2},
		            { width: 100, targets: 3 },
		            { width: 50,  targets: 4 },
		            { width: 200, targets: 11 },
		            { width: 200, targets: 12 },
		            { width: 300, targets: 13 }
		        ],
            "columns": [{
                "data": "slNo",//1
                "orderable": true,
                "defaultContent": '',
                "className": clsName
            }, {
                "data": "tripNo",
                "visible":false
            }, {
                "data": "ShipmentId"//3
            }, {
                "data": "routeName"
            }, {
                "data": "vehicleNo"
            }, {
                "data": "make"
            }, {
                "data": "lrNo"
            }, {
                "data": "custRefId"//8
            }, {
                "data": "customerName"
            }, {
                "data": "driverName",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "") {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "driverContact",
                 "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "") {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "Location"
            }, {
                "data": "origin"
            }, {
                "data": "Destination"
            }, {
            	"data": "OriginCity"
            }, {
            	"data": "OriginState"
            }, {
            	"data": "DestCity"
            }, {
            	"data": "DestState"
            }, {
                "data": "status"
            }, {
                "data": "STP"
            }, {
                "data": "ATP"
            }, {
                "data": "STD"
            }, {
                "data": "ATD",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "") {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "delayedDepartureATDSTD"
            }, {
                "data": "totalTripTimeATAATD"
            }, {
                "data": "fuelConsumed",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "" || cellData == "00.00" ) {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "mileageFuelSensor" ,
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == ""  || cellData == "00.00" ) {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "mileageOBD",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == ""  || cellData == "00.00" ) {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "TripTravelTime"               
            }, {
                "data": "greenBandRPM"//,//24
               // "visible":false
               ,
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "" || cellData == "NA" ) {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "greenBandSpeed"//,//25
              //  "visible":false
              ,"createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == ""  || cellData == "00.00" ) {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "STA"
            }, {
                "data": "ATA",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == ""  || cellData == "NA" ) {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            },{
                "data": "beforeTime"
            }, {
                "data": "delay"
            }, {
                "data": "avgSpeed"
            }, {
                "data": "stoppageTime"
            }, {
                "data": "totalDist"
            }, {
                "data": "placementDelay"
            }, {
                "data": "customerDetentionTime"
            }, {
                "data": "loadingDetentionTime"
            }, {
                "data": "unloadingDetentionTime"
            }, {
                "data": "flag"
            },{
                "data": "endDateHidden",//37
                "visible":false
            }, {
                "data": "routeIdHidden",//38
                "visible":false
            }, {
                "data": "doorAlert",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "") {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "panicAlert",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "") {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "nonReporting",
                "createdCell": function (td, cellData, rowData, row, col) { //t4u506 start
      				if ( cellData == "") {
        				$(td).css('background-color', 'yellow')
      				}
    			}//t4u506 stop
            }, {
                "data": "remarks"
            }, {
                "data": "reason"
            }, {
                "data": "cancelremarks"
            }],
            "order": [[0, 'asc']]
        });
         var userAuthr = '<%= userAuthority %>' ;
                   if( userAuthr == 'User'){
                    table.column(23).visible(false);
       			    table.column(22).visible(false);
       			    table.column(21).visible(false);
       			    }else
       			    {       			   
       			           $('#example').find('tbody').off('click', 'td.details-control');	
       			         	$('#example tbody').on('click', 'td.details-control', function () {
						        	//jQuery('#innertbaleId').html('');
						        //table.ajax.reload();
						       // var tr = $(this).closest('tr');
						       // var row = table.row( tr );
						         var tr = $(this).closest('tr');
						        var row = table.row( tr );
						 
						        if ( row.child.isShown() ) {
						     //  alert("if---------"+row);
						            // This row is already open - close it
						              tr.removeClass( 'details' );
						            row.child.hide();
						            tr.removeClass('shown');
						        }
						        else {
						        //   alert("else---------"+row);
						            // Open this row
						             tr.addClass( 'details' );
						            row.child( format(row.data()) ).show();
						            tr.addClass('shown');
						        }
						    } );
                   }

		jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
        $('#example tbody').on('dblclick', 'td', function() {
            var data = table.row(this).data();
            var columnIndex = table.cell(this).index().column;
            tripNo = (data['tripNo']);
            vehicleNo = (data['vehicleNo']);
            startDate = (data['STD']);
            endDate = (data['endDateHidden']);
            actualDate = (data['ATD']);
            status = (data['status']);
            routeId = (data['routeIdHidden']);
            window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=5&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId;
            event.preventDefault();
        });
 }
 }
 
  function format ( d ) {

	var tbody="";
	var a;
	
	if(d.legdetails.length>0)
	{
			for(var i=0;i<d.legdetails.length;i++)
			{
			var row="";
			row += '<tr>'
				row += '<td>'+d.legdetails[i].LegName+'</td>';
				row += '<td>'+d.legdetails[i].Driver1+'</td>';
				row += '<td>'+d.legdetails[i].Driver2+'</td>';
				row += '<td>'+d.legdetails[i].STD+'</td>';
				row += '<td>'+d.legdetails[i].STA+'</td>';
				row += '<td>'+d.legdetails[i].ATD+'</td>';
				row += '<td>'+d.legdetails[i].ATA+'</td>';
				row += '<td>'+d.legdetails[i].TotalDistance+'</td>';
				row += '<td>'+d.legdetails[i].AvgSpeed+'</td>';
				row += '<td>'+d.legdetails[i].FuelConsumed+'</td>';
				row += '<td>'+d.legdetails[i].Mileage+'</td>';
				row += '<td>'+d.legdetails[i].OBDMileage+'</td>';
				row += '<td>'+d.legdetails[i].TravelDuration+'</td>';
				row += '<td>'+d.legdetails[i].ETA+'</td>';
				row += '<td>'+d.legdetails[i].LegGreenBandRPM+'</td>';
				row += '<td>'+d.legdetails[i].LegGreenBandSpeed+'</td>';
		
				row += '</tr>';
				//objTo.appendChild(row);
				tbody+=row;
			}
			a = '<div id="innertbaleId" style="overflow-x:auto;width:35%">'+
				'<table class="table table-bordered">'+
				'<thead>'+	
				'<tr style=" font-size: larger; color: black;">'+
		                                   '<th>Leg Name</th>'+
		                                   '<th>Driver 1</th>'+
		                                   '<th>Driver 2</th>'+
		                                   '<th>STD</th>'+
		                                   '<th>STA</th>'+
		                                   '<th>ATD</th>'+
		                                   '<th>ATA</th>'+
		                                   '<th>Total Distance (km)</th>'+
                                           '<th>Average Speed (kmph)</th>'+
                                           '<th>Fuel Consumed</th>'+
                                           '<th>Mileage</th>'+
                                           '<th>OBD Mileage</th>'+
                                           '<th>Travel Duration (HH:mm)</th>'+
                                           '<th>ETA</th>'+
                                           '<th>Green Band RPM %</th>'+
                                           '<th>Green Band Speed %</th>'+
		                                   
				'</tr>'+
				'</thead>' +
				'<tbody id="tbodyId">'+tbody+'</tbody>'+
		    '</table>'+
		    '</div>';
   }
   else
   {
  			var row="";
			row += '<tr>'
				row += '<td colspan="14"><b>No Records Found for Trip Id: '+d.ShipmentId+'</b></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '<td></td>';
				row += '</tr>';
				tbody+=row;
   		
   		a = '<div style="overflow-x:auto;width:30%">'+
		'<table  cellpadding="5" cellspacing="0" border="0">'+
		' <thead>'+	
		'</thead>'+
		'<tbody id="tbodyId">'+tbody+'</tbody>'+
    '</table>'+
    '</div>';
   }
  // alert(a);
   return a;
}
 
    </script>
  <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->