<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String SelectCustomer="Select Customer"; 
	String CustomerName="Customer Name";
	String SelectLTSP="Select Ltsp Name";
	String LTSPName="Ltsp Name";
	String GroupName="Group Name";
	String selectGroupName="select Group Name";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>VehicleGroupingForBilling</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
  </head>
  <body>
 <style>
.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
}
</style>
<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
<!-- for grid -->
<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
<pack:style src="../../Main/resources/css/ext-all.css" />
<pack:style src="../../Main/resources/css/chooser.css" />
<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/component.css" />
<pack:style src="../../Main/resources/css/dashboard.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
<pack:style src="../../Main/resources/css/commonnew.css" />
<pack:style src="../../Main/iconCls/icons.css" />
<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
<!-- for grid -->
<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<pack:style src="../../Main/resources/css/examples1.css" />
<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>	
<pack:script src="../../Main/Js/MonthPickerPlugin.js"></pack:script>
<script>
document.documentElement.setAttribute("dir", "ltr");
function getwindow(jsp){
window.location=jsp;
}
</script>
  <table id="tableID" style="width:100%;height:99%;background-color:#FFFFFF;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="99%">
  <td height="99%" id="content">
  </td>
  </tr>
</table>
<script>
    var outerPanel;
    var LTSPComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=getLtsp',
        id: 'ltspStoreId',
        root: 'lpstRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['systemId', 'systemName'],
        listeners: {}
    });
    var LTSP = new Ext.form.ComboBox({
        store: LTSPComboStore,
        id: 'ltspComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectLTSP%>',
        blankText: '<%=SelectLTSP%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'systemId',
        displayField: 'systemName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('custcomboId').reset();
                    clientcombostore.load({
                        params: {
                            systemId: Ext.getCmp('ltspComboId').getValue()
                        }
                    });
                }
            }
        }
    });

    var clientcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['CustId', 'CustName']
    });

    var Client = new Ext.form.ComboBox({
        store: clientcombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>',
        blankText: '<%=SelectCustomer%>',
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
                    systemId = Ext.getCmp('ltspComboId').getValue();
                    Ext.getCmp('groupComboId').reset();
                    firstGridStore.removeAll();
                    secondGridStore.removeAll();
                    groupCombostore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            systemId: systemId
                        }
                    });
                }
            }
        }
    });
    var groupCombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=getGroup',
        id: 'groupStoreId',
        root: 'groupRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['groupId', 'groupName']
    });

    var Group = new Ext.form.ComboBox({
        store: groupCombostore,
        id: 'groupComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=selectGroupName%>',
        blankText: '<%=selectGroupName%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'groupId',
        displayField: 'groupName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    systemId = Ext.getCmp('ltspComboId').getValue();
                    firstGridStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            systemId: systemId,
                            groupId: Ext.getCmp('groupComboId').getValue()
                        }
                    });
                    secondGridStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            systemId: systemId,
                            groupId: Ext.getCmp('groupComboId').getValue()
                        }
                    });
                }
            }
        }
    });
    var comboPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: false,
        width: screen.width - 12,
        height: 60,
        layoutConfig: {
            columns: 6
        },
        items: [{
                xtype: 'label',
                text: '<%=LTSPName%>' + ' :',
                cls: 'labelstyle'
            },
            LTSP, {
                width: 15
            }, {
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle'
            },
            Client, {
                width: 15
            }, {
                xtype: 'label',
                text: '<%=GroupName%>' + ' :',
                cls: 'labelstyle'
            },
            Group,
            {
                width: 15
            }, {
                xtype: 'button',
                text: "<span style=font-weight:bold;>Add Group</span>",
                id: 'addId',
                iconCls: 'addbutton',
                cls: 'buttonstyle',
                width: 80,
                listeners: {
                    click: {
                        fn: function() {
                            addGroup();
                        }
                    }
                }
            }, {
                width: 15
            }, {
                width: 15
            }
        ]
    });
    var innerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        height: 100,
        width: 480,
        frame: true,
        id: 'innerPanelId',
        layout: 'table',
        resizable: true,
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'fieldset',
            title: 'Group Details',
            cls: 'my-fieldset',
            collapsible: false,
            autoScroll: true,
            colspan: 3,
            id: 'GId',
            width: 465,
            height: 93,
            layout: 'table',
            layoutConfig: {
                columns: 4,
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
                id: 'manGroupId'
            }, {
                xtype: 'label',
                text: 'Group Name' + ' :',
                cls: 'labelstyle',
                id: 'groupLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: 'Enter Group Name',
                blankText: 'Enter Group Name',
                id: 'groupNameId'
            }, {
                width: 20
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'addressManId'
            }, {
                xtype: 'label',
                text: 'Address' + ' :',
                cls: 'labelstyle',
                id: 'adressLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: 'Enter Group Address',
                blankText: 'Enter Group Address',
                id: 'addressId'
            }]
        }]
    });

    var innerWinButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 80,
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
                        if (Ext.getCmp('groupNameId').getValue() == "") {
                            Ext.example.msg("Enter Group Name");
                            Ext.getCmp('groupNameId').focus();
                            return;
                        }
                        if (Ext.getCmp('addressId').getValue() == "") {
                            Ext.example.msg("Enter Group Name");
                            Ext.getCmp('addressId').focus();
                            return;
                        }

                        outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=saveGroupDetails',
                            method: 'POST',
                            params: {
                                custId: Ext.getCmp('custcomboId').getValue(),
                                systemId: Ext.getCmp('ltspComboId').getValue(),
                                groupName: Ext.getCmp('groupNameId').getValue(),
                                groupAddress: Ext.getCmp('addressId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                console.log(message);
                                Ext.example.msg(message);
                                myWin.hide();
                                Ext.getCmp('addressId').reset();
                                Ext.getCmp('groupNameId').reset();
                                outerPanelWindow.getEl().unmask();
                                groupCombostore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        systemId: Ext.getCmp('ltspComboId').getValue()
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                Ext.getCmp('addressId').reset();
                                Ext.getCmp('groupNameId').reset();
                                myWin.hide();
                                outerPanelWindow.getEl().unmask();
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
                        Ext.getCmp('addressId').reset();
                        Ext.getCmp('groupNameId').reset();
                    }
                }
            }
        }]
    });

    var outerPanelWindow = new Ext.Panel({
        width: 510,
        height: 150,
        standardSubmit: true,
        frame: true,
        items: [innerPanel, innerWinButtonPanel]
    });

    myWin = new Ext.Window({
        title: 'titelForInnerPanel',
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 200,
        width: 510,
        frame: true,
        id: 'myWin',
        items: [outerPanelWindow]
    });

    function addGroup() {
        if (Ext.getCmp('ltspComboId').getValue() == "") {
            Ext.example.msg("<%=SelectLTSP%>");
            return;
        }
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            return;
        }
        myWin.setTitle('Add Group Details');
        myWin.show();
    }

    //***************************************************************************FIRST GRID***********************************************************************************//
    var sm1 = new Ext.grid.CheckboxSelectionModel({
        checkOnly: true
    });

    var cols1 = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 40
        }), sm1, {
            header: '<b>Registration No</b>',
            width: 195,
            sortable: true,
            dataIndex: 'regNoDataIndex'
        }, {
            header: '<b>Group Name</b>',
            width: 195,
            sortable: true,
            dataIndex: 'groupNameDataIndex'
        }, {
            header: '<b>Group Id</b>',
            width: 190,
            sortable: true,
            hidden: true,
            dataIndex: 'groupIdDataIndex'
        }
    ]);

    var reader1 = new Ext.data.JsonReader({
        root: 'firstGridRoot',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'regNoDataIndex',
            type: 'string'
        }, {
            name: 'groupNameDataIndex',
            type: 'string'
        }, {
            name: 'groupIdDataIndex',
            type: 'int'
        }]
    });

    var filters1 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            dataIndex: 'regNoDataIndex',
            type: 'string'
        }, {
            dataIndex: 'groupNameDataIndex',
            type: 'string'
        }, {
            dataIndex: 'groupIdDataIndex',
            type: 'int'
        }]
    });

    var firstGridStore = new Ext.data.Store({
        url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=getDataForNonAssociation',
        bufferSize: 367,
        reader: reader1,
        autoLoad: false,
        remoteSort: false
    });

    //***************************************************************************88SECOND GRID*******************************************************************************************//
    var sm2 = new Ext.grid.CheckboxSelectionModel({
        checkOnly: true
    });

    var cols2 = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 40
        }), sm2, {
            header: '<b>Registration No</b>',
            width: 195,
            sortable: true,
            dataIndex: 'regNoDataIndex2'
        }, {
            header: '<b>Group Name</b>',
            width: 195,
            sortable: true,
            dataIndex: 'groupNameDataIndex2'
        }, {
            header: '<b>Group Id</b>',
            width: 190,
            sortable: true,
            hidden: true,
            dataIndex: 'groupIdDataIndex2'
        }
    ]);

    var reader2 = new Ext.data.JsonReader({
        root: 'secondGridRoot',
        fields: [{
            name: 'slnoIndex2'
        }, {
            name: 'regNoDataIndex2',
            type: 'string'
        }, {
            name: 'groupNameDataIndex2',
            type: 'String'
        }, {
            name: 'groupIdDataIndex2',
            type: 'int'
        }]
    });

    var filters2 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex2'
        }, {
            dataIndex: 'regNoDataIndex2',
            type: 'string'
        }, {
            dataIndex: 'groupNameDataIndex2',
            type: 'string'
        }, {
            dataIndex: 'groupIdDataIndex2',
            type: 'int'
        }]
    });

    var secondGridStore = new Ext.data.Store({
        url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=getDataForAssociation',
        bufferSize: 367,
        reader: reader2,
        autoLoad: false,
        remoteSort: false
    });

    var associateAndDissociatebuttonsPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'buttonpannelid',
        layout: 'table',
        frame: false,
        width: 150,
        height: 500,
        layoutConfig: {
            columns: 1
        },
        items: [{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId1'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId3'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId4'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId5'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId6'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId7'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId8'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId9'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId10'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId11'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId12'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId13'
        }, {
            xtype: 'button',
            text: "<span style=font-weight:bold;>Associate</span>",
            id: 'associateId',
            iconCls: 'associatebutton',
            cls: 'userassetbuttonstyle',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('ltspComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectLTSP%>");
                            return;
                        }
                        if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                            Ext.example.msg("<%=SelectCustomer%>");
                            return;
                        }
                        if (Ext.getCmp('groupComboId').getValue() == "") {
                            Ext.example.msg("<%=selectGroupName%>");
                            return;
                        }
                        if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected()) {
                            Ext.example.msg("You Can Either Associate Or Dissociate At a Time");
                            return;
                        }
                        if (grid2.getSelectionModel().getSelected()) {
                            Ext.example.msg("GroupName Already Associated");
                            return;
                        }
                        var records4 = grid1.getSelectionModel().getSelected();
                        if (records4 == undefined || records4 == "undefined") {
                            Ext.example.msg("Please select Atleast One GroupName To Associate");
                            return;
                        }
                        var gridData = "";
                        var json = "";
                        var records1 = grid1.getSelectionModel().getSelections();
                        for (var i = 0; i < records1.length; i++) {
                            var record1 = records1[i];
                            var row = grid1.store.findExact('slnoIndex', record1.get('slnoIndex'));
                            var store = grid1.store.getAt(row);
                            json = json + Ext.util.JSON.encode(store.data) + ',';
                        }
                        var selected = grid1.getSelectionModel().getSelected();
                        outerPanel.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=associateGroup',
                            method: 'POST',
                            params: {
                                systemId: Ext.getCmp('ltspComboId').getValue(),
                                custId: Ext.getCmp('custcomboId').getValue(),
                                groupId: Ext.getCmp('groupComboId').getValue(),
                                gridData: json
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                firstGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        systemId: Ext.getCmp('ltspComboId').getValue(),
                                        groupId: Ext.getCmp('groupComboId').getValue()
                                    }
                                });
                                secondGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        systemId: Ext.getCmp('ltspComboId').getValue(),
                                        groupId: Ext.getCmp('groupComboId').getValue()
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                firstGridStore.reload();
                                secondGridStore.reload();

                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryFirstNameId14'
        }, {
            xtype: 'button',
            text: '<b>Disassociate</b>',
            id: 'dissociateid',
            cls: 'userassetbuttonstyle',
            iconCls: 'dissociatebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('ltspComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectLTSP%>");
                            return;
                        }
                        if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                            Ext.example.msg("<%=SelectCustomer%>");
                            return;
                        }
                        if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected()) {
                            Ext.example.msg("You Can Either Associate Or Dissociate At a Time");
                            return;
                        }
                        if (Ext.getCmp('groupComboId').getValue() == "") {
                            Ext.example.msg("<%=selectGroupName%>");
                            return;
                        }
                        if (grid1.getSelectionModel().getSelected()) {
                            Ext.example.msg("GroupName Already DisAssociated");
                            return;
                        }
                        var records3 = grid2.getSelectionModel().getSelected();
                        if (records3 == undefined || records3 == "undefined") {
                            Ext.example.msg('Please select Atleast One GroupName To Disassociate');
                            return;
                        }
                        var gridData2 = "";
                        var json2 = "";
                        var records2 = grid2.getSelectionModel().getSelections();
                        for (var i = 0; i < records2.length; i++) {
                            var record2 = records2[i];
                            var row = grid2.store.findExact('slnoIndex2', record2.get('slnoIndex2'));
                            var store = grid2.store.getAt(row);
                            json2 = json2 + Ext.util.JSON.encode(store.data) + ',';
                        }
                        var selected = grid2.getSelectionModel().getSelected();
                        outerPanel.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleGroupingForBilling.do?param=dissociateGroup',
                            method: 'POST',
                            params: {
                                systemId: Ext.getCmp('ltspComboId').getValue(),
                                custId: Ext.getCmp('custcomboId').getValue(),
                                groupId: Ext.getCmp('groupComboId').getValue(),
                                gridData2: json2
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                secondGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        systemId: Ext.getCmp('ltspComboId').getValue(),
                                        groupId: Ext.getCmp('groupComboId').getValue()
                                    }
                                });
                                firstGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        systemId: Ext.getCmp('ltspComboId').getValue(),
                                        groupId: Ext.getCmp('groupComboId').getValue()
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                firstGridStore.reload();
                                secondGridStore.reload();
                            }
                        });
                    }
                }
            }
        }]
    });

    var grid1 = getSelectionModelGrid('Non Associated', 'No Records found', firstGridStore, 470, 370, cols1, 6, filters1, sm1);
    var grid2 = getSelectionModelGrid('Associated', 'No Records found', secondGridStore, 470, 370, cols2, 6, filters2, sm2);

    var firstGridForNonAssociation = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'FirstGridForNonAssociationId',
        layout: 'table',
        frame: false,
        width: 480,
        height: 380,
        items: [grid1]
    });

    var secondGridPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'secondGridPanelId',
        layout: 'table',
        frame: false,
        width: 480,
        height: 380,
        items: [grid2]
    });

    var firstAndSecondPanels = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'firsrAndSecondGridPanelId',
        layout: 'table',
        frame: false,
        width: '100%',
        height: 395,
        layoutConfig: {
            columns: 5
        },
        items: [firstGridForNonAssociation, {
            width: 100
        }, associateAndDissociatebuttonsPanel, {
            width: 100
        }, secondGridPanel]
    });

    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            width: screen.width - 38,
            height: 510,
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [comboPanel, firstAndSecondPanels]
        });
        sb = Ext.getCmp('form-statusbar');
    });
</script>
  </body>
</html>