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

%>
<jsp:include page="../Common/header.jsp" />
 		<title>FMS Job Card Settings</title>		
  
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
			height : 36px !important;
		}
		.x-table-layout-ct {
			overflow : hidden !important;
		}
		fieldset#AssociateRouteId {
			width : 378px !important;
		}
		.x-form-radio {
			margin-bottom : 5px !important;
		}
		.x-menu-list {
			height:auto !important;
		}
   </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "routeVehicleAssociationDetails";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;

var isActive='YES';
var globalCustId = '<%=customerId%>'; 

var clientcombostore1 = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId1',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if ( globalCustId > 0) {
                Ext.getCmp('custcomboIdOne').setValue('<%=customerId%>');
                custId = Ext.getCmp('custcomboIdOne').getValue();
                custName=Ext.getCmp('custcomboIdOne').getRawValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                managercombostore.load({
                 params: {
                        CustId: custId
                    }
                });
			}
  }
}
    
});

var ClientName = new Ext.form.ComboBox({
    store: clientcombostore1,
    id: 'custcomboIdOne',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Customer Name',
    blankText: 'Select Customer Name',
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
                custId = Ext.getCmp('custcomboIdOne').getValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                managercombostore.load({
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
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        ClientName
    ]
});

var managercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FMSExtJobCardSettingsAction.do?param=getManagerDetails',
    id: 'CustomerStoreId',
    root: 'ManagerRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['ManagerId','ManagerName'],
});

var managercombo = new Ext.form.ComboBox({
    store: managercombostore,
    id: 'managercomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Manager',
    blankText: 'Select Manager',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ManagerId',
    displayField: 'ManagerName',
    value: 'Select Manager',
    cls: 'selectstylePerfect'
});


var RadioButtons = new Ext.Panel({
   		border:false,
   	  	title:'',
		standardSubmit: true,
		hidden:false,
		//width:300,
		height:30,
		id:'RadioButtonsId',
		layout:'table',
		layoutConfig: {columns:5},
		items:[
			{
			xtype:'radio',
			id:'YESButtonId',
			value:'YESRADIO',
			checked: true,
		    // cls: 'myStyle',	
		    name:'optionX',
		    listeners:{
		        check:{fn:function(){
		        	if(this.checked){
		        		isActive = 'YES';        
		        	}		// end of if	
				}           // end of function
			 }              // end of check
		   }                // end of listeners
		  },                // end of xtype
		  {
		  xtype:'label',
		  width:80,
		  text:'YES',
		  cls:'myStyle'
		  },
			{width:20},
			{
			xtype:'radio',
			id:'NoButtonId',
			value:'NORADIO',
			checked:false,
		   // cls: 'myStyle',	
		    name:'optionX',
		    listeners:{
		        check:{fn:function(){
		        	if(this.checked){
		        		isActive = 'NO';     
		        	}		// end of if	
				}           // end of function
			 }              // end of check
		   }                // end of listeners
		  },                // end of xtype
		  {
		  xtype:'label',
		  width:20,
		  text:'NO',
		  cls:'myStyle'
		  }		  
		]
		});

var innerPanelForFMSJobCardDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 180,
    width: 400,
    frame: false,
    id: 'innerPanelForFMSJobCardDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'JobCard Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'AssociateRouteId',
        width: 380,
        height: 170,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [
          {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        }, {
            xtype: 'label',
            text: 'Ext JobCard Max Cost' + ' :',
            cls: 'labelstyle',
            id: 'nameLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            id: 'ExtJobCardMaxCostId',
            mode: 'local',
            allowNegative: false,
            forceSelection: true,
            emptyText: 'Enter Max Cost Value',
            blankText: 'Enter Max Cost Value',
            selectOnFocus: true,
            allowNegative: false,
            allowBlank: false,
            listeners: {
            'change': function(){
            	var amt=Ext.getCmp('ExtJobCardMaxCostId').getValue();
            	if(amt<=0){
            		Ext.example.msg("Cost Cannot Be Less Than Or Zero");
            		return;
            	}
            }
            }
            
        }, {},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'taskMandatory'
        }, {
            xtype: 'label',
            text: 'Ext JobCard subtask ? :',
            cls: 'labelstyle',
            id: 'jobcardsubtaskLabel'
        }, RadioButtons,{},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'managerMandatory'
        }, {
            xtype: 'label',
            text: 'Manager Name :',
            cls: 'labelstyle',
            id: 'routeLabel'
        },managercombo,{}
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
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboIdOne').getValue() == "") {
                    Ext.example.msg("Select Customer Name");
                        return;
                    }
                    if (Ext.getCmp('ExtJobCardMaxCostId').getValue() == "") {
                    Ext.example.msg("Enter External Jobcard Cost");
                        return;
                    }
                    var amt=Ext.getCmp('ExtJobCardMaxCostId').getValue();
            		if(amt<=0){
            			Ext.example.msg("Cost Cannot Be Less Than Or Zero");
            			return;
            		}
                    if (Ext.getCmp('managercomboId').getValue() == "") {
                    	Ext.example.msg("Select Manager Name");
                    	return;
                    }       
                    var rec;
                    if (innerPanelForFMSJobCardDetails.getForm().isValid()) {
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueIdDataIndex');
                           
                        }
                        OuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/FMSExtJobCardSettingsAction.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboIdOne').getValue(),
                                ExtJobCardMaxCostId: Ext.getCmp('ExtJobCardMaxCostId').getValue(),
                                ExtJobCardSubTaskYesNo: isActive,
                                managercomboId: Ext.getCmp('managercomboId').getValue(),
                                id: id
                               
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
                                Ext.getCmp('ExtJobCardMaxCostId').reset();
                                Ext.getCmp('YESButtonId').setValue(true);
                                Ext.getCmp('managercomboId').reset();
                                myWin.hide();
                                OuterPanelWindow.getEl().unmask();
                                store.reload();
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
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                Ext.getCmp('ExtJobCardMaxCostId').reset();
                Ext.getCmp('YESButtonId').setValue(true);
                Ext.getCmp('managercomboId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

var OuterPanelWindow = new Ext.Panel({
    width: 430,
    height: 240,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForFMSJobCardDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 300,
    width: 460,
    id: 'myWin',
    items: [OuterPanelWindow]
});

function addRecord() {
   
   if (Ext.getCmp('custcomboIdOne').getValue() == "") {
    Ext.example.msg("Select Customer Name");
        return;
    }
    buttonValue = 'Add';
    titelForInnerPanel = 'Add External JobCard Details';
    myWin.setPosition(450, 170);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    //  myWin.setHeight(350);
    Ext.getCmp('managercomboId').reset();
    
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
    titelForInnerPanel = 'Modify External Job Card Details';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    
    var selected = grid.getSelectionModel().getSelected();
    
    Ext.getCmp('ExtJobCardMaxCostId').setValue(selected.get('extMaxJCcostIndex'));
    Ext.getCmp('managercomboId').setValue(selected.get('ManagerNameIndex'));
    
    if(selected.get('ManagerNameIndex') == Ext.getCmp('managercomboId').getValue())
    {
    	 Ext.getCmp('managercomboId').setValue(selected.get('ManagerIDIndex'));
    }
    
    if(selected.get('extJCardSubTaskIndex') == 'YES') {
    	Ext.getCmp('YESButtonId').setValue(true);
    }
    else {
    	Ext.getCmp('NoButtonId').setValue(true);
    }
}



var reader = new Ext.data.JsonReader({
    idProperty: 'jobcardSettingId',
    root: 'fmsjobcardSettingRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },  {
        name: 'uniqueIdDataIndex'
    },  {
        name: 'customerNameIndex'
    }, {
        name: 'extMaxJCcostIndex'
    }, {
        name: 'extJCardSubTaskIndex'
    }, {
        name: 'ManagerNameIndex'
    }, {
    	name: 'ManagerEmailIdnex'
    },	{
    	name: 'ManagerPhoneNoIndex' 
    }, {
    	name: 'ManagerIDIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/FMSExtJobCardSettingsAction.do?param=getFMSJobCardSettingsDetails',
        method: 'POST'
    }),
    storeId: 'jobCardsettingDetailsId',
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
        dataIndex: 'customerNameIndex'
    }, {
        type: 'numeric',
        dataIndex: 'extMaxJCcostIndex'
    }, {
        type: 'string',
        dataIndex: 'extJCardSubTaskIndex'
    },  {
        type: 'string',
        dataIndex: 'ManagerNameIndex'
    }, {
        type: 'string',
        dataIndex: 'ManagerEmailIdnex'
    }, {
        type: 'string',
        dataIndex: 'ManagerPhoneNoIndex'
    }, {
    	type: 'numeric',
    	dataIndex: 'ManagerIDIndex'
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
            width: 100,
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'customerNameIndex',
            hidden: false,
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>External Max Jobcard Cost</span>",
            dataIndex: 'extMaxJCcostIndex',
            width: 80,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>External Jobcard Sub Task</span>",
            dataIndex: 'extJCardSubTaskIndex',
            width: 70,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>	Manager Name </span>",
            dataIndex: 'ManagerNameIndex',
            width: 70,
            filter: {
                type: 'string'
         		}
         }, {
            header: "<span style=font-weight:bold;>	Manager Email </span>",
            dataIndex: 'ManagerEmailIdnex',
            width: 80,
            filter: {
                type: 'string'
         		}
          }, {
            header: "<span style=font-weight:bold;>	Manager Phone </span>",
            dataIndex: 'ManagerPhoneNoIndex',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>	Manager ID </span>",
            dataIndex: 'ManagerIDIndex',
            hidden: true,
            width: 80,
            filter: {
                type: 'numeric'
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

grid = getGrid('Jobcard Setting Details', 'No Records Found', store, screen.width - 40, 440, 12, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'JobCard Settings',
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
});</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->