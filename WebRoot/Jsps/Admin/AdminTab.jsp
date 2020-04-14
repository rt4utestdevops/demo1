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
String UserRole="User Group Association";
String roleManagement = "Role Management";
Boolean roleBasedMenu = cf.checkForRoleBasedMenu(loginInfo.getSystemId(),loginInfo.getCustomerId());
//System.out.println(" role based menu :: "+roleBasedMenu);
%>
<!--<html> -->
<jsp:include page="../Common/header.jsp" />
<title>Administrator</title>
 
<style>
.x-tab-panel-header{
border: 0px solid !important;
padding-bottom: 0px !important;
}
.x-panel-tl
{
border-bottom: 0px solid !important;
}
.x-grid3{
    width: 100% !important;
    height: 363px;
}
#admindiv{
height: 564px;
}
.footer {
			bottom : -4px !important;
		}
		
</style>
 
<!-- <body> -->
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>
<script>

var globalCustomerID="";
var flagtab=0;
  var adminTab;
Ext.onReady(function(){
Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = '534px';
			
			    adminTab.setSize(width, height);
			    adminTab.doLayout();
			});
    adminTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,
        activeTab:'customerInformationTab',  
        width:'100%', 
       
        listeners: {
//******************************* Listener is to reload the pages on tabchange,because on tabchange he have to get the globalCustomerID*****************        
		tabchange:function(tp, newTab, currentTab){
		var activeTab = adminTab.getActiveTab();
	    var activeTabIndex = adminTab.items.findIndex('id', activeTab.id);
	    var rbmn = <%=roleBasedMenu%>;
	    switch(activeTabIndex)
	    {
		case 0:Ext.getCmp('customerInformationTab').update("<iframe style='width:102%;height:525px;border:0;'src='<%=path%>/Jsps/Admin/CustomerMaster.jsp?feature=1'></iframe>");break;
		case 1:Ext.getCmp('productFeaturetab').update("<iframe style='width:100%;height:496px;border:0;' src='<%=path%>/Jsps/Admin/ProductFeature.jsp?feature=1&CustId=0'></iframe>");break;
		case 2:Ext.getCmp('customizationTab').update("<iframe style='width:100%;height:495px;border:0;' src='<%=path%>/Jsps/Admin/CustomerSetting.jsp?feature=1'></iframe>");break;
		case 3:Ext.getCmp('assetGroupTab').update("<iframe style='width:100%;height:562px;border:0;' src='<%=path%>/Jsps/Admin/AssetGroup.jsp'></iframe>");break;
		case 4:Ext.getCmp('assetassociationTab').update("<iframe style='width:100%;height:496px;border:0;' src='<%=path%>/Jsps/Admin/ProductFeature.jsp?feature=1&CustId=0&GroupId=0'></iframe>");break;
    	case 5:Ext.getCmp('userManagementTab').update("<iframe style='width:100%;height:562px;border:0;' src='<%=path%>/Jsps/Admin/UserManagement.jsp?feature=1'></iframe>");break;
    	case 6:Ext.getCmp('userAssetGroupAssociationTab').update("<iframe style='width:102%;height:530px;border:0;' src='<%=path%>/Jsps/Admin/UserAssetGroupAssociation.jsp?feature=1'></iframe>");break;
 		
 		case 7:Ext.getCmp('userFeatureDetachmentTab').update("<iframe style='width:102%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/UserFeatureDetachment.jsp?feature=1'></iframe>");break;
 		 
 		case 8:Ext.getCmp('roleManagementTab').update("<iframe style='width:102%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/RoleManagement.jsp?feature=1'></iframe>");break;
		  
 		}
    	}		
	},       
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        adminTab.add({
        
            title: '<%=customerInformation%>',
           	iconCls: 'admintab',
           	id:'customerInformationTab',
           	html : "<iframe style='width:102%;height:525px;border:0;'src='<%=path%>/Jsps/Admin/CustomerMaster.jsp?feature=1'></iframe>"
            
        }).show();        
        
        adminTab.add({
            title: '<%=productFeatures%>',
            iconCls: 'admintab',
            autoScroll:true,
            id:'productFeaturetab',
            html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/ProductFeature.jsp?feature=1&CustId=0'></iframe>"
          
        }).show();
        
        adminTab.add({
            title: '<%=customization%>',
            iconCls: 'admintab',
            id:'customizationTab',
            html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/CustomerSetting.jsp?feature=1'></iframe>"
        
        }).show();       
       
        adminTab.add({
            title: '<%=assetGroup%>',
            iconCls: 'admintab',
            id:'assetGroupTab',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/Admin/AssetGroup.jsp'></iframe>"
            //closable:true
        }).show();   
        
        adminTab.add({
            title: '<%=assetGroupFeatures%>',
            iconCls: 'admintab',
            id:'assetassociationTab',
            html : "<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/ProductFeature.jsp?feature=1&CustId=0&GroupId=0'></iframe>"          
        }).show();  
        
        adminTab.add({
            title: '<%=userManagement%>',
            iconCls: 'admintab',
            id:'userManagementTab',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/Admin/UserManagement.jsp?feature=1'></iframe>"
           
        }).show();
        var rbm = <%=roleBasedMenu%>;
        if (rbm){
           adminTab.add({
            title: '<%=roleManagement%>',
            iconCls: 'admintab',
            id:'roleManagementTab',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/Admin/RoleManagement.jsp?feature=1'></iframe>"
           
        }).show();
        }
        
          adminTab.add({
            title: '<%=UserRole%>',
            iconCls: 'admintab',
            id:'userAssetGroupAssociationTab',
            html : "<iframe style='width:102%;height:531px;border:0;' src='<%=path%>/Jsps/Admin/UserAssetGroupAssociation.jsp?feature=1'></iframe>"
           
        }).show();
       
        if (!rbm){
        adminTab.add({
			title: '<%=userFeatureDetachment%>',
			iconCls: 'admintab',
			id:'userFeatureDetachmentTab',
			html : "<iframe style='width:102%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/UserFeatureDetachment.jsp?feature=1'></iframe>"

		}).show();
		}
          
    }
  adminTab.render('admindiv'); 
  
});	
</script>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
<%}%>