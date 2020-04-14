<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
    <%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
 	
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	String systemID = Integer.toString(systemid);
 	int customeridlogged = loginInfo.getCustomerId();
 	String customernamelogged = "null";
 	String locationName="";
 	String latitude="";
 	String longitude="";
 	String vehicleNo = "";
 	String gmttime="";
 	if (request.getParameter("vehicleNo") != null) {
 		vehicleNo = request.getParameter("vehicleNo");
 		ArrayList arrayList=cf.getLocationLatLong(vehicleNo);
 		if(arrayList!=null)
 		{
 		longitude=(String)arrayList.get(0);
 		latitude=(String)arrayList.get(1);
 		locationName=(String)arrayList.get(2);
 		gmttime=(String)arrayList.get(3);
 		}
 	}
 	if (customeridlogged > 0) {
 		customernamelogged = loginInfo.getCustomerName();
 	}
 	int userId = loginInfo.getUserId();
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	
 	String Location="Location";
 	String Latitude="Latitude";
 	String Longitude="Longitude";
 	String WorkLocationDetails="Work Location Details";
 %>
 <!DOCTYPE html>
<html>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">

<title>Map</title>

<head>
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/mapView/css/component1.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/mapView/css/layout1.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
    <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
    <pack:script src="../../Main/Js/Common.js"></pack:script>

    <!-- for grid -->
    <pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
    <pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
    <pack:script src="../../Main/Js/Jquery-min.js"></pack:script>
    <pack:style src="../../Main/resources/css/ext-all.css" />
    <pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
    <pack:style src="../../Main/resources/css/common.css" />
    <pack:style src="../../Main/resources/css/commonnew.css" />
    <pack:script src="../../Main/Js/examples1.js"></pack:script>
    <pack:style src="../../Main/resources/css/examples1.css" />

    <!-- for grid -->
    <pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
    <pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
</head>
<style>
    #pac-input {
        background-color: #fff;
        padding: 0 11px 0 13px;
        width: 400px;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        text-overflow: ellipsis;
    }
    .controls {
        margin-top: 6px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 32px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
    }
    body {
        background-color: #FFFFFF;
    }
    html {
        overflow-x: hidden;
        overflow-y: hidden;
    }
    .x-panel-header {
        height: 40px !important;
    }
    .x-panel-body {
        margin-top: 10px;
    }
    .x-panel-footer {
        padding: 0px;
    }
    #locationLabelId2 {
        margin-left: 8px;
    }
    #latitudeLabelId2 {
        margin-left: 10px;
    }
</style>
<script src=<%=GoogleApiKey%>></script> 

<body onload="refresh();">
    <div class="container">
        <div class="main">
            <div class="mp-container" id="mp-container">
                <div class="mp-map-wrapper" id="map"></div>
                    <input id="pac-input" class="controls" type="text" placeholder="Search Places">
               
            </div>
        </div>
    </div>
    <script>
        var markers = {};
        var outerPanel;
       var infowindow;
       var content;
        var tsb;
        var marker;
        var mapOptions = {
            zoom: 2,
            center: new google.maps.LatLng('0.0', '0.0'),
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var LatLng = new google.maps.LatLng('0.0', '0.0');
        var map = new google.maps.Map(document.getElementById('map'), mapOptions);
        var input = (document.getElementById('pac-input'));
        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);
        var searchBox = new google.maps.places.SearchBox(input);
        google.maps.event.addListener(searchBox, 'places_changed', function() {
            var places = searchBox.getPlaces();
            if (places.length == 0) {
                return;
            }
            for (var i = 0, marker; marker = markers[i]; i++) {
                marker.setMap(null);
            }
            markers1 = [];
            var bounds = new google.maps.LatLngBounds();
            for (var i = 0, place; place = places[i]; i++) {
                var image = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25)
                };
                bounds.extend(place.geometry.location);
            }
            map.fitBounds(bounds);
            if (map.getZoom() > 16) map.setZoom(15);

        });
        google.maps.event.addListener(map, 'bounds_changed', function() {
            var bounds = map.getBounds();
            searchBox.setBounds(bounds);
        });
      
           
        
        
        
function initialize(latitude, longitude) {
           
            var LatLng1 = new google.maps.LatLng(latitude, longitude);
             if (marker != null) {
                marker.setMap(null);
            }
               image = {
                url: '/ApplicationImages/VehicleImages/red.png',
                size: new google.maps.Size(48, 48)
            };
                marker = new google.maps.Marker({
                position: LatLng1,
                map: map,
                icon: image
            });
            map.setZoom(10);
            map.panTo(marker.position);
            var vehicleNo='<%=vehicleNo%>';
            var locationName='<%=locationName%>';
            var gmttime='<%=gmttime%>';
            content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:13px; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td style=" width: 75px; "><b>Vehicle No:</b></td><td>'+vehicleNo+'</td></tr>'+
			'<tr><td><b>Location:</b></td><td>'+locationName+'</td></tr>'+
			'<tr><td><b>Date Time:</b></td><td>'+gmttime+'</td></tr>'+
			'</table>'+
			'</div>';
		
		infowindow = new google.maps.InfoWindow({
      		content: content,
      		marker:marker,
      		maxWidth: 300,
      		image:image,
      		id:vehicleNo
  		 });
  		 google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){ 
    			return function() {
    		infowindow.setContent(content);
        	infowindow.open(map,marker);
        			         			
    			};
		 })(marker,content,infowindow)); 
  		 infowindow.setContent(content);
         infowindow.open(map,marker);
        }
        
 function refresh()
 {
 initialize('<%=latitude%>','<%=longitude%>');
 }
 
    
       
    </script>
</body>

</html>          