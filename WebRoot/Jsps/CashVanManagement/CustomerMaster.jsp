<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int countryId = loginInfo.getCountryCode();
    CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}

///file-upload.js
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Customer_Master");
tobeConverted.add("Company_Name");
tobeConverted.add("Company_Type");
tobeConverted.add("Region");
tobeConverted.add("Address");
tobeConverted.add("Contact_Person");
tobeConverted.add("Phone_No");
tobeConverted.add("Mobile");
tobeConverted.add("Email");
tobeConverted.add("Created_By");
tobeConverted.add("Created_Time");
tobeConverted.add("Updated_By");
tobeConverted.add("Updated_Time");
tobeConverted.add("Status");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Save");
tobeConverted.add("Customer_Name");
tobeConverted.add("Cancel");
tobeConverted.add("Add");
tobeConverted.add("Delete");
tobeConverted.add("Modify");
tobeConverted.add("Modify_Details");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String Customer_Master=convertedWords.get(0);
String Company_Name=convertedWords.get(1);
String Company_Type=convertedWords.get(2);
String Region=convertedWords.get(3);
String Address=convertedWords.get(4);
String Contact_Person=convertedWords.get(5);
String Phone_No=convertedWords.get(6);
String Mobile=convertedWords.get(7);
String Email=convertedWords.get(8);
String Created_By=convertedWords.get(9);
String Created_Time=convertedWords.get(10);
String Updated_By=convertedWords.get(11);
String Updated_Time=convertedWords.get(12);
String Status=convertedWords.get(13);
String SelectCustomerName=convertedWords.get(14);
String Save=convertedWords.get(15);
String Customer_Name = convertedWords.get(16);
String Cancel = convertedWords.get(17);
String Add = convertedWords.get(18);
String Delete = convertedWords.get(19);
String Modify = convertedWords.get(20);
String ModifyDetails = convertedWords.get(21); 
String SLNO = convertedWords.get(22);
String NoRecordsFound = convertedWords.get(23);
String ClearFilterData = convertedWords.get(24);
String Excel = convertedWords.get(25);

%>

<jsp:include page="../Common/header.jsp" />
 		<title>Customer Master</title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script> 
   <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
   <style>
   label {
			display : inline !important;
		}
			.x-panel-header
		{
				height: 28% !important;
		}
		
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		
		.x-window-tl *.x-window-header {
			height: 36px !important;
			padding-top : 8px !important;
		}
		
		</style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "CustomerMaster";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel = "Add New Customer Details";
var myWin;
var selectedName = null;
var selectedType = null;
var custId = '<%=customerId%>';
var coutryId = '<%=countryId%>';
var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', 'Active'],
        ['Inactive', 'Inactive']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Status',
    blankText: 'Select Status',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});


var companyTypecombostore = new Ext.data.SimpleStore({
    id: 'companyTypecombostoreId',
    fields: ['Name', 'Value'],
    data: [
        ['ATM Replenishment', 'ATM Replenishment'],
        ['Cash pickup', 'Cash pickup'],
        ['Cash Delivery','Cash Delivery'],
        ['Pay Packeting','Pay Packeting'],
        ['Bank','Bank'],
        ['Manpower(Cashier/Gunmen)','Manpower(Cashier/Gunmen)']
    ]
});

var companyTypecombo = new Ext.ux.form.LovCombo({
	  
	width: 200,
	forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    maxHeight: 200,
    store: companyTypecombostore,
    id: 'companyTypecomboId',   
    multiSelect: true,
    maxSelections: 3,
    emptyText: 'Select Product Type',
    blankText: 'Select Product Type',
    valueField: 'Name',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    mode: 'local',
    checkField:'checked',
    hideOnSelect:false,
    beforeBlur: Ext.emptyFn
	});

var regionComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CustomerAction.do?param=getStateList',
    id: 'regionComboStoreId',
    autoLoad: false,
    fields: ['StateName', 'StateID'],
    root:'StateRoot'
});

regionComboStore.load({
            params: {
            countryId: coutryId
             }
         });

var regionCombo = new Ext.form.ComboBox({
    store: regionComboStore,
    id: 'regionComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Region',
    blankText: 'Select Region',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'StateName',
    displayField: 'StateName',
    cls: 'selectstylePerfect'
});



var innerPanelForCustomerMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 360,
    width: 400,
    frame: false,
    id: 'innerPanelForCustomerMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Add New Record',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'NewRecordId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id1'
        },{
            xtype: 'label',
            text: 'Company Name' + ' :',
            cls: 'labelstyle',
            id: 'companyNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'CompanyNameTextId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Company Name',
            blankText: 'Enter Company Name',
            selectOnFocus: true,
            allowBlank: false,
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
                }
            }
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id2'
        },{
            xtype: 'label',
            text: 'Product Type' + ' :',
            cls: 'labelstyle',
            id: 'CompanyTypeLabelId'
        }, 
           companyTypecombo
        , {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id3'
        },{
            xtype: 'label',
            text: 'Region' + ' :',
            cls: 'labelstyle',
            id: 'RegionLabelId'
        }, 
            regionCombo
        , {},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id4'
        },{
            xtype: 'label',
            text: 'Address' + ' :',
            cls: 'labelstyle',
            id: 'AddressLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'AddressTextId',
            mode: 'local',
            height: 80,
            forceSelection: true,
            emptyText: '',
            blankText: '',
            selectOnFocus: true,
            allowBlank: false,
            maskRe: /[a-z0-9\s]/i,
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        }, {},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id5'
        },{
            xtype: 'label',
            text: 'Contact Person' + ' :',
            cls: 'labelstyle',
            id: 'ContactPersonLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'ContactPersonTextId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Name',
            blankText: 'Enter Name',
            selectOnFocus: true,
            allowBlank: false,
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
                }
            }
        }, {},
          {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'id6'
        },{
            xtype: 'label',
            text: 'Phone No' + ' :',
            cls: 'labelstyle',
            id: 'PhineLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'PhoneTextId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Phone No',
            blankText: 'Enter Phone No',
            selectOnFocus: true,
            allowBlank: false,
            maskRe: /[0-9]/i,
            autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 12,
				type: "text",
				size: "12",
				autocomplete: "off"
			},
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        }, {},
            {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id7'
        },{
            xtype: 'label',
            text: 'Mobile' + ' :',
            cls: 'labelstyle',
            id: 'MobileLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'MobileTextId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Mobile',
            blankText: 'Enter Mobile',
            selectOnFocus: true,
             maskRe: /[0-9]/i,
               autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 10,
				type: "text",
				size: "10",
				autocomplete: "off"
			},
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        }, {},
          {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'id44'
        }, {
            xtype: 'label',
            text: 'Contact'+' Person 2',
            cls: 'labelstyle',
            id: 'id66',
        }, {
            xtype: 'textfield',
            text: ' ',
            cls: 'selectstylePerfect',
            size: "100",
            id: 'ContactPersonTextId2',
             emptyText: 'Enter Name',
            blankText: 'Enter Name',
            selectOnFocus: true,
            allowBlank: false,
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
                }
            }
        },{},
        
      
                  {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'id11'
        }, {
            xtype: 'label',
            text: 'Phone '+'No 2',
            cls: 'labelstyle',
            id: 'phoneLabelId2'
        }, {
            xtype: 'textfield',
            text: ' ',
            cls: 'selectstylePerfect',
            id: 'phoneTextId2',
             emptyText: 'Enter Phone No',
            blankText: 'Enter Phone No',
            selectOnFocus: true,
            allowBlank: false,
            maskRe: /[0-9]/i,
            autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 12,
				type: "text",
				size: "12",
				autocomplete: "off"
			},
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        },{},
        
    
        
                  {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'id02'
        }, {
            xtype: 'label',
            text: 'Mobile'+' 2',
            cls: 'labelstyle',
            id: 'id03'
        }, {
            xtype: 'textfield',
            text: ' ',
            cls: 'selectstylePerfect',
            id: 'mobileTextId2',
             emptyText: 'Enter Mobile',
            blankText: 'Enter Mobile',
            selectOnFocus: true,
             maskRe: /[0-9]/i,
               autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 10,
				type: "text",
				size: "10",
				autocomplete: "off"
			},
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        },{},
        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id8'
        },{
            xtype: 'label',
            text: 'Email' + ' :',
            cls: 'labelstyle',
            id: 'EmailLabelId'
        }, {
            xtype: 'textfield',
            vtype: 'email',
            cls: 'selectstylePerfect',
            id: 'EmailTextId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Email',
            blankText: 'Enter Email',
            selectOnFocus: true,
            allowBlank: false,
            regex:/[a-z0-9_.-@]/i,
               autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 100,
				type: "text",
				size: "100",
				autocomplete: "off"
			}
        }, {},
        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id9'
        }, {
            xtype: 'label',
            text: 'Status' + ' :',
            cls: 'labelstyle',
            id: 'statusLabelId'
        },  statuscombo, {}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 400,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    
                    if (Ext.getCmp('CompanyNameTextId').getValue() == "") {
                    Ext.example.msg("Enter Company Name");
                        return;
                    }
                    if (Ext.getCmp('companyTypecomboId').getValue() == "") {
                    Ext.example.msg("Enter Product Type");
                        return;
                    }
                    if (Ext.getCmp('regionComboId').getValue() == "") {
                    Ext.example.msg("Select Region");
                        return;
                    }
                    if (Ext.getCmp('AddressTextId').getValue() == "") {
                    Ext.example.msg("Enter Address");
                        return;
                    }
                    if (Ext.getCmp('ContactPersonTextId').getValue() == "") {
                    Ext.example.msg("Enter Contact Person Name");
                        return;
                    }
                    var phonenoRegX = /^\d{10}$/;
                    if (Ext.getCmp('MobileTextId').getValue() == "") {
                   		Ext.example.msg("Enter Mobile");
                       	return;
                    }
                    if (Ext.getCmp('MobileTextId').getValue() != "") {
                    	if(!Ext.getCmp('MobileTextId').getValue().match(phonenoRegX)){
                    		Ext.example.msg("Enter valid Mobile");
                        	return;
                    	}
                    }
                    if (Ext.getCmp('mobileTextId2').getValue() != "") {
                    	if(!Ext.getCmp('mobileTextId2').getValue().match(phonenoRegX)){
                    		Ext.example.msg("Enter valid Mobile2");
                        	return;
                    	}
                    }
                    if (Ext.getCmp('EmailTextId').getValue() == "") {
                    Ext.example.msg("Enter Email");
                        return;
                    }
                    if (Ext.getCmp('statuscomboId').getValue() == "") {
                    	Ext.example.msg("Select Status");
                    	return;
                    }   
                      
                    var emailId = Ext.getCmp('EmailTextId').getValue();
                    if(!isValidEmailAddress(emailId)){
        				Ext.example.msg("Invalid email Id");
     					return;
    				}
                    var rec;
                   	if (buttonValue == 'Modify') {
	                	var selected = grid.getSelectionModel().getSelected();
                       	id = selected.get('uniqueIdDataIndex');
                   	}
                    Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/CustomerMasterAction.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: <%=customerId%>,
                                CumpanyName: Ext.getCmp('CompanyNameTextId').getValue(),
                                CompanyType: Ext.getCmp('companyTypecomboId').getRawValue(), 
                                Region: Ext.getCmp('regionComboId').getRawValue(),
                                Address:Ext.getCmp('AddressTextId').getValue(),
								ContactPesrson: Ext.getCmp('ContactPersonTextId').getValue(),
                                PhoneNo: Ext.getCmp('PhoneTextId').getValue(),
                                Mobile: Ext.getCmp('MobileTextId').getValue(),
                                Email:Ext.getCmp('EmailTextId').getValue(),
                                Status: Ext.getCmp('statuscomboId').getValue(),
                                ContactPesrson2: Ext.getCmp('ContactPersonTextId2').getValue(),
                                PhoneNo2: Ext.getCmp('phoneTextId2').getValue(),
                                Mobile2: Ext.getCmp('mobileTextId2').getValue()
                                
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
                               
Ext.getCmp('CompanyNameTextId').reset();
Ext.getCmp('companyTypecomboId').reset();
Ext.getCmp('regionComboId').reset();
Ext.getCmp('AddressTextId').reset();
Ext.getCmp('ContactPersonTextId').reset();
Ext.getCmp('PhoneTextId').reset();
Ext.getCmp('MobileTextId').reset();
Ext.getCmp('EmailTextId').reset();
Ext.getCmp('ContactPersonTextId2').reset(),
Ext.getCmp('phoneTextId2').reset(),
Ext.getCmp('mobileTextId2').reset(),
                                Ext.getCmp('statuscomboId').reset();
                                myWin.hide();
                                CustomerMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
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

var CustomerMasterOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 400,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForCustomerMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 430,
    id: 'myWin',
    items: [CustomerMasterOuterPanelWindow]
});

function addRecord() {
    Ext.getCmp('CompanyNameTextId').enable();
    buttonValue = '<%=Add%>';
    titelForInnerPanel = 'AddCustomerMaster';
    myWin.setPosition(450, 50);
    myWin.show();
    //  myWin.setHeight(350);
   Ext.getCmp('CompanyNameTextId').reset();
Ext.getCmp('companyTypecomboId').reset();
Ext.getCmp('regionComboId').reset();
Ext.getCmp('AddressTextId').reset();
Ext.getCmp('ContactPersonTextId').reset();
Ext.getCmp('PhoneTextId').reset();
Ext.getCmp('MobileTextId').reset();
Ext.getCmp('EmailTextId').reset();
    Ext.getCmp('statuscomboId').reset();
Ext.getCmp('ContactPersonTextId2').reset(),
Ext.getCmp('phoneTextId2').reset(),
Ext.getCmp('mobileTextId2').reset(),
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
   
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("NoRowsSelected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("SelectSingleRow");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
   
    var selected = grid.getSelectionModel().getSelected();
Ext.getCmp('CompanyNameTextId').setValue(selected.get('CompanyNameDataIndex'));
Ext.getCmp('CompanyNameTextId').disable();

companyTypecombo.deselectAll();
var checkedValues = selected.get('CompanyTypeDataIndex').split(", ");
var checkedValuesLen = checkedValues.length;
companyTypecombo.store.each(function(r) {
if(checkedValues.indexOf(r.get('Name'))>-1)
r.set(companyTypecombo.checkField, 'checked');
});
companyTypecombo.value = companyTypecombo.getCheckedValue();
companyTypecombo.setRawValue(companyTypecombo.getCheckedValue().replace(/,/g, ", "));

Ext.getCmp('regionComboId').setValue(selected.get('RegionDataIndex'));
Ext.getCmp('AddressTextId').setValue(selected.get('AddressDataIndex'));
Ext.getCmp('ContactPersonTextId').setValue(selected.get('ContactPersonDataIndex'));
Ext.getCmp('PhoneTextId').setValue(selected.get('PhoneNoDataIndex'));
Ext.getCmp('EmailTextId').setValue(selected.get('EmailDataIndex'));
Ext.getCmp('MobileTextId').setValue(selected.get('MobileDataIndex'));
Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));
Ext.getCmp('ContactPersonTextId2').setValue(selected.get('ContactPerson2DataIndex'));
Ext.getCmp('phoneTextId2').setValue(selected.get('PhoneNo2DataIndex'));
Ext.getCmp('mobileTextId2').setValue(selected.get('Mobile2DataIndex'));

}

var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'customerMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'CompanyNameDataIndex'
    },{
        name: 'CompanyTypeDataIndex'
    },{
        name: 'RegionDataIndex'
    },{
        name: 'AddressDataIndex'
    },{
        name: 'ContactPersonDataIndex'
    },{
        name: 'ContactPerson2DataIndex'
    },{
        name: 'PhoneNoDataIndex'
    },{
        name: 'PhoneNo2DataIndex'
    },{
        name: 'EmailDataIndex'
    },{
        name: 'MobileDataIndex'
    },{
        name: 'Mobile2DataIndex'
    },{
        name: 'CreatedByDataIndex'
    },{
        name: 'CreatedTimeDataIndex'
    },{
        name: 'UpdatedByDataIndex'
    },{
        name: 'UpdatedTimeDataIndex'
    },{
        name: 'statusIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/CustomerMasterAction.do?param=getCustomerMasterDetails',
        method: 'POST'
    }),
    storeId: 'customerMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
        type: 'string',
        dataIndex: 'CompanyNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'CompanyTypeDataIndex'
    },{
        type: 'string',
        dataIndex: 'RegionDataIndex'
    },{
        type: 'string',
        dataIndex: 'AddressDataIndex'
    },{
        type: 'string',
        dataIndex: 'ContactPersonDataIndex'
    },{
        type: 'string',
        dataIndex: 'ContactPerson2DataIndex'
    },{
        type: 'string',
        dataIndex: 'PhoneNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'PhoneNo2DataIndex'
    },{
        type: 'string',
        dataIndex: 'EmailDataIndex'
    },{
        type: 'string',
        dataIndex: 'MobileDataIndex'
    },{
        type: 'string',
        dataIndex: 'Mobile2DataIndex'
    },{
        type: 'string',
        dataIndex: 'CreatedByDataIndex'
    },{
        type: 'date',
        dataIndex: 'CreatedTimeDataIndex'
    },{
        type: 'string',
        dataIndex: 'statusIndex'
    },{
        type: 'string',
        dataIndex: 'UpdatedByDataIndex'
    },{
        type: 'date',
        dataIndex: 'UpdatedTimeDataIndex'
    }  ]
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
            header: "<span style=font-weight:bold;>Company Name</span>",
            dataIndex: 'CompanyNameDataIndex',          
            width: 50,
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Product Type</span>",
            dataIndex: 'CompanyTypeDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Region</span>",
            dataIndex: 'RegionDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Address</span>",
            dataIndex: 'AddressDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Contact Person</span>",
            dataIndex: 'ContactPersonDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Contact Person 2</span>",
            dataIndex: 'ContactPerson2DataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>PhoneNo</span>",
            dataIndex: 'PhoneNoDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>PhoneNo2</span>",
            dataIndex: 'PhoneNo2DataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Email</span>",
            dataIndex: 'EmailDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Mobile</span>",
            dataIndex: 'MobileDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Mobile2</span>",
            dataIndex: 'Mobile2DataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Created By</span>",
            dataIndex: 'CreatedByDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Created Time</span>",
            dataIndex: 'CreatedTimeDataIndex',
            width: 50,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Updated By</span>",
            dataIndex: 'UpdatedByDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Updated Time</span>",
            dataIndex: 'UpdatedTimeDataIndex',
            width: 50,
            filter: {
                type: 'date'
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

	function isValidEmailAddress(emailAddress) {
    	var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    	return pattern.test(emailAddress);
	}

grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 15, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, '', false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title: 'Customer Master',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          width: screen.width - 22,
          height: 545,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
        items: [grid]
    });
     store.load({
		       params: {
		           CustId: custId
		       }
		   });
    sb = Ext.getCmp('form-statusbar');
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
