<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
%>

	<jsp:include page="../Common/header.jsp" />
	<title>Parameter Setting</title>
	<style>
	
	.labelstyle {
		spacing: 10px;
		height: 20px;
		width: 150 px !important;
		min-width: 150px !important;
		margin-bottom: 5px !important;
		margin-left: 5px !important;
		font-size: 12px;
		font-family: sans-serif;
		font-weight:bold;
	}
	.x-table-layout td {
    vertical-align: inherit !important;
    }
    .x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;
	}
	.x-panel-header {
    height: 100px !important;
}	
	label{
		display : inline !important;
	}
	.footer {
		bottom : -6px !important;
	}
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	.x-layer ul {
	 	min-height:27px !important;
	}
	</style>

		  
	
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
    <script>
    var grid;
	var dtcur = datecur;
	var jspName = 'TripCreationReport';
	var exportDataType = "int,string,string,string,string,string,string,number,number,number,string,number,number,string";
	var currentTime = new Date();
	var minDate = dateprev.add(Date.Month, -10);
	var editedRows = "";
	var endDateMinVal = datecur.add(Date.DAY, -30);
	var globalOnAccOf;
	var emptyValue;

	var limitTypeCombostore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/OBDAction.do?param=getLimitType',
   	 	id: 'limitTypeCombostoreId',
    	root: 'limitTypeCombostoreRoot',
    	autoLoad: true,
	    fields: ['typeId','typeName']
	});
	var limitTypeCombo = new Ext.form.ComboBox({
	    store: limitTypeCombostore,
	    id: 'limitTypeComboId',
	    mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'typeId',
	    displayField: 'typeName',
	   	multiSelect:true,
		beforeBlur: Ext.emptyFn,
	    listeners: {
	        select: {
	            fn: function() {
	            	grid.getSelectionModel().getSelected().set("limitValueDI","");				
	            }
	        }
	    }
	});
	var modelComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleModel',
	    id: 'modelComboStoreId',
	    root: 'modelComboStoreRoot',
	    autoLoad: false,
	    fields: ['modelId', 'modelName']
	});
	var vehicleModelCombo = new Ext.form.ComboBox({
	    store: modelComboStore,
	    id: 'vehicleModelComboId',
	    mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: 'Select Vehicle Model',
	    blankText: 'Select Vehicel Model',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'modelId',
	    displayField: 'modelName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {
					store.load({params:{vehicleModel: Ext.getCmp('vehicleModelComboId').getValue()}});
	            }
	        }
	    }
	});
	var vehicleMakeStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleMake',
	    id: 'vehicleMakeStoreId',
	    root: 'vehicleMakeStoreRoot',
	    autoLoad: true,
	    fields: ['vehicleMakeName']
	});
	var vehicleMakeCombo = new Ext.form.ComboBox({
	    store: vehicleMakeStore,
	    id: 'vehicleMakeComboId',
	    mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: 'Select Vehicle Make',
	    blankText: 'Select Vehicle Make',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'vehicleMakeName',
	    displayField: 'vehicleMakeName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {
	            	Ext.getCmp('vehicleModelComboId').reset();
	                modelComboStore.load({params:{vehicleMake: Ext.getCmp('vehicleMakeComboId').getRawValue()}});
	            }
	        }
	    }
	});

	var Panel = new Ext.Panel({
	    standardSubmit: true,
	    collapsible: false,
	    id: 'panelId',
	    layout: 'table',
	    cls: 'innerpanelsmallest',
	    frame: false,
	    width: 50,
	    width: screen.width - 80,
	    layoutConfig: {
	        columns: 12
	    },
	    items: [{width: 50},{
	        xtype: 'label',
	        text: 'Vehicle Make ' + ' :',
	        cls: 'labelstyle',
	        id: 'vehicleMakeLblId'
	    },{width: 30}, vehicleMakeCombo,{width: 100}, {
	        xtype: 'label',
	        text: 'Vehicle Model ' + ' :',
	        width: 20,
	        cls: 'labelstyle',
	        id: 'vehicleModelLblId'
	    },{width: 30},vehicleModelCombo]
	});
	var reader = new Ext.data.JsonReader({
	    idProperty: 'parameterConfigRootId',
	    root: 'parameterConfigRootRoot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'UIDDI'
	    }, {
	        name: 'slNoDI'
	    }, {
	        name: 'parameterNameDI'
	    }, {
	        name: 'parameterIdDI'
	    }, {
	        name: 'unitDI'
	    },{
	        name: 'parameterLimitTypeDI'
	    }, {
	        name: 'limitValueDI'
	    }]
	});

	var store = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/OBDAction.do?param=getParameterConfigDetails',
	        method: 'POST'
	    }),
	    remoteSort: false,
	    reader: reader
	});

	var filters = new Ext.ux.grid.GridFilters({
	    local: true,
	    filters: [{
	        type: 'numeric',
	        dataIndex: 'UIDDI'
	    }, {
	        type: 'numeric',
	        dataIndex: 'slNoDI'
	    }, {
	        type: 'string',
	        dataIndex: 'parameterNameDI'
	    }, {
	    	type: 'numeric',
	        dataIndex: 'parameterIdDI'
	    }, {
	        type: 'string',
	        dataIndex: 'unitDI'
	    },{
			type: 'string',
			dataIndex: 'parameterLimitTypeDI'    
	    }, {
	        type: 'string',
	        dataIndex: 'limitValueDI'
	    }]
	});
	var sm = new Ext.grid.CheckboxSelectionModel({
	checkOnly: 'true'});
	var createColModel = function(finish, start) {
	    var columns = [
	        new Ext.grid.RowNumberer({
	            header: "<span style=font-weight:bold;>SNo</span>",
	            width: 40
	        }), sm, {
	            dataIndex: 'UIDDI',
	            hidden: true,
	            header: "<span style=font-weight:bold;>UID</span>",
	            filter: {
	                type: 'int'
	            }
	        }, {
	            dataIndex: 'slNoDI',
	            hidden: true,
	            header: "<span style=font-weight:bold;>Sl No</span>",
	            filter: {
	                type: 'int'
	            }
	        }, {
	            header: "<span style=font-weight:bold;>Parameter Name</span>",
	            dataIndex: 'parameterNameDI',
	            width: 150,
	            sortable: true,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;>Parameter Id</span>",
	            dataIndex: 'parameterIdDI',
	            width: 150,
	            sortable: true,
	            hidden: true,
	            filter: {
	                type: 'int'
	            }
	        },{
	            header: "<span style=font-weight:bold;>Unit</span>",
	            dataIndex: 'unitDI',
	            width: 140,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;>Parameter Limit Type</span>",
	            dataIndex: 'parameterLimitTypeDI',
	            width: 150,
	            filter: {
	                type: 'string'
	            },
	            editor: new Ext.grid.GridEditor(limitTypeCombo),
	            renderer: limitTypeRenderer
	        }, {
	            header: "<span style=font-weight:bold;>Limit Value</span>",
	            dataIndex: 'limitValueDI',
	            width: 150,
	            filter: {
	                type: 'string'
	            },
	            editor: new Ext.grid.GridEditor(new Ext.form.TextField({}))
	        }
	    ];
	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),
	        defaults: {
	            sortable: true
	        }
	    });
	};

	grid = getSelectionModelEditorGridCashVan('', 'No Records Found', store, 1330, 430, 32, filters, 'Clear Filter Data', false, '', 32, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Save', false, 'Cancel', true, 'Refresh', sm);

	function addRecord() {
	    if(Ext.getCmp('vehicleMakeComboId').getValue() == ""){
	    	Ext.example.msg("Please select Vehicle Make");
            return false;
	    }
	    if(Ext.getCmp('vehicleModelComboId').getValue() == ""){
	    	Ext.example.msg("Please select Vehicle Model");
            return false;
	    }
	    var selected = grid.getSelectionModel().getSelected();
	    if (selected == undefined || selected == "undefined") {
	        Ext.example.msg("Please select one row");
	        return false;
	    }
	    var json = '';
	    var record = grid.getSelectionModel().getSelections();
    	for (var i = 0, len = record.length; i < len; i++) {
        	var row = record[i];
            if (row.data['parameterLimitTypeDI'] == "") {
                Ext.example.msg("Please select Parameter Limit Type");
                return false;
            }
            if (row.data['parameterLimitTypeDI'] != 1 && row.data['limitValueDI'] == "") {
            	Ext.example.msg("Please enter Limit Value");
            	return false;
        	}
        	json += Ext.util.JSON.encode(row.data) + ',';
    	}
	    if (json != '') { 
	        json = json.substring(0, json.length - 1);
	    }
	    Ext.MessageBox.confirm('Confirm', "Please make sure that all required parameters are selected. Continue...?", function(btn) {
	    	if (btn == 'yes') {
		    Ext.MessageBox.show({
		        title: 'Please wait',
		        msg: 'Closing...',
		        progressText: 'Closing...',
		        width: 300,
		        progress: true,
		        closable: false
		});
    	outerPanel.getEl().mask();
    	Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/OBDAction.do?param=saveParameterSetting',
	        method: 'POST',
	        params: {
	            json: json,
	            vehicleModel: Ext.getCmp('vehicleModelComboId').getValue()
	        },
	        success: function(response, options) {
	        	Ext.example.msg(response.responseText);
	        	store.reload();
	            outerPanel.getEl().unmask();
	            json = "";
	        },
	        failure: function() {
	            outerPanel.getEl().unmask();
	            store.reload();
	            json = "";
	        }
    	});
    	Ext.MessageBox.hide();
    	}
    	});
	}
	function deleteData() {
	    grid.store.reload();
	}
	function limitTypeRenderer(value, p, r) {
	    var returnValue = "";
	    var idx = limitTypeCombostore.findBy(function(record) {
	        if (record.get('typeId') == value) {
	            returnValue = record.get('typeName');
	            return true;
	        }
	    });
	    //r.data['consigneeStr']=returnValue;
	    return returnValue;
	}
	grid.on({
		beforeedit: function (e){
		},
		afteredit: function(e) {
	    }
	});

	function onCellClick(grid, rowIndex, columnIndex, e) {
		var r = grid.store.getAt(rowIndex);
	
	}
	var UGrid = function() {
	    return {
	        init: function() {
	            grid.on({
	                "cellclick": {
	                    fn: onCellClick
	                }
	            });
	        },
	        getDS: function() {
	            return store;
	        }
	    } // END OF RETURN
	}(); // END OF UGrid
	var notePanel = new Ext.Panel({
    	id: 'notePanelId',
        standardSubmit: true,
        collapsible: false,
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [{
        	html:'<div style="font-weight:bold;color:black;font-size:13px;margin:10px 0px 5px 0px;">Note :- For Limit Types (i)Range : enter values like (min value - max value) Ex: 20-90 (ii)ON/OFF : enter On or Off (iii)OPEN / CLOSE : enter Open or Close</b></div>'
        }]  	
    });
	Ext.onReady(UGrid.init, UGrid, true);

	Ext.onReady(function() {
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    outerPanel = new Ext.Panel({
	        title: 'Parameter Configuration',
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        cls: 'outerpanel',
	        height: 550,
	        width: screen.width - 17,
	        items: [Panel, grid, notePanel]
	    });
	    store.on('load', function(){
		for(var i = 0; i < grid.getStore().data.length; i++){
			var record = grid.getStore().getAt(i);
			if(parseInt(record.data['UIDDI']) > 0){
			var row = store.findExact('UIDDI', record.data['UIDDI']);
				grid.getSelectionModel().selectRow(row,true);
			} 
		}
		});
	});
	</script>
	   
	<jsp:include page="../Common/footer.jsp" />
	 <!-- </body>   -->
<!-- </html> -->
<%}%>
