<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String list1=null;
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	list1=request.getParameter("list").toString().trim();
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
<title>DMG Masters</title>
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
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
   var url = '/Telematics4uApp/Jsps/IronMining/MiningTCMaster.jsp?ipVal=true' ;                                      
   <%}else {%>  
   var url = '/Telematics4uApp/Jsps/IronMining/MiningTCMaster.jsp??ipVal=true&list=' + '<%=list1%>' ;
<%} %>
 

var globalCustomerID="";
var flagtab=0;
var masterTab;
Ext.onReady(function(){
Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = '554px';
			
			    masterTab.setSize(width, height);
			    masterTab.doLayout();
			});
    masterTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,
        activeTab:'acHeadMasterTabId',  
        width:'100%', 
        listeners: {
		tabchange:function(tp, newTab, currentTab){
		var activeTab = masterTab.getActiveTab();
	    var activeTabIndex = masterTab.items.findIndex('id', activeTab.id);
	    switch(activeTabIndex)
	    {
		case 0:Ext.getCmp('acHeadMasterTabId').update("<iframe style='width:100%;height:525px;border:0;'src='<%=path%>/Jsps/IronMining/AccountsHeadMaster.jsp?ipVal=true'></iframe>");break;
		case 1:Ext.getCmp('mineralMasterTabId').update("<iframe style='width:100%;height:496px;border:0;' src='<%=path%>/Jsps/IronMining/MineMaster.jsp?ipVal=true'></iframe>");break;
		case 2:Ext.getCmp('gradeMasterTabId').update("<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/MiningGradeMaster.jsp?ipVal=true'></iframe>");break;
		case 3:Ext.getCmp('tradeMasterTabId').update("<iframe style='width:100%;height:562px;border:0;' src='<%=path%>/Jsps/IronMining/TraderMaster.jsp'></iframe>");break;
		case 4:Ext.getCmp('orgMasterTabId').update("<iframe style='width:100%;height:562px;border:0;' src='<%=path%>/Jsps/IronMining/MiningOrganizationMaster.jsp?ipVal=true'></iframe>");break;
		case 5:Ext.getCmp('mineMasterTabId').update("<iframe style='width:100%;height:496px;border:0;' src='<%=path%>/Jsps/IronMining/MineDetails.jsp?ipVal=true'></iframe>");break;
    	case 6:Ext.getCmp('tcLeaseMasterTabId').update("<iframe style='width:100%;height:562px;border:0;' src='" + url + "'></iframe>");break;
    	case 7:Ext.getCmp('mineOwnerMasterTabId').update("<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/MineOwnerMaster.jsp?ipVal=true'></iframe>");break;
    	case 8:Ext.getCmp('plantMasterTabId').update("<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/PlantMaster.jsp'></iframe>");break;
    	case 9:Ext.getCmp('wbMasterTabId').update("<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/WeighbridgeMaster.jsp'></iframe>");break;
    	case 10:Ext.getCmp('vesselMasterTabId').update("<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/VesselMaster.jsp'></iframe>");break;
    	case 11:Ext.getCmp('motherRouteTabId').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MotherRouteMaster.jsp'></iframe>");break;
 		case 12:Ext.getCmp('tripDetailsTabId').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MiningRouteMaster.jsp'></iframe>");break;
 		case 13:Ext.getCmp('lotMasterTabId').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/LotMaster.jsp'></iframe>");break;
 		case 14:Ext.getCmp('lotAllocationTabId').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/LotAllocation.jsp'></iframe>");break;
 		case 15:Ext.getCmp('processingFeeTabId').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/ProcessingFeeMaster.jsp'></iframe>");break;
		}
    	}		
	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        masterTab.add({
        
            title: 'Account Head Master',
           	iconCls: 'admintab',
           	id:'acHeadMasterTabId',
           	html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/AccountsHeadMaster.jsp?ipVal=true'></iframe>"
            
        }).show();        
        
        masterTab.add({
            title: 'Mineral Master',
            iconCls: 'admintab',
            autoScroll:true,
            id:'mineralMasterTabId',
            html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MineMaster.jsp?ipVal=true'></iframe>"
          
        }).show();
        
        masterTab.add({
            title: 'Grade Master',
            iconCls: 'admintab',
            id:'gradeMasterTabId',
            html : "<iframe style='width:102%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MiningGradeMaster.jsp?ipVal=true'></iframe>"
        
        }).show();       
       
       masterTab.add({
			title: 'Trader Master',
			iconCls: 'admintab',
			id:'tradeMasterTabId',
			html : "<iframe style='width:100%;height:525px;border:0;' src='/jsps/Trip_jsps/TraderMaster.jsp'></iframe>"

		}).show();
      
        masterTab.add({
            title: 'Organization Master',
            iconCls: 'admintab',
            id:'orgMasterTabId',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/MiningOrganizationMaster.jsp?ipVal=true'></iframe>"
        }).show();   
        
        masterTab.add({
            title: 'Mine Master',
            iconCls: 'admintab',
            id:'mineMasterTabId',
            html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MineDetails.jsp?ipval=true'></iframe>"          
        }).show();  
        
         masterTab.add({
            title: 'Lease Master',
            iconCls: 'admintab',
            id:'tcLeaseMasterTabId',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/MiningTCMaster.jsp?list='+'<%=list1%>'></iframe>"
        }).show();
        
          masterTab.add({
            title: 'Mine Owner Master',
            iconCls: 'admintab',
            id:'mineOwnerMasterTabId',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/MineOwnerMaster.jsp?ipVal=true'></iframe>"
           
        }).show();
       
   		masterTab.add({
            title: 'Plant Master',
            iconCls: 'admintab',
            id:'plantMasterTabId',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/PlantMaster.jsp'></iframe>"
           
        }).show();
        
        masterTab.add({
            title: 'Weighbridge Master',
            iconCls: 'admintab',
            id:'wbMasterTabId',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/WeighbridgeMaster.jsp'></iframe>"
           
        }).show();
        
        masterTab.add({
            title: 'Vessel Master',
            iconCls: 'admintab',
            id:'vesselMasterTabId',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/IronMining/VesselMaster.jsp'></iframe>"
           
        }).show();
        
         masterTab.add({
			title: 'Mother Route Master',
			iconCls: 'admintab',
			id:'motherRouteTabId',
			html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MotherRouteMaster.jsp'></iframe>"

		}).show();
		
        masterTab.add({
			title: 'Route Master',
			iconCls: 'admintab',
			id:'tripDetailsTabId',
			html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/MiningRouteMaster.jsp'></iframe>"

		}).show();
		
		masterTab.add({
			title: 'Lot Master',
			iconCls: 'admintab',
			id:'lotMasterTabId',
			html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/LotMaster.jsp'></iframe>"

		}).show();
		
		masterTab.add({
			title: 'Lot Allocation',
			iconCls: 'admintab',
			id:'lotAllocationTabId',
			html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/LotAllocation.jsp'></iframe>"

		}).show();
		
		masterTab.add({
			title: 'Processing Fee Master',
			iconCls: 'admintab',
			id:'processingFeeTabId',
			html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/IronMining/ProcessingFeeMaster.jsp'></iframe>"

		}).show();
    }
  masterTab.render('admindiv'); 
  
});	
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
	

     