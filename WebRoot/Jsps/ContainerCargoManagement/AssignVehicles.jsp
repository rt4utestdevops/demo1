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

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Modified_Date_Time");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("Assign_Vehicles");
tobeConverted.add("Select_Vehicle");
tobeConverted.add("Select_Principal");
tobeConverted.add("Add_Details");
tobeConverted.add("Modify_Details");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Principal_Name");
tobeConverted.add("Consignee_Name");
tobeConverted.add("Assigned_By");
tobeConverted.add("Assigned_Date_Time");
tobeConverted.add("Modified_By");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ModifiedDateTime=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String ID=convertedWords.get(6);
String Delete=convertedWords.get(7);
String NoRowsSelected=convertedWords.get(8);
String SelectSingleRow=convertedWords.get(9);
String Save=convertedWords.get(10);
String Cancel=convertedWords.get(11);

String AssignVehicles=convertedWords.get(12);
String SelectVehicle=convertedWords.get(13);
String SelectPrincipal=convertedWords.get(14);
String AddDetails=convertedWords.get(15);
String ModifyDetails=convertedWords.get(16);
String VehicleNo=convertedWords.get(17);
String PrincipalName=convertedWords.get(18);
String ConsigneeName=convertedWords.get(19);
String AssignedBy=convertedWords.get(20);
String AssignedDateTime=convertedWords.get(21);
String ModifiedBy=convertedWords.get(22);

int userId=loginInfo.getUserId(); 

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Assign Vehicles</title>		
    
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
	
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-layer ul {
		 	min-height:26px !important;
		}
		.x-window-tl *.x-window-header {
			height: 46px !important;
		}
   </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Assign Vehicles";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;

	window.onload = function () { 
		loadDataStore();
	}

//******************************** Vehicle Combo**************************************//

    var vehicleStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/AssignVehiclesAction.do?param=getVehicles',
           id: 'vehicleStoreId',
				    root: 'vehicleStoreRoot',
				    autoload: false,
				    remoteSort: true,
				    fields: ['vehicleNo']
	});
	var vehicleCombo = new Ext.form.ComboBox({
	    value: '',
	    width: 175,
	    store: vehicleStore,
	    displayField: 'vehicleNo',
	    valueField: 'vehicleNo',
	    mode: 'local',
	    forceSelection: true,
	    triggerAction: 'all',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    selectOnFocus: true,
	    cls:'selectstylePerfectnew',
	    emptyText: 'SelectVehicle',
	    labelSeparator: '',
	    id: 'vehicleId',
	    loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	                vehId = Ext.getCmp('vehicleId').getValue();
	            }
	        }
	    }
    }); 
    
    //******************************** Principal Combo**************************************//
    
    var principalStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AssignVehiclesAction.do?param=getPrinicipalStore',
        id: 'principalStoreId',
        root: 'principalStoreRoot',
        remoteSort: true,
        autoLoad: true,
        fields: ['principalId', 'principalName']
    });
    
    var principalCombo = new Ext.form.ComboBox({
	    value: '',
	    width: 175,
	    store: principalStore,
	    displayField: 'principalName',
	    valueField: 'principalId',
	    mode: 'local',
	    forceSelection: true,
	    triggerAction: 'all',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    selectOnFocus: true,
	    emptyText: 'Select Principal',
	    labelSeparator: '',
	    id: 'principalId',
	    loadingText: 'Searching...',
	    enableKeyEvents: true,
	    cls:'selectstylePerfectnew',
	    listeners: {
	        select: {
	            fn: function() {
	                principalId = Ext.getCmp('principalId').getValue();
	            }
	        }
	    }
    }); 

    //******************************** Consignee Combo**************************************//
    
    var ConsigneeStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AssignVehiclesAction.do?param=getConsigneeStore',
        id: 'consigneeStoreId',
        root: 'consigneeStoreRoot',
        remoteSort: true,
        autoLoad: true,
        fields: ['consigneeId', 'consigneeName']
    });
    
    var consigneeCombo = new Ext.form.ComboBox({
	    value: '',
	    width: 175,
	    store: ConsigneeStore,
	    displayField: 'consigneeName',
	    valueField: 'consigneeId',
	    mode: 'local',
	    forceSelection: true,
	    triggerAction: 'all',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    selectOnFocus: true,
	    emptyText: 'Select Consignee',
	    labelSeparator: '',
	    id: 'consigneeId',
	    loadingText: 'Searching...',
	    enableKeyEvents: true,
	    cls:'selectstylePerfectnew',
	    listeners: {
	        select: {
	            fn: function() {
	                consigneeId = Ext.getCmp('consigneeId').getValue();
	            }
	        }
	    }
    }); 
	
var innerPanelForAssignVehicle = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 210,
    width: 450,
    frame: false,
    id: 'innerPanelForWeighbridgeMasterId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title:'Assign Vehicle Details',
        cls: 'my-fieldset',
        collapsible: false,
        id: 'WBInfoId',
        width: 445,
        height:200,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'MandatoryWBId'
        },{
            xtype: 'label',
            text: 'Vehicle No' + ' :',
            cls: 'labelstylenew',
            id: 'WBLocationLabelId'
        }, vehicleCombo,  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: 'Principal Name' + ' :',
            cls: 'labelstylenew',
            id: 'weighbridgeLabelId'
        }, principalCombo,  {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'nameEmptyId2'
        },{
            xtype: 'label',
            text: 'Consignee Name' + ' :',
            cls: 'labelstylenew',
            id: 'companyNameLabelId'
        }, consigneeCombo
        ]
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
                var principal;
                    if (Ext.getCmp('vehicleId').getValue() == "") {
                    Ext.example.msg("<%=SelectVehicle%>");
                    Ext.getCmp('vehicleId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('principalId').getValue() == "") {
                    Ext.example.msg("<%=SelectPrincipal%>");
                    Ext.getCmp('principalId').focus();
                        return;
                    }
                    
                    principal = Ext.getCmp('principalId').getValue();
                    consignee = Ext.getCmp('consigneeId').getValue();
                    
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            
                            id = selected.get('uniqueIdDataIndex');
                            var compstr = principalStore.find('principalName', Ext.getCmp('principalId').getValue());
		                    if(compstr >= 0){
	                               var record = principalStore.getAt(compstr);
	                                principal = record.data['principalId'];
                                }
                                
                            var compstr1 = ConsigneeStore.find('consigneeName', Ext.getCmp('consigneeId').getValue());
		                    if(compstr1 >= 0){
	                               var record = ConsigneeStore.getAt(compstr1);
	                                consignee = record.data['consigneeId'];
                                }
                        }
                        
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/AssignVehiclesAction.do?param=AddorModifyAssignedVehicleDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                vehicle: Ext.getCmp('vehicleId').getValue(),
								principal: principal,
								consignee: consignee,
                                id: id
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
							    Ext.getCmp('vehicleId').reset();
							    Ext.getCmp('principalId').reset();
							    Ext.getCmp('consigneeId').reset();
                                myWin.hide();
                                WBMasterOuterPanelWindow.getEl().unmask();
                                store.load();
                                vehicleStore.reload();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                vehicleStore.reload();
                                myWin.hide();
                            }
                        });
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

var WBMasterOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 270,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForAssignVehicle, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 330,
    width: 475,
    id: 'myWin',
    items: [WBMasterOuterPanelWindow]
});

function addRecord() {

    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(450, 50);
    myWin.show();

    Ext.getCmp('vehicleId').reset();
    Ext.getCmp('principalId').reset();
    Ext.getCmp('consigneeId').reset();
    Ext.getCmp('vehicleId').enable();
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
    
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Rows Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("Select Single Row");
        return;
    }
    buttonValue = 'Modify';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('vehicleId').reset();
    Ext.getCmp('principalId').reset();
    Ext.getCmp('consigneeId').reset();
    Ext.getCmp('vehicleId').enable();
    
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('vehicleId').setValue(selected.get('vehicleNoIndex'));
	Ext.getCmp('vehicleId').disable();
	Ext.getCmp('principalId').setValue(selected.get('principalNameIndex'));
	Ext.getCmp('consigneeId').setValue(selected.get('consigneeNameIndex'));
    }
    
var reader = new Ext.data.JsonReader({
    idProperty: 'assignVehiclesid',
    root: 'assignVehiclesRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'uniqueIdDataIndex'
    },{
        name: 'vehicleNoIndex'
    },{
        name: 'principalNameIndex'
    },{
        name: 'consigneeNameIndex'
    },{
        name: 'associatedByIndex'
    },{
        name: 'associatedTimeIndex'
    },{
        name: 'modifiedByIndex'
    },{
        name: 'modifiedTimeIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/AssignVehiclesAction.do?param=getAssignedVehiclesDetails',
        method: 'POST'
    }),
    storeId: 'assignVehiclesStoreId',
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
        dataIndex: 'vehicleNoIndex'
    }, {
        type: 'string',
        dataIndex: 'principalNameIndex'
    }, {
        type: 'string',
        dataIndex: 'consigneeNameIndex'
    }, {
        type: 'string',
        dataIndex: 'associatedByIndex'
    }, {
        type: 'string',
        dataIndex: 'associatedTimeIndex'
    }, {
        type: 'string',
        dataIndex: 'modifiedByIndex'
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
            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            dataIndex: 'vehicleNoIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PrincipalName%></span>",
            dataIndex: 'principalNameIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ConsigneeName%></span>",
            dataIndex: 'consigneeNameIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssignedBy%></span>",
            dataIndex: 'associatedByIndex',
            width: 70,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssignedDateTime%></span>",
            dataIndex: 'associatedTimeIndex',
            width: 70,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ModifiedBy%></span>",
            dataIndex: 'modifiedByIndex',
            width: 70,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ModifiedDateTime%></span>",
            dataIndex: 'modifiedTimeIndex',
            width: 70,
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

grid = getGrid('<%=AssignVehicles%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 12, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

function loadDataStore(){
		vehicleStore.load();
		principalStore.load();
		ConsigneeStore.load();
		store.load();
	}
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
        items: [grid]
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> --><%}%>