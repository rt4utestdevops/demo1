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
tobeConverted.add("Terminal_Name");
tobeConverted.add("Route_Name");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Origin");
tobeConverted.add("Destination");
tobeConverted.add("Duration(HH:MM)");
tobeConverted.add("Route_Master");
tobeConverted.add("Status");
tobeConverted.add("Select_Status");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("Distance(KMs)");
tobeConverted.add("Select_Terminal_Name");
tobeConverted.add("Enter_Origin");
tobeConverted.add("Enter_Destination");
tobeConverted.add("Enter_Distance");
tobeConverted.add("Enter_Duration");
tobeConverted.add("PDF");
tobeConverted.add("Excel");
tobeConverted.add("Invalid_Destination");
tobeConverted.add("Invalid_Source");

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
String TerminalName=convertedWords.get(12);
String RouteName=convertedWords.get(13);
String EnterRouteName=convertedWords.get(14);
String Origin=convertedWords.get(15);
String Destination=convertedWords.get(16);
String Duration=convertedWords.get(17);
String RouteMaster=convertedWords.get(18);
String Status=convertedWords.get(19);
String SelectStatus=convertedWords.get(20);
String RouteMasterDetails=convertedWords.get(21);
String Kms=convertedWords.get(22);
String SelectTerminalName=convertedWords.get(23);
String EnterOrigin=convertedWords.get(24);
String EnterDestination=convertedWords.get(25);
String EnterKMS=convertedWords.get(26);
String EnterDuration=convertedWords.get(27);
String PDF=convertedWords.get(28);
String Excel=convertedWords.get(29);
String invalidDestination=convertedWords.get(30);
String invalidSource=convertedWords.get(31);
int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=RouteMaster%></title>
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
	label
		{
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height : 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
		.selectstylePerfectDropDown {
			width : 126px !important;
		}
</style>
 <script>
var outerPanel;
var jspName = "<%=RouteMaster%>";
var exportDataType = "int,string,string,string,string,float,float,string";
var grid;
var myWin;
var buttonValue;
var innerPanelForRouteMasterDetails;
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
				terminalNameStore.load({
					params: {
						CustId: custId
					}
				});
				store.load({
					params: {
						CustId: custId,
						CustName: custName,
						jspName: jspName
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
				terminalNameStore.load({
					params: {
						CustId: custId
					}
				});
				store.load({
					params: {
						CustId: custId,
						CustName: custName,
						jspName: jspName
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
		width: 40
	}]
});

var terminalNameStore = new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/TerminalRouteMasterAction.do?param=getTerminalName',
	id: 'terminalNameStoreId',
	root: 'getTerminalName',
	autoLoad: true,
	remoteSort: true,
	fields: ['TERMINAL_NAME', 'TERMINAL_ID'],
	listeners: {}
});

var terminalNameCombo = new Ext.form.ComboBox({
	store: terminalNameStore,
	id: 'terminalNameComboId',
	mode: 'local',
	forceSelection: true,
	selectOnFocus: true,
	allowBlank: false,
	anyMatch: true,
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	valueField: 'TERMINAL_ID',
	emptyText: '<%=SelectTerminalName%>',
	displayField: 'TERMINAL_NAME',
	cls: 'selectstylePerfectDropDown',
	listeners: {}
});

//store for status
var statuscombostore = new Ext.data.SimpleStore({
	id: 'statuscombostoreId',
	autoLoad: true,
	fields: ['Name', 'Value'],
	data: [
		['Active', 'Active'],
		['Inactive', 'Inactive']
	]
});

//combo definition of  status field 
var statusCombo = new Ext.form.ComboBox({
	store: statuscombostore,
	id: 'statusComboId',
	mode: 'local',
	forceSelection: true,
	emptyText: '<%=SelectStatus%>',
	blankText: '<%=SelectStatus%>',
	selectOnFocus: true,
	allowBlank: false,
	anyMatch: true,
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	valueField: 'Value',
	value: 'Active',
	displayField: 'Name',
	cls: 'selectstylePerfectDropDown',
});


var innerPanelForRouteMasterDetails = new Ext.form.FormPanel({
	standardSubmit: true,
	collapsible: false,
	autoScroll: true,
	height: 270,
	width: 400,
	frame: true,
	id: 'innerPanelForRouteMasterDetailsId',
	layout: 'table',
	resizable: true,
	layoutConfig: {
		columns: 4
	},
	items: [{
		xtype: 'fieldset',
		title: '<%=RouteMasterDetails%>',
		cls: 'fieldsetpanel',
		collapsible: false,
		colspan: 3,
		id: 'routeMasterDetailsid',
		width: 360,
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
			id: 'EmptyId1'
		}, {
			xtype: 'label',
			text: '<%=TerminalName%>' + ' :',
			cls: 'labelstyle',
			id: 'monthLabelId',
			resizable: true
		},
		terminalNameCombo, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'originEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=Origin%>' + ' :',
			cls: 'labelstyle',
			id: 'originLabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterOrigin%>',
			emptyText: '<%=EnterOrigin%>',
			labelSeparator: '',
			allowBlank: false,
			id: 'originId',
			maskRe: /[a-z0-9\s]/i,
			autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 100,
				type: "text",
				size: "100",
				autocomplete: "off"
			},
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
					Ext.getCmp('routeNameId').setValue(Ext.getCmp('originId').getValue() + "-" + Ext.getCmp('destinationId').getValue());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'destinationEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=Destination%>' + ' :',
			cls: 'labelstyle',
			id: 'destinationLabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterDestination%>',
			emptyText: '<%=EnterDestination%>',
			maskRe: /[a-z0-9\s]/i,
			labelSeparator: '',
			allowBlank: false,
			id: 'destinationId',
			autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 100,
				type: "text",
				size: "100",
				autocomplete: "off"
			},
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
					Ext.getCmp('routeNameId').setValue(Ext.getCmp('originId').getValue() + "-" + Ext.getCmp('destinationId').getValue());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'routeNameEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=RouteName%>' + ' :',
			cls: 'labelstyle',
			id: 'routeNameLabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterRouteName%>',
			emptyText: '<%=EnterRouteName%>',
			id: 'routeNameId',
			listeners: {

				change: function(field, newValue, oldValue) {
					Ext.getCmp('routeNameId').setValue(Ext.getCmp('originId').getValue() + "-" + Ext.getCmp('destinationId').getValue());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'kmstypeEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=Kms%>' + ' :',
			cls: 'labelstyle',
			id: 'kmsLabelId'
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			blankText: '<%=EnterKMS%>',
			emptyText: '<%=EnterKMS%>',
			labelSeparator: '',
			allowNegative: false,
			id: 'kmsId'
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'durationEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=Duration%>' + ' :',
			cls: 'labelstyle',
			id: 'durationLabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			regex: validatation('duration'),
			regexText: 'Duration should be number:number ex:12:30',
			//    maskRe: /(^\d{0,9}[:]?\d*)$/ ,
			blankText: '<%=EnterDuration%>',
			emptyText: '<%=EnterDuration%>',
			labelSeparator: '',
			id: 'durationId'
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'statusEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=Status%>' + ' :',
			cls: 'labelstyle',
			id: 'statusLabelId'
		},
		statusCombo]
	}]
});
var innerWinButtonPanel = new Ext.Panel({
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
					if (Ext.getCmp('terminalNameComboId').getValue() == "") {
						Ext.example.msg("<%=SelectTerminalName%>");
						Ext.getCmp('terminalNameComboId').focus();
						return;
					}
					if (Ext.getCmp('originId').getValue() == "") {
						Ext.example.msg("<%=EnterOrigin%>");
						Ext.getCmp('originId').focus();
						return;
					}
					if (Ext.getCmp('destinationId').getValue() == "") {
						Ext.example.msg("<%=EnterDestination%>");
						Ext.getCmp('destinationId').focus();
						return;
					}
					if (Ext.getCmp('routeNameId').getValue() == "") {
						Ext.example.msg("<%=EnterRouteName%>");
						Ext.getCmp('routeNameId').focus();
						return;
					}
					if (Ext.getCmp('kmsId').getValue() == "") {
						Ext.example.msg("<%=EnterKMS%>");
						Ext.getCmp('kmsId').focus();
						return;
					}
					if (Ext.getCmp('durationId').getValue() == "") {
						Ext.example.msg("<%=EnterDuration%>");
						Ext.getCmp('durationId').focus();
						return;
					}
					if (Ext.getCmp('statusComboId').getValue() == "") {
						Ext.example.msg("<%=SelectStatus%>");
						Ext.getCmp('statusComboId').focus();
						return;
					}
					var reg = /^[a-z0-9.,-\s]+$/i

					var source = Ext.getCmp('originId').getValue();
					if (!reg.test(source)) {
						Ext.example.msg("<%=invalidSource%>");
						Ext.getCmp('originId').focus();
						return;
					}

					var dest = Ext.getCmp('destinationId').getValue();
					if (!reg.test(dest)) {
						Ext.example.msg("<%=invalidDestination%>");
						Ext.getCmp('destinationId').focus();
						return;
					}
					var id;
					if (buttonValue == '<%=Modify%>') {
						var selected = grid.getSelectionModel().getSelected();
						id = selected.get('routeIdDataIndex');
					}
					if (innerPanelForRouteMasterDetails.getForm().isValid()) {
						RouteMasterOuterPanelWindow.getEl().mask();
						Ext.Ajax.request({
							url: '<%=request.getContextPath()%>/TerminalRouteMasterAction.do?param=TerminalRouteMasterDetailsAddAndModify',
							method: 'POST',
							params: {
								buttonValue: buttonValue,
								CustID: Ext.getCmp('custcomboId').getValue(),
								CustName: Ext.getCmp('custcomboId').getRawValue(),
								terminalName: Ext.getCmp('terminalNameComboId').getRawValue(),
								terminalId: Ext.getCmp('terminalNameComboId').getValue(),
								origin: Ext.getCmp('originId').getValue(),
								destination: Ext.getCmp('destinationId').getValue(),
								routeName: Ext.getCmp('routeNameId').getValue(),
								kms: Ext.getCmp('kmsId').getValue(),
								duration: Ext.getCmp('durationId').getValue(),
								status: Ext.getCmp('statusComboId').getValue(),
								id: id,
								jspName: jspName
							},
							success: function(response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
								Ext.getCmp('terminalNameComboId').reset();
								Ext.getCmp('originId').reset();
								Ext.getCmp('destinationId').reset();
								Ext.getCmp('routeNameId').reset();
								Ext.getCmp('kmsId').reset();
								Ext.getCmp('durationId').reset();
								Ext.getCmp('statusComboId').reset();
								myWin.hide();
								store.reload();
								RouteMasterOuterPanelWindow.getEl().unmask();
							},

							failure: function() {
								Ext.example.msg("Error");
								store.reload();
								myWin.hide();
							}
						});
					} else {
						Ext.example.msg("Please Enter Valid Duration Field");
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
				fn: function() {
					myWin.hide();
				}
			}
		}
	}]
});

var RouteMasterOuterPanelWindow = new Ext.Panel({
	width: 400,
	height: 340,
	standardSubmit: true,
	frame: true,
	items: [innerPanelForRouteMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
	title: 'titelForInnerPanel',
	closable: false,
	resizable: false,
	modal: true,
	autoScroll: false,
	height: 370,
	width: 410,
	id: 'myWin',
	frame: true,
	items: [RouteMasterOuterPanelWindow]
});

function addRecord() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
		Ext.example.msg("<%=SelectCustomer%>");
		return;
	}
	buttonValue = '<%=Add%>';
	titelForInnerPanel = '<%=AddDetails%>';
	myWin.setPosition(450, 150);
	myWin.show();
	myWin.setTitle(titelForInnerPanel);
	Ext.getCmp('terminalNameComboId').enable();
	Ext.getCmp('originId').enable();
	Ext.getCmp('destinationId').enable();
	Ext.getCmp('terminalNameComboId').reset();
	Ext.getCmp('originId').reset();
	Ext.getCmp('destinationId').reset();
	Ext.getCmp('routeNameId').reset();
	Ext.getCmp('kmsId').reset();
	Ext.getCmp('durationId').reset();
	Ext.getCmp('statusComboId').reset();
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
	myWin.setPosition(450, 150);
	myWin.setTitle(titelForInnerPanel);
	myWin.show();
	Ext.getCmp('terminalNameComboId').disable();
	Ext.getCmp('originId').disable();
	Ext.getCmp('destinationId').disable();
	var selected = grid.getSelectionModel().getSelected();
	Ext.getCmp('terminalNameComboId').setRawValue(selected.get('terminalNameDataIndex'));
	Ext.getCmp('originId').setValue(selected.get('originDataIndex'));
	Ext.getCmp('destinationId').setValue(selected.get('destinationDataIndex'));
	Ext.getCmp('routeNameId').setValue(selected.get('routeNameDataIndex'));
	Ext.getCmp('kmsId').setValue(selected.get('kmsDataIndex'));
	Ext.getCmp('durationId').setValue(selected.get('duratoinDataIndex'));
	Ext.getCmp('statusComboId').setValue(selected.get('statusDataIndex'));
	Ext.getCmp('terminalNameComboId').setValue(selected.get('terminalIdDataIndex'));
}

function validatation(name) {
	if (name == 'duration') {
		return /^(\d{0,2}:[0-5][0-9])$/;
		//	return /^([0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/;      //regex for 24:00
	}
}


var reader = new Ext.data.JsonReader({
	idProperty: 'TerminalRouteMasterDetails',
	root: 'getTerminalRouteMasterDetails',
	totalProperty: 'total',
	fields: [{
		name: 'slnoIndex'
	}, {
		name: 'terminalNameDataIndex'
	}, {
		name: 'routeNameDataIndex'
	}, {
		name: 'originDataIndex'
	}, {
		name: 'destinationDataIndex',
	}, {
		name: 'kmsDataIndex'
	}, {
		name: 'duratoinDataIndex'
	}, {
		name: 'statusDataIndex'
	}, {
		name: 'routeIdDataIndex'
	}, {
		name: 'terminalIdDataIndex'
	}, {
		name: 'idDataIndex'
	}]
});

var store = new Ext.data.GroupingStore({
	autoLoad: false,
	proxy: new Ext.data.HttpProxy({
		url: '<%=request.getContextPath()%>/TerminalRouteMasterAction.do?param=getTerminalRouteMasterDetails',
		method: 'POST'
	}),
	remoteSort: false,
	storeId: 'TerminalRouteMasterDetails',
	reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
	local: true,
	filters: [{
		type: 'numeric',
		dataIndex: 'slnoIndex'
	}, {
		type: 'string',
		dataIndex: 'terminalNameDataIndex'
	}, {
		type: 'string',
		dataIndex: 'routeNameDataIndex'
	}, {
		type: 'string',
		dataIndex: 'originDataIndex'
	}, {
		type: 'string',
		dataIndex: 'destinationDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'kmsDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'duratoinDataIndex'
	}, {
		type: 'string',
		dataIndex: 'statusDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'routeIdDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'terminalIdDataIndex'
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
		header: "<span style=font-weight:bold;><%=TerminalName%></span>",
		dataIndex: 'terminalNameDataIndex',
		width: 80,

	}, {
		header: "<span style=font-weight:bold;><%=RouteName%></span>",
		dataIndex: 'routeNameDataIndex',
		width: 80,

	}, {
		header: "<span style=font-weight:bold;><%=Origin%></span>",
		dataIndex: 'originDataIndex',
		width: 80,

	}, {
		header: "<span style=font-weight:bold;><%=Destination%></span>",
		dataIndex: 'destinationDataIndex',
		width: 80,
	}, {
		header: "<span style=font-weight:bold;><%=Kms%></span>",
		dataIndex: 'kmsDataIndex',
		width: 80,
	}, {
		header: "<span style=font-weight:bold;><%=Duration%></span>",
		dataIndex: 'duratoinDataIndex',
		width: 80,
	}, {
		header: "<span style=font-weight:bold;><%=Status%></span>",
		dataIndex: 'statusDataIndex',
		width: 80,

	}];
	return new Ext.grid.ColumnModel({
		columns: columns.slice(start || 0, finish),
		defaults: {
			sortable: true
		}
	});
};


grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 400, 21, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');

Ext.onReady(function() {
	ctsb = tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	outerPanel = new Ext.Panel({
		title: '<%=RouteMaster%>',
		renderTo: 'content',
		standardSubmit: true,
		frame: true,
		width: screen.width - 28,
		height: 540,
		cls: 'outerpanel',
		layout: 'table',
		layoutConfig: {
			columns: 1
		},
		items: [clientPanel, grid]
		//bbar: ctsb
	});
	sb = Ext.getCmp('form-statusbar');
});
  </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>