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
		tobeConverted.add("Accident_Expenditure_Summary");
		tobeConverted.add("Accident_Expenditure_Details");

		ArrayList<String> convertedWords = new ArrayList<String>();
		String language = loginInfo.getLanguage();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted, language);
		
		String AccidentExpenditureSummary = convertedWords.get(0);
		String AccidentExpenditureDetails = convertedWords.get(1);
%>
<jsp:include page="../Common/header.jsp" />
	<title>Accidental Expenditure Reports</title>
	<style>
.x-tab-panel-header {
	border: 0px solid !important;
	padding-bottom: 0px !important;
}

.x-panel-tl {
	border-bottom: 0px solid !important;
}

.footer {
			bottom : -5px !important;
		}	
		
</style>
	
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/MenuTabJS.jsp" /><%} %>
		
		
		<script>
var AccidentAnalysisReportTab;

var flagAccidentAnalysisReport = 0;
var globalCustomerID = "";
var globalCustomerName = "";
var assetNumber;

Ext.onReady(function () {

    Ext.EventManager.onWindowResize(function () {
        var width = '100%';
        var height = '100%';

        AccidentAnalysisReportTab.setSize(width, height);
        AccidentAnalysisReportTab.doLayout();
    });

    AccidentAnalysisReportTab = new Ext.TabPanel({
        resizeTabs: false, // turn off tab resizing
        enableTabScroll: true,
        activeTab: 'AccidentExpenditureSummaryId',
        width: '100%',
        height:555,
        listeners: {
            tabchange: function (tp, newTab, currentTab) {
                var activeTab = AccidentAnalysisReportTab.getActiveTab();
                var activeTabIndex = AccidentAnalysisReportTab.items.findIndex('id', activeTab.id);
                switch (activeTabIndex) {
                //case 0:
                //    Ext.getCmp('AccidentAnalysisCasetabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentExpenditureSummary.jsp'></iframe>");
                //    break;
                case 1:
                    Ext.getCmp('AccidentExpenditureDetailsId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentExpenditureDetails.jsp'></iframe>");
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
        AccidentAnalysisReportTab.add({

            title: '<%=AccidentExpenditureSummary%>',
            iconCls: 'admintab',
            id: 'AccidentExpenditureSummaryId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentExpenditureSummary.jsp'></iframe>"

        }).show();

        AccidentAnalysisReportTab.add({

            title: '<%=AccidentExpenditureDetails%>',
            iconCls: 'admintab',
            id: 'AccidentExpenditureDetailsId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentExpenditureDetails.jsp'></iframe>"

        }).show();
        Ext.getCmp('AccidentExpenditureDetailsId').disable(true);
    }
    AccidentAnalysisReportTab.render('admindiv');
});

		</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%
	}
%>