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
     width: 80px;
     padding:2px 0px;	 
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
  padding:4px 0px 4px 0px;
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
	height: 110px;
}

.toolTipClass{
	 background-color: yellow
}
.required:after {
    content:" *";
    color: red;
  }

      </style>

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>


      <!-- content -->
<div class="panel panel-primary" style="margin-top: -10px;">

    <div class="panel-heading">
        <h3 class="panel-title">
			MAP VIEW SETTING
		</h3>
    </div>
    <div class="modal-body" style="margin-top:8px;height: 80vh; overflow-y: auto;padding:0px;">

        <div class="row">
            <div class="col-lg-2" style="padding-left:40px;"><strong>Alert Type:</strong></div>
            <div class="col-lg-2" required><strong>Duration(hh:mm):</strong><span class="required"></span></div>
            <div class="col-lg-2" required><strong>Region:</strong><span class="required"></span></div>
            <div class="col-lg-2" required><strong>Colour:</strong><span class="required"></span></div>
            <div class="col-lg-1"><strong>Blink:</strong></div>
            <div class="col-lg-2 dispNone" id="blinkDiv" required><strong>Blink Duration(hh:mm):</strong><span class="required"></span></div>
			<div class="col-lg-1"> </div>

        </div>
		<hr style="margin:8px"/>
        <div class="row">

            <div class="col-lg-2" style="padding-left:40px;">
                <select id="alertType" name="alertType">
                    <option value="Stop">Stop</option>
                    <option value="Idle">Idle</option>
                </select>
            </div>
            <div class="col-lg-2"><input type="text" id="duration" style="width:100px;"/></div>
            <div class="col-lg-2">
                <select id="region" name="region">
                    <option value="STOP">Select Region</option>
                    <option value="STOP">Dubai</option>
                    <option value="IDLE">Bahrain</option>
                    <option value="IDLE">Kuwait</option>
                </select>
            </div>
            <div class="col-lg-2">
                <select id="iconcolor" name="iconcolor">
				 <option value="">Select colour</option>
                    <option value="RED">Red</option>
                    <option value="YELLOW">Yellow</option>
                </select>
            </div>
            <div class="col-lg-1"><input type="checkbox" id="blink" /></div>
            <div class="col-lg-2"><input type="text" class="dispNone" style="width:100px;" id="blinkDuration"/></div>
				
			<div class="col-lg-1"><input type="button" id="ADD" value="ADD" onclick="showAlertSettingTable()" /></div>

        </div>
		<hr style="margin:8px"/>
        

        <div class="row">
            <div class="col-lg-12" style="padding-top:8px;">
                <table id="mapViewSettingTable" class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Alert Type</th>
                            <th>Duration(hh:mm)</th>
                            <th>Region</th>
                            <th>Colour</th>
                            <th>Blink</th>
                            <th id="removeSetting">Remove</th>
                            <th>hubId</th>
                            <th>Blink Duration(hh:mm)</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
    <button type="reset" id="saveSetting" class="btn btn-success btnScreen" onclick="saveMapViewSetting()">Save</button>
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
	var mapViewSettingTable;
	var hhmmpattern = /^([01]\d|2[0-3]):?([0-5]\d)$/;
	
    $( document ).ready(function() {
        $.ajax({
        url : '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getMapViewSetting',
		type: 'GET',
        success: function(result) {
			results = JSON.parse(result);
			console.log(result);
			loadAlertSettingTable(results["mapViewSettingRoot"]);
			for(i =0; i <results["mapViewSettingRoot"].length;i++){
				mapSettings.push(results["mapViewSettingRoot"][i]);
			}				
          }
		}); 		 
    });
 
	  $('#blink').change(function() {
		 $("#blinkDuration").val("");
	if($('#blink').is(":checked")){
		$("#blinkDiv").removeClass("dispNone");
		$("#blinkDuration").removeClass("dispNone");

	  }else{
	  $("#blinkDiv").addClass("dispNone");
      $("#blinkDuration").addClass("dispNone");
	  }
	  })


	function btnMapViewSetting(){
		 $('#mapViewSettingModal').modal('show');
	}
	 function getRegions() {
        $.ajax({
            url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByOperationId',
            data:{
            	hubType : 42 //TODO read this from trip configuration
            },
            success: function(result) {
            $("#region").empty().select2();
	            hubList = JSON.parse(result);
				$('#region').append($("<option></option>").attr("value", 0).text("Select Region"));
                for (var i = 0; i < hubList["hubDetailsRoot"].length; i++) {
                    $('#region').append($("<option></option>").attr("value", hubList["hubDetailsRoot"][i].hubid).attr("latitude", hubList["hubDetailsRoot"][i].latitude)
                        .attr("longitude", hubList["hubDetailsRoot"][i].longitude).attr("radius", hubList["hubDetailsRoot"][i].radius).attr("detention", hubList["hubDetailsRoot"][i].standard_Duration).attr("hubAddress",
                        hubList["hubDetailsRoot"][i].address).text(hubList["hubDetailsRoot"][i].name));
                }

            }
        });
    }
     function showAlertSettingTable(){
		 if($("#duration").val()===""){
			sweetAlert("Duration is mandantory");
			return; }
			
		if(!hhmmpattern.test($("#duration").val())){
			sweetAlert("Duration in hh:mm format");
			return;
		}

		if($('#region option:selected').attr("value") == 0){
			sweetAlert("Region is mandantory");
			return; }			
		
		if($("#iconcolor").val()===""){
			sweetAlert("Colour is mandantory");
			return; 
		}
	
		if($('#blink').is(":checked")){
			if($("#blinkDuration").val()===""){
				sweetAlert("Blink Duration is mandantory");
				return;
          	}else if(($("#blinkDuration").val())< ($("#duration").val()) || ($("#blinkDuration").val())=== ($("#duration").val())){
				sweetAlert("Blink Duration Should be greaterthan Duration");
				return;
          	}
			
			if(!hhmmpattern.test($("#blinkDuration").val())){
			sweetAlert("Blink Duration in hh:mm format");
			return;
		}
		}
		let data = $('#mapViewSettingTable').DataTable().rows().data();
		let duplicate = false;
		data.each(function (value, index) {
			   let selectedAlertType = value[1];
			   let selectedHub = value[7];
			  if(($('#region option:selected').attr("value") == selectedHub) && ($("#alertType").val() == selectedAlertType)){
				  duplicate = true;
				  return;
			  }
			});
			
			if (duplicate){
				sweetAlert("Duplicate entry for selected alert type and region");
				return;
			}
		 var settingDataTable = $('#mapViewSettingTable').DataTable();
				let rows = [];
				let hubId=$('#region option:selected').attr("value");
				let row = {
                         "0":rows.length+1,
                         "1":$('#alertType option:selected').text(),
                         "2":$('#duration').val(),
                         "3": $('#region option:selected').text(),
                         "4": $('#iconcolor option:selected').text(),
                         "5": ($('#blink:checked').val() == 'on')?'Y':'N',
                         "6":'<i style="cursor:pointer;" onclick="deleteRow('+hubId+')" class="far fa-window-close"></i>',
						 "7":$('#region option:selected').attr("value"),
						 "8": $('#blinkDuration').val()
                    }
					
					rows.push(row);
					
				//settingDataTable.rows.add(rows).draw();
				alertSettingJson = {
					alertType : $('#alertType option:selected').text(),
					duration : $('#duration').val(),
					region : $('#region option:selected').text(),
					hubId : $('#region option:selected').attr("value"),
					iconColour : $('#iconcolor option:selected').text(), 
					blink : ($('#blink:checked').val() == 'on')?'Y':'N',
				    blinkDuration : $('#blinkDuration').val()
				};
				mapSettings.push(alertSettingJson);
				console.log(alertSettingJson);
				loadAlertSettingTable(mapSettings);
				
				 $("#blinkDuration").val("");
	 }
	 function loadAlertSettingTable(result){
               let rows = [];
                $.each(result, function(i, item) {
                   let row = {
                         "0":i+1,
                         "1":item.alertType,
                         "2":item.duration,
                         "3":item.region,
                         "4":item.iconColour,
                         "5":item.blink,
                         "6":'<i style="cursor:pointer;" onclick="deleteRow('+item.hubId+')" class="far fa-window-close"></i>',
						 "7":item.hubId,
						 "8":item.blinkDuration
                    }
                    rows.push(row);
                  })

                  if ($.fn.DataTable.isDataTable("#mapViewSettingTable")) {
					  $('#mapViewSettingTable').DataTable().clear().destroy();
                  }
                  mapViewSettingTable = $('#mapViewSettingTable').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });
                  mapViewSettingTable.rows.add(rows).draw();
				  mapViewSettingTable.column(7).visible( false );
    }
 function saveMapViewSetting(){
		var saveMapViewArray = [];
		var param = {};
		var data = mapViewSettingTable.rows().data();
		 data.each(function (value, index) {
			  var node = {
				alertType : value[1],
				duration : value[2],
				iconColour :value[4] ,
				blink: value[5]	,
				hubId : value[7],
				blinkDuration: value[8]== "" ? '0:0' : value[8],
				
			  }	
			saveMapViewArray.push(node);			  
		 });
		 var param = {
			mapViewSettings : JSON.stringify(saveMapViewArray),
		}
	$.ajax({
        url : '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=saveMapViewSetting',
        data: param,
		type: 'POST',
        success: function(result) {
        	sweetAlert(result);
        }
	}); 
	 console.log(saveMapViewArray);
 }
	
	getRegions();
	
	function deleteRow(hubId){
		//mapViewSettingTable.row(index).remove().draw();
		
	  $.each(mapSettings, function(i, item) {
       if(typeof item !== 'undefined')
       {
         if(item.hubId == hubId)
         {
           mapSettings.splice(i,1);
           loadAlertSettingTable(mapSettings);
         }
        }
      })
		return;
	}
	

</script>

  <jsp:include page="../Common/footer.jsp" />
