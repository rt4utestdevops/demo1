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
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		
		%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title>User Authority Details</title>

<style>
   .x-panel-tl {
       border-bottom: 0px solid !important;
   }
 #content div.x-grid3-col-numberer {
    text-align: center;
}
   
</style>

		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 20px !important;
			}
			.x-window-tl *.x-window-header {
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
		</style>
        <script>
        
var outerPanel;
var jspName = "UserAuthority";
var exportDataType = "int,string,string,string,string,string,string,string,string";
var grid;
var ledger;
var cash;

/******************************** User Combo **************************************/
var UserAuthorityStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/UserAuthorityAction.do?param=getUserDataDetails',
    id: 'userStoreId',
    root: 'sourceUserStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['ID', 'DATA']
});

var LedgerAuthorityCombo = new Ext.form.ComboBox({
    store: UserAuthorityStore,
    id: 'ledgercomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '',
    blankText: '',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ID',
    displayField: 'DATA',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                ID = Ext.getCmp('ledgercomboId').getValue();
                DATA = Ext.getCmp('ledgercomboId').getRawValue();
            }
        }
    }
});


var CashAuthorityCombo = new Ext.form.ComboBox({
    store: UserAuthorityStore,
    id: 'cashcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '',
    blankText: '',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ID',
    displayField: 'DATA',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                ID = Ext.getCmp('cashcomboId').getValue();
                DATA = Ext.getCmp('cashcomboId').getRawValue();
            }
        }
    }
});

var ReconcileAuthorityCombo = new Ext.form.ComboBox({
    store: UserAuthorityStore,
    id: 'reconcilecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '',
    blankText: '',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ID',
    displayField: 'DATA',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                ID = Ext.getCmp('reconcilecomboId').getValue();
                DATA = Ext.getCmp('reconcilecomboId').getRawValue();
            }
        }
    }
});

var writeOffAuthorityCombo = new Ext.form.ComboBox({
    store: UserAuthorityStore,
    id: 'writeOffAuthorityComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '',
    blankText: '',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ID',
    displayField: 'DATA',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                ID = Ext.getCmp('writeOffAuthorityComboId').getValue();
                DATA = Ext.getCmp('writeOffAuthorityComboId').getRawValue();
            }
        }
    }
});

var ReconcileHeadAuthorityCombo = new Ext.form.ComboBox({
    store: UserAuthorityStore,
    id: 'reconcileHeadcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '',
    blankText: '',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ID',
    displayField: 'DATA',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                ID = Ext.getCmp('reconcileHeadcomboId').getValue();
                DATA = Ext.getCmp('reconcileHeadcomboId').getRawValue();
            }
        }
    }
});


//****************************************** Modify function *********************************************************************//
var innerPanelForUserAuthorityDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: false,
    height: 200,
    width: 470,
    frame: true,
    id: 'innerPanelForuserDetailsId',
    layout: 'table',
    resizable: true,
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'UserAuthorituy',
        cls: 'my-fieldset',
        collapsible: false,
        autoScroll: true,
        colspan: 3,
        id: 'authoritydetailsid',
        width: 455,
        height: 205,
        layout: 'table',
        layoutConfig: {
            columns: 2,
            tableAttrs: {
                style: {
                    width: '88%'
                }
            }
        },
        items: [{
            xtype: 'label',
            text: 'User Name' + ' :',
            cls: 'labelstyle',
            id: 'usernameId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            disabled: true,
            blankText: 'Enter User Name',
            emptyText: 'Enter User Name',
            labelSeparator: '',
            id: 'userNameID'
        }, {
            xtype: 'label',
            text: 'Ledger Entry Authority' + ' :',
            cls: 'labelstyle',
            id: 'ledgerentryid'
        }, LedgerAuthorityCombo, {
            xtype: 'label',
            text: 'Physical Cash Entry Authority' + ' :',
            cls: 'labelstyle',
            id: 'cashviewid'
        }, CashAuthorityCombo, {
            xtype: 'label',
            text: 'Reconcile Authority' + ' :',
            cls: 'labelstyle',
            id: 'reconcileid'
        }, ReconcileAuthorityCombo, {
            xtype: 'label',
            text: 'Close / WriteOff Authority' + ' :',
            cls: 'labelstyle',
            id: 'writeOffId'
        }, writeOffAuthorityCombo, {
            xtype: 'label',
            text: 'Reconcile Head Authority' + ' :',
            cls: 'labelstyle',
            id: 'reconcilehEADid'
        }, ReconcileHeadAuthorityCombo,]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 90,
    width: 480,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   var selected = grid.getSelectionModel().getSelected();
                   username = selected.get('usernameindex');
                   UserId = selected.get('useridindex');
                   UserAuthorityOuterPanelWindow.getEl().mask();
                   Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/UserAuthorityAction.do?param=userModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            username: username,
                            UserId: UserId,
                            ledgerauthority: Ext.getCmp('ledgercomboId').getValue(),
                            cashview: Ext.getCmp('cashcomboId').getValue(),
                            reconcile: Ext.getCmp('reconcilecomboId').getValue(),
                            writeOff: Ext.getCmp('writeOffAuthorityComboId').getValue(),
                            reconcileHead: Ext.getCmp('reconcileHeadcomboId').getValue()
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('ledgercomboId').reset();
                            Ext.getCmp('cashcomboId').reset();
                            Ext.getCmp('reconcilecomboId').reset();
                            Ext.getCmp('writeOffAuthorityComboId').reset();
                            Ext.getCmp('reconcileHeadcomboId').reset();
                            myWin.hide();
                            store.reload();
                            UserAuthorityOuterPanelWindow.getEl().unmask();
                        },
                        failure: function() {
                         	UserAuthorityOuterPanelWindow.getEl().unmask();
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


var UserAuthorityOuterPanelWindow = new Ext.Panel({
    width: 500,
    height: 300,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForUserAuthorityDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: 'titelForInnerPanel',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 260,
    width: 500,
    frame: true,
    id: 'myWin',
    items: [UserAuthorityOuterPanelWindow]
});

function modifyData() {

    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("NoRowsSelected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("SelectSingleRow");
        return;
    }
    buttonValue = 'Modify';
    titelForInnerPanel = 'Modify';
    myWin.setPosition(450, 50);
    myWin.setHeight(320);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('userNameID').disable();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('userNameID').setValue(selected.get('usernameindex'));
    Ext.getCmp('ledgercomboId').setValue(selected.get('ledgerindex'));
    Ext.getCmp('cashcomboId').setValue(selected.get('cashviewindex'));
    Ext.getCmp('reconcilecomboId').setValue(selected.get('reconcileindex'));
    Ext.getCmp('writeOffAuthorityComboId').setValue(selected.get('writeOffAuthorityIndex'));
    Ext.getCmp('reconcileHeadcomboId').setValue(selected.get('reconcileHeadindex'));
    UserAuthorityStore.load();
}


var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'int',
        dataIndex: 'useridindex'
    }, {
        type: 'string',
        dataIndex: 'usernameindex'
    }, {
        type: 'string',
        dataIndex: 'ledgerindex'
    }, {
        type: 'string',
        dataIndex: 'cashviewindex'
    }, {
        type: 'string',
        dataIndex: 'reconcileindex'

    }, {
        type: 'string',
        dataIndex: 'reconcileHeadindex'

    },{
        type: 'string',
        dataIndex: 'creadtedbyindex'
    }, {
        type: 'date',
        dataIndex: 'createddateindex'
    }, {
        type: 'string',
        dataIndex: 'updatedbyindex'
    }, {
        type: 'date',
        dataIndex: 'updateddateindex'
    },{
    	type: 'string',
    	dataIndex: 'writeOffAuthorityIndex'
    }]
});
var reader = new Ext.data.JsonReader({
    idProperty: 'crossid',
    root: 'userauthorityroot',
    totalProperty: 'total',
    fields: [{
        name: 'useridindex'
    }, {
        name: 'usernameindex'
    }, {
        name: 'ledgerindex'
    }, {
        name: 'cashviewindex'
    }, {
        name: 'reconcileindex'
    }, {
        name: 'reconcileHeadindex'
    },{
        name: 'creadtedbyindex'
    }, {
        name: 'createddateindex'
    }, {
        name: 'updatedbyindex'
    }, {
        name: 'updateddateindex'
    },{
    	name: 'writeOffAuthorityIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/UserAuthorityAction.do?param=getUserAuthorityDetails',
        method: 'POST'
    }),

    storeId: 'userauthorityid',
    reader: reader
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>Sl No</span>",
            width: 60,
            align: 'center'
        }), {
            dataIndex: 'useridindex',
            hidden: true,
            header: "<span style=font-weight:bold;>User Id</span>",
            width: 200,

            filter: {
                type: 'int'
            }
        }, {
            dataIndex: 'usernameindex',
            hidden: false,
            header: "<span style=font-weight:bold;>User Name</span>",
            width: 300,

            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'ledgerindex',
            hidden: false,
            header: "<span style=font-weight:bold;>Ledger Entry Authority</span>",
            width: 370,
            filter: {
                type: 'string'
            }
        }, {

            dataIndex: 'cashviewindex',
            hidden: false,
            header: "<span style=font-weight:bold;>Physical Cash Entry Authority</span>",
            width: 450,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'reconcileindex',
            hidden: false,
            header: "<span style=font-weight:bold;>Reconcile Authority</span>",
            width: 350,
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'writeOffAuthorityIndex',
            hidden: false,
            header: "<span style=font-weight:bold;>Close / WriteOff Authority</span>",
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'reconcileHeadindex',
            hidden: false,
            header: "<span style=font-weight:bold;>Reconcile Head Authority</span>",
            width: 350,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Created By</span>",
            hidden: false,
            width: 300,
            dataIndex: 'creadtedbyindex',

            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Created Date</span>",
            hidden: false,
            width: 300,
            dataIndex: 'createddateindex',
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Updated By</span>",
            hidden: false,
            width: 300,
            dataIndex: 'updatedbyindex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Updated Date</span>",
            hidden: false,
            width: 300,
            dataIndex: 'updateddateindex',
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
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
grid = getGrid('UserAuthority Deatails', 'NoRecordsFound', store, screen.width - 40, 510, 31, filters, 'ClearFilterData', false, '', 17, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', true, 'Modify');

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
        height: 540,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid]
    });
    sb = Ext.getCmp('form-statusbar');
    store.load();
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>