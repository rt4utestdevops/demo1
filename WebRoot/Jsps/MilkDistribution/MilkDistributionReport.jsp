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
    
    <title>Milk Distribution Report</title>
    
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
.labelstyleMainPanel {
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

</style>

	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
	<%} %>
	<jsp:include page="../Common/ExportJS.jsp" />
	 <style>
			.x-panel-header
			{
				height: 7% !important;
			}		
			.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
				height: 26px !important;
				padding-top: 8px;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}			
		</style>
<script>
	var outerPanel;
    var jspName = "Milk_Distribution_Report";
	var exportDataType = "number,number,string,string,string,string,string,string,number,number,string,string,string,int";
	var grid;
	var store;
    var myWin;
   	var fromDate = datecur;
   	var jspNameViewGrid = "Distribution_Details";
   	var exportDataTypeViewGrid = "int,string,string,int,string,string,string,number";
   	
   	var vehicleComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getVehicleNos',
	    id: 'vehicleComboStoreId',
	    root: 'vehicleComboStoreRoot',
	    autoLoad: true,
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
		url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getActiveRoutes',
	    id: 'routeStoreId',
	    root: 'routeStoreRoot',
	    autoLoad: true,
	    fields: ['routeId','routeName']
	});

	var routeCombo = new Ext.form.ComboBox({
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
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'routeId',
	    displayField: 'routeName',
		cls: 'selectstylePerfect',
		listeners:{
		select: {
		fn: function(){
		}
		}
		}
	});
   	var selectPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 80,
	    width: 1340,
	    frame: true,
	    id: 'selectPanelId',
	    layout: 'table',
	    layoutConfig: {
	        columns: 13
	    },
	    items:[{width:200},{
	    xtype: 'label',
        text: 'From date' + ' :',
        cls: 'labelstyle',
        id: 'fromDateLblId'
	    },{
	    xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryFromDateId'   
	    },{width:10},{
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        format: getDateTimeFormat(),
        width: 60,
        id: 'fromDateId'
	    },{width:80},{
	    xtype: 'label',
        text: 'To date' + ' :',
        cls: 'labelstyle',
        id: 'toDateLblId'
	    },{
	    xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryToDateId'   
	    },{width:10},{
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        format: getDateTimeFormat(),
        width: 60,
        id: 'toDateId'
	    },{width:50},{width:50},{height:30},{width:200},{
	    xtype: 'label',
        text: 'Vehicle No' + ' :',
        cls: 'labelstyle',
        id: 'vehicleNoLblId'
	    },{
	    xtype: 'label',
        text: '',
        cls: 'mandatoryfield'   
	    },{width:10},vehicleCombo,{width:80},{
	    xtype: 'label',
        text: 'Route Name' + ' :',
        cls: 'labelstyle',
        id: 'routeNameLblId'
	    },{
	    xtype: 'label',
        text: '',
        cls: 'mandatoryfield'   
	    },{width:10},routeCombo,{width:80},{
	    xtype: 'button',
	    text: 'Show Results',
	    width: 50,
	    id: 'submitId',
	    listeners:{
	    click:{
	    fn: function(){
	    	if(Ext.getCmp('fromDateId').getValue() == ""){
	    		Ext.example.msg("Please select From Date");
	    		return;
	    	}
	    	if(Ext.getCmp('toDateId').getValue() == ""){
	    		Ext.example.msg("Please select To Date");
	    		return;
	    	}
	    	if(Ext.getCmp('vehicleComboId').getValue() != "" && Ext.getCmp('routeComboId').getValue() != ""){
	    		Ext.example.msg("Please select either Vehicle No or Route Name");
	    		return;
	    	}
	    	store.load({
	    	params:{
	    		fromDate: Ext.getCmp('fromDateId').getValue(),
	    		toDate: Ext.getCmp('toDateId').getValue(),
	    		routeName: Ext.getCmp('routeComboId').getValue(),
	    		vehicleNo: Ext.getCmp('vehicleComboId').getValue(),
	    		jspName: jspName
	    	}
	    	})
	    }}}
	    }]
	});
	    
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
            type: 'date',
            dataIndex: 'dateDI'
        },{
            type: 'string',
            dataIndex: 'routeNameDI'
        },{
            type: 'string',
            dataIndex: 'sourceDI'
        },{
            type: 'string',
            dataIndex: 'schdDepTimeDI'
        },{
            type: 'string',
            dataIndex: 'actualDepTime'
       	},{
            type: 'numeric',
            dataIndex: 'distrPtsDI'
       	},{     
            type: 'numeric',
            dataIndex: 'distanceDI'
        },{  
       		type: 'string',
            dataIndex: 'routeTimeDI'
        },{
        	type: 'string',
        	dataIndex: 'totalTimeDI'
        },{
        	type: 'string',
        	dataIndex: 'totalDelayDI'
        },{
        	type: 'float',
        	dataIndex: 'permittedBufferDI'
        }]
	}); 
    
	var reader = new Ext.data.JsonReader({
    	idProperty: 'milkDistributionReportId',
        root: 'milkDistributionReportRoot',
        totalProperty: 'total',
        fields: [{
	        name: 'UIDDI'
	    },{
        	name: 'slnoDataIndex'
        },{
        	name: 'vehicleNoDI'
        },{
            name: 'dateDI',
            type: 'date',
            dateFormat: getDateFormat()
        },{
            name: 'routeNameDI'
        },{
            name: 'sourceDI'
        },{
            name: 'schdDepTimeDI'
        },{
            name: 'actualDepTime'
        },{
            name: 'distrPtsDI'
        },{
            name: 'distanceDI'
        },{
            name: 'routeTimeDI'
        },{
        	name: 'totalTimeDI'
        },{
        	name: 'totalDelayDI'
        },{
        	name: 'permittedBufferDI'
        }]
	});    
    
	var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	    url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getDistributionReportDetails',
	    method: 'POST'
	    }),
	    autoLoad: false,
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
            width: 60,
            filter: {
                type: 'numeric'
            }
        },{
        	header: "<span style=font-weight:bold;>Vehicle No</span>",
            dataIndex: 'vehicleNoDI',
            filter: {
                type: 'string'
            },
            width:100
        },{
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'dateDI',
            width: 100,
            filter: {
                type: 'date'
            },
            renderer: Ext.util.Format.dateRenderer(getDateFormat())
        },{
            header: "<span style=font-weight:bold;>Route Name</span>",
            width:120,
            dataIndex: 'routeNameDI',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Source</span>",
            width:200,
            dataIndex: 'sourceDI',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Scheduled Dep Time</span>",
            dataIndex: 'schdDepTimeDI',
            width: 120,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Actual Dep Time</span>",
            dataIndex: 'actualDepTime',
            width: 120,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>No Of Distribution Pts</span>",
            dataIndex: 'distrPtsDI',
            width: 120,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Distance Travelled</span>",
            dataIndex: 'distanceDI',
            width: 120,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Scheduled Route Time</span>",
            dataIndex: 'routeTimeDI',
            width: 120,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Total Time Taken</span>",
            dataIndex: 'totalTimeDI',
            width: 120,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Total Delay</span>",
            dataIndex: 'totalDelayDI',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Permitted Buffer</span>",
            dataIndex: 'permittedBufferDI',
            width: 100,
            filter: {
                type: 'numeric'
            },
            hidden: true
        }];
    	return new Ext.grid.ColumnModel({
        	columns: columns.slice(start || 0, finish),
        	defaults: {
            	sortable: true
        	}
    	});
	};  
	
	var grid = getGrid('Milk Distribution Report', 'No Records Found', store, screen.width - 30, 458, 18, filters, '', false,'', 11, false, '', false, 'View',true, 'Excel', jspName, exportDataType, true, 'pdf',true,'Details',false,'Modify');
   	
   	var mainPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 120,
	    width: 1100,
	    frame: true,
	    id: 'mainPanelId',
	    layout: 'table',
	    layoutConfig: {
	        columns: 9
	    },
	    items:[{width:30},{
        xtype: 'label',
        text: 'Vehicle No' + ' :',
        cls: 'labelstyleMainPanel',
        id: 'vehicleNoLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'vehicleNoId'
        },{width:250},{
        xtype: 'label',
        text: 'Date'+ ' :',
        cls: 'labelstyleMainPanel',
        id: 'dateLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'dateId'
        },{height:30},{width:30},{
        xtype: 'label',
        text: 'Source'+ ' :',
        cls: 'labelstyleMainPanel',
        id: 'sourceLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'sourceId'
        },{width:250},{
        xtype: 'label',
        text: '',
        cls: 'labelstyleMainPanel',
        id: ''
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: ''
        },{height:30},{width:30},{
        xtype: 'label',
        text: 'Route Name' + ' :',
        cls: 'labelstyleMainPanel',
        id: 'routeNameLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'routeNameId'
        },{width:250},{
        xtype: 'label',
        text: 'Scheduled Dep Time'+ ' :',
        cls: 'labelstyleMainPanel',
        id: 'schdldDepLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'schdldDepId'
        },{height:30},{width:30},{
        xtype: 'label',
        text: 'Permitted Buffer' + ' :',
        cls: 'labelstyleMainPanel',
        id: 'permittedBufferLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'permittedBufferId'
        },{width:250},{
        xtype: 'label',
        text: 'Actual Dep Time'+' :',
        cls: 'labelstyleMainPanel',
        id: 'actualDepLblId'
        },{width:20},{
        xtype: 'label',
        text: '',
        cls: 'labelstyle',
        id: 'actualDepId'
        }]
	    });
	
	var viewGridReader = new Ext.data.JsonReader({
    	idProperty: 'viewGridReaderId',
        root: 'viewGridStoreRoot',
        totalProperty: 'total',
        fields: [{
        name: 'slNoDI'
        },{
        name: 'distributionPointDI'
        },{
        name : 'scheduledArrivalTimeDII'
        },{
        name: 'permittedBufferDI'
        },{
        name : 'actulaArrivalTimeDI'
        },{
        name : 'actulaArrivalVarianceDI'
        },{
        name : 'actulaDepartureTimeDI'
        },{
        name : 'tempDI'
        }]
    });
	var viewGridStore = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/milkDistributionAction.do?param=getDistributionPointDetails',
        bufferSize: 367,
        reader: viewGridReader,
        root: 'rows',
        autoLoad: false,
        remoteSort: true
    });
    var viewGridFilters = new Ext.ux.grid.GridFilters({
    	local: true,
        filters: [{
        type: 'numeric',
        dataIndex: 'slNoDI'
        },{
	    type: 'numeric',
	    dataIndex: 'distributionPointDI'
	    },{
	    type: 'string',
	    dataIndex : 'scheduledArrivalTimeDII'
	    },{
	    type: 'string',
	    dataIndex: 'permittedBufferDI'
	    },{
	    type: 'string',
	    dataIndex: 'actulaArrivalTimeDI'
	    },{
	    type: 'string',
	    dataIndex: 'actulaArrivalVarianceDI'
	    },{
	    type: 'string',
	    dataIndex: 'actulaDepartureTimeDI'
	    },{
	    type: 'numeric',
	    dataIndex: 'tempDI'
	    }]
	});    
    function getcmnmodel() {
    	toolGridColumnModel = new Ext.grid.ColumnModel([
        	new Ext.grid.RowNumberer({
            header: '<B>SLNO</B>',
            width: 45
            }),{
            header: "<span style=font-weight:bold;>SLNO</span>",
        	dataIndex: 'slNoDI',
            hidden: true,
            width: 200	
            },{
            header: '<B>Distribution Point Name</B>',
            sortable: true,
            width: 220,
            dataIndex: 'distributionPointDI'
			},{
            header: '<B>Scheduled Arrival Time</B>',
            width: 150,
            sortable: true,
            dataIndex: 'scheduledArrivalTimeDII'
            },{
            header: '<B>Permitted Buffer</B>',
            width: 130,
            sortable: true,
            dataIndex: 'permittedBufferDI'
            },{
            header: '<B>Actual Arrival Time</B>',
            width: 150,
            sortable: true,
            dataIndex: 'actulaArrivalTimeDI'
            },{
            header: '<B>Actual Arrival Variance</B>',
            width: 150,
            sortable: true,
            dataIndex: 'actulaArrivalVarianceDI'
            },{
            header: '<B>Actual Departure Time</B>',
            width: 150,
            sortable: true,
            dataIndex: 'actulaDepartureTimeDI'
            },{
            header: '<B>Temprature</B>',
            width: 80,
            sortable: true,
            dataIndex: 'tempDI'
            }
        ]);
    	return toolGridColumnModel;
	}
  
	var viewGrid = new Ext.grid.GridPanel({
    	id: 'viewGridId',
        ds: viewGridStore,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: 1100,
        height: 315,
        autoScroll: true,
        clicksToEdit: 1,
        plugins: [viewGridFilters],
        selModel: new Ext.grid.RowSelectionModel(),
        bbar: new Ext.Toolbar({})
        
	});
	
	var innerWinButtonPanel = new Ext.Panel({
	    id: 'innerWinButtonPanelId',
	    standardSubmit: true,
	    collapsible: false,
	    autoHeight: true,
	    height: 70,
	    width:1100,
	    frame: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 4
	    },
	    buttons: [{
	        xtype: 'button',
	        text: '',
	        id: 'pdfBtnId',
	        iconCls: 'pdfbutton',
	        listeners: {
	            click: {
	                fn: function() {
	                	getordreport('pdf','All',jspNameViewGrid,viewGrid,exportDataTypeViewGrid);
	         		}
	         	}
	         }
	    	},{
	        xtype: 'button',
	        text: '',
	        id: 'saveButtonId',
	        iconCls: 'excelbutton',
	        listeners: {
	            click: {
	                fn: function() {
	                	getordreport('xls','All',jspNameViewGrid,viewGrid,exportDataTypeViewGrid);
	         		}
	         	}
	         }
	    	},{
	        xtype: 'button',
	        text: 'Back',
	        id: 'canButtId',
	        cls: 'buttonstyle',
	        iconCls: 'backbutton',
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
	    width:1120,
	    height:540,
	    standardSubmit: true,
	    frame: true,
	    items: [mainPanel, viewGrid, innerWinButtonPanel]
	});

	myWin = new Ext.Window({
	    title: "Report Details",
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: false,
	    height: 540,
	    width: 1120,
	    id: 'myWin',
	    items: [milkDistributionPanelWindow]
	});
   	function addRecord(){
   		var selected = grid.getSelectionModel().getSelected();
   		if(selected == 'undefined' || selected == undefined){
   			Ext.example.msg("Please slect a record");
   			return;
   		}
   		viewGridStore.load({
  			params: {
  				tripId: selected.get('UIDDI'),
  				jspName: jspNameViewGrid,
  				vehicleNo: selected.get('vehicleNoDI'),
  				date: selected.get('dateDI').format('d-m-Y'),
  				source: selected.get('sourceDI'),
  				routeName: selected.get('routeNameDI'),
  				schldDepTime: selected.get('schdDepTimeDI'),
  				permittedBuffer: selected.get('permittedBufferDI')+' min',
  				actualDepTime: selected.get('actualDepTime') 
  			}
  		});
   		myWin.show();
  		Ext.getCmp('vehicleNoId').setText(selected.get('vehicleNoDI'));
  		Ext.getCmp('dateId').setText(selected.get('dateDI').format('d-m-Y'));
  		Ext.getCmp('sourceId').setText(selected.get('sourceDI'));
  		Ext.getCmp('routeNameId').setText(selected.get('routeNameDI'));
  		Ext.getCmp('schdldDepId').setText(selected.get('schdDepTimeDI'));
  		Ext.getCmp('permittedBufferId').setText(selected.get('permittedBufferDI')+' min');
  		Ext.getCmp('actualDepId').setText(selected.get('actualDepTime'));
   	}
	
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
        items: [selectPanel,grid]
  		});
	});   
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    