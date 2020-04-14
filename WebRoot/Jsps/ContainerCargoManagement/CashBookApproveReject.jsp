<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%@page import="t4u.functions.CommonFunctions"%>
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
	if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	}
	
	session.setAttribute("loginInfoDetails",loginInfo);
	}
	
	CommonFunctions cf = new CommonFunctions();
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
	
	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("SLNO");
	tobeConverted.add("Cash_Book_Approve_Reject");
	tobeConverted.add("Select_client");
	tobeConverted.add("UID");
	tobeConverted.add("Transaction_Date");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Select_Status");
	tobeConverted.add("Branch_Code");
	tobeConverted.add("Transaction_Type");
	tobeConverted.add("Amount");
	tobeConverted.add("Account_Header");
	tobeConverted.add("Description");
	tobeConverted.add("Bill_No");
	tobeConverted.add("Invoice");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Cleaner");
	tobeConverted.add("Driver");
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("Approve_Reject_Amount");
	tobeConverted.add("Enter_Approved_amount");
	tobeConverted.add("Approved_amount_Validation");
	tobeConverted.add("Approved_Amount_Should_Not_Be_Greater_Than_Zero");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Reject");
	tobeConverted.add("Approve");
	tobeConverted.add("Cancel");
	tobeConverted.add("BranchID");
	tobeConverted.add("Select_Branch");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SLNO = convertedWords.get(0);
	String cashBookApproveReject = convertedWords.get(1);
	String selectClient = convertedWords.get(2);
	String UID = convertedWords.get(3);;
	String transactionDate = convertedWords.get(4);
	String NoRecordsFound = convertedWords.get(5);
	String selectStatus = convertedWords.get(6);
	String branchCode = convertedWords.get(7);
	String transactionType = convertedWords.get(8);
	String amount = convertedWords.get(9);
	String accountHeader = convertedWords.get(10);
	String description = convertedWords.get(11);
	String billNo = convertedWords.get(12);
	String invoice = convertedWords.get(13);
	String vehicle = convertedWords.get(14);
	String cleaner = convertedWords.get(15);
	String driver = convertedWords.get(16);
	String startDate = convertedWords.get(17);
	String endDate = convertedWords.get(18);
	String EndDateMustBeGreaterthanStartDate = convertedWords.get(19);
	String monthValidation = convertedWords.get(20); 
	String approvedAmount = convertedWords.get(21);
	String enterApprovedAmount = convertedWords.get(22);
	String approvedAmountValidation = convertedWords.get(23);
	String approvedAmountShouldNotBeGreaterThanZero = convertedWords.get(24);
	String selectSingleRow = convertedWords.get(25);
	String reject = convertedWords.get(26);
	String approve = convertedWords.get(27);
	String cancel = convertedWords.get(28);
	String branchId = convertedWords.get(29);
	String selectBranch = convertedWords.get(30);
	
%>

<jsp:include page="../Common/header.jsp" />
    <title><%=cashBookApproveReject%></title>
  
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
    <jsp:include page="../Common/ExportJS.jsp" />
	<style>
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-layer ul {
		 	min-height:27px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-btn-text {
			font-size : 15px !important;
		}
	</style>
    
	<script>
	var jspName = 'Cashbook_Approval_Reject';
	var outerPanel;
	var ctsb;
	var exportDataType = "int,int,string,int,string,date,string,string,string,string,number,number,string,string";
	var dtnext = datenext;
	var dtcur = datecur;
	var titel;
	var globalClientId ;
	var uploadFileFlag = false;
	var custName = "";
	var myWinTitle = "";
	var myWin;

	var clientcombostore = new Ext.data.JsonStore({
              url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
              id: 'clientNameStoreId',
              root: 'CustomerRoot',
              autoLoad: true,
              remoteSort: true,
              fields: ['CustId', 'CustName']
          });
    clientcombostore.on('load', function() {
        if (clientcombostore.data.items.length == 1) {
            var rec = clientcombostore .getAt(0);
            Ext.getCmp('custcomboId').setValue(rec.data['CustId']);
            globalClientId = Ext.getCmp('custcomboId').getValue();
            custName = Ext.getCmp('custcomboId').getRawValue();
            branchStore.load({params: {custId: globalClientId}});
        }
    });
	
	var Client = new Ext.form.ComboBox({
	    store: clientcombostore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=selectClient%>',
	    blankText: '<%=selectClient%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'CustId',
	    displayField: 'CustName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {
	                globalClientId = Ext.getCmp('custcomboId').getValue();
	                custName = Ext.getCmp('custcomboId').getRawValue();
	                branchStore.load({params: {custId: globalClientId}});
	            }
	        }
	    }
	});
	
	  /******store for getting All branch List******/
   var branchStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAppRejAction.do?param=getBranchList',
				   id:'branchStoreId',
			       root: 'branchRoot',
			       autoLoad: false,
				   fields: ['BranchId','BranchName']
	});
//***** combo for All branch combo*************/
  var branchcombo = new Ext.form.ComboBox({
	        store: branchStore,
	        id:'branchComboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectBranch%>',
	        blankText :'<%=selectBranch%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'BranchId',
	    	displayField: 'BranchName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		          select: {
		              fn:function(){
  		}}}
  });
  
  //******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'cashBookReaderId',
        root: 'cashBookRoot',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {name: 'idIndex'},
        {name: 'branchCodeIndex'},
        {name: 'branchIdIndex'},
        {name: 'transactionTypeIndex'},
        {name: 'transactionDateIndex'},
        {name: 'accountHeaderIndex'},
        {name: 'vehicleIndex'},
        {name: 'driverIndex'},
        {name: 'cleanerIndex'},
        {name: 'amountIndex'},
        {name: 'appAmountIndex'},
        {name: 'descriptionIndex'},
        {name: 'billNoIndex'}
        ]
    });

//************************* store configs
	var store =  new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/CashBookAppRejAction.do?param=getCashBookDetails',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: {
            field: 'transactionDateIndex',
            direction: 'ASC'
        },
        storeId: 'cashBookStore',
        reader:reader
    });
    
//**********************filter config
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        	{type: 'numeric',dataIndex: 'slnoIndex'},
        	{type: 'numeric',dataIndex: 'idIndex'},
        	{type: 'string', dataIndex: 'branchCodeIndex'},
        	{type: 'numeric', dataIndex: 'branchIdIndex'},
	        {type: 'string', dataIndex: 'transactionTypeIndex'},
	        {type: 'date', dataIndex: 'transactionDateIndex'},
	        {type: 'string', dataIndex: 'accountHeaderIndex'},
	        {type: 'string', dataIndex: 'vehicleIndex'},
	        {type: 'string', dataIndex: 'driverIndex'},
	        {type: 'string', dataIndex: 'cleanerIndex'},
	        {type: 'numeric', dataIndex: 'amountIndex'},
	        {type: 'numeric', dataIndex: 'appAmountIndex'},
	        {type: 'string', dataIndex: 'descriptionIndex'},
			{type: 'string', dataIndex: 'billNoIndex'}
        ]
    });

//**************column model config
    var createColModel = function (finish, start) {

        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=SLNO%></span>",width:40}),
         {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },
        {
            dataIndex: 'idIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=UID%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },
		{
			dataIndex: 'branchCodeIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=branchCode%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'branchIdIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=branchId%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'transactionTypeIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=transactionType%></span>",
            filter:
            {
            	type: 'string'
			}
		},		
        {
            dataIndex: 'transactionDateIndex',
            hidden:false,
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            header: "<span style=font-weight:bold;><%=transactionDate%></span>",
            filter:
            {
            	type: 'date'
			}
        },
		{
			dataIndex: 'accountHeaderIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=accountHeader%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'vehicleIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=vehicle%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'driverIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=driver%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'cleanerIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=cleaner%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'amountIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=amount%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'appAmountIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=approvedAmount%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'descriptionIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=description%></span>",
            filter:
            {
            	type: 'string'
			}
		},				
		{
			dataIndex: 'billNoIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=billNo%></span>",
            filter:
            {
            	type: 'string'
			}
		},
		{
			dataIndex: 'invoiceIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=invoice%></span>",
            renderer: function(){
            	return '<a href="#div1" onclick="viewInvoice()"><img src="../../Main/images/documentView.png"></img></a>';;
            },
            filter:
            {
            	type: 'string'
			}
		}
       ];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
         })
       };
       
	grid = getGrid('<%=cashBookApproveReject%>','<%=NoRecordsFound%>',store,screen.width-60,430,15,filters,'Clear Filter Data',false,'',8,false,'',false,'',true,'Export',jspName,exportDataType,false,'',false,'Add',true,'Modify',false,'Delete');

	function modifyData(){
	if(Ext.getCmp('branchComboId').getValue() == "" && Ext.getCmp('branchComboId').getValue() != "0" )
	{
		Ext.example.msg("<%=selectBranch%>");
		Ext.getCmp('branchComboId').focus();
		return;
	}
	if(Ext.getCmp('statusComboId').getValue() == "" && Ext.getCmp('statusComboId').getValue() != "0" )
	{
		Ext.example.msg("<%=selectStatus%>");
		Ext.getCmp('statusComboId').focus();
		return;
	}
	if(grid.getSelectionModel().getCount()==0 || grid.getSelectionModel().getCount()>1){
		Ext.example.msg("<%=selectSingleRow%>");
		return;
	}

	buttonValue="modify";
	myWinTitle="<%=cashBookApproveReject%>"
	myWin.show();
	myWin.setTitle(myWinTitle);
	myWin.setPosition(388,145);
	Ext.getCmp('branchCodeTextFieldId').reset();
	Ext.getCmp('transTypeTextFieldId').reset();
	Ext.getCmp('transDateTextFieldId').reset();
	Ext.getCmp('accHeaderTextFieldId').reset();
	Ext.getCmp('vehicleTextFieldId').reset();
	Ext.getCmp('driverTextFieldId').reset();
	Ext.getCmp('cleanerTextFieldId').reset();
	Ext.getCmp('amountTextFieldId').reset();
	Ext.getCmp('appAmountTextFieldId').reset();
	Ext.getCmp('descTextFieldId').reset();
	Ext.getCmp('billNoTextFieldId').reset();

	var selected = grid.getSelectionModel().getSelected();
	//alert(selected.get('idIndex'));
	Ext.getCmp('branchCodeTextFieldId').setValue(selected.get('branchCodeIndex'));
	Ext.getCmp('transTypeTextFieldId').setValue(selected.get('transactionTypeIndex'));
	Ext.getCmp('transDateTextFieldId').setValue(selected.get('transactionDateIndex'));
	Ext.getCmp('accHeaderTextFieldId').setValue(selected.get('accountHeaderIndex'));
	Ext.getCmp('vehicleTextFieldId').setValue(selected.get('vehicleIndex'));
	Ext.getCmp('driverTextFieldId').setValue(selected.get('driverIndex'));
	Ext.getCmp('cleanerTextFieldId').setValue(selected.get('cleanerIndex'));
	Ext.getCmp('amountTextFieldId').setValue(selected.get('amountIndex'));
	Ext.getCmp('appAmountTextFieldId').setValue(selected.get('appAmountIndex'));
	Ext.getCmp('descTextFieldId').setValue(selected.get('descriptionIndex'));
	Ext.getCmp('billNoTextFieldId').setValue(selected.get('billNoIndex'));
 }



var innerPanelWindow = new Ext.form.FormPanel({
		standardSubmit: false,
		collapsible:false,
		autoScroll:true,
		height: 260,
		width:750,
		frame:true,
		id:'modifyCashBook',
		layout:'table',
		layoutConfig: {
			columns:1
		},
		items: [
		        {
		        xtype:'fieldset', 
				title:'<%=cashBookApproveReject%>',
				cls:'fieldsetpanel',
				collapsible: false,
				colspan:1,
				id:'cashBookFieldsetid',
				width: 730,
				layout:'table',
				layoutConfig: {
					columns:7
				},
				items: [
				{
            	xtype:'label',
            	text:'<%=branchCode%> '+'  :',
            	hidden:false,
            	cls:'labelstyle',
            	id:'mandatoryBranch'
            	},{width : 30},
				{
				xtype: 'textfield',
				text: '',
				cls:'textrnumberstyle',
				id:'branchCodeTextFieldId',
				readOnly : true
				},{width : 30},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'transactionDateLabelid',
				text: '<%=transactionDate%> '+'  :'
				},{width : 30},
				{
				xtype:'textfield',
		        value: '',
		        emptyText:'',
	    	    cls:'selectstylePerfect',
		        id:'transDateTextFieldId',
				readOnly: true
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'transacTypeLabelid',
				text: '<%=transactionType%> '+'  :'
				},{width : 30},
				{
            	xtype:'textfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'transTypeTextFieldId',
				readOnly: true
            	},{width : 30},
	    		{
				xtype: 'label',
				text: '<%=accountHeader%> '+'  :',
				cls:'labelstyle',
				id:'accountHeaderlabelid'
				},{width : 30},
				{
            	xtype:'textfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'accHeaderTextFieldId',
				readOnly: true
            	},
				{
				xtype: 'label',
				text: '<%=vehicle%> '+'  :',
				cls:'labelstyle',
				id:'vehicleLabid'
				},{width : 30},
				{
            	xtype:'textfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'vehicleTextFieldId',
				readOnly: true
            	},{width: 30},
				{
				xtype: 'label',
				text: '<%=driver%> '+'  :',
				cls:'labelstyle',
				id:'driverLabid'
				},{width: 30},
				{
            	xtype:'textfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'driverTextFieldId',
				readOnly: true
            	},
				{
				xtype: 'label',
				text: '<%=cleaner%> '+'  :',
				cls:'labelstyle',
				id:'cleanerLabid'
				},{width: 30},
				{
            	xtype:'textfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'cleanerTextFieldId',
				readOnly: true
            	},{width: 30},
	    		{
				xtype: 'label',
				text: '<%=amount%> '+'  :',
				cls:'labelstyle',
				id:'amountlabelid'
				},{width:30},
				{
            	xtype:'numberfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'amountTextFieldId',
				readOnly: true
            	},
				{
				xtype: 'label',
				text: '<%=approvedAmount%>'+':',
				cls:'labelstyle',
				id:'appAmountlabelid'
				},{width: 30},
				{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Amount',
	    		blankText :'0',
	    		maxLength : 10,
	    		emptyText : '0',
	    		value: 0,
	    		allowBlank: true,
	    		id:'appAmountTextFieldId'
	    		},{width: 30},
	    		{
				xtype: 'label',
				text: '<%=description%> '+'  :',
				cls:'labelstyle',
				id:'descriptionLabelid'
				},{width: 30},
	    		{
            	xtype:'textfield',
            	text:'',
            	cls:'textrnumberstyle',
            	id:'descTextFieldId',
				readOnly: true
            	},
				{
				xtype: 'label',
				text: '<%=billNo%> '+'  :',
				cls:'labelstyle',
				id:'billNolabelid'
				},{width: 30},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		allowBlank: false,	    			    		
	    		id:'billNoTextFieldId',
				readOnly: true
				}],
			   buttons: [
			    {
			    text: '<%=approve%>',
			    handler: function() {
						var selected = grid.getSelectionModel().getSelected();
						var uniqueId;
						var branchId;
						var transacDate;
						if(buttonValue == "modify"){
						   uniqueId = selected.get('idIndex');
						   branchId = selected.get('branchIdIndex');
						   transacDate = selected.get('transactionDateIndex');
						}
						if(Ext.getCmp('appAmountTextFieldId').getValue()== ""){
							Ext.example.msg("<%=enterApprovedAmount%>");
							Ext.getCmp('appAmountTextFieldId').focus();
							return;
						}
						if(Ext.getCmp('transTypeTextFieldId').getValue() == 'Debit' && 
							(Ext.getCmp('appAmountTextFieldId').getValue() > Ext.getCmp('amountTextFieldId').getValue())) {
							Ext.example.msg("<%=approvedAmountValidation%>");
							Ext.getCmp('appAmountTextFieldId').focus();
							return;
						}
						
						Ext.Ajax.request({
								url: '<%=request.getContextPath()%>/CashBookAppRejAction.do?param=approveCashBookAmount',
								method: 'POST',
								params: {
									uniqueId: uniqueId, appAmount: Ext.getCmp('appAmountTextFieldId').getValue(),
									amount: Ext.getCmp('amountTextFieldId').getValue(),transacType: Ext.getCmp('transTypeTextFieldId').getValue(),
									branchId: branchId, transacDate: transacDate
								},
						        success: function(response, action) {
						          var message = "Saved Successfully.";
						          Ext.example.msg(message);
								  Ext.getCmp('branchCodeTextFieldId').reset();
								  Ext.getCmp('transTypeTextFieldId').reset();
								  Ext.getCmp('transDateTextFieldId').reset();
								  Ext.getCmp('accHeaderTextFieldId').reset();
								  Ext.getCmp('vehicleTextFieldId').reset();
								  Ext.getCmp('driverTextFieldId').reset();
								  Ext.getCmp('cleanerTextFieldId').reset();
								  Ext.getCmp('amountTextFieldId').reset();
								  Ext.getCmp('descTextFieldId').reset();
								  Ext.getCmp('billNoTextFieldId').reset();
								  Ext.getCmp('appAmountTextFieldId').reset();
								  myWin.hide();
						          outerPanel.getEl().unmask();
						          store.load({params:{
										custId: globalClientId, status: Ext.getCmp('statusComboId').getValue(),CustName: custName,jspName: jspName,branchId: Ext.getCmp('branchComboId').getValue(),
										startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d'),branchName: Ext.getCmp('branchComboId').getRawValue()
									}
								});
					         },
					         failure: function() {
					          	  var message = "Error occurred while saving data.";
					          	  Ext.example.msg(message);
					          	  Ext.getCmp('branchCodeTextFieldId').reset();
								  Ext.getCmp('transTypeTextFieldId').reset();
								  Ext.getCmp('transDateTextFieldId').reset();
								  Ext.getCmp('accHeaderTextFieldId').reset();
								  Ext.getCmp('vehicleTextFieldId').reset();
								  Ext.getCmp('driverTextFieldId').reset();
								  Ext.getCmp('cleanerTextFieldId').reset();
								  Ext.getCmp('amountTextFieldId').reset();
								  Ext.getCmp('descTextFieldId').reset();
								  Ext.getCmp('billNoTextFieldId').reset();
								  Ext.getCmp('appAmountTextFieldId').reset();
								  myWin.hide();
						          outerPanel.getEl().unmask();
						          store.load({params:{
										custId: globalClientId, status: Ext.getCmp('statusComboId').getValue(),CustName: custName,jspName: jspName,branchId: Ext.getCmp('branchComboId').getValue(),
										startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d'),branchName: Ext.getCmp('branchComboId').getRawValue()
									}
								});
					         }
						});
					}//handler
				},//save
	       		{
	       			xtype:'button',
	      			text:'<%=reject%>',
	        		id:'rejButtId',
	        		cls:'buttonstyle',
	        		width:80,
	       			listeners: {
	        			click: 	{
	       					fn:function() {
	       						var selected = grid.getSelectionModel().getSelected();
								var uniqueId;
								var branchId;
								var transacDate;
								if(buttonValue == "modify"){
								   uniqueId = selected.get('idIndex');
								   branchId = selected.get('branchIdIndex');
								   transacDate = selected.get('transactionDateIndex');
								}
								if(Ext.getCmp('appAmountTextFieldId').getValue() > 0){
									Ext.example.msg("<%=approvedAmountShouldNotBeGreaterThanZero%>");
									Ext.getCmp('appAmountTextFieldId').focus();
									return;
								}
								Ext.MessageBox.confirm('Confirm', 'Would you like to reject?', function(btn) {
							        if (btn == 'no') {
							            return;
							        } 
							        
							        if(btn == 'yes'){
								        	Ext.Ajax.request({
												url: '<%=request.getContextPath()%>/CashBookAppRejAction.do?param=rejectCashBookAmount',
												method: 'POST',
												params: {
													uniqueId: uniqueId, appAmount: Ext.getCmp('appAmountTextFieldId').getValue(),
													amount: Ext.getCmp('amountTextFieldId').getValue(),transacType: Ext.getCmp('transTypeTextFieldId').getValue(),
													branchId: branchId, transacDate: transacDate
												},
												success: function(response, action) {
												  var message = "Saved Successfully.";
												  Ext.example.msg(message);
												  Ext.getCmp('branchCodeTextFieldId').reset();
												  Ext.getCmp('transTypeTextFieldId').reset();
												  Ext.getCmp('transDateTextFieldId').reset();
												  Ext.getCmp('accHeaderTextFieldId').reset();
												  Ext.getCmp('vehicleTextFieldId').reset();
												  Ext.getCmp('driverTextFieldId').reset();
												  Ext.getCmp('cleanerTextFieldId').reset();
												  Ext.getCmp('amountTextFieldId').reset();
												  Ext.getCmp('descTextFieldId').reset();
												  Ext.getCmp('billNoTextFieldId').reset();
												  Ext.getCmp('appAmountTextFieldId').reset();
												  myWin.hide();
												  outerPanel.getEl().unmask();
												  store.load({params:{
														custId: globalClientId, status: Ext.getCmp('statusComboId').getValue(),CustName: custName,jspName: jspName,branchId: Ext.getCmp('branchComboId').getValue(),
														startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d'),branchName: Ext.getCmp('branchComboId').getRawValue()
													}
												});
											 },
											 failure: function() {
												  var message = "Error occurred while saving data.";
												  Ext.example.msg(message);
												  Ext.getCmp('branchCodeTextFieldId').reset();
												  Ext.getCmp('transTypeTextFieldId').reset();
												  Ext.getCmp('transDateTextFieldId').reset();
												  Ext.getCmp('accHeaderTextFieldId').reset();
												  Ext.getCmp('vehicleTextFieldId').reset();
												  Ext.getCmp('driverTextFieldId').reset();
												  Ext.getCmp('cleanerTextFieldId').reset();
												  Ext.getCmp('amountTextFieldId').reset();
												  Ext.getCmp('descTextFieldId').reset();
												  Ext.getCmp('billNoTextFieldId').reset();
												  Ext.getCmp('appAmountTextFieldId').reset();
												  myWin.hide();
												  outerPanel.getEl().unmask();
												  store.load({params:{
														custId: globalClientId, status: Ext.getCmp('statusComboId').getValue(),CustName: custName,jspName: jspName,branchId: Ext.getCmp('branchComboId').getValue(),
														startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d'),branchName: Ext.getCmp('branchComboId').getRawValue()
													}
												});
											 }
										});
										
									}//yes button
								});
	       					}
						}
					}
	       		},//reject
	       		{
	       			xtype:'button',
	      			text:'<%=cancel%>',
	        		id:'canButtId',
	        		iconCls:'cancelbutton',
	        		cls:'buttonstyle',
	        		width:80,
	       			listeners: {
	        			click: {
	       					fn:function() {
	       						myWin.hide();
	       					}
	       				}
	       			}
	       		}
				]
			}]
		});
		
myWin = new Ext.Window({
        title:myWinTitle,
        closable: false,
        modal: true,
        resizable:false,
        autoScroll: false,
       // cls:'mywindow',
        width  : 750,
        height : 280,
        id     : 'myWin',
        items  : [innerPanelWindow]
    });
	
 	var statusData = [['PENDING'],['APPROVED'],['REJECTED']];
 	
	var statusStore = new Ext.data.SimpleStore({
		data: statusData,
		fields: ['StatusId']
	});
			
	var statusCombo = new Ext.form.ComboBox({
		store: statusStore,
		id: 'statusComboId',
		mode: 'local',
		forceselection: true,		
		emptyText: '<%=selectStatus%>',
		blankText: '<%=selectStatus%>',
		selectOnFocus: true,
		allowBlank: false,
		enableKeyEvents: true,
		anyMatch: true,
		typeAhead: true,
		triggerAction: 'all',
		valueField: 'StatusId',
		displayField: 'StatusId',
		cls: 'selectstylePerfect',
		listeners: { 
			select : {
					fn: function() {
						if(Ext.getCmp('statusComboId').getValue() == "PENDING") {
							grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('appAmountIndex'), true);
							Ext.getCmp('modifyId').enable();
						} else {
							grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('appAmountIndex'), false);
							Ext.getCmp('modifyId').disable();
						}
				}		
			}
		}
	});	
					
	var statusAndDatePanel = new Ext.Panel({
		standardSubmit: false,
		frame: true,
		autoScroll: true,
		border: true,
		layout: 'table',
		layoutConfig: {
			columns: 18
		},
		items: [
			{width: 10},
			{
			xtype: 'label',
			text: '<%=selectBranch%>',
			cls: 'labelstyle',
			id: 'branchLabelId'
			},{width: 15},
			branchcombo,{width: 20},
			{
			xtype: 'label',
			text: '<%=selectStatus%>',
			cls: 'labelstyle',
			id: 'statusLabelId'
			},{width: 15},
			statusCombo,{width: 20},
			{
			xtype: 'label',
			text: '<%=startDate%>',
			cls: 'labelstyle',
			id: 'startDateLabelId'
			},{width: 20},
			{
			xtype:'datefield',
	        format: getDateFormat(),
	        value: dtcur,
            vtype: 'daterange',
	        emptyText:'',
    	    cls:'selectstylePerfect',
	        id:'startDateId'
    		},{width: 20},
			{
			xtype: 'label',
			text: '<%=endDate%>',
			cls: 'labelstyle',
			id: 'endDateLabelId'
			},{width: 20},
			{
			xtype: 'datefield',
			format: getDateFormat(),
			value: dtnext,
			vtype: 'daterange',
			emptyText:'',
			cls: 'selectstylePerfect',
			id: 'endDateId'
			},{width: 30},
			{
			xtype: 'button',
			cls: 'buttonstyle',
			text: 'View',
			handler: function () {
					if(Ext.getCmp('branchComboId').getValue() == "") {
						Ext.example.msg("<%=selectBranch%>");
						Ext.getCmp('branchComboId').focus();
						return;
					}
					if(Ext.getCmp('statusComboId').getValue() == "") {
						Ext.example.msg("<%=selectStatus%>");
						Ext.getCmp('statusComboId').focus();
						return;
					}
					if (dateCompare(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue()) == -1) {
                           Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                           Ext.getCmp('endDateId').focus();
                           return;
                 } 
					if (checkMonthValidation(Ext.getCmp('startDateId').getValue().format('Y-m-d'), Ext.getCmp('endDateId').getValue().format('Y-m-d'))) {
  		                    Ext.example.msg("<%=monthValidation%>");
  		                    Ext.getCmp('endDateId').focus();
  		                    return;
  		            } 
					store.load({params:{
						custId: globalClientId, status: Ext.getCmp('statusComboId').getValue(),CustName: custName,jspName: jspName,branchId: Ext.getCmp('branchComboId').getValue(),
						startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d'),branchName: Ext.getCmp('branchComboId').getRawValue()
					}
					});
				}
			}
			
		]
		
	});
  
  Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'',
			renderTo : 'content',
			standardSubmit: true,
			autoScroll:false,
			frame:true,
			border:false,
			width:screen.width-38,
			height:500,
			cls:'outerpanel',
			items: [statusAndDatePanel, grid]
			//bbar:ctsb
	});
  
  });
	</script>    

  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
