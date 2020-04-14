<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	
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
String Excel;
String NoRecordsFound;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Vault Inward</title>
    
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
    var jspName = "vaultinventory";
	 var exportDataType = "int,string,string,string,string";
	  var cvsCustId = 0 ; 

  var reader = new Ext.data.JsonReader({
         idProperty: 'vaultdetailid',
        root: 'VaultIventoryRoot',
        totalProperty: 'total',
        fields: [{
        name: 'slnoDataIndex'
        },{
            name: 'customerIDindex'
        
        }, {
            name: 'customernameindex'
        
        }, 
        {
            name: 'availableBalance'
        },
        {
            name: 'concolidatedcash'
        },{
            name: 'sealedbagcashindex'
        
         },{
            name: 'checkcashindex'
        
         },{
            name: 'jewellerycashindex'
        
         }, {
            name: 'forexcashindex'
        
         },{
            name: 'totalamountindex'
        }
        ]
    });

	 var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getVaultInventory',
	        method: 'POST'
	    }),
	    storeId: 'vaultinwards',
	    reader: reader
	    
	});
 
     var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
        type: 'int',
            dataIndex: 'slnoDataIndex'
        },{
            type: 'int',
            dataIndex: 'customerIDindex'
        },  {
            type: 'string',
            dataIndex: 'customernameindex'
        }, {
            type: 'string',
            dataIndex: 'availableBalance'
        }, {
            type: 'string',
            dataIndex: 'concolidatedcash'
        }, {
            type: 'string',
            dataIndex: 'sealedbagcashindex'       
           
         },{
            type: 'string',
            dataIndex: 'checkcashindex'       
           
         },{
            type: 'string',
            dataIndex: 'jewellerycashindex'       
           
         },{
            type: 'string',
            dataIndex: 'forexcashindex'       
           
         },{
            type: 'string',
            dataIndex: 'totalamountindex'     
        } 
        ]
    });
  
 
   
    var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 60
        }), 
        {
        dataIndex: 'slnoDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 200,
            
            filter: {
                type: 'int'
            }
            }, {
        
            dataIndex: 'customerIDindex',
            hidden: true,
            header: "<span style=font-weight:bold;>CustomerID</span>",
            width: 400,
         
            filter: {
                type: 'int'
            }
            },
            {
        
            dataIndex: 'customernameindex',
            hidden: false,
            header: "<span style=font-weight:bold;>CustomerName</span>",
            width: 400,
         
            filter: {
                type: 'string'
            }
            }, {
            header: "<span style=font-weight:bold;>Available Balance (LKR)</span>",
            hidden: false,
            width: 500,
            //sortable: false,
            dataIndex: 'availableBalance',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Ledger Amount (LKR)</span>",
            hidden: false,
            width: 500,
            //sortable: false,
            dataIndex: 'concolidatedcash',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Sealed Bag Cash (LKR)</span>",
            hidden: false,
            width:500,
            //sortable: true,
            dataIndex: 'sealedbagcashindex',
           
            filter: {
                type: 'string'
            }
       
           
        },{
            header: "<span style=font-weight:bold;>Cheque Amount (LKR)</span>",
            hidden: false,
            width:500,
            //sortable: true,
            dataIndex: 'checkcashindex',
           
            filter: {
                type: 'string'
            }
       
           
        },{
            header: "<span style=font-weight:bold;>Jewellery Amount (LKR)</span>",
            hidden: false,
            width:500,
            //sortable: true,
            dataIndex: 'jewellerycashindex',
           
            filter: {
                type: 'string'
            }
       
           
        },{
            header: "<span style=font-weight:bold;>Foreign Currency Amount (LKR)</span>",
            hidden: false,
            width:500,
            //sortable: true,
            dataIndex: 'forexcashindex',
           
            filter: {
                type: 'string'
            }
       
           
        },{
            dataIndex: 'totalamountindex',
            hidden: false,
            header: "<span style=font-weight:bold;>Total Amount (LKR)</span>",
            
            width: 400,
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




function viewFunction(){
var selectedRow = grid.getSelectionModel().getSelected();

cvsCustId = selectedRow.get('customerIDindex');
   myWin1 = new Ext.Window({
    title: 'Denomination Details',
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: false,maximizable: false,
        	buttonAlign: "center",
        	width:1000,
        	height: screen.height-280,
        	id: 'dispenseId2',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
            scripts: true,
            shim: false,
        html: "<iframe id = 'xyz' style = 'width:100%;height:100%'; src='<%=request.getContextPath()%>/Jsps/CashVanManagement/DenominationSummary.jsp?CVSCustId="+cvsCustId+"'></iframe>"
       	});
       	myWin1.show();

		
		
}


    grid = getGridArmory('', 'No Records Found', store, screen.width - 40, 440, 12, filters, '', false,'', 12, false, '', false, '', true, 'View Ledger', false, 'Excel', jspName, exportDataType, false, 'Pdf');

function getGridArmory(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, ViewLedger, ViewledgerStr , excel, excelstr, jspName, exportDataType, pdf, pdfstr) {
    var grid = new Ext.grid.GridPanel({
        title: gridtitle,
        border: false,
        height: getGridHeight(),
        autoScroll: true,
        store: store,
        id: 'grid',
        colModel: createColModel(gridnoofcols),
        loadMask: true,
        view: new Ext.grid.GroupingView({
            autoFill: true,
            groupTextTpl: getGroupConfig(),
            emptyText: emptytext,
            deferEmptyText: false
        }),
        listeners: {
            render: function(grid) {
                grid.store.on('load', function(store, records, options) {
                    grid.getSelectionModel().selectFirstRow();
                });
         
            }
        },

        selModel: new Ext.grid.RowSelectionModel(),
     
        plugins: filters,
        bbar: new Ext.Toolbar({})
    });
    if (width > 0) {
        grid.setSize(width, height);
    }
    grid.getBottomToolbar().add([
        '->', {
            text: filterstr,
            iconCls: 'clearfilterbutton',
            handler: function() {
                grid.filters.clearFilters();
            }
        }
    ]);
    if (reconfigure) {
        grid.getBottomToolbar().add([
            '-', {
                text: reconfigurestr,
                handler: function() {
                    grid.reconfigure(store, createColModel(reconfigurenoofcols));
                }
            }
        ]);
    }
    if (group) {
        grid.getBottomToolbar().add([
            '-', {
                text: groupstr,
                handler: function() {
                    store.clearGrouping();
                }
            }
        ]);
    }

    if (chart) {
        grid.getBottomToolbar().add([
            '-', {
                text: chartstr,
                handler: function() {
                    columnchart();
                }
            }
        ]);
    }
    if (ViewLedger) {
        grid.getBottomToolbar().add([
            '-', {
                text: ViewledgerStr,
                // iconCls : 'closebutton'
                handler: function() {
                   viewFunction();
                }
            }
        ]);
    }
    


    if (excel) {
        grid.getBottomToolbar().add([
            '-', {
                text: '',
                iconCls: 'excelbutton',
                handler: function() {
                    getordreport('xls', 'All', jspName, grid, exportDataType);
                }
            }
        ]);
    }
    if (pdf) {
        grid.getBottomToolbar().add([
            '-', {
                text: '',
                iconCls: 'pdfbutton',
                handler: function() {
                    getordreport('pdf', 'All', jspName, grid, exportDataType);

                }
            }
        ]);
    }



    return grid;
}

	var headerStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getVaultInventorySummary',
	    id: 'getVaultInventorySummaryStoreId',
	    root: 'getVaultInventorySummaryRoot',
	    autoLoad: false,
	    fields: ['AvailableBalance','LedgerAmount','SealedBagAmount','TotalAmount','ChequeAmount','JewelleryAmount','ForeignCurrencyAmount']
	});

 var clientPanel234 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId1234',
        layout: 'table',
        frame: false,
        border: false,
        width:screen.width-22,
        height:10
    });
var clientPanel2 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId2',
        layout: 'table',
        frame: false,
        border: false,
        width:screen.width-22,
        height:30,
        layoutConfig: {
            columns: 12
        },
        items: [ {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'AvailableAmountLabelId',
                text: 'Available Balance' + ' :'
            }, {
              
                 xtype: 'label',
                cls: 'labelstyle',
                //width: 185,
                emptyText: 'Available Amount',
                allowBlank: false,
                blankText: 'Available Amount',
                id: 'AvailableAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true,
                maskRe: /[a-zA-Z0-9]/i

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId1',
                text: 'LKR' 
                }, 
              { 
              
                width:80,
                border :false
                },  
           {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'LedgerAmountLabelId',
                text: 'Ledger Amount' + ' :'
            }, {
              
                 xtype: 'label',
                cls: 'labelstyle',
                //width: 185,
                emptyText: 'Ledger Amount',
                allowBlank: false,
                blankText: 'Ledger Amount',
                id: 'LedgerAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true,
                maskRe: /[a-zA-Z0-9]/i

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId167',
                text: 'LKR' 
                },
                {width:80,
                border :false},  
           {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'SealedBagAmountLabelId',
                text: 'Sealed Bag Amount' + ' :'
            }, {
              
                xtype: 'label',
                cls: 'labelstyle',
                //width: 185,
                emptyText: 'Sealed Bag Amount',
                allowBlank: false,
                blankText: 'Sealed Bag Amount',
                id: 'SealedBagAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true,
                maskRe: /[a-zA-Z0-9]/i

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId3',
                text: 'LKR' 
                },  
                { width:80,
                border :false}
        ]
    });
    
    
    
    var clientPanel25 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId25',
        layout: 'table',
        frame: false,
        border: false,
        width:screen.width-22,
        height:30,
        layoutConfig: {
            columns: 16
        },
        items: [ {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'ChequeAmountLabel',
                text: 'Cheque Amount' + ' :'
            }, {
              
                 xtype: 'label',
                cls: 'labelstyle',
                //width: 185,
                emptyText: 'Cheque Amount',
                allowBlank: false,
                blankText: 'Cheque Amount',
                id: 'ChequeAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId155',
                text: 'LKR' 
                }, 
              { 
              
                width:80,
                border :false
                },  
           {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'JewelleryLabelId',
                text: 'Jewellery Amount' + ' :'
            }, {
              
                 xtype: 'label',
                cls: 'labelstyle',
                //width: 185,
                emptyText: 'Jewellery Amount',
                allowBlank: false,
                blankText: 'Jewellery Amount',
                id: 'JewelleryAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId16755',
                text: 'LKR' 
                },
                {width:80,
                border :false},  
           {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'ForeignCurrencyLabelId',
                text: 'Foreign Currency Amount' + ' :'
            }, {
              
                xtype: 'label',
                cls: 'labelstyle',
                //width: 185,
                emptyText: 'Foreign Currency Amount',
                allowBlank: false,
                blankText: 'Foreign Currency Amount',
                id: 'ForeignCurrencyAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId3455',
                text: 'LKR' 
                },  
                { width:80,
                border :false},     
          {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TotalAmountLabelId',
                text: 'Total Amount' + ' :'
            }, {
              
                 xtype: 'label',
                cls: 'labelstyle',
                width: 185,
                emptyText: 'Total Amount',
                allowBlank: false,
                blankText: 'Total Amount',
                id: 'EnterTotalAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                readOnly:true,
                maskRe: /[0-9 ]/i

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId4',
                text: 'LKR' 
                },
                 { width:80,
                border :false}
        ]
    });
 
    
 
 Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
       // title: 'Vault Operations',
        renderTo: 'content',
        id: 'outerPanel',
        standardView: true,
        autoScroll: false,
        frame: false,
        border: false,
        width:screen.width-22,
        height:750,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel234,clientPanel2,clientPanel25,grid]
    });
    headerStore.load({
    params:{
    custId:<%=customerId%>
    },
    callback: function(){
    
    var rec = headerStore.getAt(0);
				Ext.getCmp('AvailableAmountId').setText(rec.data['AvailableBalance']);
				Ext.getCmp('LedgerAmountId').setText(rec.data['LedgerAmount']);
				Ext.getCmp('SealedBagAmountId').setText(rec.data['SealedBagAmount']);
				Ext.getCmp('EnterTotalAmountId').setText(rec.data['TotalAmount']);
				Ext.getCmp('ChequeAmountId').setText(rec.data['ChequeAmount']);
                Ext.getCmp('JewelleryAmountId').setText(rec.data['JewelleryAmount']);
                Ext.getCmp('ForeignCurrencyAmountId').setText(rec.data['ForeignCurrencyAmount']);
				
    }
    });
    store.load({
    params:{
    },
callback: function(){

            var selectedRow = grid.getSelectionModel().getSelected();
            cvsCustId = selectedRow.get('customerIDindex');
            }
});
 
});
 

   </script>
	</body>
</html>

