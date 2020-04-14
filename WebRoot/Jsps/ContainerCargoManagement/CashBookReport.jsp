<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="t4u.functions.CommonFunctions"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
	tobeConverted.add("Cash_Book_Report");
	tobeConverted.add("Select_client");
	tobeConverted.add("UID");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Branch");
	tobeConverted.add("Select_Branch");
	tobeConverted.add("Transaction_Type");
	tobeConverted.add("Select_Transaction_Type");
	tobeConverted.add("Year");
	tobeConverted.add("Enter_Year"); 
	tobeConverted.add("Account_Header");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Month_Validation");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String slNo = convertedWords.get(0);
	String cashBookReport = convertedWords.get(1);
	String selectClient = convertedWords.get(2);
	String UID = convertedWords.get(3);;
	String NoRecordsFound = convertedWords.get(4);
	String branch = convertedWords.get(5);
	String selectBranch = convertedWords.get(6);
	String transactionType = convertedWords.get(7);
	String selectTransactionType = convertedWords.get(8);
	String year = convertedWords.get(9);
	String selectYear = convertedWords.get(10);
	String accountHeader = convertedWords.get(11);
	String EndDateMustBeGreaterthanStartDate = convertedWords.get(12);
	String monthValidation = convertedWords.get(13);
	
	
	String jan = "Jan";
	String feb = "Feb";
	String mar = "Mar";
	String apr = "Apr";
	String may = "May";
	String june = "Jun";
	String july = "Jul";
	String aug = "Aug";
	String sep = "Sep";
	String oct = "Oct";
	String nov = "Nov";
	String dec = "Dec";


Calendar cal = Calendar.getInstance();
int currYear = cal.get(Calendar.YEAR);
int prevYear = cal.get(Calendar.YEAR) - 1;
int nextYear = cal.get(Calendar.YEAR) + 1;

String prevFinancialYear = prevYear + " - " + currYear ;
String currFinancialYear = currYear + " - " + nextYear ;
	
%>

<jsp:include page="../Common/header.jsp" />
    <title><%=cashBookReport%></title>
  
  
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
	.x-window-tl *.x-window-header {
		padding-top : 6px !important;
	}
	.x-layer ul {
		min-height: 27px !important;
	}
   </style>
   	<script>
   	var jspName = 'CashBookReport';
   	var exportDataType = 'int,string,number,number,number,number,number,number,number,number,number,number,number,number';
   	var branchId = 0;
   	var transactionTypeId = 0;
   	var year = 0;
   	
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
        transactionTypeStore.load({params: {custId: globalClientId}});
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
	            }
	        }
	    }
	});			
   	var yearData = [
	    ['<%=prevFinancialYear%>', '<%=prevFinancialYear%>'],  
	    ['<%=currFinancialYear%>', '<%=currFinancialYear%>']
	];
	
   	var yearStore = new Ext.data.ArrayStore({
	    fields: ['yearId', 'year'],
	    autoLoad: true,
	    data: yearData
	});

	
	var yearCombo = new Ext.form.ComboBox({
		allowBlank : false,
		autoScroll : true,
		mode: 'local',
		store : yearStore,
		valueField : 'yearId',
		displayField : 'year',
		emptyText : '<%=selectYear%>',
		blankText : '<%=selectYear%>',
		id: 'yearComboId',
		minChars : 3,
		typeAhead : true,
		resizable : true,
		forceSelection : true,
		triggerAction: 'all',
		cls: 'selectstylePerfect',
		listeners: {
			select: {
				fn: function(){
					year = Ext.getCmp('yearComboId').getValue();
					for(var i = 3; i <= 14; i++) {
					////alert('year : '+grid.getColumnModel().getColumnHeader(i).substring(0,33)+'-'+year);
						grid.getColumnModel().setColumnHeader(i, grid.getColumnModel().getColumnHeader(i).substring(0,33)+' <b>- '+year+'</b>');
					}
				}
			}
		}
	});
	
	var branchStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashBookReportAction.do?param=getBranchStore',
		autoLoad: false,
		root: 'branchRoot',
		fields: ['BranchId','BranchName']
	});
	var branchCombo = new Ext.form.ComboBox({
		allowBlank : false,
		autoScroll : true,
		mode: 'local',
		store : branchStore,
		valueField : 'BranchId',
		displayField : 'BranchName',
		emptyText : '<%=selectBranch%>',
		blankText : '<%=selectBranch%>',
		id: 'branchComboId',
		minChars : 3,
		typeAhead : true,
		resizable : true,
		forceSelection : true,
		triggerAction: 'all',
		cls: 'selectstylePerfect',
		listeners: {
			select: {
				fn: function(){
					branchId = Ext.getCmp('branchComboId').getValue();
					//alert('branchId : '+branchId);
				}
			}
		}
	});
	
	var transactionTypeStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashBookReportAction.do?param=getTransactionTypeStore',
		autoLoad: false,
		root: 'transactionTypeRoot',
		fields: ['transTypeID','transTypeName']
	});
	var transactionTypeCombo = new Ext.form.ComboBox({
		allowBlank : false,
		autoScroll : true,
		mode: 'local',
		store : transactionTypeStore,
		valueField : 'transTypeID',
		displayField : 'transTypeName',
		emptyText : 'Select Transaction Type',
		blankText: 'Select Transaction Type',
		id: 'transactionTypeComboId',
		minChars : 3,
		typeAhead : true,
		resizable : true,
		forceSelection : true,
		triggerAction: 'all',
		cls: 'selectstylePerfect',
		listeners: {
			select: function(){
				transactionTypeId = Ext.getCmp('transactionTypeComboId').getValue();
				//alert('transactionTypeId : '+transactionTypeId);
			}
		}
	});
	
   	
   	var selectionPanel = new Ext.Panel({
   		standardSubmit: false,
   		frame: true,
   		layout: 'table',
   		layoutConfig: {
   			columns: 11
   		},
   		items: [{ width: 50 },
   			{
   				xtype: 'label',
   				cls: 'labelstyle',
   				text: '<%=branch%>'
   			},
   				branchCombo,
   			{ width: 50 },
   			{
   				xtype: 'label',
   				cls: 'labelstyle',
   				text: '<%=transactionType%>'
   			},
   				transactionTypeCombo,
   			{ width: 50 },
   			{
   				xtype: 'label',
   				cls: 'labelstyle',
   				text: '<%=year%>'
   			},
   				yearCombo,
   			{ width: 50 },
   			{
   				xtype: 'button',
   				cls: '',
   				text: 'View',
   				handler: function(){
   					branchId = Ext.getCmp('branchComboId').getValue();
   					transactionTypeId = Ext.getCmp('transactionTypeComboId').getValue();
   					year = Ext.getCmp('yearComboId').getValue();
   					
   					if(Ext.getCmp('branchComboId').getValue() == "") {
						Ext.example.msg("<%=selectBranch%>");
						Ext.getCmp('branchComboId').focus();
						return;
					}
  		            if(Ext.getCmp('transactionTypeComboId').getRawValue() == "") {
						Ext.example.msg("<%=selectTransactionType%>");
						Ext.getCmp('transactionTypeComboId').focus();
						return;
					}
					if(Ext.getCmp('yearComboId').getValue() == "") {
						Ext.example.msg("<%=selectYear%>");
						Ext.getCmp('yearComboId').focus();
						return;
					} 
   					store.load({params:{
   						branchId : branchId, transactionTypeId: transactionTypeId, year: year, custId: globalClientId,jspName: jspName,
   						branchName: Ext.getCmp('branchComboId').getRawValue(), transacType: Ext.getCmp('transactionTypeComboId').getRawValue()
   					}});
   				}
   			}
   		]
   	});
   	
   		//******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'cashBookReaderId',
        root: 'cashBookReportRoot',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {name: 'accHeaderIndex'},
        {name: 'aprIndex'},
        {name: 'mayIndex'},
        {name: 'juneIndex'},
        {name: 'julyIndex'},
        {name: 'augIndex'},
        {name: 'sepIndex'},
        {name: 'octIndex'},
        {name: 'novIndex'},
        {name: 'decIndex'},
        {name: 'janIndex'},
        {name: 'febIndex'},
        {name: 'marIndex'}
        ]
    });

//************************* store configs
	var store =  new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/cashBookReportAction.do?param=getCashBookReportDetails',
        method: 'POST'
		}),
        remoteSort: false,
        storeId: 'cashBookStore',
        reader:reader
    });
    
//**********************filter config
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        	{type: 'numeric',dataIndex: 'slnoIndex'},
	        {type: 'string', dataIndex: 'accHeaderIndex'},
	        {type: 'numeric', dataIndex: 'aprIndex'},
	        {type: 'numeric', dataIndex: 'mayIndex'},
	        {type: 'numeric', dataIndex: 'juneIndex'},
	        {type: 'numeric', dataIndex: 'julyIndex'},
	        {type: 'numeric', dataIndex: 'augIndex'},
	        {type: 'numeric', dataIndex: 'sepIndex'},
	        {type: 'numeric', dataIndex: 'octIndex'},
	        {type: 'numeric', dataIndex: 'novIndex'},
	        {type: 'numeric', dataIndex: 'decIndex'},
	        {type: 'numeric', dataIndex: 'janIndex'},
	        {type: 'numeric', dataIndex: 'febIndex'},
	        {type: 'numeric', dataIndex: 'marIndex'}
        ]
    });

//**************column model config
    var createColModel = function (finish, start) {

        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=slNo%></span>",width:40}),
         {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=slNo%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },
        {
            dataIndex: 'accHeaderIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=accountHeader%></span>",
            filter:
            {
            	type: 'string'
			}
        },
		{
			dataIndex: 'aprIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=apr%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'mayIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=may%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'juneIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=june%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'julyIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=july%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'augIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=aug%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'sepIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=sep%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'octIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=oct%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'novIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=nov%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'decIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=dec%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
        {
			dataIndex: 'janIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=jan%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'febIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=feb%></span>",
            filter:
            {
            	type: 'numeric'
			}
		},
		{
			dataIndex: 'marIndex',
            hidden:false,
            header: "<span style=font-weight:bold;><%=mar%></span>",
            filter:
            {
            	type: 'numeric'
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

grid=getGrid('<%=cashBookReport%>','<%=NoRecordsFound%>',store,screen.width-60,430,17,filters,'Clear Filter Data',false,'',8,false,'',false,'',true,'Export',jspName,exportDataType,false,'',false,'',false,'Modify',false,'Delete');
   		
   		
   		Ext.onReady( function(){
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
			items: [selectionPanel, grid]
			//bbar:ctsb
			});
   		});
   	</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
