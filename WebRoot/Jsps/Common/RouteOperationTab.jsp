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
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath() + "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		ArrayList<String> tobeConverted = new ArrayList<String>();
		tobeConverted.add("Calibration_Status");
		tobeConverted.add("FDAS_Refuel");
		tobeConverted.add("Enrolment_Form");
		tobeConverted.add("Work_Location_Map");

		ArrayList<String> convertedWords = new ArrayList<String>();
		String language = loginInfo.getLanguage();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted, language);
		String CalibrationStatus = convertedWords.get(0);
		String FDASRefuel = convertedWords.get(1);
		String EnrolmentForm=convertedWords.get(2);
		String WorkLocationMap=convertedWords.get(3);
%>


<jsp:include page="../Common/header.jsp" />
	<meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8" />
	<style>
.x-tab-panel-header {
	border: 0px solid !important;
	padding-bottom: 0px !important;
}

.x-panel-tl {
	border-bottom: 0px solid !important;
}
</style>
	<!-- <body>  -->
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
   <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
   <%} %>  
   <style>
	.footer {
		bottom : -8px !important;
	}
   </style>
		<script>
var routeOperationTab;
var flagFDAS = 0;
var globalCustomerID;
var assetNumber;

Ext.onReady(function () {

    Ext.EventManager.onWindowResize(function () {
        var width = screen.width-22;
        var height = 550;

        routeOperationTab.setSize(width, height);
        routeOperationTab.doLayout();
    });

    routeOperationTab = new Ext.TabPanel({
        resizeTabs: false, 
        enableTabScroll: true,
        activeTab: 'routeOperationId',
        width: screen.width-22,
        height:535,
        listeners: {
            tabchange: function (tp, newTab, currentTab) {
                var activeTab = routeOperationTab.getActiveTab();
                var activeTabIndex = routeOperationTab.items.findIndex('id', activeTab.id);
                switch (activeTabIndex) {
                case 1:
                    Ext.getCmp('routeCreationId').update("<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/Common/RouteCreation.jsp'></iframe>");
                    break;
                }
            }
        },
        defaults: {
            autoScroll: false
        }
    });
    addTab();

    function addTab() {
        routeOperationTab.add({

            title: 'Route Details',
            iconCls: 'admintab',
            id: 'routeOperationId',
            html: "<iframe style='width:101%;height:530px;border:0;'src='<%=path%>/Jsps/Common/RouteOperation.jsp'></iframe>"

        }).show();

        routeOperationTab.add({

            title: 'Route Creation',
            iconCls: 'admintab',
            id: 'routeCreationId',
            html: "<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/Common/RouteCreation.jsp'></iframe>"

        }).show();
        
         routeOperationTab.add({

            title: 'Check Point Creation',
            iconCls: 'admintab',
            id: 'checkPointCreationId',
            html: "<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/NTC/NTCTCheckPointDetails.jsp'></iframe>"

        }).show();
       Ext.getCmp('routeCreationId').disable(true);
    }
    routeOperationTab.render('admindiv');
});

		</script>
	<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 
<%
	}
%>
