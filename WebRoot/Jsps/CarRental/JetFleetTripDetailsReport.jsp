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
	 tobeConverted.add("SLNO");
	 tobeConverted.add("Select_client");
	 tobeConverted.add("Customer_Name");
	 tobeConverted.add("Start_Date");
	 tobeConverted.add("Select_Start_Date");
	 tobeConverted.add("End_Date");
	 tobeConverted.add("Select_End_Date");
	 tobeConverted.add("No_Records_Found");
	 tobeConverted.add("Clear_Filter_Data");
	 tobeConverted.add("Excel");
	 tobeConverted.add("View");
	 tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	 tobeConverted.add("Week_Validation");
	 
	 tobeConverted.add("RA_ID");
	 tobeConverted.add("Booking_No");
	 tobeConverted.add("Duty_Type");
	 tobeConverted.add("Asset_No");
	 tobeConverted.add("Driver_Name");
	 tobeConverted.add("Driver_Mobile_No");
	 tobeConverted.add("Status");
	 tobeConverted.add("Scheduled_Pickup_Time");
	 tobeConverted.add("G2G_GPS_Kms");
     tobeConverted.add("G2G_ODO_Kms");
     tobeConverted.add("G2G_Distance_Difference");
     tobeConverted.add("G2G_Time");
	 tobeConverted.add("P2P_GPS_Kms");
     tobeConverted.add("P2P_ODO_Kms");
	 tobeConverted.add("P2P_Kms_Difference");
	 tobeConverted.add("P2P_Time");
	 tobeConverted.add("Exception_Remarks");
	 tobeConverted.add("Comments");
	 tobeConverted.add("Trip_Details_Report");
	 tobeConverted.add("G_Out_Date");
	 tobeConverted.add("G_In_Date");
	 tobeConverted.add("G_Out_Odometer");
	 tobeConverted.add("G_In_Odometer");
	 tobeConverted.add("PickUp_Date");
	 tobeConverted.add("Pick_Odometer");
	 tobeConverted.add("DropUp_Date");
	 tobeConverted.add("Drop_Odometer");
	 tobeConverted.add("Feedback");
	 tobeConverted.add("Remarks");
	 tobeConverted.add("GS_Latitude");
	 tobeConverted.add("GS_Longitude");
	 tobeConverted.add("TS_Latitude");
	 tobeConverted.add("TS_Longitude");
	 tobeConverted.add("TE_Latitude");
	 tobeConverted.add("TE_Longitude");
	 tobeConverted.add("GI_Latitude");
	 tobeConverted.add("GI_Longitude");
	 tobeConverted.add("GS_GPS_Dist");
	 tobeConverted.add("TS_GPS_Dist");
	 tobeConverted.add("TE_GPS_Dist");
	 tobeConverted.add("GI_GPS_Dist");

  ArrayList<String> convertedWords=new ArrayList<String>();
  convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
   String SLNO = convertedWords.get(0);
   String SelectCustomer = convertedWords.get(1);
   String CustomerName = convertedWords.get(2);
   String startDate=convertedWords.get(3);
   String selectStartDate=convertedWords.get(4);
   String endDate=convertedWords.get(5);
   String selectEndDate=convertedWords.get(6);
   String NoRecordsfound= convertedWords.get(7);
   String ClearFilterData = convertedWords.get(8);
   String Excel=convertedWords.get(9);
   String view=convertedWords.get(10);
   String EndDateMustBeGreaterthanStartDate = convertedWords.get(11);
   String WeekValidation=convertedWords.get(12);
   
   String raid=convertedWords.get(13);
   String bookingNo=convertedWords.get(14);
   String dutyType=convertedWords.get(15);
   String vehicleRegNo=convertedWords.get(16);
   String driverName=convertedWords.get(17);
   String driverMobileNo=convertedWords.get(18);
   String status=convertedWords.get(19);
   String scheduledPickUpTime=convertedWords.get(20);
   String G2G_GPS_KMS=convertedWords.get(21);
   String G2G_ODO_KMS=convertedWords.get(22);
   String G2G_DIS_DIFFERENCE=convertedWords.get(23);
   String G2G_GPS_TIME=convertedWords.get(24);
   String P2P_GPS_KMS=convertedWords.get(25);
   String P2P_ODO_KMS=convertedWords.get(26);
   String P2P_KMS_DIFFERENCE=convertedWords.get(27);
   String P2P_GPS_TIME=convertedWords.get(28);
   String EXCEPTION_REMARKS=convertedWords.get(29);
   String comments=convertedWords.get(30);
   String JetFleetTripDetailsReport=convertedWords.get(31);
   String G_OUT_DATE=convertedWords.get(32);
   String G_IN_DATE=convertedWords.get(33);
   String G_OUT_ODOMETER=convertedWords.get(34);
   String G_IN_ODOMETER=convertedWords.get(35);
   String PICKUP_DATE=convertedWords.get(36);
   String PICK_ODOMETER=convertedWords.get(37);
   String DROP_UPDATE=convertedWords.get(38);
   String DROP_ODOMETER=convertedWords.get(39);
   String feedback=convertedWords.get(40);
   String remark=convertedWords.get(41);
   String GS_LATITUDE=convertedWords.get(42);
   String GS_LONGITUDE=convertedWords.get(43);
   String TS_LATITUDE=convertedWords.get(44);
   String TS_LONGITUDE=convertedWords.get(45);
   String TE_LATITUDE=convertedWords.get(46);
   String TE_LONGITUDE=convertedWords.get(47);
   String GI_LATITUDE=convertedWords.get(48);
   String GI_LONGITUDE=convertedWords.get(49);
   String GPS_DIS_GS=convertedWords.get(50);
   String GPS_DIS_TS=convertedWords.get(51);
   String GPS_DIS_TE=convertedWords.get(52);
   String GPS_DIS_GI=convertedWords.get(53);
         
%>

<jsp:include page="../Common/header.jsp" />
		<title><%=JetFleetTripDetailsReport%></title>		
	  
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
		<style>
			.ext-strict .x-form-text {
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
   	var jspName = "JetFleetTripDetailsReport";
  	var exportDataType = "int,int,int,string,string,string,string,string,string,number,number,number,string,number,number,number,string,string,string,number,string,number,string,number,string,number,string,string,number,string,string,number,string,string,number,string,string,number,string,string,string";
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
                    custId = Ext.getCmp('clientId').getValue();
                    custName = Ext.getCmp('clientId').getRawValue();
                }
            }
        }
    });

    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'JFTripDetailsRoot',
        totalProperty: 'total',
        fields: [{
			        name: 'slnoIndex'
			      },{
			        name: 'raidIndex'
			      },{
			        name: 'bookingNoIndex'
			      },{
			        name: 'dutyTypeIndex'
			      },{
					name: 'vehicleRegNoIndex'
				  },{
					name: 'driverNameIndex'
				  },{
					name: 'driverMobileNoIndex'
				  },{
					name: 'statusIndex'
				  },{
					type:'date',
					dateFormat: 'c',
					name: 'scheduledPickUpTimeIndex'
				  },{
					name: 'G2G_GPS_KMS_Index'
				  },{
					name: 'G2G_ODO_KMS_Index'
				  },{
					name: 'G2G_DIS_DIFFERENCE_Index'
				  },{
					name: 'G2G_GPS_TIME_Index'
				  },{
					name: 'P2P_GPS_KMS_Index'
				  },{
					name: 'P2P_ODO_KMS_Index'
				  },{
					name: 'P2P_KMS_DIFFERENCE_Index'
				  },{
					name: 'P2P_GPS_TIME_Index'
				  },{
					name: 'ExceptionRemarksIndex'
				  },{
					type:'date',
					dateFormat: 'c',
					name: 'G_OUT_DATE_Index'
				  },{
					name: 'G_OUT_ODOMETER_Index'
				  },{
					type:'date',
					dateFormat: 'c',
					name: 'PICKUP_DATE_Index'
				  },{
					name: 'PICK_ODOMETER_Index'
				  },{
					type:'date',
					name: 'DROP_UPDATE_Index'
				  },{
					name: 'DROP_ODOMETER_Index'
				  },{
					type:'date',
					dateFormat: 'c',
					name: 'G_IN_DATE_Index'
				  },{
					name: 'G_IN_ODOMETER_Index'
				  },{
					name: 'GS_LATITUDE_Index'
				  },{
					name: 'GS_LONGITUDE_Index'
				  },{
					name: 'GPS_DIS_GS_Index'
				  },{
					name: 'TS_LATITUDE_Index'
				  },{
					name: 'TS_LONGITUDE_Index'
				  },{
					name: 'GPS_DIS_TS_Index'
				  },{
					name: 'TE_LATITUDE_Index'
				  },{
					name: 'TE_LONGITUDE_Index'
				  },{
					name: 'GPS_DIS_TE_Index'
				  },{
					name: 'GI_LATITUDE_Index'
				  },{
					name: 'GI_LONGITUDE_Index'
				  },{
					name: 'GPS_DIS_GI_Index'
				  },{
					name: 'feedbackIndex'
				  },{
					name: 'remarkIndex'
				  },{
					name: 'commentIndex'
				  }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/JetFleetTripDetailsAction.do?param=getJFTripDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'storeId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
        			type:'numeric',
			        dataIndex: 'slnoIndex'
			      },{
        			type:'numeric',
			        dataIndex: 'raidIndex'
			      },{
        			type:'numeric',
			        dataIndex: 'bookingNoIndex'
			      },{
        			type:'string',
			        dataIndex: 'dutyTypeIndex'
			      },{
					type:'string',
					dataIndex: 'vehicleRegNoIndex'
				  },{
					type:'string',
					dataIndex: 'driverNameIndex'
				  },{
					type:'string',
					dataIndex: 'driverMobileNoIndex'
				  },{
					type:'string',
					dataIndex: 'statusIndex'
				  },{
					type:'date',
					dataIndex: 'scheduledPickUpTimeIndex'
				  },{
					type:'numeric',
					dataIndex: 'G2G_GPS_KMS_Index'
				  },{
					type:'numeric',
					dataIndex: 'G2G_ODO_KMS_Index'
				  },{
					type:'numeric',
					dataIndex: 'G2G_DIS_DIFFERENCE_Index'
				  },{
					type:'string',
					dataIndex: 'G2G_GPS_TIME_Index'
				  },{
					type:'numeric',
					dataIndex: 'P2P_GPS_KMS_Index'
				  },{
					type:'numeric',
					dataIndex: 'P2P_ODO_KMS_Index'
				  },{
					type:'numeric',
					dataIndex: 'P2P_KMS_DIFFERENCE_Index'
				  },{
					type:'string',
					dataIndex: 'P2P_GPS_TIME_Index'
				  },{
					type:'string',
					dataIndex: 'ExceptionRemarksIndex'
				  },{
					type:'date',
					dataIndex: 'G_OUT_DATE_Index'
				  },{
					type:'numeric',
					dataIndex: 'G_OUT_ODOMETER_Index'
				  },{
					type:'date',
					dataIndex: 'PICKUP_DATE_Index'
				  },{
					type:'numeric',
					dataIndex: 'PICK_ODOMETER_Index'
				  },{
					type:'date',
					dataIndex: 'DROP_UPDATE_Index'
				  },{
					type:'numeric',
					dataIndex: 'DROP_ODOMETER_Index'
				  },{
					type:'date',
					dataIndex: 'G_IN_DATE_Index'
				  },{
					type:'numeric',
					dataIndex: 'G_IN_ODOMETER_Index'
				  },{
					type:'numeric',
					dataIndex: 'GS_LATITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GS_LONGITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GPS_DIS_GS_Index'
				  },{
					type:'numeric',
					dataIndex: 'TS_LATITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'TS_LONGITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GPS_DIS_TS_Index'
				  },{
					type:'numeric',
					dataIndex: 'TE_LATITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'TE_LONGITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GPS_DIS_TE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GI_LATITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GI_LONGITUDE_Index'
				  },{
					type:'numeric',
					dataIndex: 'GPS_DIS_GI_Index'
				  },{
					type:'numeric',
					dataIndex: 'feedbackIndex'
				  },{
					type:'string',
					dataIndex: 'remarkIndex'
				  },{
					type:'string',
					dataIndex: 'commentIndex'
				  }]
    });

    //************************************Column Model Config******************************************
var createColModel = function (finish, start) {
    var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>"
            }, {
                dataIndex: 'raidIndex',
                header: "<span style=font-weight:bold;><%=raid%></span>"
            }, {
                dataIndex: 'bookingNoIndex',
                header: "<span style=font-weight:bold;><%=bookingNo%></span>"
            }, {
                dataIndex: 'dutyTypeIndex',
                header: "<span style=font-weight:bold;><%=dutyType%></span>"
            }, {
                dataIndex: 'vehicleRegNoIndex',
                header: "<span style=font-weight:bold;><%=vehicleRegNo%></span>"
            }, {
                dataIndex: 'driverNameIndex',
                header: "<span style=font-weight:bold;><%=driverName%></span>"
            }, {
                dataIndex: 'driverMobileNoIndex',
                header: "<span style=font-weight:bold;><%=driverMobileNo%></span>"
            }, {
                dataIndex: 'scheduledPickUpTimeIndex',
                header: "<span style=font-weight:bold;><%=scheduledPickUpTime%></span>",
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
            },{
                dataIndex: 'statusIndex',
                header: "<span style=font-weight:bold;><%=status%></span>"
            }, {
                dataIndex: 'G2G_ODO_KMS_Index',
                header: "<span style=font-weight:bold;><%=G2G_ODO_KMS%></span>"
            }, {
                dataIndex: 'G2G_GPS_KMS_Index',
                header: "<span style=font-weight:bold;><%=G2G_GPS_KMS%></span>"
            }, {
                dataIndex: 'G2G_DIS_DIFFERENCE_Index',
                header: "<span style=font-weight:bold;><%=G2G_DIS_DIFFERENCE%></span>"
            }, {
                dataIndex: 'G2G_GPS_TIME_Index',
                header: "<span style=font-weight:bold;><%=G2G_GPS_TIME%>(HH:MM)</span>"
            }, {
                dataIndex: 'P2P_ODO_KMS_Index',
                header: "<span style=font-weight:bold;><%=P2P_ODO_KMS%></span>"
            }, {
                dataIndex: 'P2P_GPS_KMS_Index',
                header: "<span style=font-weight:bold;><%=P2P_GPS_KMS%></span>"
            }, {
                dataIndex: 'P2P_KMS_DIFFERENCE_Index',
                header: "<span style=font-weight:bold;><%=P2P_KMS_DIFFERENCE%></span>"
            }, {
                dataIndex: 'P2P_GPS_TIME_Index',
                header: "<span style=font-weight:bold;><%=P2P_GPS_TIME%>(HH:MM)</span>"
            }, {
                dataIndex: 'ExceptionRemarksIndex',
                header: "<span style=font-weight:bold;><%=EXCEPTION_REMARKS%></span>"
            }, {
                dataIndex: 'G_OUT_DATE_Index',
                header: "<span style=font-weight:bold;><%=G_OUT_DATE%></span>",
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
            }, {
                dataIndex: 'G_OUT_ODOMETER_Index',
                header: "<span style=font-weight:bold;><%=G_OUT_ODOMETER%></span>"
            }, {
                dataIndex: 'PICKUP_DATE_Index',
                header: "<span style=font-weight:bold;><%=PICKUP_DATE%></span>",
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
            }, {
                dataIndex: 'PICK_ODOMETER_Index',
                header: "<span style=font-weight:bold;><%=PICK_ODOMETER%></span>"
            }, {
                dataIndex: 'DROP_UPDATE_Index',
                header: "<span style=font-weight:bold;><%=DROP_UPDATE%></span>",
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
            }, {
                dataIndex: 'DROP_ODOMETER_Index',
                header: "<span style=font-weight:bold;><%=DROP_ODOMETER%></span>"
            }, {
                dataIndex: 'G_IN_DATE_Index',
                header: "<span style=font-weight:bold;><%=G_IN_DATE%></span>",
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
            }, {
                dataIndex: 'G_IN_ODOMETER_Index',
                header: "<span style=font-weight:bold;><%=G_IN_ODOMETER%></span>"
            }, {
                dataIndex: 'GS_LATITUDE_Index',
                header: "<span style=font-weight:bold;><%=GS_LATITUDE%></span>"
            }, {
                dataIndex: 'GS_LONGITUDE_Index',
                header: "<span style=font-weight:bold;><%=GS_LONGITUDE%></span>"
            }, {
                dataIndex: 'GPS_DIS_GS_Index',
                header: "<span style=font-weight:bold;><%=GPS_DIS_GS%></span>"
            }, {
                dataIndex: 'TS_LATITUDE_Index',
                header: "<span style=font-weight:bold;><%=TS_LATITUDE%></span>"
            }, {
                dataIndex: 'TS_LONGITUDE_Index',
                header: "<span style=font-weight:bold;><%=TS_LONGITUDE%></span>"
            }, {
                dataIndex: 'GPS_DIS_TS_Index',
                header: "<span style=font-weight:bold;><%=GPS_DIS_TS%></span>"
            }, {
                dataIndex: 'TE_LATITUDE_Index',
                header: "<span style=font-weight:bold;><%=TE_LATITUDE%></span>"
            }, {
                dataIndex: 'TE_LONGITUDE_Index',
                header: "<span style=font-weight:bold;><%=TE_LONGITUDE%></span>"
            }, {
                dataIndex: 'GPS_DIS_TE_Index',
                header: "<span style=font-weight:bold;><%=GPS_DIS_TE%></span>"
            }, {
                dataIndex: 'GI_LATITUDE_Index',
                header: "<span style=font-weight:bold;><%=GI_LATITUDE%></span>"
            }, {
                dataIndex: 'GI_LONGITUDE_Index',
                header: "<span style=font-weight:bold;><%=GI_LONGITUDE%></span>"
            }, {
                dataIndex: 'GPS_DIS_GI_Index',
                header: "<span style=font-weight:bold;><%=GPS_DIS_GI%></span>"
            }, {
                dataIndex: 'feedbackIndex',
                header: "<span style=font-weight:bold;><%=feedback%></span>"
            }, {
                dataIndex: 'remarkIndex',
                header: "<span style=font-weight:bold;><%=remark%></span>"
            }, {
                dataIndex: 'commentIndex',
                header: "<span style=font-weight:bold;><%=comments%></span>"
            }];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
    
Grid = getGrid('', '<%=NoRecordsfound%>', store, screen.width - 20, 365, 50, filters, '<%=ClearFilterData%>', false, '', 50, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF');

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
            text: '<%=SelectCustomer%>' + ' :',
            cls: 'labelstyle',
            id: 'client'
        },
        clientCombo,
        {width:30},
        {
        xtype: 'label',
        text: '<%=startDate%>' + ' :',
        cls: 'labelstyle',
        id: 'startDate'
    }, {
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        emptyText: '<%=selectStartDate%>',
        format: getDateTimeFormat(),
        id: 'startDateId'
    }, {width:30},{
        xtype: 'label',
        text: '<%=endDate%>' + ' :',
        cls: 'labelstyle',
        id: 'endDate'
    },{
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        emptyText: '<%=selectEndDate%>',
        format: getDateTimeFormat(),
        id: 'endDateId'
    },{width:30},{
        xtype: 'button',
        text: '<%=view%>',
        id: 'addbuttonid',
        cls: ' ',
        width: 80,
        listeners: {
                click: {
                    fn: function () {
                        if (Ext.getCmp('clientId').getValue() == "") {
                            Ext.example.msg("<%=SelectCustomer%>");
                          Ext.getCmp('clientId').focus();
                          return;
                      }
                      if (Ext.getCmp('startDateId').getValue() == "") {
                          Ext.example.msg("<%=selectStartDate%>");
                          Ext.getCmp('startDateId').focus();
                          return;
                      }
                      if (Ext.getCmp('endDateId').getValue() == "") {
                          Ext.example.msg("<%=selectEndDate%>");
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
                          if (checkWeekValidation(startdates, enddates)) {
                          Ext.example.msg("<%=WeekValidation%>");
                            Ext.getCmp('endDateId').focus();
                            return;
                        }
                        store.load({
                                params: {
                                	custId: Ext.getCmp('clientId').getValue(),
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
        title: '<%=JetFleetTripDetailsReport%>',
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
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,155);
    }
    });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->