<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	loginInfo.setStyleSheetOverride(str[11].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}

LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Preventive_Maintenance");
tobeConverted.add("Customer");	
tobeConverted.add("SLNO");
tobeConverted.add("Service_Name");
tobeConverted.add("Service_Type");
tobeConverted.add("Days_Of_Service");
tobeConverted.add("KMS_Of_Service");
tobeConverted.add("Status");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("Enter_Task_Name");
tobeConverted.add("Enter_Type");
tobeConverted.add("Enter_Default_Days");
tobeConverted.add("Enter_Default_Distance");
tobeConverted.add("Enter_Status");

tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");

tobeConverted.add("Select_Status");
tobeConverted.add("Add_Service");
tobeConverted.add("Service_Information");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Select_Customer");
tobeConverted.add("Service_Details");



ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String PreventiveMaintenance=convertedWords.get(0);
String Customer=convertedWords.get(1);
String SLNO=convertedWords.get(2);
String ServiceName=convertedWords.get(3);
String ServiceType=convertedWords.get(4);
String DaysOfService=convertedWords.get(5);
String KMSOfService=convertedWords.get(6);
String Status=convertedWords.get(7);
String Add=convertedWords.get(8);
String Modify=convertedWords.get(9);
String Save=convertedWords.get(10);
String Cancel=convertedWords.get(11);

String EnterTaskName=convertedWords.get(12);
String EnterType=convertedWords.get(13);
String EnterDefaultDays=convertedWords.get(14);
String EnterDefaultDistance=convertedWords.get(15);
String EnterStatus=convertedWords.get(16);

String NoRowsSelected=convertedWords.get(17);
String SelectSingleRow=convertedWords.get(18);
String NoRecordsFound=convertedWords.get(19);
String ClearFilterData=convertedWords.get(20);           

String selectStatus=convertedWords.get(21);
String AddService=convertedWords.get(22);
String ServiceInformation=convertedWords.get(23);
String SelectCustomerName=convertedWords.get(24);
String SelectCustomer=convertedWords.get(25);
String ServiceDetails=convertedWords.get(26);
%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=PreventiveMaintenance%></title>		
 
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
  </style>
  
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
  <jsp:include page="../Common/ImportJSSandMining.jsp"/>
  <%}else {%>
  <jsp:include page="../Common/ImportJS.jsp" /><%} %>
  <jsp:include page="../Common/ExportJS.jsp" />
  <style>
	label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height : 21px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		.x-menu-list {
			height: auto !important;
		}
  </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "PreventiveMaintenance";
var exportDataType = "int,string,string,int,int,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;


var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
            if ( <%= customeridlogged %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                custId = Ext.getCmp('custcomboId').getValue();
                taskMasterStore.load({
                    params: {
                        custId: custId,
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
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
    emptyText: '<%=SelectCustomer%>',
    blankText: '<%=SelectCustomer%>',
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                taskMasterStore.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});

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
    emptyText: '<%=selectStatus%>',
    blankText: '<%=selectStatus%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});
var autoupdatecombostore = new Ext.data.SimpleStore({
    id: 'autoupdatecombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['YES', 'YES'],
        ['NO', 'NO']
    ]
});
var autoUpdatecombo = new Ext.form.ComboBox({
    store: autoupdatecombostore,
    id: 'autoUpdateComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=selectStatus%>',
    blankText: '<%=selectStatus%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'NO',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
                if(Ext.getCmp('autoUpdateComboId').getValue() == "NO"){
					Ext.getCmp('mandatorydetentionId').hide();
					Ext.getCmp('detentionTxtId').hide();
					Ext.getCmp('detentionTimeId').hide();  
					Ext.getCmp('mandatorydetentionTimeId').hide();             	
                }else{
					Ext.getCmp('mandatorydetentionId').show();
					Ext.getCmp('detentionTxtId').show();
					Ext.getCmp('detentionTimeId').show(); 
					Ext.getCmp('mandatorydetentionTimeId').show();              	
                }
                
            }
        }
    }
});
var typeComboStore = new Ext.data.SimpleStore({
    id: 'typeComboStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Periodic', 'Periodic'],
        ['Non Periodic', 'Non Periodic']
    ]
});

var typeCombo = new Ext.form.ComboBox({
    store: typeComboStore,
    id: 'typeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Periodic',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

var comboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: true,
    width:screen.width-50,
    layoutConfig: {
        columns: 2
    },
    items: [{
            xtype: 'label',
            text: '<%=Customer%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});

var innerPanelForTaskDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 230,
    width: 400,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=ServiceInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskNameId12'
            },{
                xtype: 'label',
                text: '<%=ServiceName%>' + ' :',
                cls: 'labelstyle',
                id: 'taskNameTxtId'
            },  {
                xtype: 'textfield',
                regex: validate('name'),
                emptyText: '<%=EnterTaskName%>',
                allowBlank: false,
                blankText: '<%=EnterTaskName%>',
                cls: 'selectstylePerfect',
                id: 'taskNameId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskNameId1'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskDymmyId'
            }, {
                xtype: 'label',
                text: '<%=ServiceType%>' + ' :',
                cls: 'labelstyle',
                id: 'typeTxtId'
            }, 
            typeCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskDymmyId2'
            },{
                xtype: 'label',
                text: '<%=DaysOfService%>' + ' :',
                cls: 'labelstyle',
                id: 'defaultDaysTxtId'
            },  {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                value: '<%=100%>',
                allowDecimals: false,
                id: 'defaultDaysId',
                listeners: {
                    change: function (t, n, o) {
                        if (Ext.getCmp('defaultDaysId').getValue() == "") {
                            Ext.getCmp('defaultDaysId').setValue('<%=0%>');
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryDefaultDaysId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskDymmyId4'
            },{
                xtype: 'label',
                text: '<%=KMSOfService%>' + ' :',
                cls: 'labelstyle',
                id: 'defaultDistanceTxtId'
            },  {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                value: '<%=1000%>',
                allowDecimals: false,
                id: 'defaultDistanceId',
                listeners: {
                    change: function (t, n, o) {
                        if (Ext.getCmp('defaultDistanceId').getValue() == "") {
                            Ext.getCmp('defaultDistanceId').setValue('<%=0%>');
                        }
                   }
                   
                }
            },
            
            {
                html: '(Kms)',
                hidden: false,
                id: 'mandatoryDefaultDistanceId1'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryStatusId'
            }, {
                xtype: 'label',
                text: '<%=Status%>' + ' :',
                cls: 'labelstyle',
                id: 'statusTxtId'
            }, 
            statuscombo, { 
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryStatusId1'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryautoUpdateId'
            }, {
                xtype: 'label',
                text: 'Auto Update' + ' :',
                cls: 'labelstyle',
                id: 'autoUpdateTxtId'
            }, 
            autoUpdatecombo, { 
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryautoUpdateId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydetentionId'
            },{
                xtype: 'label',
                text: 'Detention Time' + ' :',
                cls: 'labelstyle',
                id: 'detentionTxtId'
            },{
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                value: '',
                allowDecimals: false,
                id: 'detentionTimeId',
                listeners: {
                    change: function (t, n, o) {
                        
                   }
                   
                }
            },{
                html: '(mins)',
                hidden: false,
                id: 'mandatorydetentionTimeId'
            }
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 380,
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
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                    return;
                    }
                    if (Ext.getCmp('taskNameId').getValue() == "") {
                    Ext.example.msg("<%=EnterTaskName%>");
             	    Ext.getCmp('taskNameId').focus();
                    return;
                    }
                    if (Ext.getCmp('typeComboId').getValue() == "") {
                    Ext.example.msg("<%=EnterType%>");
                    Ext.getCmp('typeComboId').focus();
                    return;
                    }
                    if (Ext.getCmp('statuscomboId').getValue() == "") {
                    Ext.example.msg("<%=EnterStatus%>");
                    Ext.getCmp('statuscomboId').focus();
                    return;
                    }
                    if (Ext.getCmp('autoUpdateComboId').getValue() == "") {
	                    Ext.example.msg("Enter auto update");
	                    Ext.getCmp('autoUpdateComboId').focus();
	                    return;
                    }
                    if(Ext.getCmp('autoUpdateComboId').getValue() == "YES"){
                    	var dtime = Ext.getCmp('detentionTimeId').getValue();
                    	if (dtime.toString() == "" ) {
		                    Ext.example.msg("Please enter detention time");
		                    Ext.getCmp('detentionTimeId').focus();
		                    return;
	                    }
	                    if (Ext.getCmp('detentionTimeId').getValue() < 30 || Ext.getCmp('detentionTimeId').getValue() > 1440 ) {
		                    Ext.example.msg("Please enter greater than 30 mins and less than 1440 mins");
		                    Ext.getCmp('detentionTimeId').focus();
		                    return;
	                    }
                    }
                    var defaultDays = 0;
                    if (Ext.getCmp('defaultDaysId').getValue() != "") {
                        defaultDays = Ext.getCmp('defaultDaysId').getValue();
                    }

                    var defaultDistance = 0;
                    if (Ext.getCmp('defaultDistanceId').getValue() != "") {
                        defaultDistance = Ext.getCmp('defaultDistanceId').getValue();
                    }


                    if (innerPanelForTaskDetails.getForm().isValid()) {
                        var id;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('id');
                        }
                        taskMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=taskMasterAddModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getValue(),
                                taskName: Ext.getCmp('taskNameId').getValue(),
                                type: Ext.getCmp('typeComboId').getValue(),
                                defaultDays: defaultDays,
                                defaultDistance: defaultDistance,
                                status: Ext.getCmp('statuscomboId').getValue(),
                                id: id,
                                jspName: jspName,
                                autoUpdate:Ext.getCmp('autoUpdateComboId').getValue(),
                                detentionTime:Ext.getCmp('detentionTimeId').getValue()
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                
                                Ext.getCmp('taskNameId').reset();
                                Ext.getCmp('typeComboId').reset();
                                Ext.getCmp('defaultDaysId').reset();
                                Ext.getCmp('defaultDistanceId').reset();
                                Ext.getCmp('statuscomboId').reset();
                                Ext.getCmp('autoUpdateComboId').reset();
                                Ext.getCmp('detentionTimeId').reset()
                                myWin.hide();
                                taskMasterStore.reload();
                                taskMasterOuterPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                            Ext.example.msg("Error");
                                
                                taskMasterStore.reload();
                                myWin.hide();
                            }
                        });
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
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

var taskMasterOuterPanelWindow = new Ext.Panel({
    width: 390,
    height:300,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForTaskDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 340,
    width: 390,
    id: 'myWin',
    items: [taskMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    Ext.example.msg("<%=SelectCustomerName%>");
    return;
    }
    buttonValue = 'Add';
    titelForInnerPanel = '<%=AddService%>';
    myWin.setPosition(525, 90);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('taskNameId').enable();
    Ext.getCmp('taskNameId').reset();
    Ext.getCmp('typeComboId').reset();
    Ext.getCmp('defaultDaysId').reset();
    Ext.getCmp('defaultDistanceId').reset();
    Ext.getCmp('statuscomboId').reset();
    Ext.getCmp('autoUpdateComboId').reset();
    Ext.getCmp('detentionTimeId').reset();
    Ext.getCmp('mandatorydetentionId').hide();
	Ext.getCmp('detentionTxtId').hide();
	Ext.getCmp('detentionTimeId').hide();
	Ext.getCmp('mandatorydetentionTimeId').hide();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
	    Ext.example.msg("<%=SelectCustomerName%>");
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
    buttonValue = 'Modify';
    titelForInnerPanel = '<%=Modify%>';
    myWin.setPosition(525, 90);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('taskNameId').disable();
    Ext.getCmp('typeComboId').show();
    Ext.getCmp('defaultDaysId').show();
    Ext.getCmp('defaultDistanceId').show();
    Ext.getCmp('statuscomboId').show();
    Ext.getCmp('autoUpdateComboId').show();
    Ext.getCmp('mandatorydetentionId').show();
	Ext.getCmp('detentionTxtId').show();
    Ext.getCmp('detentionTimeId').show();
    Ext.getCmp('mandatorydetentionTimeId').show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('taskNameId').setValue(selected.get('taskNameDataIndex'));
    Ext.getCmp('typeComboId').setValue(selected.get('typeDataIndex'));
    Ext.getCmp('defaultDaysId').setValue(selected.get('defaultDaysIndex'));
    Ext.getCmp('defaultDistanceId').setValue(selected.get('defaultDistanceDataIndex'));
    Ext.getCmp('statuscomboId').setValue(selected.get('statusDataIndex'));
    Ext.getCmp('autoUpdateComboId').setValue(selected.get('autoUpdateIndex'));
    Ext.getCmp('detentionTimeId').setValue(selected.get('detentionTimeIndex'));
}

var reader = new Ext.data.JsonReader({
    idProperty: 'taskMasterid',
    root: 'taskMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'taskNameDataIndex'
    }, {
        name: 'typeDataIndex'
    }, {
        name: 'defaultDaysIndex'
    }, {
        name: 'defaultDistanceDataIndex'
    }, {
        name: 'statusDataIndex'
    }, {
        name: 'id'
    },{
    	name: 'autoUpdateIndex'
    },{
    	name: 'detentionTimeIndex'
    }]
});

var taskMasterStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getTaskMasterDetails',
        method: 'POST'
    }),
    storeId: 'taskMasterid',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'taskNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'typeDataIndex'
    }, {
        type: 'int',
        dataIndex: 'defaultDaysIndex'
    }, {
        type: 'int',
        dataIndex: 'defaultDistanceDataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusDataIndex'
    },{
    	type : 'string',
    	dataindex: 'autoUpdateIndex'
    },{
    	type : 'string',
    	dataindex: 'detentionTimeIndex'
    }]
});

var createColModel = function (finish, start) {
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
            header: "<span style=font-weight:bold;><%=ServiceName%></span>",
            dataIndex: 'taskNameDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ServiceType%></span>",
            dataIndex: 'typeDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DaysOfService%></span>",
            dataIndex: 'defaultDaysIndex',
            filter: {
                type: 'int'
            }
        }, {
            dataIndex: 'defaultDistanceDataIndex',
            header: "<span style=font-weight:bold;><%=KMSOfService%></span>",
            filter: {
                type: 'int'
            }
        }, {
            dataIndex: 'statusDataIndex',
            header: "<span style=font-weight:bold;><%=Status%></span>",
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'autoUpdateIndex',
            header: "<span style=font-weight:bold;>Auto Update</span>",
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'detentionTimeIndex',
            header: "<span style=font-weight:bold;>Detention Time</span>",
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
grid = getGrid('<%=ServiceDetails%>', 'NoRecordsFound', taskMasterStore, screen.width - 55, 380, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=PreventiveMaintenance%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        cls: 'outerpanel',
        width:screen.width-43,
        height:screen.height-260,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [comboPanel, grid],
       // bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');

});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
 