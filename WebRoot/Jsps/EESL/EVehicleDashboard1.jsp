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
    font-size: 100px;
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
}
.AgencyDivider {
    border: 1px solid #dedede;
    margin: 10px; 
    margin-left: 10px;
    margin-right: 10px;
}


	  
	  .factor_val {
          color: #f5f5f5;
    font-size: 20px;
    line-height: 30px;
    display: inline-block;
	font-weight: 600;
}

.factor_lbl {
      color: #f5f5f5;
    font-size: 13px;
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


.value_delhi_state {
    position: absolute;
    left: 310px;
    top: 194px;
    /* z-index: 0; */
}

.value_delhi {
    position: absolute;
    left: 136px;
    top: 138px;
}

.panel-body {
    padding: 15px;
    margin-top: 2%;
}


  </style>
</head>
<body onload="loadData()">
 


            <div class="conainer">

                <div id="dashboard" class="panel">
				
                   <div style="text-align: center; line-height: 28px;">
						<a href="#" class="TopMenu TopMenu1">Bulb Dashboard</a>
						<a href="#" class="TopMenu TopMenu1">Fan Dashboard</a>
						<a href="#" class="TopMenu TopMenu2">Tubelight Dashboard</a>
						<a class="LanguageTranslateTextHide TopMenu TopMenu3" href="#">हिंदी में अनुवाद</a>
						<a href="#" class="TopMenu TopMenu4">FAQs</a>
						<a class="TopMenu TopMenu5" onclick="login()">Fleet Tracking Login</a>
		      </div>
                    <div class="panel-body">

                        <div class="row">
                            <div class="col-sm-12 col-md-3 col-lg-3"><img src="../../Telematics4uApp/assets/EESL/images/ministry-ofpower.png" style="margin-left: 20%;"></div>
                            <div class="col-sm-12 col-md-6 col-lg-6" style="margin-top: -3%;">
                                <h1>
										<span class="orange">NATIONAL</span> 
										<span class="white">E-VEHICLE</span> 
										<span class="green">DASHBOARD</span>
										</h1></div>
                            <div class="col-sm-12 col-md-3 col-lg-3"><img src="../../Telematics4uApp/assets/EESL/images/eesl-lg.png" style="margin-left: 25%;"></div>

                        </div> <!-- end of 1st row : panel-1- image and heading -->
						

                        <div class="row blue_bg " border="0" align="center" cellpadding="0" cellspacing="0">
                            <span class="TotalTab">Total E-Vehicle as on <span id="dateid"></span></span>
                        </div>  <!-- end of date row -->
						
						<div class="row"> 
							
							<div class="col-sm-12 col-md-12 col-lg-12" style="height:370px">
							
							<div class="col-sm-12 col-md-12 col-lg-12 digital_font"> 
							<span class="counter" id="ecount" style="display: inline-block;"> 0 </span> </div>
								
								
								<div class="col-sm-12 col-md-12 col-lg-12" style="margin-top:5% ;margin-left: 0%;">
								<div class="col-sm-12 col-md-3 col-lg-3" ></div>
							
								
								<div class="col-sm-6 col-md-2 col-lg-2" style="border-right: 1px solid #aaa;padding-left:5%">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_avoidedcapacity.png" style="margin-left:30%"><br>
									  <span class="counter factor_val digital_font">37,179</span>
									  <span class="factor_val">Ltrs</span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl">
									  Fuel Saved
								   </div>
								</div>
								
															
								<div class="col-sm-6 col-md-2 col-lg-2"  style="border-right: 1px solid #aaa;padding-left:5%">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_costsavingperday.png" style="margin-left:30%"><br>
									  <span class="counter factor_val digital_font">37,179</span>
									  <span class="factor_val">INR</span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl">
									  Fuel Cost Saved
								   </div>
								</div>
								
								<div class="col-sm-6 col-md-2 col-lg-2"  style="padding-left:5%">
								   <div class="col-sm-12 col-md-12 col-lg-12">
									  <img src="../../Telematics4uApp/assets/EESL/images/Icon_co2reduction.png" style="margin-left:30%"><br>
									  <span class="counter factor_val digital_font">37,179</span>
									  <span class="factor_val">CO<sub>2</span>
								   </div>
								   <div class="col-sm-12 col-md-12 col-lg-12 factor_lbl">
									  CO2 Reduction
								   </div>
								</div>
								<div class="col-sm-12 col-md-3 col-lg-3" ></div>
								</div>
								                                  
									
									
                                </div>   
								
								<div class="col-sm-12 col-md-12 col-lg-12" >
										<div class="col-sm-12 col-md-3 col-lg-3" ></div>
										<div class="col-sm-12 col-md-6 col-lg-6" >
										
										<div id="map_img_india">
                                    <div class="outer_div">
                                                <span class="map_numbers value_delhi">
<!--                                                    <a data-tooltip="Click here" class="state-value tooltip-font inline" href="#" style="color: #003658;font-size: 19px;font-weight: 500;">-->
                                                        <span class="counter digital-font" style="display: inline-block;" id="delhiId">0</span>
<!--                                                    </a>-->
                                                </span>
                                                <span class="value_delhi_state">
                                                    <a  class="state-names inline" href="#" style="color: #003658;font-size: 19px;font-weight: 500;">Delhi</a>
                                                </span>
                                    </div>
                                </div>
								</div>
										<div class="col-sm-12 col-md-3 col-lg-3" ></div>
								</div>		

								
								</div>  <!-- end of 3rd row : image and number panel -->
 
<div class="col-sm-12 col-md-12 col-lg-12" style="padding:20px;background-color:#cceafd;">
   <div class="col-sm-12 col-md-12 col-lg-12" style="padding-bottom:10px;"><span class="footer_title">Zone Wise Distribution Counts</span></div>
   <div class="col-sm-12 col-md-12 col-lg-12 row" >
       <div class="col-xm-6 col-md-2 col-lg-2 AgencyBox BpclAgencyBox" align="center">
         <span class="digital-font counter" id="northId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> North </span>
      </div>
	  <div class="col-xm-6 col-md-2 col-lg-2 AgencyBox HpclAgencyBox" align="center">
         <span class="digital-font counter" id="southId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> South </span>
      </div>
	  <div class="col-xm-6 col-md-2 col-lg-2 AgencyBox IoclAgencyBox" align="center">
         <span class="digital-font counter" id="eastId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> East </span>
      </div>
	  <div class="col-xm-6 col-md-2 col-lg-2 AgencyBox CscAgencyBox" align="center">
         <span class="digital-font counter" id="westId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> West </span>
      </div>
	  <div class="col-xm-6 col-md-2 col-lg-2 AgencyBox DopAgencyBox" align="center">
         <span class="digital-font counter" id="centerId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> Centeral </span>
      </div>
	  <div class="col-xm-6 col-md-2 col-lg-2 AgencyBox OtherAgencyBox" align="center">
         <span class="digital-font counter" id="totalId">0</span><br>
         <hr class="AgencyDivider">
         <span class="AgencyName"> Total </span>
      </div>
      
   </div>
</div>
<div class="col-sm-12 col-md-12 col-lg-12" style="margin-top:1%;">
<div class="col-sm-12 col-md-2 col-lg-2" style="    border: 2px solid #0189b7;;
    padding: 0px;
    border-radius: 15px;
    background-color: #fff;margin-left: 40%;cursor: pointer;" ><img src="../../Telematics4uApp/assets/EESL/images/ecar.png" style="margin-left: 6%;">

</div>
<div class="col-sm-12 col-md-12 col-lg-12" style=" padding-left: 44%;
    font-weight: 500;
     font-family: sans-serif;
    color: #fff;">About E-Vehicle</div>
								
							</div>
								
							</div>
								
							<!-- </div> -->
						</div>  <!-- end of main panel -->
                    </div>
                 

     
       
<script>
var path=window.location.pathname;
var url=window.location.href;
var link = url.replace(path,''); /// redirectPath
var extenstion="/t4u/eesl";
function login(){
window.open(link+extenstion, '_blank');
}
setTimeout(function() {
    window.location.reload(1);
}, 20000);

 var eeslDetails;
function loadData() {
    var z1 = 0;
    var z2 = 0;
    var z3 = 0;
    var z4 = 0;
    var z5 = 0;
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/PublicViewAction.do?param=getDashBoardDetails',

        success: function(result) {
            eeslDetails = JSON.parse(result);
            var j = 0;
            for (var i = 0; i < eeslDetails["Details"].length; i++) {
                var regNO = eeslDetails["Details"][i].RegNo;
                var lat = eeslDetails["Details"][i].lat;
                var lng = eeslDetails["Details"][i].lng;
                var zone = eeslDetails["Details"][i].zone;

                <!---->
                <!-- switch(zone) {-->
                <!--    			case 5:-->
                <!--        		  document.getElementById("zone5").innerHTML=++z5;-->
                <!--       			 break;-->
                <!--				 case 1:-->
                <!--        		  document.getElementById("zone1").innerHTML=++z1;-->
                <!--       			 break;-->
                <!--				 case 2:-->
                <!--        		  document.getElementById("zone2").innerHTML=++z2;-->
                <!--       			 break;-->
                <!--				 case 3:-->
                <!--        		  document.getElementById("zone3").innerHTML=++z3;-->
                <!--       			 break;-->
                <!--				 case 4:-->
                <!--        		  document.getElementById("zone4").innerHTML=++z4;-->
                <!--       			 break;-->
                <!--    -->
                <!--    default:-->
                <!--       // code block-->
                <!--}-->

                document.getElementById("ecount").innerHTML = eeslDetails["Details"].length;
                j = i + 1;
                document.getElementById("ecount").innerHTML = eeslDetails["Details"].length;
                document.getElementById("northId").innerHTML = j;
                document.getElementById("southId").innerHTML = '0';
                document.getElementById("eastId").innerHTML = '0';
                document.getElementById("westId").innerHTML = '0';
                document.getElementById("centerId").innerHTML = '0';
                document.getElementById("totalId").innerHTML = eeslDetails["Details"].length;
                document.getElementById("totalId").innerHTML = eeslDetails["Details"].length;
                document.getElementById("delhiId").innerHTML = eeslDetails["Details"].length;


            }


        }
    }).done(function() { //use this
        callRunner();
        document.getElementById('ecount').innerHTML = pad(eeslDetails["Details"].length,5);
    });
    //  setTimeout(callRunner, 2000);


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
        
   </script>
  </body>
</html>
