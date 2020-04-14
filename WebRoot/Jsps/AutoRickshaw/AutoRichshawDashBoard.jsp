<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customerId=loginInfo.getCustomerId();
int offset = loginInfo.getOffsetMinutes();
int custidpassed=0;
if(request.getParameter("cutomerIDPassed")!= null)
{
customerId=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}

//if(customerId == 0)
//	{
//		response.sendRedirect(request.getContextPath()+"/Jsps/Common/ApplicationMigration.html");
//	}
boolean mapViewLink=false;
if(request.getParameter("mapViewlink")!=null)
{
   mapViewLink=true;
}
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Total_Billboard");
tobeConverted.add("Occupied");
tobeConverted.add("Vacant");
tobeConverted.add("Good_Display");
tobeConverted.add("Defective_Display");
tobeConverted.add("Pending_Action");
tobeConverted.add("Flex_Defective");
tobeConverted.add("Lighting_Defective");
tobeConverted.add("Image_Not_Received");
tobeConverted.add("View_Details");
tobeConverted.add("Vertical_Dashboard");
tobeConverted.add("Brand_Inactive");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String TotalBillboard=convertedWords.get(0);
String Occupied=convertedWords.get(1);
String Vacant=convertedWords.get(2);
String GoodDisplay=convertedWords.get(3);
String DefectiveDisplay=convertedWords.get(4);
String PendingAction=convertedWords.get(5);
String FlexDefective=convertedWords.get(6);
String LightingDefective=convertedWords.get(7);
String ImageNotReceived=convertedWords.get(8);
String ViewDetails=convertedWords.get(9);
String Dashboard=convertedWords.get(10);
String BrandInactive=convertedWords.get(11);
%>

<!DOCTYPE html>
<html>
  <head>
    <title><%=Dashboard%></title>
    <meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	     <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/dashBoard/css/component.css" />
		<script src="../../Main/adapter/ext/ext-base.js"></script>
		<script src="../../Main/Js/ext-all-debug.js"></script>
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
  	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	<style>
body {
  font-family: 'Open Sans', sans-serif !important;
  font-size: 25px;
  line-height: 1.42857143;
  color: #333;
  background-color: #fff;
}
.pull-left {
  float: left!important;
  font-family: 'Open Sans', sans-serif !important;
  font-size: 12px;
}
.panel-body{
	/*background-color: #C0C0C0;*/
	font-family: 'Lato', Calibri, Arial, sans-serif;
	font-size: 24px;
	color: #5eb9f9;
	padding: 2px 2px;
	font-weight: 300;
}

.col-sm-4
{
width:650px;
}

.container {
  width: 100%;
  height: 86%;
  margin-top:3%;
  margin-left:2.5%;
}
.huge{
	  text-align: center;
	  font-family: Open Sans, Light;
      font-size: 33px;
}
.huge_text{
	text-align: center;
	font-family: Open Sans, Light;
    font-size: 22px;
}
.col-xs-9 {
  width: 97%;
}
.panel-green{
	border-color: #8cc22e;
}
.panel-green > .panel-heading {
  border-color: #8cc22e;
  color: #fff;
  background-color: #8cc22e;
  height:200px;
}
.panel-blue {
  border-color: #12a7cc;
  
}
.panel-blue > .panel-heading {
  border-color: #12a7cc;
  color: #fff;
  background-color: #12a7cc;
  height:200px;
}
.panel-black {
  border-color: #646464;
}
.panel-black > .panel-heading {
  border-color: #646464;
  color: #fff;
  background-color: #646464;
  height:200px;
}
.panel-cyan {
  border-color: #10c9a0;;
}
.panel-cyan > .panel-heading {
  border-color: #10c9a0;
  color: #fff;
  background-color: #10c9a0;
  height:200px;
}
.panel-red {
  border-color: #C94223;
}
.panel-red > .panel-heading {
  border-color: #C94223;
  color: #fff;
  background-color: #C94223;
  height:200px;
}
.panel-desaturatedOrange {
  border-color: #CF8452;
}
.panel-desaturatedOrange > .panel-heading {
  border-color: #CF8452;
  color: #fff;
  background-color: #CF8452;
}
.panel-paleGreen {
  border-color: #b7b85e;
}
.panel-paleGreen > .panel-heading {
  border-color: #b7b85e;
  color: #fff;
  background-color: #b7b85e;
  height:200px;
}
.panel-yellow {
  border-color: #e6bd1b;
}
.panel-yellow > .panel-heading {
  border-color: #e6bd1b;
  color: #fff;
  background-color: #e6bd1b;
}
.panel-lightGray {
  border-color: #C0C0C0;
}
.panel-lightGray > .panel-heading {
  border-color: #C0C0C0;
  color: #fff;
  background-color: #C0C0C0;
}
@media (min-width: 1200px){
	.col-lg-3 {
	  width: 33%;
	}
}
	</style>
  </head>
  
  <body>
   	<div class="panel panel-default">
    	<div class="panel-body">Dashboard</div>
  	</div> 
  	<div class="container">
  	<div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-green">
                        <div class="panel-heading">
                            <div class="row">                                
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "totalBillCountId">0</div>
                                    <div class="huge_text">No of Vehicles in crime zone</div>
                                </div>
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/Jsps/OutdoorHoardings/BillBoardMapView.jsp">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="panel panel-blue">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "occupiedCountId">0</div>
                                    <div class="huge_text">No of Vehicles approaching crime zones</div>
                                </div>
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/Jsps/OutdoorHoardings/BillboardDashboardDetails.jsp?paramFromJsp=Occupied&CustId=<%=customerId%>">
                            <div class="panel-footer">
                                <span class="pull-left"><%=ViewDetails%></span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
            </div> 
            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-cyan">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "goodDisplayCountId">0</div>
                                    <div class="huge_text">No of vehicles in crime zone with passenger for more than "x" hour</div>
                                </div>
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/Jsps/OutdoorHoardings/BillboardDashboardDetails.jsp?paramFromJsp=Good&CustId=<%=customerId%>">
                            <div class="panel-footer">
                                <span class="pull-left"><%=ViewDetails%></span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "defectiveDisplayId">0</div>
                                    <div class="huge_text">No of Emergency alert by commuters in a day</div>
                                </div>
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/Jsps/OutdoorHoardings/BillboardDashboardDetails.jsp?paramFromJsp=Defective&CustId=<%=customerId%>">
                            <div class="panel-footer">
                                <span class="pull-left"><%=ViewDetails%></span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
            </div> 
         </div> 
         <script type="text/javascript">
         	function CheckSession() {
  						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ObservationDashboardAction.do?param=checkSession',
                        method: 'POST',
                        success: function (response, options)
                        {
                        if(response.responseText=='InvalidSession')
                        {
                        window.location.href = "<%=request.getContextPath()%>/Jsps/Common/SessionDestroy.html";
                        }
                        },
                        failure: function ()
                        {
                        } 
                    });
            }
            
            	
				var customercombostore= new Ext.data.JsonStore({
			       url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: 
				   {
	    				load: function(custstore, records, success, options) 
	    				{
	    				      if(<%=customerId%>>0)
	        				 {	        				 	
	        				 	//Ext.getCmp('custcomboId').setValue(<%=customerId%>); 
	        				 	//parent.parentCustomerID=Ext.getCmp('custcomboId').getValue();
	        				 	//parent.parentVehicleType=Ext.getCmp('vehicleTypeId').getValue();
					 			getDashboardElementsCount();
                	   	        setInterval('getDashboardElementsCount()',60000);
                        		
					 		 }
	    				}
    			  }
});

var dashBoardElements = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/ObservationDashboardAction.do?param=getDashboardElementsCount',
				id:'dashboardElementsCountId',
				root: 'DashBoardElementCountRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['totalBillBoardCount','occupied','vacant','goodDisplay','defectiveDisplay','pendingActions','AllLightingOff','lightingPartially','ImageNotRecivied']
		});
		
	function getDashboardElementsCount(){
		CheckSession();
			dashBoardElements.load({
			params:{customerId:<%=customerId%>},
				callback: function(){
					 for(var i=0;i<=dashBoardElements.getCount()-1;i++) {
              		 	var rec = dashBoardElements.getAt(i);
              			document.getElementById('totalBillCountId').innerHTML = rec.data['totalBillBoardCount'];
              			document.getElementById('occupiedCountId').innerHTML = rec.data['occupied'];
              			document.getElementById('vacantCountId').innerHTML = rec.data['vacant'];
              			document.getElementById('goodDisplayCountId').innerHTML = rec.data['goodDisplay'];
              			document.getElementById('defectiveDisplayId').innerHTML = rec.data['defectiveDisplay'];
              			document.getElementById('pendingActionsId').innerHTML = rec.data['pendingActions'];
              			document.getElementById('AllLightingOffId').innerHTML = rec.data['AllLightingOff'];
              			document.getElementById('lightingPartiallyId').innerHTML = rec.data['lightingPartially'];
              			document.getElementById('ImageNotReciviedId').innerHTML = rec.data['ImageNotRecivied'];              			
					}
				}
			});	

		}	
		
         </script>	
  </body>
</html>
