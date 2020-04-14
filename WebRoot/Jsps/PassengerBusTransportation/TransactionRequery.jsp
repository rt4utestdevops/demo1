<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
   
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Trip_Summary_Report");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("SLNO");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Excel");
    tobeConverted.add("Select_From_Date");
    tobeConverted.add("Select_To_Date");
    tobeConverted.add("From_Date");
    tobeConverted.add("To_Date");
    tobeConverted.add("Submit");
    tobeConverted.add("Email_ID");
    tobeConverted.add("Inserted_Time");
    tobeConverted.add("Transaction_Date");
    tobeConverted.add("Amount");
    tobeConverted.add("View");
    tobeConverted.add("Transaction_Id");
    tobeConverted.add("Phone_No");
    tobeConverted.add("Transaction_Status");
    tobeConverted.add("Response_Code");
    tobeConverted.add("Response_Description");
    tobeConverted.add("Transaction_Requery");
    tobeConverted.add("Requery");
    
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String TripSummaryReport = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	String SlNo = convertedWords.get(3);
	String NoRecordsFound = convertedWords.get(4);
	String ClearFilterData = convertedWords.get(5);
	String Excel = convertedWords.get(6); 
	String Select_From_Date = convertedWords.get(7); 	
	String Select_To_Date=convertedWords.get(8); 	
	String From_Date=convertedWords.get(9); 
	String To_Date=convertedWords.get(10);
	String Submit=convertedWords.get(11); 		
	String Email=convertedWords.get(12); 		
	String InsertedDate=convertedWords.get(13); 		
	String TransactionDate=convertedWords.get(14); 		
	String Amount=convertedWords.get(15); 	
	String View=convertedWords.get(16);
	String TransactionId=convertedWords.get(17);
	String PhoneNo=convertedWords.get(18);
	String TransactionStatus=convertedWords.get(19);
	String ResponseCode=convertedWords.get(20);
	String ResponseDescription=convertedWords.get(21);
	String TransactionRequery=convertedWords.get(22);
	String Requery=convertedWords.get(23);
	
	
%>

<jsp:include page="../Common/header.jsp" />
		<title>Transaction Requery</title>		
	    
  
  	
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height : 21px !important;
			}
		

		</style>
   	<script>
   	var jspName = "<%=TransactionRequery%>";
 	var exportDataType = " ";
 	var outerPanel;
 	var ctsb;
 	var summaryGrid;
 	var custId;
 	var custName;
 	var dtprev = dateprev;
 	var dtcur=new Date();
 	//var MS_PER_MINUTE = 60000;
 	//var durationInMinutes = 15;
 	//var dtcur = new Date(new Date() - durationInMinutes * MS_PER_MINUTE);

 	//***************************************Customer Store*************************************  		
 	var customercombostore = new Ext.data.JsonStore({
 		url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
 		id: 'CustomerStoreId',
 		root: 'CustomerRoot',
 		autoLoad: true,
 		remoteSort: true,
 		fields: ['CustId', 'CustName'],
 		listeners: {
 			load: function(custstore, records, success, options) {
 				if ( <%= customerId %> > 0) {
 					Ext.getCmp('custcomboId').setValue('<%=customerId%>');

 					custId = Ext.getCmp('custcomboId').getValue();
 					custName = Ext.getCmp('custcomboId').getRawValue();

 					parent.globalCustomerID = custId;
 					parent.globalCustomerName = custName;

 				}
 			}
 		}
 	});

 	var custnamecombo = new Ext.form.ComboBox({
 		store: customercombostore,
 		id: 'custcomboId',
 		mode: 'local',
 		forceSelection: true,
 		emptyText: '<%=SelectCustomer%>',
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
 					custId = Ext.getCmp('custcomboId').getValue();
 					custName = Ext.getCmp('custcomboId').getRawValue();

 					parent.globalCustomerID = custId;
 					parent.globalCustomerName = custName;
 				}
 			}
 		}
 	});
 	var reader = new Ext.data.JsonReader({
 		idProperty: 'readerId',
 		root: 'requryRoot',
 		totalProperty: 'total',
 		fields: [{
 			name: 'slnoIndex'
 		}, {
 			name: 'transactionIdIndex'
 		}, {
 			name: 'phoneNoIndex'
 		}, {
 			name: 'emailIndex'
 		}, {
 			name: 'amountIndex'
 		}, {
 			name: 'transactionStatusIndex'
 		}]
 	});

 	var store = new Ext.data.GroupingStore({
 		autoLoad: false,
 		proxy: new Ext.data.HttpProxy({
 			url: '<%=request.getContextPath()%>/TransactionRequeryAction.do?param=getRequeryDetails',
 			method: 'POST'
 		}),
 		remoteSort: false,
 		storeId: 'transactionStoreId',
 		reader: reader
 	});

 	var filters = new Ext.ux.grid.GridFilters({
 		local: true,
 		filters: [{
 			type: 'numeric',
 			dataIndex: 'slnoIndex'
 		}, {
 			type: 'string',
 			dataIndex: 'transactionIdIndex'
 		}, {
 			type: 'string',
 			dataIndex: 'phoneNoIndex'
 		}, {
 			type: 'string',
 			dataIndex: 'emailIndex'
 		}, {
 			type: 'string',
 			dataIndex: 'amountIndex'
 		}, {
 			type: 'string',
 			dataIndex: 'transactionStatusIndex'
 		}]
 	});

 	//************************************Column Model Config******************************************

 	var colModel = new Ext.grid.ColumnModel({

 		columns: [
 		new Ext.grid.RowNumberer({
 			header: "<span style=font-weight:bold;><%=SlNo%></span>",
 			width: 50
 		}), {
 			dataIndex: 'slnoIndex',
 			hidden: true,
 			header: "<span style=font-weight:bold;><%=SlNo%></span>"

 		}, {
 			header: "<span style=font-weight:bold;><%=TransactionId%></span>",
 			dataIndex: 'transactionIdIndex',
 			width: 200
 		}, {
 			header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
 			dataIndex: 'phoneNoIndex',
 			width: 208
 		}, {
 			header: "<span style=font-weight:bold;><%=Email%></span>",
 			dataIndex: 'emailIndex',
 			width: 325
 		}, {
 			header: "<span style=font-weight:bold;><%=Amount%></span>",
 			dataIndex: 'amountIndex',
 			width: 200
 		}, {
 			header: "<span style=font-weight:bold;><%=TransactionStatus%></span>",
 			dataIndex: 'transactionStatusIndex',
 			width: 200
 		}, {
 			header: 'Requery',
 			dataIndex: 'requeryIndex',
 			xtype: 'actioncolumn',
 			width: 100,
 			items: [{
 				icon: '/ApplicationImages/ApplicationButtonIcons/requery_button.png',
 				tooltip: 'Requery',
 				handler: function(grid, rowIndex, colIndex) {
 					var record = grid.getStore().getAt(rowIndex); // Get the Record	
 					transaction = record.get('transactionIdIndex');
 					buttonValue = "<%=Requery%>";
 					Ext.MessageBox.show({
 						title: '',
 						msg: 'Are you sure, you want to Requery for the Transaction_Id : ' + transaction + '?',
 						buttons: Ext.MessageBox.YESNO,
 						icon: Ext.MessageBox.QUESTION,
 						fn: function(btn) {
 							if (btn == 'yes') {
 								Ext.Ajax.request({
 									url: '<%=request.getContextPath()%>/TransactionRequeryAction.do?param=getRequeryPermission',
 									method: 'POST',
 									params: {
 										transaction: transaction
 									},
 									success: function(response, options) {
 									store.load({
 									params: {
 										CustId: Ext.getCmp('custcomboId').getValue(),
 										fromdate: Ext.getCmp('fromDtId').getValue(),
 										todate: Ext.getCmp('toDtId').getValue()
 									        }
 								        });
 									
 										var message = response.responseText;
 										var reasons = message.split("|");
 										var description = reasons[0];
 										if (description == "null") {
 											description = "Not Available";
 										}
 										var code = reasons[1];
 										Ext.MessageBox.show({
 											title: '',
 											msg: 'Your Transaction has been Requeried Suceesfully and Response Description is : ' + description + ' And Response Code is : ' + code,
 											buttons: Ext.MessageBox.OK,
 										});
 									},
 									failure: function() {
 										Ext.example.msg("Error");
 									}
 								});
 								
 							}
 						}
 					});
 				}
 			}]
 		}

 		]
 	});


 	var grid = new Ext.grid.GridPanel({
 		height: 400,
 		width: screen.width - 45,
 		disableSelection: true,
 		store: store,
 		colModel: colModel,
 		viewConfig: {
 			forceFit: true
 		},
 		plugins: [filters],
 		view: new Ext.grid.GridView({
 			loadMask: true,
 			emptyText: 'NoRecordsFound'
 		})
 	});
 	var innerPanel = new Ext.Panel({
 		standardSubmit: true,
 		collapsible: false,
 		title: '<%=TransactionRequery%>',
 		id: 'panelId',
 		layout: 'table',
 		frame: true,
 		layoutConfig: {
 			columns: 12
 		},
 		items: [{
 			xtype: 'label',
 			text: '<%=CustomerName%>' + ' :',
 			cls: 'labelstyle',
 			id: 'custnamelab'
 		},
 		custnamecombo, {
 			width: '30px'
 		}, {
 			xtype: 'label',
 			text: '<%=From_Date%>' + ' :',
 			cls: 'labelstyle',
 			id: 'tripStartDtLabelId'
 		}, {
 			xtype: 'datefield',
 			cls: 'selectstylePerfect',
 			format: getDateTimeFormat(),
 			value: dtprev,
 			id: 'fromDtId'
 		}, {
 			width: '30px'
 		}, {
 			xtype: 'label',
 			text: '<%=To_Date%>' + ' :',
 			cls: 'labelstyle',
 			id: 'tripEndDtLabelId'
 		}, {
 			xtype: 'datefield',
 			cls: 'selectstylePerfect',
 			format: getDateTimeFormat(),
 			value: dtcur,
 			id: 'toDtId'
 		}, {
 			width: '30px'
 		}, {
 			xtype: 'button',
 			text: '<%=View%>',
 			id: 'addbuttonid',
 			cls: ' ',
 			width: 80,
 			listeners: {
 				click: {
 					fn: function() {
 						var fromdate = Ext.getCmp('fromDtId').getValue();
 						var todate = Ext.getCmp('toDtId').getValue();
 						//dtcur = new Date(new Date() - durationInMinutes * MS_PER_MINUTE);

 						if (Ext.getCmp('custcomboId').getValue() == "") {
 							Ext.example.msg("<%=SelectCustomer%>");
 							Ext.getCmp('custcomboId').focus();
 							return;
 						}
 						if (Ext.getCmp('fromDtId').getValue() == "") {
 							Ext.example.msg("<%=Select_From_Date%>");
 							Ext.getCmp('fromDtId').focus();
 							return;
 						}
 						if (Ext.getCmp('toDtId').getValue() == "") {
 							Ext.example.msg("<%=Select_To_Date%>");
 							Ext.getCmp('toDtId').focus();
 							return;
 						}


 						if (dateCompare(fromdate, todate) == -1) {
 							Ext.example.msg("To Date Must Be Grater Than From Date");
 							Ext.getCmp('toDtId').focus();
 							return;
 						}
 					//	if (dateCompare(todate, dtcur) == -1) {
 						//	Ext.example.msg("End Time Must Be 15min Less Than Current Time");
 						//	Ext.getCmp('toDtId').focus();
 						//	return;
 					//	}
 						store.load({
 							params: {
 								CustId: Ext.getCmp('custcomboId').getValue(),
 								fromdate: Ext.getCmp('fromDtId').getValue(),
 								todate: Ext.getCmp('toDtId').getValue()
 							}
 						});
 					}
 				}
 			}
 		}

 		]
 	}); // End of Panel	

 	Ext.onReady(function() {
 		ctsb = tsb;
 		Ext.QuickTips.init();
 		Ext.form.Field.prototype.msgTarget = 'side';

 		outerPanel = new Ext.Panel({
 			renderTo: 'content',
 			standardSubmit: true,
 			frame: true,
 			cls: 'outerpanel',
 			layout: 'table',
 			layoutConfig: {
 				columns: 1
 			},
 			items: [innerPanel, grid]
 			//bbar: ctsb

 		});
 	});
</script>
  	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->