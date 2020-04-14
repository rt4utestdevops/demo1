<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int countryId = loginInfo.getCountryCode();
    CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}


ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Status");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Save");
tobeConverted.add("Customer_Name");
tobeConverted.add("Cancel");
tobeConverted.add("Add");
tobeConverted.add("Delete");
tobeConverted.add("Modify");
tobeConverted.add("Modify_Details");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Status=convertedWords.get(0);
String SelectCustomerName=convertedWords.get(1);
String Save=convertedWords.get(2);
String Customer_Name = convertedWords.get(3);
String Cancel = convertedWords.get(4);
String Add = convertedWords.get(5);
String Delete = convertedWords.get(6);
String Modify = convertedWords.get(7);
String ModifyDetails = convertedWords.get(8); 
String SLNO = convertedWords.get(9);
String NoRecordsFound = convertedWords.get(10);
String ClearFilterData = convertedWords.get(11);
String Excel = convertedWords.get(12);

%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Quotation_History</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
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
var systemId = '<%=systemId%>';
var custId = '<%=customerId%>';
var outerPanel;
var ctsb;
var jspName = 'Quotation_History';
var exportDataType = "int,int,string,string,string,string,string,string,string,string,string,numeric,int";
var selected;
var selected;
var grid;
var buttonValue;
var titelForInnerPanel = "Add New Customer Details";
var myWin;
var selectedName = null;
var selectedType = null;
var coutryId = '<%=countryId%>';


function  refreshRecord(){
   store.load({
    params: {
    CustId: custId,
   jspName : jspName
   }
   });

}

function viewAttachmentFunction() {
   var selectedRow = grid.getSelectionModel().getSelected();

  var systemQuotationId2 = selectedRow.get('QuotationIdDataIndex');
  var quotationName2 = selectedRow.get('QuotationNoDataIndex');


   window.open('<%=request.getContextPath()%>/QuotationMasterExcel?systemQuotationId=' + systemQuotationId2 + '&clientId=' + custId + '&systemId=' + systemId + '');


  }

  function viewRevisionFunction() {

   if (grid.getSelectionModel().getCount() == 0) {
    Ext.example.msg("No Rows Selected");
    return;
   }
   if (grid.getSelectionModel().getCount() > 1) {
    Ext.example.msg("Select Single Row");
    return;
   }

   var selected = grid.getSelectionModel().getSelected();

   var quotationIdForRevision = selected.get('QuotationIdDataIndex');
   var quotationNameForRevision = selected.get('QuotationNoDataIndex');
   var revisionCount = selected.get('RevisionCountDataIndex');
   if (revisionCount == 0) {
    Ext.example.msg("This Quotation Hasn't Revised!!");
    return;

   }
   if (revisionCount != 0) {
    var title = "Quotation -" + quotationNameForRevision + " (" + quotationIdForRevision + ")";
    quotationMasterPopupAdd2.setTitle(title);
    revisionWindow.show();

    store2.load({
     params: {
      CustId: custId,
      QuotationId: quotationIdForRevision
     }
    });
   }
  }


  var reader2 = new Ext.data.JsonReader({
   idProperty: 'ownMasterid2',
   root: 'quotationRevisionMasterRoot',
   totalProperty: 'total',

   fields: [{
     name: 'slnoIndex2'
    }, {
     name: 'validFromDataIndex2'
    }, {
     name: 'validToIndex2'
    },{
        name: 'QuotationStatusDataIndex2'
    },{
        name: 'StatusTypeDataIndex2'
    },{
     name: 'locationIndex2'
    }, {
     name: 'quotForIndex2'
    }, {
     name: 'typeIndex2'
    }, {
     name: 'tariffTypeIndex2'
    }, {
     name: 'tariffAmountIndex2'
    }
, {
     name: 'reasonDataIndex'
    }
   ]
  });

  var store2 = new Ext.data.GroupingStore({
   autoLoad: false,
   proxy: new Ext.data.HttpProxy({
    url: '<%=request.getContextPath()%>/quoteFor.do?param=getRevisionData',
    method: 'POST'
   }),
   storeId: 'revisionStoreId',
   reader: reader2
  });


  var createColModel2 = new Ext.grid.ColumnModel({
   columns: [
    new Ext.grid.RowNumberer({
     header: "<span style=font-weight:bold;>SLNO</span>",
     width: 50
    }), {
     dataIndex: 'slnoIndex2',
     hidden: true,
     header: "<span style=font-weight:bold;>SLNO</span>",
     filter: {
      type: 'numeric'
     }
    }, {
     header: "<span style=font-weight:bold;>Valid From</span>",
     dataIndex: 'validFromDataIndex2',
     width: 130,
     filter: {
      type: 'date'
     }
    }, {
     header: "<span style=font-weight:bold;>Valid To</span>",
     dataIndex: 'validToIndex2',
     width: 130,
     filter: {
      type: 'date'
     }
    }, {
            header: "<span style=font-weight:bold;>Quotation Status</span>",
            dataIndex: 'QuotationStatusDataIndex2',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status Type</span>",
            dataIndex: 'StatusTypeDataIndex2',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
     header: "<span style=font-weight:bold;>location</span>",
     dataIndex: 'locationIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Quote For</span>",
     dataIndex: 'quotForIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Type</span>",
     dataIndex: 'typeIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Tariff Type</span>",
     dataIndex: 'tariffTypeIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Tariff Amount</span>",
     dataIndex: 'tariffAmountIndex2',
     width: 130,
     filter: {
      type: 'numeric'
     }
    },{
            header: "<span style=font-weight:bold;>Reason</span>",
            dataIndex: 'reasonDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        }

   ]
  });

  var grid2 = new Ext.grid.GridPanel({
   title: "",
  height: 300,
   width: 1000,
   store: store2,
   colModel: createColModel2,
   viewConfig: {
    forceFit: true
   },

   view: new Ext.grid.GridView({
    loadMask: true,
    emptyText: 'No Records Found'
   }),

  });


  var innerWinButtonPanel3 = new Ext.Panel({
   id: 'innerWinButtonPanelId23',
   standardSubmit: true,
   collapsible: false,
   autoHeight: true,

   width: 980,
   frame: false,
   frame: false,
   layout: 'table',
   layoutConfig: {
    columns: 4
   },
   buttons: [{
    xtype: 'button',
    text: 'Close',
    id: 'CloseButtId2',
    cls: 'buttonstyle',
    iconCls: 'cancelbutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
       revisionWindow.hide();
      }
     }
    }
   }]
  });

  var quotationMasterPopupAdd2 = new Ext.Panel({
   title: 'Quotation Details',
   width: 1000,
   autoHeight: true,
   standardSubmit: true,
   frame: true,
   items: [grid2, innerWinButtonPanel3]
  });

 revisionWindow = new Ext.Window({
   title: 'Quotation Revision Details',
   closable: false,
   resizable: false,
   modal: true,
   autoScroll: false,
   autoHeight: true,
   width: 1010,
   id: 'revisionWindow',
   items: [quotationMasterPopupAdd2]
  });


var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'customerMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'QuotationIdDataIndex'
    },{
        name: 'QuotationNoDataIndex'
    },{
        name: 'QuotationStatusDataIndex'
    },{
        name: 'StatusTypeDataIndex'
    },{
        name: 'ValidFromDataIndex'
    },{
        name: 'ValidToDataIndex'
    },{
        name: 'LocationDataIndex'
    },{
        name: 'QuotationForDataIndex'
    },{
        name: 'QuotationTypeDataIndex'
    },{
        name: 'TarrifTypeDataIndex'
    },{
        name: 'TarrifAmountDataIndex'
    },{
        name: 'RevisionCountDataIndex'
    },{
        name: 'reasonDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/QuotationMasterHistoryAction.do?param=getQuoTationHistoryDetails',
        method: 'POST'
    }),
    storeId: 'customerMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
        type: 'numeric',
        dataIndex: 'QuotationIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'QuotationNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'QuotationStatusDataIndex'
    },{
        type: 'string',
        dataIndex: 'StatusTypeDataIndex'
    },{
        type: 'date',
        dataIndex: 'ValidFromDataIndex'
    },{
        type: 'date',
        dataIndex: 'ValidToDataIndex'
    },{
        type: 'string',
        dataIndex: 'LocationDataIndex'
    },{
        type: 'string',
        dataIndex: 'QuotationForDataIndex'
    },{
        type: 'string',
        dataIndex: 'QuotationTypeDataIndex'
    },{
        type: 'string',
        dataIndex: 'TarrifTypeDataIndex'
    },{
        type: 'string',
        dataIndex: 'TarrifAmountDataIndex'
    },{
        type: 'string',
        dataIndex: 'RevisionCountDataIndex'
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
        }, {
            header: "<span style=font-weight:bold;>System Quotation No</span>",
            dataIndex: 'QuotationIdDataIndex',          
            width: 130,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Quotation No</span>",
            dataIndex: 'QuotationNoDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Quotation Status</span>",
            dataIndex: 'QuotationStatusDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status Type</span>",
            dataIndex: 'StatusTypeDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Valid From</span>",
            dataIndex: 'ValidFromDataIndex',
            width: 130,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Valid To</span>",
            dataIndex: 'ValidToDataIndex',
            width: 130,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Location</span>",
            dataIndex: 'LocationDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Quotation For</span>",
            dataIndex: 'QuotationForDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Quotation Type</span>",
            dataIndex: 'QuotationTypeDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Tarrif Type</span>",
            dataIndex: 'TarrifTypeDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Tarrif Amount</span>",
            dataIndex: 'TarrifAmountDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Revision Count</span>",
            dataIndex: 'RevisionCountDataIndex',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Reason</span>",
            dataIndex: 'reasonDataIndex',
            width: 130,
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
function viewFuelPercentage(){
}
 var grid = getCashVanGrid('', 'No Record Found', store, screen.width - 40, 510, 15, true, 'Refresh', filters, 'Clear Filter Data', false, '', 16, false, '', false, '', false, '', false, '', false, '', false, '', false, '', false, '', false, '', false, '', true, 'View Revision',true,'View Attacment', true,'Excel',jspName,exportDataType, true, 'PDF');

Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          renderTo: 'content',
          standardSubmit: true,
          frame: false,
          width: screen.width - 22,
          height: 520,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
        items: [grid]
    });
     store.load({
    params: {
    CustId: custId,
   jspName : jspName
   }
   });
    sb = Ext.getCmp('form-statusbar');
});</script>
</body>
</html>
