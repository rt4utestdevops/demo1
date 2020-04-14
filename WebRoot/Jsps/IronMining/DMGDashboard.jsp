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

<jsp:include page="../Common/header.jsp" />

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
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900italic,900' rel='stylesheet' type='text/css'>
   <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    
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

</style>

<div class="form-group" id="cust_div">
        <label class="col-xs-3 control-label" id="cust_label">Customer Name</label>
        <div class="col-xs-5 selectContainer">
            <select class="form-control" name="size" id="cust_name">
             <option id="">Select Customer Name</option>
            </select>
        </div>
</div>
    <!-- Page Content -->
    <div class="page-wrapper">
        <div class="container-fluid">
            <div class="page-heading">
                <div class="row">
                    <div class="col-lg-6 text-left">
                        <h3>Dashboard</h3>
                    </div>
                </div>
            </div>
            <div class="page-content">
                <div class="row">
                    <div class="col-lg-4 pad-right-0">
                        <div class="panel panel-default">
                              <div class="panel-heading">
                                <h3 class="panel-title">Permit Quantity</h3>
                              </div>
                              <div class="panel-body">
                                <div class="triangle-row">
                                     <div class="triangle">
                                        <div class="triangle-img">
                                          <img src="/ApplicationImages/DashBoard/hill.png" alt="hill">
                                        </div>
                                        <div class="stock">
                                            <div class="count-wrap">
                                                <div class="count" id="pot_qty"></div>
                                                <div class="mt">(M/T)</div> 
                                                <div class="clearfix"></div>
                                            </div> 
                                            <div class="stock-title">
                                               Purchased<br/>
                                               Rom Quantity
                                            </div>
                                        </div>
                                       </div>
                                       <div class="triangle">
                                        <div class="triangle-img">
                                          <img src="/ApplicationImages/DashBoard/hill.png" alt="hill">
                                        </div>
                                        <div class="stock">
                                            <div class="count-wrap">
                                                <div class="count" id="pos_qty"></div>
                                                <div class="mt">(M/T)</div> 
                                                <div class="clearfix"></div>
                                            </div> 
                                            <div class="stock-title">
                                               Purchased<br/>
                                               Processed Quantity
                                            </div>
                                        </div>
                                       </div>
                                     <div class="clear-fix"></div>
                                </div>
                                <div class="triangle-row">
                                     <div class="triangle">
                                        <div class="triangle-img">
                                          <img src="/ApplicationImages/DashBoard/hill.png" alt="hill">
                                        </div>
                                        <div class="stock">
                                            <div class="count-wrap">
                                                <div class="count" id="de_qty"></div>
                                                <div class="mt">(M/T)</div> 
                                                <div class="clearfix"></div>
                                            </div> 
                                            <div class="stock-title">
                                               Domestic<br/>
                                               Export Quantity
                                            </div>
                                        </div>
                                       </div>
                                       <div class="triangle">
                                        <div class="triangle-img">
                                          <img src="/ApplicationImages/DashBoard/hill.png" alt="hill">
                                        </div>
                                        <div class="stock">
                                            <div class="count-wrap">
                                                <div class="count" id="ie_qty"></div>
                                                <div class="mt">(M/T)</div> 
                                                <div class="clearfix"></div>
                                            </div> 
                                            <div class="stock-title">
                                               International<br/>
                                               Export Quantity
                                            </div>
                                        </div>
                                       </div>
                                       <div class="triangle">
                                        <div class="triangle-img">
                                          <img src="/ApplicationImages/DashBoard/hill.png" alt="hill">
                                        </div>
                                        <div class="stock">
                                            <div class="count-wrap">
                                                <div class="count" id="post_qty"></div>
                                                <div class="mt">(M/T)</div> 
                                                <div class="clearfix"></div>
                                            </div> 
                                            <div class="stock-title">
                                               ProcessedOre sale<br/>
                                               Export Quantity
                                            </div>
                                        </div>
                                       </div>
                                     <div class="clear-fix"></div>
                                </div>
                               
                                   
                              </div>
                        </div>
                    </div>
                    <div class="col-lg-4 pad-right-0">
                     
                      <div class="challan-wrap">
                         <div class="week-filter" id="week-filter">
                            <div class="pop-up-close">
                               <a href="#" class="pop-up-hide"><img src="/ApplicationImages/DashBoard/close.png" alt="close"></a>
                            </div>
                            <div class="pop-up-body">
                              <div class="form">
                               <div class="col-lg-6">
                                  <SELECT class="form-control">
                                    <option>Month</option>
                                  </SELECT>
                                </div>
                                <div class="col-lg-6">
                                  <SELECT  class="form-control">
                                    <option>Year</option>
                                  </SELECT>
                                </div>
                                <div class="clearfix"></div>
                              </div>
                              <div class="form-group text-center">
                                <button class="btn btn-done pop-up-hide" id="done">Done</button>
                              </div>
                            </div>
                          </div>
                          <div class="panel panel-default">
                              <div class="panel-heading">
                                <div class="row">
                                     <div class="col-lg-10">
                                     <h3 class="panel-title">Challan</h3>
                                        </div>
                                </div>
                               
                              </div>
                              <div class="panel-body pad-btm-nil">
                                <div class="circle-row">
                                        <h3 class="ch-count-title">
                                            <span class="ch-count" id="total_challan">
                                                
                                            </span>
                                            Total Challans
                                        </h3>
										<div class="circle-content"  id="donut_chart">
										</div>
                                    <div class="ch-status-wrapper">
                                        <div class="row">
                                            <div class="col-lg-6">
                                                   <h4>
                                                       <span class="ch-status-count" id="pending_challan">
                                                       
                                                       </span><br/>
                                                        <span class="ch-status-pending">
                                                       PENDING Approval
                                                       </span>
                                                    </h4>
                                                
                                            </div>
                                            <div class="col-lg-6">
                                                 <h4>
                                                       <span class="ch-status-count" id="approved_challan">
                                                       
                                                       </span><br/>
                                                        <span class="ch-status-approve">
                                                       Approved
                                                       </span>
                                                    </h4>
                                            </div>
                                        </div>
                                    </div>
                                      <div class="clear-fix"></div>
                                </div>
                                   
                              </div>
                        </div>
                      </div>
                        
                    </div>
                    <div class="col-lg-4 pad-right-0"">
                        <div class="panel panel-default pad-btm-nil">
                              <div class="panel-heading">
                                <div class="row">
                                     <div class="col-lg-8">
                                     <h3 class="panel-title">Permits</h3>
                                        </div>
                                    <div class="col-lg-4 permit-count-heading" id="permit_count">
                                      <span class="permit-count" id="total_permit"></span>Total Counts
                                    </div>
                                </div>
                               
                              </div>
                              <div class="panel-body permit-content pad-btm-nil ">
                                <div class="permit-wrapper ">
                                      <div class="btn-group btn-group-justified bx-shadow" role="group" >
                                          <div class="btn-group bdr-right" role="group">
                                             <div class="permit-heading">
                                                <div class="permit-count" id="pending_permit">
                                                    
                                                </div>
                                                <div class="permit-status">
                                                    <img src="/ApplicationImages/DashBoard/pending.png" alt="approve">
                                                </div>
                                                <div class="clearfix"></div>
                                             </div>
                                             <div class="permit-status-text">
                                                <h4 class="clr-pend"> PENDING Approval</h4>
                                            </div>
                                          </div>
                                        <div class="btn-group bdr-right" role="group">
                                          <div class="permit-heading">
                                                <div class="permit-count" id="approved_permit">
                                                    
                                                </div>
                                                <div class="permit-status">
                                                    <img src="/ApplicationImages/DashBoard/approve.png" alt="approve">
                                                </div>
                                                <div class="clearfix"></div>
                                             </div>
                                             <div class="permit-status-text">
                                                <h4 class="clr-apv"> Approved</h4>
                                            </div>
                                        </div>
                                        <div class="btn-group" role="group">
                                          <div class="permit-heading">
                                                <div class="permit-count" id="closed_permit">
                                                   
                                                </div>
                                                <div class="permit-status">
                                                    <img src="/ApplicationImages/DashBoard/rejected.png" alt="approve">
                                                </div>
                                                <div class="clearfix"></div>
                                             </div>
                                             <div class="permit-status-text">
                                                <h4 class="clr-rej"> Closed</h4>
                                            </div>
                                        </div>
                                     </div>
                                    <div class="clear-fix"></div>
                                </div>
                                <div class="permit-wrapper ">
                                  <div class="form-group">
                                    <div class="col-lg-6">
                                      <h4 class="montly-rtn">Monthly Returns</h4>
                                    </div>
                                    <div class="col-lg-6">
                                      <div class="monthly-rtn-count" id="total_monthly">
                                         
                                      </div>
                                    </div>
                                    <div class="clearfix"></div>
                                  </div>
                                      <div class="btn-group btn-group-justified " role="group" >
                                          <div class="btn-group bdr-right" role="group">
                                             <div class="permit-heading">
                                                <div class="permit-count" id="pending_monthly">
                                                    
                                                </div>
                                                <div class="permit-status">
                                                    <img src="/ApplicationImages/DashBoard/pending.png" alt="approve">
                                                </div>
                                                <div class="clearfix"></div>
                                             </div>
                                             <div class="permit-status-text">
                                                <h4 class="clr-pend"> PENDING Approval</h4>
                                            </div>
                                          </div>
                                        <div class="btn-group bdr-right" role="group">
                                          <div class="permit-heading">
                                                <div class="permit-count" id="approved_monthly">
                                                    
                                                </div>
                                                <div class="permit-status">
                                                    <img src="/ApplicationImages/DashBoard/approve.png" alt="approve">
                                                </div>
                                                <div class="clearfix"></div>
                                             </div>
                                             <div class="permit-status-text">
                                                <h4 class="clr-apv"> Approved</h4>
                                            </div>
                                        </div>
                                        <div class="btn-group" role="group">
                                          <div class="permit-heading">
                                                <div class="permit-count" id="rejected_monthly">
                                                    
                                                </div>
                                                <div class="permit-status">
                                                    <img src="/ApplicationImages/DashBoard/rejected.png" alt="approve">
                                                </div>
                                                <div class="clearfix"></div>
                                             </div>
                                             <div class="permit-status-text">
                                                <h4 class="clr-rej"> Rejected</h4>
                                            </div>
                                        </div>
                                     </div>
                                    <div class="clear-fix"></div>
                                </div>
                                   
                              </div>
                        </div>
                    </div>
                </div>
                <!-- /.row -->
              <div class="row">
                  <div class="col-lg-12 pad-right-0">
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

<!--                                 <div class="switch-content" id="truck" hidden="true">-->
<!--                                    <div class=" tripsheet">-->
<!--                                      <div class="col-lg-6 ">-->
<!--                                        <div class="trip-issued">-->
<!--                                          <span class="count">50</span>-->
<!--                                          <span><img src="/ApplicationImages/DashBoard/truck.png" alt="truck"></span>-->
<!--                                        </div>-->
<!--                                        <div class="trip-issued-title">-->
<!--                                          <h5>Tripsheets issued</h5>-->
<!--                                        </div>-->
<!--                                        -->
<!--                                      </div>-->
<!--                                      <div class="col-lg-6">-->
<!--                                        <div class="trip-issued">-->
<!--                                            <span class="count">25000</span>-->
<!--                                            <span><img src="/ApplicationImages/DashBoard/machine.png" alt="machine"></span>-->
<!--                                          </div>-->
<!--                                          <div class="total-qty-title">-->
<!--                                            <h5>Total Quantity(m/t)</h5>-->
<!--                                          </div>-->
<!--                                        -->
<!--                                      </div>-->
<!--                                      <div class="clearfix"></div>-->
<!--                                    </div>-->
<!--                                    <div class="tripsheet-status-wrap">-->
<!--                                    <div class="tripsheet-status-cont">-->
<!--                                      <div class="elem">-->
<!--                                        <h2>30</h2>-->
<!--                                        <h5>tripsheet open</h5>-->
<!--                                      </div>-->
<!--                                    </div>-->
<!--                                     <div class="tripsheet-status-cont">-->
<!--                                      <div class="elem">-->
<!--                                        <h2>25</h2>-->
<!--                                        <h5>tripsheet closed</h5>-->
<!--                                      </div>-->
<!--                                    </div>-->
<!--                                     <div class="tripsheet-status-cont">-->
<!--                                      <div class="elem">-->
<!--                                        <h2>1000</h2>-->
<!--                                        <h5>in-transit quantity(m/t)</h5>-->
<!--                                      </div>-->
<!--                                    </div>-->
<!--                                     <div class="tripsheet-status-cont">-->
<!--                                      <div class="elem">-->
<!--                                        <h2>1000</h2>-->
<!--                                        <h5>Closed quantity</h5>-->
<!--                                      </div>-->
<!--                                     </div>-->
<!--                                     <div class="clearfix"></div>-->
<!--                                  </div>-->
<!--                                </div>-->
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
                <div class="col-lg-12  pad-right-0">
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
                <div class="col-lg-12 pad-right-0">
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
window.oncontextmenu=function()
	{
		return false;
	}
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
	 if (<%=customerId%> == 0) {
	     $('#cust_div').show();
	     $.ajax({
	         url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getCustomer',
	         success: function(response) {
	             customerList = JSON.parse(response);
	             var $custName = $('#cust_name');
	             $.each(customerList, function() {
	                 $('<option id=' + this.CustId + '>' + this.CustName + '</option>').appendTo($custName);
	             });
	         }
	     });
	     $('#cust_name').change(function() {
	         custId = $('option:selected').attr('id');
	         getElementStore();
	     });
	 } else {
	     custId = <%=customerId%>;
	     $('#cust_div').hide();
	     getElementStore();
	 }

	 function getElementStore() {
	     if (custId > 0) {
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
	             url: '<%=request.getContextPath()%>/DMGDashBoardAction.do?param=getDashBoardElementCount',
	             data: {
	                 CustId: custId
	             },
	             success: function(response) {
	                 dashBoardElementList = JSON.parse(response);

	                 var approveChallan = dashBoardElementList["dashBoardRoot"][0].approvedChallanCount;
	                 var totalChallan = dashBoardElementList["dashBoardRoot"][0].totalChallanCount;
	                 challanperc = (approveChallan * 100) / totalChallan;
	                 var noIssued = totalChallan-approveChallan;
	                // document.getElementById('issued_perc').innerHTML = (Math.round(parseFloat(challanperc))) + '%';

	                 var potQuantity = dashBoardElementList["dashBoardRoot"][0].potQuantity;
	                 var posQuantity = dashBoardElementList["dashBoardRoot"][0].posQuantity;
	                 var ieQuantity = dashBoardElementList["dashBoardRoot"][0].ieQuantity;
	                 var deQuantity = dashBoardElementList["dashBoardRoot"][0].deQuantity;
	                 var postQuantity = dashBoardElementList["dashBoardRoot"][0].postQuantity;

	                 document.getElementById('total_permit').innerHTML = dashBoardElementList["dashBoardRoot"][0].totalPermitCount;
	                 document.getElementById('approved_permit').innerHTML = dashBoardElementList["dashBoardRoot"][0].approvedPermitCount;
	                 document.getElementById('pending_permit').innerHTML = dashBoardElementList["dashBoardRoot"][0].pendingPermitCount;
	                 document.getElementById('closed_permit').innerHTML = dashBoardElementList["dashBoardRoot"][0].closedPermitCount;

	                 document.getElementById('total_challan').innerHTML = dashBoardElementList["dashBoardRoot"][0].totalChallanCount;
	                 document.getElementById('approved_challan').innerHTML = dashBoardElementList["dashBoardRoot"][0].approvedChallanCount;
	                 document.getElementById('pending_challan').innerHTML = dashBoardElementList["dashBoardRoot"][0].pendingChallanCount;

	                 document.getElementById('pot_qty').innerHTML = potQuantity;
	                 document.getElementById('pos_qty').innerHTML = posQuantity;
	                 document.getElementById('de_qty').innerHTML = deQuantity;
	                 document.getElementById('ie_qty').innerHTML = ieQuantity;
	                 document.getElementById('post_qty').innerHTML = postQuantity;

	                 document.getElementById('total_monthly').innerHTML = dashBoardElementList["dashBoardRoot"][0].totalMonthlyRetunsCount;
	                 document.getElementById('approved_monthly').innerHTML = dashBoardElementList["dashBoardRoot"][0].approvedMonthlyRetunsCount;
	                 document.getElementById('pending_monthly').innerHTML = dashBoardElementList["dashBoardRoot"][0].pendingMonthlyRetunsCount;
	                 document.getElementById('rejected_monthly').innerHTML = dashBoardElementList["dashBoardRoot"][0].rejectedMonthlyRetunsCount;
	                 
	                   
	                 var c = new google.visualization.PieChart(document.getElementById('donut_chart'));
			           var d = google.visualization.arrayToDataTable([
				         ['Task', 'Hours per Day'],
				          ['issued',   challanperc],
				          ['Pending',  noIssued]
				        ]);
				
				        var o = {
		      			 pieHole: 0.4,
		      			 height:230,
				        };
				        c.draw(d, o);
			             }
			         });
	           
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
	 }
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
    </script>

 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
