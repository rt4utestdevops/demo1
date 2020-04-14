<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	System.out.println("list contains:"+str.toString());
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
	tobeConverted.add("Customer_History");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("View");
	tobeConverted.add("Select_Customer_Name");
	tobeConverted.add("Customer_Visit_Details");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Add");
	tobeConverted.add("Excel");
	tobeConverted.add("SLNO");
	tobeConverted.add("Employee");
	tobeConverted.add("Company_Name");
	tobeConverted.add("Customer");
	tobeConverted.add("Date_Of_Update");
	tobeConverted.add("Call_Type");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("Remarks");
	
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	

String CustomerVisitHistoryView=convertedWords.get(0);
String CustomerName=convertedWords.get(1);
String StartDate=convertedWords.get(2);
String EndDate=convertedWords.get(3);
String SelectStartDate=convertedWords.get(4);
String SelectEndDate=convertedWords.get(5);
String View=convertedWords.get(6);
String SelectCustomerName=convertedWords.get(7);
String CustomerVisitDetails=convertedWords.get(8);
String NoRecordsFound=convertedWords.get(9);
String ClearFilterData=convertedWords.get(10);
String Add=convertedWords.get(11);
String Excel=convertedWords.get(12);
String SLNO=convertedWords.get(13);
String Employee=convertedWords.get(14);
String CompanyName=convertedWords.get(15);
String Customer=convertedWords.get(16);
String UpdateDate=convertedWords.get(17);
String CallType=convertedWords.get(18);
String monthValidation=convertedWords.get(19);
String Remarks=convertedWords.get(20);

%>
	
<jsp:include page="../Common/header.jsp" /> 
<html class="largehtml">


    <title>
        <%=CustomerVisitHistoryView%>
    </title>    

    <%if (loginInfo.getStyleSheetOverride().equals( "Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else{%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%}%>
                <jsp:include page="../Common/ExportJS.jsp" />
	<style>
		.x-panel-tl {
			border-bottom: 0px solid !important;
		}
		label
		{
			display : inline !important;
		}
		.x-layer ul {
			min-height: 27px !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}		
	</style>
<script>

var jspName="CustomerHistoryReport";
var exportDataType="int,string,string,string,date,string,string";
var grid;
var outerPanel;
var startDate="";
var endDate="";


var reader = new Ext.data.JsonReader({
    idProperty: 'customerVisitHistoryId',
    root: 'customerVisitHistoryRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'companynameDataIndex'
    },  {
        name: 'employeeDataIndex'
    },  {
        name: 'customerDataIndex'
    },{
        name: 'updateDateDataIndex',
	     type: 'date'   
    }, {
        name: 'callTypeDataIndex'
    }, {
        name: 'remarksDataIndex'
    }]
});    

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
    url: '<%=request.getContextPath()%>/CustomerVisitHistoryAction.do?param=getCustomerHistory',
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
    },  {
        type: 'string',
        dataIndex: 'companynameDataIndex'
    },{
        type: 'string',
        dataIndex: 'employeeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'customerDataIndex'
    },{
        type: 'date',
        dataIndex: 'updateDateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'callTypeDataIndex'
    },{
        type: 'string',
        dataIndex: 'remarksDataIndex'
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
        }, {
            header: "<span style=font-weight:bold;><%=CompanyName%></span>",
            dataIndex: 'companynameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Employee%></span>",
            dataIndex: 'employeeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },   {
            header: "<span style=font-weight:bold;><%=Customer%></span>",
            dataIndex: 'customerDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=UpdateDate%></span>",
          	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            dataIndex: 'updateDateDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CallType%></span>",
            dataIndex: 'callTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            dataIndex: 'remarksDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        } ];
    	return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            		sortable: true
        		}
   		 });
};     

grid = getGrid('<%=CustomerVisitDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, true, 'PDF', false, '<%=Add%>');

var datePanel = new Ext.Panel({
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
  		        cls: 'labelstyle',
  		        id: 'startdatelab',
  				text: '<%=StartDate%>' + ' :'
  			},{
  		        xtype: 'datefield',
  		        cls: 'selectstyle',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectStartDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectStartDate%>',
  		        id: 'startdate',
  		        vtype: 'daterange',
  		        endDateField: 'enddate'
  		    },{width: 30}, 
  		    {
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'enddatelab',
  		        text: '<%=EndDate%>' + ' :'
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstyle',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectEndDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectEndDate%>',
  		        id: 'enddate',
  		        vtype: 'daterange',
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
  		                        store.removeAll();  		                      
								store.load({
                                    params: {
                                       
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

Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=CustomerName%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
      items: [datePanel,grid]
    });    
    
    });
    
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
