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
		 <title>Permit Report.jsp</title>
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
 var jspName = "PERMIT REPORT";
 var exportDataType = "int,string,string,string,string,string,number,number,number,number,number,number,number,string,string";
 var grid;
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
             }
         }
     }
 });


 var custnamecombo = new Ext.form.ComboBox({
     store: customercombostore,
     id: 'custcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Select Customer Name',
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'CustId',
     displayField: 'CustName',
     cls: 'selectstylePerfectnew',
     width:200,
     listeners: {
         select: {
             fn: function() {
                 custId = Ext.getCmp('custcomboId').getValue();
                  OrganisationStore.load({
                     params: {
                         CustID: custId
                     }
                 });
                 store.load({
                     params: {
                         CustID: custId,
                         jspName: jspName,
                         CustName: Ext.getCmp('custcomboId').getRawValue(),
                         OrgID:OrganisationId,
                         mineral:mineral,
                         startdate: Ext.getCmp('startdate').getValue(),
                         enddate: Ext.getCmp('enddate').getValue()
                      }
                 });
                  Ext.getCmp('MineralcomboId').reset();
                  Ext.getCmp('OrganisationcomboId').reset();
             }
         }
     }
 });
 

 var mineraltype = new Ext.data.SimpleStore({
     id: 'mineraltypeId',
     fields: ['Name', 'Value'],
     autoLoad: false,
     data: [
         ['Iron Ore', 'Iron Ore'],
         ['Iron Ore(E-Auction)', 'Iron Ore(E-Auction)']
       ]
 });
 var MineraltypeCombo = new Ext.form.ComboBox({
     store: mineraltype,
     id: 'MineralcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Select Mineral Type',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'Value',
     displayField: 'Name',
     cls: 'selectstylePerfectnew',
     width:200,
     listeners: {
         select: {
             fn: function() {
             mineral = Ext.getCmp('MineralcomboId').getRawValue();
             OrganisationStore.load({
                     params: {
                         CustID: custId
                     }
                 });
             }
         }
     }
 });
 
 var OrganisationStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/PermitReportAction.do?param=getOrganisationName',
     id: 'hubLocationStoreId',
     root: 'OrgStoreRoot',
     autoload: false,
     remoteSort: true,
     fields: ['Orgname', 'OrgID']
 });

    var OrgCombo = new Ext.form.ComboBox({
     store: OrganisationStore,
     id: 'OrganisationcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Select Organisation Name',
     blankText: 'Select Organisation Name',
     resizable: true,
     selectOnFocus: true,
     allowBlank: true,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'OrgID',
     displayField: 'Orgname',
     cls: 'selectstylePerfectnew',
     width:200,
     listeners: {
         select: {
             fn: function() {
                 OrganisationId = Ext.getCmp('OrganisationcomboId').getValue();
             }
         }
     } 
 });
 
 
 var editInfo1 = new Ext.Button({
    text: 'View',
    id: 'reportId',
    cls: 'buttonStylenew',
    width: 80,
    listeners: {
             click: {
                 fn: function() {
                     if (Ext.getCmp('custcomboId').getValue() == "") {
                         Ext.example.msg('Select Customer Name');
                         Ext.getCmp('custcomboId').focus();
                         return;
                     }
                     
                     if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                             Ext.example.msg("End Date Should Be Greater than Start Date");
                             return;
                       }
                       
                      if (Ext.getCmp('MineralcomboId').getValue() == "") {
                         Ext.example.msg("Select Mineral Type");
                         Ext.getCmp('MineralcomboId').focus();
                        return;
                       }
                     if (Ext.getCmp('OrganisationcomboId').getRawValue() == "") {
                         Ext.example.msg("Select Organization Name");
                         Ext.getCmp('OrganisationcomboId').focus();
                        return;
                     }			
				         var CustomerName = Ext.getCmp('custcomboId').getValue();
				         custId = Ext.getCmp('custcomboId').getValue();
	                     store.load({
	                     params: {
                         CustID: custId,
                         jspName: jspName,
                         CustName: Ext.getCmp('custcomboId').getRawValue(),
                         OrgID:OrganisationId,
                         Orgname:Ext.getCmp('OrganisationcomboId').getRawValue(),
                         mineral:mineral,
                         startdate: Ext.getCmp('startdate').getValue(),
                         enddate: Ext.getCmp('enddate').getValue()
                      }
                 });
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
     height: 75,
     layoutConfig: {
         columns: 8
     },
     items: [{
             xtype: 'label',
             text: 'Customer Name' + ' :',
             cls: 'labelstylenew'
         },
         custnamecombo,
         {
         width:180
         },
         {
              xtype: 'label',
              cls: 'labelstylenew',
              id: 'startdatelab',
              text: 'Start Date' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              width: 200,
              format: getDateFormat(),
              id: 'startdate',
              maxValue:dtcur,
              value: dtcur,
              endDateField: 'enddate'
          }, {width:100},{
              xtype: 'label',
              cls: 'labelstylenew',
              id: 'enddatelab',
              text: 'End Date' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              width: 180,
              format: getDateFormat(),
              id: 'enddate',
              maxValue:dtnxt,
              value: dtnxt,
              startDateField: 'startdate'
          },
          {
             xtype: 'label',
             text: 'Mineral Type' + ' :',
             cls: 'labelstylenew'
         },MineraltypeCombo,{width:50},
         {
          xtype: 'label',
             text: 'Organization Name' + ' :',
             cls: 'labelstylenew'
         },OrgCombo,
         {width:100},
        editInfo1
     ]
 });
 
 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         type: 'int',
         dataIndex: 'slnoindex'
      }, {
         type: 'string',
         dataIndex: 'permitno'
       }, {
         type: 'string',
         dataIndex: 'organizationname'       
     }, {
         type: 'string',
         dataIndex: 'tcnoindex'
     }, {
         type: 'string',
         dataIndex: 'permittypeindex'
     }, {
         type: 'string',
         dataIndex: 'mineraltypeindex'
     }, {
         type: 'numeric',
         dataIndex: 'romquantityindex'
     }, {
         type: 'numeric',
         dataIndex: 'finesquantityindex'
     }, {
         type: 'numeric',
         dataIndex: 'lumpsquantityindex'
     }, {
         type: 'numeric',
         dataIndex: 'tailingsQtyInd'
     }, {
         type: 'numeric',
         dataIndex: 'finesquantityindex'
     }, {
         type: 'numeric',
         dataIndex: 'rejectsQtyInd'
     }, {
         type: 'numeric',
         dataIndex: 'concentratesQtyInd'
     }, {
         type: 'numeric',
         dataIndex: 'transportedquantityindex'
     }, {
         type: 'string',
         dataIndex: 'tradernameindex' 
      }, {
         type: 'string',
         dataIndex: 'tradercodeindex'      
           
     }]
 });

 var reader = new Ext.data.JsonReader({
     idProperty: 'permitid',
     root: 'permitroot',
     totalProperty: 'total',
     fields: [{
        name: 'slnoindex'
     }, {
        name: 'permitno'
     }, {
        name: 'organizationname'
     }, {
        name: 'tcnoindex'
     }, {
         name: 'permittypeindex'
     }, {
        name: 'mineraltypeindex'
     }, {
         name: 'romquantityindex'
     }, {
         name: 'finesquantityindex'
     }, {
         name: 'lumpsquantityindex'
     }, {
         name: 'tailingsQtyInd'
     }, {
         name: 'rejectsQtyInd'
     }, {
         name: 'concentratesQtyInd'
     }, {
         name: 'transportedquantityindex'
     }, {
         name: 'tradernameindex' 
      }, {
         name: 'tradercodeindex'   
     }]
 });

 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/PermitReportAction.do?param=getPermitReportDetails',
         method: 'POST'
     }),

     storeId: 'lotdetailid',
     reader: reader
 });
 var createColModel = function(finish, start) {
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;>SLNO</span>",
             width:50
         }), {
             dataIndex: 'slnoindex',
             hidden: true,
             header: "<span style=font-weight:bold;>SL NO</span>"
         }, {
             dataIndex: 'permitno',
             hidden: false,
             header: "<span style=font-weight:bold;>Permit No</span>"
         }, {
             dataIndex: 'organizationname',
             hidden: false,
             header: "<span style=font-weight:bold;>Organization Name</span>"
         }, {
             dataIndex: 'tcnoindex',
             hidden: false,
             header: "<span style=font-weight:bold;>TC No</span>"
         }, {
             header: "<span style=font-weight:bold;>Permit Type</span>",
             dataIndex: 'permittypeindex'
          }, {
             header: "<span style=font-weight:bold;>Mineral Type</span>",
             dataIndex: 'mineraltypeindex'
         }, {
             header: "<span style=font-weight:bold;>ROM Quantity</span>",
             dataIndex: 'romquantityindex',
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Fines Quantity</span>",
             dataIndex: 'finesquantityindex',
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Lumps Quantity</span>",
             dataIndex: 'lumpsquantityindex',
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Tailings Quantity</span>",
             dataIndex: 'tailingsQtyInd',
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Rejects Quantity</span>",
             dataIndex: 'rejectsQtyInd',
             hidden: true,
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Concentrates Quantity</span>",
             dataIndex: 'concentratesQtyInd',
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Transported Quantity</span>",
             dataIndex: 'transportedquantityindex',
             align: 'right'
         }, {
             header: "<span style=font-weight:bold;>Buying Org/Trader Name</span>",
             dataIndex: 'tradernameindex'
       }, {
             header: "<span style=font-weight:bold;>Buying Org/Trader Code</span>",
             dataIndex: 'tradercodeindex'
        }
     ];
     return new Ext.grid.ColumnModel({
         columns: columns.slice(start || 0, finish),
         defaults: {
             sortable: true
         }
     });
 };

 grid = getGrid('Permit Report', 'NoRecordsFound', store, screen.width - 40, 400, 16, filters, 'ClearFilterData', false, '', 18, false, '', false, '', true, 'Excel', jspName, exportDataType,false,'PDF');
 
 Ext.onReady(function() {
	     Ext.QuickTips.init();
	     Ext.form.Field.prototype.msgTarget = 'side';
	     outerPanel = new Ext.Panel({
         title: '',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         width: screen.width - 30,
         height: screen.height-280,
         cls: 'outerpanel',
         layout: 'table',
         layoutConfig: {
             columns: 1
         },
         items: [customerComboPanel,grid]
     });
      var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,150);
    }
    sb = Ext.getCmp('form-statusbar');
 });
</script>
</body>
</html>
<%}%>
