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
	loginInfo.setStyleSheetOverride("N");
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

ArrayList<String> tobeConverted = new ArrayList<String>();
		tobeConverted.add("Consignment_Tracking_Usage_Report");	
		tobeConverted.add("Consignment_Tracking_Details");
		tobeConverted.add("Dealer_Name");
		tobeConverted.add("Select_Dealer");
		tobeConverted.add("Customer_Name");
		tobeConverted.add("Start_Date");
		tobeConverted.add("Select_Start_Date");
		tobeConverted.add("End_Date");
		tobeConverted.add("Select_End_Date");
		tobeConverted.add("View");
		tobeConverted.add("SLNO");
		tobeConverted.add("Consignment_Number");
		tobeConverted.add("Search_DateTime");
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("Clear_Filter_Data");
		tobeConverted.add("Excel");
		tobeConverted.add("Add");
		tobeConverted.add("Month_Validation");
		tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

	String consignmenttrackingusageReportforTitle = convertedWords.get(0);
	String consignmentTrackingDetails = convertedWords.get(1);
	String dealername = convertedWords.get(2);
	String SelectDealer = convertedWords.get(3);
	String custname = convertedWords.get(4);
	String startdate = convertedWords.get(5);
	String selectstartdate = convertedWords.get(6);
	String enddate =  convertedWords.get(7) ;
	String selectenddate = convertedWords.get(8);
	String View = convertedWords.get(9);
	String slno = convertedWords.get(10);
	String consingmentno = convertedWords.get(11);
	String searchdatetime = convertedWords.get(12);
	String NoRecordsFound = convertedWords.get(13);
	String ClearFilterData = convertedWords.get(14);
	String Excel = convertedWords.get(15);
	String Add = convertedWords.get(16);
	String monthValidation = convertedWords.get(17);
	String EndDateMustBeGreaterthanStartDate = convertedWords.get(18);
%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=consignmenttrackingusageReportforTitle%></title>
 		<meta http-equiv="X-UA-Compatible" content="IE=11">			
  
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
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

var prevDate = previousDate;
var curDate = currentDate;
var dtnext1 = datecur.add(Date.DAY, +1); 
var dtnext = datecur;  
var outerPanel;
var ctsb;
var jspName = "consignmenttrackingusagereport";
var exportDataType = "int,string,string,string,date,String,date,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;

var dealercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/BookingCustomerAction.do?param=getDealers',
    id: 'DealerStoreId',
    root: 'DealerRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['DealerId', 'DealerName']
});

var Dealer = new Ext.form.ComboBox({
    store: dealercombostore,
    id: 'dealercomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectDealer%>',
    blankText: '<%=SelectDealer%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'DealerId',
    displayField: 'DealerName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                dealerId = Ext.getCmp('dealercomboId').getValue();
                store.load();
            }
        }
    }
});

var dealerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'dealerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 40,
    height: 35,
    layoutConfig: {
        columns: 20
    },
    items: [{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            text: '<%=startdate%>' + ' :'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateTimeFormat(),
            emptyText: '<%=selectstartdate%>',
            allowBlank: false,
            blankText: '<%=selectstartdate%>',
            id: 'startdate',
          //  vtype: 'daterange',
            maxValue:dtnext,
            value: prevDate
           // endDateField: 'enddate'
        }, {
            width: 60
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'enddatelab',
            text: '<%=enddate%>' + ' :'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateTimeFormat(),
            emptyText: '<%=selectenddate%>',
            allowBlank: false,
            blankText: '<%=selectenddate%>',
            id: 'enddate',
           // vtype: 'daterange',
            maxValue:dtnext1,
            //minValue:prevDate,
            value: curDate
          //  startDateField: 'startdate'
        }, {
            width: 60
        }, {
            xtype: 'label',
            text: '<%=dealername%>' + ' :',
            cls: 'labelstyle'
        },
        Dealer, {
            width: 80
        }, {
            xtype: 'button',
            text: '<%=View%>',
            id: 'addbuttonid',
            cls: ' ',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                    
                    
                     if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
						             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
						             Ext.getCmp('enddate').focus();
						             return;
						         }
                        
                        var startdates = Ext.getCmp('startdate').getValue();
                        var enddates = Ext.getCmp('enddate').getValue();
                        
                      
                        if(checkMonthValidation(startdates, enddates)) {
                            Ext.example.msg("<%=monthValidation%>");
                            Ext.getCmp('enddate').focus();
                            return;
                        }
                        
                        if(Ext.getCmp('dealercomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectDealer%>");
                            Ext.getCmp('dealercomboId').focus();
                            return;
                        }
                        if(Ext.getCmp('startdate').getValue() == "") {
                            Ext.example.msg("<%=selectstartdate%>");
                            Ext.getCmp('startdate').focus();
                            return;
                        }
                        if(Ext.getCmp('enddate').getValue() == "") {
                            Ext.example.msg("<%=selectenddate%>");
                            Ext.getCmp('enddate').focus();
                            return;
                        }
                        
                        store.load({
                            params: {
                                DealerId: Ext.getCmp('dealercomboId').getValue(),
                                startdate: Ext.getCmp('startdate').getValue(),
                                enddate: Ext.getCmp('enddate').getValue(),
                                jspName: jspName
                            }
                        });
                    }
                }
            }
        }
    ]
});

var reader = new Ext.data.JsonReader({
    idProperty: 'ConsignmentRequestid',
    root: 'ConsignmentRequestRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'dealerNameDataIndex'
    }, {
        name: 'customerNameDataIndex'
    }, {
        name: 'consignmentNoDataIndex'
    }, {
        name: 'searchDateTimeDataIndex',
        type: 'date'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/BookingCustomerAction.do?param=getConsignmentTrackingUsageReport',
        method: 'POST'
    }),
    storeId: 'ConsignmentRequestId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'dealerNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'customerNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'consignmentNoDataIndex'
    }, {
        type: 'date',
        dataIndex: 'searchDateTimeDataIndex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=slno%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=slno%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=dealername%></span>",
            dataIndex: 'dealerNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=custname%></span>",
            dataIndex: 'customerNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=consingmentno%></span>",
            dataIndex: 'consignmentNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=searchdatetime%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            dataIndex: 'searchDateTimeDataIndex',
            width: 100,
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
grid = getGrid('<%=consignmentTrackingDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF', false, '<%=Add%>');
//******************************************************************************************************************************************************

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=consignmenttrackingusageReportforTitle%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [dealerComboPanel, grid]
            //bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
    dealercombostore.load();
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

