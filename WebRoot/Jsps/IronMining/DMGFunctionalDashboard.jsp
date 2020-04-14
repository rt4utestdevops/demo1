<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1" %>
    <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


        <!doctype html>
        <html class="no-js" lang="">

        <head>
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <meta charset="UTF-8">
            <title>Dashboard</title>
            <meta name="description" content="">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="../../Main/modules/ironMining/DMGDashboard/css/wrap-styles.css">
        </head>

        <body class="dashboard-bg">
            <section class="io-dash">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-8">
                            <!-- Header -->
                            <div class="header">
                                <div class="container-fluid no-padding">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="logo-1">
                                                <a href="#"><img src="/ApplicationImages/DMGDashboard/mega_soft_logo.png" alt="logo_1"></a>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="logo-2">
                                                <a href="/Telematics4uApp/Jsps/IronMining/DMGFunctionalDashboard.jsp"><img class="center-block" src="/ApplicationImages/DMGDashboard/Gvt_Goa_logo.png" alt="logo_1"></a>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="logo-1">
                                                <a href="#"> <img class="pull-right" src="/ApplicationImages/DMGDashboard/T4U.png" alt="logo_1"></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- //Header -->
                            <!-- cards-->
                            <div class="io-cards">
                                <div class="card-row-1">
                                    <div class="container-fluid no-padding">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="/Telematics4uApp/Jsps/IronMining/IbmGrade.jsp">
                                                        <img src="/ApplicationImages/DMGDashboard/img_1.png" alt="logo_1">
                                                        <p>IBM GRADES</p>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="#">
                                                        <img src="/ApplicationImages/DMGDashboard/img_2.png" alt="logo_1">
                                                        <p class="font-dark">FINANCIAL <br/>ACCOUNTING</p>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="#">
                                                        <img src="/ApplicationImages/DMGDashboard/img_3.png" alt="logo_1">
                                                        <p>IMPORTS/EXPORTS</p>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-row-2">
                                    <div class="container-fluid no-padding">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="/Telematics4uApp/Jsps/IronMining/Production.jsp">
                                                        <img src="/ApplicationImages/DMGDashboard/img_4.png" alt="logo_1">
                                                        <p>PRODUCTION</p>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="/Telematics4uApp/Jsps/IronMining/Transportion.jsp">
                                                        <img src="/ApplicationImages/DMGDashboard/img_5.png" alt="logo_1">
                                                        <p>TRANSPORTATION</p>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="#">
                                                        <img src="/ApplicationImages/DMGDashboard/img_6.png" alt="logo_1">
                                                        <p>STOCKS</p>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-row-2">
                                    <div class="container-fluid no-padding">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="/Telematics4uApp/Jsps/IronMining/DMFDashboard.jsp">
                                                        <img src="/ApplicationImages/DMGDashboard/img_7.png" alt="logo_1">
                                                        <p>DMF DETAILS</p>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="#">
                                                        <img src="/ApplicationImages/DMGDashboard/img_8.png" alt="logo_1">
                                                        <p>BARGE LOADING</p>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="thumb-img">
                                                    <a href="#">
                                                        <img src="/ApplicationImages/DMGDashboard/img_9.png" alt="logo_1">
                                                        <p class="font-dark">GIS</p>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- // cards -->
                            <!--                  <div class="io-footer">-->
                            <!--                  </div>-->
                        </div>
                        <div class="col-md-4 right-padding">
                            <div class="io-counter">
                                <div class="barge-trip">
                                    <p>BARGE TRIP SHEET QUANTITY (MT)</p>
                                    <div class="barge-counter">
                                        <div class="barge" id="bargeTripQty"></div>
                                    </div>
                                </div>
                                <div class="trip-sheet">
                                    <p>TRUCK TRIP SHEET QUANTITY (MT)</p>
                                    <div class="trip-counter">
                                        <div class="clock" id="truckTripQty"></div>
                                    </div>
                                </div>
                                <div class="value-table">
                                    <table class="table table-striped">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <p>Production&nbsp;for&nbsp;the&nbsp;Day<span class="row-value"><br/><span id="ProductionId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Royalty&nbsp;Collection&nbsp;for&nbsp;the&nbsp;Day<span class="row-value"><br/><span id="royaltyId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>DMF&nbsp;Collection<span class="row-value"><br/><span id="dmfId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>NMET&nbsp;Collection<span class="row-value"><br/><span id="nmetId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>GIOPF&nbsp;Collection<span class="row-value"><br/><span id="giopfId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Processing&nbsp;Fees<span class="row-value"><br/><span id="processingFId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Number&nbsp;of&nbsp;Traders<span class="row-value"><br/><span id="traderId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>No&nbsp;of&nbsp;Organizations<span class="row-value"><br/><span id="orgId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>No&nbsp;of&nbsp;Leases<span class="row-value"><br/><span id="leaseId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Import&nbsp;Permits<span class="row-value"><br/><span id="importPermitId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Export&nbsp;Permits<span class="row-value"><br/><span id="exportPermitId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Transit&nbsp;Permits<span class="row-value"><br/><span id="transitPermitId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Domestic&nbsp;Consumption<span class="row-value"><br/><span id="domesticConsumId"></span></span>
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <p>Debarring&nbsp;of&nbsp;Trucks<span class="row-value"><br/>0</span></p>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Scripts -->
            <script src="../../Main/modules/ironMining/DMGDashboard/js/jquery-3.1.1.min.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/bootstrap.min.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/flipclock.js"></script>
            <script src="../../Main/modules/ironMining/DMGDashboard/js/custom.js"></script>
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <script>
                setInterval(function() {
                    $.ajax({
                        url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getTripsheetQty',
                        data: {},
                        success: function(response) {
                            tripsheetQty = JSON.parse(response);

                            barge.setTime(tripsheetQty["tripQtyRoot"][0].bargeTripQty);
                            clock.setTime(tripsheetQty["tripQtyRoot"][0].truckTripQty);
                        }
                    });
                }, 240000);

                $.ajax({
                    url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getDashBoardCounts',
                    data: {},
                    success: function(response) {
                        dashBoardCount = JSON.parse(response);

                        document.getElementById('royaltyId').innerHTML = dashBoardCount["DBoardRoot"][0].royalty;
                        document.getElementById('dmfId').innerHTML = dashBoardCount["DBoardRoot"][0].dmf;
                        document.getElementById('nmetId').innerHTML = dashBoardCount["DBoardRoot"][0].nmet;
                        document.getElementById('giopfId').innerHTML = dashBoardCount["DBoardRoot"][0].giopf;
                        document.getElementById('processingFId').innerHTML = dashBoardCount["DBoardRoot"][0].pfee;

                        document.getElementById('exportPermitId').innerHTML = dashBoardCount["DBoardRoot"][0].Export;
                        document.getElementById('transitPermitId').innerHTML = dashBoardCount["DBoardRoot"][0].Transit;
                        document.getElementById('importPermitId').innerHTML = dashBoardCount["DBoardRoot"][0].Import;

                        document.getElementById('ProductionId').innerHTML = dashBoardCount["DBoardRoot"][0].productionQty;
                        document.getElementById('leaseId').innerHTML = dashBoardCount["DBoardRoot"][0].lease;
                        document.getElementById('orgId').innerHTML = dashBoardCount["DBoardRoot"][0].org;
                        document.getElementById('traderId').innerHTML = dashBoardCount["DBoardRoot"][0].trader;
                        document.getElementById('domesticConsumId').innerHTML = dashBoardCount["DBoardRoot"][0].domesticConsum;
                        
                    }
                });
            </script>
        </body>

        </html>