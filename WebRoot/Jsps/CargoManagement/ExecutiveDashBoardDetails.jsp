<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	
	String clientID=request.getParameter("cutomerID");
	
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
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();

	int systemid=loginInfo.getSystemId();
	String systemID=Integer.toString(systemid);
	String clientID=request.getParameter("cutomerID");
	String type=request.getParameter("type");
	String custName=request.getParameter("custName");
	
ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Reconfigure_Grid");
	tobeConverted.add("Clear_Grouping");
	tobeConverted.add("SLNO");
	tobeConverted.add("Select_Single_Row");

	
	

ArrayList<String> convertedWords = new ArrayList<String>();
 	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String NoRecordsFound = convertedWords.get(0);
 	String ClearFilterData = convertedWords.get(1);
 	String ReconfigureGrid = convertedWords.get(2);
 	String ClearGrouping = convertedWords.get(3);
    String SLNO = convertedWords.get(4);
    String SelectSingleRow=convertedWords.get(5);
    
%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
           ExecutiveDashBoardDetails
        </title>
    </head>
    
    <body class="largebody">
        <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
            var outerPanel;
            var ctsb;
            var dtprev = dateprev;
            var dtcur = datecur;
			var grid;
			
			 //****************************************Export Excel********************************* 
            var jspName = "ExecutiveDashBoardDetails";
            var exportDataType = "int,string,string,string,string,string,string,string,date,string,string,string,string,string,date,string";

             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'ExecutiveDashBoardDetailsRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slno'
                    },{
                    	name: 'VehicleNo'
                    }, {
                        name: 'RouteName',
                    }, {
                        name: 'RouteCode',
                    }, {
                        name: 'TripStartTime'
                    }, {
                        name: 'LastHubName'
                    },{
                        name: 'AverageSpeed'
                    },{
                        name: 'ScheduledArrivalDateTime',
                        type: 'date',
                        dateFormat: getDateTimeFormat()
                    },{
                        name: 'fromSourceLocation'
                    },{
                        name: 'toDestionation'
                    },{
                        name: 'CurrentLocation'
                    },{
                        name: 'distanceTravelled'
                    },{
                        name: 'delayTime'
                    },{
                        name: 'idleTime'
                    },{
                        name: 'LastCommunicatedDateTime',
                        type: 'date',
                        dateFormat: getDateTimeFormat()
                    },{
                        name: 'status'
                    }
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getExecutiveDashBoardDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'VehicleNo',
                    direction: 'ASC'
                },
                storeId: 'ExecutiveDashboardDetails',
                reader: reader
            });
            
             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slno'
                    }, {
                        type: 'string',
                        dataIndex: 'VehicleNo'
                    },{
                        type: 'string',
                        dataIndex: 'RouteName'
                    },{
                        type: 'string',
                        dataIndex: 'RouteCode'
                    },{
                        type: 'string',
                        dataIndex: 'TripStartTime'
                    }, {
                        type: 'string',
                        dataIndex: 'LastHubName'
                    },{
                        type: 'string',
                        dataIndex: 'AverageSpeed'
                    },{
                        type: 'date',
                        dataIndex: 'ScheduledArrivalDateTime'
                    },{
                        type: 'string',
                        dataIndex: 'fromSourceLocation'
                    },{
                        type: 'string',
                        dataIndex: 'toDestionation'
                    },{
                        type: 'string',
                        dataIndex: 'CurrentLocation'
                    },{
                        type: 'string',
                        dataIndex: 'distanceTravelled'
                    },{
                        type: 'string',
                        dataIndex: 'delayTime'
                    },{
                        type: 'string',
                        dataIndex: 'idleTime'
                    },{
                        type: 'date',
                        dataIndex: 'LastCommunicatedDateTime'
                    },{
                        type: 'string',
                        dataIndex: 'status'
                    }
                ]
            });
            
             //************************************Column Model Config******************************************
            var createColModel = function (finish, start) {
                
                
                       var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 50
                    }), {
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        dataIndex: 'slno',
                        hidden:true,
                        filter: {
                            type: 'numeric'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Vehicle No</span>",
                        dataIndex: 'VehicleNo',
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Route Name</span>",
                        dataIndex: 'RouteName',
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Route Code</span>",
                        dataIndex: 'RouteCode',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Trip Start Time</span>",
                        dataIndex: 'TripStartTime',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Last Hub Name</span>",
                        dataIndex: 'LastHubName',
                        hidden: true,
                        hideable: false,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Average Speed</span>",
                        dataIndex: 'AverageSpeed',
                        hidden: true,
						hideable: false,
                       filter: {
                            type: 'string'
                        }
                        
                     },{
                        header: "<span style=font-weight:bold;>Scheduled Arrival(Date,Time)</span>",
                        dataIndex: 'ScheduledArrivalDateTime',
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
                        }
                    },{
                        header: "<span style=font-weight:bold;>From Source Location</span>",
                        dataIndex: 'fromSourceLocation',
                       filter: {
                            type: 'string'
                        }
                        
                     },{
                        header: "<span style=font-weight:bold;>To Destination</span>",
                        dataIndex: 'toDestionation',
                       filter: {
                            type: 'string'
                        }
                        
                     },{
                        header: "<span style=font-weight:bold;>Current Location</span>",
                        dataIndex: 'CurrentLocation',
                        filter: {
                            type: 'string'
                        }
                     },{
                        header: "<span style=font-weight:bold;>Distance Travelled(Kms)</span>",
                        dataIndex: 'distanceTravelled',
                       filter: {
                            type: 'string'
                        }
                     },{
                        header: "<span style=font-weight:bold;>Delay Time(HH:MM)</span>",
                        dataIndex: 'delayTime',
                       filter: {
                            type: 'string'
                        }
                        
                     },{
                        header: "<span style=font-weight:bold;>Idle Time(HH:MM)</span>",
                        dataIndex: 'idleTime',
                       filter: {
                            type: 'string'
                        }
                     },{
                        header: "<span style=font-weight:bold;>Last Communicated(Date,Time)</span>",
                        dataIndex: 'LastCommunicatedDateTime',
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Status</span>",
                        dataIndex: 'status',
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

function addRecord()
{
if (grid.getSelectionModel().getCount() > 1) {
Ext.example.msg("<%=SelectSingleRow%>");
    return;
}
 var selected = grid.getSelectionModel().getSelected();
 var vehicleNo = selected.get('VehicleNo');
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
//openNormalWindow("HistoryWin",'History',"/jsps/CustomHistoryTracking.jsp");

}
             //*******************************************Grid Panel Config***************************************

             grid = getGrid('Dashboard Details', '<%=NoRecordsFound%>', store,screen.width-40,450,20, filters, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, false, '<%=ClearGrouping%>', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'View Map');

             //********************************************Grid Panel Config Ends********************************
             
             //********************************************Inner Pannel Starts******************************************* 
            var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'dashboardinnerpanelgridpercentage',
                height:40,
                id: 'buttonpanel',
                layout: 'column',
                layoutConfig: {
                    columns: 14
                },
                items: [{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	
                    {
                        xtype: 'button',
                        text: 'Back',
                        id: 'backbuttonid',
                        iconCls: 'backbutton',
                        cls: 'dashboarddetailsbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                   window.location ="<%=request.getContextPath()%>/Jsps/CargoManagement/ExecutiveDashboard.jsp?cutomerIDPassed=<%=clientID%>";
                                }
                            }
                        } 
                    }
                ]
            }); // End of Panel	
             //***************************************Main starts from here*************************
            Ext.onReady(function () {
                ctsb = tsb;
                Ext.QuickTips.init();
                Ext.Ajax.timeout = 180000;  
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: false,
                    height: 510,
                    width:screen.width-25,
                    items: [grid,buttonPanel],
                    bbar: ctsb
                });
                store.load({
                             params: {
                                      custID:<%=clientID%>,
                                      type:'<%=type%>',
                    				  jspName: jspName,
                    				  custName:'<%=custName%>'
                                     }
                         });
    var cm = grid.getColumnModel();  
    
      var basictype='<%=type%>';
                    
     if(basictype=="totalasset"){
          	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('LastHubName'),true);
          	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('AverageSpeed'),true);
          	
      }
      if(basictype=="nogps" || basictype=="noncommunicating"){
          	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('LastHubName'),true);
          	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('AverageSpeed'),true);
          	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('status'),true);
      }
      if(basictype=="onschedule" || basictype=="bsvunderobv" || basictype=="bsvactionreq"){
           grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('status'),true);
           grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('LastHubName'),false);
          	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('AverageSpeed'),false);
      }
                 
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,120);
    }
            });
        </script>
    </body>

</html>