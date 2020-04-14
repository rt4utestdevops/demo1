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

tobeConverted.add("SMS_Report");
tobeConverted.add("SMS_Report_to_Parent");
tobeConverted.add("SLNO");
tobeConverted.add("Vehicle_No");
tobeConverted.add("SMS_Trigger_Time");
tobeConverted.add("Parent_Name");
tobeConverted.add("Contact_No");
tobeConverted.add("Message");
tobeConverted.add("Route_and_Type");
tobeConverted.add("Driver_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("View");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SMSReport = convertedWords.get(0);
String SMSReportDetails = convertedWords.get(1);
String SLNO = convertedWords.get(2);
String VehicleNO = convertedWords.get(3);
String RouteandType = convertedWords.get(4);
String ParentName = convertedWords.get(5);
String ContactNo  = convertedWords.get(6);
String Message = convertedWords.get(7);
String SMSTriggerTime = convertedWords.get(8);
String DriverName = convertedWords.get(9);
String StartDate = convertedWords.get(10);
String EndDate = convertedWords.get(11);
String selectCustomerName = convertedWords.get(12);
String CustomerName = convertedWords.get(13);
String NoRecordsFound = convertedWords.get(14);
String ClearFilterData = convertedWords.get(15);
String SelectStartDate = convertedWords.get(16);
String SelectEndDate = convertedWords.get(17);
String MonthValidation = convertedWords.get(18);
String View = convertedWords.get(19);
%>

<jsp:include page="../Common/header.jsp" />
 		<title></title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
    <style>
	
		label {
				display : inline !important;
		}
		.ext-strict .x-form-text {
			height : 21px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		
   </style>
   <script>
   
var prevDate = previousDate; 
var curDate = currentDate;
var outerPanel;
var ctsb;
var jspName = "SMSReport";
var exportDataType = "int,String,String,String,String,String,String,String";
var selected;
var grid;

var ClientStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'ClientStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    			store: ClientStore,
    			id: 'custcomboId',
    			mode: 'local',
    			forceSelection: true,
    			emptyText: '<%=selectCustomerName%>',
    			blankText: '<%=selectCustomerName%>',
    			selectOnFocus: true,
    			allowBlank: false,
    			anyMatch: true,
    			typeAhead: false,
    			triggerAction: 'all',
    			lazyRender: true,
    			valueField: 'CustId',
    			displayField: 'CustName',
    			cls: 'selectstylePerfect',
    			/*listeners: {
        			select: {
            			fn: function () {
                		 custId = Ext.getCmp('custcomboId').getValue();
                			store.load({
                    			params: {
                        			CustId: custId
                    			}
                			});
            		  	}
        			}
    			}*/
			});
			
var ClientPanel = new Ext.Panel({
    				     standardSubmit: true,
    					 collapsible: false,
    					 id: 'customerComboPanelId',
    					 layout: 'table',
    					 frame: true,
    					 title:'<%=SMSReport%>',
    					 width: screen.width - 27,
    					 height: 90,
    					 layoutConfig: {
        						columns: 13
    					 },
    					 items: [{
            	xtype: 'label',
            	text: '<%=CustomerName%>' + ' :',
            	cls: 'labelstyle'
        	},
        	Client,{width:30},
        	{
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
  		        value: prevDate,
  		        endDateField: 'enddate'
  		    },{width: 60}, 
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
  		        value:curDate,
  		        startDateField: 'startdate'
  		    },{width: 30},
  		    {
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=selectCustomerName%>");
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
  		                            Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                jspName:jspName
                                    }
                                });
  		                    }
  		                }
  		            }
  		    },{width:30}
    ]
					 });
			
					 
//Decleration of Reader
var reader = new Ext.data.JsonReader({
    idProperty: 'SMSReportId',
    root: 'SMSReporRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    }, {
        name: 'vehicleNoDataIndex'
    }, {
        name: 'routeandTypeDataIndex'
    }, {
        name: 'parentNameDataIndex'
    }, {
        name: 'contactNoDataIndex'
    }, {
        name: 'messageDataIndex'
    }, {
        name: 'smsTriggerTimeDataIndex'
    }, {
        name: 'driverNameDataIndex'
    }]
});


//Decleration of Grid Store
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SMSReportAction.do?param=getSMSReport',
        method: 'POST'
    }),
    storeId: 'SMSId',
    reader: reader
});

//Decleration of Filter
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'routeandTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'parentNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'contactNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'messageDataIndex'
    }, {
        type: 'string',
        dataIndex: 'smsTriggerTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'driverNameDataIndex'
    }]
});


//Decleration of Column Module
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleNO%></span>",
            dataIndex: 'vehicleNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RouteandType%></span>",
            dataIndex: 'routeandTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ParentName%></span>",
            dataIndex: 'parentNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ContactNo%></span>",
            dataIndex: 'contactNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Message%></span>",
            dataIndex: 'messageDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SMSTriggerTime%></span>",
            dataIndex: 'smsTriggerTimeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DriverName%></span>",
            dataIndex: 'driverNameDataIndex',
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
//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=SMSReportDetails%>', '<%=NoRecordsFound%>', store, screen.width - 25, 440, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '', jspName, exportDataType, true, '', false, '', false, '', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: false,
        width: screen.width-25,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [ClientPanel, grid]
    });
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

