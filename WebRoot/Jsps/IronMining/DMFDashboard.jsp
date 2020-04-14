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
            <title>DMF</title>
            <meta name="description" content="">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/wrap-styles.css">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/panel-style.css">
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css">
            <style>
				.col-md-6 {
				    width: 52%;
				}
				.cd-panel-content{
					padding-top: 33px;
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
			    .graphs {
			     	float: right;
    				width: 40%;
			     }
			    .images{
			     	float: left;
   					width: 60%;
			     }
			     #imagerow1,#imagerow2,#imagerow3,#imagerow4{
			     	padding-bottom:28px;
			     }
			     #typeDmfTableId_filter {
                    height: 0px;
                    visibility: collapse;
                }
                #pieChartTableId_filter{
                	 height: 0px;
                	 visibility: collapse;
                }
                table.dataTable td {
   					border-bottom : 1px solid grey;
				}
				table.dataTable {
    				border-collapse: separate;
				}
                .io-inner-header {
                    background-color: #1D5D8D;
                    padding-bottom: 10px;
                    position: sticky;
                    width: 100%;
                    z-index: 99;
                    top: 0;
                }
                p {
				    margin: -22px 0 10px;
				}
            </style>
        </head>

        <body class="dashboard-bg">
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
            <!-- Header -->
             <!-- Breadcrumb -->
            <div class="container-fluid" id="heading">
                <div class="io-breadcrumb">
                    <ol class="breadcrumb">
                        <li><a href="/Telematics4uApp/Jsps/IronMining/Dashboard.jsp">Dashboard</a></li>
                        <li class="active">DMF DETAILS</li>
                    </ol>
            	</div>
              
                <!-- filter -->
<!--                <div class="ibm-filter">-->
<!--                    <div class="filter-financialYear">-->
<!--                    <select class="form-control" id="financialYear">-->
<!--                    <option value="">Select Year</option>-->
<!--                    <option >2015-2016</option>-->
<!--					<option >2016-2017</option>-->
<!--					<option selected>2017-2018</option>-->
<!--					<option >2018-2019</option>-->
<!--					<option >2019-2020</option>-->
<!--               		</select>-->
<!--                    </div>-->
<!--                    <div class="clearfix"></div>-->
<!--                </div>-->
            </div>
            <!-- //filter -->
            <!-- Breadcrumb -->
            <!-- Image Panel -->
            <div class="images">
                <div class="container-fluid">
                    <div class="row" id="imagerow1">
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/afforestation.jpg" alt="logo_1">
                                   <p id="AFORRESTATION"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/drinking_water.jpg" alt="logo_1">
                                  <p class="font-dark" id="DRINKING WATER"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/education.jpg" alt="logo_1">
                                  <p id="EDUCATION"></p>
                             </div>
                        </div>
                    </div>
                    <div class="row" id="imagerow2">
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/electrification.jpg" alt="logo_1" style="height: 160px;width: 240px;">
                                  <p id="ELECTRIFICATION"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/enviroment.jpg" alt="logo_1">
                                  <p id="ENVIRONMENT"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/health_care.jpg" alt="logo_1">
                                  <p id="HEALTH CARE"></p>
                             </div>
                        </div>
                    </div>
                    <div class="row" id="imagerow3">
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/housing.jpg" alt="logo_1">
                                  <p id="HOUSING"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/infrastructure.jpg" alt="logo_1">
                                  <p id="INFRASTRUCTURE"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/irrigation.jpg" alt="logo_1">
                                  <p id="IRRIGATION"></p>
                             </div>
                        </div>
                    </div>
                    <div class="row" id="imagerow4">
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/sanitation.jpg" alt="logo_1">
                                  <p id="SANITATION"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/skill_development.jpg" alt="logo_1">
                                  <p id="SKILL DEVELOPMENT"></p>
                             </div>
                        </div>
                        <div class="col-md-4">
                             <div class="thumb-img">
                                  <img src="/ApplicationImages/DMGDashboard/sports.jpg" alt="logo_1">
                                  <p id="SPORTS"></p>
                             </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Image Panel -->
            <!-- Graph Panel -->
             <div class="graphs">
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
            <!-- Graph Panel -->
            <!-- Panel -->
            <div class="cd-panel from-right">
                <div class="cd-panel-container">
                    <div class="cd-panel-content">
                        <a href="#0" class="cd-panel-close">Close</a>
                        <div class="production-summary" id="typeDmfTableDiv">
                            <table id="typeDmfTableId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th>TYPE</th>
                                        <th>NORTH DMF</th>
                                        <th>SOUTH DMF</th>
                                        <th>TOTAL DMF</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="production-summary" id="pieChartDiv">
                            <table id="pieChartTableId" class="stripe" cellspacing="0" width="100%">
                                <thead style="font-size:12px;background: lightseagreen !important;">
                                    <tr>
                                        <th>SNO</th>
                                        <th>TOTAL NORTH DMF</th>
                                        <th>TOTAL SOUTH DMF</th>
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
                var typeWiseJSList;
                var financialYear;
                var pieJSONList;
                var count = 0;
                //financialYear = $("#financialYear option:selected").text();
                loadPieChartDetails();
                loadLineGraphDetails("NORTHDMF","SOUTHDMF");

                function loadPieChartDetails() {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });

                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getTotalDmfForFinancialYear',
                            data: {
                            	//financialYear:financialYear
                            },
                            success: function(response) {
                                    pieJSONList = JSON.parse(response);
                                    var Nroyalty = pieJSONList["totalDmfRoot"][0].NORTHDMF;
                                    var Sroyalty = pieJSONList["totalDmfRoot"][0].SOUTHDMF;
                                   
                                    var data = google.visualization.arrayToDataTable([
                                        ['Task', 'Quantity'],
                                        ['NORTH DMF', Number(Nroyalty)],
                                        ['SOUTH DMF', Number(Sroyalty)]
                                    ]);
                                    var options = {
                                    	title: 'TOTAL DMF AMOUNT-MAJOR MINERAL',
                                        height: 380,
                                        width: 525,
                                        pieSliceText: 'value-and-percentage',
                                        backgroundColor: 'rgb(36, 40, 68)',//'#262626',
                                        titleTextStyle: {
        									color: 'white'
    									},
    									legend: {
									        textStyle: {
									            color: 'white'
									        }
									    }
                                    };
                                     var chart = new google.visualization.PieChart(document.getElementById('majorPieChart'));
							         chart.draw(data, options);
                                }
                        });
                    }
                }
                function loadLineGraphDetails(DMFtype,DMFtype1) {
                    google.charts.load('current', {
                        'packages': ['line', 'corechart', 'bar']
                    });
                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getTypeWiseDMFDeatils',
                            data: {
                            	//financialYear:financialYear
                            },
                            success: function(response) {
                                    typeWiseJSList = JSON.parse(response);        
                                    var data =new google.visualization.DataTable();
                                    data.addColumn('string', 'Type');
      								data.addColumn('number', DMFtype);
      								data.addColumn('number', DMFtype1);
      									
      								for(var i=0;i<12;i++){
      									document.getElementById(typeWiseJSList["TypeWisedmfDetailsRoot"][i].TYPE).innerHTML = 
      									typeWiseJSList["TypeWisedmfDetailsRoot"][i].TYPE+'<br/>'+'INR '+typeWiseJSList["TypeWisedmfDetailsRoot"][i].TOTALDMF;
      									var arr=[];
      									arr.push(typeWiseJSList["TypeWisedmfDetailsRoot"][i].TYPE);
      									arr.push(Number(typeWiseJSList["TypeWisedmfDetailsRoot"][i][DMFtype]));
      									arr.push(Number(typeWiseJSList["TypeWisedmfDetailsRoot"][i][DMFtype1]));
      									data.addRows([arr]);
      								}	
                                    var options = {
                                    	title: 'Type WISE DMF',
                                        height: 350,
                                        width: 525,
                                        backgroundColor: 'rgb(36, 40, 68)',
                                        colors: ['yellow','red'],
                                        hAxis: { 
									        direction: 1, 
									        slantedText: true, 
									        slantedTextAngle: 315, // here you can even use 180 
									        textStyle: {
									            color: 'white'
									        },
									        titleTextStyle: {
									            color: 'white'
									        }
									    },
									    vAxis: {
									        textStyle: {
									            color: 'white'
									        },
									        titleTextStyle: {
									            color: 'red'
									        }
									    },
									    titleTextStyle: {
        									color: 'white'
    									},
    									legend: {
									        textStyle: {
									            color: 'white'
									        }
									    }
                                    };
                                    var chart = new google.visualization.LineChart(document.getElementById('currentLineGraph'));
                                    chart.draw(data, options);
                                }
                        });
                    }
                }
                
                $('#currentLineGraph').on('click', function(event) {
	                $('#typeDmfTableDiv').show();
	                $('#pieChartDiv').hide();
                    getLineChartData();
                    event.preventDefault();
                    $('.cd-panel').addClass('is-visible');
                });
                $('#majorPieChart').on('click', function(event) {
                	 $('#typeDmfTableDiv').hide();
                	 $('#pieChartDiv').show();
                     getPieChartData();
                     event.preventDefault();
                     $('.cd-panel').addClass('is-visible');
                });
                $('.cd-panel').on('click', function(event) {
                    if ($(event.target).is('.cd-panel') || $(event.target).is('.cd-panel-close')) {
                        $('.cd-panel').removeClass('is-visible');
                        event.preventDefault();
                    }
                });
                function getLineChartData() {
                    var TypeWiseDMFTable = $('#typeDmfTableId').DataTable({
                    "autoWidth": true,
                    "scrollX": true,
                    "scrollY": false,
                    "bFilter": true,
                    "bRetrieve": true,
                    "bStateSave": true,
                    "bPaginate": false,
                    "info": false,
                    "columnDefs": [
                       { className: "dt-right", "targets": [1,2,3]},
                    ],
                    "columns": [{
                        "data": "TYPE"
                    }, {
                        "data": "NORTHDMF"
                    },{
                        "data": "SOUTHDMF"
                    }, {
                        "data": "TOTALDMF"
                    }]
                });
                TypeWiseDMFTable.clear().draw();
                TypeWiseDMFTable.rows.add(typeWiseJSList["TypeWisedmfDetailsRoot"]).draw();
                }
                function getPieChartData() {
                var pieTable = $('#pieChartTableId').DataTable({
                    "autoWidth": true,
                    "scrollX": true,
                    "bFilter": true,
                    "bRetrieve": true,
                    "bStateSave": true,
                    "bPaginate": false,
                    "info": false,
                    "columnDefs": [
                       { className: "dt-right", "targets": [1,2]},
                    ],
                    "columns": [{
                        "data": "SLNO"
                    },{
                        "data": "NORTHDMF"
                    }, {
                        "data": "SOUTHDMF"
                    }]
                });
                	pieTable.clear().draw();
                    pieTable.rows.add(pieJSONList["totalDmfRoot"]).draw();
                }
                
            </script>
        </body>

        </html>