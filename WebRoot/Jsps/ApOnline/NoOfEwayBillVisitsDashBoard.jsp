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
var jspName="eWayBillVsReachVisits";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string";
var myWin;
var recordNumber;

var clientPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     title:'No Of E-Way Bill V/S Sand Reach Visits',
     id: 'datePanelId',
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
                                			value:'6'
                            			}
                        			});
                        	  		noofwaysstore.removeAll();
			       			  		Ext.getCmp('firstGridPanelId').setHeight(380);
			       			  		Ext.getCmp('secondGridPanelId').setHeight(0);
							  }
							}
					}
			}
     ]
 });

var reader = new Ext.data.JsonReader({
   root: 'noOfewayBillDetailsRoot',
   totalProperty: 'total',
   fields: [{
       name: 'slnoDataIndex'
   },{
       name: 'dateDataIndex'
   },{
       name: 'noOfvehiclesDataIndex'
   },{
       name: 'noOfReachVisitsDataIndex'
   },{
       name: 'noOfWayBillsIssuedDataIndex'
   },{
       name: 'perOfDifferenceInVisitandWayBillDataIndex' 
   },{
       name: 'noOfReachVisitseWayBillsDataIndex' 
   },{
       name: 'withoutGPSDataIndex'  
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
           dataIndex: 'noOfvehiclesDataIndex',
           type: 'String'
       }, {
           dataIndex: 'noOfReachVisitsDataIndex',
           type: 'String'
       }, {
           dataIndex: 'noOfWayBillsIssuedDataIndex', 
           type: 'String'
       }, {
           dataIndex: 'perOfDifferenceInVisitandWayBillDataIndex',
           type: 'String' 
       }, {
           dataIndex: 'noOfReachVisitseWayBillsDataIndex',
           type: 'String'
       }, {
           dataIndex: 'withoutGPSDataIndex',
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
           header: "<span style=font-weight:bold;>No Of Vehicles</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfvehiclesDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No Of Reach Visits</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfReachVisitsDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>Reach Visits with eWayBills</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfReachVisitseWayBillsDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>Total No Of eWayBills Issued</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'noOfWayBillsIssuedDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>Difference In Visit and eWayBill</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'perOfDifferenceInVisitandWayBillDataIndex',
           filter: {
               type: 'String'
           }
       },{
           header: "<span style=font-weight:bold;>No of eWayBill without GPS</span>",
           hidden: false,
           width: 120,
           sortable: true,
           dataIndex: 'withoutGPSDataIndex',
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
grid = getGrid('', 'No Records Found', store, screen.width -35, 330, 12, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete');
//******************************************************************************************************************************************************

function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
if (grid.getSelectionModel().getCount() == 1) {
         var selected = grid.getSelectionModel().getSelected();
         var destinationName = selected.get('sameDestinationIndex');
		var startDate = Ext.getCmp('startdate').getValue();
		var endDate = Ext.getCmp('enddate').getValue();
	
}
noofwaysstore.load({
      params:{
          destinationName:destinationName,
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
  
  //sameer
  var reader = new Ext.data.JsonReader({
    idProperty: 'noOfewayBillsVsVisitsid',
    root: 'noOfewayBillsVsVisitsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'vehicleNumberDataIndex'
    }, {
        name: 'reachNameDataIndex'
    }, {
        name: 'reachEntryDateTimeDataIndex'
    }, {
        name: 'reachExitDateTimeDataIndex'
    }, {
        name: 'eWayBillDataIndex'
    }, {
        name: 'Remarks1dataIndex'
    }, {
        name: 'Remarks2dataIndex'
    },{
        name: 'latitudeIndex'
    },{
        name: 'longitudeIndex'
    },{
        name: 'destinationIndex'
    }]
});

var noofwaysstore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/NoOfewayBillsVsVisits.do?param=getNoOfeWayBillsVsVisits',
        method: 'POST'
    }),
    storeId: 'noofewaybillId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'reachNameDataIndex'
    }, {
        type: 'date',
        dataIndex: 'reachEntryDateTimeDataIndex'
    }, {
        type: 'date',
        dataIndex: 'reachExitDateTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'eWayBillDataIndex'
    },{
        type: 'string',
        dataIndex: 'Remarks1dataIndex'
    },{
        type: 'string',
        dataIndex: 'Remarks2dataIndex'
    },{
        type: 'string',
        dataIndex: 'latitudeIndex'
    },{
        type: 'string',
        dataIndex: 'longitudeIndex'
    },{
        type: 'string',
        dataIndex: 'destinationIndex'
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
            header: "<span style=font-weight:bold;>Unique Id</span>",
            hidden: true,
            dataIndex: 'uniqueIdDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Vehicle Number</span>",
            dataIndex: 'vehicleNumberDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Reach Name</span>",
            dataIndex: 'reachNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Reach Entry Date Time</span>",
            dataIndex: 'reachEntryDateTimeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Reach Exit Date Time</span>",
            dataIndex: 'reachExitDateTimeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>eWayBill No</span>",
            dataIndex: 'eWayBillDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Remarks1</span>",
            dataIndex: 'Remarks1dataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Remarks2</span>",
            dataIndex: 'Remarks2dataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
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
        }, {
            header: "<span style=font-weight:bold;>Destination</span>",
            hidden: true,
            dataIndex: 'destinationIndex',
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

  var startdatee=Ext.util.Format.date(Ext.getCmp('startdate').getValue(),'d/m/Y');
  var endDatee=Ext.util.Format.date(Ext.getCmp('enddate').getValue(),'d/m/Y');
  var userid='<%=userid%>';
  var clientid='<%=customerId%>';
  var selected = datagrid.getSelectionModel().getSelected();
  var vehicleNo = selected.get('vehicleNumberDataIndex');
  var reachentry=selected.get('reachEntryDateTimeDataIndex');
  reachentry=reachentry.replace(" ", "T");
  var latitude=selected.get('latitudeIndex');
  var longitude=selected.get('longitudeIndex');
  var destination=selected.get('destinationIndex');
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
datagrid = getGrid('', 'No Records Found', noofwaysstore, screen.width - 35,250, 13, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'View Map', true, 'History Analysis', false, 'Delete');
//******************************************************************************************************************************************************
 function onCellClickOnGrid1(datagrid, rowIndex, columnIndex, e) {
 if (datagrid.getSelectionModel().getCount() ==1) {
  		 var selected = grid.getSelectionModel().getSelected();
         var remarks1 = selected.get('Remarks1dataIndex');
		 var remarks2 = selected.get('Remarks2dataIndex');
		 var recno = parseInt(columnIndex);
}
		if (recno==8){
					addRemarks1(recno);
			}else if (recno==9){
					addRemarks2(recno);
			}

}    


 datagrid.on({
      "cellclick": {
          fn: onCellClickOnGrid1
      }
  });
  
   function addRemarks1(recno) {
    if (datagrid.getSelectionModel().getCount() == 0) {
        setMsgBoxStatus("No Rows Selected");
       
        return;
    }
    if (datagrid.getSelectionModel().getCount() > 1) {
        setMsgBoxStatus('Select Single Row');
         
        return;
    }
    var selected = datagrid.getSelectionModel().getSelected();
    Ext.getCmp('remID').setValue(selected.get('Remarks1dataIndex'));
    recordNumber=recno;
    buttonValue = 'add';
    titelForInnerPanel = 'Add Remarks';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    
    myWin.show();
}

function addRemarks2(recno) {
    if (datagrid.getSelectionModel().getCount() == 0) {
        setMsgBoxStatus("No Rows Selected");
       
        return;
    }
    if (datagrid.getSelectionModel().getCount() > 1) {
        setMsgBoxStatus('Select Single Row');
         
        return;
    }
    recordNumber=recno;
    var selected = datagrid.getSelectionModel().getSelected();
    Ext.getCmp('remID').setValue(selected.get('Remarks2dataIndex'));
    buttonValue = 'add';
    titelForInnerPanel = 'Add Remarks';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    
    myWin.show();
}


var innerPanelForRemarks = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 110,
    width: 400,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
   
        items: [{
                xtype: 'label',
                text: 'Remarks:',
                cls: 'labelstyle',
                id: 'defaultDaysTxtId'
            },{
                xtype: 'textarea',
				//id: 'rem1',
				readOnly: false,
	   			width: 300,
	   			maxLength: 500,
	   			value: '',
	   			cls: 'bskExtStyle',
                //cls: 'selectstylePerfect',
                id: 'remID'
            } 
        ]
    
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    }, buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    
                    if (innerPanelForRemarks.getForm().isValid()) {
                        
                        var selectdID;
                        var selected = datagrid.getSelectionModel().getSelected();
                        selectdID= selected.get('uniqueIdDataIndex');
                        taskMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/NoOfewayBillsVsVisits.do?param=addRemarks',
                            method: 'POST',
                            params: {
                                selectdID:selectdID,
                                jspName: jspName,
                                recordNumber:recordNumber,
                                remID:Ext.getCmp('remID').getValue()
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                setMsgBoxStatus(message);
                                myWin.hide();
                                taskMasterOuterPanelWindow.getEl().unmask();
                                noofwaysstore.reload();
                            },
                            failure: function () {
                                ctsb.setStatus({
                                    text: getMessageForStatus("Error"),
                                    iconCls: '',
                                    clear: true
                                });
                                
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    Ext.getCmp('remID').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

var taskMasterOuterPanelWindow = new Ext.Panel({
    width: 390,
    height:175,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForRemarks, innerWinButtonPanel]
  });

myWin = new Ext.Window({
    title: 'My win',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 216,
    width: 390,
    id: 'myWin',
    items: [taskMasterOuterPanelWindow]
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
        width: screen.width-25,
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
              value:'6'
   	 	}
   	});

});
</script>
</body>
</html>
<%}%>