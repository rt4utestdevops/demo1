var previewPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 420,
        width: 1280,
        frame: true,
        id: 'previewPanelId',
        layout: 'table',
        layoutConfig: { columns: 2 },
        items:[{xtype:'panel',
        standardSubmit: true, collapsible: false, autoScroll: true,
        height: 400, width: 600,
        frame: false,
        layout: 'table',
        layoutConfig: { columns: 3 },
        items: [
        { xtype: 'label', text: 'Date :',
          cls: 'labelstyle', id: 'dateLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'dateDateId' },{height:25,width:1, hidden:false ,id:'hos2'},
        { xtype: 'label', text: 'Financial Year :',
          cls: 'labelstyle', id: 'FinanYearLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'FinanYearTxtId' },{height:25,width:1, hidden:false ,id:'hos3'},
        { xtype: 'label', text: 'Permit Type :',
          cls: 'labelstyle', id: 'PrmtTypeLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'permtTypeTxtId' },{height:25,width:1, hidden:false ,id:'hos4'},       
        { xtype: 'label', text: 'Import Permit Type :',
          cls: 'labelstyle', id: 'impPrmtTypeLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'impPrmtTypeTxtId' },{height:25,width:1, hidden:true ,id:'hos5'},
        { xtype: 'label', text: 'Purpose of Import :',
          cls: 'labelstyle', id: 'prpsOfImpLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'prpsOfImpTxtId' },{height:25,width:1, hidden:true ,id:'hos6'},
        { xtype: 'label', text: 'Tc No :',
          cls: 'labelstyle', id: 'tcN0LabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'tcN0TxtId' },{height:25,width:1, hidden:true ,id:'hos7'},
        { xtype: 'label', text: 'Mine Code :',
          cls: 'labelstyle', id: 'mineCodLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'MineCodTxtId' },{height:25,width:1, hidden:true ,id:'hos8'},

        { xtype: 'label', text: 'Lease Name :',
          cls: 'labelstyle', id: 'leaseNamLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'leaseNamTxtId' },{height:25,width:1, hidden:true ,id:'hos9'},
        { xtype: 'label', text: 'Lease Owner :',
          cls: 'labelstyle', id: 'leaseOwnLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'leaseOwnTxtId' },{height:25,width:1, hidden:true ,id:'hos10'},
        { xtype: 'label', text: 'Organization/Trader Code :',
          cls: 'labelstyle', id: 'orgCodLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'orgCodTxtId' },{height:25,width:1, hidden:true ,id:'hos11'},
        { xtype: 'label', text: 'Organization/Trader Name :',
           cls: 'labelstyle', id: 'orgNamLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'orgNamTxtId' },{height:25,width:1, hidden:false ,id:'hos12'},
          
        { xtype: 'label', text: 'M-wallet Balance :',
          cls: 'labelstyle', id: 'M-walBalLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'M-walBalTxtId' },{height:25,width:1, hidden:true ,id:'hos13'},
        {xtype: 'label', text: 'Application No :',
          cls: 'labelstyle', id: 'AppNoLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'AppNoTxtId' },{height:25,width:1,width:1, hidden:false ,id:'hos1'},
        { xtype: 'label', text: 'RS Permit :',
          cls: 'labelstyle', id: 'RSPrmtLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'RSPrmtTxtId' },{height:25,width:1, hidden:true ,id:'hos14'},
        { xtype: 'label', text: 'TO Location :',
          cls: 'labelstyle', id: 'to_LocLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'to_LocTxtId' },{height:25,width:1, hidden:true ,id:'hos15'},
        { xtype: 'label', text: 'Buying Organization/Trader Name :',
          cls: 'labelstyle', id: 'BuyOrgNamLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'buyOrgNamTxtId' },{height:25,width:1, hidden:true ,id:'hos16'}, 
        
        { xtype: 'label', text: 'Buying Organization/Trader Code :',
          cls: 'labelstyle', id: 'buyOrgCodLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'buyOrgCodTxtId' },{height:25,width:1, hidden:false ,id:'hos17'},
        { xtype: 'label', text: 'Owner Type :',
          cls: 'labelstyle', id: 'owneTypeLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'owneTypeTxtId' },{height:25,width:1, hidden:false ,id:'hos18'},
        { xtype: 'label', text: 'Mineral :',
          cls: 'labelstyle', id: 'mineralLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'mineralTxtId' },{height:25,width:1, hidden:false ,id:'hos19'},
        { xtype: 'label', text: 'Imported Permit No :',
          cls: 'labelstyle', id: 'impPrmtNoLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'impPrmtNoTxtId' }, {height:25,id:'hos20'},
        
	    { xtype: 'label', text: 'Export Permit No :',
	      cls: 'labelstyle', id: 'expPrmtNoLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'expPrmtNoTxtId' },{height:25,width:1, hidden:true ,id:'hos21'},
	    { xtype: 'label', text: 'Export Permit Date :',
	      cls: 'labelstyle', id: 'expPrmtDatLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'expPrmtDatTxtId' },{height:25,width:1, hidden:true ,id:'hos22'},
	    { xtype: 'label', text: 'Export Challan No :',
	      cls: 'labelstyle', id: 'expChalNoLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'expChalNoTxtId' },{height:25,width:1, hidden:true ,id:'hos23'},
	    { xtype: 'label', text: 'Export Challan Date :',
	      cls: 'labelstyle', id: 'expChalDatLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'expChalDatTxtId' },{height:25,width:1, hidden:true ,id:'hos24'},
		]
      },{xtype:'panel',
        standardSubmit: true, collapsible: false, autoScroll: true,
        height: 400, width: 610,
        frame: false,
        layout: 'table',
        layoutConfig: { columns: 3 },
        items: [
        { xtype: 'label', text: 'Sale Invoice No :',
          cls: 'labelstyle', id: 'saleInvoiceNoLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'saleInvoiceNoTxtId' },{height:25,width:1, hidden:true ,id:'hos25'},
        { xtype: 'label', text: 'Sale Invoice Date :',
          cls: 'labelstyle', id: 'saleInvoicedatLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'saleInvoiceDatTxtId' },{height:25,width:1, hidden:true ,id:'hos26'},
        { xtype: 'label', text: 'Transportation Type :',
          cls: 'labelstyle', id: 'TransportTypeLabId'
        },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'TransportTypeTxtId' }, {height:25, hidden:true ,id:'hos27'},
        
        { xtype: 'label', text: 'Source Type :',
          cls: 'labelstyle', id: 'sourceTypeLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'sourceTypeTxtId' },{height:25,width:1, hidden:true ,id:'hos28'},
	    { xtype: 'label', text: 'Source Hub :',
	      cls: 'labelstyle', id: 'sourceHubLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'sourceHubTxtId' },{height:25,width:1, hidden:true ,id:'hos29'},
	    { xtype: 'label', text: 'Route Id :',
	      cls: 'labelstyle', id: 'routeLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'routeTxtId' },{height:25,width:1, hidden:true ,id:'hos30'},
	    { xtype: 'label', text: 'From Location :',
	      cls: 'labelstyle', id: 'fromLocLabId'
	    },{xtype: 'label',  cls: 'labelsize', readOnly: true, id: 'fromLocTxtId' },{height:25,width:1, hidden:true ,id:'hos31'},
	    { xtype: 'label', text: 'To Location :',
		  cls: 'labelstyle', id: 'toLocLabId'
		},{xtype: 'label',  cls: 'labelsize', readOnly: true, id: 'toLocTxtId' },{height:25,width:1, hidden:true ,id:'hos32'},

        { xtype: 'label', text: 'Ref :',
          cls: 'labelstyle', id: 'refLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'refTxtId' },{height:25,width:1, hidden:true ,id:'hos33'},
	    { xtype: 'label', text: 'Bauxite Challan :',
	      cls: 'labelstyle', id: 'bauxChalLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'bauxChalTxtId' },{height:25,width:1, hidden:true ,id:'hos34'},
	    { xtype: 'label', text: 'Start Date :',
	      cls: 'labelstyle', id: 'startDatLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'startDatTxtId' },{height:25,width:1, hidden:false ,id:'hos35'},
	    { xtype: 'label', text: 'End Date :',
	      cls: 'labelstyle', id: 'endDatLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'endDatTxtId' },{height:25,width:1, hidden:false ,id:'hos36'},
	    { xtype: 'label', text: 'Buyer Name :',
		  cls: 'labelstyle', id: 'buyerNamLabId'
		},{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'buyerNamTxtId' },{height:25,width:1, hidden:true ,id:'hos37'},

        { xtype: 'label', text: 'Country Name :',
          cls: 'labelstyle', id: 'countryLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'countryTxtId' },{height:25,width:1, hidden:true ,id:'hos38'},
	    { xtype: 'label', text: 'State :',
	      cls: 'labelstyle', id: 'stateLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'stateTxtId' },{height:25,width:1, hidden:true ,id:'hos40'},
	    { xtype: 'label', text: 'Vessel Name :',
	      cls: 'labelstyle', id: 'vesselNamLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'vesselNamTxtId' },{height:25,width:1, hidden:true ,id:'hos41'},
	    { xtype: 'label', text: 'Remarks :',
		  cls: 'labelstyle', id: 'remarksLabId'
		},{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'remarksTxtId' },{height:25,width:1, hidden:false ,id:'hos42'},

        { xtype: 'label', text: 'Exact Grade :',
          cls: 'labelstyle', id: 'exactGradeLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'exactGradeTxtId' },{height:25,width:1, hidden:false ,id:'hos43'},
	    { xtype: 'label', text: 'Grade Type :',
	      cls: 'labelstyle', id: 'gradeTypeLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'gardeTypeTxtId' },{height:25,width:1, hidden:false ,id:'hos44'},
	    { xtype: 'label', text: 'Stock Location :',
	      cls: 'labelstyle', id: 'stockLocLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'stockLocTxtId' },{height:25,width:1, hidden:false ,id:'hos45'},
	    { xtype: 'label', text: 'Quantity :',
	      cls: 'labelstyle', id: 'quantityLabId'
	    },{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'QuantityTxtId' },{height:25,width:1, hidden:false ,id:'hos46'},
	    { xtype: 'label', text: 'Processing Fee :',
		  cls: 'labelstyle', id: 'processFeeLabId'
		},{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'processFeeTxtId' },{height:25,width:1, hidden:false ,id:'hos47'},
		{ xtype: 'label', text: 'Total Processing Fee :',
		  cls: 'labelstyle', id: 'totalProcessFeeLabId'
		},{xtype: 'label', cls: 'labelsize', readOnly: true, id: 'totalProcessFeeTxtId' },{height:25,width:1, hidden:false ,id:'hos48'},
		]
      }]	
    });

var previewButtonsPanel = new Ext.Panel({
        id: 'previewButtonsPanelId',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        cls: 'windowbuttonpanel',
        frame: false,
        layout: 'table',
        layoutConfig: { columns: 4 },
        buttons: [{
            xtype: 'button',
            text: 'Save',
            id: 'previewSaveButtonId',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
        			Ext.MessageBox.confirm('Confirm', "Permit will be saved.Do you want to continue?",
				    function(btn){
						    if(btn == 'yes'){
							   Ext.MessageBox.show({
							   
							  }); // END OF MESSAGEBOX.show()
				    myWin.hide();
				    previewWin.hide();
				    Ext.MessageBox.hide(); 
				    routeMasterOuterPanelWindow.getEl().mask();
            Ext.Ajax.request({
                url: basePath+'/PermitDetailsAction.do?param=AddorModifyPermitDetails',
                method: 'POST',
                params: {
                    buttonValue: buttonValue,
                    CustId: Ext.getCmp('custcomboId').getValue(),
                    date: Ext.getCmp('dateid').getValue(),
                    finyear: Ext.getCmp('finyearId').getValue(),
                    permitreq: Ext.getCmp('permitreqtypecomboId').getValue(),
                    ownertype: Ext.getCmp('ownertypecomboId').getValue(),
                    permittype: Ext.getCmp('permittypecomboId').getValue(),
                    tcid: Ext.getCmp('TccomboId').getValue(),
                    minecode: Ext.getCmp('minecodeId').getValue(),
                    leasename: Ext.getCmp('leaseNameid').getValue(),
                    leaseowner: Ext.getCmp('leaseOwnerid').getValue(),
                    orgname: Ext.getCmp('organizationid').getValue(),
                    mineral: Ext.getCmp('mineralcomboId').getValue(),
                    routeid: Ext.getCmp('routeidcomboId').getValue(),
                    fromloc: Ext.getCmp('fromlocId').getValue(),
                    toloc: Ext.getCmp('tolocId').getValue(),
                    challanid: challanId,
                    startdate: Ext.getCmp('startdateid').getValue(),
                    enddate: Ext.getCmp('enddateid').getValue(),
                    remarks: Ext.getCmp('remarksid').getValue(),
                    CustName: Ext.getCmp('custcomboId').getRawValue(),
                    applicationno: Ext.getCmp('applicationid').getRawValue(),
                    orgCode: orgCode,
                    json: json,
                    country: Ext.getCmp('countryComboId').getValue(),
                    buyer: Ext.getCmp('buyerId').getValue(),
                    ship: Ext.getCmp('shipId').getValue(),
                    state: RomState,
                    buyingOrgId: Ext.getCmp('buyingOrgComboId').getValue(),
                    stockName: stockValue,
                    vesselName: Ext.getCmp('vesselNameId').getValue(),
                    importType: Ext.getCmp('importtypecomboId').getValue(),
                    importPurpose: Ext.getCmp('importpurposecomboId').getValue(),
                    exportPermitNo: Ext.getCmp('exportPermitNoId').getValue(),
                    exportPermitDate: Ext.getCmp('exportPermitDateId').getValue(),
                    exportChallanNo: Ext.getCmp('exportChallanNoId').getValue(),
                    exportChallanDate: Ext.getCmp('exportChallanDateId').getValue(),
                    saleInvoiceNo: Ext.getCmp('saleInvoiceNoId').getValue(),
                    saleInvoiceDate: Ext.getCmp('saleInvoiceDateId').getValue(),
                    transportnType: Ext.getCmp('transportnTypecomboId').getValue(),
                    ImporteiPermitId: permitIDD,
                    hubId: Ext.getCmp('hubId').getValue(),
                    TcorgId : TcorgId,
                    toLocation : Ext.getCmp('toLocationId').getValue(),
                    destType: Ext.getCmp('desttypeId').getValue()
                },
                success: function(response, options) {
                    var message = response.responseText;
                    if(message=="0"){
                        message="Error in Saving Permit Details";
                        Ext.example.msg(message);
                     }else if(message>0){
                    	 window.open(basePath+"/PermitPDF?autoGeneratedKeys=" + message+"&buttonType="+buttonValue);
                         message="Permit Details Saved Successfully";
                         Ext.example.msg(message);
                     }
                    loadMask.hide();
                    Ext.getCmp('dateid').reset(),
                    Ext.getCmp('finyearId').reset(),
                    Ext.getCmp('permitreqtypecomboId').reset(),
                    Ext.getCmp('ownertypecomboId').reset(),
                    Ext.getCmp('permittypecomboId').reset(),
                    Ext.getCmp('TccomboId').reset(),
                    Ext.getCmp('minecodeId').reset(),
                    Ext.getCmp('leaseNameid').reset(),
                    Ext.getCmp('leaseOwnerid').reset(),
                    Ext.getCmp('organizationid').reset(),
                    Ext.getCmp('mineralcomboId').reset(),
                    Ext.getCmp('routeidcomboId').reset(),
                    Ext.getCmp('fromlocId').reset(),
                    Ext.getCmp('tolocId').reset(),
                    Ext.getCmp('RefcomboId').reset(),
                    Ext.getCmp('BuChallancomboId').reset(),
                    Ext.getCmp('startdateid').reset(),
                    Ext.getCmp('enddateid').reset(),
                    Ext.getCmp('remarksid').reset(),
                    Ext.getCmp('applicationid').reset(),
                    Ext.getCmp('shipId').reset(),
                    Ext.getCmp('countryComboId').reset(),
                    Ext.getCmp('buyerId').reset(),
                    Ext.getCmp('importtypecomboId').reset(),
                    Ext.getCmp('importpurposecomboId').reset(),
                        
                    Ext.getCmp('importedPermitId').reset(),
                    Ext.getCmp('vesselNameId').reset(),
                    Ext.getCmp('exportPermitNoId').reset(),
                    Ext.getCmp('exportPermitDateId').reset(),
                    Ext.getCmp('exportChallanNoId').reset(),
                    Ext.getCmp('exportChallanDateId').reset(),
                    Ext.getCmp('saleInvoiceNoId').reset(),
                    Ext.getCmp('saleInvoiceDateId').reset(),
                    Ext.getCmp('transportnTypecomboId').reset(),
                    Ext.getCmp('hubId').reset(),
                    Ext.getCmp('romPermitId').reset();
			        Ext.getCmp('toLocationId').reset();
			        Ext.getCmp('desttypeId').reset();
			        previewWin.hide();
                    myWin.hide();
                    routeMasterOuterPanelWindow.getEl().unmask();
                    store.load({
                        params: {
                        	jspName: jspName,
                        	CustName: Ext.getCmp('custcomboId').getRawValue(),
                            CustId: custId,
                            endDate: Ext.getCmp('enddate').getValue(),
                            startDate: Ext.getCmp('startdate').getValue()
                        }
                    });
                    PermitsForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    		listOfPermitNo=[];
			 				for(var i=0; i<PermitsForSearchStore.getCount(); i++){
								var rec = PermitsForSearchStore.getAt(i);
								listOfPermitNo.push(rec.data['PERMIT_NO']);
							}
                    	}
                    });
                    OrgNamesForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    	listOfOrgName=[];
			 				for(var i=0; i<OrgNamesForSearchStore.getCount(); i++){
								var rec = OrgNamesForSearchStore.getAt(i);
								listOfOrgName.push(rec.data['ORG_NAME']);
							}
						}
                    }); 
                    organizationCodeStore.load({ params: { CustId: custId } });
                },
                failure: function() {
                    Ext.example.msg("Error");
                    loadMask.hide();
                    store.reload();
                    previewWin.hide();
                    myWin.hide();
                }
            });
						 }//if--yes
					    });  // End of MESSAGEBOX.confirm()
                    }
                }
            }
        }, {
            xtype: 'button', text: 'Cancel', id: 'previewCanButtId',cls: 'buttonstyle',iconCls: 'cancelbutton',width: 70,
            listeners: { click: { fn: function() { previewWin.hide(); } } }
        }]
    });  
var previewWinPanel = new Ext.Panel({
    cls: 'previewWinPanelId', standardSubmit: true, id: 'radiocasewinpanelId',
    frame: true, height: 540, width: 1320,
    items: [previewPanel,
            { xtype: 'label', cls: 'mandatoryfield', text: 'NOTE: Recheck the details before saving, Once saved the changes can not be revert.'
    	},previewButtonsPanel]
});
previewWin = new Ext.Window({
        title: 'Permit Preview',
        closable: false,resizable: false,
        modal: true,autoScroll: false,
        height: 540, width: 1320,
        id: 'previewWin',items: [previewWinPanel]
    });


var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'numeric',
        dataIndex: 'uniqueidDataIndex'
    }, {
        type: 'string',
        dataIndex: 'permitNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusDataIndex'
    }, {
        type: 'date',
        dataIndex: 'dateIndex'
    }, {
        type: 'string',
        dataIndex: 'financialYearIndex'
    }, {
        type: 'string',
        dataIndex: 'permitRequestTypeIndex'
    }, {
        type: 'string',
        dataIndex: 'ownerTypeIndex'
    }, {
        type: 'string',
        dataIndex: 'permitTypeIndex'
    }, {
        type: 'string',
        dataIndex: 'exactRomIndex'
    }, {
        type: 'string',
        dataIndex: 'exactFinesIndex'
    }, {
        type: 'string',
        dataIndex: 'exactLumpsIndex'
    }, {
        type: 'string',
        dataIndex: 'exactConcentratesIndex'
    }, {
        type: 'string',
        dataIndex: 'exactTailingsIndex'
    }, {
        type: 'string',
        dataIndex: 'tcNoIndex'
    }, {
        type: 'string',
        dataIndex: 'mineCodeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'leaseNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'leaseOwnerDataIndex'
    }, {
        type: 'string',
        dataIndex: 'organizationCodeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'organizationNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'mineralDataIndex'
    }, {
        type: 'string',
        dataIndex: 'routeIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'fromLocationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'toLocationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'refDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'quantityDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'usedQtyIndex'
    }, {
        type: 'numeric',
        dataIndex: 'permitBalanceIndex'
    }, {
        type: 'numeric',
        dataIndex: 'toSourceIndex'
    }, {
    	type: 'numeric',
        dataIndex: 'selfconsIndex'
    }, {
        type: 'numeric',
        dataIndex: 'pfIndex'
    }, {
        type: 'numeric',
        dataIndex: 'totalPfIndex'
    }, {
        type: 'numeric',
        dataIndex: 'closedQtyIndex'
    }, {
        type: 'string',
        dataIndex: 'applicationNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'remarksDataIndex'
    }, {
        type: 'string',
        dataIndex: 'startdateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'enddateDataIndex'
    },{
        type: 'string',
        dataIndex: 'buyerDataIndex'
    },{
        type: 'string',
        dataIndex: 'countryNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'countryIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'stateNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'stateIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'shipNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'routeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'organizationIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'challanIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'buyingOrgIdDataIndex'
    }, {
    	type: 'string',
        dataIndex: 'buyingOrgNameDataIndex'
    }, {
    	type: 'string',
        dataIndex: 'buyingOrgCodeDataIndex'
    },{
    	type: 'string',
        dataIndex: 'existingPermitIndex'
    },{
    	type: 'string',
        dataIndex: 'importTypeDataIndex'
    },{
    	type: 'string',
        dataIndex: 'hubNameIndex'
    },{
    	type: 'string',
        dataIndex: 'toLocIndex'
    },{
    	type: 'string',
        dataIndex: 'destTypeDataIndex'
    },{
    	type: 'string',
        dataIndex: 'motherRDataIndex'
    },{
    	type: 'string',
        dataIndex: 'leaseTypeDataIndex'
    },{
    	type: 'string',
        dataIndex: 'processingFeeTypeDataIndex'
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
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Application No</span>",
            dataIndex: 'applicationNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Permit No</span>",
            dataIndex: 'permitNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'dateIndex',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Financial Year</span>",
            dataIndex: 'financialYearIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Permit Request Type</span>",
            dataIndex: 'permitRequestTypeIndex',
            width: 100,
            hidden: true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Owner Type</span>",
            dataIndex: 'ownerTypeIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Permit Type</span>",
            dataIndex: 'permitTypeIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>ROM</span>",
            dataIndex: 'exactRomIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;>Fines</span>",
            dataIndex: 'exactFinesIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Lumps</span>",
            dataIndex: 'exactLumpsIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Concentrates</span>",
            dataIndex: 'exactConcentratesIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Tailings</span>",
            dataIndex: 'exactTailingsIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Permit Quantity</span>",
            dataIndex: 'quantityDataIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Used Quantity</span>",
            dataIndex: 'usedQtyIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Permit Balance</span>",
            dataIndex: 'permitBalanceIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>To Source</span>",
            dataIndex: 'toSourceIndex',
            align: 'right',
            hidden:false,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
        	header: "<span style=font-weight:bold;>Self Consumption Quantity</span>",
            dataIndex: 'selfconsIndex',
            align: 'right',
            hidden:false,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Processing Fee</span>",
            dataIndex: 'pfIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Total Processing Fee</span>",
            dataIndex: 'totalPfIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Closed Quantity</span>",
            dataIndex: 'closedQtyIndex',
            align: 'right',
            hidden:true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>TC No</span>",
            dataIndex: 'tcNoIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Mine Code</span>",
            dataIndex: 'mineCodeDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Lease Name</span>",
            dataIndex: 'leaseNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Lease Owner</span>",
            dataIndex: 'leaseOwnerDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Organization/Trader Code</span>",
            dataIndex: 'organizationCodeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Organization/Trader Name</span>",
            dataIndex: 'organizationNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Mineral Type</span>",
            dataIndex: 'mineralDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Route_Id</span>",
            dataIndex: 'routeIdDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>From Location</span>",
            dataIndex: 'fromLocationDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>To Location</span>",
            dataIndex: 'toLocationDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Ref</span>",
            dataIndex: 'refDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Id</span>",
            dataIndex: 'uniqueidDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Remarks</span>",
            dataIndex: 'remarksDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Start Date</span>",
            dataIndex: 'startdateDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>End Date</span>",
            dataIndex: 'enddateDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Buyer Name</span>",
            dataIndex: 'buyerDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Country Name</span>",
            dataIndex: 'countryNameDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Country Id</span>",
            dataIndex: 'countryIdDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>State Name</span>",
            dataIndex: 'stateNameDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>State Id</span>",
            dataIndex: 'stateIdDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Vessel Name</span>",
            dataIndex: 'shipNameDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Route</span>",
            dataIndex: 'routeDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Buying Org Id</span>",
            dataIndex: 'buyingOrgIdDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Buying Organization/Trader Name</span>",
            dataIndex: 'buyingOrgNameDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Buying Organization/Trader Code</span>",
            dataIndex: 'buyingOrgCodeDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Existing Permit No</span>",
            dataIndex: 'existingPermitIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Import Type</span>",
            dataIndex: 'importTypeDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Source Hub Name</span>",
            dataIndex: 'hubNameIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>To Location</span>",
            dataIndex: 'toLocIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Source Type</span>",
            dataIndex: 'destTypeDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Mother Route</span>",
            dataIndex: 'motherRDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Route Type</span>",
            dataIndex: 'leaseTypeDataIndex',
            hidden: false,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Processing Fee Type</span>",
            dataIndex: 'processingFeeTypeDataIndex',
            hidden: false,
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

