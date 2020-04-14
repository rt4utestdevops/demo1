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

	ArrayList<String> tobeConverted = new ArrayList<String>();	
	
	tobeConverted.add("Case_Number");	
	tobeConverted.add("Select_Case_Number");
	
	tobeConverted.add("SLNO");	
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Reference_Number");
	tobeConverted.add("Enter_Reference_Number");
	tobeConverted.add("Compensation_Type");
	tobeConverted.add("Select_Compensation_Type");
	tobeConverted.add("Mode_Of_Transaction");
	tobeConverted.add("Select_Mode_Of_Transaction");
	tobeConverted.add("Transaction_Type");
	tobeConverted.add("Select_Transaction_Type");
	tobeConverted.add("Transaction_Date");
	tobeConverted.add("Select_Transaction_Date");
	tobeConverted.add("Transaction_Amount");
	tobeConverted.add("Enter_Transaction_Amount");
	tobeConverted.add("Transaction_Number");
	tobeConverted.add("Enter_Transaction_Number");
	tobeConverted.add("Next_Hearing_Date");
	tobeConverted.add("Select_Next_Hearing_Date");
	
	tobeConverted.add("Compensation_Information");	
	tobeConverted.add("Add_Compensation_Information");	
	tobeConverted.add("Edit_Compensation_Information");	
	tobeConverted.add("Add");
	tobeConverted.add("Edit");
	tobeConverted.add("Save");
	tobeConverted.add("Cancel");	
	tobeConverted.add("Back");
	
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	
	tobeConverted.add("Enter_Compensation_Paid_In");
	tobeConverted.add("Enter_Compensation_Paid_Out");
	tobeConverted.add("Enter_Internal_Expenses");
	tobeConverted.add("Compensation_Paid_In");
	tobeConverted.add("Compensation_Paid_Out");
	tobeConverted.add("Internal_Expenses");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	String CaseNumber = convertedWords.get(0);
	String SelectCaseNumber = convertedWords.get(1);;
	
	String SlNo = convertedWords.get(2);	
	String AssetNumber = convertedWords.get(3);
	String ReferenceNumber = convertedWords.get(4);
	String EnterReferenceNumber = convertedWords.get(5);
	String CompensationType = convertedWords.get(6);
	String SelectCompensationType  = convertedWords.get(7);
	String ModeOfTransaction = convertedWords.get(8);
	String SelectModeOfTransaction = convertedWords.get(9);
	String TransactionType = convertedWords.get(10);
	String SelectTransactionType = convertedWords.get(11);
	String TransactionDateTime = convertedWords.get(12);
	String SelectTransactionDateTime = convertedWords.get(13);
	String TransactionAmount = convertedWords.get(14);
	String EnterTransactionAmount = convertedWords.get(15);
	String CheckOrDD = convertedWords.get(16);
	String EnterCheckOrDD = convertedWords.get(17);
	String NextHearingDate = convertedWords.get(18);
	String SelectNextHearingDate = convertedWords.get(19);
	
	
	String CompensationInformation = convertedWords.get(20);
	String AddCompensationInformation  = convertedWords.get(21);
	String EditCompensationInformation = convertedWords.get(22);
	String Add = convertedWords.get(23);
	String Edit = convertedWords.get(24);
	String Save = convertedWords.get(25);
	String Cancel = convertedWords.get(26);
	String Back = convertedWords.get(27);
	
	String NoRecordsFound = convertedWords.get(28);
	String ClearFilterData = convertedWords.get(29);
	String SelectSingleRow = convertedWords.get(30);	
	
	String EnterCompensationPaidIn = convertedWords.get(31);
	String EnterCompensationPaidOut = convertedWords.get(32);
	String EnterInternalExpenses = convertedWords.get(33);
	String CompensationPaidIn = convertedWords.get(34);
	String CompensationPaidOut = convertedWords.get(35);
	String InternalExpenses = convertedWords.get(36);		
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title></title>		
	</head>	    
  
  	<body>
  	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
  	
   	<script>
    var outerPanel;
    var ctsb;
    var compensationTitle;
    var compensationMyWin;
    var compensationButtonValue;
    var dtprev;
    var compositionInfoGrid;
    var caseId;
    var globalCustomerId = parent.globalCustomerID;
	var caseInfoCaseNumber = parent.caseInfoCaseNumber;
	var caseInfoAssetNumber = parent.caseInfoVehicleNumber;
	
	var caseNumberStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getCaseNumber',
        id: 'CaseNumberStoreId',
        root: 'CaseNumberRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CaseId', 'CaseNumber']
    });
    
    caseNumberStore.on('beforeload',function(store, operation,eOpts){
   				operation.params={
          	    	CustId : globalCustomerId
          	    };
    });
    
    caseNumberStore.on('load',function(store, operation,eOpts){  	    
          	    Ext.getCmp('caseNumberComboId').setValue(caseInfoCaseNumber);
          	    Ext.getCmp('compensationCaseNumberId').setText(Ext.getCmp('caseNumberComboId').getRawValue());
          	    Ext.getCmp('compensationAssetNumberId').setText(caseInfoAssetNumber);
          	    compensationInfoStore.load({
                        params: {
                            caseIdParam: caseInfoCaseNumber,
                            CustId: globalCustomerId
                        }
                    });
                    
                    compensationTypeStore.load({
                        params: {
                            CustId: globalCustomerId,
                            Type: 'CompensationType'
                        }
                    });
                    
                    modeOfTransactionStore.load({
                        params: {
                            CustId: globalCustomerId,
                            Type: 'ModeOfTransaction'
                        }
                    });
                    
                    transactionTypeStore.load({
                        params: {
                            CustId: globalCustomerId,
                            Type: 'TransactionType'
                        }
                    });
	},this);

    var caseNumberCombo = new Ext.form.ComboBox({
        store: caseNumberStore,
        id: 'caseNumberComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCaseNumber%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'CaseId',
        displayField: 'CaseNumber',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                    caseId = Ext.getCmp('caseNumberComboId').getValue();
                    Ext.getCmp('compensationCaseNumberId').setText(Ext.getCmp('caseNumberComboId').getRawValue());
                    compensationInfoStore.load({
                        params: {
                            caseIdParam: caseId,
                            CustId: globalCustomerId
                        }
                    });
                }
            }
        }
    });

    
    var compensationTypeStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'compensationTypeStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var compensationTypeCombo = new Ext.form.ComboBox({
        store: compensationTypeStore,
        id: 'compensationTypeComboId',
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
        emptyText: '<%=SelectCompensationType%>',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });
    
    var modeOfTransactionStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'modeOfTransactionStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var modeOfTransactionCombo = new Ext.form.ComboBox({
        store: modeOfTransactionStore,
        id: 'modeOfTransactionComboId',
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
        emptyText: '<%=SelectModeOfTransaction%>',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });
    
    var transactionTypeStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentLookUpMaster',
        id: 'transactionTypeStoreId',
        root: 'typeRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['id', 'name']
    });

    var transactionTypeCombo = new Ext.form.ComboBox({
        store: transactionTypeStore,
        id: 'transactionTypeComboId',
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
        emptyText: '<%=SelectTransactionType%>',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {

                }
            }
        }
    });

	var compensationInnerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 350,
        width: 540,
        frame: true,
        id: 'addCompensationInfo',
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [{
            xtype: 'fieldset',
            title: '<%=CompensationInformation%>',
            collapsible: false,
            colspan: 3,
            width: 510,
            id: 'compensationinfopanelid',
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
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCompensationCaseNumber'
            }, {
                xtype: 'label',
                text: '<%=CaseNumber%>  :',
                cls: 'labelstyle',
                id: 'compensationCaseNumberLableId'
            }, {
                xtype: 'label',
                id: 'compensationCaseNumberId',
                 cls: 'labelBoldFontPerfect'
            }, {height:10 },{height:10 },{height:10 }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCompensationAssetNumber'
            }, {
                xtype: 'label',
                text: '<%=AssetNumber%>  :',
                cls: 'labelstyle',
                id: 'compensationAssetNumberLabelId'
            }, {
                xtype: 'label',
                id: 'compensationAssetNumberId',
                 cls: 'labelBoldFontPerfect'
            }, {height:10 },{height:10 },{height:10 }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryReferenceNumber'
            }, {
                xtype: 'label',
                text: '<%=ReferenceNumber%>  :',
                cls: 'labelstyle',
                id: 'referenceNumberLableId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterReferenceNumber%>',
                blankText: '<%=EnterReferenceNumber%>',
                allowBlank: true,
                id: 'referenceNumberId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCompensationType'
            }, {
                xtype: 'label',
                text: '<%=CompensationType%>  :',
                cls: 'labelstyle',
                id: 'compensationTypeLabelId'
            },
            compensationTypeCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryModeOfTransaction'
            }, {
                xtype: 'label',
                text: '<%=ModeOfTransaction%>  :',
                cls: 'labelstyle',
                id: 'modeOfTransactionLabelId'
            },
            modeOfTransactionCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTransactionType'
            }, {
                xtype: 'label',
                text: '<%=TransactionType%>  :',
                cls: 'labelstyle',
                id: 'transactionTypeLabelId'
            },
            transactionTypeCombo, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTransactionDateTime'
            }, {
                xtype: 'label',
                text: '<%=TransactionDateTime%>  :',
                cls: 'labelstyle',
                id: 'transactionDateTimeLabelId'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateTimeFormat(),
                emptyText: '<%=SelectTransactionDateTime%>',
                allowBlank: false,
                blankText: '<%=SelectTransactionDateTime%>',
                id: 'transactionDateTimeId',
                value: dtprev,
                vtype: 'daterange'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTransactionAmount'
            }, {
                xtype: 'label',
                text: '<%=TransactionAmount%>  :',
                cls: 'labelstyle',
                id: 'transactionAmountLabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterTransactionAmount%>',
                blankText: '<%=EnterTransactionAmount%>',
                allowBlank: false,
                maxLength: 20,
                id: 'transactionAmountId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycheckOrDD'
            }, {
                xtype: 'label',
                text: '<%=CheckOrDD%>  :',
                cls: 'labelstyle',
                id: 'checkOrDDLableId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterCheckOrDD%>',
                blankText: '<%=EnterCheckOrDD%>',
                allowBlank: true,
                id: 'checkOrDDId',
                listeners: {
                    change: function (field, newValue, oldValue) {
                        field.setValue(newValue.toUpperCase().trim());
                    }
                }
            },
            
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCompensationPaidIn'
            }, {
                xtype: 'label',
                text: '<%=CompensationPaidIn%>  :',
                cls: 'labelstyle',
                id: 'transactionPaidInlabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterCompensationPaidIn%>',
                blankText: '<%=EnterCompensationPaidIn%>',
                allowBlank: false,
                maxLength: 20,
                id: 'compensationPaidinId'
            }, 
            
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCompensationPaidOut'
            }, {
                xtype: 'label',
                text: '<%=CompensationPaidOut%>  :',
                cls: 'labelstyle',
                id: 'compensationPaidOutlabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterCompensationPaidOut%>',
                blankText: '<%=EnterCompensationPaidOut%>',
                allowBlank: false,
                maxLength: 20,
                id: 'compensationPaidOutId'
            },
            
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryInternalExpenses'
            }, {
                xtype: 'label',
                text: '<%=InternalExpenses%>  :',
                cls: 'labelstyle',
                id: 'internalExpenseslabelId'
            }, {
                xtype: 'numberfield',
                allowDecimals: true,
                allowNegative: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterInternalExpenses%>',
                blankText: '<%=EnterInternalExpenses%>',
                allowBlank: false,
                maxLength: 20,
                id: 'internalExpensesId'
            },
            
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryNextHearingDate'
            }, {
                xtype: 'label',
                text: '<%=NextHearingDate%>  :',
                cls: 'labelstyle',
                id: 'nextHearingDateLabelId'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=SelectNextHearingDate%>',
                allowBlank: true,
                blankText: '<%=SelectNextHearingDate%>',
                id: 'nextHearingDateId',
                value: dtprev,
                vtype: 'daterange'
            }]
       	}]
    });

    /****************window static button panel****************************/
    var compensationWinButtonPanel = new Ext.Panel({
        id: 'compensationwinbuttonid',
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
            id: 'addCompensationButtId',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {
                        
                        if (Ext.getCmp('compensationTypeComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectCompensationType%>");
                            Ext.getCmp('compensationTypeComboId').focus();
                            return;
                        }
                        if (Ext.getCmp('modeOfTransactionComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectModeOfTransaction%>");
                            Ext.getCmp('modeOfTransactionComboId').focus();
                            return;
                        }
                        if (Ext.getCmp('transactionTypeComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectTransactionType%>");
                            Ext.getCmp('transactionTypeComboId').focus();
                            return;
                        }

                        if (Ext.getCmp('transactionDateTimeId').getValue() == "") {
                            Ext.example.msg("<%=SelectTransactionDateTime%>");
                            Ext.getCmp('transactionDateTimeId').focus();
                            return;
                        }
                        if (Ext.getCmp('transactionAmountId').getValue() == "") {
                            Ext.example.msg("<%=EnterTransactionAmount%>");
                            Ext.getCmp('transactionAmountId').focus();
                            return;
                        }
                        
                        if (Ext.getCmp('compensationPaidinId').getRawValue() == "") {
                            Ext.example.msg("<%=EnterCompensationPaidIn%>");
                            Ext.getCmp('compensationPaidinId').focus();
                            return;
                        }
                        
                        if (Ext.getCmp('compensationPaidOutId').getRawValue() == "") {
                            Ext.example.msg("<%=EnterCompensationPaidOut%>");
                            Ext.getCmp('compensationPaidOutId').focus();
                            return;
                        }
                        
                        if (Ext.getCmp('internalExpensesId').getRawValue() == "") {
                            Ext.example.msg("<%=EnterInternalExpenses%>");
                            Ext.getCmp('internalExpensesId').focus();
                            return;
                        }
                        
                        if (compensationInnerPanel.getForm().isValid()) {
                        
                        var compensationIdPrefix;
                        if (compensationButtonValue == "modify") {
                            var selected = compensationInfoGrid.getSelectionModel().getSelected();
                            compensationIdPrefix = selected.get('compensationId');
                        }
                        
                        var compensationButtonPanel = Ext.getCmp('compensationwinbuttonid');
                        compensationButtonPanel.getEl().mask();

                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=saveAccidentCompensationInformation',
                            method: 'POST',
                            params: {
                                compensationButtonValue: compensationButtonValue,                               
                                CompensationIdPrefix: compensationIdPrefix,
                                customerIdParam: globalCustomerId,
                                caseIdParam: Ext.getCmp('caseNumberComboId').getValue(),
                                ReferenceNumberParam: Ext.getCmp('referenceNumberId').getValue(),
                                CompensationTypeParam: Ext.getCmp('compensationTypeComboId').getValue(),
                                ModeOfTransactionParam: Ext.getCmp('modeOfTransactionComboId').getValue(),
                                TransactionTypeParam: Ext.getCmp('transactionTypeComboId').getValue(),
                                TransactionDateTimeParam: Ext.getCmp('transactionDateTimeId').getValue(),
                                TransactionAmtparam: Ext.getCmp('transactionAmountId').getValue(),
                                CheckOrDDParam: Ext.getCmp('checkOrDDId').getValue(),
                                CompensationPaidIn: Ext.getCmp('compensationPaidinId').getValue(),
                                CompensationPaidOut: Ext.getCmp('compensationPaidOutId').getValue(),
                                InternalExpenses: Ext.getCmp('internalExpensesId').getValue(),
                                NextHearingDateParam: Ext.getCmp('nextHearingDateId').getValue()

                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                compensationInfoStore.load({
                            		params: {
                            			caseIdParam: caseInfoCaseNumber,
                                		CustId: globalCustomerId
                            		}
                            	});
                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                }
                        });

                        compensationInfoStore.load({
                            params: {
                            	caseIdParam: caseInfoCaseNumber,
                                CustId: globalCustomerId
                            },
                            callback: function () {
                                Ext.getCmp('referenceNumberId').reset();
                        		Ext.getCmp('compensationTypeComboId').reset();
                        		Ext.getCmp('modeOfTransactionComboId').reset();
                        		Ext.getCmp('transactionTypeComboId').reset();
                        		Ext.getCmp('transactionDateTimeId').reset();
                        		Ext.getCmp('transactionAmountId').reset();
                        		Ext.getCmp('checkOrDDId').reset();
                        		Ext.getCmp('nextHearingDateId').reset();
                        		Ext.getCmp('compensationPaidinId').reset();
                        		Ext.getCmp('compensationPaidOutId').reset();
                        		Ext.getCmp('internalExpensesId').reset();
                        		compensationMyWin.hide();
                        		compensationButtonPanel.getEl().unmask();
                            }
                        });
                        }
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'compensationcanButtId',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: '80',
            listeners: {
                click: {
                    fn: function () {
                        Ext.getCmp('referenceNumberId').reset();
                        Ext.getCmp('compensationTypeComboId').reset();
                        Ext.getCmp('modeOfTransactionComboId').reset();
                        Ext.getCmp('transactionTypeComboId').reset();
                        Ext.getCmp('transactionDateTimeId').reset();
                        Ext.getCmp('transactionAmountId').reset();
                        Ext.getCmp('checkOrDDId').reset();
                        Ext.getCmp('nextHearingDateId').reset();
                        Ext.getCmp('compensationPaidinId').reset();
                        Ext.getCmp('compensationPaidOutId').reset();
                        Ext.getCmp('internalExpensesId').reset();
                        compensationMyWin.hide();
                    }
                }
            }
        }]
    });

    var compensationPanelWindow = new Ext.Panel({
        cls: 'outerpanelwindow',
        standardSubmit: true,
        frame: false,
        items: [compensationInnerPanel, compensationWinButtonPanel]
    });

    /***********************window for form field****************************/
    compensationMyWin = new Ext.Window({
        title: compensationTitle,
        closable: false,
        modal: true,
        resizable: false,
        autoScroll: false,
        cls: 'mywindow',
        id: 'compensationMyWin',
        items: [compensationPanelWindow]
    });
    
    function modifyData() {
        if (Ext.getCmp('caseNumberComboId').getValue() == "") {
            Ext.example.msg("<%=SelectCaseNumber%>");
            Ext.getCmp('caseNumberComboId').focus();
            return;
        }

        if (compensationInfoGrid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (compensationInfoGrid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        compensationButtonValue = "modify";
        compensationTitle = '<%=EditCompensationInformation%>';
        compensationMyWin.setPosition(400, 40);
        compensationMyWin.setTitle(compensationTitle);
        compensationMyWin.show();

        var selected = compensationInfoGrid.getSelectionModel().getSelected();

        Ext.getCmp('referenceNumberId').setValue(selected.get('referenceNumber'));
        Ext.getCmp('compensationTypeComboId').setValue(selected.get('IdCompensationType'));
        Ext.getCmp('modeOfTransactionComboId').setValue(selected.get('IdModeOftransaction'));
        Ext.getCmp('transactionTypeComboId').setValue(selected.get('IdTransactionType'));
        Ext.getCmp('transactionDateTimeId').setValue(selected.get('transactionDate'));
        Ext.getCmp('transactionAmountId').setValue(selected.get('transactionAmount'));
        Ext.getCmp('checkOrDDId').setValue(selected.get('checkOrDD'));
        Ext.getCmp('nextHearingDateId').setValue(selected.get('nextHearingDate'));
        Ext.getCmp('compensationPaidinId').setValue(selected.get('compensationPaidIn'));
        Ext.getCmp('compensationPaidOutId').setValue(selected.get('compensationPaidOut'));
        Ext.getCmp('internalExpensesId').setValue(selected.get('internalExpenses'));
    }
    
    function addRecord() {
         		
      compensationButtonValue = "add";
      compensationTitle = '<%=AddCompensationInformation%>';
      compensationMyWin.setPosition(400, 40);
      compensationMyWin.show();
      compensationMyWin.setTitle(compensationTitle);
    }


    var compensationInfoReader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'AccidentCompensationInformationRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'compensationId'
        }, {
            name: 'compensationCaseNumber'
        }, {
            name: 'compensationAssetNumber'
        }, {
            name: 'referenceNumber'
        }, {
            name: 'IdCompensationType'
        }, {
            name: 'compensationType'
        }, {
            name: 'IdModeOftransaction'
        }, {
            name: 'modeOfTransaction'
        }, {
            name: 'IdTransactionType'
        }, {
            name: 'transactionType'
        }, {
            name: 'transactionDate',
            type: 'date',
            dateFormat: getDateTimeFormat()
        }, {
            name: 'transactionAmount'
        }, {
            name: 'checkOrDD'
        }, {
            name: 'nextHearingDate'
        },{
            name: 'compensationPaidIn'
        },{
            name: 'compensationPaidOut'
        },{
            name: 'internalExpenses'
        }]
    });

    var compensationInfoStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AccidentAnalysis.do?param=getAccidentCompensationInformation',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darStore',
        reader: compensationInfoReader
    });


    var compensationInfoFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'compensationCaseNumber'
        }, {
            type: 'string',
            dataIndex: 'compensationAssetNumber'
        }, {
            type: 'string',
            dataIndex: 'referenceNumber'
        }, {
            type: 'string',
            dataIndex: 'compensationType'
        }, {
            type: 'string',
            dataIndex: 'modeOfTransaction'
        }, {
            type: 'string',
            dataIndex: 'transactionType'
        }, {
            type: 'date',
            dataIndex: 'transactionDate'
        }, {
            type: 'float',
            dataIndex: 'transactionAmount'
        },{
            type: 'float',
            dataIndex: 'compensationPaidIn'
        },{
            type: 'float',
            dataIndex: 'compensationPaidOut'
        },{
            type: 'float',
            dataIndex: 'internalExpenses'
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
            dataIndex: 'compensationCaseNumber',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            dataIndex: 'compensationAssetNumber',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ReferenceNumber%></span>",
            dataIndex: 'referenceNumber',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CompensationType%></span>",
            dataIndex: 'compensationType',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ModeOfTransaction%></span>",
            dataIndex: 'modeOfTransaction',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TransactionType%></span>",
            dataIndex: 'transactionType',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'transactionDate',
            header: "<span style=font-weight:bold;><%=TransactionDateTime%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            width: 140,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TransactionAmount%></span>",
            dataIndex: 'transactionAmount',
            width: 100,
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CompensationPaidIn%></span>",
            dataIndex: 'compensationPaidIn',
            width: 100,
            filter: {
                type: 'float'
            }
        },{
            header: "<span style=font-weight:bold;><%=CompensationPaidOut%></span>",
            dataIndex: 'compensationPaidOut',
            width: 100,
            filter: {
                type: 'float'
            }
        },{
            header: "<span style=font-weight:bold;><%=InternalExpenses%></span>",
            dataIndex: 'internalExpenses',
            width: 100,
            filter: {
                type: 'float'
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

    compensationInfoGrid = getGrid('', '<%=NoRecordsFound%>', compensationInfoStore, screen.width - 53, 400, 13, compensationInfoFilters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', false, '', '', '', false, '', true, '<%=Add%>', true, '<%=Edit%>');

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
                text: '<%=CaseNumber%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            caseNumberCombo
        ]
    }); // End of Panel	
    
    var backButtonPanel = new Ext.Panel({   
        id: 'backbuttonid',
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
            text: '<%=Back%>',
            id: 'backButtId',
            iconCls: 'backbutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {
						parent.Ext.getCmp('AccidentAnalysisCasetabId').enable();
						parent.Ext.getCmp('AccidentAnalysisCasetabId').show();
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
            items: [innerPanel, compensationInfoGrid, backButtonPanel]
            //bbar: ctsb
        });
    });
</script>
  	</body>
</html>