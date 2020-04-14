<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
	CommonFunctions cf = new CommonFunctions();
	String userName = "";
	String password = "";
	String vehicleNo= "NA";
 	
 	if(request.getParameter("vehicleNo")!=null){
 		vehicleNo=request.getParameter("vehicleNo");
 	}

	if (request.getParameter("userName")!=null){
	userName=request.getParameter("userName");
	}
	
	if (request.getParameter("password")!=null){
	password=request.getParameter("password");
	}
	
	if(request.getParameter("userName")=="" || request.getParameter("userName")==null){
%>	<html>
		<body>
			<script>
				alert("Please Enter The Username.");
			</script>
		</body>
	</html>
	
<% }else if (request.getParameter("password")=="" || request.getParameter("password")==null){%>
	<html>
		<body>
			<script>
				alert("Please Enter The Password.");
			</script>
		</body>
	</html>
<% }else if(request.getParameter("vehicleNo")=="" || request.getParameter("vehicleNo")==null){%>
 <html>
		<body>
			<script>
				alert("Please Enter At Least One Vehicle Number.");
			</script>
		</body>
	</html>
<% }else if(!(cf.checkAuthenticationMLLECommerce(userName,password,vehicleNo))){%>
	<html>
		<body>
			<script>
				alert("The User Credentials or Vehicle No are not valid.");
			</script>
		</body>
	</html>
<% }else
	{
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setLanguage("en");
	loginInfo.setZone("A");//B
	loginInfo.setOffsetMinutes(330);
	loginInfo.setCategory("India");
	loginInfo.setCategoryType("South India");
 	String vehicleTypeRequest = "all";
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 	session.setAttribute("loginInfoDetails",loginInfo);	
 %>
<!DOCTYPE html>
<html>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    
    <title>Map</title> 
    <style type="text/css">
    #image-info{
    text-align: left;
	width: 501px;
	float: left;
    }
    
    #image-info img{
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
    </style>
    
 <head>
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cargoManagement/mapView/css/component.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cargoManagement/mapView/css/layout.css" /> 
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

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
	</head>
    <script src=<%=GoogleApiKey%>></script>   
	<body oncontextmenu="return false">
		<div class="container">
			<header>
				<div id="vehicletype">
				</div>					
				<h1><span>MAPVIEW</span></h1>					
			</header>					
			<div class = "main">
			<img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index:4;left: 50%;top: 50%;">			
			<div class="mapview-mask" id="mapview-mask-id"></div>	
			<div class="mp-vehicle-wrapper" id="vehicle-list"></div>
			<div class="mp-vehicle-details-wrapper" id="vehicle-details">
			<form class="me-select">
				<ul id="me-select-list">
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle No </span><span class="vehicle-details-block-sep">:</span><p class="vehicle-details-block" id="asset-no-id"></p></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Location </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="location-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Vehicle Group </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="group-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Date Time </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="gmt-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Driver Name </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="driver-name-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Speed </span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="speed-id"></span></li>
					<li class="me-select-label"><span class="vehicle-details-block-header">Ignition</span><span class="vehicle-details-block-sep">:</span><span class="vehicle-details-block" id="ignition-id"></span></li>
				</ul>
			</form>						
			</div>
				<div class="mp-container" id="mp-container">
					<div class="mp-map-wrapper" id="map"></div>
					<div class="mp-options-wrapper"/>
						<div id="image-info">
							<img id="info" src="/ApplicationImages/VehicleImages/red.png" >
							<span style="padding-right: 20px; font-size: 14px;">Vehicle Not Moving</span>
							<img class="info" src="/ApplicationImages/VehicleImages/green.png">
							<span style="padding-right: 20px; font-size: 14px;">Moving Vehicle</span>
							<span style="left:50px; position:absolute;"></span>
						</div>
						<div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"  onclick="mapFullScreen()"></div>
					</div>
				</div>
			</div>
			</div>		
		<script>
		
		var markers = {};
		var infowindows= {};
		var circles = [];
		var polygons =[];
		var buffermarkers = [];
		var polygonmarkers =[];
		var marker;
		var map;
		var infowindow;
		var circle;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		document.getElementById('option-normal').style.display = 'none';
		var previousVehicleType='<%=vehicleTypeRequest%>';
		var vehicle='<%=vehicleNo%>';
		document.getElementById("vehicletype").value='<%=vehicleTypeRequest%>';

		
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

//***********************************Plot Vehicle on Map *******************************************
	    
	    function plotSingleVehicle(vehicleNo,latitude,longtitude,location,gmt,status,speed)
	    {
	    if((status=='stoppage') || (status=='idle'))
	    {
	    imageurl='/ApplicationImages/VehicleImages/red.png';
	    }
	    else
	    {
	    imageurl='/ApplicationImages/VehicleImages/green.png';
	    }
	    image = {
	        	url:imageurl , // This marker is 20 pixels wide by 32 pixels tall.
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
 
 		var content= document.createElement("div");
		content.innerHTML =
			'<table style="widthfont-size:10px;">'+
			'<tr><td><b>Vehicle No:</b></td><td>'+vehicleNo+'</td></tr>'+
			'<tr><td><b>Location:</b></td><td>'+location+'</td></tr>'+
			'<tr><td><b>Speed:</b></td><td>'+speed+'</td></tr>'+
			'<tr><td><b>Date Time:</b></td><td>'+gmt+'</td></tr>'+
			'</table>';
  		 
 		 	infowindow = new google.maps.InfoWindow({
      		content: content,
      		marker:marker,
      		maxWidth: 300,
      		image:image,
      		id:vehicleNo 
  		});	
  		
  		 google.maps.event.addDomListener(content, "contextmenu", function(e) {
   			e.preventDefault();
			e.stopPropogation();
 		  });
 		 
 			google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){ 
    			return function() {
    				var vehicles = grid.getSelectionModel().getSelections(); 
					Ext.iterate(vehicles, function(vehicle, index) {
						infowindowId=store.getAt(grid.getStore().indexOf(vehicle)).data['vehicleNo'];
						infowindows[infowindowId].setMap(null);
					}); 
        			infowindow.setContent(content);
        			infowindow.open(map,marker);
    			};
			})(marker,content,infowindow)); 
			marker.setAnimation(google.maps.Animation.DROP); 	
        var bounds = new google.maps.LatLngBounds();
    	var vehicles = grid.getSelectionModel().getSelections(); 
				Ext.iterate(vehicles, function(vehicle, index) {
				if(store.getAt(grid.getStore().indexOf(vehicle)).data['location']!='No GPS Device Connected')
				{
    				bounds.extend(new google.maps.LatLng(store.getAt(grid.getStore().indexOf(vehicle)).data['latitude'],store.getAt(grid.getStore().indexOf(vehicle)).data['longitude']));	
    			}	
				}); 
	    map.fitBounds(bounds);
	    var listener = google.maps.event.addListener(map, "idle", function() { 
  		if (map.getZoom() > 16) map.setZoom(10); 
  			google.maps.event.removeListener(listener); 
		});
	    infowindows[vehicleNo]=infowindow;
	    markers[vehicleNo] = marker;	    
	    }
	    
//********************************* Remove Vehicle Marker**********************************************	    
	    
	    function removeVehicleMarker(vehicleNo)
	    {
	    	if(document.getElementById("vehicletype").value!='noGPS')
	    	{
  				var marker = markers[vehicleNo];
    			marker.setMap(null);
    		}
	    }
	    
//********************************* Load Vehicles********************************************************	    
	    function loadvehicles()
	    {
	        document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';	
			document.getElementById('speed-id').innerHTML='';	
				
	    reszieFullScreen();
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
	    store.load({
    	params:{vehicleNo:vehicle},
    	callback:function(){  
    	 				grid.getSelectionModel().selectAll();
    					var el = document.getElementById('loadImage');
						el.parentNode.removeChild(el);
						var el1 = document.getElementById('mapview-mask-id');
						el1.parentNode.removeChild(el1);
    			}
    		});
	    }	    
	    
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
        		 	name: 'speed'
        		 },
        		 {
        		    name:'category'
        		 },        		 
        		 {
        		    name:'ignition'
        		 }      
        	  ]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MapView.do?param=getVehicleForMLLECommerce',
            method: 'POST'
        }),
        remoteSort: false,

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


         
   
    var grid = new Ext.grid.EditorGridPanel({                         
     height 	: 495,
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
  var selectedRows = selModel.getSelections();
  var rec = grid.store.getAt(index);
  if(!rec.data['latitude']==0 && !rec.data['longitude']==0)
  {
 		plotSingleVehicle(rec.data['vehicleNo'],rec.data['latitude'],rec.data['longitude'],rec.data['location'],rec.data['gmt'],rec.data['category'],rec.data['speed']);
  }
  	if( selectedRows.length>1){
           	multipleVehicleScreen();
           	}
           	else if( selectedRows.length==1){
           			document.getElementById('asset-no-id').innerHTML=rec.data['vehicleNo'];
					document.getElementById('location-id').innerHTML=rec.data['location'];
					document.getElementById('group-id').innerHTML=rec.data['groupname'];
					document.getElementById('gmt-id').innerHTML=rec.data['gmt'];
					document.getElementById('driver-name-id').innerHTML=rec.data['drivername'];
					document.getElementById('speed-id').innerHTML=rec.data['speed'];
					document.getElementById('ignition-id').innerHTML=rec.data['ignition'];
					
           	}	
  		});
  
  
  selModel.on('rowdeselect',function(selModel, index, record){
  var selectedRows = selModel.getSelections();
  var rec = grid.store.getAt(index);
  if(!rec.data['latitude']==0 && !rec.data['longitude']==0)
  {
  removeVehicleMarker(rec.data['vehicleNo']);
  }
           if( selectedRows.length==1){
            reszieFullScreen();
            var record = grid.getSelectionModel().getSelections(); 
			Ext.iterate(record, function(record, index) {
			document.getElementById('asset-no-id').innerHTML=record.data['vehicleNo'];
			document.getElementById('location-id').innerHTML=record.data['location'];
			document.getElementById('group-id').innerHTML=record.data['groupname'];
			document.getElementById('gmt-id').innerHTML=record.data['gmt'];
			document.getElementById('driver-name-id').innerHTML=record.data['drivername'];
			document.getElementById('speed-id').innerHTML=record.data['speed'];	
			document.getElementById('ignition-id').innerHTML=record.data['ignition'];	
			});			
           	}
           	else if( selectedRows.length==0){
			document.getElementById('asset-no-id').innerHTML='';
			document.getElementById('location-id').innerHTML='';
			document.getElementById('group-id').innerHTML='';
			document.getElementById('gmt-id').innerHTML='';
			document.getElementById('driver-name-id').innerHTML='';	
			document.getElementById('speed-id').innerHTML='';	
			document.getElementById('ignition-id').innerHTML='';
           	}
           	
  });
  
  
   
   function startfilter() {
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
   var vehiclePannel =new Ext.Panel({
   					id:'vehiclePannel',
                    height : 520,
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
							}, grid]
                });
        loadvehicles();        
        vehiclePannel.render('vehicle-list');	
		</script>
    </body>
      </html> 
      
<%}%>
