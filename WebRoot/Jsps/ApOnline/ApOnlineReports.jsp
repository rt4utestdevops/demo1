<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
%>

<jsp:include page="../Common/header.jsp" />
		<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
		
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<pack:style src="../../Main/resources/css/chooser.css" />
		<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
		<pack:style src="../../Main/modules/sandMining/theme/css/component.css" />
		<pack:style src="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
		<pack:style src="../../Main/resources/css/commonnew.css" />
  	<%}%>
  	
  		<div id="tabs" ></div>
    <script>

var jspName = "ApOnline";

var minwidth=250;
if(<%=loginInfo.getStyleSheetOverride().equals("Y")%>){
  		if(navigator.appName == 'Microsoft Internet Explorer' || (navigator.userAgent.indexOf('Trident') != -1 && navigator.userAgent.indexOf('MSIE') == -1)){
			minwidth=120;
		}
  	}

Ext.onReady(function(){
    var test = new Ext.TabPanel({
        resizeTabs:true, // turn on tab resizing
        enableTabScroll:true,
        minTabWidth: minwidth,
        width:'100%',
        height:550,
        activeTab:'noOfEwayBillVSVisitsTab', 
        layoutOnTabChange: true,
        listeners: {
		tabchange:function(tp, newTab, currentTab){
		Ext.getCmp('noOfEwayBillVSVisitsTab').enable();
		Ext.getCmp('vehiclesWithInCompleteOrderTab').enable();
		Ext.getCmp('RouteDeviationTab').enable();
		Ext.getCmp('excessHaltingTab').enable();
		Ext.getCmp('sameVehicleSameDestTab').enable();
		Ext.getCmp('multipleVehicleSameDestiTab').enable();
		Ext.getCmp('IdleTab').enable();
		Ext.getCmp('TamperingTab').enable();
		Ext.getCmp('crossBroderTab').enable();
		}
	  },
        defaults: {autoScroll:false}
    });

    
  var index = 0;
  var tab;
    addTab();

    function addTab(){
        test.add({
        
            title: 'No of E-Way Bill V/S Sand Reach Visits',
           	iconCls: 'test',
           	id:'noOfEwayBillVSVisitsTab',
           	html : "<iframe style='width:100%;height:100%;align:center;' src='<%=path%>/Jsps/ApOnline/NoOfEwayBillVisitsDashBoard.jsp'></iframe>"
            
        }).show();
        
        test.add({
          id:'vehiclesWithInCompleteOrderTab',
            title: 'Vehicle with Order Completion',
            iconCls: 'test',
           html : "<iframe style='width:100%;height:540px;align:center;' src='<%=path%>/Jsps/ApOnline/vehiclesWithInCompleteOrderDashboard.jsp'></iframe>"
        }).show();
        
        test.add({
         id:'RouteDeviationTab',
            title: 'Destination Deviation',
            iconCls: 'test',
           html : "<iframe style='width:100%;height:540px;align:center;' src='<%=path%>/Jsps/ApOnline/RouteDeviationDashBoard.jsp'></iframe>"
          
        }).show();
        
        test.add({
        id:'excessHaltingTab',
            title: 'Excess Halting',
            iconCls: 'test',
           html : "<iframe style='width:100%;height:540px;align:center;' src='<%=path%>/Jsps/ApOnline/excessHaltingDashBoard.jsp'></iframe>"
           
        }).show();
        
        test.add({
         id:'sameVehicleSameDestTab',
            title: 'Same Vehicle Same Destination',
            iconCls: 'test',
          html : "<iframe style='width:100%;height:100%;align:center;' src='<%=path%>/Jsps/ApOnline/sameVehicleSameDestDashboard.jsp'></iframe>"
        
        }).show();
        
        test.add({
            id:'multipleVehicleSameDestiTab',
            title: 'Multiple Vehicle Same Destination',
            iconCls: 'test',
            html : "<iframe style='width:100%;height:100%;align:center;' src='<%=path%>/Jsps/ApOnline/multipleVehicleSameDestiDashBoard.jsp'></iframe>"
        }).show();
       
        
        test.add({
            id:'IdleTab',
            title: 'Idle Time Report',
            iconCls: 'test',
            html : "<iframe style='width:100%;height:100%;align:center;' src='<%=path%>/Jsps/ApOnline/IdleDashBoard.jsp'></iframe>"
        }).show();
       
       test.add({
            id:'TamperingTab',
            title: 'Tampering Report',
            iconCls: 'test',
            html : "<iframe style='width:100%;height:100%;align:center;' src='<%=path%>/Jsps/ApOnline/TamperingDashboard.jsp'></iframe>"
        }).show();
        
        test.add({
            id:'crossBroderTab',
            title: 'Cross Border Report',
            iconCls: 'test',
            html : "<iframe style='width:100%;height:100%;align:center;' src='<%=path%>/Jsps/ApOnline/crossBroderDashboard.jsp'></iframe>"
        }).show();
    }
   test.render('tabs');
   
});  
  </script>
   <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 

<%}%>