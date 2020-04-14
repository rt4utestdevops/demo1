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



int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Processing Fee Master</title>		
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
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName =" Processing Fee Master";
var exportDataType = "";
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;

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
                store.load({
                    params: {
                        CustId: custId
                    }
                });
            }
        }
    }
});

<!--var permittypeStore = new Ext.data.JsonStore({-->
<!--       id: 'permitTypeId',-->
<!--       root: 'permitTypeRoot',-->
<!--   	   autoLoad: false,-->
<!--   	   remoteSort: true,-->
<!--       fields: ['Name'],-->
<!--       autoLoad: false,-->
<!--       proxy: new Ext.data.HttpProxy({-->
<!--     	url: '<%=request.getContextPath()%>/ProcessingFeeMaster.do?param=getPermitType',-->
<!--       	method: 'POST'-->
<!--   	})-->
<!--   });-->
   
    var permittypeStore = new Ext.data.SimpleStore({
        id: 'permitTypeId',
        fields: ['Name', 'Value'],
        autoLoad: true,
        data: [
           ['ROM Transit', 'Rom Transit'],
           ['ROM Sale', 'Rom Sale'],
           ['Purchased ROM Sale Transit Permit', 'Purchased Rom Sale Transit Permit'],
           ['Processed Ore Transit', 'Processed Ore Transit'],
           ['Processed Ore Sale', 'Processed Ore Sale'],
           ['Processed Ore Sale Transit', 'Processed Ore Sale Transit'],
           ['Domestic Export', 'Domestic Export'],
           ['International Export', 'International Export'],
           ['Import Permit', 'Import Permit'],
           ['Import Transit Permit', 'Import Transit Permit'],
           ['Bauxite Transit', 'Bauxite Transit']
        ]
    });
var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Customer Name',
    blankText: 'Select Customer Name',
    selectOnFocus: true,
    allowBlank: false,
    resizable: true,
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
                store.load({
                    params: {
                        CustId: custId
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
            text: 'CustomerName' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});

    //******************************store for Mineral**********************************
    var mineralStore = new Ext.data.SimpleStore({
        id: 'mineralsComboStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Iron Ore', 'Iron Ore'],
            ['Bauxite/Laterite', 'Bauxite/Laterite'],
            ['Manganese', 'Manganese'],
            ['Iron Ore(E-Auction)', 'Iron Ore(E-Auction)']
        ]
    });
    //****************************combo for Mineral****************************************
    var mineralCombo = new Ext.form.ComboBox({
        store: mineralStore,
        id: 'mineralcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Mineral Type',
        //readOnly: true,
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfectnew',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
var permitTypeCombo = new Ext.form.ComboBox({
    store: permittypeStore,
    id: 'permitTypeId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Permit Type',
    blankText: 'Select Permit Type',
    //readOnly: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Name',
    displayField: 'Name',
	cls:'selectstylePerfectnew'
    });
var innerPanelForProcessingFeeMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 450,
    frame: false,
    id: 'innerPanelForProcessingFeeMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title:'Processing Fee Details',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 3,
        id: 'pfInfoId',
        width: 445,
        height:140,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'MandatoryPtId'
        },{
            xtype: 'label',
            text: 'Permit Type' + ' :',
            cls: 'labelstylenew',
            id: 'permitTypeLabelId'
        }, permitTypeCombo,{},
          {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'MandatorymtId'
        },{
            xtype: 'label',
            text: 'Mineral Type' + ' :',
            cls: 'labelstylenew',
            id: 'mineralTypeLabelId'
        }, mineralCombo,{},
             {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'manPfId'
        },{
            xtype: 'label',
            text: 'Processing Fee' + ' :',
            cls: 'labelstylenew',
            id: 'pfLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'processingFeeId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Select Processing Fee',
            blankText: 'Select  Processing Fee',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
            autoCreate: {
               tag: "input",
               maxlength: 9,
               autocomplete: "off"
            }
           
    },{}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 445,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   
                    if (Ext.getCmp('permitTypeId').getValue() == "") {
                    	Ext.example.msg("Select Permit Type");
                    	Ext.getCmp('permitTypeId').focus();
                        return;
                    }
                    var pattern = /^[0-9][0-9\s]*/;
                      if (!pattern.test(Ext.getCmp('processingFeeId').getValue())) {
                          Ext.example.msg("Enter Processing Fee");
                          Ext.getCmp('processingFeeId').focus();
                          return;
                      }
                    var id;
                    if(buttonValue=='Modify'){
                     	var selected = grid.getSelectionModel().getSelected();
                    	id=selected.get('uniqueIdIndex');
                    }
                        routeMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ProcessingFeeMaster.do?param=AddorModifyProcessingFeeDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                permitType: Ext.getCmp('permitTypeId').getValue(),
                                processingFee: Ext.getCmp('processingFeeId').getValue(),
                                id:id,
                                mineralType: Ext.getCmp('mineralcomboId').getValue(),
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
							    Ext.getCmp('permitTypeId').reset();
							    Ext.getCmp('processingFeeId').reset();
							    Ext.getCmp('mineralcomboId').reset();
                                myWin.hide();
                                store.reload();
                             routeMasterOuterPanelWindow.getEl().unmask();
                         },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                Ext.getCmp('permitTypeId').reset();
							    Ext.getCmp('processingFeeId').reset();
							    Ext.getCmp('mineralcomboId').reset();
                            }
                        });
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
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

   

var routeMasterOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 210,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForProcessingFeeMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title:"Processing Fee Details",
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 260,
    width: 475,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});
function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("SelectCustomerName");
        return;
    }
    Ext.getCmp('permitTypeId').enable();
     Ext.getCmp('mineralcomboId').enable();
    buttonValue = 'Add';
    titelForInnerPanel = "Add Processing Fee Details";
    myWin.setPosition(450, 100);
     myWin.setTitle(titelForInnerPanel);
    myWin.show();
    //  myWin.setHeight(350);

    Ext.getCmp('permitTypeId').reset();
    Ext.getCmp('processingFeeId').reset();
    Ext.getCmp('mineralcomboId').reset();
    
    Ext.getCmp('permitTypeId').setReadOnly(false);
    Ext.getCmp('mineralcomboId').setReadOnly(false);
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("Select Customer Name");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
     	Ext.example.msg("No Rows Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     	Ext.example.msg("Select Single Row");
        return;
    }
    buttonValue = 'Modify';
    titelForInnerPanel = "Modify Processing Fee Details";
    myWin.setPosition(450, 100);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('permitTypeId').setValue(selected.get('permitTypeIndex'));
    Ext.getCmp('processingFeeId').setValue(selected.get('processingFeeIndex'));
    Ext.getCmp('mineralcomboId').setValue(selected.get('mineralTypeIndex'));
    Ext.getCmp('permitTypeId').setReadOnly(true);
    Ext.getCmp('mineralcomboId').setReadOnly(true);
    }
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'proFeeMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'permitTypeIndex'
    }, {
        name: 'processingFeeIndex'
    }, {
        name: 'mineralTypeIndex'
    }, {
        name: 'uniqueIdIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
      url: '<%=request.getContextPath()%>/ProcessingFeeMaster.do?param=getProcessingFeeMasterDetails',
        method: 'POST'
    }),
    storeId: 'mineMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'int',
        dataIndex: 'uniqueIdIndex'
    }, {
        type: 'string',
        dataIndex: 'permitTypeIndex'
    }, {
        type: 'string',
        dataIndex: 'processingFeeIndex'
    },{
        type: 'string',
        dataIndex: 'mineralTypeIndex'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>"
        },{
            header: "<span style=font-weight:bold;>Permit Type</span>",
            dataIndex: 'permitTypeIndex',
            width: 50           
        }, {
            header: "<span style=font-weight:bold;>Processing Fee</span>",
            dataIndex: 'processingFeeIndex',
            width: 100
        }, {
            header: "<span style=font-weight:bold;>Mineral Type</span>",
            dataIndex: 'mineralTypeIndex',
            width: 100
        }, {
            header: "<span style=font-weight:bold;>ID</span>",
            dataIndex: 'uniqueIdIndex',
            hidden:true,
            width: 100
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

grid = getGrid('Processing Fee Details', 'NoRecordsFound', store, screen.width - 40, 440, 8, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, '=Excel', jspName, exportDataType, false, 'PDF', true, 'Add', true, 'Modify', false, 'Delete');


  Ext.onReady(function() {
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
        items: [customerComboPanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>
<%}%>
<%}%>
   