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
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");

tobeConverted.add("Organization_Code");
tobeConverted.add("Organization_Name");
tobeConverted.add("Select_Organization_Name");
tobeConverted.add("Organization_Code");

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
String ModifyDetails=convertedWords.get(10);
String SelectCustomer=convertedWords.get(11);
String CustomerName=convertedWords.get(12);
String organizationCode=convertedWords.get(13);
String organizationName=convertedWords.get(14);
String SelectOrganizationName=convertedWords.get(15);
String EnterOrganizationCode=convertedWords.get(16);

String selectHubLocation = "Select Hub Location";	
		
int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

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
		<base href="<%=basePath%>">
		<title>Route Master</title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 
<script>
    var outerPanel;
    var jspName = "Route Master Details";
    var exportDataType = "int,string,string,string,string,string,int,number,string,string,int,int,string,int,string";
    var grid;
    var myWin;
    var buttonValue;
    var orgCode;
    var orgName;
    var selected;
    var newRowAdded = 0;
    var editedRowsForTimeLimit = "";
    var removedData = '';

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
                if (<%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    store.load({
                        params: {
                            CustId: custId,
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue()
                        }
                    });
                    OrgNameComboStore.load({
                        params: {
                            clientId: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    HubLocationStore.load({
                        params: {
                            CustID: custId
                        }
                    });
                    motherRouteComboStore.load({
                        params: {
                            custId: custId,
                            buttonValue: buttonValue
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
                            CustId: custId,
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue()
                        }
                    });
                    HubLocationStore.load({
                        params: {
                            CustID: custId
                        }
                    });
                    OrgNameComboStore.load({
                        params: {
                            clientId: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    motherRouteComboStore.load({
                        params: {
                            custId: custId,
                            buttonValue:buttonValue
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
            }
        ]
    });
    //*******************org store*******************************************************  
    var OrgNameComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=getOrgname',
        root: 'OrgnameRoot',
        autoLoad: false,
        id: 'orgnameId',
        fields: ['id', 'organizationCode', 'organizationName']
    });

    //****************************combo for OrgCode***************************************
    var OrgNameCombo = new Ext.form.ComboBox({
        store: OrgNameComboStore,
        id: 'OrgnamecomboId',
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
        valueField: 'id',
        displayField: 'organizationName',
        cls: 'selectstylePerfectnew',
        listeners: {
            select: {
                fn: function() {

                    var id = Ext.getCmp('OrgnamecomboId').getValue();
                    var row = OrgNameComboStore.findExact('id', id);
                    var rec = OrgNameComboStore.getAt(row);
                    orgcode = rec.data['organizationCode'];
                }
            }
        }
    });

    //*******************Mother Route store*******************************************************  
    var motherRouteComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=getMotherRoute',
        root: 'motherRnameRoot',
        autoLoad: false,
        id: 'motherRId',
        fields: ['id', 'motherRouteName', 'motherRLimit', 'motherRBal']
    });

    //****************************combo for Mother Route***************************************
    var motherRouteCombo = new Ext.form.ComboBox({
        store: motherRouteComboStore,
        id: 'motherRoutecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Mother Route',
        blankText: 'Select Mother Route',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        displayField: 'motherRouteName',
        cls: 'selectstylePerfectnew',
        listeners: {
            select: {
                fn: function() {
                    var row = motherRouteComboStore.findExact('id', Ext.getCmp('motherRoutecomboId').getValue());
                    var rec = motherRouteComboStore.getAt(row);
                    Ext.getCmp('motherRLimitId').setValue(rec.data['motherRLimit']);
                    Ext.getCmp('motherRBalId').setValue(rec.data['motherRBal']);
                    Ext.getCmp('OrgnamecomboId').reset();
                    Ext.getCmp('routeNameID').reset();
                    Ext.getCmp('SourceHubcomboId').reset();
                    Ext.getCmp('DestinationHubcomboId').reset();
                    Ext.getCmp('distanceId').reset();
                    timeLimitStore.removeAll();
                    newRowAdded = 0;
                }
            }
        }
    });

    //******************************** Hub Location **************************************//
    var HubLocationStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=getHubLocation',
        id: 'hubLocationStoreId',
        root: 'sourceHubStoreRoot',
        autoload: false,
        remoteSort: true,
        fields: ['Hubname', 'HubID']
    });

    var SourceHubCombo = new Ext.form.ComboBox({
        store: HubLocationStore,
        id: 'SourceHubcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=selectHubLocation%>',
        blankText: '<%=selectHubLocation%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubID',
        displayField: 'Hubname',
        cls: 'selectstylePerfectnew',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                    hubLocationId = Ext.getCmp('SourceHubcomboId').getValue();
                }
            }
        }
    });

    var DestinationHubCombo = new Ext.form.ComboBox({
        store: HubLocationStore,
        id: 'DestinationHubcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=selectHubLocation%>',
        blankText: '<%=selectHubLocation%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubID',
        displayField: 'Hubname',
        cls: 'selectstylePerfectnew',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                    hubLocationId = Ext.getCmp('DestinationHubcomboId').getValue();
                }
            }
        }
    });
	
	 //******************************store for sourcetype**********************************
    var sourceTypeStore = new Ext.data.SimpleStore({
        id: 'srcTypComboStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Lease', 'Lease'],
            ['Non-Lease', 'Non-Lease']
        ]
    });
	 var srcTypeCombo = new Ext.form.ComboBox({
        store: sourceTypeStore,
        id: 'sourceTypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Route Type',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfectnew',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
    //****************************combo for sourcetype****************************************

    var timeLimitReader = new Ext.data.JsonReader({
        idProperty: 'timeLimitRootId',
        root: 'timeLimitRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'fromTimeIndex'
        }, {
            name: 'toTimeIndex'
        }, {
            name: 'limitIndex'
        }, {
            name: 'uidIndex'
        }]
    });
    var timeLimitFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'string',
            dataIndex: 'fromTimeIndex'
        }, {
            type: 'string',
            dataIndex: 'toTimeIndex',
        }, {
            type: 'int',
            dataIndex: 'limitIndex',
        }]
    });
    var timeLimitColModel = new Ext.grid.ColumnModel({
        columns: [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                dataIndex: 'SLNOIndex',
                width: 50
            }), {
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 30,
                hidden: true,
                dataIndex: 'SLNOIndex'
            }, {
                header: "<span style=font-weight:bold;>From Time(HH:mm:ss)</span>",
                sortable: true,
                dataIndex: 'fromTimeIndex',
                width: 200,
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({}))
            }, {
                header: "<span style=font-weight:bold;>To Time(HH:mm:ss)</span>",
                sortable: true,
                dataIndex: 'toTimeIndex',
                width: 200,
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({}))
            }, {
                header: "<span style=font-weight:bold;>Trip Sheet Limit</span>",
                sortable: true,
                dataIndex: 'limitIndex',
                editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                    allowNegative: false,
                    allowDecimals: false
                }))
            }, {
                header: "<span style=font-weight:bold;>Trip Sheet Limit</span>",
                sortable: true,
                hidden: true,
                dataIndex: 'uidIndex'
            }
        ]
    });
    var timeLimitStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=getTripLimitDetails',
            method: 'POST'
        }),
        reader: timeLimitReader
    });
    var timeLimitPlant = Ext.data.Record.create([{
            name: 'SLNOIndex'
        },{
            name: 'fromTimeIndex'
        },{
            name: 'toTimeIndex'
        },{
            name: 'limitIndex'
        },{
            name: 'uidIndex'
        }]
        );
    var selModDeltimeLimit = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    var timeLimitGrid = new Ext.grid.EditorGridPanel({
        height: 300,
        width: screen.width - 800,
        autoScroll: true,
        border: false,
        store: timeLimitStore,
        id: 'timeLimitGridId',
        cm: timeLimitColModel,
        sm: selModDeltimeLimit,
        plugins: timeLimitFilters,
        clicksToEdit: 1,
        tbar: [{
            text: 'Add',
            handler: function() {
                var Plant = timeLimitGrid.getStore().recordType;
                newRowAdded++;
                if (newRowAdded < 25) {
                    var p = new timeLimitPlant({
                        SLNOIndex: newRowAdded,
                        fromTimeIndex: '',
                        toTimeIndex: '',
                        limitIndex: '',
                        uidIndex: 0
                    });
                    timeLimitGrid.stopEditing();
                    timeLimitStore.insert(0, p);
                    timeLimitGrid.startEditing(0, 0);
                }
            }
        }, {
            text: 'Remove',
            handler: function() {

                if (timeLimitGrid.getSelectionModel().getCount() == 0) {
                    Ext.example.msg("Select Record to Remove");
                    return;
                }
                if (newRowAdded > 1) {
                    newRowAdded--;
                }
                var rec = timeLimitGrid.getSelectionModel().getSelected();
                if (rec.get('uidIndex') != 0) {
                    var row = timeLimitGrid.store.find('uidIndex', rec.get('uidIndex'));
                    var removeStore = timeLimitGrid.store.getAt(row);
                    removedData += Ext.util.JSON.encode(removeStore.data) + ',';

                    if (removedData != '') {
                        removedData = removedData.substring(0, removedData.length - 1);
                    }
                }
                timeLimitStore.remove(rec);
            }
        }]
    });
    timeLimitGrid.on({
        afteredit: function(e) {
            var field = e.field;
            var slno = e.record.data['SLNOIndex'];
            var temp = editedRowsForTimeLimit.split(",");
            var isIn = 0;
            for (var i = 0; i < temp.length; i++) {
                if (temp[i] == slno) {
                    isIn = 1
                }
            }
            if (isIn == 0) {
                editedRowsForTimeLimit = editedRowsForTimeLimit + slno + ",";
            }
        }
    });
    //******************************************Add and Modify function *********************************************************************//		

    var innerPanelForRouteMasterDetails = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: '371px',
        width: 1180,
        frame: true,
        id: 'innerPanelForRouteMasterDetailsId',
        layout: 'table',
        resizable: true,
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'fieldset',
            title: 'Route Master',
            cls: 'my-fieldset',
            collapsible: false,
            autoScroll: true,
            colspan: 3,
            id: 'RouteMasterDetailsid',
            width: 460,
            height: 362,
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
                    id: 'MotherREmptyId'
                }, {
                    xtype: 'label',
                    text: 'Mother Route Name' + ' :',
                    cls: 'labelstylenew',
                    id: 'MotherRLabelId'
                }, motherRouteCombo,
                {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'motherRLimitEmptyId2'
                }, {
                    xtype: 'label',
                    text: 'Mother Route Limit' + ' :',
                    cls: 'labelstylenew',
                    id: 'motherRLimitLabelId2'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfectnew',
                    id: 'motherRLimitId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: false,
                    readOnly: true
                }, {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'motherRBalEmptyId2'
                }, {
                    xtype: 'label',
                    text: 'Mother Route Bal' + ' :',
                    cls: 'labelstylenew',
                    id: 'motherRBalLabelId2'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfectnew',
                    id: 'motherRBalId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: false,
                    readOnly: true
                }, {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'totalCountEmptyId2'
                }, {
                    xtype: 'label',
                    text: 'Total Trip Count' + ' :',
                    cls: 'labelstylenew',
                    id: 'totalCountLabelId2'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfectnew',
                    id: 'totalCountId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: false
                },{
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'orgNameEmptyId'
                }, {
                    xtype: 'label',
                    text: '<%=organizationName%>' + ' :',
                    cls: 'labelstylenew',
                    id: 'orgNameLabelId'
                },
                OrgNameCombo,
                {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'routeNameEmptyId'
                }, {
                    xtype: 'label',
                    text: 'Route Name' + ' :',
                    cls: 'labelstylenew',
                    id: 'routeNameLabelId'
                }, {
                    xtype: 'textfield',
                    cls: 'selectstylePerfectnew',
                    allowBlank: false,
                    blankText: 'Enter Route Name',
                    emptyText: 'Enter Route Name',
                    listeners: {
                        change: function(field, newValue, oldValue) {
                            field.setValue(newValue.toUpperCase().trim());
                            if (field.getValue().length > 50) {
                                Ext.example.msg("Field exceeded it's Maximum length");
                                field.setValue(newValue.substr(0, 50).toUpperCase().trim());
                                field.focus();
                            }
                        }
                    },
                    labelSeparator: '',
                    id: 'routeNameID'
                }, {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'sourceHubLocEmptyId'
                }, {
                    xtype: 'label',
                    text: 'Source Hub' + ' :',
                    cls: 'labelstylenew',
                    id: 'sourceHubLocLabelId'
                },
                SourceHubCombo,
                {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'destinationHubLocEmptyId'
                }, {
                    xtype: 'label',
                    text: 'Destination Hub' + ' :',
                    cls: 'labelstylenew',
                    id: 'destinationHubLocLabelId'
                },
                DestinationHubCombo,
                {
                    xtype: 'label',
                    text: '',
                    cls: 'mandatoryfield',
                    id: 'tripSheetEmptyId22'
                }, {
                    xtype: 'label',
                    text: 'Distance' + ' :',
                    cls: 'labelstylenew',
                    id: 'tripSheetLabelId23'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfectnew',
                    id: 'distanceId',
                    allowBlank: false,
                    allowNegative: false,
                    listeners: {
                        change: function(f, n, o) {
                            f.setValue(Math.abs(n));
                        }
                    },
                    blankText: 'Enter Distance',
                    emptyText: 'Enter Distance',
                    autoCreate: { //restricts user to 7 chars max, 
                        tag: "input",
                        maxlength: 7,
                        type: "text",
                        size: "50",
                        autocomplete: "off"
                    }
                },{
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'sourcetypEmptyId'
                }, {
                    xtype: 'label',
                    text: 'Route Type' + ' :',
                    cls: 'labelstylenew',
                    id: 'sourcetypLabelId'
                }, srcTypeCombo
            ]
        }, {
            xtype: 'fieldset',
            title: 'Time Limit',
            cls: 'my-fieldset',
            collapsible: false,
            autoScroll: true,
            colspan: 3,
            id: 'RouteMaster1',
            width: 600,
            height: 362,
            layout: 'table',
            layoutConfig: {
                columns: 3,
                tableAttrs: {
                    style: {
                        width: '88%'
                    }
                }
            },
            items: [timeLimitGrid]
        }]
    });

    var innerWinButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 90,
        width: 1180,
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
                        var JSON = '';
                        if (Ext.getCmp('custcomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectCustomer%>");
                            Ext.getCmp('custcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('motherRoutecomboId').getValue() == "") {
                            Ext.example.msg("Select Mother Route");
                            Ext.getCmp('motherRoutecomboId').focus();
                            return;
                        }
                        var pattern = /^[0-9][0-9\s]*/;
                        if (!pattern.test(Ext.getCmp('totalCountId').getValue())) {
                            Ext.example.msg("Enter total Trip Count");
                            Ext.getCmp('totalCountId').focus();
                            return;
                        }
                        if (Ext.getCmp('OrgnamecomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectOrganizationName%>");
                            Ext.getCmp('OrgnamecomboId').focus();
                            return;
                        }
                        var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                        if (Ext.getCmp('routeNameID').getValue() == "") {
                            Ext.example.msg("Enter Route Name");
                            Ext.getCmp('routeNameID').focus();
                            return;
                        }
                        if (Ext.getCmp('SourceHubcomboId').getValue() == "") {
                            Ext.example.msg("select Source Hub Location");
                            Ext.getCmp('SourceHubcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('DestinationHubcomboId').getValue() == "") {
                            Ext.example.msg("select Destination Hub Location");
                            Ext.getCmp('DestinationHubcomboId').focus();
                            return;
                        }
                        if (parseInt(Ext.getCmp('totalCountId').getValue()) > parseInt(Ext.getCmp('motherRBalId').getValue())) {
                            Ext.example.msg("Please Enter Limit equals or less than Mother route balance");
                            return;
                        }
                        var datePattern = /^([01]\d|2[0-3]):?([0-5]\d):?([0-5]\d)$/;
                        var totalTripCount = 0;
                        if (editedRowsForTimeLimit == "" && buttonValue == '<%=Add%>') {
                            Ext.example.msg("Please Enter Time Details");
                            return;
                        }
                        var tempForGrid = editedRowsForTimeLimit.split(",");
                        var len=timeLimitGrid.getStore().data.length;
                        for (var i = 0; i < len; i++) {
                            var storer = timeLimitGrid.store.getAt(i);
                            if (storer.data['fromTimeIndex'] == "") {
                                Ext.example.msg("Please Enter From Time");
                                timeLimitGrid.startEditing(row, 2);
                                return;
                            }
                            if (storer.data['toTimeIndex'] == "") {
                                Ext.example.msg("Please Enter To Time");
                                timeLimitGrid.startEditing(row, 3);
                                return;
                            }
                            if (!pattern.test(storer.data['limitIndex'])) {
                                Ext.example.msg("Please Enter Time Limit");
                                timeLimitGrid.startEditing(row, 4);
                                return;
                            }
                            var testing = datePattern.test(storer.data['fromTimeIndex']);
                            var testing1 = datePattern.test(storer.data['toTimeIndex']);
                            if (testing == false || testing1 == false) {
                                Ext.example.msg("Please Enter the value in HH:mm:ss format");
                                return;
                            }
                            if (storer.data['toTimeIndex'] < storer.data['fromTimeIndex']) {
                                Ext.example.msg("Please Enter To time greater than From time");
                                return;
                            }
                            JSON += Ext.util.JSON.encode(storer.data) + ',';
                        }
                        var gridLen=timeLimitGrid.getStore().data.length;
                        for(var k=0;k<gridLen;k++){
                        	var recordF = timeLimitGrid.getStore().getAt(k);
                        	totalTripCount = totalTripCount + Number(recordF.data['limitIndex']);
                        }
                        if(totalTripCount!=parseInt(Ext.getCmp('totalCountId').getValue())){
                           Ext.example.msg("Please Enter trip limit equal to total trip count");
                           return;
                        }
                        for(var k=0;k<gridLen-1;k++){
                        	for(var l=1;l<gridLen;l++){
                        		var record1 = timeLimitGrid.getStore().getAt(l);//1,2,
                        		var record2 = timeLimitGrid.getStore().getAt(k);//0,0
                        		fromTime1 = record1.data['fromTimeIndex'];
                        		toTime1 = record1.data['toTimeIndex'];
                        		fromTime2 = record2.data['fromTimeIndex'];
                        		toTime2 = record2.data['toTimeIndex'];
                        		if(l!=k){
	                        		if(fromTime1==fromTime2 || toTime1==toTime2){
	                        			Ext.example.msg("Same time setting is already entered.Please enter different one");
	                           			return;
	                        		}
                        		}
                        	}
                        }
                        if (JSON != '') {
                            JSON = JSON.substring(0, JSON.length - 1);
                        }
                        var id;
                        var orgNameModify;
                        var sHubModify;
                        var dHubModify;
                        if (buttonValue == '<%=Modify%>') {
                            selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uid');
                            if (selected.get('OrganizationNameIndex') != Ext.getCmp('OrgnamecomboId').getValue()) {
                                orgNameModify = Ext.getCmp('OrgnamecomboId').getValue();
                            } else {
                                orgNameModify = selected.get('OrgIdIndex');
                            }
                            if (selected.get('SourceHubIndex') != Ext.getCmp('SourceHubcomboId').getValue()) {
                                sHubModify = Ext.getCmp('SourceHubcomboId').getValue();
                            } else {
                                sHubModify = selected.get('SourceHubIdIndex');
                            }
                            if (selected.get('DestinationHubIndex') != Ext.getCmp('DestinationHubcomboId').getValue()) {
                                dHubModify = Ext.getCmp('DestinationHubcomboId').getValue();
                            } else {
                                dHubModify = selected.get('DestinationHubIdIndex');
                            }
                        }
                        RouteMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=routeMasterAddModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                id: id,
                                orgName: Ext.getCmp('OrgnamecomboId').getValue(),
                                routeName: Ext.getCmp('routeNameID').getValue(),
                                sourceHubLocId: Ext.getCmp('SourceHubcomboId').getValue(),
                                destinationHubLocId: Ext.getCmp('DestinationHubcomboId').getValue(),
                                orgNameModify: orgNameModify,
                                distance: Ext.getCmp('distanceId').getValue(),
                                dHubModify: dHubModify,
                                sHubModify: sHubModify,
                                json: JSON,
                                motherRId: Ext.getCmp('motherRoutecomboId').getValue(),
                                removedData: removedData,
                                totalTripLimit: Ext.getCmp('totalCountId').getValue(),
                                sourceType: Ext.getCmp('sourceTypecomboId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                console.log(message);
                                Ext.example.msg(message);
                                Ext.getCmp('OrgnamecomboId').reset();
                                Ext.getCmp('routeNameID').reset();
                                Ext.getCmp('SourceHubcomboId').reset();
                                Ext.getCmp('DestinationHubcomboId').reset();
                                Ext.getCmp('distanceId').reset();
                                Ext.getCmp('motherRoutecomboId').reset();
                                Ext.getCmp('motherRLimitId').reset();
                                Ext.getCmp('motherRBalId').reset();
                                Ext.getCmp('totalCountId').reset();
                                Ext.getCmp('sourceTypecomboId').reset();
                                myWin.hide();
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue()
			                        }
			                    });
                                RouteMasterOuterPanelWindow.getEl().unmask();
                                newRowAdded = 0;
                                timeLimitStore.removeAll();
                                removedData = '';
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                Ext.getCmp('OrgnamecomboId').reset();
                                Ext.getCmp('routeNameID').reset();
                                Ext.getCmp('SourceHubcomboId').reset();
                                Ext.getCmp('DestinationHubcomboId').reset();
                                Ext.getCmp('motherRoutecomboId').reset();
                                Ext.getCmp('motherRLimitId').reset();
                                Ext.getCmp('motherRBalId').reset();
                                 Ext.getCmp('totalCountId').reset();
                                 Ext.getCmp('sourceTypecomboId').reset();
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue()
			                        }
			                    });
                                myWin.hide();
                                newRowAdded = 0;
                                timeLimitStore.removeAll();
                                removedData = '';
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
                        newRowAdded = 0;
                        timeLimitStore.removeAll();
                        removedData = '';
                    }
                }
            }
        }]
    });


    var RouteMasterOuterPanelWindow = new Ext.Panel({
        width: 1200,
        height: 500,
        standardSubmit: true,
        frame: true,
        items: [innerPanelForRouteMasterDetails, innerWinButtonPanel]
    });

    myWin = new Ext.Window({
        title: 'titelForInnerPanel',
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 500,
        width: 1200,
        frame: true,
        id: 'myWin',
        items: [RouteMasterOuterPanelWindow]
    });

    var activeInnerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: false,
        id: 'cancel',

        items: [{
            xtype: 'fieldset',
            width: 480,
            title: 'Acitve/Inactive Details',
            id: 'closefieldset',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 5
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseLabel'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycloseLabelId'
            }, {
                xtype: 'label',
                text: 'Remark' + '  :',
                cls: 'labelstyle',
                id: 'remarkLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textarea',
                cls: 'selectstylePerfect',
                id: 'remark',
                emptyText: 'Enter Remarks',
                blankText: 'Enter Remarks'
            }]
        }]
    });
    var winButtonPanelForActive = new Ext.Panel({
        id: 'winbuttonid12',
        standardSubmit: true,
        collapsible: false,
        height: 8,
        cls: 'windowbuttonpanel',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Ok',
            id: 'cancelId1',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('remark').getValue() == "") {
                            Ext.example.msg("Enter Remark");
                            Ext.getCmp('remark').focus();
                            return;
                        }
                        activeWin.getEl().mask();
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('uid');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=activeInactiveRoutes',
                            method: 'POST',
                            params: {
                                id: id,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                remark: Ext.getCmp('remark').getValue(),
                                status: selected.get('statusIndex')
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                activeWin.getEl().unmask();
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue()
			                        }
			                    });
                                activeWin.hide();
                                Ext.getCmp('remark').reset();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue()
			                        }
			                    });
                                Ext.getCmp('remark').reset();
                                activeWin.hide();
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'cancelButtonId2',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: '80',
            listeners: {
                click: {
                    fn: function() {
                        activeWin.hide();
                        Ext.getCmp('remark').reset();
                    }
                }
            }
        }]
    });
    var ActivePanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        width: 490,
        height: 180,
        frame: true,
        id: 'cancelPanel1',
        items: [activeInnerPanel]
    });
    var outerPanelWindowForActive = new Ext.Panel({
        standardSubmit: true,
        id: 'cancelwinpanelId1',
        frame: true,
        height: 250,
        width: 520,
        items: [ActivePanel, winButtonPanelForActive]
    });

    activeWin = new Ext.Window({
        closable: false,
        modal: true,
        resizable: false,
        autoScroll: false,
        height: 300,
        width: 530,
        id: 'closemyWin',
        items: [outerPanelWindowForActive]
    });

    function addRecord() {
        Ext.getCmp('OrgnamecomboId').setReadOnly(false);
        Ext.getCmp('routeNameID').setReadOnly(false);
        Ext.getCmp('SourceHubcomboId').setReadOnly(false);
        Ext.getCmp('DestinationHubcomboId').setReadOnly(false);
        Ext.getCmp('motherRoutecomboId').setReadOnly(false);
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }

        buttonValue = '<%=Add%>';
        titelForInnerPanel = '<%=AddDetails%>';
        myWin.setPosition(50, 20);
        myWin.show();
        myWin.setTitle(titelForInnerPanel);

        Ext.getCmp('motherRoutecomboId').reset();
        Ext.getCmp('motherRLimitId').reset();
        Ext.getCmp('motherRBalId').reset();
        Ext.getCmp('OrgnamecomboId').reset();
        Ext.getCmp('routeNameID').reset();
        Ext.getCmp('SourceHubcomboId').reset();
        Ext.getCmp('DestinationHubcomboId').reset();
        Ext.getCmp('totalCountId').reset();
        Ext.getCmp('sourceTypecomboId').reset();
        motherRouteComboStore.load({
            params: {
                custId: Ext.getCmp('custcomboId').getValue(),
                buttonValue:buttonValue
            }
        });
    }

    function modifyData() {
        Ext.getCmp('OrgnamecomboId').setReadOnly(true);
        Ext.getCmp('routeNameID').setReadOnly(true);

        selected = grid.getSelectionModel().getSelected();
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
        if ((selected.get('routeCount')) > 0) {
            Ext.getCmp('SourceHubcomboId').setReadOnly(true);
            Ext.getCmp('DestinationHubcomboId').setReadOnly(true);
        } else {
            Ext.getCmp('SourceHubcomboId').setReadOnly(false);
            Ext.getCmp('DestinationHubcomboId').setReadOnly(false);
        }
        buttonValue = '<%=Modify%>';
        titelForInnerPanel = '<%=ModifyDetails%>';
        myWin.setPosition(50, 20);
        myWin.setTitle(titelForInnerPanel);
        myWin.show();
        var mbal=0;
        var mlimit=0;
        motherRouteComboStore.load({
            params: {
                custId: Ext.getCmp('custcomboId').getValue(),
                buttonValue:buttonValue,
                routeId:selected.get('uid')
            },callback: function() {
                var row = motherRouteComboStore.findExact('id', parseInt(selected.get('motherRId')));
        		var rec = motherRouteComboStore.getAt(row);
        		mbal=rec.data['motherRBal'];
        		mlimit=rec.data['motherRLimit'];
        		Ext.getCmp('motherRLimitId').setValue(mlimit);
        		Ext.getCmp('motherRBalId').setValue(mbal);
            }
        });
        Ext.getCmp('motherRoutecomboId').setValue(selected.get('motherRNameIndex'));
        Ext.getCmp('totalCountId').setValue(selected.get('totalTripCount'));
        Ext.getCmp('motherRoutecomboId').setReadOnly(true);
        Ext.getCmp('OrgnamecomboId').setValue(selected.get('OrganizationIndex'));
        Ext.getCmp('routeNameID').setValue(selected.get('RouteNameIndex'));
        Ext.getCmp('SourceHubcomboId').setValue(selected.get('SourceHubIdIndex'));
        Ext.getCmp('DestinationHubcomboId').setValue(selected.get('DestinationHubIndex'));
        Ext.getCmp('distanceId').setValue(selected.get('distanceIndex'));
        Ext.getCmp('sourceTypecomboId').setValue(selected.get('srcIndex'));
        
        timeLimitStore.load({
            params: {
                id: selected.get('uid')
            }
        });
    }

    function closetripsummary() {

        selected = grid.getSelectionModel().getSelected();
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=NoRowsSelected%>");
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (selected.get('motherRStatus') == 'Inactive') {
            Ext.example.msg("Can't change status");
            return;
        }
        activeWin.show();
    }
    //***************************************************************************************//
    var reader = new Ext.data.JsonReader({
        idProperty: 'MiningRouteMasterDetails',
        root: 'MiningRouteMasterRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'uid'
        }, {
            name: 'motherRNameIndex'
        }, {
            name: 'OrgIdIndex'
        }, {
            name: 'OrganizationIndex'
        }, {
            name: 'RouteNameIndex'
        }, {
            name: 'SourceHubIdIndex'
        }, {
            name: 'SourceHubIndex'
        }, {
            name: 'DestinationHubIndex'
        }, {
            name: 'DestinationHubIdIndex'
        }, {
            name: 'totalTripCount'
        }, {
            name: 'distanceIndex'
        }, {
            name: 'statusIndex'
        }, {
        	name: 'srcIndex'
        }, {
            name: 'routeCount'
        }, {
            name: 'motherRStatus'
        }, {
            name: 'motherRId'
        },{
            name: 'updatedBy'
        },{
            name: 'updatedDateIndex'
        },{
            name: 'activeBy'
        },{
            name: 'activeDateIndex'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=getRouteMasterDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'RouteDetails',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'OrganizationIndex'
        }, {
            type: 'string',
            dataIndex: 'motherRNameIndex'
        }, {
            type: 'string',
            dataIndex: 'RouteNameIndex'
        }, {
            type: 'string',
            dataIndex: 'SourceHubIndex'
        }, {
            type: 'string',
            dataIndex: 'DestinationHubIndex'
        }, {
            type: 'int',
            dataIndex: 'totalTripCount'
        }, {
            type: 'string',
            dataIndex: 'distanceIndex'
        }, {
            type: 'string',
            dataIndex: 'statusIndex'
        },{
        	type: 'string',
        	dataIndex: 'srcIndex'
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
                width: 50,
                header: "<span style=font-weight:bold;><%=SLNO%></span>"
            }, {
                header: "<span style=font-weight:bold;>Mother Route Name</span>",
                dataIndex: 'motherRNameIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Organization Name</span>",
                dataIndex: 'OrganizationIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Route Name</span>",
                dataIndex: 'RouteNameIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Source Hub</span>",
                dataIndex: 'SourceHubIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Destination Hub</span>",
                dataIndex: 'DestinationHubIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Total TripSheet Limit</span>",
                dataIndex: 'totalTripCount',
                align: 'right',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Distance</span>",
                dataIndex: 'distanceIndex',
                align: 'right',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Status</span>",
                dataIndex: 'statusIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>Route Type</span>",
                dataIndex: 'srcIndex',
                hidden: false,
                width: 50
            }, {
                header: "<span style=font-weight:bold;>ID</span>",
                dataIndex: 'uid',
                hidden: true,
                width: 50
            }, {
                header: "<span style=font-weight:bold;>Updated By</span>",
                dataIndex: 'updatedBy',
                hidden: true,
                width: 50
            }, {
                header: "<span style=font-weight:bold;>Updated Datetime</span>",
                dataIndex: 'updatedDateIndex',
                hidden: true,
                width: 50
            }, {
                header: "<span style=font-weight:bold;>Active By</span>",
                dataIndex: 'activeBy',
                hidden: true,
                width: 50
            }, {
                header: "<span style=font-weight:bold;>Activated Datetime</span>",
                dataIndex: 'activeDateIndex',
                hidden: true,
                width: 50
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };

    grid = getGrid("Route Master", '<%=NoRecordsFound%>', store, screen.width - 40, 450, 20, filters, '<%=ClearFilterData%>', false, '', 8, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete', true, 'Active/Inactive');

    Ext.onReady(function() {
        ctsb = tsb;
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
            items: [clientPanel, grid]
        });
    });
</script>
</body>

</html>
<%}%>
    <%}%>		
		