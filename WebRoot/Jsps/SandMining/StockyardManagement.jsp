<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	System.out.println("list contains:"+str.toString());
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

tobeConverted.add("Select_Division");
tobeConverted.add("Division");   
tobeConverted.add("State");     
tobeConverted.add("Sub_Division");   
tobeConverted.add("Taluka");  
tobeConverted.add("Gram_Panchayat");  
tobeConverted.add("Village");       
tobeConverted.add("Sand_Stockyard_Name");
tobeConverted.add("Sand_Stockyard_Address");
tobeConverted.add("River_Name");
tobeConverted.add("Capacity_Of_Stockyard");
tobeConverted.add("Capacity_Metric");
tobeConverted.add("Associated_Geofence"); 
tobeConverted.add("Associated_Sand_Blocks");
tobeConverted.add("Estimated_Sand_Quantity_Available");
tobeConverted.add("Rate_Metric");
tobeConverted.add("Rate");
tobeConverted.add("Assigned_Contractor");
tobeConverted.add("Select_State_Name"); 
tobeConverted.add("Select_Sub_Division"); 
tobeConverted.add("Select_Taluka");       
tobeConverted.add("Enter_Gram_Panchayat"); 
tobeConverted.add("Enter_Village");
tobeConverted.add("Enter_Sand_Stockyard_Name");
tobeConverted.add("Enter_Sand_Stockyard_Address");
tobeConverted.add("Enter_River_Name");
tobeConverted.add("Enter_Capacity_Of_Stockyard");
tobeConverted.add("Select_Capacity_Metric");
tobeConverted.add("Enter_Associated_Geofence");  
tobeConverted.add("Select_Associated_Sand_Blocks");
tobeConverted.add("Enter_Estimated_Sand_Quantity_Available");
tobeConverted.add("Select_Rate_Metric");
tobeConverted.add("Enter_Rate");
tobeConverted.add("Select_Assigned_Contractor");
tobeConverted.add("District");   
tobeConverted.add("Select_District");   
tobeConverted.add("Stockyard_Management");
tobeConverted.add("Select_Division_Name"); 
tobeConverted.add("Stockyard_Information");
tobeConverted.add("Stockyard_Details");
tobeConverted.add("No_Records_Found");   
tobeConverted.add("Clear_Filter_Data"); 
tobeConverted.add("Excel"); 
tobeConverted.add("Add");    
tobeConverted.add("Modify");   
tobeConverted.add("Save");    
tobeConverted.add("Cancel");  
tobeConverted.add("No_Rows_Selected");  
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("SLNO");            
tobeConverted.add("UniqueId_No");
tobeConverted.add("Validate_Mesg_For_Form");    


HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
String SelectDivision=convertedWords.get(0);
String Division=convertedWords.get(1);
String State=convertedWords.get(2);
String SubDivision=convertedWords.get(3); 
String Taluk=convertedWords.get(4); 
String GramPanchayat=convertedWords.get(5);
String Village=convertedWords.get(6); 
String SandStockyardName=convertedWords.get(7);
String SandStockyardAddress=convertedWords.get(8); 
String RiverName=convertedWords.get(9); 
String CapacityofStockyard=convertedWords.get(10); 
String CapacityMetric=convertedWords.get(11); 
String AssociatedGeofence=convertedWords.get(12);
String AssociatedSandBlocks=convertedWords.get(13); 
String EstimatedSandQuantity=convertedWords.get(14);
String RateMetric=convertedWords.get(15); 
String Rate=convertedWords.get(16); 
String AssignedContractor=convertedWords.get(17); 
String SelectState=convertedWords.get(18); 
String SelectSubDivision=convertedWords.get(19);
String SelectTaluk=convertedWords.get(20); 
String EnterGramPanchayat=convertedWords.get(21);
String EnterVillage=convertedWords.get(22);
String EnterSandStockyardName=convertedWords.get(23); 
String EnterSandStockyardAddress=convertedWords.get(24);
String EnterRiverName=convertedWords.get(25); 
String EnterCapacityofStockyard=convertedWords.get(26); 
String SelectCapacityMetric=convertedWords.get(27);
String SelectAssociatedGeofence=convertedWords.get(28); 
String SelectAssociatedSandBlocks=convertedWords.get(29); 
String EnterEstimatedSandQuantity=convertedWords.get(30);
String SelectRateMetric=convertedWords.get(31); 
String EnterRate=convertedWords.get(32); 
String SelectAssignedContractor=convertedWords.get(33); 
String District=convertedWords.get(34); 
String SelectDistrict=convertedWords.get(35);
String StockyardManagement=convertedWords.get(36);
String  SelectDivisionName=convertedWords.get(37); 
String DivisionInformation=convertedWords.get(38);
String DivisionDetails=convertedWords.get(39);
String NoRecordsFound=convertedWords.get(40); 
String ClearFilterData=convertedWords.get(41); 
String Excel=convertedWords.get(42); 
String Add=convertedWords.get(43); 
String Modify=convertedWords.get(44);
String Save=convertedWords.get(45);
String Cancel=convertedWords.get(46);
String NoRowsSelected=convertedWords.get(47); 
String ModifyDetails=convertedWords.get(48);
String SelectSingleRow=convertedWords.get(49);
String SLNO=convertedWords.get(50);
String UNIQUEID=convertedWords.get(51); 
String ValidateMesgForForm=convertedWords.get(52); 

%>

<jsp:include page="../Common/header.jsp" />
    
   
        <title>
		<%=StockyardManagement%>
        </title>
 
    <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
.x-grid3-scroller {
    overflow: auto;
    position: relative;
    width: 1326;
    height:
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
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}	
			.x-menu-list {
				height:auto !important;
			}			
		</style>
	 <%}%>
   <script>
var outerpanel;
var jspName;
var ctsb;
var jspName = "StockyardInformation";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var stateModify;
var districtModify;
var subDivisionModify;
var subDivisionModify;
var geofenceModify;
var districtModify1;
var stateModify1;

var districtstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDistirctList',
    id: 'DistrictStoreId',
    root: 'districtRoot',
    autoLoad: false,
    fields: ['districtID', 'districtName']
});

var districtcombo = new Ext.form.ComboBox({
    store: districtstore,
    id: 'districtcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectDistrict%>',
    blankText: '<%=SelectDistrict%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'districtID',
    displayField: 'districtName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('talukcomboId').reset();
                districtIds = Ext.getCmp('districtcomboId').getValue();
                talukstore.load({
                    params: {
                        districtId: districtIds
                    }
                });
            }
        }
    }
});

var subdivisionstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getgroup',
    id: 'SubDivisionStoreId',
    root: 'GroupRoot',
    autoLoad: true,
    fields: ['GroupId', 'GroupName']
});

var subdivisioncombo = new Ext.form.ComboBox({
    store: subdivisionstore,
    id: 'subdivisioncomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectSubDivision%>',
    blankText: '<%=SelectSubDivision%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'GroupId',
    displayField: 'GroupName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var talukstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getTaluka',
    id: 'TalukStoreId',
    root: 'talukaRoot',
    autoLoad: false,
    fields: ['TalukaId', 'TalukaName']
});

var talukcombo = new Ext.form.ComboBox({
    store: talukstore,
    id: 'talukcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectTaluk%>',
    blankText: '<%=SelectTaluk%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'TalukaName',
    displayField: 'TalukaName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var capacitymetricstore = new Ext.data.SimpleStore({
    id: 'capacitymetricstoreId',
    autoLoad: true,
    fields: ['CapacityMetricName', 'CapacityMetricId'],
    data: [
        ['Ton', 'Ton'],
        ['CM3', 'CM3']
    ]
});

var capacitymetriccombo = new Ext.form.ComboBox({
    store: capacitymetricstore,
    id: 'capacitymetriccomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectCapacityMetric%>',
    blankText: '<%=SelectCapacityMetric%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'CapacityMetricId',
    displayField: 'CapacityMetricName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var associatedgeofencestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getGeoFence1',
    id: 'AssociatedGeofenceStoreId',
    root: 'geoFenceRoot',
    autoLoad: false,
    fields: ['geoFenceId', 'geoFenceName']
});

var associatedgeofencecombo = new Ext.form.ComboBox({
    store: associatedgeofencestore,
    id: 'associatedgeofencecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectAssociatedGeofence%>',
    blankText: '<%=SelectAssociatedGeofence%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'geoFenceId',
    displayField: 'geoFenceName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var associatedsandblocksstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandBlocks',
    id: 'AssociatedSandBlocksStoreId',
    root: 'sandBlocksRoot',
    autoLoad: false,
    fields: ['sandBlocksId', 'sandBlocksName'],
        listeners: {
        load: function() {
            	var i = 0;
            	var k = 0;
            	if (buttonValue == '<%=Modify%>') {
            	    
                	var selected = grid.getSelectionModel().getSelected();
                	var sandBlockNames = selected.get('AssociatedSandBlocksDataIndex');
                	sandBlockLs = sandBlockNames.split(",");
                	associatedsandblocksstore.each(function(rec) {
                    i = 0;
                    for (; i < sandBlockLs.length; i++) {
                        if (rec.get('sandBlocksName') == sandBlockLs[i]) {
                            sandBlockGrid.getSelectionModel().selectRow(k, true);
                        }
                    }
                    k++;
                	});
            }	
        }
    }
});

var sandBlockSelect = new Ext.grid.CheckboxSelectionModel();
var sandBlockGrid = new Ext.grid.GridPanel({
    id: 'sandBlockGridId',
    store: associatedsandblocksstore,
    columns: [
        sandBlockSelect, {
            header: '<%=SelectAssociatedSandBlocks%>',
            hidden: false,
            sortable: true,
            width: 456,
            resizable: true,
            id: 'selectAllSandBlocksId',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'sandBlocksName'
            }]
        }
    ],
    sm: sandBlockSelect,
    plugins: filters,
    stripeRows: true,
    border: true,
    frame: false,
    width: 400,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});


var associatedsandblockscombo = new Ext.form.ComboBox({
    store: associatedsandblocksstore,
    id: 'associatedsandblockscomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectAssociatedSandBlocks%>',
    blankText: '<%=SelectAssociatedSandBlocks%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    resizable: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'sandBlocksName',
    displayField: 'sandBlocksName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var ratemetricstore = new Ext.data.SimpleStore({
    id: 'RateMetricStoreId',
    autoLoad: true,
    fields: ['rateMetricId', 'rateMetricName'],
    data: [
        ['Rupee', 'Rs']
    ]
});

var ratemetriccombo = new Ext.form.ComboBox({
    store: ratemetricstore,
    id: 'ratemetriccomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectRateMetric%>',
    blankText: '<%=SelectRateMetric%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: false,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'rateMetricId',
    displayField: 'rateMetricName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var assignedcontractorstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getAssignedContractor',
    id: 'AssignedContractorStoreId',
    root: 'assignedContractorRoot',
    autoLoad: false,
    fields: ['assignedContractorId', 'assignedContractorName']
});

var assignedcontractorcombo = new Ext.form.ComboBox({
    store: assignedcontractorstore,
    id: 'assignedcontractorcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectAssignedContractor%>',
    blankText: '<%=SelectAssignedContractor%>',
    lazyRender: true,
    selectOnFocus: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'assignedContractorId',
    displayField: 'assignedContractorName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var statestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
    id: 'StateStoreId',
    root: 'StateRoot',
    autoLoad: false,
    fields: ['StateID', 'stateName']
});

var statecombo = new Ext.form.ComboBox({
    store: statestore,
    id: 'statecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectState%>',
    blankText: '<%=SelectState%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: false,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'StateID',
    displayField: 'stateName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('districtcomboId').reset();
                Ext.getCmp('talukcomboId').reset();
                Ext.getCmp('estimatedSandQuantityId').setValue('0.00');  
                // stateIds = 29;
                stateIds = Ext.getCmp('statecomboId').getValue();
                districtstore.load({
                    params: {
                        stateId: stateIds
                    }
                });
                
                talukstore.load({
                    params: {
                        districtId: Ext.getCmp('talukcomboId').getValue()
                    }
                });
            }
        }
    }
});

var innerPanelForOwnerDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 290,
    width: 700,
    frame: true,
    id: 'innerPanelForOwnerDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=DivisionDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'DivisionInformationId',
        width: 670,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'stateNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=State%>' + ' :',
            cls: 'labelstyle',
            id: 'stateLabelId'
        }, statecombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stateNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'districtEmptyId1'
        },{
            xtype: 'label',
            text: '<%=District%>' + ' :',
            cls: 'labelstyle',
            id: 'districtLabelId'
        },  districtcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'districtNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId1'
        },{
            xtype: 'label',
            text: '<%=SubDivision%>' + ' :',
            cls: 'labelstyle',
            id: 'sudDivisionLabelId'
        },  subdivisioncombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'talukEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Taluk%>' + ' :',
            cls: 'labelstyle',
            id: 'talukLabelId'
        },  talukcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'talukId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'gramPanchayatEmptyId1'
        },{
            xtype: 'label',
            text: '<%=GramPanchayat%>' + ' :',
            cls: 'labelstyle',
            id: 'gramPanchayatLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterGramPanchayat%>',
            emptyText: '<%=EnterGramPanchayat%>',
            labelSeparator: '',
            id: 'gramPanchayatId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'gramPanchayatEmptyId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villageEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Village%>' + ' :',
            cls: 'labelstyle',
            id: 'villageLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterVillage%>',
            emptyText: '<%=EnterVillage%>',
            labelSeparator: '',
            id: 'villageId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villageEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandStockyardEmptyId1'
        },{
            xtype: 'label',
            text: '<%=SandStockyardName%>' + ' :',
            cls: 'labelstyle',
            id: 'sandStockyardLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterSandStockyardName%>',
            emptyText: '<%=EnterSandStockyardName%>',
            id: 'sandStockyardNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandStockyardNameId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandStockyardAddressEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SandStockyardAddress%>' + ' :',
            cls: 'labelstyle',
            id: 'sandStockyardAddressLabelId'
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            blankemptyText: '<%=EnterSandStockyardAddress%>',
            emptyText: '<%=EnterSandStockyardAddress%>',
            id: 'sandStockyardAddressId',
            regex: validate('alphanumericname')
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandStockyardaddressId2'
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
            blankText: '<%=EnterRiverName%>',
            emptyText: '<%=EnterRiverName%>',
            id: 'riverNameId',
            regex: validate('alphanumericname')
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'riverNameId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'capacityofStockyardEmptyId1'
        },{
            xtype: 'label',
            text: '<%=CapacityofStockyard%>' + ' :',
            cls: 'labelstyle',
            id: 'capacityofStockyardLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            decimalPrecision: 10,
            blankText: '<%=EnterCapacityofStockyard%>',
            emptyText: '<%=EnterCapacityofStockyard%>',
            id: 'capacityofStockyardId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'capacityofStockyardId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'capacityMetricEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=CapacityMetric%>' + ' :',
            cls: 'labelstyle',
            id: 'capacityMetricLabelId'
        }, capacitymetriccombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'capacityMetricId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'associatedGeofenceEmptyId1'
        },{
            xtype: 'label',
            text: '<%=AssociatedGeofence%>' + ' :',
            cls: 'labelstyle',
            id: 'associatedGeofenceLabelId'
        }, associatedgeofencecombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'associatedGeofenceId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'associatedSandBlocksEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=AssociatedSandBlocks%>' + ' :',
            cls: 'labelstyle',
            id: 'associatedSandBlocksLabelId'
        },sandBlockGrid, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'associatedSandBlocksId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'estimatedSandQuantityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EstimatedSandQuantity%>' + ' :',
            cls: 'labelstyle',
            id: 'estimatedSandQuantityLabelId'
        },  {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            renderer: Ext.util.Format.numberRenderer('0.00'),
            //decimalPrecision: 10,
            emptyText: '<%=EnterEstimatedSandQuantity%>',
            emptyText: '<%=EnterEstimatedSandQuantity%>',
            allowNegative: false,
            id: 'estimatedSandQuantityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'estimatedSandQuantityId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'rateMetricEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=RateMetric%>' + ' :',
            cls: 'labelstyle',
            id: 'rateMetricLabelId'
        },  ratemetriccombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'rateMetricId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'rateEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Rate%>' + ' :',
            cls: 'labelstyle',
            id: 'rateLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterRate%>',
            emptyText: '<%=EnterRate%>',
            allowNegative: false,
            id: 'rateId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'rateId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'assignedContractorEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=AssignedContractor%>' + ' :',
            cls: 'labelstyle',
            id: 'assignedContractorLabelId'
        }, assignedcontractorcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'assignedCintractorId2'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 40,
    width:710,
    frame: false,
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
                    if (Ext.getCmp('statecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectState%>");
                        return;
                    }
                    if (Ext.getCmp('districtcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectDistrict%>");
                        return;
                    }
                    if (Ext.getCmp('subdivisioncomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSubDivision%>");
                        return;
                    }
                    if (Ext.getCmp('talukcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectTaluk%>");
                        return;
                    }
                    if (Ext.getCmp('sandStockyardNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterSandStockyardName%>");
                        return;
                    }
                    if (Ext.getCmp('capacityofStockyardId').getValue() == "") {
                        Ext.example.msg("<%=EnterCapacityofStockyard%>");
                        return;
                    }
                    if (Ext.getCmp('capacitymetriccomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCapacityMetric%>");
                        return;
                    }
                    if (Ext.getCmp('associatedgeofencecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectAssociatedGeofence%>");
                        return;
                    }
                     if (Ext.getCmp('capacityofStockyardId').getValue() < Ext.getCmp('estimatedSandQuantityId').getValue()) {
                        Ext.example.msg('Estimated Available Quantity should be equal or less than Stockyard Capacity');
                        return;
                    }
                    
                    var selectedSandBlocks;
                    selectedSandBlocks = "-";
                    var recordSandBlocks = sandBlockGrid.getSelectionModel().getSelections();
                    for (var i = 0; i < recordSandBlocks.length; i++) {
                        var recordEach = recordSandBlocks[i];
                        var sandBlocksName = recordEach.data['sandBlocksName'];
                        if (selectedSandBlocks == "-") {
                            selectedSandBlocks = sandBlocksName;
                        } else {
                            selectedSandBlocks = selectedSandBlocks + "," + sandBlocksName;
                        }
                    }
                    if (selectedSandBlocks == '' || selectedSandBlocks == '0' || selectedSandBlocks == '-') {
                        Ext.example.msg("<%=SelectAssociatedSandBlocks%>");
                        return;
                    }
                    if (Ext.getCmp('ratemetriccomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectRateMetric%>");
                        return;
                    }
                    if (Ext.getCmp('rateId').getValue() == "") {
                        Ext.example.msg("<%=EnterRate%>");
                        return;
                    }
                        
                    if (buttonValue == 'Modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('UniqueIdDataIndex');
                        if (selected.get('StateDataIndex') != Ext.getCmp('statecomboId').getValue()) {
                            stateModify = Ext.getCmp('statecomboId').getValue();
                        } else {
                            stateModify = selected.get('StateIdDataIndex');
                        }
                        if (selected.get('DistrictDataIndex') != Ext.getCmp('districtcomboId').getValue()) {
                            districtModify = Ext.getCmp('districtcomboId').getValue();
                        } else {
                            districtModify = selected.get('DistrictIdDataIndex');
                        }
                        if (selected.get('SubDivisionDataIndex') != Ext.getCmp('subdivisioncomboId').getValue()) {
                            subDivisionModify = Ext.getCmp('subdivisioncomboId').getValue();
                        } else {
                            subDivisionModify = selected.get('groupIdDataIndex');
                        }
                        if (selected.get('AssociatedGeofenceDataIndex') != Ext.getCmp('associatedgeofencecomboId').getValue()) {
                            geofenceModify = Ext.getCmp('associatedgeofencecomboId').getValue();
                        } else {
                            geofenceModify = selected.get('AssociatedGeofenceIdDataIndex');
                        }
                        if (Ext.getCmp('capacityofStockyardId').getValue() < Ext.getCmp('estimatedSandQuantityId').getValue()) {
                        Ext.example.msg('Estimated Available Quantity should be equal or less than Stockyard Capacity');
                        return;
                    }
                    }
                    if (innerPanelForOwnerDetails.getForm().isValid()) {
                        ownerMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=stockyardManagementAddAndModify',
                            method: 'POST',
                            params: {
                                id: id,
                                buttonValue: buttonValue,
                                divId: Ext.getCmp('divcomboId').getValue(),
                                divName: Ext.getCmp('divcomboId').getRawValue(),
                                state: Ext.getCmp('statecomboId').getValue(),
                                district: Ext.getCmp('districtcomboId').getValue(),
                                subDivision: Ext.getCmp('subdivisioncomboId').getValue(),
                                taluk: Ext.getCmp('talukcomboId').getValue(),
                                gramPanchayat: Ext.getCmp('gramPanchayatId').getValue(),
                                village: Ext.getCmp('villageId').getValue(),
                                sandStockyardName: Ext.getCmp('sandStockyardNameId').getValue(),
                                sandStockyardAddress: Ext.getCmp('sandStockyardAddressId').getValue(),
                                riverName: Ext.getCmp('riverNameId').getValue(),
                                capacityofStockyard: Ext.getCmp('capacityofStockyardId').getValue(),
                                capacityMetric: Ext.getCmp('capacitymetriccomboId').getValue(),
                                associatedGeofence: Ext.getCmp('associatedgeofencecomboId').getValue(),
                                associatedSandBlocks: selectedSandBlocks,
                                estimatedSandQuantity: Ext.getCmp('estimatedSandQuantityId').getValue(),
                                rateMetric: Ext.getCmp('ratemetriccomboId').getRawValue(),
                                rates: Ext.getCmp('rateId').getValue(),
                                assignedContractor: Ext.getCmp('assignedcontractorcomboId').getValue(),
                                stateModify: stateModify,
                                districtModify: districtModify,
                                subDivisionModify: subDivisionModify,
                                geofenceModify: geofenceModify
                              
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                ownerMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: Ext.getCmp('divcomboId').getValue(),
                                        CustName: Ext.getCmp('divcomboId').getRawValue(),
                        				jspName:jspName
                                    }
                                });
                                Ext.getCmp('statecomboId').reset();
                                Ext.getCmp('districtcomboId').reset();
                                Ext.getCmp('subdivisioncomboId').reset();
                                Ext.getCmp('talukcomboId').reset();
                                Ext.getCmp('gramPanchayatId').reset();
                                Ext.getCmp('villageId').reset();
                                Ext.getCmp('sandStockyardNameId').reset();
                                Ext.getCmp('sandStockyardAddressId').reset();
                                Ext.getCmp('riverNameId').reset();
                                Ext.getCmp('capacityofStockyardId').reset();
                                Ext.getCmp('capacitymetriccomboId').reset();
                                Ext.getCmp('associatedgeofencecomboId').reset();
                                Ext.getCmp('estimatedSandQuantityId').reset();
                                Ext.getCmp('ratemetriccomboId').reset();
                                Ext.getCmp('rateId').reset();
                                Ext.getCmp('assignedcontractorcomboId').reset();
                                districtstore.load({
                                    params: {}
                                });
                                talukstore.load({
                                    params: {}
                                });
                                associatedsandblocksstore.load({
                                    params: {}
                                });
                                 associatedgeofencestore.load({
                    params: {
                        custId: Ext.getCmp('divcomboId').getValue()
                    }
                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
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
                    districtstore.load({
                                    params: {}
                                });
                    talukstore.load({
                                    params: {}
                                });
                                
                    myWin.hide();
                }
            }
        }
    }]
});

var ownerMasterOuterPanelWindow = new Ext.Panel({
    width: 720,
    height: 365,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForOwnerDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 385,
    width: 730,
    id: 'myWin',
    items: [ownerMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('divcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectDivisionName%>");
        return;
    }
    buttonValue = '<%=Add%>';
	associatedsandblocksstore.load({
		  params: {
		             custId: Ext.getCmp('divcomboId').getValue()
		  }
	});
    titelForInnerPanel = '<%=DivisionInformation%>';
    myWin.setPosition(325,70);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('statecomboId').reset();
    Ext.getCmp('districtcomboId').reset();
    Ext.getCmp('subdivisioncomboId').reset();
    Ext.getCmp('talukcomboId').reset();
    Ext.getCmp('gramPanchayatId').reset();
    Ext.getCmp('villageId').reset();
    Ext.getCmp('sandStockyardNameId').reset();
    Ext.getCmp('sandStockyardAddressId').reset();
    Ext.getCmp('riverNameId').reset();
    Ext.getCmp('capacityofStockyardId').reset();
    Ext.getCmp('capacitymetriccomboId').reset();
    Ext.getCmp('associatedgeofencecomboId').reset();
    Ext.getCmp('associatedsandblockscomboId').reset();
    Ext.getCmp('estimatedSandQuantityId').reset();
    Ext.getCmp('ratemetriccomboId').reset();
    Ext.getCmp('rateId').reset();
    Ext.getCmp('assignedcontractorcomboId').reset();
    
    Ext.getCmp('statecomboId').enable();
    Ext.getCmp('districtcomboId').enable();
    Ext.getCmp('subdivisioncomboId').enable();
    Ext.getCmp('talukcomboId').enable();
    Ext.getCmp('gramPanchayatId').enable();
    Ext.getCmp('villageId').enable();
    Ext.getCmp('sandStockyardNameId').enable();
    Ext.getCmp('sandStockyardAddressId').enable();
    Ext.getCmp('riverNameId').enable();
    Ext.getCmp('associatedgeofencecomboId').enable();
    Ext.getCmp('ratemetriccomboId').enable();
}

function modifyData() {
    if (Ext.getCmp('divcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectDivisionName%>");
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
    myWin.setPosition(325, 70);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('statecomboId').disable();
    Ext.getCmp('districtcomboId').disable();
    Ext.getCmp('subdivisioncomboId').disable();
    Ext.getCmp('talukcomboId').disable();
    Ext.getCmp('gramPanchayatId').disable();
    Ext.getCmp('villageId').disable();
    Ext.getCmp('sandStockyardNameId').disable();
    Ext.getCmp('sandStockyardAddressId').disable();
    Ext.getCmp('riverNameId').disable();
    Ext.getCmp('capacityofStockyardId').show();
    Ext.getCmp('capacitymetriccomboId').show();
    Ext.getCmp('associatedgeofencecomboId').disable();
    Ext.getCmp('associatedsandblockscomboId').show();
    Ext.getCmp('estimatedSandQuantityId').show();
    Ext.getCmp('ratemetriccomboId').disable();
    Ext.getCmp('rateId').show();
    Ext.getCmp('assignedcontractorcomboId').show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('statecomboId').setValue(selected.get('StateDataIndex'));
    Ext.getCmp('districtcomboId').setValue(selected.get('DistrictDataIndex'));
    Ext.getCmp('subdivisioncomboId').setValue(selected.get('SubDivisionDataIndex'));
    Ext.getCmp('talukcomboId').setValue(selected.get('TalukDataIndex'));
    Ext.getCmp('gramPanchayatId').setValue(selected.get('GramPanchayatDataIndex'));
    Ext.getCmp('villageId').setValue(selected.get('VillageDataIndex'));
    Ext.getCmp('sandStockyardNameId').setValue(selected.get('SandStockyardNameDataIndex'));
    Ext.getCmp('sandStockyardAddressId').setValue(selected.get('SandStockyardAddressDataIndex'));
    Ext.getCmp('riverNameId').setValue(selected.get('RiverNameDataIndex'));
    Ext.getCmp('capacityofStockyardId').setValue(selected.get('CapacityofStockyardDataIndex'));
    Ext.getCmp('capacitymetriccomboId').setValue(selected.get('CapacityMetricDataIndex'));
    Ext.getCmp('associatedgeofencecomboId').setValue(selected.get('AssociatedGeofenceDataIndex'));
    Ext.getCmp('associatedsandblockscomboId').setValue(selected.get('AssociatedSandBlocksDataIndex'));
    Ext.getCmp('estimatedSandQuantityId').setValue(selected.get('EstimatedSandQuantityAvailableDataIndex'));
    Ext.getCmp('ratemetriccomboId').setValue(selected.get('RateMetricDataIndex'));
    Ext.getCmp('rateId').setValue(selected.get('RateDataIndex'));
    Ext.getCmp('assignedcontractorcomboId').setValue(selected.get('AssignedContractorDataIndex'));
    
    if (selected.get('StateDataIndex') != Ext.getCmp('statecomboId').getValue()) {
                            stateModify1 = Ext.getCmp('statecomboId').getValue();
                        } else {
                            stateModify1 = selected.get('StateIdDataIndex');
                        }
                        if (selected.get('DistrictDataIndex') != Ext.getCmp('districtcomboId').getValue()) {
                            districtModify1 = Ext.getCmp('districtcomboId').getValue();
                        } else {
                            districtModify1 = selected.get('DistrictIdDataIndex');
                        }
    associatedsandblocksstore.load({
                    params: {
                        custId: Ext.getCmp('divcomboId').getValue()
                    }
                });
    districtstore.load({
        params: {
            stateId: stateModify1
        }
    });
    talukstore.load({
        params: {
            districtId: districtModify1
        }
    });
}
var reader = new Ext.data.JsonReader({
    idProperty: 'stockYardid',
    root: 'divisionMastersRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
    }, {
        name: 'UniqueIdDataIndex',
    }, {
        name: 'StateDataIndex'
    }, {
        name: 'DistrictDataIndex'
    }, {
        name: 'SubDivisionDataIndex'
    }, {
        name: 'TalukDataIndex'
    }, {
        name: 'GramPanchayatDataIndex'
    }, {
        name: 'VillageDataIndex'
    }, {
        name: 'SandStockyardNameDataIndex'
    }, {
        name: 'SandStockyardAddressDataIndex'
    }, {
        name: 'RiverNameDataIndex'
    }, {
        name: 'CapacityofStockyardDataIndex'
    }, {
        name: 'CapacityMetricDataIndex'
    }, {
        name: 'AssociatedGeofenceDataIndex'
    }, {
        name: 'AssociatedSandBlocksDataIndex'
    }, {
        name: 'EstimatedSandQuantityAvailableDataIndex'
    }, {
        name: 'RateMetricDataIndex'
    }, {
        name: 'RateDataIndex'
    }, {
        name: 'AssignedContractorDataIndex'
    }, {
        name: 'StateIdDataIndex'
    }, {
        name: 'DistrictIdDataIndex'
    }, {
        name: 'groupIdDataIndex'
    }, {
        name: 'AssociatedGeofenceIdDataIndex'
    }, {
        name: 'SeizedQuantityDataIndex'
    }, {
        name: 'DirectQuantityDataIndex'
    }, {
        name: 'DispatchedQtyDataIndex'
    }, {
        name: 'AvailableQtyDataIndex'
    }]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDivisionMasterReport',
        method: 'POST'
    }),
    storeId: 'stockYardId',
    reader: reader
});
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'numeric',
        dataIndex: 'UniqueIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'StateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'DistrictDataIndex'
    }, {
        type: 'string',
        dataIndex: 'SubDivisionDataIndex'
    }, {
        type: 'string',
        dataIndex: 'TalukDataIndex'
    }, {
        type: 'string',
        dataIndex: 'GramPanchayatDataIndex'
    }, {
        type: 'string',
        dataIndex: 'VillageDataIndex'
    }, {
        type: 'string',
        dataIndex: 'SandStockyardNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'SandStockyardAddressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'RiverNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'CapacityofStockyardDataIndex'
    }, {
        type: 'string',
        dataIndex: 'CapacityMetricDataIndex'
    }, {
        type: 'string',
        dataIndex: 'AssociatedGeofenceDataIndex'
    }, {
        type: 'string',
        dataIndex: 'AssociatedSandBlocksDataIndex'
    }, {
        type: 'string',
        dataIndex: 'EstimatedSandQuantityAvailableDataIndex'
    }, {
        type: 'string',
        dataIndex: 'RateMetricDataIndex'
    }, {
        type: 'string',
        dataIndex: 'RateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'AssignedContractorDataIndex'
    }, {
        type: 'string',
        dataIndex: 'SeizedQuantityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'DirectQuantityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'DispatchedQtyDataIndex'
    }, {
        type: 'string',
        dataIndex: 'AvailableQtyDataIndex'
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
        },
        //  {
        //  dataIndex: 'UniqueIdDataIndex',
        //  hidden: true,
        //   header: "<span style=font-weight:bold;><%=UNIQUEID%></span>",
        // filter: {
        //      type: 'numeric'
        //   }
        //   },
        {
            dataIndex: 'StateDataIndex',
            header: "<span style=font-weight:bold;><%=State%></span>",
            hidden: true,
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=District%></span>",
            hidden: true,
            dataIndex: 'DistrictDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SubDivision%></span>",
            dataIndex: 'SubDivisionDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Taluk%></span>",
            dataIndex: 'TalukDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=GramPanchayat%></span>",
            hidden: true,
            dataIndex: 'GramPanchayatDataIndex',
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Village%></span>",
            dataIndex: 'VillageDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandStockyardName%></span>",
            dataIndex: 'SandStockyardNameDataIndex',
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandStockyardAddress%></span>",
            dataIndex: 'SandStockyardAddressDataIndex',
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RiverName%></span>",
            dataIndex: 'RiverNameDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CapacityofStockyard%></span>",
            dataIndex: 'CapacityofStockyardDataIndex',
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CapacityMetric%></span>",
            dataIndex: 'CapacityMetricDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssociatedGeofence%></span>",
            dataIndex: 'AssociatedGeofenceDataIndex',
            width: 380,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssociatedSandBlocks%></span>",
            dataIndex: 'AssociatedSandBlocksDataIndex',
            width: 400,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;><%=RateMetric%></span>",
            dataIndex: 'RateMetricDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Rate%></span>",
            dataIndex: 'RateDataIndex',
            width: 160,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssignedContractor%></span>",
            dataIndex: 'AssignedContractorDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Dumped Quantity</span>",
            dataIndex: 'EstimatedSandQuantityAvailableDataIndex',
            width: 420,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Seized Quantity</span>",
            dataIndex: 'SeizedQuantityDataIndex',
            width: 420,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Direct Quantity</span>",
            dataIndex: 'DirectQuantityDataIndex',
            width: 420,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Dispatched Quantity</span>",
            dataIndex: 'DispatchedQtyDataIndex',
            width: 160,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Available Quantity</span>",
            dataIndex: 'AvailableQtyDataIndex',
            width: 360,
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
grid = getGrid('<%=DivisionDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 30, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>');
//******************************************************************************************************************************************************
var divisioncombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'DivisionStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('divcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('divcomboId').getValue();
                store.load({
                    params: {
                        CustId: Ext.getCmp('divcomboId').getValue(),
                        CustName: Ext.getCmp('divcomboId').getRawValue(),
                        jspName:jspName
                    }
                });
                statestore.load({
                    params: {}
                });
                subdivisionstore.load({
                    params: {
                        CustId: Ext.getCmp('divcomboId').getValue()
                    }
                });
                associatedgeofencestore.load({
                    params: {
                        custId: Ext.getCmp('divcomboId').getValue()
                    }
                });
               assignedcontractorstore.load({
                    params: {
                        custId: Ext.getCmp('divcomboId').getValue()
                    }
                });
                
                districtstore.load({
                    params: {}
                });
                talukstore.load({
                    params: {}
                });
                
                
            }
        }
    }
});
var Division = new Ext.form.ComboBox({
    store: divisioncombostore,
    id: 'divcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectDivisionName%>',
    blankText: '<%=SelectDivisionName%>',
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
                //  custId = Ext.getCmp('divcomboId').getValue();
                statestore.load({
                    params: {}
                });
                subdivisionstore.load({
                    params: {
                        CustId: Ext.getCmp('divcomboId').getValue()
                    }
                });
                associatedgeofencestore.load({
                    params: {
                        custId: Ext.getCmp('divcomboId').getValue()
                    }
                });
                assignedcontractorstore.load({
                    params: {
                        custId: Ext.getCmp('divcomboId').getValue()
                    }
                });
                store.load({
                    params: {
                        CustId: Ext.getCmp('divcomboId').getValue(),
                        CustName: Ext.getCmp('divcomboId').getRawValue(),
                        jspName:jspName
                        
                    }
                });
                districtstore.load({
                    params: {}
                });
                talukstore.load({
                    params: {}
                });
            }
        }
    }
});
var divisionComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'divisionComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=SelectDivision%>' + ' :',
            cls: 'labelstyle'
        },
        Division
    ]
});
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=DivisionInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        autoscroll: true,
        frame: true,
        width: screen.width - 30,
        cls: 'outerpanel',
        // layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [divisionComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
   		var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 170);
        }
});

</script>

 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

