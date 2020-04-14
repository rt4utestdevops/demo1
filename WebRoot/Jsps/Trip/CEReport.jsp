<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
  <%
     String path = request.getContextPath();
     String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
     LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
     if(loginInfo==null){
     response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
     }
     else
     {
     %>
    <jsp:include page="../Common/header.jsp" />
    <script>$(document).prop('title', 'Trip Performance Report');
    </script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/css/tempusdominus-bootstrap-4.min.css">
    <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
    <link type="text/css" href="//gyrocode.github.io/jquery-datatables-checkboxes/1.2.11/css/dataTables.checkboxes.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js">
    </script>
    <script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js">
    </script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js">
    </script>
    <script src="../../Main/sweetAlert/sweetalert.min.js">
    </script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.21.0/moment.min.js">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/js/tempusdominus-bootstrap-4.min.js">
    </script>
    <script src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl" crossorigin="anonymous">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js">
    </script>    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js">
    </script>
    <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js">
    </script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css"/>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js">
    </script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js">
    </script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js">
    </script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js">
    </script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.bootstrap.min.css"/>
	<script type="text/javascript" src="https://gyrocode.github.io/jquery-datatables-checkboxes/1.2.11/js/dataTables.checkboxes.min.js">
    </script>
    <style>
      .caret {
        border-top:none;
      }
      .panel-primary {
        width: 50% !important;
        margin-left:25%;
      }
      .form-control {
        width: 40% !important;
        display: inline !important;
      }
      /*		.select2-container {
      width: 253px !important;
      }
      .select2-container--default .select2-selection--single
      {
      margin-left: 6px;
      }
	
      .multiselect-container>li>a {
      margin-left: -15px;
      } 
      */
      .multiselect-container  {
        top: 0px !important;
        overflow : scroll !important;
        height: 220px !important;
        min-width : 0px !important;
        width : 242px !important;
      }
      #page-loader{
        position:fixed;
        left: 0%;
        top: 35%;
        z-index: 1000;
        width:100%;
        height:100%;
        background-position:center;
        z-index:10000000;
        opacity: 0.7;
        filter: alpha(opacity=40);
        /* For IE8 and earlier */
      }
     
  
      
	  .input-group{
		  position: relative;
		  display:flex;		
		  width: 180px !important;
	  }
	  
	  .form-control .multiselect-search {
		  margin-left: -12px !important;
		  right: -12px !important;
	  }
	  .btn-default .multiselect-clear-filter{
		      margin-left: -42px !important;
	  }
	  .glyphicon {
		      top: 3px;
    left: -5px;
	  }
	  
	  .multiselect{
		  width:240px !important;
	  }
	  .multiselect-container li {
		  margin-left:-24px;
	  }
	  
	  .multiselect-container .filter{
		  margin-left:0px;
	  }
    </style>	
    <span  title="Report Columns Setting" style="float: right;margin-right: 1%;visibility: hidden;" >-
    </span>
    <button type="button" class="btn btn-info"  style="float: right;"  onClick="showUserTableSetting()" >User Settings
    </button>
    <div class="panel panel-primary">
      <div class="panel-heading">
        <h3 class="panel-title">Trip Performance Report
        </h3>
      </div>
      <div class="panel-body" style="padding-top: 0px;">
        <div class="col-sm-12 col-md-12 col-lg-12 padCols" style="padding: 1%;">
          <label for="customer" style="padding-right:7px; min-width: 100px !important">CUSTOMER
          </label>
          <select style="width:300px !important" class="form-control form-control-custom" id="customer" name="reportStart" >
          </select>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12 padCols" style="padding: 1%;">
          <label for="report-start-date" style=" min-width: 100px !important">START DATE
          </label>
          <input type="text" style="padding:6px;background-color: white;width:300px !important" id="report-start-date" class="form-control form-control-custom" name="reportStartDate" readonly="readonly"  >
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12 padCols" style="padding: 1%;">
          <label for="report-end-date" style=" min-width: 100px !important">END DATE
          </label>
          <input type="text" style="padding:6px;background-color: white;width:300px !important" id="report-end-date" class="form-control form-control-custom" name="reportEndDate" readonly="readonly" >
        </div>
        <div class="col-sm-4 col-md-4 col-lg-4" style="padding: 1%; margin-left: 44%;">
          <button id="submmitBtn" class="btn" style="background-color: DodgerBlue;" onclick="downloadExcel()">
            <i class="fa fa-download">
            </i> Export to Excel
          </button>
        </div>
      </div>
      <div class="alert alert-info" >
        <strong>Note:
        </strong> Maximum 31 days report can be downloaded.
        </br>
      Please make sure pop ups are enabled on your browser
    </div>
    <div id="disclimer" class="alert alert-warning" style="display:none">
      <strong>Info!
      </strong> Please wait your report is downloading
      . This will take few seconds to download.
    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
      <div id="page-loader" style="margin-top:10px;display:none;">
        <img src="../../Main/images/loading.gif" alt="loader" />
      </div>
    </div>
    <div id="columnSetting" class="modal-content modal fade" style="margin-top:0%;width:116%;margin-top:0%;top: -332px;height:531px;overflow:hidden !important">
      <div class="modal-header" style="display:flex;flex-direction:column;">
<div style="width:100%;margin-bottom:24px;">
<h4 id="columnSettingTitle" class="modal-title" style="text-align:left; margin-left:10px; font-weight: bold;">Column Settings</h4></div>
        <div class="row" style="margin-left:0px;">

          <div class="col-lg-3">
            <label>Customer:
            </label>
          </div>
<div class="col-lg-6">
              <select class="form-control" id="custName"  multiple="multiple" style="display: none !important;margin-left:24px !important;height:32px;">
              </select>
            </div>
            <div class="col-lg-3">
              <button id="viewButtonId" style="margin-left:24px;height:32px;" type="button" class="btn btn-primary" onclick="getcolumns()">View
              </button>
            </div>								
       </div>
        &nbsp;&nbsp;
        &nbsp;&nbsp;
        <!--                                <h4 id="columnSettingTitle" class="modal-title" style="text-align:left; margin-left:10px;">Column Settings</h4>-->
      </div>
      <div class="modal-body" style="overflow-y: auto;">
        <div class="row">
          <div class="col-lg-12">
            <div class="col-lg-12" style="border:none;">
              <table id="alertEventsTable" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                <thead>
                  <tr>
                    <th>Select All
                    </th>
					<th>Customer Name
                    </th>
                    <th>Sl. No.
                    </th>
                    <th>Indent Number
                    </th>
                    <th>Placement Date
                    </th>
                    <th>Trip Number
                    </th>
                    <th>Customer Ref. No.
                    </th>
                    <th>Placement Type
                    </th>
                    <th>Client Name
                    </th>
                    <th>Status
                    </th>
                    <th>Origin
                    </th>
                    <th>Touch Point 1
                    </th>
                    <th>Touch Point 2
                    </th>
                    <th>Touch Point 3
                    </th>
                    <th>Touch Point 4
                    </th>
                    <th>Destination
                    </th>
                    <th>Route
                    </th>
                    <th>Vehicle Size
                    </th>
                    <th>Vehicle Type
                    </th>
                    <th>Vehicle ID
                    </th>
                    <th>Scheduled Report Date/Time
                    </th>
                    <th>Actual Report Date/Time
                    </th>
                    <th>Placement deviation
                    </th>
                    <th>Placement Status
                    </th>
                    <th>Scheduled Dep Date/Time
                    </th>
                    <th>Actual Dep Date/Time
                    </th>
                    <th>Dispatch Variation
                    </th>
                    <th>Dispatch Status
                    </th>
                    <th>Loading Detention
                    </th>
                    <th>Touchpoint 1 Arrival
                    </th>
                    <th>Touchpoint 1 Departure
                    </th>
                    <th>Touch point1 Detention
                    </th>
                    <th>Touchpoint 2 Arrival
                    </th>
                    <th>Touchpoint 2 Departure
                    </th>
                    <th>Touch point2 Detention
                    </th>
                    <th>Touchpoint 3 Arrival
                    </th>
                    <th>Touchpoint 3 Departure
                    </th>
                    <th>Touch point3 Detention
                    </th>
                    <th>Estimated Arrival
                    </th>
                    <th>Actual Arrival
                    </th>
                    <th>Trip Closure
                    </th>
                    <th>Unloading Detention
                    </th>
                    <th>AgreedTAT -incl.SH Stoppages
                    </th>
                    <th>OverallTAT -incl.SH Stoppages
                    </th>
                    <th>Uncontrollable TAT
                    </th>
                    <th>Actual TAT
                    </th>
                    <th>Delay
                    </th>
                    <th>Transit Performance
                    </th>
                    <th>Delay Bucket
                    </th>
                    <th>Delay Sub Bucket
                    </th>
                    <th>Delay Remarks
                    </th>
                    <th>Actual CHDetention
                    </th>
                    <th>Planned CHDetention
                    </th>
                    <th>Avg Speed
                    </th>
                  </tr>
                </thead>
                <tbody>  
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer" style="text-align: center; height:52px;">
        <input onclick="createOrUpdateListViewColumnSetting()" type="button"  class="btn btn-success" disabled="true" id="columnSettingSave" value="Save" />
        <button type="reset" class="btn btn-danger" data-dismiss="modal">Close
        </button>
      </div>
    </div>
    </div>
  <script>
    var custId = "ALL";
    var custcombo = "";
    var tripcombo = "";
    var custArr="";
    var pageName = "CEREPORT";
    var columns = [
      "Select All",
	  "Customer Name",
      "Sl. No.",								
      "Indent Number",										
      "Placement Date",										
      "Trip Number",											
      "Customer Ref. No.",											
      "Placement Type",										
      "Client Name",											
      "Status",										
      "Origin",											
      "Touch Point 1",											
      "Touch Point 2",											
      "Touch Point 3",											
      "Touch Point 4",											
      "Destination",											
      "Route",											
      "Vehicle Size",											
      "Vehicle Type",											
      "Vehicle ID",										
      "Scheduled Report Date/Time",										
      "Actual Report Date/Time",											
      "Placement deviation",											
      "Placement Status",											
      "Scheduled Dep Date/Time",											
      "Actual Dep Date/Time",											
      "Dispatch Variation",										
      "Dispatch Status",											
      "Loading Detention",											
      "Touchpoint 1 Arrival",											
      "Touchpoint 1 Departure",										
      "Touch point1 Detention",										
      "Touchpoint 2 Arrival",		
      "Touchpoint 2 Departure",										
      "Touch point2 Detention",									
      "Touchpoint 3 Arrival",		
      "Touchpoint 3 Departure",										
      "Touch point3 Detention",										
      "Estimated Arrival",											
      "Actual Arrival",										
      "Trip Closure",											
      "Unloading Detention",											
      "AgreedTAT -incl.SH Stoppages",											
      "OverallTAT -incl.SH Stoppages",											
      "Uncontrollable TAT",										
      "Actual TAT",										
      "Delay",											
      "Transit Performance",											
      "Delay Bucket",											
      "Delay Sub Bucket",											
      "Delay Remarks",
      "Actual CHDetention",
      "Planned CHDetention",
      "Avg Speed"
    ];
    let alertEventsTable;
    let rows = [];
    let slNo = 0;
    $(document).ready(function() {
      alertEventsTable = $('#alertEventsTable').DataTable({
        scrollX: true,
		scrollY: "200px",
        dom: 'Bfrtip',
		paging:false,
		buttons: ['excel', 'pdf'],
		searching: false
      }
                                                         );
      var todayTimeStamp = +new Date;
      // Unix timestamp in milliseconds
      var oneDayTimeStamp = 1000 * 60 * 60 * 24;
      // Milliseconds in a day
      var diff = todayTimeStamp - (oneDayTimeStamp * 7);
      var yesterdayDate = new Date(diff);
      var today = new Date(todayTimeStamp);
      var date1 = new Date();
      date1.setFullYear(today.getFullYear(), (today.getMonth()), today.getDate());
      var date2 = new Date();
      date2.setFullYear(yesterdayDate.getFullYear(), (yesterdayDate.getMonth()), yesterdayDate.getDate());
	  $("#report-start-date").datepicker({ dateFormat: "dd/mm/yy"}).datepicker("setDate", date2);
	  $("#report-end-date").datepicker({ dateFormat: "dd/mm/yy"}).datepicker("setDate", date1);
      $("#report-start-date").datepicker({
        dateFormat: 'dd/mm/yy',
        onSelect: function(selected, event) {
          $("#report-end-date").datepicker("option", "minDate", selected);
          setTimeout(function() {
            $("#report-end-date").datepicker('show');
          }
                     , 10);
        }
      }
                                        );
      $("#report-end-date").datepicker({
        dateFormat: 'dd/mm/yy',
        onSelect: function(selected) {
          $("#report-start-date").datepicker("option", "maxDate", selected)
        }
      }
                                      );
    }
                     );
    getCustomer();
    function getCustomer(){
      var cusAarray=[];
      var cus = [];
      $.ajax({
        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripCustomerNames',
        success: function(result) {
          cus = JSON.parse(result);
          $('#customer').append($("<option></option>"));
          for (var i = 0; i < cus["customerRoot"].length; i++) {
            cusAarray.push(cus["customerRoot"][i].CustName);
            $('#customer').append($("<option></option>").attr("value",cus["customerRoot"][i].CustId).text(cus["customerRoot"][i].CustName));
          }
          $("#customer").select2();
          $("#customer").val(0).trigger('change');
        }
      }
            );
    }
    getTripCustomerType();
    function getTripCustomerType() {
      for (var i = document.getElementById("custName").length - 1; i >= 1; i--) {
        document.getElementById("custName").remove(i);
      }
      $.ajax({
        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripCustomerNames',
        success: function(result) {
          var addcustList = JSON.parse(result);
          for (var i = 0; i < addcustList["customerRoot"].length; i++) {
            if(addcustList["customerRoot"][i].CustId !='0'){
              $('#custName').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
            }
          }
          $('#custName').multiselect({
            nonSelectedText:'Select Customer',
            includeSelectAllOption: false,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            numberDisplayed: 1,
			onDropdownHide: function() { $('button.multiselect-clear-filter').click(); }
          }
                                    );
          $("#custName").multiselect('deselectAll', false);
          $("#custName").multiselect('updateButtonText');
        }
      }
            );
    }
    var combo;
    $('#custName').on('change', function(e) {
      var custcombo = "";
      var custselected =$("#custName option:selected");
      custselected.each(function () {
        custcombo += $(this).val() + ",";
	  }
                       );
      combo= custcombo.split(",").join(",");
	  custmerlength= custcombo.split(",");
	  if((custmerlength.length)-1>10){
	   $('option[value="' + $(this).val().toString().split(',')[10] + '"]').prop('selected', false);
		  sweetAlert("Maximum selection reached");
        return;
	  }
	  
	  
      var custselected =$("#custName option:selected");
    }
    );
    function downloadExcel() {
      var customer=document.getElementById('customer').value;
      var startDate = document.getElementById('report-start-date').value;
      var endDate = document.getElementById('report-end-date').value;
      var dateRange = startDate + '-' + endDate;
      var dateDiff = monthValidation(startDate, endDate);
      var dayDiff = dateValidation(startDate, endDate);
      if (!dayDiff) {
        sweetAlert("Start Date should be less than End Date");
        return;
      }
      if (!dateDiff) {
        sweetAlert("Date Range should not exceeds 31 days");
        return;
      }
	  if(customer==0)
	  {
		sweetAlert("Please select a valid customer");
        return;  
	  }
      else {
        $('#submmitBtn').prop('disabled', true);
        $('#report-start-date').prop('disabled', true);
        $('#report-end-date').prop('disabled', true);
        document.getElementById("page-loader").style.display = "block";
        document.getElementById("disclimer").style.display = "block";
        $.ajax({
          type: "POST",
          url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getCEReport',
          data: {
            startDate: startDate.split("/").reverse().join("-"),
            endDate: endDate.split("/").reverse().join("-"),
            customer:customer
          }
          ,
          success: function(responseText) {
            document.getElementById("page-loader").style.display = "none";
            document.getElementById("disclimer").style.display = "none";
            $('#submmitBtn').prop('disabled', false);
            $('#report-start-date').prop('disabled', false);
            $('#report-end-date').prop('disabled', false);
            if (responseText != "Failed to Download Report") {
              window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
              //  document.getElementById("page-loader").style.display="none";
            }
            else {
              //document.getElementById("page-loader").style.display="none";
            }
          }
        }
              );
      }
    }
    function dateValidation(date1, date2) {
      var dd = date1.split("/");
      var ed = date2.split("/");
      var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
      var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
      if (endDate >= startDate) {
        return true;
      }
      else {
        return false;
      }
    }
    function monthValidation(date1, date2) {
      var dd = date1.split("/");
      var ed = date2.split("/");
      var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
      var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
      var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
      var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
      if (daysDiff <= 30) {
        return true;
      }
      else {
        return false;
      }
    }
    function getcolumns()
    {
      tripcombo="";
      var tripSelected =$("#custName option:selected");
      tripSelected.each(function () {
        tripcombo += $(this).val() + ",";
      }
                       );
      custArr="";
      custArr= tripcombo.split(",").join(",");
      custlength= tripcombo.split(",");
      if(custArr=='')
      {
        sweetAlert("Please select atleast one customer");
        return;
      }
      else if((custlength.length)-1>10)
      {
        sweetAlert("Maximum selection reached");
        return;
      }
      rows=[];
      var unique=custArr.split(",");
      $.ajax({
        url: "<%=request.getContextPath()%>/TripCreatAction.do?param=getColumnSetting",
        type: 'POST',
        data: {
          pageName: pageName,
          custArr:custArr
        }
        ,
        "dataSrc": "columnSettingsRoot",
        success: function(result) {
          var checkstatus = "unchecked";
          results = JSON.parse(result);
          rows=[];
          for(var j = 0; j< results['columnSettingsRoot'].length; j++)
          {
            let row=[];
            if ((Number(results['columnSettingsRoot'][j].length) == Number(0))) {
              setDefaultUserColumnSetting(j,row,rows);
              columnSettingAddOrModify = "ADD";
            }
            else{
              setUpdateColumnSetting(results,j,row,rows);
              columnSettingAddOrModify = "UPDATE";
            }
          }
          document.getElementById("columnSettingSave").disabled = false;
        }
      }
            );
    }
    var count=0;
    function showUserTableSetting() {
      document.getElementById("columnSettingSave").disabled = true;
      $('#columnSetting').modal('show');
      $('#sortable').empty();
      getTripCustomerType();
      $('#alertEventsTable').DataTable().clear().draw();
	   $('button.multiselect-clear-filter').click();
    }
    function setUpdateColumnSetting(results,j,row,rows)
    {
		selectAllStatus = "checked";
		for (var x = 0; x < results['columnSettingsRoot'][j].length; x++) 
      {
        if (results['columnSettingsRoot'][j][x].visibility == 'false') {
          selectAllStatus = "unchecked";
		  break;
        }
      }
      row.push('<input name=columnSetting id= "checkboxSelectAll'+j+'" onchange="selectAll('+j+')" type="checkbox"  '+selectAllStatus+'  value="Select All" />');
	  
	  $("#custName option:selected").each(function () {
		   var $this = $(this);
		   if ($this.length && $this.val() === results['columnSettingsRoot'][j][0].cusName.toString()) { 
			row.push($this.text());
		   }
		});
      for (var i = 0; i < results['columnSettingsRoot'][j].length; i++) 
      {
        if (results['columnSettingsRoot'][j][i].visibility == 'true') {
          checkstatus = "checked";
        }
        else {
          checkstatus = "unchecked";
        }
        row.push('<input name=columnSetting id= "checkbox' + j + i + '" onchange="selectcheckbox('+ j +')" type="checkbox" ' + checkstatus + ' value="' + results['columnSettingsRoot'][j][i].id +","+results['columnSettingsRoot'][j][i].cusName+","+results['columnSettingsRoot'][j][i].columnName+ '" />');
        
      }
      rows.push(row);
      alertEventsTable.clear();
      alertEventsTable.rows.add(rows).draw();
    }
    function setDefaultUserColumnSetting(j,row,rows) {
      var unique=custArr.split(",");
      row.push('<input name=columnSetting id= "checkboxSelectAll'+j+'" onchange="selectAll('+j+')" type="checkbox"  checked value="Select All" />');
	  $("#custName option:selected").each(function () {
		   var $this = $(this);
		   if ($this.length && $this.val() === unique[j]) { 
			row.push($this.text());
		   }
		});
      for (var i = 2; i <columns.length; i++) {
        checkstatus = "checked";
        row.push('<input name=columnSetting id= "checkbox' + j + i + '" onchange="selectcheckbox('+ j +')" type="checkbox" ' + checkstatus + ' value="' + columns[i]+","+unique[j]+ '" />');
      }
      rows.push(row);
      alertEventsTable.clear();
      alertEventsTable.rows.add(rows).draw();
    }
    // function selectAll(j){
      // for (var i = 0; i < columns.length-1; i++) {
        // if($("#checkboxSelectAll" + j).is(":checked")){
          // $("#checkbox" + j + i).attr("checked", true);
        // }
        // else{
          // $("#checkbox" + j + i).attr("checked", false);
        // }
      // }
    // }
	function selectcheckbox(z)
	{
		$("#checkboxSelectAll" + z).prop('checked',true);	
		for(var x=0;x<columns.length-1;x++)
		{
		  if($("#checkbox" + z + x).is(":unchecked")){
		  $("#checkboxSelectAll" + z).prop('checked',false);
        }
					
		}
	}
	 function selectAll(j){
      //for (var i = 0; i < columns.length-1; i++) {
      for (var i = 0; i < columns.length; i++) {
        if($("#checkboxSelectAll" + j).is(":checked")){
		  $("#checkbox" + j + i).prop('checked',true);
        }
        else{
			$("#checkbox" + j + i).prop('checked', false);
        }
      }
    }
    function createOrUpdateListViewColumnSetting() {
      if (columnSettingAddOrModify == "ADD") {
        createListViewColumnSetting();
      }
      else {
        updateListViewColumnSetting();
      }
    }
    function createListViewColumnSetting() {
      let row = [];
      let rowsToSave = [];
      for(var j = 0; j < alertEventsTable.rows().count(); j++)
      {
        for (var i = 2; i < columns.length ; i++) {
          let rowJSON = {
            columnName: $("#checkbox" + j + i).val(),
            visibility: $("#checkbox" + j + i).is(':checked')? true: false
          }
          row.push(rowJSON);
		  console.log(row);
        }
        rowsToSave.push(row);
      }
      custArr= tripcombo.split(",").join(",");
      if(custArr=='')
      {
        sweetAlert("Please select atleast one customer");
        return;
      }
      var columnSettings = JSON.stringify(row);
      $.ajax({
        url: "<%=request.getContextPath()%>/TripCreatAction.do?param=createColumnSettings",
        type: 'POST',
        data: {
          columnSettings: columnSettings,
          pageName: pageName,
          custArr:custArr
        }
        ,
        success: function(result) {
          document.getElementById("columnSettingSave").disabled = true;
          setTimeout(function() {
            sweetAlert("Saved Successfully");
            $('#columnSetting').modal('hide');
          }
                     , 1000);
        }
      }
            );
    }
    function updateListViewColumnSetting() {
      let row = [];
      let rowsToSave = [];
      for(var j = 0; j < alertEventsTable.rows().count(); j++)
      {
        //let row = [];
        for (var i = 0; i < 51 ; i++) {
          let rowJSON = {
            id: $("#checkbox" + j + i).val(),
            visibility: $("#checkbox" + j + i).is(':checked')? true: false
          }
          row.push(rowJSON);
        }
        rowsToSave.push(row);
      }
      custArr= tripcombo.split(",").join(",");
      if(custArr=='')
      {
        sweetAlert("Please select atleast one customer");
        return;
      }
      var columnSettings = JSON.stringify(row);
      $.ajax({
        url: "<%=request.getContextPath()%>/TripCreatAction.do?param=updateColumnSetting",
        type: 'POST',
        data: {
          columnSettings: columnSettings,
          pageName: pageName,
          custArr:custArr
        }
        ,
        success: function(result) {
          document.getElementById("columnSettingSave").disabled = true;
          setTimeout(function() {
            sweetAlert("Saved Successfully");
            $('#columnSetting').modal('hide');
          }
                     , 1000);
        }
      }
            );
    }
  </script>
  <jsp:include page="../Common/footer.jsp" />
  <%}%>
