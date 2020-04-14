<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	
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
String Excel;
String NoRecordsFound;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Cash Dispense</title>
    
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
	var custId = '<%=customerId%>';	
	var buttonValue = '';  
	var myWin1; 
	var myWin2;
	var grid;
	var grid1;
	var store;
	var store1;
/////////////////////////////////////////////////////grid for enclose dispense//////////////////////////////////////////////
	
	 var filters1 = new Ext.ux.grid.GridFilters({
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
            type: 'string',
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
  
   var reader1 = new Ext.data.JsonReader({
        idProperty: 'vaultdetailid1',
        root: 'getGridForSummaryEnrouteDispense',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoDataIndex'
        }, {
            name: 'tripstatusDataIndex'
        
        },{
            name: 'tripsheetnoDataIndex'
        
        },{
            name: 'tripnoindex'
        
        }, {
            name: 'dateindex',
            type: 'date',
            format: getDateFormat()
        
        }, {
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
   var store1 = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	      url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getGridForSummaryEnrouteDispense',
	        method: 'POST'
	    }),
	    storeId: 'vaultinwards2',
	    reader: reader1
	});
	
    var createColModel1 = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 60
        }), 
        {
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
                type: 'string'
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
        }
        ,{
            header: "<span style=font-weight:bold;>Custodian 2</span>",
            hidden: false,
            width:500,
            dataIndex: 'custodian2index',
            filter: {
                type: 'string'
            }
        }
        ,{
            header: "<span style=font-weight:bold;>Driver Name</span>",
            hidden: false,
            width:500,
            dataIndex: 'drivernameindex',
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
	
	
	
	var grid2 = getGridArmory2('', 'No Records Found', store1, screen.width - 50, 450, 12, filters1, '', false,'', 12, false, '', true, 'Real Time Data', true, 'Add/Amendment', true, 'Reconciliation', false, 'Excel', jspName, exportDataType, false, 'Pdf');

function getGridArmory2(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, realdata, amendMent, amendMentStr, reconcilation, ModifyDispenseStr, excel, excelstr, jspName, exportDataType, pdf, pdfstr) {
    var grid = new Ext.grid.GridPanel({
        title: gridtitle,
        border: false,
        height: getGridHeight(),
        autoScroll: true,
        store: store,
        id: 'grid2',
        colModel: createColModel1(gridnoofcols),
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


    if (realdata) {
        grid.getBottomToolbar().add([
            '-', {
                text: realdata,
                // iconCls : 'closebutton'
                handler: function() {
                buttonValue = 'realData' ;
                Reconcile(buttonValue);
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
                buttonValue = 'AmendMent' ; 
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
     var spacepanel = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'spacepanel',
        layout: 'table',
        frame: false,
        width: screen.width - 12,
        height: 20,
        layoutConfig: {
            columns: 6
        },
        items: [ 
        ]
    });
      
 var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width -12,
    height:20,
    layoutConfig: {
        columns:6
    },
    items: [{height:5},{height:5},{height:5},{height:5},{height:5},{height:5},{width:5},{
            xtype: 'radio',
            id:'radio1',
            text     : ' ',
        	width    : 30,
        	checked  : true,
        	name     : 'option',
   	        value	: 'Create Dispense For Trips',
   	        style:'margin-left:20px',
            listeners: {
     	    check : function(){
            if(this.checked){
            isactive = 'Create Dispense For Trips'
            panel1.show();
            store.load();
            panel2.hide();
           }
           }
           }
        },{
         xtype: 'label',
            text: 'Create Dispense For Trips ' ,
            style:'vertical-align: -webkit-baseline-middle',
            cls: 'labelstyle',
            id: 'companyNameLabelId',
        }, {width:50},{
  			xtype: 'radio',
            id:'radio2',
            text     : '   ',
   			width    : 30,
		  	checked  : false,
		  	name     : 'option',
   			value	: 'Enroute Dispense',
   			style:'margin-left:20px',  	
    	  	listeners: {
     	  	check : function(){
          	if(this.checked){
          	isactive = 'Enroute Dispense';
          	panel1.hide(); 
          	panel2.show();  
          	store1.load({params:{btn:'enroute'}});
           }
           }
           }           
        },{
         xtype: 'label',
            text: ' Enroute Dispense ',
            style:'vertical-align: -webkit-baseline-middle',
            cls: 'labelstyle',
            id: 'companyNameLabelId2'
        }]
		});

   
     var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
        	type: 'numeric',
            dataIndex: 'slnoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'tripsheetnoDataIndex'
        },{
         
            type: 'date',
            dataIndex: 'dateDataIndex',
           
        },{
            type: 'string',
            dataIndex: 'routeindex'
        }, {
            type: 'int',
            dataIndex: 'noofpoiindex'
     
        }, {
            type: 'int',
            dataIndex: 'atmrepamtindex'
           
        }, {
            type: 'float',
            dataIndex: 'cashdeliveryindex'
       },{     
            type: 'float',
            dataIndex: 'cashpickupindex'
         },{  
          type: 'int', 
            dataIndex: 'totalamountindex'
         }]
    });
  
   var reader = new Ext.data.JsonReader({
        idProperty: 'cashDispenseSummaryId',
        root: 'cashDispenseSummary',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoDataIndex'
        }, {
            name: 'tripsheetnoDataIndex'
        
        },{
            name: 'dateDataIndex',
             type: 'date',
             format: getDateFormat()
        
        },{
            name: 'routeindex'
        
        }, {
            name: 'noofpoiindex'
        }, {
            name: 'atmrepamtindex'
        },{
            name: 'cashdeliveryindex'
             },{
            name: 'cashpickupindex'
             },{
            name: 'totalamountindex'
        
         },{
            name: 'deliveryCustomerId'
        
         }]
    });
	
	 var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	      url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getGridForSummary',
	        method: 'POST'
	    }),
	    storeId: 'cashDispenseSummaryStoreId',
	    reader: reader
	});
	
    var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 60
        }), 
        {
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	dataIndex: 'slnoDataIndex',
            hidden: true,
            width: 200,
            filter: {
                type: 'numeric'
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
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'dateDataIndex',
            hidden: false,
            width: 400,
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
                }
            },{
            header: "<span style=font-weight:bold;>Route</span>",
            dataIndex: 'routeindex',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
            }
            }, {
            header: "<span style=font-weight:bold;>No of POI</span>",
            dataIndex: 'noofpoiindex',
            hidden: false,
            width: 400,
            filter: {
                type: 'int'
            }
        
        },{
            header: "<span style=font-weight:bold;>ATM Rep Amt</span>",
            hidden: false,
            width:500,
            dataIndex: 'atmrepamtindex',
            filter: {
                type: 'int'
            }
             },{
            header: "<span style=font-weight:bold;>Cash Delivery</span>",
            hidden: false,
            width:500,
            dataIndex: 'cashdeliveryindex',
            filter: {
                type: 'float'
            }
             },{
            header: "<span style=font-weight:bold;>Cash Pickup</span>",
            hidden: false,
            width:500,
            dataIndex: 'cashpickupindex',
            filter: {
                type: 'float'
            }
            },{
            header: "<span style=font-weight:bold;>Total Amount</span>",
            hidden: false,
            width:500,
            dataIndex: 'totalamountindex',
            filter: {
                type: 'int'
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



function Reconcile(buttonrec){
	    var selectedrow = grid2.getSelectionModel().getSelected();
		var tripSheetNoselected = selectedrow.get('tripsheetnoDataIndex');
		if(buttonrec == 'AmendMent' && (selectedrow.get('tripstatusDataIndex') == 'CLOSED' || selectedrow.get('tripstatusDataIndex') == 'ARMORY CLOSED')){
			Ext.example.msg("Armory or Trip is closed, cannot add / amend");
           	return;
		}
		else if(buttonrec == 'Reconcile' && selectedrow.get('tripstatusDataIndex') != 'CLOSED'){
			Ext.example.msg("Please close the trip");
           	return;
		}else{
   			myWin2 = new Ext.Window({
        	title: "Dispense Details",
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: true,maximizable: true,
        	buttonAlign: "center",
        	width:screen.width-50,
        	height: screen.height-300,
        	id: 'dispenseId2',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/ReconcilationDetails.jsp?&btn=" + buttonrec + "&TripSheetNo=" + tripSheetNoselected + " '></iframe>",
            scripts: true,
            shim: false
       	});
       	myWin2.show();
       	}
}

	function addNewAsset(btn){
		if(btn == "Create"){
		   myWin1 = new Ext.Window({
        	title: "Dispense Details",
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: true,maximizable: true,
        	buttonAlign: "center",
        	width:screen.width-50,
        	height: screen.height-280,
        	id: 'dispenseId',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/CashDispenseDetailsView.jsp?&btn=" + btn + "'></iframe>",
            scripts: true,
            shim: false
       	});
		}else if(btn == "Modify"){
		var selected = grid.getSelectionModel().getSelected();
		var tripSheetNo = selected.get('tripsheetnoDataIndex');
		var deliveryCustomerId = selected.get('deliveryCustomerId');
       	myWin1 = new Ext.Window({
        	title: "Dispense Details",
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: true,maximizable: true,
        	buttonAlign: "center",
        	width:screen.width-50,
        	height: screen.height-280,
        	id: 'dispenseId',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/CashDispenseDetailsView.jsp?&btn=" + btn + "&tripSheetNo="+tripSheetNo+" &deliveryCustomerId="+deliveryCustomerId+"'></iframe>",
            scripts: true,
            shim: false
       });
       }
	   myWin1.show();
}


	
	
   grid = getGridArmory('', 'No Records Found', store, screen.width - 50, 450, 12, filters, '', false,'', 12, false, '', false, '', true, 'Create Dispense', true, 'Modify Dispense', false, 'Excel', jspName, exportDataType, false, 'Pdf');

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
                 buttonValue = 'Modify' ; 
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
 var panel1 = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
     id: 'clientPanelId14',
        layout: 'table',
        frame: false,
        width: screen.width -42,
        height: 450,
      layoutConfig: {
            columns: 1
        },
        items: [grid 
        ]
    });
   
  var panel2 = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
     id: 'clientPanelId',
        layout: 'table',
        frame: false,
        width: screen.width -42,
        height: 450,
      layoutConfig: {
            columns: 1
        },
        items: [grid2
        ]
    });
    
 Ext.onReady(function() {
    Ext.QuickTips.init();
   // Ext.Ajax.timeout = 180000;
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
        items: [customerComboPanel,spacepanel,panel1,panel2]
  });
   panel1.show();
   	store.load();
   panel2.hide();

	
 
                                  
    sb = Ext.getCmp('form-statusbar');
});</script>
	</body>
</html>

