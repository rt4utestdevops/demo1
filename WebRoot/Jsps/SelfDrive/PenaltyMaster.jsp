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
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
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
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Penalty_Name");
tobeConverted.add("Enter_Penalty_Name");

tobeConverted.add("Enter_Cost");
tobeConverted.add("Cost");
tobeConverted.add("Penalty_Description");
tobeConverted.add("Enter_Penalty_Description");
tobeConverted.add("Penalty_Master");
tobeConverted.add("Penalty_Details"); 

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
String SelectCustomer=convertedWords.get(10);
String CustomerName=convertedWords.get(11);
String PenaltyName=convertedWords.get(12);
String enterPenaltyName=convertedWords.get(13);

String EnterCost=convertedWords.get(14);
String Cost=convertedWords.get(15);
String PenaltyDescription=convertedWords.get(16);
String EnterPenaltyDescription=convertedWords.get(17);
String PenaltyMaster=convertedWords.get(18);
String PenaltyDetails=convertedWords.get(19);  



int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();



%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=PenaltyMaster%></title>
		<style type="text/css">
			.selectstylePerfectDropDown {
				height: 20px;
				width: 124px !important;
				listwidth: 120px !important;
				max-listwidth: 120px !important;
				min-listwidth: 120px !important;
				margin: 0px 0px 5px 5px !important;
			}
		</style>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <style>
			.x-panel-header
		{
				height: 7% !important;
		}
		
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		
		label {
			display : inline !important;
		}
		.footer {
			bottom : -10px !important;
		}
		.x-window-tl *.x-window-header {
			
			height : 46px !important;
		}
		 </style>
 <script>
  var outerPanel;
 var jspName = "";
 var exportDataType = "";
 var grid;
 var myWin;
 var buttonValue;
 var id;
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
 			if ( <%= customerId %> > 0) {
 				Ext.getCmp('custcomboId').setValue('<%=customerId%>');
 				custId = Ext.getCmp('custcomboId').getValue();
 				custName = Ext.getCmp('custcomboId').getRawValue();
 				store.load({
 					params: {
 						CustId: custId
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
 				custName = Ext.getCmp('custcomboId').getRawValue();
 				store.load({
 					params: {
 						JspName: jspName,
 						CustId: custId,
 						CustName: custName
 					}
 				});
 			}
 		}
 	}
 });

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
 		width: 40
 	}]
 });

 var innerPanelForPenaltyMasterDetails = new Ext.form.FormPanel({
 	standardSubmit: true,
 	collapsible: false,
 	autoScroll: true,
 	height: 200,
 	width: 430,
 	frame: true,
 	id: 'innerPanelForGradeDetailsId',
 	layout: 'table',
 	resizable: true,
 	layoutConfig: {
 		columns: 4
 	},
 	items: [{
 		xtype: 'fieldset',
 		title: '<%=PenaltyDetails%>',
 		cls: 'fieldsetpanel',
 		collapsible: false,
 		colspan: 3,
 		id: 'penaltyMasterDetialsId',
 		width: 380,
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
 			text: '*',
 			cls: 'mandatoryfield',
 			id: 'penaltyTypeEmptyId1'
 		}, {
 			xtype: 'label',
 			text: '<%=PenaltyName%>' + ' :',
 			cls: 'labelstyle',
 			id: 'penaltyTypeLabelId',
 		},
 		{
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=enterPenaltyName%>',
			emptyText: '<%=enterPenaltyName%>',
			id: 'penaltyTypeComboId',
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
				}
			}
		}, {
 			xtype: 'label',
 			text: '*',
 			cls: 'mandatoryfield',
 			id: 'penaltyDescriptionEmptyId1'
 		}, {
 			xtype: 'label',
 			text: '<%=PenaltyDescription%>' + ' :',
 			cls: 'labelstyle',
 			id: 'penaltyDescriptionLabelId',
 		}, {
 			xtype: 'textarea',
            cls: 'selectstylePerfect',
 			allowBlank: false,
 			blankText: '<%=EnterPenaltyDescription%>',
 			emptyText: '<%=EnterPenaltyDescription%>',
            margin:'0px 0px 5px 5px',
            maxLength: 500,
            enforceMaxLength: true,
 			labelSeparator: '',
 			id: 'penaltyDescriptionId',
 			listeners:{
					change: function(field, newValue, oldValue){
			        	 }   
			          }
 		}, {
 			xtype: 'label',
 			text: '*',
 			cls: 'mandatoryfield',
 			id: 'penaltyCostEmptyId1'
 		}, {
 			xtype: 'label',
 			text: '<%=Cost%>' + ' :',
 			cls: 'labelstyle',
 			id: 'penaltyCostLabelId',
 		}, {
 			xtype: 'numberfield',
 			cls: 'selectstylePerfect',
 			allowBlank: false,
 			blankText: '<%=EnterCost%>',
 			emptyText: '<%=EnterCost%>',
 			labelSeparator: '',
 			decimalPrecision: 3,
 			forcePrecision: true,
 			id: 'penaltyCostId'
 		}]
 	}]
 });
 var innerWinButtonPanel = new Ext.Panel({
 	id: 'winbuttonid',
 	standardSubmit: true,
 	collapsible: false,
 	autoHeight: true,
 	height: 100,
 	width: 430,
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
 						return;
 					}
 					if (Ext.getCmp('penaltyTypeComboId').getValue() == "") {
 						Ext.example.msg("<%=PenaltyName%>");
 						Ext.getCmp('penaltyTypeComboId').focus();
 						return;
 					}
 					if (Ext.getCmp('penaltyDescriptionId').getValue() == "") {
 						Ext.example.msg("<%=PenaltyDescription%>");
 						Ext.getCmp('penaltyDescriptionId').focus();
 						return;
 					}
 					if (Ext.getCmp('penaltyCostId').getRawValue() == "") {
 						Ext.example.msg("<%=EnterCost%>");
 						Ext.getCmp('penaltyCostId').focus();
 						return;
 					}
 					if (buttonValue == '<%=Add%>') {
 			 		var row = store.find('penaltyTypeDataIndex',Ext.getCmp('penaltyTypeComboId').getValue());
 					var rowfind=row+1;
 					var find =Ext.getCmp('penaltyTypeComboId').getValue();
 					 if (rowfind!=0 && Ext.getCmp('penaltyTypeComboId').getValue() == find) {
                   			 Ext.example.msg("Penalty Type already Exists  ");
                   			 return;
                    	}
                    }
 					var id;
 					var penaltyTypeModify;
 					var value;
 					if (buttonValue == '<%=Modify%>') {
 						var selected = grid.getSelectionModel().getSelected();
 						id = selected.get('IdDataIndex');
 					}
 						PenaltyMasterOuterPanelWindow.getEl().mask();
 						Ext.Ajax.request({
 							url: '<%=request.getContextPath()%>/PenaltyMasterAction.do?param=penaltyMasterAddModify',
 							method: 'POST',
 							params: {
 								buttonValue: buttonValue,
 								CustID: Ext.getCmp('custcomboId').getValue(),
 								CustName: Ext.getCmp('custcomboId').getRawValue(),
 								penaltyType: Ext.getCmp('penaltyTypeComboId').getValue(),
 								penaltyDescription: Ext.getCmp('penaltyDescriptionId').getValue(),
 								penaltyCost: Ext.getCmp('penaltyCostId').getValue(),
 								id: id,
 								jspName: jspName
 							},
 							success: function(response, options) {
 								var message = response.responseText;
 								Ext.example.msg(message);
 								Ext.getCmp('penaltyTypeComboId').reset();
 								Ext.getCmp('penaltyDescriptionId').reset();
 								Ext.getCmp('penaltyCostId').reset();
 								myWin.hide();
 								store.reload();
 								PenaltyMasterOuterPanelWindow.getEl().unmask();
 							},

 							failure: function() {
 								Ext.example.msg("Error");
 								store.reload();
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

 var PenaltyMasterOuterPanelWindow = new Ext.Panel({
 	width: 440,
 	height: 280,
 	standardSubmit: true,
 	frame: true,
 	items: [innerPanelForPenaltyMasterDetails, innerWinButtonPanel]
 });

 myWin = new Ext.Window({
 	title: 'titelForInnerPanel',
 	closable: false,
 	resizable: false,
 	modal: true,
 	autoScroll: false,
 	height: 310,
 	width: 450,
 	frame: true,
 	id: 'myWin',
 	items: [PenaltyMasterOuterPanelWindow]
 });

 function addRecord() {
 	if (Ext.getCmp('custcomboId').getValue() == "") {
 		Ext.example.msg("<%=SelectCustomer%>");
 		return;
 	}
 	buttonValue = '<%=Add%>';
 	titelForInnerPanel = '<%=AddDetails%>';
 	myWin.setPosition(450, 120);
 	myWin.show();
 	myWin.setTitle(titelForInnerPanel);
	Ext.getCmp('penaltyTypeComboId').enable();
 	Ext.getCmp('penaltyTypeComboId').reset();
 	Ext.getCmp('penaltyDescriptionId').reset();
 	Ext.getCmp('penaltyCostId').reset();

 }

 function modifyData() {
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
 	buttonValue = '<%=Modify%>';
 	titelForInnerPanel = '<%=Modify%>';
    myWin.setPosition(450, 120);
 	myWin.setTitle(titelForInnerPanel);
 	myWin.show();
    Ext.getCmp('penaltyTypeComboId').disable();
 	var selected = grid.getSelectionModel().getSelected();
 	Ext.getCmp('penaltyTypeComboId').setValue(selected.get('penaltyTypeDataIndex'));
 	Ext.getCmp('penaltyDescriptionId').setValue(selected.get('penaltyDescriptionDataIndex'));
 	Ext.getCmp('penaltyCostId').setValue(selected.get('costDataIndex'));

 }

 var reader = new Ext.data.JsonReader({
 	idProperty: 'PenaltyMasterDetails',
 	root: 'getPenaltyMasterDetails',
 	totalProperty: 'total',
 	fields: [{
 		name: 'slnoIndex'
 	}, {
 		name: 'penaltyTypeDataIndex'
 	}, {
 		name: 'penaltyDescriptionDataIndex'
 	}, {
 		name: 'costDataIndex'
 	}, {
 		name: 'IdDataIndex'
 	}, {
 		name: 'penaltyIdDataIndex'
 	}]
 });
 var store = new Ext.data.GroupingStore({
 	autoLoad: false,
 	proxy: new Ext.data.HttpProxy({
 		url: '<%=request.getContextPath()%>/PenaltyMasterAction.do?param=getPenaltyMasterDetails',
 		method: 'POST'
 	}),
 	remoteSort: false,
 	storeId: 'PenaltyMasterDetails',
 	reader: reader
 });

 var filters = new Ext.ux.grid.GridFilters({
 	local: true,
 	filters: [{
 		type: 'numeric',
 		dataIndex: 'slnoIndex'
 	}, {
 		type: 'string',
 		dataIndex: 'penaltyTypeDataIndex'
 	}, {
 		type: 'string',
 		dataIndex: 'penaltyDescriptionDataIndex'
 	}, {
 		type: 'numeric',
 		dataIndex: 'costDataIndex'
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
 		header: "<span style=font-weight:bold;><%=SLNO%></span>"
 	}, {
 		header: "<span style=font-weight:bold;><%=PenaltyName%></span>",
 		dataIndex: 'penaltyTypeDataIndex',
 		width: 80
 	}, {
 		header: "<span style=font-weight:bold;><%=PenaltyDescription%></span>",
 		dataIndex: 'penaltyDescriptionDataIndex',
 		width: 80

 	}, {
 		header: "<span style=font-weight:bold;><%=Cost%></span>",
 		dataIndex: 'costDataIndex',
 		width: 80
 	}

 	];
 	return new Ext.grid.ColumnModel({
 		columns: columns.slice(start || 0, finish),
 		defaults: {
 			sortable: true
 		}
 	});
 };

 grid = getGrid('<%=PenaltyDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 460, 21, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');


 Ext.onReady(function() {
 	ctsb = tsb;
 	Ext.QuickTips.init();
 	Ext.form.Field.prototype.msgTarget = 'side';
 	outerPanel = new Ext.Panel({
 		title: '<%=PenaltyMaster%>',
 		renderTo: 'content',
 		standardSubmit: true,
 		frame: true,
 		width: screen.width - 22,
 		cls: 'outerpanel',
 		layout: 'table',
 		layoutConfig: {
 			columns: 1
 		},
 		items: [clientPanel, grid]
 		//bbar: ctsb0
 	});
 	// sb = Ext.getCmp('form-statusbar');
 });
  </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>