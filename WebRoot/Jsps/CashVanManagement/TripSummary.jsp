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
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
    tobeConverted.add("Trip_No");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("View");
    
	tobeConverted.add("Driver_Name");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	
	tobeConverted.add("Trip_Start_Date_Time");
	tobeConverted.add("Trip_End_Date_Time");
	tobeConverted.add("Trip_Name");
    tobeConverted.add("Start_Location");
    tobeConverted.add("End_Location");
    tobeConverted.add("Trip_Status");
    
    tobeConverted.add("Distance_Travelled");
	tobeConverted.add("Trip_Id");
	tobeConverted.add("Single_Trip");
    tobeConverted.add("Total_Trip_Duration");
    tobeConverted.add("Driving_Time");
    tobeConverted.add("Top_Speed");
    tobeConverted.add("Assignment");
    tobeConverted.add("Total_Authorize_Halt_Time");
    tobeConverted.add("Total_Unauthorize_Halt_Time");
    
    
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String TripSummaryReport = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	
	String SlNo = convertedWords.get(3);
	String Next = convertedWords.get(4);	
	String NoRecordsFound = convertedWords.get(5);
	String ClearFilterData = convertedWords.get(6);
	String Excel = convertedWords.get(7); 
	String PDF = convertedWords.get(8); 	

	String TripNo=convertedWords.get(9); 	
	String VehicleNo=convertedWords.get(10); 	
	String MonthValidation=convertedWords.get(11); 	
	String SelectStartDate=convertedWords.get(12); 	
	String SelectEndDate=convertedWords.get(13); 	
	String View=convertedWords.get(14); 	
	
    String DriverName=convertedWords.get(15); 	
    String EndDateMustBeGreaterthanStartDate = convertedWords.get(16);	
    
    
    String TripStartDateAndTime=convertedWords.get(17);
    String TripEndDateAndTime=convertedWords.get(18);
    
    String TripName=convertedWords.get(19);
    String startLocation=convertedWords.get(20);
    String endLocation=convertedWords.get(21);
    String tripStatus=convertedWords.get(22);
    
    String totalDistanceTraveled=convertedWords.get(23);
    String TripId=convertedWords.get(24);
    String SingleOrReturnTrip=convertedWords.get(25);
    String timeTakenToCompleteTrip=convertedWords.get(26);
    String drivingTime=convertedWords.get(27);
    String topSpeed=convertedWords.get(28);
    String Assignement=convertedWords.get(29);
    String totalAuthorizeHaltTime=convertedWords.get(30);
    String totalUnauthorizeHaltTime=convertedWords.get(31);
    
	String avgDistancePerHr="Avg. Distance/Hr"; 
	String avgDrivingPerHr="Avg. Driving/Hr";  
	
	
%>

<jsp:include page="../Common/header.jsp" />
		<title>Trip Summary Report</title>		
	   
  
<!--  	<body onload="" >  -->
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
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
		</style>
   	<script>
   	var jspName = "Trip_Summary_Report";
  	var exportDataType = "int,string,string,string,string,string,string,date,string,date,string,string,number,number,number,number,number,number,number,string,number";
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
    function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      if (summaryGrid.getSelectionModel().getCount() == 0) {
          Ext.example.msg("NoRowsSelected");
          return;
      }
      if (summaryGrid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("SelectSingleRow");
          return;
      }
      var selected = summaryGrid.getSelectionModel().getSelected();
      var clientId=Ext.getCmp('custcomboId').getValue();
      var vehicleno=selected.get('vehicalNoIndex');
      var startDate=selected.get('startDateDataIndex');
      var endDate=selected.get('endDateDataIndex');
      if(endDate == null ){
        endDate=dtcur;
      }
      var vehicletype=selected.get('vehicleTypeIndex');
      var Date1 = startDate.format('d/m/Y H:i:s').replace(/\s/g, "%20");
      var Date2 = endDate.format('d/m/Y H:i:s').replace(/\s/g, "%20");
      var vehicleNo = vehicleno.replace(/\s/g, "%20")
      var vehicleType = vehicletype.replace(/\s/g, "%20")
      var myParamfromCross = clientId +"|" + vehicleNo + "|" + vehicleType + "|" + Date1 + "|" + Date2;
      
      openPopWin("/jsps/Activity_jsp/ActivityReport.jsp?myParamfromCross=" + myParamfromCross, 'Activity Report', screen.width * 0.75, screen.height * 0.65);
 }
 
 function openPopWin(url, title, width, height) {
    popWin = new Ext.Window({
        title: title,
        autoShow: false,
        constrain: false,
        constrainHeader: false,
        resizable: false,
        maximizable: true,
        minimizable: true,
        width: width,
        height: height,
        closable: true,
        stateful: false,
        html: "<iframe style='width:100%;height:100%' src=" + url + "></iframe>",
        scripts: true,
        shim: false
    });
    popWin.show();
}
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'tripSummaryRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'tripIdIndex'
        },{
            name: 'tripNameIndex'
        },{
            name: 'AssignementIndex'
        },{
            name: 'SingleOrReturnTripIndex'
        },{
            name: 'vehicalNoIndex'
        },{
            name: 'driverNameIndex'
        },{
            name: 'startDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'startLocationIndex'
        },{
            name: 'endDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'endLocationIndex'
        },{
            name: 'tripStatusIndex'
        },{
            name: 'timeTakenToCompleteTripIndex'
        },{
            name: 'totalAuthorizeHaltTimeIndex'
        },{
            name: 'totalUnauthorizeHaltTimeIndex'
        },{
            name: 'totalDistanceTraveledIndex'
        },{
            name: 'drivingTimeIndex'
        },{
            name: 'avgDistancePerHrIndex'
        },{
            name: 'avgDrivingPerHrIndex'
        },{
            name: 'vehicleTypeIndex'
        },{
            name: 'topSpeedIndex'
        }]
    });

    var tripSummaryReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripSummaryReportNew',
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
            dataIndex: 'tripIdIndex'
        }, {
            type: 'string',
            dataIndex: 'tripNameIndex'
        }, {
            type: 'string',
            dataIndex: 'AssignementIndex'
        },{
            type: 'string',
            dataIndex: 'SingleOrReturnTripIndex'
        },{
            type: 'string',
            dataIndex: 'vehicalNoIndex'
        },{
            type: 'string',
            dataIndex: 'driverNameIndex'
        },{
            type: 'date',
            dataIndex: 'startDateDataIndex'
        },{
            type: 'string',
            dataIndex: 'startLocationIndex'
        },{
            type: 'date',
            dataIndex: 'endDateDataIndex'
        },{
            type: 'string',
            dataIndex: 'endLocationIndex'
        },{
            type: 'string',
            dataIndex: 'tripStatusIndex'
        }, {
            type: 'numeric',
            dataIndex: 'timeTakenToCompleteTripIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalAuthorizeHaltTimeIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalUnauthorizeHaltTimeIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalDistanceTraveledIndex'
        },{
            type: 'numeric',
            dataIndex: 'drivingTimeIndex'
        },{
            type: 'numeric',
            dataIndex: 'avgDistancePerHrIndex'
        },{
            type: 'numeric',
            dataIndex: 'avgDrivingPerHrIndex'
        },{
            type: 'string',
            dataIndex: 'vehicleTypeIndex'
        },{
            type: 'numeric',
            dataIndex: 'topSpeedIndex'
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
                header: "<span style=font-weight:bold;><%=TripId%></span>",
                dataIndex: 'tripIdIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripName%></span>",
                dataIndex: 'tripNameIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Assignement%></span>",
                dataIndex: 'AssignementIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=SingleOrReturnTrip%></span>",
                dataIndex: 'SingleOrReturnTripIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicalNoIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=DriverName%></span>",
                dataIndex: 'driverNameIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripStartDateAndTime%></span>",
                dataIndex: 'startDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;><%=startLocation%></span>",
                dataIndex: 'startLocationIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripEndDateAndTime%></span>",
                dataIndex: 'endDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;><%=endLocation%></span>",
                dataIndex: 'endLocationIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=tripStatus%></span>",
                dataIndex: 'tripStatusIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=timeTakenToCompleteTrip%> (HH.MM)</span>",
                dataIndex: 'timeTakenToCompleteTripIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=totalAuthorizeHaltTime%> (HH.MM)</span>",
                dataIndex: 'totalAuthorizeHaltTimeIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=totalUnauthorizeHaltTime%> (HH.MM)</span>",
                dataIndex: 'totalUnauthorizeHaltTimeIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=totalDistanceTraveled%></span>",
                dataIndex: 'totalDistanceTraveledIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=drivingTime%> (HH.MM)</span>",
                dataIndex: 'drivingTimeIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=avgDistancePerHr%></span>",
                dataIndex: 'avgDistancePerHrIndex',
                hidden:true,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=avgDrivingPerHr%></span>",
                dataIndex: 'avgDrivingPerHrIndex',
                hidden:true,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Vehicle Type</span>",
                dataIndex: 'vehicleTypeIndex',
                hidden:true,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=topSpeed%></span>",
                dataIndex: 'topSpeedIndex',
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
    
    summaryGrid = getGrid('', '<%=NoRecordsFound%>', tripSummaryReportStore, screen.width - 35, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>',true, 'Trip Details', false, '');

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
            {width:'30px'},
            {
            xtype: 'label',
            text:  '<%=SelectStartDate%>'+ ' :',
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
            text: '<%=SelectEndDate%>' + ' :',
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
    		  items: [innerPanel, summaryGrid]  
            //bbar: ctsb
        });
    var cm = summaryGrid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,120);
    }
    });
</script>
  	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->