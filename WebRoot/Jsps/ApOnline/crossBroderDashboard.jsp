    
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
		  .ext-strict {
				overflow : hidden;
		   }
		  .x-toolbar-layout-ct {
				width : 1302px !important;
		   }		  	
	</style>
	
   <script>

var prevDate = previousDate; 
var curDate = currentDate;
var nextDate = nextDate;
var outerPanel;
var ctsb;
var exportDataType = "";
var selected;
var grid;
var jspName="CrossBorderReport";
var exportDataType = "int,string,string,string,string,string,string,string,string,string";
var myWin;

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'traderMaster',
     layout: 'table',
     title:'Cross Border Report',
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
             style: 'margin-top:50px;',
             emptyText: 'Select Start Date',
             allowBlank: false,
             blankText: 'Select Start Date',
             id: 'startdate',
             vtype: 'daterange',
             value: curDate,
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
             value: nextDate,
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
                                		value:'9'
                            	  	 }
                        	    });
                        	    crossstore.removeAll();
			       			   		Ext.getCmp('firstGridPanelId').setHeight(380);
			       			  		Ext.getCmp('secondGridPanelId').setHeight(0);
							}
						}
					}
			}
     ]
 });


var reader = new Ext.data.JsonReader({
   root: 'crossBoarderDetailsRoot',
   totalProperty: 'total',
   fields: [{
       name: 'slnoDataIndex'
   },{
       name: 'dateDataIndex'
   },{
       name: 'noOfVehicleIndex'
   },{
       name: 'eWayBillAssignedIndex'
   },{
       name: 'noOfVehiclesDataIndex'
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
           type: 'String'
       }, {
           dataIndex: 'noOfVehicleIndex',
           type: 'String'
       }, {
           dataIndex: 'eWayBillAssignedIndex',
           type: 'String'
       }, {
           dataIndex: 'noOfVehiclesDataIndex',
           type: 'String'
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
            width: 100,
            filter: {
                type: 'numeric'
            }
      },{
           header: "<span style=font-weight:bold;>Date</span>",
           hidden: true,
           hideable:false,
           width: 120,
           sortable: true,
           dataIndex: 'dateDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No of Vehicles With GPS</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfVehicleIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>eWayBill Assigned</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'eWayBillAssignedIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Vehicles Crossed Border</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfVehiclesDataIndex',
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
grid = getGrid('', 'No Records Found', store, screen.width - 35, 330,10, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************

function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {

var startDate = Ext.getCmp('startdate').getValue();
var endDate = Ext.getCmp('enddate').getValue();


crossstore.load({
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
    root: 'crossBorderRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNumberDataIndex'
    }, {
        name: 'ewayBillNumber'
    }, {
        name: 'reachNameDataIndex'
    }, {
        name: 'ewayBillDateAndTimeDataIndex'
    }, {
        name: 'expectedTravelTimeDataIndex'
    }, {
        name: 'clientNameDataIndex'
    }, {
        name: 'timeOfBroderCrossedDataIndex'
    }, {
        name: 'destinationReachedDataIndex'
    }, {
        name: 'orderStatusDataIndex'
    }]
});

var crossstore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/CrossBorderReport.do?param=getCrossedBroderOrderReport',
        method: 'POST'
    }),
    storeId: 'crossBroderReportId',
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
        type: 'string',
        dataIndex: 'reachNameDataIndex'
    }, {
        type: 'date',
        dataIndex: 'ewayBillDateAndTimeDataIndex'
    }, {
        type: 'date',
        dataIndex: 'expectedTravelTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'clientNameDataIndex'
    }, {
        type: 'date',
        dataIndex: 'timeOfBroderCrossedDataIndex'
    }, {
        type: 'string',
        dataIndex: 'destinationReachedDataIndex'
    }, {
        type: 'string',
        dataIndex: 'orderStatusDataIndex'
    },]
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
        }, {
            header: "<span style=font-weight:bold;>Sand Reach Name</span>",
            dataIndex: 'reachNameDataIndex',
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
            header: "<span style=font-weight:bold;>Expected Travel Time</span>",
            dataIndex: 'expectedTravelTimeDataIndex',
            hidable : false,
            hidden : true,
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'clientNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Time Of Broder Crossed</span>",
            dataIndex: 'timeOfBroderCrossedDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination</span>",
            dataIndex: 'destinationReachedDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Order Status</span>",
            dataIndex: 'orderStatusDataIndex',
            width: 100,
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
 var reachentry=selected.get('timeOfBroderCrossedDataIndex');
 //var latitude=selected.get('latitudeindex');
 //var longitude=selected.get('longitudeindex');
 //var destination=selected.get('clientAddressDataIndex');
 //destination=destination.replace(" ","%20");
 var flag1="ROUTE";
 if(reachentry=="" || reachentry==null)
{
 Ext.example.msg("Please select A vehicle Having eWayBill"); 
 return;		                            
}
 reachentry=reachentry.replace(" ", "T");

 var url="/jsps/Redirect.jsp?vehicleNo="+vehicleNo+"&startdate="+startdatee+"&enddate="+endDatee+"&userid="+userid+"&clientid="+clientid+"&reachentry="+reachentry;

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
datagrid = getGrid('', 'No Records Found', crossstore, screen.width - 60, 250, 14, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, '',true, 'History Analysis', false, '', false, '');
//******************************************************************************************************************************************************

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
     
     var firstGridPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'firstGridPanelId',
     layout: 'table',
     title:'DashBoard Details',
     frame: true,
     width: screen.width - 19,
     height:380,
     layoutConfig: {
         columns: 1
     },
     items: [grid]
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
    
    var startDate = Ext.getCmp('startdate').getValue();
	 var endDate = Ext.getCmp('enddate').getValue();
	
     store.load({
       params: {
              startDate: startDate,
              endDate: endDate,
              value:'9'
   	 	}
   	});
});
</script>
</body>
</html>
<%}%>
    
    
    
    

 