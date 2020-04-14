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
tobeConverted.add("Fuel_Reports");
ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String FDAR=convertedWords.get(0);
%>
<html> 
<title>FDAS</title>
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
var fdasTab;
var flagFdas=0;
Ext.onReady(function(){
    fdasTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,  
        activeTab: 'FDARTab', 
        width:'100%', 
        autoScroll:false,
        listeners: {
//******************************* Listener is to reload the pages on tabchange,because on tabchange he have to get the globalCustomerID*****************        
		tabchange:function(tp, newTab, currentTab){
		var activeTab = fdasTab.getActiveTab();
	    var activeTabIndex = fdasTab.items.findIndex('id', activeTab.id);
	    switch(activeTabIndex)
	    {//Jsps/FCIS/FuelConsolidatedReport.jsp
		case 0:Ext.getCmp('FDARTab').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/FCIS/FuelConsolidatedReport.jsp?feature=1'></iframe>");break;
    	}
    	}		
	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        fdasTab.add({
            title: '<%=FDAR%>',
           	iconCls: 'admintab',
           	autoScroll:false,
           	id:'FDARTab',
           	html : "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/FCIS/FuelConsolidatedReport.jsp?feature=1'></iframe>"
            
        }).show();        
    }
  fdasTab.render('admindiv');   
});		

</script>
</body>
</html>
<%}%>