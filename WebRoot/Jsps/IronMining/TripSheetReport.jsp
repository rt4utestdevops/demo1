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
<jsp:include page="../Common/header.jsp" /> 
<title>Trip Sheet Reports</title>
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
var globalCustomerID="";
var flagtab=0;
var tripTab;
Ext.onReady(function(){
Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = '554px';
			
			    tripTab.setSize(width, height);
			    tripTab.doLayout();
			});
    tripTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,
        activeTab:'tripSheetId',  
        width:'100%', 
        listeners: {
		tabchange:function(tp, newTab, currentTab){
		var activeTab = tripTab.getActiveTab();
	    var activeTabIndex = tripTab.items.findIndex('id', activeTab.id);
	    switch(activeTabIndex)
	    {
			case 0:Ext.getCmp('tripSheetId').update("<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/TripsheetReort.jsp'></iframe>");break;
			case 1:Ext.getCmp('tripwisePermitId').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/PermitWiseTripSheets.jsp'></iframe>");break;
		}
      }		
	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        tripTab.add({
      
            title: 'Trip Sheet Report',
           	iconCls: 'admintab',
           	id:'tripSheetId',
           	html : "<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/TripsheetReort.jsp'></iframe>"
            
        }).show();        
        
        tripTab.add({
            title: 'Permit-Wise Trip Report',
            iconCls: 'admintab',
            autoScroll:true,
            id:'tripwisePermitId',
            html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/PermitWiseTripSheets.jsp'></iframe>"
          
        }).show();
    }
  tripTab.render('admindiv'); 
  
});	
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
	

     