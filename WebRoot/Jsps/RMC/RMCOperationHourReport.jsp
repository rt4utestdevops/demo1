<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session
			.getAttribute("loginInfoDetails"), session, request,
			response);
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	//getting language
	String language = loginInfo.getLanguage();
	int systemid = loginInfo.getSystemId();
	String systemID = Integer.toString(systemid);
	int customeridlogged = loginInfo.getCustomerId();
	//getting hashmap with language specific words
	HashMap langConverted = ApplicationListener.langConverted;
	LanguageWordsBean lwb = null;

	//Getting words based on language 
	String SelectCustomer;
	lwb = (LanguageWordsBean) langConverted.get("Select_Customer");
	if (language.equals("ar")) {
		SelectCustomer = lwb.getArabicWord();
	} else {
		SelectCustomer = lwb.getEnglishWord();
	}
	lwb = null;
	String CustomerName;
	lwb = (LanguageWordsBean) langConverted.get("Customer_Name");
	if (language.equals("ar")) {
		CustomerName = lwb.getArabicWord();
	} else {
		CustomerName = lwb.getEnglishWord();
	}
	lwb = null;

	String SelectGroup;
	lwb = (LanguageWordsBean) langConverted.get("Select_Group_Name");
	if (language.equals("ar")) {
		SelectGroup = lwb.getArabicWord();
	} else {
		SelectGroup = lwb.getEnglishWord();
	}
	lwb = null;

	String GroupName;
	lwb = (LanguageWordsBean) langConverted.get("Group_Name");
	if (language.equals("ar")) {
		GroupName = lwb.getArabicWord();
	} else {
		GroupName = lwb.getEnglishWord();
	}
	lwb = null;

	String StartDate;
	lwb = (LanguageWordsBean) langConverted.get("Start_Date");
	if (language.equals("ar")) {
		StartDate = lwb.getArabicWord();
	} else {
		StartDate = lwb.getEnglishWord();
	}
	lwb = null;
	String SelectStartDate;
	lwb = (LanguageWordsBean) langConverted.get("Select_Start_Date");
	if (language.equals("ar")) {
		SelectStartDate = lwb.getArabicWord();
	} else {
		SelectStartDate = lwb.getEnglishWord();
	}
	lwb = null;
	String EndDate;
	lwb = (LanguageWordsBean) langConverted.get("End_Date");
	if (language.equals("ar")) {
		EndDate = lwb.getArabicWord();
	} else {
		EndDate = lwb.getEnglishWord();
	}
	lwb = null;
	String SelectEndDate;
	lwb = (LanguageWordsBean) langConverted.get("Select_End_Date");
	if (language.equals("ar")) {
		SelectEndDate = lwb.getArabicWord();
	} else {
		SelectEndDate = lwb.getEnglishWord();
	}
	lwb = null;
	String Submit;
	lwb = (LanguageWordsBean) langConverted.get("Submit");
	if (language.equals("ar")) {
		Submit = lwb.getArabicWord();
	} else {
		Submit = lwb.getEnglishWord();
	}

	String loadinghour;
	lwb = (LanguageWordsBean) langConverted.get("Mixing_Hours");
	if (language.equals("ar")) {
		loadinghour = lwb.getArabicWord();
	} else {
		loadinghour = lwb.getEnglishWord();
	}

	String unloadinghour;
	lwb = (LanguageWordsBean) langConverted.get("Discharging_Hours");
	if (language.equals("ar")) {
		unloadinghour = lwb.getArabicWord();
	} else {
		unloadinghour = lwb.getEnglishWord();
	}

	String emptyhour;
	lwb = (LanguageWordsBean) langConverted.get("Empty_Hours");
	if (language.equals("ar")) {
		emptyhour = lwb.getArabicWord();
	} else {
		emptyhour = lwb.getEnglishWord();
	}

	String loadingpercent;
	lwb = (LanguageWordsBean) langConverted.get("Mixing_Percentage");
	if (language.equals("ar")) {
		loadingpercent = lwb.getArabicWord();
	} else {
		loadingpercent = lwb.getEnglishWord();
	}

	String unloadingpercent;
	lwb = (LanguageWordsBean) langConverted
			.get("Discharging_Percentage");
	if (language.equals("ar")) {
		unloadingpercent = lwb.getArabicWord();
	} else {
		unloadingpercent = lwb.getEnglishWord();
	}

	String emptypercent;
	lwb = (LanguageWordsBean) langConverted.get("Empty_Percentage");
	if (language.equals("ar")) {
		emptypercent = lwb.getArabicWord();
	} else {
		emptypercent = lwb.getEnglishWord();
	}

	lwb = null;
	String SLNO;
	lwb = (LanguageWordsBean) langConverted.get("SLNO");
	if (language.equals("ar")) {
		SLNO = lwb.getArabicWord();
	} else {
		SLNO = lwb.getEnglishWord();
	}
	lwb = null;
	String Date;
	lwb = (LanguageWordsBean) langConverted.get("Date");
	if (language.equals("ar")) {
		Date = lwb.getArabicWord();
	} else {
		Date = lwb.getEnglishWord();
	}
	lwb = null;
	String VehicleNo;
	lwb = (LanguageWordsBean) langConverted.get("Registration_No");
	if (language.equals("ar")) {
		VehicleNo = lwb.getArabicWord();
	} else {
		VehicleNo = lwb.getEnglishWord();
	}
	lwb = null;
	String NoRecordsFound;
	lwb = (LanguageWordsBean) langConverted.get("No_Records_Found");
	if (language.equals("ar")) {
		NoRecordsFound = lwb.getArabicWord();
	} else {
		NoRecordsFound = lwb.getEnglishWord();
	}
	lwb = null;
	String ClearFilterData;
	lwb = (LanguageWordsBean) langConverted.get("Clear_Filter_Data");
	if (language.equals("ar")) {
		ClearFilterData = lwb.getArabicWord();
	} else {
		ClearFilterData = lwb.getEnglishWord();
	}
	lwb = null;
	String ReconfigureGrid;
	lwb = (LanguageWordsBean) langConverted.get("Reconfigure_Grid");
	if (language.equals("ar")) {
		ReconfigureGrid = lwb.getArabicWord();
	} else {
		ReconfigureGrid = lwb.getEnglishWord();
	}
	lwb = null;
	String ClearGrouping;
	lwb = (LanguageWordsBean) langConverted.get("Clear_Grouping");
	if (language.equals("ar")) {
		ClearGrouping = lwb.getArabicWord();
	} else {
		ClearGrouping = lwb.getEnglishWord();
	}
	lwb = null;

	String RMC_Operation_Hour_Report;
	lwb = (LanguageWordsBean) langConverted
			.get("RMC_Operation_Hour_Report");
	if (language.equals("ar")) {
		RMC_Operation_Hour_Report = lwb.getArabicWord();
	} else {
		RMC_Operation_Hour_Report = lwb.getEnglishWord();
	}
	lwb = null;
	String Excel = cf.getLabelFromDB("Excel", language);
	String monthValidation = cf.getLabelFromDB("Month_Validation",
			language);
	langConverted = null;
%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
            <%=RMC_Operation_Hour_Report%>
        </title>
    </head>
    
    <body class="largebody">
		<%
			if (loginInfo.getStyleSheetOverride().equals("Y")) {
		%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%
			} else {
		%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%
			}
		%>
		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 15px !important;
			}
		</style>
        <script>
            var outerPanel;
            var ctsb;
            var dtprev = dateprev;
            var dtcur = datecur;

             //****************************************Export Excel********************************* 
            var jspName = "RMCOperationHourReport";
            var exportDataType = "int,string,string,number,number,number,number,number,number";
             /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				 var width = '100%';
			    var height = '100%';
			grid.setSize(width, height);
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
			});
             //****************************************Customer Name Store**************************
            var customercombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                id: 'CustomerStoreId',
                root: 'CustomerRoot',
                autoLoad: true,
                remoteSort: true,
                fields: ['CustId', 'CustName'],
                listeners: {
                    load: function (custstore, records, success, options) {
                        if ( <%=customeridlogged%> > 0) {
                            Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                            groupstore.load({
                                params: {
                                    CustId: <%=customeridlogged%> ,
                                    LTSPId: <%=systemID%>
                                }
                            });
                        }
                    }
                }
            });
             //***************************************Group store*************************************
     		var groupstore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroupExceptAll',
			id:'GroupNameStoreId',
			root: 'assetGroupRoot',
			autoLoad: false,
			remoteSort: true,
			fields: ['groupId','groupName']
	});
             //**************************************Customer Combo*************************************
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
                            Ext.getCmp('groupcomboid').reset();
                            groupstore.load({
                                params: {
                                    CustId: custId,
                                    LTSPId: <%=systemID%>
                                }
                            });
                        }
                    }
                }
            });
             //****************************************Combo for Vehicle******************************************	
            var groupcombo = new Ext.form.ComboBox({
                store: groupstore,
                id: 'groupcomboid',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=SelectGroup%>',
                selectOnFocus: true,
                allowBlank: false,
                anyMatch: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'groupId',
                displayField: 'groupName',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });

             //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'RMCReportDetailsRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    }, {
                        name: 'VehicleNo'
                    }, {
                        name: 'loadinghour'
                    }, {
                        name: 'loadingpercent'
                    }, {
                        name: 'unloadinghour'
                    }, {
                        name: 'unloadingpercent'
                    }, {
                        name: 'emptyhour'
                    }, {
                        name: 'emptypercent'
                    }, {
                        name: 'Date',
                        type: 'date',
                        dateFormat: getDateTimeFormat()
                    }
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/RMCAction.do?param=getDailyRMCReport',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'Date',
                    direction: 'ASC'
                },
                storeId: 'darStore',
                reader: reader
            });
            store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    groupid: Ext.getCmp('groupcomboid').getValue(),
                    startdate: Ext.getCmp('startdate').getValue(),
                    enddate: Ext.getCmp('enddate').getValue(),
                    jspName: jspName
                };
            }, this);
             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'VehicleNo'
                    }, {
                        type: 'string',
                        dataIndex: 'loadinghour'
                    }, {
                        type: 'string',
                        dataIndex: 'loadingpercent'
                    }, {
                        type: 'string',
                        dataIndex: 'unloadinghour'
                    }, {
                        type: 'string',
                        dataIndex: 'unloadingpercent'
                    }, {
                        type: 'string',
                        dataIndex: 'emptyhour'
                    }, {
                        type: 'string',
                        dataIndex: 'emptypercent'
                    }, {
                        type: 'date',
                        dataIndex: 'Date'
                    }
                ]
            });

             //************************************Column Model Config******************************************
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
                        dataIndex: 'Date',
                        header: "<span style=font-weight:bold;><%=Date%></span>",
                        renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                        filter: {
                            type: 'date'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                        dataIndex: 'VehicleNo',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=loadinghour%></span>",
                        dataIndex: 'loadinghour',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=loadingpercent%></span>",
                        dataIndex: 'loadingpercent',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=unloadinghour%></span>",
                        dataIndex: 'unloadinghour',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=unloadingpercent%></span>",
                        dataIndex: 'unloadingpercent',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=emptyhour%></span>",
                        dataIndex: 'emptyhour',
                        filter: {
                            type: 'string'
                        }
                    },   {
                        header: "<span style=font-weight:bold;><%=emptypercent%></span>",
                        dataIndex: 'emptypercent',
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

             //*******************************************Grid Panel Config***************************************

            var grid = getGrid('<%=RMC_Operation_Hour_Report%>', '<%=NoRecordsFound%>', store, screen.width-57,350, 10, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');

             //********************************************Grid Panel Config Ends*********************************

             //********************************************Inner Pannel Starts******************************************* 
            var innerPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'innerpanelgridpercentage',
                id: 'traderMaster',
                layout: 'table',
                layoutConfig: {
                    columns: 7
                },
                items: [{
                        xtype: 'label',
                        text: '<%=CustomerName%>' + ' :',
                        cls: 'labelstyle',
                        id: 'custnamelab'
                    },
                    custnamecombo, {
                        width: 20,
                        height: 10
                    }, {
                        xtype: 'label',
                        text: '<%=GroupName%>' + ' :',
                        cls: 'labelstyle',
                        id: 'vehiclecombolab'
                    },
                    groupcombo, {
                        width: 20,
                        height: 10
                    }, {
                        width: 20,
                        height: 10
                    }, {
                        xtype: 'label',
                        cls: 'labelstyle',
                        id: 'startdatelab',
                        text: '<%=StartDate%>' + ' :'
                    }, {
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        emptyText: '<%=SelectStartDate%>',
                        allowBlank: false,
                        blankText: '<%=SelectStartDate%>',
                        id: 'startdate',
                        value: dtprev,
                        maxValue: dtprev,
                        vtype: 'daterange',
                        endDateField: 'enddate'
                    }, {
                        width: 20,
                        height: 10
                    }, {
                        xtype: 'label',
                        cls: 'labelstyle',
                        id: 'enddatelab',
                        text: '<%=EndDate%>' + ' :'
                    }, {
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        emptyText: '<%=SelectEndDate%>',
                        allowBlank: false,
                        blankText: '<%=SelectEndDate%>',
                        id: 'enddate',
                        value: dtcur,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        startDateField: 'startdate'
                    }, {
                        width: 20,
                        height: 10
                    }, {
                        xtype: 'button',
                        text: '<%=Submit%>',
                        id: 'addbuttonid',
                        cls: ' ',
                        width: 80,
                        listeners: {
                            click: {
                                fn: function () {
                                    //Action for Button
                                    if (Ext.getCmp('custcomboId').getValue() == "") {
                                        Ext.example.msg("<%=SelectCustomer%>");
                                        Ext.getCmp('custcomboId').focus();
                                        return;
                                    }
                                    if (Ext.getCmp('groupcomboid').getValue() == "") {
                                        Ext.example.msg("<%=SelectGroup%>");
                                        Ext.getCmp('groupcomboid').focus();
                                        return;
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
                                    var startdates=Ext.getCmp('startdate').getValue();
            		 				var enddates=Ext.getCmp('enddate').getValue();
									if(checkMonthValidation(startdates,enddates))
            		 				{
            		 				    Ext.example.msg("<%=monthValidation%>");
               		   	 				Ext.getCmp('enddate').focus(); 
               		    				return;
            		 				}
                                    store.load({
                                        params: {
                                            vehicleNo: Ext.getCmp('groupcomboid').getValue(),
                                            startdate: Ext.getCmp('startdate').getValue(),
                                            enddate: Ext.getCmp('enddate').getValue(),
                                            jspName: jspName
                                        }
                                    });
                                }
                            }
                        }
                    }
                ]
            }); // End of Panel	

             //***************************************Main starts from here*************************
            Ext.onReady(function () {
                ctsb = tsb;
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    title: '<%=RMC_Operation_Hour_Report%>',
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: true,
                    layout: 'fit',
                    cls: 'outerpanel',
                    items: [innerPanel, grid]
                });
            });
        </script>
    </body>

</html>