<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
    <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
        <!doctype html>
        <html class="no-js" lang="">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title>Royalty</title>
            <meta name="description" content="">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/wrap-styles.css">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/panel-style.css">
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css">
            <style>
                .io-inner-header {
                    background-color: #1D5D8D;
                    padding-bottom: 10px;
                    position: sticky;
                    width: 100%;
                    z-index: 99;
                    top: 0;
                }

                .bar-graph {
                    width: 653px;
                    border: 1px solid gainsboro;
                    padding: 10px;
                    margin: 0px;
                    height: 389px;
                    border-radius: 8px;
                }
                .pie-chart{
                	width: 653px;
                    border: 1px solid gainsboro;
                    margin: 0px;
                    height: 389px;
                    border-radius: 8px;
                }

                .form-control {
                    width: 100%;
                }
                .cd-panel-content {
				  padding: 5%;
				}
                #orgDataTableId_filter {
                    height: 0px;
                    visibility: collapse;
                }
                #monthlyTableId_filter {
                    height: 0px;
                    visibility: collapse;
                }
                table.dataTable td {
   					border-bottom : 1px solid grey;
				}
				table.dataTable {
    				border-collapse: separate;
				}
				#orgDataTableId{
					width: 590px;
    				margin-left: inherit;
				}
				#monthlyTableId{
					width: 590px;
    				margin-left: inherit;
				}
                .org-graph {
                    width: 1319px;
                    border: 1px solid gainsboro;
                    padding: 10px;
                    margin: 0px;
                    height: 350px;
                    border-radius: 8px;
                }
                dt-right{
                	align:right;
                }
                ::-webkit-scrollbar {
			        width: 12px;
			    }
			
			    ::-webkit-scrollbar-track {
			        -webkit-box-shadow: inset 0 0 6px rgba(0,0,255,0.8); 
			        border-radius: 10px;
			    }
			
			    ::-webkit-scrollbar-thumb {
			        border-radius: 10px;
			        -webkit-box-shadow: inset 0 0 6px rgba(0,0,255,0.7); 
			    }
            </style>
        </head>

        <body>
            <!-- Header -->
            <div class="io-inner-header">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="logo-1">
                                <a href="#"><img src="/ApplicationImages/DMGDashboard/mega_soft_logo.png" alt="logo_1"></a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="logo-2">
                                <a href="/Telematics4uApp/Jsps/IronMining/Dashboard.jsp"><img class="center-block" src="/ApplicationImages/DMGDashboard/Gvt_Goa_logo.png" alt="logo_1"></a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="logo-1">
                                <a href="#"><img class="pull-right" src="/ApplicationImages/DMGDashboard/T4U.png" alt="logo_1"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container-fluid" id="heading">
                <!-- Breadcrumb -->
                <div class="io-breadcrumb">
                    <ol class="breadcrumb">
                        <li><a href="/Telematics4uApp/Jsps/IronMining/Dashboard.jsp">Dashboard</a></li>
                        <li class="active">FINANCIAL ACCOUNTING</li>
                    </ol>
                </div>
                <!-- filter -->
                <div class="ibm-filter">
                    <div class="filter-financialYear">
                    <select class="form-control" id="financialYear">
                    <option value="">Select Year</option>
					<option >2016-2017</option>
					<option selected>2017-2018</option>
					<option >2018-2019</option>
					<option >2019-2020</option>
               		</select>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
            <!-- //filter -->
            <div class="ibm-graphs">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-6" id="FirstGraph">
                            <div class="pie-chart">
                                <a href="#" id="majorPieChart">
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="bar-graph">
                                <a href="#" id="currentLineGraph">
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ibm-graphs">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="org-graph">
                                <div id="orgGraph">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Panel -->
            <div class="cd-panel from-right">
                <div class="cd-panel-container">
                    <div class="cd-panel-content">
                        <a href="#0" class="cd-panel-close">Close</a>
                        <div class="production-summary" id="monthlyTableDiv">
                            <table id="monthlyTableId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th>MONTH</th>
                                        <th>ROYALTY</th>
                                        <th>DMF</th>
                                        <th>NMET</th>
                                        <th>GIOPF</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="production-summary" id="orgTableDiv">
                            <table id="orgDataTableId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th>SNO</th>
                                        <th>ORGANIZATION</th>
                                        <th>ROYALTY</th>
                                        <th>DMF</th>
                                        <th>NMET</th>
                                        <th>GIOPF</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                    <!-- cd-panel-content -->
                </div>
                <!-- cd-panel-container -->
            </div>
            <!-- cd-panel -->
            <!-- Scripts -->
            <script src="../../Main/modules/ironMining/DMGDashboard/js/jquery-3.1.1.min.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/bootstrap.min.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/flipclock.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/custom.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/modernizr.js"></script>
            <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
            <a href="http://www.google.com"></a>
            <script>
                var barJSONList;
                var monthlyJSList;
                var financialYear;
                var count = 0;
                

                financialYear = $("#financialYear option:selected").text();

                loadAccountDetails(financialYear);
                loadLineChart(financialYear,"ROYALTY");
                loadOrgDetails(financialYear,"ROYALTY");
                

                $('#financialYear').on('change', function() {
                    financialYear = $("#financialYear option:selected").val();
                    loadAccountDetails(financialYear);
                    loadOrgDetails(financialYear,"ROYALTY");
                    loadLineChart(financialYear,"ROYALTY");
                });

                function loadAccountDetails(financialYear) {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });

                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getAccountDetailsForDashBoard',
                            data: {
                            financialYear:financialYear
                            },
                            success: function(response) {
                                    var jsonList = JSON.parse(response);
                                    var royalty = jsonList["accountDetailsRoot"][0].ROYALTY;
                                    var proFee = jsonList["accountDetailsRoot"][0].PROCESSING_FEE;
                                    var dmf = jsonList["accountDetailsRoot"][0].DMF;
                                    var nmet = jsonList["accountDetailsRoot"][0].NMET;
                                    var giopf = jsonList["accountDetailsRoot"][0].GIOPF;
                                    var others = 0;//jsonList["accountDetailsRoot"][0].ROYALTY;
                                   
                                    var data = google.visualization.arrayToDataTable([
                                        ['Task', 'Quantity'],
                                        ['ROYALTY', Number(royalty)],
                                        ['PROCESSING FEE', Number(proFee)],
                                        ['DMF', Number(dmf)],
                                        ['NMET', Number(nmet)],
                                        ['GIOPF', Number(giopf)]
                                        
                                    ]);

                                    var options = {
                                    	title: 'TOTAL CHALLAN AMOUNT-MAJOR MINERAL',
                                        height: 380,
                                        width: 600,
                                        pieSliceText: 'value-and-percentage'
                                    };
                                     var chart = new google.visualization.PieChart(document.getElementById('majorPieChart'));
                                    
                                 function selectHandler() {
						          var selectedItem = chart.getSelection()[0];
						          if (selectedItem) {
						           var topping = data.getValue(selectedItem.row, 0);
						           loadLineChart1(financialYear,topping);
						           loadOrgDetails1(financialYear,topping);
						          }
						         }
							        google.visualization.events.addListener(chart, 'select', selectHandler); 
							        chart.draw(data, options);
                                }
                        });
                    }
                }
                function loadLineChart(financialYear,type) {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });

                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getMonthlyAccountDetailsForDashBoard',
                            data: {
                            	financialYear:financialYear
                            },
                            success: function(response) {
                                    monthlyJSList = JSON.parse(response);                                   
                                    var data =new google.visualization.DataTable();
                                        data.addColumn('string', 'Month');
      									data.addColumn('number', type);
      									
      								for(var i=0;i<12;i++){
      									var arr=[];
      									arr.push(monthlyJSList["monthlyAccountDetailsRoot"][i].MONTH);
      									arr.push(Number(monthlyJSList["monthlyAccountDetailsRoot"][i][type]));
      									data.addRows([arr]);
      								}	
                                         
                                    var options = {
                                    	title: 'MONTH WISE '+type+' OF '+financialYear,
                                        height: 350,
                                        width: 600,
                                        hAxis: { 
									        direction: 1, 
									        slantedText: true, 
									        slantedTextAngle: 315 // here you can even use 180 
									    }
                                        
                                    };
                                    var chart = new google.visualization.LineChart(document.getElementById('currentLineGraph'));
                                    chart.draw(data, options);
                                }
                        });
                    }
                }
                function loadLineChart1(financialYear,type) {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });
                    google.charts.setOnLoadCallback(drawChart);
                    function drawChart() {
                            var data =new google.visualization.DataTable();
                                data.addColumn('string', 'Month');
							data.addColumn('number', type);
							
						for(var i=0;i<12;i++){
							var arr=[];
							arr.push(monthlyJSList["monthlyAccountDetailsRoot"][i].MONTH);
							arr.push(Number(monthlyJSList["monthlyAccountDetailsRoot"][i][type]));
							data.addRows([arr]);
						}	
                            var options = {
                            	title: 'MONTH WISE '+type+' OF '+financialYear,
                                height: 350,
                                width: 600,
                                hAxis: { 
					        direction: 1, 
					        slantedText: true, 
					        slantedTextAngle: 315 // here you can even use 180 
					    }
                            };
                            var chart = new google.visualization.LineChart(document.getElementById('currentLineGraph'));
                            chart.draw(data, options);
                    }
                }
                function loadOrgDetails(financialYear,type) {
                    google.charts.load('current', {
                        'packages': ['bar']
                    });
                    google.charts.setOnLoadCallback(drawChart);
                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getOrgRoyaltyForDashBoard',
                            dataSrc: 'orgRoyaltyRoot',
                            data:{
                            	financialYear:financialYear
                            },
                            success: function(response) {
                                barJSONList = JSON.parse(response);
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Organization');
                                data.addColumn('number', type);
                                var options = {
                                	title: 'ORGANIZATION WISE '+type+' OF '+financialYear,
                                    width: 1280,
                                    height: 300,
                                   bars: 'vertivcal',
							       hAxis: { 
								        direction: 1, 
								        slantedText: true, 
								        slantedTextAngle: 340 // here you can even use 180 
								    }
	                         
                                };
                                for (var i = 0; i < barJSONList["orgRoyaltyRoot"].length; i++) {
                                    var array = [];
                                    array.push(barJSONList["orgRoyaltyRoot"][i]['ORG']);
                                    array.push(Number(barJSONList["orgRoyaltyRoot"][i][type]));
                                    data.addRows([array]);
                                }
                                var challanQtyChart = new google.visualization.ColumnChart(document.getElementById('orgGraph'));
                                    challanQtyChart.draw(data, google.charts.Bar.convertOptions(options));
                            }
                        });
                    }
                }
                function loadOrgDetails1(financialYear,type) {
                    google.charts.load('current', {
                        'packages': ['bar']
                    });
                    google.charts.setOnLoadCallback(drawChart);
                    function drawChart() {
                                var data = new google.visualization.DataTable();
                                data.addColumn('string', 'Organization');
                                data.addColumn('number', type);
                                var options = {
                                	title: type+' OF '+financialYear,
                                    width: 1280,
                                    height: 300,
                                   bars: 'vertivcal',
							       hAxis: { 
								        direction: 1, 
								        slantedText: true, 
								        slantedTextAngle: 340 // here you can even use 180 
								    }
                                };
                                for (var i = 0; i < barJSONList["orgRoyaltyRoot"].length; i++) {
                                    var array = [];
                                    array.push(barJSONList["orgRoyaltyRoot"][i]['ORG']);
                                    array.push(Number(barJSONList["orgRoyaltyRoot"][i][type]));
                                    data.addRows([array]);
                                }
                                var challanQtyChart = new google.visualization.ColumnChart(document.getElementById('orgGraph'));
                                    challanQtyChart.draw(data, google.charts.Bar.convertOptions(options));
                    }
                }

                $('#currentLineGraph').on('click', function(event) {
	                $('#monthlyTableDiv').show();
	                $('#orgTableDiv').hide();
                    getMonthlyData();
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('#orgGraph').on('click', function(event) {
                	 $('#monthlyTableDiv').hide();
                	 $('#orgTableDiv').show();
                    getOrgData();
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('.cd-panel').on('click', function(event) {
                    if ($(event.target).is('.cd-panel') || $(event.target).is('.cd-panel-close')) {
                        $('.cd-panel').removeClass('is-visible');
                        event.preventDefault();
                    }
                });

                function getMonthlyData() {
                    var monthlyTable = $('#monthlyTableId').DataTable({
                    "autoWidth": true,
                    "scrollX": true,
                    "bFilter": true,
                    "bRetrieve": true,
                    "bStateSave": true,
                    "bPaginate": false,
                    "info": false,
                    "columnDefs": [
               			{ className: "dt-right", "targets": [1,2,3,4]},
              		],
                    "columns": [{
                        "data": "MONTH"
                    }, {
                        "data": "ROYALTY"
                    },{
                        "data": "DMF"
                    }, {
                        "data": "NMET"
                    },{
                        "data": "GIOPF"
                    }, ]
                });
                	monthlyTable.clear().draw();
                    monthlyTable.rows.add(monthlyJSList["monthlyAccountDetailsRoot"]).draw();
                }
                function getOrgData() {
                var barTable = $('#orgDataTableId').DataTable({
                    "autoWidth": true,
                    "scrollX": true,
                    "bFilter": true,
                    "bRetrieve": true,
                    "bStateSave": true,
                    "bPaginate": false,
                    "info": false,
                    "columnDefs": [
                       { className: "dt-right", "targets": [2,3,4,5]},
                    ],
                    "columns": [{
                        "data": "SLNO"
                    },{
                        "data": "ORG"
                    }, {
                        "data": "ROYALTY"
                    },{
                        "data": "DMF"
                    }, {
                        "data": "NMET"
                    },{
                        "data": "GIOPF"
                    }, ]
                });
                	barTable.clear().draw();
                    barTable.rows.add(barJSONList["orgRoyaltyRoot"]).draw();
                }
            </script>
        </body>

        </html>