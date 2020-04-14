<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if(loginInfoBean != null){
	  //Do nothing
	}
	else 
	{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>DTC Code Details</title>
  	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" href="../../Main/resources/css/obd/circle.css" type="text/css"></link>
  <link rel="stylesheet" href="../../Main/resources/css/obd/custom.css" type="text/css"></link>
  <link href="../../Main/Js/bootstrap.min.css" rel="stylesheet"></link>
	<script src="../../Main/Js/jquery.min.js"></script>
	<script src="../../Main/Js/bootstrap.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
	<link  rel="stylesheet" href="https://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css">
	<script src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<style>
.jumbotron{padding-left:10px;padding-top:2px;color:inherit;padding-bottom: 6px;margin-bottom: 0px;background-color:#eee}
.jumbotron p {
    margin-bottom: 0px;
    font-size: 0.8em;
    font-weight: 200;
    padding-left:10px;
    padding-top:5px;
}
.container{
	padding-top: 10px;
}
.values{
	font-weight: inherit;
    padding-left: 10px;
}
.tableHeader {
	text-decoration: underline;
	font-style: inherit;
	font-weight: bolder;
}
.dataTables_scrollHead{
	background: silver;
}
#errorTableId td{
	color: rgba(239, 3, 3, 0.99);
}
.col-sm-4{
	padding-left: 0px;
}
.container{
width: 80%;
}

.dataTables_wrapper{
width:90%;
}
.dataTables_scrollBody{
 height:72vh;
}
</style>

<body onload = "LoadData()">
<button onclick="gotoDashboard()">Back</button>
<form style="display: hidden" action="<%=basePath+"Jsps/OBD/VehicleDiagnosticView.jsp"%>" method="POST" id="vehicleNoForm">
  <input type="hidden" id="vehicleNoId" name="vehicleNoId" value=""/>
  <input type="hidden" id="alertTypeId" name="alertTypeId" value=""/>
  <input type="hidden" id="alertValueId" name="alertValueId" value=""/>
  <input type="hidden" id="pageId" name="pageId" value=""/>
</form>
<div class="jumbotron text-left">
  <h4>DTC Code Details</h4> 
</div>

<div class = "outerLayer"> 
<center>
	<table  id="tableId" class="table">
  	<thead>
    	<tr>
      	<th class="sorting_desc">SL. No</th>
      	<th>Vehicle No</th>
      	<th>DTC Code</th>
      	<th>Code Description</th>
      	<th>GPS TIME</th>
      	<th>Vehicle Type</th>
      	<th>Vehicle Model</th>
      	<th>Remarks</th>
    	</tr>
  	</thead>
	</table>
</center>
</div>
<script language="javascript">
function gotoDashboard(){
	  window.location.href="<%=basePath+"Jsps/OBD/OBD_Dashboard.jsp"%>";
	 }
	 
	 function LoadData(){
		 <% String errorType="",errorType1=""; if(request.getParameter("errorType")!=null){
			 errorType="&errorType="+request.getParameter("errorType");
			 errorType1=request.getParameter("errorType");
		 }%>
	 	var table = $('#tableId').DataTable({
	 		"ajax": {
            "url": "<%=request.getContextPath()%>/OBDAction.do?param=getErrorCodeDetails"+"<%=errorType%>",
            "dataSrc": 'errorCodeDetailsRoot'
        }, 
        "autoWidth": true,
  	    "scrollX": true,
      	"bFilter": true,
   		"bRetrieve":true,
   		"bStateSave": true,
   		"bPaginate": false,
   		"info":     false,
   		"height": '70%',
   		"order": [[ 1, "asc" ]],
   		"columnDefs": [
   		            { "width": "13%", "targets": 5},
   		         	{ "width": "2%", "targets": 1}
   		          ],
        "columns": [ {
                "data": "slNo"
            }, {
                "data": "vehicleNo"
            }, {
                "data": "errorCode"
            }, {
                "data": "codeDesc"
            },{
                "data": "gpsTime"
            }, {
                "data": "vehType"
            },{
                "data": "vehModel"
            },{
                "data": "remarks"
            }
        ]
	 	});
	 	$('#tableId').on('click', 'td', function(event) {
	 		 var columnIndex = table.cell(this).index().column;
	 	       var aPos = $('#tableId').dataTable().fnGetPosition(this);
	 	       var data = $('#tableId').dataTable().fnGetData(aPos[0]);
	 	       var uid = (data['vehicleNo']);
	 	       $("#vehicleNoId").val(uid);
	 	       $("#alertTypeId").val("errorType");
	 	       $("#alertValueId").val("<%=errorType1%>");
	 	       $("#pageId").val("ErrorCodeDetails.jsp");
			    $("#vehicleNoForm").submit();
	 	});
	 	$.fn.dataTable.ext.errMode = 'throw';
	 }
		
</script>
</body>
</html>