<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String regNo = "";
CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int customerId=loginInfo.getCustomerId();
if(loginInfo != null){

			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>
 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
	<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">	
      
 <link rel="stylesheet" href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css" type="text/css" />
			
			
			
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
   
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert.min.js"></script>

	 <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/scripts/demos.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/globalization/globalize.js"></script>
    
     <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.5/jspdf.min.js"></script>
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }
         #tempCombo{
         	    margin-right: 930px;
         }
        .select2-container{
         	width:300px !important;
         }
          .center-view{
						width:100%;
						margin-left:48%;
				}

      </style>
 
  
  
<!--    <body onload="getTripNames();" >   -->
    
      <div class="custom">
         <div class="panel panel-primary">
               
			   <div class="panel-heading">
                  <h3 class="panel-title" >
                     Temperature Report
                  </h3>
               </div>
			   
			   <div class="panel-body">
			   <div class="col-lg-12 col-md-12">
			    <span><label >Trip wise  </label><span style="padding-left: 20px;"></span><input type="radio" value="radiotrip" name="yesno" id="yesClick" >
				
			   <label style="padding-left: 50px;">Vehicle wise</label><span style="padding-left: 20px;"></span><input type="radio" value="radiovehicle" name="yesno" id="noClick" style="padding-left: 20px;"></span>
			  
				 </div>
			   <div class="panel row" style="padding:1% ;margin: 0%;"> 
			   
			
			   
			   <div class="col-xs-12 col-md-12 col-lg-12 col-sm-12 row" id="tripWise" >
				   <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3  "  >
				     <select class="form-control" id="tripName" onchange="resetDataTable()">
				     	<option value="">Select Trip Number</option>
				     </select> 
	               </div>
	               <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  id="viewReport" class="btn btn-success" onclick="getTemperatureReport()">View Report</button></div>
				   <div class="col-xs-2 col-md-1 col-lg-1 col-sm-2" style="margin-left: 8px;"><button type="button"  id="viewGraph" class="btn btn-success" onclick="getTempDetails()">View Graph</button></div>
			   </div>
			    <div class="col-sm-12 col-md-12 col-lg-12 col-sm-12 row" id="vehicleWise">
				   <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3 " id="vehicleWise"><select class="form-control" id="vehicleNumber" onchange="resetDataTable()">
				     	<option value="">Select Vehicle Number</option>
				     </select> </div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1 "><label   id="startDateLabelId" >Start Date:</label></div>
				   <div class="col-sm-2 col-md-2 col-lg-2 col-sm-2 "><input type='text'  id="dateInput1" /></div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1 "><label  id="endDateLabelId">End Date:</label></div>
				   <div class="col-sm-2 col-md-2 col-lg-2 col-sm-2 "><input type='text'  id="dateInput2" /></div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1 "><button type="button"  class="btn btn-success" onclick="getTemperatureReport()">View Report</button></div>
				   <div class="col-sm-1 col-md-1 col-lg-1 col-sm-1" style="margin-left: 8px;" ><button type="button"  class="btn btn-success" onclick="getTempDetails()">View Graph</button></div>
			   </div>
			    
			    </div>  <!--End of header Panel-->
			    
			    
			    <div class="panel row" style="padding:1% ;margin: 0%;" id ="tripVehicles"> 
			   <div class="col-lg-12 col-md-12" >
			   
			     <label>Vehicle No: </label> <label id="vehicleNo" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>Start Date: </label> <label id="startdate" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>End Date: </label> <label id="endDate" style="font-weight: 300;padding-right: 40px;"></label>
  				 <label>Trip Name: </label> <label id="tripName1" style="font-weight: 300;padding-right: 40px;"></label><br>
			    <label>Reference Number: </label> <label id="referenceNo" style="font-weight: 300;padding-right: 40px;"></label>
				<label>Driver: </label> <label id="DriverName" style="font-weight: 300;padding-right: 40px;"></label>
				<label>Threshold Limit(°C): </label> <label id="tempRangeDataIndex" style="font-weight: 300;padding-right: 40px; bottom: 30px"></label>
				<%if(customerId == 5516){ %>
				<label>Recorded Min Value (°C): </label> <label id="minTemp" style="font-weight: 300;padding-right: 40px;"></label>
				<label>Recorded Max Value (°C): </label> <label id="maxTemp" style="font-weight: 300;padding-right: 40px;"></label>
				 <%}%>
			   </div>
			    
			    </div>  <!--End of header Panel-->
			    
			    <div style="overflow: auto !important;">
			   <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
							
				</table>
				</div>	<!-- end of table -->
			   
			   </div>  <!-- end of panel body -->
	  </div> <!-- end of panel  -->
	  </div> <!-- end of main div : custom -->
	  
	 <div id="add" class="modal fade" style="width: 90%;margin-left: 63px;margin-top: 76px;">
         <div class="modal-content">
            <div class="modal-header" >
               
               <div class="secondLine" style="display:flex; align-items:baseline;">
                  Category: <select class="form-control" id="tempCombo">
		     	
			     </select>
                  <button type="button" class="close" data-dismiss="modal">&times;</button>
               </div>
            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-lg-12">
                  	<input class="btn-success" id="save-pdf" type="button" value="Save as PDF" disabled />
                      <div id="chart_div"></div>
                  </div>
               </div>
            </div>
            <div class="modal-footer"  style="text-align: right; height:75px;" >
           <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px;">Close</button>
            </div>
         </div>
      </div>
      <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
     <script type="text/javascript">
	  window.onload = function () { 
		getTripNames();
	}
	var columnArr = [];
     var currentDate = new Date();
     var yesterdayDate = new Date();
	 var table;
         yesterdayDate.setDate(yesterdayDate.getDate() - 2);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);
     var startDate;
	 var endDate;
	 var regNo;
	 var tripName1;
	 var tempRangeDataIndex;
	 
 $(document).ready(function () {
   
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
   
});
	 
	 $('input:radio[name=yesno]').change(function() {
		if ($.fn.DataTable.isDataTable('#example')) {
		    $('#example').DataTable().destroy();
		}
        if (this.value == 'radiotrip') {
           $('#startDateLabelId').hide();
           $('#dateInput1').hide();
           $('#endDateLabelId').hide();
           $('#dateInput2').hide();
           $('#vehicleWise').hide();
           $('#tripWise').show();
           $('#tripVehicles').show(); 
           if(document.getElementById("vehicleNumber").value){
	          $("#vehicleNumber").select2("val", "");
	       }
	       $("#dateInput1").val(yesterdayDate);
	       $("#dateInput2").val(currentDate);
	       }
        if (this.value == 'radiovehicle') {
           $('#startDateLabelId').show();
           $('#dateInput1').show();
           $('#endDateLabelId').show();
           $('#dateInput2').show();
           $('#vehicleWise').show();
           $('#tripWise').hide();      
           $('#tripVehicles').hide(); 
           if(document.getElementById("tripName").value){
	          $("#tripName").select2("val", "");
	       }
        }
    });
    
    function resetDataTable()
    {
    	if($.fn.DataTable.isDataTable("#example"))
    	{
    		$("#example").DataTable().clear().destroy();  
    		$('#example').empty();  
    		columnArr = [];  		
    		
    	}
    }
	
 function getTemperatureReport(){
    var threshold = "";
 	var vehicleNo;
	var vehicleNum;
	var  tripName = "";
	if(document.getElementById("yesClick").checked){
		tripName = "Trip Name:"+tripName1;
	threshold="Threshold Limit(°C):"+document.getElementById("tempRangeDataIndex").innerHTML;
	}
 	if(document.getElementById("yesClick").checked){
		vehicleNo = document.getElementById("vehicleNo").innerHTML;	
		if(document.getElementById("tripName").value == ""){
		    sweetAlert("Please select Trip Number");
		    return;
		}
	}
	else if(document.getElementById("noClick").checked){
		vehicleNo = document.getElementById("vehicleNumber").value;
	    if(document.getElementById("vehicleNumber").value == ""){
		    sweetAlert("Please select Vehicle Number");
		    return;
		}else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			
				regNo = document.getElementById("vehicleNumber").value;
				startDate = document.getElementById("dateInput1").value;
				endDate = document.getElementById("dateInput2").value;
				tripName1=document.getElementById("tripName1").value;
				tempRangeDataIndex=document.getElementById("tempRangeDataIndex").value;
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
	}
	vehicleNum="Vehicle No:"+regNo;
	resetDataTable();
	$('#loading-div').show();
	
	 getConfigurationDetails(regNo,'');
	setTimeout(function(){
		
    table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTemperatureReport",
                "dataSrc": "tempReportRoot",
                  "data": {
					startdate: startDate,
					enddate: endDate,
					vehicleNo: regNo,
               }
            },
            "bLengthChange": false,
             "dom": 'Bfrtip',
			 paging:false,
			 "scrollY" : "500px",
       		"buttons": [{extend:'pageLength'},
	       				{
	       				extend:'excel',
						header:false,
	       					text: 'Export to Excel',
		      	 			className: 'btn btn-primary',
		      	 			title: 'Temperature Report',
		      	 			exportOptions: {
				            	columns: ':visible'
				            },
							 customizeData: function(data){
									var desc = [
									    ['',''], 
										['End Date:',endDate, tripName],
										['Start Date:',startDate,vehicleNum,threshold]	
									];
									data.body.unshift(data.header);
									for (var i = 0; i < desc.length; i++) {
										data.body.unshift(desc[i]);
									};
								},
			            },{
			            extend:'pdf',
       					text: 'Export to Pdf',
	      	 			className: 'btn btn-primary',
	      	 			title: 'Temperature Report',
	      	 			exportOptions: {
			                columns: ':visible'
			            }
			            }],
       		columnDefs: [
		            { width: 50, targets: 0 },
		            { width: 50, targets: 1 },
		            { width: 50, targets: 2 },
		            { width: 300, targets: 3 }
		        ],
            "columns": columnArr
        });
		
		  if(document.getElementById("minTemp") != null && document.getElementById("maxTemp") != null){
			setTimeout(function(){
				var maxTemp = table
					.column(1)
					.data()
					.sort(function(a, b){return parseFloat(b)-parseFloat(a)})[0];
				var minTemp = table
					.column(1)
					.data()
					.sort(function(a, b){return parseFloat(a)-parseFloat(b)})[0];
					if(typeof minTemp !== "undefined" )
					{
						document.getElementById("minTemp").innerHTML = minTemp;
						document.getElementById("maxTemp").innerHTML = maxTemp;
					}
					else{				
						document.getElementById("minTemp").innerHTML='NA';
						document.getElementById("maxTemp").innerHTML = 'NA';
					} 
			}, 3000);
		}
		
       } , 2000);
      }
			
	$('#tripName').change(function() {
        tripId = $('#tripName option:selected').attr('value');
        if(tripId){
        	getTripData(tripId);
        }
    });

    function getTripNames(){
	    tripArray=[];
		$.ajax({
	        url: '<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTrip',
	          success: function(result) {
	           tripList = JSON.parse(result);
		       for (var i = 0; i < tripList["tripNames"].length; i++) {
				   $('#tripName').append($("<option></option>").attr("value",tripList["tripNames"][i].tripId).text(tripList["tripNames"][i].tripName));
			   }
				$("#tripName").select2();
			}
		});
		getVehicle();
		document.getElementById("yesClick").checked = true;
		$('#startDateLabelId').hide();
        $('#dateInput1').hide();
        $('#endDateLabelId').hide();
        $('#dateInput2').hide();
        $('#vehicleWise').hide();
    }
    function getVehicle(){
		var vehicleAarray=[];
		var vehicles = [];
		$.ajax({
	        url: '<%=request.getContextPath()%>/TemperatureReportAction.do?param=getVehicles',
	          success: function(result) {
	                  vehicles = JSON.parse(result);
	         
	            for (var i = 0; i < vehicles["vehicleDetails"].length; i++) {
				vehicleAarray.push(vehicles["vehicleDetails"][i].vehicleNo);
				   $('#vehicleNumber').append($("<option></option>").attr("value",vehicles["vehicleDetails"][i].vehicleNo).text(vehicles["vehicleDetails"][i].vehicleNo));			
				}
	            $("#vehicleNumber").select2();	           	            
			}
		});
    }
    
    function getTripData(tripId){
    	document.getElementById("viewReport").disabled=true;
    	document.getElementById("viewGraph").disabled=true;
    	$.ajax({
            url: "<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTripData",
            data: {
              tripId:tripId
            },
            "dataSrc": "tripData",
            success: function(result) {
                results = JSON.parse(result);
                regNo=results["tripData"][0].assetNo;
                startDate=results["tripData"][0].startDate;
                endDate=results["tripData"][0].endDate;
                tripName1=results["tripData"][0].tripName1;
                referenceNo=results["tripData"][0].referenceNo;
                tempRangeDataIndex=results["tripData"][0].tempRangeDataIndex;
                DriverName=results["tripData"][0].DriverName;
                
                document.getElementById("vehicleNo").innerHTML = regNo;
                document.getElementById("startdate").innerHTML = startDate;
                document.getElementById("endDate").innerHTML = endDate;
                document.getElementById("tripName1").innerHTML = tripName1;
                 document.getElementById("referenceNo").innerHTML =referenceNo;
                   document.getElementById("DriverName").innerHTML =DriverName;
                   if(typeof tempRangeDataIndex != "undefined" )
					{ document.getElementById("tempRangeDataIndex").innerHTML =tempRangeDataIndex;
					}
					else{				
						document.getElementById("tempRangeDataIndex").innerHTML='NA';
						
					} 
                document.getElementById("viewReport").disabled=false;
    			document.getElementById("viewGraph").disabled=false;
				if(document.getElementById("minTemp") != null && document.getElementById("maxTemp") != null){
					document.getElementById("minTemp").innerHTML = '';
					document.getElementById("maxTemp").innerHTML = '';
				}
            }
        });
    }
    $('#tempCombo').change(function() {
        tempData = $('#tempCombo option:selected').attr('value');
        if(tempData=='ALL'){
        	getTempDetailsForAll();
        }else{
        	getIndividualTemp(tempData);
        }
    });
    
    function getTempDetails(){
    
	    if(document.getElementById("yesClick").checked){
		    if(document.getElementById("tripName").value == ""){
			    sweetAlert("Please select Trip Number");
			    return;
			}
		}
		else if(document.getElementById("noClick").checked){
		    if(document.getElementById("vehicleNumber").value == ""){
		    sweetAlert("Please select Vehicle Number");
		    return;
		}else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			
				regNo = document.getElementById("vehicleNumber").value;
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
		}
	     $(".modal-header #tripEventsTitle").text("Temperature Graph for "+regNo+" From  "+startDate+" To  "+endDate);
	     getConfigurationDetails(regNo,'graph');
	     $('#add').modal('show');
	     getTempDetailsForAll();
     }
     function getIndividualTemp(temp){
     	 $("#chart_div").html('<div class="center-view"><img src="../../Main/images/loading.gif" alt=""></div>');
		google.charts.load('current', {'packages':['corechart']});
      	google.charts.setOnLoadCallback(drawChart1(temp));
	}
	function drawChart1(temp) {
		var sensorName = $('#tempCombo option:selected').attr('value');
		var displayName = $('#tempCombo option:selected').attr('text');
			   $.ajax({
                        url: '<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTempDetails',
                        data: {
                        	vehicleNo: regNo,
							startdate: startDate,
							category: sensorName,
							enddate: endDate
                        },
                        success: function(response) {
                            tempList = JSON.parse(response);
                            if(tempList["tempRoot"].length>0){
                            var data = new google.visualization.DataTable();
                            data.addColumn('string', 'Time');
                            data.addColumn('number', displayName);
                            for (var i = 0; i < tempList["tempRoot"].length; i++) {
                                var arr = [];
                                arr.push(tempList["tempRoot"][i].DATE);
                                arr.push(Number(tempList["tempRoot"][i].TEMP));
                                data.addRows([arr]);
                            }
                            var options = {  
                                title: 'Temperature Graph - '+regNo+'. From  '+startDate+' To  '+endDate,
                                height: 350,
                                width: 1120,
                                vAxis: {
	                             format: 'decimal'
	                         	},
                                hAxis: {
                                    direction: 1,
                                    slantedText: true,
                                    slantedTextAngle: 315
                                }
                            };
                            $("#chart_div").html('');
                           var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                           var chart_div = document.getElementById('chart_div');

	                       var btnSave = document.getElementById('save-pdf');
						  	google.visualization.events.addListener(chart, 'ready', function () {
						    	btnSave.disabled = false;
						  	});
						
						  	btnSave.addEventListener('click', function () {
						    	var doc = new jsPDF('landscape');
						    	doc.addImage(chart.getImageURI(), 0, 0);
						    	doc.save('chart.pdf');
							}, false); 
      					   chart.draw(data, options);
      					   
      					   }else{
      					   		$('.modal').modal('hide');
      					   		sweetAlert("No records Found");
      					   }
                        }
                    });
		}
   function getTempDetailsForAll(){
   		$("#chart_div").html('<div class="center-view"><img src="../../Main/images/loading.gif" alt=""></div>');
		google.charts.load('current', {'packages':['corechart']});
      	google.charts.setOnLoadCallback(drawChart());
		function drawChart() {
			   $.ajax({
                        url: '<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTemperatureReport',
                        data: {
                        	vehicleNo: regNo,
							startdate: startDate,
							enddate: endDate
                        },
                        success: function(response) {
                            tempList = JSON.parse(response);
                            if(tempList["tempReportRoot"].length>0){
	                            var data = new google.visualization.DataTable();
	                            data.addColumn('string', 'Time');
	                             for(var j = 0; j < headerArrayAj.length; j++){
                           			 data.addColumn('number', headerArrayAj[j]+'(°C)');
                            	} 
							    
	                            for (var i = 0; i < tempList["tempReportRoot"].length; i++) {
	                                var arr = [];
	                                arr.push(tempList["tempReportRoot"][i].gmt);
	                                var map = tempList["tempReportRoot"][i].map;
	                                 for (var key in map) { 
	                                 	 arr.push(Number(map[key]));
	                                 }
	                                data.addRows([arr]);
	                            }
	                            var options = {
	                                title: 'Temperature Graph of - '+regNo+'. From  '+startDate+' To  '+endDate,
	                                height: 330,
	                                width: 1120,
	                                vAxis: {
		                             format: 'decimal'
		                         	},
	                                hAxis: {
	                                    direction: 1,
	                                    slantedText: true,
	                                    slantedTextAngle: 315
	                                }
	                            };
	                            $("#chart_div").html('');
	                          	var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
								var chart_div = document.getElementById('chart_div');

	                           	var btnSave = document.getElementById('save-pdf');
							  	google.visualization.events.addListener(chart, 'ready', function () {
							    	btnSave.disabled = false;
							  	});
							
							  	btnSave.addEventListener('click', function () {
							    	var doc = new jsPDF('landscape');
							    	doc.addImage(chart.getImageURI(), 0, 0);
							    	doc.save('chart.pdf');
								}, false); 
								chart.draw(data, options);
                           }else{
                           		$('.modal').modal('hide');
                           		sweetAlert("No records Found");
                           }
                        }
                    });
       		}
		}
		  var headerArrayAj=[];
    var dataArray=[];
    function getConfigurationDetails(regNo,graph){
     columnArr = [];
     headerArrayAj=[];
     $('#tempCombo').empty();
     
     //If not rs232 
     
    $.ajax({
	        url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=checkRS232Assoc',
	        data: {
	        vehicleNo:regNo        	
	        },
	         success: function(result) {
	         if(result == 'false'){
	         headerArrayAj = ['T1'];
	        	$('#tempCombo').append($("<option></option>").attr("value","ALL").text("ALL"));
	         	$('#tempCombo').append($("<option></option>").attr("value","T1").text("T1"));
			     columnArr.push({ "title": "Sl No","data": "slno"});
			     columnArr.push({ "title": "T1","data": "T1"});
			     columnArr.push({ "title": "Location","data": "location"});
			     columnArr.push({ "title": "Date & Time","data": "datetime"});
     		}
    	 else {
	       $.ajax({
	            url: '<%=request.getContextPath()%>/TemperatureReportAction.do?param=getTempConfigurations',
	            data: {
	              regNo:regNo
	            },
	             success: function(result) {
	                 json = JSON.parse(result);
	                 headerArrayAj = json["tempConfigDetails"][0];
	                 dataArray = json["tempConfigDetails"][1];
	                 if(graph!=''){
	                  $('#tempCombo').append($("<option></option>").attr("value","ALL").text("ALL"));
	                   for (var i = 0; i < headerArrayAj.length; i++) {
	                       $('#tempCombo').append($("<option></option>").attr("value",dataArray[i]).text(headerArrayAj[i]));
	                   }
	                 }else{
	                    columnArr.push({ "title": "Sl No","data": "slno"});
	                    for(var j = 0; j < headerArrayAj.length; j++){
	                       columnArr.push({ "title": headerArrayAj[j],"data": dataArray[j]});
	                    }
	                    columnArr.push({ "title": "Location","data": "location"});
	                    columnArr.push({ "title": "Date & Time","data": "datetime"});
	                 }
	            }
	        });
	     }
    }
    });
}
 </script>
   
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->