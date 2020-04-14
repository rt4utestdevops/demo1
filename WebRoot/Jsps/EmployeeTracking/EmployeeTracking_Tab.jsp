<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Daily_Employ_Tracking");
tobeConverted.add("Daily_Status_Report");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String employtracking=convertedWords.get(0);
String statusreport=convertedWords.get(1);

%>
<html> 
<title>Employee Tracking</title>
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
<jsp:include page="../Common/MenuTabJS.jsp" />
<script>
var employtracTab;
var flagEmp=0;
Ext.onReady(function(){
    employtracTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,  
        activeTab: 'dashboardtab', 
        width:'100%',  
        listeners: {
//******************************* Listener is to reload the pages on tabchange,because on tabchange he have to get the globalCustomerID*****************        

	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
            
        employtracTab.add({
            title: 'DashBoard',
            iconCls: 'admintab',
            id:'dashboardtab',
            html : "<iframe style='width:100%;height:680px;border:0;' src='<%=path%>/Jsps/EmployeeTracking/DashBoard.jsp'></iframe>"
          
        }).show();
        
        employtracTab.add({
        
            title: '<%=employtracking%>',
           	iconCls: 'admintab',
           	id:'employtrackingTab',
           	html : "<iframe style='width:100%;height:950px;border:0;'src='<%=path%>/Jsps/EmployeeTracking/EmployeeTracking.jsp'></iframe>"
            
        }).show();        
        
        employtracTab.add({
            title: '<%=statusreport%>',
            iconCls: 'admintab',
            id:'statusreporttab',
            html : "<iframe style='width:100%;height:600px;border:0;' src='<%=path%>/Jsps/EmployeeTracking/StatusReport.jsp'></iframe>"
          
        }).show();
            
    }
  employtracTab.render('admindiv');   
});		

</script>
</body>
</html>
<%}%>