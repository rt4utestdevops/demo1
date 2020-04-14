<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"😕/"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(12);
loginInfo.setUserId(1);
loginInfo.setLanguage("en");  
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setStyleSheetOverride("Y");

if(loginInfo==null){
response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);	
String language="en";

CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
  responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
session.setAttribute("responseaftersubmit",null);
}

int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();		

	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Vertical_Summary_Report");
tobeConverted.add("Vertical_Details");
tobeConverted.add("Report_Type");
tobeConverted.add("SLNO");
tobeConverted.add("Region_Name");
tobeConverted.add("Ltsp_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Vertical_Name");
tobeConverted.add("Vehicle_Count");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Select_Report_Type");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String VerticalSummaryReport=convertedWords.get(0);
String VerticalDetails=convertedWords.get(1);
String ReportType=convertedWords.get(2);
String SLNO=convertedWords.get(3);
String RegionName=convertedWords.get(4);
String LtspName=convertedWords.get(5);
String CustomerName=convertedWords.get(6);
String VerticalName=convertedWords.get(7);
String VehicleCount=convertedWords.get(8);
String Excel=convertedWords.get(9);
String PDF=convertedWords.get(10);
String ClearFilterData=convertedWords.get(11);
String NoRecordsfound=convertedWords.get(12);
String SelectReportType=convertedWords.get(13);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html >
  <head>
    <html>
    
    <title>VerticalSummaryReport</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
   <jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script type="text/javascript">
   
   var outerPanel;
   var jspName = "VerticalSummaryReport"; 
   var grid;
   var exportDataType="int,String,String,String,Sting,int";
   var Type;
   var value;
   var ReportName;
   var reportName;
   
   var reportTypeStore = new Ext.data.SimpleStore({
      id: 'reportTypeStoreId',
      autoLoad: true,
      fields: ['Name', 'Value'],
      data: [
          ['VERTICAL', '1'],
          ['LTSP', '2'],
          ['REGION', '3']
      ]
  });
  
  var reportTypeCombo = new Ext.form.ComboBox({
      store: reportTypeStore,
      id: 'reportTypeComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=SelectReportType%>',
      displayField: 'Name',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function () {
                   value = Ext.getCmp('reportTypeComboId').getValue();
                  if (Ext.getCmp('reportTypeComboId').getValue() == 1) {
                  		 ReportName="VERTICAL";
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('verticalNameDataIndex'),false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleCountDataIndex'),false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('LTSPNameDataIndex'),true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerNameDataIndex'),true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('RegionNameDataIndex'), true);
                  }
                  if (Ext.getCmp('reportTypeComboId').getValue() == 2) {
                       ReportName="LTSP";
                       grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('LTSPNameDataIndex'),false);
                       grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerNameDataIndex'),false);
                       grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('verticalNameDataIndex'),false);
                       grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleCountDataIndex'),false);
                       grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('RegionNameDataIndex'),true);
                  }
                  
                  if (Ext.getCmp('reportTypeComboId').getValue() == 3) {
                        ReportName="REGION";
                         grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('RegionNameDataIndex'),false);
                         grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('LTSPNameDataIndex'),false);
                         grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerNameDataIndex'),false);
                         grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('verticalNameDataIndex'),false);
                         grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleCountDataIndex'),false);
                  }
                  
                      store.load({
                    			params: {
                        					Type: value,
                        					 ReportName:ReportName,
                        					JspName:jspName
                   						 }
               					 });
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
      height: 40,
      layoutConfig: {
          columns: 7
      },
      items: [ {
                xtype: 'label',
                text: '<%=ReportType%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab'
               },
                reportTypeCombo, {
                width: 10
               }
             ]
  });
  
  var reader = new Ext.data.JsonReader({
    idProperty: '',
    root: 'verticalReport',
    totalProperty: 'total',
     fields: [{
        name: 'slnoIndex'
    }, {
        name: 'RegionNameDataIndex'
    }, {
        name: 'LTSPNameDataIndex'
    }, {
        name:  'customerNameDataIndex'
    }, {
        name: 'verticalNameDataIndex'
    }, {
        name: 'vehicleCountDataIndex'
    } ]
});

   var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/VerticalSummaryAction.do?param=getVerticalSummaryReport',
          method: 'POST',
      }),
      remoteSort: false,
      storeId: 'VerticalSummaryreport',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'RegionNameDataIndex'
    }, {
        type: 'string',
        dataIndex:  'LTSPNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'customerNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'verticalNameDataIndex'
    }, {
        type: 'numeric',
        dataIndex:  'vehicleCountDataIndex'
    }]
});  
  
   var createColModel = function (finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }), 
          {
             dataIndex: 'slnoIndex',
              hidden: true,
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              filter: {
                  type: 'numeric'
              }
          },  {
              header: "<span style=font-weight:bold;><%=RegionName%></span>",
              dataIndex: 'RegionNameDataIndex',
              width: 300,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=LtspName%></span>",
              dataIndex: 'LTSPNameDataIndex',
              width: 300,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=CustomerName%></span>",
               dataIndex: 'customerNameDataIndex',
              width: 300,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=VerticalName%></span>",
               dataIndex: 'verticalNameDataIndex',
              width: 300,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=VehicleCount%></span>",
           dataIndex: 'vehicleCountDataIndex',
              width: 300,
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
  
  grid = getGrid('<%=VerticalDetails%>', '<%=NoRecordsfound%> ', store, screen.width -140, 450, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');  
 
    Ext.onReady(function () {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title:'<%=VerticalSummaryReport%>',
          renderTo: 'content',
          standardSubmit: true,
          height:550,
           width : screen.width -130,
          frame: true,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [clientPanel,grid]
      });
  });
  
</script>
  </body>
</html>
<%}%>