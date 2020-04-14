<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Vessel_ID");
	tobeConverted.add("Vessel_Name");
	tobeConverted.add("Live");
	tobeConverted.add("History");
	
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	
	String SlNo = convertedWords.get(2);
	String VesselId = convertedWords.get(3);
	String VesselName = convertedWords.get(4);
	String Live = convertedWords.get(5);
	String History = convertedWords.get(6);
	
	String NoRecordsFound = convertedWords.get(7);
	String ClearFilterData = convertedWords.get(8);
	String SelectSingleRow = convertedWords.get(9); 
	
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>By Vessel</title>		
	</head>	    
  
  	<body onload="refresh();" >
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
   	<script>
    var outerPanel;
    var ctsb;
    var dtprev;
    var custId;
    var byVesselGrid;
    var globalAssetNumber;
    var globalAssetId;

    //In chrome activate was slow so refreshing the page

    function refresh() {
        isChrome = window.chrome;
        if (isChrome && parent.flagMarineVessel < 2) {
            setTimeout(
                function () {
                    parent.Ext.getCmp('MarineByVesselId').enable();
                    parent.Ext.getCmp('MarineByVesselId').show();
                    parent.Ext.getCmp('MarineByVesselId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineByVessel.jsp'></iframe>");
                }, 0);
            parent.MarineVesselTab.doLayout();
            parent.flagMarineVessel = parent.flagMarineVessel + 1;
        }
    }

    //***************************************Customer Store*************************************  		
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function (custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();

                    byVesselStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                    Ext.getCmp('MarineVesselHistoryTabId').disable();

                    Ext.getCmp('MarineVesselLiveTabId').enable();
                    Ext.getCmp('MarineVesselLiveTabId').show();
                    Ext.getCmp('MarineVesselLiveTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselLive.jsp'></iframe>");

                }
            }
        }
    });

    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>',
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
                    byVesselStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                    Ext.getCmp('MarineVesselHistoryTabId').disable();

                    Ext.getCmp('MarineVesselLiveTabId').enable();
                    Ext.getCmp('MarineVesselLiveTabId').show();
                    Ext.getCmp('MarineVesselLiveTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselLive.jsp'></iframe>");
                }
            }
        }
    });

    function onCellClickOnGrid(byVesselGrid, rowIndex, columnIndex, e) {

        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }

        Ext.getCmp('MarineVesselHistoryTabId').enable(true);

        if (byVesselGrid.getSelectionModel().getCount() == 1) {
            var selected = byVesselGrid.getSelectionModel().getSelected();
            globalAssetNumber = selected.get('vesselName');
            globalAssetId = selected.get('vesselId');

            Ext.getCmp('MarineVesselLiveTabId').enable();
            Ext.getCmp('MarineVesselLiveTabId').show();
            Ext.getCmp('MarineVesselLiveTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselLive.jsp'></iframe>");
        
        }
    }


    var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'MarineVesselRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'vesselId'
        }, {
            name: 'vesselName'
        }]
    });

    var byVesselStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MarineVessel.do?param=getMarineVessel',
            method: 'POST'
        }),
        remoteSort: false,

        storeId: 'darStore',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'int',
            dataIndex: 'vesselId'
        }, {
            type: 'string',
            dataIndex: 'vesselName'
        }]
    });

    //************************************Column Model Config******************************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VesselId%></span>",
                dataIndex: 'vesselId',
                width: 80,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VesselName%></span>",
                dataIndex: 'vesselName',
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

    byVesselGrid = getGrid('', '<%=NoRecordsFound%>', byVesselStore, 300, 435, 4, filters, '<%=ClearFilterData%>', false, '', 4);

    byVesselGrid.on({
        "cellclick": {
            fn: onCellClickOnGrid
        }
    });

    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
        width: 300,
        layoutConfig: {
            columns: 2
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo
        ]
    }); // End of Panel	

    var vesselPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'vesselPanelId',
        layout: 'table',
        frame: false,
        width: 300,
        height: 560,
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, byVesselGrid]
    }); // End of Panel	

    var LiveOrHistoryTab = new Ext.TabPanel({
        resizeTabs: false, // turn off tab resizing
        enableTabScroll: true,
        activeTab: 'MarineVesselLiveTabId',
        width: screen.width-354,
        height: 560,
        listeners: {
            tabchange: function (tp, newTab, currentTab) {
                var activeTab = LiveOrHistoryTab.getActiveTab();
                var activeTabIndex = LiveOrHistoryTab.items.findIndex('id', activeTab.id);
                switch (activeTabIndex) {
                case 0:
                    Ext.getCmp('MarineVesselLiveTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselLive.jsp'></iframe>");
                    break;
                case 1:
                    Ext.getCmp('MarineVesselHistoryTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselHistory.jsp'></iframe>");
                    break;
                }
            }
        },
        defaults: {
            autoScroll: false
        }
    });
    addTab();

    function addTab() {
        LiveOrHistoryTab.add({

            title: '<%=Live%>',
            iconCls: 'admintab',
            id: 'MarineVesselLiveTabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselLive.jsp'></iframe>"

        }).show();

        LiveOrHistoryTab.add({

            title: '<%=History%>',
            iconCls: 'admintab',
            id: 'MarineVesselHistoryTabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/MarineVessel/MarineVesselHistory.jsp'></iframe>"

        }).show();

        Ext.getCmp('MarineVesselHistoryTabId').disable(true);
    }

    Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            collapsible: false,
            height:510,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 2
            },
            items: [vesselPanel, LiveOrHistoryTab],
            //bbar: ctsb
        });
    });
	</script>
  	</body>
</html>