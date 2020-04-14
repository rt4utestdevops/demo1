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
int customeridlogged=loginInfo.getCustomerId();
int offset = loginInfo.getOffsetMinutes();
int custidpassed=0;
if(request.getParameter("cutomerIDPassed")!= null)
{
custidpassed=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}
int list=0;
StringBuilder alertpannelitems1=new StringBuilder();
StringBuilder alertpannelitems2=new StringBuilder();
CashVanManagementFunctions cvmf=new CashVanManagementFunctions();

//getting alert id of all alert
Map <String,Integer> alert=cvmf.getAlert(systemid);
Iterator i = alert.entrySet().iterator();
while(i.hasNext()) {
Map.Entry me = (Map.Entry)i.next();
if((Integer)me.getValue()>=0 && list<5)
{
alertpannelitems1.append(me.getKey()+",");
list++;
}
else if((Integer)me.getValue()>=0 && list>=5)
{
alertpannelitems2.append(me.getKey()+",");
}
}
alertpannelitems1.setLength(alertpannelitems1.length() - 1);
alertpannelitems2.setLength(alertpannelitems2.length() - 1);
String alert_DEVIATED_STANDARD_ROUTE="0";
String alert_NOT_VISITED_VAULT_BEFORE_PARKING="0";
String alert_CROSSED_THE_BORDER="0";
String alert_NOT_RETURNED_TO_PARKING="0";
String alert_OVERSPEED="0";
String alert_STOPPED_MORE_THAN_THIRTY="0";
String alert_CONTINUOUSLY_MOVING="0";
String alert_IDLE="0";
String alert_REFUEL_LITERS="0";
String alert_DETENTION="0";
String alert_STATUTORY_BARCHART="0";
if(alert.get("NOT_VISITED_VAULT_BEFORE_PARKING")!=null)
{
alert_NOT_VISITED_VAULT_BEFORE_PARKING=Integer.toString(alert.get("NOT_VISITED_VAULT_BEFORE_PARKING"));
}
if(alert.get("CROSSED_THE_BORDER")!=null)
{
alert_CROSSED_THE_BORDER=Integer.toString(alert.get("CROSSED_THE_BORDER"));
}
if(alert.get("NOT_RETURNED_TO_PARKING")!=null)
{
alert_NOT_RETURNED_TO_PARKING=Integer.toString(alert.get("NOT_RETURNED_TO_PARKING"));
}
if(alert.get("OVERSPEED")!=null)
{
alert_OVERSPEED=Integer.toString(alert.get("OVERSPEED"));
}
if(alert.get("DEVIATED_STANDARD_ROUTE")!=null)
{
alert_DEVIATED_STANDARD_ROUTE=Integer.toString(alert.get("DEVIATED_STANDARD_ROUTE"));
}
if(alert.get("STOPPED_MORE_THAN_THIRTY")!=null)
{
alert_STOPPED_MORE_THAN_THIRTY=Integer.toString(alert.get("STOPPED_MORE_THAN_THIRTY"));
}
if(alert.get("CONTINUOUSLY_MOVING")!=null)
{
alert_CONTINUOUSLY_MOVING=Integer.toString(alert.get("CONTINUOUSLY_MOVING"));
}
if(alert.get("IDLE")!=null)
{
alert_IDLE=Integer.toString(alert.get("IDLE"));
}
if(alert.get("REFUEL_LITERS")!=null)
{
alert_REFUEL_LITERS=Integer.toString(alert.get("REFUEL_LITERS"));
}
if(alert.get("DETENTION")!=null)
{
alert_DETENTION=Integer.toString(alert.get("DETENTION"));
}
if(alert.get("STATUTORY-BARCHART")!=null)
{
alert_STATUTORY_BARCHART=Integer.toString(alert.get("STATUTORY-BARCHART"));
}
String cvsdashboard="CVS Status Dashboard";
String  NOT_VISITED_VAULT_BEFORE_PARKING="NOT VISITED VAULT BEFORE PARKING";
String  CROSSED_THE_BORDER="CROSSED THE BORDER";
String  NOT_RETURNED_TO_PARKING="NOT RETURNED TO PARKING";
String  PREVENTIVE_EXPIRED="PREVENTIVE EXPIRED";
String  PREVENTIVE_DUE_EXPIRY="PREVENTIVE DUE FOR EXPIRY";
String  OVERSPEED="OVERSPEED";
String  VEHICLE_ON_OFF_ROAD="VEHICLE ON/OFF ROAD";
String  STOPPED_MORE_THAN_THIRTY="STOPPAGE ALERT";
String  CONTINUOUSLY_MOVING="CONTINUOUSLY MOVING ALERT";
String  IDLE="IDLE ALERT";
String  VEHICLE_NOT_COMMUNICATING="VEHICLE NOT COMMUNICATING";
String  STATUTORY_ALERT="STATUTORY ALERT";
String  REFUEL_LITERS="REFUEL(LITRES)";
String DETENTION="DETENTION ALERT";
String PREVENTIVE_MAINTAINANCE_ASSET="Preventive Maintenance Assets";
String PREVENTIVE_MAINTAINANCE_ASSET_ZERO_VALUES="Preventive Maintainance of Assets Values-Due For Expiry=0&Expired=0";
%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title><%=cvsdashboard%></title>	
		<style type="text/css">

		</style>	
	</head>	    
  
  <body height="100%" onload="timeoutrefresh();">
   <jsp:include page="../Common/ImportJS.jsp" />
<!--    <script type="text/javascript" src="https://www.google.com/jsapi"></script>-->
 <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   <script>
    google.load("visualization", "1", {packages:["corechart"]});
    //google.setOnLoadCallback(drawnonCommunicatingpieChart);
 var outerPanel;
 var ctsb;
 var panel1;
 var overspeedcount="";
 var offset=<%=offset%>;
 var alertpannelorder="";
 var dtcur = datecur;
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
		                 	  if(Ext.getCmp('communicatingpanelid').hidden==true && Ext.getCmp('commisionedpanel1id').hidden==true)
		                 	  {
		                 	  Ext.getCmp('communicatingcommisionedmainpanelid').hide();
		                 	  }
		                 	  if(Ext.getCmp('preventivemaintainancepanelid').hidden==true && Ext.getCmp('vehiclelivestatusid').hidden==true)
		                 	  {
		                 	  Ext.getCmp('preventivevehiclestatusmainpanelid').hide();
		                 	  }
    				}
    				else if(<%=customeridlogged%>>0)
    				{
    				Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
    								 <%
									 		Iterator itl = alert.entrySet().iterator();
      										while(itl.hasNext()) {
         									Map.Entry me = (Map.Entry)itl.next();
		                 	 		 %>
		                 	  				callAlertFunction('<%=me.getKey()%>');
		                 	  		 <%
		                 	  				}
		                 	  		 %>
		                 	  if(Ext.getCmp('communicatingpanelid').hidden==true && Ext.getCmp('commisionedpanel1id').hidden==true)
		                 	  {
		                 	  Ext.getCmp('communicatingcommisionedmainpanelid').hide();
		                 	  }
		                 	  if(Ext.getCmp('preventivemaintainancepanelid').hidden==true && Ext.getCmp('vehiclelivestatusid').hidden==true)
		                 	  {
		                 	  Ext.getCmp('preventivevehiclestatusmainpanelid').hide();
		                 	  }
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
	        height:23,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'dashboardCashVancombostyle',
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
		                 	  				callAlertFunction('<%=me.getKey()%>');
		                 	  		 <%
		                 	  				}
		                 	  		 %>
		                 	  if(Ext.getCmp('communicatingpanelid').hidden==true && Ext.getCmp('commisionedpanel1id').hidden==true)
		                 	  {
		                 	  Ext.getCmp('communicatingcommisionedmainpanelid').hide();
		                 	  }
		                 	  if(Ext.getCmp('preventivemaintainancepanelid').hidden==true && Ext.getCmp('vehiclelivestatusid').hidden==true)
		                 	  {
		                 	  Ext.getCmp('preventivevehiclestatusmainpanelid').hide();
		                 	  }
		                 	   }}
                 	   }   
    });
    
function callAlertFunction(alertname)
{
if (alertname=='OVERSPEED')
{overspeed();
setInterval(function(){
<%if(loginInfo!=null){%>
overspeed();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='CONTINUOUSLY_MOVING')
{ContinuouslyMovingAlert();
setInterval(function(){
<%if(loginInfo!=null){%>
ContinuouslyMovingAlert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='DETENTION')
{detentionalert();
setInterval(function(){
<%if(loginInfo!=null){%>
detentionalert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='STOPPED_MORE_THAN_THIRTY')
{vehiclestoppageAlert();
setInterval(function(){
<%if(loginInfo!=null){%>
vehiclestoppageAlert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='NOT_VISITED_VAULT_BEFORE_PARKING')
{notvisitedvaultalert();
setInterval(function(){
<%if(loginInfo!=null){%>
notvisitedvaultalert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='NOT_RETURNED_TO_PARKING')
{notreturnedtoparkingalert();
setInterval(function(){
<%if(loginInfo!=null){%>
notreturnedtoparkingalert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='REFUEL_LITERS')
{fuelconsumptionalert();
setInterval(function(){
<%if(loginInfo!=null){%>
fuelconsumptionalert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='CROSSED_THE_BORDER')
{crossedBorderAlert();
setInterval(function(){
<%if(loginInfo!=null){%>
crossedBorderAlert();
<%}%>
},60000);// 1min refresh
}	
else if (alertname=='VEHICLE_ON_OFF_ROAD')
{vehicleOnOffAlert();
setInterval(function(){
<%if(loginInfo!=null){%>
vehicleOnOffAlert();
<%}%>
},60000);// 1min refresh
}	
else if (alertname=='IDLE')
{idletimeAlert();
setInterval(function(){
<%if(loginInfo!=null){%>
idletimeAlert();
<%}%>
},60000);// 1min refresh
}
else if (alertname=='COMMUNICATING/NONCOMMUNICATING-PIECHART')
{
Ext.getCmp('communicatingpanelid').show();
drawnonCommunicatingpieChart();
setInterval(function(){
<%if(loginInfo!=null){%>
var commpanel=Ext.getCmp('pannelid');
Ext.getCmp('pannelid').update('<table width="100%"><tr><tr> <td> <div id="visualization" align="left"> </div></td></tr></table>');
drawnonCommunicatingpieChart();
<%}%>
},300000);// 5min refresh
}
else if (alertname=='COMMISSIONED/DECOMMISIONED-PIECHART')
{
Ext.getCmp('commisionedpanel1id').show();
drawncommisionedPieChart();
setInterval(function(){
<%if(loginInfo!=null){%>
Ext.getCmp('commisionedpiepannelid').update('<table width="100%"><tr><tr> <td> <div id="commisioneddiv" align="left"> </div></td></tr></table>');
drawncommisionedPieChart();
<%}%>
},300000);// 5min refresh
}				                 	 
else if (alertname=='PREVENTIVEMAINTAINACE-PIECHART')
{
Ext.getCmp('preventivemaintainancepanelid').show();
preventivemaintainancePieChart();
setInterval(function(){
<%if(loginInfo!=null){%>
Ext.getCmp('preventivemaintainanceid').update('<table width="100%"><tr><tr> <td> <div id="preventivemaintainance" align="left"> </div></td></tr></table>');
preventivemaintainancePieChart();
<%}%>
},300000);// 5min refresh
}	
else if (alertname=='VEHICLELIVESTATUS-PIECHART')
{
Ext.getCmp('vehiclelivestatusid').show();
vehicleLiveStatusPieChart();
setInterval(function(){
<%if(loginInfo!=null){%>
Ext.getCmp('vehiclelivedivid').update('<table width="100%"><tr><tr> <td> <div id="vehiclelivestatus" align="left"> </div></td></tr></table>');
vehicleLiveStatusPieChart();
<%}%>
},300000);// 5min refresh
}
else if (alertname=='STATUTORY-BARCHART')
{
Ext.getCmp('barchartpanel1id').show();
statutoryBarChart();
setInterval(function(){
<%if(loginInfo!=null){%>
Ext.getCmp('barchartpiepannelid').update('<table width="100%"><tr><tr> <td> <div id="barchartddiv" align="left"> </div></td></tr></table>');
statutoryBarChart();
<%}%>
},300000);// 5min refresh
}
}	   
function fuelconsumptionalert(){
  Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getFuelConsume',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Offset:offset,
                        	Alert_Id:<%=alert_REFUEL_LITERS%>
                        	
                        },
                        success: function (response, options)
                        {
                        count=response.responseText;
                        document.getElementById('fuelcondivid').innerHTML=count;
                        },
                        failure: function ()
                        {
                        } 
                    });   
 }
 
 /*****************function call for displaying overspeed alert count*******************************/
function overspeed()
{

		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getOverSpeedCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Alert_Id:<%=alert_OVERSPEED%>
                        },
                        success: function (response, options)
                        {
                        overspeedcount=response.responseText;
                        document.getElementById('overspeeddivid').innerHTML=overspeedcount
                        },
                        failure: function ()
                        {
                        } 
                    });   
                                   
}
/*****************function call for displaying vehicle stoppage alert count*******************************/
function vehiclestoppageAlert(){

var vehiclestoppagealert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleStoppageAlertCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Alert_Id:<%=alert_STOPPED_MORE_THAN_THIRTY%>
                        },
                        success: function (response, options)
                        {
                        vehiclestoppagealert=response.responseText;
                        document.getElementById('stoppagemoredivid').innerHTML=vehiclestoppagealert;
                        //Ext.getCmp('alertdetailsstoppagemoreid').setText(vehiclestoppagealert);
                        //createOverspeedPannel(response.responseText);
                        //setTimeout(function(){
          				//overspeedAlert();
        				//},5000); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
       
}
     /*****************function call for displaying idletime alert count*******************************/
     function idletimeAlert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getIdleTimeAlertCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Alert_Id:<%=alert_IDLE%>
                        },
                        success: function (response, options)
                        {
                        alert=response.responseText;
                        document.getElementById('idledivid').innerHTML=alert;
                        //Ext.getCmp('alertdetailsimttmid').setText(alert);
                        //createOverspeedPannel(response.responseText);
                        //setTimeout(function(){
          				//overspeedAlert();
        				//},5000); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
     }
     
     /*****************function call for displaying continuously moving alert count*******************************/
     function ContinuouslyMovingAlert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getContinuousMovingCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Alert_Id:<%=alert_CONTINUOUSLY_MOVING%>
                        },
                        success: function (response, options)
                        {
                        alert=response.responseText;
                        document.getElementById('continuouslymovethricedivid').innerHTML=alert;
                        //Ext.getCmp('alertdetailscmmtthid').setText(alert);
                        //createOverspeedPannel(response.responseText);
                        //setTimeout(function(){
          				//overspeedAlert();
        				//},5000); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
     }
     /*****************function call for displaying deviated From Standard Root alert count*******************************/
     function vehicleOnOffAlert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleOnOffAlert',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Alert_Id:'vehicleonoff'
                        },
                        success: function (response, options)
                        {
					    alert = response.responseText.split(",");
                        document.getElementById('deviatedrootdivid').innerHTML=alert[0];
                        document.getElementById('deviatedrootdivid2').innerHTML=alert[1];
                        //Ext.getCmp('alertdetailsdfsrid').setText(alert);
                        //createOverspeedPannel(response.responseText);
                        //setTimeout(function(){
          				//overspeedAlert();
        				//},5000); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
     }
     
     /*****************function call for displaying crossed border alert count*******************************/
     function crossedBorderAlert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getCrossedBorderCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Offset:offset,
                        	Alert_Id:<%=alert_CROSSED_THE_BORDER%>
                        },
                        success: function (response, options)
                        {
                        alert=response.responseText;
                        document.getElementById('crossborderdivid').innerHTML=alert;
                        //Ext.getCmp('alertdetailsctbid').setText(alert);
                        //createOverspeedPannel(response.responseText);
                        //setTimeout(function(){
          				//overspeedAlert();
        				//},5000); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
     }
     
      /*****************function call for displaying not visited vault alert count*******************************/
     function notvisitedvaultalert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getNotVisitedVaultAlertCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Offset:offset,
                        	Alert_Id:<%=alert_NOT_VISITED_VAULT_BEFORE_PARKING%>
                        	
                        },
                        success: function (response, options)
                        {
                        alert=response.responseText;
                        document.getElementById('notvisitedvaultdivid').innerHTML=alert;
                        //Ext.getCmp('alertdetailsctbid').setText(alert);
                        //createOverspeedPannel(response.responseText);
                        //setTimeout(function(){
          				//overspeedAlert();
        				//},5000); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
     
     }
     
     /*****************function call for displaying not visited vault alert count*******************************/
     function notreturnedtoparkingalert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getNotreturnedToParkingAlertCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Offset:offset,
                        	Alert_Id:<%=alert_NOT_RETURNED_TO_PARKING%>
                        	
                        },
                        success: function (response, options)
                        {
                        alert=response.responseText;
                        document.getElementById('notreturnparkdivid').innerHTML=alert;
                        },
                        failure: function ()
                        {
                        } 
                    });
     
     }

 /*****************function call for displaying not visited vault alert count*******************************/
     function detentionalert(){
      var alert;
				Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getDetentionAlertCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	Offset:offset,
                        	Alert_Id:<%=alert_DETENTION%>
                        	
                        },
                        success: function (response, options)
                        {
                        alert=response.responseText;
                        document.getElementById('detensiondivid').innerHTML=alert;
                        },
                        failure: function ()
                        {
                        } 
                    });
     
     }
/*****************************panel for NOT_VISITED_VAULT_BEFORE_PARKING alert******************************************************/
var NOT_VISITED_VAULT_BEFORE_PARKING = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'nvavbpid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Not Visited Vault',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheadernvavbpid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="notvisitedvaultdivid"></div>',
				width:'50%',
				cls:'dashboardCashVanLabelStyle',
				bodyStyle: 'background-color: green',
				id:'alertdetailsnvavbpid'},
				{
				xtype: 'label',
				text:'Vehicles Not Visited Vault since 9.5 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
        		var custID=Ext.getCmp('custmastcomboId').getValue();
                getDashBoardDetails(custID,<%=alert_NOT_VISITED_VAULT_BEFORE_PARKING%>,'<%=NOT_VISITED_VAULT_BEFORE_PARKING%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	

/*****************************panel for CROSSED_THE_BORDER alert******************************************************/
var CROSSED_THE_BORDER = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'ctbid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Crossed the Border',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheaderctbid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="crossborderdivid"></div>',
				width:'50%',
				cls:'dashboardCashVanLabelStyle',
				bodyStyle: 'background-color: green',
				id:'alertdetailsctbid',
				},
				{
				xtype: 'label',
				text:'Vehicles Crossed the Border in last 24 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_CROSSED_THE_BORDER%>,'<%=CROSSED_THE_BORDER%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	


/*****************************panel for NOT_RETURNED_TO_PARKING alert******************************************************/

var NOT_RETURNED_TO_PARKING = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'nrtpfnpfh',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Not Returned to Parking',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheadernrtpfnpfh'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="notreturnparkdivid"></div>',
				width:'50%',
				cls:'dashboardCashVanLabelStyle',
				bodyStyle: 'background-color: green',
				id:'alertdetailsnrtpfnpfh'},
				{
				xtype: 'label',
				text:'Vehicle not returned to the parking since 9.5 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_NOT_RETURNED_TO_PARKING%>,'<%=NOT_RETURNED_TO_PARKING%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel		

/*****************************panel for OVERSPEED alert******************************************************/
	
	var OVERSPEED = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'osid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Overspeed',
				cls:'dashboardheaderCashVan',
				id:'alertheaderosid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="overspeeddivid"></div>',
				width:'50%',
				cls:'dashboardCashVanLabelStyle',
				bodyStyle: 'background-color: green',
				id:'alertdetailslbloverspeed'},
				{
				xtype: 'label',
				text:'Over speeding vehicles in last 24 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_OVERSPEED%>,'<%=OVERSPEED%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	
/*****************************panel for DEVIATED FROM THE STANDARD ROUTE alert******************************************************/
	
		var VEHICLE_ON_OFF_ROAD = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		//height:130,
		bodyStyle: 'background: white',
		id:'dfsrid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Vehicle On/Off Road',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheaderdfsrid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 140,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				text:'Vehicles On Road',
				width:'50%',
				height:40,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				},
				{
				xtype: 'label',
				text:'Vehicle Off Road due to Maintenance',
				width:'50%',
				height:55,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid2'
				},
				{
				xtype: 'label',
				html: '<div id="deviatedrootdivid"></div>',
				cls:'dashboardCashVanLabelStyle2',
				width:'50%',
				height:55,
				bodyStyle: 'background-color: green',
				id:'alertdetailsdfsrid'},
				{
				xtype: 'label',
				html: '<div id="deviatedrootdivid2"></div>',
				cls:'dashboardCashVanLabelStyle2',
				width:'50%',
				height:55,
				bodyStyle: 'background-color: green',
				id:'alertdetailsdfsrid2'}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:true,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_DEVIATED_STANDARD_ROUTE%>,'<%=VEHICLE_ON_OFF_ROAD%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	
	/*****************************panel for STOPPED FOR MORE THAN 30MIN alert******************************************************/
	
		var STOPPED_MORE_THAN_THIRTY = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'smttmid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Stoppage Alert',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheadersmttmid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="stoppagemoredivid"></div>',
				cls:'dashboardCashVanLabelStyle',
				width:'50%',
				bodyStyle: 'background-color: green',
				id:'alertdetailsstoppagemoreid'},
				{
				xtype: 'label',
				text:'Vehicle Stopped more than configured value in last 24 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_STOPPED_MORE_THAN_THIRTY%>,'<%=STOPPED_MORE_THAN_THIRTY%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	
		
/*****************************panel for CONTINUOUSLY MOVING FOR MORE THE 3HOURS alert******************************************************/
		
		var CONTINUOUSLY_MOVING = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'cmmtthid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Continuously Moving Alert',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheadercmmtthid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="continuouslymovethricedivid"></div>',
				width:'50%',
				cls:'dashboardCashVanLabelStyle',
				bodyStyle: 'background-color: green',
				id:'alertdetailscmmtthid'},
				{
				xtype: 'label',
				text:'Vehicles Continuously Running for 3 Hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_CONTINUOUSLY_MOVING%>,'<%=CONTINUOUSLY_MOVING%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	
		
/*****************************panel for IDLE MORE THAN 10MIN alert******************************************************/
		
		var IDLE = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'imttmid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Idle Alert',
				allowBlank: false,
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheaderimttmid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				labelAlign:'center',
				html: '<div id="idledivid"></div>',
				styleHtmlContent: true,
				width:'50%',
				cls:'dashboardCashVanLabelStyle',
				bodyStyle: 'background-color: green',
				id:'alertdetailsimttmid'},
				{
				xtype: 'label',
				text:'Vehicles Idle in last 24 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_IDLE%>,'<%=IDLE%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	
		/*****************************panel for Fuel Consumption alert******************************************************/
		
var REFUEL_LITERS = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'fcaid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Refuel(Liters)',
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheaderrlid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="fuelcondivid"></div>',
				cls:'dashboardCashVanLabelStyle',
				width:'50%',
				bodyStyle: 'background-color: green',
				id:'alertdetailsfcaid'
				},
				{
				xtype: 'label',
				text:'Vehicles refuel in last 24 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}
				]}]
		}); // End of Panel	
		

/*****************************panel for Fuel Consumption alert******************************************************/
		
var DETENTION = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'innerpaneldashboardCashVanPannel',
		bodyStyle: 'background: white',
		id:'daid',
		layout:'column',
		layoutConfig: {
			columns:1
		},
		items:[			
				{
				xtype: 'label',
				text:'Detention Alert',
				hidden:false,
				cls:'dashboardheaderCashVan',
				id:'alertheaderdaid'
				},
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				height: 125,
				cls:'dashboardCashVanLabelStyle',
				layout:'column',
				layoutConfig: {
					columns:2
				},
				items:[
				{
				xtype: 'label',
				html: '<div id="detensiondivid"></div>',
				cls:'dashboardCashVanLabelStyle',
				width:'50%',
				bodyStyle: 'background-color: green',
				id:'alertdetailsdaid'},
				{
				xtype: 'label',
				text:'Vehicles in Parking for 24 hours',
				width:'50%',
				height:125,
				cls:'dashboardCashVanLabelDetailsStyle',
				id:'alertlbldetailssaid'
				}]},
				{
				xtype: 'label',
				text:'Details',
				allowBlank: false,
				hidden:false,
				cls:'dashboardfooterCashVan',
				id:'alertfootersaid',
				autoEl:{
    					tag: 'a',
    					href: '#',
    					cn: 'Link To Prospect'
						},
				listeners: {
    			render: function(component) {
        		component.getEl().on('click', function(e) {
            	var custID=Ext.getCmp('custmastcomboId').getValue();
				getDashBoardDetails(custID,<%=alert_DETENTION%>,'<%=DETENTION%>');
        		});    
   	 			}
				}
				}]
		}); // End of Panel	
/************************************************************************************/



//****************************************************Inner Panel*****************************************************************************

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
		items:[<%=alertpannelitems1%>]		
		});
var alertPanel2 = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		width:'20%',
		id:'alertcount2id',
		items:[<%=alertpannelitems2%>]
		}); 
		
function getDashBoardDetails(cutomerID,alertId,alertName)
{
if(cutomerID !="")
{
window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/CVSDashboardDetails.jsp?cutomerID="+cutomerID+"&AlertId="+alertId+"&AlertName="+alertName;
}
}				
//********************************************************Pie Chart Store***********************************************************************		
var communicatingNonCommunicatingStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getCommNonCommunicatingVehicles',
				id:'CommNoncommroot',
				root: 'CommNoncommroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['communicating','noncommunicating','noGPS']
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

var statutoryStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getstatutorydetails',
				id:'Statutoryroot',
				root: 'Statutoryroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['insuranceDOE','insuranceExp','goodstokentaxDOE','goodstokentaxExp','FCIDOE','FCIExp','EmissionDOE','EmissionExp','PermitDOE','PermitExp','DriverLicenseDOE','DriverLicenseExp']
		});				

//*************************************** Communicating/Non Communicating Pie Chart*************************************************************			
function drawnonCommunicatingpieChart(){
communicatingNonCommunicatingStore.load({
                        params: {custID:Ext.getCmp('custmastcomboId').getValue()},
                        callback  : function() {
                         		 	var rec = communicatingNonCommunicatingStore.getAt(0);
  									var communicatingcount=rec.data['communicating'];   
  									var noncommunicatingcount=rec.data['noncommunicating']; 
  									var noGPS=rec.data['noGPS'];               	
  									var communicatingNoncommunicatingdata = google.visualization.arrayToDataTable([
    								['Status', 'No of Vehicles'],
    								['Comm', communicatingcount],
    								['Non-Comm',noncommunicatingcount],
    								['No GPS',noGPS]
  									]);
  									var communicatingNoncommunicatinggraph=new google.visualization.PieChart(document.getElementById('visualization'));
  									var options = {
          							title: 'Communicating / Non Communicating',
          							titleTextStyle:{color:'#686262',fontSize:13},
          							pieSliceText: "value",
          							legend:{position: 'bottom'},
          							sliceVisibilityThreshold:0,
          							colors:['#4572A7','#93A9CF','#BDBDBD'],
          							//'tooltip' : {
  									//			trigger: 'none'
									//}
        							};
  									
      								communicatingNoncommunicatinggraph.draw(communicatingNoncommunicatingdata,options);
      							 	//google.visualization.events.addListener(communicatingNoncommunicatinggraph, 'select', selectHandler);
                        }
                    	});

}
//******************************************** Commisioned/Decommissioned PieChart**********************************************************		
function drawncommisionedPieChart() {
 commisionedDecommisionedStore.load({
                        params: {custID:Ext.getCmp('custmastcomboId').getValue()},
                        callback  : function() {
                         		 	var rec = commisionedDecommisionedStore.getAt(0);
  									var commisioned=rec.data['commisioned'];   
  									var decommisioned=rec.data['decommisioned'];              	
  									var commisioneddecommisioneddata = google.visualization.arrayToDataTable([
    								['Status', 'No of Vehicles'],
    								['Commisioned', commisioned],
    								['DeCommisioned',decommisioned]
  									]);
  									var commisionedDecommisionedgraph=new google.visualization.PieChart(document.getElementById('commisioneddiv'));
  									var options = {
          							title: 'Commisioned  /  Decommisioned (from last 1 month)',
          							titleTextStyle:{color:'#686262',fontSize:13,align:'center',width:'80%'},
          							pieSliceText: "value",
          							legend:{position: 'bottom'},
          							colors:['#4572A7','#93A9CF'],
          							sliceVisibilityThreshold:0,
        							};
  									
      								commisionedDecommisionedgraph.draw(commisioneddecommisioneddata,options);
      							 //google.visualization.events.addListener(commisionedDecommisionedgraph, 'select', selectHandler);
                        }
                    	}); 
}
//*******************************************************Preventive Maintainance Pie Chart**********************************************************
function preventivemaintainancePieChart() {
 preventiveExpiryStore.load({
                        params: {custID:Ext.getCmp('custmastcomboId').getValue()},
                        callback  : function() {
                        			var preventiveTitle='<%=PREVENTIVE_MAINTAINANCE_ASSET%>';
                         		 	var rec = preventiveExpiryStore.getAt(0);
  									var expired=rec.data['expired'];   
  									var dueforexpiry=rec.data['dueforexpiry'];
  									if(expired==0 && dueforexpiry==0)
  									{
  									preventiveTitle='<%=PREVENTIVE_MAINTAINANCE_ASSET_ZERO_VALUES%>';
  									}             	
  									var commisioneddecommisioneddata = google.visualization.arrayToDataTable([
    								['Status', 'No of Vehicles'],
    								['Due for Expiry',dueforexpiry],
    								['Expired',expired]
  									]);
  									var preventiveMaintanacegraph=new google.visualization.PieChart(document.getElementById('preventivemaintainance'));
  									var options = {
          							title: preventiveTitle,
          							titleTextStyle:{color:'#686262',fontSize:13,width:20},
          							pieSliceText: "value",
          							legend:{position: 'bottom'},
          							colors:['#4572A7','#93A9CF'],
          							sliceVisibilityThreshold:0
        							};
      				preventiveMaintanacegraph.draw(commisioneddecommisioneddata,options);     					
      				google.visualization.events.addListener(preventiveMaintanacegraph, 'select',function(){
      				var custID=Ext.getCmp('custmastcomboId').getValue();  
      				var alertid="";
      				if(expired==0)
      				{
      				alertid=2;
      				} 
      				else if(dueforexpiry==0)
      				{
      				alertid=1;
      				}
      				else
      				{  				 
                    var selection = preventiveMaintanacegraph.getSelection(); 
                    var alertType = selection[0].row;
                    if(alertType==1){
                    	alertid=1;
                    }
                    if(alertType==0){
                    	alertid=2;
                    }
                    }
                    var win = window.open("", "printing", "location=0", "status=0", "toolbar=0", "menubar=0", "resizable=0", "scrollbars=0", "height=375", "width=420");
                    win.location = "<%=request.getContextPath()%>/Jsps/PreventiveMaintenance/ServiceDetails.jsp?cutomerID="+custID+"&AlertType="+alertid;
                    win.focus();
      				});
                        }
                    }); 
                  }
//*******************************************************VEhicleLive Status Pie Chart**********************************************************
function vehicleLiveStatusPieChart() {
 vehicleLiveStatusStore.load({
                        params: {custID:Ext.getCmp('custmastcomboId').getValue()},
                        callback  : function() {
                         		 	var rec = vehicleLiveStatusStore.getAt(0);
  									var running=rec.data['running'];   
  									var idle=rec.data['idle'];  
  									var stopped=rec.data['stopped']; 
  									var total=running+idle+stopped;           	
  									var vehiclestatusdata = google.visualization.arrayToDataTable([
    								['Status', 'No of Vehicles'],
    								['Running', running],
    								['Idle',idle],
    								['Stopped', stopped]
  									]);
  									var vehiclestatusgraph=new google.visualization.PieChart(document.getElementById('vehiclelivestatus'));
  									var options = {
  									title:'Vehicle Live Status - Total Fleets:'+total,
  									titleTextStyle:{color:'#686262',fontSize:13,align:'center'},
          							pieSliceText: "value",
          							forceIFrame: true,
          							legend:{position: 'bottom'},
          							colors:['#61D961','#5757FE','#BDBDBD'],
        							};
      								vehiclestatusgraph.draw(vehiclestatusdata,options);
      							 //google.visualization.events.addListener(vehiclestatusgraph, 'select', selectHandler);
                        }
                    	});                     	
}
//******************************************** Stutary BarChart**********************************************************		
function statutoryBarChart() {
 statutoryStore.load({
                        params: {custID:Ext.getCmp('custmastcomboId').getValue()},
                        callback  : function() {
                         		 	var rec = statutoryStore.getAt(0);
  									var insuranceDOE=rec.data['insuranceDOE'];   
  									var insuranceExp=rec.data['insuranceExp'];
									var goodstokentaxDOE=rec.data['goodstokentaxDOE'];   
  									var goodstokentaxExp=rec.data['goodstokentaxExp'];
									var FCIDOE=rec.data['FCIDOE'];   
  									var FCIExp=rec.data['FCIExp'];
									var EmissionDOE=rec.data['EmissionDOE'];   
  									var EmissionExp=rec.data['EmissionExp'];
  									var PermitDOE=rec.data['PermitDOE'];
									var PermitExp=rec.data['PermitExp'];   
  									var DriverLicenseDOE=rec.data['DriverLicenseDOE'];
									var DriverLicenseExp=rec.data['DriverLicenseExp'];                   	
  									var barchartdata = google.visualization.arrayToDataTable([
    								['Types', 'Due of Expiry', 'Expired'],
    								['Insurance',  insuranceDOE,   insuranceExp],
    								['Goods Token Tax',  goodstokentaxDOE,   goodstokentaxExp],
    								['FCI',  FCIDOE,   FCIExp],
    								['Emission',  EmissionDOE,   EmissionExp],
    								['Permit',  PermitDOE,   PermitExp],
    								['Driver License',  DriverLicenseDOE,   DriverLicenseExp]
  									]);
  									var options = {
          							title: 'Statutory Details',
          							titleTextStyle:{color:'#686262',fontSize:13},
          							pieSliceText: "value",
          							legend:{position: 'bottom'},
          							colors:['#93A9CF','#4572A7'],
          							sliceVisibilityThreshold:0,
          							height:380,
          							hAxis: {title: 'Types',titleTextStyle: { italic: false} },
          							vAxis:{title:'Vehicle Count',titleTextStyle: { italic: false} }
        							};
  									
  
 var statutorybargraph= new google.visualization.ColumnChart(document.getElementById('barchartddiv'));
      statutorybargraph.draw(barchartdata,options);
      google.visualization.events.addListener(statutorybargraph, 'select', function() {
    var selection = statutorybargraph.getSelection();
    var id=parseInt(selection[0].row+''+selection[0].column);
    var cutomerID=Ext.getCmp('custmastcomboId').getValue();
      switch(id)
      {
	  case 1:getDashBoardDetailsStatutoryAlert(cutomerID,10,'Statutory Details Insurance Due for Expiry');break;
      case 2:getDashBoardDetailsStatutoryAlert(cutomerID,32,'Statutory Details Insurance Expired');break;
      case 11:getDashBoardDetailsStatutoryAlert(cutomerID,11,'Statutory Details Goods Token Tax Due for Expiry');break;
      case 12:getDashBoardDetailsStatutoryAlert(cutomerID,33,'Statutory Details Goods Token Tax Expired');break;
      case 21:getDashBoardDetailsStatutoryAlert(cutomerID,12,'Statutory Details FCI Due for Expiry');break;
      case 22:getDashBoardDetailsStatutoryAlert(cutomerID,34,'Statutory Details FCI Expired');break;
      case 31:getDashBoardDetailsStatutoryAlert(cutomerID,13,'Statutory Details Emission Due for Expiry');break;
      case 32:getDashBoardDetailsStatutoryAlert(cutomerID,35,'Statutory Details Emission Expired');break;
	  case 41:getDashBoardDetailsStatutoryAlert(cutomerID,15,'Statutory Details Permit Due for Expiry');break;
      case 42:getDashBoardDetailsStatutoryAlert(cutomerID,36,'Statutory Details Permit Expired');break;
	  case 51:getDashBoardDetailsStatutoryAlert(cutomerID,66,'Statutory Details Driver License Due for Expiry');break;
      case 52:getDashBoardDetailsStatutoryAlert(cutomerID,67,'Statutory Details Driver License Expired');break;
      }
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

<!--function selectHandler() {-->
<!--var custID=Ext.getCmp('custmastcomboId').getValue();-->
<!-- getDashBoardDetails(custID,'-5','Preventive Maintainance Assets');-->
<!--}	-->

var CommunicatingGrapPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
hidden:true,
border:false,
width:'50%',
height:222,
id:'communicatingpanelid',
bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.5%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'communicatingpannelHeader',
		 text:'Communicating  /  Non Communicating',
		 hidden:true,
		 width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'label',
	     id:'pannelid',
	     border:false,
	     width:'100%',
       	 html : '<table width="100%"><tr><tr> <td> <div id="visualization" align="left"> </div></td></tr></table>'
       }
       ]
});

var CommisionedDecommisionedPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
hidden:true,
border:false,
width:'49%',
height:222,
id:'commisionedpanel1id',
bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.5%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'commisionedpannelHeader',
		 text:'Commmisioned  /  DeCommisioned',
		 hidden:true,
		 width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'commisionedpiepannelid',
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="commisioneddiv" align="left"> </div></td></tr></table>'
       }
       ]
});
var CommunicatingCommisionedMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
width:'100%',
height:225,
id:'communicatingcommisionedmainpanelid',
layout:'column',
		layoutConfig: {
			columns:2
		},
items: [CommunicatingGrapPannel,CommisionedDecommisionedPannel]
});
var PreventiveMaintainancePannel=new Ext.Panel({
standardSubmit: true,
frame:false,
hidden:true,
border:false,
width:'50%',
height:222,
id:'preventivemaintainancepanelid',
bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.5%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'preventivepannelHeader',
	     hidden:true,
		 text:'  Preventive Maintainance of Assets',
		 width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'preventivemaintainanceid',
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="preventivemaintainance" align="left"> </div></td></tr></table>'
       }
       ]
});
var VehiclLiveStatusPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
hidden:true,
width:'49%',
height:222,
id:'vehiclelivestatusid',
bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.5%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'vehiclestatuspannelHeader',
		 text:'Vehicle Live Status With Cash in Hand',
		 hidden:true,
		 width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'vehiclelivedivid',
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="vehiclelivestatus" align="left"> </div></td></tr></table>'
       }
       ]
});
var PreventivegVehicleStatusMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
width:'100%',
height:225,
id:'preventivevehiclestatusmainpanelid',
layout:'column',
		layoutConfig: {
			columns:2
		},
items: [PreventiveMaintainancePannel,VehiclLiveStatusPannel]
});
var barchartPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
hidden:true,
border:false,
width:'99%',
height:500,
id:'barchartpanel1id',
bodyStyle : 'border:1px solid #ADBDDE;border-top:10px solid #ADBDDE;margin-left:.3%;margin-bottom:.5%',
items: [{xtype:'label',
	     id:'statutaryHeader',
	     hidden:true,
		 text:'Stautory Alert of Vehicles',
		 width:'100%',
		 cls:'dashboardpiechartheader'
       },{xtype:'panel',
	     id:'barchartpiepannelid',
	     border:false,
       	 html : '<table width="100%"><tr><tr> <td> <div id="barchartddiv" align="left"> </div></td></tr></table>'
       }
       ]
});

var graphpannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
width:'60%',
id:'graphpannel',
//cls:'innermainPannelCashVan',
items: [CommunicatingCommisionedMainPannel,PreventivegVehicleStatusMainPannel,barchartPannel]
});
		
var innerSecondMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
//hidden:true,
border:false,
width:'99%',
id:'innersecondmainpannel',
		layout:'column',
		layoutConfig: {
			columns:3
		},
items: [alertPanel,graphpannel,alertPanel2]
});
		
var innerMainPannel=new Ext.Panel({
standardSubmit: true,
frame:false,
border:false,
width:'100%',
id:'innermainpannel',
//cls:'innermainPannelCashVan',
items: [customerPannel,innerSecondMainPannel]
});
											
//***************************  Main starts from here **************************************************
 Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	
	
 	outerPanel = new Ext.Panel({
			renderTo : 'content',
			standardSubmit: true,
			width:'100%',
			//cls:'outerpanel',
			bodyCfg : { cls:'outerpanel' ,style: {'background':'#1B4679','padding-top':'1%'} },
			items: [innerMainPannel]
					
			});
		
			
			 
			                
	});

   
   </script>
  </body>
</html>