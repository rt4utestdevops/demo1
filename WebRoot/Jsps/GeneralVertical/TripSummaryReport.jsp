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

<!DOCTYPE HTML>
<html>
	<head>
		<title>Trip Summary Report</title>		
	</head>	    
  
  	<body onload="" >
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "Trip_Summary_Report";
  	var exportDataType = "int,int,string,string,string,date,date,string,number,date,date,number,string,number,number,string,string";
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
      var vehicleno=selected.get('vehicleNoIndex');
      var startDate=selected.get('startDateDataIndex');
      var endDate=selected.get('endDateDataIndex');
      if(endDate == null ){
        endDate=dtcur;
      }
     var vehicletype=selected.get('vehicleTypeIndex');
     var tripNo=selected.get('tripIdIndex');
     var vehicleNo=selected.get('vehicleNoIndex');
      var Date1 = startDate.format('d/m/Y H:i:s').replace(/\s/g, "%20");
      var Date2 = endDate.format('d/m/Y H:i:s').replace(/\s/g, "%20");
      var vehicleNo = vehicleno.replace(/\s/g, "%20")
      var vehicleType = vehicletype.replace(/\s/g, "%20")
      var myParamfromCross = clientId +"|" + vehicleNo + "|" + vehicleType + "|" + Date1 + "|" + Date2;
      var status = selected.get('tripStatusIndex');
      //openPopWin("/jsps/Activity_jsp/ActivityReport.jsp?myParamfromCross=" + myParamfromCross, 'Activity Report', screen.width * 0.75, screen.height * 0.65);
 	 // window.location.href ="<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo="+tripNo+"&vehicleNo="+vehicleNo+"&startDate="+Date1+"&endDate="+Date2+"&pageId=2&status="+status+"";
 	  window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo="+tripNo+"&vehicleNo="+vehicleNo+"&startDate="+Date1+"&endDate="+Date2+"&pageId=2&status="+status+"" , '_blank');
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
            name: 'vehicleNoIndex'
        },{
            name: 'shipmentIdIndex'
        },{
            name: 'roteNameIndex'
        },{
            name: 'startDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'actualtripStartDateIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'startLocationIndex'
        },{
            name: 'startOdometerIndex'
        },{
            name: 'endDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'actualendDateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'endOdometerIndex'
        },{
            name: 'tripStatusIndex'
        },{
            name: 'plannedDistanceIndex'
        },{
            name: 'actualDistanceIndex'
        },{
            name: 'vehicleTypeIndex'
        }]
    });

    var tripSummaryReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripSummaryReport',
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
            type: 'numeric',
            dataIndex: 'tripIdIndex'
        },{
            type: 'string',
            dataIndex: 'vehicleNoIndex'
        }, {
            type: 'string',
            dataIndex: 'shipmentIdIndex'
        }, {
            type: 'string',
            dataIndex: 'roteNameIndex'
        },{
            type: 'date',
            dataIndex: 'startDateDataIndex'
        },{
            type: 'date',
            dataIndex: 'actualtripStartDateIndex'
        },{
            type: 'string',
            dataIndex: 'startLocationIndex'
        },{
            type: 'numeric',
            dataIndex: 'startOdometerIndex'
        },{
            type: 'date',
            dataIndex: 'endDateDataIndex'
        },{
            type: 'date',
            dataIndex: 'actualendDateDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'endOdometerIndex'
        },{
            type: 'string',
            dataIndex: 'tripStatusIndex'
        }, {
            type: 'numeric',
            dataIndex: 'plannedDistanceIndex'
        }, {
            type: 'numeric',
            dataIndex: 'actualDistanceIndex'
        },{
            type: 'string',
            dataIndex: 'vehicleTypeIndex'
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
                header: "<span style=font-weight:bold;>Trip Id</span>",
                dataIndex: 'tripIdIndex',
                hidden: true,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Vehicle No</span>",
                dataIndex: 'vehicleNoIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Trip Name</span>",
                dataIndex: 'shipmentIdIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Route Name</span>",
                dataIndex: 'roteNameIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=TripStartDateAndTime%></span>",
                dataIndex: 'startDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;>Actual Trip Start Date Time</span>",
                dataIndex: 'actualtripStartDateIndex',
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
            },{
                header: "<span style=font-weight:bold;>Start Odometer</span>",
                dataIndex: 'startOdometerIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=TripEndDateAndTime%></span>",
                dataIndex: 'endDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;>Actual Trip End Date Time</span>",
                dataIndex: 'actualendDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;>End Odometer</span>",
                dataIndex: 'endOdometerIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Status</span>",
                dataIndex: 'tripStatusIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Planned Distance</span>",
                dataIndex: 'plannedDistanceIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Actual Distance</span>",
                dataIndex: 'actualDistanceIndex',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Vehicle Type</span>",
                dataIndex: 'vehicleTypeIndex',
                hidden: true,
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
  	</body>
</html>