<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int customerId = loginInfo.getCustomerId();
	
	Properties properties = ApplicationListener.prop;
	String counter = properties.getProperty("RefuelCounter").trim();

	//System.out.println("counter" +counter);
	//int counter = 5;
	
	ArrayList<String> tobeConverted = new ArrayList<String>();
	    tobeConverted.add("Refuel_Details");
    	tobeConverted.add("Asset_Number");
		tobeConverted.add("Select_Asset_Number");
		tobeConverted.add("SLNO");
		tobeConverted.add("Refuel_Date");                                   
		tobeConverted.add("Refuel_(Ltrs)");
		tobeConverted.add("Source");
		tobeConverted.add("Calibration_Remarks");
		tobeConverted.add("Entered_By");
		tobeConverted.add("Entered_Date");                       
		tobeConverted.add("Verify_Remarks");
		tobeConverted.add("Verified_By");
		tobeConverted.add("Reviewed_By");
		tobeConverted.add("Approved_Remarks");
		tobeConverted.add("Approved_By");
		tobeConverted.add("Approved_Date");
		tobeConverted.add("FDAS_Refuel");
		
		tobeConverted.add("Enter_Refuel_Date");
		tobeConverted.add("Enter_Refuel_(Ltrs)");
		tobeConverted.add("Enter_Source");
		tobeConverted.add("Enter_Calibration_Remarks");
		tobeConverted.add("Enter_Verify_Remarks");
		tobeConverted.add("Enter_Reviewed_By");
		tobeConverted.add("Enter_Approved_Remarks");
		
		tobeConverted.add("Add");
		tobeConverted.add("Modify");
		tobeConverted.add("Verify");
		tobeConverted.add("Approve");
		tobeConverted.add("Cancel");
		tobeConverted.add("Back");
		tobeConverted.add("Save");
		
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("Clear_Filter_Data");
		tobeConverted.add("Select_Single_Row");
		tobeConverted.add("No_Rows_Selected");
		tobeConverted.add("Record_Has_Been_Verified_So_Unable_To_Modify");
		tobeConverted.add("Record_Has_Been_Already_Verified");
		tobeConverted.add("Please_Verify_Before_Approve");
		tobeConverted.add("Vehicle_Has_Been_Already_Approved");
		tobeConverted.add("Please_Select_Asset_Number");
		
		tobeConverted.add("Refuel_Information");
        tobeConverted.add("Approve_Information");
        tobeConverted.add("Verify_Information");
        
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
		String RefuelDetails =  convertedWords.get(0); 
		String AssetNumber =  convertedWords.get(1);
		String SelectAssetNumber =  convertedWords.get(2);
		String SLNO =  convertedWords.get(3);
		String RefuelDate =  convertedWords.get(4);
		String RefuelLitres =  convertedWords.get(5);
		String Source =  convertedWords.get(6);
		String CalibrationRemarks =  convertedWords.get(7);
		String EnteredBy =  convertedWords.get(8);
		String EnteredDate =  convertedWords.get(9);
		String VerifyRemarks =  convertedWords.get(10); 
		String VerifiedBy =  convertedWords.get(11);
		String ReviewedBy =  convertedWords.get(12);
		String ApprovedRemarks =  convertedWords.get(13);
		String ApprovedBy =  convertedWords.get(14);
		String ApprovedDate =  convertedWords.get(15);
		
		
		String FDASRefuel =  convertedWords.get(16);
		String EnterRefuelDate =  convertedWords.get(17);
		String EnterRefuelLitres =  convertedWords.get(18);
		String EnterSource =  convertedWords.get(19);
		String EnterCalibrationRemarks =  convertedWords.get(20);
		String EnterVerifyRemarks =  convertedWords.get(21); 
		String EnterReviewedBy =  convertedWords.get(22);
		String EnterApprovedRemarks =  convertedWords.get(23);
		
		String Add =  convertedWords.get(24);
		String Modify =  convertedWords.get(25);
		String Verify =  convertedWords.get(26);
		String Approve =  convertedWords.get(27);
		String Cancel =  convertedWords.get(28);
		String Back =  convertedWords.get(29);
		String Save =  convertedWords.get(30);
		
		String NoRecordsFound =  convertedWords.get(31);
		String ClearFilterData =  convertedWords.get(32);
		String SelectSingleRow =  convertedWords.get(33);
		String NoRowsSelected =  convertedWords.get(34);
		
		String RecordHasBeenVerifiedSoUnableToModify =  convertedWords.get(35);
		String RecordHasBeenAlreadyVerified =  convertedWords.get(36);
		String PleaseVerifyBeforeApprove =  convertedWords.get(37);
		String VehicleHasBeenAlreadyApproved =  convertedWords.get(38);
        String PleaseSelectAssetNumber =  convertedWords.get(39);
        
        String RefuelInformation =  convertedWords.get(40);
        String ApproveInformation =  convertedWords.get(41);
        String VerifyInformation =  convertedWords.get(42);
%>

<!DOCTYPE HTML>
<html>
 <head>
 	<title><%=RefuelDetails%></title>	
 	<meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8" />	
	</head>	    
  	<body>
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
 	var myWin;
 	var dtcur = datecur;
 	var jspName = '<%=FDASRefuel%>';
 	var exportDataType = "int,string,string,date,string,date,string,int,int,string";
 	var globalCustomerId = parent.globalCustomerID;
 	var assetNumber = parent.assetNumber;
 	
	var vehiclestore = new Ext.data.JsonStore({
 	    url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=getVehicleNumber',
 	    id: 'VehicleStoreId',
 	    root: 'vehicleNoRoot',
 	    autoLoad: true,
 	    remoteSort: true,
 	    fields: ['vehicleno']
 	});

 	vehiclestore.on('beforeload', function (store, operation, eOpts) {
 	    operation.params = {
 	        CustId: globalCustomerId
 	    };
 	});

 	vehiclestore.on('load', function (store, operation, eOpts) {
 	    Ext.getCmp('vehiclecomboId').setValue(assetNumber);
 	    refuelStore.load({
 	         params: {
		 	     assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
		 	     CustId: globalCustomerId
 	         },  
 	         callback:function(records, operation, success){
 	             for (var i = 0; i < refuelStore.data.length; i++) {
 	                 var r = grid.store.getAt(i);
 	                 Ext.getCmp('approveReviewOutputId').setText(r.get('approveEnteredBy'));
				 	 Ext.getCmp('approveRemarksOutputId').setText(r.get('approveRemarks'));
				 	 Ext.getCmp('approveByOutputId').setText(r.get('approveBy')); 
				 	 Ext.getCmp('approveDateOutputId').setText(r.get('approveDate'));
				 } 
 	         }	 
 	   	});      
 	}, this);

 	var vehicleCombo = new Ext.form.ComboBox({
 	    store: vehiclestore,
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
 	    valueField: 'vehicleno',
 	    enableKeyEvents: true,
 	    minChars: 1,
 	    listeners: {
 	        select: {
 	            fn: function () {	             
 	                Ext.getCmp('approveReviewOutputId').setText('');
				 	Ext.getCmp('approveRemarksOutputId').setText('');
				 	Ext.getCmp('approveByOutputId').setText('');  
				 	Ext.getCmp('approveDateOutputId').setText('');  
 	             	refuelStore.load({
 	                	params: {
		 	                assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
		 	                CustId: globalCustomerId
 	                	},  
 	                	callback:function(records, operation, success){
 	                    	for (var i = 0; i < refuelStore.data.length; i++) {
 	                  			var r = grid.store.getAt(i);
 	                  			Ext.getCmp('approveReviewOutputId').setText(r.get('approveEnteredBy'));
				 	  			Ext.getCmp('approveRemarksOutputId').setText(r.get('approveRemarks'));
				 	  			Ext.getCmp('approveByOutputId').setText(r.get('approveBy'));  
				 	  			Ext.getCmp('approveDateOutputId').setText(r.get('approveDate'));  
 	                		} 
 	           			}	 
 	             	});
				}
 	        }
 	    }
 	});

 	var comboPanel = new Ext.Panel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    id: 'vehicleComboId',
 	    frame: true,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 2
 	    },
 	    items: [{
 	            xtype: 'label',
 	            text: '<%=AssetNumber%> :',
 	            width: 20,
 	            cls: 'selectstylePerfect'
 	        },
 	        vehicleCombo
 	    ]
 	});

 	var innerPanel = new Ext.form.FormPanel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoScroll: true,
 	    height: 180,
 	    width: 500,
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
        title: '<%=RefuelInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'refuelpanelid',
        width: 480,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
 	    
 	    
 	    
 	    items: [{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorya'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=RefuelDate%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'refueltxt'
 	    }, {
 	        xtype: 'datefield',
 	        cls: 'selectstylePerfect',
 	        id: 'refuelid',
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
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryb'
 	    }, {
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryc'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=RefuelLitres%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'ltrstxt'
 	    }, {
 	        xtype: 'numberfield',
 	        emptyText: '<%=EnterRefuelLitres%>',
 	        cls: 'selectstylePerfect',
 	        blankText: '<%=EnterRefuelLitres%>',
 	        id: 'ltrsid'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryd'
 	    }, {
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorye'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=Source%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'sourcetxt'
 	    }, {
 	        xtype: 'textfield',
 	        regex: validate('name'),
 	        emptyText: '<%=EnterSource%>',
 	        allowBlank: false,
 	        regexText: 'Customer Name should be in Albhates only',
 	        blankText: '<%=EnterSource%>',
 	        cls: 'selectstylePerfect',
 	        id: 'sourceid'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryf'
 	    }, {
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryg'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=CalibrationRemarks%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'remtxt'
 	    }, {
 	        xtype: 'textfield',
 	        emptyText: '<%=EnterCalibrationRemarks%>',
 	        allowBlank: true,
 	        cls: 'selectstylePerfect',
 	        id: 'remid'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryh'
 	    }]
 	    
 	  }]    
 	    
 	});
 	
 	var winButtonPanel = new Ext.Panel({
 	    id: 'winbuttonid',
 	    standardSubmit: true,
 	    collapsible: false,
 	    height: 10,
 	    width: 500,
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
 	                fn: function () {
 	                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
 	                        Ext.example.msg("<%=SelectAssetNumber%>");
 	                        Ext.getCmp('vehiclecomboId').focus();
 	                        return;
 	                    }
 	                    if (!(Ext.getCmp('refuelid').getValue() == "0" || Ext.getCmp('refuelid').getValue() != "")) {
 	                        Ext.example.msg("<%=EnterRefuelDate%>");
 	                        Ext.getCmp('refuelid').focus();
 	                        return;
 	                    }
 	                    if (!(Ext.getCmp('ltrsid').getValue() == "0" || Ext.getCmp('ltrsid').getValue() != "")) {
 	                        Ext.example.msg("<%=EnterRefuelLitres%>");
 	                        Ext.getCmp('ltrsid').focus();
 	                        return;
 	                    }
 	                    if (Ext.getCmp('sourceid').getValue() == "") {
 	                        Ext.example.msg("<%=EnterSource%>");
 	                        Ext.getCmp('sourceid').focus();
 	                        return;
 	                    } if (Ext.getCmp('remid').getValue() == "") {
 	                        Ext.example.msg("<%=EnterCalibrationRemarks%>");
 	                        Ext.getCmp('remid').focus();
 	                        return;
 	                    }
 	                    
 	                    
 	                    if (innerPanel.getForm().isValid()) {
 	                        var id;
 	                        if (buttonValue == 'Modify') {
 	                            var selected = grid.getSelectionModel().getSelected();
 	                            id = selected.get('id');
 	                        }
 	                        Ext.Ajax.request({
 	                            url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=RefuelSave',
 	                            method: 'POST',
 	                            params: {
 	                                buttonValue: buttonValue,
 	                                CustId: globalCustomerId,
 	                                VehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
 	                                Refuel: Ext.getCmp('refuelid').getValue(),
 	                                Litres: Ext.getCmp('ltrsid').getValue(),
 	                                Source: Ext.getCmp('sourceid').getValue(),
 	                                Remarks1: Ext.getCmp('remid').getValue(),
 	                                id: id  
 	                            },
 	                            success: function (response, options) {
 	                                var message = response.responseText;
 	                                Ext.example.msg(message);
 	                                Ext.getCmp('refuelid').reset();
 	                                Ext.getCmp('ltrsid').reset();
 	                                Ext.getCmp('sourceid').reset();
 	                                Ext.getCmp('remid').reset();
 	                                myWin.hide();
 	                                refuelStore.load({
 	                                    params: {
 	                                        assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
 	                                        CustId: globalCustomerId
 	                                      
 	                                        
 	                                    }
 	                                }); 	                                          
 	                            },
 	                            failure: function () {
 	                                Ext.example.msg("Error");
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
 	                    //alert('1');
 	                    myWin.hide();
 	                    // alert('2');
 	                }
 	            }
 	        }
 	    }]
 	});
 	
 	var outerPanelWindow = new Ext.Panel({
 	    height: 260,
 	    width: 530,
 	    standardSubmit: true,
 	    frame: true,
 	    items: [innerPanel, winButtonPanel]
 	});
 	myWin = new Ext.Window({
 	    closable: false,
 	    resizable: true,
 	    modal: true,
 	    autoScroll: false,
 	    height: 300,
 	    width: 530,
 	    id: 'myWin',
 	    items: [outerPanelWindow]
 	});

 	function addRecord() {
 	    
 	    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
 	        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
 	        Ext.getCmp('vehiclecomboId').focus();
 	        return;
 	    }

 	    buttonValue = 'Add';
 	    titel = '<%=Add%>';
 	    myWin.setPosition(400, 90);
 	    myWin.show();
 	    myWin.setTitle(titel);
 	    Ext.getCmp('refuelid').reset();
 	    Ext.getCmp('ltrsid').reset();
 	    Ext.getCmp('sourceid').reset();
 	    Ext.getCmp('remid').reset();	   
 	}

 	function modifyData() {
 	
 	    if (Ext.getCmp('vehiclecomboId').getValue() == '') {
 	        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
 	        Ext.getCmp('vehiclecomboId').focus();
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
 	    var selected = grid.getSelectionModel().getSelected();
 	  	if (selected.get('verifiedby') != '') {
 	        Ext.example.msg("<%=RecordHasBeenVerifiedSoUnableToModify%>");
 	        return;
 	    }   

 	    buttonValue = 'Modify';
 	    titel = '<%=Modify%>';
 	    myWin.setPosition(400, 90);
 	    myWin.setTitle(titel);
 	    myWin.show();
 	    Ext.getCmp('refuelid').setValue(selected.get('refueldate'));
 	    Ext.getCmp('ltrsid').setValue(selected.get('ltrsrefueled'));
 	    Ext.getCmp('sourceid').setValue(selected.get('source'));
 	    Ext.getCmp('remid').setValue(selected.get('remarks1'));
 		}

 	var approvePanel = new Ext.form.FormPanel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoScroll: true,
 	    height: 130,
 	    width: 380,
 	    frame: true,
 	    id: 'approveid',
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4,
 	        style: {
 	            // width: '10%'
 	        }
 	    },
 	    
 	    items: [{
        xtype: 'fieldset',
        title: '<%=ApproveInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'apprpanelid',
         width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
 	    
 	    
 	    items: [{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryq'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=ReviewedBy%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'reviewtxt'
 	    }, {
 	        xtype: 'textfield',
 	        regex: validate('name'),
 	        emptyText: '<%=EnterReviewedBy%>',
 	        allowBlank: false,
 	        regexText: 'Entered Value Should Be In Albhates Only',
 	        blankText: '<%=EnterReviewedBy%>',
 	        cls: 'selectstylePerfect',
 	        id: 'reviewid'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatoryr'
 	    }, {
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorys'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=ApprovedRemarks%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'rem2txt'
 	    }, {
 	        xtype: 'textfield',
 	        regex: validate('name'),
 	        emptyText: '<%=EnterApprovedRemarks%>',
 	        allowBlank: false,
 	        regexText: 'Entered Remarks Should Be In Albhates Only',
 	        blankText: '<%=EnterApprovedRemarks%>',
 	        cls: 'selectstylePerfect',
 	        id: 'rem2id'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatoryt'
 	    }]
 	 }] 
 	});
 	
 	var approveButtonPanel = new Ext.Panel({
 	    id: 'approvepanelid',
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoHeight: true,
 	     height: 10,
 	    width: 380,
 	    frame: true,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4
 	    },
 	    buttons: [{
 	        xtype: 'button',
 	        text: '<%=Approve%>',
 	        id: 'saveId',
 	        cls: 'buttonstyle',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                    if (Ext.getCmp('reviewid').getValue() == '') {
 	                        Ext.example.msg("<%=EnterReviewedBy%>");
 	                        Ext.getCmp('reviewid').focus();
 	                        return;
 	                    }
 	                    if (Ext.getCmp('rem2id').getValue() == "") {
 	                        Ext.example.msg("<%=EnterApprovedRemarks%>");
 	                        Ext.getCmp('rem2id').focus();
 	                        return;
 	                    }

 	                    Ext.Ajax.request({
 	                        url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=approveSave',
 	                        method: 'POST',
 	                        params: {
 	                            buttonValue: buttonValue,
 	                            CustId: globalCustomerId,
 	                            VehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
 	                            Reviewby: Ext.getCmp('reviewid').getValue(),
 	                            Remark2: Ext.getCmp('rem2id').getValue(),
 	                            
 	                        },
 	                        success: function (response, options) {
 	                            var message = response.responseText;
 	                            Ext.example.msg(message);
 	                            //Ext.getCmp('reviewid').reset();
 	                            //Ext.getCmp('rem2id').reset();
 	                            approveWin.hide();
 	                              refuelStore.load({
 	                             	params: {
		 	                        	assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
		 	                        	CustId: globalCustomerId
 	                    			},  
 	                    		callback:function(records, operation, success){
 	                    		for (var i = 0; i < refuelStore.data.length; i++) {
 	                  				var r = grid.store.getAt(i);
 	                  				Ext.getCmp('approveReviewOutputId').setText(r.get('approveEnteredBy'));
				 	  				Ext.getCmp('approveRemarksOutputId').setText(r.get('approveRemarks'));
				 	  				Ext.getCmp('approveByOutputId').setText(r.get('approveBy'));  
				 	  				Ext.getCmp('approveDateOutputId').setText(r.get('approveDate'));
 	                			} 
 	                    		}	 
 	              	  			});
 	                			
 	              	  			
 	                					
 	                        },
 	                        failure: function () {
 	                            Ext.example.msg("Error");
 	                            approveWin.hide();
 	                        }
 	                    });
 	                }
 	            }
 	        }
 	    }, {
 	        xtype: 'button',
 	        text: '<%=Cancel%>',
 	        id: 'cancelButtonId',
 	        cls: 'buttonstyle',
 	        iconCls: 'cancelbutton',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                //alert('1');
 	                    approveWin.hide();
 	                   // alert('2');
 	                }
 	            }
 	        }
 	    }]
 	});

 	var approvePanelWindow = new Ext.Panel({
 	    height: 220,
 	    width: 410,
 	    standardSubmit: true,
 	    frame: true,
 	    items: [approvePanel, approveButtonPanel]
 	});

 	approveWin = new Ext.Window({
 	    closable: false,
 	    resizable: false,
 	    modal: true,
 	    autoScroll: false,
 	    height: 230,
 	    width: 410,
 	    id: 'myWinApprove',
 	    items: [approvePanelWindow]
 	});

 	function approveFunction() {
 	    if (Ext.getCmp('vehiclecomboId').getValue() == '') {
 	        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
 	        Ext.getCmp('vehiclecomboId').focus();
 	        return;
 	    }
 	  
 	  if (grid.getSelectionModel().getCount() == 0) {
 	        Ext.example.msg("<%=NoRowsSelected %>");
 	        return;
 	    }
 	    
 	     if (grid.getSelectionModel().getCount() > 1) {
 	        Ext.example.msg("<%=SelectSingleRow %>");
 	        return;
 	    }  
		
		var check = false;
		var refuelCounter = 0;
 	    for (var i = 0; i < refuelStore.data.length; i++) {
 	        var r = grid.store.getAt(i);
 	        var verifiedby = r.data['verifiedby'];
 	        refuelCounter = r.data['refuelCounter'];
 	        if (verifiedby == '') {
 	            check = true;
 	        }
 	    }
 	    
 	    if (check == true) {
 	       Ext.example.msg("<%=PleaseVerifyBeforeApprove%>");
 	       return; 
 	    }
 	    
 	    if (refuelCounter < '<%=counter%>') {
 	    	var actualCount = '<%=counter%>';
 	    	var count = actualCount - refuelCounter;
 	       	Ext.example.msg("Need To Add "+ count +" More Refuel Data To Approve");
 	        return; 
 	    }

 	    buttonValue = 'Approve';
 	    titel = '<%=Add%>';
 	    approveWin.show();
 	    approveWin.setTitle(titel);
 	    Ext.getCmp('approveid').enable();
 	}

 	var verifyPanel = new Ext.form.FormPanel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoScroll: true,
 	    height: 100,
 	    width: 380,
 	    frame: true,
 	    id: 'verify2id',
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4,
 	        style: {
 	            // width: '10%'
 	        }
 	    },
 	    items: [{
        xtype: 'fieldset',
        title: '<%=VerifyInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'verifypanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
 	    
 	    
 	    items: [{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryab'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=VerifyRemarks%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'remarks2txt'
 	    }, {
 	        xtype: 'textfield',
 	        regex: validate('name'),
 	        emptyText: '<%=EnterVerifyRemarks%>',
 	        allowBlank: false,
 	        regexText: 'Customer Name should be in Albhates only',
 	        blankText: '<%=EnterVerifyRemarks%>',
 	        cls: 'selectstylePerfect',
 	        id: 'remarks2id'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatorycd'
 	    }]
 	  }] 
 	});

 	var verifyButtonPanel = new Ext.Panel({
 	    id: 'verifybuttonid',
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoHeight: true,
 	     height: 10,
 	    width: 380,
 	    frame: true,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4
 	    },
 	    buttons: [{
 	        xtype: 'button',
 	        text: '<%=Verify%>',
 	        id: 'savesId',
 	        cls: 'buttonstyle',
 	        iconCls: 'savebutton',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                    if (Ext.getCmp('remarks2id').getValue() == "") {
 	                        Ext.example.msg("<%=EnterVerifyRemarks%>");
 	                        Ext.getCmp('remarks2id').focus();
 	                        return;
 	                    }

 	                    var selected = grid.getSelectionModel().getSelected();
 	                    Ext.Ajax.request({
 	                        url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=VerifySave',
 	                        method: 'POST',
 	                        params: {
 	                            buttonValue: buttonValue,
 	                            CustId: globalCustomerId,
 	                            VehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
 	                            Remarks2: Ext.getCmp('remarks2id').getValue(),
 	                            id: selected.get('id')
 	                        },
 	                        success: function (response, options) {
 	                            var message = response.responseText;
 	                            Ext.example.msg(message);
 	                            Ext.getCmp('remarks2id').reset();
 	                            verifyWin.hide();
 	                            refuelStore.load({
 	                                 params: {
			 	                        assetNumber: Ext.getCmp('vehiclecomboId').getValue(),
			 	                        CustId: globalCustomerId,
 	                    			}   
 	              	  			});
 	                        },
 	                        failure: function () {
 	                            Ext.example.msg("Error");
 	                            verifyWin.hide();
 	                        }
 	                    });
 	                }
 	            }
 	        }
 	    }, {
 	        xtype: 'button',
 	        text: '<%=Cancel%>',
 	        id: 'cancelsButtId',
 	        cls: 'buttonstyle',
 	        iconCls: 'cancelbutton',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                    verifyWin.hide();
 	                }
 	            }
 	        }
 	    }]
 	});

 	var verifyPanelWindow = new Ext.Panel({
 	    standardSubmit: true,
 	    height: 180,
 	    width: 410,
 	    frame: true,
 	    items: [verifyPanel, verifyButtonPanel]
 	});

 	verifyWin = new Ext.Window({
 	    closable: false,
 	    resizable: false,
 	    modal: true,
 	    autoScroll: false,
 	    height: 190,
 	    width: 410,
 	    id: 'myWinVerify',
 	    items: [verifyPanelWindow]
 	});

 	function verifyFunction() {
 	    if (Ext.getCmp('vehiclecomboId').getValue() == '') {
 	        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
 	        Ext.getCmp('vehiclecomboId').focus();
 	        return;
 	    }
 	  
 	  	if (grid.getSelectionModel().getCount() == 0) {
 	        Ext.example.msg("<%=NoRowsSelected %>");
 	        return;
 	    }
 	    
 	     if (grid.getSelectionModel().getCount() > 1) {
 	        Ext.example.msg("<%=SelectSingleRow %>");
 	        return;
 	    } 
 	    
 	    var selected = grid.getSelectionModel().getSelected();
 	  	if (selected.get('verifiedby') != '') {
 	        Ext.example.msg("<%=RecordHasBeenAlreadyVerified%>");
 	        return;
 	     }

 	    buttonValue = 'Verify';
 	    titel = '<%=Verify%>';
 	    verifyWin.show();
 	    verifyWin.setTitle(titel);
 	}

 	var reader = new Ext.data.JsonReader({
 	    idProperty: 'refuelid',
 	    root: 'refuelroot',
 	    totalProperty: 'total',
 	    fields: [{
 	        name: 'slnoIndex'
 	    }, {
 	        name: 'refueldate',
 	        type: 'date',
 	        dateFormat: getDateTimeFormat()
 	    }, {
 	        name: 'ltrsrefueled'
 	    }, {
 	        name: 'source',
 	    }, {
 	        name: 'remarks1'
 	    }, {
 	        name: 'enteredby'
 	    }, {
 	        name: 'entereddate',
 	        type: 'date',
 	        dateFormat: getDateTimeFormat()
 	    }, {
 	        name: 'remarks2'
 	    }, {
 	        name: 'verifiedby'
 	    },{
 	        name: 'approveEnteredBy'
 	    },{
 	        name: 'approveRemarks'
 	    },{
 	        name: 'approveBy'
 	    },{
 	        name: 'approveDate'
 	    },{
 	        name: 'refuelCounter'
 	    },{
 	        name: 'id'
 	    }]
 	});

 	 //***************************************Store Config*****************************************
 	var refuelStore = new Ext.data.GroupingStore({
 	    autoLoad: false,
 	    proxy: new Ext.data.HttpProxy({
 	        url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=getrefuelDetails',
 	        method: 'POST'
 	    }),
 	    storeId: 'refuelid',
 	    reader: reader
 	});

 	 //**********************Filter Config****************************************************
 	var filters = new Ext.ux.grid.GridFilters({
 	    local: true,
 	    filters: [{
 	        type: 'numeric',
 	        dataIndex: 'slnoIndex'
 	    }, {
 	        type: 'date',
 	        dataIndex: 'refueldate'
 	    }, {
 	        type: 'float',
 	        dataIndex: 'ltrsrefueled'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'source'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'remarks1'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'enteredby'
 	    }, {
 	        type: 'date',
 	        dataIndex: 'entereddate'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'remarkindex'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'verifiedby'
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
 	            dataIndex: 'refueldate',
 	            header: "<span style=font-weight:bold;><%=RefuelDate%></span>",
 	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
 	            width: 50,
 	            filter: {
 	                type: 'date'
 	            }
 	        }, {
 	            dataIndex: 'ltrsrefueled',
 	            header: "<span style=font-weight:bold;><%=RefuelLitres%></span>",
 	            width: 50,
 	            filter: {
 	                type: 'float'
 	            }
 	        }, {
 	            dataIndex: 'source',
 	            header: "<span style=font-weight:bold;><%=Source%></span>",
 	            width: 50,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            dataIndex: 'remarks1',
 	            header: "<span style=font-weight:bold;><%=CalibrationRemarks %></span>",
 	            width: 50,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            dataIndex: 'enteredby',
 	            header: "<span style=font-weight:bold;><%=EnteredBy%></span>",
 	            width: 50,
 	            filter: {
 	                type: 'String'
 	            }
 	        }, {
 	            dataIndex: 'entereddate',
 	            header: "<span style=font-weight:bold;><%=EnteredDate%></span>",
 	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
 	            width: 40,
 	            filter: {
 	                type: 'date'
 	            }
 	        }, {
 	            dataIndex: 'remarks2',
 	            header: "<span style=font-weight:bold;><%=VerifyRemarks %></span>",
 	            width: 40,
 	             filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            dataIndex: 'verifiedby',
 	            header: "<span style=font-weight:bold;><%=VerifiedBy%></span>",
 	            width: 50,
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
 	var grid = getGrid('', '<%=NoRecordsFound%>', refuelStore, screen.width -50, 380, 14, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', false, '', jspName, exportDataType, false, '', true, '<%=Add%>', true, '<%=Modify%>',false,'',false,'', true, '<%=Verify%>', true, '<%=Approve%>');
 	

 	var approveRemarkPanel = new Ext.Panel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    id: 'approveRemarkPanelId',
 	    layout: 'table',
 	    cls: 'innerpanelsmallest',
 	    frame: true,
 	    width: '100%',
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 11
 	    },
 	    items: [{
 	        xtype: 'label',
 	        id:'approveReviewLabelId',
 	        text: '<%=ReviewedBy%> :',
 	        width: 20,
 	        cls: 'labelstyle'
 	    }, {
 	        xtype: 'label',
 	        id: 'approveReviewOutputId',	       
 	        cls: 'labelBoldFontPerfect'
 	    }, {
 	        width: 150
 	    }, {
 	        xtype: 'label',
 	        id :'approveRemarksId',
 	        text: '<%=ApprovedRemarks%>:',
 	        width: 20,
 	        cls: 'labelstyle'
 	    }, {
 	        xtype: 'label',
 	        id: 'approveRemarksOutputId',
 	        cls: 'labelBoldFontPerfect'
 	    }, {
 	        width: 310
 	    }, {
 	        xtype: 'label',
 	        cls: 'labelstyle',
 	        id: 'approveById',
 	        text: '<%=ApprovedBy%>:',
 	        width: 20,
 	        cls: 'labelstyle'
 	    }, {
 	        xtype: 'label',
 	        id:'approveByOutputId',
 	        cls: 'labelBoldFontPerfect'
 	    }, {
 	        width: 100
 	    }, {
 	        xtype: 'label',
 	        cls: 'labelstyle',
 	        id: 'approveDateId',
 	        text: '<%=ApprovedDate%>:',
 	        width: 20,
 	        cls: 'labelstyle'
 	    }, {
 	        xtype: 'label',
 	        id:'approveDateOutputId',
 	        cls: 'labelBoldFontPerfect'
 	    }]
 	});

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
 	                    parent.Ext.getCmp('fdastabId').enable();
 	                    parent.Ext.getCmp('fdastabId').show();
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
 	        height:510,
	        width:screen.width-30,
 	        cls: 'outerpanel',
 	        items: [comboPanel, grid, backButtonPanel, approveRemarkPanel]
 	       // bbar: ctsb
 	    });
 	});
</script>
</body>               
</html>    
    



