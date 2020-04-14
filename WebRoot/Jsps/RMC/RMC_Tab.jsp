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
tobeConverted.add("RMC_Setting");
tobeConverted.add("RMC_Plant_Association");
tobeConverted.add("RMC_Operation_Hour_Report");
tobeConverted.add("RMC_Activity_Report");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String rmcsetting=convertedWords.get(0);
String rmcplantassoc=convertedWords.get(1);
String rmcoperationhour=convertedWords.get(2);
String rmcactivityrep=convertedWords.get(3);
%>
<jsp:include page="../Common/header.jsp" />
<title>RMC</title>
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
   <jsp:include page="../Common/MenuTabJS.jsp" /><%} %>

<!--<jsp:include page="../Common/MenuTabJS.jsp" />-->
	<style>
		.ext-strict .x-form-text  {
			height : 15px !important;
		}
		.x-toolbar x-small-editor x-toolbar-layout-ct {
				width : 1305px !important;
			}
			.footer {
				bottom : -12px !important;
			}
			
	</style>
	
<script>
var flagRMC=0;
var RMCTab;
Ext.onReady(function(){
  Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = '100%';
			
			    RMCTab.setSize(width, height);
			    RMCTab.doLayout();
			});
    RMCTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:false,  
        activeTab:'rmcplantassoctab', 
        width:'100%',  
        defaults: {autoScroll:false}
     });
     addTab();
    function addTab(){
        RMCTab.add({
            title: '<%=rmcplantassoc%>',
            iconCls: 'admintab',
            id:'rmcplantassoctab',
//            autoScroll:true,
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/RMC/RMCPlantAssociation.jsp'></iframe>"
          
        }).show();
        
        RMCTab.add({        
            title: '<%=rmcsetting%>',
           	iconCls: 'admintab',
           	id:'rmcsettingTab',
           	html : "<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/RMC/RMCSetting.jsp'></iframe>"
            
        }).show();        
                
        RMCTab.add({
            title: '<%=rmcoperationhour%>',
            iconCls: 'admintab',
            id:'rmcoperationhourTab',
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/RMC/RMCOperationHourReport.jsp'></iframe>"
        
        }).show();
        
        RMCTab.add({
            title: '<%=rmcactivityrep%>',
            iconCls: 'admintab',
            id:'rmcactivityrepTab',
//            autoScroll:true,
            html : "<iframe style='width:100%;height:530px;border:0;' src='<%=path%>/Jsps/RMC/RMCActivityReport.jsp'></iframe>"
           
        }).show();
            
    }
  RMCTab.render('admindiv');   
});		

</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>