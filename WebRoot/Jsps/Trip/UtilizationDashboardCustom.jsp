<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
    String countryName = cf.getCountryName(countryId);
    Properties properties = ApplicationListener.prop;
    String vehicleImagePath = properties.getProperty("vehicleImagePath");
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
    String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
%>
	  <jsp:include page="../Common/header.jsp" />
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
      <script src="../../Main/Js/markerclusterer.js"></script>
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
      <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
      <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
      <style>


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
         .select2-container{
            width: 261px !important;
         }
         .modal {
            position: fixed;
            top: 5%;
            left: 30%;
            z-index: 1050;
            width: 800px;
            margin-left: -280px;
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
        }
        .modal {
            position: fixed;
            top: 5%;
            left: 30%;
            z-index: 1050;
            width: 81%;
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
            overflow-y:hidden;
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
                border-radius:0px !important;
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
                text-align:center; color: white;
                padding:4px 4px 4px 0px;
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
.col-lg-8,.col-lg-6{padding: 0px;margin:0px;}

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
      </style>

      <!-- content -->
      <div class="row" id="columnContainer">
        <div class="col-lg-2" id="leftColumn">
          <div class="row" style="width:100%;" id="box1">
                        <div class="col-lg-12 card">
                          <div class="row" style="height:100%;">
                             <div class="col-lg-12">
                               <div class="centerText" style="padding-top:24px;" id="assigned" title="Assigned vehicles" onclick="onColumnClick(8,false,'')"></div>
                                 <div class="headerText blueGrey"><span style="margin-left:-16px;">Assigned</span></div>
                                 <div class="red highlightRow" ><div class="highlightText whiteFont" title="Assigned non-communicating vehicles" id="assignedTop" onclick="onColumnClick(8,true,'')"></div></div>
                             </div>
                           </div>
                        </div>
            </div>
            <div class="row" style="width:100%;" id="box2">
                          <div class="col-lg-12 card">
                            <div class="row" style="height:55%;border-bottom:1px solid #ECEFF1;">
                               <div class="col-lg-12">
                                 <div class="centerText" style="padding-top:24px;" title="UnAssigned vehicles" id="unassigned" onclick="onColumnClick(16,false,'')"></div>
                                   <div class="headerText blueGrey"><span style="margin-left:-16px;">Unassigned</span></div>
                                   <div class="red highlightRow"><div class="highlightText whiteFont" title="UnAssigned non-communicating vehicles" id="unassignedTop" onclick="onColumnClick(16,true,'')"></div></div>
                               </div>
                               </div>
                             <div class="row" style="height:45%;">
                                <div class="col-lg-6 blueGreyLight">
                                  <div class="row" style="height:100%;">
                                     <div class="col-lg-12">
                                       <div class="red highlightRowLeft" ><div class="highlightText whiteFont" title="UnAssigned moving non-communicating vehicles" id="movingTop" onclick="onColumnClick(16,true,'moving')"></div></div>
                                       <div class="centerText" style="padding-top:24px;left:3%" id="moving" title="UnAssigned moving vehicles" onclick="onColumnClick(16,false,'moving')"><div style="font-size:12px;">Moving</div></div>

                                     </div>
                                   </div>
                                </div>
                                <div class="col-lg-6 ">
                                  <div class="row" style="height:100%;">
                                     <div class="col-lg-12">
                                       <div class="centerText" style="padding-top:24px;left:53%" id="halted" title="UnAssigned halted vehicles" onclick="onColumnClick(16,false,'halted')"><div style="font-size:12px;">Halted</div></div>
                                         <div class="red highlightRow" style="width:45% !important;" ><div class="highlightText whiteFont" title="UnAssigned halted non-communicating vehicles" onclick="onColumnClick(16,true,'halted')" id="haltedTop"></div></div>

                                     </div>

                                   </div>
                                </div>
                              </div>

                          </div>
              </div>
            <div class="row" style="width:100%;" id="box3">
                          <div class="col-lg-12 card">
                            <div class="row" style="height:100%;">
                               <div class="col-lg-12">
                                 <div class="centerText" style="padding-top:24px;" title="Under maintenance vehicles" id="undermaintenance" onclick="onColumnClick(4,false,'')"></div>
                                   <div class="headerText blueGrey" ><span style="margin-left:-16px;">Under Maintenance</span></div>
                                   <div class="red highlightRow" ><div class="highlightText whiteFont" title="Under maintenance non-communicating vehicles" id="undermaintenanceTop" onclick="onColumnClick(4,true,'')"></div></div>
                               </div>
                             </div>
                          </div>
              </div>
        </div>
        <div class="col-lg-10" id="midColumn">
           <div class="tabs-container blueGrey" style="color:white;">
                  <ul class="nav nav-tabs">
                     <li><a href="#mapViewId" data-toggle="tab" active style="margin:0px;border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;"><i class="fas fa-globe"></i></a></li>
                     <li><a href="#listViewId" onclick="$('#tableDiv').css('visibility','hidden');loadTable(custName, routeId, tripStatus);" data-toggle="tab" style="border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;margin:0px"><i class="far fa-list-alt"></i></a></li>
                    <!-- <li class="dropdown">
                          <a class="dropdown-toggle" style="margin:0px;height:32px;padding-top:4px;" data-toggle="dropdown" href="#">Legend
                          <span class="caret"></span></a>
                             <ul class ="dropdown-menu" style="padding:8px;margin-top:4px;width:250px;">
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/ontime.svg"> On Time</li>
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/enroute.svg"> EnRoute Placement</li>
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/delayed1hr.svg"> Delayed < 1 hr </li>
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/delayed1hr2.svg"> Delayed > 1 hr </li>
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/EnroutePlacement.svg"> Loading Detention</li>
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/detention.svg"> UnLoading Detention</li>
                                 <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/Pink.svg"> Delayed - Late Departure</li>
                             </ul>
                     </li>
                     <li><a href="#settingsViewId" data-toggle="tab" style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">Page Settings</a></li>-->

                  </ul>
                  <a onclick="fullscreen()" data-toggle="tab" style="margin:0px;height:32px;padding-top:4px;border-radius:0px;position:absolute; right:36px;top:1px;cursor:pointer;"><i class="fas fa-arrows-alt"></i></a>

               </div>
               <div class="tab-content" id="tabs">
                  <div class="tab-pane" id="mapViewId">
                     <div class="col-md-12" style="margin-bottom:32px;">
                        <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
                        <div id="legend"><h3>LEGEND</h3></div>
                     </div>
                  </div>
                  <div class="tab-pane" style="border:none;" id="listViewId" >
                    <div class="center-view" style="display:none;" id="loading-div">
                      <img src="../../Main/images/loading.gif" alt="">
                    </div>
                    <div id="tableDiv">
                  <table id="tripSumaryTable"  class="table table-striped table-bordered" cellspacing="0">
                        <thead style="background:#37474F;color:white;">
                           <tr>
                             <th>Serial Number</th>
                             <th>Comm Status</th>
                             <th>Distance</th>
                             <th>Driver Name</th>
                             <th>Driver Number</th>
                             <th>LR No.</th>
                             <th>Reg. No.</th>
                             <th>Shipment</th>
                             <th>Tamper Count</th>
                             <th>Location Name</th>
                             <th>Unassigned Age(DD:HH:MM)</th>
                             </tr>
                        </thead>
                     </table>
                   </div>
                  </div>
                  <div class="tab-pane" id="settingsViewId">
                     <div class="col-lg-12" style="margin-bottom:32px;">
                       <input type="checkbox" id="box1check" onChange="checkBox('box1')" name="box1check" value="box1check" checked> Box 1<br>
                       <input type="checkbox" id="box2check" onChange="checkBox('box2')" name="box2check" value="box2check" checked> Box 2<br>
                       <input type="checkbox" id="box3check" onChange="checkBox('box3')" name="box3check" value="box3check" checked> Box 3<br>
                       <input type="checkbox" id="box4check" onChange="checkBox('box4')" name="box4check" value="box4check" checked> Box 4<br>
                       <input type="checkbox" id="box5check" onChange="checkBox('box5')" name="box5check" value="box5check" checked> Box 5<br>
                       <input type="checkbox" id="box6check" onChange="checkBox('box6')" name="box6check" value="box6check" checked> Box 6<br>
                     </div>
                  </div>
               </div>
        </div>

      </div>








      <div  class="">
         <div id="add" class="modal-content modal fade">
            <div class="modal-header" >
               <div>
                  <button type="button" class="close" style="align:right;"data-dismiss="modal">&times;</button>
               </div>
               <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
               </div>
            </div>
            <div class="modal-body" style="height: 100%; overflow-y: auto;">
               <div class="row">
                  <div class="col-lg-12">
                     <div class="col-lg-12" style="border: solid  1px lightgray;">
                        <table id="alertEventsTable"  class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                           <thead>
                              <tr>
                                 <th>Sl No</th>
                                 <th>Vehicle No</th>
                                 <th>Location</th>
                                 <th>Date</th>
                                 <th>Remarks</th>
                                 <th>Action Taken</th>
                              </tr>
                           </thead>
                        </table>
                     </div>
                  </div>
               </div>
            </div>
            <div class="modal-footer"  style="text-align: right; height:52px;" >
               <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
            </div>
         </div>
      </div>

<!-- <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN"> -->
<script src='<%=GoogleApiKey%>'></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>

var status = 0;
var noncommveh = false;
var unassignedVehtype = "";

$.ajax({
     type: "POST",
     url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehicleCountJson',
     success: function(result) {
       var data = JSON.parse(result).CountIndex[0];
       console.log("data", data);
       $("#assigned").text(data.AsignedTotalCount);
       $("#assignedTop").text(data.AsignedNonCommCount);
       $("#unassigned").text(data.UnAsignedTotalCount);
       $("#unassignedTop").text(data.UnAsignedNonCommCount);
       $("#moving").prepend(data.moving);
       $("#movingTop").text(data.movingNonComm);
       $("#halted").prepend(data.halted);
       $("#haltedTop").text(data.haltedNonComm);
       $("#undermaintenance").text(data.MTotalCount);
       $("#undermaintenanceTop").text(data.MNonCommCount);
 }
 });


      var map;
    var boxLeft = 3;
    var boxRight = 3;
    var mcOptions = {
        gridSize: 20,
        maxZoom: 100
    };
    var markerClusterArray = [];
    var markerClusterArray1 = [];
    var animate = "true";
    var bounds = new google.maps.LatLngBounds();
    var infowindow;
    var infowindowOne;
    var mainPowerCount = 0;
    var panicCount = 0;
    var hbCount = 0;
    var haCount = 0;
    var restrictiveCount = 0;
    var engineErrorCount = 0;
    var mapNew;
    var tripNo;
    var vehicleNo;
    var startDate;
    var lineInfo = [];
    var infoWindows = [];
    var groupId;
    var table;
    var endDatehid;
    var countryName = '<%=countryName%>';
    var $mpContainer = $('#map');
    var custName = "ALL";
    var routeId = "ALL";
    var tripStatus = "";
    var flag = false;
    var toggle = "hide";

    $( document ).ready(function() {
        $("#map").css("height", $(window).height()-172);
        var heightVal = ($("#map").height())/2.75;
        $("#box1").css("height",heightVal );
        $("#box2").css("height",heightVal );
        $("#box3").css("height",heightVal );
        $("#columnContainer").css("height", $(window).height()-172);
    });

    function fullscreen()
    {

      if(toggle == "hide")
      {
        toggle = "show";
        $( "#leftColumn" ).hide();
        $( "#rightColumn" ).hide();
        $( "#leftColumn" ).removeClass("col-lg-2");
        $( "#rightColumn" ).removeClass("col-lg-2");
        $( "#midColumn" ).removeClass("col-lg-8").addClass("col-lg-12");
    }
      else {
        toggle = "hide";
        $( "#midColumn" ).removeClass("col-lg-12").addClass("col-lg-8");
        $( "#leftColumn" ).addClass("col-lg-2");
        setTimeout(function(){$( "#leftColumn" ).fadeIn();$( "#rightColumn" ).addClass("col-lg-2");$( "#rightColumn" ).fadeIn();},600);
      }

    }



    $( document ).ready(function() {
      // $('.w3card').css('height', $(window).height()/3.9);
    });

    function checkBox(val){
      if ($("#" + val + "check").is(':checked')) {
        $("#" + val).show();
        if(val == "box1" || val == "box2" || val == "box3" ){
        boxLeft++;} else {boxRight++;}
      }
      else {
        $("#" + val).hide();
        if(val == "box1" || val == "box2" || val == "box3" ){
        boxLeft--;} else {boxRight--;}
      }
      checkBoxValueReCheck();
    }

    function checkBoxValueReCheck()
    {
      if(boxLeft > 0 && boxRight == 0)
      {
        $("#leftColumn").addClass("col-lg-2");
        $("#midColumn").removeClass("col-lg-8").removeClass("col-lg-12").addClass("col-lg-10");
      }
      if(boxRight > 0 && boxLeft == 0)
      {
        $("#rightColumn").addClass("col-lg-2");
        $("#midColumn").removeClass("col-lg-8").removeClass("col-lg-12").addClass("col-lg-10");
      }
      if(boxRight > 0 && boxLeft > 0)
      {
        $("#leftColumn").addClass("col-lg-2");
        $("#rightColumn").addClass("col-lg-2");
        $("#midColumn").removeClass("col-lg-12").removeClass("col-lg-10").addClass("col-lg-8");
      }
      checkBoxValue();

    }


    function boxLeftValChange(val)
    {
      $("#" + val).hide();
      $("#" + val + "check").prop('checked', false);
      boxLeft--;
      checkBoxValue();
    }

    function boxRightValChange(val)
    {
      $("#" + val).hide();
      $("#" + val + "check").prop('checked', false);
      boxRight--;
      checkBoxValue();
    }

    function checkBoxValue(){
        if(boxLeft == 0)
        {
          $("#leftColumn").removeClass("col-lg-2");
          $("#midColumn").removeClass("col-lg-8").addClass("col-lg-10");
        }
        if(boxRight == 0)
        {
          $("#rightColumn").removeClass("col-lg-2");
          $("#midColumn").removeClass("col-lg-8").addClass("col-lg-10");
        }
        if(boxRight == 0 && boxLeft == 0)
        {
          $("#midColumn").removeClass("col-lg-10").addClass("col-lg-12");
        }


    }

    function ResetData(){
        custName = "ALL";
        routeId = "ALL";
        tripStatus = "";
        loadData(custName, routeId);
        loadMap(custName, routeId, tripStatus);
        loadTable(custName, routeId, tripStatus);
        getRouteNames(routeId);
        getCustNames(custName);
    }

    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
    activaTab('mapViewId');
    loadData(custName, routeId);

    function loadData(custName, routeId) {

    }
    // ************* Map Details
    function initialize() {
        var mapOptions = {
            zoom: 4.6,
            center: new google.maps.LatLng(<%=latitudeLongitude%>), //23.524681, 77.810561),,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
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

        };
        map = new google.maps.Map(document.getElementById('map'), mapOptions);
      //map.fitBounds(bounds);
        var trafficLayer = new google.maps.TrafficLayer();
        trafficLayer.setMap(map);

        var geocoder = new google.maps.Geocoder();

        geocoder.geocode( {'address' : countryName}, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                map.setCenter(results[0].geometry.location);
            }
        });
    }
    initialize();
    var markerCluster;
    function loadMap(custName, routeId, tripStatus) {
        $.ajax({
          url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehiclesMapDetails',
             data: {
                   statusId: status,
               },
            "dataSrc": "MapViewIndex",
            success: function(result) {
                var bounds = new google.maps.LatLngBounds();

                results = JSON.parse(result);
                  console.log("Map",results);
                var count = 0;
                markerClusterArray.length=0;
                if (markerCluster) {
                    markerCluster.clearMarkers();
                }
                var iconBase = "/ApplicationImages/VehicleImages/";
                var icons = {
                          0: {
                            name: 'On Time',
                            icon: iconBase + 'ontime.svg'
                          },
                          1: {
                            name: 'EnRoute Placement',
                            icon: iconBase + 'enroute.svg'
                          },
                          2: {
                            name: 'Delayed < 1hr',
                            icon: iconBase + 'tempdelayed1.png'
                          },
                          3: {
                            name: 'Delayed > 1hr',
                            icon: iconBase + 'tempdelayed2.svg'
                          },
                          4: {
                            name: 'Loading Detention',
                            icon: iconBase + 'EnroutePlacement.svg'
                          },
                          5: {
                            name: 'Unloading Detention',
                            icon: iconBase + 'detention.svg'
                          },
                          6: {
                            name: 'Delayed - Late Departure',
                            icon: iconBase + 'tempPink.svg'
                          }
                        };

                        var legend = document.getElementById('legend');
                        for (var key in icons) {
                          var type = icons[key];
                          var name = type.name;
                          var icon = type.icon;
                          var div = document.createElement('div');
                          div.innerHTML = '<img src="' + icon + '"> ' + name;
                          legend.appendChild(div);
                        }

                        map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
                for (var i = 0; i < results["MapViewIndex"].length; i++) {
                    if (!results["MapViewIndex"][i].lat == 0 && !results["MapViewIndex"][i].lon == 0) {
                        count++;
                        let plot = true;
                        if(noncommveh){
                          if(results["MapViewIndex"][i].CommStatus != "NON COMMUNICATING"){
                            plot = false;
                          }
                        }
                        if(unassignedVehtype=="moving")
                        {
                          if(results["MapViewIndex"][i].movingStatus != "Moved"){
                            plot = false;
                          }
                        }
                        if(unassignedVehtype=="halted")
                        {
                          if(results["MapViewIndex"][i].movingStatus != "Halted"){
                            plot = false;
                          }
                        }
                        if(plot) {
                          plotSingleVehicle(results["MapViewIndex"][i].vehicleNo, results["MapViewIndex"][i].lat, results["MapViewIndex"][i].lon,
                            results["MapViewIndex"][i].location, results["MapViewIndex"][i].gmt,
                            results["MapViewIndex"][i].tripStatus, results["MapViewIndex"][i].custName, results["MapViewIndex"][i].shipmentId,
                            results["MapViewIndex"][i].delay, results["MapViewIndex"][i].weather, results["MapViewIndex"][i].driverName,
                            results["MapViewIndex"][i].etaDest, results["MapViewIndex"][i].etaNextPt, results["MapViewIndex"][i].routeIdHidden,
                            results["MapViewIndex"][i].ATD, results["MapViewIndex"][i].status, results["MapViewIndex"][i].tripId,
                            results["MapViewIndex"][i].endDateHidden,results["MapViewIndex"][i].STD,results["MapViewIndex"][i].T1,
                            results["MapViewIndex"][i].T2,results["MapViewIndex"][i].T3,results["MapViewIndex"][i].productLine,results["MapViewIndex"][i].Humidity,results["MapViewIndex"][i].tripNo,
                            results["MapViewIndex"][i].routeName,results["MapViewIndex"][i].currentStoppageTime,results["MapViewIndex"][i].currentIdlingTime,
                            results["MapViewIndex"][i].speed,results["MapViewIndex"][i].LRNO);
                        var mylatLong = new google.maps.LatLng(results["MapViewIndex"][i].lat, results["MapViewIndex"][i].lon);
                      }
                    }
                }
                markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
            }
        });
    }
    loadMap(custName, routeId, tripStatus);

    function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, tripStatus, custName, shipmentId, delay, weather,
     driverName, etaDest, etaNextPt,routeId,ATD,status,tripId,endDate,startDate,T1,T2,T3,productLine,Humidity,tripNo,routeName,currentStoppageTime,currentIdlingTime,speed,LRNO) {
        var tempContent='';
        var humidityContent='';
        var Humidity;
 if(productLine != 'Chiller' && productLine != 'Freezer' && productLine != 'TCL')        
   //     if(productLine != 'TCL')
        {
        	T1='NA';
        	T2='NA';
        	T3='NA';
        	Humidity = 'NA';
        }
        if(T1!='NA'){
            tempContent='<tr><td><b>T @ reefer(°C):</b></td><td>' +  T1 + '</td></tr>'
         }if(T2!='NA'){
            tempContent=tempContent+'<tr><td><b>T @ middle(°C):</b></td><td>' +  T2 + '</td></tr>'
         }if(T3!='NA'){
            tempContent=tempContent+'<tr><td><b>T @ door(°C):</b></td><td>' +  T3 + '</td></tr>'
         }
         if(Humidity==''){
            Humidity='NA';
         }

         if(T1=='NA' || T2=='NA' || T3=='NA'){
            humidityContent='';
         }else{
            humidityContent=humidityContent+'<tr><td><b>Humidity:</b></td><td>' + Humidity + '</td></tr>' ;
         }
        // alert(tripStatus);

        var imageurl;
        if (tripStatus == 'ENROUTE PLACEMENT ON TIME' || tripStatus == 'ENROUTE PLACEMENT DELAYED') {
            imageurl = '/ApplicationImages/VehicleImages/enroute.svg';
        }
        if (tripStatus == 'ON TIME') {
            imageurl = '/ApplicationImages/VehicleImages/ontime.svg';
        }
        if (tripStatus == 'DELAYED' && delay < 60) {
            imageurl = '/ApplicationImages/VehicleImages/delayed1hr.svg';
        }
        if (tripStatus == 'DELAYED' && delay > 60) {
            imageurl = '/ApplicationImages/VehicleImages/delayed1hr2.svg';
        }
        if (tripStatus == 'LOADING DETENTION') {
            imageurl = '/ApplicationImages/VehicleImages/EnroutePlacement.svg';
        }
        if (tripStatus == 'UNLOADING DETENTION') {
            imageurl = '/ApplicationImages/VehicleImages/detention.svg';
        }
        if (tripStatus == 'DELAYED LATE DEPARTURE') {

            imageurl = '/ApplicationImages/VehicleImages/Pink.svg';
        }

        if (tempContent!='' && (tripStatus == 'ENROUTE PLACEMENT ON TIME' || tripStatus == 'ENROUTE PLACEMENT DELAYED')) {
           imageurl = '/ApplicationImages/VehicleImages/tempenroute.svg';
        }
        if (tempContent!='' && tripStatus == 'ON TIME') {
            imageurl = '/ApplicationImages/VehicleImages/tempontime.svg';
        }
        if (tempContent!='' && tripStatus == 'DELAYED' && delay < 60) {
            imageurl = '/ApplicationImages/VehicleImages/tempdelayed1.svg';
        }
        if (tempContent!='' && tripStatus == 'DELAYED' && delay > 60) {
            imageurl = '/ApplicationImages/VehicleImages/tempdelayed2.svg';
        }
        if (tempContent!='' && tripStatus == 'LOADING DETENTION') {
           imageurl = '/ApplicationImages/VehicleImages/temploading.svg';
        }
        if (tempContent!='' && tripStatus == 'UNLOADING DETENTION') {
            imageurl = '/ApplicationImages/VehicleImages/tempunloading.svg';
        }
		if (tempContent!='' && tripStatus == 'DELAYED LATE DEPARTURE') {
            imageurl = '/ApplicationImages/VehicleImages/tempPink.svg';
        }
        image = {
            url: String(imageurl), // This marker is 20 pixels wide by 32 pixels tall.
            scaledSize: new google.maps.Size(20, 40), // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
            anchor: new google.maps.Point(0, 32)
        };
        var pos = new google.maps.LatLng(latitude, longtitude);
        var marker = new google.maps.Marker({
            position: pos,
            map: map,
            icon: image
        });

        markerClusterArray.push(marker);
        var coordinate=latitude+','+longtitude;


        // alert(shipmentId);
        var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; height: 100%; float: left; color: #000; line-height:100%; font-size:11px; font-family: sans-serif;padding:4px;">' +
            '<table class="infoDiv">' +
            '<tr><td nowrap><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
            '<tr><td nowrap><b>Trip No:</b></td><td>' + tripNo + '</td></tr>' +
            '<tr><td nowrap><b>LR No:</b></td><td>' + LRNO + '</td></tr>' +
            '<tr><td nowrap><b>Route Name:</b></td><td>' + routeName + '</td></tr>' +
            '<tr><td nowrap><b>Location:</b></td><td>' + location.replace(/,/g, "<br/>") + '</td></tr>' +
            '<tr><td nowrap><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
            '<tr><td nowrap><b>Customer :</b></td><td>' + custName + '</td></tr>' +
            '<tr><td nowrap><b>Delay:</b></td><td>' + convertMinutesToHHMM(delay) + '</td></tr>' +
            '<tr><td nowrap><b>weather:</b></td><td>' + weather + '</td></tr>' +
            '<tr><td nowrap><b>Driver Name:</b></td><td>' + driverName + '</td></tr>' +
            '<tr><td nowrap><b>Next Hub ETA:</b></td><td>' + etaNextPt + '</td></tr>' +
            '<tr><td nowrap><b>Dest ETA:</b></td><td>' + etaDest + '</td></tr>' +
            '<tr><td nowrap><b>LatLong:</b></td><td>' + coordinate.replace(",","<br/>") + '</td></tr>' +
            '<tr><td nowrap><b>Curr Stoppage:&nbsp;&nbsp;</b></td><td>' + currentStoppageTime + ' (HH.mm)</td></tr>' +
            '<tr><td nowrap><b>Curr Idling:</b></td><td>' + currentIdlingTime + ' (HH.mm)</td></tr>' +
            '<tr><td nowrap><b>Speed(km/h):</b></td><td>' + speed + '</td></tr>' +
            tempContent +
            humidityContent+
            '</table>' +
            '</div>';
        contentOne = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff;font-size:11px; font-family: sans-serif;">' +
            '<table>' +
            '<tr><td></td><td>' + vehicleNo + '</td></tr>' +
            '</table>' +
            '</div>';

        infowindow = new google.maps.InfoWindow({
            content: content,
            marker: marker,
            maxWidth: 300,
            id: vehicleNo
        });

        infowindowOne = new google.maps.InfoWindow({
            contents: contentOne,
            marker: marker,
            maxWidth: 200,
            id: vehicleNo
        });

        google.maps.event.addListener(marker, 'click', (function(marker, contents, infowindow) {
            return function() {
                firstLoadDetails = 1;
                infowindow.setContent(content);
                infowindow.open(map, marker);
            };
        })(marker, content, infowindow));

        /*google.maps.event.addListener(marker, 'mouseout', (function(marker, contents, infowindow) {
            return function() {

                infowindow.close();
            };
        })(marker, content, infowindow));*/

        var parameterStr="tripNo=" + tripId + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + ATD + "&routeId=" + routeId;

      /*  google.maps.event.addListener(marker, 'dblclick', (function(marker, parameterStr) {
            return function() {
                window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?"+parameterStr, '_blank');
            };
        })(marker, parameterStr));*/

        google.maps.event.addListener(infowindow, 'closeclick', function() {

        });
        infowindowOne.setContent(contentOne);

        if (animate == "true") {
            marker.setAnimation(google.maps.Animation.DROP);
        }
        if (location != 'No GPS Device Connected') {
            bounds.extend(pos);
        }

    }

    // ************ Table for Trip Summary
    $('#groupName').change(function() {
        groupId = $('#groupName option:selected').attr('id');
        routeId = $('#route_names option:selected').val();
        custName = $('#cust_names option:selected').val();
        loadTable(custName, routeId, tripStatus);
    });
    var table;
    //loadTable(custName, routeId, tripStatus);

    function onColumnClick(statusValue,topValue,unassignedVehtypeValue){
         //Global Variable set
         status = statusValue;
         noncommveh = topValue;
         unassignedVehtype = unassignedVehtypeValue;
         loadMap(custName, routeId, tripStatus);
         loadTable(custName, routeId, tripStatus);
    }

    function loadTable(custName, routeId, tripStatus) {
      $('#loading-div').show();
      $.ajax({
           type: "POST",
           url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehiclesDetails',
               data: {
                     statusId: status,
                 },success: function(result) {
                   result = JSON.parse(result).ListViewIndex;
                   console.log("Table", result);
                   let rows = [];
                   let rowCounter = 1;
                   $.each(result, function(i, item) {
                       let row = {
                         "0":rowCounter,
                         "1":item.CommStatus,
                         "2":item.Distance,
                         "3":item.DriverName,
                         "4":item.DriverNumber,
                         "5":item.Lrno,
                         "6":item.RegNO,
                         "7":item.ShipMent,
                         "8":item.TamperCount,
                         "9":item.locationName,
                         "10":item.unassignedTime
                       }
                       let push = true;
                       if(noncommveh){
                         if(item.CommStatus != "NON COMMUNICATING"){
                           push = false;
                         }
                       }
                       if(unassignedVehtype=="moving")
                       {
                         if(item.movingStatus != "Moved"){
                           push = false;
                         }
                       }
                       if(unassignedVehtype=="halted")
                       {
                         if(item.movingStatus != "Halted"){
                           push = false;
                         }
                       }
                       if(push) {
                         rows.push(row);
                         rowCounter++;
                       }
                     });
                     if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
                       $('#tripSumaryTable').DataTable().clear().destroy();
                     }

                     table = $('#tripSumaryTable').DataTable({
                       "scrollY": "372px",
                       "scrollX": true,
                       paging : false,
                       "oLanguage": {
                           "sEmptyTable": "No data available"
                       },
                       dom: 'Bfrtip',
                       buttons:[{
                                  extend: 'excel',
                                  text:       'Export to Excel',
                                  class: "btn btn-primary",
                                  title: 'SLA dashboard Trip Details',
                                  customData: function (exceldata) {
                                              exportExtension = 'Excel';
                                              return exceldata;
                                  }
                                 }]
                     });
                     table.rows.add(rows).draw();
                     $('#loading-div').hide();
                     $('#tableDiv').css('visibility','');

       }
       });
    }
    setInterval(function() {
        //loadMap(custName, routeId, tripStatus);
        //loadData(custName, routeId);
        //loadTable(custName, routeId, tripStatus);
    }, 60000);

     $('#tripSumaryTable tbody').on('click', 'td.details-control', function () {
	       var tr = $(this).closest('tr');
	       var row = table.row( tr );
	       if ( row.child.isShown() ) {
	           tr.removeClass( 'details' );
	           row.child.hide();
	           tr.removeClass('shown');
	       }
	       else {
	           tr.addClass( 'details' );
	           row.child( format(row.data()) ).show();
	           tr.addClass('shown');
	       }
	   } );

    var tableNew;


    function Acknowledge(uniqueId) {
        swal({
                title: "",
                text: "Enter Remarks:",
                type: "input",
                showCancelButton: true,
                closeOnConfirm: false,
                animation: "slide-from-top",
                inputPlaceholder: "Enter Remarks"
            },
            function(inputValue) {
                if (inputValue === "") {
                    swal.showInputError("Enter Remarks!");
                    return false;
                } else if(inputValue === true) {

                }else if(typeof(inputValue)=="string"){
                    $.ajax({
                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateRemarks',
                        data: {
                            uniqueId: uniqueId,
                            remarks: inputValue
                        },
                        success: function(result) {
                               sweetAlert(result);
                                tableNew.ajax.reload();
                        }
                    })
                }
            },
            function() {
            })
    }
    function loadAjax(){
        loadTable(custName, routeId, tripStatus);
    }
    function format ( d ) {

    var tbody="";
    var a;

    if(d.legdetails.length>0)
    {
            for(var i=0;i<d.legdetails.length;i++)
            {
            var row="";
            row += '<tr>'
                row += '<td>'+d.legdetails[i].LegName+'</td>';
                row += '<td>'+d.legdetails[i].Driver1+'</td>';
                row += '<td>'+d.legdetails[i].Driver2+'</td>';
                row += '<td>'+d.legdetails[i].STD+'</td>';
                row += '<td>'+d.legdetails[i].STA+'</td>';
                row += '<td>'+d.legdetails[i].ATD+'</td>';
                row += '<td>'+d.legdetails[i].ATA+'</td>';
                row += '<td>'+d.legdetails[i].TotalDistance+'</td>';
                row += '<td>'+d.legdetails[i].AvgSpeed+'</td>';
                row += '<td>'+d.legdetails[i].FuelConsumed+'</td>';
                row += '<td>'+d.legdetails[i].Mileage+'</td>';
                row += '<td>'+d.legdetails[i].OBDMileage+'</td>';
                row += '<td>'+d.legdetails[i].TravelDuration+'</td>';
                row += '<td>'+d.legdetails[i].ETA+'</td>';

                row += '</tr>';
                //objTo.appendChild(row);
                tbody+=row;
            }
            a = '<div style="overflow-x:auto;width:29%">'+
                '<table class="table table-bordered" >'+
                ' <thead>'+
                '<tr ">'+
                                           '<th>Leg Name</th>'+
                                           '<th>Driver 1</th>'+
                                           '<th>Driver 2</th>'+
                                           '<th>STD</th>'+
                                           '<th>STA</th>'+
                                           '<th>ATD</th>'+
                                           '<th>ATA</th>'+
                                           '<th>Total Distance (km)</th>'+
                                           '<th>Average Speed (kmph)</th>'+
                                           '<th>Fuel Consumed</th>'+
                                           '<th>Mileage</th>'+
                                           '<th>OBD Mileage</th>'+
                                           '<th>Travel Duration (HH:mm)</th>'+
                                           '<th>ETA</th>'+

                '</tr>'+
                '</thead>' +
                '<tbody id="tbodyId">'+tbody+'</tbody>'+
            '</table>'+
            '</div>';
   }
   else
   {
            var row="";
            row += '<tr>'
                row += '<td colspan="14"><b>No Records Found for Trip Id: '+d.ShipmentId+'</b></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '</tr>';
                tbody+=row;

        a = '<div style="overflow-x:auto;width:31%">'+
        '<table  cellpadding="5" cellspacing="0" border="0">'+
        ' <thead>'+
        '</thead>'+
        '<tbody id="tbodyId">'+tbody+'</tbody>'+
    '</table>'+
    '</div>';
   }
   return a;
}

function showTripAndAlertDetails()
{

}
 $('#tripSumaryTable tbody').on('click', 'td', function() {
     var data = table.row(this).data();
     var columnIndex = table.cell(this).index().column;
     tripNo = (data['tripNo']);
     vehicleNo = (data['vehicleNo']);
     startDate = (data['STD']);
     endDate = (data['endDateHidden']);
     actualDate = (data['ATD']);
     status = (data['status']);
     routeId = (data['routeIdHidden']);

     if (columnIndex==2) {
         window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId
         , '_blank');
     }
     event.preventDefault();
 });

  $('#legbtn').click(function() {
		$.ajax({
			url : '<%=request.getContextPath()%>/LegDetailsExportAction.do?param=createLegExcel',
			//type:"POST",
			data : {
					groupId: groupId,
                    unit: '<%=unit%>',
                    custName: custName,
                    routeId: routeId,
                    status: tripStatus
			},
			success : function(responseText) {
				//$('#ajaxGetUserServletResponse').text(responseText);
				alert(responseText);
				//window.location="<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText;
				window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText);
			}
		});
	});
</script>

  <jsp:include page="../Common/footer.jsp" />
