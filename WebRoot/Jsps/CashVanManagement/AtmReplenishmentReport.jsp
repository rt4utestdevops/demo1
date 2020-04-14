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
		<title>Atm Replenishment Report</title>		
	</head>	    
  
  	<body>
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "Atm Replenishment Report";
  	var exportDataType = "int,string,date,string,string,string,string,string,string,string,string,number";
    var outerPanel;
    var ctsb;
    var summaryGrid;
    var custId;
    var custName;
    var dtprev = dateprev;
    var dtcur = datecur;


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
                    
                    crewcombostore.load({params:{custId:custId}});
                    VehicleComboStore.load({params:{custId:custId}});
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
                    
                    crewcombostore.load({params:{custId:custId}});
                    VehicleComboStore.load({params:{custId:custId}});
                    
                }
            }
        }
    });
   
    var crewcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CashVanReportAction.do?param=getCrewDetails',
        id: 'CrewStoreId',
        root: 'CrewRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['CrewId', 'CrewName']
    });
   
   var Crewcombo = new Ext.form.ComboBox({
    store: crewcombostore,
    id: 'CrewcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select Crew',
    blankText: 'Select Crew',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'CrewId',
    displayField: 'CrewName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            }
        }
    }
  });

	var VehicleComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CashVanReportAction.do?param=getVehicleDetails',
        id: 'VehicleComboStoreId',
        root: 'VehicleStoreRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['VehicleNo']
    });
   
   var VehicleCombo = new Ext.form.ComboBox({
    store: VehicleComboStore,
    id: 'VehicleComboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select Vehicle',
    blankText: 'Select Vehicle',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'VehicleNo',
    displayField: 'VehicleNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            }
        }
    }
  });
  
  var AtmNocombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CashVanReportAction.do?param=getAtmNo',
        id: 'AtmNoStoreId',
        root: 'AtmNoRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['AtmId', 'AtmNo']
    });
   
   var AtmNocombo = new Ext.form.ComboBox({
    store: AtmNocombostore,
    id: 'AtmNocomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select ATM No.',
    blankText: 'Select ATM No.',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'AtmId',
    displayField: 'AtmNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            }
        }
    }
  });
    
   var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'',
        id: 'panelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 12
        },
        items: [
            {
                xtype: 'label',
                text: 'Crew Name' + ' :',
                cls: 'labelstyle',
                id: 'CrewlabId'
            },
            Crewcombo,
            {width:'30px'},
             {
                xtype: 'label',
                text: 'Vehicle Number' + ' :',
                cls: 'labelstyle',
                id: 'VehiclelabId'
            },
            VehicleCombo,
            {width:'30px'},
            {
                xtype: 'label',
                text: 'ATM No' + ' :',
                cls: 'labelstyle',
                id: 'atmNolab'
            },
            AtmNocombo,
            {width:'30px'},
            {
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo,
            {width:'30px'},
            {
            xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle',
            id: 'StartDtLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value:dtprev,
            id: 'StartDtId'
        }, {width:'30px'},{
            xtype: 'label',
            text: 'End Date' + ' :',
            cls: 'labelstyle',
            id: 'EndDtLabelId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value:dtcur,
            id: 'EndDtId'
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
  		                  /*      if (Ext.getCmp('CrewcomboId').getValue() == "") {
  		                            Ext.example.msg("Select Crew");
  		                            Ext.getCmp('CrewcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('VehicleComboId').getValue() == "") {
  		                            Ext.example.msg("Select Vehicle");
  		                            Ext.getCmp('VehicleComboId').focus();
  		                            return;
  		                        }  */
  		                        if (Ext.getCmp('StartDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('StartDtId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('EndDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('StartDtId').getValue();
  		                        var enddates = Ext.getCmp('EndDtId').getValue();
  		                        
  		                      if (dateCompare(startdates,enddates) == -1) {
                             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                             Ext.getCmp('EndDtId').focus();
                             return;
                               }
                                if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        SummaryReportStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('StartDtId').getValue(),
  		                                enddate: Ext.getCmp('EndDtId').getValue(),
  		                                custName:Ext.getCmp('custcomboId').getRawValue(),
  		                                crewId:Ext.getCmp('CrewcomboId').getValue(),
  		                                vehicleNo:Ext.getCmp('VehicleComboId').getValue(),
  		                                atmNo:Ext.getCmp('AtmNocomboId').getValue(),
 		                                jspName:jspName
                                    }
                                });  
  		                    }
  		                }
  		            }
  		    },{width:30},
  		    {
		        xtype: 'button',
		        text: 'Reset',
		        id: 'ResButtId',
		        cls: 'buttonstyle',
		        //iconCls : 'cancelbutton',
		        width: '80',
		        listeners: {
		      
		            click: {
		                fn: function () {
						                Ext.getCmp('CrewcomboId').reset();
										Ext.getCmp('VehicleComboId').reset();
		                                Ext.getCmp('AtmNocomboId').reset();
		                }
		            }
		        }
		    }
        ]
    }); // End of Panel	 
    
    
    
    
    
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'AtmReplenishmentSummaryRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'AtmDetailsDataIndex'
        },{
            name: 'DateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'vehicleNoDataIndex'
        },{
            name: 'driverDataIndex'
        },{
            name: 'custodian1DataIndex'
        },{
            name: 'custodian2DataIndex'
        },{
            name: 'tripNoDataIndex'
        },{
            name: 'numberOfPoiDataIndex'
        },{
            name: 'businessNameDataIndex'
        },{
            name: 'locationDataIndex'
        },{
            name: 'totalDataIndex'
        }]
    });

    var SummaryReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CashVanReportAction.do?param=getAtmReplenishmentReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'AtmsummaryStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'AtmDetailsDataIndex'
        }, {
            type: 'date',
            dataIndex: 'DateDataIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicleNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'driverDataIndex'
        }, {
            type: 'string',
            dataIndex: 'custodian1DataIndex'
        }, {
            type: 'string',
            dataIndex: 'custodian2DataIndex'
        }, {
            type: 'string',
            dataIndex: 'tripNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'numberOfPoiDataIndex'
        }, {
            type: 'string',
            dataIndex: 'businessNameDataIndex'
        }, {
            type: 'string',
            dataIndex: 'locationDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalDataIndex'
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
                header: "<span style=font-weight:bold;>ATM Details</span>",
                dataIndex: 'AtmDetailsDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Date</span>",
                dataIndex: 'DateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicleNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=DriverName%></span>",
                dataIndex: 'driverDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=CustodianName%> 1</span>",
                dataIndex: 'custodian1DataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=CustodianName%> 2</span>",
                dataIndex: 'custodian2DataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Trip Number</span>",
                dataIndex: 'tripNoDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Number of POI's </span>",
                dataIndex: 'numberOfPoiDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Business Name</span>",
                dataIndex: 'businessNameDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Location%></span>",
                dataIndex: 'locationDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Total</span>",
                dataIndex: 'totalDataIndex',
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
    
   summaryGrid = getGrid('', '<%=NoRecordsFound%>', SummaryReportStore, screen.width - 40, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>'); 
    
    Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

        outerPanel = new Ext.Panel({
        	title:'ATM Replenishment Report',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            height: 520,
            width:screen.width-24,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [innerPanel, summaryGrid]
            //bbar: ctsb
        });
        if(<%=customerId%> > 0)
    {
    Ext.getCmp('custnamelab').hide();
    Ext.getCmp('custcomboId').hide();
    }
    var cm = summaryGrid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,120);
    }
    });
</script>
</body>
</html>