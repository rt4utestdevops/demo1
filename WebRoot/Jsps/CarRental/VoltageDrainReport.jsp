<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
String clientID=request.getParameter("cutomerID");
String alertID=request.getParameter("AlertId");
String alertName="";
 String alert=cf.getLabelFromDB("Alert",language);
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
String NoRecordsFound;
lwb=(LanguageWordsBean)langConverted.get("No_Records_Found");
if(language.equals("ar")){
	NoRecordsFound=lwb.getArabicWord();
}else{
	NoRecordsFound=lwb.getEnglishWord();
}
lwb=null;
String ClearFilterData;
lwb=(LanguageWordsBean)langConverted.get("Clear_Filter_Data");
if(language.equals("ar")){
	ClearFilterData=lwb.getArabicWord();
}else{
	ClearFilterData=lwb.getEnglishWord();
}
lwb=null;
String ReconfigureGrid;
lwb=(LanguageWordsBean)langConverted.get("Reconfigure_Grid");
if(language.equals("ar")){
	ReconfigureGrid=lwb.getArabicWord();
}else{
	ReconfigureGrid=lwb.getEnglishWord();
}
lwb=null;
String ClearGrouping;
lwb=(LanguageWordsBean)langConverted.get("Clear_Grouping");
if(language.equals("ar")){
	ClearGrouping=lwb.getArabicWord();
}else{
	ClearGrouping=lwb.getEnglishWord();
}
lwb=null;
boolean hide=false;
boolean hide1=true;
alertName="Vehicle Battery Voltage Status";
if(alertID.equals("-1"))
{
alertName="Immobilized Vehicles";
hide=true;
hide1=false;
}
%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
           Vehicle Battery Voltage Status
        </title>
        <style>
        #backbuttonid{
          padding-left: 130px;
        }
        </style>
        
    </head>
    
    <body class="largebody">
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
            var outerPanel;
             //****************************************Export Excel********************************* 
            var jspName = "VehicleBatteryReport";
            var exportDataType = "int,string,float,string,string,string";
             //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'AlertDetailsRoot',
                totalProperty: 'total',
                fields: [
                {      name:'slnoIndex',
                     },{
                     name:'vehicleNoDI',
                	}, {
                        name: 'batteryVoltageDI',
                    },{
                    	name:'drivernamerDI',
                    },{
                        name: 'drivernumberDI', 
					},{
                        name: 'locationDI', 
					}
                ]
            });


             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getVoltageBatteryDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                
                storeId: 'darStore',
                reader: reader
            });
            store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    custID:<%=clientID%>,
                    alertId:<%=alertID%>,
                    jspName: jspName
                };
            }, this);
             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'string',
                        dataIndex: 'vehicleNoDI'
                    },{
                        type: 'int',
                        dataIndex: 'slnoIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'batteryVoltageDI'
                    }, {
                        type: 'string',
                        dataIndex: 'drivernamerDI'
                    }, {
                        type: 'string',
                        dataIndex: 'drivernumberDI'
                    }, {
                        type: 'string',
                        dataIndex: 'locationDI'
                    }
                    
                ]
            });

             //************************************Column Model Config******************************************
            var createColModel = function (finish, start) {

                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;>SL NO</span>",
                        width: 50
                    }),{
              dataIndex: 'slnoIndex',
              hidden: true,
              header: "<span style=font-weight:bold;>SL NO</span>",
              filter: {
                  type: 'numeric'
              }
          },
                    {
                        header: "<span style=font-weight:bold;>Vehicle No</span>",
                        dataIndex: 'vehicleNoDI',
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Battery Voltage</span>",
                        dataIndex: 'batteryVoltageDI',
                        filter: {
                            type: 'numeric'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Location</span>",
                        dataIndex: 'locationDI',
                        width:300,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Driver Name</span>",
                        dataIndex: 'drivernamerDI',
                         filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Driver Number</span>",
                        dataIndex: 'drivernumberDI',
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

             //*******************************************Grid Panel Config***************************************

            var grid = getGrid('<%=alertName%>', '<%=NoRecordsFound%>', store,screen.width-30, 500, 9,filters,'', false, '', 10, false, '', false, '',true, 'Excel', jspName, exportDataType, true, 'Pdf');

             //********************************************Grid Panel Config Ends********************************
           
		         
           var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'dashboardinnerpanelgridpercentage',
                height:40,
                //bodyStyle: 'background: #ececec',
                border:false,
                frame:false,
                id: 'buttonpanel',
                layout: 'column',
                layoutConfig: {
                    columns: 12
                },
                items: [{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	
                    {
                        xtype: 'button',
                        text: 'Back',
                        id: 'backbuttonid',
                        cls: 'buttonstyle',
                        iconCls: 'backbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                   window.location ="<%=request.getContextPath()%>/Jsps/CarRental/DashBoard.jsp";
                                }
                            }
                        }
                    }
                ]
            }); // End of Panel	
             //***************************************Main starts from here*************************
            Ext.onReady(function () {
    
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: false,
                    cls: 'outerpanel',
                    items: [grid,buttonPanel]

                });
                store.load({
                             params: {
                    				  alertId:<%=alertID%>,
                    				  jspName: jspName
                                        }
                                    });
            });
        </script>
    </body>

</html>
