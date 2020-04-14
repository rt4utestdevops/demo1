<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
int userId=loginInfo.getUserId();

int list=0;
StringBuilder alertpannelitems1=new StringBuilder();
StringBuilder alertpannelitems2=new StringBuilder();
CashVanManagementFunctions cvmf=new CashVanManagementFunctions();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Total_Assets");
tobeConverted.add("No_GPS");
tobeConverted.add("Comm");
tobeConverted.add("Non_Comm");
tobeConverted.add("Vehicle_On_Road");
tobeConverted.add("Vehicle_Off_Road");
tobeConverted.add("Refuel_(Ltrs)");
tobeConverted.add("Commissioned_DeCommissioned");
tobeConverted.add("Vehicle_Status_Live");
tobeConverted.add("Preventive_Maintenance_Assets");
tobeConverted.add("Vehicle_On_Trip");
tobeConverted.add("Statutory_Details");
tobeConverted.add("Vehicle_Count");
tobeConverted.add("Insurance");
tobeConverted.add("Goods_Token_Tax");
tobeConverted.add("FCI");
tobeConverted.add("Emission");
tobeConverted.add("Permit");
tobeConverted.add("Driver_License");
tobeConverted.add("Due_for_Expiry");
tobeConverted.add("Expired");
tobeConverted.add("Commissioned");
tobeConverted.add("DeCommissioned");
tobeConverted.add("CVS_DashBoard");
tobeConverted.add("Generic_Dashboard");
tobeConverted.add("Commissioned_DeCommissioned_(Last_1_Month)");
tobeConverted.add("Preventive_Maintainance_Asset_Zero_Values");
tobeConverted.add("Running");
tobeConverted.add("Idle");
tobeConverted.add("Stopped");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String totalAssets = convertedWords.get(0);
String noGPS = convertedWords.get(1);
String comm = convertedWords.get(2);
String nonComm = convertedWords.get(3);
String vehicleOnRoad = convertedWords.get(4);
String vehicleOffRoad = convertedWords.get(5);
String refuel = convertedWords.get(6);
String commDeComm = convertedWords.get(7);
String vehicleStatusLive = convertedWords.get(8);
String preventiveMaintenanceAssets = convertedWords.get(9);
String vehicleOnTrip = convertedWords.get(10);
String statutoryDetails = convertedWords.get(11);
String vehicleCount = convertedWords.get(12);
String insurance = convertedWords.get(13);
String goodsTokenTax = convertedWords.get(14);
String fci = convertedWords.get(15);
String emission = convertedWords.get(16);
String permit = convertedWords.get(17);
String driverLicense = convertedWords.get(18);
String dueforExpiry = convertedWords.get(19);
String expired = convertedWords.get(20);
String commissioned = convertedWords.get(21);
String deCommissioned= convertedWords.get(22);
String CVSDashBoard = convertedWords.get(23);
String genericDashboard = convertedWords.get(24).toUpperCase();
String CommissionedDeCommissionedLast1Month = convertedWords.get(25).toUpperCase();
String preventiveMaintainanceAssetZeroValues = convertedWords.get(26);
String running = convertedWords.get(27);
String idle = convertedWords.get(28);
String stopped = convertedWords.get(29);

String alertDiv="";
	String alertID="";
	String alert1="";
	CarRentalFunctions cFunctions = new CarRentalFunctions();
	HashMap<Object, Object> alertComponents = cFunctions.getAlertComponents(systemid,customerId,userId,offset,language);
	for (Object value : alertComponents.values()) {
    alertDiv=value.toString();
    for ( Map.Entry<Object, Object> entry : alertComponents.entrySet()) {
    alertID= entry.getKey().toString();
	}
	 alert1=cf.getLabelFromDB("Alerts",language).toUpperCase();
	}
//getting alert id of all alert
Map <String,Integer> alert=cFunctions.getDashBoardDetails(systemid);
String alert_REFUEL_LITERS="0";
String alert_STATUTORY_BARCHART="0";
if(alert.get("STATUTORY-BARCHART")!=null)
{
alert_STATUTORY_BARCHART=Integer.toString(alert.get("STATUTORY-BARCHART"));
}
String cvsdashboard=CVSDashBoard;
String  PREVENTIVE_EXPIRED="PREVENTIVE EXPIRED";
String  PREVENTIVE_DUE_EXPIRY="PREVENTIVE DUE FOR EXPIRY";
String  VEHICLE_ON_OFF_ROAD="VEHICLE ON/OFF ROAD";
String  VEHICLE_NOT_COMMUNICATING="VEHICLE NOT COMMUNICATING";
String  STATUTORY_ALERT="STATUTORY ALERT";
String  REFUEL_LITERS=refuel;
String PREVENTIVE_MAINTAINANCE_ASSET=preventiveMaintenanceAssets;
String PREVENTIVE_MAINTAINANCE_ASSET_ZERO_VALUES=preventiveMaintainanceAssetZeroValues;
String registration="Registration Or Revenue";
%>


<!DOCTYPE HTML>
<html>
 <head>
 
		<title>NC DashBoard</title>	
		<link rel="stylesheet" type="text/css" href="../../Main/modules/CarRental/dashboard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/CarRental/dashboard/css/component.css" />
<style type="text/css">
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}	
.x-form-text, textarea.x-form-field {
border: solid 2px #3897C4 !important;
height: 25px !important;
}
#preventivevehiclestatusmainpanelid{
height:250px ! important;
}
#informativeAlertmainpanelid{
height:500px! important;
width: 1342px ! important;
}
.panicHearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color:#F52020;
color: #fff;
font-size:48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.panicHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #F52020;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.panicCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: #F52020;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.panicCountDiv
{
height: 136px;
padding-top: 7px;
text-align: center;
background-color: #F52020;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.panicDeatilsNav{
width: 8% !important;
height: 115px !important;
background-color: #F52020 !important;
}
@media screen and (device-width:1920px){
.panicDeatilsNav
{
width: 8% !important;
height: 195px !important;
background-color:#F52020 !important;	
}
}
.panicDeatilsNavimage
{
background-color: #F52020;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #790505;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.panicDeatilsNavimage
{
background-color: #F52020;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #790505;
cursor: pointer;
z-index: 100;
height: 15px;
}
}

.Noncomm12HearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color:#E1915C;
color: #fff;
font-size:48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.Noncomm12HearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #E1915C;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.noncomm12CountDiv
{
height: 50px;
text-align: center;
padding-top:7px;
background-color: #E1915C;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.noncomm12CountDiv
{
height: 136px;
text-align: center;
padding-top:7px;
background-color: #E1915C;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.noncomm12DeatilsNav{
width: 8% !important;
height: 115px !important;
background-color: #E1915C !important;
}
@media screen and (device-width:1920px){
.noncomm12DeatilsNav
{
width: 8% !important;
height: 195px !important;
background-color:#E1915C !important;	
}
}
.noncomm12DeatilsNavimage
{
background-color: #E1915C;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #9C4105;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.noncomm12DeatilsNavimage
{
background-color: #E1915C;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #9C4105;
cursor: pointer;
z-index: 100;
height: 15px;
}
}

.uberAlertHearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color: #BFA12C;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.uberAlertHearderLabelDiv
{
height: 60px;
padding-top: 36%;
text-align: center;
background-color: #BFA12C;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}
.deviceBaterryConHearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color:#ff4747;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.deviceBaterryConHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #ff4747;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}
.gpsTampCrossBorderAlertCountDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color:#C784C7;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.gpsTampCrossBorderAlertCountDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #C784C7;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}
.hubArrivalHearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color: #E1915C;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.hubArrivalHearderLabelDiv
{
height: 60px;
padding-top: 36%;
text-align: center;
background-color: #E1915C;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.uberAlertCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: #BFA12C;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;

}
@media screen and (device-width:1920px){
.uberAlertCountDiv
{
height: 125px;
padding-top: 7px;
text-align: center;
background-color: #BFA12C;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;
}
}

.temperingHearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color: coral;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.temperingHearderLabelDiv
{
height: 60px;
padding-top: 36%;
text-align: center;
background-color: coral;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.temperingCountDiv
{
height: 50px;
text-align: center;
background-color: coral;
padding-top:7px;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;

}
@media screen and (device-width:1920px){
.temperingCountDiv
{
height: 125px;
padding-top: 51px;
padding-top:7px;
text-align: center;
background-color: coral;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;
}
}

.temperingDeatilsNavimage
{
background-color: coral;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #B5380A;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.temperingDeatilsNavimage
{
background-color: coral;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #B5380A;
cursor: pointer;
z-index: 100;
height: 15px;
}
}

.borderLimitNavimage
{
background-color: #A73523;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #211C1C;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.borderLimitNavimage
{
background-color: #A73523;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #211C1C;
cursor: pointer;
z-index: 100;
height: 15px;
}
}

.borderLimitnav{

height: 115px !important;
background-color:#A73523 !important;	
}
@media screen and (device-width:1920px){
.borderLimitnav
{
height: 195px !important;
background-color:#A73523 !important;	
}
}
.borderLimitHearderCountDiv
{
height: 50px;
text-align: center;
background-color: #A73523;
padding-top:7px;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.borderLimitHearderCountDiv
{
height: 136px;
padding-top: 51px;
text-align: center;
padding-top:7px;
background-color: #A73523;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.borderLimitHearderDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color: #A73523;
color: #fff;
font-size:48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.borderLimitHearderDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #A73523;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}
.IdleAlertCountDiv
{
height:50px;
padding-top:7px;
text-align: center;
background-color: #F6CC2A;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.IdleAlertCountDiv
{
height: 136px;
padding-top: 51px;
text-align: center;
padding-top:7px;
background-color: #F6CC2A;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.idleAlertHearderLabelDiv
{
height: 65px;
padding-top: 14%;
text-align: center;
background-color:#F6CC2A;
color: #fff;
font-size: 200%;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.idleAlertHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #F6CC2A;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.idleAlertDeatilsNav
{
width: 10px;
height: 115px;
background-color: #F6CC2A !important;	
}
@media screen and (device-width:1920px){
.idleAlertDeatilsNav
{
width: 10px;
height: 195px;
background-color: #F6CC2A !important;	
}
}

.idleAlertDeatilsNavimage
{
background-color: #F6CC2A;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #AB8A0E;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
	.idleAlertDeatilsNavimage
{
background-color: #F6CC2A;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #AB8A0E;
cursor: pointer;
z-index: 100;
height: 15px;
}
}

.paniciconlabel
{
height: 115px;
background-color:#D60606;
background-repeat: no-repeat;
background-size: 75%;
background-image: url(/ApplicationImages/AlertIcons/Distress.png) !important;
background-position-x: 50%;
background-position-y: 30%;
}
@media screen and (device-width:1920px){
	.paniciconlabel
{
height: 195px;
background-color:#D60606;
background-repeat: no-repeat;
background-image: url(/ApplicationImages/AlertIcons/Distress.png) !important;
background-size: 70%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.temperingconlabel{
height: 115px;
background-color:tomato;
background-repeat: no-repeat;
background-image: url(/ApplicationImages/AlertIcons/MainPowerOnOff.png) !important;
background-size: 60%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
	.temperingconlabel
{
height: 195px;
background-color:tomato ;
background-image: url(/ApplicationImages/AlertIcons/MainPowerOnOff.png) !important;
background-repeat: no-repeat;
background-size: 70%;
background-position-x: 50%;
background-position-y: 50%;
}
}



.idleiconlabel{
height: 115px;
background-color:#E7BD1B;
background-image: url(/ApplicationImages/AlertIcons/Idle.png) !important;
background-repeat: no-repeat;
background-size: 75%;
background-position-x: 50%;
background-position-y: 30%;
}
@media screen and (device-width:1920px){
	.idleiconlabel
{
height: 195px;
background-color:#E7BD1B;
background-image: url(/ApplicationImages/AlertIcons/Idle.png) !important;
background-repeat: no-repeat;
background-size: 70%;
background-position-x: 50%;
background-position-y: 50%;
}
}
.non_commiconlabel
{
height: 115px;
background-color:#D08452;
background-image: url(/ApplicationImages/DashBoard/no_gps_icon.png) !important;
background-repeat: no-repeat;
background-size: 75%;
background-position-x: 50%;
background-position-y: 30%;
}
@media screen and (device-width:1920px){
	.non_commiconlabel
{
height: 195px;
background-color:#D08452;
background-image: url(/ApplicationImages/DashBoard/no_gps_icon.png) !important;
background-repeat: no-repeat;
background-size: 70%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.temperingDeatilsNav
{
width: 8px;
height: 115px;
background-color: #5C8C2E !important;	

}

@media screen and (device-width:1920px){
.temperingDeatilsNav
{
width: 8px;
height: 195px;
background-color: #5C8C2E !important;	

}
}
.x-panel-body x-panel-body-noheader x-panel-body-noborder{
    height: 115px;
    background: #fefefe;
    background-color: #5C8C2E;
}
.preventivevehiclestatusmainpanel {
	height:250px !important ;
	width: 1342px ! important;
}
#ext-gen35{
    height:38px ! important;
    background-color: burlywood ! important; 
    margin-bottom: 0px;
    margin-left: 0.5%;
    margin-right: 0.5%;
    margin-top: 0.5%;
    font-size: 20px ! important;
}
.crossBorderLimit
{
height: 115px;
background-color: #840E0E;
background-image: url(/ApplicationImages/AlertIcons/CrossedBorder.png) !important;
background-repeat: no-repeat;
background-size: 65%;
background-position-x: 50%;
background-position-y: 40%;
}

@media screen and (device-width:1920px){
	.crossBorderLimit
	{
	height: 195px;
	background-color: #840E0E;
	background-image: url(/ApplicationImages/AlertIcons/CrossedBorder.png) !important;
	background-repeat: no-repeat;
	background-size: 70%;
	background-position-x: 50%;
	background-position-y: 50%;
	}
}
#borderLimitId{
	margin-top: 0.5%;
	margin-left: 0.5% !important;
   margin-bottom:0.5% !important;
   
}
#idleAlertId{
	margin-top: 0.5%;
	margin-left: 0.5% !important;
   margin-bottom:0.5% !important;
   
}


</style>		
	</head>	    
 
  <body onload="timeoutrefresh();">
  <div class="headerbox">
   <p><%=genericDashboard%></p>
  </div>
   <img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index: 4;left: 50%;top: 50%;">
						<div class="alert-mask" id="alert-mask-id"></div>
   <jsp:include page="../Common/ImportJSCashVan.jsp" />
<!--    <script type="text/javascript" src="https://www.google.com/jsapi"></script>-->
 <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   <script>

   google.load("visualization", "1", {
    packages: ["corechart"]
});
google.setOnLoadCallback(setGoogleLoad());
var outerPanel;
var ctsb;
var panel1;
var overspeedcount = "";
var offset = <%=offset%>;
var alertpannelorder = "";
var dtcur = datecur;
var googleLoad = false;
Ext.Ajax.timeout = 360000;
var insideYardVehicleList;
var simVehicleList;
var amperingVehicleList;
var onRoadVehicleList;
function setGoogleLoad() {
    googleLoad = true;
}
//******************************************** Refresh in IE after 1 sec for solving alignment issues *************************
function timeoutrefresh() {
    setTimeout('initrefresh()', 100);
}

function initrefresh() {
    if (Ext.isIE) {
        if (document.URL.indexOf("#") == -1) {
            url = document.URL + "#";
            location = "#";
            location.reload();
        }
    }
}

//******************************** check session ************************//

function CheckSession() {
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=checkSession',
        method: 'POST',
        success: function(response, options) {
            if (response.responseText == 'InvalidSession') {
                window.location.href = "<%=request.getContextPath()%>/Jsps/Common/SessionDestroy.html";
            }
        },
        failure: function() {}
    });
}  

var alertCountStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getNonCommunicationAlertCount',
    id: 'AlertCountRoot',
    root: 'NonCommunicatingAlertCountRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['suspectedSIMCount', 'insideYardCount', 'onRoadCount', 'nonComm48HrsCount', 'suspectedTamperingCount','insideYardVehicle', 'simRelatedVehicle','tamperingVehicle','onRoadVehicle']
});



/*****************************function call for displaying Total Assets******************************************************/
function totalAssetsAlert() {
    alertCountStore.load({
        params: {
            alertList: '<%=alertID%>'
        },
        callback: function() {
            if (alertCountStore.getCount() > 0) {
                CheckSession();
                var rec = alertCountStore.getAt(0);
                document.getElementById('simCountId').innerHTML = rec.data['suspectedSIMCount'];
                document.getElementById('temperingdivid').innerHTML = rec.data['suspectedTamperingCount'];
                document.getElementById('onRoadAlertdivid').innerHTML = rec.data['onRoadCount'];
                document.getElementById('insideYarddivid').innerHTML = rec.data['insideYardCount'];
                document.getElementById('non_commdivid').innerHTML = rec.data['nonComm48HrsCount'];
                insideYardVehicleList=rec.data['insideYardVehicle'];
			    simVehicleList=rec.data['simRelatedVehicle'];
				amperingVehicleList=rec.data['tamperingVehicle'];
				onRoadVehicleList=rec.data['onRoadVehicle'];
                
                var el = document.getElementById('loadImage');
            el.parentNode.removeChild(el);
            var el1 = document.getElementById('alert-mask-id');
            el1.parentNode.removeChild(el1);
            }
        }
    });
    
}

var SIM_ISSUE_ALERT = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    width: '438px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    id: 'panicAlertId',
    layout: 'column',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        cls: 'paniciconlabel',
        id: 'paniciconId',
    }, {
        xtype: 'panel',
        id: 'paniccountcetailspannel',
        frame: false,
        border: false,
        width: '46%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="panicHearderLabelDiv" id="simCountId">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: green'
        }, {
            xtype: 'label',
            html: '<div class="panicCountDiv" id="panicHeader">Suspected SIM Related Issue</div>',
            width: '100%',
            border: true,
        }]
    }, {
        xtype: 'panel',
        id: 'panicdetailsbuttonpannel',
        cls: 'panicDeatilsNav',
        width: '8%',
        frame: false,
        border: false,
        items: [{
            html: '<div class="panicDeatilsNavimage" id="panicnav" onclick="getNonCommunicationDetails(\'3\',\'Suspected SIM Related Issue\',\simVehicleList\);"></div>',
            xtype: 'panel',
            bodyCssClass: 'htmltotaldetailsnav',
            bodyStyle: 'background:#F52020',
            border: false
        }]
    }]
}); // End of Panel		
var TEMPERING = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    width: '438px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyStyle: 'background: white',
    id: 'temperingAlertId',
    layout: 'column',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'label',
        text: '',
        width: '46%',
        allowBlank: false,
        hidden: false,
        cls: 'temperingconlabel',
        id: 'temperinggId'
    }, {
        xtype: 'panel',
        id: 'temperingdetailspannel',
        frame: false,
        border: false,
        width: '44%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="temperingHearderLabelDiv" id="temperingdivid">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: green'
        }, {
            xtype: 'label',
            html: '<div class="temperingCountDiv" id="temperingHeader">Suspected Tampering</div>',
            width: '100%',
            border: true
        }]
    }, {
        xtype: 'panel',
        id: 'temperingdetailsbuttonpannel',
        cls : 'temperingDeatilsNav',
        height: 115,
        width: '8%',
        frame: false,
        border: false,
        bodyStyle: 'background: #FFFFFF !important',
        items: [{
            html: '<div class="temperingDeatilsNavimage" id="temperingdetailsnav" onclick="getNonCommunicationDetails(\'4\',\'Suspected Tampering\',\amperingVehicleList\);"></div>',
            xtype: 'panel',
            height: 115,
            bodyStyle: 'background: coral',
            border: false
        }]
    }]
}); // End of Panel	
var NON_COMM_12 = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    width: '438px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyStyle: 'background: white',
    id: 'nonComm12Id',
    layout: 'column',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        cls: 'non_commiconlabel',
        id: 'nonComm12_Id',
    }, {
        xtype: 'panel',
        id: 'non_pannel',
        frame: false,
        border: false,
        width: '46%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="Noncomm12HearderLabelDiv" id="non_commdivid">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: green',
            id: 'non_commid',
        }, {
            xtype: 'label',
            html: '<div class="noncomm12CountDiv" id="non_commHeader">NC More Than 48 Hours</div>',
            width: '100%',
            border: true,
        }]
    }, {
        xtype: 'panel',
        id: 'non_commbuttonpannel',
        cls: 'noncomm12DeatilsNav',
        width: '8%',
        frame: false,
        border: false,
        items: [{
            html: '<div class="noncomm12DeatilsNavimage" id="noncomm12detailsnav" onclick="getNonCommunicationDetails(\'1\',\'Vehicle Not Communicating More Than 48 hrs\',\' \');"></div>',
            xtype: 'panel',
            bodyCssClass: 'htmltotaldetailsnav',
            bodyStyle: 'background:#E1915C',
            border: false
        }]
    }]
});


var INSIDE_YARD_ALERT = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    collapsible: false,
    hidden: true,
    width: '438px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyStyle: 'background: white',
    id: 'borderLimitId',
    layout: 'column',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        cls: 'crossBorderLimit',
        id: 'borderfootersaid'
    }, {
        xtype: 'panel',
        id: 'borderLimitdetalspannel',
        frame: false,
        border: false,
        width: '46%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="borderLimitHearderDiv" id="insideYarddivid">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: green'
        }, {
            xtype: 'label',
            html: '<div class="borderLimitHearderCountDiv" id="borderLimitHeader">Inside Yard/Service Station </div>',
            width: '100%',
            border: true,
            id: 'borderLimitdetailssaid1'
        }]
    }, {
        xtype: 'panel',
        id: 'borderLimitbuttonpannel',
        cls: 'borderLimitnav',
        width: '8%',
        frame: false,
        border: false,
        items: [{
            html: '<div class="borderLimitNavimage" id="borderLimitnav" onclick="getNonCommunicationDetails(\'2\',\'Inside Yard / SC Vehicles\',\insideYardVehicleList\);"></div>',
            xtype: 'panel',
            bodyCssClass: 'htmltotaldetailsnav',
            bodyStyle: 'background:#A73523',
            border: false
        }]
    }]
});


var ON_ROAD_ALERT = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    hidden: true,
    border: false,
    collapsible: false,
    width: '438px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyStyle: 'background: white',
    id: 'idleAlertId',
    layout: 'column',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        id: 'idleiconId',
        cls: 'idleiconlabel'
    }, {
        xtype: 'panel',
        id: 'noncommcountcetailspannel',
        frame: false,
        border: false,
        width: '46%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="idleAlertHearderLabelDiv" id="onRoadAlertdivid">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: green'
        }, {
            xtype: 'label',
            html: '<div class="IdleAlertCountDiv" id="idleAlertHeader">On Road Vehicles</div>',
            width: '100%',
            border: true
        }]
    }, {
        xtype: 'panel',
        id: 'idledetailsbuttonpannel',
        cls: 'idleAlertDeatilsNav',
        width: '8%',
        frame: false,
        border: false,
        items: [{
            html: '<div class="idleAlertDeatilsNavimage" id="idledetailsnav" onclick="getNonCommunicationDetails(\'5\',\'On Road Vehicles\',\onRoadVehicleList\);"></div>',
            xtype: 'panel',
            bodyCssClass: 'htmltotaldetailsnav',
            bodyStyle: 'background:#F6CC2A',
            border: false
        }]
    }]
});



function getNonCommunicationDetails(alertId,alertName,RegNo) {
	window.location = "<%=request.getContextPath()%>/Jsps/CarRental/NonCommunicationDashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName+"&RegNo="+RegNo;
}


var crusialAlertPanel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    //width: '1322 px',
    height: '120px',
    id: 'preventivevehiclestatusmainpanelid',
    bodyCssClass: 'preventivevehiclestatusmainpanel',
    layout: 'column',
    layoutConfig: {
        columns: 5
    },
    items: [NON_COMM_12,INSIDE_YARD_ALERT,SIM_ISSUE_ALERT,TEMPERING,ON_ROAD_ALERT ]
});


var heading1 = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    width: '100%',
    title: 'Bifurcation Of Non-Communicating Vehicles',
    id: 'graphpannel5',
    layout: 'column'
});


var graphpannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    width: '100%',
    id: 'graphpannel',
    items: [heading1, crusialAlertPanel]
});


var innerSecondMainPannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    height:385,
    border: false,
    autoScroll: true,
    width: '100%',
    id: 'innersecondmainpannel',
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [graphpannel]
});

var innerMainPannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    width: '100%',
    id: 'innermainpannel',
    items: [innerSecondMainPannel]
});
var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'dashboardinnerpanelgridpercentage',
                height:40,
                //bodyStyle: 'background: #ececec',
                border:false,
                frame:false,
                id: 'buttonpanel',
                layout: 'column',
                layoutConfig: {
                    columns: 12
                },
                items: [{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},
                    {
                        xtype: 'button',
                        text: 'Back',
                        id: 'backbuttonid',
                        cls: 'buttonstyle',
                        iconCls: 'backbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                   window.location ="<%=request.getContextPath()%>/Jsps/CarRental/DashBoard.jsp";
                                }
                            }
                        }
                    }
                ]
            }); // End of Panel	

//***************************  Main starts from here **************************************************
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        border: false,
        bodyCssClass: 'outerpaneldashboard',
        items: [innerMainPannel,buttonPanel]
    });

    totalAssetsAlert();

    <%
		Iterator itl = alert.entrySet().iterator();
 		while(itl.hasNext()) {
    	Map.Entry me = (Map.Entry)itl.next();
	%>
    
    Ext.getCmp('panicAlertId').show();
    Ext.getCmp('temperingAlertId').show();
    Ext.getCmp('borderLimitId').show();
    Ext.getCmp('nonComm12Id').show();
    Ext.getCmp('idleAlertId').show();
   

    <%} %>


});
   
   </script>
  </body>
</html>