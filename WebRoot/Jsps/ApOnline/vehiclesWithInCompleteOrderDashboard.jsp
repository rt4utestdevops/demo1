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
	int userid=loginInfo.getUserId();
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>DashBoard</title>		
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
var jspName="OrderCompletionDetails";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string";
var myWin;

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'traderMaster',
     layout: 'table',
     title:'Order Completion Details',
     frame: true,
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
             emptyText: 'Select Start Date',
             allowBlank: false,
             blankText: 'Select Start Date',
             id: 'startdate',
             value: prevDate,
             vtype: 'daterange',
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
                                			value:'5'
                            			}
                        			});
                              		vehicleIncompStore.removeAll();
			       			  		grid.expand();
			       			  		Ext.getCmp('firstGridPanelId').setHeight(380);
			       			  		Ext.getCmp('secondGridPanelId').setHeight(0);
							  	 }
							}
					}
			}
     ]
 });


var reader = new Ext.data.JsonReader({
    idProperty: 'dashboardId',
    root: 'vehicleswithIncompleteRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    },{
        name: 'DateDataIndex'
    },{
        name: 'NoofvehiclewithGPSIndex'
    },{
        name: 'NoofvehicleEwayBillsAssignedDataIndex'
    },{
        name: 'VehiclecompleteddeliverycycleDataIndex'
    },{
        name: 'VehiclenotcompleteddeliveryDataIndex'
    },{
        name: 'deliverynotcompletedDataIndex'
    },{
        name: 'inprogressDataIndex'
    },{
        name: 'destinationNADataIndex'
    },{
        name: 'completedelayDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/DashBoardAction.do?param=getDashboardDetails',
        method: 'POST'
    }),
    storeId: 'ownersId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
     filters: [{
            dataIndex: 'slnoDataIndex',
             type: 'numeric'
        }, {
            dataIndex: 'DateDataIndex',
            type: 'String'
        }, {
            dataIndex: 'NoofvehiclewithGPSIndex',
            type: 'numeric'
        }, {
            dataIndex: 'NoofvehicleEwayBillsAssignedDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'VehiclecompleteddeliverycycleDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'VehiclenotcompleteddeliveryDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'deliverynotcompletedDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'inprogressDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'destinationNADataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'completedelayDataIndex',
            type: 'numeric'
        }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;>SLNO</span>",
             width: 50
         }), {
             dataIndex: 'slnoDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;>SLNO</span>",
             width: 100,
             filter: {
                 type: 'numeric'
             }
			},{
            header: "<span style=font-weight:bold;>Date</span>",
            hidden: true,
            width: 50,
            sortable: true,
            dataIndex: 'DateDataIndex',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>No Of Vehicles With GPS</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'NoofvehiclewithGPSIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;> eWayBills Assigned</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'NoofvehicleEwayBillsAssignedDataIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Order Completion</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'VehiclecompleteddeliverycycleDataIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>In Progress</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'inprogressDataIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Order Completed With Delay</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'completedelayDataIndex',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Order Not Completed</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'VehiclenotcompleteddeliveryDataIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination Not Found</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'destinationNADataIndex',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>% Delivery Not Completed</span>",
            hidden: false,
            width: 150,
            sortable: true,
            renderer: Ext.util.Format.numberRenderer('0.00'),
            dataIndex: 'deliverynotcompletedDataIndex',
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
grid = getGrid('', 'No Records Found', store, screen.width - 60, 330, 12, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************


function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {

var startDate = Ext.getCmp('startdate').getValue();
var endDate = Ext.getCmp('enddate').getValue();


vehicleIncompStore .load({
	params:{
	    startDate:startDate,
	    endDate:endDate,
	    jspName:jspName
	}
	});
	   Ext.getCmp('firstGridPanelId').setHeight(120);
       Ext.getCmp('secondGridPanelId').setHeight(300);
 
}

grid.on({
      "cellclick": {
          fn: onCellClickOnGrid
      }
  });
  var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'vehicleswithIncompleteRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNumberDataIndex'
    }, {
        name: 'ewayBillNumber'
    }, {
        name: 'ewayBillDateAndTimeDataIndex'
    }, {
        name: 'ewayBillvalidityDataIndex'
    }, {
        name: 'destinationAsPereWayBillDataIndex'
    }, {
        name: 'expectedDestinationTimeDataIndex'
    },{
        name: 'destinationReachedTimeDataIndex'
    },{
        name: 'delayDataIndex'
    },{
        name: 'reachdataindex'
    },{
        name: 'latitudeIndex'
    },{
        name: 'longitudeIndex'
    },{
        name: 'orderstatusDataIndex'
    }]
});

var vehicleIncompStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VehiclesWithInCompleteOrder.do?param=getVehiclesWithIncompleteOrder',
        method: 'POST'
    }),
    storeId: 'vehicleswithIncompleteId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ewayBillNumber'
    }, {
        type: 'date',
        dataIndex: 'ewayBillDateAndTimeDataIndex'
    }, {
        type: 'date',
        dataIndex: 'ewayBillvalidityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'destinationAsPereWayBillDataIndex'
    }, {
        type: 'date',
        dataIndex: 'expectedDestinationTimeDataIndex'
    },{
        type: 'date',
        dataIndex: 'destinationReachedTimeDataIndex'
    },{
        type: 'string',
        dataIndex: 'delayDataIndex'
    },{
        type: 'string',
        dataIndex: 'reachdataindex'
    },{
        type: 'string',
        dataIndex: 'orderstatusDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'latitudeIndex'
    },{
        type: 'numeric',
        dataIndex: 'longitudeIndex'
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
        }, {
            header: "<span style=font-weight:bold;>Vehicle Number</span>",
            dataIndex: 'vehicleNumberDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>eWayBill Number</span>",
            dataIndex: 'ewayBillNumber',
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
            header: "<span style=font-weight:bold;>eWayBill Date And Time</span>",
            dataIndex: 'ewayBillDateAndTimeDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>eWayBill Validity</span>",
            dataIndex: 'ewayBillvalidityDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination As Per eWayBill</span>",
            dataIndex: 'destinationAsPereWayBillDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>ETA</span>",
            dataIndex: 'expectedDestinationTimeDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Destination Reached Time</span>",
            dataIndex: 'destinationReachedTimeDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Delay(Min)</span>",
            dataIndex: 'delayDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Order Status</span>",
            dataIndex: 'orderstatusDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Destination Latitude</span>",
            dataIndex: 'latitudeIndex',
            width: 100,
            hidden: true,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Destination Longitude</span>",
            dataIndex: 'longitudeIndex',
            width: 100,
            hidden: true,
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


function modifyData()
{

var startdatee='';
var endDatee='';
var userid='<%=userid%>';
var clientid='<%=customerId%>';
 var selected = datagrid.getSelectionModel().getSelected();
 var vehicleNo = selected.get('vehicleNumberDataIndex');
 var reachentry=selected.get('ewayBillDateAndTimeDataIndex');
 reachentry=reachentry.replace(" ", "T");
 var latitude=selected.get('latitudeIndex');
 var longitude=selected.get('longitudeIndex');
 var destination=selected.get('destinationAsPereWayBillDataIndex');
 destination=destination.replace(/ /g,"%20");
 var flag1="ROUTE";

 var url="/jsps/Redirect.jsp?vehicleNo="+vehicleNo+"&startdate="+startdatee+"&enddate="+endDatee+"&userid="+userid+"&clientid="+clientid+"&reachentry="+reachentry+"&latitude="+latitude+"&longitude="+longitude+"&destination="+destination+"&flag1="+flag1;


 	var win = new Ext.Window({
        title:'History Analysis Window',
        autoShow : false,
    	constrain : false,
    	constrainHeader : false,
    	resizable : false,
    	maximizable : true,
    	minimizable :true,
    	footer:true,
    	header:false,
        width:screen.width-40,
        height:510,
        shim:false,
        animCollapse:false,
        border:false,
        constrainHeader:true,
        layout: 'fit',
		html : "<iframe style='width:100%;height:470px;background:#ffffff' src="+url+"></iframe>",
		listeners: {
			maximize: function(){
			},
			minimize:function(){
			},
			resize:function(){
			},
			restore:function(){
			}
		}
    });
  
    win.show();
//openNormalWindow("HistoryWin",'History',"/jsps/CustomHistoryTracking.jsp");
win.setPosition(10, 5);
}



function addRecord()
{

 var selected = datagrid.getSelectionModel().getSelected();
 var vehicleNo = selected.get('vehicleNumberDataIndex');
 var url="/Telematics4uApp/Jsps/SandMining/APOnlineMapView.jsp?vehicleNo="+vehicleNo;
 	var win = new Ext.Window({
        title:'Map View',
        autoShow : false,
    	constrain : false,
    	constrainHeader : false,
    	resizable : false,
    	maximizable : true,
    	minimizable :true,
    	footer:true,
        width:1300,
        height:450,
        shim:false,
        animCollapse:false,
        border:false,
        constrainHeader:true,
        layout: 'fit',
		html : "<iframe style='width:100%;height:100%;background:#ffffff' src="+url+"></iframe>",
		listeners: {
			maximize: function(){
			},
			minimize:function(){
			},
			resize:function(){
			},
			restore:function(){
			}
		}
    });
  
    win.show();


}

//*****************************************************************Grid *******************************************************************************
datagrid = getGrid('', 'No Records Found', vehicleIncompStore, screen.width - 35,250, 15, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'View Map', true, 'History Analysis', false, '');
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
                                			value:'5'
                            			}
                        			});
                              		vehicleIncompStore.removeAll();
			       			  		grid.expand();
			       			  		Ext.getCmp('secondGridPanelId').setHeight(0);

});
</script>
</body>
</html>
<%}%>
    
    
    
    

