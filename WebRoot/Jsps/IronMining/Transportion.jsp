<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
		}
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		if(str.length>12){
			loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	int systemId = loginInfo.getSystemId();
	int userId=loginInfo.getUserId(); 
	int customerId = loginInfo.getCustomerId();
	
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat formatter = new SimpleDateFormat("MMMMMMMMMMMMMMMMM");
	SimpleDateFormat formatter1 = new SimpleDateFormat("dd");
	int dayNum=0;
	cal.add(Calendar.DATE,-1);
	Date dt1=cal.getTime();
	int day1=cal.get(Calendar.DAY_OF_WEEK);
	cal.add(Calendar.DATE,-1);
	Date dt2=cal.getTime();
	int day2=cal.get(Calendar.DAY_OF_WEEK);
	cal.add(Calendar.DATE,-1);
	Date dt3=cal.getTime();
	int day3=cal.get(Calendar.DAY_OF_WEEK);
	cal.add(Calendar.DATE,-1);
	Date dt4=cal.getTime();
	int day4=cal.get(Calendar.DAY_OF_WEEK);
	cal.add(Calendar.DATE,-1);
	Date dt5=cal.getTime();
	int day5=cal.get(Calendar.DAY_OF_WEEK);
	cal.add(Calendar.DATE,-1);
	Date dt6=cal.getTime();
	int day6=cal.get(Calendar.DAY_OF_WEEK);
	cal.add(Calendar.DATE,-1);
	Date dt7=cal.getTime();
	int day7=cal.get(Calendar.DAY_OF_WEEK);
	String d1 = formatter1.format(dt1);
	String date1 = formatter.format(dt1).toUpperCase()+d1;
	String d2 = formatter1.format(dt2);
	String date2 = formatter.format(dt2).toUpperCase()+d2;
	String d3 = formatter1.format(dt3);
	String date3 = formatter.format(dt3).toUpperCase()+d3;
	String d4 = formatter1.format(dt4);
	String date4 = formatter.format(dt4).toUpperCase()+d4;
	String d5 = formatter1.format(dt5);
	String date5 = formatter.format(dt5).toUpperCase()+d5;
	String d6 = formatter1.format(dt6);
	String date6 = formatter.format(dt6).toUpperCase()+d6;
	String d7 = formatter1.format(dt7);
	String date7 = formatter.format(dt7).toUpperCase()+d7;

%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="refresh" content="3000" />

    <title>DMG</title>

    <!-- Bootstrap Core CSS -->
    <link href="../../Main/modules/ironMining/dashBoard/bootStrap/bootstrap.min.css" rel="stylesheet">
    <link href="../../Main/modules/ironMining/dashBoard/bootStrap/styles.css" rel="stylesheet">
    <link href="../../Main/modules/ironMining/dashBoard/bootStrap/toggle-switch.css" rel="stylesheet">

    <link rel="stylesheet" type="text/css" 
          href="../../Main/modules/ironMining/dashBoard/fonts/font-awesome/css/font-awesome.min.css">
          <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/wrap-styles.css">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/panel-style.css">
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css">
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900italic,900' rel='stylesheet' type='text/css'>
    
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
	
	<!-- jQuery Version 1.11.1 -->
    <script src="../../Main/modules/ironMining/dashBoard/js/jquery.js"></script>
    <script src="../../Main/modules/ironMining/dashBoard/js/jqueryjson.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="../../Main/modules/ironMining/dashBoard/js/bootstrap.min.js"></script>
    <script src="../../Main/modules/ironMining/dashBoard/js/main.js"></script>
		
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<style>
.graph-content{
	padding-top:0px;
}
.circle-content{
	padding-top:0px;
}
#donut_chart{
	height: 144px;
	padding-left: 53px;
	margin-top: -22px;
}
.col-lg-8{
  width:99% !important;
}
.tripsheet-status-wrap .elem h2 {
    font-size: 36px !important;
    width: 294px !important;
}
.tripsheet-status-cont{
	width: 294px !important;
}
#bar_id{
 	float:right;
}
#line_id{
 	float:right;
}
#permit_count{
	float:right;
}
.form-control{
	width:49%;
}
.col-xs-3 {
    width: 10%;
}
#cust_label{
	font-size: 14px;
}
.io-breadcrumb {
    float: left;
    padding-top: 70px;
}
.page-content .panel-default {
    background: transparent;
    border: solid #cccccc 1px;
    padding: 0px 10px;
    height: 350px;
    border-radius: 8px;
}
.io-breadcrumb .breadcrumb {
    padding: 0px 0px;
    margin-bottom: 9px;
    background-color: transparent;
}

</style>
<body oncontextmenu="return false;" >
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
    <!-- Page Content -->
    <div class="page-wrapper">
        <div class="container-fluid">
           <div class="io-breadcrumb">
                    <ol class="breadcrumb">
                        <li><a href="/Telematics4uApp/Jsps/IronMining/Dashboard.jsp">Dashboard</a></li>
                        <li class="active">Transportion</li>
                    </ol>
                </div>
            <div class="page-content">
              <div class="row">
                  <div class="col-lg-8 pad-right-0">
                    <div class="panel panel-default">
                                <div class="panel-heading">
                                  <div class="row">
                                      <div class="col-lg-2">
                                        <h3 class="panel-title">Tripsheet
                                        </h3>
                                      </div>
                                      <div class="col-lg-3">
                                          <div class="switch-toggle switch-background ">
                                              <input id="Truck" name="view6" type="radio" checked>
                                              <label for="Truck" onclick="viewContent('truck')">Truck</label>

                                              <input id="Barge" name="view6" type="radio">
                                              <label for="Barge" onclick="viewContent('barge')">Barge</label>

                                              <input id="Train" name="view6" type="radio">
                                              <label for="Train" onclick="viewContent('train')">Train</label>
                                              <a class="btn btn-switch"></a>
                                            </div>
                                      </div>
                                       <div class="col-lg-7 permit-count-heading text-right">
                                            Todays Data
                                       </div>
                                  </div>
                                  
                                </div>
                                <div class="panel-body">
                                 <div class="switch-content" id="truck">
                                    <div class=" tripsheet">
                                      <div class="col-lg-6 ">
                                        <div class="trip-issued">
                                          <span class="count" id="total_tripsheet"></span>
                                          <span><img src="/ApplicationImages/DashBoard/truck.png" alt="truck"></span>
                                        </div>
                                        <div class="trip-issued-title">
                                          <h5>Tripsheets issued</h5>
                                        </div>
                                        
                                      </div>
                                      <div class="col-lg-6">
                                        <div class="trip-issued">
                                            <span class="count" id="total_tripsheet_qty"></span>
                                            <span><img src="/ApplicationImages/DashBoard/machine.png" alt="machine"></span>
                                          </div>
                                          <div class="total-qty-title">
                                            <h5>Total Quantity(m/t)</h5>
                                          </div>
                                        
                                      </div>
                                      <div class="clearfix"></div>
                                    </div>
                                    <div class="tripsheet-status-wrap">
                                    <div class="tripsheet-status-cont">
                                      <div class="elem" >
                                        <h2 id="open_tripsheet"></h2>
                                        <h5>tripsheet open</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem" >
                                        <h2 id="closed_tripsheet"></h2>
                                        <h5>tripsheet closed</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2 id="open_Qty"></h2>
                                        <h5>in-transit quantity(m/t)</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem" >
                                        <h2 id="closed_Qty"></h2>
                                        <h5>Closed quantity</h5>
                                      </div>
                                     </div>
                                     <div class="clearfix"></div>
                                  </div>
                                </div>
                                <div class="switch-content" id="barge">
                                    <div class=" tripsheet">
                                      <div class="col-lg-6 ">
                                        <div class="trip-issued">
                                          <span class="count" id="total_barge"></span>
                                          <span><img src="/ApplicationImages/DashBoard/Barge.png" alt="truck"></span>
                                        </div>
                                        <div class="trip-issued-title">
                                          <h5>Tripsheets issued</h5>
                                        </div>
                                        
                                      </div>
                                      <div class="col-lg-6">
                                        <div class="trip-issued">
                                            <span class="count" id="total_barge_qty"></span>
                                            <span><img src="/ApplicationImages/DashBoard/machine.png" alt="machine"></span>
                                          </div>
                                          <div class="total-qty-title">
                                            <h5>Total Quantity(m/t)</h5>
                                          </div>
                                        
                                      </div>
                                      <div class="clearfix"></div>
                                    </div>
                                    <div class="tripsheet-status-wrap">
                                    <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2 id="open_barge"></h2>
                                        <h5>tripsheet open</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2 id="closed_barge"></h2>
                                        <h5>tripsheet closed</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2 id="open_barge_qty"></h2>
                                        <h5>in-transit quantity(m/t)</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2 id="closed_barge_qty"></h2>
                                        <h5>Closed quantity</h5>
                                      </div>
                                     </div>
                                     <div class="clearfix"></div>
                                  </div>
                                </div>
                                <div class="switch-content" id="train">
                                    <div class=" tripsheet">
                                      <div class="col-lg-6 ">
                                        <div class="trip-issued">
                                          <span class="count">0</span>
                                          <span><img src="/ApplicationImages/DashBoard/train.png" alt="truck"></span>
                                        </div>
                                        <div class="trip-issued-title">
                                          <h5>Tripsheets issued</h5>
                                        </div>
                                        
                                      </div>
                                      <div class="col-lg-6">
                                        <div class="trip-issued">
                                            <span class="count">0</span>
                                            <span><img src="/ApplicationImages/DashBoard/machine.png" alt="machine"></span>
                                          </div>
                                          <div class="total-qty-title">
                                            <h5>Total Quantity(m/t)</h5>
                                          </div>
                                        
                                      </div>
                                      <div class="clearfix"></div>
                                    </div>
                                    <div class="tripsheet-status-wrap">
                                    <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2>0</h2>
                                        <h5>tripsheet open</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2>0</h2>
                                        <h5>tripsheet closed</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2>0</h2>
                                        <h5>in-transit quantity(m/t)</h5>
                                      </div>
                                    </div>
                                     <div class="tripsheet-status-cont">
                                      <div class="elem">
                                        <h2>0</h2>
                                        <h5>Closed quantity</h5>
                                      </div>
                                     </div>
                                     <div class="clearfix"></div>
                                  </div>
                                </div>
                              </div>
                              <!-- panelbody-ends -->
                          </div>
                  </div>
              </div>
              <div class="row">
                <div class="col-lg-12">
                 <div class="panel panel-default pad-btm-nil">
                   <div class="panel-heading">
                        <h3 class="panel-title">Tripsheet Count Graph</h3>
                     </div>
                     <div class="col-lg-7 permit-count-heading text-right" id="line_id">
                          7 Days Data
                     </div>
                    <div class="panel-body"> 
                        <div class="graph-content"  id="line_chart">
                        </div>
                    </div>
                        </div>
                </div>
                
              </div>
              <!-- /.Tripsheet Block -->
              <div class="row">
                <div class="col-lg-12">
                 <div class="panel panel-default pad-btm-nil">
                   <div class="panel-heading">
                        <h3 class="panel-title">Tripsheet Quantity Graph</h3>
                     </div>
                     <div class="col-lg-7 permit-count-heading text-right" id="bar_id">
                          7 Days Data
                     </div>
                    <div class="panel-body"> 
                        <div class="graph-content"  id="bar_chart">
                        </div>
                    </div>
                        </div>
                </div>
              </div>
            </div>
           <!-- /.page-content -->
            

        </div>
        <!-- /.container-fluid -->

    </div>
    <!-- /.page-wrapper -->
    <a href="http://www.google.com"></a>
    <script>
     var dashBoardElementList;
	 var dashBoardTripSheetCount;
	 var lineChartCount;
	 var barChartDataList;
	 var customerList;
	 var dateArray = [];
	 var custId;
	 var challanperc;

	 dateArray.push('<%=date1%>');
	 dateArray.push('<%=date2%>');
	 dateArray.push('<%=date3%>');
	 dateArray.push('<%=date4%>');
	 dateArray.push('<%=date5%>');
	 dateArray.push('<%=date6%>');
	 dateArray.push('<%=date7%>');
	 getElementStore();
	 function getElementStore() {
	         $.ajax({
	             url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getTripSheetCountAndQuantity',
	             data: {
	                 CustId: custId
	             },
	             success: function(response) {
	                 dashBoardTripSheetCount = JSON.parse(response);

	                 document.getElementById('total_tripsheet').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].totalTripSheetCount;
	                 document.getElementById('total_tripsheet_qty').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].totalTripSheetQty;
	                 document.getElementById('open_tripsheet').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].openTripSheetCount;
	                 document.getElementById('open_Qty').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].openTripSheetQty;
	                 document.getElementById('closed_tripsheet').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].CloseTripSheetCount;
	                 document.getElementById('closed_Qty').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].CloseTripSheetQty;

	                 document.getElementById('total_barge').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].totalBargeTripSheetCount;
	                 document.getElementById('total_barge_qty').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].totalBargeTripSheetQty;
	                 document.getElementById('open_barge').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].openBargeTripSheetCount;
	                 document.getElementById('closed_barge').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].ClosedBargeTripSheetCount;
	                 document.getElementById('open_barge_qty').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].openBargeTripSheetQty;
	                 document.getElementById('closed_barge_qty').innerHTML = dashBoardTripSheetCount["tripsheetRoot"][0].ClosedBargeTripSheetQty;

	             }
	         });
	         google.charts.load('current', {
	             'packages': ['line', 'corechart', 'bar']
	         });
	         google.charts.setOnLoadCallback(drawChart);

	         function drawChart() {
	             $.ajax({
	                 url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getTripsheetCountForChart',
	                 data: {
	                     CustId: custId
	                 },
	                 success: function(response) {
	                     lineChartCount = JSON.parse(response);
	                     var data = new google.visualization.DataTable();
	                     data.addColumn('string', 'Days');
	                     data.addColumn('number', 'Truck');
	                     data.addColumn('number', 'Barge');
	                     //data.addColumn('number', 'Train');
	                     var options = {
	                         width: 1280,
	                         height: 280,
	                         vAxis: {
	                             format: 'decimal'
	                         },
	                         series: {
	                             0: {
	                                 axis: 'Truck'
	                             },
	                             1: {
	                                 axis: 'Barge'
	                             }
	                         },
	                         axes: {
	                             y: {
	                                 Truck: {
	                                     label: 'Truck Count',
	                                     minValue: 0
	                                 },
	                                 Barge: {
	                                     label: 'Barge Count'
	                                 }
	                             }
	                         }
	                     };
	                     var array = [];
	                     for (var i = 0; i < 7; i++) {
	                         array = [];
	                         array.push(dateArray[i]);
	                         for (var j = 0; j < 2; j++) {
	                             if (lineChartCount["chartCountRoot"][j][dateArray[i]] == undefined) {
	                                 array.push(0);
	                             } else {
	                                 array.push(lineChartCount["chartCountRoot"][j][dateArray[i]]);
	                             }
	                         }
	                         data.addRows([array]);
	                         var chart = new google.charts.Line(document.getElementById('line_chart'));
	                         chart.draw(data, google.charts.Bar.convertOptions(options));
	                     }
	                     console.log(array);
	                 }
	             });

	             $.ajax({
	                 url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getTripsheetQuantityForChart',
	                 data: {
	                     CustId: custId
	                 },
	                 success: function(response) {
	                     barChartDataList = JSON.parse(response);
	                     var QuantityData = new google.visualization.DataTable();
	                     QuantityData.addColumn('string', 'Days');
	                     QuantityData.addColumn('number', 'Truck');
	                     QuantityData.addColumn('number', 'Barge');
	                     //data.addColumn('string', 'Train');
	                     var Baroptions = {
	                         width: 1280,
	                         height: 280,
	                         vAxis: {
	                             title: 'Quantity',
	                             format: 'decimal'
	                         },
	                         colors: ['#1b9e77', '#d95f02', '#7570b3']
	                     };
	                     var array = [];
	                     for (var i = 0; i < 7; i++) {
	                         array = [];
	                         array.push(dateArray[i]);
	                         for (var j = 0; j < 2; j++) {
	                             if (barChartDataList["chartQuantityRoot"][j][dateArray[i]] == undefined) {
	                                 array.push(0);
	                             } else {
	                                 array.push(barChartDataList["chartQuantityRoot"][j][dateArray[i]]);
	                             }
	                         }
	                         QuantityData.addRows([array]);

	                         var quantityChart = new google.charts.Bar(document.getElementById('bar_chart'));
	                         quantityChart.draw(QuantityData, google.charts.Bar.convertOptions(Baroptions));
	                     }
	                 }
	             });
	         }
	 }
    </script>

</body>

</html>
