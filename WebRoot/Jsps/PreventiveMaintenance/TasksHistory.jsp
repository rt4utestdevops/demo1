<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	loginInfo.setCategory(str[4].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>5){
	loginInfo.setCustomerName(str[5].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}

LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Asset_Number");
tobeConverted.add("Service_Name");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Tasks_History");
tobeConverted.add("Alert_Type");
tobeConverted.add("Event_Date");
tobeConverted.add("Last_Service_Date");
tobeConverted.add("Renewed_By");
tobeConverted.add("Remarks");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String AssetNumber=convertedWords.get(1);
String ServiceName=convertedWords.get(2);
String ClearFilterData=convertedWords.get(3);
String TasksHistory=convertedWords.get(4);
String AlertType=convertedWords.get(5);
String EventDate=convertedWords.get(6);
String LastServiceDate=convertedWords.get(7);
String RenewedBy=convertedWords.get(8);
String Remarks=convertedWords.get(9);
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title><%=TasksHistory%></title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body onload="bdLd()">
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   var outerPanel;
   var ctsb;
   var jspName = "TasksHistory";
   var exportDataType = "";
   var selected;
   var grid;
   var assetNumber = parent.globalAssetNumber;
   var assetId = parent.globalAssetId;
   var customerId = parent.custId;

   var reader = new Ext.data.JsonReader({
       idProperty: 'taskMasterid',
       root: 'tasksHistoryRoot',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'assetDataIndex'
       }, {
           name: 'taskNameIndex'
       }, {
           name: 'lastServiceDateDataIndex'
       },{
           name: 'ServiceDateDataIndex',
             type: 'date',
  		   dateFormat: 'd-m-Y'
       }, {
           name: 'eventParamDataIndex'
       }, {
           name: 'alertTypeDataIndex'
       },{
           name: 'remarksDataIndex'
       }
       ]
   });

   function bdLd() {
       historyTasksStore.load({
           params: {
               CustId: customerId,
               assetNumber: assetNumber

           }
       });
   }

   var historyTasksStore = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getTasksHistoryDetails',
           method: 'POST'
       }),
       storeId: 'taskMasterid',
       reader: reader
   });

   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'assetDataIndex'
       }, {
           type: 'string',
           dataIndex: 'taskNameIndex'
       }, {
           type: 'date',
           dataIndex: 'lastServiceDateDataIndex'
       }, {
           type: 'date',
           dataIndex: 'ServiceDateDataIndex'
       }, {
           type: 'string',
           dataIndex: 'eventParamDataIndex'
       }, {
           type: 'int',
           dataIndex: 'alertTypeDataIndex'
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
           }), {
               dataIndex: 'slnoIndex',
               hidden: true,
               header: "<span style=font-weight:bold;><%=SLNO%></span>",
               filter: {
                   type: 'numeric'
               }
           }, {
               header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
               dataIndex: 'assetDataIndex',
               width: 120,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=ServiceName%></span>",
               dataIndex: 'taskNameIndex',
               width: 120,
               filter: {
                   type: 'string'
               }
           }, {
               dataIndex: 'lastServiceDateDataIndex',
               header: "<span style=font-weight:bold;><%=LastServiceDate%></span>",
               width: 260,
               hidden:true,
               filter: {
                   type: 'date'
               }
           }, {
               dataIndex: 'ServiceDateDataIndex',
               header: "<span style=font-weight:bold;>Service Date</span>",
               renderer: Ext.util.Format.dateRenderer(getDateFormat()),
               width: 260,
               filter: {
                   type: 'date'
               }
           },{
               dataIndex: 'eventParamDataIndex',
               header: "<span style=font-weight:bold;><%=RenewedBy%></span>",
               filter: {
                   type: 'string'
               }
           }, {
               dataIndex: 'alertTypeDataIndex',
               header: "<span style=font-weight:bold;><%=AlertType%></span>",
               filter: {
                   type: 'int'
               }
           },{
               dataIndex: 'remarksDataIndex',
               header: "<span style=font-weight:bold;><%=Remarks%></span>",
               filter: {
                   type: 'string'
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
    //*****************************************************************Grid********************************************************************************
   grid = getGrid('', 'NoRecordsFound', historyTasksStore, screen.width - 360, 360, 11, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '', false, '', false, '');
    //******************************************************************************************************************************************************
   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           //title: 'Service history details',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [grid]
           //bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');

   });</script>
</body>
</html>
    
    
    
    
    

