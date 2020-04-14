<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	CommonFunctions cf = new CommonFunctions();

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int customerId = loginInfo.getCustomerId();

	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("Calibration_Status");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Minimum_Fuel_Present_In_Tank");
	tobeConverted.add("Voltage_When_Minimum_Fuel_Present_In_Tank");
	tobeConverted.add("Maximum_Fuel_Present_In_Tank");
	tobeConverted.add("Voltage_When_Maximum_Fuel_Present_In_Tank");
	tobeConverted.add("Min_Mileage_Expected");
	tobeConverted.add("Max_Mileage_Expected");
	tobeConverted.add("Calibration_Date");
	tobeConverted.add("Calibrated_By");
	tobeConverted.add("Calibration_Remarks");
	tobeConverted.add("End_Customer_SPOC");
	tobeConverted.add("Last_Execution_Date");
	tobeConverted.add("Approve_Status");

	tobeConverted.add("Select_Asset_Number");
	tobeConverted.add("Enter_Minimum_Fuel_Present_In_Tank");
	tobeConverted.add("Enter_Voltage_When_Minimum_Fuel_Present_In_Tank");
	tobeConverted.add("Enter_Maximum_Fuel_Present_In_Tank");
	tobeConverted.add("Enter_Voltage_When_Maximum_Fuel_Present_In_Tank");
	tobeConverted.add("Enter_Min_Mileage_Expected");
	tobeConverted.add("Enter_Max_Mileage_Expected");		
	tobeConverted.add("Enter_Calibration_Date");
	tobeConverted.add("Enter_Calibrated_By");
	tobeConverted.add("Enter_Calibration_Remarks");
	tobeConverted.add("Enter_End_Customer_SPOC");
	tobeConverted.add("Enter_Last_Execution_Date");

	tobeConverted.add("Add");
	tobeConverted.add("Modify");
	tobeConverted.add("Save");
	tobeConverted.add("Cancel");
	
    tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Next");
	tobeConverted.add("Calibration_Information");
	tobeConverted.add("UID");
	
	tobeConverted.add("Speed_Id");
	tobeConverted.add("Enter_Speed");
	tobeConverted.add("Ignition");
	tobeConverted.add("Select_Ignition");
	tobeConverted.add("Delta_Distance");
	tobeConverted.add("Enter_Delta_Distance");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String CalibrationStatus = convertedWords.get(0);
	String CustomerName = convertedWords.get(1);
	String SelectCustomerName = convertedWords.get(2);
	String SLNO = convertedWords.get(3);
	String AssetNumber = convertedWords.get(4);
	String MinimumFuelPresentInTank = convertedWords.get(5);
	String VoltageWhenMinimumFuelPresentInTank = convertedWords.get(6);
	String MaximumFuelPresentInTank = convertedWords.get(7);
	String VoltageWhenMaximumFuelPresentInTank = convertedWords.get(8);
	String MinMileageExpected = convertedWords.get(9);
	String MaxMileageExpected = convertedWords.get(10);
	String CalibrationDate = convertedWords.get(11);
	String CalibratedBy = convertedWords.get(12);
	String CalibrationRemarks = convertedWords.get(13);
	String EndCustomerSPOC = convertedWords.get(14);
	String LastExecutionDate = convertedWords.get(15);
	String ApproveStatus= convertedWords.get(16);
	
	String SelectAssetNumber= convertedWords.get(17);	
	String EnterMinimumFuelPresentInTank = convertedWords.get(18);
	String EnterVoltageWhenMinimumFuelPresentInTank = convertedWords.get(19);
	String EnterMaximumFuelPresentInTank = convertedWords.get(20);
	String EnterVoltageWhenMaximumFuelPresentInTank = convertedWords.get(21);
	String EnterMinMileageExpected = convertedWords.get(22);
	String EnterMaxMileageExpected = convertedWords.get(23);	
	String EnterCalibrationDate = convertedWords.get(24);
	String EnterCalibratedBy = convertedWords.get(25);
	String EnterCalibrationRemarks = convertedWords.get(26);
	String EnterEndCustomerSPOC = convertedWords.get(27);	
	String EnterLastExecutionDate = convertedWords.get(28);
		
	String Add = convertedWords.get(29);
	String Modify = convertedWords.get(30);
	String Save = convertedWords.get(31);
	String Cancel = convertedWords.get(32);
	
	String NoRecordsFound = convertedWords.get(33);
	String ClearFilterData = convertedWords.get(34);
	String SelectSingleRow = convertedWords.get(35);
	String NoRowSelected = convertedWords.get(36);		
	String Next = convertedWords.get(37);
    String CalibrationInformation = convertedWords.get(38);
	String UID = convertedWords.get(39);
	
	String Speed=convertedWords.get(40);
	String EnterSpeed=convertedWords.get(41);
	String ignition=convertedWords.get(42);
	String SelectIgnition=convertedWords.get(43);
	String DeltaDistance=convertedWords.get(44);
	String EnterDeltaDistance=convertedWords.get(45);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title><%=CalibrationStatus%></title>
		<meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8" />
	</head>
	<body onload="refresh();">
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
    <%}else {%>  
    <jsp:include page="../Common/ImportJS.jsp" />
    <%} %>
		<script>
    var outerPanel;
	var ctsb;
	var buttonValue;
	var titel;
	var title;
	var myWin;
	var jspName = "";
	var dtcur = datecur;
	var globaluid;
	
	function refresh() {
	    isChrome = window.chrome;
	    if (isChrome && parent.flagFDAS < 2) {
	        setTimeout(
	            function () {
	                parent.Ext.getCmp('fdastabId').enable();
	                parent.Ext.getCmp('fdastabId').show();
	                parent.Ext.getCmp('fdastabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/FCIS/CalibrationStatus.jsp'></iframe>");
	            }, 0);
	        parent.FDASTab.doLayout();
	        parent.flagFDAS = parent.flagFDAS + 1;
	    }
	}

	var VehicleNumberStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=getvehicleno',
	    id: 'VehicleStoreId',
	    root: 'vehicleNoRoot',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['vehicleno', 'vehicleId']
	});

	var vehicleCombo = new Ext.form.ComboBox({
	    store: VehicleNumberStore,
	    id: 'vehiclecomboId',
	    cls: 'selectstylePerfect',
	    forceSelection: true,
	    emptyText:'Select Vehicle',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    enableKeyEvents: true,
	    mode: 'local',
	    triggerAction: 'all',
	    displayField: 'vehicleno',
	    valueField: 'vehicleId',
	    enableKeyEvents: true,
	    minChars: 1,
	    listeners: {
	        select: {
	            fn: function () {
	             	voltageFuelStore.load({
	                    params: {
    						VehicleNo: Ext.getCmp('vehiclecomboId').getValue()
    					}
	    			});
	            }
	        } // END OF SELECT
	    } // END OF LISTENERS 
	});
	
var ignitionStore = new Ext.data.SimpleStore({
    id: 'ignitionStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['On', 'On'],
        ['On/Off', 'On/Off']
    ]
});

var ignition = new Ext.form.ComboBox({
    store: ignitionStore,
    id: 'ignitionId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    emptyText: '<%=SelectIgnition%>',
    resizable: true,
    valueField: 'Value',
    displayField: 'Name',
    value:'On',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            ign= Ext.getCmp('ignitionId').getValue();
            if(ign=='On/Off'){
              Ext.getCmp('speedId').setValue(-1);
              Ext.getCmp('deltaDistanceId').setValue(-1);
              Ext.getCmp('speedId').disable();
              Ext.getCmp('deltaDistanceId').disable();
            }
            else{
             Ext.getCmp('speedId').enable();
             Ext.getCmp('deltaDistanceId').enable();
             Ext.getCmp('speedId').setValue(20);
             Ext.getCmp('deltaDistanceId').setValue(0.5);
            }
            }
        }
    }
});

	var voltageFuelStore = new Ext.data.JsonStore({
    	id: 'voltageFuelStoreId',
    	url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=getFuelMultiValue',
    	root: 'voltageFuelRoot',
    	autoLoad: false,
    	fields: ['slnoIndex', 'voltage', 'fuel'],
    	listeners: {
    	}
});

	var cm = new Ext.grid.ColumnModel([
    	new Ext.grid.RowNumberer({
	            header: "<span style=font-weight:bold;><%=SLNO%></span>",
	            dataIndex: 'RowNo',
	            width: 50
    	}), {
	    	dataIndex: 'slnoIndex',
	   	 	hidden: true,
	   	 	header: "<span style=font-weight:bold;><%=SLNO%></span>",
	    	filter: {
	    		type: 'numeric'
	    	}
		}, {
        	header: "<span style=font-weight:bold;>VOLTAGE</span>",
        	dataIndex: 'voltage',
        	width: 106,
        	editor: new Ext.form.NumberField({
                allowNegative: false,
                maxValue: 100000,
                decimalPrecision:3
            }),
        	editable: true
   	 	}, {
        	header: "<span style=font-weight:bold;>FUEL</span>",
        	dataIndex: 'fuel',
        	width: 106,
        	editor: new Ext.form.NumberField({
                allowNegative: false,
                maxValue: 100000
            }),
        	editable: true
    	}
	]);

	var voltageFuelGrid = new Ext.grid.EditorGridPanel({
    	id: 'voltageFuelGridId',
    	store: voltageFuelStore,
   	 	cm: cm,
    	clicksToEdit:1,
    	stripeRows: true,
    	border: true,
    	frame: false,
    	width: 285,
    	height: 320,
    	cls: 'bskExtStyle',
    	loadMask: true,
    	listeners: {
       
    	}
	});

		voltageFuelStore.on('load', function(voltageFuelStore) {
  				var records = new Array();
  				for(var i = 100 - voltageFuelStore.getCount(); i > 0; i--) {
  						var defaultData = {
  							id : "id_" + i,
                    		slnoIndex: 0,
                    		voltage: '',
                    		fuel: ''
                		};
     					records.push(new voltageFuelStore.recordType(defaultData))
  				}
  				voltageFuelStore.add(records);
  				voltageFuelStore.commitChanges();
  				//console.log(voltageFuelStore);
		});

	var innerPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 410,
	    width: '100%',
	    frame: true,
	    id: 'custMaster',
	    layout: 'table',
	    layoutConfig: {
	        columns: 4,
	        style: {
	            // width: '10%'
	        }
	    },
	    items: [{
        xtype: 'fieldset',
        title: '<%=CalibrationInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'calibrationpanelid',
        width: 470,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
	    
	    
	    items: [{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=AssetNumber%>' + ' :',
	            cls: 'labelstyle'
	        },
	        vehicleCombo, 
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=MinMileageExpected%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '<%=EnterMinMileageExpected%>',
	            cls: 'selectstylePerfect',
	            blankText: '<%=EnterMinMileageExpected%>',
	            id: 'mileageid'
	        }, {
	            html: '(KM/LTR)',
	            hidden: false
	        }, {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=MaxMileageExpected%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '<%=EnterMaxMileageExpected%>',
	            cls: 'selectstylePerfect',
	            blankText: '<%=EnterMaxMileageExpected%>',
	            id: 'maxmileageid'
	        }, {
	            html: '(KM/LTR)',
	            hidden: false
	        }, {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=CalibrationDate%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'datefield',
	            cls: 'selectstylePerfect',
	            id: 'calid',
	            format: getDateTimeFormat(),
	            allowBlank: false,
	            blankText: '<%=EnterCalibrationDate%>',
	            submitFormat: getDateTimeFormat(),
	            labelSeparator: '',
	            allowBlank: false,
	            value: dtcur
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=CalibratedBy%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'textfield',
	            regex: validate('name'),
	            allowBlank: false,
	            emptyText: '<%=EnterCalibratedBy%>',
	            blankText: '<%=EnterCalibratedBy%>',
	            cls: 'selectstylePerfect',
	            id: 'caliid'
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=EndCustomerSPOC%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'textfield',
	            regex: validate('name'),
	            emptyText: '<%=EnterEndCustomerSPOC%>',
	            allowBlank: false,
	            blankText: '<%=EnterEndCustomerSPOC%>',
	            cls: 'selectstylePerfect',
	            id: 'endid'
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=CalibrationRemarks%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'textfield',
	            emptyText: '<%=EnterCalibrationRemarks%>',
	            allowBlank: true,
	            cls: 'selectstylePerfect',
	            id: 'remarkid'
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=LastExecutionDate%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'datefield',
	            cls: 'selectstylePerfect',
	            id: 'dateid',
	            format: getDateTimeFormat(),
	            allowBlank: false,
	            blankText: 'Select Date',
	            submitFormat: getDateTimeFormat(),
	            labelSeparator: '',
	            allowBlank: false,
	            value: dtcur
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        },{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=ignition%>' + ' :',
	            cls: 'labelstyle'
	        },ignition , {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        },{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=Speed%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            allowBlank: false,
	            emptyText: '<%=EnterSpeed%>',
	            blankText: '<%=EnterSpeed%>',
	            cls: 'selectstylePerfect',
	            id: 'speedId'
	        }, {
	            xtype: 'label',
	            text: '(KM/HR)'
	            //cls: 'mandatoryfield'
	        },{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=DeltaDistance%>' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            allowBlank: false,
	            emptyText: '<%=EnterDeltaDistance%>',
	            blankText: '<%=EnterDeltaDistance%>',
	            cls: 'selectstylePerfect',
	            id: 'deltaDistanceId'
	        }, {
	            xtype: 'label',
	            text: '(KMS)'
	            //cls: 'mandatoryfield'
	        }
	    ]
	    
	  }, {
            width: 20
        }, {
            xtype: 'fieldset',
            title: 'Fuel Voltage Series',
            autoHeight: true,
            width: 470,
            colspan: 3,
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'voltageFuelEmptyId1'
            }, {
                xtype: 'label',
                text: 'Voltage Fuel Values' + ' :      ',
                cls: 'labelstyle',
                id: 'voltageFuelLabelId'
            }, voltageFuelGrid, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'voltageFuelEmptyId2'
            }]
        }, {
            width: 20
        }]  
	    
	});
                
	var winButtonPanel = new Ext.Panel({
	    id: 'winbuttonid',
	    standardSubmit: true,
	    collapsible: false,
	    autoHeight: true,
	    cls: 'windowbuttonpanel',
	    frame: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 4
	    },
	    buttons: [{
	        xtype: 'button',
	        text: '<%=Save%>',
	        id: 'addButtId',
	        cls: 'buttonstyle',
	        iconCls: 'savebutton',
	        width: 70,
	        listeners: {
	            click: {
	                fn: function (btn) {
	                	
	                	if(buttonValue == "Add" && voltageFuelGrid.store.getModifiedRecords().length >= 2){
	                		var data = [];
							var rs = voltageFuelGrid.store.getModifiedRecords();
							var prevIndex = 0;
							for (var i = 0, ln = rs.length; i < ln; i++) {
   								if(i<2){
   									if (rs[i].data.fuel === "" || rs[i].data.voltage === ""){
   										Ext.example.msg("First two Fuel-Voltage values cannot be empty");
	                        			Ext.getCmp('vehiclecomboId').focus();
	                        			return;
   									}
   								}
   								if (rs[i].data.fuel !== "" || rs[i].data.voltage !== ""){
   									if(rs[prevIndex].data.voltage > rs[i].data.voltage){
   										Ext.example.msg("Fuel-Voltage values should be in ascending order");
	                        			Ext.getCmp('vehiclecomboId').focus();
	                        			return;
   									}
   									data.push(rs[i].data);
   									prevIndex = i;
   								}
							}
							VoltageFueljson = Ext.util.JSON.encode(data);
	                	
	                	} else if(buttonValue == "Modify") {
	                		var VoltageFueljson = [];
	                		//alert("modify");
	                		if(voltageFuelGrid.store.getModifiedRecords().length > 0){
	                			//alert(voltageFuelGrid.store.getModifiedRecords().length);
	                			VoltageFueljson = Ext.encode(Ext.pluck(voltageFuelGrid.store.data.items, 'data'));
	                			var data = [];
								var rs = voltageFuelGrid.store.getRange();
								var prevIndex = 0;
								for (var i = 0, ln = rs.length; i < ln; i++) {
   									if(i<2){
   										if (rs[i].data.fuel === "" || rs[i].data.voltage === ""){
   											//alert("First two Fuel-Voltage values cannot be empty");
   											Ext.example.msg("First two Fuel-Voltage values cannot be empty");
	                        				Ext.getCmp('vehiclecomboId').focus();
	                        				return;
   										}
   									}
   									if (rs[i].data.fuel !== "" || rs[i].data.voltage !== ""){
   										if(rs[prevIndex].data.voltage > rs[i].data.voltage){
   											Ext.example.msg("Fuel-Voltage values should be in ascending order");
	                        				Ext.getCmp('vehiclecomboId').focus();
	                        				return;
   										}
   										data.push(rs[i].data);
   										prevIndex = i;
   									}
								}
								VoltageFueljson = Ext.util.JSON.encode(data);
								//console.log(data);
								//console.log(VoltageFueljson);
	                		} 
	                	} else {
	                			Ext.example.msg("please enter atleast two Fuel-Voltage values");
	                        	Ext.getCmp('vehiclecomboId').focus();
	                        	return;
	                    }
	                	
	                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
	                        Ext.example.msg("<%=SelectAssetNumber%>");
	                        Ext.getCmp('vehiclecomboId').focus();
	                        return;
	                    }
                
	                    if (!(Ext.getCmp('mileageid').getValue() == "0" || Ext.getCmp('mileageid').getValue() != "")) {
	                        Ext.example.msg("<%=EnterMinMileageExpected%>");
	                        Ext.getCmp('mileageid').focus();	                      
	                        return;
	                    }
                
	                    if (Ext.getCmp('maxmileageid').getValue() == "") {
	                        Ext.example.msg("<%=EnterMaxMileageExpected%>");
	                        Ext.getCmp('maxmileageid').focus();
	                        return;
	                    }
                
	                    if (Ext.getCmp('calid').getValue() == "") {
	                        Ext.example.msg("<%=EnterCalibrationDate%>");
	                        Ext.getCmp('calid').focus();
	                        return;
	                    }
                
	                    if (Ext.getCmp('caliid').getValue() == "") {
	                        Ext.example.msg("<%=EnterCalibratedBy%>");
	                        Ext.getCmp('caliid').focus();
	                        return;
	                    }
                
	                    if (Ext.getCmp('endid').getValue() == "") {
	                        Ext.example.msg("<%=EnterEndCustomerSPOC%>");
	                         Ext.getCmp('endid').focus();
	                        return;
	                    }
                
	                    if (Ext.getCmp('dateid').getValue() == "") {
	                        Ext.example.msg("<%=EnterLastExecutionDate%>");
	                        Ext.getCmp('dateid').focus();
	                        return;
	                    }
	                    
	                    if (Ext.getCmp('speedId').getValue() === "") {
	                        Ext.example.msg("<%=EnterSpeed%>");
	                        Ext.getCmp('speedId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('ignitionId').getValue() == "") {
	                        Ext.example.msg("<%=SelectIgnition%>");
	                        Ext.getCmp('ignitionId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('deltaDistanceId').getValue() === "") {
	                        Ext.example.msg("<%=EnterDeltaDistance%>");
	                        Ext.getCmp('deltaDistanceId').focus();
	                        return;
	                    }
	                    if (innerPanel.getForm().isValid()) {
							btn.disable();
	                        Ext.Ajax.request({
	                            url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=CalibrationSave',
	                            method: 'POST',
	                            params: {
	                                buttonValue: buttonValue,
	                                UID: globaluid,
	                                VehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
	                                MinMileage: Ext.getCmp('mileageid').getValue(),
	                                MaxMileage: Ext.getCmp('maxmileageid').getValue(),
	                                Calibrationdate: Ext.getCmp('calid').getValue(),
	                                Calibratedby: Ext.getCmp('caliid').getValue(),
	                                EndCustomer: Ext.getCmp('endid').getValue(),
	                                Remarks: Ext.getCmp('remarkid').getValue(),
	                                Lastdate: Ext.getCmp('dateid').getValue(),
	                                custId: Ext.getCmp('custcomboId').getValue(),
	                                lastdate: Ext.getCmp('dateid').getValue(),
	                                fuelVoltjson: VoltageFueljson,
	                                speed:Ext.getCmp('speedId').getValue(),
	                                ignition:Ext.getCmp('ignitionId').getValue(),
	                                deltaDistance:Ext.getCmp('deltaDistanceId').getValue()
	                            },
	                            success: function (response, options) {
	                                var message = response.responseText;
	                                Ext.example.msg(message);
	                                Ext.getCmp('vehiclecomboId').reset();
	                                Ext.getCmp('mileageid').reset();
	                                Ext.getCmp('maxmileageid').reset();
	                                Ext.getCmp('calid').reset();
	                                Ext.getCmp('caliid').reset();
	                                Ext.getCmp('endid').reset();
	                                Ext.getCmp('remarkid').reset();
	                                Ext.getCmp('dateid').reset();
	                                Ext.getCmp('speedId').reset();
	                                Ext.getCmp('ignitionId').reset();
	                                Ext.getCmp('deltaDistanceId').reset();
	                                btn.enable();
	                                myWin.hide();
	                                store.load({
	                                    params: {
	                                        jspName: jspName,
	                                        custId: Ext.getCmp('custcomboId').getValue(),
	                                        custName: Ext.getCmp('custcomboId').getRawValue()
	                                    }
	                                });
	                                VehicleNumberStore.load({
	                                    params: {
	                                        custId: Ext.getCmp('custcomboId').getValue()
	                                    }
	                                });
	                                voltageFuelStore.removeAll();
	                            },
	                            failure: function () {
	                                Ext.example.msg("Error");
	                                btn.enable();
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
	                    myWin.hide();
	                }
	            }
	        }
	    }]
	});

	var outerPanelWindow = new Ext.Panel({
	    cls: 'outerpanelwindow',
	    standardSubmit: true,
	    frame: true,
	    items: [innerPanel, winButtonPanel]
	});

	myWin = new Ext.Window({
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: false,
	    cls: 'mywindow',
	    id: 'myWin',
	    items: [outerPanelWindow]
	});

	function addRecord() {
	    if (Ext.getCmp('custcomboId').getValue() == "") {
	        Ext.example.msg("<%=SelectCustomerName%>");
	        Ext.getCmp('custcomboId').focus();
	        return;
	    }
	    buttonValue = 'Add';
	    title = '<%=Add%>';
	    myWin.setPosition(400, 12);
	    myWin.show();
	    myWin.setTitle(title);
	    Ext.getCmp('vehiclecomboId').enable();
	    Ext.getCmp('vehiclecomboId').reset();
	    Ext.getCmp('mileageid').reset();
	    Ext.getCmp('maxmileageid').reset();
	    Ext.getCmp('calid').reset();
	    Ext.getCmp('caliid').reset();
	    Ext.getCmp('endid').reset();
	    Ext.getCmp('remarkid').reset();
	    Ext.getCmp('dateid').reset();
	    Ext.getCmp('speedId').setValue(20);
       Ext.getCmp('ignitionId').reset();
       Ext.getCmp('deltaDistanceId').setValue(0.5);
       Ext.getCmp('speedId').enable();
       Ext.getCmp('deltaDistanceId').enable();
	    globaluid = "";
	    voltageFuelStore.removeAll();
	}

	function modifyData() {
		voltageFuelStore.removeAll();
	    if (Ext.getCmp('custcomboId').getValue() == "") {
	        Ext.example.msg("<%=SelectCustomerName%>>");
	        Ext.getCmp('custcomboId').focus();
	        return;
	    }
      
	    if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("<%=NoRowSelected%>");
	        return;
	    }
      
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("<%=SelectSingleRow%>");
	        return;
	    }
      
	    buttonValue = 'Modify';
	    titel = '<%=Modify%>';	   
	    myWin.setPosition(400, 12);
	    myWin.setTitle(titel);
	    myWin.show();
	     Ext.getCmp('vehiclecomboId').disable();
	    var selected = grid.getSelectionModel().getSelected();
	    globaluid = selected.get('UIDDataIndex');
	    Ext.getCmp('vehiclecomboId').setValue(selected.get('VehicleNo'));
	    Ext.getCmp('mileageid').setValue(selected.get('MinMileage'));
	    Ext.getCmp('maxmileageid').setValue(selected.get('MaxMileage'));
	    Ext.getCmp('calid').setValue(selected.get('Calibrationdate'));
	    Ext.getCmp('caliid').setValue(selected.get('Calibratedby'));
	    Ext.getCmp('endid').setValue(selected.get('EndCustomer'));
	    Ext.getCmp('remarkid').setValue(selected.get('Remarks'));
	    Ext.getCmp('dateid').setValue(selected.get('Lastdate'));
	    Ext.getCmp('speedId').setValue(selected.get('speedDataIndex'));
	    Ext.getCmp('ignitionId').setValue(selected.get('ignitionDataIndex'));
	    Ext.getCmp('deltaDistanceId').setValue(selected.get('deltaDistanceDataIndex'));
	    voltageFuelStore.load({
	                    params: {
    						VehicleNo: Ext.getCmp('vehiclecomboId').getValue()
    					}
	    });
	}

	 //*********************** Store For Customer *****************************************/
	var customercombostore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
	    id: 'CustomerStoreId',
	    root: 'CustomerRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['CustId', 'CustName'],
	    listeners: {
	        load: function (custstore, records, success, options) {
	            if ( <%=customerId%> > 0) {
	                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
	                custId = Ext.getCmp('custcomboId').getValue();
	                parent.globalCustomerID = custId;
	                store.load({
	                    params: {
	                        jspName: jspName,
	                        custId: custId,
	                        custName: Ext.getCmp('custcomboId').getRawValue()
	                    }
	                });
	                
	                VehicleNumberStore.load({
	                    params: {
	                        custId: custId
	                    }
	                });
	                
	                parent.Ext.getCmp('RefuelId').disable();
	                parent.Ext.getCmp('RefuelId').hide();
	            }
	        }
	    }
	});

	 //************************ Combo for Customer Starts Here***************************************//
	var custnamecombo = new Ext.form.ComboBox({
	    store: customercombostore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=SelectCustomerName%>',
	    selectOnFocus: true,
	    resizable: true,
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
	                parent.globalCustomerID = custId;
                  	store.load({
	                    params: {
	                        jspName: jspName,
	                        custId: custId,
	                        custName: Ext.getCmp('custcomboId').getRawValue()
	                    }
	                });
                  
	                VehicleNumberStore.load({
	                    params: {
	                        custId: custId
	                    }
	                });
	                
	                parent.Ext.getCmp('RefuelId').disable();
	                parent.Ext.getCmp('RefuelId').hide();
	            }
	        }
	    }
	});

	var comboPanel = new Ext.Panel({
	    standardSubmit: true,
	    collapsible: false,
	    id: 'customerMaster',
	    frame: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 2
	    },
	    items: [{
	            xtype: 'label',
	            text: '<%=CustomerName%> :',
	            width: 20,
	            cls: 'labelstyle'
	        },
	        custnamecombo
	    ]
	});

	function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
	
	    if (Ext.getCmp('custcomboId').getValue() == "") {
	        Ext.example.msg("<%=SelectCustomerName%>");
	        Ext.getCmp('custcomboId').focus();
	        return;
	    }
	    
	    if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("<%=NoRowSelected%>");
	        return;
	    }
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("<%=SelectSingleRow%>");
	        return;
	    }
	    
	    parent.Ext.getCmp('RefuelId').enable(true);
	    if (grid.getSelectionModel().getCount() == 1) {
	        var selected = grid.getSelectionModel().getSelected();
	        parent.assetNumber = selected.get('VehicleNo');
	        parent.globalCustomerID = custId;
	    }
	}

	var reader = new Ext.data.JsonReader({
	    idProperty: 'clientreaderid',
	    root: 'calibrationroot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'slnoIndex'
	    }, {
	        name: 'UIDDataIndex'
	    },{
	        name: 'VehicleNo'
	    }, {
	        name: 'MinMileage'
	    }, {
	        name: 'MaxMileage'
	    }, {
	        name: 'Calibrationdate',
	        type: 'date',
	        dateFormat: getDateTimeFormat()
	    }, {
	        name: 'Calibratedby'
	    }, {
	        name: 'EndCustomer'
	    }, {
	        name: 'Remarks'
	    }, {
	        name: 'Lastdate',
	        type: 'date',
	        dateFormat: getDateTimeFormat()
	    },{
	       name: 'approvestatus'
	       },{
	       name: 'speedDataIndex'
	       },{
	       name: 'ignitionDataIndex'
	       },{
	       name: 'deltaDistanceDataIndex'
	       }]
	});

	 //***************************************Store Config*****************************************
	var store = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=getCalibrationStatus',
	        method: 'POST'
	    }),
	    storeId: 'clientreaderid',
	    reader: reader
	});

	 //**********************Filter Config****************************************************
	var filters = new Ext.ux.grid.GridFilters({
	    local: true,
	    filters: [{
	        type: 'numeric',
	        dataIndex: 'slnoIndex'
	    }, {
	        type: 'numeric',
	        dataIndex: 'UIDDataIndex'
	    },{
	        type: 'string',
	        dataIndex: 'VehicleNo'
	    }, {
	        type: 'float',
	        dataIndex: 'MinMileage'
	    }, {
	        type: 'float',
	        dataIndex: 'MaxMileage'
	    }, {
	        type: 'date',
	        dataIndex: 'Calibrationdate'
	    }, {
	        type: 'string',
	        dataIndex: 'Calibratedby'
	    }, {
	        type: 'string',
	        dataIndex: 'EndCustomer'
	    }, {
	        type: 'string',
	        dataIndex: 'Remarks'
	    }, {
	        type: 'date',
	        dataIndex: 'Lastdate'
	    },{
	        type: 'numeric',
	        dataIndex: 'speedDataIndex'
	    },{
	        type: 'string',
	        dataIndex: 'ignitionDataIndex'
	    },{
	        type: 'numeric',
	        dataIndex: 'deltaDistanceDataIndex'
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
	        },{       
				dataIndex: 'UIDDataIndex',
	            hidden: true,
	            header: "<span style=font-weight:bold;><%=UID%></span>",
	            width: 50,
	            filter: {
	                type: 'numeric'
	            }
			}, {
	            dataIndex: 'VehicleNo',
	            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
	            width: 50,
	            editor: new Ext.grid.GridEditor(vehicleCombo),
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'MinMileage',
	            header: "<span style=font-weight:bold;><%=MinMileageExpected%></span>",
	            width: 40,
	            filter: {
	                type: 'float'
	            }
	        }, {
	            dataIndex: 'MaxMileage',
	            header: "<span style=font-weight:bold;><%=MaxMileageExpected%></span>",
	            width: 40,
	            filter: {
	                type: 'float'
	            }
	        }, {
	            dataIndex: 'Calibrationdate',
	            header: "<span style=font-weight:bold;><%=CalibrationDate%></span>",
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
	            width: 50,
	            filter: {
	                type: 'date'
	            }
	        }, {
	            dataIndex: 'Calibratedby',
	            header: "<span style=font-weight:bold;><%=CalibratedBy%></span>",
	            width: 40,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'EndCustomer',
	            header: "<span style=font-weight:bold;><%=EndCustomerSPOC%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'Remarks',
	            header: "<span style=font-weight:bold;><%=CalibrationRemarks%></span>",
	            width: 40,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'Lastdate',
	            header: "<span style=font-weight:bold;><%=LastExecutionDate%></span>",
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
	            width: 50,
	            filter: {
	                type: 'date'
	            }
	        },{
	            dataIndex: 'approvestatus',
	            header: "<span style=font-weight:bold;><%=ApproveStatus%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        },{
	            dataIndex: 'speedDataIndex',
	            header: "<span style=font-weight:bold;><%=Speed%></span>",
	            width: 50,
	            filter: {
	                type: 'numeric'
	            }
	        },{
	            dataIndex: 'ignitionDataIndex',
	            header: "<span style=font-weight:bold;><%=ignition%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        },{
	            dataIndex: 'deltaDistanceDataIndex',
	            header: "<span style=font-weight:bold;><%=DeltaDistance%></span>",
	            width: 50,
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

	 //*****************************************************************Grid *******************************************************************************
	var grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 400, 16, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '', jspName, '', false, '', true, '<%=Add%>', true, '<%=Modify%>');
	
	grid.on({
	    "cellclick": {
	        fn: onCellClickOnGrid
	    }
	});

	var nextButtonPanel = new Ext.Panel({
	    id: 'nextbuttonid',
	    standardSubmit: true,
	    collapsible: false,
	    cls: 'nextbuttonpanel',
	    frame: false,
	    layout: 'table',
	    layoutConfig: {
	        columns: 1
	    },
	    items: [{
	        xtype: 'button',
	        text: '<%=Next%>',
	        id: 'nextButtId',
	        iconCls: 'nextbutton',
	        width: 80,
	        listeners: {
	            click: {
	                fn: function () {
	                    if (Ext.getCmp('custcomboId').getValue() == "") {
	                        Ext.example.msg("<%=SelectCustomerName%>");
	                        Ext.getCmp('custcomboId').focus();
	                        return;
	                    }
	                    parent.Ext.getCmp('RefuelId').enable(true);
	                    if (grid.getSelectionModel().getCount() == 0) {
	                        Ext.example.msg("<%=NoRowSelected%>");
	                        return;
	                    }
	                    if (grid.getSelectionModel().getCount() > 1) {
	                        Ext.example.msg("<%=SelectSingleRow%>");
	                        return;
	                    }
	                    if (grid.getSelectionModel().getCount() == 1) {
	                        var selected = grid.getSelectionModel().getSelected();
	                        parent.assetNumber = selected.get('VehicleNo');
	                        parent.globalCustomerID = custId;
	                        parent.Ext.getCmp('RefuelId').enable();
	                        parent.Ext.getCmp('RefuelId').show();
	                        parent.Ext.getCmp('RefuelId').update("<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/FCIS/FDASRefuel.jsp'></iframe>");
	                    }
	                }
	            }
	        }
	    }]
	});

	Ext.onReady(function () {
	    ctsb = tsb;
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    outerPanel = new Ext.Panel({
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        border: false,
	       //  cls: 'outerpanel',
	        height:520,
	        width:screen.width-28,
	        items: [comboPanel, grid, nextButtonPanel]
	       // bbar: ctsb
	    });
	});
</script>
	</body>
</html>




