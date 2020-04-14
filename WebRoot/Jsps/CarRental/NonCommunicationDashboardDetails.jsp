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
String regNo=request.getParameter("RegNo");

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
           NC Details
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
            var jspName = "NonCommunicationAlertReport";
            var exportDataType = "int,string,string,string,number,number,number";
             //***********************************Grid Starts******************************************
              
  
  
  //******************************Store for getting customer name************************
            var custmastcombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                id: 'CustomerStoreId',
                root: 'CustomerRoot',
                autoLoad: true,
                remoteSort: true,
                fields: ['CustId', 'CustName'],
                listeners: {
                    load: function (custstore, records, success, options) {
                        if ( <%= customeridlogged %> > 0) {
                            Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                            var custName1=Ext.getCmp('custmastcomboId').getRawValue();
                            
                        }
                    }
                }
            });
            
             //**************************** Combo for Client Name***************************************************
            var clientnamecombo = new Ext.form.ComboBox({
    store: custmastcombostore,
    id: 'custmastcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Customer',
    blankText: 'Select Customer',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'CustId',
    displayField: 'CustName',
    cls: 'selectstylePerfect',

                listeners: {
                    select: {
                        fn: function () {
                        var custName1=Ext.getCmp('custmastcomboId').getRawValue();
                            
                        }
                    }
                }
            });
            //*********************************submit button
             var editInfo1 = new Ext.Button({
            text: 'Submit',
            cls: 'buttonStyle',
            width: 100,
            handler: function ()

            {
            }
            });
             
 
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'NonCommAlertDetailsRoot',
                totalProperty: 'total',
                fields: [{name:'alertslno'
                	}, {
                        name: 'vehicleNoIndex'
                    },{
                    	name:'locationIndex',
                    },{
                        name: 'groupNameIndex', 
					},{
                        name: 'dateTimeIndex', 
					},{
                        name: 'cityIndex', 
					},{
                        name: 'speedIndex', 
					},{
                        name: 'ignaionIndex', 
					},{
                        name: 'gpsTamperingdateIndex', 
					},{
                        name: 'gpsTamperingLocationIndex', 
					}
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getNonCommunicationAlertDetails',
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
                        dataIndex: 'alertslno'
                    }, {
                        type: 'string',
                        dataIndex: 'vehicleNoIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'locationIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'groupNameIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'dateTimeIndex'
                    },
                    {
                        type: 'string',
                        dataIndex: 'cityIndex'
                    },
                    {
                        type: 'string',
                        dataIndex: 'speedIndex'
                    },
                    {
                        type: 'string',
                        dataIndex: 'ignaionIndex'
                    },{
                        type: 'string',
                        dataIndex: 'gpsTamperingdateIndex'
                    },
                    {
                        type: 'string',
                        dataIndex: 'gpsTamperingLocationIndex'
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
                            type: 'numeric'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Vehicle Number</span>",
                        dataIndex: 'vehicleNoIndex',
                       // width:250,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Location</span>",
                        dataIndex: 'locationIndex',
                        //width:100,
                        hidden:false,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Group Name</span>",
                        dataIndex: 'groupNameIndex',
                        width:50,
                        //hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Date / Time</span>",
                        dataIndex: 'dateTimeIndex',
                       //  width:150,
                        hidden:false,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>City</span>",
                        dataIndex: 'cityIndex',
                      //   width:150,
                        hidden:false,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Speed</span>",
                        dataIndex: 'speedIndex',
                     //    width:150,
                        hidden:false,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Ignition(NO/OFF)</span>",
                        dataIndex: 'ignaionIndex',
                     //    width:150,
                        hidden:false,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>GPS Tampering Date & time</span>",
                        dataIndex: 'gpsTamperingdateIndex',
                     //    width:150,
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>GPS tampering location</span>",
                        dataIndex: 'gpsTamperingLocationIndex',
                     //    width:150,
                        hidden:true,
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

            var grid = getVerticalPlatFormGrid('<%=alert%> > <%=alertName%>', '<%=NoRecordsFound%>', store,screen.width-30, 435, 15,filters, false, '', false, '', 10, false, '', false, '', false, '', jspName, exportDataType, false, '');

             //********************************************Grid Panel Config Ends********************************
             		         
            
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
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},
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
                    				  regNo:"<%=regNo%>",
                    				  jspName: jspName
                                        }
                                    });
  
            });
           
            if('<%=alertID%>'==4){
              grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('gpsTamperingdateIndex'), false);
              grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('gpsTamperingLocationIndex'), false);
             }
            	
        </script>
    </body>

</html>
