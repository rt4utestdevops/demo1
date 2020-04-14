<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
int customerId=loginInfo.getCustomerId();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
String clientID=request.getParameter("cutomerID");
String alertID=request.getParameter("AlertId");

boolean hide=false;
String alertName=request.getParameter("AlertName");
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
String NoRecordsFound;
lwb=(LanguageWordsBean)langConverted.get("No_Records_Found");
if(alertID.equals("66") || alertID.equals("67"))
{
hide=true;
}
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
        <jsp:include page="../Common/ImportJSCashVan.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
   		
   		<script>
    	google.load("visualization", "1", {packages:["corechart"]});
            var outerPanel;
            var dtprev = dateprev;
            var dtcur = datecur;
            var state="";
            var statename="";
            var hidecolumn=<%=hide%>;

             //****************************************Export Excel********************************* 
            var jspName = "CVSDashBoardDetails";
            var exportDataType = "int,string,string,number,number,number";


var barchartPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		title:'<%=alertName%>',
		border:false,
		frame:false,
		width:'100%',
		id:'barchartid',
		items: [
				{xtype:'label',
				id:'statutaryHeader',
				hidden:true,
				text:'Stautory Alert of Vehicles',
				width:'100%',
				cls:'dashboardpiechartheader'
				},{xtype:'panel',
				id:'barchartpiepannelid',
				border:false,
				html : '<table width="100%"><tr><tr> <td> <div id="visualization" align="left"> </div></td></tr></table>'
       }			  							
			]
		});
var statutorycountStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getStateWiseStatutoryCount',
				id:'StatutoryStateWiseCountId',
				root: 'StatutoryStateWiseCountRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['state','count']
		});			
//******************************************** Statutory BarChart**********************************************************		
function statutoryBarChart() {
    statutorycountStore.load({
        params: {
            typeofalert:<%=alertID%> ,
            clientId: <%=clientID%>
        },
        callback: function () {
            var options = {
                title: '<%=alertName%>',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 13
                },
                pieSliceText: "value",
                legend: {
                    position: 'bottom'
                },
                colors: ['#4572A7', '#93A9CF'],
                sliceVisibilityThreshold: 0,
                backgroundColor: '#E4E4E4',
                height: 200,
                //width:600,
                 bar: {groupWidth: "50%"},
                 vAxis: {
                            title: '',
                            viewWindow: {
                        min:0
                    },gridlines:{count:6},
                            titleTextStyle: {
                                italic: false,
                                fontSize: 13
                            }
                        },
               hAxis:{textStyle:{fontSize: 10},showTextEvery:1}
            };
           
          							
                   
            var statutorybargraph = new google.visualization.ColumnChart(document.getElementById('visualization'));
            var barchartdata = new google.visualization.DataTable();
            barchartdata.addColumn('string', 'Count');
            barchartdata.addColumn('number', 'States');
            barchartdata.addRows(statutorycountStore.getCount() + 1);
            var rowdata = new Array();
            // Belowis the Model for rowdata
            //barchartdata.setCell(0, 0, 'Kerala');
            //barchartdata.setCell(0, 1, 100);
            //barchartdata.setCell(1, 0, 'punjab');
            //barchartdata.setCell(1, 1, 25);
            for (i = 0; i < statutorycountStore.getCount(); i++) {
                var rec = statutorycountStore.getAt(i);
                rowdata.push(rec.data['state']);
                if(i==0)
                {
                statename=rec.data['state'];
                
                store.load({
                    params: {
                        custID: <%=clientID%> ,
                        alertId:<%=alertID%> ,
                        state:rec.data['state']
                    }
                });
                }
                rowdata.push(parseInt(rec.data['count']));
            }
            var k = 0;
            for (i = 0; i < statutorycountStore.getCount(); i++) {
                for (j = 0; j <= 1; j++) {
                    barchartdata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }

            statutorybargraph.draw(barchartdata, options);
           
            google.visualization.events.addListener(statutorybargraph, 'select', function () {
                var selection = statutorybargraph.getSelection();
                 for (var i = 0; i < selection.length; i++) {
               		state = barchartdata.getValue(selection[i].row, 0);
               		}
                store.load({
                    params: {
                        custID: <%=clientID%> ,
                        alertId:<%=alertID%> ,
                        state:state
                    }
                });
            });

        }
    });
}          //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'StatutoryStateWiseDetailsRoot',
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
                    url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getStatutoryDashboardDetails',
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
                    },{
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
                        width:70,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;>Group Name</span>",
                        dataIndex: 'groupname',
                        width:70,
                        filter: {
                            type: 'string'
                        }
                    },  {
                        header: "<span style=font-weight:bold;>Due Date</span>",
                        dataIndex: 'alertdate',
                        width:70,
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
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
                        width:70,
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

            var grid = getVerticalPlatFormGrid('', '<%=NoRecordsFound%>', store,screen.width-45,250, 9, filters,false, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, false, '<%=ClearGrouping%>', false, '', false, '', jspName, exportDataType, false, '');

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
													 typeofalert:<%=alertID%>,
													 clientId:<%=clientID%>
										        },
												success:function(response, options)//start of success
												{
													 myWin.hide();
											         setMsgBoxStatus(response.responseText);         
												     store.reload();
												     outerPanel.getEl().unmask();
												    
												}, // END OF  SUCCESS
											    failure: function()//start of failure 
											    {
											    	  setMsgBoxStatus("error");
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
                border:false,
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
    								setMsgBoxStatus("No rows selected");
           							return;
       								}
       								else if(grid.getSelectionModel().getCount()<1){
    								setMsgBoxStatus("Select one row");
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
                                //if(<%=customerId%>>0)
                                //{
                                //   window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/Dashboard.jsp";
                                //}
                                ///else
                                //{
                                   window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/Dashboard.jsp?cutomerIDPassed="+<%=clientID%>;
                               // }
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
                    //width:'99%',
                    cls: 'outerpanel',
                    items: [barchartPannel,grid,buttonPanel]
                });
                statutoryBarChart();
                 if(hidecolumn)
            {
            
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('VehicleNo'), true);
            grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupname'), true);
             
            }
            });
        </script>
    </body>

</html>