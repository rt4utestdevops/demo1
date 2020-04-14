
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String ipVal = request.getParameter("ipVal");
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
String customernamelogged="null";
if(customeridlogged>0)
{
customernamelogged=cf.getCustomerName(String.valueOf(customeridlogged),systemid);
}
int userId = loginInfo.getUserId();
Properties properties = ApplicationListener.prop;						
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
%>
<jsp:include page="../Common/header.jsp" />

<div class="myHtml">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <title>Map</title>  
    <script src=<%=GoogleApiKey%>></script>   
    	<style type="text/css">
     		//html { height: 100% }
     		//body { height: 100%; margin: 0px; padding: 0px }
			.myHtml { height: 100% }
     		.myBody { height: 100%; margin: 0px; padding: 0px }
     		#content { height: 100% }
     		#myInfoDiv { width:100%; height:100% }
     		
.style-toggler {
position: absolute;
left: -1px;
background-image: url(/ApplicationImages/DashBoard/BoxBlack.png);
border: 1px solid #111;
-webkit-box-shadow: 0 0 5px 1px #111111;
-moz-box-shadow: 0 0 5px 1px #111111;
box-shadow: 0 0 5px 1px #111111;
-webkit-border-radius: 3px 3px 3px 3px;
-moz-border-radius: 3px 3px 3px 3px;
border-radius: 3px 3px 3px 3px;
padding: 5px 0;
top: 67px;
z-index: 1050;
cursor: pointer;
}
.style-switcher {
background-image: url(/ApplicationImages/DashBoard/Box_Black_Flip.png);
border: 1px solid #111;
-webkit-box-shadow: 0 0 5px 1px #111111;
-moz-box-shadow: 0 0 5px 1px #111111;
box-shadow: 0 0 5px 1px #111111;
-webkit-border-radius: 3px 3px 3px 3px;
-moz-border-radius: 3px 3px 3px 3px;
top: 100px;
position: absolute;
z-index: 1050;
color: #eee;
}
.style-toggler {
cursor: pointer;
}
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew-black.png) !important;
border-bottom-color: transparent !important;
}
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew-black.png) !important;
border-bottom-color: transparent !important;
}	
.container {
	height : 2000px;
	position: absolute;
	
}

   		</style>

	<div class="myBody">
  	<jsp:include page="../Common/ImportJS.jsp" />
  	<div class="style-toggler">
		<img src="/ApplicationImages/DashBoard/color.png" alt="" class='tip' onclick="toggle_visibility('style-switcherid')">
	</div>	
		
<div class="style-switcher" id="style-switcherid" hidden="true">
</div>
  	<script type="text/javascript">
	var innerpage=<%=ipVal%>;	
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
	
	function toggle_visibility(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'none')
          e.style.display = 'block';
       else
          e.style.display = 'none';
    }
	var customerID=0;
	var customerName='';
    var customerPanel;
   	var map;
	var circle;
	var circle1;
	var circle2;
	var centerLongitude =0.0;
	var centerLatitude  =0.0;
	var facility  ='';	
	var createCircle;
	var createCircle1;
	var createCircle2;
	
	var defaultmapOptions = {
	        zoom: 10,
	        center: new google.maps.LatLng('12.972442', '77.583847'),
	        mapTypeId: google.maps.MapTypeId.ROADMAP
	    };

	    map = new google.maps.Map(document.getElementById('content'), defaultmapOptions);
	    
	 var shiftstore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/DashBoard.do?param=getshift',
				   id:'Shift',
			       root: 'Shift',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['shift'],
				   listeners: {
    				load: function(shifttimestore, records, success, options) {
    				}}
	});
	
	
	 if(<%=customeridlogged%>==0){
			var sessionInterval = setInterval(function() {
			if(customerID>0){
			var myMask = new Ext.LoadMask(mainPanel.getEl(), {msg:"Loading..."});
								myMask.show();	                 	    	                 	   	
		              customerLatLong.load({
		              params:{facility:customerName},
		               callback:function(){
		     				shiftstore.load({params:{facility:customerName},	
		                 	     callback:function(){
		                 	     	if(shiftstore.getCount()==0)
		                 	   			{
		                 	   				myMask.hide();
		                 	   				return;
		                 	   			}
		                 	   	 Ext.getCmp('shiftcomboId').setValue(shiftstore.getAt(0).data['shift']);	             	   		
    						markers.load({
		              			params:{custID:customerID,facility:customerName,shifttime:Ext.getCmp('shiftcomboId').getValue()},
		              			callback:function(){			                                						 
          								     initialize(); 
          								     setAllCircles(Ext.getCmp('sliderValue1').getValue(),Ext.getCmp('sliderValue2').getValue(),Ext.getCmp('sliderValue3').getValue());      															
			                   			 	 myMask.hide();
			                   			 	 //toggle_visibility('style-switcherid');
			                   			 }
			          });
			          }
			          });
			          }
		});
		}
		}, 300000);
		}
		else if(<%=customeridlogged%>>0)
		{
		var sessionInterval = setInterval(function() {
			var myMask = new Ext.LoadMask(mainPanel.getEl(), {msg:"Loading..."});
								myMask.show();	                 	    	                 	   	
		                 	    customerLatLong.load({
		                 	    params:{facility:'<%=customernamelogged%>'},
		                 	   		callback:function(){
		     							shiftstore.load({params:{facility:'<%=customernamelogged%>'},	
		                 	     			callback:function(){
		                 	     				if(shiftstore.getCount()==0)
		                 	   						{
		                 	   							myMask.hide();
		                 	   							return;
		                 	   						}
		                 	   	 Ext.getCmp('shiftcomboId').setValue(shiftstore.getAt(0).data['shift']);	
		                 	   	              	   		
    			markers.load({
		              params:{custID:'<%=customeridlogged%>',facility:'<%=customernamelogged%>',shifttime:Ext.getCmp('shiftcomboId').getValue()},
		              callback:function(){			                                						 
          								     initialize(); 
          								     setAllCircles(Ext.getCmp('sliderValue1').getValue(),Ext.getCmp('sliderValue2').getValue(),Ext.getCmp('sliderValue3').getValue());      															
			                   			 	 myMask.hide();
			                   			 	 //toggle_visibility('style-switcherid');
			                   			 }
			          });
			          }
			          });
			          }
		});
		}, 300000);
		}
		
		
	var markers=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashBoard.do?param=getMapVehicles',
				id:'MapVehicles',
				root: 'MapVehicles',
				autoLoad: false,
				remoteSort: true,
				fields: ['longittude','lattitude','regNo','tripId','employeesOnTrip','vehicleId']
		}); 
	
	var customerLatLong=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashBoard.do?param=getcustomerLatLong',
				id:'CustomerLatLong',
				root: 'CustomerLatLong',
				autoLoad: false,
				remoteSort: true,
				fields: ['longittude','lattitude','facility']
		});
			
	function initialize() {
	var custcolumn=customerLatLong.getAt(0);
	centerLongitude = custcolumn.data['longittude'];
	centerLatitude  = custcolumn.data['lattitude'];	
	facility=custcolumn.data['facility'];
	    var mapOptions = {
	        zoom: 20,
	        center: new google.maps.LatLng(centerLatitude, centerLongitude),
	        mapTypeId: google.maps.MapTypeId.ROADMAP
	    };

	    map = new google.maps.Map(document.getElementById('content'), mapOptions);
	    //Plotting Multiple Markers in Map
	    setMultipleMarkers(map, markers);
	}
	

	function setMultipleMarkers(map, markers) {
	    
	    var infowindow = new google.maps.InfoWindow(), marker, i, image;
    	for (i = 0; i < markers.data.length; i++) { 
    		var column = markers.getAt(i);
    		image = {
	        	url: '/ApplicationImages/VehicleImages/GreenBalloon.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};
    		var pos = new google.maps.LatLng(column.data['lattitude'], column.data['longittude']);
        	marker = new google.maps.Marker({
            	position: pos,
            	map: map,
            	icon: image
        	});
        	
        	
			var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #FFF; background:#ed8719; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td><b>Registration No:</b></td><td>'+column.data['regNo']+'</td></tr>'+
			'<tr><td><b>Vehicle Id:</b></td><td>'+column.data['vehicleId']+'</td></tr>'+
			'<tr><td><b>Trip Id:</b></td><td>'+column.data['tripId']+'</td></tr>'+
			'<tr><td><b>Employess on Trip:</b></td><td>'+column.data['employeesOnTrip']+'</td></tr>'+
			'</table>'+
			'</div>';
			google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){ 
    			return function() {
        			infowindow.setContent(content);
        			infowindow.open(map,marker);
    			};
			})(marker,content,infowindow)); 
			marker.setAnimation(google.maps.Animation.DROP); 
    	}
	}
	
	function setAllCircles(level1,level2,level3) {
			var convertRadiusToMeters = level1 * 1000;
	        var myLatLng = new google.maps.LatLng(centerLatitude, centerLongitude); 
    		var bearing = Math.random()*360;     	      	
	        createCircle = {
	            strokeColor:'#3F6826',
	            strokeOpacity: 0.8,
	            strokeWeight: 2,
	            fillColor: '#3F6826',
	            fillOpacity: 0.65,
	            map: map,
	            center: myLatLng,
	            radius: convertRadiusToMeters //In meters
	        };
	        
        	image1 = {
	        	url: '/ApplicationImages/DashBoard/building-icon.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};
	    	
	    	
        	markerCircle = new google.maps.Marker({
            	position: myLatLng,
            	map: map,
            	icon:image1
        	});
        	
        	var infowindow = new google.maps.InfoWindow(), markerCircle, i, image1;
        	

        	var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #FFF; background:#ed8719; line-height:100%; font-size:100%; font-family: sans-serif;">'+
			'<table>'+
			'<tr><td><b>Facility:</b></td><td>'+facility+'</td></tr>'+
			'<tr><td><b></b></td><td></td></tr>'+
			'</table>'+
			'</div>';

			google.maps.event.addListener(markerCircle,'click', (function(markerCircle,content,infowindow){ 
    			return function() {
        			infowindow.setContent(content);
        			infowindow.open(map,markerCircle);
    			};
			})(markerCircle,content,infowindow)); 
			markerCircle.setAnimation(google.maps.Animation.DROP); 
        	
    		
	        var convertRadiusToMeters = level2 * 1000;
	        createCircle1 = {
	            strokeColor:'#66CCCC',
	            strokeOpacity: 0.8,
	            strokeWeight: 2,
	            fillColor: '#66CCCC',
	            fillOpacity: 0.55,
	            map: map,
	            center: myLatLng,
	            radius: convertRadiusToMeters //In meters
	        };
	        
        	
        	
	        var convertRadiusToMeters = level3 * 1000;
	        createCircle2 = {
	            strokeColor:'#FF8000',
	            strokeOpacity: 0.8,
	            strokeWeight: 2,
	            fillColor: '#FF8000',
	            fillOpacity: 0.35,
	            map: map,
	            center: myLatLng,
	            radius: convertRadiusToMeters //In meters
	        };
	        
        	
	        circle = new google.maps.Circle(createCircle);
	        circle1 = new google.maps.Circle(createCircle1);
	        circle2 = new google.maps.Circle(createCircle2);
	        
	        if(level2!=0)
	        {
	        circle1.setCenter(myLatLng);
	        map.fitBounds(circle1.getBounds());
	        }
	        else if(level3!=0)
	        {
	        circle2.setCenter(myLatLng);
	        map.fitBounds(circle2.getBounds());
	        }
	        else
	        {
	        circle.setCenter(myLatLng);
	        map.fitBounds(circle.getBounds());
	        }
	}
	
	//**************************************************  Main starts from here **************************************************
 Ext.onReady(function(){
 //******************************store for getting customer name************************
  var custmastcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getallCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(cutstore, records, success, options) {
        				 if(<%=customeridlogged%>>0){
        				 Ext.getCmp('custlbl').hide();
        				 Ext.getCmp('custmastcomboId').hide();
		                 	    var myMask = new Ext.LoadMask(mainPanel.getEl(), {msg:"Loading..."});
								myMask.show();	                 	    	                 	   	
		                 	    customerLatLong.load({
		                 	    	params:{facility:'<%=customernamelogged%>'},
		                 	   		callback:function(){
		                 	   			shiftstore.load({params:{facility:'<%=customernamelogged%>'},	
		                 	     			callback:function(){
		                 	     				if(shiftstore.getCount()==0)
		                 	   						{
		                 	   							myMask.hide();
		                 	   							return;
		                 	   						}
		                 	   	 Ext.getCmp('shiftcomboId').setValue(shiftstore.getAt(0).data['shift']);		
		                 	   			markers.load({
		                 	   			params:{custID:'<%=customeridlogged%>',facility:'<%=customernamelogged%>'},
		                 	    			callback:function(){			                                						 
          															initialize();       															
			                                						setAllCircles(Ext.getCmp('sliderValue1').getValue(),Ext.getCmp('sliderValue2').getValue(),Ext.getCmp('sliderValue3').getValue());    
			                                						Ext.getCmp("cbPal11").setValue(true);
		                 	   										Ext.getCmp("cbPal12").setValue(true);
		                 	   										Ext.getCmp("cbPal13").setValue(true);
		                 	   										Ext.getCmp("level1id").setValue(2);
		                 	   										myMask.hide();
		                 	   										//toggle_visibility('style-switcherid');
			                   									}
		                 	   	
		                 	   						}); 
		                 	   			}
		                 	   			});			
		                 	   		}
		                 	   	});	
				 		  }
    				}}
	});
	
	 
//**************************** Combo for Customer Name***************************************************
 var custnamecombo=new Ext.form.ComboBox({
	        store: custmastcombostore,
	        id:'custmastcomboId',
	        mode: 'local',
	        hidden:false,
	        resizable:true,
	        width:130,
	        forceSelection: true,
	        emptyText:'Select Customer',
	        blankText :'Select Customer',
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	//cls:'dashboardcombo',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   customerID=Ext.getCmp('custmastcomboId').getValue();
		                 	   customerName=Ext.getCmp('custmastcomboId').getRawValue();	
		                 	    var myMask = new Ext.LoadMask(mainPanel.getEl(), {msg:"Loading..."});
								myMask.show();                 	    	                 	   	
		                 	    customerLatLong.load({
		                 	    params:{facility:customerName},
		                 	   		callback:function(){
		                 	   	shiftstore.load({params:{facility:customerName},	
		                 	   	callback:function(){
		                 	   		if(shiftstore.getCount()==0)
		                 	   		{
		                 	   			myMask.hide();
		                 	   			return;
		                 	   		}
		                 	   	Ext.getCmp('shiftcomboId').setValue(shiftstore.getAt(0).data['shift']);		                 	   	
		                 	   			markers.load({
		                 	   			params:{custID:customerID,facility:customerName,shifttime:Ext.getCmp('shiftcomboId').getValue()},
		                 	    			callback:function(){			                                						 
          															initialize();       															
			                                						setAllCircles(Ext.getCmp('sliderValue1').getValue(),Ext.getCmp('sliderValue2').getValue(),Ext.getCmp('sliderValue3').getValue());    
			                                						Ext.getCmp("cbPal11").setValue(true);
		                 	   										Ext.getCmp("cbPal12").setValue(true);
		                 	   										Ext.getCmp("cbPal13").setValue(true);
		                 	   										Ext.getCmp("level1id").setValue(2);
		                 	   										myMask.hide();
		                 	   										//toggle_visibility('style-switcherid');
			                   									}
		                 	   	
		                 	   						}); 
		                 	   						}
		                 	   						});
		                 	   		}
		                 	   	});			                 	   	
		                 	   }}
                 	   } 
    });
    
    //**************************** Combo for Shift***************************************************
 var shiftcombo=new Ext.form.ComboBox({
	        store: shiftstore,
	        id:'shiftcomboId',
	        mode: 'local',
	        hidden:false,
	        resizable:true,
	        width:130,
	        forceSelection: true,
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'shift',
	    	displayField: 'shift',
	    	//cls:'dashboardcombo',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   if(<%=customeridlogged%>>0){
		                 	   			var myMask = new Ext.LoadMask(mainPanel.getEl(), {msg:"Loading..."});
								myMask.show();	                 	    	                 	   	
		                 	    customerLatLong.load({
		                 	    params:{facility:'<%=customernamelogged%>'},
		                 	   		callback:function(){
    							markers.load({
		              			params:{custID:'<%=customeridlogged%>',facility:'<%=customernamelogged%>',shifttime:Ext.getCmp('shiftcomboId').getValue()},
		              			callback:function(){			                                						 
          								     initialize(); 
          								     setAllCircles(Ext.getCmp('sliderValue1').getValue(),Ext.getCmp('sliderValue2').getValue(),Ext.getCmp('sliderValue3').getValue());      															
			                   			 	 myMask.hide();
			                   			 	 //toggle_visibility('style-switcherid');
			                   			 }
			          					});
			          					}
									});		     
		                 	   }
		                 	   else{
		                 	   			var myMask = new Ext.LoadMask(mainPanel.getEl(), {msg:"Loading..."});
								myMask.show();	                 	    	                 	   	
		                 	    customerLatLong.load({
		                 	    params:{facility:customerName},
		                 	   		callback:function(){
    							markers.load({
		              			params:{custID:customerID,facility:customerName,shifttime:Ext.getCmp('shiftcomboId').getValue()},
		              			callback:function(){			                                						 
          								     initialize(); 
          								     setAllCircles(Ext.getCmp('sliderValue1').getValue(),Ext.getCmp('sliderValue2').getValue(),Ext.getCmp('sliderValue3').getValue());      															
			                   			 	 myMask.hide();
			                   			 	 //toggle_visibility('style-switcherid');
			                   			 }
			          				});
			          				}
									});		                 	   	
		                 	   }
		                 	   }}
                 	   } 
    });
	
	customerPanel = new Ext.Panel({
				width: 300,	
				id:'customerPanelid1',	
				bodyCfg : { cls:'dashboardcustomerpannelmap' , style: {'background-color': 'transparent !important'} },
				cls:'dashboardcustomerpannelmap',		
				layout:'table',
				layoutConfig:{columns:3},
				items: [{
				 		xtype: 'label',
						text: 'Customer Name',
						id:'custlbl',
						cls:'maplabel'
						},
						{width:10,bodyCfg : { cls:'mapempty' , style: {'background-color': 'transparent !important'} }},
						custnamecombo,
						{
				 		xtype: 'label',
						text: 'Shift',
						id:'shiftlbl',
						cls:'maplabel'
						},
						{width:10,bodyCfg : { cls:'mapempty' , style: {'background-color': 'transparent !important'} }},
						shiftcombo,
						{
				 		xtype: 'label',
						text: 'Transition Interval(sec)',
						id:'pagetranslbl',
						cls:'maplabel'
						},
						{width:10,bodyCfg : { cls:'mapempty' , style: {'background-color': 'transparent !important'} }},
						{
				 		xtype: 'numberfield',
						value: '20',
						width:40,
						id:'pagetranstxt',
						enableKeyEvents:true,
						listeners: {
    					'keyup': function(){
      							parent.pageSwitchingInterval=parseInt(Ext.getCmp('pagetranstxt').getValue()*1000);
    					}
  						}
						}
						]
				});
	
	levelPanel = new Ext.Panel({
				width: 300,	
				id:'levelPanelid',	
				bodyCfg : { cls:'dashboardcustomerpannelmap' , style: {'background-color': 'transparent !important'} },
				cls:'dashboardlevelpannelmap',		
				layout:'table',
				layoutConfig:{columns:5},
				items: [
						{
             			xtype: 'checkbox',
            			id:'cbPal11', 
            			name : 'nCbPal1',
            			width:15,
            			padding:'1%',
            			value: true, 
						checked: true,
            			listeners: {
							check: function() {
								if(Ext.getCmp('cbPal11').getValue())
								{
								Ext.getCmp('sliderValue1').setValue(Ext.getCmp('level1id').getValue());
								circle.setRadius(Ext.getCmp('sliderValue1').getValue() * 1000);
								}
								else
								{
								circle.setRadius(0);
								Ext.getCmp('sliderValue1').setValue(0);
								}
								}
						}   
        				},{
				 		xtype: 'label',
						text: 'Within 1-3 km',
						id:'levellbl1',
						width : 100,
						cls:'maplabel'
						},{
	        			fieldLabel: 'Level 1',
	        			xtype: 'sliderfield',
	        			increment: 1,
	        			minValue: 1,
	        			maxValue: 3,
	        			width:120,
	        			name: 'fx',
	        			id:'level1id',
	        			plugins: new Ext.slider.Tip(),
						expand: function() {
                		Ext.getCmp('level1id').syncThumb();
            			},
	        			onChange: function (slider, v) {
	        			Ext.getCmp("cbPal11").setValue(true);
	        			Ext.getCmp('sliderValue1').setValue(Ext.getCmp('level1id').getValue());
	            		circle.setRadius(Ext.getCmp('level1id').getValue() * 1000);
	            		}
	        			},
	        			{width: 10,bodyCfg : { cls:'mapempty' , style: {'background-color': 'transparent !important'} }},
	        			{
	        			xtype: 'textfield',
	        			id: 'sliderValue1',
	        			value: '2',
	        			width: 35,
	        			disabled: true
	    				},{
             			xtype: 'checkbox',
            			id:'cbPal12', 
            			name : 'nCbPal2',
            			width:15,
            			checked: true,
            			listeners: {
							check: function() {
								if(Ext.getCmp('cbPal12').getValue())
								{
								Ext.getCmp('sliderValue2').setValue(Ext.getCmp('level2id').getValue());
								circle1.setRadius(Ext.getCmp('sliderValue2').getValue() * 1000);
								}
								else
								{
								circle1.setRadius(0);
								Ext.getCmp('sliderValue2').setValue(0);
								}
								}
						}  
        				},
        				{
				 		xtype: 'label',
						text: 'Within 4-6 km',
						id:'levellbl2',
						width : 100,
						cls:'maplabel'
						},{
	        			fieldLabel: 'Level 2',
	        			xtype: 'sliderfield',
	        			increment: 1,
	        			minValue: 4,
	        			maxValue: 6,
	        			width:120,
	        			name: 'fx',
	        			id:'level2id',
	        			plugins: new Ext.slider.Tip(),
	        			onChange: function (slider, v) {
	        			Ext.getCmp("cbPal12").setValue(true);
	        			Ext.getCmp('sliderValue2').setValue(Ext.getCmp('level2id').getValue());
	            		circle1.setRadius(Ext.getCmp('level2id').getValue() * 1000);
	            		}
	        			},
	        			{width: 10,bodyCfg : { cls:'mapempty' , style: {'background-color': 'transparent !important'} }},{
	        			xtype: 'textfield',
	        			id: 'sliderValue2',
	        			value: '4',
	        			width: 35,
	        			disabled: true
	    				},{
             			xtype: 'checkbox',
            			id:'cbPal13', 
            			name : 'nCbPal3',
            			width:15,
            			checked: true,
            			listeners: {
							check: function() {
								if(Ext.getCmp('cbPal13').getValue())
								{
								Ext.getCmp('sliderValue3').setValue(Ext.getCmp('level3id').getValue());
								circle2.setRadius(Ext.getCmp('sliderValue3').getValue() * 1000);
								}
								else
								{
								circle2.setRadius(0);
								Ext.getCmp('sliderValue3').setValue(0);
								}
								}
						}   
        				},{
				 		xtype: 'label',
						text: 'Within 7-12 km',
						id:'levellbl3',
						width : 100,
						cls:'maplabel'
						},{
	        			fieldLabel: 'Level 3',
	        			xtype: 'sliderfield',
	        			increment: 1,
	        			minValue: 7,
	        			maxValue: 12,
	        			width:120,
	        			name: 'fx',
	        			id:'level3id',
	        			plugins: new Ext.slider.Tip(),
	        			onChange: function (slider, v) {
	        			Ext.getCmp("cbPal13").setValue(true);
	        			Ext.getCmp('sliderValue3').setValue(Ext.getCmp('level3id').getValue());
	            		circle2.setRadius(Ext.getCmp('level3id').getValue() * 1000);
	            		}
	        			},
	        			{width:10,bodyCfg : { cls:'mapempty' , style: {'background-color': 'transparent !important'} }},{
	        			xtype: 'textfield',
	        			id: 'sliderValue3',
	        			value: '7',
	        			width: 35,
	       			    disabled: true
	    				}]
	});	
	mainPanel = new Ext.Panel({
				width: 300,	
				id:'mainPanelid',	
				bodyCfg : { cls:'dashboardcustomerpannelmap' , style: {'background-color': 'transparent !important'} },
				cls:'dashboardcustomerpannelmap',		
				items: [customerPanel,levelPanel]
				});
						
	mainPanel.render('style-switcherid');			 		                
	});
	//google.maps.event.addDomListener(window, 'load', initialize);
    </script>
	</div>
	</div>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

<script> 
	  if (innerpage == true) {
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
	  }
						
	</script>