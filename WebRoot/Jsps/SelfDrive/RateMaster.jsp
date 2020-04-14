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
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
			 
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
tobeConverted.add("Asset_Type");
tobeConverted.add("Select_Asset_type");
tobeConverted.add("Asset_Model");
tobeConverted.add("Select_Asset_Model");

tobeConverted.add("Id");
tobeConverted.add("8_Hours_Rate");
tobeConverted.add("24_Hours_Rate");
tobeConverted.add("Weekday");
tobeConverted.add("Weekend");

tobeConverted.add("Deposit_Amount");
tobeConverted.add("Enter_8_Hours_Rate");
tobeConverted.add("Enter_24_Hours_Rate");
tobeConverted.add("Enter_Weekday");
tobeConverted.add("Enter_Weekend");

tobeConverted.add("Enter_Deposit_Amount");
tobeConverted.add("Per_hour_rate_when_exceeded_time_lock");
tobeConverted.add("Enter_Per_hour_rate_when_exceeded_time_lock");
tobeConverted.add("Rate_Master");
tobeConverted.add("Rate_Master_Details");

tobeConverted.add("Modify_Details");
tobeConverted.add("Enter_Weekday_8_Hours_Rate");
tobeConverted.add("Enter_Weekday_24_Hours_Rate");
tobeConverted.add("Enter_Weekday_Per_Hour_Rate_When_Exceeded_Time_Lock");

tobeConverted.add("Enter_Weekend_8_Hours_Rate");
tobeConverted.add("Enter_Weekend_24_Hours_Rate");
tobeConverted.add("Enter_Weekend_Per_Hour_Rate_When_Exceeded_Time_Lock");

tobeConverted.add("Weekday_8_Hours_Rate");
tobeConverted.add("Weekday_24_Hours_Rate");
tobeConverted.add("Weekday_Per_Hour_Rate_When_Exceeded_Time_Lock");

tobeConverted.add("Weekend_8_Hours_Rate");
tobeConverted.add("Weekend_24_Hours_Rate");
tobeConverted.add("Weekend_Per_Hour_Rate_When_Exceeded_Time_Lock");

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
String AssetType=convertedWords.get(12);
String SelectAssettype=convertedWords.get(13);
String AssetModel=convertedWords.get(14);
String SelectAssetModel=convertedWords.get(15);

String Id=convertedWords.get(16);
String EightHoursRate=convertedWords.get(17);
String TwentyFourHoursRate=convertedWords.get(18);
String Weekday=convertedWords.get(19);
String Weekend=convertedWords.get(20);

String DepositAmount=convertedWords.get(21);
String Enter8HoursRate=convertedWords.get(22);
String Enter24HoursRate=convertedWords.get(23);
String EnterWeekday=convertedWords.get(24);
String EnterWeekend=convertedWords.get(25);

String EnterDepositAmount=convertedWords.get(26);
String PerHour=convertedWords.get(27);
String EnterPerHour=convertedWords.get(28);
String RateMaster=convertedWords.get(29);
String RateMasterDetails=convertedWords.get(30);

String ModifyDetails=convertedWords.get(31);

String enterWeekday8HoursRate =convertedWords.get(32);
String enterWeekday24HoursRate =convertedWords.get(33);
String enterWeekdayPerHourRate =convertedWords.get(34);

String enterWeekEnd8HoursRate = convertedWords.get(35);
String enterWeekEnd24HoursRate = convertedWords.get(36);
String enterWeekEndPerHourRate = convertedWords.get(37);

String Weekday8HoursRate = convertedWords.get(38);
String Weekday24HoursRate = convertedWords.get(39);
String WeekdayPerHourRate = convertedWords.get(40);

String WeekEnd8HoursRate = convertedWords.get(41);
String WeekEnd24HoursRate = convertedWords.get(42);
String WeekEndPerHourRate =convertedWords.get(43);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=RateMaster%></title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
  var outerPanel;
  var jspName = "";
  var exportDataType = "";
  var grid;
  var myWin;
  var buttonValue;
  var assetTypeModify;
  var assetModelModify;
  var assetTypeModify1;
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
  				assetTypeStore.load();
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
  	emptyText: 'Select Customer',
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
  				assetTypeStore.load();
  				store.load({
  					params: {
  						CustId: custId
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
  //*************************************************AssetType Store **************************************************************// 
  var assetTypeStore = new Ext.data.JsonStore({
  	url: '<%=request.getContextPath()%>/RateMasterAction.do?param=getAssetType',
  	id: 'assetTypeStoreId',
  	root: 'assetTypeRoot',
  	autoLoad: true,
  	remoteSort: true,
  	fields: ['AssetType', 'Value'],
  	listeners: {
  		
  	}
  });
  //*************************************************AssetType Combo*************************************************************//
  var assetTypeCombo = new Ext.form.ComboBox({
  	store: assetTypeStore,
  	id: 'assetTypeComboId',
  	mode: 'local',
  	bodyStyle: 'padding-left:60px',
  	forceSelection: true,
  	selectOnFocus: true,
  	allowBlank: false,
  	anyMatch: true,
  	typeAhead: false,
  	triggerAction: 'all',
  	lazyRender: true,
  	valueField: 'Value',
  	emptyText: '<%=SelectAssettype%>',
  	displayField: 'AssetType',
  	cls: 'selectstylePerfect',
  	listeners: {
  		select: {
  			fn: function() {
  				assetId = Ext.getCmp('assetTypeComboId').getValue();
  				Ext.getCmp('assetModelComboId').reset();
  				assetModelStore.load({
  					params: {
  						AssetId: assetId
  					}
  				});
  			}
  		}
  	}
  });
  //*************************************************Asset Model Store **************************************************************// 
  var assetModelStore = new Ext.data.JsonStore({
  	url: '<%=request.getContextPath()%>/RateMasterAction.do?param=getAssetModel',
  	id: 'assetModelStoreId',
  	root: 'assetModelRoot',
  	autoLoad: true,
  	remoteSort: true,
  	fields: ['ModelName', 'Value'],
  	listeners: {}
  });
  //*************************************************Asset Model Combo**************************************************************// 
  var assetModelCombo = new Ext.form.ComboBox({
  	store: assetModelStore,
  	id: 'assetModelComboId',
  	mode: 'local',
  	forceSelection: true,
  	selectOnFocus: true,
  	allowBlank: false,
  	anyMatch: true,
  	typeAhead: false,
  	triggerAction: 'all',
  	lazyRender: true,
  	valueField: 'Value',
  	emptyText: '<%=SelectAssetModel%>',
  	displayField: 'ModelName',
  	cls: 'selectstylePerfect',
  });

  //************************************************Add and Modify Functionality **************************************************************//
  var innerPanel1 = new Ext.form.FormPanel({
  	standardSubmit: true,
  	collapsible: false,
  	autoScroll: true,
  	height: 90,
  	width: 600,
  	frame: false,
  	id: 'innerPanelForRateDetailsId1',
  	layout: 'table',
  	resizable: true,
  	layoutConfig: {
  		columns: 4
  	},
  	items: [{
  		cls: 'fieldsetpanel',
  		collapsible: false,
    	bodyStyle: 'padding-left:10px;',
  		colspan: 3,
  		id: 'RateMasterDetailsid',
  		width: 580,
  		layout: 'table',
  		layoutConfig: {
  			columns: 4,
  			tableAttrs: {
  				style: {
  					width: '88%'
  				}
  			}
  		},
  		items: [{
  			xtype: 'label',
  			text: '*',
  			width:60,
  			cls: 'mandatoryfield',
  			id: 'assetTypeEmptyId1'
  		},{
  			xtype: 'label',
  			text:'<%=AssetType%>' + ' :',
  			cls: 'labelstyle',
  			id: 'assetTypeLabelId',
  		},{width:166},
  		assetTypeCombo, {
  			xtype: 'label',
  			text: '*',
  			cls: 'mandatoryfield',
  			id: 'assetModelEmptyId1'
  		}, {
  			xtype: 'label',
  			text: '<%=AssetModel%>' + ' :',
  			cls: 'labelstyle',
  			id: 'assetModelLabelId',
  			resizable: true
  		},{width:166},
  		assetModelCombo,
  		 {
  			xtype: 'label',
  			text: '*',
  			cls: 'mandatoryfield',
  			id: 'depositAmountEmptyId1'
  		}, {
  			xtype: 'label',
  			text: '<%=DepositAmount%>' + ' :',
  			cls: 'labelstyle',
  			id: 'depositAmountLabelId'
  		},{width:166}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			decimalPrecision: 3,
  			blankText: '<%=EnterDepositAmount%>',
  			emptyText: '<%=EnterDepositAmount%>',
  			id: 'depositAmountId'
  		}]
  	}]
  });
   var innerPanel2 = new Ext.form.FormPanel({
  	standardSubmit: true,
  	collapsible: false,
  	autoScroll: true,
  	height: 150,
  	width: 590,
  	frame: false,
  	id: 'innerPanelForWeekdayRateId',
  	layout: 'table',
  	resizable: true,
  	layoutConfig: {
  		columns: 4
  	},
  	items: [{
  		xtype: 'fieldset',
  		title: '<%=Weekday%>',
  		cls: 'fieldsetpanel',
  		collapsible: false,
  		colspan: 3,
  		id: 'weekdayRateId',
  		width: 580,
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
  			id: '8hrEmptyId'
  		}, {
  			xtype: 'label',
  			text: '<%=EightHoursRate%>' + ' :',
  			cls: 'labelstyle',
  			id: '8hrLabelId'
  		}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			allowBlank: false,
  			blankText: '<%=Enter8HoursRate%>',
  			emptyText: '<%=Enter8HoursRate%>',
  			labelSeparator: '',
  			allowBlank: false,
  			id: '8hrRateId'

  		}, {
  			xtype: 'label',
  			text: '*',
  			cls: 'mandatoryfield',
  			id: '24hrEmptyId'
  		}, {
  			xtype: 'label',
  			text: '<%=TwentyFourHoursRate%>' + ' :',
  			cls: 'labelstyle',
  			id: '24hrLabelId'
  		}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			blankText: '<%=Enter24HoursRate%>',
  			emptyText: '<%=Enter24HoursRate%>',
  			labelSeparator: '',
  			allowBlank: false,
  			id: '24hrRateId'
  		}, {
  			xtype: 'label',
  			text: '*',
  			cls: 'mandatoryfield',
  			id: 'perhrRateEmptyId'
  		}, {
  			xtype: 'label',
  			text: '<%=PerHour%>' + ' :',
  			cls: 'labelstyle',
  			id: 'perhrRateLabelId'
  		}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			blankText: '<%=EnterPerHour%>',
  			emptyText: '<%=EnterPerHour%>',
  			id: 'perhrRateId'
  		}]
  	}]
  });
  var innerPanel3 = new Ext.form.FormPanel({
  	standardSubmit: true,
  	collapsible: false,
  	autoScroll: true,
  	height: 150,
  	width: 590,
  	frame: false,
  	id: 'innerPanelForWeekendRateId',
  	layout: 'table',
  	resizable: true,
  	layoutConfig: {
  		columns: 4
  	},
  	items: [{
  		xtype: 'fieldset',
  		title: '<%=Weekend%>',
  		cls: 'fieldsetpanel',
  		collapsible: false,
  		colspan: 3,
  		id: 'weekdayRateId',
  		width: 580,
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
  			id: '8hrEmptyId1'
  		}, {
  			xtype: 'label',
  			text: '<%=EightHoursRate%>' + ' :',
  			cls: 'labelstyle',
  			id: '8hrLabelId1'
  		}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			allowBlank: false,
  			blankText: '<%=Enter8HoursRate%>',
  			emptyText: '<%=Enter8HoursRate%>',
  			labelSeparator: '',
  			allowBlank: false,
  			id: '8hrRateId1'

  		}, {
  			xtype: 'label',
  			text: '*',
  			cls: 'mandatoryfield',
  			id: '24hrEmptyId1'
  		}, {
  			xtype: 'label',
  			text: '<%=TwentyFourHoursRate%>' + ' :',
  			cls: 'labelstyle',
  			id: '24hrLabelId11'
  		}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			blankText: '<%=Enter24HoursRate%>',
  			emptyText: '<%=Enter24HoursRate%>',
  			labelSeparator: '',
  			allowBlank: false,
  			id: '24hrRateId1'
  		}, {
  			xtype: 'label',
  			text: '*',
  			cls: 'mandatoryfield',
  			id: 'perhrRateEmptyId1'
  		}, {
  			xtype: 'label',
  			text: '<%=PerHour%>' + ' :',
  			cls: 'labelstyle',
  			id: 'perhrRateLabelId1'
  		}, {
  			xtype: 'numberfield',
  			cls: 'selectstylePerfect',
  			blankText: '<%=EnterPerHour%>',
  			emptyText: '<%=EnterPerHour%>',
  			id: 'perhrRateId1'
  		}]
  	}]
  });
  var innerWinButtonPanel = new Ext.Panel({
  	id: 'winbuttonid',
  	standardSubmit: true,
  	collapsible: false,
  	autoHeight: true,
  	height: 150,
  	width: 640,
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
  					if (Ext.getCmp('assetTypeComboId').getValue() == "") {
  						Ext.example.msg("<%=SelectAssettype%>");
  						Ext.getCmp('assetTypeComboId').focus();
  						return;
  					}
  					if (Ext.getCmp('assetModelComboId').getValue() == "") {
  						Ext.example.msg("<%=SelectAssetModel%>");
  						Ext.getCmp('assetModelComboId').focus();
  						return;
  					}
  					if (Ext.getCmp('depositAmountId').getValue() == "") {
  						Ext.example.msg("<%=EnterDepositAmount%>");
  						Ext.getCmp('depositAmountId').focus();
  						return;
  					}
  					if (Ext.getCmp('8hrRateId').getValue() == "") {
  						Ext.example.msg("<%=enterWeekday8HoursRate%>");					
  						Ext.getCmp('8hrRateId').focus();
  						return;
  					}
  					if (Ext.getCmp('24hrRateId').getValue() == "") {
  						Ext.example.msg("<%=enterWeekday24HoursRate%>");				
  						Ext.getCmp('24hrRateId').focus();
  						return;
  					}
  					if (Ext.getCmp('perhrRateId').getValue() == "") {
  						Ext.example.msg("<%=enterWeekdayPerHourRate%>");					
  						Ext.getCmp('perhrRateId').focus();
  						return;
  					}
  					if (Ext.getCmp('8hrRateId1').getValue() == "") {
  						Ext.example.msg("<%=enterWeekEnd8HoursRate%>");				
  						Ext.getCmp('8hrRateId1').focus();
  						return;
  					}
  					if (Ext.getCmp('24hrRateId1').getValue() == "") {
  						Ext.example.msg("<%=enterWeekEnd24HoursRate%>");						
  						Ext.getCmp('24hrRateId1').focus();
  						return;
  					}
  					if (Ext.getCmp('perhrRateId1').getValue() == "") {
  						Ext.example.msg("<%=enterWeekEndPerHourRate%>");						//label
  						Ext.getCmp('perhrRateId1').focus();
  						return;
  					}
  					var id;
  					if (buttonValue == '<%=Modify%>') {
  						var selected = grid.getSelectionModel().getSelected();
  						id = selected.get('uniqueDataIndex');
  						
  						if (selected.get('vehicleTypeDataIndex') != Ext.getCmp('assetTypeComboId').getRawValue()) {
  							assetTypeModify = Ext.getCmp('assetTypeComboId').getValue();
  						} else {
  							assetTypeModify = selected.get('assetTypeDataIndex');
  						}
  						
  						if (selected.get('vehicleModelDataIndex') != Ext.getCmp('assetModelComboId').getRawValue()) {
  							assetModelModify = Ext.getCmp('assetModelComboId').getValue();
  						} else {
  							assetModelModify = selected.get('assetModelDataIndex');
  						}
  					}
  					RateMasterOuterPanelWindow.getEl().mask();
  					Ext.Ajax.request({
  						url: '<%=request.getContextPath()%>/RateMasterAction.do?param=rateMasterAddModify',
  						method: 'POST',
  						params: {

  							buttonValue: buttonValue,
  							CustID: Ext.getCmp('custcomboId').getValue(),
  							CustName: Ext.getCmp('custcomboId').getRawValue(),
  							assetTypeName: Ext.getCmp('assetTypeComboId').getRawValue(),
  							assetModelName: Ext.getCmp('assetModelComboId').getRawValue(),
  							assetType: Ext.getCmp('assetTypeComboId').getValue(),
  							assetModel: Ext.getCmp('assetModelComboId').getValue(),
  							eighthrRate: Ext.getCmp('8hrRateId').getValue(),
  							twentyfourhrRate: Ext.getCmp('24hrRateId').getValue(),
  							perhrRate: Ext.getCmp('perhrRateId').getValue(),
  							weekendEighthrRate: Ext.getCmp('8hrRateId1').getValue(),
  							weekendTwentyfourhrRate: Ext.getCmp('24hrRateId1').getValue(),
  							weekendPerhrRate: Ext.getCmp('perhrRateId1').getValue(),
  							assetModelModify:assetModelModify,
  							assetTypeModify:assetTypeModify,
  							depositAmount: Ext.getCmp('depositAmountId').getValue(),
  							id: id,
  							jspName: jspName
  						},
  						success: function(response, options) {
  							var message = response.responseText;
  							Ext.example.msg(message);
  							Ext.getCmp('assetTypeComboId').reset();
  							Ext.getCmp('assetModelComboId').reset();
  							Ext.getCmp('8hrRateId').reset();
  							Ext.getCmp('24hrRateId').reset();
  							Ext.getCmp('perhrRateId').reset();
  							Ext.getCmp('8hrRateId1').reset();
  							Ext.getCmp('24hrRateId1').reset();
  							Ext.getCmp('perhrRateId1').reset();
  							Ext.getCmp('depositAmountId').reset();
  							myWin.hide();
  							store.reload();
  							RateMasterOuterPanelWindow.getEl().unmask();
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

  var outerPanel = new Ext.Panel({
  	standardSubmit: true,
  	collapsible: false,
  	autoScroll: true,
    width: 640,
  	height: 460,
  	frame: true,
  	id: 'outerFormPanelId',
  	layout: 'table',
  	resizable: true,
  	layoutConfig: {
  		columns: 4
  	},
  	items: [{
  		xtype: 'fieldset',
  		title: 'Rate Master Details ',
  		cls: 'fieldsetpanel',
  		collapsible: false,
  		colspan: 3,
  		id: 'weekdayRateId',
  		width: 610,
  		
  		items: [innerPanel1, innerPanel2,innerPanel3]
  		}]
  	});
  var RateMasterOuterPanelWindow = new Ext.Panel({
  	width: 650,
  	height: 570,
  	standardSubmit: true,
  	frame: false,
  	items: [outerPanel, innerWinButtonPanel]
  });

  myWin = new Ext.Window({
  	title: 'titelForInnerPanel',
  	closable: false,
  	resizable: false,
  	modal: true,
  	autoScroll: false,
  	height: 580,
  	width: 660,
  	id: 'myWin',
  	items: [RateMasterOuterPanelWindow]
  });

  function addRecord() {
  	if (Ext.getCmp('custcomboId').getValue() == "") {
  		Ext.example.msg("<%=SelectCustomer%>");
  		return;
  	}
  	buttonValue = '<%=Add%>';
  	titelForInnerPanel = '<%=AddDetails%>';
  	myWin.setPosition(380,60);
  	myWin.show();
  	myWin.setTitle(titelForInnerPanel);
  	Ext.getCmp('assetTypeComboId').enable();
  	Ext.getCmp('assetModelComboId').enable();
  	Ext.getCmp('assetTypeComboId').reset();
  	Ext.getCmp('assetModelComboId').reset();
  	Ext.getCmp('8hrRateId').reset();
  	Ext.getCmp('24hrRateId').reset();
  	Ext.getCmp('perhrRateId').reset();
  	Ext.getCmp('8hrRateId1').reset();
  	Ext.getCmp('24hrRateId1').reset();
  	Ext.getCmp('perhrRateId1').reset();
  	Ext.getCmp('depositAmountId').reset();
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
  	titelForInnerPanel = '<%=ModifyDetails%>';
  	myWin.setPosition(380, 60);
  	myWin.setTitle(titelForInnerPanel);
  	myWin.show();
  
  	Ext.getCmp('assetTypeComboId').disable();
  	Ext.getCmp('assetModelComboId').disable();
  	var selected = grid.getSelectionModel().getSelected();
  	Ext.getCmp('assetTypeComboId').setValue(selected.get('assetTypeDataIndex'));
    Ext.getCmp('assetModelComboId').setValue(selected.get('vehicleModelDataIndex'));
  	Ext.getCmp('8hrRateId').setValue(selected.get('8hoursRateDataIndex'));
  	Ext.getCmp('24hrRateId').setValue(selected.get('24hoursRateDataIndex'));
  	Ext.getCmp('perhrRateId').setValue(selected.get('perHourRateDataIndex'));
  	Ext.getCmp('8hrRateId1').setValue(selected.get('8hoursWeekendRateDataIndex'));
  	Ext.getCmp('24hrRateId1').setValue(selected.get('24hoursWeekendRateDataIndex'));
  	Ext.getCmp('perhrRateId1').setValue(selected.get('perHourWeekendRateDataIndex'));
  	Ext.getCmp('depositAmountId').setValue(selected.get('depositAmountDataIndex'));
  	
  	if (selected.get('vehicleTypeDataIndex') != Ext.getCmp('assetTypeComboId').getRawValue()) {
  		assetTypeModify1 = Ext.getCmp('assetTypeComboId').getValue();
  	} else {
       assetTypeModify1 = selected.get('assetTypeDataIndex');
  	}
  	assetModelStore.load({
  		params: {
  			AssetId: assetTypeModify1
  		}
  	});
  }
  
  //*************************************************Reader Config **************************************************************//     
  var reader = new Ext.data.JsonReader({
  	idProperty: 'RateMasterDetails',
  	root: 'getRateMasterDetails',
  	totalProperty: 'total',
  	fields: [{
  		name: 'slnoIndex'
  	}, {
  		name: 'assetTypeDataIndex'
  	}, {
  		name: 'assetModelDataIndex'
  	}, {
  		name: '8hoursRateDataIndex'
  	}, {
  		name: '24hoursRateDataIndex'
  	}, {
  		name: 'perHourRateDataIndex'
  	}, {
  		name: '8hoursWeekendRateDataIndex'
  	}, {
  		name: '24hoursWeekendRateDataIndex'
  	}, {
  		name: 'perHourWeekendRateDataIndex'
  	}, {
  		name: 'depositAmountDataIndex'
  	}, {
  		name: 'vehicleTypeDataIndex'
  	}, {
  		name: 'vehicleModelDataIndex'
  	}, {
  		name: 'uniqueDataIndex'
  	}]
  });


  var store = new Ext.data.GroupingStore({
  	autoLoad: false,
  	proxy: new Ext.data.HttpProxy({
  		url: '<%=request.getContextPath()%>/RateMasterAction.do?param=getRateMasterDetails',
  		method: 'POST'
  	}),
  	remoteSort: false,
  	storeId: 'RateMasterDetails',
  	reader: reader
  });

  ///*************************************************Filters **************************************************************//
  var filters = new Ext.ux.grid.GridFilters({
  	local: true,
  	filters: [{
  		type: 'numeric',
  		dataIndex: 'slnoIndex'
  	}, {
  		type: 'int',
  		dataIndex: 'assetTypeDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: 'assetModelDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: '8hoursRateDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: '24hoursRateDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: 'perHourRateDataIndex'
  	},{
  		type: 'int',
  		dataIndex: '8hoursWeekendRateDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: '24hoursWeekendRateDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: 'perHourWeekendRateDataIndex'
  	}, {
  		type: 'float',
  		dataIndex: 'depositAmountDataIndex'
  	}, {
  		type: 'string',
  		dataIndex: 'vehicleTypeDataIndex'
  	}, {
  		type: 'string',
  		dataIndex: 'vehicleModelDataIndex'
  	}, {
  		type: 'int',
  		dataIndex: 'uniqueDataIndex'
  	}]
  });
  //*************************************************Rate Master Grid Columns *************************************************************//
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
  		header: "<span style=font-weight:bold;><%=AssetType%></span>",
  		dataIndex: 'vehicleTypeDataIndex',
  		width: 80, 
  		filter: {
  			type: 'string'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=AssetModel%></span>",
  		dataIndex: 'vehicleModelDataIndex',
  		width: 80,
  		filter: {
  			type: 'string'
  		}
  	},{
  		header: "<span style=font-weight:bold;><%=DepositAmount%></span>",
  		dataIndex: 'depositAmountDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=Weekday8HoursRate%></span>",
  		dataIndex: '8hoursRateDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=Weekday24HoursRate%></span>",
  		dataIndex: '24hoursRateDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=WeekdayPerHourRate%></span>",
  		dataIndex: 'perHourRateDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=WeekEnd8HoursRate%></span>",
  		dataIndex: '8hoursWeekendRateDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=WeekEnd24HoursRate%></span>",
  		dataIndex: '24hoursWeekendRateDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=WeekEndPerHourRate%></span>",
  		dataIndex: 'perHourWeekendRateDataIndex',
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=AssetType%></span>",
  		dataIndex: 'assetTypeDataIndex',
  		hidden: true,
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=AssetModel%></span>",
  		dataIndex: 'assetModelDataIndex',
  		hidden: true,
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}, {
  		header: "<span style=font-weight:bold;><%=Id%></span>",
  		dataIndex: 'uniqueDataIndex',
  		hidden: true,
  		width: 80,
  		filter: {
  			type: 'int'
  		}
  	}];
  	return new Ext.grid.ColumnModel({
  		columns: columns.slice(start || 0, finish),
  		defaults: {
  			sortable: true
  		}
  	});
  };
  //**************************************************************************Rate Master Grid **************************************************************//  
  grid = getGrid('<%=RateMasterDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 460, 21, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');

  //**************************************************************************Main Function*************************************************************// 
  Ext.onReady(function() {
  	ctsb = tsb;
  	Ext.QuickTips.init();
  	Ext.form.Field.prototype.msgTarget = 'side';
  	outerPanel = new Ext.Panel({
  		title: '<%=RateMaster%>',
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
  		//bbar: ctsb
  	});
  	sb = Ext.getCmp('form-statusbar');
  });
  </script>
</body>
</html>
<%}%>
