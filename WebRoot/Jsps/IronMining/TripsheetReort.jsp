<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		     
			 ArrayList<String> tobeConverted = new ArrayList<String>();
			 tobeConverted.add("SLNO");
			 tobeConverted.add("Trip_Sheet_Report");
			 tobeConverted.add("Select_Customer");
			 tobeConverted.add("Select_Asset_Group");
			 tobeConverted.add("Select_Asset_type");
			 tobeConverted.add("Select_Asset_Criteria");
			 tobeConverted.add("Asset_Number");
			 tobeConverted.add("Customer_Name");
			 tobeConverted.add("Asset_Group");
			 tobeConverted.add("Asset_Type");
			 tobeConverted.add("Start_Date");
			 tobeConverted.add("End_Date");
			 tobeConverted.add("Generate_Report");
			 tobeConverted.add("Select_Vehicle_Type");
			 tobeConverted.add("Select_Start_Date");
			 tobeConverted.add("Select_End_Date");
			 tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
			 tobeConverted.add("Month_Validation");
			 tobeConverted.add("Please_Select_Asset_Number");
			 tobeConverted.add("Trip_Sheet_No");
			 tobeConverted.add("Trip_Issued_Date_And_Time");
			 tobeConverted.add("Trip_Close_Date_And_Time");
			 tobeConverted.add("Trip_Sheet_Status");
			 tobeConverted.add("TC_No");
			 tobeConverted.add("Driver_Name");
			 tobeConverted.add("Start_Location");
			 tobeConverted.add("Quantity_At_Source(Ton)");
			 tobeConverted.add("Quantity_At_Destination(Ton)");
			 tobeConverted.add("Route_Id");
			 tobeConverted.add("Destination");
			 tobeConverted.add("Mining_Type");
			 tobeConverted.add("Communication_Status");
			 tobeConverted.add("Remarks");
			 tobeConverted.add("No_Records_Found");
			 tobeConverted.add("Clear_Filter_Data");
			 tobeConverted.add("Excel");
			 tobeConverted.add("Asset_Group");
			 
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

		    String SLNO = convertedWords.get(0);
		    String tripSheetReport =  convertedWords.get(1);
		    String SelectCustomer = convertedWords.get(2);
		    String SelectAssetGroup = convertedWords.get(3);
		    String SelectAssettype =  convertedWords.get(4);
		    String SelectAssetCriteria =  convertedWords.get(5);
		    String AssetNumber = convertedWords.get(6);
		    String CustomerName=convertedWords.get(7);
		    String AssetGroup = convertedWords.get(8);
		    String AssetType = convertedWords.get(9);
		    String StartDate = convertedWords.get(10);
			String EndDate = convertedWords.get(11);
			String GenerateReport = convertedWords.get(12);
			String SelectVehicleType=  convertedWords.get(13);
			String SelectStartDate = convertedWords.get(14);
			String SelectEndDate = convertedWords.get(15);
			String EndDateMustBeGreaterthanStartDate = convertedWords.get(16);
			String monthValidation=convertedWords.get(17);
			String PleaseSelectAssetNumber=convertedWords.get(18);
			String tripSheetNo = convertedWords.get(19);
			String tripIssuedDateAndTime = convertedWords.get(20);
			String tripCloseDateAndTime = convertedWords.get(21);
			String tripSheetStatus= convertedWords.get(22);
			String tCNo= convertedWords.get(23);
			String driverName= convertedWords.get(24);
			String startLocation= convertedWords.get(25);
			String quantityAtSource= convertedWords.get(26);
			String quantityAtDestination= convertedWords.get(27);
			String routeId= convertedWords.get(28);
			String destination= convertedWords.get(29);
			String miningType= convertedWords.get(30);
			String CommunicationStatus= convertedWords.get(31);
			String remarks= convertedWords.get(32);
			String NoRecordsfound= convertedWords.get(33);
			String ClearFilterData = convertedWords.get(34);
		    String Excel=convertedWords.get(35);
		    String groupName=convertedWords.get(36);
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Trip Sheet Report</title>
				<style>
				.labelstyle {
					spacing: 10px;
					height: 20px;
					width: 150 px !important;
					min-width: 150px !important;
					margin-bottom: 5px !important;
					margin-left: 5px !important;
					font-size: 12px;
					font-family: sans-serif;
				}
				.selectstylePerfect {
					height: 20px;
					width: 140px !important;
					listwidth: 120px !important;
					max-listwidth: 120px !important;
					min-listwidth: 120px !important;
					margin: 0px 0px 5px 5px !important;
				}
				.x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
				.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;
				}
	</style>
  </head>
  <body>
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "TripSheetReport";
    var exportDataType = "int,string,date,date,string,string,string,string,string,string,string,number,number,int,string,string,string,string";
    var dtprev = dateprev;
    var dtcur = datecur;
    var json = "";
    var startDate = "";
    var endDate = "";
    var tripGrid;

    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    groupStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>',
        resizable: true,
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
                fn: function() {
                    globalAssetNumber = "";
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    groupStore.load({
                        params: {
                            CustId: custId
                        }
                    });

                    Ext.getCmp('assetNocomboId').reset();
                    Ext.getCmp('groupNameComboId').reset();
                    tripGrid.show();
                    vehiclePanel.hide();
                    store.load();

                    if ( <%= customerId %> > 0) {
                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                        custId = Ext.getCmp('custcomboId').getValue();
                        custName = Ext.getCmp('custcomboId').getRawValue();
                        groupStore.load({
                            params: {
                                CustId: custId
                            }
                        });
                        Ext.getCmp('assetNocomboId').reset();
                        Ext.getCmp('groupNameComboId').reset();
                        tripGrid.show();
                        vehiclePanel.hide();
                        store.load();
                    }
                }
            }
        }
    });

    var groupStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/TripSheetReportAction.do?param=getGroups',
        id: 'groupId',
        root: 'groupNameList',
        autoLoad: false,
        remoteSort: true,
        fields: ['groupId', 'groupName']
    });

    var groupNameCombo = new Ext.form.ComboBox({
        fieldLabel: '',
        store: groupStore,
        id: 'groupNameComboId',
        // width: 150,
        emptyText: '<%=SelectAssetGroup%>',
        blankText: '<%=SelectAssetGroup%>',
        // labelWidth: 100,
        resizable: true,
        hidden: false,
        forceSelection: true,
        enableKeyEvents: true,
        mode: 'local',
        triggerAction: 'all',
        displayField: 'groupName',
        valueField: 'groupId',
        loadingText: 'Searching...',
        cls: 'selectstyle',
        minChars: 3,
        listeners: {
            select: {
                fn: function() {
                    CustId = Ext.getCmp('custcomboId').getValue();
                    groupId = Ext.getCmp('groupNameComboId').getValue();
                    Ext.getCmp('assetNocomboId').reset();
                    if (Ext.getCmp('groupNameComboId').getValue() == 0) {
                        Ext.getCmp('assetNocomboId').setValue(0);
                        Ext.getCmp('selectassetlab').disable();
                        Ext.getCmp('assetNocomboId').disable();
                        tripGrid.getColumnModel().setHidden(tripGrid.getColumnModel().findColumnIndex('GroupNameDataIndex'), false);
	                    var cm = tripGrid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,150);
					    }
                    } else {
                        tripGrid.getColumnModel().setHidden(tripGrid.getColumnModel().findColumnIndex('GroupNameDataIndex'), true);
                        Ext.getCmp('selectassetlab').enable();
                        Ext.getCmp('assetNocomboId').enable();
                        tripGrid.setWidth(screen.width - 35);
                         var cm = tripGrid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,150);
					    }
                    }
                    store.load();
                    tripGrid.show();
                    tripGrid.setWidth(screen.width - 35);
                    vehiclePanel.hide();
                    AssetTypeComboStore.load();
                }
            }
        }
    });

    var AssetTypeComboStore = new Ext.data.SimpleStore({
        id: 'assetTypecombostoreId',
        autoLoad: true,
        fields: ['Name', 'Value'],
        data: [
            ['ALL', '0'],
            ['MULTIPLE', '1']
        ]
    });

    var VehicleTypeCombos = new Ext.form.ComboBox({
        store: AssetTypeComboStore,
        id: 'assetNocomboId',
        mode: 'local',
        resizable: true,
        forceSelection: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        //value:0,
        valueField: 'Value',
        emptyText: '<%=SelectAssetCriteria%>',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    // Listener Logic
                    groupId = Ext.getCmp('groupNameComboId').getValue();
                    var vehicleValue = Ext.getCmp('assetNocomboId').getValue();
                    if (Ext.getCmp('assetNocomboId').getValue() == '0') {
                        //alert(vehicleValue);
                         var cm = tripGrid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					      cm.setColumnWidth(j,150);
					    }
                        tripGrid.show();
                        tripGrid.setWidth(screen.width - 45);
                        vehiclePanel.hide();
                        store.load();
                    } else if (Ext.getCmp('assetNocomboId').getValue() == '1') {
                        var cm = tripGrid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,150); 
					    }
                        vehiclePanel.show();
                        tripGrid.show();
                        tripGrid.setWidth(1090);
                        firstGridStore.load({
                            params: {
                                CustId: custId,
                                groupId: groupId
                            }
                        });
                        store.load();
                    }
                }
            }
        }
    });
    //--------------------------------------------------------------------firstgrid--------------------------------//
    var sm1 = new Ext.grid.CheckboxSelectionModel({
        checkOnly: true,
        header: false
    });

    var cols1 = new Ext.grid.ColumnModel([

        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 40
        }), sm1, {
            header: '<b><%=AssetNumber%></b>',
            width: 155,
            sortable: true,
            dataIndex: 'assetnumber'
        }


    ]);

    var reader1 = new Ext.data.JsonReader({
        root: 'managerAssetRoot',
        fields: [{
            name: 'slnoIndex'
        }, , {
            name: 'assetnumber',
            type: 'string'
        }]
    });

    var filters1 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
                type: 'numeric',
                dataIndex: 'slnoIndex'
            }, {
                dataIndex: 'assetnumber',
                type: 'string'
            }

        ]
    });

    var firstGridStore = new Ext.data.Store({
        url: '<%=request.getContextPath()%>/TripSheetReportAction.do?param=getAssetNumber',
        bufferSize: 367,
        reader: reader1,
        autoLoad: false,
        remoteSort: true
    });
    //----------------------------------------------------------------------------------------------------------//
    var firstGrid = getSelectionModelGrid('Asset Details', '<%=NoRecordsfound%>', firstGridStore, 250, 400, cols1, 4, filters1, sm1);

    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 70,
        layoutConfig: {
            columns: 10
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '<%=AssetGroup%>' + ' :',
                cls: 'labelstyle',
                id: 'assetGrouplab'
            },
            groupNameCombo, {
                width: 30
            }, {
                xtype: 'label',
                text: '<%=SelectAssetCriteria%>' + ' :',
                cls: 'labelstyle',
                id: 'selectassetlab'
            },
            VehicleTypeCombos, {
                width: 30
            }, {
                width: 50
            },

            {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                text: '<%=StartDate%>' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=SelectStartDate%>',
                allowBlank: false,
                blankText: '<%=SelectStartDate%>',
                id: 'startdate',
                value: dtprev,
                endDateField: 'enddate'
            }, {
                width: 10
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'enddatelab',
                text: '<%=EndDate%>' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstyle',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=SelectEndDate%>',
                allowBlank: false,
                blankText: '<%=SelectEndDate%>',
                id: 'enddate',
                value: datecur,
                startDateField: 'startdate'
            }, {
                width: 50
            }, {
                width: 50
            }, {
                xtype: 'button',
                text: '<%=GenerateReport%>',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 100,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("<%=SelectCustomer%>");
                                Ext.getCmp('custcomboId').focus();
                                return;
                            }

                            if (Ext.getCmp('groupNameComboId').getValue() == "") {
                                Ext.example.msg("<%=SelectAssetGroup%>");
                   				 Ext.getCmp('groupNameComboId').focus();
                                return;
                            }
                            if (Ext.getCmp('groupNameComboId').getValue() != 0) {
                                if (Ext.getCmp('assetNocomboId').getValue() == "") {
                                    Ext.example.msg("<%=SelectAssetCriteria%>"); 
                                    Ext.getCmp('assetNocomboId').focus();
                                    return;
                                }
                            }

                            if (Ext.getCmp('startdate').getValue() == "") {
                                Ext.example.msg("<%=SelectStartDate%>");
                                Ext.getCmp('startdate').focus();
                                return;
                            }

                            if (Ext.getCmp('enddate').getValue() == "") {
                                Ext.example.msg("<%=SelectEndDate%>");
                                Ext.getCmp('enddate').focus();
                                return;
                            }

                            if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                                Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                                Ext.getCmp('enddate').focus();
                                return;
                            }

                            if (Ext.getCmp('groupNameComboId').getValue() == 0) {
                                var v_from = Ext.getCmp('startdate').value;
                                var v_to = Ext.getCmp('enddate').value;
                                var str = v_from.split("-");
                                var frmDate = new Date(str[1] + "-" + str[0] + "-" + str[2]); //mm/dd/yyyy
                                str = v_to.split("-");
                                var todateDay = str[0];
                                var toDate = new Date(str[1] + "-" + str[0] + "-" + str[2]); //mm/dd/yyyy
                                var one_day = 1000 * 60 * 60 * 24;
                                var days = parseInt((toDate.getTime() - frmDate.getTime()) / one_day);
                                if (days >= 4) {
                                    Ext.example.msg("Difference Between Two Dates Cannot Be Greater Than 3 Days");
                                    return;
                                }
                            }
                            if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                                Ext.example.msg("<%=monthValidation%>");
                                Ext.getCmp('enddate').focus();
                                return;
                            }

                            var startDate = Ext.getCmp('startdate').getValue();
                            var endDate = Ext.getCmp('enddate').getValue();
                            var vehicleValue = Ext.getCmp('assetNocomboId').getValue();
                            var groupIds = Ext.getCmp('groupNameComboId').getValue();

                            var gridData = "";
                            var jsonsecond = "";

                            var records2 = firstGrid.getSelectionModel().getSelections();
                            for (var i = 0; i < records2.length; i++) {
                                var record2 = records2[i];
                                var row = firstGrid.store.findExact('slnoIndex', record2.get('slnoIndex'));
                                var store2 = firstGrid.store.getAt(row);
                                jsonsecond = jsonsecond + Ext.util.JSON.encode(store2.data) + ',';
                            }
                            //alert(jsonsecond);

                            if (Ext.getCmp('assetNocomboId').getValue() == "1") {
                                if (firstGrid.getSelectionModel().getCount() == 0) {
                                    Ext.example.msg("<%=PleaseSelectAssetNumber%>");
                                    return;
                                }
                            }

                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: Ext.getCmp('custcomboId').getRawValue(),
                                    StartDate: startDate,
                                    EndDate: endDate,
                                    gridData: jsonsecond,
                                    jspName: jspName,
                                    vehicleValue: vehicleValue,
                                    groupId: groupIds,
                                    groupName: Ext.getCmp('groupNameComboId').getRawValue()
                                }
                            });

                        }
                    }
                }
            }
        ]
    });
    //---------------------------------------------------Reader-------------------------------------------------------//
    var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
        root: 'TripSheetReportDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNODataIndex',
            type: 'int'
        }, {
            name: 'TripSheetNoDataIndex',
            type: 'string'
        }, {
            name: 'TripIssuedDateAndTimeDataIndex',
            type: 'date'
        }, {
            name: 'TripCloseDateAndTimeDataIndex',
            type: 'date'
        }, {
            name: 'TripSheetStatusDataIndex',
            type: 'string'
        }, {
            name: 'TCNoDataIndex',
            type: 'string'
        }, {
            name: 'AssetNoDataIndex',
            type: 'string'
        }, {
            name: 'AssetTypeDataIndex',
            type: 'string'
        }, {
            name: 'GroupNameDataIndex',
            type: 'string'
        }, {
            name: 'DriverNameDataIndex',
            type: 'string'
        }, {
            name: 'StartLocationDataIndex',
            type: 'string'
        }, {
            name: 'QuantityAtSourceDataIndex',
            type: 'numeric'
        }, {
            name: 'QuantityAtDestinationDataIndex',
            type: 'numeric'
        }, {
            name: 'RouteIdDataIndex',
            type: 'numeric'
        }, {
            name: 'DestinationDataIndex',
            type: 'string'
        }, {
            name: 'MiningTypeDataIndex',
            type: 'string'
        }, {
            name: 'CommunicationStatusIndex',
            type: 'string'
        }, {
            name: 'RemarksDataIndex',
            type: 'string'
        }]
    });

    //-----------------------------------------Reader configs Ends-------------------------------------------//
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TripSheetReportAction.do?param=getTripSheetDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'AssetNoDataIndex',
            direction: 'ASC'
        },
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'SLNODataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TripSheetNoDataIndex',
            type: 'string'
        }, {
            dataIndex: 'TripIssuedDateAndTimeDataIndex',
            type: 'date'
        }, {
            dataIndex: 'TripCloseDateAndTimeDataIndex',
            type: 'date'
        }, {
            dataIndex: 'TripSheetStatusDataIndex',
            type: 'string'
        }, {
            dataIndex: 'TCNoDataIndex',
            type: 'string'
        }, {
            dataIndex: 'AssetNoDataIndex',
            type: 'string'
        }, {
            dataIndex: 'AssetTypeDataIndex',
            type: 'string'
        }, {
            dataIndex: 'GroupNameDataIndex',
            type: 'string'
        }, {
            dataIndex: 'DriverNameDataIndex',
            type: 'string'
        }, {
            dataIndex: 'StartLocationDataIndex',
            type: 'string'
        }, {
            dataIndex: 'QuantityAtSourceDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'QuantityAtDestinationDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'RouteIdDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'DestinationDataIndex',
            type: 'string'
        }, {
            dataIndex: 'MiningTypeDataIndex',
            type: 'string'
        }, {
            dataIndex: 'CommunicationStatusIndex',
            type: 'string'
        }, {
            dataIndex: 'RemarksDataIndex',
            type: 'string'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: '<b>SL NO</b>',
                width: 50
            }), {
                header: '<b><%=SLNO%></b>',
                hidden: true,
                sortable: true,
               // width: 120,
                dataIndex: 'SLNODataIndex'
            }, {
                header: '<b><%=tripSheetNo%></b>',
                //hidden: true,
                sortable: true,
               // width: 150,
                dataIndex: 'TripSheetNoDataIndex'
            }, {
                header: '<b><%=tripIssuedDateAndTime%></b>',
                hidden: false,
                sortable: true,
                //width: 200,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                dataIndex: 'TripIssuedDateAndTimeDataIndex',
                filter: {
                type: 'date'
               }
            }, {
                header: '<b><%=tripCloseDateAndTime%></b>',
                hidden: false,
                sortable: true,
                //width: 200,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                dataIndex: 'TripCloseDateAndTimeDataIndex',
                filter: {
                type: 'date'
               }
            }, {
                header: '<b><%=tripSheetStatus%></b>',
                hidden: false,
                sortable: true,
                //width: 170,
                dataIndex: 'TripSheetStatusDataIndex'
            }, {
                header: '<b><%=tCNo%></b>',
                hidden: false,
                sortable: true,
               // width: 90,
                dataIndex: 'TCNoDataIndex'
            }, {
                header: '<b><%=AssetNumber%></b>',
                hidden: false,
                sortable: true,
               // width: 170,
                dataIndex: 'AssetNoDataIndex'
            }, {
                header: '<b><%=AssetType%></b>',
                hidden: false,
                sortable: true,
                //width: 150,
                dataIndex: 'AssetTypeDataIndex'
            }, {
                header: '<b><%=groupName%></b>',
                hidden: false,
                sortable: true,
                //width: 140,
                dataIndex: 'GroupNameDataIndex',
                hideable: true
            }, {
                header: '<b><%=driverName%></b>',
                hidden: false,
                sortable: true,
                //width: 90,
                dataIndex: 'DriverNameDataIndex'
            }, {
                header: '<b><%=startLocation%></b>',
                hidden: false,
                sortable: true,
               // width: 170,
                dataIndex: 'StartLocationDataIndex'
            }, {
                header: '<b><%=quantityAtSource%></b>',
                hidden: false,
                sortable: true,
                //width: 170,
                dataIndex: 'QuantityAtSourceDataIndex'
            }, {
                header: '<b><%=quantityAtDestination%></b>',
                hidden: false,
                sortable: true,
               // width: 170,
                dataIndex: 'QuantityAtDestinationDataIndex'
            }, {
                header: '<b><%=routeId%></b>',
                hidden: false,
                sortable: true,
                //width: 120,
                dataIndex: 'RouteIdDataIndex'
            }, {
                header: '<b><%=destination%></b>',
                hidden: false,
                sortable: true,
               // width: 170,
                dataIndex: 'DestinationDataIndex'
            }, {
                header: '<b><%=miningType%></b>',
                hidden: false,
                sortable: true,
               // width: 170,
                dataIndex: 'MiningTypeDataIndex'
            }, {
                header: '<b><%=CommunicationStatus%></b>',
                hidden: false,
                sortable: true,
               // width: 120,
                dataIndex: 'CommunicationStatusIndex'
            }, {
                header: '<b><%=remarks%></b>',
                hidden: false,
                sortable: true,
                //width: 120,
                dataIndex: 'RemarksDataIndex'
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };

    //---------------------------------------------------------grid-------------------------------------------//

    tripGrid = getGridforRightIcons('<%=tripSheetReport%>', '<%=NoRecordsfound%>', store, screen.width - 45, 400, 24, filters, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');

    //--------------------------------------------------------------------------------------------------------//

    var vehiclePanel = new Ext.Panel({
        standardSubmit: true,
        width: 250,
        height: 400,
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [
            firstGrid
        ]
    });

    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        //autoScroll: true,
        width: screen.width - 20,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [
            vehiclePanel,
            tripGrid
        ]
    });

    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 360000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: 1360,
            height: 500,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });
        tripGrid.show();
        vehiclePanel.hide();
    });
    
</script>
  </body>
</html>
<%}%>
