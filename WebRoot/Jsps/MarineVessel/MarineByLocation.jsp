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
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Vessel_ID");
	tobeConverted.add("Vessel_Name");
	tobeConverted.add("Distance");
	tobeConverted.add("Speed_Nauticle");
	tobeConverted.add("Group_Name");
	tobeConverted.add("Latitude");
	tobeConverted.add("Longitude");
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Owner_Name");
	tobeConverted.add("Date");
	tobeConverted.add("Proximity");
	tobeConverted.add("Please_Slide_Proximity");
	tobeConverted.add("View");
	
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
	tobeConverted.add("Driver_Number");
	tobeConverted.add("Owner_Number");
	
	tobeConverted.add("Enter_Latitude");
	tobeConverted.add("Enter_Longitude");
	tobeConverted.add("Select_Date");
	
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Clear");
	
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
		
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	
	String SlNo = convertedWords.get(2);
	String VesselId = convertedWords.get(3);
	String VesselName = convertedWords.get(4);
	String Distance = convertedWords.get(5);
	String Speed = convertedWords.get(6);
	String GroupName = convertedWords.get(7);
	String Latitude = convertedWords.get(8);
	String Longitude = convertedWords.get(9);
	String DriverName = convertedWords.get(10);
	String OwnerName = convertedWords.get(11);	
	String Date = convertedWords.get(12);
	String Proximity = convertedWords.get(13);
	String PleaseSlideProximity = convertedWords.get(14);
	String View = convertedWords.get(15);
	
	String Excel =  convertedWords.get(16);
	String PDF = convertedWords.get(17);
	
	String DriverNumber = convertedWords.get(18);
	String OwnerNumber = convertedWords.get(19);
	
	String EnterLatitude =  convertedWords.get(20);
	String EnterLongitude = convertedWords.get(21);
	String SelectDate = convertedWords.get(22);
	
	String NoRecordsFound = convertedWords.get(23);
	String ClearFilterData = convertedWords.get(24);
	String Clear = convertedWords.get(25);

%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>By Location</title>		
	</head>	    
  
  	<body>
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %> 		
   	<!-- for exporting to excel***** -->
   	<jsp:include page="../Common/ExportJS.jsp" />
   	<table align="center">
   		<tr>
   			<td id="content"></td>
   		</tr>
   	</table>
	<script type="text/javascript">
	
	var marineLocationPanel;
 	var dtprev;
 	var ctsb;
 	var custId;
 	var isCalledByHistory = parent.callByLocation;
 	var customerIdFormHistory;

 	var jspName = "MarineVesselLocationReport";
 	var exportDataType = "int,string,string,number,int,string,float,float,string,string,string,string";

 	if (isCalledByHistory == 'Yes') {

 	    var findByLocationStore = new Ext.data.JsonStore({
 	        url: '<%=request.getContextPath()%>/MarineVessel.do?param=getFindByLocation',
 	        id: 'findByLocationId',
 	        root: 'FindByLocationRoot',
 	        autoLoad: true,
 	        remoteSort: true,
 	        fields: ['FindByCustomerId', 'FindByLatitude', 'FindByLongitude', 'FindByDate'],
 	    });

 	    findByLocationStore.on('load', function (store, operation, eOpts) {
 	        var storeData = findByLocationStore.getAt(0);
 	        customerIdFormHistory = storeData.data['FindByCustomerId'];
 	        Ext.getCmp('latitudeId').setValue(storeData.data['FindByLatitude']);
 	        Ext.getCmp('longitudeId').setValue(storeData.data['FindByLongitude']);
 	        Ext.getCmp('dateTimeId').setValue(storeData.data['FindByDate']);
 	    }, this);
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
 	            }
 	            if (isCalledByHistory == 'Yes') {
 	                Ext.getCmp('custcomboId').setValue(customerIdFormHistory);
 	                parent.callByLocation = 'No';
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
 	            }
 	        }
 	    }
 	});

 	var reader = new Ext.data.JsonReader({
 	    idProperty: 'darreaderid',
 	    root: 'MarineLocationGridRoot',
 	    totalProperty: 'total',
 	    fields: [{
 	        name: 'slnoIndex'
 	    }, {
 	        name: 'assetId'
 	    }, {
 	        name: 'assetNumber'
 	    }, {
 	        name: 'distance'
 	    }, {
 	        name: 'speed'
 	    }, {
 	        name: 'groupName'
 	    }, {
 	        name: 'latitude'
 	    }, {
 	        name: 'longitude'
 	    }, {
 	        name: 'driverName'
 	    }, {
 	        name: 'driverNumber'
 	    }, {
 	        name: 'ownerName'
 	    }, {
 	        name: 'ownerNumber'
 	    }, {
 	        name: 'direction'
 	    }]
 	});

 	var marineLocationGridStore = new Ext.data.GroupingStore({
 	    autoLoad: false,
 	    proxy: new Ext.data.HttpProxy({
 	        url: '<%=request.getContextPath()%>/MarineVessel.do?param=getMarineLocationGrid',
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
 	        dataIndex: 'assetId'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'assetNumber'
 	    }, {
 	        type: 'float',
 	        dataIndex: 'distance'
 	    }, {
 	        type: 'int',
 	        dataIndex: 'speed'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'groupName'
 	    }, {
 	        type: 'float',
 	        dataIndex: 'latitude'
 	    }, {
 	        type: 'float',
 	        dataIndex: 'longitude'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'driverName'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'driverNumber'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'ownerName'
 	    }, {
 	        type: 'string',
 	        dataIndex: 'ownerNumber'
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
 	            header: "<span style=font-weight:bold;><%=VesselId%></span>",
 	            dataIndex: 'assetId',
 	            width: 120,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=VesselName%></span>",
 	            dataIndex: 'assetNumber',
 	            width: 120,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=Distance%></span>",
 	            dataIndex: 'distance',
 	            width: 60,
 	            filter: {
 	                type: 'numeric'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=Speed%></span>",
 	            dataIndex: 'speed',
 	            width: 80,
 	            filter: {
 	                type: 'numeric'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=GroupName%></span>",
 	            dataIndex: 'groupName',
 	            width: 100,
 	            filter: {
 	                type: 'string'
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
 	            header: "<span style=font-weight:bold;><%=DriverName%></span>",
 	            dataIndex: 'driverName',
 	            width: 120,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=DriverNumber%></span>",
 	            dataIndex: 'driverNumber',
 	            width: 100,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=OwnerName%></span>",
 	            dataIndex: 'ownerName',
 	            width: 120,
 	            filter: {
 	                type: 'string'
 	            }
 	        }, {
 	            header: "<span style=font-weight:bold;><%=OwnerNumber%></span>",
 	            dataIndex: 'ownerNumber',
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

 	var marineLocationGrid = getGrid('', '<%=NoRecordsFound%>', marineLocationGridStore, screen.width-64, 390, 13, filters, '<%=ClearFilterData%>', false, '', 13, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

 	var latLongPanel = new Ext.Panel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoScroll: true,
 	    frame: false,
 	    width: screen.width-32,
 	    id: 'marineLatLongPanelId',
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 11
 	    },	    
 	        items: [{
 	                xtype: 'label',
 	                text: '<%=CustomerName%>  :',
 	                cls: 'labelstyle',
 	                id: 'customerNameLabelId'
 	            },
 	            custnamecombo, {
 	                width: 140
 	            }, {
 	                xtype: 'label',
 	                text: '<%=Latitude%>  :',
 	                cls: 'labelstyle',
 	                id: 'LatitudeLabelId'
 	            }, {
 	                xtype: 'numberfield',
 	                allowDecimals: true,
 	                allowNegative: false,
 	                cls: 'selectstyle',
 	                emptyText: '<%=EnterLatitude%>',
 	                blankText: '<%=EnterLatitude%>',
 	                allowBlank: false,
 	                maxLength: 20,
 	                decimalPrecision: 9,
 	                id: 'latitudeId'
 	            }, {
 	                width: 140
 	            }, {
 	                xtype: 'label',
 	                text: '<%=Longitude%>  :',
 	                cls: 'labelstyle',
 	                id: 'LongitudeLabelId'
 	            }, {
 	                xtype: 'numberfield',
 	                allowDecimals: true,
 	                allowNegative: false,
 	                cls: 'selectstyle',
 	                emptyText: '<%=EnterLongitude%>',
 	                blankText: '<%=EnterLongitude%>',
 	                allowBlank: false,
 	                maxLength: 20,
 	                decimalPrecision: 9,
 	                id: 'longitudeId'
 	            }, {
 	                width: 140
 	            }, {
 	                xtype: 'label',
 	                text: '<%=Date%>  :',
 	                cls: 'labelstyle',
 	                id: 'dateTimeLabelId'
 	            }, {
 	                xtype: 'datefield',
 	                cls: 'selectstylePerfect',
 	                format: getDateTimeFormat(),
 	                emptyText: '<%=SelectDate%>',
 	                allowBlank: false,
 	                blankText: '<%=SelectDate%>',
 	                id: 'dateTimeId'
 	            }
 	        ]
 	});

 	var proximityPanel = new Ext.form.FormPanel({
 	    standardSubmit: true,
 	    frame: false,
 	    collapsible: false,
 	    autoHeight: true,
 	    width: 380,
 	    defaults: {
 	        anchor: '100%',
 	        tipText: function (thumb) {
 	            return String(thumb.value) + ' Nautical Miles';
 	        }
 	    },
 	    items: [{
 	        fieldLabel: '<%=Proximity%>',
 	        xtype: 'sliderfield',
 	        id: 'proximitySlideId',
 	        increment: 1,
 	        minValue: 1,
 	        maxValue: 20,
 	        name: 'fx',
 	        plugins: new Ext.slider.Tip(),
 	        onChange: function (slider, v) {
 	            var sliderValue = slider.getValue();
 	            Ext.getCmp('sliderValue').setValue(sliderValue);
 	        }

 	    }]
 	});

 	var buttonPanel = new Ext.Panel({
 	    standardSubmit: true,
 	    frame: false,
 	    collapsible: false,
 	    autoHeight: true,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 7
 	    },
 	    items: [{
 	        xtype: 'textfield',
 	        id: 'sliderValue',
 	        value: '1',
 	        width: 30,
 	        disabled: true
 	    }, {
 	        width: 10
 	    }, {
 	        xtype: 'label',
 	        cls: 'labelBoldFontPerfect',
 	        text: 'Nauticle Miles'
 	    }, {
 	        width: 30
 	    }, {
 	        xtype: 'button',
 	        text: '<%=View%>',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {

 	                    if (Ext.getCmp('custcomboId').getValue() == "") {
 	                        Ext.example.msg("<%=SelectCustomer%>");
 	                        Ext.getCmp('custcomboId').focus();
 	                        return;
 	                    }

 	                    if (Ext.getCmp('latitudeId').getValue() == "") {
 	                        Ext.example.msg("<%=EnterLatitude%>");
 	                        Ext.getCmp('latitudeId').focus();
 	                        return;
 	                    }

 	                    if (Ext.getCmp('longitudeId').getValue() == "") {
 	                        Ext.example.msg("<%=EnterLongitude%>");
 	                        Ext.getCmp('longitudeId').focus();
 	                        return;
 	                    }

 	                    if (Ext.getCmp('dateTimeId').getValue() == "") {
 	                        Ext.example.msg("<%=SelectDate%>");
 	                        Ext.getCmp('dateTimeId').focus();
 	                        return;
 	                    }

 	                    marineLocationGridStore.load({
 	                        params: {
 	                            CustId: Ext.getCmp('custcomboId').getValue(),
 	                            CustName: Ext.getCmp('custcomboId').getRawValue(),
 	                            Latitude: Ext.getCmp('latitudeId').getValue(),
 	                            Longitude: Ext.getCmp('longitudeId').getValue(),
 	                            Proximity: Ext.getCmp('proximitySlideId').getValue(),
 	                            Date: Ext.getCmp('dateTimeId').getValue(),
 	                            jspName: jspName
 	                        }
 	                    });
 	                }
 	            }
 	        }

 	    }, {
 	        width: 30
 	    }, {
 	        xtype: 'button',
 	        text: '<%=Clear%>',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                    Ext.getCmp('custcomboId').reset();
 	                    Ext.getCmp('latitudeId').reset();
 	                    Ext.getCmp('longitudeId').reset();
 	                    Ext.getCmp('proximitySlideId').reset();
 	                    Ext.getCmp('dateTimeId').reset();
 	                    marineLocationGrid.store.clearData();
 	                    marineLocationGrid.view.refresh();
 	                }
 	            }
 	        }
 	    }]
 	});

 	var proximityButtonpanel = new Ext.Panel({
 	    standardSubmit: true,
 	    frame: false,
 	    collapsible: false,
 	    autoHeight: true,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4
 	    },
 	    items: [{
 	            width: 5
 	        },
 	        proximityPanel, {
 	            width: 10
 	        },
 	        buttonPanel
 	    ]
 	});

 	var innerPanel = new Ext.Panel({
 	    standardSubmit: true,
 	    frame: true,
 	    collapsible: false,
 	    autoHeight: true,
 	    width:screen.width-64,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 1
 	    },
 	    items: [latLongPanel, {height:10}, proximityButtonpanel]
 	});

 	Ext.onReady(function () {
 	    ctsb = tsb;
 	    Ext.QuickTips.init();
 	    Ext.form.Field.prototype.msgTarget = 'side';

 	    marineLocationPanel = new Ext.Panel({
 	        renderTo: 'content',
 	        standardSubmit: true,
 	        frame: true,
 	        collapsible: false,
 	        width:screen.width-38,
 	        height:500,
 	        cls: 'outerpanel',
 	        layout: 'table',
 	        layoutConfig: {
 	            columns: 1
 	        },
 	        items: [innerPanel, marineLocationGrid],
 	        //bbar: ctsb
 	    });
 	});
 	
	</script>
  	</body>
</html>