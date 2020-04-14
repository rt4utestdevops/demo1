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

<!DOCTYPE HTML>
<html>
 <head>
 		<title>CVS Summary Report</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.x-tab-strip-inner
	{
		width: 135px !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script> 
   <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
   
<script>
	var test;
   	Ext.onReady(function() {

    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'center';
    var test = new Ext.TabPanel({
            resizeTabs: true, // turn on tab resizing
            enableTabScroll: true,
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
	    			case 0: Ext.getCmp('atmReplenishmentReportid').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/AtmReplenishmentReport.jsp'></iframe>");break;
             		case 1: Ext.getCmp('tripOperationReportid').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/TripOperationReport.jsp'></iframe>");break;
             		case 2: Ext.getCmp('quotationReportid').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/QuotationReport.jsp'></iframe>");break;
	    			case 3: Ext.getCmp('armoryReportid').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/ArmoryOperationReport.jsp'></iframe>");break;	    			
	    			case 4: Ext.getCmp('vaultLedgerId').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/VaultLedger.jsp'></iframe>");break;
	    			case 5: Ext.getCmp('customerwiseReportid').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/CustomerWiseReport.jsp'></iframe>");break;
	    			case 6: Ext.getCmp('vehiclewiseReportid').update("<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/VehicleWiseReport.jsp'></iframe>");break;
	    			
	    	}
        	}
			}
        }),

        sb = Ext.getCmp('form-statusbar');


    var index = 0;
    var tab;

    addTab();

    function addTab() {


        test.add({
            id: 'atmReplenishmentReportid',
            title: "ATM Replenishment Report",
   
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/AtmReplenishmentReport.jsp'></iframe>"
                
        }).show();

        test.add({
            id: 'tripOperationReportid',
            title: 'Trip Operation Report',
          
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/TripOperationReport.jsp'></iframe>"

        });
        test.add({
            id: 'quotationReportid',
            title: 'Quotation Report',
          
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/QuotationReport.jsp'></iframe>"

        });
		test.add({
            id: 'armoryReportid',
            title: 'Armory Report',
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/ArmoryOperationReport.jsp'></iframe>"
        });
            test.add({
            id: 'vaultLedgerId',
            title: 'Vault Ledger Report',
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/VaultLedger.jsp'></iframe>"
        });
        test.add({
            id: 'customerwiseReportid',
            title: 'Customer Wise Report',
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/CustomerWiseReport.jsp'></iframe>"
        });
          test.add({
            id: 'vehiclewiseReportid',
            title: 'Vehicle Wise Report',
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/VehicleWiseReport.jsp'></iframe>"
        });
    }
});

</script>
	</body>
</html>
