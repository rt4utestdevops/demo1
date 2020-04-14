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
	
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Select_Asset_Number");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Case_Number");
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Accidental_Type");
	tobeConverted.add("DateTime");
	tobeConverted.add("Location");
	tobeConverted.add("Total_Payments");
	tobeConverted.add("Total_Receipts");
	tobeConverted.add("Insurance_Claimed_Amount");
	tobeConverted.add("Total_Loss_Of_Life");
	tobeConverted.add("Total_Injured");
	tobeConverted.add("Case_Status");

	tobeConverted.add("Back");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String AssetNumber = convertedWords.get(0);
	String SelectAssetNumber = convertedWords.get(1);
	
	String SlNo = convertedWords.get(2);
	String CaseNumber = convertedWords.get(3);
	String DriverName = convertedWords.get(4);
	String AccidentalType = convertedWords.get(5);
	String DateTime = convertedWords.get(6);
	String Location = convertedWords.get(7);
	String TotalPayments = convertedWords.get(8);
	String TotalReceipts = convertedWords.get(9);
	String InsuranceClaimedAmount = convertedWords.get(10);
	String TotalLossOfLife = convertedWords.get(11);
	String TotalInjured = convertedWords.get(12);
	String CaseStatus = convertedWords.get(13);
	
	String Back = convertedWords.get(14);	
	String NoRecordsFound = convertedWords.get(15);
	String ClearFilterData = convertedWords.get(16);
	String SelectSingleRow = convertedWords.get(17); 
	String Excel = convertedWords.get(18); 
	String PDF = convertedWords.get(19); 
		
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>Accident Expenditure Details</title>		
	</head>	    
  
  	<body>
   		 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "AccidentExpenditureDetails";
  	var exportDataType = "int,string,string,string,string,string,string,number,number,number,int,int,string";
    var outerPanel;
    var ctsb;
    var detailsGrid;
    var assetNumber = parent.assetNumber;
    var globalCustomerId = parent.globalCustomerID;
    var globalCustomerName = parent.globalCustomerName;
	

	var vehiclestore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentVehicleNo',
	    id: 'VehicleStoreId',
	    root: 'VehicleNoRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['VehicleNo']
	});
	
	vehiclestore.on('beforeload',function(store, operation,eOpts){
   				operation.params={
          	    	CustId : globalCustomerId
          	    };
    });
    
    vehiclestore.on('load',function(store, operation,eOpts){  	    
    	Ext.getCmp('vehiclecomboId').setValue(assetNumber);
        accidentExpenditureDetailsStore.load({
	        params : {
	            CustId: globalCustomerId,
	            CustName: globalCustomerName,
	            assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
	            jspName: jspName
	        }
	    });    	    
	},this);

	var vehiclecombo = new Ext.form.ComboBox({
	    store: vehiclestore,
	    id: 'vehiclecomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=SelectAssetNumber%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'VehicleNo',
	    displayField: 'VehicleNo',
	    cls: 'selectperfectstyle',
	    listeners: {
	        select: {
	            fn: function () {	                
	                accidentExpenditureDetailsStore.load({
	                	params : {
	                		CustId: globalCustomerId,
	                		CustName: globalCustomerName,
	                		assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
	                		jspName: jspName
	                	}
	                });
	            }
	        }
	    }
	});

    var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'AccidentExpenditureDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'assetNumber'
        }, {
            name: 'caseNumber'
        }, {
            name: 'driverName'
        }, {
            name: 'accidentalType'
        }, {
            name: 'dateTime',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'location'
        }, {
            name: 'totalPayments'
        }, {
            name: 'totalReceipts'
        }, {
            name: 'insuranceClaimedAmount'
        }, {
            name: 'totalLossOfLife'
        }, {
            name: 'totalInjured'
        }, {
            name: 'caseStatus'
        }]
    });

    var accidentExpenditureDetailsStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentExpenditureDetails',
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
            type: 'string',
            dataIndex: 'caseNumber'
        }, {
            type: 'string',
            dataIndex: 'driverName'
        }, {
            type: 'string',
            dataIndex: 'accidentalType'
        }, {
            type: 'date',
            dataIndex: 'dateTime'
        }, {
            type: 'string',
            dataIndex: 'location'
        }, {
            type: 'float',
            dataIndex: 'totalPayments'
        }, {
            type: 'float',
            dataIndex: 'totalReceipts'
        }, {
            type: 'float',
            dataIndex: 'insuranceClaimedAmount'
        }, {
            type: 'numeric',
            dataIndex: 'totalLossOfLife'
        }, {
            type: 'numeric',
            dataIndex: 'totalInjured'
        }, {
            type: 'string',
            dataIndex: 'caseStatus'
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
                header: "<span style=font-weight:bold;><%=CaseNumber%></span>",
                dataIndex: 'caseNumber',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=DriverName%></span>",
                dataIndex: 'driverName',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=AccidentalType%></span>",
                dataIndex: 'accidentalType',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=DateTime%></span>",
                dataIndex: 'dateTime',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Location%></span>",
                dataIndex: 'location',
                filter: {
                    type: 'string'
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
                header: "<span style=font-weight:bold;><%=InsuranceClaimedAmount%></span>",
                dataIndex: 'insuranceClaimedAmount',
                width: 140,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalLossOfLife%></span>",
                dataIndex: 'totalLossOfLife',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalInjured%></span>",
                dataIndex: 'totalInjured',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=CaseStatus%></span>",
                dataIndex: 'caseStatus',
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

    detailsGrid = getGrid('', '<%=NoRecordsFound%>', accidentExpenditureDetailsStore, screen.width - 38, 410, 14, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

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
                text: '<%=AssetNumber%>' + ' :',
                cls: 'labelstyle',
                id: 'assetNumberlab'
            },
            vehiclecombo
        ]
    }); // End of Panel	
    
    var backButtonPanel = new Ext.Panel({   
        id: 'backbuttonid',
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
            text: '<%=Back%>',
            id: 'backButtId',
            iconCls: 'backbutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {
						parent.Ext.getCmp('AccidentExpenditureSummaryId').enable();
						parent.Ext.getCmp('AccidentExpenditureSummaryId').show();
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
            items: [innerPanel, detailsGrid, backButtonPanel]
            //bbar: ctsb
        });
    });
</script>
  	</body>
</html>