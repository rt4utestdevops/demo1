<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%@page import="t4u.functions.CommonFunctions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
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
	tobeConverted.add("Cash_Book");
	tobeConverted.add("Select_client");
	tobeConverted.add("UID");
	tobeConverted.add("Transaction_Date");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Select_Branch");
	tobeConverted.add("Select_Transaction_Type");
	tobeConverted.add("Add_Cash_Book_Details");
	tobeConverted.add("Current_Balance"); 
	tobeConverted.add("Branch_Code");
	tobeConverted.add("Transaction_Type");
	tobeConverted.add("Amount");
	tobeConverted.add("Account_Header");
	tobeConverted.add("Description");
	tobeConverted.add("Select_Vehicle");
	tobeConverted.add("Bill_No");
	tobeConverted.add("Document_Upload");
	tobeConverted.add("Save");
	tobeConverted.add("Enter_Amount");
	tobeConverted.add("Select_Account_Header");
	tobeConverted.add("Enter_Description");
	tobeConverted.add("Enter_Bill_No");
	tobeConverted.add("Cancel");
	tobeConverted.add("Select_Date");
	tobeConverted.add("Invoice");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Cleaner");
	tobeConverted.add("Select_Cleaner");
	tobeConverted.add("Driver");
	tobeConverted.add("Select_Driver");
	tobeConverted.add("Branch");
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Trip_No");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("Ledger_Balance");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SLNO = convertedWords.get(0);
	String CashBook = convertedWords.get(1);
	String Selectclient = convertedWords.get(2);
	String UID = convertedWords.get(3);;
	String transactionDate = convertedWords.get(4);
	String NoRecordsFound = convertedWords.get(5);
	String selectBranch = convertedWords.get(6);
	String selectTransactionType = convertedWords.get(7);
	String AddCashBookDetails = convertedWords.get(8);
	String currentBalance = convertedWords.get(9);
	String branchCode = convertedWords.get(10);
	String transactionType = convertedWords.get(11);
	String amount = convertedWords.get(12);
	String accountHeader = convertedWords.get(13);
	String description = convertedWords.get(14);
	String selectVehicle = convertedWords.get(15);
	String billNo = convertedWords.get(16);
	String uploadInvoice = convertedWords.get(17);
	String Save = convertedWords.get(18);
	String enterAmount = convertedWords.get(19);
	String selectAccHeader = convertedWords.get(20);
	String enterDescription = convertedWords.get(21);
	String enterBillNo = convertedWords.get(22);
	String Cancel = convertedWords.get(23);
	String selectDate = convertedWords.get(24); 
	String invoice = convertedWords.get(25);
	String vehicle = convertedWords.get(26);
	String cleaner = convertedWords.get(27);
	String selectCleaner = convertedWords.get(28);
	String driver = convertedWords.get(29);
	String selectDriver = convertedWords.get(30);
	String branch = convertedWords.get(31);
	String startDate = convertedWords.get(32);
	String endDate = convertedWords.get(33);
	String tripNo = convertedWords.get(34);
	String EndDateMustBeGreaterthanStartDate = convertedWords.get(35);
	String monthValidation = convertedWords.get(36);
	String ledgerBalance = convertedWords.get(37);
	String openingBalance = "Opening Balance";
	String closingBalance = "Closing Balance";
	
%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=CashBook%></title>	
 		  
  
	 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
#div1:target {
    height: auto;
    margin-top: -110px;
    padding-top: 110px;
}
  </style>
 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
		div#myWin {
			height : 51px !important;
		}
   </style>
   <script>
var outerPanel;
var ctsb;
var jspName = "CashBook";
var exportDataType = "int,int,date,string,string,string,string,string,string,string,string,number,string";
var dtnext = datenext;
var dtcur = datecur;
var titel;
var globalClientId ;
var uploadFileFlag = false;
var vehId = "";
var drivId = 0;
var cleaId = 0;
var custName = "";

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
        }
        branchStore.load({params: {custId: globalClientId}});
        userBranchStore.load({params: {custId: globalClientId}});
        transactionTypeStore.load({params: {custId: globalClientId}});
		accountHeaderStore.load({params: {custId: globalClientId}});
		driverStore.load({params: {custId: globalClientId}});
		cleanerStore.load({params: {custId: globalClientId}});
		vehicleStore.load({params: {custId: globalClientId}});
    });

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Selectclient%>',
    blankText: '<%=Selectclient%>',
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
            }
        }
    }
});

	var openingAndClosingBalance = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CashBookAction.do?param=getOpeningAndClosingBal',
       root: 'balanceRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['openingBal', 'closingBal']
   });
  /******store for getting All branch List******/
   var branchCurrentBalance= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getBranchCurrentBalance',
				   id:'branchCurrentBalanceId',
			       root: 'branchCurrentBalanceRoot',
			       autoLoad: false,
				   fields: ['currentBalance','ledgerBalance']
	});
/******store for getting user branch List******/
   var userBranchStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getUserBranchList',
				   id:'userBranchStoreId',
			       root: 'userBranchRoot',
			       autoLoad: false,
				   fields: ['BranchId','BranchName']
	});
//***** combo for user branch combo*************/
  var userBranchcombo = new Ext.form.ComboBox({
	        store: userBranchStore,
	        id:'userBranchComboId',
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
		              	branchCurrentBalance.load({params:
		              		{branchId: Ext.getCmp('userBranchComboId').getValue(),custId: globalClientId 
		              	},
		              	callback: function() {
							var rec = branchCurrentBalance.getAt(0);
							if (rec != null) {
								Ext.getCmp('currBalanceId').setText(rec.data['currentBalance']); 
								Ext.getCmp('ledgerBalanceId').setText(rec.data['ledgerBalance']); 
							} else {
								Ext.getCmp('currBalanceId').setText('0');
								Ext.getCmp('ledgerBalanceId').setText('0'); 
							}
						}
		              	});
  		}}}
  });
  
  /******store for getting All branch List******/
   var branchStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getBranchList',
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
  
//******store for getting Transaction Type List******/
   var transactionTypeStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getTransactionTypeList',
				   id:'transactionTypeStoreId',
			       root: 'transactionTypeRoot',
			       autoLoad: false,
				   fields: ['transTypeID','transTypeName']
	});
//***** combo for Transaction Type*************/
  var transactionTypeCombo = new Ext.form.ComboBox({
	        store: transactionTypeStore,
	        id:'transactionTypeComboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectTransactionType%>',
	        blankText :'<%=selectTransactionType%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'transTypeID',
	    	displayField: 'transTypeName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
  }}}
  });
  
  //******store for getting Account Header List******/
   var accountHeaderStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getAccountHeaderList',
				   id:'accountHeaderStoreId',
			       root: 'accountHeaderRoot',
			       autoLoad: false,
				   fields: ['accHeaderID','accHeaderName']
	});
//***** combo for Account Header*************/
  var accountHeaderCombo = new Ext.form.ComboBox({
	        store: accountHeaderStore,
	        id:'accountHeaderComboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectAccHeader%>',
	        blankText :'<%=selectAccHeader%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'accHeaderID',
	    	displayField: 'accHeaderName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		        select: {
		          fn:function(){
  				  }
  			   }
  			}
  		});

    //******store for getting vehicle List******/
   var vehicleStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getVehicles',
				   id:'vehicleStoreId',
			       root: 'vehicleRoot',
			       autoLoad: false,
				   fields: ['vehicleId','VehicleNo']
	});
//***** combo for vehicle *************/
  var vehicleCombo = new Ext.form.ComboBox({
	        store: vehicleStore,
	        id:'vehicleComboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectVehicle%>',
	        blankText :'<%=selectVehicle%>',
	        selectOnFocus:true,
	        allowBlank: true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'vehicleId',
	    	displayField: 'VehicleNo',
	    	cls:'selectstylePerfect',
	    	listeners: {
		        select: {
		        	fn:function(){
		            	vehId = Ext.getCmp('vehicleComboId').getValue();
  			}}}
  });
  
  //----------Store for Cleaner------------------
   var cleanerStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getCleanerList',
				   id:'cleanerStoreId',
			       root: 'cleanerRoot',
			       autoLoad: false,
				   fields: ['cleanerID','cleanerName']
	});
//***** combo for Cleaner*************/
  var cleanerCombo = new Ext.form.ComboBox({
	        store: cleanerStore,
	        id:'cleanerComboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectCleaner%>',
	        blankText :'<%=selectCleaner%>',
	        selectOnFocus:true,
	        allowBlank: true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'cleanerID',
	    	displayField: 'cleanerName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		         select: {
		         	fn:function(){
		            	cleaId = Ext.getCmp('cleanerComboId').getValue();
  		}}}
  });
  
   var driverStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CashBookAction.do?param=getdriverList',
				   id:'driverStoreId',
			       root: 'driverRoot',
			       autoLoad: false,
				   fields: ['driverID','driverName']
	});
//***** combo for Account Header*************/
  var driverCombo = new Ext.form.ComboBox({
	        store: driverStore,
	        id:'driverComboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectDriver%>',
	        blankText :'<%=selectDriver%>',
	        selectOnFocus:true,
	        allowBlank: true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'driverID',
	    	displayField: 'driverName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		          select: {
		                fn:function(){
		                   drivId = Ext.getCmp('driverComboId').getValue();
  			}}}
  });

function addRecord(){
	buttonValue="add";
	titel='<%=AddCashBookDetails%>';
	myWin.show();
	myWin.setTitle(titel);
	myWin.setPosition(380,40);

	Ext.getCmp('currBalanceId').setText('');
	Ext.getCmp('ledgerBalanceId').setText('');
	Ext.getCmp('userBranchComboId').reset();
	Ext.getCmp('transactionTypeComboId').reset();
	Ext.getCmp('transactionDateId').reset();
	Ext.getCmp('vehicleComboId').reset();
	Ext.getCmp('accountHeaderComboId').reset();
	Ext.getCmp('cleanerComboId').reset();
	Ext.getCmp('driverComboId').reset();
	Ext.getCmp('amountId').reset();
	Ext.getCmp('descriptionId').reset();
	Ext.getCmp('billNoId').reset();
	Ext.getCmp('filePath').reset();
   
}
//******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'cashBookReaderId',
        root: 'cashBookRoot',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {name: 'idIndex'},
        {name: 'transactionDateIndex'},
        {name: 'branchCodeIndex'},
        {name: 'accountHeaderIndex'},
        {name: 'tripNoIndex'},
        {name: 'vehicleIndex'},
        {name: 'driverIndex'},
        {name: 'cleanerIndex'},
        {name: 'billNoIndex'},
        {name: 'descriptionIndex'},
        {name: 'amountIndex'},
        {name: 'transactionTypeIndex'}
        ]
    });

//************************* store configs
	var store =  new Ext.data.GroupingStore({
        autoLoad:true,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/CashBookAction.do?param=getCashBookDetails',
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
	        {type: 'date', dataIndex: 'transactionDateIndex'},
	        {type: 'string', dataIndex: 'branchCodeIndex'},
	        {type: 'string', dataIndex: 'accountHeaderIndex'},
	        {type: 'string', dataIndex: 'tripNoIndex'},
	        {type: 'string', dataIndex: 'vehicleIndex'},
	        {type: 'string', dataIndex: 'driverIndex'},
	        {type: 'string', dataIndex: 'cleanerIndex'},
	        {type: 'string', dataIndex: 'billNoIndex'},
	        {type: 'string', dataIndex: 'descriptionIndex'},
	        {type: 'numeric', dataIndex: 'amountIndex'},
	        {type: 'string', dataIndex: 'transactionTypeIndex'}
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
			dataIndex: 'branchCodeIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=branchCode%></span>",
            filter:
            {
            	type: 'string'
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
			dataIndex: 'tripNoIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=tripNo%></span>",
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
			dataIndex: 'billNoIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=billNo%></span>",
            filter:
            {
            	type: 'string'
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
			dataIndex: 'amountIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=amount%></span>",
            filter:
            {
            	type: 'numeric'
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

grid=getGrid('<%=CashBook%>','<%=NoRecordsFound%>',store,screen.width-60,430,15,filters,'Clear Filter Data',false,'',8,false,'',false,'',true,'Export',jspName,exportDataType,false,'',true,'Add',false,'Modify',false,'Delete');

function viewInvoice()
{
	var records = grid.getSelectionModel().getSelected();
	var id = records.data['idIndex'];
	Ext.Ajax.request({
			        url: '<%=request.getContextPath()%>/CashBookAction.do?param=isInvoiceExists',
			        method: 'POST',
			        params: {
			           id: id,
			           systemId: '<%=systemId%>',
			           custId: globalClientId
			        },
			        success: function(response, options) {
			        	if(response.responseText == "No File Founds..." || response.responseText == ""){
			        	//alert('if  ' + response.responseText);
			        		Ext.example.msg("No File Founds...");
			        	} else {
			        	//alert('else '+response.responseText);
			        		parent.open('<%=request.getContextPath()%>'+"/viewInvoicePT?custId="+globalClientId+"&id="+id+"&systemId="+'<%=systemId%>');
			        	}
			        },
			        failure: function() {
						Ext.example.msg("No File Founds...");
			        }
			    });
	 

}

var fp = new Ext.form.FormPanel({
		fileUpload: true,
		standardSubmit: false,
		collapsible:false,
		autoScroll:true,
		///height:280,
		autoHeight: true,
		width:770,
		frame:true,
		id:'addCashBook',
		layout:'table',
		layoutConfig: {
			columns:1
		},
		items: [
		        {
		        xtype:'fieldset', 
				title:'<%=CashBook%>',
				cls:'fieldsetpanel',
				collapsible: false,
				autoHeight: true,
				colspan:1,
				id:'cashBookFieldsetid',
				//height: 260,
				width: 740,
				layout:'table',
				layoutConfig: {
					columns:7
				},
				items: [
				{
            	xtype:'label',
            	text:'*',
            	hidden:false,
            	cls:'mandatoryfield',
            	id:'mandatoryBranch'
            	},{
				xtype: 'label',
				text: '<%=branchCode%> '+'  :',
				allowBlank: false,
				cls:'labelstyle',
				hidden:false,
				id:'branchCodelabelid'
				},
				userBranchcombo,{width : 50},{width : 10},{width : 10},{width : 10},
				{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory'
            	},
				{
				xtype: 'label',
				text: '<%=currentBalance%> '+'  :',
				cls:'labelstyle',
				id:'currBalLabelId'
				},
				{
				xtype:'label',
				text: '',
				cls:'labelstyle',
	    		id:'currBalanceId',
	    		readOnly : true
	    		},{width : 50},{height : 25},
	    		{
				xtype: 'label',
				text: '<%=ledgerBalance%> '+'  :',
				cls:'labelstyle',
				id:'ledgerBalLabelId'
				},
				{
				xtype:'label',
				text: '',
				cls:'labelstyle',
	    		id:'ledgerBalanceId',
	    		readOnly : true
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryTransTypeId'
            	},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'transacTypeLabelid',
				text: '<%=transactionType%> '+'  :'
				},
				transactionTypeCombo,
				{width : 50},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryTransDateId'
            	},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'transactionDateLabelid',
				text: '<%=transactionDate%> '+'  :'
				},
				{
				xtype:'datefield',
		        format: getDateFormat(),
		        value: dtcur,
                minValue:dtcur,
                maxValue:dtcur,
                vtype: 'daterange',
		        emptyText:'',
	    	    cls:'selectstylePerfect',
		        id:'transactionDateId'
	    		},
				{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryAccHeaderId'
            	},
	    		{
				xtype: 'label',
				text: '<%=accountHeader%> '+'  :',
				cls:'labelstyle',
				id:'accountHeaderlabelid'
				},
				accountHeaderCombo,{width : 50},
				{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryVehicle'
            	},
				{
				xtype: 'label',
				text: '<%=vehicle%> '+'  :',
				cls:'labelstyle',
				id:'vehicleLabid'
				},vehicleCombo,
				{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryDriverId'
            	},
				{
				xtype: 'label',
				text: '<%=driver%> '+'  :',
				cls:'labelstyle',
				id:'driverLabid'
				},driverCombo,
				{width: 50},
				{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryCleanerId'
            	},
				{
				xtype: 'label',
				text: '<%=cleaner%> '+'  :',
				cls:'labelstyle',
				id:'cleanerLabid'
				},cleanerCombo,
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryAmountId'
            	},
	    		{
				xtype: 'label',
				text: '<%=amount%> '+'  :',
				cls:'labelstyle',
				id:'amountlabelid'
				},
				{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Amount',
	    		blankText :'',
	    		maxLength : 10,
	    		allowBlank: true,
	    		id:'amountId'
	    		},{width: 50},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryDescId'
            	},
	    		{
				xtype: 'label',
				text: '<%=description%> '+'  :',
				cls:'labelstyle',
				id:'descriptionLabelid'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		allowBlank: false,
	    		emptyText:'<%=description%>',
	    		maskRe: /([a-zA-Z0-9\s]+)$/,
	    		id:'descriptionId',
	    		maxLength : 40,
	    		maxLengthText : 'The maximum length for this field is 40',
	    		listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
	    		},
				{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryBillNo'
            	},
				{
				xtype: 'label',
				text: '<%=billNo%> '+'  :',
				cls:'labelstyle',
				id:'billNolabelid'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		allowBlank: false,
	    		emptyText:'<%=billNo%>',
	    		maskRe: /([a-zA-Z0-9\s]+)$/,
	    		id:'billNoId',
	    		maxLength : 15,
	    		maxLengthText : 'The maximum length for this field is 15',
	    		listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
				},{width : 50},
				{
				xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryUploadId'
				},{
				xtype: 'label',
				text: '<%=uploadInvoice%> '+'  :',
				cls:'labelstyle',
				id:'uploadInvoiceLabelId'
				},{
		        xtype: 'textfield',
		        inputType: 'file',
		        id: 'filePath',
		        width: 180,
		        name: 'filePath',
		        listeners: {
		            'change': {
				       fn: function() {
				       	if (document.getElementById('filePath').value == '') {
				        	uploadFileFlag = false;
				        } else {
				        	uploadFileFlag = true;
				        }
				        var filePath = document.getElementById('filePath').value;
				        //var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
				        return;
			       }
			    }}//lis
				}],
			   buttons: [
			    {
			    text: '<%=Save%>',
			    iconCls: 'uploadbutton',
			    id: 'saveButtonId',
			    handler: function() {
			    	
	       					//alert("button value:-"+buttonValue);
	       		           if(Ext.getCmp('userBranchComboId').getValue()== ""){
      		                    Ext.example.msg("<%=selectBranch%>");
								Ext.getCmp('userBranchComboId').focus();
								return;
							}
							if(Ext.getCmp('transactionTypeComboId').getValue()== ""){
								Ext.example.msg("<%=selectTransactionType%>");
								Ext.getCmp('transactionTypeComboId').focus();
								return;
							}
							if(Ext.getCmp('transactionDateId').getValue()== ""){
								Ext.example.msg("<%=selectDate%>");
								Ext.getCmp('transactionDateId').focus();
								return;
							}
							if(Ext.getCmp('accountHeaderComboId').getValue()== ""){
								Ext.example.msg("<%=selectAccHeader%>");
								Ext.getCmp('accountHeaderComboId').focus();
								return;
							}
							if(Ext.getCmp('amountId').getValue()== ""){
								Ext.example.msg("<%=enterAmount%>");
								Ext.getCmp('amountId').focus();
								return;
							}
							if(Ext.getCmp('descriptionId').getValue()== "" ){
								Ext.example.msg("<%=enterDescription%>");
								Ext.getCmp('descriptionId').focus();
								return;
							}
							if(Ext.getCmp('billNoId').getValue()== ""){
								Ext.example.msg("<%=enterBillNo%>");
								Ext.getCmp('billNoId').focus();
								return;
							}
						var branchId = Ext.getCmp('userBranchComboId').getValue();
			         	var transacTypeId = Ext.getCmp('transactionTypeComboId').getValue();
			         	var transactionDateId = Ext.getCmp('transactionDateId').getValue().format('Y-m-d');
			         	var amountId = Ext.getCmp('amountId').getValue();
			         	var accHeaderId = Ext.getCmp('accountHeaderComboId').getValue();
			         	var descriptionid = Ext.getCmp('descriptionId').getValue();
			         	var billNoId = Ext.getCmp('billNoId').getValue();
			         	//var uploadedFile = Ext.getCmp('filePath').getValue();
			         	var filePath = document.getElementById('filePath').value;
			         	vehId = vehId;
						drivId = drivId;
						cleaId = cleaId;
						
						//var waitBox = Ext.MessageBox.wait('Please wait', 'Uploading your file...');; 
						
						if(uploadFileFlag) {
								//waitBox.show();
					        	var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
					        	if (imgext == "jpg" || imgext == "JPG" || imgext == "jpeg" || imgext == "JPEG" || imgext == "pdf") {
			                } else {
			                	//waitBox.hide();
			                	Ext.example.msg('Please select only JPG/JPEG/PDF files formats.');
			                    Ext.getCmp('filePath').setValue("");
			                    return;
			                }
						}
						Ext.getCmp('saveButtonId').disable();
						if(fp.getForm().isValid()){
				        fp.getForm().submit({
					         url: '<%=request.getContextPath()%>/CashBookAction.do?param=saveCashBookDetails&buttonValue=' + buttonValue + '&custId=' + globalClientId + '&branchId=' + branchId + '&transacTypeId=' + transacTypeId + '&transactionDateId=' + transactionDateId + '&amountId=' + amountId + '&accHeaderId=' + accHeaderId + '&descriptionid=' + descriptionid + '&vehId=' + vehId + '&billNoId=' + billNoId + '&drivId=' + drivId + '&cleaId=' + cleaId + '&uploadFileFlag=' + uploadFileFlag + '',
					         enctype: 'multipart/form-data',
					         //waitMsg: 'Uploading your file...',// waitBox,
					         success: function(response, action) {
						          var message = "Saved Successfully.";
						          Ext.example.msg(message);
								  Ext.getCmp('userBranchComboId').reset();
								  Ext.getCmp('transactionTypeComboId').reset();
								  Ext.getCmp('transactionDateId').reset();
								  Ext.getCmp('amountId').reset();
								  Ext.getCmp('accountHeaderComboId').reset();
								  Ext.getCmp('descriptionId').reset();
								  Ext.getCmp('vehicleComboId').reset();
								  Ext.getCmp('billNoId').reset();
								  Ext.getCmp('cleanerComboId').reset();
								  Ext.getCmp('driverComboId').reset();
								  Ext.getCmp('filePath').reset();
								  Ext.getCmp('currBalanceId').setText('');
								  Ext.getCmp('ledgerBalanceId').setText('');
								  uploadFileFlag = false;
								  myWin.hide();
						          outerPanel.getEl().unmask();
						          store.load({ params: {
						            	custId: globalClientId, branchId: Ext.getCmp('branchComboId').getValue(),CustName: custName, jspName: jspName,
										startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d')
						           	}
						          });
						          Ext.getCmp('saveButtonId').enable();
					         },
					         failure: function() {
					          	  var message = "Error occurred while saving data.";
					          	  Ext.example.msg(message);
					          	  Ext.getCmp('userBranchComboId').reset();
								  Ext.getCmp('transactionTypeComboId').reset();
								  Ext.getCmp('transactionDateId').reset();
								  Ext.getCmp('amountId').reset();
								  Ext.getCmp('accountHeaderComboId').reset();
								  Ext.getCmp('descriptionId').reset();
								  Ext.getCmp('vehicleComboId').reset();
								  Ext.getCmp('billNoId').reset();
								  Ext.getCmp('cleanerComboId').reset();
								  Ext.getCmp('driverComboId').reset();
								  Ext.getCmp('filePath').reset();
								  Ext.getCmp('currBalanceId').setText('');
								  Ext.getCmp('ledgerBalanceId').setText('');
								  uploadFileFlag = false;
								  myWin.hide();
						          outerPanel.getEl().unmask();
						          store.load({ params: {
						            	custId: globalClientId, branchId: Ext.getCmp('branchComboId').getValue(),CustName: custName, jspName: jspName,
										startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d')
						           	}
						          });
					         	Ext.getCmp('saveButtonId').enable();
					         }
				        });
					}
			    
				}//handler
				},//save
	       		{
	       			xtype:'button',
	      			text:'<%=Cancel%>',
	        		id:'canButtId',
	        		iconCls:'cancelbutton',
	        		cls:'buttonstyle',
	        		width:80,
	       			listeners: {
	        			click: 	{
	       					fn:function() {
	       						myWin.hide();
	       						Ext.getCmp('saveButtonId').enable();
	       					}
						}
					}
	       		}
				]
	    		}]});
	    		
   
		     
var outerPanelWindow=new Ext.Panel({
			cls:'outerpanelwindow',
			standardSubmit: true,
			frame:false,
			autoHeight: true,
			id : 'outerpanelWindowId',
			items: [fp]
			}); 
			
myWin = new Ext.Window({
        title:titel,
        closable: false,
        //autoHeight: true,
        modal: true,
        resizable:false,
        autoScroll: false,
        cls:'mywindow',
        height : 350,
        width  : 780,
        id     : 'myWin',
        items  : [outerPanelWindow]
	});
	
	var branchAndDatePanel = new Ext.Panel({
		standardSubmit: false,
		frame: true,
		autoHeight: true,
		border: false,
		layout: 'table',
		layoutConfig: {
			columns : 14
		},
		items: [
			{width: 40},
			{
			xtype: 'label',
			text: '<%=branch%> : ',
			cls: 'labelstyle',
			id: 'branchLabelId'
			},{width: 20},
			branchcombo,{width: 20},
			{
			xtype: 'label',
			text: '<%=startDate%> : ',
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
			text: '<%=endDate%> : ',
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
			},{width: 50},
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
					if (dateCompare(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue()) == -1) {
                           Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                           Ext.getCmp('endDateId').focus();
                           return;
                 } 
				 if (checkMonthValidation(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue())) {
 		                    Ext.example.msg("<%=monthValidation%>");
 		                    Ext.getCmp('endDateId').focus();
 		                    return;
 		         } 
  		            openingAndClosingBalance.load({params:{
						custId: globalClientId, branchId: Ext.getCmp('branchComboId').getValue(),CustName: custName,jspName: jspName,
						startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d')
					},
					callback: function() {
						var r = openingAndClosingBalance.getAt(0);
						if(r != null) {
							Ext.getCmp('openingBalValueId').setText(r.data['openingBal']);
							Ext.getCmp('closingBalValueId').setText(r.data['closingBal']);
						} else {
							Ext.getCmp('openingBalValueId').setText(0.00);
							Ext.getCmp('closingBalValueId').setText(0.00);
						}
					}//end of function
					
					});
					store.load({params:{
						custId: globalClientId, branchId: Ext.getCmp('branchComboId').getValue(),CustName: custName,jspName: jspName,
						startDate: Ext.getCmp('startDateId').getValue().format('Y-m-d'),endDate: Ext.getCmp('endDateId').getValue().format('Y-m-d')
					}
					});
				}
			},{width: 40},
			{
			xtype: 'label',
			text: '<%=openingBalance%> : ',
			cls: 'labelstyle',
			id: 'openingBalLabelId'
			},{
			xtype: 'label',
			text: '',
			cls: 'labelstyle',
			id: 'openingBalValueId'
			},{width: 20},{
			xtype: 'label',
			text: '<%=closingBalance%> : ',
			cls: 'labelstyle',
			id: 'closingBalLabelId'
			},{
			xtype: 'label',
			text: '',
			cls: 'labelstyle',
			id: 'closingBalValueId'
			},
			
		]
	});

//*****main starts from here*************************
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
			items: [branchAndDatePanel, grid]
			//bbar:ctsb
	});
}); 

</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
