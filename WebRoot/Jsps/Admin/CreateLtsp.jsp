<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
ArrayList<String> tobeConverted=new ArrayList<String>();	

	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	




%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Create Ltsp</title>	
 		  
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
var ctsb;
var jspName = "Create Ltsp";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;

	var GroupWiseBillingStore = new Ext.data.SimpleStore({
    id: 'GroupWiseBillingId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Y', 'Y'],
        ['N', 'N']
    ]
});

var GroupWiseBillingCombo = new Ext.form.ComboBox({
    store: GroupWiseBillingStore,
    id: 'groupWiseBillingId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Groupwise Billing',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                 }
            }
        }
});


	var countryStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getCountryListForCreateLtsp',
    id: 'countryStoreIdId',
    root: 'countryStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['countryID', 'countryName'],
    listeners: {
        load: function() {}
    }
});
var countryCombo = new Ext.form.ComboBox({
    store: countryStore,
    id: 'countryId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Country',
    blankText: 'Select Country',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'countryID',
    displayField: 'countryName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {

            }
        }
    }
});		
	var bbcOilStore = new Ext.data.SimpleStore({
    id: 'bbcComboStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Yes', 'Yes'],
        ['No', 'No']
    ]
});

var bbcOilCombo = new Ext.form.ComboBox({
    store: bbcOilStore,
    id: 'bccOilId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select bbc Oil',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                 }
            }
        }
});			
	
	var companyLogoStore = new Ext.data.SimpleStore({
    id: 'companyLogoComboStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Yes', 'Yes'],
        ['No', 'No']
    ]
});

var companyLogoCombo = new Ext.form.ComboBox({
    store: companyLogoStore,
    id: 'companyLogoId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Company Logo',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                 }
            }
        }
});		

	var currencyTypeStore = new Ext.data.SimpleStore({
    id: 'currencyTypeStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Rs', 'Rs'],
        ['Dollar', 'Dollar']
    ]
});

var currencyTypeCombo = new Ext.form.ComboBox({
    store: currencyTypeStore,
    id: 'currencyTypeId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Currency Type',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                 }
            }
        }
});		

	var categoryStore = new Ext.data.SimpleStore({
    id: 'categoryComboStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Enterprise', 'Enterprise'],
        ['LTSPIndia', 'LTSPIndia'],
		['LTSPOverseas', 'LTSPOverseas']
    ]
});

var categoryCombo = new Ext.form.ComboBox({
    store: categoryStore,
    id: 'categoryId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Category',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
           // Ext.getCmp('subCategoryId').reset();
             subCategoryStore.load({
                    params: {
                        categoryId: Ext.getCmp('categoryId').getValue()
                    }
                });
                if(Ext.getCmp('categoryId').getValue() == 'LTSPOverseas')
                {
                    Ext.getCmp('serviceTaxNomandatoryId').hide();
                    Ext.getCmp('serviceTaxNoLabelId').hide();
                    Ext.getCmp('serviceTaxNoId').hide();
                    Ext.getCmp('serviceTaxNoEmptyId').hide();
                    Ext.getCmp('panNomandatoryId').hide();
                    Ext.getCmp('tinNomandatoryId').hide();
                    
                }else
                {
                    Ext.getCmp('serviceTaxNomandatoryId').show();
                    Ext.getCmp('serviceTaxNoLabelId').show();
                    Ext.getCmp('serviceTaxNoId').show();
                    Ext.getCmp('serviceTaxNoEmptyId').show();
                    Ext.getCmp('panNomandatoryId').show();
                    Ext.getCmp('tinNomandatoryId').show();
                    
                  
                }
                 }
            }
        }
});		

	var subCategoryStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getSubCategory',
    id: 'subCategoryStoreIdId',
    root: 'subCategoryStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['subCategoryID', 'subCategoryName'],
    listeners: {
        load: function() {}
    }
});
var subCategoryCombo = new Ext.form.ComboBox({
    store: subCategoryStore,
    id: 'subCategoryId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Sub Category',
    blankText: 'Select Sub Category',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'subCategoryID',
    displayField: 'subCategoryName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                     
            }
        }
    }
});			
			

var innerPanelForCreateLtsp = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 270,
    width: 460,
    frame: false,
    id: 'innerPanelForCreateLtspId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'TSP Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'tspDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'companyOrTspmandatoryId'
        }, {
            xtype: 'label',
            text: 'TSP Name' + ' :',
            cls: 'labelstyle',
            id: 'companyOrTspLabelId',
            width:150
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'TSP Name',
            emptyText: 'TSP Name',
            labelSeparator: '',
            id: 'companyOrTspId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'companyOrTspEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addressmandatoryId'
        }, {
            xtype: 'label',
            text: 'Address' + ' :',
            cls: 'labelstyle',
            id: 'addressLabelId'
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Address',
            emptyText: 'Enter Address',
            labelSeparator: '',
            id: 'addressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'addressEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'citymandatoryId'
        }, {
            xtype: 'label',
            text: 'City' + ' :',
            cls: 'labelstyle',
            id: 'cityLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter City',
            emptyText: 'Enter City',
            labelSeparator: '',
            id: 'cityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'cityEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'countrymandatoryId'
        }, {
            xtype: 'label',
            text: 'Country' + ' :',
            cls: 'labelstyle',
            id: 'countryLabelId'
        },countryCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'countryEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'postalCodemandatoryId'
        }, {
            xtype: 'label',
            text: 'Postal Code' + ' :',
            cls: 'labelstyle',
            id: 'postalCodeLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Postal Code',
            emptyText: 'Enter Postal Code',
            labelSeparator: '',
            id: 'postalCodeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'postalCodeEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'latitudemandatoryId'
        }, {
            xtype: 'label',
            text: 'Latitude' + ' :',
            cls: 'labelstyle',
            id: 'latitudeLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Latitude',
            emptyText: 'Enter Latitude',
            labelSeparator: '',
            id: 'latitudeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'latitudeEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'longitudemandatoryId'
        }, {
            xtype: 'label',
            text: 'Longitude' + ' :',
            cls: 'labelstyle',
            id: 'longitudeLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Longitude',
            emptyText: 'Enter Longitude',
            labelSeparator: '',
            id: 'longitudeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'longitudeEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'categorymandatoryId'
        }, {
            xtype: 'label',
            text: 'Category' + ' :',
            cls: 'labelstyle',
            id: 'categoryLabelId'
        },categoryCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'categoryEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subCategorymandatoryId'
        }, {
            xtype: 'label',
            text: 'Sub Category' + ' :',
            cls: 'labelstyle',
            id: 'subCategoryLabelId'
        },subCategoryCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'subCategoryEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'bccOilmandatoryId'
        }, {
            xtype: 'label',
            text: 'BBC Oil' + ' :',
            cls: 'labelstyle',
            id: 'bccOilLabelId'
        }, bbcOilCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'bccOilEmptyId'
        }]
    }]
});

//****************************************************************White Label Panel********************************************************************************************************//
var innerPanelForWhiteLabel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    frame: false,
    id: 'innerPanelForWhiteLabelId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'White Label Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'whiteLabelDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'platformTitlemandatoryId'
        }, {
            xtype: 'label',
            text: 'Platform Title' + ' :',
            cls: 'labelstyle',
            id: 'platformTitleLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Platform Title',
            emptyText: 'Enter Platform Title',
            labelSeparator: '',
            id: 'platformTitleId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'platformTitleEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'companyLogomandatoryId'
        }, {
            xtype: 'label',
            text: 'Company Logo' + ' :',
            cls: 'labelstyle',
            id: 'companyLogoLabelId'
        }, companyLogoCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'companyLogoEmptyId'
        }]
    }]
});

//*****************************************************End Ofwhite label Panel********************************************************************************************//
var innerPanelForTspContactDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    frame: false,
    id: 'innerPanelForTspContactDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'TSP Contact Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'tspContactDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contactPersonmandatoryId'
        }, {
            xtype: 'label',
            text: 'Contact Person' + ' :',
            cls: 'labelstyle',
            id: 'contactPersonLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Contact Person',
            emptyText: 'Enter Contact Person',
            labelSeparator: '',
            id: 'contactPersonId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contactPersonEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'emailIdmandatoryId'
        }, {
            xtype: 'label',
            text: 'Email Id' + ' :',
            cls: 'labelstyle',
            id: 'emailIdLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Email Id',
            emptyText: 'Enter Email Id',
            labelSeparator: '',
            id: 'emailIdId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'emailIdEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'phoneNomandatoryId'
        }, {
            xtype: 'label',
            text: 'Phone Number' + ' :',
            cls: 'labelstyle',
            id: 'phoneNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Phone Number',
            emptyText: 'Enter Phone Number',
            labelSeparator: '',
            id: 'phoneNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'phoneNoEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mobileNomandatoryId'
        }, {
            xtype: 'label',
            text: 'Mobile No' + ' :',
            cls: 'labelstyle',
            id: 'mobileNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Mobile No',
            emptyText: 'Enter Mobile No',
            labelSeparator: '',
            id: 'mobileNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mobileNoEmptyId'
        }]
    }]
});

//*******************************************************8End of Tsp Contact Details**********************************************************************************//
var innerPanelForTspBillingDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    frame: false,
    id: 'innerPanelForTspBillingDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'TSP Billing Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'tspBillingDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'currencyTypemandatoryId'
        }, {
            xtype: 'label',
            text: 'Currency Type' + ' :',
            cls: 'labelstyle',
            id: 'currencyTypeLabelId'
        },currencyTypeCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'currencyTypeEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'panNomandatoryId'
        }, {
            xtype: 'label',
            text: 'PAN No' + ' :',
            cls: 'labelstyle',
            id: 'panNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter PAN No',
            emptyText: 'Enter PAN No',
            labelSeparator: '',
            id: 'panNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'panNoEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tinNomandatoryId'
        }, {
            xtype: 'label',
            text: 'Tin No' + ' :',
            cls: 'labelstyle',
            id: 'tinNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Tin No',
            emptyText: 'Enter Tin No',
            labelSeparator: '',
            id: 'tinNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tinNoEmptyId'
        }, 
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'serviceTaxNomandatoryId'
        }, {
            xtype: 'label',
            text: 'Service Tax No' + ' :',
            cls: 'labelstyle',
            id: 'serviceTaxNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Service Tax No',
            emptyText: 'Enter Service Tax No',
            labelSeparator: '',
            id: 'serviceTaxNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'serviceTaxNoEmptyId'
        },
        
        
        
        
        
        
        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'faxmandatoryId'
        }, {
            xtype: 'label',
            text: 'Fax' + ' :',
            cls: 'labelstyle',
            id: 'faxLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Fax',
            emptyText: 'Enter Fax',
            labelSeparator: '',
            id: 'faxId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'faxEmptyId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'invoiceNoPrefixmandatoryId'
        }, {
            xtype: 'label',
            text: 'Invoice No Prefix' + ' :',
            cls: 'labelstyle',
            id: 'invoiceNoPrefixLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Invoice No Prefix',
            emptyText: 'Enter Invoice No Prefix',
            labelSeparator: '',
            id: 'invoiceNoPrefixId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'invoiceNoPrefixEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'groupWiseBillingmandatoryId'
        }, {
            xtype: 'label',
            text: 'Group Wise Billing' + ' :',
            cls: 'labelstyle',
            id: 'groupWiseBillingLabelId'
        },GroupWiseBillingCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'groupWiseBillingEmptyId'
        }]
    }]
});

//************************************************************************************8End Of Billing details******************************************************************************//
var innerPanelForUserDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    frame: false,
    id: 'innerPanelForUserDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'User Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'userDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'namemandatoryId'
        }, {
            xtype: 'label',
            text: 'Name' + ' :',
            cls: 'labelstyle',
            id: 'nameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Name',
            emptyText: 'Enter Name',
            labelSeparator: '',
            id: 'nameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'nameEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'loginNamemandatoryId'
        }, {
            xtype: 'label',
            text: 'Login Name' + ' :',
            cls: 'labelstyle',
            id: 'loginNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Login Name',
            emptyText: 'Enter Login Name',
            labelSeparator: '',
            id: 'loginNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'loginNameEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'passwordmandatoryId'
        }, {
            xtype: 'label',
            text: 'Password' + ' :',
            cls: 'labelstyle',
            id: 'passwordLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            inputType: 'password',
            allowBlank: false,
            regex: /((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=\S+$)(?=.*\W).{8,30})/,
            regexText: 'passregex',
            blankText: 'Enter Password',
            emptyText: 'Enter Password',
            labelSeparator: '',
            id: 'passwordId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'passwordEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'confirmPasswordmandatoryId'
        }, {
            xtype: 'label',
            text: 'Confirm Password' + ' :',
            cls: 'labelstyle',
            id: 'confirmPasswordLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            inputType: 'password',
            allowBlank: false,
            blankText: 'Enter Confirm Password',
            emptyText: 'Enter Confirm Password',
            labelSeparator: '',
            id: 'confirmPasswordId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'confirmPasswordEmptyId'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 480,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('companyOrTspId').getValue() == "") {
                        Ext.example.msg("Enter Company/TSP");
                        return;
                    }
                    if (Ext.getCmp('addressId').getValue() == "") {
                        Ext.example.msg("Enter Address");
                        return;
                    }
<!--                    if (Ext.getCmp('cityId').getValue() == "") {-->
<!--                        Ext.example.msg("Enter City");-->
<!--                        return;-->
<!--                    }-->
                    if (Ext.getCmp('countryId').getValue() == "") {
                        Ext.example.msg("Enter Country");
                        return;
                    }
<!--                    if (Ext.getCmp('postalCodeId').getValue() == "") {-->
<!--                        Ext.example.msg("Enter Postal Code");-->
<!--                        return;-->
<!--                    }-->
                    if (Ext.getCmp('latitudeId').getValue() == "") {
                        Ext.example.msg("Enter Latitude");
                        return;
                    }
                    if (Ext.getCmp('longitudeId').getValue() == "") {
                        Ext.example.msg("Enter Longitude");
                        return;
                    }
                    if (Ext.getCmp('categoryId').getValue() == "") {
                        Ext.example.msg("Enter Category");
                        return;
                    }
                    if (Ext.getCmp('subCategoryId').getValue() == "") {
                        Ext.example.msg("Enter Sub Category");
                        return;
                    }
                    if (Ext.getCmp('bccOilId').getValue() == "") {
                        Ext.example.msg("Enter Bcc Oil");
                        return;
                    }
                    if (Ext.getCmp('platformTitleId').getValue() == "") {
                        Ext.example.msg("Enter PlatForm Title");
                        return;
                    }
                    if (Ext.getCmp('companyLogoId').getValue() == "") {
                        Ext.example.msg("Enter Company Logo");
                        return;
                    }
                    if (Ext.getCmp('emailIdId').getValue() == "") {
                        Ext.example.msg("Enter Email Id");
                        return;
                    }
                    if (Ext.getCmp('phoneNoId').getValue() == "") {
                        Ext.example.msg("Enter Phone No");
                        return;
                    }
                    if (Ext.getCmp('mobileNoId').getValue() == "") {
                        Ext.example.msg("Enter Mobile No");
                        return;
                    }
                    if (Ext.getCmp('currencyTypeId').getValue() == "") {
                        Ext.example.msg("Enter Currency Type");
                        return;
                    }
                   
                     if(Ext.getCmp('categoryId').getValue() != 'LTSPOverseas')
                     {
                     
                      if (Ext.getCmp('panNoId').getValue() == "") {
                        Ext.example.msg("Enter Pan No");
                        return;
                    }
                    
                    if (Ext.getCmp('tinNoId').getValue() == "") {
                        Ext.example.msg("Enter Tin No");
                        return;
                    }
                    }
                    if (Ext.getCmp('faxId').getValue() == "") {
                        Ext.example.msg("Enter Fax");
                        return;
                    }
                   
                    
                    if (Ext.getCmp('groupWiseBillingId').getValue() == "") {
                        Ext.example.msg("Enter GroupWise Billing");
                        return;
                    }
                    
                    if(buttonValue == 'Add')
                    {
                    if (Ext.getCmp('nameId').getValue() == "") {
                        Ext.example.msg("Enter User Name");
                        return;
                    }
                    if (Ext.getCmp('loginNameId').getValue() == "") {
                        Ext.example.msg("Enter Login Name");
                        return;
                    }
                    if (Ext.getCmp('passwordId').getValue() == "") {
                        Ext.example.msg("Enter Password");
                        return;
                    }
                    if (Ext.getCmp('confirmPasswordId').getValue() == "") {
                        Ext.example.msg("Enter Password To Confirm");
                        return;
                    }
                    }
                    //  if (innerPanelForSandBlockManagement.getForm().isValid()) {
                    if(buttonValue == 'Modify')
                    {
                        var selected = grid.getSelectionModel().getSelected();
                       	systemId=selected.get('systemIdDataIndex');
                    if (selected.get('categoryTypeDataIndex') != Ext.getCmp('subCategoryId').getValue()) {
                            categoryId1 = Ext.getCmp('subCategoryId').getValue();
                        } else {
                            categoryId1 = selected.get('categoryTypeIdDataIndex');
                        }
                        alert(categoryId1);
                    }
                    createLtspOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=CreateLtspAddAndModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            company: Ext.getCmp('companyOrTspId').getValue(),
                            address: Ext.getCmp('addressId').getValue(),
                            city: Ext.getCmp('cityId').getValue(),
                            country: Ext.getCmp('countryId').getValue(),
                            postalCode: Ext.getCmp('postalCodeId').getValue(),
                            latitude: Ext.getCmp('latitudeId').getValue(),
                            longitude: Ext.getCmp('longitudeId').getValue(),
                            category: Ext.getCmp('categoryId').getValue(),
                            subcategory: Ext.getCmp('subCategoryId').getValue(),
                            bccOil: Ext.getCmp('bccOilId').getValue(),
                            platformTitle: Ext.getCmp('platformTitleId').getValue(),
                            companyLogo: Ext.getCmp('companyLogoId').getValue(),
                            emailId: Ext.getCmp('emailIdId').getValue(),
                            phoneNo: Ext.getCmp('phoneNoId').getValue(),
                            mobileNo: Ext.getCmp('mobileNoId').getValue(),
                            currencyType: Ext.getCmp('currencyTypeId').getValue(),
                            panNo: Ext.getCmp('panNoId').getValue(),
                            tinNo: Ext.getCmp('tinNoId').getValue(),
                            faxNo: Ext.getCmp('faxId').getValue(),
                            invoiceNo: Ext.getCmp('invoiceNoPrefixId').getValue(),
                            groupWiseBilling: Ext.getCmp('groupWiseBillingId').getValue(),
                            name: Ext.getCmp('nameId').getValue(),
                            loginName: Ext.getCmp('loginNameId').getValue(),
                            password: Ext.getCmp('passwordId').getValue(),
                            confirmPassword: Ext.getCmp('confirmPasswordId').getValue(),
                            contactPerson: Ext.getCmp('contactPersonId').getValue(),
                            systemId:systemId,
                            categoryId1:categoryId1
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('companyOrTspId').getValue(),
                            Ext.getCmp('addressId').reset();
                            Ext.getCmp('cityId').reset();
                            Ext.getCmp('countryId').reset();
                            Ext.getCmp('postalCodeId').reset();
                            Ext.getCmp('latitudeId').reset();
                            Ext.getCmp('longitudeId').reset();
                            Ext.getCmp('categoryId').reset();
                            Ext.getCmp('subCategoryId').reset();
                            Ext.getCmp('bccOilId').reset();
                            Ext.getCmp('platformTitleId').reset();
                            Ext.getCmp('companyLogoId').reset();
                            Ext.getCmp('emailIdId').reset();
                            Ext.getCmp('phoneNoId').reset();
                            Ext.getCmp('mobileNoId').reset();
                            Ext.getCmp('currencyTypeId').reset();
                            Ext.getCmp('panNoId').reset();
                            Ext.getCmp('tinNoId').reset();
                            Ext.getCmp('faxId').reset();
                            Ext.getCmp('invoiceNoPrefixId').reset();
                            Ext.getCmp('groupWiseBillingId').reset();
                            Ext.getCmp('nameId').reset();
                            Ext.getCmp('loginNameId').reset();
                            Ext.getCmp('passwordId').reset();
                            Ext.getCmp('confirmPasswordId').reset();
                            myWin.hide();
                            createLtspOuterPanelWindow.getEl().unmask();
                            store.load();
                        },
                        
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
                        }
                    });
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

var allInnerPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 310,
    width: 480,
    frame: true,
    id: 'allInnerPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'fieldset',
        title: 'Telematics service Provider',
        collapsible: false,
        colspan: 3,
        width: 450,
        autoScroll: false,
        id: 'allpanelidForCreateLtspDetails',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [innerPanelForCreateLtsp, innerPanelForWhiteLabel, innerPanelForTspContactDetails, innerPanelForTspBillingDetails, innerPanelForUserDetails]
    }]
});

var createLtspOuterPanelWindow = new Ext.Panel({
    width: 490,
    height: 370,
    standardSubmit: true,
    frame: false,
    items: [allInnerPanel, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 420,
    width: 490,
    id: 'myWin',
    items: [createLtspOuterPanelWindow]
});

function addRecord() {
    innerPanelForUserDetails.show();
    Ext.getCmp('companyOrTspId').getValue(),
    Ext.getCmp('addressId').reset();
    Ext.getCmp('cityId').reset();
    Ext.getCmp('countryId').reset();
    Ext.getCmp('postalCodeId').reset();
    Ext.getCmp('latitudeId').reset();
    Ext.getCmp('longitudeId').reset();
    Ext.getCmp('categoryId').reset();
    Ext.getCmp('subCategoryId').reset();
    Ext.getCmp('bccOilId').reset();
    Ext.getCmp('platformTitleId').reset();
    Ext.getCmp('companyLogoId').reset();
    Ext.getCmp('emailIdId').reset();
    Ext.getCmp('phoneNoId').reset();
    Ext.getCmp('mobileNoId').reset();
    Ext.getCmp('currencyTypeId').reset();
    Ext.getCmp('panNoId').reset();
    Ext.getCmp('tinNoId').reset();
    Ext.getCmp('faxId').reset();
    Ext.getCmp('invoiceNoPrefixId').reset();
    Ext.getCmp('groupWiseBillingId').reset();
    Ext.getCmp('nameId').reset();
    Ext.getCmp('loginNameId').reset();
    Ext.getCmp('passwordId').reset();
    Ext.getCmp('confirmPasswordId').reset();
    
     Ext.getCmp('serviceTaxNomandatoryId').show();
     Ext.getCmp('serviceTaxNoLabelId').show();
     Ext.getCmp('serviceTaxNoId').show();
     Ext.getCmp('serviceTaxNoEmptyId').show();
     Ext.getCmp('panNomandatoryId').show();
     Ext.getCmp('tinNomandatoryId').show();
                  
    buttonValue = 'Add';
    titelForInnerPanel = 'Create Ltsp Information';
    myWin.setPosition(450, 120);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
    buttonValue = 'Modify';
    titelForInnerPanel = 'Modify Ltsp Details';
    myWin.setPosition(450, 120);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    innerPanelForUserDetails.hide();
    var selected = grid.getSelectionModel().getSelected();
	Ext.getCmp('companyOrTspId').setValue(selected.get('ltspNameDataIndex'));
    Ext.getCmp('addressId').setValue(selected.get('addressDataIndex'));
    //Ext.getCmp('cityId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('countryId').setValue(selected.get('countryDataIndex'));
    Ext.getCmp('postalCodeId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('latitudeId').setValue(selected.get('latitudeDataIndex'));
    Ext.getCmp('longitudeId').setValue(selected.get('longitudeDataIndex'));
    Ext.getCmp('categoryId').setValue(selected.get('categoryDataIndex'));
    Ext.getCmp('subCategoryId').setValue(selected.get('categoryTypeDataIndex'));
    Ext.getCmp('bccOilId').setValue(selected.get('bbcOilDataIndex'));
    Ext.getCmp('platformTitleId').setValue(selected.get('titleDataIndex'));
    Ext.getCmp('companyLogoId').setValue(selected.get('logoDataIndex'));
    Ext.getCmp('emailIdId').setValue(selected.get('emailIdDataIndex'));
    Ext.getCmp('phoneNoId').setValue(selected.get('telephoneNoDataIndex'));
    Ext.getCmp('mobileNoId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('currencyTypeId').setValue(selected.get('unitOfMeasureDataIndex'));
    Ext.getCmp('panNoId').setValue(selected.get('panNoDataIndex'));
    Ext.getCmp('tinNoId').setValue(selected.get('tinNoDataIndex'));
    Ext.getCmp('faxId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('invoiceNoPrefixId').setValue(selected.get('invoiceNoDataIndex'));
    Ext.getCmp('groupWiseBillingId').setValue(selected.get('groupWiseDataIndex'));
   // Ext.getCmp('nameId').setValue(selected.get('stateDataIndex'));
   // Ext.getCmp('loginNameId').setValue(selected.get('stateDataIndex'));
   // Ext.getCmp('passwordId').setValue(selected.get('stateDataIndex'));
   // Ext.getCmp('confirmPasswordId').setValue(selected.get('stateDataIndex'));
   }

var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'createLtspRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'systemIdDataIndex'
    },{
        name: 'ltspNameDataIndex'
    },{
        name: 'addressDataIndex'
    },{
        name: 'countryDataIndex'
    },{
        name: 'latitudeDataIndex'
    },{
        name: 'longitudeDataIndex'
    },{
        name: 'categoryDataIndex'
    },{
        name: 'categoryTypeDataIndex'
    },{
        name: 'bbcOilDataIndex'
    },{
        name: 'titleDataIndex'
    },{
        name: 'logoDataIndex'
    },{
        name: 'contactPersonDataIndex'
    },{
        name: 'emailIdDataIndex'
    },{
        name: 'telephoneNoDataIndex'
    },{
        name: 'unitOfMeasureDataIndex'
    },{
        name: 'panNoDataIndex'
    },{
        name: 'tinNoDataIndex'
    },{
        name: 'invoiceNoDataIndex'
    },{
        name: 'groupWiseDataIndex'
    },{
      name:'categoryTypeIdDataIndex'
      }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getCreateLtspReport',
        method: 'POST'
    }),
    storeId: 'createLtspId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'ltspNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'addressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'emailIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'telephoneNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'countryDataIndex'
    }, {
        type: 'string',
        dataIndex: 'categoryDataIndex'
    }, {
        type: 'string',
        dataIndex: 'categoryTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusDataIndex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'ltspNameDataIndex',
            header: "<span style=font-weight:bold;>Ltsp Name</span>",
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Address</span>",
            dataIndex: 'addressDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Email Id</span>",
            dataIndex: 'emailIdDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Phone No</span>",
            dataIndex: 'telephoneNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Country</span>",
            dataIndex: 'countryDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Category</span>",
            dataIndex: 'categoryDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Category Type</span>",
            dataIndex: 'categoryTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>SystemId</span>",
            dataIndex: 'systemIdDataIndex',
            hidden:true,
            width: 100,
            filter: {
                type: 'string'
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
grid = getGrid('Create Ltsp Details', 'NoRecordsFound', store, screen.width - 40, 420, 20, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, '', jspName, exportDataType, false, 'PDF', true, 'Add', true, 'Modify', false, '');
//******************************************************************************************************************************************************
var nextButtonPanel = new Ext.Panel({
    id: 'nextbuttonid',
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
        text: 'Next',
        id: 'nextButtId',
        iconCls: 'nextbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    window.location = "<%=request.getContextPath()%>/Jsps/Admin/ProductFeatureForCreateLtsp.jsp?";
                }
            }
        }
    }]
});

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Create Ltsp',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid, nextButtonPanel]
    });
    store.load();
    countryStore.load();
});
</script>
</body>
</html>
<%}%>
    
    
    
    
    

