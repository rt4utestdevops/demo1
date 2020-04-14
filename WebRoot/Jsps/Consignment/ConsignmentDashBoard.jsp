<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
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
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int customerId=loginInfo.getCustomerId();
String vehicleTypeRequest = "all";
Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
int custId=0;

String clientIdFromDetails=request.getParameter("clientIdFromDetails");
String regionFromDetails=request.getParameter("regionFromDetails");
String dashBoardSummary=request.getParameter("dashBoardSummary");
String custName=request.getParameter("custName");
String bookingCustomerNameRawValueFromDetails=request.getParameter("bookingCustomerNameRawValueFromDetails");
String transporterRawValueFromDetails=request.getParameter("transporterRawValueFromDetails");
String bookingCustomerNameFromDetails=request.getParameter("bookingCustomerNameFromDetails");
String transporterFromDetails=request.getParameter("transporterFromDetails");
int bookingCustomerId=0;
int transporter=0;

 String nameFromLoginCustomer = request.getParameter("name");
 String bookingCustnameFromLoginCustomer = request.getParameter("bookingCustname");
 String bookingCustIdFromLoginCustomer = request.getParameter("bookingCustId");
 String systemIdFromLoginCustomer = request.getParameter("systemId");
 String custIdFromLoginCustomer = request.getParameter("custId");
 String customerLogin = request.getParameter("customerLogin");
 String regionFromCustomerLogin = "ALL";
String customerLogin1 = request.getParameter("customerLogin1");


ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Select_Region");
tobeConverted.add("View");
tobeConverted.add("Customer_Name");
tobeConverted.add("Region");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Please_Click_On_View_To_Get_The_Data");
tobeConverted.add("Please_Click_On_View_To_Get_The_Data");
tobeConverted.add("Select_Booking_Customer");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomerName=convertedWords.get(0);
String SelectRegion=convertedWords.get(1);
String View=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String Region=convertedWords.get(4);
String NoRecordFound=convertedWords.get(5);
String Pleaseclickonviewtogetthedata=convertedWords.get(6);
String SelectBookingCustomer = convertedWords.get(7);

%>
<jsp:include page="../Common/header.jsp" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
   
	<title>Map</title>
	<style type="text/css">
#image-info {
	text-align: left;
	width: 501px;
	float: left;
}

#image-info img {
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
	height: 550px;
}

.mp-map-wrapper1 {
	width: 99.5%;
	height: 441px;
	position: absolute;
}

.x-table-layout1 td {
	vertical-align: top;
}

.mp-container1 {
	background: #f4f4f4;
	border: 5px solid #fff;
	width: 45%;
	height: 480px;
	position: relative;
	margin: initial;
	left: 2%;
	-moz-box-shadow: 1px 1px 3px #cac4ab;
	-webkit-box-shadow: 1px 1px 3px #cac4ab;
	box-shadow: 1px 1px 3px #cac4ab;
}
.main1 {
width: 100%;
height: 498px;   
float: left;
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}
.mp-vehicle-details-wrapper1 {
width: 40.5%;
height: 550px;
float: right;
background-color: #ffffff;
overflow: auto;
overflow-x: hidden;
}

		#pac-input {
        background-color: #fff;
        padding: 0 11px 0 13px;
        width: 400px;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        text-overflow: ellipsis;
      }
      
      .controls {
        margin-top: 6px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 32px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
      }
      
      .combodiv1{
width:100%;
height:63px;
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}
		.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}
.bodyBackGround{
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}
@media screen and (max-device-width: 1024px) {
  #custMaster{
  	width: 90%;  	
	}
}
</style>

	
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/mapView/css/component.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/mapView/css/layout.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
				      <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/layout.css" /> 
		<link rel="stylesheet" type="text/css" href="../../Main/modules/consignment/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/consignment/dashBoard/css/component.css" />
		 <link rel="stylesheet" type="text/css" href="../../Main/modules/consignment/dashBoard/css/style.css" />
		
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<pack:script src="../../Main/Js/Common.js"></pack:script>

		<!-- for grid -->
		<pack:script
			src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
		<pack:script src="../../Main/Js/Jquery-min.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
		<pack:style src="../../Main/resources/css/common.css" />
		<pack:style src="../../Main/resources/css/commonnew.css" />
		<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
		<pack:script src="../../Main/Js/examples1.js"></pack:script>
        <pack:style src="../../Main/resources/css/examples1.css" />

		<!-- for grid -->
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		
		<style>			
			label {
				display : inline !important;
			}
		</style>
	
	<script src=<%=GoogleApiKey%>></script>
	<div  class="bodyBackGround" >
		<div class="container">
	
			<div id="vehicletype">
			</div>
			<div class="combodiv1" id="customerIddiv1">
			</div>
	
			<div class="main1">
			
			  <div id="dd">
	           <a class="back" href=""></a>
            <span class="scroll"></span>
            <table class="table1">
                <thead>
                    <tr>
                        <th></th>
                        <th></th>
						<th scope="col" abbr="Starter" style="width:700px" ><b>VEHICLES</b></th>
                        <th scope="col" abbr="Medium" style="width:700px"><b>ON TIME</b></th>
                        <th scope="col" abbr="Business" style="width:700px"><b>DELAY</b></th>
                        <th scope="col" abbr="Deluxe" style="width:700px"><b>ALERTS</b></th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th scope="row"><b>Total</b></th>	
						<td>  </td>						
                        <td id="totalId1" />
                        <td id="totalId2" />
                        <td id="totalId3" />
                        <td id="totalId4" />
                    </tr>
                </tfoot>
				<tbody>
				<tr>
					<td rowspan = "3"> <b>NORTH</b> </td>
                        <th scope="row"><b>LOAD</b></th>
						
                        <td id="northLoad1" onclick="link('Load','North','Vehicles');"/>
                        <td id="northLoad2" onclick="link('Load','North','OnTime');"/>
                        <td id="northLoad3" onclick="link('Load','North','Delay');"/>
                        <td id="northLoad4" onclick="link('Load','North','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>EMPTY</b></th>
                        <td id="northEmpty1" onclick="link('Empty','North','Vehicles');"/>
                        <td id="northEmpty2" onclick="link('Empty','North','OnTime');"/>
                        <td id="northEmpty3" onclick="link('Empty','North','Delay');"/>
                        <td id="northEmpty4" onclick="link('Empty','North','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>RETURN LOAD</b></th>
                        <td id="northReturnLoad1" onclick="link('Return Load','North','Vehicles');"/>
                        <td id="northReturnLoad2" onclick="link('Return Load','North','OnTime');"/>
                        <td id="northReturnLoad3" onclick="link('Return Load','North','Delay');"/>
                        <td id="northReturnLoad4" onclick="link('Return Load','North','Alerts');"/>
                    </tr>
                    <tr>
					<td rowspan = "3" style="width:300px"><b> EAST </b>  </td>	
                        <th scope="row"><b>LOAD</b></th>											
                        <td id="eastLoad1" color="#008000" onclick="link('Load','East','Vehicles');"/>
                        <td id="eastLoad2" onclick="link('Load','East','OnTime');" />
                        <td id="eastLoad3" onclick="link('Load','East','Delay');"/>
                        <td id="eastLoad4" onclick="link('Load','East','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>EMPTY</b></th>
                        <td id="eastEmpty1" onclick="link('Empty','East','Vehicles');"/>
                        <td id="eastEmpty2" onclick="link('Empty','East','OnTime');"/>
                        <td id="eastEmpty3" onclick="link('Empty','East','Delay');"/>
                        <td id="eastEmpty4" onclick="link('Empty','East','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row" style="width:600px"><b>RETURN LOAD</b></th>
                        <td id="eastReturnLoad1" onclick="link('Return Load','East','Vehicles');"/>
                        <td id="eastReturnLoad2" onclick="link('Return Load','East','OnTime');"/>
                        <td id="eastReturnLoad3" onclick="link('Return Load','East','Delay');"/>
                        <td id="eastReturnLoad4" onclick="link('Return Load','East','Alerts');"/>
                    </tr>
                    <tr>
					<td rowspan = "3"> <b>WEST </b></td>
                        <th scope="row"><b>LOAD</b></th>
                        <td id="westLoad1" onclick="link('Load','West','Vehicles');"/>
                        <td id="westLoad2" onclick="link('Load','West','OnTime');"/>
                        <td id="westLoad3" onclick="link('Load','West','Delay');"/>
                        <td id="westLoad4" onclick="link('Load','West','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>EMPTY</b></th>
                        <td id="westEmpty1" onclick="link('Empty','West','Vehicles');"/>
                        <td id="westEmpty2" onclick="link('Empty','West','OnTime');"/>
                        <td id="westEmpty3" onclick="link('Empty','West','Delay');"/>
                        <td id="westEmpty4" onclick="link('Empty','West','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>RETURN LOAD</b></th>
                        <td id="westReturnLoad1" onclick="link('Return Load','West','Vehicles');"/>
                        <td id="westReturnLoad2" onclick="link('Return Load','West','OnTime');"/>
                        <td id="westReturnLoad3" onclick="link('Return Load','West','Delay');"/>
                        <td id="westReturnLoad4" onclick="link('Return Load','West','Alerts');"/>
                    </tr>
					
					<tr>
					<td rowspan = "3"><b> SOUTH </b></td>
                        <th scope="row"><b>LOAD</b></th>
						
                        <td id="southLoad1" onclick="link('Load','South','Vehicles');"/>
                        <td id="southLoad2" onclick="link('Load','South','OnTime');"/>
                        <td id="southLoad3" onclick="link('Load','South','Delay');"/>
                        <td id="southLoad4" onclick="link('Load','South','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>EMPTY</b></th>
                        <td id="southEmpty1" onclick="link('Empty','South','Vehicles');"/>
                        <td id="southEmpty2" onclick="link('Empty','South','OnTime');"/>
                        <td id="southEmpty3" onclick="link('Empty','South','Delay');"/>
                        <td id="southEmpty4" onclick="link('Empty','South','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>RETURN LOAD</b></th>
                        <td id="southReturnLoad1" onclick="link('Return Load','South','Vehicles');"/>
                        <td id="southReturnLoad2" onclick="link('Return Load','South','OnTime');"/>
                        <td id="southReturnLoad3" onclick="link('Return Load','South','Delay');"/>
                        <td id="southReturnLoad4" onclick="link('Return Load','South','Alerts');"/>
                    </tr>
					<tr>
					<td rowspan = "3"> <b>TOTAL</b> </td>
                        <th scope="row"><b>LOAD</b></th>
                        <td id="totalLoad1" onclick="link('Load','Total','Vehicles');"/>
                        <td id="totalLoad2" onclick="link('Load','Total','OnTime');"/>
                        <td id="totalLoad3" onclick="link('Load','Total','Delay');"/>
                        <td id="totalLoad4" onclick="link('Load','Total','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>EMPTY</b></th>
                        <td id="totalEmpty1" onclick="link('Empty','Total','Vehicles');"/>
                        <td id="totalEmpty2" onclick="link('Empty','Total','OnTime');"/>
                        <td id="totalEmpty3" onclick="link('Empty','Total','Delay');"/>
                        <td id="totalEmpty4" onclick="link('Empty','Total','Alerts');"/>
                    </tr>
                    <tr>
                        <th scope="row"><b>RETURN LOAD</b></th>
                        <td id="totalReturnLoad1" onclick="link('Return Load','Total','Vehicles');"/>
                        <td id="totalReturnLoad2" onclick="link('Return Load','Total','OnTime');"/>
                        <td id="totalReturnLoad3" onclick="link('Return Load','Total','Delay');"/>
                        <td id="totalReturnLoad4" onclick="link('Return Load','Total','Alerts');"/>
                    </tr>
                </tbody>
            </table>
        <br/>
		   
		   <div class="main2">
		   <a class="back" href=""></a>
            <span class="scroll"></span>
		   <div class="onschedulediv" id="onschedulecountidForBox"> 
		   <div class="iconspace">
		   <span class="spanon"><b>EAST</b></span>
		     <span class="iconon" id="onschedulecountid"  onclick="link('EastFieldBox','East','Vehicles');"><b></b></span>
		     </div>
		   </div>
		   
		    <div class="onschedulediv1" id="onschedulecountidForBox1"> 
		   <div class="iconspace">
		   <span class="spanon1"><b>WEST</b></span>
		    <span class="iconon" id="onschedulecountid1" onclick="link('EastFieldBox','West','Vehicles');"><b></b></span>
		     </div>
		   </div>
		   
		    <div class="onschedulediv2" id="onschedulecountidForBox2"> 
		   <div class="iconspace">
		   <span class="spanon2"><b>NORTH</b></span>
		    <span class="iconon" id="onschedulecountid2" onclick="link('EastFieldBox','North','Vehicles');"><b></b></span>
		     </div>
		   </div>
		  
		    <div class="onschedulediv3" id="onschedulecountidForBox3"> 
		   <div class="iconspace">
		   <span class="spanon3"><b>SOUTH</b></span>
		   <span class="iconon" id="onschedulecountid3" onclick="link('EastFieldBox','South','Vehicles');"><b></b></span>
		     </div>
		   </div>
		   
		   </div>
		   
         </div>
		</div>	
	</div>
	
	  
				<div class="mp-container1" id="mp-container">
					<div class="mp-map-wrapper1" id="map">
					</div>
					<div class="mp-options-wrapper" />
					<div class="mp-option-showhub">
					
					
						 <img class="for-image" src="/ApplicationImages/VehicleImages/greenbal.png">
						<input type="checkbox" id="c1" name="cc"  onclick='load(this);'/>
						<label for="c1"><span></span></label>
						<span class="vehicle-show-details-block-for-consignment1">Load</span>
						
						<img class="for-image" src="/ApplicationImages/VehicleImages/redbal.png">
						<input type="checkbox" id="c3" name="cc"  onclick='empty(this);'/>
            			<label for="c3"><span></span></label>
            			<span class="vehicle-show-details-block-for-consignment1">Empty</span>
						
						<img class="for-image" src="/ApplicationImages/VehicleImages/bluebal.png">
						<input type="checkbox" id="c2" name="cc" onclick='returnload(this);'/>
            			<label for="c2"><span></span></label>
            			<span class="vehicle-show-details-block-for-consignment2">Return Load</span>
            			
							 
						<div class="mp-option-normal" id="option-normal"
							onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"
							onclick="mapFullScreen()"></div>
					</div>
						</div>
				</div>
		<script>
		window.onload = function () { 
		loadAllStores();
	}
		setInterval('loadAllStores()',900000);
		var markers = {};
		var infowindows = {};
		var marker;
		var custId = "";
		var map;
		var All="All";
		var dashBoard = '<%=dashBoardSummary%>';
		var click = 'false';
		var infowindow;
		var status = "";
		var region = "";
		var customerLogin= '<%=customerLogin%>';
		var zeroCheck=false;
		var $mpContainer = $('#mp-container');
		var $mapEl = $('#map');
		var transporter="0";
		var bookingCustomerId="0";
		var customerLogin1='<%=customerLogin1%>';
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		document.getElementById('option-normal').style.display = 'none';
		document.getElementById("vehicletype").value = '<%=vehicleTypeRequest%>';

		function mapFullScreen() {
		    document.getElementById('option-fullscreen').style.display = 'none';
		    document.getElementById('option-normal').style.display = 'block';
		    $mpContainer.removeClass('mp-container-fitscreen');
		    document.getElementById("onschedulecountidForBox").style.visibility = "hidden";
		    document.getElementById("onschedulecountidForBox1").style.visibility = "hidden";
		    document.getElementById("onschedulecountidForBox2").style.visibility = "hidden";
		    document.getElementById("onschedulecountidForBox3").style.visibility = "hidden";
		    $mpContainer.addClass('mp-container-fullscreen').css({
		        width: 'originalWidth',
		        height: 485
		    });
		    $mapEl.css({
		        width: $mapEl.data('originalWidth'),
		        height: $mapEl.data('originalHeight')
		    });
		    google.maps.event.trigger(map, 'resize');
		}

		function reszieFullScreen() {
		    document.getElementById('option-fullscreen').style.display = 'block';
		    document.getElementById('option-normal').style.display = 'none';
		    $mpContainer.removeClass('mp-container-fitscreen');
		    $mpContainer.removeClass('mp-container-fullscreen');
		    $mpContainer.addClass('mp-container1');
		    document.getElementById("onschedulecountidForBox").style.visibility = "visible";
		    document.getElementById("onschedulecountidForBox1").style.visibility = "visible";
		    document.getElementById("onschedulecountidForBox2").style.visibility = "visible";
		    document.getElementById("onschedulecountidForBox3").style.visibility = "visible";
		    $mapEl.css({
		        width: $mapEl.data('originalWidth'),
		        height: $mapEl.data('originalHeight')
		    });
		    google.maps.event.trigger(map, 'resize');
		}

		function initialize() {
		        var mapOptions = {
		            zoom: 4,
		            center: new google.maps.LatLng('22.89', '78.88'),
		            mapTypeId: google.maps.MapTypeId.ROADMAP
		        };
		        map = new google.maps.Map(document.getElementById('map'), mapOptions);
		    }
		    //***********************************Plot Vehicle on Map *******************************************

		function plotSingleVehicle(regNo, latitude, longtitude, location, dateTime, status, speed) {
		    if ((status == 'Load')) {
		        imageurl = '/ApplicationImages/VehicleImages/greenbal.png';
		    } else if (status == 'Empty') {
		        imageurl = '/ApplicationImages/VehicleImages/redbal.png';
		    } else if (status == 'Return Load') {
		        imageurl = '/ApplicationImages/VehicleImages/bluebal.png';
		    } else if (status == 'Waiting For Load') {
		        imageurl = '/ApplicationImages/VehicleImages/yellow.png';
		    }
		    image = {
		        url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
		        size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
		        origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
		        anchor: new google.maps.Point(0, 32)
		    };
		    var pos = new google.maps.LatLng(latitude, longtitude);
		    marker = new google.maps.Marker({
		        position: pos,
		        id: regNo,
		        map: map,
		        icon: image
		    });
		       var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
                '<table>'+
                '<tr><td><b>Vehicle No:</b></td><td>'+regNo+'</td></tr>'+
                '<tr><td><b>Location:</b></td><td>'+location+'</td></tr>'+
                '<tr><td><b>Date Time:</b></td><td>'+dateTime+'</td></tr>'+
                '</table>'+
                '</div>';
                infowindow = new google.maps.InfoWindow({
                content: content,
                maxWidth: 300,
                marker:marker,
                image:image,
                id:regNo
             });
		//    google.maps.event.addDomListener(content, "contextmenu", function(e) {
		//        e.preventDefault();
		//        e.stopPropogation();
		//   });
		    google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
		        return function() {
		            infowindow.setContent(content);
		            infowindow.open(map, marker);
		        };
		    })(marker, content, infowindow));
		    marker.setAnimation(google.maps.Animation.DROP);
		}
		
		var allDetailsStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MapView.do?param=getConsignmentDetailsForDashBoard',
		    id: 'allDetailsStoreId',
		    root: 'DetailsStoreRootConsignmentDashBoard',
		    autoLoad: false,
		    fields: ['dateTime', 'regNo', 'location', 'speed', 'latitude', 'longtitude', 'status']
		});
		
		var tableDataStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MapView.do?param=getConsignmentDetailsForDashBoardTable',
		    id: 'dashBoardTableId',
		    root: 'DashBoardTableRoot',
		    autoLoad: false,
		    fields: ['vehicles', 'onTime', 'delay', 'alerts', 'consignmentStatus', 'region', 'totalLoadVehicleCount', 'totalLoadOnTimeCount', 'totalLoadDelayCount', 'totalLoadAlertsCount', 'totalEmptyVehicleCount', 'totalEmptyOnTimeCount', 'totalEmptyDelayCount', 'totalEmptyAlertsCount', 'totalReturnVehicleCount', 'totalReturnOnTimeCount', 'totalReturnDelayCount', 'totalReturnAlertsCount', 'finalTotalCountForVehicles', 'finalTotalCountForOnTime', 'finalTotalCountForDelay', 'finalTotalCountForAlerts']
		});
		
		var boxesStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MapView.do?param=getCountForBoxes',
		    id: 'boxesStoreId',
		    root: 'boxesStoreRoot',
		    autoLoad: false,
		    fields: ['eastVehiclesCount', 'westVehiclesCount', 'northVehiclesCount', 'southVehiclesCount']
		});

		function returnload(cb) {
		    if (Ext.getCmp('custcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectCustomerName%>');
		        return;
		    }
		    if (Ext.getCmp('regionTypeId').getValue() == "") {
		        Ext.example.msg('<%=SelectRegion%>');
		        return;
		    }
		      if (Ext.getCmp('bookingcustcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectBookingCustomer%>');
		        return;
		    }
		    initialize();
		    document.getElementById("c1").checked = false;
		    document.getElementById("c2").checked = true;
		    document.getElementById("c3").checked = false;
		    //document.getElementById("c4").checked = false;
		    var status = "Return Load";
		    allDetailsStore.load({
		        params: {
		            status: status,
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		          //  transporter: transporter
		        },
		        callback: function() {
		            for (var i = 0; i < allDetailsStore.getCount(); i++) {
		                var rec = allDetailsStore.getAt(i);
		                  if (rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") {
		                     plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['status'], rec.data['speed'])
		                }
		            }
		        }
		    });
		}
		function load(cb) {
		    if (Ext.getCmp('custcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectCustomerName%>');
		        return;
		    }
		    if (Ext.getCmp('regionTypeId').getValue() == "") {
		        Ext.example.msg('<%=SelectRegion%>');
		        return;
		    }
		       if (Ext.getCmp('bookingcustcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectBookingCustomer%>');
		        return;
		    }
		    initialize();
		    document.getElementById("c1").checked = true;
		    document.getElementById("c2").checked = false;
		    document.getElementById("c3").checked = false;
		    //document.getElementById("c4").checked = false;
		    var status = "Load";
		    allDetailsStore.load({
		        params: {
		            status: status,
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		         //   transporter: transporter
		            
		        },
		        callback: function() {
		            for (var i = 0; i < allDetailsStore.getCount(); i++) {
		                var rec = allDetailsStore.getAt(i);
		                if (rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") {
		                    plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['status'], rec.data['speed'])
		                }
		            }
		        }
		    });
		}

		function link(type, fieldRegion, fieldCondition) {
		    if (Ext.getCmp('custcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectCustomerName%>');
		        return;
		    }
		    if (Ext.getCmp('regionTypeId').getValue() == "") {
		        Ext.example.msg('<%=SelectRegion%>');
		        return;
		    }
		       if (Ext.getCmp('bookingcustcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectBookingCustomer%>');
		        return;
		    }
		    
		     if (click == 'false') {
		        Ext.example.msg('<%=Pleaseclickonviewtogetthedata%>');
		        return;
		    }
           if(type=='Load' && fieldRegion=='East' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('eastLoad1').innerHTML == "" || document.getElementById('eastLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Load' && fieldRegion=='East' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('eastLoad2').innerHTML == "" || document.getElementById('eastLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Load' && fieldRegion=='East' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('eastLoad3').innerHTML == "" || document.getElementById('eastLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Load' && fieldRegion=='East' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('eastLoad4').innerHTML == "" || document.getElementById('eastLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 


		    if(type=='Empty' && fieldRegion=='East' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('eastEmpty1').innerHTML == "" || document.getElementById('eastEmpty1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Empty' && fieldRegion=='East' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('eastEmpty2').innerHTML == "" || document.getElementById('eastEmpty2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Empty' && fieldRegion=='East' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('eastEmpty3').innerHTML == "" || document.getElementById('eastEmpty3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Empty' && fieldRegion=='East' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('eastEmpty4').innerHTML == "" || document.getElementById('eastEmpty4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 



		    if(type=='Return Load' && fieldRegion=='East' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('eastReturnLoad1').innerHTML == "" || document.getElementById('eastReturnLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Return Load' && fieldRegion=='East' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('eastReturnLoad2').innerHTML == "" || document.getElementById('eastReturnLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Return Load' && fieldRegion=='East' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('eastReturnLoad3').innerHTML == "" || document.getElementById('eastReturnLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
         
		   if(type=='Return Load' && fieldRegion=='East' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('eastReturnLoad4').innerHTML == "" || document.getElementById('eastReturnLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 	
/****************************************************WEST***************************************************************************************/       
                     if(type=='Load' && fieldRegion=='West' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('westLoad1').innerHTML == "" || document.getElementById('westLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Load' && fieldRegion=='West' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('westLoad2').innerHTML == "" || document.getElementById('westLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Load' && fieldRegion=='West' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('westLoad3').innerHTML == "" || document.getElementById('westLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Load' && fieldRegion=='West' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('westLoad4').innerHTML == "" || document.getElementById('westLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 


		    if(type=='Empty' && fieldRegion=='West' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('westEmpty1').innerHTML == "" || document.getElementById('westEmpty1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Empty' && fieldRegion=='West' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('westEmpty2').innerHTML == "" || document.getElementById('westEmpty2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Empty' && fieldRegion=='West' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('westEmpty3').innerHTML == "" || document.getElementById('westEmpty3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Empty' && fieldRegion=='West' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('westEmpty4').innerHTML == "" || document.getElementById('westEmpty4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 



		    if(type=='Return Load' && fieldRegion=='West' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('westReturnLoad1').innerHTML == "" || document.getElementById('westReturnLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Return Load' && fieldRegion=='West' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('westReturnLoad2').innerHTML == "" || document.getElementById('westReturnLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Return Load' && fieldRegion=='West' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('westReturnLoad3').innerHTML == "" || document.getElementById('westReturnLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Return Load' && fieldRegion=='West' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('westReturnLoad4').innerHTML == "" || document.getElementById('westReturnLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
         
/**************************************************************8NORTH************************************************************************************/        
                     if(type=='Load' && fieldRegion=='North' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('northLoad1').innerHTML == "" || document.getElementById('northLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Load' && fieldRegion=='North' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('northLoad2').innerHTML == "" || document.getElementById('northLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Load' && fieldRegion=='North' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('northLoad3').innerHTML == "" || document.getElementById('northLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Load' && fieldRegion=='North' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('northLoad4').innerHTML == "" || document.getElementById('northLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 


		    if(type=='Empty' && fieldRegion=='North' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('northEmpty1').innerHTML == "" || document.getElementById('northEmpty1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Empty' && fieldRegion=='North' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('northEmpty2').innerHTML == "" || document.getElementById('northEmpty2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Empty' && fieldRegion=='North' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('northEmpty3').innerHTML == "" || document.getElementById('northEmpty3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Empty' && fieldRegion=='North' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('northEmpty4').innerHTML == "" || document.getElementById('northEmpty4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 



		    if(type=='Return Load' && fieldRegion=='North' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('northReturnLoad1').innerHTML == "" || document.getElementById('northReturnLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Return Load' && fieldRegion=='North' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('northReturnLoad2').innerHTML == "" || document.getElementById('northReturnLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Return Load' && fieldRegion=='North' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('northReturnLoad3').innerHTML == "" || document.getElementById('northReturnLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Return Load' && fieldRegion=='North' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('northReturnLoad4').innerHTML == "" || document.getElementById('northReturnLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
 /*****************************************SOUTH******************************************************************************************************************************/        
         
             if(type=='Load' && fieldRegion=='South' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('southLoad1').innerHTML == "" || document.getElementById('southLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Load' && fieldRegion=='South' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('southLoad2').innerHTML == "" || document.getElementById('southLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Load' && fieldRegion=='South' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('southLoad3').innerHTML == "" || document.getElementById('southLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Load' && fieldRegion=='South' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('southLoad4').innerHTML == "" || document.getElementById('southLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 


		    if(type=='Empty' && fieldRegion=='South' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('southEmpty1').innerHTML == "" || document.getElementById('southEmpty1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Empty' && fieldRegion=='South' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('southEmpty2').innerHTML == "" || document.getElementById('southEmpty2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Empty' && fieldRegion=='South' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('southEmpty3').innerHTML == "" || document.getElementById('southEmpty3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Empty' && fieldRegion=='South' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('southEmpty4').innerHTML == "" || document.getElementById('southEmpty4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 



		    if(type=='Return Load' && fieldRegion=='South' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('southReturnLoad1').innerHTML == "" || document.getElementById('southReturnLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }
		  
		   if(type=='Return Load' && fieldRegion=='South' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('southReturnLoad2').innerHTML == "" || document.getElementById('southReturnLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
		    if(type=='Return Load' && fieldRegion=='South' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('southReturnLoad3').innerHTML == "" || document.getElementById('southReturnLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		   if(type=='Return Load' && fieldRegion=='South' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('southReturnLoad4').innerHTML == "" || document.getElementById('southReturnLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
         	
         				if(type=='EastFieldBox' && fieldRegion=='East')
		    {
		    if (document.getElementById('onschedulecountid').innerHTML == "" || document.getElementById('onschedulecountid').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }

         }  
		 if(type=='EastFieldBox' && fieldRegion=='West')
		    {
		    if (document.getElementById('onschedulecountid1').innerHTML == "" || document.getElementById('onschedulecountid1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }

         }  
		  if(type=='EastFieldBox' && fieldRegion=='North')
		    {
		    if (document.getElementById('onschedulecountid2').innerHTML == "" || document.getElementById('onschedulecountid2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }

         }   
		   
		    if(type=='EastFieldBox' && fieldRegion=='South')
		    {
		    if (document.getElementById('onschedulecountid3').innerHTML == "" || document.getElementById('onschedulecountid3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }

         }  
  //*****************************FOr TOtal**********************************************//
  
    if(type=='Load' && fieldRegion=='Total' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('totalLoad1').innerHTML == "" || document.getElementById('totalLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }


  if(type=='Load' && fieldRegion=='Total' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('totalLoad2').innerHTML == "" || document.getElementById('totalLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
  if(type=='Load' && fieldRegion=='Total' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('totalLoad3').innerHTML == "" || document.getElementById('totalLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
  if(type=='Load' && fieldRegion=='Total' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('totalLoad4').innerHTML == "" || document.getElementById('totalLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 


		 
  if(type=='Empty' && fieldRegion=='Total' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('totalEmpty1').innerHTML == "" || document.getElementById('totalEmpty1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }


  if(type=='Empty' && fieldRegion=='Total' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('totalEmpty2').innerHTML == "" || document.getElementById('totalEmpty2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
  if(type=='Empty' && fieldRegion=='Total' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('totalEmpty3').innerHTML == "" || document.getElementById('totalEmpty3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
  if(type=='Empty' && fieldRegion=='Total' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('totalEmpty4').innerHTML == "" || document.getElementById('totalEmpty4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
		 
  if(type=='Return Load' && fieldRegion=='Total' && fieldCondition=='Vehicles')
		    {
		    if (document.getElementById('totalReturnLoad1').innerHTML == "" || document.getElementById('totalReturnLoad1').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }


  if(type=='Return Load' && fieldRegion=='Total' && fieldCondition=='OnTime')
		    {
		    if (document.getElementById('totalReturnLoad2').innerHTML == "" || document.getElementById('totalReturnLoad2').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         }  
		   
  if(type=='Return Load' && fieldRegion=='Total' && fieldCondition=='Delay')
		    {
		    if (document.getElementById('totalReturnLoad3').innerHTML == "" || document.getElementById('totalReturnLoad3').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 
  if(type=='Return Load' && fieldRegion=='Total' && fieldCondition=='Alerts')
		    {
		    if (document.getElementById('totalReturnLoad4').innerHTML == "" || document.getElementById('totalReturnLoad4').innerHTML==0) {
		        Ext.example.msg('<%=NoRecordFound%>');
		        return;
		    }
         } 	            
		   
		    var region = Ext.getCmp('regionTypeId').getValue();
		    var custName = Ext.getCmp('custcomboId').getRawValue();
		    bookingCustomerId = bookingCustomerId;
		     var bookingCustomerNameRawValue = Ext.getCmp('bookingcustcomboId').getRawValue();
		     if ( <%= dashBoardSummary %> == 1) {
		        custId = Ext.getCmp('custcomboId').getValue();
		    }
		    if (Ext.getCmp('custcomboId').getValue() == '<%=custName%>') {
		        custId = '<%=clientIdFromDetails%>';
		    }
		    window.location = "<%=request.getContextPath()%>/Jsps/Consignment/ConsignmentSummaryDetails.jsp?custId=" + custId + "&region=" + region + "&type=" + type + "&fieldRegion=" + fieldRegion + "&fieldCondition=" + fieldCondition + "&custName=" + custName + "&bookingCustomerName=" + bookingCustomerId + "&bookingCustomerNameRawValue=" +bookingCustomerNameRawValue + "&customerLogin1=" +customerLogin1 + "&TotalRegion=" +region;
		}

		function empty(cb) {
		    if (Ext.getCmp('custcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectCustomerName%>');
		        return;
		    }
		    if (Ext.getCmp('regionTypeId').getValue() == "") {
		        Ext.example.msg('<%=SelectRegion%>');
		        return;
		    }
		      if (Ext.getCmp('bookingcustcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectBookingCustomer%>');
		        return;
		    }
		    initialize();
		    document.getElementById("c1").checked = false;
		    document.getElementById("c2").checked = false;
		    document.getElementById("c3").checked = true;
		    //document.getElementById("c4").checked = false;
		    var status = "Empty";
		    allDetailsStore.load({
		        params: {
		            status: status,
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		            
		        },
		        callback: function() {
		            for (var i = 0; i < allDetailsStore.getCount(); i++) {
		                var rec = allDetailsStore.getAt(i);
		                if (rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") {
		                    plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['status'], rec.data['speed'])
		                }
		            }
		        }
		    });
		}
		function waitingForLoad(cb) {
		    if (Ext.getCmp('custcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectCustomerName%>');
		        return;
		    }
		    if (Ext.getCmp('regionTypeId').getValue() == "") {
		        Ext.example.msg('<%=SelectRegion%>');
		        return;
		    }
		     if (Ext.getCmp('bookingcustcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectBookingCustomer%>');
		        return;
		    }
		    initialize();
		    document.getElementById("c1").checked = false;
		    document.getElementById("c2").checked = false;
		    document.getElementById("c3").checked = false;
		  // document.getElementById("c4").checked = true;
		    var status = "Waiting For Load";
		    allDetailsStore.load({
		        params: {
		            status: status,
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		           // transporter: transporter
		            
		        },
		        callback: function() {
		            for (var i = 0; i < allDetailsStore.getCount(); i++) {
		                var rec = allDetailsStore.getAt(i);
		                if (rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") {
		                    plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['status'], rec.data['speed'])
		                }
		            }
		        }
		    });
		}
		
			function zeroCondition()
			{
			
			  if(document.getElementById('eastLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('eastLoad1').innerHTML="0";
			  }
			  if(document.getElementById('eastLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('eastLoad2').innerHTML="0";
			  }
			  if(document.getElementById('eastLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('eastLoad3').innerHTML="0";
			  }
			  if(document.getElementById('eastLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('eastLoad4').innerHTML="0";
			  }
			  
			  if(document.getElementById('eastEmpty1').innerHTML.trim() == "")
			  {
			   document.getElementById('eastEmpty1').innerHTML="0";
			  }
			  if(document.getElementById('eastEmpty2').innerHTML.trim() == "")
			  {
			   document.getElementById('eastEmpty2').innerHTML="0";
			  }
			  if(document.getElementById('eastEmpty3').innerHTML.trim() == "")
			  {
			   document.getElementById('eastEmpty3').innerHTML="0";
			  }
			  if(document.getElementById('eastEmpty4').innerHTML.trim() == "")
			  {
			   document.getElementById('eastEmpty4').innerHTML="0";
			  }
			  
			  if(document.getElementById('eastReturnLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('eastReturnLoad1').innerHTML="0";
			  }
			  if(document.getElementById('eastReturnLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('eastReturnLoad2').innerHTML="0";
			  }
			  if(document.getElementById('eastReturnLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('eastReturnLoad3').innerHTML="0";
			  }
			  if(document.getElementById('eastReturnLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('eastReturnLoad4').innerHTML="0";
			  }
			
			
				 if(document.getElementById('westLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('westLoad1').innerHTML="0";
			  }
			  if(document.getElementById('westLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('westLoad2').innerHTML="0";
			  }
			  if(document.getElementById('westLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('westLoad3').innerHTML="0";
			  }
			  if(document.getElementById('westLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('westLoad4').innerHTML="0";
			  }
		
				 if(document.getElementById('westEmpty1').innerHTML.trim() == "")
			  {
			   document.getElementById('westEmpty1').innerHTML="0";
			  }
			  if(document.getElementById('westEmpty2').innerHTML.trim() == "")
			  {
			   document.getElementById('westEmpty2').innerHTML="0";
			  }
			  if(document.getElementById('westEmpty3').innerHTML.trim() == "")
			  {
			   document.getElementById('westEmpty3').innerHTML="0";
			  }
			  if(document.getElementById('westEmpty4').innerHTML.trim() == "")
			  {
			   document.getElementById('westEmpty4').innerHTML="0";
			  }
	
			 if(document.getElementById('westReturnLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('westReturnLoad1').innerHTML="0";
			  }
			  if(document.getElementById('westReturnLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('westReturnLoad2').innerHTML="0";
			  }
			  if(document.getElementById('westReturnLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('westReturnLoad3').innerHTML="0";
			  }
			  if(document.getElementById('westReturnLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('westReturnLoad4').innerHTML="0";
			  }
			  
			  
			  
			  	 if(document.getElementById('northLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('northLoad1').innerHTML="0";
			  }
			  if(document.getElementById('northLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('northLoad2').innerHTML="0";
			  }
			  if(document.getElementById('northLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('northLoad3').innerHTML="0";
			  }
			  if(document.getElementById('northLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('northLoad4').innerHTML="0";
			  }
		
				 if(document.getElementById('northEmpty1').innerHTML.trim() == "")
			  {
			   document.getElementById('northEmpty1').innerHTML="0";
			  }
			  if(document.getElementById('northEmpty2').innerHTML.trim() == "")
			  {
			   document.getElementById('northEmpty2').innerHTML="0";
			  }
			  if(document.getElementById('northEmpty3').innerHTML.trim() == "")
			  {
			   document.getElementById('northEmpty3').innerHTML="0";
			  }
			  if(document.getElementById('northEmpty4').innerHTML.trim() == "")
			  {
			   document.getElementById('northEmpty4').innerHTML="0";
			  }
	
			 if(document.getElementById('northReturnLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('northReturnLoad1').innerHTML="0";
			  }
			  if(document.getElementById('northReturnLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('northReturnLoad2').innerHTML="0";
			  }
			  if(document.getElementById('northReturnLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('northReturnLoad3').innerHTML="0";
			  }
			  if(document.getElementById('northReturnLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('northReturnLoad4').innerHTML="0";
			  }
	
		
			
		 if(document.getElementById('southLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('southLoad1').innerHTML="0";
			  }
			  if(document.getElementById('southLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('southLoad2').innerHTML="0";
			  }
			  if(document.getElementById('southLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('southLoad3').innerHTML="0";
			  }
			  if(document.getElementById('southLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('southLoad4').innerHTML="0";
			  }
		
				 if(document.getElementById('southEmpty1').innerHTML.trim() == "")
			  {
			   document.getElementById('southEmpty1').innerHTML="0";
			  }
			  if(document.getElementById('southEmpty2').innerHTML.trim() == "")
			  {
			   document.getElementById('southEmpty2').innerHTML="0";
			  }
			  if(document.getElementById('southEmpty3').innerHTML.trim() == "")
			  {
			   document.getElementById('southEmpty3').innerHTML="0";
			  }
			  if(document.getElementById('southEmpty4').innerHTML.trim() == "")
			  {
			   document.getElementById('southEmpty4').innerHTML="0";
			  }
	
			 if(document.getElementById('southReturnLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('southReturnLoad1').innerHTML="0";
			  }
			  if(document.getElementById('southReturnLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('southReturnLoad2').innerHTML="0";
			  }
			  if(document.getElementById('southReturnLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('southReturnLoad3').innerHTML="0";
			  }
			  if(document.getElementById('southReturnLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('southReturnLoad4').innerHTML="0";
			  }
	
				 if(document.getElementById('totalLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('totalLoad1').innerHTML="0";
			  }
			  if(document.getElementById('totalLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('totalLoad2').innerHTML="0";
			  }
			  if(document.getElementById('totalLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('totalLoad3').innerHTML="0";
			  }
			  if(document.getElementById('totalLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('totalLoad4').innerHTML="0";
			  }
		
				 if(document.getElementById('totalEmpty1').innerHTML.trim() == "")
			  {
			   document.getElementById('totalEmpty1').innerHTML="0";
			  }
			  if(document.getElementById('totalEmpty2').innerHTML.trim() == "")
			  {
			   document.getElementById('totalEmpty2').innerHTML="0";
			  }
			  if(document.getElementById('totalEmpty3').innerHTML.trim() == "")
			  {
			   document.getElementById('totalEmpty3').innerHTML="0";
			  }
			  if(document.getElementById('totalEmpty4').innerHTML.trim() == "")
			  {
			   document.getElementById('totalEmpty4').innerHTML="0";
			  }
	
			 if(document.getElementById('totalReturnLoad1').innerHTML.trim() == "")
			  {
			   document.getElementById('totalReturnLoad1').innerHTML="0";
			  }
			  if(document.getElementById('totalReturnLoad2').innerHTML.trim() == "")
			  {
			   document.getElementById('totalReturnLoad2').innerHTML="0";
			  }
			  if(document.getElementById('totalReturnLoad3').innerHTML.trim() == "")
			  {
			   document.getElementById('totalReturnLoad3').innerHTML="0";
			  }
			  if(document.getElementById('totalReturnLoad4').innerHTML.trim() == "")
			  {
			   document.getElementById('totalReturnLoad4').innerHTML="0";
			  }
	
	      if(document.getElementById('totalId1').innerHTML.trim() == "")
			  {
			   document.getElementById('totalId1').innerHTML="0";
			  }
			  if(document.getElementById('totalId2').innerHTML.trim() == "")
			  {
			   document.getElementById('totalId2').innerHTML="0";
			  }
			  if(document.getElementById('totalId3').innerHTML.trim() == "")
			  {
			   document.getElementById('totalId3').innerHTML="0";
			  }
			  if(document.getElementById('totalId4').innerHTML.trim() == "")
			  {
			   document.getElementById('totalId4').innerHTML="0";
			  }
			}	
	   			
		var editInfo1 = new Ext.Button({
		    text: '<%=View%>',
		    id: 'submitId',
		    cls: 'buttonstyleforConsignmentDashboard',
		    width: 70,
		    handler: function() {
		        initialize();
		        click = 'true';
		        customerLogin="";
		        if (Ext.getCmp('custcomboId').getValue() == "") {
		            Ext.example.msg('<%=SelectCustomerName%>');
		            return;
		        }
		        if (Ext.getCmp('regionTypeId').getValue() == "") {
		            Ext.example.msg('<%=SelectRegion%>');
		            return;
		        }
		          if (Ext.getCmp('bookingcustcomboId').getValue() == "") {
		        Ext.example.msg('<%=SelectBookingCustomer%>');
		        return;
		    }
		        
		        loadAllStores();
		       
		        
		    }
		});

		function loadAllStores() {
    initialize();
    if(customerLogin == 'customerLogin')
    {
    loadDataForCustomerLogin();
    customerLogin1='1';
    }
		    if (dashBoard == '1') {
		    if(customerLogin1=='1')
		    {
		    	Ext.getCmp('custcomboId').disable();
				Ext.getCmp('bookingcustcomboId').disable();
				Ext.getCmp('regionTypeId').disable();
		    
		    }
		        Ext.getCmp('custcomboId').setValue('<%=clientIdFromDetails%>');
		        Ext.getCmp('regionTypeId').setValue('<%=regionFromDetails%>');
		        Ext.getCmp('custcomboId').setValue('<%=custName%>');
		        custId = '<%=clientIdFromDetails%>';
		        Ext.getCmp('bookingcustcomboId').setValue('<%=bookingCustomerNameRawValueFromDetails%>');
		        bookingCustomerId = '<%=bookingCustomerNameFromDetails%>';
		        click = 'true';
		       
			    }
		    dashBoard = '0';
		    document.getElementById("c1").checked = false;
		    document.getElementById("c2").checked = false;
		    document.getElementById("c3").checked = false;
		    var All = "All";
		  //  alert(bookingCustomerId);
		    allDetailsStore.load({
		        params: {
		            status: All,
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		            
		        },
		        
		        callback: function() {
		            for (var i = 0; i < allDetailsStore.getCount(); i++) {
		                var rec = allDetailsStore.getAt(i);
		                if (rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") {
		                    plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['status'], rec.data['speed'])
		                }
		            }
		        }
		    });
		       
                            bookingCustomertore.load({
                                params: {
                                      CustId:custId,
                                      region: Ext.getCmp('regionTypeId').getValue()
                                    }
                            });
		    
		    tableDataStore.load({
		        params: {
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		             bookingCustomerId: bookingCustomerId
		        },
		        callback: function() {
		            for (var i = 0; i < tableDataStore.getCount(); i++) {
		                var rec = tableDataStore.getAt(i);
		                if (rec.data['consignmentStatus'] == "Load") {
		                    if (rec.data['region'] == "East") {
		                        document.getElementById('eastLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('eastLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('eastLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('eastLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                    if (rec.data['region'] == "West") {
		                        document.getElementById('westLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('westLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('westLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('westLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                    if (rec.data['region'] == "North") {
		                        document.getElementById('northLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('northLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('northLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('northLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                    if (rec.data['region'] == "South") {
		                        document.getElementById('southLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('southLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('southLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('southLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                }
		                if (rec.data['consignmentStatus'] == "Empty") {
		                    if (rec.data['region'] == "East") {
		                        document.getElementById('eastEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('eastEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('eastEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('eastEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                    if (rec.data['region'] == "West") {
		                        document.getElementById('westEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('westEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('westEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('westEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                    if (rec.data['region'] == "North") {
		                        document.getElementById('northEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('northEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('northEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('northEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                    if (rec.data['region'] == "South") {
		                        document.getElementById('southEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('southEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('southEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('southEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                }
		                if (rec.data['consignmentStatus'] == "Return Load") {
		                    if (rec.data['region'] == "East") {
		                        document.getElementById('eastReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('eastReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('eastReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('eastReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                    if (rec.data['region'] == "West") {
		                        document.getElementById('westReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('westReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('westReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('westReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                    if (rec.data['region'] == "North") {
		                        document.getElementById('northReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('northReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('northReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('northReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                    if (rec.data['region'] == "South") {
		                        document.getElementById('southReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('southReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('southReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('southReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                }
		                document.getElementById('totalId1').innerHTML = rec.data['finalTotalCountForVehicles'];
		                document.getElementById('totalId2').innerHTML = rec.data['finalTotalCountForOnTime'];
		                document.getElementById('totalId3').innerHTML = rec.data['finalTotalCountForDelay'];
		                document.getElementById('totalId4').innerHTML = rec.data['finalTotalCountForAlerts'];
		            }
		          
		          zeroCondition();
		      
		        }
		    });
		    boxesStore.load({
		        params: {
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		            
		        },
		        callback: function() {
		            if (Ext.getCmp('regionTypeId').getValue() == 'ALL') {
		                for (var i = 0; i < boxesStore.getCount(); i++) {
		                    var rec = boxesStore.getAt(i);
		                    if (i == 0) {
		                        document.getElementById('onschedulecountid').innerHTML = rec.data['eastVehiclesCount'];
		                    }
		                    if (i == 1) {
		                        document.getElementById('onschedulecountid1').innerHTML = rec.data['westVehiclesCount'];
		                    }
		                    if (i == 2) {
		                        document.getElementById('onschedulecountid2').innerHTML = rec.data['northVehiclesCount'];
		                    }
		                    if (i == 3) {
		                        document.getElementById('onschedulecountid3').innerHTML = rec.data['southVehiclesCount'];
		                    }
		                }
		            } else {
		                var rec = boxesStore.getAt(0);
		                document.getElementById('onschedulecountid').innerHTML = rec.data['eastVehiclesCount'];
		                document.getElementById('onschedulecountid1').innerHTML = rec.data['westVehiclesCount'];
		                document.getElementById('onschedulecountid2').innerHTML = rec.data['northVehiclesCount'];
		                document.getElementById('onschedulecountid3').innerHTML = rec.data['southVehiclesCount'];
		            }
		        }
		    });
		    
		        
		}
		
		
		function loadDataForCustomerLogin()
	{
	 Ext.getCmp('custcomboId').disable();
	  Ext.getCmp('bookingcustcomboId').disable();
	   Ext.getCmp('regionTypeId').disable();
	  Ext.getCmp('custcomboId').setValue('<%=nameFromLoginCustomer%>');
	  Ext.getCmp('bookingcustcomboId').setValue('<%=bookingCustnameFromLoginCustomer%>');
	  Ext.getCmp('regionTypeId').setValue('<%=regionFromCustomerLogin%>');
	  click = 'true';
	  custId='<%=custIdFromLoginCustomer%>';
      bookingCustomerId='<%=bookingCustIdFromLoginCustomer%>';
	  		    var All = "All";
		    allDetailsStore.load({
		        params: {
		            status: All,
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		            
		        },
		        
		        callback: function() {
		            for (var i = 0; i < allDetailsStore.getCount(); i++) {
		                var rec = allDetailsStore.getAt(i);
		                if (rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") {
		                    plotSingleVehicle(rec.data['regNo'], rec.data['latitude'], rec.data['longtitude'], rec.data['location'], rec.data['dateTime'], rec.data['status'], rec.data['speed'])
		                }
		            }
		        }
		    });
		    
		    tableDataStore.load({
		        params: {
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		             bookingCustomerId: bookingCustomerId
		        },
		        callback: function() {
		            for (var i = 0; i < tableDataStore.getCount(); i++) {
		                var rec = tableDataStore.getAt(i);
		                if (rec.data['consignmentStatus'] == "Load") {
		                    if (rec.data['region'] == "East") {
		                        document.getElementById('eastLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('eastLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('eastLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('eastLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                    if (rec.data['region'] == "West") {
		                        document.getElementById('westLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('westLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('westLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('westLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                    if (rec.data['region'] == "North") {
		                        document.getElementById('northLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('northLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('northLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('northLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                    if (rec.data['region'] == "South") {
		                        document.getElementById('southLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('southLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('southLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('southLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalLoad1').innerHTML = rec.data['totalLoadVehicleCount'];
		                        document.getElementById('totalLoad2').innerHTML = rec.data['totalLoadOnTimeCount'];
		                        document.getElementById('totalLoad3').innerHTML = rec.data['totalLoadDelayCount'];
		                        document.getElementById('totalLoad4').innerHTML = rec.data['totalLoadAlertsCount'];
		                    }
		                }
		                if (rec.data['consignmentStatus'] == "Empty") {
		                    if (rec.data['region'] == "East") {
		                        document.getElementById('eastEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('eastEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('eastEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('eastEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                    if (rec.data['region'] == "West") {
		                        document.getElementById('westEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('westEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('westEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('westEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                    if (rec.data['region'] == "North") {
		                        document.getElementById('northEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('northEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('northEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('northEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                    if (rec.data['region'] == "South") {
		                        document.getElementById('southEmpty1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('southEmpty2').innerHTML = rec.data['onTime'];
		                        document.getElementById('southEmpty3').innerHTML = rec.data['delay'];
		                        document.getElementById('southEmpty4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalEmpty1').innerHTML = rec.data['totalEmptyVehicleCount'];
		                        document.getElementById('totalEmpty2').innerHTML = rec.data['totalEmptyOnTimeCount'];
		                        document.getElementById('totalEmpty3').innerHTML = rec.data['totalEmptyDelayCount'];
		                        document.getElementById('totalEmpty4').innerHTML = rec.data['totalEmptyAlertsCount'];
		                    }
		                }
		                if (rec.data['consignmentStatus'] == "Return Load") {
		                    if (rec.data['region'] == "East") {
		                        document.getElementById('eastReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('eastReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('eastReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('eastReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                    if (rec.data['region'] == "West") {
		                        document.getElementById('westReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('westReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('westReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('westReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                    if (rec.data['region'] == "North") {
		                        document.getElementById('northReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('northReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('northReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('northReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                    if (rec.data['region'] == "South") {
		                        document.getElementById('southReturnLoad1').innerHTML = rec.data['vehicles'];
		                        document.getElementById('southReturnLoad2').innerHTML = rec.data['onTime'];
		                        document.getElementById('southReturnLoad3').innerHTML = rec.data['delay'];
		                        document.getElementById('southReturnLoad4').innerHTML = rec.data['alerts'];
		                        document.getElementById('totalReturnLoad1').innerHTML = rec.data['totalReturnVehicleCount'];
		                        document.getElementById('totalReturnLoad2').innerHTML = rec.data['totalReturnOnTimeCount'];
		                        document.getElementById('totalReturnLoad3').innerHTML = rec.data['totalReturnDelayCount'];
		                        document.getElementById('totalReturnLoad4').innerHTML = rec.data['totalReturnAlertsCount'];
		                    }
		                }
		                document.getElementById('totalId1').innerHTML = rec.data['finalTotalCountForVehicles'];
		                document.getElementById('totalId2').innerHTML = rec.data['finalTotalCountForOnTime'];
		                document.getElementById('totalId3').innerHTML = rec.data['finalTotalCountForDelay'];
		                document.getElementById('totalId4').innerHTML = rec.data['finalTotalCountForAlerts'];
		            }
		          
		          zeroCondition();
		      
		        }
		    });
		    
		    boxesStore.load({
		        params: {
		            custId: custId,
		            region: Ext.getCmp('regionTypeId').getValue(),
		            bookingCustomerId: bookingCustomerId
		            
		        },
		        callback: function() {
		            if (Ext.getCmp('regionTypeId').getValue() == 'ALL') {
		                for (var i = 0; i < boxesStore.getCount(); i++) {
		                    var rec = boxesStore.getAt(i);
		                    if (i == 0) {
		                        document.getElementById('onschedulecountid').innerHTML = rec.data['eastVehiclesCount'];
		                    }
		                    if (i == 1) {
		                        document.getElementById('onschedulecountid1').innerHTML = rec.data['westVehiclesCount'];
		                    }
		                    if (i == 2) {
		                        document.getElementById('onschedulecountid2').innerHTML = rec.data['northVehiclesCount'];
		                    }
		                    if (i == 3) {
		                        document.getElementById('onschedulecountid3').innerHTML = rec.data['southVehiclesCount'];
		                    }
		                }
		            } else {
		                var rec = boxesStore.getAt(0);
		                document.getElementById('onschedulecountid').innerHTML = rec.data['eastVehiclesCount'];
		                document.getElementById('onschedulecountid1').innerHTML = rec.data['westVehiclesCount'];
		                document.getElementById('onschedulecountid2').innerHTML = rec.data['northVehiclesCount'];
		                document.getElementById('onschedulecountid3').innerHTML = rec.data['southVehiclesCount'];
		            }
		        }
		    });
	  
	}
		
		
		
		
		
			var transpoterstore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MapView.do?param=getGroups',
		    id: 'transporterStoreId',
		    root: 'groupNameList',
		    autoLoad: true,
		    remoteSort: true,
		    fields: ['groupId', 'groupName']
		    
		});
		
		var transportercombo = new Ext.form.ComboBox({
		    store: transpoterstore,
		    id: 'transportercomboId',
		    mode: 'local',
		    forceSelection: true,
		    emptyText: 'Select Transporter',
		    selectOnFocus: true,
		    allowBlank: false,
		    anyMatch: true,
		    typeAhead: false,
		    triggerAction: 'all',
		    lazyRender: true,
		    value: 'ALL',
		    valueField: 'groupId',
		    displayField: 'groupName',
		    cls: 'selectstylePerfect',
		    listeners: {
		        select: {
		            fn: function() {
		            initialize();
		            transporter = Ext.getCmp('transportercomboId').getValue();
		                document.getElementById("c1").checked = false;
		                document.getElementById("c2").checked = false;
		                document.getElementById("c3").checked = false;
		                document.getElementById('eastLoad1').innerHTML = "0";
		                document.getElementById('eastLoad2').innerHTML = "0";
		                document.getElementById('eastLoad3').innerHTML = "0";
		                document.getElementById('eastLoad4').innerHTML = "0";
		                document.getElementById('eastEmpty1').innerHTML = "0";
		                document.getElementById('eastEmpty2').innerHTML = "0";
		                document.getElementById('eastEmpty3').innerHTML = "0";
		                document.getElementById('eastEmpty4').innerHTML = "0";
		                document.getElementById('eastReturnLoad1').innerHTML = "0";
		                document.getElementById('eastReturnLoad2').innerHTML = "0";
		                document.getElementById('eastReturnLoad3').innerHTML = "0";
		                document.getElementById('eastReturnLoad4').innerHTML = "0";
		                document.getElementById('westLoad1').innerHTML = "0";
		                document.getElementById('westLoad2').innerHTML = "0";
		                document.getElementById('westLoad3').innerHTML = "0";
		                document.getElementById('westLoad4').innerHTML = "0";
		                document.getElementById('westEmpty1').innerHTML = "0";
		                document.getElementById('westEmpty2').innerHTML = "0";
		                document.getElementById('westEmpty3').innerHTML = "0";
		                document.getElementById('westEmpty4').innerHTML = "0";
		                document.getElementById('westReturnLoad1').innerHTML = "0";
		                document.getElementById('westReturnLoad2').innerHTML = "0";
		                document.getElementById('westReturnLoad3').innerHTML = "0";
		                document.getElementById('westReturnLoad4').innerHTML = "0";
		                document.getElementById('northLoad1').innerHTML = "0";
		                document.getElementById('northLoad2').innerHTML = "0";
		                document.getElementById('northLoad3').innerHTML = "0";
		                document.getElementById('northLoad4').innerHTML = "0";
		                document.getElementById('northEmpty1').innerHTML = "0";
		                document.getElementById('northEmpty2').innerHTML = "0";
		                document.getElementById('northEmpty3').innerHTML = "0";
		                document.getElementById('northEmpty4').innerHTML = "0";
		                document.getElementById('northReturnLoad1').innerHTML = "0";
		                document.getElementById('northReturnLoad2').innerHTML = "0";
		                document.getElementById('northReturnLoad3').innerHTML = "0";
		                document.getElementById('northReturnLoad4').innerHTML = "0";
		                document.getElementById('southLoad1').innerHTML = "0";
		                document.getElementById('southLoad2').innerHTML = "0";
		                document.getElementById('southLoad3').innerHTML = "0";
		                document.getElementById('southLoad4').innerHTML = "0";
		                document.getElementById('southEmpty1').innerHTML = "0";
		                document.getElementById('southEmpty2').innerHTML = "0";
		                document.getElementById('southEmpty3').innerHTML = "0";
		                document.getElementById('southEmpty4').innerHTML = "0";
		                document.getElementById('southReturnLoad1').innerHTML = "0";
		                document.getElementById('southReturnLoad2').innerHTML = "0";
		                document.getElementById('southReturnLoad3').innerHTML = "0";
		                document.getElementById('southReturnLoad4').innerHTML = "0";
		                document.getElementById('totalId1').innerHTML = "0";
		                document.getElementById('totalId2').innerHTML = "0";
		                document.getElementById('totalId3').innerHTML = "0";
		                document.getElementById('totalId4').innerHTML = "0";
		                document.getElementById('totalLoad1').innerHTML = "0";
		                document.getElementById('totalLoad2').innerHTML = "0";
		                document.getElementById('totalLoad3').innerHTML = "0";
		                document.getElementById('totalLoad4').innerHTML = "0";
		                document.getElementById('totalEmpty1').innerHTML = "0";
		                document.getElementById('totalEmpty2').innerHTML = "0";
		                document.getElementById('totalEmpty3').innerHTML = "0";
		                document.getElementById('totalEmpty4').innerHTML = "0";
		                document.getElementById('totalReturnLoad1').innerHTML = "0";
		                document.getElementById('totalReturnLoad2').innerHTML = "0";
		                document.getElementById('totalReturnLoad3').innerHTML = "0";
		                document.getElementById('totalReturnLoad4').innerHTML = "0";
		                document.getElementById('onschedulecountid').innerHTML = "0";
		                document.getElementById('onschedulecountid1').innerHTML = "0";
		                document.getElementById('onschedulecountid2').innerHTML = "0";
		                document.getElementById('onschedulecountid3').innerHTML = "0";

		            }
		        }
		    }
		});
		
			var bookingCustomertore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MapView.do?param=getBookingCustomer',
		    id: 'bookingCustomerStoreId',
		    root: 'bookingCustomerRoot',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['bookingCustId', 'bookingCustName']
		    
		});
		
		var bookingcustnamecombo = new Ext.form.ComboBox({
		    store: bookingCustomertore,
		    id: 'bookingcustcomboId',
		    mode: 'local',
		    forceSelection: true,
		    emptyText: 'Select Booking Customer',
		    selectOnFocus: true,
		    allowBlank: false,
		    anyMatch: true,
		    typeAhead: false,
		    triggerAction: 'all',
		    lazyRender: true,
		    value: 'ALL',
		    valueField: 'bookingCustId',
		    displayField: 'bookingCustName',
		    cls: 'selectstylePerfect',
		    listeners: {
		        select: {
		            fn: function() {
		                 initialize();
		                 bookingCustomerId = Ext.getCmp('bookingcustcomboId').getValue();
		              //   alert(Ext.getCmp('bookingcustcomboId').getValue());
		                document.getElementById("c1").checked = false;
		                document.getElementById("c2").checked = false;
		                document.getElementById("c3").checked = false;
		               // document.getElementById("c4").checked = false;
		                document.getElementById('eastLoad1').innerHTML = "0";
		                document.getElementById('eastLoad2').innerHTML = "0";
		                document.getElementById('eastLoad3').innerHTML = "0";
		                document.getElementById('eastLoad4').innerHTML = "0";
		                document.getElementById('eastEmpty1').innerHTML = "0";
		                document.getElementById('eastEmpty2').innerHTML = "0";
		                document.getElementById('eastEmpty3').innerHTML = "0";
		                document.getElementById('eastEmpty4').innerHTML = "0";
		                document.getElementById('eastReturnLoad1').innerHTML = "0";
		                document.getElementById('eastReturnLoad2').innerHTML = "0";
		                document.getElementById('eastReturnLoad3').innerHTML = "0";
		                document.getElementById('eastReturnLoad4').innerHTML = "0";
		                document.getElementById('westLoad1').innerHTML = "0";
		                document.getElementById('westLoad2').innerHTML = "0";
		                document.getElementById('westLoad3').innerHTML = "0";
		                document.getElementById('westLoad4').innerHTML = "0";
		                document.getElementById('westEmpty1').innerHTML = "0";
		                document.getElementById('westEmpty2').innerHTML = "0";
		                document.getElementById('westEmpty3').innerHTML = "0";
		                document.getElementById('westEmpty4').innerHTML = "0";
		                document.getElementById('westReturnLoad1').innerHTML = "0";
		                document.getElementById('westReturnLoad2').innerHTML = "0";
		                document.getElementById('westReturnLoad3').innerHTML = "0";
		                document.getElementById('westReturnLoad4').innerHTML = "0";
		                document.getElementById('northLoad1').innerHTML = "0";
		                document.getElementById('northLoad2').innerHTML = "0";
		                document.getElementById('northLoad3').innerHTML = "0";
		                document.getElementById('northLoad4').innerHTML = "0";
		                document.getElementById('northEmpty1').innerHTML = "0";
		                document.getElementById('northEmpty2').innerHTML = "0";
		                document.getElementById('northEmpty3').innerHTML = "0";
		                document.getElementById('northEmpty4').innerHTML = "0";
		                document.getElementById('northReturnLoad1').innerHTML = "0";
		                document.getElementById('northReturnLoad2').innerHTML = "0";
		                document.getElementById('northReturnLoad3').innerHTML = "0";
		                document.getElementById('northReturnLoad4').innerHTML = "0";
		                document.getElementById('southLoad1').innerHTML = "0";
		                document.getElementById('southLoad2').innerHTML = "0";
		                document.getElementById('southLoad3').innerHTML = "0";
		                document.getElementById('southLoad4').innerHTML = "0";
		                document.getElementById('southEmpty1').innerHTML = "0";
		                document.getElementById('southEmpty2').innerHTML = "0";
		                document.getElementById('southEmpty3').innerHTML = "0";
		                document.getElementById('southEmpty4').innerHTML = "0";
		                document.getElementById('southReturnLoad1').innerHTML = "0";
		                document.getElementById('southReturnLoad2').innerHTML = "0";
		                document.getElementById('southReturnLoad3').innerHTML = "0";
		                document.getElementById('southReturnLoad4').innerHTML = "0";
		                document.getElementById('totalId1').innerHTML = "0";
		                document.getElementById('totalId2').innerHTML = "0";
		                document.getElementById('totalId3').innerHTML = "0";
		                document.getElementById('totalId4').innerHTML = "0";
		                document.getElementById('totalLoad1').innerHTML = "0";
		                document.getElementById('totalLoad2').innerHTML = "0";
		                document.getElementById('totalLoad3').innerHTML = "0";
		                document.getElementById('totalLoad4').innerHTML = "0";
		                document.getElementById('totalEmpty1').innerHTML = "0";
		                document.getElementById('totalEmpty2').innerHTML = "0";
		                document.getElementById('totalEmpty3').innerHTML = "0";
		                document.getElementById('totalEmpty4').innerHTML = "0";
		                document.getElementById('totalReturnLoad1').innerHTML = "0";
		                document.getElementById('totalReturnLoad2').innerHTML = "0";
		                document.getElementById('totalReturnLoad3').innerHTML = "0";
		                document.getElementById('totalReturnLoad4').innerHTML = "0";
		                document.getElementById('onschedulecountid').innerHTML = "0";
		                document.getElementById('onschedulecountid1').innerHTML = "0";
		                document.getElementById('onschedulecountid2').innerHTML = "0";
		                document.getElementById('onschedulecountid3').innerHTML = "0";

		            }
		        }
		    }
		});			
		
		var customercombostore = new Ext.data.JsonStore({
		   url: '<%=request.getContextPath()%>/MapView.do?param=getCustomersForDashBoard',
		    id: 'CustomerStoreId',
		    root: 'CustomerRoot',
		    autoLoad: true,
		    remoteSort: true,
		    fields: ['CustId', 'CustName'],
		    listeners: {
		        load: function(custstore, records, success, options) {
		          if ( <%= dashBoardSummary %> != 1) {
		            if ( <%= customerId %> > 0) {
		                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
		                custId = Ext.getCmp('custcomboId').getValue();
		              if ( <%= dashBoardSummary %> != 1) {  
		             loadAllStores();
		              click = 'true';
		               }
		                     
                            bookingCustomertore.load({
                                params: {
                                      CustId:custId,
                                      region: Ext.getCmp('regionTypeId').getValue()
                                    }
                            });
		            }
		            
		        }
		     }   
		    }
		});
		
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
		    displayField: 'CustName',
		    cls: 'selectstylePerfect',
		    listeners: {
		        select: {
		            fn: function() {
		                initialize();
		                zeroCheck=true;
		                custId = Ext.getCmp('custcomboId').getValue();
                            bookingCustomertore.load({
                                params: {
                                      CustId: custId
                                    }
                            });
                            Ext.getCmp('bookingcustcomboId').reset();
                            Ext.getCmp('regionTypeId').reset();
		                
		                document.getElementById("c1").checked = false;
		                document.getElementById("c2").checked = false;
		                document.getElementById("c3").checked = false;
		               //document.getElementById("c4").checked = false;
		                document.getElementById('eastLoad1').innerHTML = "0";
		                document.getElementById('eastLoad2').innerHTML = "0";
		                document.getElementById('eastLoad3').innerHTML = "0";
		                document.getElementById('eastLoad4').innerHTML = "0";
		                document.getElementById('eastEmpty1').innerHTML = "0";
		                document.getElementById('eastEmpty2').innerHTML = "0";
		                document.getElementById('eastEmpty3').innerHTML = "0";
		                document.getElementById('eastEmpty4').innerHTML = "0";
		                document.getElementById('eastReturnLoad1').innerHTML = "0";
		                document.getElementById('eastReturnLoad2').innerHTML = "0";
		                document.getElementById('eastReturnLoad3').innerHTML = "0";
		                document.getElementById('eastReturnLoad4').innerHTML = "0";
		                document.getElementById('westLoad1').innerHTML = "0";
		                document.getElementById('westLoad2').innerHTML = "0";
		                document.getElementById('westLoad3').innerHTML = "0";
		                document.getElementById('westLoad4').innerHTML = "0";
		                document.getElementById('westEmpty1').innerHTML = "0";
		                document.getElementById('westEmpty2').innerHTML = "0";
		                document.getElementById('westEmpty3').innerHTML = "0";
		                document.getElementById('westEmpty4').innerHTML = "0";
		                document.getElementById('westReturnLoad1').innerHTML = "0";
		                document.getElementById('westReturnLoad2').innerHTML = "0";
		                document.getElementById('westReturnLoad3').innerHTML = "0";
		                document.getElementById('westReturnLoad4').innerHTML = "0";
		                document.getElementById('northLoad1').innerHTML = "0";
		                document.getElementById('northLoad2').innerHTML = "0";
		                document.getElementById('northLoad3').innerHTML = "0";
		                document.getElementById('northLoad4').innerHTML = "0";
		                document.getElementById('northEmpty1').innerHTML = "0";
		                document.getElementById('northEmpty2').innerHTML = "0";
		                document.getElementById('northEmpty3').innerHTML = "0";
		                document.getElementById('northEmpty4').innerHTML = "0";
		                document.getElementById('northReturnLoad1').innerHTML = "0";
		                document.getElementById('northReturnLoad2').innerHTML = "0";
		                document.getElementById('northReturnLoad3').innerHTML = "0";
		                document.getElementById('northReturnLoad4').innerHTML = "0";
		                document.getElementById('southLoad1').innerHTML = "0";
		                document.getElementById('southLoad2').innerHTML = "0";
		                document.getElementById('southLoad3').innerHTML = "0";
		                document.getElementById('southLoad4').innerHTML = "0";
		                document.getElementById('southEmpty1').innerHTML = "0";
		                document.getElementById('southEmpty2').innerHTML = "0";
		                document.getElementById('southEmpty3').innerHTML = "0";
		                document.getElementById('southEmpty4').innerHTML = "0";
		                document.getElementById('southReturnLoad1').innerHTML = "0";
		                document.getElementById('southReturnLoad2').innerHTML = "0";
		                document.getElementById('southReturnLoad3').innerHTML = "0";
		                document.getElementById('southReturnLoad4').innerHTML = "0";
		                document.getElementById('totalId1').innerHTML = "0";
		                document.getElementById('totalId2').innerHTML = "0";
		                document.getElementById('totalId3').innerHTML = "0";
		                document.getElementById('totalId4').innerHTML = "0";
		                document.getElementById('totalLoad1').innerHTML = "0";
		                document.getElementById('totalLoad2').innerHTML = "0";
		                document.getElementById('totalLoad3').innerHTML = "0";
		                document.getElementById('totalLoad4').innerHTML = "0";
		                document.getElementById('totalEmpty1').innerHTML = "0";
		                document.getElementById('totalEmpty2').innerHTML = "0";
		                document.getElementById('totalEmpty3').innerHTML = "0";
		                document.getElementById('totalEmpty4').innerHTML = "0";
		                document.getElementById('totalReturnLoad1').innerHTML = "0";
		                document.getElementById('totalReturnLoad2').innerHTML = "0";
		                document.getElementById('totalReturnLoad3').innerHTML = "0";
		                document.getElementById('totalReturnLoad4').innerHTML = "0";
		                document.getElementById('onschedulecountid').innerHTML = "0";
		                document.getElementById('onschedulecountid1').innerHTML = "0";
		                document.getElementById('onschedulecountid2').innerHTML = "0";
		                document.getElementById('onschedulecountid3').innerHTML = "0";
		                
		                 
		            }
		        }
		    }
		});
		
		var regionStore = new Ext.data.SimpleStore({
		    id: 'regionStoreId',
		    autoLoad: true,
		    fields: ['Name', 'Value'],
		    data: [
		        ['ALL', 'ALL'],
		        ['East', 'East'],
		        ['West', 'West'],
		        ['North', 'North'],
		        ['South', 'South']
		    ]
		});
		
		var regionTypeCombo = new Ext.form.ComboBox({
		    store: regionStore,
		    id: 'regionTypeId',
		    mode: 'local',
		    forceSelection: true,
		    allowBlanks: false,
		    value: 'ALL',
		    selectOnFocus: true,
		    anyMatch: true,
		    typeAhead: false,
		    triggerAction: 'all',
		    lazyRender: true,
		    valueField: 'Name',
		    displayField: 'Value',
		    cls: 'selectstylePerfect',
		    listeners: {
		        select: {
		            fn: function() {
		                initialize();
		                 region = Ext.getCmp('regionTypeId').getValue();
		                document.getElementById("c1").checked = false;
		                document.getElementById("c2").checked = false;
		                document.getElementById("c3").checked = false;
		               // document.getElementById("c4").checked = false;
		                document.getElementById('eastLoad1').innerHTML = "0";
		                document.getElementById('eastLoad2').innerHTML = "0";
		                document.getElementById('eastLoad3').innerHTML = "0";
		                document.getElementById('eastLoad4').innerHTML = "0";
		                document.getElementById('eastEmpty1').innerHTML = "0";
		                document.getElementById('eastEmpty2').innerHTML = "0";
		                document.getElementById('eastEmpty3').innerHTML = "0";
		                document.getElementById('eastEmpty4').innerHTML = "0";
		                document.getElementById('eastReturnLoad1').innerHTML = "0";
		                document.getElementById('eastReturnLoad2').innerHTML = "0";
		                document.getElementById('eastReturnLoad3').innerHTML = "0";
		                document.getElementById('eastReturnLoad4').innerHTML = "0";
		                document.getElementById('westLoad1').innerHTML = "0";
		                document.getElementById('westLoad2').innerHTML = "0";
		                document.getElementById('westLoad3').innerHTML = "0";
		                document.getElementById('westLoad4').innerHTML = "0";
		                document.getElementById('westEmpty1').innerHTML = "0";
		                document.getElementById('westEmpty2').innerHTML = "0";
		                document.getElementById('westEmpty3').innerHTML = "0";
		                document.getElementById('westEmpty4').innerHTML = "0";
		                document.getElementById('westReturnLoad1').innerHTML = "0";
		                document.getElementById('westReturnLoad2').innerHTML = "0";
		                document.getElementById('westReturnLoad3').innerHTML = "0";
		                document.getElementById('westReturnLoad4').innerHTML = "0";
		                document.getElementById('northLoad1').innerHTML = "0";
		                document.getElementById('northLoad2').innerHTML = "0";
		                document.getElementById('northLoad3').innerHTML = "0";
		                document.getElementById('northLoad4').innerHTML = "0";
		                document.getElementById('northEmpty1').innerHTML = "0";
		                document.getElementById('northEmpty2').innerHTML = "0";
		                document.getElementById('northEmpty3').innerHTML = "0";
		                document.getElementById('northEmpty4').innerHTML = "0";
		                document.getElementById('northReturnLoad1').innerHTML = "0";
		                document.getElementById('northReturnLoad2').innerHTML = "0";
		                document.getElementById('northReturnLoad3').innerHTML = "0";
		                document.getElementById('northReturnLoad4').innerHTML = "0";
		                document.getElementById('southLoad1').innerHTML = "0";
		                document.getElementById('southLoad2').innerHTML = "0";
		                document.getElementById('southLoad3').innerHTML = "0";
		                document.getElementById('southLoad4').innerHTML = "0";
		                document.getElementById('southEmpty1').innerHTML = "0";
		                document.getElementById('southEmpty2').innerHTML = "0";
		                document.getElementById('southEmpty3').innerHTML = "0";
		                document.getElementById('southEmpty4').innerHTML = "0";
		                document.getElementById('southReturnLoad1').innerHTML = "0";
		                document.getElementById('southReturnLoad2').innerHTML = "0";
		                document.getElementById('southReturnLoad3').innerHTML = "0";
		                document.getElementById('southReturnLoad4').innerHTML = "0";
		                document.getElementById('totalId1').innerHTML = "0";
		                document.getElementById('totalId2').innerHTML = "0";
		                document.getElementById('totalId3').innerHTML = "0";
		                document.getElementById('totalId4').innerHTML = "0";
		                document.getElementById('totalLoad1').innerHTML = "0";
		                document.getElementById('totalLoad2').innerHTML = "0";
		                document.getElementById('totalLoad3').innerHTML = "0";
		                document.getElementById('totalLoad4').innerHTML = "0";
		                document.getElementById('totalEmpty1').innerHTML = "0";
		                document.getElementById('totalEmpty2').innerHTML = "0";
		                document.getElementById('totalEmpty3').innerHTML = "0";
		                document.getElementById('totalEmpty4').innerHTML = "0";
		                document.getElementById('totalReturnLoad1').innerHTML = "0";
		                document.getElementById('totalReturnLoad2').innerHTML = "0";
		                document.getElementById('totalReturnLoad3').innerHTML = "0";
		                document.getElementById('totalReturnLoad4').innerHTML = "0";
		                document.getElementById('onschedulecountid').innerHTML = "0";
		                document.getElementById('onschedulecountid1').innerHTML = "0";
		                document.getElementById('onschedulecountid2').innerHTML = "0";
		                document.getElementById('onschedulecountid3').innerHTML = "0";
		            }
		        }
		    }
		});
		

		
		var customerinnerPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    frame: false,
		    cls: 'dashboardcustomerinnerpannelForConsignment',
		    bodyCfg: {
		        cls: 'dashboardcustomerinnerpannelForConsignment',
		        style: {
		            'background-color': 'transparent'
		        }
		    },
		    id: 'custcomboMaster',
		    layout: 'table',
		    layoutConfig: {
		        columns: 14
		    },
		    items: [{
		            xtype: 'label',
		            text: '<%=CustomerName%>' + ':',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'customerNameId'
		        },
		        custnamecombo, {
		            xtype: 'label',
		            text: '',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'emptyId12'
		        }, {
		            xtype: 'label',
		            text: '<%=Region%>' + ':',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'regionId'
		        },
		        regionTypeCombo, {
		            xtype: 'label',
		            text: '',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'emptyId13'
		        },{
		            xtype: 'label',
		            text: 'Booking Customer' + ':',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'bookingcustomerNameId'
		        },bookingcustnamecombo,{
		            xtype: 'label',
		            text: '',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'emptyId14'
		        },{
		            xtype: 'label',
		            text: '',
		            cls: 'labelstyleforConsignmentDashboard',
		            id: 'emptyId16'
		        },
		        editInfo1
		    ]
		});
		
		var customerMainPanel = new Ext.Panel({
		    standardSubmit: true,
		    collapsible: false,
		    frame: false,
		    cls: 'dashboardcustomerpannelForConsignmentPanel',
		    bodyCfg: {
		        cls: 'dashboardcustomerpannelForConsignmentPanel',
		        style: {
		            'background-image': 'url(/ApplicationImages/DashBoard/Box_Blue.png) !important',
		            'background-repeat': 'repeat'
		        }
		    },
		    id: 'custMaster',
		    items: [customerinnerPanel]
		});
		
		customerMainPanel.render('customerIddiv1');
		google.maps.event.addDomListener(window, 'load', initialize);		
		</script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->


