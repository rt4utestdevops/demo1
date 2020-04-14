<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int customerId=loginInfo.getCustomerId();
				String vehicleTypeRequest = "all";
		Properties properties = ApplicationListener.prop;
		String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		
		int custId=0;



ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Select_Customer");
tobeConverted.add("Trip_No");
tobeConverted.add("Registration_Number");
tobeConverted.add("Hub");
tobeConverted.add("Location");
tobeConverted.add("ROUTE");
tobeConverted.add("Points_To_Visit");
tobeConverted.add("Start_Date_Time");
tobeConverted.add("Driver_Name");
tobeConverted.add("CUSTODIAN1");
tobeConverted.add("GUNMAN1");
tobeConverted.add("GUNMAN2");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Clear_Filter_Data");
//tobeConverted.add("CUSTODIAN1AND2");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String CustomerName=convertedWords.get(1);
String NoRecordFound=convertedWords.get(2);
String SelectCustomer=convertedWords.get(3);
String TripNo=convertedWords.get(4);
String RegistrationNumber=convertedWords.get(5);
String Hub=convertedWords.get(6);
String Location=convertedWords.get(7);
String Route=convertedWords.get(8);
String PointsToVisit=convertedWords.get(9);
String StartDateTime=convertedWords.get(10);
String DRIVERNAME=convertedWords.get(11);
String CUSTODIAN1=convertedWords.get(12);
String GUNMAN1=convertedWords.get(13);
String GUNMAN2=convertedWords.get(14);
String SelectSingleRow=convertedWords.get(15);
String SLNO=convertedWords.get(16);
String NoRecordsFound=convertedWords.get(17);
String NoRowSelected=convertedWords.get(18);
String ClearFilterData=convertedWords.get(19);
String CUSTODIAN1AND2 = "CUSTODIAN 1&2";
String latitudeLongitude = cf.getCoordinates(systemid);
MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
String mapName = bean.getMapName();
String appKey = bean.getAPIKey();
String appCode = bean.getAppCode();
%>
<jsp:include page="../Common/header.jsp" />
<jsp:include page="../Common/InitializeLeaflet.jsp" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
   
	<title>Map</title>
	<style type="text/css">
#image-info {
	text-align: left;
	width: 501px;
	float: left;
}

#image-info img {
	width: 16px;
	height: 16px;
	margin-right: 5px;
	margin-left: 5px;
}

.mp-container-fitscreen {
	position: fixed;
	border: 5px solid #ffffff;
	top: 40px !important;
	left: 16%;
	width: 84%;
	height: 550px;
}

.mp-map-wrapper1 {
	width: 99.5%;
	height: 431px;
	position: absolute;
}

.x-table-layout1 td {
	vertical-align: top;
}

.mp-container1 {
	background: #f4f4f4;
	border: 5px solid #fff;
	width: 38%;
	height: 471px;
	position: relative;
	margin: initial;
	left: 60%;
	-moz-box-shadow: 1px 1px 3px #cac4ab;
	-webkit-box-shadow: 1px 1px 3px #cac4ab;
	box-shadow: 1px 1px 3px #cac4ab;
}
.main1 {
width: 101%;
height: 498px;   
float: left;
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}

#allPanels.main3 {
width: 100%;
height: 75px;   
float: left;
margin-left:5px;
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
margin-top : -100px;
}

.mp-vehicle-details-wrapper1 {
width: 40.5%;
height: 550px;
float: right;
background-color: #ffffff;
overflow: auto;
overflow-x: hidden;
}

	.controls {
margin-top: 16px;
border: 1px solid transparent;
border-radius: 2px 0 0 2px;
box-sizing: border-box;
-moz-box-sizing: border-box;
height: 32px;
outline: none;
box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

#pac-input {
background-color: #fff;
padding: 0 11px 0 13px;
width: 304px;
font-family: Roboto;
font-size: 15px;
font-weight: 300;
text-overflow: ellipsis;
}

#pac-input:focus {
border-color: #4d90fe;
margin-left: -1px;
padding-left: 14px; /* Regular padding-left + 1. */
width: 304px;
}

.pac-container {
font-family: Roboto;
}
      .combodiv1{
width:101%;
height:63px;
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}
		.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}
.bodyBackGround{
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
margin-left:0px;
}

#option-fullscreen {
	margin-top:-18px;
}


</style>


		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/mapView/css/component.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/mapView/css/layout.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/layout.css" /> 
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashLogistics/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashLogistics/dashBoard/css/component.css" />
		 <link rel="stylesheet" type="text/css" href="../../Main/modules/cashLogistics/dashBoard/css/style.css" />
		 
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
		
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<pack:script src="../../Main/Js/Common.js"></pack:script>

		<!-- for grid -->
		<pack:script
			src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
		<pack:script src="../../Main/Js/Jquery-min.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
		<pack:style src="../../Main/resources/css/common.css" />
		<pack:style src="../../Main/resources/css/commonnew.css" />
		<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
		<pack:script src="../../Main/Js/examples1.js"></pack:script>
        <pack:style src="../../Main/resources/css/examples1.css" />
		

		<!-- for grid -->
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
    <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	  <script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	  <script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	  <script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	  <script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	  <link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
  crossorigin=""></script>
	<style>
		.mp-container1 {
				left : 62% !important;
		}
		.container {
				padding-right : 0px !important;
				margin-top:-10px;
				margin-left:-14px;
				
		}
		.leaflet-popup {bottom: 25px !important;}

/*.x-panel-bwrap {
	margin-top : -115px !important;
} */
	</style>  
	
	<script src=<%=GoogleApiKey%>></script> 
<!-- <body onload="" class="bodyBackGround" >   -->
		<div class="container">
	
			<div id="vehicletype">
			</div>
			<div class="combodiv1" id="customerIddiv1">
			</div>
	
			<div class="main1" id="customerPanel11">

	</div>
	
	<div id="allPanels" class="main3" >

	</div>
	
	  
				<div class="mp-container1" id="mp-container">
					<div class="mp-map-wrapper1" id="map">
					</div>
					<div class="mp-options-wrapper" />
					
					<div class="mp-option-showhub">
					
						<input type="checkbox" id="c1" name="cc"  onclick='showDetails(this);'/>
						<label for="c1"><span></span></label>
						<span class="vehicle-show-details-block-for-consignment1">Show Details</span>
						
						<img class="for-image" src="/ApplicationImages/VehicleImages/BlueBalloon.png">
            			<label for="c3"><span></span></label>
            			<span class="vehicle-show-details-block-for-cms">Visited</span>
						
						<img class="for-image" src="/ApplicationImages/VehicleImages/PinkBalloon.png">
            			<label for="c2"><span></span></label>
            			<span class="vehicle-show-details-block-for-cms1">Pending</span>
						 
            			
							 
						<div class="mp-option-normal" id="option-normal"
							onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"
							onclick="mapFullScreen()"></div>
					</div>
						</div>
				</div>
		<script>
		var layerGroup;
		var markers = {};
		var infowindows = {};
		var marker;
		var custId = "";
		var map;
		var infowindow;
		var outerPanel;
		var ctsb;
		var exportDataType = "";
		var selected;
		var grid;
		var jspName;
		var buttonValue;
		var titelForInnerPanel;
		var myWin;
		var $mpContainer = $('#mp-container');
		var $mapEl = $('#map');
		var loadMask = new Ext.LoadMask(Ext.getBody(), {
		    msg: "Loading"
		});
		document.getElementById('option-normal').style.display = 'none';
		document.getElementById("vehicletype").value = '<%=vehicleTypeRequest%>';

		function mapFullScreen() {
		    document.getElementById('option-fullscreen').style.display = 'none';
		    document.getElementById('option-normal').style.display = 'block';
		    $mpContainer.removeClass('mp-container-fitscreen');
		    $mpContainer.addClass('mp-container-fullscreen').css({
		        width: 'originalWidth',
		        height: 485
		    });
		    $mapEl.css({
		        width: $mapEl.data('originalWidth'),
		        height: $mapEl.data('originalHeight')
		    });
		    google.maps.event.trigger(map, 'resize');
		}

		function reszieFullScreen() {
		    document.getElementById('option-fullscreen').style.display = 'block';
		    document.getElementById('option-normal').style.display = 'none';
		    $mpContainer.removeClass('mp-container-fitscreen');
		    $mpContainer.removeClass('mp-container-fullscreen');
		    $mpContainer.addClass('mp-container1');
		    $mapEl.css({
		        width: $mapEl.data('originalWidth'),
		        height: $mapEl.data('originalHeight')
		    });
		    google.maps.event.trigger(map, 'resize');
		}
		
			initialize("map",new L.LatLng(<%=latitudeLongitude%>),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
			 layerGroup = new L.LayerGroup().addTo(map);
		    //***********************************Plot Vehicle on Map *******************************************
		function plotSingleVehicle(regNo, latitude, longitude, location, dateTime,speed,category) {
		    if ((category == 'stoppage')) {
		        imageurl = '/ApplicationImages/VehicleImages/red.png';
		    } else if (category == 'idle') {
		        imageurl = '/ApplicationImages/VehicleImages/yellow.png';
		    } else if (category == 'running') {
		        imageurl = '/ApplicationImages/VehicleImages/green.png';
		    } 
		      image = L.icon({
				      iconUrl: imageurl,
				      iconSize: [40,40], // size of the icon
				      popupAnchor: [0, 32]
				  });
		    var pos = new L.LatLng(latitude, longitude);
			marker = new L.Marker(pos,{
				id: regNo,
                icon: image
            });
		    var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden;color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">' + '<table>' + '<tr><td><b>Vehicle No:</b></td><td>' + regNo + '</td></tr>' + '<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' + '<tr><td><b>Date Time:</b></td><td>' + dateTime + '</td></tr>' + '</table>' + '</div>';
		    marker.bindPopup(content).addTo(layerGroup);
		     map.setView(pos,6);
		   // infowindows[regNo]=infowindow;
	   // markers[regNo] = marker;
		  //  marker.setAnimation(google.maps.Animation.DROP);
		}
		
	function plotSingleVehicleForTrips(regNo, latitude, longitude, location, dateTime,speed,category) {
		    if(category == 'Visited')
		    {
		        imageurl = '/ApplicationImages/VehicleImages/BlueBalloon.png';
		    }
		    if(category == 'Pending')
		    {
		        imageurl = '/ApplicationImages/VehicleImages/PinkBalloon.png';
		    }
			 image = L.icon({
				      iconUrl: imageurl,
				      iconSize: [40,40], // size of the icon
				      popupAnchor: [0, 32]
				  });
		    var pos = new L.LatLng(latitude, longitude);
			marker = new L.Marker(pos,{
				id: regNo,
                icon: image
            });
		    var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden;color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">' + '<table>' + '<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' + '</table>' + '</div>';
			 marker.bindPopup(content).addTo(layerGroup);
		      map.setView(pos,6);
		    //infowindows[location]=infowindow;
	   // markers[location] = marker;
		 //   marker.setAnimation(google.maps.Animation.DROP);
		}
		
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
		                store.load({
		        params: {
		            CustId: Ext.getCmp('custcomboId').getValue()
		        },
		        
		    });
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
		            fn: function() {
		                initialize();
		                store.load({
		        params: {
		            CustId: Ext.getCmp('custcomboId').getValue()
		        },
		        
		    });

		    Ext.getCmp('driverNameValueId').setText("");
            Ext.getCmp('empty5').setText("");
            Ext.getCmp('empty13').setText("");
		    Ext.getCmp('empty3').setText("");           
		                
		            }
		        }
		    }
		});
		
	var mapStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getDataForCMSDashBoardMap',
    id: 'allDetailsStoreId',
    root: 'cmsDashboardMapRoot',
    autoLoad: false,
    fields: ['dateTime', 'regNo', 'location', 'speed', 'latitude', 'longitude','category']
});

	 var tripPontsStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripPointsForCmsDasbBooard',
    id: 'allDetailsStoreId',
    root: 'TripPointsForCmsDasbBooardRoot',
    autoLoad: false,
    fields: ['dateTime', 'regNo', 'location', 'speed', 'latitude', 'longitude','category','statusForTripPoints']
});
 
 
  
	     function showDetails(cb)
	    {	
	    if (Ext.getCmp('custcomboId').getValue() == "") {
	    // alert('2');
		        Ext.example.msg('<%=SelectCustomerName%>');
		        Ext.getCmp('custcomboId').focus();
		        return;
		    }
		    
		   // alert(Ext.getCmp('driverNameValueId').getValue());
		 //   if (Ext.getCmp('driverNameValueId').getValue() == "undefined") {
		 //       setMsgBoxStatus('Please Click On Row');
		  //      return;
		 //  }
		    
	    if (grid.getSelectionModel().getCount() == 0) {
		     
		      Ext.example.msg("<%=SelectSingleRow%>");
		      
		        return;
		    }
		    
		    
	    		 var selected = grid.getSelectionModel().getSelected();
		       tripPontsStore.load({
		        params: {
		          tripId: selected.get('tripNumberDataIndex'),
		           custId: Ext.getCmp('custcomboId').getValue()
		            
			        }, 
			        callback: function() {
		            for (var i = 0; i < tripPontsStore.getCount(); i++) {
		                var rec = tripPontsStore.getAt(i);
		                var location= rec.data['location'];
		                //alert(location);
		                infowindowId=rec.data['location'];
		               // alert(infowindowId);
		                
 		                 if(cb.checked)
	    			{
						 
	    			  marker.bindTooltip(infowindowId,{permanent:true,direction: 'top'})	
    	    			//infowindows[infowindowId].open(map, markers[infowindowId]); 
    	    		}else
    	    		{
						 
						 $(".leaflet-tooltip").css("display","none")
    	    			//infowindows[infowindowId].setMap(null);
    	    		}
		            }
		        }
		        
		    });
			
	    }


		var customerinnerPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    frame: false,
		    cls: 'dashboardcustomerinnerpannelForCmsDashBoard',
		    bodyCfg: {
		        cls: 'dashboardcustomerinnerpannelForCmsDashBoard',
		        style: {
		            'background-color': 'transparent'
		        }
		    },
		    id: 'custcomboMaster',
		    layout: 'table',
		    layoutConfig: {
		        columns: 7
		    },
		    items: [{
		            xtype: 'label',
		            text: '<%=CustomerName%>' + ':',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'customerNameId'
		        },
		        custnamecombo, {
		            xtype: 'label',
		            text: '',
		            cls: 'labelstyle',
		            id: 'emptyId12'
		        }
		    ]
		});
		var customerMainPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    frame: false,
		    cls: 'dashboardcustomerpannelForConsignmentPanel',
		    bodyCfg: {
		        cls: 'dashboardcustomerpannelForConsignmentPanel',
		        style: {
		            'background-image': 'url(/ApplicationImages/DashBoard/Box_Blue.png) !important',
		            'background-repeat': 'repeat'
		        }
		    },
		    id: 'custMaster',
		    width:780,
		    items: [customerinnerPanel]
		});
		
		var reader = new Ext.data.JsonReader({
		    idProperty: 'ownMasterid',
		    root: 'cmsDashboardRoot',
		    totalProperty: 'total',
		    fields: [{
		        name: 'slnoIndex'
		    }, {
		        name: 'tripNumberDataIndex'
		    }, {
		        name: 'registrationNumberDataIndex'
		    },{
		        name: 'routeDataIndex'
		    }, {
		        name: 'pointTovisitDataIndex'
		    }, {
		        name: 'startDateAndTimeDataIndex',
		        type: 'date',
                format: getDateTimeFormat()
		    },{
		        name: 'gunman1DataIndex'
		    }, {
		        name: 'gunman2DataIndex'
		    }, {
		        name: 'driverNameDataIndex'
		    }, {
		       name: 'custodianNameDataIndex'
		    }
		    ]
		});
		
		var store = new Ext.data.GroupingStore({
		    autoLoad: false,
		    proxy: new Ext.data.HttpProxy({
		        url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getCMSDashBoardDetails',
		        method: 'POST'
		    }),
		    storeId: 'ownersId',
		    reader: reader
		});
		
		var filters = new Ext.ux.grid.GridFilters({
		    local: true,
		    filters: [{
		        type: 'numeric',
		        dataIndex: 'slnoIndex'
		    }, {
		        type: 'string',
		        dataIndex: 'tripNumberDataIndex'
		    }, {
		        type: 'string',
		        dataIndex: 'registrationNumberDataIndex'
		    }, {
		        type: 'string',
		        dataIndex: 'routeDataIndex'
		    }, {
		        type: 'int',
		        dataIndex: 'pointTovisitDataIndex'
		    }, {
		        type: 'date',
		        dataIndex: 'startDateAndTimeDataIndex'
		    }]
		});
		
		var createColModel = function(finish, start) {
		    var columns = [
		        new Ext.grid.RowNumberer({
		            header: "<span style=font-weight:bold;><%=SLNO%></span>",
		            width: 50
		        }), {
		            dataIndex: 'slnoIndex',
		            hidden: true,
		            header: "<span style=font-weight:bold;><%=SLNO%></span>",
		            //  renderer: myRender,
		            filter: {
		                type: 'numeric'
		            }
		        }, {
		            header: "<span style=font-weight:bold;><%=TripNo%></span>",
		            dataIndex: 'tripNumberDataIndex',
		            width: 100,
		            // renderer: myRender,
		            filter: {
		                type: 'string'
		            }
		        }, {
		            header: "<span style=font-weight:bold;><%=RegistrationNumber%></span>",
		            dataIndex: 'registrationNumberDataIndex',
		            width: 100,
		            border: true,
		            //  renderer: myRender,
		            filter: {
		                type: 'string'
		            }
		        },{
		            header: "<span style=font-weight:bold;><%=Route%></span>",
		            dataIndex: 'routeDataIndex',
		            width: 150,
		            //  renderer: myRender,
		            filter: {
		                type: 'string'
		            }
		        }, {
		            header: "<span style=font-weight:bold;><%=PointsToVisit%></span>",
		            dataIndex: 'pointTovisitDataIndex',
		            width: 50,
		            //   renderer: myRender,
		            filter: {
		                type: 'int'
		            }
		        }, {
		            header: "<span style=font-weight:bold;><%=StartDateTime%></span>",
		            dataIndex: 'startDateAndTimeDataIndex',
		            width: 190,
		            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
		            //   renderer: myRender,
		            filter: {
		                type: 'date'
		            }
		        },{
		            header: "<span style=font-weight:bold;><%=DRIVERNAME%></span>",
		            dataIndex: 'driverNameDataIndex',
		            hidden:true,
		            width: 170,
		            //   renderer: myRender,
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
		
		var myRender = function(value, metaData, record, rowIndex, colIndex, store, view) {
		    // if (parseInt(value) < 0) {
		    metaData.attr = 'style="background-color:MediumSeaGreen;height:30px;"';
		    // }
		    return value
		};
		
		grid = getGrid('', '<%=NoRecordsFound%>', store, 770, 360, 25, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '', false, '', false, '');
		grid.on({
		    "cellclick": {
		        fn: onCellClickOnGrid
		    }
		});
		
		var crewDetailsPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    id: 'crewDetailsPanelId',
		    layout: 'table',
		    frame: true,
		    bodyCfg: {
		         cls: 'dashboardcustomerinnerpannelForCmsDashBoard',
		        style: {
		            'background-color': 'transparent'
		        }
		    },
		    width:391,
		    layoutConfig: {
		        columns: 2
		    },
		    items: [{
		        xtype: 'label',
		        text: '<%=DRIVERNAME%>' + ' :',
		        cls: 'labelstyleForcmsPanelLabels',
		        id: 'driverNameTxtId'
		    }, {
		        xtype: 'label',
		        cls: 'labelForUserInterfaceForConsignment',
		        id: 'driverNameValueId'
		    }
		    ]
		});



     var secondPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    id: 'secondPanelId',
		    layout: 'table',
		    frame: true,
		    bodyCfg: {
		        cls: 'dashboardcustomerinnerpannelForCmsDashBoard',
		        style: {
		            'background-color': 'transparent'
		        }
		    },
		    width:391,
		    layoutConfig: {
		        columns: 2
		    },
		    items: [{
			    xtype: 'label',
		        text: '<%=CUSTODIAN1AND2%>' + ' :',
		        cls: 'labelstyleForcmsPanelLabels',
		        id: 'empty2'
		    }, {
		        xtype: 'label',
		        cls: 'labelForUserInterfaceForConsignment',
		        id: 'empty3'
		    }
		    ]
		});


		var gunManPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    id: 'gunManPanelPanelId',
		    layout: 'table',
		    frame: true,
		    bodyCfg: {
		        cls: 'dashboardcustomerinnerpannelForCmsDashBoard',
		        style: {
		            'background-color': 'transparent'
		        }
		    },
		    width:391,
		    layoutConfig: {
		        columns: 2
		    },
		    items: [{
		        xtype: 'label',
		        text: '<%=GUNMAN1%>' + ' :',
		        cls: 'labelstyleForcmsPanelLabels',
		        id: 'empty4'
		    }, {
		        xtype: 'label',
		        cls: 'labelForUserInterfaceForConsignment',
		        id: 'empty5'
		    }
		    ]
		});	
			
		var gunManPanel2 = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    id: 'gunManPanelPanelId2',
		    layout: 'table',
		    frame: true,
		    bodyCfg: {
		        cls: 'dashboardcustomerinnerpannelForCmsDashBoard',
		        style: {
		            'background-color': 'transparent'
		        }
		    },
		    width:391,
		    layoutConfig: {
		        columns: 2
		    },
		    items: [{
		        xtype: 'label',
		        text: '<%=GUNMAN2%>' + ' :',
		        cls: 'labelstyleForcmsPanelLabels',
		        id: 'empty12'
		    }, {
		        xtype: 'label',
		        cls: 'labelForUserInterfaceForConsignment',
		        id: 'empty13'
		    }
		    ]
		});	

		function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
		//initialize(); 
		layerGroup.clearLayers();
		    if (Ext.getCmp('custcomboId').getValue() == "") {
		       Ext.example.msg("<%=SelectCustomerName%>");
		       Ext.getCmp('custcomboId').focus();
		        return;
		    }
		    if (grid.getSelectionModel().getCount() == 0) {
		    	Ext.example.msg("<%=NoRowSelected%>");
		        return;
		    }
		    if (grid.getSelectionModel().getCount() > 1) {
		    	Ext.example.msg("<%=SelectSingleRow%>");
		        return;
		    }
		     var selected = grid.getSelectionModel().getSelected();
            Ext.getCmp('driverNameValueId').setText(selected.get('driverNameDataIndex'));
            Ext.getCmp('empty5').setText(selected.get('gunman1DataIndex'));
            Ext.getCmp('empty13').setText(selected.get('gunman2DataIndex'));
            Ext.getCmp('empty3').setText(selected.get('custodianNameDataIndex'));
              
            mapStore.load({
		        params: {
		           custId: Ext.getCmp('custcomboId').getValue(),
		            tripId: selected.get('tripNumberDataIndex'),
		            assetNumber :selected.get('registrationNumberDataIndex')
		        },
		        callback: function() {
		            for (var i = 0; i < mapStore.getCount(); i++) {
		                var rec = mapStore.getAt(i);
		                     
 		                  if (rec.data['latitude'] != "0.0" && rec.data['longitude'] != "0.0") {
		                     plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['dateTime'],rec.data['speed'],rec.data['category'])
		                }
		            }
		        }
		    });
		    
		    
		     var selected = grid.getSelectionModel().getSelected();
		       tripPontsStore.load({
		        params: {
		          tripId: selected.get('tripNumberDataIndex'),
		           custId: Ext.getCmp('custcomboId').getValue()
		            
			        }, 
			        callback: function() {
		            for (var i = 0; i < tripPontsStore.getCount(); i++) {
		                var rec = tripPontsStore.getAt(i);
 		                  if (rec.data['latitude'] != "0.0" && rec.data['longitude'] != "0.0") {
		                    plotSingleVehicleForTrips(rec.data['regNo'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['dateTime'],rec.data['speed'],rec.data['category'])
		                }
		            }
		        }
		        
		    });
		}
		
		
		 
		var customerMainPanel11 = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    frame: false,
		    renderTo: 'customerPanel11',
		    cls: 'dashboardcustomerpannelForConsignmentPanel',
		    height: 395,
		    width: 780,
		    id: 'custMaster11',
		    layoutConfig: {
		        columns: 1
		    },
		    items: [grid]
		});
		var customerMainPanel111 = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    frame: false,
		    bodyCfg: {
		        cls: 'dashboardcustomerpannelForConsignmentPanel',
		        style: {}
		    },
		    renderTo: 'allPanels',
		    width: 788,
		    height: 100,
		    id: 'custMaster111',
		    layout:'table',
		    layoutConfig: {
		        columns: 2
		    },
		    items: [crewDetailsPanel,secondPanel,gunManPanel,gunManPanel2]
		});
		customerMainPanel.render('customerIddiv1');
		</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->


