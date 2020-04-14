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
                #gradeDataTableId{
				    width: 590px;
				    margin-left: inherit;
				}
                #gradeDataTableId_filter {
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
                        <li class="active">IBM Grades</li>
                    </ol>
                </div>
                <!-- filter -->
                <div class="ibm-filter">
                    <div class="filter-month">
                        <select class="form-control" id="month">
                  <option>Select Month</option>
                  <option selected>January</option>
                  <option value="February">February</option>
                  <option value="March">March</option>
                  <option value="April">April</option>
                  <option value="May">May</option>
                  <option value="June">June</option>
                  <option value="July">July</option>
                  <option value="August">August</option>
                  <option value="September">September</option>
                  <option value="October">October</option>
                  <option value="November">November</option>
                  <option value="December">December</option>
               </select>
                    </div>
                    <div class="filter-year">
                        <select class="form-control" id="year">
                  <option value="">Select Year</option>
                  <option selected>2017</option>
                  <option value="2016">2016</option>
                  <option value="2015">2015</option>
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
                            <div class="bar-graph">
                                <a href="#" id="FinesGraph">
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="bar-graph">
                                <a href="#" id="LumpsGraph">
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ibm-graphs">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="bar-graph">
                                <a href="#" id="ConcentratesGraph">
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="bar-graph">
                                <a href="#" id="ROMGraph">
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
                            <div class="royalty-graph">
                                <div id="royaltyGraph">
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
                        <div class="production-summary">
                            <div class="tableHeader text-left">
                                <p>Grade Data </p>
                            </div>
                            <table id="gradeDataTableId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th class="sorting_desc">SL No</th>
                                        <th>Type</th>
                                        <th>Grade</th>
                                        <th>IBM Rate</th>
                                        <th>Royalty</th>
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
                var gradeArray = [];
                var grade = [];
                var type = [];
                var month;
                var year;
                var count = 0;
                gradeArray.push("Below55%");
                gradeArray.push("55%toBelow58%");
                gradeArray.push("58%toBelow60%");
                gradeArray.push("60%toBelow62%");
                gradeArray.push("62%toBelow65%");
                gradeArray.push("65%andabove");

                grade.push("55%");
                grade.push("55%-58%");
                grade.push("58%-60%");
                grade.push("60%-62%");
                grade.push("62%-65%");
                grade.push("65%");

                type.push("Fines");
                type.push("Lumps");
                type.push("Concentrates");
                type.push("ROM");

                month = $("#month option:selected").text();
                year = $("#year option:selected").text();

                for (var l = 0; l < 4; l++) {
                    loadData(type, l);
                }
                getRoyaltyForDashBoard(type);
                $('#month').on('change', function() {
                    month = $("#month option:selected").val();
                    getRoyaltyForDashBoard(type);
                    for (var l = 0; l < 4; l++) {
                        loadData(type, l);
                    }
                });

                $('#year').on('change', function() {
                    year = $("#year option:selected").val();
                    getRoyaltyForDashBoard(type);
                    for (var l = 0; l < 4; l++) {
                        loadData(type, l);
                    }
                });

                function loadData(type, count) {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });

                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getGradeDataForChart',
                            data: {
                                type: type[count],
                                year: year,
                                month: month
                            },
                            success: function(response) {
                                GradeRateList = JSON.parse(response);
                                var gradeData = new google.visualization.DataTable();
                                gradeData.addColumn('string', 'Grade (' + type[count] + ')');
                                gradeData.addColumn('number', 'IBM');
                                gradeData.addColumn('number', 'Royalty');
                                gradeData.addColumn('number', 'GIOPF');
                                var Baroptions = {
                                    width: 620,
                                    height: 340,
                                    vAxis: {
                                        title: 'Rate',
                                        format: 'decimal'
                                    },
                                    colors: ['#1b9e77', '#d95f02', '#7570b3']
                                };
                                var array = [];
                                for (var i = 0; i < 6; i++) {
                                    array = [];
                                    array.push(grade[i]);
                                    for (var j = 0; j < 3; j++) {
                                        array.push(Number(GradeRateList["chartQuantityRoot"][j][gradeArray[i]]));
                                    }
                                    gradeData.addRows([array]);
                                    id = type[count] + 'Graph';
                                    var formatter = new google.visualization.NumberFormat({
                                        pattern: '#,###.00'
                                    });
                                    formatter.format(gradeData, 1);
                                    formatter.format(gradeData, 2);
                                    formatter.format(gradeData, 3);
                                    var rateChart = new google.charts.Bar(document.getElementById(id));
                                    rateChart.draw(gradeData, google.charts.Bar.convertOptions(Baroptions));
                                }
                            }
                        });
                    }
                }

                function getRoyaltyForDashBoard(typeGrade) {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });

                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getRoyaltyForDashBoard',
                            data: {
                                year: year,
                                month: month
                            },
                            success: function(response) {
                                challanQtyList = JSON.parse(response);
                                var challanData = new google.visualization.DataTable();
                                challanData.addColumn('string', 'Grade');
                                challanData.addColumn('number', 'Royalty');
                                challanData.addColumn('number', 'Quantity');
                                var options = {
                                    width: 1280,
                                    height: 300,
                                    vAxis: {
                                        //title: 'Quantity',
                                        format: 'decimal'
                                    },
                                    series: {
			                             0: {
			                                 axis: 'Royalty'
			                             },
			                             1: {
			                                 axis: 'Quantity'
			                             }
	                         },
	                         axes: {
	                             y: {
	                                 Royalty: {
	                                     label: 'Royalty'
	                                 },
	                                 Quantity: {
	                                     label: 'Quantity',
	                                     minValue: 0
	                                 }
	                             }
	                         },colors: ['#1b9e77', '#d95f02']
	                         
                                };
                                var array = [];
                                for (var i = 0; i < 4; i++) {
                                    array = [];
                                    array.push(typeGrade[i]);
                                    for (var j = 0; j < 2; j++) {
                                        if (challanQtyList["challanQtyRoot"][j][type[i]] == undefined) {
                                            array.push(0);
                                        } else {
                                            array.push(Number(challanQtyList["challanQtyRoot"][j][type[i]]));
                                        }
                                    }
                                    challanData.addRows([array]);
                                    var formatter = new google.visualization.NumberFormat({
                                        pattern: '#,###.00'
                                    });
                                    formatter.format(challanData, 1);
                                    formatter.format(challanData, 2);
                                    var challanQtyChart = new google.charts.Bar(document.getElementById('royaltyGraph'));
                                    challanQtyChart.draw(challanData, google.charts.Bar.convertOptions(options));
                                }
                            }
                        });
                    }
                }
                var table;
                var table = $('#gradeDataTableId').DataTable({
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
                        "data": "typeIndex"
                    }, {
                        "data": "GradeIndex"
                    }, {
                        "data": "IBMIndex"
                    }, {
                        "data": "royaltyIndex"
                    }, {
                        "data": "giopfIndex"
                    }, ]
                });

                $('#FinesGraph').on('click', function(event) {
                    string = $(this).attr("id");
                    gradeType = string.substring(0, string.length - 5);
                    getData(gradeType);
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('#LumpsGraph').on('click', function(event) {
                    string = $(this).attr("id");
                    gradeTypeL = string.substring(0, string.length - 5);
                    getData(gradeTypeL);
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('#ConcentratesGraph').on('click', function(event) {
                    string = $(this).attr("id");
                    gradeTypeC = string.substring(0, string.length - 5);
                    getData(gradeTypeC);
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('#ROMGraph').on('click', function(event) {
                    string = $(this).attr("id");
                    gradeTypeR = string.substring(0, string.length - 5);
                    getData(gradeTypeR);
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('.cd-panel').on('click', function(event) {
                    if ($(event.target).is('.cd-panel') || $(event.target).is('.cd-panel-close')) {
                        $('.cd-panel').removeClass('is-visible');
                        event.preventDefault();
                    }
                });

                function getData(gradeType) {
                    $.ajax({
                        url: "<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getGradeData",
                        data: {
                            gradeType: gradeType,
                            month: month,
                            year: year
                        },
                        success: function(response) {
                            response = JSON.parse(response);
                            table.clear().draw();
                            table.rows.add(response).draw();
                        }
                    });
                }
            </script>
        </body>

        </html>