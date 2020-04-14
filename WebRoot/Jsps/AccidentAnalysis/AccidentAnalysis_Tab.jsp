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
		tobeConverted.add("Case_Information");
		tobeConverted.add("Compensation_Information");

		ArrayList<String> convertedWords = new ArrayList<String>();
		String language = loginInfo.getLanguage();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted, language);
		String AccidentCaseInfo = convertedWords.get(0);
		String AccidentCompensationInfo = convertedWords.get(1);
%>
<jsp:include page="../Common/header.jsp" />
	<title>Accidental Analysis Tab</title>
	<style>
.x-tab-panel-header {
	border: 0px solid !important;
	padding-bottom: 0px !important;
}

.x-panel-tl {
	border-bottom: 0px solid !important;
}
div#ext-comp-1053 {
	width: 1308px !important;
}
.footer {
			bottom : -2px !important;
		}
</style>
	
	    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/MenuTabJS.jsp" /><%} %>
		
		<script>
var AccidentAnalysisTab;

var flagAccidentAnalysis = 0;
var globalCustomerID = "";
var caseInfoCaseNumber = "";
var caseInfoVehicleNumber = "";

Ext.onReady(function () {

    Ext.EventManager.onWindowResize(function () {
        var width = '100%';
        var height = '100%';

        AccidentAnalysisTab.setSize(width, height);
        AccidentAnalysisTab.doLayout();
    });

    AccidentAnalysisTab = new Ext.TabPanel({
        resizeTabs: false, // turn off tab resizing
        enableTabScroll: true,
        activeTab: 'AccidentAnalysisCasetabId',
        width: '100%',
        height:555,
        listeners: {
            tabchange: function (tp, newTab, currentTab) {
                var activeTab = AccidentAnalysisTab.getActiveTab();
                var activeTabIndex = AccidentAnalysisTab.items.findIndex('id', activeTab.id);
                switch (activeTabIndex) {
                //case 0:
                //    Ext.getCmp('AccidentAnalysisCasetabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentCaseInfo.jsp'></iframe>");
                //    break;
                case 1:
                    Ext.getCmp('AccidentAnalysisCompensationtabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentCompensationInfo.jsp'></iframe>");
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
        AccidentAnalysisTab.add({

            title: '<%=AccidentCaseInfo%>',
            iconCls: 'admintab',
            id: 'AccidentAnalysisCasetabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentCaseInfo.jsp'></iframe>"

        }).show();

        AccidentAnalysisTab.add({

            title: '<%=AccidentCompensationInfo%>',
            iconCls: 'admintab',
            id: 'AccidentAnalysisCompensationtabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentCompensationInfo.jsp'></iframe>"

        }).show();
        Ext.getCmp('AccidentAnalysisCompensationtabId').disable(true);
    }
    AccidentAnalysisTab.render('admindiv');
});

		</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%
	}
%>