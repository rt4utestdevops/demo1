<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	String responseafterview="''";
	String feature="1";
	if(session.getAttribute("responseafterview")!=null){
	   responseafterview="'"+session.getAttribute("responseafterview").toString()+"'";
		session.setAttribute("responseafterview",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Dispense History</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
} 
.labelstyle {
	spacing: 10px;
	height: 20px;
	width: 150 px !important;
	min-width: 150px !important;
	margin-bottom: 5px !important;
	margin-left: 5px !important;
	font-size: 12px;
	font-family: sans-serif;
	font-weight:bold;
}
</style>
<body>
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
	<%} %>
	<jsp:include page="../Common/ExportJS.jsp" />
<script>
	var outerPanel;
    var jspName = "vaultoperations";
	var exportDataType = "numeric,string,string,string,string,string,string,string";
	var buttonValue = '';  
	var grid;
	var store;
    var toDate = datecur;
    var fromDate = twoDaysPrev;
    var startDate = new Ext.form.DateField({
        fieldLabel: '',
        width: 140,
        id: 'startdate',
        format: 'd-m-Y',
        value: fromDate,
        menuListeners: {
            select: function (m, d) {
                this.setValue(d);
				store.load({params: {startDate: ''}});
            }
        }
    });

    var endDate = new Ext.form.DateField({
        fieldLabel: '',
        id: 'enddate',
        width: 140,
        format: 'd-m-Y',
        value: toDate,
        menuListeners: {
            select: function (m, d) {
                this.setValue(d);
				store.load({params: {startDate: ''}});
            }
        }
    });
    var datePanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 10
        },
        height:50,
        items: [{width:30},{
            xtype: 'label',
            text: 'From Date :',
            width: 70,
            cls: 'labelstyle'
        },{width:10},startDate,{width: 60},{
            xtype: 'label',
            text: 'To Date :',
            width: 70,
            cls: 'labelstyle'
        },{width:10},endDate, {width: 250},{
            text: 'View',
            xtype: 'button',
            width: 50,
            cls: 'bskExtStyle',
            listeners: {
                click: {
                    fn: function () {
                        if (Ext.getCmp('startdate').getValue() == "") {
                            Ext.example.msg("Please Select From Date");
                            Ext.getCmp('startdate').focus();
                            return;
                        }
                        if (Ext.getCmp('enddate').getValue() == "") {
                            Ext.example.msg("Please Select To Date");
                            Ext.getCmp('enddate').focus();
                            return;
                        } // end of if
                        if (DateCompare3(document.getElementById('startdate').value, document.getElementById('enddate').value) == false) {
							Ext.example.msg("To Date should be greater than From Date");
							return;
                        }

                        if (checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue())) {
                           Ext.example.msg("Difference between two days should be 1 month");
                            return;
                        }
						store.load({
                            params: {
                                startDate: Ext.getCmp('startdate').getValue(),
                                endDate: Ext.getCmp('enddate').getValue()
                            }
                        });
                    } // end of function
                } // end of click
            } // end of listener
        }] // End of Items
    }); // End of DatePanel 
	
	var filters = new Ext.ux.grid.GridFilters({
    	local: true,
        filters: [{
        	type: 'numeric',
            dataIndex: 'slnoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'tripstatusDataIndex'
        },{
            type: 'string',
            dataIndex: 'tripsheetnoDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'tripnoindex'
        }, {
            type: 'date',
            dataIndex: 'dateindex'
     
        }, {
            type: 'string',
            dataIndex: 'routeindex'
           
        }, {
            type: 'int',
            dataIndex: 'noofpoiindex'
       	},{     
            type: 'string',
            dataIndex: 'vehiclenoindex'
        },{  
       		type: 'string',
            dataIndex: 'custodian1index'
        },{  
       		type: 'string',
            dataIndex: 'custodian2index'
        },{  
       		type: 'string',
            dataIndex: 'drivernameindex'
        }]
	});
  
	var reader = new Ext.data.JsonReader({
    	idProperty: 'vaultdetailid1',
        root: 'getDispenseHistoryRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoDataIndex'
        }, {
            name: 'tripstatusDataIndex'
        },{
            name: 'tripsheetnoDataIndex'
        },{
            name: 'tripnoindex'
        },{
            name: 'dateindex',
            type: 'date',
            format: getDateFormat()
        },{
            name: 'routeindex'
        },{
            name: 'noofpoiindex'
        },{
            name: 'vehiclenoindex'
        },{
            name: 'custodian1index'
        },{
            name: 'custodian2index'
        },{
            name: 'drivernameindex'
        }]
	});
   
	var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	    url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getDispenseHistory',
	    method: 'POST'
	    }),
	    autoLoad: false,
	    reader: reader
	});
	
    var createColModel = function (finish, start) {
    var columns = [
    	new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 60
        }),{
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	dataIndex: 'slnoDataIndex',
            hidden: true,
            width: 200,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Trip Status</span>",
            dataIndex: 'tripstatusDataIndex',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
                }
        },{
            header: "<span style=font-weight:bold;>Trip Sheet No</span>",
            dataIndex: 'tripsheetnoDataIndex',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
                }
        },{
            header: "<span style=font-weight:bold;>Trip No</span>",
            dataIndex: 'tripnoindex',
            hidden: false,
            width: 400,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'dateindex',
            hidden: false,
            width: 400,
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Route</span>",
            hidden: false,
            width:500,
            dataIndex: 'routeindex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>No of POI</span>",
            hidden: false,
            width:500,
            dataIndex: 'noofpoiindex',
            filter: {
                type: 'int'
            }
        },{
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            hidden: false,
            width:500,
            dataIndex: 'vehiclenoindex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Custodian 1</span>",
            hidden: false,
            width:500,
            dataIndex: 'custodian1index',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Custodian 2</span>",
            hidden: false,
            width:500,
            dataIndex: 'custodian2index',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Driver Name</span>",
            hidden: false,
            width:500,
            dataIndex: 'drivernameindex',
            filter: {
                type: 'string'
            }
        }];
    	return new Ext.grid.ColumnModel({
        	columns: columns.slice(start || 0, finish),
        	defaults: {
            	sortable: true
        	}
    	});
	};
	var grid = getGridArmory2('', 'No Records Found', store, screen.width - 40, 450, 12, filters, '', false,'', 12, false, 'Excel', jspName, exportDataType, false, 'Pdf');

	function getGridArmory2(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, excel, excelstr, jspName, exportDataType, pdf, pdfstr) {
    var grid = new Ext.grid.GridPanel({
    	title: gridtitle,
        border: false,
        height: getGridHeight(),
        autoScroll: true,
        store: store,
        id: 'grid2',
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
    '->',{
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

	Ext.onReady(function() {
		Ext.QuickTips.init();
    	Ext.form.Field.prototype.msgTarget = 'side';
    	outerPanel = new Ext.Panel({
        renderTo: 'content',
        id: 'outerPanel',
        standardView: true,
        autoScroll: false,
        frame: true,
        border: true,
        height:510,
        width:screen.width-22,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [datePanel,grid]
  		});
	});
</script>
</body>
</html>

