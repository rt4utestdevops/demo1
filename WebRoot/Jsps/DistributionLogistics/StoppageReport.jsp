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
String StartDate=request.getParameter("startDate");
String EndDate=request.getParameter("EndDate");
String VehicleNo=request.getParameter("VehicleNo");
String alertName="";

String fromdate= request.getParameter("fromdate");
String todate= request.getParameter("todate");

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
alertName="Stoppage Report";

%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
          Stoppage Report
        </title>
        <style>
        #backbuttonid{
          padding-left: 130px;
        }
        
        .green-row .x-grid3-cell-inner {
        background-color: lightgreen;
        font-style: italic;
        color: black;
    }
    
    .red-row .x-grid3-cell-inner {
        background-color: #E55B3C;
        font-style: italic;
        color: black;
    }
    
    .yellow-row .x-grid3-cell-inner {
        background-color: #FDD017;
        font-style: italic;
        color: black;
    }
        </style>
        
    </head>
    
    <body class="largebody">
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJsForDriver.jsp" />
        <script>
            var outerPanel;
					var custID;
					var startdate;
					var enddate;
					var regno;
             //****************************************Export Excel********************************* 
            var jspName = "StoppageRepotEcom";
            var exportDataType = "int,string,string,string,string,string,String";
             //***********************************Grid Starts******************************************
             
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'StopReport',
                totalProperty: 'total',
                fields: [
                {      name:'slno',
                     },{
                     name:'durationNEW',
                	}, {
                        name: 'duration',
                    },{
                    	name:'startdate',
                    },{
                        name: 'enddate', 
					},{
                        name: 'location', 
					},{
                        name: 'value',
                    }
                ]
            });


             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=getstopReport',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
            field: 'value',
            direction: 'ASC'
        },
                storeId: 'darStore',
                reader: reader
            });
            store.on('beforeload', function (store, operation, eOpts) {
     
                operation.params = {
                    custID: '<%=clientID%>',
                    startdate:'<%=StartDate%>',
                    enddate:'<%=EndDate%>',
                   regno:'<%=VehicleNo%>',
                    jspName: jspName
                };
            }, this);
             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'string',
                        dataIndex: 'durationNEW'
                    },{
                        type: 'int',
                        dataIndex: 'slno'
                    }, {
                        type: 'string',
                        dataIndex: 'duration'
                    }, {
                        type: 'string',
                        dataIndex: 'startdate'
                    }, {
                        type: 'string',
                        dataIndex: 'enddate'
                    }, {
                        type: 'string',
                        dataIndex: 'location'
                    },
                    {
                        type: 'string',
                        dataIndex: 'value'
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
              dataIndex: 'slno',
              hidden: true,
              header: "<span style=font-weight:bold;>SL NO</span>",
              filter: {
                  type: 'numeric'
              }
          },
                    {
                        header: "<span style=font-weight:bold;>Duration</span>",
                        dataIndex: 'durationNEW',
                        filter: {
                            type: 'string'
                        },
                        hidden:true
                    },{
                        header: "<span style=font-weight:bold;>Duration</span>",
                        dataIndex: 'duration',
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Location</span>",
                        dataIndex: 'location',
                        width:300,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Start Date</span>",
                        dataIndex: 'startdate',
                         filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>End Date</span>",
                        dataIndex: 'enddate',
                        filter: {
                            type: 'string'
                        }
                    }
                    ,
                    {
                        header: "<span style=font-weight:bold;>Value</span>",
                        dataIndex: 'value',
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


 var notePanel = new Ext.Panel({
                        standardSubmit: true,
                        id: 'notePanelID',
                        hidden: false,
                        collapsible: false,
                        items: [{
                            html: "<div >Note:</div>",
                            style: 'font-weight:bold;font-size:14px;',
                            cellCls: 'bskExtStyle'
                        }, {
                            html: "<table><TR><TD></TD><TD class=col>** Colour Code indicate as fallows. </TD></TR><tr><td></td><td class=col><img src='<%=request.getContextPath()%>/Main/images/Drlegend_green.png' width='35px' height='15px' />&nbsp;Stoppage Hrs from 1 to 2 hrs</td></tr> <tr><td></td><td class=col><img src='<%=request.getContextPath()%>/Main/images/Drlegend_yellow.png' width='35px' height='15px' />&nbsp;Stoppage Hrs from 2 to 4 hrs</td></tr><tr><td></td><td class=col><img src='<%=request.getContextPath()%>/Main/images/Drlegend_red.png' width='35px' height='15px'/>&nbsp;Stoppage Hrs greater than 4 hrs </td></tr></table>",
                            style: 'font-size:12px;',
                            cellCls: 'bskExtStyle'
                        }]
                    });
             //*******************************************Grid Panel Config***************************************

            var grid = getGrid('<%=alertName%>', '<%=NoRecordsFound%>', store,screen.width-30, 350, 9,filters,'', false, '', 10, false, '', false, '',true, 'Excel', jspName, exportDataType, true, 'Pdf');

             //********************************************Grid Panel Config Ends********************************
             grid.getView().getRowClass = function(record, index) {

                        var score = record.data.value;
                        if (parseInt(score) ==1) {
                            rowcolour = 'green-row';
                        } else if (parseInt(score) >= 2 && parseInt(score) < 4) {
                            rowcolour = 'yellow-row';
                        } else if (parseInt(score) >= 4) {
                            rowcolour = 'red-row';
                        }

                        return rowcolour
                    };
		         //grid.getSelectionModel().getSelected()='';
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
                                var checkDashBoardDetails = '1'; 
                                   window.location ="<%=request.getContextPath()%>/Jsps/DistributionLogistics/APMTTripDetails.jsp?fromdate="+'<%=fromdate%>'+"&todate="+'<%=todate%>'+"&checkDashBoardDetails="+checkDashBoardDetails;
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
                    items: [grid,buttonPanel,notePanel]

                });
                store.load({
            
                             params: {
                    				   custID: '<%=clientID%>',
                    startdate:'<%=StartDate%>',
                    enddate:'<%=EndDate%>',
                   regno:'<%=VehicleNo%>',
                    jspName: jspName 
                                           }
                                    });
            });
        </script>
    </body>

</html>
