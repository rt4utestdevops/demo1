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
		
	tobeConverted.add("Vessel_History_Analysis");
	tobeConverted.add("SLNO");
	tobeConverted.add("Group_Name");
	tobeConverted.add("Speed_Nauticle");
	tobeConverted.add("Latitude");
	tobeConverted.add("Longitude");
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Driver_Number");
	tobeConverted.add("Owner_Name");
	tobeConverted.add("Owner_Number");
	tobeConverted.add("Last_Communicated_Date_Time");
	tobeConverted.add("Start_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("DateTime");
	tobeConverted.add("View_By_Location");
	tobeConverted.add("View");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Week_Validation");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String MarineHistoryInformation = convertedWords.get(0);	
	
	String SlNo = convertedWords.get(1);
	String GroupName = convertedWords.get(2);
	String Speed = convertedWords.get(3);
	String Latitude = convertedWords.get(4);
	String Longitude = convertedWords.get(5);
	String DriverName = convertedWords.get(6);
	String DriverNumber = convertedWords.get(7);
	String OwnerName = convertedWords.get(8);	
	String OwnerNumber = convertedWords.get(9);
	String LastCommunicatedTime = convertedWords.get(10);
	
	String StartDate = convertedWords.get(11);
	String SelectStartDate = convertedWords.get(12);
	String EndDate = convertedWords.get(13);
	String SelectEndDate = convertedWords.get(14);
	String DateTime = convertedWords.get(15);
	String ViewByLocation =  convertedWords.get(16);
	
	String View = convertedWords.get(17);
	
	String Excel = convertedWords.get(18);
	String PDF = convertedWords.get(19);
	String NoRecordsFound = convertedWords.get(20);
	String ClearFilterData = convertedWords.get(21);
	String SelectSingleRow = convertedWords.get(22); 
	
	String SelectCustomer = convertedWords.get(23);
	String WeekValidation = convertedWords.get(24);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>Marine Vessel History</title>		
	</head>	     
  	<body>
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
   	<!-- for exporting to excel***** -->
    <jsp:include page="../Common/ExportJS.jsp" />
        
	<script type="text/javascript">
	Ext.override(Ext.form.Label, {
		getText : function(){
			return this.text || Ext.util.Format.htmlDecode(this.html);
		}
	});
	
	var marineLivePanel;
	var marineHistoryGrid;
	var dtprev;
	var dtcur;
	var assetNumber = parent.globalAssetNumber;
	var customerId = parent.custId;
	var jspName = "MarineVesselHistoryReport";
	var exportDataType = "int,date,int,float,float,string";

	var marineHistoryInformationStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/MarineVessel.do?param=getMarineLiveInformation',
	    id: 'MarineHistoryInformationId',
	    root: 'MarineLiveInformationRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['GroupName', 'LastCommunicatedTime', 'Latitude', 'Longitude', 'DriverName', 'DriverNumber', 'OwnerName', 'OwnerNumber'],
	});

	marineHistoryInformationStore.on('beforeload', function (store, operation, eOpts) {
	    operation.params = {
	        CustId: customerId,
	        AssetNumber: assetNumber
	    };
	});

	marineHistoryInformationStore.on('load', function (store, operation, eOpts) {
	    var storeData = marineHistoryInformationStore.getAt(0);

	    Ext.getCmp('HistoryGroupNameId').setText(storeData.data['GroupName']);
	    Ext.getCmp('HistoryLastCommunicatedTimeId').setText(storeData.data['LastCommunicatedTime']);
	    Ext.getCmp('HistoryLatitudeId').setText(storeData.data['Latitude']);
	    Ext.getCmp('HistoryLongitudeId').setText(storeData.data['Longitude']);
	    Ext.getCmp('HistoryDriverNameId').setText(storeData.data['DriverName']);
	    Ext.getCmp('HistoryDriverNumberId').setText(storeData.data['DriverNumber']);
	    Ext.getCmp('HistoryOwnerNameId').setText(storeData.data['OwnerName']);
	    Ext.getCmp('HistoryOwnerNumberId').setText(storeData.data['OwnerNumber']);

	}, this);

	var infoPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    frame: false,
	    width: screen.width-374,
	    id: 'marineHistoryInfoPanelId',
	    layout: 'table',
	    layoutConfig: {
	        columns: 1
	    },
	    items: [{
	        xtype: 'fieldset',
	        title: '<%=MarineHistoryInformation%>',
	        collapsible: false,
	        colspan: 3,
	        width: screen.width-379,
	        id: 'marineHistoryItemId',
	        layout: 'table',
	        layoutConfig: {
	            columns: 5,
	            tableAttrs: {
	                style: {
	                    width: '90%'
	                }
	            }
	        },
	        items: [{
	            xtype: 'label',
	            text: '<%=GroupName%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryGroupNameLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryGroupNameId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=LastCommunicatedTime%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryLastCommunicatedTimeLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryLastCommunicatedTimeId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            xtype: 'label',
	            text: '<%=Latitude%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryLatitudeLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryLatitudeId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=Longitude%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryLongitudeLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryLongitudeId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            xtype: 'label',
	            text: '<%=DriverName%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryDriverNameLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryDriverNameId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=DriverNumber%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryDriverNumberLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryDriverNumberId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            xtype: 'label',
	            text: '<%=OwnerName%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryOwnerNameLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryOwnerNameId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=OwnerNumber%>  :',
	            cls: 'labelstyle',
	            id: 'HistoryOwnerNumberLabelId'
	        }, {
	            xtype: 'label',
	            id: 'HistoryOwnerNumberId',
	            cls: 'labelBoldFontPerfect'
	        }]
	    }]
	});

	function onCellClickOnGrid(marineHistoryGrid, rowIndex, columnIndex, e) {
	    if (marineHistoryGrid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("<%=SelectSingleRow%>");
	        return;
	    }
	    if (marineHistoryGrid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("<%=SelectSingleRow%>");
	        return;
	    }

	    if (columnIndex == 6 && marineHistoryGrid.getSelectionModel().getCount() == 1) {
	        var selected = marineHistoryGrid.getSelectionModel().getSelected();
	        var dateTime = selected.get('dateTime');
	        var latitude = selected.get('latitude');
	        var longitude = selected.get('longitude');
	        var flag = true;

	        var findByLocationStore = new Ext.data.JsonStore({
	            url: '<%=request.getContextPath()%>/MarineVessel.do?param=postFindByLocation',
	            id: 'findByLocationId',
	            root: 'FindByLocationRoot',
	            autoLoad: false,
	            remoteSort: true
	        });

	        findByLocationStore.load({
	            params: {
	                FindByCustomerId: customerId,
	                FindByLatitude: latitude,
	                FindByLongitude: longitude,
	                FindByDateTime: dateTime
	            }
	        });
	        parent.parent.callByLocation = 'Yes';
	        parent.parent.Ext.getCmp('MarineByLocationId').enable();
	        parent.parent.Ext.getCmp('MarineByLocationId').show();
	        parent.parent.Ext.getCmp('MarineByLocationId').update("<iframe style='width:100%;height:520px;border:0;' src='<%=path%>/Jsps/MarineVessel/MarineByLocation.jsp'></iframe>");


	    }
	}

	var reader = new Ext.data.JsonReader({
	    idProperty: 'darreaderid',
	    root: 'MarineHistoryGridRoot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'slnoIndex'
	    }, {
	        name: 'dateTime',
	        type: 'date',
	        dateFormat: getDateTimeFormat()
	    }, {
	        name: 'speed'
	    }, {
	        name: 'latitude'
	    }, {
	        name: 'longitude'
	    }, {
	        name: 'viewByLocation'
	    }]
	});

	var marineHistoryGridStore = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/MarineVessel.do?param=getMarineHistoryGrid',
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
	        type: 'date',
	        dataIndex: 'dateTime'
	    }, {
	        type: 'int',
	        dataIndex: 'speed'
	    }, {
	        type: 'float',
	        dataIndex: 'latitude'
	    }, {
	        type: 'float',
	        dataIndex: 'longitude'
	    }, {
	        type: 'string',
	        dataIndex: 'viewByLocation'
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
	            header: "<span style=font-weight:bold;><%=DateTime%></span>",
	            dataIndex: 'dateTime',
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
	            width: 100,
	            filter: {
	                type: 'date'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Speed%></span>",
	            dataIndex: 'speed',
	            width: 60,
	            filter: {
	                type: 'numeric'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Latitude%></span>",
	            dataIndex: 'latitude',
	            width: 100,
	            filter: {
	                type: 'numeric'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Longitude%></span>",
	            dataIndex: 'longitude',
	            width: 100,
	            filter: {
	                type: 'numeric'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=ViewByLocation%></span>",
	            dataIndex: 'viewByLocation',
	            renderer: veiwMapRenderer,
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

	function veiwMapRenderer() {
	    return '<img src="/ApplicationImages/ApplicationButtonIcons/ViewLocation.png">';
	}


	marineHistoryGrid = getGrid('', '<%=NoRecordsFound%>', marineHistoryGridStore, screen.width-390, 260, 7, filters, '<%=ClearFilterData%>', false, '', 7, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

	marineHistoryGrid.on({
	    "cellclick": {
	        fn: onCellClickOnGrid
	    }
	});

	var durationPanel = new Ext.Panel({
	    standardSubmit: true,
	    frame: true,
	    collapsible: false,
	    autoHeight: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 7
	    },
	    items: [{
	        xtype: 'label',
	        cls: 'labelstyle',
	        id: 'startdatelab',
	        text: '<%=StartDate%>' + ' :'
	    }, {
	        xtype: 'datefield',
	        cls: 'selectstylePerfect',
	        width: 185,
	        format: getDateTimeFormat(),
	        emptyText: '<%=SelectStartDate%>',
	        allowBlank: false,
	        blankText: '<%=SelectStartDate%>',
	        id: 'startdate',
	        value: dtprev,
	        vtype: 'daterange',
	        endDateField: 'enddate'
	    }, {
	        width: 30
	    }, {
	        xtype: 'label',
	        cls: 'labelstyle',
	        id: 'enddatelab',
	        text: '<%=EndDate%>' + ' :'
	    }, {
	        xtype: 'datefield',
	        cls: 'selectstylePerfect',
	        width: 185,
	        format: getDateTimeFormat(),
	        emptyText: '<%=SelectEndDate%>',
	        allowBlank: false,
	        blankText: '<%=SelectEndDate%>',
	        id: 'enddate',
	        value: dtcur,
	        vtype: 'daterange',
	        startDateField: 'startdate'
	    }, {
	        width: 30
	    }, {
	        xtype: 'button',
	        text: '<%=View%>',
	        id: 'addbuttonid',
	        cls: ' ',
	        width: 80,
	        listeners: {
	            click: {
	                fn: function () {
	                    if (parent.Ext.getCmp('custcomboId').getValue() == "") {
	                        parent.Ext.example.msg("<%=SelectCustomer%>");
	                        parent.Ext.getCmp('custcomboId').focus();
	                        return;
	                    }


	                    if (Ext.getCmp('startdate').getValue() == "") {
	                        parent.Ext.example.msg("<%=SelectStartDate%>");
	                        Ext.getCmp('startdate').focus();
	                        return;
	                    }

	                    if (Ext.getCmp('enddate').getValue() == "") {
	                        parent.Ext.example.msg("<%=SelectEndDate%>");
	                        Ext.getCmp('enddate').focus();
	                        return;
	                    }
	                    var startdates = Ext.getCmp('startdate').getValue();
	                    var enddates = Ext.getCmp('enddate').getValue();
	                    if (checkWeekValidation(startdates, enddates)) {
	                        parent.Ext.example.msg("<%=WeekValidation%>");
	                        Ext.getCmp('enddate').focus();
	                        return;
	                    }

	                    if (parent.byVesselGrid.getSelectionModel().getCount() == 1) {
	                        var selected = parent.byVesselGrid.getSelectionModel().getSelected();
	                        if (assetNumber == selected.get('vesselName')) {
	                            marineHistoryGridStore.load({
	                                params: {
	                                    CustId: customerId,
	                                    AssetNumber: assetNumber,
	                                    StartDate: Ext.getCmp('startdate').getValue(),
	                                    EndDate: Ext.getCmp('enddate').getValue(),
	                                    GroupName: Ext.getCmp('HistoryGroupNameId').getText(),
	                                    Latitude: Ext.getCmp('HistoryLatitudeId').getText(),
	                                    Longitude: Ext.getCmp('HistoryLongitudeId').getText(),
	                                    DriverName: Ext.getCmp('HistoryDriverNameId').getText(),
	                                    DriverNumber: Ext.getCmp('HistoryDriverNumberId').getText(),
	                                    OwnerName: Ext.getCmp('HistoryOwnerNameId').getText(),
	                                    OwnerNumber: Ext.getCmp('HistoryOwnerNumberId').getText(),
	                                    jspName: jspName
	                                }
	                            });
	                        } else {
	                            parent.Ext.example.msg("<%=SelectSingleRow%>");
	                            return;
	                        }
	                    }
	                }
	            }
	        }
	    }]
	});

	Ext.onReady(function () {
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';

	    marineHistoryPanel = new Ext.Panel({
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        collapsible: false,
	        width: screen.width-364,
	        height:435,
	        layout: 'table',
	        layoutConfig: {
	            columns: 1
	        },
	        items: [infoPanel, durationPanel, marineHistoryGrid]
	    });
	});			
	</script>
  	</body>
</html>