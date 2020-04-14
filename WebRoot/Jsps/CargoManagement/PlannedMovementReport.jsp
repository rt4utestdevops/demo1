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
  tobeConverted.add("Planned_Movement_Report");
  tobeConverted.add("Select_Customer");
  tobeConverted.add("Select_Asset_type");
  tobeConverted.add("SLNO");
  tobeConverted.add("Asset_Number");
  tobeConverted.add("Select_Start_Date");
  tobeConverted.add("Select_End_Date");
  tobeConverted.add("Asset_Details");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Asset_Group");
  tobeConverted.add("Start_Date");
  tobeConverted.add("End_Date");
  tobeConverted.add("Trip_Name");
  tobeConverted.add("Start_Location");
  tobeConverted.add("End_Time");
  tobeConverted.add("End_Location");
  tobeConverted.add("Running_Durations");
  tobeConverted.add("Travel_Time");
  tobeConverted.add("Travel_Distance");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Clear_Filter_Data");
  tobeConverted.add("Excel");
  tobeConverted.add("Month_Validation");  
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("Route_Name");
  tobeConverted.add("No_Records_Selected_Please_Select_Atleast_One_Record");
       
ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 String PlannedMovementReport = convertedWords.get(0);
 String SelectCustomer = convertedWords.get(1);
 String SelectAssettype = convertedWords.get(2);
 String SLNO = convertedWords.get(3);
 String AssetNumber = convertedWords.get(4);
 String SelectStartDate = convertedWords.get(5);
 String SelectEndDate = convertedWords.get(6);
 String AssetDetails = convertedWords.get(7);
 String CustomerName = convertedWords.get(8);
 String AssetGroup = convertedWords.get(9);
 String StartDate = convertedWords.get(10);
 String EndDate = convertedWords.get(11);
 String TripName = convertedWords.get(12);
 String StartLocation = convertedWords.get(13);
 String EndTime = convertedWords.get(14);
 String EndLocation = convertedWords.get(15);
 String RunningDuration = convertedWords.get(16);
 String TravelTime = convertedWords.get(17);
 String TravelDistance = convertedWords.get(18);
 String NoRecordsfound = convertedWords.get(19);
 String ClearFilterData = convertedWords.get(20);
 String Excel = convertedWords.get(21);
 String monthValidation =  convertedWords.get(22);
 String EndDateMustBeGreaterthanStartDate = convertedWords.get(23);
 String RouteName= convertedWords.get(24);
 String NoRecordsSelectedPleaseSelectatleastOneRecord = convertedWords.get(25);
	
%>



<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 		<title><%=PlannedMovementReport%></title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	*.x-grid3-row-checker, *.x-grid3-hd-checker {
        margin-top: 1px !important;
    }
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   var outerPanel;
   var AssetNumber;
   /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
       var width = '100%';
       var height = '100%';
       grid.setSize(width, height);
       outerPanel.setSize(width, height);
       outerPanel.doLayout();
   });
   var dtprev = dateprev;
   var dtcur = datecur;
   var jspName = "PlannedMovementReport";
   var exportDataType = "int,string,string,date,string,date,string,float,float,float";
  
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
                   assetGroupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
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
                   globalAssetNumber = "";
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   var globalGroupId= Ext.getCmp('assettypecomboId').getValue()
                   
                   assetGroupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
        
         
                   Ext.getCmp('assettypecomboId').reset();
                  firstGridStore.load();
                   
                   
                  store.load();
                
                   if ( <%= customerId %> > 0) {
                      
                       Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                       var globalGroupId= Ext.getCmp('assettypecomboId').getValue()
                       assetGroupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                       firstGridStore.load({
                           params: {
                               CustId: custId,
                               CustName: custName,
                                 globalGroupId: globalGroupId
                                
                           }
                       });
                       
                       store.load();
  
                   }

               }
           }
       }
   });

var assetGroupStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroup',
       id: 'assetTypeId',
       root: 'assetGroupRoot',
       autoload: false,
       remoteSort: true,
       fields: ['groupId','groupName'],
       listeners: {
           load: function () {}
       }

   });


 var assetGroupCombo = new Ext.form.ComboBox({
       store: assetGroupStore,
       id: 'assettypecomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectAssettype%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'groupId',
       displayField: 'groupName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   assetType = Ext.getCmp('assettypecomboId').getValue();
                   custId = Ext.getCmp('custcomboId').getValue();
                   var globalGroupId = Ext.getCmp('assettypecomboId').getValue();
                   firstGridStore.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           AssetType: assetType,
                            globalGroupId: globalGroupId
                           
                       }
                   });
                     store.load();
                }
           }
       }
   });


	var sm1 = new Ext.grid.CheckboxSelectionModel({
      checkOnly: true
 	 });
  
  
   var cols1 = new Ext.grid.ColumnModel([
	       new Ext.grid.RowNumberer({
	           header: "<span style=font-weight:bold;><%=SLNO%></span>",
	           width: 40
	       }),sm1,{
	           header: '<b><%=AssetNumber%></b>',
	           width: 120,
	           sortable: true,
	           dataIndex: 'assetnumber'
	       }
   ]);

   var reader1 = new Ext.data.JsonReader({
       root: 'assetNumberRoot',
       fields: [{
           name: 'slnoIndex'
       },{
           name: 'assetnumber',
           type: 'string'
       }]
   });

   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
               type: 'numeric',
               dataIndex: 'slnoIndex'
           }, {
               dataIndex: 'assetnumber',
               type: 'string'
           }

       ]
   });

   var firstGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getAssetNumber',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: true
   });
   
   var allButtonsPannel = new Ext.Panel({
    standardSubmit: true,
    collapsibli: false,
    id: 'buttonpannelid',
    layout: 'table',
    frame: false,
    width: 180,
    height: 30,
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 60
    }, {
        xtype: 'button',
        text: 'Generate Report',
        id: 'generateReport',
        cls: 'buttonwastemanagement',
        width: 100,
        listeners: {
            click: {
                fn: function() {
                store.load();
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
                     if (firstGridToGetAssetNumber.getSelectionModel().getCount() == 0) 
                      {
                           Ext.example.msg("<%=NoRecordsSelectedPleaseSelectatleastOneRecord%>");
                           return;
                      }
                    var gridData = "";
                    var json1 = "";
                    var records1 = firstGridToGetAssetNumber.getSelectionModel().getSelections();
                    for (var i = 0; i < records1.length; i++) {
                        var record1 = records1[i];
                        var row = firstGridToGetAssetNumber.store.findExact('slnoIndex', record1.get('slnoIndex'));
                        var store1 = firstGridToGetAssetNumber.store.getAt(row);
                        json1 = json1 + Ext.util.JSON.encode(store1.data) + ',';
                    }
                    
                    
                    store.load({
                        params: {
                            CustId: custId,
                            startDate: Ext.getCmp('startdate').getValue(),
                            endDate: Ext.getCmp('enddate').getValue(),
                            gridData: json1,
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue()
                        }
                    });
                }
            }
        }
    }, {
        width: 10
    }]
});

   var firstGridToGetAssetNumber = new Ext.grid.GridPanel({
       title: '<%=AssetDetails%>',
       id: 'firstGrid',
       ds: firstGridStore,
       frame: true,
       cm: cols1,
       sm: sm1,
       view: new Ext.grid.GridView({
           nearLimit: 2,
       }),
       plugins: [filters1],
       stripeRows: true,
       height: 440,
       width: 200,
       autoScroll: true
       
   });

   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 12,
       height: 40,
       layoutConfig: {
           columns: 11
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
               text: '<%=AssetGroup%>' + ' :',
               cls: 'labelstyle',
               id: 'assetGrouplab'
           },
           assetGroupCombo, {            
           width:60
           },
            {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'startdatelab',
               text: '<%=StartDate%>' + ' :'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 185,
               format: getDateTimeFormat(),
               emptyText: 'SelectStartDate',
               allowBlank: false,
               blankText: 'SelectStartDate',
               id: 'startdate',
               value: dtprev,
               endDateField: 'enddate'
           }, {
               width: 60
           }, {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'enddatelab',
               text: '<%=EndDate%>' + ' :'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 185,
               format: getDateTimeFormat(),
               emptyText: '<%=SelectEndDate%>',
               allowBlank: false,
               blankText: '<%=SelectEndDate%>',
               id: 'enddate',
               value: datecur,
               startDateField: 'startdate'
           }
       ]
   });

   var reader = new Ext.data.JsonReader({
       idProperty: 'plantMovementReport',
       root: 'plantMovementReport',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex1'
       },{
           name: 'assetNumberDataIndex'
       }, {
           name: 'tripNameDataIndex'
       }, {
           name: 'startTimeDataIndex'
       }, {
           name: 'startLocationDataIndex'
       }, {
           name: 'endTimeDataIndex'
       }, {
           name: 'endLocationDataIndex'
       }, {
           name: 'runningDurationDataIndex'
       }, {
           name: 'travelTimeDataIndex'
       }, {
           name: 'travelDistanceDataIndex'
       }
        ]
   });

   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getPlantMovementReport',
           method: 'POST'
       }),
       remoteSort: false,
       sortInfo: {
           field: 'assetNumberDataIndex',
           direction: 'ASC'
       },
       storeId: 'plantMovementReportId',
       reader: reader
   });

   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex1'
       }, {
           type: 'string',
           dataIndex: 'assetNumberDataIndex'
       },{
           type: 'string',
           dataIndex: 'tripNameDataIndex'
       }, {
           type: 'date',
           dataIndex: 'startTimeDataIndex'
       }, {
           type: 'string',
           dataIndex: 'startLocationDataIndex'
       }, {
           type: 'date',
           dataIndex: 'endTimeDataIndex'
       }, {
           type: 'string',
           dataIndex: 'endLocationDataIndex'
       }, {
           type: 'float',
           dataIndex: 'runningDurationDataIndex'
       }, {
           type: 'float',
           dataIndex: 'travelTimeDataIndex'
       }, {
           type: 'float',
           dataIndex: 'travelDistanceDataIndex'
       }]
   });

   var createColModel = function (finish, start) {

       var columns = [
           new Ext.grid.RowNumberer({
               header: "<span style=font-weight:bold;><%=SLNO%></span>",
               width: 50
           }), {
               dataIndex: 'slnoIndex1',
               hidden: true,
               header: "<span style=font-weight:bold;><%=SLNO%></span>",
               filter: {
                   type: 'numeric'
               }
           }, {
               dataIndex: 'assetNumberDataIndex',
               header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
               width:40,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=RouteName%></span>",
               dataIndex: 'tripNameDataIndex',
               width: 40,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=StartDate%></span>",
               dataIndex: 'startTimeDataIndex',
               width: 40,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=StartLocation%></span>",
               dataIndex: 'startLocationDataIndex',
               hidden: false,
               width: 40,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=EndDate%></span>",
               dataIndex: 'endTimeDataIndex',
               decimalPrecision: 2,
               width: 40,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=EndLocation%></span>",
               dataIndex: 'endLocationDataIndex',
               width: 40,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=RunningDuration%></span>",
               dataIndex: 'runningDurationDataIndex',
               width: 40,
               filter: {
                   type: 'float'
               }
           },{
               header: "<span style=font-weight:bold;><%=TravelTime%></span>",
               dataIndex: 'travelTimeDataIndex',
               width: 40,
               filter: {
                   type: 'float'
               }
           },{
               header: "<span style=font-weight:bold;><%=TravelDistance%></span>",
               dataIndex: 'travelDistanceDataIndex',
               width: 40,
               filter: {
                   type: 'float'
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

 var grid = getGrid('<%=PlannedMovementReport%>', '<%=NoRecordsfound%>', store, screen.width - 260, 430, 12, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');


   var secondGridPanelForPlantMovement = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondPanelId',
       layout: 'table',
       frame: true,
       width: 1300,
       height: 440,
       layoutConfig: {
           columns: 1
       },
       items: [grid],

   });

   var plantMovementPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'vesselPanelId',
       layout: 'table',
       frame: false,
       width: '100%',
       height: 450,
       layoutConfig: {
           columns: 2
       },
       items: [firstGridToGetAssetNumber, secondGridPanelForPlantMovement],

   });



   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: '',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width:screen.width-25,
           height:529,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [clientPanel, plantMovementPanel,allButtonsPannel]
       });
       sb = Ext.getCmp('form-statusbar');

   });
   </script>
 </body>
</html>


