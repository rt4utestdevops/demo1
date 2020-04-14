<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int systemId = 0;
	int customerId = 0;
	if (loginInfo == null) {
			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		systemId = loginInfo.getSystemId();
		customerId = loginInfo.getCustomerId();

	}
	String selectDate="Select Date";
	String view="View";
	String SLNO="SLNO";
	String restrictiveHoursTripDetails = "Restrictive Hours Trip Details";
	String vehicleNo="Vehicle No";
	String tripNo="Trip No";
	String insertedTime="Inserted Time";
	String validityDate="Validity Date";
	String routeName="Route Name";
	String orgName="Organization Name";
	String NoRecordsfound="No Records Found";
	String ClearFilterData="Clear Filter Data";
	String Excel="Excel";
	String SelectCustomer="Select Customer";
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>RestrictiveHoursTripDetails.jsp</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->


    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
	<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			.x-panel-header
			{
				height: 7% !important;
			}
			.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
				height: 26px !important;
				padding-top: 8px;
			}
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
			}
			 .x-btn-text .clearfilterbutton {
				 font-size : 15px !important;
			 }
		</style>
	 <%}%>
<script>
var outerPanel;
    var jspName = "Restrictive Hours Trip Details";
    var exportDataType = "int,string,string,date,date,string,string";
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                        //store.load();
                    }
                }
            }
    });


 	
  var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: '',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 75,
        layoutConfig: {
            columns: 9
        },
        items: [{
                xtype: 'label',
                text: '<%=SelectCustomer%>' + ' :',
                cls: 'labelstyle',
                id: 'datelabel01'
            },{
                width: 30
            },custnamecombo,
              {
                width: 50
            },{
                xtype: 'label',
                text: '<%=selectDate%>' + ' :',
                cls: 'labelstyle',
                id: 'datelabel'
            },{
                width: 30
            },{
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 120,
                format: getDateFormat(),
                emptyText: 'Select Date',
                allowBlank: false,
                blankText: 'Select Date',
                id: 'dateFieldId',
                value: currentDate
            },
              {
                width: 50
            },{
                xtype: 'button',
                text: '<%=view%>',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 60,
                listeners: {
                    click: {
                        fn: function() {
                            store.load({
                                params: {
                                    jspName:jspName,
                                    CustId: custId,
                                    custName: custName,
                                    date:Ext.getCmp('dateFieldId').getValue()
                                }
                            });
                        }
                    }
                }
            }
        ]
    });
    
    //===================================================	Grid   =============================================================
    
    
     var reader = new Ext.data.JsonReader({
         idProperty: 'readerId',
         root: 'RestrictiveHoursTripDetailsRoot',
         totalProperty: 'total',
         fields: [{
             name: 'slnoIndex'
         }, {
             name: 'vehicleNoDataIndex'
         }, {
             name: 'tripNoDataIndex'
         }, {
             name: 'insertedTimeDataIndex'
         }, {
             name: 'validityDateDataIndex'
         }, {
             name: 'routeNameDataIndex'
         }, {
             name: 'orgNameDataIndex'
         }]
     });
     var store = new Ext.data.GroupingStore({
         autoLoad: false,

         proxy: new Ext.data.HttpProxy({
             url: '<%=request.getContextPath()%>/MiningTimes.do?param=getRestrictiveHoursTripDetails',
             method: 'POST'
         }),
         remoteSort: false,
         sortInfo: {
             field: 'slnoIndex',
             direction: 'ASC'
         },
         storeId: 'StoreId',
         reader: reader
     });

     var filters = new Ext.ux.grid.GridFilters({
         local: true,
         filters: [{
                 type: 'numeric',
                 dataIndex: 'slnoIndex'
             }, {
                 type: 'string',
                 dataIndex: 'vehicleNoDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'tripNoDataIndex'
             }, {
                 type: 'date',
                 dataIndex: 'insertedTimeDataIndex'
             }, {
                 type: 'date',
                 dataIndex: 'validityDateDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'routeNameDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'orgNameDataIndex'
             }]
     });

     var createColModel = function(finish, start) {
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
                 header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
                 dataIndex: 'vehicleNoDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=tripNo%></span>",
                 dataIndex: 'tripNoDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=insertedTime%></span>",
                 dataIndex: 'insertedTimeDataIndex',
                 width: 60,
                 filter: {
                     type: 'date'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=validityDate%></span>",
                 dataIndex: 'validityDateDataIndex',
                 width: 80,
                 filter: {
                     type: 'date'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=routeName%></span>",
                 dataIndex: 'routeNameDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=orgName%></span>",
                 dataIndex: 'orgNameDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
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
     Grid = getGrid('<%=restrictiveHoursTripDetails%>', '<%=NoRecordsfound%>', store, screen.width - 50, 400, 20, filters, '<%=ClearFilterData%>', false, '', 12, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,false,false,'View Details',false,'',false,'',false,'Generate PDF');

    
    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        width: screen.width - 30,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Grid]
       
    });
     Ext.onReady(function() {
     Ext.Ajax.timeout = 360000;
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-22,
            height: screen.height-220,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });

    });
    </script>
      <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
