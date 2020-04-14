
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
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
if(session.getAttribute("loginInfoDetails")==null){
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(206);
	loginInfo.setCustomerId(3545);
	loginInfo.setCustomerName("KANGAROO");
	loginInfo.setUserId(0);
	loginInfo.setOffsetMinutes(330);
	loginInfo.setLanguage("en");
	loginInfo.setIsLtsp(-1);
	loginInfo.setZone("A");
	session.setAttribute("loginInfoDetails",loginInfo);
}
 	CommonFunctions cf = new CommonFunctions();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
 	
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	int customerId=loginInfo.getCustomerId(); 	
 	String systemID = Integer.toString(systemid);
 	String vehicleTypeRequest = "all";
 	if (request.getParameter("vehicleType") != null) {
 		vehicleTypeRequest = request.getParameter("vehicleType");
 	}
 	int userId = loginInfo.getUserId();
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	String unit=cf.getUnitOfMeasure(systemid);
 %>
<jsp:include page="../Common/header.jsp" />
   <title>Map</title> 
  

  	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
  	<link rel="stylesheet" type="text/css" href="../../Main/modules/taxiSolution/mapView/css/component.css"  />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/mapView/css/layout.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" /> 
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
    <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
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
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />

	<style>
	
	.Taxi_Status_1  .x-grid3-cell-inner {
		background-color: #FF4040;
		height: 30px;
	}

	.Taxi_Status_2  .x-grid3-cell-inner {
		background-color: orange;
		height: 30px;
	}

	.Taxi_Status_3  .x-grid3-cell-inner {
		background-color: #33FF66;
		height: 30px;
	}
	.controls {
        margin-top: 16px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 26px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
      }
      
   
      .controls1 {
        margin-top: 30px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 26px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
      }

      #pac-input {
        background-color: #fff;
        padding: -1px 11px 0 13px;
        width: 294px;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        text-overflow: ellipsis;
      }
      
      #pac-input1 {
       position: absolute;
	height: 36px;
	background: #FFF;
	bottom: 0px;
	width: 100%;
	padding-top: 9px;
      }
      

      #pac-input:focus {
        border-color: #4d90fe;
        margin-left: -1px;
        padding-left: 14px;  /* Regular padding-left + 1. */
        width: 401px;
      }

      .pac-container {
        font-family: Roboto;
      }

      #type-selector {
        color: #fff;
        background-color: #4d90fe;
        padding: 5px 11px 0px 11px;
      }

      #type-selector label {
        font-family: Roboto;
        font-size: 13px;
        font-weight: 300;
      }
	@media screen and (device-width: 1600px) {
	.mp-container {
		background: #f4f4f4;
		border: 5px solid #fff;
		width: 60.8%;
		height: 639px;
		position: absolute;
		margin: auto;
		right: 23.4%;
		box-shadow: 1px 1px 3px #cac4ab;
		}
	}
	.editorgridstyles{
		height:530px; !Important;
	}
	@media screen and (device-width: 1600px) {
		.editorgridstyles{
		height:580px; !Important;
	}
	}
	.vhiclePanel{
		height:588px; !Important;
	}
	@media screen and (device-width: 1600px) {
		.vhiclePanel{
		height:640px; !Important;
		}
	}
	@media screen and (device-width: 1600px){
	.mp-container-fullscreen {
	border: none;	
	left: 0px;
	width: 100% !Important;
	height: 640px !Important;
	}
	}
	.footer {
			//bottom : -80px !important;
		}
		.vehicle-show-details-block {
			margin-top : -6px !important;
		}
		
		.mp-container {
			margin-bottom:64px;
		}
		.x-form-field-wrap .x-form-trigger {
			height: 19px;   
			top: 4px;
		}

	</style>
    <script src=<%=GoogleApiKey%>></script>   
	
		<div class="container">
			<header>
				<select class="combobox" id="vehicletype" onchange="loadvehicles()">
  					<option value="all">All</option>
  					<option value="readyforBooking">Ready for Booking</option>
  					<option value="driverLog">Driver Offline</option>
  					<option value="meterOn">Meter On</option>
  					<option value="vehicelisMoving">Vehicle is Moving</option>
  					<option value="noncomm">Non Communicating</option>
  					<option value="noGPS">No GPS Connected</option>
				</select>					
				<h1><span>LIVE VISION</span></h1>					
			</header>					
			<div class = "main" id="main-id">
			
			<img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index:4;left: 50%;top: 50%;">			
			<div class="mapview-mask" id="mapview-mask-id"></div>
			<div class="mapview-asset-commstatus">
			<div id="mapview-commstatus-dashboard-id" class="map-view-noncommststus-dashboard">
			     <div id="mapview-commstatus-leftdashboard-id" class="map-view-noncommststus-leftdashboard"> 
			        <form class="me-commselect">
					<ul id="me-select-list" class="map-view-comm-details">
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Vehicle No </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="assetno-id"></p></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Last Communicated Location </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="lastlocation-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Last Communicated Date Time</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="lastgmt-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">NonCommunicating Hours(HH:MM)</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="noncommhours-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">No of Satellites</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="staellite-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Invalid Packet</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="invalidpacket-id"></span></li>
					</ul>	
					</form>	
			     </div>
				 <div id="mapview-commstatus-rightdashboard-id" class="map-view-noncommststus-rightdashboard"> 
				 	<form class="me-commselect">
					<ul id="me-select-list" class="map-view-comm-details">
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Main Power</span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="mainpower-id"></p></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Main Power Off Location</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="mainpowerlocation-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Main Power Off DateTime</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="mainpowergmt-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Battery Health</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="batteryhealth-id"></span></li>
					<li class="me-select-commlabel"><span class="vehicle-details-block-header">Battery Voltage</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="batteryvoltage-id"></span></li>
					</ul>	
					</form>	
				 </div>
			</div>
			<div id="mapview-commstatus-id" class="map-view-noncommststus-grid"></div>
			<div id="mapview-commstatus-desc" class="map-view-noncommststus-desc">
			        <form class="me-commselect">
					  <ul id="me-select-list" class="map-view-comm-details">
					  		<li class="me-select-commlabel"><span class="vehicle-details-block-header">Device Non Communicating CheckList</span></li>
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">1) Sim Card Installed in device may  not be working</span></li>
					        <li class="me-select-commlabel"><span class="vehicle-details-block-details">2) Vehicle may be out of network coverage area</span></li>
							<li class="me-select-commlabel"><span class="vehicle-details-block-details">3) Device may be Tampered</span></li>
							<li class="me-select-commlabel"><span class="vehicle-details-block-details">4) Device Wire may be loosley connected</span></li>
					  </ul>	
					</form>	
			</div>
			<button type="button" id="ackw-button2-id" class="ack-button2" onclick="commstatusScreen()">Map View</button>	
			</div>	
			<div class="mp-vehicle-wrapper" id="vehicle-list"></div>
			<div class="mp-vehicle-details-wrapper" id="vehicle-details">
			<form class="me-select">
				<ul id="me-select-list" class="map-view-asset-details">
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle No </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="asset-no-id"></p></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Location </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="location-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle Group </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="group-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Date Time </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="gmt-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Driver Name </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="driver-name-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Speed</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="speed-id"></span></li>
				</ul>
			<div class='map-view-botton-pannel-div'>	
			<button type="button" id="ackw-button-id" class="ack-button" onclick="commstatusScreen()">Device Health</button>		
			</div>	
			</form>						
			</div>
				<div class="mp-container" id="mp-container">
					<div class="mp-map-wrapper" id="map"></div>
					<div class="mp-options-wrapper"/>
					<table width="98%">
						<tr height="10px"><td style="width: 1%;"> <div class="mp-option-showhub" id="show"></div></td>
						
						<td style=" width:5%;">
								<div>
								<img class="refreshImage" src="/ApplicationImages/ApplicationButtonIcons/Refresh.png" onclick="refreshVehicle()" title="Refresh"/>						
								</div>
						</td >
								
						<td style="width: 19%;" width="14%"><div>
								<input type="checkbox" id="c1" name="cc" onclick='showHub(this);'/>
            					<label for="c1"><span></span></label>
            					<span class="vehicle-show-details-block">Show Hubs</span>
            					</div>
            				</td>
            				<td style="width: 9%;" width="27%"><div class ="checkBoxRegion">
								<input type="checkbox" id="c2" name="cc" onclick='showDetails(this);'/>
            					<label for="c2"><span></span></label>
            					<span class="vehicle-show-details-block">Show Details</span>
            					</div>
            				</td>	
	
						<td><div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"  onclick="mapFullScreen()"></div></td>
				</tr></table>
				</div>
				<div id="pac-input1"></div>
			</div>
			</div>	
			</div>
		<script>
		var detailspage=0;
		var markers = {};
		var infowindows= {};
		var openinfowindows= {};
		var circles = [];
		var circles1 = [];
		var polygons =[];
		var buffermarkers = [];
		var buffermarker1 = [];
		var polygonmarkers =[];
		var buffermarker2;
		var marker;
		var map;
		var infowindow;
		var openinfowindow;
		var createCircle;
		var myLatLng;
		var circle;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });	
		var previousSelectedRow=-1;
		var contentone;
		var firstLoad=0;
		window.onload = function () { 
			getCombo();
		}
		if(parent.document.getElementById("msg-div") !=null && parent.document.getElementById("msg-div").style.display!="none")
		{
		parent.document.getElementById('msg-div').style.visibility = 'hidden';
		}	
		
		document.getElementById('ackw-button-id').style.visibility = 'hidden';	
		document.getElementById('option-normal').style.display = 'none';
		var previousVehicleType='<%=vehicleTypeRequest%>';
		document.getElementById("vehicletype").value='<%=vehicleTypeRequest%>';
		
		function commstatusScreen()
		{
		if(detailspage==0)
		{
		previousSelectedRow = grid.store.indexOf(grid.getSelectionModel().getSelected());
		var vehicleNo=document.getElementById('asset-no-id').innerHTML;
    	$('#mp-container').slideUp('slow', function() {});
  		$('#vehicle-details').slideUp('slow', function() {});
  		gridCommStatus.render('mapview-commstatus-id');	 
  		detailspage=1;  		
		getNonCommStatusData();
  		}
  		else
  		{
  		$('#mp-container').slideDown('slow', function() {});
  		$('#vehicle-details').slideDown('slow', function() {});
  		detailspage=0;
  		}
		}
			
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
		if(grid.getSelectionModel().getCount()>1)
		{
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container-fitscreen');
		}
		else
		{
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container');
		}
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		google.maps.event.trigger(map, 'resize');
					
		}
		
		function reszieFullScreen1()
		{
		if(grid.getSelectionModel().getCount()>1)
		{
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.removeClass('mp-container-fitscreen');
		}
		else
		{
		document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.removeClass('mp-container-fullscreen');
		$mpContainer.addClass('mp-container');
		}
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		google.maps.event.trigger(map, 'resize');
					
		}
		
		
//*****************************Multiple Vehicle Screen ******************************************************		
		function multipleVehicleScreen()
		{
		//document.getElementById('option-fullscreen').style.display = 'none';
        document.getElementById('option-normal').style.display = 'none';	
        
		$mpContainer.addClass('mp-container-fitscreen').css({
						width	: 'originalWidth',
						height	: 'originalHeight'
					});

		
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});				
					google.maps.event.trigger(map, 'resize');
		}
		
		 var mapOptions = {
	        zoom: 2,
	        center: new google.maps.LatLng('0.0', '0.0'),
	        mapTypeId: google.maps.MapTypeId.ROADMAP
	    };
		   map = new google.maps.Map(document.getElementById('map'), mapOptions);
		
		var latlongStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/MapView.do?param=getLatLong',
            id: 0,
            fields: ['name','latitude','longitude','imagename'],
            autoLoad: true,
            root: 'latlongList'
        });
		
			var LocationStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/MapView.do?param=getLandmarks',
				   id:'LocationStoreId',
			       root: 'LocationStoreList',
			       autoLoad: true,
			       remoteSort:true,
				   fields: ['id','locationName']
			     })	;	
			     
		var lc = new Ext.form.ComboBox({
		 id:'loccombo'
		,hideOnSelect:false
		,fieldLabel: 'Select Landmark'
        ,store: LocationStore
        ,queryMode: 'local'
        ,displayField: 'locationName'
        ,valueField: 'id'
        ,multiSelect: true
        ,emptyText: 'Search Location'
        ,width: 300
        ,height:50
		,anchor:'90%'
		,triggerAction:'all'
		,mode:'local',
		 listeners: {
            select: {
                fn: function () {
                Ext.getCmp('level1id').setValue(1);
                Ext.getCmp('sliderValue').setValue(1); 
                var names=Ext.getCmp('loccombo').getRawValue();
                latlongStore.load({
    			params:{names:names,
    			clientId:'<%=customerId%>'
    			},
    	callback:function(){
    	removeLocationMarker();
    	plotLocBuffers();
    	var rec=latlongStore.getAt(0);
    	
	    myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);  
	
	    var convertintomtrs=1*1000;
    	createCircle = {
	            strokeColor:'#FF8000',
	            strokeOpacity: 0.8,
	            strokeWeight: 2,
	            fillColor: '#FF8000',
	            fillOpacity: 0.35,
	            map: map,
	            center: myLatLng,
	            radius: convertintomtrs//In meters
	        };
	        
	        circle = new google.maps.Circle(createCircle);
	         
	          circle.setCenter(myLatLng);
	       	  map.fitBounds(circle.getBounds());
	       	  refreshVehicle();
    	//setAllCircles(Ext.getCmp('sliderValue').getValue());
    	$('#loccombo').keyup(function(){
				removeLocationMarker();
				circle.setCenter(null);
				 				
				 			});
    	}
    	});
                
                
                }
                }
                }
	});
	  
	    
    
		var mapZoom = 13;
		
		//***********************************Proximity search***********************************************

		var proximityPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    frame: false,
	    border:false,
	    collapsible: false,
	    autoHeight: true,
	    width: 800,
	    layout:'table',layoutConfig : {columns:7},
	     defaults: {
	        anchor: '100%',

	        },
	    items: [{xtype:'label',cls:'vehicle-show-details-block',id:'proxmityId' ,text:'Proximity in KMS:'},
	    				{
 							xtype: 'spacer',
 							 width:10
						},
	        			{fieldLabel: 'Level 1',
	        			xtype: 'sliderfield',
	        			increment: 1,
	        			minValue: 1,
	        			maxValue: 5,
	        			width:250,
	        			name: 'fx',
	        			id:'level1id',
	        			plugins: new Ext.slider.Tip(),
						expand: function() {
                		Ext.getCmp('level1id').syncThumb();
            			},
	        			onChange: function (slider, v) {
	        			
	        			Ext.getCmp('sliderValue').setValue(Ext.getCmp('level1id').getValue());
	        			
	        			if(Ext.getCmp('sliderValue').getValue()>=1)
	        			circle.setMap(null);
	        		//setAllCircles(Ext.getCmp('sliderValue').getValue());
	   				 var convertintomtrs=Ext.getCmp('sliderValue').getValue()*1000;
    					createCircle = {
	           			 strokeColor:'#FF8000',
	          			  strokeOpacity: 0.8,
	          			  strokeWeight: 2,
	           			 fillColor: '#FF8000',
	           			 fillOpacity: 0.35,
	           			 map: map,
	          			  center: myLatLng,
	          			  radius: convertintomtrs//In meters
	      				 };
	        
	       				 circle = new google.maps.Circle(createCircle);
	         
	         			 circle.setCenter(myLatLng);
	       	 			 map.fitBounds(circle.getBounds());
	        			}
	        			},{
 							xtype: 'spacer',
 							 width:10
						},{
	        			xtype: 'textfield',
	        			id: 'sliderValue',
	        			value: '1',
	        			width: 35,
	        			disabled: true
	    				},{
 							xtype: 'spacer',
 							 width:30
						},lc]
	});
	proximityPanel.render('pac-input1');
	
	
	
//	function setAllCircles(level1) {
//	for(var i=0;i<latlongStore.getCount();i++)
//	    {
	   
//	    var rec=latlongStore.getAt(i);
//	    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);    
//			var convertRadiusToMeters = level1 * 1000;
//    		var bearing = Math.random()*360;     	      	
//	        createCircle = {
//	            strokeColor:'#FF8000',
//	            strokeOpacity: 0.8,
//	            strokeWeight: 2,
//	            fillColor: '#FF8000',
//	            fillOpacity: 0.35,
//	            map: map,
//	            center: myLatLng,
//	            radius: convertRadiusToMeters //In meters
//	        };
//			for(var i=0;i<circles1.length;i++){
//						circles1[i].setMap(null);
//			}
//	         circles1[i] = new google.maps.Circle(createCircle);
	         
//	          circles1[i].setCenter(myLatLng);
//	       	  map.fitBounds(circle.getBounds());
//	       	  }
//	       	  }
//***********************************Plot Vehicle on Map *******************************************
	    
	    function plotSingleVehicle(vehicleNo,latitude,longtitude,location,gmt,status,speed,taxiMeter,flag)
	    {
	    	if (flag==1)
	    	{
	     		imageurl='/ApplicationImages/VehicleImages/blue1.png';
	    	} 
	    	else if(taxiMeter=='DriverLog')
	    	{
	    		imageurl='/ApplicationImages/VehicleImages/grey.png'
	    	}
	    	else
	    	{
	    		 if(taxiMeter=='MeterOn')
	    		{
	   				 imageurl='/ApplicationImages/VehicleImages/red.png';
	    		}
	    		else if(taxiMeter=='MeterOff' && speed>=5)
	    		{
	    			imageurl='/ApplicationImages/VehicleImages/yellow.png';
	    		}
	    		else if(taxiMeter=='MeterOff' && speed<5)
	   			{
	    			imageurl='/ApplicationImages/VehicleImages/green.png';
	    		}
	 			
			}
	    
	    image = {
	        	url:imageurl, // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};
    	var pos= new google.maps.LatLng(latitude,longtitude);
    	
        marker = new google.maps.Marker({
            	position: pos,
            	id:vehicleNo,
            	map: map,
            	icon: image
        	});       
		var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td><b>Vehicle No:</b></td><td>'+vehicleNo+'</td></tr>'+
			'<tr><td><b>Location:</b></td><td>'+location+'</td></tr>'+
			'<tr><td><b>Date Time:</b></td><td>'+gmt+'</td></tr>'+
			'</table>'+
			'</div>';
		  contentone = '<div id="InfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td></td><td>'+vehicleNo+'</td></tr>'+
			'</table>'+
			'</div>';
		infowindow = new google.maps.InfoWindow({
      		content: content,
      		marker:marker,
      		maxWidth: 300,
      		image:image,
      		id:vehicleNo
  		});	  		
  		openinfowindow = new google.maps.InfoWindow({
      		content: contentone,
      		marker:marker,
      		maxWidth: 300,
      		image:image,
      		id:vehicleNo
  		});	  		  		
		google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){ 		
    			return function() {    			    			
    				showDetails(true);
    				infowindow.setContent(content);
        			infowindow.open(map,marker);
        			document.getElementById("c2").checked=true;         			        			  			      			        			     			    			
    			};    			
			})(marker,content,infowindow)); 
			
		google.maps.event.addListener(infowindow,'closeclick',function(){
			document.getElementById("c2").checked=false;					
		});		
<!--		openinfowindow.setContent(contentone);-->
<!--        openinfowindow.open(map,marker);        -->
<!--        document.getElementById("c2").checked=true;-->
                    
		marker.setAnimation(google.maps.Animation.DROP);	  	
        var bounds = new google.maps.LatLngBounds();
    	var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					if(Ext.getCmp('loccombo').getValue()=='')
					{
					  bounds.extend(new google.maps.LatLng(store.getAt(grid.getStore().indexOf(vehicle)).data['latitude'],store.getAt(grid.getStore().indexOf(vehicle)).data['longitude']));	
					 
					}
					else
					{
						 for(var i=0;i<latlongStore.getCount();i++) {
						var rec=latlongStore.getAt(i);
						bounds.extend(new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']));	
						 
						}
    				}
    				}
				}); 
	    map.fitBounds(bounds);
	    var listener = google.maps.event.addListener(map, "idle", function() {
	     if (map.getZoom() > 16) map.setZoom(mapZoom);
  			google.maps.event.removeListener(listener); 
		});
		infowindows[vehicleNo]=infowindow;
	    markers[vehicleNo] = marker;
	    openinfowindows[vehicleNo]=openinfowindow;	    
	    }
//********************************* Select All ********************************************************

function selecAllVehicles(cb)
  {
  firstLoad=1;
  if(document.getElementById("vehicletype").value!='noGPS') 
  	   {
	    var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
    				marker.setMap(null);
    			}	
				}); 
		}
		
   if(cb.checked)
   {
   grid.getSelectionModel().selectAll();
   document.getElementById("c2").checked=false;
   Ext.getCmp('level1id').setValue(1);
   Ext.getCmp('sliderValue').setValue(1); 
   //showDetails(cb);
   }
   else
   {
   grid.getSelectionModel().clearSelections();
   }
  }	    
	    
//********************************* Remove Vehicle Marker**********************************************	    
	    
	    function removeVehicleMarker(vehicleNo)
	    {
	    	if(document.getElementById("vehicletype").value!='noGPS')
	    	{
	    	if(markers[vehicleNo]!=null){
  				var marker = markers[vehicleNo];
  				marker.setMap(null);
    			marker=null;
    			}
    		}
	    }
	    
//********************************* Load Vehicles********************************************************	    
	    function loadvehicles()
	    {
	    if(document.getElementById("selectAll") !=null && document.getElementById("selectAll") !="none")
	    {
	    	document.getElementById("selectAll").checked = false;
	    }	
	        document.getElementById('ackw-button-id').style.visibility = 'hidden';
	        document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';
			document.getElementById('speed-id').innerHTML='';		
	    reszieFullScreen1();
	    if(previousVehicleType!='noGPS')
	    {
	    var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					var marker = markers[store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']];
    				marker.setMap(null);
    			}	
				}); 
		}
		previousVehicleType=document.getElementById("vehicletype").value;
		if(firstLoad==1){
			var e = document.getElementById('combo-checkbox');     
          	e.style.display = 'none';
		}
	    store.load({
    	params:{vehicleType:document.getElementById("vehicletype").value,
    			customerID:'<%=customerId%>'
    			},
    	callback:function(){
    	if(firstLoad==1){
			var e = document.getElementById('combo-checkbox');     
          	e.style.display = 'block';
		}   
    	var el = document.getElementById('loadImage');
    	if(el != null){
			el.parentNode.removeChild(el);
		}
		var el1 = document.getElementById('mapview-mask-id');
		if(el1 != null){
			el1.parentNode.removeChild(el1);
    	}
    	}
    	});
	    }	    
//********************************** Refresh Vehicles every 1 min*****************************************************

function refreshVehicle()
{
		mapZoom=map.getZoom();
		var mapZoomRefresh=map.getZoom();
		var center = map.getCenter();
		var selectedIdx=[];
		var rowSel=[];
		var selVehicles=[];
		var index=[];
		previousSelectedRow=-1;
       	document.getElementById('asset-no-id').innerHTML='';
		document.getElementById('location-id').innerHTML='';
		document.getElementById('group-id').innerHTML='';
		document.getElementById('gmt-id').innerHTML='';
		document.getElementById('driver-name-id').innerHTML='';	
		document.getElementById("c2").checked=false;
   		reszieFullScreen();
   		if(previousVehicleType!='noGPS')
   			{
   				var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
   				selectedIdx.push(store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']);
   					if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
						{
							selVehicles.push(store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo']);
   						}
   	
				});
		showDetails(true); 
		}
		previousVehicleType=document.getElementById("vehicletype").value;	
   		store.load({
   			params:{vehicleType:document.getElementById("vehicletype").value,
   					customerID:'<%=customerId%>'
   			},
   		callback:function(){
				for(i=0; i<selVehicles.length; i++) {
   					removeVehicleMarker(selVehicles[i]);
					}
				if(document.getElementById("selectAll") !=null && document.getElementById("selectAll") !="none"){
		   			if(document.getElementById("selectAll").checked){
		   			grid.getSelectionModel().selectAll();
		   			}
		   			else
		   			{
		   			for(i=0;i<selectedIdx.length;i++){
		   			var indexSel=store.findExact('vehicleNo', selectedIdx[i]);
		   			index.push(indexSel);
					grid.getSelectionModel().selectRows(index);
					}
					}
		   				}
   					else
   				{
   		
					for(i=0;i<selectedIdx.length;i++){
				   	var vehicleIndex = store.findExact('vehicleNo',selectedIdx[i]);
				   	index.push(vehicleIndex);
					grid.getSelectionModel().selectRows(index);
				}
			}	
			map.setZoom(mapZoomRefresh);
			map.setCenter(center);
   			}
   		});
	}   
	    
//********************************** AssetDetails,Buffer & Polygon Store *********************************************	    
	    var bufferStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getBufferMapView',
				id:'BufferMapView',
				root: 'BufferMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','buffername','radius']
		}); 
		
		var polygonStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getPolygonMapView',
				id:'PolygonMapView',
				root: 'PolygonMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','polygonname','sequence','hubid']
		});
		
		
		var mapViewAssetDetails = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getIronMiningMapViewVehicleDetails',
				id:'MapViewVehicleDetails',
				root: 'MapViewVehicleDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['tripNo','ownerName','tripvalidity','vehicleId','status']
		});
		
		var mapViewNonCommStatus = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/MapView.do?param=getIronMiningMapViewCommStatus',
				id:'MapViewCommStatus',
				root: 'MapViewCommStatus',
				autoLoad: false,
				remoteSort: true,
				fields: ['vehicleNo','lastCommLocation','lastCommDateTime','nonCommHours','mainPower','mainPowerOffLocation','mainPowerOffTime','invalidPacket','batteryHealth','batteryVoltage','noOfSatellites']
		});
						
//*************************************** Display Hub *********************************************	

	    function showHub(cb)
	    {
	    	if(cb.checked)
	    	{
	    	loadMask.show();	
	    		bufferStore.load({
	    		params:{customerID:'<%=customerId%>'},
	    			callback:function(){
	    							plotBuffers();
	    							loadMask.hide();	
	    							}
	    					});
	    		polygonStore.load({
	    		params:{customerID:'<%=customerId%>'},
	    			callback:function(){
	    							plotPolygon();
	    							loadMask.hide();	
	    							}
	    					});			
	    	}
	    else
	    	{
	    	for(var i=0;i<circles.length;i++)
	    	{
	    	
    			circles[i].setMap(null);
    			buffermarkers[i].setMap(null);
	    	}
	    	for(var i=0;i<polygons.length;i++)
	    	{
    			polygons[i].setMap(null);
    			polygonmarkers[i].setMap(null);
	    	}
	    	}
	    }

///***************************************** Show Details********************************************	    
	    
	    function showDetails(cb)
	    {	
	    		var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
					infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
					if(cb.checked)
	    			{
    	    			openinfowindows[infowindowId].open(map, markers[infowindowId]); 
    	    			openinfowindow.setContent(contentone);
    	    		}
    	    		else
    	    		{
    	    			openinfowindows[infowindowId].setMap(null);
    	    		}
    	    	}	
				}); 
	    }

//******************************************* Buffer *******************************************************	    
	    function plotBuffers()
	    {
	    for(var i=0;i<bufferStore.getCount();i++)
	    {
	    var rec=bufferStore.getAt(i);
	    var convertRadiusToMeters = rec.data['radius'] * 1000;
	    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
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
	  bufferimage = {
	        	url: '/ApplicationImages/VehicleImages/information.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};      

	  buffermarker = new google.maps.Marker({
            	position: myLatLng,
            	id:rec.data['vehicleNo'],
            	map: map,
            	icon:bufferimage
        	});
        buffercontent=rec.data['buffername']; 	
		bufferinfowindow = new google.maps.InfoWindow({
      		content:buffercontent,
      		id:rec.data['vehicleNo'],
      		marker:buffermarker
  		});	
  		
  		google.maps.event.addListener(buffermarker,'click', (function(buffermarker,buffercontent,bufferinfowindow){ 
    			return function() {
        			bufferinfowindow.setContent(buffercontent);
        			bufferinfowindow.open(map,buffermarker);
    			};
			})(buffermarker,buffercontent,bufferinfowindow)); 
			buffermarker.setAnimation(google.maps.Animation.DROP); 


    		buffermarkers[i]=buffermarker;
			circles[i] = new google.maps.Circle(createCircle);
	    }
	    }

//*************************************Plot Location************************************************************

		function plotLocBuffers()
	    {
	    
	    for(var i=0;i<latlongStore.getCount();i++) {
	    var urlForZero='/jsps/OpenLayers-2.10/img/marker.png';
	    var rec=latlongStore.getAt(i);
	    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
	    var mapOptions = {
	        zoom: 12,
	        center: new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']),
	        mapTypeId: google.maps.MapTypeId.ROADMAP
	    };
	    map = new google.maps.Map(document.getElementById('map'), mapOptions)
	    var input =document.getElementById('pac-input');
	    map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);
	    if(rec.data['imagename']!=''){
	        var image1='/jsps/images/CustomImages/';
	        var image2=rec.data['imagename'];
	        urlForZero= image1+image2 ;
	        }
		bufferimage = {
	        	url:urlForZero , // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};      

	  buffermarker2 = new google.maps.Marker({
            	position: myLatLng,
            	map: map,
            	icon:bufferimage
        	});
        buffercontent=rec.data['name']; 	
		bufferinfowindow = new google.maps.InfoWindow({
      		content:buffercontent,
      		marker:buffermarker2
  		});	
  		
  		google.maps.event.addListener(buffermarker2,'click', (function(buffermarker2,buffercontent,bufferinfowindow){ 
    			return function() {
    				
        			bufferinfowindow.setContent(buffercontent);
        			bufferinfowindow.open(map,buffermarker2);
        			
    			};
			})(buffermarker2,buffercontent,bufferinfowindow)); 
			buffermarker2.setAnimation(google.maps.Animation.DROP); 
 
	
    		buffermarker1[i]=buffermarker2;
		//	circles[i] = new google.maps.Circle(createCircle);
		
			 
			
	    }
	    
	    
	    
	    }    
//*************************************Remove Location**********************************************************

		function removeLocationMarker(){
		  for (var i = 0, buffermarker2; buffermarker2 = buffermarker1[i]; i++) {
     	 buffermarker2.setMap(null);
      		}
		}



//**************************************Polygon*****************************************************************	    
	    function plotPolygon()
	    {
	    var hubid=0;
	    var polygonCoords=[];
	    for(var i=0;i<polygonStore.getCount();i++)
	    {
	    	var rec=polygonStore.getAt(i);
	    	if(i!=polygonStore.getCount()-1 && rec.data['hubid']==polygonStore.getAt(i+1).data['hubid'])
	    	{
	    	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
			}
  			polygon = new google.maps.Polygon({
    			paths: polygonCoords,
    			strokeColor: '#A7A005',
    			strokeOpacity: 0.8,
    			strokeWeight: 3,
    			fillColor: '#ECF086',
	            fillOpacity: 0.55
  				});
  			
  			polygonimage = {
	        	url: '/ApplicationImages/VehicleImages/information.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	}; 	
  				
  			  polygonmarker = new google.maps.Marker({
            	position:latLong,
            	map: map,
            	icon:polygonimage
        	});
        	var polygoncontent=rec.data['polygonname'];
			polygoninfowindow = new google.maps.InfoWindow({
      			content:polygoncontent,
      			marker:polygonmarker
  		});	
  		
     	google.maps.event.addListener(polygonmarker,'click', (function(polygonmarker,polygoncontent,polygoninfowindow){ 
    			return function() {
        			polygoninfowindow.setContent(polygoncontent);
        			polygoninfowindow.open(map,polygonmarker);
    			};
			})(polygonmarker,polygoncontent,polygoninfowindow)); 
			polygonmarker.setAnimation(google.maps.Animation.DROP); 
  			polygon.setMap(map);
  			polygons[hubid]=polygon;
  			polygonmarkers[hubid]=polygonmarker;
  			hubid++;
  			polygonCoords=[];
	    }
	    }
//***************************** Communication Status***********************************************************	    
	 var readerNonCommStatus = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'MapViewHistoryData',
        totalProperty: 'total',
        fields: [{
            		name: 'location'
        		 },
        		 {
            		name: 'datetime'            		
        		 },
        		 {
            		name: 'packettype'
        		 },
        		 {
        		    name: 'batteryvoltage'
        		 },
        		 {
        		    name: 'speed'
        		 },
        		 {
        		    name:'nosatelites'
        		 }       
        	  ]
    });

    var storeCommStatus = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getIronMiningHistoryData',
            method: 'POST'
        }),
        remoteSort: false,

        storeId: 'darStore',
        reader: readerNonCommStatus
    });
    

    var filtersCommStatus = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'location',
            type: 'string'
        }]
    });
    


    //************************************Column Model Config******************************************
     var colModelCommStatus = new Ext.grid.ColumnModel({
    	columns: [
    	 {
        header: 'Location',
        sortable: true,
        resizable:true,
        dataIndex: 'location',
        width:300
    	},{
        header: 'Date Time',
        sortable: true,
        resizable:true,
        dataIndex: 'datetime',
        width:150
    	},{
        header: 'Packet Type',
        sortable: true,
        resizable:true,
        dataIndex: 'packettype',
        width:170
    	},{
        header: 'Battery Voltage',
        sortable: true,
        resizable:true,
        dataIndex: 'batteryvoltage',
        width:100
    	},{
        header: 'Speed('+<%=unit%>+'/hr)',
        sortable: true,
        resizable:true,
        dataIndex: 'speed',
        width:80
    	},{
        header: 'Satelites',
        sortable: true,
        resizable:true,
        dataIndex: 'nosatelites',
        width:80
    	}]
		});


         
   
    var gridCommStatus = new Ext.grid.EditorGridPanel({                         
     height 	: 140,
     id			:'gridCommStatusid',
     viewConfig: {
            forceFit: true
        },
     autoWidth	: false,
     resizable	: true,
     store      : storeCommStatus,                                                                     
     colModel   : colModelCommStatus,                                       
     loadMask	: true
	 //plugins: [filtersCommStatus]  
	});	    
//***************************** Vehicle Grid***********************************************************	    
	 var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'MapViewVehicles',
        totalProperty: 'total',
        fields: [{
            		name: 'vehicleNo'
        		 },
        		 {
            		name: 'latitude'
        		 },
        		 {
            		name: 'longitude'
        		 },
        		 {
            		name: 'location'
        		 },
        		 {
            		name: 'gmt'
        		 },
        		 {
            		name: 'drivername'
        		 },
        		 {
            		name: 'groupname'
        		 },
        		 {
        		    name:'category'
        		 },
        		 {
        		    name:'ignition'
        		 },
        		 {
        		   name:'commstatus'
        		 },
        		 {
        		   name:'taxiMeter'
        		 },
        		 {
        		    name:'speed'
        		 },
        		 {
        		 	name:'flag'
        		 }	       
        	  ]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getTaxiMapViewVehicles',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'vehicleNo',
            direction: 'ASC'
        },
		fields:['vehicleNo'],
        storeId: 'darStore',
        reader: reader
    });
    

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'vehicleNo',
            type: 'string'
        }]
    });
    
    
       var selModel = new Ext.grid.CheckboxSelectionModel({             
     	singleSelect : false,
     	checkOnly : true
 		});

    //************************************Column Model Config******************************************
     var colModel = new Ext.grid.ColumnModel({
    	columns: [selModel,
    	 {
        header: 'Vehicle No',
        sortable: true,
        dataIndex: 'vehicleNo',
        width:160
    	}]
		});


         
   
    var grid = new Ext.grid.GridPanel({                         
    bodyCssClass : 'editorgridstyles',
     viewConfig: {
            forceFit: true
        },
     store      : store,                                                                     
     colModel   : colModel,                                       
     selModel   : selModel,
     hideHeaders: true,
     loadMask	: true,
	 plugins: [filters]   
	});


  selModel.on('rowselect', function(selModel, index, record){
  if(detailspage>0)
  {
  	if(previousSelectedRow!=-1)
  	{
   		selModel.deselectRow(previousSelectedRow);
   	}
   previousSelectedRow=index;
   getNonCommStatusData();
  }
  var selectedRows = selModel.getSelections();
  var rec = grid.store.getAt(index);
  if(!rec.data['latitude']==0 && !rec.data['longitude']==0)
  { 
 		plotSingleVehicle(rec.data['vehicleNo'],rec.data['latitude'],rec.data['longitude'],rec.data['location'],rec.data['gmt'],rec.data['category'],rec.data['speed'],rec.data['taxiMeter'],rec.data['flag']);
  }
  	if( selectedRows.length>1){
  			document.getElementById('ackw-button-id').style.visibility = 'hidden';
           	multipleVehicleScreen();
           	}
           	else if( selectedRows.length==1){
           	if(document.getElementById('vehicletype').value == "noncomm")
           	{
           document.getElementById('ackw-button-id').style.visibility = 'visible';
           }	
           			document.getElementById('asset-no-id').innerHTML=rec.data['vehicleNo'];
					document.getElementById('location-id').innerHTML=rec.data['location'];
					document.getElementById('group-id').innerHTML=rec.data['groupname'];
					document.getElementById('gmt-id').innerHTML=rec.data['gmt'];
					document.getElementById('driver-name-id').innerHTML=rec.data['drivername'];
					document.getElementById('speed-id').innerHTML=rec.data['speed'];
           	}	
  		});
  
  
  selModel.on('rowdeselect',function(selModel, index, record){
  document.getElementById('ackw-button-id').style.visibility = 'hidden';
  var selectedRows = selModel.getSelections();
  var rec = grid.store.getAt(index);
  if(!rec.data['latitude']==0 && !rec.data['longitude']==0)
  {
  removeVehicleMarker(rec.data['vehicleNo']);
  }
           if( selectedRows.length==1){
           if(document.getElementById('vehicletype').value=="noncomm"){
           document.getElementById('ackw-button-id').style.visibility = 'visible';
           }          
            reszieFullScreen();
            var record = grid.getSelectionModel().getSelections(); 
			Ext.iterate(record, function(record, index) {
			document.getElementById('asset-no-id').innerHTML=record.data['vehicleNo'];
			document.getElementById('location-id').innerHTML=record.data['location'];
			document.getElementById('group-id').innerHTML=record.data['groupname'];
			document.getElementById('gmt-id').innerHTML=record.data['gmt'];
			document.getElementById('driver-name-id').innerHTML=record.data['drivername'];	
			document.getElementById('speed-id').innerHTML=record.data['speed'];	
			});			
           	}
           	else if( selectedRows.length==0){
           	document.getElementById("c2").checked=false;
           	document.getElementById('ackw-button-id').style.visibility = 'hidden';
			document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';			
			document.getElementById('speed-id').innerHTML='';
           	}
           	
  });
  
  function getCombo()
  {
   LocationStore.load({
	params:{
		clientId:'<%=customerId%>'
		}
		});
  }
  
  function getNonCommStatusData(){
    	setTimeout(function(){
  		mapViewNonCommStatus.load({
  		params:{vehicleNo:document.getElementById('asset-no-id').innerHTML,customerID:'<%=customerId%>'},
  		callback:function(){
    	if(mapViewNonCommStatus.getCount()>0){
								var record=mapViewNonCommStatus.getAt(0);
								document.getElementById('assetno-id').innerHTML=record.data['vehicleNo'];
								document.getElementById('lastlocation-id').innerHTML=record.data['lastCommLocation'];
								document.getElementById('lastgmt-id').innerHTML=record.data['lastCommDateTime'];
								document.getElementById('noncommhours-id').innerHTML=record.data['nonCommHours'];
								document.getElementById('mainpower-id').innerHTML=record.data['mainPower'];
								document.getElementById('invalidpacket-id').innerHTML=record.data['invalidPacket'];
								document.getElementById('batteryhealth-id').innerHTML=record.data['batteryHealth'];
								document.getElementById('batteryvoltage-id').innerHTML=record.data['batteryVoltage'];
								document.getElementById('mainpowerlocation-id').innerHTML=record.data['mainPowerOffLocation'];
								document.getElementById('mainpowergmt-id').innerHTML=record.data['mainPowerOffTime'];
								document.getElementById('staellite-id').innerHTML=record.data['noOfSatellites'];
								storeCommStatus.load({
  								params:{vehicleNo:document.getElementById('asset-no-id').innerHTML,
  										customerID:'<%=customerId%>',
  										lastcommtime:document.getElementById('lastgmt-id').innerHTML}
  		
							    });	   	
    	}
    	}
  		}) ,1000});	
  		}
   
   function startfilter() {
        var selectedRows = selModel.getSelections();
        if(Ext.getCmp('searchVehicle').getValue()!='')
        {
        for(var i=0;i<selectedRows.length;i++)
        {
        var index=i;
        var seletionModel = grid.getSelectionModel();
        ///get array of the currently selected records
       var selectedRecords = selModel.getSelections();
        //get the value of given field definition from the first selected row
       var myValue = selectedRecords[index].get('vehicleNo');
        ///loop thru selectedRecords for more records if MULTI selection was allowed
        removeVehicleMarker(myValue);
        }
        }
		var val = Ext.getCmp('searchVehicle').getValue();
		var cm = this.grid.getColumnModel();
 		var filter = this.grid.filters.filters.get(cm.getDataIndex(1));
 		filter.setValue(val);
 		if(val!="") {
 			filter.setActive(true);
 		} else {
 			filter.setActive(false);
 		}
	} 
	
	
//******************************************* Vehicle Panel****************************************	
   Ext.Ajax.timeout = 360000;
   
   var noncommStatusPannel =new Ext.Panel({
   					id:'noncommStatusPannel',
                    height : 180,
                    border:true,
                    items: [gridCommStatus]
                });
                
   var vehiclePannel =new Ext.Panel({
   					id:'vehiclePannel',
                    cls: 'vhiclePanel',
                    items: [{
                    		xtype:'textfield',
                    		id:'searchVehicle',
                    		width:'100%',
                    		height:30,
                    		emptyText:'Search Vehicle',
                    		cls:'searchtextbox',
                    		fireKey: function (e) {
                        			if (e.type == 'keydown' || e.type == 'keypress') {
                            setTimeout('startfilter()', 500);
                        			}
                    				}
							},{
							xtype: 'panel',
							name :'image',
							html : '<div class="selectalldiv" id="combo-checkbox"><input type="checkbox" id="selectAll" name="cc" onclick="selecAllVehicles(this)"/><label for="selectAll"><span></span></label><span class="vehicle-show-details-block">Select All</span></div>'          
							}, grid]
                });
        loadvehicles();        
		setInterval(function(){refreshVehicle()},60000);  
        vehiclePannel.render('vehicle-list');           
		</script>
     <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
