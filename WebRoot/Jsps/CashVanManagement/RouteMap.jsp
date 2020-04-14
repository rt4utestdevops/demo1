<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
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
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
		loginInfo.setCustomerName(str[8].trim());
	}
	
	if(str.length>12){
		loginInfo.setStyleSheetOverride(str[12].trim());	
	}
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
String customerName1 = loginInfo.getCustomerName();
int custId= 0;
String buttonValue="";
int routeId=0;
String routeName="";
String source="";
String destination="";
String actualduration="";
String expDuration="";
float actualDistance=0;
float expDistance=0;
String trigger1="";
String trigger2="";
String routeDesp="";
String custName="";
int radius=0;
float SourceRadius=0;
float destRadius=0;
if(request.getParameter("custId") != null && !request.getParameter("custId").equals("")){
	custId = Integer.parseInt(request.getParameter("custId")); 
}
if(request.getParameter("buttonValue") != null && !request.getParameter("buttonValue").equals("")){
	buttonValue = request.getParameter("buttonValue");
}
if(request.getParameter("routeId") != null && !request.getParameter("routeId").equals("")){
	routeId = Integer.parseInt(request.getParameter("routeId")); 
}		
if(request.getParameter("routeName") != null && !request.getParameter("routeName").equals("")){
	routeName = request.getParameter("routeName"); 
}
if(request.getParameter("source") != null && !request.getParameter("source").equals("")){
	source = request.getParameter("source"); 
}
if(request.getParameter("destination") != null && !request.getParameter("destination").equals("")){
	destination = request.getParameter("destination"); 
}
if(request.getParameter("actualDistance") != null && !request.getParameter("actualDistance").equals("")){
	actualDistance = Float.parseFloat(request.getParameter("actualDistance")); 
}
if(request.getParameter("expDistance") != null && !request.getParameter("expDistance").equals("")){
	expDistance = Float.parseFloat(request.getParameter("expDistance")); 
}
if(request.getParameter("actualduration") != null && !request.getParameter("actualduration").equals("")){
	actualduration = request.getParameter("actualduration"); 
}
if(request.getParameter("expDuration") != null && !request.getParameter("expDuration").equals("")){
	expDuration = request.getParameter("expDuration"); 
}
if(request.getParameter("trigger1") != null && !request.getParameter("trigger1").equals("")){
	trigger1 = request.getParameter("trigger1"); 
}
if(request.getParameter("trigger2") != null && !request.getParameter("trigger2").equals("")){
	trigger2 =  request.getParameter("trigger2");
}
if(request.getParameter("routeDesp") != null && !request.getParameter("routeDesp").equals("")){
	routeDesp =  request.getParameter("routeDesp");
}
if(request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
	custName =  request.getParameter("custName");
}
if(request.getParameter("radius") != null && !request.getParameter("radius").equals("")){
	radius =  Integer.parseInt(request.getParameter("radius"));
}
if(request.getParameter("SourceRadius") != null && !request.getParameter("SourceRadius").equals("")){
	SourceRadius =  Float.parseFloat(request.getParameter("SourceRadius"));
}
if(request.getParameter("destRadius") != null && !request.getParameter("destRadius").equals("")){
	destRadius =  Float.parseFloat(request.getParameter("destRadius"));
}

Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
%>
<!DOCTYPE HTML>
<html>
<head>
<title>RouteCreation</title>
  <script src=<%=GoogleApiKey%>></script>
  
   <style>
   #room_fileds{
   height:500px;
   max-height: 357px;
   overflow: auto;
   background-color:#fff;
   border: solid 2px #A5BED1;
   }
   #pac-dest{
   height: 28px;
   margin-right: -362px;
   }
   #pac-origin{
   height: 28px;
   margin-right: 318px;
   }
   </style>
</head>
<body onload="CallRoute1()">
<div id="room_fileds1" style="visibility: hidden;height:0px;">
            <div>
              <span><input id="lat" type="text" style="width:142px;" name="lati" value="" readOnly/><input  id="long" type="text" style="width:142px;" name="longi" value="" readOnly/></span> 
           </div>
        </div>
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
<script>
    var outerPanel;
    var ctsb;
    var jsonArray = [];
    var routeCount = 0;
    var latArray = [];
    var k = 0;
    var map;
    var polyLine;
    var polyOptions;
    var markers = [];
    var latArray = [];
    var route = 0;
    var route1 = 0;
    var jsonArray1 = [];
    var custId = '<%=custId%>';
    var buttonValue = '<%=buttonValue%>';
    var routeId = '<%=routeId%>';
    var custName = '<%=custName%>';
    var searchBox;
    var outerPanelWindow;
    var latlongorigin = '0,0';
    var latlongDestination = '0,0';
    var directionsDisplay;
    var distance;
    var duration;
    var markerArray = [];
    var routeMarker;
    var markers1 = [];
    var dirDspArray = [];
    var myLatLngDest;
    var myLatLngOrigin;
    var createCircle;
    var createTrigCircle;
    var circle;
    var trigCircle;
    var haltCircle;
    var createHaltCircle;
    var triggerArray = [];
    var circleArray = [];
    var trigCircleArray = [];
    var haltCircleArray = [];
    var haltDataArray=[];
    var gmarker = [];
    var latitudeP=0;
    var longitudeP=0;
    var saveBtn;
    var hmarker=[];
    var Lmarker;
    var currentRoute;
    var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Saving" });
    var haltCount=0;
   
    function initialize() {
        var opts = {
            'center': new google.maps.LatLng(22.89, 78.88),
            'zoom': 5,
            'mapTypeId': google.maps.MapTypeId.ROADMAP
        }
        map = new google.maps.Map(document.getElementById('mapid'), opts);

        google.maps.event.addListener(map, 'click', function (event) {
        if(Lmarker!=null){
           Lmarker.setMap(null);
        }
         latitudeP = event.latLng.lat();
         longitudeP = event.latLng.lng();
         var myLocLatLng = new google.maps.LatLng(latitudeP,longitudeP);
         plotLocationMarker(myLocLatLng);
   }) 
        //searchBox1(map, 'pac-origin');
        //searchBox1(map, 'pac-dest');
    }

    function plotDrag(result, markerArray, map, directionsDisplay) {
        var myRoute = result.routes[0].legs[0];
        for (var i = 0; i < markerArray.length; i++) {
            markerArray[i].setMap(null);
        }
        jsonArray = [];
		distance = directionsDisplay.directions.routes[0].legs[0].distance.text;
		duration = directionsDisplay.directions.routes[0].legs[0].duration.text;
        var formattedDuration;
        var formattedMin;
        var formattedHours1;
        var formattedMin1;
        if (duration.indexOf("mins") >= 2 && duration.indexOf("hours") == -1) {
            formattedMin1 = duration.split("mins");
            formattedHours = '0';
            Ext.getCmp('actualKmId').setValue(distance.replace(",", ""));
            Ext.getCmp('actualTimeId').setValue(formattedHours + "." + formattedMin1[0]);
        }
        if (duration.indexOf("hour") >= 2) {
            if (duration.indexOf("hours") >= 2) {
                formattedHours = duration.split("hours");
                formattedMin = formattedHours[1].split("mins");
                Ext.getCmp('actualKmId').setValue(distance.replace(",", ""));
                Ext.getCmp('actualTimeId').setValue(formattedHours[0].trim() + "." + formattedMin[0].trim().replace("s", ""));
            } else {
                formattedHours = duration.split("hour");
                formattedMin = formattedHours[1].split("mins");
                Ext.getCmp('actualKmId').setValue(distance.replace(",", ""));
                Ext.getCmp('actualTimeId').setValue(formattedHours[0].trim() + "." + formattedMin[0].trim().replace("s", ""));
            }
        }
        if (duration.indexOf("day") >= 2) {
            if (duration.indexOf("days") >= 2) {
                formattedHours1 = duration.split("days");
                formattedMin1 = formattedHours1[1].split("hours");
                formattedHours = (((formattedHours1[0].trim()) * 24) + parseInt(formattedMin1[0].trim()));
                formattedMin = '0';
                Ext.getCmp('actualKmId').setValue(distance.replace(",", ""));
                Ext.getCmp('actualTimeId').setValue(formattedHours + "." + formattedMin);
            } else {
                formattedHours1 = duration.split("day");
                formattedMin1 = formattedHours1[1].split("hours");
                formattedHours = (((formattedHours1[0].trim()) * 24) + parseInt(formattedMin1[0].trim()));
                formattedMin = '0';
                Ext.getCmp('actualKmId').setValue(distance.replace(",", ""));
                Ext.getCmp('actualTimeId').setValue(formattedHours + "." + formattedMin);
            }
        }
         currentRoute = result.routes[0].overview_path; 
         for (var i = 0; i < currentRoute.length; i++) {
         jsonArray.push('{' + (i + 1) + ',' + currentRoute[i].lat() + ',' + currentRoute[i].lng() + '}');
         }
<!--         for (var i = 0; i < myRoute.steps.length; i++) {-->
<!--            routeMarker = markerArray[i] = markerArray[i] || new google.maps.Marker;-->
<!--            routeMarker.setMap(map);-->
<!--            routeMarker.setPosition(myRoute.steps[i].start_location);-->
<!--            lat = myRoute.steps[i].start_location.lat();-->
<!--            lng = myRoute.steps[i].start_location.lng();-->
<!--            //jsonArray.push('{' + (i + 1) + ',' + lat + ',' + lng + '}');-->
<!--        }-->
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
            }else {
                console.log("10 request per 1 sec");
            }
        });
       
    }
    function setPolyPoints(map,polylatlongs){
	  var line = new google.maps.Polyline({
	    path: polylatlongs,
	    strokeColor: '#6699FF',
	     map: map
	  });
	  line.setMap(map);
	  //zoomToObject(line);
   }
    function CallRoute1() {
        setTimeout(function() {
            CallRoute();
        }, 500);
    }

    function CallRoute() {
        if (buttonValue == 'Modify') {
            Ext.getCmp('saveButtonId').hide();
            Ext.getCmp('canButtId').hide();
            
            Ext.getCmp('haltpanelId').hide();
            
            Ext.getCmp('sourcecomboId').setValue('<%=source%>');
            Ext.getCmp('destinationcomboId').setValue('<%=destination%>');
            Ext.getCmp('trigger1comboId').setValue('<%=trigger1%>');
            Ext.getCmp('routeNameId').setValue('<%=routeName%>');
            Ext.getCmp('expectedkmId').setValue('<%=expDistance%>');
            Ext.getCmp('actualKmId').setValue('<%=actualDistance%>');
            Ext.getCmp('expectedTimeId').setValue('<%=expDuration%>');
            Ext.getCmp('actualTimeId').setValue('<%=actualduration%>');
            Ext.getCmp('routeDescriptionId').setValue('<%=routeDesp%>');
            Ext.getCmp('radiusId').setValue('<%=radius%>');
         
            Ext.getCmp('sourcecomboId').disable();
            Ext.getCmp('destinationcomboId').disable();
            Ext.getCmp('trigger1comboId').disable();
            Ext.getCmp('trigger2comboId').disable();
            Ext.getCmp('routeNameId').disable();
            Ext.getCmp('expectedkmId').disable();
            Ext.getCmp('actualKmId').disable();
            Ext.getCmp('expectedTimeId').disable();
            Ext.getCmp('actualTimeId').disable();
            Ext.getCmp('routeDescriptionId').disable();
            Ext.getCmp('radiusId').disable();
            
          
            triggerPointStore.load({
                params: {
                    CustId: custId,
                    RouteId: routeId
                },
                callback: function() {
                    for (i = 0; i <= triggerPointStore.getCount() - 1; i++) {
                        var tradius = triggerPointStore.getAt(i).data['TRADIUS'] * 1000;
                        var latlng = new google.maps.LatLng(triggerPointStore.getAt(i).data['Tlat'], triggerPointStore.getAt(i).data['Tlong']);
                        DrawCircleForTriggers(latlng, tradius);
                        plotMarker(latlng);
                    }
                }
            });
            
             haltStore.load({
                params: {
                    CustId: custId,
                    RouteId: routeId
                },
                callback: function() {
                    for (var z = 0; z <= haltStore.getCount() - 1; z++) {
                        var hradius = haltStore.getAt(z).data['HRADIUS'] * 1000;
                        var Hlatlng = new google.maps.LatLng(haltStore.getAt(z).data['Hlat'], haltStore.getAt(z).data['Hlong']);
                        DrawCircleForHalt(Hlatlng, hradius);
                        plotHaltMarker(Hlatlng);
                    }
                }
            });
            
            
            routedetailsstore.load({
                params: {
                    CustId: custId,
                    RouteId: routeId
                },
                callback: function() {
                    var size = routedetailsstore.getCount();
                    var waypts = [];
                    var radius;
                    var polylatlongs = [];
                    for (i = 0; i < routedetailsstore.getCount(); i++) {
                         var rec = routedetailsstore.getAt(i);
                         var latlon= new google.maps.LatLng(rec.data['lat'], rec.data['long']);
                         polylatlongs.push(latlon);
                         setPolyPoints(map,polylatlongs);

                    }
<!--                    for (i = 0; i <= routedetailsstore.getCount() - 1;) {-->
<!---->
<!--                        var directionsService = new google.maps.DirectionsService;-->
<!--                        directionsDisplay = new google.maps.DirectionsRenderer({-->
<!--                            map: map,-->
<!--                            draggable: true-->
<!--                        });-->
<!---->
<!--                        if (size > 10) {-->
<!--                            for (var k = i; k < i + 8; k++) {-->
<!--                                waypts.push({-->
<!--                                    location: new google.maps.LatLng(routedetailsstore.getAt(k + 1).data['lat'], routedetailsstore.getAt(k + 1).data['long']),-->
<!--                                    stopover: true-->
<!--                                });-->
<!--                            }-->
<!--                            addPath(routedetailsstore.getAt(i).data['lat'] + ',' + routedetailsstore.getAt(i).data['long'], routedetailsstore.getAt(i + 9).data['lat'] + ',' + routedetailsstore.getAt(i + 9).data['long'], directionsService, directionsDisplay, waypts);-->
<!--                            size = size - 9;-->
<!--                            waypts = [];-->
<!--                            i = i + 9;-->
<!--                        } else {-->
<!--                            for (var j = i + 1; j < routedetailsstore.getCount() - 1; j++) {-->
<!--                                waypts.push({-->
<!--                                    location: new google.maps.LatLng(routedetailsstore.getAt(j).data['lat'], routedetailsstore.getAt(j).data['long']),-->
<!--                                    stopover: true-->
<!--                                });-->
<!--                            }-->
<!--                            addPath(routedetailsstore.getAt(i).data['lat'] + ',' + routedetailsstore.getAt(i).data['long'], routedetailsstore.getAt(routedetailsstore.getCount() - 1).data['lat'] + ',' + routedetailsstore.getAt(routedetailsstore.getCount() - 1).data['long'], directionsService, directionsDisplay, waypts);-->
<!--                            i = routedetailsstore.getCount() + 1;-->
<!--                        }-->
<!--                    }-->
                    for (var t = 0; t <= routedetailsstore.getCount() - 1;) {
                        var sPoint = new google.maps.LatLng(routedetailsstore.getAt(t).data['lat'], routedetailsstore.getAt(t).data['long']);
                        if(routedetailsstore.getAt(t).data['type'] == 'SOURCE'){
                            radius='<%=SourceRadius%>';
                        }if(routedetailsstore.getAt(t).data['type'] == 'DESTINATION'){
                            radius='<%=destRadius%>';
                        }
                        DrawCircle(sPoint, radius*1000);
                        plotRouteMarker(sPoint);
                        t = t + ((routedetailsstore.getCount()) - 1);
                    }
                }
            });
        }
    }

    var SourcecomboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getSourceAndDestination',
        id: 'hubStoreId',
        root: 'sourceRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['Hub_Id', 'Hub_Name', 'latitude', 'longitude', 'radius']
    });
    
    var destcomboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getSourceAndDestination1',
        id: 'hubStoreId1',
        root: 'sourceRoot1',
        autoLoad: false,
        remoteSort: true,
        fields: ['Hub_Id', 'Hub_Name', 'latitude', 'longitude', 'radius']
    });

    var routedetailsstore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getLatLongs',
        id: 'RouteDetailstoreId',
        root: 'latLongRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['sequence', 'lat', 'long', 'type']
    });

    var triggerPointStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getTriggerPointLatLongs',
        id: 'tiggerstoreId',
        root: 'triggerRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['Tlat', 'Tlong', 'TRADIUS']
    });

   var haltStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getHaltLatLongs',
        id: 'haltstoreId',
        root: 'haltRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['Hlat', 'Hlong', 'HRADIUS']
    });
    
    var sourceCombo = new Ext.form.ComboBox({
        store: SourcecomboStore,
        id: 'sourcecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Source',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        width: 170,
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('destinationcomboId').reset();
                    Ext.getCmp('trigger1comboId').reset();
                    Ext.getCmp('trigger2comboId').reset();
                    myLatLngOrigin = '0.0,0.0';
                    myLatLngDest = '0.0,0.0';
                    for (var i = 0; i < circleArray.length; i++) {
                       circleArray[i].setMap(null);
                    }
                    for (var i = 0; i < gmarker.length; i++) {
                        gmarker[i].setMap(null);
                    }
                    plotRoute(myLatLngOrigin, myLatLngDest);
                    var source = Ext.getCmp('sourcecomboId').getValue();
                    var idO = SourcecomboStore.find('Hub_Id', source);
                    var recordO = SourcecomboStore.getAt(idO);
                    var convertintomtrs = recordO.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(recordO.data['latitude'], recordO.data['longitude']);
                    DrawCircle(myLatLng, convertintomtrs);
                }
            }
        }
    });


    var destinationCombo = new Ext.form.ComboBox({
        store: destcomboStore,
        id: 'destinationcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Destination',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        width: 170,
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                    if (Ext.getCmp('sourcecomboId').getValue() == Ext.getCmp('destinationcomboId').getValue()) {
                        Ext.example.msg("Source and destination should not be same");
                        Ext.getCmp('destinationcomboId').reset();
                        return;
                    }
                    var source = Ext.getCmp('sourcecomboId').getValue();
                    var destination = Ext.getCmp('destinationcomboId').getValue();
                    var idO = SourcecomboStore.findExact('Hub_Id', source);
                    var idD = destcomboStore.findExact('Hub_Id', destination);
                    var recordO = SourcecomboStore.getAt(idO);
                    var recordD = destcomboStore.getAt(idD);
                    myLatLngOrigin = recordO.data['latitude'] + ',' + recordO.data['longitude'];
                    myLatLngDest = recordD.data['latitude'] + ',' + recordD.data['longitude'];
                    plotRoute(myLatLngOrigin, myLatLngDest);
                    var convertintomtrs = recordD.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(recordD.data['latitude'], recordD.data['longitude']);
                    DrawCircle(myLatLng, convertintomtrs);
                }
            }
        }
    });

    var trigger1Combo = new Ext.form.ComboBox({
        store: SourcecomboStore,
        id: 'trigger1comboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Trigger Point 1',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        width: 170,
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('trigger2comboId').reset();
                    triggerArray = [];
                    for (var i = 0; i < gmarker.length; i++) {
                        gmarker[i].setMap(null);
                    }
                    for (var i = 0; i < trigCircleArray.length; i++) {
                        trigCircleArray[i].setMap(null);
                    }
                    if (Ext.getCmp('sourcecomboId').getValue() == "") {
                        Ext.example.msg("Select Source");
                        Ext.getCmp('trigger1comboId').reset();
                        return;
                    }
                    if (Ext.getCmp('destinationcomboId').getValue() == "") {
                        Ext.example.msg("Enter Destination");
                        Ext.getCmp('trigger1comboId').reset();
                        return;
                    }
                    var trigger1 = Ext.getCmp('trigger1comboId').getValue();
                    var idO = SourcecomboStore.find('Hub_Id', trigger1);
                    var recordT1 = SourcecomboStore.getAt(idO);
                    var convertintomtrs = recordT1.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(recordT1.data['latitude'], recordT1.data['longitude']);
                    plotMarker(myLatLng);
                    DrawCircleForTriggers(myLatLng, convertintomtrs);
                    triggerArray.push('{' + '1' + ',' + recordT1.data['latitude'] + ',' + recordT1.data['longitude'] + '}');
                }
            }
        }
    });


    var trigger2Combo = new Ext.form.ComboBox({
        store: SourcecomboStore,
        id: 'trigger2comboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Trigger Point 2',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        width: 170,
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    if (triggerArray.length == 2) {
                        triggerArray.pop();
                    }
                    if (Ext.getCmp('sourcecomboId').getValue() == "") {
                        Ext.example.msg("Select Source");
                        Ext.getCmp('trigger2comboId').reset();
                        return;
                    }
                    if (Ext.getCmp('destinationcomboId').getValue() == "") {
                        Ext.example.msg("Enter Destination");
                        Ext.getCmp('trigger2comboId').reset();
                        return;
                    }
                    if (Ext.getCmp('trigger1comboId').getValue() == Ext.getCmp('trigger2comboId').getValue()) {
                        Ext.example.msg("Trigger1 and trigger2 should not be same");
                        Ext.getCmp('trigger2comboId').reset();
                        return;
                    }
                    var trigger2 = Ext.getCmp('trigger2comboId').getValue();
                    var idO = SourcecomboStore.find('Hub_Id', trigger2);
                    var recordT2 = SourcecomboStore.getAt(idO);
                    var convertintomtrs = recordT2.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(recordT2.data['latitude'], recordT2.data['longitude']);
                    plotMarker(myLatLng);
                    DrawCircleForTriggers(myLatLng, convertintomtrs);
                    triggerArray.push('{' + '2' + ',' + recordT2.data['latitude'] + ',' + recordT2.data['longitude'] + '}');
                }
            }
        }
    });
    
        function haltOperation(halt,i){
                    var idO = SourcecomboStore.find('Hub_Id', halt);
                    var record = SourcecomboStore.getAt(idO);
                    if(saveBtn=='save'){
                        haltDataArray.push('{' + i + ',' + record.data['latitude'] + ',' + record.data['longitude'] + ',' + halt + '}');
                    }else{
                    if (Ext.getCmp('sourcecomboId').getValue() == "") {
                        Ext.example.msg("Select Source");
                        return;
                    }
                    if (Ext.getCmp('destinationcomboId').getValue() == "") {
                        Ext.example.msg("Enter Destination");
                        return;
                    }
                    
                    var convertintomtrs = record.data['radius'] * 1000;
                    myLatLng = new google.maps.LatLng(record.data['latitude'], record.data['longitude']);
                    plotHaltMarker(myLatLng);
                    DrawCircleForHalt(myLatLng, convertintomtrs);
                    }
    }
function openLocationWindow(locationPage,windowTitle)
{
createMapWindow(locationPage,windowTitle);
}
function createMapWindow(locationPage,windowTitle){
var win = new Ext.Window({
       title:windowTitle,
       autoShow : false,
	   constrain : false,
	   constrainHeader : false,
	   resizable : false,
	   maximizable : true,   
   	   footer:true,
       width:840,
       height:400,
       shim:false,
       animCollapse:false,
       border:false,
       constrainHeader:true,
       layout: 'fit',
html : "<iframe style='width:100%;height:100%;background:#ffffff' src="+locationPage+"></iframe>",
listeners: {
maximize: function(){
},
minimize:function(){
},
resize:function(){
},
restore:function(){
},
'close':function(win){
        SourcecomboStore.load({
            params: {
                CustId: custId
            }
        });
        destcomboStore.load({
            params: {
                CustId: custId
            }
        });
        
        Lmarker.setMap(null);
},
}
   });
 
   win.show();
}
    function getLatLon(){
     
     var vehicleNo=" KA05AC1420";
     var reghs = vehicleNo.replace(/ /g,"%20");
     var title="Location Page";custId
     var locationPage="<%=request.getContextPath()%>/Jsps/Common/CreateLandmark.jsp?vehicle="+reghs+"&lat="+latitudeP+"&lon="+longitudeP+"&hs=yes"+"&custId="+custId+"&ipVal=true";
     openLocationWindow(locationPage,title);	
    }
    function plotLocationMarker(myLocLatLng){
     var image = {
            url: '/ApplicationImages/VehicleImages/blue1.png', // This marker is 20 pixels wide by 32 pixels tall.
            size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
            anchor: new google.maps.Point(0, 32)
        };
        Lmarker = new google.maps.Marker({
            map: map,
            position: myLocLatLng,
            icon: image
        });
        //Lmarker.push(markerL);
    }
    function plotMarker(myLatLng) {
        var image = {
            url: '/ApplicationImages/VehicleImages/blue.png', // This marker is 20 pixels wide by 32 pixels tall.
            size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
            anchor: new google.maps.Point(0, 32)
        };
        var marker1 = new google.maps.Marker({
            map: map,
            position: myLatLng,
            icon: image
        });
        gmarker.push(marker1);
    }
     function plotRouteMarker(myLatLng) {
        var image = {
            url: '/ApplicationImages/VehicleImages/green.png', // This marker is 20 pixels wide by 32 pixels tall.
            size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
            anchor: new google.maps.Point(0, 32)
        };
        var marker1 = new google.maps.Marker({
            map: map,
            position: myLatLng,
            icon: image
        });
        //gmarker.push(marker1);
    }
     function plotHaltMarker(myLatLng) {
        var image = {
            url: '/ApplicationImages/VehicleImages/red.png', // This marker is 20 pixels wide by 32 pixels tall.
            size: new google.maps.Size(60, 60), // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
            anchor: new google.maps.Point(0, 32)
        };
        var markerH = new google.maps.Marker({
            map: map,
            position: myLatLng,
            icon: image
        });
        hmarker.push(markerH);
    }
    
    function DrawCircle(myLatLng, convertintomtrs) {

        createCircle = {
            strokeColor: '#FF8000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF8000',
            fillOpacity: 0.35,
            map: map,
            center: myLatLng,
            radius: convertintomtrs //In meter
        };
        circle = new google.maps.Circle(createCircle);
        circle.setCenter(myLatLng);
        map.fitBounds(circle.getBounds());
        circleArray.push(circle);
    }

    function DrawCircleForTriggers(myLatLng, convertintomtrs) {

        createTrigCircle = {
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35,
            map: map,
            center: myLatLng,
            radius: convertintomtrs //In meter
        };
        trigCircle = new google.maps.Circle(createTrigCircle);
        trigCircle.setCenter(myLatLng);
        map.fitBounds(trigCircle.getBounds());
        trigCircleArray.push(trigCircle);
    }
    
        function DrawCircleForHalt(myLatLng, convertintomtrs) {

        createHaltCircle = {
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#0957F2',
            fillOpacity: 0.35,
            map: map,
            center: myLatLng,
            radius: convertintomtrs //In meter
        };
        haltCircle = new google.maps.Circle(createHaltCircle);
        haltCircle.setCenter(myLatLng);
        map.fitBounds(haltCircle.getBounds());
        haltCircleArray.push(haltCircle);
    }
    
    function plotRoute(latlongorigin, latlongDestination) {
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        for (var i = 0; i < markerArray.length; i++) {
            markerArray[i].setMap(null);
        }
        for (var i = 0; i < dirDspArray.length; i++) {
            dirDspArray[i].setMap(null);
        }
        var directionsService = new google.maps.DirectionsService;
        directionsDisplay = new google.maps.DirectionsRenderer({
            map: map,
            draggable: true
            //suppressMarkers: true
        });
        google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {
            plotDrag(directionsDisplay.directions, markerArray, map, directionsDisplay);
        });

        directionsService.route({
            origin: latlongorigin,
            destination: latlongDestination,
            travelMode: google.maps.TravelMode.DRIVING
        }, function(response, status) {
            if (status === google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(response);
            } else {
                console.log("Invalid Request");
            }
        });
    }

    //*******************************window*************************************//
    function CreateComboBox() {
    haltCount++;
    var combo = new Ext.form.ComboBox({
        store: SourcecomboStore,
        id: 'halt'+haltCount+'comboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Halt '+haltCount,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Hub_Id',
        width: 170,
        displayField: 'Hub_Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    var id='halt'+haltCount+'comboId';
                    var halt = Ext.getCmp(id).getValue();
                    haltOperation(halt,0);
                }
            }
        }
    });
    return combo;
}
    function AddControlsHandler() {
           haltDetailsPanel.add(CreateComboBox());
           haltDetailsPanel.doLayout();
 }
    var innerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 370,
        width: 438,
        frame: true,
        id: 'innerPanelId',
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sourceEmptyId1'
        }, {
            xtype: 'label',
            text: 'Source Name' + ' :',
            cls: 'labelstyle',
            id: 'sourceLabelId'
        }, sourceCombo, {
            xtype: 'button',
            text: '',
            iconCls: 'addbutton',
            id: 'addButtonId',
            cls: 'buttonstyle',
            width: 40,
            listeners: {
                click: {
                    fn: function() {
                    if(latitudeP==0 && longitudeP==0){
                         Ext.example.msg("Click on map before add");
                         return;
                         }
                         getLatLon();
                          latitudeP=0;
                          longitudeP=0;
                    }
                }
            }
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'destEmptyId1'
        }, {
            xtype: 'label',
            text: 'Destination Name' + ' :',
            cls: 'labelstyle',
            id: 'destLabelId'
        }, destinationCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'destEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'trig1EmptyId1'
        }, {
            xtype: 'label',
            text: 'Trigger Point 1' + ' :',
            cls: 'labelstyle',
            id: 'trig1LabelId'
        }, trigger1Combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'trig1EmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'trig2EmptyId1'
        }, {
            xtype: 'label',
            text: 'Trigger Point 2' + ' :',
            cls: 'labelstyle',
            id: 'trig2LabelId'
        }, trigger2Combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'trig2EmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'routeNameEmptyId1'
        }, {
            xtype: 'label',
            text: 'Route Name' + ' :',
            cls: 'labelstyle',
            id: 'routeNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            emptyText: 'Enter Route Name',
            id: 'routeNameId',
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase());
                }
            }
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'routeNameEmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contractorNameEmptyId1'
        }, {
            xtype: 'label',
            text: 'Route Description' + ' :',
            cls: 'labelstyle',
            id: 'routeDescriptionLabelId'
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            id: 'routeDescriptionId',
            emptyText: 'Enter Route Description'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'descriptionNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'despEmptyId1'
        }, {
            xtype: 'label',
            text: 'Actual Km' + ' :',
            cls: 'labelstyle',
            id: 'despLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            readOnly: true,
            id: 'actualKmId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'actualkmEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'expectedkmEmptyId1'
        }, {
            xtype: 'label',
            text: 'Expected Km',
            cls: 'labelstyle',
            id: 'expectedkmLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            emptyText: 'Enter Expected km',
            id: 'expectedkmId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'expectedkmEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'actualTimeEmptyId1'
        }, {
            xtype: 'label',
            text: 'Actual Time(HH:MM)' + ' :',
            cls: 'labelstyle',
            id: 'actualTimelableId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            readOnly: true,
            decimalPrecision: 2,
            id: 'actualTimeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'actualTimeEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'expectedTimeEmptyId1'
        }, {
            xtype: 'label',
            text: 'Expected Time(HH:MM)' + ' :',
            cls: 'labelstyle',
            id: 'expectedTimeLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            emptyText: 'Enter Expected Time',
            id: 'expectedTimeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'expectedTimeEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'radiusEmptyId1'
        }, {
            xtype: 'label',
            text: 'Route Radius(Meters)' + ' :',
            cls: 'labelstyle',
            id: 'radiusLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            emptyText: 'Enter Radius',
            autoCreate: {//restricts user to 6 chars max, 
                   tag: "input",
                   maxlength: 6,
                   type: "text",
                   size: "6",
                   autocomplete: "off"
               },
            decimalPrecision:0,
            id: 'radiusId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'radiusEmptyId2'
        }]
    });
       var haltDetailsPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: true,
        width: 435,
        id: 'haltpanelId',
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
            items: [{
            xtype: 'button',
            text: 'Add Halt',
            iconCls: '',
            id: 'addButtonIdH',
            cls: 'buttonstyle',
            width: 40,
            handler: AddControlsHandler
        }]
    });
    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 440,
        width: 450,
        frame: true,
        id: 'addPanelInfo',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [innerPanel, haltDetailsPanel]
    });
    var innerWinButtonPanel = new Ext.Panel({
        id: 'innerWinButtonPanelId',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 100,
        width: 450,
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Back',
            iconCls: 'backbutton',
            id: 'backButtonId',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        parent.Ext.getCmp('routeDetailsId').enable();
                        parent.Ext.getCmp('routeDetailsId').show();
                        parent.Ext.getCmp('routeMapId').disable();
                        var backData='/Telematics4uApp/Jsps/CashVanManagement/RouteDetails.jsp?status=yes'+'&custId='+custId;
                        parent.Ext.getCmp('routeDetailsId').update("<iframe style='width:101%;height:533px;border:0;' src='"+backData+"'></iframe>");
                        parent.Ext.getCmp('routeDetailsId').show();
                    }
                }
            }
        },{
            xtype: 'button',
            text: 'Save',
            iconCls: 'savebutton',
            id: 'saveButtonId',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('sourcecomboId').getValue() == "") {
                            Ext.example.msg("Select Source");
                            Ext.getCmp('sourcecomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('destinationcomboId').getValue() == "") {
                            Ext.example.msg("Enter Destination");
                            Ext.getCmp('destinationcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('trigger1comboId').getValue() == "") {
                            Ext.example.msg("Enter Trigger Point 1");
                            Ext.getCmp('trigger1comboId').focus();
                            return;
                        }
                        if (Ext.getCmp('routeNameId').getValue() == "") {
                            Ext.example.msg("Enter Route Name");
                            Ext.getCmp('routeNameId').focus();
                            return;
                        }
                        if (Ext.getCmp('actualKmId').getValue() == "") {
                            Ext.example.msg("Enter Actual Km");
                            Ext.getCmp('actualKmId').focus();
                            return;
                        }
                        if (Ext.getCmp('expectedkmId').getValue() == "") {
                            Ext.example.msg("Enter Expected Km");
                            Ext.getCmp('expectedkmId').focus();
                            return;
                        }
                        if (Ext.getCmp('actualTimeId').getValue() == "") {
                            Ext.example.msg("Enter Actual Time");
                            Ext.getCmp('actualTimeId').focus();
                            return;
                        }
                        if (Ext.getCmp('expectedTimeId').getValue() == "") {
                            Ext.example.msg("Enter Expected Time");
                            Ext.getCmp('expectedTimeId').focus();
                            return;
                        }
                        if (Ext.getCmp('radiusId').getValue() == "") {
                            Ext.example.msg("Enter Route Radius");
                            Ext.getCmp('radiusId').focus();
                            return;
                        }
                        if (Ext.getCmp('radiusId').getValue() <= 0) {
                            Ext.example.msg("greater");
                            Ext.getCmp('radiusId').focus();
                            return;
                        }
                        saveBtn='save';
                        var newarr=[];
                        var haltId=0;
                        for(var i=1; i<=haltCount;i++){
                           haltId='halt'+i+'comboId';
						   newarr.push(Ext.getCmp(haltId).getValue());
						}
                        var haltArray=[];
							for(var i=0; i<newarr.length;i++){
							   if(newarr[i] !== "" && newarr[i] !== null){
							    haltArray.push(newarr[i]);
							   }
							}
                        for(var h=0;h<haltArray.length;h++){
                             haltOperation(haltArray[h],(h+1));
                        }
                        var triggerdata = JSON.stringify(triggerArray);
                        var stringData = JSON.stringify(jsonArray);
                        var haltData=JSON.stringify(haltDataArray);
                        loadMask.show();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=saveRouteDetails',
                            method: 'POST',
                            params: {
                                source: Ext.getCmp('sourcecomboId').getValue(),
                                destination: Ext.getCmp('destinationcomboId').getValue(),
                                trigger1: Ext.getCmp('trigger1comboId').getValue(),
                                trigger2: Ext.getCmp('trigger2comboId').getValue(),
                                routeName: Ext.getCmp('routeNameId').getValue(),
                                routeValue: stringData,
                                triggerValue: triggerdata,
                                haltValue:haltData,
                                routeDescription: Ext.getCmp('routeDescriptionId').getValue(),
                                actualDistance: Ext.getCmp('actualKmId').getValue(),
                                expectedDistance: Ext.getCmp('expectedkmId').getValue(),
                                actualDuration: Ext.getCmp('actualTimeId').getValue(),
                                expectedDuration: Ext.getCmp('expectedTimeId').getValue(),
                                CustId: custId,
                                routeRadius:Ext.getCmp('radiusId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                loadMask.hide();
                                latlongorigin = '0,0';
                                latlongDestination = '0,0';
                                if (directionsDisplay != null) {
                                    directionsDisplay.setMap(null);
                                }
                                for (var i = 0; i < dirDspArray.length; i++) {
                                    dirDspArray[i].setMap(null);
                                }
                                for (var i = 0; i < markerArray.length; i++) {
                                    markerArray[i].setMap(null);
                                }
                                for (var i = 0; i < circleArray.length; i++) {
                                    circleArray[i].setMap(null);
                                }
                                for (var i = 0; i < trigCircleArray.length; i++) {
                                    trigCircleArray[i].setMap(null);
                                }
                                for (var i = 0; i < gmarker.length; i++) {
                                    gmarker[i].setMap(null);
                                }
                                for (var i = 0; i < haltCircleArray.length; i++) {
                                     haltCircleArray[i].setMap(null);
                                }
                                for (var i = 0; i < hmarker.length; i++) {
                                     hmarker[i].setMap(null);
                                }
                                if(Lmarker!=null){
                                     Lmarker.setMap(null);
                                }
                                jsonArray = [];
                                triggerArray = [];
                                var savehalt=0;
                                for(var i=1; i<=haltCount;i++){
	                            savehalt='halt'+i+'comboId';
							    Ext.getCmp(savehalt).reset();
							    Ext.getCmp(savehalt).hide();
							    }
                                haltCount=0;
                                Ext.getCmp('sourcecomboId').reset();
                                Ext.getCmp('destinationcomboId').reset();
                                Ext.getCmp('routeNameId').reset();
                                Ext.getCmp('routeDescriptionId').reset();
                                Ext.getCmp('actualKmId').reset();
                                Ext.getCmp('expectedkmId').reset();
                                Ext.getCmp('actualTimeId').reset();
                                Ext.getCmp('expectedTimeId').reset();
                                Ext.getCmp('trigger1comboId').reset();
                                Ext.getCmp('trigger2comboId').reset();
                                Ext.getCmp('radiusId').reset();

                            },
                            failure: function() {
                                loadMask.hide();
                                Ext.example.msg("Route Creation Unsucessfull");
                                jsonArray = [];
                                triggerArray = [];
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: 'Clear',
            id: 'canButtId',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        latlongorigin = '0,0';
                        latlongDestination = '0,0';
                        if (directionsDisplay != null) {
                            directionsDisplay.setMap(null);
                        }
                        for (var i = 0; i < dirDspArray.length; i++) {
                            dirDspArray[i].setMap(null);
                        }
                        for (var i = 0; i < markerArray.length; i++) {
                            markerArray[i].setMap(null);
                        }
                        for (var i = 0; i < markers1.length; i++) {
                            markers1[i].setMap(null);
                        }
                        for (var i = 0; i < circleArray.length; i++) {
                            circleArray[i].setMap(null);
                        }
                        for (var i = 0; i < trigCircleArray.length; i++) {
                            trigCircleArray[i].setMap(null);
                        }
                        for (var i = 0; i < gmarker.length; i++) {
                            gmarker[i].setMap(null);
                        }
                        for (var i = 0; i < haltCircleArray.length; i++) {
                            haltCircleArray[i].setMap(null);
                        }
                        for (var i = 0; i < hmarker.length; i++) {
                            hmarker[i].setMap(null);
                        }
                        if(Lmarker!=null){
                            Lmarker.setMap(null);
                        }
                        var clearhalt=0;
                        for(var i=1; i<=haltCount;i++){
                        clearhalt='halt'+i+'comboId';
					    Ext.getCmp(clearhalt).reset();
					    Ext.getCmp(clearhalt).hide();
					    }
                        jsonArray = [];
                        haltCount=0;
                        Ext.getCmp('sourcecomboId').reset();
                        Ext.getCmp('destinationcomboId').reset();
                        Ext.getCmp('routeNameId').reset();
                        Ext.getCmp('routeDescriptionId').reset();
                        Ext.getCmp('actualKmId').reset();
                        Ext.getCmp('expectedkmId').reset();
                        Ext.getCmp('actualTimeId').reset();
                        Ext.getCmp('expectedTimeId').reset();
                        Ext.getCmp('trigger1comboId').reset();
                        Ext.getCmp('trigger2comboId').reset();
                        Ext.getCmp('radiusId').reset();
                    }
                }
            }
        }]
    });

    var rightPanel = new Ext.Panel({
        standardSubmit: true,
        id: 'mapdivid',
        collapsible: false,
        frame: true,
        width: screen.width - 300,
        height: 530,
        html: '<div id="mapid" style="width:82%;height:510px;border:0;">'
    });

    var leftPanel = new Ext.Panel({
        id: 'leftContentId',
        standardSubmit: true,
        collapsible: false,
        frame: true,
        height: 530,
        width: 455,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [mainPanel, innerWinButtonPanel]
    });


    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            width: screen.width - 29,
            height: 510,
            layout: 'table',
            layoutConfig: {
                columns: 2
            },
            items: [leftPanel, rightPanel]
        });
        initialize();
        Ext.getCmp('radiusId').setValue(500);
        SourcecomboStore.load({
            params: {
                CustId: custId
            }
        });
        destcomboStore.load({
            params: {
                CustId: custId
            }
        });
        
    });
</script>
</body>

</html>