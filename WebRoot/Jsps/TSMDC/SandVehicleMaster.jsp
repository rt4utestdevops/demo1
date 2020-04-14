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
 		<title>Sand Vehicle Master</title>		
    
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
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
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
		</style>
	 <%}%>	
   <script>
   
var outerPanel;
var ctsb;
var jspName = "sandVehicleMasterDetails";
var exportDataType = "int,int,string,string,string,string,number,string,string,date";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;
var Id=0;
var vehicleResponseImportData;

var vehicleNoStore= new Ext.data.JsonStore({
       url:'<%=request.getContextPath()%>/SandTSMDCAction.do?param=getVehicleNoList',
                   id:'VehicleNoId',
                   root: 'VehicleStoreRoot',
                   autoLoad: true,
                   fields: ['Id','VehicleNo','ChassisNo','OwnerName','VehicleCapacity']
    });

var vehicleNoCombo = new Ext.form.ComboBox({
    store: vehicleNoStore,
    id: 'vehicleNocomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Vehicle No.',
    blankText: 'Select Vehicle No.',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'VehicleNo',
    displayField: 'VehicleNo',
    cls: 'selectstylePerfect',
    listeners: {
      select: {
          fn: function() {
	
 					var  permitNo=Ext.getCmp('vehicleNocomboId').getValue();
                    var row = vehicleNoStore.find('VehicleNo',permitNo);
                    var rec = vehicleNoStore.getAt(row);
                    var ChassisNo=rec.data['ChassisNo'];
                    var OwnerName=rec.data['OwnerName'];
                    var VehicleCapacity=rec.data['VehicleCapacity'];
                    Id=rec.data['Id'];
                    Ext.getCmp('chassisNoId').setValue(ChassisNo);
                    Ext.getCmp('ownerNameId').setValue(OwnerName);
                    Ext.getCmp('vehicleCapacityId').setValue(VehicleCapacity);
                    
              }
          }
      }
});

var innerPanelForSandVehicleMasterDetails1 = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 300,
    width: '100%',
    frame: true,
    id: 'innerPanelForVehicleMasterId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
	items: [{width : 20},{},{},{height : 30},
			{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryId1'
	        },{
	            xtype: 'label',
	            text: 'Vehicle No ' + ' :',
	            cls: 'labelstyle',
	            id: 'vehicleLabelId'
	        }, 
	        vehicleNoCombo,
	        {height : 40},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryFieldId2'
        	}, {
	            xtype: 'label',
	            text: 'Chassis No' + ' :',
	            cls: 'labelstyle',
	            id: 'chassisNoLabelId',
	            readOnly: true
	       	 },  
	       	 {
	        	xtype: 'textfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'chassisNoId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Chassis Number',
	            blankText: 'Enter Chassis Number',
	            selectOnFocus: true,
	            allowBlank: false,
	          }, {height : 40},
	          {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryField3'
	        } ,
        	{ 
        		xtype: 'label',
        	  	text: 'Owner Name' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'fuelLtrId',
        	 },
        	 {
	        	xtype: 'textfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'ownerNameId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Owner Name',
	            blankText: 'Enter Owner Name',
	            selectOnFocus: true
	           
            },{height : 40},
            {
            	xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryField4'
            },
            {	
            	xtype: 'label',
        	  	text: 'Vehicle Capacity' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'vehicleCapacityLabelId',
        	  	
            },
            {	
            	xtype: 'textfield',
	            cls: 'selectstylePerfect',
	            id: 'vehicleCapacityId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Vehicle Capacity',
	            blankText: 'Enter Vehicle Capacity',
	            selectOnFocus: true
	            
            },
            {
            	xtype: 'label',
        	  	text: '',
        	  	cls: 'labelstyle'
        	},
            {
            	xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatoryField5'
            },
            {
            	xtype: 'label',
        	  	text: 'Tare Weight' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'tareWeightLabelId'
            }, 
            {
            	xtype: 'numberfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'TareWeightId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Tare Weight',
	            blankText: 'Enter Tare Weight',
	            selectOnFocus: true,
	            allowBlank: false,
	            autoCreate : { 
				 tag: "input", 
				 maxlength : 10, 
				 type: "text", 
				 size: "20", 
				 autocomplete: "off"
				}
            }, 
            {
            	xtype: 'label',
        	  	text: 'kg',
        	  	cls: 'labelstyle'
			},
            {
            	xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatoryField6'
            },
            {
            	xtype: 'label',
        	  	text: 'RFID NO' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'rfidLabelId'
            }, {
            	xtype: 'textfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'RFIDNoId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter RFID No',
	            blankText: 'Enter RFID No',
	            selectOnFocus: true,
	            allowBlank: false,
            }
	        ]
		});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: '100%',
    frame: true,
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
                   
                    if (Ext.getCmp('vehicleNocomboId').getValue() == "") {
                 	   Ext.example.msg("Select Vehicle Number");
                        return;
                    }
                    
                    if(Ext.getCmp('TareWeightId').getValue()==""){
                    	Ext.example.msg("Enter Tare Weight");
                    	return;
                    }
                    
                     if(Ext.getCmp('RFIDNoId').getValue()==""){
                    	Ext.example.msg("Enter RFID No.");
                    	return;
                    }
                    
                    sandVehicleMasterOuterPanelWindow.getEl().mask();  
                    if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            Id = selected.get('IdIndex');
                          }  
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=AddorModifyVehicleDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                Id:Id,
                                vehicleNo: Ext.getCmp('vehicleNocomboId').getValue(),
                                tareWeight: Ext.getCmp('TareWeightId').getValue(),
                                rfidNo: Ext.getCmp('RFIDNoId').getValue(),
                                chassisNo: Ext.getCmp('chassisNoId').getValue(),
                                ownerName: Ext.getCmp('ownerNameId').getValue(),
                                vehicleCapacity: Ext.getCmp('vehicleCapacityId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('vehicleNocomboId').reset();
                                Ext.getCmp('chassisNoId').reset();
                                Ext.getCmp('ownerNameId').reset();
                                Ext.getCmp('vehicleCapacityId').reset();
                                Ext.getCmp('TareWeightId').reset();
                                Ext.getCmp('RFIDNoId').reset();
                                
                                myWin.hide();
                                sandVehicleMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                    				params: {
                        				jspName : jspName
                    				}
               					 });
               					 vehicleNoStore.reload();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                Ext.getCmp('vehicleNocomboId').reset();
                                Ext.getCmp('chassisNoId').reset();
                                Ext.getCmp('ownerNameId').reset();
                                Ext.getCmp('vehicleCapacityId').reset();
                                Ext.getCmp('TareWeightId').reset();
                                Ext.getCmp('RFIDNoId').reset();
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
                 Ext.getCmp('vehicleNocomboId').reset();
                 Ext.getCmp('chassisNoId').reset();
                 Ext.getCmp('ownerNameId').reset();
                 Ext.getCmp('vehicleCapacityId').reset();
                 Ext.getCmp('TareWeightId').reset();
                 Ext.getCmp('RFIDNoId').reset();
                 myWin.hide();
                }
            }
        }
    }]
});

var sandVehicleMasterOuterPanelWindow = new Ext.Panel({
    width: 485,
    height: 400,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForSandVehicleMasterDetails1,innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 420,
    width: 500,
    id: 'myWin',
    items: [sandVehicleMasterOuterPanelWindow]
});

function addRecord() {

    
    buttonValue = 'Add';
    titelForInnerPanel = 'Add Vehicle Details';
  
    myWin.setPosition(450, 100);
    myWin.show();
    //  myWin.setHeight(350);
     Ext.getCmp('vehicleNocomboId').reset();
     Ext.getCmp('chassisNoId').reset();
     Ext.getCmp('ownerNameId').reset();
     Ext.getCmp('vehicleCapacityId').reset();
     Ext.getCmp('TareWeightId').reset();
     Ext.getCmp('RFIDNoId').reset();
     Ext.getCmp('vehicleNocomboId').enable();
     Ext.getCmp('chassisNoId').enable();
     Ext.getCmp('ownerNameId').enable();
     Ext.getCmp('vehicleCapacityId').enable();
 	
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
    titelForInnerPanel = 'Modify Vehicle Details';
    myWin.setPosition(450, 100);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('vehicleNocomboId').setValue(selected.get('vehicleNoIndex')); 
    Ext.getCmp('vehicleNocomboId').disable();
    Ext.getCmp('chassisNoId').setValue(selected.get('chassisNoIndex')); 
    Ext.getCmp('chassisNoId').disable();
    Ext.getCmp('ownerNameId').setValue(selected.get('ownerNameIndex')); 
    Ext.getCmp('ownerNameId').disable();
    Ext.getCmp('vehicleCapacityId').setValue(selected.get('vehicleCapacityIndex')); 
    Ext.getCmp('vehicleCapacityId').disable();
    Ext.getCmp('TareWeightId').setValue(selected.get('tareWeightIndex')); 
    Ext.getCmp('RFIDNoId').setValue(selected.get('RFIDNoIndex')); 
    
}

//Excel import start here

function clearInputData() {
    importgrid.store.clearData();
    importgrid.view.refresh();
}

function importExcelData() {
    importButton = "import";
    importTitle = 'Vehicle Import Details';
    importWin.show();
    importWin.setTitle(importTitle);
}

var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: true,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 90,
  //  defaults: {
  //      anchor: '95%',
  //      allowBlank: false,
  //      msgTarget: 'side'
  //  },
    items: [{
        xtype: 'fileuploadfield',
        id: 'filePath',
        width: 400,
        emptyText: 'Browse',
        fieldLabel: 'ChooseFile',
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
            if (fp.getForm().isValid()) {
                var filePath = document.getElementById('filePath').value;

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
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=importVehicleDetailsExcel',
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=getImportVehicleDetails',
                        method: 'POST',
                        params: {
                            vehicleImportResponse: action.response.responseText
                        },
                        success: function (response, options) {
                            vehicleResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            importstore.loadData(vehicleResponseImportData);
                            
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
		text: 'Get Standard Format',
		iconCls : 'downloadbutton',
	    handler : function(){
	    Ext.getCmp('filePath').setValue("Upload the Standard File");
	    fp.getForm().submit({
	    	url:'<%=request.getContextPath()%>/SandTSMDCAction.do?param=openStandardFileFormats'
	    	});
		}	   
	}]
});
function closeImportWin(){
fp.getForm().reset();
            importWin.hide();
			clearInputData();
}
function saveDate(){

var validCount = 0;
var totalUnitcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importstatusindex'];
        if (checkvalidOrInvalid == 'Valid') {
            validCount++;
        }
    }

	var saveJson = getJsonOfStore(importstore);
	Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + validCount + ' valid transaction to be saved out of ' + totalUnitcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
    
		if (saveJson != '[]' && validCount>0) {
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=saveImportVehicleDetails',
               method: 'POST',
               params: {
                            vehicleDataSaveParam: saveJson
               },
               success: function (response, options) {
               			var message = response.responseText;
               			store.reload({
                        params: {
					    jspName:jspName
                         }
              			});
              			Ext.example.msg(message);
               },
               failure: function () {
                           Ext.example.msg("Error");
                        }
               });
               clearInputData();
               fp.getForm().reset();
               importWin.hide();
               
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

//************************* store configs
//***************************jsonreader
var reader = new Ext.data.JsonReader({
    root: 'VehicleDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importVehicleNoindex'
    }, {
        name: 'importChassisNoindex'
    },{
        name: 'importOwnerNameindex'
    }, {
        name: 'importVehicleCapacityindex'
    }, {
        name: 'importstatusindex'
    }, {
        name: 'importremarksindex'
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getImportUnitDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: reader
});
//****************************grid filters
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'importslnoIndex'
        }, {
            dataIndex: 'importVehicleNoindex',
            type: 'String'
        }, {
            dataIndex: 'importChassisNoindex',
            type: 'string'
        },{
            dataIndex: 'importOwnerNameindex',
            type: 'string'
        }, {
            dataIndex: 'importVehicleCapacityindex',
            type: 'string'
        }, {
            dataIndex: 'importstatusindex',
            type: 'string'
        }, {
            dataIndex: 'importremarksindex',
            type: 'string'
        }

    ]
});
//****************column Model Config
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
        },
        {
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importVehicleNoindex'
        }, {
            header: "<span style=font-weight:bold;>Chassis No</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importChassisNoindex'
        }, {
            header: "<span style=font-weight:bold;>Owner Name</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importOwnerNameindex'
        },

        {
            header: "<span style=font-weight:bold;>Vehicle Capacity</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importVehicleCapacityindex',
            filter: {
                type: 'String'
            }
        },  {
            header: "<span style=font-weight:bold;>Valid Status</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importstatusindex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;>Remarks</span>",
            hidden: false,
            width: 200,
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
importgrid = getGrid('', 'No Records Found', importstore, 825, 198, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete',false,'',false,'',false,'',false,'',false,'',false,'',true,'Save',true,'Clear',true,'Close');	

//end grid

var excelImageFormat = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'excelMaster',

    height: 170,
    width: '100%',
    frame: false,
    items: [{
        cls: 'importimagepanel'
    }]
});

var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [fp,importgrid]
});

importWin = new Ext.Window({
    title: 'Vehicle Import Details',
    width: 900,
    height:483,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    id: 'importWin',
    items: [importPanelWindow]
});

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
 importWin.setHeight(505);
importWin.setWidth(840);
<%}%>

//excel import ends here//


var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'sandVehicleMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'IdIndex'
    },{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNoIndex'
    }, {
        name: 'chassisNoIndex'
    }, {
        name: 'ownerNameIndex'
    }, {
        name: 'vehicleCapacityIndex'
    }, {
        name: 'tareWeightIndex'
    }, {
        name: 'RFIDNoIndex'
    }, {
        name: 'updatedByIndex'
    }, {
        name: 'updatedDateIndex'
  	 }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=getSandVehicleMasterDetails',
        method: 'POST'
    }),
    storeId: 'sandVehicleMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'int',
        dataIndex: 'IdIndex'
    }, {
        type: 'int',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNoIndex'
    }, {
        type: 'string',
        dataIndex: 'chassisNoIndex'
    }, {
        type: 'string',
        dataIndex: 'ownerNameIndex'
    },  {
        type: 'string',
        dataIndex: 'vehicleCapacityIndex'
    },{
        type: 'int',
        dataIndex: 'tareWeightIndex'
    },{
        type: 'string',
        dataIndex: 'RFIDNoIndex'
    },{
        type: 'string',
        dataIndex: 'updatedByIndex'
    },{
        type: 'date',
        dataIndex: 'updatedDateIndex'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'IdIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>Id</span>",
            filter: {
                type: 'int'
            }
        },{
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            dataIndex: 'vehicleNoIndex',
            //hidden: true,
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Chassis No</span>",
            dataIndex: 'chassisNoIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Owner Name</span>",
            dataIndex: 'ownerNameIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Vehicle Capacity </span>",
            dataIndex: 'vehicleCapacityIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
        	header: "<span style=font-weight:bold;>Tare Weight (kg)</span>",
            dataIndex: 'tareWeightIndex',
            width: 50,
            filter: {
                type: 'number'
            }
        },{	
        	header: "<span style=font-weight:bold;>RFID No</span>",
        	dataIndex: 'RFIDNoIndex',
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
        		type: 'date'
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

grid = getGrid('', 'No Records Found', store, screen.width - 40, 440, 15, filters, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add', true, 'Modify', false, 'Delete',false,'',false,'',false,'',false,'',false,'',true,'Import Excel');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Sand Vehicle Master',
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