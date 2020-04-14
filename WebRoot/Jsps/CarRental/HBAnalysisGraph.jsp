<html>
<head>
	<link href="../../Main/Js/bootstrap.min.css" rel="stylesheet">
	<script src="../../Main/Js/jquery.js"></script>
	<script src="../../Main/Js/jquery.min.js"></script>
	<script src="../../Main/Js/bootstrap.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.16.0/jquery.validate.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.16.0/additional-methods.js"></script>
	<script src="../../Main/Js/Common.js"></script>
</head>
<style>
	.container{
		padding-top: 10px;
		margin-left: inherit;
		height: 490px !important;
	}
	#validationId{
		color: red;
	}
	
</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
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
	         loadData();
	     });
	});
 	function loadData(){
			document.getElementById("repeat").innerHTML="";
			if($("#datepickerstart").val() == "" || $("#datepickerend").val() == ""){
				$('#noteId').hide();
				$('#currentLineGraph').hide();
				$('#validationId').show();
			}else{
				$('#noteId').show();
				$('#currentLineGraph').show();
				$('#validationId').hide();
			}

    		var sDate = new Date($("#datepickerstart").val());
    		var eDate = new Date($("#datepickerend").val());
    		var diff_date =  sDate.getTime() - eDate.getTime();
    		var days = diff_date / (1000 * 60 * 60 * 24);
    		
<!--    		if(new Date(sDate).getTime() > new Date(eDate).getTime()){-->
<!--    			alert();-->
<!--			}-->
			
 			var HbJsonList;
    		google.charts.load('current', {'packages': ['line', 'corechart', 'bar']});
          	google.charts.setOnLoadCallback(drawChart);

          	function drawChart() {
            	$.ajax({
                	url: '<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getHBDetilsforGraph',
                  	data: {
                  		startDate: $("#datepickerstart").val(),
                  		endDate: $("#datepickerend").val(),
                  		cityId: groupId
                  	},
                  	success: function(response) {
                    	HbJsonList = JSON.parse(response);
	                    var data = new google.visualization.DataTable();
	                          
	                        var options = {
	                        	title: 'HB Analysis',
	                            height: 420,
	                            width: 1200,
	                            hAxis: { 
									direction: 1, 
								    slantedText: true, 
								    slantedTextAngle: 315, // here you can even use 180 
								},
								vAxis: {
		                        	title: 'Average Duration (min)',
		                            format: 'decimal'
		                        }
	                        };
	                        data.addColumn('string', 'Date');
	                        if(HbJsonList["HBAnalysisRoot"][2].length > 0){
	                        records = 'notempty';
		                        for(var k = 0; k < HbJsonList["HBAnalysisRoot"][2].length; k++){
		                        	data.addColumn('number', HbJsonList["HBAnalysisRoot"][2][k]);
		                        }
								for (var i = 0; i < HbJsonList["HBAnalysisRoot"][0].length; i++) {
						     		date=HbJsonList["HBAnalysisRoot"][0][i];
		                   			array = [];
		                   			array.push(date);
		                   			for (var j = 0; j < HbJsonList["HBAnalysisRoot"][2].length; j++) {
		                       			if (HbJsonList["HBAnalysisRoot"][1][j][date] == undefined) {
		                           			array.push(0);
		                       			} else {
		                           			array.push(HbJsonList["HBAnalysisRoot"][1][j][date]);
		                       			}
		                   			}
		                   			data.addRows([array]);
		                   			var chart = new google.charts.Line(document.getElementById('currentLineGraph'));
		
							 		chart.draw(data, google.charts.Line.convertOptions(options));
		                  			// var chart = new google.visualization.LineChart(document.getElementById('currentLineGraph'));
		                          	//chart.draw(data, options);
		               			}
	                        }else{
	                        	records = 'empty';
	                        	data.addColumn('number', '');
	                        	for (var i = 0; i < HbJsonList["HBAnalysisRoot"][0].length; i++) {
						     		date = HbJsonList["HBAnalysisRoot"][0][i];
		                   			array = [];
		                   			array.push(date);
		                   			array.push(0);
		                   			data.addRows([array]);
		                   			
		                   			var chart = new google.charts.Line(document.getElementById('currentLineGraph'));
							 		chart.draw(data, google.charts.Line.convertOptions(options));
		               			}
	                        }
                     }
            	});
			}
		}
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

</script>
<body onload="loadData()">
<div class="container">
<div class="validation" id="validationId">
<p><strong>Please select Start Date and End Date</strong></p>
</div>
<p><strong style="margin-left: 10px;">Start Date: </strong><input type="text" id="datepickerstart">
<strong style="margin-left: 40px;">End Date: </strong><input type="text" id="datepickerend">
<strong style="margin-left: 40px;">Select City: </strong><select name="size" id="groupName"><option id="">All</option></select>
<input style="margin-left: 50px;" type="button" value="Submit" onclick="loadData()">
<input style="margin-left: 50px;" type="button" title="Report will be generated for the selected City and Date range" value="Generate Report" onclick="gotoReportPage()"></p>
<div class="graph" id=currentLineGraph></div>
<div class="note" id="noteId">
<p><strong>Note : Top 10 vehicles which are doing frequent Harsh Brake</strong></p>
</div>
</div>
<div class="diag-icons" id="repeat"> </div>	
</body>
</html>
