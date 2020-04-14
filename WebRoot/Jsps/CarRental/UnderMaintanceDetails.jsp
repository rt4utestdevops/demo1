<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
String clientID="1";
String alertID="1";
String alertName="1";
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
%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
           Under Maintenance Report
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
        Ext.Ajax.timeout = 360000;
            var outerPanel;
            var dtprev = dateprev;
            var dtcur = datecur;

             //****************************************Export Excel********************************* 
            var jspName = "UnderMaintanceReport";
            var exportDataType = "int,string,string,string,number,number,number";
             //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'maintanceoot',
                totalProperty: 'total',
                fields: [{name:'alertslno'
                	}, {
                        name: 'regNoDataIndex'
                    },{
                    	name:'locationDataIndex',
                    },{
                        name: 'arrivalDataIndex', 
					},{
                        name: 'driverName', 
					}
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getUnderMaintanceDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'darStore',
                reader: reader
            });
<!--            store.on('beforeload', function (store, operation, eOpts) {-->
<!--                operation.params = {-->
<!--                    custID:<%=clientID%>,-->
<!--                    alertId:<%=alertID%>,-->
<!--                    jspName: jspName-->
<!--                };-->
<!--            }, this);-->
             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'int',
                        dataIndex: 'alertslno'
                    }, {
                        type: 'string',
                        dataIndex: 'regNoDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'locationDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'arrivalDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'driverName'
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
                        header: "<span style=font-weight:bold;>SL NO</span>",
                        dataIndex: 'alertslno',
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Registration No</span>",
                        dataIndex: 'regNoDataIndex',
                        width:50,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Location</span>",
                        dataIndex: 'locationDataIndex',
                        width:250,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Actual Arrival</span>",
                        dataIndex: 'arrivalDataIndex',
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Driver Name</span>",
                        dataIndex: 'driverName',
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

            var grid = getVerticalPlatFormGrid('Under Maintenance Details', '<%=NoRecordsFound%>', store,screen.width-30, 500, 9,filters, false, '', false, '', 10, false, '', false, '', false, '', jspName, exportDataType, false, '');

            var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'dashboardinnerpanelgridpercentage',
                height:40,
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
                
                store.load();
            });
        </script>
    </body>

</html>
