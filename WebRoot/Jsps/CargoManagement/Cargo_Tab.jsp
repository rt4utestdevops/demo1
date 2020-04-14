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
tobeConverted.add("Cargo_Route_Skeleton");
tobeConverted.add("Trip_Allocation");
tobeConverted.add("Planned_Movement_Report");
tobeConverted.add("Route_Skeleton");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String cargorouteskeleton=convertedWords.get(0);
String tripalloctaion=convertedWords.get(1);
String PlannedMovementReport=convertedWords.get(2);
String RouteSkeleton = convertedWords.get(3);
%>
 <jsp:include page="../Common/header.jsp" />
<title>Cargo Management</title>
<style>
.x-tab-panel-header
{
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
        <jsp:include page="../Common/MenuTabJS.jsp" /><%} %> 
<script>
var CargoTab;
var flagCargo=0;
Ext.onReady(function(){
	Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = 555;
			
			    CargoTab.setSize(width, height);
			    CargoTab.doLayout();
	});
    CargoTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,  
        activeTab: 'ExecutiveDashboardTab', 
        width:'100%',
        height:550,  
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
    	CargoTab.add({
        
            title: 'Executive Dashboard',
           	iconCls: 'admintab',
           	id:'ExecutiveDashboardTab',
           	html : "<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/CargoManagement/ExecutiveDashboard.jsp'></iframe>"
            
        }).show(); 
        
        CargoTab.add({
        
            title: '<%=RouteSkeleton%>',
           	iconCls: 'admintab',
           	id:'CargoRouteSkeletonTab',
           	html : "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/CargoManagement/RouteSkeleton.jsp'></iframe>"
            
        }).show();        
        
        CargoTab.add({
            title: 'Route Allocation',
            iconCls: 'admintab',
            id:'TripAllocationtab',
            autoScroll:true,
            html : "<iframe style='width:100%;height:522px;border:0;' src='<%=path%>/Jsps/CargoManagement/TripAllocation.jsp'></iframe>"
          
        }).show();
        
        CargoTab.add({
            title: '<%=PlannedMovementReport%>',
            iconCls: 'admintab',
            id:'CargoDashBoardTab',
            html : "<iframe style='width:100%;height:600px;border:0;' src='<%=path%>/Jsps/CargoManagement/PlannedMovementReport.jsp'></iframe>"
            
        
        }).show();
            
    }
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>  
    var tab = Ext.getCmp('ExecutiveDashboardTab');
   	CargoTab.remove(tab);
    <%} %> 
    
    CargoTab.render('admindiv');  
  
});		

</script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>