<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
		loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
		loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
		loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);	
}	
CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}		
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Asset_On");
tobeConverted.add("Asset_Off");
tobeConverted.add("Moving_Asset");
tobeConverted.add("Alert");
tobeConverted.add("Generic_Dashboard");
tobeConverted.add("Region");
tobeConverted.add("Group_Id");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String slno = convertedWords.get(0);
String assetOn = convertedWords.get(1);
String assetOff = convertedWords.get(2);
String movingAsset = convertedWords.get(3);
String alert = convertedWords.get(4);
String dashboard = convertedWords.get(5);
String region = convertedWords.get(6);
String groupId = convertedWords.get(7);
%>


<jsp:include page="../Common/header.jsp" />   
    <title><%=dashboard%></title>    
	 <meta charset="utf-8"> 
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    
    <link rel="stylesheet" href="../../Main/modules/cashVan/theme/css/EXTJSExtn.css" type="text/css"></link> 	
    <link rel="stylesheet" href="../../Main/modules/coldChainLogistics/dashboard/css/component.css" type="text/css"></link>
    
    <pack:style src="../../Main/resources/css/ext-all.css" />
    <pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
	
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	
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
	<pack:script src="../../Main/Js/Common.js"></pack:script>
	<pack:style src="../../Main/resources/css/common.css" />
	<pack:style src="../../Main/resources/css/dashboard.css" />
	
	<style>
		label {
			display : inline !important;
		}
		.x-panel-header
		{
			height: 44px !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-layer ul {
			min-height: 27px !important;
		}
		
	</style>
    
  <script src=<%=GoogleApiKey%>></script>
    <div class="container">
    	<div class="grid-content">
    		<div class="grid-container" id="grid-container"></div>
    	</div>
    	<div class="mp-container" id="mp-container">
	    		<div class="mp-map-wrapper" id="map"></div>
	    		<div class="mp-options-wrapper">
	    			<input id="pac-input" class="controls" type="text" placeholder="Search Places" >
	    			<table width="100%">
	    				<tr>
	    					<td width="25%">
	    						<div>
	    							<img class="asset_marker" src="/ApplicationImages/VehicleImages/green2.png">            				
									<span class="asset_marker_label" style="padding-right: 10px;"><%=assetOn%></span>
	    						</div>
	    					</td>
	    					<td width="25%">
	    						<div>
	    							<img class="asset_marker" src="/ApplicationImages/VehicleImages/red2.png">            				
									<span class="asset_marker_label" style="padding-right: 10px;"><%=assetOff%></span>
	    						</div>
	    					</td>
	    					<td width="25%">
	    						<div class="mp-option-normal" id="option-normal" onclick="reszieFullScreen()"></div>
								<div class="mp-option-fullscreen" id="option-fullscreen" onclick="mapFullScreen()"></div>
	    					</td>
	    				</tr>
	    			</table>
	    		</div>
	    </div>
    </div>
    <script> 
    var $mpContainer = $('#mp-container');	
	var $mapEl = $('#map');	
	var map;  
	var markers=[];	
    function initialize() {
        var mapOptions = {
            zoom: 2,
            center: new google.maps.LatLng('0.0','0.0'),
            mapTypeControl: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };        
        map = new google.maps.Map(document.getElementById('map'), mapOptions); 
        mapZoom = 5;       
        var defaultBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(17.385044000000000000, 78.486671000000000000),
        new google.maps.LatLng(17.439929500000000000, 78.498274100000000000));
        map.fitBounds(defaultBounds);
        searchBox(map,'pac-input');
        }
        google.maps.event.addDomListener(window, 'load', initialize);
        
    document.getElementById('option-normal').style.display = 'none';      
   
    function mapFullScreen(){
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
     function reszieFullScreen(){
    	document.getElementById('option-fullscreen').style.display = 'block';
        document.getElementById('option-normal').style.display = 'none';	
		$mpContainer.removeClass('mp-container-fitscreen');
		$mpContainer.removeClass('mp-container-fullscreen');	
		$mpContainer.addClass('mp-container');
		$mapEl.css({
						width	: $mapEl.data( 'originalWidth'),
						height	: $mapEl.data( 'originalHeight')
					});			
		google.maps.event.trigger(map, 'resize');
    }
/*****************************Panel for ASSET_OFF******************************************************/
	var ASSET_ON = new Ext.Panel({
			standardSubmit: true,
			frame:false,
			border:false,		
			collapsible:false,	
			width:'25%',	
			cls:'dashboardInnerPanelAssetColdChainPannel',
			bodyStyle: 'background: white',
			id:'ctbid',
			layout:'column',		
			layoutConfig: {
				columns:2
			},
			items:[{
					xtype:'panel',
					id:'statucountdetalspannel',
					frame:false,
					border:false,
					width:'100%',
					cls:'dashboardColdChainLogisticsHeaderLabelStyle',
					items:[{
					xtype: 'label',
					html: '<div class="assetOnHearderDiv" id="assentOnId">0</div>',
					width:'100%',
					border:true,
					bodyStyle: 'background-color: green',
					id:'assetOnCountId',
					},{
					xtype: 'label',
					html: '<div class="assetOnHearderCountDiv" id="assetOnHeader"><%=assetOn.toUpperCase()%></div>',
					width:'100%',
					border:true,
					}]}]
			}); // End of Panel	
		
		
/*****************************Panel for ASSET_OFF******************************************************/
	var ASSET_OFF = new Ext.Panel({
			standardSubmit: true,
			frame:false,
			border:false,				
			collapsible:false,
			width:'25%',
			cls:'dashboardInnerPanelAssetColdChainPannel',
			bodyStyle: 'background: white',
			id:'assetOffPanelId',
			layout:'column',		
			layoutConfig: {
				columns:2
			},
			items:[{
					xtype:'panel',
					id:'assetOffCountDetailsPannel',
					frame:false,
					border:false,
					width:'100%',
					cls:'dashboardColdChainLogisticsHeaderLabelStyle',
					items:[{
					xtype: 'label',
					html: '<div class="assetOffHearderLabelDiv" id="assetOffLabelId">0</div>',
					width:'100%',
					border:true,
					bodyStyle: 'background-color: green',
					id:'delayeddetailsid',
					},{
					xtype: 'label',
					html: '<div class="assetOffHeaderCountDiv" id="assetOffHeader"><%=assetOff.toUpperCase()%></div>',
					width:'100%',
					border:true,
					}]}]
			}); // End of Panel		
			
/*****************************Panel for MOVING******************************************************/
	var MOVING = new Ext.Panel({
			standardSubmit: true,
			frame:false,
			border:false,		
			collapsible:false,
			width:'25%',
			cls:'dashboardInnerPanelAssetColdChainPannel',
			bodyStyle: 'background: white',
			id:'movingAssetPanelId',
			layout:'column',		
			layoutConfig: {
				columns:2
			},
			items:[{
					xtype:'panel',
					id:'movingAssetPanel',
					frame:false,
					border:false,
					width:'100%',
					cls:'dashboardColdChainLogisticsHeaderLabelStyle',
					items:[{
					xtype: 'label',
					html: '<div class="movingHearderLabelDiv" id="movingdivId">0</div>',
					width:'100%',
					border:true,
					bodyStyle: 'background-color: green'
					},{
					xtype: 'label',
					html: '<div class="movingHeaderCountDiv" id="movingHeader"><%=movingAsset.toUpperCase()%></div>',
					width:'100%',
					border:true
					}]}]
			}); // End of Panel	
			
/*****************************Panel for ALERT******************************************************/
	var ALERT = new Ext.Panel({
			standardSubmit: true,
			frame:false,		
			border:false,		
			collapsible:false,
			width:'25%',
			cls:'dashboardInnerPanelAssetColdChainPannel',
			bodyStyle: 'background: white',
			id:'delayedaddresspanelid',
			layout:'column',		
			layoutConfig: {
				columns:3
			},
			items:[{
					xtype:'panel',
					id:'delayedaddresscountcetailspannel',
					frame:false,
					border:false,
					width:'100%',
					cls:'dashboardColdChainLogisticsHeaderLabelStyle',
					items:[{
					xtype: 'label',
					html: '<div class="alertHearderLabelDiv" id="alertdivId">0</div>',
					width:'100%',
					border:true,
					bodyStyle: 'background-color: green'
					},{
					xtype: 'label',
					html: '<div class="alertHeaderCountDiv" id="alertHeader"><%=alert.toUpperCase()%></div>',
					width:'100%',
					border:true
					}]}]
			}); // End of Panel		
	
	var innerSecondMainPannel=new Ext.Panel({
		standardSubmit: true,
		frame:false,
		height:100,
		width:'100%',
		border:false,
		id:'innersecondmainpannel',
			layout:'column',
			layoutConfig: {
				columns:4
			},
		items: [ASSET_ON,ASSET_OFF,MOVING,ALERT]
	});
	var innerMainPannel=new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		width:'100%',
		id:'innermainpannel',
		items: [innerSecondMainPannel]
	});
/****************************************************Reader************************************************/  		
		var reader = new Ext.data.JsonReader({
	        idProperty: 'clientReaderid',
	        root: 'clientList',
	        totalProperty: 'total',
	        fields: [{
	            		name: 'SLNOIndex'
	        		 },{
	            		name: 'groupIndex'
	        		 },{
	            		name: 'groupNameIndex'
	        		 },{
	            		name: 'assetOnIndex'
	        		 },{
	            		name: 'assetOffIndex'
	        		 },{
	            		name: 'movingAssetIndex'
	        		 },{
	            		name: 'alertIndex'
	        		 }]
    	});
 /****************************************************Stores************************************************************/     	
        var store = new Ext.data.GroupingStore({
	        autoLoad: false,
	        proxy: new Ext.data.HttpProxy({
	            url: '<%=request.getContextPath()%>/DashboardAction.do?param=getDashboardCount',
	            method: 'POST'
	        }),
	        reader: reader
    	});
    	var allVehicleStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardAction.do?param=getAllVehiclesBasedOnGroupId',
		    id: 'allVehicles',
		    root: 'allVehicles',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['allVehicleNo','allLatitude','allLongitude','allLocation','allGps','allStatus']	
		});
		var commVehicleStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardAction.do?param=getCommVehiclesCount',
		    id: 'commVehicles',
		    root: 'commVehicles',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['commcount']	
		});
		var nonCommVehicleStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardAction.do?param=getNonCommVehiclesCount',
		    id: 'nonCommVehicles',
		    root: 'nonCommVehicles',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['noncommcount']	
		});
		var movingVehicleStore = new Ext.data.JsonStore({
		   url: '<%=request.getContextPath()%>/DashboardAction.do?param=getMovingVehiclesCount',
		   id: 'movingVehicles',
		   root: 'movingVehicles',
		   autoLoad: false,
		   remoteSort: true,
		   fields: ['movingassetcount']	
		});
		var alertVehicleStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/DashboardAction.do?param=getAlertVehiclesCount',
		    id: 'alertVehicles',
		    root: 'alertVehicles',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['alertcount']	
		});
/****************************************************Filters-Column-Grid************************************************/		
        var filters = new Ext.ux.grid.GridFilters({
		    local: true,
		    filters: [{
	            		type: 'int',
	            		dataIndex: 'SLNOIndex'
	        		 },{
	            		type: 'int',
	            		dataIndex: 'groupIndex'
	        		 },{
	            		type: 'string',
	            		dataIndex: 'groupNameIndex'
	        		 },{
	            		type: 'int',
	            		dataIndex: 'assetOnIndex'
	        		 },{
	            		type: 'int',
	            		dataIndex: 'assetOffIndex'
	        		 },{
	            		type: 'int',
	            		dataIndex: 'movingAssetIndex'
	        		 },{
	            		type: 'int',
	            		dataIndex: 'alertIndex'
	        		 }]
		});
		var selModel=new Ext.grid.RowSelectionModel({
	      singleSelect:true
		});
         var colModel = new Ext.grid.ColumnModel([
	         	new Ext.grid.RowNumberer({
	            header : '<%=slno%>' , 
	            width : 40
            	}),{
		        header: "<span style=font-weight:bold;><%=slno%></span>",
		        sortable: true,		        
		        draggable:false,
		        hidden: true,
		        dataIndex: 'SLNOIndex',
		        filter: {
                  type: 'numeric'
              	}
		    	},{
		        header: "<span style=font-weight:bold;><%=groupId%></span>",
		        sortable: true,        
		        draggable:false,
		        hidden: true,
		        dataIndex: 'groupIndex',
		        filter: {
                  type: 'numeric'
              	}
		    	},{
		        header: "<span style=font-weight:bold;><%=region%></span>",
		        width:210,
		        sortable: true,	  
		        draggable:false,      
		        dataIndex: 'groupNameIndex',		        
		        filter: {
                  type: 'string'
              	}
		    	},{
		        header: "<span style=font-weight:bold;><%=assetOn%></span>",
		        sortable: true,	
		        draggable:false,        
		        dataIndex: 'assetOnIndex',		        
		        filter: {
                  type: 'numeric'
              	}
		    	},{
		        header: "<span style=font-weight:bold;><%=assetOff%></span>",
		        sortable: true,
		        dataIndex: 'assetOffIndex',
		        filter: {
                  type: 'numeric'
              	}		        
		    	},{
		        header: "<span style=font-weight:bold;><%=movingAsset%></span>",
		        sortable: true,
		        dataIndex: 'movingAssetIndex',
		        filter: {
                  type: 'numeric'
              	}		        
		    	},{
		        header: "<span style=font-weight:bold;><%=alert%></span>",
		        sortable: true,
		        dataIndex: 'alertIndex',
		        filter: {
                  type: 'numeric'
              	}		        
		    	}
		   ]);
        var grid = new Ext.grid.EditorGridPanel({ 
        	 border		: false,
		     frame		: false,                        
		     colModel   : colModel,		     
		     height		: 380,
		     //width		: screen.width-600,
		     store		: store,
		     sm			: selModel,
		     listeners  : {
			               cellclick:{fn:getRegionId}
              			  },		     
		     plugins 	: [filters]
		});
		function getRegionId(grid,rowIndex,columnIndex,e){
			var groupId = grid.getStore().getAt(rowIndex).data['groupIndex'];
			var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
			clearmarker();
			allVehicleStore.removeAll();
			allVehicleStore.load({
				params:{
					groupId:groupId
				},
				callback:function(){
					for(var i=0;i<allVehicleStore.getCount();i++){
						var record = allVehicleStore.getAt(i);
						var vehicleNo = record.data['allVehicleNo'];
						var latitude = record.data['allLatitude'];
						var longitude = record.data['allLongitude'];
						var location = record.data['allLocation'];
						var gps = record.data['allGps'];
						var status = record.data['allStatus'];
						plotmarker(vehicleNo,latitude,longitude,location,gps,status);
					}
				}
			});
			if(fieldName == 'movingAssetIndex'){
				window.location ="<%=request.getContextPath()%>/Jsps/Common/Alert.jsp";				
			}
			if(fieldName == 'alertIndex'){
				window.location ="<%=request.getContextPath()%>/Jsps/Common/Alert.jsp";
			}
		}
		function plotmarker(vehicleNo,latitude,longitude,location,gps,status){
			if(status == 'Communicating'){				
				imageurl='/ApplicationImages/VehicleImages/green.png';
			}else if(status == 'NonCommunicating'){
				imageurl='/ApplicationImages/VehicleImages/red.png';
			}
			image = {
	        	url:imageurl,
	        	scaledSize:  new google.maps.Size(19, 35),
	        	origin: new google.maps.Point(0, 0),
	        	anchor: new google.maps.Point(0, 32)
    		};
			var pos= new google.maps.LatLng(latitude,longitude);
       		var marker = new google.maps.Marker({
            	position: pos,
            	id:vehicleNo,
            	map: map,
            	icon:image
       		});       		
			marker.setAnimation(google.maps.Animation.DROP);       		
       		var bounds = new google.maps.LatLngBounds(new google.maps.LatLng(latitude,longitude));
			map.fitBounds(bounds);
			var listener = google.maps.event.addListener(map, "idle", function() { 
      			map.setZoom(5);
      			if (map.getZoom() > 16) map.setZoom(mapZoom);
				google.maps.event.removeListener(listener); 
			});
			markers.push(marker);
		}
		function clearmarker(){
			for(var i=0; i<markers.length;i++){
				var marker = markers[i];
    			marker.setMap(null);
    			marker=null;
			}
			markers.length = 0;
		}
        Ext.onReady(function(){
	       var outerPanel = new Ext.Panel({	
	       		title    : '<%=dashboard%>',
				id		 :'outerPanelId',
				renderTo :'grid-container',			
				items	 :[innerMainPannel,grid]
			});
			commVehicleStore.load({
				callback:function(){
					if(commVehicleStore.getCount()>0){
						var record = commVehicleStore.getAt(0);
						document.getElementById('assentOnId').innerHTML = record .data['commcount'];
					}
				}
			});
			nonCommVehicleStore.load({
				callback:function(){
				if(nonCommVehicleStore.getCount()>0){
					var record = nonCommVehicleStore.getAt(0);
					document.getElementById('assetOffLabelId').innerHTML = record .data['noncommcount'];
				}
				}
			});
			movingVehicleStore.load({
				callback:function(){
				if(movingVehicleStore.getCount()>0){
					var record = movingVehicleStore.getAt(0);
					document.getElementById('movingdivId').innerHTML = record .data['movingassetcount'];
				}
				}
			});
			alertVehicleStore.load({
				callback:function(){
				if(alertVehicleStore.getCount()>0){
					var record = alertVehicleStore.getAt(0);
					document.getElementById('alertdivId').innerHTML = record .data['alertcount'];
				}
				}
			});
			store.load();		
		});
    </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
