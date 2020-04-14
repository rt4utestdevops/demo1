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
    MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
	String mapName = bean.getMapName();
	String appKey = bean.getAPIKey();
	String appCode = bean.getAppCode();
%>
<!--<jsp:include page="../Common/header.jsp" />-->
<jsp:include page="../Common/InitializeLeaflet.jsp" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
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
	  
	  <link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
      <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	  <script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	  <script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	  <script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	  <script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	  <link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
	  <script src="../../Main/leaflet/leaflet.measure.js"></script>
		<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
	  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
	  crossorigin=""></script>
	  
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

         .modal {
            position: fixed;
            top: 7%;
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
            top: 7%;
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
            border-radius:4px;
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
  width:240px !important;
}

.blueGreyDark {
  /* background: #ECEFF1; */
  background: #37474F;
}

.pointer{
  cursor: pointer;
}

.leaflet-popup-content{
    width: auto;
    height: auto;
}

      </style>

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>


      <!-- content -->
      <div class="row" id="columnContainer">
        <div class="col-lg-2" id="leftColumn">
          <div class="row" style="width:100%;" id="box1">
                        <div class="col-lg-12 card">
                          <div class="row" style="height:60%;">
                             <div class="col-lg-12">
                                 <div class="headerText blueGrey"><i class="fas fa-truck" style="margin-left:24px;"></i><span style="margin-left:12px;">Vehicle Status</span></div>
                                 <ul class="list-group" style="border-bottom:0px !important;margin-bottom:0px;">
                                   <li class="list-group-item">
                                     <div class="col-lg-8" style="padding:4px;">Available</div>
                                     <div class="col-lg-4 pointer" id="available"></div>
                                   </li>
                                   <li class="list-group-item" style="background:#ECEFF1;">
                                     <div class="col-lg-8">Enroute Placement</div>
                                     <div class="col-lg-4 pointer" id="enroute"></div>
                                   </li>
                                   <li class="list-group-item">
                                     <div class="col-lg-8">On Trip</div>
                                     <div class="col-lg-4 pointer" id="onTrip"></div>
                                   </li>
                                   <li class="list-group-item" style="background:#ECEFF1;">
                                     <div class="col-lg-8">Waiting for Loading</div>
                                     <div class="col-lg-4 pointer" id="waiting"></div>
                                   </li>
                                   <li class="list-group-item">
                                     <div class="col-lg-8">Not Ready for Loading</div>
                                     <div class="col-lg-4 pointer" id="notReady"></div>
                                   </li>
                                 </ul>


                             </div>
                           </div>
                        </div>
            </div>
            <div class="row" style="width:100%;" id="box2">
                          <div class="col-lg-12 card" style="margin-top:15%;">
                            <div class="row" style="height:35%;">
                               <div class="col-lg-12">
                                    <div class="headerText blueGrey"><i class="fas fa-exclamation-triangle" style="margin-left:24px;"></i><span style="margin-left:12px;">Vehicle Alerts</span></div>
                                    <ul class="list-group" style="border-bottom:0px !important;margin-bottom:0px;">
                                      <li class="list-group-item">
                                        <div class="col-lg-8">Temperature Alert</div>
                                        <div class="col-lg-4 pointer" id="temperatureAlert" onclick="temperatureAlertOnClick()"></div>
                                      </li>
                                      <li class="list-group-item" style="background:#ECEFF1;">
                                        <div class="col-lg-8">Not Communicating</div>
                                        <div class="col-lg-4" id="nonComm"></div>
                                      </li>
                                    </ul>
                                 </div>
                               </div>

                          </div>
              </div>

        </div>
        <div class="col-lg-10" id="midColumn">
           <div class="row" style="margin-bottom:8px;">
             <div class="col-md-4" style="padding:0px;">
                 <select id="vehicleNoDropDownId" name="selectCriteriaVehicle"></select>
             </div>

             <div class="col-md-8" style="text-align:right;">
               <button id="btnCreateTrip" class="btn btn-generate btn-md  btn-primary" style="background:#92D050;width:180px;height:32px;border:0px;" onClick="btnCreateTrip()">Create Trip</button>
               <button id="btnModifyTrip" class="btn btn-generate btn-md btn-primary" style="display:none;background:#FFC000;width:180px;height:32px;border:0px;" onClick="btnModifyTrip()">Modify Trip</button>
               <button id="btnCloseTrip" class="btn btn-generate btn-md btn-primary" style="display:none;background:#C00000;width:180px;height:32px;border:0px;" onClick="btnCloseTrip()">Close Trip</button>

             </div>
           </div>
           <div class="tabs-container blueGrey" style="color:white;">
                  <ul class="nav nav-tabs">
                     <li><a href="#mapViewId" data-toggle="tab" active style="margin:0px;border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;"><i class="fas fa-globe"></i></a></li>
                     <%-- <li><a href="#listViewId" onclick="$('#tableDiv').css('visibility','hidden');loadTable(custName, routeId, tripStatus);" data-toggle="tab" style="border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;margin:0px"><i class="far fa-list-alt"></i></a></li> --%>
                  </ul>                  <a onclick="fullscreen()" data-toggle="tab" style="margin:0px;height:32px;padding-top:4px;border-radius:0px;position:absolute; right:36px;top:42px;cursor:pointer;"><i class="fas fa-arrows-alt"></i></a>

               </div>
               <div class="tab-content" id="tabs">
                  <div class="tab-pane" id="mapViewId">
                     <div class="col-md-12" style="margin-bottom:32px;">
                        <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>

                     </div>
                  </div>
                  <div class="tab-pane" style="border:none;" id="listViewId" >

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








      <div id="add" class="modal fade">
             <div class="row blueGreyDark" style="width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
               <div  class="col-md-6">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;color:white;">Acknowledge Temperature Alerts</h4>
               </div>
                <div class="col-md-6" style="text-align:right;padding-right:24px;">
                   <button type="button" class="close" style="align:right;cursor:pointer;color:white;" data-dismiss="modal">&times;</button>
                </div>
             </div>
             <div class="modal-body" style="margin-top:8px;height: 100%; overflow-y: hidden;padding:0px;">
                <div class="row">
                      <div class="col-lg-12" >
                         <table id="alertEventsTable"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                            <thead>
                               <tr>
                                <th>Sl No</th>
                                <th>VehicleNo</th>
								<th>ShipmentId</th>
								<th>Datetime</th>
								<th>Updated Date</th>
								<th>Updated By</th>
                                <th>Remarks</th>
                                <th>Acknowledge</th>
                               </tr>
                            </thead>
                         </table>
                      </div>

                </div>
             </div><br/>
             <!--<div class="modal-footer"  style="text-align: right; height:52px;" >
                <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
             </div>-->
          </div>



<!--<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg&region=IN">-->
<!--</script>-->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>

var status = 0;
var noncommveh = false;
var unassignedVehtype = "";
var data;

getSATDashBoardCounts();

function getSATDashBoardCounts()
{
          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getSATDashBoardCounts',
             "dataSrc": "vehicleCounts",
             success: function(result) {
               console.log(result)
              data =  JSON.parse(result);

               $("#available").html(data["vehicleCounts"][0].available);
               $("#enroute").html(data["vehicleCounts"][0].enroute);
               $("#onTrip").html(data["vehicleCounts"][0].onTrip);
               $("#waiting").html(data["vehicleCounts"][0].waitingForLoading);
               $("#notReady").html(data["vehicleCounts"][0].notReadyForLoading);
               $("#temperatureAlert").html(data["vehicleCounts"][0].tempAlert);
               $("#nonComm").html(data["vehicleCounts"][0].nonCommVehicles);

         }
         });
       }


      var map;
      var info;
    var boxLeft = 3;
    var boxRight = 3;
    var mcOptions = {
        gridSize: 20,
        maxZoom: 100
    };
    var markerClusterArray = [];
    var markerClusterArray1 = [];
    var animate = "true";
    var bounds = new L.LatLngBounds();
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
    var tripStatus = "ALL";
    var flag = false;
    var toggle = "hide";
    var tripStat = "All";

    $( document ).ready(function() {
        $("#map").css("height", $(window).height()-200);
        var heightVal = ($("#map").height())/1.8;
        // $("#box1").css("height",heightVal );
        // $("#box2").css("height",heightVal );
        $("#columnContainer").css("height", $(window).height()-200);

    $.ajax({
        url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getVehicleNo',
          success: function(result) {
                   vehicleList = JSON.parse(result);
                   	            for (var i = 0; i < vehicleList["VehicleNoRoot"].length; i++) {
                    $('#vehicleNoDropDownId').append($("<option></option>").attr("value", vehicleList["VehicleNoRoot"][i].VehicleNo).text(vehicleList["VehicleNoRoot"][i].VehicleNo));
	            }
	            $('#vehicleNoDropDownId').select2();
		}
	})
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
        $( "#midColumn" ).removeClass("col-lg-8 paddingLeft16").addClass("col-lg-12");
    }
      else {
        toggle = "hide";
        $( "#midColumn" ).removeClass("col-lg-12").addClass("col-lg-8 paddingLeft16");
        $( "#leftColumn" ).addClass("col-lg-2");
        setTimeout(function(){$( "#leftColumn" ).fadeIn();$( "#rightColumn" ).addClass("col-lg-2");$( "#rightColumn" ).fadeIn();},600);
      }

    }



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
      //  routeId = "ALL";
        tripStatus = "ALL";
        loadData(custName, routeId);
        loadMap(custName, tripStatus);
        loadTable(custName, routeId, tripStatus);
        getRouteNames(routeId);
        getCustNames(custName);
    }

    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
    activaTab('mapViewId');

    // ************* Map Details
    var buffer_circle = null;

    function initialize() {
    var here = L.tileLayer("https://1.base.maps.cit.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=" + '<%=appKey%>' + "&app_code=" + '<%=appCode%>', {
        styleId: 997
    })
    var osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    });

    map = new L.Map("map", {
        fullscreenControl: {
            pseudoFullscreen: false
        },
        tms: true,
        center: new L.LatLng(<%=latitudeLongitude%>),
        zoom: 4
    });
    var baseMaps = {};
    if ('<%=mapName%>' == 'HERE') {
        baseMaps["HERE"] = here;
        baseMaps["OSM"] = osm;
    } else {
        baseMaps["OSM"] = osm;
    }
    var overlayMaps = {};
    L.control.layers(baseMaps).addTo(map);
    if ('<%=mapName%>' == 'HERE') {
        baseMaps["HERE"].addTo(map);
    } else {
        baseMaps["OSM"].addTo(map);
    }
    setTimeout(function(){map.invalidateSize();},250);
}
   /* function btnGo()
    {
      buffer_circle = new L.Circle({
          center: {lat: 19.076000213623047, lng: 72.87770080566406},
          radius: 7000,
          strokeColor: "",
          strokeOpacity: 0.0,
          strokeWeight: 2,
          fillColor: "#FFD700",
          fillOpacity: 0.5,
        });
     // map.setCenter({lat: 19.076000213623047, lng: 72.87770080566406});
    // map.setZoom(12);
    }*/

    function btnCreateTrip()
    {
		window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/SemiAutoTripCreation.jsp","_self");
    }

    function btnModifyTrip()
    {

    }

    function btnCloseTrip()
    {

    }
    initialize();
    var markerCluster;
    var truckJSON = null;

    $('#vehicleNoDropDownId').on('select2:select', function (e) {
		 var truck = null;
       for (var i = 0; i < markerClusterArray.length; i++ ) {
             map.removeLayer(markerClusterArray[i]);
        }
        markerClusterArray.length = 0;
        markerClusterArray=[];
        
        if (markerCluster) {
			map.removeLayer(markerCluster);
		 }

		if(e.params.data.id ==='-- ALL --'){
		
			loadMap(custName,tripStatus);
		}
		else{
       
        console.log("Truck JSON", truckJSON)
        for (var i = 0; i < truckJSON.length; i++) {
            if((truckJSON[i].vehicleNo).trim() == e.params.data.id){
              truck = truckJSON[i];
            
              plotSingleVehicle(truck.vehicleNo, truck.lat, truck.lon,
          		truck.location, truck.driverName,
           		truck.temperature,true);
            }
         }
         
	}
         

         // Add a marker clusterer to manage the markers.
         /*if(markerCluster != null)
         {
           markerCluster.clearMarkers();
         }*/
      
        /* markerCluster = new MarkerClusterer(map, markerClusterArray,
              {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});*/
             ///markerCluster = L.markerClusterGroup();
    });
    

//Hi Shipla, the status is being sent in the json below. you can use results["MapViewIndex"][i].status to specify the colour of the vehicle images.
//Shikha was asking to change the icons of the vehicles so please have a word with her on the icons.
    function loadMap(custName,tripStatus) {
        $.ajax({
          url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getVehiclesMapDetails',
             data: {
                   statusId: tripStatus,
               },
            "dataSrc": "MapViewIndex",
            success: function(result) {

                var bounds = new L.LatLngBounds();


                results = JSON.parse(result);
                  console.log("Map",results);
                truckJSON = results["MapViewIndex"];
                var count = 0;
               // markerClusterArray.length=0;
                /*if (markerCluster) {
                    markerCluster.clearMarkers();
                }*/
                 if (markerCluster) {
			 map.removeLayer(markerCluster);
		    }
               markerCluster = L.markerClusterGroup();
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
                            results["MapViewIndex"][i].location, results["MapViewIndex"][i].driverName,
                            results["MapViewIndex"][i].temperature,false);
                        var mylatLong = new L.LatLng(results["MapViewIndex"][i].lat, results["MapViewIndex"][i].lon);
                      }
                    }
                }
               // markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
               map.addLayer(markerCluster);
            }
        });
    }
    loadMap(custName, tripStatus);

    function plotSingleVehicle(vehicleNo, latitude, longtitude, location, driverName, temperature,isSinglePlot) {
        var tempContent='';
        var humidityContent='';
        var Humidity;

        var imageurl = '/ApplicationImages/VehicleImages/delivery-van-green.png';

        if(tripStat == "available")
        {
          imageurl = '/ApplicationImages/VehicleImages/delivery-van-blue.png';
        }
        if(tripStat == "enroute")
        {
          imageurl = '/ApplicationImages/VehicleImages/delivery-van-lightblue.png';
        }
        if(tripStat == "waiting")
        {
          imageurl = '/ApplicationImages/VehicleImages/delivery-van-orange.png';
        }
        if(tripStat == "notReady")
        {
          imageurl = '/ApplicationImages/VehicleImages/delivery-van-red.png';
        }
        if(tripStat == "onTrip")
        {
          imageurl = '/ApplicationImages/VehicleImages/delivery-van-green.png';
        }

        var image = L.icon({
        iconUrl: imageurl,
        iconSize: [40, 40], // size of the icon
        popupAnchor: [0, 32]
       // labelOrigin:[16,0]
    });
     
        var pos = new L.LatLng(latitude, longtitude);	
         marker = new L.Marker(pos, {
        icon: image
    });	
    marker.bindTooltip(temperature + " C",{permanent:true})
      
        
        var coordinate=latitude+','+longtitude;
     

        // alert(shipmentId);
        var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; color: #000; line-height:100%; font-size:11px; font-family: sans-serif;padding:4px;">' +
            '<table class="infoDiv">' +
            '<tr><td nowrap><b>Vehicle No:&nbsp;&nbsp;</b></td><td>' + vehicleNo + '</td></tr>' +
            '<tr><td nowrap><b>Driver Name:&nbsp;&nbsp;</b></td><td>' + driverName + '</td></tr>' +
            '<tr><td nowrap><b>Curr Location:&nbsp;&nbsp;</b></td><td>' + location + '</td></tr>' +
            '<tr><td nowrap><b>Temperature:&nbsp;&nbsp;</b></td><td>' + temperature + ' &deg; C</td></tr>' +
            '</table>' +
            '</div>';
     
     
	marker.bindPopup(content);    
	if (isSinglePlot){
		marker.addTo(map);
	}
    markerCluster.addLayer(marker);
    markerClusterArray.push(marker);

    if (animate == "true") {
            //marker.setAnimation(google.maps.Animation.DROP);
        }
        if (location != 'No GPS Device Connected') {
            //bounds.extend(pos);
            map.setView(pos,4);
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
         loadMap(custName,  tripStatus);
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
                         "9":item.locationName
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
        loadMap(custName, tripStatus);
        getSATDashBoardCounts();
        //loadData(custName, routeId);
        //loadTable(custName, routeId, tripStatus);
    }, 300000);

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

    function temperatureAlertOnClick(){
          $('#loading-div').show();
          $('#add').modal('show');

          $.ajax({
               type: "GET",
               url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getTempAlertDetails',
               success: function(results) {
                 var result = JSON.parse(results).tempAlertRoot;
                 let rows = [];
                let rowCounter = 1;
                $.each(result, function(i, item) {
                      var ack = "";
                      var remarks = "";
                      if(item.remarks == "" || item.remarks == null)
                      {
                        ack = "<button id='btn"+item.id+"'  class='green' onClick='Acknowledge("+item.id+")'>Acknowledge</button>";
<!--                        remarks = "<div id='div"+item.id+"'><input style='width:300px;' id='txt"+item.id+"' type='text'/></div>";-->
						remarks = item.remarks;
                      }
                      else {
                        remarks = item.remarks;
                      }

                   let row = {
                        "0":rowCounter,
<!--                        "2":item.tripNo,-->
                        "1":item.vehicleNo,
                        "2":item.shipmentId,
                        "3":item.alertDatetime,
                        "4":item.updatedDate,
                        "5":item.updatedBy,
                        "6":remarks,
                        "7":ack

                    }
                    rows.push(row);
                    rowCounter++;
                  })

                  if ($.fn.DataTable.isDataTable("#alertEventsTable")) {
                    $('#alertEventsTable').DataTable().clear().destroy();
                  }
                  table = $('#alertEventsTable').DataTable({

                    "scrollY": "300px",
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
                  setTimeout(function() {
                    table.rows.add(rows).draw();
                    $('#loading-div').hide();
                  }, 2000);

                //  $('#loading-div').hide();

               }
       })

    }

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
                                temperatureAlertOnClick();
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

		$("#available").on("click", function(){ loadMap("2", "available"); tripStat = "available";  map.setZoom(5);});
		$("#enroute").on("click", function(){ loadMap("2", "enroute");tripStat = "enroute"; map.setZoom(5);});
		$("#waiting").on("click", function(){ loadMap("2", "waiting");tripStat = "waiting"; map.setZoom(5);});
		$("#notReady").on("click", function(){ loadMap("2","notReady"); tripStat = "notReady";map.setZoom(5);});
		$("#onTrip").on("click", function(){ loadMap("2", "onTrip");tripStat = "onTrip"; map.setZoom(5);});

</script>

  <jsp:include page="../Common/footer.jsp" />
