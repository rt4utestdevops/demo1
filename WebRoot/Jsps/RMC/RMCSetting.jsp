<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
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

	String RMC_Setting;
	lwb = (LanguageWordsBean) langConverted.get("RMC_Setting");
	if (language.equals("ar")) {
		RMC_Setting = lwb.getArabicWord();
	} else {
		RMC_Setting = lwb.getEnglishWord();
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

	String loading;
	lwb = (LanguageWordsBean) langConverted.get("Mixing");
	if (language.equals("ar")) {
		loading = lwb.getArabicWord();
	} else {
		loading = lwb.getEnglishWord();
	}
	lwb = null;

	String unloading;
	lwb = (LanguageWordsBean) langConverted.get("Discharging");
	if (language.equals("ar")) {
		unloading = lwb.getArabicWord();
	} else {
		unloading = lwb.getEnglishWord();
	}
	lwb = null;

	String reset = "Reset";
	lwb = (LanguageWordsBean) langConverted.get("Reset");
	if (language.equals("ar")) {
		reset = lwb.getArabicWord();
	} else {
		reset = lwb.getEnglishWord();
	}
	lwb = null;

	String delete;
	lwb = (LanguageWordsBean) langConverted.get("Delete");
	if (language.equals("ar")) {
		delete = lwb.getArabicWord();
	} else {
		delete = lwb.getEnglishWord();
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

	String NoRecordsFound = "No_Records_Found";
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

	String selectLoading;
	lwb = (LanguageWordsBean) langConverted.get("Select_Mixing");
	if (language.equals("ar")) {
		selectLoading = lwb.getArabicWord();
	} else {
		selectLoading = lwb.getEnglishWord();
	}
	lwb = null;

	String selectUnloading;
	lwb = (LanguageWordsBean) langConverted.get("Select_Unloading");
	if (language.equals("ar")) {
		selectUnloading = lwb.getArabicWord();
	} else {
		selectUnloading = lwb.getEnglishWord();
	}
	lwb = null;

	String sameLoadingUnloading;
	lwb = (LanguageWordsBean) langConverted
			.get("Same_Loading_Unloading");
	if (language.equals("ar")) {
		sameLoadingUnloading = lwb.getArabicWord();
	} else {
		sameLoadingUnloading = lwb.getEnglishWord();
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

	String AddRMCSetting;
	lwb = (LanguageWordsBean) langConverted.get("Add_RMC_Setting");
	if (language.equals("ar")) {
		AddRMCSetting = lwb.getArabicWord();
	} else {
		AddRMCSetting = lwb.getEnglishWord();
	}
	lwb = null;

	String ModifyRMCSetting;
	lwb = (LanguageWordsBean) langConverted.get("Modify_RMC_Setting");
	if (language.equals("ar")) {
		ModifyRMCSetting = lwb.getArabicWord();
	} else {
		ModifyRMCSetting = lwb.getEnglishWord();
	}
	lwb = null;

	String save;
	lwb = (LanguageWordsBean) langConverted.get("Save");
	if (language.equals("ar")) {
		save = lwb.getArabicWord();
	} else {
		save = lwb.getEnglishWord();
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
            <%=RMC_Setting%>
        </title>
    </head>
    
    <body height="100%">
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
			
			.ext-strict .x-form-text {
				height: 15px !important;
			}
		</style>
		<script>
            var outerPanel;
            var ctsb;
            var panel1;
            var userGrid;
 			var buttonValue = "";
 			var titel;
 			var myWin;
             /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				 var width = '100%';
			    var height = '100%';
			userGrid.setSize(width, height);
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
			});
             //******************************store for getting customer name************************
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
                            Ext.getCmp('vehicleno').reset();
                            Ext.getCmp('loadingid').reset();
                            Ext.getCmp('unloadingid').reset();

                            store.load({
                                params: {
                                    custID: <%=customeridlogged%>
                                },callback:function(){
                                userGrid.getSelectionModel().deselectRow(0);     
                                }
                            });
                            vehiclestore.load({
                                params: {
                                    CustId: <%=customeridlogged%> ,
                                    LTSPId: <%=systemID%>
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
                            Ext.getCmp('vehicleno').reset();
                            Ext.getCmp('loadingid').reset();
                            Ext.getCmp('unloadingid').reset();
                            store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue()
                                },callback:function(){
                                userGrid.getSelectionModel().deselectRow(0);     
                                }
                            });
                            vehiclestore.load({
                                params: {
                                    CustId: Ext.getCmp('custmastcomboId').getValue(),
                                    LTSPId: <%=systemID%>
                                }
                            });
                        }
                    }
                }
            });
            
             //************************************ Vehicle Store************************************************
            var vehiclestore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/RMCAction.do?param=getVehicleDetails',
                id: 'VehicleStoreId',
                root: 'VehicleRoot',
                autoLoad: false,
                remoteSort: true,
                fields: ['VehicleNo', 'IMEINo', 'DeviceType', 'VehicleAlias']
            });
            
            var vehiclescombo = new Ext.form.ComboBox({
                store: vehiclestore,
                id: 'vehicleno',
                mode: 'local',
                hidden: false,
                resizable: true,
                forceSelection: true,
                emptyText: '<%=selectVehicle%>',
                blankText: '<%=selectVehicle%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'VehicleNo',
                displayField: 'VehicleNo',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });

            var eventcombostore = new Ext.data.SimpleStore({
                id: 'loadingcombostoreId',
                autoLoad: true,
                fields: ['Name', 'loadingid'],
                data: [
                    ['EVENTA', 'EVENTA'],
                    ['EVENTB', 'EVENTB']
                ]
            });
            var loadingcombo = new Ext.form.ComboBox({
                store: eventcombostore,
                id: 'loadingid',
                mode: 'local',
                hidden: false,
                resizable: true,
                forceSelection: true,
                emptyText: '',
                blankText: '<%=selectLoading%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'loadingid',
                displayField: 'loadingid',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });

            var unloadingcombo = new Ext.form.ComboBox({
                store: eventcombostore,
                id: 'unloadingid',
                mode: 'local',
                hidden: false,
                resizable: true,
                forceSelection: true,
                emptyText: '',
                blankText: '<%=selectUnloading%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'loadingid',
                displayField: 'loadingid',
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
		            },{
		            	xtype:'label',
		            	text:'*',
		            	cls:'mandatoryfield',
		            	id:'mandatoryvehicleno'
		            }, 
					{
		                xtype: 'label',
		                text: '<%=vehicleNo%>'+' :',
		                cls: 'labelstyle',
		                id: 'vehiclenolab'
		            },vehiclescombo,
		            {
		            	xtype:'label',
		            	text:'*',
		            	cls:'mandatoryfield',
		            	id:'mandatoryloading'
		            },
		            {
		                xtype: 'label',
		                text: '<%=loading%>'+' :',
		                cls: 'labelstyle',
		                id: 'loadinglab'
		            }, 
		            loadingcombo,
		            {
		                xtype:'label',
		            	text:'*',
		            	cls: 'mandatoryfield',
		            	id:'mandatoryunloading'
		            },{
		                xtype: 'label',
		                text: '<%=unloading%>'+' :',
		                cls: 'labelstyle',
		                id: 'unloadinglab'
		              },unloadingcombo,
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
	      			text:'<%=save%>',
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
				       			if (Ext.getCmp('vehicleno').getValue() == "") {
				       			    Ext.example.msg("<%=selectVehicle%>");
			                        Ext.getCmp('vehicleno').focus();
			                        return;
			                    }
			                    if (Ext.getCmp('loadingid').getValue() == "") {
			                        Ext.example.msg("<%=selectLoading%>");
			                        Ext.getCmp('loadingid').focus();
			                        return;
			                    }
			                    if (Ext.getCmp('unloadingid').getValue() == "") {
			                        Ext.example.msg("<%=selectUnloading%>");
			                        Ext.getCmp('unloadingid').focus();
			                        return;
			                    }
			                    if (Ext.getCmp('loadingid').getValue() == Ext.getCmp('unloadingid').getValue()) {
			                        Ext.example.msg("<%=sameLoadingUnloading%>");
			                        Ext.getCmp('unloadingid').focus();
			                        return;
			                    }
			                    outerPanel.getEl().mask();
			                    Ext.Ajax.request({
			                        url: '<%=request.getContextPath()%>/RMCAction.do?param=saveormodifyRMCSetting',
			                        method: 'POST',
			                        params: {
			                            buttonvalue: buttonValue,
			                            custID: Ext.getCmp('custmastcomboId').getValue(),
			                            vehicleno: Ext.getCmp('vehicleno').getValue(),
			                            loading: Ext.getCmp('loadingid').getValue(),
			                            unloading: Ext.getCmp('unloadingid').getValue()
			                        },
			                        success: function (response, options) //start of success
			                        {
			                            vehiclestore.load({
			                                params: {
			                                    CustId: Ext.getCmp('custmastcomboId').getValue(),
			                                    LTSPId: <%=systemID%>
			                                }
			                            });
			                            Ext.getCmp('vehicleno').reset();
			                            Ext.getCmp('loadingid').reset();
			                            Ext.getCmp('unloadingid').reset();
			                            Ext.example.msg(response.responseText);
			                            custmastcombostore.reload();
			                            store.load({
			                                params: {
			                                    custID: Ext.getCmp('custmastcomboId').getValue()
			                                },callback:function(){
			                                userGrid.getSelectionModel().deselectRow(0);     
			                                }
			                            });
			                            userGrid.getView().refresh();
			                            outerPanel.getEl().unmask();
			                            myWin.hide();
			                        }, // END OF  SUCCESS
			                        failure: function () //start of failure 
			                        {
			                            Ext.example.msg("<%=error%>");
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
			        height: 316,
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
                        name: 'vehicleno'
                    }, {
                        name: 'loadingid'
                    }, {
                        name: 'unloadingid'
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/RMCAction.do?param=getGridRMCAction',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'vehicleno',
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
                        dataIndex: 'vehicleno',
                        type: 'string'
                    }, {
                        type: 'string',
                        dataIndex: 'loadingid'
                    }, {
                        type: 'string',
                        dataIndex: 'unloadingid'
                    }
                ]
            });

            
             //**********************inner panel start******************************************* 
            var innerTopPanel = new Ext.Panel({
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
                        header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
                        dataIndex: 'vehicleno',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=loading%></span>",
                        dataIndex: 'loadingid',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=unloading%></span>",
                        dataIndex: 'unloadingid',
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
            userGrid = getGrid('<%=RMC_Setting%>', '<%=NoRecordsFound%>', store, screen.width-57,410, 4, filters, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', false, '', '', '', false, '',true,'Add',true,'Modify', true, 'Delete');
				
            
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
			  titel="<%=ModifyRMCSetting%>"
			  myWin.setTitle(titel);
			  
			  myWin.show();
			  var selected = userGrid.getSelectionModel().getSelected();
			  Ext.getCmp('vehicleno').setValue(selected.get('vehicleno'));
              Ext.getCmp('loadingid').setValue(selected.get('loadingid'));
              Ext.getCmp('unloadingid').setValue(selected.get('unloadingid'));
              Ext.getCmp('vehicleno').disable();
			 }
			 
			 //function for add button in grid that will open form window
			 function addRecord(){
			 if(Ext.getCmp('custmastcomboId').getValue() == ""){
			    Ext.example.msg("<%=selectCustomer%>");
			    return;
			 }
			 buttonValue="add";
			 titel='<%=AddRMCSetting%>';
			 myWin.show();
			 myWin.setTitle(titel);
			 Ext.getCmp('mandatoryvehicleno').show();
			 Ext.getCmp('vehiclenolab').show();
			 Ext.getCmp('vehicleno').show();
			 Ext.getCmp('vehicleno').reset();
			 Ext.getCmp('vehicleno').enable();
			 Ext.getCmp('mandatoryloading').show();
			 Ext.getCmp('loadinglab').show();
			 Ext.getCmp('loadingid').show();
			 Ext.getCmp('loadingid').reset();
			 Ext.getCmp('mandatoryunloading').show();
			 Ext.getCmp('unloadinglab').show();
			 Ext.getCmp('unloadingid').show();
			 Ext.getCmp('unloadingid').reset();
			 }
			 
			 //************************************************Function for Deleting Record**********************************************************************

		    function deleteData() {
		    	if(userGrid.getSelectionModel().getCount()==0){
		    	                        Ext.example.msg("<%=selectSingleRow%>");
			           					return;
			       						}
			      if(userGrid.getSelectionModel().getCount()>1){
			                            Ext.example.msg("<%=selectSingleRow%>");
			           					return;
			       						}
			  
			  var selected = userGrid.getSelectionModel().getSelected();
			  Ext.getCmp('vehicleno').setValue(selected.get('vehicleno'));
              Ext.getCmp('loadingid').setValue(selected.get('loadingid'));
              Ext.getCmp('unloadingid').setValue(selected.get('unloadingid'));
              
		        if (Ext.getCmp('vehicleno').getValue() == "") {
		                            Ext.example.msg("<%=selectVehicle%>");
                                    Ext.getCmp('vehicleno').focus();
                                    return;
                                }
                                if (Ext.getCmp('loadingid').getValue() == "") {
                                    Ext.example.msg("<%=selectLoading%>");
                                    Ext.getCmp('loadingid').focus();
                                    return;
                                }
                                if (Ext.getCmp('unloadingid').getValue() == "") {
                                    Ext.example.msg("<%=selectUnloading%>");
                                    Ext.getCmp('unloadingid').focus();
                                    return;
                                }
                    Ext.Msg.show({
                        title: '<%=delete%>',
                        msg: '<%=wantToDelete%>',
                        buttons: {
                            yes: true,
                            no: true
                        },
                        fn: function (btn) {
                            switch (btn) {
                            case 'yes':
                                outerPanel.getEl().mask();
                                Ext.Ajax.request({
                                    url: '<%=request.getContextPath()%>/RMCAction.do?param=deleteRMCSetting',
                                    method: 'POST',
                                    params: {
                                        custID: Ext.getCmp('custmastcomboId').getValue(),
                                        vehicleno: Ext.getCmp('vehicleno').getValue(),
                                        loading: Ext.getCmp('loadingid').getValue(),
                                        unloading: Ext.getCmp('unloadingid').getValue()
                                    },
                                    success: function (response, options) //start of success
                                    {
                                        vehiclestore.load({
                                            params: {
                                                CustId: Ext.getCmp('custmastcomboId').getValue(),
                                                LTSPId: <%=systemID%>
                                            }
                                        });
                                        Ext.getCmp('vehicleno').reset();
                                        Ext.getCmp('loadingid').reset();
                                        Ext.getCmp('unloadingid').reset();
                                        Ext.example.msg(response.responseText);
                                        custmastcombostore.reload();
                                        store.load({
                                		params: {
                                    	custID: Ext.getCmp('custmastcomboId').getValue()
                                		},callback:function(){
                                		userGrid.getSelectionModel().deselectRow(0);     
                                		}
                            			});
                                        vehiclestore.reload();
                                        userGrid.getView().refresh();
                                        outerPanel.getEl().unmask();
                                    }, // END OF  SUCCESS
                                    failure: function () //start of failure 
                                    {
                                        Ext.example.msg("<%=error%>");
                                        custmastcombostore.reload();

                                        outerPanel.getEl().unmask();
                                    } // END OF FAILURE 
                                }); // END OF AJAX	  
                                break;
                            case 'no':
                                 Ext.example.msg("<%=custNotDeleted%>");
                                Ext.getCmp('custmastcomboId').reset();
                                custmastcombostore.reload();

                                break;

                            }
                        }
                    });
		
		    }
    
            
             //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                ctsb = tsb;
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    title: '<%=RMC_Setting%>',
                    renderTo: 'content',
                    standardSubmit: true,
					frame: true,
                    cls: 'outerpanel',
                    items: [innerTopPanel, userGrid]
                });


            });
        </script>
    </body>

</html>