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
tobeConverted.add("Route_Master");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Route_Id");
tobeConverted.add("Route_Name");
tobeConverted.add("Route_Type");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Route_Master_Information");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("Enter_Route_ID");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Enter_Route_Type");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
//tobeConverted.add("This_Route_is_Already_Exists_Please_Select_Different_One");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String RouteMaster=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String RouteMasterDetails=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String RouteID=convertedWords.get(10);
String RouteName=convertedWords.get(11);
String RouteType=convertedWords.get(12);
String Excel=convertedWords.get(13);
String Delete=convertedWords.get(14);
String AddRouteMaster=convertedWords.get(15);
String NoRowsSelected=convertedWords.get(16);
String SelectSingleRow=convertedWords.get(17);
String ModifyDetails=convertedWords.get(18);
String AssociateRoute=convertedWords.get(19);
String SelectRouteID=convertedWords.get(20);
String SelectRouteName=convertedWords.get(21);
String SelectRouteType=convertedWords.get(22);
String Save=convertedWords.get(23);
String Cancel=convertedWords.get(24);
//String RouteisAlreadyExistsPleaseSelectDifferentOne=convertedWords.get(25);

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Armory Inventory</title>		
   
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
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	label {
		display : inline !important;
	}
	.x-layer ul {
		 min-height: 27px !important;
	}
	.x-window-tl *.x-window-header {
		padding-top : 6px !important;
	}
	 .x-panel-body-noheader .x-form {
		height : 424px !important;
	}
   </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "routeVehicleAssociationDetails";
var exportDataType = "int,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var titelForInnerPanel1;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;
var sm1 = new Ext.grid.CheckboxSelectionModel({});
var isactive = 1;
var spareNames = "";
var myWin1 ;
var systemId = <%=systemId%>


var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if (<%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('custcomboId').getValue();
                CustName = Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        custName: CustName,
                        jspName: jspName
                    }
                });
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
                CustName = Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        custName: CustName,
                        jspName: jspName
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
            cls: 'labelstyle',
            style:'vertical-align: -webkit-baseline-middle'
        },
        Client

    ]
});

var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', 'Active'],
        ['Inactive', 'Inactive']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Status',
    blankText: 'Select Status',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});




var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'inventories',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'assetNo'
    }, {
        name: 'assetName'
    }, {
        name: 'qrCode'
    }, {
        name: 'status'
    }, {
        name: 'date'
    }, {
        name: 'vendorName'
    }, {
        name: 'branchName'

    }, {
        name: 'reason'
    }, {
        name: 'isActive'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ArmoryAction.do?param=getArmoryInventory',
        method: 'POST'
    }),
    storeId: 'inventories',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'int',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'assetNo'
    }, {
        type: 'string',
        dataIndex: 'assetName'
    }, {
        type: 'string',
        dataIndex: 'qrCode'
    }, {
        type: 'string',
        dataIndex: 'status'
    }, {
        type: 'date',
        dataIndex: 'date',
    }, {
        type: 'string',
        dataIndex: 'vendorName'
    }, {

        type: 'string',
        dataIndex: 'branchName'
    }, {

        type: 'string',
        dataIndex: 'reason'
    }, {

        type: 'boolean',
        dataIndex: 'isActive'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 200,

            filter: {
                type: 'int'
            }
        },
        sm1, {
            header: "<span style=font-weight:bold;>Asset Number</span>",
            dataIndex: 'assetNo',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Asset Name</span>",
            dataIndex: 'assetName',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>QR Code</span>",
            dataIndex: 'qrCode',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'status',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'date',
            width: 50,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Vendor Name</span>",
            dataIndex: 'vendorName',
            width: 50,
            filter: {
                type: 'string'
            }
        },

        {
            header: "<span style=font-weight:bold;>Branch Name</span>",
            dataIndex: 'branchName',
            width: 50,
            filter: {
                type: 'string'
            }
        },

        {
            header: "<span style=font-weight:bold;>Reason</span>",
            dataIndex: 'reason',
            width: 50,
            filter: {
                type: 'string'
            }
        },

        {
            header: "<span style=font-weight:bold;>Is Active</span>",
            dataIndex: 'isActive',
            width: 50,
            filter: {
                type: 'boolean'
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


function ajaxfunction() {
    if (spareNames != '') {
        Ext.Ajax.request({
            url: '<%=request.getContextPath()%>/ArmoryAction.do?param=saveStatusOfArmory',
            method: 'POST',
            params: {
                CustId: Ext.getCmp('custcomboId').getValue(),
                Status: isactive,
                JsonData: spareNames

            },
            success: function(response, options) {
             myWin.hide();
                var message = response.responseText;

                Ext.example.msg(message);
                store.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                         custName: CustName,
                        jspName: jspName
                        }
                        });
                spareNames = ''
            },
            failure: function() {
             myWin.hide();
                Ext.example.msg("Error");
               store.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                         custName: CustName,
                        jspName: jspName
                        }
                        });
                spareNames = ''
            }
        });
    } 
}



function updateStatus() {
    myWin.show();
}

function addNewAsset() {
    myWin1.show();
}

var innerPanelForCustomerMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 160,
    width: 400,
    frame: false,
    id: 'innerPanelForCustomerMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Select Any One Option',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'NewRecordId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '',
                //cls: 'mandatoryfield',
                id: 'id1'
            }, {
                xtype: 'radio',
                id: 'radio1',
                text: '',
                width: 20, 
                checked: true,
                name: 'option',
                value: 'active',

                listeners: {
                    check: function() {
                        if (this.checked) {
                            isactive =1;
                            
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'Active',
              style:'vertical-align: -webkit-baseline-middle',
             //  style:' display: table-cell;vertical-align: middle;',
                cls: 'labelstyle',
                id: 'companyNameLabelId'
            }, {}, {
                xtype: 'label',
                text: '',
                //cls: 'mandatoryfield',
                id: 'id2'
            }, {
                xtype: 'radio',
                id: 'radio2',
                text: '',
                width: 20,
                checked: false,
                name: 'option',
                value: 'inactive',

                listeners: {
                    check: function() {
                        if (this.checked) {
                            isactive = 0;

                        }
                    }
                }

            }, {
                xtype: 'label',
                text: 'InActive',
                style:'vertical-align: -webkit-baseline-middle',
                cls: 'labelstyle',
                id: 'companyNameLabelId2'
            }, {}

        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 400,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {



                    spareNames = "";
                    var records = grid.getSelectionModel().getSelections();
                    for (var i = 0, len = records.length; i < len; i++) {
                        var store = records[i];
                        var spareId = store.get('assetNo');
                        spareNames = spareNames +"'"+spareId+"'"+ ",";
                    }

                    ajaxfunction();

                }


            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myWin.hide();

                }
            }
        }
    }]
});



var innerPanel2 = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: false,
    height: 400,
    width: 500,
    frame: false,
    id: 'addmap',
    items: [{
        html: "<iframe id = 'xyz' style = 'height:500px;width:490px'; src='<%=request.getContextPath()%>/Jsps/CashVanManagement/InwardArmory.jsp'></iframe>"

    }]

});


var RadioPanelWindow = new Ext.Panel({
    width: 410,
    height: 200,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForCustomerMasterDetails, innerWinButtonPanel]
});
var AddPanelWindow = new Ext.Panel({
    width: 700,
    height: 490,
    standardSubmit: true,
    frame: false,
    items: [innerPanel2]
});
myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false, 
    modal: true,
    autoScroll: false,
    height: 250,
    width: 430,
    id: 'myWin',
    items: [RadioPanelWindow]
});


myWin1 = new Ext.Window({
    title: titelForInnerPanel1,
    closable: false,
    title:'Add Inward Armory', 
    resizable: false,
    modal: true,
    autoScroll: false,
    height:500,
    width: 540,
    id: 'myWin1',
    items: [AddPanelWindow]
});



grid = getGridArmory('Armory Inventory Details', 'No Records Found', store, screen.width - 40, 460, 12, filters, '', false, '', 12, false, '', false, '', true, 'Add', true, 'Active/Inactive', true, 'Excel', jspName, exportDataType, true, 'Pdf',true,'Generate QR COde');

function getGridArmory(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, Add, addStr, activeInActive, activeStr, excel, excelstr, jspName, exportDataType, pdf, pdfstr,qrcode,qrcodegeneration) {
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
        sm: sm1,
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
    if (Add) {
        grid.getBottomToolbar().add([
            '-', {
                text: addStr,
                // iconCls : 'closebutton',
                handler: function() {
                    addNewAsset();
                }
            }
        ]);
    }
    if (activeInActive) {
        grid.getBottomToolbar().add([
            '-', {
                text: activeStr,
                // iconCls : 'closebutton',
                handler: function() {
                    updateStatus();
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

 if (qrcode) {
        grid.getBottomToolbar().add([
            '-', {
                text: qrcodegeneration,
                handler: function() {
                   qrcodegeneartion ();

                }
            }
        ]);
    }

    return grid;
}

function qrcodegeneartion (){
var custIdForPdf  = Ext.getCmp('custcomboId').getValue();
selectedassets = "";
                    var records = grid.getSelectionModel().getSelections();
                    for (var i = 0, len = records.length; i < len; i++) {
                        var store = records[i];
                        var assetNos = store.get('assetNo');
                        selectedassets = "'"+assetNos+"'"+ ","+selectedassets;
                    }
                    if (selectedassets != '') {
                    
                       window.open('<%=request.getContextPath()%>/generateQRCodePdfReport?selectedassets=' + selectedassets + '&clientId=' + custIdForPdf + '&systemId=' + systemId + '');
 
    } 
                 
}

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Armory Inventory',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 20,
        height: 550,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    store.load();
    sb = Ext.getCmp('form-statusbar');
});


$(".clearfilterbutton").hide();
</script>

 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->