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
tobeConverted.add("Route_Master");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Route_Id");
tobeConverted.add("Route_Name");
tobeConverted.add("Route_Type");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Route_Master_Information");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("Enter_Route_ID");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Enter_Route_Type");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
//tobeConverted.add("This_Route_is_Already_Exists_Please_Select_Different_One");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String RouteMaster=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String RouteMasterDetails=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String RouteID=convertedWords.get(10);
String RouteName=convertedWords.get(11);
String RouteType=convertedWords.get(12);
String Excel=convertedWords.get(13);
String Delete=convertedWords.get(14);
String AddRouteMaster=convertedWords.get(15);
String NoRowsSelected=convertedWords.get(16);
String SelectSingleRow=convertedWords.get(17);
String ModifyDetails=convertedWords.get(18);
String AssociateRoute=convertedWords.get(19);
String SelectRouteID=convertedWords.get(20);
String SelectRouteName=convertedWords.get(21);
String SelectRouteType=convertedWords.get(22);
String Save=convertedWords.get(23);
String Cancel=convertedWords.get(24);
//String RouteisAlreadyExistsPleaseSelectDifferentOne=convertedWords.get(25);

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Route Master</title>		
   
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
   <style>
	.x-panel-header
		{
				height: 7% !important;
		}
		
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
   </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "routeVehicleAssociationDetails";
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

var innerPanelForRouteMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 180,
    width: 400,
    frame: false,
    id: 'innerPanelForRouteMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AssociateRoute%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'AssociateRouteId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'routeEmptyId1'
        },{
            xtype: 'label',
            text: '<%=RouteID%>' + ' :',
            cls: 'labelstyle',
            id: 'routeLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'RouteId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=SelectRouteID%>',
            blankText: '<%=SelectRouteID%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=RouteName%>' + ' :',
            cls: 'labelstyle',
            id: 'nameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'NameId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=SelectRouteName%>',
            blankText: '<%=SelectRouteName%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        }, {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusEmptyId1'
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
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }
                    if (Ext.getCmp('RouteId').getValue() == "") {
                    Ext.example.msg("<%=SelectRouteID%>");
                        return;
                    }
                    if (Ext.getCmp('NameId').getValue() == "") {
                    Ext.example.msg("<%=SelectRouteName%>");
                        return;
                    }
                   
                        if (Ext.getCmp('statuscomboId').getValue() == "") {
                    	Ext.example.msg("Select Status");
                    	return;
                    }       
                    var rec;
                    if (innerPanelForRouteMasterDetails.getForm().isValid()) {
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueIdDataIndex');
                           
                        }
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/RouteMasterActions.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                RouteId: Ext.getCmp('RouteId').getValue(),
                                RouteName: Ext.getCmp('NameId').getValue(),
                                Status: Ext.getCmp('statuscomboId').getValue(),
                                id: id
                               
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
                                Ext.getCmp('RouteId').reset();
                                Ext.getCmp('NameId').reset();
                                Ext.getCmp('statuscomboId').reset();
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
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

var routeMasterOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 240,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRouteMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 300,
    width: 430,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddRouteMaster%>';
    myWin.setPosition(450, 170);
    myWin.show();
    //  myWin.setHeight(350);
    Ext.getCmp('RouteId').enable();
    Ext.getCmp('RouteId').reset();
    Ext.getCmp('NameId').reset();
    Ext.getCmp('statuscomboId').reset();
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
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    Ext.getCmp('NameId').show();
    
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('RouteId').setValue(selected.get('routeIdDataIndex'));
    Ext.getCmp('NameId').setValue(selected.get('routeNameIndex'));
    Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));
}
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'routeMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'routeIdDataIndex'
    }, {
        name: 'routeNameIndex'
    }, {
        name: 'statusIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RouteMasterActions.do?param=getRouteMasterDetails',
        method: 'POST'
    }),
    storeId: 'routeMasterId',
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
        dataIndex: 'routeIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'routeNameIndex'
    },  {
        type: 'string',
        dataIndex: 'statusIndex'
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
            header: "<span style=font-weight:bold;><%=ID%></span>",
            dataIndex: 'uniqueIdDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RouteID%></span>",
            dataIndex: 'routeIdDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RouteName%></span>",
            dataIndex: 'routeNameIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusIndex',
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

grid = getGrid('<%=RouteMasterDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 8, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=RouteMaster%>',
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
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->