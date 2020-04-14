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
tobeConverted.add("Utilization_Working_Days");
tobeConverted.add("Utilization_During_Working_Days_And_Working_Hrs");
tobeConverted.add("Utilization_During_Working_Days_After_Working_Hrs");
tobeConverted.add("Utilization_During_Holidays_And_Weekends");
tobeConverted.add("Utilization_Summary_Report");
tobeConverted.add("Asset_Utilization_Reports");
tobeConverted.add("Asset_Utilization_And_Analysis");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String UtilizationWorkingDays=convertedWords.get(0);
String UtilizationDaysHours=convertedWords.get(1);
String UtilizationWorkingDaysAfterWorkingHours=convertedWords.get(2);
String UtilizationDuringHolidaysAndWeekends=convertedWords.get(3);
String UtilizationSummaryReport=convertedWords.get(4);
String AssetUtilizationReports=convertedWords.get(5);
String AssetUtilizationAndAnalysis=convertedWords.get(6);



%>
<jsp:include page="../Common/header.jsp" />
<title><%=AssetUtilizationAndAnalysis%></title>
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

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>
<script>
var flagASSET=0;
var UtilizationTab;
Ext.onReady(function(){
  Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = 600; 
			
			    UtilizationTab.setSize(width, height);
			    UtilizationTab.doLayout();
			});
    UtilizationTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,  
        activeTab:'workingDaysTab', 
       width:'100%',  
       height:550,
        defaults: {autoScroll:false}
     });
     addTab();
     
    function addTab(){
        UtilizationTab.add({
            title: '<%=UtilizationWorkingDays%>',
            iconCls: 'admintab',
            id:'workingDaysTab',   
            html : "<iframe style='width:100%;height:620px;border:0;' src='<%=path%>/Jsps/Utilization/UtilizationWorkingDays.jsp'></iframe>"
          
        }).show();
       
        
        UtilizationTab.add({        
            title: '<%=UtilizationDaysHours%>',
           	iconCls: 'admintab', 
           	id:'daysHoursTab',
           	html : "<iframe style='width:100%;height:620px;border:0;'src='<%=path%>/Jsps/Utilization/UtilizationDaysHrs.jsp'></iframe>"
            
        }).show();  
        
         UtilizationTab.add({        
            title: '<%=UtilizationWorkingDaysAfterWorkingHours%>',
           	iconCls: 'admintab', 
           	id:'workingDaysAfterHoursTab',
           	html : "<iframe style='width:100%;height:620px;border:0;'src='<%=path%>/Jsps/Utilization/VehicleUtilizationDuringWorkingDaysAfterWorkingHrs.jsp'></iframe>"
            
        }).show();     
        
        UtilizationTab.add({        
            title: '<%=UtilizationDuringHolidaysAndWeekends%>',
           	iconCls: 'admintab', 
           	id:'holidaysAndWeekendsTab',
           	html : "<iframe style='width:100%;height:620px;border:0;'src='<%=path%>/Jsps/Utilization/UtilizationHolidayAndWeekends.jsp'></iframe>"
            
        }).show();  
              
         UtilizationTab.add({        
            title: '<%=UtilizationSummaryReport%>',
           	iconCls: 'admintab', 
           	id:'summaryTab',
           	html : "<iframe style='width:100%;height:620px;border:0;'src='<%=path%>/Jsps/Utilization/VehicleUtilizationSummaryReport.jsp'></iframe>"
            
        }).show();         
            
    }
 UtilizationTab.render('admindiv');   
});		
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>