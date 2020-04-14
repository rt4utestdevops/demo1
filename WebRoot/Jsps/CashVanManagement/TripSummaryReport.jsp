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
	tobeConverted.add("Trip_Summary_Report");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Next");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
	tobeConverted.add("Total_Kms_By_Veh_ODO");		
	tobeConverted.add("Total_Kms_By_GPS");
	tobeConverted.add("No_Of_Points_Visited");
	tobeConverted.add("Total_Trip_Hrs");
	tobeConverted.add("Trip_Start_Veh_ODO");
	tobeConverted.add("Trip_End_Veh_ODO");
	tobeConverted.add("Trip_Start_Date_Time");
    tobeConverted.add("Trip_End_Date_Time");
    
    tobeConverted.add("Trip_No");
	tobeConverted.add("Vehicle_No");
	
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("View");
    
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Custodian_Name");
	tobeConverted.add("Gunman_Name");
	
	tobeConverted.add("Hub");
	tobeConverted.add(" Route");
	tobeConverted.add("Region");
	tobeConverted.add("Location");		
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String TripSummaryReport = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	
	String SlNo = convertedWords.get(3);
	String Next = convertedWords.get(4);	
	String NoRecordsFound = convertedWords.get(5);
	String ClearFilterData = convertedWords.get(6);
	String SelectSingleRow = convertedWords.get(7); 
	String Excel = convertedWords.get(8); 
	String PDF = convertedWords.get(9); 	
	
	String TotalKmsByOdometer=convertedWords.get(10);
	String TotalDistance=convertedWords.get(11); 	
	String VisistedPoints=convertedWords.get(12); 	
	String TotalTripHrs=convertedWords.get(13); 	
	String TripStartVehODO=convertedWords.get(14); 	
	String TripEndVehODO=convertedWords.get(15); 	
	String TripStartDate=convertedWords.get(16); 	
	String TripEndDate=convertedWords.get(17); 	

	String TripNo=convertedWords.get(18); 	
	String VehicleNo=convertedWords.get(19); 	
	String MonthValidation=convertedWords.get(20); 	
	String SelectStartDate=convertedWords.get(21); 	
	String SelectEndDate=convertedWords.get(22); 	
	String View=convertedWords.get(23); 	
	
    String DriverName=convertedWords.get(24); 	
	String CustodianName=convertedWords.get(25); 	
    String Gunman=convertedWords.get(26); 	
    String Hub=convertedWords.get(27); 	
    String Route=convertedWords.get(28); 	
    String Region=convertedWords.get(29); 	
    String Location=convertedWords.get(30); 
    String EndDateMustBeGreaterthanStartDate = convertedWords.get(31);	
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
			.x-toolbar-layout-ct {
				width : 1305px !important;
			}
		</style>
   	<script>
   	var jspName = "Trip_Summary_Report";
  	var exportDataType = "int,string,string,string,string,string,string,string,string,string,date,date,number,number,string,int,number,number";
    var outerPanel;
    var ctsb;
    var summaryGrid;
    var custId;
    var custName;
    var dtprev = dateprev;
    var dtcur = datecur;

    //In chrome activate was slow so refreshing the page

    function refresh() {
        isChrome = window.chrome;
        if (isChrome && parent.flagTripReport < 2) {
            setTimeout(
                function () {
                    parent.Ext.getCmp('tripSummaryId').enable();
                    parent.Ext.getCmp('tripSummaryId').show();
                    parent.Ext.getCmp('tripSummaryId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/CashVanManagement/TripSummaryReport.jsp'></iframe>");
                }, 0);
            parent.TripReportTab.doLayout();
            parent.flagTripReport = parent.flagTripReport + 1;
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
        	parent.Ext.getCmp('tripDetailsId').disable();
			parent.Ext.getCmp('tripDetailsId').hide();
			Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        
        if (summaryGrid.getSelectionModel().getCount() > 1) {
        	parent.Ext.getCmp('tripDetailsId').disable();
			parent.Ext.getCmp('tripDetailsId').hide();
			Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }

        if (summaryGrid.getSelectionModel().getCount() == 1) {
            var selected = summaryGrid.getSelectionModel().getSelected();
            	parent.Ext.getCmp('tripDetailsId').enable(true);
            	parent.tripNo= selected.get('tripNoDataIndex');
            	parent.startDt=Ext.getCmp('tripStartDtId').getValue();
            	parent.endDt=Ext.getCmp('tripEndDtId').getValue();
        }
    }
 
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'tripSummaryRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'vehicleNoDataIndex'
        },{
            name: 'tripNoDataIndex'
        },{
            name: 'regionDataIndex'
        },{
            name: 'locationDataIndex'
        },{
            name: 'hubDataIndex'
        },{
            name: 'routeDataIndex'
        },{
            name: 'custodian1DataIndex'
        },{
            name: 'driverDataIndex'
        },{
            name: 'gunMan1DataIndex'
        },{
            name: 'startDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'endDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'startOdoDataIndex'
        },{
            name: 'endOdoDataIndex'
        },{
            name: 'totalHrsDataIndex'
        },{
            name: 'visitedPointsDataIndex'
        },{
            name: 'totalDistanceDataIndex'
        },{
            name: 'totalOdometerDataIndex'
        }]
    });

    var tripSummaryReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripSummaryReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'summaryStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicleNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'tripNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'regionDataIndex'
        },{
            type: 'string',
            dataIndex: 'locationDataIndex'
        },{
            type: 'string',
            dataIndex: 'hubDataIndex'
        },{
            type: 'string',
            dataIndex: 'routeDataIndex'
        },{
            type: 'string',
            dataIndex: 'custodian1DataIndex'
        },{
            type: 'string',
            dataIndex: 'driverDataIndex'
        },{
            type: 'string',
            dataIndex: 'gunMan1DataIndex'
        },{
            type: 'date',
            dataIndex: 'startDateDataIndex'
        }, {
            type: 'date',
            dataIndex: 'endDateDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'startOdoDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'endOdoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'totalHrsDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'visitedPointsDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalDistanceDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalOdometerDataIndex'
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
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicleNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripNo%></span>",
                dataIndex: 'tripNoDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Region%></span>",
                dataIndex: 'regionDataIndex',
                hidden:true,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Location%></span>",
                dataIndex: 'locationDataIndex',
                hidden:true,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Hub%></span>",
                dataIndex: 'hubDataIndex',
                hidden:true,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Route%></span>",
                dataIndex: 'routeDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=CustodianName%></span>",
                dataIndex: 'custodian1DataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=DriverName%></span>",
                dataIndex: 'driverDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Gunman%></span>",
                dataIndex: 'gunMan1DataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripStartDate%></span>",
                dataIndex: 'startDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripEndDate%></span>",
                dataIndex: 'endDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripStartVehODO%></span>",
                dataIndex: 'startOdoDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripEndVehODO%></span>",
                dataIndex: 'endOdoDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalTripHrs%>(HH:MM)</span>",
                dataIndex: 'totalHrsDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VisistedPoints%></span>",
                dataIndex: 'visitedPointsDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalDistance%></span>",
                dataIndex: 'totalDistanceDataIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=TotalKmsByOdometer%></span>",
                dataIndex: 'totalOdometerDataIndex',
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
    
    summaryGrid = getGrid('', '<%=NoRecordsFound%>', tripSummaryReportStore, screen.width - 35, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

	summaryGrid.on({
        "cellclick": {
            fn: onCellClickOnGrid
        }
    });  

    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'<%=TripSummaryReport%>',
        id: 'panelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 10
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo,
            {width:'5px'},
            {
            xtype: 'label',
            text: '<%=TripStartDate%>' + ' :',
            cls: 'labelstyle',
            id: 'tripStartDtLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value:dtprev,
            id: 'tripStartDtId'
        }, {width:'30px'},{
            xtype: 'label',
            text: '<%=TripEndDate%>' + ' :',
            cls: 'labelstyle',
            id: 'tripEndDtLabelId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value:dtcur,
            id: 'tripEndDtId'
        },{width:'30px'},{
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomer%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('tripStartDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('tripStartDtId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('tripEndDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('tripEndDtId').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('tripStartDtId').getValue();
  		                        var enddates = Ext.getCmp('tripEndDtId').getValue();
  		                        
  		                      if (dateCompare(startdates,enddates) == -1) {
                             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                             Ext.getCmp('tripEndDtId').focus();
                             return;
                               }
                                if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('tripEndDtId').focus();
  		                            return;
  		                        }
  		                        tripSummaryReportStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('tripStartDtId').getValue(),
  		                                enddate: Ext.getCmp('tripEndDtId').getValue(),
  		                                custName:Ext.getCmp('custcomboId').getRawValue(),
 		                                jspName:jspName
                                    }
                                });
  		                    }
  		                }
  		            }
  		    }
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
        				if (Ext.getCmp('tripStartDtId').getValue() == "") {
                           Ext.example.msg("<%=SelectStartDate%>");
                           Ext.getCmp('tripStartDtId').focus();
                           return;
                       }
                        if (Ext.getCmp('tripEndDtId').getValue() == "") {
                           Ext.example.msg("<%=SelectEndDate%>");
                           Ext.getCmp('tripEndDtId').focus();
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
        				
        				 parent.Ext.getCmp('tripDetailsId').enable(true);
						
        				if (summaryGrid.getSelectionModel().getCount() == 1) {

            				var selected = summaryGrid.getSelectionModel().getSelected();
            					parent.tripNo= selected.get('tripNoDataIndex');
				            	parent.startDt=Ext.getCmp('tripStartDtId').getValue();
            	                parent.endDt=Ext.getCmp('tripEndDtId').getValue();
            					parent.Ext.getCmp('tripDetailsId').enable();
								parent.Ext.getCmp('tripDetailsId').show();
								parent.Ext.getCmp('tripDetailsId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/CashVanManagement/TripDetailsReport.jsp'></iframe>");
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
    var cm = summaryGrid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,120);
    }
    });
</script>
  	</body>
</html>