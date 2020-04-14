<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="t4u.functions.OBDFunctions"%>
<%@ page import="t4u.beans.LoginInfoBean" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
if(loginInfoBean == null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}else {
 	int systemId = loginInfoBean.getSystemId();
 	String vehicleMake = "HYUNDAI";
 	String vehicleModel = "1874";
 	String vehicleModelName = "XCENT";
 	String vehicleNo = "KA 05 AG 5562";
 	String pageName = "";//request.getParameter("pageId");
 	String alertTypeId = "";//request.getParameter("alertTypeId");
 	String alertValueId = "";//request.getParameter("alertValueId");
	OBDFunctions obdFunc = new OBDFunctions();
	ArrayList<Object> vehicleDetails = null;
	
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Vehicle Health Diagnostic View</title>
  	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link href="../../Main/Js/bootstrap.min.css" rel="stylesheet">
	<script src="../../Main/Js/jquery.js"></script>
	<script src="../../Main/Js/jquery.min.js"></script>
	<script src="../../Main/Js/bootstrap.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
	<link  rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css">
	<script src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<style>
.container-vd{
	padding-right: 5px;
    padding-left: 5px;
    margin-right: 5px;
    margin-left: 5px;
    padding-top: 5px;
}
.jumbotron{
	padding-left:15px;
	padding-top:2px;
	color:inherit;
	padding-bottom: 6px;
	margin-bottom: 0px;
	background-color:#eee;
}
.jumbotron p {
    margin-bottom: 0px;
    font-size: 18px;
    font-weight: 200;
    padding-left:5px;
    padding-top:5px;
}
.controls.readonly {
	padding-top: 5px;
}
.values{
	font-weight: inherit;
    padding-left: 15px;
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
	color: #BA1010;
}
.col-sm-4{
	padding-left: 0px;
}
.important{
color:red;
}
#chart_div{
	display: none;
}
#chart_div2{
	display:none;
}
</style>

<body onload = "LoadData()">
<div class="jumbotron text-left">
  <p>Vehicle Health Diagnostic View</p> 
</div>
<div class="container-vd">
  <button type="button" class="btn btn-default btn-md" id="backButtonId">Back</button>
  <button type="button" class="btn btn-default btn-md" id="refreshId" onclick="LoadData()">Refresh</button>
</div>
<div class="container-vd">
 	<div class="col-sm-4">
     <div class ="controls.readonly" >
     <label class="control-label">Vehicle No :   </label> 
    	<label class = "values" id="vehicleNoId"> </label> 
    </div>
    </div>
    <div class="col-sm-4">
      <div class ="controls.readonly" >
     <label class="control-label">Vehicle Make :   </label> 
    	<label class = "values" id="vehicleMakeId"> </label> 
    </div>
    </div>
    <div class="col-sm-4">
       <div class ="controls.readonly" >
     <label class="control-label">Vehicle Model :   </label> 
    	<label class = "values" id="vehicleModelId">  </label> 
    </div>
    </div>
</div>
<div class = "container-vd">
	<div class="tableHeader text-left">
  		<p>Vehicle Health Assessment : </p> 
	</div>

	<table  id="tableId" class="stripe" cellspacing="0" width="100%" >
  	<thead>
    	<tr>
      	<th class="sorting_desc">Sr. No</th>
      	<th>Parameter Name</th>
	  	<th>Unit</th>
      	<th>Actual Value</th>
      	<th>Threshold Range</th>
      	<th>Remarks</th>
    	</tr>
  	</thead>
	</table>
</div>
<div class = "container-vd">
	<div class="col-sm-6">
		<div id="chart_div" style="width: 100%; height: 500px;"></div>
	</div>
	<div class="col-sm-6">
		<div id="chart_div2" style="width: 100%; height: 500px;"></div>
	</div>
</div>
<div class = "container-vd">
	<div class="tableHeader text-left">
  		<p>DTC Error Codes : </p> 
	</div>

	<table  id="errorTableId" class="stripe" cellspacing="0" width="100%" >
  	<thead>
    	<tr>
      	<th>Sr. No</th>
      	<th>Code ID</th>
	  	<th>Code Description</th>
      	<th>Code Generated D & T</th>
      	<th>Remarks</th>
    	</tr>
  	</thead>
	</table>
</div>
<div class = "container-vd">
<p></p>
</div>
<script language="javascript">
	 $('#vehicleNoId').text('<%=vehicleNo%>');
	 $('#vehicleMakeId').text('<%=vehicleMake%>');
	 $('#vehicleModelId').text('<%=vehicleModelName%>');
	 
	 function LoadData(){
	 	var table = $('#tableId').DataTable({
	 		"ajax": {
            "url": "<%=request.getContextPath()%>/OBDAction.do?param=getVehicleDiagnosticDeatails",
            "dataSrc": "vehicleDiagnosisDetailsRoot",
            "data":{
            vehicleNo: '<%=vehicleNo%>',
            vehicleModel: '<%=vehicleModel%>'
            },
        },     
        "autoWidth": true,
  	    "scrollX": true,
      	"bFilter": true,
   		"bRetrieve":true,
   		"bStateSave": true,
   		"bPaginate": false,
   		"info":     false,
        "columns": [ {
                "data": "slNoIndex"
            }, {
                "data": "parameterNameIndex"
            }, {
                "data": "unitIndex"
            }, {
                "data": "actualValueIndex"
            }, {
                "data": "thresholdrangeIndex"
            },{
                "data": "remarksIndex"
            }
        ],
        "createdRow": function( row, data, dataIndex ) {
<!--    		if ( data["actualValueIndex"] > data["thresholdrangeIndex"] ) {-->
<!--     	 		$(row).addClass( 'important' );-->
<!--    		}-->
  		}
	 	});
	 	$('#tableId').closest('.dataTables_scrollBody').css('max-height', '300px');
     	$('#tableId').DataTable().draw();
	 	$.fn.dataTable.ext.errMode = 'throw';
		 //********Fuel Level Chart
		 google.charts.load('current', {packages: ['corechart', 'line']});
	     google.charts.setOnLoadCallback(drawFuelChart);
	
	     function drawFuelChart() {
	     var finalLevelData = [];
	     var finalRow = [];
<!--	     	$.ajax({-->
<!--	     		url: '<%=request.getContextPath()%>/OBDAction.do?param=getFuelLevelDetails',-->
<!--        		success: function(result) {-->
<!--            	fuelDetails = JSON.parse(result);-->
<!--            	var fuelData = new google.visualization.DataTable();-->
<!--		    fuelData.addColumn('string', 'X');-->
<!--		    fuelData.addColumn('string', 'Fuel Level');-->
<!--            var options = {-->
<!--	        	title: 'Fuel Level',-->
<!--	          	hAxis: {title: 'Date', format:'d/M/yy'},-->
<!--	          	vAxis: {title: 'Ltr',format: '##.######', min: 0, max: 6}-->
<!--	       	};-->
<!--	       	var array = [];-->
<!--	       	//alert(fuelDetails["fuelDetailsRoot"][1][1]);-->
<!--            	for (var i = 0; i < fuelDetails["fuelDetailsRoot"].length; i++) {-->
<!--	                         array = [];-->
<!--	                         array.push(fuelDetails["fuelDetailsRoot"][i][0]);-->
<!--	                         array.push(fuelDetails["fuelDetailsRoot"][i][1]);-->
<!--	                         fuelData.addRow(array);-->
<!---->
<!--	                         var chart = new google.visualization.LineChart(document.getElementById('chart_div'));-->
<!--	       							chart.draw(fuelData, options);-->
<!--	                     }-->
<!--	     		}	-->
<!--	     		})-->
	       
		}
		//*********Voltage Chart
		google.charts.load('current', {'packages':['corechart']});
	    google.charts.setOnLoadCallback(drawVoltageChart);
	
	     function drawVoltageChart() {
	     	var data = google.visualization.arrayToDataTable([
	        	['Date', 'Voltage'],
	          	['15/3/2017',  7],
	          	['16/3/2017',  2],
	          	['17/3/2017',  8],
	          	['18/3/2017',  2],
	          	['19/3/2017', 12]
	       	]);
			var options = {
	        	title: 'Battery Voltage',
	          	hAxis: {title: 'Date',  titleTextStyle: {color: '#100'}},
	          	vAxis: {title: 'V', minValue: 0}
	       	};
	
	        var chart = new google.visualization.AreaChart(document.getElementById('chart_div2'));
	        chart.draw(data, options);
		}
		var errorTable = $('#errorTableId').DataTable({
	 		"ajax": {
            "url": "<%=request.getContextPath()%>/OBDAction.do?param=getErrorDeatails",
            "data":{
            	vehicleNo: '<%=vehicleNo%>'
            },
            "dataSrc": "errorDetailsRoot"
        }, 
        "autoWidth": true,
  	    "scrollX": true,
      	"bFilter": false,
   		"bRetrieve": true,
   		"bStateSave": true,
   		"bPaginate": false,
   		"info":     false,
        "columns": [ {
                "data": "slNoIndex"
            }, {
                "data": "codeIndex"
            }, {
                "data": "descIndex"
            }, {
                "data": "codegeneratedIndex"
            },{
                "data": "remarksIndex"
            }
        ]
	 	});
	 	$('#errorTableId').closest('.dataTables_scrollBody').css('max-height', '150px');
     	$('#errorTableId').DataTable().draw();
	 	//var column = table.column( $('#errorTableId').attr('codegeneratedIndex') );
	 	//var table = $('#errorTableId').DataTable();
 		//table.columns( [ 1, 3 ] ).visible( true, true );
		//table.columns.adjust().draw( false );
	 	$.fn.dataTable.ext.errMode = 'throw';
	 	document.getElementById("refreshId").addEventListener("click", reloadTable);
	 	function reloadTable(){
		 	table.ajax.reload();
		 	errorTable.ajax.reload();
	 	}
	 	document.getElementById("backButtonId").addEventListener("click", backButton);
	 	function backButton(){
	 	if('<%=pageName%>' == 'ErrorCodeDetails.jsp'){
	 		window.location ="<%=request.getContextPath()%>/Jsps/OBD/ErrorCodeDetails.jsp?"+'errorType'+"="+'<%=alertValueId%>';
	 	}else{
	 		window.location ="<%=request.getContextPath()%>/Jsps/OBD/OBDAlertDetails.jsp?"+'alertParam'+"="+'<%=alertValueId%>';
	 	}
	 	}
	}
	setInterval( function () {
   		$('#tableId').DataTable().ajax.reload();
   		$('#errorTableId').DataTable().ajax.reload();
	}, 60000);	// 1 min interval
</script>
</body>
</html>
<%}%>