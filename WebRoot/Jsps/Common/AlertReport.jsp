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
 alertName=cf.getLabelFromDB(alertName.trim().replace(" ","_"),language);
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

 <jsp:include page="../Common/header.jsp" />
    
  <!--  <body class="largebody"> -->
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			.x-layer ul {
		 	min-height:24px !important;
		}
		</style>
        <script>
        Ext.Ajax.timeout = 360000;
            var outerPanel;
            var dtprev = dateprev;
            var dtcur = datecur;

             //****************************************Export Excel********************************* 
            var jspName = "AlertReport";
            var exportDataType = "int,string,string,number,number,number";
             //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'AlertDetailsRoot',
                totalProperty: 'total',
                fields: [{name:'alertslno'
                	}, {
                        name: 'alertdetails'
                    },{
                    	name:'vehicleNo',
                    },{
                        name: 'gmt', 
					}
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/AlertComponent.do?param=getAlertDetails',
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
                        type: 'int',
                        dataIndex: 'alertslno'
                    }, {
                        type: 'string',
                        dataIndex: 'alertdetails'
                    }, {
                        type: 'string',
                        dataIndex: 'vehicleNo'
                    }, {
                        type: 'string',
                        dataIndex: 'gmt'
                    }
                ]
            });

             //************************************Column Model Config******************************************
            var createColModel = function (finish, start) {

                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;>SLNO</span>",
                        width: 50
                    }),{
                        header: "<span style=font-weight:bold;>Alert</span>",
                        dataIndex: 'alertdetails',
                        width:250,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>VehicleNo</span>",
                        dataIndex: 'vehicleNo',
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>GMT</span>",
                        dataIndex: 'gmt',
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Alert SLNO</span>",
                        dataIndex: 'alertslno',
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

            var grid = getVerticalPlatFormGrid('<%=alert%> > <%=alertName%>', '<%=NoRecordsFound%>', store,screen.width-30, 500, 9,filters, false, '', false, '', 10, false, '', false, '', false, '', jspName, exportDataType, false, '');

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
								 				url: '<%=request.getContextPath()%>/AlertComponent.do?param=saveAlertRemarks',
												method: 'POST',
												params: 
												{
													 alertslno:selected.get('alertslno'),
													 remark:Ext.getCmp('remarksid').getValue(),
													 regno:selected.get('vehicleNo'),
													 GMT:selected.get('gmt'),
													 typeofalert:<%=alertID%>
										        },
												success:function(response, options)//start of success
												{
													 myWin.hide();
											         setMsgBoxStatus('Acknowledgment Successfull');
												      	store.reload();
												       outerPanel.getEl().unmask();
												    
												}, // END OF  SUCCESS
											    failure: function()//start of failure 
											    {
											    	  setMsgBoxStatus('Error ! ');
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
                        text: 'Acknowledge',
                        id: 'addbuttonid',
                        cls: 'dashboarddetailsbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                 if(grid.getSelectionModel().getCount()<1){
    								setMsgBoxStatus('No Row Selected');
           							return;
       								}
       								else if(grid.getSelectionModel().getCount()<1){
    								setMsgBoxStatus('Select one Row');
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
                                   window.location ="<%=request.getContextPath()%>/Jsps/Common/Alert.jsp";
                                }
                            }
                        }
                    }
                ]
            }); // End of Panel	
            
            var startdate = new Ext.form.DateField({
            fieldLabel: 'Start Date',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: 'Select Start Date',
            allowBlank: false,
            blankText: 'Start Date',
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'startdate',
            value: dtprev,
            maxValue: dtprev,
            vtype: 'daterange',
            endDateField: 'enddate'

        });




        var enddate = new Ext.form.DateField({
            fieldLabel: 'End Date',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: 'Select End Date',
            allowBlank: false,
            blankText: 'Select End Date',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'enddate',
            value: dtcur,
            maxValue: dtcur,
            vtype: 'daterange',
            startDateField: 'startdate'
        });

            
            
            var datePanel = new Ext.Panel({
            frame: false,
            layout: 'table',
            layoutConfig: {
                columns: 7
            },
            items: [ 
                    {
                    xtype: 'label',
                    text: 'Start Date' + ':',
                    width: 20,
                    cls: 'labelstyle'

                },
                startdate,{
                        width: 20,
                        height: 10
                    },

                {
                    xtype: 'label',
                    text: 'End Date' + ':',
                    width: 20,
                    cls: 'labelstyle'
                },
                enddate, {
                        width: 20,
                        height: 10
                    },
                 {
	       			xtype:'button',
	      			text:'Submit',
	        		id:'submitButtId',
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
	       			} 
            ]
        });
            
            
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
     <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
