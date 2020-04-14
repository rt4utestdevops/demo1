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
   .input-group[class*=col-] {
   float: left !important;
   padding-right: 0px;
   margin-left: -54px !important;
   }
   label {
   display: inline-block;
   max-width: 100%;
   margin-bottom: 5px;
   font-weight: 500;
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
   #viewId{
   margin-left: 19px;
   width: 83px;
   height: 26px;
   padding-top: 4px;
   }
</style>

 
<div class="panel panel-primary">
<div class="panel-heading">
   <h3 class="panel-title">
      Trip Audit Log Report
   </h3>
</div>
<div class="panel-body">
   <div class="row">
      <div style="display: inherit;">
         <label style="width: 133px;margin-left: 14px;">Start Date</label>
         <div class='input-group date' style="margin-left: -4% !important;">
            <input type='text'  id="dateInput1"/>
         </div>
      </div>
      <div style="display: inherit;">
         <label style="width: 86px;">End Date</label>
         <div  input-group date' style="margin-left: -4% !important;">
            <input type='text'  id="dateInput2"/>
         </div>
      </div>
      <div >
         <div> 
            <button id="viewId" class="btn btn-primary" onclick="getGridData()">View</button>
         </div>
      </div>
      <br><br/>
      <div style="overflow: auto !important;">
         <table id="reportTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
               <tr>
                  <th>S No</th>
                  <th>Trip No</th>
                  <th>Datetime</th>
                  <th>Action</th>
                  <th>User Name</th>
                  <th>Page Name</th>
                  <th>Remarks</th>
               </tr>
            </thead>
         </table>
      </div>
   </div>
</div>

<script>

var startDate = "";
var endDate = "";
var currentDate = new Date();
var yesterdayDate = new Date();
yesterdayDate.setDate(yesterdayDate.getDate() - 1);
yesterdayDate.setHours(00);
yesterdayDate.setMinutes(00);
yesterdayDate.setSeconds(00);
currentDate.setHours(23);
currentDate.setMinutes(59);
currentDate.setSeconds(59);

$(document).ready(function() {
    $("#dateInput1").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '100%',
        height: '25px',
        max: new Date()
    });
    $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
    $("#dateInput2").jqxDateTimeInput({
        theme: "arctic",
        formatString: "dd/MM/yyyy HH:mm:ss",
        showTimeButton: true,
        width: '100%',
        height: '25px',
        max: currentDate
    });
    $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

    getGridData();
});

function getGridData() {

    if (document.getElementById("dateInput1").value == "") {
        sweetAlert("Please select Start Date");
        return;
    } else if (document.getElementById("dateInput2").value == "") {
        sweetAlert("Please select End Date");
        return;
    } else {
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
            "url": '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getTripAuditLogReport',
            "data": {
                startDate: startDate,
                endDate: endDate
            },
            "dataSrc": "tripAuditLogDetails"
        },
        "bLengthChange": false,
        "dom": 'Bfrtip',
        "buttons": [{
                extend: 'pageLength'
            },
            {
                extend: 'excel',
                text: 'Export to Excel',
                title: 'Audit Log Report  ' + startDate + " - " + endDate,
                className: 'btn btn-primary',
                exportOptions: {
                    columns: ':visible'
                }
            }
        ],
        "columns": [{
            "data": "slNo"
        }, {
            "data": "orderId"
        }, {
            "data": "datetime"
        }, {
            "data": "action"
        }, {
            "data": "userName"
        }, {
            "data": "pageName"
        },{
        	"data": "remarks"
        }]
    });
    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

}
</script> 
<jsp:include page="../Common/footer.jsp" />
 