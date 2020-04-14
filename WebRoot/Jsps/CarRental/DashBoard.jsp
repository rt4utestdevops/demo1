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

if(request.getParameter("cutomerIDPassed")!= null)
{
customerId=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}
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


<jsp:include page="../Common/header.jsp" />
 
		<title><%=cvsdashboard%></title>	
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
.panicHearderLabelDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color:lightgray;
color: darkorange;
font-size:48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.panicHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: lightgray;
color: darkorange;
font-size:45px;
font-family: Open Sans, Light;
}
}

.panicCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: lightgray;
color: darkorange;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.panicCountDiv
{
height: 136px;
padding-top: 7px;
text-align: center;
background-color: lightgray;
color: darkorange;
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
padding-top: 4%;
text-align: center;
background-color: lightgray;
color: red;
font-size:48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.Noncomm12HearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: lightgray;
color: red;
font-size:45px;
font-family: Open Sans, Light;
}
}

.noncomm12CountDiv
{
height: 50px;
text-align: center;
padding-top:7px;
background-color: lightgray;
color: red;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.noncomm12CountDiv
{
height: 136px;
text-align: center;
padding-top:7px;
background-color: lightgray;
color: red;
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
padding-top: 4%;
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
padding-top: 4%;
text-align: center;
background-color:#b5cc5f;
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
background-color: #b5cc5f;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}
.gpsTampCrossBorderAlertCountDiv
{
height: 65px;
padding-top: 4%;
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
padding-top: 4%;
text-align: center;
background-color: lightgray;
color: darkorange;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.hubArrivalHearderLabelDiv
{
height: 60px;
padding-top: 36%;
text-align: center;
background-color: lightgray;
color: darkorange;
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
.deviceBatConAlertCountDiv
{
height: 50px;
text-align: center;
background-color: #b5cc5f;
padding-top: 20px;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.deviceBatConAlertCountDiv
{
height: 135px;
padding-top: 20px;
text-align: center;
background-color: #b5cc5f;
color: #fff;
font-size: 15px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.gpstampcrossborderHearderLabelDiv
{
height: 50px;
text-align: center;
background-color: #C784C7;
padding-top: 20px;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.gpstampcrossborderHearderLabelDiv
{
height: 135px;
padding-top: 20px;
text-align: center;
background-color: #C784C7;
color: #fff;
font-size: 15px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.hubArrivalCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: lightgray;
color: darkorange;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;

}
@media screen and (device-width:1920px){
.hubArrivalCountDiv
{
height: 125px;
padding-top: 7px;
text-align: center;
background-color: lightgray;
color: darkorange;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;
}
}

.uberAlertDeatilsNavimage
{
background-color: #BFA12C;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #866B05;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.uberAlertDeatilsNavimage
{
background-color: #BFA12C;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #866B05;
cursor: pointer;
z-index: 100;
height: 15px;
}
}
.deviceBatConAlertDeatilsNavimage
{
background-color: #ff4747;
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
.deviceBatConAlertDeatilsNavimage
{
background-color: #ff4747;
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
.gpsTampCrossBorderNavimage
{
background-color: #C784C7;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #B255B2;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.gpsTampCrossBorderNavimage
{
background-color: #C784C7;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #B255B2;
cursor: pointer;
z-index: 100;
height: 15px;
}
}
devicebatteryDeatilsNav
{
width: 10px;
height: 115px;
background-color: #ffad47 !important;	
}
@media screen and (device-width:1920px){
	.devicebatteryDeatilsNav
{
width: 10px;
height: 195px;
background-color: #ffad47 !important;	
}
}
.hubArrivalDeatilsNavimage
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
.hubArrivalDeatilsNavimage
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

.oversppedHearderLabelDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color: #FBB83D;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.oversppedHearderLabelDiv
{
height: 60px;
padding-top: 36%;
text-align: center;
background-color: #FBB83D;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.overspeedCountDiv
{
height: 50px;
text-align: center;
padding-top: 20px;
background-color: #FBB83D;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;

}
@media screen and (device-width:1920px){
.overspeedCountDiv
{
height: 125px;
padding-top: 20px;
text-align: center;
background-color: #FBB83D;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;
}
}

.overspeedDeatilsNavimage
{
background-color: #FBB83D;
top:96px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #AF7917;
cursor: pointer;
z-index: 100;
height: 15px;
}
@media screen and (device-width:1920px){
.overspeedDeatilsNavimage
{
background-color: #FBB83D;
top:176px;
position: relative;
right: 0%;
border-top: 18px solid rgba(173, 72, 72, 0);
border-right: 15px solid #AF7917;
cursor: pointer;
z-index: 100;
height: 15px;
}
}
.temperingHearderLabelDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color: #1DDEB2;
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
background-color: #1DDEB2;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

.temperingCountDiv
{
height: 49px;
text-align: center;
background-color: #1DDEB2;
padding-top:20px;
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
padding-top: 20px;
text-align: center;
background-color: #1DDEB2;
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
background-color: #e0b14e;
padding-top:20px;
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
padding-top:20px;
background-color: #e0b14e;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.borderLimitHearderDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color: #e0b14e;
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
background-color: #e0b14e;
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
padding-top: 4%;
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
background-color:#10C9A0;
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
background-color:#10C9A0 ;
background-image: url(/ApplicationImages/AlertIcons/MainPowerOnOff.png) !important;
background-repeat: no-repeat;
background-size: 70%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.oversppedIconlabel{
height: 115px;
background-color: orange! important;
background-image: url(/ApplicationImages/AlertIcons/OverSpeed.png) !important;
background-repeat: no-repeat;
background-size: 60%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
	.oversppedIconlabel
{
height: 195px;
background-color: orange ! important;
background-image: url(/ApplicationImages/AlertIcons/OverSpeed.png) !important;
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
width: 10px;
height: 115px;
background-color: #5C8C2E !important;	
background:white;
}

@media screen and (device-width:1920px){
.temperingDeatilsNav
{
width: 10px;
height: 195px;
background-color: #5C8C2E !important;	
background:white;
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
.crossBorderLimit
{
height: 115px;
background-color: #E3A21A;
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
	background-color: #E3A21A;
	background-image: url(/ApplicationImages/AlertIcons/CrossedBorder.png) !important;
	background-repeat: no-repeat;
	background-size: 70%;
	background-position-x: 50%;
	background-position-y: 50%;
	}
}
.uberconlabel{
height: 115px;
background-color:#927917;
background-repeat: no-repeat;
background-image: url(/ApplicationImages/AlertIcons/uber1.png) !important;
background-size: 32%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
.uberconlabel
{
height: 195px;
background-color:#927917;
background-image: url(/ApplicationImages/AlertIcons/uber1.png) !important;
background-repeat: no-repeat;
background-size: 32%;
background-position-x: 50%;
background-position-y: 50%;
}
}
.devicebatteryconlabel{
height: 115px;
background-color:#99B433;
background-image: url(/ApplicationImages/AlertIcons/DeviceBatery.png) !important;
background-repeat: no-repeat;
background-size: 75%;
background-position-x: 50%;
background-position-y: 30%;
}
@media screen and (device-width:1920px){
.devicebatteryconlabel
{
height: 195px;
background-color:#99B433;
background-image: url(/ApplicationImages/AlertIcons/DeviceBatery.png) !important;
background-repeat: no-repeat;
background-size: 50%;
background-position-x: 50%;
background-position-y: 50%;
}
}
.gpstamperedcrossborderlabel{
height: 115px;
background-color:#B255B2;
background-image: url(/ApplicationImages/AlertIcons/CrossedBorder.png) !important;
background-repeat: no-repeat;
background-size: 75%;
background-position-x: 50%;
background-position-y: 30%;
}
@media screen and (device-width:1920px){
.gpstamperedcrossborderlabel
{
height: 195px;
background-color:#B255B2;
background-image: url(/ApplicationImages/AlertIcons/CrossedBorder.png) !important;
background-repeat: no-repeat;
background-size: 50%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.hubarrivalconlabel{
height: 115px;
background-color:#D08452;
background-repeat: no-repeat;
background-image: url(/ApplicationImages/AlertIcons/HubArrival.png) !important;
background-size: 75%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
.hubarrivalconlabel
{
height: 195px;
background-color:#D08452;
background-image: url(/ApplicationImages/AlertIcons/HubArrival.png) !important;
background-repeat: no-repeat;
background-size: 32%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.hubDepartureconlabel{
height: 115px;
background-color:#840E0E;
background-repeat: no-repeat;
background-image: url(/ApplicationImages/AlertIcons/HubDeparture.png) !important;
background-size: 75%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
.hubDepartureconlabel
{
height: 195px;
background-color:#840E0E;
background-image: url(/ApplicationImages/AlertIcons/HubDeparture.png) !important;
background-repeat: no-repeat;
background-size: 32%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.offRoadConLabel{
height: 115px;
background-color:#927917;
background-repeat: no-repeat;
background-image: url(/ApplicationImages/AlertIcons/ParkingAlert.png) !important;
background-size: 75%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
.offRoadConLabel
{
height: 195px;
background-color:#927917;
background-image: url(/ApplicationImages/DashBoard/vcl_offroad_icon.png) !important;
background-repeat: no-repeat;
background-size: 32%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.highUsageconlabel{
height: 115px;
background-color:#10A7CD;
background-image: url(/ApplicationImages/AlertIcons/HighUsage2.png) !important;
background-repeat: no-repeat;
background-size: 40%;
background-position-x: 50%;
background-position-y: 40%;
}
@media screen and (device-width:1920px){
	.highUsageconlabel
{
height: 195px;
background-color:#10A7CD;
background-image: url(/ApplicationImages/AlertIcons/HighUsage2.png) !important;
background-repeat: no-repeat;
background-size: 40%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.noGPSiconlabel
{
height: 115px;
background-color:#10C9A0;
background-image: url(/ApplicationImages/AlertIcons/lock1.png) !important;
background-repeat: no-repeat;
background-size: 42%;
background-position-x: 50%;
background-position-y: 50%;
}
@media screen and (device-width:1920px){
.noGPSiconlabel
{
height: 195px;
background-color:#10C9A0;
background-image: url(/ApplicationImages/AlertIcons/lock1.png) !important;
background-repeat: no-repeat;
background-size: 42%;
background-position-x: 50%;
background-position-y: 50%;
}
}
.commCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: #2FAD33;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.commCountDiv
{
height: 136px;
padding-top: 7px;
text-align: center;
background-color: #2FAD33;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.noncommCountDiv
{
height:50px;
text-align: center;
padding-top: 7px;
background-color: lightgray;
color: darkorange;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.noncommCountDiv
{
height: 136px;
padding-top: 7px;
text-align: center;
background-color: lightgray;
color: darkorange;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.noncommHearderLabelDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color:lightgray!important;
color: orange;
font-size: 200%;
font-family: Open Sans, Light;

}
@media screen and (device-width:1920px){
.noncommHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: lightgray !important;
color: orange;
font-size:45px;
font-family: Open Sans, Light;
}
}
.noncommiconlabel{
height: 115px;
background-color:#E7BD1B !important;
background-image: url(/ApplicationImages/DashBoard/no_comm_l24.png) !important;
background-repeat: no-repeat;
background-size: 75%;
background-position-x: 50%;
background-position-y: 30%;
}
.vehicleoffHearderLabelDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color:#5643c7;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.vehicleoffHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: #CACC6B;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}
.vehicleoffCountDiv1
{
height: 50px;
text-align: center;
background-color: #5643c7;
color: #fff;
font-size: 60%;
font-family: 'Open Sans', sans-serif;
}
@media screen and (device-width:1920px){
.vehicleoffCountDiv1
{
height: 125px;
padding-top: 51px;
text-align: center;
background-color: #CCBA99;
color: #fff;
font-size: 20px;
font-family: 'Open Sans', sans-serif;
}
}
.noGPSCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: #1DDEB2;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.noGPSCountDiv
{
height: 136px;
padding-top: 7px;
text-align: center;
background-color: #1DDEB2;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.dashBoarderHearderCountDiv
{
height: 50px;
text-align: center;
padding-top: 7px;
background-color: #9ED43E;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.dashBoarderHearderCountDiv
{
height: 136px;
padding-top: 7px;
text-align: center;
background-color: #9ED43E;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.vehicleonCountDiv
{
height: 50px;
text-align: center;
padding-top: 20px;
background-color: #18B4DC;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;

}
@media screen and (device-width:1920px){
.vehicleonCountDiv
{
height: 125px;
padding-top: 20px;
text-align: center;
background-color: #18B4DC;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
word-break: break-word !Important;
word-wrap: break-word !Important;
}
}
.vehicleoffCountDiv
{
height: 50px;
text-align: center;
background-color: #5643c7;
padding-top: 7px;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.vehicleoffCountDiv
{
height: 135px;
padding-top: 7px;
text-align: center;
background-color: #5643c7;
color: #fff;
font-size: 20px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}
.voltagedrainCountDiv
{
height: 50px;
text-align: center;
background-color: coral;
padding-top: 20px;
color: #fff;
font-size: 60%;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
@media screen and (device-width:1920px){
.voltagedrainCountDiv
{
height: 135px;
padding-top: 20px;
text-align: center;
background-color: coral;
color: #fff;
font-size: 15px;
font-family: 'Lato', Calibri, Arial, sans-serif;
}
}


.voltagedrainlabel{
height: 115px;
background-color:tomato;
background-image: url(/Telematics4uApp/Main/images/low_battery.png) !important;
background-repeat: no-repeat;
background-size: 75%;
background-position-x: 50%;
background-position-y: 30%;
}
@media screen and (device-width:1920px){
	.voltagedrainlabel
{
height: 195px;
background-color:tomato;
background-image: url(/Telematics4uApp/Main/images/low_battery.png) !important;
background-repeat: no-repeat;
background-size: 50%;
background-position-x: 50%;
background-position-y: 50%;
}
}

.voltagedrainHearderLabelDiv
{
height: 65px;
padding-top: 4%;
text-align: center;
background-color:coral;
color: #fff;
font-size: 48px;
font-family: Open Sans, Light;
}
@media screen and (device-width:1920px){
.voltagedrainHearderLabelDiv
{
height: 48px;
padding-top: 36%;
text-align: center;
background-color: coral;
color: #fff;
font-size:45px;
font-family: Open Sans, Light;
}
}

voltagedrainDeatilsNav
{
width: 10px;
height: 115px;
background-color: coral !important;	
}
@media screen and (device-width:1920px){
	.voltagedrainDeatilsNav
{
width: 10px;
height: 195px;
background-color: coral !important;	
}
}

.voltagedrainDeatilsNavimage
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
	.voltagedrainDeatilsNavimage
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
#voltageDrainId{
	margin-left: 2.5% !important;
    margin-top: 10px !important;
}
#deviceBatteryConnId{
    margin-left: 2.5% !important;
    margin-top: 10px !important;
}
#gpsTamperedCrossBorderId{
    margin-left: 4.5% !important;
    margin-top: 10px;
}
#NoncommpanelId{
    margin-left: 2.8% !important;
    margin-top: 10px;
    width:117px;
}
#proactivepanelId{
    margin-left: 2.5% !important;
    margin-top: 10px;
    width:191px;
}
#vehicleOffroadId{
	margin-left: 2.2% !important;
    margin-top: 10px !important;
}	
.x-column-inner{
	width: 655px;
}
#preventivevehiclestatusmainpanelid{
    width: 50%;
    margin-left: 26px;
}
#informativeAlertmainpanelid{
    width: 48%;
}
@media screen and (device-width:1920px){
#informativeAlertmainpanelid{
    width: 47%;
}
}
#maintancepanelid{
    width: 100%;
    //height: 155px;
    
}
#ctbid{
    margin-right: 2.5% !important;
    margin-left: 2.5% !important;
    margin-top: 10px !important;
        width: 191px;
}
#overspeedId{
    margin-left: 2.5% !important;
    margin-top: 10px !important;
}
#commpanelid{
    margin-top: 10px !important;
    margin-left: 0.5% !important;
     width: 183px;
}
.dashboardinnerpanelAssetsCashVanPannel{
	width: 290px;
}
#borderLimitId{
    margin-left: 2.5% !important;
    margin-top: 10px !important;
}
#temperingAlertId{
	margin-top: 10px !important;
	margin-left: 4.5% !important;
	margin-bottom:0px !important;
	margin-right:0px !important;
}
#labelId{
	font-size: x-large;
    border: solid;
    border-color: white;
    border-radius: 15px 50px;
    padding-left:225px;
    border-style: double;
     color: white;
}
#label1Id{
	font-size: x-large;
    border: solid;
    border-color: white;
    border-radius: 15px 50px;
    padding-left:225px;
    border-style: double;
    color: white;
}
#labelIdNon{
	font-size: large !important;
    border: solid;
    border-color: white;
    border-radius: 15px 50px;
    padding-left:110px;
    border-style: double;
    color: white;
}
@media screen and (device-width:1920px){
#labelIdNon{
	font-size: large !important;
    border: solid;
    border-color: white;
    border-radius: 15px 50px;
    padding-left:110px;
    border-style: double;
    color: white;
}
}
#maintancelabelId{
	font-size: x-large;
    border: solid;
    border-color: white;
    border-radius: 15px 50px;
    padding-left:557px;
    border-style: double;
    color: white;
}
#highUsageid{
	margin-left: 1.5% !important;
    margin-top: 10px;
}
#proactiveiconId{
    background-color: #603CBA;
}
#alertfootersaid{
	display:none;
}
#commiconId{
	display:none;
}
#proactiveiconId{
	display:none;
}
#hubDepartureId{
	width: 100px;
}
#hubArrivalId{
	width: 107px;
}
#panicAlertId{
	width: 135px;
}
#hubdeparturePannel{
	margin-top:7px;
}
#hubArrivalpannel{
	width:100%;
	margin-top:7px;
	margin-left:3px;
}
#paniccountcetailspannel{
	margin-top:7px;
	margin-left:13px;
}
#immobilizedid{
	margin-top:7px;
}
#nonComm12Id{
	width:112px;
}
#non_pannel{
	margin-top:7px;
}
#NonCommcountcetailspannel{
	    margin-left: 6px;
}
#labelNonId
{
	width:  79% !important;
    padding-left: 100px;
}
.x-panel-body{
	background-color: #242844;
    background-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zd…B5PSIwIiB3aWR0aD0iMSIgaGVpZ2h0PSIxIiBmaWxsPSJ1cmwoI3ZzZ2cpIiAvPjwvc3ZnPg==);
    background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, color-stop(0, rgb(29, 93, 141)), color-stop(0.164, rgb(37, 35, 62)));
    background-image: -webkit-linear-gradient(top, rgb(29, 93, 141) 0%, rgb(37, 35, 62) 16.4%);
    background-image: linear-gradient(to bottom, rgb(29, 93, 141) 0%, rgb(37, 35, 62) 16.4%);
    background-image: -ms-linear-gradient(top, rgb(29, 93, 141) 0%, rgb(37, 35, 62) 16.4%);
    font-family: 'Poppins', sans-serif;
}
.dashBoarderHearderDiv:hover , .voltagedrainHearderLabelDiv:hover , .commHearderLabelDiv:hover  , .vehicleoffHearderLabelDiv:hover ,
.vehicleonHearderLabelDiv:hover , .panicHearderLabelDiv:hover , .temperingHearderLabelDiv:hover , .Noncomm12HearderLabelDiv:hover , .borderLimitHearderDiv:hover ,
.oversppedHearderLabelDiv:hover , .uberAlertHearderLabelDiv:hover , .hubArrivalHearderLabelDiv:hover , .hubdepartureHearderLabelDiv:hover , .offRoadHearderLabelDiv:hover ,
.deviceBaterryConHearderLabelDiv:hover , .gpsTampCrossBorderAlertCountDiv:hover , .vehicleoffHearderLabelDiv:hover , .dashBoarderHearderDiv:hover{
   font-size: 70px;
}
.noncommHearderLabelDiv:hover{
	font-size: 50px;
}
.headerbox 
{
	padding: 6px 6px;
	background-color: #f8f8f8;
	height: 40px;
	border-top: 1px solid #bdbdbd;
	border-bottom: 1px solid #bdbdbd;
	box-shadow: 4px 0px 6px #bdbdbd;
	margin-bottom: 4px;
	display: block;
	font-size: 24px;
	color: #5eb9f9;
	padding: 2px 2px;
	font-weight: 300;
	width:88%;
}
.refresh1{
    float: right;
    width: 85px;
    margin-right: 25px;
    margin-top: -32px;
    
    }
	.footer {
		bottom : -5px !important;
	}
	#preventivevehiclestatusmainpanelid {
		margin-left: 0px !important; 
	}
	label {
		display : inline !important;
	}
	label#proactiveiconId {
		width : 0px !important;
	}
	#maintancepanelid{
		//height: 0px !important;    
	}
	.offRoadCountDiv {
		padding-top : 0px !important;
	}
	#proactivepanelId {
		margin-left: 0% !important;    
	}	
	#vehicleOffroadId {
		margin-left: 1.2% !important;
	}
	#informativeAlertmainpanelid {
		width: 50% !important;
	}
</style>
		

 
<!--  <body  onload="timeoutrefresh();">   -->
  <div class="headerbox"><p><%=genericDashboard%></p></div>
  <div class="refresh1">
  <button onclick="refresh()" style=" width: 122px; margin-left: -27px;height: 34px;margin-top: -13px; border-radius: 8px; background-color: deepskyblue;">Refresh</button>
  </div>
  <img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index: 4;left: 50%;top: 50%;">
						<div class="alert-mask" id="alert-mask-id"></div>
  <jsp:include page="../Common/ImportJSCashVan.jsp" />
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
window.onload = function () { 
	timeoutrefresh();
}
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

//******************************************** Refresh after 30 min for solving alignment issues*************************   
function refresh() {
   // window.location = "<%=request.getContextPath()%>/Jsps/CashVanManagement/CVSStatusDashboard.jsp?cutomerIDPassed=" + Ext.getCmp('custmastcomboId').getValue();
}

//********************************************************Pie Chart Store***********************************************************************		
var communicatingNonCommunicatingStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getCommNonCommunicatingVehicles',
    id: 'CommNoncommroot',
    root: 'CommNoncommroot',
    autoLoad: false,
    remoteSort: true, 
    fields: ['communicating', 'noncommunicating', 'totalAssets', 'immobilizedCount','highUsageCount','underMaintanceCount','voltagedrain']
});

var alertCountStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getAlertCount',
    id: 'AlertCountRoot',
    root: 'AlertCountRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['overspeedAlertCount', 'distressAlertCount', 'crossBorderlertCount', 'idleAlertCount', 'mainPowerAlertCount','noncommunicating_12','uberAlertCount','hubArrivalCount','hubDepartureCount','vehicleoffRoadCount','deviceBateryCount','gpsTampCrossBorderCount','nonCommunicationCount','proactiveMaintenanceCount']
});

/*****************function call for displaying vehicle On/Off Road count*******************************/
function vehicleOnOffAlert() {
    CheckSession();
    var result;
    var poorSatellite = 0;
    var vehicleOff = 0;
    var tripcount = 0;
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleOnOffAlert',
        method: 'POST',
        params: {
            custID: '<%=customerId%>',
            Alert_Id: 'vehicleonoff'
        },
        success: function(response, options) {
            if (response.responseText == 'undefined' || response.responseText == '') {
                document.getElementById('vehicleoffdivid').innerHTML = vehicleOff;
                document.getElementById('vehicleoffdivid1').innerHTML=tripcount;
            } else {
                result = response.responseText.split(",");
                if (result != null) {
                    vehicleOff = result[0];
                    tripcount = result[1];
                }
                document.getElementById('vehicleoffdivid').innerHTML = vehicleOff;
                document.getElementById('vehicleoffdivid1').innerHTML=tripcount;
            }
        },
        failure: function() {
            document.getElementById('vehicleoffdivid').innerHTML = vehicleOff;
            document.getElementById('vehicleoffdivid1').innerHTML=tripcount;
        }
    });

    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getPoorSatelliteCount',
        method: 'POST',
        success: function(response, options) {
            if (response.responseText == 'undefined' || response.responseText == '') {
                document.getElementById('vehicleondivid').innerHTML = poorSatellite;

            } else {
                poorSatellite = response.responseText;
                document.getElementById('vehicleondivid').innerHTML = poorSatellite;
            }
        },
        failure: function() {
            document.getElementById('vehicleondivid').innerHTML = poorSatellite;
        }
    });

}
/*****************************function call for displaying Total Assets******************************************************/
function totalAssetsAlert() {
    communicatingNonCommunicatingStore.load({
        params: {
            custID: '<%=customerId%>'
        },
        callback: function() {
            if (communicatingNonCommunicatingStore.getCount() > 0) {
                CheckSession();
                var rec = communicatingNonCommunicatingStore.getAt(0);
                document.getElementById('commdivid').innerHTML = rec.data['communicating'];
                document.getElementById('totalasset').innerHTML = rec.data['totalAssets'];
                document.getElementById('voltagedraindivid').innerHTML = rec.data['voltagedrain'];
              
            }
        }
    });
    alertCountStore.load({
        params: {
            alertList: '<%=alertID%>'
        },
        callback: function() {
            if (alertCountStore.getCount() > 0) {
                CheckSession();
                var rec = alertCountStore.getAt(0);
                document.getElementById('overspeeddivid').innerHTML = rec.data['overspeedAlertCount'];
                document.getElementById('temperingdivid').innerHTML = rec.data['mainPowerAlertCount'];
                document.getElementById('borderLimit').innerHTML = rec.data['crossBorderlertCount'];
                document.getElementById('deviceBaterydivid').innerHTML = rec.data['deviceBateryCount'];
                document.getElementById('gpstampcrossborderdivid').innerHTML = rec.data['gpsTampCrossBorderCount'];
                document.getElementById('proactivemaindivid').innerHTML = rec.data['proactiveMaintenanceCount'];
                
                 var el = document.getElementById('loadImage');
	            el.parentNode.removeChild(el);
	            var el1 = document.getElementById('alert-mask-id');
	            el1.parentNode.removeChild(el1);
            }
        }
    });
    
}
var NonCommalertCountStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getNonCommunicationAlertCount',
    id: 'AlertCountRoot',
    root: 'NonCommunicatingAlertCountRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['suspectedSIMCount', 'insideYardCount', 'onRoadCount', 'nonComm48HrsCount', 'suspectedTamperingCount','insideYardVehicle', 'simRelatedVehicle','tamperingVehicle','onRoadVehicle']
});



/*****************************function call for displaying Total Assets******************************************************/
function totalAlertCount() {
    NonCommalertCountStore.load({
        params: {
            alertList: '<%=alertID%>'
        },
        callback: function() {
            if (NonCommalertCountStore.getCount() > 0) {
                CheckSession();
                var rec = NonCommalertCountStore.getAt(0);
                document.getElementById('hubarrivaldivid').innerHTML = rec.data['suspectedSIMCount'];
                document.getElementById('panicCountId').innerHTML = rec.data['suspectedTamperingCount'];
                document.getElementById('nogpsdivid').innerHTML = rec.data['onRoadCount'];
                document.getElementById('hubDeparturedivid').innerHTML = rec.data['insideYardCount'];
                document.getElementById('Noncommdivid').innerHTML = rec.data['nonComm48HrsCount'];
                
                insideYardVehicleList=rec.data['insideYardVehicle'];
			    simVehicleList=rec.data['simRelatedVehicle'];
				amperingVehicleList=rec.data['tamperingVehicle'];
				onRoadVehicleList=rec.data['onRoadVehicle'];
                
            }
        }
    });
    
}

var TOTAL_ASSET = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    collapsible: false,
    hidden: true,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'ctbid',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        cls: 'assetIconlabel',
        id: 'alertfootersaid'
    }, {
        xtype: 'panel',
        id: 'statucountdetalspannel',
        frame: false,
        border: false,
        width: '81%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        bodyCfg : { style: {'background-color': 'transparent'} },
        items: [{
            xtype: 'label',
            html: '<div class="dashBoarderHearderDiv" id="totalasset" onclick="gotoMapView(\'all\');">0</div>',
            width: '100%',
            border: true,
            bodyCfg : { style: {'background-color': 'transparent'} },
            id: 'alertdetailsctbid1',
        }, {
            xtype: 'label',
            html: '<div class="dashBoarderHearderCountDiv" id="totalAssetHeader"><%=totalAssets%></div>',
            width: '100%',
            border: true,
            id: 'alertlbldetailssaid1'
        }]
    }]
});
var VOLTAGE_DRAIN = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'voltageDrainId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'voltagedraindetailspannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="voltagedrainHearderLabelDiv" id="voltagedraindivid" onclick="getVoltageDrainReport(\'-3\',\'maintance\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="voltagedrainCountDiv" id="voltagedrainHeader">Vehicle Battery Critically Low</div>',
            width: '100%',
            border: true
        }]
    }]
});
var COMMUNICATING = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'commpanelid',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        cls: 'commiconlabel',
        id: 'commiconId'
    }, {
        xtype: 'panel',
        id: 'Commcountcetailspannel',
        frame: false,
        border: false,
        width: '81%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="commHearderLabelDiv" id="commdivid"  onclick="gotoMapView(\'comm\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="commCountDiv" id="commHeader">Communicating</div>',
            width: '100%',
            border: true
        }]
    }]
});


var NONCOMMUNICATING = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    hidden: true,
    border: false,
    collapsible: false,
    width: '322px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'noncommpanelid',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        text: '',
        width: '46%',
        allowBlank: false,
        border: false,
        hidden: false,
        id: 'noncommiconId',
        cls: 'noncommiconlabel'
    }, {
        xtype: 'panel',
        id: 'noncommcountcetailspannel',
        frame: false,
        border: false,
        width: '81%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="noncommHearderLabelDiv" id="noncommdivid" onclick="gotoMapView(\'noncomm\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="noncommCountDiv" id="noncommHeader">Non Communicating</div>',
            width: '100%',
            border: true
        }]
    }]
});

var UNDER_MAINTANCE = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'vehicleOffRoadId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'label',
        text: '',
        width: '46%',
        allowBlank: false,
        hidden: false,
        cls: 'vehicleoffconlabel',
        id: 'vehicleOffRoadIconId'
    }, {
        xtype: 'panel',
        id: 'vehicleOffRoaddetailspannel',
        frame: false,
        border: false,
        width: '54%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="vehicleoffHearderLabelDiv" id="vehicleoffdivid" onclick="getUnderMaintanceReport(\'-3\',\'maintance\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="vehicleoffCountDiv" id="vehicleoffHeader">Under Maintenance</div>',
            width: '100%',
            border: true
        }]
    }]
});

var HIGH_USAGE = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'highUsageid',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'highUsagepannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="vehicleonHearderLabelDiv" id="vehicleondivid" onclick="getHighUsageReport(\'-2\',\'highUsage\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="vehicleonCountDiv" id="vehicleonHeader">High Usage</div>',
            width: '100%',
            border: true
        }]
    }]
});



var PANIC_ALERT = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'panicAlertId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'paniccountcetailspannel',
        frame: false,
        border: false,
        width: '82%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="panicHearderLabelDiv" id="panicCountId" onclick="getNonCommunicationDetails(\'4\',\'Suspected Tampering\',\amperingVehicleList\);">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="panicCountDiv" id="panicHeader">Suspected Tampering</div>',
            width: '100%',
            border: true,
        }]
    }]
}); // End of Panel		
var TEMPERING = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'temperingAlertId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'temperingdetailspannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="temperingHearderLabelDiv" id="temperingdivid" onclick="getTamperingReport(\'145\',\'Main Power On/Off\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="temperingCountDiv" id="temperingHeader">GPS / Vehicle Wiring Tampered</div>',
            width: '100%',
            border: true
        }]
    }]
}); // End of Panel	
var NON_COMM_12 = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'nonComm12Id',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'non_pannel',
        frame: false,
        border: false,
        width: '96%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="Noncomm12HearderLabelDiv" id="nogpsdivid" onclick="getNonCommunicationDetails(\'5\',\'ON ROAD\',\onRoadVehicleList\);">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent',
            id: 'non_commid',
        }, {
            xtype: 'label',
            html: '<div class="noncomm12CountDiv" id="non_commHeader">ON ROAD</div>',
            width: '100%',
            border: true,
        }]
    }]
});


var BORDER_LIMIT = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    collapsible: false,
    hidden: true,
    //width: '100px',
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'borderLimitId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'borderLimitdetalspannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="borderLimitHearderDiv" id="borderLimit" onclick="getCrossBorderReport(\'84\',\'Crossed Border\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="borderLimitHearderCountDiv" id="borderLimitHeader">Outside border limit</div>',
            width: '100%',
            border: true,
            id: 'borderLimitdetailssaid1'
        }]
    }]
});


var OVER_SPEED = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'overspeedId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'overspeedpannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="oversppedHearderLabelDiv" id="overspeeddivid" onclick="getOverSpeedReport(\'2\',\'OverSpeed\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="overspeedCountDiv" id="overspeedHeader">Over Speed</div>',
            width: '100%',
            border: true
        }]
    }]
});



var UBER_ALERT = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'uberAlertId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'label',
        text: '',
        width: '46%',
        allowBlank: false,
        hidden: false,
        cls: 'uberconlabel',
        id: 'uberId'
    }, {
        xtype: 'panel',
        id: 'uberpannel',
        frame: false,
        border: false,
        width: '54%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="uberAlertHearderLabelDiv" id="uberdivid" onclick="getUberAlertReport(\'139\',\'Competitor Alert\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="uberAlertCountDiv" id="uberHeader">Uber Alert</div>',
            width: '100%',
            border: true
        }]
    }]
});

var HUB_ARRIVAL = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'hubArrivalId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'hubArrivalpannel',
        frame: false,
        border: false,
        width: '101%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="hubArrivalHearderLabelDiv" id="hubarrivaldivid" onclick="getNonCommunicationDetails(\'3\',\'Suspected SIM issue\',\simVehicleList\);">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="hubArrivalCountDiv" id="hubarrivalHeader">Suspected SIM issue</div>',
            width: '100%',
            border: true
        }]
    }]
});

var HUB_DEPARTURE = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'hubDepartureId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'hubdeparturePannel',
        frame: false,
        border: false,
        width: '103%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="hubdepartureHearderLabelDiv" id="hubDeparturedivid" onclick="getNonCommunicationDetails(\'2\',\'IN YARD / SC Vehicles\',\insideYardVehicleList\);">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="hubdepartureCountDiv" id="hubHeader">IN YARD</div>',
            width: '100%',
            border: true
        }]
    }]
});

var VEHICLE_OFF_ROAD = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'vehicleOffroadId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'offRoadPanel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="offRoadHearderLabelDiv" id="offRoaddivid" onclick="getPopUp();">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="offRoadCountDiv" id="offRoadHeader">Vehicle with Low Mileage</div>',
            width: '100%',
            border: true
        }]
    }]
});


var DEVICE_BATTERY_CONNECTION = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'deviceBatteryConnId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'devicebatteryConpannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="deviceBaterryConHearderLabelDiv" id="deviceBaterydivid" onclick="getDeviceBateryReport(\'-4\',\'DeviceBateryConnection Alert\');">0</div>',
            width: '100%',
            border: true,
            bodyCfg : { style: {'background-color': 'transparent'} },
        }, {
            xtype: 'label',
            html: '<div class="deviceBatConAlertCountDiv" id="deviceBatConHeader">Suspected Connection issue Or Tampering</div>',
            width: '100%',
            border: true
        }]
    }]
});
var GPS_TAMPERED_CROSS_BORDER = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'gpsTamperedCrossBorderId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'gpstamperedcrossborderpannel',
        frame: false,
        border: false,
        width: '100%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        items: [{
            xtype: 'label',
            html: '<div class="gpsTampCrossBorderAlertCountDiv" id="gpstampcrossborderdivid" onclick="getGPSTamperedCrossBorderReport(\'148\',\'GPS Tampered Crossed Border Alert\');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="gpstampcrossborderHearderLabelDiv" id="gpsTampCrossBorderHeader">GPS Tampered Crossed Border Alert</div>',
            width: '100%',
            border: true
        }]
    }]
});

var NON_COMMUNICATING = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'NoncommpanelId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'panel',
        id: 'NonCommcountcetailspannel',
        frame: false,
        border: false,
        width: '83%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        
     items: [{
           xtype: 'label',
            html: '<div class="noncommHearderLabelDiv" id="Noncommdivid" onclick="getNonCommunicationDetails(\'1\',\'NC >48 Hrs\',\' \');"></div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="noncommCountDiv" id="NoncommHeader">NC > 24 Hrs</div>',
            width: '100%',
            border: true
        }]
        }] 
});

var PROACTIVE_MAINTENANCE = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    collapsible: false,
    cls: 'dashboardinnerpanelAssetsCashVanPannel',
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'proactivepanelId',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'label',
        text: '',
        width: '46%',
        allowBlank: false,
        hidden: false,
        cls: 'vehicleoffconlabel',
        id: 'proactiveiconId'
    } ,{
        xtype: 'panel',
        id: 'proactivepannel',
        frame: false,
        border: false,
        width: '81%',
        cls: 'dashboardCashVanHeaderLabelStyle',
        
     items: [{
           xtype: 'label',
            html: '<div class="vehicleoffHearderLabelDiv" id="proactivemaindivid" onclick="getNonCommunicationDetails(\'6\',\'Possible Vehicle to lose visibility\',\' \');">0</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, {
            xtype: 'label',
            html: '<div class="vehicleoffCountDiv" id="proactivemainHeader">Possible Vehicle to lose visibility</div>',
            width: '100%',
            border: true
        }]
        }] 
});

function getNonCommunicationDetails(alertId,alertName,RegNo) {
	window.location = "<%=request.getContextPath()%>/Jsps/CarRental/NonCommunicationDashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName+"&RegNo="+RegNo;
}

function getVehicleOffRoadDetails(id) {
    window.location = "<%=request.getContextPath()%>/Jsps/Common/VehicleOffRoadDetails.jsp?pageId=" + id;
}
function gotoMapView(type) {
    if ('<%=loginInfo.getStyleSheetOverride()%>' == 'Y') {
        parent.firstLoad = 0;
        //parent.getVerticalMenus('#menu2', 19);
    }
    var status="dashboard";
    window.location = "<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp?vehicleType=" + type+"&status="+status ;
}
function gotoListView(type) {
    parent.firstLoad = 0;
    // parent.getVerticalMenus('#menu2', 19);
    window.location = "<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp?category=" + type;
}
function getPanicReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getTamperingReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getCrossBorderReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getIdleReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getOverSpeedReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getImmobilizedReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/HighUsageAlertReport.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getHighUsageReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/HighUsageAlertReport.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getNonCommunicating12Report(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getUnderMaintanceReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/UnderMaintanceDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getUberAlertReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getVoltageDrainReport(alertId,alertName) {

//alert('hi');
    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/VoltageDrainReport.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getOffRoadReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/OffRoadAlertReport.jsp?AlertId="+alertId+"&AlertName="+alertName;
}

function getHubArrivalReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getDeviceBateryReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DeviceBateryConnection.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getGPSTamperedCrossBorderReport(alertId,alertName) {

    window.location = "<%=request.getContextPath()%>/Jsps/CarRental/DashboardDetails.jsp?AlertId="+alertId+"&AlertName="+alertName;
}
function getNonCommunicatingCountDashboard() {

	window.location = "<%=request.getContextPath()%>/Jsps/CarRental/NonCommunicatingCountDashboard.jsp";
}
function getPopUp(){
	window.alert('Coming soon');
}
var CommisionedDecommisionedPannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    hidden: true,
    border: false,
    //width:'33%',
    //height:222,
    cls: 'CommisionedDecommisionedPannel',
    id: 'commisionedpanel1id',
    items: [{
        xtype: 'label',
        id: 'commisionedpannelHeader',
        text: '<%=commDeComm%>',
        hidden: true,
        // width:'100%',
        cls: 'dashboardpiechartheader'
    }, {
        xtype: 'panel',
        id: 'commisionedpiepannelid',
        cls: 'commisionedpiepannelidcls',
        border: false,
        html: '<table width="100%"><tr><tr> <td> <div id="commisioneddiv" class="commisionedpiepannelstatusidcls" align="left"> </div></td></tr></table>'
    }]
});

var VehiclLiveStatusPannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    hidden: true,
    cls: 'VehiclLiveStatusPannel',
    id: 'vehiclelivestatusid',
    items: [{
        xtype: 'label',
        id: 'vehiclestatuspannelHeader',
        text: 'Vehicle Live Status With Cash in Hand',
        hidden: true,
        cls: 'dashboardpiechartheader'
    }, {
        xtype: 'panel',
        id: 'vehiclelivedivid',
        cls: 'vehiclelivedividcls',
        border: false,
        html: '<table width="100%"><tr><tr> <td> <div id="vehiclelivestatus" class="vehiclelivestatusidcls" align="left"> </div></td></tr></table>'
    }]
});
var crusialAlertPanel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    id: 'preventivevehiclestatusmainpanelid',
    bodyCfg : { style: {'background-color': 'transparent'} },
    layout: 'column',
    layoutConfig: {
        columns: 4
    },
    items: [{
            xtype: 'label',
            html: '<div id="labelId" style="font-size: x-large;">Fleet Security</div>',
            width: '100%',
            border: true,
            bodyStyle: 'background-color: transperent'
        }, TEMPERING,BORDER_LIMIT, GPS_TAMPERED_CROSS_BORDER,DEVICE_BATTERY_CONNECTION]
});

var informativeAlertPanel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    id: 'informativeAlertmainpanelid',
    bodyCfg : { style: {'background-color': 'transparent'} },
    layout: 'column',
    layoutConfig: {
        columns: 4
    },
    items: [{
            xtype: 'label',
            html: '<div id="label1Id" style="font-size: x-large;">Fleet Visibility</div>',
            width: '100%',
            border: true,
            bodyCfg : { style: {'background-color': 'transparent'} },
        },TOTAL_ASSET, COMMUNICATING,PROACTIVE_MAINTENANCE,
        {
            xtype: 'label',
            html: '<div id="labelIdNon" style="font-size: x-large;">Non Communicating</div>',
            width: '100%',
            id:'labelNonId',
            border: true,
            bodyCfg : { style: {'background-color': 'transparent'} },
        }, NON_COMMUNICATING,HUB_DEPARTURE,HUB_ARRIVAL,PANIC_ALERT,NON_COMM_12]
});

var maintancePanel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    bodyCfg : { style: {'background-color': 'transparent'} },
    id: 'maintancepanelid',
    layout: 'column',
    layoutConfig: {
        columns: 4
    },
    items: [{
            xtype: 'label',
            html: '<div id="maintancelabelId" style="font-size: x-large;">Maintenance</div>',
            width: '100%',
            border: true
            //bodyStyle: 'background-color: transperent'
        },HIGH_USAGE, OVER_SPEED,VOLTAGE_DRAIN, VEHICLE_OFF_ROAD]
});


var graphpannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    border: false,
    width: '97%',
    id: 'graphpannel',
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [informativeAlertPanel, crusialAlertPanel,maintancePanel]
});

graphpannel.on("afterrender", function() {
    //this code will run after the panel renders.

});

var innerSecondMainPannel = new Ext.Panel({
    standardSubmit: true,
    frame: false,
    //height:485,
    border: false,
    autoScroll: true,
    bodyCssClass: 'innersecondmainpanneldashboard',
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

//***************************  Main starts from here **************************************************
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        border: false,
        //bodyCssClass: 'outerpaneldashboard',
        items: [innerMainPannel]
    });

    totalAssetsAlert();
	totalAlertCount();
	
	function refresh(){
		totalAssetsAlert();
		totalAlertCount();
	}

    <%
		Iterator itl = alert.entrySet().iterator();
 		while(itl.hasNext()) {
    	Map.Entry me = (Map.Entry)itl.next();
	%>
    if ('<%=me.getKey()%>' == 'VEHICLE_ON_OFF_ROAD') {
        Ext.getCmp('vehicleOffRoadId').show();
    } else if ('<%=me.getKey()%>' == 'TOTAL_ASSET') {
        Ext.getCmp('ctbid').show();
        setInterval(function() {
            totalAssetsAlert();
        }, 60000); // 1min refresh
    } else if ('<%=me.getKey()%>' == 'COMMUNICATING') {
        Ext.getCmp('commpanelid').show();
    } else if ('<%=me.getKey()%>' == 'NONCOMMUNICATING') {
        Ext.getCmp('noncommpanelid').show();
    }
    Ext.getCmp('panicAlertId').show();
    Ext.getCmp('overspeedId').show();
    Ext.getCmp('highUsageid').show();
    Ext.getCmp('temperingAlertId').show();
    Ext.getCmp('borderLimitId').show();
    Ext.getCmp('nonComm12Id').show();
    Ext.getCmp('uberAlertId').show();
    Ext.getCmp('voltageDrainId').show();
    Ext.getCmp('hubArrivalId').show();
    Ext.getCmp('hubDepartureId').show();
    Ext.getCmp('vehicleOffroadId').show();
    Ext.getCmp('deviceBatteryConnId').show();
    Ext.getCmp('gpsTamperedCrossBorderId').show();
    Ext.getCmp('NoncommpanelId').show();
    Ext.getCmp('proactivepanelId').show();
    <%} %>
});
   
   </script>
   <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->