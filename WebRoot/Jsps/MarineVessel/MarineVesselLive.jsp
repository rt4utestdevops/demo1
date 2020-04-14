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
	
	tobeConverted.add("Vessel_Live_Information");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Vessel_ID");
	tobeConverted.add("Vessel_Name");
	tobeConverted.add("Distance");
	tobeConverted.add("Speed_Nauticle");
	tobeConverted.add("Group_Name");
	tobeConverted.add("Latitude");
	tobeConverted.add("Longitude");
	tobeConverted.add("View");
	
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Owner_Name");
	tobeConverted.add("Last_Communicated");
	tobeConverted.add("Driver_Number");
	tobeConverted.add("Owner_Number");
	
	tobeConverted.add("Near_By_Vessel");
	tobeConverted.add("Map");
	
	tobeConverted.add("Proximity");
	tobeConverted.add("Please_Slide_Proximity");
	
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Communication_Status");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String MarineLiveInformation =  convertedWords.get(0);
	String SlNo = convertedWords.get(1);
	String VesselId = convertedWords.get(2);
	String VesselName = convertedWords.get(3);
	String Distance = convertedWords.get(4);
	String Speed = convertedWords.get(5);
	String GroupName = convertedWords.get(6);
	String Latitude = convertedWords.get(7);
	String Longitude = convertedWords.get(8);
	String View = convertedWords.get(9);
	
	String DriverName = convertedWords.get(10);
	String OwnerName = convertedWords.get(11);
	String LastCommunicatedTime = convertedWords.get(12);
	String DriverNumber = convertedWords.get(13);
	String OwnerNumber = convertedWords.get(14);;
	
	String NearByVessel = convertedWords.get(15);
	String Map = convertedWords.get(16);
	String Proximity = convertedWords.get(17);
	String PleaseSlideProximity = convertedWords.get(18);
	
	String Excel = convertedWords.get(19);
	String PDF = convertedWords.get(20);
	String NoRecordsFound = convertedWords.get(21);
	String ClearFilterData = convertedWords.get(22);
	String SelectSingleRow = convertedWords.get(23); 
	
	String SelectCustomer = convertedWords.get(24);
	String CommunicationStatus = convertedWords.get(25);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>Marine Vessel Live</title>		
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
	var assetNumber = parent.globalAssetNumber;
	var assetId = parent.globalAssetId;
	var customerId = parent.custId;
	var mapLatitude;
	var mapLongitude;
	var mapRadius;
	var marineLiveGridStore;
	
	var jspName = "MarineVesselLiveReport";
	var exportDataType = "int,string,string,number,int,string,string,string,float,float";

	var marineLiveInformationStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/MarineVessel.do?param=getMarineLiveInformation',
	    id: 'MarineLiveInformationId',
	    root: 'MarineLiveInformationRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['GroupName', 'LastCommunicatedTime', 'Latitude', 'Longitude', 'DriverName', 'DriverNumber', 'OwnerName', 'OwnerNumber', 'Communication']
	});

	marineLiveInformationStore.on('beforeload', function (store, operation, eOpts) {
	    operation.params = {
	        CustId: customerId,
	        AssetNumber: assetNumber
	    };
	});

	marineLiveInformationStore.on('load', function (store, operation, eOpts) {
	    var storeData = marineLiveInformationStore.getAt(0);

	    Ext.getCmp('liveGroupNameId').setText(storeData.data['GroupName']);
	    Ext.getCmp('liveLastCommunicatedTimeId').setText(storeData.data['LastCommunicatedTime']);
	    Ext.getCmp('liveLatitudeId').setText(storeData.data['Latitude']);
	    Ext.getCmp('liveLongitudeId').setText(storeData.data['Longitude']);
	    Ext.getCmp('liveDriverNameId').setText(storeData.data['DriverName']);
	    Ext.getCmp('liveDriverNumberId').setText(storeData.data['DriverNumber']);
	    Ext.getCmp('liveOwnerNameId').setText(storeData.data['OwnerName']);
	    Ext.getCmp('liveOwnerNumberId').setText(storeData.data['OwnerNumber']);
	    Ext.getCmp('liveCommunicationId').setText(storeData.data['Communication']);
	    
	    //For Map
	    mapLatitude = storeData.data['Latitude'];
	    mapLongitude = storeData.data['Longitude'];
	    
	}, this);

	var infoPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    frame: false,
	    width: screen.width-374,
	    id: 'marineLiveInfoPanelId',
	    layout: 'table',
	    layoutConfig: {
	        columns: 1
	    },
	    items: [{
	        xtype: 'fieldset',
	        title: '<%=MarineLiveInformation%>',
	        collapsible: false,
	        colspan: 3,
	        width: screen.width-379,
	        id: 'marineLiveItemId',
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
	            id: 'liveGroupNameLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveGroupNameId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label'
	        }, {
	            xtype: 'label'
	        }, {
	            xtype: 'label',
	            text: '<%=Latitude%>  :',
	            cls: 'labelstyle',
	            id: 'liveLatitudeLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveLatitudeId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=Longitude%>  :',
	            cls: 'labelstyle',
	            id: 'liveLongitudeLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveLongitudeId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            xtype: 'label',
	            text: '<%=DriverName%>  :',
	            cls: 'labelstyle',
	            id: 'liveDriverNameLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveDriverNameId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=DriverNumber%>  :',
	            cls: 'labelstyle',
	            id: 'liveDriverNumberLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveDriverNumberId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            xtype: 'label',
	            text: '<%=OwnerName%>  :',
	            cls: 'labelstyle',
	            id: 'liveOwnerNameLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveOwnerNameId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=OwnerNumber%>  :',
	            cls: 'labelstyle',
	            id: 'liveOwnerNumberLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveOwnerNumberId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            xtype: 'label',
	            text: '<%=LastCommunicatedTime%>  :',
	            cls: 'labelstyle',
	            id: 'liveLastCommunicatedTimeLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveLastCommunicatedTimeId',
	            cls: 'labelBoldFontPerfect'
	        }, {
	            width: 30
	        }, {
	            xtype: 'label',
	            text: '<%=CommunicationStatus%>  :',
	            cls: 'labelstyle',
	            id: 'liveCommunicationLabelId'
	        }, {
	            xtype: 'label',
	            id: 'liveCommunicationId',
	            cls: 'labelBoldFontPerfect'
	        }]
	    }]
	});

	var reader = new Ext.data.JsonReader({
	    idProperty: 'darreaderid',
	    root: 'MarineLiveGridRoot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'slnoIndex'
	    }, {
	        name: 'vesselId'
	    }, {
	        name: 'vesselName'
	    }, {
	        name: 'distance'
	    }, {
	        name: 'speed'
	    }, {
	        name: 'groupName'
	    }, {
	        name: 'driverName'
	    }, {
	        name: 'ownerName'
	    }, {
	        name: 'latitude'
	    }, {
	        name: 'longitude'
	    }]
	});

	marineLiveGridStore = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/MarineVessel.do?param=getMarineLiveGrid',
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
	        dataIndex: 'vesselId'
	    }, {
	        type: 'string',
	        dataIndex: 'vesselName'
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
	        type: 'string',
	        dataIndex: 'driverName'
	    }, {
	        type: 'string',
	        dataIndex: 'ownerName'
	    }, {
	        type: 'float',
	        dataIndex: 'latitude'
	    }, {
	        type: 'float',
	        dataIndex: 'longitude'
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
	            dataIndex: 'vesselId',
	            width: 80,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=VesselName%></span>",
	            dataIndex: 'vesselName',
	            width: 100,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Distance%></span>",
	            dataIndex: 'distance',
	            width: 50,
	            filter: {
	                type: 'numeric'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Speed%></span>",
	            dataIndex: 'speed',
	            width: 70,
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
	            header: "<span style=font-weight:bold;><%=DriverName%></span>",
	            dataIndex: 'driverName',
	            width: 100,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=OwnerName%></span>",
	            dataIndex: 'ownerName',
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
	        }
	    ];

	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),
	        defaults: {
	            sortable: true
	        }
	    });
	};

	var marineLiveGrid = getGrid('', '<%=NoRecordsFound%>', marineLiveGridStore, screen.width-380, 210, 11, filters, '<%=ClearFilterData%>', false, '', 11, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');


	var proximityPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    frame: false,
	    collapsible: false,
	    autoHeight: true,
	    width: 390,
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
	        columns: 5
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
	        width: 25
	    }, {
	        xtype: 'button',
	        text: '<%=View%>',
	        width: 80,
	        listeners: {
	            click: {
	                fn: function () {
	                    if (parent.Ext.getCmp('custcomboId').getValue() == "") {
	                        parent.Ext.example.msg("<%=SelectCustomer%>");
	                        parent.Ext.getCmp('custcomboId').focus();
	                        return;
	                    }

	                    if (parent.byVesselGrid.getSelectionModel().getCount() == 0) {
	                        parent.Ext.example.msg("<%=SelectSingleRow%>");
	                        return;
	                    }

	                    if (parent.byVesselGrid.getSelectionModel().getCount() > 1) {
	                        parent.Ext.example.msg("<%=SelectSingleRow%>");
	                        return;
	                    }

	                    if (parent.byVesselGrid.getSelectionModel().getCount() == 1) {
	                    	  		                	 		                	
	                        var selected = parent.byVesselGrid.getSelectionModel().getSelected();
	                        if (assetNumber == selected.get('vesselName')) {
	                        	mapRadius = Ext.getCmp('proximitySlideId').getValue();
	                            marineLiveGridStore.load({
	                                params: {
	                                    CustId: customerId,
	                                    AssetNumber: assetNumber,
	                                    ProximityValue: Ext.getCmp('proximitySlideId').getValue(),
	                                    GroupName: Ext.getCmp('liveGroupNameId').getText(),
	                                    Latitude: Ext.getCmp('liveLatitudeId').getText(),
	                                    Longitude: Ext.getCmp('liveLongitudeId').getText(),
	                                    DriverName: Ext.getCmp('liveDriverNameId').getText(),
	                                    DriverNumber: Ext.getCmp('liveDriverNumberId').getText(),
	                                    OwnerName: Ext.getCmp('liveOwnerNameId').getText(),
	                                    OwnerNumber: Ext.getCmp('liveOwnerNumberId').getText(),
	                                    LastCommunicated: Ext.getCmp('liveLastCommunicatedTimeId').getText(),
	                                    CommunicationStatus: Ext.getCmp('liveCommunicationId').getText(),
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

	var proximityButtonpanel = new Ext.Panel({
	    standardSubmit: true,
	    frame: true,
	    width:screen.width-380,
	    collapsible: false,
	    autoHeight: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 3
	    },
	    items: [proximityPanel, {
	            width: 10
	        },
	        buttonPanel
	    ]
	});
	
	var marineLiveTabs = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll: true,
	    activeTab: 'marineLiveGridTab',
	    id: 'mainTabPanelId',
	    width: screen.width-380,
	    listeners: {
	    	'tabchange': function(tabPanel, tab){
            	if(tab.id == 'marineLiveMapTab'){
            		Ext.getCmp('marineLiveMapTab').enable();
            		Ext.getCmp('marineLiveMapTab').show();
            		Ext.getCmp('marineLiveMapTab').update("<iframe style='width:100%;height:380px;border:0;frameborder=0;scrolling=no;marginheight=0;marginwidth=0;'src='<%=path%>/Jsps/Common/GoogleMap.jsp'></iframe>");
                }
             }
        }
	});

	addTab();

	function addTab() {
	    marineLiveTabs.add({
	        title: '<%=NearByVessel%>',
	        iconCls: 'admintab',
	        id: 'marineLiveGridTab',
	        items: [proximityButtonpanel, marineLiveGrid]
	    }).show();

	    marineLiveTabs.add({
	        title: '<%=Map%>',
	        iconCls: 'admintab',
	        autoScroll: true,
	        id: 'marineLiveMapTab',
	        html: "<iframe style='width:100%;height:250px;border:0;'src='<%=path%>/Jsps/Common/GoogleMap.jsp'></iframe>"
	    }).show();
	    
	    
	}

	Ext.onReady(function () {

	    marineLivePanel = new Ext.Panel({
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        collapsible: false,
	        width: screen.width-360,
	        height:435,
	        layout: 'table',
	        layoutConfig: {
	            columns: 1
	        },
	        items: [infoPanel, marineLiveTabs]
	    });
	    Ext.Ajax.timeout = 180000; 
	});
	</script>
  	</body>
</html>