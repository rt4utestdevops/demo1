<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>IdleDashBoard</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>

var prevDate = currentDate; 
var curDate = nextDate;
var outerPanel;
var ctsb;
var exportDataType = "";
var selected;
var grid;
var jspName="IdleTimeReport";
var exportDataType = "int,string,string,string,string,string,string,string";
var myWin;

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'traderMaster',
     layout: 'table',
     frame: true,
	 title:'Idle Time Report',
     width: screen.width - 27,
     height: 80,
     layoutConfig: {
         columns: 13
     },
     items: [{width: 30},{
             xtype: 'label',
             cls: 'labelstyle',
             id: 'startdatelab',
             text: 'Start Date' + ' :'
         }, {
             xtype: 'datefield',
             cls: 'selectstylePerfect',
             width: 185,
             format: getDateTimeFormat(),
             style: 'margin-top:50px;',
             emptyText: 'Select Start Date',
             allowBlank: false,
             blankText: 'Select Start Date',
             id: 'startdate',
             vtype: 'daterange',
             value: prevDate,
             endDateField: 'enddate'
         } , {
             width: 50
         }, {
             xtype: 'label',
             cls: 'labelstyle',
             id: 'enddatelab',
             text: 'End Date' + ' :'
         }, {
             xtype: 'datefield',
             cls: 'selectstylePerfect',
             width: 185,
             format: getDateTimeFormat(),
             emptyText: 'Select End Date',
             allowBlank: false,
             blankText: 'Select End Date',
             id: 'enddate',
             value: curDate,
             vtype: 'daterange',
             startDateField: 'startdate'
         },{
				 xtype:'button',
				 text:'View',
				 id:'viewbuttonid',
				 cls:'buttonstyle ',
				 width:80,
				 listeners: 
	       		 {
		        	click:
		        		{
			       		  fn:function()
			       			  {
							  	if (Ext.getCmp('startdate').getValue() == "") {
  		                            Ext.example.msg("Select Start Date");
  		                            Ext.getCmp('startdate').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('enddate').getValue() == "") {
  		                            Ext.example.msg("Select End Date");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('startdate').getValue();
  		                        var enddates = Ext.getCmp('enddate').getValue();
  		                        
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("Difference between Start Date and End Date should not be more then 1 Month");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
			       			  
							    store.load({
                                 		params: {
                                			startDate: Ext.getCmp('startdate').getValue(),
                                			endDate: Ext.getCmp('enddate').getValue(),
                                			value:'8'
                            			}
                        		});
                        		idleTimeReportStore.removeAll();
			       	    		Ext.getCmp('firstGridPanelId').setHeight(380);
			       	    		Ext.getCmp('secondGridPanelId').setHeight(0);
							}
						}
					}
			}
     ]
 });

var reader = new Ext.data.JsonReader({
   root: 'BranchMasterDetailsRoot',
   totalProperty: 'total',
   fields: [{
       name: 'slnoDataIndex'
   },{
       name: 'dateDataIndex'
   },{
       name: 'NoofvehiclewithGPSIndex'
   },{
       name: 'NoofvehicleEwayBillsAssignedDataIndex'
   },{
       name: 'idle1to2hrewaybillIndex'
   },{
       name: 'idle2to5hrewaybillIndex'
   },{
       name: 'idle5hrewaybillIndex'
   },{
       name: 'idle1to2hrNoewaybillIndex'
   },{
       name: 'idle2to5hrNoewaybillIndex'
   },{
       name: 'idle5hrNoewaybillIndex'
   }]
});

//************************* store configs****************************************//
var store = new Ext.data.GroupingStore({
   proxy: new Ext.data.HttpProxy({
     	 url: '<%=request.getContextPath()%>/DashBoardAction.do?param=getDashboardDetails',
       method: 'POST'
   }),
    remoteSort: false,
   bufferSize: 700,
   reader: reader
});
//****************************grid filters*************************************************//
var filters = new Ext.ux.grid.GridFilters({
   local: true,
   filters: [{
           dataIndex: 'slnoDataIndex',
            type: 'numeric'
       }, {
           dataIndex: 'dateDataIndex',
           type: 'numeric'
       }, {
           dataIndex: 'NoofvehiclewithGPSIndex',
           type: 'numeric'
       }, {
           dataIndex: 'NoofvehicleEwayBillsAssignedDataIndex',
           type: 'numeric'
       }, {
           dataIndex: 'idle1to2hrewaybillIndex',
           type: 'numeric'
       }, {
           dataIndex: 'idle2to5hrewaybillIndex',
           type: 'numeric'
       }, {
           dataIndex: 'idle5hrewaybillIndex',
           type: 'numeric'
       }, {
           dataIndex: 'idle1to2hrNoewaybillIndex',
           type: 'String'
       }, {
           dataIndex: 'idle2to5hrNoewaybillIndex',
           type: 'numeric'
       }, {
           dataIndex: 'idle5hrNoewaybillIndex',
           type: 'numeric'
       }
   ]
});
//****************column Model Config***************************************************//
var createColModel = function (finish, start) {

    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
},{
           header: "<span style=font-weight:bold;>Date</span>",
           hidden: true,
           hideable:false,
           sortable: true,
           dataIndex: 'dateDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Vehicles With GPS</span>",
           hidden: false,
           sortable: true,
           dataIndex: 'NoofvehiclewithGPSIndex',
           filter: {
               type: 'numeric'
           }
       },
          
           {
           header: "<span style=font-weight:bold;>eWay Bill Assigned</span>",
           hidden: false,
           sortable: true,
           dataIndex: 'NoofvehicleEwayBillsAssignedDataIndex',
           filter: {
               type: 'numeric'
           }
           },
          
          { header: "<span style=font-weight:bold;>Idle More Than 1Hr <= 2Hr With Way Bill</span>",
           hidden: false,
           sortable: true,
           dataIndex: 'idle1to2hrewaybillIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>Idle More Than 2Hr < 5Hr With Way Bill </span>",
           hidden: false,
           sortable: true,
           dataIndex: 'idle2to5hrewaybillIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>Idle More Than 5Hr With Way Bill</span>",
           hidden: false,
           sortable: true,
           dataIndex: 'idle5hrewaybillIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>Idle More Than 1Hr <= 2Hr Without Way Bill</span>",
           hidden: false,
           sortable: true,
           dataIndex: 'idle1to2hrNoewaybillIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>Idle More Than 2Hr < 5Hr Without Way Bill</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'idle2to5hrNoewaybillIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>Idle More Than 5Hr Without Way Bill</span>",
           hidden: false,
           sortable: true,
           dataIndex: 'idle5hrNoewaybillIndex',
           filter: {
               type: 'numeric'
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

//*****************************************************************Grid *******************************************************************************
grid = getGrid('', 'No Records Found', store, screen.width - 30, 330, 12, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************

function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {

var startDate = Ext.getCmp('startdate').getValue();
var endDate = Ext.getCmp('enddate').getValue();
var recno = parseInt(columnIndex)-2;

idleTimeReportStore.load({
	params:{
	    recordNo:recno,
	    startDate:startDate,
	    endDate:endDate,
	    jspName:jspName
	}
	});
      
      if(recno>5){
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('eWayBillDataIndex'),true);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('eWayBillDateandTimeDataIndex'),true);
      	Ext.getCmp('firstGridPanelId').setHeight(120);
        Ext.getCmp('secondGridPanelId').setHeight(300);
      }else if(recno>2 && recno<6){
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('eWayBillDataIndex'),false);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('eWayBillDateandTimeDataIndex'),false);
      	Ext.getCmp('firstGridPanelId').setHeight(120);
        Ext.getCmp('secondGridPanelId').setHeight(300);
      }   
      
}

grid.on({
      "cellclick": {
          fn: onCellClickOnGrid
      }
  });
var reader = new Ext.data.JsonReader({
    root: 'excessHaltingRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'eWayBillDataIndex'
    }, {
        name: 'eWayBillDateandTimeDataIndex'
    }, {
        name: 'vehicleNumberDataIndex'
    }, {
        name: 'vehicleEntryDateandTimeDataIndex'
    }, {
        name: 'vehicleExitDateandTimeDataIndex'
    }, {
        name: 'totalWaitingTimeDataIndex'
    }, {
        name: 'reachdataindex'
    }]
});

var idleTimeReportStore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/IdleTimeReport.do?param=getIdleTimeReportDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'eWayBillDataIndex'
    }, {
        type: 'string',
        dataIndex: 'eWayBillDateandTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNumberDataIndex'
    }, {
        type: 'date',
        dataIndex: 'vehicleEntryDateandTimeDataIndex'
    }, {
        type: 'date',
        dataIndex: 'vehicleExitDateandTimeDataIndex'
    }, {
        type: 'String',
        dataIndex: 'totalWaitingTimeDataIndex'
    }, {
        type: 'String',
        dataIndex: 'reachdataindex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Vehicle Number</span>",
            dataIndex: 'vehicleNumberDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>eWayBill No</span>",
            dataIndex: 'eWayBillDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Sand Reach Name</span>",
            dataIndex: 'reachdataindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>eWaybill Date Time</span>",
            dataIndex: 'eWayBillDateandTimeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Reach Entry Date And Time</span>",
            dataIndex: 'vehicleEntryDateandTimeDataIndex',
            width: 100,
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;>Reach Exit Date And Time</span>",
            dataIndex: 'vehicleExitDateandTimeDataIndex',
            width: 100,
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;>Total Waiting Time(HH.MM)</span>",
            dataIndex: 'totalWaitingTimeDataIndex',
            width: 100,
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

//*****************************************************************Grid *******************************************************************************
datagrid = getGrid('', 'No Records Found', idleTimeReportStore, screen.width - 35,250, 10, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************
var firstGridPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'firstGridPanelId',
     layout: 'table',
     title:'Dashboard Details',
     frame: true,
     width: screen.width - 25,
     height:380,
     layoutConfig: {
         columns: 1
     },
     items: [grid]
     });

var secondGridPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'secondGridPanelId',
     layout: 'table',
     title:'Summary Details',
     frame: true,
     width: screen.width - 25,
     height:0,
     layoutConfig: {
         columns: 1
     },
     items: [datagrid]
     });
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: false,
        width: screen.width - 25,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,firstGridPanel,secondGridPanel]
    });
    
      store.load({
                                 		params: {
                                			startDate: Ext.getCmp('startdate').getValue(),
                                			endDate: Ext.getCmp('enddate').getValue(),
                                			value:'8'
                            			}
                        		});
                        		idleTimeReportStore.removeAll();
			       	    		grid.expand();
			       	    		Ext.getCmp('secondGridPanelId').setHeight(0);
 var cm = grid.getColumnModel();  
 for (var j = 1; j < cm.getColumnCount(); j++) {
 cm.setColumnWidth(j,150);
   }
});
</script>
</body>
</html>
<%}%>
    
    
    
    

