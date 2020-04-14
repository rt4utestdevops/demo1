<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Customers_Information");
tobeConverted.add("Product_Features");
tobeConverted.add("Customization");
tobeConverted.add("User_Management");
tobeConverted.add("User_Feature_Detachment");
tobeConverted.add("Asset_Group");
tobeConverted.add("Asset_Group_Features"); 
tobeConverted.add("User_Role"); 

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String customerInformation=convertedWords.get(0);
String productFeatures=convertedWords.get(1);
String customization=convertedWords.get(2);
String userManagement=convertedWords.get(3);
String userFeatureDetachment=convertedWords.get(4);
String assetGroup=convertedWords.get(5);
String assetGroupFeatures=convertedWords.get(6);	
String UserRole=convertedWords.get(7);
%>
<jsp:include page="../Common/header.jsp" />
<title>Vehicle Subscription</title>
<style>
.x-tab-panel-header{
border: 0px solid !important;
padding-bottom: 0px !important;
}
.x-panel-tl
{
border-bottom: 0px solid !important;
}
.x-tab-strip-inner
{
    width: 175px !important;
}
</style>

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>
     
 <script>
     
    
    Ext.onReady(function(){
     adminTab = new Ext.TabPanel({
        resizeTabs:true, 
        enableTabScroll:false,
        width:screen.width-20,
        height:555,   
        activeTab: 'VSTabId',
        layoutOnTabChange: true,
        listeners: {
		tabchange:function(tp, newTab, currentTab){

    }
	},
        defaults: {autoScroll:false}
     });
   
    addTab();
   function addTab(){
        adminTab.add({
            id:'VSTabId',
            title: 'Vehicle Subscription',
            iconCls: 'test',
            listeners: {
		       show: function(panel) { 
		                  
		        
		         // console.log(Ext.getCmp('ToPlaceId').getValue());
		       }
		   },
           html : "<iframe style='width:102%;height:576px;align:center'; src='<%=path%>/Jsps/SandMining/VehicleSubscriptionDetail.jsp'></iframe>"
        }).show();
        
         adminTab.add({
           id:'Reporttab',
           title: 'Vehicle Subscription Report',
           iconCls: 'test',
           html : "<iframe style='width:100%;height:100%;align:center'; src='<%=path%>/Jsps/SandMining/VehicleSubscriptionRenwal.jsp'></iframe>"
        }).show();
        
         adminTab.add({
           id:'ReconReporttab',
           title: 'Reconciliation Report',
           iconCls: 'test',
           html : "<iframe style='width:100%;height:100%;align:center'; src='<%=path%>/Jsps/SandMining/SandReconciliationReport.jsp'></iframe>"
        }).show();
        
         adminTab.add({
           id:'ReporttabNew',
           title: 'InActive Vehicle Subscription Report',
           iconCls: 'test',
           html : "<iframe style='width:100%;height:100%;align:center'; src='<%=path%>/Jsps/SandMining/VehicleSubscriptionRenwalReport.jsp'></iframe>"
        }).show();
        
         }
   adminTab.render('admindiv'); 
   
   
});		

</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>