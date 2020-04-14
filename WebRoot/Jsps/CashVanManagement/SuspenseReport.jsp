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
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();
int isLtsp = loginInfo.getIsLtsp();
CashVanManagementFunctions cvm = new CashVanManagementFunctions();
String toDate = cvm.setCurrentDateForReports(0)+" 23:59:59";
String fromDate = cvm.setCurrentDateForReports(6)+" 00:00:00";
String writeOffAuthority = "1";
if(isLtsp < 0){
	writeOffAuthority = cvm.getUserAuthority(systemId,userId,customerId,3); 
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Suspense Report</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
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
</style>
<body>
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
	<%} %>
	<jsp:include page="../Common/ExportJS.jsp" />
<script>
	var outerPanel;
    var jspName = "Suspense_Report";
	var exportDataType = "numeric,string,string,string,date,string,numeric,string,string";
	var buttonValue = '';  
	var grid;
	var store;
    var dtcur = datecur;
    var dtprev = twoDaysPrev;
    var closeWindow;
    var WriteOffAuthority = '<%=writeOffAuthority%>';
    var typeArray = [['Pending'], ['Closed']];
 	var typestore = new Ext.data.SimpleStore({
 		data: typeArray,
        autoLoad: true,
        remoteSort: false,
        fields: ['typeName']
    });	
    var typeCombo = new Ext.form.ComboBox({
        store: typestore,
        id: 'typeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Pending/Closed',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'typeName',
        displayField: 'typeName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                
                }
            }
        }
    });
    var startDate = new Ext.form.DateField({
        fieldLabel: '',
        width: 140,
        id: 'startdate',
        format: 'd-m-Y H:i:s',
        value: '<%=fromDate%>',
        menuListeners: {
            select: function (m, d) {
                this.setValue(d);
				store.load({params: {startDate: ''}});
            }
        }
    });

    var endDate = new Ext.form.DateField({
        fieldLabel: '',
        id: 'enddate',
        width: 140,
        format: 'd-m-Y H:i:s',
        value: '<%=toDate%>',
        menuListeners: {
            select: function (m, d) {
                this.setValue(d);
				store.load({params: {startDate: ''}});
            }
        }
    });
    
    var datePanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 14
        },
        height:50,
        items: [{width:40},{
            xtype: 'label',
            text: 'From Date :',
            width: 70,
            cls: 'labelstyle'
        },{width:10},startDate,{width: 60},{
            xtype: 'label',
            text: 'To Date :',
            width: 70,
            cls: 'labelstyle'
        },{width:10},endDate,{width:100},{
        	xtype: 'label',
        	text: 'Type',
        	width: 50,
        	cls: 'labelstyle'
        },{width:10},typeCombo,{width: 30},{
            text: 'View',
            xtype: 'button',
            width: 50,
            cls: 'bskExtStyle',
            listeners: {
                click: {
                    fn: function () {
                        if (Ext.getCmp('startdate').getValue() == "") {
                            Ext.example.msg("Please Select From Date");
                            Ext.getCmp('startdate').focus();
                            return;
                        }
                        if (Ext.getCmp('enddate').getValue() == "") {
                            Ext.example.msg("Please Select To Date");
                            Ext.getCmp('enddate').focus();
                            return;
                        } // end of if
                        if (DateCompare3(document.getElementById('startdate').value, document.getElementById('enddate').value) == false) {
							Ext.example.msg("To Date should be greater than From Date");
							return;
                        }

                        if (checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue())) {
                           Ext.example.msg("Difference between two days should be 1 month");
                            return;
                        }
                        if(Ext.getCmp('typeComboId').getValue() == ""){
                        	Ext.example.msg("Please select type");
                        	Ext.getCmp('typeComboId').focus();
                        	return;
                        }
						store.load({
                            params: {
                                startDate: Ext.getCmp('startdate').getValue(),
                                endDate: Ext.getCmp('enddate').getValue(),
                                type: Ext.getCmp('typeComboId').getValue()
                            }
                        });
                    } // end of function
                } // end of click
            } // end of listener
        }] // End of Items
    }); // End of DatePanel    
   	var filters = new Ext.ux.grid.GridFilters({
    	local: true,
        filters: [{
	        type: 'numeric',
	        dataIndex: 'UIDDI'
	    },{
        	type: 'numeric',
            dataIndex: 'slnoDataIndex'
        },{
        	type: 'numeric',
            dataIndex: 'customerIdIndex'
        },{
            type: 'string',
            dataIndex: 'customerDataIndex'
        },{
            type: 'string',
            dataIndex: 'tripsheetnoDataIndex'
        },{
            type: 'date',
            dataIndex: 'dateindex'
        },{
            type: 'string',
            dataIndex: 'routeindex'
        },{
            type: 'string',
            dataIndex: 'businessIdIndex'
       	},{
            type: 'string',
            dataIndex: 'businessTypeIndex'
       	},{     
            type: 'string',
            dataIndex: 'shortindex'
        },{  
       		type: 'string',
            dataIndex: 'excessindex'
        },{
        	type: 'string',
        	dataIndex: 'tripSheetDI'
        },{
        	type: 'string',
        	dataIndex: 'statusIndex'
        }]
	}); 
    
	var reader = new Ext.data.JsonReader({
    	idProperty: 'vaultdetailid1',
        root: 'getSuspenseReportRoot',
        totalProperty: 'total',
        fields: [{
	        name: 'UIDDI'
	    },{
        	name: 'slnoDataIndex'
        },{
        	name: 'customerIdIndex'
        },{
            name: 'customerDataIndex'
        },{
            name: 'tripsheetnoDataIndex'
        },{
            name: 'dateindex',
            type: 'date',
            format: getDateTimeFormat()
        },{
            name: 'routeindex'
        },{
            name: 'businessIdIndex'
        },{
            name: 'businessTypeIndex'
        },{
            name: 'shortindex'
        },{
            name: 'excessindex'
        },{
        	name: 'tripSheetDI'
        },{
        	name: 'statusIndex'
        }]
	});    
    
	var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	    url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getSuspenseReport',
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
            width: 200,
            filter: {
                type: 'numeric'
            }
        },{
        	header: "<span style=font-weight:bold;>CVS CustomerId</span>",
            dataIndex: 'customerIdIndex',
            hidden: true,
            filter: {
                type: 'int'
            }
        },{
            header: "<span style=font-weight:bold;>Customer</span>",
            dataIndex: 'customerDataIndex',
            hidden: false,
            width: 350,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Business ID</span>",
            hidden: false,
            width:350,
            dataIndex: 'businessIdIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Business Type</span>",
            hidden: false,
            width:350,
            dataIndex: 'businessTypeIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Trip No</span>",
            dataIndex: 'tripsheetnoDataIndex',
            hidden: false,
            width: 450,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'dateindex',
            hidden: false,
            width: 300,
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Route</span>",
            hidden: false,
            width:350,
            dataIndex: 'routeindex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Short</span>",
            hidden: false,
            width:200,
            dataIndex: 'shortindex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Excess</span>",
            hidden: false,
            width:200,
            dataIndex: 'excessindex',
            filter: {
                type: 'string'
            }
        },{
        	header: "<span style=font-weight:bold;>Trip Sheet No</span>",
            hidden: true,
            width:300,
        	dataIndex: 'tripSheetDI',
        	filter: {
                type: 'string'
            }
        },{
        	header: "<span style=font-weight:bold;>Status</span>",
            width:350,
        	dataIndex: 'statusIndex',
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
                                                                                                                                  
	var grid = getGrid('Suspense Details', 'No Records Found', store, screen.width - 40, 450, 14, filters, 'ClearFilterData', false,'', 11, false, '', true, 'View',false, 'Excel', jspName, exportDataType, false, 'pdf',false,'',false,'',false,'',false,'',true,'Settlement',true,'Close/Write Off');
   
	function verifyFunction(){
	var selected = grid.getSelectionModel().getSelected();
		if(selected == undefined || selected == 'undefined'){
			Ext.example.msg("Please select a record");
			return;
	}
	if(selected.get('statusIndex') == "PENDING"){
		Ext.example.msg("Only Pending to stttle records can be settled");
		return;
	}
	if(selected.get('statusIndex') == "SETTLED"){
		Ext.example.msg("Record is already settled");
		return;
	}
	Ext.getCmp('gridVerifyId').disable();
	var id = selected.get('UIDDI');	
	var cvsCustId = selected.get('customerIdIndex');
	var tripSheetNo = selected.get('tripSheetDI');
	
	Ext.MessageBox.confirm('Confirm', "Are you sure want to settle this record..?", function(btn) {
     if (btn == 'yes') {
		Ext.Ajax.request({
    	url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=settlement',
        method: 'POST',
        params: {
            uniqueId: id,
            cvsCustId : cvsCustId,
            tripSheetNo: tripSheetNo
        },
        success: function(response, options) {
        	Ext.getCmp('gridVerifyId').enable();
        	parent.Ext.example.msg(response.responseText);
            store.reload();
		},
        failure: function() {
        	Ext.getCmp('gridVerifyId').enable();
            Ext.example.msg("Error");
            store.reload();
        }
        });
	 }else{
	 	Ext.getCmp('gridVerifyId').enable();
	 }
	});
 	
   } 
   function columnchart(){
   		var selected = grid.getSelectionModel().getSelected();
		if(selected == undefined || selected == 'undefined'){
			Ext.example.msg("Please select a record");
			return;
		}
		var selected = grid.getSelectionModel().getSelected();
		var id = selected.get('UIDDI');		
		window.open("<%=request.getContextPath()%>/pdfForSuspenseReprint?uniqueId="+id+"");
    }
	function approveFunction(){
		var selected = grid.getSelectionModel().getSelected();
		if(selected == undefined || selected == 'undefined'){
			Ext.example.msg("Please select a record");
			return;
		}
		var uId = selected.get('UIDDI');
		var tripSheetNo = selected.get('tripSheetDI');
		var cvsCustId = selected.get('customerIdIndex');
		var typeId= Ext.getCmp('typeComboId').getValue()
		closeWindow = new Ext.Window({
        	title: "Close / Write Off",
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: true,maximizable: true,
        	buttonAlign: "center",
        	width:950,
        	height: 380,
        	id: 'dispenseId2',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/CloseOrWriteOffWindow.jsp?&uId=" + uId + "&tripSheetNo="+tripSheetNo+"&cvsCustId="+cvsCustId+"&typeId="+typeId+"'></iframe>",
            scripts: true,
            shim: false
       	});
       	closeWindow.show();
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
        height:510,
        width:screen.width-22,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [datePanel,grid]
  		});
	});   
    if(WriteOffAuthority == '1'){
		Ext.getCmp('gridVerifyId').enable();
		Ext.getCmp('gridApproveId').enable();
	}else{
		Ext.getCmp('gridVerifyId').disable();
		Ext.getCmp('gridApproveId').disable();
	}
</script>
</body>
</html>
    