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
String clientID=request.getParameter("cutomerID");
String alertID=request.getParameter("AlertId");
String alertName=request.getParameter("AlertName");
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
           CVS DashBoard Details
        </title>
    </head>
    
    <body class="largebody">
        <jsp:include page="../Common/ImportJS.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
            var outerPanel;
            var ctsb;
            var dtprev = dateprev;
            var dtcur = datecur;

             //****************************************Export Excel********************************* 
            var jspName = "CVSDashBoardDetails";
            var exportDataType = "int,string,string,number,number,number";
<!--             /********************resize window event function***********************/-->
<!--   Ext.EventManager.onWindowResize(function () {-->
<!--   				 var width = '100%';-->
<!--			    var height = '100%';-->
<!--			grid.setSize(width, height);-->
<!--			    outerPanel.setSize(width, height);-->
<!--			    outerPanel.doLayout();-->
<!--			});-->
             //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'AlertDetailsRoot',
                totalProperty: 'total',
                fields: [{name:'alertslno'
                	}, {
                        name: 'VehicleNo'
                    },{ name: 'groupname'
                    }, {
                        name: 'alertdate',
						type: 'date',
                        dateFormat: getDateTimeFormat()
                    }, {
                        name: 'location'
                    }, {
                        name: 'speed'
                    }, {
                        name: 'remarks', 
					}, {
                        name: 'drivername', 
						}
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getDashboardDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'alertdate',
                    direction: 'ASC'
                },
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
                        type: 'int',
                        dataIndex: 'alertslno'
                    }, {
                        type: 'string',
                        dataIndex: 'VehicleNo'
                    },{
                        type: 'string',
                        dataIndex: 'groupname'
                    }, {
                        type: 'date',
                        dataIndex: 'alertdate'
                    }, {
                        type: 'string',
                        dataIndex: 'location'
                    }, {
                        type: 'int',
                        dataIndex: 'speed'
                    }, {
                        type: 'string',
                        dataIndex: 'remarks'
                    }, {
                        type: 'string',
                        dataIndex: 'drivername'
                    }
                ]
            });

             //************************************Column Model Config******************************************
            var createColModel = function (finish, start) {

                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;>SLNO</span>",
                        width: 50
                    }), {
                        header: "<span style=font-weight:bold;>SLNO</span>",
                        dataIndex: 'alertslno',
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Registration No</span>",
                        dataIndex: 'VehicleNo',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Group Name</span>",
                        dataIndex: 'groupname',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },  {
                        header: "<span style=font-weight:bold;>Alert Date</span>",
                        dataIndex: 'alertdate',
                        width:80,
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Location</span>",
                        dataIndex: 'location',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Value</span>",
                        dataIndex: 'speed',
                        width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Remarks</span>",
                        dataIndex: 'remarks',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Driver Name</span>",
                        dataIndex: 'drivername',
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

            var grid = getGrid('<%=alertName%>', '<%=NoRecordsFound%>', store,screen.width-30,500, 9, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', false, '', jspName, exportDataType, false, '');

             //********************************************Grid Panel Config Ends********************************
             var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,
		collapsible:false,
		autoScroll:true,
		width:'100%',
		frame:true,
		id:'custMaster',
		layout:'column',
		layoutConfig: {
			columns:2
		},
		items: [{
				xtype: 'label',
				text: 'Remarks',
				cls:'dashboardlabelstyle2',
				id:'remarkslblid'
				},
				{
				xtype: 'textarea',
				text: 'Remarks',
				cls:'dashboardtextarea',
				id:'remarksid'
				},
				//{cls:'labelstyle'},{cls:'labelstyle'},
				{
	       			xtype:'button',
	      			text:'Save',
	        		id:'saveButtId',
	        		cls:'dashboarddetailsbutton2',
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	       						var selected = grid.getSelectionModel().getSelected();
								Ext.Ajax.request({
								 				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=saveCVSremarks',
												method: 'POST',
												params: 
												{
													 alertslno:selected.get('alertslno'),
													 remark:Ext.getCmp('remarksid').getValue(),
													 regno:selected.get('VehicleNo'),
													 GMT:selected.get('alertdate'),
													 typeofalert:<%=alertID%>,
													 clientId:<%=clientID%>
										        },
												success:function(response, options)//start of success
												{
													 myWin.hide();
											         ctsb.setStatus({
																 text:getMessageForStatus(response.responseText), 
																 iconCls:'',
																 clear: true
											                     });
												      	store.reload();
												       outerPanel.getEl().unmask();
												    
												}, // END OF  SUCCESS
											    failure: function()//start of failure 
											    {
											    	  ctsb.setStatus({
																 text:getMessageForStatus("error"), 
																 iconCls:'',
																 clear: true
											                     });
												     	store.reload();
												       outerPanel.getEl().unmask();
												     
												} // END OF FAILURE 
									}); // END OF AJAX
							}
	       				}
	       			}
	       		},{
	       			xtype:'button',
	      			text:'Cancel',
	        		id:'cancelButtId',
	        		cls:'dashboarddetailsbutton2',
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	       					Ext.getCmp('remarksid').setValue("");
	       					myWin.hide();}
	       				}
	       			}
	       			}		]
		});
		         
             myWin = new Ext.Window({
        	 title:'Acknowledge',
        	 closable: false,
        	 modal: true,
        	 resizable:false,
        	 autoScroll: false,
        	 cls:'mywindow',
        	 height:180,
			 width:'25%',
			 shadow: false,
        	 id     : 'myWin',
        	 items  : [innerPanel]
    		 });
             //********************************************Inner Pannel Starts******************************************* 
            var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'dashboardinnerpanelgridpercentage',
                height:40,
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
                        text: 'Acknowledge',
                        id: 'addbuttonid',
                        cls: 'dashboarddetailsbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                 if(grid.getSelectionModel().getCount()<1){
    								ctsb.setStatus({
               						text: getMessageForStatus("No rows selected"),
               						iconCls: '',
               						clear: true
           							});
           							return;
       								}
       								else if(grid.getSelectionModel().getCount()<1){
    								ctsb.setStatus({
               						text: getMessageForStatus("Select one row"),
               						iconCls: '',
               						clear: true
           							});
           							return;
       								}
                                  myWin.show(); 
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: 'Back',
                        id: 'backbuttonid',
                        cls: 'dashboarddetailsbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                   window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/CVSStatusDashboard.jsp?cutomerIDPassed="+<%=clientID%>;
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
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: false,
                    cls: 'outerpanel',
                    items: [grid,buttonPanel],
                    bbar: ctsb
                });
                store.load({
                             params: {
                                      custID:<%=clientID%>,
                    				  alertId:<%=alertID%>,
                    				  jspName: jspName
                                        }
                                    });
            });
        </script>
    </body>

</html>