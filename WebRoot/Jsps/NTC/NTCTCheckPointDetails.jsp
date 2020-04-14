<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
%>

            <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
            <html>

            <head>
                <base href="<%=basePath%>">

                <title>My JSP 'NTCTCheckPointDetails.jsp' starting page</title>

                <meta http-equiv="pragma" content="no-cache">
                <meta http-equiv="cache-control" content="no-cache">
                <meta http-equiv="expires" content="0">
                <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
                <meta http-equiv="description" content="This is my page">
                <pack:script src="../../Main/Js/jquery.min.js"></pack:script>
				<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>
                <pack:script src="../../Main/Js/jQueryMask.js"></pack:script>
                <pack:style src="../../Main/modules/common/jquery.loadmask.css" />
                <style type="text/css">
                    input[type=text],
                    input[type=password],
                    textarea,
                    select,
                    input[type=number] {
                        display: inline-block;
                        padding: 6px 12px;
                        font-size: 14px;
                        line-height: 1.428571429;
                        color: #555;
                        vertical-align: middle;
                        background-color: #fff;
                        background-image: none;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
                        box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
                        -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
                        transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
                    }

                    button,
                    html input[type="button"],
                    input[type="reset"],
                    input[type="submit"] {
                        display: inline-block;
                        padding: 6px 12px;
                        margin-bottom: 0;
                        font-size: 14px;
                        font-weight: normal;
                        line-height: 1.428571429;
                        text-align: center;
                        white-space: nowrap;
                        vertical-align: middle;
                        cursor: pointer;
                        background-image: none;
                        border: 1px solid transparent;
                        border-radius: 4px;
                        -webkit-user-select: none;
                        -moz-user-select: none;
                        -ms-user-select: none;
                        -o-user-select: none;
                        user-select: none;
                        background-color: #4bc2e8;
                    }

                    body {
                        font-family: Arial;
                        font-size: 10pt;
                    }

                    #panel {
                        padding-bottom: 10px;
                    }

                    #saveBtn {
                        margin-left: 46px;
                    }
                </style>
            </head>

            <body>
                <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry,drawing&key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"></script>
                <script type="text/javascript">
                    var source, destination;
                    var directionsDisplay;
                    var Slatlong;
                    var Dlatlong;
                    var jsonArray = [];
                    var routeId;
                    var radius;
                    var Lat;
                    var Lng;
                    var infoWindow;
                    var MarkerinfowinArr=[];
                    var circles;
                    var marker;
                    var dirDspArray = [];
                    $(function() {
                         getRouteNames();
                    });

                    function getRouteNames() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getRouteNames',
                            success: function(response) {
                                routeList = JSON.parse(response);
                                var $routeName = $('#route_name');
                                $.each(routeList, function() {
                                    $('<option id=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeName);
                                });
                            }
                        });
                        $('#route_name').change(function() {
                        	document.getElementById("checkBtn").disabled = false;
                            routeId = $('option:selected').attr('id');
                            if (directionsDisplay != null) {
			                   directionsDisplay.setMap(null);
			                }
			                for (var i = 0; i < MarkerinfowinArr.length; i++) {
                                MarkerinfowinArr[i].setMap(null);
                            }
                            for (var i = 0; i < dirDspArray.length; i++) {
					            dirDspArray[i].setMap(null);
					        }
                            getRoute(routeId);
                            getLatLongForMarker();
                        });
                    }

                    function getRoute(routeId) {
                    	$("#dvMap").mask({'label':"Waiting..."});
                        $.ajax({
                            url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getRouteDetails1',
                            data: {
                                routeId: routeId
                            },
                            success: function(response) {
                                var obj = JSON.parse(response);
                                size = obj["latLongRoot"].length;
                                var waypts = [];
                                for (i = 0; i <= obj["latLongRoot"].length - 1;) {
                                    var directionsService = new google.maps.DirectionsService;
                                    directionsDisplay = new google.maps.DirectionsRenderer({
                                        map: map
                                        //draggable: true
                                    });
                                    
                                    if (size > 10) {
                                        for (var k = i; k < i + 8; k++) {
                                            waypts.push({
                                                location: new google.maps.LatLng(obj["latLongRoot"][k + 1].lat, obj["latLongRoot"][k + 1].lng),
                                                stopover: true
                                            });
                                        }
                                        addPath(obj["latLongRoot"][i].lat + ',' + obj["latLongRoot"][i].lng, obj["latLongRoot"][i + 9].lat + ',' + obj["latLongRoot"][i + 9].lng, directionsService, directionsDisplay, waypts);
                                        size = size - 9;
                                        waypts = [];
                                        i = i + 9;
                                    } else {
                                        for (var j = i + 1; j < obj["latLongRoot"].length - 1; j++) {
                                            waypts.push({
                                                location: new google.maps.LatLng(obj["latLongRoot"][j].lat, obj["latLongRoot"][j].lng),
                                                stopover: true
                                            });
                                        }
                                        addPath(obj["latLongRoot"][i].lat + ',' + obj["latLongRoot"][i].lng, obj["latLongRoot"][obj["latLongRoot"].length - 1].lat + ',' + obj["latLongRoot"][obj["latLongRoot"].length - 1].lng, directionsService, directionsDisplay, waypts);
                                        i = obj["latLongRoot"].length + 1;
                                    }
                                }
                                $("#dvMap").unmask();
                            }
                        });
                    }
                    var obj1;
                    function getLatLongForMarker(){
                    $("#dvMap").mask();
                    	$.ajax({
                            url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getLatLongForMarker',
                            data: {
                                routeId: routeId
                            },
                            success: function(response) {
                                obj1 = JSON.parse(response);
                                size = obj1["latLongRoot1"].length;
                                for (i = 0; i <= obj1["latLongRoot1"].length - 1; i++) {
                                	var myLocLatLng = new google.maps.LatLng(obj1["latLongRoot1"][i].lat,obj1["latLongRoot1"][i].lng);
                                	plotLocationMarker(myLocLatLng,i);
                                }
                                $("#dvMap").unmask();
                            }
                        });
                     }

                    function addPath(latlongorigin, latlongDestination, directionsService, directionsDisplay, waypts) {
                        directionsService.route({
                            origin: latlongorigin,
                            destination: latlongDestination,
                            waypoints: waypts,
                            travelMode: google.maps.TravelMode.DRIVING
                        }, function(response, status) {
                            if (status === google.maps.DirectionsStatus.OK) {
                                directionsDisplay.setDirections(response);
                                 dirDspArray.push(directionsDisplay);
                            } else if (status === google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                                setTimeout(function() {
                                    addPath(latlongorigin, latlongDestination, directionsService, directionsDisplay, waypts);
                                }, 500);
                            } else {
                                console.log("10 request per 1 sec");
                            }
                        });

                    }

                    function loadMap() {
                    	document.getElementById("checkBtn").disabled = true;
                        var mode;
                        var dmodes;
                        mode = google.maps.drawing.OverlayType.CIRCLE;
                        dmodes = 'circle';
                        drawingManager = new google.maps.drawing.DrawingManager({
                            drawingMode: mode,
                            drawingControl: true,
                            drawingControlOptions: {
                                position: google.maps.ControlPosition.TOP_CENTER,
                                drawingModes: [dmodes]
                            },
                            circleOptions: {
                                fillColor: '',
                                fillOpacity: 0.1,
                                strokeWeight: 2,
                                clickable: false,
                                editable: true,
                                zIndex: 1,
                                clickable: true
                            }
                        });
                        drawingManager.setMap(map);
						
                        google.maps.event.addListener(drawingManager, 'circlecomplete', function(circle) {
                            circles = circle;
                            drawingManager.setOptions({
                                drawingControl: false
                            });
                            drawingManager.setDrawingMode(null);
                            radius = circle.getRadius() / 1000;
                            Lat = circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                            Lng = circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                            
                            google.maps.event.addListener(circle, 'click', function() {
                            	getInfoWindowOnCircle(radius,circle);
                               
                            });
                            google.maps.event.addListener(circle, 'radius_changed', function() {
                                radius = circle.getRadius() / 1000;
                                Lat = circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                Lng = circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                
                            });
                            google.maps.event.addListener(circle, 'center_changed', function() {
                                radius = circle.getRadius() / 1000;
                                Lat = circle.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                Lng = circle.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1");
                                var pos = new google.maps.LatLng(Lat, Lng);

                            });
							document.getElementById("checkBtn").disabled = false;
                        });
                    }
                    function  getInfoWindowOnCircle(radius1,circle){
                    	var contentString = ' <div > ' +
                            ' <span>Hub Name</span> ' +
                            ' <input type="text" id="hubName" value="" style="width: 260px;margin-bottom: 6px;margin-left: 10px;" /><br> ' +
                            ' <span>Remarks</span>' +
                            ' <input type="text" id="remarks" value="" style="width: 260px;margin-bottom: 6px;margin-left: 20px;" /><br> ' +
                            ' <span>Alert Type</span> ' +
                            ' <select name="alerttype" id="alertType" style="width: 260px;margin-bottom: 6px;margin-left: 13px;">' +
             			    ' <option id="">Select Alert Type</option> ' +
             			    ' <option id="">Before</option> ' +
             			    ' <option id="">Inside</option> ' +
             			    ' <option id="">After</option> ' +
             				' </select> <br>' +
                            ' <span>Alert Radius(Kms)</span>' +
                            ' <input type="number" id="alertRad" step="any" value="" style="   awidth: 260px;margin-bottom: 6px;margin-left: 2px;" /><br>' +
                            ' <p style="font-weight: bold;">Hub Radius(Kms):   '+radius1.toFixed(2)+'</p>' +
                            ' <input type="button"  value="Save" id="saveInfo" onclick="saveInfoW;aindowDetails()" />' +
                            ' <input type="button"  value="Cancel" id="cancelInfo" onclick="cancel()" />' +
                            ' </div> ';
                        infoWindow = new google.maps.InfoWindow({
                            content: contentString
                        });
                        infoWindow.setPosition(circle.getCenter());
                        //infoWindow.setContent($("#iw-content").prop("innerHTML"));
                        infoWindow.open(map, circle);
					}

                    function initialize() {
                        var mumbai = new google.maps.LatLng(22.89, 78.88);
                        var mapOptions = {
                            zoom: 7,
                            center: mumbai
                        };
                        map = new google.maps.Map(document.getElementById('dvMap'), mapOptions);
                    }
                    google.maps.event.addDomListener(window, 'load', initialize);

                    function saveInfoWindowDetails() {
                    $("#dvMap").mask();
                        $.ajax({
                            url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=saveInfoWindowDetails',
                            type: "POST",
                            data: {
                                hubName: document.getElementById("hubName").value,
                                remarks: document.getElementById("remarks").value,
                                alertType: document.getElementById("alertType").value,
                                alertRadius: document.getElementById("alertRad").value,
                                routeId: routeId,
                                latitude: Lat,
                                longitude: Lng,
                                hubRad: radius
                            },
                            success: function(response) {
                                //message = JSON.parse(response);
                                 getLatLongForMarker();
                                 $("#dvMap").unmask();
                            }
                        });
                        $('#hubName').val("");
                        $('#remarks').val("");
                        $('#alertType').val("");
                        $('#alertRad').val("");
                        infoWindow.close();
                        circles.setMap(null);
                        
                    }
                    function cancel() {
                        $('#hubName').val("");
                        $('#remarks').val("");
                        $('#alertType').val("");
                        $('#alertRad').val("");
                        infoWindow.close();
                    }
                     function plotLocationMarker(myLocLatLng,id){
					     var image = {
					            url: '/ApplicationImages/VehicleImages/blue1.png', // This marker is 20 pixels wide by 32 pixels tall.
					            size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
					            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
					            anchor: new google.maps.Point(0, 32)
					        };
					        var markerContent='';
					        marker = new google.maps.Marker({
					            map: map,
					            position: myLocLatLng,
					            icon: image
					        });
					        marker.set("id", id);
					        MarkerinfowinArr.push(marker);
							google.maps.event.addListener(marker, "click", function (event) {
								
							markerContent=' <div > ' +
							' <table class="infotable">'+	
							' <tr><td style="font-weight: bold;">Hub Name:</td><td>'+obj1["latLongRoot1"][this.id].hubName+'</td></tr>'+	
							' <tr><td style="font-weight: bold;">Remarks:</td><td>'+obj1["latLongRoot1"][this.id].remarks+'</td></tr>'+	
							' <tr><td style="font-weight: bold;">Alert Type:</td><td>'+obj1["latLongRoot1"][this.id].alertType+'</td></tr>'+	
							' <tr><td style="font-weight: bold;">Alert Radius:</td><td>'+obj1["latLongRoot1"][this.id].alertRadius+'</td></tr>'+	
							' <tr><td style="font-weight: bold;">Hub Radius:</td><td>'+obj1["latLongRoot1"][this.id].hubRadius+'</td></tr>'+		
	                        ' </div> ';
	                         var Markerinfowindow=new google.maps.InfoWindow({
					           content: markerContent,
					           minWidth:400,
	    					   maxWidth: 400
					         });
					        
					         if (Markerinfowindow) {
	          					Markerinfowindow.close(); 
	          			     }
	                         Markerinfowindow.open(map, this);
							}); 
					  }
                </script>

                <div id="modifyPanelId">
                    <span>Select Route</span>
             		<select class="form-control" name="size" id="route_name">
             			<option id="">Select Route Name</option>
             		</select>
             		<input type="button" value="Create Check Point" id="checkBtn" onclick="loadMap()" />
                </div>
                <div id="dvMap" style="width: 1300px; height: 417px; margin-top: 18px;margin-left: 11px "></div>
                <div class="note"><p id="noteId" style="font-weight: bold;">Note: Please Create the checkpoints on the route</p>
		         </div>
            </body>

            </html>