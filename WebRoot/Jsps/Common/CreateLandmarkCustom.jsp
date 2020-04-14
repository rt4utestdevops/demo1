<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	String responseaftersubmit = "''";
	if (session.getAttribute("responseaftersubmit") != null) {
		responseaftersubmit = "'"
				+ session.getAttribute("responseaftersubmit")
						.toString() + "'";
		session.setAttribute("responseaftersubmit", null);
	}
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	String GetStandardFormat = "Get Standard Format";
	String SLNO = "SLNO";
	String hubName = "HubName";
	String radius = "Radius";
	String latitude = "Latitude";
	String longitude = "Longitude";
	String offset = "Offset";
	String city = "City";
	String state = "State";
	String country = "Country";
	String geoFence = "Geo Fence";
	String stdDuration = "Standard Duration";
	String Remarks = "Remarks";
	String NoRecordsFound = "No Records Found";
	String Save = "Save";
	String Clear = "Clear";
	String Close = "Close";

		
	String language = loginInfo.getLanguage();
	List valid = new ArrayList();
	//getting client id
	int customeridlogged = loginInfo.getCustomerId();
	int systemId = loginInfo.getSystemId();
	int userId=loginInfo.getUserId();
	int countryId = loginInfo.getCountryCode();
	String countryName ="";// cf.getCountryName(countryId);
	String vehicle = "";
	String hubId = null;
	String isModify = null;
	String custId = null;
	String id = null;
	String custName = "";
	boolean fromLiveUpdate = false;
	double lat = 0;
	double lon = 0;
	String userAuthority=cf.getUserAuthority(systemId,userId);	
	double Convertionsfactor= cf.getUnitOfMeasureConvertionsfactor(systemId);
	System.out.println("Convertionsfactor in Createlandmark.jsp : "+Convertionsfactor);
	Convertionsfactor = 1000/Convertionsfactor;
	System.out.println(systemId+userAuthority);
	if(systemId==15 && !userAuthority.equalsIgnoreCase("Admin") && loginInfo.getIsLtsp()==0){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
	}
	
	System.out.println("222"+systemId+loginInfo.getIsLtsp());
	if(systemId==15 && loginInfo.getIsLtsp() == -1){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
	}
	if (request.getParameter("vehicle") != null
			&& !request.getParameter("vehicle").equals("")) {
		vehicle = request.getParameter("vehicle");
		
		fromLiveUpdate = true;
		if (request.getParameter("lat") != null
				&& request.getParameter("lon") != null) {
			lat = Double.parseDouble(request.getParameter("lat")
					.toString());
			lon = Double.parseDouble(request.getParameter("lon")
					.toString());
		}
	}
	String ipVal = request.getParameter("ipVal");
	if (request.getParameter("hubId") != null
			&& !request.getParameter("hubId").equals("")) {
		hubId = request.getParameter("hubId");
		id = request.getParameter("id");
		isModify = request.getParameter("isModify");
		custId = request.getParameter("custId");
	}
	if (request.getParameter("custName") != null
			&& !request.getParameter("custName").equals("")) {
		String name = request.getParameter("custName");
		String cname[] = name.split("@");
		for (int i = 0; i < cname.length; i++) {
			custName = custName + cname[i] + " ";

		}
	}
	String distUnits = cf.getUnitOfMeasure(systemId);
	String latitudeLongitude = cf.getCoordinates(systemId);
	Properties properties = ApplicationListener.prop;
	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	String GoogleAPIKEY = GoogleApiKey + "&libraries=places,drawing";
	
	MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
	String mapName = bean.getMapName();
	String appKey = bean.getAPIKey();
	String appCode = bean.getAppCode();
	
%>

 <jsp:include page="../Common/header.jsp" />    
 <jsp:include page="../Common/InitializeLeaflet.jsp" />
	<title>Location Grabber</title>	
	
	  <link href="https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/master/leaflet.css" rel="stylesheet" type="text/css" />
	  <script src="https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/master/leaflet.js"></script>
	  <script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	  <script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css" />
      <script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>
	  <script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	  <script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	  <link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
  crossorigin=""></script>
	  
	 
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.4.2/leaflet.draw.css"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.4.2/leaflet.draw.js"></script>
	
	<style>
		/*
		 * FileUploadField component styles
		 */
		.x-form-file-wrap {
		    position: relative;
		    height: 22px;
		}
		.x-form-file-wrap .x-form-file {
			position: absolute;
			right: 0;
			-moz-opacity: 0;
			filter:alpha(opacity: 0);
			opacity: 0;
			z-index: 2;
		    height: 22px;
		}
		.x-form-file-wrap .x-form-file-btn {
			position: absolute;
			right: 0;
			z-index: 1;
		}
		.x-form-file-wrap .x-form-file-text {
		    position: absolute;
		    left: 0;
		    z-index: 3;
		    color: #777;
		}
		.bskExtStyle{
			display:block;
	  		font-size:12px;
	  		font-family: sans-serif;
		}
        .upload-icon {
            background: url('../shared/icons/fam/image_add.png') no-repeat 0 0 !important;
        }
        
        .tripimportimagepanel{
			width: 90%;
			height: 140px;
			background-image:url(/ApplicationImages/ExcelImportFormats/locationDetailsExcelFormat.png);
			background-repeat: no-repeat;
		}
		#target{
	          display: inline-block;
	          padding: 6px 12px;
	          font-size: 14px;
	          line-height: 1.428571429;
	          color: #555;
	          vertical-align: middle;
	          background-color: #fff;
	          background-image: none;
	          border: 1px solid black;
	          border-radius: 4px;
	          -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	          box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	          -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	      }
	      .x-form-check-wrap{
	      	width:123px !important;
	      }
	      .x-panel-body x-panel-body-noheader x-form x-table-layout-ct{
	      	width: 291px !important;
	      	height: 492px !important;
	      }
        label {
   		 margin-bottom: .5rem !impotant;
   		 display: inline !important;
		}
		.leaflet-marker-icon leaflet-div-icon leaflet-editing-icon leaflet-edit-move leaflet-touch-icon leaflet-zoom-animated leaflet-interactive leaflet-marker-draggable {
			height:8px;
			width:8px;
		}
	  </style>
	<style>
	.x-panel-tl
	{
		border-bottom: 1px solid !important;
	}
	.x-panel-header-text{
		font-family: 'Cambria';
		text-align: center;
	}
	.labelstyleNew {
	spacing: 10px;
	height: 20px;
	width: 150 px !important;
	min-width: 150px !important;
	font-size: 12px;
	font-family: sans-serif;
	margin: 10px 15px 15px 15px !important;
}
.ext-strict .x-form-text {
    height: 21px !important;
}
.x-window-tl *.x-window-header {
			padding-top : 6px !important;
			height : 38px !important;
		}
		importClass {
		 	min-height:24px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		.x-window-body {
   			 overflow : overlay !important;
		}
		#polygonButtonId {
            margin-top : -6px !important;
            margin-left: 7px !important;
        }
        #kmlLoctypeLabelId {
            margin-top : -6px !important;
        }
	</style>
	<%
   		if (loginInfo.getStyleSheetOverride().equals("Y")) {
   	%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%
		} else {
	%>
	<jsp:include page="../Common/ImportJS.jsp" /><%
		}
	%>
 	
<font color="#ffff00">
	<script>
	var innerpage=<%=ipVal%>;
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
			
	var pageName='Create Landmark';
	var map;
	var isIE = false;
	var drawingManager;
	var markers = null;
	var pointer = null;
	var circles = null;
	var polygons = null;
	var circlesPlot = [];
	var latitude = [];
	var longitude = [];
	var latitudePolygon = [];
    var longitudePolygon = [];
	var buffermarkers = [];
    var polygonsPlot = [];
    var polygonmarkers = [];
    var borderPolylines = [];
    var isModify = null;
    var countryName = '<%=countryName%>';
	var fromLiveUpdate = <%=fromLiveUpdate%>;
	var modifyStore ;
	var customer = 0;
	var polygonNew;
	var drawingarray=[];
	var mode;
	var markerArray=[];
	var circleArray=[];
	var polyArray=[];
	var countryNew='<%=countryId%>';
	var hhmmpattern = /^([01]\d|2[0-3]):?([0-5]\d)$/;
	isIE = /*@cc_on!@*/false || !!document.documentMode;
	var newPincode ="";
	var kmlCoOrdsArray=[];
	var plotPolygonKML;
	var marker;
	var polygonCustomCreation;
	function initializeStore(){
	        
       if(fromLiveUpdate){
	      	var lat = '<%=lat%>';
	      	var lon = '<%=lon%>';
	      	var position = new L.LatLng(lat,lon);
	      	var markr = new L.Marker(position).addTo(map);
			bounds = new L.LatLngBounds(position);
   	        map.fitBounds(bounds);
   	        map.setZoom(16);
         	Ext.getCmp('saveLabelId').enable();
			Ext.getCmp('latitudeTextId').setValue(lat);
			Ext.getCmp('longitudeTextId').setValue(lon);
	     }
        tripCustomerCombostore.load();				
	}
	    function clearMap(){
			
		var layers = map._layers;
		     clearMarkers();
		}      
		function clearMarkers(){
			for (var i = 0; i < markerArray.length; i++) {
				map.removeLayer(markerArray[i]);
			}
			for(var i = 0; i < circleArray.length; i++){
				map.removeLayer(circleArray[i]);
			}
			for(var i = 0; i < polyArray.length; i++){
				map.removeLayer(polyArray[i]);
			}
		}
	        
			
       function loadMap() {
       clearMap();
        
	  		var type = Ext.getCmp('loccomboId').value;
			
			//map.addControl(drawingManager);
           var dmodes;
		   if(type==1){
			   dmodes='Circle';
		   }else if(type==3){
			   dmodes='Polygon';
		   }else{
			   dmodes='Point';
		   }
		   setDrawingTools(dmodes);
           // if(type==1){
           		// var circleDrawer = new L.Draw.Circle(map);
		  		// circleDrawer.enable();
           		// dmodes='circle';
           		// document.getElementById('noteId').innerHTML = 'Please select the circle symbol, click on map and drag it.To resize the hub drag the circles on the boundary.To move the circle, drag the circle in the center to the desired position.';
				// drawingManager.options.draw.marker = false;
				// drawingManager.options.draw.circle = true;
				// drawingManager.options.draw.polygon = false;
				// map.addControl(drawingManager);
				// Ext.getCmp('saveLabelId').enable();
				// Ext.getCmp('radiusTextId').enable();
				// Ext.getCmp('radiusButtonId').enable();
				
				
           // }else if(type==3){
           		// var polygonDrawer = new L.Draw.Polygon(map);
		  		// polygonDrawer.enable();
           		// dmodes='polygon';           		
           		// document.getElementById('noteId').innerHTML = 'Please select the polygon symbol,click on map to draw the polygon.Click on start point to close the polygon.'
           		// +'To resize the hub drag the circles on the boundary';
				// drawingManager.options.draw.marker = false;
				// drawingManager.options.draw.circle = false;
				// drawingManager.options.draw.polygon = true;
				// map.addControl(drawingManager);
           // }else{
           		// var markerDrawer = new L.Draw.Marker(map);
		  		// markerDrawer.enable();
           		// dmodes='marker';           
           		// document.getElementById('noteId').innerHTML = 'Please click on the balloon symbol and then on the map to create the marker.Drag the marker to change the location.';
				// drawingManager.options.draw.marker = true;
				// drawingManager.options.draw.circle = false;
				// drawingManager.options.draw.polygon = false;
				// map.addControl(drawingManager);
           // }
         drawingarray.push(drawingManager);
         //map.on('draw:created', function (e) {
		 map.on(L.Draw.Event.CREATED, function (e) {
         	e.layer.options.draggable = true;
		    var type = e.layerType,
		    layer = e.layer;
			//drawnItems.addLayer(layer);
		    
		    alert(type);
			map.addLayer(layer);
			clearMap();
			
		    if (type === 'marker') {
				console.log(e);
		    	//alert('marker plotted');
		    	//alert(e.layer._latlng.lng + ','+ e.layer._latlng.lat);
		    	
		    	if(Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value== undefined)
		         {
		         	map.removeLayer(marker);
		         	Ext.example.msg("Select Hub/POI Type");
		         	Ext.getCmp('loccomboId').focus();
		         	return;
		         }
		         Ext.getCmp('saveLabelId').enable();
				 Lat = layer._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = layer._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,type);
				 layer.on('dragend',function(e) {
					 alert("drag done");
	
					Lat = e.target._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = e.target._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,'marker');
				}.bind(this));
				
			map.on('click', function(e) {    
				console.log('marker click:: ',e);
				map.removeLayer(layer);				
				if(Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value== undefined)
				 {
					map.removeLayer(marker);
					Ext.example.msg("Select Hub/POI Type");
					Ext.getCmp('loccomboId').focus();
					return;
				 } else {
					 if(marker!=null){
						 map.removeLayer(marker);
					 }
					
					marker = new L.marker(e.latlng).addTo(map);
					markerArray.push(marker);
					Lat = e.latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = e.latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					//geocodeLatLng(Lat,Lng,'marker');
				}  
			});
		    }else  if (type === 'circle') {
				var circle;
				console.log(e);
		    	alert('circle drawn');
		    	//circle.editing.enable();
		    	alert(e.layer._latlng.lng + ','+ e.layer._latlng.lat);
		    	
		    	if(Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value== undefined)
		         {
		      //   	map.removeLayer(circle);
		         	Ext.example.msg("Select Hub/POI Type");
		         	Ext.getCmp('loccomboId').focus();
		         	return;
		         }
		         Ext.getCmp('saveLabelId').enable();
				 circle = layer;
				 circles = circle;
				 circleArray.push(circle);
					
					Lat = layer._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = layer._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,type);
					var geoFenceId = Ext.getCmp('geofencecomboId').getValue();
					if(geoFenceId == 999) {
					Ext.getCmp('radiusTextId').setValue('30.00');
				        }else {
					Ext.getCmp('radiusTextId').setValue(circle.getRadius()/<%=Convertionsfactor%>);
				    }  
					 
				 e.layer.on('dragend',function(e) {
					 alert("dragend");
					Lat = e.target._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = e.target._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,'circle');
						
				}.bind(this));
				

		    }else  if (type === 'polygon') {
				console.log(e);
		    	alert('poly drawn');
		    	var polygon; 
		    	if(Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value== undefined)
		         {
		           	Ext.example.msg("Select Hub/POI Type");
		         	Ext.getCmp('loccomboId').focus();
		         	return;
		         }
		         Ext.getCmp('saveLabelId').enable();
				  polygon = layer;
			      polyArray.push(polygon);
				Lat = polygon._latlngs[0][0].lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
				Lng = polygon._latlngs[0][0].lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
				console.log('drag :: '+Lat+','+Lng);
				//geocodeLatLng(Lat,Lng,type);
				 e.layer.on('dragend',function(e) {
					 console.log(e);
					Lat = e.target._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = e.target._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,'polygon');
					
				}.bind(this));
			  }
		    
		});
	    map.on('draw:edited', function (e) {
		    var layers = e.layers;
		    layers.eachLayer(function (layer) {
		        if (layer instanceof L.Marker){
		            alert('marker edited');
					Lat = layer._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = layer._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,'marker');
		        }
		        if (layer instanceof L.Circle){
		           Lat = layer._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = layer._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,'circle');
					var geoFenceId = Ext.getCmp('geofencecomboId').getValue();
					if(geoFenceId == 999) {
					Ext.getCmp('radiusTextId').setValue('30.00');
				        }else {
					Ext.getCmp('radiusTextId').setValue(layer.getRadius()/<%=Convertionsfactor%>);
				    }  
		        }
		        if (layer instanceof L.Polygon){
		            Lat = layer._latlng.lat.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					Lng = layer._latlng.lng.toString();//.replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					console.log('drag :: '+Lat+','+Lng);
					//geocodeLatLng(Lat,Lng,'marker');
		        }
		    });
		});
/*          google.maps.event.addListener(drawingManager, 'markercomplete', function (marker) {
         
        google.maps.event.addListener(marker, 'dragend', function () {  
            
                var objLatLng = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
                Lat = objLatLng[0];
                Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
                Lng = objLatLng[1];
                Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
				geocodeLatLng(Lat,Lng,'marker');
        });
        
        google.maps.event.addListener(map, 'click', function (event) {
	        if(Ext.getCmp('loccomboId').value == null || Ext.getCmp('loccomboId').value == '' || Ext.getCmp('loccomboId').value== undefined)
	         {
	         	marker.setMap(null);
	         	Ext.example.msg("Select Hub/POI Type");
	         	Ext.getCmp('loccomboId').focus();
	         	return;
	         } else {
						marker.setPosition(event.latLng);
	                	Lat = event.latLng.lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
	               	 	Lng = event.latLng.lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
						geocodeLatLng(Lat,Lng,'marker');
					}
        });
        
        drawingManager.setOptions({ drawingControl: false });
        drawingManager.setDrawingMode(null);
        var objLatLng = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
        Lat = objLatLng[0];
        Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
        Lng = objLatLng[1];
        Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1").trim();// Set 5 Digits after comma
		geocodeLatLng(Lat,Lng,'marker');
    }); */
    
    
    //circle
/*     google.maps.event.addListener(drawingManager, 'circlecomplete', function (circle) {
    	Ext.getCmp('saveLabelId').enable();
    	Ext.getCmp('radiusTextId').enable();
    	Ext.getCmp('radiusButtonId').enable();
    	circles = circle; 
    	var geoFenceId = Ext.getCmp('geofencecomboId').getValue();
        if(geoFenceId == 999) {
    		Ext.getCmp('radiusTextId').setValue('30.00');
    	}else {
    		Ext.getCmp('radiusTextId').setValue(circle.getRadius()/<%=Convertionsfactor%>);
    	}  
		geocodeLatLng(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"),circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"),'drag');
    	drawingManager.setOptions({ drawingControl: false });
        drawingManager.setDrawingMode(null);
        circleArray.push(circles);
        google.maps.event.addListener(circle, 'radius_changed', function () {            		    
    		Ext.getCmp('radiusTextId').setValue(circle.getRadius()/<%=Convertionsfactor%>);
    		Ext.getCmp('latitudeTextId').setValue(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
			Ext.getCmp('longitudeTextId').setValue(circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
			geocodeLatLng(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"),circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"),'drag');
  		});
  		
  		google.maps.event.addListener(circle, 'center_changed', function () {  		   
  			Ext.getCmp('radiusTextId').setValue(circle.getRadius()/<%=Convertionsfactor%>);  			
    		Ext.getCmp('latitudeTextId').setValue(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
			Ext.getCmp('longitudeTextId').setValue(circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
			geocodeLatLng(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"),circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"),'drag');
  			var pos = new google.maps.LatLng(document.getElementById('latitudeTextId').value,document.getElementById('longitudeTextId').value);
  			if(markers==null){
       		 	if(pointer!=null){
       		 		pointer.setPosition(pos);
       	 		}
       		}else{
       			markers.setPosition(pos);
       		}
  		});
        
     }); */
/* 	 	google.maps.event.addListener(drawingManager, 'polygoncomplete', function (polygon) {
	 	
	 		polygons = polygon;
	 		Ext.getCmp('saveLabelId').enable();
			var polygonBounds = polygon.getPath();
			latitude = [];
	        longitude = [];
			for(var i = 0 ; i < polygonBounds.length ; i++)
    		{
        		latitude.push(polygonBounds.getAt(i).lat());
        		longitude.push(polygonBounds.getAt(i).lng());
        	
        		//no markers exist, so adding a InfoWindow without marker
        		google.maps.event.addListener(polygon,'click', showInfoWindow);
        		
    		}
			geocodeLatLng(polygonBounds.getAt(0).lat(),polygonBounds.getAt(0).lng(),'drag');
			polygon.setOptions({
            	editable: true
        	});
			
			drawingManager.setOptions({ drawingControl: false });
        	drawingManager.setDrawingMode(null);
     		polyArray.push(polygon);
	       function showInfoWindow(event) {
	        var contentString = '<b>Latitude: </b>' + event.latLng.lat() +'<br>' +
	            '<b>Longitude: </b>' + event.latLng.lng();
	        infoWindow.setContent(contentString);
	        infoWindow.open(map);
	       	infoWindow.setPosition(event.latLng);
	      }
        	
        	google.maps.event.addListener(polygon.getPath(),'set_at',function () {
				latitude = [];
	  		    longitude = [];
	  		    
				var len = polygon.getPath().getLength();
	  			for(var i=0;i<len;i++){
	  				latitude.push(polygon.getPath().getAt(i).lat());
        			longitude.push(polygon.getPath().getAt(i).lng());
	  			}
	  			geocodeLatLng(polygon.getPath().getAt(0).lat(),polygon.getPath().getAt(0).lng(),'drag');
	  		});
	  		google.maps.event.addListener(polygon.getPath(), 'insert_at', function() {
	  		    latitude = [];
	  		    longitude = [];
	  			var len = polygon.getPath().getLength();
	  			for(var i=0;i<len;i++){
	  				latitude.push(polygon.getPath().getAt(i).lat());
        			longitude.push(polygon.getPath().getAt(i).lng());
	  			} 
	  		});
	  		
	  	}); */
    }
       function setLatLng(){
			if(document.getElementById('latitudeTextId').value==''){
				Ext.example.msg("Select Latitude");
				document.getElementById('latitudeTextId').focus();
			}else if(document.getElementById('longitudeTextId').value==''){
				Ext.example.msg("Select Longitude");
				document.getElementById('longitudeTextId').focus();
			}else{
       			var pos = new L.LatLng(document.getElementById('latitudeTextId').value,document.getElementById('longitudeTextId').value);
       			alert();
       			if(markers==null){
       		 		if(pointer!=null){
       					pointer.setMap(null);
       					if(Ext.getCmp('radiusTextId').value!=''){
       						circles.setCenter(pos);
       					}
       	 			}
       				pointer = new google.maps.Marker({
          					 position: pos,
          					 map: map
        			});
       			}else{
       				markers.setPosition(pos);
       				if(Ext.getCmp('radiusTextId').value!=''){
       					map.removeLayer(markers);
       					circles.setView(pos);
       				}
       			}
       			map.setView(pos);
       	   }
       	   
       }
       
   
       
  function loadKMLCoordinatesToArray(responseObject)
	{
		var i;
		var jsonArray=Ext.util.JSON.decode(responseObject.kmlArray);
		for(i=0;i<jsonArray.length;i++)
		{
		  latitude.push(parseFloat(jsonArray[i].Latitude));
		  longitude.push(parseFloat(jsonArray[i].Longitude));
		  kmlCoOrdsArray.push({lat:parseFloat(jsonArray[i].Latitude),lng:parseFloat(jsonArray[i].Longitude)});
		}
    }
	
	 
       
       function setCircleRadius(){
       	    var radius = Ext.getCmp('radiusTextId').value*<%=Convertionsfactor%>;
       		circles.setRadius(radius);
       }
      

var drawControl;
    window.onload = function () { 
		initializeStore();
		initialize("map-canvas",new L.LatLng(<%=latitudeLongitude%>),'<%=mapName%>','<%=appKey%>','<%=appCode%>');
		
	 drawControl = new L.Control.Draw({
     draw : {
       position : 'topleft',
       polygon : false,
       polyline : false,
       rectangle : false,
       circle : false

   },
   edit : false
   });
     map.addControl(drawControl);
	}
function setDrawingTools(layerType) {

   map.removeControl(drawControl);

   if (layerType == 'Polygon') {
alert();
       drawControl = new L.Control.Draw({
           draw : {
               position : 'topleft',
               polygon : {
                   title : 'Draw a sexy polygon!',
                   allowIntersection : false,
                   drawError : {
                       color : '#b00b00',
                       timeout : 1000
                   },
                   shapeOptions : {
                       color : '#bada55'
                   },
                   showArea : true
               },
               polyline : false,
               rectangle : false,
               circle : false,
               marker : false
           },
           edit : false
       });
   } else if (layerType == 'Circle') {

       drawControl = new L.Control.Draw({
           draw : {
               position : 'topleft',
               polygon : false,
               polyline : {
                   metric : false
               },
               rectangle : false,
               circle : true,
               marker : false
           },
           edit : false
       });
   } else if (layerType == 'Point') {

       drawControl = new L.Control.Draw({
           draw : {
               position : 'topleft',
               polygon : false,
               polyline : false,
               rectangle : false,
               circle : false

           },
           edit : false
       });

   }
   map.addControl(drawControl);
}
   /*******************resize window event function**********************/
	Ext.EventManager.onWindowResize(function () {
		var width = '100%';
		var height = '100%';
		outerPanel.setSize(width, height);
		outerPanel.doLayout();
	});
  /*******************End of resize window event function**********************/
 
 	var outerPanel;
 	var informationPanel;
 	var mapPannel;
 	var infoWindow = null;
  	
 	var countrystore= new Ext.data.JsonStore({
            url:'<%=request.getContextPath()%>/CustomerAction.do?param=getCountryList',
                   id:'CountryStoreId',
                   root: 'CountryRoot',
                   autoLoad: true,
                   fields: ['CountryID','CountryName','Offset']
    });
 	
 	var countryCombo = new Ext.form.ComboBox({
        				   store: countrystore,
        				   id: 'countrycomboId',
        				   mode: 'local',
        				   forceSelection: true,
        				   emptyText: 'Select Country',
        				   selectOnFocus: true,
        				   allowBlank: false,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   valueField: 'CountryID',
        				   width: 170,
        				   displayField: 'CountryName',
        				   cls: 'selectstylePerfect',
        				   value: '<%=countryName%>',
        				   listeners: {
            				   			select: {
                							fn: function() {
                							var countryID=Ext.getCmp('countrycomboId').getValue();
                							Ext.getCmp('statecomboId').setValue('');
                							countryNew=countryID;
                							    statestore.load({
							                 	   params:{
							                 	  	countryId:countryID
							                 	  }
									            });
									            var country = countrystore.find('CountryID', countryID);
			                                    if(country >= 0)
			                                    {
			                                     var record = countrystore.getAt(country);
			                                     Ext.getCmp('gmtTextId').setValue(record.data['Offset']);
			                                    }else
			                                    {
			                                     Ext.getCmp('gmtTextId').setValue('');
			                                    }
					                		}
            							}
        					}
    				  });
    				  
	var statestore= new Ext.data.JsonStore({
            url:'<%=request.getContextPath()%>/CustomerAction.do?param=getStateList',
                   id:'StateStoreId',
                   root: 'StateRoot',
                   autoLoad: false,
                   fields: ['StateID','StateName','Region']
    });
 	
 	var stateCombo = new Ext.form.ComboBox({
        				   store: statestore,
        				   id: 'statecomboId',
        				   mode: 'local',
        				   forceSelection: true,
        				   emptyText: 'Select State',
        				   selectOnFocus: true,
        				   allowBlank: false,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   valueField: 'StateID',
        				   width: 170,
        				   displayField: 'StateName',
        				   cls: 'selectstylePerfect',
        				   listeners: {
            				   			select: {
                							fn: function() {
                    							
					                		}
            							}
        					}
    				  });    
    				  
    				   statestore.load({
	                	   params:{
	                	  	countryId:'<%=countryId%>'
	                	  }
		            });
    				  
	var clientcombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
       id: 'CustomerStoreId',
       root: 'CustomerRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['CustId', 'CustName'],
       listeners: {
           load: function(custstore, records, success, options) {
               if ( <%=customeridlogged%> > 0) {
                   Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                   custId = Ext.getCmp('custcomboId').getValue();
                   Ext.getCmp('custcomboId').hide();
                   Ext.getCmp('custMandatoryId').hide();
                   Ext.getCmp('custLabelId').hide();
                   Ext.getCmp('cust4LabelId').hide();
               }
           }
       }
   });
 	
 	var custCombo = new Ext.form.ComboBox({
        				   store: clientcombostore,
        				   id: 'custcomboId',
        				   mode: 'local',
        				   forceSelection: true,
        				   emptyText: 'Select Customer',
        				   selectOnFocus: true,
        				   allowBlank: false,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   valueField: 'CustId',
        				   width: 170,
        				   displayField: 'CustName',
        				   cls: 'selectstylePerfect',
        				   listeners: {
            				   			select: {
                							fn: function() {
												tripCustomerCombostore.load({
							                 	   params:{
							                 	  	CustId: Ext.getCmp('custcomboId').getValue(),
							                 	  }
									     		});
					                		}
            							}
        					}
    				  });   
    				  
	var tripCustomerCombostore = new Ext.data.JsonStore({
					       url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getTripCustomer',
					       id: 'TripCustomerStoreId',
					       root: 'TripCustomerRoot',
					       autoLoad: false,
					       remoteSort: true,
					       fields: ['CustomerId', 'CustomerName'],
					       listeners: {
					           load: function() {
					               
					           }
					           
					       }
					   });
    				  
    var tripCustCombo = new Ext.form.ComboBox({
        				   store: tripCustomerCombostore,
        				   id: 'tripCustComboId',
        				   mode: 'local',
        				   forceSelection: true,
        				   emptyText: 'Select Client',
        				   selectOnFocus: true,
        				   allowBlank: false,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   valueField: 'CustomerId',
        				   width: 170,
        				   displayField: 'CustomerName',
        				   cls: 'selectstylePerfect',
        				   listeners: {
            				   			select: {
                							fn: function() {
                    								var selectedCustomer = Ext.getCmp('tripCustComboId').getValue();
                    									var selectedCustomer = Ext.getCmp('tripCustComboId').getValue();
                    								if((selectedCustomer == 0)&&(Ext.getCmp('loccomboId').getValue()==2)){
                    									Ext.getCmp('geofencecomboId').disable();
                    									Ext.getCmp('geofencecomboId').setValue('');
                    									geofencecomboStore.removeAt(geofencecomboStore.find('operationType', 'Customer Hub'));
                    									
                    								}if((selectedCustomer == 0)&&(Ext.getCmp('loccomboId').getValue()!=2)){
                    									Ext.getCmp('geofencecomboId').enable();  
                    									Ext.getCmp('geofencecomboId').setValue('');
                    									geofencecomboStore.removeAt(geofencecomboStore.find('operationType', 'Customer Hub'));
                    									
                    								}if((selectedCustomer != 0)&&(Ext.getCmp('loccomboId').getValue()!=2)){
                    									geofencecomboStore.reload();
                    									Ext.getCmp('geofencecomboId').disable();  
                    									Ext.getCmp('geofencecomboId').setValue('Customer Hub');
                    									
                    								}if((selectedCustomer != 0)&&(Ext.getCmp('loccomboId').getValue()==2)){
                    									geofencecomboStore.reload();
                    									Ext.getCmp('geofencecomboId').setValue('');
                    									Ext.getCmp('geofencecomboId').disable();
                    								}
                    								
                    								//call hub exist store
                    								hubNameExistStore.load({
							                 	   params:{
							                 	  	tripCustId: Ext.getCmp('tripCustComboId').getValue()
							                 	  }
									     		});
									     		Ext.getCmp('locationNameTextId').reset();
					                		}
            							}
        					}
    				  }); 			 

	var locTypeComboStore =  new Ext.data.SimpleStore({
	  							 id:'locationTypeStoreId',
	  							 autoLoad: true,
	  							 fields: ['LocTypeId', 'LocTyeName'],
	  							 data: [['2', 'POI'], ['1', 'Circular Hub'],['3','Polygonal Hub']]
							}); 
 	
 	var locTypeCombo = new Ext.form.ComboBox({
        				   store: locTypeComboStore,
        				   id: 'loccomboId',
        				   mode: 'local',
        				   forceSelection: true,
        				   emptyText: 'Select Geo-Fence Type',
        				   selectOnFocus: true,
        				   allowBlank: false,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   valueField: 'LocTypeId',
        				   width: 170,
        				   displayField: 'LocTyeName',
        				   cls: 'selectstylePerfect',
        				   listeners: {
            				   			select: {
                							fn: function() {
                    							loadMap();
                    							 Ext.getCmp('radiusTextId').reset();
                    							 
										        if(fromLiveUpdate == false){
										      	    Ext.getCmp('latitudeTextId').reset();
										        	Ext.getCmp('longitudeTextId').reset();
										       	}
                    							if(Ext.getCmp('loccomboId').getValue()==1){
           											Ext.getCmp('lng4LabelId').setText('Set Center');
           											Ext.getCmp('geofencecomboId').enable();
           											Ext.getCmp('geofencecomboId').setValue('Hub');  
                    								Ext.getCmp('latitudeTextId').enable();
           											Ext.getCmp('longitudeTextId').enable();
           											Ext.getCmp('standardTextId').enable();
           											Ext.getCmp('lng4LabelId').enable();
           											Ext.getCmp('geofencecomboId').setValue('Hub');
													
													Ext.getCmp('kmlLoctypeLabelId').disable();
													Ext.getCmp('polygonButtonId').disable(); //t4u506
           										}else if(Ext.getCmp('loccomboId').getValue()==2){
           											Ext.getCmp('lng4LabelId').setText('Set Hub/POI');   
           											Ext.getCmp('geofencecomboId').setValue('');  
           											Ext.getCmp('geofencecomboId').disable(); 
           											Ext.getCmp('latitudeTextId').enable();
           											Ext.getCmp('longitudeTextId').enable(); 
           											Ext.getCmp('radiusTextId').disable();
                    								Ext.getCmp('radiusButtonId').disable();
                    								Ext.getCmp('lng4LabelId').enable();
                    								Ext.getCmp('standardTextId').enable();
													
													Ext.getCmp('kmlLoctypeLabelId').disable();
													Ext.getCmp('polygonButtonId').disable(); //t4u506
           										}else if(Ext.getCmp('loccomboId').getValue()==3){
           											Ext.getCmp('lng4LabelId').setText('Set Hub/POI'); 
           											Ext.getCmp('geofencecomboId').enable();
           											Ext.getCmp('geofencecomboId').setValue('Hub');  
           											Ext.getCmp('latitudeTextId').disable();
           											Ext.getCmp('longitudeTextId').disable();
           											Ext.getCmp('radiusTextId').disable();
                    								Ext.getCmp('radiusButtonId').disable();
                    								Ext.getCmp('lng4LabelId').disable();
                    								Ext.getCmp('geofencecomboId').setValue('Hub');
                    								Ext.getCmp('standardTextId').enable();
													
													Ext.getCmp('kmlLoctypeLabelId').enable();
													Ext.getCmp('polygonButtonId').enable(); //t4u506
           										}   
           											var selectedCustomer = Ext.getCmp('tripCustComboId').getValue();
                    									var selectedCustomer = Ext.getCmp('tripCustComboId').getValue();
                    								if((selectedCustomer == 0)&&(Ext.getCmp('loccomboId').getValue()==2)){
                    									Ext.getCmp('geofencecomboId').disable();
                    									Ext.getCmp('geofencecomboId').setValue('');
                    									geofencecomboStore.removeAt(geofencecomboStore.find('operationType', 'Customer Hub'));
                    									
                    								}if((selectedCustomer == 0)&&(Ext.getCmp('loccomboId').getValue()!=2)){
                    									Ext.getCmp('geofencecomboId').enable();  
                    									Ext.getCmp('geofencecomboId').setValue('');
                    									geofencecomboStore.removeAt(geofencecomboStore.find('operationType', 'Customer Hub'));
                    									
                    								}if((selectedCustomer != 0)&&(Ext.getCmp('loccomboId').getValue()!=2)){
                    									geofencecomboStore.reload();
                    									Ext.getCmp('geofencecomboId').disable();  
                    									Ext.getCmp('geofencecomboId').setValue('Customer Hub');
                    									
                    								}if((selectedCustomer != 0)&&(Ext.getCmp('loccomboId').getValue()==2)){
                    									geofencecomboStore.reload();
                    									Ext.getCmp('geofencecomboId').setValue('');
                    									Ext.getCmp('geofencecomboId').disable();
                    								}

					                		}
            							}
        					}
    				  });  
    				  
	var geofencecomboStore =  new Ext.data.JsonStore({
        					  	 url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getGeoFenceType',
        					  	 id: 'geofenceStoreId',
        					  	 root: 'geofenceRoot',
        					      autoLoad: true,
        					     remoteSort: true,
        					     fields: ['operationId','operationType']
    					     }); 
    					     
    var bufferStore=new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/MapView.do?param=getBufferMapView',
		id:'BufferMapView',
		root: 'BufferMapView',
		autoLoad: false,
		remoteSort: true,
		fields: ['longitude','latitude','buffername','radius','imagename']
	}); 
	
	var polygonStore=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/MapView.do?param=getPolygonMapView',
			id:'PolygonMapView',
			root: 'PolygonMapView',
			autoLoad: false,
			remoteSort: true,
			fields: ['longitude','latitude','polygonname','sequence','hubid']
	});		
	
	var polygonStoreForModify=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getPolygon',
			id:'PolygonModifyId',
			root: 'PolygonModify',
			autoLoad: false,
			remoteSort: true,
			fields: ['longitude','latitude','sequence','hubid']         
	});
	
	

	
	var hubNameExistStore=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=isHubNameExists',
			id:'hubNameExistId',
			root: 'hubNameExistRoot',
			autoLoad: false,
			remoteSort: true,
			fields: ['hubNameExist']         
	});
	
	var regionComboStore =  new Ext.data.SimpleStore({
	  							 id:'regionStoreId',
	  							 autoLoad: true,
	  							 fields: ['regionId', 'regionName'],
	  							 data: [['1', 'North'], ['2', 'South'],['3','East'],['4','West']]
								 
								 

	});
	
					var regionCombo = new Ext.form.ComboBox({
        				   store: regionComboStore,
        				   id: 'regioncomboId',
        				   mode: 'local',
        				   emptyText: 'Select Region',
        				   selectOnFocus: true,
        				   allowBlank: true,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   valueField: 'regionName',
        				   width: 170,
        				   displayField: 'regionName',
        				   cls: 'selectstylePerfect',
        				   listeners: {
            				   			select: {
                							fn: function() {
                							Ext.getCmp('areacomboId').reset();
                							
					                		}
            							}
        					}
    				  });
	
	//*****************************************************ModifyStore***************************************************
	
	var modifyReader = new Ext.data.JsonReader({
       idProperty: 'readerId',
       root: 'NewGridRoot',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'landmarkNameDataIndex'
       }, {
           name: 'locationNameDataIndex'
       }, {
           name: 'locationTypeDataIndex'
       }, {
           name: 'geoFenceDataIndex'
       }, {
           name: 'radiusDataIndex'
       }, {
           name: 'latitudeDataIndex'
       }, {
           name: 'longitudeDataIndex'
       }, {
           name: 'gmtOffsetDataIndex'
       }, {
           name: 'cityDataIndex'
       }, {
           name: 'stateDataIndex'
       }, {
           name: 'countryDataIndex'
       }, {
           name: 'stdDurationDataIndex'
       }
       	]
   });
   
   modifyStore=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getModifyData',
			id:'editLandmarkStoreId',
			root: 'NewGridRoot',
			autoLoad: false,
			remoteSort: true,
			fields: ['slnoIndex','landmarkNameDataIndex','locationNameDataIndex','locationTypeDataIndex','geoFenceDataIndex','radiusDataIndex','operationIdDataIndex',
			'latitudeDataIndex','longitudeDataIndex','gmtOffsetDataIndex','cityDataIndex','stateDataIndex','countryDataIndex','stdDurationDataIndex','idDataIndex','regionDataIndex','tripCustomerDataIndex','contactPersonDataIndex','addressDataIndex','descDataIndex'
       	]
	});		
	
    
	
	function plotBuffers(){
	for(var i=0;i<bufferStore.getCount();i++){
	    var rec=bufferStore.getAt(i);
	    var urlForZero='/ApplicationImages/VehicleImages/information.png';
	    var convertRadiusToMeters = rec.data['radius'] * <%=Convertionsfactor%>;
	    var myLatLng = new L.LatLng(rec.data['latitude'],rec.data['longitude']);       	
	    createCircle = {
			strokeColor: '#A7A005',
			strokeOpacity: 0.8,
			strokeWeight: 3,
			fillColor: '#ECF086',
			fillOpacity: 0.55,
			map: map,
			center: myLatLng,
			radius: convertRadiusToMeters //In meters
	    };
	    if(convertRadiusToMeters==0 && rec.data['imagename']!=''){
	        var image1='/jsps/images/CustomImages/';
	        var image2=rec.data['imagename'];
	        urlForZero= image1+image2 ;
	    }else if (convertRadiusToMeters==0 && rec.data['imagename']==''){
	        urlForZero='/jsps/OpenLayers-2.10/img/marker.png';
	    }
	    bufferimage = L.icon({
			iconUrl: urlForZero,
			iconSize: [19, 35], // size of the icon
			popupAnchor: [0,-15]
		});
		buffermarker = new L.Marker(myLatLng, {icon: bufferimage}).addTo(map);   
		buffermarker.bindPopup(rec.data['buffername']);  
        
    	buffermarkers[i]=buffermarker;
		circlesPlot[i] = L.circle(myLatLng, {
			  color: '#A7A005',
			  fillColor: '#ECF086',
			  fillOpacity: 0.55,
			  center: myLatLng,
			  radius: convertRadiusToMeters
		}).addTo(map);
	    }
	}
	
	function plotPolygon(){
		
	var hubid=0;
	var polygonCoords=[];
	var polygonlines = [];
	for(var i=0;i<polygonStore.getCount();i++){
		var rec=polygonStore.getAt(i);
		if(i!=polygonStore.getCount()-1 && rec.data['hubid']==polygonStore.getAt(i+1).data['hubid']){			
			var latLong=new L.LatLng(rec.data['latitude'],rec.data['longitude']);
			polygonCoords.push(latLong);
			continue;
		}else{
			var latLong=new L.LatLng(rec.data['latitude'],rec.data['longitude']);
			polygonCoords.push(latLong);
		   }
		polygon = L.polygon(polygonCoords).addTo(map);
		
		polygonimage = L.icon({
			iconUrl: '/ApplicationImages/VehicleImages/information.png',
			iconSize: [48, 48], // size of the icon
			popupAnchor: [0,-15]
		});
		
		polygonmarker = new L.Marker(latLong, {icon: polygonimage}).addTo(map);
		polygonmarker.bindPopup(rec.data['polygonname']);  
		polygonsPlot[hubid]=polygon;
		polygonmarkers[hubid]=polygonmarker;
		hubid++;
		polygonCoords=[];
	}	
}    
 	
 	var GeoFenceCombo = new Ext.form.ComboBox({
        				   store: geofencecomboStore,
        				   id: 'geofencecomboId',
        				   mode: 'local',
        				   forceSelection: true,
        				   emptyText: 'Select Hub/POI Type',
        				   selectOnFocus: true,
        				   allowBlank: false,
        				   anyMatch: true,
        				   typeAhead: false,
        				   triggerAction: 'all',
        				   lazyRender: true,
        				   disabled:true,
        				   valueField: 'operationId',
        				   width: 170,
        				   displayField: 'operationType',
        				   cls: 'selectstylePerfect',
        				   value:'Hub',
        				   listeners: {
            				   			select: {
                							fn: function() {
                    							var geoFenceId = Ext.getCmp('geofencecomboId').getValue();
                    							if(geoFenceId == 999) {    												
    												Ext.getCmp('radiusTextId').setValue('30.00');
    											}
					                		}
            							}
        					}
    				  });  
    				    				  
 	var innerPanel = new Ext.form.FormPanel({
        				 standardSubmit: true,
        				 collapsible: false,
        				 autoScroll: true,
        				 height: 470,//410
        				 width: 400,
        				 frame: false,
        				 id: 'innerPanelId',
        				 layout: 'table',
        				 style:'margin-top:20px',
        				 layoutConfig: {
            					columns: 4,
            					tableAttrs: {
		            					style: {
		                					height: '90%'
		            					}
            					}		
        				 },
        				 items: [{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'custMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Customer Name',
            						cls: 'labelstyle',
            						id: 'custLabelId'
        						},
        						custCombo,{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'cust4LabelId'
        						},{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'tripcustMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Client Name',
            						cls: 'labelstyle',
            						id: 'tripcustLabelId'
        						},
        						tripCustCombo,{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'tripcust4LabelId'
        						},{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'locationNameMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Hub/POI Name',
            						cls: 'labelstyle',
            						id: 'locationNameLabelId'
        						},{
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: 'Enter Hub/POI Name',
            						emptyText: 'Enter Hub/POI Name',
            						enableKeyEvents: true,
            						allowBlank: false,
            						id: 'locationNameTextId',
            						regex: validate('locationname'),
            						listeners: {
            				   			change: {
                							fn: function() {
                    							var hubNameExist;
                    							 var value = Ext.getCmp('locationNameTextId').getValue().toUpperCase();
                    							 var row = hubNameExistStore.findExact('hubNameExist', value);
												 if(row >= 0)
												 {
												 	Ext.example.msg("Hub Name Already Exists!"); 
												 	Ext.getCmp('locationNameTextId').reset();
												 	Ext.getCmp('locationNameTextId').focus();
												 }	
												}
					                		}
            							}
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'loc4LabelId'
        						},{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'loctypeMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Geo-Fence Type',
            						cls: 'labelstyle',
            						id: 'loctypeLabelId'
        						},
        						locTypeCombo,
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'loctype4LabelId'
        						},
        						///  //Murali
                                {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'addressMandatoryId1'
                                }, {
                                    xtype: 'label',
                                    text: 'Polygon Buttons',
                                    cls: 'labelstyle',
                                    id: 'addressnameLabelId1'
                                },{
                                    xtype: 'button',
                                    text: 'Custom Polygon',
                                    cls: '',
                                    id: 'polygonButtonId',
                                    disabled:true,
                                       listeners: {
                                           click: {
                                            fn: function() {
                                                    myWinNew.show();
                                            }
                                        }
                                    }
                                },
                                {
                                    xtype: 'button',
                                    text: 'Upload KML',
                                    cls: '',
                                    id: 'kmlLoctypeLabelId',
                                    disabled:true,
                                       listeners: {
                                           click: {
                                            fn: function() {
                                            kmlWin.show();
                                            Ext.getCmp('saveLabelId').enable();
                                            }
                                        }
                                    }
                                },
        						{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'geofenceMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Hub/POI Type',
            						cls: 'labelstyle',
            						id: 'geofenceLabelId'
        						},GeoFenceCombo,
								{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'geofence4LabelId'
        						},
								{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'radiusMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Radius'+'('+'<%=distUnits%>'+')',
            						cls: 'labelstyle',
            						id: 'radiusLabelId'
        						},{
            						xtype: 'numberfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: '',
            						emptyText: '',
            						allowBlank: false,
            						disabled:true,
            						id: 'radiusTextId'
        						},{
            						xtype: 'button',
            						text: 'Set Radius',
            						cls: '',
            						id: 'radiusButtonId',
            						disabled:true,
        				   			listeners: {
            				   			click: {
                							fn: function() {
                    								setCircleRadius();
					                		}
            							}
        							}
        						},{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'latitudeMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Latitude',
            						cls: 'labelstyle',
            						id: 'latitudeLabelId'
        						},{
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: '',
            						emptyText: '',
            						allowBlank: false,
            						disabled:true,
            						id: 'latitudeTextId'
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'lat4LabelId'
        						},{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'longitudeMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Longitude',
            						cls: 'labelstyle',
            						id: 'longitudeLabelId'
        						},{
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: '',
            						emptyText: '',
            						allowBlank: false,
            						disabled:true,
            						id: 'longitudeTextId'
        						},{
            						xtype: 'button',
            						text: 'Set Location',
            						cls: '',
            						id: 'lng4LabelId',
            						disabled:true,
        				   			listeners: {
            				   			click: {
                							fn: function() {
                    							setLatLng();	
					                		}
            							}
        							}
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'mandatoryfield',
            						id: 'contactPersonMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Contact Person',
            						cls: 'labelstyle',
            						id: 'contactPersonLabelId'
        						},{
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						blankText: 'Enter Contact Person',
            						emptyText: 'Enter Contact Person',
            						allowBlank: true,
            						id: 'contactPersonTextId'
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'contactPerson4LabelId'
        						},{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'countryMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Country Name',
            						cls: 'labelstyle',
            						id: 'countryLabelId'
        						},countryCombo,
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'coun4LabelId'
        						},
        						{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'stateMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'State Name',
            						cls: 'labelstyle',
            						id: 'stateLabelId'
        						},stateCombo,
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'stat4LabelId'
        						},
        						{
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'cityMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'City Name',
            						cls: 'labelstyle',
            						id: 'cityLabelId'
        						}, {
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: '',
            						emptyText: '',
            						allowBlank: false,
            						id: 'cityTextId',
            						regex:validate('alphanumericname')
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'city4LabelId'
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'mandatoryfield',
            						id: 'addressMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Address',
            						cls: 'labelstyle',
            						id: 'addressnameLabelId'
        						},{
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: true,
            						blankText: 'Enter Address',
            						emptyText: 'Enter Address',
            						id: 'addressTextId'
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'address4LabelId'
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'mandatoryfield',
            						id: 'regionMandatoryId'
        						},{
            						xtype: 'label',
            						text: 'Region Name',
            						cls: 'labelstyle',
            						id: 'regionLabelId'
        						},
        						regionCombo,
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'region4LabelId'
        						}, {
            						xtype: 'label',
            						text: '*',
            						cls: 'mandatoryfield',
            						id: 'detentionMandatoryId'
        						}, {
            						xtype: 'label',
            						text: 'Detention Time (hh:mm)',
            						cls: 'labelstyle',
            						id: 'detentionLabelId'
        						}, {
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: '',
            						emptyText: '',
            						allowBlank: false,
            						id: 'standardTextId'
        						},{
            						xtype: 'label',
            						text: '',
            						cls: ''
        						},{
            						xtype: 'label',
            						text: '',
            						cls: 'mandatoryfield',
            						id: 'gmtMandatoryId',
            						hidden:true
        						}, {
            						xtype: 'label',
            						text: 'GMT offset',
            						cls: 'labelstyle',
            						id: 'gmtLabelId',
            						hidden:true
        						},{
            						xtype: 'textfield',
            						cls: 'selectstylePerfect',
            						allowBlank: false,
            						blankText: '',
            						emptyText: '',
            						allowBlank: false,
            						disabled:true,
									id: 'gmtTextId',
									hidden:true
        						},{
            						xtype: 'label',
            						text: '',
            						id: 'gmt4LabelId',
									hidden:true
        						},{
									xtype: 'label',
									text: '',
									cls: 'mandatoryfield',
									id: 'hubDescEmptyId1'
								}, {
									xtype: 'label',
									text: 'Description',
									cls: 'labelstyle',
									id: 'DescriptionLabelId'
								}, {
									xtype: 'textarea',
									cls: 'selectstylePerfect',
									id: 'DescriptionId',
									emptyText: 'Enter Description'
								}, {
						            xtype: 'label',
						            text: '',
						            cls: 'mandatoryfield',
						            id: 'hubDescId5'
						        },{
					                xtype: 'label',
					                id: 'CheckBoxLabelId',
					                cls:'labelstyle',
					                text: '' 
					            },
        						{
					                xtype: 'checkbox',
					                id: 'CheckboxId',
					                boxLabel:'Show Hubs',
					                width : 100,
			            			listeners: {
										check: function() {
										if (Ext.getCmp('custcomboId').getValue() == "") {
								               Ext.example.msg("Select Customer Name");
								               Ext.getCmp('custcomboId').focus();
								               return;
							                }
											if(Ext.getCmp('CheckboxId').getValue())
											{
												bufferStore.load({
												    callback:function(){
												    	plotBuffers();
												    	}
												});
												polygonStore.load({
												    callback:function(){
												    	plotPolygon();	
												    	}
												});
											} else {
												for(var i=0;i<circlesPlot.length;i++){
													map.removeLayer(circlesPlot[i]);
													map.removeLayer(buffermarkers[i]);
												}
												circlesPlot.length=0;
												for(var i=0;i<polygonsPlot.length;i++){
													map.removeLayer(polygonsPlot[i]);
													map.removeLayer(polygonmarkers[i]);
												}
												polygonsPlot.length=0;
											}
										}
									}
					                
					            },
								{        						
					                xtype: 'checkbox',
					                id: 'userHubCheckBoxLabelId',
					                boxLabel:'User Hub Association',
					                width : 100,
					                checked:true,
			            			listeners: {
										check: function() {
										if (Ext.getCmp('custcomboId').getValue() == "") {
								               Ext.example.msg("Select Customer Name");
								               Ext.getCmp('custcomboId').focus();
								               return;
							                }
										}
									}
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'importTextId'
        						},
        						{
            						xtype: 'label',
            						text: ' ',
            						cls: 'labelstyle',
            						id: 'importTextId22'
        						},
        						{
            						xtype: 'button',
            						text: 'Save',
            						cls: 'buttonstyle',
            						disabled:true,
            						id: 'saveLabelId',
            						width:'50px',
            						listeners: { 
							               click: {
							                   fn: function() {
							               		   var idIndex;
							                   	   var radius = 0;
							                   	   var locType = 0;
							                   	   if (Ext.getCmp('loccomboId').getValue() != "") {
							                   	   		var typeOfLoc = Ext.getCmp('loccomboId').getValue();
							                   	   		if (typeOfLoc == 'Buffer'){
							                   		   		locType = 1;
							                   	   		}
							                   	   		if (typeOfLoc == 'Location'){
							                   	  	 		locType = 2;
							                   	   		}
							                   	   		if (typeOfLoc == 'Polygon'){
							                   	  	 		locType = 3;
							                   	   		}
							                   	   }
							                       if (Ext.getCmp('custcomboId').getValue() == "") {
								                       Ext.example.msg("Select Customer Name");
								                       Ext.getCmp('custcomboId').focus();
								                       return;
							                       }
							                       if (Ext.getCmp('tripCustComboId').getValue() == "") {
								                       Ext.example.msg("Select Client Name");
								                       Ext.getCmp('tripCustComboId').focus();
								                       return;
							                       }
							                       if (Ext.getCmp('locationNameTextId').getValue() == "") {
								                       Ext.example.msg("Enter Hub/POI Name");
								                       Ext.getCmp('locationNameTextId').focus();
								                       return;
							                       }
							                       if (Ext.getCmp('loccomboId').getValue() == "") {
								                       Ext.example.msg("Select Hub/POI Type");
								                       Ext.getCmp('locationNameTextId').focus();
								                       return;
							                       }
							                       if (Ext.getCmp('countrycomboId').getValue() == "") {
								                       Ext.example.msg("Select Country");
								                       Ext.getCmp('countrycomboId').focus();
								                       return;
							                       }
							                       if (Ext.getCmp('statecomboId').getValue() == "") {
								                       Ext.example.msg("Select State");
								                       Ext.getCmp('statecomboId').focus();
								                       return;
							                       }
							                       if (Ext.getCmp('cityTextId').getValue() == "") {
								                       Ext.example.msg("Enter City");
								                       Ext.getCmp('cityTextId').focus();
								                       return;
							                       }
							                       if(Ext.getCmp('loccomboId').getValue() == '1' || locType == '1')
							                       {
							                       	 	radius = Ext.getCmp('radiusTextId').getValue();
							                       	 //removed for STD DUR
							                       	 	Ext.getCmp('standardTextId').enable();		
							                       	 	if (Ext.getCmp('radiusTextId').getValue() == "") {
								                       		Ext.example.msg("Enter Radius");
								                       		Ext.getCmp('radiusTextId').focus();
								                       		return;
							                       		}
							                       		//removed for STD DUR
							                       		if (Ext.getCmp('standardTextId').getValue() == "") {
									                       Ext.example.msg("Enter Detention Time");
									                       Ext.getCmp('standardTextId').focus();
									                       return;
								                       }
								                       if(!hhmmpattern.test(Ext.getCmp('standardTextId').getValue())){
								                       		Ext.example.msg("Enter Detention Time in standard format");
									                       Ext.getCmp('standardTextId').focus();
									                       return;
								                       }
								                       if (Ext.getCmp('geofencecomboId').getValue() == "") {
									                       Ext.example.msg("Select Geo-Fence Type");
									                       Ext.getCmp('geofencecomboId').focus();
									                       return;
								                       }
								                       if (Ext.getCmp('latitudeTextId').getValue() == "") {
									                       Ext.example.msg("Enter Latitude");
									                       Ext.getCmp('latitudeTextId').focus();
									                       return;
								                       }
								                       if (Ext.getCmp('longitudeTextId').getValue() == "") {
									                       Ext.example.msg("Enter Longitude");
									                       Ext.getCmp('longitudeTextId').focus();
									                       return;
								                       }
								                       if(<%=Convertionsfactor%> < 1100){
								                       if(Ext.getCmp('geofencecomboId').getRawValue() == 'Hub' && Ext.getCmp('radiusTextId').getValue()>3)
								                       	 {
								                       	   Ext.example.msg("Radius Should Not Exceed 3 kms");
									                       return;
								                      	 }
								                       }else if(<%=Convertionsfactor%> > 1100){
								                       if(Ext.getCmp('geofencecomboId').getRawValue() == 'Hub' && Ext.getCmp('radiusTextId').getValue()>1.8)
								                      	  {
								                       	   Ext.example.msg("Radius Should Not Exceed 1.8 miles");
									                       return;
								                       	  }
								                       }
							                       } 
							                       else if(Ext.getCmp('loccomboId').getValue() == '3' || locType == '3')
							                       {
							                       		radius = -1;
							                       		Ext.getCmp('standardTextId').enable();
							                       		if (Ext.getCmp('standardTextId').getValue() == "") {
									                       Ext.example.msg("Enter Detention Time");
									                       Ext.getCmp('standardTextId').focus();
									                       return;
								                       }
								                        if(!hhmmpattern.test(Ext.getCmp('standardTextId').getValue())){
								                       		Ext.example.msg("Enter Detention Time in standard format");
									                       Ext.getCmp('standardTextId').focus();
									                       return;
								                       }
								                       if (Ext.getCmp('geofencecomboId').getValue() == "") {
									                       Ext.example.msg("Select Geo-Fence Type");
									                       Ext.getCmp('geofencecomboId').focus();
									                       return;
								                       }
								                       if(Ext.getCmp('geofencecomboId').getRawValue() == 'Hub' && Ext.getCmp('radiusTextId').getValue()>3)
								                       {
								                       	   Ext.example.msg("Radius Should Not Exceed 3 kms");
									                       return;
								                       }
							                       } else if(Ext.getCmp('loccomboId').getValue() == '2' || locType == '2')
							                       {
							                       		Ext.getCmp('standardTextId').enable();
							                       		
							                       		if (Ext.getCmp('standardTextId').getValue() == "") {
									                       Ext.example.msg("Enter Detention Time");
									                       Ext.getCmp('standardTextId').focus();
									                       return;
								                       }
								                       
							                       		if(!hhmmpattern.test(Ext.getCmp('standardTextId').getValue())){
								                       		Ext.example.msg("Enter Detention Time in standard format");
									                       Ext.getCmp('standardTextId').focus();
									                       return;
								                       }
							                       	   if (Ext.getCmp('latitudeTextId').getValue() == "") {
									                       Ext.example.msg("Enter Latitude");
									                       Ext.getCmp('latitudeTextId').focus();
									                       return;
								                       }
								                       if (Ext.getCmp('longitudeTextId').getValue() == "") {
									                       Ext.example.msg("Enter Longitude");
									                       Ext.getCmp('longitudeTextId').focus();
									                       return;
								                       }
							                       }
							                       var lat; 
							                       var lng;
							                       var isModify=<%=isModify%>;
							                       if(Ext.getCmp('loccomboId').getValue()==3 || locType == '3'){
							                        if(isModify == true){
							                        latitudePolygon = [];
				   	                                longitudePolygon = [];
				   	                                var len = polygonNew.getPath().getLength();
				   	                                for (var i = 0; i < len; i++) {
				   	                                    latitudePolygon.push(polygonNew.getPath().getAt(i).lat());
				   	                                    longitudePolygon.push(polygonNew.getPath().getAt(i).lng());
				   	                                }
							                       }
							                       }
							                       if(Ext.getCmp('loccomboId').getValue()==3 || locType == '3'){
							                       		if(isModify == true){
							                       			lat = latitudePolygon+"";
							                       			lng = longitudePolygon+"";
							                       		}
							                       		else{
							                       			lat = latitude+"";
							                       			lng = longitude+"";
							                       		}
							                       }else{
							                       		lat = Ext.getCmp('latitudeTextId').getValue();
							                       		lng = Ext.getCmp('longitudeTextId').getValue();
							                       }
							                       if(isModify == true){
							                       		customer = '<%=custId%>';
							                       }else{
							                       		customer = Ext.getCmp('custcomboId').getValue();
							                       }
							                       if(Ext.getCmp('contactPersonTextId').getValue() != ""){
							                       		var pattern = /^[a-zA-Z0-9_\-\,\s]+$/;
							                       		var testing = pattern.test(Ext.getCmp('contactPersonTextId').getValue());
							                       		if (testing == false ) {
								                                Ext.example.msg("Please enter Contact Person in correct format");
								                                return;
								                            }
							                       }
							                       if(Ext.getCmp('addressTextId').getValue() != ""){
							                       		var pattern = /^[a-zA-Z0-9_\-\,\s]+$/;
							                       		var testing = pattern.test(Ext.getCmp('addressTextId').getValue());
							                       		if (testing == false ) {
								                                Ext.example.msg("Please enter Address in correct format");
								                                return;
								                            }
							                       }
							                       
							                       var countryName=Ext.getCmp('countrycomboId').getValue();
							                       if(isNaN(countryName))
							                       {
							                       		countryName=countryName.trim();
											            var country = countrystore.find('CountryName', countryName);
					                                    if(country >= 0)
					                                    {
					                                     	var record = countrystore.getAt(country);
					                                     	Ext.getCmp('gmtTextId').setValue(record.data['Offset']);
					                                    }
					                                    else
					                                    {
					                                     Ext.getCmp('gmtTextId').setValue('');
					                                    }
							                       }
							                	   
							                       var location = Ext.getCmp('locationNameTextId').getValue()+','+Ext.getCmp('cityTextId').getValue()+','+Ext.getCmp('statecomboId').getRawValue()+','+Ext.getCmp('countrycomboId').getRawValue();
							                       
							                       if(isModify == true){
							                       		Ext.Ajax.request({
								                 		 url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=checkHubInLegDetails',
								                         method: 'POST',
								                         params: {
								                             hubId: <%=hubId%>,
								                         },
								                         success: function(response, options) {
								                             var message = response.responseText;
								                             if(message == " Hub is not associated to leg "){
								                              // Let it flow
								                              }else {
								                             	  Ext.Msg.show({
														                title: 'Alert !!!',
														                msg: message,
														            	buttons: Ext.MessageBox.OK
																           
										                             	});
										                             }
										                         },
										                         failure: function() {
										                             Ext.example.msg(message);
										                         }		
														});
							                       }
							                       
							                   	   Ext.Ajax.request({
                                                   url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=saveLocation',
                                                   method: 'POST',
                                                   params: {
                                                       CustID: customer,
                                                       locationName:location ,
                                                       locationType: Ext.getCmp('loccomboId').getValue(),
                                                       geofenceType: Ext.getCmp('geofencecomboId').getRawValue(),
                                                       radius: radius,
                                                       latitude: lat,
                                                       longitude: lng,
                                                       gmt: Ext.getCmp('gmtTextId').getValue(),
                                                       standardDuration: Ext.getCmp('standardTextId').getValue(),
                                                       city: Ext.getCmp('cityTextId').getValue(),
                                                       pincode:newPincode,
                                                       country: countryNew,
                                                       state: Ext.getCmp('statecomboId').getValue(),
                                                       isModify: <%=isModify%>,
                                                       hubId: <%=hubId%>,
                                                       id: <%=id%>,
                                                       pageName: pageName,
                                                       checkBoxValue: Ext.getCmp('userHubCheckBoxLabelId').getValue(),
                                                       tripCustomerId:Ext.getCmp('tripCustComboId').getValue(),
                                                       region:Ext.getCmp('regioncomboId').getValue(),
                                                       contactPerson:Ext.getCmp('contactPersonTextId').getValue(),
                                                       address:Ext.getCmp('addressTextId').getValue(),
                                                       desc:Ext.getCmp('DescriptionId').getValue()
                                                   },
                                                   success: function(response, options) {
                                                       var message = response.responseText;
                                                       Ext.example.msg(message);
												       Ext.getCmp('locationNameTextId').reset();
												       Ext.getCmp('loccomboId').reset();
												       Ext.getCmp('geofencecomboId').reset();
												       Ext.getCmp('radiusTextId').reset();
												       Ext.getCmp('latitudeTextId').reset();
												       Ext.getCmp('longitudeTextId').reset();
												       Ext.getCmp('countrycomboId').reset();
												       Ext.getCmp('statecomboId').reset();
												       Ext.getCmp('cityTextId').reset();
												       Ext.getCmp('standardTextId').reset();
												       Ext.getCmp('gmtTextId').reset();
												       Ext.getCmp('tripCustComboId').reset();
												       Ext.getCmp('regioncomboId').reset();
												       Ext.getCmp('contactPersonTextId').reset();
												       Ext.getCmp('addressTextId').reset();
												       Ext.getCmp('DescriptionId').reset();
												       document.getElementById('target').innerHTML = '';
												       document.getElementById('noteId').innerHTML ='';
												       hubNameExistStore.load();
													   
                                                   },
                                                   failure: function() {
                                                   		Ext.example.msg("Error");
												        Ext.getCmp('locationNameTextId').reset();
												        Ext.getCmp('loccomboId').reset();
												        Ext.getCmp('geofencecomboId').reset();
												        Ext.getCmp('radiusTextId').reset();
												        Ext.getCmp('latitudeTextId').reset();
												        Ext.getCmp('longitudeTextId').reset();
												        Ext.getCmp('countrycomboId').reset();
												        Ext.getCmp('statecomboId').reset();
												        Ext.getCmp('cityTextId').reset();
												        Ext.getCmp('standardTextId').reset();
												        Ext.getCmp('gmtTextId').reset();
												        Ext.getCmp('tripCustComboId').reset();
												        Ext.getCmp('regioncomboId').reset();
												        Ext.getCmp('contactPersonTextId').reset();
												        Ext.getCmp('addressTextId').reset();
												        Ext.getCmp('DescriptionId').reset();
												        document.getElementById('target').innerHTML = '';
												        document.getElementById('noteId').innerHTML ='';
														
                                                   }		
							                   });
							                   if(markers != null){
							                   	  map.removeLayer(markers);
							                   }if(pointer != null){
							                   	  map.removeLayer(pointer);
							                   }if(circles != null){
							                   	  map.removeLayer(circles);
							                   }if(polygons != null){
							                   	   map.removeLayer(polygons);
							                   }
											   if(plotPolygonKML != undefined){
											  		 map.removeLayer(plotPolygonKML);
                                               }
                                               if(polygonCustomCreation != undefined){
                                               		map.removeLayer(polygonCustomCreation);
                                               }
							                   Ext.getCmp('geofencecomboId').disable();
                    						   Ext.getCmp('latitudeTextId').disable();
           									   Ext.getCmp('longitudeTextId').disable();
      										   Ext.getCmp('lng4LabelId').disable();
      										   Ext.getCmp('standardTextId').disable();
      										   Ext.getCmp('saveLabelId').disable();
      										   Ext.getCmp('radiusTextId').disable();
                    						   Ext.getCmp('radiusButtonId').disable();
                    						   Ext.getCmp('polygonButtonId').disable();
        						}
        						}
        						}}, {
            						xtype: 'button',
            						text: 'Clear',
            						cls: 'buttonstyle',
            						hidden: false,
            						disabled:false,
            						id: 'resetAllId',
            						listeners: {
							               click: {
							                   fn: function() {
				       								resetAll();
	            	                    		}
        									}					
        								}
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'clearTextId1'
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'importTextId1'
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'importTextId12'
        						},
        						
        						{ 
        							xtype: 'button',
            						text: 'Import',
            						cls: 'buttonstyle',
            						hidden:false,
            						disabled:false,
            						id: 'importXL',
            						listeners: {
							               click: {
							                   fn: function() {
												if (Ext.getCmp('custcomboId').getValue() == "") {
								                       Ext.example.msg("Select  Name");
								                       Ext.getCmp('custcomboId').focus();
								                       return;
							                       }
				        				importWin.show();
    									importWin.setTitle(importTitle);
				       
	            	                    }
        						}}
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'userId1'
        						},
        						{
            						xtype: 'label',
            						text: '',
            						cls: 'labelstyle',
            						id: 'importTextId3'
        						}
        						]
    			    });
     var fp = new Ext.FormPanel({
    		fileUpload: true,
  			width: '100%',
   			frame: true,
    		autoHeight: true,
    		standardSubmit: false,
    		labelWidth: 70,
   			defaults: {
        		anchor: '95%',
     		 	allowBlank: false,
    			msgTarget: 'side'
   	 			},
   	 		items: [{
        	xtype: 'fileuploadfield',
       		id: 'filePath',
       		width: 60,
       		emptyText: 'Browse',
       		fieldLabel: 'ChooseFile',
       		name: 'filePath',
       		buttonText: 'Browse',
     			buttonCfg: {
            			iconCls: 'browsebutton'
      					  },
       			listeners: {
         	    fileselected: {
                fn: function () {	
                    var filePath = document.getElementById('filePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "xls" || imgext == "xlsx") {

                    } else {
                        Ext.MessageBox.show({
                          		 msg: 'Please select only .xls or .xlsx files',
                           		 buttons: Ext.MessageBox.OK
                      		});
                       		 Ext.getCmp('filePath').setValue("");
                        	return;
                   			}
               			 }
           			 }
        			}
    			}],
   			 buttons: [{
       			 text: 'Upload',
      			 iconCls : 'uploadbutton',
       			 handler: function () {
         		 if (fp.getForm().isValid()) {
               			var filePath = document.getElementById('filePath').value;
						var custId=Ext.getCmp('custcomboId').getValue();
               			var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
               			 if (imgext == "xls" || imgext == "xlsx") {
								clearInputData();
                		} else {
                    			Ext.MessageBox.show({	
                      			msg: 'Please select only .xls or .xlsx files',
                        		buttons: Ext.MessageBox.OK
                  			  });
                   			Ext.getCmp('filePath').setValue("");
                    		return;
             			 	 }  					 
			 	fp.getForm().submit({
					  	url:'<%=request.getContextPath()%>/createLandmarkAction.do?param=importExcel&clientId='+custId,
						enctype: 'multipart/form-data',
						waitMsg: 'Uploading your file...',
                  		success: function (response, action) {
						Ext.Ajax.request({
                       		 url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getImportLocationDetails',
                       		 method: 'POST',
                      		 params: {
                        		    LocationImportResponse: action.response.responseText
                       			 },
                        	 success: function (response, options) {
                          			var  locationResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            		importstore.loadData(locationResponseImportData);
                            		
                        			},
                        	failure: function () {
                          			Ext.example.msg("Error");
                       				 }
                   				 });
                   				 
                   			 },
                   		failure: function () {
                       				 Ext.example.msg("Please Upload The Standard Format");
                   				 }
               			 });
           			 }
       			 }
   				 },
	       		{
					text: '<%=GetStandardFormat%>',
					iconCls : 'downloadbutton',
	  			 	handler : function(){
	  				Ext.getCmp('filePath').setValue("Upload the Standard File");
	 			  	fp.getForm().submit({
	  			  	url:'<%=request.getContextPath()%>/createLandmarkAction.do?param=openStandardFileFormat',
	    			});
					}
	 			 }]
		});
		
	  var kmlCloseButton = new Ext.Panel({
      id: 'kmlCloseButton',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 230,
      width: 430,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'Close',
          id: 'kmlCloseButton',
          cls: 'buttonstyle',
          iconCls: 'savebutton',
          width: 70,
          listeners: {
          click: {
          fn :function() {
            kmlWin.hide();
			}
		} 
		}
		}]
	});
	
		  var kmlFp = new Ext.FormPanel({
    		fileUpload: true,
  			width: '100%',
   			frame: true,
    		autoHeight: true,
    		standardSubmit: false,
    		labelWidth: 60,
   			defaults: {
        		anchor: '95%',
     		 	allowBlank: false,
    			msgTarget: 'side'
   	 			},
   	 		items: [{
        	xtype: 'fileuploadfield',
       		id: 'kmlFilePath',
       		width: 50,
       		emptyText: 'Browse',
       		fieldLabel: 'ChooseFile',
       		name: 'kmlFilePath',
       		buttonText: 'Browse',
     			buttonCfg: {
            			iconCls: 'browsebutton'
      					  },
       			listeners: {
         	    fileselected: {
                fn: function () {	
                    var filePath = document.getElementById('kmlFilePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "kml" || imgext == "kml") {

                    } else {
                        Ext.MessageBox.show({
                          		 msg: 'Please select only .kml files',
                           		 buttons: Ext.MessageBox.OK
                      		});
                       		 Ext.getCmp('kmlFilePath').setValue("");
                        	return;
                   			}
               			 }
           			 }
        			}
    			}],
   			 buttons: [{
       			 text: 'Upload',
      			 iconCls : 'uploadbutton',
       			 handler: function () {
         		 if (kmlFp.getForm().isValid()) {
               			var filePath = document.getElementById('kmlFilePath').value;
               			var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
               			 if (imgext == "kml" || imgext == "kml") {
								
                		} else {
                    			Ext.MessageBox.show({	
                      			msg: 'Please select only .kml files',
                        		buttons: Ext.MessageBox.OK
                  			  });
                   			Ext.getCmp('kmlFilePath').setValue("");
                    		return;
             			 	 }  					 
			 	        kmlFp.getForm().submit({
					  	url:'<%=request.getContextPath()%>/createLandmarkAction.do?param=importKML',
						enctype: 'multipart/form-data',
						waitMsg: 'Uploading your file...',
                  		success: function (response,action) {

                            Ext.Ajax.request({
                       		 url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=loadKML',
                        	 success: function (response, options) {
								 if(kmlCoOrdsArray.length>0)
								 {
									 kmlCoOrdsArray=[];
								 }
						   var responseObject=Ext.util.JSON.decode(response.responseText);
                  		   loadKMLCoordinatesToArray(responseObject);
                  		   plotPolygonKML = L.polygon(kmlCoOrdsArray).addTo(map);
						   
						   
						   geocodeLatLng(kmlCoOrdsArray[0].lat,kmlCoOrdsArray[0].lng,'drag');
						   var bounds = new L.LatLngBounds();
   	                            for (i = 0; i < kmlCoOrdsArray.length; i++) {
   	                                bounds.extend(kmlCoOrdsArray[i]);
   	                            }
   	                            map.fitBounds(bounds);
								google.maps.event.addListener(plotPolygonKML.getPath(), 'set_at', function() {
                                                     geocodeLatLng(plotPolygonKML.getPath().getAt(0).lat(),plotPolygonKML.getPath().getAt(0).lng(),'drag');
                                   
                                   });

                                   google.maps.event.addListener(plotPolygonKML.getPath(), 'insert_at', function() {
                                                     geocodeLatLng(plotPolygonKML.getPath().getAt(0).lat(),plotPolygonKML.getPath().getAt(0).lng(),'drag');
                                   
                                   });
						   drawingManager.setMap(null);
						   document.getElementById('noteId').innerHTML='';
                           kmlWin.hide();
                        			},
                        	failure: function () {
                          			Ext.example.msg("Error");
                       				 }
                   				 });
                   				 
						},
                   		failure: function () {
                       				 Ext.example.msg("File Uploading Failed");
                   				 }
               			 });
           			 }
       			 }
   				 }]
		});
		function closeImportWin(){
			fp.getForm().reset();	
            importWin.hide();
			clearInputData();
		}
		function clearInputData()	 {
    		importgrid.store.clearData();
    		importgrid.view.refresh();
		}
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!NEW GRID FOR IMPORT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  		var reader = new Ext.data.JsonReader({
   			 root: 'LocationDetailsImportRoot',
   			 totalProperty: 'total',
  			 fields: [{
     				    name: 'importslnoIndex'
  				  }, {
      					name: 'importhubname'
   				  }, {
     				    name: 'importradius'
  				  }, {
       					name: 'importlatitude'
  				  }, {
        				name: 'importlongitude'
   				  }, {
       					name: 'importoffset'
  				  }, {
        				name: 'importcity'
    			  }, {
        				name: 'importstate'
   				  }, {
      					name: 'importcountry'
   				  }, {
       					name: 'importgeoFence'
   				  }, {
      					name: 'importstdDuration'
    			  }, {
       					name: 'importremarksindex'
   				 }]
			});

		var importstore = new Ext.data.GroupingStore({
   				proxy: new Ext.data.HttpProxy({
       			url: '<%=request.getContextPath()%>/createLandmarkAction?param=getImportLocationDetails',
        		method: 'POST'
   				 }),
    			remoteSort: false,
    			bufferSize: 700,
   				autoLoad: false,
    			reader: reader
		});
//****************************grid filters
		var filters = new Ext.ux.grid.GridFilters({
  		  	local: true,
 			filters: [
 				 {
           type: 'numeric',
           dataIndex: 'importunitnoindex'
        }, {
            dataIndex: 'importunitnoindex',
            type: 'String'
        }, {
            dataIndex: 'importmanufacturerindex',
            type: 'string'
        },{
            dataIndex: 'importunittypeindex',
            type: 'string'
        }, {
            dataIndex: 'importunitreferenceidindex',
            type: 'string'
        }, {
            dataIndex: 'importstatusindex',
            type: 'string'
        }, {
            dataIndex: 'importremarksindex',
            type: 'string'
        }

   		 ]
		});
//****************column Model Config
		var createColModel = function (finish, start) {
  		var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 50,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=hubName%></span>",
            hidden: false,
            width: 100,
            sortable: true,
			//cls:'importClass',
            dataIndex: 'importhubname',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=radius%></span>",
            hidden: false,
            width: 80,
            sortable: true,
            dataIndex: 'importradius',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=latitude%></span>",
            dataIndex: 'importlatitude',
            hidden: false,
            width: 90,
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=longitude%></span>",
            dataIndex: 'importlongitude',
            hidden: false,
            width: 90,
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=offset%></span>",
            dataIndex: 'importoffset',
            hidden: false,
            width: 60,
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=city%></span>",
            hidden: false,
            width: 80,
            sortable: true,
            dataIndex: 'importcity',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=state%></span>",
            hidden: false,
            width: 80,
            sortable: true,
            dataIndex: 'importstate',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=country%></span>",
            hidden: false,
            width: 80,
            sortable: true,
            dataIndex: 'importcountry',
             filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=geoFence%></span>",
            dataIndex: 'importgeoFence',
            hidden: false,
            width: 90,
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=stdDuration%></span>",
            dataIndex: 'importstdDuration',
            hidden: false,
            width: 90,
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importremarksindex',
            filter: {
                type: 'String'
            }

        }];
   		return new Ext.grid.ColumnModel({
       		 columns: columns.slice(start || 0, finish),
       		 defaults: {
        	 sortable: true
      		 }
  		  });
		};

		function checkValid(val) {
    		if (val == "Invalid") {
       				 return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
   			 } else if (val == "Valid") {
       			 	return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    		}
		}
//*******************************grid**************************///
					 
		importgrid = getGrid('', '<%=NoRecordsFound%>', importstore, 1168, 283, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel',' jspName', 'exportDataType', false, 'PDF', false, false, false, false, false, false,false,'',false,'',false,'',false,'',false,'',false,'',true,'<%=Save%>',true,'<%=Clear%>',true,'<%=Close%>');	

//end grid

		var excelImageFormat = new Ext.FormPanel({
    		standardSubmit: true,
   	 		collapsible: false,
   			 id: 'excelMaster',
  		  		height: '100%',
  	  			width: '100%',
   				frame: false,
   			 items: [{
      			  cls: 'tripimportimagepanel'
    			}]
		});
    	var importPanelWindow = new Ext.Panel({
    		cls: 'outerpanelwindow',
  			frame: false,
    		layout: 'column',
    		layoutConfig: {
        	columns: 1
    		},
    		items: [fp,excelImageFormat,importgrid]//
		});		    
		function saveDate(){
  			    var locationValidCount = 0;
				var totalLocationCount = importstore.data.length;
   				 for (var i = 0; i < importstore.data.length; i++) {
       				var record = importstore.getAt(i);
        			var checkvalidRemarks = record.data['importremarksindex'];
        	if ( checkvalidRemarks == "") {
            	locationValidCount++;
        	}
        }
       Ext.Msg.show({
                title: 'Saving..',
        msg: 'We have ' + locationValidCount + ' valid locations out of ' + totalLocationCount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
 			var custId=Ext.getCmp('custcomboId').getValue();
			var saveJson = getJsonOfStore(importstore);
			if (saveJson != '[]' && locationValidCount>0) {
       			  		Ext.Ajax.request({
               			url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=saveImportLocationDetails&clientId='+custId,
            		    method: 'POST',
              			params: {
                            locationDataSaveParam: saveJson
              			},
               			success: function (response, options) {
               					var message = response.responseText;
               					store.reload({
                       				params: {
					    				jspName:jspName
                       			  	}
              					});
              			
              			 Ext.example.msg("Save Successful"); 
              		 },
              			failure: function () {
                           		Ext.example.msg("Error");
                      			  }
              			 });
              			clearInputData();
               			fp.getForm().reset();
            			importWin.hide();
              			Ext.example.msg("Save Successful"); 
        		   }else{
          				Ext.MessageBox.show({
                        		msg: "You don't have any Valid Information to Proceed",
                       			buttons: Ext.MessageBox.OK
                  			  });
           				}
          			 }
         		  }
        	  });
          }

		function getJsonOfStore(importstore) {
   			 var datar = new Array();
    		 var jsonDataEncode = "";
    		 var recordss = importstore.getRange();
    		 for (var i = 0; i < recordss.length; i++) {
       			 datar.push(recordss[i].data);
   			 }
   			 jsonDataEncode = Ext.util.JSON.encode(datar);
    		return jsonDataEncode;
		}
   
  		 var importWin = new Ext.Window({
    			title: 'Import Location from Excel',
    			width: 1180,
    			height:555,				
  				closable: false,
    			modal: true,
    			resizable: false,
    			autoScroll: false,
    			id: 'importWin',
    			items: [importPanelWindow]
		});
			 //t4u506
			 var polycount = 0;
    var polyArrayCustom = [];
           
    var formS = new Ext.FormPanel({
        xtype: 'form',
        id: 'myform',
         items: [{
            xtype: 'fieldset',
            width: 500,
            title: '',
            id: 'newFormPanelId',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 2
            },
        		items: []
        }],
       buttons: [{
            text: 'Add',
            handler: function() {
            Ext.getCmp('newFormPanelId').add(new Ext.form.TextField({
                   emptyText :'Latitude',
                    name: 'polygonLatitudeId'+polycount,
                    id: 'polygonLatitudeId'+polycount,
                    cls: 'selectstylePerfect',
                    maskRe: /[\d\.]/,
        			regex: /^\d+(\.\d{1,2})?$/
                }));
			
                Ext.getCmp('newFormPanelId').add(new Ext.form.TextField({
                    emptyText: 'Longitude',
                    //id:'longNewIdStyle',
                    name: 'polygonLongitudeId'+polycount,
                    id: 'polygonLongitudeId'+polycount,
                    cls: 'selectstylePerfect',
                    maskRe: /[\d\.]/,
					regex: /^\d+(\.\d{1,2})?$/
                }));
                polycount++;
                formS.doLayout();
            }
        }]
    });
		
  var innerWinButtonPanelNew = new Ext.Panel({
      id: 'winButtonIdNew',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 230,
      width: 430,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'Submit',
          id: 'addButtonIdNew',
          cls: 'buttonstyle',
          iconCls: 'savebutton',
          width: 70,
          listeners: {
          click: {
          fn :function() {
          Ext.getCmp('saveLabelId').enable();
				 for(var i=0; i < polycount; i++) {
					if(document.getElementById("polygonLatitudeId"+i).value == "" || document.getElementById("polygonLatitudeId"+i).value == "Latitude") {
						alert("Please Enter Latitude");
						Ext.getCmp("polygonLatitudeId"+i).focus();
						return;
					}
					if(document.getElementById("polygonLongitudeId"+i).value == "" || document.getElementById("polygonLongitudeId"+i).value == "Longitude") {
						alert("Please Enter Longitude");
						Ext.getCmp("polygonLongitudeId"+i).focus();
						return;
					}
				}  
        
        					var latLong;
        					var firstValue;
        					var lastLngValue;
        					var firstLngValue;
        					latitude = [];
	  		   				longitude = [];
   	                            for (var i = 0; i < polycount; i++) {
   	                                    latLong = new L.LatLng(document.getElementById("polygonLatitudeId"+i).value, document.getElementById("polygonLongitudeId"+i).value);
   	                                    polyArrayCustom.push(latLong);//abc
   	                                    latitude.push(document.getElementById("polygonLatitudeId"+i).value);
   	                                    longitude.push(document.getElementById("polygonLongitudeId"+i).value);
   	                            }
   	                             for (var i = 0; i < polycount; i++) {
   	                                    if(i==0){
   	                                    	firstValue = document.getElementById("polygonLatitudeId"+i).value;
   	                                    	firstLngValue = document.getElementById("polygonLongitudeId"+i).value;
   	                                    }
   	                                    if((i+1) == (polycount)){
   	                                    	lastLatValue = document.getElementById("polygonLatitudeId"+i).value;
   	                                    	lastLngValue = document.getElementById("polygonLongitudeId"+i).value;
   	                                    }
   	                            }
   	                            if(polycount < 4) {
   	                            	alert("Atleast 4 Lat Long should be required to create Polygon ");
   	                            	return;
   	                            }
   	                            console.log("lastLatValue  " + lastLatValue + " lastLngValue " + lastLngValue);
   	                            if(firstValue != lastLatValue) {
   	                                  alert("First and Last Latitude should be same");
   	                                  return;
   	                            }
   	                            if(firstLngValue != lastLngValue) {
   	                                  alert("First and Last Longitude should be same");
   	                                  return;
   	                            }
   	                            
   	                            
   	                            geocodeLatLng(Ext.getCmp('polygonLatitudeId0').getValue(),Ext.getCmp('polygonLongitudeId0').getValue(),'drag');
        						console.log("polyArrayCustom New :: " + polyArrayCustom);
					
   	                            polygonCustomCreation = L.polygon(polyArrayCustom).addTo(map);
   	                            bounds = new L.LatLngBounds();
   	                            for (i = 0; i < polyArrayCustom.length; i++) {
   	                                bounds.extend(polyArrayCustom[i]);
   	                            }
   	                            map.fitBounds(bounds);

   	                            google.maps.event.addListener(polygonCustomCreation.getPath(), 'set_at', function() {
   	                            	  			geocodeLatLng(polygonCustomCreation.getPath().getAt(0).lat(),polygonCustomCreation.getPath().getAt(0).lng(),'drag');
   	                            
   	                            });

   	                            google.maps.event.addListener(polygonCustomCreation.getPath(), 'insert_at', function() {
   	                            	  			geocodeLatLng(polygonCustomCreation.getPath().getAt(0).lat(),polygonCustomCreation.getPath().getAt(0).lng(),'drag');
   	                            
   	                            });
   	                            myWinNew.hide();
                }
                
            }
        }
      }, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtonId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myWinNew.hide();
                }
            }
        }
    }]
  });

		 myWinNew = new Ext.Window({
     		title: 'Polygon Lat Long',
      		closable: false,
     		resizable: false,
      		modal: true,
      		autoScroll: false,
      		height: 320,
      		width: 450,
      		frame: true,
      		id: 'myWinNew',
      		items: [formS,innerWinButtonPanelNew]
  		});
			 //t4u506	
			  
	var kmlWin = new Ext.Window({
              title: 'Upload KML File',
              closable: false,
              resizable: false,
              modal: true,
              autoScroll: false,
              height: 420,
              width: 450,
              frame: true,
              id: 'kmlWin',
              items: [kmlFp,kmlCloseButton]
          });
			    
 	var mapPannel = new Ext.Panel({
        				 standardSubmit: true,
        				 id: 'mapPannelId',
        				 collapsible: false,
        				 frame: true,
        				 style:'margin-left: 5px',
        				 width: screen.width - 465,
        				 height: 485,
        				 html: '<div id="search-panel" >'+
      						   '<input id="target" type="text" placeholder="Search Places" style="width: 863px; margin-bottom: 10px;">'+// 
    						   '</div>'+'<div id="map-canvas" style="width:100%;height:398px;border:2;">' +
    						   '</div>'+'<h1 id="noteId" style="font-size: larger;">'+'</h1>'
    					});

    var informationPanel = new Ext.Panel({
        				id: 'informationPanelId',
        				standardSubmit: true,
        				collapsible: false,
        				frame: true,
        				height: 485,
        				width: 410,
        				layout: 'table',
        				layoutConfig: {
            					columns: 1
        				},
        				items: [innerPanel]
    				});
 //====================================================EDIT LANDMARK FUNCTION===============================================   				

   	function editLandmark() {
   	    isModify = <%=isModify%>;
   	    if (isModify == true) {
   	       if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
   	       {
   	       		document.getElementById("topNav").style.display = "none";
   	       }
			var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
				}
   	        var location;
   	        var radius;
   	        var offset;
   	        var stdDuration;
   	        var geoFencetype;
   	        var city;
   	        var state;
   	        var country;
   	        var region;
   	        var contactPerson;
   	        var address;
   	        var desc;
   	        var trip;
   	        var polygonCoords = [];
   	        var marker;
   	        var mode;
   	        var dmodes;
   	        var circle;
   	        var polygon;
   	        var pos;
   	        var idIndex;
   	        var bounds;
   	        var record;
			
   	        modifyStore.load({
   	            params: {
   	                hubId: '<%=hubId%>',
   	                custId: '<%=custId%>'
   	            },
   	            callback: function() {
   	                record = modifyStore.getAt(0);
   	                Ext.getCmp('locationNameTextId').setValue(record.data['locationNameDataIndex']);
   	                Ext.getCmp('loccomboId').setValue(record.data['locationTypeDataIndex']);
   	                Ext.getCmp('geofencecomboId').setValue(record.data['geoFenceDataIndex']);
   	                Ext.getCmp('countrycomboId').setValue(record.data['countryDataIndex']);
   	                Ext.getCmp('statecomboId').setValue(record.data['stateDataIndex']);
   	                Ext.getCmp('cityTextId').setValue(record.data['cityDataIndex']);
   	                Ext.getCmp('gmtTextId').setValue(record.data['gmtOffsetDataIndex']);
   	                Ext.getCmp('standardTextId').setValue(record.data['stdDurationDataIndex']);
   	                Ext.getCmp('regioncomboId').setValue(record.data['regionDataIndex']);
   	                Ext.getCmp('tripCustComboId').setValue(record.data['tripCustomerDataIndex']);
   	                Ext.getCmp('contactPersonTextId').setValue(record.data['contactPersonDataIndex']);
   	                Ext.getCmp('addressTextId').setValue(record.data['addressDataIndex']);
   	                Ext.getCmp('DescriptionId').setValue(record.data['descDataIndex']);
   	                drawingManager.setOptions({
   	                    drawingControl: false
   	                });
   	                drawingManager.setDrawingMode(null);
   	                
		            var r=tripCustomerCombostore.find('CustomerName',Ext.getCmp('tripCustComboId').getValue());
		            var custRec=tripCustomerCombostore.getAt(r);
		            var tripCustomerId=custRec.data['CustomerId'];
   	                hubNameExistStore.load({
					       params:{
					                 tripCustId: tripCustomerId
					              }
					});
   	               
   	                if (record.data['radiusDataIndex'] == "0" || record.data['radiusDataIndex'] == "0.0") {
   	                    Ext.getCmp('latitudeTextId').setValue(record.data['latitudeDataIndex']);
   	                    Ext.getCmp('longitudeTextId').setValue(record.data['longitudeDataIndex']);
   	                    Ext.getCmp('countrycomboId').setValue(record.data['countryDataIndex']);
   	                	Ext.getCmp('statecomboId').setValue(record.data['stateDataIndex']);
   	                	Ext.getCmp('cityTextId').setValue(record.data['cityDataIndex']);
   	                    Ext.getCmp('saveLabelId').enable();
   	                    Ext.getCmp('lng4LabelId').enable();
   	                    Ext.getCmp('radiusTextId').disable();
   	                    Ext.getCmp('latitudeTextId').enable();
   	                    Ext.getCmp('longitudeTextId').enable();
   	                    Ext.getCmp('countrycomboId').enable();
   	                	Ext.getCmp('statecomboId').enable();
   	                	Ext.getCmp('cityTextId').enable();
						
   	                    pos = new L.LatLng(record.data['latitudeDataIndex'], record.data['longitudeDataIndex']);
   	                    map.setView(pos);
   	                    markers = new L.Marker(pos).addTo(map);
   	                    bounds = new L.LatLngBounds(pos);
   	                    map.fitBounds(bounds);
   	                    map.setZoom(12);

   	                    google.maps.event.addListener(markers, 'dragend', function() {
   	                        var objLatLng = markers.getPosition().toString().replace("(", "").replace(")", "").split(',');
   	                        Lat = objLatLng[0];
   	                        Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
   	                        Lng = objLatLng[1];
   	                        Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
   	                        geocodeLatLng(Lat,Lng,'marker');
   	                    });

   	                    google.maps.event.addListener(map, 'click', function(event) {
   	                    
   	                        markers.setPosition(event.latLng);
   	                        Lat = event.latLng.lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
   	                        Lng = event.latLng.lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"); // Set 5 Digits after comma
   	                        
   	                        geocodeLatLng(Lat,Lng,'marker');
   	                    });
   	                }

   	                if (record.data['radiusDataIndex'] == "-1" || record.data['radiusDataIndex'] == "-1.0") {
   	               
   	                    Ext.getCmp('radiusTextId').disable();
   	                    Ext.getCmp('latitudeTextId').disable();
   	                    Ext.getCmp('longitudeTextId').disable();
   	                    Ext.getCmp('saveLabelId').enable();
   	                    polygonStoreForModify.load({
   	                    params: {
   	               			 hubId: '<%=hubId%>'
   	           				},
   	                        callback: function() {
   	                            var latLong;
   	                            for (var i = 0; i < polygonStoreForModify.getCount(); i++) {
   	                                var rec = polygonStoreForModify.getAt(i);
   	                                if (i != polygonStoreForModify.getCount()  && '<%=hubId%>' == polygonStoreForModify.getAt(i).data['hubid']) {
   	                                    latLong = new L.LatLng(rec.data['latitude'], rec.data['longitude']);
   	                                    polygonCoords.push(latLong);
   	                                    latitudePolygon.push(rec.data['latitude']);
   	                                    longitudePolygon.push(rec.data['longitude']);
   	                                    continue;
   	                                }
   	                            }
								polygonNew = L.polygon(polygonCoords).addTo(map);
   	                            
   	                            bounds = new L.LatLngBounds();
   	                            for (i = 0; i < polygonCoords.length; i++) {
   	                                bounds.extend(polygonCoords[i]);
   	                            }
   	                            map.fitBounds(bounds);

   	                            google.maps.event.addListener(polygonNew.getPath(), 'set_at', function() {
   	                            	  			geocodeLatLng(polygonNew.getPath().getAt(0).lat(),polygonNew.getPath().getAt(0).lng(),'drag');
   	                            
   	                            });

   	                            google.maps.event.addListener(polygonNew.getPath(), 'insert_at', function() {
   	                            	  			geocodeLatLng(polygonNew.getPath().getAt(0).lat(),polygonNew.getPath().getAt(0).lng(),'drag');
   	                            
   	                            });
   	                        }
   	                    });
   	                }

   	                if (record.data['radiusDataIndex'] > 0 || record.data['radiusDataIndex'] > 0.0) {
   	                    Ext.getCmp('radiusTextId').setValue(record.data['radiusDataIndex']);
   	                    Ext.getCmp('latitudeTextId').setValue(record.data['latitudeDataIndex']);
   	                    Ext.getCmp('longitudeTextId').setValue(record.data['longitudeDataIndex']);
   	                    Ext.getCmp('countrycomboId').setValue(record.data['countryDataIndex']);
   	                	Ext.getCmp('statecomboId').setValue(record.data['stateDataIndex']);
   	                	Ext.getCmp('cityTextId').setValue(record.data['cityDataIndex']);
   	                    Ext.getCmp('radiusTextId').enable();
   	                    Ext.getCmp('radiusButtonId').enable();
   	                    Ext.getCmp('lng4LabelId').enable();
   	                    Ext.getCmp('lng4LabelId').setText('Set Center');
   	                    Ext.getCmp('latitudeTextId').enable();
   	                    Ext.getCmp('longitudeTextId').enable();
   	                    Ext.getCmp('countrycomboId').enable();
   	                	Ext.getCmp('statecomboId').enable();
   	                	Ext.getCmp('cityTextId').enable();
   	                    Ext.getCmp('saveLabelId').enable();

   	                    pos = new L.LatLng(record.data['latitudeDataIndex'], record.data['longitudeDataIndex']);
   	                    map.setView(pos);
   	                    circles = L.circle(pos, {
							  color: '#A7A005',
							  fillColor: '#ECF086',
							  fillOpacity: 0.55,
							  center: myLatLng,
							  radius: record.data['radiusDataIndex'] * <%=Convertionsfactor%>, //In meters
						}).addTo(map);

   	                    bounds = new L.LatLngBounds(pos);
   	                    map.fitBounds(bounds);
   	                    if (record.data['radiusDataIndex'] < 1.0) {
   	                        map.setZoom(16);
   	                    } else {
   	                        map.setZoom(10);
   	                    }

   	                    google.maps.event.addListener(circles, 'radius_changed', function() {
   	                        Ext.getCmp('radiusTextId').setValue(circles.getRadius() / <%=Convertionsfactor%>);
   	                        Ext.getCmp('latitudeTextId').setValue(circles.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
   	                        Ext.getCmp('longitudeTextId').setValue(circles.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
   	                        geocodeLatLng(circles.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"),circles.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"),'drag');
   	                        
   	                    });

   	                    google.maps.event.addListener(circles, 'center_changed', function() {
   	                        Ext.getCmp('radiusTextId').setValue(circles.getRadius() / <%=Convertionsfactor%>);
   	                        Ext.getCmp('latitudeTextId').setValue(circles.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
   	                        Ext.getCmp('longitudeTextId').setValue(circles.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
   	                        geocodeLatLng(circles.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"),circles.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"),'drag');
   	                        var pos = new L.LatLng(document.getElementById('latitudeTextId').value, document.getElementById('longitudeTextId').value);
   	                        if (markers == null) {
   	                            if (pointer != null) {
   	                                pointer.setPosition(pos);
   	                            }
   	                        } else {
   	                            circles.setPosition(pos);
   	                        }
   	                    });
   	                }
   	            }
   	        }); // modifyStore
   	        Ext.getCmp('CheckboxId').hide();
   	        Ext.getCmp('userHubCheckBoxLabelId').hide();
   	        Ext.getCmp('importXL').hide();
   	        Ext.getCmp('custcomboId').setValue('<%=custName%>');
   	        Ext.getCmp('custcomboId').disable();
   	        Ext.getCmp('loccomboId').disable();
   	        Ext.getCmp('tripCustComboId').disable();
   	        Ext.getCmp('geofencecomboId').disable();
   	        Ext.getCmp('countrycomboId').disable();
   	        Ext.getCmp('statecomboId').disable();
   	        Ext.getCmp('cityTextId').disable();
   	        Ext.getCmp('resetAllId').disable();
   	        var x = document.getElementById("target");
		    if (x.style.display === "none") {
		        x.style.display = "block";
		    } else {
		        x.style.display = "none";
		    }
   	    }
   	    
   	} 

   	var geocoder = null;
   	function geocodeLatLng(lat,lon,type) {
		//resetAll();
		var locId=document.getElementById('loccomboId').value;
		fetch('http://nominatim.openstreetmap.org/reverse?format=json&lon='+ lon + '&lat=' + lat).then(function(response) {
			resp = response.json();
			return resp;
		}).then(function(json) {
	       	       alert(json);
				   
				   if ('error' in json){
					   alert("address not found");
				   }
				   
				   var cntry = json.address.country.replace(/[0-9]/g, '');
		            var stat = json.address.state.replace(/[0-9]/g, '');
					var cty = "";
		             if ('city' in json.address){
						 cty = json.address.city.replace(/[0-9]/g, '')
					 }else if ('village' in json.address){
						 cty = json.address.village.replace(/[0-9]/g, '')
					 } else if ('hamlet' in json.address){
						 cty = json.address.hamlet.replace(/[0-9]/g, '')
					 }else if ('town' in json.address){
						 cty = json.address.town.replace(/[0-9]/g, '')
					 }else{
						cty = ""; 
					 }					
		            stat=stat.toUpperCase();
		            cntry=cntry.toUpperCase(); 
		            cty=cty.toUpperCase();
					newPincode = json.address.postcode;
				   Ext.getCmp('latitudeTextId').setValue(lat);
		   	        Ext.getCmp('longitudeTextId').setValue(lon);
		            Ext.getCmp('countrycomboId').setValue(cntry);
		            Ext.getCmp('statecomboId').setValue(stat);
		            if(cty=='UNNAMED ROAD'){
		            Ext.getCmp('cityTextId').setValue('');
		            Ext.getCmp('cityTextId').enable();
		            }else if(cty==''){
		            Ext.getCmp('cityTextId').setValue(cty);
		            Ext.getCmp('cityTextId').enable();
		            }else{
		            Ext.getCmp('cityTextId').setValue(cty);
		            Ext.getCmp('cityTextId').disable();
		            }
		            statestore.load({ params:{
	                	  	countryId:'<%=countryId%>'
	                	  }});
			         stat=stat.trim();
	                 var row = statestore.find('StateName',stat);
	                 var rec = statestore.getAt(row);
	                 var Region=rec.data['Region'];
			         Ext.getCmp('regioncomboId').setValue(Region);
	       })
		}
    
	function resetAll(){
		for (var i = 0; i < markerArray.length; i++) {
			map.removeLayer(markerArray[i]);
        }
        for(var i = 0; i < circleArray.length; i++){
        	map.removeLayer(circleArray[i]);
        }
        for(var i = 0; i < polyArray.length; i++){
        	map.removeLayer(polyArray[i]);
        }
        //reset fields
         Ext.getCmp('locationNameTextId').reset();
         Ext.getCmp('loccomboId').reset();
         Ext.getCmp('geofencecomboId').reset();
         Ext.getCmp('countrycomboId').reset();
         Ext.getCmp('statecomboId').reset();
         Ext.getCmp('cityTextId').reset();
         Ext.getCmp('gmtTextId').reset();
         Ext.getCmp('latitudeTextId').reset();
         Ext.getCmp('longitudeTextId').reset();
         Ext.getCmp('radiusTextId').reset();
         Ext.getCmp('tripCustComboId').reset();
      	 Ext.getCmp('regioncomboId').reset();
         Ext.getCmp('contactPersonTextId').reset();
         Ext.getCmp('addressTextId').reset();
         Ext.getCmp('DescriptionId').reset();
         Ext.getCmp('standardTextId').reset();
         document.getElementById('target').innerHTML = '';
         document.getElementById('noteId').innerHTML ='';
         
         Ext.getCmp('kmlLoctypeLabelId').disable();
         if(plotPolygonKML != undefined){
         	 map.removeLayer(plotPolygonKML);
         }
         kmlCoOrdsArray=[];
         //T4u506 
          Ext.getCmp('polygonButtonId').disable();
          if(polygonCustomCreation != undefined){
          	 map.removeLayer(polygonCustomCreation);
          }
         polyArrayCustom= [];
         //t4u506
	}
    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 360000;
        Ext.form.Field.prototype.msgTarget = 'side';
        Ext.getCmp('geofencecomboId').setValue('');
        outerPanel = new Ext.Panel({
            			 renderTo: 'content',
            			 standardSubmit: true,
            			 frame: true,
            			 title:'Hub/POI Creation',
            			 width: screen.width - 38,
            			 height: 540,
            			 layout: 'table',
            			 cls:'outerpanel',
            			 layoutConfig: {
                				columns: 2
            			 },
            			 items: [informationPanel,mapPannel]
        			});
        			//comment--call at trip cust combo
        			hubNameExistStore.load();
        			
	});

       
	 setTimeout(function(){editLandmark();}, 500);
  </script></font>
  <jsp:include page="../Common/footer.jsp" />

 <script> 
 var innerpage=<%=ipVal%>;
	  if (innerpage == true) {
				
				
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
			}
			
			</script>
