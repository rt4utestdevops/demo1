<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
Calendar cal = Calendar.getInstance();
SimpleDateFormat formatter = new SimpleDateFormat("MMM");
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
String date1 = formatter.format(dt1).toUpperCase()+"-"+d1;
String d2 = formatter1.format(dt2);
String date2 = formatter.format(dt2).toUpperCase()+"-"+d2;
String d3 = formatter1.format(dt3);
String date3 = formatter.format(dt3).toUpperCase()+"-"+d3;
String d4 = formatter1.format(dt4);
String date4 = formatter.format(dt4).toUpperCase()+"-"+d4;
String d5 = formatter1.format(dt5);
String date5 = formatter.format(dt5).toUpperCase()+"-"+d5;
String d6 = formatter1.format(dt6);
String date6 = formatter.format(dt6).toUpperCase()+"-"+d6;
String d7 = formatter1.format(dt7);
String date7 = formatter.format(dt7).toUpperCase()+"-"+d7;
%>

<html>
	<head>
		<meta charset="UTF-8">
		<title>AdminLTE 2 | Dashboard</title>
		<link rel="stylesheet"
			href="../../Main/modules/sandMining/dashBoard/bootstrap/css/bootstrap.min.css"
			type="text/css"></link>
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<script type = "text/javascript" src="../../Main/Js/jsapi.js"></script><pack:script src="../../Main/modules/outDoorHordings/js/javascript.js"></pack:script>
		<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
		<pack:script src="../../Main/modules/outDoorHordings/js/jqueryjson.js"></pack:script>
		<!-- grid start	-->
		<script
			src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
		<link rel="stylesheet"
			href="https://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css">
		<!-- grid ends	-->
		<style>
table tr td {
	color: brown;
	font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif;
	font-style: normal;
	font-weight: normal;
	font-size: 10px;
}

.odd:hover td {
	color: #57DC57 !important
}

.even:hover td {
	color: #57DC57 !important
}

table th {
	color: #CB9F7B !important;
}

.odd td {
	color: #888484 !important;
	font-size: 12px;
}

.even td {
	color: #888484 !important;
	font-size: 12px;
}

.row {
	max-width: 100%;
	margin: 0px;
	padding: 0px;
}

tr td a {
	position: relative;
	top: 0px;
	bottom: 0px;
	left: 0px;
	right: 0px;
}

.textstyleforsmallerfont {
	font-size: 15px;
	font-family: sans-serif;
	color: #fff;
	font-weight: 300;
	margin-left: 18px;
}

.textstyleforbiggerrfont {
	font-size: 25px;
	font-family: sans-serif;
	color: #fff;
	font-weight: 700;
	margin-left: 17px;
}

.averagTime {
	margin-top: 10%;
}

.digitStyle {
	font-size: 55px;
	color: #fff;
	font-family: sans-serif;
	font-weight: 500;
	margin-left: 4px;
}

.digitStyleForSurv {
	font-size: 40px;
	color: #fff;
	font-family: sans-serif;
	font-weight: 500;
	margin-left: 7%;
}

.inProcessId {
	margin-top: 17%;
	margin-left: 12%;
}

.navbar {
	margin-bottom: 0px !important;
}

.carousel-caption {
	margin-top: 0px !important
}
}
</style>
	</head>
	<body
		style="background-image: url(/ApplicationImages/DashBoard/bgimage.png) !important; background-repeat: no-repeat; background-size: cover; width: 98%;">

		<!-- Main content -->
		<section class="content">
		<!-- Small boxes (Stat box) -->
		<div class="row">
			<div class="col-lg-6 col-xs-4">
				<!-- small box -->
				<div class="small-box">
					<div class="inner" style="height: 590px; margin-left: 30px;">
						<div class="icon">
							<div class="col-lg-12"
								style="background-image: url(/ApplicationImages/DashBoard/waitingbox.png); background-repeat: no-repeat; background-size: cover;">
								<!-- small box -->
								<div class="small-box">
									<div class="inner" style="height: 184px; margin-top: 6px;">
										<div class="icon">
											<div class="col-lg-6">
												<!-- small box -->
												<div class="small-box">
													<div class="inner" id="waitingTime"
														style="height: 165px; margin-top: 6px;"
														onclick="loadGrid();">
														<div class="icon">
															<div class="averagTime">
																<span class="textstyleforsmallerfont">Average</span>
																<br />
																<span class="textstyleforbiggerrfont">WAITING
																	TIME</span>
																<br />
																<span class="textstyleforbiggerrfont" id="waiting_time"
																	style="font-size: 40px;"></span><br />
																<span id="HHmmText1" style="padding-left: 46px;color: lightgoldenrodyellow;">HH  MM</span>
																	
																<br />
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-lg-6">
												<!-- small box -->
												<div class="small-box">
													<div class="inner" id="loadingTime"
														style="height: 165px; margin-top: 6px;"
														onclick="loadGrid();">
														<div class="icon">
															<div class="averagTime">
																<span class="textstyleforsmallerfont">Average</span>
																<br />
																<span class="textstyleforbiggerrfont">LOADING
																	TIME</span>
																<br />
																<span class="textstyleforbiggerrfont" id="loading_time"
																	style="font-size: 40px;"></span><br />
																<span id="HHmmText2" style="padding-left: 46px;color: lightgoldenrodyellow;">HH  MM</span><br />
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-12"
								style="background-image: url(/ApplicationImages/DashBoard/waitingbox.png); background-repeat: no-repeat; background-size: cover;">
								<!-- small box -->
								<div class="small-box">
									<div class="inner" style="height: 184px; margin-top: 10px;">
										<div class="icon">
											<div class="col-lg-8">
												<!-- small box -->
												<div class="small-box">
													<div class="inner" id="unauthorized"
														style="height: 165px; margin-top: 6px;">
														<div class="icon">
															<div class="col-lg-5"
																style="background-image: url(/ApplicationImages/DashBoard/box_two_circles_icon.png); background-repeat: no-repeat; background-size: 160px; height: 160px;">

															</div>
															<div class="col-lg-5">
																<span
																	style="font-size: 20px; color: #990000; margin-right: 25px;">UNAUTHORIZED</span>
																<br />
																<span
																	style="font-size: 15px; color: #171616; margin-right: 25px;">Reach
																	Entry</span>
																<hr style="border-top: 1px solid #FF0000;" />
															<a href="/Telematics4uApp/Jsps/ApOnline/UnAuthourizedReachEntry.jsp">	<span
																	style="font-size: 40px; color: #fff; margin-left: 28%;"
																	id="unauthorizedReachEntry"></span></a>
																<br />
															</div>
															<div class="col-lg-2"
																style="background-image: url(/ApplicationImages/DashBoard/box2_icon_truck.png);background-repeat: no-repeat;top: 70px; height: 55%;">

															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-lg-4">
												<!-- small box -->
												<div class="small-box">
													<div class="inner" id="topDistrict"
														style="height: 165px; margin-top: 6px; opacity: 0.6">
														<div class="icon"
															style="background-image: url(/ApplicationImages/DashBoard/box2 _top_district.png) !important;">
															<span
																style="font-size: 20px; color: #fff; margin-right: 25px;">Top
																District</span>
															<br />
															<span
																style="font-size: 15px; color: #fff; margin-right: 25px;"
																id="topDistrictName"></span>
															<hr style="border-top: 1px solid #FF0000;" />
															<span
																style="font-size: 40px; color: #fff; margin-left: 28%;"
																id="topDistrictId"></span>
															<br />
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>



							<div class="col-lg-12"
								style="background-image: url(/ApplicationImages/DashBoard/box3.png); background-repeat: no-repeat; background-size: cover;">
								<!-- small box -->
								<div class="small-box">
									<div class="inner" style="height: 184px; margin-top: 10px;">

										<div class="icon">
											<div class="col-lg-12">
												<!-- small box -->
												<div class="small-box">
													<div class="inner" style="height: 165px; margin-top: 6px;">

														<div class="icon">

															<div class="col-lg-6">
																<!-- small box -->
																<div class="small-box">
																	<div class="inner"
																		style="height: 150px; margin-top: 6px;">

																		<div class="icon">

																			<div class="col-lg-6">
																				<!-- small box -->
																				<div class="small-box">
																					<div id="inProcess" class="inner"
																						style="margin-top: 95px;">

																						<div class="icon">
																						<span style="font-size: 14px; color: #fff;margin-left: 23px;">In
																									Progress</span>
																								<br />
<span id="inProcessIds"	style="font-size: 40px; color: #fff; margin-left: 19%;"></span>
																						</div>

																					</div>

																				</div>
																			</div>

																			<div class="col-lg-6">
																				<!-- small box -->
																				<div class="small-box">
																					<div id="Closed" class="inner"
																						style=" margin-top: 95px;">

																						<div class="icon">
<span style="font-size: 14px; color: #fff;margin-left: 42px;">Closed</span>
																								<br />
																								<span id="closedIds"
																									style="font-size: 40px; color: #fff; margin-left: 23%;"></span>
																						</div>

																					</div>

																				</div>
																			</div>

																		</div>

																	</div>

																</div>
															</div>

															<div class="col-lg-6">
																<!-- small box -->
																<div class="small-box">
																	<div class="inner"
																		style="margin-top: 0px;font-size: 23px;color: #DDB34B;">
Trip Clearance
																		<div class="icon">
																			<div class="col-lg-6">
																				<!-- small box -->
																				<div class="small-box">
																					<div id="notcompleted" class="inner"
																						style="margin-top: 25px;">

																						<div class="icon">
<div class="notComltdId">
																								<span style="font-size: 14px; color: #fff;">Not</span>
																								<br />
																								<span style="font-size: 14px; color: #fff;">Completed</span>
																								<br />
																								<span id="notcompletedId"
																									style="font-size: 40px; color: #fff; "></span>
																							</div>
																						</div>

																					</div>

																				</div>
																			</div>

																			<div class="col-lg-6">
																				<!-- small box -->
																				<div class="small-box">
																					<div id="nodestinationfound" class="inner"
																						style="margin-top: 25px;">

																						<div class="icon">
<span style="font-size: 14px; color: #fff;">No</span>
																							<br />
																							<span style="font-size: 14px; color: #fff;">Destination
																								Found</span>
																							<br />
																							<span id="nodestinationfoundId"
																								style="font-size: 40px; color: #fff; "></span>
																						</div>

																					</div>

																				</div>
																			</div>
																		</div>

																	</div>

																</div>
															</div>

														</div>

													</div>

												</div>
											</div>




										</div>

									</div>

								</div>
							</div>
























							
						</div>
					</div>
				</div>
			</div>
			<!-- ./col -->
			<div class="col-lg-6 col-xs-4">
				<!-- small box -->
				<div class="small-box">
					<div class="inner" style="height: 590px; margin-right: 30px;">
						<div class="icon">
							<div class="col-lg-12">
								<!-- small box -->
								<div class="small-box">
									<div class="inner"
										style="height: 140px; background-image: url(/ApplicationImages/DashBoard/waitingbox.png); background-repeat: no-repeat; background-size: cover;">
										<div class="icon">
											<div class="col-lg-6">
												<!-- small box -->
												<div class="small-box">
													<div class="inner"
														style="height: 120px; margin-top: 10px; margin-left: 30px;"
														id="totalewaybill">
														<div class="icon">
															<div style="margin-top: 11%;">
																<span class="textstyleforbiggerrfont">TOTAL</span>
																<br />
																<span class="textstyleforsmallerfont">eWay Bill</span>
																<br />
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-lg-1">
												<!-- small box -->
												<div class="small-box">
													<div id="digit1" class="inner"
														style="height: 75px; margin-top: 15px; background-color: #DDB34B; border-radius: 15px;">

														<div class="icon">
															<span class="digitStyle" id="number1">0</span>
														</div>

													</div>
												</div>
											</div>
										</div>
										<div class="col-lg-1">
											<!-- small box -->
											<div class="small-box">
												<div id="digit2" class="inner"
													style="height: 75px; margin-top: 15px; background-color: #DDB34B; border-radius: 15px;">

													<div class="icon">
														<span class="digitStyle" id="number2">0</span>
													</div>
												</div>
											</div>
										</div>
										<div class="col-lg-1">
											<!-- small box -->
											<div class="small-box">
												<div id="digit3" class="inner"
													style="height: 75px; margin-top: 15px; background-color: #DDB34B; border-radius: 15px;">

													<div class="icon">
														<span class="digitStyle" id="number3">0</span>
													</div>
												</div>
											</div>
										</div>
										<div class="col-lg-1">
											<!-- small box -->
											<div class="small-box">
												<div id="digit4" class="inner"
													style="height: 75px; margin-top: 15px; background-color: #DDB34B; border-radius: 15px;">

													<div class="icon">
														<span class="digitStyle" id="number4">0</span>
													</div>
												</div>
											</div>
										</div>
										<div class="col-lg-1">
											<!-- small box -->
											<div class="small-box">
												<div id="digit5" class="inner"
													style="height: 75px; margin-top: 15px; background-color: #DDB34B; border-radius: 15px;">

													<div class="icon">
														<span class="digitStyle" id="number5">0</span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-12">
							<!-- small box -->
							<div class="small-box">
								<div class="inner" style="height: 130px; margin-top: 10px;">
									<div class="icon">
										<div class="col-lg-6">
											<!-- small box -->
											<div class="small-box">
												<div id="issuedTranSurv" class="inner"
													style="height: 110px; background-image: url(/ApplicationImages/DashBoard/waitingbox.png); background-repeat: no-repeat; background-size: cover;">
													<div class="icon">
														<div>
															<span class="textstyleforbiggerrfont">ISSUED &
																Under</span>
															<br />
															<span class="textstyleforsmallerfont">Transportation
																Surveillance</span>
															<br />
															<span class="digitStyleForSurv" id="issuedUnderTranSurv"></span>
															<br />
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="col-lg-6">
											<!-- small box -->
											<div class="small-box">
												<div id="nonIssuedTranSur" class="inner"
													style="height: 110px; background-image: url(/ApplicationImages/DashBoard/waitingbox.png); background-repeat: no-repeat; background-size: cover;">
													<div class="icon">
														<div>
															<span class="textstyleforbiggerrfont">ISSUED & not
																under</span>
															<br />
															<span class="textstyleforsmallerfont">Transportation
																Surveillance</span>
															<br />
															<span class="digitStyleForSurv"
																id="issuedNotUnderTranSurv">0000</span>
															<br />
															<div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-12" style="background-image: url(/ApplicationImages/DashBoard/waitingbox.png); background-repeat: no-repeat; background-size: cover;">
									<!-- small box -->
									<div class="small-box">
										<div class="inner" id="chart_div"
											style="height: 290px; margin-top: 10px; opacity: 0.6">
											<div class="icon">
											</div>
										</div>  
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-6 col-xs-4" id="dynamicDiv1">
			<div class="small-box">
				<div class="inner" style="height: 400px; margin-left: 30px;">
					<table id="example" class="table table-hover display"
						cellspacing="0" width="100%">
						<thead style="font-size: 12px; background: #F5F5F5 !important;">
							<tr>
								<th>
									Customer Name
								</th>
								<th>
									Average Waiting Time
								</th>
								<th>
									Average Loading Time
								</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
		<div class="col-lg-6 col-xs-4" style="width: 47.8%;" id="dynamicDiv2">
			<div class="small-box">
				<div class="inner" style="height: 400px;">
					<table id="example1" class="display" cellspacing="0" width="100%">
						<thead style="font-size: 12px; background: #F5F5F5 !important;">
							<tr>
								<th>
									Reach Name
								</th>
								<th>
									Average Waiting Time
								</th>
								<th>
									Average Loading Time
								</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
		</div>
		<!-- /.row -->
		<!-- Main row -->
		<div></div>
		</section>
		<!-- /.content -->
		<a href="http://www.google.com"></a>
		<script>
      	var serpDashboardElementList;
      	var table1;
      	var table2;
      	$("#dynamicDiv1").hide();
        $("#dynamicDiv2").hide();
        google.load("visualization", "1", {packages:["corechart"]});
		
	
      	
      	var revenueChart = {
			title: 'DAY WISE REVENUE',
            titleTextStyle: {
            	color: '#fff',
            	fontSize: 13
            },
            pieSliceText: "value",
            legend: {
                position: 'none'
            },
            sliceVisibilityThreshold: 0,
            height: 265,
            isStacked: true,
            backgroundColor: '#000000',
    		is3D: true,
            hAxis:{title:'DATES',textStyle:{fontSize: 9,color: '#FFF'},titleTextStyle: { italic: false,color: '#FFF'}},
            vAxis:{title:'REVENUE(RS)',textStyle:{fontSize: 9,color: '#FFF'},titleTextStyle: { italic: false,color: '#FFF'} }
        };
      	
      	google.setOnLoadCallback(drawChart);
             function drawChart() {

               var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('chart_div'));
               var data = google.visualization.arrayToDataTable([
    					['DAYS', 'REVENUE(RS)', { role: 'style' }],
    					['<%=date7%>',  37891580.000, '#DDB34B'],
    					['<%=date6%>',  9852335.000, '#DDB34B'],
    					['<%=date5%>',  74728710.000, '#DDB34B'],
    					['<%=date4%>',  89311589.000, '#DDB34B'],
    					['<%=date3%>',  71967477.000, '#DDB34B'],
    					['<%=date2%>',  25208088.000, '#DDB34B'],
    					['<%=date1%>',  12801900.000, '#DDB34B']
  					]);
    

               barchartrevenuegraph.draw(data, revenueChart);
        
              
             }
		    $.ajax({
	        url: '<%=request.getContextPath()%>/DashboardElementAction.do?param=serpDashboardElements',
	        success: function(result) {
	            serpDashboardElementList = JSON.parse(result);
	            var totalEwaybills = serpDashboardElementList["serpDashboardElementsRoot"][0].totalEwaybills;
	            var registerdEwaybills = serpDashboardElementList["serpDashboardElementsRoot"][0].registerdEwaybills;
				var NonregisterdEwaybills = serpDashboardElementList["serpDashboardElementsRoot"][0].NonregisterdEwaybills;
				var avgWaitingltsp = serpDashboardElementList["serpDashboardElementsRoot"][0].avgWaitingltsp;
				var avgLoadingTime = serpDashboardElementList["serpDashboardElementsRoot"][0].avgLoadingTime;
				var unauthorisedCount = serpDashboardElementList["serpDashboardElementsRoot"][0].unauthorisedCount;
				var completed = serpDashboardElementList["serpDashboardElementsRoot"][0].completed;
				var notcompleted = serpDashboardElementList["serpDashboardElementsRoot"][0].notcompleted;
				var inprogress = serpDashboardElementList["serpDashboardElementsRoot"][0].inprogress;
				var delaycompleted = serpDashboardElementList["serpDashboardElementsRoot"][0].delaycompleted;
				var destnotfound = serpDashboardElementList["serpDashboardElementsRoot"][0].destnotfound;
				
				var waybill7 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill7;
				var waybill6 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill6;
				var waybill5 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill5;
				var waybill4 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill4;
				var waybill3 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill3;
				var waybill2 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill2;
				var waybill1 = serpDashboardElementList["serpDashboardElementsRoot"][0].waybill1;
				
				var revenue7 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue7;
				var revenue6 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue6;
				var revenue5 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue5;
				var revenue4 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue4;
				var revenue3 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue3;
				var revenue2 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue2;
				var revenue1 = serpDashboardElementList["serpDashboardElementsRoot"][0].revenue1;
				
				var topCount = serpDashboardElementList["serpDashboardElementsRoot"][0].topCount;
				var topDistrict = serpDashboardElementList["serpDashboardElementsRoot"][0].topDistrict;
	            
	            document.getElementById('waiting_time').innerHTML = avgWaitingltsp;
	            document.getElementById('loading_time').innerHTML = avgLoadingTime;
	            document.getElementById('unauthorizedReachEntry').innerHTML = unauthorisedCount;
	            document.getElementById('topDistrictId').innerHTML = topCount;
	            document.getElementById('topDistrictName').innerHTML = topDistrict;
	            document.getElementById('issuedUnderTranSurv').innerHTML = registerdEwaybills;
				document.getElementById('issuedNotUnderTranSurv').innerHTML = NonregisterdEwaybills; 
				document.getElementById('inProcessIds').innerHTML = inprogress;
				document.getElementById('closedIds').innerHTML =  completed;
				document.getElementById('notcompletedId').innerHTML = notcompleted; 
				document.getElementById('nodestinationfoundId').innerHTML = destnotfound;
	            var count = totalEwaybills.toString();
			    var res = count.split("");
			    var val1 = res[0];
			    var val2 = res[1];
			    var val3 = res[2];
			    var val4 = res[3];
			    var val5 = res[4];
			    document.getElementById('number1').innerHTML = val1; 
				document.getElementById('number2').innerHTML = val2;
				document.getElementById('number3').innerHTML =  val3;
				document.getElementById('number4').innerHTML = val4; 
				document.getElementById('number5').innerHTML = val5;
			    
	        }
	    });
	    function loadGrid(){
	    	$("#dynamicDiv1").show();
    		if(table1 != undefined){
			  	table1.destroy();
			 }
		 	table1 = $('#example').DataTable({
		          "ajax": {
		          "url": "<%=request.getContextPath()%>/DashboardElementAction.do?param=waitingLoadingTime",
		          "dataSrc": "waitingLoadingTimeRoot",
		          "scrollY": "200px",
        		  "scrollCollapse": true,
        		  "paging": false
		          },
		          "columns": [
					    {"data":"custnameId"},
						{"data":"waitingDistrict"},
						{"data":"loadingDistrict"}
						]
		   		});
		   $('#example tbody ').on( 'click','tr',function () {
		    	var data = table1.row( $(this) ).data();
		    	var custName = (data['custnameId']);
		    	loadSecondGrid(custName);
		   });
	    }
	    function loadSecondGrid(custName){
	    	$("#dynamicDiv2").show();
	    	if(table2 != undefined){
			  	table2.destroy();
			 }
		 	table2 = $('#example1').DataTable({
		          "ajax": {
		          "url": "<%=request.getContextPath()%>/DashboardElementAction.do?param=reachwaitingLoadingTime",
		          "data":{
		           	custName:custName
		           	},
		          "dataSrc": "reachwaitingLoadingTimeRoot",
		          "scrollY": "10000px",
        		  "scrollCollapse": true,
        		  "paging": false
		          },
		          "columns": [
					    {"data":"reachName"},
						{"data":"waitingReach"},
						{"data":"loadingReach"}
						]
		   		});
	    }
      </script>
	</body>
</html>
