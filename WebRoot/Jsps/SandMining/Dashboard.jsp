<%@ page language="java" import="java.util.*,java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
int systemId = loginInfo.getSystemId();
String MDP="Total MDP";
String GPS="MDP Without GPS";
String title="DAY WISE PERMIT";
String vAxis="PERMIT ISSUED";

if(systemId==229){
  vAxis="EWAYBILL ISSUED";
  title="DAY WISE EWAYBILLS";
  MDP="Total eWayBill";
  GPS="eWayBill Without GPS";
}

String path = request.getContextPath();
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

<jsp:include page="../Common/header.jsp" />
<!--<html lang="en" class="no-js">  -->

		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title>DashBoard</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/dashBoard/css/component.css" />
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<script type = "text/javascript" src="../../Main/Js/jsapi.js"></script>
	
		<style>
			.noGps, .assetArrival, .permitsGenerated2{
				margin-left : 1px !important;
			}
			.dashboardElements {
				width: 152% !important;
				color : #ffff;
			}
			
		</style>
	<script type="text/javascript">
		window.onload = function () { 
			refresh();
		}
		google.load("visualization", "1", { packages: ["corechart"]});
		window.oncontextmenu = function () {return false;}
		var revenueChart = {
		    title: 'DAY WISE REVENUE',
		    titleTextStyle: {
		        color: '#686262',
		        fontSize: 13
		    },
		    pieSliceText: "value",
		    legend: {
		        position: 'none'
		    },
		    sliceVisibilityThreshold: 0,
		    height: 341,
		    isStacked: true,
		    backgroundColor: '#E4E4E4',
		    is3D: true,
		    hAxis: {
		        title: 'DATES',
		        textStyle: {
		            fontSize: 9
		        },
		        titleTextStyle: {
		            italic: false
		        }
		    },
		    vAxis: {
		        title: 'REVENUE(RS)',
		        viewWindow: {
		            min: 0
		        },
		        titleTextStyle: {
		            italic: false
		        }
		    }
		};

		var permitChart = {
		    title: '<%=title%>',
		    titleTextStyle: {
		        color: '#686262',
		        fontSize: 13
		    },
		    pieSliceText: "value",
		    legend: {
		        position: 'none'
		    },
		    sliceVisibilityThreshold: 0,
		    height: 331,
		    backgroundColor: '#E4E4E4',
		    is3D: true,
		    isStacked: true,
		    hAxis: {
		        title: 'DATES',
		        textStyle: {
		            fontSize: 9
		        },
		        titleTextStyle: {
		            italic: false
		        }
		    },
		    vAxis: {
		        title: '<%=vAxis%>',
		        viewWindow: {
		            min: 0
		        },
		        maxValue: 5,
		        gridlines: {
		            count: 6
		        },
		        titleTextStyle: {
		            italic: false
		        }
		    }
		};

		var dashBoardElements = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardElementAction.do?param=getDashboardElementsCount',
		    id: 'dashboardElementsCountId',
		    root: 'DashBoardElementCountRoot',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['totalAssetCount', 'commCount', 'nonCommLessThan24hrCount', 'nonCommGreaterThan24hrCount', 'noGpsCount', 'alertsCount', 'sandPermitsCount', 'assetArrivalSandPortCount', 'minimumPermitDivision', 'maximumPermitDivision', 'totalsandquantityId', 'totalewaybillsnogps']
		});

		var dashBoardRevenueChartStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardElementAction.do?param=getDashboardRevenueChart',
		    root: 'DashBoardRevenueChartRoot',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['sunrevenueIndex', 'monrevenueIndex', 'tuerevenueIndex', 'wedrevenueIndex', 'thurevenueIndex', 'frirevenueIndex', 'satrevenueIndex']
		});

		var dashBoardPermitChartStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardElementAction.do?param=getDashboardPermitChart',
		    root: 'DashBoardPermitChartRoot',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['sunpermitIndex', 'monpermitIndex', 'tuepermitIndex', 'wedpermitIndex', 'thupermitIndex', 'fripermitIndex', 'satpermitIndex']
		});

		function getDashboardElementsCount() {
		    dashBoardElements.load({
		        callback: function() {
		            for (var i = 0; i <= dashBoardElements.getCount() - 1; i++) {
		                var rec = dashBoardElements.getAt(i);
		                document.getElementById('totalAssetCountId').innerHTML = rec.data['totalAssetCount'];
		                document.getElementById('commCountId').innerHTML = rec.data['commCount'];
		                document.getElementById('nonCommLessThan24hrCountId').innerHTML = rec.data['nonCommLessThan24hrCount'];
		                document.getElementById('nonCommGreaterThan24hrCountId').innerHTML = rec.data['nonCommGreaterThan24hrCount'];
		                document.getElementById('noGpsCountId').innerHTML = rec.data['noGpsCount'];
		                //document.getElementById('alertsCountId').innerHTML = rec.data['alertsCount'];
		                document.getElementById('sandPermitsCountId').innerHTML = rec.data['sandPermitsCount'];
		                document.getElementById('assetArrivalSandPortCountId').innerHTML = rec.data['assetArrivalSandPortCount'];
		                //document.getElementById('minimumPermitDivisionId').innerHTML = rec.data['minimumPermitDivision'];
		                //document.getElementById('maximumPermitDivisionId').innerHTML = rec.data['maximumPermitDivision'];
		                document.getElementById('totalsandquantityId').innerHTML = rec.data['totalsandquantityId'];
		                document.getElementById('ewayBillwithoutgps').innerHTML = rec.data['totalewaybillsnogps'];
		            }
		        }
		    });

		    dashBoardRevenueChartStore.load({
		        callback: function() {
		            var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('revenuechartdiv'));
		            var rec = dashBoardRevenueChartStore.getAt(0);
		            var barchartrevenuedata = google.visualization.arrayToDataTable([
		                ['DAYS', 'REVENUE(RS)', {role: 'style'}],
		                ['<%=date7%>', parseInt(rec.data['sunrevenueIndex']), '#8CC22E'],
		                ['<%=date6%>', parseInt(rec.data['monrevenueIndex']), '#8CC22E'],
		                ['<%=date5%>', parseInt(rec.data['tuerevenueIndex']), '#8CC22E'],
		                ['<%=date4%>', parseInt(rec.data['wedrevenueIndex']), '#8CC22E'],
		                ['<%=date3%>', parseInt(rec.data['thurevenueIndex']), '#8CC22E'],
		                ['<%=date2%>', parseInt(rec.data['frirevenueIndex']), '#8CC22E'],
		                ['<%=date1%>', parseInt(rec.data['satrevenueIndex']), '#8CC22E']
		            ]);
		            barchartrevenuegraph.draw(barchartrevenuedata, revenueChart);
		        }
		    });

		    dashBoardPermitChartStore.load({
		        callback: function() {
		            var barchartpermitgraph = new google.visualization.ColumnChart(document.getElementById('permitchartdiv'));
		            var rec = dashBoardPermitChartStore.getAt(0);
		            var barchartpermitdata = google.visualization.arrayToDataTable([
		                ['DAYS', 'PERMIT ISSUED', {role: 'style'}],
		                ['<%=date7%>', parseInt(rec.data['sunpermitIndex']), '#19A0D9'],
		                ['<%=date6%>', parseInt(rec.data['monpermitIndex']), '#19A0D9'],
		                ['<%=date5%>', parseInt(rec.data['tuepermitIndex']), '#19A0D9'],
		                ['<%=date4%>', parseInt(rec.data['wedpermitIndex']), '#19A0D9'],
		                ['<%=date3%>', parseInt(rec.data['thupermitIndex']), '#19A0D9'],
		                ['<%=date2%>', parseInt(rec.data['fripermitIndex']), '#19A0D9'],
		                ['<%=date1%>', parseInt(rec.data['satpermitIndex']), '#19A0D9']
		            ]);
		            barchartpermitgraph.draw(barchartpermitdata, permitChart);
		        }
		    });
		}

		function refresh() {
		    dashBoardElements.load({
		        callback: function() {
		            for (var i = 0; i <= dashBoardElements.getCount() - 1; i++) {
		                var rec = dashBoardElements.getAt(i);
		                document.getElementById('totalAssetCountId').innerHTML = rec.data['totalAssetCount'];
		                document.getElementById('commCountId').innerHTML = rec.data['commCount'];
		                document.getElementById('nonCommLessThan24hrCountId').innerHTML = rec.data['nonCommLessThan24hrCount'];
		                document.getElementById('nonCommGreaterThan24hrCountId').innerHTML = rec.data['nonCommGreaterThan24hrCount'];
		                document.getElementById('noGpsCountId').innerHTML = rec.data['noGpsCount'];
		                //document.getElementById('alertsCountId').innerHTML = rec.data['alertsCount'];
		                document.getElementById('sandPermitsCountId').innerHTML = rec.data['sandPermitsCount'];
		                document.getElementById('assetArrivalSandPortCountId').innerHTML = rec.data['assetArrivalSandPortCount'];
		                //document.getElementById('minimumPermitDivisionId').innerHTML = rec.data['minimumPermitDivision'];
		                //document.getElementById('maximumPermitDivisionId').innerHTML = rec.data['maximumPermitDivision'];
		                document.getElementById('totalsandquantityId').innerHTML = rec.data['totalsandquantityId'];
		                document.getElementById('ewayBillwithoutgps').innerHTML = rec.data['totalewaybillsnogps'];

		            }
		            var el = document.getElementById('loadImage');
		            el.parentNode.removeChild(el);
		            var el1 = document.getElementById('dashboard-mask-id');
		            el1.parentNode.removeChild(el1);

		        }
		    });
		    dashBoardRevenueChartStore.load({
		        callback: function() {
		            var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('revenuechartdiv'));
		            var rec = dashBoardRevenueChartStore.getAt(0);
		            var barchartrevenuedata = google.visualization.arrayToDataTable([
		                ['DATES', 'Revenue(Rs)', {role: 'style'}],
		                ['<%=date7%>', parseInt(rec.data['sunrevenueIndex']), '#8CC22E'],
		                ['<%=date6%>', parseInt(rec.data['monrevenueIndex']), '#8CC22E'],
		                ['<%=date5%>', parseInt(rec.data['tuerevenueIndex']), '#8CC22E'],
		                ['<%=date4%>', parseInt(rec.data['wedrevenueIndex']), '#8CC22E'],
		                ['<%=date3%>', parseInt(rec.data['thurevenueIndex']), '#8CC22E'],
		                ['<%=date2%>', parseInt(rec.data['frirevenueIndex']), '#8CC22E'],
		                ['<%=date1%>', parseInt(rec.data['satrevenueIndex']), '#8CC22E']
		            ]);
		            barchartrevenuegraph.draw(barchartrevenuedata, revenueChart);
		        }
		    });

		    dashBoardPermitChartStore.load({
		        callback: function() {
		            var barchartpermitgraph = new google.visualization.ColumnChart(document.getElementById('permitchartdiv'));
		            var rec = dashBoardPermitChartStore.getAt(0);
		            var barchartpermitdata = google.visualization.arrayToDataTable([
		                ['DATES', 'EWAYBILL ISSUED', {role: 'style'}],
		                ['<%=date7%>', parseInt(rec.data['sunpermitIndex']), '#19A0D9'],
		                ['<%=date6%>', parseInt(rec.data['monpermitIndex']), '#19A0D9'],
		                ['<%=date5%>', parseInt(rec.data['tuepermitIndex']), '#19A0D9'],
		                ['<%=date4%>', parseInt(rec.data['wedpermitIndex']), '#19A0D9'],
		                ['<%=date3%>', parseInt(rec.data['thupermitIndex']), '#19A0D9'],
		                ['<%=date2%>', parseInt(rec.data['fripermitIndex']), '#19A0D9'],
		                ['<%=date1%>', parseInt(rec.data['satpermitIndex']), '#19A0D9']
		            ]);
		            barchartpermitgraph.draw(barchartpermitdata, permitChart);
		        }
		    });

		    setInterval('getDashboardElementsCount()', 20000);
		    document.onkeydown = function(e) {
		        if (event.keyCode == 123) {
		            return false;
		        }
		        if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
		            return false;
		        }
		        if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
		            return false;
		        }
		        if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
		            return false;
		        }
		    }
		}

		//Highlighting Map horizontal menus by calling these functions from Home Screen
		function setMapActiveStyle() {
		    //parent.getVerticalMenus('#menu2', 19);
		}
		//Highlighting Alert horizontal menus by calling these functions from Home Screen
		function setAlertActiveStyle() {
		    // parent.getVerticalMenus('#menu3', 20);
		}
		
		</script>
		
		<div class="container">
		    <!-- Codrops top bar -->
		    <header>
		        <h1><span>DASHBOARD</span></h1>
		    </header>
		    <img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index:4;left: 50%;top: 50%;">
		    <div class="dashboard-mask" id="dashboard-mask-id"></div>
		    <div class="main">
		        <nav id="menu" class="nav">
		            <ul>
		                <div class="dashboardElements">
		                    <li class="totalAsset" onclick="setMapActiveStyle();">
		                        <div class="elementContentTotalAsset">
		                            <a>
		                                <span class="icon">
												<i aria-hidden="true" id = "totalAssetCountId"></i>
											</span>
		                                <span>Total Vehicle</span>
		                                <a class="triangleTotalAsset" href="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType=all" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsTotalAsset></div>
		                    </li>
		                    <li class="communication" onclick="setMapActiveStyle();">
		                        <div class="elementContentCommunication">
		                            <a>
		                                <span class="icon">
												<i aria-hidden="true" id = "commCountId"></i>
											</span>
		                                <span>Communication</span>
		                                <a class="triangleCommunication" href="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType=comm" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsCommunication></div>
		                    </li>
		                    <li class="noGps" onclick="setMapActiveStyle();">
		                        <div class="elementContentNoGPS">
		                            <a>
		                                <span class="icon"> 
												<i aria-hidden="true" id = "noGpsCountId"></i>
											</span>
		                                <span>No Gps</span>
		                                <a class="triangleNoGPS" href="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType=noGPS" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsNoGPS></div>
		                    </li>
		                </div>
		                <div class="dashboardElements">
		                    <li class="nonCommunicationLess" onclick="setMapActiveStyle();">
		                        <div class="elementContentNonCommLess">
		                            <a>
		                                <span class="icon">
												<i aria-hidden="true" id = "nonCommLessThan24hrCountId"></i>
											</span>
		                                <span>Non Com<24</span>
		                                <a class="triangleNonCommLess" href="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType=noncomm" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsNonComm></div>
		                    </li>
		                    <li class="nonCommunicationGreater" onclick="setMapActiveStyle();">
		                        <div class="elementContentNonCommGreater">
		                            <a>
		                                <span class="icon">
												<i aria-hidden="true" id = "nonCommGreaterThan24hrCountId"></i>
											</span>
		                                <span>Non Com>24</span>
		                                <a class="triangleNonCommGreater" href="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType=noncomm" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsNonComm></div>
		                    </li>
		                    <li class="assetArrival">
		                        <div class="elementContentAssetArrival">
		                            <a>
		                                <span class="icon">
												<i aria-hidden="true" id = "assetArrivalSandPortCountId"></i>
											</span>
		                                <span>Reach Arrival</span>
		                                <a class="portarrival" href="<%=request.getContextPath()%>/Jsps/Common/HubArrDepReportNew.jsp?" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsAssetArrival></div>
		                    </li>
		                </div>
		                <div class="dashboardElements">
		                    <li class="sandPermits">
		                        <div class="elementContentSandPermits">
		                            <a>
		                                <span class="icon">
												<i aria-hidden="true" id = "sandPermitsCountId"></i>
											</span>
		                                <span><%=MDP%></span>
		                                <a class="totalmdp" href="/jsps/SandMining_jsps/Sand_Mining_Report.jsp?dashboard=yes" style="margin-top : -15px;"></a>
		                            </a>
		                        </div>
		                        <div class=transparentIconsSandPermits></div>
		                    </li>
		                    <li class="permitsGenerated">
		                        <a>
		                            <span class="icon">
											<i aria-hidden="true" class = "permitsGeneratedFont" id = "totalsandquantityId"></i>
										</span>
		                            <span>Total Sand Quantity Issued (CBM)</span>
		                        </a>
		                    </li>
		                    <li class="permitsGenerated2">
		                        <a>
		                            <span class="icon">
											<i aria-hidden="true" id = "ewayBillwithoutgps"></i>
										</span>
		                            <span><%=GPS%></span>
		                            <a class="triangleNonCommGreater" href="<%=request.getContextPath()%>/Jsps/SandMining/VehicleWithoutGPSReport.jsp?" style="margin-top : -15px;"></a>
		                        </a>
		                    </li>
		                </div>
		
		            </ul>
		        </nav>
		    </div>
		    <div>
		        <div class="revenueBarChart" id="revenuechartdiv"></div>
		        <div class="permitBarChart" id="permitchartdiv"></div>
		    </div>
		</div>
		
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
