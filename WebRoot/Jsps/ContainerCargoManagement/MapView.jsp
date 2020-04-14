<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	CommonFunctions cf = new CommonFunctions();

		String path = request.getContextPath();
		String basePath = request.getScheme() + "://"+ request.getServerName() + ":"+ request.getServerPort() + path + "/";
		int systemId=Integer.parseInt(request.getParameter("systemId"));
		int customerId=Integer.parseInt(request.getParameter("customerId"));
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setLanguage("en");
		loginInfo.setSystemId(systemId);
		loginInfo.setCustomerId(customerId);
		loginInfo.setZone("A");//B
		loginInfo.setOffsetMinutes(330);
		loginInfo.setCategory("India");
		loginInfo.setCategoryType("South India");
		String vehicleTypeRequest = "all";
		Properties properties = ApplicationListener.prop;
		String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
		session.setAttribute("loginInfoDetails", loginInfo);
%>
<!DOCTYPE html>
<html>
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
	height: 520px;
}

.mp-map-wrapper1 {
	width: 99.5%;
	height: 484px;
	position: absolute;
}

.x-table-layout1 td {
	vertical-align: top;
}

.mp-container1 {
	background: #f4f4f4;
	border: 5px solid #fff;
	width: 76.5%;
	height: 525px;
	position: relative;
	margin: initial;
	right: 0%;
	-moz-box-shadow: 1px 1px 3px #cac4ab;
	-webkit-box-shadow: 1px 1px 3px #cac4ab;
	box-shadow: 1px 1px 3px #cac4ab;
}
</style>

	<head>
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/mapView/css/component.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/mapView/css/layout.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
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
		<pack:script src="../../Main/Js/examples1.js"></pack:script>
        <pack:style src="../../Main/resources/css/examples1.css" />

		<!-- for grid -->
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
	</head>
	<script src=<%=GoogleApiKey%>></script>
	<body oncontextmenu="return false">
		<div class="container">
			<header>
			<div id="vehicletype">
			</div>
			<h1>
				<span>MAPVIEW</span>
			</h1>

			</header>
			<div class="combodiv" id="customerIddiv1">
			</div>
			<div class="main">
				<div class="mp-vehicle-details-wrapper" id="vehicle-details">
					<form class="me-select">
						<ul id="me-select-list">
							<li class="me-select-label">
								<span class="vehicle-details-block-header">Registration
									No </span><span class="vehicle-details-block-sep">:</span>
								<p class="vehicle-details-block" id="asset-no-id"></p>
							</li>
							<li class="me-select-label">
								<span class="vehicle-details-block-header">Location </span><span
									class="vehicle-details-block-sep">:</span><span
									class="vehicle-details-block" id="location-id"></span>
							</li>
							<li class="me-select-label">
								<span class="vehicle-details-block-header">Date Time </span><span
									class="vehicle-details-block-sep">:</span><span
									class="vehicle-details-block" id="gmt-id"></span>
							</li>
							<li class="me-select-label">
								<span class="vehicle-details-block-header">Speed </span><span
									class="vehicle-details-block-sep">:</span><span
									class="vehicle-details-block" id="speed-id"></span>
							</li>
							<li class="me-select-label">
								<span class="vehicle-details-block-header">Ignition</span><span
									class="vehicle-details-block-sep">:</span><span
									class="vehicle-details-block" id="ignition-id"></span>
							</li>
						</ul>
					</form>
				</div>
				<div class="mp-container1" id="mp-container">
					<div class="mp-map-wrapper1" id="map"></div>
					<div class="mp-options-wrapper" />
						<div id="image-info">
							<img id="info" src="/ApplicationImages/VehicleImages/red.png">
							<span style="padding-right: 20px; font-size: 14px;">Vehicle
								Not Moving</span>
							<img class="info"
								src="/ApplicationImages/VehicleImages/green.png">
							<span style="padding-right: 20px; font-size: 14px;">Moving
								Vehicle</span>
							<span style="left: 50px; position: absolute;"></span>
						</div>
						<div class="mp-option-normal" id="option-normal"
							onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"
							onclick="mapFullScreen()"></div>
					</div>
				</div>
			</div>
		</div>
		<script>
		var markers = {};
		var infowindows = {};
		var marker;
		var map;
		var infowindow;
		var mapZoom = 10;
		var $mpContainer = $('#mp-container');
		var $mapEl = $('#map');
		var loadMask = new Ext.LoadMask(Ext.getBody(), {
		    msg: "Loading"
		});
		document.getElementById('option-normal').style.display = 'none';
		document.getElementById("vehicletype").value = '<%=vehicleTypeRequest%>';
		
		
		function mapFullScreen()
		{	
        document.getElementById('option-fullscreen').style.display = 'none';
        document.getElementById('option-normal').style.display = 'block';	
        $mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.addClass('mp-container-fullscreen').css({
						width	: 'originalWidth',
						height	: 'originalHeight'
					});

		
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
					google.maps.event.trigger(map, 'resize');
					
		}
		
		function reszieFullScreen()
		{

		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container1');

		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		google.maps.event.trigger(map, 'resize');
					
		}
		var mapOptions = {
		    zoom: 6,
		    center: new google.maps.LatLng('-1.28', '36.83'),
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		};
		map = new google.maps.Map(document.getElementById('map'), mapOptions);
		
		 //***********************************Plot Vehicle on Map *******************************************
		function plotSingleVehicle(regNo, latitude, longtitude, location, dateTime, category, speed) {
		    if ((category == 'stoppage') || (category == 'idle')) {
		        imageurl = '/ApplicationImages/VehicleImages/red.png';
		    } else {
		        imageurl = '/ApplicationImages/VehicleImages/green.png';
		    }
		    image = {
		        url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
		        size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
		        origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
		        anchor: new google.maps.Point(0, 32)
		    };
		    var pos = new google.maps.LatLng(latitude, longtitude);
		    marker = new google.maps.Marker({
		        position: pos,
		        id: regNo,
		        map: map,
		        icon: image
		    });
		     var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
                '<table>'+
                '<tr><td><b>Vehicle No:</b></td><td>'+regNo+'</td></tr>'+
                '<tr><td><b>Location:</b></td><td>'+location+'</td></tr>'+
                '<tr><td><b>Date Time:</b></td><td>'+dateTime+'</td></tr>'+
                '</table>'+
                '</div>';
                infowindow = new google.maps.InfoWindow({
                content: content,
                maxWidth: 300,
                marker:marker,
                image:image,
                id:regNo
             });

		   // google.maps.event.addDomListener(content, "contextmenu", function(e) {
		   //     e.preventDefault();
		    //    e.stopPropogation();
		   // });
		   
		    var bounds = new google.maps.LatLngBounds(new google.maps.LatLng(latitude, longtitude));
			map.fitBounds(bounds);
		    google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
		        return function() {
		            infowindow.setContent(content);
		            infowindow.open(map, marker);
		        };
		    })(marker, content, infowindow));
		    var listener = google.maps.event.addListener(map, "idle", function() {  		 
	  		if (map.getZoom() > 16) map.setZoom(mapZoom);
	  			google.maps.event.removeListener(listener); 
			});
		    marker.setAnimation(google.maps.Animation.DROP);
		}
		
		var allDetailsStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MapView.do?param=getContainerCargoDetails',
		    id: 'allDetailsStoreId',
		    root: 'DetailsStoreRoot',
		    autoLoad: false,
		    fields: ['regNo', 'location', 'dateTime', 'speed', 'ignition', 'latitude', 'longtitude', 'category', 'ConsignmentNo']
		});
		
		var editInfo1 = new Ext.Button({
		    text: 'View',
		    id: 'submitId',
		    cls: 'buttonStyle',
		    width: 70,
		    handler: function() {
		        map = new google.maps.Map(document.getElementById('map'), mapOptions);
		        
		        if (Ext.getCmp('ContainerNumberTextId').getValue() == "") {
	                Ext.example.msg('Enter Container Number');
		            return;
		        }
		        if (Ext.getCmp('BookingNumberTextId').getValue() == "") {
	                Ext.example.msg('Enter Booking Number');
		            return;
		        }
		        allDetailsStore.load({
		            params: {
		                conNo: Ext.getCmp('ContainerNumberTextId').getValue(),
		                bookingNo: Ext.getCmp('BookingNumberTextId').getValue()
		            },
		            callback: function() {
		                var rec = allDetailsStore.getAt(0);
		                
		                document.getElementById('asset-no-id').innerHTML = rec.data['regNo'];
		                document.getElementById('location-id').innerHTML = rec.data['location'];
		                document.getElementById('gmt-id').innerHTML = rec.data['dateTime'];
		                document.getElementById('speed-id').innerHTML = rec.data['speed'];
		                document.getElementById('ignition-id').innerHTML = rec.data['ignition'];
		                registrationNo = rec.data['regNo'];
		                if(registrationNo=="")
		                {
		                   Ext.example.msg('Consignment Number Is Incorrect / Vehicle Not Found');
		                   return;
		                }
		                if(!rec.data['latitude']==0 && !rec.data['longtitude']==0)
                          {
 		                      plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['category'], rec.data['speed'])
 		                  }
                       
		            }
		        });
		    }
		});
		
		Ext.Ajax.timeout = 360000;
		var outerPanel = new Ext.Panel({
		    //renderTo: 'content',
		    standardSubmit: true,
		    frame: true,
		    height: 50,
		    //cls: 'mainpanelpercentage',
		    layout: 'table',
		    layoutConfig: {
		        columns: 7
		    },
		    items: [{
		            xtype: 'label',
		            text: 'Consignment Number' + ':',
		            cls: 'labelstyle',
		            id: 'consignmentNumberId'
		        }, {
		            xtype: 'textfield',
		            cls: '.x-table-layout1 td',
		            id: 'BookingNumberTextId',
		            emptyText: 'Enter Booking Number'
		        }, {
		            width: 70
		        }, {
		            xtype: 'textfield',
		            cls: '.x-table-layout1 td',
		            id: 'ContainerNumberTextId',
		            emptyText: 'Enter Container Number'
		        }, {
		            width: 70
		        },
		        editInfo1
		    ]
		});
		outerPanel.render('customerIddiv1');
		</script>
	</body>
</html>


