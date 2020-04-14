<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	
if(loginInfo != null){
			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>

<!doctype html>
<html>

<head>
    <title></title>

   
    
  	
	<link href="../../Main/Js/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	
	
	   <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	   <script src="../../Main/Js/jquery.min.js"></script>
       <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
	   <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.16.0/jquery.validate.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.16.0/additional-methods.js"></script>
	<script src="../../Main/Js/Common.js"></script>
	 <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
    #title
    {
    font-weight: 600;
    font-size: 25px;
    color: dodgerblue;
    }
    
   .container{
	margin-left: inherit;
    margin: 10px;
    border: solid 1px #ddd;
    padding-top: 9px;
    }
   
    </style>
	
</head>

<body onload="LoadData()">
   <div class="container">

<p><strong style="margin-left: 10px;">Start Date: </strong><input type="text" id="datepickerstart">
<strong style="margin-left: 40px;">End Date: </strong><input type="text" id="datepickerend">
<strong style="margin-left: 40px;">Select City: </strong><select name="size" id="groupName"><option id="">All</option></select>
<input style="margin-left: 50px;" type="button" value="Submit" onclick="LoadData()">
<input style="margin-left: 50px;" type="button" title="Report will be generated for the selected City and Date range" value="Generate Report" onclick="gotoReportPage()"></p>
 <div class="col-lg-12">
        <div class="col-lg-8">
            <div class="panel panel-default">
                <div class="panel-heading" id="title">
                  HB Analysis Report
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>SLNO</th>
                                <th>REGISTRATION_NO</th>
                                <th>COUNT</th>
                                 <th>AVERAGE(mm:ss)</th>
                            </tr>
                        </thead>

                    </table>
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>

    </div>

</div>



   
  <script>
var reportWindow;
	var groupId;
	var records = '';
 	$(function () {
 		var currentDate = new Date();
 		var lastWeek = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - 7);
 		$("#datepickerstart" ).datepicker({ dateFormat: "dd-mm-yy" }).val();
 		$("#datepickerstart").datepicker( "setDate" , lastWeek );
		$("#datepickerend").datepicker({ dateFormat: "dd-mm-yy" , maxDate: '0'}).val();
		$("#datepickerend").datepicker( "setDate" , currentDate );
		
		$.ajax({
	         url: '<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getGroupNames',
	         success: function(response) {
	             groupNameList = JSON.parse(response);
	             var $groupName = $('#groupName');
	             $.each(groupNameList, function() {
	                 $('<option id=' + this.cityId + '>' + this.cityName + '</option>').appendTo($groupName);
	             });
	         }
	     });
	     $('#groupName').change(function() {
	         groupId = $('option:selected').attr('id');
	        LoadData();
	     });
	});
	
	function gotoReportPage(){
			var startDate = $("#datepickerstart").val();
			var endDate = $("#datepickerend").val();
			var groupId = $('option:selected').attr('id');
			var groupName = $('#groupName').find(":selected").text();
			if(records == 'empty'){
				alert('No records found!')
				return;
			}else{
				window.open("<%=request.getContextPath()%>/ExcelForHBAnalysisGraph?startDate="+startDate+"&endDate="+endDate+"&groupId="+groupId+"&groupName="+groupName);
			}
		}
	
	
 function LoadData() {
  if ($.fn.DataTable.isDataTable('#example')) {
            $('#example').DataTable().destroy();
        }
           var sDate = $("#datepickerstart").val();
    		var eDate = $("#datepickerend").val();
    		var groupId = $('option:selected').attr('id');
     var table = $('#example').DataTable({
         "ajax": {
             "url": "<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getcountHb",
             "data": {
                 cityId: groupId,
				 startDate:sDate,
				 endDate:eDate
             },
             "dataSrc": "hbCountReport"
         },
         "bLengthChange": false,
         "columns": [{
             "data": "slno"
         }, {
             "data": "regNo"
         }, {
             "data": "count"
         }, {
             "data": "totalAvginMins"
         }]
     });

 }
  </script>
  
 </body>
</html>
