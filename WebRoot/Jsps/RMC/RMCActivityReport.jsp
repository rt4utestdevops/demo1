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

	String SelectVehicle;
	lwb = (LanguageWordsBean) langConverted.get("Sel_Reg_No");
	if (language.equals("ar")) {
		SelectVehicle = lwb.getArabicWord();
	} else {
		SelectVehicle = lwb.getEnglishWord();
	}
	lwb = null;

	String RegistrationNo;
	lwb = (LanguageWordsBean) langConverted.get("Registration_No");
	if (language.equals("ar")) {
		RegistrationNo = lwb.getArabicWord();
	} else {
		RegistrationNo = lwb.getEnglishWord();
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

	String DrumActivity;
	lwb = (LanguageWordsBean) langConverted.get("Drum_Activity");
	if (language.equals("ar")) {
		DrumActivity = lwb.getArabicWord();
	} else {
		DrumActivity = lwb.getEnglishWord();
	}

	String Duration;
	lwb = (LanguageWordsBean) langConverted.get("Duration");
	if (language.equals("ar")) {
		Duration = lwb.getArabicWord();
	} else {
		Duration = lwb.getEnglishWord();
	}

	String Speed;
	lwb = (LanguageWordsBean) langConverted.get("Speed");
	if (language.equals("ar")) {
		Speed = lwb.getArabicWord();
	} else {
		Speed = lwb.getEnglishWord();
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
	lwb = (LanguageWordsBean) langConverted.get("Date&Time");
	if (language.equals("ar")) {
		Date = lwb.getArabicWord();
	} else {
		Date = lwb.getEnglishWord();
	}
	lwb = null;
	String Location;
	lwb = (LanguageWordsBean) langConverted.get("Location");
	if (language.equals("ar")) {
		Location = lwb.getArabicWord();
	} else {
		Location = lwb.getEnglishWord();
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

	String RMC_Activity_Report = "RMC Activity Report";
	lwb = (LanguageWordsBean) langConverted.get("RMC_Activity_Report");
	if (language.equals("ar")) {
		RMC_Activity_Report = lwb.getArabicWord();
	} else {
		RMC_Activity_Report = lwb.getEnglishWord();
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
            <%=RMC_Activity_Report%>
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
            var jspName = "RMCActivityReport";
            var exportDataType = "int,string,string,string,string,number";
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
                            vehiclestore.load({
                                params: {
                                    CustId: <%=customeridlogged%> ,
                                    LTSPId: <%=systemID%>
                                }
                            });
                        }
                    }
                }
            });
                //***************************************Vehicle store*************************************
            var vehiclestore = new Ext.data.JsonStore({
				    url: '<%=request.getContextPath()%>/CommonAction.do?param=getVehicleNo',
				    id: 'VehicleStoreId',
				    root: 'VehicleNoRoot',
				    autoLoad: false,
				    remoteSort: true,
				    fields: ['VehicleNo']
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
                            Ext.getCmp('vehiclecomboId').reset();
                             vehiclestore.load({
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
            var vehiclecombo = new Ext.form.ComboBox({
                store: vehiclestore,
                id: 'vehiclecomboId',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=SelectVehicle%>',
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
                        fn: function () {}
                    }
                }
            });

             //***********************************Grid Starts******************************************
             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'RMCActivityReportDetailsRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    }, {
                        name: 'Location'
                    }, {
                        name: 'DrumActivity'
                    }, {
                        name: 'Duration'
                    }, {
                        name: 'Speed'
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
                    url: '<%=request.getContextPath()%>/RMCAction.do?param=getRMCActivityReport',
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
                    vehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
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
                        dataIndex: 'Location'
                    }, {
                        type: 'string',
                        dataIndex: 'DrumActivity'
                    }, {
                        type: 'int',
                        dataIndex: 'Duration'
                    }, {
                        type: 'int',
                        dataIndex: 'Speed'
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
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        width:100,
                        filter: {
                            type: 'date'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Location%></span>",
                        dataIndex: 'Location',
                        width:250,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=DrumActivity%></span>",
                        dataIndex: 'DrumActivity',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Duration%></span>",
                        dataIndex: 'Duration',
                        filter: {
                            type: 'numeric'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Speed%></span>",
                        dataIndex: 'Speed',
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

             //*******************************************Grid Panel Config***************************************

            var grid = getGrid('<%=RMC_Activity_Report%>', '<%=NoRecordsFound%>', store, screen.width-57,350, 7, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');

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
                        text: '<%=RegistrationNo%>' + ' :',
                        cls: 'labelstyle',
                        id: 'vehiclecombolab'
                    },
                    vehiclecombo, {
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
                        format: getDateTimeFormat(),
                        emptyText: '<%=SelectStartDate%>',
                        allowBlank: false,
                        blankText: '<%=SelectStartDate%>',
                        id: 'startdate',
                        value: dtprev,
                        width:150,
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
                        width:150,
                        format: getDateTimeFormat(),
                        emptyText: '<%=SelectEndDate%>',
                        allowBlank: false,
                        blankText: '<%=SelectEndDate%>',
                        id: 'enddate',
                        value: dtcur,
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
                                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                                        Ext.example.msg("<%=SelectVehicle%>");
                                        Ext.getCmp('vehiclecomboId').focus();
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
                                            vehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
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
                    title: '<%=RMC_Activity_Report%>',
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: true,
                    cls: 'outerpanel',
                    layout: 'fit',
                    items: [innerPanel, grid]
                });
            });
        </script>
    </body>

</html>