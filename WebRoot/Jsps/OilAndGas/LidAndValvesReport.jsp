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
 
  tobeConverted.add("Select_Customer");
  tobeConverted.add("Select_Asset_type");
  tobeConverted.add("SLNO");
  tobeConverted.add("Asset_Number");
  tobeConverted.add("Select_Start_Date");
  tobeConverted.add("Select_End_Date");
  tobeConverted.add("Asset_Details");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Start_Date");
  tobeConverted.add("End_Date");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Clear_Filter_Data");
  tobeConverted.add("Excel");
  tobeConverted.add("Month_Validation");  
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  
  tobeConverted.add("Select_Type");
  tobeConverted.add("Type");
  tobeConverted.add("Time_Of_Opening");
  tobeConverted.add("Time_Of_Closing");
  tobeConverted.add("Start_Location");
  tobeConverted.add("Duration");
  tobeConverted.add("Distance_Travelled");
  tobeConverted.add("Lid_And_Valves_Report");  
       
ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 String SelectCustomer = convertedWords.get(0);
 String SelectAssettype = convertedWords.get(1);
 String SLNO = convertedWords.get(2);
 String AssetNumber = convertedWords.get(3);
 String SelectStartDate = convertedWords.get(4);
 String SelectEndDate = convertedWords.get(5);
 String AssetDetails = convertedWords.get(6);
 String CustomerName = convertedWords.get(7);
 String StartDate = convertedWords.get(8);
 String EndDate = convertedWords.get(9);
 String NoRecordsfound = convertedWords.get(10);
 String ClearFilterData = convertedWords.get(11);
 String Excel = convertedWords.get(12);
 String monthValidation =  convertedWords.get(13);
 String EndDateMustBeGreaterthanStartDate = convertedWords.get(14);
 String SelectType = convertedWords.get(15);
 String Type = convertedWords.get(16);
 String TimeOfOpening = convertedWords.get(17);
 String TimeOfClosing =  convertedWords.get(18);
 String Location = convertedWords.get(19);
 String Duration = convertedWords.get(20);
 String DistanceTravelled = convertedWords.get(21);
 String LidAndValvesReport = convertedWords.get(22);
 %>



<jsp:include page="../Common/header.jsp" />

 
 		<title><%=LidAndValvesReport%></title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
  </style>
  
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
	<style>
		label {
				display : inline !important;
		}
		.ext-strict .x-form-text {
				height : 21px !important;
		}
		.x-window-body {
				width : 121px !important;
		}
		.x-window-tl *.x-window-header{
				padding-top : 6px !important;
		}
	</style>
   <script>
   var outerPanel;
   var AssetNumber;
   var dtprev = dateprev;
   var dtcur = datecur;
   var jspName = "LidAndValvesReport";
   var exportDataType = "int,string,string,date,date,string,float,float";
   window.onload = function () { 
		refresh();
	}

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
                   typeStore.load({
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
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   firstGridStore.load();
                   Ext.getCmp('typecomboId').reset();
                   store.load();
                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                       typeStore.load({
                           params: {
                               CustId: custId
                           }
                       });
                       firstGridStore.load({
                           params: {
                               CustId: Ext.getCmp('custcomboId').getValue(),
                               CustName: custName
                           }
                       });
                       store.load();
                   }
               }
           }
       }
   });

   var typeStore = new Ext.data.SimpleStore({
       id: 'typecombostoreId',
       autoLoad: true,
       fields: ['Name', 'Value'],
       data: [
           ['Lid', '72'],
           ['Valves', '73'],
           ['Both', '0']
       ]
   });

   var typeCombo = new Ext.form.ComboBox({
       store: typeStore,
       id: 'typecomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectType%>',
       blankText: '',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       displayField: 'Name',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   custId = Ext.getCmp('custcomboId').getValue();
                   type = Ext.getCmp('typecomboId').getValue(),
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   firstGridStore.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           type: type
                       }
                   });
                   store.load();
               }
           }
       }
   });

   var cols1 = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), {
           header: '<b><%=AssetNumber%></b>',
           width: 130,
           sortable: true,
           dataIndex: 'assetnumber'
       }
   ]);

   var reader1 = new Ext.data.JsonReader({
       root: 'assetNumberRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
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
       url: '<%=request.getContextPath()%>/OilAndGasAction.do?param=getAssetNumber',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: true
   });

   function onCellClickOnGrid(firstGridToGetAssetNumber, rowIndex, columnIndex, e) {

        store.load();
       if (Ext.getCmp('typecomboId').getValue() == "") {
            Ext.example.msg("<%=SelectType%>");
            Ext.getCmp('typecomboId').focus();
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
       if (firstGridToGetAssetNumber.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetAssetNumber.getSelectionModel().getSelected();
           AssetNumber = selected.get('assetnumber');
           custId = Ext.getCmp('custcomboId').getValue();
           store.load({
               params: {
                   CustId: custId,
                   startDate: Ext.getCmp('startdate').getValue(),
                   endDate: Ext.getCmp('enddate').getValue(),
                   assetNumber: AssetNumber,
                   jspName: jspName,
                   CustName: Ext.getCmp('custcomboId').getRawValue(),
                   type: Ext.getCmp('typecomboId').getValue()
               }
           });
       }
   }
   var firstGridToGetAssetNumber = new Ext.grid.GridPanel({
       title: '<%=AssetDetails%>',
       id: 'firstGrid',
       ds: firstGridStore,
       frame: true,
       cm: cols1,
       view: new Ext.grid.GridView({
           nearLimit: 2,
       }),
       plugins: [filters1],
       stripeRows: true,
       height: 430,
       width: 200,
       autoScroll: true

   });

   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 38,
       height: 40,
       layoutConfig: {
           columns: 11
       },
       items: [{
               xtype: 'label',
               text: '<%=CustomerName%>',
               cls: 'labelstyle',
               id: 'custnamelab'
           },
           custnamecombo, {
               width:50
           }, {
               xtype: 'label',
               text: '<%=Type%>',
               cls: 'labelstyle',
               id: 'assetGrouplab'
           },
           typeCombo, {
               width: 75
           }, {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'startdatelab',
               text: '<%=StartDate%>'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 185,
               format: getDateTimeFormat(),
               emptyText: '<%=SelectStartDate%>',
               allowBlank: false,
               blankText: '<%=SelectStartDate%>',
               id: 'startdate',
               value: dtprev,
               endDateField: 'enddate'
           }, {
               width: 50
           }, {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'enddatelab',
               text: '<%=EndDate%>'
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
       idProperty: 'lidAndValvesReportId',
       root: 'lidAndValvesReportRoot',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex1'
       }, {
           name: 'assetNumberDataIndex'
       }, {
           name: 'typeDataIndex'
       }, {
           name: 'timeOfOpeningDataIndex'
       }, {
           name: 'timeOfClosingDataIndex'
       }, {
           name: 'locationDataIndex'
       }, {
           name: 'durationDataIndex'
       }, {
           name: 'distanceTravelledDataIndex'
       }]
   });

   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/OilAndGasAction.do?param=getOilAndGasReport',
           method: 'POST'
       }),
       remoteSort: false,
       storeId: 'lidAndValvesReportId',
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
       }, {
           type: 'string',
           dataIndex: 'typeDataIndex'
       }, {
           type: 'date',
           dataIndex: 'timeOfOpeningDataIndex'
       }, {
           type: 'date',
           dataIndex: 'timeOfClosingDataIndex'
       }, {
           type: 'string',
           dataIndex: 'locationDataIndex'
       }, {
           type: 'float',
           dataIndex: 'durationDataIndex'
       }, {
           type: 'float',
           dataIndex: 'distanceTravelledDataIndex'
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
               width: 50,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=Type%></span>",
               dataIndex: 'typeDataIndex',
               width: 50,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=TimeOfOpening%></span>",
               dataIndex: 'timeOfOpeningDataIndex',
               width: 50,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=TimeOfClosing%></span>",
               dataIndex: 'timeOfClosingDataIndex',
               hidden: false,
               width: 50,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=Location%></span>",
               dataIndex: 'locationDataIndex',
               decimalPrecision: 2,
               width: 50,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=Duration%></span>",
               dataIndex: 'durationDataIndex',
               width: 50,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=DistanceTravelled%></span>",
               dataIndex: 'distanceTravelledDataIndex',
               width: 50,
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

   var grid = getGrid('<%=LidAndValvesReport%>', '<%=NoRecordsfound%>', store, screen.width - 270, 430, 9, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');

   firstGridToGetAssetNumber.on({
       "cellclick": {
           fn: onCellClickOnGrid
       }
   });


   var secondGridPanelForLidAndValve = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondPanelId',
       layout: 'table',
       frame: true,
       width: screen.width-250,
       height: 450,
       layoutConfig: {
           columns: 1
       },
       items: [grid],

   });

   var lidAndValvePanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'vesselPanelId',
       layout: 'table',
       frame: false,
       width: '100%',
       height: 460,
       layoutConfig: {
           columns: 2
       },
       items: [firstGridToGetAssetNumber, secondGridPanelForLidAndValve],

   });

   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
      
           title: '<%=LidAndValvesReport%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width-22,
           height:550,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [clientPanel, lidAndValvePanel]
           //bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');

   });
   </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->


