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
 		<title>Quotation Tab</title>		
  
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
   
   <pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script> 
   <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
   <style>
	.footer {
		bottom : -22px !important;
	}
   </style>
<script>

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
            layoutOnTabChange: true
        }),

        sb = Ext.getCmp('form-statusbar');


    var index = 0;
    var tab;

    addTab();

    function addTab() {


        test.add({
            id: 'quotationMaster',
            title: "Create Quotation  ",
   
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/QuotationMaster.jsp'></iframe>"
                
        }).show();

        test.add({
            id: 'quotationMasterHistory',
            title: 'Quotation History  ',
          
            html: "<iframe style='width:100%;height:100%;align:center'; scrolling='no' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/QuotationMasterHistory.jsp'></iframe>"

        });


    }

});

</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
