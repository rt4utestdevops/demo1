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
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Asset_Group_Hub_Association");
tobeConverted.add("Daily_AssetUtilization_Report");
tobeConverted.add("Monthly_Asset_Utilization_Report");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String assetgrouphubassoc=convertedWords.get(0);
String dailyassetutirepo=convertedWords.get(1);
String monthlyassetutirepo=convertedWords.get(2);

%>
<html> 
<title>Demo or Lease Car Management</title>
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
var DemoCarTab;
var flagDemo=0;
Ext.onReady(function(){
	Ext.EventManager.onWindowResize(function () {
				var width = screen.width-22;
			    var height = 550;
			
			    DemoCarTab.setSize(width, height);
			    DemoCarTab.doLayout();
	});
    DemoCarTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:false,  
        setAutoScroll: false,
        activeTab:'AssetGroupHubAssociationTab', 
        width:screen.width-24,  
        height:550,
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        DemoCarTab.add({
        
            title: '<%=assetgrouphubassoc%>',
           	iconCls: 'admintab',
           	id:'AssetGroupHubAssociationTab',
           	html : "<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/DemoCar/AssetGroupHubAssociation.jsp'></iframe>"
            
        }).show();        
        
        DemoCarTab.add({
            title: '<%=dailyassetutirepo%>',
            iconCls: 'admintab',
            autoScroll:true,
            id:'DailyAssetUtilizationReporttab',
          html : "<iframe style='width:100%;height:524px;border:0;' src='<%=path%>/Jsps/DemoCar/DailyAssetUtilizationReport.jsp'></iframe>"
          
        }).show();
        
        DemoCarTab.add({
            title: '<%=monthlyassetutirepo%>',
            iconCls: 'admintab',
            id:'MonthlyAssetUtilizationReportTab',
            autoScroll:true,
            html : "<iframe style='width:100%;height:524px;border:0;' src='<%=path%>/Jsps/DemoCar/MonthlyAssetUtilizationReport.jsp'></iframe>"
       
        }).show();
            
    }
  DemoCarTab.render('admindiv');   
});		

</script>
</body>
</html>
<%}%>