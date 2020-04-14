<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
    
    <title>MD Route Master</title>
    
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
.selectstylePerfectGrid{
	 height:20px;
	 width:230px !important;	
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
		.x-menu-list {
			height:auto !important;
		}
		.x-btn-text-icon .x-btn-icon-small-left .x-btn-text {
			font-size: 15px !important;	
		}	
		.footer {
			bottom : -5px !important;
		}
   </style>
   <%}%>
<script>
	var outerPanel;
    var jspName = "MD_Route_Master";
	var exportDataType = "int,int,string,string,string,int,string,int";
	var grid;
	var store;
    var myWin;
	var editedRows = "";
	var regExp = /^([01]\d|2[0-3]):?([0-5]\d)$/;
   	var btnValue;
   	
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
            dataIndex: 'routeNameDI'
        },{
            type: 'string',
            dataIndex: 'sourceDI'
        },{
            type: 'string',
            dataIndex: 'depTimeDI'
        },{
            type: 'numeric',
            dataIndex: 'pointsDI'
        },{
            type: 'string',
            dataIndex: 'statusDI'
        },{
        	type: 'int',
        	dataIndex: 'bufferDI'
        }]
	}); 
    
	var reader = new Ext.data.JsonReader({
    	idProperty: 'routeMasterId',
        root: 'routeMasterDetailsRoot',
        totalProperty: 'total',
        fields: [{
	        name: 'UIDDI'
	    },{
        	name: 'slnoDataIndex'
        },{
        	name: 'routeNameDI'
        },{
            name: 'sourceDI'
        },{
            name: 'depTimeDI'
        },{
            name: 'pointsDI'
        },{
            name: 'statusDI'
        },{
        	name: 'bufferDI'
        }]
	});    
    
	var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getRouteMasterDetails&jspName='+jspName+'',
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
        	header: "<span style=font-weight:bold;>Route Name</span>",
            dataIndex: 'routeNameDI',
            hidden: false,
            width: 230,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Source</span>",
            dataIndex: 'sourceDI',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Source Dep Time</span>",
            hidden: false,
            width:160,
            dataIndex: 'depTimeDI',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>No. of Distribution Points</span>",
            hidden: false,
            width:170,
            dataIndex: 'pointsDI',
            filter: {
                type: 'float'
            }
        },{
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusDI',
            hidden: false,
            width: 160,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Permitted Buffer</span>",
            hidden: true,
            width:170,
            dataIndex: 'bufferDI',
            filter: {
                type: 'int'
            }
        }];
    	return new Ext.grid.ColumnModel({
        	columns: columns.slice(start || 0, finish),
        	defaults: {
            	sortable: true
        	}
    	});
	};  
	
	var grid = getGrid('Milk Distribution Route Master Details', 'No Records Found', store, screen.width - 30, 545, 10, filters, 'ClearFilterData', false,'', 11, false, '', false, 'View',true, 'Excel', jspName, exportDataType, true, 'pdf',true,'Add',true,'Modify',false,'Delete',false,'Close',true,'');
   	
	var distributionPointComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getDistributionPointNames',
	    id: 'distributionPointId',
	    root: 'distributionPointRoot',
	    autoLoad: true,
	    fields: ['sourceId','sourceName']
    });

	var distributionPointCombo = new Ext.form.ComboBox({
	    store: distributionPointComboStore,
	    id: 'distributionPointComboId',
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
	    valueField: 'sourceId',
	    displayField: 'sourceName',
	    cls: 'selectstylePerfectGrid',
	    width: 250,
	    listeners: {
	        select: {
	            fn: function() {}
	        }
	    }
	});
   	var sourceComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getSourceLocationName',
	    id: 'sourceComboStoreId',
	    root: 'sourceComboRoot',
	    autoLoad: true,
	    fields: ['sourceId','sourceName']
    });

	var sourceCombo = new Ext.form.ComboBox({
	    store: sourceComboStore,
	    id: 'sourceComboId',
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
	    valueField: 'sourceId',
	    displayField: 'sourceName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {}
	        }
	    }
	});
   	var mainPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 98,
	    width: 910,
	    frame: true,
	    id: 'mainPanelId',
	    layout: 'table',
	    layoutConfig: {
	        columns: 11
	    },
	    items:[{width:10},{
		xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryRouteNameId'    	
	    },{
        xtype: 'label',
        text: 'Route Name' + ' :',
        cls: 'labelstyle',
        id: 'routeNameLblId'
        },{width:20},{
        xtype: 'textfield',
        text: '',
        cls: 'selectstylePerfect',
        id: 'routeNameId'
        },{width:40},{
		xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: ''    	
	    },{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: ''
        },{width:20},{
        xtype: 'textfield',
        hidden: true,
        text: '',
        cls: 'selectstylePerfect',
        id: ''
        },{height:30},{width:10},{
		xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatorySourceId'    	
	    },{
        xtype: 'label',
        text: 'Source' + ' :',
        cls: 'labelstyle',
        id: 'sourceLblId'
        },{width:20},sourceCombo,{width:40},{
		xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: ''    	
	    },{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: ''
        },{width:20},{
        xtype: 'textfield',
        hidden: true,
        text: '',
        cls: 'selectstylePerfect',
        id: ''
        },{height:30},{width:10},{
		xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatorySourceDepId'    	
	    },{
        xtype: 'label',
        text: 'Source Dep Time' + ' : (HH:MM)',
        cls: 'labelstyle',
        id: 'sourceDepLblId'
        },{width:20},{
        xtype: 'textfield',
        text: '',
        cls: 'selectstylePerfect',
        id: 'sourceDepId'
        },{width:40},{
		xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: ''    	
	    },{
        xtype: 'label',
        text: 'Permitted Buffer (+/-)'+' : (min)',
        cls: 'labelstyle',
        id: 'permittedBufferLblId'
        },{width:20},{
        xtype: 'numberfield',
        text: '',
        cls: 'selectstylePerfect',
        id: 'permittedBfrId',
        allowNegative: false,
        allowBlank: false,
        allowDecimals: false
        }]
	    });
	
	var addGridReader = new Ext.data.JsonReader({
    	idProperty: 'addGridReaderId',
        root: 'addGridStoreRoot',
        totalProperty: 'total',
        fields: [{
        name: 'slNoDI'
        },{
        name: 'UIDDI'
        },{
        name: 'distributionPointDI'
        },{
        name : 'locationNameDI'
        },{
        name: 'arrivalTimeDI'
        },{
        name : 'permittedBufferDI'
        },{
        name: 'priorityDI'
        }]
    });
	var addGridStore = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getAddGridStore',
        bufferSize: 367,
        reader: addGridReader,
        root: 'rows',
        autoLoad: false,
        remoteSort: true
    });
    var addGridFilters = new Ext.ux.grid.GridFilters({
    	local: true,
        filters: [{
        type: 'int',
        dataIndex: 'slNoDI'
        },{
        type: 'int',
        dataIndex: 'UIDDI'
        },{
	    type: 'string',
	    dataIndex: 'permittedBufferDI'
	    },{
	    type: 'string',
	    dataIndex : 'locationNameDI'
	    },{
	    type: 'string',
	    dataIndex: 'arrivalTimeDI'
	    },{
	    type: 'numeric',
	    dataIndex: 'permittedBufferDI'
	    },{
	    type: 'int',
	    dataIndex: 'priorityDI'
	    }]
	});    
    function getcmnmodel() {
    	toolGridColumnModel = new Ext.grid.ColumnModel([
        	new Ext.grid.RowNumberer({
            header: '<B>SLNO</B>',
            width: 45,
            hidden:true
            }),{
            header: "<span style=font-weight:bold;>SLNO</span>",
        	dataIndex: 'slNoDI',
            hidden: true,
            width: 200	
            },{
            header: "<span style=font-weight:bold;>UID</span>",
        	dataIndex: 'UIDDI',
            hidden: true,
            width: 200	
            },{
            header: '',
            sortable: true,
            width: 150,
            dataIndex: 'distributionPointDI',
            editable: false
			},{
            header: '<B>Sequence</B>',
            sortable: true,
            width: 90,
            dataIndex: 'priorityDI',
            editable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false, 
            	allowDecimals:false,
            	cls: 'bskExtStyle'
            }))
			},{
            header: '<B>Location Name</B>',
            width: 255,
            dataIndex: 'locationNameDI',
            editor: new Ext.grid.GridEditor(distributionPointCombo),
            renderer: locationRenderer
            },{
            header: '<B>Scheduled Arrival Time (HH:MM)</B>',
            width: 200,
            dataIndex: 'arrivalTimeDI',
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({cls: 'bskExtStyle'}))
            }, {
            header: '<B>Permitted Buffer (+/-)(min)</B>',
            width: 180,
            dataIndex: 'permittedBufferDI',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
            	allowDecimals:false,
            	cls: 'bskExtStyle'
            }))
            }
        ]);
    	return toolGridColumnModel;
	}
	function locationRenderer(value, p, r) {
  		var returnValue="";
 		if(distributionPointComboStore.isFiltered()){
			distributionPointComboStore.clearFilter();
		}
       	var idx = distributionPointComboStore.findBy(function(record) {
  			if(record.get('sourceId') == value) {
      			returnValue = record.get('sourceName');
      			return true;
  			}
		});
		r.data['locationNameStr'] = returnValue;
		return returnValue;
	}    
	var addGrid = new Ext.grid.EditorGridPanel({
    	id: 'addGridId',
        ds: addGridStore,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: 900,
        height: 355,
        autoScroll: true,
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        bbar: new Ext.Toolbar({})
        
	});
	
	var innerWinButtonPanel = new Ext.Panel({
	    id: 'innerWinButtonPanelId',
	    standardSubmit: true,
	    collapsible: false,
	    autoHeight: true,
	    height: 70,
	    width:910,
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
	                	if(Ext.getCmp('routeNameId').getValue().trim() == ""){
	                		Ext.example.msg("Please enter Route Name");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
	                	if(Ext.getCmp('sourceComboId').getValue() == ""){
	                		Ext.example.msg("Please select a Source");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
	                	if(Ext.getCmp('sourceDepId').getValue() == ""){
	                		Ext.example.msg("Please enter Source Departure Time");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
	                	var trueOrFalse = regExp.test(Ext.getCmp('sourceDepId').getValue());
	                	if(trueOrFalse == false){
	                		Ext.example.msg("Please enter Source Departure Time in HH:MM format");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
	                	if(Ext.getCmp('permittedBfrId').getValue() == ""){
	                		Ext.example.msg("Please enter Source Permitted Buffer Time in mins");
	                		Ext.getCmp('saveButtonId').enable();
	                		return;
	                	}
<!--	                	if(editedRows == ""){-->
<!--	                		Ext.example.msg("No row/s changed to save");-->
<!--	                		Ext.getCmp('saveButtonId').enable();-->
<!--	                		return;-->
<!--	                	}-->
	                	var routeId = 0;
	                	if(btnValue == 'Modify'){
	                		var selected = grid.getSelectionModel().getSelected();
	                		routeId = selected.get('UIDDI');
	                	}
	                	var json = '';
	                	var temp = editedRows.split(",");
	                	for(var i = 0;  i < temp.length; i++){
	          				var row = addGrid.store.find('slNoDI',temp[i]); 
	          				if(row == -1){
	          					continue;
	          				}
	          				var record = addGrid.store.getAt(row);
	          				if(record.data['priorityDI'] == "" || record.data['priorityDI'] == "0"){
	          					Ext.example.msg("Please enter the Sequence more than 0");
	          					Ext.getCmp('saveButtonId').enable();
	                			return;
	          				}
	          				if(record.data['locationNameDI'] == ""){
	          					Ext.example.msg("Please select a Distribution Point");
	          					Ext.getCmp('saveButtonId').enable();
	                			return;
	          				}
	          				if(record.data['arrivalTimeDI'] == ""){
	          					Ext.example.msg("Please enter Scheduled arrival time");
	          					Ext.getCmp('saveButtonId').enable();
	                			return;
	          				}
	          				var trueOrFalseNew = regExp.test(record.data['arrivalTimeDI']);
	                		if(trueOrFalseNew == false){
	                			Ext.example.msg("Please enter Scheduled Arrival Time in HH:MM format");
	                			Ext.getCmp('saveButtonId').enable();
	                			return;
	                		}
<!--	                		var srcDate = Ext.getCmp('sourceDepId').getValue().replace(':','.');-->
<!--	                		var destDate = record.data['arrivalTimeDI'].replace(':','.');-->
<!--	                		if(parseFloat(srcDate) > parseFloat(destDate)){-->
<!--	                			Ext.example.msg("Arrival Time should be greater than Source Departure time");-->
<!--	                			return;-->
<!--	                		}-->
	          				if(record.data['permittedBufferDI'] == ""){
	          					Ext.example.msg("Please enter Permitted Buffer Time in mins");
	          					Ext.getCmp('saveButtonId').enable();
	                			return;
	          				}
	          				json += Ext.util.JSON.encode(record.data) + ',';
	                	}
	                	if(json!=''){
							json = json.substring(0, json.length - 1);
						}
						var jsonTest = '';
						var locatonArray = [];
						var sequenceArray = [];
						for(var i = 0; i < addGrid.getStore().data.length; i++) {
				            var record1 = addGrid.getStore().getAt(i);
				            if(record1.data['locationNameDI'] != ""){
        						locatonArray.push(record1.data['locationNameDI']);
        					}
        					if(record1.data['priorityDI'] != ""){
        						sequenceArray.push(record1.data['priorityDI']);
        					}
				            jsonTest += Ext.util.JSON.encode(record1.data) + ',';
        				}
						for(var m = 0; m < locatonArray.length; m++){
							for(var n = m+1 ; n < locatonArray.length; n++){
								if(locatonArray[m] == locatonArray[n]){
									Ext.example.msg("Same Distribution Point has been selected multiple times");
									Ext.getCmp('saveButtonId').enable();
									return;
								}
							}
						}
						for(var m = 0; m < sequenceArray.length; m++){
							for(var n = m+1 ; n < sequenceArray.length; n++){
								if(sequenceArray[m] == sequenceArray[n]){
									Ext.example.msg("Same Sequence has been selected multiple times");
									Ext.getCmp('saveButtonId').enable();
									return;
								}
							}
						}
	                	Ext.Ajax.request({
				 		url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=saveRouteDetails',
						method: 'POST',
						params: {
							json : json,
							routeName: Ext.getCmp('routeNameId').getValue(),
							sourceHub: Ext.getCmp('sourceComboId').getValue(),
							sourceDep: Ext.getCmp('sourceDepId').getValue(),
							sourceBuffer: Ext.getCmp('permittedBfrId').getValue(),
							btnValue: btnValue,
							routeId: routeId
						},
						success:function(response, options){
							var message = response.responseText;
							if(message.trim() == "Error"){
								Ext.getCmp('saveButtonId').enable();
								Ext.example.msg("Same Distribution Point has been selected multiple times");
							}else if(message.trim() == "Error1"){
								Ext.getCmp('saveButtonId').enable();
								Ext.example.msg("Same Sequence has been selected multiple times");
							}else if(message.trim() == 'Route Error'){
								Ext.getCmp('saveButtonId').enable();
								Ext.example.msg("Selected Route Name already exists");
							}else{
								Ext.getCmp('saveButtonId').enable();
								Ext.example.msg(response.responseText);
 								myWin.hide();
 								store.reload();
 								editedRows = "";
							}
						}, // end of success
						failure: function(){
							 myWin.hide();
							 editedRows = "";
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
	                    editedRows= "";
	                    json = '';
	                    jsonTest = '';
	                    
	                }
	            }
	        }
	    }]
	});    
   	var milkDistributionPanelWindow = new Ext.Panel({
	    width:910,
	    height:550,
	    standardSubmit: true,
	    frame: true,
	    items: [mainPanel, addGrid, innerWinButtonPanel]
	});

	myWin = new Ext.Window({
	    title: "Milk Distribution Route Master",
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: false,
	    height: 550,
	    width: 920,
	    id: 'myWin',
	    items: [milkDistributionPanelWindow]
	});
   	function addRecord(){
   		btnValue = "Add";
   		myWin.show();
   		document.getElementById("sourceDepId").maxLength = 5;
   		addGridStore.load({
   			params:{btnValue:"Add", routeId: 0}
   		});
   		Ext.getCmp('routeNameId').enable();
   		Ext.getCmp('routeNameId').reset();
   		Ext.getCmp('sourceComboId').reset();
   		Ext.getCmp('sourceDepId').reset();
   		Ext.getCmp('permittedBfrId').reset();
   	}
   	function modifyData(){
   		btnValue = "Modify";
   		var selected = grid.getSelectionModel().getSelected();
   		if(selected == undefined || selected == 'Undefined'){
   			Ext.example.msg("Please select a record");
   			return;
   		}
   		myWin.show();
   		document.getElementById("sourceDepId").maxLength = 5;
   		Ext.getCmp('routeNameId').setValue(selected.get('routeNameDI'));
   		Ext.getCmp('routeNameId').disable();
   		Ext.getCmp('sourceComboId').setValue(selected.get('sourceDI'));
   		Ext.getCmp('sourceDepId').setValue(selected.get('depTimeDI'));
   		Ext.getCmp('permittedBfrId').setValue(selected.get('bufferDI'));
   		addGridStore.load({
   			params:{btnValue:"Modify", routeId: selected.get('UIDDI')}
   		});
   		
   	}
   	addGrid.on({
   		afteredit: function(e){
   			var field=e.field;
			var rec=e.record;
			var  slNo = e.record.data['slNoDI'];
			var temp=editedRows.split(",")
			isIn=0
			for(var i=0;i<temp.length;i++)
			{
				if(temp[i]==slNo)
				{
					isIn=1
				}
			}
			if(isIn==0)
			{
				editedRows = editedRows+slNo+",";
			}
   		}
   	});
   	function verifyFunction(){
   		var selected = grid.getSelectionModel().getSelected();
   		var UID = selected.get('UIDDI');
   		var status = selected.get('statusDI');
   		Ext.Ajax.request({
			url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=changeRouteStatus',
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
        height:555,
        width:screen.width-20,
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
    