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
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");

tobeConverted.add("Total");
tobeConverted.add("Hub_Id");
tobeConverted.add("Select_Hub_Name");
tobeConverted.add("Vehicle_No");
tobeConverted.add("select_vehicle_No");

tobeConverted.add("Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Enter_Amount");
tobeConverted.add("Hub_Name");
tobeConverted.add("Submit");

tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Hub_Maintenance_Report");
tobeConverted.add("Hub_Maintenance_Details");
tobeConverted.add("Comments");
tobeConverted.add("Enter_Comments");

tobeConverted.add("Car_dirty");
tobeConverted.add("Key_Lost");
tobeConverted.add("Car_Dent");
tobeConverted.add("Car_Scratch");
tobeConverted.add("Towing");

tobeConverted.add("Car_Puncture");
tobeConverted.add("Refuel");
tobeConverted.add("Local_Conveyance");
tobeConverted.add("Car_Washing");
tobeConverted.add("Others");


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
String StartDate=convertedWords.get(12);
String EndDate=convertedWords.get(13);
String SelectStartDate=convertedWords.get(14);
String SelectEndDate=convertedWords.get(15);

String Total=convertedWords.get(16);
String HubId=convertedWords.get(17);
String SelectHub=convertedWords.get(18);
String vehicleNo=convertedWords.get(19);
String selectvehicleNo=convertedWords.get(20);

String Date=convertedWords.get(21);
String MonthValidation=convertedWords.get(22);
String EnterAmount=convertedWords.get(23);
String HubName=convertedWords.get(24);
String Submit=convertedWords.get(25);

String SelectCustomerName=convertedWords.get(26);
String HubMaintenanceReport=convertedWords.get(27);
String HubMaintenanceDetails=convertedWords.get(28);
String comments=convertedWords.get(29);
String EnterComments=convertedWords.get(30);

String Car_dirty=convertedWords.get(31);
String Key_Lost=convertedWords.get(32);
String Car_Dent=convertedWords.get(33);
String Car_Scratch=convertedWords.get(34);
String Towing=convertedWords.get(35);

String Car_Puncture=convertedWords.get(36);
String Refuel=convertedWords.get(37);
String Local_Conveyance=convertedWords.get(38);
String Car_Washing=convertedWords.get(39);
String Others=convertedWords.get(40);


int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=HubMaintenanceReport%></title>
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
		<%}%>
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
			label {
				display : inline !important;
			}
		
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				//height : 56px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-panel-btns {
				//margin-top : -16px !important;
			}
			.x-window-ml {
				//padding-top : 21px !important;
			}
			div#myWin {
				top : 74px !important;
			}
			.x-layer ul {
		 		min-height: 27px !important;
			}		
			.x-menu-list {
				height:auto !important;
			}
		 </style>
 <script>
var outerPanel;
var jspName = "Hub Maintenance Report";
var exportDataType = "int,int,string,string,number,number,number,number,number,number,number,number,number,string,number";
var grid;
var myWin;
var buttonValue;
var id;
var dtprev = dateprev;
var dtcur = datecur;
var hubIdModify;
var hubNameModify;
var keyLostValue = 1000;
var keyLostEmptyValue = 0;
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
				hubStore.load({
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
				hubStore.load({
					params: {
						CustId: custId
					}
				});
				store.load();
			}
		}
	}
});

var hubStore = new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/HubMaintenanceAction.do?param=gethubNames',
	id: 'hubTypeStore',
	root: 'gethubNames',
	autoLoad: true,
	remoteSort: true,
	fields: ['HUB_ID', 'HUB_NAME'],
	listeners: {
		select: {
			fn: function() {
				hubId = Ext.getCmp('hubtypeComboId').getValue();
				hubName = Ext.getCmp('hubtypeComboId').getRawValue();
				vehicleStore.load({
					params: {
						hubId: hubId

					}
				});
			}
		}
	}
});

var hubTypeCombo = new Ext.form.ComboBox({
	store: hubStore,
	id: 'hubtypeComboId',
	mode: 'local',
	selectOnFocus: true,
	allowBlank: false,
	anyMatch: true,
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	valueField: 'HUB_ID',
	emptyText: '<%=SelectHub%>',
	displayField: 'HUB_NAME',
	cls: 'selectstylePerfectDropDown',
	resizable:true,
    height: 350,
    width:400,
	listeners: {
		select: {
			fn: function() {
				hubId = Ext.getCmp('hubtypeComboId').getValue();
				hubName = Ext.getCmp('hubtypeComboId').getRawValue();
				vehicleStore.load({
					params: {
						hubId: hubId,
						CustId: Ext.getCmp('custcomboId').getValue()
					}
				});
				store.load();
			}
		}
	}
});
var vehicleStore = new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/HubMaintenanceAction.do?param=getVehicleNo',
	id: 'vehicleStoreId',
	root: 'VehicleNo',
	autoLoad: true,
	remoteSort: true,
	fields: ['VehicleNo', 'VehicleNo'],
	listeners: {}
});

var VehicleNoCombo = new Ext.form.ComboBox({
	store: vehicleStore,
	id: 'veicleComboId',
	mode: 'local',
	forceSelection: true,
	selectOnFocus: true,
	allowBlank: false,
	anyMatch: true,
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	valueField: 'VehicleNo',
	emptyText: '<%=selectvehicleNo%>',
	displayField: 'VehicleNo',
	cls: 'selectstylePerfectDropDown',
});


var MenuPanel = new Ext.Panel({
	standardSubmit: true,
	collapsible: false,
	id: 'customerComboPanelId',
	layout: 'table',
	frame: false,
	width: screen.width - 40,
	height: 40,
	layoutConfig: {
		columns: 20
	},
	items: [{
		xtype: 'label',
		cls: 'labelstyle',
		id: 'customercomboid',
		text: '<%=CustomerName%> ' + ':'
	},
	custnamecombo, {
		width: 30
	}, {
		xtype: 'label',
		cls: 'labelstyle',
		id: 'hubLabelId',
		text: '<%=HubName%>' + ':'
	},
	hubTypeCombo, {
		width: 30
	}, {
		xtype: 'label',
		cls: 'labelstyle',
		id: 'startdatelab',
		text: '<%=StartDate%>' + ' :' 
	}, {
		xtype: 'datefield',
		cls: 'selectstylePerfect',
		frame: true,
		width: 185,
		resizable: true,
		format: getDateTimeFormat(),
		emptyText: '<%=SelectStartDate%>',
		allowBlank: false,
		blankText: '<%=SelectStartDate%>',
		id: 'startdate',
		vtype: 'daterange',
		value: dtprev,
		endDateField: 'enddate'
	}, {
		width: 52
	}, {
		xtype: 'label',
		cls: 'labelstyle',
		id: 'enddatelab',
		text: '<%=EndDate%>' + ' :'
	}, {
		xtype: 'datefield',
		cls: 'selectstylePerfect',
		width: 185,
		format: getDateTimeFormat(),
		emptyText: '<%=SelectEndDate%>',
		allowBlank: false,
		blankText: '<%=SelectEndDate%>',
		id: 'enddate',
		vtype: 'daterange',
		value: datecur,
		startDateField: 'startdate'
	}, {
		width: 52
	}, {
		xtype: 'button',
		text: '<%=Submit%>', 
		id: 'addbuttonid',
		cls: ' ',
		width: 80,
		listeners: {
			click: {
				fn: function() {

					if (Ext.getCmp('custcomboId').getValue() == "") {
						Ext.example.msg("<%=SelectCustomerName%>"); 
						Ext.getCmp('custcomboId').focus();
						return;
					}
					if (Ext.getCmp('hubtypeComboId').getValue() == "") {
						Ext.example.msg("<%=SelectHub%>"); 
						Ext.getCmp('hubtypeComboId').focus();
						return;
					}
					if (Ext.getCmp('startdate').getValue() == "") {
						Ext.example.msg("<%=SelectStartDate%>");
						Ext.getCmp('startdate').focus();
						return;
					}
					if (Ext.getCmp('enddate').getValue() == "") {
						Ext.example.msg("<%=SelectEndDate%>");
						Ext.getCmp('enddate').focus();
						return;
					}
					var startdates = Ext.getCmp('startdate').getValue();
					var enddates = Ext.getCmp('enddate').getValue();


					if (checkMonthValidation(startdates, enddates)) {
						Ext.example.msg("<%=MonthValidation%>"); 
						Ext.getCmp('enddate').focus();
						return;
					}
					store.removeAll();  		                      
					store.load({
						params: {
							CustId: Ext.getCmp('custcomboId').getValue(),
							custName: Ext.getCmp('custcomboId').getRawValue(),
							HubId: Ext.getCmp('hubtypeComboId').getValue(),
							HubName: Ext.getCmp('hubtypeComboId').getRawValue(),
							startDate: startdates,
							endDate: enddates,
							jspName: jspName
						}
					});

				}
			}
		}
	}]
});
var innerPanelForHubExpensiveDetails = new Ext.form.FormPanel({
	standardSubmit: true,
	collapsible: false,
	autoScroll: true,
	height: 420,
	width: 450,
	frame: true,
	id: 'innerPanelForHubExpensiveDetailsId',
	layout: 'table',
	resizable: true,
	layoutConfig: {
		columns: 4
	},
	items: [{
		xtype: 'fieldset',
		title: '<%=HubMaintenanceDetails%> ', 						
		cls: 'fieldsetpanel',
		collapsible: false,
		colspan: 3,
		id: 'hubExpenseDetilsid',
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
			id: 'vehicleEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=vehicleNo%>' + ' :', 					
			cls: 'labelstyle',
			id: 'vehicleLabelId',
		},
		VehicleNoCombo,{
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Key_Lost%>' + ' :', 				
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 
			labelSeparator: '',
			allowBlank: false,
			id: 'keyLostId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Car_Dent%>' + ' :', 				
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 
			labelSeparator: '',
			allowBlank: false,
			id: 'carDentId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Car_Scratch%>' + ' :', 			
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 				
			labelSeparator: '',
			allowBlank: false,
			id: 'carScratchId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Towing%>' + ' :',						
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 
			labelSeparator: '',
			allowBlank: false,
			id: 'towingId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Car_Puncture%>' + ' :',				 
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 					
			labelSeparator: '',
			allowBlank: false,
			id: 'carPunctureId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: ' <%=Refuel%>' + ' :', 
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 
			labelSeparator: '',
			allowBlank: false,
			id: 'refuelId'


		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Local_Conveyance%>' + ' :', 			
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 
			labelSeparator: '',
			allowBlank: false,
			id: 'localConveyanceId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Car_Washing%>' + ' :', 				
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 				
			labelSeparator: '',
			allowBlank: false,
			id: 'carWashingId'
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Others%>' + ' :', 
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterAmount%>',
			emptyText: '<%=EnterAmount%>', 
			labelSeparator: '',
			allowBlank: false,
			id: 'ortherServiceId'
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'commentEmptyId1'
		}, {
			xtype: 'label',
			text: '<%=comments%>' + ' :',						 
			cls: 'labelstyle',
			id: 'commentLabelId'
		}, {
			xtype: 'textarea',
			cls: 'selectstylePerfect',
			blankText: '<%=EnterComments%>',
			emptyText: '<%=EnterComments%>',                      
			id: 'commentId',
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
				}
			}
		}]
	}]
});
var innerWinButtonPanel = new Ext.Panel({
	id: 'winbuttonid',
	standardSubmit: true,
	collapsible: false,
	autoHeight: true,
	height: 80,
	width: 450,
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
					if (Ext.getCmp('veicleComboId').getValue() == "") {
						Ext.example.msg("<%=selectvehicleNo%>");
						Ext.getCmp('veicleComboId').focus();
						return;
					}
					if (Ext.getCmp('commentId').getValue() == "") {
						Ext.example.msg("<%=EnterComments%>");
						Ext.getCmp('commentId').focus();
						return;
					}


					var id;

					if (buttonValue == '<%=Modify%>') {
						var selected = grid.getSelectionModel().getSelected();
						id = selected.get('IdDataIndex');
						if (selected.get('hubIdDataIndex') != Ext.getCmp('hubtypeComboId').getValue()) {
							hubIdModify = selected.get('hubIdDataIndex');
						} else {
							hubIdModify = selected.get('hubIdDataIndex');
						}
					}
					HubExpenseMasterOuterPanelWindow.getEl().mask();
					Ext.Ajax.request({
						url: '<%=request.getContextPath()%>/HubMaintenanceAction.do?param=hubExpenseMasterAddModify',
						method: 'POST',
						params: {
							buttonValue: buttonValue,
							CustID: Ext.getCmp('custcomboId').getValue(),
							hubId: Ext.getCmp('hubtypeComboId').getValue(),
							vehicleNo: Ext.getCmp('veicleComboId').getValue(),
							comments: Ext.getCmp('commentId').getValue(),
							keyLost: Ext.getCmp('keyLostId').getValue(),
							carDent: Ext.getCmp('carDentId').getValue(),
							carScrathch: Ext.getCmp('carScratchId').getValue(),
							towing: Ext.getCmp('towingId').getValue(),
							carPuncture: Ext.getCmp('carPunctureId').getValue(),
							refuel: Ext.getCmp('refuelId').getValue(),
							localConveyance: Ext.getCmp('localConveyanceId').getValue(),
							carWashing: Ext.getCmp('carWashingId').getValue(),
							other: Ext.getCmp('ortherServiceId').getValue(),
							hubIdModify: hubIdModify,
							id: id,
							jspName: jspName
						},
						success: function(response, options) {
							var message = response.responseText;
							Ext.example.msg(message);
							Ext.getCmp('veicleComboId').reset();
							Ext.getCmp('commentId').reset();
							Ext.getCmp('keyLostId').reset();
							Ext.getCmp('carDentId').reset();
							Ext.getCmp('carScratchId').reset();
							Ext.getCmp('towingId').reset();
							Ext.getCmp('carPunctureId').reset();
							Ext.getCmp('refuelId').reset();
							Ext.getCmp('localConveyanceId').reset();
							Ext.getCmp('carWashingId').reset();
							Ext.getCmp('ortherServiceId').reset();

							myWin.hide();
							store.reload();
							HubExpenseMasterOuterPanelWindow.getEl().unmask();
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

var HubExpenseMasterOuterPanelWindow = new Ext.Panel({
	width: 460,
	height: 510,
	standardSubmit: true,
	frame: true,
	items: [innerPanelForHubExpensiveDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
	title: 'titelForInnerPanel',
	closable: false,
	resizable: false,
	modal: true,
	autoScroll: false,
	height: 520,
	width: 480,
	id: 'myWin',
	frame: true,
	items: [HubExpenseMasterOuterPanelWindow]
});

function addRecord() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
		Ext.example.msg("<%=SelectCustomer%>");
		return;
	}
	if (Ext.getCmp('hubtypeComboId').getValue() == "") {
		Ext.example.msg("<%=SelectHub%>");
		Ext.getCmp('hubtypeComboId').focus();
		return;
	}
	if (Ext.getCmp('startdate').getValue() == "") {
		Ext.example.msg("<%=SelectStartDate%>");
		Ext.getCmp('startdate').focus();
		return;
	}
	if (Ext.getCmp('enddate').getValue() == "") {
		Ext.example.msg("<%=SelectEndDate%>");
		Ext.getCmp('enddate').focus();
		return;
	}
	buttonValue = '<%=Add%>';
	titelForInnerPanel = '<%=AddDetails%>';
	myWin.setPosition(450, 30);
	myWin.show();
	Ext.getCmp('veicleComboId').enable();
	myWin.setTitle(titelForInnerPanel);
	Ext.getCmp('veicleComboId').reset();
	Ext.getCmp('commentId').reset();
	Ext.getCmp('keyLostId').reset();
	Ext.getCmp('carDentId').reset();
	Ext.getCmp('carScratchId').reset();
	Ext.getCmp('towingId').reset();
	Ext.getCmp('carPunctureId').reset();
	Ext.getCmp('refuelId').reset();
	Ext.getCmp('localConveyanceId').reset();
	Ext.getCmp('carWashingId').reset();
	Ext.getCmp('ortherServiceId').reset();
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
	myWin.setPosition(450, 30);
	myWin.setTitle(titelForInnerPanel);
	myWin.show();
	Ext.getCmp('veicleComboId').disable();
	var selected = grid.getSelectionModel().getSelected();
	Ext.getCmp('hubtypeComboId').setValue(selected.get('hubIdDataIndex'));
	Ext.getCmp('veicleComboId').setValue(selected.get('vehicleNoDataIndex'));
	Ext.getCmp('commentId').setValue(selected.get('commentDataIndex'));
	Ext.getCmp('keyLostId').setValue(selected.get('keyLostDataIndex'));
	Ext.getCmp('carDentId').setValue(selected.get('carDentDataIndex'));
	Ext.getCmp('carScratchId').setValue(selected.get('carScratchDataIndex'));
	Ext.getCmp('towingId').setValue(selected.get('towingDataIndex'));
	Ext.getCmp('carPunctureId').setValue(selected.get('carPunctureDataIndex'));
	Ext.getCmp('refuelId').setValue(selected.get('refuelDataIndex'));
	Ext.getCmp('localConveyanceId').setValue(selected.get('loacalConveyanceDataIndex'));
	Ext.getCmp('carWashingId').setValue(selected.get('carWashingDataIndex'));
	Ext.getCmp('ortherServiceId').setValue(selected.get('otherServiceDataIndex'));

}

var reader = new Ext.data.JsonReader({
	idProperty: 'hubExpenseMasterDetails',
	root: 'getHubExpenseDetails',
	totalProperty: 'total',
	fields: [{
		name: 'slnoIndex'
	}, {
		name: 'hubIdDataIndex'
	}, {
		name: 'commentDataIndex'
	}, {
		name: 'vehicleNoDataIndex'
	}, {
		name: 'IdDataIndex'
	}, , {
		name: 'carDirtyDataIndex'
	}, {
		name: 'keyLostDataIndex'
	}, {
		name: 'carDentDataIndex'
	}, {
		name: 'carScratchDataIndex'
	}, {
		name: 'towingDataIndex'
	}, {
		name: 'carPunctureDataIndex'
	}, {
		name: 'refuelDataIndex'
	}, {
		name: 'loacalConveyanceDataIndex'
	}, {
		name: 'carWashingDataIndex'
	}, {
		name: 'otherServiceDataIndex'
	}, {
		name: 'dateDataIndex',
		format: 'm/d/Y H:i',
		type: 'date'
	}, {
		name: 'totalDataIndex'
	}]
});
var store = new Ext.data.GroupingStore({
	autoLoad: false,
	proxy: new Ext.data.HttpProxy({
		url: '<%=request.getContextPath()%>/HubMaintenanceAction.do?param=getHubExpenseDetails',
		method: 'POST'
	}),
	remoteSort: false,
	storeId: 'hubExpenseMasterDetails',
	reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
	local: true,
	filters: [{
		type: 'numeric',
		dataIndex: 'slnoIndex'
	}, {
		type: 'numeric',
		dataIndex: 'hubIdDataIndex'
	}, {
		type: 'string',
		dataIndex: 'commentDataIndex'
	}, {
		type: 'string',
		dataIndex: 'vehicleNoDataIndex'
	}, {
		type: 'string',
		dataIndex: 'IdDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'carDirtyDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'keyLostDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'carDentDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'carScratchDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'towingDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'carPunctureDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'refuelDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'loacalConveyanceDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'carWashingDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'otherServiceDataIndex'
	}, {
		type: 'date',
		dataIndex: 'dateDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'totalDataIndex'
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
		header: "<span style=font-weight:bold;><%=HubId%></span>",
		dataIndex: 'hubIdDataIndex',
		hidden: true,
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
		dataIndex: 'vehicleNoDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Date%></span>",
		dataIndex: 'dateDataIndex',
		renderer: Ext.util.Format.dateRenderer('d-m-Y H:i'),
        hidden: false,
        width: 100,
	},  {
		header: "<span style=font-weight:bold;><%=Key_Lost%></span>",
		dataIndex: 'keyLostDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Car_Dent%></span>",
		dataIndex: 'carDentDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Car_Scratch%></span>",
		dataIndex: 'carScratchDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Towing%></span>",
		dataIndex: 'towingDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Car_Puncture%></span>",
		dataIndex: 'carPunctureDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Refuel%></span>",
		dataIndex: 'refuelDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Local_Conveyance%></span>",
		dataIndex: 'loacalConveyanceDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Car_Washing%></span>",
		dataIndex: 'carWashingDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Others%></span>",
		dataIndex: 'otherServiceDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=comments%></span>",
		dataIndex: 'commentDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Total%></span>",
		dataIndex: 'totalDataIndex',
		width: 80
	}];
	return new Ext.grid.ColumnModel({
		columns: columns.slice(start || 0, finish),
		defaults: {
			sortable: true
		}
	});
};

grid = getGrid('<%=HubMaintenanceDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 410, 25, filters, '<%=ClearFilterData%> ', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');

Ext.onReady(function() {
	ctsb = tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	outerPanel = new Ext.Panel({
		title: '<%=HubMaintenanceReport%>',
		renderTo: 'content',
		standardSubmit: true,
		frame: true,
		width: screen.width - 22,
		cls: 'outerpanel',
		layout: 'table',
		layoutConfig: {
			columns: 1
		},
		items: [MenuPanel, grid]
	});
});
  </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
