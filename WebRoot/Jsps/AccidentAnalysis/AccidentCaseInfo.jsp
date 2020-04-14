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

	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("Case_Information");
	tobeConverted.add("Case_Info_Details");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Accidental_Type");
	tobeConverted.add("Collated_With");
	tobeConverted.add("Asset_To_Asset");
	tobeConverted.add("Remarks");
	tobeConverted.add("Location");
	tobeConverted.add("DateTime");
	tobeConverted.add("Insurance_Claimed_Amount");
	tobeConverted.add("Faulty_Vehicle");
	tobeConverted.add("Settlement");
	tobeConverted.add("Case_Status");	
	
	tobeConverted.add("Case_Number");
	tobeConverted.add("Enter_Case_Number");
	tobeConverted.add("Enter_Location");
	tobeConverted.add("Select_Date_Time");
	tobeConverted.add("Enter_Insurance_Amount");
	tobeConverted.add("Select_Asset_Number");
	tobeConverted.add("Select_Driver_Name");
	tobeConverted.add("Select_Accidental_Type");
	tobeConverted.add("Select_Collated_With");
	tobeConverted.add("Select_Settlement");
	tobeConverted.add("Enter_Asset_Number");
	tobeConverted.add("Enter_Driver_Name");
	tobeConverted.add("Select_Case_Status");
	tobeConverted.add("Add_Case_Information");
	tobeConverted.add("Edit_Case_Information");
	tobeConverted.add("Loss_Of_Life");
	tobeConverted.add("Injured");
		
	tobeConverted.add("Add");
	tobeConverted.add("Edit");
	tobeConverted.add("Save");
	tobeConverted.add("Cancel");
	tobeConverted.add("Next");		
	
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	
	String CaseInformation = convertedWords.get(2);	
	String CaseInfoDetails = convertedWords.get(3);	
	String SlNo = convertedWords.get(4);
	String AssetNumber = convertedWords.get(5);
	String DriverName = convertedWords.get(6);
	String AccidentalType = convertedWords.get(7);
	String CollatedWith = convertedWords.get(8);
	String AssetToAsset = convertedWords.get(9);
	String Remarks = convertedWords.get(10);//other
	String Location = convertedWords.get(11);
	String DateTime = convertedWords.get(12);
	String InsuranceClaimedAmount = convertedWords.get(13);
	String FaultyVehicle = convertedWords.get(14);
	String Settlement = convertedWords.get(15);
	String CaseStatus = convertedWords.get(16);
	
	String CaseNumber = convertedWords.get(17);
	String EnterCaseNumber = convertedWords.get(18);
	String EnterLocation = convertedWords.get(19);
	String SelectDate = convertedWords.get(20);
	String EnterInsuranceAmount = convertedWords.get(21);
	String SelectAssetNumber = convertedWords.get(22);
	String SelectDriverName = convertedWords.get(23);
	String SelectAccidentalType = convertedWords.get(24);
	String SelectCollatedWith = convertedWords.get(25);
	String SelectSettlement = convertedWords.get(26);
	String EnterAssetNumber = convertedWords.get(27);
	String EnterDriverName = convertedWords.get(28);
	String SelectCaseStatus = convertedWords.get(29);
	String AddCaseInformation = convertedWords.get(30);
	String EditCaseInformation = convertedWords.get(31);
	String LossOfLife = convertedWords.get(32);
	String Injured = convertedWords.get(33);
	
	String Add = convertedWords.get(34);
	String Edit = convertedWords.get(35);
	String Save = convertedWords.get(36);
	String Cancel = convertedWords.get(37);
	String Next = convertedWords.get(38);
	
	String NoRecordsFound = convertedWords.get(39);
	String ClearFilterData = convertedWords.get(40);
	String SelectSingleRow = convertedWords.get(41); 
		
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>Accident Analysis</title>		
	</head>	    
  
  	<body onload="refresh();" >
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   	<script>
    var outerPanel;
    var ctsb;
    var title;
    var myWin;
    var buttonValue;
    var dtprev;
    var caseInfoGrid;

    //In chrome activate was slow so refreshing the page

    function refresh() {
        isChrome = window.chrome;
        if (isChrome && parent.flagAccidentAnalysis < 2) {
            setTimeout(
                function () {
                    parent.Ext.getCmp('AccidentAnalysisCasetabId').enable();
                    parent.Ext.getCmp('AccidentAnalysisCasetabId').show();
                    parent.Ext.getCmp('AccidentAnalysisCasetabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentCaseInfo.jsp'></iframe>");
                }, 0);
            parent.AccidentAnalysisTab.doLayout();
            parent.flagAccidentAnalysis = parent.flagAccidentAnalysis + 1;
        }
    }

    //***************************************Customer Store*************************************  		
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
                    custId = Ext.getCmp('custcomboId').getValue();
                    
                    parent.globalCustomerID = custId;
                    caseInfoStore.load({
                        params: {
                            clientId: custId
                        }
                    });
                    
                    vehicleNoStore.load({
                        params: {
                            CustId: <%= customerId %> ,
                            LTSPId: <%= systemId %>
                        }
                    });
                    
                    driverNameStore.load({
                        params: {
                            CustId: custId
                        }
                    });

                    accidentalTypeStore.load({
                        params: {
                            CustId: custId,
                            Type: 'AccidentType'
                        }
                    });

                    collatedWithStore.load({
                        params: {
                            CustId: custId,
                            Type: 'CollatedWith'
                        }
                    });

                    settlementStore.load({
                        params: {
                            CustId: custId,
                            Type: 'SettlementType'
                        }
                    });

                    caseStatusStore.load({
                        params: {
                            CustId: custId,
                            Type: 'CaseStatus'
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
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                    custId = Ext.getCmp('custcomboId').getValue();
                    parent.globalCustomerID = custId;
                    caseInfoStore.load({
                        params: {
                            clientId: custId
                        }
                    });

                    vehicleNoStore.load({
                        params: {
                            CustId: custId
                        }
                    });

                    driverNameStore.load({
                        params: {
                            CustId: custId
                        }
                    });

                    accidentalTypeStore.load({
                        params: {
                            CustId: custId,
                            Type: 'AccidentType'
                        }
                    });

                    collatedWithStore.load({
                        params: {
                            CustId: custId,
                            Type: 'CollatedWith'
                        }
                    });

                    settlementStore.load({
                        params: {
                            CustId: custId,
                            Type: 'SettlementType'
                        }
                    });

                    caseStatusStore.load({
                        params: {
                            CustId: custId,
                            Type: 'CaseStatus'
                        }
                    });
                }
            }
        }
    });

    var vehicleNoStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getVehicleNo',
        id: 'VehicleNoStoreId',
        root: 'VehicleNoRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['VehicleNo']
    });

    var vehicleCombo = new Ext.form.ComboBox({
        store: vehicleNoStore,
        id: 'vehicleComboId',
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
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });

    var driverNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getDriverNames',
        id: 'DriverNameStoreId',
        root: 'DriverNameRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['DriverId', 'DriverName']
    });

    var driverCombo = new Ext.form.ComboBox({
        store: driverNameStore,
        id: 'driverComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectDriverName%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'DriverId',
        displayField: 'DriverName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });

    var accidentalTypeStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'accidentTypeStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var accidentalTypeCombo = new Ext.form.ComboBox({
        store: accidentalTypeStore,
        id: 'accidentalTypeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectAccidentalType%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });

    var collatedWithStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'collatedWithStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var collatedWithCombo = new Ext.form.ComboBox({
        store: collatedWithStore,
        id: 'collatedWithComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCollatedWith%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                    var collatedWithWhat = Ext.getCmp('collatedWithComboId').getValue();
                    if (collatedWithWhat == 4) {
                        Ext.getCmp('secondPanelId').show();
                    } else {
                        Ext.getCmp('secondPanelId').hide();
                        Ext.getCmp('assetToAssetVehicleId').reset();
                        Ext.getCmp('assetToAssetDriverId').reset();
                    }
                }
            }
        }
    });

    var settlementStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'settlementStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var settlementCombo = new Ext.form.ComboBox({
        store: settlementStore,
        id: 'settlementComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectSettlement%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });

    var caseStatusStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'caseStatusStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var caseStatusCombo = new Ext.form.ComboBox({
        store: caseStatusStore,
        id: 'caseStatusComboId',
        mode: 'local',
        forceSelection: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        displayField: 'name',
        emptyText: '<%=SelectCaseStatus%>',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });
    
    var firstPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'firstPanelId',
        layout: 'table',
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 3,
            tableAttrs: {
                style: {
                    width: '100%'
                }
            }
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCaseNumber'
            }, {
                xtype: 'label',
                text: '<%=CaseNumber%>  :',
                cls: 'labelstyle',
                id: 'caseNumberLableId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterCaseNumber%>',
                blankText: '<%=EnterCaseNumber%>',
                allowBlank: true,
                id: 'caseNumberId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAssetNumber'
            }, {
                xtype: 'label',
                text: '<%=AssetNumber%>  :',
                cls: 'labelstyle',
                id: 'assetNumberLabelId'
            },
            vehicleCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryDriverName'
            }, {
                xtype: 'label',
                text: '<%=DriverName%>  :',
                cls: 'labelstyle',
                id: 'driverNameLabelId'
            },
            driverCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAccidentalType'
            }, {
                xtype: 'label',
                text: '<%=AccidentalType%>  :',
                cls: 'labelstyle',
                id: 'accidentalTypeLabelId'
            },
            accidentalTypeCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCollatedWith'
            }, {
                xtype: 'label',
                text: '<%=CollatedWith%>  :',
                cls: 'labelstyle',
                id: 'collatedWithLabelId'
            },
            collatedWithCombo
        ]
    }); // End of Panel

    var secondPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'secondPanelId',
        layout: 'table',
        frame: false,
        hidden: true,
        items: [{
            xtype: 'fieldset',
            title: '<%=AssetToAsset%>',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 3,
                tableAttrs: {
                    style: {
                        width: '80%'
                    }
                }
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAssetToAssetVehicle'
            }, {
                xtype: 'label',
                text: '<%=AssetToAsset%>  :',
                cls: 'labelstyle',
                id: 'assetToAssetVehicleLableId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterAssetNumber%>',
                blankText: '<%=EnterAssetNumber%>',
                allowBlank: true,
                id: 'assetToAssetVehicleId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAssetToAssetDriver'
            }, {
                xtype: 'label',
                text: '<%=DriverName%>  :',
                cls: 'labelstyle',
                id: 'assetToAssetDriverLableId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterDriverName%>',
                blankText: '<%=EnterDriverName%>',
                allowBlank: true,
                id: 'assetToAssetDriverId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }]
        }]
    }); // End of Panel

    var thirdPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'thirdPanelId',
        layout: 'table',
        frame: false,
        width: 500,
        layout: 'table',
        layoutConfig: {
            columns: 3,
            tableAttrs: {
                style: {
                    width: '80%'
                }
            }
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryOtherDetails'
            }, {
                xtype: 'label',
                text: '<%=Remarks%>  :',
                cls: 'labelstyle',
                id: 'otherDetailsLableId'
            }, {
                xtype: 'textarea',
                cls: 'selectstylePerfect',
                allowBlank: true,
                id: 'otherDetailsId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryLocation'
            }, {
                xtype: 'label',
                text: '<%=Location%>  :',
                cls: 'labelstyle',
                id: 'locationLableId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterLocation%>',
                blankText: '<%=EnterLocation%>',
                allowBlank: true,
                id: 'locationId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryDateTime'
            }, {
                xtype: 'label',
                text: '<%=DateTime%>  :',
                cls: 'labelstyle',
                id: 'dateTimeLabelId'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateTimeFormat(),
                emptyText: '<%=SelectDate%>',
                allowBlank: false,
                blankText: '<%=SelectDate%>',
                id: 'dateTimeId',
                value: dtprev,
                vtype: 'daterange'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryLossOfLive'
            }, {
                xtype: 'label',
                text: '<%=LossOfLife%>  :',
                cls: 'labelstyle',
                id: 'lossofLiveLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: false,
                allowNegative: false,
				value: 0,
                cls: 'selectstylePerfect',
                maxLength: 20,
                id: 'lossOfLifeId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryInjured'
            }, {
                xtype: 'label',
                text: '<%=Injured%>  :',
                cls: 'labelstyle',
                id: 'linjuredLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: false,
                allowNegative: false,
				value: 0,
                cls: 'selectstylePerfect',
                maxLength: 20,
                id: 'injuredId'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryInsuranceClaimedAmount'
            }, {
                xtype: 'label',
                text: '<%=InsuranceClaimedAmount%>  :',
                cls: 'labelstyle',
                id: 'insuranceClaimedAmountLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterInsuranceAmount%>',
                blankText: '<%=EnterInsuranceAmount%>',
                allowBlank: false,
                maxLength: 20,
                id: 'insuranceClaimedAmountId'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryFaultyVehicle'
            }, {
                xtype: 'label',
                text: '<%=FaultyVehicle%>  :',
                cls: 'labelstyle',
                id: 'faultyLabelId'
            }, {
                xtype: 'radiogroup',
                cls: 'selectstylePerfect',
                id: 'faultyVehicleId',
                items: [{
                    boxLabel: 'Ours',
                    name: 'rb-auto',
                    id: 'faultyOursId',
                    inputValue: 'Ours',
                    checked: true
                }, {
                    boxLabel: 'Others',
                    name: 'rb-auto',
                    id: 'faultyOthersId',
                    inputValue: 'Others'
                }]
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorySettlement'
            }, {
                xtype: 'label',
                text: '<%=Settlement%>  :',
                cls: 'labelstyle',
                id: 'settlementLabelId'
            },
            settlementCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCaseStatus'
            }, {
                xtype: 'label',
                text: '<%=CaseStatus%>  :',
                cls: 'labelstyle',
                id: 'caseStatusLabelId'
            },
            caseStatusCombo
        ]
    }); // End of Panel

    var caseInnerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 400,
        width: '100%',
        frame: true,
        id: 'addCaseInfo',
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [{
            xtype: 'fieldset',
            title: '<%=CaseInformation%>',
            collapsible: false,
            colspan: 3,
            width: 500,
            id: 'caseinfopanelid',
            layout: 'table',
            layoutConfig: {
                columns: 1,
            },

            items: [firstPanel, secondPanel, thirdPanel]
        }]
    });

    /****************window static button panel****************************/
    var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        cls: 'windowbuttonpanel',
        frame: true,
        height: 50,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            width: 280
        }, {
            xtype: 'button',
            text: '<%=Save%>',
            id: 'addButtId',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {
                        if (Ext.getCmp('caseNumberId').getValue() == "") {
                            Ext.example.msg("<%=EnterCaseNumber%>");
                            Ext.getCmp('caseNumberId').focus();
                            return;
                        }
                        if (Ext.getCmp('vehicleComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectAssetNumber%>");
                            Ext.getCmp('vehicleComboId').focus();
                            return;
                        }
                        if (Ext.getCmp('driverComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectDriverName%>");
                            Ext.getCmp('driverComboId').focus();
                            return;
                        }
                        if (Ext.getCmp('accidentalTypeComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectAccidentalType%>");
                            Ext.getCmp('accidentalTypeComboId').focus();
                            return;
                        }
                        if (Ext.getCmp('collatedWithComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectCollatedWith%>");
                            Ext.getCmp('collatedWithComboId').focus();
                            return;
                        }

                        if (Ext.getCmp('collatedWithComboId').getValue() == 1) {
                            if (Ext.getCmp('assetToAssetVehicleId').getValue() == "") {
                                Ext.example.msg("<%=EnterAssetNumber%>");
                                Ext.getCmp('assetToAssetVehicleId').focus();
                                return;
                            }

                            if (Ext.getCmp('assetToAssetDriverId').getValue() == "") {
                                Ext.example.msg("<%=EnterDriverName%>");
                                Ext.getCmp('assetToAssetDriverId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('dateTimeId').getValue() == "") {
                            Ext.example.msg("<%=SelectDate%>");
                            Ext.getCmp('dateTimeId').focus();
                            return;
                        }
                   
                        if (Ext.getCmp('settlementComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectSettlement%>");
                            Ext.getCmp('settlementComboId').focus();
                            return;
                        }

                        if (Ext.getCmp('caseStatusComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectCaseStatus%>");
                            Ext.getCmp('caseStatusComboId').focus();
                            return;
                        }
                        var caseIdPrefix;
                        if (buttonValue == "modify") {
                            var selected = caseInfoGrid.getSelectionModel().getSelected();
                            caseIdPrefix = selected.get('caseId');
                        }

                        var buttonPanel = Ext.getCmp('winbuttonid');
                        buttonPanel.getEl().mask();

                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=saveAccidentCaseInformation',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                customerIdParam: Ext.getCmp('custcomboId').getValue(),
                                caseIdParam: caseIdPrefix,
                                caseNumberParam: Ext.getCmp('caseNumberId').getValue(),
                                AssetNoParam: Ext.getCmp('vehicleComboId').getValue(),
                                DriverNameParam: Ext.getCmp('driverComboId').getValue(),
                                AccidentalTypeParam: Ext.getCmp('accidentalTypeComboId').getValue(),
                                CollatedWithParam: Ext.getCmp('collatedWithComboId').getValue(),
                                AssetToAssetVehicleParam: Ext.getCmp('assetToAssetVehicleId').getValue(),
                                AssetToAssetDriverNameParam: Ext.getCmp('assetToAssetDriverId').getValue(),
                                OtherDetailsParam: Ext.getCmp('otherDetailsId').getValue(),
                                LocationParam: Ext.getCmp('locationId').getValue(),
                                DateTimeParam: Ext.getCmp('dateTimeId').getValue(),
                                LossOfLifeParam: Ext.getCmp('lossOfLifeId').getValue(),
                                InjuredParam: Ext.getCmp('injuredId').getValue(),
                                InsuranceClaimedAmtparam: Ext.getCmp('insuranceClaimedAmountId').getValue(),
                                FaultyVehicleParam: Ext.getCmp('faultyVehicleId').items.get(0).getGroupValue(),
                                SettlementParam: Ext.getCmp('settlementComboId').getValue(),
                                CaseStatusParam: Ext.getCmp('caseStatusComboId').getValue()

                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                caseInfoStore.load({
                            		params: {
                                		clientId: custId
                            		}
                            	});
                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                }
                        });

                        caseInfoStore.load({
                            params: {
                                clientId: custId
                            },
                            callback: function () {
                                Ext.getCmp('caseNumberId').reset();
                                Ext.getCmp('vehicleComboId').reset();
                                Ext.getCmp('driverComboId').reset();
                                Ext.getCmp('accidentalTypeComboId').reset();
                                Ext.getCmp('collatedWithComboId').reset();
                                Ext.getCmp('otherDetailsId').reset();
                                Ext.getCmp('locationId').reset();
                                Ext.getCmp('dateTimeId').reset();
                                Ext.getCmp('lossOfLifeId').reset();
                        		Ext.getCmp('injuredId').reset();
                                Ext.getCmp('insuranceClaimedAmountId').reset();
                                Ext.getCmp('faultyVehicleId').reset();
                                //Ext.getCmp('faultyOthersId').reset();
                                Ext.getCmp('settlementComboId').reset();
                                Ext.getCmp('caseStatusComboId').reset();
                                Ext.getCmp('assetToAssetVehicleId').reset();
                                Ext.getCmp('assetToAssetDriverId').reset();
                                Ext.getCmp('secondPanelId').hide();
                                myWin.hide();
                                buttonPanel.getEl().unmask();

                                Ext.getCmp('caseNumberId').enable();
                                Ext.getCmp('vehicleComboId').enable();
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
            width: '80',
            listeners: {
                click: {
                    fn: function () {
                        Ext.getCmp('caseNumberId').reset();
                        Ext.getCmp('vehicleComboId').reset();
                        Ext.getCmp('driverComboId').reset();
                        Ext.getCmp('accidentalTypeComboId').reset();
                        Ext.getCmp('collatedWithComboId').reset();
                        Ext.getCmp('otherDetailsId').reset();
                        Ext.getCmp('locationId').reset();
                        Ext.getCmp('dateTimeId').reset();
                        Ext.getCmp('lossOfLifeId').reset();
                        Ext.getCmp('injuredId').reset();
                        Ext.getCmp('insuranceClaimedAmountId').reset();
                        Ext.getCmp('faultyVehicleId').reset();
                        //Ext.getCmp('faultyOthersId').reset();
                        Ext.getCmp('settlementComboId').reset();
                        Ext.getCmp('caseStatusComboId').reset();
                        Ext.getCmp('assetToAssetVehicleId').reset();
                        Ext.getCmp('assetToAssetDriverId').reset();
                        Ext.getCmp('secondPanelId').hide();
                        var buttonPanel = Ext.getCmp('winbuttonid');
                        buttonPanel.getEl().unmask();
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
        items: [caseInnerPanel, winButtonPanel]
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

    function modifyData() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }

        if (caseInfoGrid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (caseInfoGrid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        buttonValue = "modify";
        title = '<%=EditCaseInformation%>';
        myWin.setPosition(400, 12);
        myWin.setTitle(title);
        myWin.show();

        Ext.getCmp('caseNumberId').disable();
        Ext.getCmp('vehicleComboId').disable();

        var selected = caseInfoGrid.getSelectionModel().getSelected();
        Ext.getCmp('caseNumberId').setValue(selected.get('caseNumber'));
        Ext.getCmp('vehicleComboId').setValue(selected.get('assetNumber'));
        Ext.getCmp('driverComboId').setValue(selected.get('IdDriverName'));
        Ext.getCmp('accidentalTypeComboId').setValue(selected.get('IdAccidentalType'));
        Ext.getCmp('collatedWithComboId').setValue(selected.get('IdCollatedWith'));
        if (selected.get('collatedWith') == "Asset - Asset") {
            Ext.getCmp('secondPanelId').show();
        } else {
            Ext.getCmp('secondPanelId').hide();
        }
        Ext.getCmp('otherDetailsId').setValue(selected.get('otherDetails'));
        Ext.getCmp('locationId').setValue(selected.get('location'));
        Ext.getCmp('dateTimeId').setValue(selected.get('date'));
        Ext.getCmp('lossOfLifeId').setValue(selected.get('lossOfLife'));
        Ext.getCmp('injuredId').setValue(selected.get('injured'));
        Ext.getCmp('insuranceClaimedAmountId').setValue(selected.get('insuranceClaimedAmount'));

        if (selected.get('faultyVehicle') == "Ours") {
            Ext.getCmp('faultyVehicleId').items.items[0].setValue(true);
            Ext.getCmp('faultyVehicleId').items.items[1].setValue(false)

        } else {
            Ext.getCmp('faultyVehicleId').items.items[0].setValue(false);
            Ext.getCmp('faultyVehicleId').items.items[1].setValue(true)
        }
        Ext.getCmp('settlementComboId').setValue(selected.get('IdSettlement'));
        Ext.getCmp('caseStatusComboId').setValue(selected.get('IdCaseStatus'));
        Ext.getCmp('assetToAssetVehicleId').setValue(selected.get('otherAssetNumber'));
        Ext.getCmp('assetToAssetDriverId').setValue(selected.get('otherDriverName'));
    }

    function addRecord() {

        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        
        Ext.getCmp('caseNumberId').enable();
        Ext.getCmp('vehicleComboId').enable();
        
        buttonValue = "add";
        title = '<%=AddCaseInformation%>';
        myWin.setPosition(400, 12);
        myWin.show();
        myWin.setTitle(title);
    }

	

    function onCellClickOnGrid(caseInfoGrid, rowIndex, columnIndex, e) {


        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }

        parent.Ext.getCmp('AccidentAnalysisCompensationtabId').enable(true);

        if (caseInfoGrid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (caseInfoGrid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }

        if (caseInfoGrid.getSelectionModel().getCount() == 1) {
            var selected = caseInfoGrid.getSelectionModel().getSelected();
            parent.caseInfoCaseNumber = selected.get('caseId');
            parent.caseInfoVehicleNumber = selected.get('assetNumber');         
                  	
        }
    }
    
    var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'AccidentCaseInformationRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'caseId'
        }, {
            name: 'caseNumber'
        }, {
            name: 'assetNumber'
        }, {
            name: 'driverName'
        }, {
            name: 'accidentalType'
        }, {
            name: 'collatedWith'
        }, {
            name: 'date',
            type: 'date',
            dateFormat: getDateTimeFormat()
        }, {
            name: 'insuranceClaimedAmount'
        }, {
            name: 'settlement'
        }, {
            name: 'caseStatus'
        }, {
            name: 'otherDetails'
        }, {
            name: 'location'
        }, {
            name: 'faultyVehicle'
        }, {
            name: 'otherAssetNumber'
        }, {
            name: 'otherDriverName'
        }, {
            name: 'IdDriverName'
        }, {
            name: 'IdAccidentalType'
        }, {
            name: 'IdCollatedWith'
        }, {
            name: 'IdSettlement'
        }, {
            name: 'IdCaseStatus'
        }, {
            name: 'lossOfLife'
        }, {
            name: 'injured'
        }]
    });

    var caseInfoStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentCaseInformation',
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
            dataIndex: 'caseId'
        }, {
            type: 'string',
            dataIndex: 'caseNumber'
        }, {
            type: 'string',
            dataIndex: 'assetNumber'
        }, {
            type: 'string',
            dataIndex: 'driverName'
        }, {
            type: 'string',
            dataIndex: 'accidentalType'
        }, {
            type: 'string',
            dataIndex: 'collatedWith'
        }, {
            type: 'date',
            dataIndex: 'date'
        }, {
            type: 'float',
            dataIndex: 'insuranceClaimedAmount'
        }, {
            type: 'string',
            dataIndex: 'settlement'
        }, {
            type: 'string',
            dataIndex: 'caseStatus'
        }, {
            type: 'string',
            dataIndex: 'otherDetails'
        }, {
            type: 'string',
            dataIndex: 'location'
        }, {
            type: 'string',
            dataIndex: 'faultyVehicle'
        }, {
            type: 'string',
            dataIndex: 'otherAssetNumber'
        }, {
            type: 'string',
            dataIndex: 'otherDriverName'
        }]
    });

    //************************************Column Model Config******************************************
    var createColModel = function (finish, start) {

        var columns = [
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
                header: "<span style=font-weight:bold;><%=CaseNumber%></span>",
                dataIndex: 'caseNumber',
                width: 120,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
                dataIndex: 'assetNumber',
                width: 130,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=DriverName%></span>",
                dataIndex: 'driverName',
                width: 120,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=AccidentalType%></span>",
                dataIndex: 'accidentalType',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=CollatedWith%></span>",
                dataIndex: 'collatedWith',
                filter: {
                    type: 'string'
                }
            }, {
                dataIndex: 'date',
                header: "<span style=font-weight:bold;><%=DateTime%></span>",
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                width: 100,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=InsuranceClaimedAmount%></span>",
                dataIndex: 'insuranceClaimedAmount',
                width: 140,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Settlement%></span>",
                dataIndex: 'settlement',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=CaseStatus%></span>",
                dataIndex: 'caseStatus',
                width: 80,
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

    caseInfoGrid = getGrid('<%=CaseInfoDetails%>', '<%=NoRecordsFound%>', caseInfoStore, screen.width - 55, 400, 16, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '', '', '', false, '', true, '<%=Add%>', true, '<%=Edit%>');

    caseInfoGrid.on({
        "cellclick": {
            fn: onCellClickOnGrid
        }
    });

    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 2
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo
        ]
    }); // End of Panel	
    
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
            				Ext.example.msg("<%=SelectCustomer%>");
            				Ext.getCmp('custcomboId').focus();
            				return;
        				}

        				parent.Ext.getCmp('AccidentAnalysisCompensationtabId').enable(true);

        				if (caseInfoGrid.getSelectionModel().getCount() == 0) {
            				Ext.example.msg("<%=SelectSingleRow%>");
            				return;
        				}
        			
        				if (caseInfoGrid.getSelectionModel().getCount() > 1) {
            				Ext.example.msg("<%=SelectSingleRow%>");
            				return;
        				}

        				if (caseInfoGrid.getSelectionModel().getCount() == 1) {
            				var selected = caseInfoGrid.getSelectionModel().getSelected();
            				parent.caseInfoCaseNumber = selected.get('caseId');
            				parent.caseInfoVehicleNumber = selected.get('assetNumber');         
                  			
                  			parent.Ext.getCmp('AccidentAnalysisCompensationtabId').enable();
							parent.Ext.getCmp('AccidentAnalysisCompensationtabId').show();
							parent.Ext.getCmp('AccidentAnalysisCompensationtabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/AccidentAnalysis/AccidentCompensationInfo.jsp'></iframe>");
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
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [innerPanel, caseInfoGrid, nextButtonPanel]
            //bbar: ctsb
        });
    });
</script>
  	</body>
</html>