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
   
 %>

<jsp:include page="../Common/header.jsp" />
	<title> Summary Report </title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">

	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
 	<script src="../../Main/sweetAlert/sweetalert-dev.js"></script> 
	
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

label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: 500;
}
#emptyColumn{
 width: 20px;
}
.dataTables_scroll
		{
		    overflow:auto;
		    position:relative;
		}

#reportTable_filter{
         //margin-top: -34px;
         }
       
#emptyColumn{
 width: 20px;
}

/* CSS for Plus and Minus Symbol */		
	td.details-control {
    background: url('../../Main/images/details_open.png') no-repeat center center;
    cursor: pointer;
}
tr.shown td.details-control {
    background: url('../../Main/images/details_close.png') no-repeat center center;
}
			.col-md-3, .col-md-4 {
				padding:0px !important;
			}
			.overFlow {
				overflow-x:auto;
			}
			@media only screen and (min-width: 768px) {
					#reportTable_paginate {
						margin-left : 865px !important;
					}
					#reportTable_filter {
						margin-left: 800px !important;
					}
			}	
			@media screen and (max-width: 767px) {
				div.dt-buttons {
					width: 62% !important;    
				}
			}
			.dataTables_scroll {
				margin-bottom : 10px !important;
				width : 100% !important;
			}
 </style>


	
<div class="panel panel-default">
	<div class="panel-heading">
	<h3>Summary Report</h3></div>
	<div class="panel-body">
	
		<div class="row"> 		
				<div class="col-sm-4 col-md-4" style="margin-bottom:8px;">
					<label for="staticEmail2" class="col-sm-5 ">Customer:</label>	
					<div class="col-lg-6 col-sm-6 col-md-6 col-xs-6">					
						<select id="custDropDownId"  data-live-search="true" style="width : 135px;height : 25px">
							<option style="display: none"></option>						  
						</select>
					</div>	
				</div>				
			    <div class="col-sm-3 col-md-3" style="margin-bottom:8px;">
					 <label for="staticEmail2" class="col-sm-4 ">Start Date:</label>					
					<div class="col-lg-6 col-sm-6 col-md-6 col-xs-6 date">
						<input type='text'  id="dateInput1"  />
					</div>
			     </div>
				<div class="col-sm-3 col-md-3" style="margin-bottom:8px;">
					<label for="staticEmail2" class=" col-sm-4 ">End Date:</label>					
					<div class="col-lg-8 col-sm-8 col-md-8 col-xs-8 date">
						<input type='text'  id="dateInput2"  />
					</div>
			    </div>  
				<div class="col-sm-1 col-md-1" style="margin-bottom:0px;">
					<button id="viewId" class="btn btn-primary" onclick="getData()">View</button>
				</div>
		</div>
		
		<br><br/>
		<div id="overflow" class="overFlow">	
			<table id="reportTable" class="table table-striped table-bordered" cellspacing="0" style="width:100%">
           		<thead>
                 		<tr>
									<th>Sl.No</th>
				        			<th>Vehicle No</th>
				        			<th>Indent Vehicle type </th>
	                                <th>Total Nos. of trips</th>
	                                <th>No. Of days Allocated</th>
	                                <th>Total Expected Distance </th>
	                                <th>Total Distance covered</th>                                  
	                                <th>Total Trip Time(hours)</th>
						</tr>
				</thead>
			</table>
		</div>	
	</div>
		
	</div>
	
    <script>
   
   // var table;
    var customerDetails;
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
	window.onload = function () { 
		getCustomer();
	}
   $(document).ready(function () {
   
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '110%', height: '25px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', currentStartDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '110%', height: '25px'});
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
			}
		}
	});
	
    }

//#############function to get grid data###################
  function getData(){
    
	  if ($.fn.DataTable.isDataTable("#reportTable")) {
          $('#reportTable').DataTable().clear().destroy();
        }
    var customerId;
    var customerName = document.getElementById("custDropDownId").value;
    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
             customerId = customerDetails["CustomerRoot"][i].CustId;

        }
    }
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
    	return;
    }
	if (parsedStartDate > parsedEndDate) {
		   	sweetAlert("End date should be greater than Start date");
    	    return;
	}
        $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getVehicleSummaryReport',
             "data": {
            	 CustId: customerId,
	               startdate: startDate,
	               enddate: endDate,
             },
             success: function(result) {
              result = JSON.parse(result).vehicleSummaryGrid;
	      var rows = new Array();
              $.each(result, function(i, item) {
   	         var row = { 
		          		  "0" : item.slNo,
                          "1" : item.VEHNo,
                          "2" : item.Vehicletype,
                          "3" : item.TotalNoOfTrips,
                          "4" : item.NoOfAllocatedDays,
                          "5" : item.TotalDistanceExpected,
                          "6" : item.TotalDistanceCovered,
                          "7" : item.TotalNoOfHours

                     }
                
                rows.push(row);
              });
                table = $('#reportTable').DataTable({
                    "scrollY": "280px",
                    "scrollX": true,
                    paging : true,
                    "serverSide": false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    },
		    "dom": 'Bfrtip',
		    "processing": true,
                   "buttons": [{
                   		extend: 'pageLength'
				
               		}, {
                    	extend: 'excel',
                   		text: 'Export to Excel',
	    	            className: 'btn btn-primary',
       	         		messageTop: "Start Date:"+newStartDate+"    End Date:" +newEndDate,
               	    }],
                  });
                  table.rows.add(rows).draw();
         }
         });

		jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
 }
</script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->