<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
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
CashVanManagementFunctions cvm = new CashVanManagementFunctions();
String toDate = cvm.setCurrentDateForReports(0)+" 23:59:59";
String fromDate = cvm.setCurrentDateForReports(6)+" 00:00:00";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Vault Inward</title>
    
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
	var exportDataType = "numeric,string,string,string,string";
	var custId = '<%=customerId%>';	
	var buttonValue = '';  
	var InwardId = 0;	  
  	var myWin1;
    
    var startDate = new Ext.form.DateField({
        fieldLabel: '',
        width: 140,
        id: 'startdate',
        format: 'd-m-Y H:i:s',
        value: '<%=fromDate%>',
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
        format: 'd-m-Y H:i:s',
        value: '<%=toDate%>',
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
                       var stdt =  new Date('DD-MM-YYYY HH:MM:SS'); //t4u506 
                       var etdt =  new Date('DD-MM-YYYY HH:MM:SS'); //t4u506 
                       stdt = Ext.getCmp('startdate').getValue();
                        if (stdt  == "")
                     
                         {
                            Ext.example.msg("Please Select From Date");
                            Ext.getCmp('startdate').focus();
                            return;
                        }
                      //  if (etdt=Ext.getCmp('enddate').getValue() == "")
                      etdt=Ext.getCmp('enddate').getValue() ;
                           if (etdt == "")
                            {
                            Ext.example.msg("Please Select To Date");
                            Ext.getCmp('enddate').focus();
                            return;
                        } // end of if                        
                        if (DateCompare3(document.getElementById('startdate').value, document.getElementById('enddate').value) == false) {
						//   if (DateCompare3(stdt, etdt == false)) {
							Ext.example.msg("To Date should be greater than From Date");
							return;
                        }
			//t4u506 end 
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
            type: 'int',
            dataIndex: 'inwardIdDataIndex'
        },{
            type: 'int',
            dataIndex: 'cvsCustIdDataIndex'
        },{
            type: 'string',
            dataIndex: 'customernameindex'
        }, {
            type: 'date',
            dataIndex: 'dateindex'
       }, {
            type: 'string',
            dataIndex: 'sealnumberindex'
           
        }, {
            type: 'int',
            dataIndex: 'totalamountindex'
         },{
            type: 'string',
            dataIndex: 'inwardModeDataIndex'
         },{
            type: 'string',
            dataIndex: 'cashTypeDataIndex'
         },{
            type: 'string',
            dataIndex: 'TripSheetNoDataIndex'
         }]
    });
  
   var reader = new Ext.data.JsonReader({
        idProperty: 'vaultdetailid',
        root: 'vaultTypeRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoDataIndex'
        }, {
            name: 'inwardIdDataIndex'
        
        },{
            name: 'cvsCustIdDataIndex'
        
        },{
            name: 'customernameindex'
        
        }, {
            name: 'dateindex',
            type: 'date',
            dateFormat: 'd-m-Y h:i:s'
        }, {
            name: 'sealnumberindex'
        },{
            name: 'totalamountindex'
        
         },{
            name: 'inwardModeDataIndex'
        
         },
		 {
            name: 'cashTypeDataIndex'
        
         },
		 {
            name: 'TripSheetNoDataIndex'
        
         }

         ]
    });
   var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/ArmoryAction.do?param=getVaultInward',
	        method: 'POST'
	    }),
	    autoLoad: false,
	    storeId: 'vaultinwards',
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
            header: "<span style=font-weight:bold;>Inward Id</span>",
            dataIndex: 'inwardIdDataIndex',
            hidden: true,
            width: 400,
            filter: {
                type: 'int'
                }
            },{
            header: "<span style=font-weight:bold;>Customer Id</span>",
            dataIndex: 'cvsCustIdDataIndex',
            hidden: true,
            width: 400,
            filter: {
                type: 'int'
                }
            },{
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'customernameindex',
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
           renderer: Ext.util.Format.dateRenderer('d-m-Y h:i:s'),
           filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Seal Number</span>",
            hidden: false,
            width: 500,
            dataIndex: 'sealnumberindex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Total Amount (LKR)</span>",
            hidden: false,
            width:500,
            dataIndex: 'totalamountindex',
            filter: {
                type: 'int'
            }
        },{
            header: "<span style=font-weight:bold;>Inward Mode</span>",
            hidden: false,
            width:500,
            dataIndex: 'inwardModeDataIndex',
            filter: {
                type: 'string'
            }
        },
		{
            header: "<span style=font-weight:bold;>Cash</span>",
            hidden: false,
            width:500,
            dataIndex: 'cashTypeDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Trip Sheet No</span>",
            hidden: false,
            width:500,
            dataIndex: 'TripSheetNoDataIndex',
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
function addNewAsset(butonvalue) {
    if(butonvalue == 'Modify'){
     var selectedRow = grid.getSelectionModel().getSelected();
   InwardId = selectedRow.get('inwardIdDataIndex');
   
 }else{
 InwardId = 0;
 }
 
    myWin1 = new Ext.Window({
    title: 'Denomination Details',
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: false,maximizable: false,
        	buttonAlign: "center",
        	width:960,
        	height: screen.height-280,
        	id: 'dispenseId2',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
            html: "<iframe id = 'xyz' style = 'height:510px;width:952px'; src='<%=request.getContextPath()%>/Jsps/CashVanManagement/DenomianationDetails.jsp?ButtonValue= " + butonvalue +  "&InwardId= " + InwardId + "'></iframe>" ,                    	
            scripts: true,
            shim: false
       	});
       	myWin1.show();
 
}


function moveSealBag(butonvalue) {
 
 InwardId = 0;
 
    myWin1 = new Ext.Window({
    title: 'Denomination Details',
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: false,maximizable: false,
        	buttonAlign: "center",
        	width:960,
        	height: screen.height-280,
        	id: 'dispenseId2',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
            html: "<iframe id = 'xyz' style = 'height:510px;width:952px'; src='<%=request.getContextPath()%>/Jsps/CashVanManagement/MoveSealBagToCash.jsp?ButtonValue= " + butonvalue +  "&InwardId= " + InwardId + "'></iframe>" ,                    	
            scripts: true,
            shim: false
       	});
       	myWin1.show();
 
}


   grid = getGridArmory('', 'No Records Found', store, screen.width - 40, 450, 11, filters, '', false,'', 11, false, '', false, '', true, 'Inward Cash', true, 'View Inward', false, 'Excel', jspName, exportDataType, false, 'Pdf', true, 'Move To Cash');

function getGridArmory(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, Inwardcash, InwardcashStr, ModifyInward, ModifyinwardStr, excel, excelstr, jspName, exportDataType, pdf, pdfstr, move, movetocashstr) {
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
    if (Inwardcash) {
        grid.getBottomToolbar().add([
            '-', {
                text: InwardcashStr,
                // iconCls : 'closebutton'
                handler: function() {
                buttonValue = 'Inward';                
                   addNewAsset(buttonValue);
                }
            }
        ]);
    }
    if (ModifyInward) {
        grid.getBottomToolbar().add([
            '-', {
                text: ModifyinwardStr,
                // iconCls : 'closebutton',
                handler: function() {
                 buttonValue = 'Modify' ; 
                 addNewAsset(buttonValue);
                }
            }
        ]);
    }

if (move) {
        grid.getBottomToolbar().add([
            '-', {
                text: movetocashstr,
                // iconCls : 'closebutton'
                handler: function() {
                buttonValue = 'Move';                
                   moveSealBag(buttonValue);
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
   // Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
       // title: 'Vault Operations',
        renderTo: 'content',
        id: 'outerPanel',
        standardView: true,
        autoScroll: false,
        frame: false,
        border: false,
        width:screen.width-22,
        height:750,
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

