<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	
%>

<!DOCTYPE html>
<html>
<head>
  
   <meta charset="utf-8" />
    <meta name="E-Vehicle" content="e-vehicle dashboard">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
    <title>E-VEHICLE FLEET MANAGEMENT PLATFORM</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link href="http://allfont.net/allfont.css?fonts=agency-fb" rel="stylesheet" type="text/css" />
    <link href='https://fonts.googleapis.com/css?family=Raleway' rel='stylesheet' type='text/css'>
    <link href="https://netdna.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href=" ../../Telematics4uApp/assets/EESL/Css/style_india.css" rel="stylesheet" />
    <link href=" ../../Telematics4uApp/assets/EESL/Css/style_location_maps_Dynamic.css" rel="stylesheet" />
    <link href=" ../../Telematics4uApp/assets/EESL/Css/style_db_updated1.css" rel="stylesheet" />
  <script src=" ../../Telematics4uApp/assets/EESL/Scripts/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src=" ../../Telematics4uApp/assets/EESL/Scripts/jquery.counterup.min.js"></script>
  <script src=" ../../Telematics4uApp/assets/EESL/Scripts/waypoints.min.js"></script>
   <script src="http://bhuvan5.nrsc.gov.in:80/bhuvan/openlayers/OpenLayers.js" type="text/javascript">
        </script>
		 <script src="https://openlayers.org/api/OpenLayers.js"></script>
   

  <style>
 #dashboard {
    margin: 0 auto;
    padding: 0px;
    font-family: Calibri;
    font-size: 22px;
    font-size: 18px;
    color: #000;
    line-height: 35px;
    background-color: #0189b7;
    /* padding-top: 0px; */
    /* overflow-x: hidden; */
}
h1 {
    font-family: Agency FB, 'Raleway', sans-serif;
    font-size: 60px;
    font-weight: normal;
    <!-- line-height: 50px; -->
    <!-- /* padding-bottom: 0px; */ -->
    <!-- padding-top: 20px; -->
}

.orange {
    color: #ff7f00;
}
.white {
    color: #fff;
}
.green {
    color: #3cd82d;
}


.TotalTab {
    text-align: center;
    color: #000;
}

.blue_bg {
   background-image: url(../../Telematics4uApp/assets/EESL/images/blue_bg.png) !important;
    background-repeat: repeat-x;
    background-position: left center;
	border: solid 1px #0189b7;
	height: auto !important;
}

.digital_font {
    font-family: Digital-7;
    font-size: 140px;
    color: #fff;
    text-decoration: none;
	margin-top:4%;
	text-align: center;
}

.footer_title {
    padding-left: 36%;
}

.AgencyBox {
	 border: 3px solid white;
    line-height: 2;
    width: 17%;
    background-color: #5eb9f9;
    margin-bottom: 2%;
    margin-left: 21px;
}
.AgencyDivider {
    border: 1px solid #dedede;
    margin: 10px; 
    margin-left: 10px;
    margin-right: 10px;
}


	  
	  .factor_val {
          color: #f5f5f5;
    font-size: 24px;
    line-height: 30px;
    display: inline-block;
	font-weight: 600;
}

.factor_lbl {
      color: #f5f5f5;
    font-size: 16px;
    line-height: 30px;
    padding-bottom: 20px;
    font-weight: 600;
}
#Heading{
    font-size: 20px;
    font-weight: 500;
    color: #0189b7;
}
.panel-footer {
    padding: 10px 15px;
    background-color: #337ab7 !important;
    border-top: 1px solid #ddd;
    border-bottom-right-radius: 3px;
    border-bottom-left-radius: 3px;
    color: #fff;
}

a {
    color: #fff;
    text-decoration: none;
    /* text-align: center; */
}




.panel-body {
    padding: 15px;
    margin-top: 2%;
}


#map {
    clear: both;
    position: relative !important;
    width: 84%;
    height: 620px !important;
    border: 1px solid #fcf8e3;
    margin-top: 2%;
    margin-left: 8%;
}

#myBtn {
  display: none;
  position: fixed;
  bottom: 16px;
  right: 32px;
  z-index: 99;
  font-size: 18px;
  border: none;
  outline: none;
  background-color: #808080;
  color: white;
  cursor: pointer;
  padding: 15px;
  border-radius: 4px;
}

#myBtn:hover {
  background-color: #555;
}
.valuePanel{
white-space: nowrap;

}

  </style>
</head>
<body onload="loadData()">
 

     <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
            <div class="conainer">

                <div id="dashboard" class="panel">
				
                   <div style="text-align: center; line-height: 28px;">
						<a target="_blank" href="http://ujala.gov.in/" class="TopMenu TopMenu1">Bulb Dashboard</a>
						<a target="_blank" href="http://fan.ujala.gov.in/" class="TopMenu TopMenu1">Fan Dashboard</a>
						<a target="_blank" href="http://ledtubes.ujala.gov.in/" class="TopMenu TopMenu2">Tubelight Dashboard</a>
						<!-- <a class="LanguageTranslateTextHide TopMenu TopMenu3" href="#">हिंदी में अनुवाद</a> -->
						<a href="#" class="TopMenu TopMenu4">FAQs</a>
						<a class="TopMenu TopMenu5" onclick="login()">Fleet Tracking Login</a>
		      </div>
                    <div class="panel-body">

                        <div class="row">
                            <div class="col-sm-4 col-md-3 col-lg-3"><img src="../../Telematics4uApp/assets/EESL/images/ministry-ofpower.png" style="margin-left: 20%;"></div>
                            <div class="col-sm-4 col-md-6 col-lg-6" style="margin-top: -3%;">
                                <h1 style="margin-left: 3%;">
										<span class="orange">NATIONAL</span> 
										<span class="white">E-VEHICLE</span> 
										<span class="green">DASHBOARD</span>
										</h1></div>
                            <div class="col-sm-4 col-md-3 col-lg-3"><img src="../../Telematics4uApp/assets/EESL/images/eesl-lg.png" style="margin-left: 30%;"></div>

                        </div> <!-- end of 1st row : panel-1- image and heading -->
						

                        <div class="row blue_bg " border="0" align="center" cellpadding="0" cellspacing="0">
                            <span class="TotalTab">Total E-Vehicle as on <span id="dateid"></span></span>
                        </div>  <!-- end of date row -->
						
						<div class="row"> 
							
							<div class="col-sm-12 col-md-12 col-lg-12">
							
							<div class="col-sm-12 col-md-12 col-lg-12 digital_font"> 
							<span class="counter" id="ecount" style="display: inline-block;"> 0 </span> </div>
								
								
								<div class="col-sm-12 col-md-12 col-lg-12" style="    margin-top: 6%;
    padding-left: 0%;
    width: 88%;
    margin-left: 12%;">
								
							   <div class="col-sm-2 col-md-2 col-lg-2 valuePanel" style="border-right: 1px solid #aaa;">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_avoidedcapacity.png" style="margin-left:20%"><br>
									  <span class="counter factor_val digital_font" id="distId">0</span>
									  <span class="factor_val">km</span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl">
									 Total Distance Travelled
								   </div>
								</div>
								
								<div class="col-sm-2 col-md-2 col-lg-2 valuePanel " style="border-right: 1px solid #aaa;">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_avoidedcapacity.png" style="margin-left:20%"><br>
									  <span class="counter factor_val digital_font" id="fuelSaved">0</span>
									  <span class="factor_val">Ltrs</span>
								   </div>						
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl">
									  Fuel Saved
								   </div>
								</div>
								
															
								<div class="col-sm-2 col-md-2 col-lg-2 valuePanel" style="border-right: 1px solid #aaa;">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_costsavingperday.png" style="margin-left:20%"><br>
									  <span class="factor_val">INR</span>
									  <span class="counter factor_val digital_font" id="FuelCostSaved">0</span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl">
									  Fuel Cost Saved 
								   </div>
								</div>
								
								<div class="col-sm-2 col-md-2 col-lg-2 valuePanel" style="border-right: 1px solid #aaa;">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_co2reduction.png" style="margin-left:18%"><br>
									  <span class="counter factor_val digital_font" id="co2Id"></span>
									  <span class="factor_val">&nbsp;&nbsp;t CO<sub>2</sub></span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl" style="padding-left: 20%;">
									  CO2 Reduction
								   </div>
								</div>
								
								
								<div class="col-sm-2 col-md-2 col-lg-2 valuePanel" >
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_co2reduction.png" style="margin-left:18%"><br>
									  <span class="counter factor_val digital_font" id="co2kgId">0</span>
									  <span class="factor_val">&nbsp;&nbsp;kg CO<sub>2</sub></span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl" style="padding-left: 20%;">
									  CO2 Reduction
								   </div>
								</div>
								
								
								
								</div>
								                                  
									
									
                                </div>   
								</div>  <!-- end of 3rd row : image and number panel -->
								
								<div id="map" class="col-sm-12 col-md-12 col-lg-12" style="height:620px;" >
										<!-- <div class="col-sm-12 col-md-1 col-lg-1" ></div>
										 <div class="col-sm-12 col-md-10 col-lg-10" id="map"></div>
										 <div class="col-sm-12 col-md-1 col-lg-1" ></div>  -->
								</div>	
 
<div class="col-sm-10 col-md-10 col-lg-10" style="    padding-top: 4px;
    background-color: #cceafd;
    margin-top: 2%;
    margin-left: 8%;">
   <div class="col-sm-12 col-md-12 col-lg-12" "><span class="footer_title">Zone Wise E-Vehicle Distribution</span></div>
   <div class="col-sm-12 col-md-12 col-lg-12 row" >
   
      <div class="col-xm-2 col-sm-2  col-md-2 col-lg-2  AgencyBox DopAgencyBox" align="center" style="margin-left: 5%">
         <span class="digital-font counter" id="northId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> North </span>
      </div>
	  <div class="col-xm-2 col-sm-2  col-md-2 col-lg-2 AgencyBox HpclAgencyBox" align="center">
         <span class="digital-font counter" id="southId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> South </span>
      </div>
	  <div class="col-xm-2 col-sm-2  col-md-2 col-lg-2 AgencyBox IoclAgencyBox" align="center">
         <span class="digital-font counter" id="eastId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> East </span>
      </div>
	  <div class="col-xm-2 col-sm-2   col-md-2 col-lg-2 AgencyBox CscAgencyBox" align="center">
         <span class="digital-font counter" id="westId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> West </span>
      </div>
	  <div class="col-xm-2 col-sm-2  col-md-2 col-lg-2 AgencyBox DopAgencyBox" align="center">
         <span class="digital-font counter" id="centerId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName">Central</span>
      </div>
	   
	  
      
   </div>
</div>

<!-- FOOTER --->
<!-- <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top:1%;"> -->
<!-- <div class="col-sm-12 col-md-2 col-lg-2" style="    border: 2px solid #0189b7;; -->
    <!-- padding: 0px; -->
    <!-- border-radius: 15px; -->
    <!-- background-color: #fff;margin-left: 40%;cursor: pointer;" ><img src="../../Telematics4uApp/assets/EESL/images/ecar.png" style="margin-left: 6%;"> -->

<!-- </div> -->
<!-- <div class="col-sm-12 col-md-12 col-lg-12" style=" padding-left: 44%; -->
    <!-- font-weight: 500; -->
     <!-- font-family: sans-serif; -->
    <!-- color: #fff;">About e-Vehicle</div> -->
								
							<!-- </div> -->
								
							</div>
								
							<!-- </div> -->
						</div>  <!-- end of main panel -->
                    </div>
                 

     
       
<script>
 var eeslDetails;
 locationArray=[];
 var map;
 
 var path=window.location.pathname;
var url=window.location.href;
var link = url.replace(path,''); /// redirectPath
var extenstion="/t4u/eesl";
function login(){
window.open(link+extenstion, '_blank');
}

 setTimeout(function() {
     // window.location.reload(1);
	 loadContent();
 }, 20000);
 
 window.onscroll = function() {scrollFunction();
        };
        function scrollFunction() {
            if (document.body.scrollTop > 15 || document.documentElement.scrollTop > 15) {
                document.getElementById("myBtn").style.display = "block";
            } else {
                document.getElementById("myBtn").style.display = "none";
            }
        }



// When the user clicks on the button, scroll to the top of the document
        function topFunction() {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        }
		
		
 var vectorLayer1 = new OpenLayers.Layer.Vector("Overlay");

 function loadData() {
	     map = new google.maps.Map(document.getElementById('map'), {
          zoom: 5,
          center: {lat:23.805450,lng:77.739259},
		  mapTypeControl: false,
            gestureHandling: 'greedy',
            styles: [
    {
        "featureType": "all",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#7c93a3"
            },
            {
                "lightness": "-10"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#7CC7DF"
            }
        ]
    }
	]
        });
	 loadContent();
    }
	
	function loadContent(){
		 $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/PublicViewAction.do?param=getDashBoardDetails',

         success: function(result) {
             eeslDetails = JSON.parse(result);
             var j = 0;
             var m=eeslDetails["Details"].length;
			 m=parseInt(m);
			 m=m-1;
             for (var i = 0; i < eeslDetails["Details"].length; i++) {
                 var regNO = eeslDetails["Details"][i].RegNo;
                 var lat = eeslDetails["Details"][i].lat;
                 var lng = eeslDetails["Details"][i].lng;
                 var zone = eeslDetails["Details"][i].zone;
                 j = i + 1;
                 document.getElementById("ecount").innerHTML = m;//eeslDetails["Details"].length;
                 document.getElementById("northId").innerHTML = m;
                 document.getElementById("southId").innerHTML = '0';
                 document.getElementById("eastId").innerHTML = '0';
                 document.getElementById("westId").innerHTML = '0';
                 document.getElementById("centerId").innerHTML = '0';
                // document.getElementById("totalId").innerHTML = m;//eeslDetails["Details"].length;
								var obj = new Object();
                                obj.lat = lat;
								obj.lng = lng;
							    obj.reg = regNO;
								locationArray.push(obj);
                 // Define markers as "features" of the vector layer:


             }
			 document.getElementById("fuelSaved").innerHTML = eeslDetails["Details"][m].fuelSaved;
             document.getElementById("FuelCostSaved").innerHTML = eeslDetails["Details"][m].FuelCostSaved;
             document.getElementById("co2Id").innerHTML = parseFloat(eeslDetails["Details"][m].co2inTon);
             document.getElementById("co2kgId").innerHTML = parseFloat(eeslDetails["Details"][m].co2inkg);//eeslDetails["Details"][m].co2inkg;
             document.getElementById("distId").innerHTML =parseInt(eeslDetails["Details"][m].distance);  //eeslDetails["Details"][m].distance;
             
         }

     }).done(function() { //use this
     
         callRunner();
          document.getElementById('ecount').innerHTML = pad(eeslDetails["Details"].length,5);
		   loadMap();
          
     });
		
	}

 function callRunner() {

     $('.counter').counterUp({
         delay: 13,
         time: 1700
     });

     startTime();
 }

function pad(num, size) {
    var s = num+"";
    while (s.length < size) s = "0" + s;
    return s;
}


 function getCurTime() {
     var today = new Date();
     var dd = today.getDate();
     var mm = today.getMonth() + 1; //January is 0!
     var yyyy = today.getFullYear();
     var h = today.getHours();
     var m = today.getMinutes();
     var s = today.getSeconds();
     m = checkTime(m);
     s = checkTime(s);

     if (dd < 10) {
         dd = '0' + dd
     }

     if (mm < 10) {
         mm = '0' + mm
     }

     today = mm + '/' + dd + '/' + yyyy;
     return today;
 }

 function checkTime(i) {
     if (i < 10) {
         i = "0" + i;
     }
     return i;
 }

 function startTime() {
     var today = new Date();
     var h = today.getHours();
     var m = today.getMinutes();
     var s = today.getSeconds();
     // add a zero in front of numbers<10
     m = checkTime(m);
     s = checkTime(s);
     var dd = getCurTime();
     document.getElementById('dateid').innerHTML = dd + " " + h + ":" + m + ":" + s;

     t = setTimeout(function() {
         startTime()
     }, 500);
 }

 /*Map details*/
   <!-- Map  -->
  function loadMap() {

     
		
        // Create an array of alphabetical characters used to label the markers.
        var labels = '123456789';
		
		image = {
				url: "http://telematics4u.in/ApplicationImages/VehicleImagesNew/MapImages/default_BG.png" , // This marker is 20 pixels wide by 32 pixels tall.
				scaledSize: new google.maps.Size(35, 35), // The origin for this image is 0,0.
				origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
				anchor: new google.maps.Point(0, 32)
			};

        // Add some markers to the map.
        // Note: The code uses the JavaScript Array.prototype.map() method to
        // create an array of markers based on a given "locations" array.
        // The map() method here has nothing to do with the Google Maps API.
        var markers = locations.map(function(location, i) {
          return new google.maps.Marker({
            position: location,
            label: labels[i % labels.length],
			icon: image
          });
        });

        // Add a marker clusterer to manage the markers.
        var markerCluster = new MarkerClusterer(map, markers,
            {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
      }
      var locations = locationArray;
     
      
    
	
    </script>
    <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
    </script>
    <script async defer
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDQk997sgiTs6KDoTQ3WdtyVfqv_yAt_68&region=IN&callback=initMap">
    </script>
  
  </body>
</html> 