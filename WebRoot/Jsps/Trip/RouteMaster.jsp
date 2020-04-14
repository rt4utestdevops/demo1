<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>

<%
String path = request.getContextPath();
Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
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
String Cid="";
String startDate="";
String reg="";
String startHour="";
String StartMin="";
String endDate="";
String EndHour="";
String EndMin="";
String timeBand="";
String clId="";
String sysId="";
String list="";
if(request.getParameter("ClientName")!= null)
{
Cid=request.getParameter("ClientName");
Cid=Cid.replace(","," ");
}
if(loginInfo.getStyleSheetOverride().equals("Y"))
{
	Cid=cf.getCustomerName(String.valueOf(customerId),systemid);
	if(Cid == null)
	{
		Cid="";
	}
}
if(request.getParameter("list")!= null)
{
list=request.getParameter("list");
}

if(request.getParameter("reg")!=null)
{
reg=request.getParameter("reg");
reg=reg.replaceAll("%20"," ");
System.out.println("......."+reg);
}
if(request.getParameter("startDate")!=null)
{
startDate=request.getParameter("startDate");
}
if(request.getParameter("startHour")!=null)
{
startHour=request.getParameter("startHour");
}
if(request.getParameter("StartMin")!=null)
{
StartMin=request.getParameter("StartMin");
}
if(request.getParameter("endDate")!=null)
{
endDate=request.getParameter("endDate");
}
if(request.getParameter("EndHour")!=null)
{
EndHour=request.getParameter("EndHour");
}
if(request.getParameter("EndMin")!=null)
{
EndMin=request.getParameter("EndMin");
}
if(request.getParameter("timeBand")!=null)
{
timeBand=request.getParameter("timeBand");
}
if(request.getParameter("clientid")!=null)
{
clId=request.getParameter("clientid");
}
if(request.getParameter("systemId")!=null)
{
sysId=request.getParameter("systemId");
}
%>
<jsp:include page="../Common/header.jsp" />
<title>RouteCreation</title>
   <script src="<%=GoogleApiKey%>"></script>
   <style>
   #room_fileds{
   height:500px;
   max-height: 357px;
   overflow: auto;
   background-color:#fff;
   border: solid 2px #A5BED1;
   }
	label {
		display : inline !important;
	}
	.ext-strict .x-form-text {
		height : 21px !important;
	}	
	.footer {
		bottom : -20px !important;
	}
	
   </style>

<div id="room_fileds1" style="visibility: hidden;height:0px;">
            <div>
              <span><input id="lat" type="text" style="width:142px;" name="lati" value="" readOnly/><input  id="long" type="text" style="width:142px;" name="longi" value="" readOnly/></span> 
           </div>
        </div>
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
	<style>
		.labelstyle {
		margin-bottom : 12px !important;
		
	}
	.x-window-tl *.x-window-header {
			height : 36px !important;
		}
	</style>
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
var route1=0;
var jsonArray1 = [];
var Cid='<%=Cid%>';
var Reg='<%=reg%>';
window.onload = function () { 
		CallRoute1();
	}
function initialize() {
    var opts = {
        'center': new google.maps.LatLng(22.89, 78.88),
        'zoom': 5,
        'mapTypeId': google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById('mapid'), opts);

    var lineSymbol = {
        path: google.maps.SymbolPath.FORWARD_OPEN_ARROW, //CIRCLE,
        scale: 2
    };

    polyOptions = {
        strokeColor: '#0026b3',
        strokeOpacity: .6,
        strokeWeight: 5,
        geodesic: true,
        icons: [{
            icon: lineSymbol,
            repeat: '100px'
        }]
    }

    polyLine = new google.maps.Polyline(polyOptions);
    polyLine.setMap(map);


    var Lat;
    var Long;
    var LatInput = document.getElementById('lat');
    var LongInput = document.getElementById('long');


    google.maps.event.addListener(map, 'dblclick', function (event) {

        LatInput.value = event.latLng.lat();
        LongInput.value = event.latLng.lng();
        Lat = LatInput.value;
        Long = LongInput.value;
        add_fields(Lat, Long);
        addPoint(event);
    })
    animateCircle();
}

function animateCircle() {
    var count = 0;
    window.setInterval(function () {
        count = (count + 1) % 200;

        var icons = polyLine.get('icons');
        icons[0].offset = (count / 2) + '%';
        polyLine.set('icons', icons);
    }, 100);
}

function CallRoute1(){
setTimeout(function(){CallRoute();}, 500);
}

function CallRoute(){
if(Reg!='')
{
if(Cid!='Select Client')
{
Ext.getCmp('custcomboId').setValue(Cid);
} else {
Ext.getCmp('custcomboId').setValue('<%=customerName1%>');
}
Ext.getCmp('mapdivid').enable();
Ext.getCmp('create').setValue(true);
plotRoutedetailsstore.load({
				params:{
				reg:'<%=reg%>',
				startDate:'<%=startDate%>',
				startHour:'<%=startHour%>',
				StartMin:'<%=StartMin%>',
				endDate:'<%=endDate%>',
				EndHour:'<%=EndHour%>',
				EndMin:'<%=EndMin%>',
				timeBand:'<%=timeBand%>',
				clId:'<%=clId%>',
				sysId:'<%=sysId%>'
				},
				callback:function()
				{
				for(i=0;i<plotRoutedetailsstore.getCount();i++)
				{
				add_fields(plotRoutedetailsstore.getAt(i).data['lat'],plotRoutedetailsstore.getAt(i).data['long']);
			    var myLatLng = new google.maps.LatLng(plotRoutedetailsstore.getAt(i).data['lat'],plotRoutedetailsstore.getAt(i).data['long']);  
				var path = polyLine.getPath();
				path.push(myLatLng);
				marker = new google.maps.Marker({
							position:myLatLng,
							map: map,
							icon:'http://chart.googleapis.com/chart?chst=d_map_pin_letter&chld='+route+'%7cF0606B%7cFFFFFF&.png%3f'
							//draggable: true
				});
				markers.push(marker);
				map.setCenter(myLatLng);
				}
				}
				});
				Ext.getCmp('savebuttonid').show();
                Ext.getCmp('cancelbuttonid').show();
               
}
}

function add_fields(Lat, Long) {

    route++;
    routeCount = route;
    var addLat = Lat;
    var addLong = Long;
    var btnId = route;

    var objTo = document.getElementById('room_fileds');
    var divtest = document.createElement("div");
    divtest.setAttribute('id', btnId);
    divtest.style.padding = '7px';
    divtest.style.backgroundColor = '#fdfdf1';
    divtest.style.border = '1px solid #CCCCCC';
    divtest.style.fontFamily = 'Arial,sans-serif';
    divtest.style.fontSize = '13px';
	var mapid='mapid';
	var bgcolor;
	var color;
	//if(route%2 !=0)
	//{
	//bgcolor='#63ABEE';
	//color='#FFFFFF';
	//divtest.style.backgroundColor = '#63ABEE';
	//divtest.style.color= '#FFFFFF';
	//}
	//else
	//{
	bgcolor='#FFFFFF';
	divtest.style.backgroundColor = '#FFFFFF';
	//}
    divtest.innerHTML += '<div class="label" id=Div_' + btnId + ' name="root" value="' + route + '">Point :' + route + ' <button  id=button_' + btnId + ' style="float: right;height: 22px;" onclick="removeElement(' + route + ');removePoint();">x</button></div><div class="content" ><span>Latitude:<input id=lat_' + btnId + ' type="label" style="width:95px;margin-left:11%;border:0;background-color:'+bgcolor+'"name="lati" readOnly value="' + addLat + '"\></span><br><span>Longitude:<input id=long_' + btnId + ' type="label" style="width:95px;margin-left:6%;border:0;background-color:'+bgcolor+'" name="longi" readOnly value="' + addLong + '"\></span></div>';
	if(btnId!=1)
	{
	var prevBtn=btnId-1;
	document.getElementById('button_'+prevBtn).hidden = true;
	}
    objTo.appendChild(divtest);

    var limit = 0;
    if (route > 2) {
        limit = 2;
    }
}

var marker;

function addPoint(event) {
    var path = polyLine.getPath();
    path.push(event.latLng);

    marker = new google.maps.Marker({
        position: event.latLng,
        map: map,
        icon:'http://chart.googleapis.com/chart?chst=d_map_pin_letter&chld='+route+'%7cF0606B%7cFFFFFF&.png%3f',
        //draggable: true
    });
    markers.push(marker);
    //map.setCenter(event.latLng);
}

function removeElement(divNum) {
    routeCount--;
    route--;
    var d = document.getElementById('room_fileds');
    var olddiv = document.getElementById(divNum);
    d.removeChild(olddiv);
	if(divNum!=1)
	{
	var prevBtn=divNum-1;
	document.getElementById('button_'+prevBtn).hidden = false;
	}
    //document.getElementById('button_' + routeCount).innerHTML = 'X';
}

function removePoint() {
    for (var i = markers.length - 1; i >= 0; i--) {
        marker = markers[i];
        if (markers[i] == marker) {
            // Delete marker
            markers[i].setMap(null);
            markers.splice(i, 1);
            // Delete polyline point
            polyLine.getPath().removeAt(i);
            break;
        }
    }
}


var customercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
        if(Reg==''){
            if ( <%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
               } 
            }
        }
    }
});

var routecombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/routeAction.do?param=getRouteNames',
    id: 'RouteNametoreId',
    root: 'RouteNameRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['RouteId', 'RouteName']
});

var routedetailsstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/routeAction.do?param=getRouteDetails',
    id: 'RouteDetailstoreId',
    root: 'RouteDetailsRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['sequence', 'lat','long']
});

var plotRoutedetailsstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/routeAction.do?param=getPlotRouteDetails',
    id: 'PlotRouteDetailstoreId',
    root: 'PlotRouteDetailsRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['sequence', 'lat','long']
});
//******************************************* Customer Combo***************************************************

var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
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
            fn: function () {
            	while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
                jsonArray=[];	
                Ext.getCmp('routenamecomboId').reset();		
				routecombostore.load({
				params:{CustId:Ext.getCmp('custcomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid}
				});
            }
        }
    }
});

var routenamecombo = new Ext.form.ComboBox({
    store: routecombostore,
    id: 'routenamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Route',
    selectOnFocus: true,
    hidden:true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'RouteId',
    width: 170,
    displayField: 'RouteName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
               	while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
            	routedetailsstore.load({
				params:{
				CustId:Ext.getCmp('custcomboId').getValue(),
				RouteId:Ext.getCmp('routenamecomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid
				},
				callback:function()
				{
				for(i=0;i<routedetailsstore.getCount();i++)
				{
								add_fields(routedetailsstore.getAt(i).data['lat'],routedetailsstore.getAt(i).data['long']);
            					var myLatLng = new google.maps.LatLng(routedetailsstore.getAt(i).data['lat'],routedetailsstore.getAt(i).data['long']);  
            					var path = polyLine.getPath();
    							path.push(myLatLng);

    							marker = new google.maps.Marker({
        						position:myLatLng,
        						map: map,
        						icon:'http://chart.googleapis.com/chart?chst=d_map_pin_letter&chld='+route+'%7cF0606B%7cFFFFFF&.png%3f'
        						//draggable: true
    							});
    							markers.push(marker);
    							map.setCenter(myLatLng);
				}
				}
				});

            }
        }
    }
});

var comboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    layout: 'table',
    height: 50,
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: 'Customer Name',
            cls: 'labelstyle',
            id: 'custnamelab'
        }, {
            width: 1
        },
        custnamecombo,{
            xtype: 'label',
            text: 'Route Name',
            cls: 'labelstyle',
            hidden:true,
            id:'routeNameId'
        }, {
            width: 1,id:'routeNameSpaceId',hidden:true
        },
        routenamecombo
    ]


});
/**************************textPanel**********************************/

var textPanel = new Ext.Panel({
    title: 'Left Route',
    id: 'room_fileds',
    standardSubmit: true,
    collapsible: false,
    frame: true,
    height: 100
});


/******************************Window static button panel****************************/
var routeValue;
var textValue;
var buttonPanel = new Ext.Panel({
    standardSubmit: true,
    id: 'buttonId',
    collapsible: false,
    layout: 'table',
    frame: true,
    layoutConfig: {
        columns: 5
    },
    items: [{
        xtype: 'button',
        text: 'Save',
        iconCls:'savebutton',
        id: 'savebuttonid',
        hidden:true,
        cls: ' ',
        width: 80,
        listeners: {
            click: {
                fn: function () {
					
					if(Ext.getCmp('view').getValue())
					{
						save();
					} else if(Ext.getCmp('create').getValue())
					{
                    	myWin.show();
                    	Ext.getCmp('textid').reset();
						Ext.getCmp('textid1').reset();
					}

                }
            }
        }
    },{width:10},{
        xtype: 'button',
        text: 'Clear',
        id: 'cancelbuttonid',
        iconCls: 'cancelbutton',
        hidden:true,
        cls: ' ',
        width: 80,
        listeners: {
            click: {
                fn: function () {
                    while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
            jsonArray=[];
                }
            }
        }
    },{width:10},{
        xtype: 'button',
        text: 'Delete',
        hidden:true,
        id: 'deletebuttonid',
        cls: ' ',
        width: 80,
        listeners: {
            click: {
                fn: function () {
                 if(Ext.getCmp('routenamecomboId').getValue()=="")
			 	{
			  		Ext.example.msg("Select Route Name");
			  		return;
			 	}
			 	
			 
			 	Ext.Ajax.request({
			 		url: '<%=request.getContextPath()%>/routeAction.do?param=checkRoutesAssociatedWithVehicle',
        				method: 'POST',
        				params: {
            				routeId: Ext.getCmp('routenamecomboId').getValue(),
            				CustID:Ext.getCmp('custcomboId').getValue(),
							clId:'<%=clId%>'
        				},
        				success: function (response, options) {
        				outerPanel.getEl().unmask();
            				 var message = response.responseText;
            				 console.log("message : " + message);
                                Ext.Msg.show({msg: message,
                                 buttons: {
                					yes: true,
                					no: true
            					},
            				   fn: function (btn) {
               						switch (btn) {
                					case 'yes':
               					    outerPanel.getEl().mask();
               					 Ext.Ajax.request({
        							url: '<%=request.getContextPath()%>/routeAction.do?param=deleteRoute',
        							method: 'POST',
        							params: {
        								CustID:Ext.getCmp('custcomboId').getValue(),
            							routeId: Ext.getCmp('routenamecomboId').getValue(),
            							clId:'<%=clId%>',
            							Cid:Cid

        							},
        							success: function (response, options) {
        								outerPanel.getEl().unmask();
            				 			var message = response.responseText;
                                			Ext.example.msg(message);
           									while(route!=0)
                							{
                								removeElement(route);
                								removePoint();
                							}
                							jsonArray=[];
   			  			    				Ext.getCmp('routenamecomboId').reset();
           									routecombostore.load({
											params:{CustId:Ext.getCmp('custcomboId').getValue(),
											clId:'<%=clId%>',
            								Cid:Cid}
									});     	

      							  },
        		  				  failure: function () {
        		  					outerPanel.getEl().unmask();
              	  					Ext.example.msg("Route Deletion Unsucessfull");
             						while(route!=0)
                					{
                						removeElement(route);
                						removePoint();
                					}
                					jsonArray=[];
             						Ext.getCmp('routenamecomboId').reset();   	
        						}
    						});
    						break;
                					case 'no':
                   	 				Ext.example.msg("Route not deleted");
                   	 				store.reload();
                   	 				break;

                			}
           				 }
            					});
                          }
			 	});
       
                }
            }
        }
    }]
});

var rightPanel = new Ext.Panel({
    title: 'Route Map',
    standardSubmit: true,
    id:'mapdivid',
    collapsible: false,
    disabled:true,
    frame: true,
    width: screen.width - 300,
    height: 530,
    html : '<div id="mapid" style="width:100%;height:520px;border:0;">'
});

var leftPanel = new Ext.Panel({
    id: 'leftContentId',
    title:'Route',
    standardSubmit: true,
    collapsible: false,
    frame: true,
    height: 530,
    width: 275,
    layout: 'table',
    layoutConfig: {
        columns: 1
    },
    items: [comboPanel,{
            xtype: 'radiogroup',
            fieldLabel: '',
            width:265,
            id:'radiogroupid',
            items: [
            
            			{boxLabel: 'Create',name: 'show',id:'create',width:20,inputValue: '2'},
                		{boxLabel: 'Modify',name: 'show',id:'view',width:20,inputValue: '1'},
                		{boxLabel: 'Delete',name: 'show',id:'delete',width:20,inputValue: '3'}
            		],
            	listeners: {
                change: function(field, newValue, oldValue) {
                if(Ext.getCmp('view').getValue())
                {
                 	if(Ext.getCmp('custcomboId').getValue()=="")
                	{
                 		Ext.getCmp('view').setValue(false);
                	 	Ext.getCmp('create').setValue(false);
                 		Ext.example.msg("Select Customer");
                		return;
                	}
                  Ext.getCmp('savebuttonid').show();
				  Ext.getCmp('cancelbuttonid').show();
                  Ext.getCmp('deletebuttonid').hide();	
                  Ext.getCmp('mapdivid').enable();
                  Ext.getCmp('routenamecomboId').show();
                  Ext.getCmp('routeNameSpaceId').show();
                  Ext.getCmp('routeNameId').show();
                  Ext.getCmp('delete').setValue(false);
                  Ext.getCmp('create').setValue(false);
                    routecombostore.load({
				params:{CustId:Ext.getCmp('custcomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid}
				});
                } else if(Ext.getCmp('create').getValue())
                {
                  if(Ext.getCmp('custcomboId').getValue()=="")
                	{
                 		Ext.getCmp('view').setValue(false);
                 		Ext.getCmp('create').setValue(false);
                 		Ext.example.msg("Select Customer");
                		return;
                	}
                	while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
                  Ext.getCmp('mapdivid').enable();
                  Ext.getCmp('savebuttonid').show();
                  Ext.getCmp('cancelbuttonid').show();
                  Ext.getCmp('deletebuttonid').hide();	
                  Ext.getCmp('routenamecomboId').reset();	
                  Ext.getCmp('routenamecomboId').hide();
                  Ext.getCmp('routeNameSpaceId').hide();
                  Ext.getCmp('routeNameId').hide();
                  Ext.getCmp('delete').setValue(false);
                  Ext.getCmp('view').setValue(false);
                  }
                else if(Ext.getCmp('delete').getValue())
                {
                Ext.getCmp('mapdivid').disable();
                if(Ext.getCmp('custcomboId').getValue()=="")
                	{
                 		Ext.getCmp('view').setValue(false);
                 		Ext.getCmp('delete').setValue(false);
                 		Ext.example.msg("Select Customer");
                		return;
                	}
                Ext.getCmp('savebuttonid').hide();
			    Ext.getCmp('cancelbuttonid').hide();                
                Ext.getCmp('deletebuttonid').show();
                Ext.getCmp('routenamecomboId').show();
                Ext.getCmp('routeNameSpaceId').show();
                Ext.getCmp('routeNameId').show();
                Ext.getCmp('view').setValue(false);
                Ext.getCmp('create').setValue(false);
                }
            }}
        	},{
            id: 'room_fileds'
        },
        buttonPanel
    ]
});

function save() {
    if(Ext.getCmp('textid').getValue()=="")
 	{
  		Ext.example.msg("Enter Source Route Name");
  		return;
 	}
 	if(Ext.getCmp('textid1').getValue()=="")
 	{
  		Ext.example.msg("Enter Destination Route Name");
  		return;
 	}
 	if(Ext.getCmp('create').getValue() == "true") {
 		if(Ext.getCmp('textid').getValue()==Ext.getCmp('textid1').getValue())
 		{
 			Ext.example.msg("Source and Destination Route name can not be same");
  			return;
 		}
 	}
 	
    var sourcetextValue = Ext.getCmp('textid').getValue();
    var destinationtextValue = Ext.getCmp('textid1').getValue();
    textValue = sourcetextValue + '-' + destinationtextValue;
    var i = 1;
    
        for (i = 1; i <= route; i++) {
            var latitude = document.getElementById("lat_" + i).value;
            var longitude = document.getElementById("long_" + i).value;
			jsonArray.push('{'+i+','+latitude+','+longitude+'}');
            var stringData = JSON.stringify(jsonArray)
}
   if(route<2)
   {
   Ext.example.msg("Minimum 2 points required to create a route");
   return;
   }
	if(Ext.getCmp('create').getValue())
	{
	outerPanel.getEl().mask();
    	Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/routeAction.do?param=getRouteCreation',
        method: 'POST',
        params: {
        	CustID:Ext.getCmp('custcomboId').getValue(),
            routeName: textValue,
            routeValue: stringData,
            clId:'<%=clId%>',
            Cid:Cid

        },
        success: function (response, options) {
        outerPanel.getEl().unmask();
           var message = response.responseText;
            Ext.example.msg(message);
           while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
            jsonArray=[];
            routecombostore.load({
				params:{CustId:Ext.getCmp('custcomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid}
				}); 
				myWin.hide();
  	
        },
        failure: function () {
        outerPanel.getEl().unmask();
           Ext.example.msg("Route Creation Unsucessfull");
           while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
                	jsonArray=[];
                	myWin.hide();
        }
    });
    if(Reg!='')
    {
    if(Ext.getCmp('create').getValue())
    {
     Ext.getCmp('create').setValue(false);
     }
     routecombostore.load({
				params:{CustId:Ext.getCmp('custcomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid}
				});
	} else {
	if(Ext.getCmp('create').getValue())
    {
     Ext.getCmp('create').setValue(false);
     }
	}
	}
	else if(Ext.getCmp('view').getValue())
	{
		outerPanel.getEl().mask();
		Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/routeAction.do?param=updateRouteDetails',
        method: 'POST',
        params: {
        	CustID:Ext.getCmp('custcomboId').getValue(),
            routeId: Ext.getCmp('routenamecomboId').getValue(),
            routeValue: stringData,
            clId:'<%=clId%>',
            Cid:Cid

        },
        success: function (response, options) {
        outerPanel.getEl().unmask();
          var message = response.responseText;
          Ext.example.msg(message);
           while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
                	jsonArray=[];
           Ext.getCmp('routenamecomboId').reset();
           routecombostore.load({
				params:{CustId:Ext.getCmp('custcomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid}
				});     	

        },
        failure: function () {
        outerPanel.getEl().unmask();
             Ext.example.msg("Route Updation Unsucessfull");
             while(route!=0)
                	{
                		removeElement(route);
                		removePoint();
                	}
                	jsonArray=[];
             Ext.getCmp('routenamecomboId').reset();   	
        }
        });
     if(Reg!='')
    {
    routecombostore.load({
				params:{CustId:Ext.getCmp('custcomboId').getValue(),
				clId:'<%=clId%>',
            	Cid:Cid}
				});
	}
        }
   }
var outerPanelWindow = new Ext.Panel({
        width: '100%',
        border:true,
        //standardSubmit: true,
        frame: false,
        height:280,
        layout: 'column',
    layoutConfig: {
        columns:3
    },
        items: [ {width:'33%',height:10,border:false}, {width:'33%',height:10,border:false}, {width:'34%',height:10,border:false},
        {
        xtype: 'label',
        text: '  Source Route Name',
        cls: 'labelstyle',
        id: 'RouteId'
    }, {width:41,height:30,border:false},{
        xtype: 'textfield',
        id: 'textid',
        name: 'routeName',
        allowBlank: false,
        width: 140,
        height:30 
    }, {width:'33%',height:5,border:false}, {width:'33%',height:5,border:false}, {width:'34%',height:5,border:false},{
        xtype: 'label',
        text: ' Destination Route Name',
        cls: 'labelstyle',
        id: 'RouteId1'
    }, {width:40,height:30,border:false},{
        xtype: 'textfield',
        id: 'textid1',
        name: 'routeName',
        allowBlank: false,
        width: 140,
        height:30 
    }, {width:'33%',height:5,border:false}, {width:'33%',height:5,border:false}, {width:'34%',height:5,border:false},{width:'40%',height:5,border:false},{
        xtype: 'button',
        itemId: 'save',
        text: 'Save',
        //bodyCfg : { style: {cls:'' ,'margin-left': '14% !important'} },
        width:50,
        height:30,
        handler: function () {
            save();
           
        }
    },{width:'1%',height:5,border:false}, {
        xtype: 'button',
        itemId: 'cancel',
        text: 'Cancel',
        //bodyCfg : { style: {'margin-left': '50% !important'} },
        width:50,
        height:30,
        handler: function () {
            myWin.hide();
        }
    }, {width:'33%',height:15,border:false}, {width:'33%',height:5,border:false}, {width:'34%',height:5,border:false}]
    });
    
//*******************************window*************************************//
myWin = new Ext.Window({
    title: 'Enter Route Name',
    height:200,
    width: 400,
    closable: false,
    resizable: false,
    autoScroll: false,
    items: [outerPanelWindow]

});


Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width:screen.width-22,
        height: 550,
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [leftPanel, rightPanel]
    });
    initialize();
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

