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
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Excel");
tobeConverted.add("Modify_Details");
tobeConverted.add("Customer_Name");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Delete");
tobeConverted.add("Not_Deleted");
tobeConverted.add("Route_Names");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Vehicle_Group");
tobeConverted.add("Created_By");
tobeConverted.add("Updated_By");
tobeConverted.add("Created_Time");
tobeConverted.add("Updated_Time");
tobeConverted.add("Route_Vehicle_Association");
tobeConverted.add("Associate_Route");
tobeConverted.add("Select_Route");
tobeConverted.add("Select_Group");
tobeConverted.add("Select_Vehicle");
tobeConverted.add("RouteId");
tobeConverted.add("Vehicle_GroupId");
tobeConverted.add("Route_Vehicle_Association_Details");
tobeConverted.add("Add_Route_Vehicle");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRowsSelected=convertedWords.get(3);
String SelectSingleRow=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String Save=convertedWords.get(6);
String Cancel=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String NoRecordsFound=convertedWords.get(9);
String Excel=convertedWords.get(10);
String ModifyDetails=convertedWords.get(11);
String CustomerName=convertedWords.get(12);
String Areyousureyouwanttodelete=convertedWords.get(13);
String Delete=convertedWords.get(14);
String NotDeleted=convertedWords.get(15);
String Route = convertedWords.get(16);
String VehicleNo = convertedWords.get(17);
String VehicleGroup = convertedWords.get(18);
String CreatedBy = convertedWords.get(19);
String UpdatedBy = convertedWords.get(20);
String CreatedTime = convertedWords.get(21);
String UpdatedTime = convertedWords.get(22);
String RouteVehicleAssociation = convertedWords.get(23);
String AssociateRoute = convertedWords.get(24);
String SelectRoute = convertedWords.get(25);
String Group = convertedWords.get(26);
String Vehicle = convertedWords.get(27);
String RouteID= convertedWords.get(28);
String VehicleGroupId = convertedWords.get(29);
String RouteVehicleDetails = convertedWords.get(30);
String AddRouteVehicle = convertedWords.get(31);
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Route Vehicle Association</title>		
 
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	label {
			display : inline !important;
		}
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	.x-layer ul {
		 	min-height: 27px !important;
		}
	
  </style>
  
<!--  <body>-->
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.x-window-tl *.x-window-header  {
		padding-top : 6px !important;
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
var clientcombostore = new Ext.data.JsonStore({
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
                store.load({
                    params: {
                        CustId: custId
                    }
                });
               routecombostore.load({
                     params:{
                         clientId:custId
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
               routecombostore.load({
                     params:{
                         clientId:custId
                     }
               }); 
            }
        }
    }
});

var routecombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/RouteVehicleAssociationAction.do?param=getCustomerRoute',
    id: 'RouteStoreId',
    root: 'customerRouteList',
    autoLoad: false,
    remoteSort: true,
    fields: ['RouteId', 'RouteName']
});


var RouteCombo = new Ext.form.ComboBox({
    store: routecombostore,
    id: 'RouteId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectRoute%>',
    blankText: '<%=SelectRoute%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'RouteId',
    displayField: 'RouteName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
            	Ext.getCmp('GroupId').reset();
            	vehicleGrid.getStore().removeAll();
            	groupcombostore.load({
                    params: {
						clientId:custId
                    }
                });
            }
        }
    }
});

var groupcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/RouteVehicleAssociationAction.do?param=getGroups',
    id: 'GroupStoreId',
    root: 'groupNameList',
    autoLoad: false,
    remoteSort: true,
    fields: ['GroupId', 'GroupName']
});

var GroupCombo = new Ext.form.ComboBox({
    store: groupcombostore,
    id: 'GroupId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Group%>',
    blankText: '<%=Group%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'GroupId',
    displayField: 'GroupName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
            var vno = '';
            if(buttonValue == 'Modify'){
              routeId=grid.getSelectionModel().getSelected().get('routeIdDataIndex');
              if(Ext.getCmp('GroupId').getValue()==grid.getSelectionModel().getSelected().get('vehicleGroupIdDataIndex')){
                   vno = grid.getSelectionModel().getSelected().get('vehicleNoDataIndex');
               }
               Ext.getCmp('VehicleId').reset();
            } 
            else
              routeId=Ext.getCmp('RouteId').getValue();
              
                custId = Ext.getCmp('custcomboId').getValue();
                vehicleStore.load({
                    params: {
						clientId:custId,
						groupId:Ext.getCmp('GroupId').getValue(),
						routeId:routeId,
						vehicleNo:vno
                    }
                });
            }
        }
    }
});
	var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'string',
        dataIndex: 'vehicleNo'
    }]
    });

    var vehicleStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RouteVehicleAssociationAction.do?param=getVehicle',
        id: 'vehicleStoreId',
        root: 'clientVehicles',
        autoLoad: false,
        fields: ['vehicleNo']
    });

	
    var smVehicle = new Ext.grid.CheckboxSelectionModel();
    var vehicleGrid = new Ext.grid.GridPanel({
        store: vehicleStore,
        columns: [
        smVehicle, {
            header: 'Select All Vehicles',
            hidden: false,
            sortable: true,
            width: 123,
            id: 'selectAllVehicleId',
            dataIndex: 'vehicleNo'
        }],
        sm: smVehicle,
        plugins: filters,
        id: 'vehicleSelectionId',
        stripeRows: true,
        border: true,
        frame:false,
        width: 165,
        height: 145,
        style: 'margin-left:5px;',
        cls: 'bskExtStyle'
    });

var VehicleCombo = new Ext.form.ComboBox({
    store: vehicleStore,
    id: 'VehicleId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Vehicle%>',
    blankText: '<%=Vehicle%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNo',
    displayField: 'vehicleNo',
    cls: 'selectstylePerfect'

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
        Client
    ]
});
var innerPanelForRouteVehicleAssociationDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: '80%',
    width: 365,
    frame: false,
    id: 'innerPanelForRouteVehicleAssociationDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AssociateRoute%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'AssociateRouteId',
        width: 350,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'routeEmptyId1'
        },{
            xtype: 'label',
            text: '<%=SelectRoute%>' + ' :',
            cls: 'labelstyle',
            id: 'routeLabelId'
        }, RouteCombo, 
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'routeEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'groupEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Group%>' + ' :',
            cls: 'labelstyle',
            id: 'groupLabelId'
        }, GroupCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'addressEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'vehicleEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Vehicle%>' + ' :',
            cls: 'labelstyle',
            id: 'vehicleLabelId'
        }, vehicleGrid, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'vehicleEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'vehicleEmpty1Id1'
        },{
            xtype: 'label',
            text: '<%=Vehicle%>' + ' :',
            cls: 'labelstyle',
            id: 'vehicleLabel1Id'
        }, VehicleCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'vehicleEmpty1Id2'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: '10%',
    width: 350,
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
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                    return;
                    }
                    if (Ext.getCmp('RouteId').getValue() == "") {
                    Ext.example.msg("<%=SelectRoute%>");
                    return;
                    }
                    if (Ext.getCmp('GroupId').getValue() == "") {
                    Ext.example.msg("<%=Group%>");
                    return;
                    }
                    if(buttonValue == 'Add'){
                    	selectedVehicles = "-";
                    	var recordVehicles = vehicleGrid.getSelectionModel().getSelections();
       					for (var i = 0; i < recordVehicles.length; i++) {
            			var recordrem = recordVehicles[i];
            			var vehicleNo = recordrem.data['vehicleNo'];
            			if (selectedVehicles == "-") {
                			selectedVehicles = "'" + vehicleNo + "'";
		            	} else {
			            	selectedVehicles = selectedVehicles + "," + "'" + vehicleNo + "'";
		            	}
      			    }
						if (selectedVehicles == '' || selectedVehicles == '0' || selectedVehicles == '-') {
    	        				message = "Please Select atleast one Vehicle.";
        	    				showVehicleMessage(message);
            					return;
	            		}
	            		Ext.getCmp('VehicleId').setValue('All');
        			}
                    if (innerPanelForRouteVehicleAssociationDetails.getForm().isValid()) {
                    //alert('aa');
                        var selectedRouteId;
                        var selectedVehicleNo;
                        var updatedVehicleNo;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            selectedRouteId = selected.get('routeIdDataIndex');
                            updatedVehicleNo = selected.get('vehicleNoDataIndex');
                            selectedVehicleNo = Ext.getCmp('VehicleId').getValue();
                        }
                        routeVehicleAssociationOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/RouteVehicleAssociationAction.do?param=routeVehicleAssociationAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                routeId : Ext.getCmp('RouteId').getValue(),
                                vehicleNo : selectedVehicles,
                                gridRouteId :selectedRouteId,
                                gridVehicleNo :selectedVehicleNo,
                                gridUpdatedVehicleNo :updatedVehicleNo 
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                
                                Ext.getCmp('RouteId').reset();
                                Ext.getCmp('GroupId').reset();
                                vehicleGrid.getStore().removeAll();
                                myWin.hide();
                                routeVehicleAssociationOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function () {
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
                fn: function () {
                	GroupCombo.store.removeAll();
            		vehicleGrid.getStore().removeAll();
                    myWin.hide();
                }
            }
        }
    }]
});

function showVehicleMessage(message) {
        Ext.MessageBox.show({
            msg: message,
            buttons: Ext.MessageBox.OK
        });
    }
var routeVehicleAssociationOuterPanelWindow = new Ext.Panel({
    width: 370,
    height: 335,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRouteVehicleAssociationDetails, innerWinButtonPanel]
});
myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 350,
    width: 380,
    id: 'myWin',
    items: [routeVehicleAssociationOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    Ext.example.msg("<%=SelectCustomerName%>");
    return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddRouteVehicle%>';
    myWin.setPosition(450, 130);
    myWin.show();
    myWin.setHeight(350);
    Ext.getCmp('RouteId').setDisabled(false); 
    VehicleCombo.setVisible(false);
    Ext.getCmp('vehicleSelectionId').show();
    Ext.getCmp('vehicleEmptyId1').show();
    Ext.getCmp('vehicleEmptyId2').show();
    Ext.getCmp('vehicleLabelId').show();
    Ext.getCmp('vehicleEmpty1Id1').hide();
    Ext.getCmp('vehicleEmpty1Id2').hide();
    Ext.getCmp('vehicleLabel1Id').hide();
    Ext.getCmp('RouteId').reset();
	Ext.getCmp('GroupId').reset();
	vehicleGrid.getStore().removeAll();
    myWin.setTitle(titelForInnerPanel);
    
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
    	Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
   		 Ext.example.msg("<%=SelectSingleRow%>");
         return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    myWin.setHeight(230);
	Ext.getCmp('RouteId').show();
    Ext.getCmp('GroupId').show();
    VehicleCombo.setVisible(true);
    Ext.getCmp('RouteId').setDisabled(true);
    Ext.getCmp('vehicleSelectionId').hide();
    Ext.getCmp('vehicleEmptyId1').hide();
    Ext.getCmp('vehicleEmptyId2').hide();
    Ext.getCmp('vehicleLabelId').hide();
    Ext.getCmp('vehicleEmpty1Id1').show();
    Ext.getCmp('vehicleEmpty1Id2').show();
    Ext.getCmp('vehicleLabel1Id').show();
    var selected = grid.getSelectionModel().getSelected();
    routeId = selected.get('routeIdDataIndex');
    Ext.getCmp('RouteId').setValue(selected.get('routeDataIndex'));
    Ext.getCmp('GroupId').setValue(selected.get('vehicleGroupDataIndex'));
	Ext.getCmp('VehicleId').setValue(selected.get('vehicleNoDataIndex'));
     custId = Ext.getCmp('custcomboId').getValue();
     groupcombostore.load({
          params: {
			        clientId:custId
                  }
     });
     vehicleStore.load({
          params: {
			        clientId:custId,
					groupId:selected.get('vehicleGroupIdDataIndex'),
					routeId:routeId,
					vehicleNo:selected.get('vehicleNoDataIndex')
                  }
     });
}

function deleteData() {

 if (Ext.getCmp('custcomboId').getValue() == "") {
 			Ext.example.msg("<%=SelectCustomerName%>");
 		    return;
                    }
                    
    if (grid.getSelectionModel().getCount() == 0) {
   			 Ext.example.msg("<%=NoRowsSelected%>");
             return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
    		Ext.example.msg("<%=SelectSingleRow%>");
    	    return;
    }
    Ext.Msg.show({
        title: 'Delete',
        msg: '<%=Areyousureyouwanttodelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                var routeId = selected.get('routeIdDataIndex');
                var vehicleNo = selected.get('vehicleNoDataIndex');
                outerPanel.getEl().mask();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/RouteVehicleAssociationAction.do?param=deleteData',
                    method: 'POST',
                    params: {
                        vehicleNo:vehicleNo,
                        routeId:routeId
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        
                        outerPanel.getEl().unmask();
                        store.load({
                            params: {
                                CustId: custId
                            }
                        });
                    },
                    failure: function () {
                    Ext.example.msg("Error");
                       
                        store.reload();
                    }
                });
                break;
            case 'no':
            Ext.example.msg("<%=NotDeleted%>");
                
                store.reload();
                break;
            }
        }
    });
}
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'routeVehicleAssociationRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'routeIdDataIndex'
    }, {
        name: 'routeDataIndex'
    }, {
        name: 'vehicleNoDataIndex'
    }, {
        name: 'vehicleGroupIdDataIndex'
    },{
        name: 'vehicleGroupDataIndex'
    }, {
        name: 'createdByDataIndex'
    }, {
        name: 'createdDateDataIndex'
    }, {
        name: 'updatedByDataIndex'
    }, {
        name: 'updatedDateDataIndex'
    }]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RouteVehicleAssociationAction.do?param=getRouteVehicleAssociationReport',
        method: 'POST'
    }),
    storeId: 'routevehicleassociationId',
    reader: reader
});
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },  {
        type: 'numeric',
        dataIndex: 'routeIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'routeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNoDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'vehicleGroupIdDataIndex'
    },  {
        type: 'string',
        dataIndex: 'vehicleGroupDataIndex'
    }, {
        type: 'string',
        dataIndex: 'createdByDataIndex'
    }, {
        type: 'string',
        dataIndex: 'createdDateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'updatedByDataIndex'
    }, {
        type: 'string',
        dataIndex: 'updatedDateDataIndex'
    }]
});
var createColModel = function (finish, start) {
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
            header: "<span style=font-weight:bold;><%=RouteID%></span>",
            hidden:true,
            dataIndex: 'routeIdDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Route%></span>",
            dataIndex: 'routeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            dataIndex: 'vehicleNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleGroupId%></span>",
            hidden:true,
            dataIndex: 'vehicleGroupIdDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;><%=VehicleGroup%></span>",
            dataIndex: 'vehicleGroupDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CreatedBy%></span>",
            dataIndex: 'createdByDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CreatedTime%></span>",
            dataIndex: 'createdDateDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=UpdatedBy%></span>",
            dataIndex: 'updatedByDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=UpdatedTime%></span>",
            dataIndex: 'updatedDateDataIndex',
            width: 100,
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
//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=RouteVehicleDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 15, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');
//******************************************************************************************************************************************************

Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=RouteVehicleAssociation%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid],
       // bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
});</script>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 