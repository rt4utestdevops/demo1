<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
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
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}

LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("SLNO");
tobeConverted.add("Asset_Number");
tobeConverted.add("Service_Name");
tobeConverted.add("Remarks");
tobeConverted.add("Last_Service_Date");

tobeConverted.add("Enter_Task_Name");
tobeConverted.add("Enter_Remarks");
tobeConverted.add("Enter_Last_Service_Date");

tobeConverted.add("Renew");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Expire_Soon");
tobeConverted.add("Select_Customer");
tobeConverted.add("Renewal_By");
tobeConverted.add("Due_Days");
tobeConverted.add("Due_Mileage");
tobeConverted.add("Task_Id");
tobeConverted.add("Event_Date");
tobeConverted.add("Expiry_Renew");
tobeConverted.add("Due_For_Renewal_Information");
tobeConverted.add("Due_For_Renewal_Details");
tobeConverted.add("Last_Service_Date_Should_Be_Greater_Than_Event_Date");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String AssetNumber=convertedWords.get(1);
String ServiceName=convertedWords.get(2);
String Remarks=convertedWords.get(3);
String LastServiceDate=convertedWords.get(4);

String EnterTaskName=convertedWords.get(5);
String EnterRemarks=convertedWords.get(6);
String EnterLastServiceDate=convertedWords.get(7);

String Renew=convertedWords.get(8);
String Save=convertedWords.get(9);
String Cancel=convertedWords.get(10);
String ClearFilterData=convertedWords.get(11);
String NoRowsSelected=convertedWords.get(12);
String SelectSingleRow=convertedWords.get(13);

String ExpireSoon=convertedWords.get(14);
String SelectCustomer=convertedWords.get(15);
String RenewalBy=convertedWords.get(16);
String DueDays=convertedWords.get(17);
String DueMileage=convertedWords.get(18);
String TaskId=convertedWords.get(19);
String EventDate=convertedWords.get(20);
String ExpiryRenew=convertedWords.get(21);
String DueForRenewalInformation=convertedWords.get(22);
String DueForRenewalDetails=convertedWords.get(23);
String LastServiceDateShouldBeGreaterThanEventDate=convertedWords.get(24);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title><%=ExpireSoon%></title>
	</head>
	<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
</style>
	<body onload="bdLd()">
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<script>
   
 var outerPanel;
 var ctsb;
 var jspName = "Expiring Soon";
 var exportDataType = "int,string,string,date,string,int,int";
 var selected;
 var grid;
 var buttonValue;
 var titelForInnerPanel;
 var myWin;
 var dtcur = dtcur;
 var assetNumber = parent.globalAssetNumber;
 var assetId = parent.globalAssetId;
 var customerId = parent.custId;
 var systemId = <%=systemid%>;
 var innerPanelExpiringSoonDetails = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     height: 180,
     width: 410,
     frame: true,
     id: 'custMaster',
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     items: [{
         xtype: 'fieldset',
         title: '<%=DueForRenewalInformation%>',
         cls: 'fieldsetpanel',
         collapsible: false,
         colspan: 3,
         id: 'addpanelid',
         width: 390,
         layout: 'table',
         layoutConfig: {
             columns: 4
         },
         items: [{
             xtype: 'label',
             text: '',
             cls: 'mandatoryfieldLastServiceDateId'
         },{
             xtype: 'label',
             text: '<%=LastServiceDate%>' + ' :',
             cls: 'labelstyle',
             id: 'lastServiceDateTxtId'
         },  {
             xtype: 'datefield',
             cls: 'selectstylePerfect',
             id: 'lastServiceDateId',
             format: getDateFormat(),
             allowBlank: false,
             blankText: '<%=EnterLastServiceDate%>',
             labelSeparator: '',
             allowBlank: false
         }, {
             xtype: 'label',
             text: '',
             cls: 'mandatoryfieldLastServiceDateId1'
         },{
             xtype: 'label',
             text: '',
             cls: 'selectstylePerfect',
             id: 'mandatoryr'
         }, {
             xtype: 'label',
             text: '<%=Remarks%>' + ' :',
             cls: 'labelstyle',
             id: 'rem2txt'
         },  {
             xtype: 'textarea',
             regex: validate('name'),
             emptyText: '<%=Remarks%>',
             id: 'remarksId',
             allowBlank: false,
             regexText: 'Entered Remarks Should Be In Albhates Only',
             blankText: '<%=Remarks%>',
             cls: 'selectstylePerfect'

         }, {
             xtype: 'label',
             text: '',
             cls: 'mandatoryfield',
             id: 'mandatorys'
         }]
     }]
 });

 var innerExpiringSoonWinButtonPanel = new Ext.Panel({
     id: 'winbuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 60,
     width: 400,
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: 'Save',
         id: 'addButtId',
         iconCls: 'savebutton',
         cls: 'buttonstyle',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     if (Ext.getCmp('lastServiceDateId').getValue() == "") {
                         Ext.example.msg("<%=EnterLastServiceDate%>");
                         Ext.getCmp('lastServiceDateId').focus();
                         return;
                     }
                     var records = grid.getSelectionModel().getSelected();
                     var Dt3 = Ext.getCmp('lastServiceDateId').getValue();
                     var Dt4 = Date.parseDate(records.get('lastServiceDateDataIndex'), "d-m-Y");
                     //alert(Dt3);
                     //alert(Dt4);
                     if (dateCompare(Dt3, Dt4) == 1) {
                         Ext.example.msg("<%=LastServiceDateShouldBeGreaterThanEventDate%>");
                         return;
                     }
                     if (innerPanelExpiringSoonDetails.getForm().isValid()) {
                         var id;
                         if (buttonValue == 'ExpiryRenew') {
                             var selected = grid.getSelectionModel().getSelected();
                             id = selected.get('id');
                         }
                         //alert('Hello')
                         manageDetailsOuterPanelWindow.getEl().mask();
                         Ext.Ajax.request({
                             url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=saveExpiringSoonDetails',
                             method: 'POST',
                             params: {
                                 buttonValue: buttonValue,
                                 taskId: selected.get('taskIdDataIndex'),
                                 CustId: customerId,
                                 assetNumber: assetNumber,
                                 lastServiceDate: Ext.getCmp('lastServiceDateId').getValue(),
                                 Remarks: Ext.getCmp('remarksId').getValue(),
                                 id: id,
                                 jspName: jspName
                             },
                             success: function (response, options) {
                                 var message = response.responseText;
                                 Ext.example.msg(message);
                                 Ext.getCmp('lastServiceDateId').reset();
                                 Ext.getCmp('remarksId').reset();

                                 myWin.hide();
                                 expiringSoonStore.reload();
                                 manageDetailsOuterPanelWindow.getEl().unmask();
                             },
                             failure: function () {
                                 Ext.example.msg("Error");
                                 expiringSoonStore.reload();
                                 myWin.hide();
                             }
                         });
                     }
                 }
             }
         }
     }, {
         xtype: 'button',
         text: '<%=Cancel%>',
         id: 'canButtId',
         cls: 'buttonstyle',
         iconCls: 'cancelbutton',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     myWin.hide();
                 }
             }
         }
     }]
 });

 function bdLd() {
     expiringSoonStore.load({
         params: {
             CustId: customerId,
             assetNumber: assetNumber,
             jspName: jspName
         }
     });
 }

 var manageDetailsOuterPanelWindow = new Ext.Panel({
     height: 260,
     width: 400,
     standardSubmit: true,
     frame: false,
     items: [innerPanelExpiringSoonDetails, innerExpiringSoonWinButtonPanel]
 });

 myWin = new Ext.Window({
     title: titelForInnerPanel,
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 280,
     width: 420,
     id: 'myWin',
     items: [manageDetailsOuterPanelWindow]
 });

 function addRecord() {
     if (grid.getSelectionModel().getCount() == 0) {
         Ext.example.msg("<%=NoRowsSelected%>");
         return;
     }
     if (grid.getSelectionModel().getCount() > 1) {
         Ext.example.msg("<%=SelectSingleRow%>");
         return;
     }
     buttonValue = 'ExpiryRenew';
     titelForInnerPanel = '<%=DueForRenewalDetails%>';
     myWin.setPosition(220, 50);
     myWin.show();
     myWin.setTitle(titelForInnerPanel);

     var selected = grid.getSelectionModel().getSelected();
     Ext.getCmp('lastServiceDateId').setValue(selected.get('lastServiceDateDataIndex'));
 }
 var reader = new Ext.data.JsonReader({
     idProperty: 'taskMasterid',
     root: 'expiringSoonRoot',
     totalProperty: 'total',
     fields: [{
         name: 'slnoIndex'
     }, {
         name: 'assetDataIndex'
     }, {
         name: 'taskNameIndex'
     }, {
         name: 'lastServiceDateDataIndex'
     },{
         name: 'ServiceDateDataIndex'
     }, {
         name: 'remarksDataIndex'
     }, {
         name: 'eventParamDataIndex'
     }, {
         name: 'taskIdDataIndex'
     }, {
         name: 'eventDateDataIndex'
     }, {
         name: 'dueDaysDataIndex'
     }, {
         name: 'dueMileageDataIndex'
     }]
 });

 var expiringSoonStore = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getExpiringSoonDetails',
         method: 'POST'
     }),
     storeId: 'taskMasterid',
     reader: reader
 });

 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         type: 'numeric',
         dataIndex: 'slnoIndex'
     }, {
         type: 'string',
         dataIndex: 'assetDataIndex'
     }, {
         type: 'string',
         dataIndex: 'taskNameIndex'
     }, {
         type: 'date',
         dataIndex: 'lastServiceDateDataIndex'
     },{
         type: 'date',
         dataIndex: 'ServiceDateDataIndex'
     }, {
         type: 'string',
         dataIndex: 'eventParamDataIndex'
     }, {
         type: 'date',
         dataIndex: 'eventDateDataIndex'
     }, {
         type: 'int',
         dataIndex: 'dueDaysDataIndex'
     }, {
         type: 'int',
         dataIndex: 'dueMileageDataIndex'
     }]
 });

 var createColModel = function (finish, start) {      
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 50
         }), {
             dataIndex: 'slnoIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             filter: {
                 type: 'numeric'
             }
         }, {
             header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
             dataIndex: 'assetDataIndex',
             width: 130,
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;><%=ServiceName%></span>",
             dataIndex: 'taskNameIndex',
             width: 130,
             filter: {
                 type: 'string'
             }
         }, {
             dataIndex: 'lastServiceDateDataIndex',
             header: "<span style=font-weight:bold;><%=LastServiceDate%></span>",
             width: 260,
             hidden:true,
             filter: {
                 type: 'date'
             }
         }, {
             dataIndex: 'ServiceDateDataIndex',
             header: "<span style=font-weight:bold;>Service Date</span>",
             width: 260,
             hidden:true,
             filter: {
                 type: 'date'
             }
         },{
             dataIndex: 'taskIdDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=TaskId%></span>",
             filter: {
                 type: 'int'
             }
         }, {
             dataIndex: 'eventParamDataIndex',
             hidden: false,
             header: "<span style=font-weight:bold;><%=RenewalBy%></span>",
             filter: {
                 type: 'string'
             }
         }, {
             dataIndex: 'eventDateDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=EventDate%></span>",
             filter: {
                 type: 'date'
             }
         }, {
             dataIndex: 'dueDaysDataIndex',
             hidden: false,
             header: "<span style=font-weight:bold;><%=DueDays%></span>",
             filter: {
                 type: 'int'
             }
         }, {
             dataIndex: 'dueMileageDataIndex',
             hidden: false,
             decimalPrecision: 2,
             header: "<span style=font-weight:bold;><%=DueMileage%></span>",
             filter: {
                 type: 'int'
             }
         }
     ];
     return new Ext.grid.ColumnModel({
         columns: columns.slice(start || 0, finish),
         defaults: {
             sortable: true
         }
     });
 };

 //*****************************************************************Grid *******************************************************************************
  if(systemId == 266){
 grid = getGrid('', 'NoRecordsFound', expiringSoonStore, screen.width - 360, 360, 12, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=ExpiryRenew%>', false, '', false, '');
 }else{
  grid = getGrid('', 'NoRecordsFound', expiringSoonStore, screen.width - 360, 360, 12, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=ExpiryRenew%>', false, '', false, '');
 }
 //******************************************************************************************************************************************************
 Ext.onReady(function () {
     ctsb = tsb;
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         //title: 'Due for renewal details',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         cls: 'outerpanel',
         layout: 'table',
         layoutConfig: {
             columns: 1
         },
         items: [grid]
         //bbar: ctsb
     });
     sb = Ext.getCmp('form-statusbar');

 });
</script>
	</body>
</html>






