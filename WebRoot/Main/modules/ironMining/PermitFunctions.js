function modifyFunction(selected, status) {
    Ext.getCmp('buyingOrgComboId').reset();
    Ext.getCmp('buyingOrgCodeid').reset();
    Ext.getCmp('vesselNameId').reset()

    if (selected.get('permitTypeIndex') == 'Processed Ore Transit') {
        gridPanel.show();
        proccessedOreGrid.show();
        outerPanelForGrid.hide();
        gridForExportDetails.show();
        outerPanelForBauxiteGrid.hide();
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);

        Ext.getCmp('mandatoryHead6').hide();
        Ext.getCmp('mandatorytcno').hide();
        Ext.getCmp('TcNoLabelId').hide();
        Ext.getCmp('TccomboId').hide();
        Ext.getCmp('mandatoryHead7').hide();
        Ext.getCmp('mandatoryminecode').hide();
        Ext.getCmp('mineCodeLabel').hide();
        Ext.getCmp('minecodeId').hide();
        Ext.getCmp('mandatoryHead8').hide();
        Ext.getCmp('mandatoryleasename').hide();
        Ext.getCmp('leaseNameLabel').hide();
        Ext.getCmp('leaseNameid').hide();
        Ext.getCmp('mandatoryHead9').hide();
        Ext.getCmp('mandatoryleaseowner').hide();
        Ext.getCmp('leaseOwnerLabel').hide();
        Ext.getCmp('leaseOwnerid').hide();
        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();
        Ext.getCmp('mandatoryHead19').show();
        Ext.getCmp('mandatoryorganizationCode').show();
        Ext.getCmp('organizationCodeLabel').show();
        Ext.getCmp('organizationcodeid').show();

        Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));

        exportStore.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        StockTypeStore1.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        setTimeout(function() {
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('uniqueidDataIndex')
                }
            });
        }, 500);


        Ext.getCmp('mandatorybuyer').hide();
        Ext.getCmp('labelBuyer').hide();
        Ext.getCmp('buyerId').hide();
        Ext.getCmp('mandatoryHead18').hide();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();

        Ext.getCmp('mandatoryship').hide();
        Ext.getCmp('labelShip').hide();
        Ext.getCmp('shipId').hide();
        Ext.getCmp('mandatoryHead20').hide();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();
        
        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

        Store2.load({
            params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                id: selected.get('uniqueidDataIndex')
            }
        });
    } else {
        Ext.getCmp('mandatoryHead6').show();
        Ext.getCmp('mandatorytcno').show();
        Ext.getCmp('TcNoLabelId').show();
        Ext.getCmp('TccomboId').show();
        Ext.getCmp('mandatoryHead7').show();
        Ext.getCmp('mandatoryminecode').show();
        Ext.getCmp('mineCodeLabel').show();
        Ext.getCmp('minecodeId').show();
        Ext.getCmp('mandatoryHead8').show();
        Ext.getCmp('mandatoryleasename').show();
        Ext.getCmp('leaseNameLabel').show();
        Ext.getCmp('leaseNameid').show();
        Ext.getCmp('mandatoryHead9').show();
        Ext.getCmp('mandatoryleaseowner').show();
        Ext.getCmp('leaseOwnerLabel').show();
        Ext.getCmp('leaseOwnerid').show();

        Ext.getCmp('mandatoryHead19').hide();
        Ext.getCmp('mandatoryorganizationCode').hide();
        Ext.getCmp('organizationCodeLabel').hide();
        Ext.getCmp('organizationcodeid').hide();

        Ext.getCmp('mandatorybuyer').hide();
        Ext.getCmp('labelBuyer').hide();
        Ext.getCmp('buyerId').hide();
        Ext.getCmp('mandatoryHead18').hide();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();

        Ext.getCmp('mandatoryship').hide();
        Ext.getCmp('labelShip').hide();
        Ext.getCmp('shipId').hide();
        Ext.getCmp('mandatoryHead20').hide();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').hide();
        Ext.getCmp('mandatoryMwallet').hide();
        Ext.getCmp('mwalletLabelId').hide();
        Ext.getCmp('mwalletId').hide();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();
        
        Ext.getCmp('desttypeId').show();
        Ext.getCmp('mandatorydesttype').show();
        Ext.getCmp('destLabelId1').show();
        Ext.getCmp('mandatoryHead1d6').show();

        gradeStore.load({
            params: {
                CustID: custId,
                challanid: selected.get('challanIdDataIndex'),
                permitId: selected.get('uniqueidDataIndex'),
                permitType: selected.get('permitTypeIndex'),
                buttinValue: 'Modify'
            }
        });
        if (selected.get('destTypeDataIndex') == 'E-Wallet') {
            outerPanelForGrid.show();
            gridPanel.hide();
            proccessedOreGrid.hide();
            gridForExportDetails.hide();
            outerPanelForBauxiteGrid.hide();

            Ext.getCmp('mandatoryHead15').show();
            Ext.getCmp('mandatoryref').show();
            Ext.getCmp('refId').show();
            Ext.getCmp('RefcomboId').show();
            
            Ext.getCmp('desttypeId').setValue(selected.get('destTypeDataIndex'));
            Ext.getCmp('desttypeId').setReadOnly(true);
        } else {
            gridPanel.show();
            proccessedOreGrid.show();
            outerPanelForGrid.hide();
            gridForExportDetails.show();
            outerPanelForBauxiteGrid.hide();

            Ext.getCmp('mandatoryHead15').hide();
            Ext.getCmp('mandatoryref').hide();
            Ext.getCmp('refId').hide();
            Ext.getCmp('RefcomboId').hide();
            
            Ext.getCmp('mandatoryHead6').hide();
            Ext.getCmp('mandatorytcno').hide();
            Ext.getCmp('TcNoLabelId').hide();
            Ext.getCmp('TccomboId').hide();
            Ext.getCmp('mandatoryHead7').hide();
            Ext.getCmp('mandatoryminecode').hide();
            Ext.getCmp('mineCodeLabel').hide();
            Ext.getCmp('minecodeId').hide();
            Ext.getCmp('mandatoryHead8').hide();
            Ext.getCmp('mandatoryleasename').hide();
            Ext.getCmp('leaseNameLabel').hide();
            Ext.getCmp('leaseNameid').hide();
            Ext.getCmp('mandatoryHead9').hide();
            Ext.getCmp('mandatoryleaseowner').hide();
            Ext.getCmp('leaseOwnerLabel').hide();
            Ext.getCmp('leaseOwnerid').hide();
            Ext.getCmp('mandatoryHead15').hide();
            Ext.getCmp('mandatoryref').hide();
            Ext.getCmp('refId').hide();
            Ext.getCmp('RefcomboId').hide();
            Ext.getCmp('mandatoryHead19').show();
            Ext.getCmp('mandatoryorganizationCode').show();
            Ext.getCmp('organizationCodeLabel').show();
            Ext.getCmp('organizationcodeid').show();
            
            Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));
            Ext.getCmp('desttypeId').setValue(selected.get('destTypeDataIndex'));
            Ext.getCmp('desttypeId').setReadOnly(true);
            
            exportStore.load({
                params: {
                    orgCode: selected.get('organizationIdDataIndex'),
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    mineralType: selected.get('mineralDataIndex'),
                    routeId: selected.get('routeDataIndex'),
                    permitType: selected.get('permitTypeIndex')
                }
            });
            StockTypeStore1.load({
                params: {
                    orgCode: selected.get('organizationIdDataIndex'),
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    mineralType: selected.get('mineralDataIndex'),
                    routeId: selected.get('routeDataIndex'),
                    permitType: selected.get('permitTypeIndex')
                }
            });
            
            setTimeout(function() {
                Store2.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        id: selected.get('uniqueidDataIndex')
                    }
                });
            }, 500);

        }
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);
    }
    if (selected.get('permitTypeIndex') == 'Domestic Export' || selected.get('importTypeDataIndex') == 'Domestic Import') {
        gridPanel.show();
        outerPanelForGrid.hide();
        proccessedOreGrid.show();
        gridForExportDetails.show();
        outerPanelForBauxiteGrid.hide();
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);
        stateComboStore.load();
        Ext.getCmp('mandatoryHead6').hide();
        Ext.getCmp('mandatorytcno').hide();
        Ext.getCmp('TcNoLabelId').hide();
        Ext.getCmp('TccomboId').hide();
        Ext.getCmp('mandatoryHead7').hide();
        Ext.getCmp('mandatoryminecode').hide();
        Ext.getCmp('mineCodeLabel').hide();
        Ext.getCmp('minecodeId').hide();
        Ext.getCmp('mandatoryHead8').hide();
        Ext.getCmp('mandatoryleasename').hide();
        Ext.getCmp('leaseNameLabel').hide();
        Ext.getCmp('leaseNameid').hide();
        Ext.getCmp('mandatoryHead9').hide();
        Ext.getCmp('mandatoryleaseowner').hide();
        Ext.getCmp('leaseOwnerLabel').hide();
        Ext.getCmp('leaseOwnerid').hide();
        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();
        Ext.getCmp('mandatoryHead19').show();
        Ext.getCmp('mandatoryorganizationCode').show();
        Ext.getCmp('organizationCodeLabel').show();
        Ext.getCmp('organizationcodeid').show();

        Ext.getCmp('mandatorybuyer').show();
        Ext.getCmp('labelBuyer').show();
        Ext.getCmp('buyerId').show();
        Ext.getCmp('mandatoryHead18').show();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();

        Ext.getCmp('mandatoryHead200').show();
        Ext.getCmp('mandatorystate').show();
        Ext.getCmp('labelstate').show();
        Ext.getCmp('stateComboId').show();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();

        Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));
        exportStore.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        StockTypeStore1.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        setTimeout(function() {
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('ExtpermitIdDataIndex')
                }
            });
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('uniqueidDataIndex')
                }
            });
        }, 500);

        Ext.getCmp('buyerId').setValue(selected.get('buyerDataIndex'));
        Ext.getCmp('stateComboId').setValue(selected.get('stateNameDataIndex'));
        Ext.getCmp('countryComboId').reset();
        Ext.getCmp('shipId').reset();

        if (selected.get('importTypeDataIndex') == 'Domestic Import') {
            gridPanel.show();
            outerPanelForGrid.hide();
            proccessedOreGrid.show();
            gridForExportDetails.hide();
            outerPanelForBauxiteGrid.hide();
            proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), true);
            stateComboStore.load();

            Ext.getCmp('mandatorybuyer').hide();
            Ext.getCmp('labelBuyer').hide();
            Ext.getCmp('buyerId').hide();
            Ext.getCmp('mandatoryHead18').hide();
        }
    }
    if (selected.get('permitTypeIndex') == 'International Export' || selected.get('importTypeDataIndex') == 'International Import') {

        gridPanel.show();
        outerPanelForGrid.hide();
        proccessedOreGrid.show();
        gridForExportDetails.show();
        countryComboStore.load();
        outerPanelForBauxiteGrid.hide();
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);

        Ext.getCmp('mandatoryHead6').hide();
        Ext.getCmp('mandatorytcno').hide();
        Ext.getCmp('TcNoLabelId').hide();
        Ext.getCmp('TccomboId').hide();
        Ext.getCmp('mandatoryHead7').hide();
        Ext.getCmp('mandatoryminecode').hide();
        Ext.getCmp('mineCodeLabel').hide();
        Ext.getCmp('minecodeId').hide();
        Ext.getCmp('mandatoryHead8').hide();
        Ext.getCmp('mandatoryleasename').hide();
        Ext.getCmp('leaseNameLabel').hide();
        Ext.getCmp('leaseNameid').hide();
        Ext.getCmp('mandatoryHead9').hide();
        Ext.getCmp('mandatoryleaseowner').hide();
        Ext.getCmp('leaseOwnerLabel').hide();
        Ext.getCmp('leaseOwnerid').hide();
        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();
        Ext.getCmp('mandatoryHead19').show();
        Ext.getCmp('mandatoryorganizationCode').show();
        Ext.getCmp('organizationCodeLabel').show();
        Ext.getCmp('organizationcodeid').show();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();

        Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));
        Ext.getCmp('buyerId').setValue(selected.get('buyerDataIndex'));
        vesselNameStore.load({
            params: {
                custId: Ext.getCmp('custcomboId').getValue()
            }
        });
        exportStore.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        StockTypeStore1.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        setTimeout(function() {
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('uniqueidDataIndex')
                }
            });
        }, 500);

        Ext.getCmp('mandatorybuyer').show();
        Ext.getCmp('labelBuyer').show();
        Ext.getCmp('buyerId').show();
        Ext.getCmp('mandatoryHead18').show();

        Ext.getCmp('mandatoryship').show();
        Ext.getCmp('labelShip').show();
        Ext.getCmp('shipId').show();
        Ext.getCmp('mandatoryHead20').show();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatorycountry').show();
        Ext.getCmp('labelcountry').show();
        Ext.getCmp('countryComboId').show();
        Ext.getCmp('mandatoryHead199').show();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('shipId').setValue(selected.get('shipNameDataIndex'));
        Ext.getCmp('countryComboId').setValue(selected.get('countryNameDataIndex'));
        Ext.getCmp('stateComboId').reset();

        if (selected.get('importTypeDataIndex') == 'International Import') {
            gridPanel.show();
            outerPanelForGrid.hide();
            proccessedOreGrid.show();
            gridForExportDetails.hide();
            outerPanelForBauxiteGrid.hide();
            proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), true);
            stateComboStore.load();

            Ext.getCmp('mandatorybuyer').hide();
            Ext.getCmp('labelBuyer').hide();
            Ext.getCmp('buyerId').hide();
            Ext.getCmp('mandatoryHead18').hide();

            Ext.getCmp('mandatoryship').hide();
            Ext.getCmp('labelShip').hide();
            Ext.getCmp('shipId').hide();
            Ext.getCmp('mandatoryHead20').hide();

            Ext.getCmp('shipId').reset();
            Ext.getCmp('buyerId').reset();
        }
    }
    if (selected.get('permitTypeIndex') == 'Rom Sale') {
        countryComboStore.load();
        stateComboStore1.load({
            params: {
                countryid: selected.get('countryIdDataIndex')
            }
        });
        if (selected.get('destTypeDataIndex') == 'E-Wallet') {
            outerPanelForGrid.show();
            gridPanel.hide();
            proccessedOreGrid.hide();
            gridForExportDetails.hide();
            outerPanelForBauxiteGrid.hide();

            Ext.getCmp('mandatoryHead15').show();
            Ext.getCmp('mandatoryref').show();
            Ext.getCmp('refId').show();
            Ext.getCmp('RefcomboId').show();
            
            Ext.getCmp('desttypeId').setValue(selected.get('destTypeDataIndex'));
            Ext.getCmp('desttypeId').setReadOnly(true);
        } else {
            gridPanel.show();
            proccessedOreGrid.show();
            outerPanelForGrid.hide();
            gridForExportDetails.show();
            outerPanelForBauxiteGrid.hide();

            Ext.getCmp('mandatoryHead15').hide();
            Ext.getCmp('mandatoryref').hide();
            Ext.getCmp('refId').hide();
            Ext.getCmp('RefcomboId').hide();
            
            Ext.getCmp('mandatoryHead6').hide();
            Ext.getCmp('mandatorytcno').hide();
            Ext.getCmp('TcNoLabelId').hide();
            Ext.getCmp('TccomboId').hide();
            Ext.getCmp('mandatoryHead7').hide();
            Ext.getCmp('mandatoryminecode').hide();
            Ext.getCmp('mineCodeLabel').hide();
            Ext.getCmp('minecodeId').hide();
            Ext.getCmp('mandatoryHead8').hide();
            Ext.getCmp('mandatoryleasename').hide();
            Ext.getCmp('leaseNameLabel').hide();
            Ext.getCmp('leaseNameid').hide();
            Ext.getCmp('mandatoryHead9').hide();
            Ext.getCmp('mandatoryleaseowner').hide();
            Ext.getCmp('leaseOwnerLabel').hide();
            Ext.getCmp('leaseOwnerid').hide();
            Ext.getCmp('mandatoryHead15').hide();
            Ext.getCmp('mandatoryref').hide();
            Ext.getCmp('refId').hide();
            Ext.getCmp('RefcomboId').hide();
            Ext.getCmp('mandatoryHead19').show();
            Ext.getCmp('mandatoryorganizationCode').show();
            Ext.getCmp('organizationCodeLabel').show();
            Ext.getCmp('organizationcodeid').show();
            
            Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));
            Ext.getCmp('desttypeId').setValue(selected.get('destTypeDataIndex'));
            Ext.getCmp('desttypeId').setReadOnly(true);
            
            exportStore.load({
                params: {
                    orgCode: selected.get('organizationIdDataIndex'),
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    mineralType: selected.get('mineralDataIndex'),
                    routeId: selected.get('routeDataIndex'),
                    permitType: selected.get('permitTypeIndex')
                }
            });
            StockTypeStore1.load({
                params: {
                    orgCode: selected.get('organizationIdDataIndex'),
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    mineralType: selected.get('mineralDataIndex'),
                    routeId: selected.get('routeDataIndex'),
                    permitType: selected.get('permitTypeIndex')
                }
            });
            
            setTimeout(function() {
                Store2.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        id: selected.get('uniqueidDataIndex')
                    }
                });
            }, 500);

        }
        Ext.getCmp('mandatoryHead001').show();
        Ext.getCmp('mandatoryoBuyingOrgName').show();
        Ext.getCmp('BuyingOrgNameLabel').show();
        Ext.getCmp('buyingOrgComboId').show();
        Ext.getCmp('buyingOrgComboId').setRawValue(selected.get('buyingOrgNameDataIndex'));

        Ext.getCmp('mandatoryHead002').show();
        Ext.getCmp('mandatorybuyingOrgCode').show();
        Ext.getCmp('buyingOrgCodeid').show();
        Ext.getCmp('buyingOrgCodeLabel').show();
        Ext.getCmp('buyingOrgCodeid').setValue(selected.get('buyingOrgCodeDataIndex'));

        Ext.getCmp('mandatorybuyer').hide();
        Ext.getCmp('labelBuyer').hide();
        Ext.getCmp('buyerId').hide();
        Ext.getCmp('mandatoryHead18').hide();

        Ext.getCmp('mandatoryship').hide();
        Ext.getCmp('labelShip').hide();
        Ext.getCmp('shipId').hide();
        Ext.getCmp('mandatoryHead20').hide();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();
        // Ext.getCmp('countryComboId').setValue(selected.get('countryNameDataIndex'));

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').hide();
        Ext.getCmp('mandatoryMwallet').hide();
        Ext.getCmp('mwalletLabelId').hide();
        Ext.getCmp('mwalletId').hide();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();

        Ext.getCmp('stateComboId1').setValue(selected.get('stateNameDataIndex'));

        gradeStore.load({
            params: {
                CustID: custId,
                challanid: selected.get('challanIdDataIndex'),
                permitId: selected.get('uniqueidDataIndex'),
                permitType: selected.get('permitTypeIndex'),
                buttinValue: 'Modify'
            }
        });
        buyingOrgComboStore.load({
            params: {
                orgCode: 0,
                CustID: Ext.getCmp('custcomboId').getValue()
            }
        });
        
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);
    }

    if (selected.get('permitTypeIndex') == 'Processed Ore Sale' || selected.get('permitTypeIndex') == 'Processed Ore Sale Transit') {
        gridPanel.show();
        proccessedOreGrid.show();
        outerPanelForGrid.hide();
        gridForExportDetails.show();
        outerPanelForBauxiteGrid.hide();
        countryComboStore.load();
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);
        stateComboStore1.load({
            params: {
                countryid: selected.get('countryIdDataIndex')
            }
        });

        Ext.getCmp('mandatoryHead6').hide();
        Ext.getCmp('mandatorytcno').hide();
        Ext.getCmp('TcNoLabelId').hide();
        Ext.getCmp('TccomboId').hide();
        Ext.getCmp('mandatoryHead7').hide();
        Ext.getCmp('mandatoryminecode').hide();
        Ext.getCmp('mineCodeLabel').hide();
        Ext.getCmp('minecodeId').hide();
        Ext.getCmp('mandatoryHead8').hide();
        Ext.getCmp('mandatoryleasename').hide();
        Ext.getCmp('leaseNameLabel').hide();
        Ext.getCmp('leaseNameid').hide();
        Ext.getCmp('mandatoryHead9').hide();
        Ext.getCmp('mandatoryleaseowner').hide();
        Ext.getCmp('leaseOwnerLabel').hide();
        Ext.getCmp('leaseOwnerid').hide();
        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();
        Ext.getCmp('mandatoryHead19').show();
        Ext.getCmp('mandatoryorganizationCode').show();
        Ext.getCmp('organizationCodeLabel').show();
        Ext.getCmp('organizationcodeid').show();
        Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));
        exportStore.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        StockTypeStore1.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue(),
                mineralType: selected.get('mineralDataIndex'),
                routeId: selected.get('routeDataIndex'),
                permitType: selected.get('permitTypeIndex')
            }
        });
        setTimeout(function() {
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('uniqueidDataIndex')
                }
            });
        }, 500);

        Ext.getCmp('mandatorybuyer').hide();
        Ext.getCmp('labelBuyer').hide();
        Ext.getCmp('buyerId').hide();
        Ext.getCmp('mandatoryHead18').hide();

        Ext.getCmp('mandatoryship').hide();
        Ext.getCmp('labelShip').hide();
        Ext.getCmp('shipId').hide();
        Ext.getCmp('mandatoryHead20').hide();

        Ext.getCmp('mandatorycountry').show();
        Ext.getCmp('labelcountry').show();
        Ext.getCmp('countryComboId').show();
        Ext.getCmp('mandatoryHead199').show();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHeadState').show();
        Ext.getCmp('mandatorystateName').show();
        Ext.getCmp('labelstateName').show();
        Ext.getCmp('stateComboId1').show();

        Ext.getCmp('mandatoryHead001').show();
        Ext.getCmp('mandatoryoBuyingOrgName').show();
        Ext.getCmp('BuyingOrgNameLabel').show();
        Ext.getCmp('buyingOrgComboId').show();

        Ext.getCmp('mandatoryHead002').show();
        Ext.getCmp('mandatorybuyingOrgCode').show();
        Ext.getCmp('buyingOrgCodeid').show();
        Ext.getCmp('buyingOrgCodeLabel').show();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();

        Ext.getCmp('countryComboId').setValue(selected.get('countryNameDataIndex'));
        Ext.getCmp('stateComboId1').setValue(selected.get('stateNameDataIndex'));
        Ext.getCmp('buyingOrgComboId').setRawValue(selected.get('buyingOrgNameDataIndex'));


        Ext.getCmp('buyingOrgCodeid').setValue(selected.get('buyingOrgCodeDataIndex'));

        Store2.load({
            params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                id: selected.get('uniqueidDataIndex')
            }
        });
        buyingOrgComboStore.load({
            params: {
                orgCode: selected.get('organizationIdDataIndex'),
                CustID: Ext.getCmp('custcomboId').getValue()
            }
        });
    }
    if (selected.get('permitTypeIndex') == 'Bauxite Transit') {

        Ext.getCmp('mandatoryHead160').show();
        Ext.getCmp('bauxiteChallanId').show();
        Ext.getCmp('mandatorybu').show();
        Ext.getCmp('BuChallancomboId').show();

        Ext.getCmp('BuChallancomboId').setValue(selected.get('refDataIndex'));
        outerPanelForBauxiteGrid.show();
        outerPanelForGrid.hide();
        gridPanel.hide();
        proccessedOreGrid.hide();
        gridForExportDetails.hide();
        Ext.getCmp('mandatoryHead6').show();
        Ext.getCmp('mandatorytcno').show();
        Ext.getCmp('TcNoLabelId').show();
        Ext.getCmp('TccomboId').show();
        Ext.getCmp('mandatoryHead7').show();
        Ext.getCmp('mandatoryminecode').show();
        Ext.getCmp('mineCodeLabel').show();
        Ext.getCmp('minecodeId').show();
        Ext.getCmp('mandatoryHead8').show();
        Ext.getCmp('mandatoryleasename').show();
        Ext.getCmp('leaseNameLabel').show();
        Ext.getCmp('leaseNameid').show();
        Ext.getCmp('mandatoryHead9').show();
        Ext.getCmp('mandatoryleaseowner').show();
        Ext.getCmp('leaseOwnerLabel').show();
        Ext.getCmp('leaseOwnerid').show();

        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();

        Ext.getCmp('mandatoryHead19').hide();
        Ext.getCmp('mandatoryorganizationCode').hide();
        Ext.getCmp('organizationCodeLabel').hide();
        Ext.getCmp('organizationcodeid').hide();

        Ext.getCmp('mandatorybuyer').hide();
        Ext.getCmp('labelBuyer').hide();
        Ext.getCmp('buyerId').hide();
        Ext.getCmp('mandatoryHead18').hide();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();

        Ext.getCmp('mandatoryship').hide();
        Ext.getCmp('labelShip').hide();
        Ext.getCmp('shipId').hide();
        Ext.getCmp('mandatoryHead20').hide();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead0m').hide();
        Ext.getCmp('mandatoryMwallet').hide();
        Ext.getCmp('mwalletLabelId').hide();
        Ext.getCmp('mwalletId').hide();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

        storeForBauxite.load({
            params: {
                CustID: custId,
                challanid: selected.get('challanIdDataIndex')
            }
        });
    }
    if ((selected.get('permitTypeIndex') == 'Rom Transit' && selected.get('destTypeDataIndex') == 'ROM') || selected.get('permitTypeIndex') == 'Purchased Rom Sale Transit Permit' || selected.get('permitTypeIndex') == 'Processed Ore Transit' || selected.get('permitTypeIndex') == 'Processed Ore Sale' || selected.get('permitTypeIndex') == 'International Export' ||
        selected.get('permitTypeIndex') == 'Processed Ore Sale Transit' || selected.get('permitTypeIndex') == 'Domestic Export' || selected.get('permitTypeIndex') == 'Import Permit' || selected.get('permitTypeIndex') == 'Import Transit Permit') {
        var row = organizationCodeStore.find('id', (selected.get('organizationIdDataIndex')));
        var rec = organizationCodeStore.getAt(row);
        var mWalletBalModify = rec.data['mWalletBalance'];
        Ext.getCmp('mwalletId').setValue(mWalletBalModify);
    }
    if (selected.get('permitTypeIndex') == 'Import Permit') {
        Ext.getCmp('importtypecomboId').setValue(selected.get('importTypeDataIndex'));
        Ext.getCmp('importpurposecomboId').setValue(selected.get('importPurposeDataIndex'));
        Ext.getCmp('vesselNameId').setValue(selected.get('vesselNameDataIndex'));

        Ext.getCmp('importtypecomboId').show();
        Ext.getCmp('importTypeHeader').show();
        Ext.getCmp('mandatoryImporttype').show();
        Ext.getCmp('importTypeId').show();

        Ext.getCmp('importpurposecomboId').show();
        Ext.getCmp('importPurId').show();
        Ext.getCmp('mandatoryImportPurpose').show();
        Ext.getCmp('importPurposeHeader').show();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').show();
        Ext.getCmp('vesselNameId').show();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

    }
    if (selected.get('permitTypeIndex') == 'Import Transit Permit') {
        gridPanel.show();
        proccessedOreGrid.show();
        outerPanelForGrid.hide();
        gridForExportDetails.hide();
        outerPanelForBauxiteGrid.hide();
        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), true);

        Ext.getCmp('mandatoryHead6').hide();
        Ext.getCmp('mandatorytcno').hide();
        Ext.getCmp('TcNoLabelId').hide();
        Ext.getCmp('TccomboId').hide();
        Ext.getCmp('mandatoryHead7').hide();
        Ext.getCmp('mandatoryminecode').hide();
        Ext.getCmp('mineCodeLabel').hide();
        Ext.getCmp('minecodeId').hide();
        Ext.getCmp('mandatoryHead8').hide();
        Ext.getCmp('mandatoryleasename').hide();
        Ext.getCmp('leaseNameLabel').hide();
        Ext.getCmp('leaseNameid').hide();
        Ext.getCmp('mandatoryHead9').hide();
        Ext.getCmp('mandatoryleaseowner').hide();
        Ext.getCmp('leaseOwnerLabel').hide();
        Ext.getCmp('leaseOwnerid').hide();
        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();
        Ext.getCmp('mandatoryHead19').show();
        Ext.getCmp('mandatoryorganizationCode').show();
        Ext.getCmp('organizationCodeLabel').show();
        Ext.getCmp('organizationcodeid').show();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

        Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));

        setTimeout(function() {
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('ExtpermitIdDataIndex')
                }
            });
        }, 500);

        Ext.getCmp('mandatorybuyer').hide();
        Ext.getCmp('labelBuyer').hide();
        Ext.getCmp('buyerId').hide();
        Ext.getCmp('mandatoryHead18').hide();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();

        Ext.getCmp('mandatoryship').hide();
        Ext.getCmp('labelShip').hide();
        Ext.getCmp('shipId').hide();
        Ext.getCmp('mandatoryHead20').hide();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').show();
        Ext.getCmp('mandatoryImportPermit').show();
        Ext.getCmp('importPermitLabelId').show();
        Ext.getCmp('importedPermitId').show();

        Ext.getCmp('importVesselHeader').show();
        Ext.getCmp('mandatoryImportVessel').show();
        Ext.getCmp('vesselLabelId').show();
        Ext.getCmp('vesselNameId').show();

        Ext.getCmp('importExpPermitHeader').show();
        Ext.getCmp('mandatoryExpPermitNo').show();
        Ext.getCmp('expPermitLabel').show();
        Ext.getCmp('exportPermitNoId').show();

        Ext.getCmp('exportPermitDateHeader').show();
        Ext.getCmp('mandatoryExpPermitDate').show();
        Ext.getCmp('expPermitDtLabel').show();
        Ext.getCmp('exportPermitDateId').show();

        Ext.getCmp('importExpChallanHeader').show();
        Ext.getCmp('mandatoryExpChallanNo').show();
        Ext.getCmp('expChallanLabel').show();
        Ext.getCmp('exportChallanNoId').show();

        Ext.getCmp('exportchallanDateHeader').show();
        Ext.getCmp('mandatoryExpchallanDate').show();
        Ext.getCmp('expChallanDtLabel').show();
        Ext.getCmp('exportChallanDateId').show();

        Ext.getCmp('saleInvoiceNoHeader').show();
        Ext.getCmp('mandatorySaleInvoiceNo').show();
        Ext.getCmp('saleInvoiceLabel').show();
        Ext.getCmp('saleInvoiceNoId').show();

        Ext.getCmp('saleInvoiceDateHeader').show();
        Ext.getCmp('mandatorysaleInvoiceDate').show();
        Ext.getCmp('saleInvoiceDtLabel').show();
        Ext.getCmp('saleInvoiceDateId').show();

        Ext.getCmp('transportnTypeHeader').show();
        Ext.getCmp('mandatorytransportnType').show();
        Ext.getCmp('transportnTypeLabelId').show();
        Ext.getCmp('transportnTypecomboId').show();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

        Ext.getCmp('importedPermitId').setValue(selected.get('existingPermitIndex'));
        Ext.getCmp('vesselNameId').setValue(selected.get('vesselNameDataIndex'));
        Ext.getCmp('exportPermitNoId').setValue(selected.get('exportPermitDataIndex'));
        Ext.getCmp('exportPermitDateId').setValue(selected.get('exportPermitDateDataIndex'));
        Ext.getCmp('exportChallanNoId').setValue(selected.get('exportChallanDataIndex'));
        Ext.getCmp('exportChallanDateId').setValue(selected.get('exportChallanDateDataIndex'));
        Ext.getCmp('saleInvoiceNoId').setValue(selected.get('saleInvoiceDataIndex'));
        Ext.getCmp('saleInvoiceDateId').setValue(selected.get('saleInvoiceDateDataIndex'));
        Ext.getCmp('transportnTypecomboId').setValue(selected.get('transportnDataIndex'));
    }
    if (selected.get('permitTypeIndex') == 'Processed Ore Sale' || selected.get('permitTypeIndex') == 'Rom Sale') {
        Ext.getCmp('routeidcomboId').hide();
        Ext.getCmp('mineralRouteId').hide();
        Ext.getCmp('mandatoryrouteid').hide();
        Ext.getCmp('mandatoryHead12').hide();

        Ext.getCmp('mandatoryHead13').hide();
        Ext.getCmp('mandatoryfromloc').hide();
        Ext.getCmp('fromId').hide();
        Ext.getCmp('fromlocId').hide();

        Ext.getCmp('mandatoryHead14').hide();
        Ext.getCmp('mandatorytoloc').hide();
        Ext.getCmp('toId').hide();
        Ext.getCmp('tolocId').hide();

        Ext.getCmp('hubId').show();
        Ext.getCmp('hubLablelId').show();
        Ext.getCmp('manrouteId').show();
        Ext.getCmp('mandatoryHead12ty').show();

        Ext.getCmp('mandatorycountry').hide();
        Ext.getCmp('labelcountry').hide();
        Ext.getCmp('countryComboId').hide();
        Ext.getCmp('mandatoryHead199').hide();

        Ext.getCmp('mandatoryHeadState').hide();
        Ext.getCmp('mandatorystateName').hide();
        Ext.getCmp('labelstateName').hide();
        Ext.getCmp('stateComboId1').hide();

        Ext.getCmp('mandatoryrspermitId').hide();
        Ext.getCmp('rspermitLabelId').hide();
        Ext.getCmp('mandatoryHead1e').hide();
        Ext.getCmp('romPermitId').hide();

        Ext.getCmp('toLocationId').hide();
        Ext.getCmp('mandatoryrstoLocId').hide();
        Ext.getCmp('toLoclabelId').hide();
        Ext.getCmp('mandatoryHead1to').hide();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

        Ext.getCmp('hubId').setReadOnly(true);
        Ext.getCmp('hubId').setValue(selected.get('hubNameIndex'));

    } else {
        Ext.getCmp('routeidcomboId').show();
        Ext.getCmp('mineralRouteId').show();
        Ext.getCmp('mandatoryrouteid').show();
        Ext.getCmp('mandatoryHead12').show();

        Ext.getCmp('mandatoryHead13').show();
        Ext.getCmp('mandatoryfromloc').show();
        Ext.getCmp('fromId').show();
        Ext.getCmp('fromlocId').show();

        Ext.getCmp('mandatoryHead14').show();
        Ext.getCmp('mandatorytoloc').show();
        Ext.getCmp('toId').show();
        Ext.getCmp('tolocId').show();

        Ext.getCmp('hubId').hide();
        Ext.getCmp('hubLablelId').hide();
        Ext.getCmp('manrouteId').hide();
        Ext.getCmp('mandatoryHead12ty').hide();
    }
    if (selected.get('permitTypeIndex') == 'Purchased Rom Sale Transit Permit') {
    	
    	if(selected.get('srcTypePrstpIndex')=='ROM'){
    		outerPanelForGrid.hide();
            gridPanel.show();
            proccessedOreGrid.show();
            gridForExportDetails.hide();
            outerPanelForBauxiteGrid.hide();
            
            setTimeout(function() {
	            Store2.load({
	                params: {
	                    CustID: Ext.getCmp('custcomboId').getValue(),
	                    permitType: selected.get('permitTypeIndex'),
	                    id: permitID
	                }
	            });
	        }, 1000);
    	}else{
    		outerPanelForGrid.show();
            gridPanel.hide();
            proccessedOreGrid.hide();
            gridForExportDetails.hide();
            outerPanelForBauxiteGrid.hide();
            gradeStore.load({
                params: {
                    CustID: custId,
                    challanid: selected.get('challanIdDataIndex'),
                    permitId: selected.get('uniqueidDataIndex'),
                    permitType: selected.get('permitTypeIndex'),
                    buttinValue: 'Modify'
                }
            });
    	}
    	
        Ext.getCmp('mandatoryHead6').hide();
        Ext.getCmp('mandatorytcno').hide();
        Ext.getCmp('TcNoLabelId').hide();
        Ext.getCmp('TccomboId').hide();
        Ext.getCmp('mandatoryHead7').hide();
        Ext.getCmp('mandatoryminecode').hide();
        Ext.getCmp('mineCodeLabel').hide();
        Ext.getCmp('minecodeId').hide();
        Ext.getCmp('mandatoryHead8').hide();
        Ext.getCmp('mandatoryleasename').hide();
        Ext.getCmp('leaseNameLabel').hide();
        Ext.getCmp('leaseNameid').hide();
        Ext.getCmp('mandatoryHead9').hide();
        Ext.getCmp('mandatoryleaseowner').hide();
        Ext.getCmp('leaseOwnerLabel').hide();
        Ext.getCmp('leaseOwnerid').hide();
        Ext.getCmp('mandatoryHead15').hide();
        Ext.getCmp('mandatoryref').hide();
        Ext.getCmp('refId').hide();
        Ext.getCmp('RefcomboId').hide();
        Ext.getCmp('mandatoryHead19').show();
        Ext.getCmp('mandatoryorganizationCode').show();
        Ext.getCmp('organizationCodeLabel').show();
        Ext.getCmp('organizationcodeid').show();

        Ext.getCmp('mandatorycountry').show();
        Ext.getCmp('labelcountry').show();
        Ext.getCmp('countryComboId').show();
        Ext.getCmp('mandatoryHead199').show();

        Ext.getCmp('mandatoryHead200').hide();
        Ext.getCmp('mandatorystate').hide();
        Ext.getCmp('labelstate').hide();
        Ext.getCmp('stateComboId').hide();

        Ext.getCmp('mandatoryHeadState').show();
        Ext.getCmp('mandatorystateName').show();
        Ext.getCmp('labelstateName').show();
        Ext.getCmp('stateComboId1').show();

        Ext.getCmp('mandatoryHead001').hide();
        Ext.getCmp('mandatoryoBuyingOrgName').hide();
        Ext.getCmp('BuyingOrgNameLabel').hide();
        Ext.getCmp('buyingOrgComboId').hide();

        Ext.getCmp('mandatoryHead002').hide();
        Ext.getCmp('mandatorybuyingOrgCode').hide();
        Ext.getCmp('buyingOrgCodeid').hide();
        Ext.getCmp('buyingOrgCodeLabel').hide();

        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();

        Ext.getCmp('mandatoryHead0m').show();
        Ext.getCmp('mandatoryMwallet').show();
        Ext.getCmp('mwalletLabelId').show();
        Ext.getCmp('mwalletId').show();

        Ext.getCmp('importtypecomboId').hide();
        Ext.getCmp('importTypeHeader').hide();
        Ext.getCmp('mandatoryImporttype').hide();
        Ext.getCmp('importTypeId').hide();

        Ext.getCmp('importpurposecomboId').hide();
        Ext.getCmp('importPurId').hide();
        Ext.getCmp('mandatoryImportPurpose').hide();
        Ext.getCmp('importPurposeHeader').hide();

        Ext.getCmp('importPermitHeader').hide();
        Ext.getCmp('mandatoryImportPermit').hide();
        Ext.getCmp('importPermitLabelId').hide();
        Ext.getCmp('importedPermitId').hide();

        Ext.getCmp('importVesselHeader').hide();
        Ext.getCmp('mandatoryImportVessel').hide();
        Ext.getCmp('vesselLabelId').hide();
        Ext.getCmp('vesselNameId').hide();

        Ext.getCmp('importExpPermitHeader').hide();
        Ext.getCmp('mandatoryExpPermitNo').hide();
        Ext.getCmp('expPermitLabel').hide();
        Ext.getCmp('exportPermitNoId').hide();

        Ext.getCmp('exportPermitDateHeader').hide();
        Ext.getCmp('mandatoryExpPermitDate').hide();
        Ext.getCmp('expPermitDtLabel').hide();
        Ext.getCmp('exportPermitDateId').hide();

        Ext.getCmp('importExpChallanHeader').hide();
        Ext.getCmp('mandatoryExpChallanNo').hide();
        Ext.getCmp('expChallanLabel').hide();
        Ext.getCmp('exportChallanNoId').hide();

        Ext.getCmp('exportchallanDateHeader').hide();
        Ext.getCmp('mandatoryExpchallanDate').hide();
        Ext.getCmp('expChallanDtLabel').hide();
        Ext.getCmp('exportChallanDateId').hide();

        Ext.getCmp('saleInvoiceNoHeader').hide();
        Ext.getCmp('mandatorySaleInvoiceNo').hide();
        Ext.getCmp('saleInvoiceLabel').hide();
        Ext.getCmp('saleInvoiceNoId').hide();

        Ext.getCmp('saleInvoiceDateHeader').hide();
        Ext.getCmp('mandatorysaleInvoiceDate').hide();
        Ext.getCmp('saleInvoiceDtLabel').hide();
        Ext.getCmp('saleInvoiceDateId').hide();

        Ext.getCmp('transportnTypeHeader').hide();
        Ext.getCmp('mandatorytransportnType').hide();
        Ext.getCmp('transportnTypeLabelId').hide();
        Ext.getCmp('transportnTypecomboId').hide();

        Ext.getCmp('mandatoryrspermitId').show();
        Ext.getCmp('rspermitLabelId').show();
        Ext.getCmp('mandatoryHead1e').show();
        Ext.getCmp('romPermitId').show();

        Ext.getCmp('toLocationId').show();
        Ext.getCmp('mandatoryrstoLocId').show();
        Ext.getCmp('toLoclabelId').show();
        Ext.getCmp('mandatoryHead1to').show();
        
        Ext.getCmp('desttypeId').hide();
        Ext.getCmp('mandatorydesttype').hide();
        Ext.getCmp('destLabelId1').hide();
        Ext.getCmp('mandatoryHead1d6').hide();

        Ext.getCmp('romPermitId').setValue(selected.get('existingPermitIndex'));
        Ext.getCmp('toLocationId').setValue(selected.get('toLocIndex'));
        Ext.getCmp('organizationcodeid').setValue(selected.get('organizationCodeDataIndex'));

        Ext.getCmp('romPermitId').setReadOnly(true);
        Ext.getCmp('toLocationId').setReadOnly(true);
        countryComboStore.load();
        stateComboStore1.load({
            params: {
                countryid: selected.get('countryIdDataIndex')
            }
        });
    }
    if (status == 'OPEN' || status == 'APPROVED') {
        myWin.show();
        Ext.getCmp('permitreqtypecomboId').setReadOnly(true);
        Ext.getCmp('permittypecomboId').setReadOnly(true);
        Ext.getCmp('TccomboId').setReadOnly(true);
        Ext.getCmp('mineralcomboId').setReadOnly(true);
        Ext.getCmp('RefcomboId').setReadOnly(true);
        Ext.getCmp('routeidcomboId').setReadOnly(true);
        Ext.getCmp('organizationcodeid').setReadOnly(true);
        Ext.getCmp('BuChallancomboId').setReadOnly(true);
        Ext.getCmp('importtypecomboId').setReadOnly(true);
        Ext.getCmp('importedPermitId').setReadOnly(true);
        Ext.getCmp('buyingOrgComboId').setReadOnly(true);

        Ext.getCmp('applicationid').setValue(selected.get('applicationNoDataIndex'));
        Ext.getCmp('dateid').setValue(selected.get('dateIndex'));
        Ext.getCmp('finyearId').setValue(selected.get('financialYearIndex'));
        Ext.getCmp('permitreqtypecomboId').setValue(selected.get('permitRequestTypeIndex'));
        Ext.getCmp('ownertypecomboId').setValue(selected.get('ownerTypeIndex'));
        Ext.getCmp('permittypecomboId').setValue(selected.get('permitTypeIndex'));
        Ext.getCmp('TccomboId').setValue(selected.get('tcNoIndex'));
        Ext.getCmp('minecodeId').setValue(selected.get('mineCodeDataIndex'));
        Ext.getCmp('leaseNameid').setValue(selected.get('leaseNameDataIndex'));
        Ext.getCmp('leaseOwnerid').setValue(selected.get('leaseOwnerDataIndex'));
        Ext.getCmp('organizationid').setValue(selected.get('organizationNameDataIndex'));
        Ext.getCmp('mineralcomboId').setValue(selected.get('mineralDataIndex'));
        Ext.getCmp('routeidcomboId').setValue(selected.get('routeIdDataIndex'));
        Ext.getCmp('fromlocId').setValue(selected.get('fromLocationDataIndex'));
        Ext.getCmp('tolocId').setValue(selected.get('toLocationDataIndex'));
        Ext.getCmp('RefcomboId').setValue(selected.get('refDataIndex'));
        Ext.getCmp('startdateid').setValue(selected.get('startdateDataIndex'));
        Ext.getCmp('enddateid').setValue(selected.get('enddateDataIndex'));
        Ext.getCmp('remarksid').setValue(selected.get('remarksDataIndex'));
        Ext.getCmp('buyingOrgComboId').setValue(selected.get('buyingOrgNameDataIndex'));
        Ext.getCmp('buyingOrgCodeid').setValue(selected.get('buyingOrgCodeDataIndex'));
        Ext.getCmp('countryComboId').setValue(selected.get('countryNameDataIndex'));
        Ext.getCmp('stateComboId1').setValue(selected.get('stateNameDataIndex'));
    } else {
        Ext.MessageBox.show({
            title: '',
            msg: 'Status Either Submitted Or Closed',
            buttons: Ext.MessageBox.OK,
        });
    }
}