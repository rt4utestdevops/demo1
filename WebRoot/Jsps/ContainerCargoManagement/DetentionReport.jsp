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
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>Detention Report</title>
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
				.x-toolbar-right {
				align: right;
    			width: 100%;
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

	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		
	<%} %>
	<jsp:include page="../Common/ExportJS.jsp" />
	<style>
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-layer ul {
		 	min-height:27px !important;
		}
		.footer {
			bottom : -5px !important;
		}
	</style>
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "DetentionReport";
    var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,number";
    var json = "";
    var startDate = "";
    var endDate = "";

	var loadingBranchStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/DetentionReportAction.do?param=getBranch',
        id: 'loadingBranchStoreId',
        root: 'loadingBranchNameList',
        autoLoad: true,
        remoteSort: true,
        fields: ['BranchId', 'BranchName']
    });
	var loadingBranchCombo = new Ext.form.ComboBox({
	    value: '',
	    width: 175,
	    store: loadingBranchStore,
	    displayField: 'BranchName',
	    valueField: 'BranchId',
	    mode: 'local',
	    forceSelection: true,
	    triggerAction: 'all',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    selectOnFocus: true,
	    emptyText: 'Select Branch',
	    labelSeparator: '',
	    id: 'loadingBranchId',
	    name: 'loadingBranchName',
	    loadingText: 'Searching...',
	    enableKeyEvents: true,
	    cls: 'selectstylePerfect',
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            store.load({params: {branchId: ''}});
	            }
	        }
	    }
    });

	var vehicleStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/DetentionReportAction.do?param=getVehicles',
        id: 'vehicleStoreId',
        root: 'vehiclesList',
        autoLoad: true,
        remoteSort: true,
        fields: ['VehicleNo']
    });
	var vehicleCombo = new Ext.form.ComboBox({
	    value: '',
	    store: vehicleStore,
	    displayField: 'VehicleNo',
	    valueField: 'VehicleNo',
	    mode: 'local',
	    forceSelection: true,
	    triggerAction: 'all',
	    resizable: true,
	    anyMatch: true,
	    onTypeAhead: true,
	    selectOnFocus: true,
	    emptyText: 'Select Vehicle',
	    labelSeparator: '',
	    id: 'vehicleId',
	    name: 'vehicleName',
	    loadingText: 'Searching...',
	    enableKeyEvents: true,
		cls: 'selectstylePerfect',
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	             store.load({params: {branchId: ''}});
	            }
	        }
	    }
    });

	var clientPanel = new Ext.Panel({
    	standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
        width: 1330,
        height: 50,
        layoutConfig: {
            columns: 13
        },
        items: [{
                xtype: 'label',
                text: 'Loading Branch' + ' :',
                cls: 'labelstyle',
                id: 'branchlab'
            },loadingBranchCombo, {width: 30}, {
                xtype: 'label',
                text: 'Vehicle No' + ' :',
                cls: 'labelstyle',
                id: 'vehnolab'
            },vehicleCombo, {width: 30},{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                text: 'Start Date' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateTimeFormat(),
                emptyText: 'Select Start Date',
                allowBlank: false,
                blankText: 'Select Start Date',
                id: 'startdate',
                endDateField: 'enddate',
                menuListeners:{
                select:  function(m,d){
                this.setValue(d);
                	store.load({params: {branchId: ''}});
                }
                }
            }, {width: 30}, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'enddatelab',
                text: 'End Date' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateTimeFormat(),
                emptyText: 'Select End Date',
                allowBlank: false,
                blankText: 'Select End Date',
                id: 'enddate',
                startDateField: 'startdate',
                menuListeners:{
                select:  function(m,d){
                this.setValue(d);
                	store.load({params: {branchId: ''}});
                }
                }
            }, {width: 50},{
                xtype: 'button',
                text: 'View Report',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 100,
                listeners: {
                click: {
                fn: function() {
                	if(Ext.getCmp('loadingBranchId').getValue() == ""){
                    	Ext.example.msg("Please select Loading Branch");
                        Ext.getCmp('loadingBranchId').focus();
                        return;
                    }
                   	if(Ext.getCmp('vehicleId').getValue() == ""){
                   		Ext.example.msg("Please select Vehicle No");
                   		Ext.getCmp('vehicleId').focus();
                   		return;
                   	}
                    if (Ext.getCmp('startdate').getValue() == "") {
                        Ext.example.msg("Please select Start Date");
                        Ext.getCmp('startdate').focus();
                        return;
                    }
                    if (Ext.getCmp('enddate').getValue() == "") {
                        Ext.example.msg("Please select End Date");
                        Ext.getCmp('enddate').focus();
                        return;
                    }
                    if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                        Ext.example.msg("End Date Must Be Greater than Start Date");
                        Ext.getCmp('enddate').focus();
                        return;
                    }
                    if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                        Ext.example.msg("Difference between two dates cannot be more than 1 month");
                        Ext.getCmp('enddate').focus();
                        return;
                    }
					store.load({
						params: {
							branchId: Ext.getCmp('loadingBranchId').getValue(),
							vehicleNo: Ext.getCmp('vehicleId').getValue(),
							startDate: Ext.getCmp('startdate').getValue(),
                            endDate: Ext.getCmp('enddate').getValue(),
                            branchName: Ext.getCmp('loadingBranchId').getRawValue(),
                            jspName: jspName
                              }
                          });

                        }
                    }
                }
            }
        ]
    });

    var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
        root: 'DetentionReportDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNODataIndex',
            type: 'int'
        }, {
            name: 'LoadingBranchIndex',
            type: 'string'
        }, {
            name: 'VehicleNoIndex',
            type: 'string'
        }, {
            name: 'DriverNameIndex',
            type: 'string'
        }, {
            name: 'DriverNoIndex',
            type: 'string'
        }, {
            name: 'TripNoIndex',
            type: 'string'
        }, {
            name: 'PrincipalNameIndex',
            type: 'string'
        }, {
            name: 'ConsigneeNameIndex',
            type: 'string'
        }, {
            name: 'ConsigneeArrivalTimeIndex',
            type: 'date',
            dateFormat: getDateTimeFormat()
        }, {
            name: 'ConsigneeDepartureTimeIndex',
            type: 'date',
            dateFormat: getDateTimeFormat()
        }, {
            name: 'DetentionDurationIndex',
            type: 'string'
        }, {
            name: 'DetentionChargeIndex',
            type: 'float'
       }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/DetentionReportAction.do?param=getDetentionDetails',
            method: 'POST'
        }),
        remoteSort: false,
        bufferSize: 700,
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'SLNODataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'LoadingBranchIndex',
            type: 'string'
        }, {
            dataIndex: 'VehicleNoIndex',
            type: 'string'
        }, {
            dataIndex: 'DriverNameIndex',
            type: 'string'
        }, {
            dataIndex: 'DriverNoIndex',
            type: 'string'
        }, {
            dataIndex: 'TripNoIndex',
            type: 'string'
        }, {
            dataIndex: 'PrincipalNameIndex',
            type: 'string'
        }, {
            dataIndex: 'ConsigneeNameIndex',
            type: 'string'
        }, {
            dataIndex: 'ConsigneeArrivalTimeIndex',
            type: 'date'
        }, {
            dataIndex: 'ConsigneeDepartureTimeIndex',
            type: 'date'
        }, {
            dataIndex: 'DetentionDurationIndex',
            type: 'string'
        },{
            dataIndex: 'DetentionChargeIndex',
            type: 'numeric'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: '<b>SL NO</b>',
                width: 50
            }), {
                header: '<b>SLNO</b>',
                hidden: true,
                sortable: true,
                width: 80,
                dataIndex: 'SLNODataIndex'
            }, {
                header: '<b>Loading Branch</b>',
                sortable: true,
                dataIndex: 'LoadingBranchIndex',
                width:250
            }, {
                header: '<b>Vehicle No</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'VehicleNoIndex',
                width:200
            }, {
                header: '<b>Driver Name</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'DriverNameIndex',
                width:200
            }, {
                header: '<b>Driver No</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'DriverNoIndex',
                width:200
            }, {
                header: '<b>Trip No</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'TripNoIndex',
                width:200
            }, {
                header: '<b>Principal Name</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'PrincipalNameIndex',
                width:200
            }, {
                header: '<b>Consignee Name</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'ConsigneeNameIndex',
                width:250
            }, {
                header: '<b>Consignee Arrival Time</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'ConsigneeArrivalTimeIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                width:300
            }, {
                header: '<b>Consignee Departure Time</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'ConsigneeDepartureTimeIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                width:300
            }, {
                header: '<b>Detention Duration(HH:MM)</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'DetentionDurationIndex',
                width:300
            }, {
                header: '<b>Detention Charge</b>',
                hidden: false,
                sortable: true,
                dataIndex: 'DetentionChargeIndex',
                width:250
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
	var tripGrid = getGrid('Detention Charges Details', 'No Records found', store, 1330, 450, 14, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');

    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 360000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: 'Detention Charges Report',
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: true,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: 1350,
            height: 580,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, tripGrid]
        });
    });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
