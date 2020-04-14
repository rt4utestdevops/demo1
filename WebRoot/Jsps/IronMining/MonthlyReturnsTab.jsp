<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	if(str.length>9){
		loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
		loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);	
}	
CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}		
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);
if(customerId > 0 && loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("User"))
{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
}else{
%>
	

<jsp:include page="../Common/header.jsp" />
    <title>MonthlyReturnsTab</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
	<%} %>
	<script >
		var monthlyReturnsTab;
		Ext.onReady(function(){
			Ext.EventManager.onWindowResize(function () {
				 var width = '100%';
				 var height = '100%';
				 monthlyReturnsTab.setSize(width, height);
				 monthlyReturnsTab.doLayout();
				});
	    	monthlyReturnsTab = new Ext.TabPanel({
		        resizeTabs:false,
		        enableTabScroll:true,
		        activeTab:'generalLabourTab',  
		        width:'100%', 
		        defaults: {autoScroll:false}
		     });
	     	addTab();
		    function addTab(){
		        monthlyReturnsTab.add({
		        title: 'Monthly Return',
		       	iconCls: 'admintab',
		       	id:'generalLabourTab',
		       	html : "<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/MonthlyReturn.jsp'></iframe>"
		        }).show();  
		        
		        monthlyReturnsTab.add({
		        title: 'General and Labour',
		       	iconCls: 'admintab',
		       	id:'partOneTab',
		       	html : "<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/MonthlyReturnsFormOnePartOne.jsp'></iframe>"
		        }).disable(); 
		        
		        monthlyReturnsTab.add({
		        title: 'Production Despatches And Stocks',
		       	iconCls: 'admintab',
		       	id:'partTwoTab',
		       	html : "<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/MonthlyReturnsFormOnePartTwo.jsp'></iframe>"
		        }).disable(); 
		        
		        monthlyReturnsTab.add({
		        title: 'Processing Outside The Mining Lease',
		       	iconCls: 'admintab',
		       	id:'partFourTab',
		       	html : "<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/MonthlyReturnsFormOnePartFour.jsp'></iframe>"
		        }).disable(); 
		        
		        monthlyReturnsTab.add({
		        title: 'Certify Information',
		       	iconCls: 'admintab',
		       	id:'partThreeTab',
		       	html : "<iframe style='width:100%;height:524px;border:0;'src='<%=path%>/Jsps/IronMining/MonthlyReturnsFormOnePartThree.jsp'></iframe>"
		        }).disable();     
		    }
			  monthlyReturnsTab.render('admindiv'); 
		});	
	</script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
