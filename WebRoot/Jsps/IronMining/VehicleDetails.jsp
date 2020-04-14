<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer");
tobeConverted.add("Vehicle_No");
tobeConverted.add("select_vehicle_No");	
tobeConverted.add("Please_Select_customer");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String CustomerName=convertedWords.get(0);
String SelectCustomer=convertedWords.get(1);
String VehicleNo=convertedWords.get(2);
String SelectVehicleNo=convertedWords.get(3);
String PleaseSelectCustomer=convertedWords.get(4);

%>

<jsp:include page="../Common/header.jsp" />
		
		<base href="<%=basePath%>">
		<title>Vehicle Details</title>

<style>
   .x-panel-tl {
       border-bottom: 0px solid !important;
   }
   
   .labelsize {
	spacing: 10px;
	height: 20px;
	width: 150 px !important;
	min-width: 150px !important;
	margin-bottom: 5px !important;
	margin-left: 5px !important;
	font-size: 12px;
	font-family: sans-serif;
	font-weight:bold;
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
		</style>
	 <%}%>
   
<script>
 var enrollStatus ="";
  var clientcombostore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
     id: 'CustomerStoreId',
     root: 'CustomerRoot',
     autoLoad:true,
     remoteSort: true,
     fields: ['CustId', 'CustName'],
     listeners: {
         load: function(custstore, records, success, options) {
             if (<%= customerId %> > 0) {
                 Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                 custId = Ext.getCmp('custcomboId').getValue();
                 VehicleStore.load({
                     params: {
                         custId: Ext.getCmp('custcomboId').getValue()
                     }
                 });
                     
             }
         }
     }
 });
 var VehicleStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/VehicleStatusAction.do?param=getVehicleDetails',
     id: 'VehicleId',
     root: 'VehicleRoot',
     autoLoad: true,
     remoteSort: true,
     fields: ['VehicleNo', 'VTS_Installed', 'Vehicle_Status', 'Communicating_Status', 'Enrollment_Status', 'Overspeed_Debarring','pucExpDate',
     	'incExpDate','roadTaxValidityDate','permitValidityDate','trip_status']
 });

 var Vehicle = new Ext.form.ComboBox({
     store: VehicleStore,
     id: 'VehiclecomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectVehicleNo%>',
     blankText: '<%=SelectVehicleNo%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'VehicleNo',
     displayField: 'VehicleNo',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function() {
            		  Ext.getCmp('updateReport').hide();
                      Ext.getCmp('vtsinstalledId').setText("");
                      Ext.getCmp('statusId').setText("");
                      Ext.getCmp('comnoncomId').setText("");
                      Ext.getCmp('enrollmentId').setText("");
                      Ext.getCmp('OverspeedId').setText("");
                      Ext.getCmp('lasttripId').setText("");
                      Ext.getCmp('lastTripTimeId').setText("");
                      Ext.getCmp('tareweightId').setText("");
                      
                      Ext.getCmp('overspeedAlertId').setText("");
                      Ext.getCmp('internalBatteryAlertId').setText("");
                      Ext.getCmp('mainPowerAlertId').setText("");
                      Ext.getCmp('vehiclenonCommId').setText("");
                      Ext.getCmp('mainPowerAlertId').setText("");
                      Ext.getCmp('internalBatteryAlertId').setText("");
                      Ext.getCmp('permitValDateId').setText("");
                      Ext.getCmp('pucExpiryId').setText("");
                      Ext.getCmp('insuranceExpId').setText("");
                      Ext.getCmp('roadTaxDateId').setText("");
                      
                    }
         }
     }
 });
 var Client = new Ext.form.ComboBox({
     store: clientcombostore,
     id: 'custcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectCustomer%>',
     blankText: '<%=SelectCustomer%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'CustId',
     displayField: 'CustName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function() {
                 VehicleStore.load({
                     params: {
                         custId: Ext.getCmp('custcomboId').getValue()
                     }
                 });
                     Ext.getCmp('VehiclecomboId').reset();
                     Ext.getCmp('vtsinstalledId').setText("");
                     Ext.getCmp('statusId').setText("");
                     Ext.getCmp('comnoncomId').setText("");
                     Ext.getCmp('enrollmentId').setText("");
                     Ext.getCmp('OverspeedId').setText("");
                     Ext.getCmp('lasttripId').setText("");
                     Ext.getCmp('lastTripTimeId').setText("");
                     Ext.getCmp('tareweightId').setText("");
                     
                     Ext.getCmp('overspeedAlertId').setText("");
                      Ext.getCmp('internalBatteryAlertId').setText("");
                      Ext.getCmp('mainPowerAlertId').setText("");
                      Ext.getCmp('vehiclenonCommId').setText("");
                      Ext.getCmp('mainPowerAlertId').setText("");
                      Ext.getCmp('internalBatteryAlertId').setText("");
                      Ext.getCmp('permitValDateId').setText("");
                      Ext.getCmp('pucExpiryId').setText("");
                      Ext.getCmp('insuranceExpId').setText("");
                      Ext.getCmp('roadTaxDateId').setText("");
             }
         }
     }
 });

 var VehicleInformationStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/VehicleStatusAction.do?param=getVehicleInformation',
     id: 'VehicleDetailsId',
     root: 'VehicleDetailsRoot',
     autoLoad: true,
     remoteSort: true,
     fields: ['Last_Trip_No_and_Status', 'Tare_weight', 'Last_Trip_Issued_Time','nonCommunication','mainPower','internalBattery','overSpeed','status']
 });


 /************************************************************ Panels ********************************************************************/
 var innerPanel1 = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'innerPanel1Id',
     layout: 'table',
     layoutConfig: {
         columns: 10
     },
     frame: false,
     width: 3000,
     height: 40,
     items: [{
         xtype: 'label',
         text: '<%=CustomerName%>' + ':',
         cls: 'labelstyle'
     }, Client, {
         width: 10
     }, {
         xtype: 'label',
         text: '<%=VehicleNo%>' + ':',
         cls: 'labelstyle'
     }, Vehicle, {
         width: 10
     }, {
         xtype: 'button',
         text: 'View',
         id: 'generateReport',
         cls: 'buttonwastemanagement',
         width: 80,
         listeners: {
             click: {
                 fn: function() {
                     if (Ext.getCmp('custcomboId').getValue() == "") {
                         Ext.example.msg("<%=SelectCustomer%>");
                         Ext.getCmp('custcomboId').focus();
                         return;
                     }

                     if (Ext.getCmp('VehiclecomboId').getValue() == "") {
                         Ext.example.msg("<%=SelectVehicleNo%>");
                         Ext.getCmp('VehiclecomboId').focus();
                         return;
                     }
                     var vehicleNo = Ext.getCmp('VehiclecomboId').getValue();
                     var row = VehicleStore.findExact('VehicleNo', vehicleNo);
                     var rec = VehicleStore.getAt(row);
                     enrollStatus = rec.data['trip_status'];
                     var VehicleStatus ="";
                     Ext.getCmp('vtsinstalledId').setText(rec.data['VTS_Installed']);
                     Ext.getCmp('statusId').setText(rec.data['Vehicle_Status']);
                     Ext.getCmp('comnoncomId').setText(rec.data['Communicating_Status']);
                     Ext.getCmp('enrollmentId').setText(rec.data['Enrollment_Status']+'('+rec.data['trip_status']+')');
                     Ext.getCmp('OverspeedId').setText(rec.data['Overspeed_Debarring']);
                     Ext.getCmp('pucExpiryId').setText(rec.data['pucExpDate']);
                     Ext.getCmp('insuranceExpId').setText(rec.data['incExpDate']);
                     Ext.getCmp('roadTaxDateId').setText(rec.data['roadTaxValidityDate']);
                     Ext.getCmp('permitValDateId').setText(rec.data['permitValidityDate']);
                     VehicleInformationStore.load({
                         params: {
                             vehicleNo: Ext.getCmp('VehiclecomboId').getValue(),
                             custId: Ext.getCmp('custcomboId').getValue()
                         },
                         callback: function() {
                             var rec1 = VehicleInformationStore.getAt(VehicleInformationStore.getCount()-1);
                             Ext.getCmp('lasttripId').setText(rec1.data['Last_Trip_No_and_Status']);
                             Ext.getCmp('tareweightId').setText(rec1.data['Tare_weight']);
							 Ext.getCmp('lastTripTimeId').setText(rec1.data['Last_Trip_Issued_Time']);
							 Ext.getCmp('vehiclenonCommId').setText(rec1.data['nonCommunication']);
							 Ext.getCmp('mainPowerAlertId').setText(rec1.data['mainPower']);
							 Ext.getCmp('internalBatteryAlertId').setText(rec1.data['internalBattery']);
							 Ext.getCmp('overspeedAlertId').setText(rec1.data['overSpeed']);
							 VehicleStatus=rec1.data['status'];				  
							  if(enrollStatus!="" && VehicleStatus!=""){
							  	if(VehicleStatus != enrollStatus){
							  		Ext.getCmp('updateReport').show();
							  	}
							  }
							  
                         }
                     });
                                         
                 }
             }
         }
     }, {
         width: 10
     },
     {
         xtype: 'button',
         text: 'Update Enrollment',
         id: 'updateReport',
         hidden:true,
         cls: 'buttonwastemanagement',
         width: 80,
         listeners: {
             click: {
                 fn: function() {	
                  mainPanel.getEl().mask();
                  Ext.Ajax.request({
	                    url: '<%=request.getContextPath()%>/VehicleStatusAction.do?param=UpdateEnroll',
	                    method: 'POST',
	                    params: {
	                        VehicleNo: Ext.getCmp('VehiclecomboId').getValue(),
	                        EnrolledStatus : enrollStatus
	                   		 },
		                    success: function (response, options) {
		                     Ext.example.msg("Updated successfully");
		                     VehicleStore.reload();
		                    Ext.getCmp('updateReport').hide();
		                     Ext.getCmp('VehiclecomboId').reset();
		                     Ext.getCmp('vtsinstalledId').setText("");
		                     Ext.getCmp('statusId').setText("");
		                     Ext.getCmp('comnoncomId').setText("");
		                     Ext.getCmp('enrollmentId').setText("");
		                     Ext.getCmp('OverspeedId').setText("");
		                     Ext.getCmp('lasttripId').setText("");
		                     Ext.getCmp('lastTripTimeId').setText("");
		                     Ext.getCmp('tareweightId').setText("");
		                     
		                      Ext.getCmp('overspeedAlertId').setText("");
		                      Ext.getCmp('internalBatteryAlertId').setText("");
		                      Ext.getCmp('mainPowerAlertId').setText("");
		                      Ext.getCmp('vehiclenonCommId').setText("");
		                      Ext.getCmp('mainPowerAlertId').setText("");
		                      Ext.getCmp('internalBatteryAlertId').setText("");
		                      Ext.getCmp('permitValDateId').setText("");
		                      Ext.getCmp('pucExpiryId').setText("");
		                      Ext.getCmp('insuranceExpId').setText("");
		                      Ext.getCmp('roadTaxDateId').setText("");
		                       mainPanel.getEl().unmask();
		                     }, // end of success
		                    failure: function () {
		                    VehicleStore.reload();
		                      Ext.example.msg("Retry!!");
		                        Ext.getCmp('updateReport').hide();
		                       Ext.getCmp('VehiclecomboId').reset();
		                     Ext.getCmp('vtsinstalledId').setText("");
		                     Ext.getCmp('statusId').setText("");
		                     Ext.getCmp('comnoncomId').setText("");
		                     Ext.getCmp('enrollmentId').setText("");
		                     Ext.getCmp('OverspeedId').setText("");
		                     Ext.getCmp('lasttripId').setText("");
		                     Ext.getCmp('lastTripTimeId').setText("");
		                     Ext.getCmp('tareweightId').setText("");
		                     
		                      Ext.getCmp('overspeedAlertId').setText("");
		                      Ext.getCmp('internalBatteryAlertId').setText("");
		                      Ext.getCmp('mainPowerAlertId').setText("");
		                      Ext.getCmp('vehiclenonCommId').setText("");
		                      Ext.getCmp('mainPowerAlertId').setText("");
		                      Ext.getCmp('internalBatteryAlertId').setText("");
		                      Ext.getCmp('permitValDateId').setText("");
		                      Ext.getCmp('pucExpiryId').setText("");
		                      Ext.getCmp('insuranceExpId').setText("");
		                      Ext.getCmp('roadTaxDateId').setText("");
		                       mainPanel.getEl().unmask();
	                		 } // end of failure
	                		 
	                		
	               		 });
                		 }
                	 }
                	 }
                 }]
 });

 var innerPanel2 = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'innerPanel2Id',
     layout: 'table',
     layoutConfig: {
         columns: 6
     },
     frame: false,
     width: 1500,
     height: 350,
     items: [{
             xtype: 'label',
             width: 100,
             text: 'VTS Installed' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'vtsinstalledId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             text: 'Vehicle Status' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'statusId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             text: 'Communicating Status' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'comnoncomId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         }, {
             xtype: 'label',
             text: 'Enrollment Staus' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'enrollmentId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             text: 'Last Trip sheet No and Status' + ':',
             cls: 'labelstyle',
             columns: 2
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'lasttripId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         }, {
             xtype: 'label',
             text: 'Last Trip Sheet Issued Time' + ':',
             cls: 'labelstyle',
             columns: 2
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'lastTripTimeId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         }, {
             xtype: 'label',
             width: 100,
             text: 'Tare weight' + ':',
             cls: 'labelstyle',

         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'tareweightId',
             mode: 'local'
         }, {
             height: 50,
             width: 100
         }, {
             xtype: 'label',
             width: 100,
             hidden:true,
             text: 'Overspeed Debarring' + ':',
             cls: 'labelstyle'
         }, {
             xtype: 'label',
             cls: 'labelsize',
             hidden:true,
             id: 'OverspeedId',
             mode: 'local'
         },{
             height: 30,
             width: 100
         }, 
         {
             xtype: 'label',
             width: 100,
             text: 'PUC Expiry Date' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'pucExpiryId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'Insurance Expiry Date' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'insuranceExpId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'RoadTax Validity Date' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'roadTaxDateId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'Permit Valididty Date' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'permitValDateId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'Vehicle NonComm Alert' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'vehiclenonCommId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'Main Power ON/OFF Alert' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'mainPowerAlertId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'Internal Battery Alert' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'internalBatteryAlertId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         },
         {
             xtype: 'label',
             width: 100,
             text: 'OverSpeed Alert' + ':',
             cls: 'labelstyle',
         }, {
             xtype: 'label',
             cls: 'labelsize',
             id: 'overspeedAlertId',
             mode: 'local'
         }, {
             height: 30,
             width: 100
         }]
 });

 var innerPanel = new Ext.Panel({
     title: 'Vehicle Details',
     standardSubmit: true,
     collapsible: false,
     id: 'innerPanelId',
     layout: 'table',
     layoutConfig: {
         columns: 1
     },
     frame: true,
     width: 900,
     height: 360,
     items: [innerPanel1, innerPanel2]
 });
 var mainPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'mainPanelId',
     layout: 'table',
     frame: false,
     width: '100%',
     height: 480,
     layoutConfig: {
         columns: 3,
     },
     items: [{
         width: 150
     }, innerPanel]
 });
 Ext.onReady(function() {
     ctsb = tsb;
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         title: '',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         width: screen.width - 38,
         height: 540,
         layout: 'table',
         layoutConfig: {
             columns: 1
         },
         items: [mainPanel]
     });
     sb = Ext.getCmp('form-statusbar');

 });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>