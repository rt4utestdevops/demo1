<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
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

	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Peak_or_Non-Peak_Hrs_Report_Details");
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
tobeConverted.add("Retailer_Name");
tobeConverted.add("Asset_No");
tobeConverted.add("Asset_Type");
tobeConverted.add("Start_Time");
tobeConverted.add("End_Time");
tobeConverted.add("Time_Zone");
tobeConverted.add("Month_Validation");
tobeConverted.add("Address");
	
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
String PeakorNonPeakHrsReportDetails=convertedWords.get(0);
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
String RetailorName=convertedWords.get(13);
String AssetNo=convertedWords.get(14);
String AssetType=convertedWords.get(15);
String StartTime=convertedWords.get(16);
String EndTime=convertedWords.get(17);
String TimeZone=convertedWords.get(18);
String MonthValidation=convertedWords.get(19);
String Address=convertedWords.get(20); 

%>
	
<!DOCTYPE HTML>
<html class="largehtml">

<head>
    <title><%=PeakorNonPeakHrsReportDetails%> </title>
    <style>
	.x-panel-tl {
    	border-bottom: 0px solid !important;
		}
	</style>
</head>

<body>
    <%if (loginInfo.getStyleSheetOverride().equals( "Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else{%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%}%>
                <jsp:include page="../Common/ExportJS.jsp" />
<script>
var jspName="PeakorNon-PeakHrsReportDetails";
var exportDataType="int,string,string,string,date,date,string,string";
var grid;
var outerPanel;
var startDate="";
var endDate="";

var reader = new Ext.data.JsonReader({
    idProperty: 'PeakOrNonPeakHrsReportDetailsId',
    root: 'peakOrNonPeakReportDetailsReader',
    totalProperty: 'total',
    fields: [{
    	name: 'SLNODataIndex'
    },{
        name: 'retailorNameDataIndex'
    },{
        name: 'assetNoDataIndex'
    },  {
        name: 'assetTypeDataIndex'
    },  {
        name: 'startTimeDataIndex',
        type: 'date'
    },{
        name: 'endTimeDataIndex',
	    type: 'date'
    }, {
        name: 'timeZoneDataIndex'
    }, {
        name: 'addressDataIndex'
    }]
});    

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
    url: '<%=request.getContextPath()%>/peakOrNonPeakReport.do?param=getPeakorNonPeakHrsReportsDetails',
        method: 'POST'
    }),
    storeId: 'storeId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
    	type:'int',
    	dataIndex: 'SLNODataIndex'
    },{
        type: 'string',
        dataIndex: 'retailorNameDataIndex'
    },  {
        type: 'string',
        dataIndex: 'assetNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'assetTypeDataIndex'
    }, {
        type: 'date',
        dataIndex: 'startTimeDataIndex'
    },{
        type: 'date',
        dataIndex: 'endTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'timeZoneDataIndex'
    },{
        type: 'string',
        dataIndex: 'addressDataIndex'
    }]
 }); 
 
 var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }),{
			header:"<span style=font-weight:bold;><%=SLNO%></span>",
			hidden: true,
			dataIndex: 'SLNODataIndex',
			filter: {
				type: 'numeric'
			}        
       	},{
            header: "<span style=font-weight:bold;><%=RetailorName%></span>",
            dataIndex: 'retailorNameDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetNo%></span>",
            dataIndex: 'assetNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=AssetType%></span>",
            dataIndex: 'assetTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },   {
            header: "<span style=font-weight:bold;><%=StartDate%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            dataIndex: 'startTimeDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=EndDate%></span>",
          	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            dataIndex: 'endTimeDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TimeZone%></span>",
            dataIndex: 'timeZoneDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Address%></span>",
            dataIndex: 'addressDataIndex',
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

grid = getGrid('<%=PeakorNonPeakHrsReportDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '', false, '<%=Add%>');

   var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function() {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
            }
            }
        }
    });
    
var customerCombo = new Ext.form.ComboBox({
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
               }
           }
       }
    });
    
var MenuPanel = new Ext.Panel({
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
    			id:'customercomboid',
    			text: '<%=SelectCustomer%> '+':'
    		},customerCombo,
    		{width:30},{
   		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'startdatelab',
  				text: '<%=StartDate%>' + ' :'
  			},{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        frame: true,
  		        width: 185,
  		        resizable:true,
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
  		    },{width: 52},
  		    {
  		        xtype: 'button',
  		        text: '<%=Submit%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		               	   fn: function () {
  		                        
  		                        if(Ext.getCmp('custcomboId').getValue() ==""){
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
  		                        Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('enddate').focus();  		                            	
  		                            return;
  		                        }
  		                        store.removeAll();  		                      
								store.load({
                                    params: {
                                    	CustId : Ext.getCmp('custcomboId').getValue(),
  		                              	startDate : startdates,
  		                                endDate : enddates,
  		                                jspName : jspName
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
        title: '<%=PeakorNonPeakHrsReportDetails%>',
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
      items: [MenuPanel,grid]
    });
    });
    
</script>
</body>
</html>    