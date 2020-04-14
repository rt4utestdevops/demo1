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

tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer");

tobeConverted.add("Part_Name");
tobeConverted.add("Part_Number");
tobeConverted.add("Part_Category");
tobeConverted.add("UOM");
tobeConverted.add("Quantity_Requested");
tobeConverted.add("Current_QIH");
tobeConverted.add("Requisition_SlipNo");
tobeConverted.add("Item_Type");
tobeConverted.add("Requested_By");
tobeConverted.add("Requested_Date");
tobeConverted.add("Parts_Pending_Details");
tobeConverted.add("Branch_Name");
tobeConverted.add("Select_Branch");
tobeConverted.add("Manufacturer");
tobeConverted.add("SLNO");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String CustomerName=convertedWords.get(0);
String SelectCustomer=convertedWords.get(1);

String PartName=convertedWords.get(2);
String PartNumber=convertedWords.get(3);
String PartCategory=convertedWords.get(4);

String UOM=convertedWords.get(5);
String QuantityRequested=convertedWords.get(6);
String CurrentQIH=convertedWords.get(7);
String RequisitionSlipNo=convertedWords.get(8);
String ItemType=convertedWords.get(9);

String RequestedBy=convertedWords.get(10);
String RequestedDate=convertedWords.get(11);

String PartsPendingDetails=convertedWords.get(12);
String BranchName=convertedWords.get(13);
String SelectBranch=convertedWords.get(14);
String Manufacturer=convertedWords.get(15);
String SLNO=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String NoRecordsFound=convertedWords.get(18);

%>

<jsp:include page="../Common/header.jsp" />
 		<title>Parts Pending Report</title>	
 		  
   
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
<style>
		label {
				display : inline !important;
		}
		.x-panel-header
		{
				height: 7% !important;
		}
		
		.x-form-label-left label {
			text-align: left;
			margin-top: 4px !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-menu-list {
				height:auto !important;
			}
	</style>
   <script>
var outerPanel;
var exportDataType="int,string,string,string,string,string,string,string,string,string,string,string,date";
var jspName = "Parts_Pending_For_Approval";
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var ESR;
var setLocation="false";

var clientcombostore = new Ext.data.JsonStore({
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
            }
             branchStore.load({
                    params: {
                         custId : Ext.getCmp('custcomboId').getValue()
                    }
                });
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomer%>',
    blankText: '<%=SelectCustomer%>',
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
                //custId = Ext.getCmp('custcomboId').getValue();
                branchStore.load({
                    params: {
                         custId : Ext.getCmp('custcomboId').getValue()
                    }
                });
            }
        }
    }
});
var branchStore = new Ext.data.JsonStore({
  url:'<%=request.getContextPath()%>/FleetMaintanceAction.do?param=getBranch',
  id:'BranchStoreId',
  root: 'BranchStoreRoot',
  autoLoad: false,
  remoteSort: true,
  fields: ['BranchId','BranchName'],
    listeners: {
        load: function() {
        }
    }
});

var branch = new Ext.form.ComboBox({
    store: branchStore,
    id: 'branchcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectBranch%>',
    blankText: '<%=SelectBranch%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'BranchId',
    displayField: 'BranchName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                   params: {
                        CustId: custId,
                        branch:Ext.getCmp('branchcomboId').getValue(),
                        jspName:jspName,
                        custName:Ext.getCmp('custcomboId').getRawValue()
                    }
                });
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
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client,{width:70},{
            xtype: 'label',
            text: '<%=BranchName%>' + ' :',
            cls: 'labelstyle'
        },
        branch
    ]
});


var reader = new Ext.data.JsonReader({
    idProperty: 'datarootid',
    root: 'PartsPendingApprovalRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'SlipNoDataIndex'
    },{
        name: 'itemTypeDataIndex'
    }, {
        name: 'partNameDataIndex'
    },{
        name: 'partNumberDataIndex'
    }, {
        name: 'partCategoryDataIndex'
    }, {
        name: 'manufacturerDataIndex'
    }, {
        name: 'UOMDataIndex'
    }, {
        name: 'quantityDataIndex'
    }, {
        name: 'QTHDataIndex'
    }, {
        name: 'branchNameDataIndex'
    }, {
        name: 'requestedByDataIndex'
    }, {
        name: 'requestedDateDataIndex'
    }]
});


var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
    url:'<%=request.getContextPath()%>/FleetMaintanceAction.do?param=getData',
    method: 'POST'
    }),
    storeId: 'PendingApprovalId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'SlipNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'itemTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'partNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'partNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'partCategoryDataIndex'
    }, {
        type: 'string',
        dataIndex: 'manufacturerDataIndex'
    }, {
        type: 'string',
        dataIndex: 'UOMDataIndex'
    }, {
        type: 'string',
        dataIndex: 'quantityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'QTHDataIndex'
    }, {
        type: 'string',
        dataIndex: 'branchNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'requestedByDataIndex'
    }, {
        type: 'date',
        dataIndex: 'requestedDateDataIndex'
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
            header: "<span style=font-weight:bold;><%=RequisitionSlipNo%></span>",
            dataIndex: 'SlipNoDataIndex',
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ItemType%></span>",
            dataIndex: 'itemTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'partNameDataIndex',
            header: "<span style=font-weight:bold;><%=PartName%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'partNumberDataIndex',
            header: "<span style=font-weight:bold;><%=PartNumber%></span>",
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PartCategory%></span>",
            dataIndex: 'partCategoryDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Manufacturer%></span>",
            dataIndex: 'manufacturerDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=UOM%>(unit of measure)</span>",
            dataIndex: 'UOMDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=QuantityRequested%></span>",
            dataIndex: 'quantityDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CurrentQIH%>(Quantity In Hand)</span>",
            dataIndex: 'QTHDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=BranchName%></span>",
            dataIndex: 'branchNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RequestedBy%></span>",
            dataIndex: 'requestedByDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RequestedDate%></span>",
            dataIndex: 'requestedDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            width: 100,
            filter: {
                type: 'date'
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

//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=PartsPendingDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 28, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, '', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

