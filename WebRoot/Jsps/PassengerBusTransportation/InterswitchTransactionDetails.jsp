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
    tobeConverted.add("Phone_No");
    tobeConverted.add("Interswitch_Transaction_Details");
    tobeConverted.add("Transaction_Id");
    tobeConverted.add("Transaction_Status");
    tobeConverted.add("Response_Code");
    tobeConverted.add("Response_Description");
    tobeConverted.add("Month_Validation");
    
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
	String PhoneNo=convertedWords.get(16); 	
	String InterswitchTransactionDetails=convertedWords.get(17); 	
	String TransactionId=convertedWords.get(18); 	
	String TransactionStatus=convertedWords.get(19); 	
	String ResponseCode=convertedWords.get(20); 	
	String ResponseDescription=convertedWords.get(21); 
	String monthValidation=convertedWords.get(22); 	
	
%>

<jsp:include page="../Common/header.jsp" />
		<title>InterSwitch Transaction Details</title>		
   
  
  	
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			label
		{
			display : inline !important;
		}
		.ext-strict .x-form-text 
		{
			height : 21px !important;
		}
		.x-window-body {
				width : 121px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		</style>
		
   	<script>
   	var jspName = "<%=InterswitchTransactionDetails%>";
  	var exportDataType = "int,String,String,String,String,String,String,String,String,String";
    var outerPanel;
    var ctsb;
    var summaryGrid;
    var custId;
    var custName;
    var dtprev = dateprev;
    var dtcur = datecur;

    //***************************************Customer Store*************************************  		
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function (custstore, records, success, options) {
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
                fn: function () {
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
        root: 'interswitchDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'transactionIdIndex'
        },{
            name: 'phoneNoIndex'
        },{
            name: 'emailIndex'
        },{
            name: 'transactionStatusIndex'
        },{
            name: 'amountIndex'
        },{
            name: 'responseCodeIndex'
        },{
            name: 'responseDescriptionIndex'
        },{
            name: 'transactionDateIndex'
        },{
            name: 'insertedDateIndex'
        }]
    });

    var Store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/InterswitchTransactionDetailsAction.do?param=getTransactionDetails',
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
        },{
            type: 'string',
            dataIndex: 'emailIndex'
        },{
            type: 'string',
            dataIndex: 'transactionStatusIndex'
        },{
            type: 'string',
            dataIndex: 'amountIndex'
        },{
            type: 'string',
            dataIndex: 'responseCodeIndex'
        },{
            type: 'string',
            dataIndex: 'responseDescriptionIndex'
        },{
            type: 'string',
            dataIndex: 'transactionDateIndex'
        },{
            type: 'string',
            dataIndex: 'insertedDateIndex'
        }]
    });

    //************************************Column Model Config******************************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TransactionId%></span>",
                dataIndex: 'transactionIdIndex',
                width: 150,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
                dataIndex: 'phoneNoIndex',
                width: 150,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Email%></span>",
                dataIndex: 'emailIndex',
                width: 200,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=TransactionStatus%></span>",
                dataIndex: 'transactionStatusIndex',
                width: 150,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=Amount%></span>",
                dataIndex: 'amountIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=ResponseCode%></span>",
                dataIndex: 'responseCodeIndex',
                width: 150,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=ResponseDescription%></span>",
                dataIndex: 'responseDescriptionIndex',
                width: 150,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TransactionDate%></span>",
                dataIndex: 'transactionDateIndex',
                width: 150,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=InsertedDate%></span>",
                dataIndex: 'insertedDateIndex',
                width: 150,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
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
    
    summaryGrid = getGrid('', '<%=NoRecordsFound%>', Store, screen.width - 35, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '',false, '', false, '');

    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'<%=InterswitchTransactionDetails%>',
        id: 'panelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 10
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo,
            {width:'30px'},
            {
            xtype: 'label',
            text:  '<%=From_Date%>'+ ' :',
            cls: 'labelstyle',
            id: 'tripStartDtLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            value:dtprev,
            id: 'fromDtId'
        }, {width:'30px'},{
            xtype: 'label',
            text: '<%=To_Date%>' + ' :',
            cls: 'labelstyle',
            id: 'tripEndDtLabelId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            value:dtcur,
            id: 'toDtId'
        },{width:'30px'},{
  		        xtype: 'button',
  		        text: '<%=Submit%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
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
  		                        var fromdate = Ext.getCmp('fromDtId').getValue();
  		                        var todate = Ext.getCmp('toDtId').getValue();
  		                        
  		                      if (dateCompare(fromdate,todate) == -1) {
                             Ext.example.msg("ToDate Must Be Greaterthan FromDate");
                             Ext.getCmp('toDtId').focus();
                             return;
                               }
                              if (checkMonthValidation(fromdate,todate)) {
                             Ext.example.msg("<%=monthValidation%>");
                             Ext.getCmp('todate').focus();
                             return;
                               }
                              
 		                        Store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                fromdate: Ext.getCmp('fromDtId').getValue(),
  		                                todate: Ext.getCmp('toDtId').getValue(),
  		                                custName:Ext.getCmp('custcomboId').getRawValue(),
 		                                jspName:jspName
                                    }
                                });
  		                    }
  		                }
  		            }
  		    }
        ]
    }); // End of Panel	
    
    Ext.onReady(function () {
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
    		  items: [innerPanel, summaryGrid]  
            //bbar: ctsb
        });
    });
</script>
  	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->