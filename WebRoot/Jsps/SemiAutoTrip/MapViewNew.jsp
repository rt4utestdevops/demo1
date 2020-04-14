<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
    int customerId = loginInfo.getCustomerId();
    int userId =loginInfo.getUserId();
    String username = loginInfo.getUserName();
    String countryName = cf.getCountryName(countryId);
    Properties properties = ApplicationListener.prop;
    String vehicleImagePath = properties.getProperty("vehicleImagePath");
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
	MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
	String mapName = bean.getMapName();
	String appKey = bean.getAPIKey();
	String appCode = bean.getAppCode();
	
	String roleModuleAPIurl = "";
	try{
		roleModuleAPIurl = properties.getProperty("roleModuleAPIAddress").trim();
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<jsp:include page="../Common/header.jsp" />
<jsp:include page="../Common/InitializeLeaflet.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
      <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      <link href="../../Main/custom.css" rel="stylesheet" type="text/css">
      <link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">

      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
      <script src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl" crossorigin="anonymous"></script>

      <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
      <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>

      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
      <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
     
	  
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
      <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
      <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
	  
	  
	 <link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
	 <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	<script src="../../Main/leaflet/leaflet-draw/js/Leaflet.fullscreen.min.js"></script>
	<link rel="stylesheet" href="../../Main/leaflet/leaflet-draw/css/leaflet.fullscreen.css" /> 
	
 	<script src="../../Main/leaflet/leaflet-draw/js/leaflet.markercluster.js"></script>
	<link rel="stylesheet" href="../../Main/leaflet/leaflet-draw/css/MarkerCluster.css" />
	<link rel="stylesheet" href="../../Main/leaflet/leaflet-draw/css/MarkerCluster.Default.css" />  
	
	<link  href="https://unpkg.com/leaflet-geosearch@latest/assets/css/leaflet.css" rel="stylesheet" />
	<script src="https://unpkg.com/leaflet-geosearch@latest/dist/bundle.min.js"></script>
	<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	<script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	<link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
 integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
 crossorigin=""></script>
	 
	 <style>
	 
	 .labels {
     color: black;
	 border:1px solid black;
     background: yellow;
     font-family: "Lucida Grande", "Arial", sans-serif;
     font-size: 14px;
	 font-weight:bold;
     text-align: center; 
     width: fit-content;
     padding:2px 8px;	 
     white-space: nowrap;
   }


		.form-control {
            display: block;
            width: 100%;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #aaa;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        }

        .enroutecard{
            border: 0.5px solid;
            height: 146px;
            width: 17% !important;
            margin-left: 8px;

        }
        .middleCard{
            width: 20.7% !important;
            border: 1px solid;
            height: 146px;
            margin-left: 6px;

        }
        .inner-row{
            border: 1px solid;
            height: 65px;
            margin-top: -2px;
        }
        .inner-text{
            margin-top: -7px;
            font-size: 10px !important;
        }
        #tripSumaryTable_wrapper {
            padding: 8px 0px 0px 0px;
         }

         #tripSumaryTable_filter{
           margin-top:-32px;
         }
         .dataTables_scroll{
            overflow:auto;
         }

        .modal {
            position: fixed;
            top: 2%;
            left: 5%;
            z-index: 10500;
            width: 88%;
            bottom:unset;
            background-color: #ffffff;
            border: 1px solid #999;
            border: 1px solid rgba(0, 0, 0, 0.3);
            -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
            -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
            -webkit-background-clip: padding-box;
            -moz-background-clip: padding-box;
            background-clip: padding-box;
            outline: none;
            border-radius:4px;
            overflow-y:auto;
        }
          #alertEventsTable_filter{
         padding-left: 99px;
         padding-top: 10px;
         }
         #alertEventsTable_length{
         padding-top: 12px;
         }
         .panel-primary {
            border:none !important;
            margin-top: 0px;
        }
        .nav-tabs {
            border-bottom: 1px dotted black;
            height:32px;
        }
        .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {
            color: #555;
            cursor: default;
            background-color: #fff;
            border: 1px dotted black;
            border-bottom-color: transparent;
            height:32px;
            padding-top:4px;
        }

        .modal-content .modal-body {
            padding-top: 24px;
            padding-right: 24px;
            padding-bottom: 16px;
            padding-left: 24px;
            overflow-y: auto;
            max-height: 400px;
        }
        .modal-open .modal {
            overflow-x: hidden;
            overflow-y: hidden;
        }

         td.details-control {
		   background: url('../../Main/images/details_open.png') no-repeat center center;
		   cursor: pointer;
		}
		tr.shown td.details-control {
		   background: url('../../Main/images/details_close.png') no-repeat center center;
		}

		.sweet-alert button.cancel
		{
			background-color: #d9534f !important;
		}

		.sweet-alert button
		{
	 		background-color: #5cb85c !important;
		}


   .card {
                box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
                padding: 10px;
                margin-bottom:16px;
                border-radius:4px !important;
                }
                .cardSmall {
                  box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
                  transition: all 0.3s cubic-bezier(.25,.8,.25,1);


               }

                 .caret {display: none;}

                /* @media only screen and (min-width: 768px) {
                   .card {height:160px;}
                 }*/
                 .row {margin-right:0px !important;margin:auto;width:100%;margin-top:0px;}
                 .col-md-4{padding:0px;}
                 .col-sm-2, .col-sm-1, .col-sm-4, .col-md-2, .col-md-1, .col-lg-2, .col-lg-1,.col-lg-12{padding: 0px;}

     .inner-row-card{border-top:1px solid black !important;}
     .inner-row-card .col-md-4 {margin-top:16px;padding:1px;}
     .outer-count{
        text-align: center;

     }

     .outer-count p {
        font-size: 12px;
     }

     .outer-count h3 {
        font-size: 18px;
     }

     .main-count{ margin-top: 20px;
      margin-bottom: 10px;}

      .padTop{
        padding-top:10px;
      }

      .col-md-12 {
      padding: 0px;
}

#tripWise .col-sm-12 {padding: 0px;}
.col-sm-12 {padding: 0px;}
#viewBtn {height: 28px;
    padding-top: 3px;}
    .purple {
                background: #8D33AA ;

              }

              .green {
                background: #00897B ;

              }

              .orange {
                background: #E9681B;

              }

              .blueWater {
            /*  background: #7CC7DF;*/
          background: #B0BEC5;}

              .blue {
                background: #00A1DE;

              }

              .brick {
                background: #C83131;

              }

              .red {
                background: #D32F2F;
              }

              .mustard {
                background: #EABC00;

              }

              .blueGrey {
              /*background: #607D8B*/
            background: #37474F;}
              .blueGreyLight {background: #ECEFF1;}

              .purpleFont {
                color: #8D33AA ;
              }

              .greenFont {
                color: #00897B ;
              }

              .orangeFont {
                color: #E9681B;
              }

              .whiteFont { color:#ffffff;}


              .blueFont {
                color: #00A1DE;
              }

              .brickFont {
                color: #C83131;
              }




              .mustardFont {
                color: #EABC00;
              }

              .headerText {
                text-align:left; color: white;
                padding:8px 4px 8px 0px;
              }


              .centerText {
                text-align:center;
                position: relative;
                cursor:pointer;
                float: left;
                top: 50%;
                left: 50%;
                font-size:16px;
                transform: translate(-50%, -50%);
              }


              .close {
                    float:right;
                    display:inline-block;
                    padding:0px 12px 0px 8px;
              }
.close:hover { cursor:pointer;}

.left { padding: 8px 16px 8px 16px; width:100%;}
.right { float:right;}
.right:hover { text-decoration: underline; cursor:pointer;}

.imageOpen {float: right;padding: 8px 12px 8px 8px;}

#midColumn{
    -webkit-transition: all 0.5s ease;
    -moz-transition: all 0.5s ease;
    -o-transition: all 0.5s ease;
    transition: all 0.5s ease;
}

.col-lg-4{padding: 8px;margin:0px;}
.col-lg-8,.col-lg-6{padding: 8px;margin:0px;}

.center-view{
  top:40%;
  left:50%;
  position:fixed;
  height:200px;
  width:200px;

}

.highlightText{
  text-align: center;
  padding: 2px 0px 2px 0px;
  min-height:24px;
  cursor:pointer;
}

.highlightRow{
  width: 30%;
  float:right;
}

.highlightRowLeft{
  width: 45%;
  float:left;
}

.infoDiv td {
  padding:10px 0px 5px 0px;
  vertical-align: top;
  line-height:12px;
}

#legend {
       background: #fff;
       padding: 10px;
       margin: 10px;
       border: 1px solid #37474F;
     }
     #legend h3 {
       margin-top: 0;
       font-size:16px !important;
     }
     #legend img {
       vertical-align: middle;
     }

     .paddingLeft16
     {
       padding-left:16px;
     }

.select2 {
  width:180px !important;
}

.blueGreyDark {
  /* background: #ECEFF1; */
  background: #37474F;
}

.pointer{
  cursor: pointer;
}

body {
  font-size:18px !important;
  font-family: "Tahoma", Geneva,  sans-serif !important;
}

.redStatus{
  /* background: #EF5350; */
  color:#FF1744;
}

.orangeStatus{
 /* background:#FFB74D; */
 color:#FF6F00;
 background:#ECEFF1;
}

.greenStatus{
  /* background: #4CAF50; */
  color:#1B5E20;
}

/* width */
::-webkit-scrollbar {
    width: 8px;

}

/* Track */
::-webkit-scrollbar-track {
    background: #f1f1f1;
       border-radius:8px
}

/* Handle */
::-webkit-scrollbar-thumb {
    background: #888;
       border-radius:8px
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background: #555;
}

.btnScreen{
  width:140px;font-size: 18px;padding-top: 2px;height:32px;border:0px;
}

.createTrip{
  font-size: 16px !important;
  min-height:500px !important;
  font-family: "Tahoma", Geneva,  sans-serif !important;
}

.redBorder{
	border:1px solid red !important;
}

.dispNone{
  display:none;
}

.red {
  color:red;
  background:white;
}

.highlight{
  color:white !important;
  background: #00A0D6 !important;
}

.leaflet-popup-content-wrapper{
	height: 185px;
}

.toolTipClass{
	 background-color: yellow
}

@keyframes fade {
  from { opacity: 0; }
}

.blinking {
  animation: fade .25s infinite alternate;
}

      </style>

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>


      <!-- content -->
<div class="panel panel-primary" style="margin-top: -10px;">
      
	<div class="panel-heading">
	<div class="row">
		<div class="col-md-3">
			<h3 class="panel-title" style="float: left;margin-right:10px">
			Jotun Smart Delivery System (JSDS)
		</h3>
		</div>
		<div class="col-md-9 dispNone" id="regionDiv">
			<select id="regionDropDownId"  onChange="onRegionChanges()" name="regionDropDownNames" multiple="multiple" class="input-s">
            
          </select>
		</div>
	</div> 
	</div>      
      <div class="row" style="margin-bottom:5px;margin-left:8px;margin-top: 15px;">
        <div class="col-md-4" style="padding:0px;">
          <select id="statusDropDownId" name="selectStatus">
            <option value="ALL">All</option>
            <option value="AVAILABLE">Available</option>
            <option value="ON_TRIP">On Trip</option>
            <option value="TRIP_ASSIGNED">Trip Assigned</option>
            <option value="AT_BORDER">At Border</option>
            <option value="STOPPED">Stopped</option>
          </select>
        </div>
		 <div class="col-md-4" style="padding:0px;">
        </div>
       </div>
       <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
       
</div>
     <div id="mapViewSettingModal" class="modal fade createTrip">
             <div class="row blueGreyDark" style="border-radius: 4px;width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
               <div  class="col-md-6">
                  <h4 id="mapviewettingTitle" class="modal-title" style="text-align:left; margin-left:10px;color:white;">MAP VIEW SETTING</h4>
               </div>
                <div class="col-md-6" style="text-align:right;padding-right:24px;">
                   <button type="button" class="close" style="align:right;cursor:pointer;color:white;" data-dismiss="modal">&times;</button>
                </div>
             </div>
             <div class="modal-body" style="margin-top:8px;height: 80vh; overflow-y: auto;padding:0px;">
               <div class="row" style="padding:16px 16px 16px 24px">
                    <div class="col-lg-4" style="padding:0px;"><strong>Alert Type:</strong>&nbsp;&nbsp;&nbsp;
                    <select id="alertType" name="alertType">
						<option value="STOP">Stop</option>
						<option value="IDLE">Idle</option>
                    </select>
                    </div>
                    <div class="col-lg-4" style="padding:0px;">
                       <strong>Duration(hh:mm):</strong>&nbsp;&nbsp;&nbsp;
                        <input type="text" id ="duration"></input>
                    </div>
                    <div class="col-lg-4" style="padding:0px;">
                       <strong>Region:</strong>&nbsp;&nbsp;&nbsp;
                       <select id="region" name="region">
							<option value="STOP">--Select Region--</option>
							<option value="STOP">Dubai</option>
							<option value="IDLE">Bahrain</option>
							<option value="IDLE">Kuwait</option>
                       </select>

                     </div>
               </div>
               <hr style="margin:8px"/>

               <div class="row" style="padding:16px 16px 0px 16px">
                 <div class="col-lg-3" style="padding:0px;" id="nameDiv">
				  <strong>Colour:</strong>&nbsp;&nbsp;&nbsp;
                   <select id="iconcolor" name="iconcolor" >
						<option value="RED">Red</option>
						<option value="YELLOW">Yellow</option>
                   </select>
                   <div id="iconcolorDiv" class="dispNone"><span class="red">* Required</span>
                   </div>
                 </div>
                 <div class="col-lg-3" style="padding:0px;" id="locationDiv">
				  <strong>Blink</strong>&nbsp;&nbsp;&nbsp;
                   <input type="checkbox" id="blink"></input>
                   <div id="blinkDev" class="dispNone"><span class="red">* Required</span>
                   </div>
                 </div>
                     <div class="col-lg-6"  style="padding:0px">
					 <input type="button" id="ADD" value="ADD" onclick="loadAlertSettingTable()"/></div>

               </div>
               <div class="row">
                     <div class="col-lg-12" style="padding-top:8px;" >
                        <table id="mapViewSettingTable"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                           <thead>
                              <tr>
                                <th>Sl No</th>
                               <th>Alert Type</th>
                               <th>Duration(HH:mm)</th>
                               <th>Region</th>
                               <th>Colour</th>
                               <th>Blink</th>
                               <th id="removeSetting">Remove</th>
                              </tr>
                           </thead>
                        </table>
                     </div>
               </div>
             </div>
             <div class="modal-footer"  style="text-align: right; height:52px;" >
                <button type="reset" id="saveSetting" class="btn btn-success btnScreen" onclick="saveMapViewSetting()">Save</button>
                <button type="reset" onclick="discard()" class="btn btn-danger btnScreen">Discard</button>
             </div>
      </div>

 
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>

var status = 0;
var noncommveh = false;
var unassignedVehtype = "";
var data;
var scanJSONCreate = [];
var scanJSONClose = [];
var deliveryPointsArray = [];
var ackJSONTable = [];
var markerCluster;

      var map;
      var info;
      var initial = true;
      var tripType = "create";
    var mcOptions = {
        gridSize: 20,
        maxZoom: 100
    };
    var markerClusterArray = [];
    var markerClusterArray1 = [];
    var animate = "true";
    var bounds;
    var infowindow;
    var infowindowOne;
    var mapNew;
    var lineInfo = [];
    var infoWindows = [];
    var $mpContainer = $('#map');
    var tripStatus = "available";
	var layerGroup;
	var mapSettings = [];
    $( document ).ready(function() {
        $("#map").css("height", $(window).height()-200);
        var heightVal = ($("#map").height())/1.8;
        $("#columnContainer").css("height", $(window).height()-200);
		 checkAccess();
		 getRegions();
    });

    setInterval(function() { 
		loadMap($('#statusDropDownId').val());
    }, 180000);


$('#statusDropDownId').on('change', function (e) {
	
	 loadMap($('#statusDropDownId').val());
 })
 
  initialize("map",new L.LatLng('25.2048', '55.2708'),'<%=mapName%>', '<%=appKey%>', '<%=appCode%>');
   setTimeout(function(){map.invalidateSize();map.setView(new  L.LatLng('25.2048', '55.2708'),8);layerGroup = new L.LayerGroup().addTo(map)},100);

 function loadMap(tripStatusIn) {
		 
		if(layerGroup != undefined){
			layerGroup.clearLayers();
		}
		
		var arr = [];
		$("#regionDropDownId > option:selected").each(function(){
		   arr.push(this.value);
		});
		var regionsId="";
		if(arr.length==0)
			 regionsId="0";
		 else
		 regionsId= arr.join(', ');

		
		//markerCluster = L.markerClusterGroup();
	//layerGroup.eachLayer(function (layer) { alert(layer); });
  	  if(tripStatusIn == "ALL"){
        tripStatus = "ALL";
      }else if(tripStatusIn == "AVAILABLE"){
        tripStatus = "available";
      }else if(tripStatusIn == "ON_TRIP"){
         tripStatus = "onTrip";
      }else if(tripStatusIn == "TRIP_ASSIGNED"){
        tripStatus = "tripAssigned";
      }
      else if(tripStatusIn=="AT_BORDER")
      {
      	 tripStatus = "atBorder";
      }
      else if(tripStatusIn=="STOPPED")
      {
      	 tripStatus = "stopped";
      }
      
        $.ajax({
          url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getJotunVehiclesMapDetails&regionsId='+regionsId,
             data: {
                   statusId: tripStatus,
               },
            "dataSrc": "MapViewIndex",
            success: function(result) {
                bounds = new L.LatLngBounds();
                results = JSON.parse(result);
                console.log(results);
                truckJSON = results["MapViewIndex"];
                var count = 0;
                // markerClusterArray.length=0;
                // if (markerCluster) {
                    // markerCluster.clearMarkers();
                // }
                for (var i = 0; i < results["MapViewIndex"].length; i++) {
                    if (!results["MapViewIndex"][i].lat == 0 && !results["MapViewIndex"][i].lon == 0) {
                        count++;
                          plotSingleVehicle(results["MapViewIndex"][i].vehicleNo, results["MapViewIndex"][i].lat, results["MapViewIndex"][i].lon,
                            results["MapViewIndex"][i].location,results["MapViewIndex"][i].direction, results["MapViewIndex"][i].driverName,
                            results["MapViewIndex"][i].etaSourceHub,results["MapViewIndex"][i].status,results["MapViewIndex"][i].etaSourceHubMin,results["MapViewIndex"][i].iconColour,results["MapViewIndex"][i].blink,results["MapViewIndex"][i].duration,results["MapViewIndex"][i].category);
                        var mylatLong = new L.LatLng(results["MapViewIndex"][i].lat, results["MapViewIndex"][i].lon);
                    }
                }
			//	map.addLayer(markerCluster);
			map.fitBounds(bounds);
               // markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
				 
            }
        });
    }
    var buffer_circle = null;
	var counter = 0;
  

    function btnGo()
    {
      buffer_circle = new L.Circle({
          center: {lat: 19.076000213623047, lng: 72.87770080566406},
          radius: 7000,
          strokeColor: "",
          strokeOpacity: 0.0,
          strokeWeight: 2,
          fillColor: "#FFD700",
          fillOpacity: 0.5,
          map: map
      });
      map.setCenter({lat: 19.076000213623047, lng: 72.87770080566406});
      map.setZoom(12);
    }
    //initialize();
	
	
    loadMap("ALL");

    function plotSingleVehicle(vehicleNo, latitude, longtitude, location,direction, driverName,
								etaSourceHub,tripStatus,etaSourceHubMin,iconColour,blink,duration,category) {
        var tempContent='';
        var humidityContent='';
        var Humidity;
        var imageurl = '/ApplicationImages/VehicleImages/delivery-van-blue-new.png';
		if(iconColour == "Red"){
			imageurl = '/ApplicationImages/VehicleImages/delivery-van-red-new.png';
		}else if(iconColour == "Yellow"){
			imageurl = '/ApplicationImages/VehicleImages/delivery-van-yellow-new.png';
		}else{
			if(tripStatus == "available" && etaSourceHubMin <= 30)
			{
			  imageurl = '/ApplicationImages/VehicleImages/delivery-van-black-new.png';
			}
			if(tripStatus == "available" && etaSourceHubMin > 30)
			{
			  imageurl = '/ApplicationImages/VehicleImages/delivery-van-grey-new.png';
			}
			if(tripStatus == "onTrip"){
				imageurl = '/ApplicationImages/VehicleImages/delivery-van-green-new.png';
			}
			if(tripStatus == "stopped")
			{
				imageurl = '/ApplicationImages/VehicleImages/delivery-van-red-new.png';
			}
		}
		image = L.icon({
            iconUrl: imageurl,
            iconSize: [25, 40], // size of the icon
            popupAnchor: [0, -15],
			className : (blink == "Y") ?'blinking':""
        });
        var pos = new L.LatLng(latitude, longtitude);
         
       // markerClusterArray.push(marker);
        var coordinate=latitude+','+longtitude;

		var eatSourceHtml = '';
		if(typeof etaSourceHub !== 'undefined' && etaSourceHub !=""){
			eatSourceHtml = '<tr><td nowrap><b>ETA to HQ:&nbsp;&nbsp;</b></td><td>' + etaSourceHub + ' (HH:MM) </td></tr>' ;
		}
        // alert(shipmentId);
        var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; height: 100%; float: left; color: #000; line-height:100%; font-size:11px; font-family: "Tahoma", Geneva,  sans-serif !important;padding:4px;">' +
            '<table class="infoDiv">' +
            '<tr><td nowrap><b>Vehicle No:&nbsp;&nbsp;</b></td><td>' + vehicleNo + '</td></tr>' +
            '<tr><td nowrap><b>Driver Name:&nbsp;&nbsp;</b></td><td>' + driverName + '</td></tr>' +
            '<tr><td nowrap><b>Curr Location:&nbsp;&nbsp;</b></td><td>' + location + '</td></tr>' +
			 '<tr><td nowrap><b>Duration(HH.MM):&nbsp;&nbsp;</b></td><td>' + duration + '</td></tr>' +
			  '<tr><td nowrap><b>Category:&nbsp;&nbsp;</b></td><td>' + category + '</td></tr>' +
            eatSourceHtml +
            '</table>' +
            '</div>';
 

			var marker = L.rotatedMarker(new L.LatLng(latitude, longtitude), {
				icon: image,
				 angle: direction,
                }).bindTooltip(driverName,{permanent: true,direction: 'right',className: 'labels'}).bindPopup(content);
                 
				
				//map.addLayer(marker);
				marker.addTo(layerGroup);
				
				
				marker.on("click", function (e) {
						 firstLoadDetails = 1;
						info = false;
						
						var imageurl = '/ApplicationImages/VehicleImages/delivery-van-blue-new.png';
					    if(iconColour == "Red"){
						   imageurl = '/ApplicationImages/VehicleImages/delivery-van-red-new.png';
					    }else if(iconColour == "Yellow"){
								imageurl = '/ApplicationImages/VehicleImages/delivery-van-yellow-new.png';
							}else{
							if(tripStatus == "available" && etaSourceHubMin <= 30)
							{
							  imageurl = '/ApplicationImages/VehicleImages/delivery-van-black-new.png';
							}
							if(tripStatus == "available" && etaSourceHubMin > 30)
							{
							  imageurl = '/ApplicationImages/VehicleImages/delivery-van-grey-new.png';
							}
							if(tripStatus == "onTrip"){
								imageurl = '/ApplicationImages/VehicleImages/delivery-van-green-new.png';
							}
					    }		
						var markerImage = L.icon({
							iconUrl: imageurl,
							iconSize: [25, 40], // size of the icon
							popupAnchor: [0, -15],
							className : (blink == "Y") ?'blinking':""
						});
						
						e.target.setIcon(markerImage);
						marker._popup.setContent(content);
									
				});


      


        if (animate == "true") {
           // marker.setAnimation(google.maps.Animation.DROP);
        }
        if (location != 'No GPS Device Connected') {
            bounds.extend(pos);
        }

    }
	
	function btnMapViewSetting(){
		 $('#mapViewSettingModal').modal('show');
	}
	function getRegions() {
        $("#region").select2({
	    			dropdownParent: $("#mapViewSettingModal")
				});
		
    }
     function loadAlertSettingTable(){
				alertSettingJson = {
					alertType : $('#alertType option:selected').text(),
					duration : $('#duration').val(),
					region : $('#region option:selected').text(),
					iconColour : $('#iconcolor option:selected').text(),
					blink : $('#blink:checked').val()
				};
				mapSettings.push(alertSettingJson);
				console.log(alertSettingJson);
               var result = mapSettings;
               let rows = [];
                $.each(result, function(i, item) {
                   let row = {
                         "0":i+1,
                         "1":item.alertType,
                         "2":item.duration,
                         "3":item.region,
                         "4":item.iconColour,
                         "5":item.blink,
                         "6":'<i style="cursor:pointer;" onclick="splice(\''+item.scanId+'\')" class="far fa-window-close"></i>'

                    }
                    
                    rows.push(row);
                  })

                  if ($.fn.DataTable.isDataTable("#mapViewSettingTable")) {
                    $(mapViewSettingTable).DataTable().clear().destroy();
                  }
                  table = $('#mapViewSettingTable').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });
                  table.rows.add(rows).draw();
    }

function checkAccess(){
		$.ajax({
          url: '<%= roleModuleAPIurl %>' + 'getRoleByUserId',
          type : 'GET',
		  contentType: 'application/json',
		  data :{  	systemId : <%=systemId%>,
                	customerId : <%=customerId%>,
                	userId : <%=userId%>
                },
          success: function(result) {
					console.log(result);
					if(result.roleType=="0")
					{
						if (result.roleName == "Admin")
							$("#regionDiv").removeClass("dispNone");
					}

				}
			})
		}
		
function onRegionChanges()
	{
		loadMap($('#statusDropDownId').val());
	}		
	
	
	 function getRegions() {
    
      $.ajax({
            url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByOperationId',
            data:{
            	hubType : 42 //TODO read this from trip configuration
            },
            success: function(result) {
          
			
	            regionList = JSON.parse(result);
				
               for (var i = 0; i < regionList["hubDetailsRoot"].length; i++) {
                  
						$('#regionDropDownId').append($("<option></option>").attr("value", regionList["hubDetailsRoot"][i].hubid).attr("latitude", regionList["hubDetailsRoot"][i].latitude)
                        .attr("longitude", regionList["hubDetailsRoot"][i].longitude).attr("radius", regionList["hubDetailsRoot"][i].radius).attr("detention", regionList["hubDetailsRoot"][i].standard_Duration).attr("hubAddress",
                        regionList["hubDetailsRoot"][i].address).text(regionList["hubDetailsRoot"][i].name));
                }
				$('#regionDropDownId').multiselect({
				 buttonWidth: '186px',
				 enableFiltering: true,
				  allSelectedText: 'All',
				  enableCaseInsensitiveFiltering: true,
				  includeSelectAllOption: true,
				  onSelectAll: function () {
				   customerAllSelected= true;
				  }
				  }).multiselect('deselectAll', false)
					.multiselect('updateButtonText');
					

					}
				});
    }
	/*extend leaflet - you should include the polli*/
  L.RotatedMarker = L.Marker.extend({
    options: {
      angle: 0
    },
    _setPos: function (pos) {
      L.Marker.prototype._setPos.call(this, pos);
      if (L.DomUtil.TRANSFORM) {
        // use the CSS transform rule if available
        this._icon.style[L.DomUtil.TRANSFORM] += ' rotate(' + this.options.angle + 'deg)';
      } else if (L.Browser.ie) {
        // fallback for IE6, IE7, IE8
        let rad = this.options.angle * (Math.PI / 180),
          costheta = Math.cos(rad),
          sintheta = Math.sin(rad);
        this._icon.style.filter += ' progid:DXImageTransform.Microsoft.Matrix(sizingMethod=\'auto expand\', M11=' +
          costheta + ', M12=' + (-sintheta) + ', M21=' + sintheta + ', M22=' + costheta + ')';
      }
    }
  });
  L.rotatedMarker = function (pos, options) {
    return new L.RotatedMarker(pos, options);
  };

  /*end leaflet extension*/
</script>

  <jsp:include page="../Common/footer.jsp" />
