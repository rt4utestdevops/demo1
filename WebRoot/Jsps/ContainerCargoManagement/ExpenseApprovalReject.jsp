<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userID=loginInfo.getUserId();
		String userAuthority=cf.getUserAuthority(systemId,userID);
		if(loginInfo.getCustomerId()>0 && loginInfo.getIsLtsp() == -1 && (!userAuthority.equalsIgnoreCase("Admin"))) 
		{
			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
		}

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Cancel");
tobeConverted.add("Principal_Name");
tobeConverted.add("Consignee_Name");
tobeConverted.add("Select_Status");
tobeConverted.add("Unique_Id");
tobeConverted.add("Trip_No");
tobeConverted.add("Trip_Date");
tobeConverted.add("Amount");
tobeConverted.add("Description");
tobeConverted.add("Approved_Amount");
tobeConverted.add("Account_Header");
tobeConverted.add("Remarks");
tobeConverted.add("BranchID");
tobeConverted.add("Driver_Id");
tobeConverted.add("Enter_Approved_amount");
tobeConverted.add("Approved_amount_Validation");
tobeConverted.add("Select_Account_Header");
tobeConverted.add("Enter_Remarks");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Status");
tobeConverted.add("Asset_No");
tobeConverted.add("Expense_Approval_Reject_Report");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String NoRecordsFound=convertedWords.get(0);
String ClearFilterData=convertedWords.get(1);
String SLNO=convertedWords.get(2);
String ID=convertedWords.get(3);
String NoRowsSelected=convertedWords.get(4);
String SelectSingleRow=convertedWords.get(5);
String Cancel=convertedWords.get(6);
String PrincipalName=convertedWords.get(7);
String ConsigneeName=convertedWords.get(8);
String SelectStatus=convertedWords.get(9);
String UniqueId=convertedWords.get(10);
String TripNo=convertedWords.get(11);
String TripDate=convertedWords.get(12);
String Amount=convertedWords.get(13);
String Description=convertedWords.get(14);
String ApprovedAmount=convertedWords.get(15);
String AccountHeader=convertedWords.get(16);
String Remarks=convertedWords.get(17);
String BranchId=convertedWords.get(18);
String DriverId=convertedWords.get(19);
String EnterApprovedamount=convertedWords.get(20);
String ApprovedAmountValidation=convertedWords.get(21);
String SelectAccountHeader=convertedWords.get(22);
String EnterRemarks=convertedWords.get(23);
String StartDate=convertedWords.get(24);
String SelectStartDate=convertedWords.get(25);
String PleaseSelectStartDate = convertedWords.get(26);
String EndDate=convertedWords.get(27);
String SelectEndDate=convertedWords.get(28);
String PleaseSelectEndDate = convertedWords.get(29);
String EndDateMustBeGreaterthanStartDate = convertedWords.get(30);
String monthValidation = convertedWords.get(31);
String status = convertedWords.get(32);
String AssetNo = convertedWords.get(33);

int userId=loginInfo.getUserId(); 

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Expense Approval Reject</title>		
  
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	.x-layer ul {
		min-height: 27px !important;
	}
	label {
		display : inline !important;
	}
   </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Expense Approval";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,date,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var editedRows = "";

var Status=[['Pending'],['Approved'],['Rejected']];
			var Statusstore=new Ext.data.SimpleStore({
				data:Status,
				fields:['Statusid']
			});
			
			var StatusCombo=new Ext.form.ComboBox({
				frame:true,
				store:Statusstore,
				id:'statuscomboId',
				forceselection:true,
				enableKeyEvents:true,
				emptyText: '<%=SelectStatus%>',
				blankText: '<%=SelectStatus%>',
				mode:'local',
				anyMatch:true,
				value:'',
				onTypeAhead:true,
				triggerAction:'all',
				displayField:'Statusid',
				cls: 'selectstylePerfect',
				valueField:'Statusid',
				listeners: {
						select: {
							fn:function(){
								status = Ext.getCmp('statuscomboId').getValue();
					            endDate = Ext.getCmp('endDateId').getValue().format('Y-m-d H:i:s');
								startDate = Ext.getCmp('startDateId').getValue().format('Y-m-d H:i:s');
								store.load({ params: {
											status: status, endDate: endDate, startDate: startDate, jspName: jspName
							  		    }
						     		});
							     	 if(Ext.getCmp('statuscomboId').getValue()== "Pending"){
							     	    grid.getColumnModel().setColumnHeader(9, '<b>Approved Amount</b>');							     	 
							     		Ext.getCmp('addButtonId').enable();
							     		Ext.getCmp('modifyButtonId').enable();
							     		grid.getColumnModel().setEditable( 9, true );
							     		grid.getColumnModel().setEditable( 10, true );
							     		grid.getColumnModel().setEditable( 11, true );
							     		grid.getColumnModel().setEditable( 12, true );
							     		grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('accountHeaderIndex'), false);
							     		grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('accountHeaderNameIndex'), true);
							     	 }else{							     	 
							     		Ext.getCmp('addButtonId').disable();
							     		Ext.getCmp('modifyButtonId').disable();
							     		grid.getColumnModel().setEditable( 9, false );
							     		grid.getColumnModel().setEditable( 10,false );
							     		grid.getColumnModel().setEditable( 11,false );
							     		grid.getColumnModel().setEditable( 12, true );
							     		grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('accountHeaderIndex'), true);
							     		grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('accountHeaderNameIndex'), false);
							     	}
							     	if(Ext.getCmp('statuscomboId').getValue()== "Rejected"){
									    grid.getColumnModel().setColumnHeader(9, '<b>Rejected Amount</b>');
									}else if(Ext.getCmp('statuscomboId').getValue()== "Approved"){
									    grid.getColumnModel().setColumnHeader(9, '<b>Approved Amount</b>');
									 }
							     		
							     	}
								}
							}
					});	
		
    var accHeaderStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ExpenseApprovalRejectAction.do?param=getAccHeaderDetails',
        id: 'accHeaderStoreId',
        root: 'accHeaderStoreRoot',
        remoteSort: true,
        autoLoad: true,
        fields: ['accHeaderId', 'accHeaderName']
    });
    
    var accHeaderCombo = new Ext.form.ComboBox({
	    value: '',
	    width: 175,
	    store: accHeaderStore,
	    displayField: 'accHeaderName',
	    valueField: 'accHeaderId',
	    mode: 'local',
	    forceSelection: true,
	    triggerAction: 'all',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    selectOnFocus: true,
	    emptyText: 'Select AccHeader',
	    labelSeparator: '',
	    id: 'accHeaderId',
	    loadingText: 'Searching...',
	    enableKeyEvents: true,
	    cls:'selectstylePerfectnew',
	    listeners: {
	        select: {
	            fn: function() {
	                accHeaderId = Ext.getCmp('accHeaderId').getValue();
	            }
	        }
	    }
    }); 
var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=SelectStatus%>' + ' :',
            cls: 'labelstyle'
        },
        StatusCombo,
        {width: 50},
        {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab2',
            width: 200,
            text: '<%=StartDate%>' + ' :'
            },  
			{
            xtype: 'datefield',          
            emptyText: '<%=SelectStartDate%>',
            allowBlank: false,
            blankText: '<%=SelectStartDate%>',
            id: 'startDateId',        
            cls: 'selectstylePerfect' ,
            format: getDateTimeFormat(),
            value: previousDate, 
            maxValue: previousDate        
            },
			{ width:50 },
			{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'endDatelablepmr',
            width: 200,
            text: '<%=EndDate%>' + ' :'
            },  
			{
            xtype: 'datefield',          
            emptyText: '<%=SelectEndDate%>',
            allowBlank: false,
            blankText: '<%=SelectEndDate%>',
            id: 'endDateId',        
            cls: 'selectstylePerfect' ,
            format: getDateTimeFormat(),
            value: nextDate, 
            maxValue: nextDate         
            },
			{ width:50 },
			{
            xtype: 'button',
            text: 'View',
            id: 'ViewButtonId',
            cls: 'buttonStyle',
            width: 60,
            handler: function() {
	            status = Ext.getCmp('statuscomboId').getValue();
	            endDate = Ext.getCmp('endDateId').getValue().format('Y-m-d H:i:s');
				startDate = Ext.getCmp('startDateId').getValue().format('Y-m-d H:i:s');
				
            	 if(Ext.getCmp('statuscomboId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectStatus%>");
  		                   Ext.getCmp('statuscomboId').focus();
  		                   return;
  		         }
  		         if(Ext.getCmp('startDateId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectStartDate%>");
  		                   Ext.getCmp('startDateId').focus();
  		                   return;
  		         }
  		         if(Ext.getCmp('endDateId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectEndDate%>");
  		                   Ext.getCmp('endDateId').focus();
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
  		         
  		         store.load({ params: {
							status: status, endDate: endDate, startDate: startDate, jspName: jspName
			  		    }
		     		});
            	}
            }
    ]
});

    
var reader = new Ext.data.JsonReader({
    idProperty: 'expenseid',
    root: 'expenseRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'uniqueIdDataIndex'
    },{
        name: 'tripNoindex'
    },{
        name: 'tripDateIndex'
    },{
        name: 'principalNameIndex'
    },{
        name: 'consigneeNameIndex'
    },{
        name: 'amountIndex'
    },{
        name: 'descriptionIndex'
    },{
        name: 'approvedAmountIndex'
    },{
        name: 'accountHeaderIndex'
    },{
    	name: 'accountHeaderNameIndex'
    },{
        name: 'remarksIndex'
    },{
        name: 'branchIndex'
    },{
        name: 'driverIndex'
    },{
    	name: 'addExpDateIndex'
    },{
    	name: 'assetNoIndex'
    },{
        name: 'billingTypeIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ExpenseApprovalRejectAction.do?param=getExpenseDetails',
        method: 'POST'
    }),
    storeId: 'expenseStoreId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'int',
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'tripNoindex'
    }, {
        type: 'string',
        dataIndex: 'tripDateIndex'
    }, {
        type: 'string',
        dataIndex: 'principalNameIndex'
    }, {
        type: 'string',
        dataIndex: 'consigneeNameIndex'
    }, {
        type: 'string',
        dataIndex: 'amountIndex'
    }, {
        type: 'string',
        dataIndex: 'descriptionIndex'
    },{
        type: 'string',
        dataIndex: 'approvedAmountIndex'
    },{
        type: 'string',
        dataIndex: 'accountHeaderIndex'
    },{
        type: 'string',
        dataIndex: 'accountHeaderNameIndex'
    },{
        type: 'string',
        dataIndex: 'remarksIndex'
    },{
        type: 'string',
        dataIndex: 'branchIndex'
    },{
        type: 'string',
        dataIndex: 'driverIndex'
    },{
    	type: 'date',
    	dataIndex: 'addExpDateIndex'
    },{
    	type: 'String',
    	dataIndex: 'assetNoIndex'
    },{
    	type: 'String',
    	dataIndex: 'billingTypeIndex'
    }]
});


var createColModel = function(finish, start) {
     var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=UniqueId%></span>",
            hidden: true,
            dataIndex: 'uniqueIdDataIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=TripNo%></span>",
            dataIndex: 'tripNoindex',
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=TripDate%></span>",
            dataIndex: 'tripDateIndex',
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PrincipalName%></span>",
            dataIndex: 'principalNameIndex',
            width: 140,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ConsigneeName%></span>",
            dataIndex: 'consigneeNameIndex',
            width: 140,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Amount%></span>",
            dataIndex: 'amountIndex',
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Description%></span>",
            dataIndex: 'descriptionIndex',
            width: 135,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ApprovedAmount%></span>",
            dataIndex: 'approvedAmountIndex',
            width: 120,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({allowNegative: false,decimalPrecision:2})),
            editable: true
        },{
            header: "<span style=font-weight:bold;><%=AccountHeader%></span>",
            dataIndex: 'accountHeaderIndex',
            width: 140,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(accHeaderCombo),
            renderer: accHeaderRenderer
        },{
            header: "<span style=font-weight:bold;><%=AccountHeader%></span>",
            dataIndex: 'accountHeaderNameIndex',
            hidden: true,
            width: 140,
            filter: {
                type: 'string'
            },
        },{
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            dataIndex: 'remarksIndex',
            width: 140,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                width: 100,
                editable: true,
                id: 'remarksId'
            }))
        },{
            header: "<span style=font-weight:bold;><%=BranchId%></span>",
            dataIndex: 'branchIndex',
            hidden: true,
            hideable:false,
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DriverId%></span>",
            dataIndex: 'driverIndex',
            hideable:false,
            hidden: true,
            width: 50,
            filter: {
                type: 'string'
            }
        },{
        	header: "<span style=font-weight:bold;>Add Exp Date</span>",
            dataIndex: 'addExpDateIndex',
            width: 140,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=AssetNo%></span>",
            dataIndex: 'assetNoIndex',
            width: 140,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Billing Type</span>",
            dataIndex: 'billingTypeIndex',
            width: 140,
            filter: {
                type: 'string'
            }
        }
    ];
  
    
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
}; 

grid = getEditorGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 18, filters, '<%=ClearFilterData%>', false, '', 18, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Approve', true, 'Reject', true, 'View Document');
	
	function addRecord() {
		buttonValue = "Approve";
		var selected = grid.getSelectionModel().getSelected();
		grid.stopEditing();
		if (grid.getSelectionModel().getCount() == 0) {
				Ext.example.msg("<%=NoRowsSelected%>");
				return;
		}
		if (grid.getSelectionModel().getCount() > 1) {
				Ext.example.msg("<%=SelectSingleRow%>");
				return;
		}
		if(selected.data['approvedAmountIndex'] == 0){
			Ext.example.msg("<%=EnterApprovedamount%>");
			return;
		}
		if(selected.data['approvedAmountIndex'] > selected.data['amountIndex']){
			Ext.example.msg("<%=ApprovedAmountValidation%>");
			return;
		}
		if(selected.data['accountHeaderIndex'] == ""){
			Ext.example.msg("<%=SelectAccountHeader%>");
			return;
		}
		if(selected.data['remarksIndex'] == ""){
			Ext.example.msg("<%=EnterRemarks%>");
			return;
		}
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/ExpenseApprovalRejectAction.do?param=ApproveExpense',
                          method: 'POST',
                          params: {
                          		buttonValue: buttonValue,
								uniqueId  : selected.data['uniqueIdDataIndex'],
								tripNo  : selected.data['tripNoindex'],
								tripDate  : selected.data['tripDateIndex'],
								amount    : selected.data['amountIndex'],
								description : selected.data['descriptionIndex'],
								appamount : selected.data['approvedAmountIndex'],
								accheader : selected.data['accountHeaderIndex'],
								remarks : selected.data['remarksIndex'],
								branchId : selected.data['branchIndex'],
								driverId : selected.data['driverIndex'],
								addExpDate : selected.data['addExpDateIndex'],
								assetNo : selected.data['assetNoIndex']
                          },
                          success: function(response, options) {
                          		var str=response.responseText;
								var array = str.split(",");
								var message = array[0];
								var groupid = array[1];
                              	store.reload();
                              	Ext.example.msg(message);
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              store.reload();
                          }
             		});
				}

	function modifyData() {
    	buttonValue = "Reject";
		var selected = grid.getSelectionModel().getSelected();
		grid.stopEditing();
		if (grid.getSelectionModel().getCount() == 0) {
				Ext.example.msg("<%=NoRowsSelected%>");
				return;
		}
		if (grid.getSelectionModel().getCount() > 1) {
				Ext.example.msg("<%=SelectSingleRow%>");
				return;
		}
		if(selected.data['approvedAmountIndex'] > 0){
			Ext.example.msg("Approved amount should not be greater than Zero while Rejecting");
			return;
		}
		if(selected.data['accountHeaderIndex']){
			Ext.example.msg("Please do not select Account Header while Rejecting");
			return;
		}
		if(selected.data['remarksIndex'] == ""){
			Ext.example.msg("<%=EnterRemarks%>");
			return;
		}
		
			 Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/ExpenseApprovalRejectAction.do?param=RejectExpense',
                          method: 'POST',
                          params: {
                          		buttonValue: buttonValue,
								uniqueId  : selected.data['uniqueIdDataIndex'],
								tripNo  : selected.data['tripNoindex'],
								tripDate  : selected.data['tripDateIndex'],
								amount    : selected.data['amountIndex'],
								description : selected.data['descriptionIndex'],
								remarks : selected.data['remarksIndex'],
								branchId : selected.data['branchIndex'],
								driverId : selected.data['driverIndex'],
								addExpDate : selected.data['addExpDateIndex'],
								assetNo : selected.data['assetNoIndex']
                          },
                          success: function(response, options) {
                          		var str=response.responseText;
								var array = str.split(",");
								var message = array[0];
								var groupid = array[1];
								Ext.example.msg(message);
                              	store.reload();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              store.reload();
                          }
                   });
    		}
	
	function deleteData() {
		buttonValue = 'Document';
		var selected = grid.getSelectionModel().getSelected();
		grid.stopEditing();
		if (grid.getSelectionModel().getCount() == 0) {
				Ext.example.msg("<%=NoRowsSelected%>");
				return;
		}
		if (grid.getSelectionModel().getCount() > 1) {
				Ext.example.msg("<%=SelectSingleRow%>");
				return;
		}
		var id = selected.data['uniqueIdDataIndex'];
		console.log('id : '+id);
		Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/ExpenseApprovalRejectAction.do?param=isInvoiceExists',
	        method: 'POST',
	        params: {
	           id: id
	        },
	        success: function(response, options) {
	        	if(response.responseText == "No File Founds..." || response.responseText == ""){
	        	//alert('if  ' + response.responseText);
	        		Ext.example.msg("No File Founds...");
	        	} else {
	        	//alert('else '+response.responseText);
	        		parent.open('<%=request.getContextPath()%>'+"/viewAddExpDocumentPT?&id="+id);
	        	}
	        },
	        failure: function() {
				Ext.example.msg("No File Founds...");
	        }
	    });
	 
	}
	
	
    function accHeaderRenderer(value, p, r) {
        var returnValue = "";
        if (accHeaderStore.isFiltered()) {
            accHeaderStore.clearFilter();
        }
        var idx = accHeaderStore.findBy(function(record) {
            if (record.get('accHeaderId') == value) {
                returnValue = record.get('accHeaderName');
                return true;
            }
        });
        return returnValue;
    }
		
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Expense Approval and Reject',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel,grid]
    });
     
     accHeaderStore.load();
    sb = Ext.getCmp('form-statusbar');
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>