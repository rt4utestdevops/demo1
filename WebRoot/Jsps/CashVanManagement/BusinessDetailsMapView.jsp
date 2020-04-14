<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	String countryName = cf.getCountryName(countryId);
	//String buttonValue = request.getParameter("btn");
	//System.out.println(request.getParameter("btn"));
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
	//System.out.println(systemId+userAuthority);
	if(systemId==15 && !userAuthority.equalsIgnoreCase("Admin") && loginInfo.getIsLtsp()==0){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
	}
	//System.out.println("222"+systemId+loginInfo.getIsLtsp());
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
	
%>

<!DOCTYPE HTML>
<html>
<head>
 
	<title>Location Grabber</title>	
	<script src ="https://maps.googleapis.com/maps/api/js?key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&v=3.93&amp;sensor=false&amp;libraries=places,drawing&region=IN"></script>	
	
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
        
	  </style>
	</head>
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
	</style>
	    
<body onload="loadMap()">
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
 	
<script>


   /*******************resize window event function**********************/
	Ext.EventManager.onWindowResize(function () {
		var width = '100%';
		var height = '100%';
		//grid.setSize(width, height);
		outerPanel.setSize(width, height);
		outerPanel.doLayout();
	});
  /*******************End of resize window event function**********************/
 
 	var outerPanel;
 	var informationPanel;
 	var mapPannel;
 	var infoWindow = new google.maps.InfoWindow({});
  	var map;
	var drawingManager;
	var markers = null;
	var pointer = null;
	var circles = null;
	var polygons = null;
	var circlesPlot = [];
	//var coordinates = [];
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

	function loadMap() {
			
           var mapOptions = {
               center:new google.maps.LatLng(7.64566,80.68908),
               zoom:5,
               mapTypeId:google.maps.MapTypeId.ROADMAP
           };
           map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);
           var geocoder = new google.maps.Geocoder();
		    geocoder.geocode({'address': countryName}, function(results, status) {
		      if (status == google.maps.GeocoderStatus.OK) {
			        map.setCenter(results[0].geometry.location);
			        map.fitBounds(results[0].geometry.viewport);
		      	}
		    });
		    
           var mode;
           var dmodes;
           mode = google.maps.drawing.OverlayType.MARKER;
           dmodes='marker'; 
           drawingManager = new google.maps.drawing.DrawingManager({
           							drawingMode: mode,
          							drawingControl: true,
          							drawingControlOptions: {
            						position: google.maps.ControlPosition.TOP_CENTER,
            						drawingModes: [dmodes]            						
          						},
          						//markerOptions: {icon: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png'},
          						circleOptions: {
            						fillColor: '',
            						fillOpacity: 0.1,
            						strokeWeight: 2,
            						clickable: false,
            						editable: true,
            						zIndex: 1
          						}
        						});
         drawingManager.setMap(map);
         google.maps.event.addListener(drawingManager, 'markercomplete', function (marker) {
         markers = marker;
         if(pointer!=null){
       				pointer.setMap(null);
       	 }
        marker.setOptions({
            draggable: true
        });            
        google.maps.event.addListener(marker, 'dragend', function () {  
            
                var objLatLng = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
                Lat = objLatLng[0];
                Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
                Lng = objLatLng[1];
                Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
				parent.Ext.getCmp('latitudeId').setValue(Lat);
      			parent.Ext.getCmp('longitudeId').setValue(Lng);
        });
        
        google.maps.event.addListener(map, 'click', function (event) {
					marker.setPosition(event.latLng);
					markers.setMap(map);
	                Lat = event.latLng.lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
	                Lng = event.latLng.lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
					parent.Ext.getCmp('latitudeId').setValue(Lat);
      				parent.Ext.getCmp('longitudeId').setValue(Lng);
      				
        });
        
        drawingManager.setOptions({ drawingControl: false });
        drawingManager.setDrawingMode(null);
        var objLatLng = marker.getPosition().toString().replace("(", "").replace(")", "").split(',');
                Lat = objLatLng[0];
                Lat = Lat.toString().replace(/(\.\d{1,5})\d*$/, "$1");// Set 5 Digits after comma
                Lng = objLatLng[1];
                Lng = Lng.toString().replace(/(\.\d{1,5})\d*$/, "$1").trim();// Set 5 Digits after comma
				parent.Ext.getCmp('latitudeId').setValue(Lat);
      			parent.Ext.getCmp('longitudeId').setValue(Lng);
      			
    });
    
    google.maps.event.addListener(drawingManager, 'circlecomplete', function (circle) {
    	circles = circle;
		parent.Ext.getCmp('latitudeId').setValue(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
      	parent.Ext.getCmp('longitudeId').setValue(circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
    	parent.Ext.getCmp('radiusId').setValue(circle.getRadius()/1000);
    	drawingManager.setOptions({ drawingControl: false });
        drawingManager.setDrawingMode(null);
        
        google.maps.event.addListener(circle, 'radius_changed', function () {
  			parent.Ext.getCmp('latitudeId').setValue(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
      		parent.Ext.getCmp('longitudeId').setValue(circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
  			parent.Ext.getCmp('radiusId').setValue(circle.getRadius()/1000);
  		});
  		
  		google.maps.event.addListener(circle, 'center_changed', function () {
			parent.Ext.getCmp('latitudeId').setValue(circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
      		parent.Ext.getCmp('longitudeId').setValue(circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1"));
  			parent.Ext.getCmp('radiusId').setValue(circle.getRadius()/1000);
  			var pos = new google.maps.LatLng(parent.Ext.getCmp('latitudeId').getValue(),parent.Ext.getCmp('longitudeId').getValue());
  			
  			if(markers==null){
       		 	if(pointer!=null){
       		 		pointer.setPosition(pos);
       	 		}
       		}else{
       			markers.setPosition(pos);
       		}
  		});
        
     });
	
	  	if(fromLiveUpdate){
	      	var lat = '<%=lat%>';
	      	var lon = '<%=lon%>';
	      	var position = new google.maps.LatLng(lat,lon);
	      	var markr = new google.maps.Marker({
			    position: position,
			    map: map
			});
			parent.Ext.getCmp('latitudeId').setValue(lat);
       		parent.Ext.getCmp('longitudeId').setValue(lon);
	     }
    }
       function setLatLng(){
		
			if(parent.Ext.getCmp('latitudeId').getValue()==''){
				Ext.example.msg("Select Latitude");
				parent.Ext.getCmp('latitudeId').focus();
			}else if(parent.Ext.getCmp('longitudeId').getValue()==''){
				Ext.example.msg("Select Longitude");
				parent.Ext.getCmp('longitudeId').focus();
			}
			
			else{
       			var pos = new google.maps.LatLng(parent.Ext.getCmp('latitudeId').getValue(),parent.Ext.getCmp('longitudeId').getValue());
       			if(markers==null){
       		 		if(pointer!=null){
       					pointer.setMap(null);
       	 			}
       				pointer = new google.maps.Marker({
          					 position: pos,
          					 map: map
        			});
       			}else{
       				markers.setPosition(pos);
       				if(parent.Ext.getCmp('radiusId').getValue()!=''){
       					markers.setMap(map);
       				}
       			}
       			//markers.setMap(map);
       			//map.setCenter(pos);
       	   }
       	   
       }
       function clear(){
       if(markers!=null){
 				markers.setMap(null);
			}
		if(pointer!=null){
       		pointer.setMap(null);
       	 }
       }
       function setCircleRadius(){
       	    var radius = parent.Ext.getCmp('radiusId').getValue()*1000;
       		circles.setRadius(radius);
       }
       setTimeout(function(){loadMap();}, 500);
      //google.maps.event.addDomListener(window, "load", loadMap);   				  
		 
 	var mapPannel = new Ext.Panel({
        				 standardSubmit: true,
        				 id: 'mapPannelId',
        				 collapsible: false,
        				 frame: false,
        				 style:'margin-left: 5px',
        				 //title:'Location on Map',
        				 width: 900,
        				 height: 485,
        				 html: '<div id="map-canvas" style="width:100%;height:430px;border:2;">'
    					});


    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 360000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            			 renderTo: 'content',
            			 standardSubmit: true,
            			 frame: false,
            			 title:'Location Creation',
            			 width: 900,
            			 height: 485,
            			 layout: 'table',
            			 cls:'outerpanel',
            			 layoutConfig: {
                				columns: 2
            			 },
            			 items: [mapPannel]
        			});
	});
   </script>
  </body>
</html>
