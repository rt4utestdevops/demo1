<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseafterview="''";
	String feature="1";
	if(session.getAttribute("responseafterview")!=null){
	   responseafterview="'"+session.getAttribute("responseafterview").toString()+"'";
		session.setAttribute("responseafterview",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}

%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>MD Trip Management</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
} 
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
.selectstylePerfect{
	 height:20px;
	 width:180px !important;	
	 listwidth:120px !important;
	 max-listwidth:120px !important;
	 min-listwidth:120px !important;
	 margin:0px 0px 5px 5px !important;
}
</style>

	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
	<%} %>
	<jsp:include page="../Common/ExportJS.jsp" />
	
    <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script>
  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>
	<% String newMenuStyle=loginInfo.getNewMenuStyle();
   if(newMenuStyle.equalsIgnoreCase("YES")){%>
	<style>
		.ext-strict .x-form-text {
		    height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
			height : 38px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		
		.x-btn-text-icon .x-btn-icon-small-left .x-btn-text {
			font-size: 15px !important;	
		}			
   </style>
   <%}%>
<script>
	var outerPanel;
    var jspName = "MD_Trip_Management";
	var exportDataType = "int,int,string,string,string";
	var grid;
	var store;
    var myWin;
    
   	var filters = new Ext.ux.grid.GridFilters({
    	local: true,
        filters: [{
	        type: 'numeric',
	        dataIndex: 'UIDDI'
	    },{
        	type: 'numeric',
            dataIndex: 'slnoDataIndex'
        },{
        	type: 'string',
            dataIndex: 'vehicleNoDI'
        },{
            type: 'string',
            dataIndex: 'routeNameDI'
        },{
            type: 'string',
            dataIndex: 'statusDI'
        }]
	}); 
    
	var reader = new Ext.data.JsonReader({
    	idProperty: 'tripGridId',
        root: 'tripDetailsRoot',
        totalProperty: 'total',
        fields: [{
	        name: 'UIDDI'
	    },{
        	name: 'slnoDataIndex'
        },{
        	name: 'vehicleNoDI'
        },{
            name: 'routeNameDI'
        },{
            name: 'statusDI'
        }]
	});    
    
	var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getTripDetails&jspName='+jspName+'',
	    method: 'POST'
	    }),
	    autoLoad: true,
	    reader: reader
	});    
    
    var createColModel = function (finish, start) {
    var columns = [
    	new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 60
        }),{
        	header: "<span style=font-weight:bold;>UID</span>",
            dataIndex: 'UIDDI',
            hidden: true,
            filter: {
                type: 'int'
            }
        },{
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	dataIndex: 'slnoDataIndex',
            hidden: true,
            width: 200,
            filter: {
                type: 'numeric'
            }
        },{
        	header: "<span style=font-weight:bold;>Vehicle No</span>",
            dataIndex: 'vehicleNoDI',
            hidden: false,
            width: 250,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Route Name</span>",
            dataIndex: 'routeNameDI',
            hidden: false,
            width: 250,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Status</span>",
            hidden: false,
            width:150,
            dataIndex: 'statusDI',
            filter: {
                type: 'string'
            }
        }];
    	return new Ext.grid.ColumnModel({
        	columns: columns.slice(start || 0, finish),
        	defaults: {
            	sortable: true
        	}
    	});
	};  
	
	var grid = getGrid('Milk Distribution Trip management', 'No Records Found', store, screen.width - 40, 535, 10, filters, 'ClearFilterData', false,'', 11, false, '', false, 'View',true, 'Excel', jspName, exportDataType, true, 'pdf',true,'Assign',false,'Modify',false,'Delete',false,'Close',true,'');
   	
	var vehicleComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getVehicleNos',
	    id: 'vehicleComboStoreId',
	    root: 'vehicleComboStoreRoot',
	    autoLoad: false,
	    fields: ['assetNo']
    });

	var vehicleCombo = new Ext.form.ComboBox({
	    store: vehicleComboStore,
	    id: 'vehicleComboId',
	    mode: 'local',
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
	    valueField: 'assetNo',
	    displayField: 'assetNo',
	    cls: 'selectstylePerfect',
	    width: 250,
	    listeners: {
	        select: {
	            fn: function() {}
	        }
	    }
	});
	var routeStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getActiveRoutesForTrip',
	    id: 'routeStoreId',
	    root: 'routeStoreRoot',
	    autoLoad: false,
	    fields: ['routeId','routeName']
	});

	var routeCombo = new Ext.ux.form.LovCombo({
		id:'routeComboId',	 
 		width:200,
		maxHeight:200,
		store: routeStore,
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
	    valueField: 'routeId',
	    displayField: 'routeName',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
		cls: 'selectstylePerfect',
		listeners:{
		select: {
		fn: function(){
		}
		}
		}
	});
   	var mainPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 90,
	    width: 350,
	    frame: true,
	    id: 'mainPanelId',
	    layout: 'table',
	    layoutConfig: {
	        columns: 6
	    },
	    items:[{width:10},{
		xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryVehicleId'    	
	    },{
        xtype: 'label',
        text: 'Vehicle No' + ' :',
        cls: 'labelstyle',
        id: 'vehicleLblId'
        },{width:30},vehicleCombo,{height:30},{width:10},{
		xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryRouteId'    	
	    },{
        xtype: 'label',
        text: 'Route Name' + ' :',
        cls: 'labelstyle',
        id: 'routeNameLblId'
        },{width:30},routeCombo]
	    });
	

	var innerWinButtonPanel = new Ext.Panel({
	    id: 'innerWinButtonPanelId',
	    standardSubmit: true,
	    collapsible: false,
	    autoHeight: true,
	    height: 70,
	    width:350,
	    frame: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 4
	    },
	    buttons: [{
	        xtype: 'button',
	        text: 'Save',
	        id: 'saveButtonId',
	        iconCls: 'savebutton',
	        cls: 'buttonstyle',
	        width: 70,
	        listeners: {
	            click: {
	                fn: function() {
	                	Ext.getCmp('saveButtonId').disable();
	                	if(Ext.getCmp('vehicleComboId').getValue() == ""){
	                		Ext.example.msg("Please select Vehicle No");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
	                	if(Ext.getCmp('routeComboId').getValue() == ""){
	                		Ext.example.msg("Please select Route Name");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
	                	Ext.Ajax.request({
				 		url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=saveTripDetails',
						method: 'POST',
						params: {
							vehicleNo: Ext.getCmp('vehicleComboId').getValue(),
							routeName: Ext.getCmp('routeComboId').getValue()
						},
						success:function(response, options){
							Ext.example.msg(response.responseText);
 							myWin.hide();
 							store.reload();
 							Ext.getCmp('saveButtonId').enable();
						}, // end of success
						failure: function(){
							 myWin.hide();
							 Ext.getCmp('saveButtonId').enable();
						}// end of failure
 						}); // end of Ajax
	         		}
	         	}
	         }
	    }, {
	        xtype: 'button',
	        text: 'Cancel',
	        id: 'canButtId',
	        cls: 'buttonstyle',
	        iconCls: 'cancelbutton',
	        width: 70,
	        listeners: {
	            click: {
	                fn: function() {
	                    myWin.hide();
	                }
	            }
	        }
	    }]
	});    
   	var milkDistributionPanelWindow = new Ext.Panel({
	    width:360,
	    height:200,
	    standardSubmit: true,
	    frame: true,
	    items: [mainPanel, innerWinButtonPanel]
	});

	myWin = new Ext.Window({
	    title: "Trip Assign",
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: false,
	    height: 200,
	    width: 360,
	    id: 'myWin',
	    items: [milkDistributionPanelWindow]
	});
   	function addRecord(){
   		myWin.show();
   		vehicleComboStore.load();
   		routeStore.load();
   		Ext.getCmp('vehicleComboId').reset();
   		Ext.getCmp('routeComboId').reset();
   	}
   	function verifyFunction(){
   		var selected = grid.getSelectionModel().getSelected();
   		var UID = selected.get('UIDDI');
   		var status = selected.get('statusDI');
   		Ext.Ajax.request({
			url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=changeStatus',
			method: 'POST',
			params: {
				status: status,
				UID: UID
			},
			success:function(response, options){
				Ext.example.msg(response.responseText);
 				store.reload();
			}, // end of success
			failure: function(){
			}// end of failure
 		}); // end of Ajax
   	}
   	
   	function onCellClick(grid, rowIndex, columnIndex, e) {
		var r = grid.store.getAt(rowIndex);
		if(r.data['statusDI'] == 'Active'){
        	Ext.getCmp('gridVerifyId').setText("Inactive");
        }else{
        	Ext.getCmp('gridVerifyId').setText("Active");
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
        renderTo: 'content',
        id: 'outerPanel',
        standardView: true,
        autoScroll: false,
        frame: true,
        border: true,
        height:550,
        width:screen.width-22,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [grid]
  		});
  		grid.store.on('load', function(store, records, options){
        	var selected = grid.getSelectionModel().getSelected();
        	if(selected.get('statusDI') == 'Active'){
        		Ext.getCmp('gridVerifyId').setText("Inactive");
        	}else{
        		Ext.getCmp('gridVerifyId').setText("Active");
        	}       
        });
	});   
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    