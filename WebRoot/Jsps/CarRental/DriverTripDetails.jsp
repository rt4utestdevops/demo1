<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row"); 
tobeConverted.add("Vehicle_No"); 
tobeConverted.add("Group_Name");
tobeConverted.add("Trip_Id");
tobeConverted.add("Pick_Up_Location");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Status");
tobeConverted.add("Created_By");
tobeConverted.add("Closed_By");
tobeConverted.add("Create_Trip");
tobeConverted.add("Close_Trip");
tobeConverted.add("Select_Vehicle_Number");
tobeConverted.add("Enter_Trip_Id");
tobeConverted.add("Select_Pick_Up_Location");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Modify");
tobeConverted.add("Add");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Booking_Trip");
tobeConverted.add("Add_Trip");
tobeConverted.add("Modify_Trip");
tobeConverted.add("Trip_Already_Closed");

ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String selectCustomer=convertedWords.get(0);
String CustomerName=convertedWords.get(1);
String Save=convertedWords.get(2);
String Cancel=convertedWords.get(3);
String SLNO=convertedWords.get(4);
String noRowsSelected=convertedWords.get(5);
String selectSingleRow=convertedWords.get(6);
String vehicleNo = convertedWords.get(7);
String groupName = convertedWords.get(8);
String tripId= convertedWords.get(9);
String pickUpLocation= convertedWords.get(10);
String startDate= convertedWords.get(11);
String endDate= convertedWords.get(12);
String status= convertedWords.get(13);
String createdBy= convertedWords.get(14);
String closedBy= convertedWords.get(15);
String createTrip= convertedWords.get(16);
String closeTrip= convertedWords.get(17);
String selectAssetNo= convertedWords.get(18);
String EnterTripId=  convertedWords.get(19);
String SelectHubId= convertedWords.get(20);
String SelectStartDate= convertedWords.get(21);
String SelectEndDate=  convertedWords.get(22);
String dateValidation= convertedWords.get(23);
String modify = convertedWords.get(24);
String add = convertedWords.get(25);
String NoRecordsFound = convertedWords.get(26);
String ClearFilterData = convertedWords.get(27);
String CreateTrip=convertedWords.get(28);
String AddTrip=convertedWords.get(29);
String ModifyTrip=convertedWords.get(30);
String TripClosed=convertedWords.get(31);//convertedWords.get(18);

%>

<jsp:include page="../Common/header.jsp" />
 
		<title>DriverTripDetails</title>		
	   
	<style>  
		.x-panel-tl
		{
			border-bottom: 0px solid !important;
		}
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height: 42px !important;
		}
		.x-layer ul {
			min-height: 27px !important;
		}
  </style>
  <div style="height:'100%' ">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
   <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <script>
    var outerPanel;
    var ctsb;
    var jspName = "Driver Trip Details";
    var exportDataType = "string";
    var selected;
    var grid;
    var buttonValue;
    var assetgroupstate;
    var titel;
    var myWin;
    var globalCustomerID=parent.globalCustomerID;
    var hubIdModify;
    var uniqueId;
    var enddate;
    var custId;
    
    Ext.override(Ext.grid.GridView, {
        afterRender: function () {
            this.mainBody.dom.innerHTML = this.renderRows();
            this.processRows(0, true);
            if (this.deferEmptyText !== true) {
                this.applyEmptyText();
            }
            this.fireEvent("viewready", this); //new event
        }
    });
	Ext.EventManager.onWindowResize(function () {
	var width = Ext.getBody().getViewSize().width-10;
	var height = '100%';
    var tmpHeight = Ext.getBody().getViewSize().height - 160;
    //var height = Ext.getBody().getViewSize().height - 140;
    grid.setSize(width, height);
	outerPanel.setSize(width, height);
	outerPanel.doLayout();
	});

    //************************************************Store for getting customer name**************************************************************
    var custmastcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('custmastcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('custmastcomboId').getValue();
            }
            store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custName:Ext.getCmp('custmastcomboId').getRawValue()
                    }
                });
                hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    vehicleNoStore.load({
						params:{
						globalClientId : Ext.getCmp('custmastcomboId').getValue()
						}
					});
        }
    }
});

    //************************************************* Combo for Customer Name*****************************************************
    var custnamecombo = new Ext.form.ComboBox({
        store: custmastcombostore,
        id: 'custmastcomboId',
        mode: 'local',
        hidden: false,
        resizable: false,
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
        listWidth : 150,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
	                store.load({
	                    params: {
	                        CustId: custId,
	                        jspName:jspName,
	                        custName:Ext.getCmp('custmastcomboId').getRawValue()
	                    }
	                });
	                
                	hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    vehicleNoStore.load({
						params:{
						globalClientId : Ext.getCmp('custmastcomboId').getValue()
						}
					});
                }
            }
        }
    });

    
   var hubNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/DriverTripDetailsAction.do?param=getHubNames',
        id: 'hubStoreId',
        root: 'hubNameRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['hubId', 'hubName']
    });
 //************************************************* Combo for State Name*****************************************************
    var hubNameCombo = new Ext.form.ComboBox({
        store: hubNameStore,
        id: 'hubcomboId',
        mode: 'local',
        hidden: false,
        resizable: true,
        forceSelection: true,
        emptyText: '<%=SelectHubId%>',
        blankText: '<%=SelectHubId%>',
        selectOnFocus: true,
        allowBlank: false,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'hubId',
        displayField: 'hubName',
        listWidth : 150,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                }
            }
        }
    });
    //*****************************************Store for getting Supervisor Details*******************************************************************
   var vehicleNoStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/DriverTripDetailsAction.do?param=getVehicleNoListForClient',
				   id:'vehicleNoStoreId',
			       root: 'vehicleNoStoreList',
			       autoLoad: false,
			       remoteSort:true,
				   fields: ['vehicleNo']
			     })			     

    //**************************************** Combo for driverName ******************************************************************************
    var vehicleNoCombo = new Ext.form.ComboBox({
        store: vehicleNoStore,
        id: 'assetNopcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=selectAssetNo%>',
        blankText: '<%=selectAssetNo%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'vehicleNo',
        displayField: 'vehicleNo',
        listWidth : 150,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                
                }
            }
        }
    });
    
    var sdate = new Ext.form.DateField({
		    width: 125,
		    format: 'd/m/Y H:i:s', 
		    cls: 'selectstylePerfect',
		    emptyText:'<%=SelectStartDate%>',
		    blankText:'<%=SelectStartDate%>',
		    allowBlank: false,
            id: 'startDatetid' 
		});
		
	 var edate = new Ext.form.DateField({
		    width: 125,
		    format: 'd/m/Y H:i:s',
		    cls: 'selectstylePerfect',
		    emptyText:'<%=SelectEndDate%>',
		    blankText:'<%=SelectEndDate%>',
          	id: 'endDateid'
		});
		
		 
    
    //********************************************* Inner Pannel **************************************************************************************
    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: false,
        height: 200,
       	width: 460,
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
                cls: 'selectstylePerfect'
            }, {
                cls: 'selectstylePerfect'
            },{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryassetgroup'
            }, {
                xtype: 'label',
                text: '<%=vehicleNo%>'+' :',
                cls: 'selectstylePerfect',
                id: 'assetgroupnametxt'
            }, vehicleNoCombo,{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryassetgroupnew' 
            },{
                xtype: 'label',
                text: '<%=tripId%>'+' :',
                cls: 'selectstylePerfect',
                id: 'assetgroupnamenewtxt'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText:'<%=EnterTripId%>',
                blankText:'<%=EnterTripId%>',
                allowBlank:false,
                id: 'tripIdTxtFld',
                listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
            },{
                xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorypickUpLocation'
            }, {
                xtype: 'label',
                text: '<%=SelectHubId%>'+' :',
                cls: 'selectstylePerfect',
                id: 'pickUpLocationtxt'
            }, hubNameCombo,
            {
                xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'startDateId'
            }, {
                xtype: 'label',
                text: '<%=startDate%>'+' :',
                cls: 'selectstylePerfect',
                id: 'startDatetxt'
            }, 
               sdate
            ,{
               	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryendDate'
            }, {
                xtype: 'label',
                text: '<%=endDate%>'+' :',
                cls: 'selectstylePerfect',
                id: 'endDateLabl'
            }, edate
            
        ]
    });
    var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 50,
        width: 460,
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: '<%=Save%>',
            id: 'addButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
						if (Ext.getCmp('assetNopcomboId').getValue() == "") {
						    Ext.example.msg('<%=selectAssetNo%>');
           					Ext.getCmp('assetNopcomboId').focus();
           					return;
       						}
       					if (Ext.getCmp('tripIdTxtFld').getValue() == "") {
       					    Ext.example.msg("<%=EnterTripId%>");
           					Ext.getCmp('tripIdTxtFld').focus();
           					return;
       						}
    					if (Ext.getCmp('hubcomboId').getValue() == "") {
       					    Ext.example.msg("<%=SelectHubId%>");
           					Ext.getCmp('hubcomboId').focus();
           					return;
       						}
      					if (Ext.getCmp('startDatetid').getValue() == "") {
       					    Ext.example.msg("<%=SelectStartDate%>");
           					Ext.getCmp('startDatetid').focus();
           					return;
       						}
       						
			            if (buttonValue == 'Modify') {
			               		if (Ext.getCmp('endDateid').getValue() == "") {
	       					    Ext.example.msg("<%=SelectEndDate%>");
	           					Ext.getCmp('endDateid').focus();
	           					return;
	       						}
	       				var dt=dateCompare(document.getElementById('startDatetid').value, document.getElementById('endDateid').value);
	       				if(dt==-1){
	       					Ext.example.msg("<%=dateValidation%>");
	           				Ext.getCmp('endDateid').focus();
	           				return;
	       				}	
	       				if(Ext.getCmp('endDateid').getValue()<Ext.getCmp('startDatetid').getValue())	
	       				{
	       					Ext.example.msg("<%=dateValidation%>");
	           				Ext.getCmp('endDateid').focus();
	           				return;
	       				}
	       						
                    	}
                    		
			            outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/DriverTripDetailsAction.do?param=saveormodifyDriverTripDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                assetNo: Ext.getCmp('assetNopcomboId').getValue(),
                                tripId: Ext.getCmp('tripIdTxtFld').getValue(),
                                customerID: Ext.getCmp('custmastcomboId').getValue(),
                                startDate: Ext.getCmp('startDatetid').getValue(),
                                endDate: Ext.getCmp('endDateid').getValue(),
                                hubId:Ext.getCmp('hubcomboId').getValue(),
                                uniqueId:uniqueId
                            },
                            success: function (response, options) {
                                var msg=response.responseText;                               			  
                                Ext.example.msg(msg);
                                Ext.getCmp('assetNopcomboId').reset();
						        Ext.getCmp('tripIdTxtFld').reset();
						        Ext.getCmp('hubcomboId').reset();
						        Ext.getCmp('startDatetid').reset();
						        Ext.getCmp('endDateid').reset(); 
                                outerPanelWindow.getEl().unmask();  
                                myWin.hide();
                                store.load({
		                        params: {
		                            customerID: Ext.getCmp('custmastcomboId').getValue()
		                        }
		                    });
                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                outerPanelWindow.getEl().unmask();  
                                store.load({
		                        params: {
		                            customerID: Ext.getCmp('custmastcomboId').getValue()
		                        }
		                    });
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'canButtId',
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                        myWin.hide();
                    }
                }
            }
        }]

    });
    var outerPanelWindow = new Ext.Panel({   
        height:330,
        width: 450,
        standardSubmit: true,
        frame: false,
        items: [innerPanel, winButtonPanel]
    });

    myWin = new Ext.Window({
        title: titel,
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        height: 365,
        width: 460,
        id: 'myWin',
        items: [outerPanelWindow]
    });
    
    //*************************************************Function for ADD button**************************************************************************

    function addRecord() {
    	if (Ext.getCmp('custmastcomboId').getValue() == "") {
    	                    Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       	}
       	 hubNameStore.load({
             params: {
                 customerID: Ext.getCmp('custmastcomboId').getValue()
             }
         });         
         vehicleNoStore.load({
			params:{
			globalClientId : Ext.getCmp('custmastcomboId').getValue()
			}
		});	
        buttonValue = '<%=add%>';
        titel = '<%=AddTrip%>';
        myWin.show();
        myWin.setTitle(titel);  
        Ext.getCmp('assetNopcomboId').reset();
        Ext.getCmp('tripIdTxtFld').reset();
        Ext.getCmp('hubcomboId').reset();
        Ext.getCmp('startDatetid').reset();
        Ext.getCmp('endDateid').reset(); 
        Ext.getCmp('endDateid').hide();
        Ext.getCmp('endDateLabl').hide();
        Ext.getCmp('mandatoryendDate').hide();
        Ext.getCmp('assetNopcomboId').setReadOnly(false);
        Ext.getCmp('startDatetid').setReadOnly(false);
        Ext.getCmp('tripIdTxtFld').setReadOnly(false);
        Ext.getCmp('hubcomboId').setReadOnly(false);
    }
    //***************************************************Function for Modify Button***********************************************************************

    function modifyData() {
    	if (Ext.getCmp('custmastcomboId').getValue() == "") {
            Ext.example.msg("<%=selectCustomer%>");
			Ext.getCmp('custmastcomboId').focus();
			myWin.hide();
			return;
		 }
		 var record = grid.getSelectionModel().getSelected();
		 if(record.data['statusIndex'] == 'Closed' || record.data['statusIndex'] == 'closed'){
		 	Ext.example.msg("<%=TripClosed%>");
		 	myWin.hide();
		 	return;
		 }
		 
		hubNameStore.load({
             params: {
                 customerID: Ext.getCmp('custmastcomboId').getValue()
             }
         });         
         vehicleNoStore.load({
			params:{
			globalClientId : Ext.getCmp('custmastcomboId').getValue()
			}
		});    
    
        buttonValue = '<%=modify%>';
        titel = "<%=ModifyTrip%>"
        myWin.setTitle(titel);
        myWin.show();
        if(grid.getSelectionModel().getCount()<1){
        myWin.hide();
        Ext.example.msg("<%=selectSingleRow%>");
        }
        Ext.getCmp('endDateid').show();
        Ext.getCmp('endDateLabl').show();
        Ext.getCmp('mandatoryendDate').show();
        var selected = grid.getSelectionModel().getSelected();
        Ext.getCmp('assetNopcomboId').setValue(selected.get('assetNoIndex'));
        Ext.getCmp('startDatetid').setValue(selected.get('startDateIndex'));
        Ext.getCmp('tripIdTxtFld').setValue(selected.get('tripIdIndex'));
        Ext.getCmp('hubcomboId').setValue(selected.get('pickUpLocationIndex'));
        var rj=document.getElementById('startDatetid').value;
        Ext.getCmp('endDateid').setValue(selected.get('endDateIndex'));
        uniqueId=selected.get('drivrTripDetuniqueId');
        Ext.getCmp('assetNopcomboId').setReadOnly(true);
        Ext.getCmp('startDatetid').setReadOnly(true);
        Ext.getCmp('tripIdTxtFld').setReadOnly(true);
        Ext.getCmp('hubcomboId').setReadOnly(true);
        Ext.getCmp('endDateid').setReadOnly(false);
    }
    
    //********************************************Grid config starts***************************************************************************************
    // **********************************************Reader configs****************************************************************************************
    var reader = new Ext.data.JsonReader({
        idProperty: 'Storerederid',
        root: 'driverTripDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'drivrTripDetuniqueId'
        },{
            name: 'assetNoIndex'
        },{
            name: 'tripIdIndex'
        }, {
            name: 'groupNameIndex'
        }, {
            name: 'driverNameIndex'
        }, {
            name: 'pickUpLocationIndex'
        }, {
            name: 'startDateIndex'
        }, {
        	name:'endDateIndex'
        }, {
        	name:'statusIndex'
        }, {
        	name:'createdByIndex'
        },{
        	name:'closedByIndex'
        }]
    });

    //********************************************************* Store Configs********************************************************************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/DriverTripDetailsAction.do?param=getDriverTripDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'Storerederid',
        reader: reader
        });
        store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    customerID: Ext.getCmp('custmastcomboId').getValue()
                };
            }, this);
   
    //********************************************************************Filter Config************************************************************************************
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'assetNoIndex'
        }, {
            type: 'string',
            dataIndex: 'assetgroupnameIndex'
        }, {
            type: 'string',
            dataIndex: 'groupNameIndex'
        }, {
            type: 'string',
            dataIndex: 'driverNameIndex'
        }, {
            type: 'string',
            dataIndex: 'tripIdIndex'
        }, {
            type: 'string',
            dataIndex: 'pickUpLocationIndex'
        },{
         	type:'string',
         	dataIndex:'statusIndex'
         },{
         	type:'date',
         	dataIndex:'startDateIndex'
         },{
         	type:'date',
         	dataIndex:'endDateIndex'
         },{
         	type:'int',
         	dataIndex:'createdByIndex'
         },{
         	type:'string',
         	dataIndex:'closedByIndex'
         }]
    });

    //*********************************************Column model config***************************************************************************
    
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },  {
                header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
                dataIndex: 'assetNoIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>UniqueId</span>",
                dataIndex: 'drivrTripDetuniqueId',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=groupName%></span>",
                dataIndex: 'groupNameIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=tripId%></span>",
                dataIndex: 'tripIdIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Driver name</span>",
                dataIndex: 'driverNameIndex',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=pickUpLocation%></span>",
                dataIndex: 'pickUpLocationIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=startDate%></span>",
                dataIndex: 'startDateIndex',
                 format: 'd/m/Y h:m:s',
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;><%=endDate%></span>",
                dataIndex: 'endDateIndex',
                format: 'd/m/Y h:m:s',
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;><%=status%></span>",
                dataIndex: 'statusIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=createdBy%></span>",
                dataIndex: 'createdByIndex',
                filter: {
                    type: 'int'
                }
            },{
                header: "<span style=font-weight:bold;><%=closedBy%></span>",
                dataIndex: 'closedByIndex',
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
    //*****************************************************************Grid *******************************************************************************
    grid = getGrid('<%=CreateTrip%>', '<%=NoRecordsFound%>', store,screen.width-50,390, 17, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', false, '', jspName, exportDataType, false, '', true, '<%=createTrip%>', true, '<%=closeTrip%>', false, 'Delete');
    
    //***********************************************************Customer Panel Start************************************************************************ 
    
    var customerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        frame:false,
        cls: 'innerpanelsmallest',
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + '  :',
                allowBlank: false,
                hidden: false,
                cls: 'labellargestyle',
                id: 'custnamhidlab'
            },
            custnamecombo
        ]
    });
    
    //****************************************************Main starts from here**************************************************************************
   
    Ext.namespace('Ext.ux');
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            height:500,
            width:screen.width-38,
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            border:false,
            cls: 'outerpanel',
            items: [customerPanel, grid]
        });
     
			if(<%=responseaftersubmit%>!=''){
				Ext.example.msg("<%=responseaftersubmit%>");
	        }

    });
    </script>
</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->