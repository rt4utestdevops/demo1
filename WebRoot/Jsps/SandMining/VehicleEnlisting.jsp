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
tobeConverted.add("Asset_Enlisting");
tobeConverted.add("Asset_Delisting_Report");

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String assetEnlisting=convertedWords.get(0);
String assetDelistingReport=convertedWords.get(1);
%>
<jsp:include page="../Common/header.jsp" />
<title>ASSET ENLISTING DELISTING</title>

<jsp:include page="../Common/SandMiningMenuTabJS.jsp" />
<script>
var flagASSET=0;
var ASSETTab;
Ext.onReady(function(){
  Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
			    var height = 550; 
			
			    ASSETTab.setSize(width, height);
			    ASSETTab.doLayout();
			});
    ASSETTab = new Ext.TabPanel({
        resizeTabs:false, // turn off tab resizing
        enableTabScroll:true,  
        activeTab:'assetEnlistingTab', 
       width:'100%',  
       height:550,
        defaults: {autoScroll:false}
     });
     addTab();
     
    function addTab(){
        ASSETTab.add({
            title: '<%=assetEnlisting%>',
            iconCls: 'admintab',
            id:'assetEnlistingTab',   
            html : "<iframe style='width:100%;height:595px;border:0;' src='<%=path%>/Jsps/SandMining/AssetEnlisting.jsp'></iframe>"
          
        }).show();
       
        
        ASSETTab.add({        
            title: '<%=assetDelistingReport%>',
           	iconCls: 'admintab', 
           	id:'delistingTab',
           	html : "<iframe style='width:100%;height:595px;border:0;'src='<%=path%>/Jsps/SandMining/AssetDelistingReport.jsp'></iframe>"
            
        }).show();        
                
            
    }
 ASSETTab.render('admindiv');   
});		
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>