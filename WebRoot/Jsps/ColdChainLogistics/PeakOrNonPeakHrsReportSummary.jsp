<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Peak_or_Non-Peak_Hrs_Report_Summary");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Submit");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Select_Customer");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("Excel");
tobeConverted.add("SLNO");
tobeConverted.add("Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Time_Zone");
tobeConverted.add("Count");
	
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
String PeakOrNonPeakReportSummary=convertedWords.get(0);
String StartDate=convertedWords.get(1);
String EndDate=convertedWords.get(2);
String SelectStartDate=convertedWords.get(3);
String SelectEndDate=convertedWords.get(4);
String Submit=convertedWords.get(5);
String SelectCustomerName=convertedWords.get(6);
String SelectCustomer=convertedWords.get(7);
String NoRecordsFound=convertedWords.get(8);
String ClearFilterData=convertedWords.get(9);
String Add=convertedWords.get(10);
String Excel=convertedWords.get(11);
String SLNO=convertedWords.get(12);
String Date=convertedWords.get(13);
String monthValidation=convertedWords.get(14);
String TimeZone=convertedWords.get(15); 
String Count=convertedWords.get(16);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=PeakOrNonPeakReportSummary%></title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%}%>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
    var outerPanel;
    var jspName = "";
    var exportDataType = "";
    var grid;
    var buttonValue;
    var custId = "";
    var custName = "";
   
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>' ,
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
                   custName=Ext.getCmp('custcomboId').getRawValue();
              }     
                  
           }
       }
    });
    

 //***************************************************************************************************************//
  
var menuPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 40,
    height: 40,
    layoutConfig: {
        columns: 20
    },
    items: [{
               xtype: 'label',
               text: '<%=SelectCustomer%>' + ' :',
               cls: 'labelstyle',
               id: 'ltspcomboId'
           },
          custnamecombo, {
               width: 52
           },{
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'startdatelab',
  				text: '<%=StartDate%>' + ' :'
  			},{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectStartDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectStartDate%>',
  		        id: 'startdate',
  		        vtype: 'daterange',
  		        endDateField: 'enddate'
  		    },{width: 52}, 
  		    {
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'enddatelab',
  		        text: '<%=EndDate%>' + ' :'
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectEndDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectEndDate%>',
  		        id: 'enddate',
  		        vtype: 'daterange',
  		        startDateField: 'startdate'
  		    },{width: 40},
  		    {
  		        xtype: 'button',
  		        text: '<%=Submit%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		               	   fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomerName%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('startdate').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('startdate').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('enddate').getValue() == "") {
  		                        Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('startdate').getValue();
  		                        var enddates = Ext.getCmp('enddate').getValue();
  		                        
  		                        
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                        Ext.example.msg("<%=monthValidation%>");
  		                            Ext.getCmp('enddate').focus();  		                            	
  		                            return;
  		                        }
  		                        peakOrNonPeakStore.removeAll();  		                      
								peakOrNonPeakStore.load({
                                    params: {
                                        CustId: custId,
  		                              	startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                jspName:jspName
                                    }
                                });  	               
  		                    }
  		                }
  		            }
  		    	}
		    ]
		}); 


		     //******************grid config starts********************************************************
		// **********************reader configs 
var reader = new Ext.data.JsonReader({
    idProperty: 'storeId',
    root: 'peakOrNonPeakReportSummaryReader',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'dateIndex',
        type: 'date',
        dateFormat: getDateFormat()
    },{
        name: 'TimeZoneIndex'
    },  {
        name: 'CountDataIndex'
    }]
});


var peakOrNonPeakStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
    url: '<%=request.getContextPath()%>/peakOrNonPeakReport.do?param=getPickOrNonPickReportSummary',
        method: 'POST'
    }),
    storeId: 'storeId',
    reader: reader
});


var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'date',
        dataIndex: 'dateIndex'
    }, {
        type: 'string',
        dataIndex: 'TimeZoneIndex'
    },{
        type: 'int',
        dataIndex: 'CountDataIndex'
    }]
 }); 
 
 
 var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }),{
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'dateIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=Date%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                 type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TimeZone%></span>",
            dataIndex: 'TimeZoneIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Count%></span>",
            dataIndex: 'CountDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }];
    	return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            		sortable: true
        		}
   		 });
};     
 

grid = getGrid('<%=PeakOrNonPeakReportSummary%>', '<%=NoRecordsFound%>', peakOrNonPeakStore, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, '', false, '<%=Add%>');

Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=PeakOrNonPeakReportSummary%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 510,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
      items: [menuPanel,grid]
    });    
    
    });
 
</script>
</body>
</html>
<%}%>