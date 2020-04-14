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
tobeConverted.add("Add");
tobeConverted.add("Add_Details");
tobeConverted.add("Modify");
tobeConverted.add("Modify_Details");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("Status");
tobeConverted.add("Select_Status");
tobeConverted.add("Vessel_Name");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);


String Add=convertedWords.get(0);
String AddDetails=convertedWords.get(1);
String Modify=convertedWords.get(2);
String ModifyDetails=convertedWords.get(3);
String CustomerName=convertedWords.get(4);
String SelectCustomerName=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String NoRowsSelected=convertedWords.get(9);
String SelectSingleRow=convertedWords.get(10);
String Save=convertedWords.get(11);
String Cancel=convertedWords.get(12);

String status=convertedWords.get(13);
String selectStatus=convertedWords.get(14);
String vesselName=convertedWords.get(15);

String enterVesselName="Enter Vessel Name";
String vesselInfo="Vessel Master Details";

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Vessel Master</title>		
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
   <script><!--
   
var outerPanel;
var ctsb;
var jspName = "Vessel Master Details";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var id;

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
 var statusStore = new Ext.data.SimpleStore({
     id: 'statusStoreId',
     fields: ['name', 'value'],
     autoLoad: true,
     data: [
         ['Active', 'Active'],
         ['Inactive', 'Inactive']
     ]
});

var statusCombo = new Ext.form.ComboBox({
    store: statusStore,
    id: 'statusComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=selectStatus%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    //value: permitrequesttypeStore.getAt(0).data['value'],
    valueField: 'value',
    displayField: 'name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            }
        }
    }
});

var innerPanelForVesselMaster = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 450,
    frame: false,
    id: 'innerPanelForVesselMasterId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title:'<%=vesselInfo%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 4,
        id: 'MineralInfoId',
        width: 445,
        height:135,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'manVesselNameId'
        },{
            xtype: 'label',
            text: '<%=vesselName%>' + ' :',
            cls: 'labelstylenew',
            id: 'vesselNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'vesselNameId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=enterVesselName%>',
            blankText: '<%=enterVesselName%>',
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
					},
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'manStatusId'
        },{
            xtype: 'label',
            text: '<%=status%>' + ' :',
            cls: 'labelstylenew',
            id: 'statusId'
        }, statusCombo
        , {},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'manbuyerNameId'
        },{
            xtype: 'label',
            text: 'Buyer Name' + ' :',
            cls: 'labelstylenew',
            id: 'vesselBuyerLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'buyerNameId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Buyer Name',
            blankText: 'Enter Buyer Name',
            selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 100){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					},
        }, {}]
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
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   
                    if (Ext.getCmp('vesselNameId').getValue() == "") {
                    	Ext.example.msg("<%=enterVesselName%>");
                    	Ext.getCmp('vesselNameId').focus();
                        return;
                    }
                     if (Ext.getCmp('statusComboId').getValue() == "") {
                    	Ext.example.msg("<%=selectStatus%>");
                    	Ext.getCmp('statusComboId').focus();
                        return;
                    }
                    if (Ext.getCmp('buyerNameId').getValue() == "") {
                    	Ext.example.msg("Enter Buyer Name");
                    	Ext.getCmp('buyerNameId').focus();
                        return;
                    }
                    var rec;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uidInd');
                        }
                         vesselMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VesselMasterAction.do?param=addOrModifyVesselMasterDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: Ext.getCmp('custcomboId').getValue(),
                                vesselName: Ext.getCmp('vesselNameId').getValue(),
                                status: Ext.getCmp('statusComboId').getValue(),
                                id: id,
                                buyerName: Ext.getCmp('buyerNameId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
							    Ext.getCmp('vesselNameId').reset();
							    Ext.getCmp('statusComboId').reset();
							    Ext.getCmp('buyerNameId').reset();
                                myWin.hide();
                                vesselMasterOuterPanelWindow.getEl().unmask();
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

var vesselMasterOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 210,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForVesselMaster, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 260,
    width: 475,
    id: 'myWin',
    items: [vesselMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(450, 100);
    myWin.show();
    //  myWin.setHeight(350);

   Ext.getCmp('vesselNameId').reset();
    Ext.getCmp('statusComboId').reset();
    Ext.getCmp('buyerNameId').reset();
    myWin.setTitle(titelForInnerPanel);
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
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 100);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    var selected = grid.getSelectionModel().getSelected();
   Ext.getCmp('vesselNameId').setValue(selected.get('vesselNameInd'));
    Ext.getCmp('statusComboId').setValue(selected.get('statusInd'));
    Ext.getCmp('buyerNameId').setValue(selected.get('buyerNameInd'));
    }
var reader = new Ext.data.JsonReader({
    idProperty: 'vesselMasterId',
    root: 'VesselMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoInd'
    }, {
        name: 'vesselNameInd'
    }, {
        name: 'statusInd'
    }, {
        name: 'buyerNameInd'
    }, {
        name: 'uidInd'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VesselMasterAction.do?param=getVesselMasterDetails',
        method: 'POST'
    }),
    storeId: 'vesselMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoInd'
    }, {
        type: 'int',
        dataIndex: 'uidInd'
    }, {
        type: 'string',
        dataIndex: 'vesselNameInd'
    }, {
        type: 'string',
        dataIndex: 'statusInd'
    },{
        type: 'string',
        dataIndex: 'buyerNameInd'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoInd',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>"
        },{
            header: "<span style=font-weight:bold;><%=vesselName%></span>",
            dataIndex: 'vesselNameInd',
            width: 80
        }, {
            header: "<span style=font-weight:bold;><%=status%></span>",
            dataIndex: 'statusInd',
            width: 100
        },{
            header: "<span style=font-weight:bold;>Buyer Name</span>",
            dataIndex: 'buyerNameInd',
            width: 100
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

grid = getGrid('<%=vesselInfo%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 8, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>');

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
--></script>
</body>
</html>
<%}%>