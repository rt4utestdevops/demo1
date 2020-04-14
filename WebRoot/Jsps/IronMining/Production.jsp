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
            <title>IBM Grades</title>
            <meta name="description" content="">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/wrap-styles.css">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/panel-style.css">
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css">
            <style>
            	.cd-panel-content {
            		width:104% !important;
            	}
                .io-inner-header {
                    background-color: #1D5D8D;
                    padding-bottom: 10px;
                    position: static;
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
                .form-control {
                    width: 100%;
                }
                #productionSummaryId_filter {
                    height: 0px;
                    visibility: collapse;
                }
                #production7daysTableId_filter{
                	 height: 0px;
                	 visibility: collapse;
                }
                table.dataTable td {
   					border-bottom : 1px solid grey;
				}
				table.dataTable {
    				border-collapse: separate;
				}
                .royalty-graph {
                    width: 1319px;
                    border: 1px solid gainsboro;
                    padding: 10px;
                    margin: 0px;
                    height: 350px;
                    border-radius: 8px;
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
            <div class="container-fluid">
                <!-- Breadcrumb -->
                <div class="io-breadcrumb">
                    <ol class="breadcrumb">
                        <li><a href="/Telematics4uApp/Jsps/IronMining/Dashboard.jsp">Dashboard</a></li>
                        <li class="active">Production</li>
                    </ol>
                </div>
                <!-- filter -->
            </div>
            <!-- //filter -->
            <div class="ibm-graphs">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-6" id="FirstGraph">
                            <div class="bar-graph">
                                <a href="#" id="productionchart">
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="bar-graph">
                                <a href="#" id="productionGraph">
                                </a>
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
                        <div class="production-summary" id="productionsummaryDiv">
                            <div class="tableHeader text-left">
                                <p>Production Summary</p>
                            </div>
                            <table id="productionSummaryId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th>SL No</th>
                                        <th>Organization Name</th>
                                        <th>TC No</th>
                                        <th>MPL Allocated(MT)</th>
                                        <th>Produced(MT)</th>
                                        <th>Balance(MT)</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="production-summary" id="productionTableDiv">
                            <table id="production7daysTableId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th>Date</th>
                                        <th>Production Qty</th>
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
                var productionList;
                google.charts.load('current', {
                    'packages': ['corechart']
                });
                google.charts.setOnLoadCallback(drawChart);

                function drawChart() {
                    $.ajax({
                        url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getProductionChartData',
                        data: {
                            //CustId: custId
                        },
                        success: function(response) {
                            productionElement = JSON.parse(response);
                            produced = productionElement["productionChartRoot"][0].produced;
                            var total = productionElement["productionChartRoot"][0].total;

                            var c = new google.visualization.PieChart(document.getElementById('productionchart'));
                            var d = google.visualization.arrayToDataTable([
                                ['Task', 'Quantity'],
                                ['Produced', Number(produced)],
                                ['balance', Number(total - produced)]
                            ]);
                            var o = {
                             	title: 'Total Production',
                                pieHole: 0.4,
                                height: 350,
                                width: 630
                                //pieSliceText: 'value-and-percentage'
                            };
                            c.draw(d, o);
                        }
                    });
                    $.ajax({
                        url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getLatest7DaysProduction',
                        data: {},
                        success: function(response) {
                            productionList = JSON.parse(response);
                            var data = new google.visualization.DataTable();
                            data.addColumn('string', 'Date');
                            data.addColumn('number', 'Quantity');
                            for (var i = 0; i < 7; i++) {
                                var arr = [];
                                arr.push(productionList["Latest7DaysProductionRoot"][i].DATE);
                                arr.push(Number(productionList["Latest7DaysProductionRoot"][i].PRODUCTION_QTY));
                                data.addRows([arr]);
                            }
                            var options = {  
                                title: 'Weekly Production',
                                height: 350,
                                width: 600,
                                hAxis: {
                                    direction: 1,
                                    slantedText: true,
                                    slantedTextAngle: 315
                                }
                            };
                            var chart = new google.visualization.LineChart(document.getElementById('productionGraph'));
                            chart.draw(data, options);
                        }
                    });
                }
                var table = $('#productionSummaryId').DataTable({
                    "autoWidth": true,
                    "scrollX": true,
                    "bFilter": true,
                    "bRetrieve": true,
                    "bStateSave": true,
                    "bPaginate": false,
                    "info": false,
                    "columnDefs": [
     					 { className: "dt-right", "targets": [3,4,5]},
    				],
                    "columns": [{
                        "data": "slNoIndex"
                    }, {
                        "data": "orgNameIndex"
                    }, {
                        "data": "tcNoIndex"
                    }, {
                        "data": "MplAllocatedIndex"
                    }, {
                        "data": "prodecedIndex"
                    }, {
                        "data": "balanceIndex"
                    }, ]
                });

                $('#productionchart').on('click', function(event) {
                    $('#productionsummaryDiv').show();
                    $('#productionTableDiv').hide();
                    getData();
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('#productionGraph').on('click', function(event) {
                    $('#productionsummaryDiv').hide();
                    $('#productionTableDiv').show();
                    getProductionData();
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('.cd-panel').on('click', function(event) {
                    if ($(event.target).is('.cd-panel') || $(event.target).is('.cd-panel-close')) {
                        $('.cd-panel').removeClass('is-visible');
                        event.preventDefault();
                    }
                });
                function getData() {
                    $.ajax({
                        url: "<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getProductionSummary",
                        data: {},
                        success: function(response) {
                            response = JSON.parse(response);
                            table.clear().draw();
                            table.rows.add(response).draw();
                        }
                    });
                }

                function getProductionData() {
                    var production = $('#production7daysTableId').DataTable({
                        "autoWidth": true,
                        "scrollX": true,
                        "bFilter": true,
                        "bRetrieve": true,
                        "bStateSave": true,
                        "bPaginate": false,
                        "info": false,
                        "columnDefs": [
     					 { className: "dt-right", "targets": [1]},
    					],
                        "columns": [{
                            "data": "DATE"
                        }, {
                            "data": "PRODUCTION_QTY"
                        }]
                    });
                    production.clear().draw();
                    production.rows.add(productionList["Latest7DaysProductionRoot"]).draw();
                }
            </script>
        </body>

        </html>