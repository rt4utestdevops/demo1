<%@ page language="java" import="java.util.*,java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
   <title>SERP DASHBOARD</title>
	
	
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	
	<script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css">
	
  <link rel="stylesheet "href="../../Main/modules/sandMining/dashBoard/bootstrap/css/bootstrap.min.css" type="text/css"></link>
 
	
	<style type="text/css">
		table tr td{
		 	color: brown;
		    font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif;
		    font-style: normal;
		    font-weight: normal;
		    font-size:10px;
		}
		.odd:hover td{
			color:#57DC57!important
		}
		.even:hover td{
			color:#57DC57!important
		}
		table th{
			color:#CB9F7B!important;
		}
		.odd td{
			color:#888484!important;
			font-size: 12px;
		}
		.even td{
			color:#888484!important;
			font-size: 12px;
		}
		.row{
			max-width: 100%;
			margin:0px;
			padding: 0px;
		}
		tr td a {
			position: relative;
			top: 0px;
			bottom: 0px;
			left: 0px;
			right: 0px;
		}
	</style>
</head>

<body onload="LoadData()">
<div class="container-fluid" >
	<div class="col-md-12 col-sm-12">
			<div class="panel panel-default">
			<!-- Default panel contents -->
				
				  <!-- Table -->
				 <table class="table table-hover" id="example" class="display" cellspacing="0" width="100%">
				  <thead style="font-size:20px;background: #F5F5F5 !important;">
				  <tr>
					<th>Vehicle No</th>
					<th>Reach Name</th>
					<th>Reach Entry Date</th>
					<th>Reach Exit Date</th>
					<th>Detention</th>
				  </tr>
				  </thead>
				 </table>
			 </div>
		</div>
	<div class="col-md-12 col-sm-12">
		<a href="/Telematics4uApp/Jsps/SandMining/SandMiningDashboard.jsp">  
		<button style="float:right;">DASHBOARD</button>
		</a>
	
	
	</div>
	</div>

	
	<script>
var table;
	
function LoadData() {
	  if(table != undefined){
	  	table.destroy();
	  }
	  table = $('#example').DataTable({
			           "ajax": {
			           "url": "<%=request.getContextPath()%>/DashboardElementAction.do?param=unAuthourizedReachEntry",
			           "dataSrc": "unAuthourizedReachEntryRoot"
			           },
           
    		       "columns": [
						     {"data":"vehicleNo"},
							 {"data":"reachName"},
							 {"data":"reachEntryDate"},
							  {"data":"reachExitDate"},
							 {"data":"detention"}
							]
						
		
	    });

}
	
</script>
</body>
</html>
