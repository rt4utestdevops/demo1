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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add_Weighbridge_Details");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Weighbridge_Master_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Organization_Name");
tobeConverted.add("Select_Organization_Name");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Company_Name");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Weighbridge_Details");
tobeConverted.add("Enter_Company_Name");
tobeConverted.add("Enter_Mineral_Code");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Location");
tobeConverted.add("Select_Location");
tobeConverted.add("Supplier_Name");
tobeConverted.add("Enter_Supplier_Name");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Add_Weighbridge_Details=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String Weighbridge_Master_Details=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String organizationName=convertedWords.get(10);
String SelectOrganizationName=convertedWords.get(11);
String Excel=convertedWords.get(12);
String Delete=convertedWords.get(13);
String companyName=convertedWords.get(14);
String NoRowsSelected=convertedWords.get(15);
String SelectSingleRow=convertedWords.get(16);
String Modify_Weighbridge_Details=convertedWords.get(17);
String Enter_Company_Name=convertedWords.get(18);
String Enter_Mineral_Code=convertedWords.get(19);
String Save=convertedWords.get(20);
String Cancel=convertedWords.get(21);
String weighbridgeLocation=convertedWords.get(22);
String SelectHubLocation=convertedWords.get(23);
String supplierName=convertedWords.get(24);
String Enter_Supplier_Name=convertedWords.get(25);
String Weighbridge_Details="Weighbridge Details";
String weighbridgeId="Weighbridge Id";
String Enter_Weighbridge="Enter Weighbridge Id";
String weighbridgeModel="Weighbridge Model";
String Enter_Weighbridge_Model="Enter Weighbridge Model";



int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Weighbridge Master</title>		
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
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Weighbride Master Details";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;
var orgNameId;
var hubLocationId;

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
                        CustId: custId
                    }
                });
               OrgCodeComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
                HubLocationStore.load({
                    params: {
                        CustID: custId
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
                        CustId: custId
                    }
                });
                OrgCodeComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
                HubLocationStore.load({
                    params: {
                        CustID: custId
                    }
                });
            }
        }
    }
});
//**********************Org combo*********************************************//
var OrgCodeComboStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/WeighbridgeMasterAction.do?param=getOrganisationCode',
				   root: 'orgRoot',
			       autoLoad: false,
				   fields: ['orgName','orgId']
	});
	
var OrgCodeCombo = new Ext.form.ComboBox({
    store: OrgCodeComboStore,
    id: 'orgComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectOrganizationName%>',
    blankText: '<%=SelectOrganizationName%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'orgId',
    displayField: 'orgName',
    cls:'selectstylePerfectnew',
    resizable: true,
    listeners: {
        select: {
            fn: function () {
            	orgNameId=Ext.getCmp('orgComboId').getValue();
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
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});
//******************************** Hub Location **************************************//
var HubLocationStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/WeighbridgeMasterAction.do?param=getHubLocation',
           id: 'hubLocationStoreId',
				    root: 'sourceHubStoreRoot',
				    autoload: false,
				    remoteSort: true,
				    fields: ['Hubname','HubID']
	});
	
var HubLocationCombo = new Ext.form.ComboBox({
    store: HubLocationStore,
    id: 'HubLocationcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectHubLocation%>',
    blankText: '<%=SelectHubLocation%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'HubID',
    displayField: 'Hubname',
    cls:'selectstylePerfectnew',
    resizable: true,
    listeners: {
        select: {
            fn: function () {
				hubLocationId=Ext.getCmp('HubLocationcomboId').getValue();
            }
        }
    }
});
var innerPanelForWeighbridgeMaster = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 280,
    width: 450,
    frame: false,
    id: 'innerPanelForWeighbridgeMasterId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title:'<%=Weighbridge_Details%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 4,
        id: 'WBInfoId',
        width: 445,
        height:270,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'orgNameEmptyId'
        },{
            xtype: 'label',
            text: '<%=organizationName %>' + ' :',
            cls: 'labelstylenew',
            id: 'orgNameLabelId'
        }, OrgCodeCombo, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'MandatoryWBId'
        },{
            xtype: 'label',
            text: '<%=weighbridgeLocation%>' + ' :',
            cls: 'labelstylenew',
            id: 'WBLocationLabelId'
        }, HubLocationCombo, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=weighbridgeId %>' + ' :',
            cls: 'labelstylenew',
            id: 'weighbridgeLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'weighbridgeId',
            mode: 'local',
            forceSelection: true,
            height:30,
            emptyText: '<%=Enter_Weighbridge%>',
            blankText: '<%=Enter_Weighbridge%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					}
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId2'
        },{
            xtype: 'label',
            text: '<%=companyName %>' + ' :',
            cls: 'labelstylenew',
            id: 'companyNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'companyNameId',
            mode: 'local',
            forceSelection: true,
            height:30,
            emptyText: '<%=Enter_Company_Name%>',
            blankText: '<%=Enter_Company_Name%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					}
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId3'
        },{
            xtype: 'label',
            text: '<%=weighbridgeModel %>' + ' :',
            cls: 'labelstylenew',
            id: 'weighbridgeModelLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'weighbridgeModelId',
            mode: 'local',
            forceSelection: true,
            height:30,
            emptyText: '<%=Enter_Weighbridge_Model%>',
            blankText: '<%=Enter_Weighbridge_Model%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					}
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId4'
        },{
            xtype: 'label',
            text: '<%=supplierName %>' + ' :',
            cls: 'labelstylenew',
            id: 'supplierNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'supplierNameId',
            mode: 'local',
            forceSelection: true,
            height:30,
            emptyText: '<%=Enter_Supplier_Name%>',
            blankText: '<%=Enter_Supplier_Name%>',
           selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					}
        }
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 445,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   var OrgIdmodify;
<!--                    if (Ext.getCmp('orgComboId').getValue() == "") {-->
<!--                    Ext.example.msg("<%=SelectOrganizationName%>");-->
<!--                    Ext.getCmp('orgComboId').focus();-->
<!--                        return;-->
<!--                    }-->
                     if (Ext.getCmp('HubLocationcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectHubLocation%>");
                    Ext.getCmp('HubLocationcomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('weighbridgeId').getValue() == "") {
                    Ext.example.msg("<%=Enter_Weighbridge%>");
                    Ext.getCmp('weighbridgeId').focus();
                        return;
                    }
                     if (Ext.getCmp('companyNameId').getValue() == "") {
                    Ext.example.msg("<%=Enter_Company_Name%>");
                    Ext.getCmp('companyNameId').focus();
                        return;
                    }
                     if (Ext.getCmp('weighbridgeModelId').getValue() == "") {
                    Ext.example.msg("<%=Enter_Weighbridge_Model%>");
                    Ext.getCmp('weighbridgeModelId').focus();
                        return;
                    }
                     if (Ext.getCmp('supplierNameId').getValue() == "") {
                    Ext.example.msg("<%=Enter_Supplier_Name%>");
                    Ext.getCmp('supplierNameId').focus();
                        return;
                    }
                    
                   
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            
                            id = selected.get('uniqueIdDataIndex');
                            
                             if (selected.get('organizationNameIndex') != Ext.getCmp('orgComboId').getValue()) {
                                OrgIdmodify = Ext.getCmp('orgComboId').getValue();
                            } else {
                                OrgIdmodify = selected.get('orgIdIndex');
                            }
                        }
                        WBMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/WeighbridgeMasterAction.do?param=AddorModifyWeighbridgeDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: Ext.getCmp('custcomboId').getValue(),
                                orgId: Ext.getCmp('orgComboId').getValue(),
                                hubLocation: hubLocationId,
								weighbridge: Ext.getCmp('weighbridgeId').getValue(),
								companyName: Ext.getCmp('companyNameId').getValue(),
								weighbridgeModel: Ext.getCmp('weighbridgeModelId').getValue(),
								supplierName: Ext.getCmp('supplierNameId').getValue(),
                                id: id,
                                OrgIdmodify : OrgIdmodify
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
							    Ext.getCmp('orgComboId').reset();
							    Ext.getCmp('HubLocationcomboId').reset();
							    Ext.getCmp('weighbridgeId').reset();
							    Ext.getCmp('companyNameId').reset();
							    Ext.getCmp('weighbridgeModelId').reset();
							    Ext.getCmp('supplierNameId').reset();
                                myWin.hide();
                                WBMasterOuterPanelWindow.getEl().unmask();
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
                    //}
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

var WBMasterOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 340,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForWeighbridgeMaster, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 390,
    width: 475,
    id: 'myWin',
    items: [WBMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=Add_Weighbridge_Details%>';
    myWin.setPosition(450, 50);
    myWin.show();

    Ext.getCmp('orgComboId').reset();
    Ext.getCmp('HubLocationcomboId').reset();
    Ext.getCmp('weighbridgeId').reset();
    Ext.getCmp('companyNameId').reset();
    Ext.getCmp('weighbridgeModelId').reset();
    Ext.getCmp('supplierNameId').reset();
    Ext.getCmp('weighbridgeId').setReadOnly(false);
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Rows Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("Select Single Row");
        return;
    }
    buttonValue = 'Modify';
    titelForInnerPanel = '<%=Modify_Weighbridge_Details%>';
    myWin.setPosition(450, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 	Ext.getCmp('orgComboId').reset();
    Ext.getCmp('HubLocationcomboId').reset();
    Ext.getCmp('weighbridgeId').reset();
    Ext.getCmp('companyNameId').reset();
    Ext.getCmp('weighbridgeModelId').reset();
    Ext.getCmp('supplierNameId').reset();
    
    var selected = grid.getSelectionModel().getSelected();
   
    source = selected.get('LocationIdIndex');
    id0 = HubLocationStore.find('HubID', source);
    recordO = HubLocationStore.getAt(id0);
    var hubLocation = recordO.data['Hubname'];
    hubLocationId = selected.get('LocationIdIndex');
    Ext.getCmp('orgComboId').setValue(selected.get('organizationNameIndex'));
	Ext.getCmp('HubLocationcomboId').setValue(hubLocation);	
	Ext.getCmp('weighbridgeId').setValue(selected.get('weighbridgeIdIndex'));
	Ext.getCmp('weighbridgeId').setReadOnly(true);
	Ext.getCmp('companyNameId').setValue(selected.get('companyNameIndex'));
	Ext.getCmp('weighbridgeModelId').setValue(selected.get('weighbridgeModelIndex'));
	Ext.getCmp('supplierNameId').setValue(selected.get('supplierNameIndex'));
    }
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'weighbridgeMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'uniqueIdDataIndex'
    },{
        name: 'organizationNameIndex'
    },{
        name: 'orgIdIndex'
    },{
        name: 'weighbridgeLocationIndex'
    },{
        name: 'LocationIdIndex'
    },{
        name: 'weighbridgeIdIndex'
    },{
        name: 'companyNameIndex'
    },{
        name: 'weighbridgeModelIndex'
    },{
    	name: 'supplierNameIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/WeighbridgeMasterAction.do?param=getWeighbrideMasterDetails',
        method: 'POST'
    }),
    storeId: 'weighbridgeMasterStoreId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'int',
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'organizationNameIndex'
    }, {
        type: 'string',
        dataIndex: 'weighbridgeLocationIndex'
    }, {
        type: 'string',
        dataIndex: 'weighbridgeIdIndex'
    }, {
        type: 'string',
        dataIndex: 'companyNameIndex'
    }, {
        type: 'string',
        dataIndex: 'weighbridgeModelIndex'
    }, {
        type: 'string',
        dataIndex: 'supplierNameIndex'
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
        },{
            header: "<span style=font-weight:bold;><%=organizationName%></span>",
            dataIndex: 'organizationNameIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=weighbridgeLocation%></span>",
            dataIndex: 'weighbridgeLocationIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=weighbridgeId%></span>",
            dataIndex: 'weighbridgeIdIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=companyName%></span>",
            dataIndex: 'companyNameIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=weighbridgeModel%></span>",
            dataIndex: 'weighbridgeModelIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=supplierName%></span>",
            dataIndex: 'supplierNameIndex',
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

grid = getGrid('<%=Weighbridge_Master_Details%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 8, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
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
</body>
</html>
<%}%>
<%}%>