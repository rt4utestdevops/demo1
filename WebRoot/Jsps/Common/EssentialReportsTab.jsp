<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<% CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
String language=loginInfo.getLanguage();
String historyAnalysis="Analysis on Map"; //cf.getLabelFromDB("History_Analysis",language);
String exceptionAnalysis="Device Activity";//cf.getLabelFromDB("Exception_Analysis",language);
String activityReport="Vehicle Activity";//cf.getLabelFromDB("Activity_Report",language);
String actionSummaryReport="Action Summary";cf.getLabelFromDB("Action_Summary_Report",language);
String totalDistanceReport=cf.getLabelFromDB("Total_Distance_Summary_Report",language);
String hubArrivalDepartureReport="Hub Arrival/Hub Departure";cf.getLabelFromDB("Hub_Arrival_Hub_Departure_Report",language);

%>

<!-- <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> -->
<!-- <html:html lang="true"> -->
 <!--  <head> -->
  <!--   <html:base />  -->
    
    <!-- <title>EssentialReportsTab.jsp</title> -->
	 <jsp:include page="../Common/header.jsp" />

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<style>
		.footer {
			bottom : -10px !important;
		}
		
		
	</style>
 
  <!-- <body>  -->
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>
<script type="text/javascript">
 var essentialReportsTab;
Ext.onReady(function(){
    essentialReportsTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,
        activeTab:'activityReportTab',  
        width:'100%',
        listeners: {
//******************************* Listener is to reload the pages on tabchange,because on tabchange he have to get the globalCustomerID*****************        
		tabchange:function(tp, newTab, currentTab){
			Ext.getCmp('historyTrackingTab').enable();
			Ext.getCmp('exceptionAnalysisTab').enable();
			Ext.getCmp('activityReportTab').enable();
			Ext.getCmp('SummaryReportTab').enable();
			//Ext.getCmp('totalDistanceTab').enable();
			Ext.getCmp('hubArrivalTab').enable();
    	}		
	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
    
        essentialReportsTab.add({
            title: '<%=activityReport%>',
            iconCls: 'admintab',
            id:'activityReportTab',
            html : "<iframe style='width:100%;height:522px;border:0;' src='/jsps/Activity_jsp/ActivityReport.jsp?ipVal=true'></iframe>"
        
        }).show(); 
        
        essentialReportsTab.add({
        
            title: '<%=historyAnalysis%>',
           	iconCls: 'admintab',          
           	id:'historyTrackingTab',
           	html : "<iframe style='width:100%;height:522px;border:0;'src='/Telematics4uApp/Jsps/Common/HistoryAnalysis.jsp'></iframe>"
            
        }).show();   
        
         essentialReportsTab.add({
            title: '<%=hubArrivalDepartureReport%>',
            iconCls: 'admintab',
            id:'hubArrivalTab',
            html : "<iframe style='width:100%;height:522px;border:0;' src='/jsps/report_jsps/HubArrivalDepReport.jsp?ipVal=true'></iframe>"
           
        }).show();     
        
        essentialReportsTab.add({
            title: '<%=actionSummaryReport%>',
            iconCls: 'admintab',
            id:'SummaryReportTab',
            html : "<iframe style='width:100%;height:522px;border:0;' src='/jsps/report_jsps/SummaryReport.jsp?ipVal=true'></iframe>"
            //closable:true
        }).show();   
        
         essentialReportsTab.add({
            title: '<%=exceptionAnalysis%>',
            iconCls: 'admintab',            
            id:'exceptionAnalysisTab',
            html : "<iframe style='width:100%;height:522px;border:0;' src='/jsps/ExceptionAnalysisReport.jsp?ipVal=true'></iframe>"
          
        }).show();
        
<!--        essentialReportsTab.add({-->
<!--            title: '<%=totalDistanceReport%>',-->
<!--            iconCls: 'admintab',-->
<!--            id:'totalDistanceTab',-->
<!--            html : "<iframe style='width:100%;height:522px;border:0;' src='/jsps/report_jsps/TotalDistanceReportNew.jsp'></iframe>"          -->
<!--        }).show();  -->
        
               
        
          
    }
  essentialReportsTab.render('admindiv'); 
  
});	
</script>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
<!--</html:html> -->
