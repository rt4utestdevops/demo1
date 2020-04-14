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
   <script>

var prevDate = previousDate; 
var curDate = currentDate;
var nextDate = nextDate;
var outerPanel;
var ctsb;
var exportDataType = "";
var selected;
var grid;
var jspName="TamperingTurnOffReport";
var exportDataType = "int,string,string,string,string,string,string,string,string,string";
var myWin;
Ext.Ajax.timeout = 360000;

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'traderMaster',
	 title:'Tampering Report',
     layout: 'table',
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
                                		value:'7'
                            		}
                        	  });
                        	  tamperedstore.removeAll();
			       			  Ext.getCmp('firstGridPanelId').setHeight(375);
			       			  Ext.getCmp('secondGridPanelId').setHeight(0);
			       			  		}
						}
					}
			}
     ]
 });


var reader = new Ext.data.JsonReader({
   root: 'tamperedDetailsRoot',
   totalProperty: 'total',
   fields: [{
       name: 'slnoDataIndex'
   },{
       name: 'dateDataIndex'
   },{
       name: 'noOfVehiclesGPSTamperedDataIndex'
   },{
       name: 'noOfVehicleIndex'
   },{
       name: 'eWayBillAssignedIndex'
   },{
       name: 'noOfVehiclesGPSTurnOffDataIndex'
   }]
});

//************************* store configs****************************************//
var store = new Ext.data.GroupingStore({
autoLoad: false,
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
           dataIndex: 'noOfVehiclesGPSTamperedDataIndex',
           type: 'String'
       },  {
           dataIndex: 'noOfVehicleIndex',
           type: 'String'
       }, {
           dataIndex: 'eWayBillAssignedIndex',
           type: 'String'
       }, {
           dataIndex: 'noOfVehiclesGPSTurnOffDataIndex',
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
           hidden: false,
           width: 120,
           hidden: true,
           hideable:false,
           sortable: true,
           dataIndex: 'dateDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Vehicles GPS Tampered</span>",
           hidden: true,
           width: 120,
           sortable: true,
           dataIndex: 'noOfVehiclesGPSTamperedDataIndex',
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
           header: "<span style=font-weight:bold;>No Of Vehicles GPS Turn Off</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfVehiclesGPSTurnOffDataIndex',
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
grid = getGrid('', 'No Records Found', store, screen.width - 35, 330, 10, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************

function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {

var startDate = Ext.getCmp('startdate').getValue();
var endDate = Ext.getCmp('enddate').getValue();


tamperedstore.load({
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
    idProperty: 'tamparingid',
    root: 'tamparingRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNumberDataIndex'
    },  {
        name: 'wayBillNumberDataIndex'
    }, {
        name: 'reachNameDataIndex'
    }, {
        name: 'ewayBillDateAndTimeDataIndex'
    }, {
        name: 'destinationDataIndex'
    }, {
        name: 'clientNameDataIndex'
    }, {
        name: 'placeofTamperingDataIndex'
    }, {
        name: 'latitudeIndex'
    }, {
        name: 'longitudeIndex'
    }]
});

var tamperedstore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/TamparingOrTurnOff.do?param=getTamparingOrTurnOffReport',
        method: 'POST'
    }),
    storeId: 'tamparingStoreId',
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
        dataIndex: 'wayBillNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'reachNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ewayBillDateAndTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'destinationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'clientNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'placeofTamperingDataIndex'
    },{
        type: 'string',
        dataIndex: 'latitudeIndex'
    },{
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
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Tampering Location</span>",
            dataIndex: 'placeofTamperingDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>eWayBill No</span>",
            dataIndex: 'wayBillNumberDataIndex',
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
        },{
            header: "<span style=font-weight:bold;>eWayBill Date and Time</span>",
            dataIndex: 'ewayBillDateAndTimeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination</span>",
            dataIndex: 'destinationDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'clientNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Latitude</span>",
            dataIndex: 'latitudeIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Longitude</span>",
            dataIndex: 'longitudeIndex',
            hidden: true,
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
 var reachentry=selected.get('ewayBillDateAndTimeDataIndex');
 var latitude=selected.get('latitudeIndex');
 var longitude=selected.get('longitudeIndex');
 var destination=selected.get('destinationDataIndex');
 if(destination=="" || destination==null)
{
Ext.example.msg("Please select A vehicle Having eWayBill"); 
return;		                            
}
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
datagrid = getGrid('', 'No Records Found', tamperedstore, screen.width -35,250, 17, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, 'Add', true, 'History Analysis', false, 'Delete');
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
              value:'7'
   	 	}
   	});
});
</script>
</body>
</html>
<%}%>
    
    
    
    

