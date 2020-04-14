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
		
			 
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Organization_Code");
tobeConverted.add("Organization_Name");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String NoRecordsFound=convertedWords.get(0);
String ClearFilterData=convertedWords.get(1);
String SLNO=convertedWords.get(2);
String SelectCustomer=convertedWords.get(3);
String CustomerName=convertedWords.get(4);
String organizationCode=convertedWords.get(5);
String organizationName=convertedWords.get(6);

String ProductionSummaryReport = "Production Summary Report";
String tcNo = "TC Number";
String productionQty = "Production Quantity";


int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=ProductionSummaryReport%></title>
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
  var jspName = "ProductionSummaryReport";
  var exportDataType = "int,string,string,string,number";
  var grid;
  var dtprev = dateprev;
  var dtcur = datecur;
  //----------------------------------customer store---------------------------// 
  var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
      id: 'CustomerStoreId',
      root: 'CustomerRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['CustId', 'CustName'],
      listeners: {
          load: function(custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                /*  store.load({
	               params: {
	                 custId: Ext.getCmp('custcomboId').getValue(),
	                 jspName: jspName,
	                 custName: Ext.getCmp('custcomboId').getRawValue(),
		           }
		         });  */
              }
          }
      }
  });
  //******************************************************************customer Combo******************************************//
  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomer%>',
      resizable: true,
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
             /*     store.load({
	               params: {
	                 custId: Ext.getCmp('custcomboId').getValue(),
	                 jspName: jspName,
	                 custName: Ext.getCmp('custcomboId').getRawValue(),
		           }
		         });  */
              }
          }
      }
  });
  //*************************************************Client Panel**************************************************************//
  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: false,
      width: screen.width - 60,
      height: 50,
      layoutConfig: {
          columns: 15
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'ltspcomboId'
          },
          custnamecombo, {
              width: 25
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              width: 200,
              text: 'From Date' + ' :'
          }, {
              width: 5
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 120,
              format: getDateFormat(),
              emptyText: 'Select From Date',
              allowBlank: false,
              blankText: 'Select From Date',
              id: 'startdate',
              value: dtprev
          },
          {
              width: 70
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              width: 200,
              text: 'To Date' + ' :'
          }, {
              width: 5
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 160,
              format: getDateFormat(),
              emptyText: 'Select To Date',
              allowBlank: false,
              blankText: 'Select To Date',
              id: 'enddate',
              value: dtcur
          }, {
              width: 20
          }, {
              xtype: 'button',
              text: 'View',
              id: 'submitId',
              cls: 'buttonStyle',
              width: 60,
              handler: function() {
              if (Ext.getCmp('custcomboId').getValue() == "") {
                  Ext.example.msg("Select Customer");
                  Ext.getCmp('custcomboId').focus();
                  return;
              }
              if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                  Ext.example.msg("To Date must be greater than From Date");
                  Ext.getCmp('enddate').focus();
                  return;
              }
           
             store.load({
	               params: {
	                 custId: Ext.getCmp('custcomboId').getValue(),
	                 jspName: jspName,
	                 custName: Ext.getCmp('custcomboId').getRawValue(),
	                 endDate: Ext.getCmp('enddate').getValue(),
        		     startDate: Ext.getCmp('startdate').getValue()
		           }
		         });
          	
         }
       }
      ]
  });
  
      //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'ProductionSummaryReaderId',
      root: 'ProductionSummaryRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      },{
          name: 'orgNameInd'
      },{
          name: 'orgCodeInd'
      },{
          name: 'orgIdInd'
      },{
      	  name: 'tcIdInd'
      },{
          name: 'tcNoInd'
      },{
          name: 'productionQtyInd'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/ProductionMasterAction.do?param=getProductionSummaryDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'ProductionSummaryStoreId',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      },{
          type: 'string',
          dataIndex: 'orgNameInd'
      },{
          type: 'string',
          dataIndex: 'orgCodeInd'
      },{
          type: 'string',
          dataIndex: 'tcNoInd'
      },{
      	  type: 'numeric',
      	  dataIndex: 'productionQtyInd'
      }]
  });
  var createColModel = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }),{
              dataIndex: 'slnoIndex',
              hidden: true,
              width: 50,
              header: "<span style=font-weight:bold;><%=SLNO%></span>"
          },{
              dataIndex: 'orgNameInd',
              width: 200,
              header: "<span style=font-weight:bold;><%=organizationName%></span>"
          },{
              dataIndex: 'orgCodeInd',
              width: 200,
              header: "<span style=font-weight:bold;><%=organizationCode%></span>"
          },{
              dataIndex: 'tcNoInd',
              width: 200,
              header: "<span style=font-weight:bold;><%=tcNo%></span>"
          },{
              dataIndex: 'productionQtyInd',
              align:'right',
              width: 200,
              header: "<span style=font-weight:bold;><%=productionQty%></span>"
          }];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };
  
  grid = getGrid('<%=ProductionSummaryReport%>', '<%=NoRecordsFound%>', store, screen.width - 40, 455, 10, filters, '<%=ClearFilterData%>', false, '', 9, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF');
  
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
    store.load({
	               params: {
	                 custId: Ext.getCmp('custcomboId').getValue(),
	                 jspName: jspName,
	                 custName: Ext.getCmp('custcomboId').getRawValue(),
	                 endDate: Ext.getCmp('enddate').getValue(),
        		     startDate: Ext.getCmp('startdate').getValue()
		           }
		         });
});

  </script>
</body>
</html>
<%}%>
 
