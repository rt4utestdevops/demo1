<%@ page language="java" import="java.util.*,t4u.beans.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>

  
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


<style>
.importimagepanelPmr
{
	width:100%;
	height:150px;
	background-image: url(/ApplicationImages/ExcelImportFormats/AssetCanReg.png) !important;
	background-repeat: no-repeat
}
.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
}
.x-panel-tl {
	border-bottom: 0px solid !important;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
    cursor: pointer;
}
.x-form-file-wrap .x-form-file-btn {
	position: absolute;
	right: 0;
	z-index: 1;
}
.x-form-file-wrap .x-form-file-text {
    position: absolute;
    left: 0;
    z-index: 3;
    color: #777;
}
#ext-gen32{
   width: 550px  !important;
}

</style>

  <table id="tableID" style="width:100%;height:90%;background-color:#DFE8F6;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="90%">
  <td height="90%">
  <div id="content"></div>
  </td>
  </tr>
</table>

	<script>

	var outerPanel;
	var ctsb;
	var exportDataType = "int,String,string,string,string";
	var jspName ="Asset Cancel Registration";	
	var buttonValue;
	var unitResponseImportData;
	var start_time ;

 var ltspNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=getLTSPNames',
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
                   Ext.getCmp('clientId').setValue('');   
                   fp.getForm().reset();   
                   importgrid.store.clearData();
    			   importgrid.view.refresh();   
                }
            }
        }
    });
	
	 var clientNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=getClientNameswrtSystem',
        root: 'clientNameList',
        autoLoad: false,
        fields: ['clientid', 'clientname']
    });

    var clientNameSelect = new Ext.form.ComboBox({
        fieldLabel: '',
        standardSubmit: true,
        width: 180,
        selectOnFocus: true,
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
                   fp.getForm().reset();   
                   importgrid.store.clearData();
    			   importgrid.view.refresh();   
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS		
    });

	
	
var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true, 
    width: '80%',
    height:30,
    frame: false,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 6
    },
     items: [{
                xtype: 'label',
                text: 'Select LTSP :',
                cls: 'labelstyle',
                id: 'UnitNoid'
            },  selectLtspDropDown,{
                xtype: 'label',              
                cls: 'mandatoryfield',
                id: 'ManufaturerId'
            }, {
                xtype: 'label',
                text: 'Select Client :',
                cls: 'labelstyle',
                id: 'labelManufaturerId'
            },	clientNameSelect,
             {
                xtype: 'label',                
                cls: 'mandatoryfield',
                id: 'UnitTypeId'
            }
        ]
});

function clearInputData() {
    importgrid.store.clearData();
    importgrid.view.refresh();
}

var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: false,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 80,
    defaults: {
        anchor: '40%',
        allowBlank: false,
        msgTarget: 'side'
    },
    items: [{
        xtype: 'fileuploadfield',
        id: 'filePath',
        width: 40,
        emptyText: 'Browse',
        fieldLabel: 'Choose File',        
        name: 'filePath',
        buttonText: 'Browse',
     	buttonCfg: {
            iconCls: 'browsebutton'
        },
        listeners: {

            fileselected: {
                fn: function () {
                    var filePath = document.getElementById('filePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "xls" || imgext == "xlsx") {

                    } else {
                        Ext.MessageBox.show({
                            msg: 'Please select only .xls or .xlsx files',
                            buttons: Ext.MessageBox.OK
                        });
                        Ext.getCmp('filePath').setValue("");
                        return;
                    }
                }
            }

        }
    }],
    buttons: [{
        text: 'Upload',
        iconCls : 'uploadbutton',
        handler: function () {
        
         		if (Ext.getCmp('selectLtspDropDownID').getValue() == "") {
                    Ext.example.msg("Please select a LTSP");
                        return;
                    } 
                  
                if (Ext.getCmp('clientId').getValue() == "") {
                    Ext.example.msg("Please select customer Name");
                        return;
                    }
                    
             	var filePath = document.getElementById('filePath').value;
             	if (filePath == "Browse") {
                    Ext.example.msg("Please select Excel file");
                        return;
                    }
                
            if (fp.getForm().isValid()) {                

                var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                if (imgext == "xls" || imgext == "xlsx") {
					clearInputData();
                } else {
                    Ext.MessageBox.show({
                        msg: 'Please select only .xls or .xlsx files',
                        buttons: Ext.MessageBox.OK
                    });
                    Ext.getCmp('filePath').setValue("");
                    return;
                }
                start_time = new Date().getTime();
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=importUnitDetailsExcel',
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    params: {
                           ltsp:Ext.getCmp('selectLtspDropDownID').getValue(),
						   client:Ext.getCmp('clientId').getValue()                        
                        },
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=getImportAssetDetails',
                        method: 'POST',
                        params: {
                            assetImportResponse: action.response.responseText                           
                        },
                        success: function (response, options) {
                        console.log('Upload validation Time=='+(new Date().getTime()-start_time));
                            unitResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            importstore.loadData(unitResponseImportData);
                            
                        },
                        failure: function () {
                            Ext.example.msg("Error");
                        }
                    });
                        
                    },
                    failure: function () {
                        Ext.example.msg("Please Upload The Standard Format");
                    }
                });
            }
        }
    },{
		text: 'GetStandardFormat',
		iconCls : 'downloadbutton',
	    handler : function(){
	    Ext.getCmp('filePath').setValue("Upload the Standard File");
	    fp.getForm().submit({
	    	url:'<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=openStandardFileFormats'
	    	});
		}	   
	}]
});

 function closeImportWin(){
		fp.getForm().reset();          
		clearInputData();
   }

function saveDate(){

var unitValidCount = 0;
var totalUnitcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importstatusindex'];
        if (checkvalidOrInvalid == 'Valid') {
            unitValidCount++;
        }
    }
		if(unitValidCount>50){
		Ext.example.msg('You Can Update Only 50 Rows of Valid Data');
		return;
		}
	var saveJson = getJsonOfStore(importstore);
	Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + unitValidCount + ' valid transaction to be saved out of ' + totalUnitcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
    
		if (saveJson != '[]' && unitValidCount>0) {
		outerPanel.getEl().mask();
		Ext.MessageBox.wait("Processing.....", 'Please Wait....'); 
		start_time = new Date().getTime();
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=saveImportAssetDetails',
               method: 'POST',
               params: {
                        unitDataSaveParam: saveJson,
                        ltsp:Ext.getCmp('selectLtspDropDownID').getValue(),
						ltspName:Ext.getCmp('selectLtspDropDownID').getRawValue(),
						client:Ext.getCmp('clientId').getValue(),
						clientName:Ext.getCmp('clientId').getRawValue()
               },
               success: function (response, options) {
               console.log('total time to can and reg =='+(new Date().getTime()-start_time));
               			var message = response.responseText;               			
              			Ext.example.msg(message);
              			outerPanel.getEl().unmask();
              			Ext.MessageBox.hide();
              			 Ext.MessageBox.show({
                            msg: '<b>'+message+'</b>',                           
                            buttons: Ext.MessageBox.OK
                        });
               },
               failure: function () {
               console.log('Upload validation Time=='+(new Date().getTime()-start_time));
                           Ext.example.msg("Error");
                           outerPanel.getEl().unmask();
                        Ext.MessageBox.hide();
                         Ext.MessageBox.show({
                            msg: 'Error When Updating',
                            buttons: Ext.MessageBox.OK
                        });
                        }
               });
               clearInputData();
               fp.getForm().reset();              
               
           }else{
           Ext.MessageBox.show({
                        msg: "You don't have any Valid Information to Proceed",
                        buttons: Ext.MessageBox.OK
                    });
           }
           }
           }
          });
}

function getJsonOfStore(importstore) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = importstore.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);

    return jsonDataEncode;
}

var excelImageFormat = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'excelMaster',
    height: 140,
    width: '100%',
    frame: false,
    items: [{
        cls: 'importimagepanelPmr'
    }]
});


var reader = new Ext.data.JsonReader({
    root: 'UnitDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importOldAssetNoindex'
    }, {
        name: 'importnewAssetNoindex'
    },{
        name: 'importstatusindex'
    }, {
        name: 'importremarksindex'
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VehicleDeletionReregistration.do?param=getImportUnitDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: reader
});


var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'importunitnoindex'
        }, {
            dataIndex: 'importOldAssetNoindex',
            type: 'String'
        }, {
            dataIndex: 'importnewAssetNoindex',
            type: 'string'
        },{
            dataIndex: 'importstatusindex',
            type: 'string'
        }, {
            dataIndex: 'importremarksindex',
            type: 'string'
        }

    ]
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Old Asset Number</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importOldAssetNoindex'
        }, {
            header: "<span style=font-weight:bold;>New Asset Number</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importnewAssetNoindex'
        }, {
            header: "<span style=font-weight:bold;>ValidStatus</span>",
            hidden: false,
            width: 50,
            sortable: true,
            dataIndex: 'importstatusindex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;>Remarks</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importremarksindex',
            filter: {
                type: 'String'
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

function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
}
//*******************************grid**************************///
importgrid = getGrid('', 'NoRecordsFound', importstore, screen.width - 260, 250, 6, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'delete',false,'',false,'',false,'',false,'',false,'',false,'Clear Filter',true,'Save',true,'Clear',false,'Close');	

var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: true,
    layout: 'column',
    width: screen.width - 50,
    height:500,
    layoutConfig: {
        columns: 1
    },
    items: [innerPanelForUnitDetails,fp,excelImageFormat,importgrid]
});

Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 720000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Vehicle Re-Registration',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        height:550,
        cls: 'outerpanel',
        items: [importPanelWindow]      
    });
});
</script>   

</html>