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

var prevDate = previousDate; 
var curDate = currentDate;
var nextDate = nextDate;
var outerPanel;
var ctsb;
var exportDataType = "";
var selected;
var grid;
var jspName="MultipleVehicleSameDestination";
var exportDataType = "int,string,string,string,string,string,string,string";
var myWin;
var displaygrid;

var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'multipleVehicleSameDestinationRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNumberDataIndex'
    }, {
        name: 'ewayBills'
    }, {
        name: 'deliveryAddressDataIndex'
    }, {
        name: 'dateOfDeliveryDataIndex'
    }, {
        name: 'customerNameDataIndex'
    }, {
        name: 'noOfTripsDataIndex'
    },{
        name: 'gpsLocationDataIndex'
    }]
});

var multiplestore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MultipleVehicleSameDestination.do?param=getMultipleVehiclesameDestination',
        method: 'POST'
    }),
    storeId: 'multipleVehiclesameDestinationId',
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
        dataIndex: 'ewayBills'
    }, {
        type: 'date',
        dataIndex: 'deliveryAddressDataIndex'
    }, {
        type: 'date',
        dataIndex: 'dateOfDeliveryDataIndex'
    }, {
        type: 'string',
        dataIndex: 'customerNameDataIndex'
    }, {
        type: 'date',
        dataIndex: 'noOfTripsDataIndex'
    },{
        type: 'date',
        dataIndex: 'gpsLocationDataIndex'
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
            header: "<span style=font-weight:bold;>eWayBills</span>",
            dataIndex: 'ewayBills',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Delivery Address</span>",
            dataIndex: 'deliveryAddressDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Date Of Delivery</span>",
            dataIndex: 'dateOfDeliveryDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'customerNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>No Of Trips</span>",
            dataIndex: 'noOfTripsDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Gps Location</span>",
            dataIndex: 'gpsLocationDataIndex',
            width: 100,
            hidden: true,
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

function closeImportWin(){
	myWin.hide();
	multiplestore.removeAll();
}
displaygrid = getGrid('', 'No Records Found', multiplestore, screen.width - 168, 440, 10, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, '', false, '', false, '',false,'',false,'',false,'',false,'',false,'',false,'',false,'',false,'',true,'Close');

var PanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [displaygrid]
});
myWin = new Ext.Window({
    title: 'Summary Details',
    width: '90%',
    height:490,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    id: 'popupWin',
    items: [PanelWindow]
});

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'traderMaster',
     layout: 'table',
     frame: true,
     title:'Multiple Vehicle Same Destination',
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
                                			value:'3'
                            			}
                        			});
							  }
						  }
					}
			}
     ]
 });

var reader = new Ext.data.JsonReader({
  idProperty: 'dashboardId',
  root: 'multipleVehcileDestinationRoot',
  totalProperty: 'total',
  fields: [{
      name: 'slnoDataIndex'
  },{
      name: 'noOfVehiclesDataIndex'
  },{
      name: 'sameDestinationIndex'
  },{
      name: 'noOfTripsDataIndex'
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
          dataIndex: 'noOfVehiclesDataIndex',
          type: 'String'
      }, {
          dataIndex: 'sameDestinationIndex',
          type: 'String'
      }, {
          dataIndex: 'noOfTripsDataIndex',
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
          header: "<span style=font-weight:bold;>No Of Vehicles</span>",
          hidden: false,
          width: 50,
          sortable: true,
          dataIndex: 'noOfVehiclesDataIndex',
          filter: {
              type: 'String'
          }
      },{
          header: "<span style=font-weight:bold;>Destination</span>",
          hidden: false,
          width: 120,
          sortable: true,
          dataIndex: 'sameDestinationIndex',
          filter: {
              type: 'String'
          }
      },{
          header: "<span style=font-weight:bold;>No Of Trips</span>",
          hidden: false,
          width: 120,
          sortable: true,
          dataIndex: 'noOfTripsDataIndex',
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
grid = getGrid('DashBoard Details', 'No Records Found', store, screen.width - 25, 433, 10, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************

function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
	if (grid.getSelectionModel().getCount() == 1) {
         var selected = grid.getSelectionModel().getSelected();
         var destinationName = selected.get('sameDestinationIndex');
		var startDate = Ext.getCmp('startdate').getValue();
		var endDate = Ext.getCmp('enddate').getValue();
	}
	multiplestore.load({
      	params:{
          		destinationName:destinationName,
          		startDate:startDate,
          		endDate:endDate,
          		jspName:jspName
      		   }
     });
   myWin.show();       
}

grid.on({
      "cellclick": {
          fn: onCellClickOnGrid
      }
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
        items: [clientPanel,grid]
    });
    
 	var startDate = Ext.getCmp('startdate').getValue();
	var endDate = Ext.getCmp('enddate').getValue();
	
    store.load({
       params: {
              startDate: startDate,
              endDate: endDate,
              value:'3'
   	 	}
   	});
});
</script>
</body>
</html>
<%}%>
    
    
    
    

