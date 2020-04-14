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
	
	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("Sales_Person_Name");
	tobeConverted.add("Select_Sales_Person");
	tobeConverted.add("No_Of_Follow_Ups");
	tobeConverted.add("No_Of_Customer_Visits"); 
	tobeConverted.add("Pending_Follow_Ups");
	tobeConverted.add("FFM_DashBoard");
	tobeConverted.add("Number_Of_Employees");
	tobeConverted.add("Non_Communicating");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String SalesPersonName=convertedWords.get(0);
	String SelectSalesPerson=convertedWords.get(1);
	String NoofFollowups=convertedWords.get(2);
    String NoofCustomerVisits=convertedWords.get(3);
    String PendingFollowups=convertedWords.get(4);
    String ffmDashBoard = convertedWords.get(5);
    String NoOfEmployees=convertedWords.get(6);
    String NonCommunicating=convertedWords.get(7);
%>
<jsp:include page="../Common/header.jsp" />  
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">   
	<title><%=ffmDashBoard %></title>
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
	width: 84%;
	height: 550px;
}

.mp-map-wrapper1 {
	width: 99.5%;
	height: 385px;
	position: absolute;
}

.x-table-layout1 td {
	vertical-align: top;
	height:30%;
	border: 5px solid white
}

.dashboardcustomerpannelForFFMPanel {
	height: 50px;
	border: 0px none !important;
	padding-left: 20px;
	width: 99%;
	padding-top: 15px;
}
.labelstyles {
	spacing: 10px;
	height: 5px;
	width: 150 px !important;
	min-width: 150px !important;	
	margin-left: 5px !important;
	font-size: 5px;
	font-family: sans-serif;
}

.mp-container1 {
	background: #f4f4f4;
	border: 8px solid #FFF;
	width: 58%;
	height: 430px;
	top:80px;	
	position: relative;	
	margin: initial;	
	-moz-box-shadow: 1px 1px 3px #cac4ab;
	-webkit-box-shadow: 1px 1px 3px #cac4ab;
	box-shadow: 1px 4px 7px #000;	
	left:40%; 
}


   .iconons {
	font-size: 300%;
	font-family: Open Sans,Light;
	text-align: center;
	cursor: pointer;
	color: #FFF;
}
	
.spanons{    
	font-family: "Open Sans",sans-serif;    
    text-align: center;
    color: #FFF;
    font-size: 80%;
}

.assetIconlabel {
    height: 130px;
    background-color: #8CC22E;
    background-image: url("/ApplicationImages/DashBoard/total_asset_icon.png") !important;
    background-repeat: no-repeat;
    background-size: 100% auto;  
   	text-align: center;
   	float:left;
   	width:40%;
   	border-bottom: 5px solid #FFF;
	border-left: 5px solid #FFF;
	border-top: 5px solid #FFF;
}
.textIconlabel {
    height: 130px;
    background-color: #9ED43E;  
   	text-align: center;
 	float:left;
   	width:60%;
   	border-bottom: 5px solid #FFF;
	border-top: 5px solid #FFF;
	border-right: 5px solid #FFF;
}

.assetIconlabel2 {
    height: 130px;
    background-color: #E7BD1B;
    background-image: url("/ApplicationImages/DashBoard/vcl_onroad_icon.png") !important;
    background-repeat: no-repeat;
    background-size: 100% auto;   
   	text-align: center;
    float:left;
   	width:40%;
   	border-bottom: 5px solid #FFF;
	border-left: 5px solid #FFF;
	border-top: 5px solid #FFF;
}

.textIconlabel2 {
    height: 130px;
    background-color: #F6CC2A;   
   	text-align: center;
	float:left;
   	width:60%;
	border-bottom: 5px solid #FFF;
	border-top: 5px solid #FFF;
	border-right: 5px solid #FFF;
}

.assetIconlabel3 {

 height: 130px;
    background-color: #E7BD1B;
    background-image: url("/ApplicationImages/DashBoard/no_comm_m24.png") !important;
    background-repeat: no-repeat;
    background-size: 100% auto;   
   	text-align: center;
    float:left;
   	width:40%;
   	border-bottom: 5px solid #FFF;
	border-left: 5px solid #FFF;
	border-top: 5px solid #FFF;

}

.textIconlabel3 {
    height: 130px;
    background-color: #E1915C;    
   	text-align: center;
    float:left;
   	width:60%;
   	border-bottom: 5px solid #FFF;
	border-top: 5px solid #FFF;
	border-right: 5px solid #FFF;  
}

.assetIconlabel1 {
    height: 130px;
    background-color: #FFA62F;
    background-image: url("/ApplicationImages/DashBoard/communication.png") !important;
    background-repeat: no-repeat;
    background-size: 100% auto;    
   	text-align: center;
    float:left;
   	width:40%;
   	border-bottom: 5px solid #FFF;
	border-left: 5px solid #FFF;
	border-top: 5px solid #FFF;
}

.textIconlabel1 {
    height: 130px;
    background-color: #FFB149;
   	text-align: center;
	float:left;
   	width:60%;
   	border-bottom: 5px solid #FFF;
	border-top: 5px solid #FFF;
	border-right: 5px solid #FFF;
}

.assetIconlabel4 {

 height: 130px;
    background-color: #C94224;
    background-image: url("/ApplicationImages/DashBoard/no_gps_icon.png") !important;
    background-repeat: no-repeat;
    background-size: 100% auto;   
   	text-align: center;
    float:left;
   	width:40%;
   	border-bottom: 5px solid #FFF;
	border-left: 5px solid #FFF;
	border-top: 5px solid #FFF;

}

.textIconlabel4 {

  height: 130px;
    background-color: #E0502E;
   	text-align: center;
	float:left;
   	width:60%;
	border-bottom: 5px solid #FFF;
	border-top: 5px solid #FFF;
	border-right: 5px solid #FFF;

}

.assetIconlabel5 {

 height: 130px;
    background-color: #C94224;
    background-image: url("/ApplicationImages/DashBoard/communication.png") !important;
    background-repeat: no-repeat;
    background-size: 100% auto;   
   	text-align: center;
    float:left;
   	width:40%;
   	border-bottom: 5px solid #FFF;
	border-left: 5px solid #FFF;
	border-top: 5px solid #FFF;

}

.textIconlabel5 {

  height: 130px;
    background-color: #E0502E;
   	text-align: center;
	float:left;
   	width:60%;
	border-bottom: 5px solid #FFF;
	border-top: 5px solid #FFF;
	border-right: 5px solid #FFF;

}

.main1 {
	width: 38%;
	top: 20px;
	height: 435px;   
	float: left;
	position:relative;
	padding-left:15px;
	vertical-align: top;
}
      
.combodiv1{
	position:relative;
	height: 60px;
	width: 100%; 
	float: right;
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
	background-image: url(/ApplicationImages/DashBoard/DashBoardBackground1.png) !important;
} 


</style>
	<head>

		<link rel="stylesheet" type="text/css" 
			href="../../Main/modules/FFM/mapView/css/component.css" />
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/FFM/mapView/css/layout.css" />
		
				       
		<link rel="stylesheet" type="text/css" href="../../Main/modules/FFM/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/FFM/dashBoard/css/component.css" />
		 <link rel="stylesheet" type="text/css" href="../../Main/modules/FFM/dashBoard/css/style.css" />
		
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

		<!-- for grid -->
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
			
		<pack:script src="../../Main/Js/MsgBox.js"></pack:script> 
		
	</head>
	
	<script src=<%=GoogleApiKey%>></script>
	<body onload="loadData();" class="bodyBackGround" >
		<div class="container">
	
			<div class="combodiv1" id="customerIddiv1">
			</div>			
		   <a class="back" href=""></a>
            <span class="scroll"></span>		   
		   <div class="main1">
            <table style="width: 100%;">
            <tr>   
            <td id="onschedulecountidForBox" style="border: 3px solid transparent;">
		   <div class="assetIconlabel" ></div>
		   <div class="textIconlabel">
		   <div class="iconspace"></div>
		   <span class="iconons" id="onschedulecountid"><b></b></span><br>
		   <span class="spanons"><b><%=NoOfEmployees %></b></span>		   
		   </div>
		   </td>		   
		   <td  id="onschedulecountidForBox1" style="border: 3px solid transparent;">
		    <div class="assetIconlabel1"> </div>
		   <div class="textIconlabel1">
		   <div class="iconspace"></div>
		   <span class="iconons" id="onschedulecountid1"><b></b></span><br> 
		   <span class="spanons"><b><%=NoofFollowups%></b></span>		    
		     </div>		 
		   </td>
			</tr>
			<tr>
			<td  id="onschedulecountidForBox2" style="border: 3px solid transparent;">		   
		    <div class="assetIconlabel2"></div>  
		   <div class="textIconlabel2">
		   <div class="iconspace"></div>
		   <span class="iconons" id="onschedulecountid2" onclick="forwardCall();"><b></b></span><br>
		   <span class="spanons"><b><%=NoofCustomerVisits %></b></span>		    
		     </div>
		
		   </td>
		   <td  id="onschedulecountidForBox3" style="border: 3px solid transparent;">		   
		    <div class="assetIconlabel3"></div> 
		   <div class="textIconlabel3">
		   <div class="iconspace"></div>
		   <span class="iconons" id="onschedulecountid3"><b></b></span><br>
		   <span class="spanons"><b><%=PendingFollowups %></b></span>		    
		     </div>
		 
		   </td>
		  </tr>
		  	<tr>
			<td  id="onschedulecountidForBox4" style="border: 3px solid transparent;">		   
		    <div class="assetIconlabel4"></div>  
		   <div class="textIconlabel4">
		   <div class="iconspace"></div>
		   <span class="iconons" id=onschedulecountid4 onclick="forwardCall();"><b></b></span><br>
		   <span class="spanons"><b><%=NonCommunicating%></b></span>		    
		     </div>
		
		   </td>	
		   
		   	<td  id="onschedulecountidForBox5" style="border: 3px solid transparent;">		   
		    <div class="assetIconlabel5"></div>  
		   <div class="textIconlabel5">
		   <div class="iconspace"></div>
		   <span class="iconons" id=onschedulecountid5 onclick="forwardCall();"><b></b></span><br>
		   <span class="spanons"><b>Communicating</b></span>		    
		     </div>
		
		   </td>
		   	   
		  </tr>
		   </table>
		   </div>		   
         </div>	  
				<div class="mp-container1" id="mp-container">
					<div class="mp-map-wrapper1" id="map">
					</div>
					<div class="mp-options-wrapper" />
					<div class="mp-option-showhub">					 	 
						<div class="mp-option-normal" id="option-normal" style="display:none;"
							onclick="reszieFullScreen()"></div>
						<div class="mp-option-fullscreenl" id="option-fullscreen"
							onclick="mapFullScreen()"></div>
					</div>  
					</div>
		</div>		
<script>
var st='<%=loginInfo.getStyleSheetOverride()%>';		
var markers = {};
var infowindows = {}; 
var marker;
var custId = "";
var map;
var All = "All";
var dashBoard = '<%=dashBoardSummary%>';
var infowindow;
var status = "";
var $mpContainer = $('#mp-container');
var $mapEl = $('#map');

var loadMask = new Ext.LoadMask(Ext.getBody(), {
    msg: "Loading"
});

var lat = '22.89';
var lng = '78.88';

var totalFollowUpstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getTotalFollowUp',
    id: 'totalFollowUpStoreId',
    root: 'totalFollowUpRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['totalFollowUpCount'],
    listeners: {
        load: function() {            
            document.getElementById('onschedulecountid1').innerHTML = totalFollowUpstore.getAt(0).get('totalFollowUpCount');
        }
    }
});

var pendingFollowUpstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getPendingFollowUp',
    id: 'pendingFollowUpStoreId',
    root: 'pendingFollowUpRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['PendingFollowUpCount'],
    listeners: {
        load: function() {            
            document.getElementById('onschedulecountid3').innerHTML = pendingFollowUpstore.getAt(0).get('PendingFollowUpCount');
        }
    }
});

function forwardCall(){
    if(Ext.getCmp('salespersoncomboId').getValue()=="" && Ext.getCmp('salespersoncomboId').getRawValue() !="All" ) {     	
    }else {
    	if(numVisitstore.getAt(0).get('NumVisits')>0){
	    	if(Ext.getCmp('salespersoncomboId').getRawValue()=="All") {    
	    		window.location = "<%=request.getContextPath()%>/Jsps/FFM/NumberOfVisits.jsp?usrId=0&style="+st;    		
	    	}else{
	    	       var usr=Ext.getCmp('salespersoncomboId').getValue();
	    	     window.location = "<%=request.getContextPath()%>/Jsps/FFM/NumberOfVisits.jsp?usrId="+usr+"&style="+st;
			}
		} 
	}
}

var customercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getUserName',
    id: 'CustomerStoreId',
    root: 'userRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['asmName', 'asmId']
});

var noncomstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getPendingFollowUps',
    id: 'NoncomStoreId',
    root: 'pendingRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['registrationNumber', 'groupName', 'latitude', 'longitude', 'location', 'mobileNo'],
    listeners: {
        load: function() {         	        
            for (x = 0; x < noncomstore.getCount(); x++) {                  
                var rec = noncomstore.getAt(x);  
                if ((rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") && rec.data['location']!='No GPS Device Connected' && rec.data['location']!='') {
                    plotSingleVehicle(rec.data['registrationNumber'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['mobileNo'],'Noncomm');
                }
            }  
            document.getElementById('onschedulecountid4').innerHTML = noncomstore.getCount();
        }
    }
});

var comstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getCommunicatingFollowUps',
    id: 'comStoreId',
    root: 'pendingRoot2',
    autoLoad: false,
    remoteSort: true,
    fields: ['registrationNumber', 'groupName', 'latitude', 'longitude', 'location', 'mobileNo'],
    listeners: {
        load: function() {  
            for (x = 0; x < noncomstore.getCount(); x++) {                  
                var rec = noncomstore.getAt(x);  
                if ((rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") && rec.data['location']!='No GPS Device Connected' && rec.data['location']!='') {
                    plotSingleVehicle(rec.data['registrationNumber'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['mobileNo'],'Noncomm');
                }
            }  
            document.getElementById('onschedulecountid5').innerHTML = comstore.getCount();
        }
    }
});

var numVisitstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getNumVisits',
    id: 'NumVisitStoreId',
    root: 'numVisitRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['NumVisits'],
    listeners: {
        load: function() {            
            document.getElementById('onschedulecountid2').innerHTML = numVisitstore.getAt(0).get('NumVisits');
        }
    }
});

var regstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getFollowUps',
    id: 'RegStoreId',
    root: 'followRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['registrationNumber', 'groupName', 'latitude', 'longitude', 'location', 'mobileNo'],
    listeners: {
        load: function() {            
            for (w = 0; w < regstore.getCount(); w++) {                  
                var rec = regstore.getAt(w);  
                if ((rec.data['latitude'] != "0.0" && rec.data['longtitude'] != "0.0") && rec.data['location']!='No GPS Device Connected' && rec.data['location']!='') {
                    plotSingleVehicle(rec.data['registrationNumber'], rec.data['latitude'], rec.data['longitude'], rec.data['location'], rec.data['mobileNo'],'Comm');
                }
            }  
            document.getElementById('onschedulecountid').innerHTML = regstore.getCount();
            
            noncomstore.load({
                params: {
                    ussrId: Ext.getCmp('salespersoncomboId').getValue()
                }
            });
            
             comstore.load({
                params: {
                    ussrId: Ext.getCmp('salespersoncomboId').getValue()
                }
            });
        }
    }
});
 
function mapFullScreen() {
    document.getElementById('option-fullscreen').style.display = 'none';
    document.getElementById('option-normal').style.display = 'block';
    $mpContainer.removeClass('mp-container-fitscreen');
    document.getElementById("onschedulecountidForBox").style.visibility = "hidden";
    document.getElementById("onschedulecountidForBox1").style.visibility = "hidden";
    document.getElementById("onschedulecountidForBox2").style.visibility = "hidden";
    document.getElementById("onschedulecountidForBox3").style.visibility = "hidden";
    document.getElementById("onschedulecountidForBox4").style.visibility = "hidden";
    document.getElementById("onschedulecountidForBox5").style.visibility = "hidden";
    $mpContainer.addClass('mp-container-fullscreen').css({
        width: 'originalWidth',
        height: 'originalHeight'
    });
    $mapEl.css({
        width: $mapEl.data('originalWidth'),
        height: 450 //$mapEl.data('originalHeight')
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
    document.getElementById("onschedulecountidForBox4").style.visibility = "visible";
    document.getElementById("onschedulecountidForBox5").style.visibility = "visible";
    $mapEl.css({
        width: $mapEl.data('originalWidth'),
        height: 384 //$mapEl.data('originalHeight')
    });
    google.maps.event.trigger(map, 'resize');
}

function loadData() {
    document.getElementById('onschedulecountid').innerHTML = "0";
    document.getElementById('onschedulecountid1').innerHTML = "0";
    document.getElementById('onschedulecountid2').innerHTML = "0";
    document.getElementById('onschedulecountid3').innerHTML = "0";
    document.getElementById('onschedulecountid4').innerHTML = "0";
    document.getElementById('onschedulecountid5').innerHTML = "0";
    customercombostore.load({

    });

}

function initialize() {
    var mapOptions = {
        zoom: 4,
        center: new google.maps.LatLng(lat, lng),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById('map'), mapOptions);
    return;
}

function plotSingleVehicle(regNo, latitude, longtitude, loc, mobileNo,status) {
	if(status=='Comm') {
    	imageurl = '/ApplicationImages/VehicleImages/green.png';
    } else {
    	imageurl = '/ApplicationImages/VehicleImages/red.png';
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

var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; line-height:100%; font-size:100%; font-family: sans-serif;">' +
	    '<table>' +
	    '<tr><td><b><span style="color:gray">Person Name:</span></b></td><td><span style="color:blue">'+ regNo + '</span></td></tr>' + 
	    '<tr><td><b><span style="color:gray">Area:</span></b></td><td><span style="color:brown">' + loc + '</td></tr>' +
	    '<tr><td><b><span style="color:gray">Mobile No:</span></b></td><td><span style="color:olive">' + mobileNo + '</span></td></tr>' +
	    '</table>' +
	    '</div>';
	infowindow = new google.maps.InfoWindow({
	    content: content,
	    maxWidth: 400,
	    marker: marker,
	    image: image,
	    id: regNo
	});
	
	google.maps.event.addListener(marker, 'click', (function(marker, content, infowindow) {
	    return function() {
	        infowindow.setContent(content);
	        infowindow.open(map, marker);
	    };
	})(marker, content, infowindow));
	marker.setAnimation(google.maps.Animation.DROP);
	var bounds = new google.maps.LatLngBounds(new google.maps.LatLng(latitude, longtitude));
    map.fitBounds(bounds);
     var listener = google.maps.event.addListener(map, "click", function() {
	if (map.getZoom() > 16) map.setZoom(3);
  			google.maps.event.removeListener(listener); 
		});
	return;
}

var salespersoncombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'salespersoncomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectSalesPerson%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'asmId',
    displayField: 'asmName',
    cls: 'selectstylePerfect',
    listeners: {
        select: function() {
        	initialize();  
            regstore.load({
                params: {
                    ussrId: Ext.getCmp('salespersoncomboId').getValue()
                }
            });
            numVisitstore.load({
                params: {
                    ussrId: Ext.getCmp('salespersoncomboId').getValue()
                }
            });
            totalFollowUpstore.load({
                params: {
                    ussrId: Ext.getCmp('salespersoncomboId').getValue()
                }
            });
            pendingFollowUpstore.load({
                params: {
                    ussrId: Ext.getCmp('salespersoncomboId').getValue()
                }
            });
        }

    }

});

var salesPersonMainPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    frame: false,
    cls: 'dashboardcustomerpannelForFFMPanel',
    bodyCfg: {
        cls: 'dashboardcustomerpannelForFFMPanel',
        style: {
            'background-image': 'url(/ApplicationImages/DashBoard/Box_Blue.png) !important',
            'background-repeat': 'repeat'
        }
    },
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: '<%=SalesPersonName%>' + ':',
            cls: 'labelstyle',
            id: 'customerNameId'
        },
        salespersoncombo
    ]
});

salesPersonMainPanel.render('customerIddiv1');
google.maps.event.addDomListener(window, 'load', initialize);
		</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->



