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
if(request.getParameter("cutomerIDPassed")!= null)
{
customerId=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}

if(customerId == 0)
	{
		response.sendRedirect(request.getContextPath()+"/Jsps/Common/ApplicationMigration.html");
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
//getting alert id of all alert
Map <String,Integer> alert=cvmf.getCVSDashboardSettings(systemid);
String alert_REFUEL_LITERS="0";
String alert_STATUTORY_BARCHART="0";
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
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/dashBoard/css/component.css" />
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
.commisionedpiepannelstatusidcls {
    width: 100%;
    height: 250px;
}
.vehhicleInHubIcon{
	height: 115px;
    background-color: #C94224;
    background-image: url(/ApplicationImages/AlertIcons/HubArrival.png) !important;
    background-repeat: no-repeat;
    background-size: 65%;
    background-position-x: 50%;
    background-position-y: 30%;
}
.vehicleOtherHubIcon{
    height: 115px;
    background-color: #B8B85E;
    background-image: url(/ApplicationImages/AlertIcons/HubDeparture.png) !important;
    background-repeat: no-repeat;
    background-size: 75%;
    background-position-x: 50%;
    background-position-y: 30%;
}

label{
	display: inline;
	text-align: left;
    padding-left: -10px;
   
}
</style>	
	</head>	    
 
  <body onload="timeoutrefresh();">
  <div class="headerbox">
   <p><%=genericDashboard%></p>
  </div>
<!--   <img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index: 4;left: 50%;top: 50%;">-->
<!--						<div class="alert-mask" id="alert-mask-id"></div>-->
   <jsp:include page="../Common/ImportJSCashVan.jsp" />
<!--    <script type="text/javascript" src="https://www.google.com/jsapi"></script>-->
 <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   <script>

   
    google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(setGoogleLoad());
 var outerPanel;
 var ctsb;
 var panel1;
 var overspeedcount="";
 var offset=<%=offset%>;
 var alertpannelorder="";
 var dtcur = datecur;
 var googleLoad=false;
 Ext.Ajax.timeout = 360000;
 function setGoogleLoad()
 {
 googleLoad=true;
 }
//******************************************** Refresh in IE after 1 sec for solving alignment issues*************************
 function timeoutrefresh()
     {     
         	//setTimeout('refresh()',1800000);  not required as we solved Zooming Pie Chart Issue
         	setTimeout('initrefresh()',100);
     }
  function initrefresh()
    {
if (Ext.isIE)
{                 
if(document.URL.indexOf("#")==-1)
{
url = document.URL+"#";
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
            
//******************************************** Refresh after 30 min for solving alignment issues*************************   
function refresh()
{                 
window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/CVSStatusDashboard.jsp?cutomerIDPassed="+Ext.getCmp('custmastcomboId').getValue();
}

 //******************************store for getting customer name************************
  var custmastcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getallCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(cutstore, records, success, options) {
    				if(<%=custidpassed%>>0)
    				{
    				Ext.getCmp('custmastcomboId').setValue('<%=custidpassed%>');
    								 <%
									 		Iterator itc = alert.entrySet().iterator();
      										while(itc.hasNext()) {
         									Map.Entry me = (Map.Entry)itc.next();
		                 	 		 %>
		                 	  				callAlertFunction('<%=me.getKey()%>');

		                 	  		 <%
		                 	  				}
		                 	  		 %>
    				}
    				else if(<%=customerId%>>0)
    				{
    				Ext.getCmp('custmastcomboId').setValue('<%=customerId%>');
    								
    				}
    				}
    				}
	});

var custnamecombo=new Ext.form.ComboBox({
	        store: custmastcombostore,
	        id:'custmastcomboId',
	        mode: 'local',
	        hidden:false,
	        resizable:true,
	        forceSelection: true,
	        emptyText:'Select Customer',
	        blankText :'Select Customer',
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	        height:25,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'dashboardCombostyle',
	    	//hideMode: 'offsets',
	    	//listWidth:'15%',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
									 <%
									 	Iterator it = alert.entrySet().iterator();
      										while(it.hasNext()) {
         									Map.Entry me = (Map.Entry)it.next();
		                 	 		 %>
		                 	  				setTimeOut(callAlertFunction('<%=me.getKey()%>'),100);
		                 	  		 <%
		                 	  				}
		                 	  		 %>
		                 	  		 
		                 	   }}
                 	   }   
    });
    
function callAlertFunction(alertname)
{
if (alertname=='VEHICLE_ON_OFF_ROAD')
{vehicleOnOffAlert();
setInterval(function(){
vehicleOnOffAlert();
},60000);// 1min refresh
}
else if (alertname=='COMMISSIONED/DECOMMISIONED-PIECHART')
{
Ext.getCmp('commisionedpanel1id').show();
drawncommisionedPieChart();
setInterval(function(){
Ext.getCmp('commisionedpiepannelid').update('<table width="100%"><tr><tr> <td> <div id="commisioneddiv" class="commisionedpiepannelstatusidcls" align="left"> </div></td></tr></table>');
drawncommisionedPieChart();
},300000);// 5min refresh
}				                 	 
else if (alertname=='VEHICLELIVESTATUS-PIECHART')
{
Ext.getCmp('vehiclelivestatusid').show();
vehicleLiveStatusPieChart();
setInterval(function(){
Ext.getCmp('vehiclelivedivid').update('<table width="100%"><tr><tr> <td> <div id="vehiclelivestatus" class="vehiclelivestatusidcls" align="left"> </div></td></tr></table>');
vehicleLiveStatusPieChart();
},310000);// 5min refresh
}
}	   
 
 /*****************function call for displaying vehicle On/Off Road count*******************************/
     function vehicleOnOffAlert(){
     CheckSession();
      var result;
      var poorSatellite=0;
	   var vehicleOff=0;
		var tripcount=0;
      			Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleOnOffAlert',
                        method: 'POST',
                        params: {
                        	custID: '<%=customerId%>',
                        	Alert_Id:'vehicleonoff'
                        },
                        success: function (response, options)
                        {                                               
                        if(response.responseText=='undefined' || response.responseText=='')
                        {
                        document.getElementById('vehicleoffdivid1').innerHTML=tripcount;
                        }else
                        {
                        result = response.responseText.split(",");                        					    
					    if(result!=null)
					    {
					    tripcount=result[1];
					    }
                        document.getElementById('vehicleoffdivid1').innerHTML=tripcount;
                        }
                        },
                        failure: function ()
                        {
                        document.getElementById('vehicleoffdivid1').innerHTML=tripcount;
                        } 
                    });
                    
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getPoorSatelliteCount',
                        method: 'POST',                        
                        success: function (response, options)
                        {                                               
                        if(response.responseText=='undefined' || response.responseText=='')
                        {
                        document.getElementById('vehicleondivid').innerHTML=poorSatellite;
                        
                        }else
                        {
                        poorSatellite = response.responseText; 
                        document.getElementById('vehicleondivid').innerHTML=poorSatellite;            
                        }
                        },
                        failure: function ()
                        {
                        document.getElementById('vehicleondivid').innerHTML=poorSatellite;                        
                        } 
                    });
                    
     }
     
     function getVehicleCountInHub(){
     	vehicleHubCountStore.load({
			params:{custID:'<%=customerId%>'},
			callback:function(){
				if(vehicleHubCountStore.getCount()>0){
					CheckSession();
					var rec=vehicleHubCountStore.getAt(0);
					var insideHub = 0;
					var outsideHub = 0;
					if(rec.data['insideHub'] != null && rec.data['insideHub'] != ""){
						insideHub = rec.data['insideHub'];
					}
					if(rec.data['outsideHub'] != null && rec.data['outsideHub'] != ""){
						outsideHub = rec.data['outsideHub'];
					}
					document.getElementById('refueldivid').innerHTML=insideHub;
					document.getElementById('vehicleoffdivid').innerHTML=outsideHub; 
				}
			}	
     	});
     }	
     
/*****************************function call for displaying Total Assets******************************************************/    
function totalAssetsAlert(){
	communicatingNonCommunicatingStore.load({
	params:{custID:'<%=customerId%>'},
	callback:function()
	{
	if(communicatingNonCommunicatingStore.getCount()>0)
	{
	CheckSession();
	var rec=communicatingNonCommunicatingStore.getAt(0);
	document.getElementById('commdivid').innerHTML=rec.data['communicating'];
	document.getElementById('noncommdivid').innerHTML=rec.data['noncommunicating'];
	document.getElementById('nogpsdivid').innerHTML=rec.data['noGPS'];
	document.getElementById('totalasset').innerHTML=rec.data['totalAssets']; 
	}
	}						 			                
	});
}
/*****************************Panel for Total Assets******************************************************/
var TOTAL_ASSET = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		hidden:true,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'ctbid',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				cls:'assetIconlabel',
				id:'alertfootersaid'
				},		
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="dashBoarderHearderDiv" id="totalasset">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green',
				id:'alertdetailsctbid1',
				},
				{
				xtype: 'label',
				html: '<div class="dashBoarderHearderCountDiv" id="totalAssetHeader"><%=totalAssets%></div>',
				width:'100%',
				border:true,
				id:'alertlbldetailssaid1'
				}]},
				{
				xtype:'panel',
				id:'totaldetailsbuttonpannel',
				cls:'totaldetailsnav',
				//height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="totalDeatilsNavimage" id="totaldetailsnav" onclick="gotoMapView(\'all\');"></div>',
				xtype:'panel',
				//height:115,
				bodyCssClass:'htmltotaldetailsnav',
				bodyStyle: 'background:#9ED43E',
				border:false
				}]}]
		}); // End of Panel	
		
		
/*****************************Panel for NO GPS******************************************************/
var NO_GPS = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		hidden:true,		
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'nogpspanelid',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				cls:'noGPSiconlabel',
				id:'noGPSiconId',
				},		
				{
				xtype:'panel',
				id:'NOGPScountcetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="noGPSHearderLabelDiv" id="nogpsdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green',
				id:'noGPSdetailsid',
				},
				{
				xtype: 'label',
				html: '<div class="noGPSCountDiv" id="noGPSHeader"><%=noGPS%></div>',
				width:'100%',
				border:true,
				}]},
				{
				xtype:'panel',
				id:'nogpsdetailsbuttonpannel',
				cls:'nogpsDeatilsNav',
				//height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="nogpsDeatilsNavimage" id="nogpsdetailsnav" onclick="gotoMapView(\'noGPS\');"></div>',
				xtype:'panel',
				//height:115,
			    bodyCssClass:'htmltotaldetailsnav',
				bodyStyle: 'background:#1DDEB2',
				border:false
				}]}]
		}); // End of Panel		
		
/*****************************Panel for COMMUNICATING******************************************************/
var COMMUNICATING = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,	
		hidden:true,	
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'commpanelid',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				cls:'commiconlabel',
				id:'commiconId'
				},		
				{
				xtype:'panel',
				id:'Commcountcetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="commHearderLabelDiv" id="commdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="commCountDiv" id="commHeader"><%=comm%></div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'commdetailsbuttonpannel',
				cls:'commDeatilsNav',
				//height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="commDeatilsNavimage" id="commdetailsnav" onclick="gotoMapView(\'comm\');"></div>',
				xtype:'panel',
				//height:115,
				bodyCssClass:'htmltotaldetailsnav',
				bodyStyle: 'background:#F6CC2A',
				border:false
				}]}]
		}); // End of Panel	
		
/*****************************Panel for NON-COMMUNICATING******************************************************/
var NONCOMMUNICATING = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		hidden:true,
		border:false,		
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'noncommpanelid',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				id:'noncommiconId',
				cls:'noncommiconlabel' 
				},		
				{
				xtype:'panel',
				id:'noncommcountcetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="noncommHearderLabelDiv" id="noncommdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="noncommCountDiv" id="noncommHeader"><%=nonComm%></div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'noncommdetailsbuttonpannel',
				cls:'noncommDeatilsNav',
				//height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="noncommDeatilsNavimage" id="noncommdetailsnav" onclick="gotoMapView(\'noncomm\');"></div>',
				xtype:'panel',
				//height:115,
				bodyCssClass:'htmltotaldetailsnav',
				bodyStyle: 'background:#E1915C',
				border:false
				}]}]
		}); // End of Panel		
		
/*************************************** Panel for REFUEL ******************************************************/
var REFUEL = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,	
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'refuelpanelid',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'label',
				text:'',
				width:'46%',
				allowBlank: false,
				hidden:false,
				cls:'vehhicleInHubIcon',
				id:'refueliconId'
				
				},		
				{
				xtype:'panel',
				id:'refueldetailspannel',
				frame:false,
				border:false,
				width:'54%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="refuelHearderLabelDiv" id="refueldivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="refuelCountDiv" id="refuelHeader">Vehicle in Jotun HQ</div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'refueldetailsbuttonpannel',
				cls:'reduelDeatilsNav',
				height:115,
				width:'0%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="refuelDeatilsNavimage" id="refueldetailsnav"></div>',
				xtype:'panel',
				height:115,
				hidden:true,
				bodyStyle: 'background: #E0502E',
				border:false
				}]}]
		}); // End of Panel							
		
/*************************************** Panel for VEHICLE ON ROAD ******************************************************/

var VEHICLE_ON_ROAD = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,	
		hidden:true,	
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'vehicleOnRoadid',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'label',
				text:'',
				width:'46%',
				allowBlank: false,
				hidden:false,
				cls:'vehicleonconlabel',
				id:'vehicleOnRoadId'
				},		
				{
				xtype:'panel',
				id:'vehicleOnRoaddetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="vehicleonHearderLabelDiv" id="vehicleondivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="vehicleonCountDiv" id="vehicleonHeader"><%=vehicleOnRoad%></div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'vehicleOnRoaddetailsbuttonpannel',
				cls:'vehicleOnRoadDeatilsNav',
				height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="vehicleOnRoadDeatilsNavimage" id="vehicleondetailsnav" onclick="gotoListView(\'satCount\');"></div>',
				xtype:'panel',
				//height:115,	
				bodyCssClass:'htmltotaldetailsnav',				
				bodyStyle: 'background: #18B4DC',
				border:false
				}]}]
		}); // End of Panel	
		
/*************************************** Panel for VEHICLE OFF ROAD ******************************************************/

var VEHICLE_OFF_ROAD = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,	
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'vehicleOffRoadId',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'label',
				text:'',
				width:'46%',
				allowBlank: false,
				hidden:false,
				cls:'vehicleOtherHubIcon',
				id:'vehicleOffRoadIconId'
				},		
				{
				xtype:'panel',
				id:'vehicleOffRoaddetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="vehicleoffHearderLabelDiv" id="vehicleoffdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="vehicleoffCountDiv" id="vehicleoffHeader">Vehicle in other Hub</div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'vehicleOffRoaddetailsbuttonpannel',
				cls:'vehicleOffRoadDeatilsNav',
				//height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				xtype:'panel',
				//height:115,	
				bodyCssClass:'htmltotaldetailsnav',
				bodyStyle: 'background: #CACC6B',
				border:false
				}]}]
		}); // End of Panel			
		
//*******************************On TRIP

var VEHICLE_ON_TRIP = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,	
		hidden:true,	
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'vehicleOffRoadId1',
		layout:'column',
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'label',
				text:'',
				width:'46%',
				allowBlank: false,
				hidden:false,
				cls:'vehicleoffconlabel1',
				id:'vehicleOffRoadIconId1'
				},		
				{
				xtype:'panel',
				id:'vehicleOffRoaddetailspannel1',
				frame:false,
				border:false,
				width:'54%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="vehicleoffHearderLabelDiv1" id="vehicleoffdivid1">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: pink'
				},
				{
				xtype: 'label',
				html: '<div class="vehicleoffCountDiv1" id="vehicleoffHeader1"><%=vehicleOnTrip%></div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'vehicleOffRoaddetailsbuttonpannel1',
				cls:'vehicleOffRoadDeatilsNav',
				height:115,
				width:'0%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="vehicleOffRoadDeatilsNavimage" id="vehicleOffdetailsnav1"></div>',
				xtype:'panel',
				height:115,
				hidden:true,
				bodyStyle: 'background: #CACC6B',
				border:false
				}]}]
		}); // End of Panel			
			

//****************************************************Inner Panel*****************************************************************************
function onclic(cust,alertid,alert){
var custs=cust;
alert(custs);
alert(alertid);
alert(alert);
}
 var customerPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
        frame:false,
		width:'100%',
		padding: '1%',
		id:'custMaster',
		layout:'column',
		layoutConfig:{columns:2},
		items: [
				{
				xtype: 'label',
				text: 'Customer Name'+'  :',
				allowBlank: false,
				hidden:false,
				cls:'dashboardCashVanlabelstyle',
				id:'custnamhidlab'
				},custnamecombo				  							
			]
		});

		
 var alertPanel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		width:'20%',
		id:'alertcountid',
		items:[TOTAL_ASSET,COMMUNICATING,VEHICLE_ON_ROAD,REFUEL]		
		});
var alertPanel2 = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		width:'20%',
		id:'alertcount2id',
		items:[NO_GPS,NONCOMMUNICATING,VEHICLE_ON_TRIP,VEHICLE_OFF_ROAD]
		}); 
		
function getDashBoardDetails(cutomerID,alertId,alertName)
{
if(cutomerID !="")
{
window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/CVSDashboardDetails.jsp?cutomerID="+cutomerID+"&AlertId="+alertId+"&AlertName="+alertName;
}
}	

function getVehicleOffRoadDetails(id){
window.location ="<%=request.getContextPath()%>/Jsps/Common/VehicleOffRoadDetails.jsp?pageId="+id;
}


function gotoMapView(type)
{

if('<%=loginInfo.getStyleSheetOverride()%>'=='Y')
{
parent.firstLoad=0;
parent.getVerticalMenus('#menu2', 19);}
window.location ="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType="+type;
}		

function gotoListView(type){

  parent.firstLoad=0;
  parent.getVerticalMenus('#menu2', 19);
  window.location ="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?category="+type;
}
	
	var vehicleHubCountStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleCountInHub',
		id:'hubCountId',
		root: 'hubCountRoot',
		autoLoad: false,
		remoteSort: true,
		fields: ['insideHub','outsideHub']
	});		
//********************************************************Pie Chart Store***********************************************************************		
var communicatingNonCommunicatingStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getCommNonCommunicatingVehicles',
				id:'CommNoncommroot',
				root: 'CommNoncommroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['communicating','noncommunicating','noGPS','totalAssets']
		});	

var commisionedDecommisionedStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getCommisionedDecommisionedVehicles',
				id:'CommDeCommroot',
				root: 'CommDeCommroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['commisioned','decommisioned']
		});	
		
var preventiveExpiryStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getPreventiveExpiryVehicles',
				id:'Preventiveroot',
				root: 'Preventiveroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['expired','dueforexpiry']
		});	
		
var vehicleLiveStatusStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleLiveStatus',
				id:'VehicleStatusroot',
				root: 'VehicleStatusroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['running','idle','stopped']
		});			

//******************************************** Commisioned/Decommissioned PieChart**********************************************************		
function drawncommisionedPieChart() {
CheckSession();
 commisionedDecommisionedStore.load({
                        params: {custID:'<%=customerId%>'},
                        callback  : function() {
                         		 	var rec = commisionedDecommisionedStore.getAt(0);
  									var commisioned=0;
  									var decommisioned=0;
  									if(commisionedDecommisionedStore.getCount()>0)
  									{
  									commisioned=rec.data['commisioned'];    									
  									decommisioned=rec.data['decommisioned'];  
  									}            	
  									var commisioneddecommisioneddata = google.visualization.arrayToDataTable([
    								['Status', 'No of Vehicles'],
    								['<%=commissioned%>', commisioned],
    								['<%=deCommissioned%>',decommisioned]
  									]);
  									var commisionedDecommisionedgraph=new google.visualization.PieChart(document.getElementById('commisioneddiv'));
  									var options = {
          							title: '<%=CommissionedDeCommissionedLast1Month%>',
          							titleTextStyle:{color:'#686262',fontSize:13,align:'center',width:'80%',fontName:'sans-serif'},
          							pieSliceText: "value",
          							//width:259,
          							legend:{position: 'bottom'},
          							backgroundColor: '#E4E4E4',
          							colors:['#61D961','#C94224'], 
          							sliceVisibilityThreshold:0,
        							};
  									
      								commisionedDecommisionedgraph.draw(commisioneddecommisioneddata,options);
      								google.visualization.events.addListener(commisionedDecommisionedgraph, 'select',function(){      				
			      					 var catergory="";			 
			                   		 var selection = commisionedDecommisionedgraph.getSelection(); 
			                   		 var alertType = selection[0].row;
			                   	     if(alertType==1){
			                    	    category='decommissioned';
			                   	       }else if(alertType==0){
			                    	   category='commissioned';
			                   	     }  
			                      parent.firstLoad=0;
							      parent.getVerticalMenus('#menu1', 18);
							      window.location ="/jsps/master_jsps/VehicleRegistrationCancellationReport.jsp?category="+category;
			      				});
                        }
                    	}); 
}

//*******************************************************VEhicleLive Status Pie Chart**********************************************************
function vehicleLiveStatusPieChart() {
CheckSession();
 vehicleLiveStatusStore.load({
                        params: {custID:'<%=customerId%>'},
                        callback  : function() {
                         		 	var rec = vehicleLiveStatusStore.getAt(0);
  									var running=rec.data['running'];   
  									var idle=rec.data['idle'];  
  									var stopped=rec.data['stopped']; 
  									var vehiclestatusdata = google.visualization.arrayToDataTable([
    								['Status', 'No of Vehicles'],
    								['<%=running%>', running],
    								['<%=idle%>',idle],
    								['<%=stopped%>', stopped]
  									]);
  									var vehiclestatusgraph=new google.visualization.PieChart(document.getElementById('vehiclelivestatus'));
  									var options = {
  									title:'<%=vehicleStatusLive%>',
  									titleTextStyle:{color:'#686262',fontSize:13,align:'center',fontName:'sans-serif'},
  									backgroundColor: '#E4E4E4',
  									//width:259,
          							pieSliceText: "value",
          							forceIFrame: true,
          							legend:{position: 'bottom'},
          							colors:['#61D961','#E7BD1B','#E0502E'],
        							};
      								vehiclestatusgraph.draw(vehiclestatusdata,options);
      								google.visualization.events.addListener(vehiclestatusgraph, 'select',function(){      				
				      				var catergory="";				 
				                    var selection = vehiclestatusgraph.getSelection(); 
				                    var alertType = selection[0].row;
				                    if(alertType==1){
				                    	category='idle';
				                    }else if(alertType==0){
				                    	category='running';
				                    } else if(alertType==2){
				                    	category='stoppage';
				                    }                  
				                   parent.firstLoad=0;
								   parent.getVerticalMenus('#menu2', 19);
								   window.location ="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?category="+category;
      								});
                        }
                    	});                     	
}

function getDashBoardDetailsStatutoryAlert(cutomerID,alertId,alertName)
{
if(cutomerID !="")
{
window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/CVSDashBoardChartDetails.jsp?cutomerID="+cutomerID+"&AlertId="+alertId+"&AlertName="+alertName;

}

}

var CommisionedDecommisionedPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
hidden:true,
border:false,
width:'100%',
//height:222,
//cls: 'CommisionedDecommisionedPannel',
id:'commisionedpanel1id',
items: [{xtype:'label',
	     id:'commisionedpannelHeader',
		 text:'<%=commDeComm%>',
		 hidden:true,
		// width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'commisionedpiepannelid',
	     cls:'commisionedpiepannelidcls',
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="commisioneddiv" class="commisionedpiepannelstatusidcls" align="left"> </div></td></tr></table>'
       }
       ]
});

var VehiclLiveStatusPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
hidden:true,
width:'100%',
//height:222,
//cls: 'VehiclLiveStatusPannel',
id:'vehiclelivestatusid',
//bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.5%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'vehiclestatuspannelHeader',
		 text:'Vehicle Live Status With Cash in Hand',
		 hidden:true,
		// width:'100%',
		// height:350,
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'vehiclelivedivid',
	     cls:'vehiclelivedividcls',
	     //height:350,
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="vehiclelivestatus" class="vehiclelivestatusidcls" align="left"> </div></td></tr></table>'
       }
       ]
});
var PreventivegVehicleStatusMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
//width:'100%',
//height:210,
id:'preventivevehiclestatusmainpanelid',
//bodyCssClass: 'preventivevehiclestatusmainpanel',
layout:'column',
		layoutConfig: {
			columns:1
		},
items: [CommisionedDecommisionedPannel,{height:50,bodyStyle: 'color: white'},VehiclLiveStatusPannel]
});
var barchartPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
hidden:true,
border:false,
//width:'99%',
//height:290,
bodyCssClass: 'barchartpannel',
id:'barchartpanel1id',
//bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.3%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'statutaryHeader',
	     hidden:true,
		 text:'Stautory Alert of Vehicles',
		// width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'barchartpiepannelid',
	     cls:'barchartpiepannelidcls',
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="barchartddiv" class="barchartddivstatusclass" align="left" onload="test()"> </div></td></tr></table>'
       }
       ]
});

var graphpannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
width:'40%',
id:'graphpannel',
//cls:'innermainPannelCashVan',
items: [PreventivegVehicleStatusMainPannel]
});

		
var innerSecondMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
//height:485,
border:false,
bodyCssClass: 'innersecondmainpanneldashboard',
//width:'98%',
//bodyStyle:{'margin': '1%'},
id:'innersecondmainpannel',
		layout:'column',
		layoutConfig: {
			columns:5
		},
items: [alertPanel,{width:50,bodyStyle: 'color: white'},alertPanel2,{width:50,bodyStyle: 'color: white'},graphpannel]
});
		
var innerMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
width:'100%',
id:'innermainpannel',
//cls:'innermainPannelCashVan',
items: [innerSecondMainPannel]
});
											
//***************************  Main starts from here **************************************************
 Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	
	
 	outerPanel = new Ext.Panel({
			renderTo : 'content',
			standardSubmit: true,
			//height:500,
			border:false,
			bodyCssClass:'outerpaneldashboard',
			//cls:'outerpanel',
			//bodyCfg : { cls:'outerpanel' ,style: {'background':'#fff','padding-top':'1%'} },
			items: [innerMainPannel]	
			});
			
	totalAssetsAlert();
	getVehicleCountInHub();
	 <%
									 		Iterator itl = alert.entrySet().iterator();
      										while(itl.hasNext()) {
         									Map.Entry me = (Map.Entry)itl.next();
		                 	 		 %>
		                 	 		 		if('<%=me.getKey()%>'=='VEHICLE_ON_OFF_ROAD')
		                 	  				{
		                 	  					Ext.getCmp('vehicleOnRoadid').show();
		                 	  					Ext.getCmp('vehicleOffRoadId1').show();
		                 	  				}
		                 	  				else if('<%=me.getKey()%>'=='TOTAL_ASSET')
		                 	  				{   
		                 	  					Ext.getCmp('ctbid').show();
            	  								setInterval(function(){totalAssetsAlert();},60000);// 1min refresh
		                 	  				}
		                 	  			else if('<%=me.getKey()%>'=='COMMUNICATING')
		                 	  				{
		                 	  					Ext.getCmp('commpanelid').show();
		                 	  				}
		                 	  				else if('<%=me.getKey()%>'=='NONCOMMUNICATING')
		                 	  				{
		                 	  					Ext.getCmp('noncommpanelid').show();
		                 	  				}
		                 	  				else if('<%=me.getKey()%>'=='NO_GPS')
		                 	  				{
		                 	  					Ext.getCmp('nogpspanelid').show();
		                 	  				}
		                 	  				callAlertFunction('<%=me.getKey()%>');
		                 	  			    
		                 	  		      <%} %>
		  setInterval(function(){getVehicleCountInHub();},60000);// 1min refresh               	  		      
		                 	  		       
             
});
   
   </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->