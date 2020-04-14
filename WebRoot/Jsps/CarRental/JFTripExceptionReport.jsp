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
	tobeConverted.add("Trip_Exception_Report");
	tobeConverted.add("Select_client");
	tobeConverted.add("RA_ID");
	tobeConverted.add("SLNO");
	tobeConverted.add("Booking_No");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Duty_Type");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Asset_No");		
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Driver_Mobile_No");
	tobeConverted.add("Scheduled_Pickup_Time");
	tobeConverted.add("G2G_GPS_Kms");
    tobeConverted.add("G2G_ODO_Kms");
    tobeConverted.add("G2G_Distance_Difference");
	tobeConverted.add("P2P_GPS_Kms");
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("View");
	tobeConverted.add("P2P_ODO_Kms");
	tobeConverted.add("P2P_Kms_Difference");
	tobeConverted.add("Exception_Remarks");
	tobeConverted.add("G2G_Time");
	tobeConverted.add("P2P_Time");
	tobeConverted.add("Vehicle_Status");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Status");
	tobeConverted.add("G2G_Google_Distance");
	tobeConverted.add("G2G_Google_Time");
	tobeConverted.add("P2P_Google_Distance");
	tobeConverted.add("P2P_Google_Time");

	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	String TripExceptionReport = convertedWords.get(0);	
	String SelectClient = convertedWords.get(1);
	String Raid = convertedWords.get(2);
	String SlNo = convertedWords.get(3);
	String BookingNo = convertedWords.get(4);	
	String NoRecordsFound = convertedWords.get(5);
	String ClearFilterData = convertedWords.get(6);
	String DutyType = convertedWords.get(7); 
	String Excel = convertedWords.get(8); 
	String PDF = convertedWords.get(9); 	
	String VehicleRegNo=convertedWords.get(10);
	String StartDate=convertedWords.get(11); 	
	String EndDate=convertedWords.get(12); 	
	String DriverName=convertedWords.get(13); 	
	String DriverMobNo=convertedWords.get(14); 	
	String scheduledPickupTime=convertedWords.get(15); 	
	String G2GGPSKms=convertedWords.get(16); 	
	String G2GOdoKms=convertedWords.get(17); 	
	String G2GDistDifference=convertedWords.get(18); 	
	String P2PGPSKms=convertedWords.get(19); 	
	String MonthValidation=convertedWords.get(20); 	
	String SelectStartDate=convertedWords.get(21); 	
	String SelectEndDate=convertedWords.get(22); 	
	String View=convertedWords.get(23); 	
    String P2POdoKms=convertedWords.get(24); 	
	String P2PKmsDifference=convertedWords.get(25); 	
    String ExceptionRemarks=convertedWords.get(26); 	
    String G2GTime=convertedWords.get(27); 	
    String P2PTime=convertedWords.get(28); 	
    String VehicleStatus=convertedWords.get(29); 	
    String EndDateMustBeGreaterthanStartDate = convertedWords.get(30);
    String Status=convertedWords.get(31); 
    String G2GGoogleDistance = convertedWords.get(32);
    String G2GGoogleTime = convertedWords.get(33); 
    String P2PGoogleDistance = convertedWords.get(34); 
    String P2PGoogleTime = convertedWords.get(35);  
    
%>

<jsp:include page="../Common/header.jsp" />
		<title><%=TripExceptionReport%></title>		
  
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
   	var jspName = "JetFleetTripExceptionReport";
  	var exportDataType = "int,int,string,string,string,string,string,string,number,number,number,string,number,number,number,string,string,string,number,string,number,string";
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
        root: 'tripExceptionReportRoot',
        totalProperty: 'total',
        fields: [{
            name: 'raidDI'
        },{
            name: 'bookingNoDI'
        },{
        	name: 'dutyTypeDI'
        },{
            name: 'vehicleRegNoDI'
        },{
            name: 'driverNameDI'
        },{
            name: 'driverMobNoDI'
        },{
            name: 'pickUpTimeDI',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'StatusDI'
        },{
            name: 'g2gGpsKmsDI'
        },{
            name: 'g2gOdoKmsDI'
        },{
            name: 'g2gDistDiffDI'
        },{
            name: 'g2gTimeDI'
        },{
            name: 'p2pGpsKmsDI'
        },{
            name: 'p2pOdoKms'
        },{
            name: 'p2pKmsDiffDI'
        },{
            name: 'p2pTimeDI'
        },{
            name: 'excpetionRemarksDI'
        },{
        	name: 'vehicleStatusDI'
        },{
        	name: 'g2GGoogleDistanceDI'
        },{
        	name: 'g2GGoogleTimeDI'
        },{
        	name: 'p2PGoogleDistanceDI'
        },{
        	name: 'p2PGoogleTimeDI'
        }]
    });

    var tripExceptionReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/jfTripExceptionReportAction.do?param=getTripExceptionReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'reportStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'raidDI'
        }, {
            type: 'numeric',
            dataIndex: 'bookingNoDI'
        },{
            type: 'string',
            dataIndex: 'dutyTypeDI'
        }, {
            type: 'string',
            dataIndex: 'vehicleRegNoDI'
        }, {
            type: 'string',
            dataIndex: 'driverNameDI'
        },{
            type: 'string',
            dataIndex: 'driverMobNoDI'
        },{
            type: 'date',
            dataIndex: 'pickUpTimeDI'
        },{
            type: 'string',
            dataIndex: 'StatusDI'
        },{
            type: 'numeric',
            dataIndex: 'g2gGpsKmsDI'
        },{
            type: 'numeric',
            dataIndex: 'g2gOdoKmsDI'
        },{
            type: 'numeric',
            dataIndex: 'g2gDistDiffDI'
        },{
            type: 'string',
            dataIndex: 'g2gTimeDI'
        },{
            type: 'numeric',
            dataIndex: 'p2pGpsKmsDI'
        }, {
            type: 'numeric',
            dataIndex: 'p2pOdoKms'
        }, {
            type: 'numeric',
            dataIndex: 'p2pKmsDiffDI'
        },{
            type: 'string',
            dataIndex: 'p2pTimeDI'
        },{
            type: 'string',
            dataIndex: 'excpetionRemarksDI'
        },{
        	type: 'string',
        	dataIndex: 'vehicleStatusDI'
        },{
        	type: 'numeric',
        	dataIndex: 'g2GGoogleDistanceDI'
        },{
        	type: 'numeric',
        	dataIndex: 'g2GGoogleTimeDI'
        },{
        	type: 'numeric',
        	dataIndex: 'p2PGoogleDistanceDI'
        },{
        	type: 'numeric',
        	dataIndex: 'p2PGoogleTimeDI'
        }]
    });

    //************************************Column Model Config******************************************
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SlNo%></span>",
           width: 50
       }), {
           dataIndex: 'raidDI',
           header: "<span style=font-weight:bold;><%=Raid%></span>"
       }, {
           header: "<span style=font-weight:bold;><%=BookingNo%></span>",
           dataIndex: 'bookingNoDI'
       }, {
           header: "<span style=font-weight:bold;><%=DutyType%></span>",
           dataIndex: 'dutyTypeDI'
       }, {
           header: "<span style=font-weight:bold;><%=VehicleRegNo%></span>",
           dataIndex: 'vehicleRegNoDI'
       },{
           header: "<span style=font-weight:bold;><%=DriverName%></span>",
           dataIndex: 'driverNameDI'
       },{
           header: "<span style=font-weight:bold;><%=DriverMobNo%></span>",
           dataIndex: 'driverMobNoDI'
       },{
           header: "<span style=font-weight:bold;><%=scheduledPickupTime%></span>",
           dataIndex: 'pickUpTimeDI',
           renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
       },{
           header: "<span style=font-weight:bold;><%=Status%></span>",
           dataIndex: 'StatusDI'
       },{
           header: "<span style=font-weight:bold;><%=G2GOdoKms%></span>",
           dataIndex: 'g2gOdoKmsDI'
       },{
           header: "<span style=font-weight:bold;><%=G2GGPSKms%></span>",
           dataIndex: 'g2gGpsKmsDI'
       }, {
           header: "<span style=font-weight:bold;><%=G2GDistDifference%></span>",
           dataIndex: 'g2gDistDiffDI'
       }, {
           header: "<span style=font-weight:bold;><%=G2GTime%>(HH:MM)</span>",
           dataIndex: 'g2gTimeDI'
       }, {
           header: "<span style=font-weight:bold;><%=P2POdoKms%></span>",
           dataIndex: 'p2pOdoKms'
       },{
           header: "<span style=font-weight:bold;><%=P2PGPSKms%></span>",
           dataIndex: 'p2pGpsKmsDI'
       }, {
           header: "<span style=font-weight:bold;><%=P2PKmsDifference%></span>",
           dataIndex: 'p2pKmsDiffDI'
       }, {
           header: "<span style=font-weight:bold;><%=P2PTime%>(HH:MM)</span>",
           dataIndex: 'p2pTimeDI'
       },  {
           header: "<span style=font-weight:bold;><%=ExceptionRemarks%></span>",
           dataIndex: 'excpetionRemarksDI'
       },{
       	   header: "<span style=font-weight:bold;><%=VehicleStatus%></span>",
           dataIndex: 'vehicleStatusDI'
       },{
           header: "<span style=font-weight:bold;><%=G2GGoogleDistance%>(Kms)</span>",
           dataIndex: 'g2GGoogleDistanceDI'
       },{
           header: "<span style=font-weight:bold;><%=G2GGoogleTime%>(HH:MM)</span>",
           dataIndex: 'g2GGoogleTimeDI'
       },{
           header: "<span style=font-weight:bold;><%=P2PGoogleDistance%>(Kms)</span>",
           dataIndex: 'p2PGoogleDistanceDI'
       },{
           header: "<span style=font-weight:bold;><%=P2PGoogleTime%>(HH:MM)</span>",
           dataIndex: 'p2PGoogleTimeDI'
       }
    ];

    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
    
Grid = getGrid('', '<%=NoRecordsFound%>', tripExceptionReportStore, screen.width - 15, 420, 23, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '<%=PDF%>');

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
                        tripExceptionReportStore.load({
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

Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=TripExceptionReport%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Panel, Grid]
	});
	var cm = Grid.getColumnModel();
	for(var j=1; j<cm.getColumnCount(); j++){
		cm.setColumnWidth(j,140);
	}
    });
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->