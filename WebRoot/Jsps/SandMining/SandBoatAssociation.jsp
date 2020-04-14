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
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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
		
			 
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Add_Details");
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String NoRecordsFound=convertedWords.get(2);
String ClearFilterData=convertedWords.get(3);
String Save=convertedWords.get(4);
String Cancel=convertedWords.get(5);

String SLNO=convertedWords.get(6);
String NoRowsSelected=convertedWords.get(7);
String SelectSingleRow=convertedWords.get(8);
String AddDetails=convertedWords.get(9);
String ModifyDetails=convertedWords.get(10);
String SelectCustomer=convertedWords.get(11);
String CustomerName=convertedWords.get(12);

String sandBoatAssociation= "SandBoat Association";

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();


%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=sandBoatAssociation%></title>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
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
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
				height : 38px !important;
			}			
		</style>
	 <%}%>	
 <script>
 var outerPanel;
 var jspName = "Sand Boat Association";
 var exportDataType = "int,int,string,string,int";
 var grid;
 var myWin;
 var buttonValue;
 var selected;
 //----------------------------------customer store---------------------------// 
 var customercombostore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
     id: 'CustomerStoreId',
     root: 'CustomerRoot',
     autoLoad: true,
     remoteSort: true,
     fields: ['CustId', 'CustName'],
     listeners: {
         load: function(custstore, records, success, options) {
             if (<%= customerId %> > 0) {
                 Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                 custId = Ext.getCmp('custcomboId').getValue();
                 store.load({
                     params: {
                         custId: Ext.getCmp('custcomboId').getValue(),
                         jspName: jspName,
                         custName: Ext.getCmp('custcomboId').getRawValue()
                     }
                 });

             }
         }
     }
 });
 //******************************************************************customer Combo******************************************//
 var custnamecombo = new Ext.form.ComboBox({
     store: customercombostore,
     id: 'custcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectCustomer%>',
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
                 custId = Ext.getCmp('custcomboId').getValue();
                 store.load({
                     params: {
                         custId: Ext.getCmp('custcomboId').getValue(),
                         jspName: jspName,
                         custName: Ext.getCmp('custcomboId').getRawValue()
                     }
                 });

             }
         }
     }
 });
 //*************************************************Client Panel**************************************************************//
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
             text: '<%=CustomerName%>' + ' :',
             cls: 'labelstyle',
             id: 'ltspcomboId'
         },
         custnamecombo, {
             width: 25
         }
     ]
 });
 var regNoComboStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/SandBoatAssociationAction.do?param=getRegNo',
     root: 'regNoRoot',
     autoLoad: false,
     id: 'regNoId',
     fields: ['REG_NO', 'REG_STATUS']
 });

 //****************************combo for OrgCode***************************************
 var registrationNoCombo = new Ext.form.ComboBox({
     store: regNoComboStore,
     id: 'regNocomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Select registrationNo',
     blankText: 'Select registrationNo',
     resizable: true,
     selectOnFocus: true,
     allowBlank: true,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'REG_NO',
     displayField: 'REG_NO',
     cls: 'selectstylePerfectnew',
     listeners: {
         select: {
             fn: function() {
                 var regNo = Ext.getCmp('regNocomboId').getValue();
                 var row = regNoComboStore.findExact('REG_NO', regNo);
                 var rec = regNoComboStore.getAt(row);
                 regStatus = rec.data['REG_STATUS'];
                 if (regStatus == 'TRUE') {
                     Ext.example.msg("Sand block is already associated to this registration No");
                     Ext.getCmp('regNocomboId').reset();
                     Ext.getCmp('regNocomboId').focus();
                     return;
                 }
             }
         }
     }
 });
 var sandBlockStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/SandBoatAssociationAction.do?param=getSandBlock',
     root: 'sandBlockRoot',
     autoLoad: false,
     id: 'sandBlockId',
     fields: ['sandBlockName', 'sandBlockId']
 });

 var sandBlockCombo = new Ext.form.ComboBox({
     store: sandBlockStore,
     id: 'sandBlockComboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Select SandBlock',
     blankText: 'Select SandBlock',
     resizable: true,
     selectOnFocus: true,
     allowBlank: true,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'sandBlockId',
     displayField: 'sandBlockName',
     cls: 'selectstylePerfectnew',
     listeners: {
         select: {
             fn: function() {

             }
         }
     }
 });
 //******************************************Add and Modify function *********************************************************************//
 var innerPanelDetails = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     //autoScroll: true,
     height: 180,
     width: 480,
     frame: true,
     id: 'innerPanelForPlantMasterDetailsId',
     layout: 'table',
     resizable: true,
     layoutConfig: {
         columns: 4
     },
     items: [{
         xtype: 'fieldset',
         title: '<%=sandBoatAssociation%>',
         cls: 'my-fieldset',
         collapsible: false,
         autoScroll: true,
         colspan: 3,
         id: 'PlantMasterDetailsid',
         width: 465,
         height: 260,
         layout: 'table',
         layoutConfig: {
             columns: 3,

         },
         items: [{
             xtype: 'label',
             text: '*',
             cls: 'mandatoryfield',
             id: 'regNoEmptyId'
         }, {
             xtype: 'label',
             text: 'Registration No' + ' :',
             cls: 'labelstylenew',
             id: 'regNoLabelId'
         }, registrationNoCombo, {
             xtype: 'label',
             text: '*',
             cls: 'mandatoryfield',
             id: 'sandBlockEmptyId'
         }, {
             xtype: 'label',
             text: 'Sand Block Name' + ' :',
             cls: 'labelstylenew',
             id: 'sandBlockLabelId'
         }, sandBlockCombo, {
             xtype: 'label',
             text: '*',
             cls: 'mandatoryfield',
             id: 'detentionMinManId'
         }, {
             xtype: 'label',
             text: 'Detention Time(Mins)' + ' :',
             cls: 'labelstylenew',
             id: 'detentionMinLabId'
         }, {
             xtype: 'numberfield',
             cls: 'selectstylePerfectnew',
             id: 'detentionMinId',
             mode: 'local',
             forceSelection: true,
             emptyText: 'Enter Detention Mins',
             blankText: 'Enter Detention Mins',
             selectOnFocus: true,
             allowBlank: false,
             allowDecimals: false,
             allowNegative: false

         }]
     }]
 });

 var innerWinButtonPanel = new Ext.Panel({
     id: 'winbuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 90,
     width: 480,
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: '<%=Save%>',
         id: 'addButtId',
         cls: 'buttonstyle',
         iconCls: 'savebutton',
         width: 70,
         listeners: {
             click: {
                 fn: function() {
                     if (Ext.getCmp('custcomboId').getValue() == "") {
                         Ext.example.msg("<%=SelectCustomer%>");
                         Ext.getCmp('custcomboId').focus();
                         return;
                     }
                     if (Ext.getCmp('regNocomboId').getValue() == "") {
                         Ext.example.msg("Select Registration No");
                         Ext.getCmp('regNocomboId').focus();
                         return;
                     }
                     if (Ext.getCmp('sandBlockComboId').getValue() == "") {
                         Ext.example.msg("Select Sand Block");
                         Ext.getCmp('sandBlockComboId').focus();
                         return;
                     }
                     if (Ext.getCmp('detentionMinId').getValue() == "") {
                         Ext.example.msg("Enter Detention Time");
                         Ext.getCmp('detentionMinId').focus();
                         return;
                     }
                     var id;
                     var sandBlockMod;
                     if (buttonValue == 'Modify') {
                         selected = grid.getSelectionModel().getSelected();
                         id = selected.get('uidIndex');
                         if (selected.get('sandBlockIndex') != Ext.getCmp('sandBlockComboId').getValue()) {
                             sandBlockMod = Ext.getCmp('sandBlockComboId').getValue();
                         } else {
                             sandBlockMod = selected.get('hubIdIndex');
                         }
                     }
                     OuterPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/SandBoatAssociationAction.do?param=saveAndModifySandBoatDetails',
                         method: 'POST',
                         params: {
                             buttonValue: buttonValue,
                             custId: Ext.getCmp('custcomboId').getValue(),
                             regNo: Ext.getCmp('regNocomboId').getValue(),
                             sandBlock: Ext.getCmp('sandBlockComboId').getValue(),
                             detentionMin: Ext.getCmp('detentionMinId').getValue(),
                             id: id,
                             sandBlockMod: sandBlockMod
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             console.log(message);
                             Ext.example.msg(message);
                             Ext.getCmp('regNocomboId').reset();
                             Ext.getCmp('sandBlockComboId').reset();
                             Ext.getCmp('detentionMinId').reset();
                             myWin.hide();
                             store.load({
                                 params: {
                                     custId: Ext.getCmp('custcomboId').getValue(),
                                     jspName: jspName,
                                     custName: Ext.getCmp('custcomboId').getRawValue()
                                 }
                             });
                             OuterPanelWindow.getEl().unmask();
                         },
                         failure: function() {
                             Ext.example.msg("Error");
                             Ext.getCmp('regNocomboId').reset();
                             Ext.getCmp('sandBlockComboId').reset();
                             Ext.getCmp('detentionMinId').reset();
                             store.load({
                                 params: {
                                     custId: Ext.getCmp('custcomboId').getValue(),
                                     jspName: jspName,
                                     custName: Ext.getCmp('custcomboId').getRawValue()
                                 }
                             });
                             myWin.hide();
                         }
                     });
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
                 fn: function() {
                     myWin.hide();
                 }
             }
         }
     }]
 });

 var OuterPanelWindow = new Ext.Panel({
     width: 510,
     height: 250,
     standardSubmit: true,
     frame: true,
     items: [innerPanelDetails, innerWinButtonPanel]
 });

 myWin = new Ext.Window({
     title: 'titelForInnerPanel',
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 300,
     width: 510,
     frame: true,
     id: 'myWin',
     items: [OuterPanelWindow]
 });

 function addRecord() {
     Ext.getCmp('regNocomboId').setReadOnly(false);
     if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomer%>");
         Ext.getCmp('custcomboId').focus();
         return;
     }

     buttonValue = '<%=Add%>';
     titelForInnerPanel = '<%=AddDetails%>';
     myWin.setPosition(450, 50);
     myWin.show();
     myWin.setTitle(titelForInnerPanel);
     Ext.getCmp('regNocomboId').reset();
     Ext.getCmp('sandBlockComboId').reset();
     Ext.getCmp('detentionMinId').reset();
     sandBlockStore.load();
     regNoComboStore.load();
 }

 function modifyData() {
     Ext.getCmp('regNocomboId').setReadOnly(true);
     if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomer%>");
         return;
     }
     if (grid.getSelectionModel().getCount() == 0) {
         Ext.example.msg("<%=NoRowsSelected%>");
         return;
     }
     if (grid.getSelectionModel().getCount() > 1) {
         Ext.example.msg("<%=SelectSingleRow%>");
         return;
     }
     selected = grid.getSelectionModel().getSelected();
     Ext.getCmp('regNocomboId').setValue(selected.get('regNoIndex'));
     Ext.getCmp('sandBlockComboId').setValue(selected.get('sandBlockIndex'));
     Ext.getCmp('detentionMinId').setValue(selected.get('detentionTimeIndex'));
     sandBlockStore.load();
     buttonValue = '<%=Modify%>';
     titelForInnerPanel = '<%=ModifyDetails%>';
     myWin.setPosition(450, 50);
     myWin.setTitle(titelForInnerPanel);
     myWin.show();
 }
 //***************************************************************************************//
 var reader = new Ext.data.JsonReader({
     idProperty: 'sandBoatDetails',
     root: 'sandBoatDetailsRoot',
     totalProperty: 'total',
     fields: [{
         name: 'slnoIndex'
     }, {
         name: 'uidIndex'
     }, {
         name: 'hubIdIndex'
     }, {
         name: 'regNoIndex'
     }, {
         name: 'sandBlockIndex'
     }, {
         name: 'detentionTimeIndex'
     }]
 });

 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/SandBoatAssociationAction.do?param=getSandBoatDetails',
         method: 'POST'
     }),
     remoteSort: false,
     storeId: 'boatDetails',
     reader: reader
 });

 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         type: 'numeric',
         dataIndex: 'slnoIndex'
     }, {
         type: 'numeric',
         dataIndex: 'uidInd'
     }, {
         type: 'string',
         dataIndex: 'regNoIndex'
     }, {
         type: 'string',
         dataIndex: 'sandBlockIndex'
     }, {
         type: 'string',
         dataIndex: 'detentionTimeIndex'
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
             width: 50,
             header: "<span style=font-weight:bold;><%=SLNO%></span>"
         }, {
             header: "<span style=font-weight:bold;>ID</span>",
             dataIndex: 'uidIndex',
             hidden: true,
             width: 50
         }, {
             header: "<span style=font-weight:bold;>Registration No</span>",
             dataIndex: 'regNoIndex',
         }, {
             header: "<span style=font-weight:bold;>Sand Block Name</span>",
             dataIndex: 'sandBlockIndex',
         }, {
             header: "<span style=font-weight:bold;>Detention Time(Mins)</span>",
             dataIndex: 'detentionTimeIndex',
         }
     ];
     return new Ext.grid.ColumnModel({
         columns: columns.slice(start || 0, finish),
         defaults: {
             sortable: true
         }
     });
 };

 grid = getGrid('SandBoat Association Details', '<%=NoRecordsFound%>', store, screen.width - 40, 450, 10, filters, '<%=ClearFilterData%>', false, '', 9, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');

 Ext.onReady(function() {
     ctsb = tsb;
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         title: '',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         width: screen.width - 25,
         cls: 'outerpanel',
         layout: 'table',
         layoutConfig: {
             columns: 1
         },
         items: [clientPanel, grid]
     });
     var cm = grid.getColumnModel();
     for (var j = 1; j < cm.getColumnCount(); j++) {
         cm.setColumnWidth(j, 420);
     }
     sb = Ext.getCmp('form-statusbar');
 });
	
 </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
