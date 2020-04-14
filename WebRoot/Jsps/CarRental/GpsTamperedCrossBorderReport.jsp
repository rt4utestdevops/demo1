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
	tobeConverted.add("Select_client");
	tobeConverted.add("SLNO");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
    tobeConverted.add("View");
	tobeConverted.add("Registration_No");
	tobeConverted.add("Group_Name");
    tobeConverted.add("Vehicle_Model");
	tobeConverted.add("GPS_Tampered_Date");
    tobeConverted.add("GPS_Tampered_Location");
	tobeConverted.add("Crossed_Border_Date");
	tobeConverted.add("Crossed_Border_Location");
    tobeConverted.add("Action_Taken");
	tobeConverted.add("User_Name");
	tobeConverted.add("Updated_Date_Time");
	tobeConverted.add("GPS_Tampered_Crossed_Border_Report");

	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	String SelectClient = convertedWords.get(0);
	String SlNo = convertedWords.get(1);
	String NoRecordsFound = convertedWords.get(2);
	String ClearFilterData = convertedWords.get(3);
	String Excel = convertedWords.get(4); 
	String PDF = convertedWords.get(5); 	
	String StartDate=convertedWords.get(6); 	
	String EndDate=convertedWords.get(7); 	
	String MonthValidation=convertedWords.get(8); 	
	String SelectStartDate=convertedWords.get(9); 	
	String SelectEndDate=convertedWords.get(10);
	String EndDateMustBeGreaterthanStartDate = convertedWords.get(11); 	
	String View=convertedWords.get(12);
	String regNo=convertedWords.get(13);
	String groupName=convertedWords.get(14);
	String vehicleModel=convertedWords.get(15); 	
    String GPS_Tampered_Date=convertedWords.get(16);
    String GPS_Tampered_Location=convertedWords.get(17);
    String Crossed_Border_Date=convertedWords.get(18);
    String Crossed_Border_Location=convertedWords.get(19);
    String Action_Taken=convertedWords.get(20);
    String User_Name=convertedWords.get(21);
    String Updated_Date_Time=convertedWords.get(22);
    String GPS_Tampered_Crossed_Border_Report=convertedWords.get(23);
    
%>

<jsp:include page="../Common/header.jsp" />
		<title>GPS Tampered Crossed Border Report</title>		
	  
  	<style>
  	.col{
			color:#0B0B61;
			font-family: sans-serif;
			font-size:14px;
			width: 400;
		}
    </style>
 
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
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
				padding-top : 6px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			 }
		</style>
  
   	<script>
  	var dtcur = datecur;
	var dtnxt = datenext;
	var jspName = "tamperedCrossBorderReport";
	var exportDataType = "int,string,string,string,date,string,date,string,string,string,date";
	var outerPanel;
	var ctsb;
	var Grid;
	var custId;
	var custName;

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
	                Ext.getCmp('clientId').setValue('<%=customerId%>');
	            }
	        }
	    }
	});

	var clientCombo = new Ext.form.ComboBox({
	    store: customercombostore,
	    id: 'clientId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=SelectClient%>',
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

	var reader = new Ext.data.JsonReader({
	    idProperty: 'gpsReaderId',
	    root: 'gpsTamperedCrossRoot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'slnoDataIndex'
	    }, {
	        name: 'regNoIndex'
	    }, {
	        name: 'groupNameIndex'
	    }, {
	        name: 'vehicleModelIndex'
	    }, {
	        name: 'gpsTamperedDateIndex',
	        type: 'date',
	        dateFormat: 'c'
	    }, {
	        name: 'gpsTamperedLocIndex'
	    }, {
	        name: 'crossBorderDateIndex',
	        type: 'date',
	        dateFormat: 'c'
	    }, {
	        name: 'actionTakenIndex'
	    }, {
	        name: 'userNameIndex'
	    }, {
	        name: 'UpdatedTimeIndex',
	        type: 'date',
	        dateFormat: 'c'
	    }]
	});

	var store = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/GpsTamperedCrossBorderAction.do?param=getGPSCrossBorderReport',
	        method: 'POST'
	    }),
	    remoteSort: false,
	    storeId: 'gpsTamperedReportId',
	    reader: reader
	});

	var filters = new Ext.ux.grid.GridFilters({
	    local: true,
	    filters: [{
	        type: 'string',
	        dataIndex: 'regNoIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'groupNameIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'vehicleModelIndex'
	    }, {
	        type: 'date',
	        dataIndex: 'gpsTamperedDateIndex'
	    }, {
	        type: 'String',
	        dataIndex: 'gpsTamperedLocIndex'
	    }, {
	        type: 'date',
	        dataIndex: 'crossBorderDateIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'crossborderLocIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'actionTakenIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'userNameIndex'
	    }, {
	        type: 'date',
	        dataIndex: 'UpdatedTimeIndex'
	    }]
	});

	//************************************Column Model Config******************************************
	var createColModel = function(finish, start) {
	    var columns = [
	        new Ext.grid.RowNumberer({
	            header: "<span style=font-weight:bold;><%=SlNo%></span>",
	            width: 50
	        }), {
	            header: "<%=SlNo%>",
	            dataIndex: 'slnoDataIndex',
	            width: 50,
	            hidden: true
	        }, {
	            header: "<span style=font-weight:bold;>Registration No</span>",
	            dataIndex: 'regNoIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=groupName%></span>",
	            dataIndex: 'groupNameIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=vehicleModel%></span>",
	            dataIndex: 'vehicleModelIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=GPS_Tampered_Date%></span>",
	            dataIndex: 'gpsTamperedDateIndex',
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
	        }, {
	            header: "<span style=font-weight:bold;><%=GPS_Tampered_Location%></span>",
	            dataIndex: 'gpsTamperedLocIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=Crossed_Border_Date%></span>",
	            dataIndex: 'crossBorderDateIndex',
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
	        }, {
	            header: "<span style=font-weight:bold;><%=Crossed_Border_Location%></span>",
	            dataIndex: 'crossborderLocIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=Action_Taken%></span>",
	            dataIndex: 'actionTakenIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=User_Name%></span>",
	            dataIndex: 'userNameIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=Updated_Date_Time%></span>",
	            dataIndex: 'UpdatedTimeIndex',
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
	        }
	    ];

	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),
	        defaults: {
	            sortable: true
	        }
	    });
	};

	Grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 25, 420, 23, filters, 'Clear filter Data', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

	var Panel = new Ext.Panel({
	    standardSubmit: true,
	    collapsible: false,
	    id: 'panelId',
	    layout: 'table',
	    frame: true,
	    layoutConfig: {
	        columns: 10
	    },
	    items: [{
	        xtype: 'label',
	        text: '<%=SelectClient%>' + ' :',
	        cls: 'labelstyle',
	        id: 'client'
	    }, clientCombo, {
	        width: 30
	    }, {
	        xtype: 'label',
	        text: '<%=StartDate%>' + ' :',
	        cls: 'labelstyle',
	        id: 'startDate'
	    }, {
	        xtype: 'datefield',
	        cls: 'selectstylePerfect',
	        width: 185,
	        format: getDateFormat(),
	        emptyText: '<%=SelectStartDate%>',
	        allowBlank: false,
	        blankText: '<%=SelectStartDate%>',
	        id: 'startDateId',
	        maxValue: dtcur,
	        value: dtcur,
	        endDateField: 'enddate'
	    }, {
	        width: 30
	    }, {
	        xtype: 'label',
	        text: '<%=EndDate%>' + ' :',
	        cls: 'labelstyle',
	        id: 'endDate'
	    }, {
	        xtype: 'datefield',
	        cls: 'selectstylePerfect',
	        width: 185,
	        format: getDateFormat(),
	        emptyText: '<%=SelectEndDate%>',
	        allowBlank: false,
	        blankText: '<%=SelectEndDate%>',
	        id: 'endDateId',
	        maxValue: dtnxt,
	        value: dtnxt,
	        startDateField: 'startdate'
	    }, {
	        width: 30
	    }, {
	        xtype: 'button',
	        text: '<%=View%>',
	        id: 'addbuttonid',
	        cls: ' ',
	        width: 80,
	        listeners: {
	            click: {
	                fn: function() {
	                    if (Ext.getCmp('clientId').getValue() == "") {
	                        Ext.example.msg("Select Client");
	                        Ext.getCmp('clientId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('startDateId').getValue() == "") {
	                        Ext.example.msg("Select Start Date");
	                        Ext.getCmp('startDateId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('endDateId').getValue() == "") {
	                        Ext.example.msg("Select End Date");
	                        Ext.getCmp('endDateId').focus();
	                        return;
	                    }
	                    var startdates = Ext.getCmp('startDateId').getValue();
	                    var enddates = Ext.getCmp('endDateId').getValue();

	                    if (dateCompare(startdates, enddates) == -1) {
	                        Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
	                        Ext.getCmp('endDateId').focus();
	                        return;
	                    }
	                    if (checkMonthValidation(startdates, enddates)) {
	                        Ext.example.msg("<%=MonthValidation%>");
	                        Ext.getCmp('endDateId').focus();
	                        return;
	                    }
	                    store.load({
	                        params: {
	                            customerId: Ext.getCmp('clientId').getValue(),
	                            startDate: Ext.getCmp('startDateId').getValue(),
	                            endDate: Ext.getCmp('endDateId').getValue(),
	                            custName: Ext.getCmp('clientId').getRawValue(),
	                            jspName: jspName
	                        }
	                    });
	                }
	            }
	        }
	    }]
	}); // End of Panel	

	Ext.onReady(function() {
	    ctsb = tsb;
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    outerPanel = new Ext.Panel({
	        title: '<%=GPS_Tampered_Crossed_Border_Report%>',
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        cls: 'outerpanel',
	        //width:screen.width-22,
	        layout: 'table',
	        layoutConfig: {
	            columns: 1
	        },
	        items: [Panel, Grid]
	    });
	    var cm = Grid.getColumnModel();
	    for (var j = 2; j < cm.getColumnCount(); j++) {
	        cm.setColumnWidth(j, 200);
	    }
	});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->