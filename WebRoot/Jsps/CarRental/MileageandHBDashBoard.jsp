<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	LoginInfoBean loginInfo1=new LoginInfoBean();
	loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo1!=null)
	{
	int isLtsp=loginInfo1.getIsLtsp();
	loginInfo.setIsLtsp(isLtsp);
	loginInfo.setStyleSheetOverride(loginInfo1.getStyleSheetOverride());
	}
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
ArrayList<String> tobeConverted=new ArrayList<String>();


ArrayList<String> convertedWords=new ArrayList<String>();

%>
<html> 
<title>Mileage and HB DashBoard</title>
<style>
.x-tab-panel-header{
border: 0px solid !important;
padding-bottom: 0px !important;
}
.x-panel-tl
{
border-bottom: 0px solid !important;
}
</style>
<body>
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>
<script>
var globalCustomerID="";
var flagtab=0;
var masterTab;
Ext.onReady(function(){
Ext.EventManager.onWindowResize(function () {
	 var width = '100%';
     var height = '680px';

    masterTab.setSize(width, height);
    masterTab.doLayout();
});
    masterTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,
        activeTab:'MileageAnalysisId',  
        width:'100%', 
        listeners: {
		tabchange:function(tp, newTab, currentTab){
		var activeTab = masterTab.getActiveTab();
	    var activeTabIndex = masterTab.items.findIndex('id', activeTab.id);
	    switch(activeTabIndex)
	    {
	    case 0:Ext.getCmp('MileageAnalysisId').update("<iframe style='width:100%;height:496px;border:0;' src='<%=path%>/Jsps/CarRental/FuelAndMileageDashboard.jsp'></iframe>");break;
		case 1:Ext.getCmp('HBAnalysisId').update("<iframe style='width:100%;height:496px;border:0;'src='<%=path%>/Jsps/CarRental/HBAnalysisReport.jsp'></iframe>");break;
		case 2:Ext.getCmp('heatMapId').update("<iframe style='width:100%;height:496px;border:0;'src='<%=path%>/Jsps/CarRental/HBAnalysisMap.jsp'></iframe>");break;
		
		}
    	}		
	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        masterTab.add({
            title: 'Fuel and Mileage Analysis',
            iconCls: 'admintab',
            autoScroll:true,
            id:'MileageAnalysisId',
            html : "<iframe style='width:100%;height:496px;border:0;' src='<%=path%>/Jsps/CarRental/FuelAndMileageDashboard.jsp'></iframe>"
          
        }).show();
        masterTab.add({
        
            title: 'Harsh Brake Analysis',
           	iconCls: 'admintab',
           	id:'HBAnalysisId',
           	html : "<iframe style='width:100%;height:496px;border:0;'src='<%=path%>/Jsps/CarRental/HBAnalysisReport.jsp'></iframe>"
            
        }).show();   
         masterTab.add({
        
            title: 'Harsh Brake Heat Map',
           	iconCls: 'admintab',
           	id:'heatMapId',
           	html : "<iframe style='width:100%;height:496px;border:0;'src='<%=path%>/Jsps/CarRental/HBAnalysisMap.jsp'></iframe>"
            
        }).show();      
        

    }
  masterTab.render('admindiv'); 
  
});	
</script>
</body>
</html>
<%}%>