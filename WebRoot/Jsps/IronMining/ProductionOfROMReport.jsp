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
	tobeConverted.add("Next");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
    tobeConverted.add("View");
    
    tobeConverted.add("Select_Date");
	tobeConverted.add("Select_Mineral_Type");		
	tobeConverted.add("Mine_Code");
	tobeConverted.add("TC_No");
	tobeConverted.add("Select_Category");
	tobeConverted.add("Opening_Stock");
	tobeConverted.add("Production");
	tobeConverted.add("Closing_Stock");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	String SlNo = convertedWords.get(2);
	String Next = convertedWords.get(3);	
	String NoRecordsFound = convertedWords.get(4);
	String ClearFilterData = convertedWords.get(5);
	String SelectSingleRow = convertedWords.get(6); 
	String Excel = convertedWords.get(7); 
	String PDF = convertedWords.get(8); 	
	String View=convertedWords.get(9); 	
    String SelectDate=convertedWords.get(10); 	
    String SelectMineral=convertedWords.get(11); 	
    String MineCode=convertedWords.get(12); 	
    String TcNo=convertedWords.get(13); 	
    String SelectCategory=convertedWords.get(14);
    String OpeningStock=convertedWords.get(15);
    String Production=convertedWords.get(16);
    String ClosingStock=convertedWords.get(17);

%>

<jsp:include page="../Common/header.jsp" />
    <title>production Of ROM Report</title>

    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
        <div align="left">
            <jsp:include page="../Common/ImportJSSandMining.jsp"></jsp:include>
            <%}else {%>
                <jsp:include page="../Common/ImportJS.jsp"></jsp:include>
                <%} %>

                    <!-- for exporting to excel***** -->
                    <jsp:include page="../Common/ExportJS.jsp"></jsp:include>
	<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}			
			.container {   
				width : 92% !important;
				margin-left: 0px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
		</style>
	 <%}%>	
					
</div>
<script>
    var jspName = "Production_Of_ROM_Report";
    var exportDataType = "int,string,string,number,number,number";
    var outerPanel;
    var ctsb;
    var custId;
    var custName;
    var dtcur = datecur;
    var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
    //***************************************Customer Store*************************************  		
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
                fn: function() {}
            }
        }
    });

    var mineralNamestore = new Ext.data.SimpleStore({
        id: 'mineralsComboStoreId',
        fields: ['mineralName', 'mineralName'],
        autoLoad: true,
        data: [
            ['Iron Ore', 'Iron Ore'],
            ['Bauxite/Laterite', 'Bauxite/Laterite'],
            ['Manganese', 'Manganese']
        ]
    });

    var mineralCombo = new Ext.form.ComboBox({
        store: mineralNamestore,
        id: 'mineralComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectMineral%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'mineralName',
        displayField: 'mineralName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('categoryId').reset();
                    categoryStore.load({
                        params: {
                            typeOfOre: Ext.getCmp('mineralComboId').getValue()
                        }
                    });
                }
            }
        }
    });

    var categoryStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/MonthlyReturnsReportsAction.do?param=getCategory',
        id: 'categoryStoreId',
        root: 'categoryRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['categoryName', 'categoryName'],
        listeners: {}
    });

    var categoryCombo = new Ext.form.ComboBox({
        store: categoryStore,
        id: 'categoryId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCategory%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'categoryName',
        displayField: 'categoryName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {}
            }
        }
    });


    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'productionReportRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'mineCodeDataIndex'
        }, {
            name: 'tcNoDataIndex'
        }, {
            name: 'openingStockDataIndex'
        }, {
            name: 'productionDataIndex'
        }, {
            name: 'closingStockDataIndex'
        }]
    });

    var productionReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MonthlyReturnsReportsAction.do?param=getProductionReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'productionStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'mineCodeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'tcNoDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'openingStockDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'productionDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'closingStockDataIndex'
        }]
    });

    //************************************Column Model Config******************************************
    var createColModel = function(finish, start) {

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
                header: "<span style=font-weight:bold;><%=MineCode%></span>",
                dataIndex: 'mineCodeDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TcNo%></span>",
                dataIndex: 'tcNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=OpeningStock%></span>",
                dataIndex: 'openingStockDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Production%></span>",
                dataIndex: 'productionDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=ClosingStock%></span>",
                dataIndex: 'closingStockDataIndex',
                filter: {
                    type: 'numeric'
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

    var grid = getGrid('Production Of ROM Details', '<%=NoRecordsFound%>', productionReportStore, screen.width - 35, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '<%=PDF%>');

    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title: '',
        id: 'panelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 10
        },
        items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :' ,
            cls: 'labelstyle',
            id: 'custnamelab'
        },{
            width: '50px'
        }, custnamecombo, {
            width: '150px'
        }, {
            xtype: 'label',
            text: '<%=SelectDate%>' + ' :',
            cls: 'labelstyle',
            id: 'DtLabelId'
        },{
            width: '50px'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            id: 'DateId',
            value:dtcur,
            format: getMonthYearFormat(),
            plugins: 'monthPickerPlugin'
        }, {
            width: '30px'
        },{
            width: '30px'
        },{
            width: '30px'
        }, {
            xtype: 'label',
            text: '<%=SelectMineral%>' + ' :',
            cls: 'labelstyle',
            id: 'mineralLabelId'
        },{
            width: '50px'
        }, mineralCombo, {
            width: '30px'
        }, {
            xtype: 'label',
            text: '<%=SelectCategory%>' + ' :',
            cls: 'labelstyle',
            id: 'categoryLabelId'
        },{
            width: '50px'
        }, categoryCombo, {
            width: '80px'
        }, {
            xtype: 'button',
            text: 'Generate Report',
            id: 'addbuttonid',
            cls: ' ',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('custcomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectCustomer%>");
                            Ext.getCmp('custcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('DateId').getValue() == "") {
                            Ext.example.msg("<%=SelectCategory%>");
                            Ext.getCmp('DateId').focus();
                            return;
                        }
                        if (Ext.getCmp('mineralComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectMineral%>");
                            Ext.getCmp('mineralComboId').focus();
                            return;
                        }
                        if (Ext.getCmp('categoryId').getValue() == "") {
                            Ext.example.msg("<%=SelectCategory%>");
                            Ext.getCmp('categoryId').focus();
                            return;
                        }
                        var date = Ext.getCmp('DateId').getValue();
                        var year=date.getFullYear();
                        productionReportStore.load({
                            params: {
                                custId: Ext.getCmp('custcomboId').getValue(),
                                mineralName: Ext.getCmp('mineralComboId').getValue(),
                                category: Ext.getCmp('categoryId').getValue(),
                                month: monthNames[date.getMonth()],
                                year: year,
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                jspName: jspName
                            }
                        });
                    }
                }
            }
        }]
    });

    function getMonthYearFormat() {
        return 'F Y';
    }
    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [innerPanel, grid]
        });
        var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 250);
        }
    });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->


