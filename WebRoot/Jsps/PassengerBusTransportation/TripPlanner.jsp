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

    tobeConverted.add("Trip_Planner");
    tobeConverted.add("SLNO");
    tobeConverted.add("Weekday_Holiday");
    tobeConverted.add("Route_Name");
    tobeConverted.add("Terminal_Name");
    tobeConverted.add("Distance");
    tobeConverted.add("Vehicle_Model");
    tobeConverted.add("Seating_Structure");
    tobeConverted.add("Rate");
    tobeConverted.add("Clear_Filter_Data");
    tobeConverted.add("No_Records_Found");
    tobeConverted.add("Modify");
    tobeConverted.add("Status");
    tobeConverted.add("Select_Customer_Name");
    tobeConverted.add("Customer_Name");
    tobeConverted.add("Trip_Planner_Details");
    tobeConverted.add("Select_Status");
    tobeConverted.add("Error");
    tobeConverted.add("Cancel");
    tobeConverted.add("Add_Details");
    tobeConverted.add("No_Rows_Selected");
    tobeConverted.add("Select_Single_Row");
    tobeConverted.add("Modify_Details");
    tobeConverted.add("Enter_Route_Name");
    tobeConverted.add("Save");
    tobeConverted.add("Id");
    tobeConverted.add("Select_Terminal_Name");
    tobeConverted.add("Select_Route_Name");
    tobeConverted.add("Invalid_Distance");
    tobeConverted.add("Invalid_Duration");
    tobeConverted.add("Service_Name");
    tobeConverted.add("Enter_Service_Name");
    tobeConverted.add("Origin_Destination");   
    tobeConverted.add("Invalid_Origin_Destination");
    tobeConverted.add("Invalid_Departure_Arrival");
    tobeConverted.add("Invalid_Vehicle_Model");
    tobeConverted.add("Departure_Arrival");
    tobeConverted.add("Departure(HH:MM)");
    tobeConverted.add("Duration(HH:MM)");       
    tobeConverted.add("Invalid_Seating_Structure");
    tobeConverted.add("Invalid_Departure_Arrival");
    tobeConverted.add("Day_Type");
    tobeConverted.add("Invalid_Rate");
    tobeConverted.add("Add"); 
    tobeConverted.add("Excel"); 
    tobeConverted.add("PDF");    
    tobeConverted.add("Select_Day_Type");
  
    
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String TripPlanner= convertedWords.get(0);
String SLNO = convertedWords.get(1); 
String WeekdayHoliday = convertedWords.get(2);
String RouteName = convertedWords.get(3);
String TerminalName = convertedWords.get(4);
String Distance = convertedWords.get(5);
String VehicleModel = convertedWords.get(6);
String SeatingStructure = convertedWords.get(7);
String Rate = convertedWords.get(8);
String ClearFilterData = convertedWords.get(9);
String NoRecordFound=convertedWords.get(10);
String Modify=convertedWords.get(11);
String Status=convertedWords.get(12);
String SelectCustomerName=convertedWords.get(13);
String CustomerName=convertedWords.get(14);
String TripPlannerDetails=convertedWords.get(15);
String SelectStatus=convertedWords.get(16);
String Error=convertedWords.get(17);
String Cancel=convertedWords.get(18);
String AddDetails=convertedWords.get(19);
String NoRowSelected=convertedWords.get(20);
String SelectSingleRow=convertedWords.get(21);
String ModifyDetails=convertedWords.get(22);
String EnterRouteName = convertedWords.get(23);
String Save=convertedWords.get(24);
String Id=convertedWords.get(25);
String SelectTerminalName  = convertedWords.get(26);
String SelectRouteName = convertedWords.get(27);
String EnterDistance = convertedWords.get(28);
String EnterDuration = convertedWords.get(29);
String Service = convertedWords.get(30);
String EnterService = convertedWords.get(31);
String OriginDestination = convertedWords.get(32);
String EnterOriginDestination = convertedWords.get(33);
String EnterArrival = convertedWords.get(34);
String SelectVehicleModel = convertedWords.get(35);
String DepartureArrivalHHMM = convertedWords.get(36);
String DepartureHHMM = convertedWords.get(37);
String DurationHHMM = convertedWords.get(38);
String SelectSeatingStructure = convertedWords.get(39);
String EnterDeparture_Arrival = convertedWords.get(40);
String DayType = convertedWords.get(41);
String EnterRate = convertedWords.get(42);
String Add=convertedWords.get(43); 
String Excel=convertedWords.get(44);
String PDF=convertedWords.get(45);
String SelectDayType = convertedWords.get(46);

%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=TripPlanner%></title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	label {
		display : inline !important;
	}
	.ext-strict .x-form-text {
		height : 21px !important;
	}
	.x-window-tl *.x-window-header {
		height : 36px !important;	
	}
	
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
 
  var outerPanel;
  var ctsb;
  var jspName = '<%=TripPlanner%>';
  var exportDataType = "int,int,string,string,string,string,string,string,string,string,string,string,string,string";
  var selected;
  var grid;
  var buttonValue;
  var titelForInnerPanel;
  var myWin;
  var statusValue = 'Active';
  var weekdayHolidayValue = 'Weekday';
  var terminalName;
  var routeName;
  var serviceName;
  var custId;
  var rateId;
  var serviceId = 0;

  var clientcombostore = new Ext.data.JsonStore({
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
              }
              terminalNameStore.load({
                  params: {
                      CustId: custId
                  }
              })
              store.load({
                  params: {
                      CustId: custId,
                      jspName: jspName,
                      custname: Ext.getCmp('custcomboId').getRawValue()
                  }
              })

          }
      }

  });

  var Client = new Ext.form.ComboBox({
      store: clientcombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomerName%>',
      blankText: '<%=SelectCustomerName%>',
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
                  terminalNameStore.load({
                      params: {
                          CustId: custId
                      }
                  })
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          custname: Ext.getCmp('custcomboId').getRawValue()
                      }
                  })
              }
          }
      }
  });
  var StatusStore = new Ext.data.SimpleStore({
      id: 'StatusStorId',
      fields: ['Name', 'Value'],
      autoLoad: true,
      data: [
          ['Active', 'Active'],
          ['Inactive', 'Inactive']
      ]
  });

  var Status = new Ext.form.ComboBox({
      frame: true,
      store: StatusStore,
      id: 'StatusId',
      width: 150,
      cls: 'selectstylePerfect',
      hidden: false,
      allowBlank: false,
      anyMatch: true,
      onTypeAhead: true,
      forceSelection: true,
      enableKeyEvents: true,
      mode: 'local',
      emptyText: '<%=SelectStatus%>',
      triggerAction: 'all',
      displayField: 'Name',
      value: 'Active',
      valueField: 'Value',
      listeners: {
          select: {
              fn: function() {
                  statusValue = Ext.getCmp('StatusId').getValue();
              }
          }
      }
  });

  var WeekdayHolidayStore = new Ext.data.SimpleStore({
      id: 'WeekdayHolidayStoreId',
      fields: ['Name', 'Value'],
      autoLoad: true,
      data: [
          ['Weekday', 'Weekday'],
          ['Weekend', 'Weekend'],
          ['Holiday', 'Holiday']
      ]
  });

  var WeekdayHoliday = new Ext.form.ComboBox({
      frame: true,
      store: WeekdayHolidayStore,
      id: 'WeekdayHolidayId',
      width: 150,
      cls: 'selectstylePerfect',
      hidden: false,
      allowBlank: false,
      anyMatch: true,
      onTypeAhead: true,
      forceSelection: true,
      enableKeyEvents: true,
      mode: 'local',
      emptyText: '<%=SelectDayType%>',
      triggerAction: 'all',
      displayField: 'Name',
      value: 'Weekday',
      valueField: 'Value',
      listeners: {
          select: {
              fn: function() {
                  weekdayHolidayValue = Ext.getCmp('WeekdayHolidayId').getValue();
                  Ext.getCmp('TerminalNameId').reset();
                  terminalNameStore.reload();
                  Ext.getCmp('RouteNameId').reset();
                  RouteNameStore.reload();
                  Ext.getCmp('OriginDestinationId').reset();
                  Ext.getCmp('EnterDistanceId').reset();
                  Ext.getCmp('EnterDurationId').reset();
                  Ext.getCmp('EnterArrivalId').reset();
                  Ext.getCmp('VehicleModelId').reset();
                  Ext.getCmp('EnterSeatingStructureId').reset();
                  Ext.getCmp('EnterRateId').reset();

              }
          }
      }
  });

  var terminalNameStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripPlannerAction.do?param=getTerminalName',
      id: 'terminalNameStoreId',
      root: 'getTerminalName',
      autoLoad: true,
      remoteSort: true,
      fields: ['TERMINAL_NAME', 'TERMINAL_ID']

  });

  var TerminalName = new Ext.form.ComboBox({
      frame: true,
      store: terminalNameStore,
      id: 'TerminalNameId',
      width: 150,
      cls: 'selectstylePerfect',
      hidden: false,
      allowBlank: false,
      anyMatch: true,
      onTypeAhead: true,
      forceSelection: true,
      enableKeyEvents: true,
      mode: 'local',
      emptyText: '<%=SelectTerminalName%>',
      triggerAction: 'all',
      displayField: 'TERMINAL_NAME',
      valueField: 'TERMINAL_ID',
      listeners: {
          select: {
              fn: function() {
                  Ext.getCmp('RouteNameId').enable();  
                  Ext.getCmp('RouteNameId').reset();
                  Ext.getCmp('OriginDestinationId').reset();
                  Ext.getCmp('EnterDistanceId').reset();
                  Ext.getCmp('EnterDurationId').reset();
                  Ext.getCmp('EnterArrivalId').reset();
                  Ext.getCmp('VehicleModelId').reset();
                  Ext.getCmp('EnterSeatingStructureId').reset();
                  Ext.getCmp('EnterRateId').reset();
                  terminalName = Ext.getCmp('TerminalNameId').getValue();
                  RouteNameStore.load({
                      params: {
                          CustId: custId,
                          TerminalName: terminalName,
                          WeekdayHolidayValue: weekdayHolidayValue
                      }
                  })

              }
          }
      }
  });

  var RouteNameStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripPlannerAction.do?param=getRouteNames',
      id: 'RouteNameStoreId',
      root: 'getRouteName',
      autoLoad: true,
      remoteSort: true,
      fields: ['RATE_ID','ROUTE_ID','ROUTE_NAME']

  });

  var RouteName = new Ext.form.ComboBox({
      frame: true,
      store: RouteNameStore,
      id: 'RouteNameId',
      width: 150,
      cls: 'selectstylePerfect',
      hidden: false,
      allowBlank: false,
      anyMatch: true,
      onTypeAhead: true,
      forceSelection: true,
      enableKeyEvents: true,
      mode: 'local',
      emptyText: '<%=SelectRouteName%>',
      triggerAction: 'all',
      displayField: 'ROUTE_NAME',
      valueField: 'RATE_ID',
      listeners: {
          select: {
              fn: function() {
                  rateID = Ext.getCmp('RouteNameId').getValue();                
                  rateDetailstore.load({
                      params: {
                          CustId: custId,
                          TerminalName: terminalName,
                          DayType: weekdayHolidayValue,
                          RateID : rateID
                      },
                      callback: function() {                         
                              var Record = rateDetailstore.getAt(0);                             
                              Ext.getCmp('OriginDestinationId').setValue(Record.data['ORIGIN_DESTINATION']);
                              Ext.getCmp('EnterDistanceId').setValue(Record.data['DISTANCE']);
                              Ext.getCmp('EnterDurationId').setValue(Record.data['DURATION']);
                              Ext.getCmp('EnterArrivalId').setValue(Record.data['ARRIVAL_DEPARTURE']);
                              Ext.getCmp('VehicleModelId').setValue(Record.data['MODEL_NAME']);
                              Ext.getCmp('EnterSeatingStructureId').setValue(Record.data['SEATING_STRUCTURE']);
                              Ext.getCmp('EnterRateId').setValue(Record.data['AMOUNT']);
                              rateId = Record.data['RATE_ID'];
                              routeName = Record.data['ROUTE_ID'];                         
                      }
                  })
              }
          }
      }
  });

  var rateDetailstore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripPlannerAction.do?param=getRateDetails',
      id: 'rateDetailstoreId',
      root: 'getRateDetails',
      autoLoad: true,
      remoteSort: true,
      fields: ['RATE_ID', 'ROUTE_ID', 'ORIGIN_DESTINATION', 'DISTANCE', 'DURATION', 'ARRIVAL_DEPARTURE', 'MODEL_NAME', 'SEATING_STRUCTURE', 'AMOUNT']
  });

  var customerComboPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'customerComboPanelId',
      layout: 'table',
      frame: false,
      width: screen.width - 12,
      height: 50,
      layout: 'table',
      layoutConfig: {
          columns: 3
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle'
          }, {
              width: 10
          },
          Client
      ]
  });
  var reader = new Ext.data.JsonReader({
      idProperty: 'TripPlannerReaderid',
      root: 'getServiceMasterDetails',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex',
      }, {
          name: 'idIndex'
      }, {
          name: 'ServiceDataIndex'
      }, {
          name: 'weekdayHolidayDataIndex'
      }, {
          name: 'terminalNameDataIndex'
      }, {
          name: 'routeNameDataIndex'
      }, {
          name: 'originDestinationDataIndex'
      }, {
          name: 'distanceDataIndex'
      }, {
          name: 'durationDataIndex'
      }, {
          name: 'departurearrivalDataIndex'
      }, {
          name: 'vehicleModelDataIndex'
      }, {
          name: 'SeatingStructureDataIndex'
      }, {
          name: 'rateDataIndex'
      }, {
          name: 'StatusDataIndex'
      }, {
          name: 'weekdayHolidayIDDataIndex'
      }, {
          name: 'terminalNameIDDataIndex'
      }, {
          name: 'routeNameIDDataIndex'
      }, {
          name: 'rateNameIDDataIndex'
      }, {
          name: 'StatusIDDataIndex'
      }]
  });


  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'numeric',
          dataIndex: 'idIndex'
      }, {
          type: 'string',
          dataIndex: 'ServiceDataIndex'
      }, {
          type: 'string',
          dataIndex: 'weekdayHolidayDataIndex'
      }, {
          type: 'string',
          dataIndex: 'terminalNameDataIndex'
      }, {
          type: 'string',
          dataIndex: 'routeNameDataIndex'
      }, {
          type: 'string',
          dataIndex: 'originDestinationDataIndex'
      }, {
          type: 'string',
          dataIndex: 'distanceDataIndex'
      }, {
          type: 'string',
          dataIndex: 'durationDataIndex'
      }, {
          type: 'string',
          dataIndex: 'departurearrivalDataIndex'
      }, {
          type: 'string',
          dataIndex: 'vehicleModelDataIndex'
      }, {
          type: 'string',
          dataIndex: 'SeatingStructureDataIndex'
      }, {
          type: 'numeric',
          dataIndex: 'rateDataIndex'
      }, {
          type: 'string',
          dataIndex: 'StatusDataIndex'
      }]
  });
  var store = new Ext.data.GroupingStore({
      autoLoad: true,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/TripPlannerAction.do?param=getServiceMasterDetails',
          method: 'POST'
      }),
      storeId: 'TripPlannerid',
      reader: reader
  });

  var createColModel = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }), {
              dataIndex: 'slnoIndex',
              width: 30,
              hidden: true,
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Id%></span>",
              dataIndex: 'idIndex',
              hidden: true,
              width: 30,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Service%></span>",
              dataIndex: 'ServiceDataIndex',
              width: 50,
              filter: {
                  type: 'String'
              }
          }, {
              header: "<span style=font-weight:bold;><%=WeekdayHoliday%></span>",
              dataIndex: 'weekdayHolidayDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=TerminalName%></span>",
              dataIndex: 'terminalNameDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=RouteName%></span>",
              dataIndex: 'routeNameDataIndex',
              width: 70,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=OriginDestination%></span>",
              dataIndex: 'originDestinationDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Distance%></span>",
              dataIndex: 'distanceDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=DurationHHMM%></span>",
              dataIndex: 'durationDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=DepartureArrivalHHMM%></span>",
              dataIndex: 'departurearrivalDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
              dataIndex: 'vehicleModelDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=SeatingStructure%></span>",
              dataIndex: 'SeatingStructureDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Rate%></span>",
              dataIndex: 'rateDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Status%></span>",
              dataIndex: 'StatusDataIndex',
              width: 50,
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
  var innerPanelForTripPlannerDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 270,
      width: 430,
      frame: true,
      id: 'innerPanelForTerminalRouteMasterId',
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=TripPlannerDetails%>',
          cls: 'fieldsetpanel',
          collapsible: false,
          id: 'RouteDetailsId',
          width: 400,
          height: 390,
          layout: 'table',
          layoutConfig: {
              columns: 3
          },
          items: [{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id0'
          }, {
              xtype: 'label',
              text: '<%=Service%>' + ' :',
              cls: 'labelstyle',
              id: 'ServiceLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=EnterService%>',
              emptyText: '<%=EnterService%>',
              allowBlank: false,
              labelSeparator: '',
              id: 'EnterServiceId',
              listeners: {
                  change: function(field, newValue, oldValue) {
                      field.setValue(newValue.toUpperCase().trim());
                      serviceName = Ext.getCmp('EnterServiceId').getValue();
                  }
              }
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id1'
          }, {
              xtype: 'label',
              text: '<%=DayType%>' + ' :',
              cls: 'labelstyle',
              id: 'WeekdayHolidaylabelId'
          }, WeekdayHoliday, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id2'
          }, {
              xtype: 'label',
              text: '<%=TerminalName%>' + ' :',
              cls: 'labelstyle',
              id: 'terminalNamelabelId'
          }, TerminalName, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id3'
          }, {
              xtype: 'label',
              text: '<%=RouteName%>' + ' :',
              cls: 'labelstyle',
              id: 'RouteNamelabelId'
          }, RouteName, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id4'
          }, {
              xtype: 'label',
              text: '<%=OriginDestination%>' + ' :',
              cls: 'labelstyle',
              id: 'OriginDestinationlabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=OriginDestination%>',
              emptyText: '<%=OriginDestination%>',
              allowBlank: false,
              readOnly: true,
              labelSeparator: '',
              id: 'OriginDestinationId',
              listeners: {
                  change: function(field, newValue, oldValue) {
                      field.setValue(newValue.toUpperCase().trim());
                  }
              }
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id5'
          }, {
              xtype: 'label',
              text: '<%=Distance%>' + ' :',
              cls: 'labelstyle',
              id: 'DistanceLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=Distance%>',
              emptyText: '<%=Distance%>',
              allowBlank: false,
              labelSeparator: '',
              readOnly: true,
              id: 'EnterDistanceId'

          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id6'
          }, {
              xtype: 'label',
              text: '<%=DurationHHMM%>' + ' :',
              cls: 'labelstyle',
              id: 'DurationLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=DurationHHMM%>',
              emptyText: '<%=DurationHHMM%>',
              allowBlank: false,
              labelSeparator: '',
              readOnly: true,
              id: 'EnterDurationId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id13'
          }, {
              xtype: 'label',
              text: '<%=DepartureArrivalHHMM%>' + ' :',
              cls: 'labelstyle',
              id: 'ArrivalId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=DepartureArrivalHHMM%>',
              emptyText: '<%=DepartureArrivalHHMM%>',
              allowBlank: false,
              labelSeparator: '',
              readOnly: true,
              id: 'EnterArrivalId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id9'
          }, {
              xtype: 'label',
              text: '<%=VehicleModel%>' + ' :',
              cls: 'labelstyle',
              id: 'VehicleModellabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=VehicleModel%>',
              emptyText: '<%=VehicleModel%>',
              allowBlank: false,
              labelSeparator: '',
              readOnly: true,
              id: 'VehicleModelId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id10'
          }, {
              xtype: 'label',
              text: '<%=SeatingStructure%>' + ' :',
              cls: 'labelstyle',
              id: 'SeatingStructureId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=SeatingStructure%>',
              emptyText: '<%=SeatingStructure%>',
              allowBlank: false,
              labelSeparator: '',
              readOnly: true,
              id: 'EnterSeatingStructureId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id12'
          }, {
              xtype: 'label',
              text: '<%=Rate%>' + ' :',
              cls: 'labelstyle',
              id: 'RateLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '<%=Rate%>',
              emptyText: '<%=Rate%>',
              allowBlank: false,
              labelSeparator: '',
              readOnly: true,
              id: 'EnterRateId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'Id11'
          }, {
              xtype: 'label',
              text: '<%=Status%>' + ' :',
              cls: 'labelstyle',
              id: 'StatusLabelId'
          }, Status]
      }]
  });

  var innerWinButtonPanel = new Ext.Panel({
      id: 'innerWinButtonPanelId',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 10,
      width: 430,
      frame: false,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: '<%=Save%>',
          iconCls: 'savebutton',
          id: 'saveButtonId',
          cls: 'buttonstyle',
          width: 70,
          listeners: {
              click: {
                  fn: function() {

                      if (Ext.getCmp('EnterServiceId').getValue() == "") {
                          Ext.example.msg("<%=EnterService%>");
                          Ext.getCmp('EnterServiceId').focus();
                          return;
                      }
                      if (Ext.getCmp('WeekdayHolidayId').getValue() == "") {
                          Ext.example.msg("<%=SelectDayType%>");
                          Ext.getCmp('WeekdayHolidayId').focus();
                          return;
                      }
                      if (Ext.getCmp('TerminalNameId').getValue() == "") {
                          Ext.example.msg("<%=SelectTerminalName%>");
                          Ext.getCmp('TerminalNameId').focus();
                          return;
                      }
                      if (Ext.getCmp('RouteNameId').getValue() == "") {
                          Ext.example.msg("<%=SelectRouteName%>");
                          Ext.getCmp('RouteNameId').focus();
                          return;
                      }
                      if (Ext.getCmp('OriginDestinationId').getValue() == "") {
                          Ext.example.msg("<%=EnterOriginDestination%>");
                          Ext.getCmp('OriginDestinationId').focus();
                          return;
                      }
                      if (Ext.getCmp('EnterDistanceId').getValue() == "") {
                          Ext.example.msg("<%=EnterDistance%>");
                          Ext.getCmp('EnterDistanceId').focus();
                          return;
                      }
                      if (Ext.getCmp('EnterDurationId').getValue() == "") {
                          Ext.example.msg("<%=EnterDuration%>");
                          Ext.getCmp('EnterDurationId').focus();
                          return;
                      }
                      if (Ext.getCmp('EnterArrivalId').getValue() == "") {
                          Ext.example.msg("<%=EnterArrival%>");
                          Ext.getCmp('EnterArrivalId').focus();
                          return;
                      }
                      if (Ext.getCmp('VehicleModelId').getValue() == "") {
                          Ext.example.msg("<%=SelectVehicleModel%>");
                          Ext.getCmp('VehicleModelId').focus();
                          return;
                      }
                      if (Ext.getCmp('EnterSeatingStructureId').getValue() == "") {
                          Ext.example.msg("<%=SelectSeatingStructure%>");
                          Ext.getCmp('EnterSeatingStructureId').focus();
                          return;
                      }
                      if (Ext.getCmp('EnterRateId').getValue() == "") {
                          Ext.example.msg("<%=EnterRate%>");
                          Ext.getCmp('EnterRateId').focus();
                          return;
                      }
                      if (Ext.getCmp('StatusId').getValue() == "") {
                          Ext.example.msg("<%=SelectStatus%>");
                          Ext.getCmp('StatusId').focus();
                          return;
                      }

                      if (innerPanelForTripPlannerDetails.getForm().isValid()) {


                          if (buttonValue == '<%=Modify%>') {
                              var selected = grid.getSelectionModel().getSelected();
                              custId = Ext.getCmp('custcomboId').getValue();
                              buttonValue = buttonValue;
                              serviceName = selected.get('ServiceDataIndex');
                              if (selected.get('weekdayHolidayDataIndex') != Ext.getCmp('WeekdayHolidayId').getValue()) {
                                  weekdayHolidayValue = Ext.getCmp('WeekdayHolidayId').getValue();
                              } else {
                                  weekdayHolidayValue = selected.get('weekdayHolidayIDDataIndex');
                              }
                              if (selected.get('terminalNameDataIndex') != Ext.getCmp('TerminalNameId').getValue()) {
                                  terminalName = Ext.getCmp('TerminalNameId').getValue();
                              } else {
                                  terminalName = selected.get('terminalNameIDDataIndex');
                              }
                              if (selected.get('routeNameDataIndex') != Ext.getCmp('RouteNameId').getValue()) {
                                  routeName = routeName;
                                  rateId = rateId
                              } else {
                                  routeName = selected.get('routeNameIDDataIndex');
                                  rateId = selected.get('rateNameIDDataIndex');
                              }
                              if (selected.get('StatusDataIndex') != Ext.getCmp('StatusId').getValue()) {
                                  statusValue = Ext.getCmp('StatusId').getValue();
                              } else {
                                  statusValue = selected.get('StatusIDDataIndex');
                              }
                              serviceId = selected.get('idIndex');

                          }

                          manageTripPlannerOuterPanelWindow.getEl().mask();
                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/TripPlannerAction.do?param=TripPlannerDetailsAddAndModify',
                              method: 'POST',
                              params: {
                                  CustId: custId,
                                  ButtonValue: buttonValue,
                                  ServiceName: serviceName,
                                  DayType: weekdayHolidayValue,
                                  TerminalName: terminalName,
                                  RouteName: routeName,
                                  RateName: rateId,
                                  Status: statusValue,
                                  ServiceId: serviceId

                              },
                              success: function(response, options) {
                                  var message = response.responseText;
                                  Ext.example.msg(message);
                                  myWin.hide();
                                  manageTripPlannerOuterPanelWindow.getEl().unmask();
                                  store.reload();
                              },
                              failure: function() {
                                  Ext.example.msg("<%=Error%>");
                                  store.reload();
                                  myWin.hide();
                              }
                          });
                      } else {
                          Ext.example.msg("<%=Error%>");
                      }
                  }
              }
          }
      }, {
          xtype: 'button',
          text: '<%=Cancel%>',
          id: 'canButtId',
          cls: 'buttonstyle',
          iconCls: 'cancelbutton',
          width: 70,
          listeners: {
              click: {
                  fn: function() {
                      myWin.hide();
                  }
              }
          }
      }]
  });

  var manageTripPlannerOuterPanelWindow = new Ext.Panel({
      width: 440,
      height: 350,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForTripPlannerDetails, innerWinButtonPanel]
  });

  myWin = new Ext.Window({
      title: titelForInnerPanel,
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      frame: true,
      height: 370,
      width: 450,
      id: 'myWin',
      items: [manageTripPlannerOuterPanelWindow]
  });

  function addRecord() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomerName%>");
          Ext.getCmp('custcomboId').focus();
          return;
      }

      buttonValue = '<%=Add%>';
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(500, 50);
      myWin.show();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('EnterServiceId').reset();
      Ext.getCmp('EnterServiceId').enable();
      Ext.getCmp('WeekdayHolidayId').reset();
      Ext.getCmp('TerminalNameId').reset();
      Ext.getCmp('RouteNameId').reset();
      Ext.getCmp('OriginDestinationId').reset();
      Ext.getCmp('EnterDistanceId').reset();
      Ext.getCmp('EnterDurationId').reset();
      Ext.getCmp('EnterArrivalId').reset();
      Ext.getCmp('VehicleModelId').reset();
      Ext.getCmp('EnterSeatingStructureId').reset();
      Ext.getCmp('EnterRateId').reset();
      Ext.getCmp('StatusId').reset();
  }

  function modifyData() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomerName%>");
          Ext.getCmp('custcomboId').focus();
          return;
      }
      if (grid.getSelectionModel().getCount() == 0) {
          Ext.example.msg("<%=NoRowSelected%>");
          return;
      }
      if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("<%=SelectSingleRow%>");
          return;
      }

      buttonValue = '<%=Modify%>';
      titelForInnerPanel = '<%=ModifyDetails%>';
      myWin.setPosition(500, 50);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
      var selected = grid.getSelectionModel().getSelected();
      Ext.getCmp('EnterServiceId').setValue(selected.get('ServiceDataIndex'));
      Ext.getCmp('EnterServiceId').disable();
      Ext.getCmp('WeekdayHolidayId').setValue(selected.get('weekdayHolidayDataIndex'));
      Ext.getCmp('TerminalNameId').setValue(selected.get('terminalNameDataIndex'));
      Ext.getCmp('RouteNameId').setValue(selected.get('routeNameDataIndex'));
      Ext.getCmp('RouteNameId').disable();
      Ext.getCmp('OriginDestinationId').setValue(selected.get('originDestinationDataIndex'));
      Ext.getCmp('EnterDistanceId').setValue(selected.get('distanceDataIndex'));
      Ext.getCmp('EnterDurationId').setValue(selected.get('durationDataIndex'));
      Ext.getCmp('EnterArrivalId').setValue(selected.get('departurearrivalDataIndex'));
      Ext.getCmp('VehicleModelId').setValue(selected.get('vehicleModelDataIndex'));
      Ext.getCmp('EnterSeatingStructureId').setValue(selected.get('SeatingStructureDataIndex'));
      Ext.getCmp('EnterRateId').setValue(selected.get('rateDataIndex'));
      Ext.getCmp('StatusId').setValue(selected.get('StatusDataIndex'));

  }

  //*****************************************************************Grid *******************************************************************************
  grid = getGrid(
      '<%=TripPlanner%>',
      '<%=NoRecordFound%>',
      store,
      screen.width - 40,
      400,
      16,
      filters,
      '<%=ClearFilterData%>',
      false,
      '',
      9,
      false,
      '',
      false,
      '',
      true,
      '<%=Excel%>',
      jspName,
      exportDataType,
      true,
      '<%=PDF%>',
      true,
      '<%=Add%>',
      true,
      '<%=Modify%>',
      false,
      ''
  );
  //******************************************************************************************************************************************************
  Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title: '<%=TripPlanner%>',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          width: screen.width - 22,
          height: 520,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [customerComboPanel, grid]
      });
      sb = Ext.getCmp('form-statusbar');
  });
 
 </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->