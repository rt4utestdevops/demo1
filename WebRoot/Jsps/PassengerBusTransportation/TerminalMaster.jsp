<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
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
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Terminal_Master");
tobeConverted.add("SLNO");
tobeConverted.add("Location");
tobeConverted.add("Terminal_Name");
tobeConverted.add("Terminal_ID");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Modify");
tobeConverted.add("Status");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Select_Customer");
tobeConverted.add("Terminal_Master_Details");
tobeConverted.add("Enter_Terminal_Name");
tobeConverted.add("Enter_Location");
tobeConverted.add("Select_Status");
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("Error");
tobeConverted.add("Cancel");
tobeConverted.add("Add_Details");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Enter_Terminal_Id");
tobeConverted.add("Save");
tobeConverted.add("Id");
tobeConverted.add("Customer_Name");
tobeConverted.add("Invalid_Terminal_Name");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String TerminalMaster=convertedWords.get(0);
String SLNO=convertedWords.get(1);
String Location=convertedWords.get(2);
String TerminalName=convertedWords.get(3);
String TerminalId=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String Add=convertedWords.get(6);
String Excel=convertedWords.get(7);
String PDF=convertedWords.get(8);
String NoRecordFound=convertedWords.get(9);
String Modify=convertedWords.get(10);
String Status=convertedWords.get(11);
String SelectCustomerName=convertedWords.get(12);
String CustomerName=convertedWords.get(13);
String TerminalMasterDetails=convertedWords.get(14);
String EnterTerminalName=convertedWords.get(15);
String EnterLocation=convertedWords.get(16);
String SelectStatus=convertedWords.get(17);
String ValidateMesgForForm=convertedWords.get(18);
String Error=convertedWords.get(19);
String Cancel=convertedWords.get(20);
String AddDetails=convertedWords.get(21);
String NoRowSelected=convertedWords.get(22);
String SelectSingleRow=convertedWords.get(23);
String ModifyDetails=convertedWords.get(24);
String EnterTerminalId=convertedWords.get(25);
String Save=convertedWords.get(26);
String Id=convertedWords.get(27);
String CustName=convertedWords.get(28);
String invalidTerminalName=convertedWords.get(29);
%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=TerminalMaster%></title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}	
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
		
  </style>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <jsp:include page="../Common/ExportJS.jsp" />

	
   <script>
var outerPanel;
var ctsb;
var jspName = "<%=TerminalMaster%>";
var exportDataType = "int,int,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var statusValue;
var clientcombostore = new Ext.data.JsonStore({
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
				store.load({
					params: {
						CustId: custId,
						jspName: jspName,
						custname: Ext.getCmp('custcomboId').getRawValue()
					}
				});
			}
		}
	}
});

var Client = new Ext.form.ComboBox({
	store: clientcombostore,
	id: 'custcomboId',
	mode: 'local',
	forceSelection: true,
	emptyText: '<%=SelectCustomerName%>',
	blankText: '<%=SelectCustomerName%>',
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
						CustId: custId,
						jspName: jspName,
						custname: Ext.getCmp('custcomboId').getRawValue()
					}
				});
			}
		}
	}
});
var StatusStore = new Ext.data.SimpleStore({
	id: 'StatusStorId',
	fields: ['Name', 'Value'],
	autoLoad: true,
	data: [
		['Active', 'Active'],
		['Inactive', 'Inactive']
	]
});

var Status = new Ext.form.ComboBox({
	frame: true,
	store: StatusStore,
	id: 'StatusId',
	width: 150,
	cls: 'selectstylePerfect',
	hidden: false,
	allowBlank: false,
	anyMatch: true,
	onTypeAhead: true,
	forceSelection: true,
	enableKeyEvents: true,
	mode: 'local',
	emptyText: '<%=SelectStatus%>',
	triggerAction: 'all',
	displayField: 'Name',
	value: 'Active',
	valueField: 'Value',
	listeners: {
		select: {
			fn: function() {
				statusValue = Ext.getCmp('StatusId').getValue();
			}
		}
	}
});



var customerComboPanel = new Ext.Panel({
	standardSubmit: true,
	collapsible: false,
	id: 'customerComboPanelId',
	layout: 'table',
	frame: false,
	width: screen.width - 12,
	height: 50,
	layout: 'table',
	layoutConfig: {
		columns: 3
	},
	items: [{
		xtype: 'label',
		text: '<%=CustName%>' + ' :',
		cls: 'labelstyle'
	}, {
		width: 10
	},
	Client

	]
});
var reader = new Ext.data.JsonReader({
	idProperty: 'terminalMasterReaderid',
	root: 'terminalMasterDetails',
	totalProperty: 'total',
	fields: [{
		name: 'slnoIndex',
	}, {
		name: 'idIndex'
	}, {
		name: 'terminalIdDataIndex'
	}, {
		name: 'terminalNameDataIndex'
	}, {
		name: 'locationDataIndex'
	}, {
		name: 'StatusDataIndex'
	}]
});

var filters = new Ext.ux.grid.GridFilters({
	local: true,
	filters: [{
		type: 'numeric',
		dataIndex: 'slnoIndex'
	}, {
		type: 'numeric',
		dataIndex: 'idIndex'
	}, {
		type: 'string',
		dataIndex: 'terminalIdDataIndex'
	}, {
		type: 'string',
		dataIndex: 'terminalNameDataIndex'
	}, {
		type: 'string',
		dataIndex: 'locationDataIndex'
	}, {
		type: 'string',
		dataIndex: 'StatusDataIndex'
	}]
});
var store = new Ext.data.GroupingStore({
	autoLoad: true,
	proxy: new Ext.data.HttpProxy({
		url: '<%=request.getContextPath()%>/TerminalMasterAction.do?param=getTerminaMasterDetails',
		method: 'POST'
	}),
	storeId: 'terminalmasterid',
	reader: reader
});




var createColModel = function(finish, start) {
	var columns = [
	new Ext.grid.RowNumberer({
		header: "<span style=font-weight:bold;><%=SLNO%></span>",
		width: 50
	}), {
		dataIndex: 'slnoIndex',
		width: 30,
		hidden: true,
		header: "<span style=font-weight:bold;><%=SLNO%></span>",
		filter: {
			type: 'numeric'
		}
	}, {
		header: "<span style=font-weight:bold;><%=Id%></span>",
		dataIndex: 'idIndex',
		hidden: true,
		width: 30,
		filter: {
			type: 'int'
		}
	}, {
		dataIndex: 'terminalIdDataIndex',
		header: "<span style=font-weight:bold;><%=TerminalId%></span>",
		width: 100,
		filter: {
			type: 'string'
		}
	}, {
		header: "<span style=font-weight:bold;><%=TerminalName%></span>",
		dataIndex: 'terminalNameDataIndex',
		width: 100,
		filter: {
			type: 'string'
		}
	}, {
		header: "<span style=font-weight:bold;><%=Location%></span>",
		dataIndex: 'locationDataIndex',
		width: 100,
		filter: {
			type: 'string'
		}
	}, {
		header: "<span style=font-weight:bold;><%=Status%></span>",
		dataIndex: 'StatusDataIndex',
		width: 100,
		filter: {
			type: 'string'
		}
	}];
	return new Ext.grid.ColumnModel({
		columns: columns.slice(start || 0, finish),
		defaults: {
			sortable: true
		}
	});
};
var innerPanelForTerminalMasterDetails = new Ext.form.FormPanel({
	standardSubmit: true,
	collapsible: false,
	autoScroll: true,
	height: 170,
	width: 450,
	frame: true,
	id: 'innerPanelForTerminalMasterId',
	layout: 'table',
	layoutConfig: {
		columns: 4
	},
	items: [{
		xtype: 'fieldset',
		title: '<%=TerminalMasterDetails%>',
		cls: 'fieldsetpanel',
		collapsible: false,
		id: 'TerminalDetailsId',
		width: 350,
		height: 160,
		layout: 'table',
		layoutConfig: {
			columns: 3
		},
		items: [{
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'Id2'
		}, {
			xtype: 'label',
			text: '<%=TerminalId%>' + ' :',
			cls: 'labelstyle',
			id: 'Id1'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterTerminalId%>',
			emptyText: '<%=EnterTerminalId%>',
			labelSeparator: '',
			autoCreate: {
				tag: "input",
				maxlength: 50,
				type: "text",
				size: "50",
				autocomplete: "off"
			},
			allowBlank: false,
			maskRe: /[a-z0-9\s]/i,
			id: 'TerminalId1',
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'Id4'
		}, {
			xtype: 'label',
			text: '<%=TerminalName%>' + ' :',
			cls: 'labelstyle',
			id: 'terminalNamelabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			blankText: '<%=EnterTerminalName%>',
			emptyText: '<%=EnterTerminalName%>',
			allowBlank: false,
			labelSeparator: '',
			autoCreate: { //restricts user to 20 chars max, cannot enter 21st char
				tag: "input",
				maxlength: 100,
				type: "text",
				size: "100",
				autocomplete: "off"
			},
			allowBlank: false,
			maskRe: /[a-z0-9\s]/i,
			id: 'TerminalNameId',
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'Id6'
		}, {
			xtype: 'label',
			text: '<%=Location%>' + ' :',
			cls: 'labelstyle',
			id: 'LocationLabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			blankText: '<%=EnterLocation%>',
			emptyText: '<%=EnterLocation%>',
			allowBlank: false,
			maskRe: /[a-z0-9\s]/i,
			labelSeparator: '',
			autoCreate: {
				tag: "input",
				maxlength: 500,
				type: "text",
				size: "500",
				autocomplete: "off"
			},
			id: 'LocationId',
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'Id7'
		}, {
			xtype: 'label',
			text: '<%=Status%>' + ' :',
			cls: 'labelstyle',
			id: 'StatusLabelId'
		},
		Status]
	}]
});

var innerWinButtonPanel = new Ext.Panel({
	id: 'innerWinButtonPanelId',
	standardSubmit: true,
	collapsible: false,
	autoHeight: true,
	height: 10,
	width: 350,
	frame: false,
	layout: 'table',
	layoutConfig: {
		columns: 4
	},
	buttons: [{
		xtype: 'button',
		text: '<%=Save%>',
		iconCls: 'savebutton',
		id: 'saveButtonId',
		cls: 'buttonstyle',
		width: 70,
		listeners: {
			click: {
				fn: function() {
					if (Ext.getCmp('TerminalId1').getValue() == "") {
						Ext.example.msg("<%=EnterTerminalId%>");
						Ext.getCmp('TerminalId1').focus();
						return;
					}
					if (Ext.getCmp('TerminalNameId').getValue() == "") {
						Ext.example.msg("<%=EnterTerminalName%>");
						Ext.getCmp('TerminalNameId').focus();
						return;
					}
					if (Ext.getCmp('LocationId').getValue() == "") {
						Ext.example.msg("<%=EnterLocation%>");
						Ext.getCmp('LocationId').focus();
						return;
					}
					if (Ext.getCmp('StatusId').getValue() == "") {
						Ext.example.msg("<%=SelectStatus%>");
						Ext.getCmp('StatusId').focus();
						return;
					}
					var reg = /^[a-z0-9.,-\s]+$/i
					var terminalName = Ext.getCmp('TerminalNameId').getValue();
					if (!reg.test(terminalName)) {
						Ext.example.msg("<%=invalidTerminalName%>");
						Ext.getCmp('TerminalNameId').focus();
						return;
					}
					if (innerPanelForTerminalMasterDetails.getForm().isValid()) {
						var seletedTerminalName;
						var selectedTerminalID;
						var selectedLocation;
						var selectedStatus;
						var id;

						if (buttonValue == '<%=Modify%>') {
							var selected = grid.getSelectionModel().getSelected();
							id = selected.get('idIndex');
							seletedTerminalName = selected.get('terminalIdDataIndex');
							selectedTerminalID = selected.get('terminalNameDataIndex');
							selectedLocation = selected.get('locationDataIndex');
							selectedStatus = selected.get('StatusDataIndex');

						}
						manageTerminalMasterOuterPanelWindow.getEl().mask();
						Ext.Ajax.request({
							url: '<%=request.getContextPath()%>/TerminalMasterAction.do?param=TerminalDetailsAddAndModify',
							method: 'POST',
							params: {
								CustId: custId,
								buttonValue: buttonValue,
								terminalName: Ext.getCmp('TerminalNameId').getValue(),
								terminalId: Ext.getCmp('TerminalId1').getValue(),
								id: id,
								location: Ext.getCmp('LocationId').getValue(),
								status: Ext.getCmp('StatusId').getValue(),
								gridStatus: statusValue

							},
							success: function(response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
								Ext.getCmp('TerminalNameId').reset();
								Ext.getCmp('TerminalId1').reset();
								Ext.getCmp('LocationId').reset();
								Ext.getCmp('StatusId').reset();
								myWin.hide();
								manageTerminalMasterOuterPanelWindow.getEl().unmask();
								store.reload()({
									params: {
										CustId: custId
									}
								});
							},
							failure: function() {
								Ext.example.msg("<%=Error%>");
								store.reload();
								myWin.hide();
							}
						});
					} else {
						Ext.example.msg("<%=ValidateMesgForForm%>");
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

var manageTerminalMasterOuterPanelWindow = new Ext.Panel({
	width: 370,
	height: 220,
	standardSubmit: true,
	frame: true,
	items: [innerPanelForTerminalMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
	title: titelForInnerPanel,
	closable: false,
	resizable: false,
	modal: true,
	autoScroll: false,
	frame: true,
	height: 270,
	width: 390,
	id: 'myWin',
	items: [manageTerminalMasterOuterPanelWindow]
});

function addRecord() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
		Ext.example.msg("<%=SelectCustomerName%>");
		Ext.getCmp('custcomboId').focus();
		return;
	}

	buttonValue = '<%=Add%>';
	titelForInnerPanel = '<%=AddDetails%>';
	myWin.setPosition(460, 200);
	myWin.show();
	Ext.getCmp('TerminalId1').enable();
	Ext.getCmp('TerminalNameId').enable();
	myWin.setTitle(titelForInnerPanel);
	Ext.getCmp('TerminalId1').reset();
	Ext.getCmp('TerminalNameId').reset();
	Ext.getCmp('LocationId').reset();
	Ext.getCmp('StatusId').reset();

}

function modifyData() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
		Ext.example.msg("<%=SelectCustomerName%>");
		Ext.getCmp('custcomboId').focus();
		return;
	}
	if (grid.getSelectionModel().getCount() == 0) {
		Ext.example.msg("<%=NoRowSelected%>");
		return;
	}
	if (grid.getSelectionModel().getCount() > 1) {
		Ext.example.msg("<%=SelectSingleRow%>");
		return;
	}

	buttonValue = '<%=Modify%>';
	titelForInnerPanel = '<%=ModifyDetails%>';
	myWin.setPosition(460, 200);
	myWin.setTitle(titelForInnerPanel);
	myWin.show();
	Ext.getCmp('TerminalId1').disable();
	Ext.getCmp('TerminalNameId').disable();
	var selected = grid.getSelectionModel().getSelected();
	Ext.getCmp('TerminalId1').setValue(selected.get('terminalIdDataIndex'));
	Ext.getCmp('TerminalNameId').setValue(selected.get('terminalNameDataIndex'));
	Ext.getCmp('LocationId').setValue(selected.get('locationDataIndex'));
	Ext.getCmp('StatusId').setValue(selected.get('StatusDataIndex'));
	statusValue = selected.get('StatusDataIndex');
}

//*****************************************************************Grid *******************************************************************************
grid = getGrid(
	'<%=TerminalMaster%>',
	'<%=NoRecordFound%>',
store,
screen.width - 40,
400,
7,
filters,
	'<%=ClearFilterData%>',
false,
	'',
9,
false,
	'',
false,
	'',
true,
	'<%=Excel%>',
jspName,
exportDataType,
true,
	'<%=PDF%>',
true,
	'<%=Add%>',
true,
	'<%=Modify%>',
false,
	'');
//******************************************************************************************************************************************************
Ext.onReady(function() {
	ctsb = tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	outerPanel = new Ext.Panel({
		title: '<%=TerminalMaster%>',
		renderTo: 'content',
		standardSubmit: true,
		frame: true,
		width: screen.width - 22,
		height: 520,
		cls: 'outerpanel',
		layout: 'table',
		layoutConfig: {
			columns: 1
		},
		items: [customerComboPanel, grid]
	});
	sb = Ext.getCmp('form-statusbar');
});
 </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
