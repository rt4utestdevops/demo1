<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.distributionlogistics.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();

CommonFunctions cf = new CommonFunctions();
CTDashboardColumns ctDashboardColumns=new CTDashboardColumns();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails"); 	
String language = loginInfo.getLanguage();
int systemid = loginInfo.getSystemId();
String systemID = Integer.toString(systemid);
int customeridlogged = loginInfo.getCustomerId();
String CustName = loginInfo.getCustomerName();
int userId=loginInfo.getUserId();
String dataTypes=ctDashboardColumns.exportDataTypes(userId,systemid,customeridlogged);
String status1 = "";
%>
<jsp:include page="../Common/header.jsp" />
<div ng-app="myApp">


    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Dashboard</title>
    <!-- Bootstrap Core CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link href="/Telematics4uApp/Main/resources/css/DistributionLogisticsDashboardStyles.css" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900italic,900' rel='stylesheet' type='text/css'>
    
    <jsp:include page="../Common/ExportJsForDriver.jsp" />
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        .running-trips {
            padding: 10px 0px;
            top: 39%;
        }
        .x-panel-body x-panel-body-noborder {
            width: 260px;
        }
        .style-toggler {
            position: absolute;
            left: 1295px;
            background-image: url(/ApplicationImages/DashBoard/BoxBlack.png);
            border: 1px solid #111;
            -webkit-box-shadow: 0 0 5px 1px #111111;
            -moz-box-shadow: 0 0 5px 1px #111111;
            box-shadow: 0 0 5px 1px #111111;
            -webkit-border-radius: 3px 3px 3px 3px;
            -moz-border-radius: 3px 3px 3px 3px;
            border-radius: 3px 3px 3px 3px;
            padding: 5px 0;
            top: 74px;
            z-index: 1050;
            cursor: pointer;
        }
        .style-switcher {
            border: 1px solid #111;
            -webkit-box-shadow: 0 0 5px 1px #111111;
            -moz-box-shadow: 0 0 5px 1px #111111;
            box-shadow: 0 0 5px 1px #111111;
            -webkit-border-radius: 3px 3px 3px 3px;
            -moz-border-radius: 3px 3px 3px 3px;
            top: 39px;
            left:1007px;
            position: absolute;
            z-index: 1050;
            color: #eee;
        }
        .style-toggler {
            cursor: pointer;
        }
        .x-grid3-hd-inner {
		     overflow: hidden;
		     padding: 3px 3px 3px 5px;
		     white-space: normal;
		}
		#noteId{
			font-size: 16px; 
			float: right;
    		padding-top: 63px;
    		color:black;
    		padding-right: 18px !important;
		}
		.ui-widget-overlay{
			display:none;
		}
		.ui-button-icon-primary ui-icon ui-icon-closethick
		{
			margin:-8px;
		}
		
		.ext-strict .x-grid3-cell-inner {
	    color:black;
	    }
	
	html { overflow: hidden };
    </style>

<!--<body ng-controller="myCtrl"> -->
<div ng-controller="myCtrl" >
    <div class="style-toggler" style="width:40px;height:40px;"  onclick="showPopUp('style-switcherid')"><img id="searchImg" src="/ApplicationImages/ApplicationButtonIcons/Settings-icon.png" alt="" class='tip' style="width: 44px;"></div>
    <div class="style-switcher" id="style-switcherid" style="display:none;"></div>
    <div class="">
        <div class="overall-status">
        <div class="note">
         <p id="noteId">Column setting</p>
         </div>
            <div class="container">
                <h1 style=" margin-top: 10px;">Welcome to Dashboard of {{clientName}}</h1>
                <div class="status-details">
                    <div class="status-elems">
                        <a href="">
                            <h3 class="ontime" id="onTimeId" ng-bind="onTimeId" onclick="loadTheStore('ontime')">0</h3>
                        </a>
                        <h6>On Time <br/></h6>
                    </div>
                    <div class="status-elems">
                        <a href="">
                            <h3 class="delayed" id="delayedId" ng-bind="delayedId" onclick="loadTheStore('delay')">0</h3>
                        </a>
                        <h6>Delayed <br/></h6>
                    </div>
                    <div class="status-elems">
                        <a href="">
                            <h3 class="before-time" id="beforeTimeId" ng-bind="beforeTimeId" onclick="loadTheStore('beforetime')">0</h3>
                        </a>
                        <h6>Before<br/> Time
                        </h6>
                    </div>
                    <div class="status-elems">
                        <a href="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/AlertReport.jsp?dashBoard=MRDASHBOARD&AlertId=2&AlertName=Over Speed&data='123'---'555'---'2434'&fromdatefordetailspage=Sun Jan 01 2017 00:00:00 GMT 0530 (India Standard Time)&todatefordetailspage=Sun Jan 29 2017 00:00:00 GMT 0530 (India Standard Time)&typefordetailspage=IN TRANSIT&fromlocationfordetailspage=0&fromlocationIdfordetailspage=0&tolocationfordetailspage=0&tolocationIdfordetailspage=0">
                            <h3 class="over-time" id="overSpeedId" ng-bind="overSpeedId" ng-click="filters.tripStatus = ''">0</h3>
                        </a>
                        <h6>Over<br/> Speed
                        </h6>
                    </div>
                    <div class="status-elems">
                        <a href="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/AlertReport.jsp?dashBoard=MRDASHBOARD&AlertId=1&AlertName=Vehicle Stoppage&data='123'---'555'---'2434'&fromdatefordetailspage=Sun Jan 01 2017 00:00:00 GMT 0530 (India Standard Time)&todatefordetailspage=Sun Jan 29 2017 00:00:00 GMT 0530 (India Standard Time)&typefordetailspage=IN TRANSIT&fromlocationfordetailspage=0&fromlocationIdfordetailspage=0&tolocationfordetailspage=0&tolocationIdfordetailspage=0">
                            <h3 class="vehicle-stoppage" id="vehicleStoppageId" ng-bind="vehicleStoppageId" ng-click="filters.tripStatus = ''">0</h3>
                        </a>
                        <h6>Vehicle<br/> Stoppage
                        </h6>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
        <div class="running-trips" id="id">

        </div>
    </div>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&region=IN"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="https://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/jquery-ui.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.6.1/angular.min.js"></script>
    <link href="https://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/themes/blitzer/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="/Telematics4uApp/Main/Js/distributionLogisticsDashboardMain.js"></script>
    <div id="dialog" style="display: none">
        <div id="dvMap" style="height: 400px; width: 100%;"></div>
    </div>
    <jsp:include page="../Common/ImportJSSandMining.jsp" />
	<style>
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
	</style>
	<script type="text/javascript">
    function showPopUp(id) { 
        optionGridStore.load();
         var e = document.getElementById(id);
        if (e.style.display == 'none') {
            $('#style-switcherid').attr("style", "display: block !important");
        } else {
           $('#style-switcherid').attr("style", "display: none !important");
        }
    }
    var jspName = "CT_Dashboard_Details";
    var infoWindows = [];
    var exportDataType = "<%=dataTypes%>";
    var status;
    var path = "<%=request.getContextPath()%>";
    
    function initialize() {
    var mapOptions = {
        zoom: 3,
        center: new google.maps.LatLng(21.0000, 78.0000),
        mapTypeControl: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map($("#dvMap")[0], mapOptions);
    mapZoom = 10;
    var defaultBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),
        new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));
	    map.fitBounds(defaultBounds);
	}
	function closeInfowindow() {
	    if (infoWindows.length > 0) {
	        infoWindows[0].set("marker", null);
	        infoWindows[0].close();
	        infoWindows.length = 0;
	    }
	}
	function clearMap() {
	    if (lineInfo.length > 0) {
	        var marker = lineInfo[0];
	        marker.setMap(null);
	        marker = null;
	    }
	}
	setTimeout(function() {
        window.location.reload(1);
    }, 120000);
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'dasBoardRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'stoppageOutsideIndex'
        }, <%=ctDashboardColumns.getGridReaders(userId,systemid,customeridlogged).toString()%> 
        {
            name: 'routeNameIndex'
        },{
            name: 'categoryIndex'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=getDahBoardDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'dataStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        },{
            type: 'string',
            dataIndex: 'stoppageOutsideIndex'
        }, <%=ctDashboardColumns.getFilterList().toString()%>
        {name: 'categoryIndex',type: 'string'}]
    });

    var createColModel = function(finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SL NO</span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                header: "<span style=font-weight:bold;>SL NO</span>",
                hidden: true,
                filter: {
                    type: 'numeric'
                }
                },
             <%=ctDashboardColumns.getGridHeaderBuffer(userId,systemid,customeridlogged).toString()%>
             {
                header: "<span style=font-weight:bold;>Stoppage</span>",
                dataIndex: 'stoppageOutsideIndex',
                align: 'left',
                hidden:true,
                filter: {
                    type: 'string'
                },
                renderer: function(value, metaData, record, rowIndex, colIndex, store) {
		                var fieldName = grid.getColumnModel().getDataIndex(colIndex);
						status = record.get(fieldName);
                        return status;
	                }
             },
             {
                header: "<span style=font-weight:bold;>Unauthorised Stoppage</span>",
                dataIndex: 'categoryIndex',
                align: 'left',
                filter: {
                    type: 'string'
                },
               	renderer: function(value, metaData, record, rowIndex, colIndex, store) {
	                var fieldName = grid.getColumnModel().getDataIndex(colIndex);
					var value1 = record.get(fieldName);
					if(status == 'true'){
					   metaData.attr = 'style="background-color:red;"';
					}
					return value1;
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
    store.load({
        params: {
            type: '',
            jspname: jspName
        }
    });
    var grid = getGrid('', 'No records Found', store, 1310, 380, 70, filters, '', false, '', 20, false, '', false, 'Approval', true, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete', false, '', false, '', false, 'PDF', false, 'Final Submit', false, '');
	function showMapView(value) {
    var res = value.getAttribute("value").split(";");
    $("#dialog").dialog({
        modal: true,
        title: "Map View",
        width: 600,
        hright: 400,
        buttons: {
            Close: function() {
                $(this).dialog('close');
            }
        },
        open: function() {
            if (res[2] == 'STOPPAGE') {
                imageurl = '/ApplicationImages/VehicleImages/red.png';
            } else if (res[2] == 'RUNNING') {
                imageurl = '/ApplicationImages/VehicleImages/green.png';
            } else {
                imageurl = '/ApplicationImages/VehicleImages/yellow.png';
            }
            image = {
                url: imageurl,
                scaledSize: new google.maps.Size(24, 35),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(0, 32)
            };
            var pos = new google.maps.LatLng(parseFloat(res[0]), parseFloat(res[1]));
            var marker = new google.maps.Marker({
                position: pos,
                map: map,
                icon: image
            });
            var infowindow = new google.maps.InfoWindow({
                content: value.getAttribute("name").replace(/\*/g, " "),
                marker: marker,
                maxWidth: 300,
                image: image
            });
            infowindow.open(map, marker);
            var mapOptions = {
                center: new google.maps.LatLng(parseFloat(res[0]), parseFloat(res[1])),
                zoom: 14,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            var map = new google.maps.Map($("#dvMap")[0], mapOptions);
            marker.setMap(map);
            var location = value.getAttribute("name");
            google.maps.event.addListener(marker, 'click', function() {
                var infowindow = new google.maps.InfoWindow({
                    content: location.replace(/\*/g, " ")
                });
                infowindow.open(map, marker);
            });
        }
    });
}
    grid.on('celldblclick', function(grid, rowIndex, columnIndex) {
        var selected = grid.getSelectionModel().getSelected();
        flag = "MRDASHBOARD";
        shipmentId = selected.get('shipmentIdIndex');
        vehicleNo = selected.get('vehicleNoDataIndex');
        routeName = selected.get('routeNameIndex');
        window.location = "<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/DashboardDetails.jsp?flag=" + flag + "&vehicleNo=" + vehicleNo + "&shipmentId=" + shipmentId + "&routeName=" + routeName;
    })

    function loadTheStore(type) {
        store.load({
            params: {
                type: type,
                jspname: jspName
            }
        });
    }
    //***************************************************************************Option GRID***********************************************************************************//
    var sm1 = new Ext.grid.CheckboxSelectionModel({
        checkOnly: true
    });

    var cols1 = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 40
        }), sm1,
        {
            header: '<b>SL NO</b>',
            width: 195,
            sortable: true,
            hidden: true,
            dataIndex: 'slnoIndex'
        }, {
            header: '<b>Columns</b>',
            width: 195,
            sortable: true,
            dataIndex: 'columnsIndex'
        }
    ]);

    var reader1 = new Ext.data.JsonReader({
        root: 'firstGridRoot',
        fields: [{
            name: 'slnoIndex',
            type: 'numeric'
        }, {
            name: 'columnsIndex',
            type: 'string'
        }, {
            name: 'columnId',
            type: 'int'
        }, {
            name: 'checkedStatus',
            type: 'String'
        }]
    });

    var filters1 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            dataIndex: 'columnsIndex',
            type: 'string'
        }]
    });

    var optionGridStore = new Ext.data.Store({
        url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=getColumnHeaders',
        bufferSize: 367,
        reader: reader1,
        autoLoad: false,
        remoteSort: false
    });
    var optionGrid = getSelectionModelGrid('', 'No Records found', optionGridStore, 288, 420, cols1, 6, filters1, sm1);

    var ButtonPanelForOptions = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 80,
        width: 288,
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Save',
            id: 'plotButtId',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        var records = optionGrid.getSelectionModel().getSelected();
                        if (records == undefined || records == "undefined") {
                            Ext.example.msg("Please Select Atleast one row");
                            return;
                        }
                        var gridData = "";
                        var json = "";
                        var records1 = optionGrid.getSelectionModel().getSelections();
                        for (var i = 0; i < records1.length; i++) {
                            var record1 = records1[i];
                            var row = optionGrid.store.findExact('slnoIndex', record1.get('slnoIndex'));
                            var store = optionGrid.store.getAt(row);
                            json = json + Ext.util.JSON.encode(store.data) + ',';
                        }
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=associateHeaders',
                            method: 'POST',
                            params: {
                                gridData: json
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                var e2 = document.getElementById('style-switcherid');
                                if (e2.style.display == 'none') {
                                    e2.style.display = 'block';
                                } else {
                                    e2.style.display = 'none';
                                }
                                optionGridStore.load();
                                window.location.reload(1);
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                optionGridStore.reload();
                                store.load({
                                    params: {
                                        type: '',
                                        jspname: jspName
                                    }
                                });

                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: 'Cancel',
            id: 'canButtId',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        var e1 = document.getElementById('style-switcherid');
                        if (e1.style.display == 'none') {
                            e1.style.display = 'block';
                        } else {
                            e1.style.display = 'none';
                        }
                    }
                }
            }
        }]
    });
    var optionsOuterPanelWindow = new Ext.Panel({
        width: 300,
        height: 500,
        standardSubmit: true,
        frame: true,
        layoutConfig: {
            columns: 1
        },
        items: [optionGrid, ButtonPanelForOptions]
    });
    optionGridStore.load();
    Ext.onReady(function() {
        Ext.QuickTips.init();
        outerPanel = new Ext.Panel({
            renderTo: 'id',
            standardSubmit: true,
            frame: true,
            width: 1337,
            height: 400,
            layoutConfig: {
                columns: 1
            },
            items: [grid]
        });
        var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 80);
        }
        mainPanel = new Ext.Panel({
            width: 300,
            height: 500,
            id: 'mainPanelid',
            bodyCfg: {
                cls: 'dashboardcustomerpannelmap',
                style: {
                    'background-color': 'transparent !important'
                }
            },
            items: [optionsOuterPanelWindow]
        });
        mainPanel.render('style-switcherid');
        var ids = [];
        optionGridStore.on('load', function(store, records) {
            ids = [];
            for (var i = 0; i < records.length; i++) {
                if (records[i].get('checkedStatus') == 'TRUE') {
                    ids.push(records[i].get('columnId'));
                }
            };
        });
        optionGridStore.on('load', function() {
            for (var i = 0; i < ids.length; i++) {
                var rec = optionGridStore.findExact('columnId', ids[i]);
                optionGrid.getSelectionModel().selectRow(rec, true);
            }
        });
    });
</script>
</div>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 </div>