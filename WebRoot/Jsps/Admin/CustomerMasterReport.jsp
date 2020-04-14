<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"😕/"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(12);
loginInfo.setUserId(1);
loginInfo.setLanguage("en");  
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setStyleSheetOverride("Y");

if(loginInfo==null){
response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);	
String language="en";

CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
  responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
session.setAttribute("responseaftersubmit",null);
}

int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();		

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Customer_Master_Report");
tobeConverted.add("Select_Region");
tobeConverted.add("Region");

tobeConverted.add("Customer_Information");
tobeConverted.add("Ltsp_Name");
tobeConverted.add("Enter_LTSP_Name");

tobeConverted.add("Enter_Place");
tobeConverted.add("Customer_Name");
tobeConverted.add("Enter_Customer_name");

tobeConverted.add("Business_Vertical");
tobeConverted.add("Enter_Bussiness_Vertical");
tobeConverted.add("Vertical_Stream");

tobeConverted.add("Enter_Vertical_Stream");
tobeConverted.add("No_Of_Vehicles");
tobeConverted.add("More_Potential");

tobeConverted.add("Enter_More_Potential");
tobeConverted.add("Date_Of_Acquisition");
tobeConverted.add("Enter_Date_Of_Acquisition");

tobeConverted.add("Reason_For_Pending_Potential");
tobeConverted.add("Enter_Reason_For_Pending_Potential");
tobeConverted.add("CRC_Last_CallDate");

tobeConverted.add("Enter_CRC_Last_CallDate");
tobeConverted.add("CRC_LastCall_Description");
tobeConverted.add("Enter_CRC_LastCall_Description");

tobeConverted.add("Issues_If_Any");
tobeConverted.add("Enter_Issues_If_Any");
tobeConverted.add("Contact_Person");

tobeConverted.add("Enter_Contact_Person");
tobeConverted.add("Contact_No");
tobeConverted.add("Enter_Contact_No");

tobeConverted.add("Select_Region_Name");
tobeConverted.add("Enter_Region_Name");
tobeConverted.add("No_Rows_Selected");

tobeConverted.add("Select_Single_Row");
tobeConverted.add("Select_Region_Name");
tobeConverted.add("SLNO");

tobeConverted.add("Reason_For_Not_Closing_The_pending_The_Potential");
tobeConverted.add("System_Id");
tobeConverted.add("CUSTOMER_ID");

tobeConverted.add("Vertical_Id");
tobeConverted.add("Id");
tobeConverted.add("Customer_Master_Details");

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");

tobeConverted.add("Modify");
tobeConverted.add("Save");
tobeConverted.add("Place");
tobeConverted.add("Contact_No");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String CustomerMasterReport=convertedWords.get(0);
String SelectRegion=convertedWords.get(1);
String Region=convertedWords.get(2);

String CustomerInformation=convertedWords.get(3);
String LTSPName=convertedWords.get(4);
String EnterLtspName=convertedWords.get(5);

String EnterPlace=convertedWords.get(6);
String CustomerName=convertedWords.get(7);
String EnterCustomerName=convertedWords.get(8);

String BusinessVertical=convertedWords.get(9);
String EnterBussinessVertical=convertedWords.get(10);
String VerticalStream=convertedWords.get(11);

String EnterVerticalStream=convertedWords.get(12);
String NoOfVehicles=convertedWords.get(13);
String MorePotential=convertedWords.get(14);

String EnterMorePotential=convertedWords.get(15);
String DateOfAcquisition=convertedWords.get(16);
String EnterDateOfAcquisition=convertedWords.get(17);

String ReasonForPendingPotential=convertedWords.get(18);
String EnterReasonForPendingPotential=convertedWords.get(19);
String CRCLastCallDate=convertedWords.get(20);

String EnterCRCLastCallDate=convertedWords.get(21);
String CRCLastCallDescription=convertedWords.get(22);
String EnterCRCLastCallDescription=convertedWords.get(23);

String IssuesIfAny=convertedWords.get(24);
String EnterIssuesIfAny=convertedWords.get(25);
String ContactPerson=convertedWords.get(26);

String EnterContactPerson=convertedWords.get(27);
String ContactNO=convertedWords.get(28);
String EnterContactNo=convertedWords.get(29);

String SelectRegionName=convertedWords.get(30);
String EnterRegionName=convertedWords.get(31);
String NORowsSelected=convertedWords.get(32);

String SelectSingleRow=convertedWords.get(33);
String ModifyDetails=convertedWords.get(34);
String SLNO=convertedWords.get(35);

String ReasonForNotClosingThePendingThePotential=convertedWords.get(36);
String SystemId=convertedWords.get(37);
String CustomerId=convertedWords.get(38);

String VerticalId=convertedWords.get(39);
String Id=convertedWords.get(40);
String CustomerMasterDetails=convertedWords.get(41);

String NoRecordFound=convertedWords.get(41);
String ClearFilterData=convertedWords.get(43);
String Excel=convertedWords.get(44);

String Modify=convertedWords.get(45);
String Save =convertedWords.get(46);
String Place =convertedWords.get(47);
String ContactNo=convertedWords.get(48);

%>


<!DOCTYPE HTML>
<html>
 <head>
 		<title><%=CustomerMasterReport%></title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
  
   var outerPanel;
   var jspName = "CustomerMasterReport";
   var exportDataType = "int,string,string,string,string,string,int,string,date,string,date,string,string,string,string,int,int,int,int";
   var grid;
   var JspName;
   var name;
   var regionid;
   var value;
   var regionId;
   var regionStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CustomerMasterReportAction.do?param=getRegion',
       id: 'regionStoreId',
       root: 'regionRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['Region', 'Value'],
       listeners: {}
   });
   var regionCombo = new Ext.form.ComboBox({
       store: regionStore,
       id: 'regionComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: '<%=SelectRegion%>',
       displayField: 'Region',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   value = Ext.getCmp('regionComboId').getValue();
                   store.load({
                       params: {
                           JspName: jspName,
                           regionid: value,
                           regionName: Ext.getCmp('regionComboId').getRawValue()
                       }
                   });
               }
           }
       }
   });
   //***************************************************************************************************************//
   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'clientPanelId',
       layout: 'table',
       frame: false,
       width: screen.width - 60,
       height: 50,
       layoutConfig: {
           columns: 15
       },
       items: [{
               xtype: 'label',
               text: '<%=Region%>' + ' :',
               cls: 'labelstyle',
               id: 'ltspcomboId'
           },
           regionCombo, {
               width: 40
           }
       ]
   });
   //---------------------------------------------------------------------------------------------------------------//
   var innerPanelForCustomerDetails = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 450,
       width: 490,
       frame: true,
       id: 'innerPanelForCustomerDetailsId',
       layout: 'table',
       layoutConfig: {
           columns: 3
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=CustomerInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 2,
           id: 'CustomerInformationId',
           width: 465,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
                   style: {
                       width: '88%'
                   }
               }
           },
           items: [{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'ltspEmptyId'
           }, {
               xtype: 'label',
               text: '<%=LTSPName%>' + ' :',
               cls: 'labelstyle',
               id: 'ltspLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterLtspName%>',
               emptyText: '<%=EnterLtspName%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'ltspId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'placeEmptyId'
           }, {
               xtype: 'label',
               text: 'Place' + ' :',
               cls: 'labelstyle',
               id: 'placeLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               blankText: '<%=EnterPlace%>',
               emptyText: '<%=EnterPlace%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'placeId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'custEmptyId'
           }, {
               xtype: 'label',
               text: '<%=CustomerName%>' + ' :',
               cls: 'labelstyle',
               id: 'custLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterCustomerName%>',
               emptyText: '<%=EnterCustomerName%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'custId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'bverticalEmptyId'
           }, {
               xtype: 'label',
               text: '<%=BusinessVertical%>' + ' :',
               cls: 'labelstyle',
               id: 'bverticalLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterBussinessVertical%>',
               emptyText: '<%=EnterBussinessVertical%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'bverticalId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'streamEmptyId'
           }, {
               xtype: 'label',
               text: '<%=VerticalStream%>' + ' :',
               cls: 'labelstyle',
               id: 'streamLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               blankText: '<%=EnterVerticalStream%>',
               emptyText: '<%=EnterVerticalStream%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'streamId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'vehicleEmptyId'
           }, {
               xtype: 'label',
               text: '<%=NoOfVehicles%>' + ' :',
               cls: 'labelstyle',
               id: 'vehicleLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=NoOfVehicles%>',
               emptyText: '<%=NoOfVehicles%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'vehicleId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'morePotentialEmptyId'
           }, {
               xtype: 'label',
               text: '<%=MorePotential%>' + ' :',
               cls: 'labelstyle',
               id: 'morePotentialLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterMorePotential%>',
               emptyText: '<%=EnterMorePotential%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'morePotentialId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'acqlEmptyId'
           }, {
               xtype: 'label',
               text: '<%=DateOfAcquisition%>' + ' :',
               cls: 'labelstyle',
               id: 'acqLabelId'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               emptyText: '<%=EnterDateOfAcquisition%>',
               labelSeparator: '',
               format: getDateFormat(),
               id: 'acqId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'pendingPotentialEmptyId'
           }, {
               xtype: 'label',
               text: '<%=ReasonForPendingPotential%>' + ' :',
               cls: 'labelstyle',
               id: 'pendingPotentialLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterReasonForPendingPotential%>',
               emptyText: '<%=EnterReasonForPendingPotential%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'pendingPotentialId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crcdate1EmptyId'
           }, {
               xtype: 'label',
               text: '<%=CRCLastCallDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crcdate1LabelId'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterCRCLastCallDate%>',
               emptyText: '<%=EnterCRCLastCallDate%>',
               labelSeparator: '',
               format: getDateFormat(),
               allowBlank: false,
               id: 'crcdate1Id'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'descriptionEmptyId'
           }, {
               xtype: 'label',
               text: '<%=CRCLastCallDescription%>' + ' :',
               cls: 'labelstyle',
               id: 'descriptionLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterCRCLastCallDescription%>',
               emptyText: '<%=EnterCRCLastCallDescription%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'descriptionId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'personEmptyId'
           }, {
               xtype: 'label',
               text: '<%=IssuesIfAny%>' + ' :',
               cls: 'labelstyle',
               id: 'issuesLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterIssuesIfAny%>',
               emptyText: '<%=EnterIssuesIfAny%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'issuesId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'personEmptyId11'
           }, {
               xtype: 'label',
               text: '<%=ContactPerson%>' + ' :',
               cls: 'labelstyle',
               id: 'personLabelId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterContactPerson%>',
               emptyText: '<%=EnterContactPerson%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'personId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'person1EmptyId'
           }, {
               xtype: 'label',
               text: '<%=ContactNO%>' + ' :',
               cls: 'labelstyle',
               id: 'person1LabelId'
           }, {
               xtype: 'numberfield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               //regex:validate('city'),
               blankText: '<%=EnterContactNo%>',
               emptyText: '<%=EnterContactNo%>',
               labelSeparator: '',
               allowBlank: false,
               id: 'person1Id'
           }]
       }]
   });
   var innerWinButtonPanel = new Ext.Panel({
       id: 'innerWinButtonPanelId',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 100,
       width: 500,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 3
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           id: 'saveButtonId',
           iconCls: 'savebutton',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function() {
                       if (Ext.getCmp('regionComboId').getValue() == "") {
                           Ext.example.msg("<%=SelectRegionName%>");
                           return;
                       }
                       var selected = grid.getSelectionModel().getSelected();
                       // alert(pendingPotential);                 
                       //  if (innerPanelForCustomerDetails.getForm().isValid()) {
                       var selected = grid.getSelectionModel().getSelected();
                       CustomerMasterOuterPanelWindow.getEl().mask();
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CustomerMasterReportAction.do?param=CustomerMasterModify',
                           method: 'POST',
                           params: {
                               buttonValue: buttonValue,
                               systemId1: selected.get('systemDataIndex'),
                               custId: selected.get('customerDataIndex'),
                               place: selected.get('placeDataIndex'),
                               verticalStream: Ext.getCmp('streamId').getValue(),
                               morePotential: Ext.getCmp('morePotentialId').getValue(),
                               pendingPotential: Ext.getCmp('pendingPotentialId').getValue(),
                               lastCallDate: Ext.getCmp('crcdate1Id').getValue(),
                               lastCall: Ext.getCmp('descriptionId').getValue(),
                               issueDate: Ext.getCmp('issuesId').getValue(),
                               contactPerson: Ext.getCmp('personId').getValue(),
                               contactNumber: Ext.getCmp('person1Id').getValue(),
                               verticalId: selected.get('verticaIdDataIndex'),
                               IdFromCustomerMaster: selected.get('IdDataIndex'),
                               ltspName: selected.get('ltspDataIndex'),
                               custName: selected.get('clientNameDataIndex'),
                               businessVertical: selected.get('businessVerticalDataIndex'),
                               noOfVehicles: selected.get('noOfVehiclesDataIndex'),
                               acqDate: selected.get('acquisitionDateDataIndex'),
                               regionId: Ext.getCmp('regionComboId').getValue()
                           },
                           success: function(response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               myWin.hide();
                               CustomerMasterOuterPanelWindow.getEl().unmask();
                               store.load({
                                   params: {
                                       regionid: Ext.getCmp('regionComboId').getValue(),
                                       JspName: jspName,
                                       regionName: Ext.getCmp('regionComboId').getRawValue()
                                   }
                               });
                           },
                           failure: function() {
                               Ext.example.msg("Error");
                               store.reload();
                               myWin.hide();
                           }
                       });
                       //  }
                   }
               }
           }
       }, {
           xtype: 'button',
           text: 'Cancel',
           id: 'canButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function() {
                       myWin.hide();
                   }
               }
           }
       }]
   });
   var CustomerMasterOuterPanelWindow = new Ext.Panel({
       width: 510,
       height: 790,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForCustomerDetails, innerWinButtonPanel]
   });
   myWin = new Ext.Window({
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 560,
       width: 510,
       id: 'myWin',
       items: [CustomerMasterOuterPanelWindow]
   });

   function modifyData() {
           if (Ext.getCmp('regionComboId').getValue() == "") {
               Ext.example.msg("<%=SelectRegionName%>");
               return;
           }
           if (grid.getSelectionModel().getCount() == 0) {
               Ext.example.msg("<%=NORowsSelected%>");
               return;
           }
           if (grid.getSelectionModel().getCount() > 1) {
               Ext.example.msg("<%=SelectSingleRow%> ");
               return;
           }
           buttonValue = 'Modify';
           titelForInnerPanel = '<%=ModifyDetails%>';
           myWin.setPosition(450, 50);
           myWin.setTitle(titelForInnerPanel);
           myWin.show();
           Ext.getCmp('ltspId').disable();
           Ext.getCmp('placeId').disable();
           Ext.getCmp('custId').disable();
           Ext.getCmp('bverticalId').disable();
           Ext.getCmp('streamId').enable();
           Ext.getCmp('vehicleId').disable();
           Ext.getCmp('acqId').disable();
           Ext.getCmp('morePotentialId').enable();
           Ext.getCmp('pendingPotentialId').enable();
           Ext.getCmp('crcdate1Id').enable();
           Ext.getCmp('descriptionId').enable();
           Ext.getCmp('issuesId').enable();
           Ext.getCmp('personId').enable();
           Ext.getCmp('person1Id').enable();
           var selected = grid.getSelectionModel().getSelected();
           Ext.getCmp('placeId').setValue(selected.get('placeDataIndex'));
           Ext.getCmp('streamId').setValue(selected.get('verticalStreamDataIndex'));
           Ext.getCmp('morePotentialId').setValue(selected.get('morePotentialDataIndex'));
           Ext.getCmp('pendingPotentialId').setValue(selected.get('pendingPotentialDataIndex'));
           Ext.getCmp('crcdate1Id').setValue(selected.get('lastCallDateDataIndex'));
           Ext.getCmp('descriptionId').setValue(selected.get('lastCallDataIndex'));
           Ext.getCmp('issuesId').setValue(selected.get('IsssueDataIndex'));
           Ext.getCmp('personId').setValue(selected.get('contactPersonDataIndex'));
           Ext.getCmp('person1Id').setValue(selected.get('contactNumberDataIndex'));
           Ext.getCmp('ltspId').setValue(selected.get('ltspDataIndex'));
           Ext.getCmp('custId').setValue(selected.get('clientNameDataIndex'));
           Ext.getCmp('bverticalId').setValue(selected.get('businessVerticalDataIndex'));
           Ext.getCmp('vehicleId').setValue(selected.get('noOfVehiclesDataIndex'));
           Ext.getCmp('acqId').setValue(selected.get('acquisitionDateDataIndex'));
       }
       //----------------------------------------------------------------------------------------------------------------//  
       //***************************************************************************************************************//
   var reader = new Ext.data.JsonReader({
       idProperty: '',
       root: 'customerMasterReport',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'ltspDataIndex'
       }, {
           name: 'placeDataIndex'
       }, {
           name: 'clientNameDataIndex'
       }, {
           name: 'businessVerticalDataIndex'
       }, {
           name: 'verticalStreamDataIndex'
       }, {
           name: 'noOfVehiclesDataIndex'
       }, {
           name: 'morePotentialDataIndex'
       }, {
           name: 'acquisitionDateDataIndex',
           type: 'date'
       }, {
           name: 'pendingPotentialDataIndex'
       }, {
           name: 'lastCallDateDataIndex',
           type: 'date'
       }, {
           name: 'lastCallDataIndex'
       }, {
           name: 'IsssueDataIndex'
       }, {
           name: 'contactPersonDataIndex'
       }, {
           name: 'contactNumberDataIndex'
       }, {
           name: 'systemDataIndex'
       }, {
           name: 'customerDataIndex'
       }, {
           name: 'verticaIdDataIndex'
       }, {
           name: 'IdDataIndex'
       }]
   });
   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/CustomerMasterReportAction.do?param=getCustomerMasterReport',
           method: 'POST'
       }),
       remoteSort: false,
       storeId: 'CustomerMasterReport',
       reader: reader
   });
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'ltspDataIndex'
       }, {
           type: 'string',
           dataIndex: 'placeDataIndex'
       }, {
           type: 'string',
           dataIndex: 'clientNameDataIndex'
       }, {
           type: 'string',
           dataIndex: 'businessVerticalDataIndex'
       }, {
           type: 'string',
           dataIndex: 'verticalStreamDataIndex'
       }, {
           type: 'int',
           dataIndex: 'noOfVehiclesDataIndex'
       }, {
           type: 'string',
           dataIndex: 'morePotentialDataIndex'
       }, {
           type: 'date',
           dataIndex: 'acquisitionDateDataIndex' //date
       }, {
           type: 'string',
           dataIndex: 'pendingPotentialDataIndex'
       }, {
           type: 'date',
           dataIndex: 'lastCallDateDataIndex' //date
       }, {
           type: 'string',
           dataIndex: 'lastCallDataIndex'
       }, {
           type: 'string',
           dataIndex: 'IsssueDataIndex'
       }, {
           type: 'string',
           dataIndex: 'contactPersonDataIndex'
       }, {
           type: 'int',
           dataIndex: 'contactNumberDataIndex'
       }]
   });
   var createColModel = function(finish, start) {
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
               header: "<span style=font-weight:bold;><%=LTSPName%></span>",
               dataIndex: 'ltspDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=Place%></span>",
               dataIndex: 'placeDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=CustomerName%></span>",
               dataIndex: 'clientNameDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=BusinessVertical%></span>",
               dataIndex: 'businessVerticalDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=VerticalStream%></span>",
               dataIndex: 'verticalStreamDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=NoOfVehicles%></span>",
               dataIndex: 'noOfVehiclesDataIndex',
               width: 80,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=MorePotential%></span>",
               dataIndex: 'morePotentialDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=DateOfAcquisition%></span>",
               dataIndex: 'acquisitionDateDataIndex',
               renderer: Ext.util.Format.dateRenderer(getDateFormat()),
               width: 80,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=ReasonForNotClosingThePendingThePotential%></span>",
               dataIndex: 'pendingPotentialDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=CRCLastCallDate%></span>",
               dataIndex: 'lastCallDateDataIndex',
               renderer: Ext.util.Format.dateRenderer(getDateFormat()),
               width: 80,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=CRCLastCallDescription%></span>",
               dataIndex: 'lastCallDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=IssuesIfAny%></span>",
               dataIndex: 'IsssueDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=ContactPerson%></span>",
               dataIndex: 'contactPersonDataIndex',
               width: 80,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=ContactNo%></span>",
               dataIndex: 'contactNumberDataIndex',
               width: 80,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=SystemId%></span>",
               dataIndex: 'systemDataIndex',
               hidden: true,
       //      hideable: false,
               width: 80,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=CustomerId%></span>",
               dataIndex: 'customerDataIndex',
               hidden: true,
       //      hideable: false,
               width: 80,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=VerticalId%></span>",
               dataIndex: 'verticaIdDataIndex',
               hidden: true,
               hideable: false,
               width: 80,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=Id%></span>",
               dataIndex: 'IdDataIndex',
               hidden: true,
               hideable: false,
               width: 80,
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
   grid = getGrid('<%=CustomerMasterDetails%>', '<%=NoRecordFound%>', store, screen.width-140,420, 21, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', false, 'Add', true, '<%=Modify%>', false, 'Delete');
   
   Ext.onReady(function() {
       // ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: '<%=CustomerMasterReport%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           cls: 'outerpanel',
           layout: 'table',
           height:550,
           width : screen.width-130,
           layoutConfig: {
               columns: 1
           },
           items: [clientPanel, grid],
           //  bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');
   }); </script>
</body>
</html>
<%}%>
