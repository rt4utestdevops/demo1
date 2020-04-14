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
	int userid = loginInfo.getUserId();
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
	<style>
		.x-toolbar-layout-ct {
			width : 1302px !important;
		}		  
	</style>
   <script>
   var prevDate = currentDate; 
var curDate = nextDate;
var outerPanel;
var ctsb;
var exportDataType = "";
var selected;
var grid;
var jspName="ExcessHaltingReport";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
var myWin;

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'traderMaster',
     layout: 'table',
	 title:'Excess Halting',
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
                                		value:'4'
                            		}
                        		});
						 		excessHaltingStore.removeAll();
			       			  	Ext.getCmp('firstGridPanelId').setHeight(380);
			       			  	Ext.getCmp('secondGridPanelId').setHeight(0);
							 }
						 }
					}
			}
     ]
 });


var reader = new Ext.data.JsonReader({
   idProperty: 'excessdashboardId',
   root: 'excessHaltingDashBoardRoot',
   totalProperty: 'total',
   fields: [{
       name: 'slnoDataIndex'
   },{
       name: 'NoofVehicleHaltingOneTimeDataIndex'
   },{
       name: 'NoofVehicleHaltingTwoTimeDataIndex'
   },{
       name: 'NoofVehicleHaltingThreeTimeDataIndex'
   },{
       name: 'NoofvehiclewithGPSIndex'
   },{
       name: 'NoofvehicleEwayBillsAssignedDataIndex'
   }]
});

var store = new Ext.data.GroupingStore({
   autoLoad: false,
   proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/DashBoardAction.do?param=getDashboardDetails',
       method: 'POST'
   }),
   reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
   local: true,
    filters: [{  
           dataIndex: 'slnoDataIndex',
            type: 'numeric'
       }, {
           dataIndex: 'NoofVehicleHaltingOneTimeDataIndex',
           type: 'String'
       }, {
           dataIndex: 'NoofVehicleHaltingTwoTimeDataIndex',
           type: 'String'
       }, {
           dataIndex: 'NoofVehicleHaltingThreeTimeDataIndex',
           type: 'String'
       }, {
           dataIndex: 'NoofvehiclewithGPSIndex',
           type: 'String'
       }, {
           dataIndex: 'NoofvehicleEwayBillsAssignedDataIndex',
           type: 'String'
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
           header: "<span style=font-weight:bold;>No Of Vehicles With GPS</span>",
           hidden: false,
           width: 100,
           sortable: true,
           dataIndex: 'NoofvehiclewithGPSIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>eWayBills Assigned</span>",
           hidden: false,
           width: 100,
           sortable: true,
           dataIndex: 'NoofvehicleEwayBillsAssignedDataIndex',
           filter: {
               type: 'numeric'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Vehicle Halting One Time</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'NoofVehicleHaltingOneTimeDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Vehicle Halting Two Time</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'NoofVehicleHaltingTwoTimeDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Vehicle Halting More Than Two Times</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'NoofVehicleHaltingThreeTimeDataIndex',
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
grid = getGrid('', 'No Records Found', store, screen.width - 20, 330, 10, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************

function columnVisiblity(recno)
{
  if(recno==3){
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt2DurationDataIndex'),true);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt2AddressDataIndex'),true);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt3DurationDataIndex'),true);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt3AddressDataIndex'),true);
      	Ext.getCmp('firstGridPanelId').setHeight(120);
        Ext.getCmp('secondGridPanelId').setHeight(300);
      }else if(recno==4){
		datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt2DurationDataIndex'),false);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt2AddressDataIndex'),false);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt3DurationDataIndex'),true);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt3AddressDataIndex'),true);
      	Ext.getCmp('firstGridPanelId').setHeight(120);
        Ext.getCmp('secondGridPanelId').setHeight(300);
	  }else if(recno==5){
		datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt2DurationDataIndex'),false);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt2AddressDataIndex'),false);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt3DurationDataIndex'),false);
      	datagrid.getColumnModel().setHidden(datagrid.getColumnModel().findColumnIndex('halt3AddressDataIndex'),false);
      	Ext.getCmp('firstGridPanelId').setHeight(120);
        Ext.getCmp('secondGridPanelId').setHeight(300);
	  }
}
function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
var startDate = Ext.getCmp('startdate').getValue();
var endDate = Ext.getCmp('enddate').getValue();
var recno = parseInt(columnIndex)-1;


excessHaltingStore.load({
	params:{
	    recordNo:recno,
	    startDate:startDate,
	    endDate:endDate,
	    jspName:jspName
	}
	});
	
	  columnVisiblity(recno);
      
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
        name: 'vehicleNumberDataIndex'
    }, {
        name: 'issedeWayBillNoDataIndex'
    }, {
        name: 'halt1AddressDataIndex'
    }, {
        name: 'halt1DurationDataIndex'
    }, {
        name: 'halt2AddressDataIndex'
    }, {
        name: 'halt2DurationDataIndex'
    }, {
        name: 'halt3AddressDataIndex'
    }, {
        name: 'halt3DurationDataIndex'
    }, {
        name: 'reachdataindex'
    }, {
        name: 'ewaybilldateIndex'
    }, {
        name: 'destinationIndex'
    }, {
        name: 'customerDataIndex'
    },{
        name: 'latitudeIndex'
    },{
        name: 'longitudeIndex'
    }]
});

var excessHaltingStore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ExcessHalting.do?param=getExcesshaltingReportDetails',
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
        dataIndex: 'vehicleNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'issedeWayBillNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'halt1AddressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'halt1DurationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'halt2AddressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'halt2DurationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'halt3AddressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'halt3DurationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'reachdataindex'
    }, {
        type: 'date',
        dataIndex: 'ewaybilldateIndex'
    }, {
        type: 'string',
        dataIndex: 'destinationIndex'
    }, {
        type: 'string',
        dataIndex: 'customerDataIndex'
    }, {
        type: 'string',
        dataIndex: 'latitudeIndex'
    }, {
        type: 'string',
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
            ///width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>eWaybill No</span>",
            dataIndex: 'issedeWayBillNoDataIndex',
           // width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Sand Reach Name</span>",
            dataIndex: 'reachdataindex',
          //  width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>eWaybill Datetime</span>",
            dataIndex: 'ewaybilldateIndex',
          //  width: 120,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination As Per eWaybill</span>",
            dataIndex: 'destinationIndex',
           // width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'customerDataIndex',
          //  width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Halt 1 Address</span>",
            dataIndex: 'halt1AddressDataIndex',
          //  width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Halt 1 Duration (DD:HH:MM)</span>",
            dataIndex: 'halt1DurationDataIndex',
         //   width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Halt 2 Address</span>",
            dataIndex: 'halt2AddressDataIndex',
           // width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Halt 2 Duration (DD:HH:MM)</span>",
            dataIndex: 'halt2DurationDataIndex',
         //   width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Halt 3 Address</span>",
            dataIndex: 'halt3AddressDataIndex',
         //   width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Halt 3 Duration (DD:HH:MM)</span>",
            dataIndex: 'halt3DurationDataIndex',
        //    width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Latitude</span>",
            hidden: true,
            dataIndex: 'latitudeIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Longitude</span>",
            hidden: true,
            dataIndex: 'longitudeIndex',
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


function modifyData()
{
 var startdatee='';
 var endDatee='';
 var userid='<%=userid%>';
 var clientid='<%=customerId%>';
 var selected = datagrid.getSelectionModel().getSelected();
 var vehicleNo = selected.get('vehicleNumberDataIndex');
 var reachentry=selected.get('ewaybilldateIndex');
 var latitude=selected.get('latitudeIndex');
 var longitude=selected.get('longitudeIndex');
 var destination=selected.get('destinationIndex');
 destination=destination.replace(/ /g,"%20");
 var flag1="ROUTE";
 reachentry=reachentry.replace(" ", "T");

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
win.setPosition(10, 5);

}

//*****************************************************************Grid *******************************************************************************
datagrid = getGrid('', 'No Records Found', excessHaltingStore, screen.width - 60,250, 17, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, 'Add', true, 'History Analysis', false, 'Delete');
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
                                		value:'4'
                            		}
                        		});
						 		excessHaltingStore.removeAll();
			       			  	grid.expand();
			       			  	Ext.getCmp('secondGridPanelId').setHeight(0);
			       			  	
   var cm = datagrid.getColumnModel();  
   for (var j = 1; j < cm.getColumnCount(); j++) {
      cm.setColumnWidth(j,150);
   }

});
</script>
</body>
</html>
<%}%>
    
    
    
    

