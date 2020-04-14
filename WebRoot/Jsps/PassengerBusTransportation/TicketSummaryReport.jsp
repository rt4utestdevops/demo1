<%@ page language="java"
import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
	int customeridlogged=loginInfo.getCustomerId();
String customerName1="null";
if(customeridlogged>0)
{
customerName1=cf.getCustomerName(String.valueOf(customeridlogged),systemId);
}
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Select_Report_Type");
tobeConverted.add("Select_Report_Type");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Report_Type");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("SLNO");
tobeConverted.add("Asset_Number");
tobeConverted.add("Service_Name");
tobeConverted.add("Renewal_By");
tobeConverted.add("Due_Days");
tobeConverted.add("Due_Mileage");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Last_Service_Date");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Expiry_Date");
tobeConverted.add("Alert_Type");
tobeConverted.add("Remarks");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Report_Type");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Terminal_Name");
tobeConverted.add("Route_Name");
tobeConverted.add("Start_Month");
tobeConverted.add("End_Month");
tobeConverted.add("Scheduled_Date");
tobeConverted.add("Consumer_Booking _By_Web");
tobeConverted.add("Consumer_Booking_By_Mobile");
tobeConverted.add("User_Booking_By_Web");
tobeConverted.add("User_Booking_By_Mobile");
tobeConverted.add("Total_Tickets_Booked");
tobeConverted.add("No_Of_Bus");
tobeConverted.add("Ticket_Summary_Report");

String clientID=request.getParameter("cutomerID");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectReportType=convertedWords.get(1);
String SelectCustomer=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String ReportType=convertedWords.get(4);
String StartDate=convertedWords.get(5);
String SelectStartDate=convertedWords.get(6);
String EndDate=convertedWords.get(7);
String SelectEndDate=convertedWords.get(8);
String SLNO=convertedWords.get(9);
String Excel=convertedWords.get(15);
String PDF=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String NoRecordsfound=convertedWords.get(19);
String PleaseSelectCustomer=convertedWords.get(23);
String PleaseSelectReportType=convertedWords.get(24);
String PleaseSelectStartDate=convertedWords.get(25);
String PleaseSelectEndDate=convertedWords.get(26);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(27);
String monthValidation=convertedWords.get(28);
String TerminalName=convertedWords.get(29);
String RouteName=convertedWords.get(30);
String StartMonthYear =convertedWords.get(31);
String EndMonthYear =convertedWords.get(32);
String ScheduledDate =convertedWords.get(33);
String ConsumerBookingByWeb =convertedWords.get(34);
String ConsumerBookingByMobile =convertedWords.get(35);
String UserBookingByWeb =convertedWords.get(36);
String UserBookingByMobile =convertedWords.get(37);
String TotalTicketsBooked =convertedWords.get(38);
String NoOfBus =convertedWords.get(39);
String TicketSummaryReport=convertedWords.get(40);
%>

<jsp:include page="../Common/header.jsp" />
<html class="largehtml">
	
		<title><%=TicketSummaryReport%></title>
	
	<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
.x-form-invalid-icon {
    left: 170px;
    top: 0px;
    visibility: visible;
}

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
		
			
			
			
			
</style>

		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
	<style>
		label {
				display : inline !important;
		}		
		.x-window-tl *.x-window-header{
				padding-top : 6px !important;
		}
	</style>
<script>
 
    var dt;
    var dt1 = dateprev; 
    dt = dt1; // -1 day from current day  
    var outerPanel;
    var dtprev = dt;
    var prevmonth = new Date().add(Date.MONTH, -1);
    var currmonth = new Date();
    var dtcur = datecur;
    var jspName = '<%=TicketSummaryReport%>';
    var reportName = '<%=TicketSummaryReport%>';
    var exportDataType = "int,string,int,string,string,int,int,int,int,int,int";
    var startDate = "";
    var endDate = "";
    var newDate = new Date().add(Date.DAY, -1);
    var grid;   
    var reportTypeStore = new Ext.data.SimpleStore({
        id: 'reportTypeStoreId',
        autoLoad: true,
        fields: ['Name', 'Value'],
        data: [
            ['Route Wise Ticket Summary', '1'],
            ['Ticket Sold By Web/Mobile (Daily)', '2'],
            ['Ticket Sold By Web/Mobile (Monthly)', '3']
        ]

    });


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
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    Ext.getCmp('reportTypeComboId').setValue('1');
                    Ext.getCmp('durationpanel1Id').show();
                    Ext.getCmp('durationpanel2Id').hide();
                    jspName = Ext.getCmp('reportTypeComboId').getRawValue();
                    headerPanel.setTitle(jspName);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByWebIndex'), true);   
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByMobileIndex'), true);      
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingBywebIndex'), true); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingByMobileIndex'), true); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalTicketsBookedIndex'), false);  
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('noOfBusIndex'), false);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('terminalNameIndex'), false);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('routeNameIndex'), false);                                                                                                     
               store.load();
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
                fn: function() {
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    Ext.getCmp('reportTypeComboId').setValue('1');
                    Ext.getCmp('durationpanel1Id').show();
                    Ext.getCmp('durationpanel2Id').hide();
                    jspName = Ext.getCmp('reportTypeComboId').getRawValue();
                    headerPanel.setTitle(jspName);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByWebIndex'), true);   
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByMobileIndex'), true);      
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingBywebIndex'), true); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingByMobileIndex'), true); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalTicketsBookedIndex'), false);  
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('noOfBusIndex'), false);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('terminalNameIndex'), false);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('routeNameIndex'), false);                                                                                                     
                     store.load();

                    if (<%= customerId %> > 0) {
                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                        custId = Ext.getCmp('custcomboId').getValue();
                        custName = Ext.getCmp('custcomboId').getRawValue();
                    }
                }
            }
        }
    });

    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: true,
        width: screen.width - 35,    
        layoutConfig: {
            columns: 5
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo, {
                width: 20
            }, {
                xtype: 'label',
                text: '<%=ReportType%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab'
            }, {
                xtype: 'combo',
                store: reportTypeStore,
                frame: true,
                width: 250,
                listWidth: 250,
                forceSelection: true,
                enableKeyEvents: true,
                mode: 'local',
                anyMatch: true,
                onTypeAhead: true,
                emptyText:'<%=SelectReportType%>',
                id: 'reportTypeComboId',
                mode: 'local',
                allowBlank: false,
                triggerAction: 'all',
                valueField: 'Value',
                displayField: 'Name',
                listeners: {
                    select: {
                        fn: function() {
                                Ext.getCmp('startdate').setValue(dtprev);
                                Ext.getCmp('enddate').setValue(datecur);                    
                                Ext.getCmp('startdate2').setValue(prevmonth);
                                Ext.getCmp('enddate2').setValue(currmonth);
                                
                            if (Ext.getCmp('reportTypeComboId').getValue() == 1) {
                                Ext.getCmp('durationpanel1Id').show();
                                Ext.getCmp('durationpanel2Id').hide();
                                jspName = Ext.getCmp('reportTypeComboId').getRawValue();
                                headerPanel.setTitle(jspName);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByWebIndex'), true);   
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByMobileIndex'), true);      
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingBywebIndex'), true); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingByMobileIndex'), true); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalTicketsBookedIndex'), false);  
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('noOfBusIndex'), false);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('terminalNameIndex'), false);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('routeNameIndex'), false);                           
                            }
                            if (Ext.getCmp('reportTypeComboId').getValue() == 2) {
                                Ext.getCmp('durationpanel1Id').show();
                                Ext.getCmp('durationpanel2Id').hide();                                
                                jspName = Ext.getCmp('reportTypeComboId').getRawValue();
                                headerPanel.setTitle(jspName);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('noOfBusIndex'), true);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('terminalNameIndex'), true);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('routeNameIndex'), true);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByWebIndex'), false);   
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByMobileIndex'), false);      
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingBywebIndex'), false); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingByMobileIndex'), false); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalTicketsBookedIndex'), false);                             
                            }
                            if (Ext.getCmp('reportTypeComboId').getValue() == 3) {
                                Ext.getCmp('durationpanel1Id').hide();
                                Ext.getCmp('durationpanel2Id').show();
                                
                                jspName = Ext.getCmp('reportTypeComboId').getRawValue();
                                headerPanel.setTitle(jspName);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('noOfBusIndex'), true);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('terminalNameIndex'), true);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('routeNameIndex'), true);
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByWebIndex'), false);   
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consumerBookingByMobileIndex'), false);      
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingBywebIndex'), false); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('UserBookingByMobileIndex'), false); 
                                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalTicketsBookedIndex'), false); 
                                var date1=Ext.getCmp('startdate2').getValue();
						        var year1= date1.getFullYear();
						        var month1 = date1.getMonth();
						        var date2=Ext.getCmp('enddate2').getValue();
						        var year2= date2.getFullYear();
						        var month2 = date2.getMonth();

					            startdate = month1+"-"+year1;
					            enddate =  month2+"-"+year2;
                            }
                            store.load();
                        }
                    }
                }
            }
        ]
    });

    var durationpanel1 = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'durationpanel1Id',
        layout: 'table',
        frame: true,
        hidden: true,
        width: screen.width - 35,
        
        layoutConfig: {
            columns: 10
        },
        items: [{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            width: 200,
            text: '<%=StartDate%>' + ' :'
        }, {
            width: 30
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 160,
            format: getDateFormat(),
            emptyText: '<%=SelectStartDate%>',
            allowBlank: false,
            blankText: '<%=SelectStartDate%>',
            id: 'startdate',
            value: dtprev,
            endDateField: 'enddate'
        }, {
            width: 170
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'enddatelab',
            width: 200,
            text: '<%=EndDate%>' + ' :'
        }, {
            width: 10
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width:160,
            format: getDateFormat(),
            emptyText: '<%=SelectEndDate%>',
            allowBlank: false,
            blankText: '<%=SelectEndDate%>',
            id: 'enddate',
            value: datecur,
            startDateField: 'startdate'
        },{width:180},{
        xtype: 'button',
        text: 'View',
        id: 'submitId',
        cls: 'buttonStyle',
        width: 60,
        handler: function() {
            buttonFunction();
        }
        }]
    });

    var durationpanel2 = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'durationpanel2Id',
        layout: 'table',
        frame: true,
        hidden: true,
        width: screen.width - 35,
        
        layoutConfig: {
            columns: 10

        },
        items: [{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab2',
            width: 200,
            text: '<%=StartMonthYear%>' + ' :'
        }, {
            width: 25
        }, {
            xtype: 'datefield',
            width: 160,
           format:getMonthYearFormat(),      
            plugins: 'monthPickerPlugin',
            emptyText: '<%=SelectStartDate%>',
            allowBlank: false,
            blankText: '<%=SelectStartDate%>',
            id: 'startdate2',
            value: prevmonth,               
            vtype: 'daterange',
            cls: 'selectstylePerfect',
            endDateField: 'enddate'
        }, {
            width: 165
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'enddatelab2',
            width: 200,
            text: '<%=EndMonthYear%>' + ' :'
        }, {
            width: 1
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 160,
            format:getMonthYearFormat(),      
            plugins: 'monthPickerPlugin',
            emptyText: '<%=SelectEndDate%>',
            allowBlank: false,
            blankText: '<%=SelectEndDate%>',
            id: 'enddate2',
           value: currmonth,               
            vtype: 'daterange',
            startDateField: 'startdate'
        },{width:180},{
        xtype: 'button',
        text: 'View',
        id: 'submitId2',
        cls: 'buttonStyle',
        width: 60,
        handler: function() {
          buttonFunction();
        }
        }]
    });
function buttonFunction(){

            var clientName = Ext.getCmp('custcomboId').getValue();
            var startdate = Ext.getCmp('startdate').getValue();
            var enddate = Ext.getCmp('enddate').getValue();
            
         if(Ext.getCmp('reportTypeComboId').getValue() == 3 ){
         var date1=Ext.getCmp('startdate2').getValue();
         var year1= date1.getFullYear();
         var month1 = date1.getMonth();
         var date2=Ext.getCmp('enddate2').getValue();
         var year2= date2.getFullYear();
         var month2 = date2.getMonth();
 
             startdate = month1+"-"+year1;
             enddate =  month2+"-"+year2;
            }
            
            if (Ext.getCmp('custcomboId').getValue() == "") {
                Ext.example.msg("<%=PleaseSelectCustomer%>");
                Ext.getCmp('custcomboId').focus();
                return;
            }
            if (Ext.getCmp('reportTypeComboId').getValue() == "") {
                Ext.example.msg("<%=PleaseSelectReportType%>");
                Ext.getCmp('reportTypeComboId').focus();
                return;
            }
            if (Ext.getCmp('reportTypeComboId').getValue() == 2 || Ext.getCmp('reportTypeComboId').getValue() == 1) {
                if (Ext.getCmp('startdate').getValue() == "") {
                    Ext.example.msg("<%=PleaseSelectStartDate%>");
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
                    Ext.example.msg("<%=PleaseSelectEndDate%>");
                    Ext.getCmp('enddate').focus();
                    return;
                }
                if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                    Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                    Ext.getCmp('enddate').focus();
                    return;
                }
                if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                    Ext.example.msg("<%=monthValidation%>");
                    Ext.getCmp('enddate').focus();
                    return;
                }
            }
               if (Ext.getCmp('reportTypeComboId').getValue() == 3) {
                if (Ext.getCmp('startdate2').getValue() == "") {
                    Ext.example.msg("<%=PleaseSelectStartDate%>");
                    Ext.getCmp('startdate2').focus();
                    return;
                }
                 if (Ext.getCmp('enddate2').getValue() == "") {
                    Ext.example.msg("<%=PleaseSelectEndDate%>");
                    Ext.getCmp('enddate2').focus();
                    return;
                }
                if (dateCompare(Ext.getCmp('startdate2').getValue(), Ext.getCmp('enddate2').getValue()) == -1) {
                    Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                    Ext.getCmp('enddate2').focus();
                    return;
                }
               }
           
            store.load({
                params: {
                    CustId: Ext.getCmp('custcomboId').getValue(),
                    custName: Ext.getCmp('custcomboId').getRawValue(),
                    startDate: startdate,
                    endDate: enddate,
                    jspName: reportName,
                    type: Ext.getCmp('reportTypeComboId').getValue()
                }
            });
}
    var reader = new Ext.data.JsonReader({
        idProperty: 'ticketSummaryReportId',
        root: 'ticketSummaryReport',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'scheduledDateIndex'
        }, {
            name: 'noOfBusIndex'
        }, {
            name: 'terminalNameIndex'
        }, {
            name: 'consumerBookingByWebIndex'
        }, {
            name: 'consumerBookingByMobileIndex'
        }, {
            name: 'UserBookingBywebIndex'
        }, {
            name: 'UserBookingByMobileIndex'
        }, {
            name: 'totalTicketsBookedIndex'
        }, {
            name: 'routeNameIndex'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TicketSummaryReportAction.do?parameter=getTicketSummaryReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'ticketSummaryReport',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'date',
            dataIndex: 'scheduledDateIndex'
        }, {
             type: 'numeric',
            dataIndex: 'noOfBusIndex'
        }, {
             type: 'string',
            dataIndex: 'terminalNameIndex'
        }, {
            type: 'string',
            dataIndex: 'routeNameIndex'
        },{
             type: 'numeric',
            dataIndex: 'consumerBookingByWebIndex'
        },{
            type: 'numeric',
            dataIndex: 'consumerBookingByMobileIndex'
        }, {
            type: 'numeric',
            dataIndex: 'UserBookingBywebIndex'
        }, {
            type: 'numeric',
            dataIndex: 'UserBookingByMobileIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalTicketsBookedIndex'
        }
        ]
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
            }, {
                header: "<span style=font-weight:bold;><%=ScheduledDate%></span>",
                dataIndex: 'scheduledDateIndex',
                width: 100,
                filter: {
                    type: 'date'
                }
            },  {
                header: "<span style=font-weight:bold;><%=NoOfBus%></span>",
                dataIndex: 'noOfBusIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },  {
                header: "<span style=font-weight:bold;><%=TerminalName%></span>",
                dataIndex: 'terminalNameIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=RouteName%></span>",
                dataIndex: 'routeNameIndex',
                width: 200,
                filter: {
                    type: 'string'
                    }
                }, {
                header: "<span style=font-weight:bold;><%=ConsumerBookingByWeb%></span>",
                dataIndex: 'consumerBookingByWebIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=ConsumerBookingByMobile%></span>",
                dataIndex: 'consumerBookingByMobileIndex',
                width: 100,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=UserBookingByWeb%></span>",
                dataIndex: 'UserBookingBywebIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=UserBookingByMobile%></span>",
                dataIndex: 'UserBookingByMobileIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TotalTicketsBooked%></span>",
                dataIndex: 'totalTicketsBookedIndex',
                width: 100,
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

        headerPanel = new Ext.Panel({
         title:'<%=TicketSummaryReport%>',
        width: screen.width - 35,
        height:40,
        id:'headerpanelId',
            standardSubmit: true,
            frame: false,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [] 
        });

    var grid = getGrid('', '<%=NoRecordsfound%>', store, screen.width - 35, 340, 15, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
 function getMonthYearFormat(){
		return 'F Y';
	}
    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '<%=TicketSummaryReport%>',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, durationpanel1, durationpanel2, headerPanel,grid]
  
        });
        sb = Ext.getCmp('form-statusbar');


    });
 
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->