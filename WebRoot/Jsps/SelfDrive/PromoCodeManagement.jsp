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
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");

tobeConverted.add("Status");
tobeConverted.add("Select_Hub_Name");
tobeConverted.add("Date");
tobeConverted.add("Hub_Id");
tobeConverted.add("Hub_Name");

tobeConverted.add("Id");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Select_Status");
tobeConverted.add("PromoCode_Details");
tobeConverted.add("PromoCode_Management");

tobeConverted.add("Enter_Frequency");
tobeConverted.add("Frequency");
tobeConverted.add("Enter_Trip_Duration");
tobeConverted.add("Min_Trip_Duration");
tobeConverted.add("Select_Car_Model");

tobeConverted.add("Car_Model");
tobeConverted.add("Enter_Discount");
tobeConverted.add("Discount");
tobeConverted.add("Enter_Promo_Code");
tobeConverted.add("Promo_Code");

tobeConverted.add("Model_Type_Id");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");

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


String Status=convertedWords.get(16);
String SelectHub=convertedWords.get(17);
String Date=convertedWords.get(18);
String HubId=convertedWords.get(19);
String HubName=convertedWords.get(20);

String Id=convertedWords.get(21);
String SelectCustomerName=convertedWords.get(22);
String SelectStatus=convertedWords.get(23);
String PromoCodeDetails=convertedWords.get(24);
String PromoCodeManagement=convertedWords.get(25);

String EnterFrequency=convertedWords.get(26);
String Frequency=convertedWords.get(27);
String EnterTripDuration=convertedWords.get(28);
String MinTripDuration=convertedWords.get(29);
String SelectCarModel=convertedWords.get(30);

String CarModel=convertedWords.get(31);
String EnterDiscount=convertedWords.get(32);
String Discount=convertedWords.get(33);
String EnterPromoCode=convertedWords.get(34);
String PromoCode=convertedWords.get(35);

String ModelTypeId=convertedWords.get(36);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(37);

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
String userAuthority=cf.getUserAuthority(systemId,userId);	

%>
<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=PromoCodeManagement%></title>
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
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%}%>
		 <jsp:include page="../Common/ExportJS.jsp" />
<script> 
var outerPanel;
var jspName = "";
var exportDataType = "";
var grid;
var myWin;
var buttonValue;
var id;
var dtprev = dateprev;
var dtcur = datecur;
var carIdModify;
var hubIdModify;

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
				assetModelStore.load({
					params: {
						CustId: custId
					}
				});
				hubStore.load({
					params: {
						CustId: custId
					}
				});
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
				assetModelStore.load({
					params: {
						CustId: custId
					}
				});
				hubStore.load({
					params: {
						CustId: custId
					}
				});
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
			}
		}
	}
});

var assetModelStore = new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/PromoCodeManagementAction.do?param=getAssetModel',
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
	emptyText: '<%=SelectCarModel%>',
	displayField: 'ModelName',
	cls: 'selectstylePerfectDropDown',
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

var innerPanelForPromoCodeDetails = new Ext.form.FormPanel({
	standardSubmit: true,
	collapsible: false,
	autoScroll: true,
	height: 320,
	width: 440,
	frame: true,
	id: 'innerPanelForPromoCodeDetailsId',
	layout: 'table',
	resizable: true,
	layoutConfig: {
		columns: 4
	},
	items: [{
		xtype: 'fieldset',
		title: '<%=PromoCodeDetails%>',
		cls: 'fieldsetpanel',
		collapsible: false,
		colspan: 3,
		id: '',
		width: 400,
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
			id: ''
		}, {
			xtype: 'label',
			text: '<%=HubName%>' + ' :',
			cls: 'labelstyle',
			id: '',
		},
		hubTypeCombo, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=CarModel%>' + ' :',
			cls: 'labelstyle',
			id: '',
		},
		assetModelCombo, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'promoCodeEmptyId'
		}, {
			xtype: 'label',
			text: '<%=PromoCode%>' + ' :',
			cls: 'labelstyle',
			id: 'promoCodeLabelId'
		}, {
			xtype: 'textfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterPromoCode%>',
			emptyText: '<%=EnterPromoCode%>',
			labelSeparator: '',
			allowBlank: false,
			id: 'promoCodeId',
			listeners: {
				change: function(field, newValue, oldValue) {
					field.setValue(newValue.toUpperCase().trim());
				}
			}
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'discountEmptyId'
		}, {
			xtype: 'label',
			text: '<%=Discount%>' + ' :',
			cls: 'labelstyle',
			id: 'discountLabelId'
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterDiscount%>',
			emptyText: '<%=EnterDiscount%>',
			labelSeparator: '',
			allowNegative: false,
			allowBlank: false,
			id: 'discountId',
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'startEmptyId'
		}, {
			xtype: 'label',
			cls: 'labelstyle',
			text: '<%=StartDate%>' + ' :',
			id: 'startdateLableId',
		}, {
			xtype: 'datefield',
			cls: 'selectstylePerfect',
			frame: true,
			cls: 'selectstylePerfectDropDown',
			resizable: true,
			format: "d/m/y H:i",
			emptyText: '<%=SelectStartDate%>',
			allowBlank: false,
			blankText: '<%=SelectStartDate%>',
			vtype: 'daterange',
			id: 'startdate'

		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'endEmptyId'
		}, {
			xtype: 'label',
			cls: 'labelstyle',
			text: '<%=EndDate%>' + ' :',
			id: 'enddateLableId',
		}, {
			xtype: 'datefield',
			cls: 'selectstylePerfect',
			cls: 'selectstylePerfectDropDown',
			format: "d/m/y H:i",
			emptyText: '<%=SelectEndDate%>',
			allowBlank: false,
			blankText: '<%=SelectEndDate%>',
			vtype: 'daterange',
			id: 'enddate',
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=MinTripDuration%>' + ' :',
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterTripDuration%>',
			emptyText: '<%=EnterTripDuration%>',
			labelSeparator: '',
			allowBlank: false,
			allowNegative: false,
			id: 'tripDurationId',
		}, {
			xtype: 'label',
			text: '',
			cls: 'mandatoryfield',
			id: ''
		}, {
			xtype: 'label',
			text: '<%=Frequency%>' + ' :',
			cls: 'labelstyle',
			id: ''
		}, {
			xtype: 'numberfield',
			cls: 'selectstylePerfect',
			allowBlank: false,
			blankText: '<%=EnterFrequency%>',
			emptyText: '<%=EnterFrequency%>',
			labelSeparator: '',
			allowBlank: false,
			allowNegative: false,
			id: 'noOfTimesId',
		}, {
			xtype: 'label',
			text: '*',
			cls: 'mandatoryfield',
			id: 'statusEmptyId'
		}, {
			xtype: 'label',
			text: '<%=Status%>' + ' :',
			cls: 'labelstyle',
			id: 'statusLabelId',
		},
		statusCombo]
	}]
});

var innerWinButtonPanel = new Ext.Panel({
	id: 'winbuttonid',
	standardSubmit: true,
	collapsible: false,
	autoHeight: true,
	height: 70,
	width: 440,
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
					if (Ext.getCmp('promoCodeId').getValue() == "") {
						Ext.example.msg("<%=EnterPromoCode%>");
						Ext.getCmp('promoCodeId').focus();
						return;
					}
					if (Ext.getCmp('discountId').getValue() == "" || Ext.getCmp('discountId').getValue() > 100) {
						Ext.example.msg("<%=EnterDiscount%>");
						Ext.getCmp('discountId').focus();
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
					if (Ext.getCmp('statusComboId').getValue() == "") {
						Ext.example.msg("<%=SelectStatus%>");
						Ext.getCmp('statusComboId').focus();
						return;
					}
					if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                        Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                        Ext.getCmp('enddate').focus();
                        return;
       			    }

       			    if (buttonValue == '<%=Add%>') {
                        var recordIndex = store.findBy(
	                        function(record, id){
	                              if(record.get('promoCodeDataIndex') === Ext.getCmp('promoCodeId').getValue()){
	                                return true;  // a record with this data exists
	                                }
	                         return false;  // there is no record in the store with this data
	                       }
                      );

						if(recordIndex != -1){
						   Ext.example.msg("Promo Code Already Exist");
						   return ;
						}
					}
					if (buttonValue == '<%=Modify%>') {
						var selected = grid.getSelectionModel().getSelected();
						id = selected.get('idDataIndex');
						if (selected.get('carModelDataIndex') != Ext.getCmp('assetModelComboId').getValue()) {
							carIdModify = Ext.getCmp('assetModelComboId').getValue();
						} else {
							carIdModify = selected.get('carModelIdDataIndex');
						}
						if (selected.get('hubDataIndex') != Ext.getCmp('hubtypeComboId').getValue()) {
							hubIdModify = Ext.getCmp('hubtypeComboId').getValue();
						} else {
							hubIdModify = selected.get('hubIdDataIndex');
						}
 					    var promoCode=selected.get('promoCodeDataIndex');
                        var recordIndex = store.findBy(
	                        function(record, id){
	                              if(record.get('promoCodeDataIndex') === Ext.getCmp('promoCodeId').getValue() && promoCode != Ext.getCmp('promoCodeId').getValue()){
	                                return true;  // a record with this data exists
	                                }
	                         return false;  // there is no record in the store with this data
	                       }
                      );

						if(recordIndex != -1){
						   Ext.example.msg("Promo Code Already Exist");
						   return ;
						}
					}
					PromoCodeMasterOuterPanelWindow.getEl().mask();
					Ext.Ajax.request({
						url: '<%=request.getContextPath()%>/PromoCodeManagementAction.do?param=promoCodeDetailsAddModify',
						method: 'POST',
						params: {
							buttonValue: buttonValue,
							CustID: Ext.getCmp('custcomboId').getValue(),
							hub: Ext.getCmp('hubtypeComboId').getValue(),
							carModel: Ext.getCmp('assetModelComboId').getValue(),
							promoCode: Ext.getCmp('promoCodeId').getValue(),
							discountRate: Ext.getCmp('discountId').getValue(),
							startDate: Ext.getCmp('startdate').getRawValue(),
							endDate: Ext.getCmp('enddate').getRawValue(),
							minTripDuration: Ext.getCmp('tripDurationId').getValue(),
							frequency: Ext.getCmp('noOfTimesId').getValue(),
							status: Ext.getCmp('statusComboId').getValue(),
							carIdModify: carIdModify,
							hubIdModify: hubIdModify,
							id: id,
							jspName: jspName
						},
						success: function(response, options) {
							var message = response.responseText;
							Ext.example.msg(message);
							Ext.getCmp('hubtypeComboId').reset();
							Ext.getCmp('assetModelComboId').reset();
							Ext.getCmp('promoCodeId').reset();
							Ext.getCmp('discountId').reset();
							Ext.getCmp('startdate').reset();
							Ext.getCmp('enddate').reset();
							Ext.getCmp('tripDurationId').reset();
							Ext.getCmp('noOfTimesId').reset();
							Ext.getCmp('statusComboId').reset();
							myWin.hide();
							store.reload();
							PromoCodeMasterOuterPanelWindow.getEl().unmask();
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

var PromoCodeMasterOuterPanelWindow = new Ext.Panel({
	width: 450,
	height: 420,
	standardSubmit: true,
	frame: true,
	items: [innerPanelForPromoCodeDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
	title: 'titelForInnerPanel',
	closable: false,
	resizable: false,
	modal: true,
	autoScroll: false,
	height: 430,
	width: 460,
	id: 'myWin',
	frame: true,
	items: [PromoCodeMasterOuterPanelWindow]
});

function addRecord() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
		Ext.example.msg("<%=SelectCustomer%>");
		return;
	}
	buttonValue = '<%=Add%>';
	titelForInnerPanel = '<%=AddDetails%>';
	myWin.setPosition(450, 80);
	myWin.show();
	myWin.setTitle(titelForInnerPanel);
	Ext.getCmp('hubtypeComboId').reset();
	Ext.getCmp('assetModelComboId').reset();
	Ext.getCmp('promoCodeId').reset();
	Ext.getCmp('discountId').reset();
	Ext.getCmp('startdate').reset();
	Ext.getCmp('enddate').reset();
	Ext.getCmp('tripDurationId').reset();
	Ext.getCmp('noOfTimesId').reset();
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
	myWin.setPosition(450, 80);
	myWin.setTitle(titelForInnerPanel);
	myWin.show();
	var selected = grid.getSelectionModel().getSelected();
	Ext.getCmp('hubtypeComboId').setValue(selected.get('hubDataIndex'));
	Ext.getCmp('assetModelComboId').setValue(selected.get('carModelDataIndex'));
	Ext.getCmp('promoCodeId').setValue(selected.get('promoCodeDataIndex'));
	Ext.getCmp('discountId').setValue(selected.get('discountDataIndex'));
	Ext.getCmp('startdate').setValue(selected.get('startDateDataIndex'));
	Ext.getCmp('enddate').setValue(selected.get('endDateDataIndex'));
	Ext.getCmp('tripDurationId').setValue(selected.get('tripDurationDataIndex'));
	Ext.getCmp('noOfTimesId').setValue(selected.get('noOfTimesDataIndex'));
	Ext.getCmp('statusComboId').setValue(selected.get('statusDataIndex'));
}

var reader = new Ext.data.JsonReader({
	idProperty: 'promoCodeManagementId',
	root: 'getPromocodeDetails',
	totalProperty: 'total',
	fields: [{
		name: 'slnoIndex'
	}, {
		name: 'promoCodeDataIndex'
	}, {
		name: 'discountDataIndex'
	}, {
		name: 'carModelDataIndex'
	}, {
		name: 'hubDataIndex'
	}, {
		name: 'tripDurationDataIndex'
	}, {
		name: 'noOfTimesDataIndex'
	}, {
		name: 'statusDataIndex'
	}, {
		name: 'startDateDataIndex',
		type: 'date'
	}, {
		name: 'endDateDataIndex',
		type: 'date'
	}, {
		name: 'idDataIndex'
	}, {
		name: 'carModelIdDataIndex'
	}, {
		name: 'hubIdDataIndex'
	}]
});

var filters = new Ext.ux.grid.GridFilters({
	local: true,
	filters: [{
		type: 'numeric',
		dataIndex: 'slnoIndex'
	}, {
		type: 'string',
		dataIndex: 'promoCodeDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'discountDataIndex'
	}, {
		type: 'string',
		dataIndex: 'carModelDataIndex'
	}, {
		type: 'string',
		dataIndex: 'hubDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'tripDurationDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'noOfTimesDataIndex'
	}, {
		type: 'string',
		dataIndex: 'statusDataIndex'
	}, {
		type: 'date',
		dataIndex: 'startDateDataIndex'
	}, {
		type: 'date',
		dataIndex: 'endDateDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'carModelIdDataIndex'
	}, {
		type: 'numeric',
		dataIndex: 'hubIdDataIndex'
	}]
});

var store = new Ext.data.GroupingStore({
	autoLoad: false,
	proxy: new Ext.data.HttpProxy({
		url: '<%=request.getContextPath()%>/PromoCodeManagementAction.do?param=getPromocodeDetails',
		method: 'POST'
	}),
	remoteSort: false,
	storeId: 'promoCodeManagementId',
	reader: reader
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
		header: "<span style=font-weight:bold;><%=Id%></span>",
		dataIndex: 'idDataIndex',
		hidden: true,
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=ModelTypeId%></span>",
		dataIndex: 'carModelIdDataIndex',
		hidden: true,
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=HubId%></span>",
		dataIndex: 'hubIdDataIndex',
		hidden: true,
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=PromoCode%></span>",
		dataIndex: 'promoCodeDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Discount%></span>",
		dataIndex: 'discountDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=StartDate%></span>",
		dataIndex: 'startDateDataIndex',
		renderer: Ext.util.Format.dateRenderer('d/m/Y H:i'),
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=EndDate%></span>",
		dataIndex: 'endDateDataIndex',
		renderer: Ext.util.Format.dateRenderer('d/m/Y H:i'),
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=CarModel%></span>",
		dataIndex: 'carModelDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=HubName%></span>",
		dataIndex: 'hubDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=MinTripDuration%></span>",
		dataIndex: 'tripDurationDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Frequency%></span>",
		dataIndex: 'noOfTimesDataIndex',
		width: 80
	}, {
		header: "<span style=font-weight:bold;><%=Status%></span>",
		dataIndex: 'statusDataIndex',
		width: 80
	}];
	return new Ext.grid.ColumnModel({
		columns: columns.slice(start || 0, finish),
		defaults: {
			sortable: true
		}
	});
};
var backPanel = new Ext.Panel({
	id: 'backbuttonid',
	standardSubmit: true,
	collapsible: false,
	cls: 'nextbuttonpanel',
	width: 100,
	frame: false,
	layout: 'table',
	layoutConfig: {
		columns: 1
	},
	items: [{
		xtype: 'button',
		text: 'Back',
		id: 'dashBoardButtonId',
		iconCls: 'backbutton',
		width: 70,
		listeners: {
			click: {
				fn: function() {
					window.location = "<%=request.getContextPath()%>/Jsps/SelfDrive/CarRentalDashBord.jsp"
				}
			}
		}
	}]
});

grid = getGrid('<%=PromoCodeDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 410, 25, filters, '<%=ClearFilterData%> ', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');

Ext.onReady(function() {
	ctsb = tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	outerPanel = new Ext.Panel({
		title: '<%=PromoCodeManagement%>',
		renderTo: 'content',
		standardSubmit: true,
		frame: true,
		width: screen.width - 22,
		cls: 'outerpanel',
		layout: 'table',
		layoutConfig: {
			columns: 1
		},
		items: [clientPanel, grid, backPanel]
	});
});
  </script>
  </body>
</html>
<%}%>
