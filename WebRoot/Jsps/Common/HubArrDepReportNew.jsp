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
	Date date=new Date();
	SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	String startDate=sdfddmmyyyy.format(date)+" 00:00:00";
    String endDate=cf.setNextDateForReports()+" 00:00:00";
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Preventive_Services_Report");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("SLNO");
tobeConverted.add("Registration_No");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Hub_Arrival_Hub_Departure_Report");
tobeConverted.add("Details");
tobeConverted.add("Location");
tobeConverted.add("Actual_Arrival");
tobeConverted.add("Actual_Departure");
tobeConverted.add("Detention_Duration(HH:MM)");
tobeConverted.add("Owner_Name");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String PreventiveMaintenanceReport=convertedWords.get(0);
String StartDate=convertedWords.get(1);
String EndDate=convertedWords.get(2);
String SLNO=convertedWords.get(3);
String AssetNumber=convertedWords.get(4);
String Excel=convertedWords.get(5);
String PDF=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String NoRecordsfound=convertedWords.get(8);
String HubArrDep=convertedWords.get(9);
String Details=convertedWords.get(10);
String Location=convertedWords.get(11);
String ActualArrival=convertedWords.get(12);
String ActualDeparture=convertedWords.get(13);
String Detention=convertedWords.get(14);
String OwnerName=convertedWords.get(15);
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 		<title><%=HubArrDep%></title>		
</head>	    

  <body onLoad="gridload();">
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>     
    <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <script>
   var outerPanel;
  var dtprev = dateprev;
  var dtcur = datecur;
  var jspName = "HubArrivalHubDepartureReport";
  var exportDataType = "int,string,string,string,string,string,string";
  var startDate = "";
  var endDate = "";
  var grid;
  var dtcur = datecur+" 00:00:00";
  var dtnext = datenext+" 00:00:00";
  
  
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
      items: [{
              
                html: '<div align=right><b><%=StartDate%> :</b></div>',
                cellCls: 'col'

            },
              {
             html: '<%=startDate%>',
                cellCls: 'col'
          },
          {
              width: 200
          },
            {
               html: '<div align=right><b><%=EndDate%> :</b></div>',
                cellCls: 'col'
          }, {
             html: '<%=endDate%>',
                cellCls: 'col'
          }, {
              width: 80
          }
      ]
  });
  
 

  var reader = new Ext.data.JsonReader({
     // idProperty: 'hubArrDepId',
      root: 'hubArrDepNewRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'assetNumberDataIndex'
      }, {
          name: 'locationIndex'
      }, {
          name: 'actualarrivalIndex'
      }, {
          name: 'actualdepartureIndex'
      }, {
          name: 'detentionIndex'
      }, {
          name: 'ownernameIndex'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getHubArrDepReportNew',
          method: 'POST'
      }),
      autoLoad: false,
      remoteSort: true,
     // storeId: 'hubArrDepreport',
      reader: reader
  });
  
   
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'assetNumberDataIndex'
      }, {
          type: 'string',
          dataIndex: 'locationIndex'
      }, {
          type: 'date',
          dataIndex: 'actualarrivalIndex'
      }, {
          type: 'date',
          dataIndex: 'actualdepartureIndex'
      }, {
          type: 'numeric',
          dataIndex: 'detentionIndex'
      }, {
          type: 'string',
          dataIndex: 'ownernameIndex'
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
              dataIndex: 'assetNumberDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Location%></span>",
              dataIndex: 'locationIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ActualArrival%></span>",
              dataIndex: 'actualarrivalIndex',
              width: 100,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ActualDeparture%></span>",
              dataIndex: 'actualdepartureIndex',
              width: 100,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Detention%></span>",
              dataIndex: 'detentionIndex',
              width: 100,
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;><%=OwnerName%></span>",
              dataIndex: 'ownernameIndex',
              width: 100,
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
  
  var grid = getGrid('<%=Details%>', '<%=NoRecordsfound%>', store, screen.width - 35, 430, 8, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
  
 function gridload()
  {
  store.load({params:{jspName:jspName} });
  }
  Ext.onReady(function () {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title:'<%=HubArrDep%>',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [clientPanel, grid],
          bbar: ctsb
      });
      sb = Ext.getCmp('form-statusbar');
          
  }); 
   </script>
 </body>
</html>