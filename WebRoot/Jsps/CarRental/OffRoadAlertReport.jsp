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
int customeridlogged=loginInfo.getCustomerId();
String alertID=request.getParameter("AlertId");
String alertName=request.getParameter("AlertName");
if(alertName.equals("Distress")){
  alertName="Panic";
}
if(alertName.equals("Main Power On/Off")){ 
   alertName="GPS / Vehicle Wiring Tampered";
}
if(alertName.equals("Crossed Border")){
 alertName="Outside OLA Border Limit";
}
if(alertName.equals("OverSpeed")){
 alertName="Over Speed";
}
// alertName=cf.getLabelFromDB(alertName.trim().replace(" ","_"),language);
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
%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
           Alert Report
        </title>
        <style type="text/css">
 
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
            var jspName = "OffRoadAlertReport";
            var exportDataType = "int,int,string,string,string,string,string,string";
             //***********************************Grid Starts******************************************
              
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'AlertDetailsRoot',
                totalProperty: 'total',
                fields: [{name:'alertslno'
                	}, {name:'slnoIndex'
                	}, {
                		type: 'date',
                        name: 'arrivalTime'
                    },{
                    	name:'vehicleNo',
                    },{
                        name: 'location', 
					}
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getOffRoadAlertDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                
                storeId: 'darStore',
                reader: reader
            });

             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'int',
                        dataIndex: 'slnoIndex'
                    }, {
                        type: 'int',
                        dataIndex: 'alertslno'
                    }, {
                        type: 'date',
                        dataIndex: 'arrivalTime'
                    }, {
                        type: 'string',
                        dataIndex: 'vehicleNo'
                    }, {
                        type: 'string',
                        dataIndex: 'location'
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
                        header: "<span style=font-weight:bold;>SLNO</span>",
                        width: 20,
                        dataIndex: 'slnoIndex',
                        hidden:true,
                        filter: {
                            type: 'numeric'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Alert SLNO</span>",
                        width: 20,
                        dataIndex: 'alertslno',
                        hidden:true,
                        filter: {
                            type: 'numeric'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Vehicle No</span>",
                        dataIndex: 'vehicleNo',
                        width:50,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Lcation</span>",
                        dataIndex: 'location',
                        width:75,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Stockyard Arrival Date & Time</span>",
                        dataIndex: 'arrivalTime',
                        width:50,
                        renderer: Ext.util.Format.dateRenderer('d-m-Y H:i:s')
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

			var grid =getGrid('<%=alertName%>', '<%=NoRecordsFound%>', store,screen.width-30, 435, 9,filters,'', false, '', 10, false, '', false, '',true, 'Excel', jspName, exportDataType, true, 'Pdf');
			
             //********************************************Inner Pannel Starts******************************************* 
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
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
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
                                   // var cm = Grid.getColumnModel();  
  //  for (var j = 1; j < cm.getColumnCount(); j++) {
   //    cm.setColumnWidth(j,50);
   // }
            });
        </script>
    </body>

</html>
