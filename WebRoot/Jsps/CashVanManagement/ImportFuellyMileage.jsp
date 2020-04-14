<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	String currency = cf.getCurrency(systemId);
	//System.out.println("currency-->"+currency);
	
	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Fuel_Import_Title");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Select_Asset_Number");
	tobeConverted.add("Date");
	tobeConverted.add("Odometer");
	tobeConverted.add("Fuel");
	tobeConverted.add("Amount");
	tobeConverted.add("Slip_No");
	tobeConverted.add("Fuel_Station_Name");
	tobeConverted.add("Valid");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Petro_Card_Number");
		
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);
	
	String fuelImportTitle = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	String SlNo = convertedWords.get(3);
	String AssetNumber = convertedWords.get(4);
	String SelectAssetNumber = convertedWords.get(5);
	String Date = convertedWords.get(6);
	String Odometer = convertedWords.get(7);
	String Fuel = convertedWords.get(8);
	String Amount = convertedWords.get(9);
	String SlipNo = convertedWords.get(10);
	String FuelStationName = convertedWords.get(11);	
	String Valid = convertedWords.get(12);
	String NoRecordsFound = convertedWords.get(13);
	String PetroCardNumber = convertedWords.get(14);
	String OK = "OK";
	String Cancel = "Cancel";
	String FuelInformation = "Fuel Mileage Information";
	String SelectDate= "Select Date";
	String EnterOdometer = "Enter Odometer";
	String EnterFuel = "Enter Refuel";
	String EnterAmount = "Enter Refuel Amount";
	String EnterSlipNo = "Enter Slip Number";
	String EnterFuelCompanyName = "Enter Fuel Company Name";
	String EnterPetroCardNumber = "Enter Petro Card";
	String Add = "Add";
	String Validate = "Validate";
	String Save = "Save";
	String ImportFuel = "Import Fuel";
	String ChooseFile = "Choose File";
	String Upload = "Upload";
	String Close = "Close";
	String Clear = "Clear";
	String GrandTotal="Total Amount";
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title><%=fuelImportTitle%></title>	
		<meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8" />
		<style type="text/css">
			.x-panel-tc
			{
				background-image: linear-gradient(#FF0000,#FFFFFF);
			}
			.x-form-file-wrap {
    position: relative;
    height: 22px;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
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
	</head>	    
  
  	<body height="100%">
  	    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %> 
		<style>
			.ext-strict .x-form-text {
				height: 15px !important;
			}
		</style>		
   	<script>
var outerPanel;
var ctsb;
var buttonValue;
var title;
var myWin;
var dtprev;
var count = 0;
var rows = "";
var defaultData;
var temp;
var importTitle;
var importWin;
var importButton;
var currency = '<%=currency%>';
var tot;

var petroCardNumberStore = new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/FuelMileage.do?param=getPetroCardNumber',
	id : 'PetroCardId',
	root: 'PetroCardRoot',
	autoLoad: false,
	remoteSort : true,
	fields : ['PetroCardNumber']
});

var vehiclestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getVehicleNo',
    id: 'VehicleStoreId',
    root: 'VehicleNoRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['VehicleNo']
});

var vehiclecombo = new Ext.form.ComboBox({
    store: vehiclestore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectAssetNumber%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'VehicleNo',
    displayField: 'VehicleNo',
    cls: 'selectstyle',
    listeners: {
        select: {
            fn: function () {
            		vehicleNo =  Ext.getCmp('vehiclecomboId').getValue();
					petroCardNumberStore.load({
						params:{
							VehicleNo : vehicleNo
						},
						callback: function(){
							var rec = petroCardNumberStore.getAt(0);
							if(rec != null){
								Ext.getCmp('petroCardNumberId').setValue(rec.data['PetroCardNumber']);
							}						
						}
					});
            }
        }
    }
});

var customercombostore = new Ext.data.JsonStore({
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
                vehiclestore.load({
                    params: {
                        CustId: <%= customerId %> ,
                        LTSPId: <%= systemId %>
                    }
                });
            }
        }
    }
});

var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomer%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'CustId',
    displayField: 'CustName',
    cls: 'selectstyle',
    listeners: {
        select: {
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                importGrid.store.clearData();
                importGrid.view.refresh();
                vehiclestore.load({
                    params: {
                        CustId: custId,
                        LTSPId: <%= systemId %>
                    }
                });
            }
        }
    }
});

var innerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 300,
    width: '100%',
    frame: true,
    id: 'addFuel',
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=FuelInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'fuelmileagepanelid',
        width: 500,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryassetNumber'
            }, {
                xtype: 'label',
                text: '<%=AssetNumber%>  :',
                cls: 'labelstyle',
                id: 'assetNumberLabelId'
            },
            vehiclecombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydateTime'
            }, {
                xtype: 'label',
                text: '<%=Date%>  :',
                cls: 'labelstyle',
                id: 'dateTimeLabelId'
            }, {
                xtype: 'datefield',
                cls: 'selectstyle',
                width: 185,
                format: getDateTimeFormat(),
                emptyText: '<%=SelectDate%>',
                allowBlank: false,
                blankText: '<%=SelectDate%>',
                id: 'dateTime',
                value: dtprev,
                vtype: 'daterange',
                maxValue: new Date()
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryodometer'
            }, {
                xtype: 'label',
                text: '<%=Odometer%>' + '  :',
                cls: 'labelstyle',
                id: 'odometerLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: false,
                allowNegative: false,
                cls: 'textrnumberstyle',
                emptyText: '<%=EnterOdometer%>',
                blankText: '<%=EnterOdometer%>',
                maxLength: 10,
                allowBlank: false,
                id: 'odometer'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryfuel'
            }, {
                xtype: 'label',
                text: '<%=Fuel%>' + '  :',
                cls: 'labelstyle',
                id: 'fuelLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'textrnumberstyle',
                emptyText: '<%=EnterFuel%>',
                blankText: '<%=EnterFuel%>',
                maxLength: 20,
                allowBlank: false,
                id: 'fuel'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAmount'
            }, {
                xtype: 'label',
                text: '<%=Amount%>' + '  :',
                cls: 'labelstyle',
                id: 'amountLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'textrnumberstyle',
                emptyText: '<%=EnterAmount%>',
                blankText: '<%=EnterAmount%>',
                allowBlank: false,
                maxLength: 20,
                id: 'amount'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorySlipNo'
            }, {
                xtype: 'label',
                text: '<%=SlipNo%>' + '  :',
                cls: 'labelstyle',
                id: 'slipNoLableId'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                emptyText: '<%=EnterSlipNo%>',
                blankText: '<%=EnterSlipNo%>',
                allowBlank: true,
                id: 'slipNumber',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryFuelStationName'
            }, {
                xtype: 'label',
                text: '<%=FuelStationName%>' + '  :',
                cls: 'labelstyle',
                id: 'fuelStationNameLableId'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                emptyText: '<%=EnterSlipNo%>',
                blankText: '<%=EnterSlipNo%>',
                allowBlank: true,
                id: 'fuelCompanyName',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPetroCardNumber'
            }, {
                xtype: 'label',
                text: '<%=PetroCardNumber%>' + '  :',
                cls: 'labelstyle',
                id: 'petroCardNumberLableId'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                emptyText: '<%=EnterPetroCardNumber%>',
                blankText: '<%=EnterPetroCardNumber%>',
                allowBlank: true,
                id: 'petroCardNumberId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }
        ]
    }]
});

/****************window static button panel****************************/
var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 280
    }, {
        xtype: 'button',
        text: '<%=OK%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls : 'okbutton',
        width: 80,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectAssetNumber%>");
                        Ext.getCmp('vehiclecomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('dateTime').getValue() == "") {
                        Ext.example.msg("<%=SelectDate%>");
                        Ext.getCmp('dateTime').focus();
                        return;
                    }
                    if (Ext.getCmp('odometer').getValue() == "") {
                        Ext.example.msg("<%=EnterOdometer%>");
                        Ext.getCmp('odometer').focus();
                        return;
                    }
                    if (Ext.getCmp('fuel').getValue() == "") {
                        Ext.example.msg("<%=EnterFuel%>");
                        Ext.getCmp('fuel').focus();
                        return;
                    }
                    if (Ext.getCmp('amount').getValue() == "") {
                        Ext.example.msg("<%=EnterAmount%>");
                        Ext.getCmp('amount').focus();
                        return;
                    }

                    if (innerPanel.getForm().isValid()) {
                        count++;
                        var plant = new plantForImport({
                            slnoIndex: "new" + count,
                            registrationNo: Ext.getCmp('vehiclecomboId').getValue(),
                            date: Ext.getCmp('dateTime').getValue(),
                            odometer: Ext.getCmp('odometer').getValue(),
                            fuel: Ext.getCmp('fuel').getValue(),
                            amount: Ext.getCmp('amount').getValue(),
                            slipNo: Ext.getCmp('slipNumber').getValue(),
                            fuelStationName: Ext.getCmp('fuelCompanyName').getValue(),
                            petroCardNumber: Ext.getCmp('petroCardNumberId').getValue(),
                            validOrInvalid: "YetToValidate",
                        });
						
                        rows = rows + "new" + count + ",";
                        if (importGrid.store.data.length == 0) {
                            Ext.getCmp('grid').view.emptyText = "";
                            Ext.getCmp('grid').view.refresh();
                        }
                        Ext.getCmp('grid').stopEditing();
                        Ext.getCmp('grid').store.insert(0, plant);
                        //getTotals();
                        //importGrid.startEditing(0, 2);
                        if (importGrid.store.data.length == 1) {
                            Ext.getCmp('grid').view.emptyText = '<%=NoRecordsFound%>';
                            Ext.getCmp('grid').view.refresh();
                        }

                        Ext.getCmp('vehiclecomboId').reset();
                        Ext.getCmp('dateTime').reset();
                        Ext.getCmp('odometer').reset();
                        Ext.getCmp('fuel').reset();
                        Ext.getCmp('amount').reset();
                        Ext.getCmp('slipNumber').reset();
                        Ext.getCmp('fuelCompanyName').reset();
                        Ext.getCmp('petroCardNumberId').reset();
                        myWin.hide();
                        //Ajax request
                        
                    } else {
                        Ext.example.msg("Invalid data entered.Please correct");
                      }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function () {
                    Ext.getCmp('vehiclecomboId').reset();
                    Ext.getCmp('dateTime').reset();
                    Ext.getCmp('odometer').reset();
                    Ext.getCmp('fuel').reset();
                    Ext.getCmp('amount').reset();
                    Ext.getCmp('slipNumber').reset();
                    Ext.getCmp('fuelCompanyName').reset();
                    Ext.getCmp('petroCardNumberId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

var outerPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    standardSubmit: true,
    frame: false,
    items: [innerPanel, winButtonPanel]
});

/***********************window for form field****************************/
myWin = new Ext.Window({
    title: title,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: 'mywindow',
    id: 'myWin',
    items: [outerPanelWindow]
});

var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: true,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 70,
    defaults: {
        anchor: '95%',
        allowBlank: false,
        msgTarget: 'side'
    },
    items: [{
        xtype: 'fileuploadfield',
        id: 'filePath',
        width: 60,
        emptyText: 'Browse',
        fieldLabel: '<%=ChooseFile%>',
        name: 'filePath',
        buttonText: '',
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
        text: '<%=Upload%>',
        iconCls : 'uploadbutton',
        handler: function () {
            if (fp.getForm().isValid()) {
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
                var ImportClientId = Ext.getCmp('custcomboId').getValue();
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/FuelMileage.do?param=importFuelMileageExcel&importCustomerId=' + ImportClientId,
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/FuelMileage.do?param=getImportFuelMileage',
                        method: 'POST',
                        params: {
                            fuelImportResponse: action.response.responseText,
                        },
                        success: function (response, options) {
                            var fuelResponseImportData  = Ext.util.JSON.decode(response.responseText);                      
                            fuelMileageImportStore.loadData(fuelResponseImportData);
                            
                        },
                        failure: function () {
                            Ext.example.msg("Error");
                        }
                    });
                        
                    },
                    failure: function () {
                        Ext.example.msg("Not Able to Show Import Data");
                     }
                });
            }
        }
    }, {
        text: 'Log File',
        iconCls : 'logbutton',
        handler: function () {
            fp.getForm().submit({
                url: '<%=request.getContextPath()%>/FuelMileage.do?param=openLogFile'
            });
        }
    }, {
        text: '<%=Close%>',
        iconCls : 'closebutton',
        handler: function () {
            fp.getForm().reset();
            importWin.hide();

        }
    }]
});

var excelImageFormat = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'excelMaster',

    height: 200,
    width: '100%',
    frame: false,
    items: [{
        cls: 'imagepanel'
    }]
});

var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [fp, excelImageFormat]
});

importWin = new Ext.Window({
    title: title,
    width: 840,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: 'mywindow',
    id: 'importWin',
    items: [importPanelWindow]
});

function clearInputData() {
   Ext.getCmp('total').setText("00 "+currency+"");
    importGrid.store.clearData();
    importGrid.view.refresh();
}

function importData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    Ext.getCmp('total').setText("00 "+currency+"");
    importButton = "import";
    importTitle = 'Import Excel';
    importWin.show();
    importWin.setTitle(importTitle);
}

function deleteData() {

    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }

    var saveJson = getJsonOfStore(fuelMileageImportStore);
    if (saveJson == '[]') {
        Ext.example.msg("Please Add Fuel Details");
        return;
    }
	
    for (var i = 0; i < fuelMileageImportStore.data.length; i++) {
        var record = fuelMileageImportStore.getAt(i);
        var checkvalidOrInvalid = record.data['validOrInvalid'];

        if (checkvalidOrInvalid == 'YetToValidate') {
            Ext.example.msg("Please Validate Before Saving..");
            return;
        }
    }

    var fuelValidCount = 0;
    var totalFuelcount = fuelMileageImportStore.data.length;
    for (var i = 0; i < fuelMileageImportStore.data.length; i++) {
        var record = fuelMileageImportStore.getAt(i);
        var checkvalidOrInvalid = record.data['validOrInvalid'];
        if (checkvalidOrInvalid == 'Valid') {
            fuelValidCount++;
        }
    }

    Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + fuelValidCount + ' valid transaction to be saved out of ' + totalFuelcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
                if (saveJson != '[]') {

                    var saveButton = "save";
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/FuelMileage.do?param=saveFuelMileageDetails',
                        method: 'POST',
                        params: {
                            buttonSaveParam: saveButton,
                            fuelDataSaveParam: saveJson,
                            customerIdSaveParam: Ext.getCmp('custcomboId').getValue()
                        },
                        success: function (response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            },
                        failure: function () {
                            Ext.example.msg("Error");
                             }
                    });
                    //fuelMileageImportStore.on('load',function(){
					//			 getTotals();
					//});
					Ext.getCmp('total').setText("00 "+currency+"");
                    importGrid.store.clearData();
                    importGrid.view.refresh();
					
                }
            }
        }
    });
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }

    var json = '';
    importGrid.stopEditing();
    json = getJsonOfStore(fuelMileageImportStore);
    if (json == '[]') {
        Ext.example.msg("Please Add Fuel Details To Validate");
        return;
    }

    if (json != '[]') {
        fuelMileageImportStore.load({
            params: {
                fueldata: json,
                validationCustomerId: Ext.getCmp('custcomboId').getValue()
            },
			 callback:function(){//alert("call back called...");
			 getTotals();
			}
        });
    }
}

function getJsonOfStore(store) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = store.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);

    return jsonDataEncode;
}

function addRecord() {

    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    buttonValue = "add";
    title = 'Add Fuel';
    myWin.show();
    myWin.setTitle(title);
}

var plantForImport = Ext.data.Record.create([{
    name: 'slnoIndex'
	}, {
    name: 'registrationNo'
	}, {
    name: 'date',
    type: 'date',
    dateFormat: getDateTimeFormat()
	}, {
    name: 'odometer'
	}, {
    name: 'fuel'
	}, {
    name: 'amount'
	}, {
    name: 'slipNo'
	}, {
    name: 'fuelStationName'
	}, {
    name: 'petroCardNumber'
	}, {
    name: 'validOrInvalid'
}]);

var reader = new Ext.data.JsonReader({
    idProperty: 'darreaderid',
    root: 'FuelMileageImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'registrationNo'
    }, {
        name: 'date',
        type: 'date',
        dateFormat: getDateTimeFormat()
    }, {
        name: 'odometer'
    }, {
        name: 'fuel'
    }, {
        name: 'amount'
    }, {
        name: 'slipNo'
    }, {
        name: 'fuelStationName'
    }, {
        name: 'petroCardNumber'
    }, {
        name: 'validOrInvalid'
    }]
});

var fuelMileageImportStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/FuelMileage.do?param=validateFuelMileage',
        method: 'POST'
    }),
    remoteSort: false,
    storeId: 'darStore',
    reader: reader
});



var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'registrationNo'
    }, {
        type: 'date',
        dataIndex: 'date'
    }, {
        type: 'int',
        dataIndex: 'odometer'
    }, {
        type: 'float',
        dataIndex: 'fuel'
    }, {
        type: 'float',
        dataIndex: 'amount'
    }, {
        type: 'string',
        dataIndex: 'slipNo'
    }, {
        type: 'string',
        dataIndex: 'fuelStationName'
    }, {
        type: 'string',
        dataIndex: 'petroCardNumber'
    }, {
        type: 'string',
        dataIndex: 'validOrInvalid'
    }]
});

//************************************Column Model Config******************************************
var createColModel = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer({
        header: "<span style=font-weight:bold;><%=SlNo%></span>",
        width: 50
    }), {
        dataIndex: 'slnoIndex',
        hidden: true,
        header: "<span style=font-weight:bold;><%=SlNo%></span>",
        filter: {
            type: 'numeric'
        }
    }, {
        header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
        dataIndex: 'registrationNo',
        width: 120,
        filter: {
            type: 'string'
        }
    }, {
        dataIndex: 'date',
        header: "<span style=font-weight:bold;><%=Date%></span>",
        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        width: 110,
        filter: {
            type: 'date'
        }
    }, {
        header: "<span style=font-weight:bold;><%=Odometer%></span>",
        dataIndex: 'odometer',
        width: 80,
        filter: {
            type: 'numeric'
        }
    }, {
        header: "<span style=font-weight:bold;><%=SlipNo%></span>",
        dataIndex: 'slipNo',
        width: 80,
        filter: {
            type: 'string'
        }
    }, {
        header: "<span style=font-weight:bold;><%=FuelStationName%></span>",
        dataIndex: 'fuelStationName',
        width: 140,
        filter: {
            type: 'string'
        }
    }, {
        header: "<span style=font-weight:bold;><%=PetroCardNumber%></span>",
        dataIndex: 'petroCardNumber',
        width: 140,
        filter: {
            type: 'string'
        }
    }, {
        header: "<span style=font-weight:bold;><%=Fuel%></span>",
        dataIndex: 'fuel',
        width: 80,
        filter: {
            type: 'numeric'
        }
    }, {
        header: "<span style=font-weight:bold;><%=Amount%></span>",
        dataIndex: 'amount',
        width: 80,
        filter: {
            type: 'numeric'
        }
    }, {
        header: "<span style=font-weight:bold;><%=Valid%></span>",
        dataIndex: 'validOrInvalid',
        width: 60,
        renderer: checkValid,
        filter: {
            type: 'string'
        }
    }
]);

function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
}

var importGrid = getMultipleGrid('', '<%=NoRecordsFound%>', fuelMileageImportStore, screen.width - 75, 350, createColModel, filters, false, '', false, '', 9, false, '', false, '', false, '', '', '', false, '', true, '<%=Add%>', true, '<%=Validate%>', true, '<%=Save%>', true, '<%=ImportFuel%>', true, '<%=Clear%>');

var customerPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: true,
    width:screen.width-75,
    layoutConfig: {
        columns: 7
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle',
            id: 'custnamelab'
        },
        custnamecombo
    ]
});

var disclaimer = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'disclaimerId',
    height: 30,
    width: screen.width - 75,
    frame: true,
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        cls: 'disclaimerValidFuel'
    }, {
        xtype: 'label',
        text: 'Only Valid Information Will Be Processed',
        cls: 'labelstyle'
    }]
});

 var total=new Ext.form.Label({
						fieldLabel: '',
       				 	style: 'font-weight:bold;',
                        width : 100,
        			  	id: 'total' 
        });
var totals= new Ext.FormPanel({
				height: 27,
				frame: true,
                layout:'column',
				layoutConfig: {
					columns: 2
				},
				width: screen.width - 75,
				items: [{
       				 	xtype: 'label',
       				 	style: 'font-weight:bold;',
       				 	text: '<%=GrandTotal%>:',
       				 	width : 100
    					},total ]
		});	 
//--------datachanged--------------//	
	fuelMileageImportStore.on('datachanged',function(){
      getTotals();
     });	
		
     function getTotals(){
		 tot = parseFloat(importGrid.store.sum('amount')).toFixed(2);
		 tot=tot+" "+currency;
		Ext.getCmp('total').setText(tot);
		}		
		

Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        title: '<%=fuelImportTitle%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width:screen.width-49,
        height:500,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerPanel, importGrid, disclaimer,totals]
       // bbar: ctsb
    });
     Ext.getCmp('total').setText("00 "+currency+"");
});	
   	</script>
  	</body>
</html>