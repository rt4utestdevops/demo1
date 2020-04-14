<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null)
	{
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

%>
<jsp:include page="../Common/header.jsp" />
 		<title>RakeExpense Master</title>		
    
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
   <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}	
			.x-table-layout-ct {
				overflow : hidden !important;
			}
			.x-window-tl *.x-window-header {			
				height : 38px !important;
			}
		</style>
	 <%}%>	
   <script>
   
var outerPanel;
var ctsb;
var jspName = "rakeExpenseMasterDetails";
var exportDataType = "int,int,string,string,number,number,number,string,date,string,date";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;



var loadTypeStore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Loaded', 1],
        ['Empty', 2]
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: loadTypeStore,
    id: 'loadTypecomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Load Type',
    blankText: 'Select Load Type',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Select Load Type',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

var innerPanelForRakeMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 190,
    width: 400,
    frame: false,
    id: 'innerPanelForRakeMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Rake Expense Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'AssociateLocationId',
        width: 360,
        height: 175,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'locationEmptyId1'
        },{
            xtype: 'label',
            text: 'Location ' + ' :',
            cls: 'labelstyle',
            id: 'LabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'locationId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter Location',
            blankText: 'Enter Location',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
               	 change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        	},{},
        	{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'statusEmptyId1'
        	}, {
            xtype: 'label',
            text: 'Load Type' + ' :',
            cls: 'labelstyle',
            id: 'loadTypeId'
       	 },  statuscombo,
         {},
        	 {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'fuelLtrsId1'
        	} ,
        	{ xtype: 'label',
        	  text: 'Fuel Ltrs' + ' :',
        	  cls: 'labelstyle',
        	  id: 'fuelLtrId'
        	 },
        	 {
	        	xtype: 'numberfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'fuelLtrsId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Fuel Ltrs',
	            blankText: 'Enter Fuel Ltrs',
	            selectOnFocus: true,
	            allowBlank: false,
            },{},
            
            {
            	xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'fuelRateLabelId'
            },
            {	
            	xtype: 'label',
        	  	text: 'Fuel Amount' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'fuelRateLabelId1'
            },
            {	
            	xtype: 'numberfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'fuelRateId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Fuel Amt',
	            blankText: 'Enter Fuel Amt',
	            selectOnFocus: true,
	            allowBlank: false,
            },{},
            {
            	xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'IncentiveLabelId'
            },
            {
            	xtype: 'label',
        	  	text: 'Incentives' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'IncentiveLabelId1'
            }, {
            	xtype: 'numberfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'incentiveId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Incentives',
	            blankText: 'Enter Incentives',
	            selectOnFocus: true,
	            allowBlank: false,
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
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   
                    if (Ext.getCmp('locationId').getValue() == "") {
                 	   Ext.example.msg("Enter Location");
                        return;
                    }
                    var loadType;
                    if (Ext.getCmp('loadTypecomboId').getValue() == "" || Ext.getCmp('loadTypecomboId').getValue() == "Select") {
                    	Ext.example.msg("Select Load Type");
                    	return;
                    } else {
                    	loadType = Ext.getCmp('loadTypecomboId').getValue();
                    }
                    
                    if(Ext.getCmp('fuelLtrsId').getValue()==""){
                    	Ext.example.msg("Enter Fuel Liters");
                    	return;
                    }
                    
                     if(Ext.getCmp('fuelRateId').getValue()==""){
                    	Ext.example.msg("Enter Fuel Amt");
                    	return;
                    }
                    
                    if(Ext.getCmp('incentiveId').getValue()=="")
                    {
                    	Ext.example.msg("Enter Incentive");
                    	return;
                    }
                              
                    var rec;
                    if (innerPanelForRakeMasterDetails.getForm().isValid()) {
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueIdDataIndex');
                            if(Ext.getCmp('loadTypecomboId').getValue() == "Loaded"){
                             loadType = 1;
                            }else if(Ext.getCmp('loadTypecomboId').getValue() == "Empty"){
                             loadType = 2;
                            }
                        }
                        
                        Ext.Ajax.request({
                        
                            url: '<%=request.getContextPath()%>/RakeExpenseMasterAction.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                               
                                locationId: Ext.getCmp('locationId').getValue(),
                                loadTypecomboId: loadType,
                                fuelLtrsId: Ext.getCmp('fuelLtrsId').getValue(),
                                fuelRateId: Ext.getCmp('fuelRateId').getValue(),
                                incentiveId: Ext.getCmp('incentiveId').getValue(),
                                id: id
                               
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('locationId').reset();
                                Ext.getCmp('loadTypecomboId').reset();
                                Ext.getCmp('fuelLtrsId').reset();
                                Ext.getCmp('fuelRateId').reset();
                                Ext.getCmp('incentiveId').reset();
                                
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                    				params: {
                        				jspName : jspName
                    				}
               					 });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
                    }
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
    width: 410,
    height: 250,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRakeMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 310,
    width: 430,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {

    
    buttonValue = 'Add';
    titelForInnerPanel = 'Rake Expense Master Information';
  
    myWin.setPosition(450, 170);
    myWin.show();
    //  myWin.setHeight(350);
    Ext.getCmp('locationId').enable();
    Ext.getCmp('locationId').reset();
    Ext.getCmp('loadTypecomboId').enable();
    Ext.getCmp('loadTypecomboId').reset();
    Ext.getCmp('fuelLtrsId').reset();
    Ext.getCmp('fuelRateId').reset();
    Ext.getCmp('incentiveId').reset();
 	
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
    titelForInnerPanel = 'Modify RakeMaster Details';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('locationId').setValue(selected.get('locationIndex')); 
    Ext.getCmp('locationId').disable();
    Ext.getCmp('loadTypecomboId').setValue(selected.get('loadTypeIndex'));
    Ext.getCmp('loadTypecomboId').disable();
    Ext.getCmp('fuelLtrsId').setValue(selected.get('fuelLtrsIndex'));
    Ext.getCmp('fuelRateId').setValue(selected.get('fuelRateIndex'));
    Ext.getCmp('incentiveId').setValue(selected.get('incentivesIndex'));
    
}

var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'rakeMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'locationIndex'
    }, {
        name: 'loadTypeIndex'
    }, {
        name: 'fuelLtrsIndex'
    }, {
        name: 'fuelRateIndex'
    }, {
        name: 'incentivesIndex'
    }, {
        name: 'createdByIndex'
    }, {
        name: 'createdDateIndex'
    }, {
        name: 'updatedByIndex'
    }, {
        name: 'updatedDateIndex'
  	 }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RakeExpenseMasterAction.do?param=getRakeMasterDetails',
        method: 'POST'
    }),
    storeId: 'rakeMasterId',
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
        dataIndex: 'locationIndex'
    }, {
        type: 'string',
        dataIndex: 'loadTypeIndex'
    },  {
        type: 'string',
        dataIndex: 'fuelLtrsIndex'
    },{
        type: 'string',
        dataIndex: 'fuelRateIndex'
    },{
        type: 'string',
        dataIndex: 'incentivesIndex'
    },{
        type: 'string',
        dataIndex: 'createdByIndex'
    },{
        type: 'string',
        dataIndex: 'createdDateIndex'
    },{
        type: 'string',
        dataIndex: 'updatedByIndex'
    },{
        type: 'string',
        dataIndex: 'updatedDateIndex'
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
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>ID</span>",
            dataIndex: 'uniqueIdDataIndex',
            hidden: true,
            width: 50,
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Location</span>",
            dataIndex: 'locationIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Load Type</span>",
            dataIndex: 'loadTypeIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Fuel Ltrs</span>",
            dataIndex: 'fuelLtrsIndex',
            width: 50,
            filter: {
                type: 'int'
            }
        }, {
        	header: "<span style=font-weight:bold;>Fuel Amount</span>",
            dataIndex: 'fuelRateIndex',
            width: 50,
            filter: {
                type: 'int'
            }
        },{	
        	header: "<span style=font-weight:bold;>Incentive</span>",
        	dataIndex: 'incentivesIndex',
        	width: 50,
        	filter: {
        		type: 'int'
        	}
        },{
        	header: "<span style=font-weight:bold;>Created By</span>",
        	dataIndex: 'createdByIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        },{
        	header: "<span style=font-weight:bold;>Created Date</span>",
        	dataIndex: 'createdDateIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        },{
        	header: "<span style=font-weight:bold;>Updated By</span>",
        	dataIndex: 'updatedByIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        },
        {
        	header: "<span style=font-weight:bold;>Updated Date</span>",
        	dataIndex: 'updatedDateIndex',
        	width: 50,
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

grid = getGrid('Rake Master Details', 'No Records Found', store, screen.width - 40, 440, 15, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'Add', true, 'Modify', false, 'Delete');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Rake Expense Master',
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
    	store.load({
                    params: {
                        jspName : jspName
                    }
                });
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->