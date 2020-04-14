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
	if(str.length>11){
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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

tobeConverted.add("Associated_Geofence");
tobeConverted.add("Direct_Loading");
tobeConverted.add("Assessed_Quantity");
tobeConverted.add("Assessed_Quantity_Metric");

tobeConverted.add("Sand_Block_Status");
tobeConverted.add("Sand_Block_Type");
tobeConverted.add("Environmental_Clearance");
tobeConverted.add("River_Name");

tobeConverted.add("Sand_Block_Address");
tobeConverted.add("Survey_No");
tobeConverted.add("Sand_Block_No");
tobeConverted.add("Sand_Block_Name");

tobeConverted.add("Village");
tobeConverted.add("Gram_Panchayat");
tobeConverted.add("Taluka");
tobeConverted.add("Sub_Division");

tobeConverted.add("Division");
tobeConverted.add("District");
tobeConverted.add("State");
tobeConverted.add("SLNO");

tobeConverted.add("Select_State_Name");
tobeConverted.add("Select_District_Name");
tobeConverted.add("Select_Division_Name");
tobeConverted.add("Select_Sub_Division");

tobeConverted.add("Select_Taluka");
tobeConverted.add("Enter_Gram_Panchayat");
tobeConverted.add("Enter_Village");
tobeConverted.add("Enter_Sand_Block_Name");
tobeConverted.add("Enter_Sand_Block_No");

tobeConverted.add("Enter_Survey_No");
tobeConverted.add("Enter_Sand_Block_Address");
tobeConverted.add("Enter_River_Name");
tobeConverted.add("Enter_Environmental_Clearance");

tobeConverted.add("Enter_Sand_Block_Type");
tobeConverted.add("Enter_Sand_Block_Status");
tobeConverted.add("Enter_Assessed_Quantity_Metric");
tobeConverted.add("Enter_Assessed_Quantity");

tobeConverted.add("Enter_Whether_Direct_Loading_Is_Allowed");
tobeConverted.add("Enter_Associated_Geofence");
tobeConverted.add("Select_Division");
tobeConverted.add("Sand_Block_Management");

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("Modify");

tobeConverted.add("Modify_Details");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Sand_Block_Details");

tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("Select_Environmental_Clearence");
tobeConverted.add("Select_Sand_Block_Type");

tobeConverted.add("Select_Sand_Block_Status");
tobeConverted.add("Select_Direct_Loading");
tobeConverted.add("Select_Assessed_Quantity_Metric");
tobeConverted.add("Select_State");

tobeConverted.add("Select_District");
tobeConverted.add("Select_Geofence");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String AssociatedGeofence=convertedWords.get(0);
String DirectLoading=convertedWords.get(1);
String AssessedQuantity=convertedWords.get(2);
String AssessedQuantityMetric=convertedWords.get(3);

String SandBlockStatus=convertedWords.get(4);
String SandBlockType=convertedWords.get(5);
String EnvironmentalClearance=convertedWords.get(6);
String RiverName=convertedWords.get(7);

String SandBlockAddress=convertedWords.get(8);
String SurveyNo=convertedWords.get(9);
String SandBlockNo=convertedWords.get(10);
String SandBlockName=convertedWords.get(11);

String Village=convertedWords.get(12);
String GramPanchayat=convertedWords.get(13);
String Taluka=convertedWords.get(14);
String SubDivision=convertedWords.get(15);

String Division=convertedWords.get(16);
String District=convertedWords.get(17);
String State=convertedWords.get(18);
String SLNO=convertedWords.get(19);

String SelectStateName=convertedWords.get(20);
String SelectDistrictName=convertedWords.get(21);
String SelectDivisionName=convertedWords.get(22);
String SelectSubDivision=convertedWords.get(23);

String SelectTaluka=convertedWords.get(24);
String EnterGramPanchayat=convertedWords.get(25);
String EnterVillage=convertedWords.get(26);
String EnterSandBlockName=convertedWords.get(27);
String EnterSandBlockNo=convertedWords.get(28);
String EnterSurveyNo=convertedWords.get(29);
String EnterSandBlockAddress=convertedWords.get(30);
String EnterRiverName=convertedWords.get(31);
String EnterEnvironmentalClearance=convertedWords.get(32);
String EnterSandBlockType=convertedWords.get(33);
String EnterSandBlockStatus=convertedWords.get(34);
String EnterAssessedQuantityMetric=convertedWords.get(35);
String EnterAssessedQuantity=convertedWords.get(36);
String EnterWhetherDirectLoadingIsAllowed=convertedWords.get(37);
String EnterAssociatedGeofence=convertedWords.get(38);
String SelectDivision=convertedWords.get(39);
String SandBlockManagement=convertedWords.get(40);
String NoRecordsFound=convertedWords.get(41);
String ClearFilterData=convertedWords.get(42);
String Add=convertedWords.get(43);
String Modify=convertedWords.get(44);
String ModifyDetails=convertedWords.get(45);
String NoRowsSelected=convertedWords.get(46);
String SelectSingleRow=convertedWords.get(47);
String SandBlockDetails=convertedWords.get(48);
String Cancel=convertedWords.get(49);
String Save=convertedWords.get(50);
String SelectEnvironmentalClearence=convertedWords.get(51);
String SelectSandBlockType=convertedWords.get(52);
String SelectSandBlockStatus=convertedWords.get(53);
String SelectDirectLoading=convertedWords.get(54);
String SelectAssessedQuantityMetric=convertedWords.get(55);
String SelectState=convertedWords.get(56);
String Selectdistrict=convertedWords.get(57);
String SelectGeofence=convertedWords.get(58);


%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=SandBlockManagement%></title>	
 		  
   
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
var ctsb;
var jspName = "SandBlockManagementReport";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var stateModify;
var districtModify;
var subDivisionModify;
var geoModify;
var stateModify1;
var districtModify1;
var custName;
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custName:custName
                    }
                });
                stateComboStore.load({
                    params: {
                        CustId: custId
                    }
                });
                subDivisionstore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                geoFencestore.load({
                    params: {
                        custId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                
                 districtComboStore.load({
                    params: {
                        
                    }
                });
                talukatstore.load({
                    params: {
                       
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
    emptyText: '<%=SelectDivision%>',
    blankText: '<%=SelectDivision%>',
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custName:custName
                    }
                });
                stateComboStore.load({
                    params: {
                         CustId: custId
                    }
                });
                subDivisionstore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                geoFencestore.load({
                    params: {
                        custId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                
                 districtComboStore.load({
                    params: {
                        
                    }
                });
                talukatstore.load({
                    params: {
                       
                    }
                });
            }
        }
    }
});

var environmentalClearenceStore = new Ext.data.SimpleStore({
    id: 'environmentalClearenceId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Applied', '1'],
        ['Cleared', '2'],
        ['Under Process', '3']
    ]
});

var environmentalClearenceCombo = new Ext.form.ComboBox({
    store: environmentalClearenceStore,
    id: 'environmentalClearenceComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectEnvironmentalClearence%>',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                if (Ext.getCmp('environmentalClearenceComboId').getRawValue() == "Cleared") {
                    Ext.getCmp('sandBlockTypeComboId').enable();
                    Ext.getCmp('sandBlockStatusComboId').enable();
                    Ext.getCmp('assessedQuantityMetricComboId').enable();
                    Ext.getCmp('asssessedQuantityId').enable();
                    Ext.getCmp('directLoadingComboId').enable();
                    Ext.getCmp('geoFencecomboid').enable();
                 } else {
                    Ext.getCmp('sandBlockTypeComboId').disable();
                    Ext.getCmp('sandBlockStatusComboId').disable();
                    Ext.getCmp('assessedQuantityMetricComboId').disable();
                    Ext.getCmp('asssessedQuantityId').disable();
                    Ext.getCmp('directLoadingComboId').disable();
                    Ext.getCmp('geoFencecomboid').disable();
                    
                    Ext.getCmp('sandBlockTypeComboId').reset();
                    Ext.getCmp('sandBlockStatusComboId').reset();
                    Ext.getCmp('assessedQuantityMetricComboId').reset();
                    Ext.getCmp('asssessedQuantityId').reset();
                    Ext.getCmp('directLoadingComboId').reset();
                    Ext.getCmp('geoFencecomboid').reset();
                }
                if (Ext.getCmp('sandBlockStatusComboId').getRawValue() == "InActive" && Ext.getCmp('environmentalClearenceComboId').getRawValue() == "Cleared") {
                    Ext.getCmp('assessedQuantityMetricComboId').disable();
                    Ext.getCmp('asssessedQuantityId').disable();
                    Ext.getCmp('directLoadingComboId').disable();
                    Ext.getCmp('geoFencecomboid').disable();
                }
            }
        }
    }
});

var sandBlockTypeStore = new Ext.data.SimpleStore({
    id: 'sandBlockTypeId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Mined', '1'],
        ['Seized', '2']
    ]
});

var sandBlockTypeCombo = new Ext.form.ComboBox({
    store: sandBlockTypeStore,
    id: 'sandBlockTypeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectSandBlockType%>',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

var sandBlockStatusStore = new Ext.data.SimpleStore({
    id: 'sandBlockTypeId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', '1'],
        ['InActive', '2']
    ]
});

var sandBlockStatusCombo = new Ext.form.ComboBox({
    store: sandBlockStatusStore,
    id: 'sandBlockStatusComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectSandBlockStatus%>',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                var selected = grid.getSelectionModel().getSelected();
                if (Ext.getCmp('sandBlockStatusComboId').getRawValue() == "InActive") {
                    Ext.getCmp('assessedQuantityMetricComboId').disable();
                    Ext.getCmp('asssessedQuantityId').disable();
                    Ext.getCmp('directLoadingComboId').disable();
                    Ext.getCmp('geoFencecomboid').disable();
                    
                    Ext.getCmp('assessedQuantityMetricComboId').reset();
                    Ext.getCmp('asssessedQuantityId').reset();
                    Ext.getCmp('directLoadingComboId').reset();
                    Ext.getCmp('geoFencecomboid').reset();
                } else {
                    Ext.getCmp('assessedQuantityMetricComboId').enable();
                    Ext.getCmp('asssessedQuantityId').enable();
                    Ext.getCmp('directLoadingComboId').enable();
                    Ext.getCmp('geoFencecomboid').enable();
                }
            }
        }
    }
});

var directLoadingStore = new Ext.data.SimpleStore({
    id: 'directLoadingId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Yes', '1'],
        ['No', '2']
    ]
});

var directLoadingCombo = new Ext.form.ComboBox({
    store: directLoadingStore,
    id: 'directLoadingComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectDirectLoading%>',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

var assessedQuantityMetricStore = new Ext.data.SimpleStore({
    id: 'assessedQuantityMetricId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Ton', '1'],
        ['Cm3', '2']
    ]
});

var stateComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
    id: 'stateStoreId',
    root: 'StateRoot',
    autoload: true,
    remoteSort: true,
    fields: ['StateID', 'stateName'],
    listeners: {
        load: function() {}
    }
});

var stateCombo = new Ext.form.ComboBox({
    store: stateComboStore,
    id: 'statecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectState%>',
    blankText: '<%=SelectState%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'StateID',
    displayField: 'stateName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('districtcomboId').reset();
                Ext.getCmp('talukacomboid').reset();
                districtComboStore.load({
                    params: {
                        stateId: Ext.getCmp('statecomboId').getValue()
                    }
                });
                talukatstore.load({
                    params: {
                        districtId: Ext.getCmp('districtcomboId').getValue()
                    }
                });
            }
        }
    }
});

var districtComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDistirctList',
    id: 'districtStoreId',
    root: 'districtRoot',
    autoload: false,
    remoteSort: true,
    fields: ['districtID', 'districtName'],
    listeners: {
        load: function() {}
    }
});
var districtCombo = new Ext.form.ComboBox({
    store: districtComboStore,
    id: 'districtcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Selectdistrict%>',
    blankText: '<%=Selectdistrict%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'districtID',
    displayField: 'districtName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('talukacomboid').reset();
                talukatstore.load({
                    params: {
                        districtId: Ext.getCmp('districtcomboId').getValue()
                    }
                });
            }
        }
    }
});

var subDivisionstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getgroup',
    id: 'subDivisionStoreId',
    root: 'GroupRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['GroupId', 'GroupName']
});

var subDivisioncombo = new Ext.form.ComboBox({
    store: subDivisionstore,
    id: 'groupcomboid',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectSubDivision%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'GroupId',
    displayField: 'GroupName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var talukatstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getTaluka',
    id: 'talukaId',
    root: 'talukaRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['TalukaId', 'TalukaName']
});

var Talukacombo = new Ext.form.ComboBox({
    store: talukatstore,
    id: 'talukacomboid',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectTaluka%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'TalukaId',
    displayField: 'TalukaName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var geoFencestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getGeoFence',
    id: 'geoFenceId',
    root: 'geoFenceRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['geoFenceId', 'geoFenceName']
});

var GeoFencecombo = new Ext.form.ComboBox({
    store: geoFencestore,
    id: 'geoFencecomboid',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectGeofence%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'geoFenceId',
    displayField: 'geoFenceName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var assessedQuantityMetricCombo = new Ext.form.ComboBox({
    store: assessedQuantityMetricStore,
    id: 'assessedQuantityMetricComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectAssessedQuantityMetric%>',
    displayField: 'Name',
    cls: 'selectstylePerfect'
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
            text: '<%=Division%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});

var innerPanelForSandBlockManagement = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 290,
    width: 450,
    frame: true,
    id: 'innerPanelForSandBlockManagementId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=SandBlockDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'sandBlockDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'stateEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=State%>' + ' :',
            cls: 'labelstyle',
            id: 'stateLabelId'
        }, stateCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stateEmptyId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'districtEmptyId1'
        },{
            xtype: 'label',
            text: '<%=District%>' + ' :',
            cls: 'labelstyle',
            id: 'districtLabelId'
        }, districtCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'districtEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId1'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SubDivision%>' + ' :',
            cls: 'labelstyle',
            id: 'subDivisionLabelId'
        }, subDivisioncombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'talukaEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=Taluka%>' + ' :',
            cls: 'labelstyle',
            id: 'talukaLabelId'
        },Talukacombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'talukaEmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'gramPanchayatEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=GramPanchayat%>' + ' :',
            cls: 'labelstyle',
            id: 'gramPanchayatLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterGramPanchayat%>',
            emptyText: '<%=EnterGramPanchayat%>',
            labelSeparator: '',
            id: 'gramPanchayatId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'gramPanchayatId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villagetEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=Village%>' + ' :',
            cls: 'labelstyle',
            id: 'villageLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterVillage%>',
            emptyText: '<%=EnterVillage%>',
            labelSeparator: '',
            id: 'villageId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villageId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandBlockNameEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=SandBlockName%>' + ' :',
            cls: 'labelstyle',
            id: 'sandBlockNameLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterSandBlockName%>',
            emptyText: '<%=EnterSandBlockName%>',
            labelSeparator: '',
            stripCharsRe :/[,]/,
            // maskRe: /^[,]/,
            id: 'sandBlockNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockNameId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SandBlockNo%>' + ' :',
            cls: 'labelstyle',
            id: 'sandBlockNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterSandBlockNo%>',
            emptyText: '<%=EnterSandBlockNo%>',
            labelSeparator: '',
            id: 'sandBlockNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockNoId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'surveyNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SurveyNo%>' + ' :',
            cls: 'labelstyle',
            id: 'surveyNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterSurveyNo%>',
            emptyText: '<%=EnterSurveyNo%>',
            labelSeparator: '',
            id: 'surveyNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'surveyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockAddressEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SandBlockAddress%>' + ' :',
            cls: 'labelstyle',
            id: 'sandBlockAddressLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterSandBlockAddress%>',
            emptyText: '<%=EnterSandBlockAddress%>',
            labelSeparator: '',
            id: 'sandBlockAddressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockAddressId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'riverNameEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=RiverName%>' + ' :',
            cls: 'labelstyle',
            id: 'riverNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterRiverName%>',
            emptyText: '<%=EnterRiverName%>',
            labelSeparator: '',
            id: 'riverNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'riverNameId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'environmentalClearanceEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EnvironmentalClearance%>' + ' :',
            cls: 'labelstyle',
            id: 'environmentalClearanceLabelId'
        },environmentalClearenceCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'environmentalClearanceId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandBlockTypeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SandBlockType%>' + ' :',
            cls: 'labelstyle',
            id: 'sandBlockTypeLabelId'
        }, sandBlockTypeCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockTypeId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandBlockStatusEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=SandBlockStatus%>' + ' :',
            cls: 'labelstyle',
            id: 'sandBlockStatusLabelId'
        }, sandBlockStatusCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandBlockStatusId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'asssessedQuantityMetricEmptyId1'
        },{
            xtype: 'label',
            text: '<%=AssessedQuantityMetric%>' + ' :',
            cls: 'labelstyle',
            id: 'asssessedQuantityMetricLabelId'
        },  assessedQuantityMetricCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'asssessedQuantityMetricId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'asssessedQuantityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=AssessedQuantity%>' + ' :',
            cls: 'labelstyle',
            id: 'asssessedQuantityLabelId'
        },  {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterAssessedQuantity%>',
            emptyText: '<%=EnterAssessedQuantity%>',
            decimalPrecision:10,
            labelSeparator: '',
            id: 'asssessedQuantityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'asssessedQuantityId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'whetherDirectLoadingIsAllowedEmptyId1'
        },{
            xtype: 'label',
            text: '<%=DirectLoading%>' + ' :',
            cls: 'labelstyle',
            id: 'whetherDirectLoadingIsAllowedLabelId'
        }, directLoadingCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'whetherDirectLoadingIsAllowedId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'associatedGeofenceEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=AssociatedGeofence%>' + ' :',
            cls: 'labelstyle',
            id: 'associatedGeofenceLabelId'
        },  GeoFencecombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'associatedGeofenceId2'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 450,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectDivision%>");
                        return;
                    }
                    if (Ext.getCmp('statecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectState%>");
                        return;
                    }
                    if (Ext.getCmp('districtcomboId').getValue() == "") {
                        Ext.example.msg("<%=Selectdistrict%>");
                        return;
                    }
                    if (Ext.getCmp('groupcomboid').getValue() == "") {
                        Ext.example.msg("<%=SelectSubDivision%>");
                        return;
                    }
                    if (Ext.getCmp('talukacomboid').getValue() == "") {
                        Ext.example.msg("<%=SelectTaluka%>");
                        return;
                    }
                    
                    if (Ext.getCmp('sandBlockNameId').getValue() == "") {
                         Ext.example.msg("<%=EnterSandBlockName%>");
                        return;
                    }
                   
                     if (Ext.getCmp('environmentalClearenceComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectEnvironmentalClearence%>");
                        return;
                    }
                    if(Ext.getCmp('environmentalClearenceComboId').getRawValue() == "Cleared")
                    {
                      if (Ext.getCmp('sandBlockTypeComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSandBlockType%>");
                        return;
                    }
                    if (Ext.getCmp('sandBlockStatusComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSandBlockStatus%>");
                        return;
                    }

                    }
                    if(Ext.getCmp('sandBlockStatusComboId').getRawValue() == "Active" && Ext.getCmp('environmentalClearenceComboId').getRawValue() == "Cleared")
                    {
                      if (Ext.getCmp('assessedQuantityMetricComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectAssessedQuantityMetric%>");
                        return;
                    }
					
					if (Ext.getCmp('asssessedQuantityId').getValue() == "") {
					    Ext.example.msg("<%=EnterAssessedQuantity%>");
                        return;
                    }

	                if (Ext.getCmp('directLoadingComboId').getValue() == "") {
	                    Ext.example.msg("<%=SelectDirectLoading%>");
                        return;
                    }
                    
                    if (Ext.getCmp('geoFencecomboid').getValue() == "") {
                        Ext.example.msg("<%=SelectGeofence%>");
                        return;
                    }
                    }
                    //  if (innerPanelForSandBlockManagement.getForm().isValid()) {
                    var id;
                    if (buttonValue == 'Modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('uniqueIdDataIndex');
                        if (selected.get('stateDataIndex') != Ext.getCmp('statecomboId').getValue()) {
                            stateModify = Ext.getCmp('statecomboId').getValue();
                        } else {
                            stateModify = selected.get('stateIdDataIndex');
                        }
                        if (selected.get('districtDataIndex') != Ext.getCmp('districtcomboId').getValue()) {
                            districtModify = Ext.getCmp('districtcomboId').getValue();
                        } else {
                            districtModify = selected.get('districtIdDataIndex');
                        }
                        if (selected.get('subDivisionDataIndex') != Ext.getCmp('groupcomboid').getValue()) {
                            subDivisionModify = Ext.getCmp('groupcomboid').getValue();
                        } else {
                            subDivisionModify = selected.get('subDivisionIdDataIndex');
                        }
                        if (selected.get('associatedGeofenceDataIndex') != Ext.getCmp('geoFencecomboid').getValue()) {
                            geoModify = Ext.getCmp('geoFencecomboid').getValue();
                        } else {
                            geoModify = selected.get('geoFenceIdDataIndex');
                        }
                    }
                    sandBlockManagementOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=sandBlockManagementAddAndModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            state: Ext.getCmp('statecomboId').getValue(),
                            district: Ext.getCmp('districtcomboId').getValue(),
                            subDivision: Ext.getCmp('groupcomboid').getValue(),
                            taluka: Ext.getCmp('talukacomboid').getRawValue(),
                            gramPanchayat: Ext.getCmp('gramPanchayatId').getValue(),
                            village: Ext.getCmp('villageId').getValue(),
                            sandBlockName: Ext.getCmp('sandBlockNameId').getValue(),
                            sandBlockNo: Ext.getCmp('sandBlockNoId').getValue(),
                            surveyNo: Ext.getCmp('surveyNoId').getValue(),
                            sandBlockAddress: Ext.getCmp('sandBlockAddressId').getValue(),
                            riverName: Ext.getCmp('riverNameId').getValue(),
                            environmentalClearence: Ext.getCmp('environmentalClearenceComboId').getRawValue(),
                            sandBlockType: Ext.getCmp('sandBlockTypeComboId').getRawValue(),
                            sandBlockStatus: Ext.getCmp('sandBlockStatusComboId').getRawValue(),
                            assessedQuantityMetric: Ext.getCmp('assessedQuantityMetricComboId').getRawValue(),
                            assessedQuantity: Ext.getCmp('asssessedQuantityId').getValue(),
                            directLoading: Ext.getCmp('directLoadingComboId').getRawValue(),
                            associatedGeoFence: Ext.getCmp('geoFencecomboid').getValue(),
                            id: id,
                            stateModify: stateModify,
                            districtModify: districtModify,
                            subDivisionModify: subDivisionModify,
                            geoModify: geoModify
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('statecomboId').reset();
                            Ext.getCmp('districtcomboId').reset();
                            Ext.getCmp('groupcomboid').reset();
                            Ext.getCmp('talukacomboid').reset();
                            Ext.getCmp('gramPanchayatId').reset();
                            Ext.getCmp('villageId').reset();
                            Ext.getCmp('sandBlockNameId').reset();
                            Ext.getCmp('sandBlockNoId').reset();
                            Ext.getCmp('surveyNoId').reset();
                            Ext.getCmp('sandBlockAddressId').reset();
                            Ext.getCmp('riverNameId').reset();
                            Ext.getCmp('environmentalClearenceComboId').reset();
                            Ext.getCmp('sandBlockTypeComboId').reset();
                            Ext.getCmp('sandBlockStatusComboId').reset();
                            Ext.getCmp('assessedQuantityMetricComboId').reset();
                            Ext.getCmp('asssessedQuantityId').reset();
                            Ext.getCmp('directLoadingComboId').reset();
                            Ext.getCmp('geoFencecomboid').reset();
                            myWin.hide();
                            sandBlockManagementOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                    jspName:jspName,
                        			custName:Ext.getCmp('custcomboId').getRawValue()
                                }
                            });
                            
                            geoFencestore.load({
                    params: {
                        custId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
                        }
                    });
                    //  }
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

var sandBlockManagementOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 340,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForSandBlockManagement, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 390,
    width: 460,
    id: 'myWin',
    items: [sandBlockManagementOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectDivision%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=SandBlockDetails%>';
    myWin.setPosition(450, 150);
    Ext.getCmp('sandBlockTypeComboId').enable();
    Ext.getCmp('sandBlockStatusComboId').enable();
    Ext.getCmp('assessedQuantityMetricComboId').enable();
    Ext.getCmp('asssessedQuantityId').enable();
    Ext.getCmp('directLoadingComboId').enable();
    Ext.getCmp('geoFencecomboid').enable();
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('statecomboId').reset();
    Ext.getCmp('districtcomboId').reset();
    Ext.getCmp('groupcomboid').reset();
    Ext.getCmp('talukacomboid').reset();
    Ext.getCmp('gramPanchayatId').reset();
    Ext.getCmp('villageId').reset();
    Ext.getCmp('sandBlockNameId').reset();
    Ext.getCmp('sandBlockNoId').reset();
    Ext.getCmp('surveyNoId').reset();
    Ext.getCmp('sandBlockAddressId').reset();
    Ext.getCmp('riverNameId').reset();
    Ext.getCmp('environmentalClearenceComboId').reset();
    Ext.getCmp('sandBlockTypeComboId').reset();
    Ext.getCmp('sandBlockStatusComboId').reset();
    Ext.getCmp('assessedQuantityMetricComboId').reset();
    Ext.getCmp('asssessedQuantityId').reset();
    Ext.getCmp('directLoadingComboId').reset();
    Ext.getCmp('geoFencecomboid').reset();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectDivision%>");
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
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('statecomboId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('districtcomboId').setValue(selected.get('districtDataIndex'));
    Ext.getCmp('groupcomboid').setValue(selected.get('subDivisionDataIndex'));
    Ext.getCmp('talukacomboid').setValue(selected.get('talukaDataIndex'));
    Ext.getCmp('gramPanchayatId').setValue(selected.get('gramPanchyatDataIndex'));
    Ext.getCmp('villageId').setValue(selected.get('villageDataIndex'));
    Ext.getCmp('sandBlockNameId').setValue(selected.get('sandBlockNameDataIndex'));
    Ext.getCmp('sandBlockNoId').setValue(selected.get('sandBlockNoDataIndex'));
    Ext.getCmp('surveyNoId').setValue(selected.get('surveyNoDataIndex'));
    Ext.getCmp('sandBlockAddressId').setValue(selected.get('sandBlockAddressDataIndex'));
    Ext.getCmp('riverNameId').setValue(selected.get('riverNameDataIndex'));
    Ext.getCmp('environmentalClearenceComboId').setValue(selected.get('environmentalClearenceDataIndex'));
    Ext.getCmp('sandBlockTypeComboId').setValue(selected.get('sandBlockTypeDataIndex'));
    Ext.getCmp('sandBlockStatusComboId').setValue(selected.get('sandBlockStatusDataIndex'));
    Ext.getCmp('assessedQuantityMetricComboId').setValue(selected.get('assessedQuantityMetrixDataIndex'));
    Ext.getCmp('asssessedQuantityId').setValue(selected.get('assessedQuantityDataIndex'));
    Ext.getCmp('directLoadingComboId').setValue(selected.get('wethereDirectLoadingIsAllowedDataIndex'));
    Ext.getCmp('geoFencecomboid').setValue(selected.get('associatedGeofenceDataIndex'));
  
    if (selected.get('sandBlockStatusDataIndex') == "InActive") {
        Ext.getCmp('assessedQuantityMetricComboId').disable();
        Ext.getCmp('asssessedQuantityId').disable();
        Ext.getCmp('directLoadingComboId').disable();
        Ext.getCmp('geoFencecomboid').disable();
    } else {
        Ext.getCmp('assessedQuantityMetricComboId').enable();
        Ext.getCmp('asssessedQuantityId').enable();
        Ext.getCmp('directLoadingComboId').enable();
        Ext.getCmp('geoFencecomboid').enable();
    }
    if (selected.get('environmentalClearenceDataIndex') == "Cleared") {
        Ext.getCmp('sandBlockTypeComboId').enable();
        Ext.getCmp('sandBlockStatusComboId').enable();
        Ext.getCmp('assessedQuantityMetricComboId').enable();
        Ext.getCmp('asssessedQuantityId').enable();
        Ext.getCmp('directLoadingComboId').enable();
        Ext.getCmp('geoFencecomboid').enable();
    } else {
        Ext.getCmp('sandBlockTypeComboId').disable();
        Ext.getCmp('sandBlockStatusComboId').disable();
        Ext.getCmp('assessedQuantityMetricComboId').disable();
        Ext.getCmp('asssessedQuantityId').disable();
        Ext.getCmp('directLoadingComboId').disable();
        Ext.getCmp('geoFencecomboid').disable();
    }
    if (selected.get('environmentalClearenceDataIndex') == "Cleared" && selected.get('sandBlockStatusDataIndex') == "InActive") {
        Ext.getCmp('assessedQuantityMetricComboId').disable();
        Ext.getCmp('asssessedQuantityId').disable();
        Ext.getCmp('directLoadingComboId').disable();
        Ext.getCmp('geoFencecomboid').disable();
    } 
    if (selected.get('stateDataIndex') != Ext.getCmp('statecomboId').getValue()) {
        stateModify1 = Ext.getCmp('statecomboId').getValue();
    } else {
        stateModify1 = selected.get('stateIdDataIndex');
    }
    if (selected.get('districtDataIndex') != Ext.getCmp('districtcomboId').getValue()) {
        districtModify1 = Ext.getCmp('districtcomboId').getValue();
    } else {
        districtModify1 = selected.get('districtIdDataIndex');
    }
    districtComboStore.load({
        params: {
            stateId: stateModify1
        }
    });
    talukatstore.load({
        params: {
            districtId: districtModify1
        }
    });
}

var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'sandBlockManagementRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'stateDataIndex'
    }, {
        name: 'districtDataIndex'
    }, {
        name: 'subDivisionDataIndex'
    }, {
        name: 'talukaDataIndex'
    }, {
        name: 'gramPanchyatDataIndex'
    }, {
        name: 'villageDataIndex'
    }, {
        name: 'sandBlockNameDataIndex'
    }, {
        name: 'sandBlockNoDataIndex'
    }, {
        name: 'surveyNoDataIndex'
    }, {
        name: 'sandBlockAddressDataIndex'
    }, {
        name: 'riverNameDataIndex'
    }, {
        name: 'environmentalClearenceDataIndex'
    }, {
        name: 'sandBlockTypeDataIndex'
    }, {
        name: 'sandBlockStatusDataIndex'
    }, {
        name: 'assessedQuantityMetrixDataIndex'
    }, {
        name: 'assessedQuantityDataIndex'
    }, {
        name: 'dispatchedQuantityDataIndex'
    }, {
        name: 'wethereDirectLoadingIsAllowedDataIndex'
    }, {
        name: 'associatedGeofenceDataIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'stateIdDataIndex'
    }, {
        name: 'districtIdDataIndex'
    }, {
        name: 'subDivisionIdDataIndex'
    }, {
        name: 'geoFenceIdDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandBlockManagementReport',
        method: 'POST'
    }),
    storeId: 'sandId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'stateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'districtDataIndex'
    }, {
        type: 'string',
        dataIndex: 'subDivisionDataIndex'
    }, {
        type: 'string',
        dataIndex: 'talukaDataIndex'
    }, {
        type: 'string',
        dataIndex: 'gramPanchyatDataIndex'
    }, {
        type: 'string',
        dataIndex: 'villageDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sandBlockNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sandBlockNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'surveyNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sandBlockAddressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'riverNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'environmentalClearenceDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sandBlockTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sandBlockStatusDataIndex'
    }, {
        type: 'string',
        dataIndex: 'assessedQuantityMetrixDataIndex'
    }, {
        type: 'string',
        dataIndex: 'assessedQuantityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'dispatchedQuantityDataIndex' 
    }, {
        type: 'string',
        dataIndex: 'wethereDirectLoadingIsAllowedDataIndex'
    }, {
        type: 'string',
        dataIndex: 'associatedGeofenceDataIndex'
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
            dataIndex: 'stateDataIndex',
            header: "<span style=font-weight:bold;><%=State%></span>",
            hidden: true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=District%></span>",
            dataIndex: 'districtDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SubDivision%></span>",
            dataIndex: 'subDivisionDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Taluka%></span>",
            dataIndex: 'talukaDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=GramPanchayat%></span>",
            dataIndex: 'gramPanchyatDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Village%></span>",
            dataIndex: 'villageDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandBlockName%></span>",
            dataIndex: 'sandBlockNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandBlockNo%></span>",
            dataIndex: 'sandBlockNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SurveyNo%></span>",
            dataIndex: 'surveyNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandBlockAddress%></span>",
            dataIndex: 'sandBlockAddressDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RiverName%></span>",
            dataIndex: 'riverNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EnvironmentalClearance%></span>",
            dataIndex: 'environmentalClearenceDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandBlockType%></span>",
            dataIndex: 'sandBlockTypeDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandBlockStatus%></span>",
            dataIndex: 'sandBlockStatusDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssessedQuantityMetric%></span>",
            dataIndex: 'assessedQuantityMetrixDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssessedQuantity%></span>",
            dataIndex: 'assessedQuantityDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Dispatched Quantity</span>",
            dataIndex: 'dispatchedQuantityDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DirectLoading%></span>",
            dataIndex: 'wethereDirectLoadingIsAllowedDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssociatedGeofence%></span>",
            dataIndex: 'associatedGeofenceDataIndex',
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
grid = getGrid('<%=SandBlockManagement%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 25, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=SandBlockManagement%>',
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
Ext.Ajax.timeout = 360000;
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

