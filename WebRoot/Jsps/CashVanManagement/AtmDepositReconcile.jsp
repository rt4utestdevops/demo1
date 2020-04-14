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
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();
int isLtsp = loginInfo.getIsLtsp();
int UniqueId = 0;
if(request.getParameter("UniqueId") != null && !request.getParameter("UniqueId").equals("")){
	UniqueId = Integer.parseInt(request.getParameter("UniqueId"));
}
String tripSheetNo = request.getParameter("TripSheetNo");
String customer = "";
String sealNo = "";
String totalAmount = "";
String date = "";
String customerType="";
String atmId = ""; 
String tripNo ="";
String cashType = "";
String routeId = "0";
CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();		
ArrayList<String> dataList = cvmFunc.getDataForReconcilation(systemId,customerId,tripSheetNo,UniqueId);
customer = dataList.get(0);
sealNo = dataList.get(1);
totalAmount = dataList.get(2);
date =dataList.get(3);
customerType=dataList.get(4);
atmId = dataList.get(5); 
tripNo =dataList.get(6);
cashType = dataList.get(7);
routeId  = dataList.get(9);
String businessId = dataList.get(12);

String reconcileHeadAuthority = "1";
if(isLtsp < 0){
	reconcileHeadAuthority = cvmFunc.getUserAuthority(systemId,userId,customerId,2);   
}

String SelectDate="Select_Date";
String AssetName="Asset_Name";
String SelectVendor="Select_Vendor";
String Date="Date";
String SLNO="SLNO";
String QRCode="QR_Code";
String AssetNumber="Asset_Number";
String VendorName="Vendor_Name";
String BranchName="Branch_Name";
String NoRecordsFound="No_Records_Found";
String Excel="Excel";
String buttonValue ="Reconcilation";

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    
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
.x-window-header .x-unselectable .x-window-draggable{
	height: 10px;
    padding-top: 3px !important;
} 
</style>
	<body>
	
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
	
	<%} %>
<script>
	var outerPanel;
	var denom5000;
	var denom2000;
	var denom1000;
	var denom500;
	var denom100;
	
	var reader = new Ext.data.JsonReader({
        root: 'atmRepRoot',
      	fields: [{
                name: 'DenominationDataIndex',
                type: 'int'
            }, {
                name: 'gernalDI',
                type: 'int'
            }, {
                name: 'gernalValueDI',
                type: 'int'
            }, {
                name: 'goodCashPysicalDI',
                type: 'int'
            },{
                name: 'goodCashPhysicalValueDI',
                type: 'int'
            }, {
                name: 'badPhysicalCashDI',
                type: 'int'
            }, {
                name: 'badPhysicalCashValueDI',
                type: 'int'
            }, {
                name: 'goodRejectedCashDI',
                type: 'int'
            },{
                name: 'goodRejectedCashValueDI',
                type: 'int'
            },{
	            name:'badRejectedDI',
	            type: 'int'
            },{
	            name:'badRejectedValueDI',
	            type: 'int'
            },{
	            name:'shortDI',
	            type: 'int'
            },{
	            name:'excessDI',
	            type: 'int'
            }]
    });

    var dataStoreForGrid = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getDenominationGrid',
        bufferSize: 367,
        reader: reader,
        root: 'rows',
        autoLoad: false,
        remoteSort: true
    });
	function getcmnmodel() {
    	toolGridColumnModel = new Ext.grid.ColumnModel([
        	new Ext.grid.RowNumberer({
            header: '<B>SLNO</B>',
            width: 45,
            hidden:true
            }),{
            header: '<B>Denominations</B>',
            sortable: true,
            width: 90,
            dataIndex: 'DenominationDataIndex',
            editable: false
			}, {
            header: '<B>As per Journal</B>',
            width: 90,
            dataIndex: 'gernalDI',
            editable: false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowDecimals:false,
            	allowNegative: false,
            	allowBlank: false,               
            	cls: 'bskExtStyle'
            }))
            },{
            header: '<B>Value</B>',
            width: 90,
            dataIndex: 'gernalValueDI',
            editable: false
            }, {
            header: '<B>Physical Good Cash Balance</B>',
            width: 140,
            dataIndex: 'goodCashPysicalDI',
            editable: false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
            	allowDecimals:false, 
            	cls: 'bskExtStyle'
            }))
            }, {
            header: '<B>Value</B>',
            width: 90,
            dataIndex: 'goodCashPhysicalValueDI',
            editable: false
        	},{
            header: '<B>Physical Bad Cash Balance</B>',
            width: 140,
            dataIndex: 'badPhysicalCashDI',
            editable: false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
            	allowDecimals:false, 
            	cls: 'bskExtStyle'
            }))
            },{
            header: '<B>Value</B>',
            width: 90,
            dataIndex: 'badPhysicalCashValueDI',
            editable: false
        	},{
            header: '<B>Rejected Good Cash Balance</B>',
            width: 150,
            dataIndex: 'goodRejectedCashDI',
            editable: false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
                allowDecimals:false, 
                cls: 'bskExtStyle'
            }))
           	},{
            header: '<B>Value</B>',
            width: 90,
            dataIndex: 'goodRejectedCashValueDI',
            editable: false
        	},{
            header: '<B>Rejected Bad Cash Balance</B>',
            width: 150,
            dataIndex: 'badRejectedDI',
            editable: false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
                allowDecimals:false, 
                cls: 'bskExtStyle'
            }))
           	},{
            header: '<B>Value</B>',
            width: 90,
            dataIndex: 'badRejectedValueDI',
            editable: false
        	}, {
            header: '<B>Short</B>',
            width: 70,
            dataIndex: 'shortDI',
            },{
            header: '<B>Excess</B>',
            width: 70,
            dataIndex: 'excessDI',
     		}
        ]);
    	return toolGridColumnModel;
	}

	var AssetGrid = new Ext.grid.EditorGridPanel({
    	id: 'toolGridid',
        ds: dataStoreForGrid,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: 1245,
        height: 265,
        autoScroll: true,
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        bbar: new Ext.Toolbar({})
        
	});
	
	AssetGrid.getBottomToolbar().add([
        '->', {
        	text: 'Save',
        	id: 'saveButtonId',
            handler: function() {
            saveFunction();    
    }
    }
    ]);
    
    function saveFunction(){
    	Ext.getCmp('saveButtonId').disable();
    	var json = '';
        for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
        	var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i); 
            json += Ext.util.JSON.encode(record.data) + ',';
        }
        Ext.Ajax.request({
        	url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=SaveForReconcilation',
            method: 'POST',
            params: {
            	json: json,
                tripNo:'<%=tripSheetNo%>',
                uniqueId:<%=UniqueId%>,
                customer:'<%=customer%>',
                atmId:'<%=atmId%>',
                businessId:'<%=businessId%>',
                date: '<%=date%>',
                tripId:'<%=tripNo%>'
            },
            success: function(response, options) {
            	Ext.getCmp('saveButtonId').enable();
            	var message = response.responseText;
            	if(message.trim() == "Error"){
            		parent.Ext.example.msg("Error while reconciling");
            		parent.store.reload();
    				parent.atmWindow.close();
			  		json = '';
            	}else{
            		parent.Ext.example.msg("Reconciled successfully");
            		var pageName = "atmDeposit";
            		parent.open("<%=request.getContextPath()%>/pdfForReconcile?pageName="+ pageName +"");
            		parent.store.reload();
    				parent.atmDepositWindow.close();
			  		json = '';
            	}
			},
            failure: function() {
            	Ext.getCmp('saveButtonId').enable();
            	Ext.example.msg("Error");
                parent.store.reload();
    			parent.atmDepositWindow.close();
		   		json = '';
            }
        });
    }
	var UGrid = function() {
    return {
    init: function() {
    	AssetGrid.on({
        	"cellclick": {
            	fn: onCellClick
            }
       	});
    }
    }
    }();
                                        
	function  onCellClick (AssetGrid, rowIndex, columnIndex, e){
		var r = AssetGrid.store.getAt(rowIndex);
    	if('<%=reconcileHeadAuthority%>' == 1){
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('gernalDI')].editable = true;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('goodCashPysicalDI')].editable = true;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('badPhysicalCashDI')].editable = true;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('goodRejectedCashDI')].editable = true;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('badRejectedDI')].editable = true;
		}else{
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('gernalDI')].editable = false;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('goodCashPysicalDI')].editable = false;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('badPhysicalCashDI')].editable = false;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('goodRejectedCashDI')].editable = false;
			AssetGrid.getColumnModel().config[AssetGrid.getColumnModel().findColumnIndex('badRejectedDI')].editable = false;
		}
    }
	AssetGrid.on({
		afteredit: function(e) {
		var value= 0;
        var field = e.field;
        var denomination  = e.record.data['DenominationDataIndex'];
        
        if( field == "gernalDI" ){
	 	if(denomination == '5000'){
	 		value = e.record.data['gernalDI'] * 5000;	 
 		}else if(denomination == '2000'){
	 		value = e.record.data['gernalDI'] * 2000;	 
 		}else if(denomination == '1000'){
	 		value = e.record.data['gernalDI'] * 1000;	 
 		}else if(denomination == '500'){
	 		value = e.record.data['gernalDI'] * 500;	 
 		}else if(denomination == '100'){
	 		value = e.record.data['gernalDI'] * 100;	 
 		}
		e.record.set('gernalValueDI',value);
		}
		
		if( field == "goodCashPysicalDI" ){
		if(denomination == '5000'){
		value = e.record.data['goodCashPysicalDI'] * 5000;
		}else if(denomination == '2000'){
		value = e.record.data['goodCashPysicalDI'] * 2000;
		}else if(denomination == '1000'){
		value = e.record.data['goodCashPysicalDI'] * 1000;
		}else if(denomination == '500'){
		value = e.record.data['goodCashPysicalDI'] * 500;
		}else if(denomination == '100'){
		value = e.record.data['goodCashPysicalDI'] * 100;
		}
		e.record.set('goodCashPhysicalValueDI',value);
		}
		
		if( field == "badPhysicalCashDI" ){
		if(denomination == '5000'){
		value = e.record.data['badPhysicalCashDI'] * 5000;
		}else if(denomination == '2000'){
		value = e.record.data['badPhysicalCashDI'] * 2000;
		}else if(denomination == '1000'){
		value = e.record.data['badPhysicalCashDI'] * 1000;
		}else if(denomination == '500'){
		value = e.record.data['badPhysicalCashDI'] * 500;
		}else if(denomination == '100'){
		value = e.record.data['badPhysicalCashDI'] * 100;
		}
		e.record.set('badPhysicalCashValueDI',value);
	    } 
	    
		if( field == "goodRejectedCashDI" ){
		if(denomination == '5000'){
		value = e.record.data['goodRejectedCashDI'] * 5000;
		}else if(denomination == '2000'){
		value = e.record.data['goodRejectedCashDI'] * 2000;
		}else if(denomination == '1000'){
		value = e.record.data['goodRejectedCashDI'] * 1000;
		}else if(denomination == '500'){
		value = e.record.data['goodRejectedCashDI'] * 500;
		}else if(denomination == '100'){
		value = e.record.data['goodRejectedCashDI'] * 100;
		}
		e.record.set('goodRejectedCashValueDI',value);
		}
		
		if( field == "badRejectedDI" ){
		if(denomination == '5000'){
		value = e.record.data['badRejectedDI'] * 5000;
		}else if(denomination == '2000'){
		value = e.record.data['badRejectedDI'] * 2000;
		}else if(denomination == '1000'){
		value = e.record.data['badRejectedDI'] * 1000;
		}else if(denomination == '500'){
		value = e.record.data['badRejectedDI'] * 500;
		}else if(denomination == '100'){
		value = e.record.data['badRejectedDI'] * 100;
		}
		e.record.set('badRejectedValueDI',value);
		}
		setTimeout(function(){shortExcessCalculation(e,denomination)},500)
	}});
	function shortExcessCalculation(e,denomination){
		var denomTotal = e.record.data['goodCashPysicalDI'] + e.record.data['badPhysicalCashDI'] + e.record.data['goodRejectedCashDI'] + e.record.data['badRejectedDI'];	
		if(denomination == '5000'){
		if(denomTotal > e.record.data['gernalDI']){
			e.record.set('shortDI',0);
			e.record.set('excessDI',denomTotal - e.record.data['gernalDI']);
		}else if(denomTotal < e.record.data['gernalDI']){
			e.record.set('shortDI',e.record.data['gernalDI'] - denomTotal);
			e.record.set('excessDI',0);
		}else{
			e.record.set('shortDI',0);
			e.record.set('excessDI',0);
		}
		}else if(denomination == '2000'){
		if(denomTotal > e.record.data['gernalDI']){
			e.record.set('shortDI',0);
			e.record.set('excessDI',denomTotal - e.record.data['gernalDI']);
		}else if(denomTotal < e.record.data['gernalDI']){
			e.record.set('shortDI',e.record.data['gernalDI'] - denomTotal);
			e.record.set('excessDI',0);
		}else{
			e.record.set('shortDI',0);
			e.record.set('excessDI',0);
		}
		}else if(denomination == '1000'){
		if(denomTotal > e.record.data['gernalDI']){
			e.record.set('shortDI',0);
			e.record.set('excessDI',denomTotal - e.record.data['gernalDI']);
		}else if(denomTotal < e.record.data['gernalDI']){
			e.record.set('shortDI',e.record.data['gernalDI'] - denomTotal);
			e.record.set('excessDI',0);
		}else{
			e.record.set('shortDI',0);
			e.record.set('excessDI',0);
		}
		}else if(denomination == '500'){
		if(denomTotal > e.record.data['gernalDI']){
			e.record.set('shortDI',0);
			e.record.set('excessDI',denomTotal - e.record.data['gernalDI']);
		}else if(denomTotal < e.record.data['gernalDI']){
			e.record.set('shortDI',e.record.data['gernalDI'] - denomTotal);
			e.record.set('excessDI',0);
		}else{
			e.record.set('shortDI',0);
			e.record.set('excessDI',0);
		}
		}else if(denomination == '100'){
		if(denomTotal > e.record.data['gernalDI']){
			e.record.set('shortDI',0);
			e.record.set('excessDI',denomTotal - e.record.data['gernalDI']);
		}else if(denomTotal < e.record.data['gernalDI']){
			e.record.set('shortDI',e.record.data['gernalDI'] - denomTotal);
			e.record.set('excessDI',0);
		}else{
			e.record.set('shortDI',0);
			e.record.set('excessDI',0);
		}
		}
	}
	var clientPanel = new Ext.Panel({
    	standardView: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: false,
        width: 1170,
        height: 65,
        layoutConfig: {
            columns: 17
        },
        items: [{width:60},{
         	xtype: 'label',
            cls: 'labelstyle',
            id: 'CustomerLabelId',
            text: 'Customer' + ' :'
            },{width:10},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'customerId',
            text: '' ,
            width:200,
            readOnly:true
           	},{width:80},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'InwardModeLabelId',
            text: 'Inward Mode' + ' :'
            },{width:10},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'InwardModeLabelId2',
            width:200,
            text: 'TRIP' + ''
            },{width:80},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'TotalAmountLabelId',
            text: 'Total Amount' + ' :'
            },{width:10},{
            xtype: 'label',
            cls: 'labelstyle',
            width: 200,
            text: '',
            id: 'EnterTotalAmountId',
            labelSeparator: '',
            readOnly:true
			},{width:80},{
            xtype: 'label',
            text: 'Date' + ' :',
            cls: 'labelstyle',
            id: 'startdateId'
        	},{width:10}, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdate',
            text: '' ,
            width:200,
            readOnly:true
            },{height:30},{width:60},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'CustomerTypeLabelId',
            text: 'Business Type' + ' :'
            },{width:10},{
          	xtype: 'label',
            cls: 'labelstyle',
            text: '',
            width:200,
            allowBlank: false,
            id: 'CustomerTypeTextId',
            readOnly:true
			},{width:80},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'TripNoLabelId',
            text: 'Trip No' + ' :'
            },{width:10},{  
            xtype: 'label',
            cls: 'labelstyle',
            allowBlank: false,
            text: '',
            width:200,
            id: 'TripNoTextId',
            readOnly:true
            },{width:80},{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'ATMLabelId',
            text: 'Business ID' + ' :'
            },{width:10},{
          	xtype: 'label',
            cls: 'labelstyle',
            text: '',
            width:200,
            id: 'ATMIDTextId',
            readOnly:true
            }
        ]
    });

	Ext.onReady(UGrid.init, UGrid, true);
	Ext.onReady(function() {
    	Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            id: 'outerPanel',
            standardView: true,
            autoScroll: true,
            frame: true,
            border: false,
            width: 1260,
            height: 350,
            layout: 'table',
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel,AssetGrid]
        });
    dataStoreForGrid.load({params:{cvsbusinessId:'<%=atmId%>',uniqueId:'<%=UniqueId%>',businessId:'<%=businessId%>',btnValue:'atmDep'}}); 
	Ext.getCmp('customerId').setText('<%=customer%>');
	Ext.getCmp('EnterTotalAmountId').setText('<%=totalAmount%>'+' LKR');
	Ext.getCmp('startdate').setText('<%=date%>');
	Ext.getCmp('CustomerTypeTextId').setText('<%=customerType%>');
	Ext.getCmp('TripNoTextId').setText('<%=tripNo%>');
	Ext.getCmp('ATMIDTextId').setText('<%=atmId%>');
	});
</script>
</body>
</html>