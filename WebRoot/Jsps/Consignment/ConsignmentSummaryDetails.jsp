<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("Y");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	String clientID=request.getParameter("custId");
	String region=request.getParameter("region");
	String type=request.getParameter("type");
	String fieldRegion=request.getParameter("fieldRegion");
	String fieldCondition=request.getParameter("fieldCondition");
	String custName=request.getParameter("custName");
	String bookingCustomerName=request.getParameter("bookingCustomerName");
	String bookingCustomerNameRawValue = request.getParameter("bookingCustomerNameRawValue");
	String customerLogin1 = request.getParameter("customerLogin1");
	String TotalRegion = request.getParameter("TotalRegion");
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Registration_Number");
tobeConverted.add("Date_Time");
tobeConverted.add("Current_Location");
tobeConverted.add("Consignment_Number");
tobeConverted.add("Status");
tobeConverted.add("Speed");
tobeConverted.add("Dealer_Name");
tobeConverted.add("Dealer_Destination");
tobeConverted.add("Region");
tobeConverted.add("Schedule_Delivery_Date");
tobeConverted.add("Revised_Delivery_Date");
tobeConverted.add("Consignment_Summary_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Consignment_DashBoard");
tobeConverted.add("Customer_Name");
tobeConverted.add("Type");
tobeConverted.add("Consignment_Summary");
tobeConverted.add("Total_Distance");
tobeConverted.add("Covered_Distance");

tobeConverted.add("Dealer_City");
tobeConverted.add("Dealer_State");
tobeConverted.add("Remaining_Distance");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String RegistrationNumber=convertedWords.get(1);
String DateTime=convertedWords.get(2);
String CurrentLocation=convertedWords.get(3);
String ConsignmentNumber=convertedWords.get(4);

String Status=convertedWords.get(5);
String Speed=convertedWords.get(6);
String DealerName=convertedWords.get(7);
String DealerDestination=convertedWords.get(8);
String Region=convertedWords.get(9);
String ScheduleDeliveryDate=convertedWords.get(10);
String RevisedDeliveryDate=convertedWords.get(11);
String ConsignmentSummaryDetails=convertedWords.get(12);

String NoRecordsFound=convertedWords.get(13);
String ClearFilterData=convertedWords.get(14);
String ConsignmentDashBoard=convertedWords.get(15);
String CustomerName=convertedWords.get(16);
String Type=convertedWords.get(17);
String ConsignmentSummary=convertedWords.get(18);
String TotalDistance=convertedWords.get(19);
String CoveredDistance=convertedWords.get(20);

String DealerCity=convertedWords.get(21);
String DealerState=convertedWords.get(22);
String RemainingDistance=convertedWords.get(23);




%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Consignment Details</title>		
 		 <link rel="stylesheet" type="text/css" href="../../Main/modules/consignment/dashBoard/css/style.css" />
</head>	   

 
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  
  
  <body>
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   
   <jsp:include page="../Common/ExportJS.jsp" />
 
   <script>
var outerPanel;
var ctsb;
var jspName = "ConsignmentSummaryDetails";
var exportDataType = "int,string,string,string,date,string,string,string,string,string,string,string,string,string,string,string,string,date,date";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var consignmentStatus = "Load";
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'consignmentSummaryDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'registrationNumberDataIndex'
    }, {
        name: 'dateTimeDataIndex',
        type: 'date',
        format: getDateTimeFormat()
    }, {
        name: 'currentLocationDataIndex'
    }, {
        name: 'consignmentNumberDataIndex'
    }, {
        name: 'statusDataIndex'
    }, {
        name: 'speedDataIndex'
    }, {
        name: 'dealerNameDataIndex'
    }, {
        name: 'dealerDestinationDataIndex'
    },{
        name: 'dealerCityDataIndex'
    },{
        name: 'dealerStateDataIndex'
    }, {
        name: 'regionDataIndex'
    }, {
        name: 'totalDistanceDataIndex'
    }, {
        name: 'remainingDistanceDataIndex'
    }, {
        name: 'coveredDistanceDataIndex'
    }, {
        name: 'scheduledDeliverydateDataIndex',
        type: 'date',
        format: getDateTimeFormat()
    }, {
        name: 'revisedDeliveryDateDataIndex',
        type: 'date',
        format: getDateTimeFormat()
    },{
        name: 'bookingCustomerNameIndex'
    },{
        name: 'CustomerNameIndex'
    }]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MapView.do?param=getConsignmentSummaryDetails',
        method: 'POST'
    }),
    storeId: 'ownersId',
    reader: reader
});
var clientPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'clientPanelId',
    layout: 'table',
    frame: true,
    title: '<%=ConsignmentSummary%>',
    width: screen.width - 42,
    height: 70,
    layoutConfig: {
        columns: 15
    },
    items: [{
        xtype: 'label',
        text: '<%=CustomerName%>' + ' :',
        cls: 'labelstyle',
        id: 'customerNameTxtId'
    }, {
        xtype: 'label',
        cls: 'labelForUserInterfaceForConsignment',
        id: 'customerNameValueId'
    }, {
        width: 100
    }, {
        xtype: 'label',
        text: '<%=Region%>' + ' :',
        cls: 'labelstyle',
        id: 'regionTxtId'
    }, {
        xtype: 'label',
        cls: 'labelForUserInterfaceForConsignment',
        id: 'regionValueId'
    }, {
        width: 100
    }, {
        xtype: 'label',
        text: '<%=Status%>' + ' :',
        cls: 'labelstyle',
        id: 'statusTxtId'
    }, {
        xtype: 'label',
        cls: 'labelForUserInterfaceForConsignment',
        id: 'statusValueId'
    }, {
        width: 100
    }, {
        xtype: 'label',
        text: '<%=Type%>' + ' :',
        cls: 'labelstyle',
        id: 'typeTxtId'
    }, {
        xtype: 'label',
        cls: 'labelForUserInterfaceForConsignment',
        id: 'typeValueId'
    },{
        width: 100
    },{
        xtype: 'label',
        text: 'Booking Customer' + ' :',
        cls: 'labelstyle',
        id: 'bookingCustTxtId'
    }, {
        xtype: 'label',
        cls: 'labelForUserInterfaceForConsignment',
        id: 'bookingCustValuuId'
    }]
});
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'registrationNumberDataIndex'
    }, {
        type: 'date',
        dataIndex: 'dateTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'currentLocationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'consignmentNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusDataIndex'
    }, {
        type: 'string',
        dataIndex: 'speedDataIndex'
    }, {
        type: 'string',
        dataIndex: 'dealerNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'dealerDestinationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'regionDataIndex'
    }, {
        type: 'string',
        dataIndex: 'totalDistanceDataIndex'
    }, {
        type: 'string',
        dataIndex: 'coveredDistanceDataIndex'
    }, {
        type: 'date',
        dataIndex: 'scheduledDeliverydateDataIndex'
    }, {
        type: 'date',
        dataIndex: 'revisedDeliveryDateDataIndex'
    },{
        type: 'string',
        dataIndex: 'dealerCityDataIndex'
    },{
        type: 'string',
        dataIndex: 'dealerStateDataIndex'
    },{
        type: 'string',
        dataIndex: 'remainingDistanceDataIndex'
    },{
        type:'string',
        dataIndex:'bookingCustomerNameIndex'
    },{
        type:'string',
        dataIndex:'CustomerNameIndex'
        }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },  {
            header: "<span style=font-weight:bold;><%=CustomerName%></span>",
            dataIndex: 'CustomerNameIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Booking Customer Name</span>",
            dataIndex: 'bookingCustomerNameIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=RegistrationNumber%></span>",
            dataIndex: 'registrationNumberDataIndex',
            width: 170,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DateTime%></span>",
            dataIndex: 'dateTimeDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            width: 180,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CurrentLocation%></span>",
            dataIndex: 'currentLocationDataIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ConsignmentNumber%></span>",
            dataIndex: 'consignmentNumberDataIndex',
            width: 180,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'statusDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Speed%></span>",
            dataIndex: 'speedDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DealerName%></span>",
            dataIndex: 'dealerNameDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DealerDestination%></span>",
            dataIndex: 'dealerDestinationDataIndex',
            hidden: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DealerCity%></span>",
            dataIndex: 'dealerCityDataIndex',
            hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DealerState%></span>",
            dataIndex: 'dealerStateDataIndex',
            hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=Region%></span>",
            dataIndex: 'regionDataIndex',
            width: 50,
           // hidden:true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TotalDistance%></span>",
            dataIndex: 'totalDistanceDataIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CoveredDistance%></span>",
            dataIndex: 'coveredDistanceDataIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RemainingDistance%></span>",
            dataIndex: 'remainingDistanceDataIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ScheduleDeliveryDate%></span>",
            dataIndex: 'scheduledDeliverydateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            width: 170,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RevisedDeliveryDate%></span>",
            dataIndex: 'revisedDeliveryDateDataIndex',
            renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                var val = Ext.util.Format.date(value, getDateTimeFormat());
                var field = '<%=fieldCondition%>';
                //  if(field=='OnTime')
                //  {
                //   metaData.attr = 'style="background-color:green;"';
                //   }
                if (field == 'Delay') {
                    metaData.attr = 'style="background-color:red;"';
                }
                return val;
            },
            width: 150,
            filter: {
                type: 'date'
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
//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=ConsignmentSummaryDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 410, 26, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '',true,'Excel', jspName, exportDataType, false, 'PDF', false, '', false, '', false, '');

//******************************************************************************************************************************************************
var dashBoardButtonPanel = new Ext.Panel({
    id: 'dashBoardbuttonid',
    standardSubmit: true,
    collapsible: false,
    cls: 'nextbuttonpanel',
    width: 100,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 1
    },
    items: [{
        xtype: 'button',
        text: '<%=ConsignmentDashBoard%>',
        id: 'dashBoardButtId',
        iconCls: 'backbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    var dashBoardSummary = 1;
                    window.location = "<%=request.getContextPath()%>/Jsps/Consignment/ConsignmentDashBoard.jsp?clientIdFromDetails=" + <%= clientID %> +"&regionFromDetails=" + '<%=region%>' + "&dashBoardSummary=" + dashBoardSummary + "&custName=" + '<%=custName%>' + "&bookingCustomerNameRawValueFromDetails=" + '<%=bookingCustomerNameRawValue%>' + "&bookingCustomerNameFromDetails=" + '<%=bookingCustomerName%>' +"&customerLogin1=" +'<%=customerLogin1%>';
                }
            }
        }
    }]
});
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid, dashBoardButtonPanel],
        bbar: ctsb
    });
 //   alert('<%=bookingCustomerName%>');
    store.load({
        params: {
            clientID: <%= clientID %> ,
            region: '<%=fieldRegion%>',
            consignmentStatus: '<%=type%>',
            fieldCondition: '<%=fieldCondition%>',
            jspName:jspName,
            customerName:'<%=custName%>',
            bookingCustomerId: '<%=bookingCustomerName%>',
            bookingCustomerNameRawValue: '<%=bookingCustomerNameRawValue%>',
            TotalRegion: '<%=TotalRegion%>'
        }
    });
    
   
    var type = '<%=type%>';
    if(type=='EastFieldBox')
    {
      Ext.getCmp('statusValueId').hide();
      Ext.getCmp('statusTxtId').hide()
      Ext.getCmp('customerNameValueId').setText('<%=custName%>');
      Ext.getCmp('regionValueId').setText('<%=fieldRegion%>');
      Ext.getCmp('typeValueId').setText('Dealers');
    }else
    {
    Ext.getCmp('statusValueId').show();
    Ext.getCmp('statusTxtId').show()
    Ext.getCmp('customerNameValueId').setText('<%=custName%>');
    Ext.getCmp('regionValueId').setText('<%=fieldRegion%>');
    Ext.getCmp('statusValueId').setText('<%=type%>');
    Ext.getCmp('typeValueId').setText('<%=fieldCondition%>');
    }
    var field = '<%=fieldCondition%>';
    var fieldRegionforTotal = '<%=fieldRegion%>';
    if(fieldRegionforTotal=="Total")
    {
      Ext.getCmp('regionTxtId').hide();
      Ext.getCmp('regionValueId').hide()
    }else
    {
      Ext.getCmp('regionTxtId').show();
      Ext.getCmp('regionValueId').show();
       
    }
    
    var bookingCustToSet = '<%=bookingCustomerNameRawValue%>';
    var customerName = '<%=custName%>';
    if(bookingCustToSet == "ALL")
    {
      Ext.getCmp('bookingCustValuuId').setText('');
      Ext.getCmp('bookingCustTxtId').hide();
      
    }else
    {
    Ext.getCmp('bookingCustTxtId').show();
    Ext.getCmp('bookingCustValuuId').setText('<%=bookingCustomerNameRawValue%>');
    }
    
    if(customerName == "ALL")
    {
      Ext.getCmp('customerNameTxtId').setText('');
      Ext.getCmp('customerNameValueId').hide();
      
    }else
    {
    Ext.getCmp('customerNameTxtId').show();
    Ext.getCmp('customerNameValueId').setText('<%=custName%>');
    }
    if (type == 'Load' || type == 'Empty' || type == 'Return Load' || type == 'EastFieldBox') {
        if (field == 'Vehicles') {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('registrationNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dateTimeDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('currentLocationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consignmentNumberDataIndex'), false);
            if(type=='EastFieldBox')
           {
           grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusDataIndex'), false);
           }
           else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusDataIndex'), true);
            }
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('speedDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerNameDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerDestinationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('regionDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('scheduledDeliverydateDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('revisedDeliveryDateDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('coveredDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerCityDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerStateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remainingDistanceDataIndex'), false);
            
             if(bookingCustToSet == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), true);
           } 
              if(customerName == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), true);
           } 
            
 
        }
        if (field == 'OnTime') {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('registrationNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dateTimeDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('currentLocationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consignmentNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('speedDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerNameDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerDestinationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('regionDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('scheduledDeliverydateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('revisedDeliveryDateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('coveredDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerCityDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerStateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remainingDistanceDataIndex'), false);
            
             if(bookingCustToSet == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), true);
           } 
           
              if(customerName == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), true);
           } 
 
        }
        if (field == 'Delay') {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('registrationNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dateTimeDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('currentLocationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consignmentNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('speedDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerNameDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerDestinationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('regionDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('scheduledDeliverydateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('revisedDeliveryDateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('coveredDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerCityDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerStateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remainingDistanceDataIndex'), false);
            
              if(bookingCustToSet == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), true);
           } 
              if(customerName == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), true);
           } 
 
        }
        if (field == 'Alerts') {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('registrationNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dateTimeDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('currentLocationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consignmentNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('speedDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerNameDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerDestinationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('regionDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('scheduledDeliverydateDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('revisedDeliveryDateDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('coveredDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerCityDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerStateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remainingDistanceDataIndex'), false);
            
             if(bookingCustToSet == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), true);
           } 
              if(customerName == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), true);
           } 
        }
         if(fieldRegionforTotal == 'Total')
        {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('registrationNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dateTimeDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('currentLocationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consignmentNumberDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusDataIndex'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('speedDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerNameDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerDestinationDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('regionDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('scheduledDeliverydateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('revisedDeliveryDateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('coveredDistanceDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerCityDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dealerStateDataIndex'), false);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remainingDistanceDataIndex'), false);
            
            if(bookingCustToSet == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('bookingCustomerNameIndex'), true);
           } 
           
              if(customerName == "ALL")
           { 
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), false);
           }else
           {
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('CustomerNameIndex'), true);
           } 
        
        }
       
    }
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>
    
    
    
    
    

