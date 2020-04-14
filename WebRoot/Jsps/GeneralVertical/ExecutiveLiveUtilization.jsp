<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
	CommonFunctions cf = new CommonFunctions();
	GeneralVerticalFunctions gf=new GeneralVerticalFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int countryId = loginInfo.getCountryCode();
	int systemId = loginInfo.getSystemId();
	String countryName = cf.getCountryName(countryId);
	
	String routeId="0";
	if(request.getParameter("routeId")!=null){
		routeId=request.getParameter("routeId");
	}
	String tripNo = request.getParameter("tripNo");
	String vehicleNo = request.getParameter("vehicleNo");
	String plannedDate = request.getParameter("startDate");
	
	String startDate = "";
	String actualDate = "";
	if(request.getParameter("actual") != null && !request.getParameter("actual").equals("")){
		actualDate = request.getParameter("actual");
	}
	if(actualDate.equals("")){
		startDate = plannedDate;
	}else{
		startDate = actualDate;
	}
	System.out.print(startDate);
	String endDate = request.getParameter("endDate");
	String pageId = request.getParameter("pageId");
	String status = request.getParameter("status");
	String sts = "";
	if(status != null && !status.equals("")){
		String statusArr[] =  status.split("-"); 
		sts = statusArr[0];
	}
	int associated=gf.getAssociationDetails(vehicleNo,tripNo);
	HistoryAnalysisFunction hTrackingFunctions = new HistoryAnalysisFunction();
	ArrayList unitOfMeasurementList= hTrackingFunctions.getUnitDetails(systemId);
	String unitOfMeasurement=unitOfMeasurementList.get(0).toString();
	
	boolean check  = gf.checkIfRoutePresent(Integer.parseInt(routeId));
%>
  
	<jsp:include page="../Common/header.jsp" />
	<!--  CSS -->
    <!-- Bootstrap Core CSS -->
    <link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- MetisMenu CSS -->
    <link href="../../Main/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
    <!-- Custom Fonts -->
<!--	<link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" rel="stylesheet">-->
    <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<!--	<link href="../../Main/vendor/datatables/css/dataTables.bootstrap.min.css" rel="stylesheet">-->
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.bootstrap.min.css" rel="stylesheet">
		
	<!-- JS -->
	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
	<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>
    <!-- Metis Menu Plugin JavaScript -->
    <script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>
    <!-- Custom Theme JavaScript -->
    <script src="../../Main/dist/js/sb-admin-2.js"></script>
    <script src="../../Main/Js/markerclusterer.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<!--    <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>-->
	<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
    
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
	<pack:script src="../../Main/Js/PlayHistory.js"></pack:script>
    <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
    <pack:script src="../../Main/Js/examples1.js"></pack:script>
	
	<style>
		
		.panel-heading{
			padding-bottom: inherit !important;
    		padding-top: inherit !important;
		}
		.panel {
   	 		margin-bottom: 0px;
   	 	}
   	 	
   	 	
   	 	.modal-header {
    		padding: 3px;
    	}
    	
    	
	   
	    .container .checkmark:after {
            left: 9px;
            width: 5px;
            height: 10px;
            border: solid white;
            border-width: 0 3px 3px 0;
            -webkit-transform: rotate(45deg);
            -ms-transform: rotate(45deg);
            transform: rotate(45deg);
        }
        .container {
            padding-left: 35px;
            cursor: pointer;
            font-size: 15px;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }
        .container input {
            position: absolute;
           
            cursor: pointer;
        }
	
        .checkmark {
            position: absolute;
            top: 0;
            left: 0;
            height: 25px;
            width: 25px;
            background-color: #eee;
            border: 1px solid black;
            border-radius: 4px;
        }
        .container:hover input ~ .checkmark {
            background-color: #ccc;
        }
        .container input:checked ~ .checkmark {
            background-color: #2196F3;
        }
        .checkmark:after {
            content: "";
            position: absolute;
            display: none;
        }
        .container input:checked ~ .checkmark:after {
            display: block;
        }
        .checkbox-inline{
            width: 10%;
        }
        .label {
            display: inline;
            padding: .2em .6em .3em;
            font-size: 99%;
            font-weight: 700;
            line-height: 3;
            color: #fff;
            text-align: center;
            white-space: nowrap;
            vertical-align: top !important;
            border-radius: .25em;
        }
        
        
         
          #legend {
        font-family: Arial, sans-serif;
        background: #fff;
        padding: 10px;
        margin: 10px;
        border: 3px solid #000;
      }
      #legend h3 {
        margin-top: 0;
      }
      #legend img {
        vertical-align: middle;
      }
	  	.checkbox input[type=checkbox], .checkbox-inline input[type=checkbox], .radio input[type=radio], .radio-inline input[type=radio] {
			position: absolute;
			margin-left: -20px;
			opacity: 0;
		}
		.dataTables_length{
			
			display:none;
		}.dataTables_filter{
			margin-left: -40%;
		}
		.dataTables_filter {
    text-align: left !important;
}

div.dataTables_wrapper div.dataTables_filter input
{
	    margin-left: 2.5em !important;
    display: inline-block !important;
    width: auto !important;
}
        
	</style>

	 <div class="col-lg-12 col-md-12 row">	
	 
	  <div class="col-xm-12 col-sm-12 col-lg-7 col-md-7">	
			 <div class="panel panel-primary">
			  <div class="panel-heading">Smart Trucks Unassigned</div>
			  <div class="panel-body" style="background-color: white;">
			       <div class="col-md-12 col-lg-12 row">
							<div class="col-lg-6 col-md-6" >
							   <label style="white-space:nowrap" class="container checkbox-inline">Un Assigned <input type="checkbox" onclick='showHub(this);' value=""><span class="checkmark"></span></label>
							</div>
							 <div class="col-lg-6 col-md-6" >
							   <label  style="white-space:nowrap" class="container checkbox-inline">Assigned Enrouted<input id="assignedEnrouted" type="checkbox" value=""><span class="checkmark"></span></label>
							</div>
					</div>
							<div class="col-md-12 col-lg-12 row" style="margin-top:2%">
								<div class="col-lg-6 col-md-6" >
								   <label style="white-space:nowrap ;margin-left: 0px;" class="container checkbox-inline">Assigned Placed<input id="assignedPlaced" type="checkbox" value=""><span class="checkmark"></span></label>
								</div>
								<div class="col-lg-6 col-md-6" style="display: inline-flex;">
								     <label style="white-space:nowrap" class="checkbox-inline">
									<input id="availableTruck" type="checkbox" value=""><span class="checkmark"></span>
									</label>
									<div class="form-group" style="display: inline-flex;">
										  <label style="white-space:pre"  for="sel1" >Trip close in next&nbsp;</label>
										  <select id="hrsId" class="form-control" onchange="plotTrucks()" id="sel1">
											<option>6</option>
											<option>5</option>
											<option>4</option>
											<option>3</option>
											<option>2</option>
											<option>1</option>
										  </select>
										  <label>hours </label>
									</div>
							  </div>
						 
						  
				</div>			
				  <div class="col-lg-12">
							<div id="map" style="width:initial;height: 390px; margin-top: 10px;margin-left: 0px "></div>
							 <div id="legend"><h4>Vehicle Types</h4></div>
				  </div> 
						
				 </div>
			</div>
			</div>
		
		
		 <div class="col-xm-12 col-sm-12 col-lg-5 col-md-5" >	
			 <div class="panel panel-primary">
			  <div class="panel-heading">Smart Truckers Available</div>
			  <div class="panel-body" style="background-color: white;height: 517px;">
							<div class="col-lg-12 col-md-12" >
								<div class="form-group" style=" display: -webkit-inline-box;">
									  <label for="sel1">Drivers: &nbsp;</label>
									  <select id="driverStatus" class="form-control" id="sel1" onchange="loadTable()" >
										<option value="CLOSE" >Unassigned</option>
										<option value="OPEN">Assigned</option>
									  </select>
								</div>
						   </div>
						   
					<div class="col-lg-12 col-md-12" >	   
					<div style="overflow: auto !important;">
						<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:4% !important">
							<thead>
								<tr>
									<th>SLNO</th>
									<th>Driver ID</th>
									<th>DRIVER NAME</th>
								</tr>
							</thead>	
						</table>
					</div>	<!-- end of table -->
					</div>	
			
						
				
			</div>
			</div>
		</div>
		
	</div>
	
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 
	<script>
	
		var countryName = '<%=countryName%>';
      	var map;
      	var mcOptions = {gridSize: 20, maxZoom: 100};
      	var bounds = new google.maps.LatLngBounds();
      	var infowindow;
		var infowindowOne;
      	var tripNo;
      	var vehicleNo;
		var markerFlag;
		var unAssignedMarkers=[];
		var assignedMarkers=[];
		var assignedPlacedMarkers=[];
		var availableTruckMarkers=[];
		var routeId='<%=routeId%>';
        var refreshFlag=true;
		var lineInfo=[];
		
	var icons = {
          parking: {
            name: 'Un Assigned',
            icon: '/ApplicationImages/VehicleImages/redbal.png'
          },
          library: {
            name: 'Assigned Enrouted',
            icon: '/ApplicationImages/VehicleImages/grey.png'
          },
          info: {
            name: 'Assigned Placed',
            icon: '/ApplicationImages/VehicleImages/green.png'
          },
		  trip: {
            name: 'Closing Trip',
            icon: '/ApplicationImages/VehicleImages/yellow.png'
          }
        };
        
		loadData();
      	function loadData()
      	{
			function initialize(){
	      	var mapOptions = {
		        zoom:14,
		        center: new google.maps.LatLng('0.0', '0.0'),
		        mapTypeId: google.maps.MapTypeId.STREET,
		        mapTypeControl: false,
		        gestureHandling: 'greedy' 
		    };
		   	map = new google.maps.Map(document.getElementById('map'), mapOptions);
			var trafficLayer = new google.maps.TrafficLayer();
        	trafficLayer.setMap(map);
			
		var legend = document.getElementById('legend');
         for (var key in icons) {
          var type = icons[key];
          var name = type.name;
          var icon = type.icon;
          var div = document.createElement('div');
          div.innerHTML = '<img src="' + icon + '"> ' + name;
          legend.appendChild(div);
        }

        map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
			
			
		   	//var mapZoom = 14;
		   	var geocoder = new google.maps.Geocoder();
			geocoder.geocode({'address': countryName}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						map.setCenter(results[0].geometry.location);
				    	map.fitBounds(results[0].geometry.viewport);
			    	}
				});
			}
		initialize();
			setInterval( function () {
				if( refreshFlag==true){  
				  loadMaps(); 
				}
			}, 30000*60);	// 30 sec interval
			
			
		loadTable();
	
		function clearMap(){
			if(lineInfo.length > 0){
				for(var k =0; k < lineInfo.length; k++){
					lineInfo[k].setMap(null);
				}
			}
		}
			
			
		}
		function loadTable(){
			<!-- table load -->
		var table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverDetails",
                "dataSrc": "driverIndex",
                "data": {
                    status: document.getElementById("driverStatus").value
                }
            },
			"lengthMenu": [[5, 10, 50, -1], [5, 10, 50, "All"]] ,
            "bDestroy": true,
			  buttons: [ 'excel'],
            "buttons": [{extend:'pageLength'},
	      	 			{extend:'excel',
	      	 				text: 'Export to Excel',
	      	 				className: 'btn btn-primary',
	      	 				title: 'Utilization Details',
	      	 				exportOptions: {
			                 columns: ':visible'
			            }
			        }
	      	 ],
            "columns": [{
                "data": "slno"
            }, {
                "data": "driverId"
            }, {
                "data": "driverName"
            }]
        });
	   }
	    
	    var unAssignedStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getUnAssigendVehiclesLatLng',
				id:'UnAssignedLatLng',
				root: 'UnAssignedLatLng',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','vehicleNo']
		});
		
		var assignedEnroutedStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAssigendEnrouteVehiclesLatLng',
				id:'AssignedEnroutedLatLng',
				root: 'AssignedEnroutedLatLng',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','vehicleNo']
		});
			
		var assignedPlacedStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAssigendPlacedVehiclesLatLng',
				id:'AssignedPlacedLatLng',
				root: 'AssignedPlacedLatLng',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','vehicleNo']
		});
		
			var availableTruckStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getFutureAvailableTrucks',
				id:'futureAvailbleTruckId',
				root: 'futureAvailbleTruck',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','vehicleNo','eta','loc'],
				
		});
			
			
				
	    function showHub(cb){
	    	if(cb.checked){	
	    		unAssignedStore.load({
	    			callback:function(){
	    				plotBuffers();
	    			}
	    		});
	    	}
	    	else
	    	{
	    		for(var i=0;i<unAssignedMarkers.length;i++){
	    			unAssignedMarkers[i].setMap(null);
	    		}
	    	}
	    }
	    
	    $('#assignedEnrouted').change(function() {
            if (this.checked) {
            	assignedEnroutedStore.load({
	    			callback:function(){
	    				getAssignedEnrouted();
	    			}
	    		});
            } else {
               for(var i=0;i<assignedMarkers.length;i++){
	    			assignedMarkers[i].setMap(null);
	    		}
            }
        });
        
        $('#assignedPlaced').change(function() {
            if (this.checked) {
                assignedPlacedStore.load({
	    			callback:function(){
	    				getAssignedPlaced();
	    			}
	    		});
            } else {
               for(var i=0;i<assignedPlacedMarkers.length;i++){
	    			assignedPlacedMarkers[i].setMap(null);
	    		}
            }
        });
		
		 $('#availableTruck').change(function() {
            if (this.checked) {
                availableTruckStore.load({
					params: {hrs: document.getElementById("hrsId").value},
	    			callback:function(){
	    				getAvailableTrucks();
	    			}
	    		});
            } else {
               for(var i=0;i<availableTruckMarkers.length;i++){
	    			availableTruckMarkers[i].setMap(null);
	    		}
            }
        });
		
		
		function plotTrucks(){
			  var status=$('#availableTruck').is(':checked');
			if (status) {
				 for(var i=0;i<availableTruckMarkers.length;i++){
	    			availableTruckMarkers[i].setMap(null);
	    		}
                availableTruckStore.load({
					params: {hrs: document.getElementById("hrsId").value},
	    			callback:function(){
	    				getAvailableTrucks();
	    			}
	    		});
            }
			
		}
	    
	    function plotBuffers()
	    {
			    var infowindow = new google.maps.InfoWindow();
			    var j=0;
				    for(var i=0;i<unAssignedStore.getCount();i++){
				    var rec=unAssignedStore.getAt(i);
				 if(rec.data['latitude']!=0 && rec.data['longitude']!=0){
				       var urlForZero='/ApplicationImages/VehicleImages/information.png';
				       //alert(i+' '+rec.data['latitude']+','+rec.data['longitude']);
				   		myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
		                markerFlag = new google.maps.Marker({
		                position: myLatLng,
		                type: 'Un Assigned',
		                map: map,
		                	icon:'/ApplicationImages/VehicleImages/redbal.png'
		                });
		                
		                var infowindow = new google.maps.InfoWindow();
		                google.maps.event.addListener(markerFlag, 'click', (function(markerFlag, i) {
		        		return function() {
		        		//alert(rec.data['latitude']+','+rec.data['longitude']);
		           infowindow.setContent(rec.data['latitude']+'\n'+rec.data['longitude']);
		           infowindow.open(map, markerFlag);
		        }
		      })(markerFlag, j));	
		      markerFlag.setAnimation(google.maps.Animation.DROP);  
		      
		      unAssignedMarkers[j]=markerFlag;
		      j=j+1;
     		}	
		};
	}
	
	 function getAssignedEnrouted(){
           var infowindow = new google.maps.InfoWindow();
            var j=0;
				    for(var i=0;i<assignedEnroutedStore.getCount();i++){
				    var rec=assignedEnroutedStore.getAt(i);
				    if(rec.data['latitude']!=0 && rec.data['longitude']!=0){
				    var urlForZero='/ApplicationImages/VehicleImages/information.png';
				   // alert(assignedEnroutedStore.getCount());
				    //alert(i+' '+rec.data['latitude']+','+rec.data['longitude']);
				   		myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
		                markerFlag = new google.maps.Marker({
		                position: myLatLng,
		                type: 'Assigned Enrouted',
		                map: map,
		                	icon:'/ApplicationImages/VehicleImages/grey.png'
		                });
		                
		                var infowindow = new google.maps.InfoWindow();
		                google.maps.event.addListener(markerFlag, 'click', (function(markerFlag, i) {
		        		return function() {
		        		//alert(rec.data['latitude']+','+rec.data['longitude']);
		           infowindow.setContent(rec.data['latitude']+','+rec.data['longitude']);
		          infowindow.open(map, markerFlag);
		        }
		      })(markerFlag, j));	
		      markerFlag.setAnimation(google.maps.Animation.DROP);  
		      
		      assignedMarkers[j]=markerFlag;
		       j=j+1;
     		}
		};
     }
  
  	 function getAssignedPlaced(){
           var infowindow = new google.maps.InfoWindow();
           var j=0;
				    for(var i=0;i<assignedPlacedStore.getCount();i++){
				   var rec=assignedPlacedStore.getAt(i);
				    //alert(assignedPlacedStore.getCount());
				    if(rec.data['latitude']!=0 && rec.data['longitude']!=0){
				    var urlForZero='/ApplicationImages/VehicleImages/information.png';
				    //alert(i+' '+rec.data['latitude']+','+rec.data['longitude']);
				   		myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
		                markerFlag = new google.maps.Marker({
		                position: myLatLng,
		                type: 'Assigned Placed',
		                map: map,
		                	icon:'/ApplicationImages/VehicleImages/green.png'
		                });
		                
		                var infowindow = new google.maps.InfoWindow();
		                google.maps.event.addListener(markerFlag, 'click', (function(markerFlag, i) {
		        		return function() {
		        		//alert(rec.data['latitude']+','+rec.data['longitude']);
		           infowindow.setContent(rec.data['latitude']+','+rec.data['longitude']);
		          infowindow.open(map, markerFlag);
		        }
		      })(markerFlag, j));	
		      markerFlag.setAnimation(google.maps.Animation.DROP);  
		      assignedPlacedMarkers[j]=markerFlag;
		      j=j+1;
     		}
		};
     }
	 
	  function getAvailableTrucks(){
           var infowindow = new google.maps.InfoWindow();
           var j=0;
				    for(var i=0;i<availableTruckStore.getCount();i++){
				   var rec=availableTruckStore.getAt(i);
				    //alert(availableTruckStore.getCount());
				    if(rec.data['latitude']!=0 && rec.data['longitude']!=0){
				    var urlForZero='/ApplicationImages/VehicleImages/yellow.png';
				    //alert(i+' '+rec.data['latitude']+','+rec.data['longitude']);
				   		myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
		                markerFlag = new google.maps.Marker({
		                position: myLatLng,
		                type: 'Closing Trip',
		                map: map,
		                	icon:'/ApplicationImages/VehicleImages/yellow.png'
		                });
		                
		                var infowindow = new google.maps.InfoWindow();
		                google.maps.event.addListener(markerFlag, 'click', (function(markerFlag, i) {
							var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
												'<table>' +
												'<tr><td><b>Vehicle No:</b></td><td>' +rec.data['vehicleNo']+ '</td></tr>' +
												'<tr><td><b>Location:</b></td><td>' +rec.data['loc']+ '</td></tr>' +
												'<tr><td><b>Eta:</b></td><td>' +rec.data['eta']+ '</td></tr>' +
												'</table>' +
												'</div>';
					return function() {
		        		//alert(rec.data['latitude']+','+rec.data['longitude']);
		           infowindow.setContent(content);
		          infowindow.open(map, markerFlag);
		        }
		      })(markerFlag, j));	
		      markerFlag.setAnimation(google.maps.Animation.DROP);  
		      availableTruckMarkers[j]=markerFlag;
		      j=j+1;
     		}
		};
     }
     
     
	</script>
<jsp:include page="../Common/footer.jsp" />
