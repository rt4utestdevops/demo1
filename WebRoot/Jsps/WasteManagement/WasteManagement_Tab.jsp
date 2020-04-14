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
tobeConverted.add("Trader_Master");
tobeConverted.add("Daily_Attendance_Report");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String trademaster=convertedWords.get(0);
String dailyattendacerepo=convertedWords.get(1);

%>
<jsp:include page="../Common/header.jsp" />
<title>Waste Management</title>
<style>
.x-tab-panel-header{
border: 0px solid !important;
padding-bottom: 0px !important;
}
.x-panel-tl
{
border-bottom: 0px solid !important;
}
.footer {
	bottom : -2px !important;
}
</style>

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>

<script>
var WasteManagementTab;
var flagwaste=0;
Ext.onReady(function(){
	Ext.EventManager.onWindowResize(function () {
				var width = '100%';
			    var height = '100%';
			
			    WasteManagementTab.setSize(width, height);
			    WasteManagementTab.doLayout();
	});
    WasteManagementTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:false,  
        activeTab: 'tradermasterTab', 
        width:screen.width-25,
        height:550,  
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        WasteManagementTab.add({
        
            title: '<%=trademaster%>',
           	iconCls: 'admintab',
           	id:'tradermasterTab',
           	html : "<iframe style='width:100%;height:540px;border:0;'src='<%=path%>/Jsps/WasteManagement/TraderMaster.jsp'></iframe>"
            
        }).show();        
        
        WasteManagementTab.add({
            title: '<%=dailyattendacerepo%>',
            iconCls: 'admintab',
            id:'dailyattendtab',
           	html : "<iframe style='width:100%;height:585px;border:0;' src='<%=path%>/Jsps/WasteManagement/DailyAttendanceReport.jsp'></iframe>"
          
        }).show();
            
    }
  WasteManagementTab.render('admindiv');   
});		

</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>