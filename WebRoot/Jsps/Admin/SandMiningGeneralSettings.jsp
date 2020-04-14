<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

String SelectCustomer="Select Customer"; 
String CustomerName="Customer Name";
String SelectLTSP="Select Ltsp Name";
String LTSPName="Ltsp Name";
String NoRecordsFound = "No Record Found";
String ClearFilterData = "Clear Filter Data";
String Add = "Add";
String SLNO = "SLNO";
String AddDetails = "Add Subscription Payment Details";
String Save = "Save";
String Cancel = "Cancle";

%>
<!DOCTYPE HTML>
<head>
		
		<base href="<%=basePath%>">
		<title>Sand Mining General Settings</title>
</head>

<body>

<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
<!-- for grid -->
<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
<pack:style src="../../Main/resources/css/ext-all.css" />
<pack:style src="../../Main/resources/css/chooser.css" />
<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/component.css" />
<pack:style src="../../Main/resources/css/dashboard.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
<pack:style src="../../Main/resources/css/commonnew.css" />
<pack:style src="../../Main/iconCls/icons.css" />
<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
<!-- for grid -->
<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<pack:style src="../../Main/resources/css/examples1.css" />
<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>	
<pack:script src="../../Main/Js/MonthPickerPlugin.js"></pack:script>
 
<script>
document.documentElement.setAttribute("dir", "ltr");
function getwindow(jsp){
window.location=jsp;
 }
</script>
  <table id="tableID" style="width:100%;height:99%;background-color:#FFFFFF;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="99%">
  <td height="99%" id="content">
  </td>
  </tr>
</table>
              
               
 <script>

	var outerPanel;
	var ctsb;
	var exportDataType = "int,String,string,string,string";
	var jspName ="Sand Mining General Setting";	
	var buttonValue;
	var unitResponseImportData;
	var start_time ;
	var titelForInnerPanel;
	var curdate=datecur;

	function isValid(amount) {
    	var pattern = new RegExp('^[0-9]+$');
    	return pattern.test(amount);
	}
 var ltspNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getLTSPNames',
        id: 'ltspNameStoreId',
        root: 'ltspNameList',
        autoLoad: true,
        remoteSort: true,
        fields: ['Systemid', 'SystemName']
    });
	
	 var selectLtspDropDown = new Ext.form.ComboBox({
        store: ltspNameStore,
        displayField: 'SystemName',
        valueField: 'Systemid',
        typeAhead: false,
        id: 'selectLtspDropDownID',
        cls: 'selectstylePerfect',
        mode: 'local',
        width: 180,
        triggerAction: 'all',
        emptyText: 'Select LTSP',
        selectOnFocus: true,
        listeners: {
            select: {
                fn: function () {
				
					var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();                    
                    clientNameStore.reload({
                        params: {
                            systemid: pagesystemId
                        }
                    });
	
                }
            }
        }
    });
	
	 var clientNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getClientNameswrtSystem',
        root: 'clientNameList',
        autoLoad: false,
        fields: ['clientid', 'clientname']
    });

    var clientNameSelect = new Ext.form.ComboBox({
        fieldLabel: '',
        standardSubmit: true,
        width: 180,
        selectOnFocus: true,
        cls: 'selectstylePerfect',
        forceSelection: true,
        anyMatch: true,
        OnTypeAhead: true,
        store: clientNameStore,
        displayField: 'clientname',
        valueField: 'clientid',
        mode: 'local',
        emptyText: 'Select Client',
        triggerAction: 'all',
        labelSeparator: '',
        id: 'clientId',
        value: "",
        minChars: 2,
        listeners: {
            select: {
                fn: function () {
                 
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS		
    });
    

    
    
  var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true, 
    width: screen.width - 12,
    height:40,
    frame: false,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 10
    },
     items: [
            {width:40},
            {
                xtype: 'label',
                text: 'Select LTSP :',
                cls: 'labelstyle',
                id: 'UnitNoid'
            },  selectLtspDropDown,{width:40},{	
            	xtype:'button',
				text: 'View',
				width:70,
				listeners: {
						click: {fn:function(){
							if (Ext.getCmp('selectLtspDropDownID').getValue() == "") {
		                        Ext.example.msg("Select LTSP");
		                        Ext.getCmp('selectLtspDropDownID').focus();
		                        return;
	                    	}
			                store.load({
			                params: {
			                   systemId: Ext.getCmp('selectLtspDropDownID').getValue()
			                }
			            });
                       	   
        			   }
        			}
        		}
        	}
        ]
});  

var innerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: false,
    height: 140,
    width: 340,
    frame: true,
    id: 'innerPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 5
    },
    items: [{
        xtype: 'fieldset',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        height: 120,
        width: 335,
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
        items: [{height : 40},{
            	xtype: 'label',
            	text: '*',
            	cls: 'mandatoryfield',
            	id: 'mandId1'
        	},{
                xtype: 'label',
                text: 'Name :',
                cls: 'labelstyle',
                id: 'UnitNoid'
            },  {
				xtype: 'textfield',
				//cls: 'selectstylePerfect',
				width:200,
				height:25,
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '',
				labelSeparator: '',
				id: 'nameId'
			},{},
            {height : 30},{
            	xtype: 'label',
            	text: '*',
            	cls: 'mandatoryfield',
            	id: 'mandId2'
        	},{
                xtype: 'label',
                text: 'Value :',
                cls: 'labelstyle',
                id: 'labelclintId'
            },	{
				xtype: 'textfield',
				//cls: 'selectstylePerfect',
				width:200,
				height:25,
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '',
				labelSeparator: '',
				id: 'valueId'
			}
            ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 30,
    width: 340,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
					if (Ext.getCmp('selectLtspDropDownID').getValue() == "") {
                        Ext.example.msg("Select LTSP");
                        Ext.getCmp('selectLtspDropDownID').focus();
                        return;
                   	}                
                
                    if (Ext.getCmp('nameId').getValue() == "") {
                        Ext.example.msg("Enter name");
                        Ext.getCmp('nameId').focus();
                        return;
                    }
                    if (Ext.getCmp('valueId').getValue() == "") {
                        Ext.example.msg("Enter value");
                        Ext.getCmp('valueId').focus();
                        return;
                    }
                    var gridNameIndex;
                    var gridValueIndex;
                    if(buttonValue=='Modify'){
                    	var selected = grid.getSelectionModel().getSelected();
    				 	gridNameIndex=selected.get('nameindex'); 
    				 	gridValueIndex= selected.get('valueindex');
                    }

           		     OuterPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=addSandMiningGeneralSettingsDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            systemId:Ext.getCmp('selectLtspDropDownID').getValue(),
                            //custId: Ext.getCmp('clientId').getValue(),
                            name: Ext.getCmp('nameId').getValue(),
                            value: Ext.getCmp('valueId').getValue(),
                            gridNameIndex:gridNameIndex,
                            gridValueIndex:gridValueIndex
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('nameId').reset();
			                Ext.getCmp('valueId').reset();
			                
                            myWin.hide();
                            OuterPanelWindow.getEl().unmask();
                            store.load({
				                params: {
				                   systemId: Ext.getCmp('selectLtspDropDownID').getValue()
				                }
			            	});
                            
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
                        }
                    });  
                    //  }
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
			                Ext.getCmp('nameId').reset();
			                Ext.getCmp('valueId').reset();
			               
                    myWin.hide();
                }
            }
        }
    }]
});

var OuterPanelWindow = new Ext.Panel({
    width: 360,
    height: 250,
    standardSubmit: true,
    frame: false,
    items: [innerPanel,innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    width: 360,
    height: 250,
    id: 'myWin',
    items: [OuterPanelWindow]
});

function addRecord() {
	
      buttonValue="Add";
      titelForInnerPanel = 'Add Details';
      
      Ext.getCmp('nameId').reset();
	  Ext.getCmp('valueId').reset();
      
      myWin.setPosition(500, 80);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
}

function modifyData()
{

	if(Ext.getCmp('selectLtspDropDownID').getValue()=="")
	   {
	         Ext.example.msg("Select LTSP");
	         return;
	   }
	             
	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
       
     Ext.getCmp('nameId').reset();
	 Ext.getCmp('valueId').reset(); 
       
     buttonValue = 'Modify';  
     var selected = grid.getSelectionModel().getSelected();
     Ext.getCmp('nameId').setValue(selected.get('nameindex'));  
     Ext.getCmp('valueId').setValue(selected.get('valueindex'));  
     
     titelForInnerPanel = 'Modify Details';
     myWin.setPosition(500, 80);
     myWin.setTitle(titelForInnerPanel);
     myWin.show();
  }

function deleteData()
{

	if(Ext.getCmp('selectLtspDropDownID').getValue()=="")
	   {
	         Ext.example.msg("Select LTSP");
	         return;
	   }

	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
     buttonValue = 'Delete';  
     var json = '';
     var selected = grid.getSelectionModel().getSelected();
     var gridNameIndex = selected.get('nameindex');
     var gridValueIndex = selected.get('valueindex');
   
    Ext.MessageBox.confirm('Confirm', "Are You Sure Want To Delete Data. Continue...?", function(btn) {
    	if (btn == 'yes') {
    	importPanelWindow.getEl().mask();
    	Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=deleteGeneralSettingsData',
	             method: 'POST',
	             params: { 
	             	 buttonValue : buttonValue,
	             	 systemId:Ext.getCmp('selectLtspDropDownID').getValue(),
	              	 gridNameIndex : gridNameIndex,
	              	 gridValueIndex:gridValueIndex
	             },
	             success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     store.load({
				                params: {
				                   systemId: Ext.getCmp('selectLtspDropDownID').getValue()
				                }
			            	});
                     importPanelWindow.getEl().unmask();
	              }, 
	              failure: function(){
	                    
                         importPanelWindow.getEl().unmask();
                         json = '';
	                 } // END OF FAILURE 
	         });
         }
    });
}


 var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'sandGeneralSettingsStore',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'ltspNameindex'
    }, {
        name: 'clientindex'
    }, {
        name: 'nameindex'
    }, {
        name: 'valueindex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getSandMiningGeneralSettingsDetails',
        method: 'POST'
    }),
    storeId: 'sandGeneralSettingsStoreId',
    reader: reader
});   
    
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'ltspNameindex'
    }, {
        type: 'string',
        dataIndex: 'clientindex'
    }, {
        type: 'string',
        dataIndex: 'nameindex'
    }, {
        type: 'string',
        dataIndex: 'valueindex'
    }
    ]
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
            dataIndex: 'ltspNameindex',
            header: "<span style=font-weight:bold;>LTSP Name</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'clientindex',
            hidden: true,
            header: "<span style=font-weight:bold;>Client Name</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'nameindex',
            header: "<span style=font-weight:bold;> Name</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'valueindex',
            header: "<span style=font-weight:bold;>Value</span>",
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
var grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 60, 420, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, 'Modify', true, 'Delete');    
    
 var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: true,
    layout: 'column',
    //width: screen.width - 50,
    height:500,
    layoutConfig: {
        columns: 1
    },
    items: [innerPanelForUnitDetails,grid]
});   
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 720000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Sand Mining General Setting',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        width : screen.width-50,
        layout: 'table',
        height:550,
        cls: 'outerpanel',
        items: [importPanelWindow]      
    });
    
});   
</script>   
</body>
</html>