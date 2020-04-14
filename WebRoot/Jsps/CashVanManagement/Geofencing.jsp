<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	if (request.getParameter("list") != null) {
	 String list = request.getParameter("list").toString().trim();
	 String[] str = list.split(",");
	 int systemid = Integer.parseInt(str[0].trim());
	 int clientid = Integer.parseInt(str[1].trim());
	 int userid = Integer.parseInt(str[2].trim());
	 String language = str[3].trim();
	 LoginInfoBean loginInfo = new LoginInfoBean();
	 loginInfo.setSystemId(systemid);
	 loginInfo.setCustomerId(clientid);
	 loginInfo.setUserId(userid);
	 loginInfo.setLanguage(language);
	 loginInfo.setZone(str[4].trim());
	 loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	 loginInfo.setSystemName(str[6].trim());
	 loginInfo.setCategory(str[7].trim());
	 loginInfo.setStyleSheetOverride("N");
	 if (str.length > 8) {
	  loginInfo.setCustomerName(str[8].trim());
	 }
	 if (str.length > 9) {
	  loginInfo.setCategoryType(str[9].trim());
	 }
	 if (str.length > 10) {
	  loginInfo.setUserName(str[10].trim());
	 }
	 session.setAttribute("loginInfoDetails", loginInfo);

	}

	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit = "''";
	String feature = "1";
	if (session.getAttribute("responseaftersubmit") != null) {
	 responseaftersubmit = "'" + session.getAttribute("responseaftersubmit").toString() + "'";
	 session.setAttribute("responseaftersubmit", null);
	}

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();

	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

	double lat = 0;
	double lon = 0;
	double rad = 0;
	if (request.getParameter("latitude").trim() != null) {
	 lat = Double.parseDouble(request.getParameter("latitude").trim());
	}
	if (request.getParameter("longitude").trim() != null) {
	 lon = Double.parseDouble(request.getParameter("longitude").trim());
	}
	if (request.getParameter("radius").trim() != null) {
	 rad = Double.parseDouble(request.getParameter("radius").trim());
	}
	String SelectMap = "Select Map";
	Properties properties = ApplicationListener.prop;
	String GoogleKey = properties.getProperty("GoogleKey").trim();
	String GoogleHttp = properties.getProperty("GoogleHttp").trim();
	String AMSPath = properties.getProperty("AMSPath").trim();
	String sessionmap = "";
	String rightClickCss = AMSPath+"/css/RightClick.css";
	String cancelbackspace = AMSPath+"/js/cancelbackspace.js";
	String extall = AMSPath+"/resources/css/ext-all.css";
	String style = AMSPath+"/css/style.css";
	String dhtmlwindow =  AMSPath+"/css/dhtmlwindow.css";
    String dhtmlwindowSearch = AMSPath+"/css/dhtmlwindow-search.css";
	String common = AMSPath+"/js/common.js";
String stringss = AMSPath+"/js/string.js";
String OpenLayers = AMSPath+"/jsps/OpenLayers-2.10/OpenLayers.js";
String labelss = AMSPath+"/jsps/label.js";
String CustomMeasuringTool = AMSPath+"/jsps/CustomMeasuringTool.js";
String extbase = AMSPath+"/adapter/ext/ext-base.js";
String extalljs = AMSPath+"/ext-all.js";
String extalllive = AMSPath+"/ext-all-live.js" ;
String livegridalldebug = AMSPath+"/livegrid-all-debug.js";
String dhtmlwindowss = AMSPath+"/js/dhtmlwindow.js";
String custommapsjs	= AMSPath+"/js/custommaps.js";
String FileUploadField =  AMSPath+"/FileUploadField.js";
String test = AMSPath+"/images/mapimage/eraser25.gif";
%>
 
<html>
  <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <pack:style src= "<%=rightClickCss%>" ></pack:style>
   
	<pack:style src="<%=extall%>"></pack:style>
	<pack:style src="<%=style%>"></pack:style>
    <pack:style src="../../Main/resources/css/googlestyle.css"></pack:style>        
    <pack:style src="../../Main/resources/css/mapstyle.css"></pack:style>
    <pack:style src="<%=dhtmlwindow%>" ></pack:style>
    <pack:style src="<%=dhtmlwindowSearch%>" ></pack:style>
    
    <title>Location and Buffer creation</title>
     <script src="<%=cancelbackspace%>"></script>
    <script src="<%=GoogleHttp%>" ></script>   
    <script src="<%=common%>"></script> 
    <script src="<%=stringss%>"></script> 
    <script src= "<%=OpenLayers%>" ></script> 
    <script src=  "<%=labelss%>" type="text/javascript"></script>
    <script src= "<%=CustomMeasuringTool%>" ></script> 
    <script src="<%=extbase%>" ></script> 
    <script src= "<%=extalljs%>" ></script> 
    <script src= "<%=extalllive%>" ></script>  
    <script src="<%=livegridalldebug%>" ></script> 
    <script src= "<%=dhtmlwindowss%>" ></script> 
 	<script src="<%=custommapsjs%>" ></script>
    <script type="text/javascript" src="<%=FileUploadField%>"></script>
<script>
function googleTranslateElementInit() {
  new google.translate.TranslateElement({
    pageLanguage: 'en'
 //   includedLanguages: 'ar'
  }, 'google_translate_element');
}
</script><script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>		
				
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
        
	  </style>
    <script type="text/javascript" language="JavaScript">
    
       var icon;
   var firstClick = true;
   var area;
   var radius = <%=rad%>;
   var sysId = <%=systemId%>;

   var lat;
   var lon;
   var m;
   var clientId = 3513;
   var fromLiveUpdate = "";
   var point;
   var polygonMarkers = [];
   var pointsofpolygon = [];
   var linesofpolygon = [];
   var action = 2;
   var myClientId = 3513;
   var buttonClick = "flase";
   radius = 1.0;

   lat = <%=lat%>;
   lon = <%=lon%>;
   OpenLayers.Handler.Marker = OpenLayers.Class.create();
   OpenLayers.Handler.Marker.prototype =
       OpenLayers.Class.inherit(OpenLayers.Handler.Feature, {

           handle: function(evt) {
               var type = evt.type;
               var node = OpenLayers.Event.element(evt);
               var feature = null;
               for (var i = 0; i < this.layer.markers.length; i++) {
                   if (this.layer.markers[i].icon.imageDiv.firstChild == node) {
                       feature = this.layer.markers[i];
                       break;
                   }
               }
               var selected = false;
               if (feature) {
                   if (this.geometryTypes == null) {
                       if (!this.feature) {
                           this.callback('over', [feature]);
                       } else if (this.feature != feature) {
                           this.callback('out', [this.feature]);
                           this.callback('over', [feature]);
                       }
                       this.feature = feature;
                       this.callback(type, [feature]);
                       selected = true;
                   } else {
                       if (this.feature && (this.feature != feature)) {
                           this.callback('out', [this.feature]);
                           this.feature = null;
                       }
                       selected = false;
                   }
               } else {
                   if (this.feature) {
                       this.callback('out', [this.feature]);
                       this.feature = null;
                   }
                   selected = false;
               }
               return selected;
           },
           CLASS_NAME: "OpenLayers.Handler.Marker"
       });

   OpenLayers.Control.DragMarker = OpenLayers.Class.create();
   OpenLayers.Control.DragMarker.prototype =
       OpenLayers.Class.inherit(OpenLayers.Control.DragFeature, {
           initialize: function(layer, options) {
               OpenLayers.Control.prototype.initialize.apply(this, [options]);
               this.layer = layer;
               this.handlers = {
                   drag: new OpenLayers.Handler.Drag(
                       this, OpenLayers.Util.extend({
                           down: this.downFeature,
                           move: this.moveFeature,
                           up: this.upFeature,
                           out: this.cancel,
                           done: this.doneDragging
                       }, this.dragCallbacks)
                   ),
                   feature: new OpenLayers.Handler.Marker(
                       this, this.layer, OpenLayers.Util.extend({
                               over: this.overFeature,
                               out: this.outFeature
                           },
                           this.featureCallbacks), {
                           geometryTypes: this.geometryTypes
                       }
                   )
               };
           },

           onComplete: function(feature, pixel) {
               getLatLng();
               resetMap();
           },

           moveFeature: function(pixel) {
               var px = this.feature.icon.px.add(pixel.x - this.lastPixel.x, pixel.y - this.lastPixel.y);;
               this.feature.moveTo(px);
               this.lastPixel = pixel;
               this.onDrag(this.feature, pixel);
           },

           CLASS_NAME: "OpenLayers.Control.DragMarker"
       });

   OpenLayers.IMAGE_RELOAD_ATTEMPTS = 5;
   OpenLayers.DOTS_PER_INCH = 25.4 / 0.28;
   var layer_style = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default']);
   layer_style.fillOpacity = 0.2;
   layer_style.graphicOpacity = 0.1;
   /*
    * Green style
    */
   var style_green = {
       strokeColor: "#00FF00",
       strokeWidth: 3,
       strokeDashstyle: "solid",
       pointRadius: 6,
       pointerEvents: "visiblePainted"
   };
   /*
    * Blue style
    */
   var style_blue = {
       strokeColor: "#0000FF",
       strokeWidth: 3,
       strokeDashstyle: "solid",
       pointRadius: 6,
       pointerEvents: "visiblePainted"
   };

   function createCircle2(lat, lon, rad) {

       clearMap();
       controls.modify.mode = OpenLayers.Control.ModifyFeature.RESHAPE;
       controls.modify.mode |= OpenLayers.Control.ModifyFeature.RESIZE;
       controls.modify.mode |= OpenLayers.Control.ModifyFeature.DRAG;
       controls.modify.mode &= ~OpenLayers.Control.ModifyFeature.RESHAPE;

       radius = rad;

       map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), 12);


       var circOrigin;

       circOrigin = new OpenLayers.Geometry.Point(lon, lat);


       var circStyle = OpenLayers.Util.extend({},
           OpenLayers.Feature.Vector.style["default"]
       );

       var circleFeature = new OpenLayers.Feature.Vector(
           OpenLayers.Geometry.Polygon.createRegularPolygon(circOrigin, radius / 110, 99, 0).transform(
               new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject()
           ), null, circStyle);
       vectorLayer.addFeatures([circleFeature]);
       map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), 12);
       parent.Ext.getCmp('latitudeId').setValue(lat);
       parent.Ext.getCmp('longitudeId').setValue(lon);
       parent.Ext.getCmp('radiusId').setValue(radius);

       vectorLayer.events.register("featuremodified", vectorLayer, function(e) {
           getRadius();
           getLatLng();
           resetMap();
       })


       vectorLayer.redraw();
       map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), 12);


   }

   function init() {

       map = getMap();

       setProperties1("<%=request.getContextPath()%>");
       var sessionmap = '<%=sessionmap%>';

       setInitMap("C", sessionmap);

       setControls1([vectorLayer, vectorLayerRuler, rulerMarkerLayer, searchMarkerLayer, markerLayer], sysId);
       controls = {
           modify: new OpenLayers.Control.ModifyFeature(vectorLayer),
           drag: new OpenLayers.Control.DragMarker(markerLayer)
       };

       for (var key in controls) {
           map.addControl(controls[key]);
           controls[key].activate();
       }

       icon = getIcon('http://gmaps-samples.googlecode.com/svn/trunk/markers/green/blank.png', 13, 15);
       map.setCenter(new OpenLayers.LonLat(<%=lat%>, <%=lon%>).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), 7);

       action = 1;

       controls.modify.mode = OpenLayers.Control.ModifyFeature.RESHAPE;
       controls.modify.mode |= OpenLayers.Control.ModifyFeature.RESIZE;
       controls.modify.mode |= OpenLayers.Control.ModifyFeature.DRAG;
       controls.modify.mode &= ~OpenLayers.Control.ModifyFeature.RESHAPE;

       createCircle();
       vectorLayer.redraw();
       getRadius();
       getLatLng();
       map.events.register("click", map, function(e) {

               point = map.getLonLatFromViewPortPx(e.xy);        
               clearMap();
               controls.modify.mode = OpenLayers.Control.ModifyFeature.RESHAPE;
               controls.modify.mode |= OpenLayers.Control.ModifyFeature.RESIZE;
               controls.modify.mode |= OpenLayers.Control.ModifyFeature.DRAG;
               controls.modify.mode &= ~OpenLayers.Control.ModifyFeature.RESHAPE;

               radius = 1.0;
               lat = point.lat;
               lon = point.lon;
               createCircle();
               vectorLayer.redraw();
               map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
                   new OpenLayers.Projection("EPSG:4326"),
                   map.getProjectionObject()
               ), 12);
           getRadius();
           getLatLng();
           resetMap();
        
           if (ruler) {
               flgTr = 1;
               var point = map.getLonLatFromViewPortPx(e.xy);
               var icon = getIcon('<%=request.getContextPath()%>/jsps/images/redcirclemarker.png', 10, 10);
               var marker = createRulerMarker(point, icon, ctrTr);
               tracepoint.push(point)
               if (ctrTr > 0) {
                   var mrkr1 = new OpenLayers.LonLat(markerArrayTr[ctrTr].lonlat.lon, markerArrayTr[ctrTr].lonlat.lat).transform(
                       map.getProjectionObject(), new OpenLayers.Projection("EPSG:4326")
                   );
                   var mrkr2 = new OpenLayers.LonLat(markerArrayTr[ctrTr - 1].lonlat.lon, markerArrayTr[ctrTr - 1].lonlat.lat).transform(
                       map.getProjectionObject(), new OpenLayers.Projection("EPSG:4326")
                   );
                   distanceTr = OpenLayers.Util.distVincenty(mrkr1, mrkr2);
                   totaldistanceTr += distanceTr;
                   distArrayTr.push(totaldistanceTr)
                   var label = distArrayTr[ctrTr];
                   label = label.toFixed(2);
                   marker.setLabel(label + " Kms");
                   createPolylineTr();
               }
               ctrTr++;
           }
           map.raiseLayer(vectorLayer, 1);
       });
       map.events.register("mousemove", map, function(e1) {
           if (flgTr == 1) {
               var point1 = map.getLonLatFromViewPortPx(e1.xy);
               createPolylinetrace(tracepoint[ctrTr - 1], point1);
           }
       })

   }

   function createCircle() {

       map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), 12);


       var circOrigin;
       if (firstClick) {
           circOrigin = new OpenLayers.Geometry.Point(lon, lat);
           firstClick = false;

       } else {
           circOrigin = new OpenLayers.Geometry.Point(lon, lat).transform(
               map.getProjectionObject(), new OpenLayers.Projection("EPSG:4326")
           );
       }
       var circStyle = OpenLayers.Util.extend({},
           OpenLayers.Feature.Vector.style["default"]
       );

       var circleFeature = new OpenLayers.Feature.Vector(
           OpenLayers.Geometry.Polygon.createRegularPolygon(circOrigin, radius / 110, 99, 0).transform(
               new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject()
           ), null, circStyle);
       vectorLayer.addFeatures([circleFeature]);
       map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), 12);
       parent.Ext.getCmp('latitudeId').setValue(lat);
       parent.Ext.getCmp('longitudeId').setValue(lon);
       parent.Ext.getCmp('radiusId').setValue(radius);

       vectorLayer.events.register("featuremodified", vectorLayer, function(e) {
           getRadius();
           getLatLng();
           resetMap();
       })

   }

   function resetMap() {
       map.setCenter(new OpenLayers.LonLat(lon, lat).transform(
           new OpenLayers.Projection("EPSG:4326"),
           map.getProjectionObject()
       ), map.getZoom());
   }

   function getRadius() {

       //Area of a circle=PI*R*R
       area = vectorLayer.features[0].geometry.getArea();
       var RR = area / Math.PI;
       var R = (Math.sqrt(RR) * 110).toFixed(2);
       var circOriginNew = new OpenLayers.Geometry.Point(lon, lat);
       var circStyleNew = OpenLayers.Util.extend({},
           OpenLayers.Feature.Vector.style["default"]
       );
       var circleFeatureNew = new OpenLayers.Feature.Vector(
           OpenLayers.Geometry.Polygon.createRegularPolygon(circOriginNew, R / 110, 100, 0).transform(map.getProjectionObject(),
               new OpenLayers.Projection("EPSG:4326")), null, circStyleNew);
       var areaNew = circleFeatureNew.geometry.getArea();
       RR = areaNew / Math.PI;
       R = (Math.sqrt(RR) * 110).toFixed(2);
       //parent.Ext.getCmp('latitudeId').setValue(lat);
       //parent.Ext.getCmp('longitudeId').setValue(lon);
       parent.Ext.getCmp('radiusId').setValue(R);

   }

   function setRadius() {
       if (vectorLayer.features.length != 0) {
           vectorLayer.destroyFeatures();
           //radius = document.getElementById("rad").value;
           //radius = parseFloat(radius).toFixed(2);
           //document.getElementById("rad").value = radius;
           createCircle();
           vectorLayer.redraw();
       }
   }

   function getLatLng() {

       if (radius / 110 <= 0) {
           lat = m.lonlat.lat;
           lon = m.lonlat.lon;
           var mnew = new OpenLayers.Marker(new OpenLayers.LonLat(lon, lat).transform(map.getProjectionObject(),
               new OpenLayers.Projection("EPSG:4326")
           ));
           lat = mnew.lonlat.lat;
           lon = mnew.lonlat.lon;
           parent.Ext.getCmp('latitudeId').setValue(lat);
           parent.Ext.getCmp('longitudeId').setValue(lon);
           //   parent.Ext.getCmp('radiusId').setValue(radius);
       } else {
           lat = vectorLayer.features[0].geometry.getBounds().getCenterLonLat().lat;
           lon = vectorLayer.features[0].geometry.getBounds().getCenterLonLat().lon;
           var mnew = new OpenLayers.Marker(new OpenLayers.LonLat(lon, lat).transform(map.getProjectionObject(),
               new OpenLayers.Projection("EPSG:4326")
           ));
           lat = mnew.lonlat.lat;
           lon = mnew.lonlat.lon;
           parent.Ext.getCmp('latitudeId').setValue(lat);
           parent.Ext.getCmp('longitudeId').setValue(lon);
           //parent.Ext.getCmp('radiusId').setValue(radius);
       }
   }

   function setLatLng() {

       vectorLayer.destroyFeatures();
       createCircle();
          
           var transformedLatLong = new OpenLayers.LonLat(lon, lat).transform(
               new OpenLayers.Projection("EPSG:4326"),
               map.getProjectionObject()
           );
           m = new OpenLayers.Marker(transformedLatLong);
           markerLayer.addMarker(m);
           markerLayer.events.register("featuremodified", markerLayer, function(e) {
               getRadius();
               getLatLng();
               resetMap();
           })     
   }

   function alertMesg(mesg) {
       Ext.MessageBox.show({
           msg: mesg,
           buttons: Ext.MessageBox.OK
       });
   }

   function clearMap() {

       while (vectorLayer.features.length > 0) {
           for (var i = 0; i < vectorLayer.features.length; i++) {
               vectorLayer.removeFeatures(vectorLayer.features[i]);
           }
       }
       vectorLayer.destroyFeatures();
   }

   Ext.onReady(function() {

       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       var bd = Ext.getBody();
       var win = new Ext.FormPanel({
           width: 455,
           height: 370,
           frame: true,
           standardsubmit: true,
           plain: true,
           items: [{
               html: "<div id='mapHTML' class='drsElement' style='width: 500px; height: 600px;'></div>"
           }]
       });
       win.render('frm');

   });
 
    </script>

  </head>
  
  <body onload="init();">
 
  <table width="100%" align="left">
    <tr>
      <td valign="top">
        <div align="left" style="width: 100%">
        <div class="drsElement" style="width:94%;">
        <table  width="100%">
  		<tr>
  	
   	
   		<td width="67%" id="gridcontentmap" align="left">
		    	<p class="labletxt"> 
			
					<select name="mapsel" id="mapsel" onchange="setmap()">
			
					<option label="Google Street" value="GoogleStreet">Google Street</option>
					
				
					
			        
					</select>
					</p>
		   </td >
		      		<td> <img src="<%=test%>" alt="Clear" title= 'Clear' onclick="clearMap()"> </td> 
		   
		     <td>
            	 <div id="wrapper" ;width="20%" ; align="left">
      	    <div id="location"></div>
      	   
          </div> 
           </td>
		   
  		</tr>
  		
 		</table>
 		 
 		</div>
 		
 		  <table align="left"; style="height: 370px">
            <tr>
              <td id="frm">
    	      </td>
            </tr>
          
          </table>
 		
 		
 		
 		</div>
    

      </td>
    </tr>
  </table>
  
  <div id="helpmesg" class="successmessage"></div>
  <br>
  <div id="helpmesg2" class="successmessage"></div>
  <br>
  <div id="helpmesg3" class="successmessage"></div>
  

  
  </body>
</html>



