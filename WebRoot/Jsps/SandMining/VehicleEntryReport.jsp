<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
			session.setAttribute("loginInfoDetails", loginInfo);
		}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		
		int userId=loginInfo.getUserId(); 
        int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		 <title>Vehicle Entry Report.jsp</title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>

     var outerPanel;
 var jspName = "VehicleEntryReport";
 var exportDataType = "int,int,date,string,string,date,date,date,string,date,string,string,string,string,float,float,string,string,date,string,float,string,int,string";
 var selected;
 var grid;
 var buttonValue;
 var dtprev = dateprev;
 var dtcur = datecur;
 var dtnxt = datenext;


 var customercombostore = new Ext.data.JsonStore({
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
                 stockyardStore.load({
                     params: {
                         CustID: custId
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
     emptyText: 'Select Customer',
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
                 stockyardStore.load({
                     params: {
                         CustID: custId
                     }
                 });
                 Ext.getCmp('stockcomboId').reset();
                 
             }
         }
     }
 });


 var stockyardStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getstockLocation',
     id: 'stockyardStoreId',
     root: 'stockStoreRoot',
     autoload: false,
     remoteSort: true,
     fields: ['stockname','uniqueid']
 });

 var stockyardCombo = new Ext.form.ComboBox({
     store: stockyardStore,
     id: 'stockcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Stockyard/Location',
     blankText: 'Stockyard/Location',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField:'uniqueid',
     displayField: 'stockname',
     cls: 'selectstylePerfectnew',
     listeners: {
         select: {
          fn: function() {
                 stockname = Ext.getCmp('stockcomboId').getRawValue();
                 uniqueid = Ext.getCmp('stockcomboId').getValue();
                 store.removeAll();
                 store2.removeAll();
                }
          }
     }
 });

 var customerComboPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'customerComboPanelId',
     layout: 'table',
     frame: false,
     width: screen.width - 30,
     height: 50,
     layoutConfig: {
         columns: 9
     },
     items: [{
             width: 30
         }, {
             xtype: 'label',
             text: 'Customer Name' + ' :',
             cls: 'labelstyle'
         },
         custnamecombo, {
             width: 100
         },
         {
             xtype: 'label',
             cls: 'labelstyle',
             id: 'startdatelab',
             text: 'From Date' + ' :'
         }, {
             xtype: 'datefield',
             cls: 'selectstylePerfect',
             width: 200,
             format: getDateFormat(),
             editable:false,
             id: 'startdate',
             maxValue: dtcur,
             value: dtcur,
             endDateField: 'enddate'
         }, {
             width: 100
         }, {

             xtype: 'label',
             cls: 'labelstyle',
             id: 'enddatelab',
             text: 'To Date' + ' :'
         }, {
             xtype: 'datefield',
             cls: 'selectstylePerfect',
             width: 180,
             format: getDateFormat(),
             editable:false,
             id: 'enddate',
             maxValue: dtnxt,
             value: dtnxt,
             startDateField: 'startdate'
         }, {
             width: 30
         }
     ]
 });


 var customerComboPanel2 = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'customerComboPanelId2',
     layout: 'table',
     frame: false,
     width: screen.width - 30,
     height: 50,
     layoutConfig: {
         columns: 11
     },
     items: [{
             width: 100
         }, {
             xtype: 'label',
             text: 'Stockyard/Location' + ' :',
             cls: 'labelstyle'
         }, stockyardCombo, {
             width: 80
         }, {
             xtype: 'radio',
             id: 'radio1',
             text: ' ',
             width: 30,
             checked: true,
             name: 'option',
             value: 'Abstact',
             style: 'margin-left:20px',
             listeners: {
                 check: function() {
                     if (this.checked) {
                         isactive = 'Abstact',
                         panel1.show();
                         panel2.hide();
                       }
                 }
             }
         }, {
             xtype: 'label',
             text: 'Abstact ',
             style: 'vertical-align: -webkit-baseline-middle',
             cls: 'labelstyle',
             id: 'companyNameLabelId',
         }, {
             width: 50
         }, {

             xtype: 'radio',
             id: 'radio2',
             text: '   ',
             width: 30,
             checked: false,
             name: 'option',
             value: 'Detailed',
             style: 'margin-left:20px',
             listeners: {
                 check: function() {
                     if (this.checked) {
                         isactive = 'Detailed';
                         panel2.show();
                         panel1.hide();
                       }
                 }
             }
         }, {
             xtype: 'label',
             text: ' Detailed ',
             style: 'vertical-align: -webkit-baseline-middle',
             cls: 'labelstyle',
             id: 'companyNameLabelId2'
         },

         {
             width: 90
         },
         {
             xtype: 'button',
             text: 'Submit',
             width: 50,
             listeners: {
                 click: function() {
						
                     if (Ext.getCmp('custcomboId').getValue() == "") {
                         Ext.example.msg("Please Select Customer ");
                         Ext.getCmp('custcomboId').focus();
                         return;
                     }

                     if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                         Ext.example.msg("End Date Should Be Greater than Start Date");
                         return;
                     }

                     var Startdates = Ext.getCmp('startdate').getValue();
                     var Enddates = Ext.getCmp('enddate').getValue();
                     var dateDifrnc = new Date(Enddates).add(Date.DAY, -7);
                     
                     if (Startdates < dateDifrnc) {
                         Ext.example.msg("Difference between two dates should not be  greater than 7 days.");
                         Ext.getCmp('startdate').focus();
                         return;
                     }

                     if (Ext.getCmp('stockcomboId').getValue() == "") {
                         Ext.example.msg("Select Stockyard Location");
                         Ext.getCmp('stockcomboId').focus();
                         return;
                     }
                     Radio1=Ext.getCmp('radio1').getValue();
                     Radio2=Ext.getCmp('radio2').getValue();
                     if(Radio1 == true)
                     {
                     store.load({
                         params: {
                             startDate: Ext.getCmp('startdate').getValue(),
                             endDate: Ext.getCmp('enddate').getValue(),
                             stockname: stockname ,
                             uniqueid:uniqueid,
                             jspName: jspName
                         }
                     });
                     }
                     if(Radio2 == true)
                     {
                      store2.load({
                         params: {
                               stockname: stockname ,
                               startDate: Ext.getCmp('startdate').getValue(),
                               endDate: Ext.getCmp('enddate').getValue(),
                               jspName: jspName
                          }
                     }); 
                    }
                 }
             }
         }
     ]
 });
 
 //////////////////////////////////////////////////////first grid for abstact///////////////////////////////////////////////////////          

 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         type: 'int',
         dataIndex: 'slno1'
     }, {
         type: 'Date',
         dataIndex: 'date'
     }, {
         type: 'int',
         dataIndex: 'noofimg'
     }, {
         type: 'int',
         dataIndex: 'noid'
     }, {
         type: 'int',
         dataIndex: 'gpsfitted'
     }, {
         type: 'int',
         dataIndex: 'gpsnotfitted'
     }]
 });

 var reader = new Ext.data.JsonReader({
     idProperty: 'abstactid1',
     root: 'abstactroot1',
     totalProperty: 'total',
     fields: [{
         name: 'slno1'
     }, {
         name: 'date'
     }, {
         name: 'noofimg'
     }, {
         name: 'noid'
     }, {
         name: 'gpsfitted'
     }, {
         name: 'gpsnotfitted'

     }]
 });

 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getAbstactDetails',
         method: 'POST'
     }),

     storeId: 'lotdetailid',
     reader: reader
 });
 var createColModel = function(finish, start) {
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;>SLNO</span>",
             width: 50
         }), {
             dataIndex: 'slno1',
             hidden: true,
             width: 30,
             header: "<span style=font-weight:bold;>SL NO</span>"
         }, {
             dataIndex: 'date',
             hidden: false,
             width: 60,
             header: "<span style=font-weight:bold;>Date</span>"
         }, {
             dataIndex: 'noofimg',
             hidden: false,
             width: 60,
             header: "<span style=font-weight:bold;>Number of Vehicle Images</span>"
         }, {
             dataIndex: 'noid',
             width: 60,
             header: "<span style=font-weight:bold;>Number of Vehicle Identified</span>"
         }, {
             header: "<span style=font-weight:bold;>GPS Fitted</span>",
             width: 60,
             dataIndex: 'gpsfitted'
         }, {
             header: "<span style=font-weight:bold;>GPS Not Fitted</span>",
             width: 60,
             dataIndex: 'gpsnotfitted'

         }
     ];
     return new Ext.grid.ColumnModel({
         columns: columns.slice(start || 0, finish),
         defaults: {
             sortable: true
         }
     });
 };

 grid = getGridArmory('', 'No Records Found', store, screen.width - 50, 450, 12, filters, '', false, '', 12, false, '', false, '', false, 'Create Dispense', false, 'Modify Dispense', false, 'Excel', jspName, exportDataType, false, 'Pdf');

 function getGridArmory(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, CreateDispense, CreateDispenseStr, ModifyDispense, ModifyDispenseStr, excel, excelstr, jspName, exportDataType, pdf, pdfstr) {
     var grid = new Ext.grid.GridPanel({
         title: gridtitle,
         border: false,
         height: getGridHeight(),
         autoScroll: true,
         store: store,
         id: 'grid',
         colModel: createColModel(gridnoofcols),
         loadMask: true,
         view: new Ext.grid.GroupingView({
             autoFill: true,
             groupTextTpl: getGroupConfig(),
             emptyText: emptytext,
             deferEmptyText: false
         }),
         listeners: {
             render: function(grid) {
                 grid.store.on('load', function(store, records, options) {
                     grid.getSelectionModel().selectFirstRow();
                 });
             }
         },

         selModel: new Ext.grid.RowSelectionModel(),

         plugins: filters,
         bbar: new Ext.Toolbar({})
     });
     if (width > 0) {
         grid.setSize(width, height);
     }
     grid.getBottomToolbar().add([
         '->', {
             text: filterstr,
             iconCls: 'clearfilterbutton',
             handler: function() {
                 grid.filters.clearFilters();
             }
         }
     ]);
     if (reconfigure) {
         grid.getBottomToolbar().add([
             '-', {
                 text: reconfigurestr,
                 handler: function() {
                     grid.reconfigure(store, createColModel(reconfigurenoofcols));
                 }
             }
         ]);
     }
     if (group) {
         grid.getBottomToolbar().add([
             '-', {
                 text: groupstr,
                 handler: function() {
                     store.clearGrouping();
                 }
             }
         ]);
     }

     if (chart) {
         grid.getBottomToolbar().add([
             '-', {
                 text: chartstr,
                 handler: function() {
                     columnchart();
                 }
             }
         ]);
     }
     if (CreateDispense) {
         grid.getBottomToolbar().add([
             '-', {
                 text: CreateDispenseStr,
                 // iconCls : 'closebutton'
                 handler: function() {
                     buttonValue = 'Create';
                     addNewAsset(buttonValue);
                 }
             }
         ]);
     }
     if (ModifyDispense) {
         grid.getBottomToolbar().add([
             '-', {
                 text: ModifyDispenseStr,
                 // iconCls : 'closebutton',
                 handler: function() {
                     buttonValue = 'Modify';
                     addNewAsset(buttonValue);
                 }
             }
         ]);
     }

     if (excel) {
         grid.getBottomToolbar().add([
             '-', {
                 text: '',
                 iconCls: 'excelbutton',
                 handler: function() {
                     getordreport('xls', 'All', jspName, grid, exportDataType);
                 }
             }
         ]);
     }
     if (pdf) {
         grid.getBottomToolbar().add([
             '-', {
                 text: '',
                 iconCls: 'pdfbutton',
                 handler: function() {
                     getordreport('pdf', 'All', jspName, grid, exportDataType);

                 }
             }
         ]);
     }
     return grid;
 }
 
 ////////////////////////////////////////////////////////////////second grid for detailed////////////////////////////////////////////////////////////////////////////////////

 var filters2 = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         type: 'int',
         dataIndex: 'slno'
     }, {
         type: 'Date',
         dataIndex: 'datendtime'
     }, {
         type: 'int',
         dataIndex: 'vehicleimg'
     }, {
         type: 'string',
         dataIndex: 'vehno'
     }, {
         type: 'string',
         dataIndex: 'gpsfitted'
     }]
 });

 var reader2 = new Ext.data.JsonReader({
     idProperty: 'detailedid',
     root: 'detailedroot',
     totalProperty: 'total',
     fields: [{
         name: 'slno'
     }, {
         name: 'datendtime'
     }, {
         name: 'vehicleimg'
     }, {
         name: 'vehno'
     }, {
         name: 'gpsfitted'

     }]
 });

 var store2 = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDetailedDetails',
         method: 'POST'
     }),
 
     storeId: 'detailedroot',
     reader: reader2
 });
 var createColModel2 = function(finish, start) {
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;>SLNO</span>",
             width: 50
         }), {
             dataIndex: 'slno',
             hidden: true,
             header: "<span style=font-weight:bold;>SL NO</span>"
         }, {
             dataIndex: 'datendtime',
             hidden: false,
             width: 80,
             header: "<span style=font-weight:bold;>Date And Time</span>"
         }, {
             dataIndex: 'vehicleimg',
             hidden: false,
             width: 80,
             header: "<span style=font-weight:bold;>Vehicle Images</span>",
         }, {
             dataIndex: 'vehno',
             hidden: false,
             width: 50,
             header: "<span style=font-weight:bold;> Vehicle Number</span>"
         }, {
             header: "<span style=font-weight:bold;>GPS Fitted (Yes/No)</span>",
             hidden: false,
             width: 50,
             dataIndex: 'gpsfitted'

         }
     ];
     return new Ext.grid.ColumnModel({
         columns: columns.slice(start || 0, finish),
         defaults: {
             sortable: true
         }
     });
 };

 var grid2 = getGridArmory2('', 'No Records Found', store2, screen.width - 50, 450, 22, filters2, '', false, '', 12, false, '', false, '', false, 'Add/Amendment', false, 'Reconciliation', false, 'Excel', jspName, exportDataType, false, 'Pdf');

 function getGridArmory2(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, amendMent, amendMentStr, reconcilation, ModifyDispenseStr, excel, excelstr, jspName, exportDataType, pdf, pdfstr) {
     var grid = new Ext.grid.GridPanel({
         title: gridtitle,
         border: false,
         height: getGridHeight(),
         autoScroll: true,
         store: store,
         id: 'grid2',
         colModel: createColModel2(gridnoofcols),
         loadMask: true,
         view: new Ext.grid.GroupingView({
             autoFill: true,
             groupTextTpl: getGroupConfig(),
             emptyText: emptytext,
             deferEmptyText: false
         }),
         listeners: {
             render: function(grid) {
                 grid.store.on('load', function(store, records, options) {
                     grid.getSelectionModel().selectFirstRow();
                 });
             }
         },

         selModel: new Ext.grid.RowSelectionModel(),

         plugins: filters,
         bbar: new Ext.Toolbar({})
     });
     if (width > 0) {
         grid.setSize(width, height);
     }
     grid.getBottomToolbar().add([
         '->', {
             text: filterstr,
             iconCls: 'clearfilterbutton',
             handler: function() {
                 grid.filters.clearFilters();
             }
         }
     ]);
     if (reconfigure) {
         grid.getBottomToolbar().add([
             '-', {
                 text: reconfigurestr,
                 handler: function() {

                 }
             }
         ]);
     }
     if (group) {
         grid.getBottomToolbar().add([
             '-', {
                 text: groupstr,
                 handler: function() {

                 }
             }
         ]);
     }

     if (chart) {
         grid.getBottomToolbar().add([
             '-', {
                 text: chartstr,
                 handler: function() {
                     columnchart();
                 }
             }
         ]);
     }
     if (amendMent) {
         grid.getBottomToolbar().add([
             '-', {
                 text: amendMentStr,
                 // iconCls : 'closebutton'
                 handler: function() {
                     buttonValue = 'AmendMent';
                     Reconcile(buttonValue);
                 }
             }
         ]);
     }
     if (reconcilation) {
         grid.getBottomToolbar().add([
             '-', {
                 text: ModifyDispenseStr,
                 // iconCls : 'closebutton',
                 handler: function() {
                     buttonValue = 'Reconcile';
                     Reconcile(buttonValue);
                 }
             }
         ]);
     }

    if (excel) {
         grid.getBottomToolbar().add([
             '-', {
                 text: '',
                 iconCls: 'excelbutton',
                 handler: function() {
                     getordreport('xls', 'All', jspName, grid, exportDataType);
                 }
             }
         ]);
     }
     if (pdf) {
         grid.getBottomToolbar().add([
             '-', {
                 text: '',
                 iconCls: 'pdfbutton',
                 handler: function() {
                     getordreport('pdf', 'All', jspName, grid, exportDataType);

                 }
             }
         ]);
     }
   return grid;
 }
 
 var panel1 = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     id: 'clientPanelId14',
     layout: 'table',
     frame: false,
     width: screen.width - 42,
     height: 450,
     layoutConfig: {
         columns: 1
     },
     items: [grid]
 });

 var panel2 = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     id: 'clientPanelId144',
     layout: 'table',
     frame: false,
     width: screen.width - 42,
     height: 450,
     layoutConfig: {
         columns: 1
     },
     items: [grid2]
 });


 Ext.onReady(function() {
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         title: 'Vehicle Entry Report',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         width: screen.width - 25,
         height: 600,
         cls: 'outerpanel',
         layout: 'table',
         layoutConfig: {
             columns: 1
         },
         items: [customerComboPanel, customerComboPanel2, panel1, panel2]
     });
     sb = Ext.getCmp('form-statusbar');
 });
</script>
</body>
</html>
<%}%>

    