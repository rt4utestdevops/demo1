<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Asset_Number");
tobeConverted.add("Service_Name");
tobeConverted.add("Mileage_Of_Service");
tobeConverted.add("Days_Of_Service");
tobeConverted.add("Renewal_Mileage_Of_Service");
tobeConverted.add("Renewal_Days_Of_Service");
tobeConverted.add("Last_Service_Date");

tobeConverted.add("Enter_Task_Name");
tobeConverted.add("Enter_Last_Service_Date");

tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Replicate");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Rows_Selected");

tobeConverted.add("Manage_Service_Information");
tobeConverted.add("Add_Manage_Details");
tobeConverted.add("Manage_Details");
tobeConverted.add("Service_Tasks");

tobeConverted.add("Asset_Model");
tobeConverted.add("Select_Customer");

tobeConverted.add("Renewal_Days_of_Service_Cannot_Be_Greater_Than_Days_of_Service");
tobeConverted.add("Renewal_Mileage_of_Service_Cannot_Be_Greater_Than_Mileage_of_Service");
tobeConverted.add("Enter_Mileage_of_Service");
tobeConverted.add("Enter_Days_of_Service");
tobeConverted.add("Select_All");
tobeConverted.add("Task_Id");
tobeConverted.add("Select_Asset_Number");
tobeConverted.add("Manage_Service_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Replicate_Details");
tobeConverted.add("No_Records_Found");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SLNO=convertedWords.get(0);
String AssetNumber=convertedWords.get(1);
String ServiceName=convertedWords.get(2);
String MileageOfService=convertedWords.get(3);
String DaysOfService=convertedWords.get(4);
String RenewalDaysOfService =convertedWords.get(5);
String RenewalMileageofService =convertedWords.get(6);
String LastServiceDate=convertedWords.get(7);

String EnterTaskName=convertedWords.get(8);
String EnterLastServiceDate=convertedWords.get(9);

String Add=convertedWords.get(10);
String Modify=convertedWords.get(11);
String Replicate=convertedWords.get(12);
String Save=convertedWords.get(13);
String Cancel=convertedWords.get(14);
String SelectSingleRow=convertedWords.get(15);
String ClearFilterData=convertedWords.get(16);
String NoRowsSelected=convertedWords.get(17);

String ManageServiceInformation=convertedWords.get(18);
String AddManageDetails=convertedWords.get(19);
String ManageDetails=convertedWords.get(20);
String ServiceTasks=convertedWords.get(21);

String AssetModel=convertedWords.get(22);
String SelectCustomer=convertedWords.get(23);
String RenewalDaysofServiceCannotBeGreaterThanDaysofService=convertedWords.get(24);
String RenewalMileageofServiceCannotBeGreaterThanMileageofService=convertedWords.get(25);
String EnterMileageofService=convertedWords.get(26);
String EnterDaysofService=convertedWords.get(27);
String SelectAll=convertedWords.get(28);
String TaskId=convertedWords.get(29);
String SelectAssetNumber=convertedWords.get(30);
String ManageServiceDetails=convertedWords.get(31);
String NoRecordsFound=convertedWords.get(32);
String ReplicateDetails=convertedWords.get(33);
String NoRecordsfound=convertedWords.get(34);
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title><%=ServiceTasks%></title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body onload="bdLd()">
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
 var outerPanel;
 var ctsb;
 var jspName = "ServiceTasks";
 var exportDataType = "int,string,string,int,int,int,int,int";
 var buttonValue;
 var titelForInnerPanel;
 var myWin;
// var dtcur = datecur;
 var assetNumber = parent.globalAssetNumber;
 var assetId = parent.globalAssetId;
 var customerId = parent.custId;
 var custName = parent.custName;
 
 var taskNamesStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getTaskNameList',
     id: 'taskNameListId',
     root: 'taskNameList',
     autoLoad: true,
     remoteSort: true,
     fields: ['TaskId', 'TaskName', 'Distance', 'Days', 'ThreshouldDistance', 'ThreshouldDays']
 })

 var taskNameCombo = new Ext.form.ComboBox({
     fieldLabel: '',
     frame: true,
     store: taskNamesStore,
     id: 'taskNameComboId',
     cls: 'selectstylePerfect',
     emptyText: '<%=EnterTaskName%>',
     allowBlank: false,
     blankText: '<%=EnterTaskName%>',
     width: 150,
     labelWidth: 100,
     hidden: false,
     forceSelection: true,
     enableKeyEvents: true,
     mode: 'local',
     triggerAction: 'all',
     displayField: 'TaskName',
     valueField: 'TaskId',
     loadingText: 'Searching...',
     emptyText: '',
     minChars: 3,
     listeners: {
         select: {
             fn: function () {
                 var row = taskNamesStore.find('TaskId', Ext.getCmp('taskNameComboId').getValue());
                 var rec = taskNamesStore.getAt(row);
                 Ext.getCmp('distanceId').setValue(rec.data['Distance']);
                 Ext.getCmp('daysId').setValue(rec.data['Days']);
                 Ext.getCmp('threshouldDistanceId').setValue(rec.data['ThreshouldDistance']);
                 Ext.getCmp('threshouldDaysId').setValue(rec.data['ThreshouldDays']);
             }
         },
         specialkey: function (searchid, evnt) {
             if (Ext.EventObject.getKey() == evnt.ENTER) {}
         }
     }
 });




 var innerPanelForManageDetails = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     height: 260,
     width: 460,
     frame: true,
     id: 'custMaster',
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     items: [{
         xtype: 'fieldset',
         title: '<%=ManageServiceInformation%>',
         cls: 'fieldsetpanel',
         collapsible: false,
         colspan: 3,
         id: 'addpanelid',
         width: 440,
         height: 238,
         layout: 'table',
         layoutConfig: {
             columns: 4
         },
         items: [{
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskNameId'
             },{
                 xtype: 'label',
                 text: '<%=ServiceName%>' + ' :',
                 cls: 'labelstyle',
                 id: 'taskNameTxtId'
             }, 
             taskNameCombo, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId1'
             }, {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistanceId'
             }, {
                 xtype: 'label',
                 text: '<%=MileageOfService%>' + ' :',
                 cls: 'labelstyle',
                 id: 'distanceTxtId'
             }, {
                 xtype: 'numberfield',
                 cls: 'selectstylePerfect',
                 emptyText: '<%=EnterMileageofService%>',
                 allowBlank: false,
                 blankText: '<%=EnterMileageofService%>',
                 allowDecimals: false,
                 id: 'distanceId',
                 listeners: {
                     change: function (t, n, o) {
                         if (Ext.getCmp('distanceId').getValue() == "") {
                             Ext.getCmp('distanceId').setValue('<%=0%>');
                         }
                         thersholdDistance = Ext.getCmp('distanceId').getValue('distanceDataIndex') - ((10 / 100) * Ext.getCmp('distanceId').getValue('distanceDataIndex'));
                         if (Ext.getCmp('threshouldDistanceId').getValue('threshouldDistanceDataIndex') != "") {
                             Ext.getCmp('threshouldDistanceId').setValue(thersholdDistance.toFixed(0));
                         } else {
                             Ext.getCmp('threshouldDistanceId').setValue(thersholdDistance.toFixed(0));
                         }
                     }
                 }
             }, {
                 html: '(Kms)',
                 hidden: false,
                 id: 'mandatoryDefaultDistanceId1'
             },{
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatorydaysId'
             },{
                 xtype: 'label',
                 text: '<%=DaysOfService%>' + ' :',
                 cls: 'labelstyle',
                 id: 'daysTxtId'
             },{
                 xtype: 'numberfield',
                 cls: 'selectstylePerfect',
                 allowDecimals: false,
                 emptyText: '<%=EnterDaysofService%>',
                 allowBlank: false,
                 blankText: '<%=EnterDaysofService%>',

                 id: 'daysId',
                 listeners: {
                     change: function (t, n, o) {
                         if (Ext.getCmp('daysId').getValue() == "") {
                             Ext.getCmp('daysId').setValue('<%=0%>');
                         }
                         thersholdDays = Ext.getCmp('daysId').getValue('daysDataIndex') - ((10 / 100) * Ext.getCmp('daysId').getValue('daysDataIndex'));
                         if (Ext.getCmp('threshouldDaysId').getValue('threshouldDaysDataIndex') != "") {
                             Ext.getCmp('threshouldDaysId').setValue(thersholdDays.toFixed(0));
                         } else {
                             Ext.getCmp('threshouldDaysId').setValue(thersholdDays.toFixed(0));
                         }
                     }
                 }
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydaysId1'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryThreshouldDistanceId'
             },  {
                 xtype: 'label',
                 text: '<%=RenewalDaysOfService%>' + ' :',
                 cls: 'labelstyle',
                 id: 'threshouldDistanceTxtId'
             }, {
                 xtype: 'numberfield',
                 cls: 'selectstylePerfect',
                 allowDecimals: false,
                 id: 'threshouldDistanceId',
                 listeners: {
                     change: function (t, n, o) {
                         if (Ext.getCmp('threshouldDistanceId').getValue() == "") {
                             Ext.getCmp('threshouldDistanceId').setValue('<%=0%>');
                         }
                     }
                 }
             }, {
                 html: '(Kms)',
                 hidden: false,
                 id: 'mandatoryThreshouldDistanceId1'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryThreshouldDaysId'
             },{
                 xtype: 'label',
                 text: '<%=RenewalMileageofService %>' + ' :',
                 cls: 'labelstyle',
                 id: 'threshouldDaysTxtId'
             },  {
                 xtype: 'numberfield',
                 cls: 'selectstylePerfect',
                 allowDecimals: false,
                 decimalPrecision: 0,
                 id: 'threshouldDaysId',
                 listeners: {
                     change: function (t, n, o) {
                         if (Ext.getCmp('threshouldDaysId').getValue() == "") {
                             Ext.getCmp('threshouldDaysId').setValue('<%=0%>');
                         }
                     }
                 }
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryThreshouldDaysId1'
             },{
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryfieldLastServiceDateId'
             }, {
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
                 blankText: 'Select Date',
                 labelSeparator: '',
                 maxValue: new Date(),
                 value: datecur
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfieldLastServiceDateId1'
             }
         ]
     }]
 });

 var innerTaskDetailsWinButtonPanel = new Ext.Panel({
     id: 'winbuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 110,
     width: 460,
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: 'Save & Close',
         id: 'addButtId',
         iconCls: 'savebutton',
         cls: 'buttonstyle',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     if (Ext.getCmp('taskNameComboId').getValue() == "") {
                         Ext.example.msg("<%=EnterTaskName%>");
                         Ext.getCmp('taskNameComboId').focus();
                         return;
                     }
                     if (Ext.getCmp('distanceId').getValue() == "") {
                         Ext.example.msg("<%=EnterMileageofService%>");
                         Ext.getCmp('distanceId').focus();
                         return;
                     }
                     if (Ext.getCmp('daysId').getValue() == "") {
                         Ext.example.msg("<%=EnterDaysofService%>");
                         Ext.getCmp('daysId').focus();
                         return;
                     }
                     if (Ext.getCmp('lastServiceDateId').getValue() == "") {
                         Ext.example.msg("<%=EnterLastServiceDate%>");
                         Ext.getCmp('lastServiceDateId').focus();
                         return;
                     }
                     if (Ext.getCmp('daysId').getValue('daysDataIndex') < Ext.getCmp('threshouldDaysId').getValue('daysDataIndex')) {
                         Ext.example.msg("<%=RenewalDaysofServiceCannotBeGreaterThanDaysofService%>");
                         valid = false;
                         return false;
                     }
                     if (Ext.getCmp('distanceId').getValue('distanceDataIndex') < Ext.getCmp('threshouldDistanceId').getValue('threshouldDistanceDataIndex')) {
                         Ext.example.msg("<%=RenewalMileageofServiceCannotBeGreaterThanMileageofService%>");
                         valid = false;
                         return false;
                     }
                     var Days = 0;
                     if (Ext.getCmp('daysId').getValue() != "") {
                         Days = Ext.getCmp('daysId').getValue();
                     }

                     var Distance = 0;
                     if (Ext.getCmp('distanceId').getValue() != "") {
                         Distance = Ext.getCmp('distanceId').getValue();
                     }

                     var thresholdDays = 0;
                     if (Ext.getCmp('threshouldDaysId').getValue() != "") {
                         thresholdDays = Ext.getCmp('threshouldDaysId').getValue();
                     }

                     var thresholdDistance = 0;
                     if (Ext.getCmp('threshouldDistanceId').getValue() != "") {
                         thresholdDistance = Ext.getCmp('threshouldDistanceId').getValue();
                     }

                     if (innerPanelForManageDetails.getForm().isValid()) {
                         var id;
                         if (buttonValue == 'Modify') {
                             var selected = grid.getSelectionModel().getSelected();
                             id = selected.get('id');
                         }
                         parent.manageAllTasksPanel.getEl().mask();
                         manageDetailsOuterPanelWindow.getEl().mask();
                         Ext.Ajax.request({
                             url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=manageTaskAddModify',
                             method: 'POST',
                             params: {
                                 buttonValue: buttonValue,
                                 CustId: customerId,
                                 assetNumber: assetNumber,
                                 taskName: Ext.getCmp('taskNameComboId').getValue(),
                                 distance: Distance,
                                 days: Days,
                                 threshouldDistance: thresholdDistance,
                                 threshouldDays: thresholdDays,
                                 lastServiceDate: Ext.getCmp('lastServiceDateId').getValue(),
                                 id: id,
                                 custName: custName,
                                 jspName: jspName
                             },
                             success: function (response, options) {
                                 var message = response.responseText;
                                 Ext.example.msg(message);
                                 Ext.getCmp('taskNameComboId').reset();
                                 Ext.getCmp('distanceId').reset();
                                 Ext.getCmp('daysId').reset();
                                 Ext.getCmp('threshouldDistanceId').reset();
                                 Ext.getCmp('threshouldDaysId').reset();
                                 Ext.getCmp('lastServiceDateId').reset();
                                 myWin.hide();
                                 manageTasksStore.reload();
                                 manageDetailsOuterPanelWindow.getEl().unmask();
                                 parent.manageAllTasksPanel.getEl().unmask();
                             },
                             failure: function () {
                                 Ext.example.msg("Error");
                                 manageTasksStore.reload();
                                 myWin.hide();
                             }
                         });
                     }
                 }
             }
         }
     }, {
         xtype: 'button',
         text: 'Save & Add New',
         id: 'addNewId',
         iconCls : 'addbutton',
         cls: 'buttonstyle',
         width: 100,
         listeners: {
             click: {
                 fn: function () {
                     if (Ext.getCmp('taskNameComboId').getValue() == "") {
                         Ext.example.msg("<%=EnterTaskName%>");
                         Ext.getCmp('taskNameComboId').focus();
                         return;
                     }
                     if (Ext.getCmp('distanceId').getValue() == "") {
                         Ext.example.msg("<%=EnterMileageofService%>");
                         Ext.getCmp('distanceId').focus();
                         return;
                     }
                     if (Ext.getCmp('daysId').getValue() == "") {
                         Ext.example.msg("<%=EnterDaysofService%>");
                         Ext.getCmp('daysId').focus();
                         return;
                     }

                     if (Ext.getCmp('lastServiceDateId').getValue() == "") {
                         Ext.example.msg("Enter Last Service Date");
                         Ext.getCmp('lastServiceDateId').focus();
                         return;
                     }
                     if (Ext.getCmp('daysId').getValue('daysDataIndex') < Ext.getCmp('threshouldDaysId').getValue('daysDataIndex')) {
                         Ext.example.msg("<%=RenewalDaysofServiceCannotBeGreaterThanDaysofService%>");
                         valid = false;
                         return false;
                     }
                     if (Ext.getCmp('distanceId').getValue('distanceDataIndex') < Ext.getCmp('threshouldDistanceId').getValue('threshouldDistanceDataIndex')) {
                         Ext.example.msg("<%=RenewalMileageofServiceCannotBeGreaterThanMileageofService%>");
                         valid = false;
                         return false;
                     }
                     var Days = 0;
                     if (Ext.getCmp('daysId').getValue() != "") {
                         Days = Ext.getCmp('daysId').getValue();
                     }

                     var Distance = 0;
                     if (Ext.getCmp('distanceId').getValue() != "") {
                         Distance = Ext.getCmp('distanceId').getValue();
                     }

                     var thresholdDays = 0;
                     if (Ext.getCmp('threshouldDaysId').getValue() != "") {
                         thresholdDays = Ext.getCmp('threshouldDaysId').getValue();
                     }

                     var thresholdDistance = 0;
                     if (Ext.getCmp('threshouldDistanceId').getValue() != "") {
                         thresholdDistance = Ext.getCmp('threshouldDistanceId').getValue();
                     }

                     if (innerPanelForManageDetails.getForm().isValid()) {
                         var id;
                         if (buttonValue == 'Modify') {
                             var selected = grid.getSelectionModel().getSelected();
                             id = selected.get('id');
                         }

                         parent.manageAllTasksPanel.getEl().mask();
                         manageDetailsOuterPanelWindow.getEl().mask();
                         Ext.Ajax.request({
                             url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=manageTaskAddModify',
                             method: 'POST',
                             params: {
                                 buttonValue: buttonValue,
                                 CustId: customerId,
                                 assetNumber: assetNumber,
                                 taskName: Ext.getCmp('taskNameComboId').getValue(),
                                 distance: Distance,
                                 days: Days,
                                 threshouldDistance: thresholdDistance,
                                 threshouldDays: thresholdDays,
                                 lastServiceDate: Ext.getCmp('lastServiceDateId').getValue(),
                                 id: id,
                                 custName: custName,
                                 jspName: jspName
                             },
                             success: function (response, options) {
                                 var message = response.responseText;
                                 Ext.example.msg(message);
                                 Ext.getCmp('taskNameComboId').reset();
                                 Ext.getCmp('distanceId').reset();
                                 Ext.getCmp('daysId').reset();
                                 Ext.getCmp('threshouldDistanceId').reset();
                                 Ext.getCmp('threshouldDaysId').reset();
                                 Ext.getCmp('lastServiceDateId').reset();
                                 myWin.show();
                                 manageTasksStore.reload();
                                 taskNamesStore.reload();
                                 manageDetailsOuterPanelWindow.getEl().unmask();
                                 parent.manageAllTasksPanel.getEl().unmask();
                             },
                             failure: function () {
                                 Ext.example.msg("Error");
                                 manageTasksStore.reload();
                                 taskNamesStore.reload();
                                 myWin.show();
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
      manageTasksStore.load({
         params: {
             CustId: customerId,
             assetNumber: assetNumber,
             jspName: jspName,
             custName: custName
         }
     });
 }

 var manageDetailsOuterPanelWindow = new Ext.Panel({
     height: 380,
     width: 460,
     standardSubmit: true,
     frame: false,
     items: [innerPanelForManageDetails, innerTaskDetailsWinButtonPanel]
 });

 myWin = new Ext.Window({
     title: titelForInnerPanel,
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 380,
     width: 470,
     id: 'myWin',
     items: [manageDetailsOuterPanelWindow]
 });

 function addRecord() {
 if(assetNumber=="" || assetNumber==undefined)
{
     Ext.example.msg("<%=SelectAssetNumber%>");
     parent.Ext.getCmp('custcomboId').focus();
         return;
  }
  else{
     buttonValue = 'Add';
     titelForInnerPanel = '<%=ManageServiceDetails%>';
     myWin.setPosition(300, 50);
     myWin.show();
     myWin.setTitle(titelForInnerPanel);
     taskNamesStore.load({
         params: {
             CustId: customerId,
             assetNumber: assetNumber,
             taskId: Ext.getCmp('taskNameComboId').getValue()
         }
     });
if(buttonValue == 'Add'){
     Ext.getCmp('lastServiceDateId').setReadOnly(false);
     }
     Ext.getCmp('addNewId').show();
     // Ext.getCmp('addNewId').enable();
     Ext.getCmp('taskNameComboId').enable();
     Ext.getCmp('taskNameComboId').reset();
     Ext.getCmp('distanceId').reset();
     Ext.getCmp('daysId').reset();
     Ext.getCmp('threshouldDistanceId').reset();
     Ext.getCmp('threshouldDaysId').reset();
     Ext.getCmp('lastServiceDateId').reset();
     }
 }

 function modifyData() {
     if (grid.getSelectionModel().getCount() == 0) {
         Ext.example.msg("<%=NoRowsSelected%>");
         return;
     }
     if (grid.getSelectionModel().getCount() > 1) {
         Ext.example.msg("<%=SelectSingleRow%>");
         return;
     }
     buttonValue = 'Modify';
     titelForInnerPanel = '<%=Modify%>';
     myWin.setPosition(220, 50);
     myWin.setTitle(titelForInnerPanel);
     myWin.show();
     if(buttonValue == 'Modify'){
     Ext.getCmp('lastServiceDateId').setReadOnly(true);
     }
     Ext.getCmp('addNewId').hide();
     Ext.getCmp('taskNameComboId').disable();
     Ext.getCmp('distanceId').show();
     Ext.getCmp('daysId').show();
     Ext.getCmp('threshouldDistanceId').show();
     Ext.getCmp('threshouldDaysId').show();
     Ext.getCmp('lastServiceDateId').show();

     var selected = grid.getSelectionModel().getSelected();
     Ext.getCmp('taskNameComboId').setValue(selected.get('taskNameIndex'));
     Ext.getCmp('distanceId').setValue(selected.get('distanceDataIndex'));
     Ext.getCmp('daysId').setValue(selected.get('daysDataIndex'));
     Ext.getCmp('threshouldDistanceId').setValue(selected.get('threshouldDistanceDataIndex'));
     Ext.getCmp('threshouldDaysId').setValue(selected.get('threshouldDaysDataIndex'));
     Ext.getCmp('lastServiceDateId').setValue(selected.get('lastServiceDateDataIndex'));
 }

 var sm1 = new Ext.grid.CheckboxSelectionModel({
     checkOnly: true

 });

 var cols1 = new Ext.grid.ColumnModel([
     sm1, {
         header: '<b><%=AssetNumber%></b>',
         width: 170,
         sortable: true,
         dataIndex: 'assetNumberDataIndex'
     }, {
         header: '<b><%=AssetModel%></b>',
         width: 170,
         sortable: true,
         hidden: false,
         dataIndex: 'assetModelIndex'
     }
 ]);
 var reader1 = new Ext.data.JsonReader({
     root: 'copyRoot',
     fields: [{
         name: 'assetModelIndex',
         type: 'string'
     }, {
         name: 'assetNumberDataIndex',
         type: 'string'
     }]
 });

 var filters1 = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
             dataIndex: 'assetModelIndex',
             type: 'string'
         }, {
             dataIndex: 'assetNumberDataIndex',
             type: 'string'
         }

     ]
 });
 var firstGridStore = new Ext.data.Store({
     url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getAssetNumberAndModelToCopyDetails',
     bufferSize: 367,
     reader: reader1,
     autoLoad: true,
     remoteSort: true
 });


  var firstGrid = getSelectionModelGrid('<%=ReplicateDetails%>', '<%=NoRecordsfound%>', firstGridStore, 400, 250, cols1, 6, filters1, sm1);


 var copyButtonPanel = new Ext.Panel({
     id: 'copybuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 110,
     width: 420,
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: '<%=Save%>',
         id: 'savesId',
         cls: 'buttonstyle',
         iconCls: 'savebutton',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     var gridData = "";
                     var json = "";
                     var records1 = grid.getSelectionModel().getSelections();
                     for (var i = 0; i < records1.length; i++) {
                         var record1 = records1[i];
                         var row = grid.store.findExact('slnoIndex', record1.get('slnoIndex'));
                         var store = grid.store.getAt(row);
                         json = json + Ext.util.JSON.encode(store.data) + ',';
                     }
                // alert('json '+json);
                     var json1 = "";
                     var records = firstGrid.getSelectionModel().getSelections();
                     for (var i = 0; i < records.length; i++) {
                         var record = records[i];
                         var row = firstGrid.store.findExact('assetNumberDataIndex', record.get('assetNumberDataIndex'));
                         var store = firstGrid.store.getAt(row);
                         json1 = json1 + Ext.util.JSON.encode(store.data) + ',';
                     }
                     copyPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=saveCopyDetails',
                         method: 'POST',
                         params: {
                             gridData: json,
                             buttonValue: buttonValue,
                             CustId: customerId,
                             assetNumber: assetNumber,
                             manageDataSaveParam: json1
                         },

                         success: function (response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message);
                             copyPanelWindow.getEl().unmask();
                             copyWin.hide();
                             firstGridStore.reload();
                         },
                         failure: function () {
                             Ext.example.msg("Error");
                             copyWin.hide();
                             firstGridStore.load({
                                 params: {
                                     CustId: customerId,
                                     assetNumber: assetNumber
                                 }
                             });

                         }
                     });

                 }
             }

         }
     }, {
         xtype: 'button',
         text: '<%=Cancel%>',
         id: 'cancelsButtId',
         cls: 'buttonstyle',
         iconCls: 'cancelbutton',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     copyWin.hide();
                 }
             }
         }
     }]
 });

 var copyPanelWindow = new Ext.Panel({
     standardSubmit: true,
     height: 350,
     width: 420,
     frame: true,
     items: [firstGrid, copyButtonPanel]
 });

 copyWin = new Ext.Window({
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 350,
     width: 430,
     id: 'myWinVerify',
     items: [copyPanelWindow]
 });

 function copyData() {
     buttonValue = 'Replicate';
     copyWin.setPosition(220, 50);
     if (parent.Ext.getCmp('custcomboId').getValue() == "") {
         parent.Ext.example.msg("<%=SelectCustomer%>");
         parent.Ext.getCmp('custcomboId').focus();
         return;
     }

     if (grid.getSelectionModel().getCount() == 0) {
         Ext.example.msg("<%=NoRowsSelected%>");
         return;
     }

     firstGridStore.load({
         params: {
             CustId: customerId,
             assetNumber: assetNumber
         }
     });
     copyWin.show();
 }

 var reader = new Ext.data.JsonReader({
     idProperty: 'taskMasterid',
     root: 'manageTasksRoot',
     totalProperty: 'total',
     fields: [{
         name: 'slnoIndex'
     }, {
         name: 'assetDataIndex'
     }, {
         name: 'taskNameIndex'
     }, {
         name: 'distanceDataIndex'
     }, {
         name: 'daysDataIndex'
     }, {
         name: 'threshouldDistanceDataIndex'
     }, {
         name: 'threshouldDaysDataIndex'
     }, {
         name: 'lastServiceDateDataIndex'
     }, {
         name: 'taskIdDataIndex'
     }, {
         name: 'id'
     }]
 });

 var manageTasksStore = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getManageTasksDetails',
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
         type: 'int',
         dataIndex: 'distanceDataIndex'
     }, {
         type: 'int',
         dataIndex: 'daysDataIndex'
     }, {
         type: 'int',
         dataIndex: 'threshouldDistanceDataIndex'
     }, {
         type: 'int',
         dataIndex: 'threshouldDaysDataIndex'
     }, {
         type: 'date',
         dataIndex: 'lastServiceDateDataIndex'
     }, {
         type: 'int',
         dataIndex: 'taskIdDataIndex'
     }]
 });

 var createColModel = function (finish, start) {
     var columns = [
          {
             dataIndex: 'slnoIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             filter: {
                 type: 'numeric'
             }
         }, {
             header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
             dataIndex: 'assetDataIndex',
             width:50,
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;><%=ServiceName%></span>",
             dataIndex: 'taskNameIndex',
             width:90,
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;><%=MileageOfService%></span>",
             dataIndex: 'distanceDataIndex',
             width:80,
             filter: {
                 type: 'int'
             }
         }, {
             dataIndex: 'daysDataIndex',
             header: "<span style=font-weight:bold;><%=DaysOfService%></span>",
             width:180,
             filter: {
                 type: 'int'
             }
         }, {
             dataIndex: 'threshouldDistanceDataIndex',
             header: "<span style=font-weight:bold;><%=RenewalDaysOfService%></span>",
             filter: {
                 type: 'int'
             }
         }, {
             dataIndex: 'threshouldDaysDataIndex',
             header: "<span style=font-weight:bold;><%=RenewalMileageofService %></span>",
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
 var grid = getGrid('', '<%=NoRecordsFound%>', manageTasksStore,screen.width-360,360, 11, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false,'',false,'',false,'',false, '',true, 'Replicate');
 //******************************************************************************************************************************************************
 Ext.onReady(function () {
     ctsb = tsb;
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         //title: 'Manage Service Details',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         cls: 'outerpanel',
         layout: 'table',
         layoutConfig: {
             columns: 1
         },
         items: [grid]
        // bbar: ctsb
     });
     sb = Ext.getCmp('form-statusbar');

 });</script>
</body>
</html>
    
    
    
    
    

