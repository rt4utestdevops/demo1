<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
%>
<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">

		<title>Rake Shift Booking</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
          <link rel="stylesheet" type="text/css" href="styles.css">
            -->

	

		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<jsp:include page="../Common/ExportJS.jsp" />
		<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}
			.x-btn-text {
				font-size : 15px !important;
			}
			.ext-strict .ext-webkit .x-small-editor .x-form-text {
				height: 19px !important;
			}
		</style>
	 <%}%>	
	 <style>
		.x-btn-text {
				font-size : 15px !important;
			}
	 </style>

		<script>
        var outerPanel;
        var jspName = "Rake_Shift_Booking";
        var addPlant = 0;
        var bookingType = "";
        var editedRows = "";
		var globalBranchId="";
        var bookingComboStore = new Ext.data.SimpleStore({
            id: 'bookingTypeStoreId',
            autoLoad: true,
            fields: ['bookingTypeId', 'bookingTyeName'],
            data: [
                ['1', 'Rake'],
                ['2', 'Shifting']
            ]
        });
       
       var branchComboStore= new Ext.data.JsonStore({
       url:'<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getBranchList',
                   id:'BranchStoreId',
                   root: 'BranchRoot',
                   autoLoad: true,
                   fields: ['BranchID','BranchName']
    });
     var branchcombo = new Ext.form.ComboBox({
        store: branchComboStore,
        id: 'branchcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Branch',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
   		valueField: 'BranchID',
        width: 170,
        displayField: 'BranchName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
               	globalBranchId = Ext.getCmp('branchcomboId').getValue();
  				loadData();
                    }
                }
            }
    });
     
       
        var billingCustomerStore = new Ext.data.JsonStore({
	        url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getActiveBillingCustomer',
	        id: 'billingCustomerStoreId',
	        root: 'BillingCustStoreRoot',
	        remoteSort: true,
	        autoLoad: true,
	        fields: ['BillingCustId', 'BillingCustName']
    	});
		var billingCustCombo = new Ext.form.ComboBox({
	        frame: true,
	        store: billingCustomerStore,
	        id: 'billingcustomerComboId',
	        width: 175,
	        hidden: true,
	        anyMatch: true,
	        onTypeAhead: true,
	        forceSelection: true,
	        resizable: true,
	        enableKeyEvents: true,
	        mode: 'local',
	        triggerAction: 'all',
	        resizable:true,
	        displayField: 'BillingCustName',
	        valueField: 'BillingCustId',
	        emptyText: 'Select Billing Customer',
	        listeners: {
	            select: {
	                fn: function () {
	                    
	             	 }
	            }
	        }
	    });
        var bookingCombo = new Ext.form.ComboBox({
            store: bookingComboStore,
            id: 'bookingComboId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Select Booking Type',
            selectOnFocus: true,
            allowBlank: false,
            anyMatch: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            displayField: 'bookingTyeName',
            valueField: 'bookingTypeId',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function() {
                        bookingType = Ext.getCmp('bookingComboId').getValue();
                        if(bookingType == '1'){
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('RakeNoDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('RailNoDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('ArrivalDateDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('DepartureDateDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('FromDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('ToDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('billingCustomerDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('shipperNameDataIndex'), true);
                        }else{
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('RakeNoDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('RailNoDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('ArrivalDateDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('DepartureDateDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('FromDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('ToDataIndex'), true);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('billingCustomerDataIndex'), false);
                        	bookingGrid.getColumnModel().setHidden(bookingGrid.getColumnModel().findColumnIndex('shipperNameDataIndex'), false);
                        }
						loadData();
                          
                    }
                }
            }
        });
        
	function loadData(){
		                            dataStoreForGrid.load({
                                params: {
                               		Branch: globalBranchId,
                                   bookingType: bookingType                                  
                               }
                          }); 
	}
	
	//new to and from combo
	
	 var toLocationStore = new Ext.data.JsonStore({
	        url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getLocation',
	        id: 'tolocationStoreId',
	        root: 'locationStoreRoot',
	        remoteSort: true,
	        autoLoad: true,
	        fields: ['LocationId', 'LocationName']
    	}); 
    	
    	
	var toLocationCombo = new Ext.form.ComboBox({
	        frame: true,
	        store: toLocationStore,
	        id: 'tolocationComboId',
	        width: 175,
	        hidden: true,
	        anyMatch: true,
	        onTypeAhead: true,
	        forceSelection: true,
	        resizable: true,
	        enableKeyEvents: true,
	        mode: 'local',
	        triggerAction: 'all',
	        resizable:true,
	        displayField: 'LocationName',
	        valueField: 'LocationName',
	        emptyText: 'Select To Location',
	        listeners: {
	            select: {
	                fn: function () {
	                    
	             	 }
	            }
	        }
	    });
	    
	    var fromLocationCombo = new Ext.form.ComboBox({
	        frame: true,
	        store: toLocationStore,
	        id: 'fromlocationComboId',
	        width: 175,
	        hidden: true,
	        anyMatch: true,
	        onTypeAhead: true,
	        forceSelection: true,
	        resizable: true,
	        enableKeyEvents: true,
	        mode: 'local',
	        triggerAction: 'all',
	        resizable:true,
	        displayField: 'LocationName',
	        valueField: 'LocationName',
	        emptyText: 'Select from Location',
	        listeners: {
	            select: {
	                fn: function () {
	                   
	             	 }
	            }
	        }
	    });
	    
        var clientPanel = new Ext.Panel({
            standardView: true,
            collapsible: false,
            id: 'clientPanelId',
            layout: 'table',
            frame: true,
            width: screen.width - 40,
            height: 40,
            layoutConfig: {
                columns: 8
            },
            items: [{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'BranchID',
                text: 'Branch Name' + ' :',
                style: 'vertical-align: -webkit-baseline-middle'               
            },
            branchcombo,
                {
                width: 50
           		 },	                
            	{
                    xtype: 'label',
                    cls: 'labelstyle',
                    id: 'branchlab',
                    text: 'Booking Type' + ' :',
                    style: 'vertical-align: -webkit-baseline-middle'
                },
                bookingCombo
            ]
        });

        var reader = new Ext.data.JsonReader({
            root: 'bookingDetailsroot',
            fields: [{
                name: 'UidDataIndex',
                type: 'numeric'
            }, {
                name: 'SLNODataIndex',
                type: 'numeric'
            }, {
                name: 'BookingNoDataIndex',
                type: 'string'
            }, {
                name: 'BookingTypeDataIndex',
                type: 'string'
            }, {
                name: 'BookingDateDataIndex',
                type: 'date'
            }, {
                name: 'RakeNoDataIndex',
                type: 'string'
            }, {
                name: 'RailNoDataIndex',
                type: 'string'
            }, {
                name: 'ArrivalDateDataIndex',
                type: 'date'
            }, {
                name: 'DepartureDateDataIndex',
                type: 'date'
            }, {
                name: 'FromDataIndex',
                type: 'string'
            }, {
                name: 'ToDataIndex',
                type: 'string'
            },{
                name: 'billingCustomerDataIndex',
                type: 'string'
            },{
                name: 'shipperNameDataIndex',
                type: 'string'
            }, {
                name: 'ContainersDataIndex',
                type: 'numeric'
            }]
        });

        var dataStoreForGrid = new Ext.data.GroupingStore({
            url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=viewBooking',
            bufferSize: 367,
            reader: reader,
            root: 'bookingDetailsRoot',
            autoLoad: true,
            remoteSort: true
        });

        var Plant = Ext.data.Record.create([{
            name: 'UidDataIndex'
        }, {
            name: 'SLNODataIndex'
        }, {
            name: 'BookingNoDataIndex'
        }, {
            name: 'BookingDateDataIndex'
        }, {
            name: 'RakeNoDataIndex'
        }, {
            name: 'RailNoDataIndex'
        }, {
            name: 'ArrivalDateDataIndex'
        }, {
            name: 'DepartureDateDataIndex'
        }, {
            name: 'FromDataIndex'
        }, {
            name: 'ToDataIndex'
        }, {
            name: 'billingCustomerDataIndex'
        },{
            name: 'shipperNameDataIndex'
        },{
            name: 'ContainersDataIndex'
        }]);

        var filters = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                type: 'numeric',
                dataIndex: 'SLNODataIndex'
            }, {
                type: 'numeric',
                dataIndex: 'UidDataIndex'
            }, {
                type: 'numeric',
                dataIndex: 'BookingNoDataIndex'
            }, {
                type: 'date',
                dataIndex: 'BookingDateDataIndex'
            }, {
                type: 'string',
                dataIndex: 'RakeNoDataIndex'
            }, {
                type: 'string',
                dataIndex: 'RailNoDataIndex'
            }, {
                type: 'date',
                dataIndex: 'ArrivalDateDataIndex'
            }, {
                type: 'date',
                dataIndex: 'DepartureDateDataIndex'
            }, {
                type: 'string',
                dataIndex: 'FromDataIndex'
            }, {
                type: 'string',
                dataIndex: 'ToDataIndex'
            }, {
                type: 'string',
                dataIndex: 'billingCustomerDataIndex'
            }, {
                type: 'string',
                dataIndex: 'shipperNameDataIndex'
            }, {
                type: 'numeric',
                dataIndex: 'ContainersDataIndex'
            }]
        });

        function getcmnmodel() {
            toolGridColumnModel = new Ext.grid.ColumnModel(
                [
                    new Ext.grid.RowNumberer({
                        header: '<B>SL.NO</B>',
                        width: 45,
                    }),
                    {
                        header: '<B>SLNO</B>',
                        hidden: true,
                        sortable: true,
                        width: 90,
                        dataIndex: 'SLNODataIndex',
                        filter: {
                            type: 'numeric'
                        }
                    }, {
                        header: '<B>UID</B>',
                        width: 150,
                        dataIndex: 'UidDataIndex',
                        editable: false,
                        hidden: true,
                    }, {
                        header: '<B>Booking No</B>',
                        width: 150,
                        dataIndex: 'BookingNoDataIndex',
                        editable: false,
                        filter: {
                            type: 'numeric'
                        }
                    }, {
                        header: '<B>Booking Date</B>',
                        width: 150,
                        dataIndex: 'BookingDateDataIndex',
                        sortable: true,
                        editable: true,
                        filter: {
                            type: 'date'
                        },
                        renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
                        editor: new Ext.grid.GridEditor(new Ext.form.DateField({
                            format: 'd/m/Y H:i:s'
                        }))
                    }, {
                        header: '<B>Rake No</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'RakeNoDataIndex',
                        editable: true,
                        filter: {
                            type: 'string'
                        },
                        editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                            width: 150,
                            disabled: false,
                            maxLength: 100
                        }))
                    }, {
                        header: '<B>Rail No</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'RailNoDataIndex',
                        editable: true,
                        filter: {
                            type: 'string'
                        },
                        editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                            width: 150,
                            disabled: false,
                            maxLength: 100
                        }))
                    }, {
                        header: '<B>Date of Arrival</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'ArrivalDateDataIndex',
                        editable: true,
                        hidable: true,
                        filter: {
                            type: 'date'
                        },
                        renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
                        editor: new Ext.grid.GridEditor(new Ext.form.DateField({
                            format: 'd/m/Y H:i:s'
                        }))
                    }, {
                        header: '<B>Date of Departure</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'DepartureDateDataIndex',
                        editable: true,
                        hidable: true,
                        filter: {
                            type: 'date'
                        },
                        renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
                        editor: new Ext.grid.GridEditor(new Ext.form.DateField({
                            format: 'd/m/Y H:i:s'
                        }))
                    }, {
                        header: '<B>From</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'FromDataIndex',
                        hidable: true,
                        editable: true,
                         filter: {
                            type: 'string'
                        },
                       // renderer: FromLocationrender,
                        editor: new Ext.grid.GridEditor(fromLocationCombo)
                        },
                        {
                        header: '<B>To</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'ToDataIndex',
                        hidable: true,
                        editable: true,
                        filter: {
                            type: 'string'
                        },
                        //renderer: ToLocationrender,
                        editor: new Ext.grid.GridEditor(toLocationCombo)                       
       				  }, {
                        header: '<B>Billing Customer</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'billingCustomerDataIndex',
                        hidable: true,
                        editable: true,
                        filter: {
                            type: 'string'
                        },
                        editor: new Ext.grid.GridEditor(billingCustCombo),
                        renderer: BillingCustomerrender
                    }, {
                        header: '<B>Shipper Name</B>',
                        sortable: true,
                        width: 150,
                        dataIndex: 'shipperNameDataIndex',
                        hidable: true,
                        editable: true,
                        filter: {
                            type: 'string'
                        },
                        editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                            width: 100,
                            disabled: false,
                            maxLength: 100
                        }))
                    }, {
                        header: '<B>No of Containers</B>',
                        sortable: true,
                        width: 140,
                        dataIndex: 'ContainersDataIndex',
                        hidable: true,
                        editable: true,
                        filter: {
                            type: 'numeric'
                        },
                        editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                            width: 140,
                            cls: 'bskExtStyle'
                        }))
                    }
                ]);
            return toolGridColumnModel;
        }

        var bookingGrid = new Ext.grid.EditorGridPanel({
            title: 'Booking Details',
            header: true,
            id: 'toolGridid',
            ds: dataStoreForGrid,
            cm: getcmnmodel(),
            stripeRows: true,
            border: true,
            width: screen.width - 45,
            height: 455,
            autoScroll: true,
            plugins: [filters],
            clicksToEdit: 1,
            selModel: new Ext.grid.RowSelectionModel(),
            tbar: [{
                text: 'Add',
                handler: function() {
                	if(Ext.getCmp('branchcomboId').getValue() == ""){
                		Ext.example.msg("Please select a branch");
                		return;
                	}
                	if(Ext.getCmp('bookingComboId').getValue() == ""){
                		Ext.example.msg("Please select a bookingType");
                		return;
                	}           	
                    addPlant++;
                    var p = new Plant({
                        SLNODataIndex: "new" + addPlant,
                        UidDataIndex: "",
                        BookingNoDataIndex: "",
                        BookingDateDataIndex: "",
                        RakeNoDataIndex: "",
                        RailNoDataIndex: "",
                        ArrivalDateDataIndex: "",
                        DepartureDateDataIndex: "",
                        FromDataIndex: "",
                        ToDataIndex: "",
                        billingCustomerDataIndex:"",
                        shipperNameDataIndex: "",
                        ContainersDataIndex: ""
                    });
                    editedRows = editedRows + "new" + addPlant + ",";
                    bookingGrid.stopEditing();
                    dataStoreForGrid.insert(0, p);
                    bookingGrid.startEditing(0, 0);
                }
            }, '-', {
                text: 'Save',
                handler: function() {
                    var selected = bookingGrid.getSelectionModel().getSelected();
                    var json = '';
                    var valid = true;
                    bookingGrid.stopEditing();
                    temp = editedRows.split(",");
                    
                    for (var i = 0; i < temp.length; i++) {
                        var row = dataStoreForGrid.find('SLNODataIndex', temp[i]);
                        if (row == -1) {
                            continue;
                        }
                        var store = bookingGrid.store.getAt(row);

                        if (store.data['BookingDateDataIndex'] == "") 
                        {
                        Ext.example.msg("Please Enter Booking Date");
                        return;
                        
                        }
        
                        if(Ext.getCmp('bookingComboId').getValue() == '1')
                        {
                        	if (store.data['RakeNoDataIndex'] == "") {
                            Ext.example.msg("Please Enter Rake Number");
                            return;
                        }
                        if (store.data['RailNoDataIndex'] == "") {
                            Ext.example.msg("Please Enter Rail Number");
                            return;
                        }
                       
                        if (store.data['ArrivalDateDataIndex'] == "") {
                            Ext.example.msg("Please Enter Date of Arrival");
                            return;
                        }
                        if (store.data['DepartureDateDataIndex'] == "") {
                            Ext.example.msg("Please Enter Date of Departure");
                            return;
                        }
                        if (store.data['FromDataIndex'] == "") {
                            Ext.example.msg("Please Enter From Location");
                            return;
                        }
                        if (store.data['ToDataIndex'] == "") {
                            Ext.example.msg("Please Enter To Location");
                            return;
                        }
                        
                        }
                        else
                        {
                        	if (store.data['billingCustomerDataIndex'] == "") {
                            	Ext.example.msg("Please select Billing Customer");
                            	return;
                        }
                        }
                        if (store.data['ContainersDataIndex'] == "") {
                            Ext.example.msg("Please Enter No of Containers");
                            return;
                        }
                        if(bookingType == '1'){
                       if(dateCompare((store.data['ArrivalDateDataIndex']),store.data['DepartureDateDataIndex'])== -1)
                       {
                       Ext.example.msg("Arrival date should be less than departure date"); 
                            return;
                       }
                       
                        if(dateCompare((store.data['BookingDateDataIndex']),store.data['ArrivalDateDataIndex'])== -1 || dateCompare((store.data['BookingDateDataIndex']),store.data['DepartureDateDataIndex'])== -1 )
                       {
                       Ext.example.msg("Booking Date should be less than arrival date and departure date");
                            return;
                       }
                       }
                        
                        json += Ext.util.JSON.encode(store.data) + ',';
                    }
                    	
                    if (json != '') {
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=saveRakeShiftBooking',
                            method: 'POST',
                            params: {
                            	Branch: globalBranchId,
                                bookingType: bookingType,                               
                                datajson: json
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                json = '';
                                editedRows = '';
                                dataStoreForGrid.reload();
                            },
                            failure: function() {
                                dataStoreForGrid.reload();
                                json = '';
                                editedRows = '';
                            }
                        });
                    } else {
                        Ext.example.msg("No row/s has changed to save");
                    }
                }
            }, '-', {
                text: 'Remove Filters',
                handler: function() {
                    bookingGrid.filters.clearFilters();
                }
            }, '-', {
                text: 'Refresh',
                handler: function() {
                    dataStoreForGrid.reload();
                    json = '';
                    editedRows = '';
                }
            },'-',{
            	text: 'Add Container Details',
                handler: function() {
                if (bookingGrid.getSelectionModel().getCount() == 0) {
		           Ext.example.msg("Please select a row");
		           return;
		       }
		       if (bookingGrid.getSelectionModel().getCount() > 1) {
		          Ext.example.msg("Please select a single row");
		           return;
		       }
		       var selected = bookingGrid.getSelectionModel().getSelected();
		       var containerNo = selected.get('ContainersDataIndex');
		       var bookingId = selected.get('UidDataIndex'); 
               var BookingType=Ext.getCmp('bookingComboId').getValue();
                   window.location="<%=request.getContextPath()%>/Jsps/ContainerCargoManagement/RakeShiftContainerInformation.jsp?BookingType="+BookingType+"&containerNo="+containerNo+"&bookingId="+bookingId;
                }
            }]
        });

        bookingGrid.on({
            afteredit: function(e) {
                var field = e.field;
                var slno = e.record.data['SLNODataIndex'];
                temp = editedRows.split(",");
                isIn = 0;
                for (var i = 0; i < temp.length; i++) {
                    if (temp[i] == slno) {
                        isIn = 1
                    }
                }
                if (isIn == 0) {
                    editedRows = editedRows + slno + ",";
                }
            }
        });
		function BillingCustomerrender(value, p, r) {
        	var returnValue = "";
        	if (billingCustomerStore.isFiltered()) {
            	billingCustomerStore.clearFilter();
        	}
        	var idx = billingCustomerStore.findBy(function (record) {
            if (record.get('BillingCustId') == value) {
                returnValue = record.get('BillingCustName');
                return true;
            }
        	});
        	//r.data['BillingCustomerStr'] = returnValue;
        	return returnValue;
    	}
    	
    	function ToLocationrender(value, p, r) {
        	var returnValue = "";
        	if (toLocationStore.isFiltered()) {
            	toLocationStore.clearFilter();
        	}
        	var idx = toLocationStore.findBy(function (record) {
            if (record.get('LocationId') == value) {
                returnValue = record.get('LocationName');
                return true;
            }
        	});
        	//r.data['ToLocationStr'] = returnValue;
        	return returnValue;
    	}
    	function FromLocationrender(value, p, r) {
        	var returnValue = "";
        	if (fromLocationStore.isFiltered()) {
            	fromLocationStore.clearFilter();
        	}
        	var idx = fromLocationStore.findBy(function (record) {
            if (record.get('LocationId') == value) {
                returnValue = record.get('LocationName');
                return true;
            }
        	});
        	//r.data['FromoLocationStr'] = returnValue;
        	return returnValue;
    	}
    	
        Ext.onReady(function() {
            Ext.QuickTips.init();
            Ext.Ajax.timeout = 180000;
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                title: 'Rake Shift Booking',
                renderTo: 'content',
                id: 'outerPanel',
                standardView: true,
              	 autoScroll: false,
                frame: true,
                border: false,
                width: screen.width - 22,
                height: 550,
                layout: 'table',
                cls: 'outerpanel',
                layoutConfig: {
                    columns: 1
                },
                items: [clientPanel, bookingGrid]
            });
        });
   </script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->