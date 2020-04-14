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
    
 %>
 
 <jsp:include page="../Common/header.jsp" />
	<title> Sand Boat Excavation Report</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	

    <link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <link href="../../Main/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
	<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>	

	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
	<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>

    <script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>

    <script src="../../Main/dist/js/sb-admin-2.js"></script>
    <script src="../../Main/Js/markerclusterer.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	
	
	
	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
 	<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
 	
 	
 		
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


#emptyColumn{
 width: 20px;
}

 </style>


	
	
<nav class="navbar navbar-default" style="background-color: #00a7cd;">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#" style="color: black;"  >Sand Boat Excavation Report</a>   
<!--	  <a class="navbar-brand" href="#" style="color: black; margin-left: -639px !important;"  >Sand Boat Excavation Report</a>  -->
    </div>
  </div>
</nav>
	
	
<div class="panel panel-default"  >
	<div class="panel-heading" style="background-color: #00a7cd; font-weight: bold; vertical-align: middle;position:relative;">
	
	<div class="row" style="padding-left: -20px;">
		<div class="col-lg-11 col-sm-11 col-md-11 ">
				<div class="col-lg-3 col-sm-3 col-md-3">
					<label for="staticEmail2" class="col-lg-6 ">Customer Name:</label>
					
						<select class="col-lg-6 col-sm-6 col-md-6" id="custDropDownId"  data-live-search="true" onchange="getTpOwner(this)" style="height:25px;">
						<option style="display: none"></option>
						  
						</select>

				</div>
				
					<div class="col-lg-3 col-sm-3 col-md-3">
					<label for="staticEmail2" class="col-lg-5 col-sm-5 col-md-5">TP Owner Name:</label>
					
						<select class="col-lg-7 col-sm-7 col-md-7" id="tpOwnerId"  data-live-search="true" style="height:25px;width:150px;">
						<option style="display: none"></option>
						  
						</select>

				</div>
				
			
			    <div class="col-lg-3 col-sm-3 col-md-3">
					 <label for="staticEmail2" class="col-lg-5 col-sm-5 col-md-5">Start Date:</label>
					<div class='col-lg-7 input-group date'   style="padding-left: 40px;">
						<input type='text'  id="dateInput1" />
				</div>
			     </div>
					<div class="col-lg-3 col-sm-3 col-md-3">
							 <label for="staticEmail2" class="col-lg-5 col-sm-5 col-md-5">End Date :</label>
							<div class='col-lg-8 input-group date' style="padding-left: 40px;">
								<input type='text'  id="dateInput2" />
							</div>
					 </div> 
					
					</div>
					<div class="col-md-1 col-sm-1 col-md-1"><button id="viewId" class="btn btn-primary" onclick="getData()">View</button></div>

		</div>
		</div>
		<div class="panel-body" style="overflow-y: auto;height: 80%;">
		<br><br/>
			<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>Serial Number</th>
					<th >TP Owner</th>
					<th >Boat Number</th>
					<th>Number Of Trips</th>
					<th>Quantity Excavated(Tons)</th>
					<th>Status</th>
					
					</tr>
				</thead>
			</table>
		</div>
	</div>
			
	
        
    <script>
    var table;
    var customerDetails;
    var addcustomerDetails;
    var status;
    var routeList;
    var routeListarray = [];
    var uniqueId;
    var currentDate = new Date();
    var restrictDate = new Date(currentDate).getDate()-7;
    var restrictMonth = new Date(currentDate).getMonth();
    var restrictYear =new Date(currentDate).getFullYear();
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);
	var tpOwnerDetails;
	
	window.onload = function () { 
		getCustomer();
	}
     
   $(document).ready(function () {
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '160px', height: '25px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '160px', height: '25px'});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
  
   $("#dateInput1").change(function (event) {
    var startDate = document.getElementById("dateInput1").value;
    var endDate = document.getElementById("dateInput2").value;

    if ((Date.parse(startDate) > Date.parse(endDate))) {
        sweetAlert("End date should be greater than Start date");
        document.getElementById("dateInput2").value = "";
   }
});
   $("#dateInput2").change(function (event) {
    var startDate = document.getElementById("dateInput1").value;
    var endDate = document.getElementById("dateInput2").value;

    if ((Date.parse(startDate) > Date.parse(endDate))) {
        sweetAlert("End date should be greater than Start date");
        document.getElementById("dateInput2").value = "";
   }
});
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
			//custId = customerDetails["CustomerRoot"][i].CustId;
            //custName = customerDetails["CustomerRoot"][i].CustName;
           
			}
		for (i = 0; i < custarray.length; i++) {
                var opt = document.createElement("option");
                document.getElementById("custDropDownId").options.add(opt);
                opt.text = custarray[i];
                opt.value = custarray[i];
            }
		}
	});
    }
    
    
function getTpOwner(el){

	for (var i = document.getElementById("tpOwnerId").length - 1; i >= 1; i--) {
      			document.getElementById("tpOwnerId").remove(i);
    		}
	var custId;
	var custName;
	var tparray=[];
	
	var customerName = document.getElementById("custDropDownId").value;

    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
             custId = customerDetails["CustomerRoot"][i].CustId;

        }
    }
	 var param = {
        CustId: custId
    };
	
	$.ajax({
        url: '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getTPownerName',
         data: param,
          success: function(result) {
                   tpOwnerDetails = JSON.parse(result);
				
			tparray.push("All");		                   
            for (var i = 0; i < tpOwnerDetails["TPowners"].length; i++) {
            
			tparray.push(tpOwnerDetails["TPowners"][i].tpName);
			//custId = customerDetails["CustomerRoot"][i].CustId;
            //custName = customerDetails["CustomerRoot"][i].CustName;
           
			}
		
            
            
            	$("#tpOwnerId").select2({
					  data: tparray
					});
            
		}
	});
    }
    
  //############function cancle##########
  function cancel(){
  	document.getElementById("addcustNameDownID").value="";
  	document.getElementById("addorderId").value="";
    //document.getElementById("addfleetReqDropDownID").value="";
    //document.getElementById("addtripDropDownID").value="";
    document.getElementById("addvehicleDropDownID").value="";
    document.getElementById("addrouteDropDownID").value = "";
    $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
    $('input:checkbox').removeAttr('checked');
    document.getElementById("modifycustNameDownID").value="";
	document.getElementById("modifyorderId").value="";
	document.getElementById("modifyrouteDropDownID").value="";
	document.getElementById("modifyvehicleDropDownID").value="";
    }
    
    //#############function to get grid data###################
  function getData(){
    
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
    
    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
    
      
    var newStartDate = document.getElementById("dateInput1").value;
    var newEndDate = document.getElementById("dateInput2").value;
    
    if(customerName == ''){
    	sweetAlert("Please select customer");
    }
    var tpId;
      var tpName = document.getElementById("tpOwnerId").value;
    for (var i = 0; i < tpOwnerDetails["TPowners"].length; i++) {
        if (tpName == tpOwnerDetails["TPowners"][i].tpName) {
             tpId = tpOwnerDetails["TPowners"][i].tpId;

        }
    }
    if(tpName == ''){
    	sweetAlert("Please select TP Owner");
    }    
    else if(newStartDate > newEndDate){
    	sweetAlert("End date should be greater than Start date");
    }
    
   else{
    		if(tpId == null ){
    	tpId = 0;
    	    }
  
     table = $('#example').DataTable({
         //"processing": true,
         // "serverSide": true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getSandExcavationReport',
             
             "data": {
                 CustId: customerId,
                 tpId : tpId,
                 startdate: startDate,
                 enddate: endDate
             },
             "dataSrc": "ticketDetailsRoot"
         },
          "bDestroy": true,
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    				},
         "bLengthChange": false,
         "dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				
        	 				exportOptions: {
				               columns: [0,1,2,3,4,5]
				           }
				            }
        	 				],

		      //  fixedColumns: true,
         
         
         "columns": [{
             "data": "slnoIndex"
         },{
             "data": "tpOwnerIndex"
         }, {
             "data": "boatNumberIndex"
         },{
         	"data": "noOfTripsIndex"
         }, {
             "data": "quantityExcavatedIndex"
         }, {
             "data": "statusDataIndex"
         }]
     });
    }
    }
    
    
    
    </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->