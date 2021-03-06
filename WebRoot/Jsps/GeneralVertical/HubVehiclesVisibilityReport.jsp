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
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" type="text/css"/>
	
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
  
<!--  	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">-->
  	
 
 <style>
 .form-control {
   display: block;
   width: 100%;
   height: 24px;
   padding: 6px 12px;
   font-size: 14px;
   line-height: 1.42857143;
   color: #555;
   background-color: #fff;
   background-image: none;
   border: 1px solid #aaa;
   border-radius: 4px;
   -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
   box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
   -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
   -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
   transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
   }
   
    .caret {
   display: none;
   }
   
   .multiselect-container {
   font-size:11px !important;
   overflow-x: scroll !important;
   }	
   .multiselect-container>li>a {
   margin-left: -15px;
   }
   a {
   text-decoration: none; 
   color: black; 
   }
   
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
 top: 50%;
     left: 45%;
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
	<h3 class="panel-title">HUB VEHICLE VISIBILITY REPORT</h3>
	</div>
	<div class="panel-body">
	
	<div class="row">
				<div class="col-lg-3">
					 <label for="staticEmail2" class="col-lg-4 col-sm-4 col-md-4 col-xs-4" style="padding-right: 0px !important">Start Date:</label>
				        <div class="col-lg-8 col-sm-8 col-md-8 col-xs-8 date">
						<input type='text'  id="dateInput1"  />
				        </div>
			    </div>
					
				<div class="col-lg-3">
				     <label for="staticEmail2" class="col-lg-4 col-sm-4 col-md-4 col-xs-4" style="padding-right: 0px !important">End Date:</label>
							<div class="col-lg-8 col-sm-8 col-md-8 col-xs-8 date">
							<input type='text'  id="dateInput2"  />
							</div>
				</div>
 
				<div class="col-lg-3">
				    <label for="staticEmail2" class="col-lg-4 col-sm-4 col-md-4 col-xs-4" style="padding-right: 0px !important">Hub Name:</label>
					<div class="col-lg-8 ">
					<select class="form-control" id="hubWise" multiple="multiple" class="input-s" name="state">
                    </select>
					 </div>	
                </div>				
				<div class="col-lg-3">	
				<button id="viewId" class="btn btn-primary" onclick="getVehicleHubsData()">View</button>
				</div>
	</div>
		
		<br><br/>
			<table id="activityReportTable" class="table table-striped table-bordered" cellspacing="0">
           		<thead>
                  <tr>
				   <th>Sl No.</th>
				   <th>Hub Name</th>
				   <th>Trip No</th>
				   <th>Customer Name</th>
				   <th>Vehicle Number</th>
				   <th>Vehicle Type</th>
				   <th>Current ODO Route</th>
				   <th>Vehicle Segment</th>
				   <th>Last Comm. DateTime</th>
				   <th>Hub Arrival DateTime</th>
				   <th>Hub Departure DateTime</th>
				   <th>Stoppage Time (HH:MM)</th>
				   <th>Ageing</th>
				  </tr>
				</thead>
			</table>
	</div>
</div>
    <script>
   // var table;
    window.onload = function () { 
		getHubNames(true);
	}
	
	var hubTypLength = 0;
	var tableN;
    var currentDate = new Date();
	var dd = currentDate.getDate();
    var mm = currentDate.getMonth() + 1; 
    var yyyy = currentDate.getFullYear();
	var hh = currentDate.getHours();
	var mi = currentDate.getMinutes();
	var ss = currentDate.getSeconds();
	var startdateSelected= "";
    var enddateSelected = "";
    var yesterdayDate = new Date();
    yesterdayDate.setDate(yesterdayDate.getDate() - 1);
    yesterdayDate.setHours(00);
	yesterdayDate.setMinutes(00);
	yesterdayDate.setSeconds(00);
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);
	
   $(document).ready(function () {
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '115%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '115%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
  });
  
  if (dd < 10) {
    dd = '0' + dd;
     } 
    if (mm < 10) {
    mm = '0' + mm;
    } 
     
  if (hh < 10) {
    hh = '0' + hh;
     } 
    if (mi < 10) {
    mi = '0' + mi;
    } 
     
  if (ss < 10) {
    ss = '0' + ss;
     } 
   
var today = dd + '-' + mm + '-' + yyyy + '_' + hh + '-' + mi + '-' + ss ;

var combo;
$('#hubWise').change(function() {
        var hubcombo = "";       
        var hubselected =$("#hubWise option:selected");
        
        hubselected.each(function () {
            hubcombo += $(this).val() + ",";
        });
		
		combo= hubcombo.split(",").join(",");
	
		var hubselected =$("#hubWise option:selected");
		
});

function formatDate(date) {
   var d = new Date(date),
      month = '' + (d.getDate()),
      day = '' + (d.getMonth() + 1),
      year = d.getFullYear();

   if (month.length < 2)
      month = '0' + month;
   if (day.length < 2)
      day = '0' + day;

   return [year, month, day].join('-');
}
function getHubNames(select) {
   $.ajax({
       type: 'GET',
       url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getSmartHubNames',
       datatype: 'json',
       contentType: "application/json",
       data: {
           customerId: <%=customerId%>,
           systemId: <%=systemId%>
           },
       success: function(response) {
		   hubTypeList = JSON.parse(response);
		   hubTypLength = hubTypeList["SmartHubNamesRoot"].length;
		   console.log(hubTypLength);
          
           for (var i = 0; i < hubTypeList["SmartHubNamesRoot"].length; i++) {
			   
          $('#hubWise').append($("<option></option>").attr("value", "'" + hubTypeList["SmartHubNamesRoot"][i].smartHubId + "'").text(hubTypeList["SmartHubNamesRoot"][i].smartHubName));
               
           }
           $('#hubWise').multiselect({
               nonSelectedText: 'Select a Smart Hub',
               includeSelectAllOption: true,
               enableFiltering: true,
               enableCaseInsensitiveFiltering: true,
               numberDisplayed: 1,
               allSelectedText: 'ALL',
               buttonWidth: 160,
               maxHeight: 200,
               selectAllText: 'ALL',
               selectAllValue: 'ALL',
           }).multiselect('selectAll', false).multiselect('updateButtonText');
           if(select){
            $("#hubWise").multiselect('deselectAll', false);
            $("#hubWise").multiselect('updateButtonText');
           }
       }
   });
}




  function getVehicleHubsData(){
	     startdateSelected = $("#dateInput1").val();
         enddateSelected = $("#dateInput2").val();
		dayDiff1 = dateValidation(startdateSelected, enddateSelected);

    
    	if (startdateSelected == ""){
			sweetAlert("Please select Start Date");
		    return;
		}
		if(enddateSelected == ""){
			sweetAlert("Please select End Date");
		    return;
		}
		
		if (!dayDiff1) {
   	     sweetAlert("End date should be greater than the Start date");
   	        return;
			}
			
		if(document.getElementById("hubWise").value == ""){
    	 	sweetAlert("Please select SmartHub");
		    return;
		}
		

		  
		 $('#loading-div').show();
		
		    $.ajax({
                   type: "GET",
                   url: "<%=request.getContextPath()%>/TripBasedReportAction.do?param=getHubVehicleDetailsForReport",
                   data: {
                      startdate: startdateSelected,
                      enddate: enddateSelected,
                      hubId: combo
                        },
                    success: function(result) {
						result = JSON.parse(result);
                       result = result["hubSummaryDetailsgrid"];
					   $('#loading-div').hide();
					   let rowCounter = 1;
                       rows = [];
                  $.each(result, function (i, item) {
                      let row = [];
                     row.push(rowCounter);
                     row.push(item.hubName != null? item.hubName : "");
                     row.push(item.tripId != null? item.tripId : "");
					 row.push(item.customerName != null? item.customerName : "");
 		             row.push(item.vehicleNo != null? item.vehicleNo : "");
                     row.push(item.vehicleType != null? item.vehicleType : "");
                     row.push(item.currentODO != null? item.currentODO : "");
                     row.push(item.vehicleSeg != null? item.vehicleSeg : "");
                     row.push(item.lastCommDtm != null? item.lastCommDtm : "");
                     row.push(item.hubArivDatm != null? item.hubArivDatm : "");
                     row.push(item.hubDeparDatm != null? item.hubDeparDatm : "");
                     row.push(item.stpgTme != null? item.stpgTme : "");
                     row.push(item.agening != null? item.agening : "");
                      let push = true;
                       if (push) {
                       rows.push(row);
                       rowCounter++;
                        }
                   });


           if ($.fn.DataTable.isDataTable("#activityReportTable")) {
              $('#activityReportTable').DataTable().clear().destroy();
           }

         tableN = $('#activityReportTable').DataTable({
               "scrollY": "300px",
                "scrollX": "300px",
                paging: false,
			"columnDefs": [
		    { "width": "30px", "targets": 0 },
		    { "width": "50px", "targets": 1 },
		    { "width": "50px", "targets": 2 },
		    { "width": "150px", "targets": 3 },
		    { "width": "50px", "targets": 4 },
		    { "width": "80px", "targets": 5 },
		    { "width": "50px", "targets": 6 },
			{ "width": "50px", "targets": 7 },
		    { "width": "150px", "targets": 8 },
		    { "width": "150px", "targets": 9 },
		    { "width": "150px", "targets": 10 },
		    { "width": "50px", "targets": 11 },
			{ "width": "50px", "targets": 12 }
		   
		],	 
					
              "oLanguage": {
            "sEmptyTable": "No data available"
                      },
             dom: 'Bfrtip',
          buttons: [
            {
                extend: 'excel',
                text: 'Export to Excel',
                title: 'Vehicles_Visibility_Report_' + today ,
                className: 'btn btn-primary',
                exportOptions: {
                    columns: ':visible'
                }
            }
                   ]
      });
         tableN.rows.add(rows).draw();
         }
          });
		  }
		  
		  
function dateValidation(date1, date2) {
    var dd = date1.split("/");
    var ed = date2.split("/");
    var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
    if (endDate >= startDate) {
        return true;
    } else {
        return false;
    }
    }
		  
		  
		  

						        
 
 
    </script>
  <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->