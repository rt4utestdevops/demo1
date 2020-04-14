<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session
			.getAttribute("loginInfoDetails"), session, request,
			response);
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	//getting language
	String language = loginInfo.getLanguage();
	int systemid = loginInfo.getSystemId();
	String systemID = Integer.toString(systemid);
	//getting hashmap with language specific words
	HashMap langConverted = ApplicationListener.langConverted;
	LanguageWordsBean lwb = null;
	int customeridlogged = loginInfo.getCustomerId();
	//Getting words based on language 
	String selectCustomer;
	lwb = (LanguageWordsBean) langConverted.get("Select_Customer");
	if (language.equals("ar")) {
		selectCustomer = lwb.getArabicWord();
	} else {
		selectCustomer = lwb.getEnglishWord();
	}
	lwb = null;
	String SLNO;
	lwb = (LanguageWordsBean) langConverted.get("SLNO");
	if (language.equals("ar")) {
		SLNO = lwb.getArabicWord();
	} else {
		SLNO = lwb.getEnglishWord();
	}
	lwb = null;
	String CustomerName;
	lwb = (LanguageWordsBean) langConverted.get("Customer_Name");
	if (language.equals("ar")) {
		CustomerName = lwb.getArabicWord();
	} else {
		CustomerName = lwb.getEnglishWord();
	}
	lwb = null;

	String RMC_Plant_Association;
	lwb = (LanguageWordsBean) langConverted
			.get("RMC_Plant_Association");
	if (language.equals("ar")) {
		RMC_Plant_Association = lwb.getArabicWord();
	} else {
		RMC_Plant_Association = lwb.getEnglishWord();
	}
	lwb = null;

	String submit;
	lwb = (LanguageWordsBean) langConverted.get("Submit");
	if (language.equals("ar")) {
		submit = lwb.getArabicWord();
	} else {
		submit = lwb.getEnglishWord();
	}
	lwb = null;

	String closeTrip;
	lwb = (LanguageWordsBean) langConverted.get("Close_Trip");
	if (language.equals("ar")) {
		closeTrip = lwb.getArabicWord();
	} else {
		closeTrip = lwb.getEnglishWord();
	}
	lwb = null;

	String reset;
	lwb = (LanguageWordsBean) langConverted.get("Reset");
	if (language.equals("ar")) {
		reset = lwb.getArabicWord();
	} else {
		reset = lwb.getEnglishWord();
	}
	lwb = null;

	String wantToDelete;
	lwb = (LanguageWordsBean) langConverted
			.get("Are_you_sure_you_want_to_delete");
	if (language.equals("ar")) {
		wantToDelete = lwb.getArabicWord();
	} else {
		wantToDelete = lwb.getEnglishWord();
	}
	lwb = null;

	String custNotDeleted;
	lwb = (LanguageWordsBean) langConverted.get("Vehicle_not_deleted");
	if (language.equals("ar")) {
		custNotDeleted = lwb.getArabicWord();
	} else {
		custNotDeleted = lwb.getEnglishWord();
	}
	lwb = null;

	String vehicleNo;
	lwb = (LanguageWordsBean) langConverted.get("Registration_No");
	if (language.equals("ar")) {
		vehicleNo = lwb.getArabicWord();
	} else {
		vehicleNo = lwb.getEnglishWord();
	}
	lwb = null;

	String status;
	lwb = (LanguageWordsBean) langConverted.get("Status");
	if (language.equals("ar")) {
		status = lwb.getArabicWord();
	} else {
		status = lwb.getEnglishWord();
	}
	lwb = null;

	String NoRecordsFound;
	lwb = (LanguageWordsBean) langConverted.get("No_Records_Found");
	if (language.equals("ar")) {
		NoRecordsFound = lwb.getArabicWord();
	} else {
		NoRecordsFound = lwb.getEnglishWord();
	}
	lwb = null;

	String ClearFilterData;
	lwb = (LanguageWordsBean) langConverted.get("Clear_Filter_Data");
	if (language.equals("ar")) {
		ClearFilterData = lwb.getArabicWord();
	} else {
		ClearFilterData = lwb.getEnglishWord();
	}
	lwb = null;
	String ReconfigureGrid;
	lwb = (LanguageWordsBean) langConverted.get("Reconfigure_Grid");
	if (language.equals("ar")) {
		ReconfigureGrid = lwb.getArabicWord();
	} else {
		ReconfigureGrid = lwb.getEnglishWord();
	}
	lwb = null;
	String ClearGrouping;
	lwb = (LanguageWordsBean) langConverted.get("Clear_Grouping");
	if (language.equals("ar")) {
		ClearGrouping = lwb.getArabicWord();
	} else {
		ClearGrouping = lwb.getEnglishWord();
	}
	lwb = null;

	String error;
	lwb = (LanguageWordsBean) langConverted.get("Error");
	if (language.equals("ar")) {
		error = lwb.getArabicWord();
	} else {
		error = lwb.getEnglishWord();
	}
	lwb = null;

	String deleting;
	lwb = (LanguageWordsBean) langConverted.get("Deleting");
	if (language.equals("ar")) {
		deleting = lwb.getArabicWord();
	} else {
		deleting = lwb.getEnglishWord();
	}
	lwb = null;

	String selectVehicle;
	lwb = (LanguageWordsBean) langConverted.get("Sel_Reg_No");
	if (language.equals("ar")) {
		selectVehicle = lwb.getArabicWord();
	} else {
		selectVehicle = lwb.getEnglishWord();
	}
	lwb = null;

	String plants;
	lwb = (LanguageWordsBean) langConverted.get("Plants");
	if (language.equals("ar")) {
		plants = lwb.getArabicWord();
	} else {
		plants = lwb.getEnglishWord();
	}
	lwb = null;

	String selectPlant;
	lwb = (LanguageWordsBean) langConverted.get("Select_Plant");
	if (language.equals("ar")) {
		selectPlant = lwb.getArabicWord();
	} else {
		selectPlant = lwb.getEnglishWord();
	}
	lwb = null;

	String selectStatus;
	lwb = (LanguageWordsBean) langConverted.get("Select_Status");
	if (language.equals("ar")) {
		selectStatus = lwb.getArabicWord();
	} else {
		selectStatus = lwb.getEnglishWord();
	}
	lwb = null;

	String selectSingleRow;
	lwb = (LanguageWordsBean) langConverted.get("Select_Single_Row");
	if (language.equals("ar")) {
		selectSingleRow = lwb.getArabicWord();
	} else {
		selectSingleRow = lwb.getEnglishWord();
	}
	lwb = null;

	String ModifyRMCPlantAssociation;
	lwb = (LanguageWordsBean) langConverted
			.get("Modify_RMC_Plant_Association");
	if (language.equals("ar")) {
		ModifyRMCPlantAssociation = lwb.getArabicWord();
	} else {
		ModifyRMCPlantAssociation = lwb.getEnglishWord();
	}
	lwb = null;

	String AddRMCPlantAssociation;
	lwb = (LanguageWordsBean) langConverted
			.get("Add_RMC_Plant_Association");
	if (language.equals("ar")) {
		AddRMCPlantAssociation = lwb.getArabicWord();
	} else {
		AddRMCPlantAssociation = lwb.getEnglishWord();
	}
	lwb = null;

	String Validate_Mesg_For_Form;
	lwb = (LanguageWordsBean) langConverted
			.get("Validate_Mesg_For_Form");
	if (language.equals("ar")) {
		Validate_Mesg_For_Form = lwb.getArabicWord();
	} else {
		Validate_Mesg_For_Form = lwb.getEnglishWord();
	}
	lwb = null;

	String Save;
	lwb = (LanguageWordsBean) langConverted.get("Save");
	if (language.equals("ar")) {
		Save = lwb.getArabicWord();
	} else {
		Save = lwb.getEnglishWord();
	}
	lwb = null;

	String Cancel;
	lwb = (LanguageWordsBean) langConverted.get("Cancel");
	if (language.equals("ar")) {
		Cancel = lwb.getArabicWord();
	} else {
		Cancel = lwb.getEnglishWord();
	}
	lwb = null;
	langConverted = null;
%>

<!DOCTYPE HTML>
<html>
    
    <head>
        <title>
            <%=RMC_Plant_Association%>
        </title>

    </head>
    
    <body height="100%" onload="refresh();">
		<%
			if (loginInfo.getStyleSheetOverride().equals("Y")) {
		%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		
		<%
			} else {
		%>
		<jsp:include page="../Common/ImportJS.jsp" />
		
		<%
			}
		%>
		<style>
			.x-toolbar-ct {
				width: 98.5% !important;
			}
			.ext-strict .x-form-text {
				height: 15px !important;
			}
		</style>
		<script>
            var outerPanel;
            var ctsb;
            var panel1;
            var hubid = 0;
            var selected;
 			var userGrid;
 			var buttonValue = "";
 			var titel;
 			var myWin;
 			
            //In chrome activate was slow so refreshing the page
 function refresh()
                 {
                 isChrome = window.chrome;
					if(isChrome && parent.flagRMC<2) {
					// is chrome
						              setTimeout(function(){
						              parent.Ext.getCmp('rmcplantassoctab').enable();
									  parent.Ext.getCmp('rmcplantassoctab').show();
						              parent.Ext.getCmp('rmcplantassoctab').update("<iframe style='width:100%;height:600px;border:0;' src='<%=path%>/Jsps/RMC/RMCPlantAssociation.jsp'></iframe>");
						              },0);
						              parent.RMCTab.doLayout();
						              parent.flagRMC= parent.flagRMC+1;
					} 
                 }
                 /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				 var width = '99%';
			    var height = '100%';
			userGrid.setSize(width, height);
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
			});
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
                        if ( <%=customeridlogged%> > 0) {
                            Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                            Ext.getCmp('plantid').reset();
                            Ext.getCmp('status').reset();
                            Ext.getCmp('plantid').show();
                            Ext.getCmp('plantname').hide();
                            store.load({
                                params: {
                                    custID: <%=customeridlogged%>
                                },callback:function(){
                                			userGrid.getSelectionModel().deselectRow(0);     
                                			}
                            });
                            hubcombostore.load({
                                params: {
                                    CustId: <%=customeridlogged%>
                                }
                            });
                        }
                    }
                }
            });

             //**************************** Combo for Customer Name***************************************************
            var custnamecombo = new Ext.form.ComboBox({
                store: custmastcombostore,
                id: 'custmastcomboId',
                mode: 'local',
                hidden: false,
                resizable: true,
                forceSelection: true,
                emptyText: '<%=selectCustomer%>',
                blankText: '<%=selectCustomer%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'CustId',
                displayField: 'CustName',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {
                            Ext.getCmp('plantid').reset();
                            Ext.getCmp('status').reset();
                            Ext.getCmp('plantid').show();
                            Ext.getCmp('plantname').hide();
                            store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue()
                                },callback:function(){
                                			userGrid.getSelectionModel().deselectRow(0);     
                                			}
                            });
                            hubcombostore.load({
                                params: {
                                    CustId: Ext.getCmp('custmastcomboId').getValue()
                                }
                            });
                        }
                    }
                }
            });
            
            var hubcombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/RMCAction.do?param=getHubs',
                id: 'HubStoreId',
                root: 'HubRoot',
                autoLoad: false,
                remoteSort: true,
                fields: ['HubId', 'HubName']
            });
            
            var plantcombo = new Ext.form.ComboBox({
                store: hubcombostore,
                id: 'plantid',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=selectPlant%>',
                blankText: '<%=selectPlant%>',
                selectOnFocus: true,
                allowBlank: false,
                anyMatch: true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'HubId',
                displayField: 'HubName',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });
            
            var planttext = new Ext.form.TextField({
                id: 'plantname',
                mode: 'local',
                disabled: true,
                triggerAction: 'all',
                lazyRender: true,
                cls: 'textrnumberstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });
            
             //store for status
            var statuscombostore = new Ext.data.SimpleStore({
                id: 'statuscombostoreId',
                autoLoad: true,
                fields: ['Name', 'Value'],
                data: [
                    ['Active', 'Active'],
                    ['Inactive', 'Inactive']
                ]
            });
            var statuscombo = new Ext.form.ComboBox({
                store: statuscombostore,
                id: 'status',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=selectStatus%>',
                blankText: '<%=selectStatus%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'Value',
                displayField: 'Value',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });
            //********************************************* Inner Pannel **************************************************************************************
		    var innerPanel = new Ext.form.FormPanel({
		        standardSubmit: true,
		        collapsible: false,
		        autoScroll: false,
		        height: 220,
		        width: '100%',
		        frame: true,
		        id: 'custMaster',
		        layout: 'table',
		        layoutConfig: {
		            columns: 3
		        },
		        items: [
		            {
		                cls: 'mandatoryfield'
		            },{
		                cls: 'labelstyle'
		            }, {
		                cls: 'labelstyle'
		            },
		            {
		            	xtype:'label',
		            	text:'*',
		            	cls:'mandatoryfield',
		            	id:'mandatoryplantcombo'
		            }, 
					{
		                xtype: 'label',
		                text: '<%=plants%>'+' :',
		                cls: 'labelstyle',
		                id: 'plantcombolab'
		            },plantcombo,
		            {
		            	xtype:'label',
		            	text:'*',
		            	cls:'mandatoryfield',
		            	id:'mandatoryplanttext'
		            },
		            {
		                xtype: 'label',
		                text: '<%=plants%>'+' :',
		                cls: 'labelstyle',
		                id: 'planttextlab'
		            }, 
		            planttext,
		            {
		                xtype:'label',
		            	text:'*',
		            	cls: 'mandatoryfield',
		            	id:'mandatorystatus'
		            },{
		                xtype: 'label',
		                text: '<%=status%>'+' :',
		                cls: 'labelstyle',
		                id: 'statuslab'
		              },statuscombo,
		             {
		                cls: 'mandatoryfield'
		            },{
		                cls: 'labelstyle'
		            }, {
		                cls: 'labelstyle'
		            }
		        ]
		    });
		 
			/****************window static button panel****************************/	    		 
			    var winButtonPanel=new Ext.Panel({
		        	id: 'winbuttonid',
		        	standardSubmit: true,
					collapsible:false,
					autoHeight: true,
        			height: 50,
        			width: '100%',
					frame:true,
					layout:'table',
					layoutConfig: {
						columns:2
					},
					buttons:[
					{
	       			xtype:'button',
	      			text:'<%=Save%>',
	        		id:'addButtId',
	        		iconCls:'savebutton',
	        		cls:'buttonstyle',
	        		width:80,
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	       					if(buttonValue == "add"){
			                    if (Ext.getCmp('plantid').getValue() == "") {
			                      Ext.example.msg("<%=selectPlant%>");
                        Ext.getCmp('plantid').focus();
                        return;
                    }
                    }
                    else{
						var selected = userGrid.getSelectionModel().getSelected();
			  			hubid=selected.get('plantid');
		   	  			
                    }
                    if (Ext.getCmp('status').getValue() == "") {
                        Ext.example.msg("<%=selectStatus%>");
                        Ext.getCmp('status').focus();
                        return;
                    }
   			Ext.Ajax.request({
	                        url: '<%=request.getContextPath()%>/RMCAction.do?param=saveRMCPlantAssociation',
	                        method: 'POST',
	                        params: {
	                            custmastcomboId: Ext.getCmp('custmastcomboId').getValue(),
	                            buttonvalue: buttonValue,
	                            plantid: Ext.getCmp('plantid').getValue(),
	                            status: Ext.getCmp('status').getValue(),
	                            hubid: hubid
	                        },
	                        success: function (response, options) //start of success
	                        {
	                            Ext.getCmp('plantid').reset();
	                            Ext.getCmp('status').reset();
	                            Ext.getCmp('plantid').show();
	                            Ext.getCmp('plantname').hide();
	                            Ext.example.msg(response.responseText);
	                            Ext.getCmp('plantid').show();
	                            Ext.getCmp('plantname').hide();
	                            custmastcombostore.reload();
	                            store.reload();
	                            hubcombostore.reload();
	                            userGrid.getView().refresh();
	                            outerPanel.getEl().unmask();
	                            myWin.hide();
	                        }, // END OF  SUCCESS
	                        failure: function () //start of failure 
	                        {
	                            Ext.example.msg("<%=error%>");
	                            closereportflag = false;
	                            custmastcombostore.reload();
								myWin.hide();
	                            outerPanel.getEl().unmask();
	                        } // END OF FAILURE 
	                    }); // END OF AJAX

	       					
	       					}}}
	       		},
	       		{
	       			xtype:'button',
	      			text:'<%=Cancel%>',
	        		id:'canButtId',
	        		cls:'buttonstyle',
	        		iconCls:'cancelbutton',
	        		width:'80',
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	       					myWin.hide();	       					
	       					}}}
	       		}
					]
		           
		    }); 
			/***********panel contains window content info***************************/
			var outerPanelWindow=new Ext.Panel({
			width: '100%',
        	height:290,
			standardSubmit: true,
			frame:false,
			items: [innerPanel, winButtonPanel]
			}); 
			/***********************window for form field****************************/	
			myWin = new Ext.Window({
			        title:titel,
			        closable: false,
			        modal: true,
			        resizable:true,
			        autoScroll: false,
			        height: 320,
        			width: '40%',	
			        id     : 'myWin',
			        items  : [outerPanelWindow]
			    });
			    
			 
		    
             //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'GridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'plantid'
                    }, {
                        name: 'plantname'
                    }, {
                        name: 'status'
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/RMCAction.do?param=getGridRMCPlantAssociationAction',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'plantid',
                    direction: 'ASC'
                },
                storeId: 'gridStore',
                reader: reader
            });
            store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    custID: Ext.getCmp('custmastcomboId').getValue()
                };
            }, this);

            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        dataIndex: 'plantid',
                        type: 'string'
                    }, {
                        type: 'string',
                        dataIndex: 'plantname'
                    }, {
                        type: 'string',
                        dataIndex: 'status'
                    }
                ]
            });

             //************************************ Store for getting Hub Name **************************	

            

             //************************************* Inner panel start******************************************* 
            var innertopPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'innerpanelsmallestpercentage',
                id: 'custMaster',
                layout: 'table',
                layoutConfig: {
                    columns: 3
                },
                items: [{
                        cls: 'labelstyle'
                    }, {
                        xtype: 'label',
                        text: '<%=CustomerName%>' + '  :',
                        allowBlank: false,
                        hidden: false,
                        cls: 'labelstyle',
                        id: 'custnamhidlab'
                    },
                    custnamecombo, {
                        cls: 'labelstyle'
                    }
                ]
            }); // End of Panel	

             //**************************** Grid Pannel Config ******************************************

            var createColModel = function (finish, start) {
                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 50
                    }), {
                        header: "<span style=font-weight:bold;><%=plants%></span>",
                        dataIndex: 'plantname',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=status%></span>",
                        dataIndex: 'status',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>PlantID</span>",
                        dataIndex: 'plantid',
                        hidden: true,
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

             //**************************** Grid Panel Config ends here**********************************
            userGrid = getGrid('<%=RMC_Plant_Association%>', '<%=NoRecordsFound%>', store, screen.width-37, 410, 4, filters, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', false, '', '', '', false, '',true,'Add',true,'Modify', false, '');

            
            //modify the data
			 function modifyData(){
			  if(Ext.getCmp('custmastcomboId').getValue() == ""){
			    Ext.example.msg("<%=selectCustomer%>");
			    return;
			 }
			  if(userGrid.getSelectionModel().getCount()==0){
			                            Ext.example.msg("<%=selectSingleRow%>");
			           					return;
			       						}
			      if(userGrid.getSelectionModel().getCount()>1){
			                            Ext.example.msg("<%=selectSingleRow%>");
			           					return;
			       						}
			  buttonValue="modify";
			  titel="<%=ModifyRMCPlantAssociation%>"
			  myWin.setTitle(titel);
			  
			  Ext.getCmp('mandatoryplantcombo').hide();
			  Ext.getCmp('plantcombolab').hide();
			  Ext.getCmp('plantid').hide();
			  Ext.getCmp('mandatoryplanttext').hide();
			  Ext.getCmp('planttextlab').show();
			  Ext.getCmp('plantname').show();
			  Ext.getCmp('mandatorystatus').show();
			  Ext.getCmp('statuslab').show();
			  Ext.getCmp('status').show();
			 
			  myWin.show();
			  var selected = userGrid.getSelectionModel().getSelected();
			  Ext.getCmp('plantname').setValue(selected.get('plantname'));
		   	  Ext.getCmp('status').setValue(selected.get('status'));
			 }
			 
			 //function for add button in grid that will open form window
			 function addRecord(){
			 if(Ext.getCmp('custmastcomboId').getValue() == ""){
			    Ext.example.msg("<%=selectCustomer%>");
			    return;
			 }
			 buttonValue="add";
			 titel='<%=AddRMCPlantAssociation%>';
			 myWin.show();
			 myWin.setTitle(titel);
			 Ext.getCmp('mandatoryplantcombo').show();
			 Ext.getCmp('plantcombolab').show();
			 Ext.getCmp('plantid').show();
			 Ext.getCmp('plantid').reset();
			 Ext.getCmp('mandatorystatus').show();
			 Ext.getCmp('statuslab').show();
			 Ext.getCmp('status').show();
			 Ext.getCmp('mandatoryplanttext').hide();
			 Ext.getCmp('planttextlab').hide();
			 Ext.getCmp('plantname').hide();
			 }
			 
             //**************************** Grid Panel Config ends here**********************************
             
             //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                ctsb = tsb;
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    title: '<%=RMC_Plant_Association%>',
                    renderTo: 'content',
                    standardSubmit: true,
					frame: true,
                    cls: 'outerpanel',
                    items: [innertopPanel, userGrid]
                });


            });
        </script>
    </body>

</html>
