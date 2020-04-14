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
	tobeConverted.add("Accident_Expenditure_Summary");
	
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("No_Of_Accidents");
	tobeConverted.add("Total_Payments");
	tobeConverted.add("Total_Receipts");
	tobeConverted.add("Total_Loss_Of_Life");
	tobeConverted.add("Total_Injured");
	tobeConverted.add("Total_Cases_Opened");
	tobeConverted.add("Total_Cases_Closed");
	
	tobeConverted.add("Next");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String AccidentExpenditureSummary = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	
	String SlNo = convertedWords.get(3);
	String AssetNumber = convertedWords.get(4);
	String NoOfAccidents = convertedWords.get(5);
	String TotalPayments = convertedWords.get(6);
	String TotalReceipts = convertedWords.get(7);
	String TotalLossOfLife = convertedWords.get(8);
	String TotalInjured = convertedWords.get(9);
	String TotalCasesOpened = convertedWords.get(10);
	String TotalCasesClosed = convertedWords.get(11);

	String Next = convertedWords.get(12);	
	String NoRecordsFound = convertedWords.get(13);
	String ClearFilterData = convertedWords.get(14);
	String SelectSingleRow = convertedWords.get(15); 
	String Excel = convertedWords.get(16); 
	String PDF = convertedWords.get(17); 	
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>Accident Expenditure Summary</title>		
	</head>	    
  
  	<body onload="refresh();" >
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.x-toolbar .x-small-editor .x-toolbar-layout-ct {
			width : 1304px !important;
		}
		</style>
   	<script>
   	var jspName = "AccidentExpenditureSummary";
  	var exportDataType = "int,string,int,number,number,int,int,int,int";
    var outerPanel;
    var ctsb;
    var summaryGrid;
    var custId;
    var custName;

    //In chrome activate was slow so refreshing the page

    function refresh() {
        isChrome = window.chrome;
        if (isChrome && parent.flagAccidentAnalysisReport < 2) {
            setTimeout(
                function () {
                    parent.Ext.getCmp('AccidentExpenditureSummaryId').enable();
                    parent.Ext.getCmp('AccidentExpenditureSummaryId').show();
                    parent.Ext.getCmp('AccidentExpenditureSummaryId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentExpenditureSummary.jsp'></iframe>");
                }, 0);
            parent.AccidentAnalysisReportTab.doLayout();
            parent.flagAccidentAnalysisReport = parent.flagAccidentAnalysisReport + 1;
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    
                    parent.globalCustomerID = custId;
                    parent.globalCustomerName = custName;
                    
                    accidentExpenditureSummaryStore.load({
                    	params: {
                    		CustId: custId,
                    		CustName: custName,
                    		jspName: jspName
                    	}
                    });
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    
                    parent.globalCustomerID = custId;
                    parent.globalCustomerName = custName;
                    
                    accidentExpenditureSummaryStore.load({
                    	params: {
                    		CustId: custId,
                    		CustName: custName,
                    		jspName: jspName
                    	}
                    });
                    
                }
            }
        }
    });
    
    function onCellClickOnGrid(caseInfoGrid, rowIndex, columnIndex, e) {


        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }

        if (summaryGrid.getSelectionModel().getCount() == 0) {
        	parent.Ext.getCmp('AccidentExpenditureDetailsId').disable();
			parent.Ext.getCmp('AccidentExpenditureDetailsId').hide();
			Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        
        if (summaryGrid.getSelectionModel().getCount() > 1) {
        	parent.Ext.getCmp('AccidentExpenditureDetailsId').disable();
			parent.Ext.getCmp('AccidentExpenditureDetailsId').hide();
			Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }

        if (summaryGrid.getSelectionModel().getCount() == 1) {
            var selected = summaryGrid.getSelectionModel().getSelected();
            if(selected.get('assetNumber') == 'TOTAL'){
            	parent.Ext.getCmp('AccidentExpenditureDetailsId').disable();
				parent.Ext.getCmp('AccidentExpenditureDetailsId').hide();        	   
            } else {
            	parent.Ext.getCmp('AccidentExpenditureDetailsId').enable(true);
            	parent.assetNumber = selected.get('assetNumber');
            }                         	
        }
    }
 
    var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'AccidentExpenditureSummaryRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'assetNumber'
        }, {
            name: 'noOfAccidents'
        }, {
            name: 'totalPayments'
        }, {
            name: 'totalReceipts'
        }, {
            name: 'totalLossOfLife'
        }, {
            name: 'totalInjured'
        }, {
            name: 'totalCasesOpened'
        }, {
            name: 'totalCasesClosed'
        }]
    });

    var accidentExpenditureSummaryStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentExpenditureSummary',
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
            type: 'string',
            dataIndex: 'assetNumber'
        }, {
            type: 'numeric',
            dataIndex: 'noOfAccidents'
        }, {
            type: 'float',
            dataIndex: 'totalPayments'
        }, {
            type: 'float',
            dataIndex: 'totalReceipts'
        }, {
            type: 'numeric',
            dataIndex: 'totalLossOfLife'
        }, {
            type: 'numeric',
            dataIndex: 'totalInjured'
        }, {
            type: 'string',
            dataIndex: 'totalCasesOpened'
        }, {
            type: 'string',
            dataIndex: 'totalCasesClosed'
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
                header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
                dataIndex: 'assetNumber',
                width: 120,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=NoOfAccidents%></span>",
                dataIndex: 'noOfAccidents',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalPayments%></span>",
                dataIndex: 'totalPayments',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalReceipts%></span>",
                dataIndex: 'totalReceipts',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalLossOfLife%></span>",
                dataIndex: 'totalLossOfLife',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalInjured%></span>",
                dataIndex: 'totalInjured',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalCasesOpened%></span>",
                dataIndex: 'totalCasesOpened',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalCasesClosed%></span>",
                dataIndex: 'totalCasesClosed',
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
    
    summaryGrid = getGrid('', '<%=NoRecordsFound%>', accidentExpenditureSummaryStore, screen.width - 55, 425, 10, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

	summaryGrid.on({
        "cellclick": {
            fn: onCellClickOnGrid
        }
    });  

    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
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
    
    var nextButtonPanel = new Ext.Panel({   
        id: 'nextbuttonid',
        standardSubmit: true,
        collapsible: false,
        cls: 'nextbuttonpanel',
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [{
            xtype: 'button',
            text: '<%=Next%>',
            id: 'nextButtId',
            iconCls: 'nextbutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {
                    	if (Ext.getCmp('custcomboId').getValue() == "") {
            				Ext.example.msg("<%=SelectCustomer%>");
            				Ext.getCmp('custcomboId').focus();
            				return;
        				}
        				
        				if (summaryGrid.getSelectionModel().getCount() == 0) {
            				Ext.example.msg("<%=SelectSingleRow%>");
            				return;
        				}
        			
        				if (summaryGrid.getSelectionModel().getCount() > 1) {
            				Ext.example.msg("<%=SelectSingleRow%>");
            				return;
        				}
        				
        				 parent.Ext.getCmp('AccidentExpenditureDetailsId').enable(true);
						
        				if (summaryGrid.getSelectionModel().getCount() == 1) {

            				var selected = summaryGrid.getSelectionModel().getSelected();
            				
            				if(selected.get('assetNumber') == 'TOTAL'){
            					parent.Ext.getCmp('AccidentExpenditureDetailsId').disable();
								parent.Ext.getCmp('AccidentExpenditureDetailsId').hide();        	   
            				} else {
            					parent.assetNumber = selected.get('assetNumber');
            					
            					parent.Ext.getCmp('AccidentExpenditureDetailsId').enable();
								parent.Ext.getCmp('AccidentExpenditureDetailsId').show();
								parent.Ext.getCmp('AccidentExpenditureDetailsId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentExpenditureDetails.jsp'></iframe>");
            				}    
        				}
                    }
                }
            }
        }]  	
    });

    Ext.onReady(function () {
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
            items: [innerPanel, summaryGrid, nextButtonPanel]
            //bbar: ctsb
        });
    });
</script>
  	</body>
</html>