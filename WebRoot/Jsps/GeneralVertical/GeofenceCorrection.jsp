<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.GeneralVertical.*"
	pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
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
			
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
	int offset = loginInfo.getOffsetMinutes();
	String offsetHHMM = cf.convertMinutesToHHMMFormat(offset);   
	String distUnits = cf.getUnitOfMeasure(systemId);
	 
%>
 
 <jsp:include page="../Common/header.jsp" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

 	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 	<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.dataTables.min.css"></link>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>   
	<script src="https://malsup.github.io/jquery.form.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
   <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
   <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
	    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>

   <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
 <style>

 
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
.comboClass2{
   width: 200px;
   height: 25px;
   
}
.comboClassVeh{
   width: 200px;
   height: 25px;
   
}
.comboClassDriver{
   width: 150px;
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
#emptyColumn2{
 	width: 30px;
}
.dataTables_scroll
{
    overflow:auto;
}

.btn{
	font-size:13px;
}

#dateInput1{
    width: 180px !important;
    height: 25px;
}
#dateInput2{
    width: 180px !important;
    height: 25px;
}
#reportTable_filter{
   margin-top: -34px;
}
table {
font-size: smaller;
}
    
.dataTables_scrollBody{
  overflow-y: auto !important;
  overflow-x: hidden !important;
}

@media (min-width: 576px){
.form-inline label {
    margin-top: 20px !important;    
    margin-left: 1000px !important;
}
}

div.dataTables_wrapper div.dataTables_paginate {   
    margin-left: 986px  !important;
}

#reportTable_wrapper{
	padding-left: 10px;
    padding-right: 5px;
}
.multiselect{
			 
			 margin-top: -37px !important;
   			margin-left: 92px !important;
		 }

		 .btn-group.open .dropdown-toggle {
		 	 width:196.22px;
			 height: 34px;
		 }
		 .multiselect-selected-text{
		 	 width:196.22px;
			 height: 34px;
		  }
		 .btn-group>.btn:first-child {
		    width: 196.22px;
		  }
		.modal-title{
		   text-align: center;
		  }
		 .btn .caret {
    		display: none;
		  }
		.multiselect-container {
		    overflow-y: auto;
    		height: 211px !important;
		} 
		.multiselect {
			width : 245px !important;
		}
 </style>
<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
                    Geofence Correction Report
		</h3>
	</div>
	<div class="panel-body">
	<div class="row">
				<div class="col-sm-3 col-md-3">
					<label for="staticEmail2" class="col-sm-4 col-md-4" >Customer</label>
					<select class="form-control" multiple="multiple" id="custDropDownId">
						</select>
				</div>
				
			    <div class="col-sm-3 col-md-3" style="display: inherit;">
					 <label for="staticEmail2" class="col-sm-5 col-md-5" >Start Date</label>
					 	<div class='col-sm-7 col-md-7 input-group date' style="margin-left: -4% !important;">
							<input type='text'  id="dateInput1"/>
						</div>
				</div>
					 
				<div class="col-sm-3 col-md-3" style="display: inherit;">
				    <label for="staticEmail2" class="col-sm-5 col-md-5" >End Date</label>
						<div class='col-sm-7 col-md-7 input-group date' style="margin-left: -4% !important;">
							<input type='text'  id="dateInput2"/>
						</div>
				</div>
				
				<div class="col-sm-3 col-md-3">
					<div class="col-sm-4 col-md-4"> 
						<button id="viewId" class="col-lg-12 btn btn-primary" onclick="getGridData()">View</button>
					</div>
				</div>
	
		<br><br/>
		<div style="overflow: auto !important;">
			<table id="reportTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>SL. No</th>
					<th>Trip Customer Name</th>
					<th>Hub Name</th>
					<th>Previous Latitude</th>
					<th>Previous Longitude</th>
					<th>Present Latitude</th>
					<th>Present Longitude</th>
					<th>Updated Date</th>
					<th>Upddated By</th>
					
					</tr>
				</thead>
			</table>
		</div>
	</div>
	</div>

    <script>
	
    var customerDetails;
    var status;
    var startDate="";
    var endDate = "";
    var uniqueId;
    var currentDate = new Date();
    var yesterdayDate = new Date();
         yesterdayDate.setDate(yesterdayDate.getDate() - 1);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);

	var tripId =0;
    
   $(document).ready(function () {
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

	});
//##########function to get customer details#############//

$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getCustomerNames',
	        success: function(result) {
	            addcustList = JSON.parse(result);
	            for (var i = 0; i < addcustList["customerRoot"].length; i++) {
                    $('#custDropDownId').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
	            }
	            $('#custDropDownId').multiselect({
	            nonSelectedText:'Select Customer',
 				includeSelectAllOption: true,
				enableFiltering: true,
				enableCaseInsensitiveFiltering: true,
 				numberDisplayed: 1
 				});             				
	            $("#custDropDownId").multiselect('selectAll', true);
  				$("#custDropDownId").multiselect('updateButtonText');
	           // $('#custDropDownId').select2();
			}
		});


    //#############function to get grid data###################
    
    function getGridData(){
    	//var status = document.getElementById("statusTypeDropDownId").value;
    	//var apiStatus = document.getElementById("apiTypeDropDownId").value;
    	var custcombo = "";       
        var custselected =$("#custDropDownId option:selected");
        
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });
		
		var combo= custcombo.split(",").join(",");
	
		var custselected =$("#custDropDownId option:selected");
		console.log(custselected);
		
    	 if(document.getElementById("custDropDownId").value == ""){
    	 	sweetAlert("Please select Customer");
		    return;
    	 }else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("dateInput1").value;
			endDate = document.getElementById("dateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("dateInput2").value = currentDate;
		       	    return;
		   		}
		}	

        
         if ($.fn.DataTable.isDataTable('#reportTable')) {
            $('#reportTable').DataTable().destroy();
        }
      var table = $('#reportTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getGeofenceCorrectionData',
             "data": {
                    startDate: startDate,
					endDate: endDate,
					tripCustId: combo
             },
             "dataSrc": "geofenceCorrectionRoot"
         },
         "bLengthChange": false,
          "dom": 'Bfrtip',
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'GeoFence Correction Report  '+startDate+ " - " +endDate,
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "slnoIndex"
         }, {
             "data": "tripCustNameIndex"
         },{ 
             "data": "hubNameIndex"
         },{
             "data": "previousLatIndex"
         },{
             "data": "previousLonIndex"
         },{
             "data": "presentLatIndex"
         }, {
             "data": "presentLonIndex"
         }, {
             "data": "updatedDateIndex"
         },{
             "data": "updatedByIndex"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

    }
</script>
   <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 