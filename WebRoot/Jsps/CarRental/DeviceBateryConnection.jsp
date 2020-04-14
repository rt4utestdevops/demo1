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
int customeridlogged=loginInfo.getCustomerId();
String alertID=request.getParameter("AlertId");
String alertName="";
alertName="Device And Battery Connection";
if(alertID.equals("-1"))
{
alertName="Immobilized Vehicles";

}
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
           Device And Battery Connection
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
            var jspName = "AlertReport";
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
            
            
            //********************************Action type combo******************************
            
     var actionTypeStore = new Ext.data.SimpleStore({
    id: 'actionTypeStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['All', 'All'],
        ['Actioned', 'Actioned'],
        ['Un-Actioned','Un-Actioned']
    ]
});

var actionTypeCombo = new Ext.form.ComboBox({
    store: actionTypeStore,
    id: 'actionTypeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Action Type',
    value : 'Un-Actioned',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
                    select: {
                        fn: function () {
                           var actiontyp=Ext.getCmp('actionTypeComboId').getValue();
                           if(actiontyp!='Un-Actioned')
                            {grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('Remarks'), false);
                            }
                            else
                            {grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('Remarks'), true);
                            }
                            store.load({
                             params: {
                    				  alertId:<%=alertID%>,
                    				  type: Ext.getCmp('actionTypeComboId').getValue()
                                        }
                                    });
                        }
                    }
                }
});
            
              //************************************* Inner panel start******************************************* 
            var innerPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                height:75,
                frame: true,
                //cls: 'innerpanelsmallestpercentage',
                id: 'custMaster',
                title:'<%=alertName%>',
                layout: 'table',
                layoutConfig: {
                    columns: 7
                },
                items: [
                    {
                        xtype: 'label',
                        text: 'Action Type' + '  :',
                        allowBlank: false,
                        hidden: false,
                        cls: 'labelstyle',
                        id: 'actionTypelab'
                    },actionTypeCombo
                ]
            }); // End of Panel	
            
           
  
 
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
					},{
                        name: 'Remarks', 
					},{
                        name: 'alertType', 
					}
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getDeviceBateryDetails',
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
                        dataIndex: 'alertdetails'
                    }, {
                        type: 'string',
                        dataIndex: 'vehicleNo'
                    }, {
                        type: 'string',
                        dataIndex: 'gmt'
                    }, {
                        type: 'string',
                        dataIndex: 'Remarks'
                    },
                    {
                        type: 'string',
                        dataIndex: 'alertType'
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
                        header: "<span style=font-weight:bold;>Alert</span>",
                        dataIndex: 'alertdetails',
                        width:250,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Remarks</span>",
                        dataIndex: 'Remarks',
                        width:100,
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Vehicle No</span>",
                        dataIndex: 'vehicleNo',
                        width:50,
                        //hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>GMT</span>",
                        dataIndex: 'gmt',
                       //  width:150,
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Alert SLNO</span>",
                        dataIndex: 'alertslno',
                      //   width:150,
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },
                    {
                        header: "<span style=font-weight:bold;>Alert Type</span>",
                        dataIndex: 'alertType',
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

            var grid = getVerticalPlatFormGrid('', '<%=NoRecordsFound%>', store,screen.width-30, 435, 9,filters, false, '', false, '', 10, false, '', false, '', false, '', jspName, exportDataType, false, '');

             //********************************************Grid Panel Config Ends********************************
             var innerPanel1 = new Ext.form.FormPanel({
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
	        		width: '102px',
	        		cls: 'buttonstyle',
                    iconCls: 'savebutton',
	       			listeners: 
	       			{
	        			click:
	        			{
	        			
	       					fn:function()
	       					{
	       					if(Ext.getCmp('remarksid').getValue()!=""){
	       						var selected = grid.getSelectionModel().getSelected();
								Ext.Ajax.request({
								 				url: '<%=request.getContextPath()%>/CarRentalAction.do?param=saveAlertRemarksForDevice',
												method: 'POST',
												params: 
												{
													 alertslno:selected.get('alertslno'),
													 
													 remark:Ext.getCmp('remarksid').getValue(),
													 regno:selected.get('vehicleNo'),
													 GMT:selected.get('gmt'),
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
						      else {
						        setMsgBoxStatus('Please enter Remarks');
						          }
							}
						}
	       			}
	       		},{
	       			xtype:'button',
	      			text:'Cancel',
	        		id:'cancelButtId',
	        		width: '102px',
	        		cls: 'buttonstyle',
                    iconCls: 'cancelbutton',
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
        	 items  : [innerPanel1]
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
                        iconCls: 'savebutton',
                        cls: 'buttonstyle',
                        listeners: {
                            click: {
                                fn: function () {
                                 if(grid.getSelectionModel().getCount()<1){
    								setMsgBoxStatus('No Row Selected');
           							return;
       								}
       								else if(grid.getSelectionModel().getCount()>1){
    								setMsgBoxStatus('Select one Row');
           							return;
       								}
       								Ext.getCmp('remarksid').setValue("");
                                  myWin.show(); 
                                }
                            }
                        }
                    },
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
                    items: [innerPanel,grid,buttonPanel]

                });
                store.load({
                             params: {
                    				  alertId:<%=alertID%>,
                    				  jspName: jspName,
                    				  type: 'Un-Actioned' 
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
