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
	tobeConverted.add("Driving_Behaviour_Report");
	tobeConverted.add("Select_client");
	tobeConverted.add("Registration_Number");
	tobeConverted.add("SLNO");
	tobeConverted.add("Driver_Id");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("PickUp_Location");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Trip_Id");		
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Distance_Driven");
	tobeConverted.add("Distance_Driven_Score");
	tobeConverted.add("Driving_Hours");
	tobeConverted.add("Group_Name");
    tobeConverted.add("Driving_Hours_Score");
    tobeConverted.add("OverSpeed_Count");
	tobeConverted.add("OverSpeed_Graded_Count");
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("View");
	tobeConverted.add("OverSpeed_Graded_Count_Score");
	tobeConverted.add("Idle_Time");
	tobeConverted.add("Idle_Time_Score");
	tobeConverted.add("Harsh_Acceleration_Count");
	tobeConverted.add("Harsh_Acceleration_Score");
	tobeConverted.add("Harsh_Breaking_Count");
	tobeConverted.add("Harsh_Breaking_Score");		
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Seat_Belt_Count");
	tobeConverted.add("Seat_Belt_Score");
	tobeConverted.add("Seat_Belt_Distance_Count");
	tobeConverted.add("Seat_Belt_Distance_Count_Score");
	tobeConverted.add("Total_Score");
	tobeConverted.add("Created_By");
	tobeConverted.add("Closed_By");
	tobeConverted.add("OverSpeed_Count_Score");
	tobeConverted.add("Status");
	tobeConverted.add("Harsh_Curve_Count");
	tobeConverted.add("Harsh_Curve_Score");
	tobeConverted.add("OverSpeed_Duration_Hrs");
	tobeConverted.add("OverSpeed_Duration_Score");
	tobeConverted.add("Continious_Driving_Hrs");
	tobeConverted.add("Continious_Driving_Score");

	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	String DriverBehaviourReport = convertedWords.get(0);	
	String SelectClient = convertedWords.get(1);
	String RegistrationNumber = convertedWords.get(2);
	String SlNo = convertedWords.get(3);
	String DriverId = convertedWords.get(4);	
	String NoRecordsFound = convertedWords.get(5);
	String ClearFilterData = convertedWords.get(6);
	String HubName = convertedWords.get(7); 
	String Excel = convertedWords.get(8); 
	String PDF = convertedWords.get(9); 	
	String TripId=convertedWords.get(10);
	String StartDate=convertedWords.get(11); 	
	String EndDate=convertedWords.get(12); 	
	String DistanceDriven=convertedWords.get(13); 	
	String DistanceDrivenScore=convertedWords.get(14); 	
	String DrivingHours=convertedWords.get(15); 	
	String GroupName=convertedWords.get(16); 	
	String DrivingHoursScore=convertedWords.get(17); 	
	String OverSpeedCount=convertedWords.get(18); 	
	String OverSpeedGradedCount=convertedWords.get(19); 	
	String MonthValidation=convertedWords.get(20); 	
	String SelectStartDate=convertedWords.get(21); 	
	String SelectEndDate=convertedWords.get(22); 	
	String View=convertedWords.get(23); 	
    String OverSpeedGradedCountScore=convertedWords.get(24); 	
	String IdleTime=convertedWords.get(25); 	
    String IdleTimeScore=convertedWords.get(26); 	
    String HarshAccelatorCount=convertedWords.get(27); 	
    String HarshAccelatorScore=convertedWords.get(28); 	
    String HarshBreakCount=convertedWords.get(29); 	
    String HarshBreakScore=convertedWords.get(30); 
    String EndDateMustBeGreaterthanStartDate = convertedWords.get(31);
    String SeatBeltCount=convertedWords.get(32);
    String SeatBeltScore=convertedWords.get(33);
    String SeatBeltDistanceCount=convertedWords.get(34);
    String SeatBeltDistanceCountScore=convertedWords.get(35);
    String TotalScore=convertedWords.get(36);
    String CreatedBy=convertedWords.get(37);
    String ClosedBy=convertedWords.get(38);
    String OverSpeedCountScore=convertedWords.get(39);
    String Status=convertedWords.get(40); 
	String HarshCurveCount = convertedWords.get(41);
	String HarshCurveScore = convertedWords.get(42);
	String OverSpeedDurationCount = convertedWords.get(43);
	String OverSpeedDurationScore = convertedWords.get(44);
	String ContiniousDrivingCount = convertedWords.get(45);
	String ContiniousDrivingScore = convertedWords.get(46);
         
%>

<jsp:include page="../Common/header.jsp" />
		<title><%=DriverBehaviourReport%></title>		
	
  	<style>
  	.col{
			color:#0B0B61;
			font-family: sans-serif;
			font-size:14px;
			width: 400;
		}
  	.green-row .x-grid3-cell-inner{
		background-color:lightgreen;
		font-style: italic;
		color:black;
	}
	.red-row .x-grid3-cell-inner{
		background-color:#E55B3C;
		font-style: italic;
		color:black;
	}
	.yellow-row .x-grid3-cell-inner{
		background-color:#FDD017;
		font-style: italic;
		color:black;
	}

    </style>
  	
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
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
			.x-menu-list {
				height:auto !important;
			}
		</style>
	<%}%>
  
   	<script>
   	var jspName = "DriverBehaviourReport";
  	var exportDataType = "int,string,string,string,string,string,string,string,number,number,string,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,string,string,string";
    var outerPanel;
    var ctsb;
    var Grid;
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
                    Ext.getCmp('clientId').setValue('<%=customerId%>');
                    
                    custId = Ext.getCmp('clientId').getValue();
                    custName = Ext.getCmp('clientId').getRawValue();
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
                fn: function () {
                    custId = Ext.getCmp('clientId').getValue();
                    custName = Ext.getCmp('clientId').getRawValue();
                }
            }
        }
    });

    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'tripDetailRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNODI'
        },{
            name: 'registrationNoDI'
        },{
        	name: 'groupNameDI'
        },{
            name: 'driverIdDI'
        },{
            name: 'hubIdDI'
        },{
            name: 'startDateDI',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'endDateDI',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'tripIdDI'
        },{
            name: 'distanceDrivenDI'
        },{
            name: 'distanceDrivenScoreDI'
        },{
            name: 'drivingHrsDI'
        },{
            name: 'drivingHrsScore'
        },{
            name: 'overSpeedCountDI'
        },{
            name: 'overSpeedCountScoreDI'
        },{
            name: 'overSpeedGradedCountDI'
        },{
            name: 'overSpeedGradedCountScoreDI'
        },{
            name: 'idleTimeDI'
        },{
            name: 'idleTimeScoreDI'
        },{
            name: 'harshAccCountDI'
        },{
            name: 'harshAccScoreDI'
        },{
            name: 'harshBrkCountDI'
        },{
            name: 'harshBrkScoreDI'
        },{
        	name: 'harshCurveCountDI'
        },{
        	name: 'harshCurveScoreDI'
        },{
            name: 'seatBeltCountDI'
        },{
            name: 'seatBeltScoreDI'
        },{
            name: 'seatBeltDistanceCountDI'
        },{
            name: 'seatBeltDistanceCountScoreDI'
        },{
            name: 'totalScoreDI'
        },{
            name: 'createdByDI'
        },{
            name: 'closedByDI'
        },{
        	name: 'overSpeedDurationCountDI'
        },{
        	name: 'overSpeedDurationScoreDI'
        },{
        	name: 'continiousDrivingCountDI'
        },{
        	name: 'continiousDrivingScoreDI'
        },{
        	name: 'statusDI'
        }]
    });

    var tripDetailReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/DriverTripDetailsAction.do?param=getTripDetailsReport',
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
            dataIndex: 'SLNODI'
        }, {
            type: 'string',
            dataIndex: 'registrationNoDI'
        },{
            type: 'string',
            dataIndex: 'groupNameDI'
        }, {
            type: 'string',
            dataIndex: 'driverIdDI'
        }, {
            type: 'string',
            dataIndex: 'hubIdDI'
        },{
            type: 'date',
            dataIndex: 'startDateDI'
        },{
            type: 'date',
            dataIndex: 'endDateDI'
        },{
            type: 'string',
            dataIndex: 'tripIdDI'
        },{
            type: 'numeric',
            dataIndex: 'distanceDrivenDI'
        },{
            type: 'numeric',
            dataIndex: 'distanceDrivenScoreDI'
        },{
            type: 'string',
            dataIndex: 'drivingHrsDI'
        }, {
            type: 'numeric',
            dataIndex: 'drivingHrsScore'
        }, {
            type: 'numeric',
            dataIndex: 'overSpeedCountDI'
        }, {
            type: 'numeric',
            dataIndex: 'overSpeedCountScoreDI'
        }, {
            type: 'numeric',
            dataIndex: 'overSpeedGradedCountDI'
        }, {
            type: 'numeric',
            dataIndex: 'overSpeedGradedCountScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'idleTimeDI'
        },{
            type: 'numeric',
            dataIndex: 'idleTimeScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'harshAccCountDI'
        },{
            type: 'numeric',
            dataIndex: 'harshAccScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'harshBrkCountDI'
        },{
            type: 'numeric',
            dataIndex: 'harshBrkScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'harshCurveCountDI'
        },{
            type: 'numeric',
            dataIndex: 'harshCurveScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'seatBeltCountDI'
        },{
            type: 'numeric',
            dataIndex: 'seatBeltScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'seatBeltDistanceCountDI'
        },{
            type: 'numeric',
            dataIndex: 'seatBeltDistanceCountScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'totalScoreDI'
        },{
            type: 'string',
            dataIndex: 'createdByDI'
        },{
            type: 'string',
            dataIndex: 'closedByDI'
        },{
            type: 'numeric',
            dataIndex: 'overSpeedDurationCountDI'
        },{
            type: 'numeric',
            dataIndex: 'overSpeedDurationScoreDI'
        },{
            type: 'numeric',
            dataIndex: 'continiousDrivingCountDI'
        },{
            type: 'numeric',
            dataIndex: 'continiousDrivingScoreDI'
        },{
        	type: 'string',
        	dataIndex: 'statusDI'
        }]
    });

    //************************************Column Model Config******************************************
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SlNo%></span>",
           width: 50
       }), {
           dataIndex: 'SLNODI',
           hidden: true,
           header: "<span style=font-weight:bold;><%=SlNo%></span>",
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=RegistrationNumber%></span>",
           dataIndex: 'registrationNoDI',
           filter: {
               type: 'string'
           }
       }, {
           header: "<span style=font-weight:bold;><%=GroupName%></span>",
           dataIndex: 'groupNameDI',
           filter: {
               type: 'string'
           }
       }, {
           header: "<span style=font-weight:bold;><%=DriverId%></span>",
           dataIndex: 'driverIdDI',
           hidden: true,
           hideable: false,
           filter: {
               type: 'string'
           }
       },{
           header: "<span style=font-weight:bold;><%=HubName%></span>",
           dataIndex: 'hubIdDI',
           filter: {
               type: 'string'
           }
       },{
           header: "<span style=font-weight:bold;><%=TripId%></span>",
           dataIndex: 'tripIdDI',
           filter: {
               type: 'string'
           }
       },{
           header: "<span style=font-weight:bold;><%=StartDate%></span>",
           dataIndex: 'startDateDI',
           renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
           filter: {
               type: 'date'
           }
       },{
           header: "<span style=font-weight:bold;><%=EndDate%></span>",
           dataIndex: 'endDateDI',
           renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
           filter: {
               type: 'date'
           }
       },{
           header: "<span style=font-weight:bold;><%=DistanceDriven%>(Kms)</span>",
           dataIndex: 'distanceDrivenDI',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;><%=DistanceDrivenScore%></span>",
           dataIndex: 'distanceDrivenScoreDI',
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=DrivingHours%></span>",
           dataIndex: 'drivingHrsDI',
           hidden: true,
           hideable: false,
           filter: {
               type: 'string'
           }
       }, {
           header: "<span style=font-weight:bold;><%=DrivingHoursScore%></span>",
           dataIndex: 'drivingHrsScore',
           hidden: true,
           hideable: false,
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=OverSpeedCount%></span>",
           dataIndex: 'overSpeedCountDI',
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=OverSpeedCountScore%></span>",
           dataIndex: 'overSpeedCountScoreDI',
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=OverSpeedGradedCount%></span>",
           dataIndex: 'overSpeedGradedCountDI',
           hidden: true,
           hideable: false,
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=OverSpeedGradedCountScore%></span>",
           dataIndex: 'overSpeedGradedCountScoreDI',
           hidden: true,
           hideable: false,
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=OverSpeedDurationCount%>(MM.SS)</span>",
           dataIndex: 'overSpeedDurationCountDI',
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=OverSpeedDurationScore%></span>",
           dataIndex: 'overSpeedDurationScoreDI',
           filter: {
               type: 'numeric'
           }
       }, {
           header: "<span style=font-weight:bold;><%=IdleTime%></span>",
           dataIndex: 'idleTimeDI',
           hidden: true,
           hideable: false,
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;><%=IdleTimeScore%></span>",
            dataIndex: 'idleTimeScoreDI',
            hidden: true,
            hideable: false,
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=HarshAccelatorCount%></span>",
            dataIndex: 'harshAccCountDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=HarshAccelatorScore%></span>",
            dataIndex: 'harshAccScoreDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=HarshBreakCount%></span>",
            dataIndex: 'harshBrkCountDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=HarshBreakScore%></span>",
            dataIndex: 'harshBrkScoreDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=HarshCurveCount%></span>",
            dataIndex: 'harshCurveCountDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=HarshCurveScore%></span>",
            dataIndex: 'harshCurveScoreDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=SeatBeltCount%></span>",
            dataIndex: 'seatBeltCountDI',
            hidden: true,
            hideable: false,
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=SeatBeltScore%></span>",
            dataIndex: 'seatBeltScoreDI',
            hidden: true,
            hideable: false,
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=SeatBeltDistanceCount%></span>",
            dataIndex: 'seatBeltDistanceCountDI',
            hidden: true,
            hideable: false,
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=SeatBeltDistanceCountScore%></span>",
            dataIndex: 'seatBeltDistanceCountScoreDI',
            hidden: true,
            hideable: false,
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=ContiniousDrivingCount%>(HH.MM)</span>",
            dataIndex: 'continiousDrivingCountDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=ContiniousDrivingScore%></span>",
            dataIndex: 'continiousDrivingScoreDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=TotalScore%></span>",
            dataIndex: 'totalScoreDI',
            filter: {
                type: 'numeric'
            }
        },{
           header: "<span style=font-weight:bold;><%=Status%></span>",
           dataIndex: 'statusDI',
           filter: {
               type: 'string'
           }
       },{
           header: "<span style=font-weight:bold;><%=CreatedBy%></span>",
           dataIndex: 'createdByDI',
           filter: {
               type: 'string'
           }
       },{
           header: "<span style=font-weight:bold;><%=ClosedBy%></span>",
           dataIndex: 'closedByDI',
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
    
Grid = getGrid('', '<%=NoRecordsFound%>', tripDetailReportStore, screen.width - 20, 365, 37, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '<%=PDF%>');

Grid.getView().getRowClass = function(record, index){
 	     var score=record.data.totalScoreDI;
 	     if(parseInt(score)<2){
 	    	rowcolour='green-row';
 	     }
 	     else if(parseInt(score)>=2 && parseInt(score)<5){
 	    	rowcolour='yellow-row';
 	     }
 	     
 	     else if(parseInt(score)>=5 ){
 	    	rowcolour='red-row';
 	     }
 	     	
 	     return rowcolour
};

var Panel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'panelId',
    layout: 'table',
    frame: true,
    layoutConfig: {
        columns: 10
    },
    items:[{
            xtype: 'label',
            text: '<%=SelectClient%>' + ' :',
            cls: 'labelstyle',
            id: 'client'
        },
        clientCombo,
        {width:30},
        {
        xtype: 'label',
        text: '<%=StartDate%>' + ' :',
        cls: 'labelstyle',
        id: 'startDate'
    }, {
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        format: getDateTimeFormat(),
        value:dtprev,
        id: 'startDateId'
    }, {width:30},{
        xtype: 'label',
        text: '<%=EndDate%>' + ' :',
        cls: 'labelstyle',
        id: 'endDate'
    },{
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        format: getDateTimeFormat(),
        value:dtcur,
        id: 'endDateId'
    },{width:30},{
        xtype: 'button',
        text: '<%=View%>',
        id: 'addbuttonid',
        cls: ' ',
        width: 80,
        listeners: {
                click: {
                    fn: function () {
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
                      
                    if (dateCompare(startdates,enddates) == -1) {
                       Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                       Ext.getCmp('endDateId').focus();
                       return;
                         }
                          if (checkMonthValidation(startdates, enddates)) {
                          Ext.example.msg("<%=MonthValidation%>");
                            Ext.getCmp('endDateId').focus();
                            return;
                        }
                        tripDetailReportStore.load({
                                params: {
                                	ClientId: Ext.getCmp('clientId').getValue(),
                                	startDate: Ext.getCmp('startDateId').getValue(),
                                	endDate: Ext.getCmp('endDateId').getValue(),
                                	custName:Ext.getCmp('clientId').getRawValue(),
                               		jspName:jspName
                                }
                            });
                    }
                }
            }
    }
    ]
}); // End of Panel	

var MessagePanel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		autoScroll:false,
		collapsible:false,
		width:'100%',
		id:'notePanelOneId',
		layout:'table',
		layoutConfig: {
			columns:1
		},
		items: [{
					html:'<div style="color:black;font-size:12px;margin:10px 0px 5px 0px;">**The Result is based on GMT time</b></div>'
    			},
    			{
    				html: '<div class=col> <img src="<%=request.getContextPath()%>/Main/images/Drlegend_green.png" width="35px" height="15px"/>Total Score is less than 2</div>'
    			},
    			{
    				html: '<div class=col> <img src="<%=request.getContextPath()%>/Main/images/Drlegend_yellow.png" width="35px" height="15px" />Total Score is in the range 2 to 5</div>'
    			},
    			{
    				html: '<div class=col> <img src="<%=request.getContextPath()%>/Main/images/Drlegend_red.png" width="35px" height="15px" />Total Score is more than 5</div>'
    			}	]			    
	});	
		
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        title: '<%=DriverBehaviourReport%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Panel, Grid,MessagePanel]
	});
    var cm = Grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,155);
    }
    });
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->