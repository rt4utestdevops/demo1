<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
   CommonFunctions cf = new CommonFunctions();
   cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
   
   
   String clientID=request.getParameter("cutomerID");
   String alertID=request.getParameter("AlertType");
   
   
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");	          
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath() + "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		ArrayList<String> tobeConverted = new ArrayList<String>();
		tobeConverted.add("Manage_Service");

		ArrayList<String> convertedWords = new ArrayList<String>();
		String language = loginInfo.getLanguage();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted, language);
		String ManageService=convertedWords.get(0);
%>
 <jsp:include page="../Common/header.jsp" />
	<title>Manage Task Tab</title>
	<style>
.x-tab-panel-header {
	border: 0px solid !important;
	padding-bottom: 0px !important;
}

.x-panel-tl {
	border-bottom: 0px solid !important;
}
/* newly added with Header/Footer Changes */
		.x-panel-header
		{
				height: 7% !important;
		}
		.x-form-radio {
			margin-bottom: 7px;
		}
		.x-form-label-left label {
			text-align: left;
			margin-top: 4px !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
</style>
	
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/MenuTabJS.jsp" /><%} %>
		<script>
		var ManageTasksTab;
		var flagManageTask = 0;
		var clientID="";
		var alertID="";
		
		Ext.onReady(function () {
		Ext.EventManager.onWindowResize(function () {
        var width = screen.width-20;
        var height = 555;
        ManageTasksTab.setSize(width, height);
        ManageTasksTab.doLayout();
    	});
	    
	    ManageTasksTab = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll: true,
	    activeTab: 'ManageTaskTabId',
	    width: screen.width-20,
	    height:555,
	    defaults: {
	            autoScroll: false
	        }
	    });
	    addTab();

	    function addTab() {
	        ManageTasksTab.add({

	            title: '<%=ManageService%>',
	            iconCls: 'admintab',
	            id: 'ManageTaskTabId',
	            html: "<iframe style='width:100%;height:600px;border:0' src=<%=path%>/Jsps/PreventiveMaintenance/ManageAllTasks.jsp?clientID="+<%=clientID%>+"&alertID="+<%=alertID%>+"></iframe>"

	        }).show();
 	    }
	    ManageTasksTab.render('admindiv');
	});
		</script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%
	}
%>