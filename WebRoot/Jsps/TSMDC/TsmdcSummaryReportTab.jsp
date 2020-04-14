<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int countryId = loginInfo.getCountryCode();
    CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}	
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Summary Report</title>		
    
  <style>
  	.x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.selectstylePerfect1 {
				height: 20px;
				width: 180px !important;
				listwidth: 120px !important;
				max-listwidth: 120px !important;
				min-listwidth: 120px !important;
				margin: 0px 0px 5px 5px !important;
			}
		</style>
	 <%}%>	
   <script>
	var test;
   	Ext.onReady(function() {

    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'center';
    var test = new Ext.TabPanel({
            resizeTabs: true, // turn on tab resizing
            enableTabScroll: false,
            width: screen.width - 22,
            height: 550,
            renderTo: 'content',
            layoutOnTabChange: true,
            reloadOnTabChange : true,
            activeTab:0,
        	listeners: {
        	'tabchange': function() {
        		var activeTab = test.getActiveTab();
	    		var activeTabIndex = test.items.findIndex('id', activeTab.id);
	    		switch(activeTabIndex){
	    			case 0: Ext.getCmp('weightReportId').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/TSMDC/WeighBridgeViolationReport.jsp'></iframe>");break;
	    		//	case 1: Ext.getCmp('orderDetailsReportId').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/TSMDC/OrderDetailsReport.jsp'></iframe>");break;
             	//	case 2: Ext.getCmp('transitPassReportId').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/TSMDC/TransitPermitViolationReport.jsp'></iframe>");break;
	    	     
	    	}
        	}
			}
        }),

        sb = Ext.getCmp('form-statusbar');


    var index = 0;
    var tab;

    addTab();

    function addTab() {

/*
        test.add({
            id: 'orderDetailsReportId',
            title: "Order Details Report",
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/TSMDC/OrderDetailsReport.jsp'></iframe>"
                
        }).show();

        test.add({
            id: 'transitPassReportId',
            title: 'Transit Pass Report',
          
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/TSMDC/TransitPermitViolationReport.jsp'></iframe>"

        }); */
        test.add({
            id: 'weightReportId',
            title: 'Weight Pass Report',
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/TSMDC/WeighBridgeViolationReport.jsp'></iframe>"

        }).show();
    }
});

   </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
