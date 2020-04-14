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
<!--
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>-->
	<jsp:include page="../Common/header.jsp" />
	<title>Vehicle RS232 Setting</title>
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
	.x-panel-header{
   height: 6% !important;
}
	</style>
	<!--</head>
	
	 <body> -->
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.x-layer ul {
				min-height: 27px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
		</style>
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

	var categoryCombostore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/rs232AssociationAction.do?param=getCategoryList',
   	 	id: 'categoryCombostoreId',
    	root: 'categoryCombostoreRoot',
    	autoLoad: false,
	    fields: ['typeName']
	});
	var categoryCombo = new Ext.form.ComboBox({
	    store: categoryCombostore,
	    id: 'categoryComboId',
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
	    valueField: 'typeName',
	    displayField: 'typeName',
	   	multiSelect:true,
		beforeBlur: Ext.emptyFn,
	    listeners: {
	        select: {
	            fn: function() {			
	            }
	        }
	    }
	});


	var ioTypeCombostore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/rs232AssociationAction.do?param=getIOTypeList',
   	 	id: 'ioTypeCombostoreId',
    	root: 'ioTypeCombostoreRoot',
    	autoLoad: false,
	    fields: ['ioTypeName']
	});
	var ioTypeCombo = new Ext.form.ComboBox({
	    store: ioTypeCombostore,
	    id: 'ioTypeComboId',
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
	    valueField: 'ioTypeName',
	    displayField: 'ioTypeName',
	   	multiSelect:true,
		beforeBlur: Ext.emptyFn,
	    listeners: {
	        select: {
	            fn: function() {			
	            }
	        }
	    }
	});

	var vehicleNoStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/rs232AssociationAction.do?param=getVehicleList',
	    id: 'vehicleNoStoreId',
	    root: 'VehicleNoRoot',
	    autoLoad: true,
	    fields: ['vehicleNo','unitType', 'unitNo']
	});
	
	var vehicleNoCombo = new Ext.form.ComboBox({
                   frame:true,
                  store: vehicleNoStore,
                  id:'vehicleNoComboId',
                  width: 175,
                  forceSelection:true,
                  enableKeyEvents:true,
                  mode: 'local',
                  hidden:false,
                  anyMatch:true,
                  onTypeAhead:true,
                  triggerAction: 'all',
                  displayField: 'vehicleNo',
                  valueField: 'vehicleNo', 
                  emptyText:'Select vehicle No',
                  cls: 'selectstylePerfect',
                  listeners: {
                           select: {
                                fn:function(){
                                var row = vehicleNoStore.findExact('vehicleNo',Ext.getCmp('vehicleNoComboId').getValue());
                                var rec = vehicleNoStore.getAt(row);
                                store.load({
	                params:{
	                	vehicleNo: Ext.getCmp('vehicleNoComboId').getRawValue(),
	                	unitTypeCode:rec.data['unitType']
	                }});
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
	        columns: 4
	    },
	    items: [{width: 50},{
	        xtype: 'label',
	        text: 'Vehicle Number ' + ' :',
	        cls: 'labelstyle',
	        id: 'vehicleMakeLblId'
	    },{width: 30}, vehicleNoCombo]
	});
	
	var reader = new Ext.data.JsonReader({
	    idProperty: 'associationDetailsRootId',
	    root: 'associationDetailsRoot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'UIDDI'
	    }, {
	        name: 'inputDI'
	    }, {
	        name: 'ioTYPE'
	    }, {
	        name: 'categoryDI'
	    }, {
	        name: 'sensorDI'
	    }]
	});

	var store = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/rs232AssociationAction.do?param=getAssociationDetails',
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
	        type: 'string',
	        dataIndex: 'inputDI'
	    }, {
	        type: 'string',
	        dataIndex: 'ioTYPE'
	    }, {
	    	type: 'string',
	        dataIndex: 'categoryDI'
	    }, {
	    	type: 'string',
	        dataIndex: 'sensorDI'
	    }]
	});
	
	var createColModel = function(finish, start) {
	    var columns = [
	        new Ext.grid.RowNumberer({
	            header: "<span style=font-weight:bold;>Sl No</span>",
	            width: 40
	        }),{
	            dataIndex: 'UIDDI',
	            hidden: true,
	            header: "<span style=font-weight:bold;>UID</span>",
	            filter: {
	                type: 'int'
	            }
	        }, {
	            dataIndex: 'inputDI',
	            header: "<span style=font-weight:bold;>Input Elements</span>",
	            filter: {
	                type: 'string'
	            },
	            width:60
	        },{
	            dataIndex: 'ioTYPE',
	            header: "<span style=font-weight:bold;>IO Type</span>",
	            filter: {
	                type: 'string'
	            },
	            width:60,
	            editor: new Ext.grid.GridEditor(ioTypeCombo)
	        }, {
	            header: "<span style=font-weight:bold;>Input Category</span>",
	            dataIndex: 'categoryDI',
	            width: 60,
	            sortable: true,
	            filter: {
	                type: 'string'
	            },
	            editor: new Ext.grid.GridEditor(categoryCombo)
	        },
	        {
	            header: "<span style=font-weight:bold;>Sensor Id</span>",
	            dataIndex: 'sensorDI',
	            width: 60,
	            sortable: true,
	            filter: {
	                type: 'string'
	            },
	           editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                autoCreate: {
                tag: "input",
                maxlength: 25,
                type: "text",
                size: "25",
                autocomplete: "off"
	            },
	            allowBlank: true
	            
	          }))
	        }
	    ];
	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),
	        defaults: {
	            sortable: true
	        }
	    });
	};
	
	grid = getEditorGrid('', 'No Records Found', store, 1330, 430, 32, filters, 'Clear Filter Data', false, '', 32, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Save', true, 'Refresh');

	function addRecord() {
	    if(Ext.getCmp('vehicleNoComboId').getValue() == ""){
	    	Ext.example.msg("Please select Vehicle Number");
            return false;
	    }
	    var index = vehicleNoStore.find('vehicleNo',Ext.getCmp('vehicleNoComboId').getRawValue());
		var rec = vehicleNoStore.getAt(index);
		var unitNo = rec.data['unitNo'];
	    
	    var json = '';
    	for (var i = 0, len = grid.getStore().data.length; i < len; i++) {
        	var row = grid.getStore().getAt(i);
        	if(row.data['ioTYPE'] == ''){
        		Ext.example.msg("Please select IO-TYPE");
            	return false;
        	}
        	
        	if(row.data['ioTYPE'] == 'NA' && row.data['categoryDI'] != 'NA'){
        		
            	Ext.example.msg("If IO Type is NA, then Input Category should also be NA");
        		return false;
        	}
        	if(row.data['ioTYPE'] != 'NA' && row.data['categoryDI'] == 'NA'){
        		
            	Ext.example.msg("If Input Category is NA, then IO Type should also be NA");
        		return false;
        	} 
        	
        	var inputIdData = row.data['inputDI'].substring(0, 7);
        	if((inputIdData == 'ONEWIRE' && row.data['categoryDI'] != 'NA' ) && (row.data['sensorDI'] == 'NA' || row.data['sensorDI'] == '') ){
        		Ext.example.msg("If Input Element is ONEWIRE and Input Category is not NA , then Sensor Id should not be NA or empty");
        		return false;
        	}
        	
            json += Ext.util.JSON.encode(row.data) + ',';
    	}
	    if (json != '') { 
	        json = json.substring(0, json.length - 1);
	    }
			
	    Ext.MessageBox.confirm('Confirm', "Do you want to save this setting?", function(btn) {
	    	if (btn == 'yes') {
		    Ext.MessageBox.show({
		        title: 'Please wait',
		        msg: 'Precessing...',
		        progressText: 'Processing...',
		        width: 300,
		        progress: true,
		        closable: false
		});
    	outerPanel.getEl().mask();
    	Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/rs232AssociationAction.do?param=saveAssociation',
	        method: 'POST',
	        params: {
	            json: json,
	            vehicleNo : Ext.getCmp('vehicleNoComboId').getRawValue(),
	            unitNo : unitNo
	        },
	        success: function(response, options) {
		        if(response.responseText == 'Success'){
		        	Ext.example.msg("Settings saved successfully");
		        	store.reload();
		        }else if(response.responseText == 'Error'){
		        	Ext.example.msg("Something went wrong. Please check your connection or re-login.");	
		        	store.reload();
		        }else{
		        	Ext.example.msg(response.responseText);
		        }
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
	function modifyData() {
	    grid.store.reload();
	}
	grid.on({
		beforeedit: function (e){
			categoryCombostore.load({
				params:{
					type : e.record.data['inputDI']
				}
			});
			ioTypeCombostore.load({
				params:{
					type : e.record.data['ioTYPE']
				}
			});
		},
		afteredit: function(e) {
	    }
	});

	function onCellClick(grid, rowIndex, columnIndex, e) {
		var r = grid.store.getAt(rowIndex);
		categoryCombostore.load({
			params:{
				type : r.data['inputDI']
			}
		});
		ioTypeCombostore.load({
			params:{
				type : r.data['ioTYPE']
			}
		});
		
		var inputIdData = r.data['inputDI'].substring(0, 7);
		if(inputIdData == "ONEWIRE"){
    		grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sensorDI')].editable = true;
		}else{
			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sensorDI')].editable = false;
		}
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

	Ext.onReady(UGrid.init, UGrid, true);

	Ext.onReady(function() {
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    outerPanel = new Ext.Panel({
	        title: 'Vehicle Sensors Association',
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        cls: 'outerpanel',
	        height: 550,
	        width: screen.width - 17,
	        items: [Panel, grid]
	    });
	});
	</script>
	 <jsp:include page="../Common/footer.jsp" />
	 <!-- </body>   -->
<!-- </html> -->
<%}%>
