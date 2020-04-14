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
	int customeridlogged=loginInfo.getCustomerId();
String customerName1="null";
if(customeridlogged>0)
{
customerName1=cf.getCustomerName(String.valueOf(customeridlogged),systemId);
}
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Preventive_Services_Report");
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
tobeConverted.add("New_Expiry_Date");
tobeConverted.add("Alert_Type");
tobeConverted.add("Remarks");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Report_Type");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Vehicle_Id");
tobeConverted.add("Vehicle_Group");
tobeConverted.add("Odometer");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String PreventiveMaintenanceReport=convertedWords.get(0);
String SelectReportType=convertedWords.get(1);
String SelectCustomer=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String ReportType=convertedWords.get(4);
String StartDate=convertedWords.get(5);
String SelectStartDate=convertedWords.get(6);
String EndDate=convertedWords.get(7);
String SelectEndDate=convertedWords.get(8);
String SLNO=convertedWords.get(9);
String AssetNumber=convertedWords.get(10);
String ServiceName=convertedWords.get(11);
String RenewalBy=convertedWords.get(12);
String DueDays=convertedWords.get(13);
String DueMileage=convertedWords.get(14);
String Excel=convertedWords.get(15);
String PDF=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String LastServiceDate=convertedWords.get(18);
String NoRecordsfound=convertedWords.get(19);
String ExpiryDate=convertedWords.get(20);
String AlertType=convertedWords.get(21);
String Remarks=convertedWords.get(22);
String PleaseSelectCustomer=convertedWords.get(23);
String PleaseSelectReportType=convertedWords.get(24);
String PleaseSelectStartDate=convertedWords.get(25);
String PleaseSelectEndDate=convertedWords.get(26);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(27);
String monthValidation=convertedWords.get(28);
String VehicleId=convertedWords.get(29);
String VehicleGroup=convertedWords.get(30);
String Odometer=convertedWords.get(31);
String clientID=request.getParameter("cutomerID");
String alertType=request.getParameter("AlertType");

%>

<!DOCTYPE HTML>
<html class="largehtml">
	<head>
		<title><%=PreventiveMaintenanceReport%></title>
	</head>
	<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
</style>
	<body onLoad=" bdLd();gridload();">
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />

		<script>
    var dt;
    var dt1=dateprev;
    var path="Telematics4uApp"; 
    var basepath="http://localhost:8080/Telematics4uApp/";
    
  if((<%= alertType %>==1))
       {
         dt = new Date().add(Date.DAY, -90); //3 months back from current date
       } 
   else
      {
          dt = dt1;      // -1 day from current day  
      }
   
 
   var outerPanel;
  var dtprev = dt;
  
  var dtcur = datecur;
  var jspName = "PreventiveServicesReport";
  var exportDataType = "int,string,string,string,string,date,string,string,string,date,number,string,string,date";
  var startDate = "";
  var endDate = "";
  var newDate = new Date().add(Date.DAY, -1);
  var grid;
 
  var reportTypeStore = new Ext.data.SimpleStore({
      id: 'reportTypeStoreId',
      autoLoad: true,
      fields: ['Name', 'Value'],
      data: [
          ['Due For Renewal', '2'],
          ['Service OverDue', '1'],
          ['Service History', '3']
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
                 Ext.getCmp('startdate').setValue(newDate);
                  if (Ext.getCmp('reportTypeComboId').getValue() == 3) {
                      Ext.getCmp('startdate').show();
                      Ext.getCmp('enddate').show();
                      Ext.getCmp('startdatelab').show();
                      Ext.getCmp('enddatelab').show();
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('assetNumberDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('serviceNameDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('lastServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('ServiceDateDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('renewalByDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueDaysDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueMileageDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('expiryDateDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('alertTypeDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remarksDataIndex'), false);
                      store.load();
                  }
                  if (Ext.getCmp('reportTypeComboId').getValue() == 2) {
                      Ext.getCmp('startdatelab').hide();
                      Ext.getCmp('startdate').hide();
                      Ext.getCmp('enddatelab').hide();
                      Ext.getCmp('enddate').hide();
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('assetNumberDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('serviceNameDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('lastServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('ServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('renewalByDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueDaysDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueMileageDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('expiryDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('alertTypeDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remarksDataIndex'), true);
                      store.load();
                  }
                  if (Ext.getCmp('reportTypeComboId').getValue() == 1) {
                      Ext.getCmp('startdatelab').show();
                      Ext.getCmp('startdate').show();
                      Ext.getCmp('enddatelab').show();
                      Ext.getCmp('enddate').show();
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('assetNumberDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('serviceNameDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('lastServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('ServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('renewalByDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueDaysDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueMileageDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('expiryDateDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('alertTypeDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remarksDataIndex'), true);
                      store.load();
                  }
              }
          }
      }
  });
  
  var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
      id: 'CustomerStoreId',
      root: 'CustomerRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['CustId', 'CustName'],
      listeners: {
          load: function (custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
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
              fn: function () {
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                 Ext.getCmp('reportTypeComboId').setValue('1');
                     grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('assetNumberDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('serviceNameDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('lastServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('ServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('renewalByDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueDaysDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueMileageDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('expiryDateDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('alertTypeDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remarksDataIndex'), true);
   
 
                  store.load();
                      Ext.getCmp('startdate').show();
                      Ext.getCmp('enddate').show();
                      Ext.getCmp('startdatelab').show();
                      Ext.getCmp('enddatelab').show();

                  if ( <%= customerId %> > 0) {
                      Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                      custId = Ext.getCmp('custcomboId').getValue();
                      custName = Ext.getCmp('custcomboId').getRawValue();
                  }
              }
          }
      }
  });

  function gridload()
  {
  
  var custid=<%=clientID%>;
  var typeid=<%=alertType%>;
  var combo = Ext.getCmp('reportTypeComboId');
  combo.setValue(typeid);
  if(typeid!=null)
  {
 
  store.load({
              params: {
                  CustId:custid ,
                  custName:'<%=customerName1%>',
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName,
                  type: typeid
              }
          });
          }
  }
  function bdLd() {
  Ext.getCmp('reportTypeComboId').setValue('1');
                     grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('assetNumberDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('serviceNameDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('lastServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('ServiceDateDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('renewalByDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueDaysDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('dueMileageDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('expiryDateDataIndex'), false);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('alertTypeDataIndex'), true);
                      grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('remarksDataIndex'), true);
   
 }
  
  var editInfo1 = new Ext.Button({
      text: 'Submit',
      id: 'submitId',
      cls: 'buttonStyle',
      width: 70,
      handler: function () {
          // store.load();
          var clientName = Ext.getCmp('custcomboId').getValue();
          var startdate = Ext.getCmp('startdate').getValue();
          var enddate = Ext.getCmp('enddate').getValue();
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
          if (Ext.getCmp('reportTypeComboId').getValue() == 3 || Ext.getCmp('reportTypeComboId').getValue() == 1) {
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
          store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName,
                  type: Ext.getCmp('reportTypeComboId').getValue()
              }
          });
      }
  });
  
  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: true,
      width: screen.width - 35,
      height: 70,
      layoutConfig: {
          columns: 7
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
          },
          reportTypeCombo, {
              width: 10
          },
          {}, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              text: '<%=StartDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectStartDate%>',
              allowBlank: false,
              blankText: '<%=SelectStartDate%>',
              id: 'startdate',
               value: dtprev,
              endDateField: 'enddate'
          }, {
              width: 20
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              text: '<%=EndDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectEndDate%>',
              allowBlank: false,
              blankText: '<%=SelectEndDate%>',
              id: 'enddate',
              value: datecur,
              startDateField: 'startdate'
          }, {
              width: 20
          },editInfo1
      ]
  });
  
 

  var reader = new Ext.data.JsonReader({
      idProperty: 'preventiveMaintenanceId',
      root: 'preventiveMaintenanceRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'assetNumberDataIndex'
      },{
          name: 'vehicleIdDataIndex'
      },{
          name: 'vehicleGroupDataIndex'
      }, {
          name: 'serviceNameDataIndex'
      }, {
          name: 'lastServiceDateDataIndex',
            type: 'date',
  		   dateFormat: 'd-m-Y'
      }, {
          name: 'renewalByDataIndex'
      }, {
          name: 'dueDaysDataIndex'
      }, {
          name: 'dueMileageDataIndex'
      }, {
          name: 'expiryDateDataIndex',
            type: 'date',
  		   dateFormat: 'd-m-Y'
      }, {
          name: 'alertTypeDataIndex'
      }, {
          name: 'remarksDataIndex'
      },{
          name: 'odometerReadingDataIndex',
          type:'float'
      }, {
     	 name: 'ServiceDateDataIndex',
     	   type: 'date',
  		   dateFormat: 'd-m-Y'
     	 
     }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getPreventiveMaintenanceReport',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'preventiveMaintenancereport',
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
      },
       {
          type: 'string',
          dataIndex: 'vehicleIdDataIndex'
      },
       {
          type: 'string',
          dataIndex: 'vehicleGroupDataIndex'
      },
       {
          type: 'float',
          dataIndex: 'odometerReadingDataIndex'
      },
       {
          type: 'string',
          dataIndex: 'serviceNameDataIndex'
      }, {
          type: 'date',         
          dataIndex: 'lastServiceDateDataIndex'
      }, {
          type: 'string',
          dataIndex: 'renewalByDataIndex'
      }, {
          type: 'int',
          dataIndex: 'dueDaysDataIndex'
      }, {
          type: 'float',
          dataIndex: 'dueMileageDataIndex'
      }, {
          type: 'date',
          dataIndex: 'expiryDateDataIndex'
      }, {
          type: 'string',
          dataIndex: 'alertTypeDataIndex'
      }, {
          type: 'string',
          dataIndex: 'remarksDataIndex'
      }, {
         type: 'date',
         dataIndex: 'ServiceDateDataIndex'
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
          },{
              header: "<span style=font-weight:bold;><%=VehicleId%></span>",
              dataIndex: 'vehicleIdDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=VehicleGroup%></span>",
              dataIndex: 'vehicleGroupDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ServiceName%></span>",
              dataIndex: 'serviceNameDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=LastServiceDate%></span>",
              dataIndex: 'lastServiceDateDataIndex',
               renderer: Ext.util.Format.dateRenderer(getDateFormat()),
               hidden:true,
              width: 100,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=RenewalBy%></span>",
              dataIndex: 'renewalByDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=DueDays%></span>",
              dataIndex: 'dueDaysDataIndex',
              width: 100,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=DueMileage%></span>",
              dataIndex: 'dueMileageDataIndex',
              width: 100,
              filter: {
                  type: 'float'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ExpiryDate%></span>",
              dataIndex: 'expiryDateDataIndex',
               renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              width: 100,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Odometer%></span>",
              dataIndex: 'odometerReadingDataIndex',
              width: 100,
              filter: {
                  type: 'float'
              }
          },{
              header: "<span style=font-weight:bold;><%=AlertType%></span>",
              dataIndex: 'alertTypeDataIndex',
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
          }, {             
             header: "<span style=font-weight:bold;>Service Date </span>",
             dataIndex: 'ServiceDateDataIndex',
              renderer: Ext.util.Format.dateRenderer(getDateFormat()),
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
  
  var grid = getGrid('<%=PreventiveMaintenanceReport%>', '<%=NoRecordsfound%>', store, screen.width - 35, 410, 15, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
  
  Ext.onReady(function () {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title:'<%=PreventiveMaintenanceReport%>',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [clientPanel, grid]
          //bbar: ctsb
      });
      sb = Ext.getCmp('form-statusbar');
      var type=<%=alertType%>;
      if(type==2)
      {
                      Ext.getCmp('startdatelab').hide();
                      Ext.getCmp('startdate').hide();
                      Ext.getCmp('enddatelab').hide();
                      Ext.getCmp('enddate').hide();
      }
      
      
  }); 
   </script>
 </body>
</html>