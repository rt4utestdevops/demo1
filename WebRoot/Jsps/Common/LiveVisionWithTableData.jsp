<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf = new CommonFunctions();
LiveVisionColumns liveVisionColumns = new LiveVisionColumns();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemid = loginInfo.getSystemId();
String systemID = Integer.toString(systemid);
int customeridlogged = loginInfo.getCustomerId();
String CustName = loginInfo.getCustomerName();
int processID = 0;
boolean checkFDAS = false;
if (session.getAttribute("processId") != null) {
	processID = Integer.parseInt((String) session.getAttribute("processId"));
	processID = cf.checkProcessIdExistsForMapView(processID);
} else {
	processID = cf.getProcessID(systemid, customeridlogged);
	processID = cf.checkProcessIdExistsForMapView(processID);
}
String unit=cf.getUnitOfMeasure(systemid);
checkFDAS = liveVisionColumns.checkFDASExistsForCustomer(systemid, customeridlogged);
String dataTypes = liveVisionColumns.exportDataTypes(processID, checkFDAS);
String customernamelogged = "null";
String vehicleTypeRequest = "all";
String category = null;
String status="";
if (request.getParameter("vehicleType") != null) {
 vehicleTypeRequest = request.getParameter("vehicleType");
}
if (request.getParameter("status") != null) {
	status=request.getParameter("status");
	System.out.println(status);
}
if (request.getParameter("category") != null) {
 category = request.getParameter("category");
 vehicleTypeRequest = "";
}
if (request.getParameter("reqType") != null) {
 processID = 20;
}
if (customeridlogged > 0) {
 customernamelogged = cf.getCustomerName(String.valueOf(customeridlogged), systemid);
}
int userId = loginInfo.getUserId();
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("SLNO");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Live_Vision");
tobeConverted.add("DashBoardMap");
tobeConverted.add("List_View");
tobeConverted.add("All");
tobeConverted.add("Communicating");
tobeConverted.add("Non_Communicating");
tobeConverted.add("No_GPS_Connected");
tobeConverted.add("Do_Not_Select_More_Vehicles");
tobeConverted.add("History_Analysis");
tobeConverted.add("Running");
tobeConverted.add("Stoppage");
tobeConverted.add("Idle");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SLNO=convertedWords.get(0);
String Save=convertedWords.get(1);
String Cancel=convertedWords.get(2);
String NoRowsSelected=convertedWords.get(3);
String SelectSingleRow=convertedWords.get(4);
String LiveVision=convertedWords.get(5).toUpperCase();
String dashBoardMap=convertedWords.get(6);
String listView=convertedWords.get(7);
String all = convertedWords.get(8);
String communicating = convertedWords.get(9);
String nonCommunicating = convertedWords.get(10);
String noGPSConnected = convertedWords.get(11);
String maxRecord = convertedWords.get(12);
String historyAnalysis = convertedWords.get(13);
String runningVehicle = convertedWords.get(14);
String stoppedVehicle = convertedWords.get(15);
String idleVehicle = convertedWords.get(16);
%>

<jsp:include page="../Common/header.jsp" />
    
    <title>LiveVisionWithTableData</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/component.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/component.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/layout.css" /> 	 
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	
	<!-- grid start	-->
	<script src="https://cdn.datatables.net/1.10.13/js/jquery.dataTables.min.js"></script>
	<script src = "https://cdn.datatables.net/buttons/1.2.4/js/dataTables.buttons.min.js"></script>
	<script src = "https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script>
	<script src = "https://cdn.rawgit.com/bpampuch/pdfmake/0.1.24/build/vfs_fonts.js"></script>
	<script src = "https://cdn.datatables.net/buttons/1.2.4/js/buttons.html5.min.js"></script>
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css" />
	<link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.2.4/css/buttons.dataTables.min.css"/>
	<script type="text/javascript" src="https://cdn.datatables.net/r/dt/jq-2.1.4,jszip-2.5.0,pdfmake-0.1.18,dt-1.10.9,af-2.0.0,b-1.0.3,b-colvis-1.0.3,b-html5-1.0.3,b-print-1.0.3,se-1.0.1/datatables.min.js"></script>
  	<!-- grid ends	-->
  	
  	<script src="../../Main/Js/jqueryjson.js"></script>
  	
  	<style>
  	
	#listviewcontainer{
		width:100% !important;
		height:520px !important;
		border:0 !important;
	}
	#historyAnalysisContainer{
		width:100% !important;
		height:520px !important;
		border:0 !important;
	}
	@media screen and (device-width:1440px) {
		#listviewcontainer{
			width:100% !important;
			height: 625px !important;
			border:0 !important;
		}
		.list-container-fitscreen {
		    position: fixed;
		    top: 5%;
		    border: 5px solid #ffffff;
		    left: 0%;
		    width: 100%;
		    height: 656px !important;
		}
		#historyAnalysisContainer {
		    width: 100% !important;
		    height: 610px !important;
		    border: 0 !important;
		}
	}
	@media screen and (device-width:1600px) {
		#listviewcontainer{
			width:100% !important;
			height: 610px !important;
			border:0 !important;
		}
		.list-container-fitscreen {
		    position: fixed;
		    top: 5%;
		    border: 5px solid #ffffff;
		    left: 0%;
		    width: 100%;
		    height: 646px !important;
		}
		#historyAnalysisContainer {
		    width: 100% !important;
		    height: 610px !important;
		    border: 0 !important;
		}
	}
	@media screen and (device-width:1920px) {
		#listviewcontainer{
			width:100% !important;
			height:765px !important;
			border:0 !important;
		}
	}
	@media (device-width: 1280px) and (device-height: 800px) {
		.list-container-fitscreen {
		    position: fixed;
		    top: 7.1%;
		    border: 5px solid #ffffff;
		    left: 0%;
		    width: 100%;
		    height: 545px;
		}
	}
	  tr td a {
		    position: relative!important;
		    top: 0 px;
		    bottom: 0 px;
		    left: 0 px;
		    right: 0 px;
		}
		.aligns {
		    margin: 7 px 0 px!important;
		}
		th,td {
		    text-align : left;
		}
		.dataTables_info {
		    display: none;
		}
		.mp-map-wrapper{
			height :515px !important;
		}
		a {
    		color: black !important;
		}
		.container {
			margin-top : -14px !important;
			margin-left : -16px !important;
		}
		#footSpan {
			margin-top : 14px !important;
			margin-right : 14px !important;
			font-size: 15px !important;
		}
	  </style>

 
  <!--<body onload="LoadData();">-->
   <script>
   window.onload = function () { 
		LoadData();
	}
    var processID=<%=processID%>;
    var exportDataType="<%=dataTypes%>";
    var previousVehicleType='<%=vehicleTypeRequest%>';
    var status='<%=status%>';
    var jspName="LiveVision";
    var table;
    var $mpContainer = $('#mp-container');	
	var $mapEl = $('#map');	
	var loadfirst = 1;
   	function LoadData() {
        button="Map";
        document.getElementById('listviewid').style.color='#02B0E6';
        document.getElementById('mapviewid').style.color='#fff';
        document.getElementById('listviewid').style.borderColor='#02B0E6';
        document.getElementById('mapviewid').style.borderColor='#fff';         
        document.getElementById('listviewcontainer').style.display = 'none';
        document.getElementById('historyAnalysisContainer').style.display = 'none';
        document.getElementById('grid').style.display = 'block';
        if(status!=null && status!="" && status=="dashboard"){
         	previousVehicleType='<%=vehicleTypeRequest%>';
    	}else{
    		previousVehicleType=document.getElementById('vehicletype').value;
    	}
       	if($.fn.dataTable.isDataTable('#example')) {
	  		table.destroy();
	  	}
	   table = $('#example').DataTable({
           "ajax": {
	           "url": "<%=request.getContextPath()%>/MapView.do?param=getLiveVisionVehicleDetails",
	           "data":{
	           	custName:'<%=customernamelogged%>',
				jspName:jspName,
				vehicleType:previousVehicleType,
				processID:processID,
				checkFDAS:'<%=checkFDAS%>'
	           	},
	           "dataSrc": "cashVanListDetailsRoot",           
           },
	       "autoWidth": true,
	       "scrollX": true,
	       "scrollY": "400px",
	       "scrollCollapse": true,
	       "paging": false,
	       dom: 'Bfrtip',
	       buttons: [{extend: 'excelHtml5',title: 'Live Vision'},{text: 'Refresh',action: function ( e, dt, node, config ) {dt.ajax.reload();}},
	       {text: 'Back',id: 'backButton',enabled: false,action: function ( e, dt, node, config ) {
	       		window.location="<%=request.getContextPath()%>/Jsps/CarRental/DashBoard.jsp";
	       }}],
	       "columnDefs": [{
						    "defaultContent": "0",
						    "targets": "_all"
						  }],
	       "columns": [
	       			{"data":"slnoIndex"},
	       			{"data":"obdIndex"},
	             	{"data":"vehiclenoindex"},
				    {"data":"vehicleimageindex"}, 
				    {"data":"datetimeindex"},    
				    {"data":"locationindex"},  
				    {"data":"ignitionindex"},    
				    {"data":"speedindex"},
				    {"data":"stoppagetimeindex"},				    
				    {"data":"vehiclegroupindex"},					
				    {"data":"remarksindex"},
					{"data":"vehiclemodelindex"},			    				 
				    {"data":"batteryVoltageIndex"},
				    {"data":"odometerindex"},		    				  
					{"data":"vehicleidindex"},
					{"data":"obdodometerindex"},
					{"data":"obddatetimeindex"}
	         ]
	    });
	    if(status!=null && status!=""){
         	table.button( 2 ).enable();
    	}
    }
    if(<%=customeridlogged%> == 0){
    	setTimeout(function(){table.column(1).visible(false);},1000);
    }
    function changecolor(){
		document.getElementById('listviewid').style.color='#02B0E6';
		document.getElementById('mapviewid').style.color='#fff';
		document.getElementById('listviewid').style.borderColor='#02B0E6';
		document.getElementById('mapviewid').style.borderColor='#fff';
		document.getElementById('history_analysis').style.color='#fff';
		document.getElementById('history_analysis').style.borderColor='#fff';

	}
	function changecolor1(){
		document.getElementById('listviewid').style.color='#fff';
		document.getElementById('mapviewid').style.color='#02B0E6';
		document.getElementById('listviewid').style.borderColor='#fff';
		document.getElementById('mapviewid').style.borderColor='#02B0E6';
		document.getElementById('history_analysis').style.color='#fff';
		document.getElementById('history_analysis').style.borderColor='#fff';
	}
	function changecolor2(){
		document.getElementById('listviewid').style.color='#fff';
		document.getElementById('listviewid').style.borderColor='#fff';
		document.getElementById('mapviewid').style.color='#fff';
		document.getElementById('mapviewid').style.borderColor='#fff';
		document.getElementById('history_analysis').style.color='#02B0E6';
		document.getElementById('history_analysis').style.borderColor='#02B0E6';
	}
	function changecolor3(){
		document.getElementById('listviewid').style.color='#fff';
		document.getElementById('listviewid').style.borderColor='#fff';
		document.getElementById('mapviewid').style.color='#fff';
		document.getElementById('mapviewid').style.borderColor='#fff';
		document.getElementById('history_analysis').style.color='#fff';
		document.getElementById('history_analysis').style.borderColor='#fff';
	}
	function showHistoryAnalysis() {
		document.getElementById('map').style.display = 'block';
		document.getElementById('grid').style.display = 'none';
		document.getElementById('listviewcontainer').style.display = 'none';
		document.getElementById('historyAnalysisContainer').style.display = 'block';
		recordstatus = "fromListView";
		if (loadfirst == 1) {
			$('#historyAnalysisContainer').attr('src', "<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?recordstatus=" + recordstatus);
			loadfirst = 0;
		}
	}	
	
	
	function reszieFullScreen() {
		document.getElementById('map').style.display = 'block';
		document.getElementById('grid').style.display = 'none';
		document.getElementById('listviewcontainer').style.display = 'block';
		document.getElementById('historyAnalysisContainer').style.display = 'none';
		var vehtype = document.getElementById("vehicletype").value;
		$('#listviewcontainer').attr('src', "<%=request.getContextPath()%>/Jsps/Common/MapViewForOla.jsp?vehicleType=" + vehtype + "&processId=<%=processID%>");
	}	
	setInterval(function(){ 
		table.ajax.reload(); 
	}, 180000);
   </script>
   <div class="container">
  		<header>
			<select class="combobox" id="vehicletype" onchange="LoadData();">
 					<option value="all"><%=all%></option>
 					<option value="comm"><%=communicating%></option>
 					<option value="noncomm"><%=nonCommunicating%></option>
 					<option value="noGPS"><%=noGPSConnected%></option>
 					<option value="running"><%=runningVehicle%></option>
 					<option value="stoppage"><%=stoppedVehicle%></option>
 					<option value="idle"><%=idleVehicle%></option>
			</select>					
			<h1><span><%=LiveVision%></span></h1>					
		</header>
	   <div class = "main" id="map">
		    <div class="mp-container" id="mp-container">
		    <div class="mp-map-wrapper" id="map">
		    	<button type="button" class="button" id="listviewid"  onclick="changecolor();LoadData();">List View</button>
		        <button type="button" class="button" id="mapviewid"  onclick="changecolor1();reszieFullScreen();">Map View</button>
		        <button type="button" class="button" id="history_analysis"  onclick="changecolor2();showHistoryAnalysis();">History Analysis</button>
	            <input type="hidden" id="reglist"/>
	            <iframe id="listviewcontainer" src="" scrolling='no'></iframe>
	            <iframe id="historyAnalysisContainer" src="" scrolling='yes'></iframe>	 	        
				<div id="grid">
					<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
				       <thead style="font-size:12px;background: #F5F5F5 !important;">				          
					       <tr>
				          		<th>SLNO</th>
				          		<th>OBD Vehicle</th>
				          		<th>Vehicle No</th>
								<th>Image</th>
								<th>Last Communication</th>
								<th>Location</th>
								<th>Ignition</th>
								<th>Speed(<%=unit%>/h)</th>
								<th>Stoppage Time(HH.MM)</th>
								<th>Vehicle Group</th>
								<th>Remarks</th>
								<th>Vehicle Model</th>
								<th>Battery Voltage</th>
								<th>Odometer</th>
								<th>Vehicle Id</th>
								<th>OBD Odometer</th>
								<th>OBD DateTime</th>
				          </tr>
				       </thead>
				    </table>
				</div>
				
			</div>
			</div>
	    </div>
    </div>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->