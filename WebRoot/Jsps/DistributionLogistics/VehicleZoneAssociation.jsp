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

///file-upload.js
ArrayList<String> tobeConverted = new ArrayList<String>();


%>
<jsp:include page="../Common/header.jsp" />
 		<title>Vehicle Zone Association</title>		
  

 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script> 
   <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
   	 
	 <style>
	  .x-panel-tl
		{
			border-bottom: 0px solid !important;
		}
		/* newly added with Header/Footer Changes */
		.x-panel-header
		{
				height: 7% !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 46px !important;
		}
		label {
			display : inline !important;
		}
		.x-panel-btns {
			padding: -5px !important;    
		}
		.x-layer ul {
			min-height: 27px !important;
		}
  </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Vehicle Zone Association";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel = "Add New Vehilce To Zone";
var myWin;
var selectedName = null;
var selectedType = null;
var custId = '<%=customerId%>';
var coutryId = '<%=countryId%>';
var zoneName;
var zoneId;

//**********************Strore For Vehicle Starts Here*********************************************
	
	var vehiclestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleZoneAssociation.do?param=getVehicles',
    id: 'VehicleStoreId',
    root: 'VehicleRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['Registration_No','Vehicle_group','odoMeter']
});

	//**********************Strore For Vehicle Ends Here*********************************************
//******************************************** Combo For Vehicle Starts Here*************************
	var vehiclecombo = new Ext.form.ComboBox({
    store: vehiclestore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'SelectRegistrationNo',
    selectOnFocus: true,
    allowBlank: false,
    resizable: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Registration_No',
    displayField: 'Registration_No',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
				   var vehicleNo = Ext.getCmp('vehiclecomboId').getValue();
                   var row = vehiclestore.find('Registration_No',Ext.getCmp('vehiclecomboId').getValue());
                   var rec = vehiclestore.getAt(row);
                   Ext.getCmp('vehicleGroupId').setValue(rec.data['Vehicle_group']);
                   callodo=rec.data['odoMeter'];
		           // alert('cal'+callodo);
            }
        }
    }
	});
//**********************Strore For Zone Starts Here*********************************************
	
	var zonestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleZoneAssociation.do?param=getZones',
    id: 'ZoneStoreId',
    root: 'ZoneRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['Zone_Name','HUBID']
});

	//**********************Strore For Zone Ends Here*********************************************
//******************************************** Combo For Zone Starts Here*************************
	var zonecombo = new Ext.form.ComboBox({
    store: zonestore,
    id: 'zoneId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'SelectZoneType',
    selectOnFocus: true,
    allowBlank: false,
    resizable: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'HUBID',
    displayField: 'Zone_Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
				   var zoneId = Ext.getCmp('zoneId').getValue();
                   var row = zonestore.find('Zone_Name',Ext.getCmp('zoneId').getValue());
                   var rec = zonestore.getAt(row);
                  
            }
        }
    }
	});
var innerPanelForVehicleZoneDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 360,
    width: 400,
    frame: false,
    id: 'innerPanelForVehicleZonAssociationDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title: 'Add New Record',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'NewRecordId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'label',
            text: 'Vehicle No.' + ' :',
            cls: 'labelstyle',
            id: 'vehicleNoLabelId'
        }, vehiclecombo
        ,{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id1'
        },{
            xtype: 'label',
            text: 'Vehicle Group' + ' :',
            cls: 'labelstyle',
            id: 'vehicleGroupLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'vehicleGroupId',
            mode: 'local',
            
            forceSelection: true,
            emptyText: 'Enter Vehicle Group Name',
            blankText: 'Enter Vehicle Group Name',
            selectOnFocus: true,
            allowBlank: false,
            maskRe: /[a-z0-9\s]/i,
			autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 100,
				type: "text",
				size: "100",
				autocomplete: "off"
			},
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id2'
        },
             {
            xtype: 'label',
            text: 'Zone' + ' :',
            cls: 'labelstyle',
            id: 'ZoneLabelId'
        }, zonecombo,{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'id3'
        }
            
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
                    
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                    Ext.example.msg("Select Vehicle No.");
                        return;
                    }
                    
                    if (Ext.getCmp('zoneId').getValue() == "") {
                    Ext.example.msg("Select Zone Type");
                        return;
                    }
                   
                      
                    var rec;
                    
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                           
                            id = selected.get('idIndex');
                           
                        }
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleZoneAssociation.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: <%=customerId%>,
                                
                                uniqueId: id,
                                VehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
                                VehicleGroup: Ext.getCmp('vehicleGroupId').getRawValue(), 
                                ZoneId: Ext.getCmp('zoneId').getValue(),
                                  //ZoneId:zoneValue
                                 //zoneName: Ext.getCmp('zoneId').getRawValue()
								
                               
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
                               
Ext.getCmp('vehiclecomboId').reset();
Ext.getCmp('vehicleGroupId').reset();
Ext.getCmp('zoneId').reset();
                              myWin.hide();
                                VehicleZoneOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
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
var VehicleZoneOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 400,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForVehicleZoneDetails, innerWinButtonPanel]
});
myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 430,
    id: 'myWin',
    items: [VehicleZoneOuterPanelWindow]
});
function addRecord() {
 //Ext.getCmp('vehicleNoLabelId').enable();
  buttonValue = 'Add';
    titelForInnerPanel = 'Associate Vehicle To Zone';
    myWin.setPosition(450, 170);
    myWin.show(); 
    myWin.setTitle(titelForInnerPanel);
    vehiclestore.load({params:{CustId:<%=customerId%>}});
    zonestore.load({params:{CustId:<%=customerId%>}});
     myWin.setTitle(titelForInnerPanel);
    
      
     
      Ext.getCmp('vehiclecomboId').reset();
       Ext.getCmp('vehiclecomboId').enable();
	  Ext.getCmp('vehicleGroupId').reset();
	  Ext.getCmp('vehicleGroupId').enable();
	 Ext.getCmp('zoneId').reset();
	  Ext.getCmp('zoneId').enable();
}
function modifyData() {
   
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("NoRowsSelected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("SelectSingleRow");
        return;
    }
    buttonValue = 'Modify';
    titelForInnerPanel = 'ModifyDetails';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
   
    
    var selected = grid.getSelectionModel().getSelected();
	Ext.getCmp('vehiclecomboId').setValue(selected.get('VehicleNoDataIndex'));
	Ext.getCmp('vehiclecomboId').disable();
	
	Ext.getCmp('vehicleGroupId').setValue(selected.get('VehicleGroupDataIndex'));
	Ext.getCmp('vehicleGroupId').disable();
	 zonestore.load({params:{CustId:<%=customerId%>}});
	Ext.getCmp('zoneId').setValue(selected.get('ZoneDataIndexId'));
	Ext.getCmp('zoneId').getRawValue(selected.get('ZoneDataIndex'));
	//getRawValue()

}

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
        type: 'numeric',
        dataIndex: 'idIndex'
    },{
        type: 'string',
        dataIndex: 'VehicleNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'VehicleGroupDataIndex'
    },{
        type: 'string',
        dataIndex: 'ZoneDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'ZoneDataIndexId'
    },{
        type: 'string',
        dataIndex: 'CreateByDataIndex'
    },{
        type: 'string',
        dataIndex: 'CreateDateDataIndex'
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
            header: "<span style=font-weight:bold;>'SLNO</span>",
            filter: {
                type: 'numeric'
            }
        }, {
              header: "<span style=font-weight:bold;>ID</span>",
              dataIndex: 'idIndex',
              hidden: true,
              width: 30,
              filter: {
                  type: 'int'
              }
          },  {
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            dataIndex: 'VehicleNoDataIndex',          
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Vehicle Group</span>",
            dataIndex: 'VehicleGroupDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Zone</span>",
            dataIndex: 'ZoneDataIndex',
            width: 50,
            filter: {
                type: 'numeric'
            }
        },{
              header: "<span style=font-weight:bold;>ZONE_OR_HUB_ID</span>",
              dataIndex: 'ZoneDataIndexId',
              hidden: true,
              width: 30,
              filter: {
                  type: 'numeric'
              }
          }, {
            header: "<span style=font-weight:bold;>Created By</span>",
            dataIndex: 'CreateByDataIndex',
            width: 50,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Created Date</span>",
            dataIndex: 'CreateDateDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }}];
         return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
        };
        
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'vehicleZoneDetails',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'idIndex'
    }, {
        name: 'VehicleNoDataIndex'
    },{
        name: 'VehicleGroupDataIndex'
    },{
        name: 'ZoneDataIndex'
    },{
        name: 'ZoneDataIndexId'
    },{
        name: 'CreateByDataIndex'
    },{
        name: 'CreateDateDataIndex'
    }]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VehicleZoneAssociation.do?param=getVehicleZoneDetails',
        method: 'POST'
    }),
    storeId: 'vehicleZoneDetailsId',
    reader: reader
});
grid = getGrid('', 'NoRecordsFound', store, screen.width - 40, 440, 15, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, 'Excel', jspName, '', false, 'PDF', true, 'Add', true, 'Modify', false, 'Delete');

Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title: 'Vehicle Zone Association',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
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
                      CustId: '<%=customerId%>'
                                    }
                                });
    sb = Ext.getCmp('form-statusbar');
});</script>

 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
