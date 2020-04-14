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
		if(loginInfo != null){
			 customerId = loginInfo.getCustomerId();
		}else{
 			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	 }
%>
<!--<!doctype html>-->
<!--<html lang="en">-->
<!--   <head>-->
<!--      <title>Vehicle Maintenance Report</title>-->
<!--      <meta charset="utf-8">-->
<!--      <meta name="viewport" content="width=device-width, initial-scale=1">-->
 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      
	 <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/3.2.4/css/fixedColumns.bootstrap.min.css">
<script src="https://cdn.datatables.net/fixedcolumns/3.2.4/js/dataTables.fixedColumns.min.js"></script>

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
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
      
      <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	  <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	  <link href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.bootstrap.min.css" rel="stylesheet">
	
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }
         .modal-open .modal {
         overflow-x: hidden;
         overflow-y: hidden;
         }
         .modalEdit {
         position: fixed;
         top: 5%;	
         left: 8%;
         z-index: 1050;
         width: 81%;
         bottom:unset;
         background-color: #ffffff;
         border: 1px solid #999;
         border: 1px solid rgba(0, 0, 0, 0.3);
         -webkit-border-radius: 6px;
         -moz-border-radius: 6px;
         border-radius: 6px;
         -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         -webkit-background-clip: padding-box;
         -moz-background-clip: padding-box;
         background-clip: padding-box;
         outline: none;
         }
         table.table-bordered.dataTable th:last-child, table.table-bordered.dataTable th:last-child, table.table-bordered.dataTable td:last-child, table.table-bordered.dataTable td:last-child {
         border-right-width: 1px;
         }
         #editableGrid_filter{
         margin-top: -34px;
         }
         #example_filter{
         margin-top: -65px;
         }
         .select2-container{
         	width:433px !important;
         }
         
         .table-striped>tbody>tr:nth-of-type(odd) {
					background-color: #f9f9f9;
					height: 20px !important;
		  }		  
		  thead th {
			white-space: nowrap;
		  }
		  tbody  tr td {
			white-space: nowrap;
		  }
		  div.dataTables_wrapper {
        width: auto;
        margin: 0;
    }
	
	::-webkit-scrollbar {
	width: 10px;
	height: 10px;
}
	
	  ::-webkit-scrollbar-track {
	background: #f1f1f1;
	border-radius: 4px;
}


/* Handle */

 ::-webkit-scrollbar-thumb {
	background: #888;
	border-radius: 4px;
}


/* Handle on hover */

 ::-webkit-scrollbar-thumb:hover {
	background: #555;
	border-radius: 4px;
}
		  
		  
 .tripDatatable_filter {
	margin-top: -60px;
}

 .dt-buttons {
	margin-top: -65px;
}
#example_paginate{
	margin-top: -30px;
}
      </style>
<!--   </head>-->
<!--   <body onload="getCustomers();">-->
      <div class="custom">
	  
	  
	  
	  
	  
         <div class="panel panel-primary" style="overflow-x: auto;overflow-y: hidden;margin-top: -31px;">
            <div class="panel-heading">
               <h3 class="panel-title" >
                  Payment Transactions Report 
               </h3>
            </div>
            <div class="panel-body">
			
			<div class="row"> 
				<div class="col-lg-3 col-sm-3 col-md-3 col-xs-3 "></div>
				<div class="col-lg-7 col-sm-7 col-md-7 col-xs-7 "> 
						 
						<div class="col-lg-4 col-sm-4 col-md-4 col-xs-4 date">
							<input type='text'  id="dateInput1"  />
					    </div>
				  
						<div class="col-lg-4 col-sm-4 col-md-4 col-xs-4 date">
							<input type='text'  id="dateInput2"  />
						</div>
				 
						<button id="viewId" class="col-lg-2 col-sm-2 col-md-2 col-xs-2 btn btn-primary" onclick="getPaymentTransactions()">View</button>
				</div>			
				<div class="col-lg-2 col-sm-2 col-md-2 col-xs-2 "></div>
			</div>
 		 
               <!--End of header Panel-->
               <div>
                  <table id="example" class="table table-striped table-bordered" cellspacing="0" width="90%">
                     <thead>
                        <tr>
                           <th >Sl No</th>
                           <th >Requested Date</th>
                           <th >Vehicle Number</th>
						   <th >LTSP Name</th>
						   <th >Customer Name</th>                  
                           <th >Group Name</th>
                           <th >Unit No</th>
						   <th >Asset Type</th>
						   <th >Asset Model</th>
						   <th >Amount</th>
                           <th >Owner Name</th>
                           <th >Owner Phone no</th>
						   <th >Owner Mail</th>
						   <th >Subscription Type</th>
                           <th >Payment Status</th>
						   <th >Payment Date</th>
                           <th >Regn  Status</th>
                           <th >Regn Date</th>
						   <th >Action</th>
                        </tr>
                       
                     </thead>
                  </table>
               </div>
               <!-- end of table -->
            </div>
            <!-- end of panel body -->
         </div>
         <!-- end of panel  -->
      </div>
      <!-- end of main div : custom -->
  
 <script >
 
	var prntTable;
    var indentId;
    var adhocCVCount;
    var dedicatedCVCount;
    var buttonValue;
    var recordId;
    var vehicleTypeList;
    var vehicleList;
	var custId = <%=customerId%>;
  

 
  
  $(document).ready(function () {
   
    var currDate = new Date();
     
      currDate.setHours(00);
	  currDate.setMinutes(00);
	  currDate.setSeconds(00);
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '90%', height: '30px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', currDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '90%', height: '30px'});
   $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
 
  
});


  
    function getPaymentTransactions() {
		
		 if ($.fn.DataTable.isDataTable('#example')) {
                $('#example').DataTable().destroy();
            }
		
	var newStartDate = document.getElementById("dateInput1").value;
	var newEndDate = document.getElementById("dateInput2").value;
	var dd = newStartDate.split("/");
    var ed = newEndDate.split("/");
    var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
     
	if (parsedStartDate >= parsedEndDate) {
		   	sweetAlert("End date should be greater than start date");
		   
    	    return;
	}
					
            var table = $('#example').DataTable({
                "ajax": {
                    "url": "<%=request.getContextPath()%>/ManageAssetAction.do?param=getPaymentTransaction",
                    "dataSrc": "paymentTransactionRoot",
                    "data": {
                        custId: custId,
						startDate : $('#dateInput1').val(),
						endDate : $('#dateInput2').val()
                    }
                },
				"scrollX": true,
				 "scrollY": 400,
                "bLengthChange": true,
				 scrollCollapse: true,
                 paging:         true,
                "dom": 'Bfrtip',
                "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export To Excel',
                    className: 'btn btn-primary',
                    exportOptions: {
			                columns: ':visible'
			            }
                }],"columnDefs": [
					{ className: "dt-nowrap", "targets": [ 3 ] }
				],"fixedColumns":   {
						leftColumns: 5,
				},
                "columns": [{
                    "data": "slno"
                },{
                    "data":"requestedDate" 
                },{
                    "data": "assetNumber"
                },  {
                    "data": "ltspName"
                }, {
                    "data": "customerName"
                },{
                    "data": "groupName"
                },  {
                    "data": "unitNo"
                },{
                    "data": "assetType"
                }, {
                    "data": "assetModel"
                }, {
                    "data": "amount"
                }, {
                    "data": "ownerName"
                }, {
                    "data": "ownerPhoneNo"
                }, {
                    "data": "ownerEmailId"
                }, {
                    "data": "subscriptionType"
                }, {
                    "data": "paymentStatus"
                },{
                    "data": "paymentDate"
                }, {
                    "data": "registrationStatus"
                }, {
                    "data": "registredDate"
                }, {
                    "data": "button"
                }]
            });
         
    }
	
	function resendLink(Id){
		//alert(Id);
		
		  $.ajax({
	        url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=resendPaymentLink',
	        data: {     custId: custId,
						Id : Id
                    },
	        success: function(result) {
	                  sweetAlert(result);
	        }
		})
		
	}
	
</script>
<!--</body>-->
<!---->
<!--</html> -->